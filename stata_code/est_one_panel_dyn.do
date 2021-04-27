// a partir de las estimaciones en:
// complete_panel_data.do 


capture log close
log using resultados/est_one_panel_dyn.log, replace

use datos\panel_marca_ciudad.dta, clear

// 
xtreg ppu m1 m1_20 d.ppu, fe
*predict resid_d_marcas, resid

outreg2 m1 m1_20 ym using resultados/doc/est_xtreg_dif ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

** prueba de especificacion:
predict ppu_marcas
gen ppu_marcas_sq = ppu_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq

* se rechaza misespecificación
* referencia web:
* Pregibon test (https://www.jstor.org/stable/2346405):
* https://www.statalist.org/forums/forum/general-stata-discussion/general/1481398-residuals-in-a-panel-data-model 
xtreg ppu m1 i.tipo##i.m1_20 d.ppu, fe

*coefplot, xline(0)

outreg2 using resultados/doc/est_xtreg_dif ///
			, keep(m1 i.tipo##i.m1_20 ym ) bdec(3) nocons  tex(fragment) append
		
// Modelo en diferencias

xtreg d.ppu m1 m1_20 L.d.ppu, fe
*predict resid_d_marcas, resid

outreg2 using resultados/doc/est_xtreg_2dif ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

predict ppu_d_marcas
gen ppu_d_marcas_sq = ppu_d_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq

xtreg d.ppu m1 i.tipo##i.m1_20 L.d.ppu, fe
*predict resid_d_marcas, resid

outreg2 using resultados/doc/est_xtreg_2dif ///
			, keep(m1 i.tipo##i.m1_20) bdec(3) nocons  tex(fragment) append

log close

