
capture log close
log using resultados/logs/desc_passthrough100_2020_2021.log, replace

use "datos/finales/pass_through100_2020_2021.dta", clear

ta marca, su(pobs)
ta marca, su(pt100)

ta marca if ym >= ym(2021,1) & ym <= ym(2021,4), su(pobs)
ta marca if ym >= ym(2021,1) & ym <= ym(2021,4), su(pt100) 

ta marca if ym >= ym(2020,1) & ym <= ym(2020,12), su(pobs)
ta marca if ym >= ym(2020,1) & ym <= ym(2020,12), su(pt100) 

log close

capture log close
log using resultados/logs/desc_tipo_pt100_2020_2021.log, replace

use "datos/finales/pass_through100_2020_2021.dta", clear
/* Tipo */
ta tipo if ym >= ym(2020,1) & ym <= ym(2020,12), su(pobs)
ta tipo if ym >= ym(2020,1) & ym <= ym(2020,12), su(pt100) 

ta tipo if ym >= ym(2020,1) & ym <= ym(2020,12), su(pobs)
ta tipo if ym >= ym(2020,1) & ym <= ym(2020,12), su(pt100) 

log close
