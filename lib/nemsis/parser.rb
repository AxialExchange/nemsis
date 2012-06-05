require File.expand_path(File.dirname(__FILE__) + '/code_lookup.rb')
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
    include CodeLookup
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
      raise ArgumentError.new('Parser initiation requires XML String argument') if xml_str.nil? or xml_str.empty?
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
    # This method is mostly invoked by other, more user-friendly calls.
    # If you pass in a normal string, it will attempt to lookup a spec hash.
    # return_data_type can be the following
    #   * string
    #   * object
    #   * raw
    # Typically, for field lookups, the negative indexes values are not returned.
    # You can override this behavior by setting <tt>filter_negative_fields</tt> to false
    def parse(element, return_data_type='string', filter_negative_fields=true)
      raise ArgumentError.new('parse(element) requires element name or spec (Hash) argument') if element.nil?

      element_spec = nil
      case
      when element.is_a?(Hash)
        element_spec = element
      else
        element_spec = get_spec(element)
      end

      return if element_spec.nil?

      return_data_type.downcase!
      return_data_type = 'string' unless ['string', 'object', 'raw'].include?(return_data_type)

      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath)

        if element_spec['is_multi_entry'].to_i.eql?(1)
          values = []
          nodes.each do |node|
            case return_data_type
            when 'string' then values << get_str(element_spec, node)
            when 'object' then values << get_obj(element_spec, node, filter_negative_fields)
            when 'raw'    then values << get_raw(element_spec, node)
            end
          end if nodes
          return values.size > 1 ? values : values.first
        else
          value = ""
          node = nodes && nodes.first or nil
          case return_data_type
          when 'string' then value = get_str(element_spec, node)
          when 'object' then value = get_obj(element_spec, node, filter_negative_fields)
          when 'raw'    then value = get_raw(element_spec, node)
          end if node
          return value
        end
      rescue Nokogiri::XML::XPath::SyntaxError => err
        puts "Element [#{xpath}] Syntax Error: #{err}"
      rescue Exception => err
        puts "Element [#{xpath}] unknown parsing error: #{err}"
      end
    end

    ###
    # Return the spec hash for the individual element node name
    # element_spec = get_spec('E06_01')
    def get_spec(node)
      spec = @@spec[node]
      if spec.nil?
        # raise "Unknown node [#{node}], add to conf/nemsis_spec.yml?"
        # puts "Unknown node [#{node}], add to conf/nemsis_spec.yml?"
      end
      spec
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
        return "&nbsp;"
      end

      results = parse(element_spec, 'string')

      results.is_a?(Array) ? results.first : results
    end

    def parse_element_no_filter(element)
      parse(element, 'object', false)
    end

    def age_in_words
      dob = self.E06_16
      unless dob.blank?
        age = get_age_in_words(Date.parse(dob))
      else
        age = "#{self.E06_14} #{self.E06_15}"
      end
      age = "Age Unavailable" if age.strip.blank?
      age
    end

    def weight_in_words
      wt = self.E16_01.to_f # in kg
      wt_in_lbs = wt*2.20462262
      "%s lbs - %d kg" % [((wt_in_lbs < 100) ? wt_in_lbs.round(1) : wt_in_lbs.round), wt]
    end

    def parse_time(element, full=false)
      time_str = parse_element(element)
      text = ""
      if full
        text = Time.parse(time_str).strftime("%Y-%m-%d %H:%M") rescue nil
      else
        text = Time.parse(time_str).strftime("%H:%M") rescue nil
      end
      text = '&nbsp;' if text.nil? || text.strip.blank?
      text
    end

    def parse_date(element, full=true)
      date_str = parse_element(element)
      text = ""

      if full
        text = Time.parse(date_str).strftime("%Y-%m-%d") rescue nil
      else
        text = Time.parse(date_str).strftime("%m-%d") rescue nil
      end
      text = '&nbsp;' if text.nil? || text.strip.blank?
      text
    end

    # Look up the city/state/county text based on codes
    # return the value, a not found message, or a nbsp;
    def lookup_address_element(type, code)
      string = "Nemsis::CodeLookup::#{type.upcase}_CODES"
      lookup_table = string.constantize
      value = lookup_table[code] || "#{type.titleize} not found for #{code}"
      value = '&nbsp;' if value == "#{type.titleize} not found for "
      value
    end

    def parse_state(element)
      lookup_address_element 'state', parse_element(element)
    end

    def parse_city(element)
      lookup_address_element 'city', parse_element(element)
    end


    def parse_county(element)
      lookup_address_element 'county', parse_element(element)
    end

    ###
    # TODO: This is a dangerous method, as there could be multiple fields with the same name (like Last Name)
    def parse_field(field_name)
      element_spec = @@spec.values.
                            select {|v| (v['name']) =~ /^#{field_name}$/i}.
                            first
      self.send(element_spec['node'])
    end

    ###
    # Niche method for HTML generation. Pull out name/value pairs from specific data elements.
    def parse_pair(name_element, value_element)
      result = {}
      begin
        name_element_spec = get_spec(name_element)
        names             = parse(name_element_spec)

        value_element_spec = get_spec(value_element)
        values             = parse(value_element_spec)

        names.size.times { |i| result[names[i]] = values[i] } unless names.nil? or values.nil?
      rescue ArgumentError => err
        # warn "Warn: in parse_pair: #{err}"
      end

      result
    end

    # This is a bizarre technique to pull certain "key" fields from the bunch of  stuff
    # that ESO throws into the E23_09_0 pairs of attributes with apparent abandon!
    # For example, given this data:
    #      <E23_09_0>
    #        <E23_09>Trauma</E23_09>
    #        <E23_11>MedicalTrauma</E23_11>
    #      </E23_09_0>
    # It would be looked up as follows:
    #    parse_value_of('MedicalTrauma')
    # I'm not kidding. Seriously.
    def parse_value_of(key)
      text = parse_pair('E23_11', 'E23_09')[key]
      #puts "parse pair: '#{text.inspect}' #{(text.nil? || text.blank?) ? 'BLANK' : ''}"
      text = '&nbsp;' if text.nil? || text.strip.blank?
      text
    end

    ###
    # Returns an array of parser objects that can then be used for parsing individual fields
    # Use for repeated sections, to build your own info, one record at a time.
    def parse_cluster(element)
      xpath    = "//#{element}"
      nodes    = xml_doc.xpath("//#{element}")
      #puts "cluster count: #{nodes.count}" if element == 'E19_01_0'

      clusters = []
      begin
        nodes.each do |node|
          cluster = Nemsis::Parser.new(node.to_s)
          clusters << cluster
        end
      # rescue => err
      #   warn "Warn: parsing xpath [#{xpath}]: #{err}"
      end

      clusters
    end

    ###
    # This gets all of the data for one or more element "roots"
    def parse_clusters(*cluster_elements)
      results = []
      cluster_elements.each do |element|
        results += parse_cluster(element)
      end

      results
    end

    ###
    # Niche method for HTML generation of assessment section
    def parse_assessments
      # Assessments elements are E15 and E16.  There would be just one E15 and
      # many E16 elements.  Sort E16 element clusters by time E16_03, and the
      # first one would be Initial Assessment.  The single E15 element is always
      # part of the initial assessment, so it will need to be combined with the
      # earliest E16.
      e15_clusters           = parse_cluster('E15')
      e15_initial_assessment = e15_clusters.shift if e15_clusters

      e16_clusters           = parse_clusters('E16_00_0')
      if e16_clusters
        e16_clusters           = e16_clusters.sort_by { |c| Time.parse(c.sub_element('03')) rescue Time.now }
        e16_initial_assessment = e16_clusters.shift
      end

      initial_assessment_node = Nokogiri::XML::Node.new("E15_E16", xml_doc)
      initial_assessment_node.add_child e15_initial_assessment.xml_doc.root if e15_initial_assessment
      initial_assessment_node.add_child e16_initial_assessment.xml_doc.root if e16_initial_assessment

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
      concat_with(elements, ' ')
    end

    def concat_with_comma(*elements)
      concat_with(elements, ', ')
    end

    def concat_with(elements, separator=' ')
      values = []

      elements.map do |elem|
        # value = parse_element(elem)
        element_values = Array(parse(elem))

        element_values.each do |value|
          if !value.nil?
            value.strip! 
            values << value unless value.empty?
          end
        end
      end

      values.flatten!
      values.compact!
      values.uniq!

      valid_values = values.reject {|v| v =~ /^\s*Not\s*(Done|Assessed)\s*$/i}
      values = valid_values unless valid_values.empty?
      
      values = values.join(separator)
      values
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

      i = 0
      until data_exists || i >= elements.size do
        xpath = "//#{elements[i]}"
        i += 1
        xml_doc.xpath(xpath).each do |node|
          data_exists = true if node.content =~ /\w/ &&
              node.content.gsub(/(\r|\n)/, ' ') !~ /^-\d{1,2}$/
        end
      end

      data_exists
    end

    # This is typically used to support the following syntax:
    #    @parser.E08_07
    # But we can also allow other embedded calls like:
    #    concat('E20_10', 'E20_14')
    def method_missing(method_sym, *arguments, &block)
      method = method_sym.to_s

      #puts "%s %s %s" % ["---- ", method, " ----"]
      #
      if method =~ /^[A-Z]\d{2}(_\d{2})?/
        Array(parse(get_spec(method))).join(', ') rescue ''
      elsif respond_to?((/(\w+)/.match(method))[0])
        instance_eval(method) rescue ''
      # for testing:
      elsif %w(E_STRING E_MULTI_STRING E_NUMBER E_DATETIME E_DATE E_TIME E_YES_NO E_SINGLE E_MULTIPLE E_ALLOW_NEGATIVE E_LOOKUP).include?(method)
        Array(parse(get_spec(method))).join(', ') rescue ''
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

    ###
    # Enable direct lookup of value in a given a field
    # return nil if nothing is found, or if there is nothing to be found
    def lookup(element_name_or_spec, key, filter_negative_fields=true)
      if element_name_or_spec.nil? or element_name_or_spec.empty?
        raise ArgumentError.new("Incorrect Method Call; element = '#{element_name_or_spec}', should be: lookup(element_name_or_spec_hash, key_for_lookup)")
      end
      if key.nil? or key.empty?
        raise ArgumentError.new("Incorrect Method Call; key = '#{key}', should be: lookup(element_name_or_spec_hash, key_for_lookup)")
      end
      obj = nil
      # key must be numeric or a CPT code
      key = Nemsis::Parser.validate_key!(key)
      unless key
        return obj
      end

      element_spec = (element_name_or_spec.is_a?(Hash) ? element_name_or_spec : get_spec(element_name_or_spec))
      #puts "Lookup #{key} in #{element_spec['field_values']}"

      # Blank out "Not Recorded" raw_values
      if filter_negative_fields
        element_spec['field_values'].merge!(
            -10 => '', # Not Known
            -15 => '', # Not Reporting
            -20 => '', # Not Recorded
            -25 => '', # Not Applicable
            -5  => ''  # Not Available
        )
      else
        # Let them be!
      end

      mapped_value = element_spec['field_values'][key]

      case mapped_value
        when true then
          obj = 'Yes'
        when false then
          obj = 'No'
        else
          obj = mapped_value unless mapped_value.nil?
      end

      obj
    end

    # Keys are typically integers, however, they can also be codes like 89.700
    # Some day, we could possibly even add string keys ;-)
    # return a valid key, otherwise nil
    def self.validate_key!(key)
      return nil if key.nil? or key.empty?
      if key.to_i.to_s == key.to_s
        return key.to_i
      elsif (key =~ /\d{1,3}.\d{1,}/) == 0
        return key.to_f
      else
        return nil
      end
    end

    # deprecated, 5/16/2012 GC
    #
    # Use the values in E04 to lookup the provider info
    #   E04_01 - ID
    #   E04_02 - Role
    #   E04_03 - Level
    #   E04_04 - Last Name
    #   E04_05 - First Name
    # provider ID can also be an element that holds the ID
    # def get_provider_name(provider_id)
    #   value = send(provider_id)
    #   provider_id = value unless (value && value.empty?)

    #   name = provider_id
    #   providers = get_children('E04')
    #   provider = providers.select{|p| p['E04_01'] == provider_id}.first

    #   unless provider.nil? || provider.empty?
    #     name = "#{(provider['E04_05']).capitalize} #{(provider['E04_04']).capitalize}"
    #   end

    #   name
    # end

    private

    # This returns values for the basic string elements
    def get_str(element_spec, node)
      obj = get_obj(element_spec, node)

      case 
      when obj.class.to_s =~ /time/i
        case element_spec['data_type']
        when /^date\/time$/i
          str = obj.in_time_zone(@@time_zone).strftime("%Y-%m-%d %H:%M") rescue nil
        when /^time$/i
          str = obj.in_time_zone(@@time_zone).strftime("%Y-%m-%d %H:%M") rescue nil
        #   str = obj.in_time_zone(@@time_zone).strftime("%H:%M") rescue nil
        end
      when obj.class.to_s =~ /date/i
          str = obj.strftime("%Y-%m-%d") rescue nil
      else
        str = obj.to_s
      end
      #puts "#{__method__}: #{str}"
      str
    end

    # This is used for look-up types
    def get_obj(element_spec, node, filter_negative_fields=true)
      raw_value = get_raw(element_spec, node)

      # Note: data_type possible values are
      # ["text", "combo", "date/time", "number", "date", "time", "combo or text", "binary"]
      case
        when element_spec['data_type'] =~ /(text|combo|combo or text)/i
          obj = raw_value
          unless element_spec['field_values'].nil?
            # map numeric key to string value
            value = nil
            key = raw_value
            if element_spec['lookup']
              value = lookup(element_spec['lookup'], key, filter_negative_fields)
            else
              value = lookup(element_spec, key, filter_negative_fields)
            end unless key.empty?
            obj = value if value
          end
        when element_spec['data_type'] =~ /time/i
          obj = ActiveSupport::TimeZone.new('UTC').parse(raw_value) rescue nil
        when element_spec['data_type'] =~ /^date$/i
          obj = Date.parse(raw_value) rescue nil
        when element_spec['data_type'] =~ /number/i
          # f = sprintf("%.1e", raw_value).to_f
          # i = f.to_i
          # # puts "raw_value=#{raw_value} f=#{f}, i=#{i}"
          # if f > 99
          #   f = raw_value.to_f
          # end
          # obj = (i == f ? i : f)
          obj = raw_value
      end
      #puts "#{__method__}: #{obj}"

      obj
    end

    # Just return the raw node text value
    def get_raw(element_spec, node)
      result = node && node.text or ""
      #puts "#{__method__}: #{result}"
      result
    end
  end
end
