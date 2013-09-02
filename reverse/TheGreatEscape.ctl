;
; SkoolKit control file for The Great Escape by Denton Designs.
;
; This disassembly copyright (c) David Thomas, 2012-2013. <dave@davespace.co.uk>
;
; To build the HTML disassembly, create a z80 snapshot of The Great Escape
; named TheGreatEscape.z80, and run these commands from the top-level SkoolKit
; directory:
;   ./sna2skool.py -c TheGreatEscape.ctl TheGreatEscape.z80 > TheGreatEscape.skool
;   ./skool2html.py TheGreatEscape.ref
;
; To create a snapshot which preserves the loading screen, breakpoint $F068 and
; alter that to jump to itself when the TZX has loaded. Save the snapshot in
; Z80 format. Use a hex editor on the .z80 to restore the bytes to their former
; values (JP $F163).

; //////////////////////////////////////////////////////////////////////////////
; TODO
; //////////////////////////////////////////////////////////////////////////////
;
; - Document everything!
;   - sub_* functions
;   - '...' indicates a gap in documentation
; - Map out game state at $8000+ which overlaps graphics.
; - Sort out inverted masks issue.
; - Use SkoolKit # refs more.
;   - Currently using (<- somefunc) to show a reference.
;
; - Check occurrences of LDIR I've converted to memcpy where I've not accounted for DE and HL being incremented...
; - Fix axis described as Y/X to X/Y.
; -

; //////////////////////////////////////////////////////////////////////////////
; STYLE
; //////////////////////////////////////////////////////////////////////////////
;
; A single dash '-' indicates a statement has been omitted.
;
; Code broken by a single ';' indicates that control flow passes through that
; point and that the subsequent instruction is a goto target.
;
; Pseudo-C code is formatted in a slightly odd way to best fit the lines to
; which it is assigned. e.g.
;     if (condition) {
;         statement; }
;     else { statement;
;     }
;
; Omit variables when the value is used once (e.g. for strides).

; //////////////////////////////////////////////////////////////////////////////
; ASSEMBLY PATTERNS
; //////////////////////////////////////////////////////////////////////////////
;
; Multiply A by 2^N:
;   ADD A,A ; A += A (N times)
;
; Increment HL by 8-bit increment:
;   A = L
;   A += increment
;   L = A
;   JR NC,skip
;   H++
;   skip:
; does this only work for HL?
;
; if-else:
;   CP <value>
;   JR <cond>,elsepart;
;   <ifwork>
;   JR endifpart;
;   elsepart: <elsework>
;   endifpart:
;
; Less than or equal:
;   CP $0F
;   JP Z,$C8F1
;   JP C,$C8F1
;
; Transfer between awkward registers:
;   PUSH reg
;   POP anotherreg

; //////////////////////////////////////////////////////////////////////////////
; ENUMERATIONS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the control
; directives.

; ; enum attribute (width 1 byte)
; attribute_BLUE_OVER_BLACK = 1
; attribute_RED_OVER_BLACK = 2
; attribute_PURPLE_OVER_BLACK = 3
; attribute_GREEN_OVER_BLACK = 4
; attribute_CYAN_OVER_BLACK = 5
; attribute_YELLOW_OVER_BLACK = 6
; attribute_WHITE_OVER_BLACK = 7
; attribute_BRIGHT_BLUE_OVER_BLACK = 65
; attribute_BRIGHT_RED_OVER_BLACK = 66
; attribute_BRIGHT_PURPLE_OVER_BLACK = 67
; attribute_BRIGHT_GREEN_OVER_BLACK = 68
; attribute_BRIGHT_CYAN_OVER_BLACK = 69
; attribute_BRIGHT_YELLOW_OVER_BLACK = 70
; attribute_BRIGHT_WHITE_OVER_BLACK = 71

; ; enum character
; character_0 = 0                       ; ?      player?
; character_1 = 1                       ; guard
; character_2 = 2                       ; guard
; character_3 = 3                       ; guard
; character_4 = 4                       ; guard  commandant?
; character_5 = 5                       ; ?
; character_6 = 6                       ; player?
; character_7_prisoner = 7              ; prisoner who sleeps at bed position A
; character_8_prisoner = 8              ; prisoner who sleeps at bed position B
; character_9_prisoner = 9              ; prisoner who sleeps at bed position C
; character_10_prisoner = 10            ; prisoner who sleeps at bed position D
; character_11_prisoner = 11            ; prisoner who sleeps at bed position E
; character_12_prisoner = 12            ; prisoner who sleeps at bed position F
; character_13 = 13                     ; guard
; character_14 = 14                     ; ?
; character_15 = 15                     ; ?
; character_16 = 16                     ; ?
; character_17 = 17                     ; ?
; character_18_prisoner = 18            ; prisoner who sits at bench position D
; character_19_prisoner = 19            ; prisoner who sits at bench position E
; character_20_prisoner = 20            ; prisoner who sits at bench position F
; character_21_prisoner = 21            ; prisoner who sits at bench position A
; character_22_prisoner = 22            ; prisoner who sits at bench position B
; character_23_prisoner = 23            ; prisoner who sits at bench position C
; character_24 = 24                     ; breakfast guard?
; character_25 = 25                     ; breakfast guard?
; Non-character characters start here.
; character_26_stove1 = 26              ; stove1
; character_27_stove2 = 27              ; stove2
; character_28_crate = 28               ; crate
; character_29 = 29                     ; are any of these later characters used?
; character_30 = 30
; character_31 = 31
; character_32 = 32
; character_33 = 33
; character_34 = 34
; character_35 = 35
; character_36 = 36
; character_37 = 37
; character_38 = 38
; character_39 = 39
; character_40 = 40
; character_41 = 41
; character_42 = 42
; character_43 = 43
; character_44 = 44                     ; suspected max
; character_NONE = 255

; ; enum room
; room_0_outdoors = 0
; room_1_hut1right = 1
; room_2_hut2left = 2
; room_3_hut2right = 3
; room_4_hut3left = 4
; room_5_hut3right = 5
; room_6 = 6                            ; unused
; room_7_corridor = 7
; room_8_corridor = 8
; room_9_crate = 9
; room_10_lockpick = 10
; room_11_papers = 11
; room_12_corridor = 12
; room_13_corridor = 13
; room_14_torch = 14
; room_15_uniform = 15
; room_16_corridor = 16
; room_17_corridor = 17
; room_18_radio = 18
; room_19_food = 19
; room_20_redcross = 20
; room_21_corridor = 21
; room_22_redkey = 22
; room_23_breakfast = 23
; room_24_solitary = 24
; room_25_breakfast = 25
; room_26 = 26                          ; unused
; room_27 = 27                          ; unused
; room_28_hut1left = 28
; room_29_secondtunnelstart = 29        ; possibly the second tunnel start
;                                       ; many of the tunnels are displayed duplicated
; room_30 = 30
; room_31 = 31
; room_32 = 32
; room_33 = 33
; room_34 = 34
; room_35 = 35
; room_36 = 36
; room_37 = 37
; room_38 = 38
; room_39 = 39
; room_40 = 40
; room_41 = 41
; room_42 = 42
; room_43 = 43
; room_44 = 44
; room_45 = 45
; room_46 = 46
; room_47 = 47
; room_48 = 48
; room_49 = 49
; room_50_blocked_tunnel = 50
; room_51 = 51
; room_52 = 52
; room_NONE = 255

; ; enum item
; item_WIRESNIPS = 0
; item_SHOVEL = 1
; item_LOCKPICK = 2
; item_PAPERS = 3
; item_TORCH = 4
; item_BRIBE = 5
; item_UNIFORM = 6
; item_FOOD = 7
; item_POISON = 8
; item_RED_KEY = 9
; item_YELLOW_KEY = 10
; item_GREEN_KEY = 11
; item_RED_CROSS_PARCEL = 12
; item_RADIO = 13
; item_PURSE = 14
; item_COMPASS = 15
; item__LIMIT = 16
; item_NONE = 255

; ; enum zoombox_tiles
; zoombox_tile_TL = 0
; zoombox_tile_HZ = 1
; zoombox_tile_TR = 2
; zoombox_tile_VT = 3
; zoombox_tile_BR = 4
; zoombox_tile_BL = 5

; ; enum static_tiles (width 1 byte)
; statictile_empty = 0
; statictile_horn_tl_tl = 1
; statictile_horn_tl_tr = 2
; statictile_horn_tl_bl = 3
; statictile_horn_tl_br = 4
; statictile_horn_tr_tl = 5
; statictile_horn_tr_tr = 6
; statictile_horn_tr_bl = 7
; statictile_horn_tr_br = 8
; statictile_horn_br_tl = 9
; statictile_horn_br_tr = 10
; statictile_horn_br_bl = 11
; statictile_horn_br_br = 12
; statictile_horn_bl_tl = 13
; statictile_horn_bl_tr = 14
; statictile_horn_bl_bl = 15
; statictile_horn_bl_br = 16
; statictile_wire_vt_left = 17
; statictile_wire_vt_right = 18
; statictile_wire_hz_left = 19
; statictile_wire_hz_right = 20
; statictile_longwire_hz_left = 21
; statictile_longwire_hz_middle = 22
; statictile_longwire_hz_right = 23
; statictile_flagpole_top = 24
; statictile_flagpole_middle = 25
; statictile_flagpole_bottom = 26
; statictile_grass_1 = 27
; statictile_grass_2 = 28
; statictile_grass_3 = 29
; statictile_grass_4 = 30
; statictile_grass_0 = 31
; statictile_medal_0_0 = 32
; statictile_medal_0_1 = 33
; statictile_medal_0_2 = 34
; statictile_medal_0_4 = 35
; statictile_medal_0_6 = 36
; statictile_medal_0_10 = 37
; statictile_medal_1_0 = 38
; statictile_medal_1_2 = 39
; statictile_medal_1_4 = 40
; statictile_medal_1_6 = 41
; statictile_medal_1_10 = 42
; statictile_medal_2_0 = 43
; statictile_medal_2_1 = 44
; statictile_medal_2_2 = 45
; statictile_medal_2_4 = 46
; statictile_medal_2_6 = 47
; statictile_medal_2_10 = 48
; statictile_medal_3_0 = 49
; statictile_medal_3_1 = 50
; statictile_medal_3_2 = 51
; statictile_medal_3_3 = 52
; statictile_medal_3_4 = 53
; statictile_medal_3_5 = 54
; statictile_medal_3_6 = 55
; statictile_medal_3_7 = 56
; statictile_medal_3_8 = 57
; statictile_medal_3_9 = 58
; statictile_medal_3_10 = 59
; statictile_medal_4_0 = 60
; statictile_medal_4_1 = 61
; statictile_medal_4_2 = 62
; statictile_medal_4_3 = 63
; statictile_medal_4_4 = 64
; statictile_medal_4_5 = 65
; statictile_medal_4_6 = 66
; statictile_medal_4_7 = 67
; statictile_medal_4_8 = 68
; statictile_medal_4_9 = 69
; statictile_bell_0_0 = 70
; statictile_bell_0_1 = 71
; statictile_bell_0_2 = 72
; statictile_bell_1_0 = 73
; statictile_bell_1_1 = 74
; statictile_bell_1_2 = 75
; statictile_bell_2_0 = 76
; statictile_bell_2_1 = 77
; statictile_medal_1_1 = 78
; static_tiles_4F = 79
; static_tiles_50 = 80
; static_tiles_51 = 81
; static_tiles_52 = 82
; static_tiles_53 = 83

; ; enum message (width 1 byte)
; message_MISSED_ROLL_CALL = 0
; message_TIME_TO_WAKE_UP = 1
; message_BREAKFAST_TIME = 2
; message_EXERCISE_TIME = 3
; message_TIME_FOR_BED = 4
; message_THE_DOOR_IS_LOCKED = 5
; message_IT_IS_OPEN = 6
; message_INCORRECT_KEY = 7
; message_ROLL_CALL = 8
; message_RED_CROSS_PARCEL = 9
; message_PICKING_THE_LOCK = 10
; message_CUTTING_THE_WIRE = 11
; message_YOU_OPEN_THE_BOX = 12
; message_YOU_ARE_IN_SOLITARY = 13
; message_WAIT_FOR_RELEASE = 14
; message_MORALE_IS_ZERO = 15
; message_ITEM_DISCOVERED = 16
; message_HE_TAKES_THE_BRIBE = 17
; message_AND_ACTS_AS_DECOY = 18
; message_ANOTHER_DAY_DAWNS = 19
; message_NONE = 255

; ; enum interior_object
; interiorobject_TUNNEL_0 = 0
; interiorobject_SMALL_TUNNEL_ENTRANCE = 1
; interiorobject_ROOM_OUTLINE_2 = 2
; interiorobject_TUNNEL_3 = 3
; interiorobject_TUNNEL_JOIN_4 = 4
; interiorobject_PRISONER_SAT_DOWN_MID_TABLE = 5
; interiorobject_TUNNEL_CORNER_6 = 6
; interiorobject_TUNNEL_7 = 7
; interiorobject_WIDE_WINDOW = 8
; interiorobject_EMPTY_BED = 9
; interiorobject_SHORT_WARDROBE = 10
; interiorobject_CHEST_OF_DRAWERS = 11
; interiorobject_TUNNEL_12 = 12
; interiorobject_EMPTY_BENCH = 13
; interiorobject_TUNNEL_14 = 14
; interiorobject_DOOR_FRAME_15 = 15
; interiorobject_DOOR_FRAME_16 = 16
; interiorobject_TUNNEL_17 = 17
; interiorobject_TUNNEL_18 = 18
; interiorobject_PRISONER_SAT_DOWN_END_TABLE = 19
; interiorobject_COLLAPSED_TUNNEL = 20
; interiorobject_ROOM_OUTLINE_21 = 21
; interiorobject_CHAIR_POINTING_BOTTOM_RIGHT = 22
; interiorobject_OCCUPIED_BED = 23
; interiorobject_WARDROBE_WITH_KNOCKERS = 24
; interiorobject_CHAIR_POINTING_BOTTOM_LEFT = 25
; interiorobject_CUPBOARD = 26
; interiorobject_ROOM_OUTLINE_27 = 27
; interiorobject_TABLE_1 = 28
; interiorobject_TABLE_2 = 29                   ; the two table objects are identical
; interiorobject_STOVE_PIPE = 30
; interiorobject_STUFF_31 = 31                  ; can't tell what this is supposed to be
; interiorobject_TALL_WARDROBE = 32
; interiorobject_SMALL_SHELF = 33
; interiorobject_SMALL_CRATE = 34
; interiorobject_SMALL_WINDOW = 35
; interiorobject_DOOR_FRAME_36 = 36
; interiorobject_NOTICEBOARD = 37
; interiorobject_DOOR_FRAME_38 = 38
; interiorobject_DOOR_FRAME_39 = 39
; interiorobject_DOOR_FRAME_40 = 40
; interiorobject_ROOM_OUTLINE_41 = 41
; interiorobject_CUPBOARD_42 = 42
; interiorobject_MESS_BENCH = 43
; interiorobject_MESS_TABLE = 44
; interiorobject_MESS_BENCH_SHORT = 45
; interiorobject_ROOM_OUTLINE_46 = 46
; interiorobject_ROOM_OUTLINE_47 = 47
; interiorobject_TINY_TABLE = 48
; interiorobject_TINY_DRAWERS = 49
; interiorobject_DRAWERS_50 = 50
; interiorobject_DESK = 51
; interiorobject_SINK = 52
; interiorobject_KEY_RACK = 53
; interiorobject__LIMIT = 54

; ; enum interior_object_tile
; interiorobjecttile_MAX = 194,
; interiorobjecttile_ESCAPE = 255              ; escape character

; ; enum location
; location_0E00 = $0E00
; location_1000 = $1000
; location_2A00 = $2A00
; location_2B00 = $2B00
; location_2C00 = $2C00
; location_2C01 = $2C01
; location_2D00 = $2D00
; location_8502 = $8502
; location_8E04 = $8E04
; location_9003 = $9003

; ; enum sound
; sound_CHARACTER_ENTERS_1 = $2030
; sound_CHARACTER_ENTERS_2 = $2040
; sound_BELL_RINGER = $2530
; sound_PICK_UP_ITEM = $3030
; sound_DROP_ITEM = $3040

; //////////////////////////////////////////////////////////////////////////////
; FLAGS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the control
; directives.

; ; enum input
; input_NONE = 0
; input_UP = 1
; input_DOWN = 2
; input_LEFT = 3
; input_RIGHT = 6
; input_FIRE = 9
; input_UP_FIRE = input_UP + input_FIRE
; input_DOWN_FIRE = input_DOWN + input_FIRE
; input_LEFT_FIRE = input_LEFT + input_FIRE
; input_RIGHT_FIRE = input_RIGHT + input_FIRE

; ; enum port_keyboard
; port_KEYBOARD_SHIFTZXCV       = 0xFEFE,
; port_KEYBOARD_ASDFG           = 0xFDFE,
; port_KEYBOARD_QWERT           = 0xFBFE,
; port_KEYBOARD_12345           = 0xF7FE,
; port_KEYBOARD_09876           = 0xEFFE,
; port_KEYBOARD_POIUY           = 0xDFFE,
; port_KEYBOARD_ENTERLKJH       = 0xBFFE,
; port_KEYBOARD_SPACESYMSHFTMNB = 0x7FFE,

; ; enum vischar
; ; $800x flags (and $802x, $804x, ...)
; vischar_BYTE0_EMPTY_SLOT   = 0xFF,
; vischar_BYTE0_MASK         = 0x1F, // character index
; vischar_BYTE1_EMPTY_SLOT   = 0xFF,
; vischar_BYTE1_MASK         = 0x3F,
; vischar_BYTE1_PICKING_LOCK = 1<<0, // player only
; vischar_BYTE1_CUTTING_WIRE = 1<<1, // player only
; vischar_BYTE1_PERSUE       = 1<<0, // AI only
; vischar_BYTE1_BIT2         = 1<<2, // set when bribe taken ('gone mad' flag)
; vischar_BYTE1_BIT6         = 1<<6, // seems to affect coordinate scaling
; vischar_BYTE1_BIT7         = 1<<7, // set in called_from_main_loop_9
; vischar_BYTE2_MASK         = 0x7F,
; vischar_BYTE2_BIT7         = 1<<7,
; vischar_BYTE7_MASK         = 0x0F,
; vischar_BYTE7_MASK_HI      = 0xF0,
; vischar_BYTE7_BIT5         = 1<<5, // bounds related, perhaps stopping movement
; vischar_BYTE7_BIT6         = 1<<6,
; vischar_BYTE7_BIT7         = 1<<7,
; vischar_BYTE12_MASK        = 0x7F,
; vischar_BYTE13_MASK        = 0x7F,
; vischar_BYTE13_BIT7        = 1<<7,
; vischar_BYTE14_CRAWL       = 1<<2,

; enum itemstructflags
; itemstruct_ITEM_MASK             = 0x0F,
; itemstruct_ITEM_FLAG_POISONED    = 1<<5,
; itemstruct_ITEM_FLAG_HELD        = 1<<7, // set when the item is picked up (maybe)
; itemstruct_ROOM_MASK             = 0x3F,
; itemstruct_ROOM_FLAG_BIT6        = 1<<6, // unknown
; itemstruct_ROOM_FLAG_ITEM_NEARBY = 1<<7, // set when the item is nearby

; enum gatesanddoorsflags
; gates_and_doors_MASK       = 0x7F,
; gates_and_doors_LOCKED     = 1<<7,

; enum characterstructflags
; characterstruct_BYTE0_BIT6    = 1<<6, // this disables the character
; characterstruct_BYTE0_MASK    = 0x1F,
; characterstruct_BYTE5_MASK    = 0x7F,
; characterstruct_BYTE6_MASK_HI = 0xF8,
; characterstruct_BYTE6_MASK_LO = 0x07,

; enum doorpositionflags
; doorposition_BYTE0_MASK_LO = 0x03,
; doorposition_BYTE0_MASK_HI = 0xFC,

; enum searchlightflags
; searchlight_STATE_00       = 0x00,
; searchlight_STATE_1F       = 0x1F,
; searchlight_STATE_OFF      = 0xFF, // likely: hunting for player

; enum bellringflags
; bell_RING_PERPETUAL        = 0x00,
; bell_RING_40_TIMES         = 0x28,
; bell_STOP                  = 0xFF,

; enum escapeitemflags
; escapeitem_COMPASS         = 1,
; escapeitem_PAPERS          = 2,
; escapeitem_PURSE           = 4,
; escapeitem_UNIFORM         = 8,

; statictiles_COUNT_MASK     = 0x7F,
; statictiles_VERTICAL       = 1<<7, // otherwise horizontal

; map constants
; map_MAIN_GATE_X            = 0x696D, // coords: 0x69..0x6D
; map_MAIN_GATE_Y            = 0x494B,
; map_ROLL_CALL_X            = 0x727C,
; map_ROLL_CALL_Y            = 0x6A72,

; input device constants
; inputdevice_KEYBOARD       = 0,

; //////////////////////////////////////////////////////////////////////////////
; CONSTANTS
; //////////////////////////////////////////////////////////////////////////////

; ; enum morale
; morale_MIN = 0
; morale_MAX = 112

; //////////////////////////////////////////////////////////////////////////////
; ROOMS
; //////////////////////////////////////////////////////////////////////////////

; Key
;
;   '' => door (up/down)
;   =  => door (left/right)
;   in => entrance
;   [] => exit
;   ~  => void / ground
;
; Map of rooms' indices
;
;   +--------+--------+----+----+----+
;   |   25   =   23   = 19 = 18 = 12 |
;   +--------+-+-''-+-+----+    +-''-+
;    | 24 = 22 = 21 | | 20 +    + 17 |
;    +----+----+-''-+ +-''-+----+-''-+
;                          = 15 |  7 |
;       +----+------+      +-''-+-''-+
;       = 28 =   1  |      | 14 = 16 |
;       +----+--''--+      +----+-''-+
;                               = 13 |
;       +----+------+           +-''-+
;       =  2 =   3  |           | 11 |
;       +----+--''--+           |    |
;                          +----+----+
;       +----+------+      |  9 | 10 |
;       =  4 =   5  |      |    |    |
;       +----+--''--+      +-''-+-''-+
;                          =    8    |
;                          +----+----+
;
; Map of tunnels' indices 1
;
;   ~~~~~~~~~~~~~~~~~~~~+---------+----+
;   ~~~~~~~~~~~~~~~~~~~~|    49   = 50 |
;   ~~~~~~~~~~~~~~~~~~~~+-''-+----+-''-+
;   ~~~~~~~~~~~~~~~~~~~~| 48 |~~~~| 47 |
;   ~~~~~~~~~~~~~~~~~~~~+-[]-+~~~~|    |
;   +------+-------+----+----+----+    |
;   |  45  =   41  =    40   | 46 =    |
;   +-''-+-+--+-''-+------''-+-''-+----+
;   | 44 = 43 = 42 |~~~~| 38 = 39 |~~~~~
;   +----+----+----+~~~~+-''-+----+~~~~~
;   ~~~~~~~~~~~~~~~~~~~~| 37 |~~~~~~~~~~
;   ~~~~~~~~~~~~~~~~~~~~+-in-+~~~~~~~~~~
;
; Map of tunnels' indices 2
;
;   +----------+--------+--------+
;   |    36    =   30   =   52   |
;   +-''-+-----+--''----+---+-''-+
;   | 35 |~~~~~~| 31 |~~~~~~| 51 |
;   |    +------+-''-+~~~~~~|    |
;   |    =  33  = 32 |~~~~~~|    |
;   |    +------+----+~~~~~~|    |
;   |    |~~~~~~~~~~~~~+----+    |
;   +-''-+~~~~~~~~~~~~in 29 =    |
;   | 34 |~~~~~~~~~~~~~+----+----+
;   +-[]-+~~~~~~~~~~~~~~~~~~~~~~~~
;
; I'm fairly sure that the visual of the above layout is actually topologically
; impossible. e.g. if you take screenshots of every room and attempt to combine
; them in an image editor it won't join up.
;
; Unused room indices: 6, 26, 27
;

; //////////////////////////////////////////////////////////////////////////////
; GAME STATE
; //////////////////////////////////////////////////////////////////////////////

; game state which overlaps with tiles etc.
;
; vars referenced as $8015 etc.
;
; $8000 seems to be an array of eight 32-wide visible character blocks. the first is likely the player character.

; b $8000 character index? (0xFF if no visible character)
; b $8001 flags: bit 6 gets toggled in set_player_target_location /  bit 0: picking lock /  bit 1: cutting wire  (0xFF when reset)
; w $8002 could be a target location (set in set_player_target_location, process_player_input)
; w $8004 (<- process_player_input) a coordinate? (i see it getting scaled in #R$CA11)
; ? $8006
; b $8007 bits 5/6/7: flags  (suspect bit 4 is a flag too) (0x00 when reset)
; w $8008 (read by called_from_main_loop_9)
; w $800A (read/written by called_from_main_loop_9)
; b $800C (read/written by called_from_main_loop_9)
; b $800D tunnel related (<- process_player_input, snipping_wire, process_player_input) assigned from table at 9EE0.  causes movement when set. but not when in solitary.
;            0x81 -> move toward top left,
;            0x82 -> move toward bottom right,
;            0x83 -> move toward bottom left,
;            0x84 -> TL (again)
;            0x85 ->
; b $800E tunnel related, direction (bottom 2 bits index table_9EE0) bit 2 is walk/crawl flag
; set to - 0x00 -> character faces top left
;          0x01 -> character faces top right
;          0x02 -> character faces bottom right
;          0x03 -> character faces bottom left
;          0x04 -> character faces top left     (crawling)
;          0x05 -> character faces top right    (crawling)
;          0x06 -> character faces bottom right (crawling)
;          0x07 -> character faces bottom left  (crawling)
; w $800F position on Y axis (along the line of - bottom right to top left of screen) (set by process_player_input)
; w $8011 position on X axis (along the line of - bottom left to top right of screen) (set by process_player_input)  i think this might be relative to the current size of the map. each step seems to be two pixels.
; w $8013 character's vertical offset // set to 24 in process_player_input, snipping_wire,  set to 12 in action_wiresnips,  reset in reset_position,  read by called_from_main_loop_9 ($B68C) (via IY), sub_B89C ($B8DE), setup_sprite_plotting ($E433), in_permitted_area ($9F4F)  written by sub_AF8F ($AFD5)  often written as a byte, but suspect it's a word-sized value
; w $8015 pointer to current character sprite set (gets pointed to the 'tl_4' sprite)
; b $8017 sub_AF8F sets this to stashed_A
; w $8018 points to something (gets 0x06C8 subtracted from it) (<- in_permitted_area)
; w $801A points to something (gets 0x0448 subtracted from it) (<- in_permitted_area)
; b $801C room index: cleared to zero by action_papers, set to room_24_solitary by solitary, copied to room_index by transition
; ? $801D
; ? $801E
; ? $801F (written by setup_sprite_plotting)

; $8020 visible character blocks. 7 sets of 32 bytes, one per visible character. can there be >7 characters on-screen/visible at once? or is it prisoners only?

;   $8020 byte -- bit 6 means something here, likely merged with a character index
;   $8021 likely a room index
;   $8022 likely a position
;   $8023 likely a position
;   $8024 likely a position
;   $803C room index within struct at $8020

; $8100 mask buffer thing

; $81A0 mystery (suspected_mask_stuff)

; $8131 <- searchlight_sub

; w $81A2 (<- masked_sprite_plotter_*)  likely screen buffer pointer

; //////////////////////////////////////////////////////////////////////////////
; CONTROL DIRECTIVES
; //////////////////////////////////////////////////////////////////////////////

b $4000 screen
D $4000 #UDGTABLE { #SCR(loading) | This is the loading screen. } TABLE#

; ------------------------------------------------------------------------------

b $5B00 super_tiles
D $5B00 Super tiles. 4x4 array of tile refs. The game map (at $BCEE) is constructed of (indices of) these.
B $5B00,16,4 super_tile $00 #CALL:supertile($5B00)
B $5B10,16,4 super_tile $01 #CALL:supertile($5B10)
B $5B20,16,4 super_tile $02 #CALL:supertile($5B20)
B $5B30,16,4 super_tile $03 #CALL:supertile($5B30)
B $5B40,16,4 super_tile $04 #CALL:supertile($5B40)
B $5B50,16,4 super_tile $05 #CALL:supertile($5B50)
B $5B60,16,4 super_tile $06 #CALL:supertile($5B60)
B $5B70,16,4 super_tile $07 #CALL:supertile($5B70)
B $5B80,16,4 super_tile $08 #CALL:supertile($5B80)
B $5B90,16,4 super_tile $09 #CALL:supertile($5B90)
B $5BA0,16,4 super_tile $0A #CALL:supertile($5BA0)
B $5BB0,16,4 super_tile $0B #CALL:supertile($5BB0)
B $5BC0,16,4 super_tile $0C #CALL:supertile($5BC0)
B $5BD0,16,4 super_tile $0D #CALL:supertile($5BD0)
B $5BE0,16,4 super_tile $0E #CALL:supertile($5BE0)
B $5BF0,16,4 super_tile $0F #CALL:supertile($5BF0)
B $5C00,16,4 super_tile $10 #CALL:supertile($5C00)
B $5C10,16,4 super_tile $11 #CALL:supertile($5C10)
B $5C20,16,4 super_tile $12 #CALL:supertile($5C20)
B $5C30,16,4 super_tile $13 #CALL:supertile($5C30)
B $5C40,16,4 super_tile $14 #CALL:supertile($5C40)
B $5C50,16,4 super_tile $15 #CALL:supertile($5C50)
B $5C60,16,4 super_tile $16 #CALL:supertile($5C60)
B $5C70,16,4 super_tile $17 #CALL:supertile($5C70)
B $5C80,16,4 super_tile $18 #CALL:supertile($5C80)
B $5C90,16,4 super_tile $19 #CALL:supertile($5C90)
B $5CA0,16,4 super_tile $1A #CALL:supertile($5CA0)
B $5CB0,16,4 super_tile $1B #CALL:supertile($5CB0)
B $5CC0,16,4 super_tile $1C #CALL:supertile($5CC0)
B $5CD0,16,4 super_tile $1D #CALL:supertile($5CD0)
B $5CE0,16,4 super_tile $1E #CALL:supertile($5CE0)
B $5CF0,16,4 super_tile $1F #CALL:supertile($5CF0)
B $5D00,16,4 super_tile $20 #CALL:supertile($5D00)
B $5D10,16,4 super_tile $21 #CALL:supertile($5D10)
B $5D20,16,4 super_tile $22 #CALL:supertile($5D20)
B $5D30,16,4 super_tile $23 #CALL:supertile($5D30)
B $5D40,16,4 super_tile $24 #CALL:supertile($5D40)
B $5D50,16,4 super_tile $25 #CALL:supertile($5D50)
B $5D60,16,4 super_tile $26 #CALL:supertile($5D60)
B $5D70,16,4 super_tile $27 #CALL:supertile($5D70)
B $5D80,16,4 super_tile $28 #CALL:supertile($5D80)
B $5D90,16,4 super_tile $29 #CALL:supertile($5D90)
B $5DA0,16,4 super_tile $2A #CALL:supertile($5DA0)
B $5DB0,16,4 super_tile $2B #CALL:supertile($5DB0)
B $5DC0,16,4 super_tile $2C #CALL:supertile($5DC0)
B $5DD0,16,4 super_tile $2D #CALL:supertile($5DD0)
B $5DE0,16,4 super_tile $2E #CALL:supertile($5DE0)
B $5DF0,16,4 super_tile $2F #CALL:supertile($5DF0)
B $5E00,16,4 super_tile $30 #CALL:supertile($5E00)
B $5E10,16,4 super_tile $31 #CALL:supertile($5E10)
B $5E20,16,4 super_tile $32 #CALL:supertile($5E20)
B $5E30,16,4 super_tile $33 #CALL:supertile($5E30)
B $5E40,16,4 super_tile $34 #CALL:supertile($5E40)
B $5E50,16,4 super_tile $35 #CALL:supertile($5E50)
B $5E60,16,4 super_tile $36 #CALL:supertile($5E60)
B $5E70,16,4 super_tile $37 #CALL:supertile($5E70)
B $5E80,16,4 super_tile $38 #CALL:supertile($5E80)
B $5E90,16,4 super_tile $39 #CALL:supertile($5E90)
B $5EA0,16,4 super_tile $3A #CALL:supertile($5EA0)
B $5EB0,16,4 super_tile $3B #CALL:supertile($5EB0)
B $5EC0,16,4 super_tile $3C #CALL:supertile($5EC0)
B $5ED0,16,4 super_tile $3D #CALL:supertile($5ED0)
B $5EE0,16,4 super_tile $3E #CALL:supertile($5EE0)
B $5EF0,16,4 super_tile $3F #CALL:supertile($5EF0)
B $5F00,16,4 super_tile $40 #CALL:supertile($5F00)
B $5F10,16,4 super_tile $41 #CALL:supertile($5F10)
B $5F20,16,4 super_tile $42 #CALL:supertile($5F20)
B $5F30,16,4 super_tile $43 #CALL:supertile($5F30)
B $5F40,16,4 super_tile $44 #CALL:supertile($5F40)
B $5F50,16,4 super_tile $45 #CALL:supertile($5F50)
B $5F60,16,4 super_tile $46 #CALL:supertile($5F60)
B $5F70,16,4 super_tile $47 #CALL:supertile($5F70)
B $5F80,16,4 super_tile $48 #CALL:supertile($5F80)
B $5F90,16,4 super_tile $49 #CALL:supertile($5F90)
B $5FA0,16,4 super_tile $4A #CALL:supertile($5FA0)
B $5FB0,16,4 super_tile $4B #CALL:supertile($5FB0)
B $5FC0,16,4 super_tile $4C #CALL:supertile($5FC0)
B $5FD0,16,4 super_tile $4D #CALL:supertile($5FD0)
B $5FE0,16,4 super_tile $4E #CALL:supertile($5FE0)
B $5FF0,16,4 super_tile $4F #CALL:supertile($5FF0) [unused by map]
B $6000,16,4 super_tile $50 #CALL:supertile($6000)
B $6010,16,4 super_tile $51 #CALL:supertile($6010)
B $6020,16,4 super_tile $52 #CALL:supertile($6020)
B $6030,16,4 super_tile $53 #CALL:supertile($6030)
B $6040,16,4 super_tile $54 #CALL:supertile($6040)
B $6050,16,4 super_tile $55 #CALL:supertile($6050)
B $6060,16,4 super_tile $56 #CALL:supertile($6060)
B $6070,16,4 super_tile $57 #CALL:supertile($6070)
B $6080,16,4 super_tile $58 #CALL:supertile($6080)
B $6090,16,4 super_tile $59 #CALL:supertile($6090)
B $60A0,16,4 super_tile $5A #CALL:supertile($60A0)
B $60B0,16,4 super_tile $5B #CALL:supertile($60B0)
B $60C0,16,4 super_tile $5C #CALL:supertile($60C0)
B $60D0,16,4 super_tile $5D #CALL:supertile($60D0)
B $60E0,16,4 super_tile $5E #CALL:supertile($60E0)
B $60F0,16,4 super_tile $5F #CALL:supertile($60F0)
B $6100,16,4 super_tile $60 #CALL:supertile($6100)
B $6110,16,4 super_tile $61 #CALL:supertile($6110)
B $6120,16,4 super_tile $62 #CALL:supertile($6120)
B $6130,16,4 super_tile $63 #CALL:supertile($6130)
B $6140,16,4 super_tile $64 #CALL:supertile($6140)
B $6150,16,4 super_tile $65 #CALL:supertile($6150)
B $6160,16,4 super_tile $66 #CALL:supertile($6160)
B $6170,16,4 super_tile $67 #CALL:supertile($6170)
B $6180,16,4 super_tile $68 #CALL:supertile($6180)
B $6190,16,4 super_tile $69 #CALL:supertile($6190)
B $61A0,16,4 super_tile $6A #CALL:supertile($61A0)
B $61B0,16,4 super_tile $6B #CALL:supertile($61B0)
B $61C0,16,4 super_tile $6C #CALL:supertile($61C0)
B $61D0,16,4 super_tile $6D #CALL:supertile($61D0)
B $61E0,16,4 super_tile $6E #CALL:supertile($61E0)
B $61F0,16,4 super_tile $6F #CALL:supertile($61F0)
B $6200,16,4 super_tile $70 #CALL:supertile($6200)
B $6210,16,4 super_tile $71 #CALL:supertile($6210)
B $6220,16,4 super_tile $72 #CALL:supertile($6220)
B $6230,16,4 super_tile $73 #CALL:supertile($6230)
B $6240,16,4 super_tile $74 #CALL:supertile($6240)
B $6250,16,4 super_tile $75 #CALL:supertile($6250)
B $6260,16,4 super_tile $76 #CALL:supertile($6260)
B $6270,16,4 super_tile $77 #CALL:supertile($6270)
B $6280,16,4 super_tile $78 #CALL:supertile($6280)
B $6290,16,4 super_tile $79 #CALL:supertile($6290)
B $62A0,16,4 super_tile $7A #CALL:supertile($62A0)
B $62B0,16,4 super_tile $7B #CALL:supertile($62B0)
B $62C0,16,4 super_tile $7C #CALL:supertile($62C0)
B $62D0,16,4 super_tile $7D #CALL:supertile($62D0)
B $62E0,16,4 super_tile $7E #CALL:supertile($62E0)
B $62F0,16,4 super_tile $7F #CALL:supertile($62F0)
B $6300,16,4 super_tile $80 #CALL:supertile($6300)
B $6310,16,4 super_tile $81 #CALL:supertile($6310)
B $6320,16,4 super_tile $82 #CALL:supertile($6320)
B $6330,16,4 super_tile $83 #CALL:supertile($6330)
B $6340,16,4 super_tile $84 #CALL:supertile($6340)
B $6350,16,4 super_tile $85 #CALL:supertile($6350)
B $6360,16,4 super_tile $86 #CALL:supertile($6360)
B $6370,16,4 super_tile $87 #CALL:supertile($6370)
B $6380,16,4 super_tile $88 #CALL:supertile($6380)
B $6390,16,4 super_tile $89 #CALL:supertile($6390)
B $63A0,16,4 super_tile $8A #CALL:supertile($63A0)
B $63B0,16,4 super_tile $8B #CALL:supertile($63B0)
B $63C0,16,4 super_tile $8C #CALL:supertile($63C0)
B $63D0,16,4 super_tile $8D #CALL:supertile($63D0)
B $63E0,16,4 super_tile $8E #CALL:supertile($63E0)
B $63F0,16,4 super_tile $8F #CALL:supertile($63F0)
B $6400,16,4 super_tile $90 #CALL:supertile($6400)
B $6410,16,4 super_tile $91 #CALL:supertile($6410)
B $6420,16,4 super_tile $92 #CALL:supertile($6420)
B $6430,16,4 super_tile $93 #CALL:supertile($6430)
B $6440,16,4 super_tile $94 #CALL:supertile($6440)
B $6450,16,4 super_tile $95 #CALL:supertile($6450)
B $6460,16,4 super_tile $96 #CALL:supertile($6460)
B $6470,16,4 super_tile $97 #CALL:supertile($6470)
B $6480,16,4 super_tile $98 #CALL:supertile($6480)
B $6490,16,4 super_tile $99 #CALL:supertile($6490)
B $64A0,16,4 super_tile $9A #CALL:supertile($64A0) [unused by map]
B $64B0,16,4 super_tile $9B #CALL:supertile($64B0)
B $64C0,16,4 super_tile $9C #CALL:supertile($64C0)
B $64D0,16,4 super_tile $9D #CALL:supertile($64D0)
B $64E0,16,4 super_tile $9E #CALL:supertile($64E0)
B $64F0,16,4 super_tile $9F #CALL:supertile($64F0)
B $6500,16,4 super_tile $A0 #CALL:supertile($6500)
B $6510,16,4 super_tile $A1 #CALL:supertile($6510)
B $6520,16,4 super_tile $A2 #CALL:supertile($6520)
B $6530,16,4 super_tile $A3 #CALL:supertile($6530)
B $6540,16,4 super_tile $A4 #CALL:supertile($6540)
B $6550,16,4 super_tile $A5 #CALL:supertile($6550)
B $6560,16,4 super_tile $A6 #CALL:supertile($6560)
B $6570,16,4 super_tile $A7 #CALL:supertile($6570)
B $6580,16,4 super_tile $A8 #CALL:supertile($6580)
B $6590,16,4 super_tile $A9 #CALL:supertile($6590)
B $65A0,16,4 super_tile $AA #CALL:supertile($65A0)
B $65B0,16,4 super_tile $AB #CALL:supertile($65B0)
B $65C0,16,4 super_tile $AC #CALL:supertile($65C0)
B $65D0,16,4 super_tile $AD #CALL:supertile($65D0)
B $65E0,16,4 super_tile $AE #CALL:supertile($65E0)
B $65F0,16,4 super_tile $AF #CALL:supertile($65F0)
B $6600,16,4 super_tile $B0 #CALL:supertile($6600)
B $6610,16,4 super_tile $B1 #CALL:supertile($6610)
B $6620,16,4 super_tile $B2 #CALL:supertile($6620)
B $6630,16,4 super_tile $B3 #CALL:supertile($6630)
B $6640,16,4 super_tile $B4 #CALL:supertile($6640)
B $6650,16,4 super_tile $B5 #CALL:supertile($6650)
B $6660,16,4 super_tile $B6 #CALL:supertile($6660)
B $6670,16,4 super_tile $B7 #CALL:supertile($6670)
B $6680,16,4 super_tile $B8 #CALL:supertile($6680)
B $6690,16,4 super_tile $B9 #CALL:supertile($6690)
B $66A0,16,4 super_tile $BA #CALL:supertile($66A0)
B $66B0,16,4 super_tile $BB #CALL:supertile($66B0)
B $66C0,16,4 super_tile $BC #CALL:supertile($66C0)
B $66D0,16,4 super_tile $BD #CALL:supertile($66D0)
B $66E0,16,4 super_tile $BE #CALL:supertile($66E0)
B $66F0,16,4 super_tile $BF #CALL:supertile($66F0)
B $6700,16,4 super_tile $C0 #CALL:supertile($6700)
B $6710,16,4 super_tile $C1 #CALL:supertile($6710)
B $6720,16,4 super_tile $C2 #CALL:supertile($6720)
B $6730,16,4 super_tile $C3 #CALL:supertile($6730)
B $6740,16,4 super_tile $C4 #CALL:supertile($6740)
B $6750,16,4 super_tile $C5 #CALL:supertile($6750)
B $6760,16,4 super_tile $C6 #CALL:supertile($6760)
B $6770,16,4 super_tile $C7 #CALL:supertile($6770)
B $6780,16,4 super_tile $C8 #CALL:supertile($6780)
B $6790,16,4 super_tile $C9 #CALL:supertile($6790)
B $67A0,16,4 super_tile $CA #CALL:supertile($67A0)
B $67B0,16,4 super_tile $CB #CALL:supertile($67B0)
B $67C0,16,4 super_tile $CC #CALL:supertile($67C0)
B $67D0,16,4 super_tile $CD #CALL:supertile($67D0)
B $67E0,16,4 super_tile $CE #CALL:supertile($67E0)
B $67F0,16,4 super_tile $CF #CALL:supertile($67F0)
B $6800,16,4 super_tile $D0 #CALL:supertile($6800)
B $6810,16,4 super_tile $D1 #CALL:supertile($6810)
B $6820,16,4 super_tile $D2 #CALL:supertile($6820)
B $6830,16,4 super_tile $D3 #CALL:supertile($6830)
B $6840,16,4 super_tile $D4 #CALL:supertile($6840)
B $6850,16,4 super_tile $D5 #CALL:supertile($6850)
B $6860,16,4 super_tile $D6 #CALL:supertile($6860)
B $6870,16,4 super_tile $D7 #CALL:supertile($6870)
B $6880,16,4 super_tile $D8 #CALL:supertile($6880)
B $6890,16,4 super_tile $D9 #CALL:supertile($6890)

; ------------------------------------------------------------------------------

b $68A0 room_index
D $68A0 Index of the current room, or 0 when outside.

; ------------------------------------------------------------------------------

b $68A1 current_door
D $68A1 Holds current door.

; ------------------------------------------------------------------------------

c $68A2 transition
D $68A2 Looks like it's called to transition to a new room.
R $68A2 I:HL Pointer to location?
R $68A2 I:IY Pointer to vischar?
  $68A2 EX DE,HL
  $68A3 HL = IY;
  $68A6 A = L; // stash vischar index/offset
  $68A7 PUSH AF
  $68A8 L = A + 0x0F; // $8xxF (position on Y axis)
  $68AB A = IY[0x1C]; // $8x1C (likely room index)
  $68AE if (A == 0) { // outdoors
D $68B2 Set position on Y axis, X axis and vertical offset (dividing by 4).
  $68B2   B = 3; // 3 iterations
  $68B4   do { PUSH BC
  $68B5     A = *DE++;
  $68B6     BC_becomes_A_times_4();
  $68B9     *HL++ = C;
  $68BB     *HL++ = B;
  $68BE     POP BC
  $68BF   } while (--B); }
  $68C1 else { // indoors
D $68C3 Set position on Y axis, X axis and vertical offset (copying).
  $68C3   B = 3; // 3 iterations
  $68C5   do { *HL++ = *DE++;
  $68C8     *HL++ = 0;
  $68CC   } while (--B); }
  $68CE POP AF
  $68CF L = A;
  $68D0 if (A) { reset_visible_character(); return; } // exit via
D $68D7 HL points to the player vischar at this point.
  $68D7 *++HL &= ~vischar_BYTE1_BIT7; // $8001
  $68DA A = ($801C); // room index
  $68DD room_index = A;
  $68E0 if (A == 0) {
  $68E4   HL += 12;
  $68E8   *HL++ = 0x80; // $800D // likely a character direction
  $68EB   *HL &= 3;     // $800E // likely a sprite direction
  $68EF   reset_B2FC();
  $68F2   goto squash_stack_goto_main; }
;
; fallthrough

c $68F4 enter_room
; This entry point is used by the routines at #R$9D78, #R$9DE5 and #R$B75A.
  $68F4 plot_game_screen_x = 0;
  $68FA setup_room();
  $68FD plot_indoor_tiles();
  $6900 map_position = 0xEA74;
  $6906 set_player_sprite_for_room();
D $6909 This assignment to HL is redundant: reset_position sets HL to $8000 as its first instruction.
  $6909 HL = $8000;
  $690C reset_position(); // reset player
  $690F setup_movable_items();
  $6912 zoombox();
  $6915 increase_score(1);
;
; fallthrough

c $691A squash_stack_goto_main
  $691A SP = $FFFF;
  $691D goto main_loop;

; ------------------------------------------------------------------------------

c $6920 set_player_sprite_for_room
D $6920 Called when changing rooms.
D $6920 For tunnels this forces the player sprite to 'prisoner' and sets the crawl flag appropriately.
  $6920 HL = $800D;
  $6923 *HL++ = 0x80; // likely a character direction
  $6926 if (room_index >= room_29_secondtunnelstart) {
  $692D   *HL |= vischar_BYTE14_CRAWL; // $800E, set crawl flag
  $692F   $8015 = &sprite_prisoner_tl_4; }
  $6935 else {
  $6936   *HL &= ~vischar_BYTE14_CRAWL; } // clear crawl flag
  $6938 return;

; ------------------------------------------------------------------------------

c $6939 setup_movable_items
  $6939 reset_nonplayer_visible_characters();
  $693C A = room_index;
  $693F      if (A == room_2_hut2left) setup_stove1();
  $6949 else if (A == room_4_hut3left) setup_stove2();
  $6953 else if (A == room_9_crate)    setup_crate();
  $695B called_from_main_loop_7();
  $695E mark_nearby_items();
  $6961 called_from_main_loop_9();
  $6964 move_map();
  $6967 searchlight(); return;

  $696A setup_crate: HL = &movable_items[movable_item_CRATE];
  $696D A = character_28_crate;
  $696F goto setup_movable_items_common;

  $6971 setup_stove2: HL = &movable_items[movable_item_STOVE2];
  $6974 A = character_27_stove2;
  $6976 goto setup_movable_items_common;

  $6978 setup_stove1: HL = &movable_items[movable_item_STOVE1];
  $697B A = character_26_stove1;
;
; fallthrough

; movable item takes the first non-player vischar
  $697D setup_movable_items_common: $8020 = A; // character index
  $6980 memcpy($802F, HL, 9); // non-player character 0 is $8020..$803F
  $6988 memcpy($8021, movable_item_reset_data, 14);
  $6993 $803C = room_index;
  $6999 HL = $8020;
  $699C reset_position(); // reset item vischar
  $699F return;

D $69A0 Fourteen bytes of reset data.
B $69A0 movable_item_reset_data

b $69AE movable_items
D $69AE struct movable_item { word y_coord, x_coord, vertical_offset; const sprite *; byte terminator; };
D $69AE Sub-struct of vischar ($802F..$8038).
  $69AE struct movable_item stove1 = { { 62, 35, 16 }, &sprite_stove, 0 };
  $69B7 struct movable_item crate  = { { 55, 54, 14 }, &sprite_crate, 0 };
  $69C0 struct movable_item stove2 = { { 62, 35, 16 }, &sprite_stove, 0 };

; ------------------------------------------------------------------------------

c $69C9 reset_nonplayer_visible_characters
D $69C9 Reset all non-player visible characters.
  $69C9 HL = $8020; // iterate over non-player characters
  $69CC B = 7; // 7 iterations
  $69CF do { PUSH BC
  $69D0   PUSH HL
  $69D1   reset_visible_character();
  $69D4   POP HL
  $69D5   POP BC
  $69D6   HL += 32; // stride
  $69D9 } while (--B);
  $69DB return;

; ------------------------------------------------------------------------------

c $69DC setup_doors
D $69DC Looks like it's filling door_related with stuff from the door_positions table.
D $69DC Wipe $81D6..$81D9 (door_related) with 0xFF.
  $69DC -
  $69DE DE = door_related + 3;
  $69E1 B = 4;
  $69E3 do { *DE-- = 0xFF;
  $69E5 } while (--B);
  $69E7 DE++; // DE = &door_related[0];
  $69E8 B = room_index << 2;
  $69EE C = 0;
  $69F1 HLdash = &door_positions[0];
  $69F4 Bdash = 124; // length of door_positions
  $69F6 -
  $69F9 do { if (HLdash[0] & 0xFC == B) {
  $6A00     *DE++ = C ^ 0x80; }
  $6A05   C ^= 0x80;
  $6A08   if (C >= 0) C++; // increment every two stops?
  $6A0E   HLdash += 4; }
  $6A0F while (--Bdash);
  $6A11 return;

; ------------------------------------------------------------------------------

c $6A12 get_door_position
D $6A12 Index turns into door_position struct pointer.
R $6A12 I:A  Index of ...
R $6A12 O:HL Pointer to ...
R $6A12 O:DE Corrupted.
  $6A12 HL = &door_positions[(A * 2) & 0xFF]; // are they pairs of doors?
  $6A1D if (A & (1<<7)) HL += 4;
  $6A26 return;

; ------------------------------------------------------------------------------

c $6A27 wipe_visible_tiles
D $6A27 Wipe the visible tiles array at $F0F8 (24 * 17 = 408).
  $6A27 memset($F0F8, 0, 408);
  $6A34 return;

; ------------------------------------------------------------------------------

c $6A35 setup_room
  $6A35 wipe_visible_tiles();
  $6A38 HL = rooms_and_tunnels[room_index - 1];
  $6A48 PUSH HL
  $6A49 setup_doors();
  $6A4C POP HL
  $6A4D DE = &roomdef_bounds_index; // room dimensions index
  $6A50 *DE++ = *HL++;
  $6A52 A = *HL;
  $6A53 -
  $6A54 *DE = A;
  $6A55 if (A == 0) { // no objects? (boundaries)
  $6A57   HL++; }
  $6A58 else {
  $6A5A   memcpy(DE, HL, A * 4 + 1); HL += A * 4 + 1; }
  $6A62 DE = &suspected_indoor_mask_data;
  $6A65 A = *HL++; // sampled HL=$6E22,$6EF8,$6F38 (unique per room, but never when outside)
  $6A67 *DE = A;
  $6A68 -
  $6A69 if (A) {
  $6A6B   DE++;
  $6A6C   B = A;
  $6A6D   do { -
  $6A6E     -
  $6A6F     memcpy(DE, &stru_EA7C[*HL++], 7);
  $6A83     *DE++ = 32;
  $6A87     -
  $6A88     -
  $6A89     - }
  $6A8A   while (--B); }
D $6A8C Plot all objects.
  $6A8C B = *HL; // count of objects  // sample: HL -> $6E25 (room_16_corridor + 5)
  $6A8D if (B == 0) return;
  $6A90 HL++;
  $6A91 do { PUSH BC
  $6A92   C = *HL++; // object index
  $6A94   A = *HL++; // column
  $6A96   -
  $6A97   DE = $F0F8 + *HL * 24 + A; // $F0F8 = visible tiles array (so *HL = row, A = column)
  $6AAB   expand_object(C); // pass C as A
  $6AAF   -
  $6AB0   POP BC
  $6AB1   HL++; }
  $6AB2 while (--B);
  $6AB4 return;

; room format:
;
; 0
; 1
; 2
; 3
; 4
; 5 number of objects
; for each object:
;   0 object index
;   1 x
;   2 y
;

; ------------------------------------------------------------------------------

c $6AB5 expand_object
D $6AB5 Expands RLE-encoded objects to a full set of tile references.
D $6AB5 Format:
D $6AB5 <w> <h>: width, height
D $6AB5 Repeat:
D $6AB5 <t>: emit tile <t>
D $6AB5 <0xFF> <64..127> <t>: emit tile <t> <t+1> <t+2> .. up to 63 times
D $6AB5 <0xFF> <128..254> <t>: emit tile <t> up to 126 times
D $6AB5 <0xFF> <0xFF>: emit <0xFF>
R $6AB5 I:A  Object index.
R $6AB5 I:DE Receives expanded tiles. Must point to correct x,y in tile buf.
R $6AB5 O:BC Corrupted.
R $6AB5 O:HL Corrupted.
  $6AB5 HL = interior_object_defs[A];
  $6AC1 B = *HL++; // width
  $6AC3 C = *HL++; // height
  $6AC5 ($6AE7) = B; // self modify (== width)
  $6AC9 do { do { expand: A = *HL;
  $6ACA     if (A == objecttile_ESCAPE) {
  $6ACE       HL++;
  $6ACF       A = *HL;
  $6AD0       if (A != objecttile_ESCAPE) { // FF FF => FF
  $6AD4         A &= 0xF0; // redundant?
  $6AD6         if (A >= 128) goto $6AF4;
  $6ADA         if (A == 64) goto $6B19; } }
  $6ADE     if (A) *DE = A;
  $6AE2     HL++;
  $6AE3     DE++;
  $6AE4   } while (--B);
  $6AE6   B = 1; // self modified
  $6AE8   DE += 24 - B;
  $6AF0 } while (--C); // for each row
  $6AF3 return;
;
; 128..255 case
  $6AF4 A = *HL++ & 0x7F;
  $6AF7 -
  $6AF9 Adash = *HL;
  $6AFA -
  $6AFB do {
  $6AFC   if (Adash > 0) *DE = Adash;
  $6B00   DE++;
  $6B01   DJNZ $6B12
; ran out of width
  $6B03   LD Adash,($6AE7)  // Adash = width
  $6B07   DE += 24 -    Adash; // stride
  $6B0F   Adash = *HL;
  $6B10   if (--C == 0) return;
;
  $6B12   -
  $6B13 } while (--A);
  $6B16 HL++;
  $6B17 goto expand;
;
; 64..127 case
  $6B19 A = 60; // opcode of 'INC A'
D $6B1B Redundant: Self modify, but nothing else modifies it! Possible evidence that other encodings (e.g. 'DEC A') were attempted.
  $6B1B ($6B28) = A;
  $6B1E A = *HL++ & 0x0F;
  $6B21 -
  $6B23 Adash = *HL;
  $6B24 -
  $6B25 do { -
  $6B26   *DE++ = Adash;
  $6B28   INC Adash // self modified
  $6B29   DJNZ $6B3B
  $6B2B   PUSH AFdash
  $6B2C   LD Adash,($6AE7)  // Adash = width
  $6B30   DE += 24 - Adash; // stride
  $6B38   POP AFdash
  $6B3A   if (--C == 0) return;
;
  $6B3B   -
  $6B3D } while (--A);
  $6B3F HL++;
  $6B40 goto expand;

; ------------------------------------------------------------------------------

c $6B42 plot_indoor_tiles
D $6B42 Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer.
R $6B42 O:A      Corrupted.
R $6B42 O:BC     Corrupted.
R $6B42 O:DE     Corrupted.
R $6B42 O:HL     Corrupted.
R $6B42 O:Adash  Corrupted.
R $6B42 O:BCdash Corrupted.
R $6B42 O:DEdash Corrupted.
R $6B42 O:HLdash Corrupted.
  $6B42 HL = $F290;  // screen buffer start address
  $6B45 DE = $F0F8;  // visible tiles array
  $6B48 C = 16;      // rows
  $6B4A do { B = 24; // columns
  $6B4C   do {
  $6B4D     tileptr = &interior_tiles[*DE];
  $6B59     screenptr = HL;
  $6B5A     iters = 8; stride = 24;
  $6B5D     do { *screenptr = *tileptr++;
  $6B5F       screenptr += stride;
  $6B66     } while (--iters);
  $6B69     DE++;
  $6B6A     HL++;
  $6B6B   } while (--B);
  $6B6D   HL += 7 * 24;
  $6B74 } while (--C);
  $6B78 return;

; ------------------------------------------------------------------------------

w $6B79 beds
D $6B79 6x pointers to bed. These are the beds of active prisoners.
D $6B79 Note that the top hut has prisoners permanently in bed.
  $6B79 { &roomdef_3_hut2_right[29],
  $6B7B   &roomdef_3_hut2_right[32],
  $6B7D   &roomdef_3_hut2_right[35],
  $6B7F   &roomdef_5_hut3_right[29],
  $6B81   &roomdef_5_hut3_right[32],
  $6B83   &roomdef_5_hut3_right[35], };

; ------------------------------------------------------------------------------

b $6B85 roomdef_bounds
D $6B85 Suspect these are room dimensions.
D $6B85,40,4 10x 4-byte structures which are range checked by routine at #R$B29F.

; ------------------------------------------------------------------------------

w $6BAD rooms_and_tunnels
D $6BAD Rooms and tunnels.
D $6BAD Array of pointers to rooms (starting with room 1).
  $6BAD &roomdef_1_hut1_right,
  $6BAF &roomdef_2_hut2_left,
  $6BB1 &roomdef_3_hut2_right,
  $6BB3 &roomdef_4_hut3_left,
  $6BB5 &roomdef_5_hut3_right,
  $6BB7 &roomdef_8_corridor, // unused
  $6BB9 &roomdef_7_corridor,
  $6BBB &roomdef_8_corridor,
  $6BBD &roomdef_9_crate,
  $6BBF &roomdef_10_lockpick,
  $6BC1 &roomdef_11_papers,
  $6BC3 &roomdef_12_corridor,
  $6BC5 &roomdef_13_corridor,
  $6BC7 &roomdef_14_torch,
  $6BC9 &roomdef_15_uniform,
  $6BCB &roomdef_16_corridor,
  $6BCD &roomdef_7_corridor,
  $6BCF &roomdef_18_radio,
  $6BD1 &roomdef_19_food,
  $6BD3 &roomdef_20_redcross,
  $6BD5 &roomdef_16_corridor,
  $6BD7 &roomdef_22_red_key,
  $6BD9 &roomdef_23_breakfast,
  $6BDB &roomdef_24_solitary,
  $6BDD &roomdef_25_breakfast,
  $6BDF &roomdef_28_hut1_left, // unused
  $6BE1 &roomdef_28_hut1_left, // unused
  $6BE3 &roomdef_28_hut1_left,
D $6BE5 Array of pointers to tunnels.
  $6BE5 &roomdef_29_second_tunnel_start,
  $6BE7 &roomdef_30,
  $6BE9 &roomdef_31,
  $6BEB &roomdef_32,
  $6BED &roomdef_29_second_tunnel_start,
  $6BEF &roomdef_34,
  $6BF1 &roomdef_35,
  $6BF3 &roomdef_36,
  $6BF5 &roomdef_34,
  $6BF7 &roomdef_35,
  $6BF9 &roomdef_32,
  $6BFB &roomdef_40,
  $6BFD &roomdef_30,
  $6BFF &roomdef_32,
  $6C01 &roomdef_29_second_tunnel_start,
  $6C03 &roomdef_44,
  $6C05 &roomdef_36,
  $6C07 &roomdef_36,
  $6C09 &roomdef_32,
  $6C0B &roomdef_34,
  $6C0D &roomdef_36,
  $6C0F &roomdef_50_blocked_tunnel,
  $6C11 &roomdef_32,
  $6C13 &roomdef_40,

b $6C15 room_defs
D $6C15 roomdef_1_hut1_right
  $6C15,19 TBD: [0, 3, 54, 68, 23, 34, 54, 68, 39, 50, 54, 68, 55, 68, 4, 0, 1, 3, 10]
  $6C28,1 10 // nobjects
  $6C29,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6C2C,3 { interiorobject_WIDE_WINDOW,                 8,  0 },
  $6C2F,3 { interiorobject_WIDE_WINDOW,                 2,  3 },
  $6C32,3 { interiorobject_OCCUPIED_BED,               10,  5 },
  $6C35,3 { interiorobject_OCCUPIED_BED,                6,  7 },
  $6C38,3 { interiorobject_DOOR_FRAME_15,              15,  8 },
  $6C3B,3 { interiorobject_WARDROBE_WITH_KNOCKERS,     18,  5 },
  $6C3E,3 { interiorobject_WARDROBE_WITH_KNOCKERS,     20,  6 },
  $6C41,3 { interiorobject_EMPTY_BED,                   2,  9 },
  $6C44,3 { interiorobject_DOOR_FRAME_16,               7, 10 },

D $6C47 roomdef_2_hut2_left
  $6C47,13 TBD: [1, 2, 48, 64, 43, 56, 24, 38, 26, 40, 2, 13, 8]
  $6C54,1 8 // nobjects
  $6C55,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6C58,3 { interiorobject_WIDE_WINDOW,                 6,  2 },
  $6C5B,3 { interiorobject_DOOR_FRAME_40,              16,  5 },
  $6C5E,3 { interiorobject_STOVE_PIPE,                  4,  5 },
  $6C61,3 { interiorobject_OCCUPIED_BED,                8,  7 }, // player's bed
  $6C64,3 { interiorobject_DOOR_FRAME_16,               7,  9 },
  $6C67,3 { interiorobject_TABLE_2,                    11, 12 },
  $6C6A,3 { interiorobject_SMALL_TUNNEL_ENTRANCE,       5,  9 },

D $6C6D roomdef_3_hut2_right
  $6C6D,19 TBD: [0, 3, 54, 68, 23, 34, 54, 68, 39, 50, 54, 68, 55, 68, 4, 0, 1, 3, 10]
  $6C80,1 10 // nobjects
  $6C81,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6C84,3 { interiorobject_WIDE_WINDOW,                 8,  0 },
  $6C87,3 { interiorobject_WIDE_WINDOW,                 2,  3 },
  $6C8A,3 { interiorobject_OCCUPIED_BED,               10,  5 }, // bed_C
  $6C8D,3 { interiorobject_OCCUPIED_BED,                6,  7 }, // bed_B
  $6C90,3 { interiorobject_OCCUPIED_BED,                2,  9 },
  $6C93,3 { interiorobject_CHEST_OF_DRAWERS,           16,  5 },
  $6C96,3 { interiorobject_DOOR_FRAME_15,              15,  8 },
  $6C99,3 { interiorobject_SHORT_WARDROBE,             18,  5 },
  $6C9C,3 { interiorobject_DOOR_FRAME_16,               7, 10 },

D $6C9F roomdef_4_hut3_left
  $6C9F,14 TBD: [1, 2, 24, 40, 24, 42, 48, 64, 43, 56, 3, 18, 20, 8]
  $6CAD,1 9 // nobjects
  $6CAE,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6CB1,3 { interiorobject_DOOR_FRAME_40,              16,  5 },
  $6CB4,3 { interiorobject_WIDE_WINDOW,                 6,  2 },
  $6CB7,3 { interiorobject_STOVE_PIPE,                  4,  5 },
  $6CBA,3 { interiorobject_EMPTY_BED,                   8,  7 },
  $6CBD,3 { interiorobject_DOOR_FRAME_16,               7,  9 },
  $6CC0,3 { interiorobject_CHAIR_POINTING_BOTTOM_RIGHT,11, 11 },
  $6CC3,3 { interiorobject_CHAIR_POINTING_BOTTOM_LEFT, 13, 10 },
  $6CC6,3 { interiorobject_STUFF_31,                   14, 14 },

D $6CC9 roomdef_5_hut3_right
  $6CC9,19 TBD: [0, 3, 54, 68, 23, 34, 54, 68, 39, 50, 54, 68, 55, 68, 4, 0, 1, 3, 10]
  $6CDC,1 10 // nobjects
  $6CDD,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6CE0,3 { interiorobject_WIDE_WINDOW,                 8,  0 },
  $6CE3,3 { interiorobject_WIDE_WINDOW,                 2,  3 },
  $6CE6,3 { interiorobject_OCCUPIED_BED,               10,  5 }, // bed_D
  $6CE9,3 { interiorobject_OCCUPIED_BED,                6,  7 }, // bed_E
  $6CEC,3 { interiorobject_OCCUPIED_BED,                2,  9 }, // bed_F
  $6CEF,3 { interiorobject_DOOR_FRAME_15,              15,  8 },
  $6CF2,3 { interiorobject_CHEST_OF_DRAWERS,           16,  5 },
  $6CF5,3 { interiorobject_CHEST_OF_DRAWERS,           20,  7 },
  $6CF8,3 { interiorobject_DOOR_FRAME_16,               7, 10 },

D $6CFB roomdef_8_corridor
  $6CFB,4 TBD: [2, 0, 1, 9]
  $6CFF,1 5 // nobjects
  $6D00,3 { interiorobject_ROOM_OUTLINE_46,             3,  6 },
  $6D03,3 { interiorobject_DOOR_FRAME_38,              10,  3 },
  $6D06,3 { interiorobject_DOOR_FRAME_38,               4,  6 },
  $6D09,3 { interiorobject_DOOR_FRAME_16,               5, 10 },
  $6D0C,3 { interiorobject_SHORT_WARDROBE,             18,  6 },

D $6D0F roomdef_9_crate
  $6D0F,9 TBD: [1, 1, 58, 64, 28, 42, 2, 4, 21]
  $6D18,1 10 // nobjects
  $6D19,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6D1C,3 { interiorobject_SMALL_WINDOW,                6,  3 },
  $6D1F,3 { interiorobject_SMALL_SHELF,                 9,  4 },
  $6D22,3 { interiorobject_DOOR_FRAME_36,              12,  6 },
  $6D25,3 { interiorobject_DOOR_FRAME_15,              13, 10 },
  $6D28,3 { interiorobject_TALL_WARDROBE,              16,  6 },
  $6D2B,3 { interiorobject_SHORT_WARDROBE,             18,  8 },
  $6D2E,3 { interiorobject_CUPBOARD,                    3,  6 },
  $6D31,3 { interiorobject_SMALL_CRATE,                 6,  8 },
  $6D34,3 { interiorobject_SMALL_CRATE,                 4,  9 },

D $6D37 roomdef_10_lockpick
  $6D37,14 TBD: [4, 2, 69, 75, 32, 54, 36, 47, 48, 60, 3, 6, 14, 22]
  $6D45,1 14 // nobjects
  $6D46,3 { interiorobject_ROOM_OUTLINE_47,             1,  4 },
  $6D49,3 { interiorobject_DOOR_FRAME_15,              15, 10 },
  $6D4C,3 { interiorobject_SMALL_WINDOW,                4,  1 },
  $6D4F,3 { interiorobject_KEY_RACK,                    2,  3 },
  $6D52,3 { interiorobject_KEY_RACK,                    7,  2 },
  $6D55,3 { interiorobject_TALL_WARDROBE,              10,  2 },
  $6D58,3 { interiorobject_CUPBOARD_42,                13,  3 },
  $6D5B,3 { interiorobject_CUPBOARD_42,                15,  4 },
  $6D5E,3 { interiorobject_CUPBOARD_42,                17,  5 },
  $6D61,3 { interiorobject_TABLE_2,                    14,  8 },
  $6D64,3 { interiorobject_CHEST_OF_DRAWERS,           18,  8 },
  $6D67,3 { interiorobject_CHEST_OF_DRAWERS,           20,  9 },
  $6D6A,3 { interiorobject_SMALL_CRATE,                 6,  5 },
  $6D6D,3 { interiorobject_TABLE_2,                     2,  6 },

D $6D70 roomdef_11_papers
  $6D70,8 TBD: [4, 1, 27, 44, 36, 48, 1, 23]
  $6D78,1 9 // nobjects
  $6D79,3 { interiorobject_ROOM_OUTLINE_47,             1,  4 },
  $6D7C,3 { interiorobject_SMALL_SHELF,                 6,  3 },
  $6D7F,3 { interiorobject_TALL_WARDROBE,              12,  3 },
  $6D82,3 { interiorobject_DRAWERS_50,                 10,  3 },
  $6D85,3 { interiorobject_SHORT_WARDROBE,             14,  5 },
  $6D88,3 { interiorobject_DOOR_FRAME_38,               2,  2 },
  $6D8B,3 { interiorobject_DRAWERS_50,                 18,  7 },
  $6D8E,3 { interiorobject_DRAWERS_50,                 20,  8 },
  $6D91,3 { interiorobject_DESK,                       12, 10 },

D $6D94 roomdef_12_corridor
  $6D94,5 TBD: [1, 0, 2, 4, 7]
  $6D99,1 4 // nobjects
  $6D9A,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6D9D,3 { interiorobject_SMALL_WINDOW,                6,  3 },
  $6DA0,3 { interiorobject_DOOR_FRAME_16,               9, 10 },
  $6DA3,3 { interiorobject_DOOR_FRAME_15,              13, 10 },

D $6DA6 roomdef_13_corridor
  $6DA6,5 TBD: [1, 0, 2, 4, 8]
  $6DAB,1 6 // nobjects
  $6DAC,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6DAF,3 { interiorobject_DOOR_FRAME_38,               6,  3 },
  $6DB2,3 { interiorobject_DOOR_FRAME_16,               7,  9 },
  $6DB5,3 { interiorobject_DOOR_FRAME_15,              13, 10 },
  $6DB8,3 { interiorobject_DRAWERS_50,                 12,  5 },
  $6DBB,3 { interiorobject_CHEST_OF_DRAWERS,           14,  7 },

D $6DBE roomdef_14_torch
  $6DBE,16 TBD: [0, 3, 54, 68, 22, 32, 62, 68, 48, 58, 54, 68, 54, 68, 1, 1]
  $6DCE,1 9 // nobjects
  $6DCF,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6DD2,3 { interiorobject_DOOR_FRAME_38,               4,  3 },
  $6DD5,3 { interiorobject_TINY_DRAWERS,                8,  5 },
  $6DD8,3 { interiorobject_EMPTY_BED,                  10,  5 },
  $6DDB,3 { interiorobject_CHEST_OF_DRAWERS,           16,  5 },
  $6DDE,3 { interiorobject_SHORT_WARDROBE,             18,  5 },
  $6DE1,3 { interiorobject_DOOR_FRAME_40,              20,  4 },
  $6DE4,3 { interiorobject_SMALL_SHELF,                 2,  7 },
  $6DE7,3 { interiorobject_EMPTY_BED,                   2,  9 },

D $6DEA roomdef_15_uniform
  $6DEA,23 TBD: [0, 4, 54, 68, 22, 32, 54, 68, 54, 68, 62, 68, 40, 58, 30, 40, 56, 67, 4, 1, 5, 10, 15]
  $6E01,1 10 // nobjects
  $6E02,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6E05,3 { interiorobject_SHORT_WARDROBE,             16,  4 },
  $6E08,3 { interiorobject_EMPTY_BED,                  10,  5 },
  $6E0B,3 { interiorobject_TINY_DRAWERS,                8,  5 },
  $6E0E,3 { interiorobject_TINY_DRAWERS,                6,  6 },
  $6E11,3 { interiorobject_SMALL_SHELF,                 2,  7 },
  $6E14,3 { interiorobject_EMPTY_BED,                   2,  9 },
  $6E17,3 { interiorobject_DOOR_FRAME_16,               7, 10 },
  $6E1A,3 { interiorobject_DOOR_FRAME_15,              13,  9 },
  $6E1D,3 { interiorobject_TABLE_2,                    18,  8 },

D $6E20 roomdef_16_corridor
  $6E20,5 TBD: [1, 0, 2, 4, 7]
  $6E25,1 4 // nobjects
  $6E26,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6E29,3 { interiorobject_DOOR_FRAME_38,               4,  4 },
  $6E2C,3 { interiorobject_DOOR_FRAME_16,               9, 10 },
  $6E2F,3 { interiorobject_DOOR_FRAME_15,              13, 10 },

D $6E32 roomdef_7_corridor
  $6E32,4 TBD: [1, 0, 1, 4]
  $6E36,1 4 // nobjects
  $6E37,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6E3A,3 { interiorobject_DOOR_FRAME_38,               4,  4 },
  $6E3D,3 { interiorobject_DOOR_FRAME_15,              13, 10 },
  $6E40,3 { interiorobject_TALL_WARDROBE,              12,  4 },

D $6E43 roomdef_18_radio
  $6E43,20 TBD: [4, 3, 38, 56, 48, 60, 38, 46, 39, 60, 22, 32, 48, 60, 5, 11, 17, 16, 24, 25]
  $6E57,1 10 // nobjects
  $6E58,3 { interiorobject_ROOM_OUTLINE_47,             1,  4 },
  $6E5B,3 { interiorobject_CUPBOARD,                    1,  4 },
  $6E5E,3 { interiorobject_SMALL_WINDOW,                4,  1 },
  $6E61,3 { interiorobject_SMALL_SHELF,                 7,  2 },
  $6E64,3 { interiorobject_DOOR_FRAME_40,              10,  1 },
  $6E67,3 { interiorobject_TABLE_2,                    12,  7 },
  $6E6A,3 { interiorobject_MESS_BENCH_SHORT,           12,  9 },
  $6E6D,3 { interiorobject_TABLE_2,                    18, 10 },
  $6E70,3 { interiorobject_TINY_TABLE,                 16, 12 },
  $6E73,3 { interiorobject_DOOR_FRAME_16,               5,  7 },

D $6E76 roomdef_19_food
  $6E76,8 TBD: [1, 1, 52, 64, 47, 56, 1, 7]
  $6E7E,1 11 // nobjects
  $6E7F,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6E82,3 { interiorobject_SMALL_WINDOW,                6,  3 },
  $6E85,3 { interiorobject_CUPBOARD,                    9,  3 },
  $6E88,3 { interiorobject_CUPBOARD_42,                12,  3 },
  $6E8B,3 { interiorobject_CUPBOARD_42,                14,  4 },
  $6E8E,3 { interiorobject_TABLE_2,                     9,  6 },
  $6E91,3 { interiorobject_SMALL_SHELF,                 3,  5 },
  $6E94,3 { interiorobject_SINK,                        3,  7 },
  $6E97,3 { interiorobject_CHEST_OF_DRAWERS,           14,  7 },
  $6E9A,3 { interiorobject_DOOR_FRAME_40,              16,  5 },
  $6E9D,3 { interiorobject_DOOR_FRAME_16,               9, 10 },

D $6EA0 roomdef_20_redcross
  $6EA0,13 TBD: [1, 2, 58, 64, 26, 42, 50, 64, 46, 54, 2, 21, 4]
  $6EAD,1 11 // nobjects
  $6EAE,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6EB1,3 { interiorobject_DOOR_FRAME_15,              13, 10 },
  $6EB4,3 { interiorobject_SMALL_SHELF,                 9,  4 },
  $6EB7,3 { interiorobject_CUPBOARD,                    3,  6 },
  $6EBA,3 { interiorobject_SMALL_CRATE,                 6,  8 },
  $6EBD,3 { interiorobject_SMALL_CRATE,                 4,  9 },
  $6EC0,3 { interiorobject_TABLE_2,                     9,  6 },
  $6EC3,3 { interiorobject_TALL_WARDROBE,              14,  5 },
  $6EC6,3 { interiorobject_TALL_WARDROBE,              16,  6 },
  $6EC9,3 { interiorobject_WARDROBE_WITH_KNOCKERS,     18,  8 },
  $6ECC,3 { interiorobject_TINY_TABLE,                 11,  8 },

D $6ECF roomdef_22_red_key
  $6ECF,13 TBD: [3, 2, 54, 64, 46, 56, 58, 64, 36, 44, 2, 12, 21]
  $6EDC,1 7 // nobjects
  $6EDD,3 { interiorobject_ROOM_OUTLINE_41,             5,  6 },
  $6EE0,3 { interiorobject_NOTICEBOARD,                 4,  4 },
  $6EE3,3 { interiorobject_SMALL_SHELF,                 9,  4 },
  $6EE6,3 { interiorobject_SMALL_CRATE,                 6,  8 },
  $6EE9,3 { interiorobject_DOOR_FRAME_16,               9,  8 },
  $6EEC,3 { interiorobject_TABLE_2,                     9,  6 },
  $6EEF,3 { interiorobject_DOOR_FRAME_40,              14,  4 },

D $6EF2 roomdef_23_breakfast
  $6EF2,9 TBD: [0, 1, 54, 68, 34, 68, 2, 10, 3]
  $6EFB,1 12 // nobjects
  $6EFC,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6EFF,3 { interiorobject_SMALL_WINDOW,                8,  0 },
  $6F02,3 { interiorobject_SMALL_WINDOW,                2,  3 },
  $6F05,3 { interiorobject_DOOR_FRAME_16,               7, 10 },
  $6F08,3 { interiorobject_MESS_TABLE,                  5,  4 },
  $6F0B,3 { interiorobject_CUPBOARD_42,                18,  4 },
  $6F0E,3 { interiorobject_DOOR_FRAME_40,              20,  4 },
  $6F11,3 { interiorobject_DOOR_FRAME_15,              15,  8 },
  $6F14,3 { interiorobject_MESS_BENCH,                  7,  6 },
  $6F17,3 { interiorobject_EMPTY_BENCH,                12,  5 }, // bench_A
  $6F1A,3 { interiorobject_EMPTY_BENCH,                10,  6 },
  $6F1D,3 { interiorobject_EMPTY_BENCH,                 8,  7 },

D $6F20 roomdef_24_solitary
  $6F20,8 TBD: [3, 1, 48, 54, 38, 46, 1, 26]
  $6F28,1 3 // nobjects
  $6F29,3 { interiorobject_ROOM_OUTLINE_41,             5,  6 },
  $6F2C,3 { interiorobject_DOOR_FRAME_40,              14,  4 },
  $6F2F,3 { interiorobject_TINY_TABLE,                 10,  9 },

D $6F32 roomdef_25_breakfast
  $6F32,7 TBD: [0, 1, 54, 68, 34, 68, 0]
  $6F39,1 11 // nobjects
  $6F3A,3 { interiorobject_ROOM_OUTLINE_2,              1,  4 },
  $6F3D,3 { interiorobject_SMALL_WINDOW,                8,  0 },
  $6F40,3 { interiorobject_CUPBOARD,                    5,  3 },
  $6F43,3 { interiorobject_SMALL_WINDOW,                2,  3 },
  $6F46,3 { interiorobject_DOOR_FRAME_40,              18,  3 },
  $6F49,3 { interiorobject_MESS_TABLE,                  5,  4 },
  $6F4C,3 { interiorobject_MESS_BENCH,                  7,  6 },
  $6F4F,3 { interiorobject_EMPTY_BENCH,                12,  5 }, // bench_D
  $6F52,3 { interiorobject_EMPTY_BENCH,                10,  6 },
  $6F55,3 { interiorobject_EMPTY_BENCH,                 8,  7 },
  $6F58,3 { interiorobject_EMPTY_BENCH,                14,  4 },

D $6F5B roomdef_28_hut1_left
  $6F5B,14 TBD: [1, 2, 28, 40, 28, 52, 48, 63, 44, 56, 3, 8, 13, 19]
  $6F69,1 8 // nobjects
  $6F6A,3 { interiorobject_ROOM_OUTLINE_27,             3,  6 },
  $6F6D,3 { interiorobject_WIDE_WINDOW,                 6,  2 },
  $6F70,3 { interiorobject_DOOR_FRAME_40,              14,  4 },
  $6F73,3 { interiorobject_CUPBOARD,                    3,  6 },
  $6F76,3 { interiorobject_OCCUPIED_BED,                8,  7 },
  $6F79,3 { interiorobject_DOOR_FRAME_16,               7,  9 },
  $6F7C,3 { interiorobject_CHAIR_POINTING_BOTTOM_LEFT, 15, 10 },
  $6F7F,3 { interiorobject_TABLE_2,                    11, 12 },

D $6F82 roomdef_29_second_tunnel_start
  $6F82,9 TBD: [5, 0, 6, 30, 31, 32, 33, 34, 35]
  $6F8B,1 6 // nobjects
  $6F8C,3 { interiorobject_TUNNEL_0,                   20,  0 },
  $6F8F,3 { interiorobject_TUNNEL_0,                   16,  2 },
  $6F92,3 { interiorobject_TUNNEL_0,                   12,  4 },
  $6F95,3 { interiorobject_TUNNEL_0,                    8,  6 },
  $6F98,3 { interiorobject_TUNNEL_0,                    4,  8 },
  $6F9B,3 { interiorobject_TUNNEL_0,                    0, 10 },

D $6F9E roomdef_31
  $6F9E,9 TBD: [6, 0, 6, 36, 37, 38, 39, 40, 41]
  $6FA7,1 6 // nobjects
  $6FA8,3 { interiorobject_TUNNEL_3,                    0,  0 },
  $6FAB,3 { interiorobject_TUNNEL_3,                    4,  2 },
  $6FAE,3 { interiorobject_TUNNEL_3,                    8,  4 },
  $6FB1,3 { interiorobject_TUNNEL_3,                   12,  6 },
  $6FB4,3 { interiorobject_TUNNEL_3,                   16,  8 },
  $6FB7,3 { interiorobject_TUNNEL_3,                   20, 10 },

D $6FBA roomdef_36
  $6FBA,9 TBD: [7, 0, 6, 31, 32, 33, 34, 35, 45]
  $6FC3,1 5 // nobjects
  $6FC4,3 { interiorobject_TUNNEL_0,                   20,  0 },
  $6FC7,3 { interiorobject_TUNNEL_0,                   16,  2 },
  $6FCA,3 { interiorobject_TUNNEL_0,                   12,  4 },
  $6FCD,3 { interiorobject_TUNNEL_0,                    8,  6 },
  $6FD0,3 { interiorobject_TUNNEL_14,                   4,  8 },

D $6FD3 roomdef_32
  $6FD3,9 TBD: [8, 0, 6, 36, 37, 38, 39, 40, 42]
  $6FDC,1 5 // nobjects
  $6FDD,3 { interiorobject_TUNNEL_3,                    0,  0 },
  $6FE0,3 { interiorobject_TUNNEL_3,                    4,  2 },
  $6FE3,3 { interiorobject_TUNNEL_3,                    8,  4 },
  $6FE6,3 { interiorobject_TUNNEL_3,                   12,  6 },
  $6FE9,3 { interiorobject_TUNNEL_17,                  16,  8 },

D $6FEC roomdef_34
  $6FEC,9 TBD: [6, 0, 6, 36, 37, 38, 39, 40, 46]
  $6FF5,1 6 // nobjects
  $6FF6,3 { interiorobject_TUNNEL_3,                    0,  0 },
  $6FF9,3 { interiorobject_TUNNEL_3,                    4,  2 },
  $6FFC,3 { interiorobject_TUNNEL_3,                    8,  4 },
  $6FFF,3 { interiorobject_TUNNEL_3,                   12,  6 },
  $7002,3 { interiorobject_TUNNEL_3,                   16,  8 },
  $7005,3 { interiorobject_TUNNEL_18,                  20, 10 },

D $7008 roomdef_35
  $7008,9 TBD: [6, 0, 6, 36, 37, 38, 39, 40, 41]
  $7011,1 6 // nobjects
  $7012,3 { interiorobject_TUNNEL_3,                    0,  0 },
  $7015,3 { interiorobject_TUNNEL_3,                    4,  2 },
  $7018,3 { interiorobject_TUNNEL_JOIN_4,               8,  4 },
  $701B,3 { interiorobject_TUNNEL_3,                   12,  6 },
  $701E,3 { interiorobject_TUNNEL_3,                   16,  8 },
  $7021,3 { interiorobject_TUNNEL_3,                   20, 10 },

D $7024 roomdef_30
  $7024,10 TBD: [5, 0, 7, 30, 31, 32, 33, 34, 35, 44]
  $702E,1 6 // nobjects
  $702F,3 { interiorobject_TUNNEL_0,                   20,  0 },
  $7032,3 { interiorobject_TUNNEL_0,                   16,  2 },
  $7035,3 { interiorobject_TUNNEL_0,                   12,  4 },
  $7038,3 { interiorobject_TUNNEL_CORNER_6,             8,  6 },
  $703B,3 { interiorobject_TUNNEL_0,                    4,  8 },
  $703E,3 { interiorobject_TUNNEL_0,                    0, 10 },

D $7041 roomdef_40
  $7041,9 TBD: [9, 0, 6, 30, 31, 32, 33, 34, 43]
  $704A,1 6 // nobjects
  $704B,3 { interiorobject_TUNNEL_7,                   20,  0 },
  $704E,3 { interiorobject_TUNNEL_0,                   16,  2 },
  $7051,3 { interiorobject_TUNNEL_0,                   12,  4 },
  $7054,3 { interiorobject_TUNNEL_0,                    8,  6 },
  $7057,3 { interiorobject_TUNNEL_0,                    4,  8 },
  $705A,3 { interiorobject_TUNNEL_0,                    0, 10 },

D $705D roomdef_44
  $705D,8 TBD: [8, 0, 5, 36, 37, 38, 39, 40]
  $7065,1 5 // nobjects
  $7066,3 { interiorobject_TUNNEL_3,                    0,  0 },
  $7069,3 { interiorobject_TUNNEL_3,                    4,  2 },
  $706C,3 { interiorobject_TUNNEL_3,                    8,  4 },
  $706F,3 { interiorobject_TUNNEL_3,                   12,  6 },
  $7072,3 { interiorobject_TUNNEL_12,                  16,  8 },

D $7075 roomdef_50_blocked_tunnel
  $7075,13 TBD: [5, 1, 52, 58, 32, 54, 6, 30, 31, 32, 33, 34, 43]
  $7082,1 6 // nobjects
  $7083,3 { interiorobject_TUNNEL_7,                   20,  0 },
  $7086,3 { interiorobject_TUNNEL_0,                   16,  2 },
  $7089,3 { interiorobject_TUNNEL_0,                   12,  4 },
  $708C,3 { interiorobject_COLLAPSED_TUNNEL,            8,  6 }, // collapsed_tunnel_obj
  $708F,3 { interiorobject_TUNNEL_0,                    4,  8 },
  $7092,3 { interiorobject_TUNNEL_0,                    0, 10 },

; ------------------------------------------------------------------------------

; Interior object definitions.
;
b $7095 interior_object_defs
W $7095 Array of pointer to interior object definitions, 54 entries long (== number of interior rooms).
D $7095 #CALL:decode_all_objects($7095, 54)
;
B $7101 Interior object tile refs 0
B $711B Interior object tile refs 1
B $7121 Interior object tile refs 3
B $713B Interior object tile refs 4
B $7155 Interior object tile refs 5
B $715A Interior object tile refs 6
B $7174 Interior object tile refs 7
B $718E Interior object tile refs 12
B $71A6 Interior object tile refs 13
B $71AB Interior object tile refs 14
B $71C4 Interior object tile refs 17
B $71DE Interior object tile refs 18
B $71F8 Interior object tile refs 19
B $7200 Interior object tile refs 20
B $721A Interior object tile refs 2
B $728E Interior object tile refs 8
B $72AE Interior object tile refs 9
B $72C1 Interior object tile refs 10
B $72CC Interior object tile refs 11
B $72D1 Interior object tile refs 15
B $72EB Interior object tile refs 16
B $7305 Interior object tile refs 22
B $730F Interior object tile refs 23
B $7325 Interior object tile refs 24
B $7333 Interior object tile refs 25
B $733C Interior object tile refs 26
B $7342 Interior object tile refs 28
B $734B Interior object tile refs 30
B $7359 Interior object tile refs 31
B $735C Interior object tile refs 32
B $736A Interior object tile refs 33
B $736F Interior object tile refs 34
B $7374 Interior object tile refs 35
B $7385 Interior object tile refs 36
B $7393 Interior object tile refs 37
B $73A5 Interior object tile refs 38
B $73BF Interior object tile refs 39
B $73D9 Interior object tile refs 41
B $7425 Interior object tile refs 42
B $742D Interior object tile refs 43
B $7452 Interior object tile refs 44
B $7482 Interior object tile refs 45
B $7493 Interior object tile refs 46
B $74F5 Interior object tile refs 47
B $7570 Interior object tile refs 48
B $7576 Interior object tile refs 49
B $757E Interior object tile refs 50
B $7588 Interior object tile refs 51
B $75A2 Interior object tile refs 52
B $75AA Interior object tile refs 53
B $75B0 Interior object tile refs 27

; ------------------------------------------------------------------------------

; Characters.
;
b $7612 character_structs
D $7612 Array, 26 long, of 7-byte structures.
D $7612 struct { byte item; byte room; byte y, x; byte unk1; byte unk2; byte unk3; } // likely same struct type/layout as item_structs
D $7612 0:
D $7619 1:
D $7620 2:
D $7627 3:
D $762E 4:
D $7635 5:
D $763C 6:
D $7643 7: prisoner who sleeps at bed position A
D $764A 8: prisoner who sleeps at bed position B
D $7651 9: prisoner who sleeps at bed position C
D $7658 10: prisoner who sleeps at bed position D
D $765F 11: prisoner who sleeps at bed position E
D $7666 12: prisoner who sleeps at bed position F (<- perhaps_reset_map_and_characters)
D $766D 13:
D $7674 14:
D $767B 15:
D $7682 16:
D $7689 17:
D $7690 18: prisoner who sits at bench position D
D $7697 19: prisoner who sits at bench position E
D $769E 20: prisoner who sits at bench position F (<- wake_up)
D $76A5 21: prisoner who sits at bench position A
D $76AC 22: prisoner who sits at bench position B
D $76B3 23: prisoner who sits at bench position C
D $76BA 24:
D $76C1 25:
  $7612,7 { character_0,           room_11_papers,    46, 46, 0x18, 0x03, 0x00 },
  $7619,7 { character_1,           room_0_outdoors,  102, 68, 0x03, 0x01, 0x00 },
  $7620,7 { character_2,           room_0_outdoors,   68,104, 0x03, 0x01, 0x02 },
  $7627,7 { character_3,           room_16_corridor,  46, 46, 0x18, 0x03, 0x13 },
  $762E,7 { character_4,           room_0_outdoors,   61,103, 0x03, 0x02, 0x04 },
  $7635,7 { character_5,           room_0_outdoors,  106, 56, 0x0D, 0x00, 0x00 },
  $763C,7 { character_6,           room_0_outdoors,   72, 94, 0x0D, 0x00, 0x00 },
  $7643,7 { character_7_prisoner,  room_0_outdoors,   72, 70, 0x0D, 0x00, 0x00 },
  $764A,7 { character_8_prisoner,  room_0_outdoors,   80, 46, 0x0D, 0x00, 0x00 },
  $7651,7 { character_9_prisoner,  room_0_outdoors,  108, 71, 0x15, 0x04, 0x00 },
  $7658,7 { character_10_prisoner, room_0_outdoors,   92, 52, 0x03, 0xFF, 0x38 },
  $765F,7 { character_11_prisoner, room_0_outdoors,  109, 69, 0x03, 0x00, 0x00 },
  $7666,7 { character_12_prisoner, room_3_hut2right,  40, 60, 0x18, 0x00, 0x08 },
  $766D,7 { character_13,          room_2_hut2left,   36, 48, 0x18, 0x00, 0x08 },
  $7674,7 { character_14,          room_5_hut3right,  40, 60, 0x18, 0x00, 0x10 },
  $767B,7 { character_15,          room_5_hut3right,  36, 34, 0x18, 0x00, 0x10 },
  $7682,7 { character_16,          room_0_outdoors,   68, 84, 0x01, 0xFF, 0x00 },
  $7689,7 { character_17,          room_0_outdoors,   68,104, 0x01, 0xFF, 0x00 },
  $7690,7 { character_18_prisoner, room_0_outdoors,  102, 68, 0x01, 0xFF, 0x18 },
  $7697,7 { character_19_prisoner, room_0_outdoors,   88, 68, 0x01, 0xFF, 0x18 },
  $769E,7 { character_20_prisoner, room_NONE,         52, 60, 0x18, 0x00, 0x08 },
  $76A5,7 { character_21_prisoner, room_NONE,         52, 44, 0x18, 0x00, 0x08 },
  $76AC,7 { character_22_prisoner, room_NONE,         52, 28, 0x18, 0x00, 0x08 },
  $76B3,7 { character_23_prisoner, room_NONE,         52, 60, 0x18, 0x00, 0x10 },
  $76BA,7 { character_24,          room_NONE,         52, 44, 0x18, 0x00, 0x10 },
  $76C1,7 { character_25,          room_NONE,         52, 28, 0x18, 0x00, 0x10 },

; ------------------------------------------------------------------------------

b $76C8 item_structs
D $76C8 16 long array of 7-byte structures. These are 'characters' but seem to be the game items.
D $76C8 struct { byte item; byte room; byte y, x; byte unk1; byte unk2; byte unk3; }
  $76C8 { item_WIRESNIPS,        room_NONE,        64,32, 0x02, 0x78, 0xF4 }, // <- item_to_itemstruct, find_nearby_item
  $76CF { item_SHOVEL,           room_9_crate,     62,48, 0x00, 0x7C, 0xF2 },
  $76D6 { item_LOCKPICK,         room_10_lockpick, 73,36, 0x10, 0x77, 0xF0 },
  $76DD { item_PAPERS,           room_11_papers,   42,58, 0x04, 0x84, 0xF3 },
  $76E4 { item_TORCH,            room_14_torch,    34,24, 0x02, 0x7A, 0xF6 },
  $76EB { item_BRIBE,            room_NONE,        36,44, 0x04, 0x7E, 0xF4 }, // <- use_bribe
  $76F2 { item_UNIFORM,          room_15_uniform,  44,65, 0x10, 0x87, 0xF1 },
  $76F9 { item_FOOD,             room_19_food,     64,48, 0x10, 0x7E, 0xF0 }, // <- action_poison, called_from_main_loop
  $7700 { item_POISON,           room_1_hut1right, 66,52, 0x04, 0x7C, 0xF1 },
  $7707 { item_RED_KEY,          room_22_redkey,   60,42, 0x00, 0x7B, 0xF2 },
  $770E { item_YELLOW_KEY,       room_11_papers,   28,34, 0x00, 0x81, 0xF8 },
  $7715 { item_GREEN_KEY,        room_0_outdoors,  74,72, 0x00, 0x7A, 0x6E },
  $771C { item_RED_CROSS_PARCEL, room_NONE,        28,50, 0x0C, 0x85, 0xF6 }, // <- event_new_red_cross_parcel, new_red_cross_parcel
  $7723 { item_RADIO,            room_18_radio,    36,58, 0x08, 0x85, 0xF4 },
  $772A { item_PURSE,            room_NONE,        36,44, 0x04, 0x7E, 0xF4 },
  $7731 { item_COMPASS,          room_NONE,        52,28, 0x04, 0x7E, 0xF4 },

; ------------------------------------------------------------------------------

; More object tile refs.
;
b $7738 more_object_tile_refs
W $7738 46 long array of pointers to object tile refs.
  $7794,1 could be a terminating $FF
  $7795 Object tile refs
  $7799 Object tile refs
  $77A0 Object tile refs
  $77CD Object tile refs
  $77D0 Object tile refs
  $77D4 Object tile refs
  $77D8 Object tile refs
  $77DA Object tile refs
  $77DC Object tile refs
  $77DE Object tile refs
  $77E1 Object tile refs
  $77E7 Object tile refs
  $77EC Object tile refs
  $77F1 Object tile refs
  $77F3 Object tile refs
  $77F5 Object tile refs
  $77F7 Object tile refs
  $77F9 Object tile refs
  $77FB Object tile refs
  $77FD Object tile refs
  $77FF Object tile refs
  $7801 Object tile refs
  $7803 Object tile refs
  $7805 Object tile refs
  $7807 Object tile refs
  $7809 Object tile refs
  $780B Object tile refs
  $780D Object tile refs
  $780F Object tile refs
  $7815 Object tile refs
  $781A Object tile refs
  $781F Object tile refs
  $7825 Object tile refs
  $782B Object tile refs
  $7831 Object tile refs
  $7833 Object tile refs
  $7835 Object tile refs
  $7838 Object tile refs

; ------------------------------------------------------------------------------

w $783A word_783A
D $783A,156,2 78 two-byte words
  $783A 0x6844
  $783C 0x5444
  $783E 0x4644
  $7840 0x6640
  $7842 0x4040
  $7844 0x4444
  $7846 0x4040
  $7848 0x4044
  $784A 0x7068
  $784C 0x7060
  $784E 0x666A
  $7850 0x685D
  $7852 0x657C
  $7854 0x707C
  $7856 0x6874
  $7858 0x6470
  $785A 0x6078
  $785C 0x5880
  $785E 0x6070
  $7860 0x5474
  $7862 0x647C
  $7864 0x707C
  $7866 0x6874
  $7868 0x6470
  $786A 0x4466
  $786C 0x4066
  $786E 0x4060
  $7870 0x445C
  $7872 0x4456
  $7874 0x4054
  $7876 0x444A
  $7878 0x404A
  $787A 0x4466
  $787C 0x4444
  $787E 0x6844
  $7880 0x456B
  $7882 0x2D6B
  $7884 0x2D4D
  $7886 0x3D4D
  $7888 0x3D3D
  $788A 0x673D
  $788C 0x4C74
  $788E 0x2A2C
  $7890 0x486A
  $7892 0x486E
  $7894 0x6851
  $7896 0x3C34
  $7898 0x2C34
  $789A 0x1C34
  $789C 0x6B77
  $789E 0x6E7A
  $78A0 0x1C34
  $78A2 0x3C28
  $78A4 0x2224
  $78A6 0x4C50
  $78A8 0x4C59
  $78AA 0x3C59
  $78AC 0x3D64
  $78AE 0x365C
  $78B0 0x3254
  $78B2 0x3066
  $78B4 0x3860
  $78B6 0x3B4F
  $78B8 0x2F67
  $78BA 0x3634
  $78BC 0x2E34
  $78BE 0x2434
  $78C0 0x3E34
  $78C2 0x3820
  $78C4 0x1834
  $78C6 0x2E2A
  $78C8 0x2222
  $78CA 0x6E78
  $78CC 0x6E76
  $78CE 0x6E74
  $78D0 0x6D79
  $78D2 0x6D77
  $78D4 0x6D75

; ------------------------------------------------------------------------------

b $78D6 door_positions
D $78D6,496,4 124 four-byte structs (<- sub 69DC)
D $78D6 #define BYTE0(room,other) ((room << 2) | other)
; room could be a target or a destination. unsure presently.
; suspect 4th byte could be a scaled height (would it be four times larger for internal coords?)
; suspect bit 1 controls whether to jump to door listed in front, or behind (see $C742)
  $78D6 { BYTE0(room_0_outdoors,           1), 0xB2, 0x8A,  6 },
  $78DA { BYTE0(room_0_outdoors,           3), 0xB2, 0x8E,  6 },
  $78DE { BYTE0(room_0_outdoors,           1), 0xB2, 0x7A,  6 },
  $78E2 { BYTE0(room_0_outdoors,           3), 0xB2, 0x7E,  6 },
  $78E6 { BYTE0(room_34,                   0), 0x8A, 0xB3,  6 },
  $78EA { BYTE0(room_0_outdoors,           2), 0x10, 0x34, 12 },
  $78EE { BYTE0(room_48,                   0), 0xCC, 0x79,  6 },
  $78F2 { BYTE0(room_0_outdoors,           2), 0x10, 0x34, 12 },
  $78F6 { BYTE0(room_28_hut1left,          1), 0xD9, 0xA3,  6 },
  $78FA { BYTE0(room_0_outdoors,           3), 0x2A, 0x1C, 24 },
  $78FE { BYTE0(room_1_hut1right,          0), 0xD4, 0xBD,  6 },
  $7902 { BYTE0(room_0_outdoors,           2), 0x1E, 0x2E, 24 },
  $7906 { BYTE0(room_2_hut2left,           1), 0xC1, 0xA3,  6 }, // if i set the room number to $80 here i can't use the (left) door to exit, entering the door from the otherside puts me in a tunnel (i think)
  $790A { BYTE0(room_0_outdoors,           3), 0x2A, 0x1C, 24 },
  $790E { BYTE0(room_3_hut2right,          0), 0xBC, 0xBD,  6 },
  $7912 { BYTE0(room_0_outdoors,           2), 0x20, 0x2E, 24 },
  $7916 { BYTE0(room_4_hut3left,           1), 0xA9, 0xA3,  6 },
  $791A { BYTE0(room_0_outdoors,           3), 0x2A, 0x1C, 24 },
  $791E { BYTE0(room_5_hut3right,          0), 0xA4, 0xBD,  6 },
  $7922 { BYTE0(room_0_outdoors,           2), 0x20, 0x2E, 24 },
  $7926 { BYTE0(room_21_corridor,          0), 0xFC, 0xCA,  6 },
  $792A { BYTE0(room_0_outdoors,           2), 0x1C, 0x24, 24 },
  $792E { BYTE0(room_20_redcross,          0), 0xFC, 0xDA,  6 },
  $7932 { BYTE0(room_0_outdoors,           2), 0x1A, 0x22, 24 },
  $7936 { BYTE0(room_15_uniform,           1), 0xF7, 0xE3,  6 },
  $793A { BYTE0(room_0_outdoors,           3), 0x26, 0x19, 24 },
  $793E { BYTE0(room_13_corridor,          1), 0xDF, 0xE3,  6 },
  $7942 { BYTE0(room_0_outdoors,           3), 0x2A, 0x1C, 24 },
  $7946 { BYTE0(room_8_corridor,           1), 0x97, 0xD3,  6 },
  $794A { BYTE0(room_0_outdoors,           3), 0x2A, 0x15, 24 },
  $794E { BYTE0(room_6,                    1), 0x00, 0x00,  0 }, // intriguing
  $7952 { BYTE0(room_0_outdoors,           3), 0x22, 0x22, 24 },
  $7956 { BYTE0(room_1_hut1right,          1), 0x2C, 0x34, 24 },
  $795A { BYTE0(room_28_hut1left,          3), 0x26, 0x1A, 24 },
  $795E { BYTE0(room_3_hut2right,          1), 0x24, 0x36, 24 },
  $7962 { BYTE0(room_2_hut2left,           3), 0x26, 0x1A, 24 },
  $7966 { BYTE0(room_5_hut3right,          1), 0x24, 0x36, 24 },
  $796A { BYTE0(room_4_hut3left,           3), 0x26, 0x1A, 24 },
  $796E { BYTE0(room_23_breakfast,         1), 0x28, 0x42, 24 },
  $7972 { BYTE0(room_25_breakfast,         3), 0x26, 0x18, 24 },
  $7976 { BYTE0(room_23_breakfast,         0), 0x3E, 0x24, 24 },
  $797A { BYTE0(room_21_corridor,          2), 0x20, 0x2E, 24 },
  $797E { BYTE0(room_19_food,              1), 0x22, 0x42, 24 },
  $7982 { BYTE0(room_23_breakfast,         3), 0x22, 0x1C, 24 },
  $7986 { BYTE0(room_18_radio,             1), 0x24, 0x36, 24 },
  $798A { BYTE0(room_19_food,              3), 0x38, 0x22, 24 },
  $798E { BYTE0(room_21_corridor,          1), 0x2C, 0x36, 24 },
  $7992 { BYTE0(room_22_redkey,            3), 0x22, 0x1C, 24 },
  $7996 { BYTE0(room_22_redkey,            1), 0x2C, 0x36, 24 },
  $799A { BYTE0(room_24_solitary,          3), 0x2A, 0x26, 24 },
  $799E { BYTE0(room_12_corridor,          1), 0x42, 0x3A, 24 },
  $79A2 { BYTE0(room_18_radio,             3), 0x22, 0x1C, 24 },
  $79A6 { BYTE0(room_17_corridor,          0), 0x3C, 0x24, 24 },
  $79AA { BYTE0(room_7_corridor,           2), 0x1C, 0x22, 24 },
  $79AE { BYTE0(room_15_uniform,           0), 0x40, 0x28, 24 },
  $79B2 { BYTE0(room_14_torch,             2), 0x1E, 0x28, 24 },
  $79B6 { BYTE0(room_16_corridor,          1), 0x22, 0x42, 24 },
  $79BA { BYTE0(room_14_torch,             3), 0x22, 0x1C, 24 },
  $79BE { BYTE0(room_16_corridor,          0), 0x3E, 0x2E, 24 },
  $79C2 { BYTE0(room_13_corridor,          2), 0x1A, 0x22, 24 },
  $79C6 { BYTE0(room_0_outdoors,           0), 0x44, 0x30, 24 },
  $79CA { BYTE0(room_0_outdoors,           2), 0x20, 0x30, 24 },
  $79CE { BYTE0(room_13_corridor,          0), 0x4A, 0x28, 24 },
  $79D2 { BYTE0(room_11_papers,            2), 0x1A, 0x22, 24 },
  $79D6 { BYTE0(room_7_corridor,           0), 0x40, 0x24, 24 },
  $79DA { BYTE0(room_16_corridor,          2), 0x1A, 0x22, 24 },
  $79DE { BYTE0(room_10_lockpick,          0), 0x36, 0x35, 24 },
  $79E2 { BYTE0(room_8_corridor,           2), 0x17, 0x26, 24 },
  $79E6 { BYTE0(room_9_crate,              0), 0x36, 0x1C, 24 },
  $79EA { BYTE0(room_8_corridor,           2), 0x1A, 0x22, 24 },
  $79EE { BYTE0(room_12_corridor,          0), 0x3E, 0x24, 24 },
  $79F2 { BYTE0(room_17_corridor,          2), 0x1A, 0x22, 24 },
  $79F6 { BYTE0(room_29_secondtunnelstart, 1), 0x36, 0x36, 24 },
  $79FA { BYTE0(room_9_crate,              3), 0x38, 0x0A, 12 },
  $79FE { BYTE0(room_52,                   1), 0x38, 0x62, 12 },
  $7A02 { BYTE0(room_30,                   3), 0x38, 0x0A, 12 },
  $7A06 { BYTE0(room_30,                   0), 0x64, 0x34, 12 },
  $7A0A { BYTE0(room_31,                   2), 0x38, 0x26, 12 },
  $7A0E { BYTE0(room_30,                   1), 0x38, 0x62, 12 },
  $7A12 { BYTE0(room_36,                   3), 0x38, 0x0A, 12 },
  $7A16 { BYTE0(room_31,                   0), 0x64, 0x34, 12 },
  $7A1A { BYTE0(room_32,                   2), 0x0A, 0x34, 12 },
  $7A1E { BYTE0(room_32,                   1), 0x38, 0x62, 12 },
  $7A22 { BYTE0(room_33,                   3), 0x20, 0x34, 12 },
  $7A26 { BYTE0(room_33,                   1), 0x40, 0x34, 12 },
  $7A2A { BYTE0(room_35,                   3), 0x38, 0x0A, 12 },
  $7A2E { BYTE0(room_35,                   0), 0x64, 0x34, 12 },
  $7A32 { BYTE0(room_34,                   2), 0x0A, 0x34, 12 },
  $7A36 { BYTE0(room_36,                   0), 0x64, 0x34, 12 },
  $7A3A { BYTE0(room_35,                   2), 0x38, 0x1C, 12 },
  $7A3E { BYTE0(room_37,                   0), 0x3E, 0x22, 24 }, // tunnel entrance
  $7A42 { BYTE0(room_2_hut2left,           2), 0x10, 0x34, 12 },
  $7A46 { BYTE0(room_38,                   0), 0x64, 0x34, 12 },
  $7A4A { BYTE0(room_37,                   2), 0x10, 0x34, 12 },
  $7A4E { BYTE0(room_39,                   1), 0x40, 0x34, 12 },
  $7A52 { BYTE0(room_38,                   3), 0x20, 0x34, 12 },
  $7A56 { BYTE0(room_40,                   0), 0x64, 0x34, 12 },
  $7A5A { BYTE0(room_38,                   2), 0x38, 0x54, 12 },
  $7A5E { BYTE0(room_40,                   1), 0x38, 0x62, 12 },
  $7A62 { BYTE0(room_41,                   3), 0x38, 0x0A, 12 },
  $7A66 { BYTE0(room_41,                   0), 0x64, 0x34, 12 },
  $7A6A { BYTE0(room_42,                   2), 0x38, 0x26, 12 },
  $7A6E { BYTE0(room_41,                   1), 0x38, 0x62, 12 },
  $7A72 { BYTE0(room_45,                   3), 0x38, 0x0A, 12 },
  $7A76 { BYTE0(room_45,                   0), 0x64, 0x34, 12 },
  $7A7A { BYTE0(room_44,                   2), 0x38, 0x1C, 12 },
  $7A7E { BYTE0(room_43,                   1), 0x20, 0x34, 12 },
  $7A82 { BYTE0(room_44,                   3), 0x38, 0x0A, 12 },
  $7A86 { BYTE0(room_42,                   1), 0x38, 0x62, 12 },
  $7A8A { BYTE0(room_43,                   3), 0x20, 0x34, 12 },
  $7A8E { BYTE0(room_46,                   0), 0x64, 0x34, 12 },
  $7A92 { BYTE0(room_39,                   2), 0x38, 0x1C, 12 },
  $7A96 { BYTE0(room_47,                   1), 0x38, 0x62, 12 },
  $7A9A { BYTE0(room_46,                   3), 0x20, 0x34, 12 },
  $7A9E { BYTE0(room_50_blocked_tunnel,    0), 0x64, 0x34, 12 },
  $7AA2 { BYTE0(room_47,                   2), 0x38, 0x56, 12 },
  $7AA6 { BYTE0(room_50_blocked_tunnel,    1), 0x38, 0x62, 12 },
  $7AAA { BYTE0(room_49,                   3), 0x38, 0x0A, 12 },
  $7AAE { BYTE0(room_49,                   0), 0x64, 0x34, 12 },
  $7AB2 { BYTE0(room_48,                   2), 0x38, 0x1C, 12 },
  $7AB6 { BYTE0(room_51,                   1), 0x38, 0x62, 12 },
  $7ABA { BYTE0(room_29_secondtunnelstart, 3), 0x20, 0x34, 12 },
  $7ABE { BYTE0(room_52,                   0), 0x64, 0x34, 12 },
  $7AC2 { BYTE0(room_51,                   2), 0x38, 0x54, 12 },

; ------------------------------------------------------------------------------

b $7AC6 solitary_transition_thing
D $7AC6 3 bytes long (<- solitary)

; ------------------------------------------------------------------------------

c $7AC9 check_for_pick_up_keypress
D $7AC9 check for 'pick up', 'drop' and both 'use item' keypresses
R $7AC9 I:A Input event.
  $7AC9 if (A == input_UP_FIRE) pick_up_item();
  $7AD3 else if (A == input_DOWN_FIRE) drop_item();
  $7ADD else if (A == input_LEFT_FIRE) use_item_A();
  $7AE7 else if (A == input_RIGHT_FIRE) use_item_B();
  $7AEF return;

c $7AF0 use_item_B
  $7AF0 A = items_held[1]; // $8216
  $7AF3 goto use_item_common;

c $7AF5 use_item_A
  $7AF5 A = items_held[0]; // $8215 // FALLTHROUGH

c $7AFB use_item_common
  $7AF8 if (A == item_NONE) return;
  $7AFB (pointless_jump)
  $7AFD HL = &item_actions_jump_table[A];
  $7B05 L = *HL++;
  $7B07 H = *HL;
  $7B09 PUSH HL // exit via jump table entry
  $7B0A memcpy(&saved_Y, $800F, 6); // copy Y,X and vertical offset
  $7B15 return;

; ------------------------------------------------------------------------------

w $7B16 item_actions_jump_table
  $7B16 action_wiresnips
  $7B18 action_shovel
  $7B1A action_lockpick
  $7B1C action_papers
  $7B1E -
  $7B20 action_bribe
  $7B22 action_uniform
  $7B24 -
  $7B26 action_poison
  $7B28 action_red_key
  $7B2A action_yellow_key
  $7B2C action_green_key
  $7B2E action_red_cross_parcel
  $7B30 -
  $7B32 -
  $7B34 -

; ------------------------------------------------------------------------------

c $7B36 pick_up_item
  $7B36 HL = items_held;
  $7B39 A = item_NONE;
  $7B3B if (L != A && H != A) return; // no spare slots
  $7B40 find_nearby_item();
  $7B43 if (!Z) return; // not found
D $7B44 Locate the empty item slot.
  $7B44 DE = &items_held[0];
  $7B47 A = *DE;
  $7B48 if (A != item_NONE) DE++;
  $7B4D *DE = *HL & 0x1F;
  $7B51 PUSH HL
  $7B52 A = room_index;
  $7B55 if (A == 0) { // outdoors
  $7B5A   sub_A8A2();
  $7B5D }
  $7B5F else { setup_room();
  $7B62   plot_indoor_tiles();
  $7B65   choose_game_screen_attributes();
  $7B68   set_game_screen_attributes(); }
  $7B6B POP HL
  $7B6C if ((*HL & itemstruct_ITEM_FLAG_HELD) == 0) {
  $7B70   *HL |= itemstruct_ITEM_FLAG_HELD;
  $7B72   PUSH HL
  $7B73   increase_morale_by_5_score_by_5();
  $7B76   POP HL }
  $7B77 A = 0;
  $7B78 HL++;
  $7B79 *HL = A;
  $7B7A HL += 4;
  $7B7E *HL++ = A;
  $7B80 *HL = A;
  $7B81 draw_all_items();
  $7B84 play_speaker(sound_PICK_UP_ITEM);
  $7B8A return;

; ------------------------------------------------------------------------------

c $7B8B drop_item
D $7B8B Drop the first item.
  $7B8B A = items_held[0];
  $7B8E if (A == item_NONE) return;
  $7B91 if (A == item_UNIFORM) $8015 = sprite_prisoner_tl_4;
  $7B9C PUSH AF
D $7B9D Shuffle items down.
  $7B9D HL = &items_held[1];  // item slot B
  $7BA0 A = *HL;
  $7BA1 *HL-- = item_NONE;
  $7BA4 *HL = A;
  $7BA5 draw_all_items();
  $7BA8 play_speaker(sound_DROP_ITEM);
  $7BAE choose_game_screen_attributes();
  $7BB1 set_game_screen_attributes();
  $7BB4 POP AF

; looks like it's converting character position + offset into object position + offset by dividing
c $7BB5 drop_item_A
R $7BB5 I:A Item.
  $7BB5 HL = item_to_itemstruct(A);
  $7BB8 HL++;
  $7BB9 A = room_index;
  $7BBC *HL = A; // set object's room index
  $7BBD if (A == 0) {
D $7BC0 Outdoors.
  $7BC0   HL++;    // -> .y
  $7BC1   PUSH HL
D $7BC2 HL is incremented here but then immediately overwritten by $7BC5.
  $7BC2   HL += 2; // -> .unk1
  $7BC4   POP DE
  $7BC5   HL = $800F;
  $7BC8   scale_pos(HL,DE);
  $7BCB   DE--;
  $7BCC   *DE = 0; // ->vo ?
  $7BCF   EX DE,HL
;
; This entry point is used by the routine at #R$CD31.
; sampled HL = 7719, 7720,
R $7BD0   I:HL Pointer to dropped itemstruct + 4.
  $7BD0   HL--; C = (0x40 + HL[1] - HL[0]) * 2; // itemstruct.x, itemstruct.y;
  $7BD8   B = 0 - HL[0] - HL[1] - HL[2]; HL += 3; // itemstruct.y, .x, .vo
  $7BE0   *HL++ = C;
  $7BE2   *HL = B;
  $7BE3   return; }
;
D $7BE4 Indoors.
  $7BE4 else { HL++;
  $7BE5   DE = $800F; // position on y axis
  $7BE8   *HL++ = *DE;
  $7BEB   DE += 2; // position on x axis
  $7BED   *HL++ = *DE;
  $7BF0   *HL = 5;
;
; This entry point is used by the routine at #R$CD31.
R $7BF2   I:HL Pointer to ? $77AE (odd - that's object tile refs...)
  $7BF2   HL--;
  $7BF3   DE = 0x0200 + HL[0];  // 512 / 8 = 64
  $7BF6   EX DE,HL
  $7BF7   DE--;
  $7BF8   HL = (HL - DE[0]) * 2;
  $7C00   A = divide_by_8_with_rounding(H,L);
  $7C05   -
  $7C06   HL = 0x0800 - DE[0] - DE[1] - DE[2]; DE += 2;
  $7C1A   Adash = divide_by_8_with_rounding(H,L);
  $7C1F   DE += 2;
  $7C21   *DE-- = Adash;
  $7C23   -
  $7C24   *DE = A;
  $7C25   return; }

; ------------------------------------------------------------------------------

c $7C26 item_to_itemstruct
R $7C26 I:A  Item index.
R $7C26 O:HL Pointer to item_struct.
  $7C26 return &item_structs[A]; // $76C8 + A * 7

; ------------------------------------------------------------------------------

c $7C33 draw_all_items
  $7C33 draw_item(screenaddr_item1, items_held[0]);
  $7C3C draw_item(screenaddr_item2, items_held[1]);
  $7C45 return;

; ------------------------------------------------------------------------------

c $7C46 draw_item
R $7C46 I:A  Item index.
R $7C46 I:HL Screen address of item.
;
  $7C46 PUSH HL
  $7C47 EX AF,AF'
;
D $7C48 Wipe item.
  $7C48 B = 2; // 16 wide
  $7C4A C = 16;
  $7C4C screen_wipe();
;
  $7C4F POP HL
  $7C50 EX AF,AF'
  $7C51 if (A == item_NONE) return;
;
D $7C54 Set screen attributes.
  $7C54 PUSH HL
  $7C55 HL = (HL & ~0xFF00) | 0x5A00; // point to screen attributes
  $7C57 PUSH AF
  $7C58 A = item_attributes[A];
  $7C61 *HL++ = A;
  $7C63 *HL-- = A;
  $7C65 HL |= 1<<5; // move to next attribute row
  $7C67 *HL++ = A;
  $7C69 *HL = A;
  $7C6A POP AF
;
D $7C6B Plot bitmap.
  $7C6B HL = &item_definitions[A]; // elements are six bytes wide
  $7C76 B = *HL++;
  $7C78 C = *HL++;
  $7C7A E = *HL++;
  $7C7C D = *HL;
  $7C7D POP HL
  $7C7E plot_bitmap();
;
  $7C81 return;

; ------------------------------------------------------------------------------

c $7C82 find_nearby_item
D $7C82 Returns an item within range of the player.
R $7C82 O:AF Z set if item found.
R $7C82 O:HL If found, pointer to item.
D $7C82 Select a pick up radius.
  $7C82 C = 1; // outdoors
  $7C84 if (room_index) C = 6; // indoors
  $7C8C B = item__LIMIT; // 16 iterations
  $7C8E HL = &item_structs[0].room;
  $7C91 do { if (*HL & itemstruct_ROOM_FLAG_ITEM_NEARBY) {
  $7C95     PUSH BC
  $7C96     PUSH HL
  $7C97     HL++; // itemstruct.y
  $7C98     DE = &player_map_position.y; // this is probably 'Y' in this sense, but i'd need to rename all others to comply
  $7C9B     B = 2; // 2 iterations
D $7C9D Range check.
  $7C9D     do { A = *DE++; // get player map position
  $7C9F       if (A - C >= *HL || A + C < *HL) goto popnext;
  $7CA7       HL++;
  $7CA9     } while (--B);
  $7CAB     POP HL
  $7CAC     HL--; // compensate for overshoot
  $7CAD     POP BC
  $7CAE     A = 0; // set Z (found)
D $7CAF The next instruction is written as RET Z but there's no need for it to be conditional.
  $7CAF     return;

  $7CB0     popnext: POP HL
  $7CB1     POP BC }
  $7CB2   HL += 7; // stride
  $7CB9 } while (--B);
  $7CBB A |= 1; // set NZ (not found)
  $7CBD return;

; ------------------------------------------------------------------------------

c $7CBE plot_bitmap
D $7CBE Straight bitmap plot without masking.
R $7CBE I:BC Dimensions (w x h, where w is in bytes).
R $7CBE I:DE Source address.
R $7CBE I:HL Destination address.
  $7CBE A = B;
  $7CBF (loopcounter + 1) = A;   // self modifying
  $7CC2 do { loopcounter: B = 3; // modified
  $7CC4   dst = HL;
  $7CC5   do { *dst++ = *DE++; } while (--B);
  $7CCC   get_next_scanline();
  $7CCF } while (--C);
  $7CD3 return;

; ------------------------------------------------------------------------------

c $7CD4 screen_wipe
D $7CD4 Wipe the screen.
R $7CD4 I:B  Number of bytes to set.
R $7CD4 I:C  Number of scanlines.
R $7CD4 I:HL Destination address.
  $7CD4 A = B;
  $7CD5 (loopcounter + 1) = A;   // self modifying
  $7CD8 do { loopcounter: B = 2; // modified
  $7CDA   dst = HL;
  $7CDB   do { *dst++ = 0; } while (--B);
  $7CE1   get_next_scanline();
  $7CE4 } while (--C);
  $7CE8 return;

; ------------------------------------------------------------------------------

c $7CE9 get_next_scanline
D $7CE9 Given a screen address, returns the same position on the next scanline.
R $7CE9 I:HL Original screen address.
R $7CE9 O:HL Updated screen address.
  $7CE9 HL += 256;
  $7CEA if ((H & 7) != 0) return;
;
  $7CEE PUSH DE
  $7CEF DE = 0xF820;
  $7CF2 if (L >= 0xE0) D = 0xFF;
  $7CF9 HL += DE;
  $7CFA POP DE
  $7CFB return;

; ------------------------------------------------------------------------------

b $7CFC message_queue_stuff

  $7CFC message_queue
D $7CFC Queue of message indexes. (Pairs of bytes + terminator).

  $7D0F message_display_counter
D $7D0F Decrementing counter. Shows next message when it hits zero.

  $7D10 message_display_index
D $7D10 Index into the message we're displaying or wiping.
D $7D10 If 128 then next_message. If > 128 then wipe message. Else display.

W $7D11 message_queue_pointer
D $7D11 Pointer to the head of the message queue.

W $7D13 current_message_character
D $7D13 Pointer to the next message character to be displayed.

; ------------------------------------------------------------------------------

c $7D15 queue_message_for_display
D $7D15 Add the specified message to the queue of pending messages.
D $7D15 The use of C here is puzzling. One routine (check_morale) explicitly sets it to zero before calling, but others do not and we receive whatever was in C previously.
R $7D15 I:B message_* index.
R $7D15 I:C Possibly a second message index.
  $7D15 if (*(HL = message_queue_pointer) == message_NONE) return;
D $7D1C Are we already about to show this message?
  $7D1C HL -= 2;
  $7D1E if (*HL++ == B && *HL++ == C) return;
D $7D26 Add it to the queue.
  $7D26 *HL++ = B; *HL++ = C;
  $7D2B message_queue_pointer = HL;
  $7D2E return;

; ------------------------------------------------------------------------------

c $7D2F plot_glyph
R $7D2F I:HL Pointer to glyph.
R $7D2F I:DE Pointer to destination.
R $7D2F O:HL Preserved.
R $7D2F O:DE Points to next character.
  $7D2F A = *HL;
  $7D30 plot_single_glyph: ...
  $7D31 HL = A * 8;
  $7D37 BC = bitmap_font;
  $7D3A HL += BC;
  $7D3C B = 8; // 8 iterations
  $7D3E do { *DE = *HL;
  $7D40 D++; // i.e. DE += 256;
  $7D41 HL++;
  $7D42 } while (--B);
  $7D44 DE++;
  $7D47 return;

; ------------------------------------------------------------------------------

c $7D48 message_display
  $7D48 if (message_display_counter > 0) {
  $7D50   message_display_counter--;
  $7D53   return; }
;
  $7D54 A = message_display_index;
  $7D57 if (A == 128) goto next_message; // exit via
  $7D5B else if (A > 128) goto wipe_message; // exit via
  $7D5D else { HL = current_message_character;
  $7D60   DE = screen_text_start_address + A;
  $7D65   plot_glyph();
  $7D68   message_display_index = E & 31;
  $7D6E   A = *++HL;
  $7D70   if (A != 255) goto not_eol;
  $7D75   message_display_counter = 31; // leave the message for 31 turns
  $7D7A   message_display_index |= 128; // then wipe it
  $7D82   return;
;
  $7D83   not_eol: current_message_character = HL;
  $7D86   return; }

c $7D87 wipe_message
  $7D87 A = message_display_index;
  $7D8A message_display_index = --A;
  $7D8E DE = screen_text_start_address + A;
  $7D93 plot_single_glyph(35); // plot a SPACE character
  $7D98 return;

c $7D99 next_message
D $7D99 Looks like message_queue is poked with the index of the message to display...
  $7D99 HL = message_queue_pointer;
  $7D9C DE = &message_queue[0];
  $7D9F if (L == E) return; // cheap test -- no more messages?
;
  $7DA3 A = *DE++;
  $7DA5 C = *DE; // C is loaded here but not used. This could be a hangover from 16-bit message IDs.
  $7DA6 HL = messages_table[A];
  $7DB2 current_message_character = HL;
  $7DB5 memmove(message_queue, message_queue + 2, 16); // drop first element
  $7DC0 message_queue_pointer -= 2;
  $7DC8 message_display_index = 0;
  $7DCC return;

; ------------------------------------------------------------------------------

; Messages - messages printed at the bottom of the screen when things happen.
;
b $7DCD messages_table
D $7DCD Non-ASCII: encoded to match the font; FF terminated.
W $7DCD Array of pointers to messages.
D $7DF5 "MISSED ROLL CALL"
  $7DF5 #CALL:decode_stringFF($7DF5)
D $7E06 "TIME TO WAKE UP"
  $7E06 #CALL:decode_stringFF($7E06)
D $7E16 "BREAKFAST TIME"
  $7E16 #CALL:decode_stringFF($7E16)
D $7E25 "EXERCISE TIME"
  $7E25 #CALL:decode_stringFF($7E25)
D $7E33 "TIME FOR BED"
  $7E33 #CALL:decode_stringFF($7E33)
D $7E40 "THE DOOR IS LOCKED"
  $7E40 #CALL:decode_stringFF($7E40)
D $7E53 "IT IS OPEN"
  $7E53 #CALL:decode_stringFF($7E53)
D $7E5E "INCORRECT KEY"
  $7E5E #CALL:decode_stringFF($7E5E)
D $7E6C "ROLL CALL"
  $7E6C #CALL:decode_stringFF($7E6C)
D $7E76 "RED CROSS PARCEL"
  $7E76 #CALL:decode_stringFF($7E76)
D $7E87 "PICKING THE LOCK"
  $7E87 #CALL:decode_stringFF($7E87)
D $7E98 "CUTTING THE WIRE"
  $7E98 #CALL:decode_stringFF($7E98)
D $7EA9 "YOU OPEN THE BOX"
  $7EA9 #CALL:decode_stringFF($7EA9)
D $7EBA "YOU ARE IN SOLITARY"
  $7EBA #CALL:decode_stringFF($7EBA)
D $7ECE "WAIT FOR RELEASE"
  $7ECE #CALL:decode_stringFF($7ECE)
D $7EDF "MORALE IS ZERO"
  $7EDF #CALL:decode_stringFF($7EDF)
D $7EEE "ITEM DISCOVERED"
  $7EEE #CALL:decode_stringFF($7EEE)

; ------------------------------------------------------------------------------

; Static tiles.
;
b $7F00 static_tiles
D $7F00 Tiles used on-screen for medals, etc. 9 bytes each: 8x8 bitmap + 1 byte attribute. 75 tiles.
D $7F00 #UDGARRAY75,6,1;$7F00,7;$7F09;$7F12;$7F1B;$7F24;$7F2D;$7F36;$7F3F;$7F48;$7F51;$7F5A;$7F63;$7F6C;$7F75;$7F7E;$7F87;$7F90;$7F99;$7FA2;$7FAB;$7FB4;$7FBD;$7FC6;$7FCF;$7FD8,7;$7FE1,7;$7FEA,7;$7FF3,7;$7FFC,4;$8005,4;$800E,4;$8017,4;$8020,3;$8029,7;$8032,3;$803B,3;$8044,3;$804D,3;$8056,3;$805F,3;$8068,3;$8071,3;$807A,3;$8083,3;$808C,7;$8095,3;$809E,3;$80A7,3;$80B0,3;$80B9,7;$80C2,7;$80CB;$80D4;$80DD;$80E6;$80EF,5;$80F8,5;$8101,4;$810A,4;$8113,4;$811C,7;$8125,7;$812E;$8137;$8140;$8149;$8152,5;$815B,5;$8164,5;$816D,4;$8176;$817F;$8188;$8191;$819A(static-tiles)
B $7F00,9 blank
;
B $7F09,9 speaker_tl_tl
B $7F12,9 speaker_tl_tr
B $7F1B,9 speaker_tl_bl
B $7F24,9 speaker_tl_br
B $7F2D,9 speaker_tr_tl
B $7F36,9 speaker_tr_tr
B $7F3F,9 speaker_tr_bl
B $7F48,9 speaker_tr_br
B $7F51,9 speaker_br_tl
B $7F5A,9 speaker_br_tr
B $7F63,9 speaker_br_bl
B $7F6C,9 speaker_br_br
B $7F75,9 speaker_bl_tl
B $7F7E,9 speaker_bl_tr
B $7F87,9 speaker_bl_bl
B $7F90,9 speaker_bl_br
;
B $7F99,9 barbwire_v_top
B $7FA2,9 barbwire_v_bottom
B $7FAB,9 barbwire_h_left
B $7FB4,9 barbwire_h_right
B $7FBD,9 barbwire_h_wide_left
B $7FC6,9 barbwire_h_wide_middle
B $7FCF,9 barbwire_h_wide_right
;
B $7FD8,9 flagpole_top
B $7FE1,9 flagpole_middle
B $7FEA,9 flagpole_bottom
B $7FF3,9 flagpole_ground1
B $7FFC,9 flagpole_ground2
B $8005,9 flagpole_ground3
B $800E,9 flagpole_ground4
B $8017,9 flagpole_ground0
;
B $8020,9 medal_0_0
B $8029,9 medal_0_1/3/5/7/9
B $8032,9 medal_0_2
B $803B,9 medal_0_4
B $8044,9 medal_0_6
B $804D,9 medal_0_8
;
B $8056,9 medal_1_0
B $805F,9 medal_1_2
B $8068,9 medal_1_4
B $8071,9 medal_1_6
B $807A,9 medal_1_8
B $8083,9 medal_1_10
;
B $808C,9 medal_2_0
B $8095,9 medal_2_1/3/5/7/9
B $809E,9 medal_2_2
B $80A7,9 medal_2_4
B $80B0,9 medal_2_6
B $80B9,9 medal_2_8
B $80C2,9 medal_2_10
;
B $80CB,9 medal_3_0
B $80D4,9 medal_3_1
B $80DD,9 medal_3_2
B $80E6,9 medal_3_3
B $80EF,9 medal_3_4
B $80F8,9 medal_3_5
B $8101,9 medal_3_6
B $810A,9 medal_3_7
B $8113,9 medal_3_8
B $811C,9 medal_3_9
;
B $8125,9 medal_4_0
B $812E,9 medal_4_1
B $8137,9 medal_4_2
B $8140,9 medal_4_3
B $8149,9 medal_4_4
B $8152,9 medal_4_5
B $815B,9 medal_4_6
B $8164,9 medal_4_7
B $816D,9 medal_4_8
B $8176,9 medal_4_9
;
B $817F,9 bell_top_middle
B $8188,9 bell_top_right
B $8191,9 bell_middle_left
B $819A,9 bell_middle_middle

; ------------------------------------------------------------------------------

u $81A3 unused_81A3
D $81A3 Unreferenced byte.

; ------------------------------------------------------------------------------

; a pos_t
D $81A4 Saved position.
w $81A4 saved_Y
w $81A6 saved_X
w $81A8 saved_VO

; ------------------------------------------------------------------------------

b $81AA stashed_A
D $81AA Used by sub_AF8F only.

; ------------------------------------------------------------------------------

u $81AB unused_81AB
D $81AB Unreferenced byte.

; ------------------------------------------------------------------------------

w $81AC bitmap_pointer
w $81AE mask_pointer
w $81B0 foreground_mask_pointer

; ------------------------------------------------------------------------------

b $81B2 byte_81B2
b $81B3 byte_81B3
b $81B4 byte_81B4
b $81B5 map_position_related_1
b $81B6 map_position_related_2

; ------------------------------------------------------------------------------

b $81B7 flip_sprite
D $81B7 Controls character left/right flipping.

; ------------------------------------------------------------------------------

; a tinypos_t
D $81B8 Player's map position.
b $81B8 player_map_position.y
b $81B9 player_map_position.x
b $81BA player_map_position.vo

; ------------------------------------------------------------------------------

w $81BB map_position
D $81BB Map position. Used when drawing tiles.

; ------------------------------------------------------------------------------

b $81BD searchlight_state
D $81BD Searchlight state.
D $81BD Suspect that this is a 'player has been found in searchlight' flag. (possible states: 0, 31, 255)
D $81BD (<- nighttime, something_then_decrease_morale)

; ------------------------------------------------------------------------------

b $81BE roomdef_bounds_index
D $81BE Index into roomdef_bounds[].
D $81BE Copy of first byte of current room def.

; ------------------------------------------------------------------------------

b $81BF roomdef_object_bounds
D $81BF Copy of current room def's additional bounds (ie. room objects).

; ------------------------------------------------------------------------------

b $81D6 door_related
D $81D6 (<- indoors maybe, <- open door)
D $81D9 Final byte?

; ------------------------------------------------------------------------------

b $81DA suspected_indoor_mask_data
D $81DA (<- setup_room, suspected_mask_stuff)

; ------------------------------------------------------------------------------

b $8213 possibly_holds_an_item

; ------------------------------------------------------------------------------

; possibly a copy of item_definitions 2nd member
b $8214 item_def_2nd_memb_copy

; ------------------------------------------------------------------------------

w $8215 items_held
D $8215 Items which the player is holding.
D $8215 Two byte slots. initialised to 0xFFFF meaning no item in either slot.

; ------------------------------------------------------------------------------

b $8217 character_index
D $8217 Character index.

; ------------------------------------------------------------------------------

; Tiles.
;
b $8218 tiles
;
;D $8218 #UDGARRAY1,7,4,1;$8218-$858F-8(exterior-tiles0)
;D $8590 #UDGARRAY1,7,4,1;$8590-$8A17-8(exterior-tiles1)
;D $8A18 #UDGARRAY1,7,4,1;$8A18-$90F7-8(exterior-tiles2)
;D $90F8 #UDGARRAY1,7,4,1;$90F8-$9767-8(exterior-tiles3)
;D $9768 #UDGARRAY1,7,4,1;$9768-$9D77-8(interior-tiles)
;
D $8218 Exterior tiles set 0. 111 tiles. Looks like mask tiles for huts. (<- plot_tile)
D $8590 Exterior tiles set 1. 145 tiles. Looks like tiles for huts. (<- plot_tile)
D $8A18 Exterior tiles set 2. 220 tiles. Looks like main building wall tiles. (<- plot_tile)
D $90F8 Exterior tiles set 3. 243 tiles. Looks like main building wall tiles.
D $9768 Interior tiles. 194 tiles.
;
;B $8A18,8 tile: ground1 [start of exterior tiles 2] (<- plot_tile)
;B $8A20,8 tile: ground2
;B $8A28,8 tile: ground3
;B $8A30,8 tile: ground4
;
;D $9768,8 empty tile (<- plot_indoor_tiles, select_tile_set)

B $8218 #UDGARRAY1,7,4,1;$8218-$821F-8(exterior-tiles0-000)
B $8220 #UDGARRAY1,7,4,1;$8220-$8227-8(exterior-tiles0-001)
B $8228 #UDGARRAY1,7,4,1;$8228-$822F-8(exterior-tiles0-002)
B $8230 #UDGARRAY1,7,4,1;$8230-$8237-8(exterior-tiles0-003)
B $8238 #UDGARRAY1,7,4,1;$8238-$823F-8(exterior-tiles0-004)
B $8240 #UDGARRAY1,7,4,1;$8240-$8247-8(exterior-tiles0-005)
B $8248 #UDGARRAY1,7,4,1;$8248-$824F-8(exterior-tiles0-006)
B $8250 #UDGARRAY1,7,4,1;$8250-$8257-8(exterior-tiles0-007)
B $8258 #UDGARRAY1,7,4,1;$8258-$825F-8(exterior-tiles0-008)
B $8260 #UDGARRAY1,7,4,1;$8260-$8267-8(exterior-tiles0-009)
B $8268 #UDGARRAY1,7,4,1;$8268-$826F-8(exterior-tiles0-010)
B $8270 #UDGARRAY1,7,4,1;$8270-$8277-8(exterior-tiles0-011)
B $8278 #UDGARRAY1,7,4,1;$8278-$827F-8(exterior-tiles0-012)
B $8280 #UDGARRAY1,7,4,1;$8280-$8287-8(exterior-tiles0-013)
B $8288 #UDGARRAY1,7,4,1;$8288-$828F-8(exterior-tiles0-014)
B $8290 #UDGARRAY1,7,4,1;$8290-$8297-8(exterior-tiles0-015)
B $8298 #UDGARRAY1,7,4,1;$8298-$829F-8(exterior-tiles0-016)
B $82A0 #UDGARRAY1,7,4,1;$82A0-$82A7-8(exterior-tiles0-017)
B $82A8 #UDGARRAY1,7,4,1;$82A8-$82AF-8(exterior-tiles0-018)
B $82B0 #UDGARRAY1,7,4,1;$82B0-$82B7-8(exterior-tiles0-019)
B $82B8 #UDGARRAY1,7,4,1;$82B8-$82BF-8(exterior-tiles0-020)
B $82C0 #UDGARRAY1,7,4,1;$82C0-$82C7-8(exterior-tiles0-021)
B $82C8 #UDGARRAY1,7,4,1;$82C8-$82CF-8(exterior-tiles0-022)
B $82D0 #UDGARRAY1,7,4,1;$82D0-$82D7-8(exterior-tiles0-023)
B $82D8 #UDGARRAY1,7,4,1;$82D8-$82DF-8(exterior-tiles0-024)
B $82E0 #UDGARRAY1,7,4,1;$82E0-$82E7-8(exterior-tiles0-025)
B $82E8 #UDGARRAY1,7,4,1;$82E8-$82EF-8(exterior-tiles0-026)
B $82F0 #UDGARRAY1,7,4,1;$82F0-$82F7-8(exterior-tiles0-027)
B $82F8 #UDGARRAY1,7,4,1;$82F8-$82FF-8(exterior-tiles0-028)
B $8300 #UDGARRAY1,7,4,1;$8300-$8307-8(exterior-tiles0-029)
B $8308 #UDGARRAY1,7,4,1;$8308-$830F-8(exterior-tiles0-030)
B $8310 #UDGARRAY1,7,4,1;$8310-$8317-8(exterior-tiles0-031)
B $8318 #UDGARRAY1,7,4,1;$8318-$831F-8(exterior-tiles0-032)
B $8320 #UDGARRAY1,7,4,1;$8320-$8327-8(exterior-tiles0-033)
B $8328 #UDGARRAY1,7,4,1;$8328-$832F-8(exterior-tiles0-034)
B $8330 #UDGARRAY1,7,4,1;$8330-$8337-8(exterior-tiles0-035)
B $8338 #UDGARRAY1,7,4,1;$8338-$833F-8(exterior-tiles0-036)
B $8340 #UDGARRAY1,7,4,1;$8340-$8347-8(exterior-tiles0-037)
B $8348 #UDGARRAY1,7,4,1;$8348-$834F-8(exterior-tiles0-038)
B $8350 #UDGARRAY1,7,4,1;$8350-$8357-8(exterior-tiles0-039)
B $8358 #UDGARRAY1,7,4,1;$8358-$835F-8(exterior-tiles0-040)
B $8360 #UDGARRAY1,7,4,1;$8360-$8367-8(exterior-tiles0-041)
B $8368 #UDGARRAY1,7,4,1;$8368-$836F-8(exterior-tiles0-042)
B $8370 #UDGARRAY1,7,4,1;$8370-$8377-8(exterior-tiles0-043)
B $8378 #UDGARRAY1,7,4,1;$8378-$837F-8(exterior-tiles0-044)
B $8380 #UDGARRAY1,7,4,1;$8380-$8387-8(exterior-tiles0-045)
B $8388 #UDGARRAY1,7,4,1;$8388-$838F-8(exterior-tiles0-046)
B $8390 #UDGARRAY1,7,4,1;$8390-$8397-8(exterior-tiles0-047)
B $8398 #UDGARRAY1,7,4,1;$8398-$839F-8(exterior-tiles0-048)
B $83A0 #UDGARRAY1,7,4,1;$83A0-$83A7-8(exterior-tiles0-049)
B $83A8 #UDGARRAY1,7,4,1;$83A8-$83AF-8(exterior-tiles0-050)
B $83B0 #UDGARRAY1,7,4,1;$83B0-$83B7-8(exterior-tiles0-051)
B $83B8 #UDGARRAY1,7,4,1;$83B8-$83BF-8(exterior-tiles0-052)
B $83C0 #UDGARRAY1,7,4,1;$83C0-$83C7-8(exterior-tiles0-053)
B $83C8 #UDGARRAY1,7,4,1;$83C8-$83CF-8(exterior-tiles0-054)
B $83D0 #UDGARRAY1,7,4,1;$83D0-$83D7-8(exterior-tiles0-055)
B $83D8 #UDGARRAY1,7,4,1;$83D8-$83DF-8(exterior-tiles0-056)
B $83E0 #UDGARRAY1,7,4,1;$83E0-$83E7-8(exterior-tiles0-057)
B $83E8 #UDGARRAY1,7,4,1;$83E8-$83EF-8(exterior-tiles0-058)
B $83F0 #UDGARRAY1,7,4,1;$83F0-$83F7-8(exterior-tiles0-059)
B $83F8 #UDGARRAY1,7,4,1;$83F8-$83FF-8(exterior-tiles0-060)
B $8400 #UDGARRAY1,7,4,1;$8400-$8407-8(exterior-tiles0-061)
B $8408 #UDGARRAY1,7,4,1;$8408-$840F-8(exterior-tiles0-062)
B $8410 #UDGARRAY1,7,4,1;$8410-$8417-8(exterior-tiles0-063)
B $8418 #UDGARRAY1,7,4,1;$8418-$841F-8(exterior-tiles0-064)
B $8420 #UDGARRAY1,7,4,1;$8420-$8427-8(exterior-tiles0-065)
B $8428 #UDGARRAY1,7,4,1;$8428-$842F-8(exterior-tiles0-066)
B $8430 #UDGARRAY1,7,4,1;$8430-$8437-8(exterior-tiles0-067)
B $8438 #UDGARRAY1,7,4,1;$8438-$843F-8(exterior-tiles0-068)
B $8440 #UDGARRAY1,7,4,1;$8440-$8447-8(exterior-tiles0-069)
B $8448 #UDGARRAY1,7,4,1;$8448-$844F-8(exterior-tiles0-070)
B $8450 #UDGARRAY1,7,4,1;$8450-$8457-8(exterior-tiles0-071)
B $8458 #UDGARRAY1,7,4,1;$8458-$845F-8(exterior-tiles0-072)
B $8460 #UDGARRAY1,7,4,1;$8460-$8467-8(exterior-tiles0-073)
B $8468 #UDGARRAY1,7,4,1;$8468-$846F-8(exterior-tiles0-074)
B $8470 #UDGARRAY1,7,4,1;$8470-$8477-8(exterior-tiles0-075)
B $8478 #UDGARRAY1,7,4,1;$8478-$847F-8(exterior-tiles0-076)
B $8480 #UDGARRAY1,7,4,1;$8480-$8487-8(exterior-tiles0-077)
B $8488 #UDGARRAY1,7,4,1;$8488-$848F-8(exterior-tiles0-078)
B $8490 #UDGARRAY1,7,4,1;$8490-$8497-8(exterior-tiles0-079)
B $8498 #UDGARRAY1,7,4,1;$8498-$849F-8(exterior-tiles0-080)
B $84A0 #UDGARRAY1,7,4,1;$84A0-$84A7-8(exterior-tiles0-081)
B $84A8 #UDGARRAY1,7,4,1;$84A8-$84AF-8(exterior-tiles0-082)
B $84B0 #UDGARRAY1,7,4,1;$84B0-$84B7-8(exterior-tiles0-083)
B $84B8 #UDGARRAY1,7,4,1;$84B8-$84BF-8(exterior-tiles0-084)
B $84C0 #UDGARRAY1,7,4,1;$84C0-$84C7-8(exterior-tiles0-085)
B $84C8 #UDGARRAY1,7,4,1;$84C8-$84CF-8(exterior-tiles0-086)
B $84D0 #UDGARRAY1,7,4,1;$84D0-$84D7-8(exterior-tiles0-087)
B $84D8 #UDGARRAY1,7,4,1;$84D8-$84DF-8(exterior-tiles0-088)
B $84E0 #UDGARRAY1,7,4,1;$84E0-$84E7-8(exterior-tiles0-089)
B $84E8 #UDGARRAY1,7,4,1;$84E8-$84EF-8(exterior-tiles0-090)
B $84F0 #UDGARRAY1,7,4,1;$84F0-$84F7-8(exterior-tiles0-091)
B $84F8 #UDGARRAY1,7,4,1;$84F8-$84FF-8(exterior-tiles0-092)
B $8500 #UDGARRAY1,7,4,1;$8500-$8507-8(exterior-tiles0-093)
B $8508 #UDGARRAY1,7,4,1;$8508-$850F-8(exterior-tiles0-094)
B $8510 #UDGARRAY1,7,4,1;$8510-$8517-8(exterior-tiles0-095)
B $8518 #UDGARRAY1,7,4,1;$8518-$851F-8(exterior-tiles0-096)
B $8520 #UDGARRAY1,7,4,1;$8520-$8527-8(exterior-tiles0-097)
B $8528 #UDGARRAY1,7,4,1;$8528-$852F-8(exterior-tiles0-098)
B $8530 #UDGARRAY1,7,4,1;$8530-$8537-8(exterior-tiles0-099)
B $8538 #UDGARRAY1,7,4,1;$8538-$853F-8(exterior-tiles0-100)
B $8540 #UDGARRAY1,7,4,1;$8540-$8547-8(exterior-tiles0-101)
B $8548 #UDGARRAY1,7,4,1;$8548-$854F-8(exterior-tiles0-102)
B $8550 #UDGARRAY1,7,4,1;$8550-$8557-8(exterior-tiles0-103)
B $8558 #UDGARRAY1,7,4,1;$8558-$855F-8(exterior-tiles0-104)
B $8560 #UDGARRAY1,7,4,1;$8560-$8567-8(exterior-tiles0-105)
B $8568 #UDGARRAY1,7,4,1;$8568-$856F-8(exterior-tiles0-106)
B $8570 #UDGARRAY1,7,4,1;$8570-$8577-8(exterior-tiles0-107)
B $8578 #UDGARRAY1,7,4,1;$8578-$857F-8(exterior-tiles0-108)
B $8580 #UDGARRAY1,7,4,1;$8580-$8587-8(exterior-tiles0-109)
B $8588 #UDGARRAY1,7,4,1;$8588-$858F-8(exterior-tiles0-110)
B $8590 #UDGARRAY1,7,4,1;$8590-$8597-8(exterior-tiles1-000)
B $8598 #UDGARRAY1,7,4,1;$8598-$859F-8(exterior-tiles1-001)
B $85A0 #UDGARRAY1,7,4,1;$85A0-$85A7-8(exterior-tiles1-002)
B $85A8 #UDGARRAY1,7,4,1;$85A8-$85AF-8(exterior-tiles1-003)
B $85B0 #UDGARRAY1,7,4,1;$85B0-$85B7-8(exterior-tiles1-004)
B $85B8 #UDGARRAY1,7,4,1;$85B8-$85BF-8(exterior-tiles1-005)
B $85C0 #UDGARRAY1,7,4,1;$85C0-$85C7-8(exterior-tiles1-006)
B $85C8 #UDGARRAY1,7,4,1;$85C8-$85CF-8(exterior-tiles1-007)
B $85D0 #UDGARRAY1,7,4,1;$85D0-$85D7-8(exterior-tiles1-008)
B $85D8 #UDGARRAY1,7,4,1;$85D8-$85DF-8(exterior-tiles1-009)
B $85E0 #UDGARRAY1,7,4,1;$85E0-$85E7-8(exterior-tiles1-010)
B $85E8 #UDGARRAY1,7,4,1;$85E8-$85EF-8(exterior-tiles1-011)
B $85F0 #UDGARRAY1,7,4,1;$85F0-$85F7-8(exterior-tiles1-012)
B $85F8 #UDGARRAY1,7,4,1;$85F8-$85FF-8(exterior-tiles1-013)
B $8600 #UDGARRAY1,7,4,1;$8600-$8607-8(exterior-tiles1-014)
B $8608 #UDGARRAY1,7,4,1;$8608-$860F-8(exterior-tiles1-015)
B $8610 #UDGARRAY1,7,4,1;$8610-$8617-8(exterior-tiles1-016)
B $8618 #UDGARRAY1,7,4,1;$8618-$861F-8(exterior-tiles1-017)
B $8620 #UDGARRAY1,7,4,1;$8620-$8627-8(exterior-tiles1-018)
B $8628 #UDGARRAY1,7,4,1;$8628-$862F-8(exterior-tiles1-019)
B $8630 #UDGARRAY1,7,4,1;$8630-$8637-8(exterior-tiles1-020)
B $8638 #UDGARRAY1,7,4,1;$8638-$863F-8(exterior-tiles1-021)
B $8640 #UDGARRAY1,7,4,1;$8640-$8647-8(exterior-tiles1-022)
B $8648 #UDGARRAY1,7,4,1;$8648-$864F-8(exterior-tiles1-023)
B $8650 #UDGARRAY1,7,4,1;$8650-$8657-8(exterior-tiles1-024)
B $8658 #UDGARRAY1,7,4,1;$8658-$865F-8(exterior-tiles1-025)
B $8660 #UDGARRAY1,7,4,1;$8660-$8667-8(exterior-tiles1-026)
B $8668 #UDGARRAY1,7,4,1;$8668-$866F-8(exterior-tiles1-027)
B $8670 #UDGARRAY1,7,4,1;$8670-$8677-8(exterior-tiles1-028)
B $8678 #UDGARRAY1,7,4,1;$8678-$867F-8(exterior-tiles1-029)
B $8680 #UDGARRAY1,7,4,1;$8680-$8687-8(exterior-tiles1-030)
B $8688 #UDGARRAY1,7,4,1;$8688-$868F-8(exterior-tiles1-031)
B $8690 #UDGARRAY1,7,4,1;$8690-$8697-8(exterior-tiles1-032)
B $8698 #UDGARRAY1,7,4,1;$8698-$869F-8(exterior-tiles1-033)
B $86A0 #UDGARRAY1,7,4,1;$86A0-$86A7-8(exterior-tiles1-034)
B $86A8 #UDGARRAY1,7,4,1;$86A8-$86AF-8(exterior-tiles1-035)
B $86B0 #UDGARRAY1,7,4,1;$86B0-$86B7-8(exterior-tiles1-036)
B $86B8 #UDGARRAY1,7,4,1;$86B8-$86BF-8(exterior-tiles1-037)
B $86C0 #UDGARRAY1,7,4,1;$86C0-$86C7-8(exterior-tiles1-038)
B $86C8 #UDGARRAY1,7,4,1;$86C8-$86CF-8(exterior-tiles1-039)
B $86D0 #UDGARRAY1,7,4,1;$86D0-$86D7-8(exterior-tiles1-040)
B $86D8 #UDGARRAY1,7,4,1;$86D8-$86DF-8(exterior-tiles1-041)
B $86E0 #UDGARRAY1,7,4,1;$86E0-$86E7-8(exterior-tiles1-042)
B $86E8 #UDGARRAY1,7,4,1;$86E8-$86EF-8(exterior-tiles1-043)
B $86F0 #UDGARRAY1,7,4,1;$86F0-$86F7-8(exterior-tiles1-044)
B $86F8 #UDGARRAY1,7,4,1;$86F8-$86FF-8(exterior-tiles1-045)
B $8700 #UDGARRAY1,7,4,1;$8700-$8707-8(exterior-tiles1-046)
B $8708 #UDGARRAY1,7,4,1;$8708-$870F-8(exterior-tiles1-047)
B $8710 #UDGARRAY1,7,4,1;$8710-$8717-8(exterior-tiles1-048)
B $8718 #UDGARRAY1,7,4,1;$8718-$871F-8(exterior-tiles1-049)
B $8720 #UDGARRAY1,7,4,1;$8720-$8727-8(exterior-tiles1-050)
B $8728 #UDGARRAY1,7,4,1;$8728-$872F-8(exterior-tiles1-051)
B $8730 #UDGARRAY1,7,4,1;$8730-$8737-8(exterior-tiles1-052)
B $8738 #UDGARRAY1,7,4,1;$8738-$873F-8(exterior-tiles1-053)
B $8740 #UDGARRAY1,7,4,1;$8740-$8747-8(exterior-tiles1-054)
B $8748 #UDGARRAY1,7,4,1;$8748-$874F-8(exterior-tiles1-055)
B $8750 #UDGARRAY1,7,4,1;$8750-$8757-8(exterior-tiles1-056)
B $8758 #UDGARRAY1,7,4,1;$8758-$875F-8(exterior-tiles1-057)
B $8760 #UDGARRAY1,7,4,1;$8760-$8767-8(exterior-tiles1-058)
B $8768 #UDGARRAY1,7,4,1;$8768-$876F-8(exterior-tiles1-059)
B $8770 #UDGARRAY1,7,4,1;$8770-$8777-8(exterior-tiles1-060)
B $8778 #UDGARRAY1,7,4,1;$8778-$877F-8(exterior-tiles1-061)
B $8780 #UDGARRAY1,7,4,1;$8780-$8787-8(exterior-tiles1-062)
B $8788 #UDGARRAY1,7,4,1;$8788-$878F-8(exterior-tiles1-063)
B $8790 #UDGARRAY1,7,4,1;$8790-$8797-8(exterior-tiles1-064)
B $8798 #UDGARRAY1,7,4,1;$8798-$879F-8(exterior-tiles1-065)
B $87A0 #UDGARRAY1,7,4,1;$87A0-$87A7-8(exterior-tiles1-066)
B $87A8 #UDGARRAY1,7,4,1;$87A8-$87AF-8(exterior-tiles1-067)
B $87B0 #UDGARRAY1,7,4,1;$87B0-$87B7-8(exterior-tiles1-068)
B $87B8 #UDGARRAY1,7,4,1;$87B8-$87BF-8(exterior-tiles1-069)
B $87C0 #UDGARRAY1,7,4,1;$87C0-$87C7-8(exterior-tiles1-070)
B $87C8 #UDGARRAY1,7,4,1;$87C8-$87CF-8(exterior-tiles1-071)
B $87D0 #UDGARRAY1,7,4,1;$87D0-$87D7-8(exterior-tiles1-072)
B $87D8 #UDGARRAY1,7,4,1;$87D8-$87DF-8(exterior-tiles1-073)
B $87E0 #UDGARRAY1,7,4,1;$87E0-$87E7-8(exterior-tiles1-074)
B $87E8 #UDGARRAY1,7,4,1;$87E8-$87EF-8(exterior-tiles1-075)
B $87F0 #UDGARRAY1,7,4,1;$87F0-$87F7-8(exterior-tiles1-076)
B $87F8 #UDGARRAY1,7,4,1;$87F8-$87FF-8(exterior-tiles1-077)
B $8800 #UDGARRAY1,7,4,1;$8800-$8807-8(exterior-tiles1-078)
B $8808 #UDGARRAY1,7,4,1;$8808-$880F-8(exterior-tiles1-079)
B $8810 #UDGARRAY1,7,4,1;$8810-$8817-8(exterior-tiles1-080)
B $8818 #UDGARRAY1,7,4,1;$8818-$881F-8(exterior-tiles1-081)
B $8820 #UDGARRAY1,7,4,1;$8820-$8827-8(exterior-tiles1-082)
B $8828 #UDGARRAY1,7,4,1;$8828-$882F-8(exterior-tiles1-083)
B $8830 #UDGARRAY1,7,4,1;$8830-$8837-8(exterior-tiles1-084)
B $8838 #UDGARRAY1,7,4,1;$8838-$883F-8(exterior-tiles1-085)
B $8840 #UDGARRAY1,7,4,1;$8840-$8847-8(exterior-tiles1-086)
B $8848 #UDGARRAY1,7,4,1;$8848-$884F-8(exterior-tiles1-087)
B $8850 #UDGARRAY1,7,4,1;$8850-$8857-8(exterior-tiles1-088)
B $8858 #UDGARRAY1,7,4,1;$8858-$885F-8(exterior-tiles1-089)
B $8860 #UDGARRAY1,7,4,1;$8860-$8867-8(exterior-tiles1-090)
B $8868 #UDGARRAY1,7,4,1;$8868-$886F-8(exterior-tiles1-091)
B $8870 #UDGARRAY1,7,4,1;$8870-$8877-8(exterior-tiles1-092)
B $8878 #UDGARRAY1,7,4,1;$8878-$887F-8(exterior-tiles1-093)
B $8880 #UDGARRAY1,7,4,1;$8880-$8887-8(exterior-tiles1-094)
B $8888 #UDGARRAY1,7,4,1;$8888-$888F-8(exterior-tiles1-095)
B $8890 #UDGARRAY1,7,4,1;$8890-$8897-8(exterior-tiles1-096)
B $8898 #UDGARRAY1,7,4,1;$8898-$889F-8(exterior-tiles1-097)
B $88A0 #UDGARRAY1,7,4,1;$88A0-$88A7-8(exterior-tiles1-098)
B $88A8 #UDGARRAY1,7,4,1;$88A8-$88AF-8(exterior-tiles1-099)
B $88B0 #UDGARRAY1,7,4,1;$88B0-$88B7-8(exterior-tiles1-100)
B $88B8 #UDGARRAY1,7,4,1;$88B8-$88BF-8(exterior-tiles1-101)
B $88C0 #UDGARRAY1,7,4,1;$88C0-$88C7-8(exterior-tiles1-102)
B $88C8 #UDGARRAY1,7,4,1;$88C8-$88CF-8(exterior-tiles1-103)
B $88D0 #UDGARRAY1,7,4,1;$88D0-$88D7-8(exterior-tiles1-104)
B $88D8 #UDGARRAY1,7,4,1;$88D8-$88DF-8(exterior-tiles1-105)
B $88E0 #UDGARRAY1,7,4,1;$88E0-$88E7-8(exterior-tiles1-106)
B $88E8 #UDGARRAY1,7,4,1;$88E8-$88EF-8(exterior-tiles1-107)
B $88F0 #UDGARRAY1,7,4,1;$88F0-$88F7-8(exterior-tiles1-108)
B $88F8 #UDGARRAY1,7,4,1;$88F8-$88FF-8(exterior-tiles1-109)
B $8900 #UDGARRAY1,7,4,1;$8900-$8907-8(exterior-tiles1-110)
B $8908 #UDGARRAY1,7,4,1;$8908-$890F-8(exterior-tiles1-111)
B $8910 #UDGARRAY1,7,4,1;$8910-$8917-8(exterior-tiles1-112)
B $8918 #UDGARRAY1,7,4,1;$8918-$891F-8(exterior-tiles1-113)
B $8920 #UDGARRAY1,7,4,1;$8920-$8927-8(exterior-tiles1-114)
B $8928 #UDGARRAY1,7,4,1;$8928-$892F-8(exterior-tiles1-115)
B $8930 #UDGARRAY1,7,4,1;$8930-$8937-8(exterior-tiles1-116)
B $8938 #UDGARRAY1,7,4,1;$8938-$893F-8(exterior-tiles1-117)
B $8940 #UDGARRAY1,7,4,1;$8940-$8947-8(exterior-tiles1-118)
B $8948 #UDGARRAY1,7,4,1;$8948-$894F-8(exterior-tiles1-119)
B $8950 #UDGARRAY1,7,4,1;$8950-$8957-8(exterior-tiles1-120)
B $8958 #UDGARRAY1,7,4,1;$8958-$895F-8(exterior-tiles1-121)
B $8960 #UDGARRAY1,7,4,1;$8960-$8967-8(exterior-tiles1-122)
B $8968 #UDGARRAY1,7,4,1;$8968-$896F-8(exterior-tiles1-123)
B $8970 #UDGARRAY1,7,4,1;$8970-$8977-8(exterior-tiles1-124)
B $8978 #UDGARRAY1,7,4,1;$8978-$897F-8(exterior-tiles1-125)
B $8980 #UDGARRAY1,7,4,1;$8980-$8987-8(exterior-tiles1-126)
B $8988 #UDGARRAY1,7,4,1;$8988-$898F-8(exterior-tiles1-127)
B $8990 #UDGARRAY1,7,4,1;$8990-$8997-8(exterior-tiles1-128)
B $8998 #UDGARRAY1,7,4,1;$8998-$899F-8(exterior-tiles1-129)
B $89A0 #UDGARRAY1,7,4,1;$89A0-$89A7-8(exterior-tiles1-130)
B $89A8 #UDGARRAY1,7,4,1;$89A8-$89AF-8(exterior-tiles1-131)
B $89B0 #UDGARRAY1,7,4,1;$89B0-$89B7-8(exterior-tiles1-132)
B $89B8 #UDGARRAY1,7,4,1;$89B8-$89BF-8(exterior-tiles1-133)
B $89C0 #UDGARRAY1,7,4,1;$89C0-$89C7-8(exterior-tiles1-134)
B $89C8 #UDGARRAY1,7,4,1;$89C8-$89CF-8(exterior-tiles1-135)
B $89D0 #UDGARRAY1,7,4,1;$89D0-$89D7-8(exterior-tiles1-136)
B $89D8 #UDGARRAY1,7,4,1;$89D8-$89DF-8(exterior-tiles1-137)
B $89E0 #UDGARRAY1,7,4,1;$89E0-$89E7-8(exterior-tiles1-138)
B $89E8 #UDGARRAY1,7,4,1;$89E8-$89EF-8(exterior-tiles1-139)
B $89F0 #UDGARRAY1,7,4,1;$89F0-$89F7-8(exterior-tiles1-140)
B $89F8 #UDGARRAY1,7,4,1;$89F8-$89FF-8(exterior-tiles1-141)
B $8A00 #UDGARRAY1,7,4,1;$8A00-$8A07-8(exterior-tiles1-142)
B $8A08 #UDGARRAY1,7,4,1;$8A08-$8A0F-8(exterior-tiles1-143)
B $8A10 #UDGARRAY1,7,4,1;$8A10-$8A17-8(exterior-tiles1-144)
B $8A18 #UDGARRAY1,7,4,1;$8A18-$8A1F-8(exterior-tiles2-000)
B $8A20 #UDGARRAY1,7,4,1;$8A20-$8A27-8(exterior-tiles2-001)
B $8A28 #UDGARRAY1,7,4,1;$8A28-$8A2F-8(exterior-tiles2-002)
B $8A30 #UDGARRAY1,7,4,1;$8A30-$8A37-8(exterior-tiles2-003)
B $8A38 #UDGARRAY1,7,4,1;$8A38-$8A3F-8(exterior-tiles2-004)
B $8A40 #UDGARRAY1,7,4,1;$8A40-$8A47-8(exterior-tiles2-005)
B $8A48 #UDGARRAY1,7,4,1;$8A48-$8A4F-8(exterior-tiles2-006)
B $8A50 #UDGARRAY1,7,4,1;$8A50-$8A57-8(exterior-tiles2-007)
B $8A58 #UDGARRAY1,7,4,1;$8A58-$8A5F-8(exterior-tiles2-008)
B $8A60 #UDGARRAY1,7,4,1;$8A60-$8A67-8(exterior-tiles2-009)
B $8A68 #UDGARRAY1,7,4,1;$8A68-$8A6F-8(exterior-tiles2-010)
B $8A70 #UDGARRAY1,7,4,1;$8A70-$8A77-8(exterior-tiles2-011)
B $8A78 #UDGARRAY1,7,4,1;$8A78-$8A7F-8(exterior-tiles2-012)
B $8A80 #UDGARRAY1,7,4,1;$8A80-$8A87-8(exterior-tiles2-013)
B $8A88 #UDGARRAY1,7,4,1;$8A88-$8A8F-8(exterior-tiles2-014)
B $8A90 #UDGARRAY1,7,4,1;$8A90-$8A97-8(exterior-tiles2-015)
B $8A98 #UDGARRAY1,7,4,1;$8A98-$8A9F-8(exterior-tiles2-016)
B $8AA0 #UDGARRAY1,7,4,1;$8AA0-$8AA7-8(exterior-tiles2-017)
B $8AA8 #UDGARRAY1,7,4,1;$8AA8-$8AAF-8(exterior-tiles2-018)
B $8AB0 #UDGARRAY1,7,4,1;$8AB0-$8AB7-8(exterior-tiles2-019)
B $8AB8 #UDGARRAY1,7,4,1;$8AB8-$8ABF-8(exterior-tiles2-020)
B $8AC0 #UDGARRAY1,7,4,1;$8AC0-$8AC7-8(exterior-tiles2-021)
B $8AC8 #UDGARRAY1,7,4,1;$8AC8-$8ACF-8(exterior-tiles2-022)
B $8AD0 #UDGARRAY1,7,4,1;$8AD0-$8AD7-8(exterior-tiles2-023)
B $8AD8 #UDGARRAY1,7,4,1;$8AD8-$8ADF-8(exterior-tiles2-024)
B $8AE0 #UDGARRAY1,7,4,1;$8AE0-$8AE7-8(exterior-tiles2-025)
B $8AE8 #UDGARRAY1,7,4,1;$8AE8-$8AEF-8(exterior-tiles2-026)
B $8AF0 #UDGARRAY1,7,4,1;$8AF0-$8AF7-8(exterior-tiles2-027)
B $8AF8 #UDGARRAY1,7,4,1;$8AF8-$8AFF-8(exterior-tiles2-028)
B $8B00 #UDGARRAY1,7,4,1;$8B00-$8B07-8(exterior-tiles2-029)
B $8B08 #UDGARRAY1,7,4,1;$8B08-$8B0F-8(exterior-tiles2-030)
B $8B10 #UDGARRAY1,7,4,1;$8B10-$8B17-8(exterior-tiles2-031)
B $8B18 #UDGARRAY1,7,4,1;$8B18-$8B1F-8(exterior-tiles2-032)
B $8B20 #UDGARRAY1,7,4,1;$8B20-$8B27-8(exterior-tiles2-033)
B $8B28 #UDGARRAY1,7,4,1;$8B28-$8B2F-8(exterior-tiles2-034)
B $8B30 #UDGARRAY1,7,4,1;$8B30-$8B37-8(exterior-tiles2-035)
B $8B38 #UDGARRAY1,7,4,1;$8B38-$8B3F-8(exterior-tiles2-036)
B $8B40 #UDGARRAY1,7,4,1;$8B40-$8B47-8(exterior-tiles2-037)
B $8B48 #UDGARRAY1,7,4,1;$8B48-$8B4F-8(exterior-tiles2-038)
B $8B50 #UDGARRAY1,7,4,1;$8B50-$8B57-8(exterior-tiles2-039)
B $8B58 #UDGARRAY1,7,4,1;$8B58-$8B5F-8(exterior-tiles2-040)
B $8B60 #UDGARRAY1,7,4,1;$8B60-$8B67-8(exterior-tiles2-041)
B $8B68 #UDGARRAY1,7,4,1;$8B68-$8B6F-8(exterior-tiles2-042)
B $8B70 #UDGARRAY1,7,4,1;$8B70-$8B77-8(exterior-tiles2-043)
B $8B78 #UDGARRAY1,7,4,1;$8B78-$8B7F-8(exterior-tiles2-044)
B $8B80 #UDGARRAY1,7,4,1;$8B80-$8B87-8(exterior-tiles2-045)
B $8B88 #UDGARRAY1,7,4,1;$8B88-$8B8F-8(exterior-tiles2-046)
B $8B90 #UDGARRAY1,7,4,1;$8B90-$8B97-8(exterior-tiles2-047)
B $8B98 #UDGARRAY1,7,4,1;$8B98-$8B9F-8(exterior-tiles2-048)
B $8BA0 #UDGARRAY1,7,4,1;$8BA0-$8BA7-8(exterior-tiles2-049)
B $8BA8 #UDGARRAY1,7,4,1;$8BA8-$8BAF-8(exterior-tiles2-050)
B $8BB0 #UDGARRAY1,7,4,1;$8BB0-$8BB7-8(exterior-tiles2-051)
B $8BB8 #UDGARRAY1,7,4,1;$8BB8-$8BBF-8(exterior-tiles2-052)
B $8BC0 #UDGARRAY1,7,4,1;$8BC0-$8BC7-8(exterior-tiles2-053)
B $8BC8 #UDGARRAY1,7,4,1;$8BC8-$8BCF-8(exterior-tiles2-054)
B $8BD0 #UDGARRAY1,7,4,1;$8BD0-$8BD7-8(exterior-tiles2-055)
B $8BD8 #UDGARRAY1,7,4,1;$8BD8-$8BDF-8(exterior-tiles2-056)
B $8BE0 #UDGARRAY1,7,4,1;$8BE0-$8BE7-8(exterior-tiles2-057)
B $8BE8 #UDGARRAY1,7,4,1;$8BE8-$8BEF-8(exterior-tiles2-058)
B $8BF0 #UDGARRAY1,7,4,1;$8BF0-$8BF7-8(exterior-tiles2-059)
B $8BF8 #UDGARRAY1,7,4,1;$8BF8-$8BFF-8(exterior-tiles2-060)
B $8C00 #UDGARRAY1,7,4,1;$8C00-$8C07-8(exterior-tiles2-061)
B $8C08 #UDGARRAY1,7,4,1;$8C08-$8C0F-8(exterior-tiles2-062)
B $8C10 #UDGARRAY1,7,4,1;$8C10-$8C17-8(exterior-tiles2-063)
B $8C18 #UDGARRAY1,7,4,1;$8C18-$8C1F-8(exterior-tiles2-064)
B $8C20 #UDGARRAY1,7,4,1;$8C20-$8C27-8(exterior-tiles2-065)
B $8C28 #UDGARRAY1,7,4,1;$8C28-$8C2F-8(exterior-tiles2-066)
B $8C30 #UDGARRAY1,7,4,1;$8C30-$8C37-8(exterior-tiles2-067)
B $8C38 #UDGARRAY1,7,4,1;$8C38-$8C3F-8(exterior-tiles2-068)
B $8C40 #UDGARRAY1,7,4,1;$8C40-$8C47-8(exterior-tiles2-069)
B $8C48 #UDGARRAY1,7,4,1;$8C48-$8C4F-8(exterior-tiles2-070)
B $8C50 #UDGARRAY1,7,4,1;$8C50-$8C57-8(exterior-tiles2-071)
B $8C58 #UDGARRAY1,7,4,1;$8C58-$8C5F-8(exterior-tiles2-072)
B $8C60 #UDGARRAY1,7,4,1;$8C60-$8C67-8(exterior-tiles2-073)
B $8C68 #UDGARRAY1,7,4,1;$8C68-$8C6F-8(exterior-tiles2-074)
B $8C70 #UDGARRAY1,7,4,1;$8C70-$8C77-8(exterior-tiles2-075)
B $8C78 #UDGARRAY1,7,4,1;$8C78-$8C7F-8(exterior-tiles2-076)
B $8C80 #UDGARRAY1,7,4,1;$8C80-$8C87-8(exterior-tiles2-077)
B $8C88 #UDGARRAY1,7,4,1;$8C88-$8C8F-8(exterior-tiles2-078)
B $8C90 #UDGARRAY1,7,4,1;$8C90-$8C97-8(exterior-tiles2-079)
B $8C98 #UDGARRAY1,7,4,1;$8C98-$8C9F-8(exterior-tiles2-080)
B $8CA0 #UDGARRAY1,7,4,1;$8CA0-$8CA7-8(exterior-tiles2-081)
B $8CA8 #UDGARRAY1,7,4,1;$8CA8-$8CAF-8(exterior-tiles2-082)
B $8CB0 #UDGARRAY1,7,4,1;$8CB0-$8CB7-8(exterior-tiles2-083)
B $8CB8 #UDGARRAY1,7,4,1;$8CB8-$8CBF-8(exterior-tiles2-084)
B $8CC0 #UDGARRAY1,7,4,1;$8CC0-$8CC7-8(exterior-tiles2-085)
B $8CC8 #UDGARRAY1,7,4,1;$8CC8-$8CCF-8(exterior-tiles2-086)
B $8CD0 #UDGARRAY1,7,4,1;$8CD0-$8CD7-8(exterior-tiles2-087)
B $8CD8 #UDGARRAY1,7,4,1;$8CD8-$8CDF-8(exterior-tiles2-088)
B $8CE0 #UDGARRAY1,7,4,1;$8CE0-$8CE7-8(exterior-tiles2-089)
B $8CE8 #UDGARRAY1,7,4,1;$8CE8-$8CEF-8(exterior-tiles2-090)
B $8CF0 #UDGARRAY1,7,4,1;$8CF0-$8CF7-8(exterior-tiles2-091)
B $8CF8 #UDGARRAY1,7,4,1;$8CF8-$8CFF-8(exterior-tiles2-092)
B $8D00 #UDGARRAY1,7,4,1;$8D00-$8D07-8(exterior-tiles2-093)
B $8D08 #UDGARRAY1,7,4,1;$8D08-$8D0F-8(exterior-tiles2-094)
B $8D10 #UDGARRAY1,7,4,1;$8D10-$8D17-8(exterior-tiles2-095)
B $8D18 #UDGARRAY1,7,4,1;$8D18-$8D1F-8(exterior-tiles2-096)
B $8D20 #UDGARRAY1,7,4,1;$8D20-$8D27-8(exterior-tiles2-097)
B $8D28 #UDGARRAY1,7,4,1;$8D28-$8D2F-8(exterior-tiles2-098)
B $8D30 #UDGARRAY1,7,4,1;$8D30-$8D37-8(exterior-tiles2-099)
B $8D38 #UDGARRAY1,7,4,1;$8D38-$8D3F-8(exterior-tiles2-100)
B $8D40 #UDGARRAY1,7,4,1;$8D40-$8D47-8(exterior-tiles2-101)
B $8D48 #UDGARRAY1,7,4,1;$8D48-$8D4F-8(exterior-tiles2-102)
B $8D50 #UDGARRAY1,7,4,1;$8D50-$8D57-8(exterior-tiles2-103)
B $8D58 #UDGARRAY1,7,4,1;$8D58-$8D5F-8(exterior-tiles2-104)
B $8D60 #UDGARRAY1,7,4,1;$8D60-$8D67-8(exterior-tiles2-105)
B $8D68 #UDGARRAY1,7,4,1;$8D68-$8D6F-8(exterior-tiles2-106)
B $8D70 #UDGARRAY1,7,4,1;$8D70-$8D77-8(exterior-tiles2-107)
B $8D78 #UDGARRAY1,7,4,1;$8D78-$8D7F-8(exterior-tiles2-108)
B $8D80 #UDGARRAY1,7,4,1;$8D80-$8D87-8(exterior-tiles2-109)
B $8D88 #UDGARRAY1,7,4,1;$8D88-$8D8F-8(exterior-tiles2-110)
B $8D90 #UDGARRAY1,7,4,1;$8D90-$8D97-8(exterior-tiles2-111)
B $8D98 #UDGARRAY1,7,4,1;$8D98-$8D9F-8(exterior-tiles2-112)
B $8DA0 #UDGARRAY1,7,4,1;$8DA0-$8DA7-8(exterior-tiles2-113)
B $8DA8 #UDGARRAY1,7,4,1;$8DA8-$8DAF-8(exterior-tiles2-114)
B $8DB0 #UDGARRAY1,7,4,1;$8DB0-$8DB7-8(exterior-tiles2-115)
B $8DB8 #UDGARRAY1,7,4,1;$8DB8-$8DBF-8(exterior-tiles2-116)
B $8DC0 #UDGARRAY1,7,4,1;$8DC0-$8DC7-8(exterior-tiles2-117)
B $8DC8 #UDGARRAY1,7,4,1;$8DC8-$8DCF-8(exterior-tiles2-118)
B $8DD0 #UDGARRAY1,7,4,1;$8DD0-$8DD7-8(exterior-tiles2-119)
B $8DD8 #UDGARRAY1,7,4,1;$8DD8-$8DDF-8(exterior-tiles2-120)
B $8DE0 #UDGARRAY1,7,4,1;$8DE0-$8DE7-8(exterior-tiles2-121)
B $8DE8 #UDGARRAY1,7,4,1;$8DE8-$8DEF-8(exterior-tiles2-122)
B $8DF0 #UDGARRAY1,7,4,1;$8DF0-$8DF7-8(exterior-tiles2-123)
B $8DF8 #UDGARRAY1,7,4,1;$8DF8-$8DFF-8(exterior-tiles2-124)
B $8E00 #UDGARRAY1,7,4,1;$8E00-$8E07-8(exterior-tiles2-125)
B $8E08 #UDGARRAY1,7,4,1;$8E08-$8E0F-8(exterior-tiles2-126)
B $8E10 #UDGARRAY1,7,4,1;$8E10-$8E17-8(exterior-tiles2-127)
B $8E18 #UDGARRAY1,7,4,1;$8E18-$8E1F-8(exterior-tiles2-128)
B $8E20 #UDGARRAY1,7,4,1;$8E20-$8E27-8(exterior-tiles2-129)
B $8E28 #UDGARRAY1,7,4,1;$8E28-$8E2F-8(exterior-tiles2-130)
B $8E30 #UDGARRAY1,7,4,1;$8E30-$8E37-8(exterior-tiles2-131)
B $8E38 #UDGARRAY1,7,4,1;$8E38-$8E3F-8(exterior-tiles2-132)
B $8E40 #UDGARRAY1,7,4,1;$8E40-$8E47-8(exterior-tiles2-133)
B $8E48 #UDGARRAY1,7,4,1;$8E48-$8E4F-8(exterior-tiles2-134)
B $8E50 #UDGARRAY1,7,4,1;$8E50-$8E57-8(exterior-tiles2-135)
B $8E58 #UDGARRAY1,7,4,1;$8E58-$8E5F-8(exterior-tiles2-136)
B $8E60 #UDGARRAY1,7,4,1;$8E60-$8E67-8(exterior-tiles2-137)
B $8E68 #UDGARRAY1,7,4,1;$8E68-$8E6F-8(exterior-tiles2-138)
B $8E70 #UDGARRAY1,7,4,1;$8E70-$8E77-8(exterior-tiles2-139)
B $8E78 #UDGARRAY1,7,4,1;$8E78-$8E7F-8(exterior-tiles2-140)
B $8E80 #UDGARRAY1,7,4,1;$8E80-$8E87-8(exterior-tiles2-141)
B $8E88 #UDGARRAY1,7,4,1;$8E88-$8E8F-8(exterior-tiles2-142)
B $8E90 #UDGARRAY1,7,4,1;$8E90-$8E97-8(exterior-tiles2-143)
B $8E98 #UDGARRAY1,7,4,1;$8E98-$8E9F-8(exterior-tiles2-144)
B $8EA0 #UDGARRAY1,7,4,1;$8EA0-$8EA7-8(exterior-tiles2-145)
B $8EA8 #UDGARRAY1,7,4,1;$8EA8-$8EAF-8(exterior-tiles2-146)
B $8EB0 #UDGARRAY1,7,4,1;$8EB0-$8EB7-8(exterior-tiles2-147)
B $8EB8 #UDGARRAY1,7,4,1;$8EB8-$8EBF-8(exterior-tiles2-148)
B $8EC0 #UDGARRAY1,7,4,1;$8EC0-$8EC7-8(exterior-tiles2-149)
B $8EC8 #UDGARRAY1,7,4,1;$8EC8-$8ECF-8(exterior-tiles2-150)
B $8ED0 #UDGARRAY1,7,4,1;$8ED0-$8ED7-8(exterior-tiles2-151)
B $8ED8 #UDGARRAY1,7,4,1;$8ED8-$8EDF-8(exterior-tiles2-152)
B $8EE0 #UDGARRAY1,7,4,1;$8EE0-$8EE7-8(exterior-tiles2-153)
B $8EE8 #UDGARRAY1,7,4,1;$8EE8-$8EEF-8(exterior-tiles2-154)
B $8EF0 #UDGARRAY1,7,4,1;$8EF0-$8EF7-8(exterior-tiles2-155)
B $8EF8 #UDGARRAY1,7,4,1;$8EF8-$8EFF-8(exterior-tiles2-156)
B $8F00 #UDGARRAY1,7,4,1;$8F00-$8F07-8(exterior-tiles2-157)
B $8F08 #UDGARRAY1,7,4,1;$8F08-$8F0F-8(exterior-tiles2-158)
B $8F10 #UDGARRAY1,7,4,1;$8F10-$8F17-8(exterior-tiles2-159)
B $8F18 #UDGARRAY1,7,4,1;$8F18-$8F1F-8(exterior-tiles2-160)
B $8F20 #UDGARRAY1,7,4,1;$8F20-$8F27-8(exterior-tiles2-161)
B $8F28 #UDGARRAY1,7,4,1;$8F28-$8F2F-8(exterior-tiles2-162)
B $8F30 #UDGARRAY1,7,4,1;$8F30-$8F37-8(exterior-tiles2-163)
B $8F38 #UDGARRAY1,7,4,1;$8F38-$8F3F-8(exterior-tiles2-164)
B $8F40 #UDGARRAY1,7,4,1;$8F40-$8F47-8(exterior-tiles2-165)
B $8F48 #UDGARRAY1,7,4,1;$8F48-$8F4F-8(exterior-tiles2-166)
B $8F50 #UDGARRAY1,7,4,1;$8F50-$8F57-8(exterior-tiles2-167)
B $8F58 #UDGARRAY1,7,4,1;$8F58-$8F5F-8(exterior-tiles2-168)
B $8F60 #UDGARRAY1,7,4,1;$8F60-$8F67-8(exterior-tiles2-169)
B $8F68 #UDGARRAY1,7,4,1;$8F68-$8F6F-8(exterior-tiles2-170)
B $8F70 #UDGARRAY1,7,4,1;$8F70-$8F77-8(exterior-tiles2-171)
B $8F78 #UDGARRAY1,7,4,1;$8F78-$8F7F-8(exterior-tiles2-172)
B $8F80 #UDGARRAY1,7,4,1;$8F80-$8F87-8(exterior-tiles2-173)
B $8F88 #UDGARRAY1,7,4,1;$8F88-$8F8F-8(exterior-tiles2-174)
B $8F90 #UDGARRAY1,7,4,1;$8F90-$8F97-8(exterior-tiles2-175)
B $8F98 #UDGARRAY1,7,4,1;$8F98-$8F9F-8(exterior-tiles2-176)
B $8FA0 #UDGARRAY1,7,4,1;$8FA0-$8FA7-8(exterior-tiles2-177)
B $8FA8 #UDGARRAY1,7,4,1;$8FA8-$8FAF-8(exterior-tiles2-178)
B $8FB0 #UDGARRAY1,7,4,1;$8FB0-$8FB7-8(exterior-tiles2-179)
B $8FB8 #UDGARRAY1,7,4,1;$8FB8-$8FBF-8(exterior-tiles2-180)
B $8FC0 #UDGARRAY1,7,4,1;$8FC0-$8FC7-8(exterior-tiles2-181)
B $8FC8 #UDGARRAY1,7,4,1;$8FC8-$8FCF-8(exterior-tiles2-182)
B $8FD0 #UDGARRAY1,7,4,1;$8FD0-$8FD7-8(exterior-tiles2-183)
B $8FD8 #UDGARRAY1,7,4,1;$8FD8-$8FDF-8(exterior-tiles2-184)
B $8FE0 #UDGARRAY1,7,4,1;$8FE0-$8FE7-8(exterior-tiles2-185)
B $8FE8 #UDGARRAY1,7,4,1;$8FE8-$8FEF-8(exterior-tiles2-186)
B $8FF0 #UDGARRAY1,7,4,1;$8FF0-$8FF7-8(exterior-tiles2-187)
B $8FF8 #UDGARRAY1,7,4,1;$8FF8-$8FFF-8(exterior-tiles2-188)
B $9000 #UDGARRAY1,7,4,1;$9000-$9007-8(exterior-tiles2-189)
B $9008 #UDGARRAY1,7,4,1;$9008-$900F-8(exterior-tiles2-190)
B $9010 #UDGARRAY1,7,4,1;$9010-$9017-8(exterior-tiles2-191)
B $9018 #UDGARRAY1,7,4,1;$9018-$901F-8(exterior-tiles2-192)
B $9020 #UDGARRAY1,7,4,1;$9020-$9027-8(exterior-tiles2-193)
B $9028 #UDGARRAY1,7,4,1;$9028-$902F-8(exterior-tiles2-194)
B $9030 #UDGARRAY1,7,4,1;$9030-$9037-8(exterior-tiles2-195)
B $9038 #UDGARRAY1,7,4,1;$9038-$903F-8(exterior-tiles2-196)
B $9040 #UDGARRAY1,7,4,1;$9040-$9047-8(exterior-tiles2-197)
B $9048 #UDGARRAY1,7,4,1;$9048-$904F-8(exterior-tiles2-198)
B $9050 #UDGARRAY1,7,4,1;$9050-$9057-8(exterior-tiles2-199)
B $9058 #UDGARRAY1,7,4,1;$9058-$905F-8(exterior-tiles2-200)
B $9060 #UDGARRAY1,7,4,1;$9060-$9067-8(exterior-tiles2-201)
B $9068 #UDGARRAY1,7,4,1;$9068-$906F-8(exterior-tiles2-202)
B $9070 #UDGARRAY1,7,4,1;$9070-$9077-8(exterior-tiles2-203)
B $9078 #UDGARRAY1,7,4,1;$9078-$907F-8(exterior-tiles2-204)
B $9080 #UDGARRAY1,7,4,1;$9080-$9087-8(exterior-tiles2-205)
B $9088 #UDGARRAY1,7,4,1;$9088-$908F-8(exterior-tiles2-206)
B $9090 #UDGARRAY1,7,4,1;$9090-$9097-8(exterior-tiles2-207)
B $9098 #UDGARRAY1,7,4,1;$9098-$909F-8(exterior-tiles2-208)
B $90A0 #UDGARRAY1,7,4,1;$90A0-$90A7-8(exterior-tiles2-209)
B $90A8 #UDGARRAY1,7,4,1;$90A8-$90AF-8(exterior-tiles2-210)
B $90B0 #UDGARRAY1,7,4,1;$90B0-$90B7-8(exterior-tiles2-211)
B $90B8 #UDGARRAY1,7,4,1;$90B8-$90BF-8(exterior-tiles2-212)
B $90C0 #UDGARRAY1,7,4,1;$90C0-$90C7-8(exterior-tiles2-213)
B $90C8 #UDGARRAY1,7,4,1;$90C8-$90CF-8(exterior-tiles2-214)
B $90D0 #UDGARRAY1,7,4,1;$90D0-$90D7-8(exterior-tiles2-215)
B $90D8 #UDGARRAY1,7,4,1;$90D8-$90DF-8(exterior-tiles2-216)
B $90E0 #UDGARRAY1,7,4,1;$90E0-$90E7-8(exterior-tiles2-217)
B $90E8 #UDGARRAY1,7,4,1;$90E8-$90EF-8(exterior-tiles2-218)
B $90F0 #UDGARRAY1,7,4,1;$90F0-$90F7-8(exterior-tiles2-219)
B $90F8 #UDGARRAY1,7,4,1;$90F8-$90FF-8(exterior-tiles3-000)
B $9100 #UDGARRAY1,7,4,1;$9100-$9107-8(exterior-tiles3-001)
B $9108 #UDGARRAY1,7,4,1;$9108-$910F-8(exterior-tiles3-002)
B $9110 #UDGARRAY1,7,4,1;$9110-$9117-8(exterior-tiles3-003)
B $9118 #UDGARRAY1,7,4,1;$9118-$911F-8(exterior-tiles3-004)
B $9120 #UDGARRAY1,7,4,1;$9120-$9127-8(exterior-tiles3-005)
B $9128 #UDGARRAY1,7,4,1;$9128-$912F-8(exterior-tiles3-006)
B $9130 #UDGARRAY1,7,4,1;$9130-$9137-8(exterior-tiles3-007)
B $9138 #UDGARRAY1,7,4,1;$9138-$913F-8(exterior-tiles3-008)
B $9140 #UDGARRAY1,7,4,1;$9140-$9147-8(exterior-tiles3-009)
B $9148 #UDGARRAY1,7,4,1;$9148-$914F-8(exterior-tiles3-010)
B $9150 #UDGARRAY1,7,4,1;$9150-$9157-8(exterior-tiles3-011)
B $9158 #UDGARRAY1,7,4,1;$9158-$915F-8(exterior-tiles3-012)
B $9160 #UDGARRAY1,7,4,1;$9160-$9167-8(exterior-tiles3-013)
B $9168 #UDGARRAY1,7,4,1;$9168-$916F-8(exterior-tiles3-014)
B $9170 #UDGARRAY1,7,4,1;$9170-$9177-8(exterior-tiles3-015)
B $9178 #UDGARRAY1,7,4,1;$9178-$917F-8(exterior-tiles3-016)
B $9180 #UDGARRAY1,7,4,1;$9180-$9187-8(exterior-tiles3-017)
B $9188 #UDGARRAY1,7,4,1;$9188-$918F-8(exterior-tiles3-018)
B $9190 #UDGARRAY1,7,4,1;$9190-$9197-8(exterior-tiles3-019)
B $9198 #UDGARRAY1,7,4,1;$9198-$919F-8(exterior-tiles3-020)
B $91A0 #UDGARRAY1,7,4,1;$91A0-$91A7-8(exterior-tiles3-021)
B $91A8 #UDGARRAY1,7,4,1;$91A8-$91AF-8(exterior-tiles3-022)
B $91B0 #UDGARRAY1,7,4,1;$91B0-$91B7-8(exterior-tiles3-023)
B $91B8 #UDGARRAY1,7,4,1;$91B8-$91BF-8(exterior-tiles3-024)
B $91C0 #UDGARRAY1,7,4,1;$91C0-$91C7-8(exterior-tiles3-025)
B $91C8 #UDGARRAY1,7,4,1;$91C8-$91CF-8(exterior-tiles3-026)
B $91D0 #UDGARRAY1,7,4,1;$91D0-$91D7-8(exterior-tiles3-027)
B $91D8 #UDGARRAY1,7,4,1;$91D8-$91DF-8(exterior-tiles3-028)
B $91E0 #UDGARRAY1,7,4,1;$91E0-$91E7-8(exterior-tiles3-029)
B $91E8 #UDGARRAY1,7,4,1;$91E8-$91EF-8(exterior-tiles3-030)
B $91F0 #UDGARRAY1,7,4,1;$91F0-$91F7-8(exterior-tiles3-031)
B $91F8 #UDGARRAY1,7,4,1;$91F8-$91FF-8(exterior-tiles3-032)
B $9200 #UDGARRAY1,7,4,1;$9200-$9207-8(exterior-tiles3-033)
B $9208 #UDGARRAY1,7,4,1;$9208-$920F-8(exterior-tiles3-034)
B $9210 #UDGARRAY1,7,4,1;$9210-$9217-8(exterior-tiles3-035)
B $9218 #UDGARRAY1,7,4,1;$9218-$921F-8(exterior-tiles3-036)
B $9220 #UDGARRAY1,7,4,1;$9220-$9227-8(exterior-tiles3-037)
B $9228 #UDGARRAY1,7,4,1;$9228-$922F-8(exterior-tiles3-038)
B $9230 #UDGARRAY1,7,4,1;$9230-$9237-8(exterior-tiles3-039)
B $9238 #UDGARRAY1,7,4,1;$9238-$923F-8(exterior-tiles3-040)
B $9240 #UDGARRAY1,7,4,1;$9240-$9247-8(exterior-tiles3-041)
B $9248 #UDGARRAY1,7,4,1;$9248-$924F-8(exterior-tiles3-042)
B $9250 #UDGARRAY1,7,4,1;$9250-$9257-8(exterior-tiles3-043)
B $9258 #UDGARRAY1,7,4,1;$9258-$925F-8(exterior-tiles3-044)
B $9260 #UDGARRAY1,7,4,1;$9260-$9267-8(exterior-tiles3-045)
B $9268 #UDGARRAY1,7,4,1;$9268-$926F-8(exterior-tiles3-046)
B $9270 #UDGARRAY1,7,4,1;$9270-$9277-8(exterior-tiles3-047)
B $9278 #UDGARRAY1,7,4,1;$9278-$927F-8(exterior-tiles3-048)
B $9280 #UDGARRAY1,7,4,1;$9280-$9287-8(exterior-tiles3-049)
B $9288 #UDGARRAY1,7,4,1;$9288-$928F-8(exterior-tiles3-050)
B $9290 #UDGARRAY1,7,4,1;$9290-$9297-8(exterior-tiles3-051)
B $9298 #UDGARRAY1,7,4,1;$9298-$929F-8(exterior-tiles3-052)
B $92A0 #UDGARRAY1,7,4,1;$92A0-$92A7-8(exterior-tiles3-053)
B $92A8 #UDGARRAY1,7,4,1;$92A8-$92AF-8(exterior-tiles3-054)
B $92B0 #UDGARRAY1,7,4,1;$92B0-$92B7-8(exterior-tiles3-055)
B $92B8 #UDGARRAY1,7,4,1;$92B8-$92BF-8(exterior-tiles3-056)
B $92C0 #UDGARRAY1,7,4,1;$92C0-$92C7-8(exterior-tiles3-057)
B $92C8 #UDGARRAY1,7,4,1;$92C8-$92CF-8(exterior-tiles3-058)
B $92D0 #UDGARRAY1,7,4,1;$92D0-$92D7-8(exterior-tiles3-059)
B $92D8 #UDGARRAY1,7,4,1;$92D8-$92DF-8(exterior-tiles3-060)
B $92E0 #UDGARRAY1,7,4,1;$92E0-$92E7-8(exterior-tiles3-061)
B $92E8 #UDGARRAY1,7,4,1;$92E8-$92EF-8(exterior-tiles3-062)
B $92F0 #UDGARRAY1,7,4,1;$92F0-$92F7-8(exterior-tiles3-063)
B $92F8 #UDGARRAY1,7,4,1;$92F8-$92FF-8(exterior-tiles3-064)
B $9300 #UDGARRAY1,7,4,1;$9300-$9307-8(exterior-tiles3-065)
B $9308 #UDGARRAY1,7,4,1;$9308-$930F-8(exterior-tiles3-066)
B $9310 #UDGARRAY1,7,4,1;$9310-$9317-8(exterior-tiles3-067)
B $9318 #UDGARRAY1,7,4,1;$9318-$931F-8(exterior-tiles3-068)
B $9320 #UDGARRAY1,7,4,1;$9320-$9327-8(exterior-tiles3-069)
B $9328 #UDGARRAY1,7,4,1;$9328-$932F-8(exterior-tiles3-070)
B $9330 #UDGARRAY1,7,4,1;$9330-$9337-8(exterior-tiles3-071)
B $9338 #UDGARRAY1,7,4,1;$9338-$933F-8(exterior-tiles3-072)
B $9340 #UDGARRAY1,7,4,1;$9340-$9347-8(exterior-tiles3-073)
B $9348 #UDGARRAY1,7,4,1;$9348-$934F-8(exterior-tiles3-074)
B $9350 #UDGARRAY1,7,4,1;$9350-$9357-8(exterior-tiles3-075)
B $9358 #UDGARRAY1,7,4,1;$9358-$935F-8(exterior-tiles3-076)
B $9360 #UDGARRAY1,7,4,1;$9360-$9367-8(exterior-tiles3-077)
B $9368 #UDGARRAY1,7,4,1;$9368-$936F-8(exterior-tiles3-078)
B $9370 #UDGARRAY1,7,4,1;$9370-$9377-8(exterior-tiles3-079)
B $9378 #UDGARRAY1,7,4,1;$9378-$937F-8(exterior-tiles3-080)
B $9380 #UDGARRAY1,7,4,1;$9380-$9387-8(exterior-tiles3-081)
B $9388 #UDGARRAY1,7,4,1;$9388-$938F-8(exterior-tiles3-082)
B $9390 #UDGARRAY1,7,4,1;$9390-$9397-8(exterior-tiles3-083)
B $9398 #UDGARRAY1,7,4,1;$9398-$939F-8(exterior-tiles3-084)
B $93A0 #UDGARRAY1,7,4,1;$93A0-$93A7-8(exterior-tiles3-085)
B $93A8 #UDGARRAY1,7,4,1;$93A8-$93AF-8(exterior-tiles3-086)
B $93B0 #UDGARRAY1,7,4,1;$93B0-$93B7-8(exterior-tiles3-087)
B $93B8 #UDGARRAY1,7,4,1;$93B8-$93BF-8(exterior-tiles3-088)
B $93C0 #UDGARRAY1,7,4,1;$93C0-$93C7-8(exterior-tiles3-089)
B $93C8 #UDGARRAY1,7,4,1;$93C8-$93CF-8(exterior-tiles3-090)
B $93D0 #UDGARRAY1,7,4,1;$93D0-$93D7-8(exterior-tiles3-091)
B $93D8 #UDGARRAY1,7,4,1;$93D8-$93DF-8(exterior-tiles3-092)
B $93E0 #UDGARRAY1,7,4,1;$93E0-$93E7-8(exterior-tiles3-093)
B $93E8 #UDGARRAY1,7,4,1;$93E8-$93EF-8(exterior-tiles3-094)
B $93F0 #UDGARRAY1,7,4,1;$93F0-$93F7-8(exterior-tiles3-095)
B $93F8 #UDGARRAY1,7,4,1;$93F8-$93FF-8(exterior-tiles3-096)
B $9400 #UDGARRAY1,7,4,1;$9400-$9407-8(exterior-tiles3-097)
B $9408 #UDGARRAY1,7,4,1;$9408-$940F-8(exterior-tiles3-098)
B $9410 #UDGARRAY1,7,4,1;$9410-$9417-8(exterior-tiles3-099)
B $9418 #UDGARRAY1,7,4,1;$9418-$941F-8(exterior-tiles3-100)
B $9420 #UDGARRAY1,7,4,1;$9420-$9427-8(exterior-tiles3-101)
B $9428 #UDGARRAY1,7,4,1;$9428-$942F-8(exterior-tiles3-102)
B $9430 #UDGARRAY1,7,4,1;$9430-$9437-8(exterior-tiles3-103)
B $9438 #UDGARRAY1,7,4,1;$9438-$943F-8(exterior-tiles3-104)
B $9440 #UDGARRAY1,7,4,1;$9440-$9447-8(exterior-tiles3-105)
B $9448 #UDGARRAY1,7,4,1;$9448-$944F-8(exterior-tiles3-106)
B $9450 #UDGARRAY1,7,4,1;$9450-$9457-8(exterior-tiles3-107)
B $9458 #UDGARRAY1,7,4,1;$9458-$945F-8(exterior-tiles3-108)
B $9460 #UDGARRAY1,7,4,1;$9460-$9467-8(exterior-tiles3-109)
B $9468 #UDGARRAY1,7,4,1;$9468-$946F-8(exterior-tiles3-110)
B $9470 #UDGARRAY1,7,4,1;$9470-$9477-8(exterior-tiles3-111)
B $9478 #UDGARRAY1,7,4,1;$9478-$947F-8(exterior-tiles3-112)
B $9480 #UDGARRAY1,7,4,1;$9480-$9487-8(exterior-tiles3-113)
B $9488 #UDGARRAY1,7,4,1;$9488-$948F-8(exterior-tiles3-114)
B $9490 #UDGARRAY1,7,4,1;$9490-$9497-8(exterior-tiles3-115)
B $9498 #UDGARRAY1,7,4,1;$9498-$949F-8(exterior-tiles3-116)
B $94A0 #UDGARRAY1,7,4,1;$94A0-$94A7-8(exterior-tiles3-117)
B $94A8 #UDGARRAY1,7,4,1;$94A8-$94AF-8(exterior-tiles3-118)
B $94B0 #UDGARRAY1,7,4,1;$94B0-$94B7-8(exterior-tiles3-119)
B $94B8 #UDGARRAY1,7,4,1;$94B8-$94BF-8(exterior-tiles3-120)
B $94C0 #UDGARRAY1,7,4,1;$94C0-$94C7-8(exterior-tiles3-121)
B $94C8 #UDGARRAY1,7,4,1;$94C8-$94CF-8(exterior-tiles3-122)
B $94D0 #UDGARRAY1,7,4,1;$94D0-$94D7-8(exterior-tiles3-123)
B $94D8 #UDGARRAY1,7,4,1;$94D8-$94DF-8(exterior-tiles3-124)
B $94E0 #UDGARRAY1,7,4,1;$94E0-$94E7-8(exterior-tiles3-125)
B $94E8 #UDGARRAY1,7,4,1;$94E8-$94EF-8(exterior-tiles3-126)
B $94F0 #UDGARRAY1,7,4,1;$94F0-$94F7-8(exterior-tiles3-127)
B $94F8 #UDGARRAY1,7,4,1;$94F8-$94FF-8(exterior-tiles3-128)
B $9500 #UDGARRAY1,7,4,1;$9500-$9507-8(exterior-tiles3-129)
B $9508 #UDGARRAY1,7,4,1;$9508-$950F-8(exterior-tiles3-130)
B $9510 #UDGARRAY1,7,4,1;$9510-$9517-8(exterior-tiles3-131)
B $9518 #UDGARRAY1,7,4,1;$9518-$951F-8(exterior-tiles3-132)
B $9520 #UDGARRAY1,7,4,1;$9520-$9527-8(exterior-tiles3-133)
B $9528 #UDGARRAY1,7,4,1;$9528-$952F-8(exterior-tiles3-134)
B $9530 #UDGARRAY1,7,4,1;$9530-$9537-8(exterior-tiles3-135)
B $9538 #UDGARRAY1,7,4,1;$9538-$953F-8(exterior-tiles3-136)
B $9540 #UDGARRAY1,7,4,1;$9540-$9547-8(exterior-tiles3-137)
B $9548 #UDGARRAY1,7,4,1;$9548-$954F-8(exterior-tiles3-138)
B $9550 #UDGARRAY1,7,4,1;$9550-$9557-8(exterior-tiles3-139)
B $9558 #UDGARRAY1,7,4,1;$9558-$955F-8(exterior-tiles3-140)
B $9560 #UDGARRAY1,7,4,1;$9560-$9567-8(exterior-tiles3-141)
B $9568 #UDGARRAY1,7,4,1;$9568-$956F-8(exterior-tiles3-142)
B $9570 #UDGARRAY1,7,4,1;$9570-$9577-8(exterior-tiles3-143)
B $9578 #UDGARRAY1,7,4,1;$9578-$957F-8(exterior-tiles3-144)
B $9580 #UDGARRAY1,7,4,1;$9580-$9587-8(exterior-tiles3-145)
B $9588 #UDGARRAY1,7,4,1;$9588-$958F-8(exterior-tiles3-146)
B $9590 #UDGARRAY1,7,4,1;$9590-$9597-8(exterior-tiles3-147)
B $9598 #UDGARRAY1,7,4,1;$9598-$959F-8(exterior-tiles3-148)
B $95A0 #UDGARRAY1,7,4,1;$95A0-$95A7-8(exterior-tiles3-149)
B $95A8 #UDGARRAY1,7,4,1;$95A8-$95AF-8(exterior-tiles3-150)
B $95B0 #UDGARRAY1,7,4,1;$95B0-$95B7-8(exterior-tiles3-151)
B $95B8 #UDGARRAY1,7,4,1;$95B8-$95BF-8(exterior-tiles3-152)
B $95C0 #UDGARRAY1,7,4,1;$95C0-$95C7-8(exterior-tiles3-153)
B $95C8 #UDGARRAY1,7,4,1;$95C8-$95CF-8(exterior-tiles3-154)
B $95D0 #UDGARRAY1,7,4,1;$95D0-$95D7-8(exterior-tiles3-155)
B $95D8 #UDGARRAY1,7,4,1;$95D8-$95DF-8(exterior-tiles3-156)
B $95E0 #UDGARRAY1,7,4,1;$95E0-$95E7-8(exterior-tiles3-157)
B $95E8 #UDGARRAY1,7,4,1;$95E8-$95EF-8(exterior-tiles3-158)
B $95F0 #UDGARRAY1,7,4,1;$95F0-$95F7-8(exterior-tiles3-159)
B $95F8 #UDGARRAY1,7,4,1;$95F8-$95FF-8(exterior-tiles3-160)
B $9600 #UDGARRAY1,7,4,1;$9600-$9607-8(exterior-tiles3-161)
B $9608 #UDGARRAY1,7,4,1;$9608-$960F-8(exterior-tiles3-162)
B $9610 #UDGARRAY1,7,4,1;$9610-$9617-8(exterior-tiles3-163)
B $9618 #UDGARRAY1,7,4,1;$9618-$961F-8(exterior-tiles3-164)
B $9620 #UDGARRAY1,7,4,1;$9620-$9627-8(exterior-tiles3-165)
B $9628 #UDGARRAY1,7,4,1;$9628-$962F-8(exterior-tiles3-166)
B $9630 #UDGARRAY1,7,4,1;$9630-$9637-8(exterior-tiles3-167)
B $9638 #UDGARRAY1,7,4,1;$9638-$963F-8(exterior-tiles3-168)
B $9640 #UDGARRAY1,7,4,1;$9640-$9647-8(exterior-tiles3-169)
B $9648 #UDGARRAY1,7,4,1;$9648-$964F-8(exterior-tiles3-170)
B $9650 #UDGARRAY1,7,4,1;$9650-$9657-8(exterior-tiles3-171)
B $9658 #UDGARRAY1,7,4,1;$9658-$965F-8(exterior-tiles3-172)
B $9660 #UDGARRAY1,7,4,1;$9660-$9667-8(exterior-tiles3-173)
B $9668 #UDGARRAY1,7,4,1;$9668-$966F-8(exterior-tiles3-174)
B $9670 #UDGARRAY1,7,4,1;$9670-$9677-8(exterior-tiles3-175)
B $9678 #UDGARRAY1,7,4,1;$9678-$967F-8(exterior-tiles3-176)
B $9680 #UDGARRAY1,7,4,1;$9680-$9687-8(exterior-tiles3-177)
B $9688 #UDGARRAY1,7,4,1;$9688-$968F-8(exterior-tiles3-178)
B $9690 #UDGARRAY1,7,4,1;$9690-$9697-8(exterior-tiles3-179)
B $9698 #UDGARRAY1,7,4,1;$9698-$969F-8(exterior-tiles3-180)
B $96A0 #UDGARRAY1,7,4,1;$96A0-$96A7-8(exterior-tiles3-181)
B $96A8 #UDGARRAY1,7,4,1;$96A8-$96AF-8(exterior-tiles3-182)
B $96B0 #UDGARRAY1,7,4,1;$96B0-$96B7-8(exterior-tiles3-183)
B $96B8 #UDGARRAY1,7,4,1;$96B8-$96BF-8(exterior-tiles3-184)
B $96C0 #UDGARRAY1,7,4,1;$96C0-$96C7-8(exterior-tiles3-185)
B $96C8 #UDGARRAY1,7,4,1;$96C8-$96CF-8(exterior-tiles3-186)
B $96D0 #UDGARRAY1,7,4,1;$96D0-$96D7-8(exterior-tiles3-187)
B $96D8 #UDGARRAY1,7,4,1;$96D8-$96DF-8(exterior-tiles3-188)
B $96E0 #UDGARRAY1,7,4,1;$96E0-$96E7-8(exterior-tiles3-189)
B $96E8 #UDGARRAY1,7,4,1;$96E8-$96EF-8(exterior-tiles3-190)
B $96F0 #UDGARRAY1,7,4,1;$96F0-$96F7-8(exterior-tiles3-191)
B $96F8 #UDGARRAY1,7,4,1;$96F8-$96FF-8(exterior-tiles3-192)
B $9700 #UDGARRAY1,7,4,1;$9700-$9707-8(exterior-tiles3-193)
B $9708 #UDGARRAY1,7,4,1;$9708-$970F-8(exterior-tiles3-194)
B $9710 #UDGARRAY1,7,4,1;$9710-$9717-8(exterior-tiles3-195)
B $9718 #UDGARRAY1,7,4,1;$9718-$971F-8(exterior-tiles3-196)
B $9720 #UDGARRAY1,7,4,1;$9720-$9727-8(exterior-tiles3-197)
B $9728 #UDGARRAY1,7,4,1;$9728-$972F-8(exterior-tiles3-198)
B $9730 #UDGARRAY1,7,4,1;$9730-$9737-8(exterior-tiles3-199)
B $9738 #UDGARRAY1,7,4,1;$9738-$973F-8(exterior-tiles3-200)
B $9740 #UDGARRAY1,7,4,1;$9740-$9747-8(exterior-tiles3-201)
B $9748 #UDGARRAY1,7,4,1;$9748-$974F-8(exterior-tiles3-202)
B $9750 #UDGARRAY1,7,4,1;$9750-$9757-8(exterior-tiles3-203)
B $9758 #UDGARRAY1,7,4,1;$9758-$975F-8(exterior-tiles3-204)
B $9760 #UDGARRAY1,7,4,1;$9760-$9767-8(exterior-tiles3-205)
B $9768 #UDGARRAY1,7,4,1;$9768-$976F-8(interior-tiles-000)
B $9770 #UDGARRAY1,7,4,1;$9770-$9777-8(interior-tiles-001)
B $9778 #UDGARRAY1,7,4,1;$9778-$977F-8(interior-tiles-002)
B $9780 #UDGARRAY1,7,4,1;$9780-$9787-8(interior-tiles-003)
B $9788 #UDGARRAY1,7,4,1;$9788-$978F-8(interior-tiles-004)
B $9790 #UDGARRAY1,7,4,1;$9790-$9797-8(interior-tiles-005)
B $9798 #UDGARRAY1,7,4,1;$9798-$979F-8(interior-tiles-006)
B $97A0 #UDGARRAY1,7,4,1;$97A0-$97A7-8(interior-tiles-007)
B $97A8 #UDGARRAY1,7,4,1;$97A8-$97AF-8(interior-tiles-008)
B $97B0 #UDGARRAY1,7,4,1;$97B0-$97B7-8(interior-tiles-009)
B $97B8 #UDGARRAY1,7,4,1;$97B8-$97BF-8(interior-tiles-010)
B $97C0 #UDGARRAY1,7,4,1;$97C0-$97C7-8(interior-tiles-011)
B $97C8 #UDGARRAY1,7,4,1;$97C8-$97CF-8(interior-tiles-012)
B $97D0 #UDGARRAY1,7,4,1;$97D0-$97D7-8(interior-tiles-013)
B $97D8 #UDGARRAY1,7,4,1;$97D8-$97DF-8(interior-tiles-014)
B $97E0 #UDGARRAY1,7,4,1;$97E0-$97E7-8(interior-tiles-015)
B $97E8 #UDGARRAY1,7,4,1;$97E8-$97EF-8(interior-tiles-016)
B $97F0 #UDGARRAY1,7,4,1;$97F0-$97F7-8(interior-tiles-017)
B $97F8 #UDGARRAY1,7,4,1;$97F8-$97FF-8(interior-tiles-018)
B $9800 #UDGARRAY1,7,4,1;$9800-$9807-8(interior-tiles-019)
B $9808 #UDGARRAY1,7,4,1;$9808-$980F-8(interior-tiles-020)
B $9810 #UDGARRAY1,7,4,1;$9810-$9817-8(interior-tiles-021)
B $9818 #UDGARRAY1,7,4,1;$9818-$981F-8(interior-tiles-022)
B $9820 #UDGARRAY1,7,4,1;$9820-$9827-8(interior-tiles-023)
B $9828 #UDGARRAY1,7,4,1;$9828-$982F-8(interior-tiles-024)
B $9830 #UDGARRAY1,7,4,1;$9830-$9837-8(interior-tiles-025)
B $9838 #UDGARRAY1,7,4,1;$9838-$983F-8(interior-tiles-026)
B $9840 #UDGARRAY1,7,4,1;$9840-$9847-8(interior-tiles-027)
B $9848 #UDGARRAY1,7,4,1;$9848-$984F-8(interior-tiles-028)
B $9850 #UDGARRAY1,7,4,1;$9850-$9857-8(interior-tiles-029)
B $9858 #UDGARRAY1,7,4,1;$9858-$985F-8(interior-tiles-030)
B $9860 #UDGARRAY1,7,4,1;$9860-$9867-8(interior-tiles-031)
B $9868 #UDGARRAY1,7,4,1;$9868-$986F-8(interior-tiles-032)
B $9870 #UDGARRAY1,7,4,1;$9870-$9877-8(interior-tiles-033)
B $9878 #UDGARRAY1,7,4,1;$9878-$987F-8(interior-tiles-034)
B $9880 #UDGARRAY1,7,4,1;$9880-$9887-8(interior-tiles-035)
B $9888 #UDGARRAY1,7,4,1;$9888-$988F-8(interior-tiles-036)
B $9890 #UDGARRAY1,7,4,1;$9890-$9897-8(interior-tiles-037)
B $9898 #UDGARRAY1,7,4,1;$9898-$989F-8(interior-tiles-038)
B $98A0 #UDGARRAY1,7,4,1;$98A0-$98A7-8(interior-tiles-039)
B $98A8 #UDGARRAY1,7,4,1;$98A8-$98AF-8(interior-tiles-040)
B $98B0 #UDGARRAY1,7,4,1;$98B0-$98B7-8(interior-tiles-041)
B $98B8 #UDGARRAY1,7,4,1;$98B8-$98BF-8(interior-tiles-042)
B $98C0 #UDGARRAY1,7,4,1;$98C0-$98C7-8(interior-tiles-043)
B $98C8 #UDGARRAY1,7,4,1;$98C8-$98CF-8(interior-tiles-044)
B $98D0 #UDGARRAY1,7,4,1;$98D0-$98D7-8(interior-tiles-045)
B $98D8 #UDGARRAY1,7,4,1;$98D8-$98DF-8(interior-tiles-046)
B $98E0 #UDGARRAY1,7,4,1;$98E0-$98E7-8(interior-tiles-047)
B $98E8 #UDGARRAY1,7,4,1;$98E8-$98EF-8(interior-tiles-048)
B $98F0 #UDGARRAY1,7,4,1;$98F0-$98F7-8(interior-tiles-049)
B $98F8 #UDGARRAY1,7,4,1;$98F8-$98FF-8(interior-tiles-050)
B $9900 #UDGARRAY1,7,4,1;$9900-$9907-8(interior-tiles-051)
B $9908 #UDGARRAY1,7,4,1;$9908-$990F-8(interior-tiles-052)
B $9910 #UDGARRAY1,7,4,1;$9910-$9917-8(interior-tiles-053)
B $9918 #UDGARRAY1,7,4,1;$9918-$991F-8(interior-tiles-054)
B $9920 #UDGARRAY1,7,4,1;$9920-$9927-8(interior-tiles-055)
B $9928 #UDGARRAY1,7,4,1;$9928-$992F-8(interior-tiles-056)
B $9930 #UDGARRAY1,7,4,1;$9930-$9937-8(interior-tiles-057)
B $9938 #UDGARRAY1,7,4,1;$9938-$993F-8(interior-tiles-058)
B $9940 #UDGARRAY1,7,4,1;$9940-$9947-8(interior-tiles-059)
B $9948 #UDGARRAY1,7,4,1;$9948-$994F-8(interior-tiles-060)
B $9950 #UDGARRAY1,7,4,1;$9950-$9957-8(interior-tiles-061)
B $9958 #UDGARRAY1,7,4,1;$9958-$995F-8(interior-tiles-062)
B $9960 #UDGARRAY1,7,4,1;$9960-$9967-8(interior-tiles-063)
B $9968 #UDGARRAY1,7,4,1;$9968-$996F-8(interior-tiles-064)
B $9970 #UDGARRAY1,7,4,1;$9970-$9977-8(interior-tiles-065)
B $9978 #UDGARRAY1,7,4,1;$9978-$997F-8(interior-tiles-066)
B $9980 #UDGARRAY1,7,4,1;$9980-$9987-8(interior-tiles-067)
B $9988 #UDGARRAY1,7,4,1;$9988-$998F-8(interior-tiles-068)
B $9990 #UDGARRAY1,7,4,1;$9990-$9997-8(interior-tiles-069)
B $9998 #UDGARRAY1,7,4,1;$9998-$999F-8(interior-tiles-070)
B $99A0 #UDGARRAY1,7,4,1;$99A0-$99A7-8(interior-tiles-071)
B $99A8 #UDGARRAY1,7,4,1;$99A8-$99AF-8(interior-tiles-072)
B $99B0 #UDGARRAY1,7,4,1;$99B0-$99B7-8(interior-tiles-073)
B $99B8 #UDGARRAY1,7,4,1;$99B8-$99BF-8(interior-tiles-074)
B $99C0 #UDGARRAY1,7,4,1;$99C0-$99C7-8(interior-tiles-075)
B $99C8 #UDGARRAY1,7,4,1;$99C8-$99CF-8(interior-tiles-076)
B $99D0 #UDGARRAY1,7,4,1;$99D0-$99D7-8(interior-tiles-077)
B $99D8 #UDGARRAY1,7,4,1;$99D8-$99DF-8(interior-tiles-078)
B $99E0 #UDGARRAY1,7,4,1;$99E0-$99E7-8(interior-tiles-079)
B $99E8 #UDGARRAY1,7,4,1;$99E8-$99EF-8(interior-tiles-080)
B $99F0 #UDGARRAY1,7,4,1;$99F0-$99F7-8(interior-tiles-081)
B $99F8 #UDGARRAY1,7,4,1;$99F8-$99FF-8(interior-tiles-082)
B $9A00 #UDGARRAY1,7,4,1;$9A00-$9A07-8(interior-tiles-083)
B $9A08 #UDGARRAY1,7,4,1;$9A08-$9A0F-8(interior-tiles-084)
B $9A10 #UDGARRAY1,7,4,1;$9A10-$9A17-8(interior-tiles-085)
B $9A18 #UDGARRAY1,7,4,1;$9A18-$9A1F-8(interior-tiles-086)
B $9A20 #UDGARRAY1,7,4,1;$9A20-$9A27-8(interior-tiles-087)
B $9A28 #UDGARRAY1,7,4,1;$9A28-$9A2F-8(interior-tiles-088)
B $9A30 #UDGARRAY1,7,4,1;$9A30-$9A37-8(interior-tiles-089)
B $9A38 #UDGARRAY1,7,4,1;$9A38-$9A3F-8(interior-tiles-090)
B $9A40 #UDGARRAY1,7,4,1;$9A40-$9A47-8(interior-tiles-091)
B $9A48 #UDGARRAY1,7,4,1;$9A48-$9A4F-8(interior-tiles-092)
B $9A50 #UDGARRAY1,7,4,1;$9A50-$9A57-8(interior-tiles-093)
B $9A58 #UDGARRAY1,7,4,1;$9A58-$9A5F-8(interior-tiles-094)
B $9A60 #UDGARRAY1,7,4,1;$9A60-$9A67-8(interior-tiles-095)
B $9A68 #UDGARRAY1,7,4,1;$9A68-$9A6F-8(interior-tiles-096)
B $9A70 #UDGARRAY1,7,4,1;$9A70-$9A77-8(interior-tiles-097)
B $9A78 #UDGARRAY1,7,4,1;$9A78-$9A7F-8(interior-tiles-098)
B $9A80 #UDGARRAY1,7,4,1;$9A80-$9A87-8(interior-tiles-099)
B $9A88 #UDGARRAY1,7,4,1;$9A88-$9A8F-8(interior-tiles-100)
B $9A90 #UDGARRAY1,7,4,1;$9A90-$9A97-8(interior-tiles-101)
B $9A98 #UDGARRAY1,7,4,1;$9A98-$9A9F-8(interior-tiles-102)
B $9AA0 #UDGARRAY1,7,4,1;$9AA0-$9AA7-8(interior-tiles-103)
B $9AA8 #UDGARRAY1,7,4,1;$9AA8-$9AAF-8(interior-tiles-104)
B $9AB0 #UDGARRAY1,7,4,1;$9AB0-$9AB7-8(interior-tiles-105)
B $9AB8 #UDGARRAY1,7,4,1;$9AB8-$9ABF-8(interior-tiles-106)
B $9AC0 #UDGARRAY1,7,4,1;$9AC0-$9AC7-8(interior-tiles-107)
B $9AC8 #UDGARRAY1,7,4,1;$9AC8-$9ACF-8(interior-tiles-108)
B $9AD0 #UDGARRAY1,7,4,1;$9AD0-$9AD7-8(interior-tiles-109)
B $9AD8 #UDGARRAY1,7,4,1;$9AD8-$9ADF-8(interior-tiles-110)
B $9AE0 #UDGARRAY1,7,4,1;$9AE0-$9AE7-8(interior-tiles-111)
B $9AE8 #UDGARRAY1,7,4,1;$9AE8-$9AEF-8(interior-tiles-112)
B $9AF0 #UDGARRAY1,7,4,1;$9AF0-$9AF7-8(interior-tiles-113)
B $9AF8 #UDGARRAY1,7,4,1;$9AF8-$9AFF-8(interior-tiles-114)
B $9B00 #UDGARRAY1,7,4,1;$9B00-$9B07-8(interior-tiles-115)
B $9B08 #UDGARRAY1,7,4,1;$9B08-$9B0F-8(interior-tiles-116)
B $9B10 #UDGARRAY1,7,4,1;$9B10-$9B17-8(interior-tiles-117)
B $9B18 #UDGARRAY1,7,4,1;$9B18-$9B1F-8(interior-tiles-118)
B $9B20 #UDGARRAY1,7,4,1;$9B20-$9B27-8(interior-tiles-119)
B $9B28 #UDGARRAY1,7,4,1;$9B28-$9B2F-8(interior-tiles-120)
B $9B30 #UDGARRAY1,7,4,1;$9B30-$9B37-8(interior-tiles-121)
B $9B38 #UDGARRAY1,7,4,1;$9B38-$9B3F-8(interior-tiles-122)
B $9B40 #UDGARRAY1,7,4,1;$9B40-$9B47-8(interior-tiles-123)
B $9B48 #UDGARRAY1,7,4,1;$9B48-$9B4F-8(interior-tiles-124)
B $9B50 #UDGARRAY1,7,4,1;$9B50-$9B57-8(interior-tiles-125)
B $9B58 #UDGARRAY1,7,4,1;$9B58-$9B5F-8(interior-tiles-126)
B $9B60 #UDGARRAY1,7,4,1;$9B60-$9B67-8(interior-tiles-127)
B $9B68 #UDGARRAY1,7,4,1;$9B68-$9B6F-8(interior-tiles-128)
B $9B70 #UDGARRAY1,7,4,1;$9B70-$9B77-8(interior-tiles-129)
B $9B78 #UDGARRAY1,7,4,1;$9B78-$9B7F-8(interior-tiles-130)
B $9B80 #UDGARRAY1,7,4,1;$9B80-$9B87-8(interior-tiles-131)
B $9B88 #UDGARRAY1,7,4,1;$9B88-$9B8F-8(interior-tiles-132)
B $9B90 #UDGARRAY1,7,4,1;$9B90-$9B97-8(interior-tiles-133)
B $9B98 #UDGARRAY1,7,4,1;$9B98-$9B9F-8(interior-tiles-134)
B $9BA0 #UDGARRAY1,7,4,1;$9BA0-$9BA7-8(interior-tiles-135)
B $9BA8 #UDGARRAY1,7,4,1;$9BA8-$9BAF-8(interior-tiles-136)
B $9BB0 #UDGARRAY1,7,4,1;$9BB0-$9BB7-8(interior-tiles-137)
B $9BB8 #UDGARRAY1,7,4,1;$9BB8-$9BBF-8(interior-tiles-138)
B $9BC0 #UDGARRAY1,7,4,1;$9BC0-$9BC7-8(interior-tiles-139)
B $9BC8 #UDGARRAY1,7,4,1;$9BC8-$9BCF-8(interior-tiles-140)
B $9BD0 #UDGARRAY1,7,4,1;$9BD0-$9BD7-8(interior-tiles-141)
B $9BD8 #UDGARRAY1,7,4,1;$9BD8-$9BDF-8(interior-tiles-142)
B $9BE0 #UDGARRAY1,7,4,1;$9BE0-$9BE7-8(interior-tiles-143)
B $9BE8 #UDGARRAY1,7,4,1;$9BE8-$9BEF-8(interior-tiles-144)
B $9BF0 #UDGARRAY1,7,4,1;$9BF0-$9BF7-8(interior-tiles-145)
B $9BF8 #UDGARRAY1,7,4,1;$9BF8-$9BFF-8(interior-tiles-146)
B $9C00 #UDGARRAY1,7,4,1;$9C00-$9C07-8(interior-tiles-147)
B $9C08 #UDGARRAY1,7,4,1;$9C08-$9C0F-8(interior-tiles-148)
B $9C10 #UDGARRAY1,7,4,1;$9C10-$9C17-8(interior-tiles-149)
B $9C18 #UDGARRAY1,7,4,1;$9C18-$9C1F-8(interior-tiles-150)
B $9C20 #UDGARRAY1,7,4,1;$9C20-$9C27-8(interior-tiles-151)
B $9C28 #UDGARRAY1,7,4,1;$9C28-$9C2F-8(interior-tiles-152)
B $9C30 #UDGARRAY1,7,4,1;$9C30-$9C37-8(interior-tiles-153)
B $9C38 #UDGARRAY1,7,4,1;$9C38-$9C3F-8(interior-tiles-154)
B $9C40 #UDGARRAY1,7,4,1;$9C40-$9C47-8(interior-tiles-155)
B $9C48 #UDGARRAY1,7,4,1;$9C48-$9C4F-8(interior-tiles-156)
B $9C50 #UDGARRAY1,7,4,1;$9C50-$9C57-8(interior-tiles-157)
B $9C58 #UDGARRAY1,7,4,1;$9C58-$9C5F-8(interior-tiles-158)
B $9C60 #UDGARRAY1,7,4,1;$9C60-$9C67-8(interior-tiles-159)
B $9C68 #UDGARRAY1,7,4,1;$9C68-$9C6F-8(interior-tiles-160)
B $9C70 #UDGARRAY1,7,4,1;$9C70-$9C77-8(interior-tiles-161)
B $9C78 #UDGARRAY1,7,4,1;$9C78-$9C7F-8(interior-tiles-162)
B $9C80 #UDGARRAY1,7,4,1;$9C80-$9C87-8(interior-tiles-163)
B $9C88 #UDGARRAY1,7,4,1;$9C88-$9C8F-8(interior-tiles-164)
B $9C90 #UDGARRAY1,7,4,1;$9C90-$9C97-8(interior-tiles-165)
B $9C98 #UDGARRAY1,7,4,1;$9C98-$9C9F-8(interior-tiles-166)
B $9CA0 #UDGARRAY1,7,4,1;$9CA0-$9CA7-8(interior-tiles-167)
B $9CA8 #UDGARRAY1,7,4,1;$9CA8-$9CAF-8(interior-tiles-168)
B $9CB0 #UDGARRAY1,7,4,1;$9CB0-$9CB7-8(interior-tiles-169)
B $9CB8 #UDGARRAY1,7,4,1;$9CB8-$9CBF-8(interior-tiles-170)
B $9CC0 #UDGARRAY1,7,4,1;$9CC0-$9CC7-8(interior-tiles-171)
B $9CC8 #UDGARRAY1,7,4,1;$9CC8-$9CCF-8(interior-tiles-172)
B $9CD0 #UDGARRAY1,7,4,1;$9CD0-$9CD7-8(interior-tiles-173)
B $9CD8 #UDGARRAY1,7,4,1;$9CD8-$9CDF-8(interior-tiles-174)
B $9CE0 #UDGARRAY1,7,4,1;$9CE0-$9CE7-8(interior-tiles-175)
B $9CE8 #UDGARRAY1,7,4,1;$9CE8-$9CEF-8(interior-tiles-176)
B $9CF0 #UDGARRAY1,7,4,1;$9CF0-$9CF7-8(interior-tiles-177)
B $9CF8 #UDGARRAY1,7,4,1;$9CF8-$9CFF-8(interior-tiles-178)
B $9D00 #UDGARRAY1,7,4,1;$9D00-$9D07-8(interior-tiles-179)
B $9D08 #UDGARRAY1,7,4,1;$9D08-$9D0F-8(interior-tiles-180)
B $9D10 #UDGARRAY1,7,4,1;$9D10-$9D17-8(interior-tiles-181)
B $9D18 #UDGARRAY1,7,4,1;$9D18-$9D1F-8(interior-tiles-182)
B $9D20 #UDGARRAY1,7,4,1;$9D20-$9D27-8(interior-tiles-183)
B $9D28 #UDGARRAY1,7,4,1;$9D28-$9D2F-8(interior-tiles-184)
B $9D30 #UDGARRAY1,7,4,1;$9D30-$9D37-8(interior-tiles-185)
B $9D38 #UDGARRAY1,7,4,1;$9D38-$9D3F-8(interior-tiles-186)
B $9D40 #UDGARRAY1,7,4,1;$9D40-$9D47-8(interior-tiles-187)
B $9D48 #UDGARRAY1,7,4,1;$9D48-$9D4F-8(interior-tiles-188)
B $9D50 #UDGARRAY1,7,4,1;$9D50-$9D57-8(interior-tiles-189)
B $9D58 #UDGARRAY1,7,4,1;$9D58-$9D5F-8(interior-tiles-190)
B $9D60 #UDGARRAY1,7,4,1;$9D60-$9D67-8(interior-tiles-191)
B $9D68 #UDGARRAY1,7,4,1;$9D68-$9D6F-8(interior-tiles-192)
B $9D70 #UDGARRAY1,7,4,1;$9D70-$9D77-8(interior-tiles-193)

; ------------------------------------------------------------------------------

c $9D78 main_loop_setup
D $9D78 There seems to be litle point in this: enter_room terminates with 'goto main_loop' so it never returns. In fact, the single caller might just as well goto enter_room instead of goto main_loop_setup.
  $9D78 enter_room(); // returns by goto main_loop

  $9D7B main_loop: for (;;) { check_morale();
  $9D7E   keyscan_cancel();
  $9D81   message_display();
  $9D84   process_player_input();
  $9D87   in_permitted_area();
  $9D8A   called_from_main_loop_3(); // [unknown]
  $9D8D   move_characters();
  $9D90   follow_suspicious_player();
  $9D93   called_from_main_loop_6(); // [unknown]
  $9D96   called_from_main_loop_7(); // [unknown]
  $9D99   mark_nearby_items();
  $9D9C   ring_bell();
  $9D9F   called_from_main_loop_9(); // [unknown]
  $9DA2   move_map();
  $9DA5   message_display();
  $9DA8   ring_bell();
  $9DAB   searchlight();
  $9DAE   plot_game_screen();
  $9DB1   ring_bell();
  $9DB4   if (day_or_night != 0) nighttime();
  $9DBB   if (room_index != 0) indoors_delay_loop();
  $9DC2   wave_morale_flag();
  $9DC5   if ((game_counter & 63) == 0) dispatch_timed_event();
  $9DCD }

; ------------------------------------------------------------------------------

c $9DCF check_morale
D $9DCF (<- main_loop)
  $9DCF if (morale >= 2) return;
  $9DD5 queue_message_for_display(message_MORALE_IS_ZERO);
  $9DDB morale_2 = 0xFF; // inhibit user input
  $9DE0 automatic_player_counter = 0; // immediately take automatic control of player
  $9DE4 return;

; ------------------------------------------------------------------------------

c $9DE5 keyscan_cancel
D $9DE5 Check for 'game cancel' keypress.
  $9DE5 if (!(shift_pressed && space_pressed)) return;
  $9DF4 screen_reset();
  $9DF7 user_confirm();
  $9DFA if (Z) reset_game();
  $9DFD if (room_index == 0) { reset_B2FC(); return; } // exit via
  $9E04 else enter_room(); // doesn't return (jumps to main_loop)

; ------------------------------------------------------------------------------

c $9E07 process_player_input
  $9E07 if (morale_1 || morale_2) return; // inhibits user control when morale hits zero // reads morale_1 + morale_2 together as a word
  $9E0E if ($8001 & (vischar_BYTE1_PICKING_LOCK | vischar_BYTE1_CUTTING_WIRE)) {
D $9E15 Picking a lock, or cutting wire fence.
  $9E15   automatic_player_counter = 31; // 31 turns until automatic control
  $9E1A   if ($8001 == vischar_BYTE1_PICKING_LOCK) goto picking_a_lock;
D $9E1F Cutting wire fence.
  $9E1F   snipping_wire(); return; } // exit via
  $9E22 A = input_routine(); // lives at same address as static_tiles_plot_direction
  $9E25 - // subsumed into following code
  $9E2A if (A == input_NONE) {
  $9E2D   if (automatic_player_counter == 0) return;
  $9E30   automatic_player_counter--; // no user input: count down
  $9E31   A = 0; }
  $9E32 else {
R $9E34 I:HL Pointer to automatic_player_counter.
  $9E34   automatic_player_counter = 31; // wait 31 turns until automatic control
  $9E36   ... (push af) ...
  $9E37   if (player_in_bed == 0) {
  $9E3D     if (!player_in_breakfast) goto not_breakfast;
  $9E43     (word) $8002 = 0x002B; // set target location?
  $9E49     (word) $800F = 0x0034; // set Y pos
  $9E4E     (word) $8011 = 0x003E; // set X pos
  $9E52     roomdef_25_breakfast.bench_G = interiorobject_EMPTY_BENCH;
  $9E57     HL = &player_in_breakfast; }
  $9E5A   else {
D $9E5C Player was in bed.
  $9E5C     (word) $8002 = 0x012C; // set target location?
  $9E62     (word) $8004 = 0x2E2E; // another position?
  $9E68     (word) $800F = 0x002E; // set Y pos
  $9E6D     (word) $8011 = 0x002E; // set X pos
  $9E70     $8013 = 24; // set vertical offset
  $9E75     player_bed = interiorobject_EMPTY_BED;
  $9E7A     HL = &player_in_bed; }
  $9E7D   *HL = 0;
  $9E7F   setup_room();
  $9E82   plot_indoor_tiles();
  $9E85 not_breakfast: // ... (pop af -- restores user input value stored at $9E36)
  $9E86   if (A >= input_FIRE) {
  $9E8A     check_for_pick_up_keypress();
  $9E8D     A = 0x80; } }
  $9E8F if ($800D == A) return; // tunnel related?
  $9E94 $800D = A | 0x80;
  $9E97 return;

; ------------------------------------------------------------------------------

c $9E98 picking_a_lock
D $9E98 Locks the player out until lock is picked.
  $9E98 if (player_locked_out_until != game_counter) return;
  $9EA0 *ptr_to_door_being_lockpicked &= ~gates_and_doors_LOCKED; // unlock
  $9EA5 queue_message_for_display(message_IT_IS_OPEN);
  $9EAA clear_lockpick_wirecut_flags_and_return: $8001 &= ~(vischar_BYTE1_PICKING_LOCK | vischar_BYTE1_CUTTING_WIRE);
  $9EB1 return;

; ------------------------------------------------------------------------------

c $9EB2 snipping_wire
D $9EB2 Locks the player out until wire is snipped.
  $9EB2 A = player_locked_out_until - game_counter;
  $9EB9 if (A) {
  $9EBB   if (A < 4)
  $9EBE     $800D = table_9EE0[$800E & 3]; // new direction?
  $9ECF   return; }
  $9ED0 else { $800E = A & 3; // walk/crawl flag?
  $9ED6   $800D = 0x80;
  $9ED9   $8013 = 24; // set vertical offset
  $9EDE   goto clear_lockpick_wirecut_flags_and_return; }

; ------------------------------------------------------------------------------

b $9EE0 table_9EE0
D $9EE0 Indexed by $800E.
  $9EE0 direction_type table_9EE0[] = { 0x84, 0x87, 0x88, 0x85 };

; ------------------------------------------------------------------------------

b $9EE4 twentyonelong
D $9EE4 7 structs, 3 wide. maps bytes to offsets.
  $9EE4,3 byte_to_offset { 42, &byte_9EF9[0] }
  $9EE7,3 byte_to_offset {  5, &byte_9EFC[0] }
  $9EEA,3 byte_to_offset { 14, &byte_9F01[0] }
  $9EED,3 byte_to_offset { 16, &byte_9F08[0] }
  $9EF0,3 byte_to_offset { 44, &byte_9F0E[0] }
  $9EF3,3 byte_to_offset { 43, &byte_9F11[0] }
  $9EF6,3 byte_to_offset { 45, &byte_9F13[0] }
D $9EF9 Data 0xFF terminated.
  $9EF9 byte_9EF9 = { 0x82,0x82,0xFF                     }
  $9EFC byte_9EFC = { 0x83,0x01,0x01,0x01,0xFF           }
  $9F01 byte_9F01 = { 0x01,0x01,0x01,0x00,0x02,0x02,0xFF }
  $9F08 byte_9F08 = { 0x01,0x01,0x95,0x97,0x99,0xFF      }
  $9F0E byte_9F0E = { 0x83,0x82,0xFF                     }
  $9F11 byte_9F11 = { 0x99,0xFF                          }
  $9F13 byte_9F13 = { 0x01,0xFF                          }

; ------------------------------------------------------------------------------

b $9F15 byte_9F15
D $9F15,12,4 three groups of four (<- in_permitted_area) possibly (un)permitted area bounds

; ------------------------------------------------------------------------------

c $9F21 in_permitted_area
D $9F21 [unsure] -- could be as general as bounds detection
  $9F21 HL = $800F; // position on Y axis
  $9F24 DE = &player_map_position.y; // x/y confusion here - mislabeling
  $9F27 if (room_index == 0) { // outdoors
  $9F2E   scale_pos(HL,DE);
  $9F31   if (($8018) >= 0x06C8 || ($801A) >= 0x0448) goto escaped; }
  $9F47 else {
  $9F49   *DE++ = *HL++; // indoors
  $9F4B   HL++;
  $9F4C   *DE++ = *HL++;
  $9F4E   HL++;
  $9F4F   *DE++ = *HL++; }
  $9F51 A = ($8001) & (vischar_BYTE1_PICKING_LOCK | vischar_BYTE1_CUTTING_WIRE);
  $9F56 if (A) goto set_flag_red;
  $9F59 if (clock >= 100) {
  $9F60   if (room_index == room_2_hut2left) goto set_flag_green; else goto set_flag_red; }
  $9F6B if (morale_1) goto set_flag_green;
  $9F72 HL = $8002; // target location
  $9F75 A = *HL++;
  $9F77 C = *HL;
  $9F78 if (A & vischar_BYTE2_BIT7) C++;
  $9F7D if (A == 0xFF) {
  $9F81   A = *HL & 0xF8;
  $9F84   if (A == 8) A = 1; else A = 2;
  $9F8C   in_permitted_area_end_bit();
  $9F8F   if (Z) goto set_flag_green; else goto set_flag_red; }
  $9F93 else { A &= 0x7F;
  $9F95   HL = &twentyonelong[0]; // table mapping bytes to offsets
  $9F98   B = 7; // 7 iterations
  $9F9A   do { if (A == *HL++) goto found;
  $9F9E     HL += 2;
  $9FA0   } while (--B);
  $9FA2   goto set_flag_green; }
  $9FA4 found: E = *HL++; // fetch offset
  $9FA6 D = *HL;
  $9FA7 PUSH DE
  $9FA8 POP HL   // HL = DE;
  $9FA9 B = 0;
  $9FAB HL += BC;
  $9FAC A = *HL;
  $9FAD PUSH DE
  $9FAE in_permitted_area_end_bit();
  $9FB1 POP HL
  $9FB2 JR Z,set_flag_green;

  $9FB4 A = $8002;
  $9FB7 if (A & vischar_BYTE2_BIT7) HL++;
  $9FBC BC = 0; // counter?
  $9FBF for (;;) { PUSH BC
  $9FC0   PUSH HL
  $9FC1   HL += BC;
  $9FC2   A = *HL;
  $9FC3   if (A == 255) goto pop_and_set_flag_red; // hit end of list
  $9FC7   in_permitted_area_end_bit();
  $9FCA   POP HL
  $9FCB   POP BC
  $9FCC   JR Z,set_target_then_set_flag_green;  // if (Z) break; equivalent?
  $9FCE   BC++;
  $9FCF }

  $9FD1 set_target_then_set_flag_green: B = $8002;
  $9FD5 set_player_target_location(); // uses B, C
  $9FD8 goto set_flag_green;

  $9FDA pop_and_set_flag_red: POP BC
  $9FDB POP HL
  $9FDC goto set_flag_red;

D $9FDE Green flag code path.
  $9FDE set_flag_green: A = 0; // red_flag
  $9FDF C = attribute_BRIGHT_GREEN_OVER_BLACK;

  $9FE1 flag_select: red_flag = A;
  $9FE4 A = C;
  $9FE5 HL = $5842; // first morale flag attribute byte
  $9FE8 if (A == *HL) return; // flag already correct colour
  $9FEA if (A == attribute_BRIGHT_GREEN_OVER_BLACK) {
  $9FEF   bell = bell_STOP; // silence bell
  $9FF4   A = C; }
  $9FF5 goto set_morale_flag_screen_attributes; // exit via

D $9FF8 Red flag code path.
  $9FF8 set_flag_red: C = attribute_BRIGHT_RED_OVER_BLACK;
  $9FFA A = ($5842); // first morale flag attribute byte
  $9FFD if (A == C) return; // flag already red
  $9FFF ($800D) = 0; // "tunnel related" thing
  $A003 A = 255; // red_flag
  $A005 goto flag_select;

; ------------------------------------------------------------------------------

; is this the end of in_permitted_area or a separate routine?
c $A007 in_permitted_area_end_bit
  $A007 HL = &room_index;
  $A00A if (A & (1<<7)) return *HL == A & 0x7F; // return with flags
;
  $A012 if (*HL) return; // return with flags NZ
  $A016 DE = &player_map_position.y;
;
; This entry point is used by the routine at #R$CB98.
  $A01A HL = &byte_9F15[A * 4];
  $A023 B = 2;
  $A025 do { A = *DE++;
  $A026   if (A < HL[0]) return; // return with flags NZ
  $A028   if (A >= HL[1]) { A |= 1; return; } // return with flags NZ
  $A030   HL += 2;
  $A031 } while (--B);
  $A033 A &= B;
  $A034 return; // return with flags Z

; ------------------------------------------------------------------------------

c $A035 wave_morale_flag
D $A035 Wave the flag every other turn.
  $A035 HL = &game_counter;
  $A038 (*HL)++;
  $A039 if (*HL & 1) return;
  $A03D PUSH HL
  $A03E A = morale;
  $A041 HL = &displayed_morale;
  $A044 if (A != *HL) {
  $A047   if (A < *HL) {
D $A04A Decreasing morale.
  $A04A     (*HL)--;
  $A04B     HL = moraleflag_screen_address;
  $A04E     get_next_scanline(); }
  $A051   else {
D $A053 Increasing morale.
  $A053     (*HL)++;
  $A054     HL = moraleflag_screen_address;
  $A057     get_prev_scanline(); }
  $A05A   moraleflag_screen_address = HL; }
  $A05D DE = bitmap_flag_down;
  $A060 POP HL
  $A061 if (*HL & 2) DE = bitmap_flag_up;
  $A068 HL = moraleflag_screen_address;
  $A06E plot_bitmap(0x0319); return; // dimensions: 24 x 25 // args-BC // exit via

; ------------------------------------------------------------------------------

c $A071 set_morale_flag_screen_attributes
R $A071 I:A Attributes to use.
  $A071 HL = $5842; // first attribute byte
  $A074 DE = $001E; // skip
  $A077 B  = $13;
  $A079 do { *HL++ = A;
  $A07B   *HL++ = A;
  $A07E   HL += DE;
  $A07F } while (--B);
  $A081 return;

; ------------------------------------------------------------------------------

c $A082 get_prev_scanline
D $A082 Given a screen address, returns the same position on the previous scanline.
R $A082 I:HL Original screen address.
R $A082 O:HL Updated screen address.
;
  $A082 if ((H & 7) != 0) { // NNN bits
  $A087   HL -= 256; } // step back one scanline
  $A088 else {
  $A089   if (L < 32) HL -= 32; else HL += 0x06E0; } // complicated
  $A094 return;

; ------------------------------------------------------------------------------

c $A095 indoors_delay_loop
D $A095 Delay loop called when the player is indoors.
  $A095 BC = 0xFFF;
  $A098 while (--BC) ;
  $A09D return;

; ------------------------------------------------------------------------------

c $A09E ring_bell
D $A09E Ring the alarm bell.
D $A09E Called three times from main_loop.
  $A09E HL = &bell;
  $A0A1 A = *HL;
  $A0A2 if (A == bell_STOP) return; // not ringing
  $A0A5 if (A != bell_RING_PERPETUAL) {
D $A0A8 Decrement the ring counter.
  $A0A8   *HL = --A;
  $A0AA   if (A == 0) {
  $A0AC     *HL = bell_STOP; // counter hit zero - stop ringing
  $A0AF     return; } }
  $A0B0 A = screenaddr_bell_ringer; // fetch visible state of bell
  $A0B3 if (A != 63) {
D $A0B8 Redundant jump.
  $A0B8 -
D $A0BB Plot ringer "on".
  $A0BB   DE = bell_ringer_bitmap_on;
  $A0BE   plot_ringer();
  $A0C1   play_speaker(sound_BELL_RINGER); return; } // args=BC // exit via
D $A0C6 Plot ringer "off".
  $A0C6 else { DE = bell_ringer_bitmap_off;
;
  $A0C9   plot_ringer: HL = screenaddr_bell_ringer;
  $A0CC   plot_bitmap(0x010C); return; } // dimensions: 8 x 12 // args=BC // exit via

; ------------------------------------------------------------------------------

c $A0D2 increase_morale
R $A0D2 I:B Amount to increase morale by. (Preserved)
  $A0D2 A = morale + B;
  $A0D6 if (A >= morale_MAX) A = morale_MAX;
  $A0DC set_morale_from_A: morale = A;
  $A0DF return;

c $A0E0 decrease_morale
R $A0E0 I:B Amount to decrease morale by. (Preserved)
  $A0E0 A = morale - B;
  $A0E4 if (A < morale_MIN) A = morale_MIN;
  $A0E7 goto set_morale_from_A;

c $A0E9 increase_morale_by_10_score_by_50
D $A0E9 Increase morale by 10, score by 50.
  $A0E9 increase_morale(10);
  $A0EE increase_score(50); return; // exit via

c $A0F2 increase_morale_by_5_score_by_5
D $A0F2 Increase morale by 5, score by 5.
  $A0F2 increase_morale(5);
  $A0F7 increase_score(5); return; // exit via

; ------------------------------------------------------------------------------

c $A0F9 increase_score
D $A0F9 Increases the score then plots it.
R $A0F9 I:B Amount to increase score by.
  $A0F9 A = 10;
  $A0FB HL = &score_digits + 4;
  $A0FE do { tmp = HL;
  $A0FF   increment_score: (*HL)++;
  $A100   if (*HL == A) { *HL-- = 0; goto increment_score; }
  $A108   HL = tmp;
  $A109 } while (--B);
E $A0F9 FALL THROUGH into plot_score.

; ------------------------------------------------------------------------------

c $A10B plot_score
D $A10B Draws the current score to screen.
  $A10B HL = &score_digits;
  $A10E DE = &score; // screen address of score
  $A111 B = 5;
  $A113 do { -
  $A114   plot_glyph(); // HL -> glyph, DE -> destination
  $A117   HL++;
  $A118   DE++;
  $A119   -
  $A11A } while (--B);
  $A11C return;

; ------------------------------------------------------------------------------

c $A11D play_speaker
D $A11D Makes a sound through the speaker.
R $A11D I:B Number of iterations to play for.
R $A11D I:C Delay inbetween each iteration.
  $A11D delay = C; // Self-modify delay loop at $A126.
  $A121 A = 16; // Initial speaker bit.
  $A123 do { OUT ($FE),A // Play.
  $A127   C = delay; while (C--) ;
  $A12A   A ^= 16; // Toggle speaker bit.
  $A12C } while (--B);
  $A12E return;

; ------------------------------------------------------------------------------

b $A12F game_counter
D $A12F Counts 00..FF then wraps.

; ------------------------------------------------------------------------------

b $A130 bell
D $A130 0 => ring indefinitely; 255 => don't ring; N => ring for N calls

; ------------------------------------------------------------------------------

u $A131 unused_A131
D $A131 Unreferenced byte.

; ------------------------------------------------------------------------------

b $A132 score_digits

; ------------------------------------------------------------------------------

b $A137 player_in_breakfast

; ------------------------------------------------------------------------------

b $A138 red_flag
D $A138 0 => not naughty, 0xFF => naughty

; ------------------------------------------------------------------------------

b $A139 automatic_player_counter
D $A139 Countdown until CPU control of the player is assumed. When it becomes zero, control is assumed. It's usually set to 31 by input events.

b $A13A morale_1
D $A13A Inhibits user input when non-zero.
D $A13A Stops set_player_target_location working.
D $A13A Used to set flag colour.
D $A13A morale_1 + morale_2 treated as a word by process_player_input. Everything else treats this as a byte.

b $A13B morale_2
D $A13B Inhibits user input when non-zero.
D $A13B Set by check_morale.
D $A13B Reset by reset_game.

b $A13C morale
D $A13C Morale 'score'. Ranges morale_MIN .. morale_MAX.

; ------------------------------------------------------------------------------

b $A13D clock

; ------------------------------------------------------------------------------

b $A13E byte_A13E
D $A13E Mystery.
D $A13E In byte_A13E_is_nonzero etc.: when non-zero, character_index is valid. Else IY points to character_struct.

; ------------------------------------------------------------------------------

b $A13F player_in_bed

; ------------------------------------------------------------------------------

b $A140 displayed_morale
D $A140 Displayed morale lags behind actual morale, as the flag moves slowly to its target.

; ------------------------------------------------------------------------------

w $A141 moraleflag_screen_address

; ------------------------------------------------------------------------------

w $A143 ptr_to_door_being_lockpicked
D $A143 Address of door (in gates_and_doors) in which bit 7 is cleared when picked.

; ------------------------------------------------------------------------------

b $A145 player_locked_out_until
D $A145 Game time until player control is restored (e.g. when picking a lock or cutting wire).

; ------------------------------------------------------------------------------

b $A146 day_or_night
D $A146 Day or night time ($00 = daytime, $FF = nighttime).

; ------------------------------------------------------------------------------

b $A147 bell_ringer_bitmaps
B $A147 bell_ringer_bitmap_off
B $A153 bell_ringer_bitmap_on

; ------------------------------------------------------------------------------

c $A15F set_game_screen_attributes
R $A15F I:A Attribute byte.
D $A15F Starting at $5847, set 23 columns of 16 rows to A.
  $A15F memset($5847, A, 23 * 16);

; ------------------------------------------------------------------------------

b $A173 timed_events
D $A173 Array of 15 event structures.
  $A173 {   0, event_another_day_dawns },
  $A176 {   8, event_wake_up },
  $A179 {  12, event_new_red_cross_parcel },
  $A17C {  16, event_go_to_roll_call },
  $A17F {  20, event_roll_call },
  $A182 {  21, event_go_to_breakfast_time },
  $A185 {  36, event_breakfast_time },
  $A188 {  46, event_go_to_exercise_time },
  $A18B {  64, event_exercise_time },
  $A18E {  74, event_go_to_roll_call },
  $A191 {  78, event_roll_call },
  $A194 {  79, event_go_to_time_for_bed },
  $A197 {  98, event_time_for_bed },
  $A19A { 100, event_night_time },
  $A19D { 130, event_search_light },

; ------------------------------------------------------------------------------

c $A1A0 dispatch_timed_event
D $A1A0 Dispatches time-based game events like parcels, meals, exercise and roll calls.
D $A1A0 Increment the clock, wrapping at 140.
  $A1A0 HL = &clock;
  $A1A3 A = *HL + 1;
  $A1A5 if (A == 140) A = 0;
  $A1AA *HL = A;
D $A1AB Dispatch the event for that time.
  $A1AB HL = &timed_events[0];
  $A1AE B = 15; // 15 iterations
  $A1B0 do { if (A == *HL++) goto found;
  $A1B4   HL += 2;
  $A1B6 } while (--B);
  $A1B8 return;

  $A1B9 found: L = *HL++;
  $A1BB H = *HL;
  $A1BD A = bell_RING_40_TIMES;
  $A1BF BC = &bell;
  $A1C2 goto *HL; // fantasy syntax

c $A1C3 event_night_time
  $A1C3 if (player_in_bed == 0) set_player_target_location(location_2C01);
  $A1CF A = 0xFF;
  $A1D1 goto set_attrs;

c $A1D3 event_another_day_dawns
  $A1D3 queue_message_for_display(message_ANOTHER_DAY_DAWNS);
  $A1D8 decrease_morale(25);
  $A1DD A = 0;
;
; fallthrough

R $A1DE I:A 0/255 for day/night.
  $A1DE set_attrs: day_or_night = A;
  $A1E1 choose_game_screen_attributes();
  $A1E4 set_game_screen_attributes(); return; // exit via

c $A1E7 event_wake_up
  $A1E7 *BC = A; // bell = bell_RING_40_TIMES;
  $A1E8 queue_message_for_display(message_TIME_TO_WAKE_UP);
  $A1ED wake_up(); return; // exit via

c $A1F0 event_go_to_roll_call
  $A1F0 *BC = A; // bell = bell_RING_40_TIMES;
  $A1F1 queue_message_for_display(message_ROLL_CALL);
  $A1F6 go_to_roll_call(); return; // exit via

c $A1F9 event_go_to_breakfast_time
  $A1F9 *BC = A; // bell = bell_RING_40_TIMES;
  $A1FA queue_message_for_display(message_BREAKFAST_TIME);
  $A1FF set_location_0x1000(); return; // exit via

c $A202 event_breakfast_time
  $A202 *BC = A; // bell = bell_RING_40_TIMES;
  $A203 breakfast_time(); return; // exit via

c $A206 event_go_to_exercise_time
  $A206 *BC = A; // bell = bell_RING_40_TIMES;
  $A207 queue_message_for_display(message_EXERCISE_TIME);
D $A20C Unlock the gates.
  $A20C gates_and_doors[0] = 0x00; gates_and_doors[1] = 0x01;
  $A212 set_location_0x0E00(); return; // exit via

c $A215 event_exercise_time
  $A215 *BC = A; // bell = bell_RING_40_TIMES;
  $A216 set_location_0x8E04(); return; // exit via

c $A219 event_go_to_time_for_bed
  $A219 *BC = A; // bell = bell_RING_40_TIMES;
D $A21A Lock the gates.
  $A21A gates_and_doors[0] = 0x80; gates_and_doors[1] = 0x81;
  $A220 queue_message_for_display(message_TIME_FOR_BED);
  $A225 go_to_time_for_bed(); return; // exit via

c $A228 event_new_red_cross_parcel
D $A228 Don't deliver a new red cross parcel while the previous one still exists.
  $A228 if ((item_structs[item_RED_CROSS_PARCEL].room & itemstruct_ROOM_MASK) != itemstruct_ROOM_MASK) return;
D $A230 Select the next parcel contents -- the first item from the list which does not exist.
  $A230 DE = &red_cross_parcel_contents_list[0];
  $A233 B = 4; // length of above
  $A235 do { A = *DE;
  $A236   HL = item_to_itemstruct(A);
  $A239   HL++;
  $A23A   if ((*HL & itemstruct_ROOM_MASK) == itemstruct_ROOM_MASK) goto found;
  $A241   DE++;
  $A242 } while (--B);
  $A244 return;

  $A245 found: red_cross_parcel_current_contents = *DE;
  $A249 memcpy(&item_structs[item_RED_CROSS_PARCEL].room, red_cross_parcel_reset_data, 6);
  $A254 queue_message_for_display(message_RED_CROSS_PARCEL); return; // exit via

D $A259 red_cross_parcel_reset_data
D $A259 Data to set the parcel object up (room, y, x, ...).
B $A259 { item_RED_CROSS_PARCEL, 44,44, 0x0C,0x80,0xF4 };

B $A25F red_cross_parcel_contents_list
B $A25F item_t red_cross_parcel_contents_list[] = { item_PURSE, item_WIRESNIPS, item_BRIBE, item_COMPASS };

B $A263 red_cross_parcel_current_contents

c $A264 event_time_for_bed
  $A264 A = 0xA6;
  $A266 C = 3;
  $A268 goto $A26E;

c $A26A event_search_light
  $A26A A = 0x26;
  $A26C C = 0;
;
; fallthrough

D $A26E Common end of event_time_for_bed and event_search_light.
  $A26E -
  $A26F Adash = 0x0C;
  $A271 B = 4; // 4 iterations
  $A273 do { PUSH AF
  $A274   sub_A38C();
  $A277   POP AF
  $A278   Adash++;
  $A279   -
  $A27A   A++;
  $A27B   -
  $A27C } while (--B);
  $A27E return;

; ------------------------------------------------------------------------------

b $A27F tenlong
D $A27F Likely: a list of character indexes.
D $A27F [unsure] (<- sub_A35F, sub_A373)
  $A27F character_index tenlong[] = { character_12_prisoner, character_13, character_20_prisoner, character_21_prisoner, character_22_prisoner, character_14, character_15, character_23_prisoner, character_24, character_25 };

; ------------------------------------------------------------------------------

c $A289 wake_up
D $A289 Called by event_wake_up.
  $A289 if (player_in_bed) { // odd that this jumps into a point which sets player_in_bed to zero when it's already zero
  $A290   $800F = 46; // player's Y position
  $A295   $8011 = 46; } // player's X position
  $A299 player_in_bed = 0;
  $A29D set_player_target_location(location_2A00);
  $A2A3 HL = &characterstruct_20.room;
  $A2A6 -
  $A2A9 -
  $A2AB B = 3; // 3 iterations
  $A2AD do { *HL = room_3_hut2right;
  $A2AE   HL += 7; // characterstruct stride
  $A2AF } while (--B);
  $A2B1 -
  $A2B3 B = 3; // 3 iterations
  $A2B5 do { *HL = room_5_hut3right;
  $A2B6   HL += 7; // characterstruct stride
  $A2B7 } while (--B);
  $A2B9 A = 5; // incremented by sub_A373
  $A2BB EX AF,AF'
  $A2BC C = 0; // BC = 0
  $A2BE sub_A373();
D $A2C1 Update all the bed objects to be empty.
  $A2C1 -
  $A2C3 HL = &beds[0];
D $A2C6 Bug: 7 iterations BUT only six beds in the data structure resulting in write to ROM location $1A42.
  $A2C6 B = 7; // 7 iterations
  $A2C8 do { E = *HL++;
  $A2CA   D = *HL++;
  $A2CC   *DE = interiorobject_EMPTY_BED;
  $A2CD } while (--B);
D $A2CF Update the player's bed object to be empty.
  $A2CF room_2_hut2_left.bed = interiorobject_EMPTY_BED;
  $A2D3 if (room_index == room_0_outdoors || room_index >= room_6) return;
  $A2DB setup_room();
  $A2DE plot_indoor_tiles();
  $A2E1 return;

; ------------------------------------------------------------------------------

c $A2E2 breakfast_time
  $A2E2 if (player_in_breakfast) {
  $A2E9   $800F = 52; // player Y position
  $A2EE   $8011 = 62; } // player X position
  $A2F2 player_in_breakfast = 0;
  $A2F6 set_player_target_location(location_9003);
  $A2FC HL = &characterstruct_20.room;
  $A2FF -
  $A302 -
  $A304 B = 3; // 3 iterations
  $A306 do { *HL = room_25_breakfast;
  $A307   HL += 7; // stride
  $A308 } while (--B);
  $A30A -
  $A30C B = 3; // 3 iterations
  $A30E do { *HL = room_23_breakfast;
  $A30F   HL += 7; // stride
  $A310 } while (--B);
  $A312 A = 144; // incremented by sub_A373
  $A314 EX AF,AF'
  $A315 C = 3;
  $A317 sub_A373();
  $A31A -
D $A31C Update all the benches to be empty.
  $A31C roomdef_23_breakfast.bench_A = interiorobject_EMPTY_BENCH;
  $A31F roomdef_23_breakfast.bench_B = interiorobject_EMPTY_BENCH;
  $A322 roomdef_23_breakfast.bench_C = interiorobject_EMPTY_BENCH;
  $A325 roomdef_25_breakfast.bench_D = interiorobject_EMPTY_BENCH;
  $A328 roomdef_25_breakfast.bench_E = interiorobject_EMPTY_BENCH;
  $A32B roomdef_25_breakfast.bench_F = interiorobject_EMPTY_BENCH;
  $A32E roomdef_25_breakfast.bench_G = interiorobject_EMPTY_BENCH;
  $A331 if (room_index == 0 || room_index >= room_29_secondtunnelstart) return;
  $A339 setup_room();
  $A33C plot_indoor_tiles(); return; // exit via // note that this differs to wake_up's ending

; ------------------------------------------------------------------------------

c $A33F set_player_target_location
  $A33F if (morale_1) return;
  $A344 $8001 &= ~vischar_BYTE1_BIT6;
  $A349 $8002 = B;
  $A34B $8003 = C;
  $A34D sub_A3BB();
  $A350 return;

; ------------------------------------------------------------------------------

c $A351 go_to_time_for_bed
  $A351 set_player_target_location(location_8502);
  $A357 Adash = 133;
  $A35A C = 2;
  $A35C sub_A373(); return; // exit via

; ------------------------------------------------------------------------------

c $A35F sub_A35F
D $A35F Uses tenlong structure.
R $A35F O:Adash Counter incremented.
  $A35F HL = &tenlong[0];
  $A362 B = 10;
  $A364 do { PUSH HL
  $A365   PUSH BC
  $A366   A = *HL;
  $A367   sub_A38C();
  $A36A   Adash++;
  $A36D   POP BC
  $A36E   POP HL
  $A36F   HL++;
  $A370 } while (--B);
  $A372 return;

; ------------------------------------------------------------------------------

c $A373 sub_A373
R $A373 O:Adash Counter incremented.
D $A373 Uses tenlong structure.
  $A373 HL = &tenlong[0];
  $A376 B = 10;
  $A378 do { PUSH HL
  $A379   PUSH BC
  $A37A   A = *HL;
  $A37B   sub_A38C();
  $A37E   POP BC
  $A37F   if (B == 6) Adash++; // 6 is which character?
  $A387   POP HL
  $A388   HL++;
  $A389 } while (--B);
  $A38B return;

; ------------------------------------------------------------------------------

c $A38C sub_A38C
D $A38C Walk non-player visible characters, ...
R $A38C I:A Character index.
R $A38C I:Adash ?
  $A38C HL = get_character_struct(A);
  $A38F if ((*HL & characterstruct_BYTE0_BIT6) == 0) goto not_set; // disabled?
  $A394 PUSH BC
  $A395 A = *HL & characterstruct_BYTE0_MASK;
  $A398 B = 7; // 7 iterations
  $A39A DE = 32; // stride
  $A39D HL = $8020; // iterate over non-player characters
  $A3A0 do { if (A == *HL) goto found;
  $A3A3   HL += DE;
  $A3A4 } while (--B);
  $A3A6 POP BC
  $A3A7 goto exit;

U $A3A9,1 unused_A3A9
D $A3A9 Unreferenced byte.

  $A3AA not_set: HL += 5; // $8005 etc.
  $A3AF store_banked_A_then_C_at_HL();
  $A3B2 exit: return;

  $A3B3 found: POP BC
  $A3B4 HL++;
  $A3B5 *HL++ &= ~vischar_BYTE1_BIT6;
  $A3B8 store_banked_A_then_C_at_HL();

; This entry point is used by the routine at #R$A33F.
  $A3BB byte_A13E = 0;
  $A3BF PUSH BC
  $A3C0 PUSH HL
  $A3C1 HL--;
  $A3C2 sub_C651();
  $A3C5 POP DE  // DE = the HL stored at $A3C0
  $A3C6 DE++;
  $A3C7 LDI // *DE++ = *HL++; BC--;
  $A3C9 LDI // *DE++ = *HL++; BC--;
  $A3CB if (A == 255) {
  $A3D0   DE -= 6;
  $A3D4   IY = DE;
  $A3D7   EX DE,HL
  $A3D8   HL += 2;
  $A3DA   sub_CB23();
  $A3DD   POP BC // could have just ended the block here
  $A3DE   return; }
  $A3DF else if (A == 128) {
  $A3E4   DE -= 5;
  $A3E8   EX DE,HL
  $A3E9   *HL |= vischar_BYTE1_BIT6; } // sample = HL = $8001
  $A3EB POP BC
  $A3EC return;

; ------------------------------------------------------------------------------

c $A3ED store_banked_A_then_C_at_HL
  $A3ED *HL++ = Adash;
  $A3F1 *HL = C;
  $A3F2 return;

; ------------------------------------------------------------------------------

c $A3F3 byte_A13E_is_nonzero
D $A3F3 Checks character indexes, sets target locations, ...
R $A3F3 I:HL -> charstruct?
  $A3F3 A = character_index;
  $A3F6 goto $A404;

c $A3F8 byte_A13E_is_zero
D $A3F8 Gets hit when player enters hut at end of day.
  $A3F8 A = IY[0]; // IY=$8000 // must be a character index
  $A3FB if (A == 0) { set_player_target_location(location_2C00); return; } // exit via
;
; This entry point is used by the routine at #R$A3F3.
R $A404 I:A Character index.
  $A404 HL[1] = 0; // HL=$766B,$7672 charstruct + 5 (charstruct + 6 when zeroed)
  $A407 if (A > 19) {
  $A40F   A -= 13; } // 20.. => 7..
  $A411 else {
  $A413   old_A = A; A = 13; if (old_A & (1<<0)) { // tmp introduced to avoid interleaving
  $A419     HL[1] = 1; // HL=$7681,$7673 // characterstruct_N + 6
  $A41B     A |= 0x80; } }
  $A41D HL[0] = A; // characterstruct_N + 5
  $A41F return;

; ------------------------------------------------------------------------------

c $A420 character_sits
R $A420 I:A Character.
  $A420 PUSH AF
  $A421 EX DE,HL
  $A422 A -= 18; // first three characters
  $A424 HL = &roomdef_25_breakfast.bench_D;
  $A427 if (A >= 3) { // second three characters
  $A42B   HL = &roomdef_23_breakfast.bench_A;
  $A42E   A -= 3; }
D $A430 Poke object.
  $A430 HL += A * 3;
  $A437 *HL = interiorobject_PRISONER_SAT_DOWN_MID_TABLE;
  $A439 POP AF
  $A43A C = room_25_breakfast;
  $A43C if (A >= character_21_prisoner) C = room_23_breakfast;
  $A442 goto character_sit_sleep_common;

D $A444 character_sleeps
  $A444 PUSH AF
  $A445 A = (A - 7) * 2
  $A448 EX DE,HL
  $A449 HL = &beds[A];  // BC = beds[A];
  $A450 C = *HL++;
  $A452 B = *HL;
  $A453 *BC = interiorobject_OCCUPIED_BED;
  $A456 POP AF
  $A457 if (A < character_10_prisoner)
  $A45C   C = room_3_hut2_right;
  $A45E else
  $A460   C = room_5_hut3_right;
;
; fallthrough

D $A462 (common end of above two routines)
  $A462 character_sit_sleep_common: EX DE,HL
  $A463 *HL = 0;  // $8022, $76B8, $76BF, $76A3  (can be vischar OR characterstruct - weird)
  $A465 EX AF,AF'
  $A466 if (room_index != C) {
  $A46C   HL -= 4;
  $A470   *HL = 255;
  $A472   return; }
D $A473 Force a refresh.
  $A473 HL += 26;
  $A477 *HL = 255;
  $A479 select_room_and_plot: setup_room();
  $A47C plot_indoor_tiles(); return;

; ------------------------------------------------------------------------------

c $A47F player_sits
  $A47F roomdef_25_breakfast.bench_G = interiorobject_PRISONER_SAT_DOWN_END_TABLE;
  $A484 HL = &player_in_breakfast;
  $A487 goto player_sits_sleeps_end;

c $A489 player_sleeps
  $A489 roomdef_2_hut2_left.bed = interiorobject_OCCUPIED_BED;
  $A48E HL = &player_in_bed;

D $A491 (common end of the above two routines)
  $A491 player_sits_sleeps_end: *HL = 0xFF; // set in breakfast, or in bed
  $A493 A = 0;
  $A494 $8002 = A; // target location? bottom byte only?
D $A498 Set player position to zero.
  $A498 memset($800F, 0, 4);
  $A4A1 HL = $8000;
  $A4A4 reset_position(); // reset player
  $A4A7 goto select_room_and_plot;

; ------------------------------------------------------------------------------

c $A4A9 set_location_0x0E00
  $A4A9 set_player_target_location(0x0E00);
  $A4AF A = 0x0E;
  $A4B1 EX AF,AF'
  $A4B2 C = 0;
  $A4B4 sub_A373(); return; // exit via

; ------------------------------------------------------------------------------

c $A4B7 set_location_0x8E04
  $A4B7 set_player_target_location(0x8E04);
  $A4BD A = 0x8E;
  $A4BF EX AF,AF'
  $A4C0 C = 4;
  $A4C2 sub_A373(); return; // exit via

; ------------------------------------------------------------------------------

c $A4C5 set_location_0x1000
  $A4C5 set_player_target_location(0x1000);
  $A4CB A = 0x10;
  $A4CD EX AF,AF'
  $A4CE C = 0;
  $A4D0 sub_A373(); return; // exit via

; ------------------------------------------------------------------------------

c $A4D3 byte_A13E_is_nonzero_anotherone
D $A4D3 Something character related [very similar to the routine at $A3F3].
  $A4D3 A = character_index;
  $A4D6 goto $A4E4;

c $A4D8 byte_A13E_is_zero_anotherone
D $A4D8 Sets a target location 2B00. Seems to get hit around breakfasting time. If I nobble this it stops him sitting for breakfast.
  $A4D8 A = IY[0]; // must be a character index
  $A4DC if (A == 0) { set_player_target_location(location_2B00); return; } // exit via
;
; This entry point is used by the routine at #R$A4D3.
R $A4E4 I:A Character index.
  $A4E4 HL[1] = 0;
  $A4E7 if (A > 19) { // change this to 20 and character_21? stands in place of a guard
  $A4EF   tmp_A = A - 2; } // seems to affect position at table // 20.. => 18..
  $A4F1 else {
  $A4F3   -
  $A4F5   tmp_A = 24; // interleaved // guard character?
  $A4F7   if (A & (1<<0)) tmp_A++; }
  $A4FA HL[0] = tmp_A;
  $A4FC return;
; is it all just working out positions where people sit / stand?

; ------------------------------------------------------------------------------

c $A4FD go_to_roll_call
  $A4FD A = 26;
  $A4FF EX AF,AF'
  $A500 C = 0;
  $A502 sub_A35F();
  $A505 set_player_target_location(location_2D00);

; ------------------------------------------------------------------------------

c $A50B screen_reset
  $A50B wipe_visible_tiles();
  $A50E plot_indoor_tiles();
  $A511 zoombox();
  $A514 plot_game_screen();
  $A517 A = attribute_WHITE_OVER_BLACK;
  $A519 set_game_screen_attributes(); return; // exit via

; ------------------------------------------------------------------------------

c $A51C escaped
D $A51C Print 'well done' message then test to see if the correct objects were used in the escape attempt.
  $A51C screen_reset();
  $A51F HL = &escape_strings[0];
  $A522 screenlocstring_plot(); // WELL DONE
  $A525 screenlocstring_plot(); // YOU HAVE ESCAPED
  $A528 screenlocstring_plot(); // FROM THE CAMP
  $A52B C = 0; // zero flag
  $A52D HL = &items_held[0];
  $A530 have_required_items();
  $A533 HL++; // &items_held[1];
  $A534 have_required_items();
  $A537 A = C;
  $A538 if (A == escapeitem_COMPASS + escapeitem_PURSE) goto success;
  $A53C else if (A != escapeitem_COMPASS + escapeitem_PAPERS) goto captured;
;
; fallthrough

  $A540 success: HL = &escape_strings[3];
  $A543 screenlocstring_plot(); // AND WILL CROSS THE
  $A546 screenlocstring_plot(); // BORDER SUCCESSFULLY
  $A549 A = 0xFF; // success flag
  $A54B PUSH AF
  $A54C goto press_any_key;

  $A54E captured: PUSH AF
  $A54F HL = &escape_strings[5];
  $A552 screenlocstring_plot(); // BUT WERE RECAPTURED
  $A555 POP AF
  $A556 PUSH AF
  $A557 if (A >= escapeitem_UNIFORM) goto plot; // at least a uniform => 'but were recaptured' // bug? plotting twice
  $A55B HL = &escape_strings[7];
  $A55E if (A == 0) goto plot; // no objects => 'totally unprepared'
  $A561 HL = &escape_strings[8];
  $A564 if ((A & escapeitem_COMPASS) == 0) goto plot; // no compass => 'totally lost'
  $A568 HL = &escape_strings[9];
;
  $A56B plot: screenlocstring_plot();
;
  $A56E press_any_key: HL = &escape_strings[10];
  $A571 screenlocstring_plot(); // PRESS ANY KEY
D $A574 Wait for a keypress.
  $A574 do { keyscan_all(); } while (!Z);
  $A579 do { keyscan_all(); } while (Z);
  $A57E POP AF
  $A57F if (A == 0xFF || A >= escapeitem_UNIFORM) { reset_game(); return; } // exit via
  $A589 solitary(); return; // exit via

; ------------------------------------------------------------------------------

c $A58C keyscan_all
R $A58C O:A Pressed key.
  $A58C BC = $FEFE;
  $A58F do { IN A,(C)
  $A591   A = ~A & 0x1F;
  $A594   if (A) return;
  $A595   RLC B
  $A597 } while (carry);
  $A59A A = 0;
  $A59B return;

; ------------------------------------------------------------------------------

c $A59C have_required_items
D $A59C Return bitmask indicating the presence of required items.
R $A59C I:HL Pointer to (single) item slot.
R $A59C I:C  Previous return value.
R $A59C O:C  Previous return value + escapeitem_ flag.
  $A59C A = *HL;
  $A59D item_to_bitmask();
  $A5A0 C += A;
  $A5A2 return;

c $A5A3 item_to_bitmask
D $A5A3 Return a bitmask indicating the presence of required items.
R $A5A3 I:A Item.
R $A5A3 O:A Bitmask.
  $A5A3 if (A == item_COMPASS) { A = escapeitem_COMPASS; return; }
  $A5AA if (A == item_PAPERS)  { A = escapeitem_PAPERS;  return; }
  $A5B1 if (A == item_PURSE)   { A = escapeitem_PURSE;   return; }
  $A5B8 if (A == item_UNIFORM) { A = escapeitem_UNIFORM; return; }
  $A5BD A = 0; // have no required objects
  $A5BE return;

; ------------------------------------------------------------------------------

c $A5BF screenlocstring_plot
R $A5BF I:HL Pointer to screenlocstring.
R $A5BF O:HL Pointer to byte after screenlocstring.
  $A5BF E = *HL++; // read screen address into DE
  $A5C1 D = *HL++;
  $A5C3 B = *HL++; // iterations / nbytes
  $A5C5 do { PUSH BC
  $A5C6   plot_glyph();
  $A5C9   HL++;
  $A5CA   POP BC
  $A5CB } while (--B);
  $A5CD return;

; ------------------------------------------------------------------------------

b $A5CE escape_strings
D $A5CE "WELL DONE"
  $A5CE #CALL:decode_screenlocstring($A5CE)
D $A5DA "YOU HAVE ESCAPED"
  $A5DA #CALL:decode_screenlocstring($A5DA)
D $A5ED "FROM THE CAMP"
  $A5ED #CALL:decode_screenlocstring($A5ED)
D $A5FD "AND WILL CROSS THE"
  $A5FD #CALL:decode_screenlocstring($A5FD)
D $A612 "BORDER SUCCESSFULLY"
  $A612 #CALL:decode_screenlocstring($A612)
D $A628 "BUT WERE RECAPTURED"
  $A628 #CALL:decode_screenlocstring($A628)
D $A63E "AND SHOT AS A SPY"
  $A63E #CALL:decode_screenlocstring($A63E)
D $A652 "TOTALLY UNPREPARED"
  $A652 #CALL:decode_screenlocstring($A652)
D $A667 "TOTALLY LOST"
  $A667 #CALL:decode_screenlocstring($A667)
D $A676 "DUE TO LACK OF PAPERS"
  $A676 #CALL:decode_screenlocstring($A676)
D $A68E "PRESS ANY KEY"
  $A68E #CALL:decode_screenlocstring($A68E)

; ------------------------------------------------------------------------------

b $A69E bitmap_font
D $A69E 0..9, A..Z (omitting O), space, full stop
D $A69E #FONT$A69E,35,7,2{0,0,560,16}(font)

; ------------------------------------------------------------------------------

b $A7C6 used_by_move_map

; ------------------------------------------------------------------------------

b $A7C7 plot_game_screen_x

; ------------------------------------------------------------------------------

c $A7C9 get_supertiles
D $A7C9 Pulls supertiles out of the map.
D $A7C9 Get vertical offset.
  $A7C9 A = (map_position >> 8) & 0xFC; // A = 0, 4, 8, 12, ...
D $A7CE Multiply A by 13.5. (A is a multiple of 4, so this goes 0, 54, 108, 162, ...)
  $A7CE HL = $BCB8 + (A + (A >> 1)) * 9; // $BCB8 is &map_tiles[0] - 54 so it must be skipping the first row.
  $A7E3 HL += (map_position & 0xFF) >> 2;
D $A7EE Populate $FF58 with 7x5 array of supertile refs.
  $A7EE A = 5; // 5 iterations
  $A7F0 DE = $FF58;
  $A7F3 do { memcpy(DE, HL, 7); DE += 7;
  $A801   HL += 54; // stride - width of map
  $A805 } while (--A);
  $A809 return;

; ------------------------------------------------------------------------------

; two entry points

c $A80A sub_A80A
D $A80A Causes some tile plotting.
  $A80A DE = $F278;
  $A80D -
  $A80E HLdash = $FF74;
  $A811 A = map_position >> 8; // map_position hi
  $A814 DEdash = $FE90;
  $A817 goto $A826;

c $A819 sub_A819
D $A819 Causes some tile plotting.
  $A819 DE = $F0F8; // visible tiles array
  $A81C -
  $A81D HLdash = $FF58;
  $A820 A = map_position >> 8; // map_position hi
  $A823 DEdash = $F290; // screen buffer start address

; This entry point is used by the routine at #R$A80A.
  $A826 A = (A & 3) * 4;
  $A82A ($A86A) = A; // self modify
  $A82D Cdash = A;
  $A82E A = (map_position[0] & 3) + Cdash;
  $A834 -
  $A835 Adash = *HLdash;
  $A836 -
  $A837 HL = 0x5B00 + Adash * 16;
  $A842 -
  $A843 A += L;
  $A844 L = A;
  $A845 A = -A & 3;
  $A849 if (A == 0) A = 4;
  $A84D B = A; // iterations
  $A84E do { A = *HL; // A = tile index
  $A84F   *DE = A;
  $A850   plot_tile();
  $A853   HL++;
  $A854   DE++;
  $A855 } while (--B);
  $A857 -
  $A858 HLdash++;
  $A859 Bdash = 5; // 5 iterations
  $A85B do { PUSH BCdash
  $A85C   A = *HLdash;
  $A85D   -
  $A85E   HL = &super_tiles[A];
  $A869   A = 0; // self modified by $A82A
  $A86B   L += A;
  $A86D   B = 4; // 4 iterations
  $A86F   do { A = *HL;
  $A870     *DE = A;
  $A871     plot_tile();
  $A874     HL++;
  $A875     DE++;
  $A876   } while (--B);
  $A878   -
  $A879   HLdash++;
  $A87A   POP BCdash
  $A87B } while (--Bdash);
  $A87D A = Cdash;
  $A87E EX AF,AF' // unpaired?
  $A87F A = *HLdash;
  $A880 -
  $A881 HL = &super_tiles[A];
  $A88C A = ($A86A); // read self modified
  $A88F L += A;
  $A891 A = map_position[0] & 3; // map_position lo
  $A896 if (A == 0) return;
  $A897 B = A;
  $A898 do { A = *HL;
  $A899   *DE = A;
  $A89A   plot_tile();
  $A89D   HL++;
  $A89E   DE++;
  $A89F } while (--B);
  $A8A1 return;

; ------------------------------------------------------------------------------

c $A8A2 sub_A8A2
D $A8A2 ...
D $A8A2 Note: Exits with banked registers active.
  $A8A2 DE = $F0F8; // visible tiles array
  $A8A5 -
  $A8A6 HLdash = $FF58; // 7x5 supertile refs
  $A8A9 DEdash = $F290; // screen buffer start address
  $A8AC A = map_position[0];
  $A8AF Bdash = 24; // 24 iterations (screen rows?)
  $A8B1 do { PUSH BCdash
  $A8B2   PUSH DEdash
  $A8B3   PUSH HLdash
  $A8B4   PUSH AFdash
  $A8B5   -
  $A8B6   PUSH DE
  $A8B7   -
  $A8B8   CALL $A8F4 // sub_A8E7:$A8F4;
  $A8BB   -
  $A8BC   POP DE
  $A8BD   DE++;
  $A8BE   -
  $A8BF   POP AF
  $A8C0   POP HLdash
  $A8C1   Cdash = ++A;
  $A8C3   if ((A & 3) == 0) HLdash++;
  $A8C8   A = Cdash;
  $A8C9   POP DEdash
  $A8CA   DEdash++;
  $A8CB   POP BCdash
  $A8CC } while (--Bdash);
  $A8CE return;

; ------------------------------------------------------------------------------

c $A8CF sub_A8CF
  $A8CF DE = $F10F;
  $A8D2 EXX // unpaired
  $A8D3 HL = $FF5E;
  $A8D6 DE = $F2A7;
  $A8D9 A = map_position[0] & 3; // map_position lo
  $A8DE if (A == 0) HL--;
  $A8E1 A = map_position[0] - 1; // map_position lo
  $A8E5 goto $A8F4; // sub_A8E7:$A8F4;

; ------------------------------------------------------------------------------

c $A8E7 sub_A8E7
D $A8E7 Suspect: supertile plotting.
  $A8E7 DE = $F0F8; // visible tiles array
  $A8EA -
  $A8EB HLdash = $FF58; // 7x5 supertile refs
  $A8EE DEdash = $F290; // screen buffer start address
  $A8F1 A = map_position[0]; // map_position lo
; This entry point is used by the routines at #R$A8A2 and #R$A8CF.
  $A8F4 A &= 3;
  $A8F6 ($A94D) = A; // self modify
  $A8F9 Cdash = A;
  $A8FA A = ((map_position >> 8) & 3) * 4 + Cdash;
  $A902 -
  $A903 Adash = *HLdash;
  $A904 -
  $A905 HL = 0x5B00 + Adash * 16;
  $A910 -
  $A911 A += L;
  $A912 L = A;
  $A913 RRA
  $A914 RRA
  $A915 A = -(A & 3) & 3;
  $A91B if (A == 0) A = 4;
  $A91F EX DE,HL
  $A920 BC = 24; // 24 iterations (screen rows?)
  $A923 do { PUSH AF
  $A924   A = *DE;
  $A925   *HL = A;
  $A926   call_plot_tile_inc_de();
  $A929   DE += 4; // stride
  $A92D   HL += BC;
  $A92E   POP AF
  $A92F } while (--A);
  $A933 EX DE,HL
  $A934 EXX
  $A935 HL += 7;
  $A93C B = 3; // 3 iterations
  $A93E do { PUSH BC
  $A93F   A = *HL;
  $A940   EXX
  $A941   HL = 0x5B00 + A * 16;
  $A94C   A = 0; // self modified
  $A94E   A += L;
  $A94F   L = A;
  $A950   BC = 24; // stride
  $A953   EX DE,HL
  $A954   A = 4;
  $A956   do { PUSH AF
  $A957     A = *DE;
  $A958     *HL = A;
  $A959     call_plot_tile_inc_de();
  $A95C     HL += BC;
  $A95D     DE += 4; // stride
  $A961     POP AF
  $A962   } while (--A);
  $A966   EX DE,HL
  $A967   EXX
  $A968   HL += 7;
  $A96F   POP BC
  $A970 } while (--B);
  $A972 A = *HL;
  $A973 EXX
  $A974 HL = 0x5B00 + A * 16;
  $A97F HL += ($A94D); // read self modified
  $A984 A = ((map_position >> 8) & 3) + 1;
  $A98A BC = 24;
  $A98D EX DE,HL
  $A98E do { PUSH AF
  $A98F   A = *DE;
  $A990   *HL = A;
  $A991   call_plot_tile_inc_de();
  $A994   A = 4;
  $A996   A += E;
  $A997   E = A;
  $A998   HL += BC;
  $A999   POP AF
  $A99A } while (--A);
  $A99E EX DE,HL
  $A99F return;

; ------------------------------------------------------------------------------

c $A9A0 call_plot_tile_inc_de
  $A9A0 plot_tile();
  $A9A3 -
  $A9A4 DEdash += 0xBF;
  $A9AB -
  $A9AC return;

; -----------------------------------------------------------------------------

c $A9AD plot_tile
D $A9AD Plots a tile to the buffer.
R $A9AD I:HL Pointer to supertile index (used to select the correct tile group).
R $A9AD I:A  Tile index
  $A9AD -
  $A9AE tile_index = A;
  $A9AF A = *HLdash; // get supertile index
  $A9B0 if (A < 45) { BCdash = exterior_tiles_1; }
  $A9BA else if (A < 139 || A >= 204) { BCdash = exterior_tiles_2; }
  $A9C2 else { BCdash = exterior_tiles_3; }
  $A9C5 PUSH HLdash
  $A9C6 A = tile_index;
  $A9C7 HLdash = A * 8 + BCdash;
  $A9CE PUSH DEdash
  $A9CF EX DEdash,HLdash
  $A9D0 -
  $A9D3 A = 8; // 8 iterations
  $A9D5 do {
  $A9D6   *HLdash = *DEdash++;
  $A9D8   HLdash += 24; // stride
  $A9DB } while (--A);
  $A9DF POP DEdash
  $A9E0 DEdash++;
  $A9E1 POP HLdash
  $A9E2 -
  $A9E3 return;

; -----------------------------------------------------------------------------

c $A9E4 map_shunt_1
  $A9E4 HL = &map_position;
  $A9E7 (*HL)++;
  $A9E8 get_supertiles();
  $A9EB HL = visible_tiles_start_address + 1;
  $A9EE DE = visible_tiles_start_address;
  $A9F1 BC = visible_tiles_length - 1;
  $A9F4 LDIR
  $A9F6 HL = screen_buffer_start_address + 1;
  $A9F9 DE = screen_buffer_start_address;
  $A9FC BC = screen_buffer_length - 1;
  $A9FF LDIR
  $AA01 sub_A8CF();
  $AA04 return;

c $AA05 map_unshunt_1
  $AA05 HL = &map_position;
  $AA08 (*HL)--;
  $AA09 get_supertiles();
  $AA0C HL = visible_tiles_end_address - 1;
  $AA0F DE = visible_tiles_end_address;
  $AA12 BC = visible_tiles_length - 1;
  $AA15 LDDR
  $AA17 HL = screen_buffer_end_address;
  $AA1A DE = screen_buffer_end_address + 1;
  $AA1D BC = screen_buffer_length;
  $AA20 LDDR
  $AA22 sub_A8E7();
  $AA25 return;

c $AA26 map_shunt_2
  $AA26 L--;
  $AA27 H++;
  $AA28 map_position = HL;
  $AA2B get_supertiles();
  $AA2E HL = visible_tiles_start_address + 24;
  $AA31 DE = visible_tiles_start_address + 1;
  $AA34 BC = visible_tiles_length - 24;
  $AA37 LDIR
  $AA39 HL = screen_buffer_start_address + 24 * 8;
  $AA3C DE = screen_buffer_start_address + 1;
  $AA3F BC = screen_buffer_length - 24 * 8;
  $AA42 LDIR
  $AA44 sub_A80A();
  $AA47 sub_A8E7();
  $AA4A return;

c $AA4B map_unshunt_2
  $AA4B HL = &map_position[1];
  $AA4E (*HL)++;
  $AA4F get_supertiles();
  $AA52 HL = visible_tiles_start_address + 24;
  $AA55 DE = visible_tiles_start_address;
  $AA58 BC = visible_tiles_length - 24;
  $AA5B LDIR
  $AA5D HL = screen_buffer_start_address + 24 * 8;
  $AA60 DE = screen_buffer_start_address;
  $AA63 BC = screen_buffer_length - 24 * 8;
  $AA66 LDIR
  $AA68 sub_A80A();
  $AA6B return;

c $AA6C map_shunt_3
  $AA6C HL = &map_position[1];
  $AA6F (*HL)--;
  $AA70 get_supertiles();
  $AA73 HL = visible_tiles_end_address - 24;
  $AA76 DE = visible_tiles_end_address;
  $AA79 BC = visible_tiles_length - 24;
  $AA7C LDDR
  $AA7E HL = screen_buffer_end_address - 24 * 8;
  $AA81 DE = screen_buffer_end_address;
  $AA84 BC = screen_buffer_length - 24 * 8;
  $AA87 LDDR
  $AA89 sub_A819();
  $AA8C return;

c $AA8D map_unshunt_3
  $AA8D L++;
  $AA8E H--;
  $AA8F map_position = HL;
  $AA92 get_supertiles();
  $AA95 HL = visible_tiles_end_address - 24;
  $AA98 DE = visible_tiles_end_address - 1;
  $AA9B BC = visible_tiles_length - 24 - 1;
  $AA9E LDDR
  $AAA0 HL = screen_buffer_end_address - 24 * 8;
  $AAA3 DE = screen_buffer_end_address - 1;
  $AAA6 BC = screen_buffer_length - 24 * 8 - 1;
  $AAA9 LDDR
  $AAAB sub_A819();
  $AAAE sub_A8CF();
  $AAB1 return;

; ------------------------------------------------------------------------------

c $AAB2 move_map
D $AAB2 Moves the map as the character walks.
R $AAB2 O:HL == map_position
  $AAB2 if (room_index) return; // outdoors only
  $AAB7 if ($8007 & vischar_BYTE7_BIT6) return;
  $AABD HL = $800A;
  $AAC0 E = *HL++;
  $AAC2 D = *HL++;
  $AAC4 C = *HL; // $800C
  $AAC5 DE += 3;
  $AAC8 A = *DE;
  $AAC9 if (A == 255) return;
  $AACC if (C & (1<<7)) A ^= 2;
  $AAD2 PUSH AF
  $AAD3 HL = &map_move_jump_table[A];
  $AADB A = *HL++; // ie. HL = (word at HL); HL += 2;
  $AADD H = *HL;
  $AADE L = A;
  $AADF POP AF
  $AAE0 PUSH HL
  $AAE1 PUSH AF
  $AAE2 BC = 0x7C00;
  $AAE5 if (A >= 2) B = 0x00;
  $AAEB else if (A != 1 && A != 2) C = 0xC0;
  $AAF5 HL = map_position;
  $AAF8 if (L == C || H == B) {
  $AAFC   popret: POP AF
  $AAFD   POP HL
  $AAFE   return; }
  $AB03 POP AF
  $AB04 HL = &used_by_move_map; // screen offset of some sort?
  $AB07 if (A >= 2) {
  $AB0B   A = *HL + 1; }
  $AB0D else {
  $AB0F   A = *HL - 1; }
  $AB11 A &= 3;
  $AB13 *HL = A;
  $AB14 EX DE,HL
  $AB15 HL = 0x0000;
; I /think/ this is equivalent:
; HL = 0x0000;
; if (A != 0) {
;     HL = 0x0060;
;     if (A != 2) {
;         HL = 0xFF30;
;         if (A != 1) {
;             HL = 0xFF90;
;         }
;     }
; }
  $AB18 if (A == 0) goto $AB2A;
  $AB1B L = 0x60;
  $AB1D if (A == 2) goto $AB2A;
  $AB21 HL = 0xFF30;
  $AB24 if (A == 1) goto $AB2A;
  $AB28 L = 0x90;
  $AB2A plot_game_screen_x = HL;
  $AB2D HL = map_position;
  $AB30 return;

W $AB31 map_move_jump_table
  $AB31 { map_move_1,
  $AB33 map_move_2,
  $AB35 map_move_3,
  $AB37 map_move_4 };

C $AB39 map_move_1
  $AB39 A = *DE;
  $AB3A if (A == 0) goto map_unshunt_2;
  $AB3E if ((A & (1<<0)) == 0) return;
  $AB41 goto map_shunt_1;

C $AB44 map_move_2
  $AB44 A = *DE;
  $AB45 if (A == 0) goto map_shunt_2;
  $AB49 if (A != 2) return;
  $AB4C goto map_unshunt_1;

C $AB4F map_move_3
  $AB4F A = *DE;
  $AB50 if (A == 3) goto map_shunt_3;
  $AB55 RRA // rotate right?
  $AB56 JP NC,map_unshunt_1;
  $AB59 return;

C $AB5A map_move_4
  $AB5A A = *DE;
  $AB5B if (A == 1) goto map_shunt_1;
  $AB60 if (A == 3) goto map_unshunt_3;
  $AB65 return;

; -----------------------------------------------------------------------------

b $AB66 zoombox_stuff
D $AB66 Zoombox stuff.
  $AB66 zoombox_x
  $AB67 zoombox_horizontal_count
  $AB68 zoombox_y
  $AB69 zoombox_vertical_count

; -----------------------------------------------------------------------------

b $AB6A game_screen_attribute

; -----------------------------------------------------------------------------

c $AB6B choose_game_screen_attributes
R $AB6B O:A Chosen attribute.
  $AB6B if (room_index < room_29_secondtunnelstart) {
  $AB72   A = day_or_night;
  $AB75   C = attribute_WHITE_OVER_BLACK;
  $AB77   if (A == 0) goto set_attribute_from_C;
  $AB7A   A = room_index;
  $AB7D   C = attribute_BRIGHT_BLUE_OVER_BLACK;
  $AB7F   if (A == 0) goto set_attribute_from_C;
  $AB82   C = attribute_CYAN_OVER_BLACK;
;
  $AB84   set_attribute_from_C: A = C;
;
  $AB85   set_attribute_from_A: game_screen_attribute = A;
  $AB88   return; }
D $AB89 Choose attribute for tunnel.
  $AB89 else { C = attribute_RED_OVER_BLACK;
  $AB8B   HL = items_held;
  $AB8E   if (L == item_TORCH || H == item_TORCH) goto set_attribute_from_C;
  $AB96   wipe_visible_tiles();
  $AB99   plot_indoor_tiles();
  $AB9C   A = attribute_BLUE_OVER_BLACK;
  $AB9E   goto set_attribute_from_A; }

; -----------------------------------------------------------------------------

c $ABA0 zoombox
  $ABA0 zoombox_x = 12;
  $ABA5 zoombox_y = 8;
  $ABAA choose_game_screen_attributes();
  $ABAD H = A;
  $ABAE L = A;
  $ABAF ($5932) = HL; // set 2 attrs
  $ABB2 ($5952) = HL; // set 2 attrs
  $ABB5 zoombox_horizontal_count = 0;
  $ABB9 zoombox_vertical_count = 0;

  $ABBC do { HL = &zoombox_x;
  $ABBF   A = *HL;
  $ABC0   if (A != 1) {
  $ABC5     (*HL)--;
  $ABC6     A--;
  $ABC7     HL++;
  $ABC8     (*HL)++;
  $ABC9     HL--; }
  $ABCA   HL++;
  $ABCB   A += *HL;
  $ABCC   if (A < 22) (*HL)++;
  $ABD2   HL++;
  $ABD3   A = *HL;
  $ABD4   if (A != 1) {
  $ABD9     (*HL)--;
  $ABDA     A--;
  $ABDB     HL++;
  $ABDC     (*HL)++;
  $ABDD     HL--; }
  $ABDE   HL++;
  $ABDF   A += *HL;
  $ABE0   if (A < 15) (*HL)++;
  $ABE6   zoombox_1();
  $ABE9   zoombox_2();
  $ABEC   A = zoombox_vertical_count + zoombox_horizontal_count;
  $ABF3 } while (A < 35);
  $ABF8 return;

C $ABF9 zoombox_1
  $ABF9 A = zoombox_y;
  $ABFC H = A;
  $ABFD A = 0;
  $ABFE SRL H
  $AC00 RRA
  $AC01 E = A;
  $AC02 D = H;
  $AC03 SRL H
  $AC05 RRA
  $AC06 L = A;
  $AC07 HL += DE + zoombox_x;
  $AC10 DE = screen_buffer_start_address + 1;
  $AC13 HL += DE;
  $AC14 EX DE,HL
  $AC15 HL = game_screen_start_addresses[zoombox_y * 8]; // ie. * 16
  $AC28 HL += zoombox_x;
  $AC2D EX DE,HL
  $AC2E A = zoombox_horizontal_count;
  $AC31 ($AC55) = A; // self modify
  $AC34 A = -A + 24;
  $AC38 ($AC4D) = A; // self modify
  $AC3B A = zoombox_vertical_count;
  $AC3E B = A; // iterations
  $AC3F do { PUSH BC
  $AC40   PUSH DE
  $AC41   A = 8; // 8 iterations
  $AC43   do { -
  $AC44     BC = zoombox_horizontal_count;
  $AC4A     LDIR
  $AC4C     Adash = 0; // self modified
  $AC4E     HL += Adash;
  $AC53     Adash = E;
  $AC54     Adash -= 0; // self modified
  $AC56     E = Adash;
  $AC57     D++;
  $AC58     -
  $AC59   } while (--A);
  $AC5D   POP DE
  $AC5E   EX DE,HL
  $AC5F   BC = 0x0020;
  $AC62   if (L >= 224) B = 0x07;
  $AC69   HL += BC;
  $AC6A   EX DE,HL
  $AC6B   POP BC
  $AC6C } while (--B);
  $AC6E return;

C $AC6F zoombox_2
  $AC6F HL = game_screen_start_addresses[(zoombox_y - 1) * 8]; // ie. * 16
D $AC83 Top left.
  $AC83 HL += zoombox_x - 1;
  $AC89 zoombox_draw_tile(zoombox_tile_TL);
  $AC8E HL++;
D $AC8F Horizontal.
  $AC8F B = zoombox_horizontal_count; // iterations
  $AC93 do { zoombox_draw_tile(zoombox_tile_HZ);
  $AC98   HL++;
  $AC99 } while (--B);
D $AC9B Top right.
  $AC9B zoombox_draw_tile(zoombox_tile_TR);
  $ACA0 DE = 32;
  $ACA3 if (L >= 224) D = 0x07;
  $ACAA HL += DE;
D $ACAB Vertical.
  $ACAB B = zoombox_vertical_count; // iterations
  $ACAF do { zoombox_draw_tile(zoombox_tile_VT);
  $ACB4   DE = 32;
  $ACB7   if (L >= 224) D = 0x07;
  $ACBE   HL += DE;
  $ACBF } while (--B);
D $ACC1 Bottom right.
  $ACC1 zoombox_draw_tile(zoombox_tile_BR);
  $ACC6 HL--;
D $ACC7 Horizontal.
  $ACC7 B = zoombox_horizontal_count; // iterations
  $ACCB do { zoombox_draw_tile(zoombox_tile_HZ);
  $ACD0   HL--;
  $ACD1 } while (--B);
D $ACD3 Bottom left.
  $ACD3 zoombox_draw_tile(zoombox_tile_BL);
  $ACD8 DE = 0xFFE0;
  $ACDB if (L < 32) DE = 0xF8E0;
  $ACE3 HL += DE;
D $ACE4 Vertical.
  $ACE4 B = zoombox_vertical_count; // iterations
  $ACE8 do { zoombox_draw_tile(zoombox_tile_VT);
  $ACED   DE = 0xFFE0;
  $ACF0   if (L < 32) DE = 0xF8E0;
  $ACF8   HL += DE;
  $ACF9 } while (--B);
  $ACFB return;

C $ACFC zoombox_draw_tile
R $ACFC I:AF Index of tile to draw.
R $ACFC I:BC (preserved)
R $ACFC I:HL Destination address.
  $ACFC PUSH BC
  $ACFD PUSH AF
  $ACFE PUSH HL
  $ACFF EX DE,HL
  $AD00 HL = &zoombox_tiles[A];
  $AD0A B = 8; // 8 iterations
  $AD0C do { *DE = *HL++;
  $AD0E   DE += 256;
  $AD10 } while (--B);
  $AD12 A = D - 1; // ie. (DE - 256) >> 8
  $AD14 H = 0x58; // attributes
  $AD16 L = E;
  $AD17 if (A >= 0x48) { H++;
  $AD1C   if (A >= 0x50) H++; }
  $AD21 *HL = game_screen_attribute;
  $AD25 POP HL
  $AD26 POP AF
  $AD27 POP BC
  $AD28 return;

; ------------------------------------------------------------------------------

w $AD29 word_AD29_used_by_nighttime
D $AD29 Likely: spotlight movement data.

; ------------------------------------------------------------------------------

c $AD59 searchlight_AD59
D $AD59 Used by nighttime.
R $AD59 I:HL Pointer to word_AD29_used_by_nighttime
  $AD59 E = *HL++;
  $AD5B D = *HL++;
  $AD5D (*HL)--;
  $AD5E if (Z) {
  $AD61   HL += 2;
  $AD63   A = *HL; // sampled HL = $AD3B, $AD34, $AD2D
  $AD64   if (A & (1<<7)) {
  $AD69     A &= 0x7F;
  $AD6B     if (A == 0) {
  $AD6E       *HL &= ~(1<<7); }
  $AD70     else {
  $AD72       (*HL)--;
  $AD73       A--; } }
  $AD74   else {
  $AD76     A++;
  $AD77     *HL = A; }
  $AD78   HL++;
  $AD79   C = *HL++;
  $AD7B   B = *HL;
  $AD7C   HL -= 2;
  $AD7E   BC += A * 2;
  $AD84   A = *BC;
  $AD85   if (A == 0xFF) {
  $AD8A     (*HL)--;
  $AD8B     *HL |= 1<<7;
  $AD8D     BC -= 2;
  $AD8F     A = *BC; }
  $AD90   HL -= 2;
  $AD92   *HL++ = *BC++;
  $AD96   *HL = *BC;
  $AD98   return; }
  $AD99 else { HL++;
  $AD9A   A = *HL++;
  $AD9C   if (*HL & (1<<7)) A ^= 2;
  $ADA2   if (A < 2) D -= 2;
  $ADA8   D++;
  $ADA9   if (A != 0 && A != 3) { E += 2; } else { E -= 2 };
  $ADB6   HL -= 3;
  $ADB9   *HL-- = D;
  $ADBB   *HL = E;
  $ADBC   return; }

; ------------------------------------------------------------------------------

c $ADBD nighttime
D $ADBD Turns white screen elements light blue and tracks the player with a searchlight.
  $ADBD HL = &searchlight_state;
  $ADC0 if (*HL == searchlight_STATE_OFF) goto not_tracking;
;
  $ADC6 if (room_index) { // player is indoors
D $ADCC If the player goes indoors the searchlight loses track.
  $ADCC   *HL = searchlight_STATE_OFF;
  $ADCE   return; }
;
D $ADCF Player is outdoors.
  $ADCF if (*HL == searchlight_STATE_1F) {
  $ADD5   HL = map_position;
  $ADD8   E = L + 4;
  $ADDC   D = H;
  $ADDD   HL = searchlight_coords;
  $ADE0   if (L == E) {
  $ADE4     if (H == D) return; } // highlight doesn't need to move, so quit
  $ADE7   else {
D $ADE9 Move searchlight left/right to focus on player.
  $ADE9     if (L < E) {
  $ADEC       L++; }
  $ADED     else {
  $ADEF       L--; }
  $ADF0   }
D $ADF1 Move searchlight up/down to focus on player.
  $ADF1   if (H != D) {
  $ADF5     if (H < D) {
  $ADF8       H++; }
  $ADF9     else {
  $ADFB       H--; }
  $ADFC   }
  $ADFD   searchlight_coords = HL; }
;
  $AE00 DE = map_position;
  $AE04 HL = $AE77; // &searchlight_coords + 1 byte; // compensating for HL--; jumped into
  $AE07 B = 1; // 1 iteration
  $AE09 PUSH BC
  $AE0A PUSH HL
  $AE0B goto $AE3F;
;
  $AE0D not_tracking: HL = &word_AD29_used_by_nighttime[0];
  $AE10 B = 3; // 3 iterations
  $AE12 do { PUSH BC
  $AE13   PUSH HL
  $AE14   searchlight_AD59();
  $AE17   POP HL
  $AE18   PUSH HL
  $AE19   searchlight_caught();
  $AE1C   POP HL
  $AE1D   PUSH HL
  $AE1E   DE = map_position;
  $AE22   if (E + 23 < *HL) goto next; // out of bounds maybe
  $AE29   if (*HL + 16 < E) goto next;
  $AE30   HL++;
  $AE31   if (D + 16 < *HL) goto next;
  $AE38   if (*HL + 16 < D) goto next;
  $AE3F   A = 0;
  $AE40   -
  $AE41   HL--;
  $AE42   B = 0x00;
  $AE44   if (*HL - E < 0) {
  $AE49     B = 0xFF;
  $AE4B     -
  $AE4C     A = ~A;
  $AE4D     - }
;
  $AE4E   C = Adash;
  $AE4F   Adash = *++HL;
  $AE51   H = 0x00;
  $AE53   Adash -= D;
  $AE54   if (Adash < 0) H = 0xFF;
  $AE59   L = Adash;
  $AE5A   HL *= 32;
  $AE5F   HL += BC;
  $AE60   HL += 0x5846; // screen attribute address of top-left game screen attribute
  $AE64   EX DE,HL
  $AE65   -
  $AE66   searchlight_related = A;
  $AE69   searchlight_plot();
;
  $AE6C   next: POP HL
  $AE6D   POP BC
  $AE6E   HL += 7;
  $AE72 } while (--B);
  $AE74 return;

; ------------------------------------------------------------------------------

b $AE75 searchlight_related
D $AE75 (<- nighttime, searchlight_plot)

; ------------------------------------------------------------------------------

w $AE76 searchlight_coords
D $AE76 (<- nighttime)

; ------------------------------------------------------------------------------

c $AE78 searchlight_caught
D $AE78 Suspect this is when the player is caught in the spotlight.
R $AE78 I:HL Pointer to word_AD29_used_by_nighttime
  $AE78 DE = map_position;
  $AE7C if (HL[0] + 5 >= E + 12 || HL[0] + 10 < E + 10) return;
  $AE8B if (HL[1] + 5 >= D + 10 || D + 6 >= HL[1] + 12) return;
  $AE9D if (searchlight_state == searchlight_STATE_1F) return;
  $AEA3 searchlight_state = searchlight_STATE_1F;
  $AEA8 D = HL[0];
  $AEAA E = HL[1];
  $AEAB searchlight_coords = DE;
  $AEAF bell = bell_RING_PERPETUAL;
  $AEB3 decrease_morale(10); // exit via

; ------------------------------------------------------------------------------

c $AEB8 searchlight_plot
D $AEB8 Searchlight plotter.
  $AEB8 -
  $AEB9 DEdash = &searchlight_shape[0];
  $AEBC Cdash = 16; // iterations  / width?
  $AEBE do { -
  $AEBF   A = searchlight_related;
  $AEC2   HL = 0x5A40; // screen attribute address (column 0 + bottom of game screen)
  $AEC5   if (A != 0 && (E & 31) >= 22) L = 32;
  $AED2   SBC HL,DE
  $AED4   RET C  // if (HL < DE) return; // what about carry?
  $AED5   PUSH DE
  $AED6   HL = 0x5840; // screen attribute address (column 0 + top of game screen)
  $AED9   if (A != 0 && (E & 31) >= 7) L = 32;
  $AEE6   SBC HL,DE
  $AEE8   JR C,$AEF0  // if (HL < DE) goto $AEF0;
  $AEEA   -
  $AEEB   DEdash += 2;
  $AEED   -
  $AEEE   goto nextrow;
;
  $AEF0   EX DE,HL
  $AEF1   -
  $AEF2   Bdash = 2;
  $AEF4   do { A = *DEdash;
  $AEF5     -
  $AEF6     DE = 0x071E;
  $AEF9     C = A;
  $AEFA     B = 8;
  $AEFC     do { A = searchlight_related;
  $AEFF       if (A != 0) ...
  $AF00       A = L; // interleaved
  $AF01         ... goto $AF0C;
  $AF04       if ((A & 31) >= 22) goto $AF1B;
  $AF0A       goto $AF18;

  $AF0C       if ((A & 31) < E) goto $AF18;
  $AF11       -
  $AF12       do { DEdash++; } while (--Bdash);
  $AF15       -
  $AF16       goto nextrow;

  $AF18       if (A < D) {
;
  $AF1B         RL C } // looks like bit extraction ...
  $AF1D       else {
  $AF1F         RL C
  $AF21         if (carry) {
  $AF24           *HL = attribute_YELLOW_OVER_BLACK; }
  $AF26         else {
  $AF28           *HL = attribute_BRIGHT_BLUE_OVER_BLACK; } }
  $AF2A       HL++;
  $AF2B     } while (--B);
  $AF2D     -
  $AF2E     DEdash++;
  $AF2F   } while (--Bdash);
  $AF31   -
;
  $AF32   nextrow: POP HL
  $AF33   HL += 32;
  $AF37   EX DE,HL
  $AF38   -
  $AF39 } while (--Cdash);
  $AF3D return;

; -----------------------------------------------------------------------------

B $AF3E searchlight_shape
D $AF3E Bitmap circle.

; -----------------------------------------------------------------------------

b $AF5E zoombox tiles
  $AF5E zoombox_tile_wire_tl
  $AF66 zoombox_tile_wire_hz
  $AF6E zoombox_tile_wire_tr
  $AF76 zoombox_tile_wire_vt
  $AF7E zoombox_tile_wire_br
  $AF86 zoombox_tile_wire_bl

; ------------------------------------------------------------------------------

b $AF8E bribed_character

; ------------------------------------------------------------------------------

c $AF8F sub_AF8F
R $AF8F I:IY Pointer to visible character block.
  $AF8F EX AF,AF'
  $AF90 stashed_A = A;
  $AF93 IY[7] |= vischar_BYTE7_BIT6 | vischar_BYTE7_BIT7;  // wild guess: clamp character in position?
  $AF9B HL = IY;
  $AF9E -
  $AF9F if (L == 0 && automatic_player_counter > 0) door_handling(); // L == 0 => HL == 0x8000
  $AFAB if (L || (($8001 & (vischar_BYTE1_PICKING_LOCK | vischar_BYTE1_CUTTING_WIRE)) != vischar_BYTE1_CUTTING_WIRE)) { bounds_check(); return; }
D $AFB9 Cutting wire only from here onwards?
  $AFB9 A = IY[0]; // $8000,$8020,$8040,$8060
  $AFBC if (A < 26) { // a character index
  $AFC0   sub_AFDF();
  $AFC3   if (!Z) return; }
; else object only from here on?
  $AFC4 IY[7] &= ~vischar_BYTE7_BIT6;
  $AFC8 memcpy(IY + 15, &saved_Y, 6); // $800F // copy Y,X and vertical offset
  $AFD7 IY[0x17] = stashed_A;
  $AFDD A = 0;
  $AFDE return;

; ------------------------------------------------------------------------------

c $AFDF sub_AFDF
  $AFDF HL = $8001; // &vischar[0].byte1;
  $AFE2 B = 8; // 8 iterations
  $AFE4 do { if (*HL & vischar_BYTE1_BIT7) goto next; // $8001, $8021, ...
  $AFE9   PUSH BC
  $AFEA   PUSH HL
  $AFEB   HL += 0x0E; // $800F etc. - y axis position
D $AFEF --------
  $AFEF   C = *HL++;
  $AFF1   B = *HL;
  $AFF2   EX DE,HL
  $AFF3   HL = saved_Y;
  $AFF6   BC += 4;
  $AFFE   if (HL != BC) {
  $B002     if (HL > BC) goto pop_next;
  $B005     BC -= 8; // ie -4 over original
  $B00C     HL = saved_Y;
  $B011     if (HL < BC) goto pop_next; }
  $B014   EX DE,HL
  $B015   HL++;
D $B016 --------
  $B016   C = *HL++;
  $B018   B = *HL;
  $B019   EX DE,HL
  $B01A   HL = saved_X;
  $B01D   BC += 4;
  $B025   if (HL != BC) {
  $B029     if (HL > BC) goto pop_next;
  $B02C     BC -= 8;
  $B033     HL = saved_X;
  $B038     if (HL < BC) goto pop_next; }
  $B03B   EX DE,HL
  $B03C   HL++;
D $B03D --------
  $B03D   C = *HL;
  $B03E   A = saved_VO - C;
  $B042   if (A < 0) {
  $B044     A = -A; }
  $B046   if (A >= 24) goto pop_next;
  $B04B   A = IY[1] & 0x0F; // sampled IY=$8020, $8040, $8060, $8000 // but this is *not* vischar_BYTE1_MASK, which is 0x1F
  $B050   if (A == 1) {
  $B054     POP HL
  $B055     PUSH HL // sampled HL=$8021, $8041, $8061, $80A1
  $B056     HL--;
  $B057     if ((HL & 0xFF) == 0) { // ie. $8000
  $B05B       if (bribed_character == IY[0]) {
  $B063         use_bribe(); }
  $B066       else {
  $B068         POP HL
  $B069         POP BC
  $B06A         HL = IY + 1;
  $B06E         solitary(); return; // exit via } } }
  $B071   POP HL
  $B072   HL--;
  $B073   A = *HL; // sampled HL = $80C0, $8040, $8000, $8020, $8060 // vischar_BYTE0
  $B074   if (A >= 26) {
  $B078     PUSH HL
  $B079     -
  $B07A     HL += 17;
  $B07E     -
  $B07F     B = 7; C = 35;
  $B082     tmpA = A;
  $B084     A = IY[14]; // interleaved
  $B087     if (tmpA == 28) {
  $B089       L -= 2;
  $B08B       C = 54;
  $B08D       A ^= 1; }
  $B08F     if (A == 0) {
  $B092       A = *HL;
  $B093       if (A != C) {
  $B096         if (A >= C) (*HL) -= 2; // decrement by -2 then execute +1 anyway to avoid branch
  $B09A         (*HL)++; } }
  $B09B     else if (A == 1) {
  $B0A1       A = C + B;
  $B0A3       if (A != *HL) (*HL)++; }
  $B0A7     else if (A == 2) {
  $B0AD       A = C - B;
  $B0AF       *HL = A; }
  $B0B0     else {
  $B0B2       A = C - B;
  $B0B4       if (A != *HL) (*HL)--; }
  $B0B8     POP HL
  $B0B9     POP BC }
  $B0BA   HL += 13;
  $B0BE   A = *HL & vischar_BYTE13_MASK; // sampled HL = $806D, $804D, $802D, $808D, $800D
  $B0C1   if (A) {
  $B0C3     HL++;
  $B0C4     A = *HL ^ 2;
  $B0C7     if (A != IY[14]) {
  $B0CC       IY[13] = 0x80;
;
  $B0D0       IY[7] = (IY[7] & vischar_BYTE7_MASK_HI) | 5; // preserve flags and set 5? // sampled IY = $8000, $80E0
  $B0DA       if (!Z) return; /* odd */ } }
;
  $B0DB   BC = IY[14]; // sampled IY = $8000, $8040, $80E0
  $B0E0   IY[13]  = four_bytes_B0F8[BC];
  $B0E8   if ((C & 1) == 0) {
  $B0EC     IY[7] &= ~vischar_BYTE7_BIT5;
  $B0F0     goto $B0D0; }
  $B0F2   else { IY[7] |= vischar_BYTE7_BIT5;
  $B0F6     goto $B0D0; }

B $B0F8,4 four_bytes_B0F8
D $B0F8 (<- sub_AFDF)

  $B0FC   pop_next: POP HL
  $B0FD   POP BC
  $B0FE   next: HL += 32;
  $B102 } while (--B);
  $B106 return;

; ------------------------------------------------------------------------------

c $B107 use_bribe
D $B107 'he takes the bribe' 'and acts as decoy'
R $B107 I:IY Pointer to vischar.
  $B107 increase_morale_by_10_score_by_50();
  $B10A IY[1] = 0;
  $B10E HL = IY + 2;
  $B113 sub_CB23();
  $B116 DE = &items_held[0];
  $B119 if (*DE != item_BRIBE && *++DE != item_BRIBE) return; // have no bribes
D $B123 We have a bribe.
  $B123 *DE = item_NONE;
  $B126 item_structs[item_BRIBE].room = itemstruct_ROOM_MASK;
  $B12B draw_all_items();
  $B12E B = 7; // 7 iterations
  $B130 HL = $8020; // iterate over non-player characters
  $B133 do { if (HL[0] < 20) { // likely character index. but why 20?
  $B138     HL[1] = vischar_BYTE1_BIT2; } // character has taken bribe?
  $B13C   HL += 32;
  $B140 } while (--B);
  $B142 queue_message_for_display(message_HE_TAKES_THE_BRIBE);
  $B147 queue_message_for_display(message_AND_ACTS_AS_DECOY);
  $B149 return;

; ------------------------------------------------------------------------------

c $B14C bounds_check
D $B14C Outdoor bounds detection?
R $B14C I:IY Pointer to visible character block.
  $B14C if (room_index) { indoor_bounds_check(); return; }
  $B153 B = 24; // 24 iterations (includes walls and fences)
  $B155 DE = &walls[0];
  $B158 do { -
  $B159   -
  $B15A   -
  $B15E   if ((saved_Y >= DE[0] * 8 + 2) &&
  $B167     -
  $B16C       (saved_Y <  DE[1] * 8 + 4) &&
  $B177     -
  $B17C       (saved_X >= DE[2] * 8)     &&
  $B183     -
  $B188       (saved_X <  DE[3] * 8 + 4) &&
  $B193     -
  $B198       (saved_VO >= DE[4] * 8)     &&
  $B19F     -
  $B1A4       (saved_VO <  DE[5] * 8 + 2)) {
D $B1AD Found it.
  $B1AD     -
  $B1AE     -
  $B1AF     IY[7] ^= vischar_BYTE7_BIT5; // sampled IY = $80A0, $8080, $8060
  $B1B7     A |= 1; // return NZ
  $B1B9     return; }
  $B1BA   -
  $B1BB   -
  $B1BC   DE += 6;
  $B1C1 } while (--B);
  $B1C5 A &= B; // return Z
  $B1C6 return;

; ------------------------------------------------------------------------------

c $B1C7 BC_becomes_A_times_8
R $B1C7 A  Argument.
R $B1C7 BC Result of (A << 3).
  $B1C7 B = 0;
  $B1C9 A <<= 1;
  $B1CA B = (B << 1) + carry;
  $B1CC A <<= 1;
  $B1CD B = (B << 1) + carry;
  $B1CF A <<= 1;
  $B1D0 B = (B << 1) + carry;
  $B1D2 C = A;
  $B1D3 return;

; ------------------------------------------------------------------------------

c $B1D4 is_door_open
R $B1D4 O:F Z set if door open.
  $B1D4 C = current_door & gates_and_doors_MASK;
  $B1DB HL = &gates_and_doors[0];
  $B1DE B = 9; // 9 iterations
  $B1E0 do { if (*HL & gates_and_doors_MASK == C) {
  $B1E5     if ((*HL & gates_and_doors_LOCKED) == 0) return; // unlocked
  $B1EA     queue_message_for_display(message_THE_DOOR_IS_LOCKED);
  $B1ED     A |= 1; // set NZ
  $B1EF     return; }
  $B1F0   HL++;
  $B1F1 } while (--B);
  $B1F3 A &= B; // set Z (B is zero)
  $B1F4 return;

; ------------------------------------------------------------------------------

c $B1F5 door_handling
  $B1F5 A = room_index;
  $B1F8 if (A) goto door_handling_indoors; // exit via?
  $B1FC HL = &door_positions[0];
  $B1FF E = IY[14];
  $B202 if (E >= 2) HL = &door_position[1];
  $B20A D = 3;  // mask
  $B20C B = 16;
  $B20E do { A = *HL & D;
  $B210   if (A == E) {
  $B213     PUSH BC
  $B214     PUSH HL
  $B215     PUSH DE
  $B216     door_in_range();
  $B219     POP DE
  $B21A     POP HL
  $B21B     POP BC
  $B21C     if (!C) goto found; }
  $B21E   HL += 8;
  $B225 } while (--B);
  $B227 A &= B; // set Z (B is zero)
  $B228 return;

  $B229 found: A = 16 - B;
  $B22C current_door = A;
  $B22F EXX
  $B230 is_door_open();
  $B233 if (!Z) return; // door was locked
  $B234 EXX
  $B235 IY[28] = (*HL >> 2) & 0x3F; // sampled HL = $792E (in door_positions[])
  $B23D if ((*HL & 3) >= 2) {
  $B244   HL += 5;
  $B249   transition(); return; } // seems to goto reset then jump back to main (icky)
  $B24C else { HL -= 3;
  $B24F   transition(); return; }

; ------------------------------------------------------------------------------

c $B252 door_in_range
D $B252 (saved_Y, saved_X) within (-3,+3) of HL[1..] scaled << 2
R $B252 I:HL Pointer to (byte before) coord byte pair.
R $B252 O:F  C/NC if match/nomatch.
  $B252 A = HL[1];
  $B254 -
  $B255 BC_becomes_A_times_4();
  $B258 if (saved_Y < BC - 3 || saved_Y >= BC + 3) return; // with C set
;
  $B273 -
  $B274 A = HL[2];
  $B276 BC_becomes_A_times_4();
  $B279 -
  $B27A if (saved_X < BC - 3 || saved_X >= BC + 3) return; // with C set
;
  $B294 return; // C not set

; ------------------------------------------------------------------------------

c $B295 BC_becomes_A_times_4
R $B295 I:A  Argument.
R $B295 O:BC Result of (A << 2).
  $B295 B = 0;
  $B297 A <<= 1;
  $B298 B = (B << 1) + carry;
  $B29A A <<= 1;
  $B29B B = (B << 1) + carry;
  $B29D C = A;
  $B29E return;

; ------------------------------------------------------------------------------

c $B29F indoor_bounds_check
D $B29F This is doing something like checking the bounds for an interior room.
R $B29F O:AF Corrupted.
R $B29F O:BC Corrupted.
R $B29F O:HL Corrupted.
  $B29F BC = &roomdef_bounds[roomdef_bounds_index];
  $B2AC HL = &saved_Y;
  $B2AF A = *BC;
  $B2B0 if (A < *HL) goto stop;
  $B2B3 A = *++BC + 4;
  $B2B7 if (A >= *HL) goto stop;
  $B2BA HL += 2;
D $B2BC This instruction is stray code. It's incremented but never used.
  $B2BC DE++;
  $B2BD A = *++BC - 4;
  $B2C1 if (A < *HL) goto stop;
  $B2C4 A = *++BC;
  $B2C6 if (A >= *HL) goto stop;
  $B2C9 HL = &roomdef_object_bounds[0];
  $B2CC B = *HL; // iterations
  $B2CE if (B == 0) return;
  $B2D0 HL++;
  $B2D1 do { PUSH BC
  $B2D2     PUSH HL
  $B2D3     DE = &saved_Y;
  $B2D6     B = 2; // 2 iterations
  $B2D8     do { A = *DE;
  $B2D9     if (A < HL[0] || A >= HL[1]) goto next; // next outer loop iteration
  $B2E0     DE += 2;
  $B2E2     HL += 2; // increment moved - hope it's still correct
  $B2E3   } while (--B);
D $B2E5 Found.
  $B2E5   POP HL
  $B2E6   POP BC
;
  $B2E7 stop: IY[7] ^= vischar_BYTE7_BIT5; // stop character?
  $B2EF   A |= 1;
  $B2F1   return; // return NZ

D $B2F2 Next iteration.
  $B2F2 next:  POP HL
  $B2F3   HL += 4;
  $B2F7   POP BC
  $B2F8 } while (--B);
D $B2FA Not found.
  $B2FA A &= B; // B is zero here
  $B2FB return; // return Z

; ------------------------------------------------------------------------------

c $B2FC reset_B2FC
D $B2FC Resets ... something.
  $B2FC HL = $8000;
  $B2FF reset_position(); // reset player
;
  $B302 HL = $8018;
  $B305 A = *HL++;
  $B307 C = *HL;
  $B308 divide_by_8(C,A);
  $B30B map_position[0] = A - 11;
;
  $B310 HL++;
  $B311 A = *HL++;
  $B313 C = *HL;
  $B314 divide_by_8(C,A);
  $B317 map_position[1] = A - 6;
;
  $B31C room_index = room_NONE;
  $B320 get_supertiles();
  $B323 sub_A8A2();
  $B326 setup_movable_items();
  $B329 zoombox();
  $B32C return;

; ------------------------------------------------------------------------------

c $B32D door_handling_indoors
D $B32D Door related stuff.
  $B32D HL = &door_related;
  $B330 for (;;) { A = *HL;
  $B331   if (A == 255) return;
  $B334   -
  $B335   current_door = A;
  $B338   get_door_position();
  $B33B   A = *HLdash;
  $B33C   Cdash = A;
  $B33D   Bdash = A & 3;
  $B340   if (IY[14] & 3 != Bdash) goto next;
  $B348   HLdash++;
  $B349   - // registers renamed here
  $B34A   DEdash = &saved_Y;
  $B34D   B = 2; // 2 iterations
  $B34F   do { A = *HLdash - 3;
  $B352     if (A >= *DEdash || A + 6 < *DEdash) goto next; // -3 .. +3
  $B35A     DEdash += 2;
  $B35C     HLdash++;
  $B35D   } while (--Bdash);
  $B35F   HLdash++;
  $B360   -
  $B361   PUSH HLdash
  $B362   PUSH BCdash
  $B363   is_door_open();
  $B366   POP BCdash
  $B367   POP HLdash
  $B368   if (!Z) return; // door was closed
  $B369   IY[28] = (Cdash >> 2) & 0x3F;
  $B371   HLdash++;
  $B372   if (current_door & (1<<7)) { HLdash -= 8; } // unsure if this flag is gates_and_doors_LOCKED
  $B380   transition(); return; // exit via // with banked registers...

  $B383   next: -
  $B384   HL++;
  $B385 }

; -----------------------------------------------------------------------------

c $B387 action_red_cross_parcel
D $B387 Player has tried to open the red cross parcel.
  $B387 item_structs[item_RED_CROSS_PARCEL].room = itemstruct_ROOM_MASK; // room_NONE & 0x3F;
  $B38C HL = &items_held;
  $B38F if (*HL != item_RED_CROSS_PARCEL) HL++; // one or the other must be a red cross parcel item
  $B395 *HL = item_NONE; // no longer have parcel (we assume one slot or the other has it)
  $B397 draw_all_items();
  $B39A A = red_cross_parcel_current_contents;
  $B39D drop_item_A();
  $B3A0 queue_message_for_display(message_YOU_OPEN_THE_BOX);
  $B3A5 increase_morale_by_10_score_by_50(); return; // exit via

; -----------------------------------------------------------------------------

c $B3A8 action_bribe
D $B3A8 Player has tried to bribe a prisoner.
D $B3A8 This searches visible characters only.
  $B3A8 HL = $8020; // iterate over non-player characters
  $B3AB B = 7; // 7 iterations
  $B3AD do { A = *HL;
  $B3AE   if ((A != character_NONE) && (A >= character_20_prisoner)) goto found;
  $B3B6   HL += 32; // sizeof a character struct
  $B3BA } while (--B);
  $B3BC return;

  $B3BD found: bribed_character = A;
  $B3C0 HL[1] = 1; // $8021 etc. // room index? room_1_hut1right
  $B3C3 return;

; -----------------------------------------------------------------------------

c $B3C4 action_poison
  $B3C4 Load items_held.
  $B3C7 Load item_FOOD.
  $B3C9 Is 'low' slot item_FOOD?
  $B3CA Yes - goto have_food.
  $B3CC Is 'high' slot item_FOOD?
  $B3CD No - return.
  $B3CE have_food: (test a character flag?)
  $B3D1 Bit 5 set?
  $B3D3 Yes - return.
  $B3D4 Set bit 5.
  $B3D6 Set item_attribute: FOOD to bright-purple/black.
  $B3DB draw_all_items()
  $B3DE goto increase_morale_by_10_score_by_50

; -----------------------------------------------------------------------------

c $B3E1 action_uniform
  $B3E1 HL = $8015; // current character sprite set
  $B3E4 DE = &sprite_guard_tl_4;
  $B3E7 if (*HL == E) return; // cheap equality test // already in uniform
  $B3EA if (room_index >= room_29_secondtunnelstart) return; // can't don uniform when in a tunnel
  $B3F0 *HL++ = E;
  $B3F1 *HL = D;
  $B3F3 increase_morale_by_10_score_by_50(); return;

; -----------------------------------------------------------------------------

c $B3F6 action_shovel
D $B3F6 Player has tried to use the shovel item.
  $B3F6 if (room_index != room_50_blocked_tunnel) return;
  $B3FC if (roomdefn_50_blockage == 255) return; // blockage already cleared
  $B402 roomdefn_50_blockage = 255;
  $B407 roomdefn_50_collapsed_tunnel_obj = 0; // remove blockage graphic
  $B40B setup_room();
  $B40E choose_game_screen_attributes();
  $B411 plot_indoor_tiles();
  $B414 increase_morale_by_10_score_by_50(); return; // exit via

; -----------------------------------------------------------------------------

c $B417 action_wiresnips
  $B417 HL = &fences[0] + 3;
  $B41A DE = &player_map_position.x;
  $B41D B = 4; // iterations
  $B41F do { ...
  $B420   A = *DE;
  $B421   if (A >= *HL) goto continue;
  $B424   HL--;
  $B425   if (A < *HL) goto continue;
  $B428   DE--; // &player_map_position.y;
  $B429   A = *DE;
  $B42A   HL--;
  $B42B   if (A == *HL) goto set_to_4;
  $B42E   A--;
  $B42F   if (A == *HL) goto set_to_6;
  $B432   DE++; // reset to Y
  $B433   continue: ...
  $B434   HL += 6; // array stride
  $B43B } while (--B);
;
  $B43D DE--; // &player_map_position.y;
  $B43E HL -= 3; // pointing to $B59E
  $B441 B = 3; // iterations
  $B443 do { ...
  $B444   A = *DE;
  $B445   if (A < *HL) goto continue2;
  $B448   HL++;
  $B449   if (A >= *HL) goto continue2;
  $B44C   DE++;
  $B44D   A = *DE;
  $B44E   HL++;
  $B44F   if (A == *HL) goto set_to_5;
  $B452   A--;
  $B453   if (A == *HL) goto set_to_7;
  $B456   DE--;
  $B457   continue2: ...
  $B458   HL += 6; // array stride
  $B45F } while (--B);
  $B461 return;
;
; i can see the first 7 entries in the table are used, but what about the remaining 5?
;
  $B466 set_to_4: A = 4; goto action_wiresnips_tail; // crawl TL
  $B466 set_to_5: A = 5; goto action_wiresnips_tail; // crawl TR
  $B46A set_to_6: A = 6; goto action_wiresnips_tail; // crawl BR
  $B46E set_to_7: A = 7;                             // crawl BL
  $B470 action_wiresnips_tail: ...
  $B471 $800E = A;
  $B475 $800D = 0x80;
  $B478 $8001 = 2;
  $B47D $8013 = 12; // set vertical offset
  $B482 $8015 = sprite_prisoner_tl_4;
  $B488 player_locked_out_until = game_counter + 96;
  $B490 queue_message_for_display(message_CUTTING_THE_WIRE);

; -----------------------------------------------------------------------------

c $B495 action_lockpick
  $B495 open_door();
  $B498 if (!Z) return; // wrong door?
  $B499 ptr_to_door_being_lockpicked = HL;
  $B49C player_locked_out_until = game_counter + 0xFF;
  $B4A4 ($8001) = vischar_BYTE1_PICKING_LOCK;
  $B4A9 queue_message_for_display(message_PICKING_THE_LOCK);

; -----------------------------------------------------------------------------

c $B4AE action_red_key
  $B4AE A = room_22_redkey;
  $B4B0 goto action_key;

; -----------------------------------------------------------------------------

c $B4B2 action_yellow_key
  $B4B2 A = room_13_corridor;
  $B4B4 goto action_key;

; -----------------------------------------------------------------------------

c $B4B6 action_green_key
  $B4B6 A = room_14_torch;
;
; fallthrough

; -----------------------------------------------------------------------------

c $B4B8 action_key
D $B4B8 Common end of action_*_key routines.
R $B4B8 I:A Room number the key is for.
  $B4B8 PUSH AF
  $B4B9 open_door();
  $B4BC POP BC
  $B4BD if (!Z) return; // wrong door?
  $B4BE A = *HL & ~gates_and_doors_LOCKED; // mask off locked flag
  $B4C1 if (A != B) {
  $B4C2   B = message_INCORRECT_KEY; }
  $B4C4 else {
  $B4C6   *HL &= ~gates_and_doors_LOCKED; // clear the locked flag
  $B4C8   increase_morale_by_10_score_by_50();
  $B4CB   B = message_IT_IS_OPEN; }
  $B4CD queue_message_for_display(B);
;
; fallthrough

; -----------------------------------------------------------------------------

c $B4D0 open_door
  $B4D0 if (room_index == 0) goto outdoors; else goto indoors;

; needless jump here
  $B4D9 outdoors: B = 5; // 5 iterations (they must overlap)
  $B4DB HL = &gates_flags;
  $B4DE do { A = *HL & ~gates_and_doors_LOCKED;
  $B4E1   EXX
  $B4E2   get_door_position();
  $B4E5   PUSH HL
  $B4E6   door_in_range();
  $B4E9   POP HL
  $B4EA   if (!C) goto return_zero; // in range
  $B4EC   HL += 4;
  $B4F0   door_in_range();
  $B4F3   if (!C) goto return_zero; // in range
  $B4F5   EXX
  $B4F6   HL++;
  $B4F7 } while (--B);
  $B4F9 return;

  $B4FA return_zero: EXX
  $B4FB A = 0; // ok
  $B4FC return;

  $B4FD indoors: HL = &door_flags;
  $B500 B = 8; // 8 iterations
  $B502 do { C = *HL & ~gates_and_doors_LOCKED;
D $B506 Search door_related for C.
  $B506   DE = &door_related;
  $B509   for (;;) { A = *DE;
  $B50A     if (A != 0xFF) {
  $B50E       if ((A & 0x7F) == C) goto found; // 0x7F is likely ~gates_and_doors_LOCKED but unsure
  $B513       DE++; } }
  $B516   HL++;
  $B517 } while (--B);
  $B519 A |= 1; // not ok
  $B51B return;

  $B51C found: A = *DE;
  $B51D EXX
  $B51E get_door_position();
  $B521 HL++;
  $B522 EX DE,HL
D $B523 Range check pattern (-3..+3).
  $B523 HL = &saved_Y;
  $B526 B = 2; // 2 iterations
  $B528 do { if (*HL <= *DE - 3 || *HL > *DE + 3) goto exx_next;
  $B533   HL += 2;
  $B535   DE++;
  $B536 } while (--B);
  $B538 EXX
  $B539 A = 0; // ok
  $B53A return;

  $B53B exx_next: EXX
  $B53C goto next;

; ------------------------------------------------------------------------------

b $B53E walls
D $B53E Boundaries.
  $B53E,6
  $B544,6
  $B54A,6
  $B550,6
  $B556,6
  $B55C,6
  $B562,6
  $B568,6
  $B56E,6
  $B574,6
  $B57A,6
  $B580,6

; ------------------------------------------------------------------------------

b $B586 fences
D $B586 Boundaries.
  $B586,6
  $B58C,6
  $B592,6
  $B598,6
  $B59E,6
  $B5A4,6
  $B5AA,6
  $B5B0,6
  $B5B6,6
  $B5BC,6
  $B5C2,6
  $B5C8,6

; -----------------------------------------------------------------------------

c $B5CE called_from_main_loop_9
  $B5CE B = 8;
  $B5D0 IY = $8000;
  $B5D4 do { if (IY[1] == vischar_BYTE1_EMPTY_SLOT) goto next; // $8001 flags
  $B5DC   PUSH BC
  $B5DD   IY[1] |= vischar_BYTE1_BIT7;
  $B5E1   if (IY[0x0D] & vischar_BYTE13_BIT7) goto byte13bit7set; // $800D
  $B5E8   H = IY[0x0B];
  $B5EB   L = IY[0x0A];
  $B5EE   A = IY[0x0C];
  $B5F1   if (!even_parity(A)) {
  $B5F5     A &= vischar_BYTE12_MASK;
  $B5F7     if (A == 0) goto snozzle;
  $B5FA     HL += (A + 1) * 4 - 1;
  $B602     A = *HL++;
  $B603     EX AF,AF'
;
  $B605     resume1: EX DE,HL
  $B606     L = IY[0x0F]; // Y axis
  $B609     H = IY[0x10];
  $B60C     A = *DE; // sampled DE = $CF9A, $CF9E, $CFBE, $CFC2, $CFB2, $CFB6, $CFA6, $CFAA (character_related_data)
  $B60D     C = A;
  $B60E     A &= 0x80;
  $B610     if (A) A = 0xFF;
  $B614     B = A;
  $B615     HL -= BC;
  $B617     saved_Y = HL;
  $B61A     DE++;
  $B61B     L = IY[0x11]; // X axis
  $B61E     H = IY[0x12];
  $B621     A = *DE;
  $B622     C = A;
  $B623     A &= 0x80;
  $B625     if (A) A = 0xFF;
  $B629     B = A;
  $B62A     HL -= BC;
  $B62C     saved_X = HL;
  $B62F     DE++;
  $B630     L = IY[0x13]; // vertical offset
  $B633     H = IY[0x14];
  $B636     A = *DE;
  $B637     C = A;
  $B638     A &= 0x80;
  $B63A     if (A) A = 0xFF;
  $B63E     B = A;
  $B63F     HL -= BC;
  $B641     saved_VO = HL;
  $B644     sub_AF8F();
  $B647     if (!Z) goto pop_next;
  $B64A     IY[0x0C]--;
  $B64D   }
  $B64F   else { if (A == *HL) goto snozzle;
  $B653     HL += (A + 1) * 4;
;
  $B65A     resume2: EX DE,HL
  $B65B     A = *DE;
  $B65C     L = A;
  $B65D     A &= 0x80;
  $B65F     if (A) A = 0xFF;
  $B663     H = A;
  $B664     C = IY[0x0F]; // Y axis
  $B667     B = IY[0x10];
  $B66A     HL += BC;
  $B66B     saved_Y = HL;
  $B66E     DE++;
  $B66F     A = *DE;
  $B670     L = A;
  $B671     A &= 0x80;
  $B673     if (A) A = 0xFF;
  $B677     H = A;
  $B678     C = IY[0x11]; // X axis
  $B67B     B = IY[0x12];
  $B67E     HL += BC;
  $B67F     saved_X = HL;
  $B682     DE++;
  $B683     A = *DE;
  $B684     L = A;
  $B685     A &= 0x80;
  $B687     if (A) A = 0xFF;
  $B68B     H = A;
  $B68C     C = IY[0x13]; // vertical offset
  $B68F     B = IY[0x14];
  $B692     HL += BC;
  $B693     saved_VO = HL;
  $B696     DE++;
  $B697     A = *DE;
  $B698     EX AF,AF'
  $B699     sub_AF8F();
  $B69C     if (!Z) goto pop_next;
  $B69F     IY[0x0C]++; }
  $B6A2   HL = IY;
  $B6A5   reset_position:$B729();
;
  $B6A8   pop_next: POP BC
  $B6A9   if (IY[1] != vischar_BYTE1_EMPTY_SLOT) IY[1] &= ~vischar_BYTE1_BIT7; // $8001
;
  $B6B4   next: DE = 32; // stride
  $B6B7   IY += DE;
  $B6B9 } while (--B);
  $B6BD return;

  $B6BE byte13bit7set: IY[0x0D] &= ~vischar_BYTE13_BIT7; // sampled IY = $8020, $80A0, $8060, $80E0, $8080,
;
  $B6C2 snozzle: A = byte_CDAA[IY[0x0E] * 9 + IY[0x0D]];
  $B6D5 C = A;
  $B6D6 L = IY[0x08];
  $B6D9 H = IY[0x09];
  $B6DC HL += A * 2;
  $B6DF E = *HL++;
  $B6E1 IY[0x0A] = E;
  $B6E4 D = *HL;
  $B6E5 IY[0x0B] = D;
  $B6E8 if ((C & (1<<7)) == 0) {
  $B6EC   IY[0x0C] = 0;
  $B6F0   DE += 2;
  $B6F2   IY[0x0E] = *DE;
  $B6F6   DE += 2;
  $B6F8   EX DE,HL
  $B6F9   goto resume2; }
  $B6FC else { A = *DE;
  $B6FD   C = A;
  $B6FE   IY[0x0C] = A | 0x80;
  $B703   IY[0x0E] = *++DE;
  $B708   DE += 3;
  $B70B   PUSH DE
  $B70C   EX DE,HL
  $B70D   HL += C * 4 - 1;
  $B715   A = *HL;
  $B716   EX AF,AF'
  $B717   POP HL
  $B718   goto resume1; }

; -----------------------------------------------------------------------------

c $B71B reset_position
D $B71B Save a copy of the vischar's position + offset.
R $B71B I:HL Pointer to vischar.
  $B71B -
  $B71C memcpy(&saved_Y, HL + 0x0F, 6);
  $B728 -

; This entry point is used by the routine at #R$B5CE.
  $B729 -
  $B72A HL += 0x18;
  $B72E DE = saved_X + 0x0200;
  $B735 -
  $B739 -
  $B73A DE = (DE - saved_Y) * 2;
  $B73D -
  $B73E *HL++ = E;
  $B740 *HL++ = D;
  $B742 -
  $B743 DE = 0x0800 - saved_Y - saved_VO - saved_X;
  $B755 -
  $B756 *HL++ = E;
  $B758 *HL = D;
  $B759 return;

; -----------------------------------------------------------------------------

c $B75A reset_game
D $B75A Discover all items.
  $B75A B = 16; C = 0;
  $B75D do { -
  $B75E   item_discovered(C); // pass C as C
  $B761   -
  $B762   C++;
  $B763 } while (--B);
D $B765 Reset message queue.
  $B765 message_queue_pointer = message_queue + 2;
  $B76B reset_map_and_characters();
  $B76E $8001 = 0;
D $B772 Reset score.
  $B772 HL = &score_digits[0];
  $B775 B = 10; // iterations
  $B777 do { *HL++ = 0;
  $B779 } while (--B); // could do a memset
D $B77B Reset morale.
  $B77B morale = morale_MAX;
  $B77D plot_score();
D $B780 Reset items.
  $B780 items_held = (item_NONE) | (item_NONE << 8);
  $B786 draw_all_items();
D $B789 Reset sprite.
  $B789 $8015 = sprite_prisoner_tl_4;
  $B78F room_index = room_2_hut2left;
  $B794 player_sleeps();
  $B797 enter_room();
  $B79A return;

; -----------------------------------------------------------------------------

c $B79B reset_map_and_characters
D $B79B Resets all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, locks the gates, resets all beds, clears the mess halls and resets characters.
  $B79B B = 7; // iterations
  $B79D HL = $8020; // iterate over non-player characters
  $B7A0 do {
  $B7A2   reset_visible_character();
  $B7A6   HL += 32;
  $B7AB } while (--B);
  $B7AD clock = 7;
  $B7B2 day_or_night = 0;
  $B7B6 ($8001) = 0; // flags
  $B7B9 collapsed_tunnel_obj = interiorobject_COLLAPSED_TUNNEL;
  $B7BE blockage = 0x34;
D $B7C3 Lock the gates.
  $B7C3 HL = &gates_and_doors[0];
  $B7C6 B = 9; // 9 iterations
  $B7C8 do { *HL++ |= gates_and_doors_LOCKED;
  $B7CB } while (--B);
D $B7CD Reset all beds.
  $B7CD B = 6; // iterations
  $B7CF HL = &beds[0];
  $B7D4 do { E = *HL++;
  $B7D6   D = *HL++;
  $B7D8   *DE = interiorobject_OCCUPIED_BED;
  $B7D9 } while (--B);
D $B7DB Clear the mess halls.
  $B7DB roomdef_23_breakfast.bench_A = interiorobject_EMPTY_BENCH;
  $B7E0 roomdef_23_breakfast.bench_B = interiorobject_EMPTY_BENCH;
  $B7E3 roomdef_23_breakfast.bench_C = interiorobject_EMPTY_BENCH;
  $B7E6 roomdef_25_breakfast.bench_D = interiorobject_EMPTY_BENCH;
  $B7E9 roomdef_25_breakfast.bench_E = interiorobject_EMPTY_BENCH;
  $B7EC roomdef_25_breakfast.bench_F = interiorobject_EMPTY_BENCH;
  $B7EF roomdef_25_breakfast.bench_G = interiorobject_EMPTY_BENCH;
D $B7F2 Reset characters 12..15 and 20..25.
  $B7F2 DE = &character_structs[12].BYTE1;
  $B7F5 C = 10; // iterations
  $B7F7 HL = &character_reset_data[0];
  $B7FA do { memcpy(DE, HL, 3); DE += 3; HL += 3;
  $B803   *DE++ = 0x12; // reset to 0x12 but the initial data is 0x18
  $B806   *DE++ = 0x00;
  $B809   DE += 2;
  $B80C   if (C == 7) DE = &character_structs[20].BYTE1;
  $B814 } while (--C);
  $B818 return;

; ------------------------------------------------------------------------------

b $B819 character_reset_data
D $B819 10 x 3-byte structs
D $B819 struct { byte room; byte y; byte x; }; // partial of character_struct
  $B819,3 { room_3_hut2right, 40,60 }, // for character 12
  $B81C,3 { room_3_hut2right, 36,48 }, // for character 13
  $B81F,3 { room_5_hut3right, 40,60 }, // for character 14
  $B822,3 { room_5_hut3right, 36,34 }, // for character 15
  $B825,3 { room_NONE,        52,60 }, // for character 20
  $B828,3 { room_NONE,        52,44 }, // for character 21
  $B82B,3 { room_NONE,        52,28 }, // for character 22
  $B82E,3 { room_NONE,        52,60 }, // for character 23
  $B831,3 { room_NONE,        52,44 }, // for character 24
  $B834,3 { room_NONE,        52,28 }, // for character 25

; $766E is 2, but reset_map_and_characters resets it to 3 (the only byte the
; differs between the default character data and the character_reset_data). Bug?
; Significant?

; ------------------------------------------------------------------------------

b $B837 byte_B837
b $B838 byte_B838
w $B839 word_B839
; might be better as two bytes

; -----------------------------------------------------------------------------

c $B83B searchlight_sub
R $B83B I:IY Pointer to vischar?
  $B83B HL = IY;
  $B83E if (L) return; // skip non-player character
  $B841 HL = $8131;
  $B844 BC = 0x0804; // 8 iterations, C is ?
  $B847 do { if (*HL != 0) goto $B860;
  $B84B   HL += 4;
  $B84F } while (--B);
  $B851 HL = &searchlight_state;
  $B854 (*HL)--;
  $B855 if (0xFF != *HL) return;
  $B859 choose_game_screen_attributes();
  $B85C set_game_screen_attributes();
  $B85F return;

  $B860 searchlight_state = searchlight_STATE_1F;
  $B865 return;

; -----------------------------------------------------------------------------

c $B866 searchlight
D $B866 searchlight related.
  $B866 sub_B89C();
  $B869 if (!Z) return;
  $B86A if ((A & (1<<6)) == 0) {
  $B86E   setup_sprite_plotting();
  $B871   if (!Z) goto searchlight;
  $B873   suspected_mask_stuff();
  $B876   if (searchlight_state != searchlight_STATE_OFF) searchlight_sub();
  $B87E   A = IY[0x1E];
  $B881   if (A != 3) {
  $B885     masked_sprite_plotter_24_wide();
  $B888     goto searchlight; }
  $B88A   if (Z) masked_sprite_plotter_16_wide_case_1(); // odd to test for Z since it's always set
  $B88D   goto searchlight; }
  $B88F else { sub_DC41();
  $B892   if (!Z) goto searchlight;
  $B894   suspected_mask_stuff();
  $B897   masked_sprite_plotter_16_wide_case_1_searchlight();
  $B89A   goto searchlight; }

; -----------------------------------------------------------------------------

c $B89C sub_B89C
D $B89C ...
  $B89C BC = 0;
  $B89F DE = 0;
  $B8A1 A = 0xFF;
  $B8A3 EX AF,AF'
  $B8A4 EXX
  $B8A5 DE = 0;
  $B8A8 BC = 0x0820; // B = 8 iterations, C = stride, 32
  $B8AB HL = $8007; // vischar byte7
  $B8AE do { if ((*HL & vischar_BYTE7_BIT7) == 0) goto next;
  $B8B2   PUSH HL
  $B8B3   PUSH BC
  $B8B4   HL += 8; // $8007 + 8 = $800F
  $B8B8   C = *HL++;
  $B8BA   B = *HL;
  $B8BB   BC += 4;
  $B8BF   PUSH BC
  $B8C0   EXX
  $B8C1   POP HL
  $B8C2   SBC HL,BC
  $B8C4   EXX
  $B8C5   JR C,pop_next
  $B8C7   HL++;
  $B8C8   C = *HL++;
  $B8CA   B = *HL;
  $B8CB   BC += 4;
  $B8CF   PUSH BC
  $B8D0   EXX
  $B8D1   POP HL
  $B8D2   SBC HL,DE
  $B8D4   EXX
  $B8D5   JR C,pop_next
  $B8D7   HL++;
  $B8D8   POP BC
  $B8D9   PUSH BC
  $B8DA   A = 8 - B;
  $B8DD   EX AF,AF'  // unpaired
  $B8DE   E = *HL++;
  $B8E0   D = *HL;
  $B8E1   PUSH HL
  $B8E2   EXX
  $B8E3   POP HL
  $B8E4   L -= 2;
  $B8E6   D = *HL--;
  $B8E8   E = *HL--;
  $B8EA   B = *HL--;
  $B8EC   C = *HL;
  $B8ED   HL -= 15;
  $B8F1   IY = HL;
  $B8F4   EXX
  $B8F5   pop_next: POP BC
  $B8F6   POP HL
  $B8F7   next: HL += C;
  $B8FA } while (--B);
  $B8FC sub_DBEB();
  $B8FF EX AF,AF' // return value
  $B900 if (A & (1<<7)) return;
  $B903 HL = IY;
  $B906 if ((A & (1<<6)) == 0) {
  $B90A   IY[7] &= ~vischar_BYTE7_BIT7;
  $B90E   return; }
  $B90F else { HL[1] &= ~itemstruct_ROOM_FLAG_BIT6;
  $B912   BIT 6,HL[1]  // odd. this tests the bit we've just cleared as if we're setting flags for return. but we can't be as we're followed by another instruction...
  $B915   return; }

; -----------------------------------------------------------------------------

c $B916 suspected_mask_stuff
D $B916 Sets attr of something, checks indoor room index, ...
D $B916 unpacks mask stuff
  $B916 memset($8100, 0xFF, 0xA0);
  $B923 if (room_index) {
  $B929   HL = &suspected_indoor_mask_data;
  $B92C   A = *HL;
  $B92D   if (A == 0) return;
  $B92F   B = A; // iterations
  $B930   HL += 3; }
  $B935 else { B = NELEMS(suspected_outdoor_mask_data); // 59 iterations
  $B937   HL = $EC03; // suspected_outdoor_mask_data + 2 bytes }
R $B93A I:B Iterations (outer loop);
  $B93A do { PUSH BC
  $B93B   PUSH HL
  $B93C   A = map_position_related_1 - 1;
  $B940   if (A >= HL[0] || A + 4 < HL[-1]) goto pop_next;
  $B94B   -
  $B94E   A = map_position_related_2 - 1;
  $B952   if (A >= HL[2] || A + 5 < HL[1]) goto pop_next;
  $B95D   -
  $B95F   if (byte_81B2 <= HL[3]) goto pop_next;
  $B96A   if (byte_81B3 < HL[4]) goto pop_next;
  $B972   A = byte_81B4;
  $B975   if (A) A--;
  $B979   if (A >= HL[5]) goto pop_next;
  $B97D   HL -= 6;
  $B984   A = map_position_related_1;
  $B987   C = A;
  $B988   if (A >= *HL) {
  $B98C     A -= *HL;
  $B98D     byte_B837 = A;
  $B990     HL++;
  $B991     A = *HL - C;
  $B993     if (A >= 3) A = 3;
  $B999     ($B83A) = ++A; // word_B839 + 1 }
  $B99D   else {
  $B99F     B = *HL;
  $B9A0     byte_B837 = 0;
  $B9A4     C = 4 - (B - C);
  $B9AB     HL++;
  $B9AC     A = (*HL - B) + 1;
  $B9AF     if (A > C) A = C;
  $B9B3     ($B83A) = A; // word_B839 + 1 }
  $B9B6   HL++;
  $B9B7   A = map_position_related_2;
  $B9BA   C = A;
  $B9BB   if (A >= *HL) {
  $B9BF     A -= *HL;
  $B9C0     byte_B838 = A;
  $B9C3     A = *++HL - C;
  $B9C6     if (A >= 4) A = 4;
  $B9CC     A++;
  $B9CD     ($B839) = A; }
  $B9D2   else { B = *HL;
  $B9D3     byte_B838 = 0;
  $B9D7     C = 5 - (B - C);
  $B9DE     A = (*++HL - B) + 1;
  $B9E2     if (A >= C) A = C;
  $B9E6     ($B839) = A; }
  $B9E9   HL--;
  $B9EA   BC = 0;
  $B9ED   if (byte_B838 == 0) C = -map_position_related_2 + *HL;
  $B9FA   HL -= 2;
  $B9FC   if (byte_B837 == 0) B = -map_position_related_1 + *HL;
  $BA09   HL--;
  $BA0A   A = *HL;
  $BA0B   -
  $BA0C   Adash = C * 32 + B;
  $BA13   HL = $8100 + Adash;
  $BA18   ($81A0) = HL; // $81A0 is a mystery location
  $BA1B   -
D $BA1C If I break this bit then the character gets drawn on top of *indoors* objects.
  $BA1C   DE = probably_mask_data_pointers[A];
  $BA27   HL = word_B839;
  $BA2A   ($BA70) = L; // self modify
  $BA2E   ($BA72) = H; // self modify
  $BA32   ($BA90) = *DE - H; // self modify // *DE looks like a count
  $BA37   ($BABA) = 32 - H; // self modify
  $BA3D   PUSH DE
  $BA3E   E = *DE;
  $BA40   A = byte_B838;
  $BA43   sub_BACD();
  $BA46   E = byte_B837;
  $BA4A   HL += DE;
  $BA4B   POP DE
  $BA4C   HL++; // iterations
  $BA4D   do { A = *DE; // DE -> $E560 upwards (in probably_mask_data)
  $BA4E     if (!even_parity(A)) { // uneven number of bits set
  $BA52       A &= 0x7F;
  $BA54       DE++;
  $BA55       HL -= A;
  $BA58       if (HL < 0) goto $BA69;
  $BA5A       DE++;
  $BA5B       if (DE) goto $BA4D;
  $BA5D       A = 0;
  $BA5E       goto $BA6C; }

  $BA60     DE++;
  $BA61   } while (--HL);
  $BA67   goto $BA6C;

  $BA69   A = -L;
;
  $BA6C   HL = ($81A0); // mystery
R $BA6F I:C Iterations (inner loop);
  $BA6F   C = 1; // self modified
  $BA71   do { B = 1; // self modified
  $BA73     do { -
  $BA74       Adash = *DE;
  $BA75       Adash &= Adash;
  $BA76       if (!P) {
  $BA79         Adash &= 0x7F;
  $BA7B         -
  $BA7C         DE++;
  $BA7D         A = *DE; }
;
  $BA7E       A &= A;
  $BA7F       if (!Z) mask_against_tile();
  $BA82       L++;
  $BA83       EX AF,AF' // unpaired?
  $BA84       if (A != 0 && --A != 0) DE--;
  $BA8B       DE++;
  $BA8C     } while (--B);
  $BA8E     PUSH BC
  $BA8F     B = 1; // self modified
  $BA91     -
  $BA92     if (B) {
  $BA97       -
  $BA98       if (A) goto $BAA3;
;
  $BA9B       do { A = *DE;
  $BA9C         if (!even_parity(A)) {
  $BAA0         A &= 0x7F;
  $BAA2         DE++;
;
  $BAA3         B -= A;
  $BAA7         if (B < 0) goto $BAB6;
  $BAA9         DE++;
  $BAAA         if (!Z) goto $BA9B;
  $BAAC         EX AF,AF' // why not just jump instr earlier? // bank
  $BAAD         goto $BAB9; }

  $BAAF         DE++;
  $BAB0       } while (--B);
  $BAB2       A = 0;
  $BAB3       EX AF,AF' // why not just jump instr earlier? // bank
  $BAB4       goto $BAB9;

  $BAB6       A = -A;
  $BAB8       EX AF,AF' // bank }
;
  $BAB9     HL += 32; // self modified
  $BABD     EX AF,AF'  // unbank
  $BABE     POP BC
  $BABF   } while (--C);
;
  $BAC3   pop_next: POP HL
  $BAC4   POP BC
  $BAC5   HL += 8;
  $BAC9 } while (--B);
;
; fallthrough

c $BACD sub_BACD
D $BACD Tail end of above routine?
  $BACD B = 8; // iterations
  $BACF HL = 0;
  $BAD2 D = 0; // DE = 8; (unsure why this is reset)
  $BAD3 do { HL += HL;
  $BAD4   RLA  // carry = (A >> 7); A <<= 1;
  $BAD5   if (carry) HL += DE;
  $BAD9 } while (--B);
  $BADB return;

; -----------------------------------------------------------------------------

c $BADC mask_against_tile
D $BADC Masks characters obscured by foreground objects.
R $BADC I:A  Mask tile index.
R $BADC I:HL Pointer to destination.
  $BADC DEdash = HL
  $BADD -
  $BADE HLdash = &tiles[A];
  $BAE8 -
  $BAE9 Bdash = 8; // 8 iterations
  $BAEB do { *DEdash &= *HLdash++;
  $BAEF   DEdash += 4; // stride of 4 => supertile?
  $BAF3 } while (--Bdash);
  $BAF5 -
  $BAF6 return;

; -----------------------------------------------------------------------------

c $BAF7 sub_BAF7
D $BAF7 Sets the flags for return but looks like caller never uses them.
R $BAF7 O:A  0 or 0xFF
R $BAF7 O:DE Return value ?
  $BAF7 HL = &map_position_related_1;
  $BAFA A = map_position[0] + 24;
  $BAFF A -= *HL;
  $BB00 if (A > 0) {
  $BB06   CP IY[30]  // if (A ?? IY[30])
  $BB09   if (carry) {
  $BB0C     BC = A; }
  $BB0F   else {
  $BB11     A = *HL + IY[30];
  $BB15     A -= map_position[0];
  $BB19     if (A <= 0) goto exit;
  $BB1F     CP IY[30]
  $BB22     if (carry) {
  $BB25       C = A;
  $BB26       B = -A + IY[30]; }
  $BB2C     else {
  $BB2E       BC = IY[30]; } }
;
  $BB33   HL = ((map_position >> 8) + 17) * 8;
  $BB3E   E = IY[26];
  $BB41   D = IY[27];
  $BB44   A &= A;
  $BB45   HL -= DE;
  $BB47   if (result <= 0) goto exit;
  $BB4D   if (H) goto exit;
  $BB52   A = L;
  $BB53   CP IY[31]
  $BB56   if (carry) {
  $BB59     DE = A; }
  $BB5C   else {
  $BB5E     HL = IY[31] + DE;
  $BB64     DE = map_position >> 8 * 8;
  $BB6F     A &= A; // likely: clear carry
  $BB70     HL -= DE;
  $BB72     if (result <= 0) goto exit;
  $BB78     if (H) goto exit;
  $BB7D     A = L;
  $BB7E     CP IY[31]
  $BB81     if (carry) {
  $BB84       E = A;
  $BB85       D = -A + IY[31]; }
  $BB8B     else {
  $BB8D       DE = IY[31]; } }
;
  $BB92   A = 0; // return Z
  $BB93   return; }

  $BB94 exit: A = 0xFF;
  $BB96 A &= A; // return NZ
  $BB97 return;

; -----------------------------------------------------------------------------

c $BB98 called_from_main_loop_3
D $BB98 Walks the visible characters array doing ?
  $BB98 B = 8; // iterations
  $BB9A IY = $8000;
  $BB9E do { PUSH BC
  $BB9F   if (IY[1] == room_NONE) goto next;
  $BBA7   map_position_related_2 = (IY[26] >> 3) | (IY[27] << 5); // divide by 8
  $BBB9   map_position_related_1 = (IY[24] >> 3) | (IY[25] << 5); // divide by 8
  $BBCB   sub_BAF7();
  $BBCE   if (A == 0xFF) goto next; // possibly not found case
  $BBD3   A = ((E >> 3) & 31) + 2;
  $BBDB   PUSH AF
  $BBDC   A += map_position_related_2 - ((map_position & 0xFF00) >> 8);
  $BBE4   if (A >= 0) {
  $BBE6     A -= 17;
  $BBE8     if (A > 0) {
  $BBEC       E = A;
  $BBED       POP AF
  $BBEE       A -= E;
  $BBEF       if (carry) goto next;
  $BBF2       if (!Z) goto $BBF8;
  $BBF4       goto next; } }
  $BBF7   POP AF
;
  $BBF8   if (A > 5) A = 5;
  $BC02   ($BC5F) = A; // self modify
  $BC05   A = C;
  $BC06   ($BC61) = A; // self modify
  $BC09   ($BC89) = A; // self modify
  $BC0C   A = 24 - C;
  $BC0F   ($BC8E) = A; // self modify
  $BC12   A += $A8;
  $BC14   ($BC95) = A; // self modify
  $BC17   HL = &map_position;
  $BC1A   A = B;
  $BC1B   A &= A;
  $BC1C   A = 0; // interleaved
  $BC1E   if (Z) {
  $BC20     A = ($81B5);
  $BC23     A -= *HL; }
  $BC24   B = A;
  $BC25   A = D;
  $BC26   A &= A;
  $BC27   A = 0; // interleaved
  $BC29   if (Z) {
  $BC2B     HL++;
  $BC2C     A = ($81B6);
  $BC2F     A -= *HL; }
  $BC30   C = A;
  $BC31   H = C;
  $BC32   A = 0;
  $BC33   SRL H
  $BC35   RRA
  $BC36   E = A;
  $BC37   D = H;
  $BC38   SRL H
  $BC3A   RRA
  $BC3B   L = A;
  $BC3C   HL += DE + B + $F290; // screen buffer start address
  $BC45   EX DE,HL
  $BC46   PUSH BC
  $BC47   -
  $BC48   POP HLdash
  $BC49   -
  $BC4A   A = B;
  $BC4B   HL = C * 24 + A + $F0F8; // visible tiles array
  $BC5D   EX DE,HL
  $BC5E   C = 5;  // self modified
  $BC60   do { B = 4; // iterations // self modified
  $BC62     do { PUSH HL
  $BC63       A = *DE;
  $BC64       -
  $BC65       POP DEdash // visible tiles array pointer
  $BC66       PUSH HLdash
  $BC67       select_tile_set(); // call using banked registers
  $BC6A       HLdash = A * 8 + BCdash;
  $BC71       Bdash, Cdash = 8, 24; // iterations, stride
  $BC74       do { *DEdash = *HLdash++;
  $BC76         DEdash += Cdash;
  $BC7D       } while (--Bdash);
  $BC7F       POP HLdash
  $BC80       Hdash++;
  $BC81       -
  $BC82       DE++;
  $BC83       HL++;
  $BC84     } while (--B);
  $BC86     -
  $BC87     A = Hdash;
  $BC88     A -= 0; // self modified
  $BC8A     Hdash = A;
  $BC8B     Ldash++;
  $BC8C     -
  $BC8D     A = 20; // self modified
  $BC8F     A += E;
  $BC90     if (carry) D++;
  $BC93     E = A;
  $BC94     A = $BC; // self modified
  $BC96     A += L;
  $BC97     if (carry) H++;
  $BC9A     L = A;
  $BC9B   } while (--C);
;
  $BC9F   next: POP BC
  $BCA0   IY += 32; // stride
  $BCA6 } while (--B);
  $BCA9 return;

; -----------------------------------------------------------------------------

c $BCAA select_tile_set
D $BCAA Turn a map ref? into a tile set pointer.
R $BCAA O:BC Pointer to tile set.
R $BCAA O:HL ?
  $BCAA -
  $BCAB if (room_index) {
  $BCB1   BC = &interior_tiles[0];
  $BCB4   -
  $BCB5   return; }

; likely just converts map pos -> index into 7x5 supertile refs array
  $BCB6 else { Adash = (((map_position >> 8) & 3) + L) >> 2;
  $BCBE   L = (Adash & 0x3F) * 7;
  $BCC6   Adash = (((map_position & 0xFF) & 3) + H) >> 2;
  $BCCE   Adash = (Adash & 0x3F) + L;
  $BCD1   Adash = $FF58[Adash]; // 7x5 supertile refs
  $BCD7   BC = &exterior_tiles_1[0];
  $BCDA   if (Adash >= 45) {
  $BCDE     BC = &exterior_tiles_2[0];
  $BCE1     if (Adash >= 139 && Adash < 204) {
  $BCE9       BC = &exterior_tiles_3[0]; } }
  $BCEC   -
  $BCED   return; }

; ------------------------------------------------------------------------------

; Map
;
b $BCEE map_tiles
D $BCEE Map super-tile refs. 54x34. Each byte represents a 32x32 tile.
D $BCEE #CALL:map($BCEE, 54, 34)
  $BCEE,1836,54*34

; The map, with blanks and grass replaced to show the outline more clearly:
;
;                                                                         5F 33 3C 58
;                                                                   5F 33 34 2E 3D 45 3C 58
;                               55 5E 31                         33 34 2B 37 2D 3F 28 48 42 5B 58
;                               82 3E 30 2E 57             33 34 2E 37 2A 2F 2C 41 26 47 43 53 42 3C 57
;                         75 76 81 5E 31 33 3C 5E 31 33 34 2B 35 2D 36 29 .. .. .. .. 49 44 54 43 3D 45 3C 58
;                   75 76 7C 7F 80 3E 30 39 3D 3E 30 2E 35 2A 2F 38 .. .. .. .. .. .. .. .. 41 44 46 27 48 42 5B 58
; 75 76 7A 79 75 76 7C 7F 7E 3A 5D 40 31 3A 3F 40 31 2D 2F 29 .. .. .. .. .. .. .. .. .. .. .. .. 41 26 47 43 53 42 3C 58
; 6A 74 77 78 7B 7F 7E 3A 2F 2C 49 3B 32 2C 41 3B 32 38 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 49 44 54 43 3D 52 59 53
; 63 64 66 6F 7D 3A 2F 38 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 06 07 .. .. .. .. .. .. .. .. 41 44 46 51 5D 58 5A 53
; 65 62 6C 6D 36 2C .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 08 1A .. .. .. .. .. .. .. .. .. 41 44 5C 5B 57 58 5A 53
; 63 64 6B 6E 71 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. .. .. .. .. .. .. 59 53 45 3C 57 58 5A
; 61 62 5A 73 72 70 71 .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07 .. .. .. .. .. .. 55 58 5A 53 45 3C 57
; 49 3B 68    5A 73 72 70 71 .. .. 75 76 7A 79 .. .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. .. .. .. .. 4B 45 3C 58 5A 53 45 45
; .. .. 41 56 68    5A 73 72 70 71 6A 74 84 85 7A 79 .. 0D 0C 0B 17 20 16 15 18 .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. 4A 50 4C 52 5B 58 5A
; .. .. .. .. 49 56 68 69 5A 73 72 63 86 88 74 77 78 .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07 49 44 4D 51 4C 52 3C 58
; .. .. .. .. .. .. 49 67 68 69 5A 65 87 83 64 66 6F .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. 41 44 4E 51 4C 45 3C 58
; .. .. .. .. .. .. .. .. 41 67 68 59 CC CD 62 8A 6D .. .. .. .. .. .. .. 0D 0C 0B 17 20 16 15 18 .. .. 02 03 04 05 09 1C 1B .. .. .. 49 44 4E 28 4C 52 5B 58
; .. .. .. .. .. .. .. .. .. .. 41 89 CE CF D2 D5 6F .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. B9 BA .. 49 26 C8 C9 4C 45 3C 58
; .. .. .. .. .. .. .. B9 BA B1 B1 49 D0 D1 D3 D6 D8 9B 9C .. .. .. .. .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. BB BC BD BE 9D 97 CA CB 4D 28 4C 45
; .. .. .. .. .. .. BB BC BD BE AF B2 B7 93 D4 D7 D9 8E 90 9B 9C .. .. .. .. .. .. .. .. .. 0D 0C 0B 17 20 16 15 18 .. .. .. .. .. C5 C0 97 96 93 95 94 41 26 C8 C9
; .. .. .. .. .. B1 B1 C5 C0 97 96 B3 B5 B6 '' '' 8C 8D 8B 8E 90 9B 9C .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. .. .. .. 9C 9D C6 C2 93 95 94 '' 99 98 97 CA CB
; .. .. .. B1 B1 B0 AF C6 C2 93 95 B4 8B 8E 90 8F '' '' 8C 8D 8B 8E A8 AA 9C .. .. .. .. .. 10 11 13 18 .. .. .. .. .. 9C 9D 97 96 C7 C4 94 '' 99 98 97 96 93 95 94
; .. .. B1 B0 AF 97 96 C7 C4 94 '' B8 8C 8D 8B 8E 90 8F '' '' 8C 8D A7 A6 90 9B 9C .. .. .. .. .. .. .. .. .. .. 9C 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. ..
; .. .. B0 B2 B7 93 95 94 '' '' '' '' '' '' 8C 8D 8B 8E A8 A9 '' '' A5 A4 8B 8E 90 9B 9C .. .. B9 BA .. .. 9C 9D 97 96 93 95 94 B8 99 98 97 96 93 95 94 .. .. .. ..
; .. .. B0 B3 B5 B6 '' '' '' '' '' '' '' '' '' '' 8C 8D A7 A6 90 8F '' '' 8C 8D 8B 8E 90 9B BB BC BD BE 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. ..
; .. .. B1 B4 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' A5 A4 8B 8E 90 8F '' '' 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. ..
; .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' 8C 8D AB AC 90 8F '' '' 8C 8D 8B C1 C2 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' B9 BA '' '' 99 98 97 AD AE 8B 8E 90 8F '' '' 8C C3 C4 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 8F BB BC BD BE 98 97 96 93 95 94 8C 8D 8B 8E 90 8F '' '' '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 .. .. .. .. 8C 8D 8B 8E 90 A2 A3 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B C1 C2 93 95 94 .. .. .. .. .. .. .. .. 8C 8D 8B A0 A1 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C C3 C4 94 .. .. .. .. .. .. .. .. .. .. .. .. 8C 9F 9E 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..

; Map tile stats:
;
; L = left facing, R = right facing
;
; Unused: 4F, 9A, DA..FF
;
;   3x00 (hut)
;   3x01 (hut)
;   9x02 (hut)
;   9x03 (hut)
;   9x04 (hut)
;   9x05 (hut)
;   3x06 (hut)
;   3x07 (hut)
;   3x08 (hut)
;   3x09 (hut)
;   6x0A (hut)
;   3x0B (hut)
;   3x0C (hut)
;   3x0D (hut)
;   3x0E (hut)
;   3x0F (hut)
;   3x10 (hut)
;   3x11 (hut)
;   3x12 (hut)
;   3x13 (hut)
;   3x14 (hut)
;   6x15 (hut)
;   9x16 (hut)
;   6x17 (hut)
;   9x18 (hut)
;   3x19 (hut)
;   3x1A (hut)
;   3x1B (hut)
;   3x1C (hut)
;   3x1D (hut)
;   3x1E (hut)
;   3x1F (hut)
;   3x20 (hut)
;   3x21 (hut)
;   3x22 (hut)
; 226x23 (grass 1)
; 198x24 (grass 2)
; 192x25 (grass 3)
;   4x26 L (lower door)
;   1x27 L (upper door, with coat of arms)
;   3x28 L (upper door)
;   2x29 R (lower door)
;   2x2A R (upper door)
;   2x2B R (upper upper door + barb wire)
;   4x2C R (ground level wall)
;   3x2D R (lower window)
;   4x2E R (upper window)
;   5x2F R (ground level wall)
;   3x30
;   5x31 R (left edge wall)
;   2x32
;   6x33 R (lower window + barb wire)
;   4x34 R (barb wire + lamp)
;   2x35 R (upper wall + brickwork + lamp)
;   2x36 R (high ground level wall + brickwork)
;   2x37 R (upper wall + brickwork + lamp)
;   3x38 R (low ground level wall + brickwork)
;   1x39
;   4x3A
;   3x3B L (ground level wall)
;  12x3C L (ground level wall)
;   4x3D
;   3x3E
;   2x3F
;   2x40
;  11x41 L (ground level wall)
;   4x42 L
;   4x43 L
;   8x44 L
;  10x45 L (barb wire)
;   2x46
;   2x47
;   2x48
;  10x49 L (ground level wall)
;   1x4A
;   1x4B
;   6x4C
;   2x4D
;   2x4E
;    (4F unused)
;   1x50
;   3x51
;   4x52
;   8x53 L
;   2x54 L
;   2x55
;   2x56 L (ground level wall)
;   5x57 L (bricks)
;  16x58 L (high bottom window)
;   3x59
;  11x5A L (dual lamps + bricks)
;   5x5B
;   1x5C
;   2x5D
;   3x5E
;   2x5F
; 303x60 (blank)
;   1x61
;   3x62
;   3x63
;   3x64
;   2x65
;   2x66
;   2x67
;   5x68
;   2x69
;   2x6A
;   1x6B
;   1x6C
;   2x6D
;   1x6E
;   3x6F
;   3x70 L
;   4x71 L
;   4x72 L
;   4x73 L
;   3x74 (roof hatch - left of pair)
;   5x75 R
;   5x76 R
;   2x77 (roof hatch - right of pair + top wall)
;   2x78 R (top wall right edge)
;   3x79
;   3x7A
;   1x7B
;   2x7C R
;   1x7D R
;   2x7E R
;   3x7F R
;   1x80
;   1x81
;   1x82
;   1x83
;   1x84 (roof hatch - right of pair)
;   1x85
;   1x86
;   1x87
;   1x88
;   1x89
;   1x8A
;  20x8B (fence)
;  21x8C (fence)
;  18x8D (fence)
;  18x8E (upper fence)
;  11x8F (upper fence + pole + on long grass)
;  19x90 (upper fence + on long grass)
;  37x91 (grass)
;  31x92 (grass)
;  23x93 R (fence)
;  26x94 R (fence)
;  22x95 R (fence)
;  19x96 R (fence)
;  22x97 R (fence)
;  11x98 R (fence)
;  10x99 R (fence)
;    (9A unused)
;   6x9B L (top fence + pole)
;  10x9C L (top fence + on grass)
;   6x9D
;   1x9E
;   1x9F
;   1xA0
;   1xA1
;   1xA2
;   1xA3
;   2xA4 L (gate)
;   2xA5 L (gate)
;   2xA6 L (gate)
;   2xA7 L (gate)
;   2xA8 L (gate)
;   1xA9 L (gate)
;   1xAA L (gate)
;   1xAB
;   1xAC
;   1xAD
;   1xAE
;   3xAF
;   4xB0
;   8xB1
;   2xB2
;   2xB3
;   2xB4
;   2xB5
;   2xB6
;   2xB7
;   2xB8 (tunnel entrance)
;   4xB9 (tower)
;   4xBA (tower)
;   4xBB (tower)
;   4xBC (tower)
;   4xBD (tower)
;   4xBE (tower)
;   2xBF (tower + fence)
;   4xC0 (tower + fence)
;   2xC1 (tower + fence)
;   4xC2 (tower + fence)
;   2xC3 (tower + fence)
;   4xC4 (tower + fence)
;   2xC5 (tower + fence)
;   2xC6 (tower + fence)
;   2xC7 (tower + fence)
;   2xC8
;   2xC9
;   2xCA
;   2xCB
;   1xCC
;   1xCD
;   1xCE
;   1xCF
;   1xD0
;   1xD1
;   1xD2
;   1xD3
;   1xD4
;   1xD5
;   1xD6
;   1xD7
;   1xD8
;   1xD9

; ------------------------------------------------------------------------------

w $C41A word_C41A
D $C41A [unknown] (<- get_A_indexed_by_C41A)

; -----------------------------------------------------------------------------

; seems to move characters around, or perhaps just spawn them

c $C41C called_from_main_loop_7
;
D $C41C Form a map position in DE.
  $C41C HL = map_position;
  $C41F E = (L < 8) ? 0 : L;
  $C426 D = (H < 8) ? 0 : H;
;
D $C42D Walk all character structs.
  $C42D HL = &character_structs[0];
  $C430 B = character_26_stove1; // the 26 'real' characters
  $C432 do { if (*HL & characterstruct_BYTE0_BIT6) goto skip;
;
  $C436   (stash HL)
  $C437   HL++; // $7613
  $C438   A = room_index;
  $C43B   if (A != *HL) goto unstash_skip; // not in the visible room
  $C43E   if (A != 0) goto done_outdoors;
;
D $C441   Outdoors.
  $C441   HL++; // $7614
  $C442   A -= *HL; // A always starts as zero here
  $C443   HL++; // $7615
  $C444   A -= *HL;
  $C445   HL++; // $7616
  $C446   A -= *HL;
  $C447   C = A;
  $C448   A = D;
  $C449   if (C <= A) goto unstash_skip; // check
  $C44C   A += 32;
  $C44E   if (A > 0xFF) A = 0xFF;
  $C452   if (C > A) goto unstash_skip; // check
;
  $C455   HL--; // $7615
  $C456   A = 64;
  $C458   *HL += A;
  $C459   HL--; // $7614
  $C45A   *HL -= A;
  $C45B   A *= 2; // A == 128
  $C45C   C = A;
  $C45D   A = E;
  $C45E   if (C <= A) goto unstash_skip; // check
  $C461   A += 40;
  $C463   if (A > 0xFF) A = 0xFF;
  $C467   if (C > A) goto unstash_skip; // check
;
  $C46A   done_outdoors: (unstash HL)
  $C46B   (stash HL, DE, BC)
  $C46E   sub_C4E0();
  $C471   (unstash BC, DE)
;
  $C473   unstash_skip: (unstash HL)
  $C474   skip: HL += 7; // stride
  $C47B } while (--B);
  $C47D return;

; -----------------------------------------------------------------------------

c $C47E called_from_main_loop_6
D $C47E Run through all visible characters, resetting them.
  $C47E HL = &map_position;
  $C481 E = MAX(L - 9, 0);
  $C488 D = MAX(H - 9, 0);
;
  $C48F B = 7; // 7 iterations
  $C491 HL = $8020; // iterate over non-player characters
  $C494 do { A = *HL;
  $C495   if (A == 255) goto next; // no character?
  $C49A   PUSH HL
  $C49B   HL += 28;
  $C49F   if (room_index != *HL) goto reset; // character not in room
;
  $C4A5   C = *--HL;
  $C4A7   A = *--HL;
  $C4A9   divide_by_8_with_rounding(C,A);
  $C4AC   C = A;
  $C4AD   if (C <= D || C > MIN(D + 34, 255)) goto reset;
;
  $C4BA   C = *--HL;
  $C4BC   A = *--HL;
  $C4BE   divide_by_8(C,A);
  $C4C1   C = A;
  $C4C2   if (C <= E || C > MIN(E + 42, 255)) goto reset;
  $C4C6   goto pop_next;
;
  $C4CF   reset: POP HL
  $C4D0   PUSH HL
  $C4D1   PUSH DE
  $C4D2   PUSH BC
  $C4D3   reset_visible_character();
  $C4D6   POP BC
  $C4D7   POP DE
;
  $C4D8   pop_next: POP HL
;
  $C4D9   next: HL += 32;
  $C4DD } while (--B);
  $C4DF return;

; -----------------------------------------------------------------------------

c $C4E0 sub_C4E0
D $C4E0 Spawns characters? / Adds characters to the visible character list.
R $C4E0 I:HL Pointer to characterstruct.  // e.g. $766D
  $C4E0 if (*HL & characterstruct_BYTE0_BIT6) return;
;
  $C4E3 PUSH HL
  $C4E4 HL = $8020; // iterate over non-player characters
  $C4E7 -
  $C4EA -
  $C4EC B = 7; // 7 iterations
  $C4EE do { if (*HL == vischar_BYTE0_EMPTY_SLOT) goto found; // empty slot found?
  $C4F1   HL += 32; // stride
  $C4F2 } while (--B);
  $C4F4 POP HL
  $C4F5 return;

  $C4F6 found: POP DE  // DE = HL (-> visible character list)
  $C4F7 PUSH HL // resave
  $C4F8 POP IY  // IY = HL (-> visible character list)
  $C4FA PUSH HL // resave
  $C4FB PUSH DE
  $C4FC DE++; // $8021 etc.
  $C4FD HL = &saved_Y;
  $C500 A = *DE++;
  $C502 A &= A;
  $C503 if (A == 0) {
  $C505   A = 3; // 3 iterations
  $C507   do {
  $C508     BC = *DE * 8;
  $C50C     *HL++ = C;
  $C50E     *HL++ = B;
  $C510     DE++;
  $C511     -
  $C512   } while (--A); }
  $C516 else {
  $C518 B = 3; // 3 iterations
  $C51A do { *HL++ = *DE++;
  $C51E   *HL++ = 0;
  $C521 } while (--B); }
;
  $C523 sub_AFDF();
  $C526 if (Z) bounds_check();
  $C529 POP DE
  $C52A POP HL
  $C52B RET NZ
;
  $C52C A = *DE | characterstruct_BYTE0_BIT6; // likely: disable character
  $C52F *DE = A;
  $C530 A &= characterstruct_BYTE0_MASK;
  $C532 *HL++ = A;
  $C534 *HL = 0;
  $C536 PUSH DE
  $C537 DE = &character_meta_data[0]; // commandant
  $C53A if (A) {
  $C53D   DE = &character_meta_data[1]; // guard
  $C540   if (A >= 16) {
  $C544     DE = &character_meta_data[2]; // dog
  $C547     if (A >= 20) {
  $C54B       DE = &character_meta_data[3]; } } } // prisoner
  $C54E EX DE,HL
  $C54F DE += 7;
  $C553 *DE++ = *HL++;
  $C555 *DE++ = *HL++;
  $C557 DE += 11;
  $C55B *DE++ = *HL++;
  $C55D *DE++ = *HL++;
  $C55F DE -= 8;
  $C563 memcpy(DE, &saved_Y, 6);
  $C56B POP HL
  $C56C HL += 5;
  $C571 DE += 7;
  $C575 A = room_index;
  $C578 *DE = A;
  $C579 if (A) {
  $C57C   play_speaker(sound_CHARACTER_ENTERS_2);
  $C582   play_speaker(sound_CHARACTER_ENTERS_1); }
  $C588 DE -= 26;
  $C58C *DE++ = *HL++;
  $C58E *DE++ = *HL++;
  $C590 HL -= 2;
;
  $C592 if (*HL == 0) {
  $C596   DE += 3; }
  $C59A else {
  $C59C   byte_A13E = 0;
  $C5A0   PUSH DE
  $C5A1   sub_C651();
  $C5A4   if (A == 255) {
  $C5A8     POP HL
  $C5A9     HL -= 2;
  $C5AB     PUSH HL
  $C5AC     CALL $CB2D
  $C5AF     POP HL
  $C5B0     DE = HL + 2;
  $C5B4     goto $C592; }
  $C5B6   if (A == 128) IY[1] |= vischar_BYTE1_BIT6; // $8021
  $C5BE   POP DE
  $C5BF   memcpy(DE, HL, 3); }
  $C5C4 *DE = 0;
  $C5C6 DE -= 7;
  $C5CA EX DE,HL
  $C5CB PUSH HL
  $C5CC reset_position();
  $C5CF POP HL
  $C5D0 character_behaviour_stuff(); return; // exit via

; -----------------------------------------------------------------------------

c $C5D3 reset_visible_character
D $C5D3 Reset a visible character (either a character or an object).
R $C5D3 I:HL Pointer to vischar.
  $C5D3 A = *HL;
  $C5D4 if (A == character_NONE) return;
  $C5D7 if (A >= character_26_stove1) {
D $C5DC A stove/crate character.
  $C5DC   HL[0] = character_NONE
  $C5DF   HL[1] = 0xFF; // flags
  $C5E1   HL[7] = 0; // more flags
  $C5E7   HL += 0x0F; // vischar + 0x0F
D $C5EB Save the old position.
  $C5EB   DE = &movable_items[0]; // stove1
  $C5EE   if (A != character_26_stove1) {
  $C5F2     DE = &movable_items[2]; // stove2
  $C5F5     if (A != character_27_stove2) {
  $C5F9       DE = &movable_items[1]; } } // crate
  $C5FC   memcpy(DE, HL, 6);
  $C601   return; }
D $C602 A non-object character.
  $C602 else { -
  $C603   DE = get_character_struct(A);
  $C606   *DE &= ~characterstruct_BYTE0_BIT6;
  $C608   -
  $C60C   A = HL[0x1C]; // room index
  $C60D   *++DE = A; // characterstruct.room = room index;
  $C610   -
  $C611   HL[7] = 0; // flags
  $C617   HL += 0x0F; // vischar+0x0F
  $C61A   DE++; // &characterstruct.y
  $C61C   if (A == 0) { // outdoors
  $C61F     scale_pos(HL,DE); } // HL,DE updated
  $C622   else {
  $C624     B = 3;
  $C626     do { *DE++ = *HL;
  $C628       HL += 2;
  $C62B     } while (--B); }
  $C62D   HL -= 21; // reset HL to point to original vischar
  $C631   A = *HL; // HL points to vischar // sampled HL = $8040, $8020, $8080, $80A0
  $C632   *HL++ = character_NONE;
  $C635   *HL++ = 0xFF; // flags
  $C638   if (A >= character_16 && A < character_20_prisoner) {
  $C640     *HL++ = 255;
  $C643     *HL = 0;
  $C645     if (A >= character_18_prisoner) *HL = 24;
  $C64B     HL--; }
  $C64C   *DE++ = *HL++; // copy target into charstruct
  $C64E   *DE++ = *HL++;
  $C650   return; }

; -----------------------------------------------------------------------------

c $C651 sub_C651
D $C651 ...
R $C651 I:HL Pointer to characterstruct + 5. // sampled = $768E, 7695, 769C, 7617, 761E, 7625, 762C, 7633, 7656, 765D
R $C651 O:A  0/255
R $C651 O:HL Pointer to somewhere in word_783A.
  $C651 A = *HL;
  $C652 if (A == 0xFF) {
  $C656   A = *++HL & characterstruct_BYTE6_MASK_HI;
  $C65A   *HL = A;
  $C65B   get_A_indexed_by_C41A();
  $C65E   A &= characterstruct_BYTE6_MASK_LO;
  $C660   A += *HL;
  $C661   *HL = A; }
  $C664 else { PUSH HL
  $C665   C = *++HL; // byte6
  $C667   element_A_of_table_7738();
  $C66A   H = 0;
  $C66C   A = C;
  $C66D   if (A == 0xFF) H--; // H = 0xFF
  $C672   L = A;
  $C673   HL += DE;
  $C674   EX DE,HL
  $C675   A = *DE;
  $C676   if (A == 0xFF) ...
  $C678   POP HL // interleaved
  $C679   ... goto return_255;
  $C67B   A &= 0x7F;
  $C67D   if (A < 40) {
  $C681     A = *DE;
  $C682     if (*HL & (1<<7)) A ^= 0x80; // 762C, 8002, 7672, 7679, 7680, 76A3, 76AA, 76B1, 76B8, 76BF, ... looks quite general
  $C688     transition();
  $C68B     HL++;
  $C68C     A = 0x80;
  $C68E     return; }
  $C68F   A = *DE - 40; }
D $C692 sample A=$38,2D,02,06,1E,20,21,3C,23,2B,3A,0B,2D,04,03,1C,1B,21,3C,...
  $C692 HL = word_783A[A];
  $C69B A = 0;
  $C69C return;
;
  $C69D return_255: A = 255;
  $C69F return;

; -----------------------------------------------------------------------------

c $C6A0 move_characters
D $C6A0 Moves characters around.
  $C6A0 byte_A13E = 0xFF;
  $C6A5 character_index = (character_index + 1) % character_26; // 26 = highest + 1 character
  $C6B1 HL = get_character_struct(character_index); // pass character_index as A
  $C6B4 if (*HL & characterstruct_BYTE0_BIT6) return;
  $C6B7 PUSH HL
  $C6B8 A = *++HL; // characterstruct byte1 == room
  $C6BA if (A != room_0_outdoors) {
  $C6BD   is_item_discoverable_indoors(A);
  $C6C0   if (Z) item_discovered(); }
  $C6C5 POP HL
  $C6C6 HL += 2; // point at charstruct y,x coords
  $C6C8 PUSH HL
  $C6C9 HL += 3; // point at charstruct byte2
  $C6CC A = *HL;
  $C6CD if (A == 0) {
  $C6D0   POP HL
  $C6D1   return; }
  $C6D2 sub_C651();
  $C6D5 if (A == 0xFF) {
  $C6DA   A = character_index;
; could re-cast this bit as:
; if (A != character_0 && A < character_12_prisoner) {
;   ...
; } else ...
  $C6DD   if (A == character_0) goto char_is_zero; // player character?
  $C6E0   if (A >= character_12_prisoner) goto char_ge_12;
;
  $C6E4   *HL++ ^= 0x80;
  $C6E9   if (A & 7) (*HL) -= 2;
  $C6EF   (*HL)++; // weird // i.e -1 or +1
  $C6F0   POP HL
  $C6F1   return;
;
  $C6F2   char_is_zero: A = *HL & characterstruct_BYTE5_MASK; // fetching a character index? // sampled = HL = $7617 (characterstruct + 5)
  $C6F5   if (A != 36) goto $C6E4;
;
  $C6F9   char_ge_12: POP DE
  $C6FA   goto character_event; // exit via
;
U $C6FD,2   DEFB $18,$6F  ; UNUSED? }
;
  $C6FF if (A == 0x80) {
  $C704   POP DE
  $C705   A = DE[-1];
  $C708   PUSH HL
  $C709   if (A == 0) {
  $C70D     PUSH DE
  $C70E     DE = &saved_Y;
  $C711     B = 2; // 2 iters
  $C713     do { *DE++ = *HL++ >> 1;
  $C719     } while (--B);
  $C71B     HL = &saved_Y;
  $C71E     POP DE }
  $C71F   if (DE[-1] == 0) A = 2; else A = 6;
  $C729   EX AF,AF'
  $C72A   B = 0;
  $C72C   increment_DE_by_diff();
  $C72F   DE++;
  $C730   HL++;
  $C731   increment_DE_by_diff();
  $C734   POP HL
  $C735   if (B != 2) return;
  $C739   DE -= 2;
  $C73B   HL--;
  $C73C   *DE = (*HL & doorposition_BYTE0_MASK_HI) >> 2; // mask
D $C742 Stuff reading from door_positions.
  $C742   if ((*HL & doorposition_BYTE0_MASK_LO) < 2) { // sampled HL = 78fa,794a,78da,791e,78e2,790e,796a,790e,791e,7962,791a
  $C749     HL += 5; }
  $C74E   else {
  $C750     HL -= 3; }
  $C753   A = *DE++
  $C755   if (A) {
  $C758     *DE++ = *HL++;
  $C75A     *DE++ = *HL++;
  $C75C     *DE++ = *HL++;
  $C75E     DE--; }
  $C75F   else {
  $C761     B = 3;
  $C763     do { *DE++ = *HL++ >> 1;
  $C769     } while (--B)
  $C76B     DE--; } }
  $C76C else {
  $C76E   POP DE
  $C76F   tmpA = DE[-1];
  $C772   -
  $C773   A = 2;
  $C775   if (tmpA) A = 6;
  $C779   EX AF,AF'
  $C77A   B = 0;
  $C77C   increment_DE_by_diff()
  $C77F   HL++;
  $C780   DE++;
  $C781   increment_DE_by_diff()
  $C784   DE++;
  $C785   if (B != 2) return; }
  $C78B DE++;
  $C78C EX DE,HL
  $C78D A = *HL; // address? 761e 7625 768e 7695 7656 7695 7680 // => character struct entry + 5
  $C78E if (A == 0xFF) return;
  $C791 if ((A & (1<<7)) != 0) ...
  $C793 HL++;       // interleaved
  $C794 ... goto exit;
  $C796 (*HL)++;
  $C797 return;

  $C798 exit: (*HL)--;
  $C799 return;

; -----------------------------------------------------------------------------

c $C79A increment_DE_by_diff
D $C79A [leaf] (<- move_characters)
D $C79A Gets called with successive bytes.
R $C79A I:B  ?
R $C79A I:DE Pointer to bytes within character_structs. // 761b,761c, 7622,7623, 7629,762a, 7630,7631, 7653,...
R $C79A I:HL Pointer to bytes within word_783A.         // 787a,787b, 787e,787f, 78b2,78b3, 7884,7885, 7892,...
R $C79A O:B  ?
  $C79A -
  $C79B C = Adash; // ie. banked A // some maximum value
  $C79C -
  $C79D A = *DE - *HL; // delta
  $C79F if (A == 0) {
  $C7A1   B++;
  $C7A2   return; }
  $C7A3 else if (A < 0) {
  $C7A5   A = -A; // absolute
  $C7A7   if (A >= C) A = C;
  $C7AB   *DE += A;
  $C7AF   return; }
  $C7B0 else { if (A >= C) A = C;
  $C7B4   *DE -= A;
  $C7B8   return; }

; -----------------------------------------------------------------------------

c $C7B9 get_character_struct
R $C7B9 I:A  Character index.
R $C7B9 O:HL Character struct.
  $C7B9 HL = &character_structs[A];
  $C7C5 return;

; ------------------------------------------------------------------------------

; Character events and handlers.
;
c $C7C6 character_event
D $C7C6 Makes characters sit, sleep or other things TBD.
; sampled HL = 80a2, 80e2, 8042, 8062, 76b8, 76bf, 80c2, 80e2, 8022, 8002, 8082, 766b,  (vischar+2 OR charstruct+5)
R $C7C6 I:HL Points to character_struct fifth byte (character index + top bit set) or vischar (straight char index).
  $C7C6 A = *HL;
  $C7C7 if (A >= character_7_prisoner  && A <= character_12_prisoner) goto character_sleeps;
  $C7D0 if (A >= character_18_prisoner && A <= character_22_prisoner) goto character_sits;
  $C7D9 PUSH HL // POPped by handlers
  $C7DA map = &character_to_event_handler_index_map[0];
  $C7DD B = NELEMS(character_to_event_handler_index_map); // 24 iterations
D $C7DF Locate the character in the map.
  $C7DF do { if (A == map->character) goto call_action;
  $C7E2   map += 2;
  $C7E4 } while (--B);
  $C7E6 POP HL
  $C7E7 *HL = 0; // no action
  $C7E9 return;

  $C7EA call_action: goto character_event_handlers[*++HL];

; enum charevnt
; charevnt_1        ;
; charevnt_2        ;
; charevnt_3        ; checks byte_A13E case 1
; charevnt_4        ; zeroes morale_1
; charevnt_5        ; checks byte_A13E case 2
; charevnt_6        ;
; charevnt_7        ;
; charevnt_8        ; player sleeps
; charevnt_9        ; player sits
; charevnt_10       ; released from solitary

D $C7F9 character_to_event_handler_index_map
D $C7F9 Array of (character + flags, character event handler index) mappings.
W $C7F9 { character_6  | 0b10100000, charevnt_0 },
W $C7FB { character_7  | 0b10100000, charevnt_0 },
W $C7FD { character_8  | 0b10100000, charevnt_1 },
W $C7FF { character_9  | 0b10100000, charevnt_1 },
W $C801 { character_5  | 0b00000000, charevnt_0 },
W $C803 { character_6  | 0b00000000, charevnt_1 },
W $C805 { character_5  | 0b10000000, charevnt_3 }, // checks byte_A13E case 1
W $C807 { character_6  | 0b10000000, charevnt_3 }, // checks byte_A13E case 1
W $C809 { character_14 | 0b00000000, charevnt_2 },
W $C80B { character_15 | 0b00000000, charevnt_2 },
W $C80D { character_14 | 0b10000000, charevnt_0 },
W $C80F { character_15 | 0b10000000, charevnt_1 },
W $C811 { character_16 | 0b00000000, charevnt_5 }, // checks byte_A13E case 2
W $C813 { character_17 | 0b00000000, charevnt_5 }, // checks byte_A13E case 2
W $C815 { character_16 | 0b10000000, charevnt_0 },
W $C817 { character_17 | 0b10000000, charevnt_1 },
W $C819 { character_0  | 0b10100000, charevnt_0 },
W $C81B { character_1  | 0b10100000, charevnt_1 },
W $C81D { character_10 | 0b00100000, charevnt_7 },
W $C81F { character_12 | 0b00100000, charevnt_8 }, // player sleeps
W $C821 { character_11 | 0b00100000, charevnt_9 }, // player sits
W $C823 { character_4  | 0b10100000, charevnt_6 }, // go to 0x0315
W $C825 { character_4  | 0b00100000, charevnt_10 },// released from solitary
W $C827 { character_5  | 0b00100000, charevnt_4 }, // zero morale_1

D $C829 character_event_handlers
D $C829 Array of pointers to character event handlers.
W $C829 charevnt_handler *character_event_handlers[] = { &charevnt_handler_0,
W $C82B   &charevnt_handler_1,
W $C82D   &charevnt_handler_2,
W $C82F   &charevnt_handler_3_check_var_A13E,
W $C831   &charevnt_handler_4_zero_morale_1,
W $C833   &charevnt_handler_5_check_var_A13E_anotherone,
W $C835   &charevnt_handler_6,
W $C837   &charevnt_handler_7,
W $C839   &charevnt_handler_8_player_sleeps,
W $C83B   &charevnt_handler_9_player_sits,
W $C83D   &charevnt_handler_10_player_released_from_solitary, };

D $C83F charevnt_handler_4_zero_morale_1
  $C83F morale_1 = 0;
  $C843 goto charevnt_handler_0;

D $C845 charevnt_handler_6 -- saw this hit somewhere around (morning) roll call -- but hits are rare
; suspicion that character_36 is commandant
  $C845 POP HL // (popped) sampled HL = $80C2 (x2), $8042  // likely target location
  $C846 *HL++ = 0x03;
  $C849 *HL   = 0x15;
  $C84B return;

D $C84C charevnt_handler_10_player_released_from_solitary
  $C84C POP HL
  $C84D *HL++ = 0xA4;
  $C850 *HL   = 0x03;
  $C852 automatic_player_counter = 0; // force automatic control
  $C856 set_player_target_location(0x2500); return;

D $C85C charevnt_handler_1
  $C85C C = 0x10; // 0xFF10
  $C85E goto exit;

D $C860 charevnt_handler_2
  $C860 C = 0x38; // 0xFF38
  $C862 goto exit;

D $C864 charevnt_handler_0
  $C864 C = 0x08; // 0xFF08 // sampled HL=$8022,$8042,$8002,$8062
  $C866 exit: POP HL
  $C867 *HL++ = 0xFF;
  $C86A *HL   = C;
  $C86B return;

D $C86C charevnt_handler_3_check_var_A13E
  $C86C POP HL
  $C86D if (byte_A13E == 0) goto byte_A13E_is_zero; else goto byte_A13E_is_nonzero;

D $C877 charevnt_handler_5_check_var_A13E_anotherone
  $C877 POP HL
  $C878 if (byte_A13E == 0) goto byte_A13E_is_zero_anotherone; else goto byte_A13E_is_nonzero_anotherone;

D $C882 charevnt_handler_7
  $C882 POP HL
  $C883 *HL++ = 0x05;
  $C886 *HL   = 0x00;
  $C888 return;

D $C889 charevnt_handler_9_player_sits
  $C889 POP HL
  $C88A goto player_sits;

D $C88D charevnt_handler_8_player_sleeps
  $C88D POP HL
  $C88E goto player_sleeps;

; ------------------------------------------------------------------------------

b $C891 food_discovered_counter
D $C891 Likely: A countdown until any food item is discovered.
D $C891 (<- follow_suspicious_player, bribes_solitary_food)

; ------------------------------------------------------------------------------

c $C892 follow_suspicious_player
D $C892 Causes characters to follow the player if they're being suspicious. Poisoned food handling.
  $C892 byte_A13E = 0;
  $C896 if (bell) guards_persue_prisoners();
  $C89D if (food_discovered_counter != 0 && --food_discovered_counter == 0) {
  $C8A7   item_structs[item_FOOD].item &= ~itemstruct_ITEM_FLAG_POISONED;
  $C8AC   C = item_FOOD;
  $C8AE   item_discovered(); }
  $C8B1 IY = $8020; // iterate over non-player characters
  $C8B5 B = 7; // iterations
  $C8B7 do { -
  $C8B8   if (IY[1] != room_NONE) { // unsure if a room index, more likely flags
  $C8C0     A = IY[0] & vischar_BYTE0_MASK; // character index
D $C8C5 Change '20' here to a higher number and prisoners will start following the player too. The character numbers I've defined earlier and the ones used here (and observed) elsewhere are a different set where < 20 is a guard.
  $C8C5     if (A < 20) {
  $C8CA       -
  $C8CB       is_item_discoverable();
  $C8CE       if (red_flag || automatic_player_counter > 0) guards_follow_suspicious_player();
  $C8DB       -
  $C8DC       if (A > 15) { // 16,17,18,19  // could these be the dogs?
  $C8E4         if (item_structs[item_FOOD].room & itemstruct_ROOM_FLAG_ITEM_NEARBY) IY[1] = 3; } }
  $C8F1     character_behaviour_stuff(); }
  $C8F4   -
  $C8F5   IY += 32; // stride
  $C8FA } while (--B);
  $C8FE if (!red_flag && (morale_1 || automatic_player_counter == 0)) {
D $C902 Pointless JP NZ (jumps to RET, RET NZ would do).
  $C910   IY = $8000;
  $C914   character_behaviour_stuff(); }
  $C917 return;

; ------------------------------------------------------------------------------

c $C918 character_behaviour_stuff
D $C918 Character behaviour?
R $C918 I:IY Pointer to visible character block.
  $C918 A = IY[7]; // $8007 etc.
  $C91B B = A;
  $C91C A &= vischar_BYTE7_MASK; // flags
  $C91E if (A) {
  $C920   IY[7] = --B; // decrement but don't affect flags
  $C924   return; }
  $C925 HL = IY;
  $C928 A = *++HL; // HL is ?
  $C92A if (A != 0) {
  $C92E   if (A == 1) {
;
  $C932     PUSH HL
  $C933     -
  $C934     POP DEdash
  $C935     DEdash += 3;
  $C938     HLdash = &player_map_position.y;
  $C93B     *DEdash++ = *HLdash++;
  $C93D     *DEdash++ = *HLdash++;
  $C93F     -
  $C940     goto jump_c9c0; }
  $C943   else if (A == 2) {
  $C947     if (automatic_player_counter) goto $C932; // jump into case 1
  $C94D     *HL++ = 0;
  $C950     sub_CB23(); return; } // exit via
  $C953   else if (A == 3) {
  $C957     PUSH HL
  $C958     EX DE,HL
  $C959     if (item_structs[item_FOOD].room & itemstruct_ROOM_FLAG_ITEM_NEARBY) {
  $C960       HL++;
  $C961       DE += 3;
  $C965       *DE++ = *HL++;
  $C967       *DE++ = *HL++;
  $C969       POP HL
  $C96A       goto jump_c9c0; }
  $C96C     else { A = 0;
  $C96D       *DE = A;
  $C96E       EX DE,HL
  $C96F       *++HL = 0xFF;
  $C972       *++HL = 0;
  $C975       POP HL
  $C976       sub_CB23(); return; } } // exit via
  $C979   else if (A == 4) {
  $C97D     PUSH HL
  $C97E     A = bribed_character;
  $C981     if (A != 0xFF) {
  $C985       -
  $C986       B = 7; // 7 iterations
  $C988       HL = $8020; // iterate over non-player characters
  $C98B       do {
  $C98C         if (*HL == A) goto found_bribed;
  $C98F         HL += 32;
  $C993       } while (--B); }
  $C995     POP HL
  $C996     *HL++ = 0;
  $C999     sub_CB23(); return; // exit via

D $C99C Found bribed character.
; indentation is wrong here, i think
  $C99C found_bribed: HL += 15;
  $C9A0     POP DE
  $C9A1     PUSH DE
  $C9A2     DE += 3;
  $C9A6     if (room_index) {
  $C9AD       scale_pos(HL,DE); }
  $C9B0     else {
  $C9B2       *DE++ = *HL++;
  $C9B4       HL++;
  $C9B5       *DE++ = *HL++; }
  $C9B7     POP HL
  $C9B8     goto jump_c9c0; } }
  $C9BA A = HL[1];
  $C9BD if (A == 0) goto gizzards;
;
  $C9C0 jump_c9c0: A = *HL; // HL is $8001
  $C9C1 -
  $C9C2 Cdash = A;
  $C9C3 if (room_index) {
  $C9C9   HLdash = &A_widened_to_BC; }
  $C9CC else {
  $C9CE   if (Cdash & vischar_BYTE1_BIT6) {
  $C9D2     HLdash = &BC_becomes_A_times_4; }
  $C9D5   else {
  $C9D7     HLdash = &BC_becomes_A_times_8; } }
  $C9DA ($CA13) = HLdash; // self-modify move_character_Y:$CA13
  $C9DD ($CA4B) = HLdash; // self-modify move_character_X:$CA4B
  $C9E0 -
  $C9E1 if (IY[7] & vischar_BYTE7_BIT5) goto bit5set; // I could 'else' this chunk.
  $C9E7 HL += 3;
  $C9EA move_character_Y();
  $C9ED if (Z) {
  $C9EF   move_character_X();
  $C9F2   if (Z) goto bribes_solitary_food; } // exit via

; This entry point is used by the routine at #R$CA81.
; Calling this "gizzards", as unsure what it's doing.
  $C9F5 gizzards: if (A != IY[13]) IY[13] = A | vischar_BYTE13_BIT7; // sampled IY=$8040,$8020,$8000
  $C9FE return;

  $C9FF bit5set: L += 4;
  $CA03 move_character_X();
  $CA06 if (Z) move_character_Y();
  $CA0B if (!Z) goto gizzards; // keep trying to move?
  $CA0D HL--;
  $CA0E bribes_solitary_food(); return; // exit via

; ------------------------------------------------------------------------------

c $CA11 move_character_Y
R $CA11 vischar[15] - scalefn(vischar[4])
R $CA11 I:HL Pointer to visible character block + 4.
R $CA11 I:IY Pointer to visible character block.
R $CA11 O:A  8/4/0 .. meaning ?
R $CA11 O:HL Pointer to ?
  $CA11 A = *HL; // sampled HL=$8004,$8044,$8064,$8084
  $CA12 BC_becomes_A_times_8(); // self modified by #R$C9DA
  $CA15 HL += 11; // position on Y axis ($800F etc.)
  $CA19 E = *HL++;
  $CA1B D = *HL;
  $CA1C -
  $CA1D DE -= BC;
  $CA1F if (DE) {
  $CA21   if (DE > 0) { // +ve
; possibly 'have reached target' flags
  $CA24     if (D != 0   || E >= 3)  { A = 8; return; } } else { // -ve
  $CA30     if (D != 255 || E < 254) { A = 4; return; } } }
  $CA3E -
  $CA3F HL -= 11;
  $CA43 IY[7] |= vischar_BYTE7_BIT5;
  $CA47 A = 0;
  $CA48 return;

; ------------------------------------------------------------------------------

c $CA49 move_character_X
D $CA49 Nearly identical routine to move_character_Y above.
R $CA49 I:HL Pointer to visible character block + 5.
R $CA49 I:IY Pointer to visible character block.
R $CA49 O:A  5/7/0 .. meaning ?
R $CA49 O:HL Pointer to ?
  $CA49 A = *HL; // sampled HL=$8025,$8065,$8005
  $CA4A BC_becomes_A_times_8(); // self modified by #R$C9DD
  $CA4D HL += 12; // position on X axis ($8011 etc.)
  $CA51 E = *HL++;
  $CA53 D = *HL;
  $CA54 -
  $CA55 DE -= BC;
  $CA57 if (DE) {
  $CA59   if (DE > 0) { // +ve
; possibly 'have reached target' flags
  $CA5C     if (D != 0   || E >= 3)  { A = 5; return; } } else { // -ve
  $CA68     if (D != 255 || E < 254) { A = 7; return; } } }
  $CA76 -
  $CA77 HL -= 14;
  $CA7B IY[7] &= ~vischar_BYTE7_BIT5;
  $CA7F A = 0;
  $CA80 return;

; ------------------------------------------------------------------------------

c $CA81 bribes_solitary_food
D $CA81 Bribes, solitary, food, 'character enters' sound.
R $CA81 I:IY Pointer to $8000, $8020, $8040, $8060, $8080
  $CA81 A = IY[1];
  $CA84 C = A;
  $CA85 A &= vischar_BYTE1_MASK;
  $CA87 if (A) {
  $CA89   if (A == 1) {
  $CA8D     if (IY[0] == bribed_character) { use_bribe(); return; } // exit via
  $CA96     else { solitary(); return; } } // exit via
  $CA99   else if (A == 2 || A == 4) { return; }
  $CA9F   -
  $CAA0   if ((item_structs[item_FOOD].item & itemstruct_ITEM_FLAG_POISONED) == 0) A = 32; else A = 255;
  $CAAB   food_discovered_counter = A;
  $CAAE   -
  $CAAF   HL -= 2;
  $CAB1   *HL = 0;
  $CAB3   goto character_behaviour_stuff:$C9F5; }
  $CAB6 if (C & vischar_BYTE1_BIT6) {
  $CABA   C = *--HL; // 80a3, 8083, 8063, 8003 // likely target location
  $CABC   A = *--HL;
  $CABE   -
  $CABF   element_A_of_table_7738();
  $CAC2   -
  $CAC3   DE += C;
  $CAC9   A = *DE;
  $CACA   if (*HL & vischar_BYTE2_BIT7) A ^= 0x80;
  $CAD0   PUSH AF
  $CAD1   A = *HL++; // $8002, ...
  $CAD3   if (A & vischar_BYTE2_BIT7) (*HL) -= 2; // $8003, ... // likely target location
  $CAD9   (*HL)++; // likely target location
  $CADA   POP AF
  $CADB   get_door_position(); // door related
  $CADE   IY[0x1C] = (*HL >> 2) & 0x3F; // IY=$8000 => $801C (room index) // HL=$790E,$7962,$795E => door position thingy // 0x3F is door_positions[0] room mask shifted right 2
  $CAE6   A = *HL & doorposition_BYTE0_MASK_LO; // door position thingy, lowest two bits -- index?
  $CAE9   if (A < 2) HL += 5; else HL -= 3; // delta of 8 - related to door stride stuff?
  $CAF8   PUSH HL
  $CAF9   HL = IY;
  $CAFC   if (L == 0) { // player's vischar only
  $CB01     HL++; // $8000 -> $8001
  $CB02     *HL++ &= ~vischar_BYTE1_BIT6;
  $CB05     sub_CB23(); }
  $CB08   POP HL
  $CB09   transition();
  $CB0C   play_speaker(sound_CHARACTER_ENTERS_1);
  $CB12   return; }
  $CB13 HL -= 2;
  $CB15 A = *HL; // $8002 etc. // likely target location
  $CB16 if (A != 0xFF) {
  $CB1A   HL++;
  $CB1B   if (A & vischar_BYTE2_BIT7) {
  $CB1F     (*HL) -= 2; } // $8003 etc.
  $CB21   else { (*HL)++;
  $CB22     HL--; } }
;
; fallthrough

c $CB23 sub_CB23
; This entry point is used by the routines at #R$A3B3, #R$B107 and #R$C918.
R $CB23 I:A Character index?
  $CB23 PUSH HL
  $CB24 sub_C651();
  $CB27 if (A == 0xFF) {
  $CB2C   POP HL
; This entry point is used by the routine at #R$C4E0.
  $CB2D   if (L != 0x02) { // if not player's vischar
  $CB33     if (IY[0] & vischar_BYTE0_MASK == 0) {
  $CB3A       A = *HL & vischar_BYTE2_MASK;
  $CB3D       if (A == 36) goto $CB46; // character index
  $CB41       A = 0; } // self modified? (suspect not - just countering next if statement)
  $CB42     if (A == 12) goto $CB50; }
;
  $CB46   PUSH HL
  $CB47   character_event();
  $CB4A   POP HL
  $CB4B   A = *HL;
  $CB4C   if (A == 0) return;
  $CB4E   sub_CB23(); return; // exit via

  $CB50   *HL++ = *HL ^ 0x80;
  $CB55   if (A & (1<<7)) { // which flag is this?
  $CB59     (*HL) -= 2; }
  $CB5B   (*HL)++
  $CB5C   HL--;
  $CB5D   A = 0;
  $CB5E   return; } // strictly the terminating brace is after the following unreferenced bytes
U $CB5F,2 Unreferenced bytes.
  $CB61 if (A == 128) {
  $CB66   IY[1] |= vischar_BYTE1_BIT6; }
  $CB6A POP DE
  $CB6B memcpy(DE + 2, HL, 2);
  $CB72 A = 128;
  $CB74 return;

; ------------------------------------------------------------------------------

c $CB75 A_widened_to_BC
  $CB75 BC = A; return;

; ------------------------------------------------------------------------------

c $CB79 element_A_of_table_7738
R $CB79 I:A  Index.
R $CB79 O:DE Element.
  $CB79 DE = more_object_tile_refs[A];
  $CB84 return;

; ------------------------------------------------------------------------------

c $CB85 get_A_indexed_by_C41A
  $CB85 PUSH HL
  $CB86 HL = word_C41A + 1;
D $CB8A sampled HL = $902E,$902F,$9030,$9031,$9032,$9033,$9034,$9035,... looks like it's fetching exterior tiles
  $CB8A A = *HL & 0x0F;
  $CB8D word_C41A = HL;
  $CB90 POP HL
  $CB91 return;

; ------------------------------------------------------------------------------

u $CB92 unused_CB92
D $CB92 Unreferenced bytes.

; ------------------------------------------------------------------------------

c $CB98 solitary
D $CB98 Silence bell.
  $CB98 bell = bell_STOP;
D $CB9D Seize player's held items.
  $CB9D HL = &items_held[0];
  $CBA0 C = *HL;
  $CBA1 *HL = item_NONE;
  $CBA2 item_discovered();
  $CBA5 HL = &items_held[1];
  $CBA8 C = *HL;
  $CBA9 *HL = item_NONE;
  $CBAB item_discovered();
  $CBAE draw_all_items();
D $CBB1 Reset all items. [unsure]
  $CBB1 B = 16; // all items
  $CBB3 HL = &item_structs[0].room;
  $CBB6 do { PUSH BC
  $CBB7   PUSH HL
  $CBB8   A = *HL & itemstruct_ROOM_MASK;
  $CBBB   if (A == room_0_outdoors) {
  $CBBD     A = *--HL;
  $CBBF     HL += 2;
  $CBC1     EX DE,HL
  $CBC2     EX AF,AF'
  $CBC3     A = 0;
  $CBC4     do { PUSH AF
  $CBC5       PUSH DE
  $CBC6       CALL $A01A // end of in_permitted_area
  $CBC9       if (Z) goto $CBD5;
  $CBCB       POP DE
  $CBCC       POP AF
  $CBCD     } while (++A != 3);
  $CBD3     goto next;

  $CBD5     POP DE
  $CBD6     POP AF
  $CBD7     EX AF,AF'
  $CBD8     C = A;
  $CBD9     item_discovered(); }
;
  $CBDC   next: POP HL
  $CBDD   POP BC
  $CBDE   HL += 7; // stride
  $CBE2 } while (--B);
  $CBE4 $801C = room_24_solitary;
  $CBE9 current_door = 20;
  $CBEE decrease_morale(35);
  $CBF3 reset_map_and_characters();
  $CBF6 memcpy(&character_structs[0].secondbyte, &solitary_player_reset_data, 6);
  $CC01 queue_message_for_display(message_YOU_ARE_IN_SOLITARY);
  $CC06 queue_message_for_display(message_WAIT_FOR_RELEASE);
  $CC0B queue_message_for_display(message_ANOTHER_DAY_DAWNS);
  $CC10 morale_1 = 0xFF; // inhibit user input
  $CC15 automatic_player_counter = 0; // immediately take automatic control of player
  $CC19 $8015 = sprite_prisoner_tl_4;
  $CC1F HL = &solitary_transition_thing;
  $CC22 IY = $8000;
  $CC26 IY[0x0E] = 3; // character faces bottom left
  $CC2A ($8002) = 0; // target location - why is this storing a byte and not a word?
  $CC2E transition(); return; // exit via

; ------------------------------------------------------------------------------

b $CC31 solitary_player_reset_data
D $CC31 (<- solitary)

; ------------------------------------------------------------------------------

c $CC37 guards_follow_suspicious_player
R $CC37 I:IY Pointer to vischar.
  $CC37 HL = IY;
  $CC3A A = *HL;
D $CC3B Don't follow the player if he's dressed as a guard
  $CC3B if (A && *$8015 == sprite_guard_tl_4) return;
  $CC46 if (HL[1] == vischar_BYTE1_BIT2) return; // $8041 etc. // 'gone mad' flag
  $CC4B -
  $CC4C HL += 15;
  $CC50 DE = &byte_81B2;
  $CC53 if (room_index == 0) {
  $CC5A   scale_pos(HL,DE);
  $CC5D   HL = &player_map_position.y;
  $CC60   DE = &byte_81B2;
  $CC63   A = IY[0x0E]; // ?
  $CC66   carry = A & 1; A >>= 1;
  $CC67   C = A;
  $CC68   if (!carry) {
  $CC6A     HL++;
  $CC6B     DE++;
; range check
  $CC6C     A = *DE - 1;
  $CC6E     if (A >= *HL || A + 2 < *HL) return; // *DE - 1 .. *DE + 1
  $CC74     HL--;
  $CC75     DE--;
  $CC76     A = *DE;
  $CC77     CP *HL  // TRICKY!
  $CC78     BIT 0,C // if ((C & (1<<0)) == 0) carry = !carry;
  $CC7D     RET C   // This is odd: CCF then RET C? // will need to fall into 'else' clause
  $CC7E   }

; range check
  $CC80   else { A = *DE - 1;
  $CC82     if (A >= *HL || A + 2 < *HL) return; // *DE - 1 .. *DE + 1
  $CC88     HL++;
  $CC89     DE++;
  $CC8A     A = *DE;
  $CC8B     CP *HL  // TRICKY!
  $CC8C     BIT 0,C // if ((C & (1<<0)) == 0) carry = !carry;
  $CC91     RET C } }
;
; fallthrough

  $CC92 else { if (!red_flag) {
  $CC98      A = IY[0x13]; // sampled IY=$8020 // saw this breakpoint hit when outdoors
  $CC9B      if (A < 32) // vertical offset
  $CC9E        IY[1] = 2; // cutting wire flag? or could this have different meaning for AI characters only?
  $CCA2      return; }
  $CCA3    bell = bell_RING_PERPETUAL;
  $CCA7    guards_persue_prisoners();
  $CCAA    return; }

; ------------------------------------------------------------------------------

c $CCAB guards_persue_prisoners
D $CCAB Searches for a visible character and something else, sets a flag.
D $CCAB If I nop this out then guards don't spot the items I drop.
  $CCAB HL = $8020; // iterate over non-player characters
  $CCB1 B = 7; // iterations
  $CCB3 do {
D $CCB4 HL[0x13] is the character's vertical offset, clearly this has some significance.
  $CCB4   if (HL[0] < character_20_prisoner && HL[0x13] < 32) HL[1] = vischar_BYTE1_PERSUE;
  $CCC9   HL += 32; // stride
  $CCCA } while (--B);
  $CCCC return;

; ------------------------------------------------------------------------------

c $CCCD is_item_discoverable
D $CCCD Searches item_structs for items dropped nearby. If items are found the guards are made to persue the player.
D $CCCD Green key and food items are ignored.
  $CCCD A = room_index;
  $CCD0 if (A != room_0_outdoors) {
D $CCD3 Indoors.
  $CCD3   is_item_discoverable_indoors(A);
  $CCD6   if (Z) guards_persue_prisoners();
  $CCDA   return; }
D $CCDB Outdoors.
  $CCDB else { HL = &item_structs[0].room;
  $CCDE   -
  $CCE1   B = 16; // iterations == n.itemstructs
  $CCE3   do { if (HL[0] & itemstruct_ROOM_FLAG_ITEM_NEARBY) goto nearby;
;
  $CCE7     next: HL += 7; // stride
  $CCE8   } while (--B);
  $CCEA   return; }
;
D $CCEB Suspected bug: HL is decremented, but not re-incremented before 'goto next'. So it must be reading a byte early when iteration is resumed. Consequences? I think it'll screw up when multiple items are in range.
  $CCEB nearby: HL--;
  $CCEC A = *HL & itemstruct_ITEM_MASK; // sampled HL = $772A (&item_structs[item_PURSE].item)
D $CCEF The green key and food items are ignored.
  $CCEF if (A == item_GREEN_KEY || A == item_FOOD) goto next;
  $CCF7 guards_persue_prisoners();
  $CCFA return;

; ------------------------------------------------------------------------------

c $CCFB is_item_discoverable_indoors
D $CCFB Examines the specified room to see if it contains a discoverable item.
D $CCFB A discoverable item is one moved away from its default room, and one that isn't the red cross parcel.
R $CCFB I:A     Room ref.
R $CCFB O:Flags Z => found, NZ => not found.
R $CCFB O:C     Item (if found).
  $CCFB C = A; // room ref
  $CCFC HL = &item_structs[0].room; // pointer to room ref
  $CCFF B = 16; // items__LIMIT
  $CD01 do { A = *HL & itemstruct_ROOM_MASK;
D $CD04 Is the item in the specified room?
  $CD04   if (A == C) { // yes
  $CD07     -
D $CD08 Has the item been moved to a different room?
D $CD08 Note that room_and_flags doesn't get its flags masked off.
  $CD08     A = default_item_locations[HL[-1] & itemstruct_ITEM_MASK].room_and_flags; // HL[-1] = itemstruct.item
  $CD17     if (A != C) goto not_in_default_room;
  $CD1A     - }
  $CD1B   next: HL += 7; // stride
  $CD1F } while (--B);
  $CD21 return; // return with NZ set

  $CD22 not_in_default_room: -
  $CD23 A = HL[-1] & itemstruct_ITEM_MASK; // itemstruct.item
D $CD27 Ignore red cross parcel.
  $CD27 if (A == item_RED_CROSS_PARCEL) {
  $CD2B   -
  $CD2C   goto next; }
  $CD2E C = A;
  $CD2F A = 0; // set Z
  $CD30 return;

; ------------------------------------------------------------------------------

c $CD31 item_discovered
R $CD31 I:C Item.
  $CD31 A = C;
  $CD32 if (A == item_NONE) return;
  $CD35 A &= 0x0F; // likely this mask is itemstruct_ITEM_MASK
  $CD37 -
  $CD38 queue_message_for_display(message_ITEM_DISCOVERED);
  $CD3D decrease_morale(5);
  $CD42 -
  $CD43 A = default_item_locations[A].room_and_flags;
  $CD4D EX DE,HL
  $CD4E
D $CD4F Bug: This is not masked with 0x0F so item_to_itemstruct generates out of range addresses.
  $CD4F Adash = C;
  $CD50 HL = item_to_itemstruct(A);
  $CD53 *HL &= ~itemstruct_ITEM_FLAG_HELD;
  $CD55 EX DE,HL
  $CD56 DE++;
  $CD57 memcpy(DE, HL, 3); DE += 3; HL += 3; // reset location?
  $CD5C EX DE,HL
  $CD5D
  $CD5E if (A == 0) {
  $CD61   *HL = A;
  $CD62   goto $7BD0; /* drop_item_A:$7BD0 */ }
  $CD65 else { *HL = 5;
  $CD67   goto $7BF2; /* drop_item_A:$7BF2 */ }

; ------------------------------------------------------------------------------

b $CD6A default_item_locations
D $CD6A Array of 16 three-byte structures. Suspect these are /default/ locations.
D $CD6A struct default_item_location { byte room_and_flags; byte y; byte x; };
D $CD6A #define ITEM_ROOM(item_no, flags) ((item_no & 63) | flags)
  $CD6A item_WIRESNIPS        { ITEM_ROOM(room_NONE, (3<<6)), ... } // do these flags mean that the wiresnips are always or /never/ found?
  $CD6D item_SHOVEL           { ITEM_ROOM(room_9, 0), ... }
  $CD70 item_LOCKPICK         { ITEM_ROOM(room_10, 0), ... }
  $CD73 item_PAPERS           { ITEM_ROOM(room_11, 0), ... }
  $CD76 item_TORCH            { ITEM_ROOM(room_14, 0), ... }
  $CD79 item_BRIBE            { ITEM_ROOM(room_NONE, 0), ... }
  $CD7C item_UNIFORM          { ITEM_ROOM(room_15, 0),  ... }
  $CD7F item_FOOD             { ITEM_ROOM(room_19, 0), ... }
  $CD82 item_POISON           { ITEM_ROOM(room_1, 0), ... }
  $CD85 item_RED_KEY          { ITEM_ROOM(room_22, 0), ... }
  $CD88 item_YELLOW_KEY       { ITEM_ROOM(room_11, 0), ... }
  $CD8B item_GREEN_KEY        { ITEM_ROOM(room_0_outdoors, 0), ... }
  $CD8E item_RED_CROSS_PARCEL { ITEM_ROOM(room_NONE, 0), ... }
  $CD91 item_RADIO            { ITEM_ROOM(room_18, 0), ... }
  $CD94 item_PURSE            { ITEM_ROOM(room_NONE, 0), ... }
  $CD97 item_COMPASS          { ITEM_ROOM(room_NONE, 0), ... }

; ------------------------------------------------------------------------------

b $CD9A character_meta_data
  $CD9A { &character_related_pointers[0], &sprites[30] } // meta_commandant (<- sub_C4E0)
  $CD9E { &character_related_pointers[0], &sprites[22] } // meta_guard (<- sub_C4E0)
  $CDA2 { &character_related_pointers[0], &sprites[14] } // meta_dog (<- sub_C4E0)
  $CDA6 { &character_related_pointers[0], &sprites[2]  } // meta_prisoner (<- sub_C4E0)

; ------------------------------------------------------------------------------

b $CDAA byte_CDAA
D $CDAA Likely direction transitions.
D $CDAA,72,9 Groups of nine. (<- called_from_main_loop_9)

; ------------------------------------------------------------------------------

w $CDF2 character_related_pointers
D $CDF2 Array, 24 long, of pointers to data.

; ------------------------------------------------------------------------------

b $CE22 sprites
D $CE22 Objects which can move.
D $CE22 This include STOVE, CRATE, PRISONER, CRAWL, DOG, GUARD and COMMANDANT.
D $CE22 Structure: (b) width in bytes + 1, (b) height in rows, (w) data ptr, (w) mask ptr
D $CE22 'tl' => character faces top left of the screen
D $CE22 'br' => character faces bottom right of the screen
  $CE22 { 3, 22, &bitmap_stove          , &mask_stove        } // (16x22,$DB46,$DB72)
  $CE28 { 4, 24, &bitmap_crate          , &mask_crate        } // (24x24,$DAB6,$DAFE)
  $CE2E { 3, 27, &bitmap_prisoner_tl_4  , &mask_various_tl_4 } // (16x27,$D28C,$D545)
  $CE34 { 3, 28, &bitmap_prisoner_tl_3  , &mask_various_tl_3 } // (16x28,$D256,$D505)
  $CE3A { 3, 28, &bitmap_prisoner_tl_2  , &mask_various_tl_2 } // (16x28,$D220,$D4C5)
  $CE40 { 3, 28, &bitmap_prisoner_tl_1  , &mask_various_tl_1 } // (16x28,$D1EA,$D485)
  $CE46 { 3, 27, &bitmap_prisoner_br_1  , &mask_various_br_1 } // (16x27,$D2C0,$D585)
  $CE4C { 3, 29, &bitmap_prisoner_br_2  , &mask_various_br_2 } // (16x29,$D2F4,$D5C5)
  $CE52 { 3, 28, &bitmap_prisoner_br_3  , &mask_various_br_3 } // (16x28,$D32C,$D605)
  $CE58 { 3, 28, &bitmap_prisoner_br_4  , &mask_various_br_4 } // (16x28,$D362,$D63D)
  $CE5E { 4, 16, &bitmap_crawl_bl_2     , &mask_crawl_bl     } // (24x16,$D3C5,$D677)
  $CE64 { 4, 15, &bitmap_crawl_bl_1     , &mask_crawl_bl     } // (24x15,$D398,$D677)
  $CE6A { 4, 16, &bitmap_crawl_tl_1     , &mask_crawl_bl     } // (24x16,$D3F5,$D455)
  $CE70 { 4, 16, &bitmap_crawl_tl_2     , &mask_crawl_bl     } // (24x16,$D425,$D455)
  $CE76 { 4, 16, &bitmap_dog_tl_1       , &mask_dog_tl       } // (24x16,$D867,$D921)
  $CE7C { 4, 16, &bitmap_dog_tl_2       , &mask_dog_tl       } // (24x16,$D897,$D921)
  $CE82 { 4, 15, &bitmap_dog_tl_3       , &mask_dog_tl       } // (24x15,$D8C7,$D921)
  $CE88 { 4, 15, &bitmap_dog_tl_4       , &mask_dog_tl       } // (24x15,$D8F4,$D921)
  $CE8E { 4, 14, &bitmap_dog_br_1       , &mask_dog_br       } // (24x14,$D951,$D9F9)
  $CE94 { 4, 15, &bitmap_dog_br_2       , &mask_dog_br       } // (24x15,$D97B,$D9F9)
  $CE9A { 4, 15, &bitmap_dog_br_3       , &mask_dog_br       } // (24x15,$D9A8,$D9F9)
  $CEA0 { 4, 14, &bitmap_dog_br_4       , &mask_dog_br       } // (24x14,$D9CF,$D9F9)
  $CEA6 { 3, 27, &bitmap_guard_tl_4     , &mask_various_tl_4 } // (16x27,$D74D,$D545)
  $CEAC { 3, 29, &bitmap_guard_tl_3     , &mask_various_tl_3 } // (16x29,$D713,$D505)
  $CEB2 { 3, 27, &bitmap_guard_tl_2     , &mask_various_tl_2 } // (16x27,$D6DD,$D4C5)
  $CEB8 { 3, 27, &bitmap_guard_tl_1     , &mask_various_tl_1 } // (16x27,$D6A7,$D485)
  $CEBE { 3, 29, &bitmap_guard_br_1     , &mask_various_br_1 } // (16x29,$D783,$D585)
  $CEC4 { 3, 29, &bitmap_guard_br_2     , &mask_various_br_2 } // (16x29,$D7BD,$D5C5)
  $CECA { 3, 28, &bitmap_guard_br_3     , &mask_various_br_3 } // (16x28,$D7F7,$D605)
  $CED0 { 3, 28, &bitmap_guard_br_4     , &mask_various_br_4 } // (16x28,$D82F,$D63D)
  $CED6 { 3, 28, &bitmap_commandant_tl_4, &mask_various_tl_4 } // (16x28,$D0D6,$D545)
  $CEDC { 3, 30, &bitmap_commandant_tl_3, &mask_various_tl_3 } // (16x30,$D09A,$D505)
  $CEE2 { 3, 29, &bitmap_commandant_tl_2, &mask_various_tl_2 } // (16x29,$D060,$D4C5)
  $CEE8 { 3, 29, &bitmap_commandant_tl_1, &mask_various_tl_1 } // (16x29,$D026,$D485)
  $CEEE { 3, 27, &bitmap_commandant_br_1, &mask_various_br_1 } // (16x27,$D10E,$D585)
  $CEF4 { 3, 28, &bitmap_commandant_br_2, &mask_various_br_2 } // (16x28,$D144,$D5C5)
  $CEFA { 3, 27, &bitmap_commandant_br_3, &mask_various_br_3 } // (16x27,$D17C,$D605)
  $CF00 { 3, 28, &bitmap_commandant_br_4, &mask_various_br_4 } // (16x28,$D1B2,$D63D)

; ------------------------------------------------------------------------------

b $CF06 character_related_data
D $CF06 [unknown] character related stuff? read by routine around $b64f (called_from_main_loop_9)
  $CF06
  $CF0E
  $CF16
  $CF1E
  $CF26
  $CF3A
  $CF4E
  $CF62
  $CF76
  $CF7E
  $CF86
  $CF8E
  $CF96
  $CFA2
  $CFAE
  $CFBA
  $CFC6
  $CFD2
  $CFDE
  $CFEA
  $CFF6
  $D002
  $D00E
  $D01A

; ------------------------------------------------------------------------------

b $D026 sprite_bitmaps_and_masks
D $D026 Sprite bitmaps and masks.
B $D026 Raw data.
;
B $D026 bitmap: COMMANDANT FACING TOP LEFT 1
B $D060 bitmap: COMMANDANT FACING TOP LEFT 2
B $D09A bitmap: COMMANDANT FACING TOP LEFT 3
B $D0D6 bitmap: COMMANDANT FACING TOP LEFT 4
;
B $D10E bitmap: COMMANDANT FACING BOTTOM RIGHT 1
B $D144 bitmap: COMMANDANT FACING BOTTOM RIGHT 2
B $D17C bitmap: COMMANDANT FACING BOTTOM RIGHT 3
B $D1B2 bitmap: COMMANDANT FACING BOTTOM RIGHT 4
;
B $D1EA bitmap: PRISONER FACING TOP LEFT 1
B $D220 bitmap: PRISONER FACING TOP LEFT 2
B $D256 bitmap: PRISONER FACING TOP LEFT 3
B $D28C bitmap: PRISONER FACING TOP LEFT 4
;
B $D2C0 bitmap: PRISONER FACING BOTTOM RIGHT 1
B $D2F4 bitmap: PRISONER FACING BOTTOM RIGHT 2
B $D32C bitmap: PRISONER FACING BOTTOM RIGHT 3
B $D362 bitmap: PRISONER FACING BOTTOM RIGHT 4
;
B $D398 bitmap: CRAWL FACING BOTTOM LEFT 1
B $D3C5 bitmap: CRAWL FACING BOTTOM LEFT 2
B $D3F5 bitmap: CRAWL FACING TOP LEFT 1
B $D425 bitmap: CRAWL FACING TOP LEFT 2
B $D455 mask: CRAWL FACING TOP LEFT (shared)
;
B $D485 mask: VARIOUS FACING TOP LEFT 1
B $D4C5 mask: VARIOUS FACING TOP LEFT 2
B $D505 mask: VARIOUS FACING TOP LEFT 3
B $D545 mask: VARIOUS FACING TOP LEFT 4
;
B $D585 mask: VARIOUS FACING BOTTOM RIGHT 1
B $D5C5 mask: VARIOUS FACING BOTTOM RIGHT 2
B $D605 mask: VARIOUS FACING BOTTOM RIGHT 3
B $D63D mask: VARIOUS FACING BOTTOM RIGHT 4
B $D677 mask: CRAWL FACING BOTTOM LEFT (shared)
;
B $D6A7 bitmap: GUARD FACING TOP LEFT 1
B $D6DD bitmap: GUARD FACING TOP LEFT 2
B $D713 bitmap: GUARD FACING TOP LEFT 3
B $D74D bitmap: GUARD FACING TOP LEFT 4
;
B $D783 bitmap: GUARD FACING BOTTOM RIGHT 1
B $D7BD bitmap: GUARD FACING BOTTOM RIGHT 2
B $D7F7 bitmap: GUARD FACING BOTTOM RIGHT 3
B $D82F bitmap: GUARD FACING BOTTOM RIGHT 4
;
B $D867 bitmap: DOG FACING TOP LEFT 1
B $D897 bitmap: DOG FACING TOP LEFT 2
B $D8C7 bitmap: DOG FACING TOP LEFT 3
B $D8F4 bitmap: DOG FACING TOP LEFT 4
B $D921 mask: DOG FACING TOP LEFT (shared)
;
B $D951 bitmap: DOG FACING BOTTOM RIGHT 1
B $D97B bitmap: DOG FACING BOTTOM RIGHT 2
B $D9A8 bitmap: DOG FACING BOTTOM RIGHT 3
B $D9CF bitmap: DOG FACING BOTTOM RIGHT 4
B $D9F9 mask: DOG FACING BOTTOM RIGHT (shared)
;
B $DA29 bitmap: FLAG UP
B $DA6B bitmap: FLAG DOWN
;
B $DAB6 bitmap: CRATE
B $DAFE mask: CRATE
;
B $DB46 bitmap: STOVE
B $DB72 mask: STOVE

;
; UDGs for above
;

D $D026 #UDGARRAY2,7,4,2;$D026-$D05F-1-16{0,0,64,116}(bitmap-commandant-facing-top-left-1)
D $D060 #UDGARRAY2,7,4,2;$D060-$D099-1-16{0,0,64,116}(bitmap-commandant-facing-top-left-2)
D $D09A #UDGARRAY2,7,4,2;$D09A-$D0D5-1-16{0,0,64,116}(bitmap-commandant-facing-top-left-3)
D $D0D6 #UDGARRAY2,7,4,2;$D0D6-$D10E-1-16{0,0,64,112}(bitmap-commandant-facing-top-left-4)
;
D $D10E #UDGARRAY2,7,4,2;$D10E-$D143-1-16{0,0,64,108}(bitmap-commandant-facing-bottom-right-1)
D $D144 #UDGARRAY2,7,4,2;$D144-$D17B-1-16{0,0,64,112}(bitmap-commandant-facing-bottom-right-2)
D $D17C #UDGARRAY2,7,4,2;$D17C-$D1B1-1-16{0,0,64,108}(bitmap-commandant-facing-bottom-right-3)
D $D1B2 #UDGARRAY2,7,4,2;$D1B2-$D1E9-1-16{0,0,64,112}(bitmap-commandant-facing-bottom-right-4)
;
D $D1EA #UDGARRAY2,7,4,2;$D1EA-$D21F-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-1)
D $D220 #UDGARRAY2,7,4,2;$D220-$D255-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-2)
D $D256 #UDGARRAY2,7,4,2;$D256-$D28B-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-3)
D $D28C #UDGARRAY2,7,4,2;$D28C-$D2BF-1-16{0,0,64,104}(bitmap-prisoner-facing-top-left-4)
;
D $D2C0 #UDGARRAY2,7,4,2;$D2C0-$D2F3-1-16{0,0,64,104}(bitmap-prisoner-facing-bottom-right-1)
D $D2F4 #UDGARRAY2,7,4,2;$D2F4-$D32B-1-16{0,0,64,112}(bitmap-prisoner-facing-bottom-right-2)
D $D32C #UDGARRAY2,7,4,2;$D32C-$D361-1-16{0,0,64,108}(bitmap-prisoner-facing-bottom-right-3)
D $D362 #UDGARRAY2,7,4,2;$D362-$D397-1-16{0,0,64,108}(bitmap-prisoner-facing-bottom-right-4)
;
D $D398 #UDGARRAY3,7,4,3;$D398-$D3C4-1-24{0,0,96,64}(bitmap-crawl-facing-bottom-left-1)
D $D3C5 #UDGARRAY3,7,4,3;$D3C5-$D3F4-1-24{0,0,96,60}(bitmap-crawl-facing-bottom-left-2)
D $D3F5 #UDGARRAY3,7,4,3;$D3F5-$D424-1-24{0,0,96,64}(bitmap-crawl-facing-top-left-1)
D $D425 #UDGARRAY3,7,4,3;$D425-$D454-1-24{0,0,96,64}(bitmap-crawl-facing-top-left-2)
D $D455 #UDGARRAY3,7,4,3;$D455-$D484-1-24{0,0,96,64}(mask-crawl-facing-top-left)
;
D $D485 #UDGARRAY2,7,4,2;$D485-$D4C4-1-16{0,0,64,116}(mask-various-facing-top-left-1)
D $D4C5 #UDGARRAY2,7,4,2;$D4C5-$D504-1-16{0,0,64,116}(mask-various-facing-top-left-2)
D $D505 #UDGARRAY2,7,4,2;$D505-$D544-1-16{0,0,64,116}(mask-various-facing-top-left-3)
D $D545 #UDGARRAY2,7,4,2;$D545-$D584-1-16{0,0,64,112}(mask-various-facing-top-left-4)
;
D $D585 #UDGARRAY2,7,4,2;$D585-$D5C4-1-16{0,0,64,108}(mask-various-facing-top-right-1)
D $D5C5 #UDGARRAY2,7,4,2;$D5C5-$D604-1-16{0,0,64,112}(mask-various-facing-top-right-2)
D $D605 #UDGARRAY2,7,4,2;$D605-$D63C-1-16{0,0,64,108}(mask-various-facing-top-right-3)
D $D63D #UDGARRAY2,7,4,2;$D63D-$D676-1-16{0,0,64,112}(mask-various-facing-top-right-4)
D $D677 #UDGARRAY3,7,4,3;$D677-$D6A6-1-24{0,0,96,64}(mask-crawl-facing-bottom-left)
;
D $D6A7 #UDGARRAY2,7,4,2;$D6A7-$D6DC-1-16{0,0,64,108}(mask-guard-facing-top-left-1)
D $D6DD #UDGARRAY2,7,4,2;$D6DD-$D712-1-16{0,0,64,108}(mask-guard-facing-top-left-2)
D $D713 #UDGARRAY2,7,4,2;$D713-$D74C-1-16{0,0,64,116}(mask-guard-facing-top-left-3)
D $D74D #UDGARRAY2,7,4,2;$D74D-$D782-1-16{0,0,64,108}(mask-guard-facing-top-left-4)
;
D $D783 #UDGARRAY2,7,4,2;$D6A7-$D6DC-1-16{0,0,64,108}(mask-guard-facing-bottom-right-1)
D $D7BD #UDGARRAY2,7,4,2;$D6DD-$D712-1-16{0,0,64,108}(mask-guard-facing-bottom-right-2)
D $D7F7 #UDGARRAY2,7,4,2;$D713-$D74C-1-16{0,0,64,116}(mask-guard-facing-bottom-right-3)
D $D82F #UDGARRAY2,7,4,2;$D74D-$D782-1-16{0,0,64,108}(mask-guard-facing-bottom-right-4)
;
D $D867 #UDGARRAY3,7,4,3;$D867-$D896-1-24{0,0,96,64}(bitmap-dog-facing-top-left-1)
D $D897 #UDGARRAY3,7,4,3;$D897-$D8C6-1-24{0,0,96,64}(bitmap-dog-facing-top-left-2)
D $D8C7 #UDGARRAY3,7,4,3;$D8C7-$D8F3-1-24{0,0,96,60}(bitmap-dog-facing-top-left-3)
D $D8F4 #UDGARRAY3,7,4,3;$D8F4-$D920-1-24{0,0,96,60}(bitmap-dog-facing-top-left-4)
D $D921 #UDGARRAY3,7,4,3;$D921-$D950-1-24{0,0,96,64}(mask-dog-facing-top-left)
;
D $D951 #UDGARRAY3,7,4,3;$D951-$D97A-1-24{0,0,96,60}(bitmap-dog-facing-bottom-right-1)
D $D97B #UDGARRAY3,7,4,3;$D97B-$D9A7-1-24{0,0,96,60}(bitmap-dog-facing-bottom-right-2)
D $D9A8 #UDGARRAY3,7,4,3;$D9A8-$D9CE-1-24{0,0,96,52}(bitmap-dog-facing-bottom-right-3)
D $D9CF #UDGARRAY3,7,4,3;$D9CF-$D9F8-1-24{0,0,96,56}(bitmap-dog-facing-bottom-right-4)
D $D9F9 #UDGARRAY3,7,4,3;$D9F9-$DA28-1-24{0,0,96,64}(mask-dog-facing-bottom-right)
;
; I'm currently unsure of the exact dimensions of the following flag graphics.
D $DA29 #UDGARRAY3,7,4,3;$DA29-$DA6A-1-24{0,0,96,96}(flag-up)
D $DA6B #UDGARRAY3,7,4,3;$DA6B-$DAB5-1-24{0,0,96,96}(flag-down)
;
D $DAB6 #UDGARRAY3,7,4,3;$DAB6-$DAFD-1-24{0,0,96,96}(bitmap-crate)
D $DAFE #UDGARRAY3,7,4,3;$DAFE-$DB45-1-24{0,0,96,96}(mask-crate)
;
D $DB46 #UDGARRAY2,7,4,2;$DB46-$DB72-1-16{0,0,64,88}(bitmap-stove)
D $DB72 #UDGARRAY2,7,4,2;$DB72-$DB9D-1-16{0,0,64,88}(mask-stove)

; ------------------------------------------------------------------------------

c $DB9E mark_nearby_items
D $DB9E Iterates over item structs. Tests to see if items are within range (-2..23,-1..16) of the map position.
D $DB9E This is similar to is_item_discoverable_indoors in that it iterates over item_structs.
  $DB9E A = room_index;
  $DBA1 if (A == room_NONE) A = 0;
  $DBA6 C = A; // room ref
  $DBA7 DE = map_position;
  $DBAB B = 16; // items__LIMIT
  $DBAD HL = &item_structs[0].room;
  $DBB0 do { -
  $DBB1   if (HL[0] & itemstruct_ROOM_MASK == C) { // compare room ref
  $DBB7     if (HL[4] > E - 2 && HL[4] < E + 23) { // itemstruct.unk2
  $DBC8       if (HL[5] > D - 1 && HL[5] < D + 16) { // itemstruct.unk3
  $DBD5         -
  $DBD6         *HL |= itemstruct_ROOM_FLAG_BIT6 | itemstruct_ROOM_FLAG_ITEM_NEARBY; // sampled HL=$772B  &itemstruct_14.room
  $DBDA         goto continue; } } }

D $DBDC Reset.
  $DBDC   -
  $DBDD   *HL &= ~(itemstruct_ROOM_FLAG_BIT6 | itemstruct_ROOM_FLAG_ITEM_NEARBY);
;
  $DBE1   continue: HL += 7; // stride
  $DBE8 } while (--B);
  $DBEA return;

; ------------------------------------------------------------------------------

c $DBEB sub_DBEB
D $DBEB Iterates over all items. Uses BC_becomes_A_times_8.
R $DBEB O:IY Pointer to ? (result?)
R $DBEB O:Adash result?
  $DBEB B = 16; // iterations
  $DBEE Outer_HL = &item_structs[0].room;
  $DBF1 do { if ((*Outer_HL & (itemstruct_ROOM_FLAG_BIT6 | itemstruct_ROOM_FLAG_ITEM_NEARBY)) == (itemstruct_ROOM_FLAG_BIT6 | itemstruct_ROOM_FLAG_ITEM_NEARBY)) {
  $DBF9   HL = Outer_HL;
  $DBFA   -
  $DBFB   HLdash = *++HL * 8; // y position
  $DC00
  $DC01
  $DC02
  $DC03   A &= A; // clear carry?
  $DC04   HLdash -= BCdash; // where is BCdash initialised?
  $DC06
  $DC07   if (HLdash > 0) {
  $DC0B     HL++; // x position
  $DC0C     HLdash = *HL * 8;
  $DC10     -
  $DC11     -
  $DC12     // not clearing carry?
  $DC13     HLdash -= BCdash; // where is BCdash initialised?
  $DC15
  $DC16     if (HLdash > 0) {
  $DC1A       HLdash = HL;
  $DC1D       DEdash = *HLdash-- * 8; // x position
  $DC24       BCdash = *HLdash-- * 8; // y position
  $DC28       HLdash--; // point to item
  $DC2A       IY = HLdash; // IY is not banked
  $DC2D
  $DC2E       - // fetch iter count
  $DC2F       -
  $DC30       A = (16 - B) | (1<<6);
  $DC35       EX AF,AF' } } // unpaired // returns the value in Adash
  $DC36       -
  $DC37       -
  $DC38   } Outer_HL += 7; // stride
  $DC3E } while (--B);
  $DC40 return;

; ------------------------------------ ------------------------------------------

c $DC41 sub_DC41
  $DC41 A &= 0x3F;
  $DC43 possibly_holds_an_item = A;
  $DC46 HL = IY + 2;
  $DC4B DE = &byte_81B2;
  $DC4E BC = 5;
  $DC51 LDIR
  $DC53 EX DE,HL
  $DC54 *HL = B;
  $DC55 HL = &item_definitions[A];
  $DC5E HL++; // &item_definitions[A].second_member
  $DC5F A = (HL);
  $DC60 item_def_2nd_memb_copy = A;
  $DC63 HL++;
  $DC64 memcpy(&bitmap_pointer, HL, 4); // copy bitmap and mask pointers
  $DC6C sub_DD02();
  $DC6F if (!Z) return;
;
  $DC70 PUSH BC
  $DC71 PUSH DE
  $DC72 A = E;
  $DC73 ($E2C2) = A; // self modify
  $DC76 A = B;
  $DC77 if (A == 0) {
  $DC7B   A = 0x77; // 0b01110111
  $DC7D   Adash = C; }
  $DC7F else {
  $DC81   A = 0;
  $DC82   Adash = 3 - C; }
  $DC86
  $DC87 Cdash = Adash;
  $DC88
  $DC89 HLdash = &masked_sprite_plotter_16_jump_table[0];
  $DC8C Bdash = 3; // iterations
  $DC8E do { Edash = *HLdash++;
  $DC90   Ddash = *HLdash;
  $DC91   *DEdash = A;
  $DC92   HLdash++;
  $DC93   Edash = *HLdash++;
  $DC95   Ddash = *HLdash++;
  $DC97   *DEdash = A;
  $DC98   if (--Cdash == 0) A |= 0x77;
  $DC9D } while (--Bdash);
  $DC9F
  $DCA0 A = D;
  $DCA1 A &= A;
  $DCA2 DE = 0;
  $DCA5 if (Z) {
  $DCA7   HL = $81BC;
  $DCAA   A = ($81B6) - *HL;
  $DCAE   HL = A * 192;
  $DCBB   EX DE,HL }
;
  $DCBC A = map_position_related_1;
  $DCBF HL = $81BB; // &map_position;
  $DCC2 A -= *HL;
  $DCC3 HL = A;
  $DCC6 if (carry) H = 0xFF;
  $DCCA HL += DE;
  $DCCB DE = $F290; // screen buffer start address
  $DCCE HL += DE;
  $DCCF ($81A2) = HL;  // screen buffer pointer
  $DCD2 HL = $8100;
  $DCD5 POP DE
  $DCD6 PUSH DE
  $DCD7 L += D * 4;
  $DCDC ($81B0) = HL;
  $DCDF POP DE
  $DCE0 PUSH DE
  $DCE1 A = D;
  $DCE2 if (A) {
  $DCE5   D = A;
  $DCE6   A = 0;
  $DCE7   E = 3; // unusual (or self modified and i've not spotted the setter)
  $DCE9   E--;
  $DCEA   do { A += E; } while (--D); }
;
  $DCEF E = A;
  $DCF0 bitmap_pointer += DE;
  $DCF7 mask_pointer += DE;
  $DCFE POP BC
  $DCFF POP DE
  $DD00 A = 0;
  $DD01 return;

; ------------------------------------------------------------------------------

c $DD02 sub_DD02
D $DD02 This is range checking something.
R $DD02 O:AF Z => ?, !Z => ?
R $DD02 O:BC
R $DD02 O:DE
  $DD02 HL = &map_position_related_1;
  $DD05 DE = map_position;
  $DD09 A = E + 24 - HL[0];
  $DD0D if (A <= 0) goto return_1;
  $DD11 if (A < 3) {
  $DD16   BC = A; }
  $DD19 else {
  $DD1B   A = HL[0] + 3 - E;
  $DD1F   if (A <= 0) goto return_1;
  $DD23   if (A < 3) {
  $DD28     C = A;
  $DD29     B = 3 - C; }
  $DD2D   else {
  $DD2F     BC = 3; } }
  $DD33 A = D + 17 - HL[1];
  $DD38 if (A <= 0) goto return_1;
  $DD3C if (A < 2) {
  $DD41   DE = 8; }
  $DD45 else {
  $DD47   A = HL[1] + 2 - D;
  $DD4B   if (A <= 0) goto return_1;
  $DD4F   if (A < 2) {
  $DD54     E = item_def_2nd_memb_copy - 8;
  $DD5A     D = 8; }
  $DD5C   else {
  $DD5E     DE = item_def_2nd_memb_copy; } }
;
  $DD64 return_0: A = 0;
  $DD65 return;

  $DD66 return_1: A |= 1;
  $DD68 return;

; ------------------------------------------------------------------------------

b $DD69 item_attributes
D $DD69 20 bytes, 4 of which are unknown, possibly unused.
D $DD69 'Yellow/black' means yellow ink over black paper, for example.
;
  $DD69 item_attribute: WIRESNIPS - yellow/black
  $DD6A item_attribute: SHOVEL - cyan/black
  $DD6B item_attribute: LOCKPICK - cyan/black
  $DD6C item_attribute: PAPERS - white/black
  $DD6D item_attribute: TORCH - green/black
  $DD6E item_attribute: BRIBE - bright-red/black
  $DD6F item_attribute: UNIFORM - green/black
  $DD70 item_attribute: FOOD - white/black
D $DD70 Food turns purple/black when it's poisoned.
  $DD71 item_attribute: POISON - purple/black
  $DD72 item_attribute: RED KEY - bright-red/black
  $DD73 item_attribute: YELLOW KEY - yellow/black
  $DD74 item_attribute: GREEN KEY - green/black
  $DD75 item_attribute: PARCEL - cyan/black
  $DD76 item_attribute: RADIO - white/black
  $DD77 item_attribute: PURSE - white/black
  $DD78 item_attribute: COMPASS - green/black
  $DD79 item_attribute: Unused? - yellow/black
  $DD7A item_attribute: Unused? - cyan/black
  $DD7B item_attribute: Unused? - bright-red/black
  $DD7C item_attribute: Unused? - bright-red/black

; ------------------------------------------------------------------------------

b $DD7D item_definitions
D $DD7D Item definitions:
D $DD7D Array of "sprite" structures.
;
  $DD7D { 2, 11, wiresnips_data, wiresnips_mask },
  $DD83 { 2, 13, shovel_data, shovelkey_mask },
  $DD89 { 2, 16, lockpick_data, lockpick_mask },
  $DD8F { 2, 15, papers_data, papers_mask },
  $DD95 { 2, 12, torch_data, torch_mask },
  $DD9B { 2, 13, bribe_data, bribe_mask },
  $DDA1 { 2, 16, uniform_data, uniform_mask },
  $DDA7 { 2, 16, food_data, food_mask },
  $DDAD { 2, 16, poison_data, poison_mask },
  $DDB3 { 2, 13, key_data, shovelkey_mask },
  $DDB9 { 2, 13, key_data, shovelkey_mask },
  $DDBF { 2, 13, key_data, shovelkey_mask },
  $DDC5 { 2, 16, parcel_data, parcel_mask },
  $DDCB { 2, 16, radio_data, radio_mask },
  $DDD1 { 2, 12, purse_data, purse_mask },
  $DDD7 { 2, 12, compass_data, compass_mask },

; ------------------------------------------------------------------------------

b $DDDD item_bitmaps_and_masks
D $DDDD Item bitmaps and masks.
D $DDDD Raw data.
;
B $DDDD item_bitmap: SHOVEL
D $DDDD #UDGARRAY2,7,4,2;$DDDD-$DDF6-1-16{0,0,64,52}(item-shovel)
;
B $DDF7 item_bitmap: KEY (shared for all keys)
D $DDF7 #UDGARRAY2,7,4,2;$DDF7-$DE10-1-16{0,0,64,52}(item-key)
;
B $DE11 item_bitmap: LOCKPICK
D $DE11 #UDGARRAY2,7,4,2;$DE11-$DE30-1-16{0,0,64,64}(item-lockpick)
;
B $DE31 item_bitmap: COMPASS
D $DE31 #UDGARRAY2,7,4,2;$DE31-$DE48-1-16{0,0,64,48}(item-compass)
;
B $DE49 item_bitmap: PURSE
D $DE49 #UDGARRAY2,7,4,2;$DE49-$DE60-1-16{0,0,64,48}(item-purse)
;
B $DE61 item_bitmap: PAPERS
D $DE61 #UDGARRAY2,7,4,2;$DE61-$DE7E-1-16{0,0,64,60}(item-papers)
;
B $DE7F item_bitmap: WIRESNIPS
D $DE7F #UDGARRAY2,7,4,2;$DE7F-$DE94-1-16{0,0,64,44}(item-wiresnips)
;
B $DE95 item_mask: SHOVEL or KEY (shared)
D $DE95 #UDGARRAY2,7,4,2;$DE95-$DEAE-1-16{0,0,64,52}(item-mask-shovelkey)
;
B $DEAF item_mask: LOCKPICK
D $DEAF #UDGARRAY2,7,4,2;$DEAF-$DECE-1-16{0,0,64,64}(item-mask-lockpick)
;
B $DECF item_mask: COMPASS
D $DECF #UDGARRAY2,7,4,2;$DECF-$DEE6-1-16{0,0,64,48}(item-mask-compass)
;
B $DEE7 item_mask: PURSE
D $DEE7 #UDGARRAY2,7,4,2;$DEE7-$DEFE-1-16{0,0,64,48}(item-mask-purse)
;
B $DEFF item_mask: PAPERS
D $DEFF #UDGARRAY2,7,4,2;$DEFF-$DF1C-1-16{0,0,64,60}(item-mask-papers)
;
B $DF1D item_mask: WIRESNIPS
D $DF1D #UDGARRAY2,7,4,2;$DF1D-$DF32-1-16{0,0,64,44}(item-mask-wiresnips)
;
B $DF33 item_bitmap: FOOD
D $DF33 #UDGARRAY2,7,4,2;$DF33-$DF52-1-16{0,0,64,64}(item-food)
;
B $DF53 item_bitmap: POISON
D $DF53 #UDGARRAY2,7,4,2;$DF53-$DF72-1-16{0,0,64,64}(item-poison)
;
B $DF73 item_bitmap: TORCH
D $DF73 #UDGARRAY2,7,4,2;$DF73-$DF8A-1-16{0,0,64,48}(item-torch)
;
B $DF8B item_bitmap: UNIFORM
D $DF8B #UDGARRAY2,7,4,2;$DF8B-$DFAA-1-16{0,0,64,64}(item-uniform)
;
B $DFAB item_bitmap: BRIBE
D $DFAB #UDGARRAY2,7,4,2;$DFAB-$DFC4-1-16{0,0,64,52}(item-bribe)
;
B $DFC5 item_bitmap: RADIO
D $DFC5 #UDGARRAY2,7,4,2;$DFC5-$DFE4-1-16{0,0,64,64}(item-radio)
;
B $DFE5 item_bitmap: PARCEL
D $DFE5 #UDGARRAY2,7,4,2;$DFE5-$E004-1-16{0,0,64,64}(item-parcel)
;
B $E005 item_mask: BRIBE
D $E005 #UDGARRAY2,7,4,2;$E005-$E01E-1-16{0,0,64,52}(item-mask-bribe)
;
B $E01F item_mask: UNIFORM
D $E01F #UDGARRAY2,7,4,2;$E01F-$E03E-1-16{0,0,64,48}(item-mask-uniform)
;
B $E03F item_mask: PARCEL
D $E03F #UDGARRAY2,7,4,2;$E03F-$E05E-1-16{0,0,64,64}(item-mask-parcel)
;
B $E05F item_mask: POISON
D $E05F #UDGARRAY2,7,4,2;$E05F-$E07E-1-16{0,0,64,64}(item-mask-poison)
;
B $E07F item_mask: TORCH
D $E07F #UDGARRAY2,7,4,2;$E07F-$E096-1-16{0,0,64,48}(item-mask-torch)
;
B $E097 item_mask: RADIO
D $E097 #UDGARRAY2,7,4,2;$E097-$E0B6-1-16{0,0,64,64}(item-mask-radio)
;
B $E0B7 item_mask: FOOD
D $E0B7 #UDGARRAY2,7,4,2;$E0B7-$E0D6-1-16{0,0,64,64}(item-mask-food)

; ------------------------------------------------------------------------------

z $E0D7 unused_E0D7
D $E0D7 Unreferenced byte.

; ------------------------------------------------------------------------------

w $E0E0 masked_sprite_plotter_16_jump_table
D $E0E0 (<- sub_DC41, setup_sprite_plotting)
  $E0E0 masked_sprite_plotter_16_wide_case_1:jump0
  $E0E2 masked_sprite_plotter_16_wide_case_2:jump1
  $E0E4 masked_sprite_plotter_16_wide_case_1:jump2
  $E0E6 masked_sprite_plotter_16_wide_case_2:jump3
  $E0E8 masked_sprite_plotter_16_wide_case_1:jump4
  $E0EA masked_sprite_plotter_16_wide_case_2:jump5

; ------------------------------------------------------------------------------

w $E0EC masked_sprite_plotter_24_jump_table
D $E0EC (<- setup_sprite_plotting)
  $E0EC masked_sprite_plotter_24_wide:E188
  $E0EE masked_sprite_plotter_24_wide:E259
  $E0F0 masked_sprite_plotter_24_wide:E199
  $E0F2 masked_sprite_plotter_24_wide:E26A
  $E0F4 masked_sprite_plotter_24_wide:E1AA
  $E0F6 masked_sprite_plotter_24_wide:E27B
  $E0F8 masked_sprite_plotter_24_wide:E1BF
  $E0FA masked_sprite_plotter_24_wide:E290
; these two look different
  $E0FC masked_sprite_plotter_16_wide_case_1
  $E0FE masked_sprite_plotter_24_wide

; ------------------------------------------------------------------------------

u $E100 unused_E100
D $E100 Unsure if related to the above masked_sprite_plotter_24_jump_table table.

; ------------------------------------------------------------------------------

; masked_sprite_plotters
;
; An w-wide masked sprite plotter takes a w-pixel wide input bitmap and plots
; it across, up to, (w+8) pixels.
;

c $E102 masked_sprite_plotter_24_wide
D $E102 Sprite plotter. Used for characters and objects.
R $E102 I:IY Unsure. Have seen IY = 0x8020 => 0x8038, IY = 0x8040, IY = 0x80A0.
;
  $E102 if ((A = IY[24] & 7) >= 4) goto unaligned;
;
  $E10C A = (~A & 3) * 8; // jump table offset
  $E112 ($E161) = A; // self-modify // set branch target of second jump
  $E115 ($E143) = A; // self-modify // set branch target of first jump
  $E118 maskptr = mask_pointer; // mask pointer
  $E11C bitmapptr = bitmap_pointer; // bitmap pointer
  $E120 iters = 32; // iterations // height? // self modified
  $E122 do { bm0 = *bitmapptr++; // bitmap bytes
  $E125   bm1 = *bitmapptr++;
  $E127   bm2 = *bitmapptr++;
  $E12B   mask0 = *maskptr++; // mask bytes
  $E12D   mask1 = *maskptr++;
  $E12F   mask2 = *maskptr++;
  $E132   if (flip_sprite & (1<<7)) flip_24_masked_pixels();
  $E139   foremaskptr = foreground_mask_pointer;
  $E13D   screenptr = ($81A2); // screen ptr // moved compared to the other routines
;
D $E140 Shift bitmap.
;
  $E140   bm3 = 0;
  $E142   goto $E144; // self-modified // jump table
  $E144   SRL bm0 // 0 // carry = bm0 & 1; bm0 >>= 1;
  $E146   RR bm1       // new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry;
  $E148   RR bm2       // new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry;
  $E14A   RR bm3       // new_carry = bm3 & 1; bm3 = (bm3 >> 1) | (carry << 7); carry = new_carry;
  $E14C   SRL bm0 // 1
  $E14E   RR bm1
  $E150   RR bm2
  $E152   RR bm3
  $E154   SRL bm0 // 2
  $E156   RR bm1
  $E158   RR bm2
  $E15A   RR bm3
;
D $E15D Shift mask.
;
  $E15D   mask3 = 0xFF;
  $E15F   carry = 1;
  $E160   goto $E162; // self-modified // jump table
  $E162   RR mask0 // 0 // new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry;
  $E164   RR mask1      // new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry;
  $E166   RR mask2      // new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry;
  $E168   RR mask3      // new_carry = mask3 & 1; mask3 = (mask3 >> 1) | (carry << 7); carry = new_carry;
  $E16A   RR mask0
  $E16C   RR mask1
  $E16E   RR mask2
  $E170   RR mask3
  $E172   RR mask0
  $E174   RR mask1
  $E176   RR mask2
  $E178   RR mask3
;
D $E17A   Plot, using foreground mask.
;
  $E17A   A = ((~*foremaskptr | mask0) & *screenptr) | (bm0 & *foremaskptr);
  $E186   foremaskptr++;
;
  $E188   *screenptr++ = A;          // jump target 0
  $E18B   A = ((~*foremaskptr | mask1) & *screenptr) | (bm1 & *foremaskptr);
  $E197   foremaskptr++;
;
  $E199   *screenptr++ = A;          // jump target 2
  $E19C   A = ((~*foremaskptr | mask2) & *screenptr) | (bm2 & *foremaskptr);
  $E1A8   foremaskptr++;
;
  $E1AA   *screenptr++ = A;          // jump target 4
  $E1AD   A = ((~*foremaskptr | mask3) & *screenptr) | (bm3 & *foremaskptr);
  $E1B9   foremaskptr++;
  $E1BA   foreground_mask_pointer = foremaskptr;
;
  $E1BD   *screenptr = A;            // jump target 6
  $E1C0   screenptr += 21; // stride (24 - 3)
  $E1C4   ($81A2) = screenptr;
  $E1C8 } while (--iters);
  $E1CD return;


  $E1CE unaligned: A -= 4;
  $E1D0 RLCA
  $E1D1 RLCA
  $E1D2 RLCA
  $E1D3 ($E22A) = A; // self-modify: set branch target - second jump
  $E1D6 ($E204) = A; // self-modify: set branch target - first jump
  $E1D9 HLdash = mask_pointer;
  $E1DD HL = bitmap_pointer;
  $E1E1 B = 32;
  $E1E3 do { PUSH BC
  $E1E4   B = *HL++;
  $E1E6   C = *HL++;
  $E1E8   E = *HL++;
  $E1EA   PUSH HL
  $E1EB   EXX
  $E1EC   B = *HL++;
  $E1EE   C = *HL++;
  $E1F0   E = *HL++;
  $E1F2   PUSH HL
  $E1F3   if (flip_sprite & (1<<7)) flip_24_masked_pixels();
  $E1FA   HL = foreground_mask_pointer;
  $E1FD   EXX
  $E1FE   HL = ($81A2);
  $E201   D = 0;
  $E203   goto $E205; // self-modified to jump into ...;
  $E205   SLA E
  $E207   RL C
  $E209   RL B
  $E20B   RL D
  $E20D   SLA E
  $E20F   RL C
  $E211   RL B
  $E213   RL D
  $E215   SLA E
  $E217   RL C
  $E219   RL B
  $E21B   RL D
  $E21D   SLA E
  $E21F   RL C
  $E221   RL B
  $E223   RL D
  $E225   EXX
  $E226   D = 255;
  $E228   SCF
  $E229   goto $E22B; // self-modified to jump into ...;
  $E22B   RL E
  $E22D   RL C
  $E22F   RL B
  $E231   RL D
  $E233   RL E
  $E235   RL C
  $E237   RL B
  $E239   RL D
  $E23B   RL E
  $E23D   RL C
  $E23F   RL B
  $E241   RL D
  $E243   RL E
  $E245   RL C
  $E247   RL B
  $E249   RL D
;
  $E24B   A = ~*HL | D;       // 1
  $E24E   EXX
  $E24F   A &= *HL;
  $E250   EX AF,AF'
  $E251   A = D;
  $E252   EXX
  $E253   A &= *HL;
  $E254   D = A;
  $E255   EX AF,AF'
  $E256   A |= D;
  $E257   L++;
  $E258   EXX
  $E259   *HL++ = A;          // jump target 2
  $E25B   EXX
  $E25C   A = ~*HL | B;       // 2
  $E25F   EXX
  $E260   A &= *HL;
  $E261   EX AF,AF'
  $E262   A = B;
  $E263   EXX
  $E264   A &= *HL;
  $E265   B = A;
  $E266   EX AF,AF'
  $E267   A |= B;
  $E268   L++;
  $E269   EXX
  $E26A   *HL++ = A;          // jump target 3
  $E26C   EXX
  $E26D   A = ~*HL | C;       // 3
  $E270   EXX
  $E271   A &= *HL;
  $E272   EX AF,AF'
  $E273   A = C;
  $E274   EXX
  $E275   A &= *HL;
  $E276   C = A;
  $E277   EX AF,AF'
  $E278   A |= C;
  $E279   L++;
  $E27A   EXX
  $E27B   *HL++ = A;          // jump target 5
  $E27D   EXX
  $E27E   A = ~*HL | E;       // 4
  $E281   EXX
  $E282   A &= *HL;
  $E283   EX AF,AF'
  $E284   A = E;
  $E285   EXX
  $E286   A &= *HL;
  $E287   E = A;
  $E288   EX AF,AF'
  $E289   A |= E;
  $E28A   L++;
  $E28B   foreground_mask_pointer = HL;
  $E28E   POP HL
  $E28F   EXX
  $E290   *HL = A;            // jump target 7
  $E291   HL += 21;
  $E295   ($81A2) = HL;
  $E298   POP HL
  $E299   POP BC
  $E29A } while (--B);
  $E29E return;

; ------------------------------------------------------------------------------

c $E29F masked_sprite_plotter_16_wide_case_1_searchlight
D $E29F Direct entry point used by searchlight code.
  $E29F A = 0;
  $E2A0 goto $E2AC;

; ------------------------------------------------------------------------------
;
; +-----+ +-----+
; |  *  | |** **|
; | *** | |*   *|
; |  *  | |** **|
; +-----+ +-----+
; sprite  mask
;

c $E2A2 masked_sprite_plotter_16_wide_case_1
D $E2A2 Sprite plotter. Used for characters and objects.
D $E2A2 Looks like it plots a two byte-wide sprite with mask into a three byte-wide destination.
  $E2A2 if ((A = IY[24] & 7) >= 4) goto masked_sprite_plotter_16_wide_case_2;
;
; This entry point is used by the routine at #R$E29F.
;
  $E2AC A = (~A & 3) * 6; // jump table offset
  $E2B3 ($E2DC) = A; // self-modify - first jump
  $E2B6 ($E2F4) = A; // self-modify - second jump
  $E2B9 maskptr = mask_pointer; // maskptr = HL'  // observed: $D505 (a mask)
  $E2BE bitmapptr = bitmap_pointer; // bitmapptr = HL  // observed: $D256 (a bitmap)
;
  $E2C1 B = 32; // iterations // height? // self modified
  $E2C3 do { bm0 = *bitmapptr++; // D
  $E2C5   bm1 = *bitmapptr++; // E
  $E2C7   mask0 = *maskptr++; // D'
  $E2CB   mask1 = *maskptr++; // E'
  $E2CE   if (flip_sprite & (1<<7)) flip_16_masked_pixels();
; I'm assuming foremaskptr to be a foreground mask pointer based on it being
; incremented by four each step, like a supertile wide thing.
  $E2D5   foremaskptr = foreground_mask_pointer;  // observed: $8100 (mask buffer)
;
D $E2D8 Shift mask.
;
  $E2D8   mask2 = 0xFF; // all bits set => mask OFF (that would match the observed stored mask format)
  $E2DA   carry = 1; // mask OFF
  $E2DB   goto $E2DD; // self modified // jump table
; RR = 9-bit rotation to the right
  $E2DD   RR mask0 // 0 // new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry;
  $E2DF   RR mask1      // new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry;
  $E2E1   RR mask2      // new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry;
  $E2E3   RR mask0 // 1
  $E2E5   RR mask1
  $E2E7   RR mask2
  $E2E9   RR mask0 // 2
  $E2EB   RR mask1
  $E2ED   RR mask2
;
D $E2EF Shift bitmap.
;
  $E2EF   bm2 = 0; // all bits clear => pixels OFF
  $E2F2   A &= A; // I do not grok this. Setting carry flag?
  $E2F3   goto $E2F5; // self modified // jump table
  $E2F5   SRL bm0 // 0 // carry = bm0 & 1; bm0 >>= 1;
  $E2F7   RR bm1       // new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry;
  $E2F9   RR bm2       // new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry;
  $E2FB   SRL bm0 // 1
  $E2FD   RR bm1
  $E2FF   RR bm2
  $E301   SRL bm0 // 2
  $E303   RR bm1
  $E305   RR bm2
;
D $E307 Plot, using foreground mask.
;
  $E307   screenptr = ($81A2);
  $E30A   A = ((~*foremaskptr | mask0) & *screenptr) | (bm0 & *foremaskptr);
  $E317   foremaskptr++;
;
  $E319   *screenptr++ = A; // entry point jump0
  $E31B   A = ((~*foremaskptr | mask1) & *screenptr) | (bm1 & *foremaskptr);
  $E328   foremaskptr++;
;
  $E32A   *screenptr++ = A; // entry point jump2
  $E32C   A = ((~*foremaskptr | mask2) & *screenptr) | (bm2 & *foremaskptr);
  $E339   foremaskptr += 2;
  $E33B   foreground_mask_pointer = foremaskptr;
;
  $E340   *screenptr = A; // entry point jump4
  $E341   screenptr += 22; // stride (24 - 2)
  $E345   ($81A2) = screenptr;
  $E348 } while (--B);
  $E34D return;

; ------------------------------------------------------------------------------

c $E34E masked_sprite_plotter_16_wide_case_2
D $E34E Sprite plotter. Used for characters and objects.
D $E34E Similar variant to above routine.
  $E34E A = (A - 4) * 6; // jump table offset
  $E354 ($E39A) = A; // self-modify - first jump
  $E357 ($E37D) = A; // self-modify - second jump
  $E35A maskptr = mask_pointer;
  $E35E bitmapptr = bitmap_pointer;
;
  $E362 B = 32; // iterations // height? // self modified
  $E364 do { bm1 = *bitmapptr++; // numbering of the masks ... unsure
  $E366   bm2 = *bitmapptr++;
  $E368   mask1 = *maskptr++;
  $E36C   mask2 = *maskptr++;
  $E36E   if (flip_sprite & (1<<7)) flip_16_masked_pixels();
  $E376   foremaskptr = foreground_mask_pointer;
;
D $E379   Shift mask.
;
  $E379   mask0 = 0xFF; // all bits set => mask OFF (that would match the observed stored mask format)
  $E37B   carry = 1; // mask OFF
  $E37C   goto $E37E; // self modified // jump table
; RL = 9-bit rotation to the left
  $E37E   RL mask2 // 0 // new_carry = mask2 >> 7; mask2 = (mask2 << 1) | (carry << 0); carry = new_carry;
  $E380   RL mask1      // new_carry = mask1 >> 7; mask1 = (mask1 << 1) | (carry << 0); carry = new_carry;
  $E382   RL mask0      // new_carry = mask0 >> 7; mask0 = (mask0 << 1) | (carry << 0); carry = new_carry;
  $E384   RL mask2 // 1
  $E386   RL mask1
  $E388   RL mask0
  $E38A   RL mask2 // 2
  $E38C   RL mask1
  $E38E   RL mask0
  $E390   RL mask2 // 3 // four groups of shifting in this routine, compared to three above.
  $E392   RL mask1
  $E394   RL mask0
;
D $E396 Shift bitmap.
;
  $E396   bm0 = 0; // all bits clear => pixels OFF
  $E399   goto $E39B; // self modified // jump table
  $E39B   SLA bm2 // 0 // carry = bm2 >> 7; bm2 <<= 1;
  $E39D   RL bm1       // new_carry = bm1 >> 7; bm1 = (bm1 << 1) | (carry << 0); carry = new_carry;
  $E39F   RL bm0       // new_carry = bm0 >> 7; bm0 = (bm0 << 1) | (carry << 0); carry = new_carry;
  $E3A1   SLA bm2
  $E3A3   RL bm1
  $E3A5   RL bm0
  $E3A7   SLA bm2
  $E3A9   RL bm1
  $E3AB   RL bm0
  $E3AD   SLA bm2
  $E3AF   RL bm1
  $E3B1   RL bm0
;
D $E3B3 Plot, using foreground mask.
;
  $E3B3   screenptr = ($81A2);
  $E3B6   A = ((~*foremaskptr | mask0) & *screenptr) | (bm0 & *foremaskptr);
  $E3C3   foremaskptr++;
;
  $E3C5   *screenptr++ = A; // entry point jump1
  $E3C7   A = ((~*foremaskptr | mask1) & *screenptr) | (bm1 & *foremaskptr);
  $E3D4   foremaskptr++;
;
  $E3D6   *screenptr++ = A; // entry point jump3
  $E3D8   A = ((~*foremaskptr | mask2) & *screenptr) | (bm2 & *foremaskptr);
  $E3E5   foremaskptr += 2;
  $E3E7   foreground_mask_pointer = foremaskptr;
;
  $E3EC   *screenptr = A; // entry point jump5
  $E3ED   screenptr += 22; // stride (24 - 2)
  $E3F1   ($81A2) = screenptr;
  $E3F4 } while (--B);
  $E3F9 return;

; ------------------------------------------------------------------------------

c $E3FA flip_24_masked_pixels
D $E3FA Takes the 24 pixels in E,B,C and reverses them bitwise.
D $E3FA Does the same for the mask pixels in E',B',C'.
; Simultaneously:
;  C = reversed[E];
;  B = reversed[B];
;  E = reversed[C];
R $E3FA I:E  First 8 pixels.
R $E3FA I:BC Second 16 pixels.
R $E3FA O:E  Reversed pixels.
R $E3FA O:BC Reversed pixels.
D $E3FA Roll the bitmap.
  $E3FA H = 0x7F;  // HL = 0x7F00 | (DE & 0x00FF); // 0x7F00 -> table of bit reversed bytes
  $E3FC L = E;
  $E3FD E = B;     // DE = (DE & 0xFF00) | (BC >> 8);
  $E3FE B = *HL;   // BC = (*HL << 8) | (BC & 0xFF);
  $E3FF L = E;     // HL = (HL & 0xFF00) | (DE & 0xFF);
  $E400 E = *HL;   // DE = (DE & 0xFF00) | *HL;
  $E401 L = C;     // HL = (HL & 0xFF00) | (BC & 0xFF);
  $E402 C = *HL;   // BC = (BC & 0xFF00) | *HL;
  $E403 -
D $E404 Roll the mask.
  $E404 Hdash = 0x7F;
  $E406 Ldash = Edash;
  $E407 Edash = Bdash;
  $E408 Bdash = *HLdash;
  $E409 Ldash = Edash;
  $E40A Edash = *HLdash;
  $E40B Ldash = Cdash;
  $E40C Cdash = *HLdash;
  $E40D -
  $E40E return;

; ------------------------------------------------------------------------------

c $E40F flip_16_masked_pixels
D $E40F Takes the 16 pixels in D,E and reverses them bitwise.
D $E40F Does the same for the mask pixels in D',E'.
R $E40F I:DE 16 pixels to reverse.
R $E40F O:DE Reversed pixels.
D $E40F Roll the bitmap.
  $E40F H = 0x7F;  // HL = 0x7F00 | (DE >> 8); // 0x7F00 -> table of bit reversed bytes
  $E411 L = D;
  $E412 D = E;     // DE = (E << 8) | *HL;
  $E413 E = *HL;
  $E414 L = D;     // HL = (HL & 0xFF00) | (DE >> 8);
  $E415 D = *HL;   // DE = (*HL << 8) | (DE & 0x00FF);
  $E416 -
; 'dash' is assigned here relative to the register state on entry
D $E417 Roll the mask.
  $E417 Hdash = 0x7F;
  $E419 Ldash = Ddash;
  $E41A Ddash = Edash;
  $E41B Edash = *HLdash;
  $E41C Ldash = Ddash;
  $E41D Ddash = *HLdash;
  $E41E -
  $E41F return;

; ------------------------------------------------------------------------------

c $E420 setup_sprite_plotting
D $E420 Sets sprites up for plotting.
R $E420 I:HL Pointer to ? // observed: always the same as IY
R $E420 I:IY Pointer to ? // observed: $8000+
  $E420 HL += 15;
  $E424 DE = &byte_81B2;
  $E427 if (room_index) { // indoors
  $E42D   *DE++ = *HL++;
  $E42F   HL++;
  $E430   *DE++ = *HL++;
  $E432   HL++;
  $E433   *DE++ = *HL++;
  $E435   HL++; }
  $E436 else { // outdoors
  $E438   A = *HL++;
  $E43A   C = *HL;
  $E43B   divide_by_8_with_rounding(C,A);
  $E43E   *DE++ = A;
  $E43F   HL++;
  $E441   B = 2; // 2 iterations
  $E443   do { A = *HL++;
  $E445     C = *HL;
  $E446     divide_by_8(C,A);
  $E449     *DE++ = A;
  $E44A     HL++;
  $E44C   } while (--B); }
  $E44E C = *HL++;
  $E450 B = *HL++;
  $E451 PUSH BC
  $E453 flip_sprite = *HL++;  // set left/right flip flag
  $E457 -
  $E459 B = 2; // 2 iterations
  $E45B do { Adash = *HL++;
  $E45D   C = *HL++;
  $E45E   divide_by_8(C,Adash);
  $E461   *DE++ = Adash;
  $E464 } while (--B);
  $E466 -
  $E467 POP DE
  $E468 DE += A * 6;
  $E471 L += 2;
  $E473 EX DE,HL
  $E474 *DE++ = *HL++; // width in bytes
  $E476 *DE++ = *HL++; // height in rows
  $E478 memcpy(bitmap_pointer, HL, 4); // copy bitmap pointer and mask pointer
  $E480 sub_BAF7();
  $E483 if (A) return;
  $E485 PUSH BC
  $E486 PUSH DE
  $E487 A = IY[30];
  $E48A if (A == 3) { // 3 => 16 wide (4 => 24 wide)
  $E48E   ($E2C2) = E; // self-modify
  $E492   ($E363) = E; // self-modify
  $E495   A = 3;
  $E497   HL = masked_sprite_plotter_16_jump_table; }
  $E49A else {
  $E49C   A = E;
  $E49D   ($E121) = A; // self-modify
  $E4A0   ($E1E2) = A; // self-modify
  $E4A3   A = 4;
  $E4A5   HL = masked_sprite_plotter_24_jump_table; }
  $E4A8 PUSH HL
  $E4A9 ($E4C0) = A; // self-modify
  $E4AC E = A;
  $E4AD A = B;
  $E4AE if (A == 0) {
  $E4B1   A = 0x77;
  $E4B3   -
  $E4B4   Adash = C; }
  $E4B5 else {
  $E4B7   A = 0;
  $E4B8   -
  $E4B9   Adash = E - C; }
  $E4BB -
  $E4BC POP HLdash
  $E4BD Cdash = Adash;
  $E4BE -
  $E4BF Bdash = 3; // 3 iterations // self modified by $E4A9
  $E4C1 do { Edash = *HLdash++;
  $E4C3   Ddash = *HLdash++;
  $E4C4   *DEdash = A;
  $E4C6   Edash = *HLdash++;
  $E4C8   Ddash = *HLdash++;
  $E4CA   *DEdash = A;
  $E4CB   Cdash--;
  $E4CC   if (Z) A ^= 0x77;
  $E4D0 } while (--Bdash);
  $E4D2 -
  $E4D3 A = D;
  $E4D4 A &= A;
  $E4D5 DE = 0;
  $E4D8 if (Z) {
  $E4DA   HL = $81BC * 8;
  $E4E3   EX DE,HL
  $E4E4   L = IY[26];
  $E4E7   H = IY[27];
  $E4EA   A &= A;
  $E4EB   SBC HL,DE
  $E4ED   HL *= 24;
  $E4F4   EX DE,HL }
  $E4F5 HL = map_position_related_1 - (map_position & 0xFF); // ie. low byte of map_position
  $E4FF if (HL < 0) H = 0xFF;
  $E503 HL += DE + 0xF290; // screen buffer start address
  $E508 ($81A2) = HL;
  $E50B HL = 0x8100;
  $E50E POP DE
  $E50F PUSH DE
  $E510 L += D * 4 + (IY[26] & 7) * 4;
  $E51E foreground_mask_pointer = HL;
  $E521 POP DE
  $E522 A = D;
  $E523 if (A) {
  $E526   D = A;
  $E527   A = 0;
  $E528   E = IY[30] - 1;
  $E52C   do { A += E; } while (--D); }
  $E531 E = A;
  $E532 bitmap_pointer += DE;
  $E539 mask_pointer += DE;
  $E540 POP BC
  $E541 return;

; ------------------------------------------------------------------------------

c $E542 scale_pos
D $E542 Scale all three members of a 'pos_t'.
D $E542 Divides 3 words by 8 with rounding to nearest.
R $E542 I:HL Pointer to input words
R $E542 I:DE Pointer to output bytes
R $E542 O:HL Updated.
R $E542 O:DE Updated.
  $E542 B = 3;
  $E544 do { A = *HL++;
  $E546   C = *HL++;
  $E547   divide_by_8_with_rounding(C,A);
  $E54A   *DE++ = A;
  $E54D } while (--B);
  $E54F return;

c $E550 divide_by_8_with_rounding
D $E550 Divides AC by 8, with rounding to nearest.
R $E550 I:A Low.
R $E550 I:C High.
R $E550 O:A Result.
  $E550 A += 4;
  $E552 if (carry) C++;
;
; fallthrough

c $E555 divide_by_8
D $E555 Divides AC by 8.
  $E555 A = (A >> 3) | (C << 5); C >>= 3;
  $E55E return;

; ------------------------------------------------------------------------------

b $E55F probably_mask_data
D $E55F { byte count+flags; ... }
  $E55F probably_mask_0
  $E5FF probably_mask_1
  $E61E probably_mask_2
  $E6CA probably_mask_3
  $E74B probably_mask_4
  $E758 probably_mask_5
  $E77F probably_mask_6
  $E796 probably_mask_7
  $E7AF probably_mask_8
  $E85C probably_mask_9
  $E8A3 probably_mask_10
  $E8F0 probably_mask_11
  $E92F probably_mask_12
  $E940 probably_mask_13
  $E972 probably_mask_14
  $E99A probably_mask_15
  $E99F probably_mask_16
  $E9B9 probably_mask_17
  $E9C6 probably_mask_18
  $E9CB probably_mask_19
  $E9E6 probably_mask_20
  $E9F5 probably_mask_21
  $EA0E probably_mask_22
  $EA2B probably_mask_23
  $EA35 probably_mask_24
  $EA43 probably_mask_25
  $EA4A probably_mask_26
  $EA53 probably_mask_27
  $EA5D probably_mask_28
  $EA67 probably_mask_29

; ------------------------------------------------------------------------------

b $EA7C stru_EA7C
D $EA7C 47 7-byte structs.
  $EA7C,329,7 Elements.

; ------------------------------------------------------------------------------

w $EBC5 probably_mask_data_pointers
D $EBC5 30 pointers to byte arrays -- probably masks.

; ------------------------------------------------------------------------------

b $EC01 suspected_outdoor_mask_data
D $EC01 58 8-byte structs.
D $EC01 Used by suspected_mask_stuff. Used in outdoor mode only.
D $EC01 struct { ?, lo, hi, lo, hi, ?, ?, ? };

; ------------------------------------------------------------------------------

w $EDD1 saved_sp
D $EDD1 Used by plot_game_screen and wipe_game_screen.

; ------------------------------------------------------------------------------

w $EDD3 game_screen_start_addresses
D $EDD3 128 screen pointers.

; ------------------------------------------------------------------------------

c $EED3 plot_game_screen
  $EED3 saved_sp = SP;
  $EED7 A = *(&plot_game_screen_x + 1);
  $EEDA if (A) goto unaligned;
  $EEDE HL = $F291 + plot_game_screen_x;
  $EEE9 SP = game_screen_start_addresses;
  $EEEC A = 128; // 128 rows
  $EEEE do { DE = *SP++; // output address
  $EEEF   *DE++ = *HL++; // 23x
  $EEF1   *DE++ = *HL++;
  $EEF3   *DE++ = *HL++;
  $EEF5   *DE++ = *HL++;
  $EEF7   *DE++ = *HL++;
  $EEF9   *DE++ = *HL++;
  $EEFB   *DE++ = *HL++;
  $EEFD   *DE++ = *HL++;
  $EEFF   *DE++ = *HL++;
  $EF01   *DE++ = *HL++;
  $EF03   *DE++ = *HL++;
  $EF05   *DE++ = *HL++;
  $EF07   *DE++ = *HL++;
  $EF09   *DE++ = *HL++;
  $EF0B   *DE++ = *HL++;
  $EF0D   *DE++ = *HL++;
  $EF0F   *DE++ = *HL++;
  $EF11   *DE++ = *HL++;
  $EF13   *DE++ = *HL++;
  $EF15   *DE++ = *HL++;
  $EF17   *DE++ = *HL++;
  $EF19   *DE++ = *HL++;
  $EF1B   *DE++ = *HL++;
  $EF1D   HL++; // skip 24th
  $EF1E } while (--A);
  $EF22 SP = saved_sp;
  $EF26 return;

  $EF27 unaligned: HL = $F290 + plot_game_screen_x; // screen buffer start address
  $EF32 A = *HL++; // prime A
  $EF34 SP = game_screen_start_addresses;
  $EF37 Bdash = 128; // 128 rows
  $EF3A do {
  $EF3B   POP DE // output address
  $EF3C   B = 4; // 4 iterations of 5 plus 3 at the end == 23
  $EF3E   do { C = *HL;
  $EF3F     RRD             // tmp = *HL & 0x0F; *HL = (*HL >> 4) | (A << 4); A = (A & 0xF0) | tmp;
  $EF42     Adash = *HL;
  $EF43     *DE++ = Adash;
  $EF44     *HL++ = C;
  $EF48     C = *HL;
  $EF49     RRD
  $EF4C     Adash = *HL;
  $EF4D     *DE++ = Adash;
  $EF4E     *HL++ = C;
  $EF52     C = *HL;
  $EF53     RRD
  $EF56     Adash = *HL;
  $EF57     *DE++ = Adash;
  $EF58     *HL++ = C;
  $EF5C     C = *HL;
  $EF5D     RRD
  $EF60     Adash = *HL;
  $EF61     *DE++ = Adash;
  $EF62     *HL++ = C;
  $EF66     C = *HL;
  $EF67     RRD
  $EF6A     Adash = *HL;
  $EF6B     *DE++ = Adash;
  $EF6C     *HL++ = C;
  $EF70   } while (--B);
  $EF72   C = *HL;
  $EF73   RRD
  $EF76   Adash = *HL;
  $EF77   *DE++ = Adash;
  $EF78   *HL++ = C;
  $EF7C   C = *HL;
  $EF7D   RRD
  $EF80   Adash = *HL;
  $EF81   *DE++ = Adash;
  $EF82   *HL++ = C;
  $EF86   C = *HL;
  $EF87   RRD
  $EF8A   Adash = *HL;
  $EF8B   *DE++ = Adash;
  $EF8C   *HL++ = C;
  $EF90   A = *HL++;
  $EF93 } while (--Bdash);
  $EF95 SP = saved_sp;
  $EF99 return;

; ------------------------------------------------------------------------------

c $EF9A event_roll_call
D $EF9A Is the player within the roll call area bounds?
D $EF9A Range checking. X in (0x72..0x7C) and Y in (0x6A..0x72).
  $EF9A DE = map_ROLL_CALL_X;
  $EF9D HL = &player_map_position.y;
  $EFA0 B = 2; // iterations
  $EFA2 do { A = *HL++;
  $EFA3   if (A < D || A >= E) goto not_at_roll_call;
  $EFAA   DE = map_ROLL_CALL_Y;
  $EFAD } while (--B);
D $EFAF All visible characters turn forward.
  $EFAF HL = $800D;
  $EFB2 B = 8; // iterations
  $EFB4 do { *HL++ = 0x80; // movement
  $EFB7   *HL = 0x03; // direction (3 => face bottom left)
  $EFB9   HL += 31;
  $EFBD } while (--B);
  $EFBF return;

  $EFC0 not_at_roll_call: bell = bell_RING_PERPETUAL;
  $EFC4 queue_message_for_display(message_MISSED_ROLL_CALL);
  $EFC8 guards_persue_prisoners(); // exit via

; ------------------------------------------------------------------------------

; HOLY SMOKES!
; If you 'use' papers while wearing the uniform by the main gate you can leave
; the camp!
; I NEVER KNEW THAT!

c $EFCB action_papers
D $EFCB Is the player within the main gate bounds?
D $EFCB Range checking. X in (0x69..0x6D) and Y in (0x49..0x4B).
  $EFCB DE = map_MAIN_GATE_X;
  $EFCE HL = &player_map_position.y;
  $EFD1 B = 2; // iterations
  $EFD3 do { A = *HL++;
  $EFD4   if (A < D || A >= E) return;
  $EFD9   DE = map_MAIN_GATE_Y;
  $EFDC } while (--B);
D $EFDE Using the papers at the main gate when not in uniform causes the player to be sent to solitary.
  $EFDE if ($8015 != sprite_guard_tl_4) goto solitary; // exit via
  $EFE8 increase_morale_by_10_score_by_50();
  $EFEB $801C = room_0_outdoors; // set room index
D $EFEF Transition to outside the main gate.
  $EFEF HL = &word_EFF9; // pointer to location?
  $EFF2 IY = $8000; // player character
  $EFF6 transition(); return; // doesn't return: exits with goto main_loop

W $EFF9 word_EFF9 (<- action_papers)

; ------------------------------------------------------------------------------

u $EFFB unused_EFFB
D $EFFB Unreferenced byte.

; ------------------------------------------------------------------------------

c $EFFC user_confirm
D $EFFC Waits for the user to press Y or N.
R $EFFC O:F 'Y'/'N' pressed => return Z/NZ
  $EFFC HL = screenlocstring_confirm_y_or_n;
  $EFFF screenlocstring_plot();
  $F002 for (;;) { BC = port_KEYBOARD_POIUY;
  $F005   IN A,(C)
  $F007   if ((A & (1<<4)) == 0) return; // is 'Y' pressed? return Z
  $F00A   BC = port_KEYBOARD_SPACESYMSHFTMNB;
  $F00C   IN A,(C)
  $F00E   A = ~A;
  $F00F   if ((A & (1<<3)) != 0) return; // is 'N' pressed? return NZ
  $F012 }

; ------------------------------------------------------------------------------

b $F014 screenlocstring_confirm_y_or_n
D $F014 "CONFIRM Y OR N"
  $F014 #CALL:decode_screenlocstring($F014)

; ------------------------------------------------------------------------------

b $F025 more_messages
D $F025 More messages.
D $F026 "HE TAKES THE BRIBE"
  $F026 #CALL:decode_stringFF($F026)
D $F039 "AND ACTS AS DECOY"
  $F039 #CALL:decode_stringFF($F039)
D $F04B "ANOTHER DAY DAWNS"
  $F04B #CALL:decode_stringFF($F04B)

; ------------------------------------------------------------------------------

b $F05D gates_and_doors
  $F05D,2 gates_flags
  $F05F,7 door_flags
  $F066,2 unknown

; ------------------------------------------------------------------------------

c $F068 jump_to_main

; ------------------------------------------------------------------------------

b $F06B key_defs
D $F06B,10,2 User-defined keys. Pairs of (port, key mask).

; ------------------------------------------------------------------------------

b $F075 static_tiles_plot_direction
D $F075 0 for horizontal, 255 for vertical.

; ------------------------------------------------------------------------------

b $F076 static_graphic_defs
D $F076 struct: w(addr), flags+length, attrs[length]
  $F076 statics_flagpole
  $F08D statics_game_screen_left_border
  $F0A4 statics_game_screen_right_border
  $F0BB statics_game_screen_top_border
  $F0D5 statics_game_screen_bottom
  $F0EF statics_flagpole_grass
  $F0F7 statics_medals_row0
  $F107 statics_medals_row1
  $F115 statics_medals_row2
  $F123 statics_medals_row3
  $F131 statics_medals_row4
  $F13E statics_bell_row0
  $F144 statics_bell_row1
  $F14A statics_bell_row2
  $F14F statics_corner_tl
  $F154 statics_corner_tr
  $F159 statics_corner_bl
  $F15E statics_corner_br

; ------------------------------------------------------------------------------

c $F163 main
D $F163 Main.
D $F163 Disable interrupts and set up stack pointer.
  $F163 -
D $F167 Set up screen.
  $F167 wipe_full_screen_and_attributes();
  $F16A set_morale_flag_screen_attributes(attribute_BRIGHT_GREEN_OVER_BLACK);
  $F16F set_menu_item_attributes(attribute_YELLOW_OVER_BLACK);
  $F174 plot_statics_and_menu_text();
  $F177 plot_score();
  $F17A menu_screen();
D $F17D Construct a table of 256 bit-reversed bytes at 0x7F00.
  $F17D HL = 0x7F00;
  $F180 do { A = L;
  $F181   C = 0;
  $F183   B = 8; // iterations
  $F185   do { carry = A & 1; A >>= 1; // flips a byte
  $F186     C = (C << 1) | carry;
  $F188   } while (--B);
  $F18A   *HL++ = C;
  $F18F } while ((HL & 0xFF) != 0);
D $F190 Initialise visible characters (HL is $8000).
  $F190 DE = &vischar_initial;
  $F193 B = 8; // iterations
  $F195 do { -
  $F196   -
  $F198   memcpy(HL, DE, 23);
  $F19E   -
  $F19F   HL += 32;
  $F1A3   -
  $F1A4 } while (--B);
D $F1A7 Write 0xFF 0xFF at 0x8020 and every 32 bytes after.
  $F1A7 B = 7; // iterations
  $F1A9 HL = 0x8020; // iterate over non-player characters
  $F1AC -
  $F1AF -
  $F1B1 do { HL[0] = 0xFF;
  $F1B3   HL[1] = 0xFF;
  $F1B4   HL += 32;
  $F1B5 } while (--B);
D $F1B7 Zero 0x118 bytes at HL (== $8100) onwards.
D $F1B7 This is likely wiping everything up until the start of tiles ($8218).
  $F1B7 BC = 0x118;
  $F1BA do { *HL++ = 0; } while (--BC != 0); // turn into memset
  $F1C3 reset_game();
  $F1C6 goto main_loop_setup;

b $F1C9 vischar_initial
D $F1C9 Initial state of a visible character.

; ------------------------------------------------------------------------------

c $F1E0 plot_statics_and_menu_text
D $F1E0 Plot statics and menu text.
  $F1E0 HL = &static_graphic_defs[0];
  $F1E3 B = NELEMS(static_graphic_defs); // 18 iterations
  $F1E5 do { PUSH BC
D $F1E6 Fetch screen address.
  $F1E6   E = *HL++;
  $F1E8   D = *HL++;
  $F1EA   if (*HL & statictiles_VERTICAL)
  $F1EE     plot_static_tiles_vertical();
  $F1F1   else
  $F1F3     plot_static_tiles_horizontal();
  $F1F6   POP BC
  $F1F7 } while (--B);
D $F1F9 Plot menu text.
  $F1F9 B = 8; // 8 iterations
  $F1FB HL = &key_choice_screenlocstrings;
  $F1FE do { PUSH BC
  $F1FF   screenlocstring_plot();
  $F202   POP BC
  $F203 } while (--B);
  $F205 return;

; ------------------------------------------------------------------------------

c $F206 plot_static_tiles_horizontal
D $F206 Plot static screen tiles horizontally.
R $F206 I:DE Pointer to screen address.
R $F206 I:HL Pointer to tile indices.
  $F206 A = 0;
  $F207 goto plot_static_tiles;

; This entry point is used by the routine at #R$F1E0.
  $F209 plot_static_tiles_vertical: A = 255;
;
  $F20B plot_static_tiles: static_tiles_plot_direction = A;
  $F20E B = *HL++ & statictiles_COUNT_MASK; // loop iterations
  $F213 PUSH DE
  $F214 -
  $F215 POP DEdash
  $F216 -
  $F217 do { A = *HL;
  $F218   -
  $F219   HLdash = &static_tiles[A]; // elements: 9 bytes each
  $F227   Bdash = 8; // 8 iterations
D $F229 Plot a tile.
  $F229   do { *DEdash = *HLdash++;
  $F22B     DEdash += 256; // next row
  $F22D   } while (--Bdash);
  $F22F   DEdash -= 256;
  $F230   PUSH DEdash
D $F231 Calculate screen attribute address of tile.
  $F231   A = Ddash;
  $F232   Ddash = 0x58; // screen attributes base
  $F234   if (A >= 0x48) DEdash += 256;
  $F239   if (A >= 0x50) DEdash += 256;
  $F23E   *DEdash = *HLdash; // copy attribute byte
  $F240   POP HLdash
  $F241   A = static_tiles_plot_direction;
  $F244   if (A == 0) { // horizontal
  $F247     Hdash -= 7;  // HLdash -= 7 * 256;
  $F24B     Ldash++; }
  $F24C   else { // vertical
  $F24E     get_next_scanline(); }
  $F251   EX DEdash,HLdash
  $F252   -
  $F253   HL++;
  $F254 } while (--B);
  $F256 return;

; ------------------------------------------------------------------------------

c $F257 wipe_full_screen_and_attributes
  $F257 memset(screen, 0, 0x1800);
  $F265 memset(atttributes, attribute_WHITE_OVER_BLACK, 0x300);
  $F26D border = 0; // black
  $F270 return;

; ------------------------------------------------------------------------------

c $F271 select_input_device
  $F271 input_device_select_keyscan();
  $F274 if (A == 0xFF) return; // nothing happened
  $F277 if (A) {
  $F27A   A--; // 1..4 -> 0..3
  $F27B   PUSH AF
  $F27C   A = chosen_input_device;
  $F27F   set_menu_item_attributes(attribute_WHITE_OVER_BLACK);
  $F284   POP AF
  $F285   chosen_input_device = A;
  $F288   set_menu_item_attributes(attribute_BRIGHT_YELLOW_OVER_BLACK);
  $F28D   return; }
D $F28E Zero pressed to start game.
  $F28E else { A = chosen_input_device;
  $F292   memcpy($F075, inputroutine[A], 0x4A); // copy input routine to $F075, length 0x4A
  $F2A7   if (A == inputdevice_KEYBOARD) goto choose_keys; // keyboard was selected
  $F2AC   return; }

; ------------------------------------------------------------------------------

b $F2AD define_key_prompts
D $F2AD Key choice prompt strings.
D $F2AD "CHOOSE KEYS"
B $F2AD #CALL:decode_screenlocstring($F2AD)
D $F2BB "LEFT"
B $F2BB #CALL:decode_screenlocstring($F2BB)
D $F2C3 "RIGHT"
B $F2C3 #CALL:decode_screenlocstring($F2C3)
D $F2CC "UP"
B $F2CC #CALL:decode_screenlocstring($F2CC)
D $F2D2 "DOWN"
B $F2D2 #CALL:decode_screenlocstring($F2D2)
D $F2DA "FIRE"
B $F2DA #CALL:decode_screenlocstring($F2DA)

; ------------------------------------------------------------------------------

b $F2E1 byte_F2E1
D $F2E1 Unsure if anything reads this byte for real, but its address is taken prior to accessing keyboard_port_hi_bytes.
D $F2E1 (<- choose_keys)

b $F2E2 keyboard_port_hi_bytes
D $F2E2 Zero terminated.
D $F2E2 (<- choose_keys)

; ------------------------------------------------------------------------------

; Counted strings.
;
b $F2EB counted_strings
D $F2EB Counted strings (encoded to match font; first byte is count).
D $F2EB "ENTER"
B $F2EB #CALL:decode_stringcounted($F2EB)
D $F2F1 "CAPS"
B $F2F1 #CALL:decode_stringcounted($F2F1)
D $F2F6 "SYMBOL"
B $F2F6 #CALL:decode_stringcounted($F2F6)
D $F2FD "SPACE"
B $F2FD #CALL:decode_stringcounted($F2FD)

; ------------------------------------------------------------------------------

b $F303 key_tables
D $F303 Five bytes each.
B $F303 table_12345
B $F308 table_09876
B $F30D table_QWERT
B $F312 table_POIUY
B $F317 table_ASDFG
B $F31C table_ENTERLKJH
B $F321 table_SHIFTZXCV
B $F326 table_SPACESYMSHFTMNB

; ------------------------------------------------------------------------------

w $F32B key_name_screen_addrs
D $F32B Screen addresses of chosen key names (5 long).

; ------------------------------------------------------------------------------

c $F335 wipe_game_screen
D $F335 Wipe the game screen.
  $F335 DI
  $F336 saved_sp = SP;
  $F33A sp = game_screen_start_addresses;
  $F33D A = 128; // 128 rows
  $F33F do { POP HL // start address
  $F340   B = 23; // 23 columns
  $F342   do { *HL = 0;
  $F344     HL++;
  $F345   } while (--B);
  $F347 } while (--A);
  $F34B SP = saved_sp;
  $F34F return;

; ------------------------------------------------------------------------------

c $F350 choose_keys
  $F350 for (;;) { wipe_game_screen();
  $F353   set_game_screen_attributes(attribute_WHITE_OVER_BLACK);
D $F358 Draw key choice prompt strings.
  $F358   B = 6; // iterations
  $F35A   HL = &define_key_prompts[0];
  $F35D   do { PUSH BC
  $F35E     E = *HL++;
  $F360     D = *HL++;
  $F362     B = *HL++; // iterations
  $F364     do { PUSH BC
  $F365       A = *HL;
  $F366       plot_glyph();
  $F369       HL++;
  $F36A       POP BC
  $F36B     } while (--B);
  $F36D     POP BC
  $F36E   } while (--B);
D $F370 Wipe key_defs.
  $F370   HL = &key_defs[0];
  $F373   B = 10; // iterations
  $F375   A = 0;
  $F376   do { *HL++ = A;
  $F378   } while (--B);
  $F37A   B = 5; // iterations L/R/U/D/F
  $F37C   HL = &key_name_screen_addrs[0];
  $F37F   do { PUSH BC
  $F380     E = *HL++;
  $F382     D = *HL++;
  $F384     PUSH HL
  $F385     ($F3E9) = DE; // self modify screen addr
  $F389     A = 0xFF;
;
  $F38B     for (;;) { -
  $F38C       HL = &keyboard_port_hi_bytes[-1]; // &byte_F2E1
  $F38F       D = 0xFF;
  $F391       do { HL++;
  $F392         D++;
  $F393         Adash = *HL;
  $F394         if (Adash == 0) goto $F38B; // end of keyboard_port_hi_bytes
  $F397         B = Adash;
  $F398         C = 0xFE;
  $F39A         IN Adash,(C)
  $F39C         Adash = ~Adash;
  $F39D         E = Adash;
  $F39E         C = 0x20;
;
  $F3A0         C >>= 1;
  $F3A2       } while (carry);  // loop structure is not quite right
  $F3A4       Adash = C & E;
  $F3A6       if (Adash == 0) goto $F3A0;
  $F3A8       -
  $F3A9       if (A) goto $F38B;
  $F3AC       A = D;
  $F3AD       -
  $F3AE       HL = 0xF06A;
;
  $F3B1       HL++;
  $F3B2       Adash = *HL;
  $F3B3       if (Adash == 0) goto $F3C1;
  $F3B6       if (A != B) ...
  $F3B7       HL++; // interleaved
  $F3B8       ... goto $F3B1;
  $F3BA       Adash = *HL;
  $F3BB       if (A != C) goto $F3B1;
  $F3BE     }

  $F3C1     *HL++ = B;
  $F3C3     *HL = C;
  $F3C4     -
  $F3C5     A *= 5;
  $F3C9     HL = 0xF302;  // &key_tables[0] - 1 byte + A // strange: off by one
  $F3CC     HL += A;
;
  $F3D1     HL++;
  $F3D2     RR C
  $F3D4     JR NC,$F3D1
  $F3D6     B = 1;
  $F3D8     A = *HL;
  $F3D9     A |= A;
  $F3DA     JP P,$F3E8
  $F3DD     A &= 0x7F;
  $F3DF     HL = &counted_strings[0] + A;
  $F3E6     B = *HL++;
;
  $F3E8     DE = 0x40D5; // self modified // screen address
  $F3EB     do { PUSH BC
  $F3EC       A = *HL;
  $F3ED       plot_glyph();
  $F3F0       HL++;
  $F3F1       POP BC
  $F3F2     } while (--B);
  $F3F4     POP HL
  $F3F5     POP BC
  $F3F6   } while (--B);
D $F3F9 Delay loop.
  $F3F9   BC = 0xFFFF;
  $F3FC   while (--BC);
D $F401 Wait for user's input.
  $F401   user_confirm();
  $F404   if (Z) return; // confirmed
  $F405 }

; ------------------------------------------------------------------------------

c $F408 set_menu_item_attributes
R $F408 I:A Item index.
R $F408 I:E Attributes.
  $F408 HL = 0x590D; // initial screen attribute address
D $F40B Skip to the item's row.
  $F40B if (A) {
  $F40E   B = A;
  $F40F   do { L += 64; } while (--B); } // skip two rows per iteration
D $F415 Draw.
  $F415 B = 10;
  $F417 do { *HL++ = E; } while (--B);
  $F41B return;

; ------------------------------------------------------------------------------

c $F41C input_device_select_keyscan
  $F41C BC = port_KEYBOARD_12345;
  $F41F E = 0;
  $F421 IN A,(C)
  $F423 A = ~A & 0x0F;
  $F426 if (A) {
  $F428   B = 4; // iterations
  $F42A   do { A >>= 1;
  $F42B     E++;
  $F42C     if (C) goto found;
  $F42E   } while (--B);
  $F430   found: A = E;
  $F431   return; }
  $F432 else { B = 0xEF; // port_KEYBOARD_09876
  $F434   IN A,(C)
  $F436   A &= 1;
  $F438   A = E; // interleaved
  $F439   if (Z) return;
  $F43A   A = 0xFF; // no keypress
  $F43C   return; }

; ------------------------------------------------------------------------------

w $F43D inputroutines
D $F43D Array [4] of pointers to input routines.
  $F43D &inputroutine_keyboard,
  $F43F &inputroutine_kempston,
  $F441 &inputroutine_sinclair,
  $F443 &inputroutine_protek,

; ------------------------------------------------------------------------------

b $F445 chosen_input_device
D $F445 0/1/2/3 keyboard/kempston/sinclair/protek

; ------------------------------------------------------------------------------

b $F446 key_choice_screenlocstrings
D $F446 Key choice screenlocstrings.
D $F446 "CONTROLS"
B $F446 #CALL:decode_screenlocstring($F446)
D $F451 "0 SELECT"
B $F451 #CALL:decode_screenlocstring($F451)
D $F45C "1 KEYBOARD"
B $F45C #CALL:decode_screenlocstring($F45C)
D $F469 "2 KEMPSTON"
B $F469 #CALL:decode_screenlocstring($F469)
D $F476 "3 SINCLAIR"
B $F476 #CALL:decode_screenlocstring($F476)
D $F483 "4 PROTEK"
B $F483 #CALL:decode_screenlocstring($F483)
D $F48E "BREAK OR CAPS AND SPACE"
B $F48E #CALL:decode_screenlocstring($F48E)
D $F4A8 "FOR NEW GAME"
B $F4A8 #CALL:decode_screenlocstring($F4A8)

; ------------------------------------------------------------------------------

c $F4B7 menu_screen
D $F4B7 Runs the menu screen: waiting for user to select an input device, waving the morale flag and playing the title tune.
  $F4B7 for (;;) { select_input_device();
  $F4BA   wave_morale_flag();
D $F4BD Play music.
  $F4BD   HL = music_channel0_ptr + 1;
  $F4C1   for (;;) { music_channel0_ptr = HL;
  $F4C4     A = music_channel0_data[HL];
  $F4C9     if (A != 0xFF) break; // end marker
  $F4CD     HL = 0;
  $F4D0   }
  $F4D2   get_tuning();
  $F4D5   -
  $F4D6   HLdash = music_channel1_ptr + 1;
  $F4DA   for (;;) { music_channel1_ptr = HLdash;
  $F4DD     A = music_channel1_data[HLdash];
  $F4E2     if (A != 0xFF) break; // end marker
  $F4E6     HLdash = 0;
  $F4E9   }
  $F4EB   get_tuning(); // using banked registers
  $F4EE   A = Bdash;
  $F4EF   -
  $F4F0   PUSH BC
  $F4F1   if (A == 0xFF) {
  $F4F5     -
  $F4F6     POP BCdash
  $F4F7     DEdash = BCdash;
  $F4F9     - }
  $F4FA   else {
  $F4FC     POP BC }
  $F4FD   A = 24; // overall tune speed (lower => faster)
  $F4FF   do { -
  $F500     H = 0xFF; // iterations
  $F502     do { if (--B == 0) { // big-endian counting down?
  $F504         if (--C == 0) {
  $F508           L ^= 16;
  $F50C           OUT ($FE),L
  $F50E           BC = DE; } }
  $F510       -
  $F511       if (--Bdash == 0) {
  $F513         if (--Cdash == 0) {
  $F517           Ldash ^= 16;
  $F51B           OUT ($FE),Ldash
  $F51D           BCdash = DEdash; } }
  $F51F       -
  $F520     } while (--H);
  $F524     -
  $F525   } while (--A);
  $F529 }

; ------------------------------------------------------------------------------

c $F52C get_tuning
R $F52C I:A  Index.
R $F52C O:BC ...
R $F52C O:DE ...
  $F52C BC = music_tuning_table[A];
  $F537 C++;
  $F538 B++;
  $F539 if (B == 0) C++; // big-endian 16-bit add?
  $F53C L = 0;
  $F53E DE = BC;
  $F540 return;

w $F541 music_channel0_ptr
w $F543 music_channel1_ptr
b $F545 unknown/unused
b $F546 music_channel0_data
b $F7C7 music_channel1_data

; ------------------------------------------------------------------------------

w $FA48 music_tuning_table

; ------------------------------------------------------------------------------

u $FDE0 unused_FDE0
D $FDE0 Unreferenced byte.

; ------------------------------------------------------------------------------

c $FDE1 loaded
D $FDE1 Very first entry point used to shunt the game image down into its proper position.
  $FDE1 Disable interrupts.
  $FDE2 SP = 0xFFFF;
  $FDE5 memmove(0x5B00, 0x5E00, 0x9FE0);
  $FDF0 goto jump_to_main; // exit via

; ------------------------------------------------------------------------------

z $FDF3 unused_FDF3
D $FDF3 Unreferenced bytes.

; ------------------------------------------------------------------------------

; Input routines (not called directly)
;
; These are relocated to $F075 when chosen from the menu screen.

c $FE00 inputroutine_keyboard
D $FE00 Input routine for keyboard.
R $FE00 O:A Input value (as per enum input).
  $FE00 HL = key_defs; // pairs of bytes (port high byte, key mask)
  $FE03 C = 0xFE; // port 0xXXFE
D $FE05 Left/right.
  $FE05 B = *HL++;
  $FE07 IN A,(C)
  $FE09 A = ~A & *HL++;
  $FE0C if (A) {
  $FE0E   HL += 2; // skip right keydef
  $FE10   E = input_LEFT;
  $FE12 }
  $FE14 else { B = *HL++;
  $FE16   IN A,(C)
  $FE18   A = ~A & *HL++;
  $FE1B   if (A) {
  $FE1D     E = input_RIGHT;
  $FE1F   }
  $FE21   else { E = A; } }
D $FE22 Up/down.
  $FE22 B = *HL++;
  $FE24 IN A,(C)
  $FE26 A = ~A & *HL++;
  $FE29 if (A) {
  $FE2B   HL += 2; // skip down keydef
  $FE2D   E += input_UP;
  $FE2E }
  $FE30 else { B = *HL++;
  $FE32   IN A,(C)
  $FE34   A = ~A & *HL++;
  $FE37   if (A) {
  $FE39     E += input_DOWN; } }
D $FE3B Fire.
  $FE3B B = *HL++;
  $FE3D IN A,(C)
  $FE3F A = ~A & *HL++;
  $FE42 A = E;
  $FE43 if (A)
  $FE44   A += input_FIRE;
  $FE46 return;

; ------------------------------------------------------------------------------

c $FE47 inputroutine_protek
D $FE47 Input routine for Protek (cursor) joystick.
R $FE00 O:A Input value (as per enum input).
  $FE47 BC = port_KEYBOARD_12345;
  $FE4A IN A,(C)
  $FE4C A = ~A & (1<<4); // 5 == left
  $FE4F E = input_LEFT;
  $FE51 B = 0xEF; // port_KEYBOARD_09876
  $FE53 if (Z) {
  $FE55   IN A,(C)
  $FE57   A = ~A & (1<<2);
  $FE5A   E = input_RIGHT;
  $FE5C   if (Z)
  $FE5E     E = 0; // no horizontal }
  $FE60 IN A,(C)
  $FE62 A = ~A;
  $FE63 D = A;
  $FE64 A &= (1<<3);
  $FE66 A = input_UP; // interleaved
  $FE68 if (Z) {
  $FE6A   A = D;
  $FE6B   A &= (1<<4);
  $FE6D   A = input_DOWN; // interleaved
  $FE6F   if (Z)
  $FE71     A = input_NONE; }
  $FE72 E += A;
  $FE74 A = D & (1<<0);
  $FE77 A = input_FIRE; // interleaved
  $FE79 if (Z) A = 0; // no vertical
  $FE7C A += E; // combine axis
  $FE7D return;

; ------------------------------------------------------------------------------

c $FE7E inputroutine_kempston
D $FE7E Input routine for Kempston joystick.
; "#1F Kempston (000FUDLR, active high)"
R $FE00 O:A Input value (as per enum input).
  $FE7E BC = 0x001F;
  $FE81 IN A,(C)
  $FE83 BC = 0;
  $FE86 carry = A & 1; A >>= 1;
  $FE87 if (carry) B = input_RIGHT;
  $FE8B carry = A & 1; A >>= 1;
  $FE8C if (carry) B = input_LEFT;
  $FE90 carry = A & 1; A >>= 1;
  $FE91 if (carry) C = input_DOWN;
  $FE95 carry = A & 1; A >>= 1;
  $FE96 if (carry) C = input_UP;
  $FE9A carry = A & 1; A >>= 1;
  $FE9B A = input_FIRE;
  $FE9D if (!carry) A = 0;
  $FEA0 A += B + C;
  $FEA2 return;

; ------------------------------------------------------------------------------

c $FEA3 inputroutine_fuller
D $FEA3 Input routine for Fuller joystick. (Unused).
; "#7F Fuller Box (FxxxRLDU, active low)"
R $FE00 O:A Input value (as per enum input).
  $FEA3 BC = 0x007F;
  $FEA6 IN A,(C)
  $FEA8 BC = 0;
  $FEAB if (A & (1<<4)) A = ~A;
  $FEB0 carry = A & 1; A >>= 1;
  $FEB1 if (carry) C = input_UP;
  $FEB5 carry = A & 1; A >>= 1;
  $FEB6 if (carry) C = input_DOWN;
  $FEBA carry = A & 1; A >>= 1;
  $FEBB if (carry) B = input_LEFT;
  $FEBF carry = A & 1; A >>= 1;
  $FEC0 if (carry) B = input_RIGHT;
  $FEC4 if (A & (1<<3)) A = input_FIRE; // otherwise A is zero
  $FECA A += B + C;
  $FECC return;

; ------------------------------------------------------------------------------

c $FECD inputroutine_sinclair
D $FECD Input routine for Sinclair joystick.
; "#EFFE Sinclair1 (000LRDUF, active low, corresponds to keys '6' to '0')"
R $FECD O:A Input value (as per enum input).
  $FECD BC = port_KEYBOARD_09876;
  $FED0 IN A,(C)
  $FED2 A = ~A; // xxx67890
  $FED3 BC = 0;
  $FED6 RRCA // 0xxx6789
  $FED7 RRCA // 90xxx678
  $FED8 if (carry) C = input_UP;
  $FEDC RRCA // 890xxx67
  $FEDD if (carry) C = input_DOWN;
  $FEE1 RRCA // 7890xxx6
  $FEE2 if (carry) B = input_RIGHT;
  $FEE6 RRCA // 67890xxx
  $FEE7 if (carry) B = input_LEFT;
  $FEEB if ((A & (1<<3)) == 0) A = input_FIRE;
  $FEF1 A += B + C;
  $FEF3 return;

; ------------------------------------------------------------------------------

b $FEF4 mystery_FEF4
D $FEF4 A block starting with NOPs.

; ------------------------------------------------------------------------------

