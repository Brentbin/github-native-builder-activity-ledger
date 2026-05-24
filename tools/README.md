# Tools

Scripts that feed the Builder Activity Ledger pipeline.

## `collect-issue-evidence.sh`

v0.1 minimal L0 evidence collector. Pulls one issue + its linked PRs into a single JSON the L1 confidence layer can consume.

### Usage

```bash
./tools/collect-issue-evidence.sh <owner/repo> <issue-number> [output-dir]
```

Writes `<output-dir>/<owner>__<repo>/issue-<n>.json`. Default `output-dir` is `./data`.

### Example

```bash
./tools/collect-issue-evidence.sh facebook/react 12345
# wrote data/facebook__react/issue-12345.json
```

### Output shape

```jsonc
{
  "collected_at": "2026-05-24T15:50:00Z",
  "collector_version": "0.1",
  "repo": "owner/name",
  "issue": {
    "number": 123, "title": "...", "body": "...", "state": "CLOSED",
    "author": { "login": "..." },
    "labels": { "nodes": [...] },
    "comments": { "nodes": [...] },
    "timelineItems": { "nodes": [/* ClosedEvent / Referenced / CrossReferenced / Connected */] },
    "closedByPullRequestsReferences": { "nodes": [/* PR refs */] }
  },
  "linked_prs": [
    {
      "number": 456,
      "meta":     { /* full PR object from REST /pulls/{n} */ },
      "files":    [ /* /pulls/{n}/files */ ],
      "reviews":  [ /* /pulls/{n}/reviews */ ],
      "commits":  [ /* /pulls/{n}/commits */ ]
    }
  ]
}
```

### Confidence inputs this enables

The JSON has enough for v0 of three out of four confidence scores:

| Confidence | Source field |
|---|---|
| `LinkConfidence` | `issue.closedByPullRequestsReferences.nodes` + `issue.timelineItems.nodes` (ClosedEvent.closer, CrossReferencedEvent.source) |
| `IdentityConfidence` | `linked_prs[].meta.user.login`, `linked_prs[].commits[].author.login`, `commits[].commit.message` (co-author trailers) |
| `ResolutionConfidence` | `linked_prs[].meta.merged` + `linked_prs[].meta.merged_at` + `issue.state` / `issue.closedAt` alignment |
| `SemanticFitConfidence` | **deferred** — `linked_prs[].files[].patch` is here, but the AI / codegraph layer is not yet built |

See [`docs/operating-spec.md` §12](../docs/operating-spec.md#12-issue-到-pr-到代码的闭环关联) for the full rubrics.

### Requirements

- `gh` CLI authenticated against the target repo's visibility (`gh auth status`)
- `jq`

### Limitations (v0.1)

- First page only: 100 timeline events, 10 closing-PR refs, 50 labels/assignees/comments. Large issues will be truncated silently.
- No retry on rate limit; if you hit it, rerun later.
- One issue per invocation. Batch with a shell loop for now.
- Reads only what the active `gh` account can see.
- No schema version negotiation; if GitHub deprecates a GraphQL field, edit the query in-place.

### Not yet (deliberate)

- Pagination, retry, batching, parallelism — wait for real volume before optimizing.
- Schema validation — write a real consumer first.
- Persistent store — flat JSON files are enough for pilot; introduce SQLite / DuckDB only if cross-issue analytics become routine.
