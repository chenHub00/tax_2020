// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg.log, replace

* use datos\tpCiudad.dta, clear
* marca con Raleigh por Lucky
use datos\tpCiudad2.dta, clear

* sin interacciones > tendencia 
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad 
areg ppu m1 m1_20 ym i.marca, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20 ym ym i.marca) bdec(3) nocons  tex(fragment) replace

testparm i.marca

* interacciones de m1_20 con marca, con tendencia de tiempo
areg ppu m1 m1_20##i.marca ym, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20##i.marca ym) bdec(3) nocons  tex(fragment) append

testparm m1_20#i.marca

* comparacion de cambio de definicion de marca
areg ppu m1 m1_20 ym i.marca if marca2 < 9, absorb(cve_ciudad)
* Mayo11: se pierden 41 observaciones en esta selecci'on, 
* respecto a la seleccion del documento anterior

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
* sin interacciones de m1_20 con marca
areg ppu m1 m1_20 i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20 i.marca) bdec(3) nocons  tex(fragment) append
			
* dummies para mes y anio, con interacciones
*regress ppu i.marca i.month##year i.cve_ciudad
*areg ppu i.marca i.month##year, absorb(cve_ciudad)
areg ppu m1 m1_20##i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1 m1_20##i.marca  i.marca) bdec(3) nocons  tex(fragment) append

testparm m1_20#i.marca

log close




