% ===============================================
% PARTE 3: Raíces por cambio de signo y bisección
% ===============================================

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

fprintf('--- IDENTIFICACIÓN DE INTERVALOS ---\n');

% 1. Preasignamos memoria asumiendo el peor caso (que todos sean cruces)
cambios_idx = zeros(1, length(V)-1); 
contador = 0; % Creamos un contador de cruces

for i = 1:(length(V)-1)
    if V(i) * V(i+1) < 0
        contador = contador + 1;
        cambios_idx(contador) = i; % Reemplazamos el cero por el índice real
        fprintf('Cambio de signo detectado entre %5.1f kHz y %5.1f kHz\n', f(i), f(i+1));
    end
end

% Quitamos los ceros que no usamos
cambios_idx = cambios_idx(1:contador);
% Definimos la función continua usando el Spline Cúbico para poder evaluarla
V_spline = @(x) spline(f, V, x);

fprintf('\n--- MÉTODO DE BISECCIÓN ---\n');
tol = 1e-6; % Tolerancia de error
raices_biseccion = zeros(1, length(cambios_idx));

for k = 1:length(cambios_idx)
    a = f(cambios_idx(k));
    b = f(cambios_idx(k)+1);
    iter = 0;
    
    while (b - a) / 2 > tol
        c = (a + b) / 2;
        if V_spline(c) == 0
            break;
        elseif V_spline(a) * V_spline(c) < 0
            b = c;
        else
            a = c;
        end
        iter = iter + 1;
    end
    raices_biseccion(k) = (a + b) / 2;
    fprintf('Raíz %d : %8.4f kHz (Iteraciones: %d)\n', k, raices_biseccion(k), iter);
end

fprintf('\n--- REFINAMIENTO CON SPLINE ---\n');
% Comparamos con el algoritmo fzero (este algoritmo combina 3 metodos haciendo rápida la obtencion de las raices)
for k = 1:length(cambios_idx)
    x0 = [f(cambios_idx(k)), f(cambios_idx(k)+1)];
    raiz_refinada = fzero(V_spline, x0);
    fprintf('Raíz %d (Refinada):  %8.4f kHz\n', k, raiz_refinada);
end

% Gráfica para visualizar las raíces

f_fina = linspace(min(f), max(f), 1000);
V_fina = spline(f, V, f_fina);

figure('Color', [1 1 1]);
plot(f_fina, V_fina, 'b-', 'LineWidth', 2, 'DisplayName', 'Spline cúbico'); hold on;
plot(f, V, 'ko', 'MarkerFaceColor', [0.3 0.3 0.3], 'DisplayName', 'Datos Medidos');

% Línea del umbral cero
yline(0, 'r--', 'LineWidth', 1.5, 'Color', [0.8 0 0], 'DisplayName', 'Umbral Cero');

% Destacar las raíces halladas
plot(raices_biseccion, zeros(1, length(raices_biseccion)), 'ro', ...
    'MarkerSize', 8, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'DisplayName', 'Raíces Calculadas');
grid on;
title('Cruce por Cero del Voltaje de Salida V(f)', 'FontSize', 12);
xlabel('Frecuencia f (kHz)', 'FontSize', 11);
ylabel('Voltaje V (V)', 'FontSize', 11);
legend('Location', 'NorthEast');