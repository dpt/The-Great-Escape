The Great Escape
================

This project reverse engineers [Denton Designs'](http://en.wikipedia.org/wiki/Denton_Designs) classic [ZX Spectrum](http://en.wikipedia.org/wiki/ZX_Spectrum) 48K game [The Great Escape](http://www.worldofspectrum.org/infoseekid.cgi?id=0002125) from a raw binary to a cross-referenced and annotated HTML disassembly, using [SkoolKit](http://skoolkit.ca/).

The Game
--------

_The Great Escape_ is a 1986 isometric 3D prison break game for the 48K ZX Spectrum where you play a POW trying to escape from a nazi prison camp. It's one of the best-regarded Spectrum games and I want to know how the [authors](https://www.mobygames.com/game/zx-spectrum/great-escape/credits) managed to pack all that magic into the 48K ZX Spectrum.

The Disassembly
---------------

[Read the disassembly here](http://dpt.github.com/The-Great-Escape/).

Note that the disassembly may lag behind the head of the source tree: it might not feature the very latest changes until I push an updated build.

Chat
----
[![Join the chat at https://gitter.im/The-Great-Escape/Lobby](https://badges.gitter.im/The-Great-Escape/Lobby.svg)](https://gitter.im/The-Great-Escape/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Goals
-----

My first goal is to build a fully documented disassembly of the game. SkoolKit lets us build both an annotated assembly listing suitable for rebuilding an exact image of the original game and a detailed cross-referenced disassembly in HTML format.

The second is to transform the annotated assembly into C source code which behaves exactly like the original game. The work-in-progress reimplementation project lives in [this repository](https://github.com/dpt/The-Great-Escape-in-C) and the two goals proceed in tandem.

SkoolKit
--------

[SkoolKit](http://skoolkit.ca/) is the peerless Python toolkit for disassembling ZX Spectrum software written by [Richard Dymond](https://github.com/skoolkid).

In addition to producing the cross-referenced HTML disassembly SkoolKit also produces an annotated assembly listing. We can use this to reassemble the game to a .TAP file which you can load into an emulator. You can use it to alter the game and fix 30-year-old bugs!

Other SkoolKit disassemblies are normally written in a one comment per line style but I've chosen to attempt to reconstruct the logic of the original code as pseudo-C-style control structures. This makes it look weirder than I'd like but eases the conversion to C. A later pass will probably remove the pseudocode and normalise the disassembly.

Building the Cross-Referenced Disassembly
-----------------------------------------

* First, make a local clone of this repository:
    * `git clone https://github.com/dpt/The-Great-Escape.git`
* Then change to the repository and install the support file:
    * `cd <cloned repo>`
    * `make install`
        * This will install `TheGreatEscape.py` into your `~/.skoolkit` directory. You only have to do this once. (Note: If you wish to install into a different location you may have to customise the path inside `Makefile`).
* Finally, build the HTML format disassembly:
    * `make disasm`

If all's well you will see output like:

    $ make disasm
    skool2html.py --hex -o TheGreatEscape.skool
    Using skool file: TheGreatEscape.skool
    Using ref files: TheGreatEscape.ref, TheGreatEscapeBugs.ref, TheGreatEscapeChangelog.ref, TheGreatEscapeFacts.ref, TheGreatEscapeGlossary.ref, TheGreatEscapeGraphics.ref
    Parsing TheGreatEscape.skool
    Creating directory build/TheGreatEscape
    Copying /usr/local/lib/python2.7/dist-packages/skoolkit-5.1-py2.7.egg/skoolkit/resources/skoolkit.css to build/TheGreatEscape/skoolkit.css
    Copying TheGreatEscape.css to build/TheGreatEscape/TheGreatEscape.css
      Writing disassembly files in build/TheGreatEscape/asm
      Writing build/TheGreatEscape/maps/all.html
      Writing build/TheGreatEscape/maps/routines.html
      Writing build/TheGreatEscape/maps/data.html
      Writing build/TheGreatEscape/maps/messages.html
      Writing build/TheGreatEscape/maps/unused.html
      Writing build/TheGreatEscape/buffers/gbuffer.html
      Writing build/TheGreatEscape/Characters.html
      Writing build/TheGreatEscape/Items.html
      Writing build/TheGreatEscape/Masks.html
    suggested width 17 > actual 16
      Writing build/TheGreatEscape/RoomObjects.html
      Writing build/TheGreatEscape/Rooms.html
      Writing build/TheGreatEscape/Map.html
      Writing build/TheGreatEscape/graphics/glitches.html
      Writing build/TheGreatEscape/reference/changelog.html
      Writing build/TheGreatEscape/reference/bugs.html
      Writing build/TheGreatEscape/reference/facts.html
      Writing build/TheGreatEscape/reference/glossary.html
      Writing build/TheGreatEscape/index.html

* Open up `build/TheGreatEscape/index.html` in your browser and dive in.

Building the Assembly and .tap
------------------------------

* To build the assembly source:
    * `make asm`
* To assemble the source into a .bin:
    * `make bin`
    * This step needs the [Pasmo](http://pasmo.speccy.org/) assembler. Use `sudo apt-get install pasmo` on Ubuntu, for example.
* To build the .tap for loading into an emulator:
    * `make tap`

Any of the above steps will invoke its prior step automatically.

Current State of the Project
----------------------------

Work on reverse engineering progresses but slowly as this is a limited spare time (late night) project for me. (I've been chipping away at it since 2012...)

I switch between the reimplemented C version and the disassembly as while a disassembled function may make sense in of itself, transforming it into functioning C forces a great deal more detail to be thought about.

Presentation
------------

Here's the [slides from a presentation](http://slides.com/dpt/the-great-escape) I delivered to my colleagues about the project in January 2016.
