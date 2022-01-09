p1_start = 7
p2_start = 2

function play_until_one_wins(p1, p2)
    p1_score, p2_score = 0, 0
    p1_turn = true
    last_die_value = 0
    rolls = 0
    while true
        rolls += 3
        next_die_value = sum(mod1.([last_die_value + i for i in 1:3], 100))
        last_die_value = mod1(last_die_value + 3, 100)
        if p1_turn
            p1 = mod1(p1+next_die_value, 10)
            p1_score += p1
            p1_score >= 1000 && return p2_score * rolls
        else
            p2 = mod1(p2+next_die_value, 10)
            p2_score += p2
            p2_score >= 1000 && return p1_score * rolls
        end
        p1_turn = !p1_turn
    end
end

const shifts = Dict(
    3 => 1,
    4 => 3,
    5 => 6, 
    6 => 7,
    7 => 6,
    8 => 3,
    9 => 1
)

function count_multiverses(p1,p2)
    multiverse_dict = Dict((p1,p2,0,0,true)=>1)
    num_universes_p1_won = 0
    num_universes_p2_won = 0
    while true
        next_multiverse_dict = Dict{Tuple{Int,Int,Int,Int,Bool},Int}()
        for ((p1_pos, p2_pos, p1_points, p2_points, turn), num_universes) in multiverse_dict
            if p1_points >= 21
                num_universes_p1_won += num_universes
                continue
            elseif p2_points >= 21
                num_universes_p2_won += num_universes
                continue
            end
            for (shift_amount, shift_freq) in shifts
                if turn
                    next_p1_pos = mod1(p1_pos+shift_amount, 10)
                    next_p1_points = p1_points + next_p1_pos
                    next_key = (next_p1_pos,p2_pos,next_p1_points,p2_points,false)
                    if next_key in keys(next_multiverse_dict)
                        next_multiverse_dict[next_key] += num_universes * shift_freq
                    else
                        next_multiverse_dict[next_key] = num_universes * shift_freq
                    end
                else
                    next_p2_pos = mod1(p2_pos+shift_amount, 10)
                    next_p2_points = p2_points + next_p2_pos
                    next_key = (p1_pos,next_p2_pos,p1_points,next_p2_points,true)
                    if next_key in keys(next_multiverse_dict)
                        next_multiverse_dict[next_key] += num_universes * shift_freq
                    else
                        next_multiverse_dict[next_key] = num_universes * shift_freq
                    end
                end
            end
        end
        length(next_multiverse_dict) == 0 && break
        multiverse_dict = next_multiverse_dict
    end
    num_universes_p1_won, num_universes_p2_won
end

println(play_until_one_wins(p1_start, p2_start))
println(count_multiverses(p1_start, p2_start))
