FROM maven:3.6.3-jdk-11 AS maven
USER root
COPY ./ /tmp/code
RUN cd /tmp/code && mvn clean package -Dmaven.test.skip=true -Dmaven.javadoc.skip=true


FROM openjdk:11-jdk-oracle
COPY --from=maven /tmp/code/target/*.jar /webdav.jar
EXPOSE 8080
ENV JAVA_OPTS="-Xmx1g"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /webdav.jar", "-p", "8080:8080", "-v", "/etc/localtime:/etc/localtime", "-v", "/etc/aliyun-driver/:/etc/aliyun-driver/", "-e", "TZ='Asia/Shanghai'", "-e", "ALIYUNDRIVE_REFRESH_TOKEN="$REFRESE_TOKEN", "-e", "ALIYUNDRIVE_AUTH_PASSWORD=$PASSWD", "-e", "JAVA_OPTS="-Xmx1g", "zx5253/webdav-aliyundriver"]
