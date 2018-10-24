# Makefile for The Great Escape disassembly
#

NAME="The Great Escape"
GAME=TheGreatEscape
BUILD?=build
OPTIONS=--hex

SFT=$(GAME).sft

ASM=$(BUILD)/$(GAME).asm
BIN=$(BUILD)/$(GAME).bin
CTL=$(BUILD)/$(GAME).ctl
PRISTINEZ80=$(BUILD)/$(GAME).pristine.z80
SKOOL=$(GAME).skool
TAP=$(BUILD)/$(GAME).tap
Z80=$(BUILD)/$(GAME).z80
GENERATED_SFT=$(BUILD)/$(GAME).sft

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		Show this help"
	@echo "  all		Build virtually everything"
	@echo "  pristine	Fetch a version of $(NAME) and output a pristine Z80 snapshot"
	@echo "  skool		Build a skool file from the skool file template + pristine Z80 snapshot"
	@echo "  disasm	Build the $(NAME) disassembly"
	@echo "  asm		Build the $(NAME) assembly"
	@echo "  z80		Build the $(NAME) Z80 snapshot"
	@echo "  tap		Build the $(NAME) TAP file"
	@echo "  sft		Build the $(NAME) skool file template"
	@echo "  ctl		Build the $(NAME) control file"
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

$(SKOOL): $(PRISTINEZ80) $(SFT)
	mkdir -p $(BUILD)
	sna2skool.py --hex --sft $(SFT) $(PRISTINEZ80) > $@

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

.PHONY: sft
sft: $(GENERATED_SFT)

$(GENERATED_SFT): $(SKOOL)
	mkdir -p $(BUILD)
	skool2sft.py $(OPTIONS) $(SKOOL) > $@

# Use when ready for commit
.PHONY: commit
commit: sft
	cp $(GENERATED_SFT) $(BUILD)/../

.PHONY: ctl
ctl: $(CTL)

$(CTL): $(SKOOL)
	mkdir -p $(BUILD)
	skool2ctl.py $(OPTIONS) $(SKOOL) > $@

.PHONY: clean
clean:
	@echo 'Cleaning...'
	-rm -rf $(BUILD)

