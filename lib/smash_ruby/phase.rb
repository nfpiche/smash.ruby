require_relative './pool'
module SmashRuby
  class Phase
    attr_reader :id, :name, :results, :pools

    def initialize(phase_hash)
      @id = phase_hash.dig('id')
      @name = phase_hash.dig('name')
    end

    def build_pools(groups)
      @pools ||= []

      if name.include? 'Pool'
        groups.each do |group|
          if group.dig('phaseId') == id
            @pools << SmashRuby::Pool.new(group)
          end
        end
      end
    end
  end
end
