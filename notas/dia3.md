# Idempotencia

Es un concepto matemático. 
Al importar este concepto en software, entendemos por idempotencia que despues de ejecutar algo, el sistema queda siempre en el mismo estado, con independencia del estado inicial.

    IrALaPaginaDeLogin                    por definición (solo por el nombre que tiene) NO ES IDEMPOTENTE
    AsegurarQueEstoyEnLaPaginaDeLogin     por definición (solo por el nombre que tiene) DEBE SER IDEMPOTENTE

> Felipe, pon una silla debajo de la ventana                Imperativa

    NoLeftSpaceOnDviceException
    Error http status 500
    Exit code 127

> Felipe, debajo de la ventana solo tiene que haber una silla. Es tu responsabilidad.        DECLARATIVO

Al hacer esto, paso la patata a Felipe.

Con la primera forma, lo que estoy no es diciendo lo que quiero... sino lo que Felipe debe hacer.
Con la segunda forma, lo que estoy es definiendo el estado final que quier conseguir, con independencia del estado inicial.


---


# Prueba de Logout

Contexto
    Call AsegurarIrALaPantallaDeLogin()
    Call HacerLogin(usuarioBueno, PasswordBuena)
Accion
    Call Logout() // En qué pantalla? Cualquiera.. Tendre que probar desde varias
Comprobacion
    Que llego al home... y que ya no hay enlace de logout
    Que hay enlace de login

# Prueba de Login
Contexto: 
    Call AsegurarIrALaPantallaDeLogin()
        Call PonermeEnElHome()
         Call IntentaHacerLogout()
Acción:    
    Call HacerLogin(usuarioBueno, PasswordBuena)
Comprobación:
    Call QueLlegoALaPantallaDeCitas()

---

XPATH es otro estandar del W3C, igual que HTML, XML o CSS
Sirve para identificar objetos dentro de un documento XML

Puedo tratar el HTML como si fuera XPATH:

Sintaxis en XPATH:

/    Al principio de la expresión indica la raiz del documento
     En medio de una expresión una dependencia jerarquica de UN NIVEL (padre hijo)
//   Al princpio o en medio, indica dependencia jerarquica de cualquier número de niveles
NOMBRE:  TIPO DE ELEMENTO
 a
 div
 p
 *        Cualquier tipo de elemento
[]    Los leemos como tal que...
[12]  Del los nodos que haya ahí coge el número 12.. El primero.. el quinto        NO LO USAMOS EN LA VIDA!
[@atributo="valor"]  tal que el elemento tenga un atributo llamado "atributo" cuyo valor sea "valor"
text() Me devuelve el texto de un elemento
contains(texto, trozo)  Me devuelve si el texto contiene el trozo

text-danger
//*[@id="login"]//*[contains(text(), "failed") or contains(class, "danger")]



//div[@id="login"]/DIV[1]/DIV[1]/DIV[1]/P[2]
/html/body/section/div/div/div[1]/p[2]

//*[@id="login"]/div/div/div[1]/p[2]