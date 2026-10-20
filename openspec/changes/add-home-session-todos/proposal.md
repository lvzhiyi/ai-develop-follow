# Proposal: REQ-001 Home 待办基础与会话生命周期

## Why

PRD-TODO-001 v1.0 需要将模板 Home 的计数演示替换为个人待办，提供可拆解、可验证且不依赖后台的需求试跑。本 change 仅覆盖用户选中的 REQ-001，为会话内待办提供列表展示与生命周期基础。

## What Changes

- REQ-001：不可变待办模型、稳定 ID、倒序列表、初始空状态和会话结束后清空；保留登录、身份展示、路由守卫及退出。
- 模板演示调整：移除 Home 计数按钮及 increment 方法，对应计数测试替换为真实待办行为测试；登录接口及路由不变。

## Capabilities

### New Capabilities

- `personal-todos`：会话内待办身份、排序、只读展示、初始空状态及清空。

### Modified Capabilities

- `home`：Home 从计数示例改为待办容器，保留用户身份、退出与响应式行为。

`user-auth` 登录及路由契约不变，仅做回归验证。

## Impact

- 代码：lib/pages/home/、拟新增该模块的 model/widgets，现有公共组件和必要的会话绑定。
- 测试：test/auth_test.dart 的计数项、test/app_test.dart 的 Home 操作项，拟新增真实 Controller/Widget 待办测试。
- 依赖：本需求不改依赖，不新增 HTTP、存储或 ID 库。
- 不新增页面、后台、持久化、日期、通知、编辑或生产数据操作；不采用 v1.1 候选中的 60 字上限、数量摘要或取消删除。

## Source and Approval

- 来源：/Users/lv/Documents/Obsidian Vault/prd-test/AI流程试跑-个人待办/PRD.md，当前正式版本 1.0。
- 来源 SHA-256：e0dbf8506c0e9415e0ea4a8d040cc4ee87b3d7af1ac02ee890a45f4186a0af74，已与 ai/sync/baseline.json 核对。
- 仅 REQ-001 与 tasks.md 第 1 组关联；进度回写需求卡，再汇总 Obsidian 面板。
- 状态：2026-10-20 用户明确“批准提案，开始实施 REQ-001”，本轮按批准范围实施。REQ-002～005 的添加、切换、筛选及删除不属于本提案，后续选中时再检查已有变更并单独规划。
