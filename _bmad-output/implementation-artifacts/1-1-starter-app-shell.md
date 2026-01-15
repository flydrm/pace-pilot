# Story 1.1: Starter 初始化工程 + App 启动壳与底部 5 Tab 导航

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 打开应用后立即看到 Today，并能在 5 个 Tab 间切换，
so that 我能快速进入“掌控工作台”，不被复杂设置打扰。

## Acceptance Criteria

1. **Given** 我在一个空目录准备开始 pace-pilot  
   **When** 我按架构文档执行 `flutter create app --project-name pace_pilot --org com.example --platforms=android --android-language kotlin`  
   **Then** 生成 `app/` 工程并可成功运行到模拟器/真机
2. **Given** 我首次打开应用（无任何数据）  
   **When** 应用启动完成  
   **Then** 默认进入 `今天` Tab
3. **Given** 应用已启动  
   **When** 我查看底部导航  
   **Then** 底部导航按顺序显示：AI / 笔记 / 今天 / 任务 / 专注
4. **Given** 应用已启动  
   **When** 我依次点击 5 个 Tab  
   **Then** 每个 Tab 均可进入对应页面（允许先为占位内容）
5. **Given** 我在任意 Tab 页面  
   **When** 我查看顶部栏  
   **Then** 右上角存在全局“设置”入口（不占 Tab），点击可进入设置页并可返回
6. **Given** 我在底部导航  
   **When** 我对比 `今天` 与其它 Tab 的呈现  
   **Then** `今天` 在视觉上“稍大/更突出”（允许 MVP 先用更大 icon/label 或 pill 胶囊实现）

## Tasks / Subtasks

- [ ] Task 1: 初始化工程与目录结构（AC: 1）
  - [ ] 执行 `flutter create ...`（Android-first）
  - [ ] 在仓库根目录创建 `packages/domain`、`packages/data`、`packages/ai` 的包结构（最小 `pubspec.yaml` + `lib/` 占位），并在 `app/pubspec.yaml` 引用
  - [ ] 确认 `app/` 可运行（至少 `flutter run` 到模拟器/真机）

- [ ] Task 2: 实现底部 5 Tab 导航壳（AC: 2, 3, 4, 6）
  - [ ] 使用 `go_router`（架构指定）建立路由：
    - 5 个 Tab 根路由：`/ai`, `/notes`, `/today`, `/tasks`, `/focus`
    - `今天`为默认入口（冷启动路由指向 `/today`）
  - [ ] 用 ShellRoute（或等价方案）承载底部导航，保证切 Tab 时页面栈行为可控
  - [ ] Tab 顺序固定：AI / 笔记 / 今天 / 任务 / 专注（禁止自行改顺序）
  - [ ] `今天`突出：实现“更大”或“胶囊”视觉强调（与线框一致即可）
  - [ ] 每个 Tab 先实现占位页面（AppBar + 标题 + 空态说明）

- [ ] Task 3: 全局设置入口（右上角，不占 Tab）（AC: 5）
  - [ ] 所有 Tab 页面的 AppBar 右上角统一放“设置” icon
  - [ ] 设置页先实现占位列表：AI / 番茄 / 数据 / 外观（后续 story 补全）

- [ ] Task 4: 应用根部注入基础能力（架构一致性）
  - [ ] 根组件使用 `ProviderScope`（Riverpod）包裹，为后续 controller/provider 做准备
  - [ ] 配置 Material 3 基础主题（安静、商务、稳重的基线：留白、克制的对比度）

- [ ] Task 5: 测试（最小但必须可回归）
  - [ ] Widget test：启动默认落在 `今天`（route 与选中状态一致）
  - [ ] Widget test：底部导航存在且顺序正确（可用文本或语义节点断言）
  - [ ] Widget test：任意 Tab 页面 AppBar 存在“设置”入口并可进入设置页

## Dev Notes

- **分层硬约束**：UI 必须只在 `app/`；Domain/Data/AI 放在 `packages/*`，禁止 UI 直连 DB/加密/网络（详见架构文档“Project Structure & Boundaries”）。
- **路由/状态**：本 Story 只需壳与占位页面，但必须用 `go_router` + `ProviderScope` 把“未来正确的形状”先立住，避免后续大重构。
- **风格与体验**：`今天`默认落点且略突出；专注期不打扰等 UX 原则后续实现，但此处先把导航与全局设置入口定死。

### Project Structure Notes

- 目标结构见：`_bmad-output/planning-artifacts/architecture.md` 的 `Project Structure & Boundaries`。
- 线框参考：`_bmad-output/excalidraw-diagrams/wireframe-20260114.excalidraw`（Row1 五个主 Tab + 设置入口）。

### References

- PRD（信息架构与入口规则）：`_bmad-output/planning-artifacts/prd.md`
- UX（Today 默认/突出、设置入口语义）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（starter 命令、分层与路由约束）：`_bmad-output/planning-artifacts/architecture.md`
- Wireframe：`_bmad-output/excalidraw-diagrams/wireframe-20260114.excalidraw`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

