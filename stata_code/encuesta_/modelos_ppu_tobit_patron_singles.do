// cd al directorio raiz
set more off

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"


global depvar "ppu"

use "$datos/cp_w1a8.dta", clear

capture log close
log using "$resultados/mods_$depvar_patron_singles.log", replace

global mod = "tobit_patron"
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron"

foreach value of numlist 0/1 {
/***************************************************************************/
// 1.0 MODELOS
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
// 1.2 MODELOS ajustes variables agrupadas

tobit $depvar $vars_reg if patron == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel replace

/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
global vars_txc "tax2020 covid19" 

// modelo
tobit $depvar $vars_txc $vars_reg i.wave if patron == `value'
outreg2 using "resultados/encuesta/mods_$depvar$mod`value'", word excel append

/***************************************************************************/
}

global mod = "tobit_singles"
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron"

foreach value of numlist 0/1 {
/***************************************************************************/
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

}
log close

