# frozen_string_literal: true

require 'pry'

# Create player objects
class Player
  attr_accessor :win_count

  attr_reader :name,
              :marker,
              :player_choices

  def initialize(name, marker)
    @name = name
    validate_marker(marker)
    @player_choices = []
    @win_count = 0
  end

  def validate_marker(marker)
    @marker = marker.to_s
    # Check that marker is 1 uppercase letter and not already taken
    until (@marker =~ /[A-Z]*/).zero? && @marker.length == 1
      puts 'You entered an invalid selection. Please enter 1 uppercase letter.'
      @marker = gets.chomp
    end
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
    puts "\n\n#{@board[0]} | #{@board[1]} | #{@board[2]}\n#{divider}\n#{@board[3]} | #{@board[4]} | #{@board[5]}\n" \
         "#{divider}\n#{@board[6]} | #{@board[7]} | #{@board[8]}\n\n"
  end
end

# Create game object
class Game
  include Display

  attr_reader :board,
              :game_over,
              :current_player,
              :available_spaces,
              :stalemate

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def create_game
    @game_over = false
    @stalemate = false
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

    # Check for stalemate
    check_stalemate

    # Swap players
    swap_players unless @game_over
  end

  def reset_game
    @game_over = false
    @stalemate = false
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @available_spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @player1.reset_game
    @player2.reset_game
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

  private

  def win_logic
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

  def check_stalemate
    if @available_spaces.empty? && !@game_over
      @stalemate = true
      @game_over = true
    end
  end
end

player1_name = ''
player1_marker = ''
player2_name = ''
player2_marker = ''

puts 'Welcome to Tic-Tac-Toe! Player 1, please enter your name:'
# while player1_name.empty? { player1_name = gets.chomp }
player1_name = gets.chomp while player1_name.empty?

puts 'Please type an uppercase letter to be your tic-tac-toe symbol:'
# while player1_marker.empty? { player1_marker = gets.chomp }
player1_marker = gets.chomp while player1_marker.empty?

player1 = Player.new(player1_name, player1_marker)

puts 'Player 2, please enter your name:'
# while player2_name.empty? { player2_name = gets.chomp }
player2_name = gets.chomp while player2_name.empty?

puts "Please type an uppercase letter to be your tic-tac-toe symbol (#{player1.name} picked #{player1.marker}): "
# while player2_marker.empty? { player2_marker = gets.chomp }
player2_marker = gets.chomp while player2_marker.empty?

while player2_marker == player1.marker
  puts "You can't pick the same marker as #{player1.name}"
  player2_marker = gets.chomp
end

player2 = Player.new(player2_name, player2_marker)
quit_game = false

game = Game.new(player1, player2)
game.create_game

until quit_game
  # Loop until game is over
  until game.game_over
    game.print_board
    puts "It is #{game.current_player.name}'s turn.\nPlease pick an open space:"
    game.play_turn(gets.chomp.to_i)
    # game.play_turn(1)
    # p game.board, game.available_spaces
  end

  game.current_player.win_count += 1 unless game.stalemate
  game.print_board

  puts "Game over! #{game.current_player.name} wins!" unless game.stalemate
  puts 'Game over! It\'s a tie!' if game.stalemate
  puts "Current score: #{player1.name}: #{player1.win_count} | #{player2.name}: #{player2.win_count}"
  puts 'Would you like to play again? (yes/no)'
  case gets.chomp
  when 'yes'
    quit_game = false
    game.reset_game
    game.swap_players
  when 'no'
    quit_game = true
    puts 'Thanks for playing!'
  else
    puts 'An error has occured'
    quit_game = true
  end
end
