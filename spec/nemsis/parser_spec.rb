require 'nemsis'

describe Nemsis::Parser do
  describe '.initialize' do
    it 'returns nil with no arguments' do
      expect {
        parser = Nemsis::Parser.new
      }.to raise_error
    end
  end
end
