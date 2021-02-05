---
layout: default
title: "Access control vulnerabilities - PortSwigger"
permalink: /access-control-ps/
---

# Access control vulnerabilities - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/access-control](https://portswigger.net/web-security/access-control)

## Índice



## 1. Lab: Unprotected admin functionality

```
Este laboratorio tiene un panel de administración desprotegido.

Resuelva el laboratorio eliminando el usuario carlos.
```

Entonces accedemos al sitio web y colocamos la ruta del fichero **robots.txt** y nos retorna el siguiente contenido:

![](img1.png)

Entonces vamos a la nueva ruta donde nos aparecerá el panel de administracion.

![](img2.png)

Ahora eliminamos a carlos y completamos el laboratorio.

![](img3.png)

## 2. Lab: Unprotected admin functionality with unpredictable URL

