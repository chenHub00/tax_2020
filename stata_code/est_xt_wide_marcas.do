
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_xt_wide_marcas.log, replace

use datos/wide_complete_panel.dta, clear

gen ym2 = ym^2

// Medias
***************** marca 4
// 
xtreg ppu4 m1 m1_20 ym 
xtreg ppu4 m1 m1_20 ym ym2
estimates store random_effects

// https://stats.stackexchange.com/questions/105416/is-it-possible-to-use-the-breusch-pagan-lagrange-multiplier-test-xttest0-in-st
// at pooled OLS might not be the appropriate model given 
// that it assumes an error structure
xttest0
// is it balanced?
xttest1

xtreg ppu4 m1 m1_20 ym, fe
xtreg ppu4 m1 m1_20 ym ym2, fe
hausman . random_effects
* Ho: diferencia no sistematica (fixed effects)
* no se rechaza

***************** marca 7
//
xtreg ppu7 m1 m1_20 ym ym2
// that it assumes an error structure
xttest0
// is it balanced?
xttest1

log close

xtsur (ppu4 m1 m1_20 ym ym2) (ppu7 m1 m1_20 ym ym2) 

/*
////// DRAFT
su ppu4 ppu7 
// tiempo
// medio  
* program: 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) 
// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".

putexcel set "resultados\sample_changes\marcas_medias.xlsx", replace
 
putexcel (B2) = matrix( e(b) ), names
*file C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\resultados\sample_changes\marcas_medias.xlsx saved
putexcel (A4) = "muestra completa:"

putexcel (B2) = matrix( e(b) ), names

su ppu4 ppu7 if e(sample)==1

// minimo 2 anios, se agrega un anio cada vez
// quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2019,1)
// CONVERGE?
// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".

//putexcel (C5) = matrix( e(b) )
//putexcel (A5) = "muestra minima: ene2019-dic2020"

// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2018,1)
// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".

putexcel (C6) = matrix( e(b) )
putexcel (A6) = "muestra: ene2018-dic2020"
su ppu4 ppu7 if e(sample)==1

// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2017,1)
// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".

putexcel (C7) = matrix( e(b) )
putexcel (A7) = "muestra: ene2017-dic2020"
su ppu4 ppu7 if e(sample)==1


// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2016,1)
	// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".

	putexcel (C8) = matrix( e(b) )
	putexcel (A8) = "muestra: ene2016-dic2020"
su ppu4 ppu7 if e(sample)==1

	// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2015,1)
	// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".
	putexcel (C9) = matrix( e(b) )
 	putexcel (A9) = "`e(cmdline)'"
su ppu4 ppu7 if e(sample)==1

		// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2014,1)
	// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".
	putexcel (C10) = matrix( e(b) )
 	putexcel (A10) = "`e(cmdline)'"
su ppu4 ppu7 if e(sample)==1

		// 
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2013,1)
	// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".
	putexcel (C11) = matrix( e(b) )
 	putexcel (A11) = "`e(cmdline)'"
su ppu4 ppu7 if e(sample)==1

//
quietly xtsur (ppu4 m1 m1_20 ym) (ppu7 m1 m1_20 ym) if  ym >= ym(2012,1)
	// despu'es de ejecutar xtreg xtsur tiene problemas para "cargar".
	putexcel (C12) = matrix( e(b) )
 	putexcel (A12) = "`e(cmdline)'"
su ppu4 ppu7 if e(sample)==1


log close
