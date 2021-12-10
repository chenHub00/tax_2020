// NO consideramos otras marcas
//

set more off  
capture log close
log using "resultados/encuesta/para_precio_w3.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear

keep if wave == 3

do "$codigo/2_d_etiquetas_marcas.do"

keep id wave marca q019 q029 

//----------------

gen cantidad_cigarros = .

recode cantidad_cigarros . = 14 if marca == 1 & q029 <=47.5
recode cantidad_cigarros . = 20 if marca == 1 & q029 >47.5

recode cantidad_cigarros . = 14 if marca == 2 & q029 <=45.55
recode cantidad_cigarros . = 20 if marca == 2 & q029 >45.55

//recode cantidad_cigarros . = 15 if marca == 3 & q029 <=36.625
// 14 desde 15: sustituye por la siguiente
recode cantidad_cigarros . = 14 if marca == 3 & q029 <=33
//recode cantidad_cigarros . = 18 if marca == 3 & q029 <=43
// 18 queda en 20
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=43.5
// recode cantidad_cigarros . = 24 if marca == 3 & q029 <=48
recode cantidad_cigarros . = 25 if marca == 3 & q029 >48

recode cantidad_cigarros . = 20 if marca == 4 & q029 <=56
recode cantidad_cigarros . = 25 if marca == 4 & q029 >56

recode cantidad_cigarros . = 14 if marca == 5 & q029 <=54.5
recode cantidad_cigarros . = 20 if marca == 5 & q029 >54.5

recode cantidad_cigarros . = 14 if marca == 6 & q029 <=31.75
//recode cantidad_cigarros . = 15 if marca == 6 & q029 <=39.75
//recode cantidad_cigarros . = 24 if marca == 6 & q029 <=48.25
// 15 y 24 a 20:
recode cantidad_cigarros . = 20 if marca == 6 & q029 <=47.5
recode cantidad_cigarros . = 25 if marca == 6 & q029 >48.25

recode cantidad_cigarros . = 14 if marca == 7 & q029 <=41
recode cantidad_cigarros . = 20 if marca == 7 & q029 <=51.5
//recode cantidad_cigarros . = 24 if marca == 7 & q029 >55.95
// 24 a 25
recode cantidad_cigarros . = 25 if marca == 7 & q029 >51.5
	
ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 1

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 6

replace cantidad_cigarros = 20 if q019 == 8
replace cantidad_cigarros = 20 if q019 == 9
replace cantidad_cigarros = 20 if q019 == 10
replace cantidad_cigarros = 20 if q019 == 11
replace cantidad_cigarros = 20 if q019 == 12
replace cantidad_cigarros = 20 if q019 == 13
replace cantidad_cigarros = 20 if q019 == 14

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 18


// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 20
replace cantidad_cigarros = 20 if q019 == 21

replace cantidad_cigarros = 20 if q019 == 23
replace cantidad_cigarros = 20 if q019 == 24
replace cantidad_cigarros = 20 if q019 == 25
replace cantidad_cigarros = 20 if q019 == 26
replace cantidad_cigarros = 20 if q019 == 27
replace cantidad_cigarros = 20 if q019 == 28
replace cantidad_cigarros = 20 if q019 == 29

// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
recode cantidad_cigarros . = 20 if marca == 99

ta cantidad_
ta marca cantidad_, m

save "$datos/cantidades_cigarros_w3.dta", replace

log close
