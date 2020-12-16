load_data() = readlines("door14_input")

decimal_to_bit_array(d, pad=36) = reverse(digits(Bool, d, base=2, pad=pad))
bit_array_to_decimal(b) = sum(b .* (2 .^ collect(length(b)-1:-1:0)))

function execute(loi)
    memory = Dict(0=>0)
    replacements = zeros(Bool, 36)
    mask = zeros(Bool, 36)
    for instruction in loi
        cmd, value = split(instruction, " = ")
        if cmd == "mask"
            mask_string = collect(value)
            mask = ifelse.(mask_string .== 'X', false, true)
            replacements = ifelse.(mask_string .== '1', true, false)
        else
            address = parse(Int, match(r"\[(.*?)\]", cmd)[1])
            bit_arr_value = decimal_to_bit_array(parse(Int, value))
            memory[address] = bit_array_to_decimal(ifelse.(mask, replacements, bit_arr_value))
        end
    end
    sum(values(memory))
end

function float_address(base, mask)
    num_X = count(==('X'), mask)
    floated_addresses = []
    for i in 1:2^num_X
        replacements = decimal_to_bit_array(i-1, num_X)
        masked_address = ifelse.(mask .== '1', true, base)
        masked_address[mask .== 'X'] = replacements
        push!(floated_addresses, bit_array_to_decimal(masked_address))
    end
    floated_addresses
end

function execute_v2(loi)
    memory = Dict(0=>0)
    mask = collect('0'^36)
    for instruction in loi
        cmd, value = split(instruction, " = ")
        if cmd == "mask"
            mask = collect(value)
        else
            value = parse(Int, value)
            base_address = decimal_to_bit_array(parse(Int, match(r"\[(.*?)\]", cmd)[1]))
            for address in float_address(base_address, mask)
                memory[address] = value
            end
        end
    end
    sum(values(memory))
end

instructions = load_data()

println(execute(instructions))
println(execute_v2(instructions))