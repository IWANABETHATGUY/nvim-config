# CLAUDE.md

## Commit messages

- Never reference another repo's issues or PRs in a commit message. This means no `owner/repo#123`, no `https://github.com/<owner>/<repo>/pull/123` or `/issues/123`, and no bare `#123` meant as an upstream number. GitHub turns these into a "referenced this pull request" entry on the upstream PR or issue, and upstream maintainers have asked us to stop.
- To point at an upstream fix, describe it in plain text, e.g. "Remove once Neovim's upstream fix for wiped-buffer folds is released."
- Code comments may still link upstream issues and PRs, because GitHub does not scan code for references.
