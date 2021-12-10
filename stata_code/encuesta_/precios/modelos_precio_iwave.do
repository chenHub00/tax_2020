// cd al directorio raiz

set more off

capture log close
// CHANGES FOR FULL SAMPLE <<<<<<<<<------------------------------------------
*log using "resultados/encuesta/mods_ppu_lineal_iwave.log", replace
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 <<<<<<<<<------------------------------------------
log using "resultados/encuesta/mods_ppu_balanc_iwave.log", replace

do stata_code/encuesta_/dir_encuesta.do

// otros y no responde se eliminan
global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

// interacciones
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron singles#patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles#patron"
global v_tipo "sexo#i.tipo i.edad_gr3#i.tipo i.educ_gr3#i.tipo i.ingr_gr#tipo i.tipo"
*global v_covid19 "covid19#singles covid19#patron"

// CHANGES FOR FULL SAMPLE <<<<<<<<<------------------------------------------
*use "$datos/cp_w1a8.dta", clear
// impuestos
*global vars_txc "tax2020 tax2021 " 
// interacciones
//global v_txc_singles "tax2020#singles tax2021#singles"
//global v_txc_patron "tax2020#patron tax2021#patron"
//global v_txc_tipo "tax2020#i.tipo tax2021#i.tipo"

*global mod = "_lineal_iwave"

// CHANGES FOR BALANCED SAMPLE IN 4 TO 6 <<<<<<<<<------------------------------------------
use "$datos/cp_w456balanc.dta", clear
// impuestos
global vars_txc "tax2020 " 
// interacciones
global v_txc_singles "tax2020#singles "
global v_txc_patron "tax2020#patron "
global v_txc_tipo "tax2020#i.tipo "

global mod = "_balanc_iwave"

/***************************************************************************/
// 1.0 MODELOS
// 1.2 MODELOS ajustes variables agrupadas

// regress
regress $depvar $vars_reg i.wave if $seleccion
// FE:
xtreg $depvar $vars_reg i.wave if $seleccion, fe
estimates store fixed
*xttest2
/*Error: too few common observations across panel.
no observations
r(2000);*/
// RE:
xtreg $depvar $vars_reg i.wave if $seleccion, re
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
regress $depvar $vars_txc $vars_reg i.wave if $seleccion
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel replace

// estimación panel
xtreg $depvar $vars_txc $vars_reg i.wave if $seleccion, fe
outreg2 using "resultados/encuesta/mods_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/

xtreg $depvar $vars_txc $vars_reg i.wave if $seleccion, re
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
// 1.3a MODELOS interacciones, patron * tax

// modelo
regress  $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion
outreg2 using "resultados/encuesta/mods_tipo_$depvar$mod", word excel replace

// pruebas
*testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion, fe
outreg2 using "resultados/encuesta/mods_tipo_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
*testparm $v_txc_patron // no se rechaza igualdad

xtreg $depvar $v_txc_tipo $v_tipo i.wave#i.tipo if $seleccion, re
outreg2 using "resultados/encuesta/mods_tipo_$depvar$mod", word excel append

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
outreg2 using "resultados/encuesta/mods_patron_$depvar$mod", word excel replace

// pruebas
//testparm i.tipo // se rechaza igualdad
//testparm tax2020#i.tipo // no se rechaza igualdad
//testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad
// singles
*testparm $v_txc_patron // no se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_patron $v_patron i.wave##patron  if $seleccion, fe
outreg2 using "resultados/encuesta/mods_patron_$depvar$mod", word excel append

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
outreg2 using "resultados/encuesta/mods_patron_$depvar$mod", word excel append

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
outreg2 using "resultados/encuesta/mods_singles_$depvar$mod", word excel replace

// pruebas
// singles
*testparm $v_txc_singles // Sí se rechaza igualdad

// estimación panel
xtreg $depvar $v_txc_singles $v_singles i.wave##singles if $seleccion, fe
outreg2 using "resultados/encuesta/mods_singles_$depvar$mod", word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
*testparm $v_txc_singles // no se rechaza igualdad

xtreg $depvar $v_txc_singles $v_singles i.wave##singles if $seleccion, re
outreg2 using "resultados/encuesta/mods_singles_$depvar$mod", word excel append

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

