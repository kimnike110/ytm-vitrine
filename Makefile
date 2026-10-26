IPA ?= $(firstword $(wildcard ipa/*.ipa))
FLEX ?= 0
FLEX_ARG := $(if $(filter 0,$(FLEX)),--no-flex,)

.PHONY: all build release clean

all: release

build:
	./scripts/pipeline.sh $(IPA)

release:
	./scripts/pipeline.sh $(IPA) --no-flex

clean:
	@$(MAKE) -C tweak clean
	rm -rf out
