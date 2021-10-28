
// cd al directorio raiz
set more off

// CHANGES FOR FULL SAMPLE
*global mod = "_iwave"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global mod = "cons_balanc_tnb"

capture log close
* FULL SAMPLE ---------------------------------------------
*log using "resultados/encuesta/mods_tnb_cons_patron_singles.log", replace
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ---------------------------------------------
log using "resultados/encuesta/cons_balanc_tnb.log", replace

/* MACROS ---------------------------------------------*/

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "w1a8_iwave_patron_singles"
//global depvar "cons_por_dia"
// semanal
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

// impuestos
*global vars_txc "tax2020 tax2021 " 
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
// BALANCEADO no tiene tax2021
global vars_txc "tax2020 " 

// // interacciones
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
// global v_txc_patron "tax2020#patron tax2021#patron"
// global v_covid19 "covid19#singles covid19#patron"

/* end: MACROS ---------------------------------------------*/
* FULL SAMPLE:
*use "$datos/cons_w_1to8.dta", clear
*global mod = "tnbreg_patron"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
use "$datos/cons_w456_balanc.dta", replace

global modx = "cons_balanc_tnb_patron"

// SAME CODE FOR BOTH DATA SETS ---------------------------------------------
foreach value of numlist 0/1 {
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tnbreg  $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$modx`value', word excel replace
	//
	xttobit $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$modx`value', word excel append

}

// end: SAME CODE FOR BOTH DATA SETS ---------------------------------------------
* FULL SAMPLE ---------------------------------------------
*use "$datos/cons_w_1to8.dta", clear
*global mod = "tnbreg_singles"

// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ---------------------------------------------
global modx = "cons_balanc_tnb_singles"

// SAME CODE FOR BOTH DATA SETS ---------------------------------------------
foreach value of numlist 0/1 {
/***************************************************************************/
// 1.3 MODELOS por tipo de compra: cajetilla o no
// 1.3a MODELOS interacciones, patron * tax

// modelo
tnbreg  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
outreg2 using resultados/encuesta/$modx`value', word excel replace

//
xttobit $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
outreg2 using resultados/encuesta/$modx`value', word excel append

}
