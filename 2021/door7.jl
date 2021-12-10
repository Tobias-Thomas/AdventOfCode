using Statistics

sum_to_n(n) = (n*(n+1)) ÷ 2

crabs = parse.(Int, split(readlines("door7_input")[1], ","))
m = median(crabs)
a = sum(crabs) ÷ length(crabs)

println(convert(Int, sum(abs.(crabs .- m))))
println(convert(Int, sum(sum_to_n.(abs.(crabs .- a)))))