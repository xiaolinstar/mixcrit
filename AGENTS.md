# AGENTS.md

## Project overview

mixcrit is a native iOS (SwiftUI) cocktail-mixing simulation game prototype. The P0 prototype focuses on a single drink (Mojito). All game logic, models, views, and scoring live in `mixcrit/ContentView.swift`; the app entry point is `mixcrit/mixcritApp.swift`. There are no external dependencies, no backend, and no test targets.

## Cursor Cloud specific instructions

### Platform constraint

This is a **pure iOS/SwiftUI project** that requires **macOS + Xcode** to build and run. The Cloud Agent Linux VM **cannot** compile or run the app, as SwiftUI and the iOS SDK are Apple-only.

### What works on Linux

- **SwiftLint** (static binary, installed at `/usr/local/bin/swiftlint`): lint Swift source files without needing the Swift compiler or SourceKit.
  ```
  SWIFTLINT_DISABLE_SOURCEKIT=1 swiftlint lint mixcrit/
  ```
  The `SWIFTLINT_DISABLE_SOURCEKIT=1` env var is required since SourceKit is not available on the Linux VM. Some SourceKit-dependent rules (e.g. `statement_position`) will be skipped.

### What does NOT work on Linux

- `swift build` / `swift test` / `xcodebuild` — the project has no `Package.swift` and depends on SwiftUI (Apple-only).
- iOS Simulator — requires macOS.
- Xcode previews — requires macOS + Xcode.

### Build & run (macOS only)

Per `README.md`: open `mixcrit.xcodeproj` in Xcode, select an iOS simulator, and press Cmd+R.

### Code structure

| Path | Purpose |
|------|---------|
| `mixcrit/mixcritApp.swift` | App entry point (`@main`) |
| `mixcrit/ContentView.swift` | All game logic, models, views, and scoring (~1250 lines) |
| `mixcrit/Assets.xcassets/` | Asset catalogs (colors, app icon) |
| `mixcrit.xcodeproj/` | Xcode project configuration |
| `docs/` | Product design and release documentation |
