/*
Variables de tabla de adolescentes:
- escolaridad (nivel, grado)
- 

*/
set more off 

capture log close
log using resultados/ensanut/tabla_residentes.log, replace

do stata_code/ensanut/dirEnsanut.do

/* ------------------------------ 2020-------------------------------- */

*Uso de la base de datos de adultos
use "$datos\2020\integrantes_ensanut2020_w.dta", clear

keep FOLIO_I ID_INT H0317A H0317G
rename H0317A nivel
rename H0317G grado
/*FOLIO_I
ID_INT
FOLIO_INT
ENTIDAD
DESC_ENT
VIVO*/

// grupos de escolaridades
* hasta primaria completa
gen gr_educ = 1 if (nivel <= 2 & grado <= 6)
* secundaria
recode gr_educ (.= 2) if (nivel == 3 & grado <= 3)
* preparatoria o tecnica
recode gr_educ (. = 3) if (nivel <= 8 & nivel >= 4)
recode gr_educ (.= 4) if (nivel >= 9 & nivel<= 10)
recode gr_educ (.= 5) if (nivel >= 11) & !missing(nivel)
label variable gr_educ "grupos de escolaridad"
label define gr_educ 1 "Hasta Primaria completa" 2 "Secundaria completa" ///
	3 "Técnica o Preparatoria" 4 "Universidad o posterior" 5 "Otro"
label values gr_educ gr_educ

* hasta primaria completa
gen educ_gr2 = 1 if  (nivel <= 2 & grado <= 6)
replace educ_gr2 = 2 if (nivel == 3 )
replace educ_gr2 = 3 if (nivel == 6 | nivel == 7 | nivel == 8) /*Técnica*/ 
replace educ_gr2 = 4 if (nivel == 4 | nivel == 5) 
replace educ_gr2 = 5 if (nivel == 9 | nivel == 10) & (grado < 4) 
replace educ_gr2 = 6 if (nivel == 9 | nivel == 10) & (grado >= 4 & !missing(grado)) 
replace educ_gr2 = 7 if (nivel == 11 | nivel == 12)
replace educ_gr2 = . if (nivel == .)

label variable educ_gr2 "grupos de escolaridad"
label define educ_gr2  1 "Hasta primaria completa" 2 "Secundaria completa" ///
	3 "Técnica" 4 "Preparatoria" 5 "Licenciatura incompleta" /// 
	6 "Licenciatura completa" 7 "Posgrado" 9 "Otro", modify
label values educ_gr2  educ_gr2

gen educ_gr3 = educ_gr2
// posgrado se une a Licenciatura completa
recode educ_gr3  (1 = 2) (7 = 6)
label define educ_gr3  2 "<= Sec comp" ///
	3 "Técnica" 4 "Prepa" 5 "Lic incomp" /// 
	6 "Lic comp y posgrado" 9 "Otro", modify
label values educ_gr3  educ_gr3

save "$datos\2020\vars_educ.dta", replace
 
use "$datos\2020\hogar_ensanut2020_ww.dta", clear

/*FOLIO_I
*/

keep FOLIO_I H0326
ta H0326

label copy H0326 ingr_gr 
label define ingr_gr  6 "" 8 "", modify
gen ingr_gr: ingr_gr = H0326
recode ingr_gr (6 8=.)

/* 
3.27 Aproximadamente, ¿cuánto dinero ganan
regularmente todos los miembros del hogar al mes?
LEE Y ANOTA UN CÓDIGO
1 – 5,999 pesos………………………………... 1
6,000 – 9,999 pesos…………………………... 2
10,000 – 13,999 pesos………………………... 3
14,000 – 21,999 pesos………………………... 4
22,000 – o más pesos………………………… 5
No perciben ingresos………………………….. 6
No quiso responder……………………………. 8
No sabe…………………………………………. 9

*/



*Guardado de la base de datos
save "$datos\2020\vars_ingr_gr.dta", replace


/* ------------------------------ 2018 -------------------------------- */

*Uso de la base de datos de adultos
use "$datos\2018\CS_RESIDENTES.dta", clear


* UPM VIV_SEL HOGAR NUMREN
keep upm_dis viv_sel hogar numren nivel grado

/* nivel y grado: : residentes	*/

// grupos de escolaridades
gen gr_educ = 1 if (nivel <= 2 & grado <= 6)
recode gr_educ (.= 2) if (nivel == 3 & grado <= 3)
recode gr_educ (. = 3) if (nivel <= 8 & nivel >= 4)
recode gr_educ (.= 4) if (nivel >= 9 & nivel<= 10)
recode gr_educ (.= 5) if (nivel >= 11) & !missing(nivel)
label variable gr_educ "grupos de escolaridad"
label define gr_educ 1 "Hasta Primaria completa" 2 "Secundaria completa" ///
	3 "Técnica o Preparatoria" 4 "Universidad o posterior" 5 "Otro"
label values gr_educ gr_educ

gen educ_gr2 = 1 if  (nivel <= 2 & grado <= 6)
replace educ_gr2 = 2 if (nivel == 3 )
replace educ_gr2 = 3 if (nivel == 6 | nivel == 7 | nivel == 8) /*Técnica*/ 
replace educ_gr2 = 4 if (nivel == 4 | nivel == 5) 
replace educ_gr2 = 5 if (nivel == 9 | nivel == 10) & (grado < 4) 
replace educ_gr2 = 6 if (nivel == 9 | nivel == 10) & (grado >= 4 & !missing(grado)) 
replace educ_gr2 = 7 if (nivel == 11 | nivel == 12)
replace educ_gr2 = . if (nivel == .)

label variable educ_gr2 "grupos de escolaridad"
label define educ_gr2  1 "Hasta primaria completa" 2 "Secundaria completa" ///
	3 "Técnica" 4 "Preparatoria" 5 "Licenciatura incompleta" /// 
	6 "Licenciatura completa" 7 "Posgrado" 9 "Otro", modify
label values educ_gr2  educ_gr2

gen educ_gr3 = educ_gr2
// posgrado se une a Licenciatura completa
recode educ_gr3  (1 = 2) (7 = 6)
label define educ_gr3  2 "<= Sec comp" ///
	3 "Técnica" 4 "Prepa" 5 "Lic incomp" /// 
	6 "Lic comp y posgrado" 9 "Otro", modify
label values educ_gr3  educ_gr3

save "$datos\2018\vars_educ.dta", replace
 
use "$datos\2018\CS_RESIDENTES.dta", clear

collapse (sum) p3_26_2, by(upm_dis viv_sel hogar)

/*
3.27 Aproximadamente, ¿cuánto dinero ganan
regularmente todos los miembros del hogar al mes?
LEE Y ANOTA UN CÓDIGO
1 – 5,999 pesos………………………………... 1
6,000 – 9,999 pesos…………………………... 2
10,000 – 13,999 pesos………………………... 3
14,000 – 21,999 pesos………………………... 4
22,000 – o más pesos………………………… 5
No perciben ingresos………………………….. 6
No quiso responder……………………………. 8
No sabe…………………………………………. 9
*/
gen gr_ingr = 1 if (p3_26_2 < 6000)
replace gr_ingr = 2 if (p3_26_2 >= 6000 & p3_26_2 < 10000)
replace gr_ingr = 3 if (p3_26_2 >= 10000 & p3_26_2 <14000)
replace gr_ingr = 4 if (p3_26_2 >= 14000 & p3_26_2 <22000)
replace gr_ingr = 5 if (p3_26_2 >= 22000 & p3_26_2 < 999999 & !missing(p3_26_2))
replace gr_ingr = 99 if (p3_26_2 ==  999999)
replace gr_ingr = . if missing(p3_26_2) 

label variable gr_ingr "grupos de ingreso (pesos)"
label define gr_ingr 1 "<6 mil pesos" 2 "6,000 a 9,999" 3 "10,000 a 13,999" ///
	4 "14,000 a 21,999" 5 "22,000 o más" 99 "No sé", modify
label values gr_ingr gr_ingr

rename gr_ingr ingr_gr 

/* Ingresos por trabajo p3_26_2 : residentes 
// grupos de ingreso
gen gr_ingr = 1 if (p3_26_2 <= 3000)
replace gr_ingr = 2 if (p3_26_2 > 3000 & p3_26_2 <=5000)
replace gr_ingr = 3 if (p3_26_2 > 5000 & p3_26_2 <=8000)
replace gr_ingr = 4 if (p3_26_2 > 8000 & p3_26_2 <=10000)
replace gr_ingr = 5 if (p3_26_2 > 10000 & p3_26_2 <=15000)
replace gr_ingr = 6 if (p3_26_2 > 15000 & p3_26_2 <=20000)
replace gr_ingr = 7 if (p3_26_2 > 20000 & p3_26_2 <=50000)
replace gr_ingr = 8 if (p3_26_2 > 50000 & p3_26_2 < 999999 & !missing(p3_26_2))
replace gr_ingr = 99 if (p3_26_2 ==  999999)
*replace gr_ingr = . if missing(p3_26_2)

label variable gr_ingr "grupos de ingreso (pesos)"
label define gr_ingr 1 "<=3 mil pesos" 2 "3,001 a 5 mil" 3 "5,001 a 8 mil" ///
	4 "8,001 a 10 mil" 5 "10,001 a 15 mil" 6 "15,001 a 20 mil" /// 
	7 "20,001 a 49,999" 8 "50 mil+" 99 "No sé", modify
label values gr_ingr gr_ingr

gen ingr_gr = gr_ingr
recode ingr_gr (1 = 3) (2 = 3) (4 = 5) (8 = 7)
label define ingr_gr 3 "< 8 mil" ///
	5 "8,001 a 15 mil" 6 "15,001 a 20 mil" /// 
	7 "20 mil+" 99 "No sé", modify
label values ingr_gr ingr_gr*/

*drop p3_26_2

*Guardado de la base de datos
save "$datos\2018\vars_ingr_gr.dta", replace

log close
