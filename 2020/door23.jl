function simulate!(next_vec, current_cup, numiter, solution_type)
    for _ in 1:numiter
        take_out1 = next_vec[current_cup]
        take_out2 = next_vec[take_out1]
        take_out3 = next_vec[take_out2]
        next_cup = next_vec[take_out3]

        dest_cup = current_cup - 1
        while (dest_cup in [take_out1, take_out2, take_out3] || dest_cup < 1)
            if !(dest_cup >= 1)
                dest_cup = length(next_vec)
            else
                dest_cup -= 1
            end
        end
        after_dest_cup = next_vec[dest_cup]

        next_vec[current_cup] = next_cup
        next_vec[dest_cup] = take_out1
        next_vec[take_out3] = after_dest_cup

        current_cup = next_cup
    end
    if solution_type == 1
        solution_vec = [next_vec[1]]
        for _ in 3:length(next_vec)
            push!(solution_vec, next_vec[solution_vec[end]])
        end
        return join(solution_vec, "")
    elseif solution_type == 2
        return Int64(next_vec[1]) * Int64(next_vec[next_vec[1]])
    end
end

function build_next_vector(cups, extend_to=0)
    nexts = Vector{Int32}()
    num_cups = length(cups)
    if extend_to > 10
        sizehint!(nexts, extend_to)
    end
    for n in eachindex(cups)
        push!(nexts, cups[mod1(findfirst(==(n), cups)+1, num_cups)])
    end
    if extend_to > num_cups
        for n in num_cups+1:extend_to
            push!(nexts, n+1)
        end
        nexts[extend_to] = cups[1]
        nexts[cups[end]] = num_cups+1
    end
    nexts
end

cups = [9,2,5,1,7,6,8,3,4]
@time println(simulate!(build_next_vector(cups), cups[1], 100, 1))
@time println(simulate!(build_next_vector(cups, 1_000_000), cups[1], 10_000_000, 2))