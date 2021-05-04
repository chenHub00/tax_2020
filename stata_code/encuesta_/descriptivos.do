/*
descriptivos.do
* sin considerar el ajuste en los precios? 
* sin asignar un precio por unidad, dado un precio por cajetilla
- w01_w05_: wave 1 a 4
- age, gender, education > (q001, q002-sexo(0/1), q003)
- consumo (semanal)> q012
- marca favorita > q019 (q018, tiene marca favorita)
- 'ultima marca -> q026
- pagado por la cajetilla > q029 [q028 = 1, compro cajetilla]
- pagado por cigarro suelto > q030 [q028 = 2, compro cigarro suelto]

*/

ta wave

su q001

ta wave, su(q001)

tab1 q001 q002 q003

ta wave, su(sexo)
ta wave, su(q003)

*tab q012
tab q012 wave
ta wave, su(q012)

*- marca favorita > q019 (q018, tiene marca favorita)
*- 'ultima marca -> q026
*ta q019 wave
ta q019 wave if q018 == 1
ta q026 wave

* - pagado por la cajetilla > q029 [q028 = 1, compro cajetilla]
* - pagado por cigarro suelto > q030 [q028 = 2, compro cigarro suelto]
ta q029 wave if q028 == 1
ta q030 wave if q028 == 2

ta q030 wave if q028 == 2

