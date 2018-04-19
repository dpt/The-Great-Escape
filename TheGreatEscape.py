# SkoolKit extension for The Great Escape by Denton Designs.
#
# This file copyright (c) David Thomas, 2013-2018. <dave@davespace.co.uk>
#

import string

from skoolkit.graphics import Udg
from skoolkit.skoolhtml import HtmlWriter
from skoolkit.skoolasm import AsmWriter

ZX_ATTRIBUTE_BRIGHT                     = 64

ZX_ATTRIBUTE_BLUE_OVER_BLACK            = 1
ZX_ATTRIBUTE_RED_OVER_BLACK             = 2
ZX_ATTRIBUTE_PURPLE_OVER_BLACK          = 3
ZX_ATTRIBUTE_GREEN_OVER_BLACK           = 4
ZX_ATTRIBUTE_CYAN_OVER_BLACK            = 5
ZX_ATTRIBUTE_YELLOW_OVER_BLACK          = 6
ZX_ATTRIBUTE_WHITE_OVER_BLACK           = 7
ZX_ATTRIBUTE_BRIGHT_BLUE_OVER_BLACK     = 65
ZX_ATTRIBUTE_BRIGHT_RED_OVER_BLACK      = 66
ZX_ATTRIBUTE_BRIGHT_PURPLE_OVER_BLACK   = 67
ZX_ATTRIBUTE_BRIGHT_GREEN_OVER_BLACK    = 68
ZX_ATTRIBUTE_BRIGHT_CYAN_OVER_BLACK     = 69
ZX_ATTRIBUTE_BRIGHT_YELLOW_OVER_BLACK   = 70
ZX_ATTRIBUTE_BRIGHT_WHITE_OVER_BLACK    = 71

class TheGreatEscapeHtmlWriter(HtmlWriter):
    def init(self):
        self.font = {}

    # Internal
    def _decode_string(self, cwd, addr, nbytes):
        """ Decode a string. """
        alphabet = string.digits + string.ascii_uppercase[:14] + string.ascii_uppercase[15:] + " ."
        s = ""
        for i in range(addr, addr + nbytes):
            try:
                s += alphabet[self.snapshot[i]]
            except IndexError:
                s += "[%d]" % (self.snapshot[i])
        return s

    # API
    def decode_stringterminated(self, cwd, addr, terminator):
        """ Decode a string with the specified terminator. """
        nbytes = 0
        while self.snapshot[addr + nbytes] != terminator:
            nbytes += 1
        return self._decode_string(cwd, addr, nbytes)

    # API
    def decode_stringFF(self, cwd, addr):
        """ Decode a string with an 0xFF terminator. """
        return self.decode_stringterminated(cwd, addr, 0xFF)

    # API
    def decode_stringcounted(self, cwd, addr):
        """ Decode a counted string (first byte of string is length). """
        return self._decode_string(cwd, addr + 1, self.snapshot[addr])

    # API
    def decode_screenlocstring(self, cwd, addr):
        """ Decode a screenlocstring. """
        scraddr = self.snapshot[addr] + self.snapshot[addr + 1] * 256
        nbytes  = self.snapshot[addr + 2]
        str     = self._decode_string(cwd, addr + 3, nbytes)
        return "screen address $%X, length $%X, string='%s'" % (scraddr, nbytes, str)

    # Internal
    def _tile(self, cwd, tile_index, supertile_index, colour_supertiles, override_bright):
        """ Tile and supertile index -> Udg. """

        if supertile_index < 45:
            data = 0x8590  # ext tiles 1
            attr = ZX_ATTRIBUTE_BRIGHT_YELLOW_OVER_BLACK
        elif supertile_index < 139 or supertile_index >= 204:
            data = 0x8A18  # ext tiles 2
            attr = ZX_ATTRIBUTE_BRIGHT_GREEN_OVER_BLACK
        else:
            data = 0x90F8  # ext tiles 3
            attr = ZX_ATTRIBUTE_BRIGHT_CYAN_OVER_BLACK

        if colour_supertiles == 0:
            # assume coloured tiles unless off
            attr = ZX_ATTRIBUTE_WHITE_OVER_BLACK

        if override_bright is not None:
            # force bright bit to the specified state
            attr = (attr & ~ZX_ATTRIBUTE_BRIGHT) | (override_bright * ZX_ATTRIBUTE_BRIGHT)

        offset = data + tile_index * 8
        return Udg(attr, self.snapshot[offset: offset + 8])

    # Internal
    def _supertile_prime(self, cwd, addr, colour_supertiles, checkerboard):
        """ Return an image for the supertile at the specified address. """

        stile = (addr - 0x5B00) // 16

        # Build tile UDG array
        udg_array = []

        for i in range(4 * 4):
            if i % 4 == 0:
                udg_array.append([])  # start new row
            bright = ((i // 4) & 1 ^ i & 1) if checkerboard else False
            tile = self._tile(cwd,
                              self.snapshot[addr + i],
                              stile,
                              colour_supertiles,
                              bright)
            udg_array[-1].append(tile)

        img_path_id = 'ScreenshotImagePath'
        fname = 'supertile-%X-%d-%d' % (stile, colour_supertiles, checkerboard)
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)

    # API
    def supertile(self, cwd, addr, colour_supertiles):
        """ Return an image for the supertile at the specified address. """
        return self._supertile_prime(cwd, addr, colour_supertiles, True)

    # Unused
    def all_supertiles(self, cwd, unused_arg):
        s = ""
        for addr in range(0x5B00, 0x68A0, 16):
            s += self.supertile(cwd, addr, 0, None)

        return s

    # Internal
    def _get_map_as_udgs(self, cwd, addr, width, height, colour_supertiles, checkerboard):
        """ Return the game map in UDG form. """

        # Build tile UDG array
        map_udgs = []

        for y in range(height * 4):
            map_udgs.append([])  # start new row
            for x in range(width * 4):
                stileidx = self.snapshot[addr + (y // 4) * width + (x // 4)]
                bright = ((x // 4) ^ (y // 4)) & 1 if checkerboard else False
                tile = self._tile(cwd,
                                  self.snapshot[0x5B00 + stileidx * 16 + (y & 3) * 4 + (x & 3)],
                                  stileidx,
                                  colour_supertiles,
                                  bright)
                map_udgs[-1].append(tile)

        return map_udgs

    # API
    def map(self, cwd, addr, width, height, colour_supertiles, checkerboard):
        """ Get a UDG game map then save it and return an IMG element. """

        map_udgs = self._get_map_as_udgs(cwd, 0xBCEE, width, height, colour_supertiles, checkerboard)

        img_path_id = 'ScreenshotImagePath'
        fname = 'map-%d-%d' % (colour_supertiles, checkerboard)
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, map_udgs, scale=1)

        return self.img_element(cwd, img_path)

# -----------------------------------------------------------------------------

    # Internal
    def _interior_tile(self, cwd, tile_index):
        """ Interior tile -> Udg. """

        data = 0x9768
        attr = 7
        a = data + tile_index * 8
        return Udg(attr, self.snapshot[a: a + 8])

    # API
    def decode_all_objects(self, cwd, base, ents):
        unused = (21, 28, 39)
        s = ""
        for index, i in enumerate(range(base, base + ents * 2, 2)):
            if index in unused:
                continue
            addr = self.snapshot[i + 0] + self.snapshot[i + 1] * 256
            s += "<h3>%s @ $%.4x</h3>" % (self.interiorobject_name(index),
                                          addr)
            s += "<p>" + self.decode_object(cwd, addr, index) + "</p>"
        return s

    # API
    def decode_object(self, cwd, addr, index):
        width, height, tiles = self._expand_object(cwd, addr)

        tiles.reverse()

        # Build tile UDG array
        udg_array = []

        for y in range(height):
            udg_array.append([])  # start new row
            for x in range(width):
                udg_array[-1].append(self._interior_tile(cwd, tiles.pop()))

        img_path_id = 'ScreenshotImagePath'
        fname = 'object-%d' % index
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)

    # Internal
    def _expand_object(self, cwd, addr):
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
                elif c >= 128:  # repeat the next byte (c - 128) times
                    d = self.snapshot[p]
                    p += 1
                    for i in range(1, 1 + c - 128):
                        s.append(d)
                        iters -= 1
                elif c >= 64:  # generate a range starting at <next byte> (c - 64) times
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

# -----------------------------------------------------------------------------

    # Internal
    def _mask_tile(self, cwd, tile_index):
        """ Mask tile -> Udg. """

        data = 0x8218
        attr = 7
        a = data + tile_index * 8
        return Udg(attr, self.snapshot[a: a + 8])

    # API
    def decode_masks(self, cwd, base, ents):
        """ Decode masks. """

        # There are no heights given in the actual mask data so we must use the
        # bounds of the $EC01 and $EA7C tables to work out the worst case and
        # use that (for exterior masks).
        if base == 0xEBC5:
            struct = (0xEC01, 0xEDD1, 8)
        elif base == 0xEBE3:
            # The structures at $EA7C stride is one byte shorter than mask_t
            # since the constant final byte is removed.
            struct = (0xEA7C, 0xEBC5, 7)

        # Collect dicts of lists of dimensions, keyed by ref. Each mask may
        # have multiple uses with different dimensions so we collect them here
        # to work out the largest.
        widths = {}
        heights = {}

        # Force all lists of widths and heights to be present but empty because
        # mask 19 is unused.
        for ref in range(30):
            widths.setdefault(ref, [])
            heights.setdefault(ref, [])

        data, dataend, stride = struct
        while data < dataend:
            ref = self.snapshot[data + 0]
            x0  = self.snapshot[data + 1]
            x1  = self.snapshot[data + 2]
            y0  = self.snapshot[data + 3]
            y1  = self.snapshot[data + 4]
            data += stride

            widths[ref].append(x1 - x0)
            heights[ref].append(y1 - y0)

        max_widths  = [max(widths[key]  + [0]) + 1 for key in widths]
        max_heights = [max(heights[key] + [0]) + 1 for key in heights]
        # for i, wh in enumerate(zip(max_widths, max_heights)):
        #     print "%d: %d x %d" % (i, wh[0], wh[1])

        s = ""
        for b in range(base, base + ents * 2, 2):
            ref = (b - 0xEBC5) // 2
            addr = self.snapshot[b + 0] + self.snapshot[b + 1] * 256
            s += "<h3>$%.4X</h3>" % addr
            s += "<p>" + self._decode_and_save_mask(cwd, addr, max_widths[ref], max_heights[ref]) + "</p>"
        return s

    # Internal
    def _decode_mask(self, cwd, addr, suggested_width, suggested_height):
        " Decode a mask at the specified address to a UDG array. "

        width, height, tiles = self._expand_mask(cwd,
                                                 addr,
                                                 suggested_width,
                                                 suggested_height)

        tiles.reverse()

        # Build tile UDG array
        udg_array = []

        for y in range(height):
            udg_array.append([])  # start new row
            for x in range(width):
                udg_array[-1].append(self._mask_tile(cwd, tiles.pop()))

        return udg_array

    # Internal
    def _save_mask(self, cwd, addr, udg_array):
        img_path_id = 'ScreenshotImagePath'
        fname = 'mask-%.4X' % addr
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)
        return img_path

    # Internal
    def _decode_and_save_mask(self, cwd, addr, suggested_width, suggested_height):
        udg_array = self._decode_mask(cwd, addr, suggested_width, suggested_height)
        img_path = self._save_mask(cwd, addr, udg_array)
        return self.img_element(cwd, img_path)

    # Internal
    def _expand_mask(self, cwd, addr, suggested_width, suggested_height):
        " Expand the mask bytes to a flat array. "

        width = self.snapshot[addr + 0]
        height = suggested_height

        if suggested_width > width:
            print("suggested width %d > actual %d" % (suggested_width, width))

        iters = width * height

        s = []

        p = addr + 1
        while iters > 0:
            b = self.snapshot[p]
            p += 1
            if b >= 128:
                c = self.snapshot[p]
                p += 1
                for i in range(1, 1 + b - 128):
                    s.append(c)
                    iters -= 1
            else:
                s.append(b)
                iters -= 1

        return (width, height, s)

# -----------------------------------------------------------------------------

    @staticmethod
    def room_name(index):
        """ Return the name of the specified room. """

        return ("Room 0: Outdoors",
                "Room 1: Lowest Hut, right",
                "Room 2: Middle Hut, left (Hero's start room)",
                "Room 3: Middle Hut, right",
                "Room 4: Highest Hut, left",
                "Room 5: Highest Hut, right",
                "Room 6: (unused)",
                "Room 7: Corridor",
                "Room 8: Corridor",
                "Room 9: Crate",
                "Room 10: Lockpick",
                "Room 11: Commandant's Office",
                "Room 12: Corridor",
                "Room 13: Corridor",
                "Room 14: Guard's Quarters 1 (Torch)",
                "Room 15: Guard's Quarters 2 (Uniform)",
                "Room 16: Corridor",
                "Room 17: Corridor",
                "Room 18: Radio",
                "Room 19: Food",
                "Room 20: Red Cross Parcel",
                "Room 21: Corridor",
                "Room 22: Corridor to Solitary (Red key)",
                "Room 23: Mess Hall, right",
                "Room 24: Solitary Confinement",
                "Room 25: Mess Hall, left",
                "Room 26: (unused)",
                "Room 27: (unused)",
                "Room 28: Lowest Hut, left",
                "Room 29: Tunnels 2 (Start)",
                "Room 30: Tunnels 2",
                "Room 31: Tunnels 2",
                "Room 32: Tunnels 2",
                "Room 33: Tunnels 2",
                "Room 34: Tunnels 2 (End)",
                "Room 35: Tunnels 2",
                "Room 36: Tunnels 2",
                "Room 37: Tunnels 1 (Start)",
                "Room 38: Tunnels 1",
                "Room 39: Tunnels 1",
                "Room 40: Tunnels 1",
                "Room 41: Tunnels 1",
                "Room 42: Tunnels 1",
                "Room 43: Tunnels 1",
                "Room 44: Tunnels 1",
                "Room 45: Tunnels 1",
                "Room 46: Tunnels 1",
                "Room 47: Tunnels 1",
                "Room 48: Tunnels 1 (End)",
                "Room 49: Tunnels 1",
                "Room 50: Tunnels 1 (Blocked Tunnel)",
                "Room 51: Tunnels 2",
                "Room 52: Tunnels 2")[index]

    @staticmethod
    def interiorobject_name(index):
        """ Return the name of the specified interior object. """

        return ("Object 0: Straight tunnel section SW-NE",
                "Object 1: Small tunnel entrance",
                "Object 2: Room outline 22x12 A",
                "Object 3: Straight tunnel section NW-SE",
                "Object 4: Tunnel T-join section NW-SE",
                "Object 5: Prisoner sat mid table",
                "Object 6: Tunnel T-join section SW-NE",
                "Object 7: Tunnel corner section SW-SE",
                "Object 8: Wide window facing SE",
                "Object 9: Empty bed facing SE",
                "Object 10: Short wardrobe facing SW",
                "Object 11: Chest of drawers facing SW",
                "Object 12: Tunnel corner section NW-NE",
                "Object 13: Empty bench",
                "Object 14: Tunnel corner section NE-SE",
                "Object 15: Door frame SE",
                "Object 16: Door frame SW",
                "Object 17: Tunnel corner section NW-SW",
                "Object 18: Tunnel entrance",
                "Object 19: Prisoner sat end table",
                "Object 20: Collapsed tunnel section SW-NE",
                "Object 21: (unused)",
                "Object 22: Chair facing SE",
                "Object 23: Occupied bed",
                "Object 24: Ornate wardrobe facing SW",
                "Object 25: Chair facing SW",
                "Object 26: Cupboard facing SE",
                "Object 27: Room outline 18x10 A",
                "Object 28: (unused)",
                "Object 29: Table",
                "Object 30: Stove pipe",
                "Object 31: Papers on floor",
                "Object 32: Tall wardrobe facing SW",
                "Object 33: Small shelf facing SE",
                "Object 34: Small crate",
                "Object 35: Small window with bars facing SE",
                "Object 36: Tiny door frame NE",  # tunnel entrance
                "Object 37: Noticeboard facing SE",
                "Object 38: Door frame NW",
                "Object 39: (unused)",
                "Object 40: Door frame NE",
                "Object 41: Room outline 15x8",
                "Object 42: Cupboard facing SW",
                "Object 43: Mess bench",
                "Object 44: Mess table",
                "Object 45: Mess bench short",
                "Object 46: Room outline 18x10 B",
                "Object 47: Room outline 22x12 B",
                "Object 48: Tiny table",
                "Object 49: Tiny drawers facing SE",
                "Object 50: Tall drawers facing SW",
                "Object 51: Desk facing SW",
                "Object 52: Sink facing SE",
                "Object 53: Key rack facing SE")[index]

    # API
    def decode_all_rooms(self, cwd, base, nrooms):
        """ Decode all rooms. """

        # Extract the start addresses of all room definitions

        roomdefptrs = self.snapshot[base:base + nrooms * 2]
        roomdefs = []
        for lo, hi in zip(roomdefptrs[0::2], roomdefptrs[1::2]):
            roomdefs.append(lo + hi * 256)

        # Build a dictionary of room data

        unused_rooms = (6, 26, 27)  # room numbers to skip

        all_rooms = {}
        for index, roomdef in enumerate(roomdefs):
            room_no = index + 1
            if room_no in unused_rooms:
                continue
            all_rooms[room_no] = self._decode_room(cwd, room_no, roomdef)

        # Produce a list of objects and the rooms which use them

        object_rooms = {}
        for _, room in all_rooms.items():
            for obj, x, y in room['objects']:
                object_rooms.setdefault(obj, set([]))
                room_no = room['room_no']
                object_rooms[obj].add(room_no)

        # Emit the info text

        s = ""
        for _, room in all_rooms.items():
            s += "<h3>%s at $%X</h3>" % (self.room_name(room['room_no']),
                                         room['roomdef'])
            s += "<p>" + self._render_room(cwd, room) + "</p>"
            s += "<ul>"
            for func in [self._room_dimensions_info,
                         self._room_boundary_info,
                         self._room_mask_info,
                         self._room_object_info]:
                s += "<li>" + func(cwd, all_rooms, room, object_rooms)
            s += "</ul>"

        return s

    # Internal
    def _decode_room(self, cwd, room_no, roomdef):
        """ Decode a single room. """

        # There are ten possible room sizes, decode them into 'dims'.
        p = 0x6B85
        dims = list(zip(self.snapshot[p + 0:p + 0 + 10 * 4:4],
                        self.snapshot[p + 1:p + 1 + 10 * 4:4],
                        self.snapshot[p + 2:p + 2 + 10 * 4:4],
                        self.snapshot[p + 3:p + 3 + 10 * 4:4]))

        p = roomdef
        dimensions_index = self.snapshot[p]
        room_dims = dims[dimensions_index]
        p += 1

        # Unpack boundaries

        nboundaries = self.snapshot[p]
        p += 1
        boundaries = []
        for i in range(nboundaries):
            boundaries.append(self.snapshot[p: p + 4])
            p += 4

        # Unpack masks

        nmasks = self.snapshot[p]
        p += 1
        masks = self.snapshot[p: p + nmasks]
        p += nmasks

        # Unpack objects

        nobjs = self.snapshot[p]
        p += 1
        objects = []
        for i in range(nobjs):
            objects.append(self.snapshot[p: p + 3])
            p += 3

        return {"room_no": room_no,
                "roomdef": roomdef,
                "dimensions": room_dims,
                "boundaries": boundaries,
                "masks": masks,
                "objects": objects}

    # Internal
    def _room_dimensions_info(self, cwd, all_rooms, room, object_rooms):
        s = "Dimensions: " + str(room['dimensions'])
        return s

    # Internal
    def _room_boundary_info(self, cwd, all_rooms, room, object_rooms):
        s = "Number of boundaries: %d" % len(room['boundaries'])
        return s

    # Internal
    def _room_mask_info(self, cwd, all_rooms, room, object_rooms):
        s = "Number of masks: %d" % len(room['masks'])
        return s

    # Internal
    def _room_object_info(self, cwd, all_rooms, room, object_rooms):
        s = "Number of objects: %d" % len(room['objects'])
        s += "<ul>"
        roomobjects = [r[0] for r in room['objects']]
        for obj in set(roomobjects):  # deduplicate the objs
            ninroom = roomobjects.count(obj)  # number in this room
            notherrooms = len(object_rooms[obj]) - 1
            if notherrooms:
                use = "present in %d other rooms" % (notherrooms)
            else:
                use = "<strong>unique to this room</strong>"
            s += "<li>" + "%d x '%s' - %s.<br>" % (ninroom, self.interiorobject_name(obj), use)
        s += "</ul>"
        return s

    # Internal
    def _render_room(self, cwd, roomdata):
        # room_dims is not comprehendible to me right now .. could use a
        # worst-size case of the screen size

        room_width, room_height = 24, 16

        # Build a UDG array for the room

        udg_array = [[self._interior_tile(cwd, 0) for x in range(room_width)] for y in range(room_height)]

        for obj_index, x, y in roomdata['objects']:
            interior_object_defs = 0x7095 + obj_index * 2
            objdef = self.snapshot[interior_object_defs] + self.snapshot[interior_object_defs + 1] * 256
            width, height, tiles = self._expand_object(cwd, objdef)

            tiles.reverse()

            for yy in range(height):
                for xx in range(width):
                    t = tiles.pop()
                    if t:
                        udg_array[y + yy][x + xx] = self._interior_tile(cwd, t)

        img_path_id = 'ScreenshotImagePath'
        fname = 'room-%d' % roomdata['room_no']
        img_path = self.image_path(fname, img_path_id)
        self.write_image(img_path, udg_array)

        return self.img_element(cwd, img_path)


class TheGreatEscapeAsmWriter(AsmWriter):
    pass

# vim: ts=8 sts=4 sw=4 et
