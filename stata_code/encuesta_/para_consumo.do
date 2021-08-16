
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "$resultados/para_consumo.log", replace

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

// solo los periodos más cercanos al cambio de impuestos
keep if wave == 4 | wave == 5

// personas que no han fumado en el último mes
// salen de la muestra
ta has_fumado_1mes wave

// impuesto2020
gen tax2020 = wave == 5

// para generar variables de 
// grupos de edad y educación
// recodificar 
do $codigo/recodificar_.do
do $codigo/gen_vars.do

// muestra:
ta has_fumado_1mes wave, m
ta has_fumado_1mes wave, sum(consumo_semanal)

duplicates report id wave

destring id, gen(id_num)
xtset id_num wave

keep if has_fumado_1mes == 1

// patrones
xtdescribe 

//
egen sum_nId = total(1), by(id)
label variable sum_nId "mismo id en la tabla"
ta sum_nId

/***************************************************************************/
// DESCRIPTIVOS
// frecuencia de consumo: diario, ocasional, dejó de fumar, nunca ha fumado cigarros
ta q009 

//  ¿Cuántos cigarros fumas al día?
su q010
hist q010

// ¿cuántos cigarros fumas cada semana?
su q012
hist q012

// dos definiciones de consumo semanal
ta q009, su(consumo_semanal)
ta q009, su(cons_1)
// cada cuándo compra?
ta patron if has_fumado_1mes, sum(consumo_semanal )

hist consumo_semanal

ta q009 sum_nId
gen s2_idN_q3_009 = q009 == 3 & sum_nId == 2

/***************************************************************************/
// busqueda de algún patrón entre los que dejaron de fumar
preserve 

keep id s2_idN_q3_009  
keep if s2_idN_q3_009  == 1

duplicates report id
duplicates tag id, generate(dup_id)
keep if dup_id == 0

save "$datos/s2_idN_q3_009.dta", replace

restore 

merge n:1 id using "$datos/s2_idN_q3_009.dta"
 
rename _merge cambios_q009_3 
label variable cambios_q009_3 "dejaron de fumar o volvieron a fumar"

// panel No balanceado
preserve 
keep if q009 <= 2
save "$datos/wave4_5unbalanced.dta", replace
restore

// panel balanceado
// id en ambas encuestas
keep if sum_nId == 2
// no dejo de fumar en una ocasion
keep if cambios_q009_3 != 3
// reportó consumo
keep if q009 <= 2
save "$datos/wave4_5balanc.dta", replace

 /***************************************************************************/
 // UNBALANCED
use "$datos/wave4_5unbalanced.dta", clear
// sexo
ta sexo if has_fumado_1mes, sum(consumo_semanal ) 
// genero
//ta identidad_genero if has_fumado_1mes, sum(consumo_semanal ) 

// edad 
// ta q001 if has_fumado_1mes, sum(consumo_semanal ) 
// definir grupos de edad, 
// acorde a la encuesta nacional
// tab1 edad* if has_fumado_1mes, sum(q012) 
tab1 gr_edad if has_fumado_1mes, sum(consumo_semanal ) 

// escolaridad
//tab1 escolaridad educ_3catr educ_9cat if has_fumado_1mes, sum(consumo_semanal ) 
tab1 gr_edad if has_fumado_1mes, sum(consumo_semanal ) 

// ingresos
ta ingreso_hogar if has_fumado_1mes, sum(consumo_semanal ) 


/***************************************************************************/
// MODELOS
global vars_reg "sexo i.gr_edad i.gr_educ i.ingreso_hogar patron singles"

// modelo
regress consumo_semanal tax2020 $vars_reg if has_fumado_1mes
regress consumo_semanal $vars_reg if has_fumado_1mes

// estimación panel
xtreg consumo_semanal tax2020 $vars_reg if has_fumado_1mes, fe
xtreg consumo_semanal $vars_reg if has_fumado_1mes, fe

xtreg consumo_semanal tax2020 $vars_reg if has_fumado_1mes, re

log close



