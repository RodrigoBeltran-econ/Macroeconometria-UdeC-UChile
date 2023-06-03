***VAR Killian
import excel "/Users/rodrigobeltranmoreira/Desktop/Econometria 2/Ayudantias/A5/Kilian2009.xlsx", sheet("Sheet1") firstrow clear


generate t = tm(1973m1) + _n-1
format t %tm
tsset t

graph twoway (line  oil t) (line output t) (line price t)


varsoc oil output price, maxlag(12)

var oil output price, lags(1/2) //siempre marcar desde que lag hasta cual

*Chequeamos la estabilidad de los parámetros:
varstable, graph 


**Definimos la matriz de identificacion en base a los supuestos
*Matriz A de STATA corresponde a la matriz B de la materia
*Matriz B de STATA es la matriz de varianzas
matrix input A = (1,0,0\.,1,0\.,.,1)
matrix input B = (.,0,0\0,.,0\0,0,.)


svar oil output price, aeq(A) beq(B) lags(1/2) iter(1000) 


*Con esto, obtenemos los valores de ambas matrices
matrix list e(A)
matrix list e(B)



*Ya que tenemos el modelo SVAR podemos calcular las IRF 
irf set, clear
irf create irf1, set(irf1) step(20) replace
#delimit ;
irf graph irf, impulse(oil output price) 
response(oil output price) 
ci(fi(0) lp(dash))
scheme(s1color)
xtitle("")
legend(order(1 "95% Confidence interval" 2 "Impulse Response"))
;
#delimit cr

*Finalmente obtenemos la descomposición de la varianza:
irf table sfevd, impulse(oil) st(30)
irf table sfevd, impulse(output) st(30)
irf table sfevd, impulse(price) st(30)

*También odemos verla gráficamente:
irf graph sfevd, impulse(oil) response(oil output price) ci(fi(0) lp(dash))
irf graph sfevd, impulse(output) response(oil output price) ci(fi(0) lp(dash))
irf graph sfevd, impulse(price)  response(oil output price) ci(fi(0) lp(dash))


