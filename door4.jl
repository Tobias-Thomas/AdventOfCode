function read_data()
    data = readlines("door4_input")
    empty_indices = findall(x -> x=="", data)
    condensed_data = [strip(join(data[1:empty_indices[1]], " "))]
    from_index = empty_indices[1]
    for to_index in empty_indices[2:end]
        push!(condensed_data, strip(join(data[from_index:to_index], " ")))
        from_index = to_index
    end
    push!(condensed_data, strip(join(data[empty_indices[end]:end], " ")))
    condensed_data
end


function extract_fields(pass_info)
    info_fields = split(pass_info, " ")
    split_key_value(f) = split(f, ":")
    info_fields = split_key_value.(info_fields)
    field_keys = [f[1] for f in info_fields]
    field_values = [f[2] for f in info_fields]
    Dict(zip(field_keys, field_values))
end

function is_complete(pass_info)
    mandatory_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    pass_dict = extract_fields(pass_info)
    issubset(mandatory_fields, keys(pass_dict))
end

function is_valid(pass_info)
    if !is_complete(pass_info)
        return false
    end
    pass_dict = extract_fields(pass_info)
    valid = true
    byr = parse(Int, pass_dict["byr"])
    valid = valid && (1920 <= byr <= 2002)
    iyr = parse(Int, pass_dict["iyr"])
    valid = valid && (2010 <= iyr <= 2020)
    eyr = parse(Int, pass_dict["eyr"])
    valid = valid && (2020 <= eyr <= 2030)
    hgt = pass_dict["hgt"]
    hgt_unit = hgt[end-1:end]
    if hgt_unit == "cm"
        hgt_val = parse(Int, hgt[1:end-2])
        valid = valid && (150 <= hgt_val <= 193)
    elseif hgt_unit == "in"
        hgt_val = parse(Int, hgt[1:end-2])
        valid = valid && (59 <= hgt_val <= 76)
    else
        valid = false
    end
    hcl = pass_dict["hcl"]
    is_hex_char(c) = c in ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                           '9', 'a', 'b', 'c', 'd', 'e', 'f']
    valid = valid && startswith(hcl, "#")
    valid = valid && all(is_hex_char.(collect(hcl[2:end])))
    ecl = pass_dict["ecl"]
    valid = valid && ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    pid = pass_dict["pid"]
    valid = valid && length(pid) == 9

    return valid
end

pass_data = read_data()

println(sum(is_complete.(pass_data)))
println(sum(is_valid.(pass_data)))