#!/bin/bash

#Set Up the Virtual Environment
#launch the apps

deactivate

source ./myproj/bin/activate


cd ./frontend
cp ./../npm_build.sh ./

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 3000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :3000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

. npm_build.sh & > npm_output.txt


cd ./../

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 5000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :5000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

flask run & > flask_output.txt

echo "*********************************"
echo "*                               *"
echo "*        WAITING. ....          *"
echo "*        API not ready          *"
echo "*                               *"
echo "*********************************"


finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://127.0.0.1:5000/flask/hello")
    if [ $health_status == "200" ]; then
        finished=true
        echo "*********************************"
        echo "*                               *"
        echo "*        API is ready           *"
        echo "*                               *"
        echo "*********************************"
    else
        finished=false
    fi
done
echo""
echo""


read -p "Press Enter to Terminate Application:" 

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 5000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :5000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 3000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :3000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

deactivate