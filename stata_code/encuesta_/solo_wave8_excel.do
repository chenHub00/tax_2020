//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta_\"

cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/desc_wave8.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

save "$datos/w08_resultados.dta", replace
export excel using "$datos\wave8.xlsx"

ta q001
tab1 edad*

ta sexo
ta identidad_genero

tab1 escolaridad educ_3catr educ_9cat

ta estados

// consumo
ta has_fumado_1mes
ta has_fumado_1mes patron, m

// precio

/*
1- cajetilla
2- suelto
*/

ta q028, m

label define numcaj 1 "14 cigarros" 2 "20 cigarros" 3 "25 cigarros" ///
	4 "Otro" 5 "No sé"
label values q029a numcaj 

ta q029a, su(q029)
ta q029a, m


su q030

log close
