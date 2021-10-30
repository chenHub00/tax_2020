// cd al directorio raiz
set more off

// previos: do_encuesta.do
// global datos = "datos/encuesta/"
// global codigo = "stata_code\encuesta_\"
// global resultados = "resultados\encuesta\"

do stata_code/encuesta_/dir_encuesta.do

global depvar "ppu"

capture log close
* FULL SAMPLE ---------------------------------------------
*log using "resultados/encuesta/ppu_tobit_patron_singles.log", replace
*use "$datos/cp_w1a8.dta", clear
// impuestos
*global vars_txc "tax2020 tax2021 " 
*global mod = "ppu_tobit_patron"

// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ---------------------------------------------
log using "resultados/encuesta/ppu_balanc_tobit.log", replace
use datos/encuesta//cp_w456balanc.dta, clear
// impuestos
global vars_txc "tax2020 " 

global mod = "ppu_tobit_balanc_patron"

/* MACROS ---------------------------------------------*/

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"

foreach value of numlist 0/1 {
/***************************************************************************
// 1.0 MODELOS
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
// 1.2 MODELOS ajustes variables agrupadas

tobit $depvar $vars_reg if patron == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel replace

/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
// modelo
tobit $depvar $vars_txc $vars_reg i.wave if patron == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel append

***************************************************************************/

	/***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tobit  $depvar $vars_txc $vars_regpatron if $seleccion &  patron == `value'
	outreg2 using resultados/encuesta/mods_$depvar$mod`value', word excel replace

	//
	xttobit $depvar $vars_txc $vars_regpatron if $seleccion  & patron == `value'
	outreg2 using resultados/encuesta/mods_$depvar$mod`value', word excel append

	

}

*global mod = "ppu_tobit_singles"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 ---------------------------------------------
global mod = "ppu_tobit_balanc_singles"

foreach value of numlist 0/1 {
/***************************************************************************
// 1.0 MODELOS
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
// 1.2 MODELOS ajustes variables agrupadas
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

tobit $depvar $vars_reg if singles == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel replace

/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
global vars_txc "tax2020 covid19" 

// modelo
tobit $depvar $vars_txc $vars_reg i.wave if singles == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel append


	***************************************************************************/
	// 1.3 MODELOS por tipo de compra: cajetilla o no
	// 1.3a MODELOS interacciones, patron * tax

	// modelo
	tobit  $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/mods_$depvar$mod`value', word excel replace

	//
	xttobit $depvar $vars_txc $vars_regsingles if $seleccion & singles == `value'
	outreg2 using resultados/encuesta/mods_$depvar$mod`value', word excel append


}
log close

