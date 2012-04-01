require 'nokogiri'
require 'yaml'

# NEMSIS (http://www.nemsis.org) is a standard used by EMS agencies to describe the data that they collect in the field.
# Loosely, it is broken up as follows:
# The core elements
#
#   * Demographic Dataset ('Dxx')
#   * EMS Dataset ('Exx')
#     * Section E00 -- Common EMS Values
#     * Section E06 -- Patient
#       * E06_01_0 --Patient Name Structure
#         * E06_01 -- Last Name, String
#         * E06_02 -- First Name, String
#         * E06_03 -- Middle, String
#       * E06_04_0 -- Patient Address Structure
#         * E06_04 -- Address, String
#         * E06_05 -- City, String
#         * E06_06 -- County, String
#         * E06_07 -- State, String
#         * E06_08 -- Zip, String
#       * E06_09 -- Country, String
#     * Multi-Entry Section -- E04 (aka, a Repeating Structure)
#        <E04>
#          <E04_02>585</E04_02>
#          <E04_03>-20</ E04_03>
#          <E04_04>TECH SUPPORT</E04_04>
#          <E04_05>ESO</ E04_05>
#        </E04>
#        <E04>
#          <E04_01>P038756</ E04_01>
#          <E04_02>580</E04_02>
#          <E04_03>6110</ E04_03>
#          <E04_04>ADAMS</E04_04>
#          <E04_05>CHRISTOPHER</ E04_05>
#        </E04>
#
# An Element is described by the YAML spec entry. Of special note are the following aspects:
#   * node (E06_01)-- this is how you can find it
#   * data type -- text, date, time, date/time, number, combo (single-choice, multiple-choice)
#     * For date/time, you can control the default value returned to be just a date or just a time
#     * Combo uses the data_entry_method to determine if multiple choice is allowed (returning a concatenated string of answers)
#   * field_values -- these are the table look-up entries for combo types (an index yields the text string)
#     * For negative indexes, no value is returned.
#
# Here is how to use the more common aspects of this API to access NEMSIS elements:
#
#   * Section -- E06 (Used to group related elements)
#     * get_children('E06') will retrieve all of the elements
#         * as an array of key/value hashes for repeated sections
#         * as a hash for each element in the single section
#     * parse_cluster('E06') will retrieve an array of parser objects that can then be queried
#     * has_content('E34') will indicate if data exists in the section (handy way to control section visibility)
#   * Structure -- E06_04_0 (Used to group related elements)
#     * Element -- E06_09 (Can be a single entry or multiple choice)
#       * @parser.E06_09 will return the default value(s)
#       * parse_date('E24_01') will return the default date/time format
#       * parse_time('E24_01') will return the default time format
#       * name('E06_02') will return the element's name as defined in the spec file
#       * has_content('E06_02') will indicate if data exists
#
# See the accompanying rspecs for more details
#
module Nemsis
  class Parser
    attr_accessor :xml_str, :xml_doc

    class << self
      attr_accessor :spec
    end

    ###
    # Create a parser by passing in a well-formed XML string and an optional NEMSIS specification yml string.
    def initialize(xml_str, spec_yaml_str=nil)
      raise ArgumentError.new('Parser initiation requires XML String argument') if xml_str.nil? or xml_str.size == 0
      if spec_yaml_str.nil? or spec_yaml_str.empty?
        @@spec = YAML::load(File.read(File.expand_path('../../../conf/nemsis_spec.yml', __FILE__)))
      else
        @@spec = YAML::load(spec_yaml_str)
      end
      self.xml_str = xml_str
      self.xml_doc = Nokogiri::XML(xml_str)
      xml_doc.remove_namespaces!
    end

    ###
    # This method is mostly invoked by other, more user-friendly call.
    # If you pass in a normal string, it will attempt to lookup a spec hash.
    def parse(element_spec)
      raise ArgumentError.new('parse(element_spec) requires spec Hash argument') if element_spec.nil?
      element_spec = get_spec(element_spec) unless element_spec.class == Hash

      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath) or return

        #puts element_spec.inspect if ["E23_08", "E29_03", "E24_01"].include?(element_spec["node"])

        multi_entry = element_spec['is_multi_entry']
        if multi_entry
          values = []
          nodes.each do |node|
            values << get_value(element_spec, node)
          end
          return values.size > 1 ? values : values.first
        else
          node = nodes.first or return
          value = get_value(element_spec, node)
          return value
        end

      rescue => err
        puts "Error: parsing xpath [#{xpath}] for '#{element_spec}': #{err}"
      end
    end

    ###
    # Return the spec hash for the individual element node name
    # element_spec = get_spec('E06_01')
    def get_spec(node)
      @@spec[node]
    end

    ###
    # Return a node name for the given element, ensuring that it exists
    def get_node_name(element)
      element_spec = get_spec(element)
      if element_spec
        element_spec['node']
      else
        nil
      end
    end

    ###
    # Return the index into the lookup table
    # Example:
    #   p.index('E24_05').should == "500003"
    def index(element)
      text = ''

      begin
        nodes = xml_doc.xpath("//#{get_node_name(element)}") or return -99
        text = nodes.first.text if nodes.size > 0
      rescue => err
        puts "Error: parsing xpath [#{xpath}] #{err}"
      end

      text
    end

    ###
    # Return the name of the element (from the YML spec)
    # Example:
    #    p.name('E06_01').should == "LAST NAME"
    def name(element)
      get(element)[:name]
    end

    ###
    # Return the value(s) for the given element
    # Example
    #   patient_last_name = p.parse_element('E06_01')
    def parse_element(element)
      element_spec = get_spec(element)

      warn "NOTICE: '#{element}' is null!!" if element_spec.nil?
      results = parse(element_spec)

      results.is_a?(Array) ? results.first : results
    end

    def parse_time(element, full=false)
      time_str = parse_element(element)

      if full
        Time.parse(time_str).strftime("%Y-%m-%d %H:%M") rescue nil
      else
        Time.parse(time_str).strftime("%H:%M") rescue nil
      end
    end

    def parse_date(element, full=true)
      date_str = parse_element(element)

      if full
        Time.parse(date_str).strftime("%Y-%m-%d") rescue nil
      else
        Time.parse(date_str).strftime("%m-%d") rescue nil
      end
    end

    def parse_state(element)
      state_code = parse_element(element)

      state_codes = {"42" => "PA", "01" => "AL", "02" => "AK", "04" => "AZ", "05" => "AR", "06" => "CA", "08" => "CO", "09" => "CT", "10" => "DE", "11" => "DC", "12" => "FL", "13" => "GA", "15" => "HI", "16" => "ID", "17" => "IL", "18" => "IN", "19" => "IA", "20" => "KS", "21" => "KY", "22" => "LA", "23" => "ME", "24" => "MD", "25" => "MA", "26" => "MI", "27" => "MN", "28" => "MS", "29" => "MO", "30" => "MT", "31" => "NE", "32" => "NV", "33" => "NH", "34" => "NJ", "35" => "NM", "36" => "NY", "37" => "NC", "38" => "ND", "39" => "OH", "40" => "OK", "41" => "OR", "44" => "RI", "45" => "SC", "46" => "SD", "47" => "TN", "48" => "TX", "49" => "UT", "50" => "VT", "51" => "VA", "53" => "WA", "54" => "WV", "55" => "WI", "56" => "WY", "60" => "AS", "66" => "GU", "69" => "MP", "72" => "PR", "74" => "UM", "78" => "VI"}

      state_codes[state_code] || state_code
    end

    ###
    # This is a dangerous method, as there could be multiple fields with the same name (like Last Name)
    def parse_field(field_name)
      element_spec = @@spec.values.
          select { |v| (v['name']) =~ /^#{field_name}$/i }.
          first
      self.send(element_spec['node'])
    end

    ###
    # Niche method for HTML generation
    def parse_pair(name_element, value_element)
      name_element_spec = get_spec(name_element)
      names             = parse(name_element_spec)

      value_element_spec = get_spec(value_element)
      values             = parse(value_element_spec)

      result = {}
      begin
        names.size.times { |i| result[names[i]] = values[i] }
      rescue => err
        warn err
      end

      result
    end

    def parse_value_of(key)
      parse_pair('E23_11', 'E23_09')[key] rescue nil
    end

    ###
    # Returns an array of parser objects that can then be used for parsing individual fields
    # Use for repeated sections, to build your own info, one record at a time.
    def parse_cluster(element)
      xpath    = "//#{element}"
      nodes    = xml_doc.xpath(xpath)
      #puts "cluster count: #{nodes.count}" if element == 'E04'

      clusters = []
      begin
        nodes.each do |node|
          cluster = Nemsis::Parser.new(node.to_s)
          clusters << cluster
        end
      rescue => err
        puts "Error: parsing xpath [#{xpath}]: #{err}"
      end

      clusters
    end

    ###
    # ???
    def parse_clusters(*cluster_elements)
      results = []
      cluster_elements.each do |element|
        results = results + parse_cluster(element)
      end

      results
    end

    ###
    # Niche method for HTML generation
    def parse_assessments
      # Assessments elements are E15 and E16.  There would be just one E15 and
      # many E16 elements.  Sort E16 element clusters by time E16_03, and the
      # first one would be Initial Assessment.  The single E15 element is always
      # part of the initial assessment, so it will need to be combined with the
      # earliest E16.
      e15_clusters           = parse_cluster('E15')
      e15_initial_assessment = e15_clusters.shift

      e16_clusters           = parse_clusters('E16')
      e16_clusters           = e16_clusters.sort_by { |c| Time.parse(c.sub_element('03')) rescue Time.now }
      e16_initial_assessment = e16_clusters.shift

      initial_assessment_node = Nokogiri::XML::Node.new("E15_E16", xml_doc)
      initial_assessment_node.add_child e15_initial_assessment.xml_doc.root
      initial_assessment_node.add_child e16_initial_assessment.xml_doc.root

      initial_assessment = Nemsis::Parser.new(initial_assessment_node.to_s)

      assessments = [initial_assessment, e16_clusters].flatten

      assessments
    end

    def root_element_name
      xml_doc.root.name
    end

    def sub_element(element_suffix)
      parse_element("#{root_element_name}_#{element_suffix}")
    end

    ###
    # Return the concatenated results of supplied elements
    def concat(*elements)
      elements.map do |elem|
        parse_element(elem)
      end.compact.join(' ')
    end

    ###
    # Return a hash representing the field and its value
    def get(element)
      element_spec = get_spec(element)
      return {} if element_spec.nil?
      {:name => element_spec["name"], :value => parse_element(element)}
    end

    ###
    # This returns an array of key-value pairs for each element group. Each array item has the list of fields.
    # The possible fields are based on the yml spec entries (not on the data itself).
    def get_children(element)
      results = []
      return children if element.nil? or element.empty?

      matching_spec_elements = @@spec.to_a.select { |v| v[0].upcase.index(element.upcase) == 0 }
      element_keys = matching_spec_elements.map { |s| s[0] }
      #puts "Expect to find: #{element_keys}"

      begin
        xpath = "//#{element}"
        nodes = xml_doc.xpath(xpath)
        #puts "cluster count: #{nodes.count}" if element == 'E04'

        nodes.each do |node|
          children = {}
          p = Nemsis::Parser.new(node.to_s)
          element_keys.each do |key|
            value = p.parse_element(key)
            value ||= ''
            #puts "\t#{key}: '#{value}'"
            children[key] = value
          end
          results << children
        end
      rescue => err
        puts "Error in get_children(): xpath [#{xpath}]: #{err}"
      end

      results
    end

    # The primary intent of this method is to enable a quick check to see if a section of the HTML should
    # be rendered (if has_content == true) or hidden.
    # Constraint: It expects D01 or E01 format. F100 will not work.
    def has_content(*elements)
      data_exists = false
      elements.each do |element|
        #puts "Checking #{element}"
        # Check for the case of a class of elements; i.e., E32
        if element.upcase =~ /^[D|E]\d\d$/
          nodes = xml_doc.xpath("//#{element}")
          # Maybe I don't get it, but this seems like an arduous way to use Nokogiri -- jon
          nodes.each do |node|
            node.children.each do |child|
              next unless child.is_a?(Nokogiri::XML::Element)
              value = child.children
              unless value.nil? or value.empty?
                #puts "    Found: #{child.name} = #{value}"
                data_exists = true
                break
              end
            end
          end
        else
          value = parse_element(element)
          unless value.nil? or value.empty?
            #puts "    Found: #{value}"
            data_exists = true
            break
          end
        end
      end
      data_exists
    end

    # Return a string
    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        Array(parse(get_spec(method_sym.to_s))).join(', ') rescue ''
      elsif method_sym.to_s =~ /^concat/
        instance_eval(method_sym.to_s) rescue ''
      else
        super
      end
    end

    def respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        true
      else
        super
      end
    end

    def get_value(element_spec, node)
      value = node.text

      # Note: data_type possible values are
      # ["text", "combo", "date/time", "number", "date", "time", "combo or text", "binary"]
      if element_spec['data_type'] =~ /(text|combo|combo or text)/i &&
          value =~ /^-?\d+$/ &&
          !element_spec['field_values'].nil?

        # Blank out "Not Recorded" values
        element_spec['field_values'].merge!(
            -10 => '', # Not Known
            -15 => '', # Not Reporting
            -20 => '', # Not Recorded
            -25 => '', # Not Applicable
            -5  => '' # Not Available
        )
        #if ["E23_08", "E29_03", "E24_01"].include?(element_spec["node"])
        #  puts " [S] Lookup #{value.to_i} in #{element_spec["node"]} values: #{element_spec['field_values'].inspect}"
        #end
        mapped_value = element_spec['field_values'][value.to_i]
        case mapped_value
          when false
            mapped_value = 'No'
          when true
            mapped_value = 'Yes'
        end

        value = mapped_value unless mapped_value.nil?
      elsif element_spec['data_type'] =~ /date\/time/i
        value = Time.parse(value).strftime("%Y-%m-%d %H:%M") rescue nil
      elsif element_spec['data_type'] =~ /date/i
        value = Time.parse(value).strftime("%Y-%m-%d") rescue nil
      elsif element_spec['data_type'] =~ /time/i
        value = Time.parse(value).strftime("%H:%M") rescue nil
      elsif element_spec['data_type'] =~ /number/i
        f      = sprintf("%.1e", value).to_f
        i      = f.to_i
        value  = (i == f ? i : f)
      end

      value
    end
  end
end
