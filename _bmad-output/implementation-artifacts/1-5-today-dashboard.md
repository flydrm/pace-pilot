# Story 1.5: Today 工作台（下一步 + 今天队列 + 昨天回顾骨架）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 在 Today 一眼看到下一步与今天队列，
so that 我能在 3 秒内决定现在做什么。

## Acceptance Criteria

1. **Given** 我打开 `今天` 页  
   **When** 页面加载完成  
   **Then** 页面至少包含三个区域：`下一步`、`今天队列`、`昨天回顾（默认折叠）`
2. **Given** 我首次使用且无任何数据  
   **When** 我查看 `今天` 页  
   **Then** 三个区域分别呈现清晰空态与下一步指引（例如“去添加任务/开始专注”），且不弹窗打扰
3. **Given** 我已有多条任务（含不同优先级/截止日期/状态）  
   **When** 我查看 `今天` 页  
   **Then** `今天队列`展示一组任务条目（来源规则可为 MVP，但必须在实现中固定并可测试）
4. **Given** `今天队列`展示任务条目  
   **When** 我点击任一任务条目  
   **Then** 我能进入该任务的详情页（与 Story 1.4 路由一致）

## Tasks / Subtasks

- [ ] Task 1: 明确 Today 队列来源规则（Domain/UseCase）（AC: 3）
  - [ ] 定义 `TodayQueueRule`（或等价纯函数），输入：任务列表 + 当前日期时间，输出：`nextStep` + `todayQueue`
  - [ ] MVP 推荐规则（落地为确定性逻辑并写单测）：
    - [ ] 仅候选：未完成任务（todo/inProgress）
    - [ ] 先收集：逾期任务 + 今天到期任务
    - [ ] 不足 N 条时补齐：按默认排序（Story 1.3 的 priority desc + dueAt asc(null last)）取前 N 条
    - [ ] `nextStep` 默认取 `todayQueue` 的第一条（后续可扩展用户手动指定）
  - [ ] 统一“今天/逾期”边界：以本地日期计算（与 Story 1.3 保持一致）

- [ ] Task 2: Today 页 UI（区域划分 + 空态）（AC: 1, 2, 3）
  - [ ] 实现 `今天` 页布局（建议）：
    - [ ] `下一步`：突出显示（卡片/强调色边框），展示任务标题 + 优先级/到期信息 + 主按钮（如“开始专注”占位）
    - [ ] `今天队列`：列表（最多 N 条）+ 轻量说明（队列来源规则的可理解描述）
    - [ ] `昨天回顾`：默认折叠（expander），先展示骨架/占位文案（后续 Epic 2/4 补齐数据）
  - [ ] 空态策略：
    - [ ] 无任务：`下一步` 给出 CTA（例如“新增任务”“去任务页”）
    - [ ] 有任务但队列为空（理论上不应）：展示“没有可执行任务”的解释与引导
  - [ ] 全程不弹窗、不强制引导；使用轻量提示即可（符合“安静、掌控”）

- [ ] Task 3: 与任务详情联动（AC: 4）
  - [ ] 点击 `下一步` 或队列条目进入任务详情（`/tasks/:taskId`）
  - [ ] 复用任务列表 item 组件（若已有）以保持一致的视觉与信息密度

- [ ] Task 4: 状态管理与加载体验（AC: 1, 2, 3）
  - [ ] Today 页面通过 Riverpod 订阅任务列表（来自 `TaskRepository`/UseCase）
  - [ ] 加载态使用骨架/占位（避免白屏），但不影响基本导航与操作

- [ ] Task 5: 测试（覆盖规则与页面区域存在性）
  - [ ] Unit：`TodayQueueRule` 的 today/overdue 边界与补齐规则
  - [ ] Widget：三大区域存在；无数据时空态文案出现；有数据时队列渲染；点击条目进入任务详情

## Dev Notes

- **今天是默认落点且要“看起来更重要”**：壳层的 Tab 强调（Story 1.1）+ 页面内部的“下一步”强调一起完成心智强化。
- **规则要可解释**：即便 MVP 先按 due/priority 自动生成，也要在 UI 里用一句话说清楚来源，避免“我不信任为什么是这些”。
- **后续扩展位**：保留“手动加入今天队列/固定下一步”的扩展点，但本 Story 只实现自动规则。

### Project Structure Notes

- Domain：`packages/domain/lib/usecases/today_queue_rule.dart`（或等价）
- UI：`app/lib/features/today/view/today_page.dart` + `controller/today_controller.dart`
- Navigation：复用 `tasks` 路由（`/tasks/:taskId`）

### References

- PRD（3 秒看清下一步、Today 核心闭环）：`_bmad-output/planning-artifacts/prd.md`
- UX（Today 信息结构、安静商务风格、空态语气）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（Riverpod/usecase-first、go_router）：`_bmad-output/planning-artifacts/architecture.md`
- Wireframe：`_bmad-output/excalidraw-diagrams/wireframe-20260114.excalidraw`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

