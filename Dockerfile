# docker image build -f Dockerfile -t mitsuba-renderer-nogui:latest .
FROM ubuntu:18.04

ARG numprocs=4

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y build-essential apt-utils \
    && apt-get update -y && apt-get upgrade -y \
    && echo 'alias clc="clear;ls"' >> ~/.bashrc \
    && mkdir -p /home/mitsuba && cd /home \
    && apt-get install -y vim \
    && apt-get install -y scons libpng-dev libjpeg-dev libilmbase-dev libxerces-c-dev libboost-all-dev libopenexr-dev libglewmx-dev libxxf86vm-dev libpcrecpp0v5 libeigen3-dev libfftw3-dev \
    && apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev \
    && apt-get install -y git \
    && git clone https://github.com/mitsuba-renderer/mitsuba mitsuba-renderer \
    && cd mitsuba-renderer && cp ./build/config-linux-gcc.py ./config.py \
    && scons -j $numprocs \
    && echo 'source /home/mitsuba-renderer/setpath.sh' >> ~/.bashrc

WORKDIR /home/mitsuba
ENTRYPOINT ["/bin/bash", "-c", "bash /home/mitsuba/render.sh"]
