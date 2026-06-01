% INTEGRACION NUMERICA

% DATOS
V = [1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75, 4];
P = [300.2, 242.1, 201.5, 169.8, 151, 134.3, 120.8, 107.9, 99.1, 93.4, 86.2, 79.5, 75.1];
n = length(V) - 1; 
h = 0.25;

%LIMITES
a = V(1);
b = V(end);

% TRAPECIO COMPUESTA
S_trap = P(1) + P(end);
for i = 2:n
    S_trap = S_trap + 2 * P(i);
end
I_trap = (h / 2) * S_trap;

% SIMPSON 1/3
S_simp13 = P(1) + P(end);
for i = 2:n
    if mod(i-1, 2) ~= 0 
        S_simp13 = S_simp13 + 4 * P(i);
    else
        S_simp13 = S_simp13 + 2 * P(i);
    end
end
I_simp13 = (h / 3) * S_simp13;

% SIMPSON 3/8
S_simp38 = P(1) + P(end);
for i = 2:n
    if mod(i-1, 3) == 0
        S_simp38 = S_simp38 + 2 * P(i);
    else
        S_simp38 = S_simp38 + 3 * P(i);
    end
end
I_simp38 = (3 * h / 8) * S_simp38;

% GAUSS-LEGENDRE
% NODOS Y PESOS
t_nodos = [-sqrt(3/5), 0, sqrt(3/5)];
pesos = [5/9, 8/9, 5/9];

% Mapeo de la variable t al dominio V [a, b]
V_gauss = ((b - a) / 2) * t_nodos + ((b + a) / 2);

P_gauss = spline(V, P, V_gauss);

% Sumatoria de Gauss-Legendre
I_gauss = 0;
for i = 1:3
    I_gauss = I_gauss + pesos(i) * P_gauss(i);
end
I_gauss = ((b - a) / 2) * I_gauss;


% CÁLCULO DEL VALOR EXACTO Y ERRORES RELATIVOS
% AL SER UN PROCESO ISOTERMICO (P*V = 300)
% ENTONCES LA FUNCION P(V) = 300 / V.
% INTEGRAL DE (300/V) EVALUADA DE a HASTA b : 300 * ln(b/a)

I_exacta = 300 * log(b/a);

% ERROR RELATIVO
err_trap   = abs((I_exacta - I_trap) / I_exacta) * 100;
err_simp13 = abs((I_exacta - I_simp13) / I_exacta) * 100;
err_simp38 = abs((I_exacta - I_simp38) / I_exacta) * 100;
err_gauss  = abs((I_exacta - I_gauss) / I_exacta) * 100;

% TABLA
fprintf('\n--- ANÁLISIS DE TRABAJO TERMODINÁMICO ---\n');
fprintf('Valor Exacto Teórico (Integral de 300/V): %.4f kPa*L\n\n', I_exacta);

fprintf('METODO \t\t\t VALOR APROXIMADO \t ERROR RELATIVO %\n');
fprintf('----------------------------------------------------------------\n');
fprintf('Trapecio \t\t %.4f \t\t %.4f %%\n', I_trap, err_trap);
fprintf('Simpson 1/3 \t\t %.4f \t\t %.4f %%\n', I_simp13, err_simp13);
fprintf('Simpson 3/8 \t\t %.4f \t\t %.4f %%\n', I_simp38, err_simp38);
fprintf('Gauss-Legendre \t\t %.4f \t\t %.4f %%\n', I_gauss, err_gauss);
fprintf('----------------------------------------------------------------\n');