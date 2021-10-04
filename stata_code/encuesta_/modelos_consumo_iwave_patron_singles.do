
set more off

capture log close
log using "resultados/encuesta/modelos_cons_patron_singles.log", replace

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// lineal: comentar si logaritmos
// global mod = "cons_patron"
// global depvar "consumo_semanal"

// logaritmos: comentar si lineal
global mod = "log_cons_patron"
global depvar "log_cons_sem"

// por dia
//global depvar "cons_por_dia"
//global mod = "log_cons_patron"
//global depvar "log_cons_x_dia"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"

// impuestos
// impuestos
global vars_txc "tax2020 tax2021 " 
// interacciones
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
global v_txc_singles "tax2020#singles tax2021#singles"
global v_txc_patron "tax2020#patron tax2021#patron"
global v_covid19 "covid19#singles covid19#patron"


use "$datos/cons_w_1to8.dta", clear

foreach value of numlist 0/1 {
preserve
keep if patron == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regpatron if $seleccion
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	
//	outreg2 using "resultados/encuesta/cons_patron1", word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regpatron if $seleccion, fe
//	outreg2 using resultados/encuesta/cons_$mod`value', word excel append
outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regpatron if $seleccion, re
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

// singles
// lineal:
//global mod = "cons_singles"
// logaritmos
global mod = "log_cons_singles"


global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

foreach value of numlist 0/1 {
preserve
// only change names, variables, and outreg
keep if singles == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regsingles if $seleccion 
// second change resp "patron"
	//	outreg2 using resultados/encuesta/cons_patron`value', word excel replace
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regsingles if $seleccion, fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regsingles if $seleccion, re
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
