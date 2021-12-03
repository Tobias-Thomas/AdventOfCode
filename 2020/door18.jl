expressions = readlines("door18_input")

⨦(a,b) = a * b
println(sum(l -> eval(Meta.parse(replace(l, "*" => "⨦"))), expressions))

⨱(a,b) = a + b
println(sum(l -> eval(Meta.parse(replace(replace(l, "*" => "⨦"), "+" => "⨱"))), expressions))