FROM openjdk:8-jre-alpine AS base

WORKDIR /spigot
EXPOSE 25565

FROM openjdk:8-jre-alpine AS build

RUN apk update && \
    apk add wget git && \
    rm -rf /var/cache/apk/*

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar
RUN cp spigot-*.jar spigot.jar

FROM base AS final
WORKDIR /spigot
COPY --from=build spigot.jar .
COPY helpers/entrypoint.sh .
COPY helpers/wait-for .

RUN chmod +x /spigot/entrypoint.sh
RUN chmod +x /spigot/wait-for

RUN chmod +x /spigot/spigot.jar

CMD /spigot/wait-for mysql:33060 -t 20 && /spigot/entrypoint.sh