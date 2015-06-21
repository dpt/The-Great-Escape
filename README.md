The Great Escape
================

Reverse engineering [Denton Designs'](http://en.wikipedia.org/wiki/Denton_Designs) classic [ZX Spectrum](http://en.wikipedia.org/wiki/ZX_Spectrum) 48K game [The Great Escape](http://www.worldofspectrum.org/infoseekid.cgi?id=0002125) from a raw binary image using [SkoolKit](http://skoolkit.ca/).

Goals
-----

**Goal one** is to build a fully documented disassembly of the game. SkoolKit enables us to generate both an annotated assembly listing suitable for rebuilding an exact image of the original game and a detailed cross-referenced disassembly in HTML format.

**Goal two** is to transform the annotated assembly into working C source code which behaves exactly like the original game. The work-in-progress reimplementation project lives in [a separate repository](https://github.com/dpt/The-Great-Escape-in-C).

SkoolKit
--------

[SkoolKit](http://skoolkit.ca/) is the awesome Python toolkit for disassembling ZX Spectrum software written by Richard Dymond.

You can view the current cross-referenced disassembly [here](http://dpt.github.com/The-Great-Escape/). Note that this can lag behind the head of the source tree.

You can also disassemble and reassemble the game to a .TAP file which you can load into an emulator. (e.g. you can alter the game and fix 30-year-old bugs!)

SkoolKit disassemblies are normally written in a plain text comment style but I've chosen to use a C-family-style pseudocode and Z80 fragments where C syntax cannot cope. Wise decision? Time will tell.

Also note that currently the disassembly is contained in a  _control_ file (a comments-only format) rather than a _skool_ file (all instructions and comments).


Building the Disassembly
------------------------

* First, make a local clone of this repository: `git clone https://github.com/dpt/The-Great-Escape.git`
* `cd <cloned repo>`.
* Drop a Z80 format snapshot of the game into the project directory. Call it `TheGreatEscape.z80`.
* `make install`. This will install `TheGreatEscape.py` into your `~/.skoolkit` directory. You only have to do this once. (Note: If you wish to install into a different location you may have to customise the path inside `Makefile`).
* `make disasm`. To build the HTML format disassembly.

If all's well you will see:

    $ make disasm
    mkdir -p build
    sna2skool.py -H -R -c TheGreatEscape.ctl TheGreatEscape.z80 > build/TheGreatEscape.skool
    skool2html.py -H -o build/TheGreatEscape.skool
    Using skool file: build/TheGreatEscape.skool
    Using ref files: TheGreatEscape.ref, TheGreatEscapeBugs.ref, TheGreatEscapeFacts.ref, TheGreatEscapeGlossary.ref, TheGreatEscapeGraphics.ref
    Parsing build/TheGreatEscape.skool
    Creating directory build/TheGreatEscape
    Copying /Library/Python/2.7/site-packages/skoolkit/resources/skoolkit.css to build/TheGreatEscape/skoolkit.css
    Copying TheGreatEscape.css to build/TheGreatEscape/TheGreatEscape.css
      Writing disassembly files in build/TheGreatEscape/asm
      Writing build/TheGreatEscape/maps/all.html
      Writing build/TheGreatEscape/maps/routines.html
      Writing build/TheGreatEscape/maps/data.html
      Writing build/TheGreatEscape/maps/messages.html
      Writing build/TheGreatEscape/maps/unused.html
      Writing build/TheGreatEscape/Characters.html
      Writing build/TheGreatEscape/Items.html
      Writing build/TheGreatEscape/RoomObjects.html
      Writing build/TheGreatEscape/Rooms.html
      Writing build/TheGreatEscape/Map.html
      Writing build/TheGreatEscape/graphics/glitches.html
      Writing build/TheGreatEscape/reference/bugs.html
      Writing build/TheGreatEscape/reference/facts.html
      Writing build/TheGreatEscape/reference/glossary.html
      Writing build/TheGreatEscape/index.html

* Open up `build/TheGreatEscape/index.html` in your browser and dive in.

Building the Reassembly
-----------------------

* `make asm` to build just the assembly source.
* `make bin` to build assembly and binary. This step needs the [Pasmo](http://pasmo.speccy.org/) assembler.
* `make tap` to build assembly, binary and .tap file for loading into an emulator.

Currrent State
--------------

I don't grok all the code yet, so I have to be vague when naming symbols. You will notice stuff like:

* 'sub_*' names a function I don't know the purpose of.
* 'byte_*' and 'word_*' in this context mean 'something which I can see is accessed as a byte (or word) but I can't yet tell what it is.'
* Vague tokens like 'maybe', 'mystery', 'unsure' or 'possibly' indicate that I'm not quite sure of something.

As work progresses on the reimplementation many of the mysteries of the original will be revealed.
