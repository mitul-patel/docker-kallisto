FROM ubuntu:15.10

MAINTAINER Mitul Patel <mitul428@gmail.com>

LABEL version="v0.43.0"

FROM r-base
FROM bioconductor/release_base2

# install dependencies

RUN apt-get update  && apt-get install -y \
                build-essential \
                cmake \
                python \
                python-pip \
                python-dev \
                hdf5-tools \
                libhdf5-dev \
                hdf5-helpers \
                libhdf5-serial-dev \
                git \
                apt-utils

# install kallisto from source

WORKDIR /docker-repo
RUN git clone https://github.com/pachterlab/kallisto.git 
WORKDIR /docker-repo/kallisto
RUN mkdir build
WORKDIR /docker-repo/kallisto/build 
RUN cmake .. && \
        make && \
        make install && \
        kallisto version 

# install sleuth

RUN echo 'source("https://bioconductor.org/biocLite.R")' > /tmp/packages.R
RUN echo 'biocLite("devtools")' >> /tmp/packages.R
RUN echo 'biocLite("pachterlab/sleuth")' >> /tmp/packages.R
RUN Rscript /tmp/packages.R
