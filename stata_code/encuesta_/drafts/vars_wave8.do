

gen n_cig_caj = .
replace n_cig_caj  = 14 if q029a == 1 & q028 == 1
replace n_cig_caj  = 20 if q029a == 2 & q028 == 1
replace n_cig_caj  = 25 if q029a == 3 & q028 == 1

// precio por cigarro
gen ppc_caj = q029/n_cig_caj
