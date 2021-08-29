// NO consideramos otras marcas
//
set more off  
capture log close
log using "para_precio4_5.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
*global resultados = "resultados\encuesta\"

*cd "C:\Users\danny\Desktop\Cohorte de fumadores\"
/* 	CON EL ANÁLISIS A PARTIR DE LOS DATOS DE INEGI SE PUEDE OMITIR EL ANALISIS DE LOS DATOS DEL 
LEVANTAMIENTO 8, EN PARTICULAR LA PROPORCIÓN DE MÁS DEL 50 % DEL CONSUMO DE MONTANA.
*use "91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

do "$codigo/etiquetas_marcas.do"

drop if q029a > 3

// Benson
ta q029a if marca == 1
proportion q029a if marca == 1
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
     q029a:  q029a:  q029a:
         1       2       3
y1  .11875   .8125  .06875

*/
matrix prop1 = e(b)

//Camel
ta q029a if marca == 2
proportion q029a if marca == 2
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
            1.         2.         3.
        q029a      q029a      q029a
y1  .11594203  .85507246  .02898551
*/
matrix prop2 = e(b)

//Chesterfield
ta q029a if marca == 3
proportion q029a if marca == 3
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
            1.         2.         3.
        q029a      q029a      q029a
y1  .22580645  .41935484  .35483871
*/
matrix prop3 = e(b)

//Lucky Strike
ta q029a if marca == 4
proportion q029a if marca == 4
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
            1.         2.         3.
        q029a      q029a      q029a
y1  .23529412  .67647059  .08823529
*/
matrix prop4 = e(b)

//Marlboro
ta q029a if marca == 5
proportion q029a if marca == 5
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .13453815  .80923695   .0562249
*/
matrix prop5 = e(b)

//Montana
ta q029a if marca == 6
proportion q029a if marca == 6
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .32758621  .17241379         .5

*/
matrix prop6 = e(b)
// proporción de montana es alto para 25 cigarros en la cajetilla.

//Pall Mall
ta q029a if marca == 7
proportion q029a if marca == 7
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .11111111  .83333333  .05555556

*/
matrix prop7 = e(b)
*/
//
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 5

do "$codigo/etiquetas_marcas.do"

keep id wave marca q019 q029

// Benson
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8
/*_pctile q029 if marca == 1, percentiles(12 93)
pctile pc_q029_1 = q029 if marca == 1, nq(100) genp(perc_q029_1)


tempname p1_1 p1_2
scalar `p1_1' = round(prop1[1,1]*100)
scalar `p1_2' = `p1_1' + round(prop1[1,2]*100)
scalar list
_pctile q029 if marca == 1, percentiles(`p1_1'  `p1_2')

return list
r(r1)*/
/*
scalars:

                 r(r1) =  50
                 r(r2) =  90
*/

gen cantidad_cigarros = .
/* AJUSTE CON BASE EN PORCENTAJES DE WAVE 8
 Benson no ten'ia presentaci'on de 25 en INEGI
replace cantidad_cigarros = 14 if marca == 1 & q029 <=pc_q029_1[12]
replace cantidad_cigarros = 20 if marca == 1 & q029 >pc_q029_1[12] & q029 <= pc_q029_1[93]
replace cantidad_cigarros = 25 if marca == 1 & q029 >pc_q029_1[12] & q029 <= pc_q029_1[93]
*/
* todos los de q019 igual a 1 con 20.
// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 1
// ESTOS Valores CORRESPONDE A Las fechas del WAVE 5 en la tabla de excel
// replace cantidad_cigarros = 14 if q019 == 2 & q029 <=56.7375471698113
// replace cantidad_cigarros = 20 if q019 == 2 & q029 >56.7375471698113
// CON EL CÓDIGO DEL EXCEL:
//replace cantidad_cigarros = 14 if q019 == 2 & q029 <=54.886
//replace cantidad_cigarros = 20 if q019 == 2 & q029 >54.886
// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
// replace cantidad_cigarros = 14 if marca == 1 & q029 <=54.886
// replace cantidad_cigarros = 20 if marca == 1 & q029 >54.886
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 14 if marca == 1 & q029 <=62.48
recode cantidad_cigarros . = 20 if marca == 1 & q029 >62.48


ta cantidad_
ta marca cantidad_, m

//Camel
*hist q029 if marca == 2
// los percentiles se toman del cálculo de la proporción en la w8
/*
_pctile q029 if marca == 2, percentiles(12 97)

return list

scalars:
                 r(r1) =  47
                 r(r2) =  85

*/
replace cantidad_cigarros = 20 if q019 == 3
// SI NO HAY VARIABLES QUE CAMBIEN LA MARCA NO SE REQUIERE AJUSTAR EL VALOR PARA LA MARCA
// replace cantidad_cigarros = 14 if q019 == 4 & q029 <=54.3625
// replace cantidad_cigarros = 20 if q019 == 4 & q029 >54.3625
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 14 if marca == 2 & q029 <=60.1
recode cantidad_cigarros . = 20 if marca == 2 & q029 >60.1

ta cantidad_
ta marca cantidad_, m

//Chesterfield
*hist q029 if marca == 3
// los percentiles se toman del cálculo de la proporción en la w8
/*
_pctile q029 if marca == 3, percentiles(23 64)

return list

scalars:
                 r(r1) =  45
                 r(r2) =  55

*/

/* EL AJUSTE ORIGINAL SOLO APLICARÍA A LA PARTE DE CHESTERFIELD, NO A DELICADOS
replace cantidad_cigarros = 15 if q019 == 5 & q029 <=48.3845
// ORIGINAL reescribe los de 14 a 18
// replace cantidad_cigarros = 18 if q019 == 5 & q029 <=48.3845
// SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// NO LO CAMBIA
recode cantidad_cigarros . = 18 if q019 == 5 & q029 <=48.3845
// ORIGINAL reescribe los menores a 20 a 20
//replace cantidad_cigarros = 20 if q019 == 5 & q029 <=48.3845
// SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// NO LO CAMBIA
recode cantidad_cigarros . = 20 if q019 == 5 & q029 <=48.3845
// ORIGINAL reescribe los menores a 24
// replace cantidad_cigarros = 24 if q019 == 5 & q029 <=48.3845
// SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// NO LO CAMBIA
recode cantidad_cigarros . = 24 if q019 == 5 & q029 <=48.3845
// ORIGINAL reescribe los de 14 y 20 a 24
// replace cantidad_cigarros = 25 if q019 == 5 & q029 >48.3845
// SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// NO LO CAMBIA
recode cantidad_cigarros . = 25 if q019 == 5 & q029 >48.3845

ta cantidad_
ta marca cantidad_, m
*/

// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
// replace cantidad_cigarros = 15 if marca == 3 & q029 <=48.3845
// recode cantidad_cigarros . = 18 if marca == 3 & q029 <=48.3845
// recode cantidad_cigarros . = 20 if marca == 3 & q029 <=48.3845
// recode cantidad_cigarros . = 24 if marca == 3 & q029 <=48.3845
// recode cantidad_cigarros . = 25 if marca == 3 & q029 >48.3845
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 15 if marca == 3 & q029 <=45.0975
recode cantidad_cigarros . = 18 if marca == 3 & q029 <=49.7225
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=49.8
recode cantidad_cigarros . = 24 if marca == 3 & q029 <=53.5714
recode cantidad_cigarros . = 25 if marca == 3 & q029 >53.5714


ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 6

replace cantidad_cigarros = 20 if q019 == 8
replace cantidad_cigarros = 20 if q019 == 9
replace cantidad_cigarros = 20 if q019 == 10
replace cantidad_cigarros = 20 if q019 == 11
replace cantidad_cigarros = 20 if q019 == 12
replace cantidad_cigarros = 20 if q019 == 13
replace cantidad_cigarros = 20 if q019 == 14

//Lucky Strike
*hist q029 if marca == 4
// los percentiles se toman del cálculo de la proporción en la w8
/*_pctile q029 if marca == 4, percentiles(24 91)

return list


scalars:
                 r(r1) =  54
                 r(r2) =  67

*/
// replace cantidad_cigarros = 14 if q019 == 15 & q029 <=59.5315
// replace cantidad_cigarros = 20 if q019 == 15 & q029 >59.5315
// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
// replace cantidad_cigarros = 14 if marca == 4 & q029 <=59.5315
// replace cantidad_cigarros = 20 if marca == 4 & q029 >59.5315
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 20 if marca == 4 & q029 <=56.618
recode cantidad_cigarros . = 25 if marca == 4 & q029 >56.618

ta cantidad_
ta marca cantidad_, m

//Marlboro
*hist q029 if marca == 5
// los percentiles se toman del cálculo de la proporción en la w8
/*_pctile q029 if marca == 5, percentiles(13 94)

return list


scalars:
                 r(r1) =  50
                 r(r2) =  77

*/
// replace cantidad_cigarros = 14 if q019 == 16 & q029 <=55.8757
// replace cantidad_cigarros = 20 if q019 == 16 & q029 >55.8757
// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
// replace cantidad_cigarros = 14 if marca == 5 & q029 <=55.8757
// replace cantidad_cigarros = 20 if marca == 5 & q029 >55.8757
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 14 if marca == 5 & q029 <=63.3219
recode cantidad_cigarros . = 20 if marca == 5 & q029 >63.3219

ta cantidad_
ta marca cantidad_, m

//Montana
*hist q029 if marca == 6
// los percentiles se toman del cálculo de la proporción en la w8
/*_pctile q029 if marca == 6, percentiles(33 50)

return list


scalars:
                 r(r1) =  38
                 r(r2) =  50

*/
// replace cantidad_cigarros = 14 if q019 == 17 & q029 <=45.8906
// // ORIGINAL reescribe los de 14 a 20
// // replace cantidad_cigarros = 15 if q019 == 17 & q029 <=45.8906
// // SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// // NO LO CAMBIA
// recode cantidad_cigarros . = 15 if q019 == 17 & q029 <=45.8906
// // ORIGINAL reescribe los de 14 y 20 a 24
// // replace cantidad_cigarros = 24 if q019 == 17 & q029 <=45.8906
// // SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// // NO LO CAMBIA
// recode cantidad_cigarros . = 24 if q019 == 17 & q029 <=45.8906
// // ORIGINAL reescribe los de 14 y 20 a 24
// // replace cantidad_cigarros = 25 if q019 == 17 & q029 >45.8906
// // SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// // NO LO CAMBIA
// recode cantidad_cigarros . = 25 if q019 == 17 & q029 >45.8906
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 14 if marca == 6 & q029 <=37
recode cantidad_cigarros . = 15 if marca == 6 & q029 <=46
recode cantidad_cigarros . = 24 if marca == 6 & q029 >46


ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 18

//Pall Mall
*hist q029 if marca == 7
// los percentiles se toman del cálculo de la proporción en la w8
/*_pctile q029 if marca == 7, percentiles(11 93)

return list


scalars:
                 r(r1) =  48
                 r(r2) =  65

*/
// replace cantidad_cigarros = 14 if q019 == 19 & q029 <=49.1343
// // ORIGINAL reescribe los de 14 a 20
// // replace cantidad_cigarros = 20 if q019 == 19 & q029 <=49.1343
// // SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// // NO LO CAMBIA
// recode cantidad_cigarros . = 20 if q019 == 19 & q029 <=49.1343 
// // ORIGINAL reescribe los de 14 y 20 a 24
// // replace cantidad_cigarros = 24 if q019 == 19 & q029 >49.1343
// // SUSTITUIDO CON RECODE, PARA SOLO CAMBIAR LOS VACIOS, SI YA TIENE UN VALOR
// // NO LO CAMBIA
// recode cantidad_cigarros . = 24 if q019 == 19 & q029 >49.1343
// SE MODIFICA LA CANTIDAD QUE DEFINE EL PUNTO DE CORTE 
// PARA TENER PROMEDIOS PONDERADOS
recode cantidad_cigarros . = 14 if marca == 7 & q029 <=52.5769
recode cantidad_cigarros . = 20 if marca == 7 & q029 >52.5769

ta cantidad_
ta marca cantidad_, m

// OTROS IGUAL A 20
replace cantidad_cigarros = 20 if q019 == 20
replace cantidad_cigarros = 20 if q019 == 21

replace cantidad_cigarros = 20 if q019 == 23
replace cantidad_cigarros = 20 if q019 == 24
replace cantidad_cigarros = 20 if q019 == 25
replace cantidad_cigarros = 20 if q019 == 26
replace cantidad_cigarros = 20 if q019 == 27
replace cantidad_cigarros = 20 if q019 == 28
replace cantidad_cigarros = 20 if q019 == 29

// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
recode cantidad_cigarros . = 20 if marca == 99

ta cantidad_
ta marca cantidad_, m

save "$datos/cantidades_cigarros_w5.dta", replace

// WAVE 4
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 4

do "$codigo/etiquetas_marcas.do"

keep id wave marca q019 q029 
// Benson
/*sum q029 if marca == 1, d
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8

_pctile q029 if marca == 1, percentiles(12 93)


// pctile pc_q029_1 = q029 if marca == 1, genp(pc_precio_1) nq

return list

scalars:
                 r(r1) =  48
                 r(r2) =  90
*/
/* ALTERNATIVOA A PARTIR DEL WAVE 8 
gen cantidad_cigarros = .
replace cantidad_cigarros = 14 if marca == 1 & q029 <=48
replace cantidad_cigarros = 20 if marca == 1 & q029 >48 & q029 <=90
replace cantidad_cigarros = 25 if marca == 1 & q029 >90
*/
gen cantidad_cigarros = .

recode cantidad_cigarros . = 14 if marca == 1 & q029 <=56.7375
recode cantidad_cigarros . = 20 if marca == 1 & q029 >56.7375


recode cantidad_cigarros . = 14 if marca == 2 & q029 <=56.0444
recode cantidad_cigarros . = 20 if marca == 2 & q029 >56.0444

recode cantidad_cigarros . = 14 if marca == 3 & q029 <=31.6667
recode cantidad_cigarros . = 15 if marca == 3 & q029 <=41.5536
recode cantidad_cigarros . = 18 if marca == 3 & q029 <=44.2083
recode cantidad_cigarros . = 20 if marca == 3 & q029 <=44.1667
recode cantidad_cigarros . = 24 if marca == 3 & q029 <=48.1667
recode cantidad_cigarros . = 25 if marca == 3 & q029 >48.1667

recode cantidad_cigarros . = 20 if marca == 4 & q029 <=51.315
recode cantidad_cigarros . = 25 if marca == 4 & q029 >51.315

recode cantidad_cigarros . = 14 if marca == 5 & q029 <=57.2391
recode cantidad_cigarros . = 20 if marca == 5 & q029 >57.2391


recode cantidad_cigarros . = 14 if marca == 6 & q029 <=32.25
recode cantidad_cigarros . = 15 if marca == 6 & q029 <=35.2
recode cantidad_cigarros . = 20 if marca == 6 & q029 <=48.8571
recode cantidad_cigarros . = 24 if marca == 6 & q029 <=49
recode cantidad_cigarros . = 25 if marca == 6 & q029 >49

recode cantidad_cigarros . = 14 if marca == 7 & q029 <=47.7678
recode cantidad_cigarros . = 20 if marca == 7 & q029 <=49.6216
recode cantidad_cigarros . = 24 if marca == 7 & q029 >49.6216

ta cantidad_
ta marca cantidad_, m

/* OTROS */
replace cantidad_cigarros = 20 if q019 == 1

replace cantidad_cigarros = 20 if q019 == 3

replace cantidad_cigarros = 20 if q019 == 6

replace cantidad_cigarros = 20 if q019 == 8
replace cantidad_cigarros = 20 if q019 == 9
replace cantidad_cigarros = 20 if q019 == 10
replace cantidad_cigarros = 20 if q019 == 11
replace cantidad_cigarros = 20 if q019 == 12
replace cantidad_cigarros = 20 if q019 == 13
replace cantidad_cigarros = 20 if q019 == 14

replace cantidad_cigarros = 20 if q019 == 18

replace cantidad_cigarros = 20 if q019 == 20
replace cantidad_cigarros = 20 if q019 == 21

replace cantidad_cigarros = 20 if q019 == 23
replace cantidad_cigarros = 20 if q019 == 24
replace cantidad_cigarros = 20 if q019 == 25
replace cantidad_cigarros = 20 if q019 == 26
replace cantidad_cigarros = 20 if q019 == 27
replace cantidad_cigarros = 20 if q019 == 28
replace cantidad_cigarros = 20 if q019 == 29

ta cantidad_
ta marca cantidad_, m

// SE CAMBIA q019 por marca PARA MANTENER LA CONSISTENCIA SOBRE LAS MARCAS EN etiquetas_marcas.do
recode cantidad_cigarros . = 20 if marca == 99

ta cantidad_
ta marca cantidad_, m

save "$datos/cantidades_cigarros_w4.dta", replace

use "$datos/cantidades_cigarros_w4.dta", clear

append using "$datos/cantidades_cigarros_w5.dta"

save "$datos/cant_cigarros_w4_w5.dta", replace

log close
