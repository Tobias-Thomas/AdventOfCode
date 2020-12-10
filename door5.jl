function load_data()
    board_passes = readlines("door5_input")
    char_dict = Dict('F'=>'0', 'B'=>'1', 'L'=>'0', 'R'=>'1')
    map_char_to_01(c) = char_dict[c]
    map_string_to_bitstring(s) = map_char_to_01.(collect(s))
    map_string_to_bitstring.(board_passes)
end

function calc_seat_id(seat_string)
    row = parse(Int, string(seat_string[1:7]...), base=2)
    column = parse(Int, string(seat_string[8:end]...), base=2)
    8 * row + column
end

function calc_own_seat(seat_list)
    i = 1
    while true
        if !(i in seat_list)
            if i-1 in seat_list && i+1 in seat_list
                return i
            end
        end
        i += 1
    end
end

board_passes = load_data()

seat_id_list = calc_seat_id.(board_passes)
println(max(seat_id_list...))
println(calc_own_seat(seat_id_list))
