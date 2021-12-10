//
// previos: para_precio4_5.do
set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/para_precio_consumo_w1_a_w8.log", replace

// MACROS
do stata_code/encuesta_/0_dir_encuesta.do

//use "$datos/wave4_5unbalanced.dta", replace
use "$datos/cons_w_1to8.dta", replace

//merge 1:1 id wave using "$datos/cant_cigarros_w4_w5.dta", gen(merge_cons_precio)
merge 1:1 id wave using "$datos/cant_cig_caj_w1_a_w8.dta", gen(merge_cons_precio)

ta merge_cons_precio

/* Desde consumo
177 no consumieron en el último mes 
85 dejaron de fumar o nunca han fumado  
*/
drop if merge_cons_precio != 3
drop merge_cons_precio

gen ppu_imp = q029/cantidad_cigarros
replace ppu_imp = precioSingles if ppu_imp== .

label variable ppu_imp "ppu (corte INEGI)"

label data "cantidad y precio waves 1 a la 8"
//"$datos/c_pw4_w5_w6unbalanc.dta"

gen ppu = ppu_cuest if wave == 8
replace ppu = ppu_imp if wave <= 7
replace ppu = q030 if wave == 8 & singles == 1

// ppu
gen log_ppu = log(ppu)
label variable log_ppu "log ppu"

save "$datos/cp_w1a8.dta", replace

keep if wave == 8

save "$datos/cp_w8.dta", replace

log close

