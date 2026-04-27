import math

def f(x, expresion):
    """Evalúa la expresión matemática ingresada por el usuario."""
    # Permite usar funciones matemáticas comunes como cos, sin, exp, etc.
    return eval(expresion, {"x": x, "math": math, "cos": math.cos, "sin": math.sin, "exp": math.exp, "tan": math.tan, "log": math.log})

def metodo_biseccion():
    print("--- MÉTODO DE BISECCIÓN ---")
    
    # Entradas solicitadas
    ecuacion = input("Ingrese la función f(x): ")
    a = float(input("Ingrese el punto inicial (a): "))
    b = float(input("Ingrese el punto final (b): "))
    tolerancia = 1e-6  # Solicitado: 10^-6
    
    # 1. Validación inicial (Diagrama de flujo)
    fa = f(a, ecuacion)
    fb = f(b, ecuacion)
    
    if fa * fb > 0:
        print("\nERROR: La función no cambia de signo en el intervalo dado.")
        print(f"f(a) = {fa:.6f}, f(b) = {fb:.6f}")
        return

    print(f"\n{'Iter':<5} | {'a':<10} | {'b':<10} | {'m (Raíz)':<10} | {'f(m)':<12}")
    print("-" * 60)

    iteracion = 0
    m_anterior = a
    
    while True:
        iteracion += 1
        m = (a + b) / 2
        fm = f(m, ecuacion)
        
        print(f"{iteracion:<5} | {a:<10.6f} | {b:<10.6f} | {m:<10.6f} | {fm:<12.6e}")
        
        # Si f(m) es exacto, si el intervalo es muy pequeño o |f(m)| < tolerancia
        if abs(fm) < tolerancia or (b - a) < tolerancia:
            break
        
        # 3. Cambio de subintervalo (Diagrama de flujo)
        if fa * fm < 0:
            b = m
            fb = fm
        else:
            a = m
            fa = fm
            
    # Respuesta final
    print("-" * 60)
    print(f"RESULTADOS FINALES:")
    print(f"Número de iteraciones: {iteracion}")
    print(f"Raíz obtenida: {m:.8f}")
    print(f"Error final |f(m)|: {abs(fm):.2e}")

if __name__ == "__main__":
    metodo_biseccion()
    