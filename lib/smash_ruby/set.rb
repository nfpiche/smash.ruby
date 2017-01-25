module SmashRuby
  class Set
    attr_reader :player_one, :player_two, :winner, :tournament

    def initialize(player_one, player_two, tournament)
      @player_one = player_one
      @player_two = player_two
      @tournament = tournament
    end

    def winner
      player_two
    end
  end
end
