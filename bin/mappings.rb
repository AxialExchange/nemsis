module Mapping

  def self.mapping
    [
        {
            :name           => 'First Name',
            :hl7_field      => 'PID.5.2, OBX.5"',
            :nemsis_field   => 'E06_02',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => 'TestFirst'
        },
        {
            :name           => 'Last Name',
            :hl7_field      => 'PID.5.1, OBX.5"',
            :nemsis_field   => 'E06_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => 'Testlast'
        },
        {
            :name           => 'Middle Name',
            :hl7_field      => 'PID 5.3, OBX.5"',
            :nemsis_field   => 'E06_03',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'DOB',
            :hl7_field      => 'PID.7, OBX.5"',
            :nemsis_field   => 'E06_16',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '19000101'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'YYYYMMDD'
        },
        {
            :name           => 'Gender',
            :hl7_field      => 'PID.8, OBX.5"',
            :nemsis_field   => 'E06_11',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => 'M or F'
        },
        {
            :name           => 'ESO Armband ID',
            :hl7_field      => 'PID.2.1',
            :nemsis_field   => 'E23_09, E23_11"',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '777777'
        },
        {
            :name           => 'Patient Number',
            :hl7_field      => 'PID.18.1',
            :nemsis_field   => 'E23_09, E23_11"',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '55555555'
        },
        {
            :name           => 'Medical Record Number',
            :hl7_field      => 'PID.3.1',
            :nemsis_field   => 'E23_09, E23_11"',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '333333'
        },
        {
            :name           => 'Receiving Facility',
            :hl7_field      => 'MSH.6',
            :nemsis_field   => 'Map NEMSIS field E20_02 to WM location code in the comments section',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => '1 Raleigh Campus'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => 'F00002506 = Raleigh Campus',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => '2 Cary Hospital'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => 'F00002573 = Cary',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'M Brier Creek Healthplex'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => 'F00039974 = Brier Creek',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'I Apex Healthplex'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => 'F00035879 = North',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'N North Healthplex'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => 'F00035878 = Apex',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Receiving Application',
            :hl7_field      => 'MSH.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'HMED'
        },
        {
            :name           => 'Sending Facility',
            :hl7_field      => 'MSH.4',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'AXIAL'
        },
        {
            :name           => 'Sending Application',
            :hl7_field      => 'MSH.3',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'EMS ALERTS'
        },
        {
            :name           => 'Message Type',
            :hl7_field      => 'MSH.9',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Always ORU^R01'
        },
        {
            :name           => 'Message Control ID',
            :hl7_field      => 'MSH.10',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Axial will create a unique ID for each message sent'
        },
        {
            :name           => 'Processing ID',
            :hl7_field      => 'MSH.11',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'P for production, D for non-production"'
        },
        {
            :name           => 'Version ID',
            :hl7_field      => 'MSH.12',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => '2.3.1'
        },
        {
            :name           => 'Placer Order Number',
            :hl7_field      => 'OBR.2',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'This field is required for the Allscripts interface, but the value does not drive any logic. Axial will place the same value of ""AXIAL"" in all messages."'
        },
        {
            :name           => 'Universal Service ID',
            :hl7_field      => 'OBR.4',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Always RUNSHEET'
        },
        {
            :name           => 'OBX Set ID',
            :hl7_field      => 'OBX.1',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Increment by one for each OBX segment per message'
        },
        {
            :name           => 'Observation Result Status',
            :hl7_field      => 'OBX.11',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'HL-7 standard required field, but does not drive any logic within Allscripts. Axial will set to F to designate Final status."'
        },
        {
            :name           => 'Incident Number',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_02',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment => '(All the OBX.5 fields will be in the second OBX segment, unless noted)"'
        },
        {
            :name           => 'Incident Date',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Age',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_14 + E06_15',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '55 years'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'E06_15 values to be mapped to text values'
        },
        {
            :name           => 'Patient Weight',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '63 kg'
        },
        {
            :name           => 'Patient SSN',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_10',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Address',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_04',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient City',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_05',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient State',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_07',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Zip',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_08',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Country',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_09',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Telephone',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_17',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Patient Physician',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_04 + E12_05 + E12_06',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Advanced Directive',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Primary Impression',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_15',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Secondary Impression',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_16',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Chief Complaint',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_05',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Primary Complaint Duration',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_06 + E09_07',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Secondary Complaint',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_08',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Secondary Complaint Duration',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_09 + E09_10',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Signs & Symptoms',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E09_13 + E09_14',
            :allow_multiple => 'Y (E09_14 only)',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Injury',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E10_01 + E10_02 + E10_03',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Medical/Trauma',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Barriers of Care',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Alcohol/Drugs',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_19',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Patient Medications',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_14 + E12_15 + E12_16',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Patient Allergies',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_08 + E12_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Patient History',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs Time',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => 'If E14_02 = 1 then Time = PTA'
        },
        {
            :name           => 'Vital Signs AVPU',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_22',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Axial will use abbreviations of ""V,"" ""U,"" ""A, "" and ""P"" to stand for Verbal, Unresponsive, Alert, and Painful, respectively"'
        },
        {
            :name           => 'Vital Signs Side',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs POS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs BP',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_04 + E14_05 + E14_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Axial will use abbreviations of (Need clarification from Richard as to what abbreviations are used here) to stand for Aterial Line, Manual Cuff, Venous Line, Automated Cuff, and Palpated Cuff, respectively, as indicated in field E14_06"'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Example 109/73 X'
        },
        {
            :name           => 'Vital Signs Pulse',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '(E14_07 or E14_08) + E14_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E14_10 will be used to map to ""regular"" or ""irregular."" Axial will place an ""I"" or ""R"" next to the pulse, if provided."'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Example 104 R'
        },
        {
            :name           => 'Vital Signs Respiratory Rate',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_11 + E14_12',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E14_12 will be used to map to ""labored,"" ""absent,"" ""normal"", or ""fatigued."" Axial will place an ""L,"" ""A,"" ""R,"" or ""F"" next to the respiratory rate to reflect the value."'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Example 12 R'
        },
        {
            :name           => 'Vital Signs SPO2',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs CO',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs BG',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_14',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs Temp',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_20 + E14_21',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E14_21 will be used to map to the location the temp was taken. Axial will place an ""A,"" ""R,"" ""U"", ""O"" or ""T"" next to the temp to show locations for ""Axillary,"" ""Rectal,"" ""Urinary Catheter,"" ""Oral,"" and ""Tympanic,"" respectively."'
        },
        {
            :name           => 'Vital Signs Pain',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_23',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs GCS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_19',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs RTS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_27',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs PTS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_28',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'ECG Time',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => 'If E14_02 = 1, then time is ""PTA"""'
        },
        {
            :name           => '3-Lead ECG',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => '12-Lead ECG',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Flow Chart Time',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_01 or E19_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => 'If E18_02 or E19_02= 1, then time = ""PTA"""'
        },
        {
            :name           => 'Flow Chart Treatment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_03 or E19_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E19_03 will map to text values in the NEMSIS 2.2.1 spec as described in element D04_04'
        },
        {
            :name      => 'Flow Chart Description',
            :hl7_field => 'OBX.5',
            :nemsis_field => '(E18_05 + E18_06; E18_04; E18_07; E18_08) or E19_04; E19_12; E19_08; E19_06; E19_07; E19_13',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Flow Chart Provider',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Mental Status Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Mental Status Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_23',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'E16_23 values to be mapped to text values'
        },
        {
            :name           => 'Skin Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Skin Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_04, E15_01"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'HEENT Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Head/Face Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_05, E15_02, E15_03"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Eyes Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_21, E16_22"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Axial will designate ""L"" and ""R"" for left and right eyes."'
        },
        {
            :name           => ' ',
            :hl7_field      => ' ',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => 'Example L Blind'
        },
        {
            :name           => 'Neck Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_06, E15_04"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Chest Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Chest Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_05',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Heart Sounds Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_08',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Lung Sounds Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Abdomen Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Abdomen General Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_13, E15_06"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Abdomen Left Upper Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Abdomen Right Upper Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_11',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Abdomen Left Lower Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Abdomen Right Lower Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_12',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Back Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Cervical Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_14',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Thoracic Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Lumbar/Sacral Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_16',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Pelvis/GU/GI Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Pelvis/GU/GI Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_13, E15_09"',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Extremities Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Left Arm Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_19',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Right Arm Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_17',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Left Leg Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_20',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Right Left Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_18',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Pulse Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Capillary Refill Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Neurological Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Neurological Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_24',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Narrative',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E13_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Location',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_07',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Incident Address',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_11',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Address 2',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Incident City',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_12',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident State',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_14',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Zip',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_15',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Medic Unit',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_03',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Run Type',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_04',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Priority Scene',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_20',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Zone',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_09',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Shift',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Level of Service',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Disposition',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_10 + E20_14',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Transport Due To',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_16',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Transported To',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Requested By',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Destination',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_17',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Destination Address',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_03',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Destination Address 2',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Destination City',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_04',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Destination State',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_05',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Destination Zip',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_07',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Destination Zone',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_09',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Condition at Destination',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E20_15',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Destination Record #',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_03',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Call Received',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_01',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Dispatched',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_04',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident En Route',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_05',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Resp on Scene',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_06',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident At Patient',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_07',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Depart Scene',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_09',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident At Destination',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_10',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Pt. Transferred',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_08',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident Close',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_11',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Incident In District',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E05_13',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Crew Member Name',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Crew Member Certification Number',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E04_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Crew Member Role',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E04_02',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Crew Member Certification Level',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E04_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Insured\'s Name',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_11 _ E07_12 + E07_13',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Insured\'s Relationship to Patient',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_14',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Primary Payer',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_01',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Primary Insurance',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Primary Policy #',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Primary Group #',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Job Related Injury',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_15',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Employer',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_27',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Employer Phone',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_32',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Mileage at Scene',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_17',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Mileage at Destination',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_18',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Loaded Miles',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'Calculated E02_18 - E02_17',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Start Mileage',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_16',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'End Mileage',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_19',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Total Miles',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'Calculated E02_19 - E02_16',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Dispatch Delays',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Response Delays',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Scene Delays',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_08',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Transport Delays',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Turn-around Delays',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E02_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment =>
                 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Additional Agencies',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E08_01 + E08_02',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment =>
                 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Next of Kin Name',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_18 + E07+19 + E07_20',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Next of Kin Relationship to Patient',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_26',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment =>
                 'Values to be mapped to text values as specified in the NEMSIS 2.2.1 data dictionary'
        },
        {
            :name           => 'Next of Kin Phone',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_25',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Next of Kin Address',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_21',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Next of Kin City',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_22',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Next of Kin State',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_23',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Next of Kin Zip',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E07_24',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Transfer Details Sending Record #',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E12_02',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'PAN',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'PCS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'ABN',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'CMS Service Level',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'ICD-9 Code',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Transfer Reason',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Other/Services',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Medical Necessity',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Sending Physician',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Receiving Physician',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Condition Code',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        },
        {
            :name           => 'Condition Code Modifier',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => ' ',
            :allow_multiple => ' ',
            :is_mapped      => ' ',
            :comment        => ''
        }
    ]
  end
end
