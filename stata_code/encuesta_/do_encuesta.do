
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

*do "$codigo\exploracion_.do"

do "$codigo\pre_panel.do"

do "$codigo\recodificar_.do"

do "$codigo\etiquetas_marcas.do"

do "$codigo\descriptivos.do"

do "$codigo\precios_por_consumo.do"

// exploraci'on de pesos
do "$codigo\weights_.do"

*do "$codigo\quit_smoking_analysis.do"

