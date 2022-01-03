*
*do C:\Users\USUARIO\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\elasticidad\0_globals.do

capture log close 
log using $pathout\dataproc.log, replace

do $do_files\2_1_concentrado_hogar.do
do $do_files\2_2_gastoshogar_ecea2.do
do $do_files\2_3_poblacion.do
do $do_files\2_4_gastohogar_cigsemk_ecea2.do
do $do_files\3_ecea2_2016_2020.do

log close

do $do_files\5_Do_AIDS_only_tobacco.do

