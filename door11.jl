load_data() = hcat(collect.(readlines("door11_input"))...)

function simulate_one_step_neighborhood(seats)
    next_seats = similar(seats)
    indices = CartesianIndices(seats)
    i_first, i_last = first(indices), last(indices)
    neighbors = CartesianIndex(1,1)
    for i in indices
        neighborhood = seats[max(i_first, i-neighbors): min(i_last, i+neighbors)]
        if seats[i] == 'L' && (count(==('#'), neighborhood) == 0)
            next_seats[i] = '#'
        elseif seats[i] == '#' && count(==('#'), neighborhood) > 4
            next_seats[i] = 'L'
        else
            next_seats[i] = seats[i]
        end
    end
    next_seats
end

function simulate_one_step_closest_seats(seats)
    next_seats = similar(seats)
    directions = CartesianIndex.([(-1, -1), (0, -1), (1, -1), (-1, 0),
                                  (1, 0), (-1, 1), (0, 1), (1, 1)])
    indices = CartesianIndices(seats)
    for i in indices
        if seats[i] == '.'
            next_seats[i] = '.'
        end
        occupied_in_sight = 0
        for d in directions
            sight = i + d
            while sight in indices
                if seats[sight] == '.'
                    sight += d
                elseif seats[sight] == '#'
                    occupied_in_sight += 1
                    break
                else
                    break
                end
            end
        end

        if seats[i] == 'L' && occupied_in_sight == 0
            next_seats[i] = '#'
        elseif seats[i] == '#' && occupied_in_sight >= 5
            next_seats[i] = 'L'
        else
            next_seats[i] = seats[i]
        end
    end
    next_seats
end 

function simulate_until_conversion(seats, next_f)
    curr_seats = seats
    i = 0
    while true
        i += 1
        next_seats = next_f(curr_seats)
        if curr_seats == next_seats
            return count(==('#'), curr_seats)
        end
        curr_seats = next_seats
    end
end

seats = load_data()
println(simulate_until_conversion(seats, simulate_one_step_neighborhood))
println(simulate_until_conversion(seats, simulate_one_step_closest_seats))