
set more off

capture log close
log using "resultados/encuesta/modelos_cons_singles.log", replace

do stata_code/encuesta_/dir_encuesta.do

//global mod = "w1a8_patron"
//global mod = "w1a8_singles"
//global depvar "cons_por_dia"
global mod = "log_cons_patron"
global depvar "log_cons_x_dia"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
global vars_txc "tax2020 tax2021 covid19" 
// interacciones
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
global v_txc_singles "tax2020#singles tax2021#singles"
global v_txc_patron "tax2020#patron tax2021#patron"
global v_covid19 "covid19#singles covid19#patron"

use "$datos/cons_w_1to8.dta", clear

foreach value of numlist 0/1 {
preserve
// only change names, variables, and outreg
keep if singles == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regsingles  
// second change resp "patron"
	//	outreg2 using resultados/encuesta/cons_patron`value', word excel replace
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regsingles , fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regsingles , re
	outreg2 using resultados/encuesta/$mod`value', word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios
	
restore
}
log close
