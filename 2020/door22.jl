function load_data()
    deck_lines = readlines("door22_input")
    p1_deck = Vector{Int}()
    p2_deck = Vector{Int}()
    d = p1_deck
    for c in deck_lines
        if c == ""
            d = p2_deck
        else
            push!(d, parse(Int, c))
        end
    end
    p1_deck, p2_deck
end

function calc_score(deck)
    score = 0
    deck_size = length(deck)
    for (p,c) in enumerate(deck)
        score += (deck_size - p + 1) * c
    end
    score
end

function play_game!(p1_deck, p2_deck)
    while (length(p1_deck) > 0) && (length(p2_deck) > 0)
        cp1, cp2 = popfirst!(p1_deck), popfirst!(p2_deck)
        if cp1 > cp2
            push!(p1_deck, cp1)
            push!(p1_deck, cp2)
        else
            push!(p2_deck, cp2)
            push!(p2_deck, cp1)
        end
    end
    calc_score(p1_deck) + calc_score(p2_deck)
end

hash_state(p1_deck, p2_deck) =  hash(join(p1_deck, ",") * join(p2_deck, ","))

function play_recursive_game!(p1_deck, p2_deck, states=Set{UInt64}())
    while (length(p1_deck) > 0) && (length(p2_deck)) > 0
        state_hash = hash_state(p1_deck, p2_deck)
        if state_hash in states
            return true, calc_score(p1_deck)
        else
            push!(states, state_hash)
        end
        cp1, cp2 = popfirst!(p1_deck), popfirst!(p2_deck)
        p1_won = nothing
        if (length(p1_deck) >= cp1) && (length(p2_deck) >= cp2)
            p1_sub_deck = deepcopy(p1_deck)[1:cp1]
            p2_sub_deck = deepcopy(p2_deck)[1:cp2]
            p1_won, _ = play_recursive_game!(p1_sub_deck, p2_sub_deck)
        else
            p1_won = cp1 > cp2
        end
        if p1_won
            push!(p1_deck, cp1)
            push!(p1_deck, cp2)
        else
            push!(p2_deck, cp2)
            push!(p2_deck, cp1)
        end
    end
    length(p1_deck) > 0, calc_score(p1_deck) + calc_score(p2_deck)
end

p1_deck, p2_deck = load_data()
println(play_game!(p1_deck, p2_deck))
p1_deck, p2_deck = load_data()
println(play_recursive_game!(p1_deck, p2_deck)[2])