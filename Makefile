NAME="The Great Escape"
GAME=TheGreatEscape
BUILD?=build
OPTIONS=-H

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		Show this help"
	@echo "  install	Install the $(NAME) support script"
	@echo "  all		Build everything"
	@echo "  disasm	Build the $(NAME) disassembly"
	@echo "  asm		Build the $(NAME) assembly"
	@echo "  bin		Build the $(NAME) binary image"
	@echo "  tap		Build the $(NAME) tape image"
	@echo "  clean		Clean a previous build"
	@echo ""
	@echo "Environment variables:"
	@echo "  BUILD          directory in which to build the disassemblies (default: build)"

# .PHONY rules are always run.

.PHONY: install
install:
	mkdir -p ~/.skoolkit
	cp $(GAME).py ~/.skoolkit

.PHONY: all
all: disasm tap

.PHONY: disasm
disasm:
	skool2html.py $(OPTIONS) -o $(GAME).skool

.PHONY: asm
asm: $(BUILD)/$(GAME).asm

%.asm: ../%.skool
	skool2asm.py $(OPTIONS) -c $< > $@

.PHONY: bin
bin: $(BUILD)/$(GAME).bin

%.bin: %.asm
	pasmo -v --bin $< $@

.PHONY: tap
tap: $(BUILD)/$(GAME).tap

%.tap: %.bin
	bin2tap.py --org 16384 --stack 65535 --start 61795 $<

.PHONY: clean
clean:
	@echo 'Cleaning...'
	-rm -rf $(BUILD)

