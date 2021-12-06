struct BingoEntry
    number::Int
    marked::Bool
end

function load_data()
    data = readlines("door4_input")
    draws = [parse(Int, x) for x in split(data[1], ",")]
    tables = [read_table(data[i+1:i+5]) for i in 2:6:length(data)]
    draws, tables
end

function read_table(lines)
    field = Array{BingoEntry}(undef, 5,5)
    for (i,l) in enumerate(lines)
        for (j,n) in enumerate(1:3:length(l))
            field[i,j] = BingoEntry(parse(Int, l[n:n+1]), false)
        end
    end
    field
end

function mark_number_on_field!(field, number)
    for i in eachindex(field)
        if field[i].number == number
            field[i] = BingoEntry(number, true)
        end
    end
end

function check_if_won(field)
    for i in 1:5
        if all([field[i,j].marked for j in 1:5]) | all([field[j,i].marked for j in 1:5]) 
            return true
        end
    end
    return false
end

sum_unmarked(f) = sum(f[i].number for i in eachindex(f) if !f[i].marked)

function play_until_win!(numbers, fields)
    for n in numbers
        for f in fields
            mark_number_on_field!(f,n)
            if check_if_won(f)
                return sum_unmarked(f) * n
            end
        end
    end
end

function play_until_last_win!(numbers, fields)
    idxs_won::Vector{Int} = []
    for n in numbers
        for (i,f) in enumerate(fields)
            if i in idxs_won
                continue
            end
            mark_number_on_field!(f,n)
            if check_if_won(f)
                push!(idxs_won, i)
                if length(idxs_won) == length(fields)
                    return sum_unmarked(f) * n
                end
            end
        end
    end
end

draws, tables = load_data()
println(play_until_win!(draws, tables))
draws, tables = load_data()
println(play_until_last_win!(draws, tables))
