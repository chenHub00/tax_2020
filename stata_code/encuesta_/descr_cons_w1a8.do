
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/descr_cons_w1a8.log", replace

global v_tab "sexo edad_gr3 educ_gr3 ingr_gr patron single tipo"
// global v_tab "sexo gr_edad edad_gr3 gr_educ educ_gr3 ingr_gr patron single tipo"

// cambiar para wave 1 a 8
foreach w of numlist 1/8 {
di "Levantamiento " `w'
 /***************************************************************************/
	 // UNBALANCED
	 // cambiar para wave 1 a 8
	use "$datos/cons_w_1to8.dta", clear

	keep if wave == `w'
* prueba:
*	keep if wave == 4

	// sexo
	tab1 $v_tab if has_fumado_1mes, sum(consumo_semanal) 
}

log close

// use "$datos/cons_w_1to8.dta", clear
//
// asdoc tabstat consumo_semanal, by(sexo) stat(mean sd count) save($resultados/precios) replace
// asdoc tabstat consumo_semanal, by(edad_gr3) stat(mean sd count) save($resultados/precios) append
// asdoc tabstat consumo_semanal, by(educ_gr3) stat(mean sd count) save($resultados/precios) append
// asdoc tabstat consumo_semanal, by(ingr_gr) stat(mean sd count) save($resultados/precios) append
// asdoc tabstat consumo_semanal, by(patron) stat(mean sd count) save($resultados/precios) append
// asdoc tabstat consumo_semanal, by(single) stat(mean sd count) save($resultados/precios) append
// asdoc tabstat consumo_semanal, by(tipo) stat(mean sd count) save($resultados/precios) append


// foreach balanced_unbalanced  in unbalanc balanc {
//	local data = "$datos/c_pw4_w5_`balanced_unbalanced'.dta"
//	use "`data'", clear
	use "$datos/cons_w_1to8.dta", clear
	// use "$datos/c_pw4_w5_"`balanced_unbalanced'".dta", clear
	foreach vartab of varlist $v_tab {
//		foreach var_sum of varlist consumo_semanal {
local var_sum = "consumo_semanal"
			foreach w of numlist 1/8 {
			di "Levantamiento " `w'
			 /***************************************************************************/
				 // UNBALANCED
				 // cambiar para wave 1 a 8
			preserve 
				keep if wave == `w'
			* prueba:
			*	keep if wave == 4

				collapse (mean) consumo_semanal (sd) sd_consumo_semanal = consumo_semanal ///
					(count) N_consumo_semanal = consumo_semanal, by(`vartab')
				export excel using "$resultados/descriptivos/`var_sum'_.xlsx", ///
					sheet(`vartab'`w', modify) firstrow(variables) 

//				tab1 $v_tab if has_fumado_1mes, sum(consumo_) 
			restore
//			}
		}
	}
//}
