data = readlines("door2_input")

function parse_pw_rule(pw_line)
    rule, char, pw = split(pw_line, ' ')
    char = char[1]
    x, y = split(rule, '-')
    x, y = parse(Int, x), parse(Int, y)
    x, y, char, pw
end

is_valid1(low, high, char, pw) = low <= count(collect(pw) .== char) <= high
is_valid2(idx1, idx2, char, pw) = xor(pw[idx1] == char, pw[idx2] == char)

count_correct_pw(pw_list, valid_f) = sum(map(x -> valid_f(x...), map(parse_pw_rule, pw_list)))
