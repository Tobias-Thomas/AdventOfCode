function load_data()
    lines = readlines("door8_input")
    hcat([parse.(Int, l) for l in collect.(lines)]...)
end

function count_visible_trees(f)
    height, width = size(forest)
    visible = zeros(Bool, height, width)
    # from left
    for y in 1:height
        current_height = -1
        for x in 1:width
            if f[y,x] > current_height
                current_height = f[y,x]
                visible[y,x] = true
            end
        end
    end
    # from right
    for y in 1:height
        current_height = -1
        for x in width:-1:1
            if f[y,x] > current_height
                current_height = f[y,x]
                visible[y,x] = true
            end
        end
    end
    # from top
    for x in 1:width
        current_height = -1
        for y in 1:height
            if f[y,x] > current_height
                current_height = f[y,x]
                visible[y,x] = true
            end
        end
    end
    # from bottom
    for x in 1:width
        current_height = -1
        for y in height:-1:1
            if f[y,x] > current_height
                current_height = f[y,x]
                visible[y,x] = true
            end
        end
    end
    sum(visible)
end

function calculate_scenic_score(f)
    height, width = size(forest)
    best_scenic_score = -1
    for x in 2:width-1
        for y in 2:height-1
            # to left
            scenic_left = 0
            for sx in x-1:-1:1
                scenic_left += 1
                if f[y,sx] >= f[y,x]
                    break
                end
            end
            # to right
            scenic_right = 0
            for sx in x+1:width
                scenic_right += 1
                if f[y,sx] >= f[y,x]
                    break
                end
            end
            # to top
            scenic_top = 0
            for sy in y-1:-1:1
                scenic_top += 1
                if f[sy,x] >= f[y,x]
                    break
                end
            end
            # to bottom
            scenic_bottom = 0
            for sy in y+1:height
                scenic_bottom += 1
                if f[sy,x] >= f[y,x]
                    break
                end
            end
            scenic_score = scenic_left * scenic_right * scenic_top * scenic_bottom
            if scenic_score > best_scenic_score
                best_scenic_score = scenic_score
            end
        end
    end
    best_scenic_score
end

forest = load_data()
println(count_visible_trees(forest))
println(calculate_scenic_score(forest))
