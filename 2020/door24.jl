using DataStructures
import Base.iterate

struct Instruction
    inst::String
end

mutable struct Tile
    is_black::Bool
    num_black_neighbors::Int
end

function iterate(iter::Instruction, state=1)
    if state > length(iter.inst)
        return nothing
    end
    direction = [0,0]
    comb_direction = iter.inst[state] in ('s', 'n')
    if iter.inst[state] == 's'
        direction[2] = -1
        state += 1
    elseif iter.inst[state] == 'n'
        direction[2] = 1
        state += 1
    end
    amount = comb_direction ? 1 : 2
    if iter.inst[state] == 'e'
        direction[1] = amount
    elseif iter.inst[state] == 'w'
        direction[1] = -amount
    else
        error("here needs to be an `e` or `w`")
    end
    (direction, state+1)
end

function simulate(instructions, numiter)
    tile_dict = DefaultDict{Vector{Int}, Tile}(() -> Tile(false, 0))
    coords = sum.(instructions)
    for c in coords
        tile_dict[c].is_black = ! tile_dict[c].is_black
    end
    neighbors = ([2,0], [1,-1], [-1,-1], [-2,0], [-1,1], [1,1])
    for _ in 1:numiter
        next_tile_dict = DefaultDict{Vector{Int}, Tile}(() -> Tile(false, 0))
        # count neighbors
        for (coord,t) in tile_dict
            if t.is_black
                next_tile_dict[coord].is_black = true
                for n in neighbors
                    next_tile_dict[coord+n].num_black_neighbors += 1
                end
            end
        end
        # update colors
        for (coord,t) in next_tile_dict
            if t.is_black
                if (t.num_black_neighbors == 0 || t.num_black_neighbors > 2)
                    t.is_black = false
                end
            else
                if t.num_black_neighbors == 2
                    t.is_black = true
                end
            end
        end
        tile_dict = next_tile_dict
    end
    sum(map(t -> t.is_black, values(tile_dict)))
end

function count_black_tiles(instructions)
    tile_dict = DefaultDict{Vector{Int}, Bool}(false)
    coords = sum.(instructions)
    for c in coords
        tile_dict[c] = ! tile_dict[c]
    end
    sum(values(tile_dict))
end

load_data() = Instruction.(readlines("door24_input"))

instructions = load_data()
println(count_black_tiles(instructions))
@time println(simulate(instructions, 100))