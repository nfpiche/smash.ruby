module SmashRuby
  class Player
    attr_reader :id, :tag, :prefix, :placement, :first_name, :last_name, :full_name, :country
    attr_accessor :losses

    def initialize(attributes)
      @id = attributes.dig('id')
      @losses = attributes.dig('losses')
      @placement = attributes.dig('finalPlacement')
      build_name(attributes.dig('mutations'))
    end

    def full_name
      @full_name ||= "#{first_name} #{last_name}"
    end

    def full_tag
      prefix.to_s.empty? ? tag : "#{prefix} | #{tag}"
    end

    def name_with_tag
      "#{first_name} \"#{tag}\" #{last_name}"
    end

    private

    def build_name(player_hash)
      _contact_key, contact_info = player_hash.dig('participants').first
      _player_key, player_info = player_hash.dig('players').first

      @first_name = contact_info.dig('contactInfo', 'nameFirst')
      @last_name = contact_info.dig('contactInfo', 'nameLast')
      @country = contact_info.dig('contactInfo', 'country')
      @prefix = player_info.dig('prefix')
      @tag = player_info.dig('gamerTag')
    end
  end
end
