class Chipmunk < Creature
  def initialize
    
  end
  
  def update
    @age += 1

    if @seeds > 0
      @activity = :plant
    end

    if @age % 17 == 0
      @activity = :get
    end

    if @age % 2 == 0
      if @path.empty?
        case @activity
        when :get
          notify(:no_path_s, self)
        when :plant
          @plant_cell = @area.random_open
          @path = @area.path(@cell, @plant_cell)
        end

        if @path.empty?
          @activity = :none
        end
      else
        @target = path.slice! 0
      end

      if @target
        move(@target)
        if path == []

          case @activity
          when :get
            pick_up
            @seeds = [@seeds-1, 0].max if rand(3) == 0
          when :plant
            plant
          when :none
            random_move
          end

          @activity = :none
        end
      end
      
    end
    
  end
  
end
