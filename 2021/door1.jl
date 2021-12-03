load_data() = parse.(Int64, readlines("door1_input"))

d = load_data()

function convert_to_sliding_window(data)
    sliding_window_data = []
    for i in 1:(length(data)-2)
        push!(sliding_window_data, sum(data[i:i+2]))
    end
    sliding_window_data
end
num_deeper(data) = sum(diff(data) .> 0)

println(num_deeper(d))
sw_d = convert_to_sliding_window(d)
println(num_deeper(sw_d))
