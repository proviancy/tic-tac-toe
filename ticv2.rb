# Create player objects
class Player
  attr_reader :name, :symbol
  
  @player_choices = []

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def add_choice(choice)
    @player_choices << choice
  end

  def reset_game
    @player_choices = []
  end
end

class Game
  attr_accessor :board, :game_over
  
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def create_game
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @available_spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def place_marker(space)
    # Check if space is occupied

    # Add space to player choices

    # Remove space from available choices

    # Place marker in space

    # Print board

    # Check if game is over
    win_logic()
  end

  private

  def win_logic
    @game_over = false
    winning_combinations = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7],
    ]
    # If player choices.contains winning combination
    @game_over = true
  end
end

player1 = Player.new("C","X")
player2 = Player.new("A","O")

game = Game.new(player1, player2)
game.create_game

p game.board