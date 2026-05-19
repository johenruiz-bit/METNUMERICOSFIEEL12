% =========================================================================
% PARTE 3: Búsqueda de raíces por bisección
% =========================================================================

% Definimos nuestra función continua usando el spline de la Parte 1
V_func = @(x) interp1(t, V, x, 'spline');

% Intervalo inicial identificado en la tabla
a = 7.0;
b = 7.5;
tol = 1e-3; % Tolerancia solicitada (ms)
iter = 0;
max_iter = 100; % Medida de seguridad

fprintf('\n--- Resultados de Búsqueda de Raíz (Bisección) ---\n');
fprintf('Iter\t a\t\t b\t\t c (Raíz est.)\t V(c)\n');

while (b - a)/2 > tol && iter < max_iter
    iter = iter + 1;
    c = (a + b) / 2; % Punto medio
    Vc = V_func(c);  % Evaluamos el voltaje en c usando el spline
    
    fprintf('%d\t %.5f\t %.5f\t %.5f\t\t %.5f\n', iter, a, b, c, Vc);
    
    % Verificamos el cambio de signo
    if V_func(a) * Vc < 0
        b = c; % La raíz está en la mitad izquierda
    else
        a = c; % La raíz está en la mitad derecha
    end
end

raiz_final = (a + b) / 2;
fprintf('\n>> Raíz estimada con tolerancia de %g ms: t = %.4f ms\n', tol, raiz_final);
fprintf('-------------------------------------------\n');