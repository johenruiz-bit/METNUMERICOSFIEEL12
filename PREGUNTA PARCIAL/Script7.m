% ===========================
% PARTE D: BÚSQUEDA DE RAÍCES
% ===========================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

Z_th = 150; % Umbral crítico

% Spline y derivada
pp = spline(f, Z);
[breaks, coefs, ~, ~, ~] = unmkpp(pp);
pp_d1 = mkpp(breaks, [3*coefs(:,1), 2*coefs(:,2), coefs(:,3)]); 

% Funciones anónimas
% g(x): Ecuación objetivo. El operador @(x) crea una función evaluable en 'x'.
% Toma el modelo Spline (pp), lo evalúa en la frecuencia 'x', y le resta 
% el umbral crítico (Z_th). Los algoritmos buscarán dónde esto se hace cero.
g = @(x) ppval(pp, x) - Z_th;
% dg(x): Derivada analítica exacta evaluable. 
% Toma el modelo derivado (pp_d1) y lo evalúa en 'x'. Esta función alimenta 
% al método de Newton-Raphson entregándole la pendiente exacta en cada paso.
dg = @(x) ppval(pp_d1, x);

tol = 1e-6; % Tolerancia
max_iter = 100; % Límite de seguridad para bucles

% BISECCIÓN
fprintf('--- MÉTODO DE BISECCIÓN ---\n');
intervalos = {[100, 120], [2160, 2340]}; 
raices_bis = zeros(1, 2); 

for k = 1:2
    a = intervalos{k}(1); b = intervalos{k}(2);
    iter = 0;
    while (b - a)/2 > tol && iter < max_iter
        c = (a + b)/2;
        if g(c) == 0, break; end
        if sign(g(c)) == sign(g(a)), a = c; else, b = c; end
        iter = iter + 1;
    end
    raices_bis(k) = (a + b)/2;
    fprintf('Raíz %d: %8.4f Hz | Iteraciones: %d\n', k, raices_bis(k), iter);
end

% NEWTON-RAPHSON
fprintf('\n--- MÉTODO DE NEWTON-RAPHSON ---\n');
puntos_iniciales = [110, 2200]; 
raices_nr = zeros(1, 2);

for k = 1:2
    x0 = puntos_iniciales(k);
    iter = 0;
    while iter < max_iter
        x1 = x0 - g(x0)/dg(x0);
        if abs(x1 - x0) < tol, break; end
        x0 = x1;
        iter = iter + 1;
    end
    raices_nr(k) = x1;
    fprintf('Raíz %d: %8.4f Hz | Iteraciones: %d\n', k, raices_nr(k), iter);
end

% ANÁLISIS DE SENSIBILIDAD
f_root = raices_nr(2); % Analizamos la raíz superior
dZ_df_val = dg(f_root); 
sensibilidad = 1 / dZ_df_val; 

fprintf('\n--- ANÁLISIS DE SENSIBILIDAD ---\n');
fprintf('Frecuencia Límite: %.4f Hz\n', f_root);
fprintf('Pendiente (d|Z|/df): %.5f Ohmios/Hz\n', dZ_df_val);
fprintf('Sensibilidad (df/d|Z|): %.4f Hz/Ohmio\n\n', sensibilidad);

% GRÁFICA
% Usando las raíces del Método de Newton-Raphson
f_root1 = raices_nr(1);
f_root2 = raices_nr(2);

f_plot = linspace(min(f), max(f), 1000);
Z_spline = spline(f, Z, f_plot);

figure('Name', 'Banda de Operación Segura');
hold on; 

% Umbral crítico
yline(Z_th, 'r--', 'LineWidth', 1.8, 'DisplayName', 'Umbral Crítico Z_{th} = 150 \Omega');

% Spline 
plot(f_plot, Z_spline, 'b-', 'LineWidth', 2, 'DisplayName', 'Spline Cúbico');
plot(f, Z, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'DisplayName', 'Datos');

% Raíces
plot([f_root1, f_root2], [Z_th, Z_th], 'ro', 'MarkerFaceColor', 'y', ...
     'MarkerSize', 8, 'DisplayName', 'Frecuencias Límite');

% Formato de la gráfica
title('Análisis de Umbral', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frecuencia de excitación {\it f} (Hz)', 'FontSize', 11);
ylabel('Magnitud de Impedancia |Z| (\Omega)', 'FontSize', 11);
legend('Location', 'north', 'FontSize', 10);
ylim([125 160]); 
grid on; 
hold off;
