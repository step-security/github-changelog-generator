FROM gradle:9.6-jdk17-alpine@sha256:5beee04f4c08985b5522ec7c68611fb8744f2fbbd19227305f544e6beebba876 AS build
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
