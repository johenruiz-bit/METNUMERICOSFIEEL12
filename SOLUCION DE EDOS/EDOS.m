% =========================================================================
% SIMULACIÓN ESTRUCTURAL: OSCILADOR DE VAN DER POL (MÉTODO RK4)
% =========================================================================

% PARÁMETROS DEL SISTEMA
mu = 1.5;           % Coeficiente de amortiguamiento no lineal
h = 0.05;           % Tamaño de paso temporal (s)
t = 0:h:20;         % Vector de tiempo de 0 a 20 s
N = length(t);      % Número total de iteraciones

% VECTORES DE ESTADO
y1 = zeros(1, N);   % desplazamiento x(t)
y2 = zeros(1, N);   % velocidad v(t)

% CONDICIONES INICIALES 
y1(1) = 2.0;        % Desplazamiento inicial máximo
y2(1) = 0.0;        % Reposo instantáneo (velocidad cero)

% DEFINICIÓN DEL SISTEMA (EDO DE 1ER ORDEN)
% Ecuación 1: dy1/dt = y2
f1 = @(t, y1, y2) y2;
% Ecuación 2: dy2/dt = mu*(1 - y1^2)*y2 - y1 (Aceleración)
f2 = @(t, y1, y2) mu * (1 - y1^2) * y2 - y1;

% RK4
for i = 1:(N-1)
    % Pendientes k1 
    k1_y1 = f1(t(i), y1(i), y2(i));
    k1_y2 = f2(t(i), y1(i), y2(i));
    
    % Pendientes k2 
    k2_y1 = f1(t(i) + h/2, y1(i) + (h/2)*k1_y1, y2(i) + (h/2)*k1_y2);
    k2_y2 = f2(t(i) + h/2, y1(i) + (h/2)*k1_y1, y2(i) + (h/2)*k1_y2);
    
    % Pendientes k3 
    k3_y1 = f1(t(i) + h/2, y1(i) + (h/2)*k2_y1, y2(i) + (h/2)*k2_y2);
    k3_y2 = f2(t(i) + h/2, y1(i) + (h/2)*k2_y1, y2(i) + (h/2)*k2_y2);
    
    % Pendientes k4 
    k4_y1 = f1(t(i) + h, y1(i) + h*k3_y1, y2(i) + h*k3_y2);
    k4_y2 = f2(t(i) + h, y1(i) + h*k3_y1, y2(i) + h*k3_y2);
    
    % Promedio ponderado y actualización del estado
    y1(i+1) = y1(i) + (h/6) * (k1_y1 + 2*k2_y1 + 2*k3_y1 + k4_y1);
    y2(i+1) = y2(i) + (h/6) * (k1_y2 + 2*k2_y2 + 2*k3_y2 + k4_y2);
end

% DATOS EN CONSOLA
fprintf('%-12s %-12s %-18s %-15s\n', 'Iteración', 'Tiempo(s)', 'Desplazamiento', 'Velocidad');
fprintf('--------------------------------------------------------------\n');

for i = 1:11 
    fprintf('%-12d %-12.2f %-18.4f %-15.4f\n', i-1, t(i), y1(i), y2(i));
end

fprintf('\nESTADO FINAL (t = %.2f s):\n', t(end));
fprintf('Desplazamiento: %.4f m\n', y1(end));
fprintf('Velocidad: %.4f m/s\n\n', y2(end));

% GRÁFICAS
% Evolución temporal
figure(1);
plot(t, y1, 'b', 'LineWidth', 1.5); hold on;
plot(t, y2, 'r', 'LineWidth', 1.5);
grid on;
title('Evolución Temporal');
xlabel('Tiempo t (s)');
ylabel('Amplitud');
legend('Desplazamiento x(t)', 'Velocidad v(t)', 'Location', 'best');

% Diagrama de espacio de fases
figure(2);
plot(y1, y2, 'k', 'LineWidth', 1.5);
grid on;
title('Diagrama de Espacio de Fases');
xlabel('Desplazamiento x(t)');
ylabel('Velocidad v(t)');