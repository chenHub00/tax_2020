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
replace marca = 4 if q019 == 15
replace marca = 4 if q019 == 22
replace marca = 5 if q019 == 16
replace marca = 6 if q019 == 17
replace marca = 7 if q019 == 19
recode marca . = 99

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

// Juntar Chesterfield y Delicados
// Raleigh : Lucky
// ajustar manual q019r30oe.xls
// 
replace marca = 5 if q019r30oe =="Malboro rubi"
replace marca = 5 if q019r30oe =="marlboro ice"
replace marca = 5 if q019r30oe =="Marlboro Sandía"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 1 if q019r30oe =="Benson & Hedges Violeta"
replace marca = 1 if q019r30oe =="Benson violeta"
replace marca = 1 if q019r30oe =="Benson cristal"
replace marca = 1 if q019r30oe =="Benson cristal"
replace marca = 5 if q019r30oe =="ICE EXPRESS DE MARLBORO"
replace marca = 7 if q019r30oe =="Pallmall"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 4 if q019r30oe =="lucky strike"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 7 if q019r30oe =="PALL MALL"
replace marca = 3 if q019r30oe =="chesterfield"
replace marca = 7 if q019r30oe =="Pollmol"
replace marca = 7 if q019r30oe =="pallmall"
replace marca = 6 if q019r30oe =="Shots"
replace marca = 3 if q019r30oe =="Chesterfield"
replace marca = 7 if q019r30oe =="Pall Mall"
replace marca = 7 if q019r30oe =="pall mol"
replace marca = 7 if q019r30oe =="PALL MAL"
replace marca = 3 if q019r30oe =="delicados sin filtro"
replace marca = 7 if q019r30oe =="pall mall"
replace marca = 5 if q019r30oe =="malvoro"
replace marca = 7 if q019r30oe =="Palo Mall"
replace marca = 4 if q019r30oe =="raleigt"
replace marca = 1 if q019r30oe =="BENSON DORADOS LIGHT"
replace marca = 4 if q019r30oe =="Lucky strike"
replace marca = 7 if q019r30oe =="PALL MALL"
replace marca = 1 if q019r30oe =="Benson mentolado"
replace marca = 7 if q019r30oe =="pall mall"
replace marca = 7 if q019r30oe =="Palmall"
replace marca = 7 if q019r30oe =="Palmall doble clik"
replace marca = 7 if q019r30oe =="paull mool"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 1 if q019r30oe =="Marlboro rubi"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 7 if q019r30oe =="Pollman"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 2 if q019r30oe =="Camel mentolados"
replace marca = 7 if q019r30oe =="Pallmall"
replace marca = 7 if q019r30oe =="Palo mall"
replace marca = 5 if q019r30oe =="marlboro"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 4 if q019r30oe =="Lucy strigth"
replace marca = 3 if q019r30oe =="Chesterfield"
replace marca = 7 if q019r30oe =="Pall mart"
replace marca = 6 if q019r30oe =="Montana"
replace marca = 7 if q019r30oe =="Pallman"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 6 if q019r30oe =="Shot"
replace marca = 5 if q019r30oe =="marlboro"
replace marca = 7 if q019r30oe =="Poll moll"


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

