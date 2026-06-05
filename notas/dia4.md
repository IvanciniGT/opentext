
Opentext Functional Testing NO ES UN ENTORNO DE EJECUCION DE PRUEBAS!
ES UN ENTORNO DE DESARROLLO DE PRUEBAS.

Opentext tiene 2 herramientas para ello:
- Batch Runner
- ALM <- Test set (Suite de pruebas)
          - Añado todos los test que me interesen
          - Ejecuto el test set

En unb entorno de producción NO NECESITO el UFT para ejecutar las pruebas... ni lo quiero!
Es una herramienta ULTRAPESADA.

                                            Jenkins (CI)
                                              | ^
                                              v |
    Entornos de desarrollo UTF              ALM Central            2 Máquinas con agentes ejecutores de test         Máquinas con navegadores
    - Cada tester el suyo!         ---->                 ---->                                                 --->
      
      
      Contenedores (tiene navegador + agente UFT ) pero operan en modo headless.
      Van más rápido las pruebas, necesitan menos RAM y la actualización es mucho más sencilla.


---

Estamos probando el rellenar el formulario de petición de cita.

Hay un campo FECHA.
Ese campo se puede rellenar de 2 formas independientes:
- Mediante un calendario gráfico
- Escribiendo un texto a mano

Cuando pruebo debo probar ambas

## Mediante un calendario gráfico
- Apretar en icono calendario
- Apretar en un día (25)
- EN ESTE MOMENTO, al apretar en ese boton "Dia 25" la app rellena en automático el campo FECHA
- Capuramos DINAMICAMENTE ESE VALOR
- Y lo comparamos con el que debería: 25/MES_ACTUAL/AÑO_ACTUAL

## Escribiendo un texto a mano
- Rellenar a mano lo que tener en el EXCEL en el campo fecha.

---


Node (antiguamente NodeJS).

Es como loa máquina virtual de Java, pero para JS.

JsonServer me ofrece un fake de un servidor HTTP REST.. que me permite gestionar CRUD(Altas, bajas, recuperacion, modificacion) de 
los datos que meta en un fichero JSON (no trabaja con una BBDD de verdad)

C#

C
C++
 ++
 
C#

---

Cuando hacemos pruebas de apis HTTP,
- Una petición la hacemos usando un VERBO:
  - GET         Recuperar cosas
  - PUT         Modificar
  - DELETE      Borrar
  - POST        Crear
  - HEAD        Consultar si existen
- En una petición hay 2 partes:
  - Request (Mi petición)
  - Response (La respuesta que me da el servidor)
- En el request es donde usamos el VERBO
- En el response lo que viene es un CODIGO DE RESPUESTA: StatusCode:
  - 2XX OK
    - 201: CREATED
  - 3XX REDIRECCIONES
  - 4XX ERROR CLIENTE
    - 403 FORBIDDEN
    - 404 ERROR DE CLENTE AL HACER LA PETICION
  - 5XX ERROR SERVIDOR

Adicionalmente al Verbo en Request y al statudCode en Response, tanto en Request Como en Response hay lo que llamamos un CUERPO
- Cuerpo (body) de la petición
- Cuerpo (body) de la respuesta

Normalmente lo que mandamos es un JSON metido en el cuerpo
Ambos son opcionales:
    - GET /usuarios       Dame todos los usuarios:
      - No mando nada en el cuerpo de la petición
      - Pero en la el cuerpo de la respuesta me viene el JSON con los usuarios
    - POST /usuarios    Para crear un usuario
      - Mando un JSON en el cuerpo de la petición con los datos del nuevo usuario que quiero crear
      - Recibo en JSON en el cuerpo del response con los datos del usuario recién creado
    - HEAD /usuarios/felipe     Dime si existe el usuario felipe
      - No mando JSON ni nada en el cuerpo de la petición
      - No recibo JSON ni nada en el cuerpo de la respuesta
        - Solo recibo un 200 si existe (status Code)

Hay una cosita más que son los headers.

---

Desarrollo de las pruebas. Igual que las que hemos planteado de UI.

## Datos

En UFT los podré tener en variables, en una tabla (DataTable).. identico a los UI Test

## Plantearé el Contexto /GIVEN
## Plantearé el Action / WHEN
## Plantearé las comprobaciones / THEN

La gracia estará sobre todo en poder juntar estas pruebas con las de UI:

- Hago login
- Doy de alta un expediente/cita mediante UI
- Comprobar que llego a la pantalla de turno
- Hacer una petición directa HTTP al servidor, para recuperar ese dato... a ver si se ha dado de alta bien
- Posteriormente comprobaré en una pantalla que los datos salen bien
