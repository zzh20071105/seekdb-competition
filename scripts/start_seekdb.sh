#!/bin/bash
# seekdb 启动脚本（WSL2 无 systemd 环境下手工拉起 dockerd + 容器）
set -u
if ! pgrep -x dockerd >/dev/null; then
    nohup dockerd > /var/log/dockerd.log 2>&1 &
fi
for i in $(seq 1 30); do
    [ -S /var/run/docker.sock ] && break
    sleep 2
done
if docker ps -a --format '{{.Names}}' | grep -qx seekdb; then
    docker start seekdb >/dev/null
else
    docker run -d --name seekdb -p 2881:2881 quay.io/oceanbase/seekdb >/dev/null
fi
for i in $(seq 1 40); do
    if mysql -h127.0.0.1 -P2881 -uroot -e 'select 1' >/dev/null 2>&1; then
        echo "seekdb ready: $(mysql -h127.0.0.1 -P2881 -uroot -N -e 'select version()' 2>/dev/null)"
        exit 0
    fi
    sleep 3
done
echo "seekdb 未就绪，查看 docker logs seekdb"
exit 1
