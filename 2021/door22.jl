Cuboid = Tuple{UnitRange{Int},UnitRange{Int},UnitRange{Int}}
NonOLCuboids = Vector{Cuboid}

function Base.intersect(c1::Cuboid, c2::Cuboid) 
    t = (intersect(c1[i],c2[i]) for i in 1:3)
    any(r -> length(r)==0, t) && return nothing
    Cuboid(t)
end

volume(c::Cuboid) = prod(length.(c))
volume(nolc::NonOLCuboids) = sum(volume.(nolc))

struct Command
    cube::Cuboid
    turn_on::Bool
end

struct Section
    segment::UnitRange{Int}
    is_new::Bool
end

const line_regex = r"(\S+) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)"

function parse_line(l)
    m = match(line_regex, l)
    @assert !isnothing(m)
    c = m.captures
    return Command((
        UnitRange(parse.(Int, c[2:3])...),
        UnitRange(parse.(Int, c[4:5])...),
        UnitRange(parse.(Int, c[6:7])...)
    ), c[1]=="on")
end

function split_dimension(old_section::UnitRange{Int}, new_section::UnitRange{Int})
    splitted = [Section(new_section,true)]
    if new_section[1] > old_section[1]
        push!(splitted, Section(old_section[1]:new_section[1]-1,false))
    end
    if new_section[end] < old_section[end]
        push!(splitted, Section(new_section[end]+1:old_section[end],false))
    end
    splitted
end

function split_cuboid(c::Cuboid, intersect::Cuboid)
    dimensions_splits = Tuple(split_dimension(c[i],intersect[i]) for i in 1:3)
    splitted_cuboids = NonOLCuboids()
    for x in dimensions_splits[1], y in dimensions_splits[2], z in dimensions_splits[3]
        all(i->i.is_new, (x,y,z)) && continue
        push!(splitted_cuboids, Cuboid((x.segment,y.segment,z.segment)))
    end
    splitted_cuboids
end

is_inner_command(c::Command) = all(r->r[1]>=-50&&r[end]<=50, c.cube)

function execute_commands(commands)
    on_cuboids = NonOLCuboids()
    for c in commands
        next_on_cuboids = NonOLCuboids()
        for on_c in on_cuboids
            inter = intersect(c.cube, on_c)
            if !isnothing(inter)
                push!(next_on_cuboids, split_cuboid(on_c, inter)...)
            else
                push!(next_on_cuboids, on_c)
            end
        end
        if c.turn_on
            push!(next_on_cuboids, c.cube)
        end
        on_cuboids = next_on_cuboids
    end
    on_cuboids
end

data = readlines("2021/door22_input")
cmds = parse_line.(data)
println(volume(execute_commands(filter(is_inner_command, cmds))))
println(volume(execute_commands(cmds)))
