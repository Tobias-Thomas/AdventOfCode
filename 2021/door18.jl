mutable struct SnailFishNumber
    parent::Union{Nothing,SnailFishNumber}
    left::Union{Nothing,SnailFishNumber}
    right::Union{Nothing,SnailFishNumber}
    value::Union{Nothing,Int}
end

function Base.show(io::IO, x::SnailFishNumber) 
    if !isnothing(x.value)
        show(io, x.value)
    else
        print(io, "[")
        show(io, x.left)
        print(io, ",")
        show(io, x.right)
        print(io, "]")
    end
end

function Base.copy(x::SnailFishNumber)
    if !isnothing(x.value)
        return SnailFishNumber(nothing, nothing, nothing, x.value)
    else
        sfn = SnailFishNumber(nothing, copy(x.left), copy(x.right), nothing)
        sfn.left.parent = sfn
        sfn.right.parent = sfn
        return sfn
    end
end

function Base.:+(left::SnailFishNumber, right::SnailFishNumber)
    l, r = copy(left), copy(right)
    snf = SnailFishNumber(nothing, l, r, nothing)
    l.parent = snf
    r.parent = snf
    reduce!(snf)
    snf
end

function parse_one_part_of_pair(line, idx)
    if line[idx] == '['
        return parse_binary_tree(line, idx)
    end
    @assert isnumeric(line[idx])
    return SnailFishNumber(nothing, nothing, nothing, parse(Int, line[idx])), idx+1
end

function next_right_sfn(sfn)
    sfn = sfn
    while true
        isnothing(sfn.parent) && return nothing
        if sfn.parent.right == sfn
            sfn = sfn.parent
        else
            sfn = sfn.parent
            break
        end
    end
    sfn = sfn.right
    while typeof(sfn.left) == SnailFishNumber
        sfn = sfn.left
    end
    sfn
end

function next_left_sfn(sfn)
    while true
        isnothing(sfn.parent) && return nothing
        if sfn.parent.left == sfn
            sfn = sfn.parent
        else
            sfn = sfn.parent
            break
        end
    end
    sfn = sfn.left
    while typeof(sfn.right) == SnailFishNumber
        sfn = sfn.right
    end
    sfn
end

function explode!(sfn::SnailFishNumber)
    @assert !isnothing(sfn.right.value) && !isnothing(sfn.left.value)
    left_node = next_left_sfn(sfn.left)
    if !isnothing(left_node)
        left_node.value += sfn.left.value
    end
    right_node = next_right_sfn(sfn.right)
    if !isnothing(right_node)
        right_node.value += sfn.right.value
    end
    sfn.left = nothing
    sfn.right = nothing
    sfn.value = 0
end

function split!(sfn::SnailFishNumber)
    left_value = sfn.value ÷ 2
    right_value = sfn.value - left_value
    left_node = SnailFishNumber(sfn, nothing, nothing, left_value)
    right_node = SnailFishNumber(sfn, nothing, nothing, right_value)
    sfn.left = left_node
    sfn.right = right_node
    sfn.value = nothing
end

function first_exploadable(sfn, level)
    level == 5 && isnothing(sfn.value) && return sfn
    !isnothing(sfn.value) && return nothing
    exploadable = first_exploadable(sfn.left, level+1)
    !isnothing(exploadable) && return exploadable
    exploadable = first_exploadable(sfn.right, level+1)
    !isnothing(exploadable) && return exploadable
    return nothing
end

function first_splittable(sfn)
    if isnothing(sfn.value)
        splittable = first_splittable(sfn.left)
        !isnothing(splittable) && return splittable
        splittable = first_splittable(sfn.right)
        !isnothing(splittable) && return splittable
        return nothing
    else
        return sfn.value > 9 ? sfn : nothing
    end
end

function reduce!(sfn)
    while true
        exploadable = first_exploadable(sfn, 1)
        if !isnothing(exploadable)
            explode!(exploadable)
            continue
        end

        splittable = first_splittable(sfn)
        if !isnothing(splittable)
            split!(splittable)
            continue
        end

        break
    end
end

function magnitude(sfn::SnailFishNumber)
    if !isnothing(sfn.value)
        return sfn.value
    else
        return 3*magnitude(sfn.left) + 2*magnitude(sfn.right)
    end
end

function parse_binary_tree(line, idx)
    @assert line[idx] == '['
    left, comma_index = parse_one_part_of_pair(line, idx+1)
    @assert line[comma_index] == ','
    right, close_index = parse_one_part_of_pair(line, comma_index+1)
    @assert line[close_index] == ']'
    new_snailfish_number = SnailFishNumber(nothing, left, right, nothing)
    left.parent = new_snailfish_number
    right.parent = new_snailfish_number
    return new_snailfish_number, close_index+1
end

function solve_homework(file)
    data = readlines(file)
    data = first.(parse_binary_tree.(data, 1))
    sfn = sum(data)
    println(magnitude(sfn))
    println(maximum([magnitude(x+y) for x in data, y in data if x != y]))
end

solve_homework("2021/door18_input")
@time solve_homework("2021/door18_input")
