The Great Escape
================

Reverse engineering Denton Designs' classic ZX Spectrum 48K game [The Great Escape](http://www.worldofspectrum.org/infoseekid.cgi?id=0002125).

SkoolKit
--------

I'm reversing the game using [SkoolKit](http://pyskool.ca/?page_id=177). This is the rather nice toolkit for disassembling ZX Spectrum software written by Richard Dymond.

View an aperiodically updated version of the HTML disassembly [here](http://dpt.github.com/The-Great-Escape/).

Currently the disassembly is _control_ file based rather than _skool_ file based.

Goals
-----

Goal one is to build a complete disassembly of the game using a C-style pseudocode (and Z80 fragments where C syntax cannot cope).

Goal two is to transform that C-style pseudocode into real C source code which behaves exactly as the original game does.

Instructions
------------

* Make a local clone of this repository.
* Drop a Z80 format snapshot of the game into the project directory. Call it TheGreatEscape.z80.
* Run kit.sh.

You will see:

    $ ./kit.sh 
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

* Open up TheGreatEscape/index.html in your browser.

Syntax Considerations
---------------------

C's curly bracket syntax conflicts with SkoolKit's so you'll notice I'll often replace them with angle brackets.

Vagueness
---------

I don't grok all the code yet, so I have to be vague when naming symbols. :-) You may notice stuff like:

* 'sub_*' is a function I don't know the purpose of.
* 'byte_*' and 'word_*' in this context mean 'something which I can see is accessed as a byte (or word) but I can't yet tell what it is.'
* 'mystery' is not yet understood.
* 'unsure' is suspected purpose but not confident.
* Vague tokens like 'maybe' or 'possibly' indicate that I'm not quite sure of something.
