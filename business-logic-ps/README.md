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

