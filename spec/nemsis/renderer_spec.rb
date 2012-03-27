require 'spec_helper'

#
#     html = renderer.render

def write_html_file(type)
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

  context 'instance methods' do
    let(:sample_xml_file) {File.expand_path('../../data/sample_v_1_13.xml', __FILE__)}
    let(:p) {
      xml_str = File.read(sample_xml_file)

      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}

    describe '#render_html' do
      context "plain HTML" do
        let(:html) {r.render(false)}

        it 'returns not nil' do
          html.should_not be_nil
        end

        it 'has title section' do
          html.should =~ /^\s*<h4>Wake County EMS System - Patient Care Record/
        end

        context 'specialty patient section' do
          it('has specialty patient') { html.should =~ /Specialty Patient/ }
          it('has specialty patient trauma criteria') { html.should =~ /Trauma Activation/ }
          it('has specialty patient airway') { html.should =~ /Advanced Airway/ }
        end

        it "should not have a STYLE section" do
          html.should_not =~ /<STYLE/
        end

        it "write to html file" do
          write_html_file("simple")
        end
      end

      context "fancy HTML" do
        let(:html) {r.render(true)}

        it "should have a STYLE section" do
          html.should =~ /<STYLE/
        end

        it "write to html file" do
          write_html_file("fancy")
        end
      end
    end

  end

end

