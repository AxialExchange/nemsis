#!/usr/bin/env ruby
require 'rubygems'
require 'ruby-debug'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "nemsis"

class Main

  def self.run
    Main.parser_examples
    Main.reproducer_examples
  end
    
  def self.parser_examples
    sample_xml_file = File.expand_path('../../data/sample_3.xml', __FILE__)
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

    renderer = Nemsis::Renderer::WakeMed::HTML.new(parser)
    puts renderer.render
  end

  def self.reproducer_examples
    sample_xml_file = File.expand_path('../../data/sample_2.xml', __FILE__)
    xml_str = File.read(sample_xml_file)

    reproducer = Nemsis::Reproducer.new(xml_str)

    reproducer.pcr_id = 'ALKEJ189PQNO49'
    reproducer.last_name = 'Davenport'
    reproducer.first_name = 'Jeffrey'
    reproducer.middle_name = 'G'
    reproducer.gender = 'Male'
    reproducer.dob = '1970-01-01'
    reproducer.transferred_to = 'WakeMed Cary'

    # puts reproducer.to_xml
  end

end

class String
  def to_p
    text = self.split(/\n/)
    paragraphs = text.map {|paragraph| "<p>#{paragraph.strip}</p>" if paragraph.strip}
    begin
      return paragraphs.join
    rescue
      return self
    end
  end

  def to_br
    text = self.split(/\n/)
    paragraphs = text.map {|paragraph| paragraph.strip}
    begin
      return paragraphs.join("<br>")
    rescue
      return self
    end
  end
end

Main.run
