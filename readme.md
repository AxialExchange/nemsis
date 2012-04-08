
NEMSIS (http://www.nemsis.org) is a standard used by EMS agencies to describe the data that they collect in the field.
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
