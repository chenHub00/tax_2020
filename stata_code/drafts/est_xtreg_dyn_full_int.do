// modelos dinámicos 
// con interacciones completas
// estimaciones similares a 
// Seemingly Unrelated Regression
set more off

capture log close
log using resultados/est_xtreg_dyn_full_int.log, append
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
global varsRegStatic "jan20 jan21 jan ym"

/*-----------------------------------------------------
RESULTADOS CON INTERACCIONES EN L.ppu, tendencia y enero
*/
// Estático
xtreg ppu i.marca#i.jan20 i.marca#jan21 i.marca#jan i.marca#c.ym, fe
outreg2 using resultados\doc/est_xtreg_dyn_full_int ///
			, keep(i.marca#i.jan20 i.marca#jan21 i.marca#jan) bdec(3) tex(fragment) replace

testparm jan20#i.marca
putexcel (H10) = rscalars, colwise overwritefmt
//putexcel (B8) = rscalars, colwise overwritefmt

// Dinámico
xtreg ppu i.marca#i.jan20 i.marca#jan21 i.marca#jan i.marca#c.ym i.marca#c.L.ppu, fe

outreg2 using resultados\doc/est_xtreg_dyn_full_int ///
			, keep(i.marca#i.jan20 i.marca#jan21 i.marca#jan i.marca#c.L.ppu) bdec(3) tex(fragment) append

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

/*-----------------------------------------------------
RESULTADOS POR MARCA
*/

capture log close
log using resultados/est_xtreg_dyn_full_int.log, append


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
outreg2 using resultados/doc/est_xtreg_no_tax_marca ///			
		, keep($varsRegStatic) bdec(3) tex(fragment) replace

predict xb_ppu_2019_`n_marca' if marca == `n_marca'
replace xb_ppu_2019 = xb_ppu_2019_`n_marca' if marca == `n_marca'
// hace la proyecci'on sin necesidad de re-ajustar la muestra?

// modelo interactuado, sin dinámica
xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 if marca == `n_marca', fe
outreg2 using resultados/doc/est_xtreg_stat_marca ///			
			, keep(i.marca##jan20 i.marca##jan21  $varsRegStatic) bdec(3) tex(fragment) replace
predict xb_ppu_nodyn_`n_marca' if ym>=ym(2020,1)  & marca == `n_marca'
replace xb_ppu_nodyn = xb_ppu_nodyn_`n_marca' if marca == `n_marca'

// modelo interactuado, con dinámica
xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 L.ppu if marca == `n_marca', fe
outreg2 using resultados/doc/est_xtreg_dyn_marca ///			
			, keep(i.marca##jan20 i.marca##jan21  $varsRegStatic L.ppu) bdec(3) tex(fragment) replace
predict xb_ppu_dyn_`n_marca' if ym>=ym(2020,1) & marca == `n_marca'
replace xb_ppu_dyn = xb_ppu_dyn_`n_marca' if marca == `n_marca'

foreach n_marca of numlist 2/7 {
    
di `n_marca'
	// modelo hasta enero 2020 (sin efecto del impuesto)
	// xtreg ppu $v_taxTrend  if ym<ym(2020,1), fe
	xtreg ppu $varsRegStatic if ym<ym(2020,1) & marca == `n_marca', fe
	outreg2 using resultados/doc/est_xtreg_no_tax_marca ///			
			, keep(i.marca##jan20 i.marca##jan21  $varsRegStatic L.ppu) bdec(3) tex(fragment) append
	predict xb_ppu_2019_`n_marca' if marca == `n_marca'
	replace xb_ppu_2019 = xb_ppu_2019_`n_marca' if marca == `n_marca'
	// hace la proyecci'on sin necesidad de re-ajustar la muestra?
	
	// modelo interactuado, sin dinámica
	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 if marca == `n_marca', fe
	outreg2 using resultados/doc/est_xtreg_stat_marca ///			
			, keep(i.marca##jan20 i.marca##jan21  $varsRegStatic L.ppu) bdec(3) tex(fragment) append
	predict xb_ppu_nodyn_`n_marca' if ym>=ym(2020,1)  & marca == `n_marca'
	replace xb_ppu_nodyn = xb_ppu_nodyn_`n_marca' if marca == `n_marca'

	// modelo interactuado, con dinámica
	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 L.ppu if marca == `n_marca', fe
	outreg2 using resultados/doc/est_xtreg_dyn_marca ///			
			, keep(i.marca##jan20 i.marca##jan21  $varsRegStatic L.ppu) bdec(3) tex(fragment) append
	predict xb_ppu_dyn_`n_marca' if ym>=ym(2020,1) & marca == `n_marca'
	replace xb_ppu_dyn = xb_ppu_dyn_`n_marca' if marca == `n_marca'
}

gen trend = ym[_n]

export excel using "datos\finales\pred_xtreg_dyn.xlsx", firstrow(variables) replace
save "datos\finales\pred_xtreg_dyn.dta", replace

log close
