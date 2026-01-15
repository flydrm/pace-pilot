# Story 1.3: 任务列表（筛选、排序、Quick Add）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 在任务列表快速新增并按条件筛选查看，
so that 我能随时找到“下一步要做什么”。

## Acceptance Criteria

1. **Given** 我在 `任务` 页且已存在多条任务（含不同优先级/截止日期/状态）  
   **When** 我使用 Quick Add 输入一句话并提交  
   **Then** 系统创建一条新任务并出现在列表顶部/合理位置
2. **Given** 我在 `任务` 页  
   **When** 我按状态/优先级/标签/今天到期/已逾期筛选  
   **Then** 列表仅展示符合条件的任务
3. **Given** 我在 `任务` 页  
   **When** 我未选择任何筛选条件  
   **Then** 默认展示未完成任务并按“优先级（高→低）+ 截止日期（近→远）”排序（无截止日期的放后）

## Tasks / Subtasks

- [ ] Task 1: Quick Add（AC: 1）
  - [ ] 在任务页顶部提供 Quick Add 输入框（单行）
  - [ ] Enter/提交后创建任务（title=输入内容，去空白；空输入禁止提交）
  - [ ] 提交后清空输入并保持键盘/焦点策略一致（避免打断）

- [ ] Task 2: 筛选与排序逻辑（Domain/UseCase）（AC: 2, 3）
  - [ ] 定义 `TaskFilter`（status/priority/tag/dueToday/overdue）与默认排序规则（写成纯函数便于单测）
  - [ ] 明确“今天到期”的定义：以本地日期 00:00–23:59 计算（需在实现中统一时区策略）
  - [ ] 优先使用 Repository 查询过滤；若 tags/日期查询复杂，可在 MVP 先内存过滤，但必须保证可测试与性能可接受

- [ ] Task 3: UI 筛选控件（AC: 2）
  - [ ] 在任务页提供筛选入口（chips 或 filter button → bottom sheet）
  - [ ] 支持：状态、优先级、标签、今天到期、已逾期
  - [ ] 提供“一键清除筛选”

- [ ] Task 4: 列表排序与展示（AC: 3）
  - [ ] 默认只显示未完成任务（todo/inProgress）
  - [ ] 按规则排序：priority desc → dueAt asc(null last) → createdAt desc（或明确的稳定排序）
  - [ ] UI 中对排序规则给出可理解提示（例如在空态/筛选提示区）

- [ ] Task 5: 测试（覆盖筛选/排序核心规则）
  - [ ] Unit：TaskFilter + sort 纯函数（覆盖 today/overdue 边界）
  - [ ] Widget：Quick Add 创建后列表更新；应用筛选后列表变化；清除筛选恢复默认

## Dev Notes

- **避免重复覆盖**：筛选/排序优先落在 domain 的纯函数与 usecase，UI 只负责收集条件与展示结果。
- **时间陷阱**：dueToday/overdue 的边界必须在测试中锁定（可注入 Clock 或在测试固定“今天”日期）。
- **性能**：MVP 可先内存过滤，但要为未来 DB 查询留好接口（避免到 P1 才大重构）。

### Project Structure Notes

- Domain：`packages/domain/lib/usecases/...`（过滤与排序规则可放在 `packages/domain/lib/usecases/task_list_query.dart` 或 `value_objects/`）
- UI：`app/lib/features/tasks/view/tasks_list_page.dart` + `controller/tasks_controller.dart`

### References

- PRD（任务列表筛选/Quick Add）：`_bmad-output/planning-artifacts/prd.md`
- UX（掌控感、信息密度与不打扰）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（命名规则、分层、时间格式）：`_bmad-output/planning-artifacts/architecture.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

