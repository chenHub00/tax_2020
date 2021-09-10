{smcl}
{com}{sf}{ul off}{txt}{.-}
      name:  {res}<unnamed>
       {txt}log:  {res}C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\resultados/inicial_marcas2.do
  {txt}log type:  {res}smcl
 {txt}opened on:  {res}10 Sep 2021, 11:06:32
{txt}
{com}. 
. use  datos/prelim/de_inpc/table11_principales7.dta, clear
{txt}
{com}. drop day fecha
{txt}
{com}. ta marca2, sum(ppu)

               {txt}{c |}           Summary of ppu
        marca2 {c |}        Mean   Std. Dev.       Freq.
{hline 15}{c +}{hline 36}
BENSON & HED.. {c |}  {res} 2.4686178   .39740809       5,618
{txt}         BOOTS {c |}  {res} 1.7376086   .16217708         152
{txt}         CAMEL {c |}  {res} 2.3718073   .35604411       4,043
{txt}  CHESTERFIELD {c |}  {res} 1.7897671    .3226417       3,369
{txt}     DELICADOS {c |}  {res}    1.5125      .04078          20
{txt}  LUCKY STRIKE {c |}  {res} 2.3151094   .31631509       2,188
{txt}      MARLBORO {c |}  {res} 2.5361129   .44584169       9,658
{txt}       MONTANA {c |}  {res} 1.8433896   .27727979       1,370
{txt}     PALL MALL {c |}  {res} 2.1226697   .42860253       4,675
{txt}       RALEIGH {c |}  {res} 1.9021278   .13493528       1,418
{txt}         SHOTS {c |}  {res} 1.8459161   .21747249          63
{txt}{hline 15}{c +}{hline 36}
         Total {c |}  {res} 2.2902829   .47045099      32,574
{txt}
{com}. 
. ta year marca

           {txt}{c |}                         marca
      year {c |} BENSON ..      CAMEL  CHESTER..  LUCKY S..   MARLBORO {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       495        396        374        349        791 {txt}{c |}{res}     2,916 
{txt}      2012 {c |}{res}       498        440        372        364        789 {txt}{c |}{res}     2,941 
{txt}      2013 {c |}{res}       527        453        351        369        795 {txt}{c |}{res}     2,993 
{txt}      2014 {c |}{res}       546        451        358        346        786 {txt}{c |}{res}     3,064 
{txt}      2015 {c |}{res}       540        451        366        349        777 {txt}{c |}{res}     3,023 
{txt}      2016 {c |}{res}       509        441        386        378        801 {txt}{c |}{res}     3,047 
{txt}      2017 {c |}{res}       498        437        370        362        811 {txt}{c |}{res}     3,047 
{txt}      2018 {c |}{res}       547        346        310        360      1,028 {txt}{c |}{res}     3,275 
{txt}      2019 {c |}{res}       616        255        242        317      1,330 {txt}{c |}{res}     3,563 
{txt}      2020 {c |}{res}       641        277        201        312      1,330 {txt}{c |}{res}     3,558 
{txt}      2021 {c |}{res}       201         96         59        100        420 {txt}{c |}{res}     1,147 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     5,618      4,043      3,389      3,606      9,658 {txt}{c |}{res}    32,574 


           {txt}{c |}         marca
      year {c |}   MONTANA  PALL MALL {c |}     Total
{hline 11}{c +}{hline 22}{c +}{hline 10}
      2011 {c |}{res}       184        327 {txt}{c |}{res}     2,916 
{txt}      2012 {c |}{res}       160        318 {txt}{c |}{res}     2,941 
{txt}      2013 {c |}{res}       158        340 {txt}{c |}{res}     2,993 
{txt}      2014 {c |}{res}       193        384 {txt}{c |}{res}     3,064 
{txt}      2015 {c |}{res}       142        398 {txt}{c |}{res}     3,023 
{txt}      2016 {c |}{res}        95        437 {txt}{c |}{res}     3,047 
{txt}      2017 {c |}{res}        80        489 {txt}{c |}{res}     3,047 
{txt}      2018 {c |}{res}       128        556 {txt}{c |}{res}     3,275 
{txt}      2019 {c |}{res}       125        678 {txt}{c |}{res}     3,563 
{txt}      2020 {c |}{res}       125        672 {txt}{c |}{res}     3,558 
{txt}      2021 {c |}{res}        43        228 {txt}{c |}{res}     1,147 
{txt}{hline 11}{c +}{hline 22}{c +}{hline 10}
     Total {c |}{res}     1,433      4,827 {txt}{c |}{res}    32,574 

{txt}
{com}. ta year marca2

           {txt}{c |}                         marca2
      year {c |} BENSON ..      BOOTS      CAMEL  CHESTER..  DELICADOS {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       495         61        396        374          0 {txt}{c |}{res}     2,916 
{txt}      2012 {c |}{res}       498         36        440        372          0 {txt}{c |}{res}     2,941 
{txt}      2013 {c |}{res}       527         24        453        351          0 {txt}{c |}{res}     2,993 
{txt}      2014 {c |}{res}       546         24        451        351          7 {txt}{c |}{res}     3,064 
{txt}      2015 {c |}{res}       540          7        451        354         12 {txt}{c |}{res}     3,023 
{txt}      2016 {c |}{res}       509          0        441        385          1 {txt}{c |}{res}     3,047 
{txt}      2017 {c |}{res}       498          0        437        370          0 {txt}{c |}{res}     3,047 
{txt}      2018 {c |}{res}       547          0        346        310          0 {txt}{c |}{res}     3,275 
{txt}      2019 {c |}{res}       616          0        255        242          0 {txt}{c |}{res}     3,563 
{txt}      2020 {c |}{res}       641          0        277        201          0 {txt}{c |}{res}     3,558 
{txt}      2021 {c |}{res}       201          0         96         59          0 {txt}{c |}{res}     1,147 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     5,618        152      4,043      3,369         20 {txt}{c |}{res}    32,574 


           {txt}{c |}                         marca2
      year {c |} LUCKY S..   MARLBORO    MONTANA  PALL MALL    RALEIGH {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}        12        791        184        266        337 {txt}{c |}{res}     2,916 
{txt}      2012 {c |}{res}        12        789        160        282        352 {txt}{c |}{res}     2,941 
{txt}      2013 {c |}{res}         9        795        158        316        360 {txt}{c |}{res}     2,993 
{txt}      2014 {c |}{res}        87        786        190        360        259 {txt}{c |}{res}     3,064 
{txt}      2015 {c |}{res}       279        777        136        391         70 {txt}{c |}{res}     3,023 
{txt}      2016 {c |}{res}       360        801         86        437         18 {txt}{c |}{res}     3,047 
{txt}      2017 {c |}{res}       352        811         68        489         10 {txt}{c |}{res}     3,047 
{txt}      2018 {c |}{res}       348      1,028        109        556         12 {txt}{c |}{res}     3,275 
{txt}      2019 {c |}{res}       317      1,330        113        678          0 {txt}{c |}{res}     3,563 
{txt}      2020 {c |}{res}       312      1,330        123        672          0 {txt}{c |}{res}     3,558 
{txt}      2021 {c |}{res}       100        420         43        228          0 {txt}{c |}{res}     1,147 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     2,188      9,658      1,370      4,675      1,418 {txt}{c |}{res}    32,574 


           {txt}{c |}   marca2
      year {c |}     SHOTS {c |}     Total
{hline 11}{c +}{hline 11}{c +}{hline 10}
      2011 {c |}{res}         0 {txt}{c |}{res}     2,916 
{txt}      2012 {c |}{res}         0 {txt}{c |}{res}     2,941 
{txt}      2013 {c |}{res}         0 {txt}{c |}{res}     2,993 
{txt}      2014 {c |}{res}         3 {txt}{c |}{res}     3,064 
{txt}      2015 {c |}{res}         6 {txt}{c |}{res}     3,023 
{txt}      2016 {c |}{res}         9 {txt}{c |}{res}     3,047 
{txt}      2017 {c |}{res}        12 {txt}{c |}{res}     3,047 
{txt}      2018 {c |}{res}        19 {txt}{c |}{res}     3,275 
{txt}      2019 {c |}{res}        12 {txt}{c |}{res}     3,563 
{txt}      2020 {c |}{res}         2 {txt}{c |}{res}     3,558 
{txt}      2021 {c |}{res}         0 {txt}{c |}{res}     1,147 
{txt}{hline 11}{c +}{hline 11}{c +}{hline 10}
     Total {c |}{res}        63 {txt}{c |}{res}    32,574 

{txt}
{com}. // observaciones perdidas al hacer collapse?
. //  Antes 1,147 en 2021 
. preserve
{txt}
{com}. collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
>                 by(year month cve_ciudad marca)
{txt}
{com}. ta year marca

           {txt}{c |}                         marca
      year {c |} BENSON ..      CAMEL  CHESTER..  LUCKY S..   MARLBORO {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       438        312        326        325        540 {txt}{c |}{res}     2,389 
{txt}      2012 {c |}{res}       438        356        324        340        540 {txt}{c |}{res}     2,398 
{txt}      2013 {c |}{res}       448        360        303        345        540 {txt}{c |}{res}     2,406 
{txt}      2014 {c |}{res}       483        360        310        311        530 {txt}{c |}{res}     2,469 
{txt}      2015 {c |}{res}       482        358        276        318        530 {txt}{c |}{res}     2,415 
{txt}      2016 {c |}{res}       458        357        270        330        548 {txt}{c |}{res}     2,385 
{txt}      2017 {c |}{res}       450        353        267        326        547 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}       483        286        224        325        580 {txt}{c |}{res}     2,374 
{txt}      2019 {c |}{res}       530        231        210        293        636 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}       535        253        198        298        636 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}       164         88         58         96        206 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     4,909      3,314      2,766      3,307      5,833 {txt}{c |}{res}    25,000 


           {txt}{c |}         marca
      year {c |}   MONTANA  PALL MALL {c |}     Total
{hline 11}{c +}{hline 22}{c +}{hline 10}
      2011 {c |}{res}       172        276 {txt}{c |}{res}     2,389 
{txt}      2012 {c |}{res}       147        253 {txt}{c |}{res}     2,398 
{txt}      2013 {c |}{res}       146        264 {txt}{c |}{res}     2,406 
{txt}      2014 {c |}{res}       181        294 {txt}{c |}{res}     2,469 
{txt}      2015 {c |}{res}       142        309 {txt}{c |}{res}     2,415 
{txt}      2016 {c |}{res}        92        330 {txt}{c |}{res}     2,385 
{txt}      2017 {c |}{res}        75        336 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}        96        380 {txt}{c |}{res}     2,374 
{txt}      2019 {c |}{res}        89        501 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}        89        503 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}        31        165 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 22}{c +}{hline 10}
     Total {c |}{res}     1,260      3,611 {txt}{c |}{res}    25,000 

{txt}
{com}. // observaciones perdidas al hacer collapse?
. // Despu'es 808 en 2021 
. restore
{txt}
{com}. 
. collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
>                 by(year month cve_ciudad marca2)
{txt}
{com}. ta year marca

           {txt}{c |}                         marca2
      year {c |} BENSON ..      BOOTS      CAMEL  CHESTER..  DELICADOS {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       438         61        312        326          0 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}       438         36        356        324          0 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}       448         24        360        303          0 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}       483         24        360        303          7 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}       482          7        358        264         12 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}       458          0        357        269          1 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}       450          0        353        267          0 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}       483          0        286        224          0 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}       530          0        231        210          0 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}       535          0        253        198          0 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}       164          0         88         58          0 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     4,909        152      3,314      2,746         20 {txt}{c |}{res}    25,084 


           {txt}{c |}                         marca2
      year {c |} LUCKY S..   MARLBORO    MONTANA  PALL MALL    RALEIGH {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}        12        540        172        218        313 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}        12        540        147        229        328 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}         9        540        146        249        336 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}        87        530        178        282        242 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}       265        530        136        308         70 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}       315        548         83        330         18 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}       316        547         63        336         10 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}       313        580         81        380         12 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}       293        636         77        501          0 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}       298        636         87        503          0 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}        96        206         31        165          0 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     2,016      5,833      1,201      3,501      1,329 {txt}{c |}{res}    25,084 


           {txt}{c |}   marca2
      year {c |}     SHOTS {c |}     Total
{hline 11}{c +}{hline 11}{c +}{hline 10}
      2011 {c |}{res}         0 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}         0 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}         0 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}         3 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}         6 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}         9 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}        12 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}        19 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}        12 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}         2 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}         0 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 11}{c +}{hline 10}
     Total {c |}{res}        63 {txt}{c |}{res}    25,084 

{txt}
{com}. // observaciones perdidas al hacer collapse?
. // Despu'es 808 en 2021 
. // no cambia al hacer collapse por marca2
. do stata_code/marca2.do
{txt}
{com}.  // 
.  // recodificar variable (marca2)  
.  // para mantener el mismo codigo
.  // generar variables de 
.  // 
. replace marca2 = "xBOOTS" if marca2 == "BOOTS" 
{txt}(152 real changes made)

{com}. replace marca2 = "yDELICADOS" if marca2 == "DELICADOS" 
{txt}(20 real changes made)

{com}. replace marca2 = "wRALEIGH" if marca2 == "RALEIGH" 
{txt}(1,329 real changes made)

{com}. replace marca2 = "zSHOTS" if marca2 == "SHOTS" 
{txt}(63 real changes made)

{com}. 
.  rename marca2 marca2_str
{res}{txt}
{com}.  encode marca2_str, gen(marca2)
{txt}
{com}. 
. ta marca2, sum(ppu)

            {txt}{c |}        Summary of (mean) ppu
     marca2 {c |}        Mean   Std. Dev.       Freq.
{hline 12}{c +}{hline 36}
  BENSON &  {c |}  {res} 2.4614351   .39194599       4,909
  {txt}    CAMEL {c |}  {res} 2.3889466   .36552556       3,314
  {txt}CHESTERFI {c |}  {res} 1.7848894   .33060529       2,746
  {txt}LUCKY STR {c |}  {res} 2.3196642   .32139462       2,016
  {txt} MARLBORO {c |}  {res} 2.4738304   .41288574       5,833
  {txt}  MONTANA {c |}  {res} 1.8189419   .26607592       1,201
  {txt}PALL MALL {c |}  {res} 2.1062143    .4315917       3,501
  {txt} wRALEIGH {c |}  {res} 1.9053207   .13698824       1,329
  {txt}   xBOOTS {c |}  {res} 1.7376086   .16217708         152
  {txt}yDELICADO {c |}  {res}    1.5125      .04078          20
  {txt}   zSHOTS {c |}  {res} 1.8459161   .21747249          63
{txt}{hline 12}{c +}{hline 36}
      Total {c |}  {res} 2.2527903   .45362871      25,084
{txt}
{com}. // tipo_marca
. // chesterfield + delicados?
. // grupo 1
. gen tipo2 = 1 if marca2 == 1 | marca2 == 2 | marca2 == 5 
{txt}(11,028 missing values generated)

{com}. replace tipo2 = 2 if marca2 == 4 | marca2 == 7 | marca2 == 8 | marca2 == 9
{txt}(6,998 real changes made)

{com}. * 8: Raleigh, 9: Boots
. replace tipo2 = 3 if marca2 == 3 | marca2 == 6 | marca2 == 10 | marca2 == 11
{txt}(4,030 real changes made)

{com}. * 10: Delicados, 11: Shots 
. 
. label define tipo2 1 "premium" 2 "medio" 3 "bajo"
{txt}
{com}. label values tipo2 tipo2
{txt}
{com}. 
. ta tipo2, su(ppu)

            {txt}{c |}        Summary of (mean) ppu
      tipo2 {c |}        Mean   Std. Dev.       Freq.
{hline 12}{c +}{hline 36}
    premium {c |}  {res} 2.4494882   .39627699      14,056
  {txt}    medio {c |}  {res} 2.1215472   .38802177       6,998
  {txt}     bajo {c |}  {res} 1.7946398   .31139351       4,030
{txt}{hline 12}{c +}{hline 36}
      Total {c |}  {res} 2.2527903   .45362871      25,084
{txt}
{com}. 
. 
{txt}end of do-file

{com}. // marca se puede obtener a partir de marca2, 
. 
. ta year marca2

           {txt}{c |}                         marca2
      year {c |} BENSON &       CAMEL  CHESTERFI  LUCKY STR   MARLBORO {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       438        312        326         12        540 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}       438        356        324         12        540 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}       448        360        303          9        540 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}       483        360        303         87        530 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}       482        358        264        265        530 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}       458        357        269        315        548 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}       450        353        267        316        547 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}       483        286        224        313        580 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}       530        231        210        293        636 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}       535        253        198        298        636 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}       164         88         58         96        206 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     4,909      3,314      2,746      2,016      5,833 {txt}{c |}{res}    25,084 


           {txt}{c |}                         marca2
      year {c |}   MONTANA  PALL MALL   wRALEIGH     xBOOTS  yDELICADO {c |}     Total
{hline 11}{c +}{hline 55}{c +}{hline 10}
      2011 {c |}{res}       172        218        313         61          0 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}       147        229        328         36          0 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}       146        249        336         24          0 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}       178        282        242         24          7 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}       136        308         70          7         12 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}        83        330         18          0          1 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}        63        336         10          0          0 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}        81        380         12          0          0 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}        77        501          0          0          0 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}        87        503          0          0          0 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}        31        165          0          0          0 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 55}{c +}{hline 10}
     Total {c |}{res}     1,201      3,501      1,329        152         20 {txt}{c |}{res}    25,084 


           {txt}{c |}   marca2
      year {c |}    zSHOTS {c |}     Total
{hline 11}{c +}{hline 11}{c +}{hline 10}
      2011 {c |}{res}         0 {txt}{c |}{res}     2,392 
{txt}      2012 {c |}{res}         0 {txt}{c |}{res}     2,410 
{txt}      2013 {c |}{res}         0 {txt}{c |}{res}     2,415 
{txt}      2014 {c |}{res}         3 {txt}{c |}{res}     2,499 
{txt}      2015 {c |}{res}         6 {txt}{c |}{res}     2,438 
{txt}      2016 {c |}{res}         9 {txt}{c |}{res}     2,388 
{txt}      2017 {c |}{res}        12 {txt}{c |}{res}     2,354 
{txt}      2018 {c |}{res}        19 {txt}{c |}{res}     2,378 
{txt}      2019 {c |}{res}        12 {txt}{c |}{res}     2,490 
{txt}      2020 {c |}{res}         2 {txt}{c |}{res}     2,512 
{txt}      2021 {c |}{res}         0 {txt}{c |}{res}       808 
{txt}{hline 11}{c +}{hline 11}{c +}{hline 10}
     Total {c |}{res}        63 {txt}{c |}{res}    25,084 

{txt}
{com}. 
. merge m:1 year month using datos/prelim/de_inpc/precios_indices.dta, gen(m_df_p)
{res}{txt}{p 0 7 2}
(note: variable
year was 
int, now float to accommodate using data's values)
{p_end}
{p 0 7 2}
(note: variable
month was 
byte, now float to accommodate using data's values)
{p_end}

{col 5}Result{col 38}# of obs.
{col 5}{hline 41}
{col 5}not matched{col 30}{res}               0
{txt}{col 5}matched{col 30}{res}          25,084{txt}  (m_df_p==3)
{col 5}{hline 41}

{com}. keep if m_ == 3
{txt}(0 observations deleted)

{com}. 
. ta tipo, su(ppu)

            {txt}{c |}        Summary of (mean) ppu
      tipo2 {c |}        Mean   Std. Dev.       Freq.
{hline 12}{c +}{hline 36}
    premium {c |}  {res} 2.4494882   .39627699      14,056
  {txt}    medio {c |}  {res} 2.1215472   .38802177       6,998
  {txt}     bajo {c |}  {res} 1.7946398   .31139351       4,030
{txt}{hline 12}{c +}{hline 36}
      Total {c |}  {res} 2.2527903   .45362871      25,084
{txt}
{com}. 
. merge m:1 year month cve_ciudad using datos\pp_lt_cerveza11_.dta, gen(m_otro_precio)
{res}
{txt}{col 5}Result{col 38}# of obs.
{col 5}{hline 41}
{col 5}not matched{col 30}{res}             808
{txt}{col 9}from master{col 30}{res}             808{txt}  (m_otro_precio==1)
{col 9}from using{col 30}{res}               0{txt}  (m_otro_precio==2)

{col 5}matched{col 30}{res}          24,276{txt}  (m_otro_precio==3)
{col 5}{hline 41}

{com}.  
. gen l_ppu = log(ppu)
{txt}
{com}. 
. gen y2020 = year==2020
{txt}
{com}. gen l_ppu_y2020=y2020*l_ppu 
{txt}
{com}. 
. gen ym_y2020=y2020*ym 
{txt}
{com}. 
. gen y2021 = year==2021
{txt}
{com}. gen l_ppu_y2021=y2021*l_ppu 
{txt}
{com}. 
. do stata_code/marca_marca2.do
{txt}
{com}. // crear una variable de marca a partir de otra variable de 
. // marca (marca2), m'as detallada
. // 
. 
. gen marca = marca2_str
{txt}
{com}. 
. replace marca = "PALL MALL" if marca2_ == "xBOOTS" 
{txt}(152 real changes made)

{com}. replace marca = "CHESTERFIELD" if marca2_ == "yDELICADOS" 
{txt}(20 real changes made)

{com}. replace marca = "LUCKY STRIKE" if marca2_ == "wRALEIGH" 
{txt}(1,329 real changes made)

{com}. replace marca = "MONTANA" if marca2_ == "zSHOTS" 
{txt}(63 real changes made)

{com}. 
. rename marca marca_str
{res}{txt}
{com}. encode marca_str, gen(marca)
{txt}
{com}. 
{txt}end of do-file

{com}. 
. save datos/prelim/de_inpc/tpCiudad2.dta, replace
{txt}file datos/prelim/de_inpc/tpCiudad2.dta saved

{com}. export excel using "datos/prelim/de_inpc/tpCiudad2.xlsx", replace
{res}{txt}file datos/prelim/de_inpc/tpCiudad2.xlsx saved

{com}. 
. log close
      {txt}name:  {res}<unnamed>
       {txt}log:  {res}C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\resultados/inicial_marcas2.do
  {txt}log type:  {res}smcl
 {txt}closed on:  {res}10 Sep 2021, 11:06:56
{txt}{.-}
{smcl}
{txt}{sf}{ul off}