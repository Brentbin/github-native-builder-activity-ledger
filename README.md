# GitHub-native Builder Activity Ledger

A fixed-cycle GitHub activity ledger for tracking who completed what work in which projects, with issue/PR evidence, quality labels, and builder profile history.

## What This Repo Tracks

This repo is not a chat community, bounty board, or accelerator. It is a working ledger.

Each update records:

- who worked on which project;
- which issue / PR / commit proves the work;
- whether the work was merged, still open, blocked, abandoned, or closed without merge;
- which upstream labels and local ledger labels apply;
- what quality evidence exists;
- how the builder profile changed.

## Update Cycle

Default rhythm:

- Weekly: publish one `updates/YYYY-WXX.md` activity update.
- Monthly: add monthly notes to active builder profiles.

## Core Directories

- `updates/`: weekly activity updates.
- `profiles/`: builder profile history.
- `projects/`: tracked project indexes.
- `templates/`: reusable update, work item, profile, and project templates.

## Evidence Rule

Profile conclusions must point back to concrete evidence: issue, PR, review, labels, commit, release note, or update entry.

If the evidence is unclear, write `unclear`. Do not convert weak evidence into strong claims.

## Quality Labels

- `quality:strong`: merged with strong review or clear evidence of high-quality delivery.
- `quality:solid`: merged with no major review concerns.
- `quality:unclear`: not enough review or verification evidence.
- `quality:risky`: completed but carries maintenance, test, compatibility, or context risk.
- `quality:incomplete`: not completed, not merged, or closed without solving the core issue.
