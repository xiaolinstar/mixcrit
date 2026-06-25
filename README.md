# mixcrit

iOS 鸡尾酒调酒模拟游戏原型。

## 项目简介

mixcrit 是一款结合真实调酒模拟与轻量酒吧经营养成的移动端游戏。玩家经营一家小酒吧，通过真实的调酒操作服务客人，学习配方、管理库存、升级酒吧，逐步成为顶级调酒师。

## 当前版本：P0.12 简化调酒方向试验

P0 原型验证核心体验：**"在手机上调一杯 Mojito，是否有趣、好看、可理解？"**
当前工程发布标识为 `0.0.14 (14)`，对应 P0.12。P0.12 作为方向试验版，验证“短时高频调酒小玩法 + 可学习调酒知识 + 顾客出杯反馈”是否适合作为后续养成经营循环的单杯制作基线。

### P0 功能

- 酒吧首页入口
- Mojito 订单及客人偏好提示
- 调酒台：5 种材料（白朗姆、青柠汁、糖浆、苏打水、薄荷）
- 核心操作：点击装量杯、量杯入杯、加冰、摇酒、出杯
- 评分系统及详细反馈
- 液体、量杯、冰块、气泡和杯具状态视觉呈现
- Mojito 核心材料贴图接入
- SpriteKit 中央调酒舞台：杯具构图、倒入路径、落冰、摇酒和出杯反馈
- 首次进入调酒页的新手引导和动态下一步提示
- P0.12 简化 Mojito 试验入口：用真实用量、风味说明和出杯复盘替代抽象档位

### 技术栈

- SwiftUI
- SpriteKit（用于调酒主舞台和核心动作反馈）
- 原生 iOS（iOS 17.0+）
- Xcode

## 产品路线图

| 版本 | 重点 | 说明 |
|------|------|------|
| P0 | Mojito 原型 | 单款鸡尾酒调制、基础评分 |
| P1 | 酒吧经营 MVP | 客人点单、库存、收入 |
| P2 | 内容扩展 | 10 款经典鸡尾酒、配方卡 |
| P3 | 长线运营 | 自创酒品、比赛模式、酒吧升级 |

## 目标酒单

1. Mojito
2. Gin Tonic
3. Whiskey Sour
4. Old Fashioned
5. Margarita
6. Martini
7. Negroni
8. Daiquiri
9. Cuba Libre
10. Cosmopolitan

## 项目结构

```
mixcrit/
├── mixcritApp.swift
├── ContentView.swift      # 应用流程入口与状态编排
├── Models/                # Mojito 配方、调酒状态、游戏阶段
├── Logic/                 # Mojito 评分逻辑
├── Views/                 # 首页、调酒台、评分页和复用组件
├── Assets.xcassets/
└── mixcrit.xcodeproj/
```

## 文档入口

后续开发遵循 Spec 驱动：

- `docs/README.md`：文档地图与当前进展
- `docs/00-overview/version-roadmap.md`：版本号、Build、产品阶段关系
- `docs/00-overview/spec-development-process.md`：Spec 驱动开发流程
- `docs/20-specs/`：具体功能和重构 Spec

## 运行

1. 用 Xcode 打开 `mixcrit.xcodeproj`
2. 选择 iOS 模拟器
3. 构建并运行（Cmd+R）

## 许可证

私有项目 - 版权所有
