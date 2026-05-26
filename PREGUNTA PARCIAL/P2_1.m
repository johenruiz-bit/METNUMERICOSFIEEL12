% ============================
% PARTE 2: Derivación Numérica
% ============================

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

h = 2.5; % Paso constante de frecuencia

fprintf('--- DIFERENCIAS CENTRADAS ---\n');
f_centr = [40.0, 70.0, 100.0];

for i = 1:length(f_centr)
    idx = find(f == f_centr(i)); 
    
    % Diferencia Centrada orden 2: f'(x) = [f(x+h) - f(x-h)] / 2h
    dV_O2 = (V(idx+1) - V(idx-1)) / (2*h);
    
    % Diferencia Centrada orden 4: f'(x) = [-f(x+2h) + 8f(x+h) - 8f(x-h) +
    % f(x-2h)] / 12h (si se disponen de los puntos necesarios)
    dV_O4 = (-V(idx+2) + 8*V(idx+1) - 8*V(idx-1) + V(idx-2)) / (12*h);
    
    fprintf('Frecuencia: %5.1f kHz\n', f_centr(i));
    fprintf('Orden 2 = %8.4f V/kHz\n', dV_O2);
    fprintf('Orden 4 = %8.4f V/kHz\n\n', dV_O4);
end

fprintf('--- DIFERENCIA PROGRESIVA ---\n');
f_inf = 10.0;
idx = find(f == f_inf);

% Diferencia Progresiva orden 2: f'(x) = [-3f(x) + 4f(x+h) - f(x+2h)] / 2h
dV_fwd2 = (-3*V(idx) + 4*V(idx+1) - V(idx+2)) / (2*h);
fprintf('Frecuencia: %5.1f kHz\n', f_inf);
fprintf('Progresiva orden 2 = %8.4f V/kHz\n\n', dV_fwd2);

fprintf('--- 3. DERIVACIÓN MEDIANTE SPLINE CÚBICO ---\n');
pp_V = spline(f, V);
[breaks, coefs, ~, ~, ~] = unmkpp(pp_V);
% Derivada matemática exacta del polinomio
pp_V_d1 = mkpp(breaks, [3*coefs(:,1), 2*coefs(:,2), coefs(:,3)]);

f_eval_d1 = [10.0, 40.0, 70.0, 100.0];
dV_spline = ppval(pp_V_d1, f_eval_d1);

for i = 1:length(f_eval_d1)
    fprintf('Frecuencia: %5.1f kHz = %8.4f V/kHz\n', f_eval_d1(i), dV_spline(i));
end