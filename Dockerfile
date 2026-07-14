FROM gradle:8.5.0-jdk17-alpine@sha256:e4f3af5b65fb20115bb8d2054fea4d37e0389aa003735ca6d7b035c9c0d9fb70 as build
COPY src /app/src/
COPY config /app/config/
COPY build.gradle settings.gradle gradle.properties /app/
RUN cd /app && gradle -Dorg.gradle.welcome=never --no-daemon bootJar

FROM ghcr.io/bell-sw/liberica-openjre-debian:25.0.2-12@sha256:0381085ca2f80495c33e3060e9945099371854550c8ade4a114aa9217db9f72c
COPY --from=build /app/build/libs/github-changelog-generator.jar /opt/action/github-changelog-generator.jar
ENTRYPOINT ["java", "-jar", "/opt/action/github-changelog-generator.jar"]
