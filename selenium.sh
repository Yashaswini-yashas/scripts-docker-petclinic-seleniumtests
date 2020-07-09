#!/bin/bash

##### removing previously running docker containers and docker images 

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker images -a && docker rmi $(docker images -a -q)
rm -rf petclinic docker-selenium

##### pulling docker image for tomcat and starting tomcat, binding tomcat to port 7009 

docker pull yashaswini1234/petclinic
docker run -d -it -p 7009:7009 yashaswini1234/petclinic bash
docker ps -a | sed -n '2p'|awk '{print $1}' > containeridpetclinic.txt
CONTAINERIDPETCLINIC=`cat containeridpetclinic.txt`
echo $CONTAINERIDPETCLINIC
docker exec -d -it $CONTAINERIDPETCLINIC /home/apache-tomcat-8.5.56/bin/catalina.sh run

##### cloning petclinic and selenium tests repo 

git clone https://github.com/Yashaswini-yashas/petclinic.git
git clone https://github.com/Yashaswini-yashas/docker-selenium.git
#sleep 10

##### building the dockerfile 

docker build -t petclinic .
docker run -d -it petclinic bash
docker ps -a | sed -n '2p'|awk '{print $1}' > containeridone.txt
CONTAINERID=`cat containeridone.txt`
echo $CONTAINERID
docker cp $CONTAINERID:/home/target/petclinic.war /home/ec2-user/tmp
docker ps -a | sed -n '3p'|awk '{print $1}' > containeridtwo.txt
CONTAINERIDTWO=`cat containeridtwo.txt`
echo $CONTAINERIDTWO

##### coping the petclinic war file into tomcat webapps folder

docker cp /home/ec2-user/tmp/petclinic.war $CONTAINERIDTWO:/home/apache-tomcat-8.5.56/webapps
sleep 5

##### running the selenium tests using docker volume command

docker run -it -v /home/ec2-user/docker-selenium/com.cg.SeleniumReportGeneration:/home petclinic mvn install
