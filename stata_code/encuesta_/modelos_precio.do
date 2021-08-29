// cd al directorio raiz
set more off

// previos: do_encuesta.do
global resultados = "resultados\encuesta\"

capture log close
log using "$resultados/modelos_precio.log", replace

/***************************************************************************/
// MACROS
macro list resultados

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

// variable dependiente>
global dep "ppu"

// variable independientes
// sección 1 
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
global vreg "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr i.tipo"
// sección 2
// sólo interacción de impuesto con sexo
global v_int "tax2020 tax2020_sexo "
// sección 3
global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "


use "$datos/c_pw4_w5_balanc.dta", clear
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

// modelo
regress $dep tax2020 $vreg if has_fumado_1mes
outreg2 using resultados/encuesta/mod_p1_1, word excel replace

// estimación panel
xtreg $dep tax2020 $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_1, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $dep tax2020 $vreg if has_fumado_1mes, re
outreg2 using resultados/encuesta/mod_p1_1, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

use "$datos/c_pw4_w5_balanc.dta", clear
//use "$datos/wave4_5balanc.dta", clear
xtreg $dep tax2020 $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_1, word excel append

/*-----------------------------------------------------*/
// use "$datos/wave4_5unbalanced.dta", clear
use "$datos/c_pw4_w5_balanc.dta", clear
/***************************************************************************/
// 1.2 MODELOS ajustes variables agrupadas

// modelo
regress $dep $v_int $vreg if has_fumado_1mes
outreg2 using resultados/encuesta/mod_p1_2, word excel replace
  
// estimación panel
xtreg $dep $v_int $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_2, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $dep $v_int $vreg if has_fumado_1mes, re
outreg2 using resultados/encuesta/mod_p1_2, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

use "$datos/c_pw4_w5_balanc.dta", clear
//use "$datos/wave4_5balanc.dta", clear
xtreg $dep $v_int $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_2, word excel append

/*-----------------------------------------------------*/
// use "$datos/wave4_5unbalanced.dta", clear
use "$datos/c_pw4_w5_balanc.dta", clear
/***************************************************************************/
// 1.3 MODELOS tipo

// modelo
regress $dep $v_tipo_int $v_tipo if has_fumado_1mes
outreg2 using resultados/encuesta/mod_p1_3, word excel replace

// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

// estimación panel
xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, re
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

// use "$datos/wave4_5balanc.dta", clear
use "$datos/c_pw4_w5_balanc.dta",clear
xtreg $dep $v_tipo_int $v_tipo if has_fumado_1mes, fe
outreg2 using resultados/encuesta/mod_p1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm i.tipo // NO se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

log close

