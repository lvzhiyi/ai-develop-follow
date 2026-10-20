# Project Context

## Purpose

Flutter AI Template：可独立运行的登录和 Home 最小模板，用于试跑及复用 AI 开发工作流。

## 技术栈

Flutter / Dart、flutter_bloc 9.1.1、go_router 16.3.0；具体版本见 pubspec.yaml 和 pubspec.lock。平台：Android、iOS、Web。没有后端连接和持久化会话。

## 工程入口

- [代码规范](../docs/development/coding.md)
- [架构规范](../docs/development/architecture.md)
- [UI 规范](../docs/development/ui.md)
- [验证规范](../docs/development/testing.md)
- [AI 工作流](../docs/development/ai-workflow.md)
- [接口联调约定](../docs/development/api-integration.md)

业务规格仅含 specs/user-auth 和 specs/home；changes/ 用于新需求，无原业务历史。新增业务、鉴权或持久化方案按 [OpenSpec 指南](AGENTS.md) 提案并确认后实施。
