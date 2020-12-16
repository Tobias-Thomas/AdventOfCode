function load_data()
    inst = readlines("door12_input")
    parse_informations(single_i) = (single_i[1], parse(Int, single_i[2:end]))
    parse_informations.(inst)
end

function follow_instructions(inst_list)
    current_pos = [0, 0]
    heading_index = 1
    headings = [[1, 0], [0, -1], [-1 , 0], [0, 1]]
    for instruction in inst_list
        command, amount = instruction
        if command == 'N'
            current_pos += [0, amount]
        elseif command == 'E'
            current_pos += [amount, 0]
        elseif command == 'S'
            current_pos += [0, -amount]
        elseif command == 'W'
            current_pos += [-amount, 0]
        elseif command == 'F'
            current_pos += amount * headings[heading_index]
        elseif command == 'R'
            heading_index += amount ÷ 90
            heading_index = mod1(heading_index, 4)
        elseif command == 'L'
            heading_index -= amount ÷ 90
            heading_index = mod1(heading_index, 4)
        end
    end
    current_pos
end

function follow_instructions2(inst_list)
    ship_pos = [0, 0]
    waypoint_pos = [10, 1]
    for instruction in inst_list
        command, amount = instruction
        if command == 'N'
            waypoint_pos += [0, amount]
        elseif command == 'E'
            waypoint_pos += [amount, 0]
        elseif command == 'S'
            waypoint_pos += [0, -amount]
        elseif command == 'W'
            waypoint_pos += [-amount, 0]
        elseif command == 'F'
            ship_pos += amount * waypoint_pos
        elseif command == 'R'
            alpha = deg2rad(360-amount)
            rotate_matrix = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)]
            waypoint_pos = rotate_matrix * waypoint_pos
        elseif command == 'L'
            alpha = deg2rad(amount)
            rotate_matrix = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)]
            waypoint_pos = rotate_matrix * waypoint_pos
        end
    end
    ship_pos
end

instructions = load_data()

println(sum(abs.(follow_instructions(instructions))))
println(sum(abs.(follow_instructions2(instructions))))