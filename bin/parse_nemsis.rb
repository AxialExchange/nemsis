#!/usr/bin/env ruby
require 'rubygems'
require 'ruby-debug'
require 'yaml'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "nemsis"

class Renderer
  attr_accessor :parser

  def initialize(nemsis_parser)
    self.parser = nemsis_parser
  end

  def render
    erb_file = File.expand_path('../../lib/nemsis/templates/runsheet.html.erb', __FILE__)
    template = File.read(erb_file)
    renderer = ERB.new(File.read(erb_file))
    puts output = renderer.result(binding)
  end

end
class Main

  def self.run
    sample_xml_file = File.expand_path('../../data/sample.xml', __FILE__)
    xml_str = File.read(sample_xml_file)

    parser = Nemsis::Parser.new(xml_str)
    # puts parser.parse_element('E06_01')
    # puts parser.parse_element('E06_02')
    # puts parser.parse_field('FIRST NAME')
    # puts parser.parse_field('LAST NAME')
    # puts parser.E06_16
    # puts parser.E06_11
    # puts parser.E23_09
    # puts parser.E23_11
    # puts parser.E20_02
    # puts parser.E20_02
    # puts parser.parse_pair('E23_11', 'E23_09')

    # parser.parse_cluster('E14').each do |p|
    #   puts p.E14_10
    # end

    renderer = Renderer.new(parser)
    renderer.render
  end

end

Main.run
