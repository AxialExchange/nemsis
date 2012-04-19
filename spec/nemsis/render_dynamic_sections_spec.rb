require 'spec_helper.rb'

# Test that certain sections only display when there are data to be shown.
dynamic_sections = ['Vital Signs', 'ECG', 'Flow Chart', 'Initial Assessment', 'Narrative',
                    'Specialty Patient &mdash; ACS', 'Specialty Patient &mdash; Advanced Airway',
                    'Specialty Patient &mdash; Burns', 'Specialty Patient &mdash; Stroke', 'Specialty Patient &mdash; CPR',
                    'Specialty Patient &mdash; Motor Vehicle Collision', 'Specialty Patient &mdash; Trauma Criteria',
                    'Specialty Patient &mdash; Obstetrical', 'Specialty Patient &mdash; Spinal Immobilization',
                    'Influenza Screening', 'SAD (Psychiatric Ax)',
                    'Incident Details', 'Crew Members', 'Insurance Details', 'Mileage', 'Additional Agencies',
                    'Next of Kin', 'Personal Items', 'Transfer Details']

describe Nemsis::Renderer do
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
      <E01>
        <E01_01>C9DA1D4D07644A1B8E98A007013D1794</E01_01>
        <E01_02>ESO Solutions</E01_02>
        <E01_03>ESO Pro ePCR</E01_03>
        <E01_04>3.1</E01_04>
      </E01>
      <E06>
        <E06_01_0>
          <E06_01>JEFFERSON</E06_01>
          <E06_02>MADISON</E06_02>
          <E06_03>K</E06_03>
        </E06_01_0>
        <E06_04_0>
          <E06_04>123 E Main St</E06_04>
          <E06_05>Some City</E06_05>
          <E06_07>  state?</E06_07>
          <E06_08>27596</E06_08>
        </E06_04_0>
        <E06_10>123574321</E06_10>
        <E06_11>655</E06_11>
        <E06_12>680</E06_12>
        <E06_13>695</E06_13>
        <E06_14_0>
          <E06_14>31</E06_14>
          <E06_15>715</E06_15>
        </E06_14_0>
        <E06_16>1981-12-10</E06_16>
        <E06_17>9194822852</E06_17>
      </E06>
    </Record>
  </Header>
</EMSDataSet>
XML
    Nemsis::Parser.new(xml_str) }

  let(:r) {  Nemsis::Renderer::WakeMed::HTML.new(p) }

  let(:html) { r.render(false) }

  context 'dynamic sections' do
    describe 'do not show when there are no data' do
      it 'should write out the html for examining' do
        write_html_file("dynamic_sections", "simple", html)
      end
      dynamic_sections.each do |s|
        it("does not have: #{s}") { html.should_not =~ /#{s}/ }
      end
    end
  end
end
