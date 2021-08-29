
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/para_precio_consumo_w4_w5.log", replace

use "$datos/wave4_5unbalanced.dta", replace

merge 1:1 id wave using "$datos/cant_cigarros_w4_w5.dta", gen(merge_cons_precio)
ta merge_cons_precio

/* Desde consumo
177 no consumieron en el último mes 
85 dejaron de fumar o nunca han fumado  
*/
drop if merge_cons_precio != 3
drop merge_cons_precio

gen ppu = q029/cantidad_
replace ppu = precioSingles if ppu == .

save "$datos/c_pw4_w5_unbalanc.dta", replace

/// balanceado
use "$datos/wave4_5balanc.dta", replace

merge 1:1 id wave using "$datos/cant_cigarros_w4_w5.dta", gen(merge_cons_precio)
ta merge_cons_precio

/* Desde consumo
177 no consumieron en el último mes 
85 dejaron de fumar o nunca han fumado  
*/
drop if merge_cons_precio != 3
drop merge_cons_precio

gen ppu = q029/cantidad_
replace ppu = precioSingles if ppu == .

save "$datos/c_pw4_w5_balanc.dta", replace

log close

