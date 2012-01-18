module Mapping
  def self.nemsis_code
    code = {
      '-25'  => 'Not Applicable ',
      '-20'  => 'Not Recorded',
      '-15'  => 'Not Reporting',
      '-10'  => 'Not Known',
      '-5'   => 'Not Available',
      '2645' => 'State/EMS DNR Form',
      '2650' => 'Other Healthcare DNR Form',
      '2655' => 'Living Will',
      '2660' => 'Family/Guardian request DNR (but no documentation',
      '2665' => 'Other',
      '2670' => 'None',
      '3175' => 'Regular',
      '3180' => 'Irregular',
      '3320' => 'Amputation',
      '3325' => 'Bleeding Controlled',
      '3330' => 'Bleeding Uncontrolled',
      '3335' => 'Burn',
      '3340' => 'Crush',
      '3345' => 'Dislocation Fracture',
      '3350' => 'Gunshot',
      '3355' => 'Laceration',
      '3360' => 'Pain without swelling/bruising',
      '3365' => 'Puncture/stab',
      '3370' => 'Soft Tissue Swelling/Bruising',
      '3420' => 'Normal',
      '3425' => 'Not Done',
      '3430' => 'Clammy',
      '3435' => 'Cold',
      '3440' => 'Cyanotic',
      '3445' => 'Jaundiced',
      '3450' => 'Lividity',
      '3455' => 'Mottled',
      '3460' => 'Pale',
      '3465' => 'Warm',
      '3470' => 'Normal',
      '3475' => 'Not Done',
      '3480' => 'Asymmetric Smile or Droop',
      '3485' => 'Drainage',
      '3490' => 'Mass/Lesion',
      '3495' => 'Swelling',
      '3500' => 'Normal',
      '3505' => 'Not Done',
      '3510' => 'JVD',
      '3515' => 'Strider',
      '3520' => 'SubQ Air',
      '3525' => 'Tracheal Dev',
      '3530' => 'Normal',
      '3535' => 'Not Done',
      '3540' => 'Accessory Muscles',
      '3545' => 'Decreased BS-Left',
      '3550' => 'Decreased BS-Right',
      '3555' => 'Flail Segment-Left',
      '3560' => 'Flail Segment-Right',
      '3565' => 'Increased Effort',
      '3570' => 'Normal BS',
      '3575' => 'Rales',
      '3580' => 'Rhonchi/Wheezing',
      '3585' => 'Tenderness-Left',
      '3590' => 'Tenderness-Right',
      '3595' => 'Normal',
      '3600' => 'Not Done',
      '3605' => 'Decreased Sounds',
      '3610' => 'Murmur',
      '3615' => 'Normal',
      '3620' => 'Not Done',
      '3625' => 'Distention',
      '3630' => 'Guarding',
      '3635' => 'Mass',
      '3640' => 'Tenderness',
      '3645' => 'Normal',
      '3650' => 'Not Done',
      '3655' => 'Distention',
      '3660' => 'Guarding',
      '3665' => 'Mass',
      '3670' => 'Tenderness',
      '3675' => 'Normal',
      '3680' => 'Not Done',
      '3685' => 'Distention',
      '3690' => 'Guarding',
      '3695' => 'Mass',
      '3700' => 'Tenderness',
      '3705' => 'Normal',
      '3710' => 'Not Done',
      '3715' => 'Distention',
      '3720' => 'Guarding',
      '3725' => 'Mass',
      '3730' => 'Tenderness',
      '3735' => 'Normal',
      '3735' => 'Normal',
      '3740' => 'Not Done',
      '3740' => 'Not Done',
      '3745' => 'Crowning',
      '3745' => 'Crowning',
      '3750' => 'Genital Injury',
      '3750' => 'Genital Injury',
      '3755' => 'Tenderness',
      '3755' => 'Tenderness',
      '3760' => 'Unstable',
      '3760' => 'Unstable',
      '3980' => 'Not Done',
      '3985' => '2-mm',
      '3990' => '3-mm',
      '3995' => '4-mm',
      '4000' => '5-mm',
      '4005' => '6-mm',
      '4010' => '7-mm',
      '4015' => 'Blind',
      '4020' => 'Reactive',
      '4025' => 'Non-Reactive',
      '4030' => 'Not Done',
      '4035' => '2-mm',
      '4040' => '3-mm',
      '4045' => '4-mm',
      '4050' => '5-mm',
      '4055' => '6-mm',
      '4060' => '7-mm',
      '4065' => 'Blind',
      '4070' => 'Reactive',
      '4075' => 'Non-Reactive',
      '4175' => 'Endotracheal tube',
      '4180' => 'Gastrostomy tube',
      '4185' => 'Inhalation',
      '4190' => 'Intramuscular',
      '4191' => 'Intraosseous',
      '4200' => 'Intraocular',
      '4205' => 'Intravenous',
      '4210' => 'Nasal',
      '4215' => 'Nasal prongs',
      '4220' => 'Nasogastric',
      '4225' => 'Ophthalmic',
      '4230' => 'Oral',
      '4235' => 'Other/miscellaneous',
      '4240' => 'Otic',
      '4245' => 'Re-breather mask',
      '4250' => 'Rectal',
      '4255' => 'Subcutaneous',
      '4260' => 'Sublingual',
      '4265' => 'Topical',
      '4270' => 'Tracheostomy',
      '4275' => 'Transdermal',
      '4280' => 'Urethral',
      '4285' => 'Ventimask',
      '4290' => 'Wound',
      '4300' => 'Inches',
      '4305' => 'IU',
      '4310' => 'KVO (TKO)',
      '4315' => 'L/MIN',
      '4320' => 'LITERS',
      '4325' => 'LPM',
      '4330' => 'MCG',
      '4335' => 'MCG/KG/MIN',
      '4340' => 'MEQ',
      '4345' => 'MG',
      '4350' => 'MG/KG/MIN',
      '4355' => 'ML',
      '4360' => 'ML/HR',
      '4365' => 'Other',
      '4370' => 'Puffs' ,
      '4375' => 'Improved',
      '4380' => 'Unchanged',
      '4385' => 'Worse',
      '4390' => 'None',
      '4395' => 'Altered Mental Status',
      '4400' => 'Apnea',
      '4405' => 'Bleeding',
      '4410' => 'Bradycardia',
      '4415' => 'Diarrhea',
      '4420' => 'Extravasion',
      '4425' => 'Hypertension',
      '4430' => 'Hyperthermia',
      '4435' => 'Hypotension',
      '4440' => 'Hypoxia',
      '4445' => 'Injury',
      '4450' => 'Itching/Urticaria',
      '4455' => 'Nausea',
      '4460' => 'Other',
      '4465' => 'Respiratory Distress',
      '4470' => 'Tachycardia',
      '4475' => 'Vomiting',
      '4500' => 'None',
      '4505' => 'Altered Mental Status',
      '4510' => 'Apnea',
      '4515' => 'Bleeding',
      '4520' => 'Bradycardia',
      '4525' => 'Diarrhea',
      '4530' => 'Esophageal Intubation-immediately',
      '4535' => 'Esophageal Intubation-other',
      '4540' => 'Extravasion',
      '4545' => 'Hypertension',
      '4550' => 'Hyperthermia',
      '4555' => 'Hypotension',
      '4560' => 'Hypoxia',
      '4565' => 'Injury',
      '4570' => 'Itching/Urticaria',
      '4575' => 'Nausea',
      '4580' => 'Other',
      '4585' => 'Respiratory Distress',
      '4590' => 'Tachycardia',
      '4595' => 'Vomiting',
      '4600' => 'Improved',
      '4605' => 'Unchanged',
      '4610' => 'Worse',
      '4635' => 'Antecubital-Left',
      '4640' => 'Antecubital-Right',
      '4645' => 'External Jugular-Left',
      '4650' => 'External Jugular-Right',
      '4655' => 'Femoral-Left IV',
      '4660' => 'Femoral-Left Distal IO',
      '4665' => 'Femoral-Right IV',
      '4670' => 'Femoral-Right IO',
      '4675' => 'Forearm-Left',
      '4680' => 'Forearm-Right',
      '4685' => 'Hand-Left',
      '4690' => 'Hand-Right',
      '4695' => 'Lower Extremity-Left',
      '4700' => 'Lower Extremity-Right',
      '4705' => 'Other',
      '4710' => 'Scalp',
      '4715' => 'Sternal IO',
      '4720' => 'Tibia IO-Left',
      '4725' => 'Tibia IO-Right',
      '4730' => 'Umbilical',
      '4735' => 'Auscultation of Bilateral Breath Sounds',
      '4740' => 'Colormetric CO2 Detector Confirmation',
      '4745' => 'Digital CO2 Confirmation',
      '4750' => 'Esophageal Bulb Aspiration confirmation',
      '4755' => 'Negative Auscultation of the Epigastrium',
      '4760' => 'Visualization of the Chest Rising with ventilation',
      '4765' => 'Visualization of Tube Passing Through the Cords',
      '4770' => 'Waveform CO2 Confirmation',
      '650' => 'Male',
      '655' => 'Female',
      '700' => 'Hours',
      '706' => 'Days',
      '710' => 'Months',
      '715' => 'Years',
    }
    
  end

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
            :name           => 'Gender',
            :hl7_field      => 'PID.8, OBX.5"',
            :nemsis_field   => 'E06_11',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :comment        => 'M or F'
        },
        {
            :name           => 'custom',
            :hl7_field      => 'PID.2.1',
            :nemsis_field   => 'E23_09_0',
            :nemsis_title_field   => 'E23_11',
            :nemsis_value_field   => 'E23_09',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => 'Patient Number:
777777'
        },
        {
            :name           => 'Receiving Facility',
            :hl7_field      => 'MSH.6',
            :nemsis_field   => 'E20_02',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :map            => {'F00002506' => 'Raleigh',
                                'F00002573' => 'Cary',
                                'F00039974' => 'Brier Creek',
                                'F00035879' => 'North',
                                'F00035878' => 'Apex'},
            :comment        => '1 Raleigh Campus'
        },
        {
            :name           => 'Receiving Application',
            :hl7_field      => 'MSH.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'HMED',
            :comment        => 'HMED'
        },
        {
            :name           => 'Sending Facility',
            :hl7_field      => 'MSH.4',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'AXIAL',
            :comment        => 'AXIAL'
        },
        {
            :name           => 'Sending Application',
            :hl7_field      => 'MSH.3',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'EMS ALERTS',
            :comment        => 'EMS ALERTS'
        },
        {
            :name           => 'Message Type',
            :hl7_field      => 'MSH.9',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'ORU^R01',
            :comment        => 'Always ORU^R01'
        },
        {
            :name           => 'Message Control ID',
            :hl7_field      => 'MSH.10',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => 'Axial will create a unique ID for each message sent'
        },
        {
            :name           => 'Processing ID',
            :hl7_field      => 'MSH.11',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => 'P for production, D for non-production"'
        },
        {
            :name           => 'Version ID',
            :hl7_field      => 'MSH.12',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => '2.3.1',
            :comment        => '2.3.1'
        },
        {
            :name           => 'Placer Order Number',
            :hl7_field      => 'OBR.2',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'AXIAL',
            :comment        => 'This field is required for the Allscripts interface, but the value does not drive any logic. Axial will place the same value of ""AXIAL"" in all messages."'
        },
        {
            :name           => 'Universal Service ID',
            :hl7_field      => 'OBR.4',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :default_value  => 'RUNSHEET',
            :comment        => 'Always RUNSHEET'
        },
        {
            :name           => 'OBX Set ID',
            :hl7_field      => 'OBX.1',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => 'Increment by one for each OBX segment per message'
        },
        {
            :name           => 'Observation Result Status',
            :hl7_field      => 'OBX.11',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => 'E06_14',
            :allow_multiple => 'N',
            :is_mapped      => 'N',
            :comment        => '55 years'
        },
        {
            :name           => 'Patient Age Unit',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_15',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
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
          # Need map!
            :name           => 'Patient State',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E06_07',
            :allow_multiple => 'N',
            :is_mapped      => 'Y',
            :map            => {},
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs POS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Vital Signs BP',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_04 + E14_05 + E14_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'Axial will use abbreviations of (Need clarification from Richard as to what abbreviations are used here) to stand for Aterial Line, Manual Cuff, Venous Line, Automated Cuff, and Palpated Cuff, respectively, as indicated in field E14_06, Example 109/73 X'
        },
        {
            :name           => 'Vital Signs Pulse',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment => ''
        },
        {
            :name           => 'Vital Signs Heart Rate',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_08',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment => ''
        },
        {
            :name           => 'Vital Signs Pulse Rhythm',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_10',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E14_10 will be used to map to ""regular"" or ""irregular."" Axial will place an ""I"" or ""R"" next to the pulse, if provided.  Example 104 R'
        },
        {
            :name           => 'Vital Signs Respiratory Rate',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E14_11 + E14_12',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment => 'E14_12 will be used to map to ""labored,"" ""absent,"" ""normal"", or ""fatigued."" Axial will place an ""L,"" ""A,"" ""R,"" or ""F"" next to the respiratory rate to reflect the value. Example 12 R'
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Medication Administered Time',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Medication Given',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Medication Administered Route',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_04',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Medication Dosage',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_05',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Medication Dosage Units',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Response to Medication',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Medication Complication',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E18_08',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Procedure Time',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => 'If E18_02 or E19_02= 1, then time = ""PTA"""'
        },
        {
            :name           => 'Procedure',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'N',
            :comment        => ''
        },
        {
            :name           => 'Size of Procedure Equipment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_04',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Procedure Successful',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Procedure Complication',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_07',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Response to Procedure',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_08',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Successful IV Site',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_12',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Tube Confirmation',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E19_13',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Flow Chart Provider',
            :hl7_field      => '',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Mental Status Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Skin Assessment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_04',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'NHTSA Injury Matrix External/Skin',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_01',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'HEENT Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Head/Face Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_05',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'NHTSA Injury Matrix Head',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_02',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'NHTSA Injury Matrix Face',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_03',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Eyes Left Assessment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_21',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Axial will designate ""L"" and ""R"" for left and right eyes.  Example L Blind'
        },
        {
            :name           => 'Eyes Right Assessment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_22',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Axial will designate ""L"" and ""R"" for left and right eyes.  Example L Blind'
        },
        {
            :name           => 'Neck Assessment',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_06',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'NHTSA Injury Matrix Neck',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_04',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'Chest Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Abdomen General Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_13',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => 'Values to be mapped to text values'
        },
        {
            :name           => 'NHTSA Injury Matrix Abdomen',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_06',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Pelvis/GU/GI Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E16_13',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'NHTSA Injury Matrix Pelvis',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => 'E15_09',
            :allow_multiple => 'Y',
            :is_mapped      => 'Y',
            :comment        => ''
        },
        {
            :name           => 'Extremities Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Capillary Refill Abnormalities',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Neurological Comments',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Level of Service',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
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
            :nemsis_field   => 'E07_12 + E07_13 + E07_11',
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
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'PCS',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'ABN',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'CMS Service Level',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'ICD-9 Code',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Transfer Reason',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Other/Services',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Medical Necessity',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Sending Physician',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Receiving Physician',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Condition Code',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        },
        {
            :name           => 'Condition Code Modifier',
            :hl7_field      => 'OBX.5',
            :nemsis_field   => '',
            :allow_multiple => '',
            :is_mapped      => '',
            :comment        => ''
        }
    ]
  end
end
