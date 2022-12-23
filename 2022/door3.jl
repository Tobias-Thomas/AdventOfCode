load_data() = readlines("door3_input")

rucksacks = load_data()

function find_duplicate(r)
    l = length(r)
    first_half, second_half = r[1:l÷2], r[(l÷2)+1:end]
    intersect(first_half, second_half)[1]
end

function char2priority(c)
    ord = Int(c)
    ord > 96 ? ord - 96 : ord - 38
end

find_badge(r1, r2, r3) = intersect(r1, r2, r3)[1]

println(sum(char2priority.(find_duplicate.(rucksacks))))
println(sum(char2priority.([find_badge(rucksacks[i:i+2]...) for i in 1:3:length(rucksacks)])))
