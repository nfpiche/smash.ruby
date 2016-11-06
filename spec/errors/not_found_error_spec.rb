require './spec/spec_helper'

describe SmashRuby::Errors::NotFoundError do
  let(:error) { SmashRuby::Errors::NotFoundError.new('type', 'request') }

  it 'builds properties correctly' do
    expect(error.model).to eql('type')
    expect(error.request).to eql('request')
  end

  describe '.to_json' do
    it 'properly serializes error fields' do
      expect(error.to_json).to eql({
        model: 'type',
        status: 404,
        error: 'Not found with request: request'
      }.to_json)
    end
  end
end
