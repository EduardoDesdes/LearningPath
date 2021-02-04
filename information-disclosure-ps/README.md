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