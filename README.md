# Builder Guild

Frontend: https://brentbin.github.io/builder-guild/

A public cross-repository contribution verification and developer impact ledger. It links builders to issue/PR evidence, verifies contribution authenticity, scores repository impact and contribution quality, and turns verified work into profile history.

## What This Repo Tracks

This repo is not a chat community, bounty board, or accelerator. It is an evidence and impact platform.

Each update records:

- who worked on which project;
- which issue / PR / commit proves the work;
- whether the work was merged, still open, blocked, abandoned, or closed without merge;
- which upstream labels and local ledger labels apply;
- what quality evidence exists;
- how repository impact and contribution score were computed;
- how issue-to-PR-to-code linkage was verified;
- how the builder profile changed.

## Link Your Historical Work

Developers can link previous work into this ledger without editing Markdown by hand.

Use the `Link historical work` issue form and provide:

- your GitHub handle;
- the project repo;
- upstream issue, PR, commit, review, release, or changelog links;
- your role in the work;
- outcome and label snapshots;
- suggested profile impact.

The ledger maintainer verifies the evidence before adding it to a weekly update and builder profile.

This repo is public. Do not post private code, customer data, internal links, unauthorized screenshots, or review content that cannot be public. Evidence that cannot be public should be marked `unclear` or reviewed through a separate private process.

## Contribution Verification And Scoring

A contribution enters profile scoring only after identity and evidence review.

- Self-claim: the submitter must be the original issue / PR / commit / review contributor.
- Platform review: the maintainer may verify unclear cases using GitHub API evidence or maintainer context.
- Issue closure: the system links issue -> PR -> commits/files -> review/merge before profile credit.
- Scoring: contribution score combines repository impact, work quality, issue complexity, role weight, and verification confidence.

See:

- [docs/contribution-model.md](docs/contribution-model.md)
- [docs/issue-pr-code-linking.md](docs/issue-pr-code-linking.md)

## Update Cycle

Default rhythm:

- Weekly: publish one `updates/YYYY-WXX.md` activity update.
- Monthly: add monthly notes to active builder profiles.

## Core Directories

- `updates/`: weekly activity updates.
- `profiles/`: builder profile history.
- `projects/`: tracked project indexes and repository profiles.
- `templates/`: reusable update, work item, scoring, profile, and project templates.
- `docs/`: contribution verification, scoring, and issue-to-code linkage models.

## Evidence Rule

Profile conclusions must point back to concrete evidence: issue, PR, review, labels, commit, release note, update entry, linkage record, or scoring record.

If the evidence is unclear, write `unclear`. Do not convert weak evidence into strong claims.

## Quality Labels

- `quality:strong`: merged with strong review or clear evidence of high-quality delivery.
- `quality:solid`: merged with no major review concerns.
- `quality:unclear`: not enough review or verification evidence.
- `quality:risky`: completed but carries maintenance, test, compatibility, or context risk.
- `quality:incomplete`: not completed, not merged, or closed without solving the core issue.
