require 'spec_helper'

describe SmashRuby::Player do
  let(:attributes) do
    {
      'id' => 1,
      'losses' => [2, 3],
      'finalPlacement' => 1,
      'mutations' => {
        'participants' => {
          'some_key' => {
            'contactInfo' => {
              'nameFirst' => 'Bob',
              'nameLast'  => 'Johnson',
              'country'   => 'United States'
            }
          }
        },
        'players' => {
          'some_key' => {
            'name' => 'Bob Johnson',
            'prefix' => 'Slam',
            'gamerTag' => 'bobbo'
          }
        }
      }
    }
  end

  let(:player) { described_class.new(attributes) }

  it 'builds correctly' do
    expect(player.id).to eql(1)
    expect(player.losses).to eql([2, 3])
    expect(player.placement).to eql(1)
    expect(player.prefix).to eql('Slam')
    expect(player.tag).to eql('bobbo')
  end

  describe '.full_name' do
    it 'builds full name properly' do
      expect(player.full_name).to eql('Bob Johnson')
    end
  end

  describe '.full_tag' do
    context 'player has a prefix' do
      it 'builds full tag properly' do
        expect(player.full_tag).to eql('Slam | bobbo')
      end
    end

    context 'player does not have prefix' do
      it 'builds properly with nil prefix' do
        attributes['mutations']['players']['some_key']['prefix'] = nil
        player = described_class.new(attributes)

        expect(player.full_tag).to eql('bobbo')
      end

      it 'builds properly with empty string prefix' do
        attributes['mutations']['players']['some_key']['prefix'] = ''
        player = described_class.new(attributes)

        expect(player.full_tag).to eql('bobbo')
      end
    end
  end

  describe '.name_with_tag' do
    it 'puts tag between first and last name when only two names' do
      expect(player.name_with_tag).to eql('Bob "bobbo" Johnson')
    end
  end
end
