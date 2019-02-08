SRC=src
ACT=act
DOC=doc
OUT=out

CAGE=cage.org

DAPP=dapp

all: $(SRC)/cage.sol $(ACT)/cage.act $(DOC)/cage.html

build: $(SRC)/cage.sol
	$(DAPP) build

doc: $(DOC)/cage.html

test: build
	$(DAPP) test

clean:
	rm -rf $(SRC) $(ACT) $(DOC)/cage.html $(OUT)

$(SRC)/cage.sol: $(CAGE)
	nix-shell --pure --command 'orgdapp-sol $(CAGE)'

$(ACT)/cage.act: $(CAGE)
	nix-shell --pure --command 'orgdapp-act $(CAGE)'

$(DOC)/cage.html: $(CAGE)
	nix-shell --pure --command 'orgdapp-doc $(CAGE)'

# don't build by default
$(DOC)/theme.css: $(CAGE)
	nix-shell --pure --command 'orgdapp-css $(CAGE)'
