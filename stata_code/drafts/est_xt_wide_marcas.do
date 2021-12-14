
 
capture log close
log using resultados/est_xt_wide_marcas.log, replace

use datos/wide_complete_medium_smp.dta, clear

gen ym2 = ym^2

// Medias
***************** marca 4
// 
xtreg ppu4 m1 m1_20 ym 
//xtreg ppu4 m1 m1_20 ym ym2
estimates store random_effects

outreg2 using est_xt_medium ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace
			
// ajuste en la muestra
xtreg ppu4 m1 m1_20 ym if smp_xtsur_medium 
outreg2 using est_xt_medium ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

// https://stats.stackexchange.com/questions/105416/is-it-possible-to-use-the-breusch-pagan-lagrange-multiplier-test-xttest0-in-st
// at pooled OLS might not be the appropriate model given 
// that it assumes an error structure
xttest0
// is it balanced?
xttest1

xtreg ppu4 m1 m1_20 ym, fe
//xtreg ppu4 m1 m1_20 ym ym2, fe
hausman . random_effects
* Ho: diferencia no sistematica (fixed effects) de ciudad
* ym: no se rechaza
* ym ym2: efectos aleatorios
***************** marca 7
//
xtreg ppu7 m1 m1_20 ym
//xtreg ppu7 m1 m1_20 ym ym2
estimates store random_effects
// that it assumes an error structure
xttest0
// is it balanced?
xttest1

outreg2 using est_xt_medium ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

// ajuste en la muestra
xtreg ppu7 m1 m1_20 ym if smp_xtsur_medium 
outreg2 using est_xt_medium ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

xtreg ppu7 m1 m1_20 ym, fe
//xtreg ppu7 m1 m1_20 ym ym2, fe
hausman . random_effects


log close

