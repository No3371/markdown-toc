---
name: markdown-toc
description: >
  Returns headings with line numbers from a markdown file. Use before reading
  a large markdown file to locate relevant sections without reading the whole thing.
---

# Markdown TOC

Run the bundled script to get the heading structure of a markdown file. A PowerShell and a Bash variant are both provided — pick the one that matches your shell.

## Usage

PowerShell:

```powershell
pwsh -NoProfile -File "<skill-dir>/scripts/toc.ps1" -Path "<file.md>"
```

Bash (Linux/macOS/WSL/Git Bash):

```bash
bash "<skill-dir>/scripts/toc.sh" "<file.md>"
```

## Output format

```
  LINE  HEADING
    12  # Top-level title
    34    ## Section
    56      ### Subsection
```

- Left column: line number to use with `Read` (offset parameter)
- Indentation reflects heading depth
- Headings inside fenced code blocks are excluded

## Workflow

1. Run `toc.ps1` or `toc.sh` to get the structure
2. Identify which sections are relevant to the task
3. Read only those sections using the line numbers as offsets
