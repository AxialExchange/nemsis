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
      expect(html).to match(/^\s*<h4>Wake County EMS System - Patient Care Record/)
    end
    it 'should have the current version number' do
      expect(html).to match(/Version #{Nemsis::VERSION}/)
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
        expect(html).not_to match(/<STYLE/)
      end
      it 'should allow for toggling fancy flag' do
        html = r.render_fancy
        expect(html).to match(/<STYLE/)
      end

      it 'should have runsheet timestamp by default' do
        timestamp = Time.now

        html = r.render
        time_in_html = (/Generated at: (.*)$/i).match(html)[1]
        html_timestamp = Time.parse(time_in_html)

        # puts "Expected #{timestamp}, Found #{time_in_html}/#{html_timestamp}; delta = #{delta}"
        
        delta = (html_timestamp - timestamp).abs
        expect(delta).to be < 5
      end

      it 'should allow for adding runsheet date' do
        time_stamp = Time.parse('2012-04-23 07:10:39 -0400')
        expected_time_stamp_str = time_stamp.in_time_zone('Eastern Time (US & Canada)').
                                             strftime("%Y-%m-%d %H:%M:%S %Z")

        html = r.render(time_stamp)
        expect(html).to match(/Generated at: #{expected_time_stamp_str}/i)
      end

    end

  end

  # This is a good place to put local test files and have them generate local output you can view in your browser
  context 'generate some sample runsheets' do

=begin
    it 'should render madison' do
      sample_xml_file = File.expand_path('../../data/madison_henry_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("madison", "fancy", html)
    end
=end

    it 'should render everything patient' do
      sample_xml_file = File.expand_path('../../data/everything_patient.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render
      write_html_file("everything_patient", "simple", html)
      html = r.render_fancy
      write_html_file("everything_patient", "fancy", html)
      expect(html).not_to match(/age_in_words/)
    end

=begin
    it 'should render test xml file' do
      sample_xml_file = File.expand_path('../../data/anthony.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("test", "fancy", html)
    end
=end

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
          expect(@plain_html).not_to be_nil
        end

        it 'has title section' do
          expect(@plain_html).to match(/^\s*<h4>Wake County EMS System - Patient Care Record/)
        end

        context 'specialty patient section' do
          it('has specialty patient') { expect(@plain_html).to match(/Specialty Patient/) }
          it('has specialty patient trauma criteria') { expect(@plain_html).to match(/Trauma Activation/) }
          it('has specialty patient airway') { expect(@plain_html).to match(/Advanced Airway/) }
        end

        it 'should not have a STYLE section' do
          expect(@plain_html).not_to match(/<STYLE/)
        end

        it 'should not have empty table cells' do
          expect(@plain_html).not_to match(/<td  ><font size='2'><\/font><\/td>/)
        end

        #it 'write to html file' do
        #  write_html_file('sample', 'simple', @plain_html)
        #end
      end

      context 'fancy HTML' do

        it 'should have a STYLE section' do
          expect(@fancy_html).to match(/<STYLE/)
        end

        #it 'write to html file' do
        #  write_html_file('sample', 'fancy', @fancy_html)
        #end
      end
    end

  end

  context 'comment tags' do
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
    let!(:html) {r.render}

    it 'should not have comment tags' do
      expect(html.index('<!--')).to be_nil
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
      it('should have start')       { expect(html).to match(/>100899.0</) }
      it('should have scene')       { expect(html).to match(/>100908.1</) }
      it('should have destination') { expect(html).to match(/>100908.1</) }
      it('should have end')         { expect(html).to match(/>100910.1</) }
      it('should have loaded')      { expect(html).to match(/>6.1</) }
      it('should have total')       { expect(html).to match(/>11.1</) }
    end

  end

  context 'Clinical Impression Signs & Symptoms' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E09>
        <E09_01>-20</E09_01>
        <E09_02>-20</E09_02>
        <E09_03>-20</E09_03>
        <E09_04>1</E09_04>
        <E09_05>Low back/flank pain</E09_05>
        <E09_06_0>
          <E09_06>30</E09_06>
          <E09_07>1240</E09_07>
        </E09_06_0>
        <E09_11>1310</E09_11>
        <E09_12>1375</E09_12>
        <E09_13>1475</E09_13>
        <E09_15>1740</E09_15>
        <E09_16>-20</E09_16>
        <E09_17>Pain-Back</E09_17>
        <E09_19>Traumatic injury</E09_19>
        <E09_20></E09_20>
      </E09>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    describe 'various signs and symptom values' do
      it('should have section')  { expect(html).to match(/Clinical Impression/) }
      it('should have details')  { expect(html).to match(/Pain/) }
      it('should have date')     { expect(html).to match(/Pain-Back/) }
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
      it('should have section')  { expect(html).to match(/Clinical Impression/) }
      it('should have details')  { expect(html).to match(/Fall from other slipping, tripping or stumbling/) }
      it('should have date')     { expect(html).to match(/2012-02-27/) }
      it('should have location') { expect(html).to match(/Home/) }
    end

  end

  context 'Insurance Details' do
    let(:p) {
      xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E07>
        <E07_01>-20</E07_01>
        <E07_03_0>
          <E07_03>Medicaid</E07_03>
          <E07_04>755</E07_04>
          <E07_10>999066222N</E07_10>
          <E07_11_0>
            <E07_11>MOORE</E07_11>
            <E07_12>ROGER</E07_12>
            <E07_13>007</E07_13>
          </E07_11_0>
          <E07_14>770</E07_14>
          <E07_38>Self</E07_38>
          <E07_39>Child</E07_39>
        </E07_03_0>
      </E07>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:html) {r.render}

    describe 'various insurance details values' do
      it('should have section')                 { expect(html).to match(/Insurance Details/) }
      it('should have name')                    { expect(html).to match(/MOORE, ROGER, 007/) }
      it('should have Relationship to Patient') { expect(html).to match(/Self/) }
      it('should have insurance')               { expect(html).to match(/Medicaid/) }
      it('should have Policy #')                { expect(html).to match(/999066222N/) }
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
      expect(html).to match(/Wake Forest Fire Department, Wake Forest Police Department/)
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
      expect(html).to match(/Vital Signs/)
    end
    it 'should not show full text descriptions' do
      expect(html).not_to match(/12 Normal/i)
    end

    # When time is missing, show PTA
    it 'should show PTA for vital signs missing timestamp' do
      expect(html).to match(/PTA/)
    end

    # BP    <%= cell ("#{[e14.E14_04, e14.E14_05].select {|v| !v.to_s.eql?('')}.compact.join('/')}&nbsp;#{e14.E14_06}") %>
    it 'should show BP abbreviations' do
      expect(html).to match(/128\/87&nbsp;A/) #Automated
      expect(html).to match(/130\/90&nbsp;P/) #Palpated
    end

    # Pulse <%= cell ("#{[(!e14.E14_07.to_s.eql?('') ? e14.E14_07 : e14.E14_08), e14.E14_10].compact.join(' ')}&nbsp;") %>
    it 'should show Pulse abbreviations' do
      expect(html).to match(/76 R/)
    end

    # RR    <%= cell ((e14.concat 'E14_11', 'E14_12')) %>
    it 'should show Respiratory Rate abbreviations' do
      expect(html).to match(/12 R/)
      expect(html).to match(/13 V/)
    end

    # Temp  <%= cell ((e14.concat 'E14_20', 'E14_37')) %>
    it 'should show Temp Method abbreviations' do
      expect(html).to match(/97.3/)   # 36.28 deg C
      expect(html).to match(/95.5 E/) # 35.28 deg C
    end

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
      it('should have the text') { expect(html).to match(/No Complaints or Injury\/Illness Noted/) }
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
      it('should have -20') { expect(html).to match(/^(\s*)<tr>.*<b>Secondary Impression.*>-20</) }
      it('should not have blank space text') { expect(html).not_to match(/^(\s*)<tr>.*<b>Secondary Impression.<b>*>&nbsp;</) }
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
      <E09>
        <E09_01>-20</E09_01>
        <E09_02>-20</E09_02>
        <E09_03>-20</E09_03>
        <E09_04>0</E09_04>
        <E09_05>abd pain</E09_05>
        <E09_11>1330</E09_11>
        <E09_12>1370</E09_12>
        <E09_13>1475</E09_13>
        <E09_14>1580</E09_14>
        <E09_15>1615</E09_15>
        <E09_16>-20</E09_16>
        <E09_17>Abdominal-Left Upper Quadrant Pain</E09_17>
        <E09_18>Abdominal-Right Upper Quadrant Pain</E09_18>
        <E09_19>Abdominal Pain/Problems</E09_19>
        <E09_20></E09_20>
      </E09>
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
        <E19_01_0>
          <E19_01>2012-04-18T06:51:10.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>89.700</E19_03>
          <E19_05>1</E19_05>
          <E19_06>-20</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4600</E19_08>
          <E19_09>P049769</E19_09>
          <E19_10>4625</E19_10>
          <E19_15>ALS Assessment</E19_15>
          <E19_16>BROWN</E19_16>
          <E19_17>AVERY</E19_17>
          <E19_19>See Narrative</E19_19>
          <E19_20>Comments See Narrative ; Patient Response: Improved</E19_20>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-04-18T06:54:24.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>38.992</E19_03>
          <E19_04>20 ga</E19_04>
          <E19_05>1</E19_05>
          <E19_06>1</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4600</E19_08>
          <E19_09>P049769</E19_09>
          <E19_10>4625</E19_10>
          <E19_15>IV Therapy</E19_15>
          <E19_16>BROWN</E19_16>
          <E19_17>AVERY</E19_17>
          <E19_20>20 ga; Hand-Left; Saline Lock; Total Fluid 10; Patient Response: Improved; Successful</E19_20>
        </E19_01_0>
        <E19_12>4685</E19_12>
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
      #write_html_file('flow_chart', 'fancy', fancy_html)
      expect(fancy_html).to match(/Flow Chart/i)
    end

    it 'should not have a Prior to Arrival section' do
      expect(fancy_html).not_to match(/Treatments Prior to Arrival/i)
    end

    it 'should not have a Trauma section' do
      expect(fancy_html).not_to match(/Trauma Activation/i)
    end

    it 'should have the CPT Code 89.7 -- soon we will get text instead (4/17/2012 telecon w/ ESO)' do
      expect(fancy_html).not_to match(/89.7/)
      expect(fancy_html).to match(/ALS Assessment/)
    end
  end

  context 'Prior to Arrival' do

    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E18><E18_01 xsi:nil="true" />
        <E18_02>1</E18_02>
        <E18_03>Aspirin</E18_03>
        <E18_07>4375</E18_07>
        <E18_08>-20</E18_08>
        <E18_12>Aspirin</E18_12>
        <E18_15>EMS Provider</E18_15>
        <E18_16>Comments RFD 19; Patient Response: Improved</E18_16>
      </E18>
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
        <E19_01_0>
          <E19_01>2012-04-18T06:51:10.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>89.700</E19_03>
          <E19_05>1</E19_05>
          <E19_06>-20</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4600</E19_08>
          <E19_09>P049769</E19_09>
          <E19_10>4625</E19_10>
          <E19_15>ALS Assessment</E19_15>
          <E19_16>BROWN</E19_16>
          <E19_17>AVERY</E19_17>
          <E19_19>See Narrative</E19_19>
          <E19_20>Comments See Narrative ; Patient Response: Improved</E19_20>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-04-18T06:54:24.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>38.992</E19_03>
          <E19_04>20 ga</E19_04>
          <E19_05>1</E19_05>
          <E19_06>1</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4600</E19_08>
          <E19_09>P049769</E19_09>
          <E19_10>4625</E19_10>
          <E19_15>IV Therapy</E19_15>
          <E19_16>BROWN</E19_16>
          <E19_17>AVERY</E19_17>
          <E19_20>20 ga; Hand-Left; Saline Lock; Total Fluid 10; Patient Response: Improved; Successful</E19_20>
        </E19_01_0>
        <E19_12>4685</E19_12>
      </E19>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }
    let(:r) {Nemsis::Renderer::WakeMed::HTML.new(p)}
    let(:fancy_html) {r.render_fancy}

    it 'should have a Prior to Arrival section' do
      #write_html_file('prior_to_arrival', 'fancy', fancy_html)
      expect(fancy_html).to match(/Treatments Prior to Arrival/i)
    end

    it 'should have a Flow Chart section' do
      expect(fancy_html).to match(/Flow Chart/i)
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
      expect(fancy_html).to match(/ECG/i)
      #write_html_file('ecg', 'fancy', fancy_html)
    end

    it 'should not have a Trauma section' do
      expect(fancy_html).not_to match(/Trauma Activation/i)
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
      expect(html).to match(/Personal Items/)
    end
    it 'should have the first entry' do
      expect(html).to match(/Purse\/Wallet/)
      expect(html).to match(/>pt</)
    end
    it 'should have the second entry' do
      expect(html).to match(/Gold Bullion/)
      expect(html).to match(/EMS Driver/)
      expect(html).to match(/thrill of the lights/)
    end

  end

end

