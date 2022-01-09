struct Scanner
    id::Int
    name::String
    beacons::Array{Int, 2}
end

const RX = [
    1 0 0;
    0 0 -1;
    0 1 0
]
const RY = [
    0 0 1;
    0 1 0;
    -1 0 0
]
const RZ = [
    0 -1 0;
    1 0 0;
    0 0 1
]
using LinearAlgebra
for R in [RX, RY, RZ]
    @assert R' == inv(R)
    @assert det(R) == 1
end

const ROTATIONS = [
    RX^0, RX, RX^2, RX^3, 
    RY, RY*RX, RY*RX^2, RY*RX^3, 
    RY^2, RY^2*RX, RY^2*RX^2, RY^2*RX^3, 
    RY^3, RY^3*RX, RY^3*RX^2, RY^3*RX^3, 
    RZ, RZ*RX, RZ*RX^2, RZ*RX^3, 
    RZ^3, RZ^3*RX, RZ^3*RX^2, RZ^3*RX^3, 
]

function load_data(file)
    data = readlines(file)
    beacon_breakpoints = findall(==(""), data)
    scanners = Vector{Scanner}()
    for (i,(s,e)) in enumerate(zip(beacon_breakpoints[1:end-1], beacon_breakpoints[2:end]))
        beacon_matrix = zeros(Int, (3,(e-s-2)))
        for (i,b) in enumerate(data[s+2:e-1])
            beacon_matrix[:, i] = parse.(Int, split(b, ","))
        end
        push!(scanners, Scanner(i, data[s+1], beacon_matrix))
    end
    return scanners
end

function align(s1::Scanner, s2::Scanner)
    @assert all(x -> abs(x)<=1000, s1.beacons)
    @assert all(x -> abs(x)<=1000, s2.beacons)
    translation, overlap_counter = 0, 0
    for b1 in eachcol(s1.beacons)
        for r in ROTATIONS
            rotated_s2_beacons = r * s2.beacons
            for rb2 in eachcol(rotated_s2_beacons)
                translation = b1 - rb2
                rot_trans_s2_beacons = rotated_s2_beacons .+ translation
                overlap_counter = 0
                for rtb2 in eachcol(rot_trans_s2_beacons)
                    any(x -> abs(x)>1000, rtb2) && continue
                    if (rtb2 in eachcol(s1.beacons))
                        overlap_counter += 1
                    else
                        overlap_counter = 0
                        break
                    end
                end
                #println(overlap_counter)
                if overlap_counter >= 12
                    return [r translation; 0 0 0 1]
                end
            end
        end
    end
    return nothing
end

function align(scanners::Vector{Scanner})
    already_aligned = [scanners[1]]
    shifts = Vector{Matrix{Int}}(undef, length(scanners))
    shifts[1] = Matrix(I, 4, 4) * 1
    to_align = scanners[2:end]
    test_aligned = Set{Tuple{String,String}}()
    while length(to_align) > 0
        new_aligned = Vector{Scanner}()
        for s1 in already_aligned
            for s2 in to_align
                ((s1.name,s2.name) in test_aligned || s2 in new_aligned) && continue
                push!(test_aligned, (s1.name,s2.name))
                shift_matrix = align(s1,s2)
                if !isnothing(shift_matrix)
                    push!(new_aligned, s2)
                    s1_shift_matrix = shifts[s1.id]
                    shifts[s2.id] =  s1_shift_matrix * shift_matrix 
                end
            end
        end
        @assert length(new_aligned) > 0
        push!(already_aligned, new_aligned...)
        to_align = [s for s in to_align if !(s in new_aligned)]
    end
    shifts
end

function unique_beacons(scanners, shifts)
    beacons = Set{Vector{Int}}()
    for (scan, shift) in zip(scanners, shifts)
        r = shift[1:3, 1:3]
        t = shift[1:3, 4]
        corrected_beacons = (r * scan.beacons) .+ t
        for b in eachcol(corrected_beacons)
            push!(beacons, b)
        end
    end
    beacons
end

manhattan(v1, v2) = sum(abs.(v1 - v2))

function largest_distance_scanners(shifts)
    scanner_positions = [shift[1:3, 4] for shift in shifts]
    maximum(manhattan(p1,p2) for p1 in scanner_positions, p2 in scanner_positions)
end


scanners = load_data("2021/door19_input")
shifts = align(scanners)
beacons = unique_beacons(scanners, shifts)
println(length(beacons))
println(largest_distance_scanners(shifts))