require 'nemsis'

describe Nemsis::Parser do
  context 'class methods' do
    describe '.initialize' do
      it 'returns nil with no arguments' do
        expect {
          @parser = Nemsis::Parser.new()
        }.to raise_error
        @parser.should be_nil
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
      <E_NUMBER>100</E_NUMBER>
      <E_DATETIME>2012-03-02T00:09:37.0Z</E_DATETIME>
      <E_DATE>2012-03-02T09:09:00.0Z</E_DATE>
      <E_TIME>2012-03-02T09:29:37.0Z</E_TIME>
      <E_SINGLE>705</E_SINGLE>
      <E_YES_NO>0</E_YES_NO>
      <E_MULTIPLE>500002</E_MULTIPLE>
      <E_MULTIPLE>500004</E_MULTIPLE>
      <E_LOOKUP>500003</E_LOOKUP>
    </Record>
  </Header>
</EMSDataSet>
XML
      Nemsis::Parser.new(xml_str, spec_yaml)
    }

    context 'simple parsing' do
      it('should handle strings')   { p.E_STRING.should    == 'My String' }
      it('should handle numbers')   { p.E_NUMBER.should    == "100" }
      it('should handle Date/Time') { p.E_DATETIME.should  == "2012-03-01 19:09" }
      it('should handle Date')      { p.E_DATE.should      == "2012-03-02" }
      it('should handle Time')      { p.E_TIME.should      == "04:29" }
      it('should handle Single')    { p.E_SINGLE.should    == "Days" }
      it('should handle Yes/No')    { p.E_YES_NO.should    == "No" }
      it('should handle Multiple')  { p.E_MULTIPLE.should  == "First, Third choice" }
    end
    describe 'method missing' do
      it('should treat method name as element name') { p.E_STRING.should == p.parse_element('E_STRING') }
      it('should pass along complex calls') { p.send("concat('E_STRING', 'E_SINGLE')").should == "My String Days" }
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
        p.parse_element_no_filter('E_SINGLE').should == 'Not Known'
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
        p.lookup('E_MULTIPLE', '500003').should == "Second choice"
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
        expect {p.parse(nil)}.should raise_error
      end

      it 'should return an empty string for a missing data element' do
        p.E25_00.should == ""
      end

      it 'should return a string for single values' do
        p.E24_04.should == "Level 1"
      end

      it 'should return an array as a comma-separated list for multiple values' do
        p.E24_05.should include "Environmental Factors"
        p.E24_05.should include "Medical Illness"
      end

      it 'should return lookup value' do
        p.E06_12.should == "White"
      end

      it 'should return an integer' do
        p.E31_04.should == "1"
      end

      it 'should return a decimal' do
        p.E31_07.should == "0.65"
        p.E31_08.should == "9.1"
        p.E31_09.should == "91"
        p.E31_10.should == "90"
        p.E02_16.should == "52250.0"
      end

      it 'should return string by default' do
        p.parse('E24_02').should == '2012-03-08 12:50'
      end

      it 'should return object (i.e. time) if requested' do
        result = p.parse('E24_02', 'object')

        result.class.should eql(ActiveSupport::TimeWithZone)
        result.in_time_zone('UTC').strftime("%F %T %z").should == '2012-03-08 17:50:00 +0000'
      end

      it 'should return raw data if requested' do
        p.parse('E06_12', 'raw').should == '680'
      end

      it 'should return date-only value without doing timezone conversion' do
        p.parse('E06_16').should == p.parse('E06_16', 'raw')
      end
    end

    describe '#get_spec' do
      it 'should return a spec hash for the given element' do
        p.get_spec('E06_12').class.should == Hash
        p.get_spec('E06_12')['data_type'].should == 'combo'
        p.get_spec('E06_12')['data_entry_method'].should == 'single-choice National Element'
      end

      it 'should return nil for a non-existent node' do
        p.get_spec('F00').should be_nil
      end
    end

    describe '#get_node_name' do
      it 'should return a name for the given element' do
        p.get_node_name('E06_12').class.should == String
        p.get_node_name('E06_12').should == 'E06_12'
      end

      it 'should return nil for a non-existent node' do
        p.get_node_name('F00').should be_nil
      end
    end

    describe 'method missing' do
      it 'should treat method name as element name' do
        p.E06_01.should == p.parse_element('E06_01')
      end

      it 'should pass along complex calls' do
        p.send("concat('E06_02', 'E06_01')").should == "TWEETY BIRD"
      end

    end

    describe '#lookup' do
      it 'should lookup a value in using another element' do
        p.E17_01.should == "Pain Control"
      end
    end

    describe '#parse_element' do
      it 'should return string for non-coded element' do
        p.parse_element('E06_01').should == 'BIRD'
      end

      it 'should return string for coded element' do
        p.parse_element('E06_12').should == 'White'
      end

      it 'should return nil for default negative values' do
        p.parse_element('E07_01').should == ''
      end

      it 'should return value for negative indexes' do
        p.parse('E07_01', 'object', false).should == 'Not Recorded'
      end
      it 'should return value for negative indexes' do
        p.parse_element_no_filter('E07_01').should == 'Not Recorded'
      end

      it 'should return lookup value' do
        p.parse_element('E24_01').should == "YES"
      end
    end

    describe '#get' do
      it 'should return key/value hash' do
        p.get('E06_01').class.should == Hash
      end

      it 'should return key/value element name' do
        p.get('E06_01')[:name].should == "LAST NAME"
      end

      it 'should return key/value element text value' do
        p.get('E06_01')[:value].should == "BIRD"
      end

      it 'should return key/value element lookup value' do
        p.get('E24_01')[:value].should == "YES"
      end
    end

    describe '#name' do
      it "should return the name" do
        p.name('E06_01').should == "LAST NAME"
        p.name('E06_02').should == "First"
      end
    end

    describe '#index' do
      it "should return the index into the lookup table" do
        p.index('E24_05').should == "500003"
      end
    end
  end

  context 'express weight in pounds' do
    let(:spec_yaml) {
      spec_yaml = <<YML
E16_01:
  allow_null: 0
  data_entry_method: ~
  data_type: number
  is_multi_entry: 0
  name: Weight (kg)
  node: E16_01
YML
    }
    context 'baby' do
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

      it 'should return age in words with months/weeks/days' do
        p.weight_in_words().should == '13.2 lbs - 6 kg'
      end
    end

    context 'adult' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E16_01>136</E16_01>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age in words with months/weeks/days' do
        p.weight_in_words().should == '299 lbs - 136 kg'
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
    context 'baby' do
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

      it 'should return age in words with months/weeks/days' do
        p.age_in_words.should == "3 months"
      end
    end

    context 'teen' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
  <Header>
    <Record>
      <E06_14_0>
      <E06_14>13</E06_14>
          <E06_15>715</ E06_15>
      </E06_14_0>
        <E06_16>1999-01-17</ E06_16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }
      it 'should return age in words in years' do
        p.age_in_words.should == "13 years"
      end

    end

    context 'senior' do
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
      <E06_16>1936-11-28</E06_16>
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str, spec_yaml)
      }

      it 'should return age in words in years' do
        p.age_in_words.should == "75 years"
      end
    end

    context 'dob missing' do
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
        p.age_in_words.should =~ /46 days/i
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
        p.age_in_words.should =~ /Age Unavailable/i
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
        p.age_in_words.should =~ /76 years/i
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

      describe 'date/time format should be based on data type by default' do
        it 'should return a full date/time value' do
          p.E24_01.should == "2012-03-08 12:50"
        end

        it 'should return a date value' do
          p.E24_02.should == "2012-03-08"
        end

        it 'should return a time value' do
          p.E24_03.should == "12:50"
        end
      end

      describe 'overriding date/time format' do
        context 'date/time data type' do
          it 'should return a full date/time value' do
            p.parse_time('E24_01', true).should == "2012-03-08 12:50"
            p.parse_time('E24_01').should == "12:50"
          end
          
          it 'should return a date value' do
            p.parse_date('E24_01').should == "2012-03-08"
          end

          it 'should return a short date value (no year)' do
            p.parse_date('E24_01', false).should == "03-08"
          end

          it 'should return a time value' do
            p.parse_time('E24_01').should == "12:50"
          end
        end
        context 'date data type' do
          it 'should not return a full date/time value' do
            p.parse_time('E24_02', true).should_not == "2012-03-08 12:50"
          end

          it 'should return a date value' do
            p.parse_date('E24_02').should == "2012-03-08"
          end

          it 'should not return a time value' do
            p.parse_time('E24_02').should_not == "12:50"
          end
        end
        context 'time data type' do
          it 'should not return a full date/time value' do
            p.parse_time('E24_03', true).should_not == "2012-03-08 12:50"
          end

          it 'should not return a date value' do
            p.parse_date('E24_03').should_not == "2012-03-08"
          end

          it 'should return a time value' do
            p.parse_time('E24_03').should == "12:50"
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
          <E23_09></E23_09>
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
        p.parse_field('CHIEF COMPLAINT').should == p.E09_05
      end

      it 'should return the first instance when there are multiple result sets' do
        p.parse_field('CREW MEMBER ID').should == p.E04_01
      end

      it 'will pick up the first node when there are duplicate node names' do
        p.parse_field('last name').should_not == p.E06_01
        p.parse_field('last name').should == p.E04_04
      end
      it 'should parse element by full name in nemsis data dictionary (case insensitive)' do
        p.parse_field('12 LEAD I').should == p.E28_07
        p.parse_field('12 Lead I').should == p.E28_07
      end
    end

    describe '#parse_state' do
      it 'should parse state code to state name' do
        p.parse_state('E08_14').should == 'NC'
      end

      it 'should parse unrecognized state code as is' do
        p.parse_state('E08_15').should == '27604'
      end
    end

    describe '#parse_pair' do
      it 'should return hash' do
        result = p.parse_pair('E23_11', 'E23_09')
        result.is_a?(Hash).should be_true
        result['Patient Number'].should == '123123212'
      end
      it 'should return an empty hash when no data exists' do
        result = p.parse_pair('E33_11', 'E33_09')
        result.is_a?(Hash).should be_true
        result.should be_empty
      end
    end

    describe '#parse_value_of' do
      it 'should return value E23_09 of key E23_11' do
        p.parse_value_of('Patient Number').should == '123123212'
      end

      it 'should return empty info when none exists' do
        p.parse_value_of('BugsBunny').should be_nil
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
        results.is_a?(Array).should be_true
        results.size.should == 4
        results.first.class.should == Nemsis::Parser
      end

      it 'should allow you to get the same elements from each parser instance' do
        results[0].E14_01.should == "2012-03-08 10:30"
        results[1].E14_01.should == "2012-03-08 10:35"
        results[2].E14_01.should == "2012-03-08 10:40"
        results[3].E14_01.should == "2012-03-08 10:45"
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
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)

      }
      let(:results) { p2.get_children('E04') }

      it "should return an array of records" do
        results.is_a?(Array).should be_true
        results.size.should == 2
      end

      it "should have each spec element available" do
        results[0]['E04_01'].should == ""
        results[0]['E04_02'].should == "Primary Patient Caregiver"
        results[0]['E04_03'].should == ""
        results[0]['E04_04'].should == "TECH SUPPORT"
        results[0]['E04_05'].should == "ESO"

        results[1]['E04_01'].should == "P038756"
        results[1]['E04_02'].should == "Driver"
        results[1]['E04_03'].should == "EMT-Paramedic"
        results[1]['E04_04'].should == "ADAMS"
        results[1]['E04_05'].should == "CHRISTOPHER"
      end

      it 'should return arrays of Nemsis::Parser for a element name' do
        results = p.parse_cluster('E14')
        results.is_a?(Array).should be_true
        results.first.is_a?(Nemsis::Parser).should be_true
      end

    end

    describe '#parse_clusters' do
      it 'should return arrays of Nemsis::Parser for multiple element names' do
        results = p.parse_clusters('E15', 'E16')
        results.is_a?(Array).should be_true
        results.first.is_a?(Nemsis::Parser).should be_true
      end
    end

    describe '#parse_assessments' do
      it 'should return assessments in chronological order' do
        results = p.parse_assessments
        results.is_a?(Array).should be_true

        initial_assessment = results.first
        initial_assessment.is_a?(Nemsis::Parser).should be_true
        initial_assessment.xml_doc.root.name.should == 'E15_E16'
        initial_assessment.E16_01.should == '1'
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
    </Record>
  </Header>
</EMSDataSet>
XML
        Nemsis::Parser.new(xml_str)
      }

      it 'should concatenate field values for multiple entries' do
        p.concat('E04_05', 'E04_04').should == "ESO TECH SUPPORT"
      end

      it 'should return empty when there are no data' do
        p.concat('E12_08', 'E12_09').should == ""
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
      <E20_03>10000 Falls of Neuse Rd</E20_03>
      <E23>
        <E23_01>-20</E23_01>
        <E23_05>0</E23_05>
      </E23>
      <E34>
        <E34_01>1</E34_01>
        <E34_02>1</E34_02>
        <E34_03>0</E34_03>
        <E34_04>1</E34_04>
        <E34_05>0</E34_05>
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
          p2.has_content('E20_03').should == true
        end

        it 'should be false when no data values exist' do
          p2.has_content('E23_02').should == false
        end

        it 'should be false for -NN lookup value' do
          p2.has_content('E23_01').should == false
        end
      end

      context 'Entire range of elements' do
        it 'should be true when data values exist' do
          p2.has_content('E34').should == true
        end

        it 'should be false when no data values exist' do
          p2.has_content('E35').should == false
        end
      end
    end

  end

  describe 'procedure code lookups' do
    it 'should lookup CPT codes from D04_04'
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
