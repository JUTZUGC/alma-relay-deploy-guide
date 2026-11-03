# alma-relay 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/yetone/alma-relay#deploy
# 更新日期：2026-11-03
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/yetone/alma-relay.git
Set-Location alma-relay
Copy-Item .env.example .env
Write-Host "把 .env 里的 RELAY_DOMAIN 改成你的域名，并把域名解析到这台服务器"
docker compose up -d

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/yetone/alma-relay#deploy'
