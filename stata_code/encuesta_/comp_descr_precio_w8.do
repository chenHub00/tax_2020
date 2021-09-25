
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"
global graficos = "graficos\exploratorios\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/comp_descr_precio_w8.log", replace

global v_tab "sexo edad_gr3 educ_gr3 ingr_gr patron single tipo"

	use "$datos/cp_w8.dta", clear
	
	keep if singles == 0
	graph box ppu_i ppu_c
	graph save "$graficos\comparacion_ppu_w8.gph", replace
	graph export "$graficos\comparacion_ppu_w8.png", as(png) replace

	
	foreach var of varlist $v_tab {
		di "Variable " "`var'"
			table `var', c(mean ppu_i mean ppu_c) 
			
			graph box ppu_i ppu_c, over(`var')
		graph save "$graficos\comparacion_ppu_w8_`var'.gph", replace
		graph export "$graficos\comparacion_ppu_w8_`var'.png", as(png) replace

	}

log close

/*
capture log close
log using "$resultados/descr_precio_w1a8.log", append

	use "$datos/cp_w1a8.dta", clear
	// use "$datos/c_pw4_w5_"`balanced_unbalanced'".dta", clear
	foreach vartab of varlist $v_tab {
//		foreach var_sum of varlist ppu {
			foreach w of numlist 1/8 {
			di "Levantamiento " `w'
			 /***************************************************************************/
				 // UNBALANCED
				 // cambiar para wave 1 a 8
			preserve 
				keep if wave == `w'
			* prueba:
			*	keep if wave == 4

				collapse (mean) ppu (sd) sd_ppu = ppu (count) Nppu = ppu, by(`vartab')
				export excel using "$resultados/descriptivos/ppu_.xlsx", ///
					sheet(`vartab'`w', modify) firstrow(variables) 

//				tab1 $v_tab if has_fumado_1mes, sum(consumo_) 
			restore
			}
//		}
	}
//}
log close

