
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_xtsur_det2.log, replace

use datos/wide_complete_panel.dta, clear

gen ym2 = ym^2

xtsur (ppu4 m1 m1_20 ym ym2) (ppu7 m1 m1_20 ym ym2) 

outreg2 m1 m1_20 using est_xtsur_det2 ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

gen ym2012 = ym <= ym(2012,1)
gen ym2013 = ym <= ym(2013,1)
gen ym2014 = ym <= ym(2014,1)
gen ym2015 = ym <= ym(2015,1)
gen ym2016 = ym <= ym(2016,1)
gen ym2017 = ym <= ym(2017,1)
gen ym2018 = ym <= ym(2018,1)
gen ym2019 = ym <= ym(2019,1)
gen ym2020 = ym <= ym(2020,1)

xtsur (ppu4 m1 m1_20 ym2012 ym2013 ym2014 ym2015 ym2016 ym2017 ym2018 ym2019 ym2020) ///
	(ppu7 m1 m1_20 ym2012 ym2013 ym2014 ym2015 ym2016 ym2017 ym2018 ym2019 ym2020) 

outreg2 m1 m1_20 using est_xtsur_spline ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

log close


