# 任务交接：REQ-001

更新时间：2026-10-20，Asia/Shanghai。
状态：实施完成，待人工验收；没有外部阻塞。用户已明确“批准提案，开始实施 REQ-001”。

## 目标、来源与边界

REQ-001 Home 待办基础与会话生命周期，来源 PRD-TODO-001 v1.0，SHA-256：e0dbf8506c0e9415e0ea4a8d040cc4ee87b3d7af1ac02ee890a45f4186a0af74，写回前再次与 ai/sync/baseline.json 核对一致。v1.1 候选未采用。

需求卡：/Users/lv/Documents/Obsidian Vault/prd-test/AI流程试跑-个人待办/ai/requirements/REQ-001.md。

本 change 仅覆盖 REQ-001。添加、切换、筛选、删除分别由其他卡推进；生产初始列表为空，fixture 仅在测试注入。没有新增接口、存储、依赖或路由；不是完整 PRD 已交付。

## 工作区及修改

仓库：/Users/lv/work/flutter/flutter-ai-template，develop，仍无首次提交/HEAD，模板文件均未跟踪。没有提交、暂存、推送、PR、部署、归档或主规格同步。不要 reset/clean 未提交工作区。工作区交接统一记录分支、HEAD、git status --short、已有修改及未跟踪文件范围；有提交基线后通过 git diff 查看差异。当前没有 HEAD，不能据空 diff 判断没有改动。

实际修改：lib/global/session_controller.dart，lib/pages/home/ 的 controller/page/state/view.dart，test/app_test.dart、test/auth_test.dart。新增 lib/pages/home/model.dart、test/home_controller_test.dart、test/home_view_test.dart；对应 change 及需求进度记录已更新。实施时曾核对登录页、鉴权仓库、路由、主题、公共组件及 pubspec/lock 与实施前一致；该历史核对不替代续做时的 Git 检查。

TodoItem 的字段只读；HomeState 复制输入、拒绝重复 ID、按 creationOrder 倒序排序并公开不可变集合。当前只消费已有身份，递增分配器在 REQ-002 的创建行为中实现；不引入未使用的添加接口。

## 验证证据与问题处理

| 命令/操作 | 实际结果 |
| --- | --- |
| 实施前 `python3 scripts/check.py full` | PASS，原有 13 项测试通过，分析无问题 |
| 新空态测试 `flutter test --no-pub test/app_test.dart` | RED：原 Home 找不到指定初始空文案；原登录回归继续通过 |
| 新基础测试首次运行 | RED：模型及初始列表 API 尚不存在，属于新能力缺失，不记为业务断言通过 |
| 同邮箱替换定向测试 | RED：旧列表 3 条仍存在；引入显式会话边界信号后随全量测试 GREEN |
| `python3 scripts/check.py full` | PASS：9 份规范链接无错误、22 份 Dart 格式无变更、flutter analyze 无问题、27 项测试通过 |
| `python3 -m unittest discover -s scripts -p 'test_*.py'` | PASS，6 项 |
| `openspec validate add-home-session-todos --strict --no-interactive` | PASS |
| `flutter build web --no-pub` | PASS，Built build/web；有 CupertinoIcons 字体提示，当前代码仅使用 Material 图标，未为消除提示新增依赖 |
| Web 热重启 | 连接实际浏览器后成功，373ms |
| 浏览器实际交互 | 演示登录后显示身份、退出及指定空态，计数消失；刷新回登录页；退出及重新登录正常 |

测试调用真实 Controller、HomeView、TemplateApp 和路由，覆盖重复标题/不同 ID、创建倒序、完成状态、不可变快照、默认无种子数据、logout→login、不同身份及同邮箱替换、边界后立即释放、应用重建、小屏320px/键盘220px/文字2倍/深浅主题。带旧记录的退出清理由测试 fixture 驱动；浏览器生产页无添加入口，未伪称手动创建过记录。

失败分类：原计数到待办的 RED 是预期新功能失败；旧 Cubit 释放断言最初失败是 Widget 测试等待不足，日志确认 close 已开始、订阅取消需真实异步轮次，测试增加 runAsync 等待后通过，未删断言。同邮箱重复 signIn 缺少信号是本次发现的生命周期缺陷，真实失败用例已复现并修复。一次终端诊断审批超时，重试成功，无遗留工具阻塞。

独立只读评审发现同邮箱替换问题及重复 ID 测试样本描述不符，两者已修复；补充边界后立即释放测试。没有待修复的重大评审项。最终修复以 RED→GREEN 和全量检查复验。

Context7 未暴露可调用工具；依项目降级规则核对锁定 flutter_bloc 9.1.1 的 BlocProvider.create 自动关闭约定，以及 bloc 9.1.0 的 stream、emit 相等状态抑制和 close 源码，位置为本机 .pub-cache/hosted/pub.flutter-io.cn/。未声称已调用 Context7，不升级依赖。

## 未验证项与恢复

尚未运行 Android/iOS 真机或模拟器，也未做原生进程重启和读屏器人工检查。浏览器验证使用本地 debug web-server，Web release 仅构建，未进行 release 浏览器交互。Widget 测试覆盖深浅主题，浏览器实际查看系统深色主题。人工业务验收未进行，REQ-001 仅标待验证，已验收仍为 0/5。

下一步由用户验收 REQ-001；未经选择不推进其他卡。续做时重读 PRD 并核对指纹、检查源码及 Git 状态，复用本 change；不要仅凭任务复选框判断业务已验收，也不要自动归档。其他 REQ-002～005 仍待依赖。

本地预览：127.0.0.1:8766，目标项目的 Flutter web-server 在本轮仍运行。终端会话 ID 98573 仅作当次线索，恢复时需实际检查进程/端口再操作；不要重载其他项目。

## 历史说明

原误扩展到 REQ-002～005 的规划已在批准前按用户要求修正为单卡。2026-10-20 用户批准后按本范围实施，未恢复整批规划。

文档维护：按用户要求移除额外的应用文件指纹清单，后续使用 Git 状态与差异记录；未自动建立首次提交。PRD 来源版本及来源指纹仍用于需求同步核对。
