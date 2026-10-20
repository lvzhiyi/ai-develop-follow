# UI 规范

- 使用 Material 3、AppTheme 和 Theme.of(context).colorScheme，琥珀色主色定义在 lib/resources/theme.dart。
- 复用 CommonText、CommonButton、CommonTextFormField；参数以实际构造函数为准。
- 页面用 maxWidth 约束和可滚动布局适配屏幕、文字缩放及键盘，不引入旧项目 ScreenUtil、AppSizes 或品牌业务资源。
- 登录显示字段校验、处理中禁用、失败和重试；必须明显标识本地演示身份验证。
- 同时支持浅色/深色主题和系统字体缩放。按钮保留键盘、焦点、禁用及语义行为。
- 修改公共组件时检查两个页面和现有 Widget 测试，不凭编译成功宣称实际设备已验证。
