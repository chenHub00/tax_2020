// NO consideramos otras marcas

cd "C:\Users\danny\Desktop\Cohorte de fumadores\"
//  
capture log close
log using "para_precio4_5.log", replace

use "91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 8

do "etiquetas_marcas.do"

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

//Marlboro
ta q029a if marca == 5
proportion q029a if marca == 5
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .13453815  .80923695   .0562249
*/

//Montana
ta q029a if marca == 6
proportion q029a if marca == 6
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .32758621  .17241379         .5

*/

//Pall Mall
ta q029a if marca == 7
proportion q029a if marca == 7
matrix list e(b)
/* estimación de las proporciones
e(b)[1,3]
        q029a      q029a      q029a
y1  .11111111  .83333333  .05555556

*/

use "91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 5

do "etiquetas_marcas.do"


// Benson
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 1, percentiles(12 93)

return list
/*
scalars:

                 r(r1) =  50
                 r(r2) =  90
*/

gen cantidad_cigarros = .
replace cantidad_cigarros = 14 if q019 == 2 & q029 <=54.886
replace cantidad_cigarros = 20 if q019 == 2 & q029 >54.886

ta cantidad_

//Camel
*hist q029 if marca == 2
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 2, percentiles(12 97)

return list
/*

scalars:
                 r(r1) =  47
                 r(r2) =  85

*/
replace cantidad_cigarros = 14 if q019 == 4 & q029 <=54.3625
replace cantidad_cigarros = 20 if q019 == 4 & q029 >54.3625

ta cantidad_

//Chesterfield
*hist q029 if marca == 3
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 3, percentiles(23 64)

return list
/*

scalars:
                 r(r1) =  45
                 r(r2) =  55

*/
replace cantidad_cigarros = 15 if q019 == 5 & q029 <=48.3845
replace cantidad_cigarros = 18 if q019 == 5 & q029 <=48.3845
replace cantidad_cigarros = 20 if q019 == 5 & q029 <=48.3845
replace cantidad_cigarros = 24 if q019 == 5 & q029 <=48.3845
replace cantidad_cigarros = 25 if q019 == 5 & q029 >48.3845

ta cantidad_

//Lucky Strike
*hist q029 if marca == 4
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 4, percentiles(24 91)

return list
/*

scalars:
                 r(r1) =  54
                 r(r2) =  67

*/
replace cantidad_cigarros = 14 if q019 == 15 & q029 <=59.5315
replace cantidad_cigarros = 20 if q019 == 15 & q029 >59.5315

ta cantidad_

//Marlboro
*hist q029 if marca == 5
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 5, percentiles(13 94)

return list
/*

scalars:
                 r(r1) =  50
                 r(r2) =  77

*/
replace cantidad_cigarros = 14 if q019 == 16 & q029 <=55.8757
replace cantidad_cigarros = 20 if q019 == 16 & q029 >55.8757

ta cantidad_

//Montana
*hist q029 if marca == 6
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 6, percentiles(33 50)

return list
/*

scalars:
                 r(r1) =  38
                 r(r2) =  50

*/
replace cantidad_cigarros = 14 if q019 == 17 & q029 <=45.8906
replace cantidad_cigarros = 15 if q019 == 17 & q029 <=45.8906
replace cantidad_cigarros = 24 if q019 == 17 & q029 <=45.8906
replace cantidad_cigarros = 25 if q019 == 17 & q029 >45.8906

ta cantidad_

//Pall Mall
*hist q029 if marca == 7
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 7, percentiles(11 93)

return list
/*

scalars:
                 r(r1) =  48
                 r(r2) =  65

*/
replace cantidad_cigarros = 14 if q019 == 19 & q029 <=49.1343
replace cantidad_cigarros = 20 if q019 == 19 & q029 <=49.1343
replace cantidad_cigarros = 24 if q019 == 19 & q029 >49.1343

ta cantidad_

save "cantidades_cigarros_w5.dta", clear

//
use "91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep if wave == 4

do "etiquetas_marcas.do"

// Benson
sum q029 if marca == 1, d
*hist q029 if marca == 1
// los percentiles se toman del cálculo de la proporción en la w8
_pctile q029 if marca == 1, percentiles p(12 93)


pctile pc_q029_1 = q029 if marca == 1, genp(pc_precio_1) nq

return list
/*
scalars:
                 r(r1) =  48
                 r(r2) =  90
*/

gen cantidad_cigarros = .
replace cantidad_cigarros = 14 if marca == 1 & q029 <=48
replace cantidad_cigarros = 20 if marca == 1 & q029 >48 & q029 <=90
replace cantidad_cigarros = 25 if marca == 1 & q029 >90


keep id wave cantidad_cigarros marca q019 


save "cantidades_cigarros_w4.dta", clear
