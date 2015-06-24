TODO
====

24-Jun-2015
-----------

- [ ] Start a proper [changelog](http://keepachangelog.com/)
  - [ ] Including a retrospective changes for earlier releases
- [x] Migrate from a [control file](http://skoolkit.ca/docs/skoolkit/control-files.html) to a [skool file](http://skoolkit.ca/docs/skoolkit/skool-files.html)
  - [x] Add a build rule for skool -> ctl.
  - [ ] Preserve `;` comments which won't make it across
  - [ ] Change direct address references into label references
- [ ] Create images of every room in the HTML disassembly
  - [ ] Illustrate the room bounds too
- [ ] Add stats for the room objects (e.g. 'foo' used in 12 rooms, 'bar' used in 5 rooms)
  - [ ] Totals for every object
  - [ ] Totals per room
- [ ] Decode masks into images in the HTML disassembly
  - [ ] Include a variant of the exterior map with the masks shown atop it
- [ ] Add a a variant of the exterior map with a checkerboard pattern showing the supertiles (using the BRIGHT bit)
- [ ] Document the game rules
  - [ ] All items and their uses
  - [ ] The escape conditions
- [ ] Document the memory map
  - [ ] Overlapping ranges in particular
- [ ] Document graphic glitches
  - [ ] Guard graphic too low
  - [ ] Stray pixels on dog graphic
- [ ] Document all bugs noted in the code
- [ ] Add POKEs!
  - [ ] Infinite morale
- [ ] Import tap2sna script from @skoolkid
- [ ] Import `stack` changes from @skoolkid
- [ ] Improve the HTML disassembly's stylesheet
