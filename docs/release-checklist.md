# mixcrit TestFlight 发布检查清单

> 创建日期：2026-05-19
> 当前版本：0.0.8
> 项目：mixcrit
> Bundle ID：cn.xiaolinstar.mixcrit

---

## 发布目标

将 0.0.8（P0.7 发布收口版）上传至 TestFlight，提供内部测试下载。

---

## 当前状态

| 项目 | 状态 | 说明 |
|------|------|------|
| Apple Developer 账号 | ✅ 已注册 | cn.xiaolinstar.mixcrit |
| Bundle Identifier | ✅ 已配置 | cn.xiaolinstar.mixcrit |
| Xcode 模拟器运行 | ⏳ 待复验 | 当前机器未启用完整 Xcode，需在 Xcode 中重新构建 |
| P0 原型验收清单 | ⏳ 待执行 | 见 `docs/p0-acceptance-checklist.md` |
| App Store Connect App 记录 | ⏳ 待创建 | 需在 appstoreconnect.apple.com 创建 |
| App Icon | ✅ 已配置 | 已加入 1024×1024 PNG，正式发布前可继续替换为品牌终稿 |
| 启动屏 | ✅ 已配置 | 使用 Xcode 自动生成 LaunchScreen |

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

### 步骤 2：确认 App Icon

当前已提供 **1024×1024** 像素的 PNG 占位图标。正式发布前如需品牌化终稿，可以替换同名资源：

- [x] 生成 1024×1024 图标
- [x] 配置 Contents.json
- [x] 更新到项目中

### 步骤 3：确认启动屏

项目启用了 `INFOPLIST_KEY_UILaunchScreen_Generation = YES`，由 Xcode 自动生成启动屏。首次 Archive 前需在真机或模拟器确认启动画面没有明显违和。

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
| 2 | 提供 1024×1024 图标源文件 | 我 | ✅ 已完成占位版 |
| 3 | 配置 App Icon 所有尺寸 | 我 | ✅ 已完成 |
| 4 | 配置启动屏 | 我 | ✅ 已完成自动生成配置 |
| 5 | Xcode Archive | 用户 | ⏳ 待办 |
| 6 | 上传至 App Store Connect | 用户 | ⏳ 待办 |
| 7 | TestFlight 添加构建版本 | 用户 | ⏳ 待办 |
| 8 | 提交内部/外部测试 | 用户 | ⏳ 待办 |

---

## 所需资源

### App Icon 源文件

- **尺寸**：1024×1024 像素
- **格式**：PNG（无透明背景）
- **当前状态**：已配置占位版
- **建议**：正式上架前替换为品牌终稿，保持纯色背景 + 酒杯图标或品牌 Logo

---

## 下一步

1. 用户在 App Store Connect 创建 App 记录
2. 用户在 Xcode 中构建并执行 P0 验收清单
3. 用户执行 Archive 并上传
4. 用户在 TestFlight 完成发布

---

*本文件每日更新，完成后打勾记录*
