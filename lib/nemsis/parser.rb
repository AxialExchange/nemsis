require 'nokogiri'
require 'yaml'

module Nemsis
  class Parser
    attr_accessor :xml_str, :xml_doc

    class << self
      attr_accessor :spec
    end

    spec_yaml = File.expand_path('../../../conf/nemsis_spec.yml', __FILE__)
    @@spec = YAML::load(File.read(spec_yaml))

    def initialize(xml_str)
      self.xml_str = xml_str
      self.xml_doc = Nokogiri::XML(xml_str)
      xml_doc.remove_namespaces!
    end

    def parse(element_spec)
      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath) or return
        case element_spec['is_multi_entry']
        when 1
          values = []
            nodes.each do |node|
              value = node.text

              # Note: data_type possible values are
              # ["text", "combo", "date/time", "number", "date", "combo or text", "binary"]
              if element_spec['data_type'] =~ /(text|combo|combo or text)/i && 
                 value =~ /^\d+$/ && 
                 !element_spec['field_values'].nil?

                mapped_value = element_spec['field_values'][value.to_i]
                
                value = mapped_value unless mapped_value.nil?
              end

              values << value
            end

          return values
        else
          node = nodes.first or return
          value = node.text

          if element_spec['data_type'] =~ /(text|combo)/i && 
             value =~ /^\d+$/ && 
             !element_spec['field_values'].nil?

            mapped_value = element_spec['field_values'][value.to_i]
            
            value = mapped_value unless mapped_value.nil?
          end

          return value
        end

      rescue => err
        puts "Error: parsing xpath [#{xpath}] #{err}"
      end
    end

    def parse_element(element)
      element_spec = @@spec[element]

      puts element if element_spec.nil?
      results = parse(element_spec)

      results.is_a?(Array) ? results.first : results
    end

    def parse_time(element)
      time_str = parse_element(element)

      Time.parse(time_str).strftime("%Y-%m-%d %H:%M") rescue nil
    end

    def parse_state(element)
      state_code = parse_element(element)

      state_codes = {"42"=>"PA", "01"=>"AL", "02"=>"AK", "04"=>"AZ", "05"=>"AR", "06"=>"CA", "08"=>"CO", "09"=>"CT", "10"=>"DE", "11"=>"DC", "12"=>"FL", "13"=>"GA", "15"=>"HI", "16"=>"ID", "17"=>"IL", "18"=>"IN", "19"=>"IA", "20"=>"KS", "21"=>"KY", "22"=>"LA", "23"=>"ME", "24"=>"MD", "25"=>"MA", "26"=>"MI", "27"=>"MN", "28"=>"MS", "29"=>"MO", "30"=>"MT", "31"=>"NE", "32"=>"NV", "33"=>"NH", "34"=>"NJ", "35"=>"NM", "36"=>"NY", "37"=>"NC", "38"=>"ND", "39"=>"OH", "40"=>"OK", "41"=>"OR", "44"=>"RI", "45"=>"SC", "46"=>"SD", "47"=>"TN", "48"=>"TX", "49"=>"UT", "50"=>"VT", "51"=>"VA", "53"=>"WA", "54"=>"WV", "55"=>"WI", "56"=>"WY", "60"=>"AS", "66"=>"GU", "69"=>"MP", "72"=>"PR", "74"=>"UM", "78"=>"VI"}

      state_codes[state_code] || state_code
    end

    def parse_field(field_name)
      element_spec = @@spec.values.
                            select{|v| v['name'] == field_name}.
                            first

      parse(element_spec)
    end

    def parse_pair(name_element, value_element)
      name_element_spec = @@spec[name_element]
      names = parse(name_element_spec)

      value_element_spec = @@spec[value_element]
      values = parse(value_element_spec)

      result = {}
      begin
        names.size.times {|i| result[names[i]] = values[i]}
      rescue
      end

      result
    end

    def parse_value_of(key)
      parse_pair('E23_11', 'E23_09')[key] rescue nil
    end
    
    def parse_cluster(element)
      xpath = "//#{element}"
      nodes = xml_doc.xpath(xpath)
      # puts nodes.count

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

    def parse_clusters(*cluster_elements)
      results = []
      cluster_elements.each do |element|
        results = results + parse_cluster(element)
      end

      results
    end

    def parse_assessments
      # Assessments elements are E15 and E16.  There would be just one E15 and
      # many E16 elements.  Sort E16 element clusters by time E16_03, and the
      # first one would be Initial Assessment.  The single E15 element is always
      # part of the initial assessment, so it will need to be combined with the
      # earliest E16.
      e15_clusters  = parse_cluster('E15')
      e15_initial_assessment = e15_clusters.shift

      e16_clusters = parse_clusters('E16')
      e16_clusters = e16_clusters.sort_by {|c| Time.parse(c.sub_element('03')) rescue Time.now}
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

    def concat(*elements)
      elements.map do |elem|
        parse_element(elem)
      end.compact.join(' ')
    end

    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        parse_element(method_sym.to_s)
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
  end
end
