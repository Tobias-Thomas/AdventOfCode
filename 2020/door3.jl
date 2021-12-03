function load_data()
    area = readlines("door3_input")
    area = collect.(area)
    hcat(area...)
end

area = load_data()

function count_trees(slope)
    w, h = size(area)
    crossed_trees = 0
    current_pos = [1,1]
    while current_pos[2] <= h - slope[2]
        current_pos += slope
        if current_pos[1] > w
            current_pos[1] -= w
        end
        if area[current_pos...] == '#'
            crossed_trees += 1
        end
    end
    crossed_trees
end

println(count_trees([3,1]))

slopes = [[1,1], [3,1], [5,1], [7,1], [1,2]]
println(prod(count_trees(s) for s in slopes))