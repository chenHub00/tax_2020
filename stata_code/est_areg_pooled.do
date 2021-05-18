
// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg_pooled.log, replace

use datos\panel_marca_ciudad.dta, clear

// unitroot test, on levels
xtunitroot fisher ppu, dfuller lags(4)

xtreg ppu m1_20 m1 ym, fe
estimates store fixed
// F : fixed effects are significant
// di  e(F_f)
// 385.7471
xtreg ppu m1_20 m1 ym, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// 
// predict est_ppu_ym_fe, xb
predict error_ppu_ym_re, e

xtunitroot fisher error_ppu_ym_re, dfuller lags(4)

regress ppu m1_20 m1 ym i.gr_marca_ciudad 
testparm i.gr_marca_ciudad 

areg ppu m1 m1_20 ym i.marca, absorb(cve_ciudad)
testparm i.marca 
areg ppu m1 m1_20 ym i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad 

// por marca
use datos\panel_marca_ciudad.dta if marca == 1, clear

xtreg ppu m1_20 m1 ym , fe
//xtset cve_ciudad ym 

use datos\panel_marca_ciudad.dta, clear
xtreg ppu m1_20 m1 ym if marca == 1, fe
estimates store fixed
outreg2 using resultados/doc/est_xt_marcas ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtreg ppu m1_20 m1 ym, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
hausman fixed random 

predict error_ppu_ym_re, e
xtunitroot fisher error_ppu_ym_re, dfuller lags(4)

*xtunitroot fisher ppu, dfuller lags(4)

foreach number of numlist 2/4 {
local number = 2
	di "`number'"

//	use datos\panel_marca_ciudad.dta if marca == `number', clear

//	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	//xtreg ppu m1_20 m1 ym, fe
	xtreg ppu m1_20 m1 ym if marca == `number', fe
	estimates store fixed`number'
	outreg2 using resultados/doc/est_xt_marcas ///
				, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

	xtreg ppu m1_20 m1 ym, re
	estimates store random
	xttest0 
	* significance of random effects
	* Hausmann Test
	hausman fixed random 

	predict error_ppu_ym_re, e
	xtunitroot fisher error_ppu_ym_re, dfuller lags(4)
}

local number = 5 
di "`number'"

use datos\panel_marca_ciudad.dta if marca == `number', clear

xtset cve_ciudad ym 
// gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym, fe
estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_p2 ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtreg ppu m1_20 m1 ym, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
hausman fixed random 

predict error_ppu_ym_re, e
xtunitroot fisher error_ppu_ym_re, dfuller lags(4)

foreach number of numlist 6 7 {
	di "`number'"

	use datos\panel_marca_ciudad.dta if marca == `number', clear

	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	xtreg ppu m1_20 m1 ym, fe
	estimates store fixed
	outreg2 using resultados/doc/est_xt_marcas_p2 ///
				, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

	xtreg ppu m1_20 m1 ym, re
	estimates store random
	xttest0 
	* significance of random effects
	* Hausmann Test
	hausman fixed random 

	predict error_ppu_ym_re, e
	xtunitroot fisher error_ppu_ym_re, dfuller lags(4)
}

// 18/05/21
// Prueba de diferencia de coeficiente de inter'es
// Pooled 
xtreg ppu m1_20 i.marca#m1_20 m1 ym, fe

asdoc testparm i.marca#m1_20, save(resultados/doc/est_areg_pooled) replace

					
log close

