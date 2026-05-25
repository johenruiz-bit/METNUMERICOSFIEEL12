% =================================================
% PARTE B1: Comparativa Método matricial y lagrange
% =================================================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

n = length(f); 
f_plot = linspace(min(f), max(f), 1000); % Malla fina para gráficos

% ================
% MÉTODO MATRICIAL 
% ================
% Construimos la matriz
V = zeros(n, n);
for i = 1:n
    for j = 1:n
        V(i, j) = f(i)^(n - j); 
    end
end

coef = V\ Z'; 

Z_matricial = zeros(1, length(f_plot));
for j = 1:n
    Z_matricial = Z_matricial + coef(j) * (f_plot.^(n - j));
end

% GRÁFICA 1: Método Matricial
figure(1);
plot(f_plot, Z_matricial, 'r-', 'LineWidth', 1.5);
hold on;
plot(f, Z, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
title('Método Matricial', 'FontSize', 12);
xlabel('Frecuencia f (Hz)'); ylabel('Impedancia |Z| (\Omega)');
legend('Polinomio obtenido', 'Datos', 'Location', 'best');
grid on; hold off;

% ==========================
% CASO 2: MÉTODO DE LAGRANGE
% ==========================
% Normalizamos los datos al intervalo [-1, 1] para que la matemática fluya
f_min = min(f); f_max = max(f);
x = 2 * (f - f_min) / (f_max - f_min) - 1; 
x_plot = 2 * (f_plot - f_min) / (f_max - f_min) - 1;

Z_lagrange = zeros(1, length(x_plot));
for i = 1:n
    L_i = ones(1, length(x_plot));
    for j = 1:n
        if i ~= j
            L_i = L_i .* (x_plot - x(j)) / (x(i) - x(j)); 
        end
    end
    Z_lagrange = Z_lagrange + Z(i) * L_i; 
end

% GRÁFICA 2: Método de Lagrange
figure(2);
plot(f_plot, Z_lagrange, 'b-', 'LineWidth', 1.5);
hold on;
plot(f, Z, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
title('Método de Lagrange', 'FontSize', 12);
xlabel('Frecuencia f (Hz)'); ylabel('Impedancia |Z| (\Omega)');
legend('Polinomio de Lagrange', 'Datos', 'Location', 'northeast');
ylim([100 200]); % Recortamos para apreciar las oscilaciones sin deformar todo
grid on; hold off;
