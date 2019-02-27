SRC=src
ACT=act
DOC=doc
OUT=out

END=end.org

DAPP=dapp

all: $(SRC)/end.sol $(ACT)/end.act $(DOC)/end.html

build: $(SRC)/end.sol
	$(DAPP) build

doc: $(DOC)/end.html

test: build
	$(DAPP) test

clean:
	rm -rf $(SRC) $(ACT) $(DOC)/end.html $(OUT)

$(SRC)/end.sol: $(END)
	nix-shell --pure --command 'orgdapp-sol $(END)'

$(ACT)/end.act: $(END)
	nix-shell --pure --command 'orgdapp-act $(END)'

$(DOC)/end.html: $(END)
	nix-shell --pure --command 'orgdapp-doc $(END)'

# don't build by default
$(DOC)/theme.css: $(END)
	nix-shell --pure --command 'orgdapp-css $(END)'
