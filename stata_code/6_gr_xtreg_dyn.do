
*do "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\cd_tabaco.do"
* do "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\cd_tabaco_usuario.do"
set more off

capture log close
log using resultados/logs/gr_xtreg_dyn.log, replace

/* PARA FINAL DE> est_one_panel_dyn.do
despu'es de 
- est_one_panel_dyn.do
*/
global varsRegStatic "jan20 jan21 jan ym"

use "datos\finales\pred_xtreg_dyn.dta", clear

// <<<<<<< HEAD
// xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21, fe
// predict xb_ppu_nodyn if ym>=ym(2020,1)
// xtreg ppu $varsRegStatic, fe
// predict xb_ppu_nodyn_nointer if ym>=ym(2020,1)
//
// xtreg ppu $varsRegStatic i.marca##jan20 i.marca##jan21 L.ppu, fe
// predict xb_ppu_dyn if ym>=ym(2020,1)
// xtreg ppu $varsRegStatic L.ppu, fe
// predict xb_ppu_dyn_nointer if ym>=ym(2020,1)
// =======

// promedios para gráficar
collapse (mean) xb_ppu_nodyn  xb_ppu_dyn xb_ppu_2019 ppu tipo, by(marca ym )

// etiquetas para gr'aficas
* label variable xb_ppu_2019 "Estático sin efecto impuestos"
* label variable xb_ppu_nodyn "Estático con interacciones"
* label variable xb_ppu_dyn "Dinámico con interacciones"
label variable xb_ppu_2019 "Tendencia previa al impuesto"
label variable xb_ppu_dyn "Estimación con impuesto"

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

// solo din'amico y tendencia
// graficos 2 marcas: Marlboro y Montana
xtline xb_ppu_dyn xb_ppu_2019  if ym > ym(2019,1) & (marca == 5 | marca == 6) 
//	, xline(2019m1)

graph save Graph "graficos\pred_dyn_2marcas.gph",  replace

graph export "graficos\pred_dyn_2marcas.pdf", as(pdf) replace
graph export "graficos\pred_dyn_2marcas.png", as(png) replace

// tipo 1
xtline xb_ppu_dyn xb_ppu_2019  if ym > ym(2019,1) & tipo == 1
//	, xline(2019m1)

graph save Graph "graficos\pred_dyn_tipo1.gph",  replace

graph export "graficos\pred_dyn_tipo1.pdf", as(pdf) replace
graph export "graficos\pred_dyn_tipo1.png", as(png) replace

// tipo 2
xtline xb_ppu_dyn xb_ppu_2019  if ym > ym(2019,1) & tipo == 2
//	, xline(2019m1)

graph save Graph "graficos\pred_dyn_tipo2.gph",  replace

graph export "graficos\pred_dyn_tipo2.pdf", as(pdf) replace
graph export "graficos\pred_dyn_tipo2.png", as(png) replace

// tipo 3
xtline xb_ppu_dyn xb_ppu_2019  if ym > ym(2019,1) & tipo == 3
//	, xline(2019m1)

graph save Graph "graficos\pred_dyn_tipo3.gph",  replace

graph export "graficos\pred_dyn_tipo3.pdf", as(pdf) replace
graph export "graficos\pred_dyn_tipo3.png", as(png) replace

log close

