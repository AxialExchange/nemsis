Update by Ievgen on 18th of December, 2017:
I can't see this project used anywhere on the BE. If you find out that this project is used, add a comment. If you find out it's not used in a hear from now, remove this project.

Note: This gem has been developed using ruby 1.9.2

# NEMSIS

[NEMSIS](http://www.nemsis.org) is a standard used by EMS agencies to describe the data that they collect in the field.
Loosely, it is broken up as follows:

## Core Elements

* Demographic Dataset ('Dxx')
* EMS Dataset ('Exx')
* Section E00 -- Common EMS Values
* Section E06 -- Patient
  * E06_01_0 --Patient Name Structure
    * E06_01 -- Last Name, String
    * E06_02 -- First Name, String
    * E06_03 -- Middle, String
  * E06_04_0 -- Patient Address Structure
    * E06_04 -- Address, String
    * E06_05 -- City, String
    * E06_06 -- County, String
    * E06_07 -- State, String
    * E06_08 -- Zip, String
  * E06_09 -- Country, String
* Multi-Entry Section -- E04 (aka, a Repeating Structure)

    <E04>
      <E04_02>585</E04_02>
      <E04_03>-20</ E04_03>
      <E04_04>TECH SUPPORT</E04_04>
      <E04_05>ESO</ E04_05>
    </E04>
    <E04>
      <E04_01>P038756</ E04_01>
      <E04_02>580</E04_02>
      <E04_03>6110</ E04_03>
      <E04_04>ADAMS</E04_04>
      <E04_05>CHRISTOPHER</ E04_05>
    </E04>

An Element is described by the YAML spec entry. Of special note are the following aspects:

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
      name: 'Last'
      node: E06_01
      E06_11:
        allow_null: 1
        data_entry_method: single-choice National Element
        data_type: combo
        field_values:
          -10: Not Known
          -15: Not Reporting
          -20: Not Recorded
          -25: Not Applicable
          -5: Not Available
          650: Male
          655: Female
        is_multi_entry: 0
        name: Gender
        node: E06_11


  * node (E06_01)-- this is how you can find it
  * data type -- text, date, time, date/time, number, combo (single-choice, multiple-choice)
    * For date/time, you can control the default value returned to be just a date or just a time
    * Combo uses the data_entry_method to determine if multiple choice is allowed (returning a concatenated string of answers)
  * field_values -- these are the table look-up entries for combo types (an index yields the text string)
    * For negative indexes, no value is returned.
  * name -- this describes the intent of the node, and is used as a default label (TODO: add a label property)

## Common Usage

You can see parser_spec.rb and renderer_spec.rb for detailed examples. Here are some common, everyday usages:

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

### Checking for content

For generating dynamic sections, you can check if there are any data with code like this:

    <% if @parser.has_content('E28') %>

or for individual values:

    <% if @parser.has_content('E14_01','E14_03','E14_33') %>

### Concatenating Fields

     <%= row( {'Primary Impression' => "concat('E09_19')"}, 'E09_11', {'Injury' => "concat_with_hyphen('E10_11', 'E10_15', 'E10_13', 'E10_14')"} )%>

### Repeating Sections

Personal Items is a good example of a set of repeating data:

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

Which can be easily tackled using the following syntax

        <% if @parser.has_content('E35_01') %>
          <%= start_table "Personal Items", 3 %>
            <tbody>
            <%=  heading_row('E35_02', 'E35_03', 'E35_04') %>
            <% @parser.parse_cluster('E35_01_0').each do |e35| %>
              <%=  row_from_values(e35.E35_02, e35.E35_03, e35.E35_04) %>
            <% end %>
            </tbody>
          </table>
          <br>
        <% end %>
