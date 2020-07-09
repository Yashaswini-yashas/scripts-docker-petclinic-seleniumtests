FROM yashaswini1234/maven-chrome
COPY petclinic /home
WORKDIR /home
RUN mvn install


