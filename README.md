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
    sna2skool.py --hex --sft TheGreatEscape.sft build/TheGreatEscape.pristine.z80 > TheGreatEscape.skool
    Using skool file template: TheGreatEscape.sft
    skool2html.py --hex --asm-labels --rebuild-images TheGreatEscape.skool
    Using ref files: TheGreatEscape.ref, TheGreatEscapeBugs.ref, TheGreatEscapeChangelog.ref, TheGreatEscapeFacts.ref, TheGreatEscapeGame.ref, TheGreatEscapeGlossary.ref, TheGreatEscapeGraphics.ref
    Parsing TheGreatEscape.skool
    Output directory: build/TheGreatEscape
    Copying /usr/local/lib/python3.7/site-packages/skoolkit/resources/skoolkit.css to skoolkit.css
    Copying TheGreatEscape.css to TheGreatEscape.css
    Copying static-images/BarbedWire.png to static-images/BarbedWire.png
    Copying static-images/GameWindow.png to static-images/GameWindow.png
    Copying static-images/JoystickControls.png to static-images/JoystickControls.png
    Writing disassembly files in asm
    Writing maps/all.html
    Writing maps/routines.html
    Writing maps/data.html
    Writing maps/messages.html
    Writing maps/unused.html
    Writing buffers/gbuffer.html
    Writing reference/bugs.html
    Writing reference/changelog.html
    Writing reference/facts.html
    Writing reference/glossary.html
    Writing graphics/glitches.html
    Writing Intro.html
    Writing Controls.html
    Writing Completion.html
    Writing Characters.html
    Writing Items.html
    Writing Masks.html
    suggested width 17 > actual 16
    Writing RoomObjects.html
    Writing Rooms.html
    Writing Map.html
    Writing index.html

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
* Edit `TheGreatEscape.skool`
* `make tap`
* Reload `build/TheGreatEscape.tap` in your emulator

Building the Assembly Source
----------------------------

If skool files are not to your taste and you prefer a regular assembly listing: `make asm` will build `build/TheGreatEscape.asm`. This can then be passed into Pasmo, for instance, to build a binary.

Current State of the Project
----------------------------

The reverse engineering of the game is now complete, but work will continue to improve the accuracy and readability of the disassembly.

Presentation
------------

Here's the [slides from a presentation](http://slides.com/dpt/the-great-escape) I delivered to my colleagues about the project in January 2016. There's a [more recently updated version too](https://slides.com/dpt/the-great-escape-42cbed).

Write-up
--------

In 2019 I did a big write-up about the project: http://www.davespace.co.uk/the.great.escape/
