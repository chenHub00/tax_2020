// Objetivo: cómo es la distribución del ppu para w 4 y w 5?
// 
// previos: do_encuesta.do
set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "resultados/encuesta/gr_ppu_w04_w05.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code/encuesta_/"
global resultados = "resultados\encuesta\"

use "$datos/c_pw4_w5_w8_caj.dta", clear
// a partir de qué precio por cajetilla
// se observa una mayor proporción de cajetillas en cada grupo?

keep if q028 == 1
// 525 obs deleted

/*
ta precio cantidad if marca == 3, row col

ta precio cantidad if marca == 6, row col


histogram q029 if marca == 99, normal kdensity
graph save Graph "graficos\exploratorios\precio_caja_m99_w8.gph", replace
*/

graph hbox ppu, over(marca)
graph hbox ppu, over(wave) over(marca)
graph save Graph "graficos\exploratorios\box_ppu_w4_w5_w8.gph", replace

graph export "graficos\exploratorios\box_ppu_w4_w5_w8.pdf", as(pdf) replace


log close



