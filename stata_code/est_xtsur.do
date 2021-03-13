// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/wide_complete_panel.log, replace

use datos/wide_complete_panel.dta, clear

ta cve_ciudad

su ppu*

xtsur (ppu1 m1 m1_20 ym) (ppu2 m1 m1_20 ym) (ppu3 m1 m1_20 ym) (ppu4 m1 m1_20 ym) ///	
		(ppu5 m1 m1_20 ym) (ppu6 m1 m1_20 ym) (ppu7 m1 m1_20 ym) 
		
* how long does it take for the entire panel?
* is it just the computer
// xtsur (ppu1 m1 m1_20 ym) (ppu2 m1 m1_20 ym) (ppu3 m1 m1_20 ym) (ppu4 m1 m1_20 ym) ///	
//		 (ppu5 m1 m1_20 ym) (ppu6 m1 m1_20 ym) (ppu7 m1 m1_20 ym), 
// if ym >= ym[43]
		 
// en primer instancia sólo se tienen algunas marcas
/// (ppu6 m1 m1_20 ym) 
///	 (ppu2 m1 m1_20 ym) 
 
// premium  
xtsur (ppu1 m1 m1_20 ym) ///
			(ppu2 m1 m1_20 ym) ///
		(ppu5 m1 m1_20 ym) 

    outreg2 m1 m1_20 ym using est_xtsur_premium ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

		test [ppu5]m1_20=[ppu1]m1_20=[ppu2]m1_20
		// rejects equality
		
		test [ppu5]m1_20=[ppu1]m1_20
		// rejects equality

		test [ppu5]m1_20=[ppu2]m1_20
		// rejects equality
		
// bajo  
xtsur (ppu3 m1 m1_20 ym) ///
			(ppu6 m1 m1_20 ym) 

		outreg2 using est_xtsur_bajo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

			
		test [ppu6]m1_20=[ppu3]m1_20
		// No se rechaza igualdad 

// medio  
xtsur (ppu4 m1 m1_20 ym) ///
			(ppu7 m1 m1_20 ym) 

		outreg2 using est_xtsur_medio ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace  

			
		test [ppu4]m1_20=[ppu7]m1_20
		// it has no Std. Err. Estimations!! "sign is changed"
		
// solo estimaciones con periodo de 2015 en adelante		
xtsur (ppu4 m1 m1_20 ym) ///
			(ppu7 m1 m1_20 ym) if ym >= ym[43]
// los estimadores resultan "invertidos"
			
log close




