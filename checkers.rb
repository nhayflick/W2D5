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
				if (row_index + space_index).odd?
					@board[row_index][space_index] = Man.new(:black) if row_index < 3
					@board[row_index][space_index] = Man.new(:red) if row_index > 4
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
    return @board[coordinates[0]][coordinates[1]].color if @board[coordinates[0]][coordinates[1]]
  end

  def move_piece(start_pos, end_pos)
    pick_up_piece = get_square(start_pos)
    set_square(start_pos, nil)
    set_square(end_pos, pick_up_piece)
    #must take out other pieces
  end

  #def valid?
    #if start_pos
  #end

  def display
    square_colors = [:red, :black]
    self.board.each_with_index do |row, r_index|
      print "#{8 - r_index} "
      row.each_with_index do |space, s_index|
        print_piece = (space.nil?) ?  "  " : " O"
        bg_color = (r_index + s_index).odd? ? square_colors[0] : square_colors[1]
        print print_piece.colorize( :background => bg_color)
      end
      print "\n"
    end
    puts "   A B C D E F G H"
  end
end
