FROM openjdk:8-alpine AS builder

RUN apk add --no-cache curl unzip

WORKDIR /opt

RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-3.3.0.1492-linux sonar-scanner && \
    SONAR_RUNNER_HOME=/opt/sonar-scanner && \
    export PATH=$PATH:$SONAR_RUNNER_HOME/bin && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner && \
	rm -rf $SONAR_RUNNER_HOME/jre && \
	echo export SONAR_RUNNER_HOME=$SONAR_RUNNER_HOME >> /etc/profile

FROM openjdk:8-alpine
COPY --from=builder /opt/sonar-scanner /opt/sonar-scanner
COPY --from=builder /etc/profile /etc/profile