# alma-relay 一键部署指南

> 第三方部署指南 · 非 alma-relay 官方仓库。官方项目：[yetone/alma-relay](https://github.com/yetone/alma-relay)
> 内容来自官方文档（2026-11-03）。项目迭代快，请以[官方文档](https://github.com/yetone/alma-relay#deploy)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己敲命令，让百度搭子帮你把 Docker 环境跑起来。

⚠️ Docker 方案需要一台公网服务器，80 与 443 开放，并把域名解析过去；Caddy 会自动申请证书。反向代理必须放行 WebSocket 且不缓冲响应。可选 TURN 用于复杂网络。没有公网服务器时，可以改用 Cloudflare Workers 免费方案。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/alma-relay-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会克隆仓库、复制环境变量模板并用 Docker Compose 起中继与 Caddy，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）



## alma-relay 是什么？

alma-relay 是开源的不用端口映射，也不依赖第三方中继：自己的服务器就是手机与桌面之间的桥（协议：MIT，<img src="https://img.shields.io/github/stars/yetone/alma-relay?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

Alma 远程访问的自托管中继：手机与桌面通过自己的服务器配对并转发连接，支持自动 HTTPS 与可选 TURN，避免端口映射。

- 自托管中继，不经过第三方
- Docker Compose 带 Caddy 自动证书
- 支持 WebSocket 与 TURN
- 也可部署到 Cloudflare Workers
- 令牌按用户签发
- MIT，可自用可二开

（来源：[官方仓库](https://github.com/yetone/alma-relay)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 416 stars | 名称搜索 16 条（每页 20 条时一页） |
| 自托管 | 不依赖第三方中继 |
| Docker 一条命令起 | 自带 HTTPS |
| 也可用 Cloudflare Workers 免费部署 | — |
| 支持 TURN | 复杂网络更稳 |
| MIT | 可自用可二开 |

| 需要注意 | 说明 |
|---|---|
| Docker 方案需要公网服务器与域名 | — |
| 80/443 必须可达 | — |
| 反代配置要求较细 | — |
| 推送通知要另配 APNs/FCM | — |
| 项目很新 | 协议可能变 |

> 以上基于官方文档与社区反馈整理（2026-11-03），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/yetone/alma-relay.git
cd alma-relay
cp .env.example .env
echo "把 .env 里的 RELAY_DOMAIN 改成你的域名，并把域名解析到这台服务器"
docker compose up -d
```

部署步骤来源：[https://github.com/yetone/alma-relay#deploy](https://github.com/yetone/alma-relay#deploy)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Docker/Cloudflare/自建反代三种方式与 8787 端口 | 已核对 2026-11-03 |
| 确认 RELAY_DOMAIN、令牌签发与 TURN profile | 已核对 2026-11-03 |
| 未实测部署与配对 | 说明 2026-11-03 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-03 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-03 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-03）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\alma-relay-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 三种部署方式

| 方式 | 需要 |
|---|---|
| Cloudflare Workers | 免费，无需服务器 |
| Docker + Caddy | 公网服务器、域名、80/443 |
| 自有反代 | 服务器与已有 HTTPS |

## Docker 部署

```bash
git clone https://github.com/yetone/alma-relay && cd alma-relay
cp .env.example .env
docker compose up -d
```

把 `RELAY_DOMAIN` 改成你的域名，解析到服务器，Caddy 会自动签发证书。

## 签发令牌

```bash
docker compose exec relay node scripts/mint-token.mjs alice
```

## 反代要求

- 放行 WebSocket Upgrade
- 关闭响应缓冲
- 保持长连接

## 注意

- 80/443 必须可达，否则证书失败
- 没有 TURN 时，严格 NAT 下可能连不上
- 令牌按人签发，泄露后立即更换
- 推送通知需要额外的 APNs / FCM 配置
- 中继只转发连接，不保存你的桌面画面

## 常见坑

- 证书失败：确认域名解析与 80/443 可达
- 连不上：检查反代是否放行 WebSocket 并关闭缓冲
- TURN 不生效：用 `--profile turn` 单独起
- 令牌无效：用 `mint-token` 重新签发
- 手机端配对失败：确认中继地址是 HTTPS 域名
- 响应被缓冲：Nginx 加 `proxy_buffering off`
- CF Workers 部署失败：检查 wrangler 登录与 Durable Objects 权限

## 免责声明

本仓库为第三方指南，与 alma-relay 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-03），项目迭代快，请以[官方文档](https://github.com/yetone/alma-relay#deploy)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
