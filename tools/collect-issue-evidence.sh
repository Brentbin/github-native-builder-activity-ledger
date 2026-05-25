#!/usr/bin/env bash
# Minimal L0 evidence collector for the Builder Guild.
# Pulls one issue + its linked PRs (closedByPullRequestsReferences + timeline)
# into a single JSON the L1 confidence layer can consume.
#
# v0.1 — bash + gh + jq. No pagination beyond first page. No retry. No batching.

set -euo pipefail

usage() {
  cat >&2 <<EOF
usage: $0 <owner/repo> <issue-number> [output-dir]

example:
  $0 facebook/react 12345
  $0 facebook/react 12345 /tmp/evidence

writes <output-dir>/<owner>__<repo>/issue-<n>.json
default output-dir: ./data
EOF
  exit 1
}

[[ $# -lt 2 ]] && usage

REPO="$1"
ISSUE="$2"
OUTDIR="${3:-data}"
OWNER="${REPO%%/*}"
NAME="${REPO#*/}"

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI not found" >&2; exit 2
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq not found" >&2; exit 2
fi

OUT_SUBDIR="$OUTDIR/${OWNER}__${NAME}"
mkdir -p "$OUT_SUBDIR"
OUT="$OUT_SUBDIR/issue-${ISSUE}.json"

# 1. Issue + linked PRs via GraphQL (single round-trip).
ISSUE_JSON=$(gh api graphql \
  -f owner="$OWNER" -f name="$NAME" -F num="$ISSUE" \
  -f query='
    query($owner:String!, $name:String!, $num:Int!) {
      repository(owner:$owner, name:$name) {
        issue(number:$num) {
          number title body url state stateReason
          author { login }
          createdAt closedAt
          labels(first:50)   { nodes { name color } }
          assignees(first:10){ nodes { login } }
          comments(first:50) { nodes { author { login } body createdAt } }
          timelineItems(first:100, itemTypes:[
            CLOSED_EVENT, REFERENCED_EVENT, CROSS_REFERENCED_EVENT, CONNECTED_EVENT, DISCONNECTED_EVENT
          ]) {
            nodes {
              __typename
              ... on ClosedEvent {
                createdAt actor { login }
                closer {
                  __typename
                  ... on PullRequest { number url }
                  ... on Commit      { oid url }
                }
              }
              ... on ReferencedEvent {
                createdAt actor { login }
                commit { oid url message }
              }
              ... on CrossReferencedEvent {
                createdAt actor { login }
                source {
                  __typename
                  ... on PullRequest { number url title }
                  ... on Issue       { number url title }
                }
              }
              ... on ConnectedEvent {
                createdAt actor { login }
                subject {
                  __typename
                  ... on PullRequest { number url }
                }
              }
            }
          }
          closedByPullRequestsReferences(first:10, includeClosedPrs:true) {
            nodes {
              number url title
              author { login }
              merged mergedAt closedAt baseRefName headRefName
            }
          }
        }
      }
    }')

# 2. For each linked PR, pull files + reviews + commits via REST.
LINKED_PRS=$(echo "$ISSUE_JSON" | jq -r '.data.repository.issue.closedByPullRequestsReferences.nodes[].number')

PR_DETAILS="[]"
for pr in $LINKED_PRS; do
  PR_META=$(gh api    "repos/$REPO/pulls/$pr")
  PR_FILES=$(gh api   "repos/$REPO/pulls/$pr/files")
  PR_REVIEWS=$(gh api "repos/$REPO/pulls/$pr/reviews")
  PR_COMMITS=$(gh api "repos/$REPO/pulls/$pr/commits")
  ONE=$(jq -n \
    --argjson meta    "$PR_META" \
    --argjson files   "$PR_FILES" \
    --argjson reviews "$PR_REVIEWS" \
    --argjson commits "$PR_COMMITS" \
    '{number: $meta.number, meta: $meta, files: $files, reviews: $reviews, commits: $commits}')
  PR_DETAILS=$(echo "$PR_DETAILS" | jq --argjson one "$ONE" '. + [$one]')
done

# 3. Compose final JSON.
jq -n \
  --arg collected_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg repo "$REPO" \
  --arg collector_version "0.1" \
  --argjson issue "$ISSUE_JSON" \
  --argjson prs "$PR_DETAILS" \
  '{
    collected_at: $collected_at,
    collector_version: $collector_version,
    repo: $repo,
    issue: $issue.data.repository.issue,
    linked_prs: $prs
  }' \
  > "$OUT"

echo "wrote $OUT"
