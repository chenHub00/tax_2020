
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/descr_w04_w05.log", replace

global v_tab "sexo edad_gr2 educ_gr2 gr_ingr patron single tipo"

// cambiar para wave 1 a 8
foreach w of numlist 4 5 {
di "Levantamiento" `w'
 /***************************************************************************/
	 // UNBALANCED
	 // cambiar para wave 1 a 8
	use "$datos/wave4_5unbalanced.dta", clear

	keep if wave == `w'
* prueba:
*	keep if wave == 4

	// sexo
	tab1 $v_tab if has_fumado_1mes, sum(consumo_semanal) 
}

log close

