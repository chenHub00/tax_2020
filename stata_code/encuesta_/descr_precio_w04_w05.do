
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/descr_precio_w04_w05.log", replace

global v_tab "sexo gr_edad gr_educ gr_ingr patron single tipo"
global v_tabB "sexo edad_gr3 gr_educ gr_ingr patron single tipo"

// cambiar para wave 1 a 8
// "$datos/c_pw4_w5_balanc.dta",
// use "$datos/c_pw4_w5_unbalanc.dta", clear
// use "$datos/c_pw4_w5_unbalanc.dta", clear
// local balanced_unbalanced  = "unbalanc"

foreach balanced_unbalanced  in unbalanc balanc {
	local data = "$datos/c_pw4_w5_`balanced_unbalanced'.dta"
	use "`data'", clear
	// use "$datos/c_pw4_w5_"`balanced_unbalanced'".dta", clear
	foreach var_sum of varlist ppu consumo_semanal {
		foreach w of numlist 4 5 {
		di "Levantamiento " `w'
		 /***************************************************************************/
			 // UNBALANCED
			 // cambiar para wave 1 a 8
		preserve 
			keep if wave == `w'
		* prueba:
		*	keep if wave == 4

			// sexo
			tab1 $v_tab if has_fumado_1mes, sum(`var_sum') 
		restore
		}
	}
}

log close


capture log close
log using "$resultados/descr_precio_w04_w05_2.log", append

global v_tabA "sexo gr_edad gr_educ gr_ingr patron single tipo"
global v_tabB "sexo edad_gr3 gr_educ gr_ingr patron single tipo"
global v_tab "sexo gr_edad edad_gr3 gr_educ educ_gr3 gr_ingr patron single tipo"

// cambiar para wave 1 a 8
// "$datos/c_pw4_w5_balanc.dta",
// use "$datos/c_pw4_w5_unbalanc.dta", clear
// use "$datos/c_pw4_w5_unbalanc.dta", clear
// local balanced_unbalanced  = "unbalanc"

// collapse (mean) ppu (sd) sd_ppu = ppu (count) Nppu = ppu, by(tipo)

/* ASDOC y TABSTAT son m'as "limpios" pero las etiquetas afectan el orden y no siempre funciona */
use "$datos/c_pw4_w5_unbalanc.dta", clear

asdoc tabstat ppu, by(sexo) stat(mean sd count) save($resultados/precios) replace
asdoc tabstat ppu, by(gr_edad) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(edad_gr3) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(gr_educ) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(educ_gr3) stat(mean sd count) save($resultados/precios) append
//asdoc tabstat ppu, by(gr_ingr) stat(mean sd count) save($resultados/precios) append
/*             asdoctable():  3301  subscript invalid
                 <istmt>:     -  function returned error
r(3301);
*/
asdoc tabstat ppu, by(tipo) stat(mean sd count) save($resultados/precios) append

use "$datos/c_pw4_w5_balanc.dta", clear

asdoc tabstat ppu, by(sexo) stat(mean sd count) save($resultados/precios) replace
asdoc tabstat ppu, by(gr_edad) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(edad_gr3) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(gr_educ) stat(mean sd count) save($resultados/precios) append
asdoc tabstat ppu, by(educ_gr3) stat(mean sd count) save($resultados/precios) append
//asdoc tabstat ppu, by(gr_ingr) stat(mean sd count) save($resultados/precios) append
/*             asdoctable():  3301  subscript invalid
                 <istmt>:     -  function returned error
r(3301);
*/
asdoc tabstat ppu, by(tipo) stat(mean sd count) save($resultados/precios) append

// Para exportar los estadísticos

foreach balanced_unbalanced  in unbalanc balanc {
	local data = "$datos/c_pw4_w5_`balanced_unbalanced'.dta"
	use "`data'", clear
	// use "$datos/c_pw4_w5_"`balanced_unbalanced'".dta", clear
	foreach vartab of varlist $v_tab {
		foreach var_sum of varlist ppu consumo_semanal {
			foreach w of numlist 4 5 {
			di "Levantamiento " `w'
			 /***************************************************************************/
				 // UNBALANCED
				 // cambiar para wave 1 a 8
			preserve 
				keep if wave == `w'
			* prueba:
			*	keep if wave == 4

				collapse (mean) ppu (sd) sd_ppu = ppu (count) Nppu = ppu, by(`vartab')
				export excel using "$resultados/descriptivos/`var_sum'_`balanced_unbalanced'.xlsx", ///
					sheet(`vartab'`w', modify) firstrow(variables) 

//				tab1 $v_tab if has_fumado_1mes, sum(consumo_) 
			restore
			}
		}
	}
}
log close

/*
// C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020
putexcel set resultados\encuesta\descriptivos\descriptivos_precios.xlsx, sheet(precios, replace) modify

estpost tabstat ppu, by(tipo)
estout e(mean)

putexcel (A2) = "tipo"
putexcel (B2) = ematrices
putexcel (B1) = e(byvar) 

outreg2 using resultados\encuesta\descriptivos\test, excel

