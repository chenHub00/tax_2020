// a apartir de 0_Variables_ENIGH
// se modifican las carpetas de origen y guardado
// 
// 
************************************
*Características de jefa del hogar, ingreso corriente, entidad, municipio, rural, hhdsize, ratio males/hhdsize
************************************
clear 
set more off
foreach i of global anios {	
//	use "$path/ENIGH_`i'/Microdatos/concentradohogar.dta"		
	use "$path/datos/enigh/`i'/concentradohogar.dta"		
	if `i'==2008 | `i'==2010 {
		rename sexo sexo_jefe
		rename edad edad_jefe
		rename ed_formal educa_jefe
		rename gasmon gasto_mon
		rename tam_hog tot_integ
		rename ingcor ing_cor
		capture rename estrato tam_loc 
	}	
	destring sexo_jefe educa_jefe, replace		
	recode sexo_jefe (1=0) (2=1),g(mujerjefa)
	rename edad_jefe edadjefa
	g edadjefa2 = edadjefa*edadjefa
	recode educa_jefe (1/3=1) (4/5=2) (6/7=3) (8/9=4) (10=5) (11=6),g(educajefa)
	label def educajefa 1 "No formal education" 2 "Complete primary" 3 "Complete secondary" ///
		4 "Complete high school" 5 "Complete college" 6 "Posgraduate "
	label val educajefa educajefa
	
	rename tabaco gastotabinegi
	
	rename tot_integ hsize	
	g maleratio = hombres/hsize
	
	g ictpc = ing_cor/hsize
	g lnictpc = ln(ictpc)
	xtile qictpc = ictpc [w=factor],nq(5)
	xtile tictpc = ictpc [w=factor],nq(3)
	if `i'==2008 {
		g ictpcdef=ictpc*1.49704292
		g exptotal=gasto_mon*1.49704292
	}	
	if `i'==2010 {
		g ictpcdef=ictpc*1.37411803
		g exptotal=gasto_mon*1.37411803
	}
	if `i'==2012 {
		g ictpcdef=ictpc*1.27058705
		g exptotal=gasto_mon*1.27058705		
	}
	if `i'==2014 {
		g ictpcdef=ictpc*1.17920676
		g exptotal=gasto_mon*1.17920676		
	}
	if `i'==2016 {
		g ictpcdef=ictpc*1.11895244
		g exptotal=gasto_mon*1.11895244		
	}
	if `i'==2018 {
		g ictpcdef=ictpc*1
		g exptotal=gasto_mon*1		
	}
	/* Ajuste inflación a 2018 - 2a quincena de julio = 100 */
	/* general? = 1.075417564 por objeto del gasto? */
	/*  */
	if `i'==2020 {
		g ictpcdef=ictpc*0.929871367
		g exptotal=gasto_mon*0.929871367
	}

	g exptotalpc=exptotal/hsize
	
	g entidad = real(substr(folioviv,1,2))
	
	g municipio = real(substr(ubica_geo,1,5))	//2 primeros digitos para entidad y 3 para el municipio
	
	destring tam_loc, replace
	g rural = 1 if tam_loc==4 
	replace rural = 0 if tam_loc>=1 & tam_loc<=3
	*ojo: definicion rural tambien se puede construir con 3era posición del folio (rural si posición=6, urbana en otro caso)
	*g rural = 1 if real(substr(folioviv,3,1))==6 
	*replace rural = 0 if real(substr(folioviv,3,1))!=6
	
	keep folioviv foliohog mujerjefa edadjefa edadjefa2 educajefa gastotabinegi factor upm est_dis ing_cor ///
		hsize maleratio exptotal exptotalpc ictpc* qictpc tictpc entidad municipio rural
	save "datos/prelim/de_enigh/`i'/final_ecea2.dta", replace
	duplicates repor folioviv foliohog 
} 
