load_init_field(filename) = reduce(vcat, permutedims.(collect.(readlines(filename))))

get_east_neighbor(idx) = CartesianIndex(idx[1], mod1(idx[2]+1, w)) 
get_south_neighbor(idx) = CartesianIndex(mod1(idx[1]+1, h), idx[2])
get_west_neighbor(idx) = CartesianIndex(idx[1], mod1(idx[2]-1, w)) 
get_north_neighbor(idx) = CartesianIndex(mod1(idx[1]-1, h), idx[2])

function find_movers(f)
    east_mover = Set{CartesianIndex{2}}()
    south_mover = Set{CartesianIndex{2}}()
    for idx in CartesianIndices(f)
        if f[idx] == '>'
            neighbor = get_east_neighbor(idx)
            if f[neighbor] == '.'
                push!(east_mover, idx)
            end
        elseif f[idx] == 'v'
            neighbor = get_south_neighbor(idx)
            if f[neighbor] == '.'
                push!(south_mover, idx)
            end
        end
    end
    east_mover, south_mover
end

function one_step!(field, east_movers, south_movers)
    next_east_movers = Set{CartesianIndex{2}}()
    for em in east_movers
        @assert field[em] == '>'
        field[em] = '.'
        neighbor = get_east_neighbor(em)
        @assert field[neighbor] == '.'
        field[neighbor] = '>'
        north_of_neighbor = get_north_neighbor(neighbor)
        if field[north_of_neighbor] == 'v'
            @assert north_of_neighbor in south_movers
            delete!(south_movers, north_of_neighbor)
        end
        north_of_em = get_north_neighbor(em)
        if field[north_of_em] == 'v'
            push!(south_movers, north_of_em)
        end
        west_of_em = get_west_neighbor(em)
        if field[west_of_em] == '>'
            @assert !(west_of_em in east_movers)
            push!(next_east_movers, west_of_em)
        end
        if field[get_east_neighbor(neighbor)] == '.'
            push!(next_east_movers, neighbor)
        end
    end
    east_movers = next_east_movers
    @assert east_movers == find_movers(field)[1]
    next_south_movers = Set{CartesianIndex{2}}()
    for sm in south_movers
        @assert field[sm] == 'v'
        field[sm] = '.'
        neighbor = get_south_neighbor(sm)
        @assert field[neighbor] == '.'
        field[neighbor] = 'v'
        west_of_neighbor = get_west_neighbor(neighbor)
        if field[west_of_neighbor] == '>'
            @assert west_of_neighbor in east_movers
            delete!(east_movers, west_of_neighbor)
        end
        west_of_sm = get_west_neighbor(sm)
        if field[west_of_sm] == '>'
            @assert !(west_of_sm in east_movers)
            push!(east_movers, west_of_sm)
        end
        north_of_sm = get_north_neighbor(sm)
        if field[north_of_sm] == 'v'
            @assert !(north_of_sm in south_movers)
            push!(next_south_movers, north_of_sm)
        end
        if field[get_south_neighbor(neighbor)] == '.'
            push!(next_south_movers, neighbor)
        end
    end
    south_movers = next_south_movers
    @assert (east_movers, south_movers) == find_movers(field)
    east_movers, south_movers
end

function simulate_until_standstill(field)
    east_movers, south_movers = find_movers(field)
    num_iterations = 1
    while length(east_movers) > 0 || length(south_movers) > 0
        num_iterations += 1
        east_movers, south_movers = one_step!(field, east_movers, south_movers)
    end
    num_iterations
end

field = load_init_field("2021/door25_input")
h, w = size(field)
println(simulate_until_standstill(field))
@time simulate_until_standstill(field)