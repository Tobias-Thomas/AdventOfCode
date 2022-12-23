@enum Choice rock=1 paper=2 scissor=3

struct Match
    p1::Choice
    p2::Choice
end

char2choice = Dict(
    'A'=> Choice(1),
    'B'=> Choice(2),
    'C'=> Choice(3),
    'X'=> Choice(1),
    'Y'=> Choice(2),
    'Z'=> Choice(3)
)

function points1(m::Match)
    if m.p1 == m.p2
        return Int(m.p2) + 3
    elseif Int(m.p1) == mod1(Int(m.p2) - 1, 3)
        return Int(m.p2) + 6
    else
        return Int(m.p2)
    end
end

function points2(m::Match)
    if Int(m.p2) == 1
        return mod1(Int(m.p1) - 1, 3)
    elseif Int(m.p2) == 2
        return Int(m.p1) + 3
    else
        return mod1(Int(m.p1) + 1, 3) + 6
    end
end

function load_data()
    matches = Vector{Match}()
    for r in readlines("door2_input")
        c1, c2 = char2choice[r[1]], char2choice[r[3]]
        push!(matches, Match(c1, c2))
    end
    matches
end

matches = load_data()
println(sum(points1.(matches)))
println(sum(points2.(matches)))
