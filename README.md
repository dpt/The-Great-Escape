The Great Escape
================

This project reverse engineers [Denton Designs'](http://en.wikipedia.org/wiki/Denton_Designs) classic [ZX Spectrum](http://en.wikipedia.org/wiki/ZX_Spectrum) 48K game [The Great Escape](http://www.worldofspectrum.org/infoseekid.cgi?id=0002125) from a tape image of the original game into a cross-referenced and annotated HTML disassembly and full assembly source code, using [SkoolKit](http://skoolkit.ca/).

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

In addition to producing the cross-referenced HTML disassembly SkoolKit can also produce an annotated assembly listing. We can use this to reassemble the game to a .TAP file which you can load into an emulator. You can use it to alter the game and fix 30-year-old bugs!

Other SkoolKit disassemblies are normally written in a one comment per line style but I've chosen to attempt to reconstruct the logic of the original code as pseudo-C-style control structures. This makes it look weirder than I'd like but eases the conversion to C. My current work involves "normalising" the assembly: removing the pseudocode and replacing it with prose.

Building the Cross-Referenced Disassembly
-----------------------------------------

* First, [install SkoolKit](http://skoolkit.ca/docs/skoolkit/usage.html)
* Then make a local clone of this repository:
    * `git clone https://github.com/dpt/The-Great-Escape.git`
* Finally change to the repository and build the HTML format disassembly:
    * `cd <cloned repo>`
    * `make disasm`

If all's well you will see output like:

    $ make disasm
    tap2sna.py --output-dir build @TheGreatEscape.t2s && mv build/TheGreatEscape.z80 build/TheGreatEscape.pristine.z80
    Downloading http://www.worldofspectrum.org/pub/sinclair/games/g/GreatEscapeThe.tzx.zip
    Extracting The Great Escape.tzx
    Writing build/TheGreatEscape.z80
    mkdir -p build
    sna2skool.py --skool-hex --sft TheGreatEscape.sft build/TheGreatEscape.pristine.z80 > build/TheGreatEscape.skool
    Using skool file template: TheGreatEscape.sft
    skool2html.py --hex --asm-labels --rebuild-images build/TheGreatEscape.skool
    Using skool file: build/TheGreatEscape.skool
    Using ref files: TheGreatEscape.ref, TheGreatEscapeBugs.ref, TheGreatEscapeChangelog.ref, TheGreatEscapeFacts.ref, TheGreatEscapeGame.ref, TheGreatEscapeGlossary.ref, TheGreatEscapeGraphics.ref
    Parsing build/TheGreatEscape.skool
    Creating directory build/TheGreatEscape
    Copying /usr/local/lib/python3.6/site-packages/skoolkit/resources/skoolkit.css to build/TheGreatEscape/skoolkit.css
    Copying TheGreatEscape.css to build/TheGreatEscape/TheGreatEscape.css
    Copying static-images/BarbedWire.png to build/TheGreatEscape/static-images/BarbedWire.png
    Copying static-images/GameWindow.png to build/TheGreatEscape/static-images/GameWindow.png
    Copying static-images/JoystickControls.png to build/TheGreatEscape/static-images/JoystickControls.png
      Writing disassembly files in build/TheGreatEscape/asm
      Writing build/TheGreatEscape/maps/all.html
      Writing build/TheGreatEscape/maps/routines.html
      Writing build/TheGreatEscape/maps/data.html
      Writing build/TheGreatEscape/maps/messages.html
      Writing build/TheGreatEscape/maps/unused.html
      Writing build/TheGreatEscape/buffers/gbuffer.html
      Writing build/TheGreatEscape/reference/bugs.html
      Writing build/TheGreatEscape/reference/changelog.html
      Writing build/TheGreatEscape/reference/facts.html
      Writing build/TheGreatEscape/reference/glossary.html
      Writing build/TheGreatEscape/graphics/glitches.html
      Writing build/TheGreatEscape/Intro.html
      Writing build/TheGreatEscape/Controls.html
      Writing build/TheGreatEscape/Completion.html
      Writing build/TheGreatEscape/Characters.html
      Writing build/TheGreatEscape/Items.html
      Writing build/TheGreatEscape/Masks.html
    suggested width 17 > actual 16
      Writing build/TheGreatEscape/RoomObjects.html
      Writing build/TheGreatEscape/Rooms.html
      Writing build/TheGreatEscape/Map.html
      Writing build/TheGreatEscape/index.html

* Open up `build/TheGreatEscape/index.html` in your browser and dive in.

Building Runnable Games
-----------------------

* To build a .tap for loading into an emulator:
    * `make tap` will build `build/TheGreatEscape.tap`
* Or use `make z80` instead to build a .z80 image if you prefer.

Any of the above steps will invoke its prior step automatically.

To Edit, Rebuild and Run the Game
---------------------------------

* `make skool` -- to build the .skool file
* Edit `build/TheGreatEscape.skool`
* `make tap`
* Reload `build/TheGreatEscape.tap` in your emulator

Building the Assembly Source
----------------------------

If skool files are not to your taste and you prefer a regular assembly listing: `make asm` will build `build/TheGreatEscape.asm`. This can then be passed into Pasmo, for instance, to build a binary.

Current State of the Project
----------------------------

Work on reverse engineering progresses but slowly as this is a limited spare time (late night) project for me. (I've been chipping away at it since 2012...)

I switch between the reimplemented C version and the disassembly as while a disassembled function may make sense in of itself, transforming it into functioning C forces a great deal more detail to be thought about.

Presentation
------------

Here's the [slides from a presentation](http://slides.com/dpt/the-great-escape) I delivered to my colleagues about the project in January 2016.
