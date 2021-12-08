
// grupo de edad como en GATS 2015
gen gr_edad = 1 if (edad >= 18 & edad <= 24)
replace gr_edad = 2 if (edad >= 25 & edad <= 44)
replace gr_edad = 3 if (edad >= 45 & edad <= 64)
replace gr_edad = 4 if (edad >= 65 & !missing(edad))
label variable gr_edad "grupos de edad"
label define gr_edad 1 "18-24" 2 "25-44" 3 "45-64" 4 "65+"
label values gr_edad gr_edad 

gen edad_gr2 = 1 if (edad >= 18 & edad <= 25)
replace edad_gr2 = 2 if (edad >= 25 & edad <= 29)
replace edad_gr2 = 3 if (edad >= 30 & edad <= 34)
replace edad_gr2 = 4 if (edad >= 35 & edad <= 39)
replace edad_gr2 = 5 if (edad >= 40 & edad <= 44)
replace edad_gr2 = 6 if (edad >= 45 & edad <= 54)
replace edad_gr2 = 7 if (edad >= 55 & edad <= 64)
replace edad_gr2 = 8 if (edad >= 65  & !missing(edad))
label variable edad_gr2 "grupos de edad"
label define edad_gr2 1 "18-24" 2 "25-29" 3 "30-34" 4 "35-39" /// 
	5 "40-44" 6 "45-54" 7 "55-64" 8 "65+", modify
label values edad_gr2 edad_gr2 

gen edad_gr3 = edad_gr2
recode edad_gr3 (8 = 7)

label define edad_gr3 1 "18-24" 2 "25-29" 3 "30-34" 4 "35-39" /// 
	5 "40-44" 6 "45-54" 7 "55+", modify
label values edad_gr3 edad_gr3

ta edad edad_gr3 if edad < 20, m