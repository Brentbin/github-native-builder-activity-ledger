# Issue To PR To Code Linking Design

## Problem

When a developer says they fixed an issue in a GitHub repository, the system must verify a chain:

```text
Developer -> Issue -> Pull Request -> Commits / Files -> Review / Merge -> Repository -> Profile
```

The output is not "someone claims they fixed an issue". The output is a confidence-scored evidence edge:

```text
A GitHub identity contributed to a PR / commit that is metadata-linked and semantically aligned with an issue.
```

## GitHub Native Signals

### Explicit issue / PR linkage

GitHub supports linked issues through closing keywords in PR descriptions or commit messages, and through the Development sidebar. Closing keywords include forms such as `fixes`, `closes`, and `resolves`. Default-branch behavior matters: keywords only trigger auto-close behavior when the PR targets the default branch.

### Issue timeline

The issue timeline API exposes issue and PR timeline activity. It is the main source for events such as labels, comments, references, and closure activity.

### PR metadata

Pull requests are a type of issue. Shared fields such as labels and milestones are read through Issues API endpoints, while PR-specific data comes from PR endpoints: commits, changed files, reviews, review comments, merge state, and base/head branches.

### Commit to PR reverse lookup

When the input is only a commit SHA, GitHub can list PRs associated with that commit. This lets the system go from commit -> PR -> issue.

## Import Flow

Minimum input:

```text
repo: owner/name
developer: github handle
one of:
  issue url
  PR url
  commit sha / url
```

Steps:

1. Fetch issue metadata: title, body, labels, author, state, close state, comments, timeline.
2. Build candidate PR set from closing references, timeline events, manual links, commit association, and text references.
3. Fetch PR metadata: author, body, merged state, base branch, commits, files, reviews, comments.
4. Verify contributor identity from PR author, commit author, reviewer, co-author trailer, or platform review.
5. Summarize code changes and compare them with issue intent.
6. Write an evidence edge into the weekly update and profile if confidence clears the threshold.

## Confidence Model

```text
ContributionResolutionConfidence =
  LinkConfidence
  * IdentityConfidence
  * ResolutionConfidence
  * SemanticFitConfidence
```

### LinkConfidence

| Score | Condition |
|---:|---|
| 1.0 | PR is explicitly closing / closed issue in GitHub metadata and merged |
| 0.9 | PR manually linked to issue and merged, or maintainer confirms |
| 0.8 | PR body has closing keyword but closure state is not final |
| 0.7 | Commit SHA maps to PR, and PR references issue |
| 0.5 | PR mentions issue number without closing / linked metadata |
| 0.2 | Only text similarity or user claim |

### IdentityConfidence

| Score | Condition |
|---:|---|
| 1.0 | PR author or commit author equals developer |
| 0.9 | Developer is primary commit author while PR author is maintainer / bot |
| 0.8 | Developer is reviewer for a review contribution |
| 0.6 | Developer appears in co-author trailer or maintainer comment |
| 0.3 | Only user self-claim |
| 0.0 | Metadata conflicts with claim |

### ResolutionConfidence

| Score | Condition |
|---:|---|
| 1.0 | PR merge auto-closes issue and timeline proves it |
| 0.9 | PR merged and maintainer confirms resolved |
| 0.8 | PR merged but issue remains open as partial / follow-up |
| 0.5 | PR open and review accepts direction |
| 0.2 | PR closed not merged |
| 0.0 | PR rejected or unrelated |

## Semantic Understanding

Metadata proves linkage; semantic analysis checks whether the code change plausibly solves the issue.

Inputs:

- issue title, body, labels, comments, reproduction steps;
- PR title, body, commits, changed files, patch summary;
- tests, docs, review comments, CI status;
- optional codegraph: changed files, symbols, imports, exports, call graph.

AI output should be structured:

```markdown
## Issue Intent
- User-visible problem:
- Affected component:
- Expected behavior:
- Acceptance clues:

## Change Summary
- Files touched:
- Symbols / modules touched:
- Behavioral change:
- Tests / docs:

## Fit Analysis
- Directly addresses:
- Partially addresses:
- Unrelated changes:
- Evidence gaps:

## SemanticFitConfidence
- Score:
- Reason:
```

Codegraph is not a fact source by itself. It only strengthens or weakens semantic fit by checking whether changed files and symbols are on the path implied by the issue.

## Failure Modes

| Failure mode | Handling |
|---|---|
| Issue closed manually without PR | Record issue interaction, not merged contribution |
| Commit message closes issue but PR is not listed as linked | Use commit -> PR lookup and reduce confidence |
| One PR closes multiple issues | Create one evidence edge per issue |
| One issue is solved by multiple PRs | Allow multiple partial edges |
| Squash merge changes commit author | Use PR author plus commit/co-author evidence |
| Maintainer or bot merges contributor work | Trace commits and co-author trailers |
| Private repository evidence | Do private review or mark public record unclear |

## Data Model

```yaml
IssueClosureEvidence:
  repository: owner/repo
  issue:
    number:
    url:
    title:
    author:
    labels:
    state:
    closed_at:
  pull_request:
    number:
    url:
    author:
    merged_at:
    base_branch:
    linked_by:
      - closing_keyword
      - manual_development_link
      - timeline_event
      - commit_association
  commits:
    - sha:
      author:
      message:
  files:
    - path:
      status:
      additions:
      deletions:
  reviews:
    - reviewer:
      state:
      summary:
  confidence:
    link:
    identity:
    resolution:
    semantic_fit:
    final:
  decision:
    profile_action: add / hold / reject
    reason:
```

## Source Notes

- GitHub Docs: Linking a pull request to an issue
- GitHub Docs: REST API timeline events
- GitHub Docs: REST API pull requests
- GitHub Docs: REST API commits
- GitHub GraphQL schema fields observed: `PullRequest.closingIssuesReferences`, `Issue.closedByPullRequestsReferences`, `timelineItems`
