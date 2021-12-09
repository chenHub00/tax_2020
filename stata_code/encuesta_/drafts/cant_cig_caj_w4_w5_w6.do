capture log close
log using resultados/encuesta/cant_cig_caj_w4_w5_w6.log, replace

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

save "$datos/cant_cig_caj_w1aw6.dta", replace

log close
