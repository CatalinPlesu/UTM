FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing
RUN apt-get install -y apt-utils
RUN apt-get install -y htop 
RUN apt-get install -y vim
RUN apt-get install -y nano
RUN apt-get install -y openssh-client
RUN apt-get install -y openssh-server

RUN apt-get install -y g++
RUN apt-get install -y make
RUN apt-get install -y libomp-dev

RUN useradd -ms /bin/bash student
USER student
WORKDIR /home/student/lab1/openmp

ENTRYPOINT ["/bin/bash"]