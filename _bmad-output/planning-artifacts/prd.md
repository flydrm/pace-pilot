

# PRD：PacePilot — AI Todo & Pomodoro（No-Login / Android First）

## 0. 文档信息

* 产品形态：移动端 App（Android 优先），后续 iOS / PC
* 登录体系：**无登录/无账号**
* 数据策略：**Local-first / Offline-first**
* MVP 版本目标：把「任务 → 专注执行 → AI 辅助总结复盘（用户触发）」打穿

> Local-first 强调：可离线工作、用户数据所有权、更好的隐私与长期可保存性。([Ink & Switch][1])

---

## 1. 目标与非目标

### 1.1 产品目标（MVP）

1. 用 TodoList 管住“要做什么”，并能快速变清晰（AI 结构化）
2. 用番茄钟管住“现在做什么”，并与任务强绑定（每个番茄都有产出记录）
3. 让 AI 真正改变日常：

   * 一句话拆分任务、改写成 Next Action（你触发、可编辑）
   * 生成今日计划草稿（番茄分配，可编辑）
   * 番茄结束：一键生成进展与下一步（预览→采用/撤销）
   * 周复盘：一键生成可回顾工作日志草稿（带引用证据）
4. 支持 **OpenAI 协议兼容**的模型配置（baseUrl/model/apiKey），可接 OpenAI 或其它兼容服务
5. 无登录前提下，提供 **导出/备份/清空**，让用户对数据有掌控

### 1.2 非目标（MVP 不做）

* ❌ 统一收件箱/邮件聚合/类似 Inbox 的内容收拢（你已明确不做）
* ❌ 多人协作、云端同步、团队空间
* ❌ 重项目管理（看板、甘特、审批）
* ❌ 深度第三方集成（Jira/Notion/Slack 双向同步）

---

## 2. 用户与核心场景

### 2.1 目标用户

* 知识工作者、AI 行业从业者、产品/研发/运营
* 对隐私敏感，不愿登录，不想把工作内容交给 SaaS 云端
* 需要“任务清晰化 + 专注执行节奏 + 复盘可被 AI 加速（不打扰）”

### 2.2 MVP 必须打穿的 4 个场景

1. **脑暴输入 → AI 拆解 → Todo 清单可执行**
2. **选择任务 → 开番茄 → 专注不中断（后台可靠提醒）**
3. **番茄结束 → 10 秒留痕（手写/AI 建议）→ 回填任务**
4. **问答检索/周复盘 → 引用证据可跳转 → 保存为笔记**

---

## 3. 功能范围与优先级（P0 = MVP 必备）

> 说明：这里按你要求的结构保留“原 P0-2 ~ P0-8”，并新增/强化 TodoList、番茄钟、OpenAI 协议兼容配置。

## P0-2 AI 自动整理流水线（从“输入”到“可执行/可回顾”）

虽然不做 Inbox，但仍保留“把事情变清楚”的流水线——触发点改为：**用户明确点击的 AI 动作（拆任务/总结/问答检索/周复盘）**，以及 **番茄结束 Sheet 中选择“AI 生成”**（可选）。

**AI 流水线输出（P0）**

* 自动生成：一句话摘要 / 要点（用于任务描述或笔记摘要）
* 自动提取：行动项（可一键转子任务/Checklist）
* 自动建议：优先级、预计番茄数、可选截止日期（可让用户确认）
* 自动归档：建议标签（项目/客户/主题）

**原则**

* AI 默认“建议”，用户点“采用”才落地；不要强行改动用户原文
* AI 输出必须预览→编辑→采用/撤销；禁止静默覆盖用户输入
* AI 失败不阻塞主闭环：仍可新增任务、开始专注、手写保存/稍后补

---

## P0-3 Notes（工作笔记）

MVP 笔记重点不是花哨编辑器，而是：**可被 AI 处理与检索复用**。

**功能点（P0）**

* 笔记列表：按时间倒序 + 支持标签筛选
* 笔记详情：标题、正文（轻量富文本或 Markdown 二选一）
* 笔记关联：可绑定到某个任务（任务详情页可查看相关笔记）
* AI 动作条（同屏快捷按钮）：

  * “总结要点”
  * “提取行动项 → 生成任务/子任务”
  * “改写成对外同步版”

---

## P0-4 TodoList（任务系统）

> 这是你新增强调的能力点之一，同时也是后续番茄绑定与 AI 闭环的核心对象。

### 任务字段（P0 最小集合）

* 标题（必填）
* 描述（可选）
* 状态：待办 / 进行中 / 已完成
* 优先级：高/中/低（或 P0/P1/P2）
* 截止日期（可选）
* 标签（可选，支持多选）
* 预计番茄数（可选，AI 可建议）
* 已消耗番茄数（自动统计）
* 创建/更新时间

### 任务列表（P0）

* 默认视图：未完成（按优先级、截止日期排序）
* 筛选：状态 / 优先级 / 标签 / 今天到期 / 已逾期
* 快速新增：顶部 Quick Add（输入一句话即可建任务）
* AI 快捷入口：

  * “把这段话拆成任务清单”（从 Quick Add 入口进入）

### 任务详情（P0）

* 编辑字段
* 子任务/Checklist（可选但建议 P0 做：提升“可执行性”）
* 关联番茄记录列表（每个番茄一条进展）
* “开始专注”按钮（直达番茄）

---

## P0-5 问答检索（Ask My Work / Evidence-first）

即使无 Inbox，你们仍然能把任务与笔记变成“个人工作知识库”。

**能力（P0）**

* 全局搜索：关键词 + 结构化过滤（时间/标签/类型）；语义搜索（embedding）可作为 P1 增强
* 问答：回答必须展示引用来源（点击跳转到对应任务/笔记/番茄记录片段）
* 过滤范围：仅搜某标签/某时间段/仅搜任务或仅搜笔记
* 默认范围：近 7 天（必须可见）
* 证据不足：必须明确“不足”，禁止编造

> 这里强烈建议“引用证据”，避免模型胡编造成不信任（尤其是工作内容）。

---

## P0-6 日/周复盘（Daily/Weekly Review）

**目标：每天少花 10–20 分钟整理，形成“可回看的工作日志”，但不被 AI/提醒打扰。**

**Daily Digest（P0）**

* 今日完成了哪些任务/番茄
* 今日关键产出（从番茄总结与笔记摘要抽取）
* 明日建议（按截止日期、优先级、预计番茄数给出排序建议）

**触发与产物（MVP 规则）**

* 不做定时后台生成，不做强提醒；复盘/总结仅在用户明确触发时生成草稿
* 日层面：以 `今天`页的“昨天回顾（折叠）/总结昨天（可选 AI）”承载
* 周层面：在 `AI 效率台 → 周复盘` 生成草稿 + 证据列表 → 用户编辑后保存为笔记（默认每周新建一篇）
* 同一周重复生成：写入同一篇作为“新草稿段落”，禁止覆盖已编辑正文
* （可选 P1）若用户主动开启“定时生成草稿”，可用 Android WorkManager/定时任务实现可靠调度。([Android Developers][2])

---

## P0-7 数据掌控（导出/备份/清空）

无登录产品最重要的信任来源之一就是“数据可迁移”。

**能力（P0）**

* 导出全部数据：JSON（任务、笔记、番茄记录、设置）
* 单独导出：任务清单 / 笔记 / 复盘
* 本地备份文件（可分享至网盘/本地文件系统），支持**恢复**
* 一键清空所有数据（含索引、缓存）

**备份/恢复（MVP 细则）**

* 备份包：ZIP（`data/*.json` 可恢复 + `exports/*.md` 可阅读迁移 + `media/` 附件）
* 加密：备份 ZIP 加密；密码为 **恰好 6 位数字 PIN（允许 0 开头）**；PIN 不保存、不回填；备份不包含 apiKey
* 恢复：恢复前自动生成“安全备份包”；校验通过才覆盖；失败必须“原地不动”不改现有数据；完成后提示恢复数量摘要

---

## P0-8 隐私与合规最小集

### 应用内（P0）

* 隐私说明页：

  * 默认本地存储
  * AI 调用会把用户选择发送给其配置的 `baseUrl`
  * 用户可随时清空本地数据
* 权限最小化：通知权限（番茄提醒必需），其它按需申请
* AI 透明：发送范围必须可见；问答/复盘必须引用可跳转；证据不足明确提示“不足”

### 上架（即使 MVP 先 Android，也要留好口径）

* Google Play：需要在 Play Console 填写 Data safety 表单并声明数据处理方式。([Google Help][3])
* iOS 后续上架：App Store 会展示 App Privacy Details，你需要在 App Store Connect 提供隐私实践信息（含第三方 SDK）。([Apple Developer][4])

---

# 新增 P0：番茄时钟（Pomodoro）

## P0-9 番茄时钟（与任务强绑定）

### 配置（P0）

* 专注：默认 25 分钟
* 短休息：默认 5 分钟
* 长休息：默认 15 分钟
* 每 N 个专注进入长休息：默认 4
* 可选：是否自动开始下一段（MVP 可先不做自动，降低边界问题）

### 计时能力（P0）

* 开始 / 暂停 / 继续 / 放弃
* 后台可靠提醒：到点通知 + 震动（可配置）
* 锁屏/切后台不丢状态：重进 App 能恢复剩余时间与当前任务

### 任务绑定（P0，关键）

* 开始番茄前必须选择任务（或创建新任务）
* 每个专注番茄结束必须落一条“进展记录”（可手写一行，也可 AI 自动生成）
* 统计：

  * 今日番茄数
  * 每个任务累计番茄数
  * 今日最专注任务（番茄最多）

### Android 后台实现建议（Flutter 同样适用，写入 PRD 便于研发不踩坑）

* 计时属于“对用户可感知的持续操作”，Android 官方定义这类适合用前台服务（Foreground Service），并且必须展示状态栏通知。([Android Developers][5])
* 同时注意 Google Play 对前台服务类型/声明有额外要求（尤其新系统版本），上架前需要检查并在 Play Console 做对应声明。([Google Help][6])

> MVP 工程实现可以采取“存 endAt 时间戳 + Alarm/通知 + 必要时前台服务”的组合，以达到可靠与省电的平衡；PRD 层面要求的是体验结果：后台也能准时提醒、状态可恢复。

---

# 新增 P0：AI 模型配置（OpenAI 协议兼容）

## P0-10 AI Provider 配置（baseUrl + model + apiKey）

### 设置项（P0）

在【设置 → AI】提供：

* `baseUrl`（必填；默认 `https://api.openai.com/v1`）
* `model`（必填；例如 `gpt-4o` / `o3` 或用户私有部署模型名）
* `apiKey`（必填；密文存储；可一键粘贴）

### OpenAI 协议兼容范围（MVP）

MVP 优先实现 **Chat Completions**（兼容面广），并预留后续 **Responses API** 的扩展接口。

* Chat Completions 创建接口（OpenAI 官方）：
  `POST https://api.openai.com/v1/chat/completions` ([OpenAI Platform][7])
* OpenAI 也提示新项目可考虑 Responses（后续可加）：([OpenAI Platform][8])

### 请求规范（P0）

* 鉴权：HTTP Bearer（`Authorization: Bearer ...`）
  OpenAI 官方说明 API key 用于鉴权且应通过 Bearer 方式提供。([OpenAI Platform][9])

### 连接测试（P0 必做）

按钮：【测试连接】

* 发起最小 Chat Completions 请求（简短 prompt）
* 返回：成功/失败 + 错误码 + 可读建议
* 错误码参考：OpenAI 官方 error codes 指南（例如 401 无效鉴权）。([OpenAI Platform][10])

### 结构化输出（强烈建议 P0 做，提升稳定性）

任务拆分、今日计划、番茄总结等，输出要求可解析的结构（JSON Schema / structured outputs）。
OpenAI 官方提供 Structured Outputs 指南，支持用 `json_schema` 或 function calling 约束结构化输出。([OpenAI Platform][11])

---

## 4. 信息架构（MVP）

底部固定 5 个 Tab（顺序固定）：

1. **AI**（效率台：拆任务 / 问答检索（带引用）/ 周复盘）
2. **笔记**（Notes）
3. **今天**（默认落点：下一步专注 + 今天队列 + 昨天回顾）
4. **任务**（Todo）
5. **专注**（Pomodoro）

设置入口：右上角全局入口（不占 Tab）——包含：AI 配置 / 番茄配置 / 数据（导出/备份/恢复/清空）/ 外观（Accent A/B/C、深浅）。

说明：

* `今天` Tab 视觉稍大，强化“掌控工作台”的心智。
* `AI` 不做聊天首页，采用“动作优先”的效率台；问答检索默认入口在 `AI`，也可在 `任务/笔记`提供“在此范围问一句”的轻入口（非长对话）。

---

## 5. 关键交互流程（MVP 验收按这个走）

### 流程 A：脑暴 → AI 拆任务 → 导入 Todo

1. AI 效率台点击【一句话拆任务】（或 Today 顶部快速入口）
2. 输入一段话（混乱也行）
3. AI 输出任务列表（可编辑）
4. 一键导入 → 生成多条任务 +（可选）标签/优先级/预计番茄
5. 可选：勾选“加入今天” → 直接进入 Today 队列

### 流程 B：选任务 → 开番茄 → 结束回填

1. 任务详情点击【开始专注】
2. 进入番茄页计时（顶部显示任务名）
3. 到点通知 → 回到 App
4. 出现收尾 Sheet（非强制对话框）：

   * 用户填一句话并点【保存】
   * 或点【稍后补】（生成“进展草稿占位”，不打扰）
   * 或点【AI 生成】（展示发送范围 → 生成建议稿 → 预览/编辑 → 采用/撤销）
5. 写入进展记录（或草稿占位）+ 回填任务 + 今日统计更新

### 流程 C：问答检索（带引用）

1. AI 效率台点击【问答检索】
2. 默认范围“近 7 天”，可切换范围/标签/任务或笔记
3. AI 输出回答草稿 + 2–5 条引用证据（可跳转）
4. 证据不足必须明确提示“不足”，并建议用户缩小范围或补充线索

### 流程 D：周复盘（保存为笔记）

1. AI 效率台点击【周复盘】（默认上周自然周）
2. 生成“工作日志草稿”+ 证据列表（可跳转）
3. 用户编辑后【保存为笔记】（默认每周新建一篇）

---

## 6. 数据模型（MVP）

### Task

* id（UUID）
* title
* description
* status
* priority
* dueAt（nullable）
* tags（list）
* estimatePomos（nullable）
* spentPomos（int，或从 session 聚合）
* createdAt / updatedAt

### PomodoroSession

* id
* taskId
* type（focus/shortBreak/longBreak）
* startedAt / endedAt
* durationSec
* summaryNote（番茄总结）
* createdAt

### Note

* id
* title
* content
* tags
* relatedTaskIds（可选）
* createdAt / updatedAt

### AIConfig

* id
* baseUrl
* model
* apiKeyEncrypted
* lastTestAt / lastTestResult

---

## 7. 技术方案（Flutter MVP）+ 多平台预留

### 7.1 Flutter MVP 推荐栈（Android First）

* UI：Flutter（Material 3）([Flutter][12])
* 架构分层：Presentation / Domain / Data（保持业务逻辑与 UI 解耦，便于测试与迭代）([Flutter][13])
* 本地数据库：SQLite + drift（或同类本地库；以 Local-first 为先）([drift][14])
* 设置存储：`shared_preferences`（偏好）+ 安全存储插件（apiKey 等敏感配置）([pub.dev][15])
* 后台可靠调度：Android 侧基于 WorkManager；Flutter 层通过插件封装，达到跨重启持久与可靠提醒。([Android Developers][2])

### 7.2 多平台预留（强烈建议）

Flutter 本身就是多平台方案：同一套 Dart/Flutter 代码可覆盖 Android/iOS，后续可扩展到 Desktop/Web（按 MVP 节奏渐进）。([Flutter][16])

**模块建议（从 MVP 就按这个切，后续更稳）**（建议采用 Dart package 结构拆分）([Dart][18])

* `packages/domain`：Task/Note/Pomodoro 实体 + UseCases
* `packages/ai`：OpenAICompatibleClient + Prompt/Schema（结构化输出）
* `packages/data`：本地库/索引/Repository（drift、导出/备份等）
* `app`：Flutter UI（Material 3）+ 平台能力集成（通知/前台服务/权限/文件分享）

---

## 8. 安全与风险（必须写进 PRD）

### 8.1 API Key 风险（重要）

OpenAI 官方明确：**不要把 API key 部署在移动端/浏览器等客户端环境**，否则可能被恶意用户盗用并造成费用与数据风险；推荐走自家后端转发。([OpenAI Help Center][19])

但你们产品要求“用户可配置 apiKey”，所以 MVP 的现实对策：

* 明确产品模式：**BYO Key（用户自带 Key）**
* 本地密文存储（Android Keystore / iOS Keychain；Flutter 建议用安全存储插件封装）([Android Developers][20])
* P1 规划：支持用户配置“自建网关 baseUrl”，由网关做短期 token、限额、审计

---

## 9. MVP 验收标准（可直接作为测试用例）

### Todo

* 可新增/编辑/完成/删除任务
* 可筛选与搜索
* 任务详情可看到番茄记录与笔记关联

### Pomodoro

* 可选择任务开始专注
* 后台到点通知可靠
* App 被杀/重启后仍能恢复当前计时状态（至少能从 endAt 恢复）

### AI

* 支持配置 baseUrl/model/apiKey
* 测试连接能给出明确成功/失败原因（含 401 等）([OpenAI Platform][10])
* AI 拆分任务输出可“一键导入”
* 番茄结束 AI 总结能回填任务进展

### 数据与隐私

* 支持导出 JSON / 全量备份
* 支持一键清空
* 应用内隐私说明页齐全
* 上架声明准备：Google Data safety 必填（即使你说“不收集数据”也要填）([Google Help][3])

---

如果你愿意，我可以在下一条直接把这份 PRD **进一步落成“研发可用”的两份附件级内容**（仍然不需要你补充信息）：

1. **页面级交互稿**：每个页面的状态机（空态/加载/失败/无Key/无网/限流429等）
2. **AI Prompt + JSON Schema 套件**：任务拆分、今日计划、番茄总结、日复盘四套结构化输出模板（配解析与失败兜底策略） ([OpenAI Platform][11])

[1]: https://www.inkandswitch.com/local-first-software/ "Local-first Software"
[2]: https://developer.android.com/develop/background-work/background-tasks/persistent "Task scheduling  |  Background work  |  Android Developers"
[3]: https://support.google.com/googleplay/android-developer/answer/10787469?hl=en "Provide information for Google Play's Data safety section - Play Console Help"
[4]: https://developer.apple.com/app-store/app-privacy-details/ "App Privacy Details - App Store - Apple Developer"
[5]: https://developer.android.com/develop/background-work/services/fgs "Foreground services overview  |  Background work  |  Android Developers"
[6]: https://support.google.com/googleplay/android-developer/answer/13392821?hl=en-419&utm_source=chatgpt.com "Understanding foreground service and full-screen intent requirements ..."
[7]: https://platform.openai.com/docs/api-reference/chat?locale=en "Chat Completions | OpenAI API Reference"
[8]: https://platform.openai.com/docs/api-reference/responses?utm_source=chatgpt.com "Responses | OpenAI API Reference"
[9]: https://platform.openai.com/docs/api-reference/authentication?utm_source=chatgpt.com "API Reference - OpenAI API"
[10]: https://platform.openai.com/docs/guides/error-codes?utm_source=chatgpt.com "Error codes | OpenAI API"
[11]: https://platform.openai.com/docs/guides/structured-outputs?utm_source=chatgpt.com "Structured model outputs | OpenAI API"
[12]: https://docs.flutter.dev/ "Flutter documentation"
[13]: https://docs.flutter.dev/app-architecture "App architecture | Flutter"
[14]: https://drift.simonbinder.eu/ "drift (SQLite ORM for Dart/Flutter)"
[15]: https://pub.dev/ "pub.dev (Flutter & Dart packages)"
[16]: https://docs.flutter.dev/platform-integration "Platform integration | Flutter"
[17]: https://docs.flutter.dev/deployment "Deployment | Flutter"
[18]: https://dart.dev/tools/pub/package-layout "Package layout conventions | Dart"
[19]: https://help.openai.com/en/articles/5112595-best-practices-for-api-key-safety "Best Practices for API Key Safety | OpenAI Help Center"
[20]: https://developer.android.com/privacy-and-security/keystore?utm_source=chatgpt.com "Android Keystore system | Security | Android Developers"
