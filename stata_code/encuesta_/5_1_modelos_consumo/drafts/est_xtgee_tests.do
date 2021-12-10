
/* para logit-binomial
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform
*/


set more off

capture log close
log using "resultados/encuesta/est_xtgee_tests.log", replace

do stata_code/encuesta_/0_dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "w1a8_iwave_patron_singles"
//global depvar "cons_por_dia"
// semanal
global mod = "xtgee_patron"
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr patron singles"
global vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
global vars_regsingles "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron"
// impuestos
global vars_txc "tax2020 tax2021 " 
// // interacciones
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
// global v_txc_patron "tax2020#patron tax2021#patron"
// global v_covid19 "covid19#singles covid19#patron"

use "$datos/cons_w_1to8.dta", clear

regress $depvar $vars_txc $vars_regpatron if $seleccion

//regress
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, corr(independent)  nmp
// family(gaussian) link(nbinomial)
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(gaussian)  corr(independent)  nmp
 // vce options?
 
// General
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(nbinomial)  corr(exchangeable) i(id_num) robust eform
// link: log?

// link(nbinomial)?
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(nbinomial) link(nbinomial) corr(exchangeable) i(id_num) robust eform

// Population-averaged negative binomial regression of y2 on x3 and x4 equivalent to xtnbreg, pa
xtnbreg $depvar $vars_txc $vars_regpatron if $seleccion, pa
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(nbinomial 1)

// tobit
tnbreg $depvar $vars_txc $vars_regpatron if $seleccion
 
//On technical note:
// nbinomial log independent nbreg (see note 3)
// no tobit, no tobit negative binomial

log close
/*--------------------------------------------------------------
/// precios
use "$datos/cp_w1a8.dta", clear
global depvar "ppu"

//regress
regress $depvar $vars_txc $vars_regpatron if $seleccion
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, corr(independent)  nmp
// family(gaussian) link(nbinomial)
xtgee  $depvar $vars_txc $vars_regpatron if $seleccion, family(gaussian)  corr(independent)  nmp
 // vce options?
