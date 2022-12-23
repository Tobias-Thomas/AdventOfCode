function load_data()
    filter!(!isnothing, eval.(Meta.parse.(readlines("door13_input"))))
end

function in_order(a, b)
    if isa(a, Integer) && isa(b, Integer)
        return sign(b-a)
    elseif isa(a, Vector) && isa(b, Vector)
        la, lb = length(a), length(b)
        for i in 1:min(la, lb)
            ordered = in_order(a[i], b[i])
            ordered != 0 && return ordered
        end
        return sign(lb-la)
    else
        if isa(a, Integer)
            return in_order([a], b)
        elseif isa(b, Integer)
            return in_order(a, [b])
        else
            error("THIS SHOULD NEVER HAPPEN $a, $b")
        end
    end
end

function less_than(a, b)
    in_order(a,b) == 1
end

pairs = load_data()
println(sum([(i+1) ÷ 2 for i in 1:2:length(pairs) if in_order(pairs[i], pairs[i+1]) == 1]))

push!(pairs, [[2]], [[6]])
sort!(pairs, lt=less_than)
i1 = findfirst(==([[2]]), pairs)
i2 = findfirst(==([[6]]), pairs)
println(i1*i2)