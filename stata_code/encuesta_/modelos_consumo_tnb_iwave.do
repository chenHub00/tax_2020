// cd al directorio raiz
set more off

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

global mod = "w1a8_tnb_iwave"
global depvar "cons_sem"

capture log close
log using "$resultados/modelos_cons$mod.log", replace

//use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cons_w_1to8.dta", clear

/***************************************************************************/
// 1.0 MODELOS
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
// 1.2 MODELOS ajustes variables agrupadas
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"

tnbreg $depvar $vars_reg if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel replace

/***************************************************************************/
// 1.1 MODELOS
// 1.2 MODELOS ajustes variables agrupadas
global vars_txc "tax2020 covid19" 

// modelo
tnbreg $depvar $vars_txc $vars_reg i.wave if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel append

/***************************************************************************/
// 1.3 MODELOS interacciones, patron and singles interaction
global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
global v_txc_singles "tax2020#singles tax2020_sexo#singles"
global v_txc_patron "tax2020#patron tax2020_sexo#patron"
global v_covid19 "covid19#singles covid19_sexo#singles covid19#patron covid19_sexo#patron"

// 1.3a MODELOS interacciones, patron * tax
// modelo
tnbreg $depvar $v_txc_patron $vars_reg $v_covid19 i.wave if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel append

// pruebas
testparm $v_txc_patron // no se rechaza igualdad

// 1.3b MODELOS interacciones, patron * vars
tnbreg $depvar $v_patron $v_txc_patron $v_covid19 i.wave if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel append

// pruebas
testparm $v_txc_patron // no se rechaza igualdad

// 1.3c MODELOS interacciones, singles * tax

tnbreg $depvar $v_txc_singles $v_reg $v_covid19 i.wave if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel append

// pruebas
testparm $v_txc_singles // Sí se rechaza igualdad
/*
. testparm $v_txc_singles // No se rechaza igualdad

 ( 1)  [cons_sem]0b.tax2020#1.singles = 0
 ( 2)  [cons_sem]1.tax2020#0b.singles = 0
 ( 3)  [cons_sem]1.tax2020#1.singles = 0
 ( 4)  [cons_sem]0b.tax2020_sexo#1.singles = 0
 ( 5)  [cons_sem]1.tax2020_sexo#0b.singles = 0

           chi2(  5) =  157.66
         Prob > chi2 =    0.0000

*/

// 1.3d MODELOS interacciones, singles * vars

tnbreg $depvar $v_singles $v_txc_singles $v_covid19 i.wave if has_fumado_1mes
outreg2 using resultados/encuesta/mods_consumo_$mod, word excel append

// pruebas
testparm $v_txc_singles // No se rechaza igualdad

/*
. testparm $v_txc_singles // No se rechaza igualdad

 ( 1)  [cons_sem]0b.tax2020#1.singles = 0
 ( 2)  [cons_sem]1.tax2020#0b.singles = 0
 ( 3)  [cons_sem]0b.tax2020_sexo#1.singles = 0
 ( 4)  [cons_sem]1.tax2020_sexo#0b.singles = 0

           chi2(  4) =    1.42
         Prob > chi2 =    0.8410
*/
log close

