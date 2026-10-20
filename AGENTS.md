<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Codex 开发入口

- 背景：[openspec/project.md](openspec/project.md)。
- 工作流与技能：[AI 开发工作流](docs/development/ai-workflow.md)。
- 编码前读：[代码规范](docs/development/coding.md)、[架构规范](docs/development/architecture.md)。
- UI：[UI 规范](docs/development/ui.md)；接口：[联调约定](docs/development/api-integration.md)。
- 验证：[验证规范](docs/development/testing.md)。
- 续做任务：[交接规则](docs/development/ai-workflow.md#中断与恢复交接)。
- 第三方 API 主动查询 Context7 并匹配锁定版本；工具不可用时查对应官方文档或依赖源码，明确限制。
- 新能力先按 OpenSpec 提案，已批准后实施；文档、配置和恢复预期行为的 Bug 可直接处理。
- 保留用户已有修改，不手改生成代码，不自动提交、推送或发布。
- 不引入原应用业务依赖或凭据；不将演示登录描述为真实鉴权。
- 开工检查基线，失败分类处理，中断保存快照；只报告实际验证的范围。
