
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

* wave 4  y 5
*do "$codigo/para_consumo.do"

do "$codigo/para_consumo_w4_w5_w6.do"
// separar las gr'aficas

*do "$codigo/modelos_consumo.do"

do "$codigo/modelos_consumo_log.do"


