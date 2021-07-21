// a partir de los resultados en
// complete_panel_data.do
// se preparan variables usadas en esta parte

*cd "C:\Users\vicen\Documentos\colabs\salud\tabaco\"
*cd "C:\Users\vicen\Documents\R\tax_ene2020\tax_2020\"
 
capture log close
log using resultados/est_areg.log, replace

global varsRegStatic "m1_20 m1_21 m1 ym"
putexcel set "resultados\doc\f_tests_areg.xlsx", sheet(areg, replace) modify
putexcel (C1) = "gl Denominator"
putexcel (E1) = "gl Numerator"
putexcel (D1) = "F"
putexcel (F1) = "prob > F"

* use datos\tpCiudad.dta, clear
use datos/prelim/de_inpc/tpCiudad2.dta if cve_ciudad <= 46, clear

* sin interacciones > tendencia 
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad 
*areg ppu m1 m1_20 ym i.marca, absorb(cve_ciudad)
areg ppu $varsRegStatic i.marca, absorb(cve_ciudad)
testparm i.marca
// H0: igualdad de parametros 
// (promedio del precio por marca)
putexcel (A2) = "marca"
putexcel (B2) = rscalars, colwise overwritefmt

outreg2 using resultados/doc/est_areg_total ///
			, keep($varsRegStatic i.marca) bdec(3) nocons  tex(fragment) replace

// absorb marca
areg ppu $varsRegStatic i.cve_ciudad, absorb(marca)
testparm i.cve_ciudad
// H0: igualdad de parametros 

// cluster ciudad
areg ppu $varsRegStatic i.marca, absorb(cve_ciudad) vce(cluster cve_ciudad)
testparm i.marca
// H0: igualdad de parametros 

// cluster marca
areg ppu $varsRegStatic i.marca, absorb(cve_ciudad) vce(cluster marca)
testparm i.marca
// H0: igualdad de parametros 

// 
* interacciones de m1_20 con marca, con tendencia de tiempo
* areg ppu m1_20##i.marca m1 ym, absorb(cve_ciudad)
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym, absorb(cve_ciudad)
testparm i.marca
putexcel (A3) = "impuesto y marca"
putexcel (B3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

testparm m1_20#i.marca
putexcel (H1) = "marca con impuesto 2020"
putexcel (H3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N1) = "marca con impuesto 2021"
putexcel (N3) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

outreg2 using resultados/doc/est_areg_total ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append


* comparacion de cambio de definicion de marca
*areg ppu m1_20  m1_21 m1  ym i.marca if marca2 < 9, absorb(cve_ciudad)
areg ppu $varsRegStatic  i.marca if marca2 < 9, absorb(cve_ciudad)
* Mayo11: se pierden 41 observaciones en esta selecci'on, 
* respecto a la seleccion del documento anterior

/*-------------------------------------------------------
** por tipo o SEGMENTO
-------------------------------------------------------*/
// ALTO
*regress ppu m1 m1_20 ym i.marca i.cve_ciudad if tipo == 1
*areg ppu m1 m1_20 ym i.marca if tipo == 1, absorb(cve_ciudad)
areg ppu $varsRegStatic i.marca if tipo == 1, absorb(cve_ciudad)
testparm i.marca
putexcel (A4) = "Alto"
putexcel (B4) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

outreg2 using resultados\doc/est_areg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) replace
// interacciones marca e impuestos
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 1, absorb(cve_ciudad)
testparm i.marca

putexcel (A5) = "Alto: con interacción marca e impuestos"
putexcel (B5) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H5) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N5) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_areg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			
*-------------------------------------------------------
// MEDIO
areg ppu $varsRegStatic i.marca if tipo == 2, absorb(cve_ciudad)
testparm i.marca
putexcel (A6) = "Medio"
putexcel (B6) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 

outreg2 using resultados\doc/est_areg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append

areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 2, absorb(cve_ciudad)
testparm i.marca

putexcel (A7) = "Medio: con interacción marca e impuestos"
putexcel (B7) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H7) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N7) = rscalars, colwise overwritefmt
						
outreg2 using resultados\doc/est_areg_tipo ///
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			
*-------------------------------------------------------
// BAJO
areg ppu $varsRegStatic i.marca if tipo == 3, absorb(cve_ciudad)
testparm i.marca
putexcel (A8) = "Bajo"
putexcel (B8) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_areg_tipo ///
			, keep($varsRegStatic i.marca) bdec(3) tex(fragment) append
			
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 ym if tipo == 3, absorb(cve_ciudad)
testparm i.marca

putexcel (A9) = "Bajo: con interacción marca e impuestos"
putexcel (B9) = rscalars, colwise overwritefmt

testparm m1_20#i.marca
putexcel (H9) = rscalars, colwise overwritefmt
// H0: igualdad de parametros 
// rechazo h0, son iguales

testparm m1_21#i.marca
putexcel (N9) = rscalars, colwise overwritefmt

outreg2 using resultados\doc/est_areg_tipo ///			
			, keep(i.marca m1_20##i.marca m1_21##i.marca m1 ym) bdec(3) tex(fragment) append
			
**********///////////////////////////////////////////////////
* sin interacciones de m1_20 con marca
*areg ppu m1 m1_20 i.marca i.month i.year, absorb(cve_ciudad)
areg ppu m1_20 m1_21 m1 i.marca i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1_20 m1_21 i.marca) bdec(3) tex(fragment) append
			
* dummies para mes y anio, con interacciones
*regress ppu i.marca i.month##year i.cve_ciudad
*areg ppu i.marca i.month##year, absorb(cve_ciudad)
*areg ppu m1_20##i.marca m1 i.month i.year, absorb(cve_ciudad)
areg ppu i.marca m1_20##i.marca m1_21##i.marca m1 i.month i.year, absorb(cve_ciudad)

outreg2 using resultados\doc/est_areg_total ///
			, keep(m1_20##i.marca m1_21##i.marca m1 i.marca) bdec(3) tex(fragment) append

testparm m1_20#i.marca
testparm m1_21#i.marca

log close




