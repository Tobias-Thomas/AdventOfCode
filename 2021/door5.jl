function parse_line(l)
    s,e = split(l, " -> ")
    x1,y1 = parse.(Int, split(s, ","))
    x2,y2 = parse.(Int, split(e, ","))
    x1,y1,x2,y2
end

function add_vent_at_point!(p, vent_dict)
    if p in keys(vent_dict)
        vent_dict[p] += 1
    else
        vent_dict[p] = 1
    end
end

function fill_line!(x1, y1, x2, y2, line_dict, use_diagonals)
    if x1 == x2
        yd = y1 < y2 ? 1 : -1
        for y_middle in y1:yd:y2
            point = (x1,y_middle)
            add_vent_at_point!(point, line_dict)
        end
    elseif y1 == y2
        xd = x1 < x2 ? 1 : -1
        for x_middle in x1:xd:x2
            point = (x_middle,y1)
            add_vent_at_point!(point, line_dict)
        end
    elseif use_diagonals
        xd = x1 < x2 ? 1 : -1
        yd = y1 < y2 ? 1 : -1
        for s in 0:abs(x1-x2)
            point = (x1 + s * xd, y1 + s * yd)
            add_vent_at_point!(point, line_dict)
        end
    end
end

function count_overlap(d)
    num_overlaps = 0
    for number_vents in values(d)
        if number_vents >= 2
            num_overlaps += 1
        end
    end
    num_overlaps
end

function fill_all_lines_and_count_overlap(lines, use_diagonals)
    vent_dict::Dict{Tuple{Int,Int}, Int} = Dict()
    for l in lines
        x1, y1, x2, y2 = l
        fill_line!(x1, y1, x2, y2, vent_dict, use_diagonals)
    end
    count_overlap(vent_dict)
end

data = parse_line.(readlines("door5_input"))

println(fill_all_lines_and_count_overlap(data, false))
println(fill_all_lines_and_count_overlap(data, true))
