
set more off

capture log close
log using "resultados/encuesta/mods_xtgee_cons_patron_singles.log", replace

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "w1a8_iwave_patron_singles"
//global depvar "cons_por_dia"
// semanal
global mod = "tnbreg_patron"
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

xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform

/*
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform

foreach value of numlist 0/1 {
preserve
keep if patron == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tnbreg  $depvar $vars_txc $vars_regpatron if $seleccion 
	outreg2 using resultados/encuesta/$mod`value', word excel replace

	//
	xttobit $depvar $vars_txc $vars_regpatron if $seleccion 
	outreg2 using resultados/encuesta/$mod`value', word excel append

	
restore
}

global mod = "tnbreg_singles"
global depvar "consumo_semanal"
// diario
//global depvar "cons_por_dia"

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
