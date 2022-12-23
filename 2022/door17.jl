wind = readline("door17_input")

const ROCKS = (
    (30,),
    (8,28,8),
    (28,4,4),
    (16,16,16,16),
    (24,24)
)
const BITSHIFTS = (1 << i for i in 0:6)

function is_placeable(chamber, rock, rock_pos)
    for (i,line) in enumerate(rock)
        chamber[i+rock_pos-1] & line != 0 && return false
    end
    return true
end

function apply_wind(chamber, rock, rock_pos, wind)
    if wind == '>'
        any(x -> (x & 1) != 0, rock) && return rock, false
        rock_after_wind = Tuple(x >> 1 for x in rock)
    else
        any(x -> (x & 64) != 0, rock) && return rock, false
        rock_after_wind = Tuple(x << 1 for x in rock)
    end
    return is_placeable(chamber, rock_after_wind, rock_pos) ? (rock_after_wind, true) : (rock, false)
end

function apply_falldown(chamber, rock, rock_pos)
    return is_placeable(chamber, rock, rock_pos-1) ? (rock_pos - 1, true) : (rock_pos, false)
end

function place_rock!(chamber, rock, rock_pos)
    for (i,line) in enumerate(rock)
        chamber[i+rock_pos-1] |= line
    end
    rock_placed_height = length(rock)+rock_pos-1
    for _ in length(chamber):rock_placed_height + 7
        push!(chamber, 0)
    end
    return rock_placed_height
end

function rock_fall!(chamber, rock, chamber_height, wind, ts)
    rock_pos = chamber_height + 4
    while true
        rock, _ = apply_wind(chamber, rock, rock_pos, wind[ts])
        ts = mod1(ts+1, length(wind))
        rock_pos, fall_success = apply_falldown(chamber, rock, rock_pos)
        !fall_success && break
    end
    chamber_height = max(place_rock!(chamber, rock, rock_pos), chamber_height)
    return chamber_height, ts
end

function column_heights(chamber, chamber_height)
    col_heights = zeros(Int, 7)
    for (i,b) in enumerate(BITSHIFTS)
        for (h,line) in enumerate(chamber[chamber_height:-1:1])
            if (line & b) != 0
                col_heights[i] = h-1
                break
            end
        end
    end
    return col_heights
end

function place_n_rocks(n)
    state_map = Dict{NTuple{9, Int},Tuple{Int,Int}}()
    chamber = zeros(UInt8, 8)
    chamber[1] = 127
    chamber_height = 1
    ts = 1
    last_step = -1
    add_on = 0
    found_circle = false
    for i in 1:n
        chamber_height, ts = rock_fall!(chamber, ROCKS[mod1(i,5)], chamber_height, wind, ts)
        if !found_circle
            col_heights = column_heights(chamber, chamber_height)
            state = (col_heights..., ts, mod1(i,5))
            if haskey(state_map, state)
                found_circle = true
                first_i, first_height = state_map[state]
                circle_length = i - first_i
                circle_increase = chamber_height - first_height
                circles_left = (n - i) ÷ circle_length
                add_on = circles_left * circle_increase
                last_step = i + ((n - i) % circle_length)
            else
                state_map[state] = (i,chamber_height)
            end
        end
        i == last_step && break
    end
    return chamber_height + add_on
end

function print_chamber(c)
    print_one_chamber_line.(reverse(c))
end

function print_one_chamber_line(l)
    s = ""
    for i in 6:-1:0
        s *= (l & (1 << i)) != 0 ? '#' : '.'
    end
    println(s)
end

chamber_height = place_n_rocks(2022)
println(chamber_height)
chamber_height = place_n_rocks(1_000_000_000_000)
println(chamber_height)
