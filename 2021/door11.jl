parse_line(l) = [parse(Int, c) for c in l]

function neighbor_idx(i, array_size)
    neighbors = []
    for x in -1:1, y in -1:1
        x == 0 && y == 0 && continue
        new_idx = i + CartesianIndex(x,y)
        if 0 < new_idx[1] <= array_size[1] && 0 < new_idx[2] <= array_size[2]
            push!(neighbors, new_idx)
        end
    end
    neighbors
end

function recursive_flash!(f, idx)
    num_flashes = 0
    f[idx] += 1
    if f[idx] == 10
        num_flashes += 1
        for n in neighbor_idx(idx, size(f))
            num_flashes += recursive_flash!(f, n)
        end
    end
    num_flashes
end

function simulate_flashes_in_one_step!(f)
    num_flashes = 0
    for idx in CartesianIndices(f)
        num_flashes += recursive_flash!(f, idx)
    end
    for idx in eachindex(f)
        if f[idx] >= 10
            f[idx] = 0
        end
    end
    num_flashes
end

function simulate_n_steps!(f, n_steps)
    num_flashes = 0
    for _ in 1:n_steps
        num_flashes += simulate_flashes_in_one_step!(f)
    end
    num_flashes
end

function find_first_time_all_flash!(f)
    i = 0
    while true
        i += 1
        flashes = simulate_flashes_in_one_step!(f)
        if flashes == 100
            return i
        end
    end
end

field = hcat(parse_line.(readlines("door11_input"))...)
println(simulate_n_steps!(copy(field), 100))
println(find_first_time_all_flash!(copy(field)))