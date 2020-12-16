function load_data()
    data = readlines("door13_input")
    dt = parse(Int, data[1])
    bus_ids = split(data[2], [','])
    dt, bus_ids
end

function closest_bus(dt, ids)
    shortest_time = Inf
    shortest_id = -1
    for cycle_time in ids
        if !(cycle_time == "x")
            cycle_time = parse(Int, cycle_time)
            num_rounds_before = dt ÷ cycle_time
            wait_time = ((num_rounds_before+1) * cycle_time) - dt
            if wait_time < shortest_time
                shortest_time = wait_time
                shortest_id = cycle_time
            end
        end
    end
    shortest_id * shortest_time
end

function find_first_alignment(ids)
    r = 0
    inc = 1

    divisor_remainder_pairs = [
        (parse(Int, ids[i]), mod((parse(Int, ids[i]) - i + 1), parse(Int, ids[i])))
        for i in eachindex(ids) if ids[i] != "x"
    ]

    for p in divisor_remainder_pairs
        while r % p[1] != p[2]
            r += inc
        end
        inc *= p[1]
    end
    r
end

depart_time, bus_ids = load_data()
println(closest_bus(depart_time, bus_ids))
println(find_first_alignment(bus_ids))