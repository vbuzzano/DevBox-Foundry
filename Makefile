SHELL = cmd.exe
RELEASE ?= amiga
MSG ?=

.DEFAULT_GOAL := build
.PHONY: 	help build clean release commit push

help:
	@pwsh -NoProfile -File scripts\help.ps1

build:
	@pwsh -NoProfile -File scripts\dist.ps1 -Release $(RELEASE)

clean:
	@pwsh -NoProfile -File scripts\clean.ps1

release: build
	@pwsh -NoProfile -File scripts\release.ps1

commit:
	@pwsh -NoProfile -File scripts\commit.ps1 -Message "$(MSG)"

push:
	@pwsh -NoProfile -File scripts\push.ps1