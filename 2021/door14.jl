parse_rule(l) = split(l, " -> ")

function build_polymer_dict(p)
    p_dict = Dict{Tuple{Char,Char},Int}()
    for (c1,c2) in zip(p[1:end-1], p[2:end])
        if (c1,c2) in keys(p_dict)
            p_dict[(c1,c2)] += 1
        else
            p_dict[(c1,c2)] = 1
        end
    end
    p_dict
end

function count_char(p)
    char_freqs = Dict{Char,Int}()
    for ((c1,c2),v) in p
        if c1 in keys(char_freqs)
            char_freqs[c1] += v
        else
            char_freqs[c1] = v
        end
        if c2 in keys(char_freqs)
            char_freqs[c2] += v
        else
            char_freqs[c2] = v
        end
    end
    for k in keys(char_freqs)
        char_freqs[k] = (char_freqs[k] + 1) ÷ 2
    end
    char_freqs
end

function add_pair_to_poly!(poly, pair, value)
    if pair in keys(poly)
        poly[pair] += value
    else
        poly[pair] = value
    end
end

function apply_one_step(polymer, rules)
    next_polymer = Dict{Tuple{Char,Char},Int}()
    for ((c1,c2),v) in polymer
        if c1*c2 in keys(rules)
            insert_char = rules[c1*c2]
            add_pair_to_poly!(next_polymer, (c1,insert_char), v)
            add_pair_to_poly!(next_polymer, (insert_char,c2), v)
        else
            add_pair_to_poly!(next_polymer, (c1,c2), v)
        end
    end
    next_polymer
end

function apply_n_steps(start_p, rules, n)
    p = start_p
    for _ in 1:n
        p = apply_one_step(p, rules)
    end
    p
end

data = readlines("door14_input")
start_polymer = data[1]
start_polymer = build_polymer_dict(start_polymer)
rules = parse_rule.(data[3:end])
rules = Dict(k=>only(v) for (k,v) in rules)
after10_poly = apply_n_steps(start_polymer, rules, 10)
char_freqs = count_char(after10_poly)
println(maximum(values(char_freqs))-minimum(values(char_freqs)))
after40_poly = apply_n_steps(start_polymer, rules, 40)
char_freqs = count_char(after40_poly)
println(maximum(values(char_freqs))-minimum(values(char_freqs)))