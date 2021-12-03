function load_data()
    data = readlines("door9_input")
    parse.(Int, data)
end

function find_first_wrong(list)
    function tuple_with_sum(s, l)
        for x in eachindex(l)
            for y in 1:x-1
                if l[x] + l[y] == s
                    return true
                end
            end
        end
        return false
    end
    n = 26
    while true
        if !(tuple_with_sum(list[n], list[n-25:n-1])) return list[n] end
        n += 1
    end
end

function contigous_set_with_sum(s, list)
    set_length = 2
    while true
        start_index = 1
        while list[start_index+set_length-1] < s
            contigous_set = @view list[start_index:start_index+set_length-1]
            if sum(contigous_set) == s
                return min(contigous_set...) + max(contigous_set...)
            end
            start_index += 1
        end
        set_length += 1
    end
end

data = load_data()

println(find_first_wrong(data))
println(contigous_set_with_sum(400480901, data))