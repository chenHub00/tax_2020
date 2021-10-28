
capture log close
log using resultados/logs/modelo_passthrough.log, replace

use "datos/finales/pass_through100_jan2020.data", clear

ttest p == pt100_

* equivalent to: 
regress p pt100_

* observaciones por tipo
ta tipo
* bajo sólo tiene 
regress p c.pt100_#i.tipo

* equivalente :
ttest p == pt100_ if tipo == 1 
* No hay diferencia en tipo 1 (closer to full-transfer?)
ttest p == pt100_ if tipo == 2
* p observado es menor a pt100 calculado
ttest p == pt100_ if tipo == 3
* p observado es menor a pt100 calculado al 10%

use "datos/finales/pass_through100_jan2021.data", clear

ttest p == pt100_

* equivalent to: 
regress p pt100_

* observaciones por tipo
ta tipo
* bajo sólo tiene 
regress p c.pt100_#i.tipo

log close