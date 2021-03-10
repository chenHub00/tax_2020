// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

cd "C:\Users\vicen\OneDrive\Documentos\colabs\salud\tabaco\"

capture log close
log using resultados/wide_complete_panel.log, replace

use datos/wide_complete_panel.dta, clear

ta cve_ciudad

su ppu*


// en primer instancia sólo se tienen algunas marcas
/// (ppu6 m1 m1_20 ym) 
///	 (ppu2 m1 m1_20 ym) 
 
xtsur (ppu1 m1 m1_20 ym) (ppu5 m1 m1_20 ym) ///	
		 (ppu7 m1 m1_20 ym)

test [ppu5]m1_20=[ppu1]m1_20=[ppu7]m1_20
		 
log close

/*

xtsur (d_ppu1 m1 m1_20 lag_ppu1) (d_ppu5 m1 m1_20 lag_ppu5) (d_ppu7 m1 m1_20 lag_ppu7)

xtsur (d_ppu1 m1 m1_20 lag_ppu1) (d_ppu5 m1 m1_20 lag_ppu5)



