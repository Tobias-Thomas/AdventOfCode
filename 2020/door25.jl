public_a = 5099500
public_b = 7648211
#public_a = 5764801
#public_b = 17807724

const modulo = 20201227

function transform(n, ls)
    val = 1
    for _ in 1:ls
        val = mod(val*n, modulo)
    end
    val
end

function solve_encryption_key(public_a, public_b, generator=7)
    val = 1
    ls = 0
    while true
        ls += 1
        val = mod(val*generator, modulo)
        if val == public_a
            return transform(public_b, ls)
        elseif val == public_b
            return transform(public_a, ls)
        end
    end
end

solve_encryption_key(public_a, public_b)