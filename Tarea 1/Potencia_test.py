def potencia_manual(base, potencia):
    # Verificar que los parámetros no sean strings
    if isinstance(base, str) or isinstance(potencia, str):
        return "ERROR_01", None  # Código de error único por tipo incorrecto
    
    # Caso especial: potencia 0 siempre da 1 (excepto 0^0 que es indefinido)
    if potencia == 0:
        return "SUCCESS", 1 if base != 0 else "Indefinido"
    
    # Caso especial: potencia negativa
    if potencia < 0:
        return "ERROR_02", None  # Código de error único por potencia negativa
    
    resultado = 1
    for _ in range(potencia):
        temp = 0
        for _ in range(resultado):
            temp += base  # Evitar la multiplicación directa
        resultado = temp
    
    return "SUCCESS", resultado  # Código de éxito

# Ejemplo de uso
if __name__ == "__main__":
    base = input("Ingrese la base: ")
    potencia = input("Ingrese la potencia: ")
    
    try:
        base = int(base)
        potencia = int(potencia)
        resultado = potencia_manual(base, potencia)
    except ValueError:
        resultado = ("ERROR_01", None)
    
    print(resultado)
