---
layout: default
title: "Business logic vulnerabilities - PortSwigger"
permalink: /business-logic-ps/
---

# Business logic vulnerabilities - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/logic-flaws](https://portswigger.net/web-security/logic-flaws)

## Índice

* [1. Lab: Excessive trust in client-side controls](#1-lab-excessive-trust-in-client-side-controls)
* [2. Lab: High-level logic vulnerability](#2-lab-high-level-logic-vulnerability)
* [3. Lab: Low-level logic flaw](#3-lab-low-level-logic-flaw)
* [4. Lab: Inconsistent handling of exceptional input](#4-lab-inconsistent-handling-of-exceptional-input)
* [5. Lab: Inconsistent security controls](#5-lab-inconsistent-security-controls)
* [6. Lab: Weak isolation on dual-use endpoint](#6-lab-weak-isolation-on-dual-use-endpoint)
* [7. Lab: Insufficient workflow validation](#7-lab-insufficient-workflow-validation)
* [8. Lab: Authentication bypass via flawed state machine](#8-lab-authentication-bypass-via-flawed-state-machine)
* [9. Lab: Flawed enforcement of business rules](#9-lab-flawed-enforcement-of-business-rules)
* [10. Lab: Infinite money logic flaw](#10-lab-infinite-money-logic-flaw)
* [11. Lab: Authentication bypass via encryption oracle](#11-lab-authentication-bypass-via-encryption-oracle)
* [CONCLUSION](#conclusion)

## 1. Lab: Excessive trust in client-side controls

```bash
Esta práctica de laboratorio no valida adecuadamente la entrada del usuario. Puede aprovechar una falla lógica en su flujo de trabajo de compras para comprar artículos por un precio no deseado. Para resolver el laboratorio, compre una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Ahora lo que haremos será hacer clic es el producto que deseamos comprar.

**NOTA: NO SE OLVIDE QUE DEBE INICIAR CON SU CUENTA**

![](img1.png)

Y ahora intercpetaremos el paquete al hacer clic en **Add to cart**.

![](img2.png)

Como podemos ver, nos encontramos con un parametro llamado **price**, entonces nos da la idea de poder cambiar el valor del producto antes de generar la compra.

![](img3.png)

Luego vamos a la seccion del carrito y le damos clic en **Place Order**.

![](img4.png)

Y luego podemos ver que se completó satisfactoriamente el laboratorio.

![](img5.png)

## 2. Lab: High-level logic vulnerability

 ```
Esta práctica de laboratorio no valida adecuadamente la entrada del usuario. Puede aprovechar una falla lógica en su flujo de trabajo de compras para comprar artículos por un precio no deseado. Para resolver el laboratorio, compre una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
 ```

Ahora lo que haremos será hacer clic es el producto que deseamos comprar.

**NOTA: NO SE OLVIDE QUE DEBE INICIAR CON SU CUENTA**

![](img6.png)

Y ahora intercpetaremos el paquete al hacer clic en **Add to cart**.

![](img7.png)

Como podemos ver, el parametro **quantity** tiene valor de 1, intentaremos actualizar su valor a **-1**.

![](img8.png)

Ahora, lo enviamos el paquete, y revisamos la respuesta.

![](img9.png)

Como podemos ver, nos va a costar la compra el modico precio de: **-1337** (LOL), entonces le damos clic en **Place order**

![](img10.png), 

Con la misma logica, vamos a realizar la siguiente configuracion.

![](img11.png)

Y como vemos logramos completar el laboratorio.

![](img12.png)

## 3. Lab: Low-level logic flaw

```bash
Esta práctica de laboratorio no valida adecuadamente la entrada del usuario. Puede aprovechar una falla lógica en su flujo de trabajo de compras para comprar artículos por un precio no deseado. Para resolver el laboratorio, compre una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Ahora lo que haremos será hacer clic es el producto que deseamos comprar.

**NOTA: NO SE OLVIDE QUE DEBE INICIAR CON SU CUENTA**

![](img13.png)

Y ahora intercpetaremos el paquete al hacer clic en **Add to cart**.

![](img14.png)

Enviamos el valor **-1** en el parametro **quantity**, pero no nos permite. 

Sabemos que un **integer** esta compuesto por 32 bits. Entonces una variable entera está en el rango de: **[ -2147483648 : 2147483647 ]**.

Como sabemos que el precio del producto es **1337**, entonces resolvemos al siguiente ecuacion.

```python
>>> (2147483647*2.0)/133700
32123.913941660434
```

Entonces, sabemos que, tenemos que reptir 32123 veces el producto, y como maximo solo podemos agregar 99 en una consulta.

```python
>>> 32123.0/99
324.47474747474746
```

Ahora enviamos el paquete anterior al intruder y seteamos la siguientes configuraciones.

![](img15.png)

En la parte de la cantidad d payloads especificamos 323, porque el intruder cuenta desde 0.

![](img16.png)

Y luego de damos en **Start Attack**.

![](img17.png)

Ahora vamos al carrito, a ver como quedó los resultados.

![](img18.png)

Entonces viendo cuandos mas nos falta, hacemos el siguiente calculo.

```python
>>> 6406096/133700
47
```

Entonces compramos 47 unidades manualmente del producto y tendríamos el siguiente resultado.

![](img19.png)

Como solo tenemos 100 de balance, no podemos exceder ese dinero, por ello que ya no podemos comprar mas productos de ese tipo. Por ello buscaremos un candidato que nos ayude a alcanzar el numero deceado. Elejiremos el producto **Giant Grasshopper** cuyo precio es: **71.20**, entonces:

```python
>>> 122196.0/7120
17.1623595505618
```

Entonces agregaremos 17 unidades del articulo **Giant Grasshopper**. El resultado sería el siguiente:

![](img20.png)

Entonces como podemos ver, todavia no llevamos a numeros positivos, así que agregamos 1 unidad mas a **Giant Grasshopper**.

![](img21.png)

Ahora si le damos clic en **Place Order**.

![](img22.png)

## 4. Lab: Inconsistent handling of exceptional input

```bash
Esta práctica de laboratorio no valida adecuadamente la entrada del usuario. Puede aprovechar una falla lógica en el proceso de registro de su cuenta para obtener acceso a la funcionalidad administrativa. Para resolver el laboratorio, acceda al panel de administración y elimine a Carlos
```

Intentaremos registrarnos usando un correo muy largo, para ver si ocurre algun caso excepcional con respecto al input.

```bash
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA@acd61f861ec39ef080ab06a901cf0050.web-security-academy.net
```

![](img23.png)

Nos da la siguiente respuesta:

```
Please check your emails for your account registration link
```

Entonces activamos la cuenta y vamos a la seccion **My Account**

![](img24.png)

Como podemos ver, cualquier correo que pongamos llegará al **email client** sin inportar que no sea el correo especificado ahí.

Ahora nos logeamos con nuestra cuenta creada luego de darle clic al enlace.

![](img25.png)

Como podemos ver, el correo se trunca ante una logitud. Lo que haremos será obtener la cantidad de caracteres donde se trunca el correo.

```python
>>> len("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA@acd61f861ec39ef080ab06a901cf0050.web-security-academy.")
255
```

Entonces pensaremos en un payload que al cortarse pueda truncarse y obtener el correo que deseamos.

```bash
textoo....oooo@dontwannacry.com.acd61f861ec39ef080ab06a901cf0050.web-security-academy.net
```

Ahora, entramos a un posible directorio llamado **admin** y nos dice que solo pueden ingresar los usuarios **DontWannaCry**.

![](img26.png)

Entonces, calculamos la longiutd del correo **@dontwannacry.com** y lo que resta lo rellenamos de **A**.

```python
>>> 255-len("@dontwannacry.com")
238
>>> print "A"*238
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

Nuestro payload sería pero debemos agregarle la finalidad **.acd61f861ec39ef080ab06a901cf0050.web-security-academy.net**.

```bash
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA@dontwannacry.com.acd61f861ec39ef080ab06a901cf0050.web-security-academy.net
```

Ahora nos registrmos con el payload como correo.

![](img27.png)

Y luego de activar la cuenta, ingresamos y vamos a la seccion de **My Account**.

![](img28.png)

Y como podemos ver, tenemos disponible el panel del **Admin**.

![](img29.png)

Nuestra mision es matar al usuario **carlos**.

![](img30.png)

Y logramos solucionar el laboratorio.

## 5. Lab: Inconsistent security controls

```bash
La lógica defectuosa de este laboratorio permite que usuarios arbitrarios accedan a funciones administrativas que solo deberían estar disponibles para los empleados de la empresa. Para resolver el laboratorio, acceda al panel de administración y elimine a Carlos.
```

Lo que haremos para este laboratorio será registrarnos, verificar el correo y luego logearnos e ingresar a la seccion **My account**.

![](img31.png)

Ahora lo que haremos será ir a la seccion de **/admin** y nos devuelve el siguiente error:

```bash
Admin interface only available if logged in as a DontWannaCry user
```

Entonces lo que haremos será en la seccion **My account** actualizamos el correo al siguiente correo:

```bash
attacker@dontwannacry.com
```

Y obtendriamos lo siguiente:

![](img32.png)

Ahora no vamos a la seccion **Admin panel** y eliminamos al usuario **carlos**.

![](img33.png)

Y luego completariamos el laboratorio.

![](img34.png)

## 6. Lab: Weak isolation on dual-use endpoint

```bash
Este laboratorio hace una suposición errónea sobre el nivel de privilegios del usuario en función de su entrada. Como resultado, puede aprovechar la lógica de sus funciones de administración de cuentas para obtener acceso a cuentas de usuarios arbitrarios. Para solucionar el laboratorio, acceda a la cuenta administrator y elimine a Carlos.

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Ingresamos con las credenciales que nos entregan, y nos dirigimos a la seccion **My account**, ahi lo que haremos será cambiar la contraseña, interceptamos el paquete y lo enviamos al **repeater**.

![](img35.png)

Como podemos ver tenemos varios parametros, entre ellos **username** el cual lo reemplazaremos por **administrator**, luego el **current-password** como no tenemos la clave, eliminaremos el parametro y seteamos una nueva contraseña que será **123**.

![](img36.png)

Y quedaría de la siguiente manera:

![](img37.png)

Ingresamos con el usuario **administrator** y la contraseña que especificamos que en nuestro caso es **123**.

![](img38.png)

Y eliminamos el usuario carlos para completar el laboratorio.

![](img39.png)

## 7. Lab: Insufficient workflow validation

```bash
Este laboratorio hace suposiciones erróneas sobre la secuencia de eventos en el flujo de trabajo de compras. Para resolver el laboratorio, aproveche este defecto para comprar una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Nos logeamos con las credenciales que nos dá el laboratorio, y luego compramos un item, el mas barato que encontremos para interceptar todos los paquetes y ver algo interesante que podamos encontrar.

![](img40.png)

Podemos ver, un paquete muy interesante, donde se realiza una validacion y confirmacion de la compra y la llevamos a repeater.

Dropearemos el paquete del proxy, y lo que haremos será cambiar el producto que agregamos por el de **Lightweight l33t leather jacket**.

![](img41.png)

Y luego vamos al repeater, donde dejamos nuestro paquete, y lo enviamos para analizar el resultado.

![](img42.png)

Y como podemos ver, nos generá un texto que nos dice que completamos el laboratorio. Entonces vamos a la pagina principal para verificar que se completó el laboratorio.

![](img43.png)

## 8. Lab: Authentication bypass via flawed state machine

```
Este laboratorio realiza suposiciones erróneas sobre la secuencia de eventos en el proceso de inicio de sesión. Para resolver el laboratorio, aproveche esta falla para evitar la autenticación del laboratorio, acceder a la interfaz de administración y eliminar a Carlos.

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Lo logeamos con las credenciales que nos dan e interceptamos todos los paquetes, podemos ver que uno de los mas interesantes es el siguiente,

![](img44.png)

Que enviamos algunos de los valores genera un paquete POST, que es el siguiente,

![](img45.png)

Podemos suponer que este recurso, **role-selector** sirve para actualizar el rol del usuario en el sitio web luego de realizarse el inicio de sesion, lo que intentaremos será simulas el mismo fujo pero haciendo un **drop** al momento que nos aparecer la solicitud **GET** de **/role-selector**.

![](img46.png)

Y luego vemos en el sitio web lo siguiente,

![](img47.png)

Lo cual tiene sentido porque realizamos un **drop** al request, entonces ahora simplemente accedemos al home del laboratorio y nos topamos con que nuestro rol está como administrador.

![](img48.png)

Ahora, accedemos al panel de administracion de eliminamos al usuario carlos para completar el laboratorio.

![](img49.png)

## 9. Lab: Flawed enforcement of business rules

```
Este laboratorio tiene una falla lógica en su flujo de trabajo de compras. Para resolver el laboratorio, aproveche este defecto para comprar una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Al entrar al laboratorio, nos topamos con lo siguiente:

```bash
New customers use code at checkout: NEWCUST5
```

Entonces, ahora bajando, nos encontramos con la siguiente seccion,

![](img50.png)

Ingresamos un correo cualquierda, para ver que ocurre y nos genera un alert con lo siguiente:

```bash
Use coupon SIGNUP30 at checkout!
```

Entonces luego de logearnos y como tenemos dos cupones, intentaremos comprar el articulo que nos piden, antes ingresando los cupones de descuento.

![](img51.png)

Como podemos ver, el primer cupon nos da un descuento de 5 dolares, mientras que el segundo nos dá un descuento de mas de 400 dolares. Entonces intentaremos usar de nuevo el segundo codigo para ver si se pueden acomular.

![](img52.png)

Entonces, nos salta un error de que el cupon ya se aplicó y que no se puede enviar de nuevo, ahora intentaremos con el otro cupon.

![](img53.png)

Vemos que el primero cupon si permite usar de nuevo, ahora podemos suponer dos cosas que el solo el primer cupon el que permite, o es que se puede enviar los cupones de manera intercalada para de esta manera saltar la "proteccion", así que intentaremos con el segundo cupón y de ser así lo intentamos hasta que el precio total sea menor que nuestro balance.

![](img54.png)

Realizamos la compra y completamos el laboratorio.

![](img55.png)

## 10. Lab: Infinite money logic flaw

```bash
Este laboratorio tiene una falla lógica en su flujo de trabajo de compras. Para resolver el laboratorio, aproveche este defecto para comprar una "Lightweight l33t leather jacket".

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

En primer lugar nos suscribimos al boletín para que nos dé el codigo de descuento el cual es:

```bash
Use coupon SIGNUP30 at checkout!
```

Luego abrimos el burpsuite interceptando en segundo plano los paquetes, y realizamos los siguientes pasos:

- Nos dirigimos al articulo de la **gift card**.
- La agregamos al carrito.
- Vamos al carrito y ejecutamos el codigo de descuento.
- Le damos en comprar.
- Y activamos el codigo de la **gift card** en **My account**.

Luego de realizar toda la tarea, vamos a configurar la macro, para ello seguiremos los siguientes pasos.

![](img56.png)

Nos saldrá una nueva ventana escribimos una descripcion y luego en **Rule Actions** le damos clic en **Add** y luego en **Run a macro**. En la nueva ventana le damos clic en add, y nos saldrá el visualizador de paquetes aquí seleccionamos los siguiente paquetes y le damos en **OK**.

![](img57.png)

Luego vamos al 5to paquete, para ver cual es el parametro de la gift card, y vemos que es **gift-card**.

![](img58.png)

Entonces ahora vamos al paquete 4, y configuramos lo siguiente haciendo clic en **configure item** y en **Add**.

![](img59.png)

Luego le damos en **OK** y ahora seleccionamos el 5to paquete, y luego clic en **Configure item**, vamos a donde dice **gift-card** y seleccionamos la opcion **Derive from prior response** y elejimos a la derecha **Response 4**.

![](img60.png)

Luego **OK** a todo hasta llegar a la ventana de **Session  handling rule editor**, y seleccionamos **Scope** con la siguiente configuracion:

![](img61.png)

Luego seleccionamos el paquete de **GET** del http history y lo enviamos al intruder.

![](img62.png)

Luego ahí hacemos clic en **Clear $**, y luego la siguiente cofiguracion.

![](img63.png)

Luego lo que haremos será obtener los montos por request, por ello iremos a la seccion de options y realizaremos la siguiente configuracion:

![](img64.png)

Y luego de toda esa configuracion podemos darle en **Start attack** y ver como se realizan los envios hasta llegar al monto necesario para comprar el articulo.

![](img65.png)

Revisamos si tenemos el saldo que nos devuelve el burpsutie.

![](img66.png)

Luego ya teniendo el dinero necesario, compramos el articulo y completamos el laboratorio.

![](img67.png)

## 11. Lab: Authentication bypass via encryption oracle

```bash
Este laboratorio contiene una falla lógica que expone un oráculo de cifrado a los usuarios. Para resolver el laboratorio, aproveche esta falla para obtener acceso al panel de administración y eliminar a Carlos.

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Empezaremos logeandonos y activando la casilla de **Stay logged in**. Luego enviamos un comentario con el correo invalido y vemos lo siguiente.

![](img68.png)

Nos muestra este error, y podemos ver en los paquetes, que existe una nueva cookie que se ah generado.

![](img69.png)

La cual se llama **notification** y podemos ver en el siguiente paquete, que se envia en la cookie e imprime el texto.

![ ](img70.png)

Así que enviaremos el GET al repeater, y en **notification** en vez de ese mensaje colocaremos la cookie de **stay-logger-in** y veremos cual es la respuesta que nos dá:

![](img71.png)

Entonces nuestra cookie de **stay-logger-in** contiene USUARIO:TIME , siendo TIME el tiempo de expiracion de la cookie. Ahora intentaremos enviar por email el siguiente payload.

```
administrator:1612462627960 
```

Y nos devolverá un texto cifrado.

![](img72.png)

Ahora, enviamos al desencriptador de la consulta anterior, para ver si nos devuelve el texto plano.

![](img73.png)

Funciona! Pero podemos ver que hay un problema, la cookie que enviariamos a **stay-logger-in** tiene un texto adelante que no nos sirve el cual es, **Invalid email address: **, entonces calculamos su longitud la cual es,

```python
>>> len("Invalid email address: ")
23
```

Entonces enviamos el texto cifrado al decoder de burp. Y hacemos las decodificaciones de HTML y BASE64.

![](img74.png)

Seleccionamos desde el bytes 24 para adelante y le damos encode **base64**.

![](img75.png)

Y lo enviamos al repeater para decifrarlo.

![](img76.png)

Pero nos dice que el texto cifrado debe ser multiplo de 16, (al parecer se está realizando un cifrado por bloques), Así que lo que haremos será en nuestro payload agregarle una cantidad para que al recortarle esa cantidad en el texto cifrado siga siendo multiplo de 16. Por ello sabemos que queremos cortar todo el texto anterior a **administrator**, por ello los 23 caracteres no nos es suficiente, y como necesitamos un multiplo de 16 entonces:

```python
>>> (16*2) - len("Invalid email address: ")
9
>>> 'A'*9
'AAAAAAAAA'
```

Entonces nuestro payload será 

```bash
AAAAAAAAAadministrator:1612462627960 
```

Enviando el payload en el parametro email para cifrarlo:

![](img77.png)

Y ahora, lo que haremos será llevar el texto cifrado al decoder, y realizamos las decodificaciones de **URL** y **BASE64**.

![](img78.png)

Y ahora seleccionamos desde el byte 33 para adelante y le damos encode **Base64**.

![](img79.png)

Ahora realizaremos un GET a /admin mediante el navegador, interceptando el paquete en el burpsuite, para realizar el cambio de la cookie.

![](img80.png)

**NOTA: Eliminamos la cookie de session para que no haga conflicto con la cookie de stay-logged-in.**

![](img81.png)

Y eliminamos al usuario carlos para completar el laboratorio.

![](img82.png)

## CONCLUSION

Este conjunto de laboratorios, son mucho mas interesantes pues aprendemos que las vulnerabilidades no sono son las conocidas, sino que tambien existen vulnerabilidades de logica que pueden cometer los desarolladores, vulnerabilidad algo raras pero que si analizamos el comportamiento de los sitios web, nos topamos que son totalmente válidas.

