.DEFAULT_GOAL := build

C = crystal
ARTIFACT = coin
LFLAGS = --release

shards:
	if ! [ -d "./lib" ]; then shards install; fi

build:
	$(C) build $(LFLAGS) src/coin.cr -o $(ARTIFACT)

static: LFLAGS += --static
static: build

install:
	mv $(ARTIFACT) /usr/bin

uninstall:
	rm /usr/bin/$(ARTIFACT)

run:
	./$(ARTIFACT)

clean:
	rm -f $(ARTIFACT) && rm -rf lib

test:
	$(C) spec
