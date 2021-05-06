
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"

do "$codigo\exploracion_.do"

do "$codigo\pre_panel.do"

do "$codigo\descriptivos.do"

*do "$codigo\quit_smoking_analysis.do"

