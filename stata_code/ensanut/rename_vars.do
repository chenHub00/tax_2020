
/* rename code */
rename H0303 edad
rename ENTIDAD entidad
destring entidad, replace
gen dominio = estrato == 2 |  estrato == 3 
replace dominio = 2 if estrato == 1