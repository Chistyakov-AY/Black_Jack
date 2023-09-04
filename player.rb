class Player
  attr_reader :name
  attr_accessor :bank, :player_cards

  def initialize (name)
    @name = name
    @player_cards = []
    @bank = 100
  end
end
