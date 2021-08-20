// cd al directorio raiz
set more off

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

global mod = "_log"
global depvar "log_cons_sem"

capture log close
log using "$resultados/modelos_cons0$mod.log", replace

use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.0 MODELOS
global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"

regress $depvar $vars_reg if has_fumado_1mes
// FE:
xtreg $depvar $vars_reg if has_fumado_1mes, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
xtreg $depvar $vars_reg if has_fumado_1mes, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// ?fixed effects?random effects
// RECHAZO ALEATORIOS

capture log close
/*-----------------------------------------------------*/
log using "$resultados/modelos_cons1$mod.log", replace

use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.1 MODELOS
global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"

// modelo
regress $depvar tax2020 $vars_reg if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_1$mod, word excel replace

// estimación panel
xtreg $depvar tax2020 $vars_reg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_1$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $depvar tax2020 $vars_reg if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_1$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

use "$datos/wave4_5balanc.dta", clear
xtreg $depvar tax2020 $vars_reg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_1$mod, word excel append

capture log close
/*-----------------------------------------------------*/
log using "$resultados/modelos_cons2$mod.log", replace

/***************************************************************************/
// 1.2 MODELOS ajustes variables agrupadas
global vreg "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr i.tipo"
global v_int "tax2020 tax2020_sexo "
// sólo interacción de impuesto con sexo

// modelo
regress $depvar  $v_int $vreg if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_2$mod, word excel replace
  
// estimación panel
xtreg $depvar $v_int $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_2$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $depvar  $v_int $vreg if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_2$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

use "$datos/wave4_5balanc.dta", clear
xtreg $depvar  $v_int $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_2$mod, word excel append

capture log close
/*-----------------------------------------------------*/
log using "$resultados/modelos_cons3$mod.log", replace
use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.3 MODELOS tipo
global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "

// modelo
regress $depvar  $v_tipo_int $v_tipo if has_fumado_1mes, noconst
outreg2 using resultados/encuesta/modelos1_3$mod, word excel replace

// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_tipo_int $v_tipo if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_3$mod, word excel append

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

xtreg $depvar $v_tipo_int $v_tipo if has_fumado_1mes, re 
outreg2 using resultados/encuesta/modelos1_3$mod, word excel append

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

use "$datos/wave4_5balanc.dta", clear
xtreg $depvar $v_tipo_int $v_tipo if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_3$mod, word excel append

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

