import cv2
import csv
import datetime

# Crear el detector de códigos QR
qrCode = cv2.QRCodeDetector()

# Inicializar la captura de vídeo desde la cámara
cap = cv2.VideoCapture(1)

if not cap.isOpened():
    print("No se puede abrir la cámara")
    exit()

# Ruta del archivo CSV
csv_path = r"C:\Users\luise\OneDrive - Estudiantes ITCR\Semestre 3.1\Microprocesadores y Microcontroladores\CSVproyecto.csv"

#Borrar los datos del CSV anterior
with open(csv_path, 'w', newline='') as f:
    pass

# Inicializar estructura para los registros
notes = [["Registro de cajas", "Fecha", "Hora"]]

while True:
    # Leer un frame de la cámara
    ret, frame = cap.read()
    if not ret:
        print("No se puede detectar el fotograma. Saliendo...")
        break

    # Detectar y decodificar el código QR
    ret_qr, decoded_info, points, _ = qrCode.detectAndDecodeMulti(frame)
    if ret_qr:
        for info, point in zip(decoded_info, points):
            if info:
                # Obtener la fecha y hora actual
                tiempo = datetime.datetime.now()
                
                print(info)
                # Guardar los datos en la lista
                notes.append([info, f"{tiempo.day}-{tiempo.month}-{tiempo.year}", 
                              f"{tiempo.hour}:{tiempo.minute}:{tiempo.second}"])
                
                # Escribir en el archivo CSV
                with open(csv_path, 'a', newline='') as f:
                    writer = csv.writer(f, delimiter=',')
                    writer.writerows(notes)

                # Limpiar la lista después de escribir
                notes = []

                # Dibujar el recuadro del QR en verde
                frame = cv2.polylines(frame, [point.astype(int)], True, (0, 255, 0), 8)
            else:
                frame = cv2.polylines(frame, [point.astype(int)], True, (0, 0, 255), 8)

    # Mostrar el frame (eliminar esto si ya no es necesario)
    cv2.imshow('Lector de QR', frame)

    # Salir con 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


# Liberar recursos
cap.release()
cv2.destroyAllWindows()