# Story 5.5: 执行恢复（原子覆盖 + 摘要 + 失败回滚）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 执行恢复时保证原子性并在失败时回滚，
so that 我能放心使用恢复功能而不担心数据损坏。

## Acceptance Criteria

1. **Given** 我已完成备份包校验且已生成“恢复前安全备份包”  
   **When** 我确认执行恢复  
   **Then** 系统以原子方式覆盖当前数据（例如：先写入临时目录/临时数据库并校验，通过后再切换）
2. **Given** 执行恢复过程中任一步骤失败  
   **When** 我回到应用  
   **Then** 现有数据必须保持不变（原地不动），并提示失败原因与下一步建议
3. **Given** 恢复执行成功  
   **When** 我看到完成提示  
   **Then** 系统展示恢复摘要（任务/笔记/番茄记录等数量）与完成时间

## Tasks / Subtasks

- [ ] Task 1: 定义“原子恢复”实现策略（先定 MVP，写入实现与测试）
  - [ ] 推荐策略：**临时数据库 + 文件夹临时写入 + 最后一次性切换**
    - [ ] 关闭当前 DB 连接（确保无句柄占用）
    - [ ] 在临时路径创建新 DB 文件（例如 `app_db.restore.tmp`）
    - [ ] 将备份的 `data/*.json` 导入临时 DB（按 schemaVersion 做必要迁移/兼容）
    - [ ] 校验临时 DB（最少：表存在、关键字段可读、行数与 manifest 匹配/合理）
    - [ ] 媒体文件 `media/` 复制到临时目录并校验（数量/哈希可选）
    - [ ] 全部成功后：用原子 rename 方式切换（替换 DB 文件与 media 目录）
  - [ ] 任一步骤失败：删除临时产物并退出；不得修改现有 DB/media

- [ ] Task 2: 数据导入与版本兼容（AC: 1, 2, 3）
  - [ ] 定义导入顺序（避免外键/引用问题）：tasks → notes → pomodoro_sessions → 关联表（如 tags/check_items）
  - [ ] schemaVersion 处理：
    - [ ] 若备份版本低于当前：在临时 DB 上执行迁移/补默认值
    - [ ] 若备份版本高于当前：在 5.4 已阻止进入本步骤
  - [ ] 导入校验：
    - [ ] 对比 manifest 的 counts（允许小偏差但要有规则，例如“忽略未知实体”时要提示）
    - [ ] 发现严重不一致：视为失败并回滚

- [ ] Task 3: UI 执行态（进度/失败/成功）（AC: 2, 3）
  - [ ] 执行恢复时显示进度（至少：准备 → 导入数据 → 校验 → 切换 → 完成）
  - [ ] 失败态：
    - [ ] 明确说明“未修改现有数据”
    - [ ] 提供下一步：重试/选择其它备份/查看安全备份包位置（如可用）
  - [ ] 成功态：展示摘要（counts + 完成时间）并提供“返回 Today”

- [ ] Task 4: 恢复后的后处理（不阻塞主闭环）
  - [ ] 恢复完成后触发必要的索引/缓存重建（如 FTS/搜索索引）
  - [ ] 若索引重建失败：只提示不影响任务/笔记/专注主闭环使用（异步可重试）

- [ ] Task 5: 测试（核心是“失败原地不动”与原子切换）
  - [ ] Integration：
    - [ ] 在旧数据存在时模拟导入中途失败 → 重启后旧数据仍可读且未变化
    - [ ] 模拟切换前校验失败 → 不切换
    - [ ] 成功路径：恢复后 counts 与摘要一致
  - [ ] Widget：执行恢复流程的进度与成功/失败 UI

## Dev Notes

- **原子性优先级最高**：不要在现有 DB 上“先删后插”做恢复；一定要在临时 DB 完成后再切换。
- **恢复不是重置**：恢复只覆盖业务数据（tasks/notes/pomodoros/media/导出文件）；敏感信息（apiKey 等 secure storage）默认不变，且不从备份写入。
- **失败语义**：失败时要明确告诉用户“你现在的数据没有变化”，并把“安全备份包”作为兜底信任锚点。

### Project Structure Notes

- Domain：`packages/domain/lib/usecases/restore_backup.dart`
- Data：`packages/data/lib/backup/restore_service.dart`（临时 DB/目录写入与切换在此封装）
- UI：`app/lib/features/settings/data/restore_flow/restore_apply_page.dart`

### References

- PRD（恢复原子性、失败原地不动、恢复摘要）：`_bmad-output/planning-artifacts/prd.md`
- UX（高风险动作、文案语气与确认语义）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（备份/恢复策略、加密/zip 结构）：`_bmad-output/planning-artifacts/architecture.md`
- Epics（Story 5.5 AC）：`_bmad-output/planning-artifacts/epics.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

