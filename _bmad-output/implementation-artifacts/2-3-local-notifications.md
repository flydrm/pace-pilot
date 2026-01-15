# Story 2.3: 到点本地通知提醒（Android First）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 番茄到点时收到可靠的本地通知提醒，
so that 即使我切后台也不会错过结束点。

## Acceptance Criteria

1. **Given** 我已开始番茄并切到后台  
   **When** 番茄到点  
   **Then** 我收到本地通知提醒（包含任务名/专注结束提示）
2. **Given** 我收到本地通知提醒  
   **When** 我点击通知  
   **Then** 应用被唤起并进入专注收尾流程（收尾 Sheet 可在 Story 2.4 完成；本 Story 至少能导航到 Focus 页并展示“已到点/待收尾”状态）
3. **Given** 系统通知权限被拒绝（Android 13+）  
   **When** 番茄到点  
   **Then** 应用在前台时提供可见的到点提示（不依赖系统通知），并引导用户在设置中开启（但不阻塞专注闭环）

## Tasks / Subtasks

- [ ] Task 1: 通知基础设施（flutter_local_notifications）（AC: 1, 2, 3）
  - [ ] 引入并初始化 `flutter_local_notifications`
  - [ ] Android 通知渠道（channel）配置：名称/说明/重要级别（符合“安静商务”但确保可感知）
  - [ ] 权限处理（Android 13+ POST_NOTIFICATIONS）：
    - [ ] 首次在需要时请求（用户触发开始番茄后），不在冷启动弹权限
    - [ ] 若拒绝：记录状态并走前台提示兜底（AC: 3）

- [ ] Task 2: 与 endAt 联动的调度/取消（AC: 1）
  - [ ] 开始番茄：按 `endAt` 调度到点通知
  - [ ] 暂停：取消通知
  - [ ] 继续：按新的 `endAt` 重新调度
  - [ ] 提前结束/放弃：取消通知
  - [ ] App 重启恢复（Story 2.2）：恢复 running 状态时必须重新调度（避免“计时恢复了但通知没了”）

- [ ] Task 3: 点击通知的路由与状态恢复（AC: 2）
  - [ ] 处理 notification tap 回调：
    - [ ] 导航进入 Focus 页（或专注收尾页）
    - [ ] 携带必要上下文（taskId、到点标记）
  - [ ] 若 app 已在前台：点击通知应聚焦到 Focus 并提示“已到点”

- [ ] Task 4: 前台兜底提示（权限拒绝/系统限制）（AC: 3）
  - [ ] 当无法发系统通知且番茄到点时：
    - [ ] Focus 页面内显示明显到点状态（banner/状态条）
    - [ ] 可选：轻量震动/音效（默认关闭，后续在设置中开放）
  - [ ] 提供“去系统设置开启通知”的入口（仅在用户主动点击时跳转）

- [ ] Task 5: 测试与验证（重点是回归与手工验收脚本）
  - [ ] Unit：调度时间计算（基于 endAt）
  - [ ] Widget：权限拒绝时的前台兜底提示出现
  - [ ] 手工验收脚本（写在 Story 完成备注里）：
    - [ ] Android 13+：允许通知/拒绝通知两条路径
    - [ ] 后台到点通知是否出现、点击是否回到 Focus
    - [ ] 杀进程后重启恢复 + 通知是否仍可按 endAt 触发（与 Story 2.2 联合验收）

## Dev Notes

- **权限请求必须“用户触发”**：只在用户开始番茄等明确动作之后请求，避免新手被打扰与不信任。
- **可靠性边界要透明**：若系统限制导致可能延迟（Doze/省电策略），至少保证：恢复后状态正确、前台可见提示正确，并在后续版本评估前台服务/精确闹钟等方案。
- **文案要克制**：提醒内容简短清晰（任务名 + “本番茄结束”）。

### Project Structure Notes

- Data：`packages/data/lib/notifications/local_notifications_service.dart`
- Domain：`packages/domain/lib/usecases/schedule_pomodoro_notification.dart`
- UI：Focus feature 内处理“到点/待收尾”状态

### References

- PRD（到点本地通知提醒）：`_bmad-output/planning-artifacts/prd.md`
- UX（不打扰原则、权限触发时机、到点提示语气）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（flutter_local_notifications、endAt 作为事实来源）：`_bmad-output/planning-artifacts/architecture.md`
- Epics（Story 2.3 AC）：`_bmad-output/planning-artifacts/epics.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

