# Guía práctica de VBScript y objetos útiles en OpenText UFT One

## 1. Objetivo del documento

Este documento recoge las funciones, objetos y patrones de código más útiles para trabajar con **OpenText UFT One** en pruebas funcionales automatizadas.

El objetivo no es hacer una referencia exhaustiva de todo VBScript, sino ofrecer una guía práctica para alumnos que están empezando a automatizar pruebas con UFT y necesitan entender:

* qué funciones básicas de VBScript se usan con frecuencia;
* qué objetos propios de UFT aparecen habitualmente;
* cómo leer datos desde DataTable;
* cómo reportar resultados;
* cómo validar objetos y textos;
* cómo capturar evidencias;
* cómo estructurar código reutilizable en Function Libraries.

---

# 2. Tres niveles distintos que conviene separar

En UFT se mezclan tres mundos diferentes:

```text
1. VBScript estándar
2. Objetos propios de UFT
3. Funciones propias creadas por el equipo
```

## 2.1. VBScript estándar

Es el lenguaje de scripting usado en los **GUI Tests** de UFT.

Ejemplos:

```vbscript
Dim nombre
nombre = "John Doe"

If nombre = "John Doe" Then
    Reporter.ReportEvent micPass, "Usuario", "Usuario correcto"
End If
```

Aquí entran funciones como:

```vbscript
Left
Right
Mid
InStr
Replace
Date
Now
CStr
CBool
CInt
Trim
UCase
LCase
```

## 2.2. Objetos propios de UFT

Son objetos que no pertenecen al VBScript estándar, sino al modelo de automatización de UFT.

Ejemplos:

```vbscript
Browser("App CURA")
Page("Formulario Reserva")
WebEdit("Caja Fecha")
Reporter
DataTable
Environment
SystemUtil
Desktop
```

Estos objetos permiten interactuar con aplicaciones, leer datos, reportar resultados y manejar el entorno de ejecución.

## 2.3. Funciones propias del proyecto

Son funciones o subrutinas creadas por el equipo para reutilizar lógica.

Ejemplo:

```vbscript
Call LoginPage_LoginAs(username, securePassword)
Call Assert_ObjectExists(obj, 10, "Validar objeto")
Call CaptureObjectEvidence(pageObject, "formulario_reserva")
```

Normalmente se guardan en ficheros `.vbs` asociados al test como **Function Libraries**.

---

# 3. Sintaxis básica de VBScript útil en UFT

## 3.1. Declaración de variables

Se recomienda usar siempre:

```vbscript
Option Explicit
```

Esto obliga a declarar las variables antes de usarlas.

Ejemplo:

```vbscript
Option Explicit

Dim username
Dim password

username = "John Doe"
password = "ThisIsNotAPassword"
```

Ventaja:

```text
Evita errores por variables mal escritas.
```

Ejemplo de error que `Option Explicit` ayuda a detectar:

```vbscript
Dim username

usernme = "John Doe"
```

Sin `Option Explicit`, VBScript podría crear una variable nueva accidentalmente. Con `Option Explicit`, UFT avisará de que `usernme` no está declarada.

---

## 3.2. Comentarios

En VBScript los comentarios empiezan con comilla simple:

```vbscript
' Esto es un comentario
```

Ejemplo:

```vbscript
' Datos de entrada
Dim Facility
Dim Program
Dim Fecha
```

---

## 3.3. Condicionales

```vbscript
If condicion Then
    ' instrucciones
End If
```

Ejemplo:

```vbscript
If username = "John Doe" Then
    Reporter.ReportEvent micPass, "Usuario", "Usuario válido"
Else
    Reporter.ReportEvent micFail, "Usuario", "Usuario incorrecto"
End If
```

También se puede usar `ElseIf`:

```vbscript
If expectedResult = "OK" Then
    Call Then_SeMuestraPantallaReserva()
ElseIf expectedResult = "KO" Then
    Call Then_SeMuestraErrorLogin()
Else
    Reporter.ReportEvent micFail, "Datos", "Resultado esperado no reconocido"
    ExitTest
End If
```

---

## 3.4. Bucles

### For

```vbscript
Dim i

For i = 1 To 10
    Reporter.ReportEvent micDone, "Iteración", CStr(i)
Next
```

### For Each

```vbscript
Dim item

For Each item In coleccion
    ' trabajar con cada elemento
Next
```

### While

```vbscript
Dim contador
contador = 1

While contador <= 5
    Reporter.ReportEvent micDone, "Contador", CStr(contador)
    contador = contador + 1
Wend
```

---

# 4. Funciones de conversión

Estas funciones sirven para convertir valores entre tipos.

```vbscript
CStr(valor)    ' convierte a texto
CInt(valor)    ' convierte a entero
CLng(valor)    ' convierte a entero largo
CDbl(valor)    ' convierte a decimal
CBool(valor)   ' convierte a booleano
```

Ejemplo:

```vbscript
Dim edadTexto
Dim edadNumero

edadTexto = "48"
edadNumero = CInt(edadTexto)

If edadNumero > 18 Then
    Reporter.ReportEvent micPass, "Edad", "Mayor de edad"
End If
```

Ejemplo habitual en asserts:

```vbscript
If CStr(expectedValue) = CStr(actualValue) Then
    Reporter.ReportEvent micPass, "Comparación", "Valores iguales"
End If
```

Esto evita problemas cuando un valor viene como número y otro como texto.

---

# 5. Funciones de texto

## 5.1. Len

Devuelve la longitud de un texto.

```vbscript
Dim longitud

longitud = Len("John Doe")
```

Resultado:

```text
8
```

---

## 5.2. Left

Devuelve los primeros caracteres de una cadena.

```vbscript
Dim texto

texto = Left("Medicare", 3)
```

Resultado:

```text
Med
```

---

## 5.3. Right

Devuelve los últimos caracteres de una cadena.

```vbscript
Dim texto

texto = Right("2026", 2)
```

Resultado:

```text
26
```

Uso típico para formatear fechas:

```vbscript
Right("0" & Month(Date), 2)
```

Si el mes es junio:

```text
Month(Date) = 6
"0" & 6 = "06"
Right("06", 2) = "06"
```

Si el mes es octubre:

```text
Month(Date) = 10
"0" & 10 = "010"
Right("010", 2) = "10"
```

---

## 5.4. Mid

Extrae texto desde una posición determinada.

```vbscript
Dim parte

parte = Mid("Appointment Confirmation", 13, 12)
```

---

## 5.5. InStr

Busca un texto dentro de otro.

```vbscript
Dim posicion

posicion = InStr("Appointment Confirmation", "Confirmation")
```

Si lo encuentra, devuelve una posición mayor que cero.

Ejemplo de validación:

```vbscript
If InStr(responseBody, "CONFIRMED") > 0 Then
    Reporter.ReportEvent micPass, "Respuesta API", "Contiene CONFIRMED"
Else
    Reporter.ReportEvent micFail, "Respuesta API", "No contiene CONFIRMED"
End If
```

---

## 5.6. Replace

Sustituye texto.

```vbscript
Dim resultado

resultado = Replace("Hola mundo", "mundo", "UFT")
```

Resultado:

```text
Hola UFT
```

Uso típico en escape de JSON:

```vbscript
result = Replace(result, """", "\""")
```

---

## 5.7. Trim, LCase y UCase

```vbscript
Trim(texto)   ' quita espacios al principio y al final
LCase(texto)  ' pasa a minúsculas
UCase(texto)  ' pasa a mayúsculas
```

Ejemplo:

```vbscript
Dim resultado

resultado = Trim(LCase("  OK  "))

If resultado = "ok" Then
    Reporter.ReportEvent micPass, "Normalización", "Resultado correcto"
End If
```

---

# 6. Fechas y horas

## 6.1. Date y Now

```vbscript
Date  ' fecha actual
Now   ' fecha y hora actual
```

Ejemplo:

```vbscript
Reporter.ReportEvent micDone, "Fecha", CStr(Date)
Reporter.ReportEvent micDone, "Fecha y hora", CStr(Now)
```

---

## 6.2. Componentes de fecha

```vbscript
Day(Date)
Month(Date)
Year(Date)
```

Ejemplo:

```vbscript
Dim dia
Dim mes
Dim anio

dia = Day(Date)
mes = Month(Date)
anio = Year(Date)
```

---

## 6.3. Componentes de hora

```vbscript
Hour(Now)
Minute(Now)
Second(Now)
```

Ejemplo:

```vbscript
Dim hora

hora = Hour(Now)
```

---

## 6.4. Fecha actual en formato dd/mm/yyyy

Función reutilizable:

```vbscript
Function Today_ddMMyyyy()

    Today_ddMMyyyy = Right("0" & Day(Date), 2) & "/" & _
                     Right("0" & Month(Date), 2) & "/" & _
                     Year(Date)

End Function
```

Uso:

```vbscript
Dim fecha

fecha = Today_ddMMyyyy()

Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").Set fecha
```

---

## 6.5. Timestamp para evidencias

```vbscript
Function GetTimestamp()

    GetTimestamp = Year(Now) & _
                   Right("0" & Month(Now), 2) & _
                   Right("0" & Day(Now), 2) & "_" & _
                   Right("0" & Hour(Now), 2) & _
                   Right("0" & Minute(Now), 2) & _
                   Right("0" & Second(Now), 2)

End Function
```

Ejemplo de resultado:

```text
20260602_124530
```

---

# 7. Manejo de errores

VBScript permite capturar errores con:

```vbscript
On Error Resume Next
```

Esto significa:

```text
Si hay un error, no pares. Continúa con la siguiente línea.
```

Debe usarse con cuidado.

## 7.1. Uso correcto

```vbscript
Sub SafeClickLogin()

    On Error Resume Next

    Browser("App CURA").Page("Login").WebButton("Login").Click

    If Err.Number <> 0 Then
        Reporter.ReportEvent micFail, "Login", "Error al pulsar Login: " & Err.Description
        Err.Clear
        On Error GoTo 0
        ExitTest
    End If

    On Error GoTo 0

End Sub
```

## 7.2. Uso peligroso

```vbscript
On Error Resume Next

' 300 líneas de test
```

Esto puede ocultar errores reales.

La regla práctica:

```text
On Error Resume Next debe usarse como anestesia local:
en un bloque pequeño, comprobando Err.Number y restaurando con On Error GoTo 0.
```

---

# 8. Reporter

`Reporter` es el objeto de UFT que permite escribir eventos en el resultado de ejecución.

## 8.1. ReportEvent

Sintaxis habitual:

```vbscript
Reporter.ReportEvent estado, titulo, descripcion
```

Estados frecuentes:

```vbscript
micPass
micFail
micDone
micWarning
```

Ejemplo:

```vbscript
Reporter.ReportEvent micPass, "Login", "El login se realizó correctamente"
Reporter.ReportEvent micFail, "Login", "No se mostró la pantalla esperada"
Reporter.ReportEvent micDone, "Datos", "Usuario utilizado: John Doe"
Reporter.ReportEvent micWarning, "Recovery", "Se detectó un popup inesperado"
```

## 8.2. Uso recomendado

Una prueba mantenible debe reportar:

```text
- inicio del caso;
- datos relevantes no sensibles;
- acciones importantes;
- validaciones pasadas;
- fallos con detalle;
- evidencias generadas;
- fin del caso.
```

Ejemplo:

```vbscript
Reporter.ReportEvent micDone, "TC_Alta_Cita", "Inicio del caso de prueba"

Call SolicitarCita(Facility, Readmission, Program, Fecha, Comentario)

Reporter.ReportEvent micDone, "TC_Alta_Cita", "Fin del caso de prueba"
```

---

# 9. DataTable

`DataTable` permite leer y escribir datos asociados al test.

## 9.1. Leer desde la Global Sheet

```vbscript
username = DataTable("username", dtGlobalSheet)
```

Ejemplo:

```vbscript
Dim username
Dim securePassword

username = DataTable("username", dtGlobalSheet)
securePassword = DataTable("password", dtGlobalSheet)
```

La Global Sheet es global **dentro del test actual**, no para toda la solución.

---

## 9.2. Leer desde la hoja local de la Action

```vbscript
username = DataTable("username", dtLocalSheet)
```

Esto lee de la DataTable local de la acción que se está ejecutando.

---

## 9.3. Leer desde una hoja por nombre

```vbscript
username = DataTable("username", "Action_Login")
```

Esto funciona, pero acopla el código al nombre de la acción. Si cambias el nombre de la acción, el script puede fallar.

---

## 9.4. Importar datos desde Excel

```vbscript
DataTable.Import "C:\ruta\datos.xls"
```

Mejor usando rutas relativas al test:

```vbscript
Dim dataFile

dataFile = Environment.Value("TestDir") & "\data\login-data.xls"

DataTable.ImportSheet dataFile, "LoginData", dtGlobalSheet
```

---

## 9.5. Exportar DataTable

```vbscript
DataTable.Export Environment.Value("ResultDir") & "\datatable_resultado.xls"
```

Esto permite guardar los datos de ejecución en la carpeta de resultados.

---

## 9.6. Ejemplo data-driven

Tabla:

```text
username      | password        | expectedResult
John Doe      | pass_cifrada_ok | OK
usuario_malo | pass_cifrada_ko | KO
```

Script:

```vbscript
Dim username
Dim securePassword
Dim expectedResult

username = DataTable("username", dtGlobalSheet)
securePassword = DataTable("password", dtGlobalSheet)
expectedResult = DataTable("expectedResult", dtGlobalSheet)

Call Given_UsuarioEnPaginaDeLogin()
Call When_HaceLogin(username, securePassword)

If expectedResult = "OK" Then
    Call Then_SeMuestraPantallaDeReserva()
ElseIf expectedResult = "KO" Then
    Call Then_SeMuestraErrorDeLogin()
Else
    Reporter.ReportEvent micFail, "Datos", "Resultado esperado no reconocido: " & expectedResult
    ExitTest
End If
```

---

# 10. Environment

`Environment.Value(...)` permite leer variables de entorno propias de UFT.

## 10.1. Variables útiles

```vbscript
Environment.Value("ResultDir")
Environment.Value("TestDir")
Environment.Value("TestName")
Environment.Value("ActionName")
```

## 10.2. ResultDir

Devuelve la carpeta de resultados de la ejecución actual.

Uso típico:

```vbscript
filePath = Environment.Value("ResultDir") & "\captura.png"
```

Sirve para guardar evidencias dentro del resultado de ejecución.

---

## 10.3. TestDir

Devuelve la carpeta donde está guardado el test.

Uso típico:

```vbscript
dataFile = Environment.Value("TestDir") & "\data\login-data.xls"
```

---

## 10.4. Ejemplo de diagnóstico

```vbscript
Reporter.ReportEvent micDone, "ResultDir", Environment.Value("ResultDir")
Reporter.ReportEvent micDone, "TestDir", Environment.Value("TestDir")
Reporter.ReportEvent micDone, "TestName", Environment.Value("TestName")
Reporter.ReportEvent micDone, "ActionName", Environment.Value("ActionName")
```

---

# 11. SystemUtil

`SystemUtil` permite lanzar programas desde UFT.

Ejemplo:

```vbscript
SystemUtil.Run "chrome.exe", "https://katalon-demo-cura.herokuapp.com/"
```

Función reusable:

```vbscript
Sub Browser_OpenUrl(url)

    Reporter.ReportEvent micDone, "Navegación", "Abriendo URL: " & url

    SystemUtil.Run "chrome.exe", url

End Sub
```

Uso:

```vbscript
Call Browser_OpenUrl("https://katalon-demo-cura.herokuapp.com/")
```

---

# 12. Desktop

`Desktop` representa el escritorio del sistema.

Uso habitual:

```vbscript
Desktop.CaptureBitmap filePath, True
```

Ejemplo:

```vbscript
Desktop.CaptureBitmap Environment.Value("ResultDir") & "\pantalla.png", True
```

Pero para evidencias de una página o un objeto concreto suele ser mejor usar `CaptureBitmap` sobre el objeto UFT correspondiente.

---

# 13. Métodos comunes de objetos UFT

Muchos objetos de UFT comparten métodos habituales.

## 13.1. Exist

Comprueba si el objeto existe.

```vbscript
If Browser("App CURA").Page("Login").WebEdit("Usuario").Exist(10) Then
    Reporter.ReportEvent micPass, "Usuario", "El campo usuario existe"
Else
    Reporter.ReportEvent micFail, "Usuario", "El campo usuario no existe"
    ExitTest
End If
```

`Exist(10)` espera hasta 10 segundos.

---

## 13.2. Click

Hace clic sobre un objeto.

```vbscript
Browser("App CURA").Page("Home").Link("Boton Reserva Cita").Click
```

---

## 13.3. Set

Escribe un valor en un campo.

```vbscript
Browser("App CURA").Page("Login").WebEdit("Usuario").Set "John Doe"
```

---

## 13.4. SetSecure

Escribe una contraseña cifrada.

```vbscript
Browser("App CURA").Page("Login").WebEdit("Password").SetSecure securePassword
```

---

## 13.5. Select

Selecciona un valor en listas o radio groups.

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebList("Ubicacion").Select "Tokyo CURA Healthcare Center"
```

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebRadioGroup("Programa Medico").Select "Medicare"
```

---

## 13.6. GetROProperty

Lee una propiedad real del objeto durante la ejecución.

```vbscript
valor = Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").GetROProperty("value")
```

RO significa **Runtime Object**.

Propiedades frecuentes:

```text
value
innertext
text
outertext
visible
disabled
title
href
```

---

## 13.7. GetTOProperty

Lee una propiedad del objeto tal como está definida en el Object Repository.

```vbscript
prop = Browser("App CURA").Page("Login").WebEdit("Usuario").GetTOProperty("name")
```

Diferencia:

```text
GetROProperty:
  lee el valor real en ejecución.

GetTOProperty:
  lee el valor definido en el repositorio.
```

---

## 13.8. CheckProperty

Comprueba una propiedad de un objeto.

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").CheckProperty "value", "10/10/2025", 10000
```

Esto comprueba que la propiedad `value` tenga el valor esperado en un tiempo máximo de 10000 milisegundos.

---

## 13.9. WaitProperty

Espera a que una propiedad alcance un valor.

```vbscript
If Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation").WaitProperty("visible", True, 10000) Then
    Reporter.ReportEvent micPass, "Confirmación", "La confirmación está visible"
Else
    Reporter.ReportEvent micFail, "Confirmación", "La confirmación no aparece"
    ExitTest
End If
```

---

## 13.10. CaptureBitmap

Guarda una captura del objeto.

```vbscript
Browser("App CURA").Page("Formulario Reserva").CaptureBitmap filePath, True
```

El segundo parámetro indica si se puede sobrescribir el fichero si ya existe.

```vbscript
True
```

significa:

```text
Si ya existe, sobrescríbelo.
```

---

# 14. Objetos web frecuentes

## 14.1. Browser

Representa el navegador.

```vbscript
Browser("App CURA").Sync
Browser("App CURA").Navigate "https://katalon-demo-cura.herokuapp.com/"
```

---

## 14.2. Page

Representa una página dentro del navegador.

```vbscript
Browser("App CURA").Page("Login")
```

---

## 14.3. WebEdit

Campo de texto.

```vbscript
Browser("App CURA").Page("Login").WebEdit("Usuario").Set "John Doe"
```

Leer valor:

```vbscript
valor = Browser("App CURA").Page("Login").WebEdit("Usuario").GetROProperty("value")
```

---

## 14.4. WebButton

Botón.

```vbscript
Browser("App CURA").Page("Login").WebButton("Login").Click
```

---

## 14.5. Link

Enlace.

```vbscript
Browser("App CURA").Page("Home").Link("Boton Reserva Cita").Click
```

---

## 14.6. WebList

Lista desplegable.

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebList("Ubicacion").Select "Tokyo CURA Healthcare Center"
```

---

## 14.7. WebCheckBox

Checkbox.

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebCheckBox("Check Readmision").Set "ON"
```

---

## 14.8. WebRadioGroup

Grupo de radios.

```vbscript
Browser("App CURA").Page("Formulario Reserva").WebRadioGroup("Programa Medico").Select "Medicare"
```

---

## 14.9. WebElement

Elemento genérico.

```vbscript
If Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation").Exist(10) Then
    Reporter.ReportEvent micPass, "Confirmación", "Confirmación visible"
End If
```

`WebElement` se usa mucho cuando UFT no identifica un elemento como botón, enlace, lista, etc., sino como elemento web genérico.

---

# 15. Validar el valor rellenado de un input

Para verificar el valor de un input de texto, normalmente se lee la propiedad `value`.

```vbscript
Dim valorActual
Dim valorEsperado

valorEsperado = "John Doe"

valorActual = Browser("App CURA") _
                .Page("Login") _
                .WebEdit("Usuario") _
                .GetROProperty("value")

If valorActual = valorEsperado Then
    Reporter.ReportEvent micPass, "Validar usuario", _
        "El campo usuario tiene el valor esperado: " & valorActual
Else
    Reporter.ReportEvent micFail, "Validar usuario", _
        "Esperado: " & valorEsperado & " / Actual: " & valorActual
    ExitTest
End If
```

Función reusable:

```vbscript
Sub Assert_WebEditValueEquals(webEditObject, expectedValue, stepName)

    Dim actualValue

    If Not webEditObject.Exist(10) Then
        Reporter.ReportEvent micFail, stepName, "El campo no existe"
        ExitTest
    End If

    actualValue = webEditObject.GetROProperty("value")

    If CStr(actualValue) = CStr(expectedValue) Then
        Reporter.ReportEvent micPass, stepName, _
            "Valor correcto: " & CStr(actualValue)
    Else
        Reporter.ReportEvent micFail, stepName, _
            "Esperado: " & CStr(expectedValue) & " / Actual: " & CStr(actualValue)
        ExitTest
    End If

End Sub
```

Uso:

```vbscript
Call Assert_WebEditValueEquals( _
    Browser("App CURA").Page("Login").WebEdit("Usuario"), _
    "John Doe", _
    "Validar campo usuario" _
)
```

---

# 16. Leer texto de un objeto

Para objetos de texto, normalmente se intenta leer:

```text
innertext
text
outertext
value
```

Función reusable:

```vbscript
Function GetObjectText(obj)

    Dim texto

    texto = obj.GetROProperty("innertext")

    If texto = "" Then
        texto = obj.GetROProperty("text")
    End If

    If texto = "" Then
        texto = obj.GetROProperty("outertext")
    End If

    If texto = "" Then
        texto = obj.GetROProperty("value")
    End If

    GetObjectText = Trim(texto)

End Function
```

Assert de texto:

```vbscript
Sub Assert_ObjectTextEquals(obj, expectedText, stepName)

    Dim actualText

    If Not obj.Exist(10) Then
        Reporter.ReportEvent micFail, stepName, "El objeto no existe"
        ExitTest
    End If

    actualText = GetObjectText(obj)

    If actualText = expectedText Then
        Reporter.ReportEvent micPass, stepName, _
            "Texto correcto: " & actualText
    Else
        Reporter.ReportEvent micFail, stepName, _
            "Esperado: " & expectedText & " / Actual: " & actualText
        ExitTest
    End If

End Sub
```

Uso:

```vbscript
Call Assert_ObjectTextEquals( _
    Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation"), _
    "Appointment Confirmation", _
    "Validar pantalla de confirmación" _
)
```

---

# 17. Capturas de pantalla y evidencias

No se recomienda guardar capturas en rutas absolutas como:

```text
C:\UFT\Evidencias
```

Es mejor guardarlas en:

```vbscript
Environment.Value("ResultDir")
```

Así las evidencias quedan dentro del resultado de la ejecución.

## 17.1. Función de timestamp

```vbscript
Function GetTimestamp()

    GetTimestamp = Year(Now) & _
                   Right("0" & Month(Now), 2) & _
                   Right("0" & Day(Now), 2) & "_" & _
                   Right("0" & Hour(Now), 2) & _
                   Right("0" & Minute(Now), 2) & _
                   Right("0" & Second(Now), 2)

End Function
```

## 17.2. Construir ruta de evidencia

```vbscript
Function BuildEvidencePath(filePrefix)

    Dim resultDir
    resultDir = Environment.Value("ResultDir")

    BuildEvidencePath = resultDir & "\" & filePrefix & "_" & GetTimestamp() & ".png"

End Function
```

## 17.3. Capturar cualquier objeto UFT

```vbscript
Sub CaptureObjectEvidence(testObject, evidenceName)

    Dim filePath

    filePath = BuildEvidencePath(evidenceName)

    testObject.CaptureBitmap filePath, True

    Reporter.ReportEvent micDone, "Evidencia", "Captura guardada: " & filePath

End Sub
```

Uso con una página:

```vbscript
Call CaptureObjectEvidence( _
    Browser("App CURA").Page("Formulario Reserva"), _
    "formulario_reserva_antes_de_enviar" _
)
```

Uso con un campo:

```vbscript
Call CaptureObjectEvidence( _
    Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha"), _
    "campo_fecha_rellenado" _
)
```

Uso con pantalla completa:

```vbscript
Sub CaptureDesktopEvidence(evidenceName)

    Dim filePath

    filePath = BuildEvidencePath(evidenceName)

    Desktop.CaptureBitmap filePath, True

    Reporter.ReportEvent micDone, "Evidencia", "Captura de escritorio guardada: " & filePath

End Sub
```

---

# 18. Function Libraries

Las Function Libraries permiten sacar código común a ficheros reutilizables.

Ejemplos:

```text
Common_Asserts.vbs
Common_Evidence.vbs
Cura_Navigation.vbs
Cura_LoginPage.vbs
Cura_AppointmentPage.vbs
```

## 18.1. Ejemplo de librería de navegación

```vbscript
Option Explicit

Sub Cura_OpenHomePage()

    Dim url
    url = "https://katalon-demo-cura.herokuapp.com/"

    Reporter.ReportEvent micDone, "Navegación", "Abriendo CURA Healthcare"

    SystemUtil.Run "chrome.exe", url

    If Browser("App CURA").Page("Home").Link("Boton Reserva Cita").Exist(10) Then
        Reporter.ReportEvent micPass, "Home", "Página inicial disponible"
    Else
        Reporter.ReportEvent micFail, "Home", "No se muestra la página inicial"
        ExitTest
    End If

End Sub
```

## 18.2. Ejemplo de librería de login

```vbscript
Option Explicit

Sub LoginPage_LoginAs(username, securePassword)

    Reporter.ReportEvent micDone, "Login", "Login con usuario: " & username

    If Not Browser("App CURA").Page("Login").WebEdit("Usuario").Exist(10) Then
        Reporter.ReportEvent micFail, "Login", "No existe el campo usuario"
        ExitTest
    End If

    Browser("App CURA").Page("Login").WebEdit("Usuario").Set username
    Browser("App CURA").Page("Login").WebEdit("Password").SetSecure securePassword
    Browser("App CURA").Page("Login").WebButton("Login").Click

End Sub
```

## 18.3. Ejemplo de librería de asserts

```vbscript
Option Explicit

Sub Assert_ObjectExists(obj, timeoutSeconds, stepName)

    If obj.Exist(timeoutSeconds) Then
        Reporter.ReportEvent micPass, stepName, "El objeto existe"
    Else
        Reporter.ReportEvent micFail, stepName, "El objeto no existe"
        ExitTest
    End If

End Sub


Sub Assert_Equals(expectedValue, actualValue, stepName)

    If CStr(expectedValue) = CStr(actualValue) Then
        Reporter.ReportEvent micPass, stepName, _
            "Valor correcto: " & CStr(actualValue)
    Else
        Reporter.ReportEvent micFail, stepName, _
            "Esperado: " & CStr(expectedValue) & _
            " / Actual: " & CStr(actualValue)
        ExitTest
    End If

End Sub
```

---

# 19. Ejemplo completo: alta de cita

```vbscript
Option Explicit

Dim BooleanosEnTablaDeDatos_ValorPositivo
BooleanosEnTablaDeDatos_ValorPositivo = "SI"

Dim Facility
Dim HospitalReadmission
Dim Program
Dim Fecha
Dim Comentario

Facility = DataTable("Facility", dtGlobalSheet)
HospitalReadmission = DataTable("Readmision", dtGlobalSheet)
Program = DataTable("Programa", dtGlobalSheet)
Fecha = DataTable("Fecha", dtGlobalSheet)
Comentario = DataTable("Comentario", dtGlobalSheet)

Call SolicitarCita( _
    Facility, _
    HospitalReadmission = BooleanosEnTablaDeDatos_ValorPositivo, _
    Program, _
    Fecha, _
    Comentario _
)

Call ComprobarAlta()


Sub SolicitarCita(DatoFacility, DatoHospitalReadmission, DatoProgram, DatoFecha, DatoComentario)

    Dim FechaAutogenerada
    Dim FechaEsperada

    Browser("App CURA").Page("Home").Link("Boton Reserva Cita").Click

    Browser("App CURA").Page("Formulario Reserva").WebList("Ubicacion").Select DatoFacility

    If DatoHospitalReadmission Then
        Browser("App CURA").Page("Formulario Reserva").WebCheckBox("Check Readmision").Set "ON"
    End If

    Browser("App CURA").Page("Formulario Reserva").WebRadioGroup("Programa Medico").Select DatoProgram

    Browser("App CURA").Page("Formulario Reserva").WebElement("Icono Del Calendario").Click

    If Browser("App CURA").Page("Formulario Reserva").WebElement("Dia 24 En El Calendario").Exist(1) Then

        Browser("App CURA").Page("Formulario Reserva").WebElement("Dia 24 En El Calendario").Click

        FechaEsperada = "24/" & Right("0" & Month(Date), 2) & "/" & Year(Date)

        FechaAutogenerada = Browser("App CURA") _
                                .Page("Formulario Reserva") _
                                .WebEdit("Caja Fecha") _
                                .GetROProperty("value")

        If FechaAutogenerada = FechaEsperada Then
            Reporter.ReportEvent micPass, "Fecha mediante calendario", _
                "La fecha se rellenó correctamente: " & FechaAutogenerada
        Else
            Reporter.ReportEvent micFail, "Fecha mediante calendario", _
                "Esperado: " & FechaEsperada & _
                " / Actual: " & FechaAutogenerada
        End If

    Else
        Reporter.ReportEvent micWarning, "Calendario", "No se encontró el día 24 en el calendario"
    End If

    Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja Fecha").Set DatoFecha
    Browser("App CURA").Page("Formulario Reserva").WebEdit("Caja De Comentarios").Set DatoComentario

    Call CaptureObjectEvidence( _
        Browser("App CURA").Page("Formulario Reserva"), _
        "formulario_reserva_antes_de_enviar" _
    )

    Browser("App CURA").Page("Formulario Reserva").WebButton("Boton Reserva").Click

End Sub


Sub ComprobarAlta()

    If Browser("App CURA").Page("Confirmacion").WebElement("Appointment Confirmation").Exist(10) Then

        Reporter.ReportEvent micPass, "Confirmación de cita", _
            "Se muestra la pantalla de confirmación de la cita"

    Else

        Reporter.ReportEvent micFail, "Confirmación de cita", _
            "No se muestra la pantalla de confirmación de la cita"

        ExitTest

    End If

End Sub
```

---

# 20. Ejemplo simple de llamada API desde un GUI Test

Aunque UFT tiene API Tests específicos, desde un GUI Test también se puede llamar a una API con VBScript usando `MSXML2.ServerXMLHTTP.6.0`.

Ejemplo:

```vbscript
Option Explicit

Dim http
Dim url
Dim responseBody

url = "http://52.209.155.43:8080/citas/1"

Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")

http.Open "GET", url, False
http.setRequestHeader "Accept", "application/json"
http.Send

responseBody = http.responseText

If http.Status = 200 Then
    Reporter.ReportEvent micPass, "GET cita", "HTTP 200 recibido"
Else
    Reporter.ReportEvent micFail, "GET cita", "HTTP inesperado: " & http.Status
    ExitTest
End If

Reporter.ReportEvent micDone, "Respuesta API", responseBody
```

Función reusable:

```vbscript
Function HttpGet(url)

    Dim http

    Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")

    http.Open "GET", url, False
    http.setRequestHeader "Accept", "application/json"
    http.Send

    If http.Status >= 200 And http.Status < 300 Then
        Reporter.ReportEvent micPass, "HTTP GET", "GET correcto: " & url
    Else
        Reporter.ReportEvent micFail, "HTTP GET", _
            "Error " & http.Status & " en " & url & _
            ". Respuesta: " & http.responseText
        ExitTest
    End If

    HttpGet = http.responseText

End Function
```

---

# 21. Checklist de funciones y objetos para alumnos

## VBScript básico

```text
Option Explicit
Dim
If / Else / ElseIf
For / Next
For Each
While / Wend
On Error Resume Next
On Error GoTo 0
Err.Number
Err.Description
Err.Clear
```

## Conversión

```text
CStr
CInt
CLng
CDbl
CBool
```

## Texto

```text
Len
Left
Right
Mid
InStr
Replace
Trim
LCase
UCase
```

## Fechas

```text
Date
Now
Day
Month
Year
Hour
Minute
Second
```

## UFT utilidades

```text
Reporter.ReportEvent
DataTable
Environment.Value
SystemUtil.Run
Desktop.CaptureBitmap
```

## Métodos comunes UFT

```text
Exist
Click
Set
SetSecure
Select
GetROProperty
GetTOProperty
CheckProperty
WaitProperty
CaptureBitmap
```

## Objetos web habituales

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

---

# 22. Referencias oficiales

## VBScript en UFT

OpenText UFT One Help — Programming VBScript
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Programming_VBScript.htm

## Function Libraries

OpenText UFT One Help — User-defined functions and function libraries
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/z_Ch_UserDefinedFunctions.htm

OpenText UFT One Help — Work with associated function libraries
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Working_w_lib_files_test.htm

## Reporter

OpenText UFT One Object Model Reference — Reporter Object
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Subsystems/OMRHelp/Content/OV_Supp_Util/Utility_Reporter.htm

## DataTable

OpenText UFT One Help — Define and manage data tables
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Define_DT_Task.htm

## Object Repository y Object Spy

OpenText UFT One Help — Object Identification Center
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/OIC.htm

OpenText UFT One Help — Use the Object Spy
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/Spy.htm

OpenText UFT One Help — Object Repository Manager
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Content/User_Guide/ORM.htm

## Web objects

OpenText UFT One Object Model Reference — WebEdit Object
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Subsystems/OMRHelp/Content/Web/WEBPACKAGELib~WebEdit.html

## Common Methods and Properties

OpenText UFT One Object Model Reference — Common Methods and Properties
https://admhelp.microfocus.com/uft/en/26.1/UFT_Help/Subsystems/OMRHelp/Content/Common_Methods_and_Properties/Common_Methods_and_Properties.html

---

# 23. Cierre

En UFT, VBScript es solo una parte de la automatización. Lo importante es aprender a combinar:

```text
VBScript
  para lógica básica

Object Repository
  para identificar objetos

Function Libraries
  para reutilizar código

DataTable
  para parametrizar datos

Reporter
  para documentar la ejecución

GetROProperty / CheckProperty / Exist
  para validar resultados

CaptureBitmap
  para generar evidencias
```

Una prueba mantenible no es una grabación larga. Es una combinación de objetos bien identificados, código reutilizable, datos parametrizados, validaciones explícitas y resultados interpretables.
