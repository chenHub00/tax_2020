

/*---------------------------------------------------------*/
*
*
*	TRUNCATED NEGATIVE BINOMIAL
*
*
/*---------------------------------------------------------*/

// CHANGES FOR FULL SAMPLE
*global mod = "_iwave"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global mod = "_balanc_iwave_patron_singles"
/* COMPLETO */
*global mod = "w1a8_tnb_iwave"
/* BALANCEADO */
*global mod = "balanc_tnb_iwave"
global depvar "consumo_semanal"
global seleccion " educ_gr3 != 9 & ingr_gr != 99"

capture log close
*log using "resultados/encuesta/mods_cons_balanc_iwave_patron_singles.log", replace
// CHANGES FOR FULL SAMPLE 
log using "resultados/encuesta/mods_tnb_cons_patron_singles.log", replace

do stata_code/encuesta_/0_dir_encuesta.do

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
// impuestos
global vars_txc "tax2020 " 
// interacciones
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron singles#patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles#patron"
global v_txc_singles "tax2020#singles "
global v_txc_patron "tax2020#patron "

//global mod = "w1a8_iwave_patron_singles"
//global depvar "cons_por_dia"
// 8 waves
global mod = "tnbreg_patron"
// BALANCEADO
*global mod = "balanc_tnb_patron"
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
global vars_txc "tax2020 tax2021" 
// // interacciones
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
// global v_txc_patron "tax2020#patron tax2021#patron"

*use "$datos/cons_w_1to8.dta", clear

// CHANGES FOR FULL SAMPLE
use "$datos/cons_w_1to8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*use "$datos/cons_w456_balanc.dta", replace

foreach value of numlist 0/1 {
preserve
keep if patron == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tnbreg  $depvar $vars_txc $vars_regpatron i.wave singles 
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xttobit $depvar $vars_txc $vars_regpatron
	outreg2 using resultados/encuesta/$mod`value', word excel append

	
restore
}

global mod = "tnbreg_singles"
// BALANCEADO
*global mod = "balanc_tnb_singles"
*global depvar "cons_por_dia"

foreach value of numlist 0/1 {
preserve
keep if singles == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tnbreg  $depvar $vars_txc $vars_regsingles if $seleccion
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xttobit $depvar $vars_txc $vars_regsingles if $seleccion
	outreg2 using resultados/encuesta/$mod`value', word excel append

	
restore
}
log close

