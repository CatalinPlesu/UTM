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
RUN apt-get install -y ruby
RUN apt-get install -y ruby-dev
RUN gem install bunny

RUN apt-get install -y sudo
RUN useradd -ms /bin/bash -G sudo student

RUN echo "student:student" | chpasswd

RUN mkdir -p /home/student/.ssh
RUN chown student /home/student/.ssh
RUN chmod 700 /home/student/.ssh
RUN mkdir /var/run/sshd
RUN chown student /var/run/sshd
RUN chown student /etc/ssh/ssh_host_rsa_key

USER student
RUN ssh-keygen -t rsa -f /home/student/.ssh/id_rsa -q -P ""
RUN cat /home/student/.ssh/id_rsa.pub >> /home/student/.ssh/authorized_keys

WORKDIR /home/student/lab2

CMD ["/usr/sbin/sshd", "-D"]