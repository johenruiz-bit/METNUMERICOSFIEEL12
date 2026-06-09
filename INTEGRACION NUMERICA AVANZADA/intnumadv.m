clear; clc;

disp('===================================');
disp('CALCULADORA DE INTEGRACIÓN NUMÉRICA');
disp('===================================');

% Bucle interactivo para ingresar funciones sin modificar el script
while true
    syms x t;
    
    % Ingreso desde Pantalla
    func_str = input('\nIngrese la función f(x) a integrar (o "salir" para terminar): ', 's');
    
    if isempty(func_str) || strcmpi(func_str, 'salir')
        disp('Finalizando programa...');
        break;
    end
    
    % Transformación del texto a función simbólica y evaluable
    f_sym = str2sym(func_str);
    f = matlabFunction(f_sym);

    a = input('Límite inferior a: ');
    b = input('Límite superior b: ');

    % Valor analítico exacto para el cálculo del error absoluto
    I_exact = double(int(f_sym, x, a, b));

    % 2. Detección polinómica para Gauss-Legendre
    try
        p_deg = polynomialDegree(f_sym, x);
        % Por el teorema de grado máximo, calcula el n óptimo
        n_gauss = ceil((double(p_deg) + 1) / 2);
        fprintf('[+] Función polinómica (Grado %d). Nodos óptimos calculados: n=%d\n', p_deg, n_gauss);
    catch
        % Captura el error de funciones trigonométricas/exponenciales
        n_gauss = 5; 
        fprintf('[+] Función no polinómica. Nodos óptimos asignados: n=5\n');
    end

    % Métodos de Newton-Cotes (N = 12 subintervalos)
    N = 12;
    h = (b - a) / N;
    x_nc = a:h:b;
    y_nc = f(x_nc);
    puntos_nc = N + 1; % Total de 13 puntos de evaluación

    % Regla del Trapecio Compuesta
    S_trap = y_nc(1) + y_nc(end);
    for i = 2:(puntos_nc - 1)
        S_trap = S_trap + 2 * y_nc(i);
    end
    I_trap = (h / 2) * S_trap;

    % Regla de Simpson 1/3 Compuesta
    S_simp13 = y_nc(1) + y_nc(end);
    for i = 2:(puntos_nc - 1)
        if mod(i-1, 2) ~= 0 
            S_simp13 = S_simp13 + 4 * y_nc(i);
        else
            S_simp13 = S_simp13 + 2 * y_nc(i);
        end
    end
    I_simp13 = (h / 3) * S_simp13;

    % Regla de Simpson 3/8 Compuesta
    S_simp38 = y_nc(1) + y_nc(end);
    for i = 2:(puntos_nc - 1)
        if mod(i-1, 3) == 0
            S_simp38 = S_simp38 + 2 * y_nc(i);
        else
            S_simp38 = S_simp38 + 3 * y_nc(i);
        end
    end
    I_simp38 = (3 * h / 8) * S_simp38;

    % Cuadratura de Gauss-Legendre (Cálculo Algorítmico)
    % Se genera el polinomio de Legendre de grado 'n_gauss'
    P_n = legendreP(n_gauss, t);
    dP_n = diff(P_n, t); % Derivada para la fórmula de pesos

    % Cálculo algorítmico de raíces (nodos estándar t_i)
    coefs = sym2poly(P_n);
    t_nodes = sort(roots(coefs));

    % Cálculo algorítmico de pesos (w_i)
    dP_eval = double(subs(dP_n, t, t_nodes));
    w_nodes = 2 ./ ((1 - t_nodes.^2) .* dP_eval.^2);

    % Mapeo del dominio estándar [-1, 1] al dominio físico [a, b]
    x_mapped = ((b - a)/2) * t_nodes + ((b + a)/2);
    I_gauss = ((b - a)/2) * sum(w_nodes .* f(x_mapped));
    puntos_gauss = n_gauss;

    % Impresión de la Tabla de Resultados
    fprintf('\n%-25s | %-11s | %-14s | %-14s\n', 'Método', 'Puntos F(x)', 'Aproximación', 'Error Absoluto');
    fprintf('-----------------------------------------------------------------------\n');
    fprintf('%-25s | %11d | %14.6f | %e\n', 'Trapecio Compuesto', puntos_nc, I_trap, abs(I_exact - I_trap));
    fprintf('%-25s | %11d | %14.6f | %e\n', 'Simpson 1/3 Compuesto', puntos_nc, I_simp13, abs(I_exact - I_simp13));
    fprintf('%-25s | %11d | %14.6f | %e\n', 'Simpson 3/8 Compuesto', puntos_nc, I_simp38, abs(I_exact - I_simp38));
    fprintf('%-25s | %11d | %14.6f | %e\n', 'Gauss-Legendre', puntos_gauss, I_gauss, abs(I_exact - I_gauss));
    fprintf('-----------------------------------------------------------------------\n');
end
