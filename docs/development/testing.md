# 验证与交付

依赖安装后运行：

```bash
python3 scripts/check.py docs
python3 -m unittest discover -s scripts -p 'test_check.py'
python3 scripts/check.py full
flutter build web
```

full 包含文档本地链接、Git diff、手写 Dart 格式、flutter analyze 和 flutter test。脚本不改源文件和暂存区；SDK/构建缓存会写入。需要 Python 3、Git 及 Flutter；新复制目录先 git init。

测试直接调用真实 repository/controller，并通过 Widget 测试覆盖字段校验、错误登录、登录/Home/退出、路由守卫和窄屏布局。Widget 测试不是已连接设备的端到端测试。修改 Flutter 代码后，运行会话存在时热重载或重启验证；无会话时明确说明未覆盖范围。

失败按 [AI 工作流](ai-workflow.md#验证失败和受阻交接)归类，工具缺失不能称为通过。只有实际执行过的命令才能写通过；Mock 登录不能写成真实接口联调通过。CI 配置待推送后实际验证，合并拦截另行设置。

交付说明修改、命令和结果、未覆盖项；不自动发布。环境、行为或代码变化后重新记录基线，不沿用来源项目的问题数量。
