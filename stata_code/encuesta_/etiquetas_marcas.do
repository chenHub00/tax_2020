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
replace marca = 3 if q019 == 7
// completar..

#delimit ;
label define marca 1 "Benson y Hedges" 
				2 "Camel"
				3 "Chesterfield"
				4 "Lucky Strike"
				// completar
		;
#delimit cr


// tipo_marca
gen tipo = 1 if marca == 1 | marca == 2 | marca == 5
replace tipo = 2 if marca == 4 | marca == 7
replace tipo = 3 if marca == 3 | marca == 6

label define tipo 1 "premium" 2 "medio" 3 "bajo"
label values tipo tipo

/*
[IF 018=1] ¿Qué marca es?
[IF 018=2] ¿Qué marca estás fumando actualmente o fumaste más recientemente?
1.	Alas[023]
2.	Benson y Hedges o B&H
3.	Broadway[023]
4.	Camel
5.	Chesterfield
6.	Cohiba[021]
7.	Delicados
8.	Dunhill
9.	Faros
10.	Fiesta[021]
11.	Fortuna
12.	Garañon[021]
13.	Joe’s
14.	Kent
15.	Lucky Strike
16.	Marlboro
17.	Montana
18.	Murattimar
19.	Pall Mall
20.	Popular 
21.	RGD
22.	Raleigh[021]
23.	Salem[021]
24.	Seneca
25.	Viceroy[021]
26.	West[021]
27.	Winston
28.	L & M Baronet 
29.	Link Ice Fusion 
30.	Otro [Especificar] ___________ [021]
99	No sé[021]
*/
