/* 
2020
2021 
impuesto

dta:
2020

2020 y 2021
pass_through100_2020_2021.dta

*/

capture log close
log using resultados/logs/calcula_passthrough100_2019_2021.log, replace


/* 2020+ prediccion 2019 */
use datos/finales/panel_marca_ciudad_2020.dta, clear

merge m:1 cve_ciudad marca using "datos/finales/pass_through100_dec2019.dta", 

*merge 1:1 cve_ciudad marca using `file2'
ta _
keep if _ == 3
drop _

gen pobs = ppu*20
drop ppu

save "datos/finales/pass_through100_2020.dta", replace

ttest pobs == pt100
/*
*/
su pobs* pt100


/* 2021 */
use datos/finales/panel_marca_ciudad_2021.dta, clear

merge m:1 cve_ciudad marca using "datos/finales/pass_through100_dec2020.dta", 

ta _merge
keep if _ == 3
drop _merge

gen pobs = ppu*20
drop ppu


save "datos/finales/pass_through100_2021.dta", replace

ttest pobs == pt100

/* 2020-2021 */
use "datos/finales/pass_through100_2021.dta", clear

append using "datos/finales/pass_through100_2020.dta", gen(append_2020_2021)

save "datos/finales/pass_through100_2020_2021.dta", replace

log close
