
# Vocabulario en el mundo del testing

- Causa raíz  Es la razón por la que el humano comete el error.
    > Despiste por mirar a una persona (falta de concentración o ruido ambiente)
- Error     Los humanos cometemos errores (errar es humano). Las máquinas cometen errores? NO.
    > Error en una medición
- Defecto   Y al cometer un error, un humano, puede introducir un defecto (BUG) en el producto.
            Podemos entender un defecto como la cicatriz que queda en un producto por un error humano. 
    > Defecto en el producto: Mi mesa, tiene una pata más corta
- Fallo     Un fallo es la manifestación de un defecto al usar el producto
            Podemos entenderlo como una desviación del comportamiento esperado del producto.
    > Fallo: Al usar la mesa, se me va toda la comida.. y queda regada por el suelo... sin cenar.

# Para que sirven las pruebas?

- Sirven para asegurar el cumplimiento de unos requisitos (tanto funcionales como no funcionales).
- Detectar la mayor cantidad posible de defectos antes de la entrega de mi producto.
  Tendremos distintas estrategias:
  - Tratar de provocar un fallo al usar el producto. Una vez identificado un Fallo, lo que busco es el defecto que lo ha provocado, para poder corregirlo (Depuración o Debugging).
  - En ocasiones, buscamos directamente los defectos: Revisión de código, revisión de requisitos, etc. En este caso, no es necesario provocar un fallo para encontrar un defecto. Esto, que muchas veces se obvia, es mucho más barato que provocar un fallo, ya que no es necesario ejecutar el producto para encontrar el defecto.
- Sirven para, en caso de detectar un fallo, aportar toda la información que sea relevante para que el defecto pueda ser dientificado y corregido lo antes posible.
- En ocasiones, a posteriori, hago un análisis de los fallos detectados para tratar de identificar la causa raíz que ha provocado el error humano, y entonces tomar acciones preventivas, que eviten que ese error humano vuelva a ocurrir, y por tanto, que nuevos defectos y fallos vuelvan a ocurrir en el futuro.
- Aprender e incorporar nuevo know-how a mi core.
- Para ayudar/guiar a los desarrolladores a diseñar un mejor producto.
- Para asegurar que el producto cumple con las necesidades/expectativas de mis clientes.
- Para ayudarme a entender el estado del producto en cada momento, y así poder tomar decisiones informadas sobre el mismo. **1**

---

# Tipos de pruebas:

Las pruebas se clasifican mediante múltiples taxonomías... paralelas entre si.

## Clasificar en base al objeto de prueba

- Funcionales     Aqueññas que verifican el cumplimiento de requisitos funcionales.
- No funcionales  Aquellas que verifican el cumplimiento de requisitos no funcionales.
  - Rendimiento
  - Carga
  - Estres
  - Seguridad
  - Usabilidad
  - UX
  - HA
  - ...

## Clasificar en base al conocimiento del objeto de prueba

- Caja negra      No se tiene o no se usa conocimiento del funcionamiento interno del producto. Solo se conoce el comportamiento esperado.

    > Hago una petición a un servidor para que me devuelva un dato.. que tengo persistido en una BBDD.
    > Sé que el dato está ahí... lo he puesto yo, para poder hacer la prueba.
    > lo pido (quizás por su id...) y espero que me lo devuelva.
    > De hecho me lo devuelve. Prueba OK!

    Esto es una prueba a nivel de API. Esta prueba trabaja contra requisitos.

- Caja blanca     Se tiene conocimiento del funcionamiento interno del producto, y se usa ese conocimiento para diseñar las pruebas.

    > Ahora... me explican un poquito como funciona el programa por dentro.
    > Y me cuentan que para mejorar rendimiento, han implementado un sistema de caché.
    > la primera vez que se pide un dato, se obtiene de la BBDD y se devuelve (pero en parallelo se guarda en la caché).
    > la segunda vez que se pide el mismo dato, se obtiene de la caché y se devuelve (sin ir a la BBDD).
    > La prueba de antes (caja negra?) cubre este escenario?

    La prueba cambia:

    > Hago una petición a un servidor para que me devuelva un dato.. que tengo persistido en una BBDD.
    > Sé que el dato está ahí... lo he puesto yo, para poder hacer la prueba.
    > lo pido (quizás por su id...) y espero que me lo devuelva.
    > De hecho me lo devuelve. Prueba OK!
    > lo pido otra vez para ver si me lo sigue devolviendo... en este caso de la caché.

    Esta prueba no trabaja contra SOLO contra requisitos... también trabaja contra la implementación (diseño/arquitectura).

## En base al SCOPE o alcance de la prueba (CONTEXTO en el que ejecuto esa prueba)

- Unitarias             Probar una función, un trocito de código por sí solo no garantiza que estoy haciendo una prueba
                        unitaria. El gran problema de las pruebas unitarias es SU NOMBRE.
                        Se deberían de llamar PRUEBAS AISLADAS!
                        Una prueba unitaria se centra en una característica de un componente AISLADO del sistema.

> Soy un fabricante de bicicletas.
  > Pregunta: Fabrico yo los sistemas de freno? NO
  > Y las ruedas? NO
  > Los platos? NO
  > Qué pinto en todo esto? Diseño/Especifico los componentes y el cuadro... y la bicicleta y luego INTEGRO esos componentes.

  > Encargo los sillines.. me llegan... qué hago? Los dejo en cajas en el almacen hasta tener el resto?
  > Los pruebo...
  > Qué pruebas le hago?
    > PRUEBA 1: Monto el sillín en un BASTIDOR DE PRUEBAS (4 hierros más o menos soldaos lo justo) y siento a un tio encima 4 horas... A ver si le duele el culo mucho o no.
        > UNITARIA, UX (No funcional)
    > PRUEBA 2: Sacar el bastidor con el sillín montado al sol.. a ve si no se derrite (en agosto Sevilla!)
        > UNITARIA, Estrés (No funcional)
    > PRUEBA 3: Cojo el bastidor, le monto el sillín y lo balanceo a los lados... 45 grados.. con una persona sentada arriba..  a ver si no se resbala el culo.
        > UNITARIA, Seguridad (No funcional)
    > PRUEBA 4: Cojo el bastidor, le monto el sillín y pongo encima a una persona de 150kgs (o un muñeco... que parezca una persona... )a ver si aguanta.
        > UNITARIA, Carga (No funcional)
    > PRUEBA 5: Cojo el sillín y le froto 4 horas con una lija... a ver si se desgasta mucho el cuero o no.
        > UNITARIA, Estrés (No funcional)
    > Otro ejemplo:
    > Requisito1_v3: La app X montada en un entorno con tales CARACTERÍSTICAS, con una carga de trabajo de X usuarios haciendo tales operaciones, debe responder a tal petición en menos de 500 segundos el 95% de las veces (percentiles).
        > Tipo de prueba? Rendimiento, Sistema.
        > Me podría haber interesado el día 1 medir la latencia de la comunicación a la BBDD? Imaginad que hago esta prueba, y me da 200ms. Qué tal voy? Como el culo... Con 2 queries y lo que luego haya que hacer ya no llego a los 500ms... Y esto puede condicionar totalmente el diseño del sistema (arquitectura interna).. quizás debo implementar un sistema de caché.
        > Esa medición de la latencia a la BBDD es una prueba UNITARIA... esto puede cambiar totalmente el diseño del sistema. 
        > El problema, que no haga esto... Y que solo haga la prueba de sistema cuando tengo el sistema montado... y entonces me doy cuenta quye no llego a los 500ms... y entonces tengo que rediseñar el sistema...y tirar mucho trabajo a la basura... 
    >
    >
    > PRUEBA 2 Me llega el sistema de frenos (o lo fabrico yo).
    > Le hago pruebas unitarias.
    > - Monto el sistema de frenos en un bastidor de pruebas. Y aprieto la palanca del freno 
    >   (sistemaDeFrenos.apretarPalanca()) y compruebo que aprieta con suficiente presión un SENSOR DE PRESIÓN que 
    >   coloco entre las pastillas de freno.
    >
    > Ese bastidor o ese sensor de frenos son lo que en software llamamos TEST-DOUBLES.
    > Hay muchos tipos de test doubles: Stubs, Spies, Dummies, Fakes, Mocks.
    >
    > Quiero probar un frontal WEB... que trabaja contra un microservicio.
    > Pero quiero hacer prueba unitaria (el backend, el servicio, aún no está desarrollado.. o lo está.. pero no quiero integrarme aún con él.. o quiero probar el frontal sin depender del backend... )
    > Por ejemplo, podría facilmente con postman o readyapi, hacer un stub del backend, que me devuelva respuestas predefinidas a las peticiones que le haga el frontal. Un stub es un programa que devuelve respuestas predefinidas.
    > Podría usar un fake del backend.. una herramienta como JSON-SERVER, que me permite montar un servidor local que me devuelve respuestas a las peticiones que le haga el frontal... pero sin persistir en BBDD ni aportar lógica adicional.
    > Quizás mi frontal necesita mandar un mensaje solicitando el envío de un email... y monto un dummy del servicio de email, que no hace nada... pero me permite probar el frontal sin necesidad de tener un servicio de email real.
    > He hecho todas las pruebas unitarias que consideraba necesarias... Me garantiza esto que el sistema va a funcionar correctamente? NO.
    > Entonces para que las hago?
    > Ir detectando dfefectos lo antes posible... Dar pasos en firme... Confianza+1

- Integración   Se centran en la COMUNICACIÓN entre 2 componentes.
  El siguiente paso natural es ir juntando componentes 2 a 2. No 3 a 3... Si los junto de 3 en 3, si la prueba falla no se que comunicación es la que falla... Si los junto de 2 en 2, si la prueba falla,en esa  comunicación es donde está el problema.
    > Me llegan las ruedas... y hago la prueba de integración ocon el sistema de frenos.
    > Prueba 1: Monto el sistema de frenos y la rueda en un bastidor de pruebas, y hago que la rueda gire a una velocidad determinada, y luego aprieto la palanca del freno (sistemaDeFrenos.apretarPalanca()) y compruebo que la rueda se para.
    > Estoy probando la misma función que antes! Lo que cambia es el CONTEXTO.
    > Y mira qué no para.
    > El sistema de frenos cierra las pinza.. pero no lo suficiente como para tocar la llanta... es muy estrecha apra ese sistema de frenos.
    > Es defectuoso el sistema de frenos? NO
    > Es defectuosa la RUEDA? NO
    > Tengo un problema de COMUNICACION entre ambos componentes... y eso es un defecto.
    > Hago todas las pruebas de integración que considero necesarias... Me garantiza esto que el sistema va a funcionar correctamente? NO.
    > Entonces para que las hago?
    > Ir detectando defectos lo antes posible... Dar pasos en firme... Confianza+1

- Sistema (end to end)
  Junto todo... monto la bici.
    > Prueba 1. Cojo la bici... ciclista encima... mochila en la espalda... bocadillo de chorizo y agua.. y pa'Cuenca (400kms) a ver si llega sin problemas. 
    > Prueba 2. Cojo la bici... ciclista encima... Pone la bici a 40kms/hora... y (sistemaDeFrenos.apretarPalanca()) a ver si se para en menos de 10 metros. De nuevo, estoy probando la misma función que antes! Lo que cambia es el CONTEXTO.

    > Pregunta... hago todas las pruebas de sistema que considero necesarias... Me garantiza esto que el sistema va a funcionar correctamente? DEBERIA! (SI)... siempre habrá algun defecto que se me escape... pero después de pruebas de sistema, el producto debería estar libre de defectos.

- Aceptación
  Las pruebas de aceptación NO BUSCAN DEFECTOS... el producto en este punto ya debe estar libre de defectos. 
  Estas pruebas miran si el producto es adedcuado para mi cliente!

  Mi cliente se sube en la bici... y sistemaDeFrenos.apretarPalanca() y dice... coño, que duro esta esta palanca.. o que freno más blandito.. NO ME GUSTA!
  Oye.. esta bici no me vale... va dando muchos saltos... tiembla mucho... 
  Coño, has cogido una bici de carreras para ir por la montaña... no me extraña que te tiemble...
  No es tu bici!
  El cliente no la acepta! Pero la bici, que está probando el cliente ya está sin defectos... el cliente no la acepta porque no es adecuada para su uso... no es adecuada para su contexto.


Humo













---

# Gestión de proyectos de software

Antiguamente, un proyecto de software se gestrionaba me diante lo que hoy llamamos una metodología de desarrollo tradicional (en cascada y variantes: V, espiral...).
Hoy en día apostamos más por metodologías ágiles.

Una metodología waterfall es mucho más optimizada (eficiente) que una metodología ágil: El problema es que para que funcione tengo que partir de una toma de requisitos muy clara, estable y completa... y eso es muy difícil de conseguir en un proyecto de software.

De hecho el objetivo de las met. ágiles es tener un feedback muy rápido por parte del cliente... y para ello propone entregar el producto de forma incremental. En las tradicionales solo había una entrega.. al final del desarrollo.

> Extraído del manifiesto ágil: 
> El software funcionando es la MEDIDA principal de progreso. > Esto define un indicador para un cuadro de mando

**1**

La MEDIDA principal de progreso es el software funcionando. 
   ------ --------- -----------    -----------------------
   Núcleo adjetivo  C. prep          Cópula o atributo 
------------------------------- --------------------------
            Sujeto                  Predicado copulativo

Es decir:

La forma en la que vamos a medir el progreso (¿qué tal va?) de nuestro proyecto es a través del concepto: "software funcionando".

La pregunta sería qué leches es el concepto de "software funcionando"?
Y básicamente es un software que cumple con requisitos.. que hace lo que debe hacer, que se comporta como se espera que se comporte.

> Pregunta: Quién dice que el software funciona? 
- El cliente/usuario... Horrible NO!
  La responsabilidad de determinar que el producto funciona NUNCA PUEDE SER DEL CLIENTE!
- Las PRUEBAS son las que dicen que el software funciona o no funciona. 
  Las pruebas son las que dicen si el producto cumple con los requisitos o no los cumple.
    
    Vamos a ver cúantas pruebas nuevas se han hecho, cuántas pruebas nuevas pasan. Cuántas pruebas viejas dejan de pasar... y a través de eso, vamos a medir el progreso de nuestro proyecto.

Otra cosa distinta es si el producto es apto o no para mi cliente. El cliente ayuda con parte de la definición de los requisitos.

El cliente verá el producto después. 
Se lo subo a producción... Y lo mira.. lo usa.. me da feedback.. propone mejoras...
Pero a mi cliente le llega un producto ya que funciona!
Mientras estoy en desarrollo, el cliente no ha visto el producto... PERO YO HE DE SABER QUE TAL VOY?

Una pregunta buena que podemos hacernos es por qué leches se metió esto en el manifiesto ágil.
Y la respuesta evidente es porque antes no se medía así.
Con las metodologías tradicionales, el progreso se medía:

- HITO 1: 10 Julio: **R1, R2, R3**
  Qué pasaba si el día 10 de Julio, el R3 no estaba acabado?
  - Ostias pa tos laos
  - Suenan las alarmas
  - Se replanifica el hito: NUEVA FECHA 20 de Julio
  - El paquete de requisitos R1, R2, R3 no se cambia. 
- HITO 2: 10 Agosto: R4, R5, R6
- HITO 3: 10 Septiembre: R7, R8, R9

Cómo medía el jefe de proyecto: 
Llegaba el 10 de Julio y preguntaba:
- Felipe... has acabado el R2 y R3? SI!
- Menchu... has acabado el R1? SI!
-> VAMOS GUAY!

---

Eh... estaba pensando que en SCRUM (una met.ágil) :

- SPRINT 1: **10 Julio**: R1, R2, R3
  Qué pasa si el día 10 de Julio, el R3 no está acabado? 
  - Ostias pa tos laos
  - Suenan las alarmas
  - El R3 se deja para la siguiente iteración: SPRINT 2
  - La fecha no se mueve ni un minuto. HOY HAY PASO A PRODUCCIÓN
- SPRINT 2: **10 Agosto**: R4, R5, R6, R3
- SPRINT 3: **10 Septiembre**: R7, R8, R9


Las met. agiles están genial.. pero A pesar de que han resuelto muchos problemas han traído otros problemas nuevos.
Antiguamente, cuántas veces se pasaba a producción? 1 al acabar el proyecto
Hoy en día paso a producción cada 2, 3, 5 semanas.
Y ojo estamos hablando de paso a producción.
Qué hay que hacer antes de un paso a producción? PRUEBAS a nivel de producción!
Y esas pruebas se hace en un entorno de pruebas.
- Me valen para algo las pruebas que hace el desarrollador en su máquina? Me fío? NO.. porque su máquina está maleada!
- Me valen para algo las pruebas que hace el tester en su máquina? Me fío?        NO.. porque su máquina está maleada!
- Me valen para algo las pruebas que hago en un entorno de pruebas? Me fío?       Hoy en día TAMPOCO
  Esto ya no vale. Valía cuando trabajaba con una met. tradicional. Cuántas veces se instalaba en el entorno de pruebas?
  4... cuando estaba ya el desarrollo acabao. 
- Con las met. ágiles, paso a producción cada 2, 3, 5 semanas... y cada vez que paso a producción, tengo que hacer pruebas en un entorno de pruebas... y despues de 25 instalaciones, cómo va a estar el entorno de pruebas? Maleado!

Hoy en día la tendencia es a usar entornos efímeros... como los kleenex... de usar y tirar.
Creo entorno, instalo, hago pruebas, lo tiro...

En el Sprint 1... R1, R2, R3, que pruebas hago?
    Pruebo el R1, R2, R3
Y en Sprint 2?
    Pruebo el R4, R5, R6, R3 + todas las pruebas de R1, R2... que no se me han roto por el camino.
    Las pruebas que hice en su momento para el R1 y R2 debo repetirlas. OBLIGATORIO... Se convierten en pruebas de regresión.

Y esto es lo que no me dicen en los cursos de Sprint... De dónde sale la pasta? y los recursos? y el tiempo? para tanta prueba e instalación? Porque las instalaciones se multiplican... pero las pruebas van exponenciales!
Y la respuesta es que NI HAY PASTA, NI HAY TIEMPO, NI HAY RECURSOS!
Cuál es la solución? AUTOMATIZAR!

---

# DEVOPS

Es una cultura, una filosofía, un moviento en pro de la automatización.
Cuando en una empresa digo: CHIC@s, vamos a automatizar todo lo que pueda! Entonces decimos que estoy adoptando una cultura DevOps.

Y Quiero automatizar todo lo que hay entre el DEV -> OPS.



PLAN -> CODE -> BUILD -> TEST -> RELEASE -> DEPLOY -> OPERATE -> MONITOR
--------------> Desarrollo ágil
-----------------------------> Integración Continua / Continuous Integration
------------------------------------------> Entrega Continua / Continuous Delivery
---------------------------------------------------> Despliegue Continuo / Continuous Deployment
------------------------------------------------------------------------> Devops

Integración Continua:

    Es tener CONTINUAmente en el entorno de INTEGRACION la última versión del código que se ha desarrollado, sometida a pruebas automatizadas... cuál es el producto?

Cuál es el entregable, el producto de un pipeline de integración continua? Es un informe de pruebas AUTOMATIZADO en tiempo REAL... Para qué? VER **1**

Esos pipelines de CI/CD los montamos en herramientas como JENKINS, GITLAB CI/CD.

Los pipelines de CI son un segundo nivel de automatización. Se montan cuando tengo las pruebas automatizadas.
---

NOTA:

- API: Application Programming Interface. Es un conjunto de reglas y protocolos que me permiten comunicarme con un software o sistema, sin necesidad de conocer su funcionamiento interno. Básicamente es :
  - Qué le mando?
  - Qué me devuelve?
 

---

UFT es una herramienta MUY LEGACY!
Viene de 5 herramienats que han sido compradas y vendidas de empresa a empresa:

Mercury Interactive QTP.
HP QTP.
Microfocus UFT.
OpenText UFT One.

Y la herramienta se ha ido actualizando... pero no ha sufrido un rediseño total... y eso hace que tenga una arquitectura muy legacy... Pero no solo eso.. sino que las formas de trabajo iniciales en esa herramienta no valen a día de hoy.

---

> Tengo un sistema que me permite hacer un CRUD de animalitos. Microservicio REST: http /api/v1/animalitos

CRUD? Create, Read, Update, Delete. Toda la gestión sobre animalitos en una tienda de animalitos.
- Registrar nuevos animalitos
- Consultar los animalitos que tengo registrados
- Modificar los datos de un animalito registrado
- Eliminar un animalito registrado
- Ver los detalles de un animalito registrado

---

> PRUEBA 1: Happy path de alta de un animalito

Dado: Los datos de un animalito (guays) en un json.
    - Nombre: firulais
    - Especie: perro
    - Raza: pastor alemán
    - Edad: 3 años

Cuando:
    Cuando hago un post a api/v1/animalitos con el json de los datos del animalito

Entonces:
    Se recibe un código http status 200
    Y en el cuerpo de la respuesta tengo un json con los datos del animalito registrado, incluyendo un id que me ha generado el sistema.
        - Me aseguro que en el JSON venga: Nombre = firulais
                                           Especie = perro
                                           Raza = pastor alemán
                                           Edad = 3 años
                                           Id >= 0

Esto es una prueba de Caja blanca o negra? Caja negra

Me interesa una de caja blanca?

> PRUEBA 2: Happy path de alta de un animalito. CAJA BLANCA... Sabiendo que los datos acaban en Oracle, en la tabla animalitos.

Dado: Los datos de un animalito (guays) en un json.
    - Nombre: firulais
    - Especie: perro
    - Raza: pastor alemán
    - Edad: 3 años

Cuando: (Acción)
    Cuando hago un post a api/v1/animalitos con el json de los datos del animalito

Entonces:
    Capturo el ID que me devuelven en el JSON de la respuesta.
    Y hago una consulta a la BBDD Oracle: select * from animalitos where id = id_capturado
    Y me aseguro que en el resultado de la consulta venga:  Nombre = firulais
                                                            Especie = perro
                                                            Raza = pastor alemán
                                                            Edad = 3 años
---

Imaginad la siguiente implementación que ha hecho un desarrollador:

```java
    @RequestMapping(path = "/api/v1/animalitos", method = RequestMethod.POST)
    public Animalito registrarAnimalito(DatosAltaDeUnAnimalito datos) {
     Animalito animalito = new Animalito();
     animalito.setNombre(datos.getNombre());
     animalito.setEspecie(datos.getEspecie());
     animalito.setRaza(datos.getRaza());
     animalito.setEdad(datos.getEdad());
     animalito.setId(33);
     return animalito;
    }
```

> PRUEBA 3: Happy path de recuperar un animalito que existe en la BBDD


Dado:   ~~ Que he ejecutado antes la prueba 2... y ya tengo a firulais registrado en la BBDD con un id concreto ~~
Los datos de un animalito (guays) en un json.
    - Nombre: firulais (Si el nombre fuese un ID único, hacer la prueba la segunda vez daría error. O si en la prueba 2 ya metieron a Firtulais, daría error)
      -> Nombre: Aleatorio autogenerado (para evitar problemas de datos duplicados) 
    - Especie: perro
    - Raza: pastor alemán
    - Edad: 3 años

~~y dado que hago un post a api/v1/animalitos con el json de los datos del animalito~~
~~y dado que Capturo el ID que me devuelven en el JSON de la respuesta.~~
y dado que hago insert a la BBDD con esos datos y pillo su id

Cuando
    Cuando hago un GET a api/v1/animalitos/<id_capturado>

Entonces:
    Se recibe un código http status 200
    Y en el cuerpo de la respuesta tengo un json con los datos del animalito registrado, incluyendo un id que me ha generado el sistema.
        - Me aseguro que en el JSON venga: Nombre = firulais
                                           Especie = perro
                                           Raza = pastor alemán
                                           Edad = 3 años
                                           Id = al id_capturado
    

--- 

# Conviene cambiar la filosofía!

No voy aprobar un flujo de negocio completo... al menos dentro de un test.
- Doy de alta un animal
- Veo que puedo recuperarlo
- Lo modifico
- Veo que se han modificado los datos
- Lo elimino
- Veo que ya no puedo recuperarlo

Hoy en día, en lugar de un test, monto uno para cada cosa... y reaprovecho código.. y podré tener una suite que lance todo!

Pero quiero que si falla algo, se identifique univocamente qué es lo que ha fallado... y no tener que revisar un test que hace 10 cosas para ver qué es lo que ha fallado.
Porque además el informe se va agenerar en automático, no en manual... con nadie mirando logs.

---

En UFT el lenguaje que usamos para definir las pruebas (los programas de pruebas) es VBScript.
Es muy sencillito.. y en cualquier caso, nosotros no vamos a hacer desarrollo de un software/app...
Vamos a desarrollar un tipo de programas muy simple llamado SCRIPTS. Y el nivel de programación (o de dominio de  lenguaje) que necesitamos es bastante bajo.

UFT va a generar mucho código VBScript. Y reaprovecharemos mucho de ese código.
Pero lo reorganizaremos entero!
Especialmente las partes más complejas son las que más vamos a reaprovechar.

---

UFT va a permitirnos grabar secuencias de operaciones sobre una aplicación, y luego reproducirlas para verificar que el comportamiento de la aplicación es el esperado. 
Pero el código que genera UFT es inmantenible... y no es reutilizable... y no es robusto...
Y con una metodología tradicional, en la que las pruebas se ejecutaban al final... con el sistema ya desarrollado, más o menos daba igual... en ese momento el sistema no sufría grandes cambios! Solo corrección de bugs.

Pero con una metodología ágil, en la que el sistema se va desarrollando e integrando de forma incremental,
de un sprint a otro, puede haber habido un cambio importante en el sistema... y entonces, si mis pruebas no están bien diseñadas, el mantenimiento de las pruebas va a ser horrible.No voy a tener recursos para continuar con el desarrollo de las pruebas.


Impactos enormes:
- Conocéis el Repositorio de Objetos de UFT.
  Las pruebas las hacemos sobre objetos... Por ejemplo, un campo Usuario o Contraseña de un formulario de login será un OBJETO.
  El botón de login será otro OBJETO.

  UFT me permite automatizar la identificación de esos objetos.... grabando unas operaciones por pantalla.
  Pero si el día de mañana, deciden cambiar el campo "Usuario", por el campo: "Nombre de usuario", el objeto no será reconocido... y mis pruebas fallarán.
  Lo primero, esperemos que haya creado un código que reutilice la función de hacer login... Así solo habrá un sitio donde cambiarlo... (COSA QUE NO OCURRIRÁ SI SOLO HE GRABADO LA ACTIVIDAD SOBRE UNA PANTALLA).
  Pero mejor aún, si hubiera optado por una identificación de objeto más estable que la que UFT me va a proponer a priori.
  - En lugar de usar el texto del botón para identificarlo, me puede interesar buscar un boton dentro del formulario de login... en cuyo nombre o id aparezca la palabra login, submit.

Hace 20 años, todo esto daba igual. HOY ES LA CLAVE!

En paralelo van apareciendo funcionalidades. Por ejemplo muchos de los conceptos de IA que se han metido en UFT van orientados a mejorar la identificación de objetos.. que veremos que será clave, para tener pruebas ESTABLES a lo largo del tiempo.
---

# Diseño de pruebas

Una prueba siempre la defino por 3 partes o conceptos:
Dado / Given / Contexto
Cuando / When / Acción
Entonces / Then / Resultado esperado

Y siempre al probar una funcionalidad comienzo por el happy path (camino feliz) es decir, que todo va como la seda...
Y después empiezo a meter los caminos problemáticos.

## Las pruebas han evolucionado mucho y el diseño de pruebas más!

### Os suenan los principios FIRST de diseño de pruebas?

F - Fast : Rápidas, sino se vuelven inútiles
I - Independent : Independientes entre si y del entorno (especialmente hoy en dia con entornos efímeros... y donde para una app grande me puede interesa ejecutar solo suites de pruebas concretas... y no todas las pruebas cada vez que hago un cambio...)
R - Repeatable : Repetibles, deben dar el mismo resultado cada vez que se ejecutan
S - Self-Validating : Auto-validables, deben poder determinar automáticamente si han pasado o fallado
T - Timely : Oportunas, deben ejecutarse en el momento adecuado del ciclo de desarrollo

---

Qué es lo más crítico/relevante al definir una prueba?
- Que la prueba compruebe lo que tiene que comprobar... que sea buena y funcione se da por descontado!
- En las pruebas, especialmente en al UI (y especialmente en el mundo WEB) - aunque no solo -lo más complejo e importante es hacer una prueba que sea capaz de envejecer dignamente...

Un problema enorme es que vamos a crear una bateria de pruebas HOY con mucho esfuerzo... y que dentro de 2 sprints van a dejar de funcionar.. y las tendré que deajustar todas... en cuanto tengan un mal diseño!

---

Hemos hablado de automatizar pruebas.
Qué significa AUTOMATIZAR?
Automatizar es crear una máquina o cambiar el comportamiento de una máquina mediante programas que hagan lo que antes hacia un humano con sus manos.

Puedo automatizar el lavado de la ropa: LAVADORA (que incluso puedo cambiar su comportamiento con Programas de lavado: FRIO, Prendas delicadas...)

En nuestro caso, la máquina la tenemos: COMPUTADORA.
Lo que vamos a hacer es CREAR PROGRAMAS!
Para nosotros, especialmente con UFT, AUTOMATIZAR = PROGRAMAR!
Por eso hemos hablado de scripting!

UTF gener un esqueleto de programa por mi... QUE NO VALE PARA NADA! Que tengo que rehacer entero!
Hace años... me podía medio servir... HOY EN DIA (con met. ágiles, con la necesidad de tener pruebas que envejezcan dignamente...) NO VALE PARA NADA!

Es decir, lo que haré es crear programas que prueben otros programas.
Yo ya no hago pruebas... hago programas que hacen pruebas.
Y me tengo que someter a lo mismo que pido a los desarrolladores... tengo que hacer un buen diseño de mis programas de pruebas... para que sean robustos, mantenibles y adaptables a los cambios. Qué esten en un sistema de control de versiones. GIT?

---

# VBScript dentro de pruebas UI en UFT

## Características básicas del lenguaje

```vbscript

' En los scripts de UFT, podemos poner comentarios usando el apóstrofo (') o la palabra Rem

Rem Esto también es un comentario

Rem Solemos darle preferencia al apóstrofo para los comentarios, ya que es más sencillo y rápido de escribir.

' Es importante comentar los programas de prueba... no con cosas obvias. 
' De entrada importante marcar la estructura de la prueba: Dado, Cuando, Entonces... 
' y luego comentar las partes más complejas o que puedan generar dudas.

' Variables. Vamos a trabajar en muchos casos con variables... para almacenar datos temporales... 
' - Datos con los que rellenar formularios
' - Datos que se muestran en una pantalla y que quiero validar...
' - Datos que me devuelve una consulta a la BBDD... y que quiero capturar...

' Por defecto, VBScript no obliga a declarar las variables... 
' Dicho eso, la mejor práctica es hacerlo... y para ello, al principio de mi programa de pruebas, suelo poner la siguiente línea:

' Esta linea FUERZA que todas las variables que usemos en el programa de pruebas
' tengan que ser declaradas previamente...
Option Explicit
' Esto es una medida de protección para MI. Me da seguridad.

Dim usuario
Dim contraseña

' Incluso puedo definir varias variables en una linea:

Dim usuario, contraseña, idAnimalito, nombreAnimalito

' No es muy habitualo, mejor en lineas separadas... pero es posible.

' TIPOS DE DATOS
' Una cosa es que las variables no tenga que definierles un tipo de datos... como ocurre en otros lenguajes de programación
' Otra cosa es que no pueda manejar datos de distintos tipos... y claro que puedo.

Dim texto
texto = "Hola, soy un texto"

Dim numero
numero = 42

Dim booleano
booleano = True
boolean = False

Dim fecha
fecha = Date() ' Me devuelve la fecha actual del sistema

' Operadores
' Hay muchos operadores... pero vamos a ver los más básicos:

' Operadores aritméticos: Se aplican a números y devuelven un número como resultado:
' + Suma
' - Resta
' * Multiplicación
' / División

numero = 10 + 5 - 3 * 2 / 4
Dim numero1, numero2
numero1 = 33
numero2 = 7
numero = numero1 + numero2

' Operadores lógicos. Son operadores que nos permiten combinar/trabajar con valores lógicos (booleanos):
' Se aplican a valores booleanos y devuelven un valor booleano como resultado:
' AND (Y lógico): Devuelve True si ambos operandos son True, de lo contrario devuelve False.
' OR (O lógico): Devuelve True si al menos uno de los operandos es True
' NOT (Negación lógica): Devuelve el valor opuesto del operando. Si el operando es True, devuelve False; si el operando es False, devuelve True.

' HaHechoLogin = True
' TienePermisoAcceso = False
' Si quiero comprobar si el usuario ha hecho login y tiene permiso de acceso, puedo usar el operador AND:
' HaHechoLogin AND TienePermisoAcceso               -> Devuelve False, porque aunque el usuario ha hecho login, no tiene permiso de acceso.

' Operadores relacionales o de comparación. Nos permiten comparar dos valores de cualquier tipo y devuelven un valor booleano como resultado:
' = Igual a: Devuelve True si los operandos son iguales, de lo contrario devuelve False.
numero1 = 10
numero2 = 10
resultado = (numero1 = numero2) ' Devuelve True, porque ambos números son iguales

' <> Distinto de: Devuelve True si los operandos son diferentes, de lo contrario devuelve False.
' > = Mayor o igual que: Devuelve True si el operando de la izquierda es mayor o igual que el operando de la derecha, de lo contrario devuelve False.
' < = Menor o igual que: Devuelve True si el operando de la izquierda es menor o igual que el operando de la derecha, de lo contrario devuelve False.
' > Mayor que: Devuelve True si el operando de la izquierda es mayor que el operando de la derecha, de lo contrario devuelve False.
' < Menor que: Devuelve True si el operando de la izquierda es menor que el operando de la derecha, de lo contrario devuelve False.

' Especiales para textos:

' Concatenar textos: &
Dim texto1, texto2, textoConcatenado
texto1 = "Hola"
texto2 = "Mundo"
textoConcatenado = texto1 & " " & texto2                            ' Devuelve "Hola Mundo"

' Sigue en la siguiente linea. A veces queremos escribir un texto que es largo... y ocuparía varias lineas.
' En este caso usamos el guion bajo para indicar que el texto continúa en la siguiente linea.
textoConcatenado = "Hola, soy un texto muy largo que quiero escribir en varias lineas para que sea más legible..." & _
                    "y aquí continúa el texto en la siguiente linea."

' Condicionales
' Esto es de lo que más vamos a escribir nosotros. El UTF no va a generar código de condicionales... y nosotros vamos a tener que escribirlo...
' La estructura básica de un condicional es la siguiente:

If        condicion1    Then
    ' Código que se ejecuta cuando se cumple condicion1
ElseIf    condicion2    Then
    ' Código que se ejecuta cuando se cumple condicion2
Else
    ' Código que se ejecuta cuando no se cumple ninguna de las condiciones anteriores
End If

Por ejemplo...

If NoSeHaHechoLoginCorrecto Then
    Reporter.ReportEvent micFail, "Login", "El usuario no ha hecho login correctamente"
End If

' Reporter.ReportEvent es una función de UFT que nos permite generar un evento en el informe de pruebas. 
' El primer parámetro indica el tipo de evento:
' - micPass -> Prueba pasada
' - micFail -> Prueba fallada
' - micWarning -> Prueba con advertencia
' El segundo parámetro es un título para el evento
' y el tercer parámetro es una descripción detallada del evento.

' Tenemos bucles también: For Each, While... por ahora no los voy a contar... los meteremos cuando sea necesario en un ejemplo.

' Funciones y procedimientos
' Y aquí de nuevo, UFT no va a generar código de funciones o procedimientos... y nosotros vamos a tener que escribirlo...
' Una función es un trozo de código que devuelve un valor. Un procedimiento es un trozo de código que no devuelve ningún valor.

' Definir un Procedimiento REUTILIZABLE para hacer login:

Sub DoLogin(usuario, contraseña)
    ' Código para hacer login con el usuario y contraseña proporcionados
End Sub

' Cuando me interese, llamar a este procedimiento desde mis pruebas para hacer login:
Call DoLogin("miUsuario", "miContraseña")

' Las funciones son muy similares
' Definir una función:
Function TryDoLogin(usuario, contraseña)
    ' Código para hacer login con el usuario y contraseña proporcionados
    ' Voy a ver si llego a la pantalla de inicio después de hacer login... o si llego a una pantalla de error...
    ' De alguna forma tendré una variable booleana que me indique si el login ha sido correcto o no...
    LoginExitoso = ????
    TryDoLogin = LoginExitoso ' Devuelvo el resultado del login
End Function

' Puedo usar la función directamente con el nombre
If TryDoLogin("miUsuario", "miContraseña") Then
    Reporter.ReportEvent micPass, "Login", "El usuario ha hecho login correctamente"
Else
    Reporter.ReportEvent micFail, "Login", "El usuario no ha hecho login correctamente"
End If

' Gestión de errores en tiempo de ejecución.
' En ocasiones intentaré hacer algo... pero puede que no sea posible.
' Por ejemplo, UFT, ve a la pantalla de login. Y el servidor no está arrancado y no puedo ir
' UFT, aprieta en el botón de novedades... y resulta que no hay botón de novedades (solo salé los 3 primeros días después de un despliegue).

' En VBScript el control de errores es muy básico

On Error Resume Next            ' Si se produce un error, se captura (en una variable Err), 
                                ' se ignora y se continúa con la siguiente línea de código

' Click en el botón de novedades
' Habrá código que haga ese click
' Se genera un error.. el botón no existe.
If Err.Number <> 0 Then          ' Si se ha producido un error, Err.Number tendrá un valor distinto de 0
    Reporter.ReportEvent micWarning, "Novedades", "No se ha podido acceder a las novedades. El botón no existe."
    Err.Clear()                    ' Limpia el objeto Err para poder detectar futuros errores
Else
    ' Si he encontrado el botón de novedades y he podido hacer click, puedo seguir con el flujo normal de la prueba
    Reporter.ReportEvent micPass, "Novedades", "Se ha accedido a las novedades correctamente."
    ' Y aquí ahora compruebo que se han mostrado las novedades... y si no se han mostrado, puedo generar un evento de fallo en el informe de pruebas.
End If

' Todo código que yo ejecute siempre acaba con un número (salida de la ejecución)... como si fuera el Código de estado http.
' 2XX -> OK
' 3XX -> Redirección
' 4XX -> Error del cliente
' 5XX -> Error del servidor

' Dentro de un código:
' Err.Number = 0 -> Todo ha ido bien
' Err.Number <> 0 -> Ha habido un error... y el número de error me dría información de qué error ha ocurrido... pero es complejo de interpretar. 
'                    Cada comando usa una codificación diferente

```

## Estructura de un programa de pruebas en UFT

Esos ejemplos de arriba son simplemente conceptos básicos del lenguaje VBScript (salvo el tema del Reporter.ReportEvent, que es específico de UFT).

UFT tiene luego funciones especiales... para lo que son las pruebas.

En pruebas a nivel de UI, lkos scripts siempre van a ser muy parecidos entre si... al menos lo básico.

' IDENTIFICO UN OBJETO y OPERO SOBRE EL

' Habitualmente un script parco, simple (y de los que no queremos),.. pero que UFT va a generar por mi,
' es una secuencia de operaciones sobre objetos... con la identificación de esos objetos... 
' y con la generación de eventos en el informe de pruebas.

' IDENTIFICO OBJETO 1 -> hago click en él
' IDENTIFICO OBJETO 2 -> Espero a que esté en pantalla
' IDENTIFICO OBJETO 3 -> Relleno un campo con un texto
' IDENTIFICO OBJETO 4 -> Relleno un campo con un texto
' IDENTIFICO OBJETO 5 -> Hago click en él
' IDENTIFICO OBJETO 6 -> Espero a que esté en pantalla

' OPERACIONES que puedo hacer...
' Depende del tipo de objeto... pero por ejemplo:
' .Click
' .Exist(10)    ' Me devuelve un booleano indicando si el objeto existe o no en pantalla. El número entre paréntesis es el tiempo máximo de espera en segundos.
' .Set "Texto a introducir en un campo de texto"                ' Me permite introducir texto en un campo de texto
' .SetSecure "Texto a introducir en un campo de contraseña"     ' Me permite introducir texto en un campo de contraseña, pero el texto no se muestra en el informe de pruebas por seguridad.
' .GetROProperty("text")    ' Me devuelve el valor de la propiedad "text" del objeto, que suele ser el texto que se muestra en pantalla para ese objeto.
' .GetTOProperty("text")    ' Me devuelve el valor de la propiedad "text" del objeto tal y como está definido en el repositorio de objetos, es decir, el valor que se espera que tenga esa propiedad para que el objeto sea reconocido.

' Como identifico un elemento? Realmente eso se hace en el Registro de UFT.

---
> Ejemplo: Happy path de la app de citas médicas de Katalon

# Dado que 
1. Ir a la URL: https://katalon-demo-cura.herokuapp.com/ en un naveador
2. Esperar 10 segundos a que exista en pantalla (se haya cargado) el botón "Make appointment"
2.1. Si está en el botón: click
2.2. Si no está en el botón: fallo en el informe de pruebas 
     Acabar el test

3. Caso que si... Espero 10 segundos a que exista en pantalla el campo de texto "Username"

# Cuando:
1. Lo relleno con "John Doe"
2. Busco el elemento para la contraseña y lo relleno con "ThisIsNotAPassword"
3. Busco el botón de login y hago click en él

# Entonces
1. Espero 10 segundos a que exista en pantalla el título "Make Appointment"
2. Si lo encuentro: Registro un evento de éxito en el informe de pruebas
3.  Si no lo encuentro: Registro un evento de fallo en el informe de pruebas
---


Nota:
Un lenguaje de programación es un "lenguaje" porque tiene una grámatica asociada.
La gramática implica a su vez una sintaxis... y una semántica.
Hay distintas palabras que podemos usar... y que tienen un significado (SEMANTICA)
    En VBScript: Dim, Option Explicit
La sintaxis es cómo uso esas palabras... y cómo las junto para formar algo que sea inteligible.

    La principal dificultad con los lenguajes de programación es que son lo que llamamos LENGUAJES FORMALES,
    En contraposicioón de los lenguajes que habalamos los humanos: LENGUAJES NATURALES

    Los lenguajes formales tienen reglas de sintaxis muy estrictas. Y nuestro cerebro no está acostumbrado... hay que darle tiempo.
    Realmente, desde niños aprendemos 2 lenguajes... 
    - Uno natural   ESPAÑOL
                      Dos más dos es igual a cuatro 
                      Cuatro es dos más dos
                      Dos más dos es cuatro
                      Dos más dos igual a cuatro
    - Uno formal    MATEMÁTICAS
                      2+2=4 
                      2=24+

# Selenium

Es otra herramienta de pruebas para UIs de tipo WEB.
De hecho... selenium se llama así en honor a UFT.
Originalmente UFT era Mercury... y cómo era insufrible de usar (al manos para los creadores de Selenium) lo llamaron a ese nuevo producto Selenium por que el sSelenio es lo que se recomiendo (tratamiento) cuando hay una intoxicación por Mercurio

En Selenium, la identificación de objetos se hace dentro del Script.
En UFT, la identificación de objetos se hace desde el REGISTRO de OBJETOS.
En los script solo referenciamos objetos del registro.

Selenium es más simple de configurar. También es mucho más difícil de mantener.






# Appium
Su nombre viene de Selenium... mezclado con app (para mobile)


---

UFT y Selenium al final hacen uso por debajo para apps web del mismo concepto: El estandar del W3C llamado WebDriver
W3C da muchos estandares:
- HTML
- CSS
- XML
- WCAG (para accesibilidad)
- WebDriver (para automatización tareas en navegadores web)