require 'active_support/all'
require 'nokogiri'
require 'yaml'
require 'age_in_words'

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
    include AgeInWords

    attr_accessor :xml_str, :xml_doc

    class << self
      attr_accessor :spec, :time_zone
    end

    # default time zone for time display, set this using class attr_accessor
    # like:
    #   Nemsis::Parser.time_zone = 'Central Time (US & Canada)'
    @@time_zone = 'Eastern Time (US & Canada)'

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
    def parse(element_spec, return_data_type='string')
      raise ArgumentError.new('parse(element_spec) requires spec Hash argument') if element_spec.nil?
      element_spec = get_spec(element_spec) unless element_spec.class == Hash

      return_data_type.downcase!
      return_data_type = 'string' unless ['string', 'object', 'raw'].include?(return_data_type)

      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath) or return

        if element_spec['is_multi_entry'].to_i.eql?(1)
          values = []
          nodes.each do |node|
            case return_data_type
            when 'string' then values << get_str(element_spec, node)
            when 'object' then values << get_obj(element_spec, node)
            when 'raw'    then values << get_raw(element_spec, node)
            end
          end
          return values.size > 1 ? values : values.first
        else
          node = nodes.first or return
          case return_data_type
          when 'string' then value = get_str(element_spec, node)
          when 'object' then value = get_obj(element_spec, node)
          when 'raw'    then value = get_raw(element_spec, node)
          end

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

      if element_spec.nil?
        # warn "Requested Info from: '#{element}', but it is null :-("
        return ""
      end

      results = parse(element_spec)

      results.is_a?(Array) ? results.first : results
    end

    def age_in_words
      dob = self.E06_16
      unless dob.blank?
        age = get_age_in_words(Date.parse(dob))
      else
        age = "#{self.E06_14} #{self.E06_15}"
      end
      age = "Age Unavailable" if age.blank?
      age
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
                            select {|v| (v['name']) =~ /^#{field_name}$/i}.
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
      return [] if e15_clusters.nil? or e15_clusters.empty?
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

    # This is typically used to support the following syntax:
    #    @parser.E08_07
    # But we can also allow other embedded calls like:
    #    concat('E20_10', 'E20_14')
    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        Array(parse(get_spec(method_sym.to_s))).join(', ') rescue ''
      elsif respond_to?((/(\w+)/.match(method_sym.to_s))[0])
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

    private

    def get_str(element_spec, node)
      obj = get_obj(element_spec, node)

      case 
      when obj.class.to_s =~ /time/i
        case element_spec['data_type']
        when /^date\/time$/i
          str = obj.in_time_zone(@@time_zone).strftime("%Y-%m-%d %H:%M") rescue nil
        when /^time$/i
          str = obj.in_time_zone(@@time_zone).strftime("%H:%M") rescue nil
        end
      when obj.class.to_s =~ /date/i
          str = obj.strftime("%Y-%m-%d") rescue nil
      else
        str = obj.to_s
      end

      str
    end

    def get_obj(element_spec, node)
      raw_value = get_raw(element_spec, node)

      # Note: data_type possible values are
      # ["text", "combo", "date/time", "number", "date", "time", "combo or text", "binary"]
      case
      when element_spec['data_type'] =~ /(text|combo|combo or text)/i
        obj = raw_value 

        if !element_spec['field_values'].nil?
          # map numeric key to string value
          key = raw_value

          if key.to_i.to_s == key.to_s   # key must be numeric
            
            # Blank out "Not Recorded" raw_values
            element_spec['field_values'].merge!(
                -10 => '', # Not Known
                -15 => '', # Not Reporting
                -20 => '', # Not Recorded
                -25 => '', # Not Applicable
                -5  => ''  # Not Available
            )

            key = key.to_i
            mapped_value = element_spec['field_values'][key]

            case mapped_value
            when true  then obj = 'Yes'
            when false then obj = 'No'
            else            obj = mapped_value unless mapped_value.nil?
            end
          end
        end
      when element_spec['data_type'] =~ /time/i
        obj = ActiveSupport::TimeZone.new('UTC').parse(raw_value) rescue nil
      when element_spec['data_type'] =~ /^date$/i
        obj = Date.parse(raw_value) rescue nil
      when element_spec['data_type'] =~ /number/i
        f      = sprintf("%.1e", raw_value).to_f
        i      = f.to_i
        obj  = (i == f ? i : f)
      end

      obj
    end

    def get_raw(element_spec, node)
      node.text
    end
  end
end
