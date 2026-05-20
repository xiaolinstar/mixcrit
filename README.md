# mixcrit

iOS 鸡尾酒调酒模拟游戏原型。

## 项目简介

mixcrit 是一款结合真实调酒模拟与轻量酒吧经营养成的移动端游戏。玩家经营一家小酒吧，通过真实的调酒操作服务客人，学习配方、管理库存、升级酒吧，逐步成为顶级调酒师。

## 当前版本：P0 准备阶段

P0 原型验证核心体验：**"在手机上调一杯 Mojito，是否有趣、好看、可理解？"**

当前代码状态：已完成工程基线整理（共享 scheme、`.gitignore`、部署版本对齐），核心玩法尚未开始实现。

### P0 功能目标

- 酒吧首页入口
- Mojito 订单及客人偏好提示
- 调酒台：5 种材料（白朗姆、青柠汁、糖浆、苏打水、薄荷）
- 核心操作：加入材料、加冰、摇酒、出杯
- 评分系统及详细反馈
- 液体动画与杯具状态视觉呈现

### 技术栈

- SwiftUI
- 原生 iOS（iOS 14.0+）
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
.
├── mixcrit/
│   ├── mixcritApp.swift
│   ├── ContentView.swift
│   └── Assets.xcassets/
├── mixcrit.xcodeproj/
└── README.md
```

## 运行

1. 用 Xcode 打开 `mixcrit.xcodeproj`
2. 选择 iOS 模拟器
3. 构建并运行（Cmd+R）

## 许可证

私有项目 - 版权所有
