function load_data()
    [(parse.(Int,split(p1, "-")), parse.(Int, split(p2, "-"))) for (p1,p2) in split.(readlines("door4_input"), ",")]
end

pairs = load_data()

is_redundant(p) = contains(p[1], p[2]) | contains(p[2], p[1])
contains(a,b) = a[1] <= b[1] & a[2] >= b[1]
is_overlap(a, b) = a[2] >= b[1] & b[2] >= a[1]

println(sum(is_redundant.(pairs)))
println(sum(is_overlap(p1, p2) for (p1,p2) in pairs))
