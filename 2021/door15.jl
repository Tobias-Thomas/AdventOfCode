using DataStructures

manhattan(p1, p2) = sum(abs.(Tuple(p1 - p2)))

const neighbors = [CartesianIndex(-1,0), CartesianIndex(0,-1), CartesianIndex(1,0), CartesianIndex(0,1)]

function expand_field(f)
    w = size(f,1)
    larger_f = zeros(UInt8, size(f).*5)
    for x in 1:5, y in 1:5
        add_value = x+y-2
        larger_f[w*(y-1)+1:w*y,w*(x-1)+1:w*x] = mod1.(f .+ add_value, 9)
    end
    larger_f
end

function find_best_path(field)
    start = CartesianIndex(1,1)
    goal = CartesianIndex(size(field))
    visited = Set{CartesianIndex{2}}()
    pq = PriorityQueue{CartesianIndex{2}, Int}()
    costs = zeros(Int, size(field))
    enqueue!(pq, start, manhattan(start, goal))
    while true
        lowest_point = dequeue!(pq)
        push!(visited, lowest_point)
        lowest_point == goal && return costs[lowest_point]
        for n in neighbors
            next_point = n + lowest_point
            if checkbounds(Bool, field, next_point) && !(next_point in visited)
                new_cost = costs[lowest_point]+field[next_point]
                new_estimate = new_cost + manhattan(next_point,goal)
                if next_point in keys(pq)
                    next_point_prior_cost = costs[next_point]
                    if new_cost < next_point_prior_cost
                        costs[next_point] = new_cost
                        pq[next_point] = new_estimate
                    end
                else 
                    enqueue!(pq, next_point, new_estimate)
                    costs[next_point] = new_cost
                end
            end
        end
    end
end

function load_field(file_name)
    data = readlines(file_name)
    w = length(data)
    field = zeros(UInt8, w, w)
    for x in 1:w, y in 1:w
        field[y,x] = parse(UInt8, data[y][x])
    end
    field
end

field = load_field("2021/door15_input")
larger_field = expand_field(field)
field[1,1] = 0
larger_field[1,1] = 0
println(find_best_path(field))
@time println(find_best_path(larger_field))