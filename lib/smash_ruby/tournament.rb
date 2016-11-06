require 'faraday'
require 'json'

BASE_URL = 'https://api.smash.gg'

module SmashRuby
  class Tournament
    attr_reader :id, :name, :start_date, :end_date, :venue_name, :venue_address


    def initialize(attributes)
      @id = attributes.dig('id')
      @name = attributes.dig('name')
      @start_date = Time.at(attributes.dig('startAt'))
      @end_date = Time.at(attributes.dig('endAt'))
      @venue_name = attributes.dig('venueName')
      @venue_address = attributes.dig('venueAddress')
    end

    def self.find(slug)
      response = Faraday.get("#{BASE_URL}/tournament/#{slug}")

      if response.success?
        attributes = JSON.parse(response.body)
        new(attributes.dig('entities', 'tournament'))
      else
        SmashRuby::Errors::ErrorHandler.build_error(self, slug, response.status)
      end
    end

    def self.model_name
      'Tournament'
    end
  end
end
