% =========================================================================
% PARTE 2: Derivación numérica por diferencias centradas
% =========================================================================

% Instantes donde se requiere la derivada
t_deriv = [4.0, 8.0, 12.0];
h = 0.5; % Paso de tiempo en ms

% Encontramos los índices correspondientes a esos tiempos en el vector 't'
% (Recordando que los índices en MATLAB empiezan en 1)
indices = [find(t == 4.0), find(t == 8.0), find(t == 12.0)];

% Inicializamos un vector para guardar los resultados
V_prima = zeros(1, 3);

fprintf('\n--- Resultados de Derivación Numérica ---\n');
for k = 1:length(indices)
    i = indices(k);
    % Aplicamos la fórmula de diferencias centradas
    V_prima(k) = (V(i+1) - V(i-1)) / (2*h);
    
    fprintf('V''(%.1f) = %.4f V/ms\n', t_deriv(k), V_prima(k));
end
fprintf('-------------------------------------------\n');