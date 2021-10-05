
set more off

capture log close
log using "resultados/encuesta/mods_xtqreg_cons_patron_singles.log", replace

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "_patron_"
//global depvar "cons_por_dia"
// semanal
global mod = "xtqreg_patron"
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
global vars_txc "tax2020 tax2021 " 
// // interacciones
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
// global v_txc_patron "tax2020#patron tax2021#patron"
// global v_covid19 "covid19#singles covid19#patron"

use "$datos/cons_w_1to8.dta", clear

foreach value of numlist 0/1 {
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	collect: qreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xtqreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel append

	
}

global mod = "xtqreg_patron"

// diario
//global depvar "cons_por_dia"

foreach value of numlist 0/1 {
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	qreg  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xtqreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/$mod`value', word excel append

	
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