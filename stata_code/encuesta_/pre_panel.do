// 
// seccion dejar de fumar p. 31
// seccion no fumadores p. 47
*use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA.dta", clear
use "$datos/91224059_w01_w08_appended_merge_w1_w8_v1_06042021_ETIQUETA SEND_weights.dta", clear

keep wave id weight* q001-q030 q006a q029a edad_cat4 consumo escolaridad sexo /// 
	educ_9cat educ_3catr fum_100cig_vida current_smoker 

// Long data
* x = individual id, wave = wave (5 available)
*rename x id
// 'util antes
duplicates report id wave

destring id, replace

xtset id wave
xtdes, patterns (10)

// id en wave consecutivas asigna 1 a la primera observación
sort id wave
qui by id: g islead = wave[_n+1]==wave+1
// no identifica los saltos en wave

// id m'as de una wave asigna 1 
sort id wave
qui by id: g twoOrMore = id[_n+1]==id[_n]
// no identifica el 'ultimo id 

// todas las observaciones que están con id repetidos
// los id que sólo están en una wave, tendrán cero
egen with2more= max(twoOrMore),by(id)


// para los que aparacen más de una vez el orden de levantamiento para cada id
// 1 significa la primera vez que se levanta
by id: gen sumWith2more= sum(with2more)
