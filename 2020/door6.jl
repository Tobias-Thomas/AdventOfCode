function load_data()
    data = readlines("door6_input")
    empty_indices = findall(x -> x=="", data)
    condensed_data = [strip(join(data[1:empty_indices[1]], " "))]
    from_index = empty_indices[1]
    for to_index in empty_indices[2:end]
        push!(condensed_data, strip(join(data[from_index:to_index], " ")))
        from_index = to_index
    end
    push!(condensed_data, strip(join(data[empty_indices[end]:end], " ")))
end

function num_unique_answers(group_answers)
    all_answers = join(split(group_answers, " "))
    length(unique(collect(all_answers)))
end

function num_common_answers(group_answers)
    single_answers = collect.(split(group_answers, " "))
    length(intersect(single_answers...))
end

answers = load_data()

println(sum(num_unique_answers.(answers)))
println(sum(num_common_answers.(answers)))