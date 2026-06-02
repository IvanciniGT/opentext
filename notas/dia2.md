La gran crisis del software se dio a finales de los años 60, después de 2 décadas intensivas de creación de software.

Debido a la falta de metodologías, herramientas y procesos para crear software, patrones, conceptos, principios... se generó una gran cantidad de software que era inmantenible... hasta que colapsó el sistema. -> Aquí nace la ingeniería de software.

Ahí lo aprendimos.. que la mantenibilidad es un factor clave para el éxito de un proyecto de software.
Nosotros estamos en testing.. pero testing automatizado = desarrollo de software. 

---

- Vocabulario
- Para que sirven hoy en día las pruebas
- Tipos de pruebas
- Metodologías ágiles
- Devops
  - Integración Continua -> Automatización de pruebas + Generar un informe de pruebas en tiempo real.
- UFT
- Pruebas de UI WEB
  - Lenguaje de programación VBScript
  - Podemos hacer grabación/Captura de scripts en automático. Como punto de partida está bien... pero hay que cambiar los scripts enteros
  - Cuando quiero probar una app web (automatizada), necesito un mínimo de conocimiento de la tecnología... en nuestro caso de HTML.
    - Identificación de objetos sobre los que vamos a interactuar.
- Estructura de una prueba:
  - Contexto / Given / Dado
  - Acción / When / Cuando
  - Comprobaciones / Then / Entonces
- Modularización de los scripts
  - Reutilización de componentes <- Esto es clave para la mantenibilidad
- Principios de pruebas: FIRST
  - Fast
  - Independent
  - Repeatable
  - Self-validating
  - Timely

---

Un script típico de UI de UFT tiene esta pinta:

OBJETO SOBRE EL QUE VOY A TRABAJAR -> ACCION
OBJETO SOBRE EL QUE VOY A TRABAJAR -> ACCION
OBJETO SOBRE EL QUE VOY A TRABAJAR -> ACCION
OBJETO SOBRE EL QUE VOY A TRABAJAR -> ACCION
OBJETO SOBRE EL QUE VOY A TRABAJAR -> ACCION
...
VALIDACION

---

UFT tiene una cosa BONITA: el registro de objetos.
Ese registro me permite tener un catálogo de los objetos que uso de mi app, a la hora de hacer las pruebas.
Ejemplos de objetos:
- Página de mi app abierta en el navegador
- Botón de login
- Campo de texto del usuario
- Campo de texto de la contraseña
- Enlace de "Olvidé mi contraseña"

Esos objetos tendrán sus propiedades. UFT usará esas props para identificar los objetos dentro de la página/app y permitirnos hacer operaciones sobre ellos. No sobre todo objeto puedo hacer las mismas operaciones. Por ejemplo, sobre un botón puedo hacer click, pero sobre un campo de texto también puedo hacer click, pero adicionalmente puedo escribir texto.

Además, ee catálogo es muy bonito desde el punto de vista de la mantenibilidad, porque si cambia el botón de login, solo tengo que actualizar ese objeto en el catálogo y no tengo que cambiar todos los scripts que usan ese botón.

Desgraciadamente el mundo web ha cambiado.... desde los más de 20 años que tiene UFT, y aunque eso suene bonito... en la práctica puede y tiende a no ser real. Antiguamente si.. funcionaba bien... pero el HTML y el CSS han evolucionado MUCHO!
Y UFT no se ha adaptado bien a los cambios.

Hay que aprender muy bien a usar el catálogo (object repository) para generar cosas que sean mantenibles.

Cualquier objeto que de de alta en el catálogo, va a tener un tipo asociado. UFT me da ciertos tipos de datos, que selen asociarse en base al tipo de elemento HTML que representen.

| elemento HTML         | tipo de objeto UFT |
|-----------------------|--------------------|
| <button>              | WebButton          |
| <div>                 | WebElement         |
| <input type="text">   | WebEdit            |
| <a>                   | WebLink            |
| <select>              | WebList            |
| <html>                | WebPage            |

En base al tipo de objeto, podré hacer más o menos operaciones sobre ese objeto. 
Por ejemplo, sobre un WebButton podré hacer click, pero sobre un WebEdit podré hacer click y escribir texto.

El problema es que ese tipo de objeto es lo que vamos a usar en nuestros scripts para interactuar con la aplicación, y con muha frecuencia, los tipos de objeto en HTML cambian. Al menos algunos de ellos.... con frecuencia.

Aquí hay un problema... HTML ofrece un lenguaje que con el tipo se ha ido moviendo hacia un lenguaje SEMANTICO! (que me permite estructurar un documento). Y el lenguaje CSS se ha vuelto muy potente para ayudarnos a definir la estética / representación de los elementos gráficamente.
Como concepto es genial!
El problema es que hoy en día cualquier elemento HTML se puede representar gráficamente como un botón, o como un campo de texto, o como un enlace... se debe a la potencia de CSS como lenguaje.

---

El navegador carga cierto HTML de un servidor (página web).
En un modelo/arquitectura tradicional WEB, el servidor devolvía al cliente(navegador) todo el HTML que debía representarse.
Este modelo YA NO EXISTE! Está totalmente OBSOLETO! Quedarán 4 apps legacy.

El concepto que impera hoy en día es el concepto de SPA (Single Page Application).
Una app web que solo tiene un archivo HTML.
Hoy día, junto a ese HTML el navegador descarga un programa JS que se ejecuta en el navegador (en el cliente).
Ese programa es el que se encarga de invocar a un Backend para obtener los datos que necesita (no en HTML, como antiguamente, sino en formato JSON) y es el que se encarga de generar dinámicamente el HTML que va MUTANDO el HTML original que se descargó el navegador.

Realmente el proceso es asi:

    Servidor ---html---> Navegador
                          Se genera un DOM (Document Object Model) a partir del HTML (árbol de nodos, como carpetas de windows)
             ---js----->  El navegador ejecuta es JS.
             <----------  JS             
             --json---->  JS (transforma ese JSON en un objeto HTML de tipo DIV... con otros 300 elementos dentro
                              Y ese nodo(objeto)) se inyecta en algún sitio del DOM, mutando el HTML original que se descargó el navegador.

    Angular, React, Vue. Estos frameworks, que son los que se usan hoy en día, es lo que hacen.
    Os dije que el W3C define los estandares del mundo WEB... Y hay uno del que no os he hablado: WebComponents.
    Ese estandar precisamente define esta forma de trabajo.


# Años atrás.

    Cliente                  Servidor
    Navegador    -----------> Programa
                 <---html----
# Hoy en día:

    Cliente                  Servidor
    AppsMobile
    - Android
    - iOS
    Navegador    -----------> Programa (Microservicio)
       JS        <---json----
    Asistentes de voz
    - Alexa
    - Google Home
    - Siri
    IVR (Interactive Voice Response) 

---

UFT trabaja contra el DOM... pero NO LO EXPONE! Otras herramientas como SELENIUM, CYPRESS, PLAYWRIGHT... sí lo hacen (si lo exponen). UFT NO.
UFT expone sus propios objetos: Page, WebElement, WebLink, WebEdit... y esos objetos se asocian a los objetos del DOM. Pero esa asociación está cogida con pinzas. Y si va cambiando el HTML que se genera a nivel de la app, esa asociación se rompe. Y entonces todos mis scripts dejan de funcionar.

```vbscript

Browser("App Citas Medicas").Page("Login").WebEdit("Usuario").Set "John Doe"
Browser("App Citas Medicas").Page("Login").WebEdit("Contraseña").SetSecure "ThisIsNotAPassword"
Browser("App Citas Medicas").Page("Login").WebButton("Iniciar sesión").Click

If Browser("App Citas Medicas").Page("Principal").WebButton("MakeAppoiment").Exist(10) Then
    Reports.ReportEvent micPass, "Inicio de sesión", "El usuario ha iniciado sesión correctamente"
Else
    Reports.ReportEvent micFail, "Inicio de sesión", "El usuario no ha podido iniciar sesión"
End If

```

Claro...Fijaros:
    Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita").Click
    ------------------------------------------------------------------ -----
    Objeto con el que interactúo                                       Acción

    Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita")

Cada una de estyas cosas, es y debe ser un objeto dado de alta en el catálogo de objetos de UFT.
        Browser("App Citas Medicas")
        Page("Home")
        WebLink("Reservar Cita")

Cada uno de esos objetos tiene metadatos asociados en el catalogo de UFT:
 - id en UFT: "Reservar Cita"
 - TipoUFT: WebLink ~ tipoHTML: <a>
 - texto visible en pantalla: "Make Appoiment"
 - id en HTML: "btn-make-appointment"
 - clase en HTML: "btn btn-dark btn-lg"

Cuando grabo una secuencia de acciones en UFT no solo se me crea un esqueleto script, también se crean los objetos necesarios (con los que estoy interactuando) en el registro de UFT.
Con unos metadatos rellenos.
La cosa es que esos metadatos los clasificamos en 2 tipos:
- Los metados mandatorios/obligatorios: son los que UFT necesita para identificar el objeto.
- Hay otros menos relevantes (de prioridad más baja), que también pueden ayudar a UFT a identificar el objeto.
- Aquí entra mi criterio como profesional... Qué quiero que use realmente UFT para identificar el objeto? Qué metadatos quiero que use? Cuáles son los más estables? 

Pero luego hay otro problema.
A día de hoy el botón de "Make Appoiment" es un WebLink... y por ende, en mis scripts lo usaré / referenciaré así:

    Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita")

Pero si mañana pasa de ser un <a> (WEBLINK) a ser un <button> (WEBBUTTON), entonces en los script necesito:

    Browser("App Citas Medicas").Page("Home").WebButton("Reservar Cita")

Por eso posiblemente, y con independencia del catalogo (object repository) de UFT, posiblemente me interese otra estrategia:

```vbscript
' Crear una función de ir al login/hacer reserva

Sub irAlLogin()
    Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita").Click
    If Browser("App Citas Medicas").Page("Login").WebEdit("Usuario").Exist(10) Then
        Reports.ReportEvent micPass, "Ir al login", "El usuario ha llegado a la página de login correctamente"
    Else
        Reports.ReportEvent micFail, "Ir al login", "El usuario no ha podido llegar a la página de login"
        ExitTest
    End If
End Sub

' Esta función (subrutina) es la que uso en mis 400 tests, que necesiten haber hecho login.
' Si el día de mañana cambia el <a> por un <button> en la página de inicio, solo tengo que cambiar esta función, y no los 400 tests. En parelo con el catálogo...que también hay que tocarlo.
```

Ese código es el que NO VA A GENERAR UFT... UFT al grabar una secuencia me genera algo como:

```vbscript

Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita").Click
If Browser("App Citas Medicas").Page("Login").WebEdit("Usuario").Exist(10) Then
    Reports.ReportEvent micPass, "Ir al login", "El usuario ha llegado a la página de login correctamente"
Else
    Reports.ReportEvent micFail, "Ir al login", "El usuario no ha podido llegar a la página de login"
    ExitTest
End If  

Browser("App Citas Medicas").Page("Home").WebEdit("Usuario").Set "John Doe"
Browser("App Citas Medicas").Page("Home").WebEdit("Contraseña").SetSecure "ThisIsNotAPassword"
Browser("App Citas Medicas").Page("Home").WebButton("Iniciar sesión").Click

If Browser("App Citas Medicas").Page("Principal").WebButton("MakeAppoiment").Exist(10) Then
    Reports.ReportEvent micPass, "Inicio de sesión", "El usuario ha iniciado sesión correctamente"
Else
    Reports.ReportEvent micFail, "Inicio de sesión", "El usuario no ha podido iniciar sesión"
End If

```

Para un caso como elq ue hemos planteado, el happy Path (camino feliz) del login de la app de citas médicas:

```vbscript
' Utilidades de nuestr app

Dim Tiempo 
Tiempo = 10

Function EsperarAElemento(objeto)
    EsperarAElemento = objeto.Exist(Tiempo)
End Function

Sub IrAlLogin()

    SystemUtil.Run "chrome.exe", "http://katalon-demo-cura.herokuapp.com/"

    If EsperarAElemento( Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita") ) Then
        Browser("App Citas Medicas").Page("Home").WebLink("Reservar Cita").Click
        If Browser("App Citas Medicas").Page("Login").WebEdit("Usuario").Exist(10) Then
            Reports.ReportEvent micPass, "Ir al login", "El usuario ha llegado a la página de login correctamente"
        Else
            Reports.ReportEvent micFail, "Ir al login", "El usuario no ha podido llegar a la página de login"
            ExitTest
        End If
    Else
        Reports.ReportEvent micFail, "Ir al login", "La app no ha cargado."
        ExitTest
    End If

End Sub

Sub RellenarLogin(usuario, contraseña)
    Browser("App Citas Medicas").Page("Login").WebEdit("Usuario").Set usuario
    Browser("App Citas Medicas").Page("Login").WebEdit("Contraseña").SetSecure contraseña
    Browser("App Citas Medicas").Page("Login").WebButton("Iniciar sesión").Click
End Sub

Sub ComprobarLoginExitoso()
    If Browser("App Citas Medicas").Page("Principal").WebSelect("Lista de Hospitales").Exist(10) Then
        Reports.ReportEvent micPass, "Inicio de sesión", "El usuario ha iniciado sesión correctamente"
    Else
        Reports.ReportEvent micFail, "Inicio de sesión", "El usuario no ha podido iniciar sesión"
        ExitTest
    End If
End Sub

Sub ComprobarLoginNoExitoso()
    If Browser("App Citas Medicas").Page("Login").WebElement("Datos invalidos").Exist(10) Then
        Reports.ReportEvent micPass, "Login con datos ruinosos", "El usuario no ha podido iniciar sesión"
    Else
        Reports.ReportEvent micFail, "Login con datos ruinosos", "El usuario si ha podido iniciar sesión"
        ExitTest
    End If
End Sub

```

```vbscript
' Escenario / Caso de Prueba: Login exitoso

' Dado que el usuario tiene el navegador abiuerto y está en la pantalla de login
Call IrAlLogin()

' Cuando el usuario rellena datos buenos de login
Call RellenarLogin("John Doe", "ThisIsNotAPassword")

' Entonces, debe de llegar a la página principal de la app
Call ComprobarLoginExitoso()
```

```vbscript
' Escenario / Caso de Prueba: Login con Datos ruinosos

' Dado que el usuario tiene el navegador abiuerto y está en la pantalla de login
Call IrAlLogin()

' Cuando el usuario rellena datos buenos de login
Call RellenarLogin("Ruina", "Ruina")

' Entonces, debe de llegar a la página de error de login
Call ComprobarLoginNoExitoso()
```

```vbscript
' Escenario / Caso de Prueba: Login sin Datos

' Dado que el usuario tiene el navegador abiuerto y está en la pantalla de login
Call IrAlLogin()

' Cuando el usuario no rellena datos
Call RellenarLogin("", "")

' Entonces, debe de llegar a la página de error de login
Call ComprobarLoginNoExitoso()
```


TEngo ahora una tabla de datos de UFT, con 2 columnas: Usuarios y Contraseñas Incorrectas, y 3 filas de datos:
| Usuario  | Contraseña           |
|----------|----------------------|
| Ruina    | Ruina                |
| Ruina    | ThisIsNotAPassword   |
| John Doe | Ruina                |

```vbscript
' Escenario / Caso de Prueba: Login con Datos ruinosos (Data Driven)
' Dado que el usuario tiene el navegador abiuerto y está en la pantalla de login
Call IrAlLogin()
' Cuando el usuario rellena datos ruinosos de login
Call RellenarLogin(DataTable("Usuario", dtGlobalSheet), DataTable("Contraseña", dtGlobalSheet))
' Entonces, debe de llegar a la página de error de login
Call ComprobarLoginNoExitoso()
```

Qué tal sería... ampliar esa tabla a 3 columnas?

| Usuario  | Contraseña           | Resultado |
|----------|----------------------|-----------|
| John Doe | ThisIsNotAPassword   | OK        |
| Ruina    | Ruina                | KO        |
| Ruina    | ThisIsNotAPassword   | KO        |
| John Doe | Ruina                | KO        |

Podría meter en el código un IF..del tipo:

```vbscript
'....

' Y la comprobación en base al resultado esperado
If DataTable("Resultado", dtGlobalSheet) = "OK" Then
    Call ComprobarLoginExitoso()
Else
    Call ComprobarLoginNoExitoso()
End If
```

En general no queremos mezclar CASOS DE PRUEBA DISTINTOS en un test. No es buena práctica.
Si el test falla.. ya hay que andar mirando informes.. y ver que le ches ha fallado

Test_LoginExitoso (5 filas de datos)

Test_LoginRuinoso (5 filas de datos)

Si falla uno de ellos, sé que está fallando: Si falla el Test_LoginExitoso, sé que el problema está en el login exitoso. Si falla el Test_LoginRuinoso, sé que el problema está en el login ruinoso.

Si tengo solo un test llamado: Test_Login (10 filas de datos), y falla, no sé si el problema está en el login exitoso o en el login ruinoso. Y entonces tengo que andar mirando informes, y viendo que fila de datos ha fallado... y eso es un engorro.

---

# Necesario para trabajar:

Hay que llegar a acuerdos entre desarrollo y testing. 
La forma más sencilla es mediante un REQUISITO a nivel de app.

Como hemos dicho la clave y lo complejo es identificar elementos de forma estable en el tiempo.

Para paliar esto podemos hacer varias propuestas. De la mejor a la peor:

1. Que desarrollo añada en cada componente con el que se pueda interactuar un atributo html llamado: `data-testid`
   o similar (aunque data-testid es muy habitual).
   Todo: button, a, input de formulario, en general cualquier elemento interactuable debe llevar ese atributo en el HTML.
   Elementos con textos cuyo contenido deba leer igual!
   Y pone en el nombre: id... es decir, debe ser UNICO y además CONSISTENTE EN EL TIEMPO!
   Conviene si optamos por esto, definir una nomenclatura clara.
2. Que desarrollo añada un id único a cada elemento interactuable html:
   Más o menos lo mismo que lo de arriba, pero usando el atributo html estandar `id` .Cual es la
   diferencia... Mientras el data-testid será único a nivel de app, el id , cuando lo pone los desarrolladores lo montan único a nivel de página.
3. En los campos de formulario, al menos ahí puedo usar el atributo `name` que es obligatorio en los campos de formulario, y suele ser único a nivel de página. Este atributo es muy estable. Pero: SOLO ESTA EN CAMPOS DE FORMULARIO.
4. Si no tengo nada eso.... Perejil a San Pancracio!
5. - Tipo de elemento HTML
        El elemento <H1> 
        Hay elementos HTML muy estables: H1, H2, Elementos de formulario
        Hay elementos muy inestables: button, div, a, li
   - Estilo css
        Que tenga un estilo: "error" 
        Hay librerías de estilos que muchas veces los desarrollares usan: BootStrap, Angular Material
        Si se usan esas, los estilos suelen ser muy estables.
   - Textos visibles en pantalla
        Que tenga como texto: "Error en el login"
   - Posición en el DOM (ESTO ES MUY INESTABLE, NO LO RECOMIENDO PARA NADA) 
        Que sea el segundo párrafo del header
6. Por ubicación en pantalla (Posicionamiento de pixels...)... eso tiene sentido para:
  - App windows desktop (VisualBasic), Un formulario SAP, Un Oracle Forms... Una app delphi
  - Estamos en apps NO ESCALABLES

Hacemos combinación de estos metadatos:
Para saber si he llegado a la pantalla de login : "Que existe el elemento ERROR DE LOGIN"
Y ese elemento "ERROR DE LOGIN" en el registry de UFT lo defino:
- Opción 1: H1 cuyo texto es "Error en el login"
- Opción 2: H1 cuyo estilo es "error" 
- Opción 3: H1 cuyo texto es "Error en el login" y cuyo estilo es "error"
- Opción 4: Segundo párrafo del header cuyo texto es "Su nombre de usuario o contraseña no son correctos"
- Y 100 combinaciones más.

```html
<html>
    <body>
        <header>
            <h1 class="error">Error en el login</h1>
            <p>Información adicional:</p>
            <p>Su nombre de usuario o contraseña no son correctos</p>
        </header>
    </body> 
</html>
```

La 3 no la cogería nunca. Es muy específica... y por ende las probabilidades de que algo cambie se multiplican.
- Si cambian el H1... jodido
- Si cambian el mensaje.... jodido
- Si cambian el estilo.... jodido

En general, cuantas menos cosas necesite/use para identificar un objeto mejor!

La 4 no es muy buena.. es un mensaje descriptivo.. y esos suelen cambiar con más probabilidad que los mensajes Identificativos: TITULO, NOMBRE DE UN CAMPO EN UN FORM.

Las buenas serían la 1 o la 2.
La 1 


---

Servidor de UFT                 Servidor de Pruebas (Entorno de Integración)
    UTF                             App (fichero.properties)
    (fichero.properties)

        El fichero .properties va cambiando con el tiempo; Modificaciones, nuevos mensajes...
        Primer problema es mantenerlo sincronizado en el servidor de UFT
        Eso la forma de hacerlo es por el sistema de control de versiones.
        Los desarrolladores que son los que gestionan ese archivo .properties lo suben a GIT
        Necesito que mi servidor de UTF cada vez que vaya a ejecutar las pruebas descargue la versión del fichero
        Que se esté usando en el servidor de pruebas.

        Una vez hecho eso, necesito un programa (que puedo hacer... pero eso no lo hago ya con 4 conceptos simples de VBScript) que cargue esos mensajes dentro del UFT.

        Y entonces si.. puedo hacerlo.

        Aquí hay otro problema adicional!
        NO TODO ELEMENTO INTERACTABLE tiene un texto asociado! Esto no me resuelve el 100% de los casos.
             Iconos, botones gráficos, Imágenes, campos de formulario.


---

Una cosa es que quiera probar que bajo un determinado elemento sale el texto que DEBE SALIR... y además, en función del idioma. <<< GUAY!
Y otra cosa es que use ese texto para IDENTIFICAR EL ELEMENTO. <<< MAL ASUNTO

Si a un tio le toca la loteria, busca un elemento con el texto: "Enhorabuena ha ganado" = MAL ASUNTO
Mucho mejor sería: Mira si el texto del elemento: "id_observaciones_resultado_usuario" existe.

Luego vendrá la siguiente prueba: Que tenga el mensaje adecuado!

Una prueba será, que si al tio le ha tocado la loteria, le salga un mensaje en el campo: "id_observaciones_resultado_usuario" con el mensaje:
- "Enhorabuena ha ganado" -> ESPAÑOL
- "Congratulations, you won" -> INGLÉS

    Prueba de UX -> Accesibilidad


---

UFT tiene soporte integrado directao nativo para lenguaje GHERKIN y CUCUMBER...
Pero en la extensión de desarrolladores.