/*
etiquetas_marcas.do
usado: recodificar.do
Etiquetar e identificar las marcas más relevantes para el análisis
2.	Benson y Hedges o B&H
4.	Camel
5.	Chesterfield
7.	Delicados > 5
15.	Lucky Strike
16.	Marlboro
17.	Montana
19.	Pall Mall
22.	Raleigh[021] > 15 
* también está la marca q026, último consumo, pero se reporta menos
*/

gen marca = .
replace marca = 1 if q019 == 2
replace marca = 2 if q019 == 4
replace marca = 3 if q019 == 5
replace marca = 3 if q019 == 7 // Delicados por Chesterfield
replace marca = 4 if q019 == 15
replace marca = 4 if q019 == 22 // Raleigh a Lucky
replace marca = 5 if q019 == 16
replace marca = 6 if q019 == 17
replace marca = 7 if q019 == 19
recode marca . = 99

do $codigo/2_d_2_marcas_w8_q019r30oe.do

#delimit ;
label define marca 1 "Benson y Hedges" 
				2 "Camel"
				3 "Chesterfield"
				4 "Lucky Strike"
				5 "Marlboro"
				6 "Montana"
				7 "Pall Mall"
				99 "Otras"
		;
#delimit cr

label values marca marca

// tipo_marca
gen tipo = 1 if marca == 1 | marca == 2 | marca == 5
replace tipo = 2 if marca == 4 | marca == 7
replace tipo = 3 if marca == 3 | marca == 6

label define tipo 1 "premium" 2 "medio" 3 "bajo"
label values tipo tipo

