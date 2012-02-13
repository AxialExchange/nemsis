require 'nokogiri'

module Nemsis
  class Reproducer
    attr_accessor :xml_str, :xml_doc

    custom_attrs = [
      {:name => 'last_name',    :element => 'E06_01', :parent_element => 'E06_01_0'},
      {:name => 'first_name',   :element => 'E06_02', :parent_element => 'E06_01_0'},
      {:name => 'middle_name',  :element => 'E06_03', :parent_element => 'E06_01_0'},
      {:name => 'gender_code',       :element => 'E06_11'},
      {:name => 'dob',          :element => 'E06_16'},

      {:name => 'pcr_id',       :element => 'E01_01'},

      {:name => 'transferred_to_name',       :element => 'E20_01'},
      {:name => 'transferred_to_code',  :element => 'E20_02'}
    ]

    custom_attrs.each do |attr|
      class_eval %{
        def #{attr[:name]}= value
          xpath = "//xmlns:#{attr[:element]}"
          nodes = xml_doc.xpath(xpath)

          if nodes.size == 0
            # create the node
            if "#{attr[:parent_element]}".to_s.size == 0
              parent_elem_name = "#{attr[:element]}".gsub(/_\\d{2}$/, '')
            else
              parent_elem_name = "#{attr[:parent_element]}"
            end

            parent_xpath = "//xmlns:" + parent_elem_name
            parent_node = xml_doc.xpath(parent_xpath).first

            new_node = Nokogiri::XML::Node.new("#{attr[:element]}", xml_doc)
            new_node.content = value

            parent_node.add_child new_node
          else
            # update the node
            nodes.each do |node|
              node.content = value
            end
          end
        end

        def #{attr[:name]}
          xpath = "//xmlns:#{attr[:element]}"
          nodes = xml_doc.xpath(xpath)

          nodes.first.content
        end
      }
    end

    def initialize(xml_str)
      self.xml_str = xml_str
      self.xml_doc = Nokogiri::XML(xml_str)
    end 

    def to_xml
      xml_doc.to_s
    end

    def gender= str
      gender_code = case str
                    when /^m(ale)?/i    then '650'
                    when /^f(emale)?/i  then '655'
                    end

      self.gender_code= gender_code
    end

    def transferred_to= str
      transferred_to_name = str

      transferred_to_code = 
        case str
        when 'WakeMed Main'         then 'F00002506'
        when 'WakeMed Cary'         then 'F00002573'
        when 'WakeMed Brier Creek'  then 'F00039974'
        when 'WakeMed North'        then 'F00035879'
        when 'WakeMed Apex'         then 'F00035878'
        end

      self.transferred_to_name= transferred_to_name
      self.transferred_to_code= transferred_to_code
    end
  end
end
