
cd "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\"

global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

do "$codigo\exploracion_.do"

do "$codigo\pre_panel.do"

do "$codigo\descriptivos.do"

*do "$codigo\quit_smoking_analysis.do"

