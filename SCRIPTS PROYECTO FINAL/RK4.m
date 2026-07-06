% ================================
% SOLUCIÓN DE EDOS (Runge-Kutta 4)
% ================================
clear; clc; close all;

% SELECCIÓN Y LECTURA DEL ARCHIVO
[archivo, ruta] = uigetfile({'*.xlsx;*.xls;*.csv'}, 'Seleccione el archivo');
if isequal(archivo, 0), return; end
ruta_completa = fullfile(ruta, archivo);
datos = readtable(ruta_completa);
t_medido = table2array(datos(:, 1));    
vin_medido = table2array(datos(:, 2));  
vout_medido = table2array(datos(:, 3)); 

% PARÁMETROS FÍSICOS
R = 10000;      % 10 kOhm
C = 10e-9;      % 10 nF 
tau = R * C;    

% Polinomio continuo de entrada
pp_vin = spline(t_medido, vin_medido);
f_edo = @(t, v_out) (ppval(pp_vin, t) - v_out) / (tau * 1e6);

% ESTRATEGIA DE ESTABILIDAD NUMÉRICA (MICRO-STEPPING)
h_sim = 10; % Paso virtual de 10 microsegundos
t_sim = t_medido(1) : h_sim : t_medido(end);
n_sim = length(t_sim);

vout_sim = zeros(n_sim, 1);
vout_sim(1) = vout_medido(1); 

for i = 1:(n_sim-1)
    t_i = t_sim(i);
    v_i = vout_sim(i);
    
    k1 = f_edo(t_i, v_i);
    k2 = f_edo(t_i + h_sim/2, v_i + k1*h_sim/2);
    k3 = f_edo(t_i + h_sim/2, v_i + k2*h_sim/2);
    k4 = f_edo(t_i + h_sim, v_i + k3*h_sim);
    
    vout_sim(i+1) = v_i + (h_sim/6)*(k1 + 2*k2 + 2*k3 + k4);
end

% VALIDACIÓN Y CÁLCULO DE ERROR
% Interpolación estricta en los nodos de tiempo donde se tomaron muestras
vout_modelo_nodos = interp1(t_sim, vout_sim, t_medido);
MSE = mean((vout_medido - vout_modelo_nodos).^2, 'omitnan');

fprintf('\n--- RESULTADOS DEL MODELADO (RK4) ---\n');
fprintf('Resistencia (R)   : %.1f Ohmios\n', R);
fprintf('Capacitor (C)     : %.2e Faradios\n', C);
fprintf('Constante (tau)   : %.6f s\n', tau);
fprintf('Paso simulado (h) : %.2f us\n', h_sim);
fprintf('Error Medio (MSE) : %.6f V^2\n', MSE);
fprintf('===============================================\n');

% TABLA COMPARATIVA
fprintf('\n--- VALORES REALES VS MODELADOS ---\n');
fprintf(' Nodo | Tiempo (us) | Vout Arduino (V) | Vout Modelo RK4 (V) | Error Absoluto (V) \n');
fprintf('----------------------------------------------------------------------------------\n');

% Bucle para imprimir cada fila de los datos emparejados
for i = 1:length(t_medido)
    % Evitar errores si el último punto da NaN por el salto del micro-stepping
    if isnan(vout_modelo_nodos(i))
        continue; 
    end
    
    error_abs = abs(vout_medido(i) - vout_modelo_nodos(i));
    
    fprintf(' %4d | %11.2f | %16.4f | %19.4f | %18.6f \n', ...
        i, t_medido(i), vout_medido(i), vout_modelo_nodos(i), error_abs);
end
fprintf('----------------------------------------------------------------------------------\n');

% GRÁFICA
figure('Name', 'Modelado EDO Filtro RC', 'Color', 'w');
plot(t_sim, vout_sim, 'r-', 'LineWidth', 1.5); hold on;
plot(t_medido, vout_medido, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
title('Validación del Modelo Dinámico del Filtro');
xlabel('Tiempo (\mu s)', 'FontWeight', 'bold');
ylabel('Voltaje de Salida (V)', 'FontWeight', 'bold');
legend('V_{out} Modelado RK4', 'Nodos V_{out} Hardware', 'Location', 'best');
grid on; set(gca, 'FontSize', 11);