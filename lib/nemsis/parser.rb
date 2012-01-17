module Nemsis
  class Parser
    attr_accessor :xml_str, :xml_doc

    def initialize(xml_str)
      self.xml_str = xml_str
    end

    def parse
      self.xml_doc = Nokogiri::XML(xml_str)
      xml_doc.remove_namespaces!
    end

    def find(xpath)
      xml_doc.xpath(xpath)
    end
  end
end
