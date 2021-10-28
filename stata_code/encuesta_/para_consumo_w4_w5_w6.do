
// Anteriormente sólo w4 y w5 en para_consumo.do
//
set more off

*cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"
//  
capture log close
log using "resultados/encuesta/para_consumo_w4_w5_w6.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

* variables
keep id wave has_fumado_1mes /// 
	q001 escolaridad ingreso patron q028 q019 q019r30oe /// 
		sexo q009 q010 q012 q028 q030 q029a 

// solo los periodos más cercanos al cambio de impuestos
keep if wave == 4 | wave == 5 | wave == 6

// para generar variables de 
// grupos de edad y educación
// recodificar 

// impuesto2020
gen tax2020 = wave == 5
// pandemia
*gen covid19 = wave >= 6

do $codigo/recodificar_.do
do $codigo/gen_vars.do
*do $codigo/gen_interacciones.do
do $codigo/etiquetas_marcas.do


/*. list id wave q009 if id == "40309"

      +---------------------+
      |    id   wave   q009 |
      |---------------------|
2314. | 40309      6      2 |
2315. | 40309      4      3 |
2316. | 40309      5      3 |
      +---------------------+
*/


// personas que no han fumado en el último mes
// salen de la muestra
ta has_fumado_1mes wave

// para generar variables de 
// grupos de edad y educación
// recodificar 
//do $codigo/recodificar_.do
//do $codigo/gen_vars.do

// muestra:
ta has_fumado_1mes wave, m
ta has_fumado_1mes wave, sum(consumo_semanal)

duplicates report id wave

// id como numero para establecer el panel
destring id, gen(id_num)
xtset id_num wave

keep if has_fumado_1mes == 1

// patrones
xtdescribe 

// 466 en los3 levantamientos
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
// hist q010

// ¿cuántos cigarros fumas cada semana?
su q012
// hist q012

// dos definiciones de consumo semanal
ta q009, su(consumo_semanal)
ta q009, su(cons_1)
// cada cuándo compra?
ta patron if has_fumado_1mes, sum(consumo_semanal )

// hist consumo_semanal
ta q009 sum_nId

// frecuencia de consumo, q009 = 3: dejo de fumar
// para 2 waves:
gen s2_idN_q3_009 = q009 == 3 & sum_nId == 2
// para 3 waves:
gen s3_idN_q3_009 = q009 == 3 & sum_nId == 3
// 21 observaciones sin fumar en los 3 levantamientos

/***************************************************************************/
// busqueda de algún patrón entre los que dejaron de fumar
preserve 

keep id s2_idN_q3_009 s3_idN_q3_009
// 2 waves
//keep if s2_idN_q3_009  == 1
// sin fumar en 2 o 3 waves:
//keep if s3_idN_q3_009  == 1 | s2_idN_q3_009  == 1
// sin fumar en 3 waves:
keep if s3_idN_q3_009  == 1

// identificar los 
// que reportan no fumar en algún periodo
duplicates report id
duplicates tag id, generate(dup_id)
keep if dup_id == 0
// solo aquellos que fumaron en los 3 periodos

save "$datos/s2_idN_q3_009_w6.dta", replace

restore 

merge n:1 id using "$datos/s2_idN_q3_009_w6.dta"
 
rename _merge cambios_q009_3 
label variable cambios_q009_3 "dejaron de fumar o volvieron a fumar"

// panel No balanceado
// solo los que fuman diario y ocasional
preserve 
keep if q009 <= 2
save "$datos/cons_w456_unbalanc.dta", replace

restore

// 
use "$datos/cons_w456_unbalanc.dta", clear

// panel balanceado
// id en ambas encuestas: w4 y w5
// keep if sum_nId == 2
// w4, w5, w6
keep if sum_nId == 3
// no dejo de fumar en una ocasion
keep if cambios_q009_3 != 3
// 13 reportaron dejar de fumar en algun periodo
// reportó consumo
keep if q009 <= 2

// hay una observación que cambio el q009
// de dejo de fumar a fumar ocasionalmente
// entre encuestas, 
duplicates report id
duplicates tag id, generate(dup_id2)
/*
. list id q009 if dup_id2 == 0

      +--------------+
      |    id   q009 |
      |--------------|
1183. | 40309      2 |

*/ 
drop if dup_id2 == 0

save "$datos/cons_w456_balanc.dta", replace

log close

