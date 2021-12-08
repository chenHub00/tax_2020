// interacciones-impuesto
gen tax2020_sexo = tax2020*sexo
gen tax2020_edad_gr3 = tax2020*edad_gr2
gen tax2020_educ_gr3 = tax2020*educ_gr3
gen tax2020_ingr_gr = tax2020*ingr_gr

/* interacciones-pandemia: covid19
gen covid19_sexo = covid19*sexo
gen covid19_edad_gr3 = covid19*edad_gr2
gen covid19_educ_gr3 = covid19*educ_gr3
gen covid19_ingr_gr = covid19*ingr_gr
