load_data() = hcat(parse_line.(readlines("door17_input"))...)
char_to_int(c) = Dict('.'=>0, '#'=>1)[c]
parse_line(l) = char_to_int.(collect(l))

function simulate(init_grid, n_steps, num_dimensions)
    s = size(init_grid)
    space = zeros(Int, n_steps*2+s[1], n_steps*2+s[2], repeat([n_steps*2+1], num_dimensions-2)...)
    space[n_steps:end-n_steps-1, n_steps:end-n_steps-1, repeat([n_steps+1], num_dimensions-2)...] = init_grid
    indices = CartesianIndices(space)
    i_first, i_last = first(indices), last(indices)
    s_neighbors = oneunit(i_first)
    for _ in 1:n_steps
        next_space = zeros(Int, size(space))
        for i in indices
            neighborhood = space[max(i_first, i-s_neighbors): min(i_last, i+s_neighbors)]
            if (space[i] == 1 && 3 <= sum(neighborhood) <= 4) || (space[i] == 0 && sum(neighborhood) == 3)
                next_space[i] = 1
            end
        end
        space = next_space
    end
    sum(space)
end

start_region = load_data()'
println(simulate(start_region, 6, 3))
println(simulate(start_region, 6, 4))