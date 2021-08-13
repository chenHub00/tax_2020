// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
set more off

capture log close
log using resultados/est_areg_pooled.log, replace

global varsRegStatic "jan20 jan21 jan ym"

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
/* Resultados de la prueba de Hausman */
putexcel set "resultados\doc\hausman_xtreg_pooled.xlsx", sheet(hausman_xtreg_dyn, replace) modify
putexcel (C1) = "No interactions"
putexcel (B2) = "Name"
putexcel (C2) = "Eq 1"
putexcel (B3) = rscalarnames
putexcel (C3) = rscalars
// RANDOM
predict error_ppu_ym_re, e

putexcel set "resultados\doc\uroot_xtreg_pooled.xlsx", sheet(unitroot_xtreg_pool, replace) modify
*xtunitroot fisher error_ppu_ym_re, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) trend
putexcel (C1) = "No interactions"
putexcel (C3) = "Inverse chi-squared (df)"
putexcel (C4) = "Inverse normal"
putexcel (C5) = "Inverse logit t(df)"
putexcel (C6) = "Modified inv. chi-squared"
putexcel (D2) = "Name"
putexcel (E2) = "Statistic"
putexcel (F2) = "df"
putexcel (G2) = "p-value"
putexcel (D3) = "P"
putexcel (D4) = "Z"
putexcel (D5) = "L*"
putexcel (D6) = "Pm"
putexcel (E3) = `r(P)'
putexcel (E4) = `r(Z)'
putexcel (E5) = `r(L)'
putexcel (E6) = `r(Pm)'
putexcel (F3) = `r(df_P)'
putexcel (F5) = `r(df_L)'
putexcel (G3) = `r(p_P)'
putexcel (G4) = `r(p_Z)'
putexcel (G5) = `r(p_L)'
putexcel (G6) = `r(p_Pm)'
/*
P	r(P) = 	r(df_P) = 	r(p_P) = 
Z	r(Z) = 	r(p_Z) =	
L*	 r(L) = 	r(df_L) =	r(p_L) = 
Pm	r(Pm) = 	r(p_Pm) =  	
*/
xtunitroot fisher error_ppu_ym_re, dfuller lags(4) drift
putexcel (E7) = `r(P)'
putexcel (E8) = `r(Z)'
putexcel (E9) = `r(L)'
putexcel (E10) = `r(Pm)'
putexcel (F7) = `r(df_P)'
putexcel (F9) = `r(df_L)'
putexcel (G7) = `r(p_P)'
putexcel (G8) = `r(p_Z)'
putexcel (G9) = `r(p_L)'
putexcel (G10) = `r(p_Pm)'

putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg) modify

// hausman favorece efectos individuales aleatorios
xtreg ppu i.marca $varsRegStatic, re
testparm i.marca
putexcel (A2) = "marca"
putexcel (C2) = rscalars, colwise overwritefmt

outreg2 using resultados/doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace

/*****************************************/
xtreg ppu i.marca $varsRegStatic i.marca#jan20 i.marca#jan21, fe
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg ppu i.marca $varsRegStatic i.marca#jan20 i.marca#jan21, re
estimates store random
xttest0 
// no OLS
hausman fixed random , sigmamore
/*  chi2(15) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       83.08
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)*/
// 
putexcel set "resultados\doc\hausman_xtreg_pooled.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (D1) = "Interacciones"
putexcel (D2) = "Eq 2"
putexcel (D3) = rscalars

putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg) modify

//xtoverid
/*1b:  operator invalid
r(198); 
//xtoverid,  cluster(gr_)
*/
xtreg ppu i.marca $varsRegStatic i.marca##jan20 i.marca##jan21, re
testparm i.marca
// F test that all u_i=0: F(262, 23647) = 343.10                Prob > F = 0.0000
putexcel (A3) = "impuesto y marca"
putexcel (C3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

testparm jan20#i.marca
putexcel (H1) = "marca con impuesto 2020"
putexcel (I3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (N1) = "marca con impuesto 2021"
putexcel (O3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

outreg2 using resultados\doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca i.marca#jan20 i.marca#jan21) bdec(3) tex(fragment) append

// doing the estimation for each brand most are fixed effects

xtreg ppu i.marca $varsRegStatic i.marca##jan20 i.marca##jan21, fe
// testparm i.marca
// F test that all u_i=0: F(262, 23647) = 343.10                Prob > F = 0.0000
putexcel (A10) = "impuesto y marca> fe"
// putexcel (C3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
putexcel (C10) =  `e(df_r)' // =  13266
putexcel (D10) =  `e(F_f)' // =  22.31938299622964
putexcel (E10) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F10) = F_ui

testparm jan20#i.marca
putexcel (H10) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (N1) = "marca con impuesto 2021"
putexcel (N10) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

outreg2 using resultados\doc/est_xtreg_total ///
			, keep($varsRegStatic i.marca i.marca#jan20 i.marca#jan21) bdec(3) tex(fragment) append
			
/* modelo estimado con los m'etodos previos
regress ppu $varsRegStatic i.gr_marca_ciudad 
testparm i.gr_marca_ciudad 

areg ppu $varsRegStatic i.marca, absorb(cve_ciudad)
testparm i.marca 
areg ppu $varsRegStatic i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad 
*/
//
xtreg ppu jan20 jan21 jan i.marca i.month i.year, re
*areg ppu jan20 jan21 jan i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_xtreg_total ///
			, keep(jan20 jan21 jan i.marca) bdec(3) tex(fragment) append
			
* dummies para mes y anio, con interacciones
xtreg ppu i.marca jan20 jan21 jan20##i.marca jan21##i.marca jan i.month i.year, re
*areg ppu i.marca jan20 jan21 jan20##i.marca jan21##i.marca jan i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_xtreg_total ///
			, keep(i.marca jan20 jan21 jan20##i.marca jan21##i.marca jan) bdec(3) tex(fragment) append

testparm jan20#i.marca
testparm jan21#i.marca


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
putexcel set "resultados\doc\hausman_xtreg_pooled.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (E1) = "Alto"
putexcel (E2) = "Eq 2"
putexcel (E3) = rscalars

xtreg ppu i.marca $varsRegStatic if tipo == 1, fe
predict error_ppu_ym_fe_t1, e

*xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4)
putexcel set "resultados\doc\uroot_xtreg_pooled.xlsx", sheet(unitroot_xtreg_pool) modify
putexcel (H1) = "Alto"
xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4) trend
putexcel (H3) = `r(P)'
putexcel (H4) = `r(Z)'
putexcel (H5) = `r(L)'
putexcel (H6) = `r(Pm)'
putexcel (I3) = `r(df_P)'
putexcel (I5) = `r(df_L)'
putexcel (J3) = `r(p_P)'
putexcel (J4) = `r(p_Z)'
putexcel (J5) = `r(p_L)'
putexcel (J6) = `r(p_Pm)'
xtunitroot fisher error_ppu_ym_fe_t1, dfuller lags(4) drift
putexcel (H7) = `r(P)'
putexcel (H8) = `r(Z)'
putexcel (H9) = `r(L)'
putexcel (H10) = `r(Pm)'
putexcel (I7) = `r(df_P)'
putexcel (I9) = `r(df_L)'
putexcel (J7) = `r(p_P)'
putexcel (J8) = `r(p_Z)'
putexcel (J9) = `r(p_L)'
putexcel (J10) = `r(p_Pm)'

putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg) modify

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
xtreg ppu i.marca jan20##i.marca jan21##i.marca jan ym if tipo == 1, fe
//testparm i.marca
putexcel (A5) = "Alto: con interacción marca e impuestos"
//putexcel (B5) = rscalars, colwise overwritefmt
// para efectos fijos anoto el resultado
putexcel (C5) =  `e(df_r)' // =  13266
putexcel (D5) =  `e(F_f)' // =  22.31938299622964
putexcel (E5) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F5) = F_ui

testparm jan20#i.marca
putexcel (H5) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (N5) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca jan20##i.marca jan21##i.marca jan ym) bdec(3) tex(fragment) append
			
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
putexcel set "resultados\doc\hausman_xtreg_pooled.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (F1) = "Medio"
putexcel (F2) = "Eq 2"
putexcel (F3) = rscalars


predict error_ppu_ym_re_t2, e

*xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4)
putexcel set "resultados\doc\uroot_xtreg_pooled.xlsx", sheet(unitroot_xtreg_pool) modify
putexcel (K1) = "Medio"
xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4) trend
putexcel (K3) = `r(P)'
putexcel (K4) = `r(Z)'
putexcel (K5) = `r(L)'
putexcel (K6) = `r(Pm)'
putexcel (L3) = `r(df_P)'
putexcel (L5) = `r(df_L)'
putexcel (M3) = `r(p_P)'
putexcel (M4) = `r(p_Z)'
putexcel (M5) = `r(p_L)'
putexcel (M6) = `r(p_Pm)'
xtunitroot fisher error_ppu_ym_re_t2, dfuller lags(4) drift
putexcel (K7) = `r(P)'
putexcel (K8) = `r(Z)'
putexcel (K9) = `r(L)'
putexcel (K10) = `r(Pm)'
putexcel (L7) = `r(df_P)'
putexcel (L9) = `r(df_L)'
putexcel (M7) = `r(p_P)'
putexcel (M8) = `r(p_Z)'
putexcel (M9) = `r(p_L)'
putexcel (M10) = `r(p_Pm)'

putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg) modify
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
xtreg ppu i.marca jan20##i.marca jan21##i.marca jan ym if tipo == 2, re
testparm i.marca

putexcel (A7) = "Medio: con interacción marca e impuestos"
putexcel (C7) = rscalars, colwise overwritefmt

testparm jan20#i.marca
putexcel (I7) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (O7) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca jan20##i.marca jan21##i.marca jan ym) bdec(3) tex(fragment) append

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
putexcel set "resultados\doc\hausman_xtreg_pooled.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (G1) = "Lower"
putexcel (G2) = "Eq 2"
putexcel (G3) = rscalars


predict error_ppu_ym_fe_t3, e

*xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4)
putexcel set "resultados\doc\uroot_xtreg_pooled.xlsx", sheet(unitroot_xtreg_pool) modify
putexcel (N1) = "Bajo"
xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4) trend
putexcel (N3) = `r(P)'
putexcel (N4) = `r(Z)'
putexcel (N5) = `r(L)'
putexcel (N6) = `r(Pm)'
putexcel (O3) = `r(df_P)'
putexcel (O5) = `r(df_L)'
putexcel (P3) = `r(p_P)'
putexcel (P4) = `r(p_Z)'
putexcel (P5) = `r(p_L)'
putexcel (P6) = `r(p_Pm)'
xtunitroot fisher error_ppu_ym_fe_t3, dfuller lags(4) drift
putexcel (N7) = `r(P)'
putexcel (N8) = `r(Z)'
putexcel (N9) = `r(L)'
putexcel (N10) = `r(Pm)'
putexcel (O7) = `r(df_P)'
putexcel (O9) = `r(df_L)'
putexcel (P7) = `r(p_P)'
putexcel (P8) = `r(p_Z)'
putexcel (P9) = `r(p_L)'
putexcel (P10) = `r(p_Pm)'

putexcel set "resultados\doc\f_tests_xtreg_pooled.xlsx", sheet(xtreg) modify
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
xtreg ppu i.marca jan20##i.marca jan21##i.marca jan ym if tipo == 3, fe
//testparm i.marca

putexcel (A9) = "Bajo: con interacción marca e impuestos"
//putexcel (B9) = rscalars, colwise overwritefmt
putexcel (C9) =  `e(df_r)' // =  13266
putexcel (D9) =  `e(F_f)' // =  22.31938299622964
putexcel (E9) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F9) = F_ui

testparm jan20#i.marca
putexcel (H9) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (N9) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_xtreg_tipo ///
			, keep(i.marca jan20##i.marca jan21##i.marca jan ym) bdec(3) tex(fragment) append


capture log close
