
// existen tablas ?
// 

cd "C:\Users\USUARIO\"

webuse nhanes2l
collect: regress bpsystol weight
collect: regress bpsystol weight i.sex i.agegrp
collect: regress bpsystol weight i.sex i.agegrp i.sex#i.agegrp
collect style save ado\personal\myreg, replace

collect preview

// https://www.youtube.com/watch?v=TFFdTIHHtUg
table () () (), command(regress bpsystol c.age##i.sex)
table () ( result ) (), command(regress bpsystol c.age##i.sex)
collect label levels result _r_b "Coef." _r_se "SE" _r_lb "__LEVEL__% lower" _r_ub "__LEVEL__% upper", modify
collect style cell result[_r_b]#result[_r_se]#result[_r_lb]#result[_r_ub], warn nformat(%9.3f)
collect style cell result[_r_p], warn nformat(%5.4f)
collect style cell, font( arial, )
collect style cell, border( right, pattern(nil) )
collect style cell, margin( top, width(5) ) margin( right, width(15) ) margin( bottom, width(5) ) margin( left, width(15) )
collect style cell
collect export "C:\Users\USUARIO\ado\personal\tabla_prueba_video.docx", as(docx) replace


collect style cell, nformat(%5.2f)
collect style _cons last
collect layout (colname) (result)

collect style save ado\personal\mystyle, replace

// Predefined styles
use https://www.stata-press.com/data/r17/nhanes2
table, command(regress bpsystol age weight) ///
	command(regress bpsystol age weight i.region) 

collect clear
collect style use style-table, replace
collect style header, title(hide) level(label)
collect style header command, level(value)
collect style showbase factor
collect style save mytablereg, replace

table, command(regress bpsystol age weight) ///
	command(regress bpsystol age weight i.region) style(mytablereg)
	
	