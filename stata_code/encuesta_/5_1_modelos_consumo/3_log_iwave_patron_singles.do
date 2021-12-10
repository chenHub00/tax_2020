* depvar: consumo 
* transformaciones: log, ninguna
* submuestras: patron = 1/0, singles= 1/0
* tablas de datos: wave 1 a 8, balanceado 4 al 6

set more off

// CHANGES FOR FULL SAMPLE
*global mod = "modelos_cons_patron_singles"
* log:
global mod = "log_modelos_cons_patron_singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global mod = "mods_cons_balanc_iwave_patron_singles"
* log:
*global mod = "log_cons_sem_balanc_iwave_patron_singles"

capture log close
log using "resultados/encuesta/$mod.log", replace

do stata_code/encuesta_/0_dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

* modelo en niveles o lineal:
*global depvar "consumo_semanal"
// logaritmos: comentar si lineal
global depvar "log_cons_sem"

// por dia
//global depvar "cons_por_dia"
//global depvar "log_cons_x_dia"
//global modx = "log_cons_patron"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

// // impuestos
 global vars_txc "tax2020 tax2021 " 
// // interacciones
*global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
*global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
*global v_covid19 "covid19#singles covid19#patron"

// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
// impuestos
*global vars_txc "tax2020  " 
// interacciones
*global v_txc_singles "tax2020#singles "
*global v_txc_patron "tax2020#patron "

// CHANGES FOR FULL SAMPLE
// lineal: comentar si logaritmos
// global modx = "cons_patron"
global modx = "log_cons_patron"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global modx = "balanc_patron"
*global modx = "balanc_log_cons_patron"

// CHANGES FOR FULL SAMPLE
use "$datos/cons_w_1to8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*use "$datos/cons_w456_balanc.dta", replace

global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"

foreach value of numlist 0/1 {
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$depvar$modx`value', word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regpatron if $seleccion, fe
//	outreg2 using resultados/encuesta/cons_$mod`value', word excel append
outreg2 using resultados/encuesta/$depvar$modx`value', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value', re
	outreg2 using resultados/encuesta/$depvar$modx`value', word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios
	
}


// singles ***********------------------------------

// CHANGES FOR FULL SAMPLE
// // lineal: comentar si logaritmos
//global modx = "cons_singles"
// logaritmos
*global modx = "log_cons_singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
global modx = "balanc_cons_singles"
*global modx = "balanc_log_cons_singles"

global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

foreach value of numlist 0/1 {
// only change names, variables, and outreg
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
// second change resp "patron"
	//	outreg2 using resultados/encuesta/cons_patron`value', word excel replace
	outreg2 using resultados/encuesta/$depvar$modx`value', word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value', fe
	outreg2 using resultados/encuesta/$depvar$modx`value', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value', re
	outreg2 using resultados/encuesta/$depvar$modx`value', word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios
	
}
log close
