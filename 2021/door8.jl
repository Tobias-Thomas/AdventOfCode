using Combinatorics

function parse_line(l)
    signal, output = split(l, " | ")
    signal = (split(signal, " "))
    output = (split(output, " "))
    signal, output
end

function count_unique_numbers(data_entry)
    _, output_signals = data_entry
    unique_numbers = 0
    for o in output_signals
        unique_numbers += length(o) in unique_lengths
    end
    unique_numbers
end

const unique_lengths = [2,3,4,7]
const wire_number_map = Dict(
    "abcefg" => "0",
    "cf" => "1",
    "acdeg" => "2",
    "acdfg" => "3",
    "bcdf" => "4",
    "abdfg" => "5",
    "abdefg" => "6",
    "acf" => "7",
    "abcdefg" => "8",
    "abcdfg" => "9"
)

sort_chars_in_string(s) = join(sort!(collect(s)))

correct_mapping(m, signals) = all([sort_chars_in_string([m[w] for w in s]) in keys(wire_number_map) for s in signals])

function find_wire_mapping(unique_signals)
    for p in permutations('a':'g')
        wire_mapping = Dict([(c,p[i]) for (i,c) in enumerate('a':'g')]) 
        correct_mapping(wire_mapping, unique_signals) && return wire_mapping
    end
end

function decode_output_signal(data_entry)
    unique_signals, output_signals = data_entry
    wire_map = find_wire_mapping(unique_signals)
    output_string = ""
    for o in output_signals
        o = sort_chars_in_string(join([wire_map[w] for w in o]))
        output_string *= wire_number_map[o]
    end
    parse(Int, output_string)
end

#test_unique = split("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab", " ")
#println(correct_mapping(Dict('d'=>'a', 'e'=>'b', 'a'=>'c', 'f'=>'d', 'g'=>'e', 'b'=>'f', 'c'=>'g'), test_unique))

data = parse_line.(readlines("door8_input"))
println(sum(count_unique_numbers.(data)))
println(sum(decode_output_signal.(data)))
