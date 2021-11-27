
capture log close
log using resultados/logs/modelo_passthrough.log, replace

use "datos/finales/pass_through100_jan2020.dta", clear

ttest pobs_jan2020 == pt100_

* equivalent to: 
regress pobs_jan2020 pt100_

* observaciones por tipo
ta tipo
* bajo sólo tiene 
regress pobs_jan2020 c.pt100_#i.tipo

* equivalente :
ttest pobs_jan2020 == pt100_ if tipo == 1 
* No hay diferencia en tipo 1 (closer to full-transfer?)
ttest pobs_jan2020 == pt100_ if tipo == 2
* p observado es menor a pt100 calculado
ttest pobs_jan2020 == pt100_ if tipo == 3
* p observado es menor a pt100 calculado al 10%

*************** Marlboro *************** 
ttest pobs_jan2020 == pt100_ if marca == 5

* equivalent to: 
regress pobs_jan2020 pt100_ if marca == 5


*************** Pall Mall *************** 
ttest pobs_jan2020 == pt100_ if marca == 7

* equivalent to: 
regress pobs_jan2020 pt100_ if marca == 7

use "datos/finales/pass_through100_jan2021.dta", clear

ttest pobs_jan2021 == pt100_

* equivalent to: 
regress pobs_jan2021 pt100_

* observaciones por tipo
ta tipo
* bajo sólo tiene 
regress pobs_jan2021 c.pt100_#i.tipo

* equivalente :
ttest pobs_jan2021 == pt100_ if tipo == 1 
* No hay diferencia en tipo 1 (closer to full-transfer?)
ttest pobs_jan2021 == pt100_ if tipo == 2
* p observado es menor a pt100 calculado
ttest pobs_jan2021 == pt100_ if tipo == 3
* p observado es menor a pt100 calculado al 10%

*************** Marlboro *************** 
ttest pobs_jan2021 == pt100_ if marca == 5

* equivalent to: 
regress pobs_jan2021 pt100_ if marca == 5


*************** Pall Mall *************** 
ttest pobs_jan2021 == pt100_ if marca == 7

* equivalent to: 
regress pobs_jan2021 pt100_ if marca == 7

log close
