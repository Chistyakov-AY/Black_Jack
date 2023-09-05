require_relative 'player'

class Main
  attr_reader :players, :cards
  attr_accessor :game_bank

  SUIT = ["♧", "♡", "♤", "♢"]
  HASH = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10,
    'A' => 11,
  }

  def initialize
    @players = []
    @cards = []
    @game_bank = 0
    HASH.keys.each do |suit|
      SUIT.each { |value| cards << [suit, value] }
    end
    cards.shuffle!
    puts 'Введите имя игрока'
    create_players(gets.chomp.capitalize)

  end

  def start
    game_bank = 20
    first_deal_of_cards
    @player_sum = calc players[0]
    @dealer_sum = calc(players[1])
    puts "Карты игрока - #{players[0].player_cards}, очки - #{@player_sum}, деньги - #{players[0].bank}"
    print "Карты дилера - "
    print '* ' * players[1].player_cards.length
    puts ", деньги - #{players[1].bank}"
    puts "Деньги в банке - #{game_bank}"
    game_menu
  end

  def game_menu
    puts 'Введите 1, - Пропустить'
    puts 'Введите 2, - Добавить карту'
    puts 'Введите 3, - Открыть карты'
    menu = gets.chomp

    case menu
    when '1' then skip
    when '2' then add_a_card
    when '3' then open_cards
    end
  end

  def create_players(name)
    players << Player.new(name)
    players << Player.new('Dealer')
    puts "#{players[0].name}, добро пожаловать в интерактивную игру Black Jack!\n\n"
  end

  def first_deal_of_cards
    players.each do |value| 
      2.times do
        value.player_cards << cards.delete_at(0)
        cards.shuffle!
      end
    end
    
    players.each do |value|
      value.bank -= 10
    end
  end

  def calc(player)
    xx = player.player_cards.map(&:first)
    sum = xx.map { |x| HASH[x] }.sum
    xx.each { |x| sum -= 10 if sum > 21 && x == 'A' }
    sum
  end

  def skip
    puts 'Ход переходит к Дилеру'
    if @dealer_sum < 17 && players[1].player_cards.length.to_i < 2
        players[1].player_cards << cards.delete_at(0)
        @dealer_sum = calc(players[1])
        open_cards
    else
      open_cards
    end
    puts "Карты игрока - #{players[0].player_cards}, очки - #{@player_sum}, деньги - #{players[0].bank}"
    puts "Карты дилера - #{players[1].player_cards}, очки - #{@dealer_sum}, деньги - #{players[1].bank}"
    puts "Деньги в банке - #{game_bank}"
    game_menu
  end

  def add_a_card
    if @dealer_sum < 17 && players[1].player_cards.length < 2
      players[0].player_cards << cards.delete_at(0)
      players[1].player_cards << cards.delete_at(0)
      @dealer_sum = calc players[1]
      @player_sum = calc players[0]
      open_cards
    else
      players[0].player_cards << cards.delete_at(0)
      @player_sum = calc players[0]
      open_cards
    end
  end
 
  def open_cards
    if @dealer_sum < 17 && players[1].player_cards.length < 4
      players[1].player_cards << cards.delete_at(0)
      @dealer_sum = calc players[1]
    end

    puts 'Итоги игры:'
    if @player_sum < @dealer_sum && @dealer_sum < 22
      puts "Победил Дилер"
      players[1].bank += 20
      elsif @player_sum < @dealer_sum && @dealer_sum > 22
        puts "Победил Игрок"
        players[0].bank += 20
        elsif @player_sum > @dealer_sum && @player_sum < 22
          puts "Победил Игрок"
          players[0].bank += 20
          elsif @player_sum > @dealer_sum && @player_sum > 22
            puts "Победил Дилер"
            players[1].bank += 20
            elsif @player_sum > 22 && @player_sum > 22
              puts "Ничья"
              players[0].bank += 10
              players[1].bank += 10
            else
              puts "Ничья"
              players[0].bank += 10
              players[1].bank += 10
    end
    puts "Карты игрока - #{players[0].player_cards}, очки - #{@player_sum}, деньги - #{players[0].bank}"
    puts "Карты дилера - #{players[1].player_cards}, очки - #{@dealer_sum}, деньги - #{players[1].bank}"
    puts "Деньги в банке - #{game_bank.to_i}\n\n"
    puts "Продолжить - 1, выход - 0"
    menu = gets.chomp

    case menu
    when '1' then
      if players[0].bank != 0 || players[0].bank != 0
        players[0].player_cards = []
        players[1].player_cards = []
        start
      else 
        puts "У Диллера или Игрока закончились деньги!!!"
        exit
      end
    when '0' then 
      puts "Игра окончена, всего хорошего!!!\n\n"
      exit
    end
  end
end

st = Main.new
st.start
