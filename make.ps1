# ==============================================================================
# DevBox-Foundry - Make Wrapper
# Forwards all arguments to bundled GNU Make
# ==============================================================================

& "$PSScriptRoot\tools\bin\make.exe" @args
exit $LASTEXITCODE
