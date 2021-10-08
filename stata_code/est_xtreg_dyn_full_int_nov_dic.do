// modelos dinámicos 
// con interacciones completas
// estimaciones similares a 
// Seemingly Unrelated Regression
set more off

capture log close
log using resultados/est_xtreg_dyn_full_int_nov_dic.log, append
// outreg2 : resultados\doc/est_xtreg_dyn_full_int 
// resultados interacci'on completa (est'atico y din'amico)
//	outreg2 using resultados/doc/est_xtreg_no_tax_marca ///			
// resultados previos a impuesto
// outreg2 : resultados/doc/est_xtreg_stat_marca 
// resultados por marca est'atico
// outreg2 using resultados/doc/est_xtreg_dyn_marca 
// resultados por marca din'amico

// resultados de interacción completa

*global vardep "ppu" 
// global vardep "ppu100"
// global varsReg_notrend "jan20 jan21 jan"
// global varsRegLag "jan20 jan21 jan ym L.ppu"

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

// creado en: est_one_panel_dyn.do
putexcel set "resultados\doc\f_tests_xtreg_dyn.xlsx", sheet(xtreg_dyn) modify

// globales
// global varsRegStatic "jan20 jan21 jan ym"

global tax_def "_nov_dic"
//global vardep "ppu100"
global vardep "ppu"
// global varsRegStatic "jan20 jan21 jan ym"
// nov19_dic19 jan20 nov20_dic20 jan21 
global varsRegStatic "jan ym"
//global varsReg_notrend "jan20 jan21 jan"
global varsReg_notrend "nov19_dic19 jan2020 nov20_dic20 jan2021 jan"
//global varsRegLag "jan20 jan21 jan ym L.ppu"
global varsRegLag "nov19_dic19 jan20 nov20_dic20 jan21 jan ym L.ppu"

global int_tax "i.marca#nov19_jan20 i.marca#nov20_jan21"
global int_fixed "i.marca#jan i.marca#c.ym"

global vars_tax "nov19_dic19 jan20 nov20_dic20 jan21 "
*------- interacciones:
global int_tax "i.marca#nov19_dic19 i.marca#jan20 i.marca#nov20_dic20 i.marca#jan21"
**global int_tax "i.marca#nov19_ i.marca#nov20_jan21"
*------- interacciones:
global tipo_tax "i.tipo#nov19_dic19 i.tipo#jan20 i.tipo#nov20_dic20 i.tipo#jan21"
*global tipo_tax "i.tipo#nov19_jan20 i.tipo#nov20_jan21"


/*-----------------------------------------------------
RESULTADOS CON INTERACCIONES EN L.ppu, tendencia y enero
*/
// Estático
xtreg ppu $int_tax $int_fixed, fe
outreg2 using "resultados\doc/est_xtreg_dyn_full_int$tax_def" ///
			, keep(i.marca#i.jan20 i.marca#jan21 i.marca#jan) bdec(3) tex(fragment) replace
/*
testparm jan20#i.marca
putexcel (H10) = rscalars, colwise overwritefmt
//putexcel (B8) = rscalars, colwise overwritefmt
*/
// Dinámico
xtreg ppu $int_tax $int_fixed i.marca#c.L.ppu, fe

outreg2 using "resultados\doc/est_xtreg_dyn_full_int$tax_def" ///
			, keep($int_tax $int_fixed i.marca#c.L.ppu) bdec(3) tex(fragment) append

/*
testparm jan20#i.marca
putexcel (H11) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan21#i.marca
putexcel (N11) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm jan#i.marca
putexcel (T1) = "Enero por marcas"
putexcel (T11) = rscalars, colwise overwritefmt

testparm c.ym#i.marca
putexcel (Z1) = "Tendencia por marcas"
putexcel (Z11) = rscalars, colwise overwritefmt

testparm c.L.ppu#i.marca
putexcel (AA1) = "Rezago por marcas"
putexcel (AA11) = rscalars, colwise overwritefmt
*/
*testparm nov19_jan20#i.marca
// rechazo igualdad de coeficiente por marca
*testparm nov20_jan21#i.marca
// rechazo igualdad de coeficiente por marca

/*-----------------------------------------------------
RESULTADOS POR MARCA
when estimated by brand:
int_fixed is equivalent to $varsRegStatic 

por marca:
i.marca##jan20 i.marca##jan21 substitute with: $vars_tax 
*/

capture log close
log using "resultados/est_xtreg_dyn_full_int_nov_dic.log", append


// Resultados por marcas
gen xb_ppu_2019 = .
gen xb_ppu_nodyn = .
gen xb_ppu_dyn = .

local n_marca = 1
/*
if `n_marca' == 1 {
	global append_replace = "replace"
} 
else {
	global append_replace = "append"
}
di "$append_replace" */
di `n_marca'
// modelo hasta enero 2020 (sin efecto del impuesto)
// xtreg ppu $v_taxTrend  if ym<ym(2020,1), fe
xtreg ppu $varsRegStatic if ym<ym(2020,1) & marca == `n_marca', fe
outreg2 using "resultados/doc/est_xtreg_no_tax_marca$tax_def" ///			
		, keep($varsRegStatic) bdec(3) tex(fragment) replace

predict xb_ppu_2019_`n_marca' if marca == `n_marca'
replace xb_ppu_2019 = xb_ppu_2019_`n_marca' if marca == `n_marca'
// hace la proyecci'on sin necesidad de re-ajustar la muestra?

// modelo interactuado, sin dinámica
xtreg ppu $varsRegStatic $vars_tax if marca == `n_marca', fe
outreg2 using "resultados/doc/est_xtreg_stat_marca$tax_def" ///			
			, keep($vars_tax  $varsRegStatic) bdec(3) tex(fragment) replace
predict xb_ppu_nodyn_`n_marca' if ym>=ym(2020,1)  & marca == `n_marca'
replace xb_ppu_nodyn = xb_ppu_nodyn_`n_marca' if marca == `n_marca'

// modelo interactuado, con dinámica
xtreg ppu $varsRegStatic $vars_tax L.ppu if marca == `n_marca', fe
outreg2 using "resultados/doc/est_xtreg_dyn_marca$tax_def" ///			
			, keep($vars_tax $varsRegStatic L.ppu) bdec(3) tex(fragment) replace
predict xb_ppu_dyn_`n_marca' if ym>=ym(2020,1) & marca == `n_marca'
replace xb_ppu_dyn = xb_ppu_dyn_`n_marca' if marca == `n_marca'

foreach n_marca of numlist 2/7 {
    
di `n_marca'
	// modelo hasta enero 2020 (sin efecto del impuesto)
	// xtreg ppu $v_taxTrend  if ym<ym(2020,1), fe
	xtreg ppu $varsRegStatic if ym<ym(2020,1) & marca == `n_marca', fe
	outreg2 using "resultados/doc/est_xtreg_no_tax_marca$tax_def" ///			
			, keep($vars_tax  $varsRegStatic) bdec(3) tex(fragment) append
	predict xb_ppu_2019_`n_marca' if marca == `n_marca'
	replace xb_ppu_2019 = xb_ppu_2019_`n_marca' if marca == `n_marca'
	// hace la proyecci'on sin necesidad de re-ajustar la muestra?
	
	// modelo interactuado con impuesto, sin dinámica
	xtreg ppu $varsRegStatic $vars_tax if marca == `n_marca', fe
	outreg2 using "resultados/doc/est_xtreg_stat_marca$tax_def" ///			
			, keep($vars_tax  $varsRegStatic ) bdec(3) tex(fragment) append
	predict xb_ppu_nodyn_`n_marca' if ym>=ym(2020,1)  & marca == `n_marca'
	replace xb_ppu_nodyn = xb_ppu_nodyn_`n_marca' if marca == `n_marca'

	// modelo interactuado con impuesto, con dinámica
	xtreg ppu $varsRegStatic $vars_tax L.ppu if marca == `n_marca', fe
	outreg2 using "resultados/doc/est_xtreg_dyn_marca$tax_def" ///			
			, keep($vars_tax  $varsRegStatic L.ppu) bdec(3) tex(fragment) append
	predict xb_ppu_dyn_`n_marca' if ym>=ym(2020,1) & marca == `n_marca'
	replace xb_ppu_dyn = xb_ppu_dyn_`n_marca' if marca == `n_marca'
}

gen trend = ym[_n]

export excel using "datos\finales\pred_xtreg_dyn$tax_def.xlsx", firstrow(variables) replace
save "datos\finales\pred_xtreg_dyn$tax_def.dta", replace

log close
