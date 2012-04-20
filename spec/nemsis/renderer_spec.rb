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
        time_stamp = Time.now
        tz    = TZInfo::Timezone.get('America/New_York')
        local = tz.utc_to_local(time_stamp)

        html = r.render
        time_in_html = (/timestamp: (.*)$/i).match(html)[1]
        html_time = Time.parse(time_in_html)

        delta = (html_time-local).abs
        #puts "Expected #{local}, Found #{time_in_html}/#{html_time}; delta = #{delta}"
        delta.should < 5
      end

      it 'should allow for adding runsheet date' do
        time_stamp = Time.now - rand(10)*3600
        tz    = TZInfo::Timezone.get('America/New_York')
        local = tz.utc_to_local(time_stamp)

        html = r.render(time_stamp)
        html.should =~ /timestamp: #{local}/i
      end

    end

  end

  context 'generate some sample runsheets' do
    it 'should render madison' do
      sample_xml_file = File.expand_path('../../data/madison_henry_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("madison", "fancy", html)
    end

=begin
    it 'should render ben' do
      sample_xml_file = File.expand_path('../../data/ben_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("ben", "fancy", html)
    end
    it 'should render nanci' do
      sample_xml_file = File.expand_path('../../data/nanci_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("nanci", "fancy", html)
    end
    it 'should render nathan' do
      sample_xml_file = File.expand_path('../../data/nathan_sample.xml', __FILE__)
      xml_str = File.read(sample_xml_file)
      p = Nemsis::Parser.new(xml_str)
      r = Nemsis::Renderer::WakeMed::HTML.new(p)
      html = r.render_fancy
      write_html_file("nathan", "fancy", html)
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

  context 'flow chart' do
    let(:spec_yaml) {
      spec_yaml = <<YML
E18_01:
  allow_null: 1
  data_entry_method: ~
  data_type: date/time
  is_multi_entry: 1
  name: DATE/TIME MEDICATION ADMINISTERED
  node: E18_01
E18_02:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    0: No
    1: Yes
  is_multi_entry: 1
  name: MEDICATION ADMINISTERED PRIOR TO THIS UNITS EMS CARE
  node: E18_02
E18_03:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: MEDICATION GIVEN
  node: E18_03
E18_04:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4175: Endotracheal tube
    4180: Gastrostomy tube
    4185: Inhalation
    4190: Intramuscular
    4191: Intraosseous
    4200: Intraocular
    4205: Intravenous
    4210: Nasal
    4215: Nasal prongs
    4220: Nasogastric
    4225: Ophthalmic
    4230: Oral
    4235: Other/miscellaneous
    4240: Otic
    4245: Re-breather mask
    4250: Rectal
    4255: Subcutaneous
    4260: Sublingual
    4265: Topical
    4270: Tracheostomy
    4275: Transdermal
    4280: Urethral
    4285: Ventimask
    4290: Wound
  is_multi_entry: 1
  name: MEDICATION ADMINISTERED ROUTE
  node: E18_04
E18_05:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 1
  name: MEDICATION DOSAGE
  node: E18_05
E18_06:
  allow_null: 0
  data_entry_method: single-choice
  data_type: combo
  field_values:
    4295: GMS
    4300: Inches
    4305: IU
    4310: KVO (TKO)
    4315: L/MIN
    4320: LITERS
    4325: LPM
    4330: MCG
    4335: MCG/KG/MIN
    4340: MEQ
    4345: MG
    4350: MG/KG/MIN
    4355: ML
    4360: ML/HR
    4365: Other
    4370: Puffs
  is_multi_entry: 1
  name: MEDICATION DOSAGE UNITS
  node: E18_06
E18_07:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4375: Improved
    4380: Unchanged
    4385: Worse
  is_multi_entry: 1
  name: RESPONSE TO MEDICATION
  node: E18_07
E18_08:
  allow_null: 1
  data_entry_method: multiple-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4390: None
    4395: Altered Mental Status
    4400: Apnea
    4405: Bleeding
    4410: Bradycardia
    4415: Diarrhea
    4420: Extravasion
    4425: Hypertension
    4430: Hyperthermia
    4435: Hypotension
    4440: Hypoxia
    4445: Injury
    4450: Itching/Urticaria
    4455: Nausea
    4460: Other
    4465: Respiratory Distress
    4470: Tachycardia
    4475: Vomiting
  is_multi_entry: 1
  name: MEDICATION COMPLICATION
  node: E18_08
E18_09:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: MEDICATION CREW MEMBER ID
  node: E18_09
E18_10:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4480: On-Line
    4485: On-Scene
    4490: Protocol (Standing Order)
    4495: Written Orders (Patient Specific)
  is_multi_entry: 1
  name: MEDICATION AUTHORIZATION
  node: E18_10
E18_11:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: MEDICATION AUTHORIZING PHYSICIAN
  node: E18_11
E19_01:
  allow_null: 1
  data_entry_method: ~
  data_type: date/time
  is_multi_entry: 1
  name: DATE/TIME PROCEDURE PERFORMED SUCCESSFULLY
  node: E19_01
E19_02:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    0: No
    1: Yes
  is_multi_entry: 1
  name: PROCEDURE PERFORMED PRIOR TO THIS UNITS EMS CARE
  node: E19_02
E19_03:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: PROCEDURE
  node: E19_03
E19_04:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: SIZE OF PROCEDURE EQUIPMENT
  node: E19_04
E19_05:
  allow_null: 1
  data_entry_method: National Element
  data_type: number
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: NUMBER OF PROCEDURE ATTEMPTS
  node: E19_05
E19_06:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    0: No
    1: Yes
  is_multi_entry: 1
  name: PROCEDURE SUCCESSFUL
  node: E19_06
E19_07:
  allow_null: 1
  data_entry_method: multiple-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4500: None
    4505: Altered Mental Status
    4510: Apnea
    4515: Bleeding
    4520: Bradycardia
    4525: Diarrhea
    4530: Esophageal Intubation-immediately
    4535: Esophageal Intubation-other
    4540: Extravasion
    4545: Hypertension
    4550: Hyperthermia
    4555: Hypotension
    4560: Hypoxia
    4565: Injury
    4570: Itching/Urticaria
    4575: Nausea
    4580: Other
    4585: Respiratory Distress
    4590: Tachycardia
    4595: Vomiting
  is_multi_entry: 1
  name: PROCEDURE COMPLICATION
  node: E19_07
E19_08:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4600: Improved
    4605: Unchanged
    4610: Worse
  is_multi_entry: 1
  name: RESPONSE TO PROCEDURE
  node: E19_08
E19_09:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: PROCEDURE CREW MEMBERS ID
  node: E19_09
E19_10:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4615: On-Line
    4620: On-Scene
    4625: Protocol (Standing Order)
    4630: Written Orders (Patient Specific)
  is_multi_entry: 1
  name: PROCEDURE AUTHORIZATION
  node: E19_10
E19_11:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: PROCEDURE AUTHORIZING PHYSICIAN
  node: E19_11
E19_12:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4635: Antecubital-Left
    4640: Antecubital-Right
    4645: External Jugular-Left
    4650: External Jugular-Right
    4655: Femoral-Left IV
    4660: Femoral-Left Distal IO
    4665: Femoral-Right IV
    4670: Femoral-Right IO
    4675: Forearm-Left
    4680: Forearm-Right
    4685: Hand-Left
    4690: Hand-Right
    4695: Lower Extremity-Left
    4700: Lower Extremity-Right
    4705: Other
    4710: Scalp
    4715: Sternal IO
    4720: Tibia IO-Left
    4725: Tibia IO-Right
    4730: Umbilical
  is_multi_entry: 1
  name: SUCCESSFUL IV SITE
  node: E19_12
E19_13:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4735: Auscultation of Bilateral Breath Sounds
    4740: Colormetric CO2 Detector Confirmation
    4745: Digital CO2 Confirmation
    4750: Esophageal Bulb Aspiration confirmation
    4755: Negative Auscultation of the Epigastrium
    4760: Visualization of the Chest Rising with ventilation
    4765: Visualization of Tube Passing Through the Cords
    4770: Waveform CO2 Confirmation
  is_multi_entry: 1
  name: TUBE CONFIRMATION
  node: E19_13
E19_14:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    4775: Auscultation of Bilateral Breath Sounds
    4780: Colormetric CO2 Detector Confirmation
    4785: Digital CO2 Confirmation
    4790: Esophageal Bulb Aspiration confirmation
    4795: Negative Auscultation of the Epigastrium
    4800: Visualization of the Chest Rising with ventilation
    4805: Visualization of Tube Passing Through the Cords
    4810: Waveform CO2 Confirmation
  is_multi_entry: 1
  name: DESTINATION CONFIRMATION OF TUBE PLACEMENT
  node: E19_14
YML
    }
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
        <E18_10>4490</E18_10>
        <E18_11>907</E18_11>
      </E18>
      <E19>
        <E19_01_0>
          <E19_01>2012-03-02T02:32:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>89.700</E19_03>
          <E19_05>1</E19_05>
          <E19_06>0</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4600</E19_08>
          <E19_10>4625</E19_10>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-03-02T02:38:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>-20</E19_03>
          <E19_05>1</E19_05>
          <E19_06>0</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4605</E19_08>
          <E19_10>4625</E19_10>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-03-02T02:42:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>38.992</E19_03>
          <E19_04>20 ga</E19_04>
          <E19_05>1</E19_05>
          <E19_06>0</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4605</E19_08>
          <E19_09>P031614</E19_09>
          <E19_10>4625</E19_10>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-03-02T02:44:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>38.992</E19_03>
          <E19_04>20 ga</E19_04>
          <E19_05>1</E19_05>
          <E19_06>0</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4605</E19_08>
          <E19_10>4625</E19_10>
        </E19_01_0>
        <E19_01_0>
          <E19_01>2012-03-02T02:46:00.0Z</E19_01>
          <E19_02>0</E19_02>
          <E19_03>38.992</E19_03>
          <E19_04>22 ga</E19_04>
          <E19_05>1</E19_05>
          <E19_06>0</E19_06>
          <E19_07>4500</E19_07>
          <E19_08>4605</E19_08>
          <E19_09>P031614</E19_09>
          <E19_10>4625</E19_10>
        </E19_01_0>
      </E19>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str, spec_yaml)
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
      fancy_html.should =~ /89.7/
      fancy_html.should_not =~ /Assessment-Adult/
    end
  end

end

