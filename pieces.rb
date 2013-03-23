class Man
	attr_reader :color, :possible_moves, :symbol

	def initialize(color)
		@color = color
		@possible_moves = []
		if @color == :black
			@possible_moves += [[-1,1],[-1,-1]]
		else
			@possible_moves += [[1,1],[1,-1]]
		end
    @symbol = " O"
	end

end

class King < Man
	def initialize(color)
		super(color)
		if @color == :black
			@possible_moves += [[1,1],[-1,1]]
		else
			@possible_moves += [[-1,1],[-1,-1]]
		end
    @symbol = " K"
	end
end