require 'spec_helper'

describe SmashRuby::SetService do
  let(:results) do
    {
      one: double('player', id: 1, losses: [2, 3]),
      two: double('player', id: 2, losses: [4, 5])
    }
  end
  let(:slug) { 'foo' }

  describe '.perfom' do
    it 'builds the proper sets' do
      result = described_class.perform(results, slug)

      expect(result.size).to eql(4)
      result.each do |set|
        expect(set.tournament).to eql(slug)
      end
    end
  end
end
