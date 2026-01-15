# Story 2.2: 番茄计时（开始/暂停/继续/结束）与 endAt 持久化

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 番茄计时在切后台/重进 App 后仍准确，
so that 我不担心“失控/丢计时”。

## Acceptance Criteria

1. **Given** 我已选择任务并开始了一个番茄  
   **When** 我暂停并继续  
   **Then** 倒计时正确暂停/继续且显示剩余时间
2. **Given** 我已开始番茄  
   **When** 应用进入后台/被杀后重启  
   **Then** 应用能从持久化状态恢复当前番茄并显示正确剩余时间
3. **Given** 我已开始番茄  
   **When** 我主动结束/放弃本次番茄  
   **Then** 计时停止并进入专注收尾流程（收尾 Sheet 可在 Story 2.4 完成；本 Story 至少要完成状态切换与占位）

> 误差阈值：恢复后的剩余时间允许存在误差，但必须在实现中固定并写入测试（建议 ≤ 30 秒；上限不超过 1 分钟）。

## Tasks / Subtasks

- [ ] Task 1: 定义 Focus 计时状态机（Domain）（AC: 1, 2, 3）
  - [ ] 定义 `PomodoroTimerState`（或等价）：
    - [ ] `idle`（未开始）
    - [ ] `running`（taskId/startAt/endAt）
    - [ ] `paused`（taskId/startAt/remainingMs）
    - [ ] `finished`/`abandoned`（用于进入收尾流程）
  - [ ] `endAt` 作为运行态事实来源；`remaining = endAt - now`
  - [ ] 暂停语义：暂停后不再递减；恢复时重新计算新的 `endAt`

- [ ] Task 2: 持久化与恢复（Data）（AC: 2）
  - [ ] 定义 `ActivePomodoroRepository`（或等价）用于持久化“当前专注状态”
  - [ ] 存储字段至少包含：`taskId`、`startAt`、`endAt`（running）或 `remainingMs`（paused）
  - [ ] 选择存储介质（择一并固定）：
    - [ ] A) Drift 表（推荐：可事务/可扩展）  
    - [ ] B) shared_preferences（MVP 更快，但结构化与迁移较弱）
  - [ ] App 启动/Focus 页进入时读取持久化状态并恢复 UI
  - [ ] 若 `endAt <= now`：进入 `finished`（后续触发收尾 Sheet/占位页）

- [ ] Task 3: UI 倒计时与操作（AC: 1, 3）
  - [ ] `running` 状态显示倒计时（基于 `endAt` 计算），并提供按钮：
    - [ ] 暂停
    - [ ] 结束（或放弃）
  - [ ] `paused` 状态显示剩余时间，并提供按钮：
    - [ ] 继续
    - [ ] 结束（或放弃）
  - [ ] `finished/abandoned` 进入收尾流程占位（Story 2.4 会替换为真正 Sheet）

- [ ] Task 4: 时间与误差策略（可测试）（AC: 2）
  - [ ] 注入 `Clock`（或等价）以便在单测固定“当前时间”
  - [ ] 定义恢复误差阈值（例如 30 秒）并在测试中断言
  - [ ] 处理系统时间跳变（最小策略）：只要 `endAt` 仍在未来就继续；若跳到过去则视为结束

- [ ] Task 5: 测试（覆盖持久化与恢复）
  - [ ] Unit：状态机（pause/resume/end）与 `remaining` 计算
  - [ ] Integration：写入持久化后模拟“重启”读取，状态与剩余时间在阈值内
  - [ ] Widget：running/paused UI 与按钮行为；结束进入收尾占位

## Dev Notes

- **endAt 是核心**：不要仅靠 `Timer.periodic` 的累加；UI 每秒刷新可以做，但真实剩余时间必须由 `endAt-now` 推导。
- **恢复优先级高于动画**：宁可 UI 简单，也要保证后台/重启恢复正确（这是“掌控感”的关键）。
- **与通知联动**：在 Story 2.3 中，开始/暂停/继续必须同步调度/取消通知（保持一致性）。

### Project Structure Notes

- Domain：`packages/domain/lib/entities/pomodoro_timer_state.dart`、`packages/domain/lib/usecases/...`
- Data：`packages/data/lib/repositories/active_pomodoro_repository.dart`（以及 drift 表/kv 存储实现）
- UI：`app/lib/features/focus/...`

### References

- PRD（endAt 持久化与恢复）：`_bmad-output/planning-artifacts/prd.md`
- UX（专注期不打扰、状态清晰）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（可靠性原则、持久化建议）：`_bmad-output/planning-artifacts/architecture.md`
- Epics（Story 2.2 AC）：`_bmad-output/planning-artifacts/epics.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

