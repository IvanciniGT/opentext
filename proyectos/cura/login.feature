#language:es

Característica: Login

Esquema del escenario:      Login con datos correctos

    Dado        que tengo un navegador
     Y          que tengo cargada la página con el formulario de login
    Cuando      relleno en el campo usuario el valor: "<usuario>"
     Y          relleno en el campo contraseña el valor: "<contraseña>"
     Y          pulso sobre el botón e hacer login
    Entonces    llego a la pantalla principal de la aplicación

    Ejemplos:

        | usuario     | contraseña          |
        | Jonh Doe    | ThisIsNotAPassword  |

---

> que tengo cargada la página con el formulario de login???

    Al final en UFT VBScript es:

        OBJETO.Exists(10)

  La pregunta es cómo identifico ese objeto en UFT