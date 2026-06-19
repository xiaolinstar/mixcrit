# mixcrit docs

> 更新日期：2026-05-26  
> 当前 TestFlight 基线：0.0.12 (12) / P0.10（审核中）  
> 当前开发阶段：P0.11  
> 下一目标构建：0.0.13 (13+)  
> 下一规划阶段：P0.11 / 0.0.13

---

## 1. 文档原则

mixcrit 后续采用 **Spec 驱动开发**：

1. 先写清楚目标、范围、验收标准。
2. 再做代码实现。
3. 每次版本迭代结束后，同步更新版本文档和验收记录。

没有 Spec 的功能，不进入正式开发；没有验收记录的功能，不算完成。

---

## 2. 当前项目进展

当前已经完成 P0 Mojito 原型的核心闭环。`0.0.12 (12)` / P0.10 已提交 TestFlight 审核；上一基线 `0.0.8 (8)` / P0.7 仍可供对比。

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

### 进行中

- P0.10 首次体验收口：新手引导、动态步骤提示、量杯流程可读性
- SpriteKit 量杯→酒杯引导反馈强化
- P0 验收清单真机回归

### 已规划

- P0.11 写实调酒主舞台定稿：构图、杯具、原料入量杯、量杯入杯、加冰、摇酒反馈
- P0.12 配方系统化：为第二杯酒和 P1 养成系统准备
- P1.0 养成 MVP：顾客订单、金币经验、酒单解锁、每日循环

### 当前主要问题

- 新用户仍可能不理解量杯工作流（P0.10 首要解决）。
- 调酒动作动态反馈（倒入、落冰、摇酒）仍可加强。
- P0 验收「无讲解完成一杯」尚未通过。

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
- `P0.10`：当前开发阶段，目标是首次体验收口。
- `0.0.12 (12+)`：P0.10 计划上传的发布包标识。
- `P0.11 / 0.0.13`：下一规划阶段，目标是写实调酒主舞台定稿。

简单说：**P0.10/P0.11 管“做什么”，0.0.12/0.0.13 管“发出去的是哪个包”。**

---

## 4. 文档地图

| 目录 | 文档 | 用途 |
|------|------|------|
| `00-overview/` | `version-roadmap.md` | 产品阶段、发布版本、Build、迭代关系总控 |
| `00-overview/` | `spec-development-process.md` | Spec 驱动开发流程和模板 |
| `10-product/` | `product-plan.md` | 产品长期方向 |
| `10-product/` | `p0-prototype-design.md` | P0 原型设计说明 |
| `10-product/` | `app-store-product-research.md` | App Store 和竞品研究 |
| `20-specs/p0.8/` | `spritekit-mixing-stage.md` | SpriteKit 调酒舞台 Spec |
| `20-specs/p0.8/` | `ingredient-priority-layout.md` | 原料与动作按钮主次重排 Spec |
| `20-specs/p0.8/` | `jigger-glass-relationship.md` | 量杯与成品杯关系表达 Spec |
| `20-specs/p0.9/` | `realistic-mixing-ui.md` | 调酒页写实化与底部原料权重 Spec |
| `20-specs/p0.10/` | `first-session-onboarding.md` | 首次体验收口：引导与动态提示 Spec |
| `20-specs/p0.11/` | `realistic-mixing-stage-finalization.md` | 写实调酒主舞台定稿 Spec |
| `20-specs/p1.0/` | `bar-management-mvp.md` | 酒吧养成 MVP Draft Spec |
| `30-releases/` | `p0.10-iteration-plan.md` | P0.10 具体迭代计划 |
| `30-releases/` | `p0.11-iteration-plan.md` | P0.11 具体迭代计划 |
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
| P0.11 | 0.0.13 | 13 | 当前开发 | 调酒主舞台定稿、动作反馈强化 |
| P0.12 | 0.0.14 | 14+ | 未开始（配方系统化） |
| P1.0 | 0.1.0 | 视发布递增 | 养成 MVP 起点 |

详见 `00-overview/version-roadmap.md`。
