function load_data()
    lines = readlines("door19_test")
    re = r"Blueprint \d+: Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."
    bps = [parse.(Int, match(re, l).captures) for l in lines]
    robot_costs.(bps)
end

function robot_costs(bp)
    ore_robot_costs = (bp[1],0,0,0)
    clay_robot_costs = (bp[2],0,0,0)
    obs_robot_costs = (bp[3],bp[4],0,0)
    geode_robot_costs = (bp[5],0,bp[6],0)
    geode_robot_costs, obs_robot_costs, clay_robot_costs, ore_robot_costs
end

function buy_possibilities(inventory, bp)
    Tuple(inventory .>= rc for rc in bp)
end

function optimal_no_geodes(bp, inventory, robots, t, curr_best)
    inv = inventory .+ robots
    t == 24 && return max(inventory[4], curr_best)
    for (rn,option) in enumerate(buy_possibilities(inventory, bp))
        option && continue
        inv .-= bp[rn]
    end
end

blueprints = load_data()