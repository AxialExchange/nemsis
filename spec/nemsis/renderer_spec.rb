require 'spec_helper'

#
#     html = renderer.render

def write_html_file(sample_xml_file, type, html)
  file_name = "#{sample_xml_file.gsub('.xml','')}-#{Time.now.strftime("%d%b")}_#{type}.html"
  file = File.open(file_name, 'w+')
  file.puts html
  file.close
  puts "Open this in your browser to check: file://localhost#{file_name}"
end

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

  context 'generate some sample runsheets' do
    it 'should render html' do
      sample_xml_file = File.expand_path('../../data/madison_henry_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render(true)
      write_html_file(sample_xml_file, "fancy", html)
    end

  end
  context 'instance methods' do
    let(:sample_xml_file) {File.expand_path('../../data/sample_v_1_13.xml', __FILE__)}
    let(:p) {
      xml_str = File.read(sample_xml_file)
      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:plain_html) { puts "plain"; r.render(false) }
    let(:fancy_html) { puts "fancy"; r.render(true) }

    describe '#render_html' do
      context "plain HTML" do

        it 'returns not nil' do
          plain_html.should_not be_nil
        end

        it 'has title section' do
          plain_html.should =~ /^\s*<h4>Wake County EMS System - Patient Care Record/
        end

        context 'specialty patient section' do
          it('has specialty patient') { plain_html.should =~ /Specialty Patient/ }
          it('has specialty patient trauma criteria') { plain_html.should =~ /Trauma Activation/ }
          it('has specialty patient airway') { plain_html.should =~ /Advanced Airway/ }
        end

        it "should not have a STYLE section" do
          plain_html.should_not =~ /<STYLE/
        end

        it "write to html file" do
          write_html_file(sample_xml_file, "simple", plain_html)
        end
      end

      context "fancy HTML" do

        it "should have a STYLE section" do
          fancy_html.should =~ /<STYLE/
        end

        it "write to html file" do
          write_html_file(sample_xml_file, "fancy", fancy_html)
        end
      end
    end

  end

end

