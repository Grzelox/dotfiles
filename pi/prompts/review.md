---
description: Review staged git changes for bugs, security, and quality
argument-hint: "[file]"
---
Review the staged changes (`git diff --cached ${1:-}`). Focus on:
- Bugs and logic errors
- Security issues (injection, path traversal, secrets)
- Error handling gaps
- Performance concerns
- Test coverage gaps
- Code style and readability

Be specific about what needs to change and why.