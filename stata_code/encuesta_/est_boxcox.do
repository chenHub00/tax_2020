
/* para logit-binomial
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform
*/

set more off

capture log close
log using "resultados/encuesta/est_boxcox.log", replace

do stata_code/encuesta_/dir_encuesta.do

global seleccion " educ_gr3 != 9 & ingr_gr != 99"

// por dìa
//global mod = "w1a8_iwave_patron_singles"
//global depvar "cons_por_dia"
// semanal
global mod = "boxcox"
global depvar "consumo_semanal"

// regresiones
global vars_reg "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave patron singles"
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

*boxcox $depvar $vars_txc $vars_regpatron if $seleccion
* factor variables not allowed
* $vars_txc 
*xi i.tax2020 i.tax2021, prefix(txc_)
* vars_regpatron "sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave singles"
xi i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)

* 4 models, most general is theta
regress $depvar $vars_txc $vars_reg if $seleccion

regress $depvar $vars_txc sexo vr_* singles patron if $seleccion
outreg2 using resultados/encuesta/$mod$depvar, word excel replace

* default is left-hand-side
* lrtest para "significancia" de las variables independientes
boxcox $depvar $vars_txc sexo vr_* singles patron if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* interacciones por patron 
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_txc_patron "tax2020#patron tax2021#patron"
xi i.edad_gr3*i.patron i.educ_gr3*i.patron i.ingr_gr*i.patron i.wave*i.patron, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo patron == 1 
xi i.edad_gr3*i.patron i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles  if $seleccion & patron == 1, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo patron == 0
xi i.edad_gr3*i.patron i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles  if $seleccion & patron == 0, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* interacciones por singles
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
xi i.edad_gr3*i.singles i.educ_gr3*i.singles i.ingr_gr*i.singles i.wave*i.singles, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo singles == 1 
xi i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron  if $seleccion & singles == 1, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo singles == 0
*xi i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron if $seleccion & singles == 0, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* only transform to the indepvars only
* boxcox $depvar $vars_txc vr_* singles if $seleccion, lrtest model(rhsonly)
* las variables dependientes deber'ian ser s'olo positivas en este caso
* mismo parametro
*boxcox $depvar $vars_txc vr_* singles if $seleccion, lrtest model(lambda)
* both las variables dependientes deber'ian ser s'olo positivas en este caso
*boxcox $depvar $vars_txc vr_* singles if $seleccion, lrtest model(theta)


/*--------------------------------------------------------------*/
/// precios
use "$datos/cp_w1a8.dta", clear
global depvar "ppu"

//regress
regress $depvar $vars_txc $vars_reg if $seleccion

xi i.sexo i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
regress $depvar $vars_txc sexo vr_* singles patron if $seleccion
outreg2 using resultados/encuesta/$mod$depvar, word excel replace

* default is left-hand-side
* lrtest para "significancia" de las variables independientes
boxcox $depvar $vars_txc sexo vr_* singles patron if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* interacciones por patron 
// global v_patron "sexo#patron i.edad_gr3#patron i.educ_gr3#patron i.ingr_gr#patron patron"
// global v_txc_patron "tax2020#patron tax2021#patron"
xi i.edad_gr3*i.patron i.educ_gr3*i.patron i.ingr_gr*i.patron i.wave*i.patron, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo patron == 1 
xi i.edad_gr3*i.patron i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles  if $seleccion & patron == 1, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo patron == 0
*xi i.edad_gr3*i.patron i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* singles  if $seleccion & patron == 0, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* interacciones por singles
// global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles singles"
// global v_txc_singles "tax2020#singles tax2021#singles"
xi i.edad_gr3*i.singles i.educ_gr3*i.singles i.ingr_gr*i.singles i.wave*i.singles, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron if $seleccion, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo singles == 1 
xi i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron  if $seleccion & singles == 1, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

* solo singles == 0
*xi i.edad_gr3 i.educ_gr3 i.ingr_gr i.wave, prefix(vr_)
boxcox $depvar $vars_txc sexo vr_* patron if $seleccion & singles == 0, lrtest
outreg2 using resultados/encuesta/$mod$depvar, word excel append

log close
