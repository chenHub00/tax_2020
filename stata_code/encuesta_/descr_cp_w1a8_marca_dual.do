
// previos: do_encuesta.do
set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "resultados\encuesta\/descr_cp_w1a8_marca_dual.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"


global v_tab "sexo edad_gr3 educ_gr3 ingr_gr patron single tipo"
// global v_tab "sexo gr_edad edad_gr3 gr_educ educ_gr3 ingr_gr patron single tipo"

//*--------------------------------------->>>>>>>>>>>>>>>>>>>>>>>
// para consumo
use "$datos/cons_w_1to8.dta", clear
//
*local var_sum "cons_por_dia"
*local var_sum "consumo_semanal"
foreach var_sum of varlist consumo_semanal cons_por_dia {
	foreach vartab of varlist $v_tab {
		di "Levantamiento " `vartab'

	preserve 
		keep if dual_use == 1
				collapse (mean) mean_`var_sum' =`var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' wave ) 
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_dual1.xlsx", ///
					sheet(`vartab', modify) firstrow(variables)  

	restore
	
	preserve 
		keep if dual_use == 0
				collapse (mean) mean_`var_sum' =`var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' wave )
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_dual0.xlsx", ///
					sheet(`vartab', modify) firstrow(variables) 

	restore
}
}

//*--------------------------------------->>>>>>>>>>>>>>>>>>>>>>>
// para precio
use "$datos/cp_w1a8.dta", clear
local var_sum "ppu"


	foreach vartab of varlist $v_tab {
		di "variable " "`vartab'"

	preserve 
		keep if dual_use == 1
				collapse (mean) mean_`var_sum' =`var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' wave )
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_dual1.xlsx", ///
					sheet(`vartab', modify) firstrow(variables) 

	restore
	
	preserve 
		keep if dual_use == 0
				collapse (mean) mean_`var_sum' =`var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' wave )
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_dual0.xlsx", ///
					sheet(`vartab', modify) firstrow(variables) 

	restore
}

/***************************************************************************
** RESULTADOS CON TODAS LAS WAVES EN UNA MISMA HOJA
	// use "$datos/c_pw4_w5_"`balanced_unbalanced'".dta", clear
	foreach vartab of varlist $v_tab {
		di "variable " "`vartab'"

	preserve 
		keep if dual_use == 1
				collapse (mean) mean_`var_sum' =`var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' marca wave )
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_marca_dual1.xlsx", ///
					sheet(`vartab', modify) firstrow(variables) 

	restore
	
	preserve 
		keep if dual_use == 0
				collapse (mean) mean_`var_sum' = `var_sum' (sd) sd_  = `var_sum' ///
					(count) N_ = `var_sum', by(`vartab' marca wave )
				sort wave `vartab'
				export excel using "$resultados/descriptivos/`var_sum'_marca_dual0.xlsx", ///
					sheet(`vartab', modify) firstrow(variables) 

	restore
}


