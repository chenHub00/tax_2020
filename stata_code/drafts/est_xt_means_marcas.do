// a partir de las estimaciones en:
// complete_panel_data.do 
 
capture log close
log using resultados/est_xt_means_marcas.log, replace

// panel: ciudad promedios
use datos\xt_ciudad.dta, clear

xtreg ppu m1 m1_20 L.ppu, fe

outreg2 m1 m1_20 ym using est_xt_means_marcas ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

predict resid_marcas, resid
*xtline resid_marcas

predict ppu_marcas
gen ppu_marcas_sq = ppu_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq
* prueba no significativa:
* se rechaza misespecificación

// 
xtreg d.ppu m1 m1_20 L.d.ppu, fe

outreg2 m1 m1_20 ym using est_xt_marcas_diff ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

predict resid_d_marcas, resid

*xtline resid_d_marcas

predict d_ppu_marcas
gen d_ppu_marcas_sq = d_ppu_marcas^2

xtreg d.ppu d_ppu_marcas d_ppu_marcas_sq
test d_ppu_marcas_sq
* prueba no significativa:
* se rechaza misespecificación

log close
