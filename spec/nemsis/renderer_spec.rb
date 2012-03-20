require 'spec_helper'

#
#     html = renderer.render

describe Nemsis::Renderer do
  context 'class methods' do
    describe '.initialize' do
      it 'returns nil with no arguments' do
        expect {
          parser = Nemsis::Renderer::WakeMed::HTML.new(nil)
        }.to raise_error
      end
    end
  end

  context 'instance methods' do
    let(:sample_xml_file) {File.expand_path('../../data/sample_3.xml', __FILE__)}
    let(:p) {
      xml_str = File.read(sample_xml_file)

      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    describe '#render_html' do
      it 'returns not nil' do
        html.should_not be_nil
        file_name = "#{sample_xml_file.gsub('.xml','')}-#{Time.now.strftime("%d%b")}.html"
        file = File.open(file_name, 'w+')
        file.puts html
        file.close
        puts "Open this in your browser to check: file://localhost#{file_name}"
      end

      it 'has title section' do
        html.should =~ /^\s*<h4>Wake County EMS System - Patient Care Record/
      end

      it 'has specialty patient trauma criteria' do
        html.should =~ /Trauma Activation/
        html.should =~ /Specialty Patient/
      end
    end

  end

end

