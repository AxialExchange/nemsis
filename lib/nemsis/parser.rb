require 'erb'

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

    def parse_element(element)
      element_spec = @@spec[element]

      puts element if element_spec.nil?
      parse(element_spec)
    end

    def parse_field(field_name)
      element_spec = @@spec.values.
                            select{|v| v['name'] == field_name}.
                            first

      parse(element_spec)
    end

    def parse(element_spec)
      xpath = "//#{element_spec['node']}"

      begin
        nodes = xml_doc.xpath(xpath) or return
        case element_spec['is_multiple_entry']
        when true
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

    def parse_pair(name_element, value_element)
      name_element_spec = @@spec[name_element]
      names = parse(name_element_spec)

      value_element_spec = @@spec[value_element]
      values = parse(value_element_spec)

      result = {}
      names.size.times {|i| result[names[i]] = values[i]}
      result
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
