//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/desc_wave8.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

save "$datos/w08_resultados.dta", replace
export excel using "$datos\wave8.xlsx", replace

// etiquetas 
label define numcaj 1 "14 cigarros" 2 "20 cigarros" 3 "25 cigarros" ///
	4 "Otro" 5 "No sé"
label values q029a numcaj 

// consumo en el 'ultimo mes
ta has_fumado_1mes
ta has_fumado_1mes, nol


ta q001 if has_fumado_1mes
tab1 edad* if has_fumado_1mes

// sexo
ta sexo if has_fumado_1mes
ta identidad_genero if has_fumado_1mes

// escolaridad
tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes

// lugar
ta estados if has_fumado_1mes

// ingresos
ta ingreso_hogar if has_fumado_1mes

// consumo: selección para el análisis
// ta has_fumado_1mes 
// ta has_fumado_1mes patron, m
// cada cuándo compra?
ta patron if has_fumado_1mes, m
ta patron if has_fumado_1mes, m nol

// precio

/* cómo compra?
1- cajetilla
2- suelto
*/
// pagado por cajetillas
ta q028 if has_fumado_1mes , m
ta q028 patron if has_fumado_1mes , m
ta q028 if has_fumado_1mes & patron , m

// para los 
ta q029a if has_fumado_1mes, su(q029)
ta q029a if has_fumado_1mes, m

// precio de cigarros sueltos
su q030 if has_fumado_1mes
ta q028 patron if has_fumado_1mes, su(q030)

log close
