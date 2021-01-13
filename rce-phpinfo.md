---
layout: default
title: "PHPINFO + LFI = RCE"
permalink: /rce-phpinfo/
---

# PhpInfo + LFI = RCE

## Creando el entorno

Version Actual

	PHP Version 7.4.11

Crear los archivos en el directorio /var/www/html

```php
┌─[root@parrot]─[/var/www/html]
└──╼ #cat phpinfo.php 
<?php
	phpinfo();
?>
┌─[root@parrot]─[/var/www/html]
└──╼ #cat lfi.php 
<?php
	require($_GET['file']);
?>
```

## Ejecutando el Exploit

![Exploit Run](https://funkyimg.com/i/392Gg.png)

![Get Shell](https://funkyimg.com/i/392Gh.png)

## Analizando Exploit

### En el codigo

![Xploit](https://funkyimg.com/i/392Gi.png)

![xploit2](https://funkyimg.com/i/392Gj.png)

### Analizando con Wireshark

![Packet HTTP](https://funkyimg.com/i/392Gk.png)

### Packet HTTP Request

```
POST /phpinfo.php?a=A...A HTTP/1.1
HTTP_ACCEPT: A...A
HTTP_USER_AGENT: A...A
Content-Type: multipart/form-data; boundary=---------------------------7dbff1ded0714
Content-Length: 3661
Host: 127.0.0.1

-----------------------------7dbff1ded0714
Content-Disposition: form-data; name="dummyname"; filename="test.txt"
Content-Type: text/plain

Security Test
<?php
    ...code...;
?> 

-----------------------------7dbff1ded0714--
```

### Packet HTTP Response

![packeter_http_response](https://funkyimg.com/i/392Gm.png)

### Execute Code Php

![Request-Shell-Code](https://funkyimg.com/i/392Gn.png)



## Referencias

https://www.hackplayers.com/2018/12/race-condition-phpinfo-mas-lfi-rce.html

https://github.com/M4LV0/LFI-phpinfo-RCE

https://hub.docker.com/r/dimonpvt/php5.5.9

https://developer.mozilla.org/es/docs/Web/HTTP/Headers/Content-Type

https://tools.ietf.org/html/rfc7231#section-3.1.1.4
