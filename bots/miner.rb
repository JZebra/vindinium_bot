require_relative "maze_solver"

# Simple bot. Tries to take the nearest mine. 
# Will travel to tavern instead if hp drops below 60
class MinerBot
  include Maze_Solver
  
  DIRECTIONS = { [0, 0] => "Stay", [1, 0] => "South", 
                [0, -1] => "West", [-1, 0] => "North", [0, 1] => "East" }
  
  def init(state)
    @game = Game.new(state)
    @board = @game.board
    # Finds gizmo!
    @hero = @game.heroes.select { |hero| hero.name == 'Gizmo' }.first
    @pos = [@hero.pos['y'], @hero.pos['x']]
    @hero_id = @game.heroes_locs[@pos]
  end
  
  def nearest_tavern
    src = @pos
    #set shortest dst to arbitrarily large value
    shortest_dst = 63
    nearest = [0,0]
    @game.taverns_locs.each do |pos, hero_id|
      build_branching_paths(src, pos)
      path = find_path
      if path.length < shortest_dst
        shortest_dst = path.length
        nearest = pos
      end
    end
    nearest
  end
  
  # finds the nearest mine that does not belong to our hero
  def nearest_mine
    src = @pos
    shortest_dst = 63
    nearest = [0,0]
    unowned_mines = @game.mines_locs.reject { |pos, hero_id| hero_id == @hero_id }
    unowned_mines.each do |pos, hero_id|
      build_branching_paths(src, pos)
      path = find_path(pos)
      if path.length < shortest_dst
        shortest_dst = path.length
        nearest = pos
      end
    end
    nearest
  end
    
  def move(state)
    init(state)
    if @hero.life < 60 && @hero.gold > 2
      dst = find_path(nearest_tavern)
      puts "getting beer at #{dst}"
    else 
      dst = find_path(nearest_mine)
      puts "getting money at #{dst}"
    end
    step = find_next_step(@pos, dst)
    dir = [(step[1] - @pos[1]), (step[0] - @pos[0])]
    p step
    p dir
    p DIRECTIONS[dir]
    p @pos
    DIRECTIONS[dir]
  end
end

    