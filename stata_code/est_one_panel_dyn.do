// a partir de las estimaciones en:
// complete_panel_data.do 
set more off

capture log close
log using resultados/est_one_panel_dyn.log, replace

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

global varsRegStatic "m1_20 m1_21 m1 ym"
global varsReg_notrend "m1_20 m1_21 m1"
global varsRegDiff "m1_20 m1_21 m1 ym L.ppu"

putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator/gl_chi"
putexcel (D1) = "F/chi2"
putexcel (F1) = "prob > F/ Prob > chi2"

// xtreg ppu $varsRegStatic L.ppu, fe 
xtreg ppu $varsRegDiff, fe 

// F test that all u_i=0: F(261, 23349) = 1.60                  Prob > F = 0.0000
estimates store fixed

predict ppu_marcas_ymL
gen ppu_marcas_ymL_sq = ppu_marcas_ymL^2
* No se rechaza funciones de ppu
* referencia web:
* Pregibon test (https://www.jstor.org/stable/2346405):
* https://www.statalist.org/forums/forum/general-stata-discussion/general/1481398-residuals-in-a-panel-data-model 

xtreg ppu ppu_marcas_ymL ppu_marcas_ymL_sq
test ppu_marcas_ymL_sq
* No se rechaza especificacion

xtreg ppu $varsRegStatic L.ppu, re
estimates store random
xttest0 
// no se rechaza Pooled (OLS)
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// rechaza efectos fijos

xtreg ppu $varsRegStatic L.ppu, fe
// testparm i.marca
putexcel (A2) = "marca"
putexcel (C2) =  `e(df_r)' // =  13266
putexcel (D2) =  `e(F_f)' // =  22.31938299622964
putexcel (E2) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F2) = F_ui

outreg2 using resultados/doc/est_xtreg_dif ///
			, keep($varsReg_notrend) bdec(3) nocons  tex(fragment) replace

/* xtreg ppu $varsRegStatic d.ppu, fe 
// F test that all u_i=0: F(261, 23349) = 357.29                Prob > F = 0.0000
estimates store fixed
predict ppu_marcas_ym
gen ppu_marcas_ym_sq = ppu_marcas_ym^2

xtreg ppu ppu_marcas_ym ppu_marcas_ym_sq
test ppu_marcas_ym_sq
* No se rechaza especificacion
// xttest2: Error: too few common observations across panel.
// F : fixed effects are significant
// di  e(F_f)
// 385.7471

*xtreg ppu m1 m1_20 d.ppu, fe
xtreg ppu m1_20 m1_21 m1 d.ppu, fe
// sobre estima: 
*predict resid_d_marcas, resid

** prueba de especificacion:
predict ppu_marcas
gen ppu_marcas_sq = ppu_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq
*/
xtreg ppu $varsRegStatic L.ppu, fe

xtreg ppu $varsRegStatic i.marca#m1_20 i.marca#m1_21  L.ppu, fe
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg ppu $varsRegStatic i.marca#m1_20 i.marca#m1_21 L.ppu, re
estimates store random
xttest0 
// no OLS
hausman fixed random , sigmamore
/*  chi2(12) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       66.27
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)*/
// xtoverid
/*1b:  operator invalid
r(198); 
//xtoverid,  cluster(gr_)
*/
xtreg ppu $varsRegStatic i.marca##m1_20 i.marca##m1_21, fe
// testparm i.marca
// F test that all u_i=0: F(262, 23647) = 343.10                Prob > F = 0.0000
putexcel (A3) = "impuesto y marca"
//putexcel (C3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
putexcel (C3) =  `e(df_r)' // =  13266
putexcel (D3) =  `e(F_f)' // =  22.31938299622964
putexcel (E3) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F3) = F_ui

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

outreg2 using resultados\doc/est_xtreg_dif ///
			, keep($varsRegStatic i.marca#m1_20 i.marca#m1_21) bdec(3) tex(fragment) append

// *******************************************************************		
// Por tipo

/*-------------------------------------------------------
** por tipo o SEGMENTO
-------------------------------------------------------*/
// ALTO
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad if tipo == 1
*areg ppu m1 m1_20 ym i.marca if tipo == 1, absorb(cve_ciudad)
xtreg ppu $varsRegStatic L.ppu if tipo == 1, fe
* testparm i.marca
* F test that all u_i=0: F(124, 13125) = 0.59                  Prob > F = 0.9999
* No efectos fijos!
putexcel (A4) = "Alto"
//putexcel (B4) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
putexcel (C4) =  `e(df_r)' // =  13266
putexcel (D4) =  `e(F_f)' // =  22.31938299622964
putexcel (E4) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F4) = F_ui

outreg2 using resultados\doc/est_areg_dif_tipo ///
			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) replace
// interacciones marca e impuestos
xtreg ppu m1_20##i.marca m1_21##i.marca m1 ym L.ppu if tipo == 1, fe
// F test that all u_i=0: F(124, 13121) = 0.60                  Prob > F = 0.9999

putexcel (A5) = "Alto: con interacción marca e impuestos"
// putexcel (B5) = rscalars, colwise overwritefmt
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

outreg2 using resultados\doc/est_xtreg_dif_tipo ///
			, keep(m1_20 m1_21 m1_20##i.marca m1_21##i.marca m1 ym L.ppu) bdec(3) tex(fragment) append
			
*-------------------------------------------------------
// MEDIO
areg ppu $varsRegStatic i.marca if tipo == 2, absorb(cve_ciudad)
testparm i.marca
putexcel (A6) = "Medio"
putexcel (B6) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

outreg2 using resultados\doc/est_areg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append

areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 2, absorb(cve_ciudad)
testparm i.marca

putexcel (A7) = "Medio: con interacción marca e impuestos"
putexcel (B7) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H7) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N7) = rscalars, colwise overwritefmt
						
outreg2 using resultados\doc/est_areg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			
*-------------------------------------------------------
// BAJO
areg ppu $varsRegStatic i.marca if tipo == 3, absorb(cve_ciudad)
testparm i.marca
putexcel (A8) = "Bajo"
putexcel (B8) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_areg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append
			
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 3, absorb(cve_ciudad)
testparm i.marca

putexcel (A9) = "Bajo: con interacción marca e impuestos"
putexcel (B9) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H9) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N9) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_areg_tipo ///			
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append

*-------------------------------------------------------
*xtreg ppu i.tipo##i.m1_20 m1 d.ppu, fe
xtreg ppu i.tipo##i.m1_20 i.tipo##i.m1_21 m1 ym d.ppu, fe
// F test that all u_i=0: F(261, 23345) = 352.22                Prob > F = 0.0000

*coefplot, xline(0)

outreg2 using resultados/doc/est_xtreg_dif ///
			, keep(i.tipo##i.m1_20 i.tipo##i.m1_21 m1 ym ) bdec(3) nocons  tex(fragment) append
			
// *******************************************************************		
// Modelo en diferencias
*xtreg d.ppu m1_20 m1 L.d.ppu, fe
xtreg d.ppu $varsReg_notrend L.d.ppu, fe
*predict resid_d_marcas, resid

outreg2 using resultados/doc/est_xtreg_2dif ///
			, keep($varsReg_notrend) bdec(3) nocons  tex(fragment) replace

predict ppu_d_marcas
gen ppu_d_marcas_sq = ppu_d_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq

xtreg d.ppu i.tipo##i.m1_20 i.tipo##i.m1_21 m1  L.d.ppu, fe
*predict resid_d_marcas, resid

outreg2 using resultados/doc/est_xtreg_2dif ///
			, keep(i.tipo##i.m1_20 i.tipo##i.m1_21 m1) bdec(3) nocons  tex(fragment) append

log close

