// cd al inicio de tax_2020 por ejemplo:
// cd ~/Documentos/R/tax_ene2020/tax_2020
set more off

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta_\"

// exploraci'on de los  
*do "$codigo\exploracion_.do"

do "$codigo\pre_panel.do"

// recodificar 
do "$codigo\recodificar_.do"

// etiquetas
do "$codigo\etiquetas_marcas.do"
do "$codigo\otras_etiquetas.do"


// descriptivos
//do "$codigo\descriptivos.do"
do "$codigo\descriptivos_recodificar.do"
// do "$codigo\descriptivos_wave_precio_inpc.do"
do "$codigo\descriptivos_recodificar_precio.do"

do "$codigo\precios_por_consumo.do"

// exploraci'on de pesos
do "$codigo\weights_.do"

*do "$codigo\quit_smoking_analysis.do"

