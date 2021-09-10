// cd al directorio raiz
set more off

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
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
log using "$resultados/modelos_consumo3b.log", replace

global v_ps "tax2020 sexo i.edad_gr2 i.educ_gr2 i.gr_ingr patron single"

foreach var of varlist patron single tipo sexo { 
	use "$datos/wave4_5unbalanced.dta", clear
	/***************************************************************************/
	// 1.3.b MODELOS tipo

	// modelo
	regress consumo_semanal $v_ps tax2020#i.`var' if has_fumado_1mes
	outreg2 using resultados/encuesta/modelos1_3b`var', word excel replace

	// estimación panel
	xtreg consumo_semanal $v_ps tax2020#i.`var' if has_fumado_1mes, fe
	outreg2 using resultados/encuesta/modelos1_3b`var', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/
	xtreg consumo_semanal $v_ps tax2020#i.`var' if has_fumado_1mes, re
	outreg2 using resultados/encuesta/modelos1_3b`var', word excel append

	estimates store random
	xttest0 
	* rechazo Pooled 
	* significance of random effects
	* Hausmann Test
	// hausman consistent efficient
	hausman fixed random , sigmamore
	// Rechazo Efectos aleatorios

	use "$datos/wave4_5balanc.dta", clear
	xtreg consumo_semanal $v_ps tax2020#i.`var' if has_fumado_1mes, fe
	outreg2 using resultados/encuesta/modelos1_3b`value', word excel append

	estimates store fixed
	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/


}

log close
