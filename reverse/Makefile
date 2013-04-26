BUILD?=build
OPTIONS=-H

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		show this help"
	@echo "  install	install the The Great Escape support"
	@echo "  tge		build the The Great Escape disassembly"
	@echo ""
	@echo "Environment variables:"
	@echo "  BUILD          directory in which to build the disassemblies (default: build)"

.PHONY: install
install:
	sudo cp TheGreatEscape.py /Library/Python/2.7/site-packages/skoolkit/

TGE=TheGreatEscape
.PHONY: tge
tge:
	mkdir -p $(BUILD)
	sna2skool.py $(OPTIONS) -c $(TGE).ctl $(TGE).z80 > $(BUILD)/$(TGE).skool 
	skool2html.py $(OPTIONS) -o $(BUILD)/$(TGE).skool
