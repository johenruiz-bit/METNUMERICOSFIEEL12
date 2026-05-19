% =========================================================================
% PARTE 1: Interpolación de señal de telemetría biomédica
% =========================================================================

% 1. Ingreso de los datos de calibración (Extraídos de la tabla)
t = 0:0.5:15; % Vector de tiempo desde 0 hasta 15 con saltos de 0.5 ms
V = [4.8120, 4.2635, 3.7541, 3.2804, 2.8387, 2.4236, 2.0314, 1.6583, ...
     1.3011, 1.2574, 1.1460, 0.8624, 0.6048, 0.3720, 0.1672, -0.0186, ...
     -0.1805, -0.3142, -0.3148, -0.2769, -0.2100, 0.0483, 0.2931, ...
     0.5185, 0.7214, 0.8982, 1.0456, 1.1618, 1.2465, 1.3001, 1.3228];

% Instantes de tiempo donde se requiere estimar el voltaje
t_est = [4.3, 8.7];

% 2. Ejecución de los métodos numéricos
% Interpolación Lineal Simple (une los puntos con líneas rectas)
V_lin = interp1(t, V, t_est, 'linear');

% Interpolación por Spline Cúbico (genera una curva suave)
% Nota de ingeniería: La función 'spline' en MATLAB por defecto usa la 
% condición de frontera "not-a-knot". Para fines prácticos y con 31 puntos, 
% el resultado es numéricamente casi idéntico al spline natural estricto.
V_spline = interp1(t, V, t_est, 'spline');

% 3. Impresión de resultados en la Command Window
fprintf('--- Resultados de Estimación de Voltaje ---\n');
fprintf('En t = 4.3 ms:\n');
fprintf('  Interpolación Lineal: %.5f V\n', V_lin(1));
fprintf('  Spline Cúbico:        %.5f V\n', V_spline(1));
fprintf('\nEn t = 8.7 ms:\n');
fprintf('  Interpolación Lineal: %.5f V\n', V_lin(2));
fprintf('  Spline Cúbico:        %.5f V\n', V_spline(2));
fprintf('-------------------------------------------\n');

% 4. Gráfica para la comparación cualitativa
% Creamos un vector de tiempo muy fino para ver las curvas continuas
t_fino = 0:0.01:15; 
V_lin_fino = interp1(t, V, t_fino, 'linear');
V_spline_fino = interp1(t, V, t_fino, 'spline');

figure('Name', 'Comparación de Métodos de Interpolación', 'Color', 'w');
plot(t, V, 'ko', 'MarkerFaceColor', 'k'); hold on; % Puntos originales
plot(t_fino, V_lin_fino, 'r--', 'LineWidth', 1.2); % Curva lineal
plot(t_fino, V_spline_fino, 'b-', 'LineWidth', 1.5); % Curva spline

% Resaltamos los puntos estimados
plot(t_est, V_spline, 'b*', 'MarkerSize', 10, 'LineWidth', 1.5); 
plot(t_est, V_lin, 'r*', 'MarkerSize', 10, 'LineWidth', 1.5);    

grid on;
xlabel('Tiempo (ms)');
ylabel('Voltaje (V)');
title('Señal del Biosensor: Spline Cúbico vs Interpolación Lineal');
legend('Datos de calibración', 'Interp. Lineal', 'Spline Cúbico', ...
       'Estimación Spline', 'Estimación Lineal', 'Location', 'best');