// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte
 
capture log close
log using resultados/wide_complete_panel.log, replace

*use datos/wide_complete_panel.dta, clear
use datos/prelim/de_inpc/wide_complete_panel.dta, clear

global varsRegStatic "m1_20 m1_21 m1 ym"

ta cve_ciudad

su ppu*

/*xtsur (ppu1 m1 m1_20 ym) (ppu2 m1 m1_20 ym) (ppu3 m1 m1_20 ym) (ppu4 m1 m1_20 ym) ///	
		(ppu5 m1 m1_20 ym) (ppu6 m1 m1_20 ym) (ppu7 m1 m1_20 ym) 
NOT RUNNING...		
classdef _b_stat() in use
(nothing dropped)
(327 lines skipped)
(error occurred while loading xtsur.ado)
* how long does it take for the entire panel?
* is it just the computer
// xtsur (ppu1 m1 m1_20 ym) (ppu2 m1 m1_20 ym) (ppu3 m1 m1_20 ym) (ppu4 m1 m1_20 ym) ///	
//		 (ppu5 m1 m1_20 ym) (ppu6 m1 m1_20 ym) (ppu7 m1 m1_20 ym), 
// if ym >= ym[43]
		 
// en primer instancia sólo se tienen algunas marcas
/// (ppu6 m1 m1_20 ym) 
///	 (ppu2 m1 m1_20 ym) 
 */
// premium  
xtsur (ppu1 $varsRegStatic) ///
			(ppu2 $varsRegStatic ) ///
		(ppu5 $varsRegStatic ) 

    outreg2 using resultados/doc/est_xtsur_premium ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace

		test [ppu5]m1_20=[ppu1]m1_20=[ppu2]m1_20
		// no se puede rechazar igualdad
		test [ppu5]m1_21=[ppu1]m1_21=[ppu2]m1_21
		// sin estimadores de error estandar para m1_21
		
		test [ppu5]m1_20=[ppu1]m1_20
		// no se puede rechazar igualdad
		test [ppu5]m1_21=[ppu1]m1_21
		// sin estimadores de error estandar para m1_21

		test [ppu5]m1_20=[ppu2]m1_20
		// no se puede rechazar igualdad
		test [ppu5]m1_21=[ppu2]m1_21
		// sin estimadores de error estandar para m1_21
		
// bajo  
xtsur (ppu3 $varsRegStatic) ///
			(ppu6 $varsRegStatic) 

		outreg2 using resultados/doc/est_xtsur_bajo ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace

		test [ppu6]m1_20=[ppu3]m1_20
		// Se rechaza igualdad 
		test [ppu6]m1_21=[ppu3]m1_21
		// Se rechaza igualdad 

// medio  
xtsur (ppu4 $varsRegStatic) ///
			(ppu7 $varsRegStatic) 

		outreg2 using resultados/doc/est_xtsur_medio ///
			, keep($varsRegStatic) bdec(3) nocons  tex(fragment) replace  
			
		test [ppu4]m1_20=[ppu7]m1_20
		// rechaza igualdad
		
		// before the change in Raleigh to Lucky
		// no Std. Err. Estimations!! "sign error"
		test [ppu4]m1_21=[ppu7]m1_21
		// rechaza igualdad
		
		
log close

asdoc test [ppu4]m1_20=[ppu7]m1_20, save(medium_effects) replace
asdoc test [ppu4]m1_21=[ppu7]m1_21, save(medium_effects) append

