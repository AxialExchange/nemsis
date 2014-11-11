require 'nemsis'

describe Nemsis::Reproducer do
  context 'class methods' do
    describe '.initialize' do
      it 'raises error with no arguments' do
        expect {
          reproducer = Nemsis::Reproducer.new
        }.to raise_error
      end

      it 'returns object with xml string argument' do
        sample_xml_file = File.expand_path('../../data/sample_2.xml', __FILE__)
        xml_str = File.read(sample_xml_file)

        reproducer = Nemsis::Reproducer.new(xml_str)
        expect(reproducer).not_to be_nil
        expect(reproducer.is_a?(Nemsis::Reproducer)).to be_truthy
      end
    end
  end

  context 'instance methods' do
    let(:reproducer) {
      sample_xml_file = File.expand_path('../../data/sample_2.xml', __FILE__)
      xml_str = File.read(sample_xml_file)

      Nemsis::Reproducer.new(xml_str)
    }

    before(:each) do end

    describe '#last_name=' do
      it 'sets last_name' do
        reproducer.last_name = 'Donohue'
        expect(reproducer.last_name).to eq('Donohue')
      end
    end

    describe '#first_name=' do
      it 'sets first_name' do
        reproducer.first_name = 'Jonathan'
        expect(reproducer.first_name).to eq('Jonathan')
      end
    end

    describe '#middle_name=' do
      it 'sets middle_name' do
        reproducer.middle_name = 'G'
        expect(reproducer.middle_name).to eq('G')
      end
    end

    describe '#dob=' do
      it 'sets dob' do
        reproducer.dob = '1975-01-01'
        expect(reproducer.dob).to eq('1975-01-01')
      end
    end

    describe '#gender_code=' do
      it 'sets gender_code' do
        reproducer.gender_code = '655'
        expect(reproducer.gender_code).to eq('655')
      end
    end

    describe '#gender=' do
      it 'sets gender' do
        reproducer.gender = 'Female'
        expect(reproducer.gender_code).to eq('655')
      end
    end

    describe '#pcr_id=' do
      it 'sets pcr_id' do
        reproducer.pcr_id = 'IOQJEPOIQH3I'
        expect(reproducer.pcr_id).to eq('IOQJEPOIQH3I')
      end
    end

    describe '#dispatch_time=' do
      it 'sets dispatch_time_str' do
        time_str = '2012-04-28T04:05:00Z'
        reproducer.dispatch_time = Time.parse(time_str)
        expect(reproducer.dispatch_time_str).to eq(time_str)
      end
    end

    describe '#transferred_to_name=' do
      it 'sets transferred_to_name' do
        reproducer.transferred_to_name = 'WakeMed Main'
        expect(reproducer.transferred_to_name).to eq('WakeMed Main')
      end
    end

    describe '#transferred_to_code=' do
      it 'sets transferred_to_code' do
        reproducer.transferred_to_code = 'F00002506'
        expect(reproducer.transferred_to_code).to eq('F00002506')
      end
    end

    describe '#transferred_to=' do
      it 'sets transferred_to' do
        reproducer.transferred_to = 'WakeMed Cary'
        expect(reproducer.transferred_to_name).to eq('WakeMed Cary')
        expect(reproducer.transferred_to_code).to eq('F00002573')
      end
    end

    describe '#patient_number=' do
      it 'sets patient_number' do
        reproducer.patient_number = '123456789'
        expect(reproducer.patient_number).to eq('123456789')
      end
    end

    describe '#hospital_chart_number=' do
      it 'sets hospital_chart_number' do
        reproducer.hospital_chart_number = '1234/56789'
        expect(reproducer.hospital_chart_number).to eq('1234/56789')
      end
    end
  end
end
