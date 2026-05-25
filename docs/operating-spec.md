# Builder Guild Operating Spec

**版本**: v0.3
**日期**: 2026-05-24
**工作名**: Builder Guild
**GitHub repo**: https://github.com/Brentbin/builder-guild
**Frontend**: https://brentbin.github.io/builder-guild/
**Visibility**: Public
**一句话定位**: 一个跨仓库贡献验证与开发者影响力量化平台，用 issue / PR / tag / review 证据验证贡献真实性，量化仓库影响力与贡献质量，并沉淀完成者技术画像。

## 1. 核心判断

这个 repo 的主职责不是“拉人组队”，而是“把跨仓库贡献变成可验证、可量化、可追踪的开发者影响力证据”。

GitHub 上真正有价值的不是说自己会 build，而是能追溯到具体项目、具体 issue、具体 PR、具体 review 结果。这个 repo 要做的是把这些分散在不同项目里的工作记录，按固定周期收拢成一个可读、可追踪、可比较的活动账本，并在此基础上建立贡献评分、仓库影响力、用户-项目关联图谱。

因此第一原则是：

> Influence comes from verified cross-repo contribution evidence.

profile 里的判断必须能回到具体 issue / PR / tag / review / merge 证据。没有证据的评价只能写成观察问题，不能写成能力结论。

## 2. Repo 的边界

### 做什么

- 按固定周期更新 Builder 工作记录。
- 记录哪些人在哪些项目里完成了哪些 issue / PR。
- 记录工作质量信号：是否 merged、issue 标签、PR 标签、review 反馈、测试/文档情况、是否被 abandoned。
- 为 repo 内出现过的 issue 完成者建立 profile。
- 持续追踪 profile 的历史变化：完成数量、完成质量、擅长方向、稳定性、风险信号。
- 验证开发者自举证的真实性，区分本人导入、平台验证和无法验证。
- 基于仓库影响力、issue 复杂度、贡献质量、角色权重和验证置信度计算贡献分值。
- 建立用户与仓库、技术标签之间的关联图谱，识别核心贡献者和活跃用户。

### 不做什么

- 不做泛 AI 群。
- 不搬运 AI 新闻。
- 不以聊天活跃度衡量价值。
- 不把这个 repo 直接做成悬赏平台。
- 不替代上游项目的 issue / PR / review。
- 不写没有证据支撑的能力评价。
- 不把 generated code 数量当成完成质量。
- 不公开私有代码、客户数据、内部链接、未授权截图或不能公开的 review 内容。
- 不允许非本人把别人的贡献导入成自己的 profile 证据。
- 不把 Star 数量单独等同于仓库影响力；Star 只是一项输入。

## 3. 核心数据对象

### 3.1 Update Cycle

一个固定周期的更新批次。默认每周一次。

每期 update 回答四个问题：

- 本周期哪些项目有工作完成或推进？
- 谁完成了这些工作？
- 对应的 issue / PR 当前是什么状态？
- 这些工作的质量证据是什么？

### 3.2 Work Item

一条被追踪的具体工作记录。

Work item 必须能链接到至少一个真实对象：

- upstream issue
- upstream PR
- 当前 repo 内的 tracking issue
- maintainer review comment
- release / changelog / commit

Work item 有两种来源：

- **周期采集**: 维护者按固定周期从项目 issue / PR 里收集。
- **开发者提交**: 开发者用 `Link historical work` issue template 主动把历史 issue / PR / commit 关联进当前 repo。

### 3.3 Builder

完成或推进 work item 的人。

Builder 的识别优先使用 GitHub handle。如果一个人有多个身份，profile 里要显式记录映射，不默默合并。

### 3.4 Project

工作发生的上游项目。

Project 可以是开源 repo、内部 repo、文档项目或产品项目，但每条 work item 都必须写清项目来源。

### 3.5 Quality Signal

质量信号不是一句主观评价，而是一组证据字段：

| 字段 | 说明 |
|---|---|
| Outcome | `merged` / `open` / `closed-not-merged` / `abandoned` / `blocked` |
| Upstream labels | 上游 issue / PR 原始标签快照 |
| Ledger labels | 本 repo 追加的统一分类标签 |
| Review result | 无 review / minor comments / major comments / rejected / maintainer praised |
| Test evidence | 有测试 / 无测试但合理 / 应有未有 / 不适用 |
| Docs evidence | 有文档 / 无文档但合理 / 应有未有 / 不适用 |
| Risk note | 质量风险或上下文限制 |
| Evidence links | issue / PR / review / commit 链接 |

### 3.6 Contribution Claim

开发者或平台方导入的一条跨仓库贡献声明。

Contribution claim 必须明确：

- claim 发起者是谁。
- 被归属的贡献者是谁。
- claim 发起者与贡献者是否同一人。
- 原始 issue / PR / commit / review 的链接。
- GitHub API 或平台复核能否证明身份一致。
- 最终验证状态。

### 3.7 Repository Profile

被引用仓库的影响力画像。

字段：

| 字段 | 说明 |
|---|---|
| Stars | GitHub stars，使用 log 归一化，不单独作为结论 |
| Lifecycle | 仓库从创建至今的时间、近期活跃度 |
| Tags | GitHub topics、语言、issue labels、项目自定义标签 |
| Issue hygiene | issue 是否有清晰状态、label、关闭原因、review 链接 |
| Maintainer activity | 近期 PR / issue review 是否活跃 |
| Impact tier | `repo-impact:seed` / `repo-impact:active` / `repo-impact:high` / `repo-impact:foundation` |

### 3.8 Contribution Score

贡献分值用于排序和趋势分析，不直接替代人工判断。

初始公式：

```text
ContributionScore =
  RepositoryImpactWeight
  * WorkQualityWeight
  * IssueComplexityWeight
  * RoleWeight
  * VerificationConfidence
```

每个因子范围：

| 因子 | 范围 | 说明 |
|---|---:|---|
| RepositoryImpactWeight | 0.8 - 2.0 | 仓库影响力，来自 stars、生命周期、活跃度、标签和 issue hygiene |
| WorkQualityWeight | 0.4 - 1.5 | merged / review / test / docs / risk |
| IssueComplexityWeight | 0.7 - 1.6 | issue 难度、范围、跨模块程度 |
| RoleWeight | 0.5 - 1.2 | author / co-author / reviewer / maintainer / docs |
| VerificationConfidence | 0.0 - 1.0 | 身份和证据验证置信度 |

`VerificationConfidence = 0` 的 claim 不进入 profile 分值，只保留为 rejected / unclear 记录。

## 4. 推荐仓库结构

这个 repo 本身就可以承载第一阶段，不需要拆多个 repo。

```text
README.md
updates/
  2026-W21.md
  2026-W22.md
profiles/
  README.md
  <github-handle>.md
projects/
  <owner>-<repo>.md
templates/
  update-template.md
  work-item-template.md
  history-link-template.md
  contribution-score-template.md
  repository-profile-template.md
  profile-template.md
  project-template.md
.github/
  ISSUE_TEMPLATE/
    work-item.yml
    history-link.yml
    model-feedback.yml
```

如果使用 GitHub Issues 做 tracking，则每条 tracking issue 也必须链接到 `updates/YYYY-WXX.md` 和对应 profile。

## 5. 固定周期更新机制

默认节奏：

| 周期 | 动作 | 输出 |
|---|---|---|
| 每周一 | 收集上周新增 / 关闭 / merged / abandoned 的 issue / PR | 候选 work item 清单 |
| 每周二 | 补齐标签、状态、证据链接 | tracking issues / update 草稿 |
| 每周三 | 更新 builder profiles | profile diff |
| 每周四 | 做质量复核 | 修正 outcome / labels / risk note |
| 每周五 | 发布 weekly update | `updates/YYYY-WXX.md` |
| 每月末 | 汇总 profile 趋势 | profile 月度小结 |

最小可行版本可以只做周五一次人工更新，但字段必须完整。

## 6. Weekly Update 模板

文件名：

```text
updates/YYYY-WXX.md
```

模板：

```markdown
# YYYY-WXX Builder Activity Update

## Summary

- Period:
- Projects tracked:
- Builders active:
- Work items tracked:
- Merged:
- Closed not merged:
- Abandoned:
- Blocked:

## Work Items

| Builder | Project | Issue | PR | Outcome | Upstream Labels | Ledger Labels | Quality Evidence | Profile Updated |
|---|---|---|---|---|---|---|---|---|

## Merged Work

## Open / In Review

## Closed Not Merged

## Abandoned / Blocked

## Quality Notes

## Profile Changes
```

## 7. Tracking Issue 模板

如果当前 repo 使用 issue 追踪 work item，每个 tracking issue 的标题格式：

```markdown
[project] <builder>: <short work title>
```

正文模板：

```markdown
## Work Item

- Builder:
- Project:
- Upstream issue:
- Upstream PR:
- Update cycle:

## Status

- Outcome:
- Current state:

## Labels Snapshot

- Upstream labels:
- Ledger labels:

## Quality Evidence

- Merge state:
- Review result:
- Test evidence:
- Docs evidence:
- Risk note:

## Profile Impact

- Profile:
- Profile section to update:
- Historical note:
```

## 8. 历史工作关联入口

开发者应该能用一个 issue form 把历史工作关联到当前 repo，不需要先改 Markdown 文件。

标题格式：

```markdown
[history] <builder>: <project> <short work title>
```

字段：

```markdown
## Builder

- GitHub handle:
- Profile:
- Role: author / co-author / reviewer / maintainer / docs

## Upstream Evidence

- Project:
- Issue:
- PR:
- Commits:
- Review / release / changelog:

## Work Summary

- What changed:
- Outcome:
- Original labels:
- Ledger labels:

## Profile Impact

- Suggested domain:
- Suggested quality:
- Notes to add:
```

复核规则：

1. 至少有一个可访问的 upstream issue / PR / commit / review 链接。
2. claim 发起者必须等于原始贡献者，或由平台方显式承担验证责任。
3. 提交者的角色能从 evidence 中看出来；看不出来则标 `quality:unclear`。
4. 维护者复核前只打 `history:pending-verification`。
5. 复核通过后打 `history:verified`，进入最近一期 weekly update。
6. 复核不通过打 `history:rejected`，并写清缺失证据，不进入 profile。
7. 因为 repo 是 public，复核时必须删除或退回任何私有代码、客户数据、内部链接、未授权截图或不能公开的 review 内容。

### 8.1 自动化验证路径

第一版 GitHub API 交叉校验：

| Evidence | 校验字段 | 通过条件 |
|---|---|---|
| Issue | `user.login` | claim builder 等于 issue author |
| PR | `user.login` / merged commits | claim builder 等于 PR author 或 commits author |
| Commit | `author.login` / `committer.login` | claim builder 等于 author 或 committer |
| Review | `user.login` | claim builder 等于 reviewer |
| Comment | `user.login` | claim builder 等于 issue / PR comment author |

校验结果标签：

```text
verification:self-claimed
verification:api-cross-check
verification:platform-reviewed
verification:insufficient
verification:rejected
```

## 9. 仓库影响力与贡献质量量化

### 9.1 Repository Impact Score

仓库影响力评分用于衡量同样一条贡献发生在什么样的项目中。

初始评分：

```text
RepositoryImpactScore =
  0.30 * StarScore
  + 0.20 * LifecycleScore
  + 0.20 * ActivityScore
  + 0.15 * TagSignalScore
  + 0.15 * IssueHygieneScore
```

评分定义：

| 子项 | 计算口径 |
|---|---|
| StarScore | `min(1, log10(stars + 1) / 5)` |
| LifecycleScore | 创建超过 12 个月且近期仍活跃为高分；新仓库不直接惩罚，但标记为 seed |
| ActivityScore | 最近 90 天有 issue / PR / release 活动 |
| TagSignalScore | GitHub topics、语言、issue labels 能清楚表明技术领域 |
| IssueHygieneScore | issue 有状态、标签、关闭原因、review / PR 链接 |

Impact tier：

| Tier | 条件 |
|---|---|
| `repo-impact:seed` | 新项目或证据不足 |
| `repo-impact:active` | 有持续维护和清晰 issue 流 |
| `repo-impact:high` | 高 star / 高活跃 / 多贡献者之一成立，且 issue hygiene 不低 |
| `repo-impact:foundation` | 基础设施级项目，例如 Apache 基金会、CNCF、语言/框架核心生态等，需人工确认 |

### 9.2 Work Quality Score

```text
WorkQualityScore =
  OutcomeWeight
  * ReviewWeight
  * TestDocsWeight
  * RiskWeight
```

基础权重：

| Signal | Weight |
|---|---:|
| `outcome:merged` | 1.0 |
| `outcome:open` | 0.4 |
| `outcome:closed-not-merged` | 0.2 |
| `outcome:abandoned` | 0.1 |
| `review:praised` | 1.2 |
| `review:minor` | 1.0 |
| `review:major` | 0.75 |
| `review:rejected` | 0.2 |
| tests/docs 符合项目预期 | 1.0 |
| 应有测试或文档但缺失 | 0.7 |
| `quality:risky` | 0.75 |
| `quality:incomplete` | 0.3 |

### 9.3 Contribution Mapping

每条贡献必须映射到仓库标签和 ledger 标签：

- 仓库标签：upstream issue labels、PR labels、GitHub topics、主要语言。
- Ledger 标签：domain、quality、outcome、review、verification、repo-impact。

用户 profile 中的技术画像不直接靠自述，而靠这些标签的长期分布。

## 10. 用户与仓库关联图谱

用户与项目之间建立边：

```text
Builder -> Repository
```

边属性：

| 属性 | 说明 |
|---|---|
| contribution_count | 已验证贡献数量 |
| merged_count | merged 贡献数量 |
| total_score | contribution score 汇总 |
| avg_quality | 平均 work quality |
| domains | 贡献标签分布 |
| first_seen / last_seen | 首次和最近贡献时间 |

身份层级：

| Level | 判定 |
|---|---|
| `relation:active-user` | 在项目中有 1 条以上 verified contribution |
| `relation:repeat-contributor` | 3 条以上 verified contribution，或 2 条以上 merged contribution |
| `relation:core-contributor` | 高影响力项目中有稳定 merged contribution、review 响应和标签集中度；Apache / CNCF 等 foundation tier 项目需人工复核 |

## 11. 系统反馈闭环

贡献场景缺失时，不直接改模型，先提交 model feedback issue。

反馈 issue 需要包含：

- 哪类贡献无法被当前字段表达。
- 具体上游 issue / PR / review 例子。
- 当前评分或验证哪里失真。
- 建议新增字段、标签或权重。

模型更新必须留下版本记录，并在 weekly update 里说明影响范围。

## 12. Issue 到 PR 到代码的闭环关联

贡献导入不只校验“这个人是不是作者”，还要校验“这次代码变更是否真的解决了这个 issue”。

系统按四层证据判断：

| 层级 | 作用 | 例子 |
|---|---|---|
| Link evidence | issue 与 PR / commit 是否被 GitHub metadata 关联 | closing keyword、Development 手动链接、timeline closed event、commit associated PR |
| Identity evidence | developer 是否是实际贡献者 | PR author、commit author、reviewer、co-author trailer |
| Resolution evidence | issue 是否因该 PR / commit 闭环 | PR merged、issue auto-closed、maintainer resolved comment |
| Semantic evidence | 代码变更是否匹配 issue 意图 | changed files、patch、tests、review comments、codegraph path |

最终置信度：

```text
ContributionResolutionConfidence =
  LinkConfidence
  * IdentityConfidence
  * ResolutionConfidence
  * SemanticFitConfidence
```

详细设计见 [Issue To PR To Code Linking Design](issue-pr-code-linking.md)。

## 13. 标签口径

### 13.1 Outcome labels

```text
outcome:merged
outcome:open
outcome:closed-not-merged
outcome:abandoned
outcome:blocked
```

### 13.2 Domain labels

```text
domain:frontend
domain:backend
domain:infra
domain:docs
domain:agent
domain:automation
domain:data
domain:product
```

### 13.3 Quality labels

```text
quality:strong
quality:solid
quality:unclear
quality:risky
quality:incomplete
```

质量标签必须有证据：

- `quality:strong`: merged，review 反馈积极或复杂问题被清楚解决，测试/文档符合项目预期。
- `quality:solid`: merged，review 无严重问题，测试/文档没有明显缺口。
- `quality:unclear`: 缺少足够 review 或验证信息。
- `quality:risky`: 已完成但有明显维护、测试、兼容或上下文风险。
- `quality:incomplete`: 未完成、未 merge、或被关闭但核心问题未解决。

### 13.4 Review labels

```text
review:none
review:minor
review:major
review:rejected
review:praised
```

### 13.5 Source / history labels

```text
source:cycle-scan
source:developer-submitted
history:pending-verification
history:verified
history:rejected
profile:update-needed
```

### 13.6 Verification / scoring labels

```text
verification:self-claimed
verification:api-cross-check
verification:platform-reviewed
verification:insufficient
verification:rejected
score:pending
score:computed
repo-impact:seed
repo-impact:active
repo-impact:high
repo-impact:foundation
relation:active-user
relation:repeat-contributor
relation:core-contributor
model:feedback
```

### 13.7 Linkage / semantic labels

```text
linkage:explicit
linkage:inferred
linkage:manual-review
semantic:fit-strong
semantic:fit-partial
semantic:fit-unclear
semantic:fit-rejected
codegraph:pending
codegraph:checked
```

## 14. Profile 模型

每个完成者一个 profile：

```text
profiles/<github-handle>.md
```

模板：

```markdown
# Builder Profile: <github-handle>

## Identity

- GitHub:
- Other handles:
- First seen:
- Last updated:

## Current Summary

- Primary domains:
- Projects touched:
- Merged work count:
- Contribution score:
- Repository impact distribution:
- User-project relation:
- Recent quality pattern:
- Current risk notes:

## Work History

| Date | Update | Project | Issue | PR | Outcome | Labels | Quality | Notes |
|---|---|---|---|---|---|---|---|---|

## Domain Pattern

| Domain | Evidence | Notes |
|---|---|---|

## Quality Pattern

| Signal | Evidence | Notes |
|---|---|---|

## Open Questions

- 
```

Profile 更新规则：

- 每周只做增量更新，不重写历史。
- 每条历史记录必须链接到 update 或 tracking issue。
- 能力判断必须写证据链。
- 风险信号要写成具体行为或上下文，不写人格判断。
- 没有足够证据时写 `unclear`，不要硬判强弱。
- 开发者主动提交的历史工作，必须先完成 `history:verified` 复核，再进入 profile。
- 贡献分值必须能回到 scoring record；不能只写总分。

## 15. Profile 的历史追踪方式

profile 不是静态简历，而是历史账本。

每月末在 profile 里追加一次小结：

```markdown
## Monthly Notes

### YYYY-MM

- Completed:
- Merged:
- Strongest evidence:
- Repeated domains:
- Repeated risks:
- Next thing to watch:
```

判断一个 builder 时优先看趋势：

- 是否持续完成，而不是只做一次。
- 是否能处理 review，而不是只开 PR。
- 是否在某个 domain 形成稳定证据。
- 是否反复出现 abandoned / risky / incomplete。
- 是否能从小 issue 走向更复杂 issue。
- 是否在高影响力仓库中形成 repeat contributor 或 core contributor 关系。

## 16. 质量复核原则

每条 work item 发布前做一次复核：

1. 链接是否能回到真实 issue / PR。
2. outcome 是否和 upstream 状态一致。
3. upstream labels 是否保留原始快照。
4. ledger labels 是否按统一口径添加。
5. quality label 是否有证据支撑。
6. profile 是否已更新。
7. profile 里的判断是否没有越过证据。
8. 若 work item 来自开发者历史提交，是否已完成 `history:verified`。
9. contribution score 是否能解释每个权重来源。
10. repository impact tier 是否有仓库画像支撑。
11. issue -> PR -> code 关联是否有 link / identity / resolution / semantic 四类证据。

## 17. 关键指标

第一阶段只看 repo 作为活动账本是否跑得起来：

| 指标 | 30 天目标 |
|---|---:|
| Weekly updates | 4 |
| Tracked work items | 20 |
| Builder profiles | 10 |
| Profiles with at least 2 historical entries | 5 |
| Work items with evidence links | 100% |
| Work items with outcome labels | 100% |
| Work items with quality labels | 100% |
| Developer-submitted history links reviewed | 100% |
| Work items with verification labels | 100% |
| Work items with contribution score | 80% |
| Work items with issue-PR-code linkage evidence | 80% |
| Repository profiles created | 5 |
| Profile updates missed | 0 |

不看这些 vanity metrics：

- GitHub stars。
- 群成员数。
- 聊天消息数。
- AI 新闻转发量。
- 没有证据链的“很强”“很活跃”。
- 没有验证和权重解释的总分。

## 18. 退出条件

30 天后如果出现以下任一情况，应暂停扩张，先修 repo 机制：

- 少于 2 期 weekly update。
- 少于 10 条 work item 有完整证据链。
- profile 经常没有同步更新。
- quality label 大量靠主观判断，无法回到 issue / PR 证据。
- contribution score 大量无法解释权重来源。
- 开发者自举证无法验证身份一致性。
- issue 与 PR / code 的关联大量只能靠用户自述，无法形成 metadata 或 semantic evidence。
- 记录成本高到无法固定周期更新。

如果 30 天目标达成，再考虑第二阶段：接入自动采集、公开 profile 汇总、跨项目趋势分析和质量仪表盘。
