---
layout: default
title: "Business logic vulnerabilities - PortSwigger"
permalink: /business-logic-ps/
---

# Business logic vulnerabilities - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/logic-flaws](https://portswigger.net/web-security/logic-flaws)

## Índice



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

 