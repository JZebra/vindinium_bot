require "maze_solver"

# Simple bot. Tries to take the nearest mine. 
# Will travel to tavern instead if hp drops below 50
class MinerBot < BaseBot
  include Maze_Solver
  
  #Dirs are W, A, S, D
  DIRS = [[1, 0], [0, -1], [-1, 0], [0, 1]]
  DIRECTIONS = { [0, 0] => "Stay", [1, 0] => "North", 
                [0, -1] => "West", [-1, 0] => "South", [0, 1] => "East" }
  
  def initialize(state)
    @game = Game.new(state)
    @board = @game.board.parse_tiles
    # Finds gizmo!
    @hero = @game.heroes.select { |hero| hero.name == 'Gizmo' }
    @hero_id = @game.heroes_locs[@hero.pos]
  end
  
  def nearest_tavern
    src = @hero.pos
    #set shortest dst to arbitrarily large value
    shortest_dst = 63
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
    src = @hero.pos
    shortest_dst = 63
    unowned_mines = @game.mines_locs.reject { |pos, hero_id| hero_id == @hero_id }
    unowned_mines.each do |pos, hero_id|
      build_branching_paths(src, pos)
      path = find_path
      if path.length < shortest_dst
        shortest_dst = path.length
        nearest = dst
      end
    end
    nearest
  end
    
  def move (state)
    if @hero.hp < 50
      path = find_path(nearest_tavern)
    else 
      path = find_path(nearest_mine)
    end
    dir = [(path[0][0] - @hero.pos[0]), (path[0][1] - @hero.pos[1])]
    DIRECTIONS[dir]
  end
end

    