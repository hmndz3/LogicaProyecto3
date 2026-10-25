% =====================================================================
%  LOGICA MATEMATICA - PROYECTO 3
%  Derivadas simbolicas en Prolog
% ---------------------------------------------------------------------
%  Uso:   ?- derivada(Funcion, Variable, Resultado).
%
%  Ejemplo:
%     ?- derivada(ln(x/(x+1)),x,Y).
%     Y = (1*(x+1)-x*(1+0))/(x+1)^2/(x/(x+1)).
%
%  La expresion NO se simplifica: solo queda indicada, tal como lo
%  pide el enunciado.
%
%  Funciones reconocidas:
%     +   -   *   /   ^      (polinomios)
%     sen   cos   tan   arctan   exp   ln
%
%  La regla de la cadena esta incluida dentro de cada regla: cada
%  funcion se deriva "por fuera" y se multiplica (o divide) por DU,
%  que es la derivada de lo que va adentro.
%
%  El ! (corte) de cada regla sirve para que Prolog use la PRIMERA
%  regla que coincide y devuelva una sola respuesta.
% =====================================================================


% ------------------------------------#variable
% La derivada de la variable respecto a ella misma es 1.   d(x)/dx = 1
derivada(X, X, 1) :- !.


% ------------------------------------#constante
% Cualquier numero u otra letra distinta de la variable es constante.
% d(c)/dx = 0
derivada(C, X, 0) :- atomic(C), C \= X, !.


% ------------------------------------#suma
% d(U+V) = DU + DV
derivada(U + V, X, DU + DV) :- !,
    derivada(U, X, DU),
    derivada(V, X, DV).


% ------------------------------------#resta
% d(U-V) = DU - DV
derivada(U - V, X, DU - DV) :- !,
    derivada(U, X, DU),
    derivada(V, X, DV).


% ------------------------------------#negativo
% d(-U) = -DU
derivada(-U, X, -DU) :- !,
    derivada(U, X, DU).


% ------------------------------------#constante por funcion
% Caso especial para que quede corto:  d(3*x) = 3*1   y no  0*x+3*1
% d(C*U) = C*DU
derivada(C * U, X, C * DU) :- number(C), !,
    derivada(U, X, DU).


% ------------------------------------#multiplicacion
% Regla del producto:  d(U*V) = DU*V + U*DV
derivada(U * V, X, DU * V + U * DV) :- !,
    derivada(U, X, DU),
    derivada(V, X, DV).


% ------------------------------------#division
% Regla del cociente:  d(U/V) = (DU*V - U*DV)/V^2
derivada(U / V, X, (DU * V - U * DV) / V ^ 2) :- !,
    derivada(U, X, DU),
    derivada(V, X, DV).


% ------------------------------------#potencia simple
% Cuando la base es la misma variable:  d(x^n) = n*x^(n-1)
derivada(X ^ N, X, N * X ^ N1) :- number(N), !,
    N1 is N - 1.


% ------------------------------------#potencia con regla de la cadena
% Cuando la base es otra expresion:  d(U^n) = n*U^(n-1)*DU
derivada(U ^ N, X, N * U ^ N1 * DU) :- number(N), !,
    N1 is N - 1,
    derivada(U, X, DU).


% ------------------------------------#seno
% d(sen(U)) = cos(U)*DU
derivada(sen(U), X, cos(U) * DU) :- !,
    derivada(U, X, DU).


% ------------------------------------#coseno
% d(cos(U)) = -sen(U)*DU
derivada(cos(U), X, -sen(U) * DU) :- !,
    derivada(U, X, DU).


% ------------------------------------#tangente
% d(tan(U)) = DU/cos(U)^2      (igual que sec(U)^2 * DU, pero sin usar sec)
derivada(tan(U), X, DU / cos(U) ^ 2) :- !,
    derivada(U, X, DU).


% ------------------------------------#arcotangente
% d(arctan(U)) = DU/(1+U^2)
derivada(arctan(U), X, DU / (1 + U ^ 2)) :- !,
    derivada(U, X, DU).


% ------------------------------------#exponencial
% d(exp(U)) = exp(U)*DU
derivada(exp(U), X, exp(U) * DU) :- !,
    derivada(U, X, DU).


% ------------------------------------#logaritmo natural
% d(ln(U)) = DU/U
derivada(ln(U), X, DU / U) :- !,
    derivada(U, X, DU).


% ------------------------------------#pruebas
% Corre los 5 ejemplos del enunciado:   ?- pruebas.
pruebas :-
    probar(ln(x/(x+1))),
    probar(sen(exp(3*x))),
    probar(ln(sen((x+1)/x))),
    probar((x^5+x^3)/(x^2+1)),
    probar(arctan((x^2+1)^10)),
    probar(tan(x^2)),
    probar(x^3*sen(x)).

probar(F) :-
    derivada(F, x, Y),
    write('derivada('), write(F), write(',x,Y).'), nl,
    write('Y = '), write(Y), nl, nl.


% =====================================================================
% ------------------------------------#referencias
%
% [1] tokkenno, "derivada.prolog" (Gist de GitHub).
%     https://gist.github.com/tokkenno/8038482
%     De aqui se tomo la IDEA de como organizar el predicado
%     derivada/3 (una clausula para la variable, una para la
%     constante con atomic/1 y el \=, y una clausula por cada
%     operador +, -, *, /) y la forma de la regla de la potencia
%     n*x^(n-1) calculando el exponente con "N1 is N-1".
%     NO se copio su codigo de simplificacion (operacion/2,
%     simplificar/2), porque este proyecto pide dejar la expresion
%     SIN simplificar, y sus reglas de producto y cociente estan
%     en otro orden / tienen el denominador distinto al que piden
%     los ejemplos del enunciado.
%
% [2] P. Gonzalez, "Laboratorio 05 - Programacion Logica", IIMAS-UNAM.
%     http://turing.iimas.unam.mx/~pedroG/al-2008-II/Lab_05.pdf
%     Referencia del enunciado: ejemplo clasico de derivacion
%     simbolica en Prolog (mismo esquema de clausulas).
%
% [3] I. Bratko, "Prolog Programming for Artificial Intelligence".
%     El ejemplo de derivacion simbolica d/3 de este libro es el
%     origen del esquema usado en [1] y [2].
%
% Las reglas de sen, cos, tan, arctan, exp y ln, la regla de la
% cadena en la potencia (n*U^(n-1)*DU), el caso C*U y el formato
% exacto de salida de los ejemplos se escribieron para este
% proyecto a partir de las tablas de derivadas de calculo.
% =====================================================================
