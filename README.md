# Flutter AI Template

从 Oil Business App 提取的独立 Flutter 起点，仅包含本地演示登录和 Home。保留 feature-first 页面分层、Cubit、GoRouter、琥珀主题以及 Codex + OpenSpec + Superpowers + Context7 开发约定；业务 API、站点/订单/支付、原生签名、渠道、上传脚本及历史业务规格不带入。

## 启动

使用 Flutter 3.47.5（Dart 3.13.4，CI 相同）。目录名 flutter-ai-template，Dart 包名 flutter_ai_template。

```bash
flutter pub get
flutter run -d chrome
# 或连接 Android/iOS 设备后运行
flutter run
```

演示账号：`demo@example.com`，密码：`demo12345`。点击“填入演示账号”可自动填写。会话仅存内存，重启需重新登录；演示身份验证不是生产安全实现。

## 结构

- lib/pages/login、lib/pages/home：page/controller/state/view。
- lib/data/auth：AuthRepository 契约与本地 Demo 实现；通过 TemplateApp 注入真实实现。
- lib/global/session_controller.dart：内存登录状态。
- lib/router/app_router.dart：登录路由守卫。
- lib/resources/theme.dart、lib/widgets：主题与三个基础组件。
- docs/development：开发规范；openspec/specs：仅本模板的登录与 Home 规格。

## 验证

```bash
python3 scripts/check.py docs
python3 -m unittest discover -s scripts -p 'test_check.py'
python3 scripts/check.py full
flutter build web
```

检查不写回源文件、不暂存、不提交；Flutter 会写构建缓存。初次使用前初始化本地 Git（如尚未初始化）：`git init`。CI 仅执行检查，不发布。

## 接入真实登录

新增 OpenSpec change 确认接口和验收，新增 AuthRepository 实现，通过 TemplateApp(authRepository: ...) 注入。当前模板不包含 HTTP 客户端、token 持久化或 refresh token；路由守卫不能替代服务端鉴权。不要直接将演示密码校验用于生产。

Android/iOS 使用 com.example 占位应用身份，创建正式应用时更换应用标识、图标和展示名称；iOS 签名需在本机配置。模板没有继承任何后台地址或发布凭据。

Superpowers/Context7 在开发者环境独立配置，文档存在不表示已安装。规范入口见 [AGENTS.md](AGENTS.md)。
