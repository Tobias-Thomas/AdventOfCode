using DataStructures
using Statistics

const illegal_points = Dict(')'=>3, ']'=>57, '}'=>1197, '>'=>25137)
const closing_points = Dict(')'=>1, ']'=>2, '}'=>3, '>'=>4)
const matching_pairs = Dict('('=>')', '['=>']', '{'=>'}', '<'=>'>')
is_closing_bracket(c) = c in keys(illegal_points)

function corrupted_score(l)
    s = Stack{Char}()
    for c in l
        if is_closing_bracket(c)
            match = pop!(s)
            matching_pairs[match] != c && return illegal_points[c]
        else
            push!(s, c)
        end
    end
    0
end

function finish_score(l)
    s = Stack{Char}()
    for c in l
        if is_closing_bracket(c)
            match = pop!(s)
            matching_pairs[match] != c && return -1
        else
            push!(s, c)
        end
    end
    score = 0
    for remaining in s
        score *= 5
        score += closing_points[matching_pairs[remaining]]
    end
    score
end

lines = readlines("door10_input")
println(sum(corrupted_score.(lines)))
println(median(filter(!=(-1), finish_score.(lines))))
