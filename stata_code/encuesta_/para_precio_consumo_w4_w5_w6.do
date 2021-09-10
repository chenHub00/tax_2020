//
// previos: para_precio4_5.do
set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/para_precio_consumo_w4_w5.log", replace

// MACROS
do stata_code/encuesta_/dir_encuesta.do

//use "$datos/wave4_5unbalanced.dta", replace
use "$datos/cons_w456_unbalanc.dta", replace

//merge 1:1 id wave using "$datos/cant_cigarros_w4_w5.dta", gen(merge_cons_precio)
merge 1:1 id wave using "$datos/cant_cig_caj_w4_w5_w6.dta", gen(merge_cons_precio)

ta merge_cons_precio

/* Desde consumo
177 no consumieron en el último mes 
85 dejaron de fumar o nunca han fumado  
*/
drop if merge_cons_precio != 3
drop merge_cons_precio

gen ppu = q029/cantidad_
replace ppu = precioSingles if ppu == .

label data "cantidad y precio waves 4, 5 y 6"
//"$datos/c_pw4_w5_w6unbalanc.dta"
save "$datos/cp_w456unbalanc.dta", replace


/// balanceado
use "$datos/cons_w456_balanc.dta", replace

merge 1:1 id wave using "$datos/cant_cig_caj_w4_w5_w6.dta", gen(merge_cons_precio)
ta merge_cons_precio

/* Desde consumo
177 no consumieron en el último mes 
85 dejaron de fumar o nunca han fumado  
*/
drop if merge_cons_precio != 3
drop merge_cons_precio

gen ppu = q029/cantidad_
replace ppu = precioSingles if ppu == .

label data "panel balanceado cantidad y precio waves 4, 5 y 6"
// save "$datos/c_pw4_w5_balanc.dta", replace
save "$datos/cp_w456balanc.dta", replace

log close

