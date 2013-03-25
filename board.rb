load 'pieces.rb'
require 'colorize'

class Board
  attr_reader :board

	def initialize
		@board = Array.new(8) { Array.new(8) }
    dead_pieces = []
		setup_board
	end

	def setup_board
		@board.each_with_index do |row, row_index|
			row.each_with_index do |space, space_index|
				if (row_index + space_index).even? #REV: smart way to setup your pieces
					@board[row_index][space_index] = Man.new(:red) if row_index < 1
					@board[row_index][space_index] = Man.new(:black) if row_index > 6
				end
			end
		end
	end

	def get_square(coordinates)
    @board[coordinates[0]][coordinates[1]]
	end

  def set_square(coordinates, value)
    @board[coordinates[0]][coordinates[1]] = value
  end

  def get_color(coordinates)
    unless coordinates.nil?
      return get_square(coordinates).color if get_square(coordinates)
    end
    false
  end

  #def []coordinates
    #@board[coordinates[0]][coordinates[1]]
  #end

  #REV: get rid of puts. Should a board move_piece? or should the player?
  def move_piece(start_pos, end_pos)
    pick_up_piece = get_square(start_pos)
    puts 1
    travel_distance = [end_pos[0] - start_pos[0], end_pos[1] - start_pos[1]]
    puts 2
    range = travel_distance[0].abs
    puts 3
    travel_vector = travel_distance.collect{|direction| direction / range} 
    puts 4
    puts "range = #{range}"
    range.times do |x|
      puts 5
      set_square(start_pos, nil)
      puts 6
      next_pos = [start_pos[0] + travel_vector[0] * x, start_pos[1] + travel_vector[1] * x]
      puts 7
      set_square(next_pos, nil)
      puts 8
      set_square(end_pos, pick_up_piece)
    end
  end

  def move_valid?(start_pos, end_pos)
    return false if end_pos.nil? || (end_pos[0] + end_pos[1]).odd? || end_pos.any? {|x| x < 0 || x > 7} || get_square(end_pos)
    true
  end

  def slide_possible?(start_pos, end_pos)
    #clean this up so it is only done once when getting the start coord and then passed after that
    piece_to_move = get_square(start_pos)
    proposed_vector = []
    2.times do |i|
      proposed_vector << end_pos[i] - start_pos[i]
    end
    piece_to_move.possible_moves.include?(proposed_vector)
  end

  def this_jump_possible?(start_pos, end_pos)
    piece_to_move = get_square(start_pos)
    proposed_vector = []
    2.times do |i|
      proposed_vector << (end_pos[i]/2 - start_pos[i]/2)
    end
    return false unless piece_to_move.possible_moves.include?(proposed_vector)
    #better way to do this below?
    #CHANGED
    target_coords = [start_pos[0] + proposed_vector[0], start_pos[1] + proposed_vector[1]]
    self_color = get_color(start_pos)
    return false unless get_square(target_coords) && get_color(target_coords) != self_color
    #kill player they jumped
    return true
  end

  def make_jump(start_pos, end_pos, target_pos)
    move_piece(start_pos, end_Pos)
  end

  def additional_jump_possible?(start_pos)
    jump_vectors = []
    piece_to_move = get_square(start_pos)
    piece_to_move.possible_moves.each do |vector|
      a_vector = []
      a_vector << vector[0] * 2 + start_pos[0]
      a_vector << vector[1] * 2 + start_pos[1]
      jump_vectors << a_vector
    end

    puts jump_vectors.any? do |vector| 
      a = this_jump_possible?(start_pos, vector) && move_valid?(start_pos, vector)
      p "any iteration: #{vector}"
      p a
    end
    p "whole any: "
    

    jump_vectors.any? do |vector| 
      this_jump_possible?(start_pos, vector) && move_valid?(start_pos, vector)
    end
  end

  def display(selected_square = nil)
    square_colors = [:white, :black, :yellow]
    @board.each_with_index do |row, r_index|
      print "#{8 - r_index} "
      row.each_with_index do |space, s_index|
        print_piece = (space.nil?) ?  "  " : space.symbol
        color = get_color([r_index,s_index])
        if selected_square && get_square(selected_square) == space
          bg_color = :yellow
        else
          bg_color = (r_index + s_index).even? ? square_colors[0] : square_colors[1]
        end
        print print_piece.colorize( :color => color, :background => bg_color)
      end
      print "\n"
    end
    puts "   A B C D E F G H"
  end
end
