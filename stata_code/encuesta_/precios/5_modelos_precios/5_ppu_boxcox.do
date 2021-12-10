
/* para logit-binomial
xtgee qalead `confusores1' if sampleqa==1, family(binomial) link(logit) corr(exchangeable) i(id) robust eform
*/

set more off

capture log close

/// precios
*use "$datos/cp_w1a8.dta", clear
// CHANGES FOR FULL SAMPLE
log using "resultados/encuesta/est_boxcox_ppu.log", replace
use "$datos/cp_w1a8.dta", clear
// CHANGES FOR BALANCED SAMPLE IN 4 TO 6
*log using "resultados/encuesta/xtgee_ppu_balanc.log", replace
*use "$datos/cp_w456balanc.dta", clear

global mod = "boxcox"

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
