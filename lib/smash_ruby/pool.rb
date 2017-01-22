module SmashRuby
  class Pool
    attr_reader :id, :phase_id, :identifier, :entrants_advancing

    def initialize(attributes)
      @id = attributes.dig('id')
      @phase_id = attributes.dig('phaseId')
      @identifier = attributes.dig('displayIdentifier')
      @entrants_advancing = attributes.dig('numProgressing')
    end
  end
end
