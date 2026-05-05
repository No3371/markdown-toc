#!/usr/bin/env bash
# Extract table of contents from a markdown file.
# Usage: toc.sh <path-to-markdown-file>

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-markdown-file>" >&2
    exit 1
fi

path=$1

if [ ! -f "$path" ]; then
    echo "File not found: $path" >&2
    exit 1
fi

awk '
BEGIN {
    in_code = 0
    prev_line = ""
    prev_ln = 0
    prev_was_atx = 0
}
{
    line = $0
    ln = NR
    is_atx = 0

    if (line ~ /^```/) {
        in_code = !in_code
        prev_line = line
        prev_ln = ln
        prev_was_atx = 0
        next
    }

    if (in_code) {
        prev_line = line
        prev_ln = ln
        prev_was_atx = 0
        next
    }

    if (match(line, /^(#{1,6})[ \t]+(.+)$/, m)) {
        level = length(m[1])
        text = m[2]
        sub(/[ \t]+$/, "", text)
        indent = ""
        for (i = 1; i < level; i++) indent = indent "  "
        marker = ""
        for (i = 1; i <= level; i++) marker = marker "#"
        printf "%5d  %s%s %s\n", ln, indent, marker, text
        is_atx = 1
    } else if (line ~ /^(=+|-+)[ \t]*$/ && prev_line != "" && prev_line ~ /[^ \t]/ && !prev_was_atx) {
        if (line ~ /^=+[ \t]*$/) level = 1; else level = 2
        text = prev_line
        sub(/^[ \t]+/, "", text)
        sub(/[ \t]+$/, "", text)
        indent = ""
        for (i = 1; i < level; i++) indent = indent "  "
        marker = ""
        for (i = 1; i <= level; i++) marker = marker "#"
        printf "%5d  %s%s %s\n", prev_ln, indent, marker, text
    }

    prev_line = line
    prev_ln = ln
    prev_was_atx = is_atx
}
' "$path"
