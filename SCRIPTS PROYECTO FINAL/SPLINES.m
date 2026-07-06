% =========================
% INTERPOLACIÓN POR SPLINES
% =========================
clear; clc; close all;

% LECTURA DEL ARCHIVO EXCEL
[archivo, ruta] = uigetfile({'*.xlsx;*.xls;*.csv', 'Archivos de Datos (*.xlsx, *.xls, *.csv)'}, ...
                             'Seleccione el archivo de capturas del Arduino');

% Detener el script si no se selecciona archivo 
if isequal(archivo, 0)
    disp('Selección cancelada. Ejecute el script nuevamente.');
    return;
end

% Construye la ruta completa y lee los datos
ruta_completa = fullfile(ruta, archivo);
fprintf('Cargando datos desde: %s\n', archivo);

% Lectura de la tabla (asumimos que la fila 1 tiene los encabezados)
datos = readtable(ruta_completa);

% Extraemos los datos por índice de columna
t_medido = table2array(datos(:, 1));    % Columna 1: Tiempo (us)
vin_medido = table2array(datos(:, 2));  % Columna 2: Vin (V)
vout_medido = table2array(datos(:, 3)); % Columna 3: Vout (V)

% VALOR A INTERPOLAR
% Se solicita al usuario ingresar el tiempo que desea evaluar
fprintf('\n--- INTERPOLACIÓN CÚBICA ---\n');
t_objetivo = input('Ingrese el tiempo a interpolar (en microsegundos): ');

% Verificación de límites
if t_objetivo < min(t_medido) || t_objetivo > max(t_medido)
    warning('El tiempo ingresado está fuera del rango medido. El resultado será una extrapolación.');
end

% CÁLCULO SPLINES CÚBICOS
% Usamos interp1 con el método 'spline' para preservar la continuidad de derivadas
vin_interp = interp1(t_medido, vin_medido, t_objetivo, 'spline');
vout_interp = interp1(t_medido, vout_medido, t_objetivo, 'spline');

fprintf('\n=== RESULTADOS DE LA INTERPOLACIÓN ===\n');
fprintf('Para t = %.1f us:\n', t_objetivo);
fprintf('-> Vin  estimado = %.4f V\n', vin_interp);
fprintf('-> Vout estimado = %.4f V\n', vout_interp);
fprintf('======================================\n');

% GRÁFICA
% Se grafica una curva suave para demostrar el comportamiento del Spline
t_fino = linspace(min(t_medido), max(t_medido), 1000); % 1000 puntos para suavidad
vin_fino = interp1(t_medido, vin_medido, t_fino, 'spline');

figure('Name', 'Interpolación Spline Cúbico', 'Color', 'w');
plot(t_fino, vin_fino, 'b-', 'LineWidth', 1.2); hold on;
plot(t_medido, vin_medido, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
plot(t_objetivo, vin_interp, 'ro', 'MarkerFaceColor', 'r','MarkerSize', 6, 'LineWidth', 2);

% Formato de la gráfica
title('Reconstrucción de Señal mediante Splines');
xlabel('Tiempo (\mu s)', 'FontWeight', 'bold');
ylabel('Voltaje Vin (V)', 'FontWeight', 'bold');
legend('Curva Spline', 'Nodos Medidos (Arduino)', 'Punto Interpolado', 'Location', 'best');
grid on;
set(gca, 'FontSize', 11);