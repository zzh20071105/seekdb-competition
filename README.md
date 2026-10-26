> 2026 年 OceanBase 数据库大赛 · 赛题一「部署一个 seekdb」
> 参赛者：zzh20071105　｜　提交物：实例遥测 ID

## 一、本题要求（原文要点）

| 项 | 内容 |
|---|---|
| 任务 | 部署并启动一个 seekdb 实例，平台不限 |
| 提交产物 | 实例的**遥测 ID**（`run/telemetry.json` 里的 `content.id`，UUID） |
| 最低验收 | 实例能连接、能执行 SQL；建议留部署截图 |
| 分值 | 10 分 |

## 二、本次部署结果

| 项 | 值 |
|---|---|
| 部署平台 | 本机 Windows 11 + WSL2（Ubuntu 24.04.5 LTS，内核 6.18.54.1-microsoft-standard-WSL2） |
| 容器镜像 | `quay.io/oceanbase/seekdb:latest`（819 MB） |
| 镜像 digest | `sha256:4db4961869d554313520d6081fca29265ba6da6db7313311bd8acbed771a956b` |
| 启动命令 | `docker run -d --name seekdb -p 2881:2881 quay.io/oceanbase/seekdb` |
| 实例版本 | `5.7.25-OceanBase seekdb-v1.4.0.0` |
| SQL 验证 | `select 1` → `1`；`select version()` → 上述版本行 |
| telemetry 路径 | 容器内 `/var/lib/seekdb/run/telemetry.json` |
| **遥测 ID** | **`60cd144e-a195-81b5-b1ae-0d8baac9a155`** |

## 三、复现步骤

```bash
# 1. 安装 Docker（Ubuntu）
bash scripts/setup.sh          # 配清华 apt 镜像 → 装 docker.io → 拉起 dockerd

# 2. 拉镜像（Docker Hub 不可达时用 quay.io / ghcr.io，三仓库等价）
docker pull quay.io/oceanbase/seekdb

# 3. 启动实例
docker run -d --name seekdb -p 2881:2881 quay.io/oceanbase/seekdb

# 4. 验证
mysql -h127.0.0.1 -P2881 -uroot -e 'select version()'

# 5. 取遥测 ID
docker exec seekdb cat /var/lib/seekdb/run/telemetry.json
```

重启后恢复（WSL2 里 dockerd 不是系统服务）：

```bash
wsl -d Ubuntu -u root -- bash /root/start_seekdb.sh
```

## 四、本次踩到的三个坑

1. **WSL 无法在线安装发行版**
   `wsl --install -d Ubuntu` 报
   `未能从 raw.githubusercontent.com/.../DistributionInfo.json 提取分发列表，操作超时`。
   绕法：从 `https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/` 下载
   `ubuntu-base-24.04.5-base-amd64.tar.gz`，用 `wsl --import Ubuntu C:\WSL\Ubuntu <tarball> --version 2` 手动注册。

2. **Docker Hub 直连超时**
   `registry-1.docker.io` 不通，`quay.io`、`ghcr.io` 正常（均返回 401 认证挑战＝可达）。
   所以镜像从 quay.io 拉取，与 Docker Hub 官方镜像为同一份。

3. **ubuntu-base 没有 CA 证书，https 镜像自锁**
   首次 `apt-get update` 报 `No system certificates available`。
   绕法：先把 apt 源切成 `http://mirrors.tuna.tsinghua.edu.cn/ubuntu`，
   装完 `ca-certificates` 再装其余软件包。

## 五、注意事项

- **容器不要删除重建**：`docker rm seekdb` 后重新 `run`，`telemetry.json` 会重新生成，
  `content.id` 随之改变，与已提交的 ID 不再对应。
- `wsl --status` 若提示“未启用虚拟化”，需在 BIOS 打开 Intel Virtualization Technology，
  并用管理员执行一次 `wsl --install --no-distribution` 后重启。
- 本机 WSL 发行版为 `wsl --import` 方式安装，默认用户为 root，无 systemd，
  因此 dockerd 需脚本手动拉起（见 `scripts/start_seekdb.sh`）。

## 六、目录

```
scripts/setup.sh           Ubuntu 内安装 docker 并启动 dockerd（含 apt 镜像与 CA 引导）
scripts/start_seekdb.sh    重启后一键恢复：起 dockerd → 起容器 → 轮询 SQL 就绪
docs/deployment-record.md  部署记录（环境、镜像、验证输出、遥测 ID）
```
