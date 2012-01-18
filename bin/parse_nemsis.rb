#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "nemsis"

require 'rubygems'
require 'ruby-debug'

$LOAD_PATH.unshift File.expand_path('..', __FILE__)
require 'mappings'

class Main
  include Mapping

  def self.run
    sample_xml_file = File.expand_path('../../data/sample.xml', __FILE__)
    xml_str = File.read(sample_xml_file)

    parser = Nemsis::Parser.new(xml_str)
    parser.parse

    maps = Mapping.mapping
    maps.each do |map|
      name = map[:name]
      # debugger if name == 'Receiving Application'
      if name == 'custom' && !map[:nemsis_title_field].nil? && 
                             !map[:nemsis_value_field].nil?

        xpath = "//#{map[:nemsis_field]}"
        nodes = parser.find(xpath)
        nodes.each do |node|
          field_name  = node.xpath(".//#{map[:nemsis_title_field]}").first.text
          field_value = node.xpath(".//#{map[:nemsis_value_field]}").first.text

          puts "#{field_name} [#{map[:nemsis_value_field]}]:[#{field_value}]"
        end

      elsif !map[:nemsis_field].nil? && 
            map[:nemsis_field].gsub(/\s*/, '').size > 0

        if map[:allow_multiple] == 'Y'
          nemsis_field = map[:nemsis_field]

          values = []
          xpath = "//#{nemsis_field}"
          nodes = parser.find(xpath)

          begin
            nodes.each do |node|
              value = node.text rescue nil

              if map[:is_mapped] == 'Y'
                code_map = Mapping.nemsis_code.merge(map[:map] || {})
                value = code_map[value]
              end

              values << value
              puts "#{name} [#{nemsis_field}]: [#{values.join(' ')}]"
            end
          rescue
          end

        else
          nemsis_fields = map[:nemsis_field].split(/\s*\+\s*/)

          values = []
          nemsis_fields.each do |field|
            xpath = "//#{field}"
            nodes = parser.find(xpath)
            begin
              nodes.each do |node|
                value = node.text rescue nil

                if map[:is_mapped] == 'Y'
                  code_map = Mapping.nemsis_code.merge(map[:map] || {})
                  value = code_map[value]
                end

                values << value
              end
            rescue
            end
          end

          puts "#{name} [#{nemsis_fields.join('+')}]: [#{values.join(' ')}]"
        end
      else
        puts "#{name} [default]: [#{map[:default_value]}]"
      end
    end

  end

end

Main.run
