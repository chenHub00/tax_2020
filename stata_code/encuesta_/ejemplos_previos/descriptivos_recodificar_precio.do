
// for each wave 1/8
// for each marca 1/8
hist q029 if wave == 1 & marca == 1

// Calculo inicial: 2021junio09
// max_20 : corte de 20 piezas por cajetilla
scalar max_20 = 100
gen precioCigarroCajetilla = q029/20 if q029 < max_20
label variable precioCigarroCajetilla "precio por cigarro"

// a partir del análisis de precios de inpc
// descriptivos_wave_precio_inpc.do
gen pzas0 = .
recode pzas0 . = 14 if q029 <= 100 & wave == 1 & marca == 1
recode pzas0 14 = 20 if q029 >=  45.5 & q029 <= 100  & wave == 1 & marca == 1

ta wave if marca  == 1
// 169
ta wave pzas0 if marca  == 1
// 134
//
ta wave if q029 > 100 & marca == 1
//  34

recode pzas0 . = 14 if q029 <= 100 & wave == 2 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 3 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 4 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 5 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 6 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 7 & marca == 1
recode pzas0 . = 14 if q029 <= 100 & wave == 8 & marca == 1

recode pzas0 14 = 20 if q029 >=  45.5 & q029 <= 100 & marca == 1 & wave == 1
recode pzas0 14 = 20 if q029 >=  46.5 & q029 <= 100 & marca == 1 & wave == 2
recode pzas0 14 = 20 if q029 >=  47.5 & q029 <= 100 & marca == 1 & wave == 3
recode pzas0 14 = 20 if q029 >=  48.5 & q029 <= 100 & marca == 1 & wave == 4
recode pzas0 14 = 20 if q029 >=  51 & q029 <= 100 & marca == 1 & wave == 5
recode pzas0 14 = 20 if q029 >=  51 & q029 <= 100 & marca == 1 & wave == 6
recode pzas0 14 = 20 if q029 >=  51 & q029 <= 100 & marca == 1 & wave == 7
recode pzas0 14 = 20 if q029 >=  54.41 & q029 <= 100 & marca == 1 & wave == 8

//gen precioCigarro


// grupo de marcas principales
