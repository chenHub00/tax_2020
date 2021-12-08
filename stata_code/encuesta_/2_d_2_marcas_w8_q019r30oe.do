
// Juntar Chesterfield y Delicados
// Raleigh : Lucky
// ajustar manual q019r30oe.xls
// 
// wave 8 > 7
replace marca = 1 if q019r30oe =="Benson cristal"
replace marca = 7 if q019r30oe =="Pall mart"
replace marca = 7 if q019r30oe =="Pallman"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 6 if q019r30oe =="Shot"
replace marca = 5 if q019r30oe =="marlboro"
replace marca = 7 if q019r30oe =="Poll moll"

// wave 4 > 8
replace marca = 3 if q019r30oe =="chesterfield"
replace marca = 7 if q019r30oe =="Pall Mall"
replace marca = 7 if q019r30oe =="PALL MAL"
replace marca = 7 if q019r30oe =="Palo Mall"
replace marca = 7 if q019r30oe =="PALL MALL"
replace marca = 7 if q019r30oe =="pall mall"
replace marca = 7 if q019r30oe =="Palmall"
replace marca = 7 if q019r30oe =="Pall mall"

// wave 5 > 6
replace marca = 5 if q019r30oe =="Malboro rubi"
replace marca = 1 if q019r30oe =="Benson violeta"
replace marca = 7 if q019r30oe =="pallmall"
replace marca = 7 if q019r30oe =="Palmall doble clik"
replace marca = 7 if q019r30oe =="paull mool"
replace marca = 7 if q019r30oe =="Pall mall"

// wave 6 > 8
replace marca = 1 if q019r30oe =="Benson cristal"
replace marca = 4 if q019r30oe =="Lucky strike"
replace marca = 1 if q019r30oe =="Marlboro rubi"
replace marca = 7 if q019r30oe =="Pollman"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 2 if q019r30oe =="Camel mentolados"
replace marca = 7 if q019r30oe =="Pallmall"
replace marca = 7 if q019r30oe =="Palo mall"

// wave 7 > 6
replace marca = 7 if q019r30oe =="Pallmall"
replace marca = 5 if q019r30oe =="marlboro"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 4 if q019r30oe =="Lucy strigth"
replace marca = 3 if q019r30oe =="Chesterfield"
replace marca = 6 if q019r30oe =="Montana"

// wave 1 > 4
replace marca = 5 if q019r30oe =="Marlboro Sandía"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 7 if q019r30oe =="Pall mall"
replace marca = 7 if q019r30oe =="Pall mall"

// wave 2 > 12
replace marca = 5 if q019r30oe =="marlboro ice"
replace marca = 1 if q019r30oe =="Benson & Hedges Violeta"
replace marca = 5 if q019r30oe =="ICE EXPRESS DE MARLBORO"
replace marca = 4 if q019r30oe =="lucky strike"
replace marca = 5 if q019r30oe =="Marlboro"
replace marca = 7 if q019r30oe =="Pollmol"
replace marca = 7 if q019r30oe =="pall mol"
replace marca = 3 if q019r30oe =="delicados sin filtro"
replace marca = 7 if q019r30oe =="pall mall"
replace marca = 5 if q019r30oe =="malvoro"
replace marca = 4 if q019r30oe =="raleigt"
replace marca = 1 if q019r30oe =="BENSON DORADOS LIGHT"

// wave 3 > 4
replace marca = 7 if q019r30oe =="PALL MALL"
replace marca = 6 if q019r30oe =="Shots"
replace marca = 3 if q019r30oe =="Chesterfield"
replace marca = 1 if q019r30oe =="Benson mentolado"


/*
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
// 
replace marca = 7 if q019r30oe =="Poll moll"
*/

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

