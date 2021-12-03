starting_numbers = [2,0,1,9,5,19]

function play_game(s_numbers, until)
    last_indices_dict = Dict(num=>[idx, 0] for (idx, num) in enumerate(s_numbers))
    curr_num = s_numbers[end]
    for i in length(s_numbers)+1:until
        curr_num = last_indices_dict[curr_num][2]
        last_indices_dict[curr_num] = [i, i - get(last_indices_dict, curr_num, [i,0])[1]]
    end
    curr_num
end

println(play_game(starting_numbers, 2020))
println(play_game(starting_numbers, 30000000))