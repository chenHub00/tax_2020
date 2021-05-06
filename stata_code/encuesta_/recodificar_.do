
recode sexo (2 = 0)
label define sexo 0 "Femenino", modify

* Se obliga sean excluyentes
gen cons_dia7 = q010*7 if q009 == 1
gen cons_sem = q012 if q009 == 2
egen consumo_semanal = rowtotal(cons_dia7 cons_sem), missing

do "$codigo\etiquetas_marcas.do"
