FROM ubuntu:trusty
MAINTAINER Jean-Michel Ruiz <jean.ruiz@cismet.de>

ENV DATA_DIR /data
ENV LIB_DIR ${DATA_DIR}/lib
ENV MAVEN_LIB_DIR ${LIB_DIR}/m2
ENV JAVA_VERSION 8
ENV JAVA_UPDATE 77
ENV JAVA_BUILD 03
ENV OPENSSL_VERSION 1.0.2g
ENV MAVEN_VERSION 3.3.9
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle
ENV JRE_HOME ${JAVA_HOME}/jre
ENV MAVEN_HOME /usr/share/maven
ENV UPDATE_SNAPSHOTS TRUE

RUN apt-get update \
  && apt-get -y --no-install-recommends install ca-certificates curl gcc libc6-dev libssl-dev make

RUN mkdir -p /usr/lib/jvm
RUN curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem --header "Cookie: oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/"${JAVA_VERSION}"u"${JAVA_UPDATE}"-b"${JAVA_BUILD}"/server-jre-"${JAVA_VERSION}"u"${JAVA_UPDATE}"-linux-x64.tar.gz | tar xz -C /tmp
RUN mv /tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} "${JAVA_HOME}"

RUN curl --silent --location --retry 3 --cacert /etc/ssl/certs/GlobalSign_Root_CA.pem https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xz -C /tmp
RUN cd /tmp/openssl-"${OPENSSL_VERSION}" ; ./config --prefix=/usr
RUN cd /tmp/openssl-"${OPENSSL_VERSION}" ; make clean
RUN cd /tmp/openssl-"${OPENSSL_VERSION}" ; make
RUN cd /tmp/openssl-"${OPENSSL_VERSION}" ; make install

RUN mkdir -p ${MAVEN_HOME}
RUN curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC ${MAVEN_HOME} --strip-components=1
RUN ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

RUN apt-get remove --purge --auto-remove -y gcc libc6-dev libssl-dev make
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1
RUN update-alternatives --set java "${JRE_HOME}/bin/java"
RUN update-alternatives --set javac "${JAVA_HOME}/bin/javac"

RUN apt-get update \
  && apt-get install -y postgresql-client \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${MAVEN_LIB_DIR}/javax/servlet/jsp/jsp-api/2.1.2
COPY jsp-api-2.1.2.pom $MAVEN_LIB_DIR/javax/servlet/jsp/jsp-api/2.1.2/
COPY policy.file ${DATA_DIR}/
COPY truststore.ks ${DATA_DIR}/