
*do "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\cd_tabaco.do"
* do "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\cd_tabaco_usuario.do"
set more off

capture log close
log using resultados/logs/gr_xtreg_dyn.log, replace

/*
despu'es de 
- est_one_panel_dyn.do
*/
global varsRegStatic "jan20 jan21 jan ym"
// omitidos por colinealidad
// global v_taxTrend "jan20 jan21 ym"

* model with interactions:
*use datos/prelim/de_inpc/df_x.dta, clear
use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

gen xb_ppu_2019 = .
gen xb_ppu_nodyn = .
gen xb_ppu_dyn = .
foreach n_marca of numlist 1/7 {
    
di `n_marca'
	// modelo hasta enero 2020 (sin efecto del impuesto)
	// xtreg ppu $v_taxTrend  if ym<ym(2020,1), fe
	xtreg ppu $varsRegStatic if ym<ym(2020,1) & marca == `n_marca', fe

	predict xb_ppu_2019_`n_marca' if marca == `n_marca'
	replace xb_ppu_2019 = xb_ppu_2019_`n_marca' if marca == `n_marca'
	// hace la proyecci'on sin necesidad de re-ajustar la muestra?
	
	// modelo interactuado, sin dinámica
	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 if marca == `n_marca', fe
	predict xb_ppu_nodyn_`n_marca' if ym>=ym(2020,1)  & marca == `n_marca'
	replace xb_ppu_nodyn = xb_ppu_nodyn_`n_marca' if marca == `n_marca'

	// modelo interactuado, con dinámica
	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 L.ppu if marca == `n_marca', fe
	predict xb_ppu_dyn_`n_marca' if ym>=ym(2020,1) & marca == `n_marca'
	replace xb_ppu_dyn = xb_ppu_dyn_`n_marca' if marca == `n_marca'
}

gen trend = ym[_n]

export excel using "datos\finales\pred_xtreg_dyn.xlsx", firstrow(variables) replace
save "datos\finales\pred_xtreg_dyn.dta", replace

// promedios para gráficar
collapse (mean) xb_ppu_nodyn  xb_ppu_dyn xb_ppu_2019 ppu , by(marca ym )

// etiquetas para gr'aficas
label variable xb_ppu_2019 "Estático sin efecto impuestos"
label variable xb_ppu_nodyn "Estático con interacciones"
label variable xb_ppu_dyn "Dinámico con interacciones"

label variable ppu "promedio entre ciudades del precio"	
label variable ym "periodo"	
xtset marca ym 

export excel using "datos\finales\predprom_xtreg_dyn.xlsx", firstrow(variables) replace
save "datos\finales\predprom_xtreg_dyn.dta", replace

// GRAFICOS

use "datos\finales\predprom_xtreg_dyn.dta", clear
*xtline xb_ppu_nodyn xb_ppu_2019 if ym > ym(2019,1)

xtline ppu, overlay
graph save Graph "graficos\promedios_por_ciudad.gph",  replace
graph export "graficos\promedios_por_ciudad.pdf", as(pdf) replace
graph export "graficos\promedios_por_ciudad.png", as(png) replace

xtline ppu if ym > ym(2018,1), overlay
graph save Graph "graficos\prom_por_ciudad_2018_.gph",  replace

graph export "graficos\prom_por_ciudad_2018_.pdf", as(pdf) replace
graph export "graficos\prom_por_ciudad_2018_.png", as(png) replace

/*
xtline xb_ppu_nodyn , overlay
xtline xb_ppu_dyn , overlay
xtline xb_ppu_2019, overlay
*/

xtline xb_ppu_nodyn xb_ppu_dyn xb_ppu_2019  if ym > ym(2019,1)
graph save Graph "graficos\pred_dyn_stat.gph",  replace

graph export "graficos\pred_dyn_stat.pdf", as(pdf) replace
graph export "graficos\pred_dyn_stat.png", as(png) replace

log close

/* ANTERIOR
	// modelo hasta enero 2020 (sin efecto del impuesto)
	// xtreg ppu $v_taxTrend  if ym<ym(2020,1), fe
	xtreg ppu $varsRegStatic if ym<ym(2020,1), fe

	predict xb_ppu_2019_`n_marca' 
	replace xb_ppu_2019 = xb_ppu_2019_`n_marca' 
	// hace la proyecci'on sin necesidad de re-ajustar la muestra?
	
	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21, fe
	predict xb_ppu_nodyn if ym>=ym(2020,1)
	xtreg ppu $varsRegStatic, fe
	predict xb_ppu_nodyn_nointer if ym>=ym(2020,1)

	xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 L.ppu, fe
	predict xb_ppu_dyn if ym>=ym(2020,1)
	xtreg ppu $varsRegStatic L.ppu, fe
	predict xb_ppu_dyn_nointer if ym>=ym(2020,1)



preserve
collapse (mean) xb_ppu_nodyn_nointer xb_ppu_dyn_nointer xb_ppu_2019 /// 
	ppu xb_ppu_dyn xb_ppu_nodyn, by(marca ym )

// etiquetas para gr'aficas
label variable xb_ppu_2019 "Estático sin efecto impuestos"
label variable xb_ppu_nodyn "Estático con interacciones"
label variable xb_ppu_nodyn_nointer "Estático sin interacciones"
label variable xb_ppu_dyn "Dinámico con interacciones"
label variable xb_ppu_dyn_nointer "Dinámico sin interacciones"

label variable ppu "promedio entre ciudades del precio"	
label variable ym "periodo"	
xtset marca ym 

export excel using "datos\finales\prom_xb_ppu_dyn.xlsx", firstrow(variables) replace
save "datos\finales\prom_xb_ppu_dyn.dta", replace
*/

// panel graphs
/* din'amico y no din'amico: 
xtline xb_ppu_nodyn xb_ppu_dyn

graph save Graph "graficos\pred_dyn_vs_static.gph"
graph export "graficos\pred_dyn_vs_static.pdf", as(pdf) replace */

/* GRAFICOS ANTERIORES
*use "datos\finales\prom_xb_ppu_dyn.dta", clear
*xtline xb_ppu_nodyn xb_ppu_2019 if ym > ym(2019,1)
xtline ppu, overlay
graph save Graph "graficos\promedios_por_ciudad.gph"

graph export "graficos\promedios_por_ciudad.pdf", as(pdf) replace
graph export "graficos\promedios_por_ciudad.png", as(png) replace

xtline ppu if ym > ym(2018,1), overlay
graph save Graph "graficos\prom_por_ciudad_2018_.gph"

graph export "graficos\prom_por_ciudad_2018_.pdf", as(pdf) replace
graph export "graficos\prom_por_ciudad_2018_.png", as(png) replace

xtline xb_ppu_nodyn_nointer xb_ppu_dyn_nointer xb_ppu_2019  if ym > ym(2019,1)
graph save Graph "graficos\pred_dyn_stat_noefect.gph"

graph export "graficos\pred_dyn_stat_noefect.pdf", as(pdf) replace
graph export "graficos\pred_dyn_stat_noefect.png", as(png) replace
*/
*xtline ppu xb_ppu_dyn

