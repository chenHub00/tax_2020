// cd al directorio raiz

set more off

capture log close
log using "resultados/encuesta/mods_ppu_patron_singles.log", replace

do stata_code/encuesta_/dir_encuesta.do


// lineal
global mod "ppu_patron"
global depvar "ppu"

// logaritmos
//global mod = "log_ppu_patron"
//global depvar "log_ppu"

// regresiones
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"

// impuestos
global vars_txc "tax2020 tax2021 " 

use "$datos/cp_w1a8.dta", clear

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


global mod = "ppu_singles"
// logaritmos
//global mod = "log_ppu_singles"
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