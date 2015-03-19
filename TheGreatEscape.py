# SkoolKit extension for The Great Escape by Denton Designs.
#
# This file copyright (c) David Thomas, 2013. <dave@davespace.co.uk>
#

import string

from skoolkit.skoolhtml import HtmlWriter, Udg
from skoolkit.skoolasm import AsmWriter

class TheGreatEscapeHtmlWriter(HtmlWriter):
    def init(self):
        self.font = {}
        pass

    def hello_world(self, cwd):
        return "Hello, world!"

    def decode_string(self, cwd, addr, nbytes):
        """ Decode a string. """
        alphabet = string.digits + string.uppercase[:14] + string.uppercase[15:] + " ."
        s = ""
        for i in range(addr, addr + nbytes):
            try:
                s += alphabet[self.snapshot[i]]
            except IndexError:
                s += "[%d]" % (self.snapshot[i])
        return s

    def decode_stringterminated(self, cwd, addr, terminator):
        """ Decode a string with the specified terminator. """
        nbytes = 0
        while self.snapshot[addr + nbytes] != terminator:
            nbytes += 1
        return self.decode_string(cwd, addr, nbytes)

    def decode_stringFF(self, cwd, addr):
        """ Decode a string with an 0xFF terminator. """
        return self.decode_stringterminated(cwd, addr, 0xFF)

    def decode_stringcounted(self, cwd, addr):
        """ Decode a counted string (first byte of string is length). """
        return self.decode_string(cwd, addr + 1, self.snapshot[addr])

    def decode_screenlocstring(self, cwd, addr):
        """ Decode a screenlocstring. """
        scraddr = self.snapshot[addr] + self.snapshot[addr + 1] * 256
        nbytes  = self.snapshot[addr + 2]
        str     = self.decode_string(cwd, addr + 3, nbytes)
        return "screen address $%X, length $%X, string='%s'" % (scraddr, nbytes, str)

    def tile(self, cwd, tile_index, supertile_index, mode):
        """ Tile and supertile index -> Udg. """

        if supertile_index < 45:
            data = 0x8590 # ext tiles 1
            attr = 70 # bright yellow over black
        elif supertile_index < 139 or supertile_index >= 204:
            data = 0x8A18 # ext tiles 2
            attr = 68 # bright green over black
        else:
            data = 0x90F8 # ext tiles 3
            attr = 69 # bright cyan over black

        if mode == 0:
            attr = 7 # white over black
        a = data + tile_index * 8
        return Udg(attr, self.snapshot[a : a + 8])

    def supertile(self, cwd, addr, mode):
        """ Supertile address -> image. """

        stile = (addr - 0x5B00) // 16

        # Build tile UDG array
        udg_array = []

        for i in range(4 * 4):
            if i % 4 == 0:
                udg_array.append([]) # start new row
            udg_array[-1].append(self.tile(cwd, self.snapshot[addr + i], stile, mode))

        img_path_id = 'ScreenshotImagePath'
        fname = 'supertile-%X' % stile
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)

    def all_supertiles(self, cwd, unused_arg):
        s = ""
        for addr in range(0x5B00, 0x68A0, 16):
            s += self.supertile(cwd, addr, 0)

        return s

    def map(self, cwd, addr, width, height, mode):

        # Build tile UDG array
        udg_array = []

        for y in range(height * 4):
            udg_array.append([]) # start new row
            for x in range(width * 4):
                stileidx = self.snapshot[addr + (y // 4) * width + (x // 4)]
                udg_array[-1].append(self.tile(cwd, self.snapshot[0x5B00 + stileidx * 16 + (y & 3) * 4 + (x & 3)], stileidx, mode))

        img_path_id = 'ScreenshotImagePath'
        fname = 'map-%d' % mode
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array, scale=1)

        return self.img_element(cwd, img_path)

    def interior_tile(self, cwd, tile_index):
        """ Interior tile -> Udg. """

        data = 0x9768
        attr = 7
        a = data + tile_index * 8
        return Udg(attr, self.snapshot[a : a + 8])

    def decode_all_objects(self, cwd, base, ents):
        s = ""
        for index,i in enumerate(range(base, base + ents * 2, 2)):
            addr = self.snapshot[i + 0] + self.snapshot[i + 1] * 256
            s += "<h3>$%.4x</h3>" % addr
            s += "<p>" + self.decode_object(cwd, addr, index) + "</p>"
        return s

    def decode_object(self, cwd, addr, index):
        width, height, tiles = self.expand_object(cwd, addr)

        tiles.reverse()

        # Build tile UDG array
        udg_array = []

        for y in range(height):
            udg_array.append([]) # start new row
            for x in range(width):
                udg_array[-1].append(self.interior_tile(cwd, tiles.pop()))

        img_path_id = 'ScreenshotImagePath'
        fname = 'object-%d' % index
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)

    def expand_object(self, cwd, addr):
        width  = self.snapshot[addr + 0]
        height = self.snapshot[addr + 1]

        iters = width * height

        s = []

        p = addr + 2
        while iters > 0:
            b = self.snapshot[p]
            p += 1
            if b == 0xFF:
                c = self.snapshot[p]
                p += 1
                if c == 0xFF:
                    s.append(c)
                    iters -= 1
                elif c >= 128: # repeat the next byte (c - 128) times
                    d = self.snapshot[p]
                    p += 1
                    for i in range(1, 1 + c - 128):
                        s.append(d)
                        iters -= 1
                elif c >= 64: # generate a range starting at <next byte> (c - 64) times
                    d = self.snapshot[p]
                    p += 1
                    for i in range(d, d + c - 64):
                        s.append(i)
                        iters -= 1
                elif c:
                    s.append(c)
                    iters -= 1
            else:
                s.append(b)
                iters -= 1

        return (width, height, s)

    def decode_all_rooms(self, cwd, base):
        data = self.snapshot[base:base + 52 * 2]
        rooms = []
        for lo, hi in zip(data[0::2], data[1::2]):
            rooms.append(lo + hi * 256)

        s = ""
        for addr in rooms:
            s += self.decode_room(cwd, addr)

        return s

    def decode_room(self, cwd, roomdef_addr):
        s = "<h3>Room at $%X</h3>" % roomdef_addr

        # Decode all room dimensions
        p = 0x6B85
        dims = []
        for i in range(10):
            dims.append((self.snapshot[p + 0], self.snapshot[p + 1], self.snapshot[p + 2], self.snapshot[p + 3]))
            p += 4

        p = roomdef_addr
        dimensions_index = self.snapshot[p]
        room_dims = dims[dimensions_index]
        p += 1

        s += "<ul>"

        s += "<li>" + "Dimensions: " + str(room_dims)

        nboundaries = self.snapshot[p]
        s += "<li>" + "Number of boundaries: %d" % nboundaries
        p += 1 + nboundaries * 4

        ntbd = self.snapshot[p]
        s += "<li>" + "Number of TBD: %d" % ntbd
        p += 1 + ntbd

        nobjs = self.snapshot[p]
        s += "<li>" + "Number of objects: %d" % nobjs
        p += 1

        s += "</ul>"

        return s

class TheGreatEscapeAsmWriter(AsmWriter):
    pass

