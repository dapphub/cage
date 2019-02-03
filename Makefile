SRC=src
ACT=act
DOC=doc
OUT=out

PRELUDE=make.el

EMACS=emacs --quick --batch --load=$(PRELUDE)

CAGE=cage.org

all: $(SRC)/cage.sol $(ACT)/cage.act $(DOC)/cage.html

solidity: $(SRC)/cage.sol

clean:
	rm -rf $(SRC) $(ACT) $(DOC)/cage.html $(OUT)

$(SRC)/ $(ACT)/ $(DOC)/:
	mkdir -p $@

$(SRC)/cage.sol: $(CAGE) $(PRELUDE) | $(SRC)/
	nix-shell --command '$(EMACS) --eval="(org-babel-tangle-file \"$(CAGE)\" nil \"sol\")"'

$(ACT)/cage.act: $(CAGE) $(PRELUDE) | $(ACT)/
	nix-shell --command '$(EMACS) --eval="(org-babel-tangle-file \"$(CAGE)\" nil \"act\")"'

$(DOC)/cage.html: $(CAGE) $(PRELUDE) | $(DOC)/
	nix-shell --command '$(EMACS) --eval="(make-html \"$(CAGE)\" \"$@\")"'

# don't build by default
INTERACTIVE_EMACS=emacs --quick --load=$(PRELUDE)
$(DOC)/theme.css: $(CAGE) $(PRELUDE) | $(DOC)/
	nix-shell --command '$(INTERACTIVE_EMACS) --eval="(make-css \"$(CAGE)\" \"$@\")"'
