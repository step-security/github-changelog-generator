FROM gradle:8.6-jdk17-alpine@sha256:87f40d50d0015236f5aa95d13399508d70e44bc3d97f3bb80efe9a942957825b AS build
COPY src /app/src/
COPY config /app/config/
COPY build.gradle settings.gradle gradle.properties /app/
RUN cd /app && gradle -Dorg.gradle.welcome=never --no-daemon bootJar

FROM ghcr.io/bell-sw/liberica-openjre-alpine:25-37@sha256:218ff7542fc2e54b984cab13eac969f447365b55b053e9ec91f5a90415451f1a
RUN apk add --no-cache \
    "libcrypto3=3.5.7-r0" \
    "libssl3=3.5.7-r0" \
    "musl=1.2.5-r23" \
    "musl-utils=1.2.5-r23" \
    "zlib=1.3.2-r0"
COPY --from=build /app/build/libs/github-changelog-generator.jar /opt/action/github-changelog-generator.jar
ENTRYPOINT ["java", "-jar", "/opt/action/github-changelog-generator.jar"]
