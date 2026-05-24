---
name: Work item tracking
description: Track one builder work item with upstream evidence
title: "[project] <builder>: <short work title>"
labels: []
body:
  - type: markdown
    attributes:
      value: "Track only work with concrete issue, PR, review, commit, or release evidence."
  - type: input
    id: builder
    attributes:
      label: Builder
      description: GitHub handle or mapped identity.
    validations:
      required: true
  - type: input
    id: project
    attributes:
      label: Project
      description: owner/repo or project name.
    validations:
      required: true
  - type: input
    id: upstream_issue
    attributes:
      label: Upstream issue
      description: Link to upstream issue if available.
  - type: input
    id: upstream_pr
    attributes:
      label: Upstream PR
      description: Link to upstream PR if available.
  - type: dropdown
    id: outcome
    attributes:
      label: Outcome
      options:
        - merged
        - open
        - closed-not-merged
        - abandoned
        - blocked
    validations:
      required: true
  - type: textarea
    id: labels_snapshot
    attributes:
      label: Labels snapshot
      description: Upstream labels and ledger labels.
    validations:
      required: true
  - type: textarea
    id: quality_evidence
    attributes:
      label: Quality evidence
      description: Review result, test evidence, docs evidence, risk note, and evidence links.
    validations:
      required: true
  - type: textarea
    id: profile_impact
    attributes:
      label: Profile impact
      description: Profile link and historical note to add.
