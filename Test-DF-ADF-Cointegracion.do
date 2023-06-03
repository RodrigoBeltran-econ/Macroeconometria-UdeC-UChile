**************
clear all
import excel "/Users/rodrigobeltranmoreira/Downloads/money.xlsx", sheet("Sheet1") firstrow


gen t = _n
generate time = tq(1959q1) + t - 1 
tsset time, quarterly
*daily
*monthly
*quarterly
*yearly

*demanda dinero
gen dd = m/p

*inflacion
gen lp = L1.p
gen infl = (p - lp)/lp


**********************************************************
*logaritmo
gen ldd = ln(dd)        //logaritmo demanda de dinero
gen ly = ln(y)          // logaritmo del producto


graph twoway (line  ldd  date) (line ly date) (line infl date)


reg ldd ly infl
dwstat
predict double res1, res

tsline res1




***Tenemos que comprobar que las variables sean I(1), procedemos a testear con
//test de dfuller para el dinero
*******************************PRIMER PASO**************************************
**TEST DF**
dfuller ldd, trend regress //no se rechaza la nula -> se debe eliminar t
regress D.ldd L1.ldd time 
predict double res2, res
corrgram res2		//No es ruido blanco, se pasa al ADF

*Test ADF:

dfuller ldd, trend regress lag(4)
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd time
predict double res3, res
corrgram res3	//sigue sin ser ruido blanco

dfuller ldd, regress lag(4)
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd
predict double res4, res
corrgram res4

dfuller ldd, trend regress lag(6)
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd L5D.ldd L6D.ldd time
predict double res5, res
corrgram res5

dfuller ldd, regress lag(6)
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd L5D.ldd L6D.ldd 
predict double res6, res
corrgram res6

//Al ir agregando rezagos llegaremos a que cuando se agrega el 8vo rezago ya
//no existe autocorrelación de los errores.

dfuller ldd, trend regress lag(8) //no se rechaza la nula -> se debe eliminar t
*Chequeamos que no exista autocorrelacion
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd L5D.ldd L6D.ldd L7D.ldd L8D.ldd time
predict double res7, res
corrgram res7 //ruido blanco

*******************************SEGUNDO PASO*************************************
* ADF sin tendencia
dfuller ldd, regress lag(8) //no se rechaza la nula ->tiene raiz unitaria
regress D.ldd L1.ldd LD.ldd L2D.ldd L3D.ldd L4D.ldd L5D.ldd L6D.ldd L7D.ldd L8D.ldd time
predict double res8, res
corrgram res8


*******************************************************************************
************************TERCER PASO******************************************
*******************************************************************************

dfuller d.ldd, regress lag(8) //Rechaza la nula ->Estamos en modelo B
regress D2.ldd LD.ldd LD2.ldd L2D2.ldd L3D2.ldd L4D2.ldd L5D2.ldd L6D2.ldd L7D2.ldd L8D2.ldd time
predict double res9, res
corrgram res9

*En tercer paso, H1 es que la serie diferenciada es AR(1) => serie es I(1). Por ende:
*¿la serie posee raíz unitaria? NO NECESARIAMENTE. Si existen quiebres estructu-
*rales, DF/ADF está sesgado a no rechazar la nula. Se puede chequear estaciona-
*riedad en presencia de quiebres estrucuturales usando la prueba de Perron.

***Aquí tenemos que el dinero SI es I(1)

drop res*




***Tenemos que comprobar que las variables sean I(1), procedemos a testear con
//test de dfuller para el producto
*******************************PRIMER PASO**************************************
**TEST DF**
dfuller ly, trend regress //no se rechaza la nula ->sedebe eliminar t
regress D.ly L1.y time 
predict double res1, res
corrgram res1		//No es ruido blanco, se pasa al ADF


dfuller ly, trend regress lag(4) //no se rechaza la nula ->sedebe eliminar t
regress D.y L1.ly LD.ly L2D.ly L3D.ly L4D.ly time
predict double res2, res
corrgram res2	//Ruido blanco


//Al ir agregando rezagos llegaremos a que cuando se agrega el 4vo rezago ya
//no existe autocorrelación de los errores, pero no se puede rechazar la nula
//con lo que se elimina t
*******************************SEGUNDO PASO*************************************
* ADF sin tendencia
dfuller ly, regress lag(4) //no se rechaza la nula ->tiene raiz unitaria
regress D.ly L1.ly LD.ly L2D.ly L3D.ly L4D.ly
predict double res3, res
corrgram res3


*******************************************************************************
************************TERCER PASO******************************************
*******************************************************************************

dfuller d.ly, regress lag(4) //Rechaza la nula ->Estamos en modelo B
regress D2.ly LD.ly LD2.ly L2D2.ly L3D2.ly L4D2.ly 
predict double res4, res
corrgram res4


**Entonces la serie del producto es I(1)





drop res*

***Tenemos que comprobar que las variables sean I(1), procedemos a testear con
//test de dfuller para la inflación
*******************************PRIMER PASO**************************************
**TEST DF**
dfuller infl, trend regress //no se rechaza la nula ->sedebe eliminar t
regress D.infl L1.infl time 
predict double res1, res
corrgram res1		//No es ruido blanco, se pasa al ADF


dfuller infl, trend regress lag(4) //no se rechaza la nula ->sedebe eliminar t
regress D.infl L1.infl LD.infl L2D.infl L3D.infl L4D.infl time
predict double res2, res
corrgram res2	//Ruido blanco


//Al ir agregando rezagos llegaremos a que cuando se agrega el 4vo rezago ya
//no existe autocorrelación de los errores, pero no se puede rechazar la nula
//con lo que se elimina t
*******************************SEGUNDO PASO*************************************
* ADF sin tendencia
dfuller infl, regress lag(4) //no se rechaza la nula ->tiene raiz unitaria
regress D.infl L1.infl LD.infl L2D.infl L3D.infl L4D.infl
predict double res3, res
corrgram res3


*******************************************************************************
************************TERCER PASO******************************************
*******************************************************************************

dfuller d.infl, regress lag(4) //Rechaza la nula ->Estamos en modelo B
regress D2.infl LD.infl LD2.infl L2D2.infl L3D2.infl L4D2.infl 
predict double res4, res
corrgram res4


**Entonces la serie de la inflación es I(1)


*****Con esto, concluimos que las 3 series son I(1), con lo que pasamos a estudiar
//el vector de cointegracion


**Pasamos a comprobar la cantidad óptima de rezagos
varsoc ldd ly infl

**Se sigue el criterio de AIC y HQ, por lo que se usan 3 rezagos
**Pasamos a realizar el test de Johansen
vecrank ldd ly infl, lags(3)

**Finalmente, estimamos el modelo VECM
vec ldd ly infl, lags(3) rank(1)


**Donde la última tabla es el vector de cointegracion, con lo que se
//puede armar la ecuacion de cointegracion
// ln(m/p) = -0.1397 -0.219*ln(y) + 19.79* infl

























