using DataStructures

struct Food
    ingredients::Set{String}
    allergenes::Set{String}
end

function load_data()
    food_lines = readlines("door21_input")
    foods = Array{Food, 1}()
    for f in food_lines
        ingredients, allergenes = split(f, " (contains ")
        allergenes = allergenes[1:end-1]
        ingredient_set = Set(split(ingredients, " "))
        allergene_set = Set(split(allergenes, ", "))
        push!(foods, Food(ingredient_set, allergene_set))
    end
    foods
end

function create_allergene_dict(foods::Array{Food, 1})
    allergene_dict = DefaultDict{String, Array{Food, 1}}(Array{Food, 1})
    for f in foods
        for a in f.allergenes
            push!(allergene_dict[a], f)
        end
    end
    allergene_dict
end

function remove_ingredient_from_foods!(allergene_ingredient, foods)
    for food in foods
        pop!(food.ingredients, allergene_ingredient, nothing)
    end
end

function count_non_allergene_ingredients!(foods, allergene_dict)
    allergic_ingredients = Array{Tuple{String, String}, 1}()
    while length(allergene_dict) > 0
        for (allergene, allergene_foods) in allergene_dict
            poss_ingredients = intersect([f.ingredients for f in allergene_foods]...)
            if length(poss_ingredients) == 1
                pop!(allergene_dict, allergene)
                allergene_ingredient = first(poss_ingredients)
                push!(allergic_ingredients, (allergene, allergene_ingredient))
                remove_ingredient_from_foods!(allergene_ingredient, foods)
            end
        end
    end
    sum([length(f.ingredients) for f in foods]), allergic_ingredients
end

foods = load_data()
allergene_dict = create_allergene_dict(foods)
count_non_allergic, allergic_list = count_non_allergene_ingredients!(foods, allergene_dict)
println(count_non_allergic)
println(join([t[2] for t in sort(allergic_list, by=t -> t[1])], ","))