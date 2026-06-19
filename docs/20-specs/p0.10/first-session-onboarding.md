# P0.10 首次体验收口 Spec

> 创建日期：2026-06-18  
> 产品阶段：P0.10  
> 目标发布标识：0.0.12 (12+)  
> 状态：Implementing  
> 前置基线：`0.0.11 (11)` — P0.9 写实调酒页 + 品牌 App Icon

---

## 1. 背景

P0.8–P0.9 已完成调酒页视觉层级、SpriteKit 主舞台、原料权重和 Liquid Glass 布局优化。  
TestFlight 基线仍为 `0.0.8 (8)`，本地已具备 `0.0.10` / `0.0.11` 改进，但 **P0 验收清单第 4 节仍未通过**：

> 新用户在无讲解情况下可完成一杯 Mojito。

根因不是画面不够好看，而是 **量杯工作流未被理解**：

1. 点击原料 → 装入 15ml 量杯  
2. 点「量杯入杯」→ 液体进入成品杯（白朗姆需重复 3 次）  
3. 苏打水 / 薄荷直接点击入杯  
4. 加冰 → 摇酒 → 出杯  

当前顶部 HUD 以订单与当前材料用量为主，缺少「下一步该做什么」的动态引导；SpriteKit 舞台的量杯→酒杯关系表达仍偏弱。

---

## 2. 目标

- 首次进入调酒台的玩家，在 **3 分钟内、无口头讲解** 完成一杯 Mojito。
- 老玩家不被重复打扰：引导只显示一次，可跳过。
- 顶部 HUD 从「状态展示」升级为「状态 + 下一步提示」。
- SpriteKit 舞台强化量杯工作流的可读性（高亮、箭头、倒入反馈）。
- 补回「重置这杯」入口，不挤占底部主操作区。

**不扩展** 新酒品、经营系统、音效完整系统（音效列入 P1 可选子项）。

---

## 3. 范围

### 3.1 包含

#### A. 三步新手引导（首次会话）

| 步骤 | 触发 | 文案（可微调） | 完成条件 |
|------|------|----------------|----------|
| 1 | 首次进入 `MixingStationView` | 「点击下方白朗姆等，每次点击装入 15ml 量杯」 | 任意 jigger 材料 `jigger.amount > 0` 或用户点「知道了」 |
| 2 | 步骤 1 完成 | 「点『量杯入杯』，把酒倒进杯中」 | 执行过一次 `transferJiggerToGlass` 或跳过 |
| 3 | 步骤 2 完成 | 「加冰、摇酒，最后点『出杯』」 | 用户点「开始调酒」或跳过 |

- 半透明遮罩 + 高亮目标区域（原料行 / 量杯入杯按钮 / 出杯按钮）。
- 底部提供「跳过引导」。
- 使用 `@AppStorage("hasCompletedMixingOnboarding")` 持久化，默认 `false`。

#### B. 动态步骤提示（顶部 HUD 第二行）

根据 `MixingWorkflowStep` 状态机显示单行提示，优先级从高到低：

| 状态 | 提示示例 |
|------|----------|
| 待倒朗姆 | 「下一步：点白朗姆装 15ml → 量杯入杯；重复 3 次到 45ml」 |
| 待倒青柠/糖浆 | 「下一步：点\(材料名)装 15ml → 量杯入杯」 |
| 量杯有液未入杯 | 「量杯里有酒，点「量杯入杯」」 |
| 待苏打 | 「下一步：点苏打水，每次 30ml，共 3 次」 |
| 待薄荷 | 「下一步：点薄荷，每次 2 片，共 4 次」 |
| 待加冰 | 「下一步：点冰桶或『加冰』，约 6 颗」 |
| 待摇酒 | 「下一步：摇酒 \(当前)/3 次」 |
| 可出杯 | 「配方差不多了，点『出杯』评分」 |

- 提示占顶部胶囊 HUD 内一行，`lineLimit(1)`，`minimumScaleFactor(0.72)`。
- 与引导遮罩不冲突：引导优先，完成后显示动态提示。

#### C. SpriteKit 量杯关系强化

在 `MixingScene` 中，当 `MixingSceneState` 满足：

- `jigger.amount > 0` 且未在转移中 → 量杯与酒杯之间显示脉冲箭头 / 引导线（复用 `transferGuideNode`）。
- 正在倒入量杯 → `pourStreamNode` 终点对齐量杯口。
- 量杯入杯转移中 → 保留现有 `JiggerTransferStreamView` 等效 SpriteKit 动画。

#### D. 重置入口

- 调酒台右上角 `···` 菜单：`重置这杯`（调用现有 `onReset`）、`清空量杯`（调用现有 `clearJigger`）。
- 底部 Dock 保持 5 个主操作，不再增加第六个按钮。

### 3.2 不包含

- 第二杯鸡尾酒、客人系统、库存。
- 完整音效系统（若工期允许可作为 0.0.12 的 `.1` 子项，见 §6）。
- 出杯前确认弹层（列入 P0.10 P1 可选）。
- 配方系统架构重构。

---

## 4. 技术方案

### 4.1 新增类型

```text
mixcrit/Logic/MixingWorkflowStep.swift   — 纯函数，根据 MojitoMix + JiggerState 计算当前步骤与提示文案
mixcrit/Views/MixingStation/MixingOnboardingOverlay.swift — 三步引导 UI
```

### 4.2 修改文件

| 文件 | 改动 |
|------|------|
| `MixingStationView.swift` | 接入引导、动态提示、右上角菜单 |
| `MixingScene.swift` | 强化 transfer 引导线与倒入反馈 |
| `MixingSceneState.swift` | 如需，增加 `shouldHighlightTransfer` |
| `ContentView.swift` | 无结构变更 |

### 4.3 状态机（MixingWorkflowStep）

判定顺序建议：

1. 白朗姆未达标且 usesJigger → `.pourJigger(.whiteRum)`
2. 青柠汁未达标 → `.pourJigger(.limeJuice)`
3. 糖浆未达标 → `.pourJigger(.syrup)`
4. `jigger.amount > 0` → `.transferJigger`
5. 苏打未达标 → `.pourDirect(.soda)`
6. 薄荷未达标 → `.pourDirect(.mint)`
7. `iceCount < 6` → `.addIce`
8. `shakeCount < 3` → `.shake`
9. 否则 → `.serve`

---

## 5. 验收标准

### 5.1 功能

- [x] 首次进入调酒台显示 3 步引导，可跳过，完成后不再出现。
- [x] 顶部 HUD 动态提示随操作进度切换，无讲解完成标准配方一杯。
- [x] 量杯有液体时，舞台可见量杯→酒杯引导反馈。
- [x] 右上角可重置本杯、清空量杯。
- [ ] 引导与倒酒、量杯入杯、出杯无状态冲突（无残留 `pourTask`）。

### 5.2 设备

- [ ] iPhone SE（或最小屏模拟器）单屏完成全流程。
- [ ] iPhone 17 / iPhone 15 Pro 真机抽检。
- [ ] iPhone Pro Max 级别无布局溢出。

### 5.3 发布

- [ ] `p0-acceptance-checklist.md` 第 1–4 节全部勾选。
- [ ] 至少 1 名非开发者测试者无讲解完成一杯。
- [ ] `xcodebuild` Release 构建通过。
- [ ] TestFlight 上传 `0.0.12 (12+)`。

---

## 6. P1 可选子项（同迭代有余力时）

| 子项 | 说明 |
|------|------|
| 最小音效 | 倒酒、加冰、摇酒、出杯各 1 个短音效 |
| 出杯前确认 | 轻量摘要弹层再评分 |
| 评分可执行反馈 | 反馈项附带改进建议 |

---

## 7. 执行顺序

1. 实现 `MixingWorkflowStep` + 动态 HUD 提示（最快验证价值）
2. 实现 `MixingOnboardingOverlay` 三步引导
3. SpriteKit 量杯引导线强化
4. 右上角重置菜单
5. 真机 + 验收清单
6. 上传 TestFlight `0.0.12`

---

## 8. 验收记录

| 日期 | 版本 | 结果 | 备注 |
|------|------|------|------|
| 2026-06-18 | 0.0.12 | 部分通过 | `xcodebuild` Debug 模拟器构建通过；iPhone 17e 常态页无底部溢出和订单重叠；仍需完整流程与多机型回归。 |
