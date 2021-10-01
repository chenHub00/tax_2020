// cd al directorio raiz

set more off

do stata_code/encuesta_/dir_encuesta.do

global mod = "ppu_patron"
//global mod = "log_ppu_patron"
global depvar "ppu"
//global depvar "log_ppu"

capture log close
log using "resultados/encuesta/mods_$mod.log", replace

// regresiones
//global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
// global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
global vars_txc "tax2020 tax2021 " 

use "$datos/cp_w1a8.dta", clear

foreach value of numlist 0/1 {
preserve
// only change names, variables, and outreg
keep if singles == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_reg
// second change resp "patron"
	//	outreg2 using resultados/encuesta/cons_patron`value', word excel replace
	outreg2 using "resultados/encuesta/$mod`value'", word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_reg , fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_reg , re
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

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


global mod = "ppu_singles"
//global mod = "log_ppu_singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

capture log close
log using "resultados/encuesta/mods_$mod.log", replace

foreach value of numlist 0/1 {
preserve
// only change names, variables, and outreg
keep if singles == `value'
//keep if patron == 1
	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	regress  $depvar $vars_txc $vars_regsingles  
// second change resp "patron"
	//	outreg2 using resultados/encuesta/cons_patron`value', word excel replace
	outreg2 using "resultados/encuesta/$mod`value'", word excel replace

	// estimación panel
	xtreg $depvar $vars_txc $vars_regsingles , fe
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/

	xtreg $depvar $vars_txc $vars_regsingles , re
	outreg2 using "resultados/encuesta/$mod`value'", word excel append

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
