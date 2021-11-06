
capture log close
log using resultados/logs/modelo_passthrough_2020_2021.log, replace

use "datos/finales/pass_through100_2020_2021.dta", clear

ttest pobs == pt100

* equivalent to: 
regress pobs pt100

* observaciones por tipo
ta tipo
* bajo sólo tiene 
regress pobs c.pt100#i.tipo

log close
