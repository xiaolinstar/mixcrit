# Spec: P0.8 SpriteKit 调酒舞台

> 创建日期：2026-06-14  
> 阶段：P0.8  
> 目标版本：0.0.9  
> 状态：In Progress

---

## 1. 背景

P0.7 / 0.0.8 的调酒台使用 SwiftUI 堆叠量杯、水杯、倒酒流、吧台、冰块和原料区。随着贴图和动作增加，页面出现以下问题：

- 调酒区和原料区边界不清。
- 量杯、水杯、刻度依赖多层 `GeometryReader`、`padding`、`offset`。
- 不同手机尺寸下视觉主次不稳定。
- 后续倒酒、加冰、摇酒动画不适合继续用 SwiftUI 叠层维护。

因此 P0.8 开始将中间调酒主舞台迁移到 SpriteKit。

---

## 2. 目标

- SwiftUI 继续负责订单、原料选择、动作按钮和评分页。
- SpriteKit 负责中间调酒舞台。
- 量杯、成品杯、目标刻度、吧台、冰块反馈由 SpriteKit 统一坐标管理。
- 首阶段只做静态舞台替换和最小状态反馈，不追求最终美术。

---

## 3. 非目标

- 不在本阶段重做所有动画。
- 不引入真实液体物理。
- 不新增第二款酒。
- 不重构评分系统。
- 不删除旧 SwiftUI 杯具组件，先保留 fallback。

---

## 4. 用户体验

用户进入调酒页后：

1. 顶部仍看到订单与客人偏好。
2. 中间看到一个清晰独立的调酒舞台。
3. 舞台内有量杯、成品杯和吧台。
4. 选中材料时，量杯显示目标刻度。
5. 点击加冰、摇酒等动作后，SpriteKit 舞台能反映状态变化。
6. 底部原料和动作按钮属于 UI 操作层，不与舞台混成一层。

---

## 5. 技术方案

新增：

- `mixcrit/Game/MixingScene.swift`
- `mixcrit/Game/MixingSceneLayout.swift`
- `mixcrit/Game/MixingSceneState.swift`
- `mixcrit/Views/MixingStation/MixingSceneContainerView.swift`

修改：

- `mixcrit/Views/MixingStation/MixingStationView.swift`

结构：

```text
MixingStationView
├── orderCard                SwiftUI
├── MixingSceneContainerView SwiftUI wrapper
│   └── MixingScene          SpriteKit
└── controlDock              SwiftUI
```

---

## 6. 验收标准

- [x] Xcode 构建通过。
- [x] `MixingStationView` 中间舞台已由 `SpriteView` 替代旧 SwiftUI 大 `ZStack`。
- [x] iPhone 17e 模拟器可进入调酒页。
- [x] 点击加冰后，SwiftUI 状态能驱动 SpriteKit 场景更新。
- [ ] 调酒舞台、原料区、动作区在小屏设备上完成验收。
- [ ] 量杯和成品杯关系通过视觉设计进一步解释清楚。
- [ ] 杯具比例、吧台板和背景光效进入可接受美术质量。

---

## 7. 验收记录

| 日期 | 设备 | 结果 | 备注 |
|------|------|------|------|
| 2026-06-14 | iPhone 17e Simulator | Partial Pass | SpriteKit 已接入，状态更新可用；美术与层级仍需继续打磨 |
