# 架构规范

- pages/<feature>/page.dart 创建页面局部 Cubit；controller.dart 管理逻辑，state.dart 为不可变状态，view.dart 负责展示和交互转发。
- data/auth/AuthRepository 是认证边界；DemoAuthRepository 仅本地演示，真实接入需新实现，不能在视图直接加入 HTTP 请求。
- global/SessionController 保存内存身份；登录成功更新会话，退出清空。没有持久化、token 和自动刷新。
- router/app_router.dart 管理 /login、/home 和会话重定向；新增路由复用入口，不另建第二套路由系统。
- resources/theme.dart 为色彩和组件主题入口，widgets/ 放跨页面基础组件。
- 新能力先检查 OpenSpec；不为未来需求预先加入 Dio、Retrofit、存储、DI 或代码生成依赖。
- 接口接入遵循 [联调约定](api-integration.md)，目前无真实接口可供联调。
