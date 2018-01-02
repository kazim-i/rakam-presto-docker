FROM ubuntu:16.04

WORKDIR /var/app

ARG P_VERSION
ENV PRESTO_VERSION ${P_VERSION}

ENV PRESTO_STREAMER_HOME /var/app/presto-streamer
ENV PRESTOST_CONF_DIR ${PRESTO_STREAMER_HOME}/etc

RUN mkdir -p /var/app/presto-streamer/etc

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

COPY templates/etc/  ${PRESTOST_CONF_DIR}/
COPY templates/presto-collector-heartbeat.sh /var/app/presto-collector-heartbeat

COPY bin/entrypoint.sh ./entrypoint.sh
COPY bin/mustache.sh ./mustache.sh
COPY lib/mustache.sh ./lib/mustache.sh
RUN chmod +x entrypoint.sh mustache.sh lib/mustache.sh presto-collector-heartbeat

RUN wget -N https://s3.amazonaws.com/rakam-private-code/rakam-presto-builds/${PRESTO_VERSION}/latest.tar.gz
RUN tar -zxvf latest.tar.gz
RUN mv collector-*/* ./presto-streamer/
RUN rm -r collector-*
RUN rm latest.tar.gz

# TODO datadir

ENTRYPOINT [ "./entrypoint.sh" ]
