# seekdb 部署记录（2026 OceanBase 数据库大赛 · 赛题一）

- 部署时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- 部署平台：本机 WSL2（Ubuntu 24.04.5 LTS，内核 6.18.54.1-microsoft-standard-WSL2）
- 容器镜像：quay.io/oceanbase/seekdb:latest（819 MB，digest sha256:4db4961869d554313520d6081fca29265ba6da6db7313311bd8acbed771a956b）
- 运行方式：docker run -d --name seekdb -p 2881:2881
- 实例版本：5.7.25-OceanBase seekdb-v1.4.0.0
- SQL 验证：select 1 → 1 ｜ version() → 5.7.25-OceanBase seekdb-v1.4.0.0
- telemetry 文件：/var/lib/seekdb/run/telemetry.json（容器内）
- content.id（遥测 ID，提交用）：
  60cd144e-a195-81b5-b1ae-0d8baac9a155
