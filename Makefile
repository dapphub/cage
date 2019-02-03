SRC=src
ACT=act
DOC=doc
OUT=out

CAGE=cage.org

all: $(SRC)/cage.sol $(ACT)/cage.act $(DOC)/cage.html

build: $(SRC)/cage.sol
	dapp --use solc:0.4.24 build

doc: $(DOC)/cage.html

clean:
	rm -rf $(SRC) $(ACT) $(DOC)/cage.html $(OUT)

$(SRC)/ $(ACT)/ $(DOC)/:
	mkdir -p $@

$(SRC)/cage.sol: $(CAGE) | $(SRC)/
	nix-shell --pure --command 'orgdapp-sol $(CAGE)'

$(ACT)/cage.act: $(CAGE) | $(ACT)/
	nix-shell --pure --command 'orgdapp-act $(CAGE)'

$(DOC)/cage.html: $(CAGE) | $(DOC)/
	nix-shell --pure --command 'orgdapp-doc $(CAGE)'

# don't build by default
$(DOC)/theme.css: $(CAGE) | $(DOC)/
	nix-shell --pure --command 'orgdapp-css $(CAGE)'
