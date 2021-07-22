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
putexcel (E1) = "gl Numerator/gl_chi"
putexcel (D1) = "F/chi2"
putexcel (F1) = "prob > F/ Prob > chi2"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

// unitroot test, on levels
/*xtunitroot fisher ppu, dfuller lags(4)
xtunitroot fisher ppu, dfuller lags(4) trend
xtunitroot fisher ppu, dfuller lags(4) drift*/

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
predict error_ppu_ym_re, e

xtunitroot fisher error_ppu_ym_re, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) drift

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic, re
testparm i.marca
putexcel (A2) = "marca"
putexcel (C2) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace

/*****************************************/
xtreg ppu i.marca $varsRegStatic i.marca#m1_20 i.marca#m1_21, fe
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg ppu i.marca $varsRegStatic i.marca#m1_20 i.marca#m1_21, re
estimates store random
xttest0 
// no OLS
hausman fixed random , sigmamore
/*  chi2(15) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       83.08
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)*/
// 
//xtoverid
/*1b:  operator invalid
r(198); 
//xtoverid,  cluster(gr_)
*/
xtreg ppu i.marca $varsRegStatic i.marca##m1_20 i.marca##m1_21, re
// testparm i.marca
// F test that all u_i=0: F(262, 23647) = 343.10                Prob > F = 0.0000
putexcel (A3) = "impuesto y marca"
putexcel (C3) = rscalars, colwise overwritefmt
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

// doing the estimation for each brand most are fixed effects

xtreg ppu i.marca $varsRegStatic i.marca##m1_20 i.marca##m1_21, fe
// testparm i.marca
// F test that all u_i=0: F(262, 23647) = 343.10                Prob > F = 0.0000
putexcel (A10) = "impuesto y marca"
// putexcel (C3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
putexcel (C10) =  `e(df_r)' // =  13266
putexcel (D10) =  `e(F_f)' // =  22.31938299622964
putexcel (E10) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F10) = F_ui

testparm m1_20#i.marca
putexcel (H10) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N1) = "marca con impuesto 2021"
putexcel (N10) = rscalars, colwise overwritefmt
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
predict error_ppu_ym_fe_t1, e

xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4)
xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4) drift
// no se puede rechazar raiz unitaria en todos los paneles 
// (i es combinación de ciudad y marca)
// excepto drift: cambio en nivel

// hausman favorece efectos individuales fijos
xtreg ppu i.marca $varsRegStatic if tipo == 1, fe
// F test that all u_i=0: F(125, 13266) = 22.32                 Prob > F = 0.0000
// testparm i.marca
putexcel (A4) = "Alto"
// putexcel (B4) = rscalars, colwise overwritefmt 
// para efectos fijos anoto el resultado
putexcel (C4) =  `e(df_r)' // =  13266
putexcel (D4) =  `e(F_f)' // =  22.31938299622964
putexcel (E4) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F4) = F_ui
// Ftail(`e(df_a)',`e(df_r)',`e(F_f)') // =  0

// H0: igualdad de parametros 

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace
// interacciones marca e impuestos
xtreg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 1, fe
//testparm i.marca
putexcel (A5) = "Alto: con interacción marca e impuestos"
//putexcel (B5) = rscalars, colwise overwritefmt
// para efectos fijos anoto el resultado
putexcel (C5) =  `e(df_r)' // =  13266
putexcel (D5) =  `e(F_f)' // =  22.31938299622964
putexcel (E5) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F5) = F_ui

testparm m1_20#i.marca
putexcel (H5) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N5) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			
// ************ Medio
xtreg ppu i.marca $varsRegStatic if tipo == 2, fe
estimates store fixed
// xttest2: Error: too few common observations across panel.
// cannot decide over 
// F : fixed effects are significant
// di  e(F_f)
// 22.319383
xtreg ppu i.marca $varsRegStatic if tipo == 2, re
estimates store random
// xttest0 
// invalid syntax
// r(111);

* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// No se rechaza de efectos aleatorios
predict error_ppu_ym_re_t2, e

xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4) drift
// no se puede rechazar raiz unitaria en todos los paneles 
// (i es combinación de ciudad y marca)
// excepto drift: cambio en nivel

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic if tipo == 2, re
testparm i.marca
putexcel (A6) = "Medio"
putexcel (C6) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo de igualdad de parametros

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append
// interacciones marca e impuestos
xtreg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 2, re
testparm i.marca

putexcel (A7) = "Medio: con interacción marca e impuestos"
putexcel (C7) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (I7) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (O7) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append

// ************ Bajo
xtreg ppu i.marca $varsRegStatic if tipo == 3, fe
estimates store fixed
// xttest2  : Error: too few common observations across panel.
// cannot decide over 
// F : fixed effects are significant
// F test that all u_i=0: F(56, 3849) = 41.93                   Prob > F = 0.0000
xtreg ppu i.marca $varsRegStatic if tipo == 3, re
estimates store random
xttest0 
// Rechazo OLS
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechaza efectos aleatorios
predict error_ppu_ym_fe_t3, e

xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4)
xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4) drift
// no se puede rechazar raiz unitaria en todos los paneles 
// (i es combinación de ciudad y marca)
// excepto drift: cambio en nivel

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic if tipo == 3, fe
//testparm i.marca
putexcel (A8) = "Bajo"
//putexcel (B8) = rscalars, colwise overwritefmt
// para efectos fijos anoto el resultado
putexcel (C8) =  `e(df_r)' // =  13266
putexcel (D8) =  `e(F_f)' // =  22.31938299622964
putexcel (E8) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F8) = F_ui

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append
// interacciones marca e impuestos
xtreg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 3, fe
//testparm i.marca

putexcel (A9) = "Bajo: con interacción marca e impuestos"
//putexcel (B9) = rscalars, colwise overwritefmt
putexcel (C9) =  `e(df_r)' // =  13266
putexcel (D9) =  `e(F_f)' // =  22.31938299622964
putexcel (E9) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F9) = F_ui

testparm m1_20#i.marca
putexcel (H9) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N9) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append

capture log close
