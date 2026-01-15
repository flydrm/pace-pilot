---
stepsCompleted: [1, 2, 3, 4]
lastStep: 4
status: "complete"
completedAt: "2026-01-14T10:09:28+08:00"
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
date: "2026-01-14"
author: "User"
---

# pace-pilot - Epic Breakdown

## Overview

本文档把 PRD / UX / Architecture 中的需求，拆解成可实施的 Epics 与 User Stories，并确保每条 Story 都能映射回具体需求与验收标准。

## Requirements Inventory

### Functional Requirements

- FR1: 应用提供底部 5 个 Tab（顺序固定）：AI / 笔记 / 今天 / 任务 / 专注
- FR2: `今天` 为默认落点，视觉上比其它 Tab 更突出（用于强化“掌控工作台”心智）
- FR3: 全局右上角提供设置入口（不占 Tab），包含：AI 配置 / 番茄配置 / 数据 / 外观

- FR4: 用户可以创建任务（至少包含：标题、描述、状态、优先级、截止日期、标签、预计番茄数）
- FR5: 用户可以编辑任务字段并标记完成/未完成
- FR6: 任务列表支持筛选（状态/优先级/标签/到期/逾期）与排序
- FR7: 任务支持快速新增（Quick Add：输入一句话即可建任务）
- FR8: 任务详情页展示子任务/Checklist（P0 建议）并可编辑勾选
- FR9: 任务详情页展示关联番茄记录列表与关联笔记入口
- FR10: 从任务详情页可一键进入专注（开始番茄）

- FR11: 用户可以创建笔记（标题 + 正文，Markdown 或轻量富文本其一）
- FR12: 笔记列表按时间倒序展示并支持标签筛选
- FR13: 笔记可与某个任务关联（任务详情可查看相关笔记）

- FR14: 用户可开始番茄专注（开始/暂停/继续/放弃/结束）
- FR15: 开始番茄前必须选择任务（或创建新任务）
- FR16: 番茄计时在切后台/锁屏/重进 App 时不丢失，可从持久化状态恢复剩余时间与当前任务
- FR17: 番茄到点触发本地通知提醒（可配置震动等）
- FR18: 每个专注番茄结束必须产生一条“进展记录”（手写一行/稍后补/AI 生成）
- FR19: 番茄结束展示收尾 Sheet（非强制对话框）：保存 / 稍后补 / AI 生成（并可撤销）
- FR20: 应用统计：今日番茄数、每任务累计番茄数、今日最专注任务等

- FR21: AI 效率台提供“一句话拆任务”：输入一段话 → 生成任务清单草稿（可编辑）→ 一键导入 Todo（可撤销）
- FR22: AI 效率台提供“问答检索”：支持关键词/过滤（时间/标签/类型），默认近 7 天范围可见
- FR23: 问答检索回答必须附 2–5 条可跳转引用证据；证据不足必须明确提示“不足”，禁止编造
- FR24: AI 效率台提供“周复盘”：默认上周自然周 → 生成草稿+证据列表 → 用户编辑后保存为笔记
- FR25: 同一周重复生成周复盘只追加“新草稿段落”，禁止覆盖已编辑正文

- FR26: 笔记内提供 AI 动作：总结要点 / 提取行动项→生成任务（或子任务）/ 改写成对外同步版
- FR27: AI 生成结果必须走统一护栏：预览→编辑→采用/撤销；禁止静默覆盖用户输入
- FR28: AI 失败不阻塞主闭环：仍可新增任务、开始专注、手写保存/稍后补

- FR29: 设置页提供 AI Provider 配置：baseUrl/model/apiKey（OpenAI 协议兼容）并支持“测试连接”
- FR30: AI 调用需明确告知发送范围（用户选择）并可中途取消

- FR31: 应用支持导出全部数据为 JSON（任务/笔记/番茄记录/设置）
- FR32: 应用支持生成可阅读迁移的导出（Markdown：复盘/笔记等）
- FR33: 应用支持全量备份（ZIP：data/*.json + exports/*.md + media/）
- FR34: 备份 ZIP 必须加密，密码为恰好 6 位数字 PIN（允许 0 开头）；PIN 不保存不回填；备份不包含 apiKey
- FR35: 恢复流程必须在覆盖前自动生成“恢复前安全备份包”；校验通过才覆盖；失败必须“原地不动”
- FR36: 应用支持一键清空所有数据（含索引、缓存），并带二次确认/可撤销语义（按 UX 规范）

- FR37: 应用内提供隐私说明页（本地存储、AI 发送说明、清空能力、权限最小化）

### NonFunctional Requirements

- NFR1: Local-first / Offline-first：无登录，核心功能离线可用
- NFR2: 信任边界：AI 仅在用户明确触发时工作；所有 AI 写入需预览→采用，默认不打扰
- NFR3: Evidence-first：AI 问答/复盘必须引用本地证据；不足即不足
- NFR4: 性能体验：围绕 3-2-10 闭环优化（Today 快速可用、专注启动低摩擦、收尾写入优先）
- NFR5: 可靠性：计时与通知稳定；被杀/重启后可恢复（以 endAt 等持久状态为准）
- NFR6: 安全：apiKey 本地密文存储（Keystore/Keychain）；备份强加密；恢复原子性
- NFR7: 风格：安静、商务、稳重；专注期“安静驾驶舱”不打扰
- NFR8: 可维护性：按 `app/` + `packages/*` 分层，避免 UI 直连 DB/加密等底层能力

### Additional Requirements

- 技术启动要求：首条实现 Story 必须包含脚手架初始化（`flutter create app ...`）与 `app/` + `packages/*` 结构落地
- 技术选型与版本（来自 Architecture）：Drift/SQLite、Riverpod、go_router、dio、flutter_secure_storage、flutter_local_notifications 等
- 证据引用协议（来自 Architecture）：AI 输出必须附 citations（evidenceId），并可跳转到 Task/Note/Session
- 数据导出/备份格式要求（来自 Architecture）：`schemaVersion`、UTC epoch ms 时间、snake_case 字段
- 一次性弱提示（来自 UX）：按风险类型首次触发；本地持久化 hintKey；避免重复打扰
- 关闭语义（来自 UX）：FocusWrapUpSheet 允许“关闭=稍后补”，其余 Sheet/对话框关闭=取消且不写入/不发送

### FR Coverage Map

### FR Coverage Map

- FR1: Epic 1 - 底部 5 Tab 与基础导航壳
- FR2: Epic 1 - Today 默认落点与视觉强化
- FR3: Epic 1 - 全局设置入口（右上角）
- FR4: Epic 1 - 任务创建
- FR5: Epic 1 - 任务编辑/完成/未完成
- FR6: Epic 1 - 任务列表筛选与排序
- FR7: Epic 1 - Quick Add 快速新增
- FR8: Epic 1 - 子任务/Checklist（任务侧）
- FR9: Epic 1 - 任务详情聚合（番茄记录/笔记入口）
- FR10: Epic 1 - 从任务详情进入专注
- FR11: Epic 3 - 笔记创建（标题+正文）
- FR12: Epic 3 - 笔记列表与标签筛选
- FR13: Epic 3 - 笔记与任务关联
- FR14: Epic 2 - 番茄专注（开始/暂停/继续/放弃/结束）
- FR15: Epic 2 - 开始番茄前必须选任务
- FR16: Epic 2 - 后台/重启恢复计时状态
- FR17: Epic 2 - 本地通知提醒
- FR18: Epic 2 - 结束必须留痕（进展记录）
- FR19: Epic 2 - 收尾 Sheet（保存/稍后补/AI 生成）
- FR20: Epic 2 - 专注统计
- FR21: Epic 4 - 一句话拆任务（可编辑+导入+可撤销）
- FR22: Epic 4 - 问答检索（关键词/过滤/默认近 7 天）
- FR23: Epic 4 - Evidence-first 引用可跳转/不足提示
- FR24: Epic 4 - 周复盘生成并保存为笔记
- FR25: Epic 4 - 同周复盘追加不覆盖
- FR26: Epic 4 - 笔记内 AI 动作（总结/提取行动项/改写）
- FR27: Epic 4 - AI 护栏（预览→编辑→采用/撤销）
- FR28: Epic 4 - AI 失败不阻塞主闭环
- FR29: Epic 4 - AI Provider 配置与测试连接
- FR30: Epic 4 - AI 发送范围透明与可取消
- FR31: Epic 5 - 导出 JSON（全量）
- FR32: Epic 5 - 导出 Markdown（可阅读迁移）
- FR33: Epic 5 - 全量备份 ZIP（data/exports/media）
- FR34: Epic 5 - 备份加密（6 位 PIN）与不包含 apiKey
- FR35: Epic 5 - 恢复原子性（恢复前安全备份/失败不动）
- FR36: Epic 5 - 一键清空（确认/撤销语义）
- FR37: Epic 5 - 隐私说明页

## Epic List

### Epic 1: 任务掌控（基础导航 + Today 工作台 + Todo）

用户可以在一个“安静、清晰、专业”的壳里快速把事情放进任务系统，并在 Today 页看到下一步与今天队列，从而形成可执行的日常节奏。

**FRs covered:** FR1–FR10

### Epic 2: 专注番茄闭环（可靠计时 + 留痕回填）

用户可以选择任务开始专注，后台到点提醒可靠；结束后用 10 秒留痕（手写/稍后补/AI 草稿）并回填任务进展，形成“做了什么”的可回顾记录。

**FRs covered:** FR14–FR20

### Epic 3: 笔记与关联（工作笔记沉淀）

用户可以快速记录工作笔记、用标签管理，并将笔记与任务关联，形成可被检索与复盘的“工作资料库”。

**FRs covered:** FR11–FR13

### Epic 4: AI 效率台（拆任务 / 问答检索 / 周复盘）

用户在不被打扰、且完全可控的前提下，使用 AI 把输入变清楚（拆任务）、把信息找出来（问答检索 Evidence-first）、把产出沉淀下来（周复盘保存为笔记）。

**FRs covered:** FR21–FR30

### Epic 5: 数据掌控与隐私（导出/备份/恢复/清空）

用户在无登录场景下仍对数据拥有掌控：可导出、可备份恢复（强加密与原子恢复）、可清空；并能在隐私说明页清楚理解数据与 AI 的边界。

**FRs covered:** FR31–FR37

## Epic 1: 任务掌控（基础导航 + Today 工作台 + Todo）

用户可以在一个“安静、清晰、专业”的壳里快速把事情放进任务系统，并在 Today 页看到下一步与今天队列，从而形成可执行的日常节奏。

### Story 1.1: 使用 Starter 初始化工程 + App 启动壳与底部 5 Tab 导航

As a 个人用户（知识工作者），
I want 打开应用后立即看到 Today，并能在 5 个 Tab 间切换，
So that 我能快速进入“掌控工作台”，不被复杂设置打扰。

**FRs covered:** FR1, FR2, FR3

**Acceptance Criteria:**

**Given** 我在一个空目录准备开始 pace-pilot
**When** 我按架构文档执行 `flutter create app --project-name pace_pilot --org com.example --platforms=android --android-language kotlin`
**Then** 生成 `app/` 工程并可成功运行到模拟器/真机
**And** 初次运行即可进入下述导航壳验收

**Given** 我首次打开应用（无任何数据）
**When** 应用启动完成
**Then** 默认进入 `今天` Tab
**And** 底部导航按顺序显示：AI / 笔记 / 今天 / 任务 / 专注
**And** 每个 Tab 均可点击进入对应页面（可先为占位内容）
**And** 每个页面右上角存在“设置”入口（不占 Tab）

### Story 1.2: 任务创建与编辑（最小字段集）

As a 个人用户（知识工作者），
I want 用最少的输入创建并编辑任务，
So that 我能把脑中的事项变成可执行条目。

**FRs covered:** FR4, FR5

**Acceptance Criteria:**

**Given** 我在 `任务` 页
**When** 我通过“新增任务”创建任务并填写标题（必填）
**Then** 任务被保存到本地并出现在任务列表中
**And** 我可以编辑任务的描述/优先级/截止日期/标签/预计番茄数并保存
**And** 标题为空时禁止保存并给出明确提示

### Story 1.3: 任务列表（筛选、排序、Quick Add）

As a 个人用户（知识工作者），
I want 在任务列表快速新增并按条件筛选查看，
So that 我能随时找到“下一步要做什么”。

**FRs covered:** FR6, FR7

**Acceptance Criteria:**

**Given** 我在 `任务` 页且已存在多条任务（含不同优先级/截止日期/状态）
**When** 我使用 Quick Add 输入一句话并提交
**Then** 系统创建一条新任务并出现在列表顶部/合理位置
**And** 我可以按状态/优先级/标签/今天到期/已逾期筛选
**And** 默认列表展示未完成任务并按优先级+截止日期进行排序（规则在 UI 中可解释）

### Story 1.4: 任务详情（Checklist、关联入口、开始专注入口）

As a 个人用户（知识工作者），
I want 在任务详情里把任务变得更可执行，并能开始专注，
So that 我能从“知道要做”快速进入“正在做”。

**FRs covered:** FR8, FR9, FR10

**Acceptance Criteria:**

**Given** 我打开某个任务的详情页
**When** 我添加/勾选/取消勾选子任务 Checklist
**Then** Checklist 状态被保存并在再次进入时保持一致
**And** 详情页展示“关联笔记”“番茄记录”入口（可先为空态）
**And** 详情页存在“开始专注”按钮，点击可进入 `专注` 页面并带上当前任务上下文（即使计时功能尚未完成，也应至少完成导航与展示任务名）

### Story 1.5: Today 工作台（下一步 + 今天队列 + 昨天回顾骨架）

As a 个人用户（知识工作者），
I want 在 Today 一眼看到下一步与今天队列，
So that 我能在 3 秒内决定现在做什么。

**FRs covered:** FR2

**Acceptance Criteria:**

**Given** 我打开 `今天` 页
**When** 页面加载完成
**Then** 页面至少包含三个区域：`下一步`、`今天队列`、`昨天回顾（折叠）`
**And** 当无数据时分别呈现清晰空态与下一步指引（例如“去添加任务/开始专注”）
**And** 当存在任务时，`今天队列`能展示一组任务条目（来源规则可先为 MVP：手动加入或按到期/优先级挑选）

## Epic 2: 专注番茄闭环（可靠计时 + 留痕回填）

用户可以选择任务开始专注，后台到点提醒可靠；结束后用 10 秒留痕（手写/稍后补/AI 草稿）并回填任务进展，形成“做了什么”的可回顾记录。

### Story 2.1: 选择任务开始专注（番茄配置可用）

As a 个人用户（知识工作者），
I want 在开始专注前明确要做的任务，并使用番茄配置开始计时，
So that 我的专注是有目标的且节奏一致。

**FRs covered:** FR14, FR15

**Acceptance Criteria:**

**Given** 我进入 `专注` 页
**When** 当前没有选中任务且我点击“开始”
**Then** 系统要求我选择一个任务或创建新任务后才能开始计时
**And** 专注时长默认 25 分钟（可在设置中修改）

### Story 2.2: 番茄计时（开始/暂停/继续/结束）与 endAt 持久化

As a 个人用户（知识工作者），
I want 番茄计时在切后台/重进 App 后仍准确，
So that 我不担心“失控/丢计时”。

**FRs covered:** FR14, FR16

**Acceptance Criteria:**

**Given** 我已选择任务并开始了一个番茄
**When** 我暂停并继续
**Then** 倒计时正确暂停/继续且显示剩余时间
**And** 系统将关键状态持久化（至少包含 endAt 与当前任务 id）
**When** 我杀掉应用并重新打开
**Then** 应用能从持久化状态恢复当前番茄并显示正确剩余时间（允许存在 <1 分钟误差容忍阈值需在实现中定义）

### Story 2.3: 到点本地通知提醒（Android First）

As a 个人用户（知识工作者），
I want 番茄到点时收到可靠的本地通知提醒，
So that 即使我切后台也不会错过结束点。

**FRs covered:** FR17

**Acceptance Criteria:**

**Given** 我已开始番茄并切到后台
**When** 番茄到点
**Then** 我收到本地通知提醒（包含任务名/专注结束提示）
**And** 点击通知可回到应用并进入专注收尾流程

### Story 2.4: 专注收尾 Sheet（保存 / 稍后补）

As a 个人用户（知识工作者），
I want 在番茄结束后用极低摩擦记录进展，
So that 我能形成可回顾的工作痕迹。

**FRs covered:** FR18, FR19

**Acceptance Criteria:**

**Given** 我的番茄到点并回到应用
**When** 收尾 Sheet 出现
**Then** 我可以输入一句话进展并点击“保存”，系统将其写入番茄记录并回填到任务（例如更新已消耗番茄数/最近进展）
**And** 我可以点击“稍后补”，系统会生成“进展草稿占位”但不阻塞我继续使用（并提供撤销入口）
**And** 除 FocusWrapUpSheet 外，其它关闭行为默认视为取消且不写入（按 UX 规范）

### Story 2.5: 专注统计（今日/任务累计）

As a 个人用户（知识工作者），
I want 看见我今天与各任务的专注投入，
So that 我更有成就感并能调整节奏。

**FRs covered:** FR20, FR9

**Acceptance Criteria:**

**Given** 我已完成若干番茄
**When** 我查看 Today 或任务详情
**Then** 我能看到今日番茄数统计
**And** 在任务详情可看到该任务累计番茄数与番茄记录列表

## Epic 3: 笔记与关联（工作笔记沉淀）

用户可以快速记录工作笔记、用标签管理，并将笔记与任务关联，形成可被检索与复盘的“工作资料库”。

### Story 3.1: 笔记创建/编辑/查看（Markdown 或轻量富文本）

As a 个人用户（知识工作者），
I want 快速记录与编辑笔记，
So that 我能沉淀工作过程与信息。

**FRs covered:** FR11

**Acceptance Criteria:**

**Given** 我在 `笔记` 页
**When** 我创建一条笔记并填写标题与正文
**Then** 笔记被保存到本地并出现在笔记列表中
**And** 我可以打开笔记详情并编辑后保存

### Story 3.2: 笔记列表与标签筛选

As a 个人用户（知识工作者），
I want 通过标签快速筛选笔记，
So that 我能更快找到相关信息。

**FRs covered:** FR12

**Acceptance Criteria:**

**Given** 我已创建多条笔记并设置了不同标签
**When** 我在笔记列表选择某个标签筛选
**Then** 列表仅展示匹配标签的笔记
**And** 取消筛选后恢复展示全部笔记（按时间倒序）

### Story 3.3: 任务与笔记关联展示

As a 个人用户（知识工作者），
I want 将笔记绑定到任务并在任务详情查看，
So that 我的任务上下文更完整。

**FRs covered:** FR13, FR9

**Acceptance Criteria:**

**Given** 我在某个任务详情页
**When** 我选择关联一条（或多条）笔记
**Then** 任务详情页能展示关联笔记列表并可跳转到笔记详情
**And** 在笔记详情也能看到其绑定的任务引用（可跳转）

## Epic 4: AI 效率台（拆任务 / 问答检索 / 周复盘）

用户在不被打扰、且完全可控的前提下，使用 AI 把输入变清楚（拆任务）、把信息找出来（问答检索 Evidence-first）、把产出沉淀下来（周复盘保存为笔记）。

### Story 4.1: AI Provider 配置与测试连接（BYO Key）

As a 个人用户（知识工作者），
I want 配置 baseUrl/model/apiKey 并测试连接，
So that 我能确认 AI 能用且失败原因清晰。

**FRs covered:** FR29, FR30

**Acceptance Criteria:**

**Given** 我进入“设置 → AI”
**When** 我填写 baseUrl/model/apiKey 并点击“测试连接”
**Then** 系统发起最小请求并返回成功/失败结果
**And** 失败时显示可读原因（例如 401/429/网络不可达）与下一步建议
**And** apiKey 必须以安全存储方式保存，且不进入备份包

### Story 4.2: 一句话拆任务（预览→编辑→导入→撤销）

As a 个人用户（知识工作者），
I want 把一段混乱输入拆成可执行任务清单，
So that 我能更快进入执行。

**FRs covered:** FR21, FR27, FR28

**Acceptance Criteria:**

**Given** 我在 AI 效率台进入“一句话拆任务”
**When** 我输入一段文字并点击生成
**Then** 系统展示任务清单草稿（可编辑标题/描述/预计番茄/标签等）
**And** 我点击“导入到任务”后生成多条本地任务
**And** 导入后提供撤销入口，撤销将回滚本次导入创建的任务
**And** AI 失败时允许我仍然手动把文本保存为笔记或复制，不阻塞其它操作

### Story 4.3: 问答检索（Evidence-first + 引用可跳转）

As a 个人用户（知识工作者），
I want 对最近工作问一句并拿到带引用的答案，
So that 我能快速回忆并可信地复盘。

**FRs covered:** FR22, FR23

**Acceptance Criteria:**

**Given** 我进入 AI 效率台“问答检索”
**When** 我输入问题且不修改范围
**Then** 默认范围为近 7 天（在 UI 中可见）并据此检索本地证据
**And** AI 输出的回答必须包含 2–5 条引用证据，点击可跳转到对应任务/笔记/番茄记录片段
**And** 当证据不足时，回答必须明确“不足/不确定”，并提示我缩小范围或补充线索

### Story 4.4: 周复盘（草稿+证据 → 保存为笔记；同周追加）

As a 个人用户（知识工作者），
I want 一键生成上周复盘草稿并保存为笔记，
So that 我能形成可回看的工作日志。

**FRs covered:** FR24, FR25

**Acceptance Criteria:**

**Given** 我进入 AI 效率台“周复盘”
**When** 我点击生成（默认上周自然周）
**Then** 系统生成复盘草稿正文与证据列表（可跳转）
**And** 我可以编辑后保存为一篇笔记
**When** 我对同一周再次生成
**Then** 系统只追加“新草稿段落”到同一篇周复盘笔记中，禁止覆盖已编辑正文

### Story 4.5: 笔记内 AI 动作（总结 / 提取行动项）

As a 个人用户（知识工作者），
I want 在笔记里一键总结与提取行动项并转成任务，
So that 我能把信息快速转化为下一步行动。

**FRs covered:** FR26, FR21, FR27

**Acceptance Criteria:**

**Given** 我打开一条笔记详情
**When** 我点击“总结要点”
**Then** 系统生成可编辑总结草稿并允许我采用/撤销
**When** 我点击“提取行动项”
**Then** 系统生成可编辑行动项清单并允许我批量导入为任务（可撤销）

## Epic 5: 数据掌控与隐私（导出/备份/恢复/清空）

用户在无登录场景下仍对数据拥有掌控：可导出、可备份恢复（强加密与原子恢复）、可清空；并能在隐私说明页清楚理解数据与 AI 的边界。

### Story 5.1: 导出全量数据为 JSON

As a 个人用户（知识工作者），
I want 导出我的全部数据为 JSON 文件，
So that 我能迁移/备份并感到数据可控。

**FRs covered:** FR31

**Acceptance Criteria:**

**Given** 我在“设置 → 数据”
**When** 我点击“导出 JSON”
**Then** 系统生成包含任务/笔记/番茄记录/设置的导出文件
**And** 导出文件包含 `schemaVersion` 与 `exportedAt` 等元数据
**And** 导出完成后可通过系统分享/保存到文件系统

### Story 5.2: 导出 Markdown（可阅读迁移）

As a 个人用户（知识工作者），
I want 导出可阅读的 Markdown（笔记/复盘等），
So that 即使不恢复 App 也能查看与迁移我的工作记录。

**FRs covered:** FR32

**Acceptance Criteria:**

**Given** 我在“设置 → 数据”
**When** 我点击“导出 Markdown”
**Then** 系统生成可阅读的 Markdown 导出（至少包含：笔记正文、周复盘正文、引用证据的可读形式）
**And** 导出文件包含 `schemaVersion` 与 `exportedAt` 等元数据（或在导出包清单中体现版本）
**And** 导出完成后可通过系统分享/保存到文件系统

### Story 5.3: 全量备份 ZIP（强加密，6 位 PIN）

As a 个人用户（知识工作者），
I want 一键生成加密备份包，
So that 我能安全地在无登录条件下迁移数据。

**FRs covered:** FR33, FR34

**Acceptance Criteria:**

**Given** 我在“设置 → 数据”点击“备份”
**When** 我输入 6 位数字 PIN 并确认
**Then** 系统生成加密 ZIP 备份包（包含 data/*.json + exports/*.md + media/）
**And** PIN 必须恰好 6 位数字（允许 0 开头）；PIN 不保存不回填
**And** 备份包不得包含 apiKey

### Story 5.4: 恢复准备（选择备份 + 校验 + 恢复前安全备份）

As a 个人用户（知识工作者），
I want 在真正覆盖数据前完成校验并生成安全备份，
So that 恢复流程在任何失败场景下都不会让我“失控”。

**FRs covered:** FR35

**Acceptance Criteria:**

**Given** 我在“设置 → 数据”点击“恢复备份”
**When** 我选择了一个备份包并输入 6 位 PIN
**Then** 系统校验备份包与 PIN（例如：解密成功、清单可读、schemaVersion 可解析）
**And** 只有校验通过后，系统才会生成“恢复前安全备份包”
**And** “安全备份包”生成成功后，系统才允许我进入下一步“执行恢复”的确认页/确认弹窗
**And** 如果校验失败或安全备份生成失败，系统不得写入任何数据变更（原地不动），并提示原因与下一步建议

### Story 5.5: 执行恢复（原子覆盖 + 摘要 + 失败回滚）

As a 个人用户（知识工作者），
I want 执行恢复时保证原子性并在失败时回滚，
So that 我能放心使用恢复功能而不担心数据损坏。

**FRs covered:** FR35

**Acceptance Criteria:**

**Given** 我已完成备份包校验且已生成“恢复前安全备份包”
**When** 我确认执行恢复
**Then** 系统以原子方式覆盖当前数据（例如：先写入临时目录/临时数据库并校验，通过后再切换）
**And** 若任一步骤失败，现有数据必须保持不变（原地不动），并提示失败原因
**And** 恢复完成后提示恢复摘要（任务/笔记/番茄记录等数量）与恢复完成时间

### Story 5.6: 一键清空与隐私说明页

As a 个人用户（知识工作者），
I want 清晰地理解隐私边界并能一键清空数据，
So that 我能长期信任并持续使用这款应用。

**FRs covered:** FR36, FR37

**Acceptance Criteria:**

**Given** 我进入隐私说明页
**When** 我阅读说明
**Then** 页面明确：默认本地存储、AI 调用发送范围与 baseUrl、可随时清空数据、权限最小化
**Given** 我在“设置 → 数据”点击“一键清空”
**When** 我确认清空
**Then** 系统清空任务/笔记/番茄记录/索引/缓存并提示完成
**And** 清空属于高风险操作，必须具备二次确认与清晰后果说明（按 UX 规范）
