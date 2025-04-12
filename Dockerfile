FROM openjdk:17-jdk-slim AS build

WORKDIR /app

COPY . /app/

RUN ./gradlew clean build


FROM gcr.io/distroless/java17-debian12
ARG application_name
ARG application_version
WORKDIR /code
COPY --from=build /app/build/libs/${application_name}-${application_version}.jar /code/app.jar
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "app.jar" ]


# Build the Docker image
# docker build --build-arg application_name=$(./gradlew -q printName) --build-arg application_version=$(./gradlew -q printVersion) -t myapp .