---
layout: default
title: "Bit Flipper Attack"
permalink: /bit-flipper-attack/
---

# Bit Flipper Attack

Para esta demostracion usaremos la maquina de padding oracle, de PentesterLab.

https://pentesterlab.com/exercises/padding_oracle/

Empezamos creando un usuario llamado bmin

![create user](img1.png)

Y luego nos logeamos para obtener la cookie por burpsuite.

![proxy](img2.png)

Luego lo que hacemos es enviarlo al intruder y seleccionamos la cookie para realizar el ataque.

![intruder](img3.png)

![payload](img4.png)

![](img5.png)

Luego, le damos clic en **Start Attack** y esperamos a que salgan los resultados.

Cuando salgan los resultados verificamos cual realiza el output deseado y esa sería la cookie valida.

![](img6.png)

Eso sería todo :D. 
