load_data() = parse.(Int, readlines("door10_input"))

function use_all_adapters(loa)
    jolt_diffs = diff(loa)
    count(==(1), jolt_diffs) * count(==(3), jolt_diffs)
end

is_valid(loa) = all(x -> 1<=x<=3, diff(loa))

function find_groups(loa)
    groups::Array{Array{Int, 1}, 1} = []
    curr_group::Array{Int, 1} = []
    for i in eachindex(loa)
        push!(curr_group, loa[i])
        if i == length(loa) || (loa[i+1] - loa[i] == 3) 
            push!(groups, curr_group)
            curr_group = []
        end
    end
    groups
end

function count_possibilities_group(group, si=2)
    if length(group) <= 2
        return 1
    end
    possibilities = 1
    for i in si:length(group)-1
        sub_group = vcat(group[1:i-1], group[i+1:end])
        if is_valid(sub_group)
            possibilities += count_possibilities_group(sub_group, i)
        end
    end
    possibilities
end

function count_possibilities(loa)
    groups = find_groups(loa)
    possibilities = 1
    for g in groups
        possibilities *= count_possibilities_group(g)
    end
    possibilities
end

adapters = load_data()
sort!(push!(adapters, 0, max(adapters...) + 3))
println(use_all_adapters(adapters))
println(count_possibilities(adapters))