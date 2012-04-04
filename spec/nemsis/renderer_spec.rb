require 'spec_helper'


def write_html_file(sample_xml_file, type, html)
  file_name = "#{sample_xml_file.gsub('.xml','')}-#{Time.now.strftime("%d%b")}_#{type}.html"
  file = File.open(file_name, 'w+')
  file.puts html
  file.close
  puts "Open this in your browser to admire your handiwork: file://localhost#{file_name}"
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

  describe 'renderer switches/options' do
    let(:spec_yaml) {
      spec_yaml = <<YML
E24_01:
  allow_null: 1
  data_entry_method: ~
  data_type: date/time
  is_multi_entry: 1
  name: 'Date/Time'
  node: E24_01
E24_02:
  allow_null: 1
  data_entry_method: ~
  data_type: date
  is_multi_entry: 1
  name: 'Date'
  node: E24_02
E24_03:
  allow_null: 1
  data_entry_method: ~
  data_type: time
  is_multi_entry: 1
  name: 'Time'
  node: E24_03
YML
    }
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E24>
        <E24_01>2012-03-08T17:50:00.0Z</E24_01>
        <E24_02>2012-03-08T17:50:00.0Z</E24_02>
        <E24_03>2012-03-08T17:50:00.0Z</E24_03>
      </E24>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str, spec_yaml)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}

    describe 'renderer flags' do
      it 'should default to plain type by default' do
        html = r.render()
        html.should_not =~ /<STYLE/
      end
      it 'should allow for toggling fancy flag' do
        html = r.render(true)
        html.should =~ /<STYLE/
      end

      it 'should have runsheet timestamp by default' do
        html = r.render()
        html.should =~ /timestamp:/i
      end

      it 'should allow for adding runsheet date' do
        time_stamp = Time.now - rand(10)*3600
        html = r.render(time_stamp)
        html.should =~ /timestamp:/i
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

    before :all do
      @sample_xml_file = File.expand_path('../../data/sample_v_1_13.xml', __FILE__)
      xml_str = File.read(@sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      @plain_html = r.render(false)
      @fancy_html = r.render(true)
    end

    describe '#render_html' do
      context 'plain HTML' do

        it 'returns not nil' do
          @plain_html.should_not be_nil
        end

        it 'has title section' do
          @plain_html.should =~ /^\s*<h4>Wake County EMS System - Patient Care Record/
        end

        context 'specialty patient section' do
          it('has specialty patient') { @plain_html.should =~ /Specialty Patient/ }
          it('has specialty patient trauma criteria') { @plain_html.should =~ /Trauma Activation/ }
          it('has specialty patient airway') { @plain_html.should =~ /Advanced Airway/ }
        end

        it 'should not have a STYLE section' do
          @plain_html.should_not =~ /<STYLE/
        end

        it 'should not have empty table cells' do
          @plain_html.should_not =~ /<td  ><font size='2'><\/font><\/td>/
        end

        it 'write to html file' do
          write_html_file(@sample_xml_file, 'simple', @plain_html)
        end
      end

      context 'fancy HTML' do

        it 'should have a STYLE section' do
          @fancy_html.should =~ /<STYLE/
        end

        it 'write to html file' do
          write_html_file(@sample_xml_file, 'fancy', @fancy_html)
        end
      end
    end

  end

end

