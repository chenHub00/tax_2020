// a partir de las estimaciones en:
// complete_panel_data.do 

set more off

*global tax_def "_nov_dic"
// octubre-2021
// inclusión del análisis para otras marcas
// despu'es de separar el efecto de la ventana _nov_dic 
global tax_def "_con_otras"

capture log close
log using resultados/est_xtreg_dyn$tax_def.log, replace

*use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear
// otros
use datos/prelim/de_inpc/panel_marca_ciudad_ot7prin.dta, clear

//global vardep "ppu100"
global vardep "ppu"
global varsRegStatic "jan20 jan21 jan ym"
//global varsRegStatic "nov19_dic19 jan20 nov20_dic20 jan21 jan ym"
global varsReg_notrend "jan20 jan21 jan"
//global varsReg_notrend "nov19_dic19 jan2020 nov20_dic20 jan2021 jan"
global varsRegLag "jan20 jan21 jan ym L.ppu"
//global varsRegLag "nov19_dic19 jan20 nov20_dic20 jan21 jan ym L.ppu"

/* Resultados de las estimaciones
putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator/gl_chi"
putexcel (D1) = "F/chi2"
putexcel (F1) = "prob > F/ Prob > chi2"
*/

// // xtreg ppu $varsRegStatic L.ppu, fe 
// xtreg $vardep $varsRegLag, fe 
//
// // F test that all u_i=0: F(261, 23349) = 1.60                  Prob > F = 0.0000
// estimates store fixed
//
// predict ppu_marcas_ymL
// gen ppu_marcas_ymL_sq = ppu_marcas_ymL^2
// * No se rechaza funciones de ppu
// * referencia web:
// * Pregibon test (https://www.jstor.org/stable/2346405):
// * https://www.statalist.org/forums/forum/general-stata-discussion/general/1481398-residuals-in-a-panel-data-model 
//
// xtreg $vardep ppu_marcas_ymL ppu_marcas_ymL_sq
// test ppu_marcas_ymL_sq
// * No se rechaza especificacion
//
// xtreg $vardep $varsRegStatic L.ppu, re
// estimates store random
// xttest0 
// // no se rechaza Pooled (OLS)
// * significance of random effects
// * Hausmann Test
// // hausman consistent efficient
// hausman fixed random , sigmamore
// // rechaza efectos fijos
// /* Resultados de la prueba de Hausman 
// putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn, replace) modify
// putexcel (C1) = "No interactions"
// putexcel (B2) = "Name"
// putexcel (C2) = "Eq 1"
// putexcel (B3) = rscalarnames
// putexcel (C3) = rscalars
//
// putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
// */
// xtreg $vardep $varsRegStatic L.ppu, fe
// // testparm i.marca
// /*
// putexcel (A2) = "marca"
// putexcel (C2) =  `e(df_r)' // =  13266
// putexcel (D2) =  `e(F_f)' // =  22.31938299622964
// putexcel (E2) = `e(df_a)' // =  125
// scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
// putexcel (F2) = F_ui
// */
// outreg2 using "resultados/doc/est_xtreg_dif$tax_def" ///
// 			, keep($varsRegStatic L.ppu) bdec(3)  tex(fragment) replace
//
// xtreg $vardep $varsRegStatic, fe
//			
// outreg2 using "resultados/doc/est_xtreg_dif$tax_def" ///
// 			, keep($varsRegStatic) bdec(3)  tex(fragment) append
//			
// *------- interacciones: MARCA
// global int_tax "i.marca#nov19_dic19 i.marca#jan20 i.marca#nov20_dic20 i.marca#jan21"
//
// xtreg $vardep $varsRegStatic $int_tax L.ppu, fe
// estimates store fixed
// // xttest2
// // Error: too few common observations across panel.
// // no observations
// // r(2000);
//
// xtreg $vardep $varsRegStatic $int_tax L.ppu, re
// estimates store random
// xttest0 
// // no OLS
// hausman fixed random , sigmamore
// /*  chi2(12) = (b-B)'[(V_b-V_B)^(-1)](b-B)
//                           =       66.27
//                 Prob>chi2 =      0.0000
//                 (V_b-V_B is not positive definite)*/
// // xtoverid
// /*1b:  operator invalid
// r(198); 
// //xtoverid,  cluster(gr_)
// */
// /* Resultados de la prueba de Hausman 
// putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn) modify
// putexcel (D1) = "Interactions"
// putexcel (D2) = "Eq 2"
// putexcel (D3) = rscalars
//
// putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
// */
//
// xtreg $vardep $varsRegStatic $int_tax L.ppu, fe
// outreg2 using "resultados\doc/est_xtreg_dif$tax_def" ///
// 			, keep($varsRegStatic L.ppu $int_tax ) bdec(3) tex(fragment) append
//
// xtreg $vardep $varsRegStatic $int_tax , fe
//
// outreg2 using "resultados\doc/est_xtreg_dif$tax_def" ///
// 			, keep($varsRegStatic L.ppu  $int_tax ) bdec(3) tex(fragment) append
//			
*------- interacciones:
//global tipo_tax "i.tipo#nov19_dic19 i.tipo#jan20 i.tipo#nov20_dic20 i.tipo#jan21"
global tipo_tax "i.tipo#jan20 i.tipo#jan21"

xtreg $vardep $varsRegStatic $tipo_tax L.ppu, fe
// F test that all u_i=0: F(261, 23345) = 1.61                  Prob > F = 0.0000
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg $vardep $varsRegStatic $tipo_tax L.ppu, re
estimates store random
xttest0 
// Pooled no se rechaza
hausman fixed random , sigmamore
// rechaza random effects
/* Resultados de la prueba de Hausman 
putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (E1) = "Segment"
putexcel (E2) = "Eq 2"
putexcel (E3) = rscalars

putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
*/

xtreg $vardep $varsRegStatic $tipo_tax L.ppu, fe
// testparm i.tipo
/* Prueba F
putexcel (A10) = "Diferencias entre tipos: con interacción marca e impuestos"
putexcel (C10) =  `e(df_r)' // =  13266
putexcel (D10) =  `e(F_f)' // =  22.31938299622964
putexcel (E10) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F10) = F_ui

testparm jan20#i.tipo
putexcel (H10) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.tipo
putexcel (N10) = rscalars, colwise overwritefmt
*/
*coefplot, xline(0)
xtreg $vardep $varsRegStatic L.ppu $tipo_tax , fe

outreg2 using "resultados/doc/est_xtreg_dif$tax_def" ///
			, keep($tipo_tax jan ym L.ppu) bdec(3)  tex(fragment) append
			
*----------------- mismo efecto por tipo:
* Reference:
xtreg $vardep $varsRegStatic $tipo_tax, fe
outreg2 using "resultados/doc/est_xtreg_dif$tax_def" ///
			, keep($varsRegStatic $tipo_tax) bdec(3)  tex(fragment) append
			
			
// *******************************************************************		
// Por tipo
/*-------------------------------------------------------
** por tipo o SEGMENTO
-------------------------------------------------------*/
// ALTO
/* FE-RE :*/
xtreg $vardep $varsRegStatic L.ppu if tipo == 1, fe
// F test that all u_i=0: F(261, 23345) = 1.61                  Prob > F = 0.0000
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg $vardep $varsRegStatic L.ppu if tipo == 1, re
estimates store random
xttest0 
// Pooled no se rechaza
hausman fixed random , sigmamore
// rechaza random effects
/* :FE-RE 
/* Resultados de la prueba de Hausman */
putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (F1) = "Premium"
putexcel (F2) = "Eq 2"
putexcel (F3) = rscalars

putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
*/
xtreg $vardep $varsRegStatic L.ppu if tipo == 1, fe
* testparm i.marca
/* Prueba F
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
*/
outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///
			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) replace
// // interacciones marca e impuestos
// xtreg $vardep $int_tax $varsRegStatic L.ppu if tipo == 1, fe
//
// /* Prueba F
// // F test that all u_i=0: F(124, 13121) = 0.60                  Prob > F = 0.9999
// putexcel (A5) = "Alto: con interacción marca e impuestos"
// // putexcel (B5) = rscalars, colwise overwritefmt
// putexcel (C5) =  `e(df_r)' // =  13266
// putexcel (D5) =  `e(F_f)' // =  22.31938299622964
// putexcel (E5) = `e(df_a)' //sd =  125
// scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
// putexcel (F5) = F_ui
//
// testparm jan20#i.marca
// putexcel (H5) = rscalars, colwise overwritefmt
// // H0: igualdad de parametros 
// // rechazo h0, son iguales
//
// testparm jan21#i.marca
// putexcel (N5) = rscalars, colwise overwritefmt
// */
// outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///
// 			, keep($int_tax $varsRegStatic  L.ppu) bdec(3) tex(fragment) append
			
*-------------------------------------------------------
// MEDIO
/* FE-RE :*/
xtreg $vardep $varsRegStatic L.ppu if tipo == 2, fe
// F test that all u_i=0: F(79, 6439) = 0.92                    Prob > F = 0.6821
// no efecto fijo significativo
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg $vardep $varsRegStatic L.ppu if tipo == 2, re
estimates store random
xttest0 
//                             chibar2(01) =     0.00
 //                         Prob > chibar2 =   1.0000
// Pooled se rechaza
hausman fixed random , sigmamore
// rechaza random effects
/* :FE-RE 
putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (G1) = "Medium"
putexcel (G2) = "Eq 2"
putexcel (G3) = rscalars

putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
*/

xtreg $vardep $varsRegStatic L.ppu if tipo == 2, fe
// testparm i.marca
/* Prueba F
putexcel (A6) = "Medio"
// putexcel (B6) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
putexcel (C6) =  `e(df_r)' // =  13266
putexcel (D6) =  `e(F_f)' // =  22.31938299622964
putexcel (E6) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F6) = F_ui
*/
outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///
			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) append

// // interacciones marca e impuestos
// xtreg $vardep $int_tax $varsRegStatic L.ppu if tipo == 2, fe
// // testparm i.marca
// /* Prueba F
// putexcel (A7) = "Medio: con interacción marca e impuestos"
// //putexcel (B7) = rscalars, colwise overwritefmt
// putexcel (C7) =  `e(df_r)' // =  13266
// putexcel (D7) =  `e(F_f)' // =  22.31938299622964
// putexcel (E7) = `e(df_a)' // =  125
// scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
// putexcel (F7) = F_ui
//
// testparm jan20#i.marca
// putexcel (H7) = rscalars, colwise overwritefmt
// // H0: igualdad de parametros 
// // rechazo h0, son iguales
//
// testparm jan21#i.marca
// putexcel (N7) = rscalars, colwise overwritefmt
// // H0: igualdad de parametros 
// // rechazo h0, son iguales
// */						
// outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///
// 			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) append
//			
*-------------------------------------------------------
// BAJO
/* FE-RE :*/
xtreg $vardep $varsRegStatic L.ppu if tipo == 3, fe
// F test that all u_i=0: F(79, 6439) = 0.92                    Prob > F = 0.6821
// no efecto fijo significativo
estimates store fixed
// xttest2
// Error: too few common observations across panel.
// no observations
// r(2000);

xtreg $vardep $varsRegStatic L.ppu if tipo == 3, re
estimates store random
xttest0 
//                             chibar2(01) =     0.00
 //                         Prob > chibar2 =   1.0000
// Pooled se rechaza
hausman fixed random , sigmamore
// rechaza random effects
/* :FE-RE 
putexcel set "resultados\doc\hausman_xtreg_dyn.xlsx", sheet(hausman_xtreg_dyn) modify
putexcel (H1) = "Lower"
putexcel (H2) = "Eq 2"
putexcel (H3) = rscalars

putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify
*/

xtreg $vardep $varsRegStatic L.ppu if tipo == 3, fe
//testparm i.marca
/* Prueba F
putexcel (A8) = "Bajo"
//putexcel (B8) = rscalars, colwise overwritefmt
putexcel (C8) =  `e(df_r)' // =  13266
putexcel (D8) =  `e(F_f)' // =  22.31938299622964
putexcel (E8) = `e(df_a)' // =  125
scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
putexcel (F8) = F_ui
*/

outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///
			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) append
			
// // interacciones marca e impuestos
// xtreg $vardep $int_tax $varsRegStatic L.ppu if tipo == 3, fe
// /* Prueba F
// // F test that all u_i=0: F(56, 3773) = 0.95                    Prob > F = 0.5758
// //testparm i.marca
// putexcel (A9) = "Bajo: con interacción marca e impuestos"
// //putexcel (B9) = rscalars, colwise overwritefmt
// putexcel (C9) =  `e(df_r)' // =  13266
// putexcel (D9) =  `e(F_f)' // =  22.31938299622964
// putexcel (E9) = `e(df_a)' // =  125
// scalar F_ui = Ftail(e(df_a),e(df_r),e(F_f))
// putexcel (F9) = F_ui
//
// testparm jan20#i.marca
// putexcel (H9) = rscalars, colwise overwritefmt
// // H0: igualdad de parametros 
// // rechazo h0, son iguales
//
// testparm jan21#i.marca
// putexcel (N9) = rscalars, colwise overwritefmt
// // H0: igualdad de parametros 
// // rechazo h0, son iguales al 5 %
// // no son iguales al 10 % []
// */
// outreg2 using "resultados\doc/est_xtreg_dif_tipo$tax_def" ///			
// 			, keep($varsRegStatic L.ppu) bdec(3) tex(fragment) append

log close
/*-----------------------------------------------------

*/

