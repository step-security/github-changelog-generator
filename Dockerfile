FROM gradle:9.7-jdk17-alpine@sha256:d537e24fca45130a3d10f4cbe91018cfd6bca92b7fade34ed57f807afedaeb9a AS build
COPY src /app/src/
COPY config /app/config/
COPY build.gradle settings.gradle gradle.properties /app/
RUN cd /app && gradle -Dorg.gradle.welcome=never --no-daemon bootJar

FROM ghcr.io/bell-sw/liberica-openjre-alpine:17.0.18-10@sha256:4506dae61e61ef9e1350dd3c1e7b54d50e8f0b4614798664366abedbdf01086a
RUN apk add --no-cache \
    "libcrypto3=3.5.7-r0" \
    "libssl3=3.5.7-r0" \
    "musl=1.2.5-r23" \
    "musl-utils=1.2.5-r23" \
    "zlib=1.3.2-r0"
COPY --from=build /app/build/libs/github-changelog-generator.jar /opt/action/github-changelog-generator.jar
ENTRYPOINT ["java", "-jar", "/opt/action/github-changelog-generator.jar"]
