// cd al directorio raiz
set more off

// previos: do_encuesta.do
global resultados = "resultados\encuesta\"

/*-----------------------------------------------------
a) Probar estimando los modelos por separado para fumadores diarios y ocasionales, si el tamaño de muestra lo permite. 
En ese caso, el tipo de compra cajetilla/suelto iría como control, y después de esta especificación inicial 
se pueden probar interacciones tipo de compra-impuesto o sexo-impuesto y así. Pero por pasos, para ir viendo cómo se comporta el modelo.
*/
capture log close
log using "$resultados/modelos_precio3a.log", replace

macro list resultados

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

// variable dependiente>
global dep "ppu"

// variable independientes
// sección 1 
//global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar i.tipo_cons"
global vreg "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr i.tipo"
// sección 2
// sólo interacción de impuesto con sexo
global v_int "tax2020 tax2020_sexo "
// sección 3
global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "


use "$datos/c_pw4_w5_unbalanc.dta", clear
//use "$datos/wave4_5unbalanced.dta", clear

/***************************************************************************/
// 1.3a MODELOS patron == 1 (diario)
global v_x "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr singles"
global v_tax "tax2020"

foreach valor_patron of numlist 1 0 {
di "Patron de consumo 1 = diario, 0 = ocasional: " + `valor_patron'
*local valor_patron = 1
// modelo
regress $dep $v_tax $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/mod_p1_3a`valor_patron', word excel replace

// estimación panel
xtreg $dep $v_tax $v_x  if patron == `valor_patron', fe
outreg2 using resultados/encuesta/mod_p1_3a`valor_patron', word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
xtreg $dep $v_tax $v_x  if patron == `valor_patron', re
outreg2 using resultados/encuesta/mod_p1_3a`valor_patron', word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
}
// PRIMERO SE DETERMINA SI LOS EFECTOS INDIVIDUALES SON FIJOS O ALEATORIOS
// NO SE RECHAZAN ALEATORIOS PARA PATRON DE CONSUMO DIARIO
/*

    Test:  Ho:  difference in coefficients not systematic

                 chi2(24) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       31.27
                Prob>chi2 =      0.1463
*/
// SE PREFIEREN FIJOS PARA CONSUMO OCASIONAL
/*
                 chi2(24) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       44.74
                Prob>chi2 =      0.0063

*/
// COMO SON DIFERENTES NO ES DIRECTA LA PROGRAMACIÓN EN EL LOOP 
/***************************************************************************/
//foreach valor_patron of numlist 1 0 {
local valor_patron = 1
// 	di "Patron de consumo 1 = diario, 0 = ocasional: " + `valor_patron'
//
// 	if   `valor_patron' == 1 {
// 	local re_fe "re"
// 	} 
// 	di "Patron de consumo 1 = diario, 0 = ocasional: " + `valor_patron'
// 	di "Efecto fijo o aletorio, fijo = fe, aleatorio = re: " $re_fe
//		
//		
// 	else {
// 	local re_fe = `fe'
// 	}
// 	di `re_fe'
	use "$datos/c_pw4_w5_unbalanc.dta", clear
	//use "$datos/wave4_5balanc.dta", clear
	
	xtreg $dep $v_tax $v_x  if patron == `valor_patron', re
	outreg2 using resultados/encuesta/mod_p1_3a`valor_patron', word excel append

	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/
	global v_x "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr singles"
	global v_tax_int0 "tax2020 tax2020#i.sexo tax2020#i.singles"
	global v_tax_int1 "tax2020 tax2020#i.sexo "
	global v_tax_int2 "tax2020 tax2020#i.singles"

	// modelo por ols
	regress $dep $v_tax_int0 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel replace

	regress $dep $v_tax_int1 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	regress $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	// modelo por re
	xtreg $dep $v_tax_int0 $v_x  if patron == `valor_patron', re
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel replace

	xtreg $dep $v_tax_int1 $v_x  if patron == `valor_patron',re
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	xtreg $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	use "$datos/c_pw4_w5_balanc.dta", clear
	//use "$datos/wave4_5balanc.dta", clear
	// modelo por re
	xtreg $dep $v_tax_int0 $v_x  if patron == `valor_patron', re
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel replace

	xtreg $dep $v_tax_int1 $v_x  if patron == `valor_patron',re
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append

	xtreg $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append

/***************************************************************************/
//foreach valor_patron of numlist 1 0 {
local valor_patron = 0
	use "$datos/c_pw4_w5_unbalanc.dta", clear
	//use "$datos/wave4_5balanc.dta", clear
	
	xtreg $dep $v_tax $v_x  if patron == `valor_patron', re
	outreg2 using resultados/encuesta/mod_p1_3a`valor_patron', word excel append

	*xttest2
	/*
	insufficient observations
	r(2001);

	end of do-file
	*/
	global v_x "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr singles"
	global v_tax_int0 "tax2020 tax2020#i.sexo tax2020#i.singles"
	global v_tax_int1 "tax2020 tax2020#i.sexo "
	global v_tax_int2 "tax2020 tax2020#i.singles"

	// modelo por ols
	regress $dep $v_tax_int0 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel replace

	regress $dep $v_tax_int1 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	regress $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	// modelo por re
	xtreg $dep $v_tax_int0 $v_x  if patron == `valor_patron', fe
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel replace

	xtreg $dep $v_tax_int1 $v_x  if patron == `valor_patron',fe
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	xtreg $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/mod_p1_3a_reg`valor_patron', word excel append

	use "$datos/c_pw4_w5_balanc.dta", clear
	//use "$datos/wave4_5balanc.dta", clear
	// modelo por re
	xtreg $dep $v_tax_int0 $v_x  if patron == `valor_patron', fe
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel replace

	xtreg $dep $v_tax_int1 $v_x  if patron == `valor_patron',fe
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append

	xtreg $dep $v_tax_int2 $v_x  if patron == `valor_patron'
	outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append


log close
