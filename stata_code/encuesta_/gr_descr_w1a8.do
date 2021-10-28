
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"
global graficos = "graficos\exploratorios\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/graficos_descr_precio_w1a8.log", replace

global v_tab "sexo edad_gr3 educ_gr3 ingr_gr patron single tipo"

	use "$datos/cp_w1a8.dta", clear
	
//	graph bar (mean) ppu, over(wave) over(patron)
graph bar (mean) ppu, over(wave) over(patron) blabel(bar, format(%3.2f))
	
	graph save "$graficos\bar_ppu_w1a8_patron.gph", replace
	graph export "$graficos\bar_ppu_w1a8_patron.png", as(png) replace
	
	graph bar (mean) cons_por_dia, over(wave) over(patron)  blabel(bar, format(%3.2f))
	
	graph save "$graficos\bar_cons_x_dia_w1a8_patron.gph", replace
	graph export "$graficos\bar_cons_x_dia_w1a8_patron.png", as(png) replace

log close

// 	foreach var of varlist $v_tab {
// 		di "Variable " "`var'"
// 			table `var', c(mean ppu_i mean ppu_c) 
//			
// 			graph box ppu_i ppu_c, over(`var')
// 		graph save "$graficos\comparacion_ppu_w8_`var'.gph", replace
// 		graph export "$graficos\comparacion_ppu_w8_`var'.png", as(png) replace
//
// 	}

