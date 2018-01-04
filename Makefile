NAME="The Great Escape"
GAME=TheGreatEscape
BUILD?=build
OPTIONS=--hex

.PHONY: usage
usage:
	@echo "Supported targets:"
	@echo "  usage		Show this help"
	@echo "  install	Install the $(NAME) support script"
	@echo "  all		Build everything"
	@echo "  disasm	Build the $(NAME) disassembly"
	@echo "  ctl		Build the $(NAME) control file"
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
disasm: $(GAME).skool
	skool2html.py $(OPTIONS) --asm-labels -o $(GAME).skool

.PHONY: ctl
ctl: $(BUILD)/$(GAME).ctl

$(BUILD)/$(GAME).ctl: $(GAME).skool
	mkdir -p $(BUILD)
	skool2ctl.py $(OPTIONS) $(GAME).skool > $@

.PHONY: asm
asm: $(BUILD)/$(GAME).asm

%.asm: ../%.skool
	mkdir -p $(BUILD)
	skool2asm.py -w $(OPTIONS) -c $< > $@

.PHONY: bin
bin: $(BUILD)/$(GAME).bin

%.bin: %.asm
	pasmo -v --bin $< $@

.PHONY: tap
tap: $(BUILD)/$(GAME).tap

%.tap: %.bin
	bin2tap.py --org 16384 --stack 65535 --start 61795 $<

.PHONY: z80
z80: $(BUILD)/$(GAME).z80

%.z80: ../%.skool
	skool2bin.py $< - | bin2sna.py --org 16384 --stack 65535 --start 61795 - $@

.PHONY: clean
clean:
	@echo 'Cleaning...'
	-rm -rf $(BUILD)

