import pygame.display
import pygame.image
import pygame.mouse
import pygame.transform
from pygame.locals import *

pygame.init()
Pantalla = pygame.display.set_mode((1000, 700))
pygame.display.set_caption("Control de la grua")

#Variables de entrada
Productos_apilado = 5
Productos_medicos = 2
Productos_cafe = 3
Productos_banano = 4

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


class Barra():
    def __init__(self, cantidad_productos):
        self.cantidad_actual = cantidad_productos 
        self.ratio_barra = 5/400
    
    #def cambios(self, Indicador):
        #if(Indicador == False):

def frenar():
    StopButton.click = True
    StartButton.click = False
    Running.Sprite = False
    Pause.Sprite = True
def ejecutar():
    StopButton.click = False
    StartButton.click = True
    Running.Sprite = True
    Pause.Sprite = False

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
    if(Productos_apilado > 0):
        if(Productos_medicos < 5 or Productos_banano < 5 or Productos_cafe < 5):
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


    