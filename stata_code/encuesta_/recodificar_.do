
// largo de nombre en variables
// orden de las etiquetas
// 

recode sexo (2 = 0)
label define sexo 0 "Femenino", modify

// consumo
* Se colecta para que sean excluyentes
gen cons_dia7 = q010*7 if q009 == 1
gen cons_sem = q012 if q009 == 2
egen consumo_semanal = rowtotal(cons_dia7 cons_sem), missing

label variable cons_dia7 "consumo semanal, 7x, con reporte diario"
label variable cons_sem "consumo semanal, con reporte semanal"
label variable consumo_semanal "consumo semanal, suma 2 tipos de reportes"


// precio
label define singles 1 "sueltos " 0 "cajetilla"
gen singles_cajetilla = q028 == 2
//label values singles singles_cajetilla 
gen precioSingles = q030 
recode precioSingles . = 0 if singles == 1

// 
// max_20 : corte de 20 piezas por cajetilla
scalar max_20 = 100
gen precioCigarroCajetilla = q029/20 if q029 < max_20
label variable precioCigarroCajetilla "precio por cigarro"

//gen precioCigarro


// grupo de marcas principales

