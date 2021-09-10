capture log close
log using resultados/encuesta/cant_cig_caj_w4_w5_w6.log, replace

*do dir_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

// cantidad
// de cigarros
// por cajetilla

use "$datos/cantidades_cigarros_w4.dta", clear

append using "$datos/cantidades_cigarros_w5.dta"

append using "$datos/cantidades_cigarros_w6.dta"

save "$datos/cant_cig_caj_w4_w5_w6.dta", replace

log close