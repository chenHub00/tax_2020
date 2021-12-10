
set more off

capture log close
// CHANGES FOR FULL SAMPLE
log using "resultados/encuesta/mods_xtqreg_cons_patron_singles.log", replace
use "$datos/cp_w1a8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*log using "resultados/encuesta/xtqreg_cons_balanc.log", replace
*use "$datos/cp_w456balanc.dta", clear

do stata_code/encuesta_/0_dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "_patron_"
//global depvar "cons_por_dia"
// semanal
*global depvar "consumo_semanal"
*global depvar "ppu"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
// CHANGES FOR FULL SAMPLE
*global vars_txc "tax2020 tax2021 " 
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
global vars_txc "tax2020 " 
// // interacciones
global v_patron "sexo##patron i.edad_gr3##patron i.educ_gr3##patron i.ingr_gr##patron i.wave##patron singles##patron "
global v_singles "sexo##singles i.edad_gr3##singles i.educ_gr3##singles i.ingr_gr##singles i.wave##singles patron##singles "
// CHANGES FOR FULL SAMPLE
global v_txc_singles "tax2020##singles tax2021##singles"
global v_txc_patron "tax2020##patron tax2021##patron"
global v_txc_tipo "tax2020##i.tipo tax2021##i.tipo"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global v_txc_singles "tax2020##singles "
*global v_txc_patron "tax2020##patron "
*global v_txc_tipo "tax2020##i.tipo "
/************************************************************************************/

* secci'on patron
// CHANGES FOR FULL SAMPLE
global mod = "xtqreg_patron"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global mod = "xtqreg_balanc_patron"

*xtqreg $depvar $vars_txc $vars_regpatron if $seleccion 
*xtqreg $depvar $v_txc_patron $v_patron if $seleccion 

*	qregpd $depvar $vars_txc $vars_regpatron if $seleccion 
*	outreg2 using resultados/encuesta/$mod`value', word excel append	
	// Factor variables and time-series not allowed
*qregpd $depvar $vars_txc , id(id_num) fix(wave)
*. qregpd $depvar $vars_txc , id(id_num) fix(wave)
*                 <istmt>:  3499  mm_panels() not found
*r(3499);

foreach value of numlist 0/1 {
	/***************************************************************************/

	// modelo
	qreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	// "standard" fixed effects
	xtqreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel append

}

* secci'on singles
// CHANGES FOR FULL SAMPLE
global mod = "xtqreg_singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*global mod = "xtqreg_balanc_singles"

// diario
//global depvar "cons_por_dia"

foreach value of numlist 0/1 {
	/***************************************************************************/

	// modelo
	qreg  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xtqreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel append

}

log close

/***************************************************************************/
**	              Precio                                                   **
**	                                                                      **
**	                                                                      **
**	                                                                      **
**	                                                                      **
***************************************************************************/
capture log close
// CHANGES FOR FULL SAMPLE
log using "resultados/encuesta/mods_xtqreg_ppu_patron_singles.log", replace
use "$datos/cp_w1a8.dta", clear
global mod = "xtqreg_"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*log using "resultados/encuesta/xtqreg_ppu_balanc.log", replace
*use "$datos/cp_w456balanc.dta", clear
*global mod = "xtqreg_balanc"

global depvar "ppu"

* secci'on patron
global patsing= "patron"

*xtqreg $depvar $vars_txc $vars_regpatron if $seleccion 
*xtqreg $depvar $v_txc_patron $v_patron if $seleccion 

*	qregpd $depvar $vars_txc $vars_regpatron if $seleccion 
*	outreg2 using resultados/encuesta/$mod`value', word excel append	
	// Factor variables and time-series not allowed
*qregpd $depvar $vars_txc , id(id_num) fix(wave)
*. qregpd $depvar $vars_txc , id(id_num) fix(wave)
*                 <istmt>:  3499  mm_panels() not found
*r(3499);

foreach value of numlist 0/1 {
	/***************************************************************************/

	// modelo
	qreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel replace

	// "standard" fixed effects
	xtqreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append

}

* secci'on singles
global patsing= "singles"

// diario
//global depvar "cons_por_dia"

foreach value of numlist 0/1 {
	/***************************************************************************/

	// modelo
	qreg  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel replace

	//
	xtqreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append

}

log close

/* 

table if $seleccion & patron == 1, command(qreg $depvar $vars_txc $vars_regpatron ) ///
	command(xtqreg $depvar $vars_txc $vars_regpatron ) style(table-reg1)
collect preview	
	
collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & singles == 0
collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & singles == 1


collect clear
collect style use table-reg1, replace
collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == 1
collect: xtqreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == 1
collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & singles == 0
collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & singles == 1

collect style use table-reg1
collect preview
