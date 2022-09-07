FROM ubuntu:20.04
RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends -y \
        arping \
        arptables \
        bridge-utils \
        ca-certificates \
        conntrack \
        curl \
        dnsutils \
        ethtool \
        iperf \
        iperf3 \
        iproute2 \
        # commented out since bionic repository fails with a timestamp issue
        # ipsec-tools \
        ipset \
        iptables \
        iputils-ping \
        jq \
        kmod \
        ldap-utils \
        less \
        libpcap-dev \
        man \
        manpages-posix \
        mtr \
        net-tools \
        netcat \
        netcat-openbsd \
        openssl \
        openssh-client \
        psmisc \
        socat \
        tcpdump \
        telnet \
        tmux \
        traceroute \
        tcptraceroute \
        tree \
        ngrep \
        vim \
        wget && \
        rm -rf /var/lib/apt/lists/* && \
        mv /usr/sbin/tcpdump /usr/bin/tcpdump && \
        mv /usr/sbin/traceroute /usr/bin/traceroute && \
        curl -sLf https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 > /usr/bin/docker && \
        chmod +x /usr/bin/docker && \
        curl -sLf https://storage.googleapis.com/kubernetes-release/release/v1.16.8/bin/linux/amd64/kubectl > /usr/local/bin/kubectl-1.16 && \
        curl -sLf https://storage.googleapis.com/kubernetes-release/release/v1.17.4/bin/linux/amd64/kubectl > /usr/local/bin/kubectl-1.17 && \
        curl -sLf https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl > /usr/local/bin/kubectl-1.18 && \
        chmod +x /usr/local/bin/kubectl* && \
        ln -s /usr/local/bin/kubectl-1.18 /usr/local/bin/kubectl && \
        wget https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64 -O /usr/bin/yq && \
        chmod +x /usr/bin/yq && \
        mkdir -p /root/.kube

RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update && apt-get -y upgrade && \
    apt-get -f -y install curl apt-transport-https lsb-release gnupg python3-pip && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    CLI_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${CLI_REPO} main" \
    > /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli openssh-server && \
# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
    rm -rf /var/lib/apt/lists/* && \
    echo "root:Docker!" | chpasswd 

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
# RUN apt-get install openssh-server \
#      && echo "root:Docker!" | chpasswd 

# Copy the sshd_config file to the /etc/ssh/ directory
COPY azure/sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY azure/ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

# Open port 2222 for SSH access
EXPOSE 80 2222
ADD start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]

# ENTRYPOINT [ "/bin/bash"]
# CMD ["-c", "trap : TERM INT; systemctl start ssh ; sleep 2147483647 & wait"]