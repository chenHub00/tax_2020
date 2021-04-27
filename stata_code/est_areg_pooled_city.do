
// a partir de las estimaciones en:
// testing_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
*cd "C:\Users\vicen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg_pooled_city.log, replace

use datos\panel_marca_ciudad.dta, clear

// ver est_areg_pooled.do

// por marca
use datos\panel_marca_ciudad.dta if cve_ciudad == 1, clear

xtset marca ym 

xtreg ppu m1_20 m1 ym, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_ciudades ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtunitroot fisher ppu, dfuller lags(4)

foreach number of numlist 2/4 {
di "`number'"

use datos\panel_marca_ciudad.dta if cve_ciudad == `number', clear

xtset marca ym 
gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_ciudades ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

xtunitroot fisher ppu, dfuller lags(4)
}
/*
local number = 5 
di "`number'"

use datos\panel_marca_ciudad.dta if cve_ciudad == `number', clear

xtset cve_ciudad ym 
gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_p2 ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

xtunitroot fisher ppu, dfuller lags(4)

foreach number of numlist 5 6 7 {
di "`number'"

use datos\panel_marca_ciudad.dta if marca == `number', clear

xtset cve_ciudad ym 
// gen dif_ppu = d.ppu

xtreg ppu m1_20 m1 ym, fe
*estimates store fixed
outreg2 using resultados/doc/est_xt_marcas_p2 ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

xtunitroot fisher ppu, dfuller lags(4)
}
*/
					
log close

