// do_definicion_precio.do	
* ejecutar los códigos de la definición de precios

capture log close
log using "resultados/encuesta/do_definicion_precios.log", replace

global datos = "datos/encuesta/"
global codigo = "stata_code/encuesta_/"
global resultados = "resultados\encuesta\"

// cantidades por cajetida en wave 4 y 5
* do $codigo/para_precio4_5.do
do $codigo/para_precio_w4_w5_prom_minmax.do

capture log close
log using "resultados/encuesta/do_definicion_precios.log", append

* cantidades por cajetilla, ppu y consumo wave 4 y 5
do $codigo/para_precio_consumo_w4_w5.do

capture log close
log using "resultados/encuesta/do_definicion_precios.log", append

// wave 8
// para comparar ppu
do $codigo/para_precio_w8.do

do $codigo/gr_ppu_w04_w05.do	
* gr'afico para comparar w8 con w4 y w8

* descriptivos de la definici'on de precios
// do $codigo/descr_precio_w04_w05.do
