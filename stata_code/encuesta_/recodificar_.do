
// largo de nombre en variables
// orden de las etiquetas
// vars:
// sexo tipo_fumador_diario/ocasional/dejo/nunca_cigarro cigarros_diarios cigarros_semanales
// compra_sueltos precio_sueltos numero_cigarros_cajetilla (num_caj)
// sexo q009 q010 q012 q028 q030 q029a 

recode sexo (2 = 1) (1 = 0)
label define sexo 1 "Femenino" 0 "Masculino", modify

// consumo
* Se colecta para que sean excluyentes
gen cons_dia7 = q010*7 if q009 == 1
gen cons_sem = q012 if q009 == 2
egen consumo_semanal = rowtotal(cons_dia7 cons_sem), missing
egen cons_1 = rowtotal(q010 cons_sem), missing
gen cons_por_dia = consumo_semanal/7

label variable cons_dia7 "consumo semanal, 7x, con reporte diario (solo reporte diario)"
label variable cons_sem "consumo semanal, con reporte semanal (solo reporte semanal/ocasional)"
label variable consumo_semanal "consumo semanal, suma 2 tipos de reportes (diario y ocasional)"
label variable cons_por_dia "consumo semanal / 7, suma 2 tipos de reportes (diario y ocasional)"


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

