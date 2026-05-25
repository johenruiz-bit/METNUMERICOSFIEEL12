% ============================================
% PARTE B1: Polinomios Escalonados de Lagrange 
% ============================================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

f_plot = linspace(min(f), max(f), 1000); % Malla fina

% 2. Configuración de los Grados a evaluar
grados = [5, 10, 15];
colores = {'r', 'b', 'k'}; 
nombres = {'Grado 5', 'Grado 10', 'Grado 15'};

for k = 1:length(grados)
    g = grados(k);
    num_puntos = g + 1; % n+1 puntos para un grado n
    
    % Muestreo uniforme de índices distribuidos en todo el dominio
    idx = round(linspace(1, 30, num_puntos)); % Redondeamos los vectores al entero mas cercano
    f_sub = f(idx);
    Z_sub = Z(idx);
    
    % Método de Lagrange
    Z_interp = zeros(1, length(f_plot));
    for i = 1:num_puntos
        L_i = ones(1, length(f_plot));
        for j = 1:num_puntos
            if i ~= j
                L_i = L_i .* (f_plot - f_sub(j)) / (f_sub(i) - f_sub(j)); 
            end
        end
        Z_interp = Z_interp + Z_sub(i) * L_i; 
    end
    
    figure(k); % Abre la ventana número k (Figura 1, 2 y 3)
    
    plot(f, Z, 'o', 'Color', [0.6 0.6 0.6], 'MarkerFaceColor', [0.8 0.8 0.8], 'MarkerSize', 5, 'DisplayName', 'Datos Medidos'); 
    hold on;
    
    % Nodos específicos seleccionados para este polinomio
    plot(f_sub, Z_sub, 'o', 'MarkerFaceColor', colores{k}, 'Color', colores{k}, 'MarkerSize', 7, 'DisplayName', 'Nodos de Interpolación');
    
    % Curva interpolada suave
    plot(f_plot, Z_interp, '-', 'LineWidth', 1.8, 'Color', colores{k}, 'DisplayName', nombres{k});
    
    title(sprintf('Interpolación de Lagrange: %s', nombres{k}), 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('Frecuencia de excitación {\it f} (Hz)', 'FontSize', 11);
    ylabel('Magnitud de Impedancia |Z| (\Omega)', 'FontSize', 11);
    legend('Location', 'northeast', 'FontSize', 10);
    ylim([125 165]); 
    grid on; 
    hold off;
end
