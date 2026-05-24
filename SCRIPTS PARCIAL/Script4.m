% ===========================
% Predicción y Validación LOO 
% ===========================

% Datos
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, 460, 520, 585, ...
     655, 730, 810, 895, 985, 1080, 1180, 1290, 1410, 1540, 1680, 1830, ...
     1990, 2160, 2340, 2530, 2730];
Z = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, ...
     133.6, 132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, ...
     132.7, 133.8, 135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, ...
     152.2, 155.6, 159.2];

n_total = length(f);
g = 5; 
num_puntos = g + 1; % 6 puntos para grado 5

% PREDICCIÓN EN f = 1000 Hz
% Seleccionamos 6 nodos uniformes de los 30 disponibles
idx_uni = round(linspace(1, n_total, num_puntos));
f_mod = f(idx_uni); Z_mod = Z(idx_uni);

f_target = 1000;
Z_1000 = 0;
for i = 1:num_puntos
    L_i = 1;
    for j = 1:num_puntos
        if i ~= j
            L_i = L_i * (f_target - f_mod(j)) / (f_mod(i) - f_mod(j));
        end
    end
    Z_1000 = Z_1000 + Z_mod(i) * L_i;
end
fprintf('\n--- PREDICCIÓN CON LAGRANGE (GRADO 5) ---\n');
fprintf('Impedancia en %d Hz: %.4f Ohmios\n', f_target, Z_1000);

% VALIDACIÓN LEAVE-ONE-OUT (LOO)
rng(42); % Fijamos la semilla para reproducibilidad de los resultados
idx_azar = randperm(n_total, 5); % Elegimos 5 índices aleatorios para test
errores_relativos = zeros(1, 5);

fprintf('\n--- VALIDACIÓN LEAVE-ONE-OUT (LOO) ---\n');
for k = 1:5
    idx_test = idx_azar(k);
    f_test = f(idx_test);
    Z_test_real = Z(idx_test);
    
    % 1. Extraemos el punto de prueba (creamos pool de entrenamiento con 29 pts)
    f_train = f; f_train(idx_test) = [];
    Z_train = Z; Z_train(idx_test) = [];
    
    % 2. Muestreamos 6 nodos uniformes del nuevo pool de 29 puntos
    idx_sub = round(linspace(1, 29, num_puntos));
    f_train_sub = f_train(idx_sub);
    Z_train_sub = Z_train(idx_sub);
    
    % 3. Predecimos usando Lagrange con los 6 nodos
    Z_pred = 0;
    for i = 1:num_puntos
        L_i = 1;
        for j = 1:num_puntos
            if i ~= j
                L_i = L_i * (f_test - f_train_sub(j)) / (f_train_sub(i) - f_train_sub(j));
            end
        end
        Z_pred = Z_pred + Z_train_sub(i) * L_i;
    end
    
    % 4. Calculamos y almacenamos el error
    err = abs(Z_test_real - Z_pred) / Z_test_real * 100;
    errores_relativos(k) = err;
    
    fprintf('Test %d (f = %4d Hz) -> Real: %6.2f | Pred: %6.2f | Error: %5.2f%%\n', ...
            k, f_test, Z_test_real, Z_pred, err);
end

fprintf('\n--> Error Relativo Medio Estimado (LOO): %.2f%%\n\n', mean(errores_relativos));