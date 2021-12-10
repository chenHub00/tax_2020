// cd al directorio raiz

set more off

// lineal <<<<<<<<<------------------------------------------ lineal 
*global depvar "ppu" 
// logaritmos <<<<<<<<<------------------------------------------ logaritmos 
global depvar "log_ppu" 

capture log close
// CHANGES FOR FULL SAMPLE
*log using "resultados/encuesta/xtreg_patron_singles_$depvar.log", replace
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
log using "resultados/encuesta/xtreg_balan_$depvar.log", replace

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"


// CHANGES FOR FULL SAMPLE *--------------------------
// impuestos <<<<<<<<<------------------------------------------
// global vars_txc "tax2020 tax2021 "  
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
// impuestos <<<<<<<<<------------------------------------------
global vars_txc "tax2020 " 
*--------------------------

// CHANGES FOR FULL SAMPLE <<<<<<<<<------------------------------------------
*use "$datos/cp_w1a8.dta", clear
// lineal <<<<<<<<<------------------------------------------
*global mod "ppu_patron"
// logaritmos <<<<<<<<<------------------------------------------
//global mod = "log_ppu_patron"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
use "$datos/cp_w456balanc.dta", clear
// lineal <<<<<<<<<------------------------------------------
*global mod = "ppu_balanc_patron"
// logaritmos <<<<<<<<<------------------------------------------ logaritmos 
global mod = "log_ppu_balanc_patron"

global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"

foreach value of numlist 0/1 {

//local value "1"
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value'
	outreg2 using "resultados/encuesta/$mod`value'", word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value', fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regpatron if $seleccion & patron == `value', re
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios
	

}

// lineal <<<<<<<<<------------------------------------------
*global mod = "ppu_singles" <<<<<<<<<------------------------------------------
// logaritmos <<<<<<<<<------------------------------------------ logaritmos 
//global mod = "log_ppu_singles" 
* Lineal: <<<<<<<<<------------------------------------------
* global mod = "ppu_balanc_singles"
* log: <<<<<<<<<------------------------------------------ logaritmos
global mod = "log_ppu_balanc_singles"


global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

foreach value of numlist 0/1 {
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regsingles  if $seleccion & singles == `value'
	outreg2 using "resultados/encuesta/$mod`value'", word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value', fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value', re
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

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
