Class Interface 
  def get_coin_call(caller)
    puts "\n#{caller}, heads or tails?"
    gets.chomp.upcase
  end
end

class Game
  attr_accessor :turn

  def initialize(player1, player2, interface)
    @player1 = player1
    @player2 = player2
    @interface = interface
    @turn = coin_toss
  end

  private

  def coin_toss
    caller
    if @interface.get_coin_call(caller.name) == flip
      @turn = caller
    else
      @turn = [@player1, @player2].delete(caller)
    end
  end

  def caller
    [@player1, @player2].sample
  end

  def flip
    ["HEADS", "TAILS"].sample
  end
end
