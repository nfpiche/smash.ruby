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

        tournament = SmashRuby::Tournament.find('the-big-house-6')

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

  describe '.available_phases' do
    it 'returns expected available phases' do
      VCR.use_cassette('one_tournament') do
        tournament = SmashRuby::Tournament.find('the-big-house-6')

        VCR.use_cassette('tournament_phases') do
          phases = tournament.available_phases

          expect(phases.keys).to eq([:'melee-singles', :'melee-doubles'])
        end
      end
    end
  end

  describe '.fetch_phase_results' do
    it 'returns results when phase exists for tournament' do
      VCR.use_cassette('one_tournament') do
        tournament = SmashRuby::Tournament.find('the-big-house-6')

        VCR.use_cassette('tournament_phases') do
          VCR.use_cassette('tournament_phase_results') do
            phase = tournament.available_phases.dig(:'melee-singles').last
            standings = tournament.fetch_phase_results('melee-singles', phase)
            expect(standings.size).to eql(64)
          end
        end
      end
    end

    it 'returns an error when phases does not exist for tournament' do
      VCR.use_cassette('one_tournament') do
        tournament = SmashRuby::Tournament.find('the-big-house-6')

        VCR.use_cassette('tournament_phases') do
          VCR.use_cassette('tournament_phase_results') do
            result = tournament.fetch_phase_results('melee-singles', SmashRuby::Phase.new({'name' => 'fake'}))
            expect(result.is_a?(SmashRuby::Errors::NotFoundError)).to be true
            expect(result.model).to eql('phase')
          end
        end
      end
    end
  end

  describe '.fetch_complete_results_for_event' do
    it 'returns results for each event' do
      VCR.use_cassette('one_tournament') do
        tournament = SmashRuby::Tournament.find('the-big-house-6')

        VCR.use_cassette('tournament_phases') do
          VCR.use_cassette('complete_tournament_phase_results') do
            result = tournament.fetch_complete_results_for_event('melee-singles')
            expect(result.size).to eql(1563)
            expect(tournament.entrants).to eql(result.size)
            expect(result.first.tag).to eql('Mang0')
            expect(result.last.tag).to eql('Link Master 3000')
          end
        end
      end
    end
  end
end
