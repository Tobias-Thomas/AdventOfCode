commands = readlines("door2_input")

function execute_command!(c, measures)
    direction, value = split(c, " ")
    value = parse(Int, value)
    if direction == "forward"
        measures[1] += value
    elseif direction == "down"
        measures[2] += value
    elseif direction == "up"
        measures[2] -= value
    end
end

function execute_command2!(c, measures)
    direction, value = split(c, " ")
    value = parse(Int, value)
    if direction == "forward"
        measures[1] += value
        measures[2] += measures[3] * value
    elseif direction == "down"
        measures[3] += value
    elseif direction == "up"
        measures[3] -= value
    end
end

function execute_all_commands(ex_f!, num_measures)
    m = [0 for _ in 1:num_measures]
    for c in commands
        ex_f!(c, m)
    end
    m
end

println(prod(execute_all_commands(execute_command!, 2)))
println(prod(execute_all_commands(execute_command2!, 3)[1:2]))
