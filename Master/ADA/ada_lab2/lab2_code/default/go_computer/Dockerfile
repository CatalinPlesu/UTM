FROM golang:1.21-bullseye

RUN go version

# Install extra tools
RUN apt-get update && apt-get install -y \
    openssh-client \
    openssh-server \
    vim nano htop sudo

# Create non-root user
RUN useradd -ms /bin/bash -G sudo student && \
    echo "student:student" | chpasswd

# SSH configuration
RUN mkdir -p /home/student/.ssh && \
    chown student /home/student/.ssh && \
    chmod 700 /home/student/.ssh && \
    mkdir /var/run/sshd

USER student
RUN ssh-keygen -t rsa -f /home/student/.ssh/id_rsa -q -P "" && \
    cat /home/student/.ssh/id_rsa.pub >> /home/student/.ssh/authorized_keys

# Set working directory
WORKDIR /home/student/lab2

RUN go mod init github.com/catalin/module || true
RUN go mod tidy
RUN go mod download

# Copy application code
COPY --chown=student:student . .

# Default to running SSH; can override to run the Go app
CMD ["/usr/sbin/sshd", "-D"]
