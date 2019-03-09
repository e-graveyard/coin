.DEFAULT_GOAL := build

C = crystal
ARTIFACT = coin

shards:
	if ! [ -d "./lib" ]; then shards install; fi

build: shards
	$(C) build src/coin.cr -o $(ARTIFACT)

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
