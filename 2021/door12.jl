function parse_line!(l, m)
    a, b = split(l, "-")
    if a in keys(m)
        push!(m[a], b)
    else
        m[a] = Set{String}([b])
    end
    if b in keys(m)
        push!(m[b], a)
    else
        m[b] = Set{String}([a])
    end
end

function create_all_paths(m, path, visited_small_twice)
    path[end] == "end" && return [path]
    collected_paths = Vector{Vector{String}}()
    for next_point in m[path[end]]
        next_point == "start" && continue
        if islowercase(next_point[1])
            if next_point in path
                !visited_small_twice && push!(collected_paths, create_all_paths(m, push!(copy(path), next_point), true)...)
            else
                push!(collected_paths, create_all_paths(m, push!(copy(path), next_point), visited_small_twice)...)
            end
        else
            push!(collected_paths, create_all_paths(m, push!(copy(path), next_point), visited_small_twice)...)
        end
    end
    collected_paths
end

cave_map = Dict{String, Set{String}}()
for l in readlines("door12_input")
    parse_line!(l, cave_map)
end
paths = create_all_paths(cave_map, ["start"], true)
println(length(paths))
paths2 = create_all_paths(cave_map, ["start"], false)
println(length(paths2))
    