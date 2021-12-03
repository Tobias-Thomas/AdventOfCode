diagnostics = readlines("door3_input")

function most_common_bit(pos, diag)
    num_ones = 0
    for info in diag
        if info[pos] == '1'
            num_ones += 1
        end
    end
    num_ones / length(diag) >= 0.5 ? '1' : '0'
end

least_common_bit(pos, diag) = most_common_bit(pos, diag) == '1' ? '0' : '1'

function find_other_ratings(diag, bit_method)
    remaining_diags = diag
    for pos in eachindex(diag[1])
        bit_criteria = bit_method(pos, remaining_diags)
        remaining_diags = filter(d -> d[pos] == bit_criteria, remaining_diags)

        if length(remaining_diags) == 1
            break
        end
    end
    parse(Int, prod(remaining_diags[1]), base=2)
end

diag_length = length(diagnostics[1])
gamma_bit_string = [most_common_bit(i, diagnostics) for i in eachindex(diagnostics[1])]
gamma_rate = parse(Int, prod(gamma_bit_string), base=2)
epsilon_rate = 2^diag_length - gamma_rate - 1
println(gamma_rate * epsilon_rate)

oxygen_rating = find_other_ratings(diagnostics, most_common_bit)
co2_rating = find_other_ratings(diagnostics, least_common_bit)
println(oxygen_rating*co2_rating)
