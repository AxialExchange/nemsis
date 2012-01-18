#!/usr/bin/env ruby
require 'rubygems'
require 'ruby-debug'
require 'yaml'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "nemsis"

class Main

  def self.run
    sample_xml_file = File.expand_path('../../data/sample.xml', __FILE__)
    xml_str = File.read(sample_xml_file)

    parser = Nemsis::Parser.new(xml_str)
    puts parser.parse_element('E06_01')
    puts parser.parse_field('FIRST NAME')
    puts parser.parse_field('LAST NAME')
    puts parser.parse_element('E06_02')
    puts parser.parse_element('E06_16')
    puts parser.parse_element('E06_11')
    puts parser.parse_element('E23_09')
    puts parser.parse_element('E23_11')
    puts parser.parse_element('E20_02')

  end

end

Main.run
