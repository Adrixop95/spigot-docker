FROM openjdk:11-jre-slim AS base

WORKDIR /spigot
EXPOSE 25565

FROM openjdk:11-jre-slim AS build

RUN apt-get update && \
    apt-get install -y wget git

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar
RUN cp spigot-*.jar spigot.jar

FROM build AS final
WORKDIR /spigot
COPY --from=build spigot.jar .
COPY helpers/entrypoint.sh .

RUN chmod +x /spigot/entrypoint.sh

CMD ["/spigot/entrypoint.sh"]