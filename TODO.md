TODO
====

26-Jun-2015
-----------

- [ ] Document everything!
  - [ ] Add descriptions for every byte of the skool file
    - [ ] Including register descriptions
  - [ ] Add a reversal status for every function. (complete, incomplete)
- [ ] Sort out the inverted masks issue
- [ ] Use SkoolKit # refs more
  - [ ] Currently using (<- somefunc) to show a reference
- [ ] Check occurrences of LDIR I've converted to memcpy where I've not accounted for DE and HL being incremented...

25-Jun-2015
-----------

- [ ] Assign IDs to bugs so they can be mentioned in more than one location in the disassembly.

24-Jun-2015
-----------

- [ ] Start a proper [changelog](http://keepachangelog.com/)
  - [ ] Including a retrospective changes for earlier releases
- [x] Migrate from a [control file](http://skoolkit.ca/docs/skoolkit/control-files.html) to a [skool file](http://skoolkit.ca/docs/skoolkit/skool-files.html)
  - [x] Add a build rule for skool -> ctl.
  - [x] Preserve `;` comments which won't make it across
  - [ ] Change direct address references into label references
  - [ ] Split skool file up into parts
- [x] Create images of every room in the HTML disassembly
  - [ ] Illustrate the room bounds too
- [x] Add stats for the room objects (e.g. 'foo' used in 12 rooms, 'bar' used in 5 rooms)
  - [ ] Totals for every object
  - [ ] Totals per room
- [x] Decode masks into images in the HTML disassembly
  - [ ] Include a variant of the exterior map with the masks shown atop it
- [ ] Add a a variant of the exterior map with a checkerboard pattern showing the supertiles (using the BRIGHT bit)
- [ ] Document the game rules
  - [ ] All items and their uses
  - [ ] The escape conditions
- [ ] Document the memory map
  - [ ] In particular map out the game state at $8000+ which overlaps static tile graphics
- [ ] Document graphic glitches
  - [x] Guard graphic too low
  - [ ] Stray pixels on dog graphic
- [ ] Document all bugs noted in the code
- [ ] Add POKEs!
  - [ ] Infinite morale
- [x] Import tap2sna script from @skoolkid
- [x] Import `stack` changes from @skoolkid
- [ ] Improve the HTML disassembly's stylesheet
