
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

* equivalente :
ttest pobs == pt100 if tipo == 1 
* No hay diferencia en tipo 1 (closer to full-transfer?)
ttest pobs == pt100 if tipo == 2
* p observado es menor a pt100 calculado
ttest pobs == pt100 if tipo == 3
* p observado es menor a pt100 calculado al 10%

*************** Marlboro *************** 
ttest pobs == pt100 if marca == 5

* equivalent to: 
regress pobs pt100 if marca == 5


*************** Pall Mall *************** 
ttest pobs == pt100 if marca == 7

* equivalent to: 
regress pobs pt100 if marca == 7


log close

/*----------------------------------------------------------------------------- Para pruebas t por periodos, en años completos 
------------------------------------------------------------------------------*/

capture log close
log using resultados/logs/modelo_passthrough_2020.log, replace

use "datos/finales/pass_through100_2020_2021.dta", clear
*use "datos/finales/pass_through100_jan2020.dta", clear

ttest pobs == pt100 if ym >= ym(2020,1) & ym <= ym(2020,12)

* equivalent to? 
regress pobs pt100 if ym >= ym(2020,1) & ym <= ym(2020,12)

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

capture log close
log using resultados/logs/modelo_passthrough_2021.log, replace

use "datos/finales/pass_through100_2020_2021.dta", clear
*use "datos/finales/pass_through100_jan2021.dta", clear

ttest pobs == pt100 if ym >= ym(2021,1) & ym <= ym(2021,4)

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
