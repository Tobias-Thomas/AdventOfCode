function load_data()
    lines = readlines("door18_input")
    Set(parse_line.(lines))
end

function parse_line(l)
    Tuple(parse.(Int, split(l, ",")) .+ 1)
end

const NEIGHBOURS = [
    (-1,0,0),
    (1,0,0),
    (0,-1,0),
    (0,1,0),
    (0,0,-1),
    (0,0,1)
]

function calculate_free_sides(cubes)
    num_free_sides = 0
    for c in cubes
        for n in NEIGHBOURS
            num_free_sides += !(c.+n in cubes)
        end
    end
    return num_free_sides
end

function calc_free_matrix()
    free_matrix = zeros(Bool, (20,20,20))
    next_matrix = zeros(Bool, (20,20,20))
    changed = true
    while changed
        changed = false
        next_matrix = free_matrix
        for i in CartesianIndices(free_matrix)
            ((free_matrix[i]) || (i.I in cubes)) && continue
            if any(i.I .∈ ([1,20],)) 
                next_matrix[i] = true
                changed = true
            elseif any(free_matrix[CartesianIndex(i.I.+n)] for n in NEIGHBOURS)
                next_matrix[i] = true
                changed = true
            end
        end
    end
    free_matrix
end

function calculate_free_sides2(cubes)
    num_free_sides = 0
    free_matrix = calc_free_matrix()
    for c in cubes
        for n in NEIGHBOURS
            c_neighbour = c.+n
            num_free_sides += any(c_neighbour .∈ ([0,21],)) || free_matrix[CartesianIndex(c_neighbour)]
        end
    end
    return num_free_sides
end

cubes = load_data()
println(calculate_free_sides(cubes))
println(calculate_free_sides2(cubes))
