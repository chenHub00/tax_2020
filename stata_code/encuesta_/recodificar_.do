
// largo de nombre en variables
// orden de las etiquetas
// 

recode sexo (2 = 1) (1 = 0)
label define sexo 1 "Femenino" 0 "Masculino", modify

// consumo
* Se colecta para que sean excluyentes
gen cons_dia7 = q010*7 if q009 == 1
gen cons_sem = q012 if q009 == 2
egen consumo_semanal = rowtotal(cons_dia7 cons_sem), missing
egen cons_1 = rowtotal(q010 cons_sem), missing


label variable cons_dia7 "consumo semanal, 7x, con reporte diario"
label variable cons_sem "consumo semanal, con reporte semanal"
label variable consumo_semanal "consumo semanal, suma 2 tipos de reportes"


// precio
label define singles 1 "sueltos " 0 "cajetilla"
gen singles = q028 == 2
label variable singles "sueltos"
label values singles singles
//label values singles singles_cajetilla 
gen precioSingles = q030 
recode precioSingles . = 0 if singles == 1


label define numcaj 1 "14 cigarros" 2 "20 cigarros" 3 "25 cigarros" ///
	4 "Otro" 5 "No sé"
label variable q029a numcaj

/*
NUMCAJ	[IF 028=1]
¿Cuántos cigarros tenía la cajetilla?
1.	14 cigarros
2.	20 cigarros 
3.	25 cigarros 
4.	Otro [Especificar] ___________ 
5.	No sé 
*/

