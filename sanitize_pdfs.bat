@echo off
setlocal
pushd "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Get-ChildItem -LiteralPath . -Filter '*.pdf' -File | ForEach-Object {" ^
  "  $old = $_.Name;" ^
  "  $base = [IO.Path]::GetFileNameWithoutExtension($old);" ^
  "  $newBase = ([regex]::Replace($base, '[^A-Za-z0-9]', '')).ToLowerInvariant();" ^
  "  if ([string]::IsNullOrWhiteSpace($newBase)) { Write-Host ('SKIP: {0} (empty after sanitize)' -f $old); return }" ^
  "  $newName = $newBase + $_.Extension;" ^
  "  if ($newName -ieq $old) { Write-Host ('OK  : {0} (no change)' -f $old); return }" ^
  "  if (Test-Path -LiteralPath $newName) { Write-Host ('SKIP: {0} -> {1} (target exists)' -f $old, $newName); return }" ^
  "  Rename-Item -LiteralPath $old -NewName $newName;" ^
  "  Write-Host ('REN : {0} -> {1}' -f $old, $newName)" ^
  "}"

popd
endlocal
pause
