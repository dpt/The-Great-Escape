# SkoolKit extension for The Great Escape by Denton Designs.
#
# This file copyright (c) David Thomas, 2013. <dave@davespace.co.uk>
#

import string

from .skoolhtml import HtmlWriter, Udg
from .skoolasm import AsmWriter

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
        return "screen address $%x, length $%x, string='%s'" % (scraddr, nbytes, str)

    def tile(self, cwd, tile_index, supertile_index):
        """ Tile and supertile index -> Udg. """

        if supertile_index < 45:
            data = 0x8590 # ext tiles 1
        elif supertile_index < 139 or supertile_index >= 204:
            data = 0x8A18 # ext tiles 2
        else:
            data = 0x90F8 # ext tiles 3

        attr = 7
        a = data + tile_index * 8
        return Udg(attr, self.snapshot[a : a + 8])

    def supertile(self, cwd, addr):
        """ Supertile address -> image. """

        stile = (addr - 0x5B00) // 16

        # Build tile UDG array
        udg_array = []

        for i in range(4 * 4):
            if i % 4 == 0:
                udg_array.append([]) # start new row
            udg_array[-1].append(self.tile(cwd, self.snapshot[addr + i], stile))

        img_path_id = 'ScreenshotImagePath'
        fname = 'supertile-%x' % stile
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)

    def all_supertiles(self, cwd, unused_arg):
        s = ""
        for addr in range(0x5B00, 0x68A0, 16):
            s += self.supertile(cwd, addr)

        return s

    def map(self, cwd, addr, width, height):

        # Build tile UDG array
        udg_array = []

        for y in range(0, height * 4):
            udg_array.append([]) # start new row
            for x in range(0, width * 4):
                stileidx = self.snapshot[addr + (y // 4) * width + (x // 4)]
                udg_array[-1].append(self.tile(cwd, self.snapshot[0x5B00 + stileidx * 16 + (y & 3) * 4 + (x & 3)], stileidx))

        img_path_id = 'ScreenshotImagePath'
        fname = 'map'
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)


class TheGreatEscapeAsmWriter(AsmWriter):
    pass

