// Para otras marcas se dej'o el valor en 
// 
set more off  

global resultados = "resultados\encuesta\"

capture log close
log using "$resultados/para_precio_w8.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

*cd "C:\Users\danny\Desktop\Cohorte de fumadores\"

*use "91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear

keep if wave == 8

do "$codigo/2_d_etiquetas_marcas.do"

// solo cantidades 14, 20 y 25
// no considera compras de cigarro suelto
drop if q029a > 3
// 341 obs deleted
drop if has_ == 0
// 38 obs deleted

gen cantidad_cajetilla = q029a
gen precio_cajetilla = q029
gen ppu_ = q029/14 if q029a == 1 
replace ppu = q029/20 if q029a == 2
replace ppu = q029/25 if q029a == 3

// a partir de qué precio por cajetilla
// se observa una mayor proporción de cajetillas en cada grupo?

// tablas para cantidad
ta precio cantidad if marca == 3, row col

ta precio cantidad if marca == 6, row col

// histogramas de cantidad por marca
* histogram q029 if marca == 99, normal kdensity
//graph save Graph "graficos\exploratorios\precio_caja_m99_w8.gph", replace

// todas las proporciones
proportion q029a, over(marca)
// para Chesterfield 25 es muy alto, pero 20 no es tanto
// para Montana 20 es muy bajo, 25 llega a 50 %, 14 también es alto
matrix prop_cant_caj_marca = r(table)

rename ppu ppu_cuest
label variable ppu_cuest "obtenido desde el cuestionario"

keep id wave cantidad_cajetilla precio_cajetilla ppu_cuest

save "$datos/cantidades_cigarros_w8_sin_inegi.dta", replace

// // 
// use "$datos/c_pw4_w5_unbalanc.dta", clear
//
// drop if has_ == 0
// keep if q028 == 1
// //(525 observations deleted)
//
// append using "$datos/cantidades_cigarros_w8.dta"
//
// save "$datos/c_pw4_w5_w8_caj.dta", replace

log close
