//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/desc_wave8.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

save "$datos/w08_resultados.dta", replace
export excel using "$datos/wave8.xlsx", replace

// etiquetas 
label define numcaj 1 "14 cigarros" 2 "20 cigarros" 3 "25 cigarros" ///
	4 "Otro" 5 "No sé"
label values q029a numcaj 

// consumo en el 'ultimo mes
ta has_fumado_1mes
ta has_fumado_1mes, nol

// 30-junio: se decidio omitir a los individuos que consumieron en 
// los levantamientos anteriores
// consumo: selección para el análisis
// ta has_fumado_1mes 
// ta has_fumado_1mes patron, m
keep if has_fumado_1mes 

// sexo
ta sexo if has_fumado_1mes
ta identidad_genero if has_fumado_1mes

// edad 
ta q001 if has_fumado_1mes
tab1 edad* if has_fumado_1mes

// escolaridad
tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes

// ingresos
ta ingreso_hogar if has_fumado_1mes

// lugar
ta estados if has_fumado_1mes

// cada cuándo compra?
ta patron if has_fumado_1mes, m
ta patron if has_fumado_1mes, m nol

// consumo
ta patron if has_fumado_1mes, su(q012) 

// precio

/* ¿Cómo compra?
1- cajetilla
2- suelto
*/
// precio de cigarros sueltos
su q030 if has_fumado_1mes
// patron
ta q028 patron if has_fumado_1mes, su(q030)

// pagado por cajetillas
ta q028 if has_fumado_1mes , m
ta q028 patron if has_fumado_1mes , m
ta q028 if has_fumado_1mes & patron , m

// para los comprados en cajetilla
ta q029a if has_fumado_1mes, m
ta q029a if has_fumado_1mes, su(q029)

// definici'on de precio por cigarro para compra por cajetilla
// 
gen n_cig_caj = .
replace n_cig_caj  = 14 if q029a == 1 & q028 == 1
replace n_cig_caj  = 20 if q029a == 2 & q028 == 1
replace n_cig_caj  = 25 if q029a == 3 & q028 == 1

// precio por cigarro
gen ppc_caj = q029/n_cig_caj

// 
su q030 ppc

// 
hist q030 
hist ppc

// Cross-tabs> consumo
// sexo
ta sexo, sum(q012) 

// edad 
ta q001, sum(q012) 
// definir grupos de edad, 
// acorde a la encuesta nacional
tab1 edad*, sum(q012) 

// escolaridad
tab1 escolaridad educ_3catr educ_9cat, sum(q012) 

// ingresos
ta ingreso_hogar, sum(q012) 

// lugar
ta estados, sum(q012) 
// definir grupos de entidades 
// comparable a ? encuesta nacional?

// cada cuándo compra?
ta patron, sum(q012)

////////////////////////////////////
// Cross-tabs> precio por cigarro
// sexo
ta sexo, sum(q030) 
ta sexo, sum(ppc) 

// edad 
ta q001, sum(q030) 
ta q001, sum(ppc) 
// definir grupos de edad, 
// acorde a la encuesta nacional
tab1 edad*, sum(q030) 
tab1 edad*, sum(ppc) 

// escolaridad
tab1 escolaridad educ_3catr educ_9cat, sum(q030) 
tab1 escolaridad educ_3catr educ_9cat, sum(ppc) 

// ingresos
ta ingreso_hogar, sum(q030) 
ta ingreso_hogar, sum(ppc) 

// lugar
ta estados, sum(q030) 
ta estados, sum(ppc) 

// cada cuándo compra?
ta patron, sum(q030)
ta patron, sum(ppc)


log close



