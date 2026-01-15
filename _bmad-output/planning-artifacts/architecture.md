---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: "complete"
completedAt: "2026-01-14T10:09:28+08:00"
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
  - docs/PacePilotPrd.txt
  - _bmad-output/planning-artifacts/ux-design-directions.html
workflowType: "architecture"
project_name: "pace-pilot"
user_name: "User"
date: "2026-01-14"
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**

- **核心闭环（3-2-10）**：`今天`页 3 秒看清下一步 → 2 步进入专注 → 10 秒留痕（手写/AI 草稿）并回填任务
- **任务系统（Todo）**：任务 CRUD、筛选/搜索、子任务清单、任务详情聚合番茄记录与关联笔记、从任务直达专注
- **专注（Pomodoro）**：与任务强绑定；后台可靠提醒；被杀/重启后可恢复（基于 endAt 等持久状态）；收尾 Sheet（保存/稍后补/AI 生成）
- **笔记（Notes）**：笔记 CRUD、标签、与任务关联；AI 动作（总结/提取行动项/改写）
- **AI 效率台（动作优先）**：
  - 一句话拆任务（可编辑清单 → 批量导入 → 可撤销）
  - 问答检索（Evidence-first：回答必须引用可跳转证据；默认近 7 天范围）
  - 周复盘（默认上周自然周；生成草稿+证据；保存为笔记；同周重复生成只追加不覆盖）
- **数据掌控（信任基础设施）**：导出（JSON/Markdown）、全量备份/恢复（含强加密与“恢复前安全备份”）、一键清空
- **设置（不占 Tab，全局右上角）**：AI 配置（OpenAI 协议兼容 baseUrl/model/apiKey + 测试连接）、番茄配置、数据/外观

**Non-Functional Requirements:**

- **本地优先/离线可用**：无登录；核心功能（任务/专注/笔记/复盘浏览）离线可用；AI 为可选且用户触发
- **可信与可控（AI 护栏）**：预览→编辑→采用/撤销；禁止静默覆盖；证据不足必须明确提示“不足/不确定”
- **可靠性**：专注计时与通知稳定；后台与被杀恢复；恢复流程“失败原地不动”
- **隐私与安全**：apiKey 本地密文存储；备份包强加密；备份不包含 apiKey；权限最小化
- **体验**：安静、商务、稳重；信息密度高但不拥挤；专注期“安静驾驶舱”不打扰

**Scale & Complexity:**

- Primary domain: Flutter 移动端（Android 优先，Material 3）
- Complexity level: 中等（本地数据/索引 + 可靠后台计时 + 备份加密/恢复原子性 + AI 集成与证据链）
- Estimated architectural components: 6–8（UI、领域用例、数据持久化与索引、AI 客户端与提示词/Schema、平台能力、导出/备份、搜索与证据、设置与主题）

### Technical Constraints & Dependencies

- Flutter + Material 3（后续 iOS/桌面可扩展）
- OpenAI 协议兼容（Chat Completions MVP；后续可扩展 Responses）
- 本地存储：偏好（shared_preferences）+ 安全存储（Keystore/Keychain）+ 本地数据库/索引（PRD 推荐 drift/SQLite）
- Android 后台能力：通知/必要时前台服务/任务调度（以体验目标为准：准时提醒与可恢复）
- 备份/恢复：ZIP 包结构（data/*.json + exports/*.md + media/），PIN=恰好 6 位数字（允许 0 开头）

### Cross-Cutting Concerns Identified

- **证据链与可跳转引用**：任何 AI“问答/复盘/总结”输出都要带引用到 Task/Note/PomodoroSession 片段
- **变更可撤销**：AI 导入任务、AI 写入进展/复盘采用、清空等关键动作需要撤销/确认语义一致
- **索引一致性**：搜索（关键词/过滤；P1 语义检索）依赖增量索引与恢复后重建策略
- **数据一致性与原子恢复**：恢复前安全备份；校验通过才覆盖；失败不动；完成给出摘要
- **“不打扰”策略**：默认不做后台 AI 自动生成；专注期与收尾 Sheet 关闭语义（关闭=稍后补/不阻塞）保持一致

## Starter Template Evaluation

### Primary Technology Domain

移动端 App（Flutter，Android 优先）+ 本地优先数据层 + 可选 AI（OpenAI 协议兼容）。

### Starter Options Considered

1. **官方 `flutter create`**：最小依赖、长期稳定；适合把架构决策放在“业务模块与数据层”而不是脚手架花活上。
2. **Very Good CLI `very_good create flutter_app`（VGV Core）**：更“工程化”的开箱（flavors/i18n/测试等），但对 MVP 会引入额外结构与约束成本。

### Selected Starter: `flutter create`

**Rationale for Selection:**

- 满足“安静、可靠、可控”的产品目标：先把本地数据、计时可靠、备份恢复与 AI 护栏做扎实，再渐进工程复杂度
- Android First，不强推多端与复杂脚手架；后续再按需要扩平台/上 CI

**Initialization Command:**

```bash
# 建议在仓库根目录创建 app/，并按 PRD 的 packages/ 结构拆分 domain/ai/data
flutter create app --project-name pace_pilot --org com.example --platforms=android --android-language kotlin
```

**Architectural Decisions Provided by Starter:**

- **Language & Runtime**：Dart + Flutter SDK；默认项目结构（`lib/`, `test/`, `pubspec.yaml`）
- **Styling Solution**：Material Design（后续在 `app` 中统一采用 Material 3 主题与 tokens）
- **Build Tooling**：Android Gradle + Flutter toolchain
- **Testing Framework**：`flutter_test`（widget test 示例）
- **Code Organization**：默认 `lib/main.dart` 单入口；本项目会进一步按 `app` + `packages/*` 做分层
- **Development Experience**：热重载/调试/`flutter test`

**Note:** 项目初始化（脚手架创建 + 目录结构落地）应作为第一条实现型 Story 执行。

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**

- **本地数据库**：SQLite + Drift `^2.30.0`（提供响应式查询、迁移能力；用于任务/笔记/番茄记录/索引元数据）
- **状态管理**：`flutter_riverpod ^3.1.0`（UI 侧统一数据流与依赖注入；利于可测试与模块化）
- **路由**：`go_router ^17.0.1`（底部 Tab 用 ShellRoute 承载，支持 deep link 与页面栈隔离）
- **通知/提醒**：`flutter_local_notifications ^19.5.0`（番茄到点通知）；计时以 `endAt` 为事实来源确保可恢复
- **AI 通信与协议**：OpenAI 协议兼容（Chat Completions MVP）+ HTTP 客户端 `dio ^5.9.0`
- **敏感信息存储**：apiKey 等使用 `flutter_secure_storage ^10.0.0`（Keychain/Keystore/加密 SharedPreferences）

**Important Decisions (Shape Architecture):**

- **分层与包结构**：`app/`（UI）+ `packages/domain`（实体/用例）+ `packages/data`（DB/索引/备份）+ `packages/ai`（OpenAICompatibleClient + Prompt/Schema）
- **序列化/不可变模型**：`json_serializable ^6.11.3` + `freezed_annotation ^3.1.0`（配合 codegen，降低手写错误）
- **ID 策略**：`uuid ^4.5.2`（Task/Note/Session/Evidence 等全局唯一 id；引用只存 id）
- **备份/恢复**：`archive ^4.0.7`（ZIP 结构）+ `cryptography ^2.9.0`（AES-GCM 加密）+ `path_provider ^2.1.5`（目录）+ `file_picker ^10.x`/`share_plus ^12.0.1`（导入导出）
- **搜索**：关键词检索 P0（SQLite/FTS）；语义检索（embedding）P1

**Deferred Decisions (Post-MVP):**

- 云同步/多端协作（明确不做）
- 语义检索（P1）
- 自动化 CI/发布流水线（可在有节奏后补齐）

### Data Architecture

- **数据库（Drift/SQLite）**
  - 表：`tasks`、`task_check_items`（可选）、`notes`、`pomodoro_sessions`、`ai_configs`、`app_prefs`（含 hintKey）等
  - **证据引用**：统一 `evidenceId`（或 `(entityType, entityId, snippetRange)`）结构，AI 输出只能引用已存在 evidence
  - **迁移**：Drift schemaVersion + migration steps；恢复后根据需要重建索引
- **数据边界**
  - Domain：实体与用例只依赖抽象 Repository
  - Data：Repository 实现 + Drift DAO + 索引/备份实现
- **校验策略**
  - 关键字段（6 位 PIN、baseUrl、model、title 等）在 Domain/UseCase 层做校验，UI 只做输入提示

### Authentication & Security

- **无登录**：不引入账户体系与鉴权中间件
- **apiKey**：仅本地保存（`flutter_secure_storage`），不进入备份包；AI 请求仅在用户触发且明确选择发送范围时发起
- **备份加密**：
  - PIN=恰好 6 位数字（允许 0 开头），PIN 不保存不回填
  - 使用 `cryptography` 的 AES-GCM；密钥由 PIN + 随机 salt 通过 KDF 派生（建议 PBKDF2/Argon2，具体以可用实现为准）
  - 恢复必须先生成“恢复前安全备份包”，校验通过才覆盖；失败原地不动

### API & Communication Patterns

- **AI Client（OpenAI Compatible）**
  - baseUrl/model/apiKey 可配置；提供“测试连接”
  - 结构化输出优先（JSON Schema / 可解析结构），所有生成结果走 `Preview → Edit → Adopt/Undo`
  - 错误处理：401/429/5xx 统一映射为可读原因与下一步建议；失败不阻塞主闭环
- **本地搜索/问答证据**
  - 默认近 7 天范围；支持标签/类型过滤
  - 回答必须附引用；不足即不足（禁止编造）

### Frontend Architecture

- **UI**：Flutter + Material 3（安静商务风；`今天` Tab 视觉强化；`设置`右上角全局入口）
- **状态管理**：Riverpod（按 Feature 切 provider；UseCase 驱动；避免 UI 直连 DB）
- **路由**：go_router（底部 Tab 作为 ShellRoute；详情页作为子路由；支持深链）
- **Feature 切分（与 UX/IA 对齐）**
  - `ai_hub`（效率台）/`notes`/`today`/`tasks`/`focus`/`settings`
  - 各 Feature 内：`view` + `controller`（Riverpod Notifier）+ `ui_model`
- **性能策略**
  - 首页/Today 优先：启动后先渲染“下一步/今天队列”骨架，再异步补齐统计与摘要
  - 写入优先：番茄收尾/稍后补必须本地写入成功，AI 结果可延迟

### Infrastructure & Deployment

- **构建**：本地构建为主；后续可引入 GitHub Actions 做 lint/test/build
- **可观测性（本地）**：基础日志（debug 级别）+ 崩溃上报 P1（需隐私评估）

### Decision Impact Analysis

**Implementation Sequence:**

1. 初始化项目（`flutter create`）+ 建立 `app/` 与 `packages/*` 目录结构
2. Domain 实体/用例（Task/Note/Pomodoro）与 Repository 接口
3. Data：Drift schema + Repository 实现 + 基础 CRUD
4. UI：底部 5 Tab + 关键页面骨架（Today/Focus/Task/Note/AI Hub）
5. Focus 计时与通知（endAt 恢复）+ 进展记录/稍后补
6. AI 配置与测试连接 + 三大 AI 动作（拆任务/问答/周复盘）按“预览→采用”落地
7. 导出/备份/恢复/清空（含加密与原子恢复）

**Cross-Component Dependencies:**

- 证据链（AI 引用）依赖统一 ID/数据模型与可跳转路由
- 备份/恢复依赖数据层 schema 与导出格式稳定（需要版本号与向后兼容策略）
- Focus 的“可靠提醒”依赖平台通知/持久化 endAt 与 UI 状态机一致

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:** 9 类（命名/目录结构/路由/时间与序列化/错误模型/加载状态/证据引用/备份格式/AI 采用语义），这些点最容易导致“多 agent 写出来的代码拼不起来”。

### Naming Patterns

**Database Naming Conventions (SQLite/Drift):**

- 表名：复数 + snake_case（例：`tasks`, `pomodoro_sessions`）
- 列名：snake_case（例：`created_at`, `due_at`, `estimated_pomodoros`）
- Drift 实体/DAO：PascalCase（例：`Tasks`, `PomodoroSessions`, `TaskDao`）
- 时间字段统一：`*_at`（存 UTC epoch ms），UI 展示再转本地

**Code Naming Conventions (Dart/Flutter):**

- 文件/目录：snake_case（例：`task_detail_page.dart`，`features/today/`）
- 类/枚举：PascalCase（例：`TaskDetailPage`, `TaskStatus`）
- 变量/方法：lowerCamelCase（例：`taskId`, `loadTodaySummary()`）
- Riverpod Provider：`xxxProvider` / `xxxControllerProvider`（例：`todayControllerProvider`）

**Routing Conventions (go_router):**

- 路径：小写 + 短名（例：`/today`, `/tasks/:taskId`）
- 参数名统一：`taskId`, `noteId`, `sessionId`（与数据层字段一致）

### Structure Patterns

**Project Organization (monorepo):**

- `app/`：Flutter UI（Material 3）
- `packages/domain/`：实体 + 用例 + Repository 抽象（不依赖 Flutter、不依赖 drift）
- `packages/data/`：drift schema/DAO + Repository 实现 + 备份/导出/索引
- `packages/ai/`：OpenAICompatibleClient + Prompt/Schema + 解析与失败兜底

**Feature-first UI Structure (`app/lib`):**

- `features/<feature>/`（ai_hub/notes/today/tasks/focus/settings）
  - `view/`：page/screen + widgets
  - `controller/`：Riverpod Notifier/State（只调用 UseCase）
  - `ui_model/`：UI 专用模型与格式化（不污染 domain）
- `shared/`：通用组件（按钮/空态/错误态/底部 sheet）、主题 tokens、路由表

**Test Structure:**

- Domain：`packages/domain/test/`（纯 Dart 单测）
- Data：`packages/data/test/`（repository/DAO 单测；需要 sqlite 测试支持）
- App：`app/test/`（widget tests）；E2E/集成测试按需引入（P1）

### Format Patterns

**Export/Backup Data Formats:**

- `data/*.json` 均包含：`schemaVersion`、`exportedAt`、`items[]`
- JSON 字段：snake_case（跨语言可读；与 DB 命名一致）
- 时间：UTC epoch ms（避免时区歧义）

**AI Result Formats (structured):**

- 所有 AI 动作输出统一结构：`preview`（可编辑）+ `citations[]`（evidenceId）+ `warnings[]`（不足/不确定）
- 不允许“无证据引用的强断言”：没有 citations 必须降级为建议/需要补充

### Communication Patterns

**Evidence-first 统一引用协议（App 内部）:**

- 引用结构：`{evidence_id, entity_type, entity_id, snippet}`（最小可跳转）
- UI 展示：引用卡片点击 → 跳转到对应实体并高亮片段（若可定位）

**State Management Patterns (Riverpod):**

- 任何写入动作都返回明确结果（成功/失败 + 原因）；UI 根据结果决定 toast/snackbar
- “AI 采用”与“撤销”必须通过同一个 UseCase 实现（保证一致性与可审计）

### Process Patterns

**Error Handling Patterns:**

- 分层错误类型：`DomainFailure`（业务校验）/`DataFailure`（IO/DB）/`AiFailure`（网络/解析/限流）
- UI 文案：先说“发生了什么”，再给“下一步”（重试/检查 key/缩小范围/稍后补）

**Loading State Patterns:**

- `loading` 只用于首次加载；后台刷新用 `refreshing`（避免 UI 闪烁）
- 关键闭环（专注收尾保存）必须是“写入优先”，不等待 AI 完成

### Enforcement Guidelines

**All AI Agents MUST:**

- 遵守 `app/` + `packages/*` 分层，不允许 UI 直接依赖 drift/SQL
- 所有 AI 功能必须走 `Preview → Edit → Adopt/Undo`，禁止静默写入
- 所有“问答/复盘/总结”必须产出 citations（或明确不足），并可跳转到证据

**Pattern Enforcement:**

- 代码评审/自动检查以“目录结构 + 命名约定 + 公共错误类型 + AI 护栏”作为硬门槛
- 若发现 pattern 冲突：以本架构文档为准，回滚到一致实现并补充文档条目

### Pattern Examples

**Good Examples:**

- `packages/domain/lib/usecases/create_task_from_ai_breakdown.dart`
- `packages/ai/lib/features/breakdown/breakdown_schema.dart`
- `app/lib/features/focus/controller/focus_controller.dart`
- `app/lib/shared/navigation/app_router.dart`

**Anti-Patterns:**

- `app/` 里直接写 SQL/直接调用 drift DAO
- AI 输出不带引用、或直接覆盖用户输入
- 导出/备份格式不带版本号，导致未来无法恢复

## Project Structure & Boundaries

### Complete Project Directory Structure

```
pace-pilot/
├── README.md
├── docs/
│   └── PacePilotPrd.txt
├── _bmad/
├── _bmad-output/
│   ├── planning-artifacts/
│   │   ├── prd.md
│   │   ├── ux-design-specification.md
│   │   ├── ux-design-directions.html
│   │   └── architecture.md
│   └── implementation-artifacts/
├── app/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   ├── android/                         # flutter create 生成（Android-first）
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── bootstrap/
│   │   │   ├── dependency_graph.dart     # 依赖组装（domain/data/ai）
│   │   │   └── app_startup.dart          # 启动流程（warm-up / restore focus state）
│   │   ├── shared/
│   │   │   ├── navigation/
│   │   │   │   ├── app_router.dart
│   │   │   │   └── routes.dart
│   │   │   ├── theme/
│   │   │   │   ├── app_color_schemes.dart
│   │   │   │   ├── app_theme.dart
│   │   │   │   └── app_typography.dart
│   │   │   ├── widgets/
│   │   │   │   ├── app_bottom_bar.dart
│   │   │   │   ├── empty_state.dart
│   │   │   │   ├── error_state.dart
│   │   │   │   ├── confirm_dialog.dart
│   │   │   │   └── sheet_scaffold.dart
│   │   │   └── format/
│   │   │       ├── date_formatters.dart
│   │   │       └── durations.dart
│   │   ├── features/
│   │   │   ├── ai_hub/
│   │   │   │   ├── view/ai_hub_page.dart
│   │   │   │   ├── view/breakdown_page.dart
│   │   │   │   ├── view/ask_page.dart
│   │   │   │   ├── view/weekly_review_page.dart
│   │   │   │   ├── controller/ai_hub_controller.dart
│   │   │   │   ├── controller/ask_controller.dart
│   │   │   │   └── ui_model/ask_result_vm.dart
│   │   │   ├── notes/
│   │   │   │   ├── view/notes_list_page.dart
│   │   │   │   ├── view/note_detail_page.dart
│   │   │   │   └── controller/notes_controller.dart
│   │   │   ├── today/
│   │   │   │   ├── view/today_page.dart
│   │   │   │   ├── view/yesterday_review_panel.dart
│   │   │   │   └── controller/today_controller.dart
│   │   │   ├── tasks/
│   │   │   │   ├── view/tasks_list_page.dart
│   │   │   │   ├── view/task_detail_page.dart
│   │   │   │   └── controller/tasks_controller.dart
│   │   │   ├── focus/
│   │   │   │   ├── view/focus_page.dart
│   │   │   │   ├── view/focus_wrap_up_sheet.dart
│   │   │   │   └── controller/focus_controller.dart
│   │   │   └── settings/
│   │   │       ├── view/settings_page.dart
│   │   │       ├── view/ai_settings_page.dart
│   │   │       ├── view/data_settings_page.dart
│   │   │       └── controller/settings_controller.dart
│   │   └── diagnostics/
│   │       ├── debug_flags.dart
│   │       └── log.dart
│   └── test/
│       ├── smoke_test.dart
│       └── features/
│           └── today/
│               └── today_page_test.dart
└── packages/
    ├── domain/
    │   ├── pubspec.yaml
    │   └── lib/
    │       ├── entities/
    │       │   ├── task.dart
    │       │   ├── note.dart
    │       │   └── pomodoro_session.dart
    │       ├── repositories/
    │       │   ├── task_repository.dart
    │       │   ├── note_repository.dart
    │       │   ├── pomodoro_repository.dart
    │       │   └── search_repository.dart
    │       ├── usecases/
    │       │   ├── create_task.dart
    │       │   ├── update_task_progress.dart
    │       │   ├── start_focus_session.dart
    │       │   ├── finish_focus_session.dart
    │       │   ├── ai_breakdown_to_tasks.dart
    │       │   ├── ask_my_work.dart
    │       │   └── generate_weekly_review.dart
    │       └── value_objects/
    │           ├── entity_id.dart
    │           └── six_digit_pin.dart
    ├── data/
    │   ├── pubspec.yaml
    │   └── lib/
    │       ├── db/
    │       │   ├── app_database.dart
    │       │   ├── migrations.dart
    │       │   └── tables/
    │       │       ├── tasks_table.dart
    │       │       ├── notes_table.dart
    │       │       └── pomodoro_sessions_table.dart
    │       ├── repositories/
    │       │   ├── drift_task_repository.dart
    │       │   ├── drift_note_repository.dart
    │       │   ├── drift_pomodoro_repository.dart
    │       │   └── drift_search_repository.dart
    │       ├── search/
    │       │   ├── fts_index.dart
    │       │   └── snippet_highlighter.dart
    │       ├── backup/
    │       │   ├── backup_bundle.dart
    │       │   ├── backup_encryptor.dart
    │       │   └── restore_transaction.dart
    │       ├── export/
    │       │   ├── export_json.dart
    │       │   └── export_markdown.dart
    │       └── preferences/
    │           ├── hint_store.dart
    │           └── app_preferences.dart
    └── ai/
        ├── pubspec.yaml
        └── lib/
            ├── client/
            │   ├── openai_compatible_client.dart
            │   ├── models.dart
            │   └── errors.dart
            ├── schemas/
            │   ├── task_breakdown_schema.dart
            │   ├── ask_my_work_schema.dart
            │   └── weekly_review_schema.dart
            ├── prompts/
            │   ├── task_breakdown_prompt.dart
            │   ├── ask_my_work_prompt.dart
            │   └── weekly_review_prompt.dart
            └── features/
                ├── task_breakdown.dart
                ├── ask_my_work.dart
                └── weekly_review.dart
```

### Architectural Boundaries

**API Boundaries:**

- 仅一类外部 API：OpenAI 协议兼容 HTTP（baseUrl/model/apiKey，可测试连接）
- 任何请求必须在 UI 层呈现“发送范围”，并通过 UseCase 触发（禁止 UI 里直接发请求）

**Component Boundaries:**

- `app/` 只负责 UI/交互/状态机，不包含 SQL、加密、归档等底层实现
- Feature 内部通过 UseCase 交互，跨 Feature 共享只允许通过 `shared/` 或 Domain UseCase

**Service Boundaries:**

- `packages/ai`：只负责“请求/结构化输出/解析/错误分类”，不直接写 DB
- `packages/data`：只负责“持久化/索引/导出/备份/恢复”，不含 UI 逻辑
- `packages/domain`：规则与用例，负责“AI 采用/撤销语义”“证据引用协议”“6 位 PIN 校验”等核心约束

**Data Boundaries:**

- DB schema 与导出格式都必须带版本号；恢复/迁移只能由 data 层执行
- 任何 evidence 引用必须可从本地实体解析（否则 AI 结果只能降级为“建议/不足”）

### Requirements to Structure Mapping

**Feature Mapping:**

- AI 效率台（拆任务/问答/周复盘）：`app/lib/features/ai_hub` + `packages/ai` + `packages/domain/usecases/*ai*`
- 笔记（CRUD/标签/关联）：`app/lib/features/notes` + `packages/domain/entities/note.dart` + `packages/data/repositories/drift_note_repository.dart`
- 今天（下一步/队列/昨天回顾）：`app/lib/features/today` + `packages/domain/usecases/*today*`（如需）
- 任务（CRUD/清单/详情/开始专注）：`app/lib/features/tasks` + `packages/domain/entities/task.dart`
- 专注（计时/通知/收尾 Sheet）：`app/lib/features/focus` + `packages/domain/entities/pomodoro_session.dart` + `packages/data/.../pomodoro_*`
- 设置（AI/番茄/数据/外观）：`app/lib/features/settings` + `packages/data/preferences` + `packages/ai/client`

**Cross-Cutting Concerns:**

- 证据引用与跳转：`packages/domain/repositories/search_repository.dart` + `app/lib/shared/navigation/app_router.dart`
- 备份/恢复/清空：`packages/data/backup` + `app/lib/features/settings/view/data_settings_page.dart`
- 统一错误与提示：`packages/ai/client/errors.dart` / `packages/domain/...Failure` + `app/lib/shared/widgets/error_state.dart`

### Integration Points

**Internal Communication:**

- UI → Controller（Riverpod）→ UseCase（domain）→ Repository（domain 抽象）→ Impl（data/ai）

**External Integrations:**

- 仅 OpenAI Compatible endpoint；未来若有自建网关，仍复用 `OpenAICompatibleClient`

**Data Flow:**

- 写入优先（Task/Note/Session/Progress）→ 增量更新索引（search）→ AI 仅在用户触发时读取本地证据并生成草稿

### File Organization Patterns

**Configuration Files:**

- App 运行时配置（AI/baseUrl/model、外观、番茄配置）统一由 `packages/data/preferences` 管理
- 敏感配置（apiKey/PIN 派生材料）只进 secure storage/内存，不进备份

**Asset Organization:**

- 仅在 `app/assets/` 放静态资源（图标/插画），避免散落在 feature 目录

### Development Workflow Integration

**Build Process Structure:**

- `app/` 作为可运行入口；`packages/*` 作为依赖包，单独可测
- 默认先跑 domain/data 单测，再跑 app widget tests
```

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:**

- Drift（SQLite）+ Riverpod + go_router 的组合没有结构性冲突；数据层/领域层/界面层边界清晰
- AI 通信（dio）与本地安全存储（flutter_secure_storage）职责分离，符合“BYO key + 用户触发 + 不静默覆盖”的信任边界

**Pattern Consistency:**

- 命名约定（snake_case 文件/DB，PascalCase 类型）与 Dart/SQLite 生态一致
- AI 护栏（Preview→Adopt/Undo + citations）贯穿 UseCase 与 UI 状态机，能有效降低“编造/夺权”风险

**Structure Alignment:**

- `app/` + `packages/*` 分层与 PRD 建议一致，能支撑后续多端扩展与并行开发
- Feature-first UI 结构与 5 Tab 信息架构一一对应，减少跨目录耦合

### Requirements Coverage Validation ✅

**Feature Coverage:**

- 任务/专注/笔记/AI 效率台/数据掌控/设置均已映射到具体模块与数据层能力
- Evidence-first 的“可跳转引用”已作为跨切关注点（domain+data+router）落位

**Non-Functional Requirements Coverage:**

- 本地优先、隐私可控、AI 用户触发、失败不阻塞主闭环已被明确为强约束
- 备份/恢复的原子性（恢复前安全备份、失败原地不动）已落入 data 层边界与流程约束

### Implementation Readiness Validation ✅

**Decision Completeness:**

- 关键技术选型与版本已记录（Drift/Riverpod/go_router/dio/secure_storage/notifications 等）
- 备份加密与导出格式约束明确（6 位 PIN、schemaVersion、UTC 时间）

**Structure Completeness:**

- 给出了可落地的目录树与关键文件名；requirements → 目录映射明确

**Pattern Completeness:**

- 已覆盖最常见 agent 冲突源（命名/结构/格式/错误/加载/AI 语义/证据引用/备份格式）

### Gap Analysis Results

**Important Gaps (建议实现前补齐到 story 级别):**

- Android “后台可靠提醒”的具体实现组合（通知 + endAt 恢复 + 必要时前台服务/系统调度）需要在实现 Story 中固化成可验收的技术方案与权限声明

### Architecture Completeness Checklist

**✅ Requirements Analysis**

- [x] Project context 分析完成
- [x] 技术约束与跨切关注点明确

**✅ Architectural Decisions**

- [x] 关键选型与版本记录
- [x] AI 信任边界与证据链机制落位

**✅ Implementation Patterns**

- [x] 命名/结构/错误/加载/AI 采用语义统一

**✅ Project Structure**

- [x] 完整目录结构 + 边界 + requirements 映射

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** High

**Key Strengths:**

- 以“信任/掌控”为中心的约束被写入架构（AI 护栏、备份恢复原子性、写入优先）
- 分层清晰，便于并行推进与减少返工

**Areas for Future Enhancement:**

- P1 语义检索（embedding）与可选的自建网关（apiKey 风险缓解）

### Implementation Handoff

**AI Agent Guidelines:**

- 所有实现必须遵守本文件的分层、命名、AI 采用语义与证据引用协议
- 如发现冲突或缺口：先更新本架构文档，再改代码

**First Implementation Priority:**

- `flutter create app --project-name pace_pilot --org com.example --platforms=android --android-language kotlin`
