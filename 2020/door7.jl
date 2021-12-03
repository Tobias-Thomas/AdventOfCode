function load_data()
    bag_rules = readlines("door7_input")
    function extract_info(rule)
        outer_bag, bag_rule = split(rule, " contain ")
        bag_color = join(split(outer_bag, " ")[1:2], " ")
        split_rules = split(bag_rule, ", ")
        bag_rules = []
        for r in split_rules
            if r == "no other bags."
                break
            end
            words = split(r, " ")
            rule_n = parse(Int, words[1])
            rule_c = join(words[2:3], " ")
            push!(bag_rules, (rule_n, rule_c))
        end
        bag_color, bag_rules
    end
    bag_rules = extract_info.(bag_rules)
    bag_dict = Dict(zip([x[1] for x in bag_rules], [x[2] for x in bag_rules]))
end

function can_carry_shiny_gold(c, rules)
    c_rules = rules[c]
    allowed_colors = [x[2] for x in c_rules]
    "shiny gold" in allowed_colors || any(map(x-> can_carry_shiny_gold(x, rules), allowed_colors))
end

function count_bags_inside(c, rules)
    c_rules = rules[c]
    inside_sum = 0
    for r in c_rules
        inside_num, inside_col = r
        inside_sum += inside_num + inside_num * count_bags_inside(inside_col, rules)
    end
    inside_sum
end

bag_rules = load_data()
println(sum(map(x-> can_carry_shiny_gold(x, bag_rules), collect(keys(bag_rules)))))
println(count_bags_inside("shiny gold", bag_rules))