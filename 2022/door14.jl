function load_data()
    rocks = readlines("door14_test")
    cave = zeros(Int8, 1000, 200)
    max_depth = 1
    for r in rocks
        points = [parse.(Int, split(l, ",")) for l in split(r, " -> ")]
        for (s,e) in zip(points[1:end-1], points[2:end])
            dx = e[1] >= s[1] ? 1 : -1
            dy = e[2] >= s[2] ? 1 : -1
            max_depth = max(max_depth, s[2], e[2])
            cave[s[1]:dx:e[1], s[2]:dy:e[2]] .= 1
        end
    end
    cave, max_depth
end

function print_cave(c)
    println.(eachcol(c))
end

function add_one_sand!(c)
    s_pos = [500,0]
    while true
        if c[s_pos[1], s_pos[2]+1] == 0
            s_pos[2] += 1
        elseif c[s_pos[1]-1, s_pos[2]+1] == 0
            s_pos[1] -= 1
            s_pos[2] += 1
        elseif c[s_pos[1]+1, s_pos[2]+1] == 0
            s_pos[1] += 1
            s_pos[2] += 1
        else
            if s_pos[2] == 0
                return false
            end
            c[s_pos...] =  2
            return true
        end
        if s_pos[2] >= 200
            return false
        end
    end
end

function add_sand_until_conv!(c)
    sand_amount = 0
    while add_one_sand!(c)
        #print_cave(c[490:510, 1:20])
        sand_amount += 1
    end
    sand_amount
end

cave, max_depth = load_data()
#println(add_sand_until_conv!(cave))
cave[:, max_depth+2] .= 1
println(add_sand_until_conv!(cave))
