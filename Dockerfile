FROM maven:3-eclipse-temurin-17 as app

WORKDIR /app
COPY ./src ./
RUN mvn package -Dmaven.test.skip

FROM postgres:14

COPY --from=app /app/target/app.jar ./app.jar
COPY --from=app /opt/java /opt/java

ARG DBNAME=db
ARG DBUSER=app
ARG DBPASS=pass

ENV POSTGRES_DB=$DBNAME
ENV POSTGRES_USER=$DBUSER
ENV POSTGRES_PASSWORD=$DBPASS

ARG JDBC_URL="jdbc:postgresql://localhost:5432/${DBNAME}?user=${DBUSER}&password=${DBPASS}"
ENV JDBC_URL=$JDBC_URL

COPY ["./docker-entrypoint-initdb.d/", "./docker-entrypoint-initdb.d/"]
COPY ["./docker-entrypoint.sh", "/docker-entrypoint.sh"]

EXPOSE 8080
EXPOSE 5432
ENTRYPOINT ["./docker-entrypoint.sh"]