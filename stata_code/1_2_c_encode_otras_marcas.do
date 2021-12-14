*** 
* renumerar para incluir otras marcas
rename marca2 marca2_str
encode marca2_str, gen(marca2)
* empezar en el 12
gen marca = marca2
replace marca2 = marca2 + 11
label drop marca2

replace marca = marca + 8
