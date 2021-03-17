// a partir de las estimaciones en:
// complete_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_xt_means_cities.log, replace

// panel: marca promedios

use datos\xt_marca.dta, clear

xtreg ppu m1 m1_20 L.ppu, fe

outreg2 m1 m1_20 ym using est_xt_means_cities ///
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

outreg2 m1 m1_20 ym using est_xt_means_diff ///
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

// panel: ciudad promedios
capture log close
log using complete_panel_results.log, append

use datos\xt_ciudad.dta, clear
*xtabond ppu m1 m1_20, lags(1) artests(2): estimable?
* en diferencias la especificación debe ser diferente para 
* identificar m1 m1_20
xtreg ppu m1 m1_20 L.ppu, fe

predict resid_marcas, resid

xtline resid_marcas

predict ppu_marcas
gen ppu_marcas_sq = ppu_marcas^2

xtreg ppu ppu_marcas ppu_marcas_sq
test ppu_marcas_sq
* se rechaza misespecificación
* referencia web:
* Pregibon test (https://www.jstor.org/stable/2346405):
* https://www.statalist.org/forums/forum/general-stata-discussion/general/1481398-residuals-in-a-panel-data-model 

log close


* sin interacciones

/////// TESTS
			test [ppu4]m1_20=[ppu7]m1_20
		// it has no Std. Err. Estimations!! "sign is changed"

** por tipo

outreg2 m1 m1_20 ym using est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace


/////// TESTS
			test [ppu4]m1_20=[ppu7]m1_20
		// it has no Std. Err. Estimations!! "sign is changed"
					
log close




