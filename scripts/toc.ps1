<#
.SYNOPSIS
    Extract table of contents from a markdown file.
.PARAMETER Path
    Path to the markdown file.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"
    exit 1
}

$lines = Get-Content $Path
$lineNumber = 0
$inCodeBlock = $false
$prevLine = $null
$prevLineNumber = 0
$prevLineWasATX = $false

foreach ($line in $lines) {
    $lineNumber++
    $isATX = $false

    # Toggle code block tracking (``` fences)
    if ($line -match '^```') {
        $inCodeBlock = -not $inCodeBlock
        $prevLine = $line
        $prevLineNumber = $lineNumber
        $prevLineWasATX = $false
        continue
    }

    if ($inCodeBlock) {
        $prevLine = $line
        $prevLineNumber = $lineNumber
        $prevLineWasATX = $false
        continue
    }

    if ($line -match '^(#{1,6})\s+(.+)') {
        $level = $Matches[1].Length
        $text  = $Matches[2].TrimEnd()
        $indent = '  ' * ($level - 1)
        $marker = '#' * $level
        Write-Output ("{0,5}  {1}{2} {3}" -f $lineNumber, $indent, $marker, $text)
        $isATX = $true
    } elseif ($line -match '^(=+|-+)\s*$' -and $null -ne $prevLine -and $prevLine -match '\S' -and -not $prevLineWasATX) {
        $isH1 = $line -match '^=+\s*$'
        $level = if ($isH1) { 1 } else { 2 }
        $text = $prevLine.Trim()
        $indent = '  ' * ($level - 1)
        $marker = '#' * $level
        Write-Output ("{0,5}  {1}{2} {3}" -f $prevLineNumber, $indent, $marker, $text)
    }

    $prevLine = $line
    $prevLineNumber = $lineNumber
    $prevLineWasATX = $isATX
}
