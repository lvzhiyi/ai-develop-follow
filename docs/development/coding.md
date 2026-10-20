# 代码规范

- formatter 以 analysis_options.yaml 为准，100 字行宽；类型 PascalCase，成员 lowerCamelCase，文件 snake_case。
- 使用 final、const 和单引号；新增公共 API 明确类型、可空语义与异常行为。
- 状态对象不可变，通过 Cubit emit 更新；不在视图内实现鉴权或请求逻辑。
- 异步操作防止重复提交，页面关闭后的返回不得更新已关闭 Cubit 或登录态。
- 组件拥有的文本控制器及时释放；会话/路由订阅由创建者释放。
- 依赖变更同时检查 pubspec.lock。禁止带入凭据、生产地址或真实敏感数据。
- 使用 [Context7 规则](ai-workflow.md#context7-文档查询)确认版本用法，文档查询不能代替测试。
