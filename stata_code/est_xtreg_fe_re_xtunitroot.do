x1
// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
set more off

capture log close
log using resultados/est_xtreg_pooled_fe_re.log, replace

global varsRegStatic "m1_20 m1_21 m1 ym"
putexcel set "resultados\doc\f_tests_xtreg_fe_re_xtunitroot.xlsx", sheet(xtreg, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator/gl_chi"
putexcel (D1) = "F/chi2"
putexcel (F1) = "prob > F/ Prob > chi2"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

// *******************************************************
// por marca
// *******************************************************
// Benson
// Rechazo efectos aleatorios
// favorece efectos individuales fijos

// unitroot tests
xtreg ppu $varsRegStatic if marca == 1, fe
predict error_ppu_ym_fe1, e

//xtreg ppu $varsRegStatic if marca == 1, re

xtunitroot fisher error_ppu_ym_fe1, dfuller lags(4)
xtunitroot fisher error_ppu_ym_fe1, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_fe1, dfuller lags(4) drift
// se rechaza raiz unitaria en todos los paneles solo con drift

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace
// *******************************************************
// Camel

// Rechazo efectos aleatorios
// favorece efectos individuales fijos

// unitroot tests
xtreg ppu $varsRegStatic if marca == 2, fe
predict error_ppu_ym_fe2, e

//xtreg ppu $varsRegStatic if marca == 1, re
xtunitroot fisher error_ppu_ym_fe2, dfuller lags(4)
xtunitroot fisher error_ppu_ym_fe2, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_fe2, dfuller lags(4) drift
// se rechaza raiz unitaria en todos los paneles solo con drift

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace

// *******************************************************
// Chesterfield

// Rechazo efectos aleatorios
// favorece efectos individuales fijos

// unitroot tests
xtreg ppu $varsRegStatic if marca == 3, re
predict error_ppu_ym_re3, e

xtunitroot fisher error_ppu_ym_re3, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re3, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re3, dfuller lags(4) drift
// se rechaza raiz unitaria en todos los paneles solo con drift

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace

// unitroot tests
xtreg ppu $varsRegStatic if marca == 4, re
predict error_ppu_ym_re3, e

xtunitroot fisher error_ppu_ym_re3, dfuller lags(4)
xtunitroot fisher error_ppu_ym_re3, dfuller lags(4) trend
xtunitroot fisher error_ppu_ym_re3, dfuller lags(4) drift
// se rechaza raiz unitaria en todos los paneles solo con drift

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace


// F 
// 3> F test that all u_i=0: F(34, 2661) = 31.64                   Prob > F = 0.0000
// 4> F test that all u_i=0: F(37, 3171) = 32.60                   Prob > F = 0.0000
// 5> F test that all u_i=0: F(45, 5489) = 19.89                   Prob > F = 0.0000
// 6> F test that all u_i=0: F(21, 1184) = 62.67                   Prob > F = 0.0000
// 7> F test that all u_i=0: F(41, 3361) = 68.29                   Prob > F = 0.0000

/* BP-LM
// 3> chibar2(01) =  6862.21 
	// Prob > chibar2 =   0.0000
// 4>     chibar2(01) = 12340.26
	// Prob > chibar2 =   0.0000
// 5> chibar2(01) =  5983.19
                          Prob > chibar2 =   0.0000
// 6> chibar2(01) = 12598.63
                          Prob > chibar2 =   0.0000
// 7>  chibar2(01) = 36450.63
                          Prob > chibar2 =   0.0000
*/

// Hausman
// 3> chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
    //                    =        1.82
    //            Prob>chi2 =      0.7688
/* 
Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re   
Sargan-Hansen statistic   3.194  Chi-sq(4)    P-value = 0.5259
*/
	
// 4>      =    -2.33  
/*  chi2<0 ==> model fitted on these
                                        data fails to meet the asymptotic
                                        assumptions of the Hausman test;
                                        see suest for a generalized test*/

// 5> chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
	//	=        0.11
    //  Prob>chi2 =      0.9985
/*
Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re   
Sargan-Hansen statistic 174.922  Chi-sq(4)    P-value = 0.0000
*/

// 6>  chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
/*                          =   -60.47    chi2<0 ==> model fitted on these
                                        data fails to meet the asymptotic
                                        assumptions of the Hausman test;
                                        see suest for a generalized test*/

// 7>  chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
/*                          =    -6.44    chi2<0 ==> model fitted on these
                                        data fails to meet the asymptotic
                                        assumptions of the Hausman test;
                                        see suest for a generalized test */

/* 4: 
Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re   
Sargan-Hansen statistic  23.561  Chi-sq(4)    P-value = 0.0001
: Fijos
6:
Sargan-Hansen statistic  22.563  Chi-sq(4)    P-value = 0.0002
: Fijos
7:
Sargan-Hansen statistic  14.155  Chi-sq(4)    P-value = 0.0068
: Fijos
*/
					
log close

