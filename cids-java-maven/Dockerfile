FROM ubuntu:xenial
MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

LABEL de.cismet.cids.java.maven.name="cids-java-maven runtime image" \
      de.cismet.cids.java.maven.version="jdk-1.8u121-2.0" \
      de.cismet.cids.java.maven.tag.docker="jdk-1.8u121-2.0" \
      de.cismet.cids.java.maven.tag.git="jdk-1.8u121-2.0" \
      de.cismet.cids.java.maven.descripton="Java and Maven Runtime Image" 

# keep DATA_DIR for backwards compatilibity with cids-server-* images
ENV DATA_DIR /cidsDistribution 
ENV LIB_DIR ${DATA_DIR}/lib
ENV MAVEN_LIB_DIR ${LIB_DIR}/m2
ENV MAVEN_OPTS -XX:-OmitStackTraceInFastThrow -server -Xms512m -Xmx1024m
ENV JAVA_VERSION 8
ENV JAVA_UPDATE 121
ENV JAVA_BUILD 13
ENV OPENSSL_VERSION 1.1.0e
ENV MAVEN_VERSION 3.3.9
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle
ENV JRE_HOME ${JAVA_HOME}/jre
ENV MAVEN_HOME /usr/share/maven
ENV IMPORT_DIR /import
ENV CIDS_ACCOUNT_EXTENSION CidsReference
ENV UPDATE_SNAPSHOTS -U
ENV PATH="${JAVA_HOME}/bin:${PATH}"

#WORKDIR ${DATA_DIR}/

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get -y --no-install-recommends install ca-certificates curl gcc libc6-dev libssl-dev make openssl

# ridiculous oracle download url
# See https://gist.github.com/P7h/9741922
RUN mkdir -p /usr/lib/jvm \
    && curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/"${JAVA_VERSION}"u"${JAVA_UPDATE}"-b"${JAVA_BUILD}"/e9e7ea248e2c4826b92b3f075a80e441/server-jre-"${JAVA_VERSION}"u"${JAVA_UPDATE}"-linux-x64.tar.gz | tar xz -C /tmp \
    && mv /tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} "${JAVA_HOME}"

RUN mkdir -p ${MAVEN_HOME} \
    && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC ${MAVEN_HOME} --strip-components=1 \
    && ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

RUN apt-get remove --purge --auto-remove -y gcc libc6-dev libssl-dev make

RUN update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/bin/java" 1 \ 
    && update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 \
    && update-alternatives --set java "${JRE_HOME}/bin/java" \
    && update-alternatives --set javac "${JAVA_HOME}/bin/javac"

# add letsencrypt certificates (use docker ADD to fetch always the freshest certificate!
# RUN curl -O --silent --retry 3 https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.der \
ADD https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.der /tmp
RUN keytool -import -alias lets-encrypt-x3-cross-signed -keystore ${JRE_HOME}/lib/security/cacerts -file /tmp/lets-encrypt-x3-cross-signed.der -storepass changeit \
    && rm -f /tmp/lets-encrypt-x3-cross-signed.der

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y postgresql-client zip\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY lib $MAVEN_LIB_DIR/

# default java policy file
COPY policy.file ${DATA_DIR}/
