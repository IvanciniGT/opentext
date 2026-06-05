# Diseño, gestión y ejecución distribuida de pruebas con OpenText UFT One, ALM y entornos remotos

## 1. Visión general

OpenText UFT One se utiliza para diseñar, desarrollar, mantener y ejecutar pruebas automatizadas funcionales sobre aplicaciones empresariales. En un entorno corporativo, UFT One no debe entenderse solo como una herramienta de grabación, sino como un entorno de automatización completo que permite modelar objetos de aplicación, estructurar pruebas, parametrizar datos, definir validaciones, reutilizar componentes y delegar ejecuciones en infraestructuras gestionadas.

La arquitectura habitual se organiza en tres niveles:

```text
Diseño técnico del test
  UFT One

Gestión del ciclo de calidad
  OpenText ALM / Application Quality Management

Ejecución remota o distribuida
  Hosts UFT, Remote Agent, Functional Testing Lab, CI/CD, cloud browsers o contenedores soportados
```

UFT One se usa para construir y depurar las pruebas. ALM se usa para organizar pruebas, campañas, ejecuciones, resultados, requisitos y defectos. Los entornos remotos permiten ejecutar esas pruebas fuera de la máquina local del diseñador, ya sea en hosts Windows, navegadores cloud o contenedores soportados.

---

## 2. Diseño de pruebas en UFT One

### 2.1. GUI Tests y estructura básica

Una prueba GUI en UFT One se organiza en torno a acciones, scripts, repositorios de objetos, recursos asociados y resultados de ejecución.

Una estructura típica sería:

```text
Test UFT
  Action1 / Action_Preparacion / Action_Ejecucion / Action_Validacion
  Object Repository local o compartido
  Function Libraries
  DataTable
  Recovery Scenarios
  Run Settings
```

La prueba puede comenzar con una grabación, pero esa grabación debe entenderse como un punto de partida. El flujo profesional consiste en revisar los objetos aprendidos, limpiar nombres, extraer funciones reutilizables, añadir reporting, parametrizar datos y definir validaciones robustas.

---

## 3. Identificación de objetos y Object Repository

### 3.1. Modelo de objetos

UFT One representa los elementos de la aplicación como objetos de prueba. En una aplicación web pueden aparecer objetos como:

```text
Browser
Page
WebEdit
WebButton
WebElement
Link
WebList
WebCheckBox
WebRadioGroup
```

Cada objeto tiene un nombre lógico dentro del repositorio y una descripción técnica que UFT usa para encontrarlo durante la ejecución.

Ejemplo:

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").Set "10/10/2025"
```

En esa línea:

```text
Browser("App CURA")
Page("Formulario Reserva")
WebEdit("Caja Fecha")
```

son nombres lógicos. No son necesariamente los nombres reales del DOM. El repositorio contiene las propiedades reales usadas para identificar cada objeto.

### 3.2. Object Spy y Object Identification Center

El Object Spy permite inspeccionar objetos de la aplicación y ver sus propiedades nativas, su jerarquía y la forma en que UFT los representa. El Object Identification Center permite espiar objetos, añadir pasos al test y agregar objetos al repositorio local, compartido o externo. [R1]

### 3.3. Repositorio local y repositorio compartido

UFT soporta repositorios locales y compartidos. Los objetos de un repositorio local están disponibles para la acción asociada; los repositorios compartidos pueden asociarse a varias acciones. Esto permite mantener una biblioteca común de objetos para varias pruebas o acciones. [R2]

El patrón recomendable es:

```text
Repositorio local
  útil para pruebas pequeñas, prototipos o elementos muy específicos

Repositorio compartido
  útil para pantallas comunes, aplicaciones estables y suites corporativas
```

Ejemplo de organización:

```text
repositories/
  CURA_OR.tsr

lib/
  Cura_Navigation.vbs
  Cura_LoginPage.vbs
  Cura_AppointmentPage.vbs
  Common_Asserts.vbs
  Common_Evidence.vbs

tests/
  TC01_Login_OK
  TC02_Login_KO
  TC03_Alta_Cita_OK
```

El repositorio compartido es común porque vive en un fichero reutilizable, pero debe asociarse a los tests o acciones que lo necesitan.

---

## 4. Diseño mantenible de scripts

### 4.1. De grabación lineal a prueba estructurada

Una grabación inicial suele producir pasos directos como:

```vbscript
Browser("App CURA").Page("Home").Link("Boton Reserva Cita").Click
Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").Set "10/10/2025"
Browser("App CURA").Page("Formulario Reserva").WebButton("Boton Reserva").Click
```

Esto funciona, pero no es mantenible si se repite en muchos tests.

Una estructura más limpia sería:

```vbscript
Option Explicit

Call Given_UsuarioAutenticado()
Call When_SolicitaCita(Facility, Readmission, Program, Fecha, Comentario)
Call Then_SeMuestraConfirmacionCita()
```

La idea es separar:

```text
Test
  expresa el caso

Function Libraries
  implementan acciones reutilizables

Object Repository
  identifica objetos

DataTable
  aporta datos de prueba
```

### 4.2. Function Libraries

Las Function Libraries son ficheros `.vbs` reutilizables que se asocian al test desde los recursos del test. Sirven para extraer funciones comunes: navegación, login, operaciones de formularios, validaciones, llamadas auxiliares y evidencias.

Ejemplo:

```vbscript
Sub LoginPage_LoginAs(username, securePassword)

    Browser("App CURA").Page("Login").WebEdit("Usuario").Set username
    Browser("App CURA").Page("Login").WebEdit("Password").SetSecure securePassword
    Browser("App CURA").Page("Login").WebButton("Login").Click

End Sub
```

Las funciones reutilizables deberían recibir datos por parámetros. No conviene que una librería dependa directamente de la DataTable de un test concreto.

Mejor:

```vbscript
username = DataTable("username", dtGlobalSheet)
securePassword = DataTable("password", dtGlobalSheet)

Call LoginPage_LoginAs(username, securePassword)
```

que:

```vbscript
Sub LoginPage_LoginAs()
    username = DataTable("username", dtGlobalSheet)
End Sub
```

---

## 5. Parametrización y DataTables

### 5.1. DataTable interna y externa

UFT permite introducir datos manualmente en la DataTable o asociar un fichero externo. La documentación oficial indica que se puede añadir una tabla externa desde los settings del test y también subir un Excel como recurso en ALM Test Resources para usarlo desde UFT. [R3]

Una tabla sencilla para login podría ser:

```text
username      | password        | expectedResult
John Doe      | pass_cifrada_ok | OK
usuario_malo | pass_cifrada_ko | KO
```

Lectura en VBScript:

```vbscript
Dim username
Dim securePassword
Dim expectedResult

username = DataTable("username", dtGlobalSheet)
securePassword = DataTable("password", dtGlobalSheet)
expectedResult = DataTable("expectedResult", dtGlobalSheet)
```

### 5.2. Global Sheet y Local Sheet

La Global Sheet es global dentro del test. No es una tabla global para toda la solución.

```vbscript
DataTable("username", dtGlobalSheet)
```

lee de la hoja global del test actual.

La Local Sheet pertenece a la acción actual:

```vbscript
DataTable("username", dtLocalSheet)
```

También puede referenciarse una hoja concreta por nombre de acción, aunque esto acopla el script al nombre de la acción.

### 5.3. Iteraciones

UFT permite configurar el número de iteraciones para una acción o para el test. Entre las opciones documentadas están ejecutar una sola iteración, ejecutar todas las filas de datos o ejecutar un rango concreto de filas. [R3]

Conceptualmente:

```text
Run one iteration only
  ejecuta una fila

Run on all data rows
  ejecuta una iteración por cada fila

Run from data row X to Y
  ejecuta un rango
```

Esto permite construir pruebas data-driven sin escribir manualmente un bucle `For`.

---

## 6. Validaciones, checkpoints y reporting

### 6.1. Validar es convertir una automatización en una prueba

Una automatización que solo hace clics no es una prueba completa. Una prueba debe comprobar resultados.

En UFT se pueden usar:

```text
Checkpoints
CheckProperty
GetROProperty + Reporter.ReportEvent
Funciones propias de assert
```

### 6.2. Checkpoints

Los checkpoints permiten definir comprobaciones desde la interfaz de UFT. Pueden comprobar propiedades de objetos, textos, páginas, tablas o respuestas, dependiendo del tipo de prueba y objeto.

Ejemplo generado:

```vbscript
Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation").Check CheckPoint("Appointment Confirmation")
```

El Object Repository responde a “cómo encuentro el objeto”. El checkpoint responde a “qué espero de ese objeto”.

### 6.3. Validación por código

Ejemplo con `GetROProperty`:

```vbscript
Dim texto

texto = Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation").GetROProperty("innertext")

If texto = "Appointment Confirmation" Then
    Reporter.ReportEvent micPass, "Confirmación", "Texto correcto: " & texto
Else
    Reporter.ReportEvent micFail, "Confirmación", "Texto esperado: Appointment Confirmation / Texto real: " & texto
    ExitTest
End If
```

Para inputs de texto se suele leer la propiedad `value`:

```vbscript
valorActual = Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").GetROProperty("value")
```

### 6.4. Librería de asserts

Como patrón mantenible, puede crearse una librería propia:

```vbscript
Sub Assert_Equals(expectedValue, actualValue, stepName)

    If CStr(expectedValue) = CStr(actualValue) Then
        Reporter.ReportEvent micPass, stepName, "Valor correcto: " & CStr(actualValue)
    Else
        Reporter.ReportEvent micFail, stepName, _
            "Esperado: " & CStr(expectedValue) & " / Actual: " & CStr(actualValue)
        ExitTest
    End If

End Sub
```

---

## 7. Evidencias y capturas

Las capturas deben guardarse en el directorio de resultados de la ejecución, no en rutas absolutas. UFT expone variables de entorno propias, como `Environment.Value("ResultDir")`, que permiten construir rutas relativas a la ejecución.

Ejemplo de función reutilizable:

```vbscript
Function GetTimestamp()

    GetTimestamp = Year(Now) & _
                   Right("0" & Month(Now), 2) & _
                   Right("0" & Day(Now), 2) & "_" & _
                   Right("0" & Hour(Now), 2) & _
                   Right("0" & Minute(Now), 2) & _
                   Right("0" & Second(Now), 2)

End Function


Function BuildEvidencePath(filePrefix)

    Dim resultDir
    resultDir = Environment.Value("ResultDir")

    BuildEvidencePath = resultDir & "\" & filePrefix & "_" & GetTimestamp() & ".png"

End Function


Sub CaptureObjectEvidence(testObject, evidenceName)

    Dim filePath

    filePath = BuildEvidencePath(evidenceName)

    testObject.CaptureBitmap filePath, True

    Reporter.ReportEvent micDone, "Evidencia", "Captura guardada: " & filePath

End Sub
```

Uso:

```vbscript
Call CaptureObjectEvidence( _
    Browser("App CURA").Page("Formulario Reserva"), _
    "formulario_reserva_antes_de_enviar" _
)
```

---

## 8. Sincronización, estabilidad y manejo de errores

### 8.1. Esperar condiciones, no segundos

La estabilidad de las pruebas UI depende en gran medida de la sincronización. En lugar de usar esperas fijas, conviene esperar a que aparezcan objetos o cambien propiedades.

Ejemplo:

```vbscript
If Browser("App CURA").Page("Formulario Reserva").WebButton("Boton Reserva").Exist(10) Then
    Browser("App CURA").Page("Formulario Reserva").WebButton("Boton Reserva").Click
Else
    Reporter.ReportEvent micFail, "Reserva", "No aparece el botón de reserva"
    ExitTest
End If
```

### 8.2. Recovery Scenarios

Los Recovery Scenarios se usan para gestionar situaciones inesperadas que bloquean la ejecución: popups, ventanas inesperadas, errores de aplicación o estados transversales que pueden aparecer en varios tests.

No deben sustituir a una buena sincronización ni ocultar errores reales. Su papel es actuar como mecanismo de recuperación controlada.

Ejemplos de uso:

```text
Si aparece popup de cookies
  cerrar popup
  repetir el paso o continuar

Si aparece error grave de aplicación
  capturar evidencia
  marcar fallo
  detener ejecución
```

---

## 9. API Tests en UFT

Además de GUI Tests, UFT permite crear API Tests basados en flujos de actividades. En pruebas REST se define un servicio, recursos, métodos, entradas, salidas y checkpoints. El tutorial oficial de OpenText muestra el patrón de crear métodos REST, añadirlos al canvas y enlazar salidas de pasos anteriores con entradas posteriores. [R4]

Un caso típico:

```text
POST /citas
  crea una cita
  devuelve un id

GET /citas/{id}
  recupera la cita creada
  valida que los datos coinciden
```

Conceptualmente:

```text
Post_Cita.id → Get_Cita.idCita
```

El patrón oficial consiste en definir propiedades de entrada y salida, añadir los métodos al flujo y usar `Link to data source` para alimentar una entrada de un paso con la salida de un paso anterior. [R4]

---

## 10. Integración conceptual con ALM

### 10.1. Papel de UFT y papel de ALM

UFT One es la herramienta de diseño, mantenimiento, depuración y ejecución técnica de tests automatizados.

OpenText ALM / Application Quality Management organiza el ciclo de calidad:

```text
Requirements
  requisitos

Test Plan
  catálogo de pruebas

Test Lab
  conjuntos de ejecución

Runs
  resultados de ejecución

Defects
  incidencias vinculadas a pruebas o ejecuciones
```

La documentación oficial indica que, al integrar UFT con ALM, se pueden ejecutar tests almacenados en ALM desde UFT, desde un cliente ALM instalado o desde un cliente ALM remoto. [R5]

### 10.2. Conexión UFT-ALM

UFT se conecta a ALM mediante la opción de conexión a ALM. Una vez conectado, los tests pueden almacenarse en el repositorio ALM y formar parte del ciclo de gestión de calidad. [R6]

### 10.3. Ejecución desde ALM

Cuando se lanza un test desde ALM, se activa el host donde debe ejecutarse UFT. La documentación oficial indica que, al ejecutar desde ALM, se abre el UFT Remote Agent en la máquina donde corre el test. El Remote Agent determina cómo se comporta UFT cuando la ejecución se inicia desde una aplicación remota como ALM. [R5]

Además, para que otras herramientas puedan llamar a UFT, debe activarse la opción de permitir que otros productos ejecuten tests y componentes desde las opciones de Test Runs de UFT. [R5]

Arquitectura conceptual:

```text
ALM Test Lab
  selecciona qué ejecutar

UFT Remote Agent
  recibe la ejecución en el host

UFT One / Runtime Engine
  ejecuta técnicamente el test

Run Results / ALM
  registran resultados, evidencias y estado
```

---

## 11. Delegación de ejecución en entornos remotos

### 11.1. Host remoto con UFT

La forma clásica de delegar ejecución consiste en tener uno o varios hosts Windows con UFT instalado y configurado. ALM o una herramienta CI/CD solicita la ejecución, y el host ejecuta la prueba.

Elementos necesarios:

```text
UFT instalado o runtime disponible
licencia disponible
add-ins necesarios cargados
navegadores y extensiones configurados
conexión a ALM si aplica
Remote Agent configurado
permisos para ejecución remota
```

### 11.2. Ejecución oculta y Remote Agent

Cuando ALM activa UFT para ejecutar un test en un test set, UFT puede abrirse y correr en modo oculto por defecto para mejorar rendimiento. El comportamiento se controla desde el Remote Agent. [R5]

Esto es importante porque la ejecución remota no se comporta como una sesión manual normal. Deben controlarse:

```text
sesión de usuario
bloqueo o cierre de sesión
permisos de ejecución
navegadores disponibles
resolución o entorno gráfico
acceso a recursos externos
```

---

## 12. Cloud browsers con Functional Testing Lab

### 12.1. Modelo conceptual

Para pruebas web en navegadores cloud, UFT se apoya en OpenText Functional Testing Lab. La documentación oficial indica que el Web Add-in de UFT usa Functional Testing Lab para ejecutar Web tests en cloud browsers. [R7]

Arquitectura conceptual:

```text
ALM / CI/CD
  orquesta la ejecución

Host UFT
  ejecuta el test

Functional Testing Lab
  proporciona el navegador cloud

Cloud browser
  ejecuta la aplicación web
```

ALM no ejecuta directamente un navegador cloud. ALM organiza la campaña y lanza el test. El motor UFT ejecuta el test y, según configuración, usa Functional Testing Lab para utilizar un navegador cloud.

### 12.2. Limitaciones operativas documentadas

OpenText documenta una limitación importante: en cloud browsers se pueden ejecutar tests, pero no espiar aplicaciones, grabar pasos ni ver la aplicación mientras el test corre. [R7]

Por tanto, el flujo normal es:

```text
Diseño y depuración
  navegador local

Ejecución remota / cross-browser
  cloud browsers desde Functional Testing Lab
```

### 12.3. Prerrequisitos web

Para web testing, UFT requiere el Web Add-in y la extensión del agente de Functional Testing en navegadores como Chrome o Edge. La documentación del Web Add-in describe estos prerrequisitos y menciona explícitamente la ejecución en cloud browsers proporcionados por Functional Testing Lab. [R8]

---

## 13. Headless Chrome y ejecución paralela

UFT soporta escenarios de ejecución web en navegadores específicos, incluido `Chrome_Headless`, dentro del soporte de pruebas web paralelas. La documentación de ejecución paralela enumera navegadores soportados para GUI Web tests, incluyendo Chrome, Chrome_Headless, Edge, Firefox, IE y Safari. [R9]

Esto permite explicar que `Chrome_Headless` es un entorno de ejecución válido dentro de escenarios soportados de UFT para pruebas web.

---

## 14. Contenedores para Chrome Headless

### 14.1. Windows Docker containers

OpenText incorporó soporte para ejecutar pruebas web y pruebas web AI-based en Headless Chrome dentro de contenedores Windows Docker. En la documentación de novedades de UFT 23.4 aparece como technical preview, y en la documentación de 24.4 se indica que la ejecución de pruebas web y AI-based web tests en Windows Docker container pasó a estar oficialmente soportada. [R10] [R11]

Por tanto, el modelo soportado que debe explicarse es:

```text
UFT One / Functional Testing
  dentro de un entorno Docker Windows soportado

Headless Chrome
  navegador usado para ejecutar pruebas web

Test web / AI-based web test
  prueba que se ejecuta en ese entorno
```

### 14.2. Papel dentro de una arquitectura corporativa

Los contenedores no sustituyen a ALM. ALM sigue organizando campañas, sets y resultados. Los contenedores forman parte de la capa de ejecución.

Arquitectura conceptual:

```text
ALM Test Lab o pipeline CI/CD
  decide qué se ejecuta

Infraestructura de ejecución
  host Windows / orquestador / agente CI

Contenedor Windows con UFT
  ejecuta web tests soportados

Headless Chrome
  navegador dentro del entorno de ejecución
```

### 14.3. Cuándo tiene sentido

Este modelo tiene sentido cuando se busca:

```text
entornos reproducibles
ejecución web automatizada
integración con pipelines
aislamiento de dependencias
ejecución sobre Headless Chrome
escalabilidad controlada
```

No debe presentarse como sustituto de todo el modelo UFT/ALM, sino como una opción concreta de ejecución para pruebas web soportadas.

---

## 15. Ejecución desde CI/CD y ALM

Además de ALM, UFT puede integrarse con herramientas CI/CD. La documentación oficial incluye escenarios donde herramientas como Bamboo o Azure DevOps ejecutan tests almacenados en ALM o integran ejecuciones UFT dentro de pipelines. [R12] [R13]

El patrón conceptual es:

```text
Pipeline
  dispara ejecución

ALM
  aporta test set, test almacenado o trazabilidad

Host UFT / agente
  ejecuta

Resultados
  se publican en ALM, pipeline o ambos
```

Esto permite separar responsabilidades:

```text
ALM
  gobierno de calidad

CI/CD
  automatización de ejecución

UFT
  motor de prueba funcional

Functional Testing Lab / Docker / cloud browser
  infraestructura de ejecución
```

---

## 16. Modelo completo de referencia

Una arquitectura corporativa completa puede representarse así:

```text
                         ┌────────────────────────┐
                         │        ALM / AQM        │
                         │ Requirements           │
                         │ Test Plan              │
                         │ Test Lab               │
                         │ Runs / Defects         │
                         └───────────┬────────────┘
                                     │
                                     │ lanza / organiza
                                     ▼
                         ┌────────────────────────┐
                         │ UFT Remote Agent / Host │
                         │ UFT One / Runtime       │
                         │ Add-ins / Licencia      │
                         └───────────┬────────────┘
                                     │
                  ┌──────────────────┼──────────────────┐
                  │                  │                  │
                  ▼                  ▼                  ▼
        ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────┐
        │ Browser local   │ │ Functional       │ │ Windows Docker       │
        │ o desktop app   │ │ Testing Lab      │ │ container            │
        │                 │ │ cloud browsers   │ │ Headless Chrome      │
        └─────────────────┘ └─────────────────┘ └─────────────────────┘
```

---

## 17. Buenas prácticas de diseño

### 17.1. Separar responsabilidades

```text
Object Repository
  identificación de objetos

Function Libraries
  lógica reutilizable

DataTable
  datos

Actions
  estructura de flujo

ALM
  gestión corporativa de pruebas

Remote execution
  ejecución distribuida
```

### 17.2. Evitar acoplamientos innecesarios

Evitar:

```text
rutas absolutas
datos hardcodeados
selectores frágiles
dependencia directa de nombres de actions
librerías que leen directamente de DataTable
acciones enormes
tests que dependen del orden de ejecución de otros tests
```

Promover:

```text
nombres funcionales de objetos
repositorios compartidos gobernados
funciones reutilizables
datos parametrizados
evidencias en ResultDir
validaciones explícitas
ejecución independiente por test
```

### 17.3. Diseñar para ejecución remota desde el principio

Una prueba diseñada solo para ejecutarse manualmente en el equipo del automatizador puede fallar cuando se delega en ALM, un host remoto, un cloud browser o un contenedor.

Por eso conviene controlar:

```text
configuración del navegador
extensiones
variables de entorno UFT
rutas relativas
datos externos
licencias
sesión de usuario
resultados
capturas
timeouts
sincronización
```

---

## 18. Conclusión

UFT One debe entenderse como la herramienta de construcción técnica de pruebas funcionales automatizadas. ALM aporta la capa de gobierno, planificación, trazabilidad, ejecución organizada y gestión de resultados. Los entornos remotos amplían la capacidad de ejecución mediante hosts UFT, Functional Testing Lab, cloud browsers, integraciones CI/CD y contenedores soportados para escenarios concretos como web tests en Headless Chrome.

La clave de una arquitectura mantenible no es solo que el test funcione en local, sino que esté diseñado para vivir dentro de un ciclo corporativo:

```text
diseño claro
objetos gobernados
datos parametrizados
validaciones explícitas
recursos reutilizables
ejecución delegable
resultados trazables
```

Ese es el paso de una automatización puntual a una suite funcional sostenible.

---

## Referencias oficiales usadas

- Enlace: [1]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Spy.htm?utm_source=chatgpt.com "Use the Object Spy - ADM Help Centers"
- Enlace: [2]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/CS_ORM_OR_Window.htm "Object Repository Window"
- Enlace: [3]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Define_DT_Task.htm "Define and manage data tables"
- Enlace: [4]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/UFT_SVN_Integration.htm?utm_source=chatgpt.com "Version - control systems - ADM Help Centers"
- Enlace: [5]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/z_Ch_ALM_Running.htm "Running tests from OpenText Application Quality Management"
- Enlace: [6]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Connection_to_TestDirector.htm?utm_source=chatgpt.com "Connect to OpenText Application Quality Management"
- Enlace: [7]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/Landing_Pages/Mobile_Help_Link.htm "OpenText Functional Testing Lab"
- Enlace: [8]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/Addins_Guide/z_Sxn_AddinWeb.htm "Web Add-in"
- Enlace: [9]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Parallel-test-runs-overview.htm "Run  tests in parallel"
- Enlace: [10]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/WhatsNew/whats_new_23.4.htm "What's new in version 23.4"
- Enlace: [11]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/WhatsNew/whats-new-24.4.htm "What's new in version 24.4"
- Enlace: [12]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/UFT_Tools/Azure_DevOps_Extension/uft-azure-devops-run-alm-lm.htm?utm_source=chatgpt.com "Use Azure DevOps to run tests from ALM Lab Management"
- Enlace: [13]: https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/UFT_Tools/Bamboo_Plugin/run_tests_from_ALM.htm?utm_source=chatgpt.com "Run tests from OpenText Application Quality Management"
