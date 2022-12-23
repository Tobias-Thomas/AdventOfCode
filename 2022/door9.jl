function load_data()
    lines = readlines("door9_input")
    [(m[1], parse(Int, m[2])) for m in split.(lines, " ")]
end

direction2coordinates = Dict(
    "L" => [-1,0],
    "R" => [1,0],
    "D" => [0,1],
    "U" => [0,-1]
)

function count_tail_visited(motions)
    h = [0,0]
    t = [0,0]
    visited = Set([Tuple(t)])
    for m in motions
        d, amount = m
        direction = direction2coordinates[d]
        for _ in 1:amount
            h += direction
            if maximum(abs.(h-t)) > 1
                t += sign.(h-t)
                push!(visited, Tuple(t))
            end
        end
    end
    length(visited)
end

function move_behind!(h, t)
    if maximum(abs.(h-t)) > 1
        t .+= sign.(h-t)
        return true
    end
    return false
end

function count_larger_tail_visited(motions)
    h = [0,0]
    t = [[0,0] for _ in 1:9]
    visited = Set([Tuple(t[9])])
    for m in motions
        d, amount = m
        direction = direction2coordinates[d]
        for _ in 1:amount
            h += direction
            moved = move_behind!(h, t[1])
            i = 1
            while moved && i <= 8
                moved = move_behind!(t[i], t[i+1])
                i += 1
            end
            if moved
                push!(visited, Tuple(t[9]))
            end
        end
    end
    length(visited)
end

motions = load_data()
println(count_tail_visited(motions))
println(count_larger_tail_visited(motions))
