# Issue To PR To Code Linkage

## Inputs

- Repository:
- Developer:
- Issue:
- PR:
- Commit(s):

## Link Evidence

- Closing keyword:
- Manual Development link:
- Issue timeline event:
- Commit association:
- LinkConfidence:

## Identity Evidence

- PR author:
- Commit author(s):
- Reviewer:
- Co-author trailer:
- IdentityConfidence:

## Resolution Evidence

- PR merged:
- Issue closed:
- Maintainer confirmation:
- Partial / follow-up notes:
- ResolutionConfidence:

## Semantic Evidence

- Issue intent:
- Files touched:
- Symbols / modules touched:
- Tests / docs:
- Review comments:
- Codegraph notes:
- SemanticFitConfidence:

## Final Decision

```text
ContributionResolutionConfidence = LinkConfidence * IdentityConfidence * ResolutionConfidence * SemanticFitConfidence
```

- ContributionResolutionConfidence:
- Profile action: add / hold / reject
- Reason:
