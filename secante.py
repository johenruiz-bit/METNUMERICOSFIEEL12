import math

def f(x, expresion):
    """Evalúa la función matemática ingresada por el usuario."""
    return eval(expresion, {"x": x, "math": math, "cos": math.cos, "sin": math.sin, "exp": math.exp, "tan": math.tan, "log": math.log})

def metodo_secante():
    print("--- MÉTODO DE LA SECANTE ---")
    
    # Entradas solicitadas
    ecuacion = input("Ingrese la función f(x): ")
    x0 = float(input("Ingrese el primer punto (x0): "))
    x1 = float(input("Ingrese el segundo punto (x1): "))
    tolerancia = 1e-6  # Solicitado: 10^-6
    
    print(f"\n{'Iter':<5} | {'xi':<12} | {'f(xi)':<12} | {'Error':<12}")
    print("-" * 55)
    
    iteracion = 0
    f0 = f(x0, ecuacion)
    
    while True:
        iteracion += 1
        f1 = f(x1, ecuacion)
        
        # Validación de división por cero (si f(x1) == f(x0))
        if (f1 - f0) == 0:
            print("ERROR: División por cero. El método no puede continuar.")
            return
        
        # Fórmula de la Secante: xi+1 = xi - f(xi) * (xi - xi-1) / (f(xi) - f(xi-1))
        x_siguiente = x1 - (f1 * (x1 - x0)) / (f1 - f0)
        
        # Error absoluto entre las dos últimas aproximaciones
        error = abs(x_siguiente - x1)
        
        print(f"{iteracion:<5} | {x1:<12.8f} | {f1:<12.2e} | {error:<12.2e}")
        
        # Condición de parada: error < tolerancia o función cercana a cero
        if error < tolerancia or abs(f(x_siguiente, ecuacion)) < tolerancia:
            print("-" * 55)
            print(f"RESULTADOS FINALES:")
            print(f"Número de iteraciones: {iteracion}")
            print(f"Raíz obtenida: {x_siguiente:.8f}")
            print(f"Error final |f(raiz)|: {abs(f(x_siguiente, ecuacion)):.2e}")
            break
            
        # Actualización de puntos para la siguiente iteración
        x0 = x1
        f0 = f1
        x1 = x_siguiente

if __name__ == "__main__":
    metodo_secante()