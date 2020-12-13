function load_data()
    split.(readlines("door8_input"), " ")
end

function execude_until_loop_or_end(code)
    pointer = 1
    pointer_list = []
    accumluator = 0
    while !(pointer in pointer_list)
        if pointer > length(code)
            return accumluator, true
        end
        push!(pointer_list, pointer)
        inst, arg = code[pointer]
        if inst == "nop"
            pointer += 1
        elseif inst == "acc"
            accumluator += parse(Int, arg)
            pointer += 1
        elseif inst == "jmp"
            pointer += parse(Int, arg)
        end
    end
    accumluator, pointer > length(code)
end

function fix_inst(code)
    for i in eachindex(code)
        inst, arg = code[i]
        if inst == "acc"
            continue
        elseif inst == "jmp"
            new_inst = "nop"
        elseif inst == "nop"
            new_inst = "jmp"
        end
        changed_code = vcat(code[1:i-1], [[new_inst, arg]], code[i+1:end])
        acc_value, finished = execude_until_loop_or_end(changed_code)
        if finished
            return acc_value
        end
    end
    return -1
end

instructions = load_data()

println(execude_until_loop_or_end(instructions))
println(fix_inst(instructions))