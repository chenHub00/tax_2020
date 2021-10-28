// cd al directorio raiz
set more off

// previos: do_encuesta.do
global resultados = "resultados\encuesta\"

/*-----------------------------------------------------
b) Las interacciones también hacerlas por pasos para ver cómo se comporta el modelo. 
Antes de la interacción sexo-impuesto, 
empezaría por poner una interacción "sencilla" 
(que no multiplique a todas las variables del modelo) 
1. diario/ocasional-impuesto 
con suelto/cajetilla solo como control 
2. luego una triple interacción diario/ocasional-impuesto-suelto/cajetilla, 
y luego otras interacciones según vayas viendo el comportamiento 
del modelo con sexo o edad. 
3. sexo
*/
capture log close
log using "$resultados/modelos_precio3b.log", replace

macro list resultados

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

// variable dependiente>
global dep "ppu"


global v_ps "tax2020 sexo i.edad_gr2 i.educ_gr2 i.gr_ingr patron single"

foreach var of varlist patron single tipo sexo { 
	use "$datos/c_pw4_w5_unbalanc.dta", clear
	// use "$datos/wave4_5unbalanced.dta", clear
	/***************************************************************************/
	// 1.3.b MODELOS tipo

	// modelo
	regress $dep $v_ps tax2020#i.`var' if has_fumado_1mes
	outreg2 using resultados/encuesta/mod_p1_3b`var', word excel replace

	// estimación panel
	xtreg $dep $v_ps tax2020#i.`var' if has_fumado_1mes, fe
	outreg2 using resultados/encuesta/mod_p1_3b`var', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/
	xtreg $dep $v_ps tax2020#i.`var' if has_fumado_1mes, re
	outreg2 using resultados/encuesta/mod_p1_3b`var', word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios


// PRIMERO VERIFICAR SI EL FECTO INDIVIDUAL ESTIMADO SERÍA ALEATORIO O FIJO
// patron: fijo
/*
   Test:  Ho:  difference in coefficients not systematic

                 chi2(26) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       41.46
                Prob>chi2 =      0.0279

*/
// single: fijo
/*

    Test:  Ho:  difference in coefficients not systematic

                 chi2(26) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       44.56
                Prob>chi2 =      0.0132
*/
// tipo: 
/*
   Test:  Ho:  difference in coefficients not systematic

                 chi2(29) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       47.17
                Prob>chi2 =      0.0179
*/
// sexo: fijo
/*


    Test:  Ho:  difference in coefficients not systematic

                 chi2(26) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       41.51
                Prob>chi2 =      0.0275

*/
// SE INCLUYE PARA BALANCEADO SOLO EFECTO FIJO
	use "$datos/c_pw4_w5_balanc.dta", clear
	xtreg $dep $v_ps tax2020#i.`var' if has_fumado_1mes, fe
	outreg2 using resultados/encuesta/mod_p1_3b`value', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/


}

log close
