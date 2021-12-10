// cd al directorio raiz

// modelos lineales con interacciones covid19
set more off


/*-----------------------------------------------------*/
log using "resultados/encuesta/modelos_consumo4.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

global vars_txc "tax2020 covid19" 
// modelos_consumo3:
// global v_txc_singles "tax2020#i.singles tax2020_sexo#i.singles tax2020#i.patron tax2020_sexo#i.patron"
global v_singles "sexo#singles i.edad_gr3#singles i.educ_gr3#singles i.ingr_gr#singles i.singles  i.patron"

//use "$datos/wave4_5unbalanced.dta", clear
use "$datos/cons_w456_unbalanc.dta", clear
/***************************************************************************/
// 1.4 MODELOS interacturados con pandemia, pandemia_sexo: patron, singles
global v_covid19 "covid19#i.singles covid19_sexo#i.singles covid19#i.patron covid19_sexo#i.patron"

// modelo
//regress consumo_semanal $vars_txc $v_tipo_int $v_tipo if has_fumado_1mes
regress consumo_semanal $vars_txc $v_covid19 $v_singles if has_fumado_1mes
outreg2 using resultados/encuesta/modelos1_4, word excel replace

// pruebas
testparm covid19#i.singles // no se rechaza igualdad
testparm covid19_sexo#i.singles // no se rechaza igualdad >  covid19_sexo#singles | 1#cajetilla
testparm covid19#i.patron // no se rechaza igualdad
testparm covid19_sexo#i.patron // Si se rechaza igualdad : Coef. covid19_sexo#patron

// estimación panel
//xtreg consumo_semanal $v_tipo_int $v_tipo if has_fumado_1mes, fe
xtreg consumo_semanal $vars_txc $v_covid19 $v_singles if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_4, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// pruebas
testparm covid19#i.singles // no se rechaza igualdad
testparm covid19_sexo#i.singles // s'i se rechaza igualdad
testparm covid19#i.patron // s'i se rechaza igualdad
testparm covid19_sexo#i.patron // s'i se rechaza igualdad

xtreg consumo_semanal $vars_txc $v_covid19 $v_singles if has_fumado_1mes, re
outreg2 using resultados/encuesta/modelos1_4, word excel append

estimates store random
xttest0 
* rechazo Pooled 
* significance of random effects
* Hausmann Test
// hausman consistent efficient
hausman fixed random , sigmamore
// Rechazo Efectos aleatorios

// // pruebas
testparm covid19#i.singles // no se rechaza igualdad
testparm covid19_sexo#i.singles // S'i se rechaza igualdad
testparm covid19#i.patron // S'i se rechaza igualdad
testparm covid19_sexo#i.patron // S'i se rechaza igualdad

//use "$datos/wave4_5balanc.dta", clear
use "$datos/cons_w456_balanc.dta", clear
xtreg consumo_semanal $vars_txc $v_covid19 $v_singles if has_fumado_1mes, fe
outreg2 using resultados/encuesta/modelos1_4, word excel append

estimates store fixed
*xttest2
/*
insufficient observations
r(2001);

end of do-file
*/
// // pruebas
testparm covid19#i.singles // no se rechaza igualdad
testparm covid19_sexo#i.singles // no se rechaza igualdad
testparm covid19#i.patron // no se rechaza igualdad
testparm covid19_sexo#i.patron // S'i se rechaza igualdad

log close

