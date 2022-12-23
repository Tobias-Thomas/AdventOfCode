function load_data()
    lines = readlines("door10_input") 
    [(c[1], parse(Int, c[2])) for c in split.(lines, " ")]
end

function execute_commands(cmds)
    Channel{Tuple{Int,Int}}(length(cmds)) do ch
        x = 1
        t = 1
        for c in cmds
            inst, amount = c
            if inst == "noop"
                put!(ch, (t,x))
                t += 1
            else
                put!(ch, (t,x))
                put!(ch, (t+1,x))
                x += amount
                t += 2
            end
        end
    end
end
 
function calc_signal_strength(cmds)
    signal_strength = 0
    for (t,x) in execute_commands(cmds)
        if (t-20)%40 == 0
            signal_strength += t * x
        end
    end
    signal_strength
end

function draw(cmds)
    display = fill('.', (6,40))
    for (t,x) in execute_commands(cmds)
        px, py = (t-1) % 40, (t-1) ÷ 40
        display[py+1,px+1] = abs(px - x) <= 1 ? '#' : ' '
    end
    display
end

function print_display(d)
    for r in eachrow(d)
        println(r)
    end
end

commands = load_data()
println(calc_signal_strength(commands))
print_display(draw(commands))
