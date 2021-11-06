
/*
panel_marca_ciudad_2019a2021.dta
panel_marca_ciudad_2020.dta
panel_marca_ciudad_2021.dta
*/

capture log close
log using resultados/logs/datos_passthrough100.log, replace

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

keep ppu marca ym cve_ tipo
keep if ym >= ym(2019,1) & ym <= ym(2021,4) 

save "datos/finales/panel_marca_ciudad_2019a2021.dta", replace

/* 2020 */
use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR ESPERADO A CONTRASTAR*/
keep if ym >= ym(2020,1) & ym <= ym(2020,12) 

save datos/finales/panel_marca_ciudad_2020.dta, replace

/* 2021 */

use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR ESPERADO A CONTRASTAR*/
keep if ym >= ym(2021,1) & ym <= ym(2021,4) 

save datos/finales/panel_marca_ciudad_2021.dta, replace

log close
