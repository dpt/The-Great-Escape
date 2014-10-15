BUILD?=build
OPTIONS=-H

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		Show this help"
	@echo "  install	Install the The Great Escape support"
	@echo "  tge		Build the The Great Escape disassembly"
	@echo "  clean		Clean a previous build"
	@echo ""
	@echo "Environment variables:"
	@echo "  BUILD          directory in which to build the disassemblies (default: build)"

.PHONY: install
install:
	mkdir -p ~/.skoolkit
	cp TheGreatEscape.py ~/.skoolkit

TGE=TheGreatEscape
.PHONY: tge
tge:
	mkdir -p $(BUILD)
	sna2skool.py $(OPTIONS) -R -c $(TGE).ctl $(TGE).z80 > $(BUILD)/$(TGE).skool 
	skool2html.py $(OPTIONS) -o $(BUILD)/$(TGE).skool

.PHONY: asm
asm:
	skool2asm.py -H -c $(BUILD)/$(TGE).skool > $(BUILD)/$(TGE).asm

.PHONY: clean
clean:
	@echo 'Cleaning...'
	-rm -rf $(BUILD)

