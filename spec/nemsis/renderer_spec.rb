require 'spec_helper'

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

  # -- START --------------------------------------------------------------------
  # Boiler plate template for rolling your own template section test
  describe 'Boilerplate Template Spec' do
    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <D01_01>0920547</D01_01>
    <D01_03>37</D01_03>
    <D01_04>00000</D01_04>
    <D01_07>6110</D01_07>
    <D01_08>5830</D01_08>
    <D01_09>5870</D01_09>
    <D01_21>192209802</D01_21>
    <D02_07>27601</D02_07>
    <Record>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p) }
    let(:html) { r.render }

    it 'should have some text' do
      html.should =~ /^\s*<h4>Wake County EMS System - Patient Care Record/
    end
    it 'should have the current version number' do
      html.should =~ /Version #{Nemsis::VERSION}/
    end

  end
  # -- END ----------------------------------------------------------------------


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
        html = r.render
        html.should_not =~ /<STYLE/
      end
      it 'should allow for toggling fancy flag' do
        html = r.render_fancy
        html.should =~ /<STYLE/
      end

      it 'should have runsheet timestamp by default' do
        timestamp = Time.now

        html = r.render
        time_in_html = (/Generated at: (.*)$/i).match(html)[1]
        html_timestamp = Time.parse(time_in_html)

        # puts "Expected #{timestamp}, Found #{time_in_html}/#{html_timestamp}; delta = #{delta}"
        
        delta = (html_timestamp - timestamp).abs
        delta.should < 5
      end

      it 'should allow for adding runsheet date' do
        time_stamp = Time.parse('2012-04-23 07:10:39 -0400')
        expected_time_stamp_str = time_stamp.in_time_zone('Eastern Time (US & Canada)').
                                             strftime("%Y-%m-%d %H:%M:%S %Z")

        html = r.render(time_stamp)
        html.should =~ /Generated at: #{expected_time_stamp_str}/i
      end

    end

  end

  # This is a good place to put local test files and have them generate local output you can view in your browser
  context 'generate some sample runsheets' do
    before :all do
      WRITE_HTML_FILE = true
    end
    it 'should render madison' do
      sample_xml_file = File.expand_path('../../data/madison_henry_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("madison", "fancy", html)
    end

    it 'should render everything patient' do
      sample_xml_file = File.expand_path('../../data/everything_patient.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render
      write_html_file("everything_patient", "simple", html)
      html = r.render_fancy
      write_html_file("everything_patient", "fancy", html)
    end

#=begin
    it 'should render test xml file' do
      sample_xml_file = File.expand_path('../../data/priscilla.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("test", "fancy", html)
    end
#=end

    after :all do
      WRITE_HTML_FILE = false
    end
  end

  context 'instance methods' do

    before :all do
      @sample_xml_file = File.expand_path('../../data/sample_v_1_13.xml', __FILE__)
      xml_str = File.read(@sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      @plain_html = r.render
      @fancy_html = r.render_fancy
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
          write_html_file('sample', 'simple', @plain_html)
        end
      end

      context 'fancy HTML' do

        it 'should have a STYLE section' do
          @fancy_html.should =~ /<STYLE/
        end

        it 'write to html file' do
          write_html_file('sample', 'fancy', @fancy_html)
        end
      end
    end

  end

  context 'mileage' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E02><E02_01>092054799999999</E02_01>
        <E02_16>100899.0</E02_16>
        <E02_17>100902.0</E02_17>
        <E02_18>100908.1</E02_18>
        <E02_19>100910.1</E02_19>
      </E02>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    describe 'various mileage values' do
      it('should have start') {html.should =~ />100899.0</}
      it('should have scene') {html.should =~ />100908.1</}
      it('should have destination') {html.should =~ />100908.1</}
      it('should have end') {html.should =~ />100910.1</}
      it('should have loaded') {html.should =~ />6.1</}
      it('should have total') {html.should =~ />11.1</}
      #it('write to html file') { WRITE_HTML_FILE=true; write_html_file('mileage', 'simple', html)}
    end

  end

  context 'signs & symptoms' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E10>
        <E10_01>9550</E10_01>
        <E10_02>2030</E10_02>
        <E10_03>2035</E10_03>
        <E10_11>Fall</E10_11>
        <E10_13>Home</E10_13>
        <E10_14>2012-02-27</E10_14>
        <E10_15>Fall from other slipping, tripping or stumbling</E10_15>
      </E10>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    describe 'various signs and symptom values' do
      it('write to html file')   {WRITE_HTML_FILE=true; write_html_file('symptoms', 'simple', html)}
      it('should have section')  {html.should =~ /Clinical Impression/}
      it('should have details')  {html.should =~ /Fall from other slipping, tripping or stumbling/}
      it('should have date')     {html.should =~ /2012-02-27/}
      it('should have location') {html.should =~ /Home/}
    end

  end

  context 'Clinical Impression Injury' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E10>
        <E10_01>9595</E10_01>
        <E10_02>2030</E10_02>
        <E10_03>2035</E10_03>
        <E10_06_0>
          <E10_06>1</E10_06>
          <E10_07>2165</E10_07>
        </E10_06_0>
        <E10_11>Motorized Vehicle Accident</E10_11>
        <E10_12>Right Front</E10_12>
      </E10>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    # "concat('E10_11', 'E10_02', 'E10_03')"
    # 9595: Motor Vehicle traffic accident (E81X.0)
    # 2030: Unintentional
    # 2035: Blunt
    # Motorized Vehicle Accident
    describe 'Injury values' do
      it('should have Injury label') {html.should =~ /Injury/}
      it('should have values') {html.should =~ /Motorized Vehicle Accident, Unintentional, Blunt/}
      #it('write to html file') { saved_flag=WRITE_HTML_FILE;WRITE_HTML_FILE=true; write_html_file('injury', 'simple', html);WRITE_HTML_FILE=saved_flag}
    end

  end

  context 'Additional Agencies' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
        <E08_17>Wake Forest Fire Department</E08_17>
        <E08_17>Wake Forest Police Department</E08_17>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    it 'should show multiple agencies' do
      html.should =~ /Wake Forest Fire Department, Wake Forest Police Department/
    end

  end

  context 'Vital Signs' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E14>
        <E14_02>1</E14_02>
        <E14_04_0></E14_04_0>
        <E14_14>107</E14_14>
        <E14_20_0>
          <E14_20>37.00</E14_20>
        </E14_20_0>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>-20</E14_32>
        <E14_38></E14_38>
      </E14>
      <E14>
        <E14_01>2012-02-28T22:08:01.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_04_0></E14_04_0>
        <E14_09>100</E14_09>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>-20</E14_32>
        <E14_38></E14_38>
      </E14>
      <E14>
        <E14_01>2012-02-28T22:11:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_04_0>
          <E14_04>140</E14_04>
          <E14_05>85</E14_05>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>98</E14_08>
        <E14_10>3175</E14_10>
        <E14_11>30</E14_11>
        <E14_12>3185</E14_12>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>5</E14_16>
          <E14_17>6</E14_17>
        </E14_15_0>
        <E14_19>15</E14_19>
        <E14_22>3255</E14_22>
        <E14_23>4</E14_23>
        <E14_27>11</E14_27>
        <E14_29>L</E14_29>
        <E14_30>Sit</E14_30>
        <E14_32>-20</E14_32>
        <E14_35>Regular</E14_35>
        <E14_36>Normal</E14_36>
        <E14_38>Regular</E14_38>
      </E14>
      <E14><E14_01>2012-03-01T18:08:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_04_0>
          <E14_04>128</E14_04>
          <E14_05>87</E14_05>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>76</E14_08>
        <E14_10>3175</E14_10>
        <E14_11>12</E14_11>
        <E14_12>3185</E14_12>
        <E14_14>108</E14_14>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>5</E14_16>
          <E14_17>6</E14_17>
        </E14_15_0>
        <E14_19>15</E14_19>
        <E14_20_0>
          <E14_20>36.28</E14_20>
        </E14_20_0>
        <E14_22>3255</E14_22>
        <E14_27>12</E14_27>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>-20</E14_32>
        <E14_35>Regular</E14_35>
        <E14_36>Normal</E14_36>
        <E14_38>Regular</E14_38>
      </E14>
      <E14><E14_01>2012-03-01T18:14:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_04>130</E14_04>
          <E14_05>90</E14_05>
          <E14_06>3165</E14_06>
        </E14_04_0>
        <E14_08>80</E14_08>
        <E14_10>3175</E14_10>
        <E14_11>13</E14_11>
        <E14_12>3185</E14_12>
        <E14_20_0>
          <E14_20>35.28</E14_20>
        </E14_20_0>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>-20</E14_32>
        <E14_34>Normal Sinus Rhythm</E14_34>
        <E14_35>Placed</E14_35>
        <E14_36>Normal</E14_36>
        <E14_37>Esophageal</E14_37>
        <E14_38>Ventilated</E14_38>
      </E14>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    it 'should show basic heading' do
      html.should =~ /Vital Signs/
    end
    it 'should not show full text descriptions' do
      html.should_not =~ /12 Normal/i
    end

    # When time is missing, show PTA
    it 'should show PTA for vital signs missing timestamp' do
      html.should =~ /PTA/
    end

    # BP    <%= cell ("#{[e14.E14_04, e14.E14_05].select {|v| !v.to_s.eql?('')}.compact.join('/')}&nbsp;#{e14.E14_06}") %>
    it 'should show BP abbreviations' do
      html.should =~ /128\/87&nbsp;A/ #Automated
      html.should =~ /130\/90&nbsp;P/ #Palpated
    end

    # Pulse <%= cell ("#{[(!e14.E14_07.to_s.eql?('') ? e14.E14_07 : e14.E14_08), e14.E14_10].compact.join(' ')}&nbsp;") %>
    it 'should show Pulse abbreviations' do
      html.should =~ /76 R/
    end

    # RR    <%= cell ((e14.concat 'E14_11', 'E14_12')) %>
    it 'should show Respiratory Rate abbreviations' do
      html.should =~ /12 R/
      html.should =~ /13 V/
    end

    # Temp  <%= cell ((e14.concat 'E14_20', 'E14_37')) %>
    it 'should show Temp Method abbreviations' do
      html.should =~ /97.3/   # 36.28 deg C
      html.should =~ /95.5 E/ # 35.28 deg C
    end

    it('write to html file') { saved_flag=WRITE_HTML_FILE;WRITE_HTML_FILE=true; write_html_file('vital_signs', 'simple', html);WRITE_HTML_FILE=saved_flag}


  end

  context 'secondary impression' do

    context 'normal text provided' do
      let(:p) {
        xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E09>
        <E09_20>No Complaints or Injury/Illness Noted</E09_20>
      </E09>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }
      let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
      let(:html) {r.render}
      it('should have the text') {html.should =~ /No Complaints or Injury\/Illness Noted/}
      #it('write to html file') { WRITE_HTML_FILE=true; write_html_file('impression_reg', 'simple', html)}
    end
    context '-20 text provided in error by ESO' do
      let(:p) {
        xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E09>
        <E09_20>-20</E09_20>
      </E09>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }
      let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
      let(:html) {r.render}
      it('should have -20') {html.should =~ /^(\s*)<tr>.*<b>Secondary Impression.*>-20</}
      it('should not have blank space text') {html.should_not =~ /^(\s*)<tr>.*<b>Secondary Impression.<b>*>&nbsp;</}
      #it('write to html file') { WRITE_HTML_FILE=true; write_html_file('impression_neg20', 'simple', html)}
    end

  end

  context 'flow chart' do

    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E18>
        <E18_01>2012-03-02T02:48:00.0Z</E18_01>
        <E18_02>0</E18_02>
        <E18_03>Fentanyl</E18_03>
        <E18_04>4190</E18_04>
        <E18_05_0>
          <E18_05>50.00</E18_05>
          <E18_06>4330</E18_06>
        </E18_05_0>
        <E18_07>4375</E18_07>
        <E18_08>4390</E18_08>
        <E18_09>P021554</E18_09>
        <E18_10>4490</E18_10>
        <E18_11>907</E18_11>
      </E18>
      <E19>
        <E19_01_0>
          <E19_01>2012-03-01T19:28:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>89.700</E19_03>
          <E19_05>1</E19_05>
          <E19_06>-20</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4605</E19_08>
          <E19_09>P048047</E19_09>
          <E19_10>4625</E19_10>
          <E19_15>ALS Assessment</E19_15>
          <E19_16>WALKER</E19_16>
          <E19_17>CHRISTOPHER</E19_17>
          <E19_19>See Narrative</E19_19>
          <E19_20>Comments See Narrative; Patient Response: Unchanged</E19_20>
        </E19_01_0>
      </E19>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:fancy_html) {r.render_fancy}

    it 'should have a Flow Chart section' do
      fancy_html.should =~ /Flow Chart/i
      write_html_file('flow_chart', 'fancy', fancy_html)
    end

    it 'should not have a Trauma section' do
      fancy_html.should_not =~ /Trauma Activation/i
    end

    it 'should have the CPT Code 89.7 -- soon we will get text instead (4/17/2012 telecon w/ ESO)' do
      fancy_html.should_not =~ /89.7/
      fancy_html.should =~ /ALS Assessment/
    end
  end

  context 'ECG section' do

    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E14>
        <E14_01>2012-03-01T18:57:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
        </E14_04_0>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>0</E14_32>
        <E14_33>NSR</E14_33>
        <E14_34>Normal Sinus Rhythm</E14_34>
      </E14>
      <E14>
        <E14_01>2012-03-01T19:09:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_04>131</E14_04>
          <E14_05>80</E14_05>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>104</E14_08>
        <E14_09>97</E14_09>
        <E14_10>3175</E14_10>
        <E14_11>14</E14_11>
        <E14_12>3185</E14_12>
        <E14_22>3255</E14_22>
        <E14_29>L</E14_29>
        <E14_30>Sit</E14_30>
        <E14_31>2</E14_31>
        <E14_32>-20</E14_32>
        <E14_34>Normal Sinus Rhythm</E14_34>
        <E14_35>Regular</E14_35>
        <E14_36>Normal</E14_36>
      </E14>
      <E14>
        <E14_01>2012-03-01T19:00:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_04>162</E14_04>
          <E14_05>83</E14_05>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>98</E14_08>
        <E14_09>97</E14_09>
        <E14_10>3175</E14_10>
        <E14_11>16</E14_11>
        <E14_12>3185</E14_12>
        <E14_22>3255</E14_22>
        <E14_29>L</E14_29>
        <E14_30>Sit</E14_30>
        <E14_31>0</E14_31>
        <E14_32>-20</E14_32>
        <E14_34>Normal Sinus Rhythm</E14_34>
        <E14_35>Regular</E14_35>
        <E14_36>Normal</E14_36>
      </E14>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:fancy_html) {r.render_fancy}

    it 'should have a ECG section' do
      fancy_html.should =~ /ECG/i
      write_html_file('ecg', 'fancy', fancy_html)
    end

    it 'should not have a Trauma section' do
      fancy_html.should_not =~ /Trauma Activation/i
    end

  end

  describe 'Personal Items' do
    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <D01_01>0920547</D01_01>
    <D01_03>37</D01_03>
    <D01_04>00000</D01_04>
    <D01_07>6110</D01_07>
    <D01_08>5830</D01_08>
    <D01_09>5870</D01_09>
    <D01_21>192209802</D01_21>
    <D02_07>27601</D02_07>
    <Record>
      <E35>
        <E35_01_0>
          <E35_01>C160EF94-F2AD-4222-9468-A0060172DA8C</E35_01>
          <E35_02>Purse/Wallet</E35_02>
          <E35_03>pt</E35_03>
        </E35_01_0>
        <E35_01_0>
          <E35_01>99D9FEEC-EC50-4284-ADAF-A006016865EE</E35_01>
          <E35_02>Gold Bullion</E35_02>
          <E35_03>EMS Driver</E35_03>
          <E35_04>Pt appreciated the thrill of the lights and sirens</E35_04>
        </E35_01_0>
      </E35>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p) }
    let(:html) { r.render }

    it 'should have the special section' do
      WRITE_HTML_FILE = true
      write_html_file('personal_items', 'simple', html)
      html.should =~ /Personal Items/
    end
    it 'should have the first entry' do
      html.should =~ /Purse\/Wallet/
      html.should =~ />pt</
    end
    it 'should have the second entry' do
      html.should =~ /Gold Bullion/
      html.should =~ /EMS Driver/
      html.should =~ /thrill of the lights/
    end

  end

end

