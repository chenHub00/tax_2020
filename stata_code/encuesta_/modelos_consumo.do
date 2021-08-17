// cd al directorio raiz

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"


capture log close
log using "$resultados/modelos_consumo0.log", replace

use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.0 MODELOS
global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar tipo"

regress consumo_semanal $vars_reg if has_fumado_1mes
xtreg consumo_semanal $vars_reg if has_fumado_1mes, fe
estimates store fixed
xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
xtreg consumo_semanal $vars_reg if has_fumado_1mes, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// ?fixed effects?random effects
// RECHAZO ALEATORIOS

capture log close
log using "$resultados/modelos_consumo1.log", replace

use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.1 MODELOS
global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar tipo"

// modelo
regress consumo_semanal tax2020 $vars_reg if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_1, word excel replace

// estimación panel
xtreg consumo_semanal tax2020 $vars_reg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_1, word excel append

xtreg consumo_semanal tax2020 $vars_reg if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_1, word excel append

capture log close
log using "$resultados/modelos_consumo2.log", replace

/***************************************************************************/
// 1.2 MODELOS ajustes variables agrupadas
global vreg "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr i.tipo"
global v_int "tax2020 tax2020_sexo "

// modelo
regress consumo_semanal $v_int $vreg if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_2, word excel replace
  
// estimación panel
xtreg consumo_semanal $v_int $vreg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_2, word excel append
xtreg consumo_semanal $v_int $vreg if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_2, word excel append

capture log close
log using "$resultados/modelos_consumo3.log", replace
use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.3 MODELOS tipo
global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons tax2020_edad_gr2#i.tipo_cons tax2020_gr_educ#i.tipo_cons"

// modelo
regress consumo_semanal $v_tipo $v_tipo_int if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_3, word excel replace

// pruebas
testparm i.marca // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm i.marca

// estimación panel
xtreg consumo_semanal $v_tipo $v_tipo_int if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_3, word excel append
xtreg consumo_semanal $v_tipo $v_tipo_int if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_3, word excel append

log close

