using DelimitedFiles

read_data(fname) = vec(readdlm(fname,Int))
v = read_data("door1_input")

function find_tuple()
    for i in eachindex(v)
        for j in 1:i
            if v[i] + v[j] == 2020
                return v[i] * v[j]
            end
        end
    end
end

function find_triplet()
    for x in eachindex(v), y in eachindex(v), z in eachindex(v)
        if v[x] + v[y] + v[z] == 2020
            return v[x] * v[y] * v[z]
        end
    end
end

println(find_tuple())
println(find_triplet())
