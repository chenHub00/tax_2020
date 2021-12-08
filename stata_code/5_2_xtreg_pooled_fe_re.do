// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
set more off

capture log close
log using resultados/est_xtreg_pooled_fe_re.log, replace

global varsRegStatic "jan20 jan21 jan ym"
putexcel set "resultados\doc\f_tests_xtreg_pooled_fe_re.xlsx", sheet(xtreg, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator/gl_chi"
putexcel (D1) = "F/chi2"
putexcel (F1) = "prob > F/ Prob > chi2"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

// *******************************************************
// por marca
// *******************************************************
// Benson
xtreg ppu $varsRegStatic if marca == 1, fe
estimates store fixed1
// xttest2 : Error: too few common observations across panel.
// cannot decide over
xtreg ppu $varsRegStatic if marca == 1, re
estimates store random1
xttest0 
// rechazar OLS
* significance of random effects
* Hausmann Test
hausman fixed1 random1 
/*
chi2<0 ==> model fitted on these
                                        data fails to meet the asymptotic
                                        assumptions of the Hausman test;
                                        see suest for a generalized test
										
:  too small sample or mis-specification of the model										
*/
// Hausman test becomes undefined.
// suest fixed1 random1, noomitted
// xtreg is not supported by suest
// r(322);
//https://stats.stackexchange.com/questions/65650/hausman-test-for-panel-data-fe-and-re-error-in-the-estimation-what-to-do-sta
*ssc install xtoverid 
/*
Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re   
Sargan-Hansen statistic  29.712  Chi-sq(4)    P-value = 0.0000
*/
// Rechazo efectos aleatorios
xtreg ppu $varsRegStatic if marca == 1, re cluster(gr_marca_ciudad)
xtoverid
/*
Test of overidentifying restrictions: fixed vs random effects
Cross-section time-series model: xtreg re  robust cluster(gr_marca_ciudad)
Sargan-Hansen statistic  30.123  Chi-sq(4)    P-value = 0.0000
*/
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
xtreg ppu $varsRegStatic if marca == 2, fe
estimates store fixed2
// xttest2 // : Error: too few common observations across panel.
// cannot decide over
//F test that all u_i=0: F(35, 3167) = 17.34                   Prob > F = 0.0000

xtreg ppu $varsRegStatic if marca == 2, re
estimates store random2
xttest0 
// rechazar OLS
* significance of random effects
* Hausmann Test
hausman fixed2 random2 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
// (V_b-V_B is not positive definite)
// Hausman test becomes undefined.
xtoverid 

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

// hausman favorece efectos individuales fijos
xtreg ppu $varsRegStatic, fe

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append


*xtunitroot fisher ppu, dfuller lags(4)

foreach number of numlist 3/7 {
	di "`number'"

//	xtset cve_ciudad ym 
	// gen dif_ppu = d.ppu

	//xtreg ppu m1_20 m1 ym, fe
	xtreg ppu $varsRegStatic if marca == `number', fe
	estimates store fixed`number'

	xtreg ppu $varsRegStatic if marca == `number', re
	estimates store random`number'
	xttest0 
	* significance of random effects
	* Hausmann Test
	hausman fixed`number' random`number' 
	xtoverid 
}
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
foreach number of numlist 4 6 7 {
	di "`number'"

	xtreg ppu $varsRegStatic if marca == `number', re
	xtoverid 

}
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
foreach number of numlist 5 {
	di "`number'"

	xtreg ppu $varsRegStatic if marca == `number', fe cluster(gr_marca_ciudad)
	estimates store fixed`number'


	xtreg ppu $varsRegStatic if marca == `number', re cluster(gr_marca_ciudad)
	estimates store random`number'
	xttest0 

	xtoverid 
}

foreach number of numlist 3 {
	di "`number'"

// hausman favorece efectos individuales fijos
xtreg ppu $varsRegStatic, fe

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append
			
}

foreach number of numlist 4 {
	di "`number'"

// hausman favorece efectos individuales fijos
xtreg ppu $varsRegStatic, fe

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append
			
}

foreach number of numlist 5/7 {
	di "`number'"

// hausman favorece efectos individuales fijos
xtreg ppu $varsRegStatic, fe

outreg2 using resultados/doc/est_xt_marcas ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) append
			
}
				
log close
