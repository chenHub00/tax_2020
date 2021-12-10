
set more off

capture log close
// CHANGES FOR FULL SAMPLE
*log using "resultados/encuesta/mods_xtgee_cons_patron_singles.log", replace
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
log using "resultados/encuesta/xtgee_cons_balanc.log", replace

/************************************************************************************/
/* 	GLOBALS, DIRS --------------------------------------------------*/
do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = ""
// diario
//global depvar "cons_por_dia"

// semanal
// CHANGES FOR FULL SAMPLE ------------------------------------------;
*global mod = "xtgee_"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
global mod = "xtgee_balanc"


global patsing = "patron_"
global inter = "01"
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos 
// CHANGES FOR FULL SAMPLE ------------------------------------------;
*global vars_txc "tax2020 tax2021 " 
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ------------------------------------------
global vars_txc "tax2020 " 
// // interacciones
global v_patron "sexo##patron i.edad_gr3##patron i.educ_gr3##patron i.ingr_gr##patron i.wave##patron singles##patron "
global v_singles "sexo##singles i.edad_gr3##singles i.educ_gr3##singles i.ingr_gr##singles i.wave##singles patron##singles "
// CHANGES FOR FULL SAMPLE ------------------------------------------;
*global v_txc_patron "tax2020##patron tax2021##patron"
*global v_txc_tipo "tax2020##i.tipo tax2021##i.tipo"
*global v_txc_singles "tax2020##singles tax2021##singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ------------------------------------------
global v_txc_patron "tax2020##patron"
global v_txc_tipo "tax2020##i.tipo"
global v_txc_singles "tax2020##singles"

/** como se definen en: modelos_consumo_iwave.do
*global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron singles#patron"
*global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles#patron"
global v_tipo "sexo#i.tipo i.edad_gr3#i.tipo i.educ_gr3#i.tipo i.ingr_gr#tipo i.tipo"
global v_txc_singles "tax2020#singles tax2021#singles"
global v_txc_patron "tax2020#patron tax2021#patron"
global v_txc_tipo "tax2020#i.tipo tax2021#i.tipo"
// global v_covid19 "covid19#singles covid19#patron"*/
/* 	end: GLOBALS, DIRS --------------------------------------------------*/
// CHANGES FOR FULL SAMPLE
*use "$datos/cons_w_1to8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
use "$datos/cons_w456_balanc.dta", replace

// SAME CODE FOR BOTH DATA SETS ---------------------------------------------
/* a partir de esta especificación, que aplica para un logit, variable binomial
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform*/

/************************************************************************************/
/* SIN INTERACCIONES*/
xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod, word excel replace

xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(nbinomial) corr(exchangeable) i(id_num) robust eform
* Link:   Log 
outreg2 using resultados/encuesta/$mod, word excel append

xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod, word excel append

/************************************************************************************/
/* PATRON (1= diario, 0 = ocasional) INTERACCIONES*/

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel replace

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(nbinomial) corr(exchangeable) i(id_num) robust eform
* Link:   Log 
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel append

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel append

/************************************************************************************/
/* SUBMUESTRAS PATRON (1= diario, 0 = ocasional) */

foreach value of numlist 0/1 {

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(gaussian)  corr(independent)  nmp
	// mismo que regress
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel replace

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(nbinomial) corr(exchangeable) i(id_num) robust eform
	* Link:   Log 
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel append

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel append

}

/************************************************************************************/
/* Singles (1= sueltos, 0 = cajetilla) INTERACCIONES*/
global patsing = "singles"
xtgee $depvar $v_txc_singles $v_singles if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel replace

xtgee  $depvar $v_txc_singles $v_singles if $seleccion, family(nbinomial) corr(exchangeable) i(id_num) robust eform
* Link:   Log 
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel append

xtgee $depvar $v_txc_singles $v_singles if $seleccion, family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod$patsing$inter, word excel append


/************************************************************************************/
/* SUBMUESTRAS PATRON (1= diario, 0 = ocasional) */

foreach value of numlist 0/1 {

	xtgee  $depvar $v_txc_singles $v_singles if $seleccion & singles == `value', family(gaussian)  corr(independent)  nmp
	// mismo que regress
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel replace

	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == `value', family(nbinomial) corr(exchangeable) i(id_num) robust eform
	* Link:   Log 
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel append

	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == `value', family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform
	outreg2 using resultados/encuesta/$mod$patsing`value', word excel append

}
log close
//end: SAME CODE FOR BOTH DATA SETS ---------------------------------------------

/************************************************************************************/
/* Precios con gaussian */
**																					**
**																					**
**																					**
**																					**
**																					**
/************************************************************************************/
capture log close
// CHANGES FOR FULL SAMPLE
*log using "resultados/encuesta/mods_xtgee_ppu_patron_singles.log", replace
*use "$datos/cp_w1a8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
log using "resultados/encuesta/xtgee_ppu_balanc.log", replace
use "$datos/cp_w456balanc.dta", clear

// precios
// semanal
global patsing = "patron_"
global inter = "01"
global depvar "ppu"

// SAME CODE FOR BOTH DATA SETS ---------------------------------------------
/* a partir de esta especificación, que aplica para un logit, variable binomial
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform*/

/************************************************************************************/
/* SIN INTERACCIONES*/
xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod$depvar, word excel replace

xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(gaussian) corr(exchangeable) i(id_num) robust eform
// equivalente a Random Effects
* Link:   Identity 
outreg2 using resultados/encuesta/$mod$depvar, word excel append

xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod$depvar, word excel append
// ¿equivalente a transformación log?

/* Otras transformaciones posibles
xtgee  $depvar $vars_txc $vars_reg if $seleccion, family(gaussian) link(power -.5) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod, word excel append
// ¿equivalente a transformación raíz cuadrada?*/

/************************************************************************************/
/* PATRON (1= diario, 0 = ocasional) INTERACCIONES*/

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel replace

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(gaussian) corr(exchangeable) i(id_num) robust eform
* Link:   Identity
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel append

xtgee  $depvar $v_txc_patron $v_patron if $seleccion, family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel append

/************************************************************************************/
/* SUBMUESTRAS PATRON (1= diario, 0 = ocasional) */

foreach value of numlist 0/1 {

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(gaussian)  corr(independent)  nmp
	// mismo que regress
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel replace

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(gaussian) corr(exchangeable) i(id_num) robust eform
	* Link:   Identity 
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append

	xtgee  $depvar $v_txc_patron $v_patron if $seleccion & patron == `value', family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append

}


/************************************************************************************/
/* Singles (1= sueltos, 0 = cajetilla) INTERACCIONES*/
global patsing = "singles"

xtgee $depvar $v_txc_singles $v_singles if $seleccion, family(gaussian)  corr(independent)  nmp
// mismo que regress
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel replace

xtgee  $depvar $v_txc_singles $v_singles if $seleccion, family(gaussian) corr(exchangeable) i(id_num) robust eform
* Link:   Identity 
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel append

xtgee $depvar $v_txc_singles $v_singles if $seleccion, family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
outreg2 using resultados/encuesta/$mod$depvar$patsing$inter, word excel append


/************************************************************************************/
/* SUBMUESTRAS PATRON (1= diario, 0 = ocasional) */

foreach value of numlist 0/1 {

	xtgee  $depvar $v_txc_singles $v_singles if $seleccion & singles == `value', family(gaussian)  corr(independent)  nmp
	// mismo que regress
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel replace

// NO hay convergencia en la estimacion
	*	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == `value', family(gaussian) corr(exchangeable) i(id_num) robust eform
	* Link:   Identity 
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append
* esta repetido 

	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == `value', family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
	outreg2 using resultados/encuesta/$mod$depvar$patsing`value', word excel append

}
log close

/*

resultados/encuesta/xtgee_balancppusingles1.rtf
resultados/encuesta/xtgee_balancppusingles1.xml
after selection: singles=1 en la segunda especificacions
	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == 1, family(gaussian) corr(exchangeable) i(id_num) robust eform

note: 1.singles omitted because of collinearity
note: 1.tax2020#1.singles omitted because of collinearity
note: 1.sexo#1.singles omitted because of collinearity
note: 2.edad_gr3#1.singles omitted because of collinearity
note: 3.edad_gr3#1.singles omitted because of collinearity
note: 4.edad_gr3#1.singles omitted because of collinearity
note: 5.edad_gr3#1.singles omitted because of collinearity
note: 6.edad_gr3#1.singles omitted because of collinearity
note: 7.edad_gr3#1.singles omitted because of collinearity
note: 3.educ_gr3#1.singles omitted because of collinearity
note: 4.educ_gr3#1.singles omitted because of collinearity
note: 5.educ_gr3#1.singles omitted because of collinearity
note: 6.educ_gr3#1.singles omitted because of collinearity
note: 5.ingr_gr#1.singles omitted because of collinearity
note: 6.ingr_gr#1.singles omitted because of collinearity
note: 7.ingr_gr#1.singles omitted because of collinearity
note: 5.wave omitted because of collinearity
note: 5.wave#1.singles omitted because of collinearity
note: 6.wave#1.singles omitted because of collinearity
note: 1.patron#1.singles omitted because of collinearity

Iteration 1: tolerance = .51357994
Iteration 2: tolerance = .33229732
Iteration 3: tolerance = .12366322
Iteration 4: tolerance = .10157037
estimates diverging (correlation > 1)

	xtgee  $depvar $v_txc_singles  $v_singles if $seleccion & singles == 1, family(gaussian) link(log) corr(exchangeable) i(id_num) robust eform
