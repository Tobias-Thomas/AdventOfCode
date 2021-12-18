x_vel_range = 12:125
y_vel_range = -159:158

x_target_interval = 70:125
y_target_interval = -159:-121

x_ts_in_interval = Vector{UnitRange{Int}}()
for xv in x_vel_range
    x_vel = xv
    start_interval, end_interval = -1, -1
    step_num = 0
    x_pos = 0
    while true
        step_num += 1
        x_pos += x_vel
        if x_pos in x_target_interval && start_interval == -1
            start_interval = step_num
        elseif x_pos > last(x_target_interval)
            end_interval = step_num - 1
            break
        elseif x_vel == 0
            end_interval = 1000
            break
        end
        x_vel = max(x_vel-1, 0)
    end
    if start_interval > 0
        push!(x_ts_in_interval, start_interval:end_interval)
    end
end

y_ts_in_interval = Vector{UnitRange{Int}}()
for yv in y_vel_range
    y_vel = yv
    start_interval, end_interval = -1,-1
    step_num = 0
    y_pos = 0
    while true
        step_num += 1
        y_pos += y_vel
        if y_pos in y_target_interval && start_interval == -1
            start_interval = step_num
        elseif y_pos < first(y_target_interval)
            end_interval = step_num - 1
            break
        end
        y_vel -= 1
    end
    if start_interval > 0
        push!(y_ts_in_interval, start_interval:end_interval)
    end
end

function count_possibilities(x_intervals, y_intervals)
    sum_possibilities = 0
    for x_interval in x_intervals
        for y_interval in y_intervals
            sum_possibilities += length(intersect(x_interval, y_interval)) > 0
        end
    end
    sum_possibilities
end

println(count_possibilities(x_ts_in_interval, y_ts_in_interval))