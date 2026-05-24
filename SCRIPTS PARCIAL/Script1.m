% ===============================
% PARTE A: Análisis exploratorio
% ===============================

% Datos
% Frecuencia f (Hz)
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];

% Magnitud de la impedancia |Z| (Ohmios)
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

% Gráfico
figure;
plot(f, Z, '-o', 'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
grid on; 
title('Magnitud de Impedancia vs. Frecuencia');
xlabel('Frecuencia de excitación f (Hz)');
ylabel('Magnitud de Impedancia |Z| (\Omega)');
