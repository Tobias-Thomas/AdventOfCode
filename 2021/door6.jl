init_state = parse.(Int, split(readlines("door6_input")[1], ","))
init_state = Dict([(i, count(==(i), init_state)) for i in 0:8])

function simulate(init_state, num_days)
    state = init_state
    for _ in 1:num_days
        next_state::Dict{Int, Int} = Dict()
        for i in 0:7
            next_state[i] = state[i+1]
        end
        next_state[8] = state[0]
        next_state[6] += state[0]
        state = next_state
    end
    state
end

final_state1 = simulate(init_state, 80)
println(sum(values(final_state1)))

final_state2 = simulate(init_state, 256)
println(sum(values(final_state2)))