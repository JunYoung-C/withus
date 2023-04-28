#FROM alpine:latest AS build
#
#ARG COMPILER_URL=https://github.com/JetBrains/kotlin/releases/download/v1.5.30/kotlin-compiler-1.5.30.zip
#
#RUN apk update
#RUN apk add openjdk11
#
#ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
#ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:${PATH}
#
#ENV LANG=ko_KR.utf8
#ENV LANGUAGE=ko_KR.utf8
#ENV LC_ALL=ko_KR.utf8
#
#RUN apk --no-cache add tzdata && \
#	cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
#	echo "Asia/Seoul" > /etc/timezone \
#	apk del tzdata \
#
#RUN apk add --no-cache bash && \
#    apk add --no-cache -t build-dependencies wget && \
#    cd /usr/lib && \
#    wget -q $COMPILER_URL && \
#    unzip kotlin-compiler-*.zip && \
#    rm kotlin-compiler-*.zip && \
#    rm -f kotlinc/bin/*.bat && \
#    apk del --no-cache build-dependencies
#
#ENV PATH $PATH:/usr/lib/kotlinc/bin
#
#CMD ["kotlinc"]
#
#COPY --chown=gradle:gradle . /home/gradle/src
#WORKDIR /home/gradle/src
#RUN ./gradlew bootJar --no-daemon --scan
#
#FROM openjdk:11-jre-slim-buster
#
#EXPOSE 8080
#
#RUN mkdir /app
#
#COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
#
#ENV LANG=ko_KR.utf8
#ENV LANGUAGE=ko_KR.utf8
#ENV LC_ALL=ko_KR.utf8
#
#RUN apk --no-cache add tzdata && \
#	cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
#	echo "Asia/Seoul" > /etc/timezone \
#	apk del tzdata
#
#ENTRYPOINT ["java", "-Dspring.profiles.active=local-h2", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

FROM openjdk:11-jre-slim-buster

COPY build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Dspring.profiles.active=local-h2", "-jar","app.jar"]