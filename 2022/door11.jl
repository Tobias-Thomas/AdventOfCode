mutable struct Monkey
    items::Vector{Int}
    fn::Function
    divisor::Int
    true_monkey::Int
    false_monkey::Int
end

test_monkeys = [
    Monkey([79,98], x -> x*19, 23, 2, 3),
    Monkey([54,65,75,74], x -> x+6, 19, 2, 0),
    Monkey([79,60,97], x -> x*x, 13, 1, 3),
    Monkey([74], x -> x+3, 17, 0, 1)
]

inp_monkeys = [
    Monkey([65,78], x -> x*3, 5, 2, 3)
    Monkey([54, 78, 86, 79, 73, 64, 85, 88], x -> x+8, 11, 4, 7)
    Monkey([69, 97, 77, 88, 87], x -> x+2, 2, 5, 3)
    Monkey([99], x -> x+4, 13, 1, 5)
    Monkey([60, 57, 52], x -> x * 19, 7, 7, 6)
    Monkey([91, 82, 85, 73, 84, 53], x -> x+5, 3, 4, 1)
    Monkey([88, 74, 68, 56], x -> x*x, 17, 0, 2)
    Monkey([54, 82, 72, 71, 53, 99, 67], x -> x+1, 19, 6, 0)
]

function throw_one_turn!(monkeys, i, monkey_lcm)
    m = monkeys[i]
    no_items = length(m.items)
    for item in m.items
        new = (monkey_lcm == -1) ? (m.fn(item) ÷ 3) : (m.fn(item) % monkey_lcm)
        dest_monkey = new % m.divisor == 0 ? m.true_monkey : m.false_monkey
        push!(monkeys[dest_monkey+1].items, new)
    end
    m.items = []
    no_items
end

function throw_one_round!(monkeys, monkey_lcm)
    [throw_one_turn!(monkeys, i, monkey_lcm) for i in 1:length(monkeys)]
end

function calc_monkey_buisiness!(monkeys, turns, monkey_lcm=-1)
    sum(throw_one_round!(monkeys, monkey_lcm) for _ in 1:turns)
end

monkeys = inp_monkeys
#println(calc_monkey_buisiness!(monkeys, 20))
monkey_lcm = lcm([m.divisor for m in monkeys]...)
println(calc_monkey_buisiness!(monkeys, 10_000, monkey_lcm))