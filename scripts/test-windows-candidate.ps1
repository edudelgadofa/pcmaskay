param(
    [Parameter(Mandatory=$true)][string]$CandidateDir
)
$ErrorActionPreference = "Stop"
$CandidateDir = (Resolve-Path $CandidateDir).Path
$datadir = Join-Path $CandidateDir "share"
Write-Host "Testing candidate at: $CandidateDir"
foreach ($relative in @(
    "recoll.exe", "recollq.exe", "recollindex.exe",
    "platforms\qwindows.dll", "share\examples\recoll.conf",
    "poppler\Library\bin\pdftotext.exe"
)) {
    $file = Join-Path $CandidateDir $relative
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Required packaged file is missing: $relative"
    }
}
# Remove MSYS2/MINGW paths so runtime checks do not accidentally use build dependencies.
$cleanPath = (($env:PATH -split ";" | Where-Object {
    $_ -and $_ -notmatch '(?i)msys64|mingw64|[\\/]msys2[\\/]'
}) -join ";")
$env:PATH = "$CandidateDir;$(Join-Path $CandidateDir 'poppler\Library\bin');$cleanPath"
$env:RECOLL_DATADIR = $datadir
$version = (& (Join-Path $CandidateDir "recollq.exe") "-v" 2>&1 | Out-String)
if ($LASTEXITCODE -ne 0) { throw "recollq.exe -v failed: $version" }
Write-Host "CLI version: $version"
$temp = Join-Path $env:RUNNER_TEMP ("recoll-pro-smoke-" + [guid]::NewGuid().ToString("N"))
$docs = Join-Path $temp "documents"
$conf = Join-Path $temp "config"
New-Item -ItemType Directory -Path $docs,$conf -Force | Out-Null
try {
    $doc = Join-Path $docs "sample-document.txt"
    [IO.File]::WriteAllText($doc,"recollcanary2026 unique test phrase", [Text.UTF8Encoding]::new($false))
    $topdirs = $docs.Replace("\","/")
    [IO.File]::WriteAllText((Join-Path $conf "recoll.conf"), "topdirs = $topdirs`n", [Text.UTF8Encoding]::new($false))
    $env:RECOLL_CONFDIR = $conf
    Write-Host "Indexing one isolated test document"
    $idxout = (& (Join-Path $CandidateDir "recollindex.exe") "-c" $conf 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "recollindex failed: $idxout" }
    Write-Host "Searching for canary phrase"
    $query = (& (Join-Path $CandidateDir "recollq.exe") "-c" $conf "-b" "recollcanary2026" 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0 -or $query -notmatch "sample-document\.txt") {
        throw "Query did not find indexed document: $query"
    }
    Write-Host "PASS: packaged Recoll can index and search an isolated TXT file."
    # This checks process startup, not visual UI rendering in a real desktop.
    Write-Host "Checking GUI process startup (not an interactive visual test)"
    $proc = Start-Process -FilePath (Join-Path $CandidateDir "recoll.exe") -ArgumentList @("-c", $conf) -WorkingDirectory $CandidateDir -PassThru
    try {
        Start-Sleep -Seconds 5
        $proc.Refresh()
        if ($proc.HasExited) { throw "recoll.exe exited unexpectedly during startup (exit $($proc.ExitCode))" }
        Write-Host "PASS: GUI process remained running for five seconds."
    } finally {
        if (-not $proc.HasExited) {
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
} finally {
    Remove-Item Env:RECOLL_CONFDIR -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "Runtime smoke test passed (TXT and GUI-process checks only). PDF, Office and interactive rendering are NOT yet verified."
