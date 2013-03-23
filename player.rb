class Player
	attr_reader :color

	def initialize(color)
		@color = color
	end

	def start_move_coordinates
    start_coord = [nil]
    until start_coord.all? {|x| !x.nil?}
      puts "Select the piece you would like to move! (for example A2)"
      start_coord = gets.chomp
      start_coord = parse(start_coord)
    end
    start_coord
	end

	def end_move_coordinates
    end_coord = [nil]
    until end_coord.all? {|x| !x.nil?}
      puts "Select where you would like to move!"
      end_coord = gets.chomp
      end_coord = parse(end_coord)
    end
    end_coord
	end

#REV try to use a real reg ex here
  def parse(untranslated_coordinates)
    letter = untranslated_coordinates.downcase.scan(/[a-h]/)[0]
    number = untranslated_coordinates.scan(/\d/)[0]
    [(8 - number.to_i), (letter.ord - "a".ord) ]
  end

end