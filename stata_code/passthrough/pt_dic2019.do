
/* 2019-dic */
use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR inicial*/
keep if ym == ym(2019,12)  

/* GENERAR EL VALOR ESPERADO */

*### ParÃ¡metros
scalar sc_vat = .16
scalar sc_iepsf = 0.35*20
scalar sc_iepsf2020 = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
scalar sc_iepsf2021 = 0.5108*20 //# ajuste por la inflaciÃ³n vigente desde 1 enero 2021
scalar sc_iepsav = 1.60
scalar sc_ret = .28
scalar sc_infe2020 = .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
scalar sc_infe2021 = .0363 // # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020

*  # Baseline=2019
* Valores antes de impuestos
* ajustados por VAT
* precios por cajetilla (suponemos de 20 cigarros)
gen p = ppu*20
su p

// original : vat0 = p-(p/(1+vat))
// periodo 
gen vat0 = p-(p/(1+sc_vat)) if  ym == ym(2019,12)
su vat0
*histogram vat0

/*
// Prueba orden de operaciones:
scalar sc_vat_factor = (sc_vat/(1+sc_vat)) 
gen vat_test = p*sc_vat_factor
su vat_test
compare vat0 vat_test
*/
gen taxbase0 = (p-vat0-sc_iepsf)/(1+sc_ret+sc_iepsav)
su taxbase0
*histogram taxbase0

gen ret0 = sc_ret*taxbase0
su ret0 
*histogram ret0 

gen iepsav0 = sc_iepsav*taxbase0
su iepsav0
*histogram iepsav0
//  solo se define pero no se encuentra su uso: iepsf0 = iepsf 
  
*   # 2020
gen taxbase1 = taxbase0*(1+sc_infe2020)
 // ?se puede sustituir directamente, cuando se tiene un programa independiente del periodo
gen sc_iepsf1 = sc_iepsf2020
gen iepsav1 = sc_iepsav*taxbase1
gen ret1 = sc_ret*taxbase1
gen  vat1 = (taxbase1+sc_iepsf1+iepsav1+ret1)*sc_vat
gen  p1 = taxbase1+sc_iepsf1+iepsav1+ret1+vat1
su p1 taxbase1 iepsav1 ret1 vat1

*replace varlist = p1
gen pt100_jan2020= p1

* Seguimiento de versiones del programa:
* 0. el programa hace el cálculo para todas las observaciones
* 1. Se ajustó para sólo considerar la comparación de los periodos relevantes
* enero 2020, vs lo esperado de diciembre 2019 
* enero 2021, vs lo esperado de diciembre 2020
* esto es equivalente a tomar los datos de cada ciudad en lugar de considerar 
* - el promeriod
* ? en la tabla de ejemplo se consideran los promedios de todo el año para todas las ciudades?
* ? o es sólo el periodo de diciembre 2019?

/**/
keep p marca ym cve_ tipo pt100
rename pt100_jan2020 pt100

*save `file1'
save "datos/finales/pass_through100_dec2019.dta", replace
