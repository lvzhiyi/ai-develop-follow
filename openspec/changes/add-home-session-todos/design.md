# Design

## Context

动机和需求范围见 proposal.md。当前 HomePage 创建页面局部 HomeController；HomeState 仅含 count，HomeView 展示身份、计数与退出。TemplateApp 持有内存 SessionController，GoRouter 根据登录态重定向。现有两个应用测试文件共有 13 项测试，其中两项直接依赖计数示例。

修改前统一 full 检查通过。仓库 develop 尚无 HEAD，所有模板文件未跟踪，不能靠 git diff 认定本次独有修改；工作区记录使用 Git：记录分支、HEAD（不存在时明确注明）、git status --short，以及已有修改和未跟踪文件范围；git diff 不能展示未跟踪文件内容，不自动提交。

## Goals / Non-Goals

**Goals:** 保留 page/controller/state/view 分层，以最小内存实现满足 REQ-001，并用真实状态和页面验证。用户已批准，仅实施 REQ-001。

**Non-Goals:** 不改变登录方式、不新增路由/后台/数据库/持久化，不提前实现候选 v1.1。

## Decisions

### 1. 页面局部 Cubit 管理会话待办

沿用 HomePage 创建的 HomeController，在该模块增加 TodoItem 模型（id、title、isCompleted、creationOrder），HomeState 使用不可变集合。路由退出释放页面 Cubit，再次登录新建空状态；验证 signOut 后返回登录，以及随后登录无旧数据。若页面未离开而会话身份变化，也需要重新绑定/清空，不以字符串邮箱相同推断同一会话。实际实现保留 SessionController 的 String? 登录态，增加同步 sessionChanges 流，在每次 signIn/signOut 时通知 Home 清空，避免 Cubit 抑制相同邮箱的重复状态。HomeController.close 取消该订阅，BlocProvider 负责页面释放。

不用全局持久化仓库，避免脱离会话生命周期和无必要依赖。测试可通过构造注入初始列表验证渲染，生产构造默认空列表，测试数据不进生产。

### 2. ID 与顺序分离

当前基础模型保存显式 ID 和创建序号，HomeState 拒绝重复 ID；无生产创建入口。REQ-002 实现创建时，同会话内使用递增序号分配唯一 ID 和创建顺序；不把标题或毫秒时间作为唯一键，避免重复标题、同一时刻创建碰撞。fixture 必须提供不同 ID，后续创建起点高于已注入记录。按 creationOrder 倒序展示；完成/筛选/删除不重排创建顺序。ID 跨会话不要求延续，因为全部任务随会话清空。

### 3. 当前只提供基础展示

本 change 仅建立不可变列表、标题及完成状态展示、初始空状态和会话清空。不提供添加、切换、筛选或删除动作，也不放置不可用按钮。生产初始列表为空；有数据的顺序与身份场景由 fixture 驱动真实 Controller 和 Widget 验证，不要求先实现添加功能。

其他需求卡后续选中时另行检查主规格与进行中 change，复用已有基础，单独规划所选需求；只有用户明确要求整批规划时才合并范围。PRD 指纹变化时先进行影响分析，不继续使用过期 Prompt。

## Risks / Trade-offs

- 页面局部生命周期遗漏 → 用真实路由的退出/再登录和会话替换测试证明无残留。
- 现有计数测试与新规格冲突 → 仅替换计数断言，保留登录、错误、路由和退出测试；不以删除回归测试通过。
- 尚无首次提交 → 记录文件范围及证据，不擅自暂存、提交、清理或回滚用户文件。
- 仅跑 Widget 测试不能证明实际设备布局 → 增加浏览器交互/主题检查，未验证原生设备明确报告。

## Migration Plan

获批后完成 REQ-001 组及回归，不自动推进其他卡。更新主规格和归档按部署后的 OpenSpec 流程进行，当前不改 openspec/specs/。无需数据迁移；撤回变更应仅撤回本 change 的文件差异，不 reset 未提交工作区。

## Validation

每阶段先添加调用真实实现的失败测试，再最小实现和相关回归；完成前运行统一 full 入口及脚本测试。本需求验证生产登录空列表、fixture 列表展示、退出与再登录清空、刷新/重启不恢复，以及身份、路由和布局回归。实施后统一 full 检查通过（27 项测试、分析无问题）；6 项检查脚本测试、OpenSpec 严格校验和 Web 构建通过。浏览器验证登录空态、刷新守卫、退出及热重启，原生设备和人工业务验收尚未覆盖。详见 handoff.md。
