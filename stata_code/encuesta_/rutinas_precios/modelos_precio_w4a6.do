// cd al directorio raiz
set more off

capture log close
log using "resultados/encuesta/modelos_precio.log", replace

/***************************************************************************/
// MACROS
do stata_code/encuesta_/dir_encuesta.do

// variable dependiente>
global dep "ppu"

// variable independientes
// sección 1 
// sección 2
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
//global vreg "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr i.tipo"
global vreg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.tipo_cons"
global vars_txc "tax2020 covid19" 


// sólo interacción de impuesto con sexo
// global v_int "tax2020 tax2020_sexo "

// sección 3
// global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
// global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "

global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles i.singles  i.patron"
global v_txc_singles "tax2020#i.singles tax2020_sexo#i.singles tax2020#i.patron tax2020_sexo#i.patron"
global v_covid19 "covid19#i.singles covid19_sexo#i.singles covid19#i.patron covid19_sexo#i.patron"

// sección 4
// 1.4 MODELOS interacturados con pandemia, pandemia_sexo: patron, singles
global v_covid19 "covid19#i.singles covid19_sexo#i.singles covid19#i.patron covid19_sexo#i.patron"

use "$datos/cp_w456unbalanc.dta", clear
// use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.0 MODELOS

regress $dep $vreg if has_fumado_1mes
// FE:
xtreg $dep $vreg if has_fumado_1mes, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
xtreg $dep $vreg if has_fumado_1mes, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// ?fixed effects?random effects
// RECHAZO ALEATORIOS

/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
// modelo
regress $dep $vars_txc $vreg if has_fumado_1mes
outreg2 using resultados/encuesta/mod_p1_1, word excel replace

// estimación panel
xtreg $dep $vars_txc $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_1, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $dep $vars_txc $vreg if has_fumado_1mes, re
outreg2 using resultados/encuesta/mod_p1_1, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

use "$datos/cp_w456balanc.dta", clear
//use "$datos/wave4_5balanc.dta", clear
xtreg $dep tax2020 $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_1, word excel append

/*-----------------------------------------------------*/
/***************************************************************************/
// 1.3 MODELOS tipo
// use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cp_w456unbalanc.dta", clear

// modelo
// regress $dep $v_tipo_int $v_tipo if has_fumado_1mes
regress $dep $vars_txc $v_txc_singles $v_singles 
outreg2 using resultados/encuesta/mod_p1_3, word excel replace
 
/*
// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
 */

// estimación panel
//xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, fe
xtreg $dep  $vars_txc $v_txc_singles $v_singles if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
/*
// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
*/

//xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, re
xtreg $dep  $vars_txc $v_txc_singles $v_singles if has_fumado_1mes, re
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

/*
// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
*/

// use "$datos/wave4_5balanc.dta", clear
use "$datos/cp_w456balanc.dta",clear
//xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, fe
xtreg $dep $vars_txc $v_txc_singles $v_singles  if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
/*
// pruebas
testparm i.tipo // NO se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
*/

log close

