/*
descriptivos.do
* dependiende de: pre_panel.do, recodificar_.do

* sin considerar el ajuste en los precios? 
* sin asignar un precio por unidad, dado un precio por cajetilla
- w01_w08_v1: wave 1 a 8
- age, gender, education > (q001, q002-sexo(0/1), q003)
- consumo (semanal)> q012
- marca favorita > q019 (q018, tiene marca favorita)
- 'ultima marca -> q026
- pagado por la cajetilla > q029 [q028 = 1, compro cajetilla]
- pagado por cigarro suelto > q030 [q028 = 2, compro cigarro suelto]

*/

ta wave

// edad, 
su q001
ta q001 edad_cat4

ta wave, su(q001)

// sexo
tab q002 sexo, nol

// identidad: identidad_genero

tab1 q002 q003

ta wave, su(sexo)
ta wave, su(q003)

ta wave q003
ta wave educ_3catr

su q010

*tab q012
*tab q012 wave
su q012 
ta wave, su(q012)


ta wave, su(consumo_semanal)

*- marca favorita > q019 (q018, tiene marca favorita)
*- 'ultima marca -> q026
*ta q019 wave
ta q019 wave if q018 == 1
ta q026 wave
