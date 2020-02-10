FROM openjdk:8-alpine AS builder

RUN apk add --no-cache curl unzip

WORKDIR /opt
ARG SONAR_SCANNER_VER="4.2.0.1873"
RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip && \
    mv sonar-scanner-${SONAR_SCANNER_VER}-linux sonar-scanner && \
    SONAR_RUNNER_HOME=/opt/sonar-scanner && \
    export PATH=$PATH:$SONAR_RUNNER_HOME/bin && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner && \
	rm -rf $SONAR_RUNNER_HOME/jre

FROM openjdk:8-alpine

ENV SONAR_RUNNER_HOME /opt/sonar-scanner
ENV PATH $SONAR_RUNNER_HOME/bin:$PATH

COPY --from=builder /opt/sonar-scanner /opt/sonar-scanner

RUN apk add --no-cache nodejs nodejs-npm
