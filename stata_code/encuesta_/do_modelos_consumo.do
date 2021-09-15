
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

// Datos

do "$codigo/para_consumo.do"
// separar las gr'aficas

do "$codigo/para_consumo_w4_w5_w6.do"

// gen_vars.do
// pre_panel.do


// Modelos
*do "$codigo/modelos_consumo.do"

do "$codigo/modelos_consumo_log.do"

// Modelos
do "$codigo/modelos_consumo_tnb.do
* estimación tnb: tobit negative binomial


// 
do "$codigo/modelos_consumo4.do"
