FROM ubuntu:xenial
MAINTAINER muabnessor <adam.rosenbaum@umu.se>

LABEL description="Image for fastqc, cutadapt, trim-galore, and multiqc"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    cmake \
    default-jdk \
    git \
    libnss-sss \
    libtbb2 \
    libtbb-dev \
    ncurses-dev \
    python-dev \
    python-pip \
    tzdata \
    unzip \
    wget \
    zlib1g \
    zlib1g-dev \
    python3-pip \
    python3-dev

RUN pip3 install --upgrade pip==9.0.1
RUN pip3 install setuptools

WORKDIR /tmp
ENV DEST_DIR /opt/
RUN mkdir -p $DEST_DIR

# fastqc install

ENV FASTQC_URL http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
ENV FASTQC_VERSION 0.11.4
ENV FASTQC_RELEASE fastqc_v${FASTQC_VERSION}.zip

RUN wget ${FASTQC_URL}/${FASTQC_RELEASE} && unzip ${FASTQC_RELEASE} -d ${DEST_DIR} && rm ${FASTQC_RELEASE}
RUN chmod a+x ${DEST_DIR}/FastQC/fastqc
ENV PATH ${DEST_DIR}/FastQC:$PATH

# cutadapt install
ENV CUTADAPT_VERSION 1.16

RUN pip3 install --user --upgrade cutadapt==${CUTADAPT_VERSION} && \
    ln -s /root/.local/bin/cutadapt /usr/bin/

# trim-galore install
ENV TRIM_GALORE_VERSION 0.4.4
ENV TRIM_GALORE_URL http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/
ENV TRIM_GALORE_RELEASE trim_galore_v${TRIM_GALORE_VERSION}.zip
RUN wget ${TRIM_GALORE_URL}/${TRIM_GALORE_RELEASE} && unzip ${TRIM_GALORE_RELEASE} -d ${DEST_DIR} && rm ${TRIM_GALORE_RELEASE}
RUN ln -s /opt/trim_galore /usr/local/bin/trim_galore

# multiqc install
ENV MULTIQC_VERSION 1.8
RUN pip3 install --user --upgrade multiqc==${MULTIQC_VERSION} && \
    ln -s /root/.local/bin/multiqc /usr/bin/
