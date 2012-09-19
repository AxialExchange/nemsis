require 'spec_helper'

# In September 2012, ESO decided to forego sending us standard address info with cryptic city, county codes, etc.
# Instead, they will send us straight-up text
describe Nemsis::Renderer do
  #New Patient Home Address (E06-20 --> E06-25)
  #New Incident address (E08-19 --> E08-23)
  #New Destination address (E20-20 --> E20-25)
  describe 'Use Fully Qualified Address Fields' do
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

    <E05>
      <E05_01>2012-06-26T19:13:40.0Z</E05_01>
      <E05_02>2012-06-26T19:13:40.0Z</E05_02>
      <E05_03>2012-06-26T05:00:00.0Z</E05_03>
      <E05_04>2012-06-26T19:14:59.0Z</E05_04>
      <E05_05>2012-06-26T19:15:33.0Z</E05_05>
      <E05_06>2012-06-26T19:21:07.0Z</E05_06>
      <E05_07>2012-06-26T19:23:00.0Z</E05_07>
      <E05_08>2012-06-26T20:00:19.0Z</E05_08>
      <E05_09>2012-06-26T19:27:30.0Z</E05_09>
      <E05_10>2012-06-26T19:41:48.0Z</E05_10>
      <E05_11>2012-06-26T20:02:46.0Z</E05_11>
      <E05_12 xsi:nil="true"/>
      <E05_13 xsi:nil="true"/>
      <E05_14>2012-06-26T19:13:40.0Z</E05_14>
    </E05>

    <E06_04_0>
      <E06_04>123 Broadway St</E06_04>
      <E06_05>SOUTH HILL</E06_05>
      <E06_07>51</E06_07>
      <E06_08>27596</E06_08>
    </E06_04_0>
    <E06_20>Home address</E06_20>
    <E06_21>Home address #2</E06_21>
    <E06_22>Home City</E06_22>
    <E06_23>Home County</E06_23>
    <E06_24>Home State</E06_24>
    <E06_25>Home Country</E06_25>

    <E08_11_0>
      <E08_11>12050 RETAIL DR</E08_11>
      <E08_12>70540</E08_12>
      <E08_14>37</E08_14>
      <E08_15>27587</E08_15>
    </E08_11_0>
    <E23_09_0>
      <E23_09>Destination Address 2</E23_09>
      <E23_11>DestinationAddress2</E23_11>
    </E23_09_0>
    <E23_09_0>
      <E23_09></E23_09>
      <E23_11>IncidentAddress2</E23_11>
    </E23_09_0>
    <E08_19>Scene address</E08_19>
    <E08_20>Scene address #2</E08_20>
    <E08_21>Scene City</E08_21>
    <E08_22>Scene County</E08_22>
    <E08_23>Scene State</E08_23>
    <E20>
      <E20_03_0>
        <E20_03>10000 Falls of Neuse Rd</E20_03>
        <E20_04>55000</E20_04>
        <E20_05>37</E20_05>
        <E20_07>27610</E20_07>
      </E20_03_0>
    <E20_17>7280</E20_17>
    </E20>

    <E20_20>Destination description</E20_20>
    <E20_21>Destination address</E20_21>
    <E20_22>Destination address #2</E20_22>
    <E20_23>Destination City</E20_23>
    <E20_24>Destination County</E20_24>
    <E20_25>Destination State</E20_25>
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


    context 'Home Address' do
      it 'should not have the original home address field' do
        html.should_not include '123 Broadway St'
      end
      it 'should have the correct home address2' do
        html.should include 'Home address #2'
        html.should include 'Home address<br>Home address #2'
      end

      it 'should have the correct home city' do
        html.should include 'Home City'
      end
      it 'should have the correct home state' do
        html.should include 'Home State'
      end
      it 'should have the correct home zip' do
        html.should include '27596'
      end
      it 'should have the correct home county' do
        html.should include 'Home County'
      end
      it 'should have the correct home country' do
        html.should include 'Home Country'
      end
    end

    context 'Scene Address' do
      it 'should not have the original scene address field' do
        html.should_not include '12050 RETAIL DR'
        html.should_not include 'Destination Address 2'
        html.should_not include 'Hospital'
      end
      it 'should have the correct scene address' do
        html.should include 'Scene address'
      end
      it 'should have the correct scene address2' do
        html.should include 'Scene address #2'
      end

      it 'should have the correct scene city' do
        html.should include 'Scene City'
      end
      it 'should have the correct scene state' do
        html.should include 'Scene State'
      end
      it 'should have the correct scene zip' do
        html.should include '27596'
      end
    end

    context 'Destination Address' do
      it 'should not have the original destination address field' do
        html.should_not include '10000 Falls of Neuse Rd'
        html.should_not include 'Destination Address 2'
      end
      it 'should have the correct destination description' do
        html.should include 'Destination description'
      end
      it 'should have the correct destination address' do
        html.should include 'Destination address'
      end
      it 'should have the correct destination address2' do
        html.should include 'Destination address #2'
      end

      it 'should have the correct destination city' do
        html.should include 'Destination City'
      end
      it 'should have the correct destination state' do
        html.should include 'Destination State'
      end
      it 'should have the correct destination zip' do
        html.should include '27596'
      end
    end
  end

end
