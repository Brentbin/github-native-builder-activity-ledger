# GitHub-native Builder Activity Ledger 30-Day Pilot Plan

**Goal**: 用 30 天验证一个 GitHub repo 是否能跨仓库导入贡献证据、验证贡献真实性、量化仓库影响力与贡献质量，并沉淀个人 profile 历史。

**Repository**: https://github.com/Brentbin/github-native-builder-activity-ledger
**Frontend**: https://brentbin.github.io/github-native-builder-activity-ledger/
**Visibility**: Public

**Architecture**: 单 repo 承载第一阶段：`updates/` 存周期更新，`profiles/` 存完成者档案，`projects/` 存项目索引，`templates/` 存 update / work item / profile / history link / scoring / linkage 模板；GitHub Issues 作为 work item tracking、历史工作关联入口和模型反馈入口。

**Success Definition**: 4 期 weekly update、20 条完整 work item、10 个 builder profile、5 个 repository profile、100% work item 带 issue / PR 证据链接和 outcome / quality / verification 标签；80% work item 有可解释 contribution score 和 issue-PR-code linkage evidence；开发者提交的历史工作关联 issue 100% 完成复核。

---

## Phase 0: Repo 定位和目录初始化

- [ ] **Step 1: 确认 repo 名称和一句话定位**

  推荐定位：

  ```text
  A GitHub-native activity ledger for tracking who completed what work in which projects, with issue/PR evidence, quality labels, and builder profiles.
  ```

  验收：README 第一屏能看懂这个 repo 是周期性工作账本，不是聊天社区或悬赏市场。

- [ ] **Step 2: 创建目录结构**

  ```text
  updates/
  profiles/
  projects/
  templates/
  ```

  验收：四个目录存在，每个目录都有 README 或模板说明。

- [ ] **Step 3: 写 repo README**

  README 必须包含：

  ```text
  repo 目标
  public repo 安全边界
  更新周期
  work item 定义
  历史工作关联方式
  贡献验证规则
  仓库影响力评分
  contribution score 公式
  issue -> PR -> code 关联逻辑
  quality signal 定义
  profile 更新规则
  不做什么
  ```

  验收：新人能知道如何读 weekly update 和 builder profile。

## Phase 1: 模板和标签口径

- [ ] **Step 4: 创建 `templates/update-template.md`**

  内容使用 [Operating Spec §6](operating-spec.md#6-weekly-update-模板)。

  验收：每周更新能直接复制模板生成。

- [ ] **Step 5: 创建 `templates/work-item-template.md`**

  内容使用 [Operating Spec §7](operating-spec.md#7-tracking-issue-模板) 的字段。

  验收：每条工作记录都能补齐 builder、project、issue、PR、outcome、labels、quality evidence。

- [ ] **Step 6: 创建 `templates/history-link-template.md` 和 `.github/ISSUE_TEMPLATE/history-link.yml`**

  内容使用 [Operating Spec §8](operating-spec.md#8-历史工作关联入口)。

  验收：开发者能直接开 issue，把历史 issue / PR / commit / review 链到当前 repo。

- [ ] **Step 7: 创建 `templates/contribution-score-template.md` 和 `templates/repository-profile-template.md`**

  内容使用 [Operating Spec §9](operating-spec.md#9-仓库影响力与贡献质量量化)。

  验收：每条 work item 可以记录 repository impact、work quality、issue complexity、role weight 和 verification confidence。

- [ ] **Step 8: 创建 `.github/ISSUE_TEMPLATE/model-feedback.yml`**

  内容使用 [Operating Spec §11](operating-spec.md#11-系统反馈闭环)。

  验收：用户可以提交“当前模型无法表达的贡献场景”。

- [ ] **Step 9: 创建 `templates/issue-pr-code-linkage-template.md`**

  内容使用 [Issue To PR To Code Linking Design](issue-pr-code-linking.md) 的数据模型。

  验收：每条 work item 可以记录 link / identity / resolution / semantic 四类置信度。

- [ ] **Step 10: 创建 `templates/profile-template.md`**

  内容使用 [Operating Spec §13](operating-spec.md#13-profile-模型)。

  验收：第一个 builder 能直接复制模板开档。

- [ ] **Step 11: 创建 labels**

  如果使用 GitHub Issues，先创建这些 labels：

  ```text
  outcome:merged
  outcome:open
  outcome:closed-not-merged
  outcome:abandoned
  outcome:blocked
  domain:frontend
  domain:backend
  domain:infra
  domain:docs
  domain:agent
  domain:automation
  domain:data
  domain:product
  quality:strong
  quality:solid
  quality:unclear
  quality:risky
  quality:incomplete
  review:none
  review:minor
  review:major
  review:rejected
  review:praised
  source:cycle-scan
  source:developer-submitted
  history:pending-verification
  history:verified
  history:rejected
  profile:update-needed
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

  验收：每条 tracking issue 至少能打 outcome、domain、quality 三类标签。

## Phase 2: 第一批项目和 work item

- [ ] **Step 12: 确定第一批项目范围**

  先选 3 到 5 个项目，不要泛化。

  每个项目建立：

  ```text
  projects/<owner>-<repo>.md
  ```

  项目文件字段：

  ```markdown
  # Project: <owner/repo>

  - URL:
  - Maintainers:
  - Domains:
  - Labels observed:
  - Tracking notes:
  ```

  验收：第一期 update 的每个 work item 都能归到一个项目文件。

- [ ] **Step 13: 建立第一批 repository profiles**

  为 3 到 5 个项目建立仓库画像：

  ```text
  projects/<owner>-<repo>.md
  ```

  每个 repository profile 至少包含：

  ```text
  stars
  lifecycle
  recent activity
  topics / languages / labels
  issue hygiene
  maintainer activity
  repo-impact tier
  ```

  验收：第一期 work item 中涉及的仓库均有 repository profile。

- [ ] **Step 14: 整理第一批 10 到 20 条 work item**

  每条 work item 必须有：

  ```text
  builder
  project
  upstream issue 或 PR
  当前 outcome
  upstream labels 快照
  ledger labels
  quality evidence
  verification evidence
  contribution score
  linkage evidence
  ```

  验收：没有证据链接的 work item 不进入第一期。

- [ ] **Step 15: 如使用 GitHub Issues，为每条 work item 建 tracking issue**

  标题格式：

  ```markdown
  [project] <builder>: <short work title>
  ```

  验收：tracking issue 里有 upstream issue / PR 链接，并打上 outcome / domain / quality / verification / score 标签。

- [ ] **Step 16: 试跑 3 条历史工作关联 issue**

  找 1 到 3 个开发者，让他们用 `Link historical work` issue form 提交历史 work item。

  验收：

  ```text
  每条都有 upstream issue / PR / commit / review 证据
  每条都没有私有代码、客户数据、内部链接或未授权截图
  每条都有 source:developer-submitted
  每条都有 verification:* 标签
  每条复核后有 history:verified 或 history:rejected
  通过复核的条目进入 update 和 profile
  ```

- [ ] **Step 17: 试跑 GitHub API 交叉校验**

  对 3 条历史工作关联 issue 做人工 API 校验：

  ```text
  issue author 是否等于 claim builder
  PR author 或 commit author 是否等于 claim builder
  review/comment author 是否等于 claim builder
  无法自动判断时是否转 platform-reviewed
  ```

  验收：每条 claim 都有 verification confidence。

- [ ] **Step 18: 试跑 3 条 issue -> PR -> code linkage**

  对 3 条 work item 计算：

  ```text
  LinkConfidence
  IdentityConfidence
  ResolutionConfidence
  SemanticFitConfidence
  ContributionResolutionConfidence
  ```

  验收：每条都能说明 PR 与 issue 的 metadata 链接、代码变更摘要和语义匹配理由。

## Phase 3: Builder Profiles

- [ ] **Step 19: 为完成者建立 profile**

  每人一个文件：

  ```text
  profiles/<github-handle>.md
  ```

  验收：第一批 work item 涉及到的每个 builder 都有 profile。

- [ ] **Step 20: 写入第一批历史记录**

  每个 profile 的 `Work History` 至少包含：

  ```text
  Date
  Update
  Project
  Issue
  PR
  Outcome
  Labels
  Quality
  Score
  Notes
  ```

  验收：profile 里的每条历史都能回到 update 或 tracking issue。

- [ ] **Step 21: 写 profile 的 current summary**

  只写证据足够的结论：

  ```text
  Primary domains
  Projects touched
  Merged work count
  Contribution score
  Repository impact distribution
  User-project relation
  Recent quality pattern
  Current risk notes
  ```

  验收：没有足够证据的字段写 `unclear`，不强行判断。

## Phase 4: 第一轮 Weekly Update

- [ ] **Step 22: 创建第一期 update**

  文件：

  ```text
  updates/YYYY-WXX.md
  ```

  内容使用 `templates/update-template.md`。

  验收：包含 summary、work items、merged work、open/in review、closed not merged、abandoned/blocked、quality notes、profile changes。

- [ ] **Step 23: 做质量复核**

  每条 work item 检查：

  ```text
  issue / PR 链接可访问
  outcome 与 upstream 状态一致
  upstream labels 已记录
  ledger labels 已添加
  quality label 有证据
  developer-submitted history 已复核
  contribution score 有权重解释
  repository impact tier 有仓库画像支撑
  issue -> PR -> code linkage 有四类证据
  profile 已更新
  ```

  验收：复核通过后才发布 weekly update。

- [ ] **Step 24: 发布第一期 update**

  发布动作：

  ```text
  update 文件合入 main
  tracking issue 状态同步
  profile 文件同步
  README 链接到最新 update
  ```

  验收：从 README 能进入最新 update，再进入 work item，再进入 profile。

## Phase 5: 连续 4 周运行和月度小结

- [ ] **Step 25: 连续发布 4 期 weekly update**

  验收：

  ```text
  updates/ 下有 4 个 YYYY-WXX.md
  每期都有完整 summary
  每期都更新相关 profiles
  ```

- [ ] **Step 26: 为每个 active builder 写月度小结**

  在 profile 追加：

  ```markdown
  ## Monthly Notes

  ### YYYY-MM

  - Completed:
- Merged:
- Contribution score:
- Strongest evidence:
- Repeated domains:
- Repository relation:
- Repeated risks:
- Next thing to watch:
  ```

  验收：至少 5 个 profile 有月度小结。

- [ ] **Step 27: 30 天复盘**

  按这些问题复盘：

  ```text
  是否完成 4 期 weekly update?
  是否追踪至少 20 条 work item?
  是否建立至少 10 个 builder profile?
  是否建立至少 5 个 repository profile?
  是否所有 work item 都有证据链接?
  自举证真实性是否能被 GitHub API 或平台复核?
  quality 标签是否可追溯到证据?
  contribution score 是否可解释?
  issue -> PR -> code 的自动关联是否比用户自述更可靠?
  codegraph 是否提升语义判断，还是成本过高?
  开发者是否能方便提交历史工作关联 issue?
  哪些复杂贡献场景需要 model feedback?
  profile 是否能看出历史变化?
  固定周期更新成本是否可接受?
  是否需要自动化采集?
  ```

  验收：明确进入第二阶段、继续人工维护、或暂停重做标签和 profile 口径。
