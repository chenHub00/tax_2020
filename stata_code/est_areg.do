// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg.log, replace

use datos\tpCiudad.dta, clear

* sin interacciones > tendencia 
regress ppu m1 m1_20 ym i.marca i.cve_ciudad 
areg ppu m1 m1_20 ym i.marca, absorb(cve_ciudad)

outreg2 m1 m1_20 ym using est_areg_total ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

** por tipo
regress ppu m1 m1_20 ym i.marca i.cve_ciudad if tipo == 1
areg ppu m1 m1_20 ym i.marca if tipo == 1, absorb(cve_ciudad)

outreg2 m1 m1_20 ym using est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

areg ppu m1 m1_20 ym i.marca if tipo == 2, absorb(cve_ciudad) 

outreg2 m1 m1_20 ym using est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

areg ppu m1 m1_20 ym i.marca if tipo == 3, absorb(cve_ciudad) 

outreg2 m1 m1_20 ym using est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

			*** 

			
**********///////////////////////////////////////////////////
* sin interacciones
regress ppu i.marca i.month i.year i.cve_ciudad
areg ppu i.marca i.month i.year, absorb(cve_ciudad)

outreg2 m1 m1_20 ym using est_areg_total ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

* dummies para mes y anio, con interacciones
regress ppu i.marca i.month##year i.cve_ciudad
areg ppu i.marca i.month##year, absorb(cve_ciudad)
areg ppu m1_20 m1 i.marca i.month##year, absorb(cve_ciudad)

* creciente, un mismo parametro para periodo
* regress ppu ym i.marca m1_20 /* diseniarlo como diferencia de la tendencia */
regress ppu m1_20 m1 i.marca##c.ym i.cve_ciudad /* diseniarlo como diferencia de la tendencia */
areg ppu m1_20 m1 i.marca##c.ym, absorb(cve_ciudad)


* sin interacciones
regress ppu m1_20 m1 i.marca ym i.cve_ciudad /* diseniarlo como diferencia de la tendencia */
areg ppu m1_20 m1 i.marca ym, absorb(cve_ciudad)

log close

 
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




