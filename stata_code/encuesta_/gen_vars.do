// agrupar categorias
// interacciones con impuestos

// grupo de edad como en GATS 2015
gen gr_edad = 1 if (q001 >= 18 & q001 <= 24)
replace gr_edad = 2 if (q001 >= 25 & q001 <= 44)
replace gr_edad = 3 if (q001 >= 45 & q001 <= 64)
replace gr_edad = 4 if (q001 >= 65)
label variable gr_edad "grupos de edad"
label define gr_edad 1 "18-24" 2 "25-44" 3 "45-64" 4 "65+"
label values gr_edad gr_edad 

gen edad_gr2 = 1 if (q001 >= 18 & q001 <= 25)
replace edad_gr2 = 2 if (q001 >= 25 & q001 <= 29)
replace edad_gr2 = 3 if (q001 >= 30 & q001 <= 34)
replace edad_gr2 = 4 if (q001 >= 35 & q001 <= 39)
replace edad_gr2 = 5 if (q001 >= 40 & q001 <= 44)
replace edad_gr2 = 6 if (q001 >= 45 & q001 <= 54)
replace edad_gr2 = 7 if (q001 >= 55 & q001 <= 64)
replace edad_gr2 = 8 if (q001 >= 65)
label variable edad_gr2 "grupos de edad"
label define edad_gr2 1 "18-24" 2 "25-29" 3 "30-34" 4 "35-39" /// 
	5 "40-44" 6 "45-54" 7 "55-64" 8 "65+", modify
label values edad_gr2 edad_gr2 

// grupos de escolaridades
gen gr_educ = 1 if (escolaridad >= 1 & escolaridad <= 2)
replace gr_educ = 2 if (escolaridad == 3)
replace gr_educ = 3 if (escolaridad >= 4 & escolaridad <= 5)
replace gr_educ = 4 if (escolaridad >= 6 & escolaridad <= 8)
replace gr_educ = 5 if (escolaridad == 9)
label variable gr_educ "grupos de escolaridad"
label define gr_educ 1 "Hasta Primaria completa" 2 "Secundaria completa" ///
	3 "Técnica o Preparatoria" 4 "Universidad o posterior" 5 "Otro"
label values gr_educ gr_educ

gen educ_gr2 = 1 if (escolaridad >= 1 & escolaridad <= 2)
replace educ_gr2 = 2 if (escolaridad == 3)
replace educ_gr2 = 3 if (escolaridad == 4) 
replace educ_gr2 = 4 if (escolaridad == 5) 
replace educ_gr2 = 5 if (escolaridad == 6) 
replace educ_gr2 = 6 if (escolaridad == 7) 
replace educ_gr2 = 7 if (escolaridad == 8)
replace educ_gr2 = 9 if (escolaridad == 9)
label variable educ_gr2 "grupos de escolaridad"
label define educ_gr2  1 "Hasta primaria completa" 2 "Secundaria completa" ///
	3 "Técnica" 4 "Preparatoria" 5 "Licenciatura incompleta" /// 
	6 "Licenciatura completa" 7 "Posgrado" 9 "Otro", modify
label values educ_gr2  educ_gr2 

// grupos de ingreso
gen gr_ingreso = 1 if (ingreso >= 1 & ingreso <= 2)
replace gr_ingreso = 2 if (ingreso == 3)
replace gr_ingreso = 3 if (ingreso == 4)
replace gr_ingreso = 4 if (ingreso == 5)
replace gr_ingreso = 5 if (ingreso == 6)
replace gr_ingreso = 6 if (ingreso == 7)
replace gr_ingreso = 7 if (ingreso == 8)
replace gr_ingreso = 8 if (ingreso == 9)
replace gr_ingreso = 99 if (ingreso == 99)

label variable gr_ingreso "grupos de ingreso (pesos)"
label define gr_ingreso 1 "<3 mil pesos" 2 "3,001 a 5 mil" 3 "5,001 a 8 mil" ///
	4 "8,001 a 10 mil" 5 "10,001 a 15 mil" 6 "15,001 a 20 mil" /// 
	7 "20,001 a 49,999" 8 "50 mil+" 99 "No sé", modify
label values gr_ingreso gr_ingreso

// tipo de consumidor
// diario-esporádico (patron, 1 =: daily) y cajetilla/suelto (q028, 1 =: cajetilla)
gen tipo_cons = 1 if patron == 1 & q028 == 1
replace tipo_cons = 2 if patron == 1 & q028 == 2
replace tipo_cons = 3 if patron == 0 & q028 == 1
replace tipo_cons = 4 if patron == 0 & q028 == 2
label variable tipo_cons "tipo de consumo"
label define tipo_cons 1 "diario-cajetilla" 2 "diario-suelto" ///
	3 "esporádico-cajetilla" 4 "esporádico-suelto"
label values tipo_cons tipo_cons

// interacciones-impuesto
gen tax2020_sexo = tax2020*sexo

gen tax2020_edad_gr2 = tax2020*edad_gr2

gen tax2020_gr_educ = tax2020*gr_educ
