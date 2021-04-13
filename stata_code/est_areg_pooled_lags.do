
// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg_pooled_lags.log, replace

use datos\panel_marca_ciudad.dta, clear

gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym L.ppu, fe
//testparm ym L.ppu
//testparm L.ppu
//xtreg ppu m1_20 m1 ym, fe
estimates store fixed
xtreg ppu m1_20 m1 ym, re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// fixed effects
xtreg ppu m1_20 m1 ym L.ppu, fe

predict error_ppu_ym_fe, e
xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)
// Sin presencia de ra'iz unitaria

areg ppu m1 m1_20 ym L.ppu i.marca, absorb(cve_ciudad)
testparm i.marca 
areg ppu m1 m1_20 ym L.ppu i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad 
// por ciudad no son significativos
// un mismo coeficiente para cada ciudad,
// ? take the mean by city 
// ? take the random effects on city or brand

// por marca
use datos\panel_marca_ciudad.dta if marca == 1, clear

gen dif_ppu = d.ppu

xtset cve_ciudad ym 

xtreg ppu m1_20 m1 ym L.ppu , fe
estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_lags ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtreg ppu m1_20 m1 ym L.ppu , re
estimates store random
xttest0 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// fixed effects
xtreg ppu m1_20 m1 ym L.ppu, fe

predict error_ppu_ym_fe, e
xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)

/*
xtunitroot fisher dif_ppu , dfuller lags(4)
xtreg dif_ppu m1_20 m1 ym, fe
*/

foreach number of numlist 2/4 {
di "`number'"

use datos\panel_marca_ciudad.dta if marca == `number', clear

xtset cve_ciudad ym 
// gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym L.ppu, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_lags ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

predict error_ppu_ym_fe, e
xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)
}

local number = 5 
di "`number'"

use datos\panel_marca_ciudad.dta if marca == `number', clear

xtset cve_ciudad ym 
// gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym L.ppu, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_lags_p2 ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

predict error_ppu_ym_fe, e
xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)

foreach number of numlist 6 7 {
	di "`number'"

	use datos\panel_marca_ciudad.dta if marca == `number', clear

	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	xtreg ppu m1_20 m1 ym L.ppu, fe
	*estimates store fixed
	outreg2 using resultados/doc/est_xt_marcas_p2 ///
				, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

	predict error_ppu_ym_fe, e
	xtunitroot fisher error_ppu_ym_fe, dfuller lags(4)
}

					
log close

