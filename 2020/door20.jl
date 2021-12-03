using DataStructures

const SIZE=12

struct Tile
    id::Int
    borders::Array{Array{Int, 1}, 1}
    parquet::Array{Char, 2}
end

struct OrientedTile
    tile::Tile
    orientation::Int
end

function load_data()
    tile_infos = readlines("door20_input")
    idx = 1
    tiles::Array{Tile, 1} = []
    while idx < length(tile_infos)
        tile_id = parse(Int, match(r"\d+", tile_infos[idx]).match)
        parquet = arr_of_arr_to_mat(collect.(tile_infos[idx+1:idx+10]))
        borders = parse_borders(parquet)
        push!(tiles, Tile(tile_id, borders, parquet))
        idx += 12
    end
    tiles
end

function parse_borders(tile)
    tile = replace(tile, '#'=>'1')
    tile = replace(tile, '.'=>'0')
    p4 = join(tile[1:end, 1])
    p3 = join(tile[end, 1:end])
    p2 = join(tile[1:end, end])
    p1 = join(tile[1, 1:end])
    n1 = reverse(p1)
    n2 = reverse(p2)
    n3 = reverse(p3)
    n4 = reverse(p4)
    [
        parse.(Int, [p1, p2, p3, p4], base=2),
        parse.(Int, [n4, p1, n2, p3], base=2),
        parse.(Int, [n3, n4, n1, n2], base=2),
        parse.(Int, [p2, n3, p4, n1], base=2),
        parse.(Int, [n1, p4, n3, p2], base=2),
        parse.(Int, [p4, p3, p2, p1], base=2),
        parse.(Int, [p3, n2, p1, n4], base=2),
        parse.(Int, [n2, n1, n4, n3], base=2),
    ]
end

function oriente_parquet(oriented_tile::OrientedTile)
    function flip_parquet(parquet)
        arr_of_arr_to_mat(reverse.([parquet[i,1:end] for i in 1:size(parquet, 1)]))
    end
    function rotate90_parquet(parquet)
        flip_parquet(permutedims(parquet, (2,1)))
    end

    orientation = oriented_tile.orientation
    parquet = oriented_tile.tile.parquet

    while mod1(orientation, 4) > 1
        parquet = rotate90_parquet(parquet)
        orientation -= 1
    end
    if orientation > 4
        parquet = flip_parquet(parquet)
        orientation -= 4
    end
    parquet
end

function verify_edge_numbers(oriented_tile::OrientedTile)
    oriented_parquet = oriente_parquet(oriented_tile)
    oriented_parquet = replace(oriented_parquet, '#'=>'1')
    oriented_parquet = replace(oriented_parquet, '.'=>'0')

    e4 = join(oriented_parquet[1:end, 1])
    e3 = join(oriented_parquet[end, 1:end])
    e2 = join(oriented_parquet[1:end, end])
    e1 = join(oriented_parquet[1, 1:end])
    parse.(Int, [e1,e2,e3,e4], base=2)
end

function arr_of_arr_to_mat(a::Array{Array{T, 2}, 2}) where {T}
    do1, do2 = size(a)
    di1, di2 = size(a[1])
    A = Array{T, 2}(undef, do1*di1, do2*di2)
    for i in eachindex(a) 
        row = mod1(i, do1)
        col = ((i-1) ÷ do2) + 1
        A[1+(row-1)*di1:row*di1, 1+(col-1)*di2:col*di2] = a[i]
    end
    A
end

function arr_of_arr_to_mat(a::Vector{Vector{T}}) where {T}
    n, m = length(a), length(a[1])
    @assert all(ai -> length(ai) == m, a)
    A = Array{T, 2}(undef, n, m)
    @inbounds for i ∈ 1:n
        A[i, :] = a[i]
    end
    A
end

function construct_final_image(puzzle)
    crop_edges(i) = i[2:end-1,2:end-1]
    final_image = crop_edges.(oriente_parquet.(puzzle))
    arr_of_arr_to_mat(final_image)
end

function find_pattern_in_image(pattern, img)
    hash_pos_list = findall(==('#'), pattern)
    size_img = size(img)
    size_pattern = size(pattern)
    num_patterns_found = 0
    for idx in CartesianIndices((size_img[1]-size_pattern[1], size_img[2]-size_pattern[2]))
        pattern_matched = true
        for hash_pos in hash_pos_list
            if img[idx+hash_pos] != '#'
                pattern_matched = false
                break
            end
        end
        if pattern_matched
            num_patterns_found += 1
        end
    end
    count(==('#'), img) - num_patterns_found * length(hash_pos_list)
end

function create_tile_border_dict(tiles)
    left_d = DefaultDict{Int, Set{OrientedTile}}(Set{OrientedTile})
    top_d = DefaultDict{Int, Set{OrientedTile}}(Set{OrientedTile})

    for t in tiles
        for o in 1:8
            push!(top_d[t.borders[o][1]], OrientedTile(t, o))
            push!(left_d[t.borders[o][4]], OrientedTile(t, o))
        end
    end
    left_d, top_d
end

function display_puzzle(p)
    println(p[1].tile.id * p[SIZE].tile.id * p[end-SIZE+1].tile.id * p[end].tile.id)
    #display(map(x->x.tile.id, p))
end

function solve_puzzle!(tiles, left_d, top_d, solutions,
    curr_puzzle=Array{OrientedTile, 2}(undef,SIZE,SIZE), already_used=Set(), idx=1)

    if idx == SIZE^2+1
        push!(solutions, copy(curr_puzzle))
        display_puzzle(curr_puzzle)
    end
    if idx == 1
        for t in tiles
            for o in 1:8
                curr_puzzle[idx] = OrientedTile(t, o)
                push!(already_used, t.id)
                solve_puzzle!(tiles, left_d, top_d, solutions, curr_puzzle, already_used, idx+1)
                pop!(already_used, t.id)
            end
        end
        return
    end
    poss_candidates_l = nothing
    poss_candidates_t = nothing
    poss_candidates = nothing
    if !(idx % SIZE == 1)
        neighbor = curr_puzzle[idx-1]
        poss_candidates_t = top_d[neighbor.tile.borders[neighbor.orientation][3]]
    end
    if !(idx <= SIZE)
        neighbor = curr_puzzle[idx-SIZE]
        poss_candidates_l = left_d[neighbor.tile.borders[neighbor.orientation][2]]
    end
    if isnothing(poss_candidates_l)
        poss_candidates = poss_candidates_t
    elseif isnothing(poss_candidates_t)
        poss_candidates = poss_candidates_l
    else
        poss_candidates = intersect(poss_candidates_l, poss_candidates_t)
    end
    if !isnothing(poss_candidates)
        for c in poss_candidates
            if !(c.tile.id in already_used)
                curr_puzzle[idx] = c
                push!(already_used, c.tile.id)
                solve_puzzle!(tiles, left_d, top_d, solutions, curr_puzzle, already_used, idx+1)
                pop!(already_used, c.tile.id)
            end
        end
    end
end

tiles = load_data()
left_d, top_d = create_tile_border_dict(tiles)
solutions = Array{Array{OrientedTile, 2}, 1}()
solve_puzzle!(tiles, left_d, top_d, solutions)

seamonster =
"                  # 
#    ##    ##    ###
 #  #  #  #  #  #   "
seamonster = arr_of_arr_to_mat(collect.(split(seamonster, "\n")))
images = construct_final_image.(solutions)
for i in images
    println(find_pattern_in_image(seamonster, i))
end