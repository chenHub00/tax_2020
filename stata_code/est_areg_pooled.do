
// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
set more off

capture log close
log using resultados/est_areg_pooled.log, replace

global varsRegStatic "m1_20 m1_21 m1 ym"
putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator"
putexcel (D1) = "F"
putexcel (F1) = "prob > F"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

// unitroot test, on levels
xtunitroot fisher ppu, dfuller lags(4)
xtunitroot fisher ppu, dfuller lags(4) trend
xtunitroot fisher ppu, dfuller lags(4) drift

// i.marca no se puede estimar en fe, es co-linear
xtreg ppu $varsRegStatic , fe 
estimates store fixed
// xttest2: Error: too few common observations across panel.
// F : fixed effects are significant
// di  e(F_f)
// 385.7471
xtreg ppu $varsRegStatic, re
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
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) drift

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic, re
testparm i.marca
putexcel (A2) = "marca"
putexcel (B2) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace

xtreg ppu i.marca $varsRegStatic i.marca#m1_20 i.marca#m1_21, re
testparm i.marca
putexcel (A3) = "impuesto y marca"
putexcel (B3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

testparm m1_20#i.marca
putexcel (H1) = "marca con impuesto 2020"
putexcel (H3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N1) = "marca con impuesto 2021"
putexcel (N3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

outreg2 using resultados\doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca i.marca#m1_20 i.marca#m1_21) bdec(3) tex(fragment) append
			
/* modelo estimado con los m'etodos previos
regress ppu $varsRegStatic i.gr_marca_ciudad 
testparm i.gr_marca_ciudad 

areg ppu $varsRegStatic i.marca, absorb(cve_ciudad)
testparm i.marca 
areg ppu $varsRegStatic i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad 
*/
//
xtreg ppu m1_20 m1_21 m1 i.marca i.month i.year, re
*areg ppu m1_20 m1_21 m1 i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_xtreg_total ///
			, keep(m1_20 m1_21 m1 i.marca) bdec(3) tex(fragment) append
			
* dummies para mes y anio, con interacciones
xtreg ppu i.marca m1_20 m1_21 m1_20##i.marca m1_21##i.marca m1 i.month i.year, re
*areg ppu i.marca m1_20 m1_21 m1_20##i.marca m1_21##i.marca m1 i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_xtreg_total ///
			, keep(i.marca m1_20 m1_21 m1_20##i.marca m1_21##i.marca m1) bdec(3) tex(fragment) append

testparm m1_20#i.marca
testparm m1_21#i.marca


// *******************************************************
// por tipo o segmento
// *******************************************************
xtreg ppu i.marca $varsRegStatic if tipo == 1, fe
estimates store fixed
// xttest2: Error: too few common observations across panel.
// cannot decide over 
// F : fixed effects are significant
// di  e(F_f)
// 22.319383
xtreg ppu i.marca $varsRegStatic if tipo == 1, re
estimates store random
xttest0 
// rules out OLS
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// rechazo de efectos aleatorios!
// predict est_ppu_ym_fe, xb
predict error_ppu_ym_re_t1, e

xtunitroot fisher error_ppu_ym_re_t1, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re_t1, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re_t1, dfuller lags(4) drift
// no se puede rechazar raiz unitaria en todos los paneles 
// (i es combinación de ciudad y marca)
// excepto drift: cambio en nivel

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic if tipo == 1, fe
testparm i.marca
putexcel (A4) = "Alto"
putexcel (B4) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace
// interacciones marca e impuestos
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 1, absorb(cve_ciudad)
testparm i.marca

putexcel (A5) = "Alto: con interacción marca e impuestos"
putexcel (B5) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H5) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N5) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			


// *******************************************************
// por marca
// *******************************************************
// use datos\panel_marca_ciudad.dta if marca == 1, clear

// xtreg ppu m1_20 m1 ym , fe
//xtset cve_ciudad ym 

*use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear
xtreg ppu $varsRegStatic if marca == 1, fe
estimates store fixed1
outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace

xtreg ppu $varsRegStatic if marca == 1, re
estimates store random1
xttest0 
* significance of random effects
* Hausmann Test
hausman fixed1 random1 

predict error_ppu_ym_re1, e
xtunitroot fisher error_ppu_ym_re1, dfuller lags(4)

*xtunitroot fisher ppu, dfuller lags(4)

foreach number of numlist 2/4 {
	di "`number'"

//	use datos\panel_marca_ciudad.dta if marca == `number', clear

//	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	//xtreg ppu m1_20 m1 ym, fe
	xtreg ppu $varsRegStatic if marca == `number', fe
	estimates store fixed`number'
	outreg2 using resultados/doc/est_xt_marcas ///
				, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append

	xtreg ppu $varsRegStatic, re
	estimates store random`number'
	xttest0 
	* significance of random effects
	* Hausmann Test
	hausman fixed`number' random`number' 

	predict error_ppu_ym_re`number', e
	xtunitroot fisher error_ppu_ym_re`number', dfuller lags(4)
}

local number = 5 
di "`number'"

*use datos\panel_marca_ciudad.dta if marca == `number', clear

//xtset cve_ciudad ym 
// gen dif_ppu = d.ppu

xtreg ppu $varsRegStatic if marca == `number', fe
estimates store fixed`number'
* HORiZONTAL
outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append
* VERTICAL
			*outreg2 using resultados/doc/est_xt_marcas_p2 ///
*			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtreg ppu $varsRegStatic if marca == `number', re
estimates store random`number'
xttest0 
* significance of random effects
* Hausmann Test
hausman fixed`number' random`number' 

predict error_ppu_ym_re`number', e
xtunitroot fisher error_ppu_ym_re`number', dfuller lags(4)

foreach number of numlist 6 7 {
	di "`number'"

*	use datos\panel_marca_ciudad.dta if marca == `number', clear

*	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	xtreg ppu $varsRegStatic if marca == `number', fe
	estimates store fixed`number'
* HORiZONTAL
outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append
* VERTICAL
			*outreg2 using resultados/doc/est_xt_marcas_p2 ///
*				, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

	xtreg ppu $varsRegStatic if marca == `number', re

	estimates store random`number'
	xttest0 
	* significance of random effects
	* Hausmann Test
	hausman fixed`number' random`number' 

	predict error_ppu_ym_re`number', e
	xtunitroot fisher error_ppu_ym_re`number', dfuller lags(4)
}

// 18/05/21
// Prueba de diferencia de coeficiente de inter'es
// Pooled 
*xtreg ppu m1_20 i.marca#m1_20 m1 ym, fe
xtreg ppu m1_20 m1_21 i.marca#m1_20 i.marca#m1_21 m1 ym, fe

asdoc testparm i.marca#m1_20, save(resultados/doc/est_areg_pooled) replace

					
log close

