
//
// previos: do_encuesta.do
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"


do "$codigo/para_consumo.do"
// separar las gr'aficas

*do "$codigo/modelos_consumo.do"

do "$codigo/modelos_consumo_log.do"
