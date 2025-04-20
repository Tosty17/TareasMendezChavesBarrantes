import pygame.display
import pygame.image
import pygame.mouse
import pygame.transform
from pygame.locals import *
import paramiko
import json

pygame.init()
try:
    Pantalla = pygame.display.set_mode((1000, 700))
    pygame.display.set_caption("Control de la grua")


    #imagenes
    fondo = pygame.image.load("interfaz.jpg")
    fondo = pygame.transform.smoothscale(fondo, (1000, 700))
    boton_start = pygame.image.load("START.png").convert_alpha()
    boton_stop = pygame.image.load("STOP.png").convert_alpha()
    boton_CSV = pygame.image.load("CSV.png").convert_alpha()
    Run_On = pygame.image.load("RUNNING-ON.png").convert_alpha()
    Run_Off = pygame.image.load("RUNNING-OFF.png").convert_alpha()
    Pause_On = pygame.image.load("PAUSE-ON.png").convert_alpha()
    Pause_Off = pygame.image.load("PAUSE-OFF.png").convert_alpha()
    grua = pygame.image.load("grua.png").convert_alpha()
    medicos = pygame.image.load("medicos.png").convert_alpha()
    bananos = pygame.image.load("banano.png").convert_alpha()
    cafe = pygame.image.load("cafe.png").convert_alpha()
    caja = pygame.image.load("Caja.png").convert_alpha()

    #Cliente SSH
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname="192.168.0.13", port=22, username="al.mendez", password="raspberry" )
    #Cliente FTP
    ftp_client = ssh_client.open_sftp()
    #Clase boton
    class Button():
        #constructor
        def __init__(self, _x, _y, _image, scale, Clicked):
            #atributos
            ancho = _image.get_width()
            altura = _image.get_height()
            self.image = pygame.transform.scale(_image, (int(ancho*scale), int(altura*scale)))
            self.rect = self.image.get_rect()
            self.rect.topleft = (_x,_y)
            self.click = Clicked
            

        def dibujar_boton(self, _Pantalla):
            _Pantalla.blit(self.image, (self.rect.x, self.rect.y))
                    
    #Clase sprites
    class Sprite():
        #constructor
        def __init__(self, _x, _y, _image1, _image2, scale, sprite):
            #atributos
            ancho1 = _image1.get_width()
            altura1 = _image1.get_height()
            self.Imagen1 = pygame.transform.scale(_image1, (int(ancho1*scale), int(altura1*scale)))
            self.Imagen2 = pygame.transform.scale(_image2, (int(ancho1*scale), int(altura1*scale)))
            self.rect = self.Imagen1.get_rect()
            self.rect.topleft = (_x,_y)
            self.Sprite = sprite
        def dibujar(self, _Pantalla):
            if(self.Sprite == False):
                _Pantalla.blit(self.Imagen1, (self.rect.x, self.rect.y))
            else:
                _Pantalla.blit(self.Imagen2, (self.rect.x, self.rect.y))


        
    class Cajas():
        #Constructor
        def __init__(self, cantidad, x, y, image):
            self.Cantidad = cantidad
            self.X = x
            self.Y = y
            self.Imagen = image
        def imprimir(self, _Pantalla):
            i = 0
            for i in range(self.Cantidad):
                sprite = Sprite(self.X, self.Y, self.Imagen, self.Imagen, 0.17, False)
                sprite.dibujar(_Pantalla)
                self.X += 40
                i += 1

    Signals = {
        "Ejecutar" : True,
        "CSV" : False
    }

    def frenar():
        StopButton.click = True
        StartButton.click = False
        Running.Sprite = False
        Pause.Sprite = True
        Signals["Ejecutar"] = False
        with ftp_client.file("/home/al.mendez/Desktop/Signals.json", "w") as file:
            json_string = json.dumps(Signals)
            file.write(json_string)
    def ejecutar():
        StopButton.click = False
        StartButton.click = True
        Running.Sprite = True
        Pause.Sprite = False
        Signals["Ejecutar"] = True
        with ftp_client.file("/home/al.mendez/Desktop/Signals.json", "w") as file:
            json_string = json.dumps(Signals)
            file.write(json_string)

    #Instancias
    StartButton = Button(21, 544, boton_start, 0.3, False)
    StopButton = Button(788,544, boton_stop, 0.3, True)
    CSVButton = Button(794, 145, boton_CSV, 0.3, False)
    Running = Sprite(793,400, Run_Off, Run_On, 0.25, False)
    Pause = Sprite(793,320, Pause_Off, Pause_On, 0.25, True)
    Grua = Sprite(50,180, grua, fondo, 0.25, False)
    Medicos = Sprite(280,380, medicos, fondo, 0.25, False)
    Bananos = Sprite(275,130, bananos, fondo, 0.25, False)
    Cafe = Sprite(290,260, cafe, fondo, 0.3, False)


    #Definir colores
    blanco = (255,255,255)

    #Funcion para la escritura de texto
    def escribir_texto(_Pantalla, fuente, dimensiones, texto, color, x , y):
        tipo_letra = pygame.font.SysFont(fuente, dimensiones)
        imagen = tipo_letra.render(texto, True, color)
        _Pantalla.blit(imagen, (x,y))




    run = True

    while run:
        Pantalla.blit(fondo, (0,0))
        #escribir_texto(Pantalla, "Arial", 40, "Hola mundo", blanco, 500, 500)

        #Dibujar Sprites y botones
        StartButton.dibujar_boton(Pantalla)
        StopButton.dibujar_boton(Pantalla)
        CSVButton.dibujar_boton(Pantalla)
        Running.dibujar(Pantalla)
        Pause.dibujar(Pantalla)
        Grua.dibujar(Pantalla)
        Medicos.dibujar(Pantalla)
        Bananos.dibujar(Pantalla)
        Cafe.dibujar(Pantalla)
        posicion = pygame.mouse.get_pos()

        with ftp_client.file("/home/al.mendez/Desktop/Variables.json", "r") as file:
            json_str = file.read()
            dic = json.loads(json_str)
            Cajas_Cafe = Cajas(int(dic["Bus"][0:3], 2), 420,320, caja)
            Cajas_Cafe.imprimir(Pantalla)

            Cajas_Medicos = Cajas(int(dic["Bus"][3:6], 2), 420,430 , caja)
            Cajas_Medicos.imprimir(Pantalla)

            Cajas_Banano = Cajas(int(dic["Bus"][6:9], 2), 420,200, caja)
            Cajas_Banano.imprimir(Pantalla)

            Cajas_Apilado = Cajas(int(dic["Bus"][9:12], 2), 12,350, caja)
            Cajas_Apilado.imprimir(Pantalla)

            if(int(dic["Bus"][9:12], 2) > 0):
                if(int(dic["Bus"][3:6]) < 5 or int(dic["Bus"][6:9], 2) < 5 or int(dic["Bus"][0:3]) < 5):
                    if(StopButton.click == True):
                        if(StartButton.rect.collidepoint(posicion)):
                            if(pygame.mouse.get_pressed()[0] == 1):
                                ejecutar()
                    if(StartButton.click == True):
                        if(StopButton.rect.collidepoint(posicion)):
                            if(pygame.mouse.get_pressed()[0] == 1):
                                frenar()
                    if(CSVButton.rect.collidepoint(posicion)):
                        if(pygame.mouse.get_pressed()[0] == 1):
                            print("hacer CSV")
                else:
                    frenar()
            else:
                frenar()
            
        pygame.display.update()
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                ssh_client.close()
                ftp_client.close()
except:
    print("Error")


    