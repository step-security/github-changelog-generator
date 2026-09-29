FROM gradle:9.8-jdk17-alpine@sha256:eaba124debec2bfd0e03d38f9f49409b4b739d6fbda0c5db999451d23d8b132b AS build
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
