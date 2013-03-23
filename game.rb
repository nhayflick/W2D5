load 'board.rb'
load 'pieces.rb'
load 'player.rb'

class Game
  def initialize
    @checkers = Board.new
    @players = [Player.new(:black), Player.new(:red)]
    play
  end

  def play
    #until checkers.game_over?
    until false
      current_color = @players[0].color
      puts "#{current_color.to_s}'s move!"
      @checkers.display
      turn_completed = false
      start_pos, end_pos = nil, nil
      #Should I make a get_color(start_pos) method that returns nil when no square?
      until @checkers.get_color(start_pos) == current_color
        start_pos = @players[0].start_move_coordinates
      end
      @checkers.display(start_pos)
      # Gotta make valid
      until turn_completed == true
        end_pos = @players[0].end_move_coordinates
        next unless @checkers.move_valid?(start_pos, end_pos)
        if slide?(start_pos, end_pos)
          turn_completed = attempt_slide(start_pos, end_pos)
        elsif jump?(start_pos, end_pos)
          if attempt_jump(start_pos, end_pos)
            @checkers.display
            if look_for_additional_jumps(end_pos)
              start_pos = end_pos
              @checkers.display(start_pos)
              turn_completed = false
            else
              turn_completed = true
            end 
          else
            turn_completed = false
          end
        else
          next
        end
      end
      check_for_kings(current_color)
      @players.reverse!
    end
  end

  def slide?(start_pos, end_pos)
    (end_pos[0] - start_pos[0]).abs == 1 && (end_pos[1] - start_pos[1]).abs == 1
  end

  def attempt_slide(start_pos, end_pos)
    if @checkers.slide_possible?(start_pos, end_pos)
      @checkers.move_piece(start_pos, end_pos) 
      return true
    end
    puts "You can't move there!"
    false
  end

  def jump?(start_pos, end_pos)
    (end_pos[0] - start_pos[0]).abs == 2 && (end_pos[1] - start_pos[1]).abs == 2
  end

  def attempt_jump(start_pos, end_pos)
    if @checkers.this_jump_possible?(start_pos, end_pos)
      @checkers.move_piece(start_pos, end_pos)
      return true
    end
    puts "You can't move there!"
    false
  end

  def look_for_additional_jumps(end_pos)
    @checkers.additional_jump_possible?(end_pos)
  end

  def check_for_kings(current_color)
    row_to_check = current_color == :red ? 7 : 0
    8.times do |i|
      check_this_spot = @checkers.get_square([row_to_check, i])
      king([row_to_check, i], current_color) if check_this_spot.class.to_s == "Man"  && check_this_spot.color == current_color
    end
  end

  def king(square, color)
    @checkers.set_square(square,nil)
    @checkers.set_square(square, King.new(color))
  end
end