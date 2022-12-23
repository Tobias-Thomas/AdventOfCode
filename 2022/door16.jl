using AStarSearch

function load_data()
    lines = readlines("/home/tobias/Documents/devel/Julia/AoC/2022/door16_input")
    r = r"Valve (..) has flow rate=(\d+); tunnel(?:s?) lead(?:s?) to valve(?:s?) (.*)"
    parse_line.(lines, r)
end

function parse_line(l, rx)
    name, flowrate, connections = match(rx, l).captures
    name, parse(Int, flowrate), split(connections, ", ")
end

function build_adjacency_matrix(valve_infos)
    adj_matrix = Dict{Tuple{String, String},Int}()
    maze = Dict([v[1], v[3]] for v in valve_infos)
    good_valves = [v[1] for v in valve_infos if v[2] > 0 || v[1] == "AA"]
    for i in eachindex(good_valves)
        si = good_valves[i]
        for j in (i+1):length(good_valves)
            sj = good_valves[j]
            adj_matrix[(si,sj)] = adj_matrix[(sj,si)] = solvemaze(maze, si, sj, mazeneighbours).cost
        end
    end
    adj_matrix
end

heuristic(a, b) = 0

function mazeneighbours(maze, p)
    maze[p]
end

function solvemaze(maze, start, goal, neighbours)
    currentmazeneighbours(state) = neighbours(maze, state)
    return astar(currentmazeneighbours, start, goal, heuristic=heuristic)
end

function visit(v, budget, state, flow, answer)
    answer[state] = max(haskey(answer, state) ? answer[state] : 0, flow)
    for u in keys(flow_rate_map)
        u == v && continue
        newbudget = budget - adj_matrix[(v,u)] - 1
        (((good_bitmap[u] & state) != 0) || newbudget <= 0) && continue
        visit(u, newbudget, state | good_bitmap[u], flow + newbudget * flow_rate_map[u], answer)
    end
    return answer  
end

function result2(answer_dict)
    max_flow2 = 0
    for (k1,v1) in answer_dict
        for (k2,v2) in answer_dict
            (k1 & k2 != 0) && continue
            max_flow2 = max(max_flow2, v1+v2)
        end
    end
    max_flow2
end

valves = load_data()
adj_matrix = build_adjacency_matrix(valves)
flow_rate_map = Dict{String,Int}()
for v in valves
    if v[2] > 0
        flow_rate_map[v[1]] = v[2]
    end
end
good_valves = [v for v in keys(flow_rate_map) if v != "AA"]
good_bitmap = Dict([v=> 1<<(i-1) for (i,v) in enumerate(good_valves)])
println(maximum(values(visit("AA", 30, 0, 0, Dict{Int,Int}()))))
println(result2(visit("AA", 26, 0, 0, Dict{Int,Int}())))