def separa_letras(cadena):
    if isinstance(cadena, int):
        return -100, None, None  # Código de error por número entero
    if not isinstance(cadena, str):
        return -200, None, None  # Código de error por caracter
    if cadena == "":
        return -300, None, None  # Código de error por string vacío
    if not cadena.isalpha():
        return -200, None, None  # Código de error por caracteres no permitidos

    mayusculas = "".join([c for c in cadena if c.isupper()])
    minusculas = "".join([c for c in cadena if c.islower()])
    return 0, mayusculas, minusculas  # Código de éxito


def potencia_manual(base, potencia):
    if isinstance(base, str) or isinstance(potencia, str):
        return -400, None  # Código de error por entrada no válida
    if potencia < 0:
        return -400, None  # No se aceptan exponentes negativos
    if base == 0 and potencia == 0:
        return 0, 1  # Definiendo 0^0 como 1 por consistencia
    if potencia == 0:
        return 0, 1  # Cualquier número elevado a 0 es 1

    resultado = 1
    for _ in range(potencia):
        temp = 0
        for _ in range(base):
            temp += resultado
        resultado = temp

    return 0, resultado  # Código de éxito
