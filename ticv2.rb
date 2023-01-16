# frozen_string_literal: true

require 'pry'

# Create player objects
class Player
  attr_reader :name,
              :marker,
              :player_choices

  def initialize(name, marker)
    @name = name
    @marker = marker
    validate_marker
    @player_choices = []
  end

  def validate_marker
    # Check that marker is 1 uppercase letter and not already taken
  end

  def add_choice(choice)
    @player_choices << choice
  end

  def reset_game
    @player_choices = []
  end
end

# Methods relating to displaying game status
module Display
  def print_board
    divider = '~~~~~~~~~'
    puts "\n\n#{@board[0]} | #{@board[1]} | #{@board[2]}\n#{divider}\n#{@board[3]} | #{@board[4]} | #{@board[5]}\n#{divider}\n#{@board[6]} | #{@board[7]} | #{@board[8]}\n\n"
  end
end

# Create game object
class Game
  include Display

  attr_reader :board,
              :game_over,
              :current_player,
              :available_spaces

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def create_game
    @game_over = false
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @available_spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @current_player = @player1
  end

  def play_turn(space)
    # Check if space is occupied
    while space_occupied?(space)
      puts 'That choice is invalid. Please enter an available space'
      space = gets.chomp.to_i
    end

    # Add space to player choices
    @current_player.add_choice(space)

    # Remove space from available choices
    @available_spaces.delete(space)

    # Place marker in space
    @board[space - 1] = @current_player.marker

    # Check if game is over
    win_logic

    # Swap players
    swap_players unless @game_over
  end

  private

  def win_logic
    p 'Running win_logic'
    winning_combinations = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7]
    ]

    player_combos = @current_player.player_choices.permutation(3).to_a
    unless player_combos == []
      winning_combinations.each do |winning_combo|
        @game_over = true if player_combos.include?(winning_combo)
      end
    end
  end

  def space_occupied?(space)
    occupied = false
    # If space = default set occupied to true
    occupied = true if @board[space - 1].to_i != space
    occupied
  end

  def whose_turn
    @current_player
  end

  def swap_players
    case @current_player
    when @player1
      @current_player = @player2
    when @player2
      @current_player = @player1
    else
      puts 'PlayerSwapError'
    end
  end
end

puts 'Welcome to Tic-Tac-Toe! Player 1, please enter your name:'
player1_name = gets.chomp
# player1_name = "Cooper"

puts 'Please type an uppercase letter to be your tic-tac-toe symbol:'
player1_marker = gets.chomp
# player1_marker = "C"

player1 = Player.new(player1_name, player1_marker)

puts 'Player 2, please enter your name:'
player2_name = gets.chomp
# player2_name = "Aly"

puts "Please type an uppercase letter to be your tic-tac-toe symbol (Player 1 picked #{player1.marker}): "
player2_marker = gets.chomp
# player2_marker = "A"

player2 = Player.new(player2_name, player2_marker)

game = Game.new(player1, player2)
game.create_game

# Loop until game is over
until game.game_over
  game.print_board
  puts "It is #{game.current_player.name}'s turn.\nPlease pick an open space:"
  game.play_turn(gets.chomp.to_i)
  # game.play_turn(1)
  # p game.board, game.available_spaces
end

p "Game over! #{game.current_player.name} wins!"
