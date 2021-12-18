hexstring = readline("2021/door16_input")
bit_str = prod([bitstring(parse(UInt8, c, base=16))[5:end] for c in hexstring])

struct Packet
    version::Int
    type::Int
    content::Union{Vector{Packet},Int}
end

function interpret_number(bs, start_index)
    idx = start_index
    number_string = ""
    while bs[idx] == '1'
        number_string *= bs[idx+1:idx+4]
        idx += 5
    end
    number_string *= bs[idx+1:idx+4]
    parse(Int, number_string, base=2), idx+5
end

function sum_version_numbers(p::Packet)
    version_count = p.version
    if typeof(p.content) == Vector{Packet}
        for subpacket in p.content
            version_count += sum_version_numbers(subpacket)
        end
    end
    version_count
end

type_functions = [
    sum,
    prod,
    minimum,
    maximum,
    nothing,
    s -> s[1] > s[2],
    s -> s[1] < s[2],
    s -> s[1] == s[2]
]

function parse_packet_tree(p::Packet)
    if p.type == 4
        return p.content
    else
        return type_functions[p.type+1](parse_packet_tree.(p.content))
    end
end

function parse_bitstring(bs, start_index)
    version = parse(Int, bs[start_index:start_index+2], base=2)
    type = parse(Int, bs[start_index+3:start_index+5], base=2)
    if type == 4
        number, idx = interpret_number(bs, start_index+6)
        return Packet(version, type, number), idx
    else
        length_type_id = bs[start_index+6]
        if length_type_id == '0'
            total_length = parse(Int, bs[start_index+7:start_index+21], base=2)
            subpackets = Vector{Packet}()
            idx = start_index+22
            while idx < start_index + 22 + total_length
                p, idx = parse_bitstring(bs, idx)
                push!(subpackets, p)
            end
            return Packet(version, type, subpackets), idx
        else
            total_count = parse(Int, bs[start_index+7:start_index+17], base=2)
            subpackets = Vector{Packet}()
            idx = start_index+18
            sub_packet_count = 0
            while sub_packet_count < total_count
                p, idx = parse_bitstring(bs, idx)
                push!(subpackets, p)
                sub_packet_count += 1
            end
            return Packet(version, type, subpackets), idx
        end
    end
end
packet_tree = parse_bitstring(bit_str, 1)[1]
println(sum_version_numbers(packet_tree))
println(parse_packet_tree(packet_tree))
