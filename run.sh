!/bin/bash

#Set Up the Virtual Environment
#dependencies
. setup_env_dep.sh
. setup_venv.sh

#Now create the front-end
. create_react_app.sh

cd ./frontend
npm run build
npm start & >npm_output.txt

cd ./../

run flask & >flask_output.txt

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

