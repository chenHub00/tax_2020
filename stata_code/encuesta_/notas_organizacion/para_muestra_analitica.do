
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/muestra_analitica.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 4 | wave == 5

// personas que no han fumado en el último mes
// salen de la muestra
ta has_fumado_1mes wave

// para generar variables de 
// grupos de edad y educación
do $codigo/gen_vars.do

// impuesto2020
gen tax2020 = wave == 5


// Variables descriptivos:
// 
tab1 sexo gr_edad gr_educ ingresos
su q030

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
ta gr_edad

// escolaridad
tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes
ta gr_educ

// ingresos
ta ingreso_hogar if has_fumado_1mes

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


// Cross-tabs> consumo
// sexo
ta sexo if has_fumado_1mes, sum(q012) 
// genero
ta identidad_genero if has_fumado_1mes, sum(q012) 

// edad 
ta q001 if has_fumado_1mes, sum(q012) 
// definir grupos de edad, 
// acorde a la encuesta nacional
tab1 edad* if has_fumado_1mes, sum(q012) 

// escolaridad
tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes, sum(q012) 

// ingresos
ta ingreso_hogar if has_fumado_1mes, sum(q012) 

// lugar
ta estados if has_fumado_1mes, sum(q012) 
// definir grupos de entidades 
// comparable a ? encuesta nacional?

// cada cuándo compra?
ta patron if has_fumado_1mes, sum(q012)

////////////////////////////////////
// Cross-tabs> precio por cigarro
// sexo
ta sexo if has_fumado_1mes, sum(q030) 

// edad 
ta q001 if has_fumado_1mes, sum(q030) 

// definir grupos de edad, 
// acorde a la encuesta nacional
tab1 gr_edad if has_fumado_1mes, sum(q030) 

// escolaridad
// tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes, sum(q030) 
tab1 ed_if has_fumado_1mes, sum(q030) 

// ingresos
ta ingreso_hogar if has_fumado_1mes, sum(q030) 

// cada cuándo compra?
ta patron if has_fumado_1mes, sum(q030)

