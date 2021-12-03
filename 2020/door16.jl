function load_data()
    tickets = readlines("door16_input")
    parse_single_ticket(t) = parse.(Int, split(t, ","))
    parse_single_ticket.(tickets)
end

function load_rules()
    rules = readlines("door16_rules")
    
    function parse_single_rule(r)
        field_name, rules = split(r, ":")
        rules = parse.(Int, [m.match for m in eachmatch(r"\d+", rules)])
        (field_name, rules)
    end
    Dict(parse_single_rule.(rules))
end

is_valid(field, intervals) =
    (intervals[1] <= field <= intervals[2]) ||
    (intervals[3] <= field <= intervals[4])

function calc_error_rate(tickets, rules)
    error_rate = 0
    for t in tickets
        for field in t
            if !any([is_valid(field, intervs) for intervs in values(rules)])
                error_rate += field
            end
        end
    end
    error_rate
end

function is_valid_ticket(ticket, rules)
    for field in ticket
        if !any([is_valid(field, intervs) for intervs in values(rules)])
            return false
        end
    end
    return true
end

function poss_indices_for_interv(tickets, interval)
    poss_indices::Array{Int, 1} = []
    for i in eachindex(tickets[1])
        if all([is_valid(t[i], interval) for t in tickets])
            push!(poss_indices, i)
        end
    end
    poss_indices
end

function find_indices_for_names(tickets, rules)
    names = keys(rules)
    poss_indices = [poss_indices_for_interv(tickets, rules[name]) for name in keys(rules)]
    while true
        length_pis = [length(pi) for pi in poss_indices]
        if all(length_pis .== 1)
            break
        end
        for single_index in poss_indices[length_pis.==1]
            single_index = single_index[1]
            for indices in poss_indices
                if !(length(indices) == 1)
                    filter!(x-> x != single_index, indices)
                end
            end
        end
    end
    Dict(zip(names, poss_indices))
end

function my_ticket_departure(own_ticket, tickets, rules)
    name_index_dict = find_indices_for_names(tickets, rules)
    result = 1
    for field in keys(name_index_dict)
        if startswith(field, "departure")
            result *= own_ticket[name_index_dict[field][1]]
        end
    end
    result
end

my_ticket = [61,101,131,127,103,191,67,181,79,71,
             113,97,173,59,73,137,139,53,193,179]
other_tickets = load_data()
rules = load_rules()

println(calc_error_rate(other_tickets, rules))

filter!(t-> is_valid_ticket(t, rules), other_tickets)
my_ticket_departure(my_ticket, other_tickets, rules)