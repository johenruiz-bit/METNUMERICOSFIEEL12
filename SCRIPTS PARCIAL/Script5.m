% =======================
% PARTE B2: Spline Cúbico
% =======================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

f_plot = linspace(min(f), max(f), 1000);

% Aplicación del Spline Cúbico
Z_spline = spline(f, Z, f_plot);

% Gráfica
figure('Name', 'Spline Cúbico');
plot(f, Z, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6, 'DisplayName', 'Datos Medidos');
hold on;
plot(f_plot, Z_spline, 'b-', 'LineWidth', 2, 'DisplayName', 'Spline Cúbico');

title('Spline Cúbico', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frecuencia f (Hz)', 'FontSize', 11);
ylabel('Impedancia |Z| (\Omega)', 'FontSize', 11);
legend('Location', 'northeast');
grid on; hold off;

% 4. Predicción en f = 1000 Hz
f_target = 1000;
% La misma función spline evalúa puntos individuales directamente
Z_1000_spline = spline(f, Z, f_target);

fprintf('\n--- PREDICCIÓN CON SPLINE CÚBICO ---\n');
fprintf('Impedancia en %d Hz: %.4f Ohmios\n\n', f_target, Z_1000_spline);