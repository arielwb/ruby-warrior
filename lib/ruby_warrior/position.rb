module RubyWarrior
  class Position
    attr_reader :floor
    DIRECTIONS = [:north, :east, :south, :west]
    RELATIVE_DIRECTIONS = [:forward, :right, :backward, :left]
    
    def initialize(floor, x, y, direction = nil)
      @floor = floor
      @x = x
      @y = y
      @direction_index = DIRECTIONS.index(direction || :north)
    end
    
    def at?(x, y)
      @x == x && @y == y
    end
    
    def direction
      DIRECTIONS[@direction_index]
    end
    
    def rotate(amount)
      @direction_index += amount
      @direction_index -= 4 while @direction_index > 3
      @direction_index += 4 while @direction_index < 0
    end
    
    def relative_space(forward, right = 0)
      @floor.space(*translate_offset(forward, right))
    end
    
    def space
      @floor.space(0, 0)
    end
    
    def move(forward, right = 0)
      @x, @y = *translate_offset(forward, right)
    end
    
    def distance_from_stairs
      stairs_x, stairs_y = *@floor.stairs_location
      (@x - stairs_x).abs + (@y - stairs_y).abs
    end
    
    def relative_direction_of_stairs
      relative_direction(direction_of_stairs)
    end
    
    def direction_of_stairs
      stairs_x, stairs_y = *@floor.stairs_location
      if (@x - stairs_x).abs > (@y - stairs_y).abs
        if stairs_x > @x
          :west
        else
          :east
        end
      elsif stairs_y > @y
        :south
      else
        :north
      end
    end
    
    def relative_direction(direction)
      offset = DIRECTIONS.index(direction) - @direction_index
      offset -= 4 while offset > 3
      offset += 4 while offset < 0
      RELATIVE_DIRECTIONS[offset]
    end
    
    private
    
    def translate_offset(forward, right)
      case direction
      when :north then [@x + right, @y - forward]
      when :east then [@x + forward, @y + right]
      when :south then [@x - right, @y + forward]
      when :west then [@x - forward, @y - right]
      end
    end
  end
end
