/*
precios_por_consumo.do
- distribuciones de precios
+ por principales marcas
+ por wave (4 y 5)

*/

* - pagado por la cajetilla > q029 [q028 = 1, compro cajetilla]
* - pagado por cigarro suelto > q030 [q028 = 2, compro cigarro suelto]
*ta q029 wave if q028 == 1
ta wave if q028 == 1, su(q029)
*ta q030 wave if q028 == 2
ta wave if q028 == 2, su(q030)
