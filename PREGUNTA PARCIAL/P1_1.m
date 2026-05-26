% =============================================
% Parte 1: Interpolación Básica y Spline Cúbico
% =============================================

% Datos
f = [10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0, 32.5, 35.0, ...
     37.5, 40.0, 42.5, 45.0, 47.5, 50.0, 52.5, 55.0, 57.5, 60.0, 62.5, ...
     65.0, 67.5, 70.0, 72.5, 75.0, 77.5, 80.0, 82.5, 85.0, 87.5, 90.0, ...
     92.5, 95.0, 97.5, 100.0, 102.5, 105.0, 107.5];

V = [0.842, 0.911, 0.986, 1.062, 1.143, 1.227, 1.314, 1.401, 1.482, ...
     1.551, 1.216, 1.048, 0.866, 0.689, 0.521, 0.364, 0.223, 0.103, ...
     0.012, -0.041, -0.057, -0.034, 0.018, 0.096, 0.197, 0.318, 0.452, ...
     0.579, 0.700, 0.809, 0.611, 0.688, 0.756, 0.811, 0.856, 0.894, ...
     0.926, 0.954, 0.980, 1.004];

Z = [182.4, 178.9, 175.1, 171.0, 166.8, 162.7, 158.9, 155.4, 152.0, ...
     149.0, 146.1, 145.2, 145.8, 147.3, 149.9, 153.5, 158.0, 163.2, ...
     168.9, 174.8, 180.5, 186.2, 191.5, 196.2, 200.1, 203.1, 205.2, ...
     206.3, 206.1, 204.7, 198.0, 194.4, 190.9, 187.8, 185.1, 183.0, ...
     181.6, 180.8, 180.6, 180.9];

f_eval = [41.0, 73.0]; % Frecuencias que se requieren estimar

fprintf('--- RESULTADOS DE INTERPOLACIÓN ---\n\n');

% Iniciamos con la interpolacion de Lagrange
fprintf('--- Metodo de Lagrange ---\n');

% Buscamos los indices mas cercanos a las frecuencias a estimar
for i = 1:length(f_eval)
    fe = f_eval(i);
    
    [~, idx_sorted] = sort(abs(f - fe));
    idx = sort(idx_sorted(1:3));

    % Guardamos los valores extraidos
    f_loc = f(idx); V_loc = V(idx); Z_loc = Z(idx);
    
    % Método de Lagrange para V y Z
    L1 = ((fe - f_loc(2))*(fe - f_loc(3))) / ((f_loc(1) - f_loc(2))*(f_loc(1) - f_loc(3)));
    L2 = ((fe - f_loc(1))*(fe - f_loc(3))) / ((f_loc(2) - f_loc(1))*(f_loc(2) - f_loc(3)));
    L3 = ((fe - f_loc(1))*(fe - f_loc(2))) / ((f_loc(3) - f_loc(1))*(f_loc(3) - f_loc(2)));
    
    V_lagrange = V_loc(1)*L1 + V_loc(2)*L2 + V_loc(3)*L3;
    Z_lagrange = Z_loc(1)*L1 + Z_loc(2)*L2 + Z_loc(3)*L3;
    
    fprintf('Frecuencia: %.1f kHz\n', fe);
    fprintf('  Nodos usados: [%.1f, %.1f, %.1f] kHz\n', f_loc(1), f_loc(2), f_loc(3));
    fprintf('  V  = %.4f V\n', V_lagrange);
    fprintf('  |Z| = %.4f Ohmios\n\n', Z_lagrange);
end

% Interpolación mediante Spline Cúbico
fprintf('--- Spline Cúbico ---\n');
V_spline = spline(f, V, f_eval);
Z_spline = spline(f, Z, f_eval);

for i = 1:length(f_eval)
    fprintf('Frecuencia: %.1f kHz\n', f_eval(i));
    fprintf('  V  = %.4f V\n', V_spline(i));
    fprintf('  |Z| = %.4f Ohmios\n\n', Z_spline(i));
end