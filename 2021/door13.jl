using SparseArrays

parse_dot_line(l) = Tuple(reverse(parse.(Int, split(l, ",")) .+ 1))

function all_folds(sheet, instructions)
    for (i,inst) in enumerate(instructions)
        direction, val = split(inst, "=")
        val = parse(Int, val) + 1
        direction = direction[end] == 'x'
        for p in findall(!iszero, sheet)
            flipped_point = direction ? (p[1], 2*val-p[2]) : (2*val-p[1], p[2])
            sheet[flipped_point...] = 1
        end
        sheet = direction ? sheet[:, 1:val-1] : sheet[1:val-1, :]
        i == 1 && println(sum(!iszero, sheet))
    end
    display(sheet)
end

data = readlines("door13_input")
split_point = findfirst(==(""), data)
points, folds = parse_dot_line.(data[1:split_point-1]), data[split_point+1:end]
sheet = sparse(first.(points), last.(points), 1)
all_folds(sheet, folds)