module SmashRuby
  class Player
    attr_reader :id, :name, :placement
    attr_accessor :losses

    def initialize(attributes)
      @id = attributes.dig('participantIds').first
      @name = attributes.dig('name')
      @losses = attributes.dig('losses')
      @placement = attributes.dig('finalPlacement')
    end
  end
end
