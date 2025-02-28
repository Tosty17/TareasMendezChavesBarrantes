def separa_letras(cadena):
    try:
        # Verificar que el parámetro sea un string
        if not isinstance(cadena, str):
            raise TypeError("ERROR_01")  # Código de error único por tipo incorrecto
        
        # Verificar que la cadena no sea vacía
        if not cadena:
            raise ValueError("ERROR_02")  # Código de error único por cadena vacía
        
        # Verificar que solo contenga letras del abecedario
        if not cadena.isalpha():
            raise ValueError("ERROR_03")  # Código de error único por caracteres no permitidos
        
        # Separar mayúsculas y minúsculas
        mayusculas = "".join([c for c in cadena if c.isupper()])
        minusculas = "".join([c for c in cadena if c.islower()])
        
        return "SUCCESS", mayusculas, minusculas  # Código de éxito
    except Exception as e:
        return str(e), None, None  # Retornar el código de error único

# Ejemplo de uso
if __name__ == "__main__":
    entrada = input("Ingrese una cadena: ")
    resultado = separa_letras(entrada)
    print(resultado)
