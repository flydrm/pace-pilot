# Story 1.2: 任务创建与编辑（最小字段集）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 用最少的输入创建并编辑任务，
so that 我能把脑中的事项变成可执行条目。

## Acceptance Criteria

1. **Given** 我在 `任务` 页  
   **When** 我通过“新增任务”创建任务并填写标题（必填）  
   **Then** 任务被保存到本地并出现在任务列表中
2. **Given** 我已创建任务  
   **When** 我编辑任务的描述/优先级/截止日期/标签/预计番茄数并保存  
   **Then** 修改被保存且再次进入仍保持一致
3. **Given** 我在创建或编辑任务  
   **When** 标题为空并尝试保存  
   **Then** 系统禁止保存并给出明确提示

## Tasks / Subtasks

- [ ] Task 1: Domain 模型与校验（AC: 1, 2, 3）
  - [ ] 在 `packages/domain` 定义 `Task` 实体（最小字段集：title/description/status/priority/dueAt/tags/estimatedPomodoros/createdAt/updatedAt）
  - [ ] 定义值对象/校验：
    - [ ] `TaskTitle`（或等价）保证非空/去空白
    - [ ] `SixDigitPin` 已在架构中提及，但本 story 不实现（避免跑偏）
  - [ ] 定义枚举：`TaskStatus`（todo/inProgress/done）、`TaskPriority`（high/medium/low）

- [ ] Task 2: Repository 接口与 UseCases（AC: 1, 2, 3）
  - [ ] `TaskRepository`：create/update/get/list/delete（最少实现 create+update+list）
  - [ ] UseCases：
    - [ ] `CreateTask`（负责 title 校验与默认值）
    - [ ] `UpdateTask`（字段更新与 updatedAt）

- [ ] Task 3: Data 层持久化（Drift/SQLite）（AC: 1, 2）
  - [ ] 在 `packages/data` 创建 Drift `app_database.dart`（或在现有基础上扩展）
  - [ ] 创建 `tasks` 表（snake_case 列名，时间用 UTC epoch ms）
  - [ ] tags 存储策略（选择其一并写进实现）：
    - [ ] A) `task_tags` 关联表（推荐，便于后续筛选）  
    - [ ] B) `tags_json` 单列 JSON（MVP 简化，但筛选会更麻烦）
  - [ ] 实现 `DriftTaskRepository`（create/update/list）

- [ ] Task 4: UI（任务页新增/编辑最小闭环）（AC: 1, 2, 3）
  - [ ] `任务` 页提供“新增任务”入口（按钮或 FAB）
  - [ ] 任务编辑页（或 bottom sheet）最小支持：
    - [ ] 标题（必填）
    - [ ] 描述（可选）
    - [ ] 优先级（下拉/分段）
    - [ ] 截止日期（可选，先支持选择日期即可）
    - [ ] 标签（先支持逗号分隔输入）
    - [ ] 预计番茄数（可选，整数）
  - [ ] 保存成功后回到任务列表并可看到新任务/更新内容
  - [ ] 标题为空时阻止保存并提示

- [ ] Task 5: 测试（至少覆盖校验与 CRUD）
  - [ ] Unit：title 校验（空/空格）与默认字段（status/createdAt）
  - [ ] Integration：Repository create/update/list 的持久化行为（使用测试 DB）
  - [ ] Widget：新增任务后列表出现；编辑后内容更新

## Dev Notes

- **分层约束**：UI 只调用 UseCase；UseCase 只依赖 Repository 抽象；Drift 仅在 data 实现。
- **时间与格式**：持久化时间统一用 UTC epoch ms，UI 展示再格式化（避免时区 bug）。
- **命名与结构**：按架构文档的 snake_case 文件命名与 feature-first 目录放置。

### Project Structure Notes

- Domain：`packages/domain/lib/entities/task.dart`
- Data：`packages/data/lib/db/tables/tasks_table.dart` + `packages/data/lib/repositories/drift_task_repository.dart`
- UI：`app/lib/features/tasks/...`

### References

- PRD（任务字段/任务列表/任务详情入口）：`_bmad-output/planning-artifacts/prd.md`
- Architecture（Drift/Riverpod/分层规则/命名约定）：`_bmad-output/planning-artifacts/architecture.md`
- UX（掌控感、低摩擦输入、错误提示语气）：`_bmad-output/planning-artifacts/ux-design-specification.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

