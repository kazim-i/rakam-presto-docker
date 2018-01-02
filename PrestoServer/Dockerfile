FROM ubuntu:16.04

WORKDIR /var/app

ARG P_VERSION
ARG U_VERSION
ARG R_VERSION

ENV PRESTO_VERSION ${P_VERSION}
ENV PRESTO_UDF_VERSION ${U_VERSION}
ENV RAPTOR_VERSION ${R_VERSION}

ENV PRESTO_HOME /var/app/presto
ENV PRESTO_CONF_DIR ${PRESTO_HOME}/etc
ENV DATA_DIR /mnt/presto

RUN mkdir -p /var/app/presto/etc/catalog
RUN mkdir -p /var/app/presto/plugin/presto-rakam-raptor
RUN mkdir -p /var/app/presto/plugin/presto-rakam-udf
RUN mkdir -p ${DATA_DIR}

# Install Java.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:${JAVA_HOME}/bin:${PRESTO_HOME}/bin


RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*


RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    git \
    libpq-dev \
    make \
    python-pip \
    python2.7 \
    python2.7-dev \
    ssh \
    curl \
    jq \
    unzip \
    psmisc \
    && apt-get autoremove \
    && apt-get clean

COPY templates/etc/  ${PRESTO_CONF_DIR}/
COPY templates/presto-server-heartbeat.sh /var/app/presto-server-heartbeat

COPY bin/entrypoint.sh ./entrypoint.sh
COPY bin/mustache.sh ./mustache.sh
COPY lib/mustache.sh ./lib/mustache.sh
RUN chmod +x entrypoint.sh mustache.sh lib/mustache.sh presto-server-heartbeat

RUN wget -N https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz
RUN tar -zxvf presto-server-${PRESTO_VERSION}.tar.gz
RUN cp -r presto-server-${PRESTO_VERSION}/bin/ presto/
RUN cp -r presto-server-${PRESTO_VERSION}/lib/ presto/

RUN if [ -z  $PRESTO_UDF_VERSION ]; then curl -s https://api.bintray.com/packages/buremba/maven/presto-rakam-udf | jq -r '.latest_version'; else echo $PRESTO_UDF_VERSION; fi > /root/presto_udf_version
RUN wget -nc https://dl.bintray.com/buremba/maven/com/facebook/presto/presto-rakam-udf/$(cat /root/presto_udf_version)/presto-rakam-udf-$(cat /root/presto_udf_version).zip
RUN unzip -o presto-rakam-udf-$(cat /root/presto_udf_version).zip
RUN rm -rf ./presto/plugin/presto-rakam-udf
RUN mkdir ./presto/plugin/presto-rakam-udf
RUN mv presto-rakam-udf-$(cat /root/presto_udf_version)/* ./presto/plugin/presto-rakam-udf

RUN if [ -z $RAPTOR_VERSION ]; then curl -s https://api.bintray.com/packages/buremba/maven/presto-rakam-raptor | jq -r '.latest_version'; else echo $RAPTOR_VERSION; fi > /root/raptor_version
RUN wget -nc https://dl.bintray.com/buremba/maven/com/facebook/presto/presto-rakam-raptor/$(cat /root/raptor_version)/presto-rakam-raptor-$(cat /root/raptor_version).zip
RUN unzip -o presto-rakam-raptor-$(cat /root/raptor_version).zip
RUN rm -rf ./presto/plugin/presto-rakam-raptor
RUN mkdir ./presto/plugin/presto-rakam-raptor
RUN mv presto-rakam-raptor-$(cat /root/raptor_version)/* ./presto/plugin/presto-rakam-raptor

RUN rm -rf presto-*

ENTRYPOINT [ "./entrypoint.sh" ]
