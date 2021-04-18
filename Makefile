.DEFAULT_GOAL := build

C = crystal
ARTIFACT = coin
LFLAGS =

build:
	$(C) build $(LFLAGS) src/coin.cr -o $(ARTIFACT)

build-release: LFLAGS += --release
build-release: build

static: LFLAGS += --static
static: build-release

clean:
	rm -f $(ARTIFACT) && rm -rf lib *.dwarf

tests:
	$(C) spec
