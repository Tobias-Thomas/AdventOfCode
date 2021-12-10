function load_data()
    inp = readlines("door9_input")
    field = zeros(UInt8,length(inp),length(inp[1]))
    for (y,l) in enumerate(inp)
        for (x,n) in enumerate(l)
            field[y,x] = parse(UInt8,n)
        end
    end
    field
end

function find_valleys(height_map)
    valley_idxs::Vector{CartesianIndex{2}} = []
    for i in CartesianIndices(height_map)
        neighbors::Vector{UInt8} = []
        i[1] > 1 && push!(neighbors, height_map[i+CartesianIndex(-1,0)])
        i[2] > 1 && push!(neighbors, height_map[i+CartesianIndex(0,-1)])
        i[1] < size(height_map, 1) && push!(neighbors, height_map[i+CartesianIndex(1,0)])
        i[2] < size(height_map, 2) && push!(neighbors, height_map[i+CartesianIndex(0,1)])
        
        all(height_map[i] .< neighbors) && push!(valley_idxs, i)
    end
    valley_idxs
end

function basin(height_map, valley)
    valley_value = height_map[valley]
    basin_idxs = Set([valley])
    neighbor = valley+CartesianIndex(-1,0)
    valley[1] > 1 && valley_value < height_map[neighbor] < 9 && union!(basin_idxs, basin(height_map, neighbor))
    neighbor = valley+CartesianIndex(0,-1)
    valley[2] > 1 && valley_value < height_map[neighbor] < 9 && union!(basin_idxs, basin(height_map, neighbor))
    neighbor = valley+CartesianIndex(1,0)
    valley[1] < size(height_map, 1) && valley_value < height_map[neighbor] < 9 && union!(basin_idxs, basin(height_map, neighbor))
    neighbor = valley+CartesianIndex(0,1)
    valley[2] < size(height_map, 2) && valley_value < height_map[neighbor] < 9 && union!(basin_idxs, basin(height_map, neighbor))
    return basin_idxs
end

field = load_data()
valley_idxs = find_valleys(field)
println(sum(field[valley_idxs].+1))
basin_sizes = sort!([length(basin(field, v)) for v in valley_idxs], rev=true)
println(prod(basin_sizes[1:3]))
