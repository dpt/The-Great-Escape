# Makefile for The Great Escape disassembly
#

NAME="The Great Escape"
GAME=TheGreatEscape
BUILD?=build
OPTIONS=--hex

CTL=$(GAME).ctl

ASM=$(BUILD)/$(GAME).asm
BIN=$(BUILD)/$(GAME).bin
PRISTINEZ80=$(BUILD)/$(GAME).pristine.z80
SKOOL=$(GAME).skool
TAP=$(BUILD)/$(GAME).tap
Z80=$(BUILD)/$(GAME).z80
GENERATED_CTL=$(BUILD)/$(GAME).ctl

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		Show this help"
	@echo "  all		Build virtually everything"
	@echo "  pristine	Fetch a tape image of $(NAME) and convert it into a pristine Z80 snapshot"
	@echo "  skool		Build a skool file from the control file and the snapshot"
	@echo "  disasm	Build the $(NAME) disassembly"
	@echo "  asm		Build assembly sources from the skool file"
	@echo "  z80		Build a Z80 snapshot from the skool file"
	@echo "  tap		Build a TAP file from the skool file"
	@echo "  ctl		Build a new control file from the skool file"
	@echo "  commit		Rebuild the main control file from the skool file"
	@echo "  clean		Clean a previous build"
	@echo ""
	@echo "Environment variables:"
	@echo "  BUILD          directory in which to build the disassemblies (default: build)"

# .PHONY rules are always run.

.PHONY: all
all: pristine skool disasm asm z80 tap

.PHONY: pristine
pristine: $(PRISTINEZ80)

$(PRISTINEZ80):
	tap2sna.py --output-dir $(BUILD) @$(GAME).t2s && mv $(BUILD)/$(GAME).z80 $(PRISTINEZ80)

.PHONY: skool
skool: $(SKOOL)

$(SKOOL): $(PRISTINEZ80) $(CTL)
	mkdir -p $(BUILD)
	sna2skool.py $(OPTIONS) --ctl $(CTL) $(PRISTINEZ80) > $@

.PHONY: disasm
disasm: $(SKOOL)
	skool2html.py $(OPTIONS) --asm-labels --rebuild-images $(SKOOL)

.PHONY: asm
asm: $(ASM)

$(ASM): $(SKOOL)
	mkdir -p $(BUILD)
	skool2asm.py $(OPTIONS) --create-labels --no-warnings $< > $@

.PHONY: z80
z80: $(Z80)

$(Z80): $(SKOOL)
	skool2bin.py $< - | bin2sna.py --org 16384 --stack 65535 --start 61795 - $@

.PHONY: tap
tap: $(TAP)

$(TAP): $(SKOOL)
	skool2bin.py $< - | bin2tap.py --org 16384 --stack 65535 --start 61795 - $@

.PHONY: ctl
ctl: $(GENERATED_CTL)

$(GENERATED_CTL): $(SKOOL)
	mkdir -p $(BUILD)
	skool2ctl.py $(OPTIONS) $(SKOOL) > $@

# Brings changes from .skool back to .ctl
# Use when ready for commit
.PHONY: commit
commit: ctl
	cp $(GENERATED_CTL) $(BUILD)/../

.PHONY: clean
clean:
	@echo 'Cleaning...'
	-rm -rf $(BUILD)

