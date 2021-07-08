
// se separan las estimaciones xtreg
// definiendo panel por combinación de marca y ciudad
// estimaciones por marca

set more off
 
capture log close
log using resultados/est_areg_pooled_lags.log, replace

global varsReg "m1_20 m1_21 m1 ym L.ppu"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

gen dif_ppu = d.ppu
gen ppu100 = 100*ppu

// inicial 
xtreg ppu m1_20 m1 ym L.ppu, fe
// actualizado junio (con datos de abril)
xtreg ppu $varsReg, fe

//testparm ym L.ppu
//testparm L.ppu
//xtreg ppu m1_20 m1 ym, fe
estimates store fixed
xtreg ppu $varsReg, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// fixed effects
xtreg ppu $varsReg, fe

predict error_ppu_ym_fe, e
xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)
// Sin presencia de ra'iz unitaria

areg ppu $varsReg i.marca, absorb(cve_ciudad)
testparm i.marca 
// por marca son significativamente diferentes
areg ppu $varsReg i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad 

// por ciudad no son significativos
// un mismo coeficiente para cada ciudad,
// ? take the mean by city 
// ? take the random effects on city or brand
// sort marca 

xtreg ppu $varsReg if marca == 1, fe
estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_lags ///
			, keep($varsReg) bdec(3) nocons  tex(fragment) replace

xtreg ppu $varsReg, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// fixed effects
xtreg ppu $varsReg, fe

predict error_ppu_ym_fe1, e
xtunitroot fisher error_ppu_ym_fe1, dfuller lags(4)

/*
preserve 
keep if marca == 1
restore
*/

foreach number of numlist 2/7 {
di "`number'"

xtreg ppu $varsReg if marca == `number', fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_lags ///
			, keep($varsReg) bdec(3) nocons  tex(fragment) append

xtreg ppu $varsReg, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// fixed effects
xtreg ppu $varsReg, fe

predict error_ppu_ym_fe`number', e
xtunitroot fisher error_ppu_ym_fe`number', dfuller lags(4)
}
					
log close

