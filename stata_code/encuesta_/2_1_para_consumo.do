
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

*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/Base_original_w1_w8_conweights.dta", clear

keep id wave has_fumado_1mes /// 
	q001 escolaridad ingreso patron q028 q019 q019r30oe /// 
		sexo q009 q010 q012 q028 q030 q029a dual_use100cig dual_use
// para generar variables de 
// grupos de edad y educación
// recodificar 

// impuesto2020
gen tax2020 = wave == 5
// impuesto2020
gen tax2021 = wave == 8
// pandemia
gen covid19 = wave >= 6

do $codigo/2_a_recodificar_.do
do $codigo/2_b_gen_vars.do
do $codigo/2_c_gen_interacciones.do
do $codigo/2_d_etiquetas_marcas.do


// septiembre: Todos los periodos
// agosto: solo los periodos más cercanos al cambio de impuestos
// keep if wave == 4 | wave == 5

// personas que no han fumado en el último mes
// salen de la muestra
ta wave has_fumado_1mes 

// para generar variables de 
// grupos de edad y educación
// recodificar 
//do $codigo/recodificar_.do
//do $codigo/gen_vars.do

// muestra:
ta wave has_fumado_1mes , m
ta wave has_fumado_1mes , sum(consumo_semanal)

duplicates report id wave

destring id, gen(id_num)
xtset id_num wave

keep if has_fumado_1mes == 1

// patrones
xtdescribe 

// la suma de id en total, 
egen sum_nId = total(1), by(id)
label variable sum_nId "mismo id en la tabla"
ta sum_nId

/*. ta sum_nId

    sum_nId |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      4,430       38.90       38.90
          2 |      2,138       18.77       57.67
          3 |      1,656       14.54       72.22
          4 |      1,056        9.27       81.49
          5 |        760        6.67       88.16
          6 |        648        5.69       93.85
          7 |        420        3.69       97.54
          8 |        280        2.46      100.00
------------+-----------------------------------
      Total |     11,388      100.00
280/6 = 35, son 35 id en las 8 ocasiones
2,138/2 = 1069 dos veces

*/

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
ta sum_nId q009 
//gen s2_idN_q3_009 = q009 == 3 & sum_nId == 2
// frecuencia de consumo, q009 = 3: dejo de fumar

// tener solo los que están fumando, en el último mes
// si en algún periodo reportan que no fuman se elimina
// para 2 waves:
// gen s2_idN_q3_009 = q009 == 3 & sum_nId == 2
// para 3 waves:
// gen s3_idN_q3_009 = q009 == 3 & sum_nId == 3
// 21 observaciones sin fumar en los 3 levantamientos
// para 4 waves:
// gen s4_idN_q3_009 = q009 == 3 & sum_nId == 4
// para 8 waves:
gen s8_idN_q3_009 = q009 == 3 & sum_nId == 8

/***************************************************************************/
// busqueda de algún patrón entre los que dejaron de fumar
preserve 
//
keep id s8_idN_q3_009  
keep if s8_idN_q3_009  == 1
//
duplicates report id
duplicates tag id, generate(dup_id)
keep if dup_id == 0
//
save "$datos/s8_idN_q3_009.dta", replace
//
restore 
// // Fin busqueda de algún patrón entre los que dejaron de fumar
//
merge n:1 id using "$datos/s8_idN_q3_009.dta"
// 
rename _merge cambios_q009_3 
label variable cambios_q009_3 "dejaron de fumar o volvieron a fumar"
//
// // panel No balanceado, no se considera el balanceado
preserve 

/***************************************************************************/
// s'olo con consumo, se eliminan los que dejaron de fumar (3) o nunca han fumado cigarros (4)
keep if q009 <= 2
//   227 con q009 == 3
// 10 con q009 == 4
save "$datos/cons_w_1to8.dta", replace

log close

