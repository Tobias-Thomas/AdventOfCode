function load_data()
    lines = readlines("door15_input")
    r = r"Sensor at x=(.*?), y=(.*?): closest beacon is at x=(.*?), y=(.*)"
    parse_one_line.(lines, r)
end

function parse_one_line(l, rx)
    infos = parse.(Int, match(rx, l).captures)
    (infos[1], infos[2]), (infos[3], infos[4])
end

manhattan(a, b) = sum(abs.(a .- b))

function calc_blocked_range(sensor, beacon, level)
    radius = manhattan(sensor, beacon)
    level_dist = abs(sensor[2] - level)
    if level_dist > radius
        return nothing
    else
        level_radius = radius - level_dist
        return sensor[1]-level_radius:sensor[1]+level_radius
    end
end

function my_union(range_arr)
    u = UnitRange[]
    for r1 in range_arr
        tmp = UnitRange[]
        for r2 in u
            if length(intersect(r1, r2)) > 0 || last(r1)+1 == first(r2) || last(r2)+1 == first(r1)
                r1 = min(first(r1), first(r2)):max(last(r1), last(r2))
            else
                push!(tmp, r2)
            end
        end
        push!(tmp, r1)
        u = tmp
    end
    u
end

data = load_data()
#ranges = filter!(!isnothing, [calc_blocked_range(s, b, 2_000_000) for (s,b) in data])
#println(sum(length.(my_union(ranges))))
for l in 0:4_000_000
    lranges = filter!(!isnothing, [calc_blocked_range(s, b, l) for (s,b) in data])
    u = my_union(lranges)
    if length(u) > 1
        @show l, u
    end
end