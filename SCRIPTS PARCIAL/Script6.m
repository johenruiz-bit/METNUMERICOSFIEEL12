% ============================
% PARTE C: Derivación Numérica
% ============================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

% Construcción del Spline Original y Extracción de Coeficientes
pp = spline(f, Z);
[breaks, coefs, tramos, orden, dim] = unmkpp(pp); % unmkpp: Extrae los límites de cada tramo (breaks) 
% y la matriz de coeficientes [a, b, c, d] de los polinomios cúbicos.

% DERIVACIÓN ANALÍTICA
% Tomando como coeficientes de spline: [a, b, c, d] para ax^3 + bx^2 + cx + d
% Primera Derivada: [3a, 2b, c]
coefs_d1 = [3*coefs(:,1), 2*coefs(:,2), coefs(:,3)];
pp_d1 = mkpp(breaks, coefs_d1); % Creamos la estructura del spline derivado, mkpp: Construye un nuevo spline completamente funcional y evaluable, 
% utilizando los nodos originales pero con los coeficientes ya derivados.

% Segunda Derivada: [6a, 2b]
coefs_d2 = [6*coefs(:,1), 2*coefs(:,2)];
pp_d2 = mkpp(breaks, coefs_d2);

% Puntos y gráfica
dZ_df = ppval(pp_d1, f); % Evaluamos la primera derivada en los 30 puntos

figure('Name', 'Derivada Analítica del Spline');
plot(f, dZ_df, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
yline(0, 'k--', 'LineWidth', 1.5, 'Label', 'Cruce por cero (Mínimo de |Z|)');

% Frecuencia mínima
f_min_exacta = fzero(@(x) ppval(pp_d1, x), 800); % Buscamos cerca de los 800 Hz
dZ_min = ppval(pp_d1, f_min_exacta); % Debería ser 0
d2Z_min = ppval(pp_d2, f_min_exacta); % Evaluamos la concavidad

plot(f_min_exacta, dZ_min, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
title('Primera Derivada de la Impedancia d|Z|/df', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frecuencia f (Hz)', 'FontSize', 11);
ylabel('d|Z|/df (\Omega/Hz)', 'FontSize', 11);
grid on; hold off;

% Resultados
fprintf('\n--- RESULTADOS DEL ANÁLISIS DE EXTREMOS ---\n');
fprintf('Frecuencia del mínimo exacto: %.4f Hz\n', f_min_exacta);
fprintf('Valor de la primera derivada en ese punto: %.4e Ohmios/Hz\n', dZ_min);
fprintf('Valor de la SEGUNDA derivada en el mínimo: %.4e Ohmios/Hz^2\n\n', d2Z_min);