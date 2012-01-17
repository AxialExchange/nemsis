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
      nemsis_fields = map[:nemsis_field].split(/\s*\+\s*/)

      values = []
      nemsis_fields.each do |field|
        xpath = "//#{field}"
        values << parser.find(xpath).first.text rescue nil
      end

      puts "#{name} [#{nemsis_fields.join('+')}]: [#{values.join(' ')}]"
    end

  end

end

Main.run
