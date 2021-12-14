
// a partir de las estimaciones en:
// complete_panel_data.do 

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_one_panel.log, replace

use datos\panel_marca_ciudad.dta, clear


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

