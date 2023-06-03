/* Tarea 1
Profesor: Ernesto Pastén
Alumnos: Rodrigo Beltran - Joaquin Cabezas*/



// 1. Variables
//  1.1 Declaración variables Endógenas
        var Y C K L A W R I;
//  1.2 Declaración variables Exógenas
        varexo eps_A;

// 2. Parámetros
//  2.1 Declaración de Parámetros
        parameters alph betta thheta phiA sigmae;
//  2.2 Calibración de Parámetros
        alph=1/3; betta=0.99; thheta=3.968; phiA=0.979; sigmae=0.0072;

// 3. Declaración del Modelo 
model;
    #UC  = exp(C)^(-1);
    #UCp = exp(C(+1))^(-1);
    #UL  = thheta*(1-exp(L))^(-1);
    UC = betta*UCp*(exp(R(+1)));
    exp(W) = UL/UC;
    exp(K) = exp(I(-1));
    exp(Y) = exp(I)+exp(C);
    exp(Y) = exp(A)*exp(K)^alph*exp(L)^(1-alph);
    exp(W) = (1-alph)*exp(Y)/exp(L);
    exp(R) = alph*exp(Y)/exp(K);
    A = phiA*A(-1)+eps_A;
end;

// 4. Declaración de Shocks (modelo estocastico)

shocks;
var eps_A = sigmae^(2); 
end;

// 5. Declaración del Estado Estacionario 
steady_state_model;
    Ass = 1;
    Rss = 1/betta;
    K_L = (Rss/(alph*Ass))^(1/(alph-1));
    Wss = (1-alph)*Ass*K_L^alph;
    I_L = K_L;
    Y_L = Ass*K_L^alph;
    C_L = Y_L-I_L; 
    Lss = Wss/(thheta*C_L+Wss);
    Css = C_L*Lss;
    Iss = I_L*Lss;
    Kss = K_L*Lss;
    Yss = Y_L*Lss;

    // SS en log que es consistente con la escritura del modelo en terminos porcentuales
    A = log(Ass);
    R = log(Rss);
    W = log(Wss);
    L = log(Lss);
    C = log(Css);
    I = log(Iss);
    K = log(Kss);
    Y = log(Yss);
end;


// 5.2 Computar el estado estacionario
steady;
check;
resid;

// 6. Solucion modelo

stoch_simul(order=1,irf=100, periods=200000, hp_filter=1600);