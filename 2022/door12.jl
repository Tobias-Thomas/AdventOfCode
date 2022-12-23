using AStarSearch

function load_data()
    lines = readlines("door12_input")
    m = hcat(collect.(lines)...)
    S_idx = findfirst(==('S'), m)
    m[S_idx] = 'a'
    E_idx = findfirst(==('E'), m)
    m[E_idx] = 'z'
    Int.(m) .- 97, S_idx, E_idx
end

maze, s_idx, e_idx = load_data()
goal2 = CartesianIndex(-1,-1)

const UP = CartesianIndex(-1, 0)
const DOWN = CartesianIndex(1, 0)
const LEFT = CartesianIndex(0, -1)
const RIGHT = CartesianIndex(0, 1)
const DIRECTIONS = [UP, DOWN, LEFT, RIGHT]

heuristic(a::CartesianIndex, b::CartesianIndex) = max(sum(abs.((b - a).I)), abs(maze[a] - maze[b]))
heuristic2(a::CartesianIndex, b::CartesianIndex) = 0

# check to be in the maze and filter out moves that go into walls
function mazeneighbours(maze, p)
  res = CartesianIndex[]
  for d in DIRECTIONS
      n = p + d
      if 1 ≤ n[1] ≤ size(maze)[1] && 1 ≤ n[2] ≤ size(maze)[2] && maze[n] <= maze[p]+1
          push!(res, n)
      end
  end
  return res
end

function mazeneighbours2(maze, p)
  res = CartesianIndex[]
  for d in DIRECTIONS
      n = p + d
      if 1 ≤ n[1] ≤ size(maze)[1] && 1 ≤ n[2] ≤ size(maze)[2] && maze[p] <= maze[n]+1
          push!(res, n)
          if maze[p] == 0
            push!(res, goal2)
          end
      end
  end
  return res
end

function solvemaze(maze, start, goal, heuristic, neighbours)
  currentmazeneighbours(state) = neighbours(maze, state)
  # Here you can use any of the exported search functions, they all share the same interface, but they won't use the heuristic and the cost
  return astar(currentmazeneighbours, start, goal, heuristic=heuristic)
end

println(solvemaze(maze, s_idx, e_idx, heuristic, mazeneighbours).cost)
println(solvemaze(maze, e_idx, goal2, heuristic2, mazeneighbours2).cost)