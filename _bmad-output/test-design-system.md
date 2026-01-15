# System-Level Test Design（Solutioning Phase）

**Date:** 2026-01-14  
**Author:** User  
**Status:** Draft  

## 1) Testability Assessment

### Controllability（可控性）

- **PASS（有前提）**：Domain/Data/AI 分层清晰，易于用 Fake/Mock 控制外部依赖（AI 网络、文件系统、时间源）。
- **CONCERNS**：Android 后台计时/通知/前台服务的“系统级可控性”较弱，需要抽象时间源与通知调度，并准备设备/模拟器矩阵验证。

### Observability（可观测性）

- **PASS**：核心状态均可从本地数据与 endAt 等持久化状态重建；Evidence-first 机制天然要求“可追溯引用”。
- **CONCERNS**：需要定义“可测试的日志/诊断接口”（至少 debug 日志与关键事件埋点），否则难定位后台/恢复类问题。

### Reliability（可复现性/隔离性）

- **PASS**：Local-first，无外部后端依赖，天然减少环境不确定性；AI 可通过 mock server/fixture 固定响应。
- **CONCERNS**：与 OS 强相关的通知/进程被杀恢复，E2E 可能波动，需要更偏“集成/仪表化测试”而不是纯 E2E。

## 2) Architecturally Significant Requirements (ASRs)

使用风险矩阵（Probability 1–3 × Impact 1–3，≥6 需明确缓解，=9 建议 gate FAIL）：

| ASR ID | Category | Description | Probability | Impact | Score | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| ASR-001 | OPS/TECH | Android 后台“准时提醒 + 可恢复”是核心闭环（专注） | 3 | 3 | 9 | OS 约束复杂，需最优先验证 |
| ASR-002 | DATA | 备份/恢复必须原子：恢复前安全备份、失败原地不动 | 2 | 3 | 6 | 数据丢失=信任崩溃 |
| ASR-003 | SEC | BYO apiKey：密文存储、绝不进备份、发送范围透明 | 2 | 3 | 6 | 泄露/误发将严重伤害信任 |
| ASR-004 | BUS | Evidence-first：AI 回答/复盘必须引用证据，不足即不足 | 2 | 3 | 6 | 违背会导致“不信任” |
| ASR-005 | PERF | Today 体验（3 秒看清下一步）与写入优先（10 秒留痕） | 2 | 2 | 4 | 影响留存与“掌控感” |

## 3) Test Levels Strategy

参考测试层级选择原则（优先 Unit，边界用 Integration，关键闭环少量 E2E）：

- **Unit：60%**  
  - Domain 校验（6 位 PIN、状态机、排序/筛选、引用协议、AI 采用/撤销语义）
  - AI schema 解析与失败兜底（纯函数/解析器）
- **Integration：30%**  
  - Drift/SQLite 的 Repository 行为（CRUD、查询、FTS、迁移）
  - 备份加密/解密、恢复事务（文件 IO + 加密 + 版本）
  - 通知调度器/时间源抽象（通过 fake 实现验证边界）
- **E2E（移动端集成）：10%**  
  - 只覆盖最关键用户旅程：`任务 → 专注 → 收尾留痕 → 回填 → Today 统计` 与 `AI 拆任务 → 导入`
  - 工具建议：Flutter `integration_test`（Android Emulator）；若后续需要更强的黑盒操作可评估 Maestro（P1）

## 4) NFR Testing Approach（按类别定义可执行证据）

### Security（SEC）

- apiKey：验证仅存安全存储；导出/备份中不存在 apiKey；错误日志不泄露 key
- AI 发送范围：在 UI/UseCase 层对“发送哪些字段”做可测试的显式输入（snapshot/contract）

### Performance（PERF）

- Today 首屏可用性：以 widget/integration 测试测量“首帧/首个可交互区域”时间（基准 + 趋势）
- 搜索/索引：对 1k/10k 条数据的查询耗时做基准（本地 bench 或 integration）

### Reliability（OPS/TECH/DATA）

- endAt 恢复：模拟进程重启后恢复倒计时与当前任务上下文
- 通知可靠性：在 Emulator 上验证到点通知触发与点击回到收尾流程（结合仪表化测试）
- 恢复原子性：故意制造解密失败/校验失败，验证“原地不动”

### Maintainability（MAINT）

- 覆盖率与质量门槛：Domain/Data 层 ≥80%（起步目标），禁止高风险模块无测试
- 质量 DoD：禁止 hard waits、避免条件分支驱动测试流、保持测试短小可维护（见 test-quality checklist）

## 5) Test Environment Requirements

- Android Emulator（至少 2 个 API level）+ 真机回归（通知/后台/省电策略更接近真实）
- 可注入的抽象：`Clock`/`NotificationScheduler`/`FileSystem`/`AiClient`（便于 deterministic tests）
- 可重复的测试数据工厂：Task/Note/Session builders（避免随机导致 flaky）

## 6) Testability Concerns（Gate 关注点）

- **Critical（=9）**：Android 后台可靠提醒/恢复（ASR-001）必须在进入大规模功能开发前跑通验证链路（至少 P0 集成测试）
- **High（≥6）**：备份/恢复原子性、apiKey 与证据链信任边界需要先有自动化保障，否则后续返工成本高

## 7) Deliverables（Risk / Coverage / Execution / Gate）

### 7.1 Risk Assessment Matrix

| Risk ID | Category | Description | Probability | Impact | Score | Mitigation |
| --- | --- | --- | --- | --- | --- | --- |
| R-001 | OPS/TECH | 后台提醒/进程被杀恢复不可靠导致核心闭环失败 | 3 | 3 | 9 | endAt 持久化 + 通知调度抽象 + Emulator/真机矩阵测试 + 必要时前台服务 |
| R-002 | DATA | 恢复覆盖导致数据损坏/丢失 | 2 | 3 | 6 | 恢复前安全备份 + 校验通过才覆盖 + 事务化恢复 + 故障注入测试 |
| R-003 | SEC | apiKey 泄露或进入备份包 | 2 | 3 | 6 | secure storage + 导出/备份扫描 + 日志脱敏 + 单测/集成测试 |
| R-004 | BUS | AI 不带引用/编造导致用户不信任 | 2 | 3 | 6 | citations 强约束 + schema 校验 + “不足即不足”逻辑测试 |
| R-005 | PERF | Today 首屏慢导致“失控感” | 2 | 2 | 4 | 首屏骨架 + 延迟加载统计 + 性能基准测试 |

### 7.2 Coverage Matrix（系统级）

| Requirement/Capability | Test Level | Priority | Risk Link | Notes |
| --- | --- | --- | --- | --- |
| 任务 CRUD + 列表筛选/Quick Add | Unit + Integration + Widget | P0 | - | 领域规则 + Repository 行为 + UI 基本交互 |
| 任务 → 专注 → 收尾留痕 → 回填 | Integration + E2E | P0 | R-001 | 核心闭环，必须有端到端信心 |
| endAt 恢复（重启/重进） | Integration | P0 | R-001 | 以可注入 Clock + 持久化恢复验证 |
| 本地通知到点提醒 | E2E（仪表化） | P0 | R-001 | Emulator/真机回归 |
| 备份加密（6 位 PIN） | Integration | P0 | R-002 | 加密/解密/格式/版本 |
| 恢复原子性（失败原地不动） | Integration | P0 | R-002 | 故障注入（错误 PIN/损坏包） |
| AI 拆任务导入（可撤销） | Integration + Widget | P1 | R-004 | AiClient stub + Adopt/Undo 语义测试 |
| 问答检索 Evidence-first | Integration + Widget | P1 | R-004 | citations 必须可跳转；不足提示 |
| 周复盘“同周追加不覆盖” | Integration | P1 | R-004 | 笔记追加策略 |
| apiKey 不进备份 + 日志脱敏 | Unit + Integration | P0 | R-003 | 扫描导出内容与日志 |

### 7.3 Execution Order（建议）

**Smoke（<5min）**

- App 启动 + Today 可渲染
- 任务 CRUD（最小路径）

**P0（<10–20min，视设备/模拟器而定）**

- 任务 → 专注 → 收尾保存/稍后补 → 回填
- endAt 恢复（模拟重启）
- 备份加密 + 恢复失败原地不动

**P1（PR 合并前）**

- AI 拆任务导入（stub）
- 问答检索引用跳转（stub）
- 周复盘追加策略（stub）

### 7.4 Resource Estimates（粗略）

> 这里按 workflow 模板给出测试建设量级（用于排优先级，不代表交付周期承诺）。

- P0 场景：10 × 2h = 20h
- P1 场景：8 × 1h = 8h
- P2/P3 场景：20 × 0.5h = 10h
- **Total**：约 38h（~5 人日）

### 7.5 Quality Gate Criteria

- P0 通过率：100%
- P1 通过率：≥95%
- 高风险（≥6）项全部有自动化验证或明确 waiver（含 owner 与到期）
- Domain/Data 关键路径覆盖率目标：≥80%

## 8) Recommendations for Sprint 0

- 把 `Clock/NotificationScheduler/FileSystem/AiClient` 抽象为可注入依赖（提升可控性与可测性）
- 先跑通 **R-001**（后台提醒/恢复）与 **R-002**（备份/恢复原子性）的 P0 集成测试，再扩功能
- 建立最小 CI：`flutter analyze` + `flutter test`（后续再引入覆盖率门槛与集成测试跑法）

## Appendix（Reference）

- PRD: `_bmad-output/planning-artifacts/prd.md`
- Architecture: `_bmad-output/planning-artifacts/architecture.md`
- Epics: `_bmad-output/planning-artifacts/epics.md`

