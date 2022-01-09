const char_light = Dict('.'=>false, '#'=>true)
const NUM_ENHANCEMENTS = 50

parse_line(l) = [char_light[c] for c in l]

function load_data(input_file)
    data = readlines(input_file)
    mapping = parse_line(data[1])
    im_width = length(data[3])
    img = zeros(Bool, (im_width+2*(1+NUM_ENHANCEMENTS),im_width+2*(1+NUM_ENHANCEMENTS)))
    for (i,l) in enumerate(data[3:end])
        img[i+NUM_ENHANCEMENTS+1, NUM_ENHANCEMENTS+2:end-(NUM_ENHANCEMENTS+1)] = parse_line(l)
    end
    mapping, img
end

function fill_border!(img, to_fill)
    img[1, :] .= to_fill
    img[end, :] .= to_fill
    img[:, 1] .= to_fill
    img[:, end] .= to_fill
end

function enhancement(img, mapping)
    new_img = zeros(Bool, size(img))
    for x in 2:size(img, 2)-1, y in 2:size(img, 1)-1
        neighborhood = img[y-1:y+1, x-1:x+1]
        new_pix = mapping[sum([2^(9-i)*neighborhood'[i] for i in eachindex(neighborhood)])+1]
        new_img[y,x] = new_pix
    end
    new_img
end

function all_enhancements(img, mapping)
    for i in 1:NUM_ENHANCEMENTS
        img = enhancement(img, mapping)
        fill_border!(img, mapping[i%2 == 1 ? 1 : end])
        i == 2 && println(sum(img))
    end
    println(sum(img))
end

mapping, img = load_data("2021/door20_input")
all_enhancements(img, mapping)
