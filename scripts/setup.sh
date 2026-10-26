#!/bin/bash
set -eu
export DEBIAN_FRONTEND=noninteractive

MIRROR="http://mirrors.tuna.tsinghua.edu.cn/ubuntu"
echo "=== 1. 配置 apt 镜像（http，先解决证书问题）==="
for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.sources; do
  [ -f "$f" ] || continue
  sed -i "s|https://mirrors.tuna.tsinghua.edu.cn/ubuntu|$MIRROR|g; s|http://archive.ubuntu.com/ubuntu|$MIRROR|g; s|http://security.ubuntu.com/ubuntu|$MIRROR|g" "$f"
done
grep -rh "^URIs" /etc/apt/sources.list.d/ 2>/dev/null | head -3

echo "=== 2. 先装 ca-certificates（http 通道）==="
apt-get update -qq
apt-get install -y -qq --no-install-recommends ca-certificates >/dev/null
echo "CA OK"

echo "=== 3. 安装 docker / 客户端 ==="
apt-get install -y -qq --no-install-recommends curl docker.io iptables iproute2 procps mariadb-client >/dev/null
echo "docker: $(docker --version)"

echo "=== 4. 启动 dockerd ==="
mkdir -p /var/log
if ! pgrep -x dockerd >/dev/null; then
  nohup dockerd > /var/log/dockerd.log 2>&1 &
fi
for i in $(seq 1 60); do
  [ -S /var/run/docker.sock ] && break
  sleep 2
done
docker info --format 'server={{.ServerVersion}} cgroup={{.CgroupVersion}} driver={{.Driver}}' || { tail -40 /var/log/dockerd.log; exit 1; }
echo "SETUP_OK"
