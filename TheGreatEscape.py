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

class TheGreatEscapeAsmWriter(AsmWriter):
    pass

