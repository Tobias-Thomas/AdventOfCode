load_data() = readlines("door6_input")[1]

datastream = load_data()

function find_sop_marker(s)
    i = 4
    while true
        length(unique(s[i-3:i])) == 4 && return i
        i += 1
    end
end

function find_som_marker(s)
    i = 14
    while true
        length(unique(s[i-13:i])) == 14 && return i
        i += 1
    end
end

println(find_sop_marker(datastream))
println(find_som_marker(datastream))
