function load_data()
    cal_sum = Vector{Int}()
    current_sum = 0
    for l in readlines("door1_input")
        if l == ""
            push!(cal_sum, current_sum)
            current_sum = 0
        else
            current_sum += parse(Int, l)
        end
    end
    cal_sum
end

cal_sum = load_data()
println(maximum(cal_sum))
println(sum(sort(cal_sum, rev=true)[1:3]))
