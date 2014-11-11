require 'nemsis'

describe Nemsis::Parser do
  context 'class methods' do
    describe '.initialize' do
      it 'returns nil with no arguments' do
        expect {
          @parser = Nemsis::Parser.new()
        }.to raise_error

        expect(@parser).to be_nil
      end
    end
  end

  describe 'Basic API Clarification' do
    let(:spec_yaml) {
      spec_yaml = <<YML
# Data [STRING]
E_STRING:
  allow_null: 0
  data_entry_method: ~
  data_type: text
  field_values: {}
  is_multi_entry: 0
  name: String
  node: E_STRING

# Data [MULTI_STRING]
E_MULTI_STRING:
  allow_null: 0
  data_entry_method: ~
  data_type: text
  field_values: {}
  is_multi_entry: 1
  name: Multiple Strings
  node: E_MULTI_STRING

# Data [INTEGER/DECIMAL]
E_NUMBER:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Numer
  node: E_NUMBER

# Data [date/time]
E_DATETIME:
  allow_null: 1
  data_entry_method: ~
  data_type: date/time
  is_multi_entry: 0
  name: Date/Time
  node: E_DATETIME

E_DATE:
  allow_null: 1
  data_entry_method: ~
  data_type: date
  is_multi_entry: 0
  name: DatE_TIME
  node: E_DATE

E_TIME:
  allow_null: 1
  data_entry_method: ~
  data_type: time
  is_multi_entry: 0
  name: Time
  node: E_TIME

# Data [combo] single-choice
E_SINGLE:
  allow_null: 1
  data_entry_method: single-choice
  data_type: text
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    700: Hours
    705: Days
    710: Months
    715: Years
  is_multi_entry: 0
  name: Single Choice
  node: E_SINGLE

E_YES_NO:
  allow_null: 1
  data_entry_method: single-choice
  data_type: text
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    0: No
    1: Yes
  is_multi_entry: 0
  name: Single Yes/No
  node: E_YES_NO

# Data [combo] Multiple Choice
E_MULTIPLE:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    500001: None
    500002: First
    500003: Second choice
    500004: Third choice
    89.700: Assessment-Adult
  is_multi_entry: 1
  name: Multiple Choice
  node: E_MULTIPLE

# Data [combo] Multiple Choice
E_ALLOW_NEGATIVE:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    500001: None
    500002: First
    500003: Second choice
    500004: Third choice
  is_multi_entry: 1
  name: Multiple Choice
  node: E_ALLOW_NEGATIVE

# Lookup from other element
E_LOOKUP:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: Protocol(s)
  lookup: E_MULTIPLE
  node: E_LOOKUP

E_TREATMENT:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: Treatment(s)
  lookup: E_MULTIPLE
  node: E_TREATMENT

YML
    }
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
      <E_STRING>My String</E_STRING>
      <E_MULTI_STRING>First of Two Strings</E_MULTI_STRING>
      <E_MULTI_STRING>Second of Two Strings</E_MULTI_STRING>
      <E_NUMBER>100</E_NUMBER>
      <E_DATETIME>2012-03-02T00:09:37.0Z</E_DATETIME>
      <E_DATE>2012-03-02T09:09:00.0Z</E_DATE>
      <E_TIME>2012-03-02T09:29:37.0Z</E_TIME>
      <E_SINGLE>705</E_SINGLE>
      <E_YES_NO>0</E_YES_NO>
      <E_MULTIPLE>500002</E_MULTIPLE>
      <E_MULTIPLE>500004</E_MULTIPLE>
      <E_MULTIPLE>Assessment-Adult</E_MULTIPLE>
      <E_LOOKUP>500003</E_LOOKUP>
      <E_TREATMENT>500002</E_TREATMENT>
      <E_TREATMENT>89.700</E_TREATMENT>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str, spec_yaml)
    }

    context 'simple parsing' do
      it('should handle strings')               { expect(p.E_STRING).to       eq('My String') }
      it('should handle multi-entry strings')   { expect(p.E_MULTI_STRING).to eq('First of Two Strings, Second of Two Strings') }
      it('should handle numbers')               { expect(p.E_NUMBER).to       eq("100") }
      it('should handle Date/Time')             { expect(p.E_DATETIME).to     eq("2012-03-01 19:09") }
      it('should handle Date')                  { expect(p.E_DATE).to         eq("2012-03-02") }
      it('should handle Time')                  { expect(p.E_TIME).to         eq("2012-03-02 04:29") }
      it('should handle Single')                { expect(p.E_SINGLE).to       eq("Days") }
      it('should handle Yes/No')                { expect(p.E_YES_NO).to       eq("No") }
      it('should handle Multiple')              { expect(p.E_MULTIPLE).to     eq("First, Third choice, Assessment-Adult") }
    end

    context 'ampersands in user-entered text' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E_STRING><E19_20>Comments Alert, 54 yo f Pt. W&D, with clear & = breath sounds......Sats @ 99% on room air.....Palpitations with Chest Tightness @ a "2"....R/O Cardiac......; Patient Response: Improved</E19_20></E_STRING>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      # ESO should remove the ampersands from the XML, as they are illegal characters
      # So I only left this in here in case Axial has to clean up the mess first.
      # 10 June 2012 -- jon
      #pending 'should preserve the ampersands' do
      #  p.E_STRING.should include('W&D')
      #  p.E_STRING.should include('clear & =')
      #end

    end

    describe 'method missing' do
      it('should treat method name as element name') { expect(p.E_STRING).to eq(p.parse_element('E_STRING')) }
      it('should pass along complex calls') { expect(p.send("concat('E_STRING', 'E_SINGLE')")).to eq("My String Days") }
    end

    context 'show negative index look-ups' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E_SINGLE>-10</E_SINGLE>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }
      it 'should show negative values' do
        expect(p.parse_element_no_filter('E_SINGLE')).to eq('Not Known')
      end

    end

    context '#lookup' do
      it 'should require an element and a key' do
        expect { p.lookup('', '') }.to raise_error
      end
      it 'should require a numeric key' do
        expect { p.lookup('', 'ABC') }.to raise_error
      end
      it 'should allow an element name' do
        expect {p.lookup('E_MULTIPLE', '500003')}.to_not raise_error
      end
      it 'should allow an element spec hash' do
        expect {p.lookup(p.get_spec('E_MULTIPLE'), '500003')}.to_not raise_error
      end
      it 'should lookup an index in specific element' do
        expect(p.lookup('E_MULTIPLE', '500003')).to eq("Second choice")
      end
      it 'should lookup CPT codes from D04_04' do
        expect(p.lookup('E_MULTIPLE', '89.700')).to eq("Assessment-Adult")
      end
      it 'should not lookup CPT codes if it is an invalid key' do
        expect(p.E_MULTIPLE).to include("Assessment-Adult")
        #p.lookup('E_MULTIPLE', 'Assessment-Adult').should == "Assessment-Adult"
      end
    end

  end

  # This is a mechanism to test the intertwined nature of the spec settings and expected results.
  context 'instance methods' do
    let(:spec_yaml) {
      spec_yaml = <<YML
D04_08:
  allow_null: 0
  data_entry_method: multiple-entry
  data_type: text
  field_values:
    6720: Abdominal Pain
    7040: Pain Control
    7130: Post Resuscitation
    7140: Pulmonary Edema
    7251: Vomiting
  is_multi_entry: 1
  name: PROTOCOL
  node: D04_08
E02_15:
  allow_null: 0
  data_entry_method: ~
  data_type: text
  is_multi_entry: 0
  name: VEHICLE DISPATCH GPS LOCATION
  node: E02_15
E02_16:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: BEGINNING ODOMETER READING OF RESPONDING VEHICLE
  node: E02_16
E02_17:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: ON-SCENE ODOMETER READING OF RESPONDING VEHICLE
  node: E02_17
E02_18:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: PATIENT DESTINATION ODOMETER READING OF RESPONDING
  node: E02_18
E02_19:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: ENDING ODOMETER READING OF RESPONDING VEHICLE
  node: E02_19
E06_01:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 0
  name: 'LAST NAME'
  node: E06_01
E06_02:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 0
  name: 'First'
  node: E06_02
E06_12:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    660: American Indian or Alaska Native
    665: Asian
    670: Black or African American
    675: Native Hawaiian or Other Pacific Islander
    680: White
    685: Other Race
  is_multi_entry: 0
  name: RACE
  node: E06_12
E06_16: 
  allow_null: 0
  data_entry_method: ~
  data_type: date
  is_multi_entry: 0
  name: DOB
  node: E06_16
E07_01:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    720: Insurance
    725: Medicaid
    730: Medicare
    735: Not Billed (for any reason)
    740: Other Government
    745: Self Pay
    750: Workers Compensation
  is_multi_entry: 0
  name: PRIMARY METHOD OF PAYMENT
  node: E07_01
E17_01:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
  is_multi_entry: 1
  name: Protocol(s)
  lookup: D04_08
  node: E17_01
E24_01:
  allow_null: 1
  data_entry_method: single-choice
  data_type: combo
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    0: No
    1: Yes
  is_multi_entry: 0
  name: 'Trauma Activation'
  node: E24_01
E24_02:
  allow_null: 1
  data_entry_method: ~
  data_type: date/time
  is_multi_entry: 1
  name: 'Date/Time'
  node: E24_02
E24_04:
  allow_null: 1
  data_entry_method: ~
  data_type: text
  is_multi_entry: 1
  name: Trauma Level
  node: E24_04
E24_05:
  allow_null: 1
  data_entry_method: multiple-choice
  data_type: combo
  field_values:
    -25: Not Applicable
    -20: Not Recorded
    -15: Not Reporting
    -10: Not Known
    -5: Not Available
    500001: None
    500002: Age < 15 or > 55
    500003: Environmental Factors
    500004: Medical Illness
    500005: Pregnancy > 3 Months
    500006: Urgent Extremity
    500007: Bleeding Disorder
    500008: Provider Suspicion
    500009: ESRD with Dialysis
  is_multi_entry: 1
  name: Other Conditions
  node: E24_05
E31_04:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Seat Row Number
  node: E31_04
E31_07:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Parking Speed (MPH)
  node: E31_07
E31_08:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Flight Speed (MPH)
  node: E31_08
E31_09:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Est. Speed (MPH)
  node: E31_09
E31_10:
  allow_null: 1
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Drivers Speed (MPH)
  node: E31_10
YML
    }
    let(:p) {
      xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06>
        <E06_01_0>
          <E06_01>BIRD</E06_01>
          <E06_02>TWEETY</E06_02>
          <E06_03>DA</E06_03>
        </E06_01_0>
        <E06_12>680</E06_12>
        <E06_16>1975-12-01</E06_16>
      </E06>
      <E07>
        <E07_01>-20</E07_01>
      </E07>
      <E02>
        <E02_16>52250.0</E02_16>
        <E02_17>52256.0</E02_17>
        <E02_18>52256.1</E02_18>
        <E02_19>52256.2</E02_19>
        <E02_20>395</E02_20>
      </E02>
      <E17>
        <E17_01>7040</E17_01>
      </E17>
      <E24>
        <E24_01>YES</E24_01>
        <E24_02>2012-03-08T17:50:00.0Z</E24_02>
        <E24_04>Level 1</E24_04>
        <E24_05>500003</E24_05>
        <E24_05>500004</E24_05>
        <E24_06>500101</E24_06>
        <E24_06>500104</E24_06>
        <E24_07>2085</E24_07>
        <E24_07>500208</E24_07>
        <E24_08>500301</E24_08>
        <E24_08>500306</E24_08>
      </E24>
      <E31>
        <E31_04>1</E31_04>
        <E31_07>0.65000</E31_07>
        <E31_08>9.10000</E31_08>
        <E31_09>90.60000</E31_09>
        <E31_10>90.10000</E31_10>
        <E31_11>2012-03-08T17:57:00.0Z</E31_11>
      </E31>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str, spec_yaml)
    }

    describe '#parse' do
      it 'should handle bad inputs' do
        expect {p.parse(nil)}.to raise_error
      end

      it 'should return an empty string for a missing data element' do
        expect(p.E25_00).to eq("")
      end

      it 'should return a string for single values' do
        expect(p.E24_04).to eq("Level 1")
      end

      it 'should return an array as a comma-separated list for multiple values' do
        expect(p.E24_05).to include "Environmental Factors"
        expect(p.E24_05).to include "Medical Illness"
      end

      it 'should return lookup value' do
        expect(p.E06_12).to eq("White")
      end

      it 'should return an integer' do
        expect(p.E31_04).to eq("1")
      end

      #it 'should return a decimal' do
      #
      #  pending "Should parser really mess with data type? Saw some bug introduced that " +
      #          "turned integer into float wrongly.  Maybe safer to return just what's" +
      #          "in the XML for numeric fields."
      #  p.E31_07.should == "0.65"
      #  p.E31_08.should == "9.1"
      #  p.E31_09.should == "91"
      #  p.E31_10.should == "90"
      #  p.E02_16.should == "52250.0"
      #end

      it 'should return string by default' do
        expect(p.parse('E24_02')).to eq('2012-03-08 12:50')
      end

      it 'should return object (i.e. time) if requested' do
        result = p.parse('E24_02', 'object')

        expect(result.class).to eql(ActiveSupport::TimeWithZone)
        expect(result.in_time_zone('UTC').strftime("%F %T %z")).to eq('2012-03-08 17:50:00 +0000')
      end

      it 'should return raw data if requested' do
        expect(p.parse('E06_12', 'raw')).to eq('680')
      end

      it 'should return date-only value without doing timezone conversion' do
        expect(p.parse('E06_16')).to eq(p.parse('E06_16', 'raw'))
      end
    end

    describe '#get_spec' do
      it 'should return a spec hash for the given element' do
        expect(p.get_spec('E06_12').class).to eq(Hash)
        expect(p.get_spec('E06_12')['data_type']).to eq('combo')
        expect(p.get_spec('E06_12')['data_entry_method']).to eq('single-choice National Element')
      end

      it 'should return nil for a non-existent node' do
        expect(p.get_spec('F00')).to be_nil
      end
    end

    describe '#get_node_name' do
      it 'should return a name for the given element' do
        expect(p.get_node_name('E06_12').class).to eq(String)
        expect(p.get_node_name('E06_12')).to eq('E06_12')
      end

      it 'should return nil for a non-existent node' do
        expect(p.get_node_name('F00')).to be_nil
      end
    end

    describe 'method missing' do
      it 'should treat method name as element name' do
        expect(p.E06_01).to eq(p.parse_element('E06_01'))
      end

      it 'should pass along complex calls' do
        expect(p.send("concat('E06_02', 'E06_01')")).to eq("TWEETY BIRD")
      end

    end

    describe '#lookup' do
      it 'should lookup a value in using another element' do
        expect(p.E17_01).to eq("Pain Control")
      end
    end

    describe '#parse_element' do
      it 'should return string for non-coded element' do
        expect(p.parse_element('E06_01')).to eq('BIRD')
      end

      it 'should return string for coded element' do
        expect(p.parse_element('E06_12')).to eq('White')
      end

      it 'should return nil for default negative values' do
        expect(p.parse_element('E07_01')).to eq('')
      end

      it 'should return value for negative indexes' do
        expect(p.parse('E07_01', 'object', false)).to eq('Not Recorded')
      end
      it 'should return value for negative indexes' do
        expect(p.parse_element_no_filter('E07_01')).to eq('Not Recorded')
      end

      it 'should return lookup value' do
        expect(p.parse_element('E24_01')).to eq("YES")
      end
    end

    describe '#get' do
      it 'should return key/value hash' do
        expect(p.get('E06_01').class).to eq(Hash)
      end

      it 'should return key/value element name' do
        expect(p.get('E06_01')[:name]).to eq("LAST NAME")
      end

      it 'should return key/value element text value' do
        expect(p.get('E06_01')[:value]).to eq("BIRD")
      end

      it 'should return key/value element lookup value' do
        expect(p.get('E24_01')[:value]).to eq("YES")
      end
    end

    describe '#name' do
      it "should return the name" do
        expect(p.name('E06_01')).to eq("LAST NAME")
        expect(p.name('E06_02')).to eq("First")
      end
    end

    describe '#index' do
      it "should return the index into the lookup table" do
        expect(p.index('E24_05')).to eq("500003")
      end
    end
  end

  context 'express supplied kg weight in pounds' do
    let(:spec_yaml) {
      spec_yaml = <<YML
E16_01:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Weight (kg)
  node: E16_01
E16_88:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Weight in Pounds
  node: E16_88
YML
    }
    context 'for a baby' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E16_01>6</E16_01>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should show lbs with a decimal place & kg' do
        expect(p.weight_in_words()).to eq('13.2 lbs - 6 kg')
      end
    end

    context 'for an adult' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E16_01>122</E16_01>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should show lbs & kg' do
        expect(p.weight_in_words()).to eq('269 lbs - 122 kg')
      end
    end

    context 'with weight in pounds provided' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E16_01>66</E16_01>
      <E16_88>145</E16_88>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should show lbs & kg' do
        expect(p.weight_in_words()).to eq('145 lbs - 66 kg')
      end
    end


  end

  context 'expressing age in words' do
    let(:spec_yaml) {
      spec_yaml = <<YML
E06_14:
  allow_null: 1
  data_entry_method: National Element
  data_type: number
  is_multi_entry: 0
  name: Age
  node: E06_14
E06_15:
  allow_null: 1
  data_entry_method: single-choice National Element
  data_type: combo
  field_values:
    -10: Not Known
    -15: Not Reporting
    -20: Not Recorded
    -25: Not Applicable
    -5: Not Available
    700: Hours
    705: Days
    710: Months
    715: Years
  is_multi_entry: 0
  name: Age Units
  node: E06_15
E06_16:
  allow_null: 0
  data_entry_method: ~
  data_type: date
  is_multi_entry: 0
  name: DOB
  node: E06_16
YML
    }

    context 'incident time missing' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06_14_0>
        <E06_14>76</E06_14>
        <E06_15>715</E06_15>
      </E06_14_0>
      <E06_16>"#{3.months.ago.strftime("%Y-%m-%d")}"</E06_16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age in words in months' do
        expect(p.age_in_words).to eq("3 Months")
      end
    end

    context 'incident time provided' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E05>
        <E05_01>2012-03-01T18:41:05.0Z</E05_01>
        <E05_02>"#{1.months.ago.strftime("%Y-%m-%dT%H:%M:%S\.0Z")}"</E05_02>
        <E05_03>2012-03-01T05:00:00.0Z</E05_03>
        <E05_04>2012-03-01T18:41:05.0Z</E05_04>
        <E05_05>2012-03-01T18:41:10.0Z</E05_05>
        <E05_06>2012-03-01T18:50:15.0Z</E05_06>
        <E05_07>2012-03-01T18:51:00.0Z</E05_07>
        <E05_08>2012-03-01T19:25:00.0Z</E05_08>
        <E05_09>2012-03-01T19:02:35.0Z</E05_09>
        <E05_10>2012-03-01T19:16:54.0Z</E05_10>
        <E05_11>2012-03-01T20:01:44.0Z</E05_11>
        <E05_12 xsi:nil="true" />
        <E05_13>2012-03-01T20:01:49.0Z</E05_13>
        <E05_14>2012-03-01T18:41:05.0Z</E05_14>
      </E05>
      <E06_14_0>
      <E06_14>13</E06_14>
          <E06_15>715</ E06_15>
      </E06_14_0>
      <E06_16>"#{2.months.ago.strftime("%Y-%m-%d")}"</E06_16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }
      it 'should return age in words in weeks' do
        expect(p.age_in_words).to match(/8 Weeks/)
      end

    end

    context 'dob missing, use E06_14 and E06_15' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06_14_0>
        <E06_14>46</E06_14>
        <E06_15>705</E06_15>
      </E06_14_0>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age in words based on entered age (not DOB)' do
        expect(p.age_in_words).to match(/46 days/i)
      end
    end

    context 'all age info missing' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06_14_0>
      </E06_14_0>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age unknown when no data exists' do
        expect(p.age_in_words).to match(/Age Unavailable/i)
      end
    end

    context 'screwed up dob should fail gracefully' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06_14_0>
        <E06_14>76</E06_14>
        <E06_15>715</E06_15>
      </E06_14_0>
      <E06_16>1988-28-28</E06_16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age as entered when DOB is illegal format' do
        expect(p.age_in_words).to match(/76 years/i)
      end
    end

  end

  context 'handling dates and times' do
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
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E24>
        <E24_01>2012-03-08T17:50:01.0Z</E24_01>
        <E24_02>2012-03-08T17:50:02.0Z</E24_02>
        <E24_03>2012-03-08T17:50:03.0Z</E24_03>
      </E24>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      describe 'date/time format should be based on data type by default' do
        it 'should return a full date/time value' do
          expect(p.E24_01).to eq("2012-03-08 12:50")
        end

        it 'should return a date value' do
          expect(p.E24_02).to eq("2012-03-08")
        end

        it 'should return a time value' do
          # Nemsis::Parser should not be stripping any part of the date/time
          # if needed to display as time string, that is a display requirement
          # which should be handled in view helpers
          expect(p.E24_03).to eq("2012-03-08 12:50")
        end
      end

      describe 'overriding date/time format' do
        context 'date/time data type' do
          it 'should return a full date/time value' do
            expect(p.parse_time('E24_01', true)).to eq("2012-03-08 12:50")
          end
          
          it 'should return a date value' do
            expect(p.parse_date('E24_01')).to eq("2012-03-08")
          end

          it 'should return a short date value (no year)' do
            expect(p.parse_date('E24_01', false)).to eq("03-08")
          end

          it 'should return a time value' do
            expect(p.parse_time('E24_01')).to eq("12:50")
          end
        end

        context 'optionally show seconds' do
          it 'should show full date and time with seconds' do
            expect(p.parse_time('E24_01', true, true)).to eq("2012-03-08 12:50:01")
          end
          it 'should show time with seconds' do
            expect(p.parse_time('E24_03', false, true)).to eq("12:50:03")
          end
        end

        context 'date data type' do
          it 'should not return a full date/time value' do
            expect(p.parse_time('E24_02', true)).not_to eq("2012-03-08 12:50")
          end

          it 'should return a date value' do
            expect(p.parse_date('E24_02')).to eq("2012-03-08")
          end

          it 'should not return a time value' do
            expect(p.parse_time('E24_02')).not_to eq("12:50")
          end
        end

        context 'time data type' do
          it 'should return a full date/time value' do
            expect(p.parse_time('E24_03', true)).to eq("2012-03-08 12:50")
          end

          it 'should not return a date value' do
            expect(p.parse_date('E24_03')).to eq("2012-03-08")
          end

          it 'should return a time value' do
            expect(p.parse_time('E24_03')).to eq("12:50")
          end
        end
    end
  end

  context 'instance methods' do
    let(:p) {
      xml_str         = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06>
        <E06_01_0>
          <E06_01>BIRD</E06_01>
          <E06_02>TWEETY</E06_02>
          <E06_03>DA</E06_03>
        </E06_01_0>
        <E06_12>680</E06_12>
      </E06>
      <E07>
        <E07_01>-20</E07_01>
        <E07_15>0</E07_15>
        <E07_34>-20</E07_34>
        <E07_35_0>
          <E07_35>-20</E07_35>
        </E07_35_0>
      </E07>
      <E08>
        <E08_03>1100</E08_03>
        <E08_05>1125</E08_05>
        <E08_06>0</E08_06>
        <E08_07>1175</E08_07>
        <E08_11_0>
          <E08_11>4500 Blue RidgeRd</E08_11>
          <E08_14>37</E08_14>
          <E08_15>27604</E08_15>
        </E08_11_0>
      </E08>
      <E14>
        <E14_01>2012-03-08T18:45:00.0Z</E14_01>
      </E14>
      <E15>
        <E15_01>3340</E15_01>
        <E15_05>3340</E15_05>
        <E15_11>-20</E15_11>
        <E15_13>3345</E15_13>
      </E15>
      <E16>
        <E16_01>1</E16_01>
        <E16_00_0>
          <E16_03>2012-03-08T17:48:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
          <E16_06>3505</E16_06>
          <E16_07>3535</E16_07>
          <E16_08>3600</E16_08>
          <E16_09>3615</E16_09>
          <E16_10>3645</E16_10>
          <E16_11>3675</E16_11>
          <E16_12>3710</E16_12>
          <E16_13>3740</E16_13>
          <E16_14>3770</E16_14>
          <E16_15>3795</E16_15>
          <E16_16>3820</E16_16>
          <E16_17>3850</E16_17>
          <E16_17>3855</E16_17>
          <E16_17>3860</E16_17>
          <E16_17>3870</E16_17>
          <E16_18>3885</E16_18>
          <E16_18>3890</E16_18>
          <E16_18>3895</E16_18>
          <E16_18>3905</E16_18>
          <E16_19>3920</E16_19>
          <E16_19>3925</E16_19>
          <E16_19>3930</E16_19>
          <E16_19>3940</E16_19>
          <E16_20>3955</E16_20>
          <E16_20>3960</E16_20>
          <E16_20>3965</E16_20>
          <E16_20>3975</E16_20>
          <E16_21>3980</E16_21>
          <E16_22>4030</E16_22>
          <E16_23>4085</E16_23>
          <E16_24>4130</E16_24>
          <E16_28>thats gotta hurt</E16_28>
          <E16_34>6403</E16_34>
          <E16_34>6409</E16_34>
          <E16_34>6415</E16_34>
          <E16_34>6419</E16_34>
          <E16_34>8495</E16_34>
          <E16_35>8501</E16_35>
          <E16_35>8507</E16_35>
          <E16_35>8513</E16_35>
          <E16_35>8517</E16_35>
        </E16_00_0>
        <E16_00_0>
          <E16_03>2012-03-08T18:50:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
          <E16_06>3505</E16_06>
          <E16_07>3535</E16_07>
          <E16_08>3600</E16_08>
          <E16_09>3620</E16_09>
          <E16_10>3650</E16_10>
          <E16_11>3680</E16_11>
          <E16_12>3710</E16_12>
          <E16_13>3740</E16_13>
          <E16_14>3770</E16_14>
          <E16_15>3795</E16_15>
          <E16_16>3820</E16_16>
          <E16_17>3845</E16_17>
          <E16_18>3880</E16_18>
          <E16_19>3915</E16_19>
          <E16_20>3950</E16_20>
          <E16_21>3980</E16_21>
          <E16_22>4030</E16_22>
          <E16_23>4085</E16_23>
          <E16_24>4130</E16_24>
          <E16_32>testing comments</E16_32>
        </E16_00_0>
      </E16>
      <E23>
        <E23_01>-20</E23_01>
        <E23_05>0</E23_05>
        <E23_06>5540</E23_06>
        <E23_06>5575</E23_06>
        <E23_07>5590</E23_07>
        <E23_07>5595</E23_07>
        <E23_08>0</E23_08>
        <E23_09_0>
          <E23_11>DestinationAddress2</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09></E23_09>
          <E23_11>IncidentAddress2</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>123123212</E23_09>
          <E23_11>Patient Number</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>1232123^1231231</E23_09>
          <E23_11>Hospital Chart Number</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>A- 24</E23_09>
          <E23_11>Shift</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>Advanced Life Support</E23_09>
          <E23_11>Level of Service</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>Bystander</E23_09>
          <E23_11>Requested By</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>DE3968F0-688F-4FE6-B0EF-A00E014BCBA4</E23_09>
          <E23_11>ESOHDE_EnterpriseKey</E23_11>
        </E23_09_0>
        <E23_09_0>
          <E23_09>Trauma</E23_09>
          <E23_11>MedicalTrauma</E23_11>
        </E23_09_0>
        <E23_10>P038756</E23_10>
      </E23>
      <E24>
        <E24_01>YES</E24_01>
        <E24_02>2012-03-08T17:50:00.0Z</E24_02>
        <E24_04>Level 1</E24_04>
        <E24_05>500003</E24_05>
        <E24_05>500004</E24_05>
        <E24_06>500101</E24_06>
        <E24_06>500104</E24_06>
        <E24_07>2085</E24_07>
        <E24_07>500208</E24_07>
        <E24_08>500301</E24_08>
        <E24_08>500306</E24_08>
      </E24>
      <E25>
        <E25_01>Class 1</E25_01>
        <E25_02>Grade 2</E25_02>
        <E25_03>500403</E25_03>
        <E25_03>500404</E25_03>
      </E25>
      <E29>
        <E29_03>2390</E29_03>
      </E29>
      <E31>
        <E31_04>1</E31_04>
        <E31_09>90.00000</E31_09>
        <E31_11>2012-03-08T17:57:00.0Z</E31_11>
      </E31>
      <E32>
        <E32_01>99</E32_01>
        <E32_05>2012-03-20T04:00:00.0Z</E32_05>
        <E32_10>2012-03-06T05:00:00.0Z</E32_10>
        <E32_28>2</E32_28>
      </E32>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str)
    }

    describe '#parse_field' do
      it 'should parse element by full name in nemsis data dictionary (case insensitive)' do
        expect(p.parse_field('CHIEF COMPLAINT')).to eq(p.E09_05)
      end

      it 'should return the first instance when there are multiple result sets' do
        expect(p.parse_field('CREW MEMBER ID')).to eq(p.E04_01)
      end

      it 'will pick up the first node when there are duplicate node names' do
        expect(p.parse_field('last name')).not_to eq(p.E06_01)
        expect(p.parse_field('last name')).to eq(p.E04_04)
      end
      it 'should parse element by full name in nemsis data dictionary (case insensitive)' do
        expect(p.parse_field('12 LEAD I')).to eq(p.E28_07)
        expect(p.parse_field('12 Lead I')).to eq(p.E28_07)
      end
    end

    describe '#parse_pair' do
      it 'should return hash' do
        result = p.parse_pair('E23_11', 'E23_09')
        expect(result.is_a?(Hash)).to be_truthy
        expect(result['Patient Number']).to eq('123123212')
      end
      it 'should return an empty hash when no data exists' do
        result = p.parse_pair('E33_11', 'E33_09')
        expect(result.is_a?(Hash)).to be_truthy
        expect(result).to be_empty
      end
    end

    describe '#parse_value_of' do
      it 'should return value E23_09 of key E23_11' do
        expect(p.parse_value_of('Patient Number')).to eq('123123212')
      end

      it 'should return empty info when none exists' do
        expect(p.parse_value_of('BugsBunny')).to eq('&nbsp;')
      end
    end

    describe '#parse_cluster' do
      let(:p2) {
        xml_str = <<XML
<?xml version=" 1.0 " encoding=" UTF-8 " ?>
<EMSDataSet xmlns=" http ://www.nemsis.org " xmlns:xsi=" http ://www.w3.org/2001/XMLSchema-instance "
            xsi:schemaLocation=" http ://www.nemsis.org http ://www.nemsis.org/media/XSD/EMSDataSet.xsd ">
  <Header>
    <Record>
      <E14>
        <E14_01>2012-03-08T15:30:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_04_0>
          <E14_06>3165</E14_06>
        </E14_04_0>
        <E14_10>3180</E14_10>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>3</E14_16>
          <E14_17>5</E14_17>
          <E14_18>3220</E14_18>
        </E14_15_0>
        <E14_20_0>
          <E14_20>38.89</E14_20>
          <E14_21>3235</E14_21>
        </E14_20_0>
        <E14_22>3255</E14_22>
        <E14_24>3285</E14_24>
        <E14_26>2</E14_26>
        <E14_29></E14_29>
        <E14_30></E14_30>
        <E14_32>-20</E14_32>
      </E14>
      <E14>
        <E14_01>2012-03-08T15:35:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>92</E14_08>
        <E14_10>3175</E14_10>
        <E14_12>3185</E14_12>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>5</E14_16>
          <E14_17>6</E14_17>
        </E14_15_0>
        <E14_22>3255</E14_22>
      </E14>
      <E14>
        <E14_01>2012-03-08T15:40:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>72</E14_08>
        <E14_10>3175</E14_10>
        <E14_12>3185</E14_12>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>5</E14_16>
          <E14_17>6</E14_17>
        </E14_15_0>
        <E14_22>3255</E14_22>
      </E14>
      <E14>
        <E14_01>2012-03-08T15:45:00.0Z</E14_01>
        <E14_02>0</E14_02>
        <E14_03>3070</E14_03>
        <E14_04_0>
          <E14_06>3155</E14_06>
        </E14_04_0>
        <E14_08>75</E14_08>
        <E14_10>3175</E14_10>
        <E14_12>3185</E14_12>
        <E14_15_0>
          <E14_15>4</E14_15>
          <E14_16>5</E14_16>
          <E14_17>6</E14_17>
        </E14_15_0>
        <E14_22>3255</E14_22>
      </E14>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }
      let(:results) {p2.parse_cluster('E14')}

      it 'should return arrays of Nemsis::Parser for an element name' do
        expect(results.is_a?(Array)).to be_truthy
        expect(results.size).to eq(4)
        expect(results.first.class).to eq(Nemsis::Parser)
      end

      it 'should allow you to get the same elements from each parser instance' do
        expect(results[0].E14_01).to eq("2012-03-08 10:30")
        expect(results[1].E14_01).to eq("2012-03-08 10:35")
        expect(results[2].E14_01).to eq("2012-03-08 10:40")
        expect(results[3].E14_01).to eq("2012-03-08 10:45")
      end

    end

    describe '#parse_city' do
      context 'valid code' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
        <E08_11_0><E08_11>5900 POYNER ANCHOR LN</E08_11>
          <E08_12>55100</E08_12>
          <E08_14>37</E08_14>
          <E08_15>27616</E08_15>
        </E08_11_0>
        <E06_06>37175</E06_06>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)

        }
        it 'should return the city for a valid code' do
          expect(p2.parse_city('E08_12')).to eq('Randleman Junction')
        end
        it 'should return the state for a valid code' do
          expect(p2.parse_state('E08_14')).to eq('NC')
        end
        it 'should return the county for a valid code' do
          expect(p2.parse_county('E06_06')).to eq('Transylvania')
        end

      end
      context 'invalid code' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
        <E08_11_0><E08_11>5900 POYNER ANCHOR LN</E08_11>
          <E08_14>137</E08_14>
          <E08_12>95100</E08_12>
          <E08_15>27616</E08_15>
        </E08_11_0>
        <E06_06>137183</E06_06>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)

        }
        it 'should return the city code when lookup fails' do
          expect(p2.parse_city('E08_12')).to eq('City not found for 95100')
        end
        it 'should return the state code when lookup fails' do
          expect(p2.parse_state('E08_14')).to eq('State not found for 137')
        end
        it 'should return the county code when lookup fails' do
          expect(p2.parse_county('E06_06')).to eq('County not found for 137183')
        end

      end
      context 'missing data element' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
        <E08_11_0><E08_11>5900 POYNER ANCHOR LN</E08_11>
          <E08_15>27616</E08_15>
        </E08_11_0>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)

        }
        it 'should return &nbsp; when XML is missing city field' do
          expect(p2.parse_city('E08_12')).to eq('&nbsp;')
        end
        it 'should return &nbsp; when XML is missing state field' do
          expect(p2.parse_state('E08_14')).to eq('&nbsp;')
        end
        it 'should return &nbsp; when XML is missing county field' do
          expect(p2.parse_county('E06_06')).to eq('&nbsp;')
        end

      end
    end

    describe '#get_children' do
      let(:p2) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E04>
        <E04_02>585</E04_02>
        <E04_03>-20</E04_03>
        <E04_04>TECH SUPPORT</E04_04>
        <E04_05>ESO</E04_05>
      </E04>
      <E04>
        <E04_01>P038756</E04_01>
        <E04_02>580</E04_02>
        <E04_03>6110</E04_03>
        <E04_04>ADAMS</E04_04>
        <E04_05>CHRISTOPHER</E04_05>
      </E04>
      <E04>
        <E04_01>P021554</E04_01>
        <E04_02>585</E04_02>
        <E04_03>6110</E04_03>
        <E04_04>LIPPERT</E04_04>
        <E04_05>REBECCA</E04_05>
      </E04>
      <E04>
        <E04_01>P079008</E04_01>
        <E04_02>580</E04_02>
        <E04_03>6090</E04_03>
        <E04_04>BOLDEN</E04_04>
        <E04_05>CHRISTOPHER</E04_05>
      </E04>
      <E04>
        <E04_01>1234</E04_01>
        <E04_02>585</E04_02>
        <E04_03>-20</E04_03>
        <E04_04>DANE</E04_04>
        <E04_05>NICOLE</E04_05>
      </E04>
      <E18>
        <E18_09>P021554</E18_09>
      </E18>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)

      }
      let(:results) { p2.get_children('E04') }

      it "should return an array of records" do
        expect(results.is_a?(Array)).to be_truthy
        expect(results.size).to eq(5)
      end

      it "should have each spec element available" do
        expect(results[0]['E04_01']).to eq("")
        expect(results[0]['E04_02']).to eq("Primary Patient Caregiver")
        expect(results[0]['E04_03']).to eq("")
        expect(results[0]['E04_04']).to eq("TECH SUPPORT")
        expect(results[0]['E04_05']).to eq("ESO")

        expect(results[1]['E04_01']).to eq("P038756")
        expect(results[1]['E04_02']).to eq("Driver")
        expect(results[1]['E04_03']).to eq("EMT-Paramedic")
        expect(results[1]['E04_04']).to eq("ADAMS")
        expect(results[1]['E04_05']).to eq("CHRISTOPHER")
      end

      #it 'provider name lookup' do
      #  pending "Nemsis::Parser#provider_name_lookup deprecated 5/16/2012 GC"
      #
      #  it 'should return provider name for the given ID' do
      #    p2.get_provider_name('P079008').should == 'Christopher Bolden'
      #  end
      #
      #  it 'should return provider name for the given numeric-only ID' do
      #    p2.get_provider_name('1234').should == 'Nicole Dane'
      #  end
      #
      #  it 'should return the ID as the provider name for an unknown ID' do
      #    p2.get_provider_name('X079008').should == 'X079008'
      #  end
      #
      #  it 'should return provider name for the given Data Element' do
      #    p2.get_provider_name('E18_09').should == 'Rebecca Lippert'
      #  end
      #end

      it 'should return arrays of Nemsis::Parser for a element name' do
        results = p.parse_cluster('E14')
        expect(results.is_a?(Array)).to be_truthy
        expect(results.first.is_a?(Nemsis::Parser)).to be_truthy
      end

    end

    describe '#parse_clusters' do
      it 'should return arrays of Nemsis::Parser for multiple element names' do
        results = p.parse_clusters('E15', 'E16')
        expect(results.is_a?(Array)).to be_truthy
        expect(results.first.is_a?(Nemsis::Parser)).to be_truthy
      end
    end

    describe '#parse_assessments' do
      let(:p2) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E15>
        <E15_01>3340</E15_01>
        <E15_05>3340</E15_05>
        <E15_11>-20</E15_11>
        <E15_13>3345</E15_13>
      </E15>
      <E16>
        <E16_01>1</E16_01>
        <E16_00_0>
          <E16_03>2012-03-08T17:48:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
        </E16_00_0>
        <E16_00_0>
          <E16_03>2012-03-08T18:50:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
          <E16_06>3505</E16_06>
          <E16_07>3535</E16_07>
          <E16_08>3600</E16_08>
        </E16_00_0>
      </E16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }

      it 'should return assessments in chronological order' do
        results = p2.parse_assessments
        expect(results.is_a?(Array)).to be_truthy

        initial_assessment = results.first
        expect(initial_assessment.is_a?(Nemsis::Parser)).to be_truthy
        expect(initial_assessment.xml_doc.root.name).to eq('E15_E16')
        expect(initial_assessment.E16_03).to eq('2012-03-08 12:48')

        ongoing_assessments = results[1..-1]
        expect(ongoing_assessments.first).to be_truthy
        expect(ongoing_assessments.first.is_a?(Nemsis::Parser)).to be_truthy
        expect(ongoing_assessments.first.xml_doc.root.name).to eq('E16_00_0')
      end
    end

    describe '#parse_assessments with spotty assessment data' do
      context 'missing E15 details' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E16>
        <E16_01>1</E16_01>
        <E16_00_0>
          <E16_03>2012-03-08T17:48:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
        </E16_00_0>
        <E16_00_0>
          <E16_03>2012-03-08T18:50:00.0Z</E16_03>
          <E16_04>3425</E16_04>
          <E16_05>3475</E16_05>
          <E16_06>3505</E16_06>
          <E16_07>3535</E16_07>
          <E16_08>3600</E16_08>
        </E16_00_0>
      </E16>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)
        }

        it 'should be well-behaved' do
          expect {
            p2.parse_assessments
          }.to_not raise_error

          results = p2.parse_assessments
          expect(results.is_a?(Array)).to be_truthy
        end
      end
            context 'missing E16_00_0 details' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E15>
        <E15_01>3340</E15_01>
        <E15_05>3340</E15_05>
        <E15_11>-20</E15_11>
        <E15_13>3345</E15_13>
      </E15>
      <E16>
        <E16_01>1</E16_01>
      </E16>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)
        }

        it 'should be well-behaved' do
          expect {
            p2.parse_assessments
          }.to_not raise_error

          results = p2.parse_assessments
          expect(results.is_a?(Array)).to be_truthy
        end
      end

      context 'missing E15 & E16 data' do
        let(:p2) {
          xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
    </Record>
  </Header>
</EMSDataSet>
XML
          Nemsis::Parser.new(xml_str)
        }

        it 'should be well-behaved' do
          expect {
            p2.parse_assessments
          }.to_not raise_error

          results = p2.parse_assessments
          expect(results.is_a?(Array)).to be_truthy
        end
      end
    end

    describe '#concat' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E04>
        <E04_02>585</E04_02>
        <E04_03>-20</E04_03>
        <E04_04>TECH SUPPORT</E04_04>
        <E04_05>ESO</E04_05>
      </E04>
      <E09>
        <E09_17>Generalized Symptoms-Nausea and Vomiting</E09_17>
        <E09_18>Generalized Symptoms-Dehydration</E09_18>
        <E09_18>GI/GU-Diarrhea</E09_18>
      </E09>
      <E15>
        <E15_02>-10</E15_02>
        <E15_03>3325</E15_03>
        <E15_04>3335</E15_04>
        <E15_05>3335</E15_05>
      </E15>
      <E16>
        <E16_05>3475</E16_05>
      </E16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }

      it 'should concatenate field values for multiple entries' do
        expect(p.concat('E04_05', 'E04_04')).to eq("ESO TECH SUPPORT")
      end

      it 'should concatenate field values for multiple fields of same element' do
        expect(p.concat('E09_17', 'E09_18')).to eq("Generalized Symptoms-Nausea and Vomiting Generalized Symptoms-Dehydration GI/GU-Diarrhea")
      end

      it 'should return empty when there are no data' do
        expect(p.concat('E12_08', 'E12_09')).to eq("")
      end

      it 'should remove "Not Assessed" if other fields contains valid value' do
        expect(p.concat('E16_05', 'E15_02', 'E15_03')).to eq('Bleeding Controlled')
      end

      it 'should leave "Not Assessed" if it is the only value' do
        expect(p.concat('E16_05' )).to eq('Not Assessed')
      end

      it 'should remove duplicate values' do
        expect(p.concat('E16_05', 'E15_03', 'E15_04', 'E15_05')).to eq('Bleeding Controlled Burn')
      end
    end

    describe '#has_content' do
      let(:p2) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
<Header>
<Record>
<E02><E02_01>092054799999999</E02_01>
<E02_02>013653</E02_02>
<E02_03>EMS10</E02_03>
<E02_04>30</E02_04>
<E02_05>75</E02_05>
<E02_06>-20</E02_06>
<E02_07>150</E02_07>
<E02_08>-20</E02_08>
<E02_09>-20</E02_09>
<E02_10>345</E02_10>
<E02_11>188101</E02_11>
<E02_12>EMS10</E02_12>
<E02_16>131511.8</E02_16>
<E02_17>131514.2</E02_17>
<E02_18>131520.0</E02_18>
<E02_19>131520.1</E02_19>
<E02_20>390</E02_20>
<E02_21>013653</E02_21>
<E02_22>EMS10</E02_22>
<E02_23>911 Response (Emergency)</E02_23>
<E02_24>None</E02_24>
<E02_27>188101</E02_27>
</E02>
<E20_03>10000 Falls of Neuse Rd</E20_03>
<E23>
<E23_01>-20</E23_01>
<E23_05>0</E23_05>
</E23>
<E34><E34_01>1</E34_01>
<E34_02>1</E34_02>
<E34_03>0</E34_03>
<E34_04>1</E34_04>
<E34_05>-20</E34_05>
<E34_06>1</E34_06>
</E34>
<E35></E35>
</Record>
</Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }

      context 'Single Values' do
        it 'should be true when data values exist' do
          expect(p2.has_content('E20_03')).to eq(true)
        end

        it 'should be false when no data values exist' do
          expect(p2.has_content('E23_02')).to eq(false)
        end

        it 'should be false for -NN lookup value' do
          expect(p2.has_content('E23_01')).to eq(false)
        end
      end

      context 'Entire range of elements' do
        it 'should be true when data values exist' do
          expect(p2.has_content('E02')).to eq(true)
        end
        it 'should be true when data values exist' do
          expect(p2.has_content('E34')).to eq(true)
        end

        it 'should be false when no data values exist' do
          expect(p2.has_content('E35')).to eq(false)
        end
      end
    end

  end

  describe 'validate_key!' do
    it 'should accept normal integers' do
      expect(Nemsis::Parser.validate_key!("50003")).to eq(50003)
    end
    it 'should accept CPT codes' do
      expect(Nemsis::Parser.validate_key!("89.700")).to eq(89.7)
    end
    it 'should accept strings' do
      expect(Nemsis::Parser.validate_key!("Hot")).to eq("Hot")
    end
    it 'should not accept nils' do
      expect(Nemsis::Parser.validate_key!(nil)).to be_nil
    end
  end


  describe 'nokogiri larnin' do
    it 'should do what i mean, not what I say!' do
      xml_str = <<XML
<root>
  <sitcoms>
    <sitcom>
      <name>Married with Children</name>
      <E04>
        <character>Al Bundy</character>
        <character>Bud Bundy</character>
        <character>Marcy Darcy</character>
      </E04>
    </sitcom>
    <sitcom>
      <name>Perfect Strangers</name>
      <E04>
        <character>Larry Appleton</character>
        <character>Balki Bartokomous</character>
      </E04>
    </sitcom>
  </sitcoms>
  <dramas>
    <drama>
      <name>The A-Team</name>
      <E04>
        <character>John " Hannibal " Smith</character>
        <character>Templeton " Face " Peck</character>
        <character>" B.A. " Baracus</character>
        <character>" Howling Mad " Murdock</character>
      </E04>
    </drama>
  </dramas>
</root
XML
      xml_doc = Nokogiri::XML(xml_str)
      nodes   = xml_doc.xpath('//E04')
      #puts nodes.count
      results = []
      nodes.each_with_index do |node, i|
        #puts "node ##{i+1}: #{node.name}"
        c = 0

        node.children.each do |child|
          #puts "\tChild ##{c+=1}: #{child.name}=> #{child.text}" if child.is_a?(Nokogiri::XML::Element)
        end
      end

    end
  end
end
