# Story 1.4: 任务详情（Checklist、关联入口、开始专注入口）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 在任务详情里把任务变得更可执行，并能开始专注，
so that 我能从“知道要做”快速进入“正在做”。

## Acceptance Criteria

1. **Given** 我从任务列表进入某个任务的详情页  
   **When** 页面渲染完成  
   **Then** 我能看到任务的核心信息（标题、状态、优先级、截止日期、标签、预计番茄数等，允许与 Story 1.2 复用同一编辑入口）
2. **Given** 我打开某个任务的详情页  
   **When** 我添加一个 Checklist 子任务并保存  
   **Then** 子任务被持久化且再次进入仍可见
3. **Given** 我打开某个任务的详情页且存在 Checklist 子任务  
   **When** 我勾选/取消勾选任一子任务  
   **Then** 勾选状态被保存且再次进入仍保持一致
4. **Given** 我打开某个任务的详情页  
   **When** 我查看“关联笔记”“番茄记录”区域  
   **Then** 页面展示对应入口（允许先为空态/占位），点击可进入对应页面或提示“暂未实现”
5. **Given** 我打开某个任务的详情页  
   **When** 我点击“开始专注”  
   **Then** 导航进入 `专注` 页面并带上当前任务上下文（即使计时功能尚未完成，也至少展示任务标题/选中状态）

## Tasks / Subtasks

- [ ] Task 1: 路由与导航（AC: 1, 5）
  - [ ] 在 `go_router` 中增加任务详情路由（例如：`/tasks/:taskId`）
  - [ ] 在任务列表点击条目可进入详情页
  - [ ] 设计“开始专注”跳转方式（择一并在实现中固定）：
    - [ ] A) 跳转到 `/focus?taskId=...` 并由 Focus 页读取参数  
    - [ ] B) 通过共享的 `SelectedTaskController`（Riverpod）设置选中任务后切到 Focus Tab

- [ ] Task 2: Checklist 的 Domain 形状（AC: 2, 3）
  - [ ] 在 `packages/domain` 定义 `TaskChecklistItem`（或等价）实体：`id/taskId/title/isDone/orderIndex/createdAt/updatedAt`
  - [ ] 校验：title 非空/去空白；同一 task 下 orderIndex 稳定排序
  - [ ] 定义接口：`TaskChecklistRepository`（create/toggle/updateTitle/reorder/delete/listByTaskId）

- [ ] Task 3: Checklist 的 Data 持久化（Drift/SQLite）（AC: 2, 3）
  - [ ] 在 `packages/data` 增加 `task_check_items` 表（taskId 外键/索引、isDone、orderIndex、timestamps）
  - [ ] 实现 `DriftTaskChecklistRepository`
  - [ ] 为“按 taskId 查询 + 按 orderIndex 排序”建立索引/查询方法

- [ ] Task 4: 任务详情 UI（信息区 + Checklist 区）（AC: 1, 2, 3）
  - [ ] 任务详情页结构（建议）：
    - [ ] 顶部：标题 + 状态/优先级摘要 + 编辑入口
    - [ ] Checklist：列表 + “新增子任务”输入/按钮 + 勾选切换
    - [ ] 关联区：关联笔记入口、番茄记录入口（空态友好）
    - [ ] 底部主按钮：“开始专注”（主行动）
  - [ ] Checklist 新增交互：输入后提交即创建；空输入禁止提交；提交后清空
  - [ ] 勾选切换必须是“本地即时反馈 + 持久化成功后稳定”（失败给出可读提示，不崩溃）

- [ ] Task 5: 关联入口占位（AC: 4）
  - [ ] “关联笔记”点击：
    - [ ] 若 Notes 未实现：展示轻量提示（SnackBar/空页）“笔记功能待实现”
    - [ ] 若已实现：预留跳转接口（例如按 taskId 过滤）
  - [ ] “番茄记录”点击：同上（Focus 记录未实现时先占位）

- [ ] Task 6: 测试（最小但必须可回归）
  - [ ] Unit：Checklist title 校验（空/空格）与 toggle 逻辑
  - [ ] Integration：Checklist create/toggle/listByTaskId 持久化
  - [ ] Widget：从任务列表进入详情；新增 checklist 可见；toggle 后状态保持；点击“开始专注”能带 task 上下文进入 Focus

## Dev Notes

- **先定“形状”再补功能**：Focus/Notes/番茄记录可先占位，但路由与“带 taskId 的上下文”必须在本 Story 定死，避免后续跨 Feature 大重构。
- **不打扰**：详情页避免自动弹窗与强引导；空态用轻量文案与 CTA 即可。
- **一致性**：Checklist 的“新增/勾选”交互语义要与后续“专注收尾 Sheet”的“可撤销/可回填”风格一致（即时可见、可解释、可恢复）。

### Project Structure Notes

- Domain：`packages/domain/lib/entities/task_checklist_item.dart`、`packages/domain/lib/repositories/task_checklist_repository.dart`
- Data：`packages/data/lib/db/tables/task_check_items_table.dart`、`packages/data/lib/repositories/drift_task_checklist_repository.dart`
- UI：`app/lib/features/tasks/view/task_detail_page.dart` + `controller/task_detail_controller.dart`

### References

- PRD（任务详情/Checklist/开始专注入口）：`_bmad-output/planning-artifacts/prd.md`
- UX（任务详情信息密度与安静感、主行动按钮）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（go_router/Riverpod/分层规则/DB）：`_bmad-output/planning-artifacts/architecture.md`
- Wireframe：`_bmad-output/excalidraw-diagrams/wireframe-20260114.excalidraw`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

