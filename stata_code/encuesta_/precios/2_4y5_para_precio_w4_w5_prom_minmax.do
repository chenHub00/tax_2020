// NO consideramos otras marcas
//

set more off  
capture log close
log using "resultados/encuesta/para_precio_w4_w5_prom_minmax.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear

keep if wave == 5

do "$codigo/2_d_etiquetas_marcas.do"

keep id wave marca q019 q029


gen cantidad_cigarros = .
// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 1

// Benson
*hist q029 if marca == 1

// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS entre min y max de cada categoria
recode cantidad_cigarros . = 14 if marca == 1 & q029 <=51
recode cantidad_cigarros . = 20 if marca == 1 & q029 >51

ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 3

//Camel
*hist q029 if marca == 2
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 14 if marca == 2 & q029 <=50.5
recode cantidad_cigarros . = 20 if marca == 2 & q029 >50.5

ta cantidad_
ta marca cantidad_, m

//Chesterfield
*hist q029 if marca == 3
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 14 if marca == 3 & q029 <=42.64
// recode cantidad_cigarros . = 18 if marca == 3 & q029 <=50.75
// solo 3 categorias
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=55
// 18, 24 a 20
//recode cantidad_cigarros . = 24 if marca == 3 & q029 <=55
// solo 3 categorias
recode cantidad_cigarros . = 25 if marca == 3 & q029 >55

ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 6

replace cantidad_cigarros = 20 if q019 == 8
replace cantidad_cigarros = 20 if q019 == 9
replace cantidad_cigarros = 20 if q019 == 10
replace cantidad_cigarros = 20 if q019 == 11
replace cantidad_cigarros = 20 if q019 == 12
replace cantidad_cigarros = 20 if q019 == 13
replace cantidad_cigarros = 20 if q019 == 14

//Lucky Strike
*hist q029 if marca == 4
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 20 if marca == 4 & q029 <=56.618
recode cantidad_cigarros . = 25 if marca == 4 & q029 >56.618

ta cantidad_
ta marca cantidad_, m

//Marlboro
*hist q029 if marca == 5
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 14 if marca == 5 & q029 <=54.25
recode cantidad_cigarros . = 20 if marca == 5 & q029 >54.25

ta cantidad_
ta marca cantidad_, m

//Montana
*hist q029 if marca == 6
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 14 if marca == 6 & q029 <=37
// recode cantidad_cigarros . = 15 if marca == 6 & q029 <=46
recode cantidad_cigarros . = 20 if marca == 6 & q029 <=54
// solo 3 presentaciones se consideran
recode cantidad_cigarros . = 25 if marca == 6 & q029 >54

ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 18

//Pall Mall
*hist q029 if marca == 7
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
recode cantidad_cigarros . = 14 if marca == 7 & q029 <=47.5
recode cantidad_cigarros . = 20 if marca == 7 & q029 <=55.95
recode cantidad_cigarros . = 25 if marca == 7 & q029 >55.95

ta cantidad_
ta marca cantidad_, m

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

save "$datos/cantidades_cigarros_w5.dta", replace

// WAVE 4
*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear
keep if wave == 4

do "$codigo/2_d_etiquetas_marcas.do"

keep id wave marca q019 q029 

//----------------
gen cantidad_cigarros = .
// Benson a Pall Mall
recode cantidad_cigarros . = 14 if marca == 1 & q029 <=48.5
recode cantidad_cigarros . = 20 if marca == 1 & q029 >48.5

recode cantidad_cigarros . = 14 if marca == 2 & q029 <=46.05
recode cantidad_cigarros . = 20 if marca == 2 & q029 >46.05

recode cantidad_cigarros . = 14 if marca == 3 & q029 <=30.5
// recode cantidad_cigarros . = 15 if marca == 3 & q029 <=38
//recode cantidad_cigarros . = 18 if marca == 3 & q029 <=45.5
// 15, 18, 24 a 20
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=49
// recode cantidad_cigarros . = 24 if marca == 3 & q029 <=49
// solo 3 categorias
recode cantidad_cigarros . = 25 if marca == 3 & q029 >49

recode cantidad_cigarros . = 20 if marca == 4 & q029 <=57.5
recode cantidad_cigarros . = 25 if marca == 4 & q029 >57.5

recode cantidad_cigarros . = 14 if marca == 5 & q029 <=55
recode cantidad_cigarros . = 20 if marca == 5 & q029 >55

recode cantidad_cigarros . = 14 if marca == 6 & q029 <=32.5
// 15 a 20, solo 3 categorias
// recode cantidad_cigarros . = 15 if marca == 6 & q029 <=40
recode cantidad_cigarros . = 20 if marca == 6 & q029 <=49
// 24 a 20, solo 3 categorias
// recode cantidad_cigarros . = 24 if marca == 6 & q029 <=49
recode cantidad_cigarros . = 25 if marca == 6 & q029 >49

recode cantidad_cigarros . = 14 if marca == 7 & q029 <=42
recode cantidad_cigarros . = 20 if marca == 7 & q029 <=53
recode cantidad_cigarros . = 25 if marca == 7 & q029 >53

ta cantidad_
ta marca cantidad_, m

/* OTROS */
replace cantidad_cigarros = 20 if q019 == 1

replace cantidad_cigarros = 20 if q019 == 3

replace cantidad_cigarros = 20 if q019 == 6

replace cantidad_cigarros = 20 if q019 == 8
replace cantidad_cigarros = 20 if q019 == 9
replace cantidad_cigarros = 20 if q019 == 10
replace cantidad_cigarros = 20 if q019 == 11
replace cantidad_cigarros = 20 if q019 == 12
replace cantidad_cigarros = 20 if q019 == 13
replace cantidad_cigarros = 20 if q019 == 14

replace cantidad_cigarros = 20 if q019 == 18

replace cantidad_cigarros = 20 if q019 == 20
replace cantidad_cigarros = 20 if q019 == 21

replace cantidad_cigarros = 20 if q019 == 23
replace cantidad_cigarros = 20 if q019 == 24
replace cantidad_cigarros = 20 if q019 == 25
replace cantidad_cigarros = 20 if q019 == 26
replace cantidad_cigarros = 20 if q019 == 27
replace cantidad_cigarros = 20 if q019 == 28
replace cantidad_cigarros = 20 if q019 == 29

ta cantidad_
ta marca cantidad_, m

// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
recode cantidad_cigarros . = 20 if marca == 99

ta cantidad_
ta marca cantidad_, m

save "$datos/cantidades_cigarros_w4.dta", replace

log close
