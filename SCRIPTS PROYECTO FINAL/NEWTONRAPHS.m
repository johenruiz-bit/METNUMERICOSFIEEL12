% ==========================================
% RAÍCES DE ECUACIONES USANDO NEWTON-RAPHSON
% ==========================================
clear; clc; close all;

% SELECCIÓN Y LECTURA DEL ARCHIVO EXCEL
[archivo, ruta] = uigetfile({'*.xlsx;*.xls;*.csv', 'Archivos de Datos (*.xlsx, *.xls, *.csv)'}, ...
                             'Seleccione el archivo de capturas del Arduino');
if isequal(archivo, 0)
    disp('Selección cancelada. Ejecute el script nuevamente.');
    return;
end

ruta_completa = fullfile(ruta, archivo);
fprintf('Cargando datos desde: %s\n', archivo);

datos = readtable(ruta_completa);
t_medido = table2array(datos(:, 1));    % Columna 1: Tiempo (us)
vin_medido = table2array(datos(:, 2));  % Columna 2: Vin (V)

% CREACIÓN DEL POLINOMIO SPLINE Y SU DERIVADA EXACTA
% Generamos la estructura del polinomio a tramos
pp_vin = spline(t_medido, vin_medido);

% Extraemos los coeficientes matemáticos para derivar analíticamente
[breaks, coefs, tramos, orden, dim] = unmkpp(pp_vin);

% Derivada de un polinomio cúbico: d/dt (at^3 + bt^2 + ct + d) = 3at^2 + 2bt + c
coefs_derivada = [3*coefs(:,1), 2*coefs(:,2), coefs(:,3)];

% Reconstrucción del polinomio derivado
pp_derivada = mkpp(breaks, coefs_derivada);

% MÉTODO DE NEWTON-RAPHSON
fprintf('\n--- MÉTODO DE NEWTON-RAPHSON ---\n');
t_inicial = input('Ingrese un tiempo estimado inicial: ');

tol = 1e-6;         % Tolerancia de error de 1 microsegundo
max_iter = 20;      % Máximo de iteraciones de seguridad
t_actual = t_inicial;
error_aprox = 100;
iter = 0;

fprintf('\nIter | Tiempo t (us) | Voltaje Vin (V) | Error Estimado\n');
fprintf('----------------------------------------------------------\n');

while error_aprox > tol && iter < max_iter
    % Evaluación de la función objetivo: f(t) = Vin_Spline(t) - 2.5
    f_t = ppval(pp_vin, t_actual) - 2.5;
    
    % Evaluación de la derivada exacta
    df_t = ppval(pp_derivada, t_actual);
    
    t_siguiente = t_actual - (f_t / df_t);
    
    % Cálculo del error y actualización
    error_aprox = abs(t_siguiente - t_actual);
    t_actual = t_siguiente;
    iter = iter + 1;
    
    % Imprimimos la evolución iterativa
    voltaje_actual = ppval(pp_vin, t_actual);
    fprintf('%4d | %13.4f | %15.4f | %14.6f\n', iter, t_actual, voltaje_actual, error_aprox);
end

% RESULTADOS Y GRÁFICA
fprintf('\n=== RESULTADO FINAL ===\n');
fprintf('El cruce exacto por 2.5000 V ocurre en t = %.4f us\n', t_actual);
fprintf('Iteraciones requeridas: %d\n', iter);
fprintf('=======================\n');

% Gráfica 
t_fino = linspace(min(t_medido), max(t_medido), 2000);
vin_fino = ppval(pp_vin, t_fino);

figure('Name', 'Método de Newton-Raphson para búsqueda de raices', 'Color', 'w');
plot(t_fino, vin_fino, 'b-', 'LineWidth', 1.2); hold on;
yline(2.5, 'g--', 'Umbral Cero Eléctrico (2.5 V)', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
plot(t_medido, vin_medido, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
plot(t_actual, ppval(pp_vin, t_actual), 'ro','MarkerFaceColor', 'r', 'MarkerSize', 6, 'LineWidth', 2);

title('Detección del Cruce por cero');
xlabel('Tiempo (\mu s)', 'FontWeight', 'bold');
ylabel('Voltaje Vin (V)', 'FontWeight', 'bold');
legend('Onda Interpolada', 'Offset 2.5V', 'Muestras capturadas', 'Raíz hallada', 'Location', 'best');
grid on;
set(gca, 'FontSize', 11);

% Zoom a la zona de la raíz hallada
xlim([t_actual - 2500, t_actual + 2500]);
ylim([1.5, 3.5]);