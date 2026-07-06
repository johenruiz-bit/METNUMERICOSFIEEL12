% ====================================================
% Cálculo del Voltaje Eficaz (VRMS) usando Simpson 1/3
% ====================================================
clear; clc; close all;

% SELECCIÓN Y LECTURA DEL ARCHIVO EXCEL
[archivo, ruta] = uigetfile({'*.xlsx;*.xls;*.csv', 'Archivos de Datos'}, ...
                             'Seleccione el archivo de capturas del Arduino');
if isequal(archivo, 0)
    disp('Selección cancelada.');
    return;
end

ruta_completa = fullfile(ruta, archivo);
fprintf('Cargando datos desde: %s\n', archivo);
datos = readtable(ruta_completa);
t_medido = table2array(datos(:, 1));    % Columna 1: Tiempo (us)
vin_medido = table2array(datos(:, 2));  % Columna 2: Vin (V)

% CONFIGURACIÓN DEL PERIODO ELÉCTRICO Y VENTANA DE INTEGRACIÓN
% Frecuencia estándar de la red = 60 Hz -> Periodo T = 1/60 s
frecuencia = 60;
T_us = (1 / frecuencia) * 1e6; 

% Definimos la ventana de integración para abarcar exactamente 1 ciclo
t_inicial = t_medido(1); 
t_final = t_inicial + T_us;

% REMUESTREO UNIFORME Y EXTRACCIÓN DE LA SEÑAL
% La Regla de Simpson 1/3 exige un número par de intervalos (N puntos impar)
% y que el paso temporal (h) sea perfectamente constante.
n_puntos = 101; 
h = (t_final - t_inicial) / (n_puntos - 1); % Paso de integración constante
t_uniforme = linspace(t_inicial, t_final, n_puntos);

% Generamos el Spline con los datos reales y evaluamos en los puntos uniformes
pp_vin = spline(t_medido, vin_medido);

% Restamos el offset DC del circuito (2.5 V) para centrar la onda alterna en cero
vin_centrado = ppval(pp_vin, t_uniforme) - 2.5;

% La función a integrar para el RMS es el voltaje al cuadrado
f_t = vin_centrado.^2;

% REGLA DE SIMPSON 1/3
% Fórmula base: (h/3) * [f(x0) + 4*f(x1) + 2*f(x2) + ... + 4*f(xn-1) + f(xn)]

suma_impares = sum(f_t(2:2:end-1)); 
suma_pares = sum(f_t(3:2:end-2));   

% Calculamos la integral (área bajo la curva cuadrada)
integral_area = (h / 3) * (f_t(1) + 4 * suma_impares + 2 * suma_pares + f_t(end));

% Cálculo matemático final del VRMS
V_rms = sqrt((1 / T_us) * integral_area);

% RESULTADOS Y GRÁFICAS
fprintf('\n--- RESULTADOS DE LA INTEGRACIÓN (SIMPSON 1/3) ---\n');
fprintf('Frecuencia de red : %d Hz\n', frecuencia);
fprintf('Periodo integrado : %.2f us\n', T_us);
fprintf('Paso (h) uniforme : %.2f us\n', h);
fprintf('Area bajo f(t)^2  : %.4f V^2*us\n', integral_area);
fprintf('-> VOLTAJE VRMS   : %.4f V\n', V_rms);
fprintf('--------------------------------------------------\n');

% --- VENTANA 1: ONDA CENTRADA ---
figure('Name', 'Voltaje Centrado (Vin - Offset)', 'Color', 'w');
plot(t_uniforme, vin_centrado, 'b-', 'LineWidth', 1.5); hold on;
yline(0, 'k--', 'LineWidth', 1);
title('Onda de Voltaje Centrada (Un Ciclo)');
xlabel('Tiempo (\mu s)', 'FontWeight', 'bold');
ylabel('Voltaje (V)', 'FontWeight', 'bold');
grid on; set(gca, 'FontSize', 11);

% --- VENTANA 2: ÁREA DE INTEGRACIÓN ---
figure('Name', 'Integración Numérica - Área V(t)^2', 'Color', 'w');
fill([t_uniforme, fliplr(t_uniforme)], [f_t, zeros(1, length(f_t))], 'y', 'FaceAlpha', 0.5); hold on;
plot(t_uniforme, f_t, 'r-', 'LineWidth', 1.5);
title('Área Integrada mediante Simpson 1/3');
xlabel('Tiempo (\mu s)', 'FontWeight', 'bold');
ylabel('Voltaje^2 (V^2)', 'FontWeight', 'bold');
grid on; set(gca, 'FontSize', 11);