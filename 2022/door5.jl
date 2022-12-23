function load_data()
    lines = readlines("door5_input")
    ll = length(lines[1])
    stacks = ["" for _ in 1:(ll+1)÷4]
    i = 0
    for l in lines
        i += 1
        l[2] == '1' && break
        chars = l[2:4:ll]
        for i in eachindex(stacks)
            stacks[i] *= chars[i]
        end
    end
    stacks = reverse.(strip.(stacks))
    i += 2
    re = r"^move ([0-9]+) from ([0-9]+) to ([0-9]+)$"
    moves = Vector{Vector{Int}}()
    for l in lines[i:end]
        numbers = match(re, l).captures
        push!(moves, parse.(Int, numbers))
    end
    stacks, moves
end

function execute_move!(stacks, m, order)
    num, from, to = m
    stacks[to] *= order(stacks[from][end-num+1:end])
    stacks[from] = stacks[from][1:end-num]
end

stacks, moves = load_data()
s1, s2 = deepcopy(stacks), deepcopy(stacks)

for m in moves
    execute_move!(s1, m, reverse)
end
println(String(last.(s1)))

for m in moves
    execute_move!(s2, m, identity)
end
println(String(last.(s2)))
