// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg.log, replace

use datos\tpCiudad.dta, clear

* sin interacciones > tendencia 
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad 
areg ppu m1 m1_20 ym i.marca, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20 ym ym i.marca) bdec(3) nocons  tex(fragment) replace

** por tipo
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad if tipo == 1
areg ppu m1 m1_20 ym i.marca if tipo == 1, absorb(cve_ciudad)

outreg2 m1 m1_20 ym using resultados\doc/est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) replace

areg ppu m1 m1_20 ym i.marca if tipo == 2, absorb(cve_ciudad) 

outreg2 m1 m1_20 ym using resultados\doc/est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

areg ppu m1 m1_20 ym i.marca if tipo == 3, absorb(cve_ciudad) 

outreg2 m1 m1_20 ym using resultados\doc/est_areg_tipo ///
			, keep(m1 m1_20 ym) bdec(3) nocons  tex(fragment) append

			*** 

			
**********///////////////////////////////////////////////////
* sin interacciones
areg ppu m1 m1_20 i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20 ym ym i.marca) bdec(3) nocons  tex(fragment) append

* dummies para mes y anio, con interacciones
*regress ppu i.marca i.month##year i.cve_ciudad
*areg ppu i.marca i.month##year, absorb(cve_ciudad)
areg ppu m1 m1_20##i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20 ym ym i.marca) bdec(3) nocons  tex(fragment) append

			* creciente, un mismo parametro para periodo
* regress ppu ym i.marca m1_20 /* diseniarlo como diferencia de la tendencia */
*regress ppu m1_20 m1 i.marca##c.ym i.cve_ciudad /* diseniarlo como diferencia de la tendencia */
*areg ppu m1_20 m1 i.marca##c.ym, absorb(cve_ciudad)


* sin interacciones
*regress ppu m1_20 m1 i.marca ym i.cve_ciudad /* diseniarlo como diferencia de la tendencia */
*areg ppu m1_20 m1 i.marca ym, absorb(cve_ciudad)

log close




