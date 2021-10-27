capture log close
log using resultados/encuesta/cant_cig_caj_w1_a_w8.log, replace

*do dir_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

// cantidad
// de cigarros
// por cajetilla

use "$datos/cantidades_cigarros_w1.dta", clear

append using "$datos/cantidades_cigarros_w2.dta"
append using "$datos/cantidades_cigarros_w3.dta"
append using "$datos/cantidades_cigarros_w4.dta"
append using "$datos/cantidades_cigarros_w5.dta"
append using "$datos/cantidades_cigarros_w6.dta"
append using "$datos/cantidades_cigarros_w7.dta"
append using "$datos/cantidades_cigarros_w8.dta"

merge 1:1 wave id using "$datos/cantidades_cigarros_w8_sin_inegi.dta"
rename _m merge_ppu_cuestionario


keep wave id q029 q019 marca cantidad_cigarros ppu*

save "$datos/cant_cig_caj_w1_a_w8.dta", replace

keep if wave >= 4 & wave <= 6

save "$datos/cant_cig_caj_w4_w5_w6.dta", replace


log close
