The Great Escape
================

Reverse engineering Denton Designs' classic ZX Spectrum 48K game [The Great Escape](http://www.worldofspectrum.org/infoseekid.cgi?id=0002125) and rebuilding it in portable C.

Goals
-----

**Goal one** is to build a complete disassembly of the game using a C-style pseudocode (and Z80 fragments where C syntax cannot cope).

**Goal two** is to transform that C-style pseudocode into real C source code which behaves exactly like the original game.

Goal One - Reverse
------------------

### SkoolKit

I'm reversing the game with the help of [SkoolKit](http://pyskool.ca/?page_id=177), the rather nice toolkit for disassembling ZX Spectrum software written by Richard Dymond.

View an aperiodically updated version of the HTML disassembly [here](http://dpt.github.com/The-Great-Escape/).

Note that currently the disassembly is contained in a  _control_ file rather than a _skool_ file.

### Building the Disassembly

* Make a local clone of this repository.
* `cd <the repo>`.
* Drop a Z80 format snapshot of the game into the project directory. Call it `TheGreatEscape.z80`.
* `make install`. This will install TheGreatEscape.py into your ~/.skoolkit directory. You only have to do this once. (Note: If you wish to install into a different location you may have to customise the path inside `Makefile`).
* `make tge`.

You will see:

    $ make tge
    Using skool file: TheGreatEscape.skool
    Using ref file: TheGreatEscape.ref
    Parsing TheGreatEscape.skool
      Wrote TheGreatEscape/images/logo.png
      Writing disassembly files in TheGreatEscape/asm
      Writing TheGreatEscape/maps/all.html
      Writing TheGreatEscape/maps/routines.html
      Writing TheGreatEscape/maps/data.html
      Writing TheGreatEscape/maps/unused.html
      Writing TheGreatEscape/reference/bugs.html
      Writing TheGreatEscape/reference/facts.html
      Writing TheGreatEscape/reference/glossary.html
      Writing TheGreatEscape/index.html

* Open up `build/TheGreatEscape/index.html` in your browser.

### Currrent State

I don't grok all the code yet, so I have to be vague when naming symbols. You will notice stuff like:

* 'sub_*' names a function I don't know the purpose of.
* 'byte_*' and 'word_*' in this context mean 'something which I can see is accessed as a byte (or word) but I can't yet tell what it is.'
* Vague tokens like 'maybe', 'mystery', 'unsure' or 'possibly' indicate that I'm not quite sure of something.

As work progresses on the reimplementation many of the mysteries of the original will be revealed.

Goal Two - Reimplement
----------------------

The reimplementation is discussed in the 'reimplement' repository [here](https://github.com/dpt/The-Great-Escape-in-C).

