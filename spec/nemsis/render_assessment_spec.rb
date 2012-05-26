require 'spec_helper.rb'


describe Nemsis::Renderer do

  context 'assessment section' do
    context 'Show a single assessment' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
<Header><D01_01>092054799999999</D01_01>
<D01_03>37</D01_03>
<D01_04>37183</D01_04>
<D01_07>6110</D01_07>
<D01_08>5830</D01_08>
<D01_09>5870</D01_09>
<D01_21>192209802</D01_21>
<D02_07>27601</D02_07>
<Record><E01><E01_01>1A79F55DD3164C1198A3A00700ED885A</E01_01>
<E01_02>ESO Solutions</E01_02>
<E01_03>ESO Pro ePCR</E01_03>
<E01_04>3.1</E01_04></E01>
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
<E03><E03_01>-20</E03_01>
<E03_02>570</E03_02>
<E03_03>26B8</E03_03></E03>
<E04>
<E04_01>P061321</E04_01>
<E04_02>580</E04_02>
<E04_03>6110</E04_03>
<E04_04>BAKER</E04_04>
<E04_05>TIM</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E04>
<E04_01>P048047</E04_01>
<E04_02>585</E04_02>
<E04_03>6110</E04_03>
<E04_04>WALKER</E04_04>
<E04_05>CHRISTOPHER</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E12>
<E12_01>2615</E12_01>
<E12_08>NKDA</E12_08>
<E12_10>345.8</E12_10>
<E12_10>V40.9 </E12_10>
<E12_14_0><E12_14>Celexa</E12_14><E12_17>-20</E12_17><E12_21>Celexa</E12_21></E12_14_0>
<E12_19>2990</E12_19>
<E12_22>NKDA</E12_22>
<E12_24>Behavioral/Psychiatric Disorder Anxiety</E12_24>
<E12_24>Seizures</E12_24>
<E12_27>None</E12_27>
</E12>
<E14><E14_01>2012-03-01T19:30:28.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
</E14_04_0>
<E14_09>95</E14_09>
<E14_29></E14_29>
<E14_30></E14_30>
<E14_31>4</E14_31>
<E14_32>-20</E14_32>
</E14>
<E14><E14_01>2012-03-01T19:35:28.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
</E14_04_0>
<E14_09>94</E14_09>
<E14_29></E14_29>
<E14_30></E14_30>
<E14_31>5</E14_31>
<E14_32>-20</E14_32>
</E14>
<E14><E14_01>2012-03-01T19:38:00.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
<E14_04>137</E14_04>
<E14_05>87</E14_05>
<E14_06>3155</E14_06>
</E14_04_0>
<E14_08>122</E14_08>
<E14_09>94</E14_09>
<E14_10>3175</E14_10>
<E14_22>3255</E14_22>
<E14_29>L</E14_29>
<E14_30>Sit</E14_30>
<E14_31>5</E14_31>
<E14_32>-20</E14_32>
<E14_35>Regular</E14_35>
</E14>
<E14><E14_01>2012-03-01T19:26:00.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
<E14_04>130</E14_04>
<E14_05>86</E14_05>
<E14_06>3155</E14_06>
</E14_04_0>
<E14_08>116</E14_08>
<E14_10>3175</E14_10>
<E14_11>14</E14_11>
<E14_12>3185</E14_12>
<E14_14>125</E14_14>
<E14_15_0>
<E14_15>4</E14_15>
<E14_16>5</E14_16>
<E14_17>6</E14_17>
</E14_15_0>
<E14_19>15</E14_19>
<E14_22>3255</E14_22>
<E14_23>0</E14_23>
<E14_27>12</E14_27>
<E14_29>L</E14_29>
<E14_30>Sit</E14_30>
<E14_32>-20</E14_32>
<E14_35>Regular</E14_35>
<E14_36>Normal</E14_36></E14>
<E15>
<E15_11>-20</E15_11>
<E15_11>-20</E15_11>
<E15_23>-20</E15_23>
<E15_23>-20</E15_23>
</E15>
<E16>
<E16_01>73</E16_01>
<E16_00_0>
<E16_03>2012-03-01T19:30:00.0Z</E16_03>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>6410</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>Radial: 2+ Normal</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
<E16_00_0>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>-20</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>-20</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
</E16>
XML
        Nemsis::Parser.new(xml_str) }

      let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p) }

      let(:html) { r.render_fancy }
      it('should output file') { write_html_file("assessments", "fancy", html) }
      it('should have assessments section') { html.should =~ /Initial Assessment/ }
      it('should NOT have 1 of n') { html.should_not =~ /Assessment (1 of)/ }
      it('should NOT have ongoing assessments section') { html.should_not =~ /Ongoing Assessment/ }
    end

    context 'Show a double assessment' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
<Header><D01_01>092054799999999</D01_01>
<D01_03>37</D01_03>
<D01_04>37183</D01_04>
<D01_07>6110</D01_07>
<D01_08>5830</D01_08>
<D01_09>5870</D01_09>
<D01_21>192209802</D01_21>
<D02_07>27601</D02_07>
<Record><E01><E01_01>1A79F55DD3164C1198A3A00700ED885A</E01_01>
<E01_02>ESO Solutions</E01_02>
<E01_03>ESO Pro ePCR</E01_03>
<E01_04>3.1</E01_04></E01>
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
<E03><E03_01>-20</E03_01>
<E03_02>570</E03_02>
<E03_03>26B8</E03_03></E03>
<E04>
<E04_01>P061321</E04_01>
<E04_02>580</E04_02>
<E04_03>6110</E04_03>
<E04_04>BAKER</E04_04>
<E04_05>TIM</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E04>
<E04_01>P048047</E04_01>
<E04_02>585</E04_02>
<E04_03>6110</E04_03>
<E04_04>WALKER</E04_04>
<E04_05>CHRISTOPHER</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E12>
<E12_01>2615</E12_01>
<E12_08>NKDA</E12_08>
<E12_10>345.8</E12_10>
<E12_10>V40.9 </E12_10>
<E12_14_0><E12_14>Celexa</E12_14><E12_17>-20</E12_17><E12_21>Celexa</E12_21></E12_14_0>
<E12_19>2990</E12_19>
<E12_22>NKDA</E12_22>
<E12_24>Behavioral/Psychiatric Disorder Anxiety</E12_24>
<E12_24>Seizures</E12_24>
<E12_27>None</E12_27>
</E12>
<E14><E14_01>2012-03-01T19:30:28.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
</E14_04_0>
<E14_09>95</E14_09>
<E14_29></E14_29>
<E14_30></E14_30>
<E14_31>4</E14_31>
<E14_32>-20</E14_32>
</E14>
<E14><E14_01>2012-03-01T19:35:28.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
</E14_04_0>
<E14_09>94</E14_09>
<E14_29></E14_29>
<E14_30></E14_30>
<E14_31>5</E14_31>
<E14_32>-20</E14_32>
</E14>
<E14><E14_01>2012-03-01T19:38:00.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
<E14_04>137</E14_04>
<E14_05>87</E14_05>
<E14_06>3155</E14_06>
</E14_04_0>
<E14_08>122</E14_08>
<E14_09>94</E14_09>
<E14_10>3175</E14_10>
<E14_22>3255</E14_22>
<E14_29>L</E14_29>
<E14_30>Sit</E14_30>
<E14_31>5</E14_31>
<E14_32>-20</E14_32>
<E14_35>Regular</E14_35>
</E14>
<E14><E14_01>2012-03-01T19:26:00.0Z</E14_01>
<E14_02>0</E14_02>
<E14_04_0>
<E14_04>130</E14_04>
<E14_05>86</E14_05>
<E14_06>3155</E14_06>
</E14_04_0>
<E14_08>116</E14_08>
<E14_10>3175</E14_10>
<E14_11>14</E14_11>
<E14_12>3185</E14_12>
<E14_14>125</E14_14>
<E14_15_0>
<E14_15>4</E14_15>
<E14_16>5</E14_16>
<E14_17>6</E14_17>
</E14_15_0>
<E14_19>15</E14_19>
<E14_22>3255</E14_22>
<E14_23>0</E14_23>
<E14_27>12</E14_27>
<E14_29>L</E14_29>
<E14_30>Sit</E14_30>
<E14_32>-20</E14_32>
<E14_35>Regular</E14_35>
<E14_36>Normal</E14_36></E14>
<E15>
<E15_11>-20</E15_11>
<E15_11>-20</E15_11>
<E15_23>-20</E15_23>
<E15_23>-20</E15_23>
</E15>
<E16>
<E16_01>73</E16_01>
<E16_00_0>
<E16_03>2012-03-01T19:30:00.0Z</E16_03>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>6410</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>Radial: 2+ Normal</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
<E16_00_0>
<E16_03>2012-03-01T19:35:00.0Z</E16_03>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>-20</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>-20</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
</E16>
XML
        Nemsis::Parser.new(xml_str) }

      let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p) }

      let(:html) { r.render_fancy }
      it('should output file') { write_html_file("multi_assessments", "fancy", html) }
      it('should have assessments section') { html.should =~ /Initial Assessment/ }
      it('should have 1 of n') { html.should =~ /Initial Assessment \(1 of 2\)/ }
      it('should have ongoing assessments section') { html.should =~ /Ongoing Assessment \(2 of 2\)/ }
    end

    context 'Show a 2nd double assessment with an intermediate non-timestamped data point' do
      let(:p) {
        xml_str = <<XML
<?xml version="1.0" encoding="UTF-8" ?>
<EMSDataSet xmlns="http://www.nemsis.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.nemsis.org http://www.nemsis.org/media/XSD/EMSDataSet.xsd">
<Header><D01_01>092054799999999</D01_01>
<D01_03>37</D01_03>
<D01_04>37183</D01_04>
<D01_07>6110</D01_07>
<D01_08>5830</D01_08>
<D01_09>5870</D01_09>
<D01_21>192209802</D01_21>
<D02_07>27601</D02_07>
<Record><E01><E01_01>1A79F55DD3164C1198A3A00700ED885A</E01_01>
<E01_02>ESO Solutions</E01_02>
<E01_03>ESO Pro ePCR</E01_03>
<E01_04>3.1</E01_04></E01>
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
<E03><E03_01>-20</E03_01>
<E03_02>570</E03_02>
<E03_03>26B8</E03_03></E03>
<E04>
<E04_01>P061321</E04_01>
<E04_02>580</E04_02>
<E04_03>6110</E04_03>
<E04_04>BAKER</E04_04>
<E04_05>TIM</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E04>
<E04_01>P048047</E04_01>
<E04_02>585</E04_02>
<E04_03>6110</E04_03>
<E04_04>WALKER</E04_04>
<E04_05>CHRISTOPHER</E04_05>
<E04_06>EMT-Paramedic</E04_06>
</E04>
<E16>
<E16_01>73</E16_01>
<E16_00_0>
<E16_03>2012-03-01T19:30:00.0Z</E16_03>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>6410</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>Radial: 2+ Normal</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
<E16_00_0>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>-20</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>-20</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
<E16_00_0>
<E16_03>2012-03-01T19:40:00.0Z</E16_03>
<E16_04>3420</E16_04>
<E16_05>3470</E16_05>
<E16_06>3500</E16_06>
<E16_07>3530</E16_07>
<E16_08>3595</E16_08>
<E16_09>3615</E16_09>
<E16_10>3645</E16_10>
<E16_11>3675</E16_11>
<E16_12>3705</E16_12>
<E16_13>3735</E16_13>
<E16_14>3765</E16_14>
<E16_15>3790</E16_15>
<E16_16>3815</E16_16>
<E16_17>3840</E16_17>
<E16_18>3875</E16_18>
<E16_19>3910</E16_19>
<E16_20>3945</E16_20>
<E16_21>-20</E16_21>
<E16_21>-20</E16_21>
<E16_22>-20</E16_22>
<E16_22>-20</E16_22>
<E16_23>4080</E16_23>
<E16_24>4125</E16_24>
<E16_34>6410</E16_34>
<E16_35>-20</E16_35>
<E16_36>3530</E16_36>
<E16_37>-20</E16_37>
<E16_38>No Abnormalities</E16_38>
<E16_39>No Abnormalities</E16_39>
<E16_40>No Abnormalities</E16_40>
<E16_41>No Abnormalities</E16_41>
<E16_41>No Abnormalities</E16_41>
<E16_42>No Abnormalities</E16_42>
<E16_42>No Abnormalities</E16_42>
<E16_43>No Abnormalities</E16_43>
<E16_44>No Abnormalities</E16_44>
<E16_45>No Abnormalities</E16_45>
<E16_46>No Abnormalities</E16_46>
<E16_47>No Abnormalities</E16_47>
<E16_48>No Abnormalities</E16_48>
<E16_49>No Abnormalities</E16_49>
<E16_50>No Abnormalities</E16_50>
<E16_51>No Abnormalities</E16_51>
<E16_52>No Abnormalities</E16_52>
<E16_53>No Abnormalities</E16_53>
<E16_54>No Abnormalities</E16_54>
<E16_55>No Abnormalities</E16_55>
<E16_56>No Abnormalities</E16_56>
<E16_57>No Abnormalities</E16_57>
<E16_58>No Abnormalities</E16_58>
<E16_59>No Abnormalities</E16_59>
<E16_60>Radial: 2+ Normal</E16_60>
<E16_61>-20</E16_61>
<E16_62>No Abnormalities</E16_62>
</E16_00_0>
</E16>
XML
        Nemsis::Parser.new(xml_str) }

      let(:r) { Nemsis::Renderer::WakeMed::HTML.new(p) }

      let(:html) { r.render_fancy }
      it('should output file') { write_html_file("multi_assessments3", "fancy", html) }
      it('should have assessments section') { html.should =~ /Initial Assessment/ }
      it('should have 1 of n') { html.should =~ /Initial Assessment \(1 of 2\)/ }
      it('should have ongoing assessments section') { html.should =~ /Ongoing Assessment \(2 of 2\)/ }
    end
  end
end
