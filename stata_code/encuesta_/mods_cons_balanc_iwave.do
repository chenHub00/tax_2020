// cd al directorio raiz
set more off

// CHANGES FOR FULL SAMPLE
*global mod = "_iwave"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
global mod = "_balanc_iwave"

capture log close
log using "resultados/encuesta/mods_cons$mod.log", replace

do stata_code/encuesta_/dir_encuesta.do

global depvar "consumo_semanal"
global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 *--------------------------
// impuestos
// global vars_txc "tax2020 tax2021 " 
// // interacciones
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron singles#patron"
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles#patron"
// global v_tipo "sexo#i.tipo i.edad_gr3#i.tipo i.educ_gr3#i.tipo i.ingr_gr#tipo i.tipo"
// global v_txc_singles "tax2020#singles tax2021#singles"
// global v_txc_patron "tax2020#patron tax2021#patron"
// global v_txc_tipo "tax2020#i.tipo tax2021#i.tipo"
*global v_covid19 "covid19#singles covid19#patron"
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
// impuestos
global vars_txc "tax2020 " 
// interacciones
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron singles#patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles#patron"
global v_tipo "sexo#i.tipo i.edad_gr3#i.tipo i.educ_gr3#i.tipo i.ingr_gr#tipo i.tipo"
global v_txc_singles "tax2020#singles "
global v_txc_patron "tax2020#patron "
global v_txc_tipo "tax2020#i.tipo "
*--------------------------

// initial working sample:
//use "$datos/wave4_5unbalanced.dta", clear 
// CHANGES FOR FULL SAMPLE
*use "$datos/cons_w_1to8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
use "$datos/cons_w456_balanc.dta", replace

/***************************************************************************/
// 1.0 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
// global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"

// regress
regress consumo_semanal $vars_reg i.wave if $seleccion
// FE:
xtreg consumo_semanal $vars_reg i.wave if $seleccion, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
xtreg consumo_semanal $vars_reg i.wave if $seleccion, re
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
regress consumo_semanal $vars_txc $vars_reg i.wave if $seleccion
outreg2 using resultados/encuesta/mods_consumo$mod, word excel replace

// estimación panel
xtreg consumo_semanal $vars_txc $vars_reg i.wave if $seleccion, fe
outreg2 using resultados/encuesta/mods_consumo$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg consumo_semanal $vars_txc $vars_reg i.wave if $seleccion, re
outreg2 using resultados/encuesta/mods_consumo$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

*log close
/***************************************************************************/
// 1.3 MODELOS por tipo de compra: cajetilla o no
// 1.3a MODELOS interacciones, tipo* tax

// modelo
regress  $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion
outreg2 using resultados/encuesta/mods_consumo_tipo$mod, word excel replace

// pruebas
*testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg  $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion, fe
outreg2 using resultados/encuesta/mods_consumo_tipo$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
*testparm $v_txc_patron // no se rechaza igualdad

xtreg  $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion, re
outreg2 using resultados/encuesta/mods_consumo_tipo$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// // pruebas
*testparm $v_txc_patron // no se rechaza igualdad

/*---------------------------------------------------------*/
// 1.3b MODELOS interacciones, patron * vars
regress $depvar $v_txc_patron $v_patron i.wave##patron if $seleccion
outreg2 using resultados/encuesta/mods_cons_patron$mod, word excel replace

// pruebas
//testparm i.tipo // se rechaza igualdad
//testparm tax2020#i.tipo // no se rechaza igualdad
//testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
// singles
*testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_patron $v_patron i.wave##patron if $seleccion, fe
outreg2 using resultados/encuesta/mods_cons_patron$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
*testparm $v_txc_patron // no se rechaza igualdad

* Aleatorios
xtreg $depvar $v_txc_patron $v_patron i.wave##patron if $seleccion, re
outreg2 using resultados/encuesta/mods_cons_patron$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

*testparm $v_txc_patron // no se rechaza igualdad

/*---------------------------------------------------------*/
// 1.3c MODELOS interacciones, singles * tax
regress $depvar $v_txc_singles $v_singles i.wave##singles if $seleccion
outreg2 using resultados/encuesta/mods_cons_singles$mod, word excel replace

// pruebas
// singles
*testparm $v_txc_singles // Sí se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_singles $v_singles i.wave##singles if $seleccion, fe
outreg2 using resultados/encuesta/mods_cons_singles$mod, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
*testparm $v_txc_singles // no se rechaza igualdad

xtreg $depvar $v_txc_singles $v_singles i.wave##singles if $seleccion, re
outreg2 using resultados/encuesta/mods_cons_singles$mod, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

*testparm $v_txc_singles // Sí se rechaza igualdad


log close
