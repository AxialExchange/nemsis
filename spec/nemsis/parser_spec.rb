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

  context 'instance methods' do
    let(:p) {
      sample_xml_file = File.expand_path('../../data/sample_3.xml', __FILE__) 
      xml_str = File.read(sample_xml_file) 

      Nemsis::Parser.new(xml_str) 
    }

    describe '#get' do
      it 'should return key/value hash' do
        p.get('E06_01').class.should == Hash
      end
      it 'should return key/value element name' do
        p.get('E06_01')[:name].should == "LAST NAME"
      end
      it 'should return key/value element text value' do
        p.get('E06_01')[:value].should == "ZERO"
      end
      it 'should return key/value element lookup value' do
        p.get('E24_01')[:value].should == "YES"
      end
    end
    describe '#parse_element' do
      it 'should return string for non-coded element' do
        p.parse_element('E06_01').should == 'ZERO'
      end

      it 'should return string for coded element' do
        p.parse_element('E06_12').should == 'White'
      end

      it 'should return nil for default negative values' do
        p.parse_element('E06_11').should == ''
      end

      it 'should return lookup value' do
        p.parse_element('E24_01').should == "YES"
      end
    end

    describe 'dynamic method' do
      it 'should treat method name as element name' do
        p.E06_01.should == p.parse_element('E06_01')
      end

      it 'should return an empty string for a missing data element' do
        p.E25_00.should == ""
      end
      it 'should return a string for single values' do
        p.E25_01.should == "Class 1"
      end
      it 'should return a full date/time value' do
        p.E31_11.should == p.parse_time('E31_11', true)
      end
      it 'should return an array as a comma-separated list for multiple values' do
        p.E25_03.should == "Ventilatory Effort Compromised, Injury/Trauma to Airway"
      end
      it 'should return lookup value' do
        p.E29_03.should == ">20 Minutes"
        p.E23_08.should == "No"
        p.E24_01.should == "YES"
      end
      it 'should return an integer' do
        p.E31_04.should == "1"
      end
      it 'should return a decimal' do
        p.E31_09.should == "91"
      end
    end

    describe '#parse_field' do
      it 'should parse element by full name in nemsis data dictionary' do
        p.parse_field('LAST NAME').should == p.E06_01
      end
    end

    describe '#parse_time' do
      it 'should parse time to standard/long format' do
        p.parse_time('E14_01', true).should == '2012-01-31 18:23'
      end
      it 'should parse time to shortened format' do
        p.parse_time('E14_01').should == '18:23'
      end
    end

    describe '#parse_state' do
      it 'should parse state code to state name' do
        p.parse_state('E08_14').should == 'NC'
      end

      it 'should parse unrecognized state code as is' do
        p.parse_state('E08_15').should == '27705'
      end
    end

    describe '#parse_pair' do
      it 'should return hash' do
        result = p.parse_pair('E23_11', 'E23_09')
        result.is_a?(Hash).should be_true
        result['Patient Number'].should == '111111111'
      end
    end

    describe '#parse_value_of' do
      it 'should return value E23_09 of key E23_11' do
        p.parse_value_of('Patient Number').should == '111111111'
      end
    end

    describe '#parse_cluster' do
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
        initial_assessment.E16_01.should == '93'
      end
    end
  end
end
