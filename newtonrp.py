import math

def f(x, expresion):
    """Evalúa la función f(x) ingresada como string."""
    return eval(expresion, {"x": x, "math": math, "cos": math.cos, "sin": math.sin, "exp": math.exp, "tan": math.tan, "log": math.log})

def derivada(x, expresion, h=1e-8):
    """Calcula la derivada numérica f'(x) usando diferencias finitas."""
    return (f(x + h, expresion) - f(x, expresion)) / h

def metodo_newton_raphson():
    print("--- MÉTODO DE NEWTON-RAPHSON ---")
    
    # Entradas solicitadas
    ecuacion = input("Ingrese la función f(x): ")
    x0 = float(input("Ingrese el punto semilla (x0): "))
    tolerancia = 1e-6  # Solicitado: 10^-6
    max_iter = 100     # Límite de seguridad para evitar bucles infinitos
    
    print(f"\n{'Iter':<5} | {'xi':<12} | {'f(xi)':<12} | {'Error':<12}")
    print("-" * 50)
    
    xi = x0
    for iteracion in range(1, max_iter + 1):
        f_xi = f(xi, ecuacion)
        df_xi = derivada(xi, ecuacion)
        
        # Validar que la derivada no sea cero para evitar división por cero
        if abs(df_xi) < 1e-12:
            print("ERROR: La derivada es cercana a cero. El método no puede continuar.")
            break
            
        # Fórmula de Newton-Raphson: xi+1 = xi - f(xi)/f'(xi)
        xi_siguiente = xi - (f_xi / df_xi)
        
        # Cálculo del error (diferencia entre aproximaciones)
        error = abs(xi_siguiente - xi)
        
        print(f"{iteracion:<5} | {xi:<12.8f} | {f_xi:<12.2e} | {error:<12.2e}")
        
        # Condición de parada (Tolerancia)
        if error < tolerancia or abs(f(xi_siguiente, ecuacion)) < tolerancia:
            xi = xi_siguiente
            print("-" * 50)
            print(f"RESULTADOS FINALES:")
            print(f"Número de iteraciones: {iteracion}")
            print(f"Raíz obtenida: {xi:.8f}")
            print(f"Error final: {abs(f(xi, ecuacion)):.2e}")
            return
        
        xi = xi_siguiente

    print("Se alcanzó el número máximo de iteraciones sin converger.")

if __name__ == "__main__":
    metodo_newton_raphson()
    