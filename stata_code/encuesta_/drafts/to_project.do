

capture log close
log using "$resultados/to_project.log", replace

use "$datos/w08_generadas.dta", clear

do gen_vars.do

///////// tabulados y cantidad
ta gr_edad
ta gr_edad, sum(q012) 

ta gr_educ
ta gr_educ, sum(q012) 

////// precio> suelto y por unidad (comprado por cajetilla)
ta gr_edad, sum(q030) 
ta gr_edad, sum(ppc) 

ta gr_educ, sum(q030)  
ta gr_educ, sum(ppc) 

log close
