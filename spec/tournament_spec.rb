require './spec/spec_helper'

describe SmashRuby::Tournament do
  describe '.find' do
    it 'returns a tournament when the slug is an existing tournament' do
      VCR.use_cassette('one_tournament') do
        expected_fields = [
          :id,
          :name,
          :start_date,
          :end_date,
          :venue_name,
          :venue_address,
        ]

        tournament = SmashRuby::Tournament.find('smash-summit-3')

        expected_fields.each do |f|
          expect(tournament.respond_to?(f)).to be true
        end
      end
    end

    it 'returns a not found error when the slug does not match' do
      VCR.use_cassette('not_found_tournament') do
        result = SmashRuby::Tournament.find('fake-fake-fake')

        expect(result.is_a?(SmashRuby::Errors::NotFoundError)).to be true
      end
    end
  end
end
