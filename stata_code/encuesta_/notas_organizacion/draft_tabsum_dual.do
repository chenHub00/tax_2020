do "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\stata_code\encuesta_\cd_local.do"

ta dual_use100cig
ta wave dual_use100cig
ta wave dual_use100cig, su(consumo_semanal)
ta wave dual_use100cig, su(consumo_semanal) nost
ta wave dual_use100cig, su(consumo_semanal) nost nofreq
ta wave dual_use100cig if sexo == 1, su(consumo_semanal) nost nofreq
