// NO consideramos otras marcas
//

set more off  
capture log close
log using "resultados/encuesta/para_precio_w8.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear

keep if wave == 8

do "$codigo/2_d_etiquetas_marcas.do"

keep id wave marca q019 q029 

//----------------

gen cantidad_cigarros = .

recode cantidad_cigarros . = 14 if marca == 1 & q029 <=54.41
recode cantidad_cigarros . = 20 if marca == 1 & q029 >54.41

recode cantidad_cigarros . = 14 if marca == 2 & q029 <=53.5
recode cantidad_cigarros . = 20 if marca == 2 & q029 >53.5

//recode cantidad_cigarros . = 15 if marca == 3 & q029 <=46
//recode cantidad_cigarros . = 18 if marca == 3 & q029 <=54.645
// 18 queda en 20
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=51
//recode cantidad_cigarros . = 24 if marca == 3 & q029 <=51
recode cantidad_cigarros . = 25 if marca == 3 & q029 >51

recode cantidad_cigarros . = 20 if marca == 4 & q029 <=65.5
recode cantidad_cigarros . = 25 if marca == 4 & q029 >65.5

recode cantidad_cigarros . = 14 if marca == 5 & q029 <=57.845
recode cantidad_cigarros . = 20 if marca == 5 & q029 >57.845

recode cantidad_cigarros . = 14 if marca == 6 & q029 <=38
//recode cantidad_cigarros . = 15 if marca == 6 & q029 <=39.5
//recode cantidad_cigarros . = 24 if marca == 6 & q029 <=57
// 15 y 24 a 20:
recode cantidad_cigarros . = 20 if marca == 6 & q029 <=58.5
recode cantidad_cigarros . = 25 if marca == 6 & q029 >57

recode cantidad_cigarros . = 14 if marca == 7 & q029 <=42.5
recode cantidad_cigarros . = 20 if marca == 7 & q029 <=60.86
//recode cantidad_cigarros . = 24 if marca == 7 & q029 <=58.875
recode cantidad_cigarros . = 25 if marca == 7 & q029 >58.875
	
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

save "$datos/cantidades_cigarros_w8.dta", replace

log close
