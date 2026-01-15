# Story 5.4: 恢复准备（选择备份 + 校验 + 恢复前安全备份）

Status: ready-for-dev

## Story

As a 个人用户（知识工作者），
I want 在真正覆盖数据前完成校验并生成安全备份，
so that 恢复流程在任何失败场景下都不会让我“失控”。

## Acceptance Criteria

1. **Given** 我在“设置 → 数据”点击“恢复备份”  
   **When** 我选择了一个备份包并输入 6 位 PIN  
   **Then** 系统校验备份包与 PIN（例如：解密成功、清单可读、schemaVersion 可解析）
2. **Given** 备份包与 PIN 校验通过  
   **When** 系统进入恢复流程  
   **Then** 系统先生成“恢复前安全备份包”，且该步骤成功后才允许继续
3. **Given** 校验失败或安全备份生成失败  
   **When** 我返回应用主流程  
   **Then** 系统不得写入任何数据变更（原地不动），并提示原因与下一步建议
4. **Given** 我已完成校验且安全备份已生成  
   **When** 我查看确认页  
   **Then** 我能看到将要恢复的摘要信息（schemaVersion、备份时间、任务/笔记/番茄数量等）以及“继续执行恢复”的明确入口

## Tasks / Subtasks

- [ ] Task 1: 输入与校验（PIN + 文件）（AC: 1, 3）
  - [ ] 实现 `SixDigitPin`（Domain 值对象）：恰好 6 位数字（允许 0 开头），不保存不回填
  - [ ] UI 输入框：
    - [ ] 仅允许数字输入；长度到 6 自动失焦/可提交
    - [ ] 错误提示语气克制且可操作（例如“PIN 不正确或备份包已损坏”）
  - [ ] 文件选择（file_picker）：
    - [ ] 仅允许选择 `.zip`（或 app 自定义扩展名），并显示文件名/大小

- [ ] Task 2: 备份包解密与结构校验（AC: 1, 3, 4）
  - [ ] 约定备份包内部必须包含清单文件（建议：`manifest.json`），至少字段：
    - [ ] `schemaVersion`
    - [ ] `exportedAt`
    - [ ] `counts`（tasks/notes/pomodoros 等）
    - [ ] `files`（data/*.json + exports/*.md + media/ 的存在性）
  - [ ] 解密与解包流程（只在临时目录进行，禁止触碰现有 DB）：
    - [ ] 使用 `cryptography`（AES-GCM）+ KDF（PBKDF2/Argon2 以可用实现为准）从 PIN 派生密钥
    - [ ] 解密失败/认证失败：直接失败并提示（不产生任何数据写入）
    - [ ] 解包后校验：manifest 可读、版本兼容、必要文件存在
  - [ ] 版本兼容策略（先定 MVP）：
    - [ ] `schemaVersion` 大于当前支持版本：提示“版本过新，无法恢复”
    - [ ] 小于等于当前版本：允许继续（若需要迁移，在 5.5 处理）

- [ ] Task 3: 生成“恢复前安全备份包”（AC: 2, 3, 4）
  - [ ] 在真正执行覆盖前，调用备份能力生成“安全备份包”（等价 Story 5.3 的备份流程）
  - [ ] 安全备份包命名建议：`pace-pilot-safe-backup-<yyyyMMdd-HHmmss>.zip`
  - [ ] 默认保存位置建议：
    - [ ] 先保存到 app 文档目录；完成后提供“分享/导出”入口（避免权限/路径不确定导致失败）
  - [ ] 若安全备份生成失败：停止流程并提示原因（例如存储权限/磁盘空间不足），不得继续恢复

- [ ] Task 4: 恢复确认页/确认弹窗（AC: 4）
  - [ ] 展示摘要（从 manifest + 本地环境信息生成）：
    - [ ] 备份时间、schemaVersion、数量统计
    - [ ] 明确告知“将覆盖本地数据”；并告知“已生成安全备份包”
  - [ ] 提供明确按钮：`继续执行恢复`（进入 Story 5.5）与 `取消`

- [ ] Task 5: 测试（覆盖失败分支与“原地不动”）
  - [ ] Unit：`SixDigitPin` 校验（含 0 开头）与错误文案映射
  - [ ] Integration：
    - [ ] 错 PIN / 篡改包 → 解密失败，DB 不应被写入
    - [ ] 缺失 manifest / schemaVersion 不可解析 → 阻止继续
    - [ ] 安全备份生成失败 → 阻止继续
  - [ ] Widget：恢复流程 UI（选择文件 → 输入 PIN → 摘要页出现/错误态出现）

## Dev Notes

- **恢复准备阶段必须“只读”**：所有解密/解包/校验都在临时目录完成，禁止提前写入数据库或覆盖文件。
- **安全备份是信任基石**：只要安全备份没成功，就不允许出现任何“继续恢复”的入口。
- **apiKey 不在备份中**：恢复流程不得尝试从备份写入 apiKey；若需要清空/保留策略，在 5.5 明确并写入 AC/实现。

### Project Structure Notes

- Domain：`packages/domain/lib/value_objects/six_digit_pin.dart`、`packages/domain/lib/entities/backup_manifest.dart`
- Data：`packages/data/lib/backup/backup_crypto.dart`、`packages/data/lib/backup/backup_manifest_reader.dart`
- UI：`app/lib/features/settings/data/restore_flow/...`

### References

- PRD（原子恢复/恢复前安全备份/失败原地不动）：`_bmad-output/planning-artifacts/prd.md`
- UX（高风险动作确认语义、安静不打扰）：`_bmad-output/planning-artifacts/ux-design-specification.md`
- Architecture（备份结构、PIN 规则、加密建议）：`_bmad-output/planning-artifacts/architecture.md`
- Epics（Story 5.4 AC）：`_bmad-output/planning-artifacts/epics.md`

## Dev Agent Record

### Agent Model Used

GPT-5.2

### Debug Log References

### Completion Notes List

### File List

