# Story 2.1: 选择任务开始专注（番茄配置可用）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 在开始专注前明确要做的任务，并使用番茄配置开始计时，
so that 我的专注是有目标的且节奏一致。

## Acceptance Criteria

1. **Given** 我进入 `专注` 页且当前没有选中任务  
   **When** 我点击“开始”  
   **Then** 系统要求我先选择一个任务或创建新任务后才能开始
2. **Given** 我已选中一个任务  
   **When** 我点击“开始”  
   **Then** 专注进入“进行中”状态，并展示当前任务标题与番茄时长
3. **Given** 我未做任何配置  
   **When** 我开始专注  
   **Then** 默认番茄时长为 25 分钟（后续可在设置中修改）
4. **Given** 我从任务详情点击“开始专注”进入 `专注` 页  
   **When** `专注` 页加载完成  
   **Then** 页面自动携带该任务上下文（无需重复选择）

## Tasks / Subtasks

- [ ] Task 1: Focus 页面骨架与状态机（AC: 1, 2, 4）
  - [ ] 实现 `专注` 页的最小状态：
    - [ ] `idle`（未开始，未选任务/已选任务）
    - [ ] `running`（已开始，展示倒计时占位/真实倒计时在 Story 2.2 完成）
  - [ ] “开始”按钮规则：
    - [ ] 未选任务 → 打开选择任务流程
    - [ ] 已选任务 → 进入 running

- [ ] Task 2: 选择任务流程（AC: 1）
  - [ ] 选择任务入口（推荐 bottom sheet / 全屏选择页）
  - [ ] 任务来源：复用 `TaskRepository` 的任务列表（默认仅未完成）
  - [ ] 提供“创建新任务”入口（可复用 Story 1.2 的新增任务流程）
  - [ ] 选中后回到 Focus 页并显示任务标题

- [ ] Task 3: 番茄配置（最小可用）（AC: 3）
  - [ ] 定义 `PomodoroConfig`（Domain）：默认 `workDurationMinutes=25`
  - [ ] 先实现读取默认值；设置页的可编辑配置可在后续 Story 补齐

- [ ] Task 4: 跨页面携带 task 上下文（AC: 4）
  - [ ] 支持从任务详情进入 Focus 时携带 `taskId`（路由参数或共享 provider，需与 Story 1.4 保持一致）
  - [ ] 若 taskId 无效/不存在：回退到“未选任务”状态并提示（轻量、不打扰）

- [ ] Task 5: 测试（最小但必须可回归）
  - [ ] Widget：未选任务点击开始会要求选择；选中任务后可进入 running 状态
  - [ ] Widget：从 `/focus?taskId=...`（或等价方式）进入时自动选中并可开始

## Dev Notes

- **不要先做复杂计时**：本 Story 先把“选任务→开始”的闭环跑通；准确倒计时与持久化在 Story 2.2。
- **不打扰**：默认不弹窗；只有在用户点“开始”且没选任务时才触发选择流程。
- **一致性**：Focus 内显示的任务标题必须与任务详情/任务列表一致，避免“我不信任”。

### Project Structure Notes

- Domain：`packages/domain/lib/entities/pomodoro_config.dart`（或等价）
- UI：`app/lib/features/focus/view/focus_page.dart` + `controller/focus_controller.dart`
- Navigation：与 `tasks` feature 共享 `taskId` 传递方式

### References

- PRD（开始专注必须选任务、默认 25 分钟）：`_bmad-output/planning-artifacts/prd.md`
- UX（专注期安静驾驶舱、触发式选择任务）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（Riverpod/go_router/分层）：`_bmad-output/planning-artifacts/architecture.md`
- Epics（Story 2.1 AC）：`_bmad-output/planning-artifacts/epics.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

