# mixcrit docs

> 更新日期：2026-06-25
> 当前 TestFlight 基线：0.0.12 (12) / P0.10（审核中）
> 当前开发阶段：P0.12
> 当前发布候选：0.0.14 (14)
> 下一规划阶段：P0.13 / 0.0.15（配方系统化）

---

## 1. 文档原则

mixcrit 后续采用 **Spec 驱动开发**：

1. 先写清楚目标、范围、验收标准。
2. 再做代码实现。
3. 每次版本迭代结束后，同步更新版本文档和验收记录。

没有 Spec 的功能，不进入正式开发；没有验收记录的功能，不算完成。

---

## 2. 当前项目进展

当前已经完成 P0 Mojito 原型的核心闭环。`0.0.14 (14)` / P0.12 作为方向试验版，验证“酒吧养成经营 + 有真实调酒知识的短时调酒小玩法”。

### 已完成

- 酒吧首页入口
- Mojito 单杯订单
- 5 种 Mojito 原料：白朗姆、青柠汁、糖浆、苏打水、薄荷
- 量杯工作流：白朗姆、青柠汁、糖浆先入量杯，再入杯
- 直接入杯工作流：苏打水、薄荷
- 核心动作：倒料、量杯入杯、加冰、摇酒、出杯、重置
- Mojito 评分与反馈
- P0 核心贴图资产接入
- TestFlight 0.0.8 (8) 发布

### 当前候选

- P0.12 简化调酒循环验证：降低量杯重复操作，引入顾客偏好和出杯反馈。
- 调酒知识显性化：用真实用量、风味说明和出杯复盘替代抽象档位。
- 产品形态从“真实模拟优先”转向“养成经营优先”。

### 已规划

- P0.13 配方系统化：为第二杯酒和 P1 养成系统准备
- P1.0 养成 MVP：顾客订单、金币经验、酒单解锁、每日循环

### 当前主要问题

- 当前量杯流程偏重，适合真实模拟验证，但不适合未来养成游戏的高频订单。
- 调酒动作需要保留手感，但常规订单应压缩到 20-40 秒。
- 出杯反馈需要从“ml 偏差”升级为“客人口味是否满足”的解释。

---

## 3. 阶段与发布标识

项目只保留一套真正的阶段体系：`P0.x / P1.x`。
`0.0.x (build)` 不是另一个阶段，而是该阶段上传到 TestFlight / App Store 的发布包标识。

| 类型 | 例子 | 是否是阶段 | 目的 |
|------|------|------------|------|
| 产品阶段 | `P0.8` | 是 | 规划、Spec、路线图、迭代范围 |
| 发布版本 | `0.0.9` | 否 | TestFlight / App Store 展示的安装包版本 |
| Build | `9` | 否 | App Store Connect 上传序号，每次上传必须递增 |

所以当前关系是：

- `0.0.8 (8)`：已经发布到 TestFlight 的安装包。
- `P0.7`：`0.0.8 (8)` 对应的产品阶段，定位是首个外部测试基线。
- `P0.12 / 0.0.14`：当前发布候选，目标是简化调酒循环验证。
- `P0.13 / 0.0.15`：下一规划阶段，目标是配方系统化。

简单说：**P0.x 管“做什么”，0.0.x 管“发出去的是哪个包”。**

---

## 4. 文档地图

| 目录 | 文档 | 用途 |
|------|------|------|
| `00-overview/` | `version-roadmap.md` | 产品阶段、发布版本、Build、迭代关系总控 |
| `00-overview/` | `spec-development-process.md` | Spec 驱动开发流程和模板 |
| `10-product/` | `product-plan.md` | 产品长期方向 |
| `10-product/` | `gameplay-evolution-plan.md` | 游戏形态演进方案：养成优先与调酒简化 |
| `10-product/` | `p0-prototype-design.md` | P0 原型设计说明 |
| `10-product/` | `app-store-product-research.md` | App Store 和竞品研究 |
| `20-specs/p0.8/` | `spritekit-mixing-stage.md` | SpriteKit 调酒舞台 Spec |
| `20-specs/p0.8/` | `ingredient-priority-layout.md` | 原料与动作按钮主次重排 Spec |
| `20-specs/p0.8/` | `jigger-glass-relationship.md` | 量杯与成品杯关系表达 Spec |
| `20-specs/p0.9/` | `realistic-mixing-ui.md` | 调酒页写实化与底部原料权重 Spec |
| `20-specs/p0.10/` | `first-session-onboarding.md` | 首次体验收口：引导与动态提示 Spec |
| `20-specs/p0.11/` | `realistic-mixing-stage-finalization.md` | 写实调酒主舞台定稿 Spec |
| `20-specs/p0.12/` | `simplified-mixing-loop.md` | 简化调酒循环验证 Spec |
| `20-specs/p1.0/` | `bar-management-mvp.md` | 酒吧养成 MVP Draft Spec |
| `30-releases/` | `p0.10-iteration-plan.md` | P0.10 具体迭代计划 |
| `30-releases/` | `p0.11-iteration-plan.md` | P0.11 具体迭代计划 |
| `30-releases/` | `p0.12-iteration-plan.md` | P0.12 具体迭代计划 |
| `30-releases/` | `p0.8-iteration-plan.md` | P0.8 具体迭代计划 |
| `30-releases/` | `release-plan.md` | 长期发布计划 |
| `30-releases/` | `release-checklist.md` | TestFlight / App Store 发布检查 |
| `40-qa/` | `p0-acceptance-checklist.md` | P0 Mojito 验收清单 |
| `50-assets/` | `visual-asset-plan.md` | 视觉资产规划 |
| `90-archive/` | `project-review-2026-05-24.md` | 历史项目评审 |

---

## 5. 目录规则

- `00-overview`：所有人先读这里，放总控文档。
- `10-product`：产品方向、玩法设计、市场研究。
- `20-specs`：具体功能或重构 Spec，按阶段分子目录。
- `30-releases`：版本计划、发布计划、TestFlight 清单。
- `40-qa`：验收清单、测试记录。
- `50-assets`：视觉、音效、资产规划。
- `90-archive`：历史评审和不再作为当前入口的文档。

---

## 6. 版本基线

| 产品阶段 | 发布版本 | Build | 状态 |
|----------|----------|-------|------|
| P0.7 | 0.0.8 | 8 | 已发布 TestFlight |
| P0.8 | 0.0.9 | 9 | 已完成本地迭代 |
| P0.9 | 0.0.10 | 10 | 已完成本地迭代 |
| P0.9 | 0.0.11 | 11 | 已并入 0.0.12 | App Icon |
| P0.10 | 0.0.12 | 12 | TestFlight 审核中 | 首次体验收口 |
| P0.11 | 0.0.13 | 13 | 已完成本地迭代 | 调酒主舞台定稿、动作反馈强化 |
| P0.12 | 0.0.14 | 14 | 发布候选 | 简化调酒循环验证 |
| P0.13 | 0.0.15 | 15+ | 未开始 | 配方系统化 |
| P1.0 | 0.1.0 | 视发布递增 | 养成 MVP 起点 |

详见 `00-overview/version-roadmap.md`。
