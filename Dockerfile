FROM gradle:8.6-jdk17-alpine@sha256:87f40d50d0015236f5aa95d13399508d70e44bc3d97f3bb80efe9a942957825b AS build
COPY src /app/src/
COPY config /app/config/
COPY build.gradle settings.gradle gradle.properties /app/
RUN cd /app && gradle -Dorg.gradle.welcome=never --no-daemon bootJar

FROM ghcr.io/bell-sw/liberica-openjre-alpine:25.0.2@sha256:87025d11840c8e873019b59f2d64a6b3da4bc5e126bb6d51aa3cd86f1b8b27be
RUN apk add --no-cache \
    "libcrypto3=3.5.7-r0" \
    "libssl3=3.5.7-r0" \
    "musl=1.2.5-r23" \
    "musl-utils=1.2.5-r23" \
    "zlib=1.3.2-r0"
COPY --from=build /app/build/libs/github-changelog-generator.jar /opt/action/github-changelog-generator.jar
ENTRYPOINT ["java", "-jar", "/opt/action/github-changelog-generator.jar"]
