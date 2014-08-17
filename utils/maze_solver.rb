# adapted from app academy maze solver problem

module Maze_Solver

  #Find distance between two points
  def find_distance(src, dst)
    s_row, s_col = pos
    e_row, e_col = pos
    ((s_row - e_row) + (s_col - e_col)).abs
  end
  
  def find_path(dst)
    [dst].tap do |path|
      spot = dst
      until @branching_paths[spot] == nil
        path << @branching_paths[spot]
        spot = @branching_paths[spot]
      end
    end
  end

  def find_manhattan_estimate(point)
    dist_to_end = find_distance(point)
    dist_traveled = find_path(point).length
    f = dist_to_end + dist_traveled
  end

  # estimates dist. traveled and dist. to end,
  # picks point that should have minimum sum.
  # does not take diagonal moves into consideration.
  def manhattan_heuristic(queue)
    queue.inject do |chosen_point, point|
      old_f = find_manhattan_estimate(chosen_point)
      new_f = find_manhattan_estimate(point)
      old_f > new_f ? point : chosen_point
    end
  end

  # simple breadth first search; not really a heuristic.
  # included for comparison.
  def b_f_s(queue)
    queue.shift
  end
  
  # finds all adjacent tiles that are passable
  def find_open_paths(pos)
    row, col = pos
    [].tap do |adjs|
      DIRS.each do |d_y, d_x|
        adj = [(row + d_y), (col + d_x)]
        adjs << adj if @board.passable?(adj)
      end
    end
  end
    

  def build_branching_paths(src, dst, heuristic = :manhattan_heuristic)
    reset_values
    queue = [@current]
    visited = [@current]

    until queue.empty? || @current == dst
      @current = self.send(heuristic, queue)
      queue.delete(@current)
      visited << @current
      #find passable spaces near current pos
      nearby_openings = find_open_paths(@current)
      #add them to queue
      nearby_openings.each do |adj|
        unless visited.include?(neighbor) || queue.include?(neighbor)
          queue << neighbor
          @branching_paths[neighbor] = @current
        end
      end
    end
    @branching_paths
  end

  # def solve(heuristic = :manhattan_heuristic)
#     build_branching_paths(heuristic)
#     path = find_path
#     @maze.travel_path(path)
#end
  
  private
  
  def reset_values
    @branching_paths = {}
    @current = @gizmo.pos
  end
end 