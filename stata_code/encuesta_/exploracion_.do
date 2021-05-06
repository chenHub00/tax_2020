
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA.dta", clear

* la mayoria han fumado en los ultimos dias
ta q005 q006
tab1 q005 q006

* cuantos cigarros fuman al d'ia?
ta q010

* a la semana 
ta q012

* comprobar n'umero de cigarros al d'ia
gen razon_sem_dia= q010/q012

* vacios
ta q010 q012

* No se pueden usar para comprobar, son excluyentes
gen cons_dia7 = q010*7
egen consumo_semanal = rowtotal(cons_dia7 q012), missing

ta q005 q006, sum(consumo_semanal)


// modelling count!
// cuánto han fumado?
// por marca
