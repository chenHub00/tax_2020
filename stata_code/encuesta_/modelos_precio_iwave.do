// cd al directorio raiz

set more off

do stata_code/encuesta_/dir_encuesta.do

global mod = "w1a8_lineal_iwave"
global depvar "ppu"

capture log close
log using "resultados/encuesta/mods_$depvar$mod.log", replace


use "$datos/cp_w1a8.dta", clear
/***************************************************************************/
// 1.0 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
// global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

// regress
regress $depvar $vars_reg i.wave if has_fumado_1mes
// FE:
xtreg $depvar $vars_reg i.wave if has_fumado_1mes, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
xtreg $depvar $vars_reg i.wave if has_fumado_1mes, re
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
global vars_txc "tax2020 covid19" 
// modelo
regress $depvar $vars_txc $vars_reg i.wave if has_fumado_1mes
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel replace

// estimación panel
xtreg $depvar $vars_txc $vars_reg i.wave if has_fumado_1mes, fe
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $depvar $vars_txc $vars_reg i.wave if has_fumado_1mes, re
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios
/***************************************************************************/
// 1.3 MODELOS por tipo de compra: cajetilla o no
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
global v_txc_singles "tax2020#singles tax2020_sexo#singles"
global v_txc_patron "tax2020#patron tax2020_sexo#patron"
global v_covid19 "covid19#singles covid19_sexo#singles covid19#patron covid19_sexo#patron"

// 1.3a MODELOS interacciones, patron * tax

// modelo
regress  $depvar $v_txc_patron $vars_reg $v_covid19 i.wave if has_fumado_1mes
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

// pruebas
testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_patron $vars_reg $v_covid19 i.wave if has_fumado_1mes, fe
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm $v_txc_patron // no se rechaza igualdad

xtreg $depvar $v_txc_patron $vars_reg $v_covid19 i.wave if has_fumado_1mes, re
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// // pruebas
testparm $v_txc_patron // no se rechaza igualdad

/*---------------------------------------------------------*/
// 1.3b MODELOS interacciones, patron * vars
regress $depvar $v_patron $v_txc_patron $v_covid19 i.wave if has_fumado_1mes
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

// pruebas
//testparm i.tipo // se rechaza igualdad
//testparm tax2020#i.tipo // no se rechaza igualdad
//testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
// singles
testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_patron $v_txc_patron $v_covid19 i.wave if has_fumado_1mes, fe
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
testparm $v_txc_patron // no se rechaza igualdad

* Aleatorios
xtreg $depvar $v_patron $v_txc_patron $v_covid19 i.wave if has_fumado_1mes, re
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

testparm $v_txc_patron // no se rechaza igualdad

/*---------------------------------------------------------*/
// 1.3c MODELOS interacciones, singles * tax
regress $depvar $v_txc_singles $v_reg $v_covid19 i.wave if has_fumado_1mes
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

// pruebas
// singles
testparm $v_txc_singles // Sí se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_singles $v_reg $v_covid19 i.wave if has_fumado_1mes, fe
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
testparm $v_txc_singles // no se rechaza igualdad

xtreg $depvar $v_txc_singles $v_reg $v_covid19 i.wave if has_fumado_1mes, re
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

testparm $v_txc_singles // Sí se rechaza igualdad

log close

