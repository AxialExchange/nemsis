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
      nodes = xml_doc.xpath(xpath)

      values = []
      begin
        nodes.each do |node|
          value = node.text

          if element_spec['data_type'] =~ /(text|combo)/i && 
             value =~ /^\d+$/ && 
             !element_spec['field_values'].nil?

            mapped_value = element_spec['field_values'][value.to_i]
            
            value = mapped_value unless mapped_value.nil?
          end

          values << value
        end
      rescue  error
        puts "Error: #{error}"
      end

      values
    end
  end
end
