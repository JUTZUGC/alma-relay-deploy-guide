#!/usr/bin/env bash
set -euo pipefail
# alma-relay 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/yetone/alma-relay#deploy
# 更新日期：2026-11-03
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/yetone/alma-relay.git
cd alma-relay
cp .env.example .env
echo "把 .env 里的 RELAY_DOMAIN 改成你的域名，并把域名解析到这台服务器"
docker compose up -d

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/yetone/alma-relay#deploy"
