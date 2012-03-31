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
      sample_xml_file = File.expand_path('../../data/sample_v_1_13.xml', __FILE__)
      xml_str         = File.read(sample_xml_file)

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
        p.get('E06_01')[:value].should == "BIRD"
      end
      it 'should return key/value element lookup value' do
        p.get('E24_01')[:value].should == "YES"
      end
    end
    describe '#name' do
      it "should return the name" do
        p.name('E32_01').should == "Gravida"
      end
    end
    describe '#index' do
      it "should return the index into the lookup table" do
        p.index('E24_05').should == "500003"
        p.index('E32_28').should == "2"
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
        p.E32_10.should == p.parse_time('E32_10', true)
      end
      it 'should return a date value' do
        p.E32_05.should == p.parse_date('E32_05')
      end
      it 'should return a time value' do
        p.E31_11.should == p.parse_time('E31_11')
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
        p.E31_09.should == "90"
      end
    end

    describe '#parse_field' do
      it 'should parse element by full name in nemsis data dictionary (case insensitive)' do
        p.parse_field('CHIEF COMPLAINT').should == p.E09_05
      end

      it 'should return the first instance when there are multiple result sets' do
        p.parse_field('CREW MEMBER ID').should == p.E04_01
      end

      it "will pick up the first node when there are duplicate node names" do
        p.parse_field('last name').should_not == p.E06_01
        p.parse_field('last name').should == p.E04_04
      end
      it 'should parse element by full name in nemsis data dictionary (case insensitive)' do
        p.parse_field('12 LEAD I').should == p.E28_07
        p.parse_field('12 Lead I').should == p.E28_07
      end
    end

    describe '#parse_time' do
      it 'should parse time to standard/long format' do
        p.parse_time('E14_01', true).should == '2012-03-08 18:45'
      end
      it 'should parse time to shortened format' do
        p.parse_time('E14_01').should == '18:45'
      end
    end

    describe '#parse_date' do
      it 'should parse time to standard date-only format' do
        p.parse_date('E14_01', true).should == '2012-03-08'
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
    end

    describe '#parse_value_of' do
      it 'should return value E23_09 of key E23_11' do
        p.parse_value_of('Patient Number').should == '123123212'
      end
    end

    describe "nokogiri" do
      it "should do what i want" do
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
        nodes = xml_doc.xpath('//E04')
        #puts nodes.count
        results = []
        nodes.each_with_index do |node,i|
          #puts "node ##{i+1}: #{node.name}"
          c = 0

          node.children.each do |child|
            #puts "\tChild ##{c+=1}: #{child.name}=> #{child.text}" if child.is_a?(Nokogiri::XML::Element)
          end
        end

        #puts "-"*25
        p = Nemsis::Parser.new(xml_str)
        #puts = p.get_children('E04').inspect

      end
    end

    describe '#parse_cluster' do
      let(:p2) {
        xml_str = "
<root>
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
</root>"
        Nemsis::Parser.new(xml_str)
      }

      it "should return proper number of records" do
        results = p2.get_children('E04')
        results.is_a?(Array).should be_true
        results.size.should == 2

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

    describe '#get_children' do
      let(:p2) {
        xml_str = "
<root>
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
</root>"
        Nemsis::Parser.new(xml_str)

      }
      let(:results) {p2.get_children('E04')}

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
    describe '#has_content' do
      let(:p2) {
        xml_str = "
<root>
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
</root>"
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
end
