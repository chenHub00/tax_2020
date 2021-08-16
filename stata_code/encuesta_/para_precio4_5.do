// NO consideramos otras marcas

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/para_precio4_5.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

do "$codigo/etiquetas_marcas.do"

drop if q029a > 3

// Benson
ta q029a if marca == 1
proportion q029a if marca == 1
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
     q029a:  q029a:  q029a:
         1       2       3
y1  .11875   .8125  .06875

*/

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 5

do "$codigo/etiquetas_marcas.do"


// Benson
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 1, percentiles(12 93)

return list
/*
scalars:

                 r(r1) =  50
                 r(r2) =  90
*/

gen cantidad_cigarros = .
replace cantidad_cigarros = 14 if q019 == 2 & q029 <=50
replace cantidad_cigarros = 20 if q019 == 2 & q029 >50 & q029 <=90
replace cantidad_cigarros = 25 if q019 == 2 & q029 >90

ta cantidad_
//
_pctile q029 if marca == 2, percentiles()

return list
/*

scalars:
                 r(r1) =  47
                 r(r2) =  80

*/
replace cantidad_cigarros = 14 if marca == 2 & q029 <=47
replace cantidad_cigarros = 20 if marca == 2 & q029 >47 & q029 <=80
replace cantidad_cigarros = 25 if marca == 2 & q029 >80


save "$datos/cantidades_cigarros_w5.dta", clear

//
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 4

do "$codigo/etiquetas_marcas.do"

// Benson
sum q029 if marca == 1, d
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 1, percentiles p(12 93)


pctile pc_q029_1 = q029 if marca == 1, genp(pc_precio_1) nq

return list
/*
scalars:
                 r(r1) =  48
                 r(r2) =  90
*/

gen cantidad_cigarros = .
replace cantidad_cigarros = 14 if marca == 1 & q029 <=48
replace cantidad_cigarros = 20 if marca == 1 & q029 >48 & q029 <=90
replace cantidad_cigarros = 25 if marca == 1 & q029 >90


keep id wave cantidad_cigarros marca q019 


save "$datos/cantidades_cigarros_w4.dta", clear
