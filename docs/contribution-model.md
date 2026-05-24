# Cross-Repo Contribution Verification And Quantification Model

## Goal

Turn cross-repository contribution claims into verifiable, quantifiable, and reviewable developer impact evidence.

The system answers:

1. Where did the contribution happen?
2. Is the importer the original contributor, or has the platform verified the claim?
3. What is the repository impact and technical tag context?
4. How should the contribution affect the builder profile?

## Import And Verification

Allowed import modes:

| Mode | Requirement | Label |
|---|---|---|
| Self-claim | Importer is the original issue / PR / commit / review contributor | `verification:self-claimed` |
| Platform import | Platform takes responsibility for evidence review | `verification:platform-reviewed` |

A user cannot import someone else's work as their own profile evidence.

## GitHub API Cross-Check

| Evidence | GitHub field | Pass condition |
|---|---|---|
| Issue | issue author | claim builder equals issue author |
| PR | PR author / commits author | claim builder equals PR author or primary commit author |
| Commit | author / committer | claim builder equals author or committer |
| Review | review author | claim builder equals reviewer |
| Comment | comment author | claim builder equals comment author |

Verification labels:

- `verification:api-cross-check`
- `verification:platform-reviewed`
- `verification:insufficient`
- `verification:rejected`

## Repository Impact Score

```text
RepositoryImpactScore =
  0.30 * StarScore
  + 0.20 * LifecycleScore
  + 0.20 * ActivityScore
  + 0.15 * TagSignalScore
  + 0.15 * IssueHygieneScore
```

| Component | Definition |
|---|---|
| StarScore | `min(1, log10(stars + 1) / 5)` |
| LifecycleScore | Repository age plus current activity |
| ActivityScore | Recent issue, PR, and release activity |
| TagSignalScore | Topics, language, and labels clarify technical domain |
| IssueHygieneScore | Issues have status, labels, close reasons, review / PR links |

Impact tiers:

- `repo-impact:seed`
- `repo-impact:active`
- `repo-impact:high`
- `repo-impact:foundation`

## Contribution Score

```text
ContributionScore =
  RepositoryImpactWeight
  * WorkQualityWeight
  * IssueComplexityWeight
  * RoleWeight
  * VerificationConfidence
```

| Factor | Range | Meaning |
|---|---:|---|
| RepositoryImpactWeight | 0.8 - 2.0 | Repository impact |
| WorkQualityWeight | 0.4 - 1.5 | Merge, review, test, docs, risk |
| IssueComplexityWeight | 0.7 - 1.6 | Difficulty and scope |
| RoleWeight | 0.5 - 1.2 | Author, co-author, reviewer, maintainer, docs |
| VerificationConfidence | 0.0 - 1.0 | Identity and evidence confidence |

`VerificationConfidence = 0` means the claim does not enter profile scoring.

## User-Repository Graph

Edge:

```text
Builder -> Repository
```

Edge attributes:

| Attribute | Meaning |
|---|---|
| contribution_count | Verified contribution count |
| merged_count | Merged contribution count |
| total_score | Sum of contribution scores |
| avg_quality | Average work quality |
| domains | Technical tag distribution |
| first_seen / last_seen | First and latest contribution dates |

Relation labels:

- `relation:active-user`
- `relation:repeat-contributor`
- `relation:core-contributor`

Foundation-level projects, such as Apache or CNCF ecosystem repositories, require manual review before `relation:core-contributor` is applied.

## Feedback Loop

Use the `Model feedback` issue form when a contribution scenario cannot be represented by the current fields, labels, or weights.

A feedback issue should include:

- concrete upstream issue / PR / review evidence;
- where verification or scoring becomes distorted;
- suggested field, label, or weight changes.
