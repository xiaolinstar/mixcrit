# mixcrit TestFlight 发布检查清单

> 创建日期：2026-05-19
> 当前版本：0.0.1
> 项目：mixcrit
> Bundle ID：cn.xiaolinstar.mixcrit

---

## 发布目标

将 0.0.1 版本上传至 TestFlight，提供内部测试下载。

---

## 当前状态

| 项目 | 状态 | 说明 |
|------|------|------|
| Apple Developer 账号 | ✅ 已注册 | cn.xiaolinstar.mixcrit |
| Bundle Identifier | ✅ 已配置 | cn.xiaolinstar.mixcrit |
| Xcode 模拟器运行 | ✅ 正常 | 可在模拟器中运行 |
| P0 原型验收清单 | ⏳ 待执行 | 见 `docs/p0-acceptance-checklist.md` |
| App Store Connect App 记录 | ⏳ 待创建 | 需在 appstoreconnect.apple.com 创建 |
| App Icon | ⏳ 待提供 | 需要 1024×1024 源文件 |
| 启动屏 | ⏳ 待配置 | 需要配置 LaunchScreen |

---

## 发布流程

### 步骤 1：在 App Store Connect 创建 App 记录

1. 访问 [App Store Connect](https://appstoreconnect.apple.com)
2. 登录后点击「我的 App」
3. 点击「+」→「新建 App」
4. 填写信息：
   - **平台**：iOS
   - **名称**：mixcrit
   - **主要语言**：简体中文
   - **套装 ID**：cn.xiaolinstar.mixcrit（选择现有）
   - **SKU**：mixcrit
5. 点击「创建」

### 步骤 2：提供 App Icon 源文件

需要提供 **1024×1024** 像素的 PNG 图片，发送给我（xingxiaolin）后，我会：

- [ ] 生成所有尺寸
- [ ] 配置 Contents.json
- [ ] 更新到项目中

### 步骤 3：配置启动屏

Xcode 需要启动屏配置。提供图标后一并处理。

### 步骤 4：Xcode Archive 并上传

1. Xcode 菜单栏 → **Product** → **Archive**
2. 等待编译完成
3. Organizer 窗口弹出后，选择 build → **Distribute App**
4. 选择 **App Store Connect** → **Development** → **Upload**
5. 等待上传完成（约 5-15 分钟）

### 步骤 5：在 TestFlight 添加构建版本

上传成功后：

1. 访问 App Store Connect → **TestFlight**
2. 选择左侧「构建版本」
3. 等待构建版本出现（通常 5-15 分钟）
4. 点击构建版本 → 添加**测试信息**
   - **测试说明**：介绍 App 和测试重点
5. **内部测试**：可直接选择，立即可用
6. **外部测试**：需提交审核，24-48h

---

## 待完成事项

| 序号 | 事项 | 负责人 | 状态 |
|------|------|--------|------|
| 1 | App Store Connect 创建 App | 用户 | ⏳ 待办 |
| 2 | 提供 1024×1024 图标源文件 | 用户 | ⏳ 待办 |
| 3 | 配置 App Icon 所有尺寸 | 我 | ⏳ 待办 |
| 4 | 配置启动屏 | 我 | ⏳ 待办 |
| 5 | Xcode Archive | 用户 | ⏳ 待办 |
| 6 | 上传至 App Store Connect | 用户 | ⏳ 待办 |
| 7 | TestFlight 添加构建版本 | 用户 | ⏳ 待办 |
| 8 | 提交内部/外部测试 | 用户 | ⏳ 待办 |

---

## 所需资源

### App Icon 源文件

- **尺寸**：1024×1024 像素
- **格式**：PNG（无透明背景）
- **建议**：纯色背景 + 酒杯图标，或品牌 Logo
- **发送方式**：直接发送图片文件

---

## 下一步

1. 用户在 App Store Connect 创建 App 记录
2. 用户提供 1024×1024 图标源文件
3. 我完成 App Icon 配置和启动屏配置
4. 用户执行 Archive 并上传
5. 用户在 TestFlight 完成发布

---

*本文件每日更新，完成后打勾记录*
