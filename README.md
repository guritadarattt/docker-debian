# docker-debian
Lightweight Debian-based Server Docker Image with Custom SSH Banner (GURITA VPS)

## 📖 Description
Docker image berbasis **Debian 12 (slim)** tanpa desktop environment (headless).
Dirancang ringan, cepat, dan siap pakai untuk kebutuhan server seperti SSH remote access,
networking tools, dan utility dasar server.

## ✨ Features
- 🐧 Base: Debian 12 (slim, amd64)
- 🪶 Sangat ringan (~200-250MB)
- 🔐 SSH server siap pakai (port 22)
- 🎨 Custom banner "GURITA VPS" saat login SSH
- 🌐 Networking tools lengkap (ping, dig, traceroute, netcat, socat)
- 🛡️ Security tools (ufw, fail2ban, openssl)
- 🕒 Timezone & locale sudah dikonfigurasi (Asia/Jakarta)
- 📦 Utilities: vim, nano, htop, jq, tree, curl, wget, rsync, dll

## 🚀 Usage
```bash
docker run -d --name gurita-vps -p 2222:22 gurita-vps
```
🔑 Access via SSH
```bash
ssh root@localhost -p 2222
```
Default password: root

⚠️ Segera ganti password setelah login pertama!

```bash
passwd
```
🐳 DockerHub
https://hub.docker.com/r/akarita/docker-gurita-vps

📥 Docker Pull
```bash
docker pull akarita/docker-gurita-vps
```
🔨 Docker Build
```bash
docker build . -t docker-gurita-vps
```
💾 Run dengan Volume Persisten (opsional)
```bash
docker run -d --name gurita-vps \
    -p 2222:22 \
    -v gurita-data:/data \
    gurita-vps
```
🖥️ Banner Preview
Pre-auth banner:

```text
  GURITA VPS - Authorized Access Only

root@localhost's password:
```
Post-login banner:

```text

==========================================
          G U R I T A   V P S
==========================================

   ____  _   _ ____ ___ _____  _
  / ___|| | | |  _ \_ _|_   _|/ \
 | |  _ | | | | |_) | |  | | / _ \
 | |_| || |_| |  _ <| |  | |/ ___ \
  \____| \___/|_| \_\_|  |_|_/   \_\


==========================================
 User     : root
 Uptime   : up 2 minutes
 Date     : Mon Sep 30 10:00:00 UTC 2026
==========================================

root@container:~#
```
⚙️ Customization
Ganti Timezone
Edit di Dockerfile:

```dockerfile
ENV TZ=Asia/Jakarta
```
Ganti Password Root
Edit di Dockerfile:

```dockerfile
RUN echo 'root:root' | chpasswd
```
Ubah Banner
Edit bagian BANNER_FILE=/etc/profile.d/gurita-banner.sh di Dockerfile.

📦 Included Packages
Kategori	Package
Core	dbus
Networking	net-tools, iproute2, iputils-ping, dnsutils, traceroute, netcat, socat, curl, wget, rsync, telnet
SSH	openssh-server, openssh-client
Editor	vim, nano, less, man-db, bash-completion
Monitoring	htop, lsof, psmisc, procps
Archive	tar, gzip, bzip2, xz-utils, zip, unzip
Security	sudo, ufw, fail2ban, openssl
System	tzdata, locales, cron, logrotate, rsyslog
Tools	jq, tree, file, bc, debianutils
⚠️ Notes
Image ini tidak menjalankan systemd — systemctl tidak akan berfungsi.
Container menggunakan sshd sebagai PID 1.

Untuk start service tambahan (cron, rsyslog), jalankan manual:

```bash
service cron start
service rsyslog start
```
Jika butuh systemctl (systemd), gunakan flag --privileged dan mount cgroup.

📄 License
MIT License (c) 2026 Gurita Darat

