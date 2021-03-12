//
// Planteamiento basado en:  
/* The Stata Journal (2005)
5, Number 2, pp. 202–207
Estimation and testing of fixed-effect
panel-data systems
J. Lloyd Blackwell, III
Department of Economics
University of North Dakota
*/

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_xtgls.log, replace

*use datos\tpCiudad.dta, clear
*drop if cve_ciudad > 46
use datos\panel_marca_ciudad, clear

ta cve_ciudad 
ta marca, gen(c)
* c1 a c7 indican la marca 

* variables dependientes
foreach var of varlist c1-c7 {
	foreach varReg of varlist m1 m1_20 ym {
		gen x`var'_`varReg' = `var'*`varReg'
	}
}

* panel
foreach var of varlist c1-c7 {
	foreach num of numlist 1/46 {
		gen d_`var'_`num' = (`var' == 1 & cve_ciudad == `num')
	}
}

foreach num of numlist 1/6 {
	local num2 = `num'+1
	order d_c`num'_*, before(xc`num2'_m1)
}

xtgls ppu c1 xc1_* d_c1_2-d_c1_46 c2 xc1_* d_c2_2-d_c2_46 ///
		, p(c) c(psar1) nocon 
		
		/*
ym is not regularly spaced or does not have intervals of delta -- use 
the force option to treat the intervals as though they were regular
r(459);
*/
log close
 // para comparar xtgls con xtpcse ver: 
// https://www.stata.com/support/faqs/statistics/xtgls-versus-regress/
		
		//xtsur (ppu1 m1 m1_20 ym) (ppu2 m1 m1_20 ym) (ppu3 m1 m1_20 ym) (ppu4 m1 m1_20 ym) ///	
//		(ppu5 m1 m1_20 ym) (ppu6 m1 m1_20 ym) (ppu7 m1 m1_20 ym) 
//		if ym >= ym[43]
		
* how long does it take for the entire panel?
* is it just the computer
 
 
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
			




