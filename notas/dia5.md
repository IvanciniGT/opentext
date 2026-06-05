
# Autenticación

## Antiguamente. Apps Stateful

Hacíamos login en una app y los datos del login (sesión) quedaba en servidor.
El servidor mandaba una Cookie al cliente con un identificador: J_TOMCAT_ID, SESION_ID.
Esa cookie necesitabamos guardarla e ir mándandola en las sucesivas Peticiones la servidor.

## Hoy en día (Microservicios). Apps Stateless

El servidor no guarda nada.

Hacemos login... y al hacerlo se nos entrega un Token (JWT) de autenticación.
Pero no viene como cookie... viene como un dato en el JSON de respuesta (body).

---

# REGEX 

Usamos una sintaxis heredada de un lenguaje de programación (que ya no se usa) llamado PERL.

El concepto es simple:
Trabajamos con lo que se llaman PATRONES: PATTERN.

Ese patrón lo podemos aplicar a un texto... de distintas formas:
- Cumple el texto con el patrón? MATCH
- Contiene el patrón?            CONTAINS / MATCH
- Reemplazar? Dentro de un texto, lo que cumpla con el patrón lo reemplazas por un valor REPLACE

La mayoría de programas, lo que hacen por defecto es un MATCH.

Cómo se define un patrón: Un patron es una secuencia de SUBPATRONES

## SUBPATRON

Subpatron = Secuencia de caracteres seguida de un modificador de cantidad

Secuencia de caracteres:

                    Cómo se interpreta?                                         Ejemplo                     Cumple?                Ocurrencias
    hola            Debe aparecer en el texto esa secuencia literalmente   
                                                                                hola Amigo                  Si                      1
                                                                                Amigo, hola, como estás?    Si                      1
                                                                                Hola y adios                No                      0
    [hola]          Debe aparecer alguno de los caracteres ahí puestos          hola Amigo                  Si                      
                                                                                -_-_xxxxx-                  Si                      5
                                                                                Hay muchas ocurrencias del patrón, dentro del texto
    [a-z]           Algún caracter entre la a y z en ASCII (no incluye á, ñ...)
    [a-zA-Z]
    [a-zA-ZñÁé]     Algun caracter básico de la a-z (mayúsculas o minúsculas, Á, é, ñ)
    [a-záéíóñ-]     El guión al final se toma como guión... no como rango.
    .               Lo que sea... un caracter.. da igual cual.
    \s              Caracteres blancos (espacio, tabulador...)
    \w              Caracteres de palabras (words... en inglés)

Modificador de cantidad:
    Nada            La secuencia de caracteres anterior debe aparecer 1 vez
    ?               Puede aparecer o no
    +               Debe aparecer al menos 1 vez
    *               Puede aparecer cualquier numero de veces o no aparecer (como si fuera el + junto con el ?)
    {3}             Debe aparecer 3 veces
    {2,8}           Debe aparecer entre 2 y 8 veces

Y punto.

Hay algunos caracteres adicionales:
    ()              Agrupan subpatrones
    |               Un "O"... Un subpatron1 o un subpatron2
    ^               Que empiece por
    $               que acabe



PATRON:  Hola [a-zA-ZñáéíóúÁÉÍÓÚÑ]+
         _____|___________________-
         sub1      Sub2
          Textos:      
                Hola Felipe                 CUMPLE

PATRON: true|false
        ____ _____
        sub1 sub2
            TEXTOS:
                true                √
                false               √
                truefalse           √
                ----
                    -----


PATRON: ^(true|false)$
        ____ _____
        sub1 sub2
            TEXTOS:
                true                √
                false               √
                truefalse           x

PATRON [0-98]    Un caracter entre el 0 y el 9: 0123456789 y el 8(que ya lo puse)
                 REGEX no tyrabaja con números, sino con caracteres
                    Esto no es un número de 0 al 98
        TEXTO:
            17  √ (2 veces)

       [0-98]+  Un caracter entre el 0 y el 9: 0123456789 y el 8(que ya lo puse)
        TEXTO:
            17  √ (1 vez)
            el 17 se captura como un bloque... no son 2 bloques por separado, el 1 y el 7

       [0-9]+[a-z]+
            17hola      √
            17hola25    √
            hola17      x
            hola17hola  √
                ------

       ^[0-9]+[a-z]+$
            17hola      √
            17hola25    x

Número del 0 al 99
    [1-9]?[0-9]
             0
             1
             9
            10 
    [0-9]+      9191923743728193730

El chatpgt os ayuda mucho con esto.

regex101.com

"name"\s*:\s+"John Doe"
"name": "John Doe"


http://52.209.155.43:8080/citas/438DrfyP0o4
GET


    "facility"\s*:\s+"(Tokyo|Hongkong|Seoul) CURA Healthcare Center",

    "program"\s*:\s+"Medicare|Medicaid|None",

    "date"\s*:\s+"[123]?[0-9]/((1?[0-2])|(0[1-9]))/20[0-9]{2}",

    "comment"\s*:\s+".*",

    "readmission"\s*:\s+(true|false),

    "id"\s*:\s+"[a-zA-Z0-9]{5,25}"


<select id="combo_facility" name="facility" class="form-control">
                            ">Tokyo CURA Healthcare Center</option>
                            <option value="Hongkong CURA Healthcare Center">Hongkong CURA Healthcare Center</option>
                            <option value="Seoul CURA Healthcare Center">Seoul CURA Healthcare Center</option>
                        </select>


[0123][0-9]         /               ((1?[0-2])|(0[1-9]))        /           20[0-9]{2}
01                                  10                                      2025
16                                  11                                      2099
31                                  12
39                                  01
00                                  09


---

# Comparación con ReadyAPI

No es una herramienta de test de Apis REST/WEB
Es una herramienta para DEFINIR APIS, exportar los openAPI/Swagger, montar virtual servers FAKE,... 
y asociada a la definición, puedo meter pruebas!

Por su parte UFT es una herramienta de Pruebas. Me permite probar APIS (que puedo dar de alta con Swagger).
Pero me enparalelo me permite hacer pruebas de Otras N cosas... E integrarme con BBDD


---

Muchas veces se confunden pruebas de Sistema con pruebas End2End

    Puedo hacer una prueba de Sistema mediante la UI
    Doy de alta una cita con el formulario y reviso que en el la pantalla de citas me salga (sistema... pero no es e2e)

    La prueba E2E sería:
        Doy de alta con el formulario... y verifico que el servicio web me la devuelve y que en la BBDD esta grabada

---

Lo normal es que un proyecto empiece definiendo APIS REST/WEB. Y lo hago en READYAPI.
Y hago ahi pruebas... a nivel de CAJA NEGRA (PRUEBO EL API, no el microservicio!)
Dicho de otra forma, pruebo REQUISITOS!
Pruebo que el API responde a requisitos.
Y para eso me puedo definir VirtualServices.
A su vez esos virtual services los puede usar un desarrollor que consuma el API (aunque no tiene sentido.. para eso me lo monto con JSON-SERVER)
Y una vez hecho esto, genero openAPI/Swagger y lo entrego a los equipos de Frontal y de Backend.. y que current.
El de frontal usará JSON-SERVE como un FAKE del microservicio que aún no está desarrollado.
Frontal hace sus pruebas unitarias/Componente/Sistema: Karma, Cypress, Jasmine, Jest

La gente de backend hace sus pruebas unitarias/integracion/sistema: JUNIT, Mockito, H2...

Hago pruebas de sistema / End2End <-- Aquí entra el UFT
    Hago pruebas de UI, Microservicio, BBDD, Sistemas de mensajería, Servidor de Email...

Smartbear hace tanto:
    - ReadyApi      Desarrollo de APIS (no implementaciones)
    - SoapUI        Testing puro de Servicios

     Cliente <-API-> Microservicio
                ^
        Especificación: Swagger/OpenAPI


---

Servicio > Recurso (usuarios) > Metodo (alta)
    Inputs (parametros de entrada):
        Nombre
        Password
    JSON QUE MANDO:
        {
            "nombre": "<input: NOMBRE>",
            "password": "<input: Password>",
        }
    JSON DE VUELTA
        {
            "nombre": "<input: NOMBRE>",
            "password": "<input: Password>",
            "id": "SE GENERA EN SERVIDOR",
        }
    Output Servicio:
        Id: <Cuyo valor se tome del JSON DE VUELTA, campo ID>

---


Servicio > Recurso (usuarios) > Metodo (recuperar uno)
    Inputs (parametros de entrada):
        Id
        Nombre
        Password
    URL uso el ID
    JSON QUE MANDO:
        NADA
    JSON DE VUELTA
        {
            "nombre": "Me lo da el servidor",
            "password": "Me lo da el servidor",
            "id": "Me lo da el servidor",
        }
    Output Servicio:
        Ninguno
    Validaciones:
        El Nombre que me devuelve: El que me pasan como Input
        El Password que me devuelve: El que me pasan como Input
        El Id que me devuelve: El que me pasan como Input

---

    FLUJO
        DATOS tabla interna
            -> Nombre1
            -> Password1

        ACTIVIDAD 1 Cada caja tiene Entradas y salidas... que sirven para:                                  ALTA
            - Conectar entradas / salidas entre Actividades / Datos
            - Usar las Entradas directamente dentro de la actividad para rellenar datos o validaciones
            - Inputs
              - Nombre2     -> Internamente lo uso para componer el JSON que mando en el alta, Validar JSON de vuelta
              - Password2   -> Internamente lo uso para componer el JSON que mando en el alta, Validar JSON de vuelta
            - Output
              - Id2         <- Lo rellenamos internamente con el JSON DE RESPUESTA

        ACTIVIDAD 2                                                                                         RECUPERAR 1
            Input: 
                - Nombre3   -> VALIDAR LA RESPUESTA
                - Password3 -> VALIDAR LA RESPUESTA
                - Id3       -> VALIDAR LA RESPUESTA y construir la URL: http:MISERVIDOR:PUERTO/usuario/<ID3>

        Nombre1 -> Nombre2
        Password1 -> Password2

        Nombre1 -> Nombre3
        Nombre1 -> Password3 
    
        Id2 -> Id3


---


    FLUJO
        DATOS tabla BBDD
            -> Nombre1
            -> Password1

        ACTIVIDAD 1 Cada caja tiene Entradas y salidas... que sirven para:                                  ALTA
            - Conectar entradas / salidas entre Actividades / Datos
            - Usar las Entradas directamente dentro de la actividad para rellenar datos o validaciones
            - Inputs
              - Nombre2     -> Internamente lo uso para componer el JSON que mando en el alta
              - Password2   -> Internamente lo uso para componer el JSON que mando en el alta
            - Output
              - Id2

        ACTIVIDAD 2                                                                                         RECUPERAR 1
            Input: 
                - Nombre3
                - Password3
                - Id3

        Nombre1 -> Nombre2
        Password1 -> Password2

        Nombre1 -> Nombre3
        Nombre1 -> Password3 
    
        Id2 -> Id3


---

Output

    Checkpoint
        Nombre Output                                                                    VALOR
        Id                              ICONO CADENA         VALIDATE [ ]                ICONO CADENA
                 ID del JSON                                       



HTTP Sincrono unidireccional

    CLIENTE ----> PETICION -------> SERVIDOR
            <----- RESPUESTA ------

WEB SOCKET Asincrono Bidireccional

    CLIENTE -------> ESTABLECE CONEXION ----> SERVIDOR

        Cliente -----> mandar mensajes------>
        Cliente -----> mandar mensajes------>
        Cliente -----> mandar mensajes------>

                <----- Mandar mensajes ------ Servidor
                <----- Mandar mensajes ------ Servidor
                <----- Mandar mensajes ------ Servidor
                <----- Mandar mensajes ------ Servidor
                

---

# IA dentro de UFT

3 cosas.
Mi consejo... si no estáis en un caso especial de uso NO USO NADA DE IA.

Una IA es un programa que hace cosas que antes hacia un humano (es una forma de AUTOMATIZAR).
OpenText, crea un programa que es capaz de hacer algunas operaciones:
- Object Inspection
- Object record
- Object Mockup

Opentext va generando nuevas versiones de ese programa (que no siempre salen en paralelo con las versiones de UFT)
Hay veces que estando vigente la misma version de UFT salen 3 versiones del programa de la IA.
Hay veces que 2 versiones de UFT usan la misma versión del programa de la IA.

Esos programas de IA en realidad su nombre más técnico es MODELOS!

Copilot es una IA? NO
    Copilot es un chatbot. que las preguntas que le hago se las pasa a un modelo de IA... y coge la respuesta del modelo y me la manda a mi.
    Chatgpot es un chatbot... que hace lo mismo

    La IA son los modelos. Hoy en día, Cualquiera de estos chatbots: usan el modelo que yo quiera
    - Chatgpt           gpt-4.5 gpt 5.4
    - Copilot chat      gpt-5.4 claude-sonnet-v4.7
    - Gemini            gemini-flash3.1 gemini-pro-3.1

---

Qué son estas 3 operaciones que puedo hacer con IA en UFT:
- Object Inspection             - Buscar objetos sueltos para añadirlos al REPO
                                    Lo llevamos haciendo muchos dias.
                                    La que hacemos tradicional, en base a que identifica los objetos?
                                        Busca propiedades en los Nodos del DOM.
                                            Qué propiedades? Las QUE YO PONGA! Aunque el ofrece una propuesta
                                                Dentro de esto... hay una cosa que se llama Smart Object Identification *1.. PERO NO ES IA!
                                    En estos objetos, que identificamos tradicionalmente, al final en el script usamos:
                                        Browser("App").Page("Home").WebButton("Do Login")... ACCION QUE QUIERO REALIZAR
                                                                                            Click()
                                                                                            Set()
                                                                                            GetROProperty()
                                    En lugar de esto, podemos delegar en este programa "inteligente" que busque dinamicamente objetos.
                                    Con ese programa hablaríamos como su fuera un humano.
                                    - Busca un botón que ponga algo así como login y le haces click
                                        El código que usamos es del tipo:
                                                        Esto no tiene porque ser exacto.
                                                           vv
                                        AIUtil("button", "Login")... Accion que quiera ejecutar:
                                                                    Click()
                                                                    Set()
                                                                    GetROProperty()
                                                ^^
                                                Esto tiene que ser exacto
                                    
                                    Ventaja: 
                                        - No me pego con props HTML.
                                        - Si cambia alguna prop del HTML o el texto... no tengo que cambiar el código
                                    Inconvenientes:
                                        - Me entenderá o no? Bueno... en general si.
                                        - No tengo npi de cómo funciona! y por ende desconozco el impacto 
                                          que puede tener un cambio en la app en los tests.
                                    Resumen:
                                        - Si tengo ID sigo trabajando como toda la santa vida:
                                          - Me da control total de cambios
                                          


- Object record                 - Grabar una secuencia de operaciones (TEST/FLUJO) para rellenar en automático un SCRIPT
                                  Es el mismo record (grabar) que el tradicional, solo que no mete objetos en el REPO 
                                  Y en la sintaxis de script nos genera código con el IAUtil... en lugar del 
                                  Browser.Page.WebElement de turno. 




- Object Mockup
                                El el mismo concepto, sobre IMAGENES.
                                Está planteado para cuando antes de tener la app quiero hacer los tests en base a un prototipo/diseño.

                                Tengo un equipo de UX/UI que ha diseñado con una app de Wireframing el flujo de pantallas.
                                Le casco al UFT unas capturas de esas pantallas (POWER POINT) Y el UFT Identifica los objetos.
                                Y puedo montar el test sin tener las pantallas reales.

                                Le paso ese test al equipo de desarrollo, 3 kilos de perejil (pal San Pancracio) y que 
                                cuando acaben el desarrollo, puedan ya ejecutar los test.
                                HAGO LOS TEST ANTES DEL DESARROLLO:
                                    - TDD
                                    - BDD
                                    - ATDD
                                Eso si... puedo hacer exactamente lo mismo pidiendo a mi equipo de desarrollo que generen los componentes 
                                con un ID... Nos ponemos de acuerdo en los IDs que vamos a generar y me la trae al peiro la pantalla y la estética.
                                AQuizás la estética se va trabajando aparte.. y no tengo todavía un prediseño (Wireframe).

---

*1 Smart Object Identification

Básicamente, si no encuentra un objeto con las props que hay establecidas (por mi... o las sugeridas por él) mira a ver 
si hay algún objeto que le medio cuadren el resto de propiedades.

como me descuide me la lia parda.
El otro dia, no encontro el Objeto LOGOUT... y pensó que era el Login... que le habiamos cambiado el "text"