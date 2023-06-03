/* Modelo NK
*/

// 1. Variables
//  1.1 Declaración variables Endógenas
        var Y_hat Yf_hat inflH_hat int_tilde A_hat;

//  1.2 Declaración variables Exógenas
        varexo e_A;  //shock prod

// 2. Parámetros
//  2.1 Declaración de Parámetros
        parameters phia phiinf phii siggma etta gama betta alphha fii vareps ommega kappa sigmaalpha;

//  2.2 Calibración de Parámetros
        phia = 0.66; phiinf = 1.5; phii = 0.75; siggma = 1; etta = 1; gama = 1; betta = 0.97; alphha = 0.4; fii = 3; vareps = 0.01; ommega = 1.5; kappa = 0.09; sigmaalpha = 1;

// 3. Declaración del Modelo 
model(linear); // linear --> entrego ecuaciones log-linearizadas

Y_hat = Y_hat(+1) - ((1+alphha*(ommega-1))/siggma)*(int_tilde - inflH_hat(+1));  //ecuacion IS
inflH_hat = kappa*(sigmaalpha+fii)*(Y_hat-Yf_hat)+betta*inflH_hat(+1);           // ecuacion Curva de Phillips
int_tilde = phiinf*inflH_hat;                                                    // tasa interes
A_hat = phia*A_hat(-1) + e_A;                                                    // shock productividad
(sigmaalpha+fii)*Yf_hat = (1+fii)*A_hat;                                         // producto sin fricciones
end;

// 4. Declaración de Shocks (modelo estocastico)
// en varianza no en ds

shocks;
var e_A = vareps^(2);
end;

// sin SS pq valor es 0 por lo que no es necesario al estar log linearizado
stoch_simul(order=1,irf=20);
