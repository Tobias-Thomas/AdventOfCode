struct State
    hallway::Vector{Int}
    side_rooms::Vector{Vector{Int}}
end

State(a_room, b_room, c_room, d_room) = State(zeros(11), [a_room,b_room,c_room,d_room])
Base.copy(s::State) = State(copy(s.hallway), [copy(sr) for sr in s.side_rooms])
rhash(a,b) = hash(b,a)
function Base.hash(s::State)
    h = reduce(rhash, s.hallway, init=UInt64(0))
    for sr in s.side_rooms
        h = reduce(rhash, sr, init=h)
    end
    h
end
function Base.isequal(s1::State, s2::State)
    all(x->x[1]==x[2], zip(s1.hallway, s2.hallway)) || return false
    for (sr1,sr2) in zip(s1.side_rooms,s2.side_rooms)
        all(x->x[1]==x[2], zip(sr1,sr2)) || return false
    end
    return true
end
function Base.show(io::IO, s::State)
    println(io, fill('#', 13)...)
    hallway_string = prod([amphipod_dict[h] for h in s.hallway])
    println(io, "#$(hallway_string)#")
    println(io, "##$(stringify_side_rooms(s, 1))###")
    for i in 2:length(s.side_rooms[1])
        println(io, "  $(stringify_side_rooms(s, i))#")
    end
    println(io, "  $(fill('#', 9)...)")
end
function stringify_side_rooms(s, depth)
    res = ""
    for i in 1:4
        res *= '#'
        res *= amphipod_dict[s.side_rooms[i][depth]]
    end
    res
end

const amphipod_dict = Dict(zip(0:4, ['.','A':'D'...]))
const side_room_entries = [3,5,7,9]
const avail_hallway_spots = setdiff(1:11, side_room_entries)
const max_cost = typemax(Int)

function all_neighbors(s::State)
    next_states_with_cost = Vector{Tuple{State,Int}}()
    for (p,h) in enumerate(s.hallway)
        h == 0 && continue
        all(e -> e in (0,h), s.side_rooms[h]) || continue
        entry = side_room_entries[h]
        d = p > entry ? -1 : 1
        all(==(0), s.hallway[p+d:d:entry]) || continue
        room_depth = findlast(==(0), s.side_rooms[h])
        steps = abs(entry-p) + room_depth
        cost = 10^(h-1) * steps
        next_s = copy(s)
        next_s.hallway[p] = 0
        next_s.side_rooms[h][room_depth] = h
        push!(next_states_with_cost, (next_s,cost))
    end
    for (hsr,sr) in enumerate(s.side_rooms), (p,h) in enumerate(sr)
        h == 0 && continue
        all(==(hsr), sr[p:end]) && continue
        p > 1 && sr[p-1] != 0 && continue
        for hs in avail_hallway_spots
            entry = side_room_entries[hsr]
            d = entry > hs ? -1 : 1
            all(==(0), s.hallway[entry:d:hs]) || continue
            steps = p + abs(entry - hs)
            cost = 10^(h-1) * steps
            next_s = copy(s)
            next_s.hallway[hs] = h
            next_s.side_rooms[hsr][p] = 0
            push!(next_states_with_cost, (next_s, cost))
        end
    end
    next_states_with_cost
end

is_final_state(s::State) = all(sr -> sr[2][1]==sr[2][2]==sr[1], enumerate(s.side_rooms))
cost_from_state_dict = Dict{State,Int}()
function find_minimal_cost_path(s::State)
    s in keys(cost_from_state_dict) && return cost_from_state_dict[s]
    is_final_state(s) && return 0
    min_cost = max_cost
    for (next_state,cost) in all_neighbors(s)
        best_from_next_state = find_minimal_cost_path(next_state)
        if best_from_next_state != max_cost
            min_cost = min(min_cost, cost+best_from_next_state)
        end
    end
    cost_from_state_dict[s] = min_cost
    min_cost
end

start_s1 = State([4,2],[1,1],[2,4],[3,3])
@time println(find_minimal_cost_path(start_s1))
start_s2 = State([4,4,4,2],[1,3,2,1],[2,2,1,4],[3,1,3,3])
@time println(find_minimal_cost_path(start_s2))
