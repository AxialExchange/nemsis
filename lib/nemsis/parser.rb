module Nemsis
  class Parser
    attr_accessor :xml_str, :xml_doc

    class << self
      attr_accessor :spec
    end

    spec_yaml = File.expand_path('../../../conf/nemsis_spec.yml', __FILE__)
    @@spec = YAML::load(File.read(spec_yaml))

    def initialize(xml_str)
      self.xml_str = xml_str
      self.xml_doc = Nokogiri::XML(xml_str)
      xml_doc.remove_namespaces!
    end

    def parse_element(element)
      element_spec = @@spec[element]

      parse(element_spec)
    end

    def parse_field(field_name)
      element_spec = @@spec.values.
                            select{|v| v['name'] == field_name}.
                            first

      parse(element_spec)
    end

    def parse(element_spec)
      xpath = "//#{element_spec['node']}"
      nodes = xml_doc.xpath(xpath)

      values = []
      begin
        nodes.each do |node|
          value = node.text

          if element_spec['data_type'] =~ /(text|combo)/i && 
             value =~ /^\d+$/ && 
             !element_spec['field_values'].nil?

            mapped_value = element_spec['field_values'][value.to_i]
            
            value = mapped_value unless mapped_value.nil?
          end

          values << value
        end
      rescue  error
        puts "Error: #{error}"
      end

      values
    end

    def parse_pair(name_element, value_element)
      name_element_spec = @@spec[name_element]
      names = parse(name_element_spec)

      value_element_spec = @@spec[value_element]
      values = parse(value_element_spec)

      result = {}
      names.size.times {|i| result[names[i]] = values[i]}
      result
    end

    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        parse_element(method_sym.to_s)
      else
        super
      end
    end

    def respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^[A-Z]\d{2}(_\d{2})?/
        true
      else
        super
      end
    end

    def to_html
      template = <<-EOS.gsub(/^\s{8}/, '')
        <h4>Wake County EMS System - Patient Care Record</h4>
        <font size="2">
          <b>Date:</b> 9/25/2011<br>
          <b>Incident #:</b>123456<br>
          <br>
        </font>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="14"><font color="blue" size="3">Patient Information</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Last</b></font></td>
              <td><font size="2">Doe</font></td>
              <td><font size="2"><b>First</b></font></td>
              <td><font size="2">John</font></td>
              <td><font size="2"><b>Middle</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>DOB</b></font></td>
              <td><font size="2">1/1/1970</font></td>
              <td><font size="2"><b>Gender</b></font></td>
              <td><font size="2">Male</font></td>
              <td><font size="2"><b>Weight</b></font></td>
              <td><font size="2">121 lbs</font></td>
              <td><font size="2"><b>SSN</b></font></td>
              <td><font size="2">555115555</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Address</b></font></td>
              <td><font size="2">101 Main Street</font></td>
              <td><font size="2"><b>Address 2</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>City</b></font></td>
              <td><font size="2">Raleigh</font></td>
              <td><font size="2"><b>State</b></font></td>
              <td><font size="2">NC</font></td>
              <td><font size="2"><b>Zip</b></font></td>
              <td><font size="2">27601</font></td>
              <td><font size="2"><b>Country</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Tel</b></font></td>
              <td><font size="2">9195551234</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Advanced Directive</b></font></td>
              <td colspan="13"><font size="2">State/EMS DNR Form</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="8"><font color="blue" size="3">Clinical Impression</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Primary Impression</b></font></td>
              <td><font size="2">Allergic Reaction</font></td>
              <td><font size="2"><b>Chief Complaint</b></font></td>
              <td><font size="2">Difficulty Breathing</font></td>
              <td><font size="2"><b>Injury</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Barriers of Care</b></font></td>
              <td><font size="2">Hearing Impaired</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Secondary Impression</b></font></td>
              <td><font size="2">Asthma</font></td>
              <td><font size="2"><b>Duration</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Medical/trauma</b></font></td>
              <td><font size="2">Medical</font></td>
              <td><font size="2"><b>Alcohol/Drugs</b></font></td>
              <td><font size="2">Smell of Alcohol on Breath</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Signs &amp; Symptoms</b></font></td>
              <td colspan="7"><font size="2">Allergic Reaction - Anaphylaxis -
              Unspecified</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="16"><font color="blue" size=
              "3">Medication/Allergies/History</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Medications</b></font></td>
              <td colspan="15"><font size="2">Prescription 23 MG</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Allergies</b></font></td>
              <td colspan="15"><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>History</b></font></td>
              <td colspan="15"><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td colspan="16"><font color="blue" size="3">Vital Signs</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Time</b></font></td>
              <td><font size="2"><b>AVPU</b></font></td>
              <td><font size="2"><b>Side</b></font></td>
              <td><font size="2"><b>POS</b></font></td>
              <td><font size="2"><b>BP</b></font></td>
              <td><font size="2"><b>Pulse</b></font></td>
              <td><font size="2"><b>RR</b></font></td>
              <td><font size="2"><b>SPO2</b></font></td>
              <td><font size="2"><b>ETCO2</b></font></td>
              <td><font size="2"><b>CO</b></font></td>
              <td><font size="2"><b>BG</b></font></td>
              <td><font size="2"><b>Temp</b></font></td>
              <td><font size="2"><b>Pain</b></font></td>
              <td><font size="2"><b>GCS</b></font></td>
              <td><font size="2"><b>RTS</b></font></td>
              <td><font size="2"><b>PTS</b></font></td>
            </tr>
            <tr>
              <td><font size="2">12:10</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">121/80 M</font></td>
              <td><font size="2">121 I</font></td>
              <td><font size="2">80 I</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">7</font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2">12:11</font></td>
              <td><font size="2">V</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">6</font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td colspan="16"><font color="blue" size="3">Flow Chart</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Time</b></font></td>
              <td colspan="2"><font size="2"><b>Treatment</b></font></td>
              <td colspan="11"><font size="2"><b>Description</b></font></td>
              <td colspan="2"><font size="2"><b>Provider</b></font></td>
            </tr>
            <tr>
              <td><font size="2">12:11</font></td>
              <td colspan="2"><font size="2">Benadryl</font></td>
              <td colspan="11"><font size="2">12 mg; Intravenous;</font></td>
              <td colspan="2"><font size="2">Lee, Stan</font></td>
            </tr>
            <tr>
              <td colspan="16"><font color="blue" size="3">Initial Assessment</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2"><b>Category</b></font></td>
              <td colspan="6"><font size="2"><b>Comments</b></font></td>
              <td colspan="2"><font size="2"><b>Abnormalities</b></font></td>
              <td colspan="6"><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2"><b>Mental Status</b></font></td>
              <td colspan="6"><font size="2">Nullam tortor nulla, tincidunt sit amet vehicula
              nec, tincidunt nec neque. Duis et venenatis nibh. Sed arcu augue, vehicula vitae
              adipiscing a, ultrices vel enim. Ut massa est, accumsan non ullamcorper vel,
              tempus vel arcu. Vivamus facilisis luctus iaculis. Quisque molestie felis quis
              urna consectetur ut iaculis magna sodales. Sed sit amet nunc id urna ultricies
              gravida eget ac nibh. Pellentesque nec nulla justo, suscipit ultrices
              leo.</font></td>
              <td colspan="2"><font size="2">Mental Status</font></td>
              <td colspan="6"><font size="2">Nullam tortor nulla, tincidunt sit amet vehicula
              nec, tincidunt nec neque. Duis et venenatis nibh. Sed arcu augue, vehicula vitae
              adipiscing a, ultrices vel enim. Ut massa est, accumsan non ullamcorper vel,
              tempus vel arcu. Vivamus facilisis luctus iaculis. Quisque molestie felis quis
              urna consectetur ut iaculis magna sodales. Sed sit amet nunc id urna ultricies
              gravida eget ac nibh. Pellentesque nec nulla justo, suscipit ultrices
              leo.</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2"><b>Skin</b></font></td>
              <td colspan="6"><font size="2">&nbsp;</font></td>
              <td colspan="2"><font size="2">Skin</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2" rowspan="3"><font size="2"><b>HEENT</b></font></td>
              <td colspan="6" rowspan="3"><font size="2"><b>&nbsp;</b></font></td>
              <td colspan="2"><font size="2">Head/Face</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Eyes</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Neck</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2" rowspan="3"><font size="2"><b>Chest</b></font></td>
              <td colspan="6" rowspan="3"><font size="2"><b>&nbsp;</b></font></td>
              <td colspan="2"><font size="2">Chest</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Heart Sounds</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Lung Sounds</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2" rowspan="5"><font size="2"><b>Abdomen</b></font></td>
              <td colspan="6" rowspan="5"><font size="2"><b>&nbsp;</b></font></td>
              <td colspan="2"><font size="2">General</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Left Upper</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Right Upper</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Left Lower</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Right Lower</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2" rowspan="3"><font size="2"><b>Back</b></font></td>
              <td colspan="6" rowspan="3"><font size="2"><b>&nbsp;</b></font></td>
              <td colspan="2"><font size="2">Cervical</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Thoracic</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Lumbar/Sacral</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2"><b>Pelvis/GU/GI</b></font></td>
              <td colspan="6"><font size="2">&nbsp;</font></td>
              <td colspan="2"><font size="2">Pelvis/GU/GI</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2" rowspan="6"><font size="2"><b>Extremities</b></font></td>
              <td colspan="6" rowspan="6"><font size="2"><b>&nbsp;</b></font></td>
              <td colspan="2"><font size="2">Left Arm</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Right Arm</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Left Leg</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Right Leg</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Pulse</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2">Capillary Refill</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
            <tr>
              <td colspan="2"><font size="2"><b>Neurological</b></font></td>
              <td colspan="6"><font size="2">&nbsp;</font></td>
              <td colspan="2"><font size="2">Neurological</font></td>
              <td colspan="6"><font size="2">No abnormalities</font></td>
            </tr>
          </tbody>
        </table><br>
        <font size="2"><b>Assessment Time:</b></font><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td><font color="blue" size="3">Narrative</font></td>
            </tr>
            <tr>
              <td><font size="2">Patient was having difficulty breathing after eating shell
              fish and the provider gave them benadryl. Lorem ipsum dolor sit amet, consectetur
              adipiscing elit. Praesent ac nibh tellus, vel interdum mi. Sed tempus ultricies
              eros sagittis ultrices. Curabitur ante erat, hendrerit sodales egestas nec,
              bibendum at nunc. Vestibulum in scelerisque risus. Nullam semper, elit at
              porttitor ultrices, orci ipsum tincidunt felis, id commodo tellus nunc in lorem.
              Aliquam non molestie risus. Quisque posuere, risus et rhoncus vestibulum, ligula
              sapien venenatis metus, sed semper magna nulla eu lectus. Proin interdum, eros
              sed fringilla tincidunt, orci velit dictum tellus, eget vestibulum elit eros vel
              turpis. Sed quam ligula, congue a tristique nec, porta id diam. Integer quis
              mauris metus, ac condimentum felis. Nullam lacinia nibh leo, sed varius ante.
              Nunc vitae lacus felis, rutrum condimentum ipsum. Maecenas pellentesque, libero
              ut viverra sagittis, eros odio volutpat arcu, quis adipiscing diam neque eget
              dolor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per
              inceptos himenaeos.</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="2"><font color="blue" size="3">Incident Details</font></td>
              <td colspan="2"><font color="blue" size="3">Destination Details</font></td>
              <td colspan="2"><font color="blue" size="3">Incident Times</font></td>
            </tr>
            <tr>
              <td><font size="2"><font size="2"><b>Location</b></font></font></td>
              <td><font size="2">Capital Building</font></td>
              <td><font size="2"><b>Disposition</b></font></td>
              <td><font size="2">Transported Lights/Siren</font></td>
              <td><font size="2"><b>Call Received</b></font></td>
              <td><font size="2">12:03:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Adress</b></font></td>
              <td><font size="2">101 West First Street</font></td>
              <td><font size="2"><b>Transport Due To</b></font></td>
              <td><font size="2">Patient</font></td>
              <td><font size="2"><b>Dispatched</b></font></td>
              <td><font size="2">12:04:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Address 2</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Transported To</b></font></td>
              <td><font size="2">WakeMed Main</font></td>
              <td><font size="2"><b>En Route</b></font></td>
              <td><font size="2">12:05:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>City</b></font></td>
              <td><font size="2">Raleigh</font></td>
              <td><font size="2"><b>Requested By</b></font></td>
              <td><font size="2">Patient</font></td>
              <td><font size="2"><b>Resp on Scene</b></font></td>
              <td><font size="2">12:06:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>State</b></font></td>
              <td><font size="2">NC</font></td>
              <td><font size="2"><b>Destination</b></font></td>
              <td><font size="2">Hospital ER</font></td>
              <td><font size="2"><b>On Scene</b></font></td>
              <td><font size="2">12:08:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Zip</b></font></td>
              <td><font size="2">27601</font></td>
              <td><font size="2"><b>Address</b></font></td>
              <td><font size="2">3000 New Bern Ave</font></td>
              <td><font size="2"><b>At Patient</b></font></td>
              <td><font size="2">12:09:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Medic Unit</b></font></td>
              <td><font size="2">CH100</font></td>
              <td><font size="2"><b>Address 2</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Depart Scene</b></font></td>
              <td><font size="2">12:10:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Run Type</b></font></td>
              <td><font size="2">911 Response (Emergency)</font></td>
              <td><font size="2"><b>City</b></font></td>
              <td><font size="2">Raleigh</font></td>
              <td><font size="2"><b>At Destination</b></font></td>
              <td><font size="2">12:11:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Priority Scene</b></font></td>
              <td><font size="2">Lights/Siren</font></td>
              <td><font size="2"><b>State</b></font></td>
              <td><font size="2">NC</font></td>
              <td><font size="2"><b>Pt. Transferred</b></font></td>
              <td><font size="2">12:12:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Shift</b></font></td>
              <td><font size="2">A-24</font></td>
              <td><font size="2"><b>Zip</b></font></td>
              <td><font size="2">27610</font></td>
              <td><font size="2"><b>Incident Close</b></font></td>
              <td><font size="2">12:13:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Zone</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Zone</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>In District</b></font></td>
              <td><font size="2">12:14:00</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Level of Service</b></font></td>
              <td><font size="2">Basic Life Support</font></td>
              <td><font size="2"><b>Condition at Destination</b></font></td>
              <td colspan="3"><font size="2">Improved</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Destination Record #</b></font></td>
              <td colspan="5"><font size="2">&nbsp;</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="4"><font color="blue" size="3">Crew Members</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Personnel</b></font></td>
              <td><font size="2"><b>Certification Number</b></font></td>
              <td><font size="2"><b>Role</b></font></td>
              <td><font size="2"><b>Certification Level</b></font></td>
            </tr>
            <tr>
              <td><font size="2">SMITH, JOHN</font></td>
              <td><font size="2">P0482732</font></td>
              <td><font size="2">Lead</font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2">COLLINS, BENNIE</font></td>
              <td><font size="2">P027804</font></td>
              <td><font size="2">Driver</font></td>
              <td><font size="2">EMT-Paramedic</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="8"><font color="blue" size="3">Insurance Details</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Insured's Name</b></font></td>
              <td><font size="2">John Doe</font></td>
              <td><font size="2"><b>State</b></font></td>
              <td><font size="2">NC</font></td>
              <td><font size="2"><b>Medicare</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Secondary Ins</b></font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2"><b>Relationship to Patient</b></font></td>
              <td><font size="2">Self</font></td>
              <td><font size="2"><b>Zip</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Medicaid</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Policy #</b></font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2"><b>Address 1</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Country</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Primary Insurance</b></font></td>
              <td><font size="2">BCBS</font></td>
              <td><font size="2"><b>Group #</b></font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2"><b>Address 2</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Phone</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Group #</b></font></td>
              <td><font size="2">ZXY12034</font></td>
              <td><font size="2"><b>Contact</b></font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2"><b>Address 3</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Primary Payer</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Policy #</b></font></td>
              <td><font size="2">123456789</font></td>
              <td><font size="2"><b>Dispatch Nature</b></font></td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><font size="2"><b>City</b></font></td>
              <td><font size="2">Raleigh</font></td>
              <td><font size="2"><b>Employer</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Job Related Injury</b></font></td>
              <td>&nbsp;</td>
              <td><font size="2"><b>Response Urgency</b></font></td>
              <td>&nbsp;</td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="4"><font color="blue" size="3">Mileage</font></td>
              <td colspan="2"><font color="blue" size="3">Delays</font></td>
              <td colspan="2"><font color="blue" size="3">Additional Agencies</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Scene</b></font></td>
              <td><font size="2">10102.0</font></td>
              <td><font size="2"><b>Start</b></font></td>
              <td><font size="2">10100.0</font></td>
              <td><font size="2"><b>Category</b></font></td>
              <td><font size="2"><b>Delays</b></font></td>
              <td colspan="2"><font size="2">Apex Fire Department</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Destination</b></font></td>
              <td><font size="2">10105.0</font></td>
              <td><font size="2"><b>End</b></font></td>
              <td><font size="2">10107.0</font></td>
              <td><font size="2">Dispatch Delays</font></td>
              <td><font size="2">Uncooperative Caller</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Loaded Miles</b></font></td>
              <td><font size="2">3.0</font></td>
              <td><font size="2"><b>Total Miles</b></font></td>
              <td><font size="2">7.0</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="6"><font color="blue" size="3">Next of Kin</font></td>
              <td colspan="3"><font color="blue" size="3">Personal Items</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Next of Kin Name</b></font></td>
              <td><font size="2">Jane Doe</font></td>
              <td><font size="2"><b>Address 1</b></font></td>
              <td><font size="2">1234 Some Street Way</font></td>
              <td><font size="2"><b>City</b></font></td>
              <td><font size="2">Raleigh</font></td>
              <td><font size="2"><b>Item</b></font></td>
              <td><font size="2"><b>Given To</b></font></td>
              <td><font size="2"><b>Comment</b></font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Relationship to Patient</b></font></td>
              <td><font size="2">Spouse</font></td>
              <td><font size="2"><b>Address 2</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>State</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2">Clothing</font></td>
              <td><font size="2">Spouse</font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Phone</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Address 3</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Zip</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td colspan="4"><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Country</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
          </tbody>
        </table><br>
        <table border="1" cellspacing="0" width="900">
          <tbody>
            <tr>
              <td colspan="4"><font color="blue" size="3">Transfer Details</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>PAN</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Sending Physician</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>PCS</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Sending Record #</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>ABN</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Receiving Physician</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>CMS Service Level</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Condition Code</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>ICD-9 Code</b></font></td>
              <td><font size="2">&nbsp;</font></td>
              <td><font size="2"><b>Condition Modifier Code</b></font></td>
              <td><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Transfer Reason</b></font></td>
              <td colspan="3"><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Other/Services</b></font></td>
              <td colspan="3"><font size="2">&nbsp;</font></td>
            </tr>
            <tr>
              <td><font size="2"><b>Medical Necessity</b></font></td>
              <td colspan="3"><font size="2">&nbsp;</font></td>
            </tr>
          </tbody>
        </table>
      EOS
    end
  end
end
