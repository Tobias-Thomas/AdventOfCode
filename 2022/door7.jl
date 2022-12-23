struct File
    id::Int
    name::String
    size::Int
    level::Int
end

Base.show(io::IO, f::File) = println(io, repeat(" ", f.level) * "- " * f.name)

struct Directory
    id::Int
    name::String
    content::Vector{Union{Directory,File}}
    parent::Union{Directory,Nothing}
    level::Int
end

function Base.show(io::IO, d::Directory)
    println(io, repeat(" ", d.level) * "- " * d.name)
    print.(io, d.content)
end

function load_data()
    lines = readlines("door7_input")
    root = Directory(0, "/", [], nothing, 0)
    current = root
    level = 1
    id = 1
    for l in lines
        if l == "\$ ls"
            continue
        elseif startswith(l, "\$ cd")
            destination = l[6:end]
            if destination == ".."
                current = current.parent
                level -= 1
            else
                dest_idx = findfirst(x -> x.name == destination, current.content)
                current = current.content[dest_idx]
                level += 1
            end
        else 
            info, name = split(l, " ")
            if info == "dir"
                push!(current.content, Directory(id, name, [], current, level))
            else
                push!(current.content, File(id, name, parse(Int, info), level))
            end
            id += 1
        end
    end
    root
end

function calc_dir_sizes!(root, dir2size)
    root_size = 0
    for c in root.content
        if typeof(c) == File
            root_size += c.size
        else
            root_size += calc_dir_sizes!(c, dir2size)
        end
    end
    dir2size[root.id] = root_size
    root_size
end

function find_best_folder(dir2size)
    needed_space = 30000000 - (70000000 - dir2size[0])
    min_bigger = Inf
    for (_,v) in dir2size
        if v > needed_space && v < min_bigger
            min_bigger = v
        end
    end
    min_bigger
end

root_node = load_data()
d2s = Dict{Int,Int}()
calc_dir_sizes!(root_node, d2s)
println(sum(filter(x -> x <= 100_000, collect(values(d2s)))))

size_best_folder = find_best_folder(d2s)
println(size_best_folder)
