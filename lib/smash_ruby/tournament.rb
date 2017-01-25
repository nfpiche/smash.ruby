require 'dry-monads'
require 'pry'
require 'json'
require_relative './request'
require_relative './phase'
require_relative './player'


module SmashRuby
  class Tournament
    BASE_URL = 'https://api.smash.gg/tournament'.freeze
    M = Dry::Monads
    attr_reader :id, :name, :start_date, :end_date, :venue_name, :venue_address, :slug, :entrants, :sets

    def initialize(attributes)
      @id = attributes.dig('id')
      @name = attributes.dig('name')
      @slug = attributes.dig('slug')
      @start_date = Time.at(attributes.dig('startAt'))
      @end_date = Time.at(attributes.dig('endAt'))
      @venue_name = attributes.dig('venueName')
      @venue_address = attributes.dig('venueAddress')
    end

    def melee_results
      @melee_singles_results ||= fetch_singles
    end

    def available_phases
      @available_phases ||= fetch_phases
    end

    def self.find(slug)
      url = "#{BASE_URL}/#{slug}"
      response = SmashRuby::Request.get(url, slug, 'tournament')

      response.fmap do |result|
        new(result.dig('entities', 'tournament').merge('slug' => slug))
      end.value
    end

    def fetch_phase_results(event, phase)
      get_id(event, phase.name).fmap do |id|
        players = []
        if phase.pools.empty?
          url = "#{BASE_URL}/#{slug}/event/#{event}/phase_groups?expand[]=results&filter={\"phaseId\": \"#{id}\"}&getSingleBracket=true"
          players << get_player_results(url)
        else
          phase.pools.each do |pool|
            url = "#{BASE_URL}/#{slug}/event/#{event}/phase_groups?expand[]=results&filter={\"phaseId\": \"#{id}\", \"id\": \"#{pool.id}\"}&getSingleBracket=true"
            players << get_player_results(url)
          end
        end

        players.flatten
      end.value
    end

    def get_player_results(url)
      response = SmashRuby::Request.get(url, slug, 'tournament')

      response.fmap do |result|
        data = result.dig('items', 'entities')
        standings = data.dig('standings')
        entrants = data.dig('entrants')

        players = []
        entrants.each do |e|
          standings.each do |s|
            if s.dig('id').include? e.dig('id').to_s
              players << SmashRuby::Player.new(s.merge(e))
            end
          end
        end

        players
      end.value
    end

    def fetch_complete_results_for_event(event)
      players = []

      available_phases.dig(event.to_sym).each do |phase|
        players << fetch_phase_results(event.to_sym, phase)
      end

      results = dedupe_and_combine_players(players)
      build_sets(results)
      results.values.sort_by(&:placement)
    end

    private

    def fetch_phases
      {
        'melee-singles': fetch_single_event('melee-singles'),
        'melee-doubles': fetch_single_event('melee-doubles')
      }
    end

    def fetch_single_event(event)
      url = "#{BASE_URL}/#{slug}/event/#{event}?expand[]=phase&expand[]=groups"
      response = SmashRuby::Request.get(url, slug, 'tournament')

      response.fmap do |result|
        result.dig('entities', 'phase').map do |phase|
          groups = result.dig('entities', 'groups')
          built_phase = SmashRuby::Phase.new(phase)
          built_phase.build_pools(groups)
          built_phase
        end
      end.value
    end

    def get_id(event, phase)
      fetched_phase = available_phases[event.to_sym].select { |p| p.name == phase }.first

      if fetched_phase.nil?
        M.Left(
          SmashRuby::Errors::ErrorHandler.build_error(
            'phase',
            "Phase: #{phase} does not exist for #{event}",
            404
          )
        )
      else
        M.Right(fetched_phase.id)
      end
    end

    def dedupe_and_combine_players(players)
      clean_players = {}

      players.flatten.each do |p|
        if clean_players[p.id].nil?
          clean_players[p.id] = p
        else
          clean_players[p.id].losses += p.losses
          clean_players[p.id].losses.flatten!
        end
      end

      @entrants = clean_players.size
      clean_players
    end

    def build_sets(results)
      @sets ||= []
      results.each do |k, v|
        v.losses.each do |l|
          @sets << { player1: v.id, player2: l, winner: l, tournament: slug }
        end
      end
    end
  end
end
