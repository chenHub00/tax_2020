// cd al directorio raiz
set more off

// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

/*-----------------------------------------------------
a) Probar estimando los modelos por separado para fumadores diarios y ocasionales, si el tamaño de muestra lo permite. 
En ese caso, el tipo de compra cajetilla/suelto iría como control, y después de esta especificación inicial 
se pueden probar interacciones tipo de compra-impuesto o sexo-impuesto y así. Pero por pasos, para ir viendo cómo se comporta el modelo.
*/
log using "$resultados/modelos_consumo3a.log", replace
use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.3a MODELOS patron == 1 (diario)
global v_x "sexo i.edad_gr2 i.educ_gr2 i.gr_ingr singles"
global v_tax "tax2020"

foreach valor_patron of numlist 1 0 {
*local valor_patron = 1
// modelo
regress consumo_semanal $v_tax $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/modelos1_3a`valor_patron', word excel replace

// estimación panel
xtreg consumo_semanal $v_tax $v_x  if patron == `valor_patron', fe
outreg2 using resultados/encuesta/modelos1_3a`valor_patron', word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
xtreg consumo_semanal $v_tax $v_x  if patron == `valor_patron', re
outreg2 using resultados/encuesta/modelos1_3a`valor_patron', word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
/*

                 chi2(24) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =   -75.15    chi2<0 ==> model fitted on these
                                        data fails to meet the asymptotic
                                        assumptions of the Hausman test;
                                        see suest for a generalized test
 
*/

use "$datos/wave4_5balanc.dta", clear
xtreg consumo_semanal $v_tax $v_x  if patron == `valor_patron', re
outreg2 using resultados/encuesta/modelos1_3a`valor_patron', word excel append

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
regress consumo_semanal $v_tax_int0 $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/modelos1_3a_reg`valor_patron', word excel replace

regress consumo_semanal $v_tax_int1 $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/modelos1_3a_reg`valor_patron', word excel append

regress consumo_semanal $v_tax_int2 $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/modelos1_3a_reg`valor_patron', word excel append

// modelo por re
xtreg consumo_semanal $v_tax_int0 $v_x  if patron == `valor_patron', re
outreg2 using resultados/encuesta/modelos1_3a_xtreg`valor_patron', word excel replace

xtreg consumo_semanal $v_tax_int1 $v_x  if patron == `valor_patron',re
outreg2 using resultados/encuesta/modelos1_3a_xtreg`valor_patron', word excel append

xtreg consumo_semanal $v_tax_int2 $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/modelos1_3a_xtreg`valor_patron', word excel append

*local valor_patron = 1

use "$datos/wave4_5balanc.dta", clear
// modelo por re
xtreg consumo_semanal $v_tax_int0 $v_x  if patron == `valor_patron', re
outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel replace

xtreg consumo_semanal $v_tax_int1 $v_x  if patron == `valor_patron',re
outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append

xtreg consumo_semanal $v_tax_int2 $v_x  if patron == `valor_patron'
outreg2 using resultados/encuesta/bal_mod1_3a_xtreg`valor_patron', word excel append

}
log close

/*-----------------------------------------------------*
log using "$resultados/modelos_consumo3.log", replace
use "$datos/wave4_5unbalanced.dta", clear
/***************************************************************************/
// 1.3 MODELOS tipo
global v_tipo "sexo#i.tipo_cons i.edad_gr2#i.tipo_cons i.educ_gr2#i.tipo_cons i.gr_ingr#i.tipo_cons i.tipo"
global v_tipo_int "tax2020 tax2020#i.tipo_cons tax2020_sexo#i.tipo_cons "

// modelo
regress consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, noconst
outreg2 using resultados/encuesta/modelos1_3, word excel replace

// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

// estimación panel
xtreg consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, fe noconst
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

xtreg consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, re noconst
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// pruebas
testparm i.tipo // se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

use "$datos/wave4_5balanc.dta", clear
xtreg consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, fe noconst
outreg2 using resultados/encuesta/modelos1_3, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm i.tipo // NO se rechaza igualdad
testparm tax2020#i.tipo // no se rechaza igualdad
testparm tax2020_sexo#i.tipo_cons // no se rechaza igualdad

log close

