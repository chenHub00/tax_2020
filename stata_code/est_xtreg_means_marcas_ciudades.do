// estimacion, xtreg
// usar promedios por ciudad y marcas
// para tener estimadores consistentes de los coeficientes de interes
// agregados por marca

// a partir de:
// practical_3way
// 

capture log close
log using resultados/est_xtreg_means_marcas_ciudades.log, replace

use datos\panel_marca_ciudad.dta, clear

// means by "spell": combinations of worker and firm, over time
// (they do not coincide in time)
// here combinations of brand and city, over time
// mean_var_
egen m_ppu_cm = mean(ppu), by(cve_ marca)
gen dm_ppu_cm = ppu - m_ppu_cm

foreach var of varlist m1_20 m1 ym {
	egen m_`var'_cm = mean(`var'), by(cve_ marca)
	gen dm_`var'_cm = `var' - m_`var'_cm
}

// the city and brand effects are not considered 
// simple time dummies
xtreg dm_ppu_cm dm_m1_cm dm_m1_20_cm i.ym, fe
// R: fixed effects (city with brand)
// meaning of the coefficient for m1_20 (1.12)?

// single time trend (mean-diff)
xtreg dm_ppu_cm dm_m1_cm dm_m1_20_cm dm_ym_cm, fe
// R: fixed effects are NOT relevant
// the coefficient for m1_20 

// single time trend (no mean-diff)
xtreg dm_ppu_cm dm_m1_cm dm_m1_20_cm ym, fe
// R: fixed effects are relevant
// the coefficient for m1_20 in the same range as previous estimation
// outreg
outreg2 using resultados/doc/est_xt_dm ///
			, keep(dm_m1_cm dm_m1_20_cm  ym) bdec(3) nocons  tex(fragment) replace

// por marca
xtreg dm_ppu_cm dm_m1_cm i.marca##c.dm_m1_20_cm ym, fe
outreg2 using resultados/doc/est_xt_dm ///
			, keep(dm_m1_cm dm_m1_20_cm  ym) bdec(3) nocons  tex(fragment) append
// includes dm_m1_20 
testparm i.marca##c.dm_m1_20 
// exclude dm_m1_20 
testparm i.marca#c.dm_m1_20

// premium 
testparm 2.marca#c.dm_m1_20 5.marca#c.dm_m1_20

// separar las estimaciones por marca
xtreg dm_ppu_cm dm_m1_cm i.marca#c.dm_m1_20_cm ym, fe
// premium 
testparm 1.marca#c.dm_m1_20 2.marca#c.dm_m1_20 5.marca#c.dm_m1_20
// medium (same company produces this two)
// 4: lucky, 7: pall mall
testparm 4.marca#c.dm_m1_20 7.marca#c.dm_m1_20

// discount (?)
// 3: chesterfield, 6: montana
testparm 3.marca#c.dm_m1_20 6.marca#c.dm_m1_20

// this equality cannot be discarded
					
log close
