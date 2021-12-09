/* cómo se distribuye la información respecto a la población nacional
*
'ultimo wave 

ubicacion geografica en la encuesta, caracteristicas de los
- nse alto
- educacion
- marcas
. cu'al es el tipo de fumadores?
- poblacion joven. edad?
- digitalizada
. hip. consume algunas marcas en particular
. hip. sesgado a comprar algo de mayor valor
. estratos que hacen que cambie en terminos de las marcas y los precios
. eg. hombres y mujeres
tabulados respecto a:
. consumo de marcas por edad, por lugar de origen
*/ 

capture log close
log using resultados/encuesta/descriptivos_recod.log, replace

use "$datos/otras_etiquetas.dta", clear

// sexo
recode sexo (1 = 0) (2=1)
label define sexo 1 "Femenino" 0 "Masculino", modify

// cantidades
su consumo_semanal

// precios 
//su precioCigarroCajetilla
//hist precioCigarroCajetilla


// family_income family_income_2 
ta ingreso_hogar 

ta no_pagar_cuentas 
ta estados_vive_act

// último levantamiento
keep if wave == 8
*use "$datos/otras_etiquetas.dta" if wave == 8, clear

/**************************************************************************
// Analizar primero la variable de Precio Cigarro que corresponde al 
*/
// cajetilla
gen precioCigarro8 = q029/q029a if wave == 8 & q028 == 1
// sueltos
gen precioCigarroSuelto = q030  if q028 == 2
egen ppCig = rowtotal(precioCigarro8  precioCigarroSuelto)

// inicial
hist ppCig 

// marcas
ta marca, su(ppCig)

graph box ppCig, over(marca, sort(marca))

// edad
ta edad
ta edad, su(ppCig)
ta edad marca, su(ppCig)

// sexo
ta sexo
ta sexo, su(ppCig)
ta marca sexo, su(ppCig)

// educacion
ta educ_3catr
ta educ_3catr, su(ppCig)
ta marca educ_3catr, su(ppCig)

// ingreso
ta ingreso_hogar , su(ppCig)
ta marca ingreso_hogar , su(ppCig)

/****************************************/
// CONSUMO
su consumo_semanal ppCig
corr consumo_semanal ppCig

// inicial
hist consumo_semanal

// marcas
ta marca, su(consumo_semanal)
graph box consumo_semanal, over(marca, sort(marca))

// edad
ta edad
ta edad, su(consumo_semanal)
ta edad marca, su(consumo_semanal)
ta marca edad, su(consumo_semanal) mean

graph bar (mean) consumo_semanal, over(edad)
graph save Graph "graficos\encuesta\w8_consumo_edad.gph"
graph bar (mean) consumo_semanal, over(edad) over(q028)
graph save Graph "graficos\encuesta\w8_consumo_edad_suelto.gph"

graph bar (mean) consumo_semanal, over(marca)
graph save Graph "graficos\encuesta\w8_consumo_marca.gph", replace

graph bar (mean) consumo_semanal, over(marca) over(q028)
graph save Graph "graficos\encuesta\w8_consumo_marca_suelto.gph"

// sexo
ta sexo
ta sexo, su(consumo_semanal)
graph box consumo_semanal, over(sexo)

ta marca sexo, su(consumo_semanal)
graph bar (mean) consumo_semanal, over(marca) over(sexo)
graph save Graph "graficos\encuesta\w8_consumo_marca_sexo.gph", replace

graph bar (mean) consumo_semanal, over(edad) over(sexo)
graph save Graph "graficos\encuesta\w8_consumo_edad_sexo.gph", replace
graph box consumo_semanal, over(edad) over(sexo)
graph save Graph "graficos\encuesta\w8_box_consumo_edad_sexo.gph", replace

// educacion
ta educ_3catr
ta educ_3catr, su(consumo_semanal)
ta marca educ_3catr, su(consumo_semanal)

// ingreso
ta ingreso_hogar , su(consumo_semanal)
ta marca ingreso_hogar , su(consumo_semanal)

/****************************************/




log close


