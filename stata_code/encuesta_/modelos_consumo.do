// cd al directorio raiz

// previos: 
set more off


capture log close
log using "resultados/encuesta/modelos_consumo0.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

//use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cons_w456_unbalanc.dta", clear
/***************************************************************************/
// 1.0 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
// global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.tipo_cons"
// regress
regress consumo_semanal $vars_reg if has_fumado_1mes
// FE:
xtreg consumo_semanal $vars_reg if has_fumado_1mes, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
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
/*-----------------------------------------------------*/
log using "$resultados/modelos_consumo1.log", replace

//use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cons_w456_unbalanc.dta", clear
/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
global vars_txc "tax2020 covid19" 
// modelo
regress consumo_semanal $vars_txc $vars_reg if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_1, word excel replace

// estimación panel
xtreg consumo_semanal $vars_txc $vars_reg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_1, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg consumo_semanal $vars_txc $vars_reg if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_1, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

//use "$datos/wave4_5balanc.dta", clear
use "$datos/cons_w456_balanc.dta", clear
xtreg consumo_semanal $vars_txc $vars_reg if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_1, word excel append

capture log close
/*-----------------------------------------------------*/
// 1.2 MODELOS ajustes variables agrupadas
// Se cambió por el 1.1
/*-----------------------------------------------------*/
log using "$resultados/modelos_consumo3.log", replace
//use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cons_w456_unbalanc.dta", clear
/***************************************************************************/
// 1.3 MODELOS por tipo de compra: cajetilla o no
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles i.singles  i.patron"
global v_txc_singles "tax2020#i.singles tax2020_sexo#i.singles tax2020#i.patron tax2020_sexo#i.patron"
global v_covid19 "covid19#i.singles covid19_sexo#i.singles covid19#i.patron covid19_sexo#i.patron"

global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_txc_tipo_int "tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons covid19#i.tipo_cons covid19_sexo#i.tipo_cons "
global v_tipo_int "tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "

// modelo
//regress consumo_semanal $vars_txc $v_tipo_int $v_tipo if has_fumado_1mes
regress consumo_semanal $vars_txc $v_txc_singles $v_singles if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_3, word excel replace

// pruebas
//testparm i.tipo // se rechaza igualdad
//testparm tax2020#i.tipo // no se rechaza igualdad
//testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
// singles
testparm i.singles // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm i.patron // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm tax2020#i.singles // no se rechaza igualdad
testparm tax2020_sexo#i.singles // no se rechaza igualdad
testparm tax2020#i.patron // no se rechaza igualdad
testparm tax2020_sexo#i.patron // no se rechaza igualdad

// estimación panel
//xtreg consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, fe
xtreg consumo_semanal $vars_txc $v_txc_singles $v_singles if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
/*
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
*/
testparm i.singles // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm i.patron // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm tax2020#i.singles // no se rechaza igualdad
testparm tax2020_sexo#i.singles // no se rechaza igualdad
testparm tax2020#i.patron // no se rechaza igualdad
testparm tax2020_sexo#i.patron // no se rechaza igualdad

xtreg consumo_semanal $vars_txc $v_txc_singles $v_singles if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// // pruebas
// testparm i.tipo // se rechaza igualdad
// testparm tax2020#i.tipo // no se rechaza igualdad
// testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

testparm i.singles // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm i.patron // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm tax2020#i.singles // no se rechaza igualdad
testparm tax2020_sexo#i.singles // no se rechaza igualdad
testparm tax2020#i.patron // no se rechaza igualdad
testparm tax2020_sexo#i.patron // no se rechaza igualdad

//use "$datos/wave4_5balanc.dta", clear
use "$datos/cons_w456_balanc.dta", clear
xtreg consumo_semanal $vars_txc $v_txc_singles $v_singles if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// // pruebas
// testparm i.tipo // NO se rechaza igualdad
// testparm tax2020#i.tipo // no se rechaza igualdad
// testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

testparm i.singles // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm i.patron // se rechaza igualdad: equivalente a la prueba t de la regresión
testparm tax2020#i.singles // no se rechaza igualdad
testparm tax2020_sexo#i.singles // no se rechaza igualdad
testparm tax2020#i.patron // no se rechaza igualdad
testparm tax2020_sexo#i.patron // no se rechaza igualdad

log close

