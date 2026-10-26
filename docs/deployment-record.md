# seekdb 部署记录（2026 OceanBase 数据库大赛 · 赛题一）

- 部署时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- 部署平台：本机 WSL2（Ubuntu 24.04.5 LTS，内核 6.18.54.1-microsoft-standard-WSL2）
- 容器镜像：quay.io/oceanbase/seekdb:latest（819 MB，digest sha256:4db4961869d554313520d6081fca29265ba6da6db7313311bd8acbed771a956b）
- 运行方式：docker run -d --name seekdb -p 2881:2881
- 实例版本：5.7.25-OceanBase seekdb-v1.4.0.0
- SQL 验证：select 1 → 1 ｜ version() → 5.7.25-OceanBase seekdb-v1.4.0.0
- telemetry 文件：/var/lib/seekdb/run/telemetry.json（容器内）
- content.id（遥测 ID，提交用）：
  602481c9-c11e-8601-8760-e4886989c362

## 变更记录
- 2026-10-26 04:14 UTC：原实例（ID 60cd144e-…）在提测平台查询不到上报记录，
  docker restart 不会重新上报（日志显示 Already initialized，telemetry.json 未重写），
  故 docker rm -f 后以 --dns 223.5.5.5 --restart unless-stopped 重建实例，
  新实例遥测 ID 为 602481c9-c11e-8601-8760-e4886989c362。
