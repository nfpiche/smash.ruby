require_relative './set'

module SmashRuby
  module SetService
    def self.perform(results, slug)
      sets = []

      results.each do |_k, player|
        player.losses.each do |loss|
          sets << SmashRuby::Set.new(player.id, loss, slug)
        end
      end

      sets
    end
  end
end
