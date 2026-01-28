FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install base utilities
RUN apt-get update --fix-missing
RUN apt-get install -y apt-utils htop vim nano sudo \
    openssh-client openssh-server g++ make \
    python3 python3-pip python3-venv

# Create user
RUN useradd -ms /bin/bash -G sudo student
RUN echo "student:student" | chpasswd

# Set up SSH
RUN mkdir -p /home/student/.ssh
RUN chown student /home/student/.ssh
RUN chmod 700 /home/student/.ssh
RUN mkdir /var/run/sshd
RUN chown student /var/run/sshd
RUN ssh-keygen -t rsa -f /home/student/.ssh/id_rsa -q -P ""
RUN cat /home/student/.ssh/id_rsa.pub >> /home/student/.ssh/authorized_keys

# Switch to student
USER student

# Set working dir and copy app
WORKDIR /home/student/lab2
COPY --chown=student:student . .

# Install Python dependencies in user environment
RUN pip3 install --no-cache-dir -r requirements.txt

# Default to running SSH; can override to run the Go app
CMD ["/usr/sbin/sshd", "-D"]
