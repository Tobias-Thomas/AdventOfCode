load_data() = readlines("door19_input")

function parse_rules(fn)
    rules = readlines(fn)
    rules = split.(rules, ": ")
    rule_dict = Dict(zip([r[1] for r in rules], ["(?:"*r[2]*")" for r in rules]))
end

function expand_rules(rules)
    final_rule = rules["0"]
    while true
        to_replace = match(r"\d+", final_rule)
        if isnothing(to_replace) break end
        replace_pattern = r"\b"*to_replace.match*r"\b"
        final_rule = replace(final_rule, replace_pattern=>SubstitutionString(rules[to_replace.match]))
    end
    filter(x->!isspace(x), final_rule)
end

is_word(w, r) = !isnothing(match(r, w))

words = load_data()

rules = parse_rules("door19_1_rules")
final_rule = expand_rules(rules)
final_rule = Regex("^"*final_rule*"\$")
println(sum(map(w-> is_word(w, final_rule), words)))

rules = parse_rules("door19_2_rules")
final_rule = expand_rules(rules)
final_rule = replace(final_rule, 'x'=>"-1")
final_rule = replace(final_rule, "(?:a)"=>'a')
final_rule = replace(final_rule, "(?:b)"=>'b')
final_rule = Regex("^"*final_rule*"\$")
println(sum(map(w-> is_word(w, final_rule), words)))