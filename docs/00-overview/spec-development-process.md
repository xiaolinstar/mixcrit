# mixcrit Spec 驱动开发流程

> 更新日期：2026-06-14  
> 适用范围：P0.8 起所有功能、体验、架构和发布迭代

---

## 1. 核心原则

mixcrit 后续遵循 **Spec First**：

> 先写 Spec，再实现；先定义验收，再判断完成。

这不是为了增加文档负担，而是避免调酒台这类复杂 UI 继续靠临时 padding、offset 和截图感觉推进。

---

## 2. 哪些工作必须先写 Spec

以下工作必须有 Spec：

- 新增或重构核心玩法
- 调酒台布局或交互大改
- SpriteKit 场景、动画、物理表现
- 新增酒品、配方、材料、杯具
- 评分规则调整
- 经营系统、库存、收益、客人系统
- TestFlight 版本迭代
- 影响用户首次体验的引导、文案、流程

以下工作可以不单独写 Spec，但要写入对应迭代记录：

- 小 bug 修复
- 文案错别字
- 资源路径修正
- 构建配置修正

---

## 3. Spec 存放规则

建议目录：

```text
docs/20-specs/
├── p0.8/
│   ├── spritekit-mixing-stage.md
│   ├── ingredient-priority-layout.md
│   └── jigger-glass-relationship.md
├── p0.9/
│   └── first-run-guidance.md
└── p1.0/
    └── bar-management-loop.md
```

命名规则：

```text
阶段-主题.md
```

示例：

- `20-specs/p0.8/spritekit-mixing-stage.md`
- `20-specs/p0.8/ingredient-priority-layout.md`
- `20-specs/p1.0/recipe-system.md`

---

## 4. Spec 模板

```markdown
# Spec: 标题

> 创建日期：YYYY-MM-DD
> 阶段：P0.8
> 目标版本：0.0.9
> 状态：Draft / Approved / In Progress / Done

---

## 1. 背景

为什么要做这个改动？当前问题是什么？

## 2. 目标

- 目标 1
- 目标 2
- 目标 3

## 3. 非目标

- 本次不做什么
- 哪些问题留到后续版本

## 4. 用户体验

描述用户看到什么、点击什么、反馈是什么。

## 5. 设计方案

包括页面结构、状态流、组件职责、视觉层级、交互规则。

## 6. 技术方案

涉及的文件、模型、状态、动画、资源和风险。

## 7. 验收标准

- [ ] 标准 1
- [ ] 标准 2
- [ ] 标准 3

## 8. 验收记录

| 日期 | 设备 | 结果 | 备注 |
|------|------|------|------|
| YYYY-MM-DD | iPhone 17e Simulator | Pass / Fail |  |
```

---

## 5. 开发流程

### Step 1：提出问题

问题必须具体到用户体验或技术风险。

不合格：

> UI 很乱。

合格：

> 原料区和调酒区边界不清，玩家无法判断白朗姆卡片是原料选择、倒料入口，还是调酒舞台的一部分。

### Step 2：写 Spec

至少写清：

- 当前问题
- 本轮目标
- 不做什么
- 验收标准

### Step 3：确认范围

确认本次是：

- P0 bug 修复
- P0 体验优化
- 架构重构
- 新功能
- 发布准备

### Step 4：实现

实现时遵循 Spec，不在实现过程中随意扩大范围。

### Step 5：验收

验收必须包含：

- 构建结果
- 截图或录屏
- 至少一个目标设备
- 是否满足 Spec 验收标准

### Step 6：更新文档

完成后更新：

- 对应 Spec 的状态
- 迭代计划
- 版本路线
- 发布清单，如涉及 TestFlight

---

## 6. P0.8 立即适用的 Spec 列表

建议补齐以下 Spec：

| Spec | 目的 | 优先级 |
|------|------|--------|
| `p0.8-spritekit-mixing-stage.md` | 规范 SwiftUI + SpriteKit 调酒舞台边界 | P0 |
| `p0.8-ingredient-priority-layout.md` | 重新定义原料区与动作按钮主次 | P0 |
| `p0.8-jigger-glass-relationship.md` | 解释量杯、成品杯、倒入关系 | P0 |
| `p0.8-testflight-feedback-loop.md` | 建立外部测试反馈收集与归类流程 | P1 |

---

## 7. Done 的定义

一个功能只有同时满足以下条件才算完成：

- Spec 已存在且状态更新为 `Done`
- 代码已实现
- 构建通过
- 至少一个目标设备截图或录屏通过
- 验收标准逐项记录
- 文档和版本计划同步

否则只能算 `In Progress`。
