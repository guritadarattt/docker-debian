FROM --platform=linux/amd64 debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install package minimal untuk server
RUN apt update -y && apt install --no-install-recommends -y \
    # Core system
    dbus \
    # Networking tools
    net-tools iproute2 iputils-ping dnsutils traceroute netcat-openbsd \
    curl wget rsync telnet socat \
    # SSH
    openssh-server openssh-client \
    # Editor & utilities
    vim nano less man-db bash-completion \
    # Monitoring
    htop lsof psmisc procps \
    # Archive
    tar gzip bzip2 xz-utils zip unzip \
    # Security
    sudo ufw fail2ban \
    # Time & locale
    tzdata locales \
    # Misc
    cron logrotate rsyslog \
    # SSL
    openssl ca-certificates \
    # Tools
    jq tree file bc debianutils \
    # Package management
    apt-utils apt-transport-https gnupg lsb-release \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup locale
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Setup SSH
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set root password
RUN echo 'root:root' | chpasswd

# Setup timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ==========================================
# SSH BANNER SETUP - GURITA VPS
# ==========================================

# Matikan MOTD default
RUN rm -rf /etc/update-motd.d/* && \
    rm -f /etc/motd /etc/issue /etc/issue.net && \
    touch /etc/motd /etc/issue /etc/issue.net && \
    sed -i 's/^session.*pam_motd.so/#&/' /etc/pam.d/sshd && \
    sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config

# Banner GURITA VPS (post-login)
RUN BANNER_FILE=/etc/profile.d/gurita-banner.sh && \
    cat > "$BANNER_FILE" <<'EOF'
#!/bin/bash
case $- in
    *i*) ;;
    *) return ;;
esac
clear
echo ""
echo "=========================================="
echo "          G U R I T A   V P S"
echo "=========================================="
echo ""
echo "   ____  _   _ ____ ___ _____  _"
echo "  / ___|| | | |  _ \\_ _|_   _|/ \\"
echo " | |  _ | | | | |_) | |  | | / _ \\"
echo " | |_| || |_| |  _ <| |  | |/ ___ \\"
echo "  \\____| \\___/|_| \\_\\_|  |_|_/   \\_\\"
echo ""
echo ""
echo "=========================================="
echo " User     : $(whoami)"
echo " Uptime   : $(uptime -p 2>/dev/null || echo 'N/A')"
echo " Date     : $(date)"
echo "=========================================="
echo ""
EOF
RUN chmod +x /etc/profile.d/gurita-banner.sh

# Pre-auth banner
RUN printf '\n  GURITA VPS - Authorized Access Only\n\n' > /etc/ssh/banner && \
    echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config

# ==========================================
# END BANNER SETUP
# ==========================================

# Cleanup
RUN apt autoremove -y && \
    apt autoclean -y && \
    rm -rf /var/lib/apt/lists/* \
           /var/cache/apt/archives/* \
           /tmp/* /var/tmp/* \
           /usr/share/doc/* \
           /usr/share/man/* \
           /usr/share/locale/* \
           /var/log/*.log

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
