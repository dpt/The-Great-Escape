;
; SkoolKit disassembly of The Great Escape by Denton Designs.
; https://github.com/dpt/The-Great-Escape
;
; Copyright 1986 Ocean Software Ltd. (The Great Escape)
; Copyright 2012-2019 David Thomas <dave@davespace.co.uk> (this disassembly)
;
;
; //////////////////////////////////////////////////////////////////////////////
; THE DISASSEMBLY
; //////////////////////////////////////////////////////////////////////////////
;
; * This is a disassembly of the game when it has been loaded and relocated,
;   but not yet invoked: every byte is in its pristine state.
;
; * Any terminology used herein such as 'super tiles' or 'vischars' is my own
;   and has been invented for the purposes of the disassembly. I have seen none
;   of the original source, nor know anything of how it was built.
;
;   When I contacted the author he informed me that the original source is
;   probably now lost forever. :-(
;
; * The md5sum of the original tape image this disassembly was taken from is
;   a6e5d50ab065accb017ecc957a954b53 and was sourced from
;   http://www.worldofspectrum.org/pub/sinclair/games/g/GreatEscapeThe.tzx.zip
;   but you may see slight differences towards the end of the file if you
;   attempt to recreate the disassembly yourself.
;
;
; //////////////////////////////////////////////////////////////////////////////
; ASSEMBLY PATTERNS
; //////////////////////////////////////////////////////////////////////////////
;
; Here are a selection of Z80 assembly language patterns which occur throughout
; the code.
;
; Multiply A by 2^N:
;   ADD A,A ; A += A (repeated N times)
; Note that this disposes of the topmost bit of A. Some routines discard flag
; bits this way.
;
; Increment HL by an 8-bit delta:
;   A = L
;   A += delta
;   L = A
;   JR NC,skip
;   H++
;   skip:
; Q: Does this only work for HL?
;
; if-else:
;   CP <value>
;   JR <cond>,elsepart;
;   <ifwork>
;   JR endifpart;
;   elsepart: <elsework>
;   endifpart:
;
; Jump if less than or equal:
;   CP $0F
;   JP Z,$C8F1
;   JP C,$C8F1
;
; Transfer between awkward registers:
;   PUSH reg
;   POP anotherreg
;
; Increment (HL) by -1 or +1:
;   BIT 7,A
;   JR Z,inc
;   DEC (HL)
;   DEC (HL)
;   inc: INC (HL)
;
;
; //////////////////////////////////////////////////////////////////////////////
; COMMENTARY
; //////////////////////////////////////////////////////////////////////////////
;
; "Exit via" - indicates that the code jumped to does not return. It itself
; will RET to the caller.
;
;
; //////////////////////////////////////////////////////////////////////////////
; ZX SPECTRUM BASIC DEFINITIONS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the
; directives.
;
; attribute_BLUE_OVER_BLACK                     = 1,
; attribute_RED_OVER_BLACK                      = 2,
; attribute_PURPLE_OVER_BLACK                   = 3,
; attribute_GREEN_OVER_BLACK                    = 4,
; attribute_CYAN_OVER_BLACK                     = 5,
; attribute_YELLOW_OVER_BLACK                   = 6,
; attribute_WHITE_OVER_BLACK                    = 7,
; attribute_BRIGHT_BLUE_OVER_BLACK              = 65,
; attribute_BRIGHT_RED_OVER_BLACK               = 66,
; attribute_BRIGHT_PURPLE_OVER_BLACK            = 67,
; attribute_BRIGHT_GREEN_OVER_BLACK             = 68,
; attribute_BRIGHT_CYAN_OVER_BLACK              = 69,
; attribute_BRIGHT_YELLOW_OVER_BLACK            = 70,
; attribute_BRIGHT_WHITE_OVER_BLACK             = 71,
;
; port_KEYBOARD_SHIFTZXCV                       = $FEFE,
; port_KEYBOARD_ASDFG                           = $FDFE,
; port_KEYBOARD_QWERT                           = $FBFE,
; port_KEYBOARD_12345                           = $F7FE,
; port_KEYBOARD_09876                           = $EFFE,
; port_KEYBOARD_POIUY                           = $DFFE,
; port_KEYBOARD_ENTERLKJH                       = $BFFE,
; port_KEYBOARD_SPACESYMSHFTMNB                 = $7FFE,
;
;
; //////////////////////////////////////////////////////////////////////////////
; ENUMERATIONS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the
; directives.
;
; character_0_COMMANDANT                        = 0,
; character_1_GUARD_1                           = 1,
; character_2_GUARD_2                           = 2,
; character_3_GUARD_3                           = 3,
; character_4_GUARD_4                           = 4,
; character_5_GUARD_5                           = 5,
; character_6_GUARD_6                           = 6,
; character_7_GUARD_7                           = 7,
; character_8_GUARD_8                           = 8,
; character_9_GUARD_9                           = 9,
; character_10_GUARD_10                         = 10,
; character_11_GUARD_11                         = 11,
; character_12_GUARD_12                         = 12,
; character_13_GUARD_13                         = 13,
; character_14_GUARD_14                         = 14,
; character_15_GUARD_15                         = 15,
; character_16_GUARD_DOG_1                      = 16,
; character_17_GUARD_DOG_2                      = 17,
; character_18_GUARD_DOG_3                      = 18,
; character_19_GUARD_DOG_4                      = 19,
; character_20_PRISONER_1                       = 20,
; character_21_PRISONER_2                       = 21,
; character_22_PRISONER_3                       = 22,
; character_23_PRISONER_4                       = 23,
; character_24_PRISONER_5                       = 24,
; character_25_PRISONER_6                       = 25,
; character_26_STOVE_1                          = 26,   ; movable item
; character_27_STOVE_2                          = 27,   ; movable item
; character_28_CRATE                            = 28,   ; movable item
; character_NONE                                = 255,
;
; room_0_OUTDOORS                               = 0,
; room_1_HUT1RIGHT                              = 1,
; room_2_HUT2LEFT                               = 2,
; room_3_HUT2RIGHT                              = 3,
; room_4_HUT3LEFT                               = 4,
; room_5_HUT3RIGHT                              = 5,
; room_6                                        = 6,    ; unused room index
; room_7_CORRIDOR                               = 7,
; room_8_CORRIDOR                               = 8,
; room_9_CRATE                                  = 9,
; room_10_LOCKPICK                              = 10,
; room_11_PAPERS                                = 11,
; room_12_CORRIDOR                              = 12,
; room_13_CORRIDOR                              = 13,
; room_14_TORCH                                 = 14,
; room_15_UNIFORM                               = 15,
; room_16_CORRIDOR                              = 16,
; room_17_CORRIDOR                              = 17,
; room_18_RADIO                                 = 18,
; room_19_FOOD                                  = 19,
; room_20_REDCROSS                              = 20,
; room_21_CORRIDOR                              = 21,
; room_22_REDKEY                                = 22,
; room_23_BREAKFAST                             = 23,
; room_24_SOLITARY                              = 24,
; room_25_BREAKFAST                             = 25,
; room_26                                       = 26,   ; unused room index
; room_27                                       = 27,   ; unused room index
; room_28_HUT1LEFT                              = 28,
; room_29_SECOND_TUNNEL_START                   = 29,   ; first of the tunnel rooms
; room_30                                       = 30,
; room_31                                       = 31,
; room_32                                       = 32,
; room_33                                       = 33,
; room_34                                       = 34,
; room_35                                       = 35,
; room_36                                       = 36,
; room_37                                       = 37,
; room_38                                       = 38,
; room_39                                       = 39,
; room_40                                       = 40,
; room_41                                       = 41,
; room_42                                       = 42,
; room_43                                       = 43,
; room_44                                       = 44,
; room_45                                       = 45,
; room_46                                       = 46,
; room_47                                       = 47,
; room_48                                       = 48,
; room_49                                       = 49,
; room_50_BLOCKED_TUNNEL                        = 50,
; room_51                                       = 51,
; room_52                                       = 52,
; room_NONE                                     = 255,
;
; item_WIRESNIPS                                = 0,
; item_SHOVEL                                   = 1,
; item_LOCKPICK                                 = 2,
; item_PAPERS                                   = 3,
; item_TORCH                                    = 4,
; item_BRIBE                                    = 5,
; item_UNIFORM                                  = 6,
; item_FOOD                                     = 7,
; item_POISON                                   = 8,
; item_RED_KEY                                  = 9,
; item_YELLOW_KEY                               = 10,
; item_GREEN_KEY                                = 11,
; item_RED_CROSS_PARCEL                         = 12,
; item_RADIO                                    = 13,
; item_PURSE                                    = 14,
; item_COMPASS                                  = 15,
; item__LIMIT                                   = 16,
; item_NONE                                     = 255,
;
; zoombox_tile_TL                               = 0,    ; top left
; zoombox_tile_HZ                               = 1,    ; horizontal
; zoombox_tile_TR                               = 2,    ; top right
; zoombox_tile_VT                               = 3,    ; vertical
; zoombox_tile_BR                               = 4,    ; bottom right
; zoombox_tile_BL                               = 5,    ; bottom left
;
; message_MISSED_ROLL_CALL                      = 0,
; message_TIME_TO_WAKE_UP                       = 1,
; message_BREAKFAST_TIME                        = 2,
; message_EXERCISE_TIME                         = 3,
; message_TIME_FOR_BED                          = 4,
; message_THE_DOOR_IS_LOCKED                    = 5,
; message_IT_IS_OPEN                            = 6,
; message_INCORRECT_KEY                         = 7,
; message_ROLL_CALL                             = 8,
; message_RED_CROSS_PARCEL                      = 9,
; message_PICKING_THE_LOCK                      = 10,
; message_CUTTING_THE_WIRE                      = 11,
; message_YOU_OPEN_THE_BOX                      = 12,
; message_YOU_ARE_IN_SOLITARY                   = 13,
; message_WAIT_FOR_RELEASE                      = 14,
; message_MORALE_IS_ZERO                        = 15,
; message_ITEM_DISCOVERED                       = 16,
; message_HE_TAKES_THE_BRIBE                    = 17,
; message_AND_ACTS_AS_DECOY                     = 18,
; message_ANOTHER_DAY_DAWNS                     = 19,
; message_QUEUE_END                             = 255,
;
; interiorobject_STRAIGHT_TUNNEL_SW_NE          = 0,
; interiorobject_SMALL_TUNNEL_ENTRANCE          = 1,
; interiorobject_ROOM_OUTLINE_22x12_A           = 2,
; interiorobject_STRAIGHT_TUNNEL_NW_SE          = 3,
; interiorobject_TUNNEL_T_JOIN_NW_SE            = 4,
; interiorobject_PRISONER_SAT_MID_TABLE         = 5,
; interiorobject_TUNNEL_T_JOIN_SW_NE            = 6,
; interiorobject_TUNNEL_CORNER_SW_SE            = 7,
; interiorobject_WIDE_WINDOW_FACING_SE          = 8,
; interiorobject_EMPTY_BED_FACING_SE            = 9,
; interiorobject_SHORT_WARDROBE_FACING_SW       = 10,
; interiorobject_CHEST_OF_DRAWERS_FACING_SW     = 11,
; interiorobject_TUNNEL_CORNER_NW_NE            = 12,
; interiorobject_EMPTY_BENCH                    = 13,
; interiorobject_TUNNEL_CORNER_NE_SE            = 14,
; interiorobject_DOOR_FRAME_SE                  = 15,
; interiorobject_DOOR_FRAME_SW                  = 16,
; interiorobject_TUNNEL_CORNER_NW_SW            = 17,
; interiorobject_TUNNEL_ENTRANCE                = 18,
; interiorobject_PRISONER_SAT_END_TABLE         = 19,
; interiorobject_COLLAPSED_TUNNEL_SW_NE         = 20,
; interiorobject_UNUSED_21                      = 21,   ; object unused by game, draws as interiorobject_ROOM_OUTLINE_22x12_A
; interiorobject_CHAIR_FACING_SE                = 22,
; interiorobject_OCCUPIED_BED                   = 23,
; interiorobject_ORNATE_WARDROBE_FACING_SW      = 24,
; interiorobject_CHAIR_FACING_SW                = 25,
; interiorobject_CUPBOARD_FACING_SE             = 26,
; interiorobject_ROOM_OUTLINE_18x10_A           = 27,
; interiorobject_UNUSED_28                      = 28,   ; object unused by game, draws as interiorobject_TABLE
; interiorobject_TABLE                          = 29,
; interiorobject_STOVE_PIPE                     = 30,
; interiorobject_PAPERS_ON_FLOOR                = 31,
; interiorobject_TALL_WARDROBE_FACING_SW        = 32,
; interiorobject_SMALL_SHELF_FACING_SE          = 33,
; interiorobject_SMALL_CRATE                    = 34,
; interiorobject_SMALL_WINDOW_WITH_BARS_FACING_SE = 35
; interiorobject_TINY_DOOR_FRAME_NE             = 36,   ; tunnel entrance
; interiorobject_NOTICEBOARD_FACING_SE          = 37,
; interiorobject_DOOR_FRAME_NW                  = 38,
; interiorobject_UNUSED_39                      = 39,   ; object unused by game, draws as interiorobject_END_DOOR_FRAME_NW_SE
; interiorobject_DOOR_FRAME_NE                  = 40,
; interiorobject_ROOM_OUTLINE_15x8              = 41,
; interiorobject_CUPBOARD_FACING_SW             = 42,
; interiorobject_MESS_BENCH                     = 43,
; interiorobject_MESS_TABLE                     = 44,
; interiorobject_MESS_BENCH_SHORT               = 45,
; interiorobject_ROOM_OUTLINE_18x10_B           = 46,
; interiorobject_ROOM_OUTLINE_22x12_B           = 47,
; interiorobject_TINY_TABLE                     = 48,
; interiorobject_TINY_DRAWERS_FACING_SE         = 49,
; interiorobject_TALL_DRAWERS_FACING_SW         = 50,
; interiorobject_DESK_FACING_SW                 = 51,
; interiorobject_SINK_FACING_SE                 = 52,
; interiorobject_KEY_RACK_FACING_SE             = 53,
; interiorobject__LIMIT                         = 54
;
; interiorobjecttile_MAX                        = 194,  ; number of tiles at $9768 interior_tiles
; interiorobjecttile_ESCAPE                     = 255,  ; escape character
;
; sound_CHARACTER_ENTERS_1                      = $2030,
; sound_CHARACTER_ENTERS_2                      = $2040,
; sound_BELL_RINGER                             = $2530,
; sound_PICK_UP_ITEM                            = $3030,
; sound_DROP_ITEM                               = $3040,
;
; morale_MIN                                    = 0,
; morale_MAX                                    = 112,
;
; direction_TOP_LEFT                            = 0
; direction_TOP_RIGHT                           = 1,
; direction_BOTTOM_RIGHT                        = 2,
; direction_BOTTOM_LEFT                         = 3,
;
;
; //////////////////////////////////////////////////////////////////////////////
; FLAGS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the
; directives.
;
; input_NONE                                    = 0,
; input_UP                                      = 1,
; input_DOWN                                    = 2,
; input_LEFT                                    = 3,
; input_RIGHT                                   = 6,
; input_FIRE                                    = 9,
; input_UP_FIRE                                 = input_UP    + input_FIRE,
; input_DOWN_FIRE                               = input_DOWN  + input_FIRE,
; input_LEFT_FIRE                               = input_LEFT  + input_FIRE,
; input_RIGHT_FIRE                              = input_RIGHT + input_FIRE,
;
; ; $8000, $8020, $8040, ...
; vischar_CHARACTER_MASK                        = $1F,          ; character index mask. this is used in a couple of places but it's not consistently applied. i've not spotted anything else sharing the this field.
;
; ; $8001, $8021, $8041, ...
; vischar_FLAGS_EMPTY_SLOT                      = $FF,
; vischar_FLAGS_MASK                            = $3F,
; vischar_FLAGS_PICKING_LOCK                    = 1 << 0,       ; hero only
; vischar_FLAGS_CUTTING_WIRE                    = 1 << 1,       ; hero only
;
; Four pursuit modes:
; vischar_PURSUIT_PURSUE                        = 1 << 0,       ; non-hero only. this flag is set when a visible friendly was nearby when a bribe was used. it's also set by hostiles_pursue
; vischar_PURSUIT_HASSLE                        = 2 << 0,       ; this flag is set in guards_follow_suspicious_character when a hostile is following the hero
; vischar_PURSUIT_DOG_FOOD                      = 3 << 0,       ; set when food is in the vicinity of a dog
; vischar_PURSUIT_SAW_BRIBE                     = 4 << 0,       ; this flag is set when a visible hostile was nearby when a bribe was used. perhaps it distracts the guards?
;
; vischar_FLAGS_TARGET_IS_DOOR                  = 1 << 6,       ; affects scaling
; vischar_FLAGS_NO_COLLIDE                      = 1 << 7,       ; don't do collision() for this vischar
;
; ; $8002, $8022, $8042, ...
; route_REVERSED                                = 1 << 7,       ; set if the route is to be followed in reverse order
;
; ; $8007, $8027, $8047, ...
; vischar_BYTE7_MASK_LO                         = $0F,
; vischar_BYTE7_COUNTER_MASK                    = $F0,
; vischar_BYTE7_Y_DOMINANT                      = 1 << 5,       ; set when hero hits an obstacle
; vischar_BYTE7_DONT_MOVE_MAP                   = 1 << 6,       ; set while touch() entered
; vischar_TOUCH_ENTERED                         = 1 << 7,       ; stops locate_vischar_or_itemstruct considering a vischar
;
; ; $800C, $802C, $804C, ...
; vischar_ANIMINDEX_BIT7                        = 1 << 7,       ; is this a kick flag?
;
; ; $800E, $802E, $804E, ...
; vischar_DIRECTION_MASK                        = $03,
; vischar_DIRECTION_CRAWL                       = 1 << 2,
;
; itemstruct_ITEM_MASK                          = $0F,
; itemstruct_ITEM_FLAG_POISONED                 = 1 << 5,
; itemstruct_ITEM_FLAG_HELD                     = 1 << 7,       ; set when the item has been encountered
; itemstruct_ROOM_MASK                          = $3F,
; itemstruct_ROOM_FLAG_NEARBY_6                 = 1 << 6,       ; possibly vestigal, needs more investigation
; itemstruct_ROOM_FLAG_NEARBY_7                 = 1 << 7,       ; set when the item is nearby
;
; door_REVERSE                                  = 1 << 7,       ; used to reverse door transitions
; door_LOCKED                                   = 1 << 7,       ; used to lock doors in locked_doors[]
; door_NONE                                     = $FF
;
; characterstruct_FLAG_ON_SCREEN                = 1 << 6,       ; this disables the character
; characterstruct_CHARACTER_MASK                = $1F,
; characterstruct_BYTE5_MASK                    = $7F,
; characterstruct_BYTE6_MASK_LO                 = $07,
;
; door_FLAGS_MASK_DIRECTION                     = $03,          ; up/down or direction field?
;
; searchlight_STATE_CAUGHT                      = $1F,
; searchlight_STATE_SEARCHING                   = $FF,          ; hunting for hero
;
; bell_RING_PERPETUAL                           = $00,
; bell_RING_40_TIMES                            = $28,
; bell_STOP                                     = $FF,
;
; escapeitem_COMPASS                            = 1,
; escapeitem_PAPERS                             = 2,
; escapeitem_PURSE                              = 4,
; escapeitem_UNIFORM                            = 8,
;
; statictiles_COUNT_MASK                        = $7F,
; statictiles_VERTICAL                          = 1 << 7,       ; otherwise horizontal
;
; map_MAIN_GATE_X                               = $696D,        ; coords: $69..$6D
; map_MAIN_GATE_Y                               = $494B,
; map_ROLL_CALL_X                               = $727C,
; map_ROLL_CALL_Y                               = $6A72,
;
; inputdevice_KEYBOARD                          = 0,
;
;
; //////////////////////////////////////////////////////////////////////////////
; COMMON TYPES
; //////////////////////////////////////////////////////////////////////////////
;
; 'bounds_t' is a bounding box:
; +---------------------------------+
; | Type | Bytes | Name | Meaning   |
; |---------------------------------|
; | Byte |     1 |   x0 | Minimum x |
; | Byte |     1 |   x1 | Maximum x |
; | Byte |     1 |   y0 | Minimum y |
; | Byte |     1 |   y1 | Maximum y |
; +---------------------------------+
;
;
; //////////////////////////////////////////////////////////////////////////////
; ROOMS
; //////////////////////////////////////////////////////////////////////////////
;
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
;       +----+------+      | 10 |  9 |
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
;
; //////////////////////////////////////////////////////////////////////////////
; GAME STATE
; //////////////////////////////////////////////////////////////////////////////
;
; There are eight visible character (vischar) structures living at $8000
; onwards. The game therefore supports up to eight characters on-screen at
; once. The stove and crate items count as characters too.
;
; These structures occupy the same addresses as some of the static tiles. This
; is fine as the static tiles are never referenced once they're plotted to the
; screen at startup.
;
; The structures are 32 bytes long. Each structure is laid out as follows:
;
; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
; | Type        | Bytes | Name              | Meaning                                                                       |
; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
; | Character   |     1 | character         | Character index, or $FF if none                                               |
; | Byte        |     1 | flags             | Flags                                                                         |
; | Route       |     2 | route             | Route                                                                         |
; | TinyPos     |     3 | target            | Target position                                                               |
; | Byte        |     1 | counter_and_flags | Top nibble = flags, bottom nibble = counter used by character_behaviour only  |
; | Pointer     |     2 | animbase          | Pointer to animation base (never changes)                                     |
; | Pointer     |     2 | anim              | Pointer to value in animations                                                |
; | Byte        |     1 | animindex         | Bit 7 is up/down flag, other bits are an animation counter                    |
; | Byte        |     1 | input             | Input .. previous direction?                                                  |
; | Byte        |     1 | direction         | Direction and walk/crawl flag                                                 |
; | MovableItem |     9 | mi                | Movable item structure (pos (where we are), current sprite, sprite index)     |
; | BigXY       |     4 | iso_pos           | Screen x, y coord                                                             |
; | Room        |     1 | room              | Current room index                                                            |
; | Byte        |     1 | unused            | -                                                                             |
; | Byte        |     1 | width_bytes       | Copy of sprite width in bytes + 1                                             |
; | Byte        |     1 | height            | Copy of sprite height in rows                                                 |
; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
;
; The first entry in the array is the hero.
;
; Further notes:
;
; b $8001 flags: bit 6 gets toggled in set_hero_route /  bit 0: picking lock /  bit 1: cutting wire  ($FF when reset)
; w $8002 route (set in set_hero_route, process_player_input)
; b*3 $8004 (<- process_player_input) a coordinate? (i see it getting scaled in #R$CA11)
; b $8007 bits 5/6/7: flags  (suspect bit 4 is a flag too) ($00 when reset)
; w $8008 (read by animate)
; w $800A (read/written by animate)
; b $800C (read/written by animate)
; b $800D tunnel related (<- process_player_input, cutting_wire, process_player_input) assigned from cutting_wire_new_inputs table.  causes movement when set. but not when in solitary.
;            $81 -> move toward top left,
;            $82 -> move toward bottom right,
;            $83 -> move toward bottom left,
;            $84 -> TL (again)
;            $85 ->
; b $800E tunnel related, direction (bottom 2 bits index cutting_wire_new_inputs) bit 2 is walk/crawl flag
; set to - $00 -> character faces top left
;          $01 -> character faces top right
;          $02 -> character faces bottom right
;          $03 -> character faces bottom left
;          $04 -> character faces top left     (crawling)
;          $05 -> character faces top right    (crawling)
;          $06 -> character faces bottom right (crawling)
;          $07 -> character faces bottom left  (crawling)
; w $800F position on X axis (along the line of - bottom right to top left of screen) (set by process_player_input)
; w $8011 position on Y axis (along the line of - bottom left to top right of screen) (set by process_player_input)  i think this might be relative to the current size of the map. each step seems to be two pixels.
; w $8013 character's height // set to 24 in process_player_input, cutting_wire,  set to 12 in action_wiresnips,  reset in calc_vischar_iso_pos_from_vischar,  read by animate ($B68C) (via IY), locate_vischar_or_itemstruct ($B8DE), setup_vischar_plotting ($E433), in_permitted_area ($9F4F)  written by touch ($AFD5)  often written as a byte, but suspect it's a word-sized value
; w $8015 pointer to current character sprite set (gets pointed to the 'tl_4' sprite)
; b $8017 touch sets this to touch_stashed_A
; w $8018 points to something (gets $06C8 subtracted from it) (<- in_permitted_area)
; w $801A points to something (gets $0448 subtracted from it) (<- in_permitted_area)
; b $801C room index: cleared to zero by action_papers, set to room_24_SOLITARY by solitary, copied to room_index by transition
;
; Other things:
;
; b $8100 mask buffer ($A0 bytes - 4 * 8 * 5)
; w $81A0 mask buffer pointer
; w $81A2 screen buffer pointer
;
;
; //////////////////////////////////////////////////////////////////////////////
; ROUTES
; //////////////////////////////////////////////////////////////////////////////
;
; Each vischar has a "route" structure that guides its pathfinding. The route
; is composed of an index and a step (the first and second bytes respectively).
; The index selects a route from the table at #R$7738. The step is the index
; into that route. If the top bit of the route index is set then the route is
; followed in reverse order.
;
;
; //////////////////////////////////////////////////////////////////////////////
; HUTS
; //////////////////////////////////////////////////////////////////////////////
;
; Hut 1 is the hut at the 'top' of the map.
; Hut 2 is the middle hut.
; Hut 3 is the bottom hut.
;
; These identifiers for the huts are my own convention - as with all things in
; this disassembly it was determined from scratch.
;
;
; //////////////////////////////////////////////////////////////////////////////
; HUT INTERIORS
; //////////////////////////////////////////////////////////////////////////////
;
; Hut 1 is composed of room 28 on the left and room 1 on the right.
; Hut 2 is composed of room  2 on the left and room 3 on the right.
; Hut 3 is composed of room  4 on the left and room 5 on the right.
;
;
; //////////////////////////////////////////////////////////////////////////////
; SLEEPING CHARACTERS
; //////////////////////////////////////////////////////////////////////////////
;
; Three of the four beds in hut 1 are occupied by sleeping figures who -
; creepily - never rise from their slumber. Perhaps more concurrent prisoner
; characters were originally planned - there's capacity in the room layout for
; eleven - but machine limits prevented more than six being used.
;
; In hut 2, our hero sleeps in the left hand room and three active characters
; (20..22) slumber in the right hand room.
;
; Hut 3 has no character sleeping in its left hand room and three active
; characters (23..25) sleep in the right hand room.
;
;       |-- Left room --|----------------- Right room -----------------|
;       |---------------|-- Left bed --|-- Middle bed -|-- Right bed --|
; Hut 1 | Always asleep | Always empty | Always asleep | Always asleep |
; Hut 2 | Hero          | 22           | 21            | 20            |
; Hut 3 | Always empty  | 25           | 24            | 23            |
;

; Loading screen.
screen:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; Pixels.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$CC,$67,$18,$D9,$9C,$1B,$31,$B6,$E6,$CE,$D8 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0D,$B5,$B6,$36,$DB,$60 ;
  DEFB $FF,$00,$00,$04,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$1C,$00,$00,$00,$FF,$D0,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$20,$00,$FF,$00,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$0F,$FF,$00,$00,$00,$10,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$E2,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$08,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$8F,$63,$18,$71,$8C,$1E,$3C,$E6,$7E,$C6,$70 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$B1,$F3,$3E,$DB,$30 ;
  DEFB $00,$FF,$00,$04,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$00,$00,$00,$10,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$40,$00,$00,$FF,$07,$54,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$05,$F0,$FF,$00,$00,$08,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$F3,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$08,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0D,$B1,$81,$B0,$DB,$18 ;
  DEFB $00,$00,$FF,$0D,$A0,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$09,$F0,$FF,$00,$00,$08,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$A0,$00,$FF,$00,$04,$06,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$FF,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$8F,$63,$7E,$71,$8C,$1E,$3C,$E6,$7C,$C6,$70 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$30,$F7,$1E,$DB,$70 ;
  DEFB $00,$00,$00,$FF,$D0,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$04,$A0,$00,$FF,$00,$1A,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$40,$00,$00,$FF,$0F,$58,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$0F,$FF,$78,$40,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$CC,$73,$18,$D9,$CC,$1B,$31,$B6,$E6,$E6,$D8 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$0F,$FF,$00,$00,$00,$04,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$04,$18,$00,$00,$FF,$1F,$40,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$68,$FF,$00,$00,$30,$08,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$FF,$A0,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$1F,$FF,$79,$C0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$6C,$7B,$19,$8D,$EC,$19,$B1,$86,$C0,$F6,$C0 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$16,$F0,$FF,$00,$00,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$04,$06,$00,$00,$00,$FF,$E0,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$48,$00,$FF,$00,$08,$10,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3C,$00,$07,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$05,$FF,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$1F,$7E,$7F,$E3,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$6F,$6B,$19,$8D,$AC,$19,$BC,$E6,$CE,$D6,$70 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$80 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$20,$50,$00,$FF,$00,$04,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$17,$FF,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$10,$00,$00,$FE,$0D,$10,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00,$1C,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$02,$B0,$FF,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$3F,$98,$7D,$E7,$B8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$6C,$6F,$19,$8D,$BC,$19,$B0,$36,$C6,$DE,$18 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0B,$2C,$E3,$9C,$F3,$38 ;
  DEFB $00,$00,$00,$18,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$40,$20,$00,$00,$FF,$0D,$50,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$60,$FF,$00,$00,$02,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$10,$00,$00,$00,$FF,$A0,$00,$00,$00,$20,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$C4,$B8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$10,$00,$FF ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$3F,$C0,$79,$F7,$9C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$3F,$C0,$78,$F7,$9C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$7F,$F8,$F8,$E1,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $40,$00,$00,$00,$00,$00,$0F,$3C,$7F,$08,$20,$18,$01,$00,$60,$03,$C3,$38,$0C,$10,$0C,$01,$03,$02,$00,$C0,$00,$00,$00,$00,$00,$08 ;
  DEFB $00,$18,$40,$00,$00,$00,$1E,$0F,$CF,$9E,$03,$C8,$78,$F1,$E0,$07,$C8,$F8,$7C,$FD,$E0,$78,$F1,$E3,$DE,$40,$00,$00,$00,$07,$00,$04 ;
  DEFB $00,$00,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$E0,$00,$00,$CF,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$07,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$B8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$30,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3F,$C0,$78,$F7,$8E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$E0,$7C,$E0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $20,$00,$00,$00,$00,$00,$1F,$3C,$7F,$1C,$60,$78,$03,$80,$60,$07,$C3,$86,$1E,$30,$3E,$03,$83,$C7,$03,$C0,$00,$00,$00,$00,$00,$12 ;
  DEFB $00,$04,$40,$00,$00,$00,$1F,$07,$CF,$9E,$03,$D0,$78,$F1,$E0,$07,$C4,$F8,$30,$7D,$E0,$78,$F1,$E3,$DE,$80,$00,$00,$00,$38,$00,$00 ;
  DEFB $00,$00,$21,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$00,$00,$3D,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$20,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$38,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$C0,$78,$F7,$8C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$80,$30,$C0,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $18,$00,$00,$00,$00,$00,$1E,$7C,$3E,$3E,$F1,$FC,$0F,$E0,$E0,$07,$C7,$8B,$3F,$F0,$FE,$0F,$E3,$EF,$8F,$E0,$00,$00,$00,$00,$00,$1B ;
  DEFB $00,$02,$80,$00,$00,$00,$0F,$47,$8F,$1E,$01,$E0,$78,$F1,$E0,$03,$E3,$F0,$00,$3D,$E0,$78,$F1,$E3,$CF,$00,$00,$00,$01,$C0,$00,$00 ;
  DEFB $00,$00,$40,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$01,$F4,$80,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$19,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$81,$C0,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$C0,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$80,$78,$F7,$90,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $04,$00,$00,$00,$00,$00,$3E,$7E,$1C,$7F,$F3,$DC,$3B,$F8,$E0,$0F,$87,$EB,$6F,$E1,$EF,$3B,$F9,$F7,$DE,$E0,$00,$00,$00,$00,$00,$0F ;
  DEFB $00,$01,$E0,$00,$00,$00,$0F,$47,$9F,$1E,$01,$E0,$78,$F1,$E0,$03,$E1,$E0,$07,$39,$E0,$78,$F3,$F3,$CF,$00,$00,$80,$0E,$00,$00,$00 ;
  DEFB $00,$00,$40,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$0E,$10,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$8E,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$21,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0E,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$FF,$00,$78,$F7,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$FC,$82,$00,$00,$00,$00,$00,$00,$00,$3E,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $02,$00,$00,$00,$00,$00,$3E,$7F,$7E,$1E,$FB,$CE,$79,$F1,$FC,$0F,$87,$F6,$EF,$C1,$EF,$78,$F1,$E3,$DE,$70,$00,$00,$00,$00,$00,$7D ;
  DEFB $00,$06,$F0,$00,$00,$00,$07,$3E,$1E,$1E,$10,$F2,$78,$F1,$E4,$01,$F0,$02,$3F,$F1,$F3,$78,$F7,$FB,$87,$90,$01,$00,$70,$00,$00,$00 ;
  DEFB $00,$00,$00,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$70,$20,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$02,$82,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8B,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$40,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FE,$01,$78,$F3,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$03,$C3,$04,$00,$00,$00,$00,$00,$20,$00,$F1,$70,$01,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $01,$80,$00,$00,$00,$00,$3E,$3F,$BF,$1E,$F3,$CE,$78,$F7,$FC,$0F,$83,$F8,$E3,$31,$E6,$78,$F1,$E3,$DE,$70,$00,$00,$00,$00,$03,$84 ;
  DEFB $00,$08,$6C,$C0,$00,$00,$03,$80,$3C,$3F,$E0,$FC,$3D,$FB,$F8,$00,$FC,$1C,$FF,$C1,$FE,$3D,$F9,$FF,$87,$E0,$01,$03,$80,$00,$00,$00 ;
  DEFB $00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$03,$80,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$01,$D2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$6F,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$8E,$78,$F3,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$07,$8E,$9C,$00,$00,$00,$00,$00,$20,$01,$E0,$FB,$02,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$40,$00,$00,$00,$00,$3E,$3F,$9F,$1E,$63,$C7,$78,$F1,$E0,$0F,$83,$F8,$F0,$F9,$E0,$78,$F1,$E3,$DE,$38,$00,$00,$00,$00,$1C,$02 ;
  DEFB $00,$00,$BB,$00,$00,$00,$01,$C0,$78,$0F,$80,$78,$3E,$F1,$F0,$00,$7F,$F0,$1F,$80,$F8,$3E,$F1,$FE,$03,$C0,$02,$1C,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$0E,$E4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$FF,$FC,$78,$E1,$E4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $80,$00,$00,$00,$00,$00,$0F,$1C,$3E,$00,$00,$00,$00,$00,$20,$03,$E1,$7C,$00,$10,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$04 ;
  DEFB $00,$20,$80,$00,$00,$00,$3E,$1F,$DF,$9E,$43,$C6,$78,$F1,$E0,$0F,$89,$FC,$7F,$F9,$E0,$78,$F1,$E3,$DE,$30,$00,$00,$00,$00,$E0,$02 ;
  DEFB $00,$00,$14,$00,$00,$00,$00,$79,$E0,$02,$00,$30,$18,$40,$40,$00,$1F,$80,$06,$00,$60,$18,$41,$E8,$01,$81,$0B,$E0,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$74,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F4,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$02,$08,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$01,$04,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$1A,$F6,$00,$00,$00,$00,$00,$07,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$04,$B7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$0F,$60,$00,$00,$00,$00,$41,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$80,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $08,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2F,$08,$00,$00,$3C,$00,$00,$00,$00,$20,$F1,$EF,$1E,$F1,$EF,$1F,$9E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$20,$7F,$C7,$FC,$7F,$C7,$FF,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$01,$08,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$78,$00,$00,$00,$00,$00,$38,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$02,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$01,$88,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$3D,$20,$00,$00,$00,$00,$02,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$80,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $10,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$46,$B0,$00,$00,$42,$18,$3C,$3C,$3C,$21,$E0,$FE,$0F,$E0,$FE,$0F,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$20,$1F,$01,$F0,$1F,$01,$F7,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$40,$80,$00,$00,$00,$00,$00,$00,$01,$2D,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$00,$00,$00,$01,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$03,$D0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$10,$01,$C0,$00,$00,$44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$01,$C4,$10,$00,$00,$00,$00,$02,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $01,$01,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0 ;
  DEFB $10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$43,$C0,$00,$00,$99,$28,$42,$42,$40,$21,$C0,$7C,$01,$FF,$FC,$07,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$20,$80,$00,$00,$00,$00,$00,$00,$00,$BE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$44,$00,$00,$00,$00,$0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$48,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$20,$0E,$00,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$0E,$08,$00,$00,$00,$00,$00,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $41,$0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$84,$00,$00,$00,$00,$00,$00,$00,$00,$30,$00,$00,$00,$00,$00,$00,$00,$30 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$A0,$00,$00,$A1,$08,$42,$3C,$7C,$21,$C0,$7C,$01,$FF,$FC,$07,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$30,$00,$00,$00,$00,$00,$00,$00,$30 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$18,$80,$00,$00,$00,$00,$00,$00,$00,$F4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$42,$00,$00,$04,$00,$70,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$72,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$40,$70,$00,$00,$00,$1E,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$70,$10,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $25,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$44,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$18,$00,$00,$A1,$08,$3E,$42,$42,$21,$C0,$7C,$01,$FF,$FC,$07,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$05,$80,$00,$00,$00,$00,$00,$00,$03,$D3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$81,$80,$00,$04,$03,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$84,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$83,$80,$00,$00,$00,$2D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$03,$80,$20,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $17,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$00,$00,$00,$00,$00,$00,$00,$00,$20,$1F,$01,$F0,$1F,$01,$F7,$70,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$04,$00,$00,$99,$08,$02,$42,$42,$21,$E0,$FE,$0F,$E0,$1E,$0F,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$03,$51,$00,$00,$00,$00,$00,$00,$1C,$40,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$80,$40,$00,$08,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$1C,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$32,$DC,$00,$00,$00,$00,$47,$CC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $1E,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$20,$7F,$C7,$FC,$7F,$C7,$FF,$FC,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$02,$00,$00,$42,$3E,$3C,$3C,$3C,$20,$F1,$EF,$1E,$F1,$EF,$1F,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$25,$E1,$00,$00,$00,$00,$00,$00,$E0,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$08,$28,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$0B,$E0,$00,$00,$00,$00,$4B,$B0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $FA,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$00,$00,$00,$00,$00,$00,$00,$20,$FF,$EF,$FE,$FF,$EF,$FF,$FC,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80,$00,$3C,$00,$00,$00,$00,$20,$FF,$EF,$FE,$FF,$EF,$FF,$0E,$10 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07 ; Attributes.
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07 ;
  DEFB $06,$06,$06,$04,$04,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07 ;
  DEFB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$06,$06,$06,$04,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07 ;
  DEFB $06,$06,$06,$06,$04,$06,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04,$06,$06,$04,$04,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$04,$06,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$06,$06,$04,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$06,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04,$04 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04,$04,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$42,$42,$42,$42,$42,$42,$42,$42,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$42,$42,$42,$42,$42,$42,$42,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05 ;
  DEFB $06,$06,$06,$06,$06,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$05,$05,$05,$05,$06,$05 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$02,$42,$05,$05,$05,$05,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$06,$05,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$06,$06,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $06,$06,$06,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;
  DEFB $05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ;
  DEFB $05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$41,$41,$41,$41,$41,$01,$01,$01,$01,$01,$01,$01,$01,$01 ;
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ;

; Super tiles.
;
; The game's exterior map (at map_tiles) is constructed of references to these "super tiles" which are in turn a 4x4 array of tile indices.
super_tiles:
  DEFB $94,$93,$92,$94    ; super_tile $00
  DEFB $92,$92,$94,$93    ;
  DEFB $91,$94,$07,$08    ;
  DEFB $03,$04,$05,$06    ;
  DEFB $91,$92,$07,$08    ; super_tile $01
  DEFB $07,$08,$09,$0A    ;
  DEFB $09,$0A,$0B,$17    ;
  DEFB $0C,$17,$18,$1F    ;
  DEFB $94,$93,$92,$94    ; super_tile $02
  DEFB $92,$91,$94,$93    ;
  DEFB $91,$94,$07,$08    ;
  DEFB $07,$08,$09,$0A    ;
  DEFB $91,$92,$07,$08    ; super_tile $03
  DEFB $07,$08,$09,$0A    ;
  DEFB $09,$0A,$0B,$17    ;
  DEFB $0B,$17,$18,$1F    ;
  DEFB $09,$0A,$0B,$17    ; super_tile $04
  DEFB $0B,$17,$18,$1F    ;
  DEFB $18,$1F,$19,$1A    ;
  DEFB $19,$1A,$1E,$17    ;
  DEFB $18,$1F,$19,$1A    ; super_tile $05
  DEFB $19,$1A,$1E,$17    ;
  DEFB $1E,$17,$1D,$1C    ;
  DEFB $1D,$1C,$19,$1B    ;
  DEFB $93,$92,$91,$92    ; super_tile $06
  DEFB $91,$93,$91,$94    ;
  DEFB $91,$91,$93,$94    ;
  DEFB $26,$27,$28,$29    ;
  DEFB $94,$93,$92,$94    ; super_tile $07
  DEFB $92,$91,$94,$93    ;
  DEFB $91,$94,$93,$94    ;
  DEFB $2A,$92,$94,$91    ;
  DEFB $6D,$2B,$91,$93    ; super_tile $08
  DEFB $19,$2C,$2D,$93    ;
  DEFB $1E,$17,$18,$2E    ;
  DEFB $1D,$1C,$19,$2F    ;
  DEFB $1E,$17,$1D,$1C    ; super_tile $09
  DEFB $1D,$1C,$19,$1B    ;
  DEFB $19,$1B,$35,$36    ;
  DEFB $35,$36,$34,$00    ;
  DEFB $1E,$17,$1D,$1C    ; super_tile $0A
  DEFB $1D,$1C,$19,$1B    ;
  DEFB $19,$1B,$35,$37    ;
  DEFB $35,$36,$34,$38    ;
  DEFB $1E,$17,$1D,$1C    ; super_tile $0B
  DEFB $1D,$1C,$19,$1B    ;
  DEFB $19,$1B,$35,$37    ;
  DEFB $32,$33,$34,$38    ;
  DEFB $0D,$0E,$19,$1A    ; super_tile $0C
  DEFB $00,$0F,$10,$17    ;
  DEFB $00,$00,$11,$12    ;
  DEFB $8B,$00,$13,$14    ;
  DEFB $02,$00,$00,$00    ; super_tile $0D
  DEFB $85,$00,$86,$87    ;
  DEFB $01,$00,$88,$89    ;
  DEFB $01,$00,$00,$8A    ;
  DEFB $01,$00,$00,$81    ; super_tile $0E
  DEFB $85,$00,$00,$4E    ;
  DEFB $6C,$00,$00,$50    ;
  DEFB $6B,$69,$66,$4E    ;
  DEFB $82,$00,$00,$15    ; super_tile $0F
  DEFB $83,$84,$00,$55    ;
  DEFB $00,$68,$00,$55    ;
  DEFB $00,$4E,$00,$62    ;
  DEFB $93,$94,$65,$6A    ; super_tile $10
  DEFB $94,$91,$8C,$8D    ;
  DEFB $91,$92,$94,$94    ;
  DEFB $92,$94,$93,$91    ;
  DEFB $00,$4E,$00,$61    ; super_tile $11
  DEFB $8E,$67,$66,$60    ;
  DEFB $8F,$90,$65,$5F    ;
  DEFB $93,$92,$91,$5E    ;
  DEFB $16,$73,$78,$38    ; super_tile $12
  DEFB $01,$73,$00,$38    ;
  DEFB $77,$73,$00,$63    ;
  DEFB $76,$58,$00,$64    ;
  DEFB $75,$59,$00,$49    ; super_tile $13
  DEFB $74,$5A,$4A,$4B    ;
  DEFB $5C,$5B,$91,$93    ;
  DEFB $5D,$93,$92,$94    ;
  DEFB $09,$21,$22,$24    ; super_tile $14
  DEFB $0B,$20,$23,$25    ;
  DEFB $18,$1F,$19,$1A    ;
  DEFB $19,$1A,$1E,$17    ;
  DEFB $00,$00,$00,$49    ; super_tile $15
  DEFB $00,$4C,$4A,$4B    ;
  DEFB $4A,$4B,$91,$93    ;
  DEFB $94,$93,$92,$94    ;
  DEFB $39,$3A,$3F,$3E    ; super_tile $16
  DEFB $40,$41,$42,$43    ;
  DEFB $44,$45,$46,$47    ;
  DEFB $48,$47,$4A,$4B    ;
  DEFB $19,$1B,$35,$36    ; super_tile $17
  DEFB $35,$36,$34,$00    ;
  DEFB $34,$7D,$00,$00    ;
  DEFB $00,$3B,$3C,$3D    ;
  DEFB $4A,$4B,$93,$91    ; super_tile $18
  DEFB $93,$94,$91,$92    ;
  DEFB $94,$92,$93,$94    ;
  DEFB $93,$91,$92,$91    ;
  DEFB $4A,$5B,$93,$94    ; super_tile $19
  DEFB $93,$94,$91,$92    ;
  DEFB $94,$92,$93,$94    ;
  DEFB $93,$91,$92,$91    ;
  DEFB $91,$93,$94,$92    ; super_tile $1A
  DEFB $92,$94,$91,$94    ;
  DEFB $94,$93,$91,$92    ;
  DEFB $30,$92,$94,$93    ;
  DEFB $31,$93,$92,$91    ; super_tile $1B
  DEFB $91,$92,$91,$94    ;
  DEFB $93,$94,$93,$91    ;
  DEFB $94,$93,$94,$92    ;
  DEFB $19,$1B,$35,$6E    ; super_tile $1C
  DEFB $35,$33,$34,$55    ;
  DEFB $34,$73,$00,$56    ;
  DEFB $00,$73,$00,$55    ;
  DEFB $79,$73,$00,$55    ; super_tile $1D
  DEFB $00,$58,$00,$7E    ;
  DEFB $7A,$59,$79,$56    ;
  DEFB $78,$5A,$4A,$57    ;
  DEFB $34,$00,$00,$7C    ; super_tile $1E
  DEFB $00,$3B,$72,$00    ;
  DEFB $39,$4F,$4E,$00    ;
  DEFB $4E,$00,$80,$7B    ;
  DEFB $50,$00,$7F,$4C    ; super_tile $1F
  DEFB $51,$00,$4D,$4B    ;
  DEFB $52,$53,$54,$91    ;
  DEFB $6F,$70,$71,$94    ;
  DEFB $34,$00,$00,$38    ; super_tile $20
  DEFB $7B,$78,$00,$38    ;
  DEFB $7C,$79,$00,$38    ;
  DEFB $7A,$00,$00,$38    ;
  DEFB $19,$1B,$35,$36    ; super_tile $21
  DEFB $35,$36,$34,$7B    ;
  DEFB $34,$00,$00,$7C    ;
  DEFB $00,$3B,$3C,$3D    ;
  DEFB $34,$00,$00,$38    ; super_tile $22
  DEFB $77,$00,$00,$38    ;
  DEFB $79,$00,$00,$63    ;
  DEFB $7A,$00,$00,$64    ;
  DEFB $94,$93,$92,$94    ; super_tile $23
  DEFB $92,$91,$94,$93    ;
  DEFB $91,$94,$93,$94    ;
  DEFB $93,$92,$94,$91    ;
  DEFB $93,$92,$91,$92    ; super_tile $24
  DEFB $91,$93,$91,$93    ;
  DEFB $91,$91,$93,$94    ;
  DEFB $94,$92,$94,$93    ;
  DEFB $93,$94,$93,$91    ; super_tile $25
  DEFB $94,$91,$94,$93    ;
  DEFB $91,$92,$94,$94    ;
  DEFB $92,$94,$93,$91    ;
  DEFB $AF,$B9,$C4,$B0    ; super_tile $26
  DEFB $C5,$B9,$BA,$B0    ;
  DEFB $96,$BB,$B6,$C6    ;
  DEFB $94,$93,$BC,$98    ;
  DEFB $00,$F0,$F1,$00    ; super_tile $27
  DEFB $B3,$F2,$F3,$00    ;
  DEFB $AF,$B5,$95,$B4    ;
  DEFB $AF,$B7,$B8,$B0    ;
  DEFB $00,$00,$00,$00    ; super_tile $28
  DEFB $B3,$F4,$00,$00    ;
  DEFB $AF,$B5,$95,$B4    ;
  DEFB $AF,$B7,$B8,$B0    ;
  DEFB $AE,$C0,$C1,$9C    ; super_tile $29
  DEFB $F8,$C2,$91,$92    ;
  DEFB $94,$92,$93,$94    ;
  DEFB $93,$91,$92,$91    ;
  DEFB $B2,$9B,$BE,$B0    ; super_tile $2A
  DEFB $AF,$BD,$BF,$B0    ;
  DEFB $AF,$B9,$BA,$F9    ;
  DEFB $AF,$B9,$BA,$C3    ;
  DEFB $E3,$E2,$E5,$00    ; super_tile $2B
  DEFB $E5,$00,$00,$00    ;
  DEFB $00,$00,$00,$00    ;
  DEFB $00,$00,$F5,$B1    ;
  DEFB $F6,$C7,$99,$9C    ; super_tile $2C
  DEFB $99,$C8,$91,$93    ;
  DEFB $91,$91,$93,$94    ;
  DEFB $94,$92,$94,$93    ;
  DEFB $1E,$45,$45,$44    ; super_tile $2D
  DEFB $1E,$45,$48,$49    ;
  DEFB $1E,$4A,$4B,$4C    ;
  DEFB $4D,$7B,$65,$0A    ;
  DEFB $52,$51,$54,$6D    ; super_tile $2E
  DEFB $54,$6D,$6D,$6D    ;
  DEFB $18,$64,$3A,$43    ;
  DEFB $47,$46,$45,$44    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $2F
  DEFB $6D,$6D,$65,$0A    ;
  DEFB $65,$36,$08,$0B    ;
  DEFB $08,$37,$00,$01    ;
  DEFB $13,$6D,$6D,$53    ; super_tile $30
  DEFB $0D,$53,$52,$51    ;
  DEFB $6A,$51,$54,$6D    ;
  DEFB $6C,$6D,$4E,$4F    ;
  DEFB $0F,$6D,$6D,$50    ; super_tile $31
  DEFB $0D,$6D,$6D,$6D    ;
  DEFB $14,$19,$6D,$6D    ;
  DEFB $15,$16,$6D,$6D    ;
  DEFB $0F,$6D,$6D,$6D    ; super_tile $32
  DEFB $0D,$6D,$65,$0A    ;
  DEFB $09,$0A,$08,$0B    ;
  DEFB $08,$0B,$02,$00    ;
  DEFB $1E,$45,$48,$49    ; super_tile $33
  DEFB $1E,$4A,$4B,$4C    ;
  DEFB $4D,$7B,$6D,$53    ;
  DEFB $6D,$53,$52,$51    ;
  DEFB $6D,$6D,$6D,$53    ; super_tile $34
  DEFB $6D,$53,$52,$51    ;
  DEFB $52,$51,$54,$6D    ;
  DEFB $54,$4E,$4F,$6D    ;
  DEFB $6D,$6D,$50,$6D    ; super_tile $35
  DEFB $7C,$19,$6D,$6D    ;
  DEFB $17,$16,$1A,$6D    ;
  DEFB $18,$1C,$1B,$6D    ;
  DEFB $7C,$19,$6D,$6D    ; super_tile $36
  DEFB $17,$16,$65,$0A    ;
  DEFB $7D,$36,$08,$0B    ;
  DEFB $08,$37,$00,$01    ;
  DEFB $6D,$7C,$50,$6D    ; super_tile $37
  DEFB $6D,$7E,$7F,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $7D,$36,$08,$0B    ; super_tile $38
  DEFB $08,$37,$00,$02    ;
  DEFB $00,$00,$02,$03    ;
  DEFB $03,$01,$03,$02    ;
  DEFB $52,$51,$54,$6D    ; super_tile $39
  DEFB $54,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $6D,$7C,$19,$6D    ;
  DEFB $6D,$17,$16,$1A    ; super_tile $3A
  DEFB $7C,$18,$1C,$1B    ;
  DEFB $7E,$7F,$6D,$6D    ;
  DEFB $6D,$6D,$7D,$0A    ;
  DEFB $6D,$6D,$6D,$0E    ; super_tile $3B
  DEFB $04,$63,$6D,$0C    ;
  DEFB $05,$80,$04,$06    ;
  DEFB $00,$02,$05,$07    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $3C
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $58,$6D,$6D,$6D    ;
  DEFB $59,$5A,$58,$6D    ;
  DEFB $6D,$5B,$59,$5A    ; super_tile $3D
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$55,$57    ;
  DEFB $58,$6D,$6D,$12    ; super_tile $3E
  DEFB $59,$5A,$58,$0C    ;
  DEFB $6D,$5B,$59,$69    ;
  DEFB $6D,$6D,$6D,$6B    ;
  DEFB $70,$6D,$56,$6D    ; super_tile $3F
  DEFB $73,$74,$6D,$6D    ;
  DEFB $77,$78,$6D,$6D    ;
  DEFB $04,$66,$6D,$6D    ;
  DEFB $6D,$6D,$6D,$0E    ; super_tile $40
  DEFB $6D,$6D,$6D,$0C    ;
  DEFB $6D,$6D,$6D,$12    ;
  DEFB $6D,$6D,$6D,$10    ;
  DEFB $05,$07,$04,$66    ; super_tile $41
  DEFB $03,$00,$05,$07    ;
  DEFB $00,$01,$03,$03    ;
  DEFB $01,$03,$02,$00    ;
  DEFB $58,$6D,$6D,$6D    ; super_tile $42
  DEFB $59,$5A,$58,$6D    ;
  DEFB $38,$5B,$59,$5A    ;
  DEFB $3B,$39,$63,$5B    ;
  DEFB $3C,$5E,$3D,$3E    ; super_tile $43
  DEFB $3C,$5E,$5E,$1F    ;
  DEFB $3C,$5E,$5E,$1F    ;
  DEFB $3F,$40,$5E,$1F    ;
  DEFB $5C,$41,$42,$1F    ; super_tile $44
  DEFB $04,$66,$05,$5D    ;
  DEFB $05,$07,$04,$63    ;
  DEFB $02,$03,$05,$80    ;
  DEFB $58,$6D,$6D,$6D    ; super_tile $45
  DEFB $59,$5A,$58,$6D    ;
  DEFB $6D,$5B,$59,$5A    ;
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $6D,$6D,$56,$74    ; super_tile $46
  DEFB $70,$6D,$81,$78    ;
  DEFB $73,$6D,$6D,$6D    ;
  DEFB $04,$63,$6D,$6D    ;
  DEFB $6D,$82,$6D,$6D    ; super_tile $47
  DEFB $74,$6D,$6D,$6D    ;
  DEFB $73,$6D,$6D,$6D    ;
  DEFB $04,$63,$6D,$6D    ;
  DEFB $6D,$5B,$59,$5A    ; super_tile $48
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $55,$57,$74,$6D    ;
  DEFB $56,$81,$78,$6D    ;
  DEFB $05,$80,$04,$63    ; super_tile $49
  DEFB $01,$00,$05,$80    ;
  DEFB $00,$03,$02,$03    ;
  DEFB $02,$01,$03,$00    ;
  DEFB $86,$6D,$56,$6D    ; super_tile $4A
  DEFB $85,$6E,$6F,$70    ;
  DEFB $84,$71,$72,$73    ;
  DEFB $83,$63,$76,$77    ;
  DEFB $87,$5B,$59,$5A    ; super_tile $4B
  DEFB $86,$82,$6D,$5B    ;
  DEFB $84,$6D,$6D,$6D    ;
  DEFB $87,$6D,$55,$57    ;
  DEFB $6D,$5B,$59,$5A    ; super_tile $4C
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $55,$57,$6D,$6D    ;
  DEFB $56,$6D,$55,$57    ;
  DEFB $6D,$6D,$56,$6D    ; super_tile $4D
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $82,$6D,$6D,$6E    ;
  DEFB $04,$66,$6D,$71    ;
  DEFB $6D,$74,$56,$6D    ; super_tile $4E
  DEFB $81,$78,$6D,$6D    ;
  DEFB $82,$6D,$6D,$6D    ;
  DEFB $04,$63,$6D,$6D    ;
  DEFB $70,$6D,$56,$6D    ; super_tile $4F  [unused by map]
  DEFB $73,$74,$6D,$6D    ;
  DEFB $77,$78,$6D,$81    ;
  DEFB $04,$66,$6D,$82    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $50
  DEFB $38,$6D,$6D,$6D    ;
  DEFB $3B,$39,$63,$6D    ;
  DEFB $3F,$40,$3D,$3E    ;
  DEFB $71,$72,$73,$74    ; super_tile $51
  DEFB $38,$76,$77,$78    ;
  DEFB $3B,$39,$63,$6D    ;
  DEFB $3F,$40,$3D,$3E    ;
  DEFB $58,$6D,$6D,$6D    ; super_tile $52
  DEFB $59,$5A,$58,$6D    ;
  DEFB $6D,$5B,$59,$5A    ;
  DEFB $6E,$6F,$70,$5B    ;
  DEFB $38,$5B,$59,$5A    ; super_tile $53
  DEFB $3B,$39,$63,$5B    ;
  DEFB $3C,$5E,$3D,$3E    ;
  DEFB $3C,$5E,$5E,$1F    ;
  DEFB $3C,$5E,$5E,$1F    ; super_tile $54
  DEFB $3F,$40,$5E,$1F    ;
  DEFB $5C,$41,$42,$1F    ;
  DEFB $04,$63,$05,$5D    ;
  DEFB $86,$6D,$6D,$6D    ; super_tile $55
  DEFB $84,$6D,$6D,$6D    ;
  DEFB $87,$6D,$6D,$6D    ;
  DEFB $86,$5A,$58,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $56
  DEFB $04,$66,$82,$6D    ;
  DEFB $05,$07,$04,$63    ;
  DEFB $02,$03,$05,$80    ;
  DEFB $6E,$6F,$70,$6D    ; super_tile $57
  DEFB $71,$72,$73,$74    ;
  DEFB $75,$76,$77,$78    ;
  DEFB $6D,$6D,$82,$6D    ;
  DEFB $3C,$5E,$5E,$1F    ; super_tile $58
  DEFB $3F,$40,$5E,$1F    ;
  DEFB $5C,$41,$42,$1F    ;
  DEFB $6D,$6D,$05,$5D    ;
  DEFB $87,$6D,$6D,$5B    ; super_tile $59
  DEFB $86,$82,$55,$57    ;
  DEFB $84,$6E,$56,$6D    ;
  DEFB $87,$82,$6D,$6D    ;
  DEFB $55,$57,$6D,$6D    ; super_tile $5A
  DEFB $56,$6D,$55,$57    ;
  DEFB $6D,$6D,$56,$6D    ;
  DEFB $73,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$6E,$6F    ; super_tile $5B
  DEFB $6D,$6D,$71,$72    ;
  DEFB $58,$6D,$75,$76    ;
  DEFB $59,$5A,$58,$6D    ;
  DEFB $86,$6D,$6D,$6D    ; super_tile $5C
  DEFB $84,$5A,$58,$6D    ;
  DEFB $87,$5B,$59,$5A    ;
  DEFB $86,$6D,$6D,$5B    ;
  DEFB $86,$6D,$6D,$74    ; super_tile $5D
  DEFB $84,$6D,$81,$78    ;
  DEFB $84,$6D,$82,$6D    ;
  DEFB $87,$66,$6D,$6D    ;
  DEFB $6E,$6F,$70,$12    ; super_tile $5E
  DEFB $71,$72,$73,$10    ;
  DEFB $75,$76,$77,$0E    ;
  DEFB $6D,$6D,$6D,$0C    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $5F
  DEFB $65,$7C,$6D,$6D    ;
  DEFB $08,$7E,$7F,$6D    ;
  DEFB $6D,$6D,$6D,$7C    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $60
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $86,$3F,$40,$5E    ; super_tile $61
  DEFB $85,$5C,$41,$88    ;
  DEFB $84,$6D,$82,$05    ;
  DEFB $83,$63,$6D,$6D    ;
  DEFB $5E,$3D,$3E,$0E    ; super_tile $62
  DEFB $40,$5E,$1F,$0C    ;
  DEFB $41,$42,$1F,$12    ;
  DEFB $58,$05,$5D,$10    ;
  DEFB $87,$6D,$6D,$5B    ; super_tile $63
  DEFB $86,$38,$81,$78    ;
  DEFB $84,$3B,$39,$63    ;
  DEFB $87,$3C,$5E,$3D    ;
  DEFB $59,$5A,$58,$0E    ; super_tile $64
  DEFB $6D,$5B,$59,$5F    ;
  DEFB $6D,$6D,$81,$6B    ;
  DEFB $39,$63,$82,$10    ;
  DEFB $86,$3F,$40,$5E    ; super_tile $65
  DEFB $84,$5C,$41,$88    ;
  DEFB $87,$5A,$58,$05    ;
  DEFB $86,$5B,$59,$5A    ;
  DEFB $0F,$53,$52,$51    ; super_tile $66
  DEFB $6A,$51,$54,$7F    ;
  DEFB $6C,$4E,$4F,$6D    ;
  DEFB $11,$6D,$50,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ; super_tile $67
  DEFB $04,$66,$6D,$6D    ;
  DEFB $05,$07,$04,$63    ;
  DEFB $03,$02,$05,$80    ;
  DEFB $6D,$6F,$70,$6D    ; super_tile $68
  DEFB $81,$72,$73,$6D    ;
  DEFB $82,$76,$77,$6D    ;
  DEFB $04,$66,$82,$6D    ;
  DEFB $66,$6D,$6D,$6D    ; super_tile $69
  DEFB $07,$74,$6E,$6D    ;
  DEFB $81,$78,$04,$82    ;
  DEFB $82,$6D,$05,$6D    ;
  DEFB $A1,$9A,$A3,$A4    ; super_tile $6A
  DEFB $86,$6D,$8E,$9A    ;
  DEFB $85,$5A,$58,$81    ;
  DEFB $84,$5B,$59,$5A    ;
  DEFB $8E,$8F,$90,$91    ; super_tile $6B
  DEFB $6E,$5A,$8E,$94    ;
  DEFB $82,$5B,$59,$5A    ;
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $0F,$6D,$64,$20    ; super_tile $6C
  DEFB $8B,$0A,$2D,$1F    ;
  DEFB $8C,$2C,$2E,$1F    ;
  DEFB $8D,$28,$29,$68    ;
  DEFB $17,$16,$1A,$9B    ; super_tile $6D
  DEFB $18,$1C,$1B,$9C    ;
  DEFB $6D,$53,$52,$9D    ;
  DEFB $52,$51,$54,$9C    ;
  DEFB $92,$93,$6D,$9D    ; super_tile $6E
  DEFB $95,$96,$9A,$9F    ;
  DEFB $8E,$97,$95,$96    ;
  DEFB $59,$5A,$8E,$97    ;
  DEFB $54,$19,$6D,$9B    ; super_tile $6F
  DEFB $17,$16,$6D,$9C    ;
  DEFB $6D,$7D,$6D,$9D    ;
  DEFB $7C,$19,$6D,$9E    ;
  DEFB $9A,$A0,$00,$01    ; super_tile $70
  DEFB $95,$96,$9A,$A0    ;
  DEFB $8E,$97,$95,$96    ;
  DEFB $59,$5A,$8E,$97    ;
  DEFB $02,$00,$01,$00    ; super_tile $71
  DEFB $03,$01,$02,$03    ;
  DEFB $9A,$A0,$01,$00    ;
  DEFB $95,$96,$9A,$A0    ;
  DEFB $8E,$97,$95,$96    ; super_tile $72
  DEFB $59,$5A,$8E,$94    ;
  DEFB $6D,$5B,$59,$5A    ;
  DEFB $6D,$6D,$6D,$5B    ;
  DEFB $6D,$5B,$59,$5A    ; super_tile $73
  DEFB $6D,$6E,$74,$5B    ;
  DEFB $6D,$81,$78,$6D    ;
  DEFB $6D,$82,$6D,$6D    ;
  DEFB $00,$03,$B2,$B3    ; super_tile $74
  DEFB $A0,$01,$B6,$B7    ;
  DEFB $8E,$9A,$A0,$02    ;
  DEFB $58,$82,$8E,$9A    ;
  DEFB $02,$00,$01,$00    ; super_tile $75
  DEFB $03,$01,$02,$03    ;
  DEFB $01,$00,$A6,$A7    ;
  DEFB $A6,$A7,$A8,$6D    ;
  DEFB $02,$01,$A6,$A7    ; super_tile $76
  DEFB $A6,$A7,$A8,$6D    ;
  DEFB $A8,$6D,$A5,$A4    ;
  DEFB $A5,$A4,$00,$03    ;
  DEFB $B4,$B5,$02,$01    ; super_tile $77
  DEFB $B8,$B9,$03,$B1    ;
  DEFB $02,$B1,$AF,$B0    ;
  DEFB $AF,$B0,$6D,$53    ;
  DEFB $AD,$AE,$AF,$A2    ; super_tile $78
  DEFB $AF,$B0,$7E,$9E    ;
  DEFB $7C,$53,$52,$9B    ;
  DEFB $52,$51,$54,$9C    ;
  DEFB $02,$03,$00,$02    ; super_tile $79
  DEFB $00,$00,$02,$03    ;
  DEFB $AA,$AB,$03,$02    ;
  DEFB $6D,$A9,$AA,$AB    ;
  DEFB $AA,$AB,$03,$00    ; super_tile $7A
  DEFB $6D,$A9,$AA,$AB    ;
  DEFB $AD,$AC,$6D,$A9    ;
  DEFB $02,$01,$AD,$AC    ;
  DEFB $BD,$6D,$A5,$A4    ; super_tile $7B
  DEFB $BF,$A4,$01,$00    ;
  DEFB $00,$02,$03,$B1    ;
  DEFB $00,$B1,$AF,$B0    ;
  DEFB $A8,$6D,$A5,$A4    ; super_tile $7C
  DEFB $A5,$A4,$01,$00    ;
  DEFB $00,$02,$03,$B1    ;
  DEFB $00,$B1,$AF,$B0    ;
  DEFB $BE,$B0,$BA,$BC    ; super_tile $7D
  DEFB $BF,$BC,$BB,$6D    ;
  DEFB $6D,$7C,$BB,$6D    ;
  DEFB $6D,$7E,$7F,$6D    ;
  DEFB $AF,$B0,$BA,$BC    ; super_tile $7E
  DEFB $A5,$BC,$BB,$7C    ;
  DEFB $6D,$6D,$BB,$6D    ;
  DEFB $6D,$6D,$6D,$6D    ;
  DEFB $02,$03,$FE,$B1    ; super_tile $7F
  DEFB $01,$B1,$AF,$B0    ;
  DEFB $AF,$B0,$A5,$BC    ;
  DEFB $A5,$BC,$6D,$6D    ;
  DEFB $AF,$B0,$BA,$C1    ; super_tile $80
  DEFB $A5,$BC,$6D,$5B    ;
  DEFB $89,$6D,$55,$57    ;
  DEFB $87,$6D,$56,$6D    ;
  DEFB $C5,$28,$33,$15    ; super_tile $81
  DEFB $C4,$28,$29,$1F    ;
  DEFB $05,$2A,$25,$C2    ;
  DEFB $00,$B1,$C3,$B0    ;
  DEFB $85,$5B,$59,$5A    ; super_tile $82
  DEFB $C7,$63,$6D,$5B    ;
  DEFB $C6,$24,$04,$23    ;
  DEFB $C6,$26,$27,$1F    ;
  DEFB $6D,$6D,$6D,$5B    ; super_tile $83
  DEFB $70,$38,$81,$78    ;
  DEFB $73,$3B,$39,$63    ;
  DEFB $6D,$3C,$5E,$3D    ;
  DEFB $B4,$B5,$02,$01    ; super_tile $84
  DEFB $B8,$B9,$03,$00    ;
  DEFB $00,$02,$03,$01    ;
  DEFB $A0,$00,$01,$02    ;
  DEFB $AD,$AC,$6D,$A9    ; super_tile $85
  DEFB $03,$00,$AD,$AC    ;
  DEFB $00,$01,$03,$03    ;
  DEFB $01,$03,$02,$00    ;
  DEFB $59,$5A,$58,$6D    ; super_tile $86
  DEFB $6D,$5B,$59,$5A    ;
  DEFB $6D,$6D,$81,$5B    ;
  DEFB $39,$63,$82,$6D    ;
  DEFB $5E,$3D,$3E,$6D    ; super_tile $87
  DEFB $40,$5E,$1F,$70    ;
  DEFB $41,$42,$1F,$73    ;
  DEFB $58,$05,$5D,$6D    ;
  DEFB $8E,$9A,$A0,$01    ; super_tile $88
  DEFB $58,$6D,$8E,$9A    ;
  DEFB $59,$5A,$58,$6D    ;
  DEFB $6D,$5B,$59,$5A    ;
  DEFB $86,$6F,$70,$6D    ; super_tile $89
  DEFB $85,$72,$73,$74    ;
  DEFB $84,$76,$77,$78    ;
  DEFB $83,$63,$6D,$6D    ;
  DEFB $0F,$6D,$6D,$6D    ; super_tile $8A
  DEFB $0D,$7C,$19,$6D    ;
  DEFB $13,$17,$16,$1A    ;
  DEFB $11,$18,$1C,$1B    ;
  DEFB $08,$09,$0B,$09    ; super_tile $8B
  DEFB $08,$09,$0B,$09    ;
  DEFB $08,$09,$0B,$09    ;
  DEFB $10,$09,$0B,$09    ;
  DEFB $11,$0F,$0B,$09    ; super_tile $8C
  DEFB $15,$13,$0D,$0F    ;
  DEFB $12,$16,$12,$13    ;
  DEFB $13,$14,$15,$15    ;
  DEFB $0B,$09,$0B,$0C    ; super_tile $8D
  DEFB $0B,$09,$0B,$0C    ;
  DEFB $0D,$0F,$0B,$0C    ;
  DEFB $14,$13,$0D,$0E    ;
  DEFB $0B,$09,$0A,$06    ; super_tile $8E
  DEFB $0B,$09,$0B,$0C    ;
  DEFB $0B,$09,$0B,$0C    ;
  DEFB $0B,$09,$0B,$0C    ;
  DEFB $15,$14,$13,$12    ; super_tile $8F
  DEFB $02,$12,$14,$15    ;
  DEFB $05,$06,$02,$16    ;
  DEFB $0A,$06,$05,$06    ;
  DEFB $07,$01,$02,$17    ; super_tile $90
  DEFB $03,$06,$05,$06    ;
  DEFB $08,$09,$0A,$06    ;
  DEFB $08,$09,$0B,$09    ;
  DEFB $14,$16,$12,$13    ; super_tile $91
  DEFB $15,$14,$13,$17    ;
  DEFB $17,$13,$15,$14    ;
  DEFB $02,$12,$13,$12    ;
  DEFB $16,$15,$17,$14    ; super_tile $92
  DEFB $14,$13,$15,$12    ;
  DEFB $16,$12,$17,$13    ;
  DEFB $15,$14,$13,$17    ;
  DEFB $1E,$20,$1E,$1F    ; super_tile $93
  DEFB $1E,$20,$1E,$1F    ;
  DEFB $1E,$20,$1E,$1F    ;
  DEFB $1E,$20,$1E,$1F    ;
  DEFB $1E,$20,$22,$23    ; super_tile $94
  DEFB $22,$21,$17,$14    ;
  DEFB $14,$13,$15,$12    ;
  DEFB $16,$12,$17,$13    ;
  DEFB $25,$20,$1E,$20    ; super_tile $95
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$22,$21    ;
  DEFB $24,$21,$17,$13    ;
  DEFB $1B,$00,$1E,$20    ; super_tile $96
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $17,$18,$19,$1A    ; super_tile $97
  DEFB $1B,$1C,$1B,$1D    ;
  DEFB $1B,$00,$1E,$1F    ;
  DEFB $1E,$20,$1E,$1F    ;
  DEFB $13,$15,$14,$15    ; super_tile $98
  DEFB $14,$16,$17,$18    ;
  DEFB $17,$18,$1B,$1C    ;
  DEFB $1B,$1C,$1B,$00    ;
  DEFB $16,$15,$17,$14    ; super_tile $99
  DEFB $14,$13,$15,$12    ;
  DEFB $12,$16,$17,$13    ;
  DEFB $15,$17,$13,$18    ;
  DEFB $16,$14,$15,$12    ; super_tile $9A  [unused by map]
  DEFB $13,$69,$6A,$13    ;
  DEFB $15,$6B,$6C,$14    ;
  DEFB $14,$13,$16,$12    ;
  DEFB $28,$27,$26,$29    ; super_tile $9B
  DEFB $02,$28,$29,$27    ;
  DEFB $05,$06,$02,$17    ;
  DEFB $0A,$06,$05,$06    ;
  DEFB $27,$28,$29,$28    ; super_tile $9C
  DEFB $26,$29,$28,$27    ;
  DEFB $28,$27,$27,$26    ;
  DEFB $02,$28,$26,$18    ;
  DEFB $26,$28,$27,$28    ; super_tile $9D
  DEFB $28,$27,$29,$18    ;
  DEFB $26,$18,$1B,$1C    ;
  DEFB $1B,$1C,$1B,$00    ;
  DEFB $2D,$20,$1E,$20    ; super_tile $9E
  DEFB $2D,$20,$1E,$20    ;
  DEFB $2D,$20,$22,$21    ;
  DEFB $2B,$21,$17,$13    ;
  DEFB $0B,$09,$0B,$2C    ; super_tile $9F
  DEFB $0B,$09,$0B,$2C    ;
  DEFB $0D,$0F,$0B,$2C    ;
  DEFB $13,$14,$0D,$2A    ;
  DEFB $0B,$09,$0A,$2E    ; super_tile $A0
  DEFB $0B,$09,$0B,$2C    ;
  DEFB $0B,$09,$0B,$2C    ;
  DEFB $0B,$09,$0B,$2C    ;
  DEFB $2F,$00,$1E,$20    ; super_tile $A1
  DEFB $2D,$20,$1E,$20    ;
  DEFB $2D,$20,$1E,$20    ;
  DEFB $2D,$20,$1E,$20    ;
  DEFB $15,$14,$13,$12    ; super_tile $A2
  DEFB $02,$17,$14,$15    ;
  DEFB $05,$06,$02,$17    ;
  DEFB $0A,$06,$05,$30    ;
  DEFB $13,$15,$14,$15    ; super_tile $A3
  DEFB $14,$16,$17,$18    ;
  DEFB $17,$18,$1B,$1C    ;
  DEFB $31,$1C,$1B,$00    ;
  DEFB $42,$09,$0B,$3A    ; super_tile $A4
  DEFB $41,$09,$0B,$3A    ;
  DEFB $3D,$3E,$3B,$3A    ;
  DEFB $13,$17,$3D,$3C    ;
  DEFB $36,$3E,$3B,$45    ; super_tile $A5
  DEFB $12,$13,$3D,$46    ;
  DEFB $14,$15,$14,$13    ;
  DEFB $12,$13,$12,$14    ;
  DEFB $44,$38,$37,$06    ; super_tile $A6
  DEFB $42,$43,$40,$39    ;
  DEFB $42,$09,$0B,$3F    ;
  DEFB $42,$09,$0B,$3A    ;
  DEFB $35,$09,$0B,$47    ; super_tile $A7
  DEFB $35,$09,$0B,$45    ;
  DEFB $34,$09,$0B,$45    ;
  DEFB $35,$09,$0B,$45    ;
  DEFB $07,$01,$02,$17    ; super_tile $A8
  DEFB $32,$06,$05,$06    ;
  DEFB $33,$38,$37,$06    ;
  DEFB $34,$43,$40,$38    ;
  DEFB $16,$15,$14,$15    ; super_tile $A9
  DEFB $02,$17,$13,$17    ;
  DEFB $05,$06,$02,$15    ;
  DEFB $41,$06,$05,$06    ;
  DEFB $29,$27,$28,$29    ; super_tile $AA
  DEFB $02,$28,$29,$27    ;
  DEFB $05,$06,$02,$26    ;
  DEFB $0A,$06,$05,$06    ;
  DEFB $08,$09,$0B,$09    ; super_tile $AB
  DEFB $08,$09,$0B,$4F    ;
  DEFB $08,$4F,$50,$4A    ;
  DEFB $52,$4A,$51,$4B    ;
  DEFB $0B,$49,$19,$48    ; super_tile $AC
  DEFB $50,$4A,$50,$1D    ;
  DEFB $51,$4B,$4C,$4E    ;
  DEFB $4C,$4D,$4C,$4E    ;
  DEFB $53,$4B,$4C,$4D    ; super_tile $AD
  DEFB $25,$20,$1E,$4D    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $4C,$4D,$4C,$4E    ; super_tile $AE
  DEFB $4C,$4D,$4C,$4E    ;
  DEFB $1E,$4D,$4C,$4E    ;
  DEFB $1E,$20,$1E,$4E    ;
  DEFB $55,$54,$57,$55    ; super_tile $AF
  DEFB $54,$56,$55,$18    ;
  DEFB $57,$18,$1B,$1C    ;
  DEFB $1B,$1C,$1B,$00    ;
  DEFB $54,$55,$56,$57    ; super_tile $B0
  DEFB $56,$57,$54,$55    ;
  DEFB $55,$56,$57,$54    ;
  DEFB $54,$55,$54,$18    ;
  DEFB $28,$28,$26,$29    ; super_tile $B1
  DEFB $27,$29,$27,$56    ;
  DEFB $29,$56,$57,$57    ;
  DEFB $57,$56,$55,$54    ;
  DEFB $17,$18,$19,$1A    ; super_tile $B2
  DEFB $5A,$1C,$1B,$1D    ;
  DEFB $65,$64,$58,$1F    ;
  DEFB $65,$5E,$5F,$5C    ;
  DEFB $61,$66,$62,$5C    ; super_tile $B3
  DEFB $61,$66,$68,$63    ;
  DEFB $61,$66,$68,$63    ;
  DEFB $61,$66,$68,$63    ;
  DEFB $61,$66,$68,$09    ; super_tile $B4
  DEFB $61,$67,$0B,$09    ;
  DEFB $11,$0F,$0B,$09    ;
  DEFB $15,$14,$0D,$0F    ;
  DEFB $5B,$01,$58,$20    ; super_tile $B5
  DEFB $03,$06,$5F,$5D    ;
  DEFB $61,$60,$0A,$5E    ;
  DEFB $61,$09,$0B,$09    ;
  DEFB $1E,$20,$22,$23    ; super_tile $B6
  DEFB $59,$21,$17,$15    ;
  DEFB $05,$06,$02,$16    ;
  DEFB $0A,$06,$05,$06    ;
  DEFB $1B,$00,$1E,$20    ; super_tile $B7
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $58,$20,$1E,$20    ;
  DEFB $16,$14,$15,$12    ; super_tile $B8
  DEFB $13,$69,$6A,$13    ;
  DEFB $15,$6B,$6C,$14    ;
  DEFB $14,$13,$16,$12    ;
  DEFB $28,$27,$26,$16    ; super_tile $B9
  DEFB $29,$17,$28,$27    ;
  DEFB $17,$28,$16,$51    ;
  DEFB $17,$A0,$9F,$9B    ;
  DEFB $17,$28,$16,$26    ; super_tile $BA
  DEFB $16,$29,$27,$28    ;
  DEFB $9A,$17,$28,$27    ;
  DEFB $9C,$9D,$9E,$17    ;
  DEFB $26,$27,$17,$70    ; super_tile $BB
  DEFB $16,$28,$29,$15    ;
  DEFB $28,$29,$26,$16    ;
  DEFB $02,$17,$26,$70    ;
  DEFB $97,$99,$B0,$B1    ; super_tile $BC
  DEFB $88,$8F,$8A,$AC    ;
  DEFB $8D,$96,$98,$6E    ;
  DEFB $8B,$AF,$8C,$83    ;
  DEFB $B2,$AE,$94,$95    ; super_tile $BD
  DEFB $AD,$85,$92,$93    ;
  DEFB $6F,$91,$A9,$8E    ;
  DEFB $84,$AB,$AA,$85    ;
  DEFB $6D,$16,$28,$27    ; super_tile $BE
  DEFB $17,$28,$27,$26    ;
  DEFB $16,$27,$17,$28    ;
  DEFB $6D,$15,$29,$18    ;
  DEFB $90,$8F,$8A,$AC    ; super_tile $BF
  DEFB $81,$17,$0D,$75    ;
  DEFB $77,$06,$02,$7B    ;
  DEFB $78,$06,$05,$71    ;
  DEFB $AD,$85,$92,$89    ; super_tile $C0
  DEFB $76,$21,$26,$82    ;
  DEFB $7C,$18,$1B,$7E    ;
  DEFB $72,$1C,$1B,$7F    ;
  DEFB $79,$09,$0A,$71    ; super_tile $C1
  DEFB $79,$09,$0B,$73    ;
  DEFB $79,$09,$0B,$73    ;
  DEFB $79,$09,$0B,$73    ;
  DEFB $72,$00,$1E,$80    ; super_tile $C2
  DEFB $74,$20,$1E,$80    ;
  DEFB $74,$20,$1E,$80    ;
  DEFB $74,$20,$1E,$80    ;
  DEFB $79,$09,$0B,$73    ; super_tile $C3
  DEFB $79,$09,$0B,$73    ;
  DEFB $0D,$0F,$0B,$73    ;
  DEFB $13,$12,$0D,$7A    ;
  DEFB $74,$20,$1E,$80    ; super_tile $C4
  DEFB $74,$20,$1E,$80    ;
  DEFB $74,$20,$22,$21    ;
  DEFB $7D,$21,$14,$15    ;
  DEFB $90,$8F,$8A,$AC    ; super_tile $C5
  DEFB $A1,$28,$0D,$75    ;
  DEFB $A1,$15,$27,$7B    ;
  DEFB $A1,$28,$17,$A4    ;
  DEFB $A1,$18,$1B,$A5    ; super_tile $C6
  DEFB $A2,$1C,$1B,$A6    ;
  DEFB $A2,$00,$1E,$A8    ;
  DEFB $A3,$20,$1E,$A8    ;
  DEFB $A3,$20,$1E,$A8    ; super_tile $C7
  DEFB $A3,$20,$1E,$A8    ;
  DEFB $1E,$20,$1E,$A8    ;
  DEFB $1E,$20,$1E,$A7    ;
  DEFB $CB,$CB,$CA,$CB    ; super_tile $C8
  DEFB $CB,$CB,$CB,$18    ;
  DEFB $CB,$18,$1B,$1C    ;
  DEFB $BC,$BA,$1B,$00    ;
  DEFB $CC,$CD,$19,$04    ; super_tile $C9
  DEFB $1B,$1C,$1B,$1D    ;
  DEFB $1B,$00,$1E,$1F    ;
  DEFB $1E,$20,$1E,$1F    ;
  DEFB $BB,$B9,$B6,$B7    ; super_tile $CA
  DEFB $25,$20,$B5,$B8    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $25,$20,$1E,$20    ;
  DEFB $1E,$20,$1E,$1F    ; super_tile $CB
  DEFB $B6,$B7,$1E,$1F    ;
  DEFB $B5,$B8,$B6,$B3    ;
  DEFB $1E,$20,$B5,$B4    ;
  DEFB $59,$5A,$58,$6D    ; super_tile $CC
  DEFB $C8,$C9,$59,$5A    ;
  DEFB $13,$19,$CB,$C9    ;
  DEFB $0D,$16,$CC,$CE    ;
  DEFB $6D,$3F,$40,$5E    ; super_tile $CD
  DEFB $58,$5C,$41,$88    ;
  DEFB $59,$5A,$58,$05    ;
  DEFB $CB,$C9,$59,$5A    ;
  DEFB $14,$19,$CC,$CC    ; super_tile $CE
  DEFB $15,$16,$CD,$D5    ;
  DEFB $0F,$6D,$CC,$CE    ;
  DEFB $0D,$6D,$CC,$CC    ;
  DEFB $CC,$CE,$CB,$C9    ; super_tile $CF
  DEFB $CC,$CC,$CC,$CE    ;
  DEFB $CC,$CC,$CC,$CC    ;
  DEFB $CC,$CC,$CC,$CA    ;
  DEFB $09,$0A,$D1,$CC    ; super_tile $D0
  DEFB $08,$0B,$D2,$D3    ;
  DEFB $6D,$F4,$F7,$F8    ;
  DEFB $F7,$F8,$F7,$DC    ;
  DEFB $CC,$CA,$F5,$F6    ; super_tile $D1
  DEFB $D4,$F8,$F7,$F9    ;
  DEFB $F7,$DC,$FA,$FB    ;
  DEFB $FA,$FC,$FA,$FB    ;
  DEFB $59,$5A,$58,$0E    ; super_tile $D2
  DEFB $6D,$5B,$59,$69    ;
  DEFB $6D,$6D,$6D,$6B    ;
  DEFB $F5,$E0,$6D,$10    ;
  DEFB $F7,$F9,$6D,$0E    ; super_tile $D3
  DEFB $FA,$FB,$6D,$0C    ;
  DEFB $FA,$FB,$6D,$12    ;
  DEFB $FA,$FB,$6D,$10    ;
  DEFB $FA,$FB,$6D,$0E    ; super_tile $D4
  DEFB $FA,$D7,$6D,$0C    ;
  DEFB $FA,$D0,$04,$06    ;
  DEFB $FE,$FF,$05,$07    ;
  DEFB $0F,$53,$52,$51    ; super_tile $D5
  DEFB $6A,$51,$54,$6D    ;
  DEFB $6C,$6D,$6D,$6D    ;
  DEFB $11,$6D,$CF,$DD    ;
  DEFB $0F,$6D,$DF,$E2    ; super_tile $D6
  DEFB $0D,$6D,$E4,$E8    ;
  DEFB $13,$6D,$E4,$E8    ;
  DEFB $11,$6D,$E4,$E8    ;
  DEFB $0F,$6D,$E4,$E8    ; super_tile $D7
  DEFB $0D,$6D,$DA,$E8    ;
  DEFB $09,$0A,$DB,$E8    ;
  DEFB $08,$0B,$ED,$EA    ;
  DEFB $E3,$DD,$DE,$D6    ; super_tile $D8
  DEFB $DF,$E2,$E1,$D8    ;
  DEFB $E4,$E5,$E6,$D8    ;
  DEFB $E4,$E5,$E6,$D9    ;
  DEFB $DA,$D9,$E7,$E5    ; super_tile $D9
  DEFB $E4,$E5,$E7,$E5    ;
  DEFB $E4,$E5,$E7,$E5    ;
  DEFB $E4,$E5,$E7,$E5    ;

; Index of the current room, or 0 when outside.
room_index:
  DEFB $00

; The current door id.
current_door:
  DEFB $00

; The current visible character is made to change room.
;
; Used by the routines at door_handling, door_handling_interior, target_reached, solitary and action_papers.
;
; !I:HL Pointer to position. FIXME: Specify type.
;  I:IY Pointer to current visible character.
transition:
  EX DE,HL                ; Save position into DE
  PUSH IY                 ; Copy the current visible character pointer into HL
  POP HL                  ;
  LD A,L                  ; Extract the visible character's offset
  PUSH AF                 ; Save it for later
  ADD A,$0F               ; Point HL at the visible character's position
  LD L,A                  ;
  LD A,(IY+$1C)           ; Fetch the visible character's current room index
  AND A                   ; Are we outdoors?
  JP NZ,transition_1      ; Jump if not
; We're outdoors.
;
; Set position on X, Y axis and height by multiplying by 4.
  LD B,$03                ; Iterate thrice: X, Y and height fields
transition_0:
  PUSH BC                 ; Save BC - multiply_by_4's output register
  LD A,(DE)               ; Fetch a position byte
  CALL multiply_by_4      ; Multiply it by 4, widening it to a word in BC
  LD (HL),C               ; Store it to visible character's position and increment pointers
  INC L                   ;
  LD (HL),B               ;
  INC L                   ;
  INC DE                  ;
  POP BC                  ; Restore
  DJNZ transition_0       ; Loop
  JR transition_3         ; !Jump over indoors case (ELSE part)
; We're indoors.
;
; Set position on X, Y axis and height by copying.
transition_1:
  LD B,$03                ; Iterate thrice: X, Y and height fields
transition_2:
  LD A,(DE)               ; Widen position bytes to words, store and increment pointers
  LD (HL),A               ;
  INC L                   ;
  LD (HL),$00             ;
  INC L                   ;
  INC DE                  ;
  DJNZ transition_2       ; Loop
transition_3:
  POP AF                  ; Retrieve vischar index/offset stacked at $68A7
  LD L,A
  AND A                   ; Is it the hero?
  JP Z,transition_4       ; Jump if so
; Not the hero.
;
; This is an unusual construct. Why did the author not use JP NZ,$C5D3 above and fallthrough otherwise?
  JP reset_visible_character ; If not, exit via reset_visible_character resetting the visible character
; Hero only.
;
; HL points to the hero's visible character at this point.
transition_4:
  INC L                   ; Point HL at the visible character's flags field (always $8001)
  RES 7,(HL)              ; Clear vischar_FLAGS_NO_COLLIDE in flags
  LD A,($801C)            ; Get the visible character's room index
  LD (room_index),A       ; Set the global current room index
  AND A                   ; Are we outdoors?
  JP NZ,enter_room        ; Jump if not
; We're outdoors.
  LD A,$0C                ; Point HL at the visible character's input field (always $800D)
  ADD A,L                 ;
  LD L,A                  ;
  LD (HL),$80             ; Set input to input_KICK
  INC L                   ; Point HL at the visible character's direction field (always $800E)
  LD A,(HL)               ; Fetch the direction field and clear the non-direction bits, resetting the crawl flag
  AND $03                 ;
  LD (HL),A               ;
  CALL reset_outdoors     ; Reset the hero's position, redraw the scene then zoombox it onto the screen
  JR squash_stack_goto_main ; Restart from main loop

; The hero enters a room.
;
; Used by the routines at transition, main_loop_setup, keyscan_break and reset_game.
enter_room:
  LD HL,$0000                ; Reset the game_window_offset X and Y coordinates to zero
  LD (game_window_offset),HL ;
  CALL setup_room         ; Setup the room
  CALL plot_interior_tiles ; Expand tile buffer into screen buffer
  LD HL,$EA74             ; Set the map_position to (116,234)
  LD (map_position),HL    ;
  CALL set_hero_sprite_for_room ; Set appropriate sprite for the room (standing or crawl)
  LD HL,$8000                            ; Reset the hero's screen position
  CALL calc_vischar_iso_pos_from_vischar ;
  CALL setup_movable_items ; Setup movable items
  CALL zoombox            ; Zoombox the scene onto the screen
  LD B,$01                ; Increment score by one
  CALL increase_score     ;
; FALL THROUGH into squash_stack_goto_main.

; Squash the stack then jump into the game's main loop.
;
; Used by the routines at transition and enter_room (a fall through).
squash_stack_goto_main:
  LD SP,$FFFF             ; Set stack to the very top of RAM
  JP main_loop            ; Jump to the start of the game's main loop

; Set appropriate hero sprite for room.
;
; Used by the routine at enter_room.
;
; Called when changing rooms.
set_hero_sprite_for_room:
  LD HL,$800D             ; Set the hero's visible character input field to input_KICK
  LD (HL),$80             ;
  INC L                   ; Point HL at vischar.direction ($800E)
; vischar_DIRECTION_CRAWL is set, or cleared, here but not tested directly anywhere else so it must be an offset into animindices[].
;
; When in tunnel rooms force the hero sprite to 'prisoner' and set the crawl flag appropriately.
  LD A,(room_index)               ; If the global current room index is room_29_SECOND_TUNNEL_START or above...
  CP $1D                          ;
  JR C,set_hero_sprite_for_room_0 ;
; We're in a tunnel room.
  SET 2,(HL)              ; Set the vischar_DIRECTION_CRAWL bit on vischar.direction
  LD HL,sprite_prisoner   ; Set vischar.mi.sprite to the prisoner sprite set
  LD ($8015),HL           ;
  RET                     ; Return
; We're not in a tunnel room.
set_hero_sprite_for_room_0:
  RES 2,(HL)              ; Clear the vischar_DIRECTION_CRAWL bit from vischar.direction
  RET                     ; Return

; Setup movable items.
;
; "Movable items" are the stoves and the crate which appear in three rooms in the game. Unlike ordinary items such as keys and the radio the movable items can be pushed around by the hero character walking into them. Internally they use the
; second visible character slot.
;
; Used by the routines at enter_room and reset_outdoors.
setup_movable_items:
  CALL reset_nonplayer_visible_characters ; Reset all non-player visible characters
  LD A,(room_index)       ; Get the global current room index
  CP $02                      ; If current room index is room_2_HUT2LEFT then jump to setup_stove1
  JP NZ,setup_movable_items_0 ;
  CALL setup_stove1           ;
  JR setup_movable_items_2    ;
setup_movable_items_0:
  CP $04                      ; If current room index is room_4_HUT3LEFT then jump to setup_stove2
  JP NZ,setup_movable_items_1 ;
  CALL setup_stove2           ;
  JR setup_movable_items_2    ;
setup_movable_items_1:
  CP $09                      ; If current room index is room_9_CRATE then jump to setup_crate
  JP NZ,setup_movable_items_2 ;
  CALL setup_crate            ;
setup_movable_items_2:
  CALL spawn_characters   ; Spawn characters
  CALL mark_nearby_items  ; Mark nearby items
  CALL animate            ; Animate all visible characters
  CALL move_map           ; Move the map
  JP plot_sprites         ; Plot vischars and items
setup_crate:
  LD HL,movable_item_crate ; Point HL at movable_item_crate
  LD A,$1C                ; Set A to character index character_28_CRATE
  JR setup_movable_item   ; Jump to setup_movable_item
setup_stove2:
  LD HL,movable_item_stove2 ; Point HL at movable_item_stove2
  LD A,$1B                ; Set A to character index character_27_STOVE_2
  JR setup_movable_item   ; Jump to setup_movable_item
setup_stove1:
  LD HL,movable_item_stove1 ; Point HL at movable_item_stove1
  LD A,$1A                ; Set A to character index character_26_STOVE_1
; Using the movable item specific data and a generic item reset data, setup the second visible character as a movable item.
setup_movable_item:
  LD ($8020),A            ; Assign the character index in A to the second visible character's character field
  LD BC,$0009             ; Copy nine bytes of item-specific movable item data over the second visible character data
  LD DE,$802F             ;
  LDIR                    ;
  LD HL,movable_item_reset_data ; Copy fourteen bytes of visible character data over the vischar
  LD DE,$8021                   ;
  LD BC,$000E                   ;
  LDIR                          ;
  LD A,(room_index)       ; Set the visible character's room index to the global current room index
  LD ($803C),A            ;
  LD HL,$8020             ; Point HL at the second visible character
  CALL calc_vischar_iso_pos_from_vischar ; Set saved_pos
  RET                     ; Return
; Fourteen bytes of visible character reset data.
movable_item_reset_data:
  DEFB $00                ; Flags
  DEFW $0000              ; Route
  DEFB $00,$00,$00        ; Position
  DEFB $00                ; Counter and flags
  DEFW animations         ; Animation base = &animations[0]
  DEFW anim_wait_tl       ; Animation      = animations[8] // anim_wait_tl animation
  DEFB $00                ; Animation index
  DEFB $00                ; Input
  DEFB $00                ; Direction
; Movable items. struct movable_item { word x_coord, y_coord, height; const sprite *; byte index; };
;
; Sub-struct of vischar ($802F..$8038).
movable_item_stove1:
  DEFW $003E,$0023,$0010  ; Position (62, 35, 16)
  DEFW sprite_stove       ; Sprite: sprite_stove
  DEFB $00                ; Index: 0
movable_item_crate:
  DEFW $0037,$0036,$000E  ; Position (55, 54, 14)
  DEFW sprite_crate       ; Sprite: sprite_crate
  DEFB $00                ; Index: 0
movable_item_stove2:
  DEFW $003E,$0023,$0010  ; Position (62, 35, 16)
  DEFW sprite_stove       ; Sprite: sprite_stove
  DEFB $00                ; Index: 0

; Reset all seven non-player visible characters.
;
; Used by the routine at setup_movable_items only. (!could merge into the above)
reset_nonplayer_visible_characters:
  LD HL,$8020             ; Start at the second visible character
  LD BC,$0720             ; Set B for seven iterations and set C for a 32 byte stride simultaneously
; Start loop
reset_nonplayer_visible_characters_0:
  PUSH BC                      ; Reset the visible character at HL
  PUSH HL                      ;
  CALL reset_visible_character ;
  POP HL                       ;
  POP BC                       ;
  LD A,L                  ; Step HL to the next visible character
  ADD A,C                 ;
  LD L,A                  ;
  DJNZ reset_nonplayer_visible_characters_0 ; ...loop
  RET                     ; Return

; Setup interior doors.
;
; Used by the routine at setup_room only.
;
; Clear the interior_doors[] array with door_NONE ($FF).
setup_doors:
  LD A,$FF                ; Set A to door_NONE
  LD DE,$81D9             ; Set DE to the final byte of interior_doors[] (byte 4)
  LD B,$04                ; Set all four bytes to door_NONE
setup_doors_0:
  LD (DE),A               ;
  DEC DE                  ;
  DJNZ setup_doors_0      ;
; Setup to populate interior_doors[].
  INC DE                  ; Set DE to the first interior_doors[] byte
  LD A,(room_index)       ; Fetch and shift the global current room index up by two bits, to match door_flags, then store it in B
  ADD A,A                 ;
  ADD A,A                 ;
  LD B,A                  ;
  LD C,$00                ; Initialise the door index
  EXX                     ; Switch register banks for the iteration
; We're about to walk through doors[] and extract the indices of the doors relevant to the current room.
  LD HL,doors             ; Point HL' to the first byte of doors[]
  LD B,$7C                ; Set B' to the number of entries in doors[] (124)
  LD DE,$0004             ; Set DE' to the stride of four bytes (each door is a room_and_direction byte followed by a 3-byte position)
; Start loop
;
; Save any door index which matches the current room.
setup_doors_1:
  LD A,(HL)               ; Fetch door's room_and_direction
  EXX                     ; Switch registers back to the set used on entry to the routine
  AND $FC                 ; Clear room_and_direction's direction bits (door_FLAGS_MASK_DIRECTION)
  CP B                    ; Is it the current room?
  JR NZ,setup_doors_2     ; Jump if not
; This is the current room.
  LD A,C                  ; Write to DE register C toggled with door_REVERSE
  XOR $80                 ;
  LD (DE),A               ;
  INC DE                  ;
setup_doors_2:
  LD A,C                  ; Toggle door_REVERSE in C for the next iteration
  XOR $80                 ;
  JP M,setup_doors_3      ; Jump if (C >= door_REVERSE)
  INC A                   ; Increment the door index once every two steps through the array
setup_doors_3:
  LD C,A                  ;
  EXX                     ; Switch registers again
  ADD HL,DE               ; Step HL' to the next door
  DJNZ setup_doors_1      ; ...loop
  RET                     ; Return

; Turn a door index into a door_t pointer.
;
; Used by the routines at door_handling_interior, get_nearest_door, get_target and target_reached.
;
; I:A Index of door + reverse flag in bit 7.
; O:HL Pointer to door_t.
get_door:
  LD C,A                  ; Save the original A so we can test its flag bit in a moment
  ADD A,A                 ; First double A since doors[] contains pairs of doors. This also discards the flag in bit 7
  LD L,A                  ; Form the address of doors[A] in HL
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD DE,doors             ;
  ADD HL,DE               ;
  BIT 7,C                 ; Was the door_REVERSE flag bit set on entry?
  RET Z                   ; If not, return with HL pointing to the entry
  LD A,L                  ; Otherwise, point to the next entry along
  ADD A,$04               ;
  LD L,A                  ;
  RET NC                  ;
  INC H                   ;
  RET                     ; Return

; Wipe the visible tiles array.
;
; Used by the routines at setup_room, screen_reset and choose_game_window_attributes.
wipe_visible_tiles:
  LD DE,$F0F9             ; Set all RAM from $F0F8 to $F0F8 + 24 * 17 - 1 to zero
  LD HL,$F0F8             ;
  LD BC,$0197             ;
  LD (HL),$00             ;
  LDIR                    ;
  RET                     ; Return

; Expand out the room definition for room_index.
;
; Used by the routines at enter_room, pick_up_item, process_player_input, wake_up, end_of_breakfast, select_room_and_plot and action_shovel.
setup_room:
  CALL wipe_visible_tiles ; Wipe the visible tiles array
; Form the address of rooms_and_tunnels[room_index - 1] in HL.
  LD A,(room_index)       ; Fetch the global current room index
  ADD A,A                 ; Double it so we can index rooms_and_tunnels[]
  LD HL,rooms_and_tunnels - $0002 ; Point HL at rooms_and_tunnels rooms_and_tunnels[-1]
  ADD A,L                 ; HL + A
  LD L,A                  ;
  JR NC,setup_room_0      ;
  INC H                   ;
setup_room_0:
  LD A,(HL)               ; Fetch room pointer in HL
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  PUSH HL                 ; Push it
  CALL setup_doors        ; Setup interior doors
  POP HL                  ; Pop it
; Copy the count of boundaries into state.
  LD DE,roomdef_bounds_index ; Point DE at roomdef_bounds_index roomdef_bounds_index
  LDI                     ; Copy first byte of roomdef into roomdef_bounds_index. (DE, HL incremented).
; DE now points to roomdef_object_bounds_count
;
; Copy all boundary structures into state, if any.
  LD A,(HL)               ; Fetch count of boundaries
  AND A                   ; Is it zero?
  LD (DE),A               ; Store it irrespectively
  JR NZ,setup_room_1      ; No, jump to copying step
  INC HL                  ; Skip roomdef count of boundaries
  JR setup_room_2         ; Jump to mask copying
setup_room_1:
  ADD A,A                 ; Multiply A by four (size of boundary structures) then add one (skip current counter) == size of boundary structures
  ADD A,A                 ;
  INC A                   ;
  LD C,A                  ; Copy all boundary structures
  LD B,$00                ;
  LDIR                    ;
; Copy interior mask into interior_mask_data.
setup_room_2:
  LD DE,interior_mask_data ; Point DE at interior_mask_data
  LD A,(HL)               ; Get count of interior masks
  INC HL                  ; Step
  LD (DE),A               ; Write it out
  AND A                   ; Is the count non-zero?
  JR Z,setup_room_4       ; Jump if not
  INC DE                  ; Skip over the written count
  LD B,A                  ; B is our loop counter
; Start loop
;
; interior_mask_data holds indices into interior_mask_data_source[].
setup_room_3:
  PUSH BC
  PUSH HL
  LD L,(HL)               ; Fetch an index (from roomdef?)
  LD H,$00                ;
  LD B,H                  ; BC = HL
  LD C,L                  ;
  ADD HL,HL               ; Multiply it by eight
  ADD HL,HL               ;
  ADD HL,HL               ;
  AND A                   ; Clear the carry flag
  SBC HL,BC               ; Final offset is index * 7
  LD BC,interior_mask_data_source ; Point at interior_mask_data_source
  ADD HL,BC               ; Form the address of the mask data
  LD BC,$0007             ; Width of mask data
  LDIR                    ; Copy it
  LD A,$20                ; Constant final byte is always 32
  LD (DE),A               ;
  INC DE                  ;
  POP HL
  INC HL
  POP BC
  DJNZ setup_room_3       ; ...loop
; Plot all objects (as tiles).
setup_room_4:
  LD B,(HL)               ; Count of objects
  LD A,B
  AND A                   ; Is it zero?
  RET Z                   ; Return if so
  INC HL                  ; Skip the count
; Start loop: for every object in the roomdef
setup_room_5:
  PUSH BC
  LD C,(HL)               ; Fetch the object index
  INC HL
  LD A,(HL)               ; Fetch the column
  INC HL
  PUSH HL
  LD L,(HL)
; Plot the object into the visible tiles array
  LD H,$00                ; DE = $F0F8 + row * 24 + column.
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD E,L                  ;
  LD D,H                  ;
  ADD HL,HL               ;
  ADD HL,DE               ;
  ADD A,L                 ;
  LD L,A                  ;
  JR NC,setup_room_6      ;
  INC H                   ;
setup_room_6:
  LD DE,$F0F8             ;
  ADD HL,DE               ;
  EX DE,HL                ;
  LD A,C
  CALL expand_object      ; Expand RLE-encoded object out to a set of tile references
  POP HL
  POP BC
  INC HL
  DJNZ setup_room_5       ; ...loop
  RET                     ; Return

; Expands RLE-encoded objects to a full set of tile references.
;
; Used by the routine at setup_room.
;
; Object format:
;
; +-------------------------------------------------------------------------+
; | Each object starts with two bytes which specify its dimensions:         |
; | <w> <h>              | Width in tiles, Height in tiles                  |
; | Which are then followed by a repetition of the following bytes:         |
; | <t>                  | Literal: Emit tile <t>                           |
; | <$FF> <$FF>          | Escape: Emit <$FF>                               |
; | <$FF> <128..254> <t> | Repetition: Emit tile <t> up to 126 times        |
; | <$FF> <64..79> <t>   | Range: Emit tile <t> <t+1> <t+2> .. up to <t+15> |
; | <$FF> <other>        | Other encodings are not used                     |
; +----------------------+--------------------------------------------------+
;
; Tile references of zero produce no output.
;
; I:A Object index.
; I:DE Tile buffer location to expand to.
expand_object:
  ADD A,A                    ; Fetch the object pointer from interior_object_defs[A] into HL
  LD HL,interior_object_defs ;
  LD C,A                     ;
  LD B,$00                   ;
  ADD HL,BC                  ;
  LD A,(HL)                  ;
  INC HL                     ;
  LD H,(HL)                  ;
  LD L,A                     ;
  LD B,(HL)               ; Fetch the object's width (in tiles)
  INC HL                  ;
  LD C,(HL)               ; Fetch the object's height (in tiles)
  INC HL                  ;
  LD A,B                    ; Self modify the "LD B,$xx" at end_of_row to load the tile-width into B
  LD (end_of_row + $0001),A ;
; Start main expand loop
expand:
  LD A,(HL)               ; Fetch the next byte
  CP $FF                  ; Is it an escape byte? (interiorobjecttile_ESCAPE/$FF)
  JR NZ,write_tile        ; Jump if not
; Handle an escape byte - indicating an encoded sequence
  INC HL                  ; Step over the escape byte
  LD A,(HL)               ; Fetch the next byte
  CP $FF                  ; Is it also an escape byte?
  JR Z,write_tile         ; Jump to tile write op if so - we'll emit $FF (Note: Could jump two instructions later)
  AND $F0                 ; Isolate the top nibble - the top two bits are flags (Note: This could move down to before the $40 test without affecting anything)
  CP $80                  ; Is it >= 128?
  JR NC,repetition        ; Jump to repetition handling if so
  CP $40                  ; Is it == 64?
  JR Z,range              ; Jump to range handling if so
write_tile:
  AND A                   ; Write out the tile if it's non-zero
  JR Z,expand_object_0    ;
  LD (DE),A               ;
expand_object_0:
  INC HL                  ; Move to next input byte
  INC DE                  ; Move to next output byte
  DJNZ expand             ; ...loop while width counter B is non-zero
end_of_row:
  LD B,$01                ; Reset width counter. Self modified by 6AC5
  LD A,$18                ; Width of tile buffer is 24
  SUB B                   ; Tile buffer width minus width of object gives the rowskip
  ADD A,E                 ; Add A to DE to move by rowskip
  LD E,A                  ;
  JR NC,expand_object_1   ;
  INC D                   ;
expand_object_1:
  DEC C                   ; Decrement row counter
  JR NZ,expand            ; ...loop to expand while row > 0
  RET                     ; Return
; Escape + 128..255 case: emit a repetition of the same byte
repetition:
  LD A,(HL)               ; Fetch flags+count byte
  AND $7F                 ; Mask off top bit to get repetition counter/length
  EX AF,AF'               ; Bank repetition counter
  INC HL                  ; Move to the next tile value
  LD A,(HL)               ; Fetch a tile value
  EX AF,AF'               ; Unbank repetition counter ready for the next bank
; Start of repetition loop
repetition_loop:
  EX AF,AF'               ; Bank the repetition counter
  AND A                   ; Is the tile value zero?
  JR Z,expand_object_2    ; Jump if so, avoiding the write
  LD (DE),A               ; Write it
expand_object_2:
  INC DE                  ; Move to next tile output byte
  DJNZ repetition_end     ; Decrement the width counter. Jump over the end-of-row code to repetition_end if it's non-zero
; Ran out of width / end of row
  LD A,(end_of_row + $0001) ; Fetch width (from self modified instruction) into A'
  LD B,A                  ; Reset width counter
  LD A,$18                ; Width of tile buffer is 24
  SUB B                   ; Tile buffer width minus width of object gives the rowskip
  ADD A,E                 ; Add A to DE to move by rowskip
  LD E,A                  ;
  JR NC,expand_object_3   ;
  INC D                   ;
expand_object_3:
  LD A,(HL)               ; Fetch the next tile value (reload)
  DEC C                   ; Decrement the row counter
  RET Z                   ; Return if it hit zero
repetition_end:
  EX AF,AF'               ; Unbank the repetition counter
  DEC A                   ; Decrement the repetition counter
  JR NZ,repetition_loop   ; ...loop if non-zero
  INC HL                  ; Advance the data pointer
  JR expand               ; Jump to main expand loop
; Escape + 64..79 case: emit an ascending range of bytes
;
; Bug: This self-modifies the INC A at expand_object_increment at the end of the loop body, but nothing else in the code modifies it! Possible evidence that other encodings (e.g. 'DEC A') were attempted.
range:
  LD A,$3C                       ; Make the instruction at expand_object_increment an 'INC A'
  LD (expand_object_increment),A ;
  LD A,(HL)               ; Fetch flags+count byte
  AND $0F                 ; Mask off the bottom nibble which contains the range counter
  EX AF,AF'               ; Bank the range counter
  INC HL                  ; Move to the first tile value
  LD A,(HL)               ; Get the first tile value
  EX AF,AF'               ; Unbank the range counter ready for the next bank
; Start of range loop
range_loop:
  EX AF,AF'               ; Bank the range counter
  LD (DE),A               ; Write the tile value (Note: We assume it's non-zero)
  INC DE                  ; Move to the next tile output byte
expand_object_increment:
  INC A                   ; Increment the tile value. Self modified by 6B1B
  DJNZ range_end          ; Decrement width counter. Jump over the end-of-row code to range_end if it's non-zero
; Ran out of width / end of row
  PUSH AF                 ; Stash the tile value
  LD A,(reset_width + $0001) ; Fetch width (from self modified instruction) into A'
  LD B,A                  ; Reset width counter
  LD A,$18                ; Width of tile buffer is 24
  SUB B                   ; Tile buffer width minus width of object gives the rowskip
  ADD A,E                 ; Add A to DE to move by rowskip
  LD E,A                  ;
  JR NC,expand_object_4   ;
  INC D                   ;
expand_object_4:
  POP AF                  ; Unstash the tile value
  DEC C                   ; Decrement row counter
  RET Z                   ; Return if it hit zero
range_end:
  EX AF,AF'               ; Unbank the range counter
  DEC A                   ; Decrement the range counter
  JR NZ,range_loop        ; ...loop if non-zero
  INC HL                  ; Advance the data pointer
  JR expand               ; Jump to main expand loop

; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer.
;
; Used by the routines at enter_room, pick_up_item, process_player_input, wake_up, end_of_breakfast, select_room_and_plot, screen_reset, choose_game_window_attributes and action_shovel.
plot_interior_tiles:
  LD HL,$F290             ; Point HL at the screen buffer's start address
  LD DE,$F0F8             ; Point DE at the visible tiles array
  LD C,$10                ; Set row counter to 16
; For every row
row_loop:
  LD B,$18                ; Set column counter to 24
; For every column
column_loop:
  PUSH HL                 ; Stack screen buffer pointer while we form a tile pointer
  LD A,(DE)               ; Load a tile index
  EXX                     ; Bank outer registers
  LD L,A                  ; Point HL at interior_tiles[tile index]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD DE,interior_tiles    ;
  ADD HL,DE               ;
  POP DE                  ; Unstack screen buffer pointer
  LD BC,$0818             ; Simultaneously set B for eight iterations and C for a 24 byte stride
tile_loop:
  LD A,(HL)               ; Transfer a byte (a row) of tile across
  LD (DE),A               ;
  LD A,C                      ; Advance the screen buffer pointer by the stride
  ADD A,E                     ;
  JR NC,plot_interior_tiles_0 ;
  INC D                       ;
plot_interior_tiles_0:
  LD E,A                      ;
  INC L                       ;
  DJNZ tile_loop          ; ...loop for each byte of the tile
; End of column
  EXX                     ; Unbank outer registers
  INC DE                  ; Move to next input tile
  INC HL                  ; Move to next screen buffer output
  DJNZ column_loop        ; ...loop for each column
; End of row
  LD A,$A8                    ; Move to the next screen buffer row (seven rows down)
  ADD A,L                     ;
  JR NC,plot_interior_tiles_1 ;
  INC H                       ;
plot_interior_tiles_1:
  LD L,A                      ;
  DEC C                   ; ...loop for each row
  JP NZ,row_loop          ;
; End
  RET                     ; Return

; Table of pointers to prisoner bed objects in room definition data.
;
; Six pointers to bed objects in room definition data. These are the beds of the active prisoners (characters 20 to 25).
;
; Note that the topmost hut has three prisoners permanently in bed and one permanently empty bed.
beds:
  DEFW roomdef_3_hut2_right_bed_A ; roomdef_3_hut2_right byte 29 - rightmost bed in hut 2 right - used by char route 7
  DEFW roomdef_3_hut2_right_bed_B ; roomdef_3_hut2_right byte 32 - middle bed in hut 2 right - used by char route 8
  DEFW roomdef_3_hut2_right_bed_C ; roomdef_3_hut2_right byte 35 - leftmost bed in hut 2 right - used by char route 9
  DEFW roomdef_5_hut2_right_bed_D ; roomdef_5_hut3_right byte 29 - rightmost in hut 3 right - used by char route 10
  DEFW roomdef_5_hut2_right_bed_E ; roomdef_5_hut3_right byte 32 - middle in hut 3 right - used by char route 11
  DEFW roomdef_5_hut2_right_bed_F ; roomdef_5_hut3_right byte 35 - leftmost in hut 3 right - used by char route 12

; Room dimensions.
;
; The room definitions specify their dimensions via an index into this table. Note that it looks like a bounds_t but has a different order.
;
; +------+-------+------+-----------+
; | Type | Bytes | Name | Meaning   |
; +------+-------+------+-----------+
; | Byte | 1     | x1   | Maximum x |
; | Byte | 1     | x0   | Minimum x |
; | Byte | 1     | y1   | Maximum y |
; | Byte | 1     | y0   | Minimum y |
; +------+-------+------+-----------+
;
; Used by interior_bounds_check only.
roomdef_dimensions:
  DEFB $42,$1A,$46,$16    ; ( 66, 26,  70, 22)
  DEFB $3E,$16,$3A,$1A    ; ( 62, 22,  58, 26)
  DEFB $36,$1E,$42,$12    ; ( 54, 30,  66, 18)
  DEFB $3E,$1E,$3A,$22    ; ( 62, 30,  58, 34)
  DEFB $4A,$12,$3E,$1E    ; ( 74, 18,  62, 30)
  DEFB $38,$32,$64,$0A    ; ( 56, 50, 100, 10)
  DEFB $68,$06,$38,$32    ; (104,  6,  56, 50)
  DEFB $38,$32,$64,$1A    ; ( 56, 50, 100, 26)
  DEFB $68,$1C,$38,$32    ; (104, 28,  56, 50)
  DEFB $38,$32,$58,$0A    ; ( 56, 50,  88, 10)

; Array of pointers to room and tunnel definitions.
;
; Room definition format:
;
; +---------------------+-----------------------------------------------------------------------------+
; | Byte                | Meaning                                                                     |
; +---------------------+-----------------------------------------------------------------------------+
; | <rd>                | Room dimensions - indirect via roomdef_dimensions                           |
; | <nb>                | Number of boundaries in the room (rectangles where characters can't walk)   |
; | Followed by an array of those boundaries:                                                         |
; | <x0> <y0> <x1> <y1> | A boundary                                                                  |
; | Then:                                                                                             |
; | <nm>                | Number of mask indices used in the room (indexes interior_mask_data_source) |
; | Followed by an array of those mask bytes:                                                         |
; | <mb>                | Mask byte                                                                   |
; | Then:                                                                                             |
; | <no>                | Number of objects in the room                                               |
; | Followed by an array of those objects:                                                            |
; | <io> <x> <y>        | Interior object ref, x, y                                                   |
; +---------------------+-----------------------------------------------------------------------------+
;
; Note: The first entry is room 1, not room 0.
rooms_and_tunnels:
  DEFW roomdef_1_hut1_right ; Room 1
  DEFW roomdef_2_hut2_left
  DEFW roomdef_3_hut2_right
  DEFW roomdef_4_hut3_left
  DEFW roomdef_5_hut3_right
  DEFW roomdef_8_corridor ; Room 6 is unused
  DEFW roomdef_7_corridor
  DEFW roomdef_8_corridor
  DEFW roomdef_9_crate
  DEFW roomdef_10_lockpick
  DEFW roomdef_11_papers
  DEFW roomdef_12_corridor
  DEFW roomdef_13_corridor
  DEFW roomdef_14_torch
  DEFW roomdef_15_uniform
  DEFW roomdef_16_corridor
  DEFW roomdef_7_corridor ; Room 17 uses the same definition as room 7
  DEFW roomdef_18_radio
  DEFW roomdef_19_food
  DEFW roomdef_20_redcross
  DEFW roomdef_16_corridor ; Room 21 uses the same definition as room 16
  DEFW roomdef_22_red_key
  DEFW roomdef_23_breakfast
  DEFW roomdef_24_solitary
  DEFW roomdef_25_breakfast
  DEFW roomdef_28_hut1_left ; Room 26 is unused
  DEFW roomdef_28_hut1_left ; Room 27 is unused
  DEFW roomdef_28_hut1_left
; Array of pointers to tunnels.
  DEFW roomdef_29_second_tunnel_start
  DEFW roomdef_30
  DEFW roomdef_31
  DEFW roomdef_32
  DEFW roomdef_29_second_tunnel_start ; Room 33 uses the same definition as room 29
  DEFW roomdef_34
  DEFW roomdef_35
  DEFW roomdef_36
  DEFW roomdef_34         ; Room 37 uses the same definition as room 34
  DEFW roomdef_35         ; Room 38 uses the same definition as room 35
  DEFW roomdef_32         ; Room 39 uses the same definition as room 32
  DEFW roomdef_40
  DEFW roomdef_30         ; Room 41 uses the same definition as room 30
  DEFW roomdef_32         ; Room 42 uses the same definition as room 32
  DEFW roomdef_29_second_tunnel_start ; Room 43 uses the same definition as room 29
  DEFW roomdef_44
  DEFW roomdef_36         ; Room 45 uses the same definition as room 36
  DEFW roomdef_36         ; Room 46 uses the same definition as room 36
  DEFW roomdef_32         ; Room 47 uses the same definition as room 32
  DEFW roomdef_34         ; Room 48 uses the same definition as room 34
  DEFW roomdef_36         ; Room 49 uses the same definition as room 36
  DEFW roomdef_50_blocked_tunnel
  DEFW roomdef_32         ; Room 51 uses the same definition as room 32
  DEFW roomdef_40         ; Room 52 uses the same definition as room 40

; Room 1: Hut 1, far side.
roomdef_1_hut1_right:
  DEFB $00                ; 0
  DEFB $03                ; 3 // count of boundaries
  DEFB $36,$44,$17,$22    ; 54, 68, 23, 34 }, // boundary
  DEFB $36,$44,$27,$32    ; 54, 68, 39, 50 }, // boundary
  DEFB $36,$44,$37,$44    ; 54, 68, 55, 68 }, // boundary
  DEFB $04                ; 4 // count of mask bytes
  DEFB $00,$01,$03,$0A    ; [0, 1, 3, 10] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $08,$08,$00        ; interiorobject_WIDE_WINDOW,                  8,  0 },
  DEFB $08,$02,$03        ; interiorobject_WIDE_WINDOW,                  2,  3 },
  DEFB $17,$0A,$05        ; interiorobject_OCCUPIED_BED,                10,  5 },
  DEFB $17,$06,$07        ; interiorobject_OCCUPIED_BED,                 6,  7 },
  DEFB $0F,$0F,$08        ; interiorobject_DOOR_FRAME_SW_NE,            15,  8 },
  DEFB $18,$12,$05        ; interiorobject_ORNATE_WARDROBE_FACING_SW,   18,  5 },
  DEFB $18,$14,$06        ; interiorobject_ORNATE_WARDROBE_FACING_SW,   20,  6 },
  DEFB $09,$02,$09        ; interiorobject_EMPTY_BED,                    2,  9 },
  DEFB $10,$07,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             7, 10 },

; Illustration
;
; Cartesian coordinates for room 2:
;
;        X>>>>> Y>>>>>
;  Room: 22..62 26..58 - the first byte of the room definition gives us this
;   Bed: 48..64 43..56 - the first boundary is the bed
; Table: 24..38 26..40 - the second boundary is the table
;
;    22 ................X................. 62
; 26 +-+------------+-----------------------+
;  . | |            |                       |
;  . | |            |                       |
;  . | |   Table    |                       |
;  . | |            |                       |
;  . | |            |                       |
;  . | +------------+                       |
;  . |                                      |
;  Y |                    +-------------------+
;  . |                    |                   |
;  . |                    |                   |
;  . |                    |        Bed        |
;  . |                    |                   |
;  . |                    |                   |
;  . |                    +-------------------+
;  . |                                      |
; 58 +--------------------------------------+
;
; (Not necessarily to scale.)

; Room 2: Hut 2, near side.
roomdef_2_hut2_left:
  DEFB $01                ; 1
  DEFB $02                ; 2 // count of boundaries
  DEFB $30,$40,$2B,$38    ; 48, 64, 43, 56 }, // boundary (bed)
  DEFB $18,$26,$1A,$28    ; 24, 38, 26, 40 }, // boundary (table)
  DEFB $02                ; 2 // count of mask bytes
  DEFB $0D,$08            ; [13, 8] // data mask bytes
  DEFB $08                ; 8 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $08,$06,$02        ; interiorobject_WIDE_WINDOW,                  6,  2 },
  DEFB $28,$10,$05        ; interiorobject_END_DOOR_FRAME_NW_SE,        16,  5 },
  DEFB $1E,$04,$05        ; interiorobject_STOVE_PIPE,                   4,  5 },
roomdef_2_hut2_left_heros_bed:
  DEFB $17,$08,$07        ; interiorobject_OCCUPIED_BED,                 8,  7 },
  DEFB $10,$07,$09        ; interiorobject_DOOR_FRAME_NW_SE,             7,  9 },
  DEFB $1D,$0B,$0C        ; interiorobject_TABLE,                       11, 12 },
  DEFB $01,$05,$09        ; interiorobject_SMALL_TUNNEL_ENTRANCE,        5,  9 },

; Room 3: Hut 2, far side.
roomdef_3_hut2_right:
  DEFB $00                ; 0
  DEFB $03                ; 3 // count of boundaries
  DEFB $36,$44,$17,$22    ; 54, 68, 23, 34 }, // boundary
  DEFB $36,$44,$27,$32    ; 54, 68, 39, 50 }, // boundary
  DEFB $36,$44,$37,$44    ; 54, 68, 55, 68 }, // boundary
  DEFB $04                ; 4 // count of mask bytes
  DEFB $00,$01,$03,$0A    ; [0, 1, 3, 10] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $08,$08,$00        ; interiorobject_WIDE_WINDOW,                  8,  0 },
  DEFB $08,$02,$03        ; interiorobject_WIDE_WINDOW,                  2,  3 },
roomdef_3_hut2_right_bed_A:
  DEFB $17,$0A,$05        ; interiorobject_OCCUPIED_BED,                10,  5 },
roomdef_3_hut2_right_bed_B:
  DEFB $17,$06,$07        ; interiorobject_OCCUPIED_BED,                 6,  7 },
roomdef_3_hut2_right_bed_C:
  DEFB $17,$02,$09        ; interiorobject_OCCUPIED_BED,                 2,  9 },
  DEFB $0B,$10,$05        ; interiorobject_CHEST_OF_DRAWERS,            16,  5 },
  DEFB $0F,$0F,$08        ; interiorobject_DOOR_FRAME_SW_NE,            15,  8 },
  DEFB $0A,$12,$05        ; interiorobject_SHORT_WARDROBE,              18,  5 },
  DEFB $10,$07,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             7, 10 },

; Room 4: Hut 3, near side.
roomdef_4_hut3_left:
  DEFB $01                ; 1
  DEFB $02                ; 2 // count of boundaries
  DEFB $18,$28,$18,$2A    ; 24, 40, 24, 42 }, // boundary
  DEFB $30,$40,$2B,$38    ; 48, 64, 43, 56 }, // boundary
  DEFB $03                ; 3 // count of mask bytes
  DEFB $12,$14,$08        ; [18, 20, 8] // data mask bytes
  DEFB $09                ; 9 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $28,$10,$05        ; interiorobject_END_DOOR_FRAME_NW_SE,        16,  5 },
  DEFB $08,$06,$02        ; interiorobject_WIDE_WINDOW,                  6,  2 },
  DEFB $1E,$04,$05        ; interiorobject_STOVE_PIPE,                   4,  5 },
  DEFB $09,$08,$07        ; interiorobject_EMPTY_BED,                    8,  7 },
  DEFB $10,$07,$09        ; interiorobject_DOOR_FRAME_NW_SE,             7,  9 },
  DEFB $16,$0B,$0B        ; interiorobject_CHAIR_FACING_SE,             11, 11 },
  DEFB $19,$0D,$0A        ; interiorobject_CHAIR_FACING_SW,             13, 10 },
  DEFB $1F,$0E,$0E        ; interiorobject_STUFF,                       14, 14 },

; Room 5: Hut 3, far side.
roomdef_5_hut3_right:
  DEFB $00                ; 0
  DEFB $03                ; 3 // count of boundaries
  DEFB $36,$44,$17,$22    ; 54, 68, 23, 34 }, // boundary
  DEFB $36,$44,$27,$32    ; 54, 68, 39, 50 }, // boundary
  DEFB $36,$44,$37,$44    ; 54, 68, 55, 68 }, // boundary
  DEFB $04                ; 4 // count of mask bytes
  DEFB $00,$01,$03,$0A    ; [0, 1, 3, 10] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $08,$08,$00        ; interiorobject_WIDE_WINDOW,                  8,  0 },
  DEFB $08,$02,$03        ; interiorobject_WIDE_WINDOW,                  2,  3 },
roomdef_5_hut2_right_bed_D:
  DEFB $17,$0A,$05        ; interiorobject_OCCUPIED_BED,                10,  5 },
roomdef_5_hut2_right_bed_E:
  DEFB $17,$06,$07        ; interiorobject_OCCUPIED_BED,                 6,  7 },
roomdef_5_hut2_right_bed_F:
  DEFB $17,$02,$09        ; interiorobject_OCCUPIED_BED,                 2,  9 },
  DEFB $0F,$0F,$08        ; interiorobject_DOOR_FRAME_SW_NE,            15,  8 },
  DEFB $0B,$10,$05        ; interiorobject_CHEST_OF_DRAWERS,            16,  5 },
  DEFB $0B,$14,$07        ; interiorobject_CHEST_OF_DRAWERS,            20,  7 },
  DEFB $10,$07,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             7, 10 },

; Room 8: Corridor.
roomdef_8_corridor:
  DEFB $02                ; 2
  DEFB $00                ; 0 // count of boundaries
  DEFB $01                ; 1 // count of mask bytes
  DEFB $09                ; [9] // data mask bytes
  DEFB $05                ; 5 // count of objects
  DEFB $2E,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_B,         3,  6 },
  DEFB $26,$0A,$03        ; interiorobject_END_DOOR_FRAME_SW_NE,        10,  3 },
  DEFB $26,$04,$06        ; interiorobject_END_DOOR_FRAME_SW_NE,         4,  6 },
  DEFB $10,$05,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             5, 10 },
  DEFB $0A,$12,$06        ; interiorobject_SHORT_WARDROBE,              18,  6 },

; Room 9: Room with crate.
roomdef_9_crate:
  DEFB $01                ; 1
  DEFB $01                ; 1 // count of boundaries
  DEFB $3A,$40,$1C,$2A    ; 58, 64, 28, 42 }, // boundary
  DEFB $02                ; 2 // count of mask bytes
  DEFB $04,$15            ; [4, 21] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $23,$06,$03        ; interiorobject_SMALL_WINDOW,                 6,  3 },
  DEFB $21,$09,$04        ; interiorobject_SMALL_SHELF,                  9,  4 },
  DEFB $24,$0C,$06        ; interiorobject_TINY_DOOR_FRAME_NW_SE,       12,  6 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },
  DEFB $20,$10,$06        ; interiorobject_TALL_WARDROBE,               16,  6 },
  DEFB $0A,$12,$08        ; interiorobject_SHORT_WARDROBE,              18,  8 },
  DEFB $1A,$03,$06        ; interiorobject_CUPBOARD,                     3,  6 },
  DEFB $22,$06,$08        ; interiorobject_SMALL_CRATE,                  6,  8 },
  DEFB $22,$04,$09        ; interiorobject_SMALL_CRATE,                  4,  9 },

; Room 10: Room with lockpick.
roomdef_10_lockpick:
  DEFB $04                ; 4
  DEFB $02                ; 2 // count of boundaries
  DEFB $45,$4B,$20,$36    ; 69, 75, 32, 54 }, // boundary
  DEFB $24,$2F,$30,$3C    ; 36, 47, 48, 60 }, // boundary
  DEFB $03                ; 3 // count of mask bytes
  DEFB $06,$0E,$16        ; [6, 14, 22] // data mask bytes
  DEFB $0E                ; 14 // count of objects
  DEFB $2F,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_B,         1,  4 },
  DEFB $0F,$0F,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            15, 10 },
  DEFB $23,$04,$01        ; interiorobject_SMALL_WINDOW,                 4,  1 },
  DEFB $35,$02,$03        ; interiorobject_KEY_RACK,                     2,  3 },
  DEFB $35,$07,$02        ; interiorobject_KEY_RACK,                     7,  2 },
  DEFB $20,$0A,$02        ; interiorobject_TALL_WARDROBE,               10,  2 },
  DEFB $2A,$0D,$03        ; interiorobject_CUPBOARD_42,                 13,  3 },
  DEFB $2A,$0F,$04        ; interiorobject_CUPBOARD_42,                 15,  4 },
  DEFB $2A,$11,$05        ; interiorobject_CUPBOARD_42,                 17,  5 },
  DEFB $1D,$0E,$08        ; interiorobject_TABLE,                       14,  8 },
  DEFB $0B,$12,$08        ; interiorobject_CHEST_OF_DRAWERS,            18,  8 },
  DEFB $0B,$14,$09        ; interiorobject_CHEST_OF_DRAWERS,            20,  9 },
  DEFB $22,$06,$05        ; interiorobject_SMALL_CRATE,                  6,  5 },
  DEFB $1D,$02,$06        ; interiorobject_TABLE,                        2,  6 },

; Room 11: Room with papers.
roomdef_11_papers:
  DEFB $04                ; 4
  DEFB $01                ; 1 // count of boundaries
  DEFB $1B,$2C,$24,$30    ; 27, 44, 36, 48 }, // boundary
  DEFB $01                ; 1 // count of mask bytes
  DEFB $17                ; [23] // data mask bytes
  DEFB $09                ; 9 // count of objects
  DEFB $2F,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_B,         1,  4 },
  DEFB $21,$06,$03        ; interiorobject_SMALL_SHELF,                  6,  3 },
  DEFB $20,$0C,$03        ; interiorobject_TALL_WARDROBE,               12,  3 },
  DEFB $32,$0A,$03        ; interiorobject_TALL_DRAWERS,                10,  3 },
  DEFB $0A,$0E,$05        ; interiorobject_SHORT_WARDROBE,              14,  5 },
  DEFB $26,$02,$02        ; interiorobject_END_DOOR_FRAME_SW_NE,         2,  2 },
  DEFB $32,$12,$07        ; interiorobject_TALL_DRAWERS,                18,  7 },
  DEFB $32,$14,$08        ; interiorobject_TALL_DRAWERS,                20,  8 },
  DEFB $33,$0C,$0A        ; interiorobject_DESK,                        12, 10 },

; Room 12: Corridor.
roomdef_12_corridor:
  DEFB $01                ; 1
  DEFB $00                ; 0 // count of boundaries
  DEFB $02                ; 2 // count of mask bytes
  DEFB $04,$07            ; [4, 7] // data mask bytes
  DEFB $04                ; 4 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $23,$06,$03        ; interiorobject_SMALL_WINDOW,                 6,  3 },
  DEFB $10,$09,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             9, 10 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },

; Room 13: Corridor.
roomdef_13_corridor:
  DEFB $01                ; 1
  DEFB $00                ; 0 // count of boundaries
  DEFB $02                ; 2 // count of mask bytes
  DEFB $04,$08            ; [4, 8] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $26,$06,$03        ; interiorobject_END_DOOR_FRAME_SW_NE,         6,  3 },
  DEFB $10,$07,$09        ; interiorobject_DOOR_FRAME_NW_SE,             7,  9 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },
  DEFB $32,$0C,$05        ; interiorobject_TALL_DRAWERS,                12,  5 },
  DEFB $0B,$0E,$07        ; interiorobject_CHEST_OF_DRAWERS,            14,  7 },

; Room 14: Room with torch.
roomdef_14_torch:
  DEFB $00                ; 0
  DEFB $03                ; 3 // count of boundaries
  DEFB $36,$44,$16,$20    ; 54, 68, 22, 32 }, // boundary
  DEFB $3E,$44,$30,$3A    ; 62, 68, 48, 58 }, // boundary
  DEFB $36,$44,$36,$44    ; 54, 68, 54, 68 }, // boundary
  DEFB $01                ; 1 // count of mask bytes
  DEFB $01                ; [1] // data mask bytes
  DEFB $09                ; 9 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $26,$04,$03        ; interiorobject_END_DOOR_FRAME_SW_NE,         4,  3 },
  DEFB $31,$08,$05        ; interiorobject_TINY_DRAWERS,                 8,  5 },
  DEFB $09,$0A,$05        ; interiorobject_EMPTY_BED,                   10,  5 },
  DEFB $0B,$10,$05        ; interiorobject_CHEST_OF_DRAWERS,            16,  5 },
  DEFB $0A,$12,$05        ; interiorobject_SHORT_WARDROBE,              18,  5 },
  DEFB $28,$14,$04        ; interiorobject_END_DOOR_FRAME_NW_SE,        20,  4 },
  DEFB $21,$02,$07        ; interiorobject_SMALL_SHELF,                  2,  7 },
  DEFB $09,$02,$09        ; interiorobject_EMPTY_BED,                    2,  9 },

; Room 15: Room with uniform.
roomdef_15_uniform:
  DEFB $00                ; 0
  DEFB $04                ; 4 // count of boundaries
  DEFB $36,$44,$16,$20    ; 54, 68, 22, 32 }, // boundary
  DEFB $36,$44,$36,$44    ; 54, 68, 54, 68 }, // boundary
  DEFB $3E,$44,$28,$3A    ; 62, 68, 40, 58 }, // boundary
  DEFB $1E,$28,$38,$43    ; 30, 40, 56, 67 }, // boundary
  DEFB $04                ; 4 // count of mask bytes
  DEFB $01,$05,$0A,$0F    ; [1, 5, 10, 15] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $0A,$10,$04        ; interiorobject_SHORT_WARDROBE,              16,  4 },
  DEFB $09,$0A,$05        ; interiorobject_EMPTY_BED,                   10,  5 },
  DEFB $31,$08,$05        ; interiorobject_TINY_DRAWERS,                 8,  5 },
  DEFB $31,$06,$06        ; interiorobject_TINY_DRAWERS,                 6,  6 },
  DEFB $21,$02,$07        ; interiorobject_SMALL_SHELF,                  2,  7 },
  DEFB $09,$02,$09        ; interiorobject_EMPTY_BED,                    2,  9 },
  DEFB $10,$07,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             7, 10 },
  DEFB $0F,$0D,$09        ; interiorobject_DOOR_FRAME_SW_NE,            13,  9 },
  DEFB $1D,$12,$08        ; interiorobject_TABLE,                       18,  8 },

; Room 16: Corridor.
roomdef_16_corridor:
  DEFB $01                ; 1
  DEFB $00                ; 0 // count of boundaries
  DEFB $02                ; 2 // count of mask bytes
  DEFB $04,$07            ; [4, 7] // data mask bytes
  DEFB $04                ; 4 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $26,$04,$04        ; interiorobject_END_DOOR_FRAME_SW_NE,         4,  4 },
  DEFB $10,$09,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             9, 10 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },

; Room 7: Corridor.
roomdef_7_corridor:
  DEFB $01                ; 1
  DEFB $00                ; 0 // count of boundaries
  DEFB $01                ; 1 // count of mask bytes
  DEFB $04                ; [4] // data mask bytes
  DEFB $04                ; 4 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $26,$04,$04        ; interiorobject_END_DOOR_FRAME_SW_NE,         4,  4 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },
  DEFB $20,$0C,$04        ; interiorobject_TALL_WARDROBE,               12,  4 },

; Room 18: Room with radio.
roomdef_18_radio:
  DEFB $04                ; 4
  DEFB $03                ; 3 // count of boundaries
  DEFB $26,$38,$30,$3C    ; 38, 56, 48, 60 }, // boundary
  DEFB $26,$2E,$27,$3C    ; 38, 46, 39, 60 }, // boundary
  DEFB $16,$20,$30,$3C    ; 22, 32, 48, 60 }, // boundary
  DEFB $05                ; 5 // count of mask bytes
  DEFB $0B,$11,$10,$18,$19 ; [11, 17, 16, 24, 25] // data mask bytes
  DEFB $0A                ; 10 // count of objects
  DEFB $2F,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_B,         1,  4 },
  DEFB $1A,$01,$04        ; interiorobject_CUPBOARD,                     1,  4 },
  DEFB $23,$04,$01        ; interiorobject_SMALL_WINDOW,                 4,  1 },
  DEFB $21,$07,$02        ; interiorobject_SMALL_SHELF,                  7,  2 },
  DEFB $28,$0A,$01        ; interiorobject_END_DOOR_FRAME_NW_SE,        10,  1 },
  DEFB $1D,$0C,$07        ; interiorobject_TABLE,                       12,  7 },
  DEFB $2D,$0C,$09        ; interiorobject_MESS_BENCH_SHORT,            12,  9 },
  DEFB $1D,$12,$0A        ; interiorobject_TABLE,                       18, 10 },
  DEFB $30,$10,$0C        ; interiorobject_TINY_TABLE,                  16, 12 },
  DEFB $10,$05,$07        ; interiorobject_DOOR_FRAME_NW_SE,             5,  7 },

; Room 19: Room with food.
roomdef_19_food:
  DEFB $01                ; 1
  DEFB $01                ; 1 // count of boundaries
  DEFB $34,$40,$2F,$38    ; 52, 64, 47, 56 }, // boundary
  DEFB $01                ; 1 // count of mask bytes
  DEFB $07                ; [7] // data mask bytes
  DEFB $0B                ; 11 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $23,$06,$03        ; interiorobject_SMALL_WINDOW,                 6,  3 },
  DEFB $1A,$09,$03        ; interiorobject_CUPBOARD,                     9,  3 },
  DEFB $2A,$0C,$03        ; interiorobject_CUPBOARD_42,                 12,  3 },
  DEFB $2A,$0E,$04        ; interiorobject_CUPBOARD_42,                 14,  4 },
  DEFB $1D,$09,$06        ; interiorobject_TABLE,                        9,  6 },
  DEFB $21,$03,$05        ; interiorobject_SMALL_SHELF,                  3,  5 },
  DEFB $34,$03,$07        ; interiorobject_SINK,                         3,  7 },
  DEFB $0B,$0E,$07        ; interiorobject_CHEST_OF_DRAWERS,            14,  7 },
  DEFB $28,$10,$05        ; interiorobject_END_DOOR_FRAME_NW_SE,        16,  5 },
  DEFB $10,$09,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             9, 10 },

; Room 20: Room with red cross parcel.
roomdef_20_redcross:
  DEFB $01                ; 1
  DEFB $02                ; 2 // count of boundaries
  DEFB $3A,$40,$1A,$2A    ; 58, 64, 26, 42 }, // boundary
  DEFB $32,$40,$2E,$36    ; 50, 64, 46, 54 }, // boundary
  DEFB $02                ; 2 // count of mask bytes
  DEFB $15,$04            ; [21, 4] // data mask bytes
  DEFB $0B                ; 11 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $0F,$0D,$0A        ; interiorobject_DOOR_FRAME_SW_NE,            13, 10 },
  DEFB $21,$09,$04        ; interiorobject_SMALL_SHELF,                  9,  4 },
  DEFB $1A,$03,$06        ; interiorobject_CUPBOARD,                     3,  6 },
  DEFB $22,$06,$08        ; interiorobject_SMALL_CRATE,                  6,  8 },
  DEFB $22,$04,$09        ; interiorobject_SMALL_CRATE,                  4,  9 },
  DEFB $1D,$09,$06        ; interiorobject_TABLE,                        9,  6 },
  DEFB $20,$0E,$05        ; interiorobject_TALL_WARDROBE,               14,  5 },
  DEFB $20,$10,$06        ; interiorobject_TALL_WARDROBE,               16,  6 },
  DEFB $18,$12,$08        ; interiorobject_ORNATE_WARDROBE_FACING_SW,   18,  8 },
  DEFB $30,$0B,$08        ; interiorobject_TINY_TABLE,                  11,  8 },

; Room 22: Room with red key.
roomdef_22_red_key:
  DEFB $03                ; 3
  DEFB $02                ; 2 // count of boundaries
  DEFB $36,$40,$2E,$38    ; 54, 64, 46, 56 }, // boundary
  DEFB $3A,$40,$24,$2C    ; 58, 64, 36, 44 }, // boundary
  DEFB $02                ; 2 // count of mask bytes
  DEFB $0C,$15            ; [12, 21] // data mask bytes
  DEFB $07                ; 7 // count of objects
  DEFB $29,$05,$06        ; interiorobject_ROOM_OUTLINE_15x8,            5,  6 },
  DEFB $25,$04,$04        ; interiorobject_NOTICEBOARD,                  4,  4 },
  DEFB $21,$09,$04        ; interiorobject_SMALL_SHELF,                  9,  4 },
  DEFB $22,$06,$08        ; interiorobject_SMALL_CRATE,                  6,  8 },
  DEFB $10,$09,$08        ; interiorobject_DOOR_FRAME_NW_SE,             9,  8 },
  DEFB $1D,$09,$06        ; interiorobject_TABLE,                        9,  6 },
  DEFB $28,$0E,$04        ; interiorobject_END_DOOR_FRAME_NW_SE,        14,  4 },

; Room 23: Breakfast room.
roomdef_23_breakfast:
  DEFB $00                ; 0
  DEFB $01                ; 1 // count of boundaries
  DEFB $36,$44,$22,$44    ; 54, 68, 34, 68 }, // boundary
  DEFB $02                ; 2 // count of mask bytes
  DEFB $0A,$03            ; [10, 3] // data mask bytes
  DEFB $0C                ; 12 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $23,$08,$00        ; interiorobject_SMALL_WINDOW,                 8,  0 },
  DEFB $23,$02,$03        ; interiorobject_SMALL_WINDOW,                 2,  3 },
  DEFB $10,$07,$0A        ; interiorobject_DOOR_FRAME_NW_SE,             7, 10 },
  DEFB $2C,$05,$04        ; interiorobject_MESS_TABLE,                   5,  4 },
  DEFB $2A,$12,$04        ; interiorobject_CUPBOARD_42,                 18,  4 },
  DEFB $28,$14,$04        ; interiorobject_END_DOOR_FRAME_NW_SE,        20,  4 },
  DEFB $0F,$0F,$08        ; interiorobject_DOOR_FRAME_SW_NE,            15,  8 },
  DEFB $2B,$07,$06        ; interiorobject_MESS_BENCH,                   7,  6 },
roomdef_23_breakfast_bench_A:
  DEFB $0D,$0C,$05        ; interiorobject_EMPTY_BENCH,                 12,  5 },
roomdef_23_breakfast_bench_B:
  DEFB $0D,$0A,$06        ; interiorobject_EMPTY_BENCH,                 10,  6 },
roomdef_23_breakfast_bench_C:
  DEFB $0D,$08,$07        ; interiorobject_EMPTY_BENCH,                  8,  7 },

; Room 24: Solitary confinement cell.
roomdef_24_solitary:
  DEFB $03                ; 3
  DEFB $01                ; 1 // count of boundaries
  DEFB $30,$36,$26,$2E    ; 48, 54, 38, 46 }, // boundary
  DEFB $01                ; 1 // count of mask bytes
  DEFB $1A                ; [26] // data mask bytes
  DEFB $03                ; 3 // count of objects
  DEFB $29,$05,$06        ; interiorobject_ROOM_OUTLINE_15x8,            5,  6 },
  DEFB $28,$0E,$04        ; interiorobject_END_DOOR_FRAME_NW_SE,        14,  4 },
  DEFB $30,$0A,$09        ; interiorobject_TINY_TABLE,                  10,  9 },

; Room 25: Breakfast room.
roomdef_25_breakfast:
  DEFB $00                ; 0
  DEFB $01                ; 1 // count of boundaries
  DEFB $36,$44,$22,$44    ; 54, 68, 34, 68 }, // boundary
  DEFB $00                ; 0 // count of mask bytes
  DEFB $0B                ; 11 // count of objects
  DEFB $02,$01,$04        ; interiorobject_ROOM_OUTLINE_22x12_A,         1,  4 },
  DEFB $23,$08,$00        ; interiorobject_SMALL_WINDOW,                 8,  0 },
  DEFB $1A,$05,$03        ; interiorobject_CUPBOARD,                     5,  3 },
  DEFB $23,$02,$03        ; interiorobject_SMALL_WINDOW,                 2,  3 },
  DEFB $28,$12,$03        ; interiorobject_END_DOOR_FRAME_NW_SE,        18,  3 },
  DEFB $2C,$05,$04        ; interiorobject_MESS_TABLE,                   5,  4 },
  DEFB $2B,$07,$06        ; interiorobject_MESS_BENCH,                   7,  6 },
roomdef_25_breakfast_bench_D:
  DEFB $0D,$0C,$05        ; interiorobject_EMPTY_BENCH,                 12,  5 },
roomdef_25_breakfast_bench_E:
  DEFB $0D,$0A,$06        ; interiorobject_EMPTY_BENCH,                 10,  6 },
roomdef_25_breakfast_bench_F:
  DEFB $0D,$08,$07        ; interiorobject_EMPTY_BENCH,                  8,  7 },
roomdef_25_breakfast_bench_G:
  DEFB $0D,$0E,$04        ; interiorobject_EMPTY_BENCH,                 14,  4 },

; Room 28: Hut 1, near side.
roomdef_28_hut1_left:
  DEFB $01                ; 1
  DEFB $02                ; 2 // count of boundaries
  DEFB $1C,$28,$1C,$34    ; 28, 40, 28, 52 }, // boundary
  DEFB $30,$3F,$2C,$38    ; 48, 63, 44, 56 }, // boundary
  DEFB $03                ; 3 // count of mask bytes
  DEFB $08,$0D,$13        ; [8, 13, 19] // data mask bytes
  DEFB $08                ; 8 // count of objects
  DEFB $1B,$03,$06        ; interiorobject_ROOM_OUTLINE_18x10_A,         3,  6 },
  DEFB $08,$06,$02        ; interiorobject_WIDE_WINDOW,                  6,  2 },
  DEFB $28,$0E,$04        ; interiorobject_END_DOOR_FRAME_NW_SE,        14,  4 },
  DEFB $1A,$03,$06        ; interiorobject_CUPBOARD,                     3,  6 },
  DEFB $17,$08,$07        ; interiorobject_OCCUPIED_BED,                 8,  7 },
  DEFB $10,$07,$09        ; interiorobject_DOOR_FRAME_NW_SE,             7,  9 },
  DEFB $19,$0F,$0A        ; interiorobject_CHAIR_FACING_SW,             15, 10 },
  DEFB $1D,$0B,$0C        ; interiorobject_TABLE,                       11, 12 },

; Room 29: Start of second tunnel.
roomdef_29_second_tunnel_start:
  DEFB $05                ; 5
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $1E,$1F,$20,$21,$22,$23 ; [30, 31, 32, 33, 34, 35] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $00,$14,$00        ; interiorobject_TUNNEL_SW_NE,                20,  0 },
  DEFB $00,$10,$02        ; interiorobject_TUNNEL_SW_NE,                16,  2 },
  DEFB $00,$0C,$04        ; interiorobject_TUNNEL_SW_NE,                12,  4 },
  DEFB $00,$08,$06        ; interiorobject_TUNNEL_SW_NE,                 8,  6 },
  DEFB $00,$04,$08        ; interiorobject_TUNNEL_SW_NE,                 4,  8 },
  DEFB $00,$00,$0A        ; interiorobject_TUNNEL_SW_NE,                 0, 10 },

; Room 31.
roomdef_31:
  DEFB $06                ; 6
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $24,$25,$26,$27,$28,$29 ; [36, 37, 38, 39, 40, 41] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $03,$00,$00        ; interiorobject_TUNNEL_NW_SE,                 0,  0 },
  DEFB $03,$04,$02        ; interiorobject_TUNNEL_NW_SE,                 4,  2 },
  DEFB $03,$08,$04        ; interiorobject_TUNNEL_NW_SE,                 8,  4 },
  DEFB $03,$0C,$06        ; interiorobject_TUNNEL_NW_SE,                12,  6 },
  DEFB $03,$10,$08        ; interiorobject_TUNNEL_NW_SE,                16,  8 },
  DEFB $03,$14,$0A        ; interiorobject_TUNNEL_NW_SE,                20, 10 },

; Room 36.
roomdef_36:
  DEFB $07                ; 7
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $1F,$20,$21,$22,$23,$2D ; [31, 32, 33, 34, 35, 45] // data mask bytes
  DEFB $05                ; 5 // count of objects
  DEFB $00,$14,$00        ; interiorobject_TUNNEL_SW_NE,                20,  0 },
  DEFB $00,$10,$02        ; interiorobject_TUNNEL_SW_NE,                16,  2 },
  DEFB $00,$0C,$04        ; interiorobject_TUNNEL_SW_NE,                12,  4 },
  DEFB $00,$08,$06        ; interiorobject_TUNNEL_SW_NE,                 8,  6 },
  DEFB $0E,$04,$08        ; interiorobject_TUNNEL_14,                    4,  8 },

; Room 32.
roomdef_32:
  DEFB $08                ; 8
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $24,$25,$26,$27,$28,$2A ; [36, 37, 38, 39, 40, 42] // data mask bytes
  DEFB $05                ; 5 // count of objects
  DEFB $03,$00,$00        ; interiorobject_TUNNEL_NW_SE,                 0,  0 },
  DEFB $03,$04,$02        ; interiorobject_TUNNEL_NW_SE,                 4,  2 },
  DEFB $03,$08,$04        ; interiorobject_TUNNEL_NW_SE,                 8,  4 },
  DEFB $03,$0C,$06        ; interiorobject_TUNNEL_NW_SE,                12,  6 },
  DEFB $11,$10,$08        ; interiorobject_TUNNEL_17,                   16,  8 },

; Room 34.
roomdef_34:
  DEFB $06                ; 6
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $24,$25,$26,$27,$28,$2E ; [36, 37, 38, 39, 40, 46] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $03,$00,$00        ; interiorobject_TUNNEL_NW_SE,                 0,  0 },
  DEFB $03,$04,$02        ; interiorobject_TUNNEL_NW_SE,                 4,  2 },
  DEFB $03,$08,$04        ; interiorobject_TUNNEL_NW_SE,                 8,  4 },
  DEFB $03,$0C,$06        ; interiorobject_TUNNEL_NW_SE,                12,  6 },
  DEFB $03,$10,$08        ; interiorobject_TUNNEL_NW_SE,                16,  8 },
  DEFB $12,$14,$0A        ; interiorobject_TUNNEL_JOIN_18,              20, 10 },

; Room 35.
roomdef_35:
  DEFB $06                ; 6
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $24,$25,$26,$27,$28,$29 ; [36, 37, 38, 39, 40, 41] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $03,$00,$00        ; interiorobject_TUNNEL_NW_SE,                 0,  0 },
  DEFB $03,$04,$02        ; interiorobject_TUNNEL_NW_SE,                 4,  2 },
  DEFB $04,$08,$04        ; interiorobject_TUNNEL_T_JOIN_NW_SE,          8,  4 },
  DEFB $03,$0C,$06        ; interiorobject_TUNNEL_NW_SE,                12,  6 },
  DEFB $03,$10,$08        ; interiorobject_TUNNEL_NW_SE,                16,  8 },
  DEFB $03,$14,$0A        ; interiorobject_TUNNEL_NW_SE,                20, 10 },

; Room 30.
roomdef_30:
  DEFB $05                ; 5
  DEFB $00                ; 0 // count of boundaries
  DEFB $07                ; 7 // count of mask bytes
  DEFB $1E,$1F,$20,$21,$22,$23,$2C ; [30, 31, 32, 33, 34, 35, 44] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $00,$14,$00        ; interiorobject_TUNNEL_SW_NE,                20,  0 },
  DEFB $00,$10,$02        ; interiorobject_TUNNEL_SW_NE,                16,  2 },
  DEFB $00,$0C,$04        ; interiorobject_TUNNEL_SW_NE,                12,  4 },
  DEFB $06,$08,$06        ; interiorobject_TUNNEL_CORNER_6,              8,  6 },
  DEFB $00,$04,$08        ; interiorobject_TUNNEL_SW_NE,                 4,  8 },
  DEFB $00,$00,$0A        ; interiorobject_TUNNEL_SW_NE,                 0, 10 },

; Room 40.
roomdef_40:
  DEFB $09                ; 9
  DEFB $00                ; 0 // count of boundaries
  DEFB $06                ; 6 // count of mask bytes
  DEFB $1E,$1F,$20,$21,$22,$2B ; [30, 31, 32, 33, 34, 43] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $07,$14,$00        ; interiorobject_TUNNEL_CORNER_7,             20,  0 },
  DEFB $00,$10,$02        ; interiorobject_TUNNEL_SW_NE,                16,  2 },
  DEFB $00,$0C,$04        ; interiorobject_TUNNEL_SW_NE,                12,  4 },
  DEFB $00,$08,$06        ; interiorobject_TUNNEL_SW_NE,                 8,  6 },
  DEFB $00,$04,$08        ; interiorobject_TUNNEL_SW_NE,                 4,  8 },
  DEFB $00,$00,$0A        ; interiorobject_TUNNEL_SW_NE,                 0, 10 },

; Room 44.
roomdef_44:
  DEFB $08                ; 8
  DEFB $00                ; 0 // count of boundaries
  DEFB $05                ; 5 // count of mask bytes
  DEFB $24,$25,$26,$27,$28 ; [36, 37, 38, 39, 40] // data mask bytes
  DEFB $05                ; 5 // count of objects
  DEFB $03,$00,$00        ; interiorobject_TUNNEL_NW_SE,                 0,  0 },
  DEFB $03,$04,$02        ; interiorobject_TUNNEL_NW_SE,                 4,  2 },
  DEFB $03,$08,$04        ; interiorobject_TUNNEL_NW_SE,                 8,  4 },
  DEFB $03,$0C,$06        ; interiorobject_TUNNEL_NW_SE,                12,  6 },
  DEFB $0C,$10,$08        ; interiorobject_TUNNEL_CORNER_NW_NE,         16,  8 },

; Room 50: Blocked tunnel.
roomdef_50_blocked_tunnel:
  DEFB $05                ; 5
  DEFB $01                ; 1 // count of boundaries
roomdef_50_blocked_tunnel_boundary:
  DEFB $34,$3A,$20,$36    ; 52, 58, 32, 54 }, // boundary
  DEFB $06                ; 6 // count of mask bytes
  DEFB $1E,$1F,$20,$21,$22,$2B ; [30, 31, 32, 33, 34, 43] // data mask bytes
  DEFB $06                ; 6 // count of objects
  DEFB $07,$14,$00        ; interiorobject_TUNNEL_CORNER_7,             20,  0 },
  DEFB $00,$10,$02        ; interiorobject_TUNNEL_SW_NE,                16,  2 },
  DEFB $00,$0C,$04        ; interiorobject_TUNNEL_SW_NE,                12,  4 },
roomdef_50_blocked_tunnel_collapsed_tunnel:
  DEFB $14,$08,$06        ; interiorobject_COLLAPSED_TUNNEL_SW_NE,       8,  6 },
  DEFB $00,$04,$08        ; interiorobject_TUNNEL_SW_NE,                 4,  8 },
  DEFB $00,$00,$0A        ; interiorobject_TUNNEL_SW_NE,                 0, 10 },

; Interior object definitions.
interior_object_defs:
  DEFW interior_object_tile_refs_0  ; Array of pointer to interior object definitions, 54 entries long (== number of interior objects).
  DEFW interior_object_tile_refs_1  ;
  DEFW interior_object_tile_refs_2  ;
  DEFW interior_object_tile_refs_3  ;
  DEFW interior_object_tile_refs_4  ;
  DEFW interior_object_tile_refs_5  ;
  DEFW interior_object_tile_refs_6  ;
  DEFW interior_object_tile_refs_7  ;
  DEFW interior_object_tile_refs_8  ;
  DEFW interior_object_tile_refs_9  ;
  DEFW interior_object_tile_refs_10 ;
  DEFW interior_object_tile_refs_11 ;
  DEFW interior_object_tile_refs_12 ;
  DEFW interior_object_tile_refs_13 ;
  DEFW interior_object_tile_refs_14 ;
  DEFW interior_object_tile_refs_15 ;
  DEFW interior_object_tile_refs_16 ;
  DEFW interior_object_tile_refs_17 ;
  DEFW interior_object_tile_refs_18 ;
  DEFW interior_object_tile_refs_19 ;
  DEFW interior_object_tile_refs_20 ;
  DEFW interior_object_tile_refs_2  ;
  DEFW interior_object_tile_refs_22 ;
  DEFW interior_object_tile_refs_23 ;
  DEFW interior_object_tile_refs_24 ;
  DEFW interior_object_tile_refs_25 ;
  DEFW interior_object_tile_refs_26 ;
  DEFW interior_object_tile_refs_27 ;
  DEFW interior_object_tile_refs_29 ;
  DEFW interior_object_tile_refs_29 ;
  DEFW interior_object_tile_refs_30 ;
  DEFW interior_object_tile_refs_31 ;
  DEFW interior_object_tile_refs_32 ;
  DEFW interior_object_tile_refs_33 ;
  DEFW interior_object_tile_refs_34 ;
  DEFW interior_object_tile_refs_35 ;
  DEFW interior_object_tile_refs_36 ;
  DEFW interior_object_tile_refs_37 ;
  DEFW interior_object_tile_refs_38 ;
  DEFW interior_object_tile_refs_40 ;
  DEFW interior_object_tile_refs_40 ;
  DEFW interior_object_tile_refs_41 ;
  DEFW interior_object_tile_refs_42 ;
  DEFW interior_object_tile_refs_43 ;
  DEFW interior_object_tile_refs_44 ;
  DEFW interior_object_tile_refs_45 ;
  DEFW interior_object_tile_refs_46 ;
  DEFW interior_object_tile_refs_47 ;
  DEFW interior_object_tile_refs_48 ;
  DEFW interior_object_tile_refs_49 ;
  DEFW interior_object_tile_refs_50 ;
  DEFW interior_object_tile_refs_51 ;
  DEFW interior_object_tile_refs_52 ;
  DEFW interior_object_tile_refs_53 ;

; Room object 0: Straight tunnel section SW-NE
interior_object_tile_refs_0:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$00,$02    ; tile references
  DEFB $03,$02,$04,$05    ;
  DEFB $08,$0F,$09,$0A    ;
  DEFB $06,$07,$0E,$0C    ;
  DEFB $0E,$0B,$0D,$00    ;
  DEFB $0D,$00,$00,$00    ;

; Room object 1: Small tunnel entrance
interior_object_tile_refs_1:
  DEFB $02                ; width
  DEFB $02                ; height
  DEFB $B6,$00            ; tile references
  DEFB $B7,$B5            ;

; Room object 3: Straight tunnel section NW-SE
interior_object_tile_refs_3:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $02,$00,$00,$00    ; tile references
  DEFB $11,$12,$02,$00    ;
  DEFB $15,$16,$17,$08    ;
  DEFB $18,$0E,$07,$19    ;
  DEFB $00,$13,$1A,$0E    ;
  DEFB $00,$00,$00,$13    ;

; Room object 4: Tunnel T-join section NW-SE
interior_object_tile_refs_4:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $02,$00,$00,$00    ; tile references
  DEFB $11,$12,$04,$05    ;
  DEFB $15,$16,$09,$0A    ;
  DEFB $18,$0E,$07,$0C    ;
  DEFB $00,$13,$1A,$0E    ;
  DEFB $00,$00,$00,$13    ;

; Room object 5: Prisoner sat mid table
interior_object_tile_refs_5:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $FF,$46,$B8        ; tile references (incl. RLE)

; Room object 6: Tunnel T-join section SW-NE
interior_object_tile_refs_6:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$03,$02    ; tile references
  DEFB $00,$02,$04,$05    ;
  DEFB $08,$0F,$09,$0A    ;
  DEFB $11,$12,$0E,$0C    ;
  DEFB $15,$16,$0D,$00    ;
  DEFB $18,$0E,$00,$00    ;

; Room object 7: Tunnel corner section SW-SE
interior_object_tile_refs_7:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$02,$17    ; tile references
  DEFB $00,$08,$0F,$02    ;
  DEFB $08,$0F,$18,$08    ;
  DEFB $11,$12,$07,$16    ;
  DEFB $15,$16,$0D,$00    ;
  DEFB $18,$0E,$00,$00    ;

; Room object 12: Tunnel corner section NW-NE
interior_object_tile_refs_12:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $02,$00,$00,$00,$11,$12,$04,$05 ; tile references (incl. RLE)
  DEFB $15,$16,$09,$0A,$18,$0E,$07,$0C ;
  DEFB $00,$13,$0D,$FF,$85,$00         ;

; Room object 13: Empty bench
interior_object_tile_refs_13:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $FF,$86,$00        ; tile references (incl. RLE)

; Room object 14: Tunnel corner section NE-SE
interior_object_tile_refs_14:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$03,$02,$00,$02,$04,$05 ; tile references (incl. RLE)
  DEFB $08,$0F,$1D,$12,$09,$07,$15,$16 ;
  DEFB $00,$13,$18,$07,$FF,$84,$00     ;

; Room object 17: Tunnel corner section NW-SW
interior_object_tile_refs_17:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $08,$02,$00,$00    ; tile references
  DEFB $11,$12,$08,$00    ;
  DEFB $04,$1C,$17,$0F    ;
  DEFB $09,$0A,$07,$16    ;
  DEFB $07,$0C,$0D,$00    ;
  DEFB $0D,$00,$00,$00    ;

; Room object 18: Tunnel entrance
interior_object_tile_refs_18:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $02,$00,$00,$00    ; tile references
  DEFB $11,$12,$04,$05    ;
  DEFB $04,$1C,$1D,$12    ;
  DEFB $09,$0A,$07,$0C    ;
  DEFB $00,$0C,$0D,$00    ;
  DEFB $00,$00,$00,$00    ;

; Room object 19: Prisoner sat end table
interior_object_tile_refs_19:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $BE,$BF            ; tile references
  DEFB $BA,$C0            ;
  DEFB $BC,$C1            ;

; Room object 20: Collapsed tunnel section SW-NE
interior_object_tile_refs_20:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$00        ; tile references (incl. RLE)
  DEFB $02,$00,$02,$1E,$05,$1B,$22,$22
  DEFB $24,$21,$22,$22,$23,$1F,$20,$0D
  DEFB $00,$0D,$00,$00,$00

; Room object 2: Room outline 22x12 A
interior_object_tile_refs_2:
  DEFB $16                ; width
  DEFB $0C                ; height
  DEFB $FF,$8B,$00,$32,$36,$FF,$92,$00 ; tile references (incl. RLE)
  DEFB $32,$25,$34,$37,$35,$36,$FF,$8E ;
  DEFB $00,$32,$25,$34,$FF,$84,$00,$37 ;
  DEFB $35,$36,$FF,$8A,$00,$32,$25,$34 ;
  DEFB $FF,$88,$00,$37,$35,$36,$FF,$86 ;
  DEFB $00,$32,$25,$34,$FF,$8C,$00,$37 ;
  DEFB $35,$36,$00,$00,$32,$25,$34,$FF ;
  DEFB $90,$00,$37,$35,$25,$34,$FF,$92 ;
  DEFB $00,$39,$0D,$13,$3A,$FF,$90,$00 ;
  DEFB $39,$0D,$FF,$84,$00,$13,$3A,$FF ;
  DEFB $8C,$00,$39,$0D,$FF,$88,$00,$13 ;
  DEFB $3A,$FF,$88,$00,$39,$0D,$FF,$8C ;
  DEFB $00,$13,$3A,$FF,$84,$00,$39,$0D ;
  DEFB $FF,$90,$00,$13,$3A,$39,$0D,$FF ;
  DEFB $8A,$00                         ;

; Room object 8: Wide window facing SE
interior_object_tile_refs_8:
  DEFB $05                ; width
  DEFB $06                ; height
  DEFB $00,$00,$00,$32,$36 ; tile references
  DEFB $00,$32,$25,$26,$27 ;
  DEFB $25,$26,$2A,$29,$27 ;
  DEFB $28,$29,$2B,$2C,$2D ;
  DEFB $31,$2C,$30,$2F,$00 ;
  DEFB $2E,$2F,$00,$00,$00 ;

; Room object 9: Empty bed facing SE
interior_object_tile_refs_9:
  DEFB $05                ; width
  DEFB $04                ; height
  DEFB $3E,$3F,$40,$00,$00,$FF,$45,$41 ; tile references (incl. RLE)
  DEFB $00,$FF,$44,$46,$00,$00,$00,$4A ;
  DEFB $00                             ;

; Room object 10: Short wardrobe facing SW
interior_object_tile_refs_10:
  DEFB $03                ; width
  DEFB $04                ; height
  DEFB $FF,$46,$51,$54,$57,$56,$58,$59 ; tile references (incl. RLE)
  DEFB $5A                             ;

; Room object 11: Chest of drawers facing SW
interior_object_tile_refs_11:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $FF,$46,$4B        ; tile references (incl. RLE)

; Room object 15: Door frame SE
interior_object_tile_refs_15:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$32,$36    ; tile references
  DEFB $32,$25,$34,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$01,$3B    ;
  DEFB $3C,$01,$01,$00    ;

; Room object 16: Door frame SW
interior_object_tile_refs_16:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $32,$36,$00,$00    ; tile references
  DEFB $38,$37,$35,$36    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $33,$01,$00,$27    ;
  DEFB $00,$01,$01,$3D    ;

; Room object 22: Chair facing SE
interior_object_tile_refs_22:
  DEFB $02                ; width
  DEFB $04                ; height
  DEFB $67,$00            ; tile references
  DEFB $68,$36            ;
  DEFB $69,$6B            ;
  DEFB $6A,$00            ;

; Room object 23: Occupied bed
interior_object_tile_refs_23:
  DEFB $05                ; width
  DEFB $04                ; height
  DEFB $3E,$70,$6C,$00,$00 ; tile references
  DEFB $41,$42,$6D,$6E,$45 ;
  DEFB $00,$46,$47,$6F,$49 ;
  DEFB $00,$00,$00,$4A,$00 ;

; Room object 24: Ornate wardrobe facing SW
interior_object_tile_refs_24:
  DEFB $03                ; width
  DEFB $04                ; height
  DEFB $51,$52,$53        ; tile references
  DEFB $71,$72,$56        ;
  DEFB $54,$57,$56        ;
  DEFB $58,$59,$5A        ;

; Room object 25: Chair facing SW
interior_object_tile_refs_25:
  DEFB $02                ; width
  DEFB $04                ; height
  DEFB $00,$73,$5C,$FF,$44,$74,$00 ; tile references (incl. RLE)

; Room object 26: Cupboard facing SE
interior_object_tile_refs_26:
  DEFB $03                ; width
  DEFB $03                ; height
  DEFB $5C,$FF,$48,$78    ; tile references (incl. RLE)

; Room object 29: Table
interior_object_tile_refs_29:
  DEFB $04                ; width
  DEFB $03                ; height
  DEFB $FF,$48,$5C,$4A,$38,$00,$00 ; tile references (incl. RLE)

; Room object 30: Stove pipe
interior_object_tile_refs_30:
  DEFB $03                ; width
  DEFB $04                ; height
  DEFB $80,$81,$00,$00,$82,$00,$00,$82 ; tile references (incl. RLE)
  DEFB $00,$00,$80,$00                 ;

; Room object 31: Papers on floor
interior_object_tile_refs_31:
  DEFB $01                ; width
  DEFB $01                ; height
  DEFB $83                ; tile references

; Room object 32: Tall wardrobe facing SW
interior_object_tile_refs_32:
  DEFB $03                ; width
  DEFB $05                ; height
  DEFB $FF,$46,$51,$54,$57,$56,$54,$57 ; tile references (incl. RLE)
  DEFB $56,$58,$59,$5A                 ;

; Room object 33: Small shelf facing SE
interior_object_tile_refs_33:
  DEFB $02                ; width
  DEFB $02                ; height
  DEFB $FF,$44,$88        ; tile references (incl. RLE)

; Room object 34: Small crate
interior_object_tile_refs_34:
  DEFB $02                ; width
  DEFB $02                ; height
  DEFB $FF,$44,$8C        ; tile references (incl. RLE)

; Room object 35: Small window with bars facing SE
interior_object_tile_refs_35:
  DEFB $03                ; width
  DEFB $05                ; height
  DEFB $00,$32,$36,$25,$84,$27,$85,$86 ; tile references (incl. RLE)
  DEFB $27,$85,$87,$2D,$2E,$2F,$00     ;

; Room object 36: Tiny door frame NE (tunnel entrance)
interior_object_tile_refs_36:
  DEFB $04                ; width
  DEFB $03                ; height
  DEFB $32,$36,$00,$00,$5B,$37,$35,$36 ; tile references (incl. RLE)
  DEFB $00,$01,$01,$27                 ;

; Room object 37: Noticeboard facing SE
interior_object_tile_refs_37:
  DEFB $04                ; width
  DEFB $04                ; height
  DEFB $00,$00,$32,$36,$32,$25,$34,$27 ; tile references (incl. RLE)
  DEFB $38,$90,$90,$27,$38,$25,$34,$00 ;

; Room object 38: Door frame NW
interior_object_tile_refs_38:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $00,$00,$32,$36    ; tile references
  DEFB $32,$25,$34,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$01,$91    ;
  DEFB $38,$01,$01,$00    ;

; Room object 40: Door frame NE
interior_object_tile_refs_40:
  DEFB $04                ; width
  DEFB $06                ; height
  DEFB $32,$36,$00,$00    ; tile references
  DEFB $38,$37,$35,$36    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $38,$00,$00,$27    ;
  DEFB $5B,$01,$00,$27    ;
  DEFB $00,$01,$01,$27    ;

; Room object 41: Room outline 15x8
interior_object_tile_refs_41:
  DEFB $0E                ; width
  DEFB $08                ; height
  DEFB $FF,$85,$00,$32,$36,$FF,$8A,$00 ; tile references (incl. RLE)
  DEFB $32,$25,$34,$37,$35,$36,$FF,$86 ;
  DEFB $00,$32,$25,$34,$FF,$84,$00,$37 ;
  DEFB $35,$36,$00,$00,$00,$25,$34,$FF ;
  DEFB $88,$00,$37,$35,$36,$00,$13,$3A ;
  DEFB $FF,$8A,$00,$37,$35,$00,$00,$13 ;
  DEFB $3A,$FF,$88,$00,$39,$0D,$FF,$84 ;
  DEFB $00,$13,$3A,$FF,$84,$00,$39,$0D ;
  DEFB $FF,$88,$00,$13,$3A,$39,$0D,$FF ;
  DEFB $84,$00                         ;

; Room object 42: Cupboard facing SW
interior_object_tile_refs_42:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $51,$52            ; tile references
  DEFB $54,$55            ;
  DEFB $58,$59            ;

; Room object 43: Mess bench
interior_object_tile_refs_43:
  DEFB $09                ; width
  DEFB $05                ; height
  DEFB $FF,$86,$00,$5C,$94,$99,$FF,$84 ; tile references (incl. RLE)
  DEFB $00,$5C,$94,$97,$66,$96,$00,$00 ;
  DEFB $5C,$94,$97,$66,$00,$00,$00,$5C ;
  DEFB $94,$97,$66,$FF,$85,$00,$98,$66 ;
  DEFB $FF,$87,$00                     ;

; Room object 44: Mess table
interior_object_tile_refs_44:
  DEFB $0A                ; width
  DEFB $06                ; height
  DEFB $FF,$86,$00,$FF,$44,$5C,$FF,$84 ; tile references (incl. RLE)
  DEFB $00,$5C,$5D,$64,$65,$62,$63,$00 ;
  DEFB $00,$5C,$5D,$64,$65,$62,$66,$00 ;
  DEFB $00,$5C,$5D,$64,$65,$62,$66,$FF ;
  DEFB $84,$00,$60,$61,$62,$66,$FF,$86 ;
  DEFB $00,$4A,$38,$FF,$88,$00         ;

; Room object 45: Mess bench short
interior_object_tile_refs_45:
  DEFB $05                ; width
  DEFB $03                ; height
  DEFB $00,$00,$5C,$94,$95,$5C,$94,$97 ; tile references (incl. RLE)
  DEFB $66,$96,$98,$66,$00,$00,$00     ;

; Room object 46: Room outline 18x10 B
interior_object_tile_refs_46:
  DEFB $12                ; width
  DEFB $0A                ; height
  DEFB $FF,$8B,$00,$32,$36,$FF,$8E,$00 ; tile references (incl. RLE)
  DEFB $32,$25,$34,$37,$35,$36,$FF,$8A ;
  DEFB $00,$32,$25,$34,$FF,$84,$00,$37 ;
  DEFB $35,$36,$FF,$86,$00,$32,$25,$34 ;
  DEFB $FF,$88,$00,$37,$35,$00,$00,$00 ;
  DEFB $32,$25,$34,$FF,$8A,$00,$39,$0D ;
  DEFB $00,$32,$25,$34,$FF,$8A,$00,$39 ;
  DEFB $0D,$00,$00,$25,$34,$FF,$8A,$00 ;
  DEFB $39,$0D,$FF,$84,$00,$13,$3A,$FF ;
  DEFB $88,$00,$39,$0D,$FF,$88,$00,$13 ;
  DEFB $3A,$FF,$84,$00,$39,$0D,$FF,$8C ;
  DEFB $00,$13,$3A,$39,$0D,$FF,$8A,$00 ;

; Room object 47: Room outline 22x12 B
interior_object_tile_refs_47:
  DEFB $16                ; width
  DEFB $0C                ; height
  DEFB $FF,$87,$00,$32,$36,$FF,$92,$00 ; tile references (incl. RLE)
  DEFB $32,$25,$34,$37,$35,$36,$FF,$8E ;
  DEFB $00,$32,$25,$34,$FF,$84,$00,$37 ;
  DEFB $35,$36,$FF,$8A,$00,$32,$25,$34 ;
  DEFB $FF,$88,$00,$37,$35,$36,$FF,$87 ;
  DEFB $00,$25,$34,$FF,$8C,$00,$37,$35 ;
  DEFB $36,$FF,$85,$00,$13,$3A,$FF,$8E ;
  DEFB $00,$37,$35,$36,$FF,$85,$00,$13 ;
  DEFB $3A,$FF,$8E,$00,$37,$35,$36,$FF ;
  DEFB $85,$00,$13,$3A,$FF,$8E,$00,$37 ;
  DEFB $35,$FF,$86,$00,$13,$3A,$FF,$8C ;
  DEFB $00,$39,$0D,$FF,$88,$00,$13,$3A ;
  DEFB $FF,$88,$00,$39,$0D,$FF,$8C,$00 ;
  DEFB $13,$3A,$FF,$84,$00,$39,$0D,$FF ;
  DEFB $90,$00,$13,$3A,$39,$0D,$FF,$86 ;
  DEFB $00                             ;

; Room object 48: Tiny table
interior_object_tile_refs_48:
  DEFB $02                ; width
  DEFB $02                ; height
  DEFB $5C,$36            ; tile references
  DEFB $98,$93            ;

; Room object 49: Tiny drawers facing SE
interior_object_tile_refs_49:
  DEFB $02                ; width
  DEFB $03                ; height
  DEFB $5C,$9A            ; tile references
  DEFB $7A,$9B            ;
  DEFB $9D,$9C            ;

; Room object 50: Tall drawers facing SW
interior_object_tile_refs_50:
  DEFB $02                ; width
  DEFB $04                ; height
  DEFB $4B,$4C            ; tile references
  DEFB $9E,$4E            ;
  DEFB $9F,$4E            ;
  DEFB $4F,$50            ;

; Room object 51: Desk facing SW
interior_object_tile_refs_51:
  DEFB $06                ; width
  DEFB $04                ; height
  DEFB $5C,$5D,$5E,$A0,$A8,$00 ; tile references
  DEFB $60,$61,$A1,$A2,$A3,$A7 ;
  DEFB $4A,$38,$A4,$A5,$A6,$00 ;
  DEFB $00,$00,$00,$2D,$00,$00 ;

; Room object 52: Sink facing SE
interior_object_tile_refs_52:
  DEFB $03                ; width
  DEFB $03                ; height
  DEFB $A9,$AA,$00,$FF,$46,$AB ; tile references (incl. RLE)

; Room object 53: Key rack facing SE
interior_object_tile_refs_53:
  DEFB $02                ; width
  DEFB $02                ; height
  DEFB $B2,$B1            ; tile references
  DEFB $B3,$B4            ;

; Room object 27: Room outline 18x10 A
interior_object_tile_refs_27:
  DEFB $12                ; width
  DEFB $0A                ; height
  DEFB $FF,$87,$00,$32,$36,$FF,$8E,$00 ; tile references (incl. RLE)
  DEFB $32,$25,$34,$37,$35,$36,$FF,$8A ;
  DEFB $00,$32,$25,$34,$FF,$84,$00,$37 ;
  DEFB $35,$36,$FF,$86,$00,$32,$25,$34 ;
  DEFB $FF,$88,$00,$37,$35,$36,$00,$00 ;
  DEFB $00,$25,$34,$FF,$8C,$00,$37,$35 ;
  DEFB $36,$00,$13,$3A,$FF,$8E,$00,$37 ;
  DEFB $35,$00,$00,$13,$3A,$FF,$8C,$00 ;
  DEFB $39,$0D,$FF,$84,$00,$13,$3A,$FF ;
  DEFB $88,$00,$39,$0D,$FF,$88,$00,$13 ;
  DEFB $3A,$FF,$84,$00,$39,$0D,$FF,$8C ;
  DEFB $00,$13,$3A,$39,$0D,$FF,$86,$00 ;

; Character structures.
;
; This array contains one of these 7-byte structures for each of the 26 game characters:
;
; +-----------+-------+---------------------+-----------------------------------------+
; | Type      | Bytes | Name                | Meaning                                 |
; +-----------+-------+---------------------+-----------------------------------------+
; | Character | 1     | character_and_flags | Character index; bit 6 = on-screen flag |
; | Room      | 1     | room                | The room the character's in, and flags  |
; | TinyPos   | 3     | pos                 | Map position of the character           |
; | Route     | 2     | route               | The route the character's on            |
; +-----------+-------+---------------------+-----------------------------------------+
character_structs:
  DEFB $00,$0B,$2E,$2E,$18,$03,$00 ; character_0_COMMANDANT,   room_11_PAPERS,   ( 46,  46, 24), (0x03, 0x00)
  DEFB $01,$00,$66,$44,$03,$01,$00 ; character_1_GUARD_1,      room_0_OUTDOORS,  (102,  68,  3), (0x01, 0x00)
  DEFB $02,$00,$44,$68,$03,$01,$02 ; character_2_GUARD_2,      room_0_OUTDOORS,  ( 68, 104,  3), (0x01, 0x02)
  DEFB $03,$10,$2E,$2E,$18,$03,$13 ; character_3_GUARD_3,      room_16_CORRIDOR, ( 46,  46, 24), (0x03, 0x13)
  DEFB $04,$00,$3D,$67,$03,$02,$04 ; character_4_GUARD_4,      room_0_OUTDOORS,  ( 61, 103,  3), (0x02, 0x04)
  DEFB $05,$00,$6A,$38,$0D,$00,$00 ; character_5_GUARD_5,      room_0_OUTDOORS,  (106,  56, 13), (0x00, 0x00)
  DEFB $06,$00,$48,$5E,$0D,$00,$00 ; character_6_GUARD_6,      room_0_OUTDOORS,  ( 72,  94, 13), (0x00, 0x00)
  DEFB $07,$00,$48,$46,$0D,$00,$00 ; character_7_GUARD_7,      room_0_OUTDOORS,  ( 72,  70, 13), (0x00, 0x00)
  DEFB $08,$00,$50,$2E,$0D,$00,$00 ; character_8_GUARD_8,      room_0_OUTDOORS,  ( 80,  46, 13), (0x00, 0x00)
  DEFB $09,$00,$6C,$47,$15,$04,$00 ; character_9_GUARD_9,      room_0_OUTDOORS,  (108,  71, 21), (0x04, 0x00)
  DEFB $0A,$00,$5C,$34,$03,$FF,$38 ; character_10_GUARD_10,    room_0_OUTDOORS,  ( 92,  52,  3), (0xFF, 0x38)
  DEFB $0B,$00,$6D,$45,$03,$00,$00 ; character_11_GUARD_11,    room_0_OUTDOORS,  (109,  69,  3), (0x00, 0x00)
  DEFB $0C,$03,$28,$3C,$18,$00,$08 ; character_12_GUARD_12,    room_3_HUT2RIGHT, ( 40,  60, 24), (0x00, 0x08)
; Bug: The room field here is 2 but reset_map_and_characters will reset it to 3.
  DEFB $0D,$02,$24,$30,$18,$00,$08 ; character_13_GUARD_13,    room_2_HUT2LEFT,  ( 36,  48, 24), (0x00, 0x08)
  DEFB $0E,$05,$28,$3C,$18,$00,$10 ; character_14_GUARD_14,    room_5_HUT3RIGHT, ( 40,  60, 24), (0x00, 0x10)
  DEFB $0F,$05,$24,$22,$18,$00,$10 ; character_15_GUARD_15,    room_5_HUT3RIGHT, ( 36,  34, 24), (0x00, 0x10)
  DEFB $10,$00,$44,$54,$01,$FF,$00 ; character_16_GUARD_DOG_1, room_0_OUTDOORS,  ( 68,  84,  1), (0xFF, 0x00)
  DEFB $11,$00,$44,$68,$01,$FF,$00 ; character_17_GUARD_DOG_2, room_0_OUTDOORS,  ( 68, 104,  1), (0xFF, 0x00)
  DEFB $12,$00,$66,$44,$01,$FF,$18 ; character_18_GUARD_DOG_3, room_0_OUTDOORS,  (102,  68,  1), (0xFF, 0x18)
  DEFB $13,$00,$58,$44,$01,$FF,$18 ; character_19_GUARD_DOG_4, room_0_OUTDOORS,  ( 88,  68,  1), (0xFF, 0x18)
  DEFB $14,$FF,$34,$3C,$18,$00,$08 ; character_20_PRISONER_1,  room_NONE,        ( 52,  60, 24), (0x00, 0x08)
  DEFB $15,$FF,$34,$2C,$18,$00,$08 ; character_21_PRISONER_2,  room_NONE,        ( 52,  44, 24), (0x00, 0x08)
  DEFB $16,$FF,$34,$1C,$18,$00,$08 ; character_22_PRISONER_3,  room_NONE,        ( 52,  28, 24), (0x00, 0x08)
  DEFB $17,$FF,$34,$3C,$18,$00,$10 ; character_23_PRISONER_4,  room_NONE,        ( 52,  60, 24), (0x00, 0x10)
  DEFB $18,$FF,$34,$2C,$18,$00,$10 ; character_24_PRISONER_5,  room_NONE,        ( 52,  44, 24), (0x00, 0x10)
  DEFB $19,$FF,$34,$1C,$18,$00,$10 ; character_25_PRISONER_6,  room_NONE,        ( 52,  28, 24), (0x00, 0x10)

; Item structures (a.k.a. itemstructs).
;
; This array contains one of these 7-byte structures for each of the 16 game items:
;
; +---------+-------+----------------+------------------------------------------+
; | Type    | Bytes | Name           | Meaning                                  |
; +---------+-------+----------------+------------------------------------------+
; | Item    | 1     | item_and_flags | bits 0..3 = item; bits 4..7 = flags      |
; | Room    | 1     | room_and_flags | bits 0..5 = room; bits 6..7 = flags      |
; | TinyPos | 3     | pos            | Map position of the item                 |
; | IsoPos  | 2     | iso_pos        | Isometric projected position of the item |
; +---------+-------+----------------+------------------------------------------+
item_structs:
  DEFB $00,$FF,$40,$20,$02,$78,$F4 ; item_WIRESNIPS,        room_NONE,        (64, 32,  2), (0x78, 0xF4) // <- item_to_itemstruct, find_nearby_item
  DEFB $01,$09,$3E,$30,$00,$7C,$F2 ; item_SHOVEL,           room_9_CRATE,     (62, 48,  0), (0x7C, 0xF2)
  DEFB $02,$0A,$49,$24,$10,$77,$F0 ; item_LOCKPICK,         room_10_LOCKPICK, (73, 36, 16), (0x77, 0xF0)
  DEFB $03,$0B,$2A,$3A,$04,$84,$F3 ; item_PAPERS,           room_11_PAPERS,   (42, 58,  4), (0x84, 0xF3)
  DEFB $04,$0E,$32,$18,$02,$7A,$F6 ; item_TORCH,            room_14_TORCH,    (34, 24,  2), (0x7A, 0xF6)
  DEFB $05,$FF,$24,$2C,$04,$7E,$F4 ; item_BRIBE,            room_NONE,        (36, 44,  4), (0x7E, 0xF4) // <- accept_bribe
  DEFB $06,$0F,$2C,$41,$10,$87,$F1 ; item_UNIFORM,          room_15_UNIFORM,  (44, 65, 16), (0x87, 0xF1)
item_structs_food:
  DEFB $07,$13,$40,$30,$10,$7E,$F0 ; item_FOOD,             room_19_FOOD,     (64, 48, 16), (0x7E, 0xF0) // <- action_poison, called_from_main_loop
  DEFB $08,$01,$42,$34,$04,$7C,$F1 ; item_POISON,           room_1_HUT1RIGHT, (66, 52,  4), (0x7C, 0xF1)
  DEFB $09,$16,$3C,$2A,$00,$7B,$F2 ; item_RED_KEY,          room_22_REDKEY,   (60, 42,  0), (0x7B, 0xF2)
  DEFB $0A,$0B,$1C,$22,$00,$81,$F8 ; item_YELLOW_KEY,       room_11_PAPERS,   (28, 34,  0), (0x81, 0xF8)
  DEFB $0B,$00,$4A,$48,$00,$7A,$6E ; item_GREEN_KEY,        room_0_OUTDOORS,  (74, 72,  0), (0x7A, 0x6E)
  DEFB $0C,$FF,$1C,$32,$0C,$85,$F6 ; item_RED_CROSS_PARCEL, room_NONE,        (28, 50, 12), (0x85, 0xF6) // <- event_new_red_cross_parcel, new_red_cross_parcel
  DEFB $0D,$12,$24,$3A,$08,$85,$F4 ; item_RADIO,            room_18_RADIO,    (36, 58,  8), (0x85, 0xF4)
  DEFB $0E,$FF,$24,$2C,$04,$7E,$F4 ; item_PURSE,            room_NONE,        (36, 44,  4), (0x7E, 0xF4)
  DEFB $0F,$FF,$34,$1C,$04,$7E,$F4 ; item_COMPASS,          room_NONE,        (52, 28,  4), (0x7E, 0xF4)

; Table of pointers to routes.
routes:
  DEFW $0000                      ; Array, 46 long, of pointers to $FF-terminated runs.
  DEFW route_7795                 ;
  DEFW route_7799                 ;
  DEFW route_commandant           ;
  DEFW route_77CD                 ;
  DEFW route_exit_hut2            ;
  DEFW route_exit_hut3            ;
  DEFW route_prisoner_sleeps_1    ;
  DEFW route_prisoner_sleeps_2    ;
  DEFW route_prisoner_sleeps_3    ;
  DEFW route_prisoner_sleeps_1    ;
  DEFW route_prisoner_sleeps_2    ;
  DEFW route_prisoner_sleeps_3    ;
  DEFW route_77DE                 ;
  DEFW route_77E1                 ;
  DEFW route_77E1                 ;
  DEFW route_77E7                 ;
  DEFW route_77EC                 ;
  DEFW route_prisoner_sits_1      ;
  DEFW route_prisoner_sits_2      ;
  DEFW route_prisoner_sits_3      ;
  DEFW route_prisoner_sits_1      ;
  DEFW route_prisoner_sits_2      ;
  DEFW route_prisoner_sits_3      ;
  DEFW route_guardA_breakfast     ;
  DEFW route_guardB_breakfast     ;
  DEFW route_guard_12_roll_call   ;
  DEFW route_guard_13_roll_call   ;
  DEFW route_prisoner_1_roll_call ;
  DEFW route_prisoner_2_roll_call ;
  DEFW route_prisoner_3_roll_call ;
  DEFW route_guard_14_roll_call   ;
  DEFW route_guard_15_roll_call   ;
  DEFW route_prisoner_4_roll_call ;
  DEFW route_prisoner_5_roll_call ;
  DEFW route_prisoner_6_roll_call ;
  DEFW route_go_to_solitary       ;
  DEFW route_hero_leave_solitary  ;
  DEFW route_guard_12_bed         ;
  DEFW route_guard_13_bed         ;
  DEFW route_guard_14_bed         ;
  DEFW route_guard_15_bed         ;
  DEFW route_hut2_left_to_right   ;
  DEFW route_7833                 ;
  DEFW route_hut2_right_to_left   ;
  DEFW route_hero_roll_call       ;
  DEFB $FF                ; Fake terminator used by get_target
route_7795:
  DEFB $48,$49,$4A,$FF    ; L-shaped route in the fenced area  [ location(32), location(33), location(34), (end) ]
route_7799:
  DEFB $4B,$4C,$4D,$4E,$4F,$50,$FF ; guard's route around the front perimeter wall  [ location(35), location(36), location(37), location(38), location(39), location(40), (end) ]
route_commandant:
  DEFB $56,$1F,$1D,$20,$1A,$23,$99,$96 ; the commandant's route - the longest of all the routes  [ location(46), door(31), door(29), door(32), door(26), door(35), door(25 reversed), door(22 reversed), door(21 reversed), door(20 reversed),
  DEFB $95,$94,$97,$52,$17,$8A,$0B,$8B ; door(23 reversed), location(42), door(23), door(10 reversed), door(11), door(11 reversed), door(12), door(27 reversed), door(28), door(29 reversed), door(13 reversed), location(11), location(55),
  DEFB $0C,$9B,$1C,$9D,$8D,$33,$5F,$80 ; door(0 reversed), door(1 reversed), location(60), door(1), door(0), door(4), door(16), door(5 reversed), location(11), door(7), door(17 reversed), door(6 reversed), door(8), door(18), door(9
  DEFB $81,$64,$01,$00,$04,$10,$85,$33 ; reversed), location(45), door(14), door(34), door(34 reversed), door(33), door(33 reversed), (end) ]
  DEFB $07,$91,$86,$08,$12,$89,$55,$0E ;
  DEFB $22,$A2,$21,$A1,$FF             ;
route_77CD:
  DEFB $53,$54,$FF        ; guard's route marching over the front gate  [ location(43), location(44), (end) ]
route_exit_hut2:
  DEFB $87,$33,$34,$FF    ; route_exit_hut2  [ door(7 reversed), location(11), location(12), (end) ]
route_exit_hut3:
  DEFB $89,$55,$36,$FF    ; route_exit_hut3  [ door(9 reversed), location(45), location(14), (end) ]
route_prisoner_sleeps_1:
  DEFB $56,$FF            ; route_prisoner_sleeps_1  [ location(46), (end) ]
route_prisoner_sleeps_2:
  DEFB $57,$FF            ; route_prisoner_sleeps_2  [ location(47), (end) ]
route_prisoner_sleeps_3:
  DEFB $58,$FF            ; route_prisoner_sleeps_3  [ location(48), (end) ]
route_77DE:
  DEFB $5C,$5D,$FF        ; route_77DE  [ location(52), location(53), (end) ]
route_77E1:
  DEFB $33,$5F,$80,$81,$60,$FF ; route_77E1  [ location(11), location(55), door(0 reversed), door(1 reversed), location(56), (end) ]
route_77E7:
  DEFB $34,$0A,$14,$93,$FF ; route_77E7  [ location(12), door(10), door(20), door(19 reversed), (end) ]
route_77EC:
  DEFB $38,$34,$0A,$14,$FF ; route_77EC  [ location(16), location(12), door(10), door(20), (end) ]
route_prisoner_sits_1:
  DEFB $68,$FF            ; route_prisoner_sits_1  [ location(64), (end) ]
route_prisoner_sits_2:
  DEFB $69,$FF            ; route_prisoner_sits_2  [ location(65), (end) ]
route_prisoner_sits_3:
  DEFB $6A,$FF            ; route_prisoner_sits_3  [ location(66), (end) ]
route_guardA_breakfast:
  DEFB $6C,$FF            ; route_guardA_breakfast  [ location(68), (end) ]
route_guardB_breakfast:
  DEFB $6D,$FF            ; route_guardB_breakfast  [ location(69), (end) ]
route_guard_12_roll_call:
  DEFB $31,$FF            ; route_guard_12_roll_call  [ location(9), (end) ]
route_guard_13_roll_call:
  DEFB $33,$FF            ; route_guard_13_roll_call  [ location(11), (end) ]
route_guard_14_roll_call:
  DEFB $39,$FF            ; route_guard_14_roll_call  [ location(17), (end) ]
route_guard_15_roll_call:
  DEFB $59,$FF            ; route_guard_15_roll_call  [ location(49), (end) ]
route_prisoner_1_roll_call:
  DEFB $70,$FF            ; route_prisoner_1_roll_call  [ location(72), (end) ]
route_prisoner_2_roll_call:
  DEFB $71,$FF            ; route_prisoner_2_roll_call  [ location(73), (end) ]
route_prisoner_3_roll_call:
  DEFB $72,$FF            ; route_prisoner_3_roll_call  [ location(74), (end) ]
route_prisoner_4_roll_call:
  DEFB $73,$FF            ; route_prisoner_4_roll_call  [ location(75), (end) ]
route_prisoner_5_roll_call:
  DEFB $74,$FF            ; route_prisoner_5_roll_call  [ location(76), (end) ]
route_prisoner_6_roll_call:
  DEFB $75,$FF            ; route_prisoner_6_roll_call  [ location(77), (end) ]
route_go_to_solitary:
  DEFB $36,$0A,$97,$98,$52,$FF ; route_go_to_solitary  [ location(14), door(10), door(23 reversed), door(24 reversed), location(42), (end) ]
route_hero_leave_solitary:
  DEFB $18,$17,$8A,$36,$FF ; route_hero_leave_solitary  [ door(24), door(23), door(10 reversed), location(14), (end) ]
route_guard_12_bed:
  DEFB $34,$33,$07,$5C,$FF ; route_guard_12_bed  [ location(12), location(11), door(7), location(52), (end) ]
route_guard_13_bed:
  DEFB $34,$33,$07,$91,$5D,$FF ; route_guard_13_bed  [ location(12), location(11), door(7), door(17 reversed), location(53), (end) ]
route_guard_14_bed:
  DEFB $34,$33,$55,$09,$5C,$FF ; route_guard_14_bed  [ location(12), location(11), location(45), door(9), location(52), (end) ]
route_guard_15_bed:
  DEFB $34,$33,$55,$09,$5D,$FF ; route_guard_15_bed  [ location(12), location(11), location(45), door(9), location(53), (end) ]
route_hut2_left_to_right:
  DEFB $11,$FF            ; route_hut2_left_to_right  [ door(17), (end) ]
route_7833:
  DEFB $6B,$FF            ; route_7833  [ location(67), (end) ]
route_hut2_right_to_left:
  DEFB $91,$6E,$FF        ; route_hut2_right_to_left  [ door(17 reversed), location(70), (end) ]
route_hero_roll_call:
  DEFB $5A,$FF            ; route_hero_roll_call  [ location(50), (end) ]

; Table of map locations used in routes.
;
; Array, 78 long, of two-byte locations (x,y)
locations:
  DEFW $6844              ; ( 68, 104)
  DEFW $5444              ; ( 68,  84)
  DEFW $4644              ; ( 68,  70)
  DEFW $6640              ; ( 64, 102)
  DEFW $4040              ; ( 64,  64)
  DEFW $4444              ; ( 68,  68)
  DEFW $4040              ; ( 64,  64)
  DEFW $4044              ; ( 68,  64)
  DEFW $7068              ; (104, 112)
  DEFW $7060              ; ( 96, 112)
  DEFW $666A              ; (106, 102)
  DEFW $685D              ; ( 93, 104)
  DEFW $657C              ; (124, 101)
  DEFW $707C              ; (124, 112)
  DEFW $6874              ; (116, 104)
  DEFW $6470              ; (112, 100)
  DEFW $6078              ; (120,  96)
  DEFW $5880              ; (128,  88)
  DEFW $6070              ; (112,  96)
  DEFW $5474              ; (116,  84)
  DEFW $647C              ; (124, 100)
  DEFW $707C              ; (124, 112)
  DEFW $6874              ; (116, 104)
  DEFW $6470              ; (112, 100)
  DEFW $4466              ; (102,  68)
  DEFW $4066              ; (102,  64)
  DEFW $4060              ; ( 96,  64)
  DEFW $445C              ; ( 92,  68)
  DEFW $4456              ; ( 86,  68)
  DEFW $4054              ; ( 84,  64)
  DEFW $444A              ; ( 74,  68)
  DEFW $404A              ; ( 74,  64)
  DEFW $4466              ; (102,  68)
  DEFW $4444              ; ( 68,  68)
  DEFW $6844              ; ( 68, 104)
  DEFW $456B              ; (107,  69)
  DEFW $2D6B              ; (107,  45)
  DEFW $2D4D              ; ( 77,  45)
  DEFW $3D4D              ; ( 77,  61)
  DEFW $3D3D              ; ( 61,  61)
  DEFW $673D              ; ( 61, 103)
  DEFW $4C74              ; (116,  76)
  DEFW $2A2C              ; ( 44,  42)
  DEFW $486A              ; (106,  72)
  DEFW $486E              ; (110,  72)
  DEFW $6851              ; ( 81, 104)
  DEFW $3C34              ; ( 52,  60)
  DEFW $2C34              ; ( 52,  44)
  DEFW $1C34              ; ( 52,  28)
  DEFW $6B77              ; (119, 107)
  DEFW $6E7A              ; (122, 110)
  DEFW $1C34              ; ( 52,  28)
  DEFW $3C28              ; ( 40,  60)
  DEFW $2224              ; ( 36,  34)
  DEFW $4C50              ; ( 80,  76)
  DEFW $4C59              ; ( 89,  76)
  DEFW $3C59              ; ( 89,  60)
  DEFW $3D64              ; (100,  61)
  DEFW $365C              ; ( 92,  54)
  DEFW $3254              ; ( 84,  50)
  DEFW $3066              ; (102,  48)
  DEFW $3860              ; ( 96,  56)
  DEFW $3B4F              ; ( 79,  59)
  DEFW $2F67              ; (103,  47)
  DEFW $3634              ; ( 52,  54)
  DEFW $2E34              ; ( 52,  46)
  DEFW $2434              ; ( 52,  36)
  DEFW $3E34              ; ( 52,  62)
  DEFW $3820              ; ( 32,  56)
  DEFW $1834              ; ( 52,  24)
  DEFW $2E2A              ; ( 42,  46)
  DEFW $2222              ; ( 34,  34)
  DEFW $6E78              ; (120, 110)
  DEFW $6E76              ; (118, 110)
  DEFW $6E74              ; (116, 110)
  DEFW $6D79              ; (121, 109)
  DEFW $6D77              ; (119, 109)
  DEFW $6D75              ; (117, 109)

; Door positions.
;
; 62 pairs of four-byte structs laid out as follows:
;
; +---------+-------+--------------------+------------------------------------------------------------------+
; | Type    | Bytes | Name               | Meaning                                                          |
; +---------+-------+--------------------+------------------------------------------------------------------+
; | Byte    | 1     | room_and_direction | Top six bits are a room index. Bottom two bits are a direction_t |
; | TinyPos | 3     | pos                | Map position of the door                                         |
; +---------+-------+--------------------+------------------------------------------------------------------+
;
; Each door is stored as a pair of two "half doors". Each half of the pair contains (room, direction, position) where the room is the *target* room index, the direction is the direction in which the door faces and the position is the
; coordinates of the door. Outdoor coordinates are divided by four.
doors:
  DEFB $01,$B2,$8A,$06    ; BYTE(room_0_OUTDOORS,             1), 0xB2, 0x8A,  6 }, // 0
  DEFB $03,$B2,$8E,$06    ; BYTE(room_0_OUTDOORS,             3), 0xB2, 0x8E,  6 },
  DEFB $01,$B2,$7A,$06    ; BYTE(room_0_OUTDOORS,             1), 0xB2, 0x7A,  6 },
  DEFB $03,$B2,$7E,$06    ; BYTE(room_0_OUTDOORS,             3), 0xB2, 0x7E,  6 },
  DEFB $88,$8A,$B3,$06    ; BYTE(room_34,                     0), 0x8A, 0xB3,  6 },
  DEFB $02,$10,$34,$0C    ; BYTE(room_0_OUTDOORS,             2), 0x10, 0x34, 12 },
  DEFB $C0,$CC,$79,$06    ; BYTE(room_48,                     0), 0xCC, 0x79,  6 },
  DEFB $02,$10,$34,$0C    ; BYTE(room_0_OUTDOORS,             2), 0x10, 0x34, 12 },
  DEFB $71,$D9,$A3,$06    ; BYTE(room_28_HUT1LEFT,            1), 0xD9, 0xA3,  6 },
  DEFB $03,$2A,$1C,$18    ; BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
  DEFB $04,$D4,$BD,$06    ; BYTE(room_1_HUT1RIGHT,            0), 0xD4, 0xBD,  6 },
  DEFB $02,$1E,$2E,$18    ; BYTE(room_0_OUTDOORS,             2), 0x1E, 0x2E, 24 },
doors_home_to_outside:
  DEFB $09,$C1,$A3,$06    ; BYTE(room_2_HUT2LEFT,             1), 0xC1, 0xA3,  6 },
  DEFB $03,$2A,$1C,$18    ; BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
  DEFB $0C,$BC,$BD,$06    ; BYTE(room_3_HUT2RIGHT,            0), 0xBC, 0xBD,  6 },
  DEFB $02,$20,$2E,$18    ; BYTE(room_0_OUTDOORS,             2), 0x20, 0x2E, 24 },
  DEFB $11,$A9,$A3,$06    ; BYTE(room_4_HUT3LEFT,             1), 0xA9, 0xA3,  6 },
  DEFB $03,$2A,$1C,$18    ; BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
  DEFB $14,$A4,$BD,$06    ; BYTE(room_5_HUT3RIGHT,            0), 0xA4, 0xBD,  6 },
  DEFB $02,$20,$2E,$18    ; BYTE(room_0_OUTDOORS,             2), 0x20, 0x2E, 24 },
  DEFB $54,$FC,$CA,$06    ; BYTE(room_21_CORRIDOR,            0), 0xFC, 0xCA,  6 }, // 10
  DEFB $02,$1C,$24,$18    ; BYTE(room_0_OUTDOORS,             2), 0x1C, 0x24, 24 },
  DEFB $50,$FC,$DA,$06    ; BYTE(room_20_REDCROSS,            0), 0xFC, 0xDA,  6 },
  DEFB $02,$1A,$22,$18    ; BYTE(room_0_OUTDOORS,             2), 0x1A, 0x22, 24 },
  DEFB $3D,$F7,$E3,$06    ; BYTE(room_15_UNIFORM,             1), 0xF7, 0xE3,  6 },
  DEFB $03,$26,$19,$18    ; BYTE(room_0_OUTDOORS,             3), 0x26, 0x19, 24 },
  DEFB $35,$DF,$E3,$06    ; BYTE(room_13_CORRIDOR,            1), 0xDF, 0xE3,  6 },
  DEFB $03,$2A,$1C,$18    ; BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
  DEFB $21,$97,$D3,$06    ; BYTE(room_8_CORRIDOR,             1), 0x97, 0xD3,  6 },
  DEFB $03,$2A,$15,$18    ; BYTE(room_0_OUTDOORS,             3), 0x2A, 0x15, 24 },
doors_unused:
  DEFB $19,$00,$00,$00    ; BYTE(room_6,                      1), 0x00, 0x00,  0 },
  DEFB $03,$22,$22,$18    ; BYTE(room_0_OUTDOORS,             3), 0x22, 0x22, 24 },
  DEFB $05,$2C,$34,$18    ; BYTE(room_1_HUT1RIGHT,            1), 0x2C, 0x34, 24 },
  DEFB $73,$26,$1A,$18    ; BYTE(room_28_HUT1LEFT,            3), 0x26, 0x1A, 24 },
  DEFB $0D,$24,$36,$18    ; BYTE(room_3_HUT2RIGHT,            1), 0x24, 0x36, 24 },
doors_home_to_inside:
  DEFB $0B,$26,$1A,$18    ; BYTE(room_2_HUT2LEFT,             3), 0x26, 0x1A, 24 },
  DEFB $15,$24,$36,$18    ; BYTE(room_5_HUT3RIGHT,            1), 0x24, 0x36, 24 },
  DEFB $13,$26,$1A,$18    ; BYTE(room_4_HUT3LEFT,             3), 0x26, 0x1A, 24 },
  DEFB $5D,$28,$42,$18    ; BYTE(room_23_BREAKFAST,           1), 0x28, 0x42, 24 },
  DEFB $67,$26,$18,$18    ; BYTE(room_25_BREAKFAST,           3), 0x26, 0x18, 24 },
  DEFB $5C,$3E,$24,$18    ; BYTE(room_23_BREAKFAST,           0), 0x3E, 0x24, 24 }, // 20
  DEFB $56,$20,$2E,$18    ; BYTE(room_21_CORRIDOR,            2), 0x20, 0x2E, 24 },
  DEFB $4D,$22,$42,$18    ; BYTE(room_19_FOOD,                1), 0x22, 0x42, 24 },
  DEFB $5F,$22,$1C,$18    ; BYTE(room_23_BREAKFAST,           3), 0x22, 0x1C, 24 },
  DEFB $49,$24,$36,$18    ; BYTE(room_18_RADIO,               1), 0x24, 0x36, 24 },
  DEFB $4F,$38,$22,$18    ; BYTE(room_19_FOOD,                3), 0x38, 0x22, 24 },
  DEFB $55,$2C,$36,$18    ; BYTE(room_21_CORRIDOR,            1), 0x2C, 0x36, 24 },
  DEFB $5B,$22,$1C,$18    ; BYTE(room_22_REDKEY,              3), 0x22, 0x1C, 24 },
  DEFB $59,$2C,$36,$18    ; BYTE(room_22_REDKEY,              1), 0x2C, 0x36, 24 },
  DEFB $63,$2A,$26,$18    ; BYTE(room_24_SOLITARY,            3), 0x2A, 0x26, 24 },
  DEFB $31,$42,$3A,$18    ; BYTE(room_12_CORRIDOR,            1), 0x42, 0x3A, 24 },
  DEFB $4B,$22,$1C,$18    ; BYTE(room_18_RADIO,               3), 0x22, 0x1C, 24 },
  DEFB $44,$3C,$24,$18    ; BYTE(room_17_CORRIDOR,            0), 0x3C, 0x24, 24 },
  DEFB $1E,$1C,$22,$18    ; BYTE(room_7_CORRIDOR,             2), 0x1C, 0x22, 24 },
  DEFB $3C,$40,$28,$18    ; BYTE(room_15_UNIFORM,             0), 0x40, 0x28, 24 },
  DEFB $3A,$1E,$28,$18    ; BYTE(room_14_TORCH,               2), 0x1E, 0x28, 24 },
  DEFB $41,$22,$42,$18    ; BYTE(room_16_CORRIDOR,            1), 0x22, 0x42, 24 },
  DEFB $3B,$22,$1C,$18    ; BYTE(room_14_TORCH,               3), 0x22, 0x1C, 24 },
  DEFB $40,$3E,$2E,$18    ; BYTE(room_16_CORRIDOR,            0), 0x3E, 0x2E, 24 },
  DEFB $36,$1A,$22,$18    ; BYTE(room_13_CORRIDOR,            2), 0x1A, 0x22, 24 },
  DEFB $00,$44,$30,$18    ; BYTE(room_0_OUTDOORS,             0), 0x44, 0x30, 24 }, // 30
  DEFB $02,$20,$30,$18    ; BYTE(room_0_OUTDOORS,             2), 0x20, 0x30, 24 },
  DEFB $34,$4A,$28,$18    ; BYTE(room_13_CORRIDOR,            0), 0x4A, 0x28, 24 },
  DEFB $2E,$1A,$22,$18    ; BYTE(room_11_PAPERS,              2), 0x1A, 0x22, 24 },
  DEFB $1C,$40,$24,$18    ; BYTE(room_7_CORRIDOR,             0), 0x40, 0x24, 24 },
  DEFB $42,$1A,$22,$18    ; BYTE(room_16_CORRIDOR,            2), 0x1A, 0x22, 24 },
  DEFB $28,$36,$35,$18    ; BYTE(room_10_LOCKPICK,            0), 0x36, 0x35, 24 },
  DEFB $22,$17,$26,$18    ; BYTE(room_8_CORRIDOR,             2), 0x17, 0x26, 24 },
  DEFB $24,$36,$1C,$18    ; BYTE(room_9_CRATE,                0), 0x36, 0x1C, 24 },
  DEFB $22,$1A,$22,$18    ; BYTE(room_8_CORRIDOR,             2), 0x1A, 0x22, 24 },
  DEFB $30,$3E,$24,$18    ; BYTE(room_12_CORRIDOR,            0), 0x3E, 0x24, 24 },
  DEFB $46,$1A,$22,$18    ; BYTE(room_17_CORRIDOR,            2), 0x1A, 0x22, 24 },
  DEFB $75,$36,$36,$18    ; BYTE(room_29_SECOND_TUNNEL_START, 1), 0x36, 0x36, 24 },
  DEFB $27,$38,$0A,$0C    ; BYTE(room_9_CRATE,                3), 0x38, 0x0A, 12 },
  DEFB $D1,$38,$62,$0C    ; BYTE(room_52,                     1), 0x38, 0x62, 12 },
  DEFB $7B,$38,$0A,$0C    ; BYTE(room_30,                     3), 0x38, 0x0A, 12 },
  DEFB $78,$64,$34,$0C    ; BYTE(room_30,                     0), 0x64, 0x34, 12 },
  DEFB $7E,$38,$26,$0C    ; BYTE(room_31,                     2), 0x38, 0x26, 12 },
  DEFB $79,$38,$62,$0C    ; BYTE(room_30,                     1), 0x38, 0x62, 12 },
  DEFB $93,$38,$0A,$0C    ; BYTE(room_36,                     3), 0x38, 0x0A, 12 },
  DEFB $7C,$64,$34,$0C    ; BYTE(room_31,                     0), 0x64, 0x34, 12 }, // 40
  DEFB $82,$0A,$34,$0C    ; BYTE(room_32,                     2), 0x0A, 0x34, 12 },
  DEFB $81,$38,$62,$0C    ; BYTE(room_32,                     1), 0x38, 0x62, 12 },
  DEFB $87,$20,$34,$0C    ; BYTE(room_33,                     3), 0x20, 0x34, 12 },
  DEFB $85,$40,$34,$0C    ; BYTE(room_33,                     1), 0x40, 0x34, 12 },
  DEFB $8F,$38,$0A,$0C    ; BYTE(room_35,                     3), 0x38, 0x0A, 12 },
  DEFB $8C,$64,$34,$0C    ; BYTE(room_35,                     0), 0x64, 0x34, 12 },
  DEFB $8A,$0A,$34,$0C    ; BYTE(room_34,                     2), 0x0A, 0x34, 12 },
  DEFB $90,$64,$34,$0C    ; BYTE(room_36,                     0), 0x64, 0x34, 12 },
  DEFB $8E,$38,$1C,$0C    ; BYTE(room_35,                     2), 0x38, 0x1C, 12 },
doors_home_to_tunnel:
  DEFB $94,$3E,$22,$18    ; BYTE(room_37,                     0), 0x3E, 0x22, 24 },
  DEFB $0A,$10,$34,$0C    ; BYTE(room_2_HUT2LEFT,             2), 0x10, 0x34, 12 },
  DEFB $98,$64,$34,$0C    ; BYTE(room_38,                     0), 0x64, 0x34, 12 },
  DEFB $96,$10,$34,$0C    ; BYTE(room_37,                     2), 0x10, 0x34, 12 },
  DEFB $9D,$40,$34,$0C    ; BYTE(room_39,                     1), 0x40, 0x34, 12 },
  DEFB $9B,$20,$34,$0C    ; BYTE(room_38,                     3), 0x20, 0x34, 12 },
  DEFB $A0,$64,$34,$0C    ; BYTE(room_40,                     0), 0x64, 0x34, 12 },
  DEFB $9A,$38,$54,$0C    ; BYTE(room_38,                     2), 0x38, 0x54, 12 },
  DEFB $A1,$38,$62,$0C    ; BYTE(room_40,                     1), 0x38, 0x62, 12 },
  DEFB $A7,$38,$0A,$0C    ; BYTE(room_41,                     3), 0x38, 0x0A, 12 },
  DEFB $A4,$64,$34,$0C    ; BYTE(room_41,                     0), 0x64, 0x34, 12 }, // 50
  DEFB $AA,$38,$26,$0C    ; BYTE(room_42,                     2), 0x38, 0x26, 12 },
  DEFB $A5,$38,$62,$0C    ; BYTE(room_41,                     1), 0x38, 0x62, 12 },
  DEFB $B7,$38,$0A,$0C    ; BYTE(room_45,                     3), 0x38, 0x0A, 12 },
  DEFB $B4,$64,$34,$0C    ; BYTE(room_45,                     0), 0x64, 0x34, 12 },
  DEFB $B2,$38,$1C,$0C    ; BYTE(room_44,                     2), 0x38, 0x1C, 12 },
  DEFB $AD,$20,$34,$0C    ; BYTE(room_43,                     1), 0x20, 0x34, 12 },
  DEFB $B3,$38,$0A,$0C    ; BYTE(room_44,                     3), 0x38, 0x0A, 12 },
  DEFB $A9,$38,$62,$0C    ; BYTE(room_42,                     1), 0x38, 0x62, 12 },
  DEFB $AF,$20,$34,$0C    ; BYTE(room_43,                     3), 0x20, 0x34, 12 },
  DEFB $B8,$64,$34,$0C    ; BYTE(room_46,                     0), 0x64, 0x34, 12 },
  DEFB $9E,$38,$1C,$0C    ; BYTE(room_39,                     2), 0x38, 0x1C, 12 },
  DEFB $BD,$38,$62,$0C    ; BYTE(room_47,                     1), 0x38, 0x62, 12 },
  DEFB $BB,$20,$34,$0C    ; BYTE(room_46,                     3), 0x20, 0x34, 12 },
  DEFB $C8,$64,$34,$0C    ; BYTE(room_50_BLOCKED_TUNNEL,      0), 0x64, 0x34, 12 },
  DEFB $BE,$38,$56,$0C    ; BYTE(room_47,                     2), 0x38, 0x56, 12 },
  DEFB $C9,$38,$62,$0C    ; BYTE(room_50_BLOCKED_TUNNEL,      1), 0x38, 0x62, 12 },
  DEFB $C7,$38,$0A,$0C    ; BYTE(room_49,                     3), 0x38, 0x0A, 12 },
  DEFB $C4,$64,$34,$0C    ; BYTE(room_49,                     0), 0x64, 0x34, 12 },
  DEFB $C2,$38,$1C,$0C    ; BYTE(room_48,                     2), 0x38, 0x1C, 12 },
  DEFB $CD,$38,$62,$0C    ; BYTE(room_51,                     1), 0x38, 0x62, 12 }, // 60
  DEFB $77,$20,$34,$0C    ; BYTE(room_29_SECOND_TUNNEL_START, 3), 0x20, 0x34, 12 },
  DEFB $D0,$64,$34,$0C    ; BYTE(room_52,                     0), 0x64, 0x34, 12 },
  DEFB $CE,$38,$54,$0C    ; BYTE(room_51,                     2), 0x38, 0x54, 12 },

; Solitary map position.
;
; Used by solitary.
solitary_pos:
  DEFB $3A,$2A,$18        ; 0x3A, 0x2A, 24 // tinypos_t

; Check for 'pick up', 'drop' and 'use' input events.
;
; Used by the routine at process_player_input.
;
; I:A Input event.
process_player_input_fire:
  CP $0A                  ; Is the input event fire + up?
  JP NZ,process_player_input_fire_0 ; Test for the next input event if not
  CALL pick_up_item       ; Call pick_up_item if so
  JR check_for_pick_up_keypress_exit ; Then return
process_player_input_fire_0:
  CP $0B                  ; Is the input event fire + down?
  JP NZ,process_player_input_fire_1 ; Test for the next input event if not
  CALL drop_item          ; Call drop_item if so
  JR check_for_pick_up_keypress_exit ; Then return
process_player_input_fire_1:
  CP $0C                  ; Is the input event fire + left?
  JP NZ,process_player_input_fire_2 ; Test for the next input event if not
  CALL use_item_A         ; Call use_item_A if so
  JR check_for_pick_up_keypress_exit ; Then return
process_player_input_fire_2:
  CP $0F                  ; Is the input event fire + right?
  JP NZ,check_for_pick_up_keypress_exit ; Test for the next input event if not
  CALL use_item_B         ; Call use_item_B if so
check_for_pick_up_keypress_exit:
  RET                     ; Return
; Use item 'B'.
use_item_B:
  LD A,(items_held + $0001) ; Fetch the second held item
  JR use_item_common      ; Jump over item 'A' case
; Use item 'A'.
use_item_A:
  LD A,(items_held)       ; Fetch the first held item
; Use item common.
use_item_common:
  CP $FF                  ; Is the item in A item_NONE? ($FF)
  RET Z                   ; Return if so
  JR process_player_input_fire_3 ; Bug: Pointless jump to adjacent instruction
process_player_input_fire_3:
  ADD A,A                       ; Point HL at the A'th entry of item_actions_jump_table
  LD C,A                        ;
  LD B,$00                      ;
  LD HL,item_actions_jump_table ;
  ADD HL,BC                     ;
  LD A,(HL)               ; Fetch the jump table destination address
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  PUSH HL                 ; Stack the jump table destination address
  LD DE,saved_pos_x       ; Copy X,Y and height from the hero's position into saved_pos
  LD HL,$800F             ;
  LD BC,$0006             ;
  LDIR                    ;
  RET                     ; Jump to the stacked destination address
; Item actions jump table.
item_actions_jump_table:
  DEFW action_wiresnips
  DEFW action_shovel
  DEFW action_lockpick
  DEFW action_papers
  DEFW check_for_pick_up_keypress_exit ; Return
  DEFW action_bribe
  DEFW action_uniform
  DEFW check_for_pick_up_keypress_exit ; Return
  DEFW action_poison
  DEFW action_red_key
  DEFW action_yellow_key
  DEFW action_green_key
  DEFW action_red_cross_parcel
  DEFW check_for_pick_up_keypress_exit ; Return
  DEFW check_for_pick_up_keypress_exit ; Return
  DEFW check_for_pick_up_keypress_exit ; Return

; Pick up an item.
;
; Used by the routine at process_player_input_fire.
pick_up_item:
  LD HL,(items_held)      ; Load both held items into HL
  LD A,$FF                ; Set A to item_NONE ($FF)
  CP L                         ; If neither item slot is empty then return - we don't have the space to pick another item up
  JR Z,pick_up_have_empty_slot ;
  CP H                         ;
  RET NZ                       ;
pick_up_have_empty_slot:
  CALL find_nearby_item   ; Find nearby items. HL points to an item in item_structs if found
  RET NZ                  ; Return if no items were found
; Locate an empty item slot.
  LD DE,items_held        ; Point DE at the held items array
  LD A,(DE)               ; Load an item
  CP $FF                  ; Step over the item if it's item_NONE
  JR Z,pick_up_item_0     ;
  INC DE                  ;
pick_up_item_0:
  LD A,(HL)               ; Fetch the item_struct item's first byte and mask off the item. Note: The mask used here is $1F, not $0F as seen elsewhere in the code. Unsure why
  AND $1F                 ;
  LD (DE),A               ;
  PUSH HL                 ; Save the item_struct item pointer
  LD A,(room_index)       ; Fetch the global current room index
  CP $00                  ; Are we outdoors?
  JP NZ,pick_up_indoors   ; No - jump to indoor handling
pick_up_outdoors:
  CALL plot_all_tiles     ; Plot all tiles
  JR pick_up_item_1       ; Jump over indoor handling
pick_up_indoors:
  CALL setup_room         ; Expand out the room definition for room_index
  CALL plot_interior_tiles ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
  CALL choose_game_window_attributes ; Choose game window attributes
  CALL set_game_window_attributes ; Set game window attributes
pick_up_item_1:
  POP HL                  ; Retrieve the item_struct item pointer
  BIT 7,(HL)              ; Is the itemstruct_ITEM_FLAG_HELD flag set? ($80)
  JR NZ,pick_up_item_2    ; Jump if so
; Have picked up an item not previously held - increase the score.
pick_up_novel_item:
  SET 7,(HL)              ; Set the itemstruct_ITEM_FLAG_HELD flag so we only award these points on the first pick-up
  PUSH HL                 ; Save the item_struct item pointer again
  CALL increase_morale_by_5_score_by_5 ; Increase morale by 5, score by 5
  POP HL                  ; Retrieve again
; Make the item disappear.
pick_up_item_2:
  XOR A                   ; Zero A
  INC HL                  ; Zero itemstruct->room_and_flags
  LD (HL),A               ;
  INC HL                  ; Advance HL to itemstruct->iso_pos
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  LD (HL),A               ; Zero itemstruct->iso_pos.screen_x and screen_y
  INC HL                  ;
  LD (HL),A               ;
  CALL draw_all_items     ; Draw both held items
  LD BC,$3030             ; Play the "pick up item" sound
  CALL play_speaker       ;
  RET                     ; Return

; Drop the first held item then shuffle the second into the first slot.
;
; Used by the routine at process_player_input_fire.
;
; Return if no items held.
drop_item:
  LD A,(items_held)       ; Fetch the first held item
  CP $FF                  ; Is the item item_NONE? ($FF)
  RET Z                   ; Return if so - there are no items to drop
; When dropping the uniform reset the hero's sprite.
  CP $06                  ; Does A contain item_UNIFORM? (6)
  JP NZ,drop_item_0       ; Jump if not
  LD HL,sprite_prisoner   ; Set the hero's sprite definition pointer to sprite_prisoner to remove the guard's uniform
  LD ($8015),HL           ;
drop_item_0:
  PUSH AF                 ; Save item
; Shuffle items down.
  LD HL,items_held + $0001 ; Point HL at the second held item
  LD A,(HL)               ; Fetch its value
  LD (HL),$FF             ; Set it to item_NONE
  DEC HL                  ; Now point to the first held item
  LD (HL),A               ; Store the fetched item there
; Redraw
  CALL draw_all_items     ; Draw both held items
  LD BC,$3040             ; Play the "drop item" sound
  CALL play_speaker       ;
  CALL choose_game_window_attributes ; Choose game window attributes
  CALL set_game_window_attributes ; Set game window attributes
  POP AF                  ; Restore item
; FALL THROUGH into drop_item_tail.

; Drop item, tail part.
;
; Used by the routine at action_red_cross_parcel.
;
; I:A Item index.
drop_item_tail:
  CALL item_to_itemstruct ; Convert the item index in A into an itemstruct pointer in HL
  INC HL                  ; Advance HL to point to the room index
  LD A,(room_index)       ; Get the global current room index
  LD (HL),A               ; Set the object's room index
  AND A                   ; Is it outdoors? (room index is zero)
  JR NZ,drop_item_interior ; Jump if not
; Outdoors.
  INC HL                  ; Point HL at itemstruct.pos
  PUSH HL                 ; Save for below
  INC HL                  ; Bug: HL is incremented by two here but then is immediately overwritten by the LD HL at $7BC5.
  INC HL                  ;
  POP DE                  ; Restore itemstruct.pos pointer into DE
  LD HL,$800F             ; Point HL at the hero's map position
  CALL pos_to_tinypos     ; Scale down hero's map position (HL) and assign the result to itemstruct's tinypos (DE). DE is updated to point after tinypos on return
  DEC DE                  ; Point at height field
  LD A,$00                ; Set height to zero
  LD (DE),A               ;
  EX DE,HL                ; Move itemstruct pointer into HL
; FALL THROUGH into calc_exterior_item_iso_pos.

; Calculate isometric screen position for dropped exterior items.
;
; Used by the routine at item_discovered.
;
; I:HL Pointer to itemstruct's pos.height field.
;
; Set C to ($40 + y - x) * 2
calc_exterior_item_iso_pos:
  DEC HL                  ; Step HL back to itemstruct.pos.y
  LD A,$40                ; Start with $40
  ADD A,(HL)              ; Add pos.y
  DEC HL                  ; Subtract pos.x
  SUB (HL)                ;
  ADD A,A                 ; Double the result
  LD C,A                  ; Save it in C
; Set B to ($200 - x - y - height)
  XOR A                   ; Zero the result; this acts like $200 for our purposes
  SUB (HL)                ; Subtract pos.x
  INC HL                  ; Subtract pos.y
  SUB (HL)                ;
  INC HL                  ; Subtract pos.height
  SUB (HL)                ;
  LD B,A                  ; Save it in B
; Write the result to itemstruct.iso_pos
  INC HL                  ; Point HL at itemstruct.iso_pos
  LD (HL),C               ; Store BC
  INC HL                  ;
  LD (HL),B               ;
  RET                     ; Return

; Drop item, interior part.
;
; Used by the routine at drop_item_tail.
;
; I:HL Pointer to itemstruct.room.
drop_item_interior:
  INC HL                  ; Point to itemstruct.x
  LD DE,$800F             ; Point DE at the hero's map position.x
  LD A,(DE)               ; Fetch x
  LD (HL),A               ; Store x in itemstruct.x
  INC HL                  ; Point to itemstruct.y
  INC E                   ; Point DE at the hero's map position.y
  INC E                   ;
  LD A,(DE)               ; Fetch y
  LD (HL),A               ; Store y in itemstruct.y
  INC HL                  ; Point HL at itemstruct.height
  LD (HL),$05             ; Set height to five
; FALL THROUGH into calc_interior_item_iso_pos.

; Calculate isometric screen position for dropped interior items.
;
; TODO: Describe why this has to scale things whereas the above exterior variant doesn't.
;
; Used by the routine at item_discovered.
;
; I:HL Pointer to itemstruct's pos.height field.
;   Set A' to ($200 + y - x) * 2
calc_interior_item_iso_pos:
  DEC HL                  ; Step HL back to itemstruct.pos.y
  LD D,$02                ; Start with $200 + pos.y
  LD E,(HL)               ;
  EX DE,HL                ; Use via DE now
  DEC DE                  ; Step DE back to pos.x
  LD A,(DE)               ; Fetch pos.x
  LD C,A                  ; Widen it to 16-bit
  LD B,$00                ;
  AND A                   ; Clear carry flag
  SBC HL,BC               ; Subtract (widened) pos.x
  ADD HL,HL               ; Double the result
  LD C,H                  ; Move result into (C,A)
  LD A,L                  ;
  CALL divide_by_8_with_rounding ; Divide by 8 with rounding. Result is in A
  EX AF,AF'               ; Bank x result
; Set A to ($800 - x - y - height)
  LD HL,$0800             ; Start with $800
  LD B,$00                ; Load and widen pos.x to 16-bit
  LD A,(DE)               ;
  LD C,A                  ;
  AND A                   ; Clear carry flag
  SBC HL,BC               ; Subtract (widened) pos.x
  INC DE                  ; Advance DE to pos.y
  LD A,(DE)               ; Load and widen pos.y to 16-bit (B already zero)
  LD C,A                  ;
  SBC HL,BC               ; Subtract (widened) pos.y
  INC DE                  ; Advance DE to pos.height
  LD A,(DE)               ; Load and widen pos.height to 16-bit (B already zero)
  LD C,A                  ;
  SBC HL,BC               ; Subtract (widened) pos.height
  LD C,H                  ; Move result into (C,A)
  LD A,L                  ;
  CALL divide_by_8_with_rounding ; Divide by 8 with rounding. Result is in A
; Write the result to itemstruct.iso_pos
  INC DE                  ; Advance DE to itemstruct.iso_pos
  INC DE                  ;
  LD (DE),A               ; Store A (y result)
  DEC DE                  ;
  EX AF,AF'               ; Unbank x result
  LD (DE),A               ; Store A (x result)
  RET                     ; Return

; Convert an item to an itemstruct pointer.
;
; Used by the routines at drop_item_tail, event_new_red_cross_parcel and item_discovered.
;
; I:A Item index.
; O:HL Pointer to itemstruct.
item_to_itemstruct:
  LD L,A                  ; Multiply item index by seven
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  SUB L                   ;
  LD HL,item_structs      ; Point HL at the first element of item_structs
  ADD A,L                 ; Add the two
  LD L,A                  ;
  RET NC                  ;
  INC H                   ;
  RET                     ; Return i'th element of item_structs in HL

; Draw both held items.
;
; Used by the routines at pick_up_item, drop_item, accept_bribe, action_red_cross_parcel, action_poison, reset_game and solitary.
draw_all_items:
  LD HL,$5087             ; Point HL at the screen address of item 1
  LD A,(items_held)       ; Fetch the first held item
  CALL draw_item          ; Draw the item
  LD HL,$508A             ; Point HL at the screen address of item 2
  LD A,($8216)            ; Fetch the second held item
  CALL draw_item          ; Draw the item
  RET                     ; Return

; Draw a single held item.
;
; Used by the routine at draw_all_items.
;
; I:A Item index.
; I:HL Screen address of item.
draw_item:
  PUSH HL                 ; Save screen address of item
  EX AF,AF'               ; Bank item index
; Wipe the item's screen area.
  LD B,$02                ; 2 bytes / pixels wide
  LD C,$10                ; 16 pixels high
  CALL screen_wipe        ; Wipe the screen area pointed to by HL
; Bail if no item.
  POP HL                  ; Retrieve screen address
  EX AF,AF'               ; Retrieve item index
  CP $FF                  ; Is the item index item_NONE? ($FF)
  RET Z                   ; Return if so
; Set screen attributes.
  PUSH HL                 ; Save screen address again
  LD H,$5A                ; Set H to $5A which points HL at the attribute for the equivalent screen address
  PUSH AF                 ; Save item index
  LD BC,item_attributes   ; Get the attribute byte for this item
  ADD A,C                 ;
  LD C,A                  ;
  JR NC,draw_item_0       ;
  INC B                   ;
draw_item_0:
  LD A,(BC)               ;
  LD (HL),A               ; Write two attribute bytes
  INC L                   ;
  LD (HL),A               ;
; Move to next attribute row.
  DEC L                   ; Move HL back for the next row
  SET 5,L                 ; Move HL to the next attribute row
  LD (HL),A               ; Write two attribute bytes
  INC L                   ;
  LD (HL),A               ;
  POP AF                  ; Retrieve item index
; Plot bitmap.
  ADD A,A                 ; Point HL at the definition for this item
  LD C,A                  ;
  ADD A,A                 ;
  ADD A,C                 ;
  LD C,A                  ;
  LD B,$00                ;
  LD HL,item_definitions  ;
  ADD HL,BC               ;
  LD B,(HL)               ; Fetch width
  INC HL                  ;
  LD C,(HL)               ; Fetch height
  INC HL                  ;
  LD E,(HL)               ; Fetch sprite data pointer
  INC HL                  ;
  LD D,(HL)               ;
  POP HL                  ; Retrieve screen address saved at 7C54
  CALL plot_bitmap        ; Plot the bitmap without masking
  RET                     ; Return

; Returns an item within range of the hero.
;
; Used by the routine at pick_up_item.
;
; O:AF Z set if item found, NZ otherwise.
; O:HL If item was found contains pointer to the item.
;
; Select a pick up radius based on the room.
find_nearby_item:
  LD C,$01                ; Set the pick up radius to one
  LD A,(room_index)       ; Fetch the global current room index
  AND A                   ; Is it room_0_OUTDOORS?
  JR Z,find_nearby_item_0 ; Jump if so
  LD C,$06                ; Otherwise set the pick up radius to six
; Loop for all items.
find_nearby_item_0:
  LD B,$10                ; Set B for 16 iterations (item__LIMIT)
  LD HL,$76C9             ; Point HL at the first item_struct's room member
find_nearby_item_loop:
  BIT 7,(HL)              ; Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_7 flag set? ($80)
  JR Z,find_nearby_next   ; If not, jump to the next iteration
  PUSH BC                 ; Save item counter
  PUSH HL                 ; Save item_struct pointer
  INC HL                  ; Point HL at itemstruct position
  LD DE,hero_map_position_x ; Point DE at global map position (hero)
  LD B,$02                ; Do two loop iterations (once for x then y)
; Range check.
find_nearby_position_loop:
  LD A,(DE)               ; Read a map position byte
  SUB C                      ; if (map_pos_byte (A) - pick_up_radius (C) >= itemstruct_byte || map_pos_byte + pick_up_radius < itemstruct_byte) jump to pop_next
  CP (HL)                    ;
  JR NC,find_nearby_pop_next ;
  ADD A,C                    ;
  ADD A,C                    ;
  CP (HL)                    ;
  JR C,find_nearby_pop_next  ;
  INC HL                  ; Move to next itemstruct byte
  INC DE                  ; Move to next map position byte
  DJNZ find_nearby_position_loop ; ...loop for both bytes
  POP HL                  ; Restore item_struct pointer
  DEC HL                  ; Compensate for overshoot. Point to itemstruct.item for return value
  POP BC                  ; Restore item counter
  XOR A                   ; Set Z (found)
; Bug: The next instruction is written as RET Z but there's no need for it to be conditional.
  RET Z                   ; Return
find_nearby_pop_next:
  POP HL                  ; Restore item_struct pointer
  POP BC                  ; Restore item counter
find_nearby_next:
  LD A,$07                 ; Step HL to the next item_struct
  ADD A,L                  ;
  LD L,A                   ;
  JR NC,find_nearby_item_1 ;
  INC H                    ;
find_nearby_item_1:
  DJNZ find_nearby_item_loop ; ...loop for each item
  OR $01                  ; Ran out of items: set NZ (not found)
  RET                     ; Return

; Plot a bitmap without masking.
;
; Used by the routines at draw_item, wave_morale_flag and plot_ringer.
;
; I:BC Dimensions (B x C == width x height, where width is specified in bytes).
; I:DE Source address.
; I:HL Destination address.
plot_bitmap:
  LD A,B                  ; Set A to the byte width of the bitmap
  LD ($7CC3),A            ; Self modify the width counter at $7CC2 to set B to the byte width
plot_bitmap_row:
  LD B,$02                ; Set the column counter to the bitmap width in bytes
  PUSH HL                 ; Save the destination address
plot_bitmap_column:
  LD A,(DE)               ; Copy a byte across
  LD (HL),A               ;
  INC L                   ; Step destination address
  INC DE                  ; Step source address
  DJNZ plot_bitmap_column ; Decrement the column counter then loop for every column
  POP HL                  ; Restore the destination address
  CALL next_scanline_down ; Move the destination address down a scanline
  DEC C                   ; Decrement the row counter
  JP NZ,plot_bitmap_row   ; ...loop for every row
  RET                     ; Return

; Wipe an area of the screen.
;
; Used by the routine at draw_item.
;
; I:BC Dimensions (B x C == width x height, where width is specified in bytes).
; I:HL Destination address.
screen_wipe:
  LD A,B                  ; Set A to the byte width of the area to wipe
  LD ($7CD9),A            ; Self modify the width counter at $7CD8 to set B to the byte width
screen_wipe_row:
  LD B,$02                ; Set the column counter to the bitmap width in bytes
  PUSH HL                 ; Save the destination address
screen_wipe_column:
  LD (HL),$00             ; Wipe a byte
  INC L                   ; Step destination address
  DJNZ screen_wipe_column ; Decrement the column counter then loop for every column
  POP HL                  ; Restore the destination address
  CALL next_scanline_down ; Move the destination address down a scanline
  DEC C                   ; Decrement the row counter
  JP NZ,screen_wipe_row   ; ...loop for every row
  RET                     ; Return

; Given a screen address, return the same position on the next scanline down.
;
; Used by the routines at plot_bitmap, screen_wipe, wave_morale_flag and plot_static_tiles.
;
; I:HL Original screen address.
; O:HL Updated screen address.
next_scanline_down:
  INC H                   ; Incrementing H moves us to the next minor row
  LD A,H
  AND $07                 ; Unless we hit an exact multiple of eight - in which case we stepped to the next third of the screen
  RET NZ                  ; Just return if we didn't
  PUSH DE                 ; Borrow DE for scratch
  LD DE,$F820             ; Step back by a third ($F8), then to the next major row ($20)
  LD A,L                  ; Unless we will hit a boundary in doing that
  CP $E0                  ;
  JR C,next_scanline_down_0 ; Skip, if we won't
  LD D,$FF                ; If we will then step back by a minor row, then to the next major row
next_scanline_down_0:
  ADD HL,DE               ; Step
  POP DE                  ; Restore
  RET                     ; Return

; The pending message queue.
message_queue:
  DEFB $FF,$FF,$00,$00,$00,$00,$00,$00 ; Queue of message indexes. Pairs of bytes + 0xFF terminator.
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$FF                     ;

; Countdown to the next message.
message_display_delay:
  DEFB $00                ; Decrementing counter which shows the next message when it reaches zero.

; Index into the message we're displaying or wiping.
message_display_index:
  DEFB $80                ; If 128 then next_message. If > 128 then wipe_message. Else display.

; Pointer to the next available slot in the message queue.
message_queue_pointer:
  DEFW $7CFE

; Pointer to the next message character to be displayed.
current_message_character:
  DEFW $0000

; Add a new message index to the pending messages queue.
;
; Used by the routines at check_morale, picking_lock, event_another_day_dawns, event_wake_up, event_go_to_roll_call, event_go_to_breakfast_time, event_go_to_exercise_time, event_go_to_time_for_bed, event_new_red_cross_parcel, accept_bribe,
; is_door_locked, action_red_cross_parcel, action_wiresnips, action_lockpick, action_key, solitary, item_discovered and event_roll_call.
;
; The use of C on entry to this routine is puzzling. One routine (check_morale) explicitly sets it to zero before calling, but the other callers do not so we receive whatever was in C previously.
;
; I:B Message index.
; I:C Unknown: possibly a second message index.
queue_message:
  LD HL,(message_queue_pointer) ; Fetch the message queue pointer
  LD A,$FF                ; Is the currently pointed-to index message_QUEUE_END? ($FF)
  CP (HL)                 ;
  RET Z                   ; Return if so - the queue is full
; Is this message index already pending?
  DEC HL                  ; Step back two bytes to the next pending entry
  DEC HL                  ;
  LD A,(HL)               ; If the new message index matches the pending entry then return
  CP B                    ;
  INC HL                  ;
  JR NZ,queue_message_0   ;
  LD A,(HL)               ;
  CP C                    ;
  RET Z                   ;
; Add it to the queue.
queue_message_0:
  INC HL                  ; Store the new message index
  LD (HL),B               ;
  INC HL                  ;
  LD (HL),C               ;
  INC HL                  ;
  LD (message_queue_pointer),HL ; Update the message queue pointer
  RET                     ; Return

; Plot a single glyph (indirectly).
;
; Used by the routines at message_display, plot_score, screenlocstring_plot and choose_keys.
;
; I:HL Pointer to glyph index.
; I:DE Pointer to screen destination.
; O:HL Preserved.
; O:DE Points to the next character position to the right.
plot_glyph:
  LD A,(HL)               ; Fetch the glyph index
; FALL THROUGH into plot_single_glyph,

; Plot a single glyph.
;
; Used by the routine at wipe_message.
;
; Note: This won't work for arbitrary screen locations.
;
; I:HL Glyph index.
; I:DE Pointer to screen destination.
; O:HL Preserved.
; O:DE Points to the next character position to the right.
plot_single_glyph:
  PUSH HL                 ; Preserve HL
  LD L,A                  ; Point HL at the bitmap glyph we want to plot
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,bitmap_font       ;
  ADD HL,BC               ;
  PUSH DE                 ; Preserve DE so we can return it incremented later
  LD B,$08                ; 8 rows
glyph_loop:
  LD A,(HL)               ; Plot a byte (a row) of bitmap glyph
  LD (DE),A               ;
  INC D                   ; Move down to the next scanline (DE increases by 256)
  INC HL                  ; Move to the next byte of the bitmap glyph
  DJNZ glyph_loop         ; ...loop until the glyph is drawn
  POP DE                  ; Restore and point DE at the next character position to the right
  INC DE                  ;
  POP HL                  ; Restore HL
  RET                     ; Return

; Incrementally wipe and display queued game messages.
;
; Used by the routine at main_loop.
;
; Proceed only if message display delay is zero.
message_display:
  LD A,(message_display_delay) ; If message display delay is positive...
  AND A                        ;
  JP Z,message_display_0       ;
  DEC A                        ; Decrement it - we'll get called again until it hits zero
  LD (message_display_delay),A ;
  RET                     ; Return
; Otherwise message_display_delay reached zero.
message_display_0:
  LD A,(message_display_index) ; If message display index == message_NEXT (128) exit via (jump to) next_message
  CP $80                       ;
  JR Z,next_message            ;
  JR NC,wipe_message      ; Otherwise if message display index > message_NEXT exit via (jump to) wipe_message
; Display a character
  LD HL,(current_message_character) ; Otherwise... point HL to the current message character
  LD DE,$50E0             ; Point DE at the message text screen address plus the display index
  OR E                    ;
  LD E,A                  ;
  CALL plot_glyph         ; Plot the glyph
  LD A,E                       ; Save the incremented message display index
  AND $1F                      ;
  LD (message_display_index),A ;
  INC HL                  ; Check for end of string ($FF)
  LD A,(HL)               ;
  CP $FF                  ;
  JP NZ,not_end_of_string ;
; Leave the message for 31 turns, then wipe it.
  LD A,$1F                     ; Set message display delay to 31
  LD (message_display_delay),A ;
  LD A,(message_display_index) ; Set the message_NEXT flag in the message display index
  OR $80                       ;
  LD (message_display_index),A ;
  RET                     ; Return
not_end_of_string:
  LD (current_message_character),HL ; If it wasn't the end of the string set current message character to HL
  RET                     ; Return

; Incrementally wipe away any on-screen game message.
;
; Used by the routine at message_display.
wipe_message:
  LD A,(message_display_index) ; Decrement the message display index
  DEC A                        ;
  LD (message_display_index),A ;
  LD DE,$50E0             ; Point DE at the message text screen address plus the display index
  OR E                    ;
  LD E,A                  ;
; Overplot the previous character with a single space.
  LD A,$23                ; Glyph index of space
  CALL plot_single_glyph  ; Plot the single space glyph
  RET                     ; Return

; Change to displaying the next queued game message.
;
; Used by the routine at message_display.
;
; Called when messages.display_index == 128.
next_message:
  LD HL,(message_queue_pointer) ; Get the message queue pointer
  LD DE,$7CFE             ; Queue start address
  LD A,L                  ; Is the queue pointer at the start of the queue?
  CP E                    ;
  RET Z                   ; Return if so
  EX DE,HL
  LD A,(HL)               ; Get message index from queue
  INC HL                  ;
  LD C,(HL)               ; Bug: C is loaded here but not used. This could be a hangover from 16-bit message IDs
  ADD A,A                           ; Set current message character pointer to messages_table[A]
  LD HL,messages_table              ;
  LD E,A                            ;
  LD D,$00                          ;
  ADD HL,DE                         ;
  LD E,(HL)                         ;
  INC HL                            ;
  LD D,(HL)                         ;
  EX DE,HL                          ;
  LD (current_message_character),HL ;
  LD DE,message_queue     ; Shunt the whole queue back by two bytes discarding the first element
  LD HL,$7CFE             ;
  LD BC,$0010             ;
  LDIR                    ;
  LD HL,(message_queue_pointer) ; Move the message queue pointer back
  DEC HL                        ;
  DEC HL                        ;
  LD (message_queue_pointer),HL ;
  XOR A                        ; Zero the message display index
  LD (message_display_index),A ;
  RET                     ; Return

; Array of pointers to game messages.
messages_table:
  DEFW messages_missed_roll_call
  DEFW messages_time_to_wake_up
  DEFW messages_breakfast_time
  DEFW messages_exercise_time
  DEFW messages_time_for_bed
  DEFW messages_the_door_is_locked
  DEFW messages_it_is_open
  DEFW messages_incorrect_key
  DEFW messages_roll_call
  DEFW messages_red_cross_parcel
  DEFW messages_picking_the_lock
  DEFW messages_cutting_the_wire
  DEFW messages_you_open_the_box
  DEFW messages_you_are_in_solitary
  DEFW messages_wait_for_release
  DEFW messages_morale_is_zero
  DEFW messages_item_discovered
  DEFW more_messages_he_takes_the_bribe
  DEFW more_messages_and_acts_as_decoy
  DEFW more_messages_another_day_dawns

; Game messages.
;
; Non-ASCII: encoded to match the font; $FF terminated.
messages_missed_roll_call:
  DEFB $16,$12,$1B,$1B,$0E,$0D,$23,$1A,$00,$15,$15,$23,$0C,$0A,$15,$15,$FF ; "MISSED ROLL CALL"
messages_time_to_wake_up:
  DEFB $1C,$12,$16,$0E,$23,$1C,$00,$23,$1F,$0A,$14,$0E,$23,$1D,$18,$FF ; "TIME TO WAKE UP"
messages_breakfast_time:
  DEFB $0B,$1A,$0E,$0A,$14,$0F,$0A,$1B,$1C,$23,$1C,$12,$16,$0E,$FF ; "BREAKFAST TIME"
messages_exercise_time:
  DEFB $0E,$20,$0E,$1A,$0C,$12,$1B,$0E,$23,$1C,$12,$16,$0E,$FF ; "EXERCISE TIME"
messages_time_for_bed:
  DEFB $1C,$12,$16,$0E,$23,$0F,$00,$1A,$23,$0B,$0E,$0D,$FF ; "TIME FOR BED"
messages_the_door_is_locked:
  DEFB $1C,$11,$0E,$23,$0D,$00,$00,$1A,$23,$12,$1B,$23,$15,$00,$0C,$14,$0E,$0D,$FF ; "THE DOOR IS LOCKED"
messages_it_is_open:
  DEFB $12,$1C,$23,$12,$1B,$23,$00,$18,$0E,$17,$FF ; "IT IS OPEN"
messages_incorrect_key:
  DEFB $12,$17,$0C,$00,$1A,$1A,$0E,$0C,$1C,$23,$14,$0E,$21,$FF ; "INCORRECT KEY"
messages_roll_call:
  DEFB $1A,$00,$15,$15,$23,$0C,$0A,$15,$15,$FF ; "ROLL CALL"
messages_red_cross_parcel:
  DEFB $1A,$0E,$0D,$23,$0C,$1A,$00,$1B,$1B,$23,$18,$0A,$1A,$0C,$0E,$15,$FF ; "RED CROSS PARCEL"
messages_picking_the_lock:
  DEFB $18,$12,$0C,$14,$12,$17,$10,$23,$1C,$11,$0E,$23,$15,$00,$0C,$14,$FF ; "PICKING THE LOCK"
messages_cutting_the_wire:
  DEFB $0C,$1D,$1C,$1C,$12,$17,$10,$23,$1C,$11,$0E,$23,$1F,$12,$1A,$0E,$FF ; "CUTTING THE WIRE"
messages_you_open_the_box:
  DEFB $21,$00,$1D,$23,$00,$18,$0E,$17,$23,$1C,$11,$0E,$23,$0B,$00,$20,$FF ; "YOU OPEN THE BOX"
messages_you_are_in_solitary:
  DEFB $21,$00,$1D,$23,$0A,$1A,$0E,$23,$12,$17,$23,$1B,$00,$15,$12,$1C,$0A,$1A,$21,$FF ; "YOU ARE IN SOLITARY"
messages_wait_for_release:
  DEFB $1F,$0A,$12,$1C,$23,$0F,$00,$1A,$23,$1A,$0E,$15,$0E,$0A,$1B,$0E,$FF ; "WAIT FOR RELEASE"
messages_morale_is_zero:
  DEFB $16,$00,$1A,$0A,$15,$0E,$23,$12,$1B,$23,$22,$0E,$1A,$00,$FF ; "MORALE IS ZERO"
messages_item_discovered:
  DEFB $12,$1C,$0E,$16,$23,$0D,$12,$1B,$0C,$00,$1E,$0E,$1A,$0E,$0D,$FF ; "ITEM DISCOVERED"

; Unreferenced bytes.
;
; Two alignment bytes to make static_tiles start at $7F00.
L7EFE:
  DEFB $00,$00

; Static tiles.
;
; These tiles are used to draw fixed screen elements such as medals.
;
; 9 bytes each: 8x8 bitmap + 1 byte attribute. 75 tiles.
static_tiles:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00,$07 ; blank
  DEFB $00,$00,$00,$00,$03,$04,$09,$0C,$06 ; speaker_tl_tl
  DEFB $00,$00,$00,$00,$E0,$50,$10,$58,$06 ; speaker_tl_tr
  DEFB $08,$0C,$09,$07,$01,$00,$00,$00,$06 ; speaker_tl_bl
  DEFB $98,$3C,$7C,$FB,$FC,$6F,$17,$16,$06 ; speaker_tl_br
  DEFB $00,$00,$00,$00,$07,$0A,$08,$1C,$06 ; speaker_tr_tl
  DEFB $00,$00,$00,$00,$C0,$A0,$10,$50,$06 ; speaker_tr_tr
  DEFB $19,$3C,$3E,$DF,$3F,$F6,$E8,$68,$06 ; speaker_tr_bl
  DEFB $10,$B0,$10,$E0,$80,$00,$00,$00,$06 ; speaker_tr_br
  DEFB $68,$E8,$F6,$3F,$DF,$3E,$3C,$18,$06 ; speaker_br_tl
  DEFB $00,$00,$00,$80,$E0,$90,$30,$90,$06 ; speaker_br_tr
  DEFB $19,$08,$0A,$07,$00,$00,$00,$00,$06 ; speaker_br_bl
  DEFB $30,$10,$20,$C0,$00,$00,$00,$00,$06 ; speaker_br_br
  DEFB $00,$00,$00,$01,$07,$08,$0C,$09,$06 ; speaker_bl_tl
  DEFB $16,$17,$6F,$FC,$FB,$7C,$3C,$18,$06 ; speaker_bl_tr
  DEFB $0C,$08,$05,$03,$00,$00,$00,$00,$06 ; speaker_bl_bl
  DEFB $98,$10,$10,$E0,$00,$00,$00,$00,$06 ; speaker_bl_br
  DEFB $10,$10,$91,$42,$5A,$24,$18,$24,$06 ; barbwire_v_top
  DEFB $18,$24,$52,$52,$91,$10,$10,$10,$06 ; barbwire_v_bottom
  DEFB $10,$0C,$02,$FD,$01,$02,$0C,$10,$06 ; barbwire_h_left
  DEFB $04,$18,$A0,$57,$50,$A0,$18,$04,$06 ; barbwire_h_right
  DEFB $02,$01,$00,$FF,$00,$00,$01,$02,$06 ; barbwire_h_wide_left
  DEFB $00,$83,$54,$AA,$2A,$54,$83,$00,$06 ; barbwire_h_wide_middle
  DEFB $80,$00,$00,$FF,$00,$00,$00,$80,$06 ; barbwire_h_wide_right
  DEFB $00,$00,$00,$FE,$38,$38,$3E,$38,$07 ; flagpole_top
  DEFB $3A,$3A,$3A,$3A,$3A,$3A,$3A,$3A,$07 ; flagpole_middle
  DEFB $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C,$07 ; flagpole_bottom
  DEFB $7C,$7C,$7C,$7A,$B5,$74,$7A,$FB,$07 ; flagpole_ground1
  DEFB $00,$00,$10,$49,$49,$D5,$D4,$FD,$04 ; flagpole_ground2
  DEFB $00,$00,$00,$42,$A4,$2A,$5A,$BD,$04 ; flagpole_ground3
  DEFB $00,$00,$00,$00,$40,$80,$D0,$A6,$04 ; flagpole_ground4
  DEFB $00,$00,$00,$00,$0A,$24,$55,$DB,$04 ; flagpole_ground0
  DEFB $00,$00,$00,$00,$1F,$08,$06,$06,$03 ; medal_0_0
  DEFB $00,$00,$00,$00,$FF,$00,$BA,$BA,$07 ; medal_0_1/3/5/7/9
  DEFB $00,$00,$00,$00,$FF,$30,$CE,$CE,$03 ; medal_0_2
  DEFB $00,$00,$00,$00,$FF,$18,$E6,$E6,$03 ; medal_0_4
  DEFB $00,$00,$00,$00,$FF,$28,$C6,$C6,$03 ; medal_0_6
  DEFB $00,$00,$00,$00,$F8,$10,$E0,$E0,$03 ; medal_0_8
  DEFB $06,$06,$06,$06,$06,$06,$06,$06,$03 ; medal_1_0
  DEFB $CE,$CE,$CE,$CE,$CE,$CE,$CE,$CE,$03 ; medal_1_2
  DEFB $E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$03 ; medal_1_4
  DEFB $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$03 ; medal_1_6
  DEFB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$03 ; medal_1_8
  DEFB $06,$06,$06,$06,$02,$04,$07,$00,$03 ; medal_1_10
  DEFB $00,$BA,$BA,$BA,$BA,$00,$FF,$10,$07 ; medal_2_0
  DEFB $CE,$CE,$CE,$CE,$86,$48,$CF,$00,$03 ; medal_2_1/3/5/7/9
  DEFB $E6,$E6,$E6,$E6,$C2,$24,$E7,$00,$03 ; medal_2_2
  DEFB $C6,$C6,$C6,$C6,$82,$44,$C7,$00,$03 ; medal_2_4
  DEFB $E0,$E0,$E0,$E0,$C0,$20,$E0,$00,$03 ; medal_2_6
  DEFB $03,$02,$02,$02,$02,$01,$02,$02,$07 ; medal_2_8
  DEFB $EF,$38,$FE,$AA,$B2,$FF,$96,$A2,$07 ; medal_2_10
  DEFB $80,$81,$83,$87,$86,$0E,$8E,$86,$06 ; medal_3_0
  DEFB $7C,$FF,$C7,$11,$E0,$72,$5C,$A6,$06 ; medal_3_1
  DEFB $00,$00,$81,$C1,$C3,$E3,$E3,$C1,$06 ; medal_3_2
  DEFB $38,$FE,$C7,$AB,$6D,$01,$6D,$AB,$06 ; medal_3_3
  DEFB $00,$00,$00,$00,$8C,$8F,$8B,$08,$05 ; medal_3_4
  DEFB $FE,$C6,$6C,$6C,$28,$39,$D7,$6C,$05 ; medal_3_5
  DEFB $00,$00,$00,$01,$61,$E6,$A6,$26,$04 ; medal_3_6
  DEFB $38,$38,$C6,$BB,$45,$BA,$BA,$BA,$04 ; medal_3_7
  DEFB $00,$00,$00,$00,$00,$C0,$C0,$C0,$04 ; medal_3_8
  DEFB $02,$02,$03,$00,$00,$00,$00,$00,$07 ; medal_3_9
  DEFB $FE,$10,$EF,$00,$00,$00,$00,$00,$07 ; medal_4_0
  DEFB $87,$83,$81,$00,$00,$00,$00,$00,$06 ; medal_4_1
  DEFB $19,$C7,$FF,$7C,$00,$00,$00,$00,$06 ; medal_4_2
  DEFB $C1,$80,$00,$00,$00,$00,$00,$00,$06 ; medal_4_3
  DEFB $C7,$FE,$38,$00,$00,$00,$00,$00,$06 ; medal_4_4
  DEFB $0B,$0F,$0C,$00,$00,$00,$00,$00,$05 ; medal_4_5
  DEFB $D7,$39,$28,$6C,$6C,$C6,$FE,$00,$05 ; medal_4_6
  DEFB $A1,$E1,$60,$00,$00,$00,$00,$00,$05 ; medal_4_7
  DEFB $45,$BB,$C6,$38,$38,$00,$00,$00,$04 ; medal_4_8
  DEFB $00,$00,$00,$01,$03,$03,$06,$06,$06 ; medal_4_9
  DEFB $00,$00,$7E,$FF,$8F,$7F,$FF,$FF,$06 ; bell_top_middle
  DEFB $00,$00,$00,$80,$C0,$C0,$E0,$E0,$06 ; bell_top_right
  DEFB $06,$E7,$E7,$87,$83,$43,$41,$20,$06 ; bell_middle_left
  DEFB $E7,$E7,$FF,$FF,$FE,$F9,$FF,$7E,$06 ; bell_middle_middle

; Unreferenced byte.
L81A3:
  DEFB $E0

; Saved/stashed position.
;
; Structure type: pos_t.
saved_pos_x:
  DEFW $60E0
saved_pos_y:
  DEFW $C060
saved_height:
  DEFW $80C0

; Used by touch() only.
touch_stashed_A:
  DEFB $00

; Unreferenced byte.
L81AB:
  DEFB $06

; Bitmap and mask pointers.
bitmap_pointer:
  DEFW $0810
mask_pointer:
  DEFW $0204
foreground_mask_pointer:
  DEFW $0102

; Saved/stashed position.
;
; Structure type: tinypos_t.
;
; Written by setup_item_plotting, setup_vischar_plotting.
;
; Read by render_mask_buffer, guards_follow_suspicious_character.
tinypos_stash_x:
  DEFB $01
tinypos_stash_y:
  DEFB $00
tinypos_stash_height:
  DEFB $06

; Current vischar's isometric projected map position.
iso_pos_x:
  DEFB $81
iso_pos_y:
  DEFB $FF

; Controls character left/right flipping.
flip_sprite:
  DEFB $E7

; Hero's map position.
;
; Structure type: tinypos_t.
hero_map_position_x:
  DEFB $DB
hero_map_position_y:
  DEFB $DB
hero_map_position_height:
  DEFB $FF

; Map position.
;
; Used when drawing tiles.
map_position:
  DEFW $FF81

; Searchlight state.
;
; Suspect that this is a 'hero has been found in searchlight' flag. (possible states: 0, 31, 255)
;
; Used by the routines at nighttime, plot_sprites.
;
; +-------+----------------------------------+
; | Value | Meaning                          |
; +-------+----------------------------------+
; | 0     | Searchlight is sweeping          |
; | 31    | Searchlight is tracking the hero |
; | 255   | Searchlight is off               |
; +-------+----------------------------------+
searchlight_state:
  DEFB $04

; Copy of first byte of current room def.
;
; Indexes roomdef_dimensions[].
roomdef_bounds_index:
  DEFB $00

; Count of object bounds.
roomdef_object_bounds_count:
  DEFB $38

; Copy of current room def's additional bounds (allows for four room objects).
roomdef_object_bounds:
  DEFB $44,$CA,$D2,$E2
  DEFB $7C,$38,$47,$00
  DEFB $00,$00,$00,$00
  DEFB $00,$00,$00,$00

; Unreferenced bytes.
;
; These are possibly spare object bounds bytes, but not ever used.
L81D0:
  DEFB $00,$00,$00,$00,$00,$00

; Indices of interior doors.
;
; Used by the routines at setup_doors, door_handling_interior, get_nearest_door.
interior_doors:
  DEFB $FF,$FF,$FF,$FF

; Interior mask data.
;
; Used by the routines at setup_room and render_mask_buffer.
;
; The first byte is a count, followed by 'count' mask_t's:
;
; +-----------+-------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------+
; | Type      | Bytes | Name   | Meaning                                                                                                                                          |
; +-----------+-------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------+
; | Byte      | 1     | index  | Index into mask_pointers                                                                                                                         |
; | bounds_t  | 4     | bounds | Isometric projected bounds of the mask. Used for culling.                                                                                        |
; | tinypos_t | 3     | pos    | If a character is behind this point then the mask is enabled. ("Behind" here means when character coord x is greater and y is greater-or-equal). |
; +-----------+-------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------+
interior_mask_data:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00

; Written to by setup_item_plotting setup_item_plotting but never read.
saved_item:
  DEFB $00

; A copy of item_definition height.
;
; Used by the routines at setup_item_plotting, item_visible.
item_height:
  DEFB $00

; The items which the hero is holding.
;
; Each byte holds one item. Initialised to 0xFFFF meaning no item in either slot.
items_held:
  DEFW $FF05

; The current character index.
character_index:
  DEFB $00

; Tiles
;
; Exterior tiles set 0. 111 tiles.
mask_tiles:
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
  DEFB $FF,$FF,$FF,$FC,$F0,$C0,$C0,$00
  DEFB $F0,$C0,$00,$00,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC
  DEFB $FF,$FF,$FF,$FC,$F0,$C0,$00,$00
  DEFB $FF,$FF,$FF,$FF,$FF,$F0,$00,$00
  DEFB $FF,$FF,$FF,$F0,$00,$00,$00,$00
  DEFB $FF,$F0,$00,$00,$00,$00,$00,$00
  DEFB $7F,$3F,$1F,$0F,$07,$03,$01,$00
  DEFB $FF,$7F,$3F,$1F,$0F,$07,$07,$03
  DEFB $FF,$FF,$7F,$3F,$3F,$1F,$0F,$07
  DEFB $03,$03,$01,$00,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$7F,$3F,$1F,$1F
  DEFB $0F,$07,$03,$01,$01,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$7F,$3F
  DEFB $3F,$1F,$3F,$7F,$7F,$7F,$7F,$7F
  DEFB $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
  DEFB $03,$C0,$F0,$F0,$F8,$D8,$00,$00
  DEFB $C3,$81,$03,$01,$03,$00,$00,$10
  DEFB $FF,$FF,$FF,$FF,$FF,$DF,$0F,$0D
  DEFB $C0,$80,$00,$00,$03,$07,$03,$00
  DEFB $FF,$DF,$0F,$0D,$00,$00,$B0,$F0
  DEFB $00,$00,$B0,$F0,$FB,$DF,$0F,$0D
  DEFB $00,$04,$07,$07,$07,$07,$07,$03
  DEFB $CF,$0F,$03,$80,$90,$9C,$CF,$CF
  DEFB $00,$00,$B0,$D0,$0B,$0F,$03,$00
  DEFB $90,$9C,$CF,$CF,$CF,$0F,$0F,$03
  DEFB $0E,$0E,$0E,$02,$90,$9C,$CE,$CE
  DEFB $00,$00,$00,$03,$0F,$3F,$FF,$FF
  DEFB $0E,$0E,$0E,$02,$B0,$FC,$FE,$FE
  DEFB $0F,$0F,$0F,$03,$B0,$FC,$FF,$FF
  DEFB $00,$9C,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $00,$00,$0D,$0B,$D8,$F8,$C0,$01
  DEFB $FF,$FF,$FF,$FF,$FF,$FB,$F0,$B0
  DEFB $C3,$81,$C0,$80,$C0,$00,$00,$08
  DEFB $00,$03,$0F,$0F,$1F,$1B,$00,$00
  DEFB $FF,$FB,$F0,$B0,$00,$00,$0D,$0F
  DEFB $00,$00,$0D,$0F,$DF,$FB,$F0,$B0
  DEFB $00,$01,$00,$00,$C0,$E0,$C0,$00
  DEFB $F0,$F8,$F1,$C1,$09,$39,$F3,$F3
  DEFB $00,$20,$E0,$E0,$E0,$E0,$E0,$C0
  DEFB $09,$39,$F3,$F3,$F3,$F0,$F0,$C0
  DEFB $00,$00,$00,$C0,$F0,$FC,$FF,$FF
  DEFB $00,$39,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $79,$7C,$70,$40,$0D,$3F,$7F,$7F
  DEFB $7B,$78,$70,$41,$09,$39,$73,$73
  DEFB $FF,$FF,$FF,$3F,$0F,$03,$00,$00
  DEFB $F0,$F0,$C0,$00,$0D,$3F,$FF,$FF
  DEFB $0F,$03,$00,$00,$00,$00,$00,$00
  DEFB $9F,$0F,$07,$0F,$0F,$07,$0F,$9F
  DEFB $F9,$F0,$E0,$F0,$F0,$E0,$F0,$F9
  DEFB $C0,$C0,$C1,$C0,$C0,$C0,$C0,$00
  DEFB $03,$03,$83,$03,$03,$03,$03,$00
  DEFB $00,$00,$00,$00,$00,$38,$FE,$FF
  DEFB $0F,$3F,$7F,$7F,$7F,$7F,$7F,$7F
  DEFB $01,$01,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$00,$00,$00,$01,$03,$03
  DEFB $00,$00,$00,$00,$00,$80,$C0,$C0
  DEFB $80,$80,$80,$80,$80,$80,$80,$80
  DEFB $F0,$FC,$FE,$FE,$FE,$FE,$FE,$FE
  DEFB $00,$00,$00,$00,$00,$1C,$7F,$FF
  DEFB $00,$00,$00,$00,$00,$00,$00,$03
  DEFB $00,$00,$00,$00,$00,$00,$00,$C0
  DEFB $0F,$3F,$FF,$FF,$FF,$FF,$FC,$F0
  DEFB $00,$00,$00,$03,$01,$03,$07,$1F
  DEFB $1F,$1F,$1C,$10,$00,$00,$00,$00
  DEFB $C0,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$FF,$FC,$F0,$C0,$00,$00,$00
  DEFB $03,$00,$00,$00,$00,$00,$00,$00
  DEFB $FF,$FF,$3F,$0F,$03,$00,$00,$00
  DEFB $F0,$FC,$FF,$FF,$FF,$FF,$3F,$0F
  DEFB $00,$00,$00,$C0,$80,$C0,$E0,$F0
  DEFB $80,$C0,$E0,$E0,$E0,$E0,$E0,$E0
  DEFB $F8,$F8,$38,$08,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F
  DEFB $00,$00,$01,$01,$01,$01,$01,$01
  DEFB $00,$00,$80,$80,$80,$80,$80,$80
  DEFB $3F,$0F,$03,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$10,$1C,$8F,$8F
  DEFB $00,$00,$00,$00,$10,$1C,$8C,$8C
  DEFB $00,$00,$00,$00,$00,$00,$80,$80
  DEFB $0C,$0C,$00,$00,$10,$1C,$8C,$8C
  DEFB $0F,$0F,$03,$00,$00,$C0,$F0,$FC
  DEFB $0C,$0C,$00,$00,$00,$C0,$F0,$FC
  DEFB $FC,$D8,$08,$08,$00,$00,$B0,$F8
  DEFB $3F,$1B,$10,$10,$00,$00,$0D,$1F
  DEFB $38,$08,$00,$00,$10,$18,$88,$88
  DEFB $1C,$10,$00,$00,$08,$18,$11,$11
  DEFB $FF,$FF,$FF,$FF,$FF,$3F,$0F,$03
  DEFB $FF,$3F,$0F,$03,$00,$00,$00,$00
  DEFB $FF,$FC,$F0,$C0,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FF,$FF,$FC,$F0,$C0
  DEFB $3F,$3F,$1F,$0F,$0F,$03,$00,$00
  DEFB $7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF
  DEFB $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
  DEFB $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
  DEFB $FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF
  DEFB $FF,$FF,$FC,$F0,$C0,$00,$03,$0F
  DEFB $C0,$00,$02,$0E,$3E,$FE,$FE,$FE
  DEFB $03,$00,$40,$70,$7C,$7F,$7F,$7F
  DEFB $FF,$FF,$3F,$0F,$03,$00,$C0,$F0
  DEFB $FF,$FF,$3F,$0F,$07,$0F,$0F,$0F
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$3F,$0F
  DEFB $07,$07,$07,$07,$07,$07,$07,$07
  DEFB $0F,$03,$00,$10,$18,$08,$00,$00
  DEFB $FF,$FF,$3F,$1F,$3F,$FF,$7F,$7F
  DEFB $FF,$FF,$FF,$FF,$FF,$F3,$C1,$01
  DEFB $FE,$FE,$FE,$FE,$FE,$FC,$F0,$C0
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE
; Exterior tiles. 145 + 220 + 206 tiles. (<- plot_tile)
exterior_tiles:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $80,$80,$80,$80,$80,$80,$80,$80
  DEFB $FF,$F0,$00,$8C,$C3,$B0,$80,$C0
  DEFB $00,$20,$06,$00,$03,$4C,$03,$3F
  DEFB $03,$0C,$30,$C0,$03,$3F,$FF,$F0
  DEFB $0F,$F0,$03,$3F,$FF,$F0,$00,$00
  DEFB $06,$3F,$FF,$F1,$00,$00,$00,$00
  DEFB $00,$40,$00,$08,$03,$0C,$30,$C0
  DEFB $23,$0C,$30,$C0,$0F,$F0,$0F,$F0
  DEFB $0F,$F0,$0F,$F0,$03,$CF,$3F,$FF
  DEFB $03,$CF,$3F,$FF,$FC,$F2,$C9,$24
  DEFB $FC,$F2,$C9,$04,$82,$49,$20,$90
  DEFB $FC,$72,$A9,$C4,$E2,$75,$78,$38
  DEFB $1C,$0E,$07,$07,$03,$01,$00,$00
  DEFB $49,$24,$12,$A9,$C5,$C4,$E2,$71
  DEFB $38,$3D,$1E,$0E,$07,$03,$01,$01
  DEFB $92,$4A,$29,$24,$12,$89,$D4,$E2
  DEFB $E2,$71,$38,$1C,$1E,$0F,$07,$03
  DEFB $49,$24,$92,$49,$A5,$14,$12,$89
  DEFB $01,$00,$00,$00,$00,$00,$00,$00
  DEFB $C4,$EA,$F1,$71,$38,$1C,$0E,$0F
  DEFB $07,$03,$01,$00,$05,$03,$31,$09
  DEFB $30,$00,$00,$80,$80,$80,$80,$80
  DEFB $92,$49,$24,$92,$4A,$29,$A4,$90
  DEFB $48,$28,$A4,$92,$49,$24,$92,$49
  DEFB $25,$94,$52,$49,$24,$92,$49,$24
  DEFB $20,$92,$48,$24,$92,$4A,$29,$A4
  DEFB $04,$92,$41,$21,$90,$50,$49,$24
  DEFB $49,$24,$92,$49,$25,$14,$12,$09
  DEFB $42,$21,$A0,$90,$49,$24,$92,$49
  DEFB $92,$4A,$29,$24,$12,$09,$24,$82
  DEFB $49,$24,$12,$09,$25,$84,$42,$41
  DEFB $90,$48,$24,$92,$4A,$29,$A4,$92
  DEFB $03,$CE,$3E,$FE,$FC,$F0,$C6,$20
  DEFB $0C,$F2,$F5,$F0,$F0,$EF,$EF,$EF
  DEFB $6F,$0F,$06,$00,$63,$0C,$B2,$49
  DEFB $92,$49,$24,$92,$4A,$29,$24,$12
  DEFB $69,$0C,$32,$C9,$05,$94,$42,$41
  DEFB $00,$10,$00,$04,$40,$00,$0F,$F0
  DEFB $00,$04,$40,$00,$0F,$F0,$03,$3C
  DEFB $00,$00,$0F,$F0,$03,$0F,$3F,$FF
  DEFB $03,$CF,$3F,$FF,$FC,$F2,$C9,$24
  DEFB $10,$80,$C2,$20,$90,$48,$24,$92
  DEFB $00,$08,$80,$40,$22,$90,$50,$48
  DEFB $24,$92,$49,$24,$92,$4A,$29,$A4
  DEFB $20,$00,$04,$80,$80,$40,$22,$90
  DEFB $02,$00,$20,$00,$02,$80,$40,$40
  DEFB $20,$90,$48,$24,$94,$52,$49,$24
  DEFB $00,$00,$0C,$00,$80,$02,$00,$80
  DEFB $00,$C0,$00,$04,$00,$00,$20,$01
  DEFB $94,$52,$49,$24,$93,$4C,$B3,$CC
  DEFB $93,$4C,$33,$CE,$32,$C2,$02,$02
  DEFB $30,$C0,$00,$00,$00,$00,$00,$00
  DEFB $94,$52,$49,$24,$93,$4C,$33,$CC
  DEFB $93,$4C,$33,$CC,$30,$C0,$00,$00
  DEFB $93,$4C,$33,$CC,$32,$C6,$06,$06
  DEFB $06,$06,$06,$06,$06,$06,$06,$06
  DEFB $30,$C3,$00,$33,$CF,$3C,$F0,$C0
  DEFB $CF,$3C,$F1,$C1,$01,$81,$81,$81
  DEFB $00,$30,$42,$04,$10,$C3,$08,$03
  DEFB $30,$C3,$00,$03,$4F,$3C,$F1,$C1
  DEFB $CE,$3D,$F3,$C3,$03,$03,$03,$03
  DEFB $03,$0D,$33,$C3,$03,$03,$03,$03
  DEFB $01,$81,$81,$81,$83,$8D,$B1,$C1
  DEFB $C0,$C0,$C0,$C0,$C3,$CC,$F0,$C0
  DEFB $82,$8D,$B1,$C1,$81,$81,$81,$C1
  DEFB $81,$83,$85,$85,$81,$81,$81,$81
  DEFB $83,$43,$43,$00,$03,$0F,$3F,$7C
  DEFB $C1,$C2,$C2,$C0,$C0,$C0,$C0,$C0
  DEFB $A1,$A1,$81,$80,$83,$8F,$BF,$BC
  DEFB $81,$8E,$BF,$BC,$71,$CC,$10,$00
  DEFB $70,$C0,$10,$C0,$0C,$30,$01,$07
  DEFB $C3,$CF,$DF,$DC,$D3,$C4,$30,$C1
  DEFB $86,$0E,$36,$46,$0E,$36,$C7,$07
  DEFB $8C,$10,$C1,$07,$1F,$7C,$F0,$C0
  DEFB $1F,$7C,$F0,$C0,$02,$00,$00,$18
  DEFB $01,$06,$88,$00,$06,$18,$21,$07
  DEFB $CC,$D0,$C1,$C7,$DF,$FC,$F0,$C0
  DEFB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  DEFB $0F,$3C,$F0,$C0,$00,$00,$00,$00
  DEFB $C0,$C0,$C0,$C0,$C0,$C0,$D0,$DC
  DEFB $C0,$C0,$C0,$C0,$00,$C0,$00,$C0
  DEFB $C0,$C0,$C0,$C0,$C0,$C3,$CF,$DF
  DEFB $00,$03,$0F,$3F,$FC,$F0,$C3,$0F
  DEFB $C0,$06,$C0,$21,$30,$C8,$F4,$CE
  DEFB $01,$01,$01,$01,$01,$01,$01,$01
  DEFB $03,$0D,$21,$01,$0D,$31,$81,$05
  DEFB $1A,$7B,$F3,$C3,$03,$03,$13,$01
  DEFB $32,$02,$0A,$12,$C2,$0A,$32,$42
  DEFB $0A,$12,$82,$0A,$22,$C2,$0A,$32
  DEFB $C2,$02,$32,$C2,$0A,$32,$82,$02
  DEFB $1A,$7A,$F2,$C2,$02,$02,$02,$22
  DEFB $8C,$B0,$C1,$87,$DF,$BC,$B0,$80
  DEFB $40,$D0,$C2,$C0,$C0,$C0,$CA,$80
  DEFB $02,$03,$03,$03,$03,$03,$03,$01
  DEFB $31,$0D,$83,$E1,$FB,$3D,$0D,$01
  DEFB $09,$C3,$31,$0D,$C3,$11,$0D,$C3
  DEFB $C3,$31,$0D,$81,$31,$0D,$43,$31
  DEFB $01,$09,$03,$01,$0D,$03,$11,$0D
  DEFB $06,$07,$0E,$16,$06,$06,$16,$06
  DEFB $0E,$36,$07,$0E,$26,$46,$0E,$36
  DEFB $F8,$3E,$0F,$43,$00,$00,$04,$08
  DEFB $03,$20,$0C,$C3,$30,$08,$83,$E0
  DEFB $C0,$C0,$C0,$E0,$F8,$3E,$CF,$C3
  DEFB $F0,$C8,$C2,$E0,$C8,$C0,$E0,$C0
  DEFB $10,$0C,$82,$E0,$F8,$3E,$0F,$03
  DEFB $C0,$C0,$C0,$C0,$C0,$C0,$30,$FC
  DEFB $58,$DE,$CF,$C3,$C0,$C0,$C8,$84
  DEFB $C0,$B0,$84,$C0,$B0,$8C,$81,$A0
  DEFB $4A,$29,$A4,$92,$49,$24,$92,$49
  DEFB $93,$4C,$33,$CC,$31,$C1,$01,$01
  DEFB $3C,$D0,$E3,$F7,$FB,$3C,$0E,$03
  DEFB $3F,$FC,$F0,$C0,$00,$0C,$00,$00
  DEFB $03,$00,$60,$00,$01,$00,$00,$08
  DEFB $00,$00,$00,$00,$00,$00,$C0,$C0
  DEFB $02,$02,$02,$02,$02,$02,$02,$02
  DEFB $90,$C2,$8C,$B0,$C3,$84,$B0,$80
  DEFB $C3,$84,$B0,$C3,$8C,$90,$C3,$8C
  DEFB $84,$B0,$C0,$8C,$90,$C3,$84,$B0
  DEFB $90,$C0,$80,$B0,$C0,$84,$90,$C0
  DEFB $00,$00,$00,$80,$00,$00,$C0,$00
  DEFB $10,$C0,$08,$30,$80,$0C,$20,$C0
  DEFB $08,$30,$C2,$04,$30,$80,$08,$20
  DEFB $00,$00,$00,$00,$03,$08,$10,$01
  DEFB $0C,$10,$C3,$0C,$20,$03,$04,$00
  DEFB $00,$00,$00,$10,$00,$0C,$30,$42
  DEFB $01,$01,$03,$01,$01,$03,$09,$01
  DEFB $D0,$C1,$CC,$D0,$C2,$CC,$D0,$C3
  DEFB $C0,$C0,$D0,$C0,$C8,$D0,$C2,$C4
  DEFB $00,$10,$C3,$F0,$FC,$CF,$C3,$C0
  DEFB $00,$20,$0C,$C0,$30,$0C,$C2,$F0
  DEFB $3C,$0F,$03,$00,$00,$00,$00,$00
  DEFB $00,$00,$D0,$CC,$C1,$F0,$CC,$C2
  DEFB $80,$80,$C0,$80,$80,$C0,$B0,$80
  DEFB $03,$00,$0C,$02,$30,$0C,$03,$20
  DEFB $00,$C0,$30,$00,$C0,$30,$0C,$C0
  DEFB $0C,$02,$00,$04,$03,$00,$00,$00
  DEFB $20,$0C,$C0,$30,$08,$43,$30,$0C
  DEFB $03,$30,$08,$01,$00,$00,$00,$00
  DEFB $00,$C0,$30,$08,$C0,$00,$00,$00
  DEFB $01,$43,$04,$0B,$1C,$30,$01,$02
  DEFB $3F,$0F,$C3,$F0,$FC,$3F,$0F,$03
  DEFB $00,$C0,$F0,$FC,$3E,$0F,$C2,$F1
  DEFB $FB,$37,$0F,$1C,$30,$00,$00,$40
  DEFB $C0,$C4,$00,$00,$20,$18,$00,$00
  DEFB $00,$01,$00,$30,$00,$02,$00,$00
  DEFB $04,$00,$00,$00,$80,$00,$18,$04
  DEFB $02,$80,$00,$08,$04,$00,$60,$00
  DEFB $00,$00,$20,$01,$00,$00,$00,$20
  DEFB $00,$40,$30,$78,$77,$7B,$3F,$7F
  DEFB $FF,$3D,$0F,$03,$00,$00,$00,$00
  DEFB $0B,$0F,$0F,$0F,$0D,$4F,$73,$7C
  DEFB $7B,$7F,$7F,$7F,$6F,$3F,$0F,$03
  DEFB $FE,$FC,$DE,$FE,$FE,$B4,$E0,$C2
  DEFB $FC,$DC,$FC,$FC,$FC,$F2,$CE,$36
  DEFB $00,$02,$0E,$1E,$EE,$FE,$7E,$FE
  DEFB $FE,$FC,$70,$C1,$00,$10,$00,$02
  DEFB $33,$3C,$2F,$3F,$0F,$03,$0C,$0F
  DEFB $C0,$30,$F0,$F0,$70,$CC,$3C,$FC
  DEFB $0F,$03,$0C,$0F,$0F,$0B,$0F,$0F
  DEFB $F0,$CC,$3C,$EC,$FC,$FC,$FC,$B0
  DEFB $33,$3C,$3F,$37,$3F,$3F,$3F,$3D
  DEFB $C0,$30,$F0,$F0,$70,$F0,$F0,$F0
  DEFB $0F,$0F,$0F,$0F,$0B,$0F,$0F,$0F
  DEFB $BC,$FC,$F4,$FC,$FC,$DC,$FC,$F0
  DEFB $BC,$FC,$F4,$FC,$FC,$DC,$FC,$F3
  DEFB $C7,$37,$F4,$F3,$77,$F4,$F0,$F0
  DEFB $CC,$3C,$B0,$88,$38,$F8,$F0,$CC
  DEFB $0F,$0F,$6C,$63,$07,$34,$F0,$CC
  DEFB $3C,$FC,$F3,$C7,$04,$03,$03,$03
  DEFB $00,$00,$00,$00,$00,$00,$C0,$C0
  DEFB $00,$00,$00,$00,$20,$E0,$C0,$30
  DEFB $F0,$F0,$C8,$38,$70,$40,$00,$00
  DEFB $3C,$B3,$83,$33,$F0,$F3,$CF,$0C
  DEFB $0F,$0E,$0F,$0F,$0C,$03,$0F,$3F
  DEFB $0F,$0B,$0F,$0F,$0F,$0D,$0F,$0F
  DEFB $70,$F0,$F0,$F0,$F0,$D0,$F0,$F0
  DEFB $00,$00,$00,$20,$F0,$E0,$E0,$D0
  DEFB $00,$00,$00,$00,$00,$03,$07,$09
  DEFB $00,$00,$00,$0C,$0F,$0F,$0B,$0F
  DEFB $00,$00,$00,$00,$00,$C0,$F0,$F0
  DEFB $FF,$FF,$7F,$FB,$FF,$3F,$4F,$73
  DEFB $B6,$B6,$B6,$B6,$B6,$B6,$96,$E6
  DEFB $7C,$7F,$77,$6B,$6B,$6D,$6D,$6D
  DEFB $FF,$3B,$CF,$F3,$FC,$DE,$AE,$AE
  DEFB $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
  DEFB $B6,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  DEFB $6D,$6D,$6D,$65,$79,$3F,$0F,$03
  DEFB $FF,$3E,$0E,$02,$00,$00,$00,$00
  DEFB $FE,$EC,$73,$0F,$3F,$7B,$75,$75
  DEFB $FF,$F7,$FF,$FE,$FB,$B4,$E2,$CE
  DEFB $3F,$FE,$EE,$D6,$D6,$B6,$B6,$B6
  DEFB $6D,$6D,$6D,$6D,$6D,$6D,$69,$67
  DEFB $B6,$B6,$B7,$A6,$9E,$FC,$F0,$C1
  DEFB $7F,$7C,$70,$41,$00,$00,$40,$02
  DEFB $70,$F3,$CF,$3F,$FF,$DF,$FD,$FF
  DEFB $B7,$B6,$B6,$B6,$B6,$B6,$B6,$B6
  DEFB $0F,$CF,$F7,$FF,$FF,$BF,$FF,$FF
  DEFB $F0,$F0,$F0,$D0,$F0,$F0,$F0,$FC
  DEFB $00,$01,$0E,$37,$B7,$D7,$F7,$F7
  DEFB $F6,$B4,$F0,$C0,$01,$40,$00,$06
  DEFB $00,$00,$00,$00,$00,$00,$00,$0C
  DEFB $00,$C0,$F0,$3C,$7F,$B3,$87,$8B
  DEFB $00,$03,$0F,$3C,$FE,$CD,$E1,$D1
  DEFB $0F,$0B,$0D,$0D,$0E,$0E,$06,$0E
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
  DEFB $7F,$B3,$87,$8B,$88,$88,$88,$88
  DEFB $00,$C0,$70,$F0,$F0,$D0,$F0,$F0
  DEFB $0E,$0A,$0E,$0E,$0E,$0E,$0D,$0D
  DEFB $88,$88,$88,$88,$88,$48,$70,$74
  DEFB $37,$F7,$F3,$DF,$FF,$3D,$0F,$03
  DEFB $08,$48,$70,$74,$36,$F6,$F2,$DE
  DEFB $60,$D0,$B0,$B0,$70,$70,$70,$70
  DEFB $70,$70,$50,$70,$70,$70,$70,$70
  DEFB $11,$11,$11,$11,$11,$11,$11,$11
  DEFB $FE,$CD,$E1,$D1,$11,$11,$11,$11
  DEFB $00,$03,$07,$0D,$0F,$0F,$0F,$0F
  DEFB $11,$11,$11,$11,$11,$12,$0E,$2E
  DEFB $70,$50,$70,$70,$70,$70,$B0,$B0
  DEFB $10,$12,$0E,$2E,$6C,$6F,$4F,$7B
  DEFB $EC,$EF,$CF,$FB,$FF,$BC,$F0,$C0
  DEFB $D0,$F0,$F0,$C0,$00,$00,$00,$00
  DEFB $0F,$0F,$0F,$0F,$0F,$0C,$00,$00
  DEFB $00,$00,$0C,$13,$14,$14,$08,$08
  DEFB $00,$00,$00,$00,$C0,$30,$10,$6C
  DEFB $FE,$FE,$7C,$00,$00,$00,$00,$00
  DEFB $13,$0C,$30,$C3,$0C,$32,$C0,$20
  DEFB $00,$01,$01,$02,$12,$04,$34,$CB
  DEFB $00,$00,$00,$00,$00,$00,$01,$00
  DEFB $08,$14,$D0,$20,$20,$20,$20,$20
  DEFB $00,$00,$00,$00,$03,$0C,$08,$36
  DEFB $7F,$7F,$3E,$00,$00,$00,$00,$00
  DEFB $00,$00,$30,$C8,$28,$28,$10,$10
  DEFB $00,$00,$00,$00,$00,$00,$80,$00
  DEFB $C8,$30,$0C,$C3,$30,$4C,$03,$04
  DEFB $00,$80,$80,$40,$48,$20,$2C,$D3
  DEFB $10,$28,$0B,$04,$04,$04,$04,$04
  DEFB $0B,$0F,$0F,$03,$00,$00,$00,$00
  DEFB $E0,$F0,$B0,$F0,$F0,$30,$00,$00
  DEFB $88,$88,$88,$88,$88,$88,$88,$88
  DEFB $08,$06,$0B,$1C,$13,$3B,$1B,$2B
  DEFB $00,$00,$00,$04,$18,$CC,$72,$36
  DEFB $4B,$09,$01,$00,$00,$C0,$F0,$3C
  DEFB $67,$DF,$CE,$8A,$12,$24,$04,$00
  DEFB $00,$00,$00,$00,$00,$C0,$F0,$3C
  DEFB $00,$80,$80,$30,$F0,$F3,$CF,$3C
  DEFB $00,$00,$00,$00,$00,$02,$0E,$3E
  DEFB $00,$00,$00,$00,$00,$40,$70,$7C
  DEFB $FF,$DF,$FD,$FF,$FF,$FC,$70,$C0
  DEFB $70,$F0,$F0,$F0,$D0,$F0,$F0,$F0
  DEFB $0F,$8F,$8F,$4F,$4B,$2F,$2F,$D7
  DEFB $BC,$FD,$F5,$FA,$FA,$D4,$F4,$EB
  DEFB $13,$28,$2B,$35,$35,$35,$35,$3B
  DEFB $C8,$14,$D0,$A0,$20,$A0,$A0,$D0
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$C0,$F0,$FC,$3C,$0C,$30,$3C
  DEFB $00,$03,$43,$73,$38,$CB,$F3,$FC
  DEFB $00,$00,$C0,$F0,$F0,$30,$C0,$D0
  DEFB $0D,$01,$0C,$0F,$0F,$03,$0C,$0F
  DEFB $3C,$CC,$E0,$2C,$CF,$C3,$CC,$0F
  DEFB $1C,$CE,$F2,$FC,$3C,$4C,$70,$38
  DEFB $00,$00,$00,$00,$00,$C0,$F0,$FC
  DEFB $03,$00,$03,$03,$03,$00,$00,$00
  DEFB $4F,$73,$38,$CB,$F3,$F0,$30,$00
  DEFB $CB,$C3,$CC,$0F,$CF,$D3,$1C,$0C
  DEFB $3C,$CC,$C0,$00,$C0,$C0,$C0,$00
  DEFB $00,$C0,$70,$EC,$ED,$EB,$EF,$EF
  DEFB $EF,$2D,$0F,$03,$00,$00,$00,$00
  DEFB $FE,$FC,$70,$C6,$30,$F3,$CF,$0C
  DEFB $00,$0C,$3C,$FC,$F3,$4F,$0C,$03
  DEFB $3C,$FC,$F3,$CF,$0C,$02,$0E,$3E
  DEFB $0F,$3F,$3C,$33,$0B,$38,$70,$40
  DEFB $04,$1C,$D3,$CF,$3F,$3C,$30,$00
  DEFB $FF,$DF,$FF,$FF,$FB,$3F,$0D,$01
  DEFB $03,$03,$0C,$0F,$0F,$13,$1C,$0E
  DEFB $32,$3C,$3F,$0F,$13,$1C,$0E,$02
  DEFB $30,$C0,$B0,$FC,$FF,$DF,$EF,$FF
  DEFB $F0,$F0,$F0,$F0,$B0,$F0,$F0,$F0
  DEFB $30,$C0,$F0,$EC,$FC,$F4,$3C,$CC
  DEFB $FC,$EC,$3C,$CC,$F0,$D0,$F0,$F0
  DEFB $30,$C0,$F0,$BC,$FC,$FC,$EC,$DC
  DEFB $08,$48,$70,$74,$37,$F7,$F3,$FF
  DEFB $30,$F0,$F0,$F0,$F0,$F0,$F0,$F0
  DEFB $2C,$4D,$15,$15,$14,$00,$00,$00
  DEFB $C0,$30,$F0,$F0,$F0,$C3,$2F,$EF
  DEFB $EF,$6F,$EB,$EF,$EF,$AC,$E3,$EF
  DEFB $CF,$2F,$EB,$EF,$AF,$ED,$CF,$33
  DEFB $EC,$3F,$0F,$03,$00,$00,$80,$00
  DEFB $6D,$2D,$CD,$F1,$CC,$3F,$0F,$03
  DEFB $B6,$B6,$B6,$B6,$B6,$36,$C6,$F2
  DEFB $B0,$F3,$CF,$33,$E8,$E8,$A8,$EC
  DEFB $08,$10,$C0,$70,$FC,$3B,$0F,$03
  DEFB $00,$00,$00,$00,$00,$00,$C0,$F0
  DEFB $C3,$08,$C2,$F0,$EC,$3F,$0F,$03
  DEFB $00,$C0,$30,$0C,$93,$00,$C0,$F2
  DEFB $EC,$3F,$0F,$03,$00,$C0,$30,$4C
  DEFB $03,$10,$C4,$B0,$FC,$3F,$0F,$03
  DEFB $0E,$0D,$01,$0A,$3A,$05,$35,$CB
  DEFB $2B,$17,$D4,$23,$2F,$2D,$2F,$0F
  DEFB $00,$10,$C0,$71,$FC,$3B,$0F,$03
  DEFB $0F,$0C,$03,$0F,$3F,$3F,$2F,$3F
  DEFB $3D,$3F,$3C,$33,$0F,$0D,$0F,$0F
  DEFB $0F,$0C,$03,$0F,$3F,$2F,$3C,$33
  DEFB $0F,$0F,$0D,$0F,$0F,$0F,$0F,$0B
  DEFB $0F,$0F,$0D,$0F,$0F,$0F,$CF,$F3
  DEFB $00,$02,$20,$00,$00,$08,$C0,$F0
  DEFB $FC,$3F,$CF,$F3,$EC,$FC,$BC,$FC
  DEFB $3F,$DC,$F3,$CD,$3F,$2F,$3C,$33
  DEFB $00,$00,$00,$00,$03,$0C,$C1,$F0
  DEFB $03,$0C,$30,$C0,$01,$20,$00,$04
  DEFB $00,$00,$00,$00,$03,$0C,$30,$C0
  DEFB $00,$00,$00,$00,$03,$0F,$3F,$7C
  DEFB $03,$0D,$3F,$FC,$B0,$C0,$00,$00
  DEFB $F0,$C0,$00,$00,$00,$00,$00,$00
  DEFB $0F,$03,$00,$00,$00,$00,$00,$00
  DEFB $C0,$B0,$FC,$3F,$0D,$03,$00,$00
  DEFB $00,$00,$00,$00,$C0,$F0,$EC,$3F
  DEFB $00,$00,$00,$00,$C0,$30,$0C,$43
  DEFB $C0,$30,$0C,$43,$00,$02,$20,$00
  DEFB $00,$00,$00,$00,$C0,$30,$03,$8F
  DEFB $00,$40,$03,$0D,$3F,$FC,$B0,$C0
  DEFB $3F,$DC,$F0,$C0,$00,$00,$00,$00
  DEFB $00,$10,$00,$00,$02,$80,$03,$0F
  DEFB $00,$42,$00,$08,$03,$4C,$33,$CC
  DEFB $43,$0C,$33,$CC,$30,$C7,$09,$0E
  DEFB $08,$C0,$30,$CC,$33,$0C,$83,$00
  DEFB $00,$00,$44,$00,$00,$C2,$30,$EC
  DEFB $33,$8C,$03,$10,$00,$00,$40,$02
  DEFB $00,$C1,$30,$CC,$33,$0C,$23,$00
  DEFB $70,$90,$E3,$0C,$33,$CC,$32,$C0
  DEFB $33,$CC,$30,$C0,$00,$11,$00,$20
  DEFB $00,$00,$00,$00,$03,$0C,$33,$CD
  DEFB $2F,$6E,$2F,$6F,$63,$4F,$6F,$2C
  DEFB $03,$0C,$30,$C0,$00,$00,$00,$00
  DEFB $70,$40,$00,$00,$00,$00,$00,$00
  DEFB $02,$40,$03,$0F,$3B,$7C,$70,$40
  DEFB $00,$00,$00,$00,$03,$0C,$30,$40
  DEFB $30,$F0,$B0,$F0,$F0,$D0,$F0,$F0
  DEFB $03,$0C,$30,$C0,$08,$20,$2C,$D3
  DEFB $F0,$D0,$F0,$F0,$F0,$B0,$F0,$CC
  DEFB $FF,$3C,$03,$8D,$3F,$DC,$F0,$C0
  DEFB $2F,$CF,$F7,$FF,$DF,$FF,$EF,$FD
  DEFB $2F,$CB,$2F,$EF,$AF,$ED,$EF,$EF
  DEFB $EF,$AF,$EF,$E3,$EC,$2F,$CD,$EF
  DEFB $C0,$E0,$E0,$EC,$E7,$E3,$2F,$CF
  DEFB $C0,$30,$CC,$F3,$F0,$F0,$CC,$3C
  DEFB $10,$08,$0B,$04,$C4,$34,$C4,$CB
  DEFB $D6,$D6,$D6,$D6,$D2,$D0,$D4,$03
  DEFB $C0,$30,$CC,$93,$54,$D6,$D6,$D6
  DEFB $D6,$D2,$D4,$D6,$D6,$56,$96,$C6
  DEFB $F0,$DC,$CF,$D3,$D4,$D6,$56,$96
  DEFB $D4,$D6,$D6,$D2,$D4,$56,$96,$C6
  DEFB $00,$00,$00,$00,$01,$03,$05,$0F
  DEFB $CB,$2B,$ED,$ED,$6D,$2D,$0D,$33
  DEFB $D6,$D6,$D6,$D6,$D6,$D6,$C6,$D2
  DEFB $1C,$0F,$03,$00,$10,$00,$00,$02
  DEFB $56,$16,$C6,$F2,$3C,$0B,$04,$03
  DEFB $D6,$D2,$D4,$83,$4C,$32,$C8,$2C
  DEFB $D6,$D6,$16,$C6,$F2,$3C,$CF,$D3
  DEFB $0F,$0C,$03,$0F,$3F,$2F,$3C,$33
  DEFB $CB,$0B,$0D,$0D,$8D,$ED,$4D,$33
  DEFB $0B,$0F,$2F,$CD,$32,$4C,$03,$04
  DEFB $23,$CF,$33,$4C,$53,$5C,$2F,$23
  DEFB $D3,$D0,$B0,$B0,$B3,$B7,$B3,$CC
  DEFB $D3,$D4,$B6,$B7,$B7,$B4,$F0,$EC
  DEFB $4C,$32,$C0,$20,$04,$03,$0C,$32
  DEFB $18,$3C,$78,$B4,$E0,$CC,$A3,$44
  DEFB $40,$08,$08,$00,$00,$00,$20,$C0
  DEFB $1E,$2C,$7B,$64,$98,$B0,$D0,$CC
  DEFB $00,$00,$00,$00,$80,$C0,$A0,$F0
  DEFB $32,$4C,$03,$04,$00,$00,$20,$C0
  DEFB $00,$00,$20,$C0,$32,$4C,$03,$04
  DEFB $32,$4C,$03,$04,$01,$03,$25,$CF
  DEFB $D3,$D0,$B0,$B0,$B0,$B0,$B0,$CC
  DEFB $20,$C0,$30,$4C,$43,$40,$20,$20
  DEFB $32,$4C,$03,$04,$20,$C0,$30,$4C
  DEFB $43,$40,$20,$20,$20,$C0,$30,$4C
  DEFB $20,$C0,$30,$4C,$42,$40,$20,$20
  DEFB $03,$00,$40,$40,$20,$04,$04,$00
  DEFB $20,$C0,$30,$4C,$02,$10,$08,$48
  DEFB $20,$C0,$30,$4C,$03,$00,$30,$00
  DEFB $D3,$D0,$B0,$B0,$B0,$B0,$B0,$EC
  DEFB $63,$00,$00,$00,$04,$24,$14,$00
  DEFB $40,$40,$01,$09,$08,$04,$64,$00
  DEFB $00,$04,$05,$42,$22,$20,$08,$00
  DEFB $00,$12,$02,$40,$40,$24,$28,$08
  DEFB $C2,$02,$04,$20,$20,$10,$02,$00
  DEFB $40,$08,$0A,$04,$04,$40,$40,$20
  DEFB $00,$20,$10,$00,$00,$08,$08,$00
  DEFB $40,$00,$00,$10,$10,$00,$04,$03
  DEFB $18,$3C,$1E,$2D,$07,$33,$C5,$22
  DEFB $0C,$30,$C0,$20,$80,$C0,$A4,$F3
  DEFB $00,$00,$04,$03,$4C,$32,$C0,$20
  DEFB $4C,$32,$C0,$20,$00,$00,$04,$03
  DEFB $78,$34,$DE,$26,$19,$0D,$0B,$33
  DEFB $04,$03,$0C,$32,$C2,$02,$04,$04
  DEFB $CB,$0B,$0D,$0D,$0D,$0D,$0D,$33
  DEFB $C2,$02,$04,$04,$04,$03,$0C,$32
  DEFB $C0,$00,$00,$08,$04,$44,$40,$00
  DEFB $04,$03,$0C,$32,$C0,$00,$02,$00
  DEFB $C6,$00,$10,$12,$0A,$48,$00,$00
  DEFB $04,$03,$0C,$30,$40,$00,$0C,$00
  DEFB $04,$03,$0C,$32,$42,$02,$04,$04
  DEFB $00,$01,$00,$30,$00,$02,$00,$00
  DEFB $02,$00,$00,$00,$40,$00,$0C,$00
  DEFB $02,$80,$00,$08,$04,$00,$60,$00
  DEFB $00,$00,$20,$01,$00,$00,$00,$20
  DEFB $23,$C3,$33,$4A,$02,$02,$02,$03
  DEFB $44,$43,$4C,$D2,$C0,$C0,$C0,$C0
  DEFB $23,$C3,$33,$4A,$42,$42,$22,$22
  DEFB $44,$43,$4C,$D2,$C2,$C2,$C4,$C4
  DEFB $03,$03,$C2,$33,$0B,$03,$02,$02
  DEFB $40,$C0,$C3,$CC,$D0,$C0,$C0,$C0
  DEFB $01,$03,$22,$C3,$33,$4B,$02,$03
  DEFB $80,$C0,$C4,$C3,$4C,$D2,$C0,$C0
  DEFB $1E,$3C,$7B,$64,$F8,$C0,$B0,$BC
  DEFB $BF,$CF,$B3,$B4,$B7,$D6,$D6,$D6
  DEFB $B7,$AE,$AF,$AF,$AF,$AF,$AF,$B7
  DEFB $D7,$D6,$D7,$B7,$B7,$B7,$B7,$D7
  DEFB $67,$06,$02,$40,$40,$00,$04,$00
  DEFB $32,$4C,$03,$04,$00,$C0,$F0,$FC
  DEFB $00,$C0,$70,$FC,$3F,$CD,$F3,$FC
  DEFB $00,$C0,$F0,$DC,$3E,$CE,$F2,$F4
  DEFB $2E,$CE,$2E,$4E,$4E,$4E,$2E,$2E
  DEFB $43,$40,$20,$20,$20,$A0,$D0,$FC
  DEFB $2E,$AE,$D6,$F6,$36,$0E,$02,$00
  DEFB $3F,$0F,$03,$40,$40,$20,$02,$00
  DEFB $20,$A0,$D0,$FC,$3F,$0F,$03,$40
  DEFB $36,$CE,$2E,$4E,$4E,$4E,$2E,$2E
  DEFB $37,$CF,$F3,$FC,$3F,$CF,$33,$4C
  DEFB $B3,$B0,$B0,$B0,$B0,$B0,$B0,$BC
  DEFB $B3,$B0,$B0,$B0,$B0,$B0,$B0,$AC
  DEFB $3F,$CF,$33,$4C,$43,$40,$20,$20
  DEFB $3F,$8F,$B3,$BC,$BF,$BF,$B3,$AC
  DEFB $21,$C1,$31,$4D,$41,$41,$21,$21
  DEFB $21,$A1,$D1,$FD,$3F,$0F,$03,$00
  DEFB $3F,$CF,$33,$4D,$41,$41,$21,$21
  DEFB $00,$00,$00,$00,$92,$CC,$A3,$F0
  DEFB $20,$C0,$30,$4C,$43,$40,$24,$03
  DEFB $4C,$30,$C0,$2C,$03,$40,$44,$03
  DEFB $4C,$30,$C0,$0C,$00,$13,$0C,$32
  DEFB $44,$43,$0C,$32,$C2,$02,$34,$04
  DEFB $C2,$02,$34,$04,$44,$43,$0C,$32
  DEFB $CB,$0B,$2D,$0D,$4D,$4D,$0D,$33
  DEFB $20,$C0,$30,$4C,$43,$40,$04,$03
  DEFB $43,$40,$04,$03,$4C,$32,$C0,$2C
  DEFB $03,$40,$44,$03,$4C,$32,$C0,$2C
  DEFB $D3,$D0,$B4,$03,$4C,$32,$C0,$20
  DEFB $C3,$00,$04,$03,$4C,$32,$C0,$20
  DEFB $00,$00,$20,$20,$00,$00,$00,$00
  DEFB $00,$00,$00,$18,$00,$00,$00,$00
  DEFB $00,$08,$04,$00,$00,$00,$00,$20
  DEFB $10,$00,$00,$00,$00,$02,$04,$00
  DEFB $04,$03,$0C,$32,$42,$02,$24,$C0
  DEFB $04,$03,$0C,$32,$C0,$00,$20,$C0
  DEFB $00,$60,$94,$F3,$B4,$B2,$D0,$D0
  DEFB $32,$4C,$03,$34,$41,$03,$25,$CF
  DEFB $CB,$0B,$2D,$CD,$32,$4C,$03,$34
  DEFB $C2,$02,$22,$C0,$32,$4C,$03,$34
  DEFB $C0,$02,$20,$C0,$32,$4C,$03,$04
  DEFB $32,$4C,$03,$34,$C0,$02,$22,$C0
  DEFB $20,$C2,$30,$4C,$43,$40,$2C,$20
  DEFB $D3,$D0,$B4,$B2,$B2,$B2,$B0,$CC
  DEFB $32,$4C,$03,$04,$20,$C2,$30,$4C
  DEFB $0A,$CE,$32,$4C,$42,$4C,$2E,$26
  DEFB $0C,$00,$20,$C0,$32,$4C,$03,$34
  DEFB $F2,$CC,$D3,$D4,$B0,$B0,$B0,$CC
  DEFB $22,$C2,$30,$4C,$43,$40,$2C,$22
  DEFB $22,$C2,$30,$4C,$43,$40,$20,$20
  DEFB $43,$40,$2C,$22,$22,$C2,$30,$4C
  DEFB $00,$21,$10,$10,$03,$0C,$33,$CC
  DEFB $40,$8C,$30,$C4,$30,$C0,$0E,$12
  DEFB $33,$0C,$03,$40,$44,$44,$20,$00
  DEFB $0C,$C0,$03,$C0,$30,$02,$0A,$04
  DEFB $00,$40,$E0,$00,$C2,$E0,$C0,$00
  DEFB $31,$CD,$32,$0D,$3E,$19,$02,$02
  DEFB $8C,$B3,$4C,$B0,$7C,$99,$C0,$C0
  DEFB $00,$02,$07,$00,$43,$07,$02,$00
  DEFB $D9,$DB,$2A,$CB,$33,$4B,$B2,$DB
  DEFB $9B,$DB,$D4,$D3,$4C,$D2,$CD,$DB
  DEFB $3B,$CB,$33,$CA,$E2,$EA,$EA,$EA
  DEFB $5C,$53,$4C,$D3,$C7,$D7,$D7,$D7
  DEFB $31,$CD,$32,$CC,$BE,$D8,$E0,$F8
  DEFB $8C,$B3,$4C,$33,$7D,$1B,$07,$1F
  DEFB $32,$4C,$33,$34,$3A,$1A,$2A,$C8
  DEFB $32,$4C,$33,$14,$2A,$CA,$32,$4C
  DEFB $53,$54,$26,$26,$2A,$CA,$32,$4C
  DEFB $3B,$C3,$33,$0B,$02,$02,$03,$01
  DEFB $D8,$D8,$D8,$D8,$E8,$E8,$E8,$E8
  DEFB $1B,$1B,$1B,$1B,$17,$17,$17,$17
  DEFB $5C,$43,$4C,$50,$C0,$C0,$C0,$80
  DEFB $4C,$32,$CC,$2C,$5C,$58,$54,$13
  DEFB $4C,$32,$CC,$28,$54,$53,$4C,$32
  DEFB $CA,$2A,$64,$64,$54,$53,$4C,$32
  DEFB $36,$36,$36,$36,$3A,$1A,$2A,$C8
  DEFB $6C,$6C,$6C,$6C,$5C,$58,$54,$13
  DEFB $0B,$43,$02,$C2,$F3,$3D,$CE,$03
  DEFB $42,$50,$C0,$C3,$CF,$BC,$70,$CC
  DEFB $C0,$0C,$30,$C3,$0C,$33,$CC,$30
  DEFB $01,$0D,$20,$C3,$0C,$33,$CC,$30
  DEFB $00,$21,$10,$10,$03,$0C,$32,$CD
  DEFB $13,$1C,$1C,$1C,$1D,$1D,$1C,$2C
  DEFB $CC,$3C,$6C,$6C,$5C,$5C,$5C,$5C
  DEFB $03,$30,$08,$C3,$30,$CC,$33,$0C
  DEFB $82,$80,$08,$C2,$30,$CC,$33,$0C
  DEFB $F0,$3C,$0F,$03,$08,$83,$20,$0C
  DEFB $F0,$3C,$8F,$83,$88,$83,$A0,$8C
  DEFB $0F,$3C,$F1,$C1,$01,$01,$C1,$09
  DEFB $30,$CC,$33,$4C,$E3,$80,$08,$00
  DEFB $33,$3C,$36,$36,$3A,$3A,$3A,$3A
  DEFB $C0,$30,$4C,$03,$10,$02,$40,$03
  DEFB $0C,$33,$CC,$32,$C7,$01,$20,$00
  DEFB $C8,$38,$38,$38,$B8,$B8,$38,$34
  DEFB $07,$40,$08,$20,$C0,$04,$30,$C3
  DEFB $C0,$F0,$1C,$83,$0C,$33,$CC,$30
  DEFB $00,$00,$00,$C0,$F3,$3C,$8F,$03
  DEFB $03,$0F,$38,$C1,$30,$8C,$33,$0C
  DEFB $03,$0C,$30,$C2,$10,$00,$08,$C1
  DEFB $E0,$02,$10,$0C,$01,$30,$04,$C3
  DEFB $02,$02,$00,$10,$C0,$30,$4C,$B3
  DEFB $06,$38,$C0,$10,$C0,$32,$0C,$03
  DEFB $60,$1C,$03,$08,$03,$4C,$30,$C0
  DEFB $C0,$30,$0C,$E3,$18,$07,$20,$00
  DEFB $00,$04,$04,$00,$C1,$30,$CC,$3B
  DEFB $03,$0C,$30,$C7,$18,$E0,$04,$00
  DEFB $00,$22,$20,$00,$03,$0C,$33,$DC
  DEFB $36,$36,$36,$36,$3A,$3A,$3A,$3A
  DEFB $36,$32,$34,$33,$4C,$32,$C8,$2A
  DEFB $34,$33,$0C,$32,$CA,$3A,$34,$34
  DEFB $D9,$DB,$DA,$DB,$EB,$EB,$EA,$A3
  DEFB $4D,$33,$CA,$2B,$CB,$EB,$EA,$A3
  DEFB $4D,$33,$CB,$2A,$CA,$E2,$CC,$B2
  DEFB $C3,$03,$03,$03,$02,$02,$0B,$33
  DEFB $CB,$1B,$DB,$DA,$EA,$E2,$CC,$32
  DEFB $30,$C3,$00,$33,$CF,$3C,$F0,$C0
  DEFB $00,$30,$42,$04,$10,$C3,$08,$03
  DEFB $0F,$3C,$F0,$C0,$00,$00,$00,$00
  DEFB $09,$C3,$31,$0D,$C3,$11,$0D,$C3
  DEFB $90,$C2,$8C,$B0,$C3,$84,$B0,$80
  DEFB $08,$30,$C2,$04,$30,$80,$08,$20
  DEFB $00,$C0,$30,$00,$C0,$30,$0C,$C0
  DEFB $20,$0C,$C0,$30,$08,$43,$30,$0C
  DEFB $C3,$31,$0D,$81,$31,$0D,$43,$31
  DEFB $C3,$84,$B0,$C3,$8C,$90,$C3,$8C
  DEFB $CB,$0B,$0D,$0D,$0D,$CD,$CD,$33
  DEFB $CB,$2B,$ED,$ED,$ED,$2D,$0D,$37
  DEFB $F4,$33,$0C,$32,$C2,$02,$04,$04
  DEFB $04,$C3,$CC,$32,$0A,$3A,$F5,$F5
  DEFB $C2,$02,$04,$04,$04,$43,$4C,$32
  DEFB $CA,$3A,$75,$75,$74,$33,$0C,$32
  DEFB $4C,$32,$CD,$2B,$D4,$33,$0C,$32
  DEFB $4C,$32,$C0,$20,$00,$C0,$F4,$B3
  DEFB $5F,$3B,$04,$03,$4C,$32,$C0,$20
  DEFB $00,$40,$74,$33,$4C,$32,$CD,$2F
  DEFB $D6,$D6,$D6,$D6,$D6,$D2,$D4,$93
  DEFB $CB,$2B,$CD,$ED,$2D,$0D,$0D,$33
  DEFB $00,$00,$00,$00,$06,$0B,$0F,$0D
  DEFB $4F,$37,$CD,$2F,$0B,$0F,$0D,$0F
  DEFB $00,$00,$00,$00,$60,$D0,$F0,$B0
  DEFB $F2,$AC,$F3,$F4,$D0,$F0,$F0,$B0
  DEFB $D3,$D0,$B0,$B0,$B3,$B7,$B3,$CC
  DEFB $22,$CE,$32,$4C,$52,$5C,$AE,$2E
  DEFB $D3,$D4,$B7,$B7,$B7,$B4,$B0,$CC
  DEFB $2E,$CC,$30,$4C,$43,$40,$20,$20
  DEFB $43,$40,$20,$20,$23,$CF,$33,$4C
  DEFB $53,$5C,$AF,$AF,$2F,$CC,$30,$4C
  DEFB $0B,$0F,$2F,$CD,$32,$4C,$13,$14
  DEFB $7F,$7F,$3E,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $4F,$73,$38,$CB,$F3,$F0,$30,$00
  DEFB $3C,$CC,$C0,$00,$C0,$C0,$C0,$00
; Interior tiles. 194 tiles.
interior_tiles:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$30,$40,$02,$0C,$80
  DEFB $00,$00,$00,$00,$00,$04,$08,$04
  DEFB $30,$FC,$3F,$CF,$C3,$C0,$C8,$C6
  DEFB $10,$60,$00,$C6,$F0,$FC,$3F,$0C
  DEFB $00,$98,$62,$08,$20,$80,$04,$00
  DEFB $24,$81,$00,$08,$01,$40,$20,$01
  DEFB $40,$30,$00,$4C,$30,$00,$86,$08
  DEFB $C8,$C0,$C2,$CC,$F0,$C0,$0C,$01
  DEFB $23,$83,$03,$13,$03,$83,$43,$03
  DEFB $00,$18,$00,$40,$02,$08,$20,$80
  DEFB $03,$13,$03,$03,$43,$0C,$30,$80
  DEFB $02,$08,$20,$80,$00,$00,$00,$00
  DEFB $08,$40,$00,$20,$00,$04,$40,$00
  DEFB $40,$04,$02,$4C,$30,$00,$C3,$08
  DEFB $00,$00,$03,$44,$8C,$1E,$0C,$40
  DEFB $08,$06,$00,$63,$0F,$3F,$FC,$30
  DEFB $0C,$3F,$FC,$F3,$C3,$0B,$23,$C3
  DEFB $40,$10,$04,$01,$00,$00,$00,$00
  DEFB $00,$00,$C0,$22,$31,$78,$30,$02
  DEFB $C4,$C1,$C0,$D0,$C0,$C1,$C2,$C0
  DEFB $13,$0B,$43,$33,$0F,$03,$20,$80
  DEFB $06,$20,$40,$34,$08,$03,$C0,$30
  DEFB $C0,$C8,$C0,$C0,$C2,$30,$0C,$01
  DEFB $00,$19,$46,$10,$04,$01,$20,$00
  DEFB $00,$00,$18,$00,$42,$10,$04,$01
  DEFB $81,$9B,$62,$01,$80,$23,$4F,$0B
  DEFB $C3,$13,$03,$C3,$F3,$FC,$3F,$0C
  DEFB $C8,$C4,$C0,$C3,$CF,$3F,$FC,$30
  DEFB $30,$FC,$3F,$CF,$C3,$C0,$98,$7E
  DEFB $73,$4F,$77,$38,$16,$03,$40,$04
  DEFB $FF,$7E,$9C,$E8,$F2,$00,$20,$80
  DEFB $1B,$5F,$0E,$C5,$1F,$33,$6D,$7D
  DEFB $72,$FB,$FF,$DB,$67,$FD,$9F,$6D
  DEFB $BB,$7B,$7B,$63,$C3,$CC,$10,$00
  DEFB $C3,$CB,$63,$E3,$D3,$FB,$BB,$CB
  DEFB $00,$00,$00,$03,$0F,$3C,$F0,$C0
  DEFB $0F,$3C,$F0,$C0,$00,$80,$80,$80
  DEFB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
  DEFB $C0,$C0,$C0,$C0,$C0,$C3,$CC,$F0
  DEFB $80,$83,$8C,$B0,$C0,$80,$80,$80
  DEFB $00,$80,$80,$80,$80,$83,$8C,$B0
  DEFB $C0,$81,$82,$82,$80,$80,$80,$80
  DEFB $C0,$A0,$A0,$80,$83,$8F,$BF,$BC
  DEFB $C0,$C0,$C0,$C0,$40,$C0,$00,$00
  DEFB $C3,$CF,$DF,$DC,$F0,$C0,$00,$00
  DEFB $70,$C0,$00,$00,$00,$00,$00,$00
  DEFB $83,$8F,$BF,$BC,$70,$C0,$00,$00
  DEFB $C0,$C1,$C2,$C2,$C0,$C0,$C0,$C0
  DEFB $00,$00,$00,$00,$00,$00,$00,$03
  DEFB $43,$13,$07,$03,$00,$00,$00,$00
  DEFB $0F,$3C,$F0,$C0,$00,$00,$00,$00
  DEFB $00,$00,$00,$C0,$F0,$3C,$0F,$03
  DEFB $00,$00,$00,$00,$00,$00,$00,$C0
  DEFB $F0,$3C,$0F,$03,$00,$00,$00,$00
  DEFB $03,$03,$03,$03,$03,$03,$03,$03
  DEFB $00,$00,$00,$00,$02,$08,$20,$80
  DEFB $00,$00,$00,$00,$40,$10,$04,$01
  DEFB $C2,$C8,$E0,$C0,$00,$00,$00,$00
  DEFB $03,$03,$03,$03,$02,$08,$20,$80
  DEFB $C0,$C0,$C0,$C0,$40,$10,$04,$01
  DEFB $00,$00,$00,$00,$01,$03,$06,$05
  DEFB $01,$07,$1C,$73,$CF,$3F,$7F,$BC
  DEFB $8F,$1C,$D0,$E0,$E0,$C0,$3C,$FF
  DEFB $05,$35,$F4,$C5,$05,$05,$04,$04
  DEFB $D3,$CF,$DF,$3F,$CC,$F3,$FC,$3F
  DEFB $FC,$F3,$CF,$3F,$FF,$FF,$FF,$3F
  DEFB $C0,$F0,$FC,$FF,$FF,$FF,$FF,$FF
  DEFB $00,$00,$00,$00,$C0,$F0,$FC,$F9
  DEFB $0F,$03,$00,$00,$00,$00,$00,$00
  DEFB $CF,$F3,$FC,$3F,$0F,$03,$00,$00
  DEFB $FF,$FF,$FE,$39,$D7,$EC,$EB,$28
  DEFB $E7,$9D,$71,$CD,$31,$C0,$00,$00
  DEFB $08,$08,$08,$00,$00,$00,$00,$00
  DEFB $00,$1C,$7F,$1F,$67,$59,$46,$59
  DEFB $00,$00,$00,$C0,$F0,$FC,$70,$8C
  DEFB $56,$5E,$46,$58,$56,$5E,$46,$58
  DEFB $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BC
  DEFB $56,$5E,$66,$18,$06,$01,$00,$00
  DEFB $BC,$BC,$BD,$BD,$BC,$B8,$00,$00
  DEFB $18,$7E,$1F,$67,$59,$46,$5B,$5B
  DEFB $00,$00,$80,$E0,$F8,$7E,$9F,$66
  DEFB $00,$00,$00,$00,$00,$00,$80,$00
  DEFB $5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
  DEFB $19,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  DEFB $80,$80,$80,$80,$80,$80,$80,$80
  DEFB $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B
  DEFB $63,$1B,$07,$01,$00,$00,$00,$00
  DEFB $6B,$6B,$6B,$8B,$6B,$1B,$02,$00
  DEFB $80,$80,$80,$80,$B0,$BC,$0F,$03
  DEFB $03,$03,$03,$C3,$F3,$3F,$0F,$03
  DEFB $00,$00,$00,$00,$00,$00,$03,$0F
  DEFB $00,$00,$03,$0F,$3F,$FF,$FF,$FF
  DEFB $30,$FC,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $00,$00,$00,$C0,$F0,$FC,$FF,$FC
  DEFB $3F,$0F,$03,$0C,$0B,$08,$08,$08
  DEFB $FF,$FF,$FF,$FF,$3F,$CF,$33,$0C
  DEFB $FF,$FF,$FF,$FC,$F3,$CC,$30,$C0
  DEFB $F0,$CC,$34,$C4,$04,$04,$04,$04
  DEFB $3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FC
  DEFB $F3,$CC,$30,$C0,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$0C,$34
  DEFB $CC,$B4,$C4,$84,$84,$80,$8F,$3F
  DEFB $FF,$3F,$8F,$80,$82,$82,$82,$82
  DEFB $02,$02,$02,$00,$00,$00,$00,$00
  DEFB $F0,$C0,$10,$10,$10,$10,$10,$10
  DEFB $8F,$1C,$E0,$30,$D0,$E0,$D4,$BB
  DEFB $7D,$DD,$BB,$FB,$F7,$CF,$FD,$3E
  DEFB $C0,$70,$BC,$DF,$DF,$E9,$EE,$FE
  DEFB $73,$8D,$FE,$39,$C7,$EC,$EB,$28
  DEFB $01,$07,$1C,$70,$CD,$3B,$7B,$BC
  DEFB $43,$5B,$3D,$3D,$5A,$42,$5B,$5B
  DEFB $19,$6B,$0B,$6B,$F3,$F3,$6B,$0B
  DEFB $00,$00,$00,$00,$00,$00,$C0,$B0
  DEFB $CC,$B4,$8C,$84,$84,$04,$C4,$F0
  DEFB $3F,$0F,$23,$20,$21,$21,$21,$21
  DEFB $FC,$F0,$C4,$04,$04,$04,$04,$04
  DEFB $01,$01,$01,$00,$00,$00,$00,$00
  DEFB $00,$00,$03,$0F,$3F,$FC,$F3,$CC
  DEFB $00,$C0,$F0,$C0,$30,$D0,$10,$D0
  DEFB $03,$0C,$0E,$0E,$0E,$0E,$0E,$0E
  DEFB $33,$CB,$BB,$BB,$BB,$BB,$BB,$BB
  DEFB $D0,$D0,$D0,$50,$50,$D0,$D0,$D0
  DEFB $0E,$0E,$0E,$0E,$0E,$0E,$02,$00
  DEFB $BB,$B8,$B3,$8C,$B0,$C0,$00,$00
  DEFB $30,$C0,$00,$00,$00,$00,$00,$00
  DEFB $70,$D8,$66,$3D,$0D,$03,$01,$00
  DEFB $00,$00,$00,$80,$40,$A0,$E0,$F0
  DEFB $F0,$60,$90,$F0,$B0,$B0,$B0,$B0
  DEFB $30,$FC,$3F,$0C,$00,$F0,$00,$00
  DEFB $0F,$3C,$F0,$C0,$08,$08,$88,$88
  DEFB $C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
  DEFB $88,$88,$88,$88,$88,$88,$88,$88
  DEFB $88,$88,$88,$88,$83,$8F,$3F,$FC
  DEFB $00,$00,$00,$04,$1E,$3C,$12,$2E
  DEFB $00,$00,$00,$00,$00,$00,$30,$FC
  DEFB $2E,$2D,$13,$EC,$30,$08,$08,$00
  DEFB $F0,$C0,$20,$20,$00,$00,$00,$00
  DEFB $01,$07,$1F,$7F,$1F,$67,$79,$5E
  DEFB $80,$60,$98,$E6,$98,$66,$9E,$7E
  DEFB $5F,$5B,$57,$5F,$67,$1B,$07,$01
  DEFB $7E,$7A,$72,$76,$7E,$78,$60,$80
  DEFB $06,$1A,$6E,$7A,$5E,$76,$58,$63
  DEFB $C0,$C0,$C0,$C3,$CF,$FC,$F0,$C0
  DEFB $C0,$B0,$8C,$E4,$9C,$C4,$34,$0C
  DEFB $F0,$C0,$30,$D0,$10,$10,$00,$00
  DEFB $00,$00,$03,$0F,$3F,$FF,$FF,$FC
  DEFB $00,$00,$00,$C0,$F0,$C0,$20,$E0
  DEFB $20,$20,$00,$00,$00,$00,$00,$00
  DEFB $3F,$FF,$FF,$FC,$F3,$CD,$31,$C1
  DEFB $3F,$0F,$33,$2C,$23,$22,$02,$02
  DEFB $F0,$3C,$0F,$C3,$F0,$C0,$20,$E0
  DEFB $00,$00,$00,$0C,$3F,$FC,$F3,$CD
  DEFB $31,$CD,$B5,$B1,$8D,$B5,$B1,$8D
  DEFB $B5,$BD,$B3,$8C,$B0,$C0,$00,$00
  DEFB $0E,$2E,$EE,$CE,$0E,$0E,$02,$00
  DEFB $5E,$52,$5E,$5E,$46,$58,$5E,$52
  DEFB $5E,$56,$5E,$46,$58,$5E,$52,$5E
  DEFB $00,$00,$00,$C0,$F0,$FC,$FF,$F3
  DEFB $FF,$FF,$FC,$F3,$CF,$3F,$CF,$F3
  DEFB $CC,$3F,$FF,$FF,$FF,$FF,$FC,$F3
  DEFB $F0,$3C,$CF,$F3,$CF,$3C,$F3,$CB
  DEFB $3C,$4F,$73,$7C,$7F,$3E,$0E,$02
  DEFB $CF,$3C,$F3,$CF,$3F,$DF,$DC,$D0
  DEFB $3B,$FB,$FB,$F3,$C3,$03,$00,$00
  DEFB $00,$00,$00,$C0,$00,$00,$00,$00
  DEFB $C0,$F0,$3C,$4F,$43,$60,$1A,$C6
  DEFB $00,$00,$03,$01,$39,$11,$19,$15
  DEFB $00,$00,$80,$00,$80,$40,$00,$00
  DEFB $10,$10,$01,$07,$1F,$27,$39,$3E
  DEFB $18,$6E,$EF,$EF,$EF,$96,$F9,$67
  DEFB $00,$00,$80,$E0,$90,$70,$F0,$F0
  DEFB $3F,$3F,$1F,$07,$01,$02,$1B,$06
  DEFB $9F,$FF,$BF,$BE,$B8,$60,$00,$03
  DEFB $F0,$E0,$80,$03,$0F,$3C,$F0,$C0
  DEFB $0C,$3C,$F4,$E8,$68,$88,$88,$94
  DEFB $00,$00,$00,$03,$0F,$3E,$36,$28
  DEFB $28,$09,$08,$14,$04,$08,$00,$00
  DEFB $84,$48,$40,$80,$00,$00,$00,$00
  DEFB $C0,$60,$80,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$03,$0F,$3C,$FC,$CB
  DEFB $88,$60,$19,$06,$00,$00,$00,$00
  DEFB $FF,$FF,$FF,$FE,$FD,$FB,$FB,$F9
  DEFB $FF,$FF,$FF,$1C,$E3,$EC,$80,$E0
  DEFB $F2,$C8,$37,$8F,$6F,$7D,$3D,$1B
  DEFB $00,$F0,$F8,$E8,$E8,$D8,$D3,$CF
  DEFB $27,$78,$7F,$5F,$0F,$F0,$FF,$FC
  DEFB $2F,$EF,$EF,$DC,$33,$CD,$31,$C1
  DEFB $00,$00,$00,$C0,$F1,$FB,$FB,$F9
  DEFB $00,$00,$00,$00,$E0,$E0,$80,$E0
  DEFB $00,$F0,$F8,$E8,$E8,$D8,$D0,$C0
  DEFB $20,$EC,$EF,$DF,$33,$CD,$31,$C1

; Main loop setup.
;
; Used by the routine at main.
;
; There seems to be litle point in this: enter_room terminates with 'goto main_loop' so it never returns. In fact, the single calling routine (main) might just as well goto enter_room instead of goto main_loop_setup.
main_loop_setup:
  CALL enter_room         ; The hero enters a room - returns via squash_stack_goto_main

; Main game loop.
;
; Used by the routine at squash_stack_goto_main.
main_loop:
  CALL check_morale       ; Check morale level, report if (near) zero and inhibit player control if exhausted
  CALL keyscan_break      ; Check for a BREAK keypress
  CALL message_display    ; Incrementally wipe and display queued game messages
  CALL process_player_input ; Process player input
  CALL in_permitted_area  ; Check the hero's map position and colour the flag accordingly
  CALL restore_tiles      ; Paint any tiles occupied by visible characters with tiles from tile_buf
  CALL move_characters    ; Move characters around
  CALL automatics         ; Make characters follow the hero if he's being suspicious
  CALL purge_invisible_characters ; Run through all visible characters, resetting them if they're off-screen
  CALL spawn_characters   ; Spawn characters
  CALL mark_nearby_items  ; Mark nearby items
  CALL ring_bell          ; Ring the alarm bell (1)
  CALL animate            ; Animate all visible characters
  CALL move_map           ; Move the map when the hero walks
  CALL message_display    ; Incrementally wipe and display queued game messages
  CALL ring_bell          ; Ring the alarm bell (2)
  CALL plot_sprites       ; Plot vischars and items in order
  CALL plot_game_window   ; Plot the game screen
  CALL ring_bell          ; Ring the alarm bell (3)
  LD A,(day_or_night)     ; If the night-time flag is set, turns white screen elements light blue and tracks the hero with a searchlight
  AND A                   ;
  CALL NZ,nighttime       ;
  LD A,(room_index)           ; If the global current room index is non-zero then slow the game down with a delay loop
  AND A                       ;
  CALL NZ,interior_delay_loop ;
  CALL wave_morale_flag   ; Wave the morale flag
  LD A,(game_counter)         ; Dispatch a timed event event once every 64 ticks of the game counter
  AND $3F                     ;
  CALL Z,dispatch_timed_event ;
  JR main_loop            ; ...loop forever

; Check morale level, report if (near) zero and inhibit player control if exhausted.
;
; Used by the routine at main_loop.
check_morale:
  LD A,(morale)           ; If morale is greater than one then return
  CP $02                  ;
  RET NC                  ;
  LD BC,$0F00             ; Queue the message "MORALE IS ZERO"
  CALL queue_message      ;
  LD A,$FF                ; Set the "morale exhausted" flag to inhibit player input
  LD (morale_exhausted),A ;
  XOR A                           ; Immediately take automatic control of the hero
  LD (automatic_player_counter),A ;
  RET                     ; Return

; Check for a BREAK keypress.
;
; Used by the routine at main_loop.
;
; If pressed then clear the screen and confirm with the player that they want to reset the game. Reset if requested.
keyscan_break:
  LD BC,$FEFE             ; If shift or space are not pressed then return
  IN A,(C)                ;
  AND $01                 ;
  RET NZ                  ;
  LD B,$7F                ;
  IN A,(C)                ;
  AND $01                 ;
  RET NZ                  ;
  CALL screen_reset       ; Reset the screen
  CALL user_confirm       ; Wait for the player to press 'Y' or 'N'
  JP Z,reset_game         ; If 'Y' was pressed (Z set) then reset the game
  LD A,(room_index)       ; If the global current room index is room_0_OUTDOORS then !(Reset the hero's position, redraw the scene, then zoombox it onto the screen) and return
  AND A                   ;
  JP Z,reset_outdoors     ;
  JP enter_room           ; The hero enters a room - returns via squash_stack_goto_main

; Process player input.
;
; Used by the routine at main_loop.
;
; Morale exhausted? If so then don't allow input.
process_player_input:
  LD HL,(in_solitary)     ; Simultaneously load the in_solitary and morale_exhausted flags
  XOR A                   ; Return if either is set. This inhibits the player's control
  OR H                    ;
  OR L                    ;
  RET NZ                  ;
  LD A,($8001)            ; Is the hero is picking a lock, or cutting wire?
  AND $03                 ;
  JR Z,process_player_input_no_flags ; Jump if not
; Hero is picking a lock, or cutting through a wire fence.
  LD HL,automatic_player_counter ; Postpone automatic control for 31 turns of this routine
  LD (HL),$1F                    ;
  CP $01                  ; Is the hero picking a lock?
  JP Z,picking_lock       ; Jump to picking_lock if so
  JP cutting_wire         ; Jump to cutting_wire otherwise
process_player_input_no_flags:
  CALL static_tiles_plot_direction ; Call the input routine. Input is returned in A. (Note: The routine lives at same address as static_tiles_plot_direction)
  LD HL,automatic_player_counter ; Take address of the automatic player counter
  CP $00                  ; Did the input routine return input_NONE? (zero)
  JP NZ,process_player_input_received ; Jump if not
; No user input was received: count down the automatic player counter
  LD A,(HL)               ; If the automatic player counter is zero then return
  AND A                   ;
  RET Z                   ;
  DEC (HL)                ; Decrement the automatic player counter
  XOR A                   ; Set input to input_NONE
  JR process_player_input_set_kick ; Jump to end bit
; User input was received.
;
; Postpone automatic control for 31 turns.
process_player_input_received:
  LD (HL),$1F             ; Set the automatic player counter to 31
  PUSH AF                 ; Bank input routine result
  LD A,(hero_in_bed)      ; Load hero in bed flag
  AND A                   ; Is it zero?
  JR NZ,process_player_input_in_bed ; Jump to 'hero was in bed' case if not
  LD A,(hero_in_breakfast) ; Load hero at breakfast flag
  AND A                   ; Is it zero?
  JR Z,process_player_input_check_fire ; Jump to 'not bed or breakfast' case if so
; Hero was at breakfast: make him stand up
  LD HL,$002B             ; Set hero's route to 43, step 0
  LD ($8002),HL           ;
  LD HL,$800F             ; Set hero's (x,y) pos to (52,62)
  LD (HL),$34             ;
  INC L                   ;
  INC L                   ;
  LD (HL),$3E             ;
  LD HL,roomdef_25_breakfast_bench_G ; Set room definition 25's bench_G object to interiorobject_EMPTY_BENCH
  LD (HL),$0D                        ;
  LD HL,hero_in_breakfast ; Point HL at hero at breakfast flag
  JR process_player_input_common ; Jump to common part
; Hero was in bed: make him get up
process_player_input_in_bed:
  LD HL,$012C             ; Set hero's route to 44, step 1
  LD ($8002),HL           ;
  LD HL,$2E2E             ; Set hero's target (x,y) to (46,46)
  LD ($8004),HL           ;
  LD H,$00                ; Set hero's (x,y) pos to (46,46)
  LD ($800F),HL           ;
  LD ($8011),HL           ;
  LD A,$18                ; Set hero's height to 24
  LD ($8013),A            ;
  LD HL,roomdef_2_hut2_left_heros_bed ; Set room definition 2's bed object to interiorobject_EMPTY_BED
  LD (HL),$09                         ;
  LD HL,hero_in_bed       ; Point HL at hero in bed flag
process_player_input_common:
  LD (HL),$00             ; Clear the hero at breakfast / hero in bed flag
  CALL setup_room         ; Expand out the room definition for room_index
  CALL plot_interior_tiles ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
process_player_input_check_fire:
  POP AF                  ; Unbank input routine result
  CP $09                  ; Was fire pressed?
  JR C,process_player_input_set_kick ; Jump if not
  CALL process_player_input_fire ; Check for 'pick up', 'drop' and 'use' input events
  LD A,$80                ; Set A to input_KICK ($80)
; If input state has changed then kick a sprite update.
process_player_input_set_kick:
  LD HL,$800D             ; Did the input state change from the hero's existing input?
  CP (HL)                 ;
  RET Z                   ; Return if not
  OR $80                  ; Kick a sprite update if it did
  LD (HL),A               ;
  RET                     ; Return

; Locks the player out until the lock is picked.
;
; Used by the routine at process_player_input.
picking_lock:
  LD HL,game_counter             ; Return unless player_locked_out_until becomes equal to game_counter
  LD A,(player_locked_out_until) ;
  CP (HL)                        ;
  RET NZ                         ;
; Countdown reached: Unlock the door.
  LD HL,(ptr_to_door_being_lockpicked) ; Clear door_LOCKED ($80) from the door whose lock is being picked
  RES 7,(HL)                           ;
  LD B,$06                ; Queue the message "IT IS OPEN"
  CALL queue_message      ;
; This entry point is used by the routine at cutting_wire.
clear_lockpick_wirecut_flags_and_return:
  LD HL,$8001             ; Clear the vischar_FLAGS_PICKING_LOCK and vischar_FLAGS_CUTTING_WIRE flags
  LD A,(HL)               ;
  AND $FC                 ;
  LD (HL),A               ;
  RET                     ; Return

; Locks the player out until the wire is snipped.
;
; Used by the routine at process_player_input.
cutting_wire:
  LD HL,game_counter             ; How much longer do we have to wait until the wire cutting is complete?
  LD A,(player_locked_out_until) ;
  SUB (HL)                       ;
  JR Z,cutting_wire_complete ; Jump if the countdown reached zero
  CP $04                  ; Return if greater than 3
  RET NC                  ;
  LD A,($800E)            ; Read current direction
  LD HL,cutting_wire_new_inputs ; Point at cutting_wire_new_inputs
  AND $03                 ; Mask off direction part
  ADD A,L                 ; Look that up in cutting_wire_new_inputs
  LD L,A                  ;
  JR NC,cutting_wire_0    ;
  INC H                   ;
cutting_wire_0:
  LD A,(HL)               ;
  LD ($800D),A            ; Save new input
  RET                     ; Return
; Countdown reached zero: Snip the wire.
cutting_wire_complete:
  LD HL,$800E             ; Point HL at hero's direction field
; Bug: An LD A,(HL) instruction is missing here. A is always zero at this point from above, so $800E is always set to zero. The hero will always face top-left (direction_TOP_LEFT is 0) after breaking through a fence. Note that the DOS x86
; version moves zero into $800E - it has no AND - hardcoding the bug.
  AND $03
  LD (HL),A
  DEC L                   ; Set vischar.input to input_KICK
  LD (HL),$80             ;
  LD A,$18                ; Set vischar height to 24
  LD ($8013),A            ;
  JR clear_lockpick_wirecut_flags_and_return ; Jump to clear_lockpick_wirecut_flags_and_return
; New inputs table.
cutting_wire_new_inputs:
  DEFB $84                ; input_UP   + input_LEFT  + input_KICK
  DEFB $87                ; input_UP   + input_RIGHT + input_KICK
  DEFB $88                ; input_DOWN + input_RIGHT + input_KICK
  DEFB $85                ; input_DOWN + input_LEFT  + input_KICK

; Maps route indices to arrays of valid rooms or areas.
;
; in_permitted_area uses this to check if the hero is in an area permitted for the current route.
route_to_permitted:
  DEFB $2A,$F9,$9E        ; (Route 42: 9EF9)
  DEFB $05,$FC,$9E        ; (Route  5: 9EFC)
  DEFB $0E,$01,$9F        ; (Route 14: 9F01)
  DEFB $10,$08,$9F        ; (Route 16: 9F08)
  DEFB $2C,$0E,$9F        ; (Route 44: 9F0E)
  DEFB $2B,$11,$9F        ; (Route 43: 9F11)
  DEFB $2D,$13,$9F        ; (Route 45: 9F13)
; Seven variable-length arrays which encode a list of valid rooms (if top bit is set) or permitted areas (0, 1 or 2) for a given route and step within the route. Terminated with $FF.
;
; Note that while routes encode transitions _between_ rooms this table encodes individual rooms or areas, so each list here will be one entry longer than the corresponding route.
;
; In the table: R => Room, A => Area
  DEFB $82,$82,$FF        ; ( R2, R2,                    $FF)
  DEFB $83,$01,$01,$01,$FF ; ( R3, A1,  A1,  A1,          $FF)
  DEFB $01,$01,$01,$00,$02,$02,$FF ; ( A1, A1,  A1,  A0,  A2, A2, $FF)
  DEFB $01,$01,$95,$97,$99,$FF ; ( A1, A1, R21, R23, R25,     $FF)
  DEFB $83,$82,$FF        ; ( R3, R2,                    $FF)
  DEFB $99,$FF            ; (R25,                        $FF)
  DEFB $01,$FF            ; ( A1,                        $FF)

; Boundings of the three main exterior areas.
permitted_bounds:
  DEFB $56,$5E,$3D,$48    ; Corridor to exercise yard
  DEFB $4E,$84,$47,$74    ; Hut area
  DEFB $4F,$69,$2F,$3F    ; Exercise yard area

; Check the hero's map position, check for escape and colour the flag accordingly.
;
; This also sets the main (hero's) map position in hero_map_position_x to that of the hero's vischar position.
;
; Used by the routine at main_loop.
in_permitted_area:
  LD HL,$800F             ; Point HL at the hero's vischar position
  LD DE,hero_map_position_x ; Point DE at the hero's map position
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Is it indoors?
  JP NZ,ipa_indoors       ; Jump if so
ipa_outdoors:
  CALL pos_to_tinypos     ; Scale down the vischar position and assign the result to the hero's map position
; Check for the hero escaping across the edge of the map (obviously this only can happen outdoors).
  LD HL,($8018)           ; If the hero's isometric x position is 217 * 8 or higher... jump to "hero has escaped"
  LD DE,$06C8             ;
  SBC HL,DE               ;
  JP NC,escaped           ;
  LD HL,($801A)           ; If the hero's isometric y position is 137 * 8 or higher... jump to "hero has escaped"
  LD DE,$0448             ;
  SBC HL,DE               ;
  JP NC,escaped           ;
  JR ipa_picking_or_cutting ; Otherwise jump over the indoors handling
ipa_indoors:
  LDI                     ; Copy position across
  INC L                   ;
  LDI                     ;
  INC L                   ;
  LDI                     ;
; Set the flag red if picking a lock, or cutting wire.
ipa_picking_or_cutting:
  LD A,($8001)            ; Read hero's vischar flags
  AND $03                 ; AND the flags with (vischar_FLAGS_PICKING_LOCK OR vischar_FLAGS_CUTTING_WIRE)
  JP NZ,ipa_set_flag_red  ; If either of those flags is set then set the morale flag red
; Is it night time?
  LD A,(clock)            ; Read the game clock
  CP $64                  ; If it's 100 or higher then it's night time
  JR C,ipa_day            ; Jump if it's not night time
; At night, home room is the only safe place.
ipa_night:
  LD A,(room_index)       ; What room are we in?
  CP $02                  ; Is it the home room? (room_2_HUT2LEFT)
  JP Z,ipa_set_flag_green ; Jump if so
  JP ipa_set_flag_red     ; Otherwise set the flag red
; If in solitary then bypass all checks.
ipa_day:
  LD A,(in_solitary)      ; Are we in solitary?
  AND A                   ;
  JP NZ,ipa_set_flag_green ; Jump if we are
; Not in solitary: turn the route into an area number then check that area is a permitted one.
  LD HL,$8002             ; Point HL at the hero's vischar route
  LD A,(HL)               ; Load the route index
  INC L                   ; Load the route step
  LD C,(HL)               ;
  BIT 7,A                 ; Is the route index's route_REVERSED flag set? ($80)
  JR Z,ipa_check_wander   ; Jump if not
  INC C                   ; Otherwise increment the route step
ipa_check_wander:
  CP $FF                  ; Is the route index routeindex_255_WANDER? ($FF)
  JR NZ,ipa_en_route      ; Jump if not
; Hero is wandering.
  LD A,(HL)               ; Load the route step again and clear its bottom three bits
  AND $F8                 ;
  CP $08                  ; If step is 8 then set A to 1 (hut area) otherwise set A to 2 (exercise yard area)
  LD A,$01                ;
  JR Z,ipa_bounds_check   ;
  LD A,$02                ;
ipa_bounds_check:
  CALL in_permitted_area_end_bit ; Check that the hero is in the specified room or camp bounds
  JR Z,ipa_set_flag_green ; Jump if within the permitted area (Z set)
  JR ipa_set_flag_red     ; Otherwise goto set_flag_red
; Hero is en route.
;
; Check regular routes against route_to_permitted.
ipa_en_route:
  AND $7F                 ; Mask off the route_REVERSED flag
  LD HL,route_to_permitted ; Point HL at route_to_permitted table
  LD B,$07                ; Set B for seven iterations
; Start loop
ipa_route_check_loop:
  CP (HL)                 ; Does the first byte of the entry match the route index?
  INC HL                  ;
  JR Z,ipa_route_check_found ; Jump if so
  INC HL                  ; Otherwise move to the next entry
  INC HL                  ;
  DJNZ ipa_route_check_loop ; ...loop
; If the route is not found in route_to_permitted assume a green flag
  JR ipa_set_flag_green   ; Jump if route index wasn't found in the table
; Route index was found in route_to_permitted.
ipa_route_check_found:
  LD E,(HL)               ; Load DE with the sub-table's address
  INC HL                  ;
  LD D,(HL)               ;
  PUSH DE                 ; Move it into HL
  POP HL                  ;
  LD B,$00                ; Zero B so we can use BC in the next instruction
  ADD HL,BC               ; Fetch byte at HL + BC
  LD A,(HL)               ;
  PUSH DE                 ; Save the sub-table's address
  CALL in_permitted_area_end_bit ; Check that the hero is in the specified room or camp bounds
  POP HL                  ; Restore the sub-table address
  JR Z,ipa_set_flag_green ; Jump if within the permitted area (Z set)
  LD A,($8002)            ; Load the hero's vischar route index
  BIT 7,A                     ; If the route index's route_REVERSED flag is set ($80) move the sub-table pointer forward by a byte
  JR Z,ipa_check_route_places ;
  INC HL                      ;
; Search through the list testing against the places permitted for the route we're on.
ipa_check_route_places:
  LD BC,$0000             ; Initialise index
; Start loop
ipa_check_route_places_loop:
  PUSH BC                 ; Save index
  PUSH HL                 ; Save sub-table address
  ADD HL,BC               ; Fetch byte at HL + BC
  LD A,(HL)               ;
  CP $FF                  ; Did we hit the end of the list?
  JR Z,ipa_pop_and_set_flag_red ; Jump if we did
  CALL in_permitted_area_end_bit ; Check that the hero is in the specified room or camp bounds
  POP HL                  ; Restore the sub-table address
  POP BC                  ; Restore the index
  JR Z,ipa_set_route_then_set_flag_green ; If within the area (Z set) break out of the loop
  INC C                   ; Increment counter
  JR ipa_check_route_places_loop ; ...loop
ipa_set_route_then_set_flag_green:
  LD A,($8002)            ; Fetch the hero's route index
  LD B,A                  ;
  CALL set_hero_route     ; Set the hero's route (to A,C) unless in solitary
  JR ipa_set_flag_green   ; Jump to "set flag green"
ipa_pop_and_set_flag_red:
  POP BC                  ; Restore the stack pointer position - don't care about order
  POP HL                  ;
  JR ipa_set_flag_red     ; Jump to "set flag red"
; Green flag code path.
ipa_set_flag_green:
  XOR A                   ; Clear the red flag
  LD C,$44                ; Load C with attribute_BRIGHT_GREEN_OVER_BLACK
ipa_flag_select:
  LD (red_flag),A         ; Assign red_flag
  LD A,C                  ; Shuffle wanted attribute value into A
  LD HL,$5842             ; Point HL at the first attribute byte of the morale flag
  CP (HL)                 ; Is the flag already the correct colour?
  RET Z                   ; Return if so
  CP $44                  ; Are we in the green flag case?
  JP NZ,set_morale_flag_screen_attributes ; Exit via set_morale_flag_screen_attributes if not
  LD A,$FF                ; Silence the bell
  LD (bell),A             ;
  LD A,C                  ; Shuffle wanted attribute value into A
  JP set_morale_flag_screen_attributes ; Exit via set_morale_flag_screen_attributes
; Red flag code path.
ipa_set_flag_red:
  LD C,$42                ; Load C with attribute_BRIGHT_RED_OVER_BLACK
  LD A,($5842)            ; Fetch the first attribute byte of the morale flag
  CP C                    ; Is the flag already the correct colour?
  RET Z                   ; Return if so
  XOR A                   ; Set the vischar's input to 0
  LD ($800D),A            ;
  LD A,$FF                ; Set the red flag flag
  JR ipa_flag_select      ; Jump to flag_select

; Check that the hero is in the specified room or camp bounds.
;
; Used by the routine at in_permitted_area.
;
; I:A If bit 7 is set then bits 0..6 contain a room index. Otherwise it's an area index as passed into within_camp_bounds.
; O:F Z set if in the permitted area.
in_permitted_area_end_bit:
  LD HL,room_index        ; Point HL at the global current room index
  BIT 7,A                 ; Was the permitted_route_ROOM flag set on entry? ($80)
  JR Z,end_bit_area       ; Jump if not
  AND $7F                 ; Mask off the room flag
  CP (HL)                 ; Does the specified room match the global current room index?
  RET                     ; Return immediately with the result in flags
end_bit_area:
  EX AF,AF'               ; Bank A
  LD A,(HL)               ; Fetch the global current room index
  AND A                   ; Is it room_0_OUTDOORS? (0)
  RET NZ                  ; Return if not
  LD DE,hero_map_position_x ; Point DE at hero_map_position
  EX AF,AF'               ; Unbank A - restoring original A
; FALL THROUGH to within_camp_bounds.

; Is the specified position within the bounds of the indexed area?
;
; Used by the routine at solitary.
;
; I:A Index (0..2) into permitted_bounds[] table.
; I:DE Pointer to position (a TinyPos).
; O:F Z set if position is within the area specified.
;   Point HL at permitted_bounds[A]
within_camp_bounds:
  ADD A,A                 ; Multiply A by 4
  ADD A,A                 ;
  LD C,A                  ; Move it into BC
  LD B,$00                ;
  LD HL,permitted_bounds  ; Point HL at permitted_bounds
  ADD HL,BC               ; Add
; Test position against bounds
  LD B,$02                ; Iterate twice - first checking the X axis, then the Y axis
; Start loop
within_camp_bounds_0:
  LD A,(DE)               ; Fetch a position byte
  CP (HL)                 ; Is A less than the lower bound?
  RET C                   ; Return with flags NZ if so (outside area)
  INC HL                  ; Move to x1, or y1 on second iteration
  CP (HL)                 ; Is A less than the upper bound?
  JR C,within_camp_bounds_1 ; Jump to the next loop iteration if so (inside area)
  OR $01                  ; Otherwise return with flags NZ (outside area)
  RET                     ;
within_camp_bounds_1:
  INC DE                  ; Advance to second axis for position
  INC HL                  ; Advance to second axis for bounds
  DJNZ within_camp_bounds_0 ; ...loop
  AND B                   ; Return with flags Z (within area)
  RET                     ;

; Wave the morale flag.
;
; Used by the routines at main_loop and menu_screen.
wave_morale_flag:
  LD HL,game_counter      ; Point HL at the game counter
  INC (HL)                ; Increment the game counter in-place
; Wave the flag on every other turn.
  LD A,(HL)               ; Now fetch the game counter
  AND $01                 ; Is its bottom bit set?
  RET NZ                  ; Return if so
  PUSH HL                 ; Save the game counter pointer
  LD A,(morale)           ; Fetch morale
  LD HL,displayed_morale  ; Point HL at currently displayed morale
  CP (HL)                 ; Is the currently displayed morale different to the actual morale?
  JR Z,wave_morale_flag_2 ; It's equal - jump straight to wiggling the flag
  JP NC,wave_morale_flag_0 ; Actual morale exceeds displayed morale - jump to the increasing case
; Decreasing morale.
  DEC (HL)                ; Decrement displayed morale
  LD HL,(moraleflag_screen_address) ; Get the current screen address of the morale flag
  CALL next_scanline_down ; Given a screen address, return the same position on the next scanline down
  JR wave_morale_flag_1   ; Jump over increasing morale block
; Increasing morale.
wave_morale_flag_0:
  INC (HL)                ; Increment displayed morale
  LD HL,(moraleflag_screen_address) ; Get the current screen address of the morale flag
  CALL next_scanline_up   ; Given a screen address, returns the same position on the next scanline up
wave_morale_flag_1:
  LD (moraleflag_screen_address),HL ; Set the screen address of the morale flag
; Wiggle and draw the flag.
wave_morale_flag_2:
  LD DE,bitmap_flag_down  ; Point DE at bitmap_flag_down
  POP HL                  ; Restore the game counter pointer
  BIT 1,(HL)              ; Is bit 1 set?
  JR Z,wave_morale_flag_3 ; Skip next instruction if not
; Note that the last three rows of the bitmap_flag_up bitmap overlap with the first three of the bitmap_flag_down bitmap.
  LD DE,bitmap_flag_up    ; Point DE at bitmap_flag_up
wave_morale_flag_3:
  LD HL,(moraleflag_screen_address) ; Get the screen address of the morale flag
  LD BC,$0319             ; Plot the flag always at 24x25 pixels in size
  JP plot_bitmap          ; Exit via plot_bitmap

; Set the screen attributes of the morale flag.
;
; Used by the routines at in_permitted_area and main.
;
; I:A Screen attributes to use.
set_morale_flag_screen_attributes:
  LD HL,$5842             ; Point HL at the top-left attribute byte of the morale flag
  LD DE,$001E             ; Set DE to the rowskip (32 attributes per row, minus 2)
  LD B,$13                ; The flag is 19 attributes high
; Start loop
set_morale_flag_screen_attributes_0:
  LD (HL),A               ; Write out three attribute bytes
  INC L                   ;
  LD (HL),A               ;
  INC L                   ;
  LD (HL),A               ;
  ADD HL,DE               ; Move to next row
  DJNZ set_morale_flag_screen_attributes_0 ; ...loop
  RET                     ; Return

; Given a screen address, returns the same position on the next scanline up.
;
; Spectrum screen memory addresses have the form:
;
; +----+----+----+----+----+----+---+---+---+---+---+---+---+---+---+---+
; | 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
; | 0-1-0        | Y7-Y6   | Y2-Y1-Y0   | Y5-Y4-Y3  | X4-X3-X2-X1-X0    |
; +--------------+---------+------------+-----------+-------------------+
;
; To calculate the address of the previous scanline (that is the next scanline higher up) we test two of the fields in sequence and subtract accordingly:
;
; Y2-Y1-Y0: If this field is non-zero it's an easy case: we can just decrement the top byte (e.g. using DEC H). Only the bottom three bits of Y will be affected.
;
; Y5-Y4-Y3: If this field is zero we can add $FFE0 (-32) to HL. This is like adding "-1" to the register starting from bit 5 upwards. Since Y2-Y1-Y0 and Y5-Y4-Y3 are both zero here we don't care about bits propagating across boundaries.
;
; Otherwise we add $06E0 (0000 0110 1110 0000) to HL. This will add 111 binary or "-1" to the Y5-Y4-Y3 field, which will carry out into Y0 for all possible values. Simultaneously it adds 110 binary or "-2" to the Y2-Y1-Y0 field (all zeroes)
; so the complete field becomes 111. Thus the complete field is decremented.
;
; Used by the routine at wave_morale_flag.
;
; I:HL Original screen address.
; O:HL Updated screen address.
next_scanline_up:
  LD A,H                  ; If Y2-Y1-Y0 zero jump to the complicated case
  AND $07                 ;
  JR Z,next_scanline_up_0 ;
; Easy case.
  DEC H                   ; Just decrement the high byte of the address to go back a scanline
  RET                     ; Return
; Complicated case.
next_scanline_up_0:
  LD DE,$06E0             ; Load DE with $06E0 by default
  LD A,L                  ; Is L < 32?
  CP $20                  ;
  JR NC,next_scanline_up_1 ; Jump if not
  LD D,$FF                ; If so bits Y5-Y4-Y3 are clear. Load DE with $FFE0 (-32)
next_scanline_up_1:
  ADD HL,DE               ; Add
  RET                     ; Return

; Delay loop called only when the hero is indoors.
;
; Used by the routine at main_loop.
interior_delay_loop:
  LD BC,$0FFF                 ; Count down from 4095
interior_delay_loop_0:
  DEC BC                      ;
  LD A,C                      ;
  OR B                        ;
  JR NZ,interior_delay_loop_0 ;
  RET                     ; Return

; Ring the alarm bell.
;
; Used by the routine at main_loop.
;
; Called three times from main_loop.
ring_bell:
  LD HL,bell              ; Point HL at bell ring counter/flag
  LD A,(HL)               ; Fetch its value
  CP $FF                  ; If it's bell_STOP then return
  RET Z                   ;
  AND A                   ; If it's bell_RING_PERPETUAL then jump over the decrement code
  JR Z,ring_bell_0        ;
; Decrement the ring counter.
  DEC A                   ; Decrement and store
  LD (HL),A               ;
  JR NZ,ring_bell_0       ; If it didn't hit zero then jump over the stop code
; Counter hit zero - stop ringing.
  LD A,$FF                ; Stop the bell
  LD (HL),A               ;
  RET                     ; Return
; Fetch visible state of bell from the screen.
ring_bell_0:
  LD A,($518E)            ; Fetch the bell ringing graphic from the screen
  CP $3F                  ; Is it $3F? (63)
  JP Z,ring_bell_2        ; If so, jump to plot "off" code
  JP ring_bell_1          ; Bug: Pointless jump to adjacent instruction
; Plot UDG for the bell ringer "on" and make the bell sound
ring_bell_1:
  LD DE,bell_ringer_bitmap_on ; Point DE at bell_ringer_bitmap_on
  CALL plot_ringer        ; Plot ringer
  LD BC,$2530             ; Play the "bell ringing" sound, exiting via it
  JR play_speaker         ;
; Plot UDG for the bell ringer "off".
ring_bell_2:
  LD DE,bell_ringer_bitmap_off ; Point DE at bell_ringer_bitmap_on
; FALL THROUGH to plot_ringer.

; Plot ringer.
;
; Used by the routine at ring_bell.
;
; I:HL Source bitmap.
plot_ringer:
  LD HL,$518E             ; Point HL at screenaddr_bell_ringer
  LD BC,$010C             ; Plot the bell always at 8x12 pixels in size, exiting via it
  JP plot_bitmap          ;

; Increase morale level.
;
; Used by the routines at increase_morale_by_10_score_by_50 and increase_morale_by_5_score_by_5.
;
; I:B Amount to increase morale level by. (Preserved)
increase_morale:
  LD A,(morale)           ; Fetch morale level and add B onto it
  ADD A,B                 ;
  CP $70                  ; Clamp morale level to morale_MAX (112)
  JR C,set_morale         ;
  LD A,$70                ;
; FALL THROUGH into set_morale.

; Set morale level.
;
; Used by the routines at increase_morale and decrease_morale.
;
; I:A Morale.
set_morale:
  LD (morale),A           ; Set morale level to A
  RET                     ; Return

; Decrease morale level.
;
; Used by the routines at event_another_day_dawns, searchlight_caught, solitary and item_discovered.
;
; I:B Amount to decrease morale level by. (Preserved)
decrease_morale:
  LD A,(morale)           ; Fetch morale level and subtract B from it
  SUB B                   ;
  JR NC,set_morale        ; Clamp morale level to morale_MIN (0)
  XOR A                   ;
  JR set_morale           ; Jump to set_morale

; Increase morale by 10, score by 50.
;
; Used by the routines at accept_bribe, action_red_cross_parcel, action_poison, action_uniform, action_shovel, action_key and action_papers.
increase_morale_by_10_score_by_50:
  LD B,$0A                ; Increase morale by 10
  CALL increase_morale    ;
  LD B,$32                ; Increase score by 50, exiting via it
  JR increase_score       ;

; Increase morale by 5, score by 5.
;
; Used by the routine at pick_up_item.
increase_morale_by_5_score_by_5:
  LD B,$05                ; Increase morale by 5
  CALL increase_morale    ;
  JR increase_score       ; Increase score by 5, exiting via it

; Increases the score then plots it.
;
; Used by the routines at enter_room, increase_morale_by_10_score_by_50 and increase_morale_by_5_score_by_5.
;
; I:B Amount to increase score by.
;
; Increment the score digit-wise until B is zero.
increase_score:
  LD A,$0A                ; Set A to our base: 10
  LD HL,$A136             ; Point HL at the last of the score digits
; Start loop
increase_score_0:
  PUSH HL                 ; Save HL
increment_score:
  INC (HL)                ; Increment the pointed-to score digit by one
  CP (HL)                 ; Has the pointed-to digit incremented to equal our base 10?
  JR NZ,increase_score_1  ; No - loop
  LD (HL),$00             ; Yes - reset the current digit to zero
  DEC HL                  ; Move to the next higher digit
  JR increment_score      ; "Recurse" - we'll arrive at the next instruction when we increment a digit which doesn't roll over
increase_score_1:
  POP HL                  ; Restore HL
  DJNZ increase_score_0   ; ...loop until the (score specified on entry) turns have been had
; FALL THROUGH into plot_score.

; Draws the current score to screen.
;
; Used by the routines at reset_game and main.
plot_score:
  LD HL,score_digits      ; Point HL at the first of the score digits
  LD DE,$5094             ; Point DE at the screen address of the score
  LD B,$05                ; Plot five digits
; Start loop
plot_score_0:
  PUSH BC                 ; Save BC
  CALL plot_glyph         ; Plot a single glyph pointed to by HL at DE
  INC HL                  ; Move to the next score digit
  INC DE                  ; Move to the next character position (in addition to plot_glyph's increment)
  POP BC                  ; Restore BC
  DJNZ plot_score_0       ; ...loop until all digits plotted
  RET                     ; Return

; Plays a sound.
;
; Used by the routines at pick_up_item, drop_item, ring_bell, spawn_character and target_reached.
;
; I:B Number of iterations to play for.
; I:C Delay inbetween each iteration.
play_speaker:
  LD A,C                  ; Self-modify the delay loop at $A126
  LD ($A126),A            ;
  LD A,$10                ; Initially set the speaker bit on
; Start loop
play_speaker_0:
  OUT ($FE),A             ; Play the speaker (and set the border)
  LD C,$37                ; Delay
play_speaker_1:
  DEC C                   ;
  JR NZ,play_speaker_1    ;
  XOR $10                 ; Toggle the speaker bit
  DJNZ play_speaker_0     ; ...loop
  RET                     ; Return

; Game counter.
;
; Counts 00..FF then wraps.
;
; Read-only by main_loop, picking_lock, cutting_wire, action_wiresnips, action_lockpick.
;
; Write/read-write by wave_morale_flag.
game_counter:
  DEFB $00

; Bell.
;
; +-------+-------------------+
; | Value | Meaning           |
; +-------+-------------------+
; | 0     | Ring indefinitely |
; | 255   | Don't ring        |
; | N     | Ring for N calls  |
; +-------+-------------------+
;
; Read-only by automatics.
;
; Write/read-write by in_permitted_area, ring_bell, event_wake_up, event_go_to_roll_call, event_go_to_breakfast_time, event_breakfast_time, event_go_to_exercise_time, event_exercise_time, event_go_to_time_for_bed, searchlight_caught,
; solitary, guards_follow_suspicious_character, event_roll_call.
bell:
  DEFB $FF

; Unreferenced byte.
LA131:
  DEFB $0A

; Score digits.
;
; Read-only by plot_score.
;
; Write/read-write by increase_score, reset_game.
score_digits:
  DEFB $00,$00,$00,$00,$00

; 'Hero is at breakfast' flag.
;
; Write/read-write by process_player_input, end_of_breakfast, hero_sit_sleep_common.
hero_in_breakfast:
  DEFB $00

; 'Red morale flag' flag.
;
; +-------+-------------------------------------+
; | Value | Meaning                             |
; +-------+-------------------------------------+
; | 0     | The hero is in a permitted area     |
; | 255   | The hero is not in a permitted area |
; +-------+-------------------------------------+
;
; Read-only by automatics, guards_follow_suspicious_character.
;
; Write/read-write by in_permitted_area.
red_flag:
  DEFB $00

; Automatic player counter.
;
; Counts down until zero at which point CPU control of the player is assumed. It's usually set to 31 by input events.
;
; Read-only by touch, automatics, character_behaviour.
;
; Write/read-write by check_morale, process_player_input, charevnt_hero_release, solitary.
automatic_player_counter:
  DEFB $00

; 'In solitary' flag.
;
; Stops set_hero_route working.
;
; Used to set flag colour.
;
; Read-only by process_player_input, in_permitted_area, set_hero_route, automatics.
;
; Write/read-write by charevnt_solitary_ends, solitary.
in_solitary:
  DEFB $00

; 'Morale exhausted' flag.
;
; Inhibits user input when non-zero.
;
; Set by check_morale.
;
; Reset by reset_game.
;
; Read-only by process_player_input.
;
; Write/read-write by check_morale.
morale_exhausted:
  DEFB $00

; Remaining morale.
;
; Ranges morale_MIN..morale_MAX.
;
; Read-only by check_morale, wave_morale_flag.
;
; Write/read-write by increase_morale, decrease_morale, reset_game.
morale:
  DEFB $70

; Game clock.
;
; Ranges 0..139.
;
; Read-only by in_permitted_area.
;
; Write/read-write by dispatch_timed_event, reset_map_and_characters.
clock:
  DEFB $07

; 'Character index is valid' flag.
;
; In character_bed_state etc.: when non-zero, character_index is valid, otherwise IY points to character_struct.
;
; Read-only by charevnt_bed, charevnt_breakfast.
;
; Write/read-write by set_route, spawn_character, move_characters, automatics, set_route.
entered_move_characters:
  DEFB $00

; 'Hero in bed' flag.
;
; Read-only by event_night_time,
;
; Write/read-write by process_player_input, wake_up, hero_sit_sleep_common.
hero_in_bed:
  DEFB $FF

; Currently displayed morale.
;
; This lags behind actual morale while the flag moves steadily to its target.
;
; Write/read-write by wave_morale_flag.
displayed_morale:
  DEFB $00

; Pointer to the screen address where the morale flag was last plotted.
;
; Write/read-write by wave_morale_flag.
moraleflag_screen_address:
  DEFW $5002

; Address of door (in locked_doors[]) in which bit 7 is cleared when picked.
;
; Read-only by picking_lock.
;
; Write/read-write by action_lockpick.
ptr_to_door_being_lockpicked:
  DEFW $0000

; The game time when player control will be restored.
;
; e.g. when picking a lock or cutting wire.
;
; Read-only by picking_lock, cutting_wire.
;
; Write/read-write by action_wiresnips, action_lockpick.
player_locked_out_until:
  DEFB $00

; 'Night-time' flag.
;
; +-------+------------+
; | Value | Meaning    |
; +-------+------------+
; | 0     | Daytime    |
; | 255   | Night-time |
; +-------+------------+
;
; Read-only by main_loop, choose_game_window_attributes.
;
; Write/read-write by set_day_or_night, reset_map_and_characters.
day_or_night:
  DEFB $00

; Bell ringer bitmaps.
;
; These are the bitmaps for the left hand side of the bell graphic which animates when the bell rings.
;
; 8x12 pixels.
bell_ringer_bitmap_off:
  DEFB $E7
  DEFB $E7
  DEFB $83
  DEFB $83
  DEFB $43
  DEFB $41
  DEFB $20
  DEFB $10
  DEFB $08
  DEFB $04
  DEFB $02
  DEFB $02
bell_ringer_bitmap_on:
  DEFB $3F
  DEFB $3F
  DEFB $27
  DEFB $13
  DEFB $13
  DEFB $09
  DEFB $08
  DEFB $04
  DEFB $04
  DEFB $02
  DEFB $02
  DEFB $01

; Set game window attributes.
;
; Used by the routines at pick_up_item, drop_item, event_another_day_dawns, screen_reset, searchlight_mask_test and choose_keys.
;
; Starting at $5847, set 23 columns of 16 rows to the specified attribute byte.
;
; I:A Attribute byte.
set_game_window_attributes:
  LD HL,$5847             ; Point HL at the top-left game window attribute
  LD C,$10                ; Set rows to 16
  LD DE,$0009             ; Set rowskip to 9 (32 - 23 columns)
; Start loop
set_game_window_attributes_0:
  LD B,$17                ; Set columns to 23
; Start loop
set_game_window_attributes_1:
  LD (HL),A               ; Set attribute byte
  INC L                   ; Step to the next
  DJNZ set_game_window_attributes_1 ; ...loop
  ADD HL,DE               ; Add rowskip
  DEC C                   ; Decrement row counter
  JP NZ,set_game_window_attributes_0 ; ...loop
  RET                     ; Return

; Timed events.
;
; Array of 15 structures which map game times to event handlers.
timed_events:
  DEFB $00,$D3,$A1        ; (   0, event_another_day_dawns ),
  DEFB $08,$E7,$A1        ; (   8, event_wake_up ),
  DEFB $0C,$28,$A2        ; (  12, event_new_red_cross_parcel ),
  DEFB $10,$F0,$A1        ; (  16, event_go_to_roll_call ),
  DEFB $14,$9A,$EF        ; (  20, event_roll_call ),
  DEFB $15,$F9,$A1        ; (  21, event_go_to_breakfast_time ),
  DEFB $24,$02,$A2        ; (  36, event_breakfast_time ),
  DEFB $2E,$06,$A2        ; (  46, event_go_to_exercise_time ),
  DEFB $40,$15,$A2        ; (  64, event_exercise_time ),
  DEFB $4A,$F0,$A1        ; (  74, event_go_to_roll_call ),
  DEFB $4E,$9A,$EF        ; (  78, event_roll_call ),
  DEFB $4F,$19,$A2        ; (  79, event_go_to_time_for_bed ),
  DEFB $62,$64,$A2        ; (  98, event_time_for_bed ),
  DEFB $64,$C3,$A1        ; ( 100, event_night_time ),
  DEFB $82,$6A,$A2        ; ( 130, event_search_light ),

; Dispatch timed events.
;
; Used by the routine at main_loop.
;
; Dispatches time-based game events like parcels, meals, exercise and roll calls.
;
; Increment the clock, wrapping at 140.
dispatch_timed_event:
  LD HL,clock             ; Point HL at the game clock
  LD A,(HL)               ; Load the game clock
  INC A                   ; ...and increment it
  CP $8C                       ; If it hits 140 then reset it to zero
  JR NZ,dispatch_timed_event_0 ;
  XOR A                        ;
dispatch_timed_event_0:
  LD (HL),A               ; Then save the game clock back
; Find an event for the current clock
  LD HL,timed_events      ; Point HL at the timed events table
  LD B,$0F                ; There are fifteen timed events
; Start loop
find_event:
  CP (HL)                 ; Does the current event's time match the game clock?
  INC HL                  ;
  JR Z,event_found        ; Jump to setup event handler if so
  INC HL                  ; Skip the event handler address
  INC HL                  ;
  DJNZ find_event         ; ...loop
  RET                     ; Return with no event matched
; Found an event
event_found:
  LD A,(HL)               ; Read the event handler address into HL
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
; Most events need to sound the bell, so prepare for that
  LD A,$28                ; Set A to bell_RING_40_TIMES
  LD BC,bell              ; Point BC at bell
  JP (HL)                 ; Jump to the event handler

; Event: Night time.
event_night_time:
  LD A,(hero_in_bed)      ; Is the hero already in his bed?
  AND A                   ;
  JR NZ,event_night_time_0 ; Skip route setting if so
  LD BC,$2C01             ; If not in bed set the hero's route to (routeindex_44_HUT2_RIGHT_TO_LEFT, 1) to make him move to bed
  CALL set_hero_route     ;
event_night_time_0:
  LD A,$FF                ; Set the night time flag ($FF)
  JR set_attrs            ; Jump to set_attrs

; Event: Another day dawns.
event_another_day_dawns:
  LD B,$13                ; Queue the message "ANOTHER DAY DAWNS"
  CALL queue_message      ;
  LD B,$19                ; Decrease morale by 25
  CALL decrease_morale    ;
  XOR A                   ; Clear the night time flag
; This entry point is used by the routine at event_night_time.
set_attrs:
  LD (day_or_night),A     ; Set the night-time flag to A
  CALL choose_game_window_attributes ; Choose game window attributes
  JP set_game_window_attributes ; Exit via set_game_window_attributes

; Event: Wake up.
event_wake_up:
  LD (BC),A               ; Ring the bell 40 times as passed in
  LD B,$01                ; Queue the message "TIME TO WAKE UP"
  CALL queue_message      ;
  JP wake_up              ; Exit via wake_up

; Event: Go to roll call.
event_go_to_roll_call:
  LD (BC),A               ; Ring the bell 40 times as passed in
  LD B,$08                ; Queue the message "ROLL CALL"
  CALL queue_message      ;
  JP go_to_roll_call      ; Exit via go_to_roll_call

; Event: Go to breakfast time.
event_go_to_breakfast_time:
  LD (BC),A               ; Ring the bell 40 times as passed in
  LD B,$02                ; Queue the message "BREAKFAST TIME"
  CALL queue_message      ;
  JP set_route_go_to_breakfast ; Exit via set_route_go_to_breakfast

; Event: Breakfast time.
event_breakfast_time:
  LD (BC),A               ; Ring the bell 40 times as passed in
  JP end_of_breakfast     ; Exit via end_of_breakfast

; Event: Go to exercise time.
event_go_to_exercise_time:
  LD (BC),A               ; Ring the bell 40 times as passed in
  LD B,$03                ; Queue the message "EXERCISE TIME"
  CALL queue_message      ;
  LD HL,$0100             ; Unlock the gates to the exercise yard
  LD (locked_doors),HL    ;
  JP set_route_go_to_yard ; Exit via set_route_go_to_yard

; Event: Exercise time.
event_exercise_time:
  LD (BC),A               ; Ring the bell 40 times as passed in
  JP set_route_go_to_yard_reversed ; Exit via set_route_go_to_yard_reversed

; Event: Go to time for bed.
event_go_to_time_for_bed:
  LD (BC),A               ; Ring the bell 40 times as passed in
  LD HL,$8180             ; Lock the gates to the exercise yard
  LD (locked_doors),HL    ;
  LD B,$04                ; Queue the message "TIME FOR BED"
  CALL queue_message      ;
  JP go_to_time_for_bed   ; Exit via go_to_time_for_bed

; Event: New red cross parcel.
;
; Don't deliver a new red cross parcel while the previous one still exists.
event_new_red_cross_parcel:
  LD A,($771D)            ; Fetch the red cross parcel's room (and flags)
  AND $3F                 ; Mask off the room part
  CP $3F                  ; Is it $3F? (i.e. room_NONE ($FF) masked)
  RET NZ                  ; Return if not
; Select the contents of the next parcel; choosing the first item from the list which does not already exist.
  LD DE,red_cross_parcel_contents_list ; Point DE at the red cross parcel contents list
  LD B,$04                ; There are four entries in the list
; Start loop
event_new_red_cross_parcel_0:
  LD A,(DE)               ; Fetch item number
  CALL item_to_itemstruct ; Turn it into an itemstruct
  INC HL                  ; Get its room and mask it
  LD A,(HL)               ;
  AND $3F                 ;
  CP $3F                  ; Is it $3F? (i.e. room_NONE ($FF) masked)
  JR Z,parcel_found       ; Jump to parcel_found if so
  INC DE
  DJNZ event_new_red_cross_parcel_0 ; ...loop while (...)
  RET                     ; Return - a parcel could not be spawned
parcel_found:
  LD A,(DE)                                ; Set red_cross_parcel_current_contents to the item number
  LD (red_cross_parcel_current_contents),A ;
  LD DE,$771D                       ; Copy the red cross parcel reset data over the red cross parcel itemstruct
  LD HL,red_cross_parcel_reset_data ;
  LD BC,$0006                       ;
  LDIR                              ;
  LD B,$09                ; Queue the message "RED CROSS PARCEL" and exit via
  JP queue_message        ;
; Red cross parcel reset data.
red_cross_parcel_reset_data:
  DEFB $14                ; Room: room_20_REDCROSS
  DEFB $2C,$2C,$0C        ; TinyPos: (44, 44, 12)
  DEFB $80,$F4            ; Coord: (128, 244)
; Red cross parcel contents list.
red_cross_parcel_contents_list:
  DEFB $0E                ; item_PURSE
  DEFB $00                ; item_WIRESNIPS
  DEFB $05                ; item_BRIBE
  DEFB $0F                ; item_COMPASS

; Current contents of red cross parcel.
red_cross_parcel_current_contents:
  DEFB $FF

; Event: Time for bed.
event_time_for_bed:
  LD A,$A6                ; Set route to (REVERSED routeindex_38_GUARD_12_BED, 3)
  LD C,$03                ;
  JR set_guards_route     ; Jump to $A26E

; Event: Search light.
event_search_light:
  LD A,$26                ; Set route to (routeindex_38_GUARD_12_BED, 0)
  LD C,$00                ;
; This entry point is used by the routine at event_time_for_bed.
;
; Common end of event_time_for_bed and event_search_light. Sets the route for guards 12..15 to (C + 0, A)..(C + 3, A) respectively.
;
; TODO: Split off to its own routine
set_guards_route:
  EX AF,AF'               ; bank
  LD A,$0C                ; Set character index to character_12_GUARD_12
  LD B,$04                ; 4 iterations
; Start loop
event_search_light_0:
  PUSH AF
  CALL set_character_route ; Set the route for a character in A to route (A', C)
  POP AF
  INC A                   ; Increment the character index
  EX AF,AF'
  INC A                   ; Increment the route index
  EX AF,AF'
  DJNZ event_search_light_0 ; ...loop
  RET                     ; Return

; List of non-player characters: six prisoners and four guards.
;
; Read-only by set_prisoners_and_guards_route, set_prisoners_and_guards_route_B.
prisoners_and_guards:
  DEFB $0C                ; character_12_GUARD_12
  DEFB $0D                ; character_13_GUARD_13
  DEFB $14                ; character_20_PRISONER_1
  DEFB $15                ; character_21_PRISONER_2
  DEFB $16                ; character_22_PRISONER_3
  DEFB $0E                ; character_14_GUARD_14
  DEFB $0F                ; character_15_GUARD_15
  DEFB $17                ; character_23_PRISONER_4
  DEFB $18                ; character_24_PRISONER_5
  DEFB $19                ; character_25_PRISONER_6

; Wake up.
;
; Used by the routine at event_wake_up.
wake_up:
  LD A,(hero_in_bed)      ; If the hero's not in bed, jump forward (note: it could jump one instruction later instead)
  AND A                   ;
  JP Z,wake_up_0          ;
; Hero gets out of bed.
  LD HL,$800F             ; Set the hero's vischar position to (46, 46)
  LD (HL),$2E             ;
  INC L                   ;
  INC L                   ;
  LD (HL),$2E             ;
wake_up_0:
  XOR A                   ; Clear the 'hero in bed' flag
  LD (hero_in_bed),A      ;
  LD BC,$2A00             ; Set the hero's route to (routeindex_42_HUT2_LEFT_TO_RIGHT, 0)
  CALL set_hero_route     ;
; Position all six prisoners.
  LD HL,$769F             ; Point HL at characterstruct 20's room field (character 20 is the first of the prisoners)
  LD DE,$0007             ; Prepare the characterstruct stride
  LD A,$03                ; Prepare room_3_HUT2RIGHT
  LD B,$03                ; Do the first three prisoner characters
; Start loop
wake_up_1:
  LD (HL),A               ; Set this characterstruct's room to room_3_HUT2RIGHT
  ADD HL,DE               ; Advance to the next characterstruct
  DJNZ wake_up_1          ; ...loop
  LD A,$05                ; Prepare room_5_HUT3RIGHT
  LD B,$03                ; Do the second three prisoner characters
; Start loop
wake_up_2:
  LD (HL),A               ; Set this characterstruct's room to room_5_HUT3RIGHT
  ADD HL,DE               ; Advance to the next characterstruct
  DJNZ wake_up_2          ; ...loop
  LD A,$05                ; Set initial route index in A'. This gets incremented by set_prisoners_and_guards_route_B for every route it assigns
  EX AF,AF'               ;
  LD C,$00                ; Zero route step
  CALL set_prisoners_and_guards_route_B ; Set the routes of all characters in prisoners_and_guards
; Update all the bed objects to be empty.
  LD A,$09                ; Prepare interiorobject_EMPTY_BED
  LD HL,beds              ; Point HL at table of pointers to prisoner bed objects
; Bug: Seven iterations are specified here BUT there are only six beds in the 'beds' array. This results in a spurious write to ROM location $1A42.
  LD B,$07                ; Set seven iterations
; Start loop
wake_up_3:
  LD E,(HL)               ; Load the current bed object address into DE
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  LD (DE),A               ; Overwrite the current bed object with interiorobject_EMPTY_BED
  DJNZ wake_up_3          ; ...loop
; Update the hero's bed object to be empty and redraw if required.
  LD HL,roomdef_2_hut2_left_heros_bed ; Set room definition 2's bed object to interiorobject_EMPTY_BED
  LD (HL),A                           ;
  LD A,(room_index)       ; If the global current room index is outdoors, or is not a hut room (6 or above) then return
  AND A                   ;
  RET Z                   ;
  CP $06                  ;
  RET NC                  ;
  CALL setup_room         ; Expand out the room definition for room_index
  CALL plot_interior_tiles ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
  RET                     ; Return

; End of breakfast time.
;
; Used by the routine at event_breakfast_time.
end_of_breakfast:
  LD A,(hero_in_breakfast) ; If the hero's not at breakfast, jump forward (note: it could jump one instruction later instead)
  AND A                    ;
  JP Z,end_of_breakfast_0  ;
  LD HL,$800F             ; Set the hero's vischar position to (52,62)
  LD (HL),$34             ;
  INC L                   ;
  INC L                   ;
  LD (HL),$3E             ;
end_of_breakfast_0:
  XOR A                    ; Clear the 'at breakfast' flag
  LD (hero_in_breakfast),A ;
  LD BC,$9003             ; Set the hero's route to (REVERSED routeindex_16_BREAKFAST_25, 3)
  CALL set_hero_route     ;
; Position all six prisoners.
  LD HL,$769F             ; Point HL at characterstruct 20's room field (character 20 is the first of the prisoners)
  LD DE,$0007             ; Prepare the characterstruct stride
  LD A,$19                ; Prepare room_25_BREAKFAST
  LD B,$03                ; Do the first three prisoner characters
; Start loop
end_of_breakfast_1:
  LD (HL),A               ; Set this characterstruct's room to room_25_BREAKFAST
  ADD HL,DE               ; Advance to the next characterstruct
  DJNZ end_of_breakfast_1 ; ...loop
  LD A,$17                ; Prepare room_23_BREAKFAST
  LD B,$03                ; Do the second three prisoner characters
; Start loop
end_of_breakfast_2:
  LD (HL),A               ; Set this characterstruct's room to room_23_BREAKFAST
  ADD HL,DE               ; Advance to the next characterstruct
  DJNZ end_of_breakfast_2 ; ...loop
  LD A,$90                ; Set initial route index in A'. This gets incremented by set_prisoners_and_guards_route_B for every route it assigns
  EX AF,AF'               ;
  LD C,$03                ; Set route step to 3
  CALL set_prisoners_and_guards_route_B ; Set the routes of all characters in prisoners_and_guards
; Update all the benches to be empty.
  LD A,$0D                ; Prepare interiorobject_EMPTY_BENCH
  LD (roomdef_23_breakfast_bench_A),A ; Set room definition 23's bench_A object to interiorobject_EMPTY_BENCH
  LD (roomdef_23_breakfast_bench_B),A ; Set room definition 23's bench_B object to interiorobject_EMPTY_BENCH
  LD (roomdef_23_breakfast_bench_C),A ; Set room definition 23's bench_C object to interiorobject_EMPTY_BENCH
  LD (roomdef_25_breakfast_bench_D),A ; Set room definition 25's bench_D object to interiorobject_EMPTY_BENCH
  LD (roomdef_25_breakfast_bench_E),A ; Set room definition 25's bench_E object to interiorobject_EMPTY_BENCH
  LD (roomdef_25_breakfast_bench_F),A ; Set room definition 25's bench_F object to interiorobject_EMPTY_BENCH
  LD (roomdef_25_breakfast_bench_G),A ; Set room definition 25's bench_G object to interiorobject_EMPTY_BENCH
  LD A,(room_index)       ; If the global current room index is outdoors, or a tunnel room then return
  AND A                   ;
  RET Z                   ;
  CP $1D                  ;
  RET NC                  ;
  CALL setup_room         ; Expand out the room definition for room_index
  JP plot_interior_tiles  ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer and exit via (note: different to wake_up's end)

; Set the hero's route, unless he's in solitary.
;
; Used by the routines at in_permitted_area, event_night_time, wake_up, end_of_breakfast, go_to_time_for_bed, character_bed_vischar, set_route_go_to_yard, set_route_go_to_yard_reversed, set_route_go_to_breakfast, charevnt_breakfast_vischar
; and go_to_roll_call.
;
; I:B Route index.
; I:C Route step.
set_hero_route:
  LD A,(in_solitary)      ; Do nothing if the hero's in solitary
  AND A                   ;
  RET NZ                  ;
; FALL THROUGH into set_hero_route_force

; Set the hero's route
;
; Used by the routine at character_event.
;
; I:B Route index.
; I:C Route step.
set_hero_route_force:
  LD HL,$8001             ; Clear vischar_FLAGS_TARGET_IS_DOOR flag
  RES 6,(HL)              ;
  INC L                   ; Assign route
  LD (HL),B               ;
  INC L                   ;
  LD (HL),C               ;
  CALL set_route          ; Set the route
  RET                     ; Return

; Go to time for bed.
;
; Used by the routine at event_go_to_time_for_bed.
go_to_time_for_bed:
  LD BC,$8502             ; Set the hero's route to (REVERSED routeindex_5_EXIT_HUT2, 2)
  CALL set_hero_route     ;
  LD A,$85                ; Set route index to (REVERSED routeindex_5_EXIT_HUT2)
  EX AF,AF'               ;
  LD C,$02                ; Set route step to 2
  JP set_prisoners_and_guards_route_B ; Set the routes of all characters in prisoners_and_guards and exit via

; Set individual routes for all characters in prisoners_and_guards.
;
; The route passed in (A',C) is assigned to the first character. The second character gets route (A'+1,C) and so on.
;
; Used by the routine at go_to_roll_call.
;
; I:A' Route index.
; I:C Route step.
set_prisoners_and_guards_route:
  LD HL,prisoners_and_guards ; Point HL at prisoners_and_guards table of character indices
  LD B,$0A                ; Iterate over the ten entries
; Start loop
set_prisoners_and_guards_route_0:
  PUSH HL                 ; Save
  PUSH BC                 ; Save
  LD A,(HL)               ; Fetch the character index
  CALL set_character_route ; Set the route for the character
  EX AF,AF'               ; Increment the route index
  INC A                   ;
  EX AF,AF'               ;
  POP BC                  ; Restore
  POP HL                  ; Restore
  INC HL                  ; Advance to the next character
  DJNZ set_prisoners_and_guards_route_0 ; ...loop
  RET                     ; Return

; Set joint routes for all characters in prisoners_and_guards.
;
; The first half of the list (guards 12,13 and prisoners 1,2,3) are set to the route passed in (A',C). The second half of the list (guards 14,15 and prisoners 4,5,6) are set to route (A'+1,C).
;
; Used by the routines at wake_up, end_of_breakfast, go_to_time_for_bed, set_route_go_to_yard, set_route_go_to_yard_reversed and set_route_go_to_breakfast.
;
; I:A' Route index.
; I:C Route step.
set_prisoners_and_guards_route_B:
  LD HL,prisoners_and_guards ; Point HL at prisoners_and_guards table of character indices
  LD B,$0A                ; Iterate over the ten entries
; Start loop
set_prisoners_and_guards_route_B_0:
  PUSH HL                 ; Save
  PUSH BC                 ; Save
  LD A,(HL)               ; Fetch the character index
  CALL set_character_route ; Set the route for the character
  POP BC                  ; Check the loop index
; When this is 6, the character being processed is character_22_PRISONER_3 and the next is character_14_GUARD_14, the start of the second half of the list.
  LD A,B                  ; Is it six?
  CP $06                  ;
  JR NZ,set_prisoners_and_guards_route_B_1 ; Jump over if not
  EX AF,AF'               ; Otherwise increment the route index
  INC A                   ;
  EX AF,AF'               ;
set_prisoners_and_guards_route_B_1:
  POP HL                  ; Restore
  INC HL                  ; Advance to the next character
  DJNZ set_prisoners_and_guards_route_B_0 ; ...loop
  RET                     ; Return

; Set the route for a character.
;
; Used by the routines at event_search_light, set_prisoners_and_guards_route and set_prisoners_and_guards_route_B.
;
; Finds a charstruct, or a vischar, and stores a route.
;
; I:A Character index.
; I:A' Route index.
; I:C Route step.
; O:BC Preserved.
set_character_route:
  CALL get_character_struct ; Get a pointer to the character struct in HL for character index A
  BIT 6,(HL)              ; Is the character on-screen? characterstruct_FLAG_ON_SCREEN
  JP Z,set_character_struct_route ; It's not - jump to characterstruct setting code
set_vischar_route:
  PUSH BC                 ; Save route step
  LD A,(HL)               ; A = *HL & characterstruct_CHARACTER_MASK;
  AND $1F                 ;
; Search non-player characters to see if this character is already on-screen.
  LD B,$07                ; There are seven non-player vischars
  LD DE,$0020             ; Prepare the vischar stride
  LD HL,$8020             ; Point HL at the second visible character
; Start loop
set_character_route_0:
  CP (HL)                 ; Is this the character we want?
  JR Z,set_character_route_vischar_found ; Jump if so
  ADD HL,DE               ; Advance the vischar pointer
  DJNZ set_character_route_0 ; ...loop
  POP BC                  ; Restore
  JR set_character_route_exit ; Jump to exit (note: why not just RET here?)
  DEFB $19                ; Unreferenced byte
set_character_struct_route:
  INC HL                  ; Advance HL to point to the characterstruct's route
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  CALL store_route        ; Store the route at HL
set_character_route_exit:
  RET                     ; Return
set_character_route_vischar_found:
  POP BC                  ; Restore route step
  INC L                   ; Reset vischar_FLAGS_TARGET_IS_DOOR flag
  RES 6,(HL)              ;
  INC L                   ;
  CALL store_route        ; Store the route at HL
; FALL THROUGH into set_route.

; Calls get_target and assigns the result into vischar.
;
; Used by the routine at set_hero_route.
;
; I:HL Points to route.step.
; O:BC Preserved.
set_route:
  XOR A                          ; Clear the entered_move_characters flag so that the vischar pointed to by IY is used for character events
  LD (entered_move_characters),A ;
  PUSH BC                 ; Preserve for callers
  PUSH HL                 ; Preserve route.step pointer
  DEC L                   ; Point HL at route.index
  CALL get_target         ; Get our next target: a location, a door or 'route ends'. The result is returned in A, target pointer returned in HL
  POP DE                  ; Restore route.step pointer to DE
  INC E                   ; Point DE at vischar.target
  LDI                     ; Copy target across
  LDI                     ;
  CP $FF                  ; Did get_target return get_target_ROUTE_ENDS? ($FF)
  JP NZ,set_route_not_end ; Jump if not
; Result was 'route ends'
  LD A,E                  ; Point DE at the vischar's start
  SUB $06                 ;
  LD E,A                  ;
  PUSH DE                 ; Assign current vischar to IY
  POP IY                  ;
  EX DE,HL                ; Swap vischar pointer into HL
  INC L                   ; Point HL at route
  INC L                   ;
  CALL get_target_assign_pos ; Call get_target_assign_pos so that the end-of-route handling code is invoked if required. Note: This seems like something of a waste as get_target is (appears to be) called again with the same arguments as
                             ; above
  POP BC                  ; Restore
  RET                     ; Return
; Result was a location or a door
set_route_not_end:
  CP $80                  ; Did get_target return get_target_DOOR? ($80)
  JP NZ,set_route_exit    ; Jump if not (it must be get_target_LOCATION)
set_route_door:
  LD A,E                  ; Point DE at vischar.flags
  SUB $05                 ;
  LD E,A                  ;
  EX DE,HL                ; Swap vischar pointer into HL
  SET 6,(HL)              ; Set the vischar_FLAGS_TARGET_IS_DOOR flag
set_route_exit:
  POP BC                  ; Restore
  RET                     ; Return

; Store a route at the specified address.
;
; Used by the routine at set_character_route.
;
; I:A' Route index.
; I:C Route step.
; I:HL Pointer to route.
; O:HL Pointer to route.step.
store_route:
  EX AF,AF'               ; Unbank the route index
  LD (HL),A               ; Store the route index
  EX AF,AF'               ; Bank the route index
  INC HL                  ; Store the route step
  LD (HL),C               ;
  RET                     ; Return

; Character goes to bed: used when entered_move_characters is non-zero.
;
; Used by the routine at character_event.
;
; I:HL Pointer to location.
character_bed_state:
  LD A,(character_index)  ; Get the current character index
  JR character_bed_common ; Jump to character_bed_common

; Character goes to bed: used when entered_move_characters is zero.
;
; Used by the routine at character_event.
;
; I:HL Pointer to location.
character_bed_vischar:
  LD A,(IY+$00)           ; Read the current vischar's character index
  AND A                      ; If it's not the commandant (0) then goto character_bed_common
  JR NZ,character_bed_common ;
  LD BC,$2C00             ; Otherwise set the commandant's route to ($2C,$00) and exit via
  JP set_hero_route       ;

; Common end of above two routines.
;
; Used by the routines at character_bed_state and character_bed_vischar.
;
; I:A Character index.
; I:HL Pointer to route.
character_bed_common:
  INC HL                  ; Clear route's step
  LD (HL),$00             ;
  CP $13                  ; Is the character a hostile? (its index less than or equal to character_19_GUARD_DOG_4)
  JP Z,character_bed_hostile ; Jump to hostile handling if so
  JP C,character_bed_hostile ;
  SUB $0D                 ; Compute the route index by subtracting 13 from the character index, e.g. character 20 is assigned route 7
  JR character_bed_common_0 ; Jump to end part
character_bed_hostile:
  BIT 0,A                 ; Does this hostile have an odd numbered character index?
  LD A,$0D                ; Set the default route index to 13
  JR Z,character_bed_common_0 ; Jump to exit if it had an even numbered character index
  LD (HL),$01             ; Otherwise reverse its route by setting the route step to 1 and setting the reversed route flag
  OR $80                  ;
character_bed_common_0:
  DEC HL                  ; Save route index
  LD (HL),A               ;
  RET                     ; Return

; Character sits.
;
; Used by the routine at character_event.
;
; I:A Route index.
; I:HL Pointer to route.
character_sits:
  PUSH AF                 ; Save the route index
  EX DE,HL                ; Move the route pointer into DE for the common part later
  SUB $12                 ; Bias the route index by 18
  LD HL,roomdef_25_breakfast_bench_D ; Point HL at room definition 25's bench_D
  CP $03                  ; Is A equal to two or lower? Jump if so
  JR C,character_sits_0   ;
  LD HL,roomdef_23_breakfast_bench_A ; Point HL at room definition 23's bench_A
  SUB $03                 ; Bias...
; Poke object.
character_sits_0:
  LD C,A                  ; Triple A
  ADD A,A                 ;
  ADD A,C                 ;
  LD B,$00                ; Move it into BC
  LD C,A                  ;
  ADD HL,BC               ; Point to the required object
  LD (HL),$05             ; Set the object at HL to interiorobject_PRISONER_SAT_MID_TABLE ($05)
  POP AF                  ; Restore the route index
  LD C,$19                ; Room is room_25_BREAKFAST
  CP $15                  ; Is the route index less than routeindex_21_PRISONER_SITS_1?
  JR C,character_sit_sleep_common ; Jump if so
  LD C,$17                ; Otherwise room is room_23_BREAKFAST
  JR character_sit_sleep_common ; Jump to character_sit_sleep_common

; Character sleeps.
;
; Used by the routine at character_event.
;
; I:A Route index.
; I:HL Pointer to route.
character_sleeps:
  PUSH AF                 ; Save the route index
  SUB $07                 ; Route indices 7..12 map to beds array indices 0..5
  ADD A,A                 ; Turn index into an offset
  EX DE,HL                ; Move the route pointer into DE for the common part later
; Poke object.
  LD C,A                  ; Fetch the bed object pointer from beds array
  LD B,$00                ;
  LD HL,beds              ;
  ADD HL,BC               ;
  LD C,(HL)               ;
  INC HL                  ;
  LD B,(HL)               ;
  LD A,$17                ; Write interiorobject_OCCUPIED_BED to the bed object
  LD (BC),A               ;
  POP AF                  ; Restore the route index
  CP $0A                  ; Is the route index greater than or equal to routeindex_10_PRISONER_SLEEPS_1?
  JP NC,character_sleeps_0 ; Jump if so
  LD C,$03                      ; Otherwise room is room_3_HUT2RIGHT
  JR character_sit_sleep_common ;
character_sleeps_0:
  LD C,$05                ; Room is room_5_HUT3RIGHT
; FALL THROUGH into character_sit_sleep_common.

; Common end of character sits/sleeps.
;
; Used by the routines at character_sits and character_sleeps.
;
; I:C Room.
; I:DE Pointer to route.
character_sit_sleep_common:
  EX DE,HL                ; Move the route pointer back into HL
  LD (HL),$00             ; Stand still - set the character's route to route_HALT ($00) (Note: This receives a pointer to a route structure which is within either a characterstruct or a vischar).
  EX AF,AF'               ; (unknown)
  LD A,(room_index)                ; If the global current room index matches C ... Jump to refresh code
  CP C                             ;
  JR Z,character_sit_sleep_refresh ;
; Character is sitting or sleeping in a room presently not visible.
  DEC HL                  ; Point HL at characterstruct's room member
  DEC HL                  ;
  DEC HL                  ;
  DEC HL                  ;
  LD (HL),$FF             ; Set room to room_NONE ($FF)
  RET                     ; Return
; Character is visible - force a repaint.
character_sit_sleep_refresh:
  LD A,L                  ; Pointer HL at vischar's room member
  ADD A,$1A               ;
  LD L,A                  ;
  LD (HL),$FF             ; Set room to room_NONE ($FF)
; FALL THROUGH into select_room_and_plot.

; Select room and plot.
;
; Used by the routine at hero_sit_sleep_common.
select_room_and_plot:
  CALL setup_room         ; Expand out the room definition for room_index
  JP plot_interior_tiles  ; Expand tile buffer into screen buffer, exit via

; The hero sits.
;
; Used by the routine at character_event.
hero_sits:
  LD HL,roomdef_25_breakfast_bench_G ; Set room definition 25's bench_G object (where the hero sits) to interiorobject_PRISONER_SAT_DOWN_END_TABLE
  LD (HL),$13                        ;
  LD HL,hero_in_breakfast ; Point HL at the hero_in_breakfast flag
  JR hero_sit_sleep_common ; Jump to hero_sit_sleep_common

; The hero sleeps.
;
; Used by the routines at reset_game and character_event.
hero_sleeps:
  LD HL,roomdef_2_hut2_left_heros_bed ; Set room definition 2's bed object (where the hero sleeps) to interiorobject_OCCUPIED_BED
  LD (HL),$17                         ;
  LD HL,hero_in_bed       ; Point HL at the hero_in_bed flag
; FALL THROUGH into hero_sit_sleep_common.

; Common end of hero sits/sleeps.
;
; Used by the routine at hero_sits.
;
; I:HL Pointer to hero_in_breakfast or hero_in_bed flag.
hero_sit_sleep_common:
  LD (HL),$FF             ; Set the sit/sleep flag, whichever it was
  XOR A                   ; Stand still - set the hero's route to route_HALT ($00)
  LD HL,$8002             ;
  LD (HL),A               ;
; Set hero position (x,y) to zero.
  LD HL,$800F                  ; Zero $800F..$8012
  LD B,$04                     ;
hero_sit_sleep_common_0:
  LD (HL),A                    ;
  INC L                        ;
  DJNZ hero_sit_sleep_common_0 ;
  LD HL,$8000                            ; Reset the hero's screen position
  CALL calc_vischar_iso_pos_from_vischar ;
  JR select_room_and_plot ; Exit via select_room_and_plot

; Set hero's and prisoners_and_guards's routes to "go to yard".
;
; Used by the routine at event_go_to_exercise_time.
set_route_go_to_yard:
  LD BC,$0E00             ; Set the hero's route to (routeindex_14_GO_TO_YARD, 0)
  CALL set_hero_route     ;
  LD A,$0E                            ; And set the routes of all characters in prisoners_and_guards to the same route (exit via)
  EX AF,AF'                           ;
  LD C,$00                            ;
  JP set_prisoners_and_guards_route_B ;

; Set hero's and prisoners_and_guards's routes to "go to yard" reversed.
;
; Used by the routine at event_exercise_time.
set_route_go_to_yard_reversed:
  LD BC,$8E04             ; Set the hero's route to (REVERSED routeindex_14_GO_TO_YARD, 4)
  CALL set_hero_route     ;
  LD A,$8E                            ; And set the routes of all characters in prisoners_and_guards to the same route (exit via)
  EX AF,AF'                           ;
  LD C,$04                            ;
  JP set_prisoners_and_guards_route_B ;

; Set hero's and prisoners_and_guards's routes to "go to breakfast".
;
; Used by the routine at event_go_to_breakfast_time.
set_route_go_to_breakfast:
  LD BC,$1000             ; Set the hero's route to (routeindex_16_BREAKFAST_25, 0)
  CALL set_hero_route     ;
  LD A,$10                            ; And set the routes of all characters in prisoners_and_guards to the same route (exit via)
  EX AF,AF'                           ;
  LD C,$00                            ;
  JP set_prisoners_and_guards_route_B ;

; Character event: used when entered_move_characters is non-zero.
;
; Used by the routine at character_event.
;
; Something character related [very similar to the routine at $A3F3].
charevnt_breakfast_state:
  LD A,(character_index)  ; Get the current character index
  JR charevnt_breakfast_common ; Jump to charevnt_breakfast_common

; Character event: used when entered_move_characters is zero.
;
; Used by the routine at character_event.
charevnt_breakfast_vischar:
  LD A,(IY+$00)           ; Read the current vischar's character index
  AND A                           ; If it's not the commandant (0) then goto charevnt_breakfast_common
  JR NZ,charevnt_breakfast_common ;
  LD BC,$2B00             ; Otherwise set the commandant's route to ($2B,$00) and exit via
  JP set_hero_route       ;

; Common end of above two routines.
;
; Sets routes for prisoners and guards.
;
; Used by the routines at charevnt_breakfast_state and charevnt_breakfast_vischar.
;
; I:A Character index.
; I:HL Pointer to route.
charevnt_breakfast_common:
  INC HL                  ; Set the route's step to zero
  LD (HL),$00             ;
  CP $13                  ; Is the character index less than or equal to character_19_GUARD_DOG_4?
  JP Z,charevnt_breakfast_common_0 ; Jump to hostile handling if so
  JP C,charevnt_breakfast_common_0 ;
  SUB $02                 ; Map prisoner 1..6 to route 18..23 (routes to sitting)
  JR charevnt_breakfast_common_1 ; Jump to store
charevnt_breakfast_common_0:
  BIT 0,A                 ; Is the character index odd?
  LD A,$18                ; Route index is 24 if even
  JR Z,charevnt_breakfast_common_1 ; Jump to store if even
  INC A                   ; Route index is 25 if odd
charevnt_breakfast_common_1:
  DEC HL                  ; Store route index
  LD (HL),A               ;
  RET                     ; Return

; Go to roll call.
;
; Used by the routine at event_go_to_roll_call.
go_to_roll_call:
  LD A,$1A                ; Set route to (routeindex_26_GUARD_12_ROLL_CALL, 0)
  EX AF,AF'               ;
  LD C,$00                ;
  CALL set_prisoners_and_guards_route ; Set individual routes for prisoners_and_guards
  LD BC,$2D00             ; Set the hero's route to (routeindex_45_HERO_ROLL_CALL, 0)
  JP set_hero_route       ;

; Reset the screen.
;
; Used by the routines at keyscan_break and escaped.
screen_reset:
  CALL wipe_visible_tiles ; Wipe the visible tiles array
  CALL plot_interior_tiles ; Expand tile buffer into screen buffer
  CALL zoombox            ; Zoombox the scene onto the screen
  CALL plot_game_window   ; Plot the game screen
  LD A,$07                ; Set A to attribute_WHITE_OVER_BLACK
  JP set_game_window_attributes ; Set game window attributes (exit via)

; Hero has escaped.
;
; Used by the routine at in_permitted_area.
;
; Print 'well done' message then test to see if the correct objects were used in the escape attempt.
escaped:
  CALL screen_reset       ; Reset the screen
; Print standard prefix messages.
  LD HL,escape_strings    ; Point HL at the escape messages
  CALL screenlocstring_plot ; Print "WELL DONE" "YOU HAVE ESCAPED" "FROM THE CAMP" (each print call advances HL)
  CALL screenlocstring_plot ;
  CALL screenlocstring_plot ;
; Form an escape items bitfield.
  LD C,$00                ; Clear the item flags
  LD HL,items_held        ; Point HL at the first held item
  CALL join_item_to_escapeitem ; Turn the item into a flag
  INC HL                  ; Point HL at the second held item
  CALL join_item_to_escapeitem ; Turn the item into a flag, merging with previous result
; Print item-tailored messages.
  LD A,C                  ; Move flags into A
  CP $05                  ; If the flags show we're holding are escapeitem_COMPASS and escapeitem_PURSE then jump to the success case
  JR Z,escaped_success    ;
  CP $03                  ; Otherwise if we don't have both escapeitem_COMPASS and escapeitem_PAPERS jump to the captured case
  JR NZ,escaped_captured  ;
escaped_success:
  LD HL,$A5FD             ; Point HL at the fourth escape message
  CALL screenlocstring_plot ; Print "AND WILL CROSS THE "BORDER SUCCESSFULLY"
  CALL screenlocstring_plot ;
  LD A,$FF                ; Signal to reset the game at the end of this routine
  PUSH AF                 ;
  JR escaped_press_any_key ; Jump to "press any key"
escaped_captured:
  PUSH AF                 ; Save flags
  LD HL,$A628             ; Point HL at the sixth escape message
  CALL screenlocstring_plot ; Print "BUT WERE RECAPTURED"
  POP AF                  ; Fetch flags
  PUSH AF                 ;
  CP $08                  ; If flags include escapeitem_UNIFORM print "AND SHOT AS A SPY"
  JR NC,escaped_plot      ;
  LD HL,$A652             ; Point HL at the eighth escape message
  AND A                   ; If flags is zero then print "TOTALLY UNPREPARED"
  JR Z,escaped_plot       ;
  LD HL,$A667             ; Point HL at the ninth escape message
  BIT 0,A                 ; If there was no compass then print "TOTALLY LOST"
  JR Z,escaped_plot       ;
  LD HL,$A676             ; Print "DUE TO LACK OF PAPERS"
escaped_plot:
  CALL screenlocstring_plot ; Print
escaped_press_any_key:
  LD HL,$A68E               ; Print "PRESS ANY KEY"
  CALL screenlocstring_plot ;
; Wait for a keypress.
escaped_0:
  CALL keyscan_all        ; Wait for a key down
  JR NZ,escaped_0         ;
escaped_1:
  CALL keyscan_all        ; Wait for a key up
  JR Z,escaped_1          ;
  POP AF                  ; Fetch flags
; Reset the game, or send the hero to solitary.
  CP $FF                  ; Are the flags $FF?
  JP Z,reset_game         ; Reset the game if so (exit via)
  CP $08                  ; Are the flags greater or equal to escapeitem_UNIFORM?
  JP NC,reset_game        ; Reset the game if so (exit via)
  JP solitary             ; Otherwise send the hero to solitary (exit via)

; Check for any key press.
;
; Used by the routine at escaped.
;
; O:F NZ if a key was pressed, Z otherwise.
keyscan_all:
  LD BC,$FEFE             ; Set B to $FE (initial keyboard half-row selector) and C to $FE (keyboard port number)
; Start loop
keyscan_all_0:
  IN A,(C)                ; Read the port
  CPL                     ; Complement the value returned to change it from active-low
  AND $1F                 ; Discard any non-key flags
  RET NZ                  ; Return with Z clear if any key was pressed
  RLC B                   ; Rotate the half-row selector ($FE -> $FD -> $FB -> .. -> $7F)
  JP C,keyscan_all_0      ; ...loop until the zero bit shifts out (eight iterations)
  XOR A                   ; No keys were pressed - return with Z set
  RET                     ;

; Call item_to_escapeitem then merge result with a previous escapeitem.
;
; Used by the routine at escaped.
;
; I:C Previous return value.
; I:HL Pointer to (single) item slot.
; O:C Previous return value + escapeitem_ flag.
join_item_to_escapeitem:
  LD A,(HL)               ; Fetch the item we've been pointed at
  CALL item_to_escapeitem ; Turn the item into a flag
  ADD A,C                 ; Merge the new flag with the previous
  LD C,A                  ;
  RET                     ; Return

; Return a bitmask indicating the presence of items required for escape.
;
; Used by the routine at join_item_to_escapeitem.
;
; I:A Item.
; O:A Bitfield.
item_to_escapeitem:
  CP $0F                  ; Is it item_COMPASS?
  JR NZ,item_to_escapeitem_0 ; No - try the next interesting item
  LD A,$01                ; Otherwise return flag escapeitem_COMPASS
  RET                     ;
item_to_escapeitem_0:
  CP $03                  ; Is it item_PAPERS?
  JR NZ,item_to_escapeitem_1 ; No - try the next interesting item
  LD A,$02                ; Otherwise return flag escapeitem_PAPERS
  RET                     ;
item_to_escapeitem_1:
  CP $0E                  ; Is it item_PURSE?
  JR NZ,item_to_escapeitem_2 ; No - try the next interesting item
  LD A,$04                ; Otherwise return flag escapeitem_PURSE
  RET                     ;
item_to_escapeitem_2:
  CP $06                  ; Is it item_UNIFORM?
  LD A,$08                ; Return escapeitem_UNIFORM if so
  RET Z                   ;
  XOR A                   ; Otherwise return zero
  RET                     ;

; Plot a screenlocstring.
;
; A screenlocstring is a structure consisting of a screen address at which to start drawing, a count of glyph indices and an array of that number of glyph indices.
;
; Used by the routines at escaped, user_confirm and plot_statics_and_menu_text.
;
; I:HL Pointer to screenlocstring. O:HL Pointer to byte after screenlocstring.
screenlocstring_plot:
  LD E,(HL)               ; Read the screen address into DE
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  LD B,(HL)               ; Read the number of characters to plot
  INC HL                  ;
; HL now points at the first glyph to plot
;
; Start loop
screenlocstring_loop:
  PUSH BC                 ; Save the counter
  CALL plot_glyph         ; Plot a single glyph
  INC HL                  ; Advance the glyph pointer
  POP BC                  ; Restore the counter
  DJNZ screenlocstring_loop ; ...loop until the counter is zero
  RET                     ; Return

; Escape messages.
;
; "WELL DONE"
escape_strings:
  DEFB $6E,$40,$09,$1F,$0E,$15,$15,$23,$0D,$00,$17,$0E
; "YOU HAVE ESCAPED"
  DEFB $AA,$40,$10,$21,$00,$1D,$23,$11,$0A,$1E,$0E,$23,$0E,$1B,$0C,$0A,$18,$0E,$0D
; "FROM THE CAMP"
  DEFB $CC,$40,$0D,$0F,$1A,$00,$16,$23,$1C,$11,$0E,$23,$0C,$0A,$16,$18
; "AND WILL CROSS THE"
  DEFB $09,$48,$12,$0A,$17,$0D,$23,$1F,$12,$15,$15,$23,$0C,$1A,$00,$1B,$1B,$23,$1C,$11,$0E
; "BORDER SUCCESSFULLY"
  DEFB $29,$48,$13,$0B,$00,$1A,$0D,$0E,$1A,$23,$1B,$1D,$0C,$0C,$0E,$1B,$1B,$0F,$1D,$15,$15,$21
; "BUT WERE RECAPTURED"
  DEFB $09,$48,$13,$0B,$1D,$1C,$23,$1F,$0E,$1A,$0E,$23,$1A,$0E,$0C,$0A,$18,$1C,$1D,$1A,$0E,$0D
; "AND SHOT AS A SPY"
  DEFB $2A,$48,$11,$0A,$17,$0D,$23,$1B,$11,$00,$1C,$23,$0A,$1B,$23,$0A,$23,$1B,$18,$21
; "TOTALLY UNPREPARED"
  DEFB $29,$48,$12,$1C,$00,$1C,$0A,$15,$15,$21,$23,$1D,$17,$18,$1A,$0E,$18,$0A,$1A,$0E,$0D
; "TOTALLY LOST"
  DEFB $2C,$48,$0C,$1C,$00,$1C,$0A,$15,$15,$21,$23,$15,$00,$1B,$1C
; "DUE TO LACK OF PAPERS"
  DEFB $28,$48,$15,$0D,$1D,$0E,$23,$1C,$00,$23,$15,$0A,$0C,$14,$23,$00,$0F,$23,$18,$0A,$18,$0E,$1A,$1B
; "PRESS ANY KEY"
  DEFB $0D,$50,$0D,$18,$1A,$0E,$1B,$1B,$23,$0A,$17,$21,$23,$14,$0E,$21

; Bitmap font definition.
;
; 0..9, A..Z (omitting O), space, full stop
bitmap_font:
  DEFB $00,$7C,$FE,$EE,$EE,$EE,$FE,$7C ; 0
  DEFB $00,$1E,$3E,$6E,$0E,$0E,$0E,$0E ; 1
  DEFB $00,$7C,$FE,$CE,$1C,$70,$FE,$FE ; 2
  DEFB $00,$FC,$FE,$0E,$3C,$0E,$FE,$FC ; 3
  DEFB $00,$0E,$1E,$3E,$6E,$FE,$0E,$0E ; 4
  DEFB $00,$FC,$C0,$FC,$7E,$0E,$FE,$FC ; 5
  DEFB $00,$38,$60,$FC,$FE,$C6,$FE,$7C ; 6
  DEFB $00,$FE,$0E,$0E,$1C,$1C,$38,$38 ; 7
  DEFB $00,$7C,$EE,$EE,$7C,$EE,$EE,$7C ; 8
  DEFB $00,$7C,$FE,$C6,$FE,$7E,$0C,$38 ; 9
  DEFB $00,$38,$7C,$7C,$EE,$EE,$FE,$EE ; A
  DEFB $00,$FC,$EE,$EE,$FC,$EE,$EE,$FC ; B
  DEFB $00,$1E,$7E,$FE,$F0,$FE,$7E,$1E ; C
  DEFB $00,$F0,$FC,$EE,$EE,$EE,$FC,$F0 ; D
  DEFB $00,$FE,$FE,$E0,$FE,$E0,$FE,$FE ; E
  DEFB $00,$FE,$FE,$E0,$FC,$E0,$E0,$E0 ; F
  DEFB $00,$1E,$7E,$F0,$EE,$F2,$7E,$1E ; G
  DEFB $00,$EE,$EE,$EE,$FE,$EE,$EE,$EE ; H
  DEFB $00,$38,$38,$38,$38,$38,$38,$38 ; I
  DEFB $00,$FE,$38,$38,$38,$38,$F8,$F0 ; J
  DEFB $00,$EE,$EE,$FC,$F8,$FC,$EE,$EE ; K
  DEFB $00,$E0,$E0,$E0,$E0,$E0,$FE,$FE ; L
  DEFB $00,$6C,$FE,$FE,$D6,$D6,$C6,$C6 ; M
  DEFB $00,$E6,$F6,$FE,$FE,$EE,$E6,$E6 ; N
  DEFB $00,$FC,$EE,$EE,$EE,$FC,$E0,$E0 ; P
  DEFB $00,$7C,$FE,$EE,$EE,$EE,$FC,$7E ; Q
  DEFB $00,$FC,$EE,$EE,$FC,$F8,$EC,$EE ; R
  DEFB $00,$7E,$FE,$F0,$7C,$1E,$FE,$FC ; S
  DEFB $00,$FE,$FE,$38,$38,$38,$38,$38 ; T
  DEFB $00,$EE,$EE,$EE,$EE,$EE,$FE,$7C ; U
  DEFB $00,$EE,$EE,$EE,$EE,$6C,$7C,$38 ; V
  DEFB $00,$C6,$C6,$C6,$D6,$FE,$EE,$C6 ; W
  DEFB $00,$C6,$EE,$7C,$38,$7C,$EE,$C6 ; X
  DEFB $00,$C6,$EE,$7C,$38,$38,$38,$38 ; Y
  DEFB $00,$FE,$FE,$0E,$38,$E0,$FE,$FE ; Z
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; SPACE
  DEFB $00,$00,$00,$00,$00,$00,$30,$30 ; FULL STOP

; An index used only by move_map().
move_map_y:
  DEFB $00

; Game window plotting offset.
game_window_offset:
  DEFW $0000

; Get supertiles.
;
; Using map_position copies supertile indices from map_tiles at $BCB8 into the map_buf buffer at $FF58.
;
; Used by the routines at shunt_map_left, shunt_map_right, shunt_map_up_right, shunt_map_up, shunt_map_down, shunt_map_down_left and reset_outdoors.
;
; Get vertical offset.
get_supertiles:
  LD A,($81BC)            ; Get the map position's Y component and round it down to a multiple of four
  AND $FC                 ;
; Multiply the Y component by 13.5 producing 0, 54, 108, 162, ...
  LD L,A                  ; Copy A into HL
  LD H,$00                ;
  RRA                     ; Halve A
  AND $7F                 ;
  ADD A,L                 ; Add A to HL, giving us Y multiplied by 1.5
  LD L,A                  ;
  JR NC,get_supertiles_0  ;
  INC H                   ;
get_supertiles_0:
  LD E,L                  ; Copy HL into DE
  LD D,H                  ;
  ADD HL,HL               ; Multiply by nine, giving us Y multiplied by 13.5
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,DE               ;
  LD DE,$BCB8             ; Point DE at map_tiles but minus a whole row
  ADD HL,DE               ; Combine
; Add the X component.
  LD A,(map_position)     ; Get the map position's X component and divide it by 4
  RRA                     ;
  RRA                     ;
  AND $3F                 ;
  LD E,A                  ; Move A into DE
  LD D,$00                ;
  ADD HL,DE               ; Combine. Now we have a pointer into map_tiles
; Populate map_buf with 7x5 array of supertile refs.
  LD A,$05                ; Five rows
  LD DE,map_buf           ; Point DE at map_buf (a 7x5 scratch buffer which holds copied-out supertile indices)
; Start loop
get_supertiles_1:
  LDI                     ; Fill the buffer row with seven bytes from HL
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LD BC,$002F             ; Move HL forward by (stride - width of map_buf)
  ADD HL,BC               ;
  DEC A                   ; ...loop
  JP NZ,get_supertiles_1  ;
  RET                     ; Return

; Plot the complete bottommost row of tiles.
;
; Used by the routines at shunt_map_up_right and shunt_map_up.
plot_bottommost_tiles:
  LD DE,$F278             ; Point DE' at the start of tile_buf's final row (= tile_buf + 24 * 16)
  EXX                     ;
  LD HL,$FF74             ; Point HL at the start of map_buf's final row (= map_buf + 7 * 4)
  LD A,($81BC)            ; Get the map's Y coordinate
  LD DE,inputroutine_kempston_1 ; Point DE at the start of window_buf's final row (= window_buf + 24 * 16 * 8)
  JR plot_horizontal_tiles_common ; Jump to plot_horizontal_tiles_common

; Plot the complete topmost row of tiles.
;
; Used by the routines at shunt_map_down and shunt_map_down_left.
plot_topmost_tiles:
  LD DE,$F0F8             ; Point DE' at the start of tile_buf's first row
  EXX                     ;
  LD HL,map_buf           ; Point HL at the start of map_buf's first row
  LD A,($81BC)            ; Get the map's Y coordinate
  LD DE,$F290             ; Point DE at the start of window_buf's first row
; FALL THROUGH into plot_horizontal_tiles_common

; Plots a single horizontal row of tiles to the screen buffer.
;
; Simultaneously updates the visible tiles buffer.
;
; Used by the routine at plot_bottommost_tiles.
;
; I:A Map Y position
; I:DE Pointer into the 24x17 visible tiles array ("tile_buf")
; I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
; I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
plot_horizontal_tiles_common:
  AND $03                 ; Compute the row offset within a supertile from the map's Y position (0, 4, 8 or 12)
  ADD A,A                 ;
  ADD A,A                 ;
  LD ($A86A),A            ; Self modify the "LD A,$xx" instruction at supertile_plot_horizontal_common_iters to load the row offset
  LD C,A                  ; Preserve the row offset in C for the next step
  LD A,(map_position)     ; Compute the column offset within a supertile from the map's X position (0, 1, 2 or 3)
  AND $03                 ;
  ADD A,C                 ; Now add it to the row offset - giving the combined offset
  EX AF,AF'               ; Bank the combined offset
; Initial edge. This draws up to 4 tiles.
  LD A,(HL)               ; Fetch a supertile index from map_buf
  EXX                     ; Switch register banks for the initial edge
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD A,$5B                ;
  ADD A,H                 ;
  LD H,A                  ;
  EX AF,AF'               ; Unbank the combined offset
  ADD A,L                 ; Add on the combined offset to HL to point us at the appropriate part of the supertile
  LD L,A                  ;
  NEG                                  ; Turn 0,1,2,3 into 4,3,2,1 - the number of initial loop iterations
  AND $03                              ;
  JR NZ,plot_horizontal_tiles_common_0 ;
  LD A,$04                             ;
plot_horizontal_tiles_common_0:
  LD B,A                  ; Set 1..4 iterations
; Start loop
plot_horizontal_tiles_common_1:
  LD A,(HL)               ; Fetch a tile index from the super tile pointer
  LD (DE),A               ; Store it in visible tiles (DE' on entry)
  CALL plot_tile          ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL'
  INC L                   ; Advance the tile pointer
  INC DE                  ; Advance the visible tiles pointer
  DJNZ plot_horizontal_tiles_common_1 ; ...loop
  EXX                     ; Unbank
  INC HL                  ; Advance the map buffer pointer
; Middle loop.
  LD B,$05                ; There are always five iterations (five supertiles in the middle section).
; Start loop (outer) -- advanced for each supertile
plot_horizontal_tiles_common_2:
  PUSH BC                 ; Preserve the loop counter
  LD A,(HL)               ; Fetch a supertile index from the map buffer pointer
  EXX                     ; Switch register banks during the middle loop
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,super_tiles       ;
  ADD HL,BC               ;
supertile_plot_horizontal_common_iters:
  LD A,$00                ; Load the row offset - self modified by $A82A
  ADD A,L                 ; Add on the row offset to HL
  LD L,A                  ;
  LD B,$04                ; Supertiles are four tiles wide
; Start loop (inner) -- advanced for each tile
plot_horizontal_tiles_common_3:
  LD A,(HL)               ; Fetch a tile index from the super tile pointer
  LD (DE),A               ; Store it in visible tiles
  CALL plot_tile          ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL'
  INC HL                  ; Advance the tiles pointer
  INC DE                  ; Advance the visible tiles pointer
  DJNZ plot_horizontal_tiles_common_3 ; ...loop (inner)
  EXX                     ; Unbank
  INC HL                  ; Advance the map buffer pointer
  POP BC                  ; Restore the loop counter
  DJNZ plot_horizontal_tiles_common_2 ; ...loop (outer)
; Trailing edge.
  LD A,C                  ; Spurious instructions
  EX AF,AF'               ;
  LD A,(HL)               ; Fetch a supertile index from map_buf
  EXX                     ; Switch register banks during the trailing loop
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,super_tiles       ;
  ADD HL,BC               ;
  LD A,($A86A)            ; Load the row offset from (self modified) $A86A
  ADD A,L                 ; Add on the row offset to HL
  LD L,A                  ;
  LD A,(map_position)     ; Form the trailing loop iteration counter
  AND $03                 ;
  RET Z                   ; Return if no iterations are required
  LD B,A                  ; Move iterations into B
; Start loop
plot_horizontal_tiles_common_4:
  LD A,(HL)               ; Fetch a tile index from the super tile pointer
  LD (DE),A               ; Store it in visible tiles
  CALL plot_tile          ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL'
  INC L                   ; Advance the tiles pointer
  INC DE                  ; Advance the visible tiles pointer
  DJNZ plot_horizontal_tiles_common_4 ; ...loop
  RET                     ; Return

; Plot all tiles.
;
; Renders the complete screen by plotting all vertical columns in turn.
;
; Used by the routines at pick_up_item and reset_outdoors.
;
; Note: Exits with banked registers active.
plot_all_tiles:
  LD DE,$F0F8             ; Point DE at the 24x17 visible tiles array ("tile_buf")
  EXX                     ; Bank
  LD HL,map_buf           ; Point HL' at the 7x5 supertile indices buffer ("map_buf")
  LD DE,$F290             ; Point DE' at the 24x17x8 screen buffer ("window_buf")
  LD A,(map_position)     ; Get map X position
  LD B,$18                ; Set 24 iterations (screen columns)
; Start loop
plot_all_tiles_0:
  PUSH BC                 ; Preserve the loop counter
  PUSH DE                 ; Preserve the screen buffer pointer
  PUSH HL                 ; Preserve the supertile indices pointer
  PUSH AF                 ; Preserve the map X position
  EXX                     ; Unbank
  PUSH DE                 ; Preserve the visible tiles pointer
  EXX                     ; Bank
  CALL plot_vertical_tiles_common ; Plot a complete column of tiles
  EXX                     ; Unbank
  POP DE                  ; Restore and advance the visible tiles pointer
  INC DE                  ;
  EXX                     ; Bank
  POP AF                  ; Restore the map X position
  POP HL                  ; Restore the supertile indices pointer
  INC A                   ; Advance the map X position
  LD C,A                  ; Save the result in C
  AND $03                 ; If the X position hits a multiple of 4 advance to the next supertile
  JR NZ,plot_all_tiles_1  ;
  INC HL                  ;
plot_all_tiles_1:
  LD A,C                  ; Restore the map X position
  POP DE                  ; Restore and advance the screen buffer pointer to the next column
  INC DE                  ;
  POP BC                  ; Restore the loop counter
  DJNZ plot_all_tiles_0   ; ...loop
  RET                     ; Return

; Plot the complete rightmost column of tiles.
;
; Used by the routines at shunt_map_left and shunt_map_down_left.
plot_rightmost_tiles:
  LD DE,$F10F             ; Point DE at the 24x17 visible tiles array ("tile_buf") rightmost column [+23]
  EXX                     ; Bank
  LD HL,$FF5E             ; Point HL' at the 7x5 supertile indices buffer ("map_buf") rightmost supertile [+6]
  LD DE,$F2A7             ; Point DE' at the 24x17x8 screen buffer ("window_buf") rightmost column [+23]
  LD A,(map_position)     ; Compute the column offset by ANDing the map's X position with 3
  AND $03                 ;
  JR NZ,plot_rightmost_tiles_0 ; If column offset is zero - use the previous supertile CHECK
  DEC HL                       ;
plot_rightmost_tiles_0:
  LD A,(map_position)     ; Get the map's X coordinate
  DEC A                   ; Decrement it
  JR plot_vertical_tiles_common ; Jump to plot_vertical_tiles_common

; Plot the complete leftmost column of tiles.
;
; Used by the routines at shunt_map_right and shunt_map_up_right.
plot_leftmost_tiles:
  LD DE,$F0F8             ; Point DE at the 24x17 visible tiles array ("tile_buf") leftmost column
  EXX                     ; Bank
  LD HL,map_buf           ; Point HL' at the 7x5 supertile indices buffer ("map_buf") leftmost supertile
  LD DE,$F290             ; Point DE' at the 24x17x8 screen buffer ("window_buf") leftmost column
  LD A,(map_position)     ; Get the map's X coordinate
; FALL THROUGH into plot_vertical_tiles_common

; Plots a single vertical row of tiles to the screen buffer.
;
; Simultaneously updates the visible tiles buffer.
;
; Used by the routines at plot_all_tiles and plot_rightmost_tiles.
;
; I:A Map X position
; I:DE Pointer into the 24x17 visible tiles array ("tile_buf")
; I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
; I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
plot_vertical_tiles_common:
  AND $03                 ; Compute the column offset within a supertile from the map's X position (0, 1, 2 or 3)
  LD ($A94D),A            ; Self modify the "LD A,$xx" instruction at $A94C to load the column offset
  LD C,A                  ; Preserve the column offset in C for the next step
  LD A,($81BC)            ; Compute the row offset within a supertile from the map's Y position (0, 4, 8 or 12)
  AND $03                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,C                 ; Now add it to the column offset - giving the combined offset
  EX AF,AF'               ; Bank the combined offset
; Initial edge. This draws up to 4 tiles.
  LD A,(HL)               ; Fetch a supertile index from map_buf
  EXX                     ; Switch register banks for the initial edge
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD A,$5B                ;
  ADD A,H                 ;
  LD H,A                  ;
  EX AF,AF'               ; Unbank the combined offset
  ADD A,L                 ; Add on the combined offset to HL to point us at the appropriate part of the supertile
  LD L,A                  ;
  RRA                                ; Turn 0,4,8,12 into 4,3,2,1 - the number of initial loop iterations
  RRA                                ;
  AND $03                            ;
  NEG                                ;
  AND $03                            ;
  JR NZ,plot_vertical_tiles_common_0 ;
  LD A,$04                           ;
plot_vertical_tiles_common_0:
  EX DE,HL                ; Transpose tile_buf and map_buf pointers
  LD BC,$0018             ; Set visible tiles stride
; Start loop
plot_vertical_tiles_common_1:
  PUSH AF                 ; Save the loop counter
  LD A,(DE)               ; Fetch a tile index from the super tile pointer
  LD (HL),A               ; Store it in the visible tiles (DE' on entry)
  CALL plot_tile_then_advance ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL' then advance DE' by a row
  LD A,$04                ; Advance the tile pointer by a supertile row (4)
  ADD A,E                 ;
  LD E,A                  ;
  ADD HL,BC               ; Advance the visible tiles pointer by a row (24)
  POP AF                  ; Restore the loop counter
  DEC A                              ; ...loop
  JP NZ,plot_vertical_tiles_common_1 ;
  EX DE,HL                ; Transpose the tile_buf and map_buf pointers back
  EXX                     ; Unbank
  LD A,L                             ; Advance the map buffer pointer by a row (7)
  ADD A,$07                          ;
  LD L,A                             ;
  JR NC,plot_vertical_tiles_common_2 ;
  INC H                              ;
; Middle loop.
plot_vertical_tiles_common_2:
  LD B,$03                ; There are always three iterations (three supertiles in the middle section).
; Start loop (outer) -- advanced for each supertile
plot_vertical_tiles_common_3:
  PUSH BC                 ; Preserve the loop counter
  LD A,(HL)               ; Fetch a supertile index from the map buffer pointer
  EXX                     ; Switch register banks during the middle loop
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,super_tiles       ;
  ADD HL,BC               ;
supertile_plot_vertical_common_iters:
  LD A,$00                ; Load the column offset - self modified by $A8F6
  ADD A,L                 ; Add on the column offset to HL
  LD L,A                  ;
  LD BC,$0018             ; Set visible tiles stride
  EX DE,HL                ; Transpose the tile_buf and map_buf pointers
  LD A,$04                ; Supertiles are four tiles high
; Start loop (inner) -- advanced for each tile
plot_vertical_tiles_common_4:
  PUSH AF                 ; Preserve the loop counter
  LD A,(DE)               ; Fetch a tile index from the super tile pointer
  LD (HL),A               ; Store it in visible tiles
  CALL plot_tile_then_advance ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL' then advance DE' by a row
  ADD HL,BC               ; Advance the visible tiles pointer by a row
  LD A,$04                ; Advance the tiles pointer by a row
  ADD A,E                 ;
  LD E,A                  ;
  POP AF                  ; Restore the loop counter
  DEC A                              ; ...loop (inner)
  JP NZ,plot_vertical_tiles_common_4 ;
  EX DE,HL                ; Transpose the tile_buf and map_buf pointers back
  EXX                     ; Unbank
  LD A,L                             ; Advance the map buffer pointer
  ADD A,$07                          ;
  LD L,A                             ;
  JR NC,plot_vertical_tiles_common_5 ;
  INC H                              ;
plot_vertical_tiles_common_5:
  POP BC                  ; Restore the loop counter
  DJNZ plot_vertical_tiles_common_3 ; ...loop (outer)
; Trailing edge.
  LD A,(HL)               ; Fetch a supertile index from map_buf
  EXX                     ; Switch register banks during the trailing loop
  LD L,A                  ; Point HL at super_tiles[A]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,super_tiles       ;
  ADD HL,BC               ;
  LD A,($A94D)            ; Load the column offset from (self modified) $A94D
  ADD A,L                 ; Add on the column offset to HL
  LD L,A                  ;
  LD A,($81BC)            ; Form the trailing loop iteration counter
  AND $03                 ;
  INC A                   ;
  LD BC,$0018             ; Set visible tiles stride
  EX DE,HL                ; Transpose the tile_buf and map_buf pointers
; Start loop
plot_vertical_tiles_common_6:
  PUSH AF                 ; Preserve the loop counter
  LD A,(DE)               ; Fetch a tile index from the super tile pointer
  LD (HL),A               ; Store it in visible tiles
  CALL plot_tile_then_advance ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL' then advance DE' by a row
  LD A,$04                ; Advance the tiles pointer by a row
  ADD A,E                 ;
  LD E,A                  ;
  ADD HL,BC               ; Advance the visible tiles pointer by a row
  POP AF                  ; Restore the loop counter
  DEC A                              ; ...loop
  JP NZ,plot_vertical_tiles_common_6 ;
  EX DE,HL                ; Transpose the tile_buf and map_buf pointers back
  RET                     ; Return

; Call plot_tile then advance the screen buffer pointer in DE' by a row.
;
; Used by the routine at plot_vertical_tiles_common.
;
; I:A Tile index
; I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
; I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
plot_tile_then_advance:
  CALL plot_tile          ; Plot the tile in A to the screen buffer at DE' using supertile pointer HL'
  EXX                     ; Bank
  LD A,E                         ; Advance the screen buffer pointer DE' to the next row (add 24 * 8 - 1)
  ADD A,$BF                      ;
  LD E,A                         ;
  JR NC,plot_tile_then_advance_0 ;
  INC D                          ;
plot_tile_then_advance_0:
  EXX                     ; Unbank
  RET                     ; Return

; Plot an exterior tile then advance DE' to the next column.
;
; Used by the routines at plot_horizontal_tiles_common and plot_tile_then_advance.
;
; I:A Tile index
; I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
; I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf") (used to select the correct tile group)
plot_tile:
  EXX                     ; Unbank input registers
  EX AF,AF'               ; Bank the tile index
  LD A,(HL)               ; Fetch a supertile index from map_buf
; Now map the tile index and supertile index into a tile pointer:
; +---------------------------------+------------------------------------+
; | Supertiles 44 and lower         | use tiles   0..249 (249 tile span) |
; | Supertiles 45..138 and 204..218 | use tiles 145..400 (255 tile span) |
; | Supertiles 139..203             | use tiles 365..570 (205 tile span) |
; +---------------------------------+------------------------------------+
  LD BC,exterior_tiles    ; Point BC at exterior_tiles[0]
  CP $2D                  ; If supertile index <= 44 jump to plot_tile_chosen
  JR C,plot_tile_chosen   ;
  LD BC,$8A18             ; Point BC at exterior_tiles[145]
  CP $8B                  ; If supertile index <= 138 or >= 204 jump to plot_tile_chosen
  JR C,plot_tile_chosen   ;
  CP $CC                  ;
  JR NC,plot_tile_chosen  ;
  LD BC,$90F8             ; Point BC at exterior_tiles[365]
plot_tile_chosen:
  PUSH HL                 ; Preserve the supertile pointer
  EX AF,AF'               ; Unbank the tile index
  LD L,A                  ; Point HL at BC[tile index]
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,BC               ;
  PUSH DE                 ; Preserve the screen buffer pointer
  EX DE,HL                ; Transpose
  LD BC,$0018             ; Set the screen buffer stride to 24
  LD A,$08                ; Set eight iterations
; Start loop
plot_tile_loop:
  EX AF,AF'               ; Preserve the loop counter
  LD A,(DE)               ; Copy a byte of tile
  LD (HL),A               ;
  ADD HL,BC               ; Advance the destination pointer to the next row
  INC E                   ; Advance the source pointer
  EX AF,AF'               ; Restore the loop counter
  DEC A                   ; ...loop
  JP NZ,plot_tile_loop    ;
  POP DE                  ; Restore the screen buffer pointer
  INC DE                  ; Advance the screen buffer pointer
  POP HL                  ; Restore the supertile pointer
  EXX                     ; Re-bank input registers
  RET                     ; Return

; Shunt the map left.
;
; Used by the routine at move_map.
shunt_map_left:
  LD HL,map_position      ; Move the map position to the left
  INC (HL)                ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,$F0F9             ; Shunt the tile_buf back by one byte
  LD DE,$F0F8             ;
  LD BC,$0197             ;
  LDIR                    ;
  LD HL,$F291             ; Shunt the window_buf back by one byte
  LD DE,$F290             ;
  LD BC,$0CBF             ;
  LDIR                    ;
  CALL plot_rightmost_tiles ; Plot the complete rightmost column of tiles
  RET                     ; Return

; Shunt the map right.
;
; Used by the routine at move_map.
shunt_map_right:
  LD HL,map_position      ; Move the map position to the right
  DEC (HL)                ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,cmk_cpy_rout      ; Shunt the tile_buf forward by one byte
  LD DE,$F28F             ;
  LD BC,$0197             ;
  LDDR                    ;
; Bug: The length in the following is one byte too long.
  LD HL,$FF4F             ; Shunt the window_buf forward by one byte
  LD DE,$FF50             ;
  LD BC,$0CC0             ;
  LDDR                    ;
  CALL plot_leftmost_tiles ; Plot the complete leftmost column of tiles
  RET                     ; Return

; Shunt the map up-right.
;
; Used by the routine at move_map.
;
; I:HL Contents of map_position map position
shunt_map_up_right:
  DEC L                   ; Move the map position up (H) and to the right (L)
  INC H                   ;
  LD (map_position),HL    ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,$F110             ; Shunt the tile_buf up and to the right
  LD DE,$F0F9             ;
  LD BC,$0180             ;
  LDIR                    ;
  LD HL,choose_keys       ; Shunt the window_buf up and to the right
  LD DE,$F291             ;
  LD BC,$0C00             ;
  LDIR                    ;
  CALL plot_bottommost_tiles ; Plot the complete bottommost row of tiles
  CALL plot_leftmost_tiles ; Plot the complete leftmost column of tiles
  RET                     ; Return

; Shunt the map up.
;
; Used by the routine at move_map.
shunt_map_up:
  LD HL,$81BC             ; Move the map position up
  INC (HL)                ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,$F110             ; Shunt the tile_buf up
  LD DE,$F0F8             ;
  LD BC,$0180             ;
  LDIR                    ;
  LD HL,choose_keys       ; Shunt the window_buf up
  LD DE,$F290             ;
  LD BC,$0C00             ;
  LDIR                    ;
  CALL plot_bottommost_tiles ; Plot the complete bottommost row of tiles
  RET                     ; Return

; Shunt the map down.
;
; Used by the routine at move_map.
shunt_map_down:
  LD HL,$81BC             ; Move the map position down
  DEC (HL)                ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,$F277             ; Shunt the tile_buf down
  LD DE,$F28F             ;
  LD BC,$0180             ;
  LDDR                    ;
  LD HL,$FE8F             ; Shunt the window_buf down
  LD DE,$FF4F             ;
  LD BC,$0C00             ;
  LDDR                    ;
  CALL plot_topmost_tiles ; Plot the complete topmost row of tiles
  RET                     ; Return

; Shunt the map down left.
;
; Used by the routine at move_map.
shunt_map_down_left:
  INC L                   ; Shunt the map position down (H) and to the left (L)
  DEC H                   ;
  LD (map_position),HL    ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  LD HL,$F277             ; Shunt the tile_buf down
  LD DE,cmk_cpy_rout      ;
  LD BC,$017F             ;
  LDDR                    ;
  LD HL,$FE8F             ; Shunt the window_buf down
  LD DE,$FF4E             ;
  LD BC,$0BFF             ;
  LDDR                    ;
  CALL plot_topmost_tiles ; Plot the complete topmost row of tiles
  CALL plot_rightmost_tiles ; Plot the complete rightmost column of tiles
  RET                     ; Return

; Move the map when the hero walks around outdoors.
;
; The map is shunted around in the opposite direction to the apparent character motion.
;
; Used by the routines at setup_movable_items and main_loop.
move_map:
  LD A,(room_index)       ; Ignore any attempt to move the map when we're indoors
  AND A                   ;
  RET NZ                  ;
  LD HL,$8007             ; Is the hero's vischar_BYTE7_DONT_MOVE_MAP flag set? (See AF93)
  BIT 6,(HL)              ;
  RET NZ                  ; Return if so
  LD HL,$800A             ; Point HL at the hero's animation pointer field
  LD E,(HL)               ; Fetch the animation pointer into DE
  INC L                   ;
  LD D,(HL)               ;
  INC L                   ;
  LD C,(HL)               ; Load the current animation index
  INC DE                  ; Step forward through the animation structure to the map direction field
  INC DE                  ;
  INC DE                  ;
  LD A,(DE)               ; Read the animation's map direction field
  CP $FF                  ; A map direction of 255 means "don't move"
  RET Z                   ; Return if 255
  BIT 7,C                 ; If animation index's vischar_ANIMINDEX_REVERSE bit is set then exchange the up and down directions
  JR Z,move_map_0         ;
  XOR $02                 ;
move_map_0:
  PUSH AF                 ; Preserve map direction
  ADD A,A                   ; Point HL at move_map_jump_table[A]
  LD C,A                    ;
  LD B,$00                  ;
  LD HL,move_map_jump_table ;
  ADD HL,BC                 ;
  LD A,(HL)               ; Load jump address into HL
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  POP AF                  ; Restore map direction
  PUSH HL                 ; Stack the jump table target - our final RET will call it
  PUSH AF                 ; Preserve map direction
; Calculate the position at which we should stop scrolling the map
;
; For example in the animation anim_walk_tl (where 'tl' denotes a character walking towards the top left) we're asked to scroll the map to the bottom and right. If the map scrolls further than 192 across we'll render off the side of the
; map, so we clamp the scroll at that point. Similar for vertical.
;
; +------------------------+---------------------------------------+
; | Direction              | Clamps at (x,y)                       |
; +------------------------+---------------------------------------+
; | direction_TOP_LEFT     | (192,124) aka bottom right of the map |
; | direction_TOP_RIGHT    | (0,124) aka bottom left of the map    |
; | direction_BOTTOM_RIGHT | (0,0) aka top left of the map         |
; | direction_BOTTOM_LEFT  | (192,0) aka top right of th map       |
; +------------------------+---------------------------------------+
  LD BC,$7C00             ; Set the initial clamp position (x,y) to (C = 0,B = 124)
  CP $02                  ; If the map scroll direction is direction_BOTTOM_* (scrolling up) then the y limit becomes 0
  JR C,move_map_1         ;
  LD B,$00                ;
move_map_1:
  CP $01                  ; If the map scroll direction is direction_*_LEFT (scrolling right) then the x limit becomes 192
  JR Z,move_map_2         ;
  CP $02                  ;
  JR Z,move_map_2         ;
  LD C,$C0                ;
move_map_2:
  LD HL,(map_position)    ; Read the current map position into HL
  LD A,L                  ; If current map X equals limit X then return
  CP C                    ;
  JR NZ,move_map_4        ;
move_map_3:
  POP AF                  ; Restore map direction
  POP HL                  ; Restore jump table target
  RET                     ; Return
move_map_4:
  LD A,H                  ; If current map Y equals limit Y then return
  CP B                    ;
  JR Z,move_map_3         ;
  POP AF                  ; Restore map direction
; Now we form a counter that's used by the move_map functions to decide in which order the map shunt operations will be issued. Instead of immediately shunting the map in the named direction, they use this counter to work through a pattern
; of moves.
  LD HL,move_map_y        ; Point HL at move_map_y
  CP $02                  ; Is the map direction direction_BOTTOM_*?
  JR NC,move_map_5        ; Jump if so
  LD A,(HL)               ; Cycle the counter forwards for TOP cases
  INC A                   ;
  JR move_map_6           ;
move_map_5:
  LD A,(HL)               ; Cycle the counter backwards for BOTTOM cases
  DEC A                   ;
move_map_6:
  AND $03                 ; Clamp to 0..3
  LD (HL),A               ; Save it back to move_map_y
  EX DE,HL                ; Transpose (for passing into move_map_*)
; Now choose the game window offset that will be used by plot_game_window. A 255 in the high byte means to plot the screen offset (which direction?) by half a byte. The low byte is a byte offset added to the source data.
  LD HL,$0000             ; Clear the game window offset (GWO)
  AND A                   ; If move_map_y is 0 GWO becomes (0, 0)
  JR Z,move_map_7         ;
  LD L,$60                ; If move_map_y is 2 GWO becomes (4 * 24, 0)
  CP $02                  ;
  JR Z,move_map_7         ;
  LD HL,$FF30             ; If move_map_y is 1 GWO becomes (2 * 24, 255)
  CP $01                  ;
  JR Z,move_map_7         ;
  LD L,$90                ; Otherwise GWO becomes (6 * 24, 255)
move_map_7:
  LD (game_window_offset),HL ; Write it to game_window_offset
  LD HL,(map_position)    ; Point HL at map_position
  RET                     ; NOT a return - pops and calls the move_map_* routine pushed at AAE0 which then returns
move_map_jump_table:
  DEFW move_map_up_left   ; move_map_up_left
  DEFW move_map_up_right  ; move_map_up_right
  DEFW move_map_down_right ; move_map_down_right
  DEFW move_map_down_left ; move_map_down_left
; Called when player moves down-right (map is shifted up or left). This moves the map in the pattern up/left/none/left.
move_map_up_left:
  LD A,(DE)               ; Fetch move_map_y
  AND A                   ; If move_map_y is 0 then jump to shunt_map_up
  JP Z,shunt_map_up       ;
  BIT 0,A                 ; If move_map_y is 2 then return
  RET Z                   ;
  JP shunt_map_left       ; Otherwise move_map_y is 1 or 3 - jump to shunt_map_left
; Called when player moves down-left (map is shifted up or right). This moves the map in the pattern up-right/none/right/none.
move_map_up_right:
  LD A,(DE)               ; Fetch move_map_y
  AND A                   ; If move_map_y is 0 then jump to shunt_map_up_right
  JP Z,shunt_map_up_right ;
  CP $02                  ; If move_map_y is 1 or 3 then return
  RET NZ                  ;
  JP shunt_map_right      ; Otherwise move_map_y is 2 - jump to shunt_map_right
; Called when player moves up-left (map is shifted down or right). This moves the map in the pattern right/none/right/down.
move_map_down_right:
  LD A,(DE)               ; Fetch move_map_y
  CP $03                  ; If move_map_y is 3 then jump to shunt_map_down
  JP Z,shunt_map_down     ;
  RRA                     ; If move_map_y is 0 or 2 then jump to shunt_map_right
  JP NC,shunt_map_right   ;
  RET                     ; Otherwise move_map_y is 1 - return
; Called when player moves up-right (map is shifted down or left). This moves the map in the pattern none/left/down/left.
move_map_down_left:
  LD A,(DE)               ; Fetch move_map_y
  CP $01                  ; If move_map_y is 1 then jump to shunt_map_left
  JP Z,shunt_map_left     ;
  CP $03                   ; If move_map_y is 3 then jump to shunt_map_down_left
  JP Z,shunt_map_down_left ;
  RET                     ; Otherwise move_map_y is 0 or 2 - return

; Zoombox parameters.
zoombox_x:
  DEFB $0C                ; X coordinate of left zoombox fill, in game window area
zoombox_width:
  DEFB $01                ; Maximum width (ish) of zoombox
zoombox_y:
  DEFB $08                ; Y coordinate of top zoombox fill, in game window area
zoombox_height:
  DEFB $01                ; Maximum height (ish) of zoombox

; Game window current attribute byte.
game_window_attribute:
  DEFB $07                ; Assigned by set_attribute_from_A. Used by zoombox_draw_tile_1 to set the attribute of a zoombox border tile

; Choose game window attributes.
;
; This uses the current room index and the night-time flag to decide which screen attributes should be used for the game window. Additionally, when in non-illuminated tunnel rooms it will wipe the visible tiles to obscure the tunnel's
; route.
;
; Used by the routines at pick_up_item, drop_item, event_another_day_dawns, zoombox, action_shovel and searchlight_mask_test.
;
; O:A Chosen attribute.
choose_game_window_attributes:
  LD A,(room_index)             ; If the global current room index is room_28_HUT1LEFT or below...
  CP $1D                        ;
  JR NC,choose_attribute_tunnel ;
; The hero is outside, or in a room, but not in a tunnel.
  LD A,(day_or_night)     ; Read the night-time flag
  LD C,$07                ; Default attribute is attribute_WHITE_OVER_BLACK
  AND A                   ; Is it night-time?
  JR Z,set_attribute_from_C ; Jump if not
; Consider night-time colours.
  LD A,(room_index)       ; Read the global current room index
  LD C,$41                ; For outside at night we use attribute_BRIGHT_BLUE_OVER_BLACK
  AND A                   ; Are we outside?
  JR Z,set_attribute_from_C ; Jump if so
  LD C,$05                ; Otherwise for inside at night we use attribute_CYAN_OVER_BLACK
set_attribute_from_C:
  LD A,C                  ; Copy
set_attribute_from_A:
  LD (game_window_attribute),A ; Assign game_window_attribute
  RET                     ; Return
; The hero is in a tunnel.
choose_attribute_tunnel:
  LD C,$02                ; For an illuminated tunnel we use attribute_RED_OVER_BLACK
  LD HL,(items_held)      ; Load HL with items_held
; If the hero holds a torch - illuminate the room.
  LD A,$04                ; Load item_TORCH into A
  CP L                    ; Item is torch?
  JR Z,set_attribute_from_C ; Jump if so
  CP H                    ; Item is torch?
  JR Z,set_attribute_from_C ; Jump if so
; The hero holds no torch - wipe the tiles so that nothing gets drawn.
  CALL wipe_visible_tiles ; Wipe the visible tiles array
  CALL plot_interior_tiles ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
  LD A,$01                ; For a dark tunnel we use attribute_BLUE_OVER_BLACK
  JR set_attribute_from_A ; Jump to set_attribute_from_A

; Zoombox.
;
; Animate the window buffer onto the screen via a zooming box effect.
;
; Used by the routines at enter_room, screen_reset and reset_outdoors.
zoombox:
  LD A,$0C                ; Initialise zoombox_x to 12
  LD (zoombox_x),A        ;
  LD A,$08                ; Initialise zoombox_y to 8
  LD (zoombox_y),A        ;
  CALL choose_game_window_attributes ; Choose the game window attributes (the chosen attribute is returned in A)
  LD H,A                  ; Duplicate attribute into both bytes of HL
  LD L,A                  ;
  LD ($5932),HL           ; Set the attributes of the initial zoombox fill rectangle
  LD ($5952),HL           ;
  XOR A                   ; Set zoombox_width and zoombox_height to zero
  LD (zoombox_width),A    ;
  LD (zoombox_height),A   ;
; Start loop Shrink X and grow width until X is 1
zoombox_0:
  LD HL,zoombox_x         ; Point HL at zoombox_x
  LD A,(HL)               ; Fetch it
  CP $01                  ; Is it 1?
  JP Z,zoombox_1          ; Skip the next chunk if so
  DEC (HL)                ; Decrement zoombox_x
  DEC A                   ; And the register copy too
  INC HL                  ; Point HL at zoombox_width
  INC (HL)                ; Increment zoombox_width
  DEC HL                  ; Step back
; Grow width until it's 22
zoombox_1:
  INC HL                  ; Point HL at zoombox_width
  ADD A,(HL)              ; Add width to x
  CP $16                  ; Did we hit 22?
  JP NC,zoombox_2         ; Jump if not
  INC (HL)                ; Increment zoombox_width
; Shrink Y and grow height until Y is 1
zoombox_2:
  INC HL                  ; Point HL at zoombox_y
  LD A,(HL)               ; Fetch it
  CP $01                  ; Is it 1?
  JP Z,zoombox_3          ; Skip the next chunk if so
  DEC (HL)                ; Decrement zoombox_y
  DEC A                   ; And the register copy too
  INC HL                  ; Point HL at zoombox_height
  INC (HL)                ; Increment zoombox_height
  DEC HL                  ; Step back
; Grow height until it's 15
zoombox_3:
  INC HL                  ; Point HL at zoombox_height
  ADD A,(HL)              ; Add height to y
  CP $0F                  ; Did we hit 15?
  JP NC,zoombox_4         ; Jump if not
  INC (HL)                ; Increment zoombox_height
zoombox_4:
  CALL zoombox_fill       ; Draw the zoombox contents
  CALL zoombox_draw_border ; Draw the zoombox border
  LD HL,zoombox_width     ; Sum the width and height
  LD A,(zoombox_height)   ;
  ADD A,(HL)              ;
  CP $23                  ; If it's less than 35 then ...loop
  JP C,zoombox_0          ;
  RET                     ; Return

; Draw the zoombox contents.
;
; Used by the routine at zoombox.
zoombox_fill:
  LD A,(zoombox_y)        ; Fetch zoombox_y
  LD H,A                  ; Multiply it by 128 and store it in DE
  XOR A                   ;
  SRL H                   ;
  RRA                     ;
  LD E,A                  ;
  LD D,H                  ;
  SRL H                   ; Multiply it by 64 and store it in HL
  RRA                     ;
  LD L,A                  ;
  ADD HL,DE               ; Sum the two, producing zoombox_y * 192
  LD A,(zoombox_x)        ; Fetch zoombox_x
  ADD A,L                 ; Add zoombox_x to zoombox_y * 192 producing the window buffer source offset
  LD L,A                  ;
  JR NC,zoombox_fill_0    ;
  INC H                   ;
zoombox_fill_0:
  LD DE,$F291             ; Point DE at window buffer + 1 (TODO: Explain the +1)
  ADD HL,DE               ; Form the final source pointer
  EX DE,HL                ; Free up HL for the next chunk
  LD A,(zoombox_y)        ; Fetch zoombox_y again
  ADD A,A                 ; Multiply it by 16 producing an offset into the game_window_start_addresses array
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  LD HL,game_window_start_addresses ; Point HL at the game_window_start_addresses array
  ADD A,L                 ; Combine it with the offset
  LD L,A                  ;
  JR NC,zoombox_fill_1    ;
  INC H                   ;
zoombox_fill_1:
  LD A,(HL)               ; Fetch the game window start address
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  LD A,(zoombox_x)        ; Fetch zoombox_x again
  ADD A,L                 ; Combine with game window start address
  LD L,A                  ;
  EX DE,HL                ; Get the source pointer back in HL
  LD A,(zoombox_width)    ; Fetch zoombox_width
  LD ($AC55),A            ; Self modify the 'SUB $00' at AC54
  NEG                     ; Compute source skip (24 - width)
  ADD A,$18               ;
  LD ($AC4D),A            ; Self modify the 'LD A,$00' at AC4C
  LD A,(zoombox_height)   ; Fetch zoombox_height (number of rows to copy)
  LD B,A                  ; Set outer iterations
; Start loop (outer) -- once for every row
zoombox_fill_2:
  PUSH BC                 ; Preserve iteration counter
  PUSH DE                 ; Preserve destination pointer
  LD A,$08                ; 8 iterations / 1 row
; Start loop (inner) -- once for every line
zoombox_fill_3:
  EX AF,AF'               ; Bank the counter
  LD A,(zoombox_width)    ; Fetch zoombox_width into BC
  LD C,A                  ;
  LD B,$00                ;
  LDIR                    ; Copy zoombox_width bytes from HL to DE, then advance those pointers
  LD A,$00                ; Load the (self modified) source skip
  ADD A,L                 ; Advance the source pointer by source skip bytes
  LD L,A                  ;
  JR NC,zoombox_fill_4    ;
  INC H                   ;
zoombox_fill_4:
  LD A,E                  ; Subtract the (self modified) zoombox_width from the destination pointer to undo LDIR's post-increment
  SUB $00                 ;
  LD E,A                  ;
  INC D                   ; Move to the next scanline by incrementing high byte
  EX AF,AF'               ; Unbank the inner loop counter
  DEC A                   ; ...loop (inner)
  JP NZ,zoombox_fill_3    ;
  POP DE                  ; Restore the destination pointer
  EX DE,HL                ; Exchange
  LD BC,$0020             ; Set the row-to-row delta to 32
  LD A,L                  ; Isolate
  CP $E0                  ; Is A < 224? This sets the C flag if we're NOT at the end of the current third of the screen
  JR C,zoombox_fill_5     ; Jump over if so
  LD B,$07                ; Otherwise set the stride to $0720 so we will step forward to the next third of the screen. In this case HL is of the binary form 010ttyyy111xxxxx. Adding $0720 - binary 0000011100100000 - will result in
                          ; 010TTyyy000xxxxx where the 't' bits are incremented, moving the pointer forward to the next screen third
zoombox_fill_5:
  ADD HL,BC               ; Step
  EX DE,HL                ; Exchange back
  POP BC                  ; Pop the outer loop counter
  DJNZ zoombox_fill_2     ; ...loop (outer)
  RET                     ; Return

; Draw the zoombox border.
;
; Used by the routine at zoombox.
zoombox_draw_border:
  LD A,(zoombox_y)        ; Fetch zoombox_y
  DEC A                   ; Subtract one so that we draw around the zoombox fill area
  ADD A,A                 ; Multiply it by 16 producing an offset into the game_window_start_addresses array
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  LD HL,game_window_start_addresses ; Point HL at the game_window_start_addresses array
  ADD A,L                     ; Combine it with the offset
  LD L,A                      ;
  JR NC,zoombox_draw_border_0 ;
  INC H                       ;
zoombox_draw_border_0:
  LD A,(HL)               ; Fetch the game window start address
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
; Top left corner tile.
  LD A,(zoombox_x)        ; Fetch zoombox_x
  DEC A                   ; Subtract one so that we draw around the zoombox fill area
  ADD A,L                 ; Combine with game window start address
  LD L,A                  ;
  LD A,$00                ; Draw a top-left zoombox border tile
  CALL zoombox_draw_tile  ;
  INC L                   ; Move the destination pointer forward
; Top horizontal run, moving right.
  LD A,(zoombox_width)    ; Fetch zoombox_width
  LD B,A                  ; Set iterations
; Start loop
zoombox_draw_border_1:
  LD A,$01                ; Draw a horizontal zoombox border tile
  CALL zoombox_draw_tile  ;
  INC L                   ; Move the destination pointer forward
  DJNZ zoombox_draw_border_1 ; ...loop
; Top right corner tile.
  LD A,$02                ; Draw a top-right zoombox border tile
  CALL zoombox_draw_tile  ;
  LD DE,$0020                ; See similar code at AC5F onwards
  LD A,L                     ;
  CP $E0                     ;
  JR C,zoombox_draw_border_2 ;
  LD D,$07                   ;
zoombox_draw_border_2:
  ADD HL,DE                  ;
; Right hand vertical run, moving down.
  LD A,(zoombox_height)   ; Fetch zoombox_height
  LD B,A                  ; Set iterations
; Start loop
zoombox_draw_border_3:
  LD A,$03                ; Draw a vertical zoombox border tile
  CALL zoombox_draw_tile  ;
  LD DE,$0020                ; See similar code at AC5F onwards
  LD A,L                     ;
  CP $E0                     ;
  JR C,zoombox_draw_border_4 ;
  LD D,$07                   ;
zoombox_draw_border_4:
  ADD HL,DE                  ;
  DJNZ zoombox_draw_border_3 ; ...loop
; Bottom right corner tile.
  LD A,$04                ; Draw a bottom-right zoombox border tile
  CALL zoombox_draw_tile  ;
  DEC L                   ; Move the destination pointer backwards
; Bottom horizontal run, moving left.
  LD A,(zoombox_width)    ; Fetch zoombox_width
  LD B,A                  ; Set iterations
; Start loop
zoombox_draw_border_5:
  LD A,$01                ; Draw a horizontal zoombox border tile
  CALL zoombox_draw_tile  ;
  DEC L                   ; Move the destination pointer backwards
  DJNZ zoombox_draw_border_5 ; ...loop
; Bottom left corner tile.
  LD A,$05                ; Draw a bottom-left zoombox border tile
  CALL zoombox_draw_tile  ;
  LD DE,$FFE0                 ; Inversion of similar code at AC5F onwards
  LD A,L                      ;
  CP $20                      ;
  JR NC,zoombox_draw_border_6 ;
  LD DE,$F8E0                 ;
zoombox_draw_border_6:
  ADD HL,DE                   ;
; Left hand vertical run, moving up.
  LD A,(zoombox_height)   ; Fetch zoombox_height
  LD B,A                  ; Set iterations
; Start loop
zoombox_draw_border_7:
  LD A,$03                ; Draw a vertical zoombox border tile
  CALL zoombox_draw_tile  ;
  LD DE,$FFE0                 ; Inversion of similar code at AC5F onwards
  LD A,L                      ;
  CP $20                      ;
  JR NC,zoombox_draw_border_8 ;
  LD DE,$F8E0                 ;
zoombox_draw_border_8:
  ADD HL,DE                   ;
  DJNZ zoombox_draw_border_7 ; ...loop
  RET                     ; Return

; Draw a single zoombox border tile.
;
; Used by the routine at zoombox_draw_border.
;
; I:A Index of tile to draw.
; I:BC (preserved)
; I:HL Destination address.
zoombox_draw_tile:
  PUSH BC                 ; Preserve
  PUSH AF                 ; Preserve
  PUSH HL                 ; Preserve
  EX DE,HL                ; Move destination address into DE
  LD L,A                  ; Widen the tile index from A into HL
  LD H,$00                ;
  ADD HL,HL               ; Then multiply the tile index by eight
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,zoombox_tiles     ; Point BC at zoombox_tiles
  ADD HL,BC               ; Combine to form a pointer to the required tile in HL
  LD B,$08                ; 8 iterations / 8 rows
; Start loop
zoombox_draw_tile_0:
  LD A,(HL)               ; Copy a byte
  LD (DE),A               ;
  INC D                   ; Next destination byte is 8 * 32 (=256) bytes ahead
  INC HL                  ; Next source byte is adjacent
  DJNZ zoombox_draw_tile_0 ; ...loop
  LD A,D                  ; Shunt D into A and undo the earlier INC D
  DEC A                   ;
  LD H,$58                ; Point HL at the attributes bank
  LD L,E                  ;
  CP $48                  ; Was the tile on the middle or later third of the screen?
  JR C,zoombox_draw_tile_1 ; If not, jump to writing the attribute
  INC H                   ; If so, increment the attribute bank pointer
  CP $50                  ; Was the tile on to the final third of the screen?
  JR C,zoombox_draw_tile_1 ; If not, jump to writing the attribute
  INC H                   ; If so, increment the attribute bank pointer
zoombox_draw_tile_1:
  LD A,(game_window_attribute) ; Read our current game_window_attribute
  LD (HL),A               ; Write it to the attribute byte
  POP HL                  ; Restore
  POP AF                  ; Restore
  POP BC                  ; Restore
  RET                     ; Return

; Searchlight movement data.
searchlight_movements:
  DEFB $24,$52,$2C,$02,$00 ; x, y, counter, direction, index
  DEFW searchlight_path_2 ; pointer to movement data
  DEFB $78,$52,$18,$01,$00 ; x, y, counter, direction, index
  DEFW searchlight_path_1 ; pointer to movement data
  DEFB $3C,$4C,$20,$02,$00 ; x, y, counter, direction, index
  DEFW searchlight_path_0 ; pointer to movement data
; Searchlight movement pattern for ?
searchlight_path_0:
  DEFB $20,$02            ; (32, bottom right)
  DEFB $20,$01            ; (32, top right)
  DEFB $FF                ; terminator
; Searchlight movement pattern for main compound.
searchlight_path_1:
  DEFB $18,$01            ; (24, top right)
  DEFB $0C,$00            ; (12, top left)
  DEFB $18,$03            ; (24, bottom left)
  DEFB $0C,$00            ; (12, top left)
  DEFB $20,$01            ; (32, top right)
  DEFB $14,$00            ; (20, top left)
  DEFB $20,$03            ; (32, bottom left)
  DEFB $2C,$02            ; (44, bottom right)
  DEFB $FF                ; terminator
; Searchlight movement pattern for ?
searchlight_path_2:
  DEFB $2C,$02            ; (44, bottom right)
  DEFB $2A,$01            ; (42, top right)
  DEFB $FF                ; terminator

; Decides searchlight movement.
;
; Used by the routine at nighttime.
;
; I:HL Pointer to a searchlight movement data.
searchlight_movement:
  LD E,(HL)               ; Fetch movement.x
  INC HL                  ; Step over
  LD D,(HL)               ; Fetch movement.y
  INC HL                  ; Step over
  DEC (HL)                ; Decrement movement.counter
  JP NZ,searchlight_movement_6 ; Jump if it's non-zero
; End of previous sweep: work out the next.
  INC HL                  ; Advance to movement.index
  INC HL                  ;
  LD A,(HL)               ; Fetch movement.index
  BIT 7,A                 ; Is the reverse direction flag set?
  JP Z,searchlight_movement_2 ; Jump if not
  AND $7F                 ; Clear the reverse direction flag
  JP NZ,searchlight_movement_0 ; Jump if non-zero index
; Index is zero.
  RES 7,(HL)              ; Clear direction bit when index hits zero
  JR searchlight_movement_1 ; (else)
; Index is non-zero.
searchlight_movement_0:
  DEC (HL)                ; Decrement movement.index
  DEC A                   ; Decrement local copy too (sans direction bit)
searchlight_movement_1:
  JR searchlight_movement_3 ; (else)
; Not reverse direction.
searchlight_movement_2:
  INC A                   ; Count up
  LD (HL),A               ; Assign to movement.index
searchlight_movement_3:
  INC HL                  ; Advance to movement.pointer
  LD C,(HL)               ; Load pointer
  INC HL                  ;
  LD B,(HL)               ;
  DEC HL                  ; Backtrack to movement.index
  DEC HL                  ;
  ADD A,A                      ; Index in A doubled and added to pointer
  ADD A,C                      ;
  LD C,A                       ;
  JR NC,searchlight_movement_4 ;
  INC B                        ;
searchlight_movement_4:
  LD A,(BC)               ; Fetch movement byte
  CP $FF                       ; End of list?
  JP NZ,searchlight_movement_5 ;
  DEC (HL)                ; !overshot? count down counter byte
  SET 7,(HL)              ; !go negative
  DEC BC                  ; Pointer -= 2
  DEC BC                  ;
  LD A,(BC)               ; Bug: A is loaded but never used again
searchlight_movement_5:
  DEC HL                  ; HL -= 2;
  DEC HL                  ;
; Copy counter + direction_t.
  LD A,(BC)               ; Copy counter
  LD (HL),A               ;
  INC HL                  ;
  INC BC                  ;
  LD A,(BC)               ; Copy direction
  LD (HL),A               ;
  RET                     ; Return
searchlight_movement_6:
  INC HL                  ; Advance to direction
  LD A,(HL)               ; Fetch direction
  INC HL                  ;
  BIT 7,(HL)              ; !Test sign
  JR Z,searchlight_movement_7 ; Jump if clear
  XOR $02                 ; Toggle direction
searchlight_movement_7:
  CP $02                       ; If direction <= direction_TOP_RIGHT, y-- else y++
  JR NC,searchlight_movement_8 ;
  DEC D                        ;
  DEC D                        ;
searchlight_movement_8:
  INC D                        ;
  AND A                       ; If direction is RIGHT, x+=2 else x-=2
  JR Z,searchlight_movement_9 ;
  CP $03                      ;
  JR Z,searchlight_movement_9 ;
  INC E                       ;
  INC E                       ;
  JR searchlight_movement_10  ;
searchlight_movement_9:
  DEC E                       ;
  DEC E                       ;
searchlight_movement_10:
  DEC HL                  ; Backtrack to (x,y)
  DEC HL                  ;
  DEC HL                  ;
  LD (HL),D               ; Store y
  DEC HL                  ;
  LD (HL),E               ; Store x
  RET                     ; Return

; Turns white screen elements light blue and tracks the hero with a searchlight.
;
; Used by the routine at main_loop.
nighttime:
  LD HL,searchlight_state ; Point HL at searchlight_state
  LD A,(HL)               ; Fetch the state
  CP $FF                  ; Is it in searchlight_STATE_SEARCHING state? ($FF)
  JP Z,searching          ; If so, jump to searching
  LD A,(room_index)       ; Fetch the global current room index
  AND A                   ; Are we outdoors?
  JR Z,nighttime_0        ; If so, jump to searchlight movement code
; If the hero goes indoors then the searchlight loses track.
  LD (HL),$FF             ; Set the searchlight state to searchlight_STATE_SEARCHING
  RET                     ; Return
; The hero is outdoors.
;
; If the searchlight previously caught the hero, then track him.
nighttime_0:
  LD A,(HL)               ; Fetch the searchlight state again - it's a counter
  CP $1F                  ; Does it equal searchlight_STATE_CAUGHT? ($1F)
  JP NZ,nighttime_8       ; If not, jump to single searchlight code. This will draw the searchlight in the place where the hero was last seen
; Caught in searchlight.
  LD HL,(map_position)    ; Fetch map_position into HL
  LD A,L                  ; Compute map_x as map_position.x + 4
  ADD A,$04               ;
  LD E,A                  ;
  LD D,H                  ; map_y is just map_position.y
  LD HL,(searchlight_caught_coord) ; Fetch the searchlight_caught_coord x/y into HL
  LD A,L                  ; Does caught_x equal map_x?
  CP E                    ;
  JR NZ,nighttime_1       ; Jump if not
  LD A,H                  ; Does caught_y equal map_y?
  CP D                    ;
  RET Z                   ; If both are equal the highlight doesn't need to move so return
  JR nighttime_4          ; (else)
; Move searchlight left/right to focus on the hero.
nighttime_1:
  JP NC,nighttime_2       ; Jump to decrement case if caught_x exceeds map_x
  INC A                   ; Increment caught_x
  JR nighttime_3          ; (else)
nighttime_2:
  DEC A                   ; Decrement caught_x
nighttime_3:
  LD L,A                  ; Save to HL
; Move searchlight up/down to focus on the hero.
nighttime_4:
  LD A,H                  ; Does caught_y equal map_y? (Note: This looks like a duplicated check but isn't - the equivalent above doesn't always execute)
  CP D                    ;
  JR Z,nighttime_7        ; Skip movement code if so
  JP NC,nighttime_5       ; Jump to decrement case if caught_y exceeds map_y
  INC A                   ; Increment caught_y
  JR nighttime_6          ; (else)
nighttime_5:
  DEC A                   ; Decrement caught_y
nighttime_6:
  LD H,A                  ; Save to HL
nighttime_7:
  LD (searchlight_caught_coord),HL ; Save HL back to searchlight_caught_coord
; When tracking the hero a single searchlight is used.
nighttime_8:
  LD DE,(map_position)    ; Fetch map_position into HL
  LD HL,$AE77             ; Point HL at searchlight_caught_coord plus a byte to compensate for the 'DEC HL' at the jump target
  LD B,$01                ; 1 iteration / 1 searchlight
  PUSH BC                 ; Preserve loop counter
  PUSH HL                 ; Preserve searchlight movement pointer
  JR nighttime_10         ; Jump
; When not tracking the hero all three searchlights are cycled through.
searching:
  LD HL,searchlight_movements ; Point HL at searchlight_movements[0]
  LD B,$03                ; 3 iterations / 3 searchlights
; Start loop
nighttime_9:
  PUSH BC                 ; Preserve loop counter
  PUSH HL                 ; Preserve searchlight movement pointer
  CALL searchlight_movement ; Decide searchlight movement
  POP HL                  ; Restore searchlight movement pointer
  PUSH HL                 ;
  CALL searchlight_caught ; Is the hero caught in the searchlight?
  POP HL                  ; Restore searchlight movement pointer
  PUSH HL                 ;
  LD DE,(map_position)    ; Point DE at map_position
  LD A,E                  ; If map_x + 23 < searchlight.x (off right hand side) goto next
  ADD A,$17               ;
  CP (HL)                 ;
  JP C,next_searchlight   ;
  LD A,(HL)               ; If searchlight.x + 16 < map_x (off left hand side) goto next
  ADD A,$10               ;
  CP E                    ;
  JP C,next_searchlight   ;
  INC HL                  ; Point HL at searchlight.y
  LD A,D                  ; If map_y + 16 < searchlight.y (off top side) goto next
  ADD A,$10               ;
  CP (HL)                 ;
  JP C,next_searchlight   ;
  LD A,(HL)               ; If searchlight.y + 16 < map_y (off bottom side) goto next
  ADD A,$10               ;
  CP D                    ;
  JP C,next_searchlight   ;
nighttime_10:
  XOR A                   ; Set the clip flag to zero
  EX AF,AF'               ; Bank the clip flag
  DEC HL                  ; Point HL at searchlight.x (or caught_coord.x depending on how it was entered)
; Calculate the column
  LD B,$00                ; Clear top part of 'column' skip
  LD A,(HL)               ; Calculate the left side skip = searchlight.x - map_x
  SUB E                   ;
  JP NC,nighttime_11      ; Jump if left hand skip is +ve
  LD B,$FF                ; Invert the top part of 'column'
  EX AF,AF'               ; Bitwise complement the banked clip flag
  CPL                     ;
  EX AF,AF'               ;
nighttime_11:
  LD C,A                  ; Finalise BC as column
; Calculate the row
  INC HL                  ; Point HL at searchlight.y
  LD A,(HL)               ; Fetch searchlight.y
  LD H,$00                ; Clear top part of 'row' skip
  SUB D                   ; Calculate the top side skip = searchlight.y - map_y
  JP NC,nighttime_12      ; Jump if top side skip is +ve
  LD H,$FF                ; Invert the top part of 'row'
nighttime_12:
  LD L,A                  ; Finalise HL as row
; HL is row, BC is column
  ADD HL,HL               ; Multiply row by 32
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,BC               ; Add column to it
  LD BC,$5846             ; Point HL at the address of the top-left game window attribute
  ADD HL,BC               ; Add row+column to base, producing our plot pointer
  EX DE,HL                ; Move it to DE
  EX AF,AF'               ; Unbank the clip flag
  LD (searchlight_clip_left),A ; Assign it to searchlight_clip_left
  CALL searchlight_plot   ; Plot the searchlight
next_searchlight:
  POP HL                  ; Restore searchlight_movement pointer
  POP BC                  ; Restore loop counter
  LD DE,$0007             ; Step to the next searchlight_movement
  ADD HL,DE               ;
  DJNZ nighttime_9        ; ...loop
  RET                     ; Return

; Searchlight state variables
;
; (Assigned by nighttime. Read by searchlight_plot.)
searchlight_clip_left:
  DEFB $00
; Coordinates of searchlight when hero is caught.
searchlight_caught_coord:
  DEFW $0000

; Is the hero is caught in the searchlight?
;
; Used by the routine at nighttime.
;
; I:HL Pointer to searchlight movement data.
searchlight_caught:
  LD DE,(map_position)    ; Fetch map_position into DE. E is x, D is y
; Detect when the searchlight overlaps the hero.
  LD A,E                  ; Compute map_position.x + 12
  ADD A,$0C               ;
  LD B,A                  ; Save it in B
  LD A,(HL)               ; Fetch searchlight.x
  ADD A,$05               ; Compute searchlight.x + 5
  CP B                    ; Is (searchlight.x + 5) >= (map_position.x + 12)?
; Is the searchlight hotspot left edge beyond the hero's right edge?
  RET NC                  ; Return if so - the hero isn't in the hotspot
  ADD A,$05               ; Compute (searchlight.x + 5) + 5
  DEC B                   ; Compute (map_position.x + 12) - 2
  DEC B                   ;
  CP B                    ; Is (searchlight.x + 10) < (map_position.x + 10)?
; Is the searchlight hotspot right edge beyond the hero's left edge?
  RET C                   ; Return if so - the hero isn't in the hotspot
  INC HL                  ; Advance HL to searchlight.y
  LD A,D                  ; Compute map_position.y + 10
  ADD A,$0A               ;
  LD B,A                  ; Save it in B
  LD A,(HL)               ; Fetch searchlight.y
  ADD A,$05               ; Compute searchlight.y + 5
  CP B                    ; Is (searchlight.y + 5) >= (map_position.y + 10)?
; Is the searchlight hotspot top edge beyond the hero's bottom edge?
  RET NC                  ; Return if so - the hero isn't in the hotspot
  ADD A,$07               ; Compute (searchlight.y + 5) + 7
  LD C,A                  ; Save it in C
  LD A,B                  ; Compute (map_position.y + 10) - 4
  SUB $04                 ;
  CP C                    ; Is (map_position.y + 6) >= (searchlight.y + 12)?
; Is the searchlight hotspot bottom edge beyond the hero's top edge?
  RET NC                  ; Return if so - the hero isn't in the hotspot
; The hero is in the hotspot.
;
; DPT: It seems odd to not do this next test first, since it's cheaper.
  LD A,(searchlight_state) ; Is searchlight_state set to searchlight_STATE_CAUGHT? ($1F)
  CP $1F                   ;
  RET Z                   ; Return if so
  LD A,$1F                 ; Set searchlight_state to searchlight_STATE_CAUGHT
  LD (searchlight_state),A ;
  LD D,(HL)                        ; Assign searchlight_caught_coord from searchlight.x and .y
  DEC HL                           ;
  LD E,(HL)                        ;
  LD (searchlight_caught_coord),DE ;
  XOR A                   ; Make the bell ring perpetually
  LD (bell),A             ;
  LD B,$0A                ; Decrease morale by 10
  JP decrease_morale      ; Exit via decrease_morale

; Plot the searchlight.
;
; Note: In terms of attributes the game window is at (7,2)-(29,17) inclusive.
;
; Used by the routine at nighttime.
;
; I:DE Pointer to screen attributes.
searchlight_plot:
  EXX                     ; Bank the screen attribute pointer supplied in DE
  LD DE,searchlight_shape ; Point DE at the spotlight bitmap searchlight_shape[0]
  LD C,$10                ; 16 iterations - one per row of searchlight bitmap
; Start loop (outer)
searchlight_plot_0:
  EXX                     ; Switch register banks for this iteration
; Note: I'm presently unable to discern the intent of the 'clip' flag.
  LD A,(searchlight_clip_left) ; Fetch the clip flag
; Stop if we're beyond the maximum Y
  LD HL,$5A40             ; Point HL at the screen attribute (0,18). This is max_y_attrs: the bottom of the game window
  AND A                   ; Is the clip flag zero?
  JP Z,searchlight_plot_1 ; Jump forward if so
  LD A,E                  ; Extract the X position from the screen attribute pointer
  AND $1F                 ;
  CP $16                  ; Is it < 22?
  JR C,searchlight_plot_1 ; Jump forward if so
  LD L,$20                ; Otherwise point HL at screen attribute (0,17)
searchlight_plot_1:
  SBC HL,DE               ; Is the screen attribute pointer >= max_y_attrs?
  RET C                   ; Return if so
  PUSH DE                 ; Preserve the screen attribute pointer
; Skip rows until we're in bounds
  LD HL,$5840             ; Point HL at screen attribute (0,2). This is min_y_attrs: the first row that has the game window on it
  AND A                   ; Is the clip flag zero?
  JP Z,searchlight_plot_2 ; Jump forward if so
  LD A,E                  ; Extract the X position from the screen attribute pointer
  AND $1F                 ;
  CP $07                  ; Is it < 7?
  JR C,searchlight_plot_2 ; Jump forward if so
  LD L,$20                ; Otherwise point HL at screen attribute (0,1)
searchlight_plot_2:
  SBC HL,DE               ; Is the screen attribute pointer >= min_y_attrs?
  JR C,searchlight_plot_3 ; Jump forward if so
  EXX                     ; Otherwise we need to skip this row. Increment the (banked) shape pointer by a row
  INC DE                  ;
  INC DE                  ;
  EXX                     ;
  JR next_row             ; Then jump to the next row, skipping all of the plotting
searchlight_plot_3:
  EX DE,HL                ; Move shape pointer into DE
  EXX
  LD B,$02                ; Two iterations (two bytes per row)
; Start loop (inner)
searchlight_plot_4:
  LD A,(DE)               ; Fetch eight pixels from the shape data
  EXX
  LD DE,$071E             ; Preload D with 7 (left hand clip) and E with 30 (right hand clip)
  LD C,A                  ; Save the shape pixels to C
  LD B,$08                ; Eight iterations (bits per byte)
; Start loop (inner inner)
;
; Clip right hand edge
searchlight_plot_5:
  LD A,(searchlight_clip_left) ; Fetch the clip flag
  AND A                   ; Is the clip flag zero?
  LD A,L                  ; Fetch the screen attribute pointer low byte (interleaved)
  JP Z,searchlight_plot_6 ; Jump forward if so
  AND $1F                 ; Get X
  CP $16                  ; Is it >= 22?
  JR NC,dont_plot         ; Jump to don't plot if so
  JR searchlight_plot_8   ; Otherwise jump to plot test
searchlight_plot_6:
  AND $1F                 ; Get X
  CP E                    ; Is it < 30? (E is 30 here, as set by AEF6)
  JR C,searchlight_plot_8 ; Jump to plot test if so
  EXX
; Tight loop to increment DE by B
searchlight_plot_7:
  INC DE                  ; Skip the remainder of the shape's row
  DJNZ searchlight_plot_7 ;
  EXX
  JR next_row             ; Jump to next_row
; Clip left hand edge
searchlight_plot_8:
  CP D                    ; Is A >= 8? (AEF6 previously stored 7 in D)
  JR NC,do_plot           ; Jump to plot if so
dont_plot:
  RL C                    ; Extract the next bit from shape's pixels
  JR searchlight_plot_10  ; Jump to the next pixel
do_plot:
  RL C                    ; Extract the next bit from shape's pixels
  JP NC,searchlight_plot_9 ; Jump if the pixel is not set
  LD (HL),$06             ; Set screen attribute to attribute_YELLOW_OVER_BLACK
  JR searchlight_plot_10  ; (else)
searchlight_plot_9:
  LD (HL),$41             ; Set screen attribute to attribute_BRIGHT_BLUE_OVER_BLACK
searchlight_plot_10:
  INC HL                  ; Advance to the next pixel and attribute
  DJNZ searchlight_plot_5 ; ...loop (inner inner)
  EXX
  INC DE                  ; Advance shape pointer
  DJNZ searchlight_plot_4 ; ...loop (inner)
  EXX
next_row:
  POP HL
  LD DE,$0020             ; Move the attribute pointer to the next scanline
  ADD HL,DE               ;
  EX DE,HL
  EXX
  DEC C                   ; Decrement row counter
  JP NZ,searchlight_plot_0 ; ...loop while row > 0 (outer)
  RET                     ; Return
; Searchlight circle shape.
searchlight_shape:
  DEFB $00,$00
  DEFB $00,$00
  DEFB $00,$00
  DEFB $01,$80
  DEFB $07,$E0
  DEFB $0F,$F0
  DEFB $0F,$F0
  DEFB $1F,$F8
  DEFB $1F,$F8
  DEFB $0F,$F0
  DEFB $0F,$F0
  DEFB $07,$E0
  DEFB $01,$80
  DEFB $00,$00
  DEFB $00,$00
  DEFB $00,$00

; Barbed wire tiles used by the zoombox effect.
zoombox_tiles:
  DEFB $00,$00,$00,$03,$04,$08,$08,$08 ; top left tile, zoombox_tile_wire_tl
  DEFB $00,$20,$18,$F4,$2F,$18,$04,$00 ; horizontal tile, zoombox_tile_wire_hz
  DEFB $00,$00,$00,$00,$E0,$10,$08,$08 ; top right tile, zoombox_tile_wire_tr
  DEFB $08,$08,$1A,$2C,$34,$58,$10,$10 ; vertical tile, zoombox_tile_wire_vt
  DEFB $10,$10,$10,$20,$C0,$00,$00,$00 ; bottom right tile, zoombox_tile_wire_br
  DEFB $10,$10,$08,$07,$00,$00,$00,$00 ; bottom left tile, zoombox_tile_wire_bl

; Bribed character.
bribed_character:
  DEFB $FF

; Test for characters meeting obstacles like doors and map bounds.
;
; Also assigns saved_pos to specified vischar's pos and sets the sprite_index.
;
; Used by the routine at animate.
;
; I:A' Flip flag and sprite offset.
; I:IY Pointer to visible character block.
; O:F Z/NZ => inside/outside bounds.
touch:
  EX AF,AF'               ; Exchange A registers
  LD (touch_stashed_A),A  ; Stash the flip flag and sprite offset
  SET 6,(IY+$07)          ; Set the vischar's vischar_BYTE7_DONT_MOVE_MAP flag
  SET 7,(IY+$07)          ; Set the vischar's vischar_TOUCH_ENTERED flag
  PUSH IY                 ; HL = IY
  POP HL                  ;
; If the hero is player controlled then check for door transitions.
  LD A,L                  ; Which vischar are we processing?
  AND A                   ;
  PUSH AF                 ; Preserve the vischar low byte
  JR NZ,touch_0           ; Jump forward if not the hero's vischar
  LD A,(automatic_player_counter) ; If the automatic player counter is positive (under player control)... call door_handling
  AND A                           ;
  CALL NZ,door_handling           ;
touch_0:
  POP AF                  ; Restore vischar low byte
; Check bounds if this is a non-player character or the hero is not cutting the fence.
  AND A                   ; If it's a non-player vischar... jump foward to bounds check
  JR NZ,touch_1           ;
  LD A,($8001)            ; OR if it's the hero's vischar and its flags (vischar_FLAGS_PICKING_LOCK | vischar_FLAGS_CUTTING_WIRE) don't equal vischar_FLAGS_CUTTING_WIRE call bounds_check
  AND $03                 ;
  CP $02                  ;
touch_1:
  CALL NZ,bounds_check    ;
  RET NZ                  ; Return if a wall was hit
; Check "real" characters for collisions.
  LD A,(IY+$00)           ; Get this vischar's character index
  CP $1A                  ; Is it >= character_26_STOVE_1?
  JR NC,touch_2           ; Jump forward if so
  CALL collision          ; Call collision
  RET NZ                  ; Return if there was a collision
; At this point we handle non-colliding characters and items only.
touch_2:
  RES 6,(IY+$07)          ; Clear vischar_BYTE7_DONT_MOVE_MAP
  LD HL,saved_pos_x       ; Copy saved_pos to vischar's position
  PUSH IY                 ;
  POP DE                  ;
  LD A,$0F                ;
  ADD A,E                 ;
  LD E,A                  ;
  LD BC,$0006             ;
  LDIR                    ;
  LD A,(touch_stashed_A)  ; Unstash the flip flag and sprite offset
  LD (IY+$17),A           ; Set it in the vischar's sprite_index field
  XOR A                   ; Set flags to Z
  RET                     ; Return

; Handle collisions, including items being pushed around.
;
; Used by the routines at touch and spawn_character.
;
; O:F Z/NZ => no collision/collision.
;   Iterate over characters being collided with (e.g. stove).
collision:
  LD HL,$8001             ; Point HL at the first vischar's flags field
  LD B,$08                ; Set B for eight iterations
; Start loop
collision_0:
  BIT 7,(HL)              ; Is the vischar_FLAGS_NO_COLLIDE flag bit set?
  JP NZ,collision_19      ; Skip if so
  PUSH BC                 ; Preserve the loop counter
  PUSH HL                 ; Preserve the vischar pointer
; Check for contact between the current vischar and saved_pos.
  LD A,$0E                ; Point HL at vischar's X position
  ADD A,L                 ;
  LD L,A                  ;
; Check X
  LD C,(HL)               ; Fetch X position
  INC L                   ;
  LD B,(HL)               ;
  EX DE,HL                ; Save our vischar pointer while we compare bounds
  LD HL,(saved_pos_x)     ; Fetch saved_pos_x
  LD A,$04                ; Add 4 to the X position - our upper bound
  ADD A,C                 ;
  LD C,A                  ;
  JR NC,collision_1       ;
  INC B                   ;
  AND A                   ; Clear the carry flag
collision_1:
  SBC HL,BC               ; Compare saved_pos_x to (X position + 4)
  JR Z,collision_3        ; Equal - jump forward to comparing Y position
  JP NC,collision_pop_next ; If (saved_pos_x >= (X position + 4)) there was no collision, so jump to the next iteration
  SUB $08                 ; Reduce A by 8 giving (X position - 4) - our lower bound
  LD C,A                  ;
  JR NC,collision_2       ;
  DEC B                   ;
  AND A                   ;
collision_2:
  LD HL,(saved_pos_x)     ; Fetch saved_pos_x again
  SBC HL,BC               ; Compare saved_pos_x to (X position - 4)
  JP C,collision_pop_next ; If (saved_pos_x < (X position - 4)) there was no collision, so jump to the next iteration
collision_3:
  EX DE,HL                ; Restore our vischar pointer
  INC L                   ; Advance to Y position
; Check Y
  LD C,(HL)               ; Fetch Y position
  INC L                   ;
  LD B,(HL)               ;
  EX DE,HL                ; Save our vischar pointer while we compare bounds
  LD HL,(saved_pos_y)     ; Fetch saved_pos_y
  LD A,$04                ; Add 4 to the Y position - our upper bound
  ADD A,C                 ;
  LD C,A                  ;
  JR NC,collision_4       ;
  INC B                   ;
  AND A                   ; Clear the carry flag
collision_4:
  SBC HL,BC               ; Compare saved_pos_y to (Y position + 4)
  JR Z,collision_6        ; Equal - jump forward to comparing height
  JP NC,collision_pop_next ; If (saved_pos_y >= (Y position + 4)) there was no collision, so jump to the next iteration
  SUB $08                 ; Reduce A by 8 giving (Y position - 4) - our lower bound
  LD C,A                  ;
  JR NC,collision_5       ;
  DEC B                   ;
  AND A                   ;
collision_5:
  LD HL,(saved_pos_y)     ; Fetch saved_pos_y again
  SBC HL,BC               ; Compare saved_pos_y to (Y position - 4)
  JP C,collision_pop_next ; If (saved_pos_y < (Y position - 4)) there was no collision, so jump to the next iteration
collision_6:
  EX DE,HL                ; Restore our vischar pointer
  INC L                   ; Advance to height
; Check height
  LD C,(HL)               ; Fetch height
  LD A,(saved_height)     ; Fetch saved_height
  SUB C                   ; Subtract height from saved_height
  JR NC,collision_7       ; If negative flip the sign - get the absolute value
  NEG                     ;
collision_7:
  CP $18                   ; If the result is >= 24 then jump to the next iteration
  JP NC,collision_pop_next ;
  LD A,(IY+$01)           ; Read the vischar's flags
  AND $0F                 ; AND the flags with vischar_FLAGS_PURSUIT_MASK
  CP $01                  ; Is the result vischar_PURSUIT_PURSUE?
  JR NZ,collision_9       ; If not, jump forward to collision checking
  POP HL                  ; Restore vischar pointer
  PUSH HL                 ;
  DEC L                   ; Point at vischar base, not flags
  LD A,L                  ; Is the current vischar the hero's? $8000
  AND A                   ;
  JR NZ,collision_9       ;
  LD A,(bribed_character) ; Fetch global bribed character
  CP (IY+$00)             ; Does it match IY's vischar character?
  JR NZ,collision_8       ; No, jump forward to solitary check
; IY is a bribed character pursuing the hero. When the pursuer catches the hero the bribe will be accepted.
  CALL accept_bribe       ; Call accept_bribe
  JR collision_9          ; (else)
; IY is a hostile who's caught the hero!
collision_8:
  POP HL                  ; Restore vischar pointer
  POP BC                  ; Restore loop counter
  PUSH IY                 ; Unused sequence: HL = IY + 1
  POP HL                  ;
  INC L                   ;
  JP solitary             ; Exit via solitary
; Check for collisions with items.
collision_9:
  POP HL                  ; Restore vischar pointer
  DEC L                   ; Point at vischar base, not flags
  LD A,(HL)               ; Fetch the vischar's character
  CP $1A                  ; Is the character >= character_26_STOVE_1?
  JR C,collision_16       ; Jump if NOT
  PUSH HL                 ; Preserve the vischar pointer
  EX AF,AF'               ; Bank the character index
  LD A,$11                ; Point HL at vischar->mi.pos.y
  ADD A,L                 ;
  LD L,A                  ;
  EX AF,AF'               ; Retrieve the character index
  LD BC,$0723             ; Set B to 7 - the permitted range, in either direction, from the centre point and set C to 35 - the centre point
  CP $1C                  ; Compare character index with character_28_CRATE
  LD A,(IY+$0E)           ; (interleaved) Fetch IY's direction
  JR NZ,collision_10      ; If it's not the crate then jump to the stove handling
; Handle the crate. It moves on the X axis (top left to bottom right) only.
  DEC L                   ; Point HL at vischar->mi.pos.x
  DEC L                   ;
  LD C,$36                ; Centre point is 54 (crate will move 47..54..61)
  XOR $01                 ; Swap direction left<=>right
; Top left case.
collision_10:
  AND A                   ; Test the direction: Is it top left? (zero)
  JR NZ,collision_12      ; Jump forward to next check if not
; The player is pushing the movable item from the front, so centre it.
  LD A,(HL)               ; Load the coordinate
  CP C                    ; Is it at the centre point?
  JR Z,collision_15       ; Jump forward if so
  JR C,collision_11       ; If the coordinate is larger than the centre point then decrement, else increment its position
  DEC (HL)                ;
  DEC (HL)                ;
collision_11:
  INC (HL)                ;
  JR collision_15         ; (else)
; Top right case.
collision_12:
  CP $01                  ; Test the direction: Is it top right? (one)
  JR NZ,collision_13      ; Jump forward to next check if not
  LD A,C                  ; If the coordinate is not at its maximum (C+B) then increment its position
  ADD A,B                 ;
  CP (HL)                 ;
  JR Z,collision_15       ;
  INC (HL)                ;
  JR collision_15         ; (else)
; Bottom right case.
collision_13:
  CP $02                  ; Test the direction: Is it bottom right? (two)
  JR NZ,collision_14      ; Jump forward to next check if not
  LD A,C                  ; Set the position to minimum (C-B) irrespective Note that this never seems to happen in practice in the game
  SUB B                   ;
  LD (HL),A               ;
  JR collision_15         ; (else)
; Bottom left case.
collision_14:
  LD A,C                  ; If the coordinate is not at its minimum (C-B) then decrement its position
  SUB B                   ;
  CP (HL)                 ;
  JR Z,collision_15       ;
  DEC (HL)                ;
collision_15:
  POP HL                  ; Restore the vischar pointer
collision_16:
  POP BC                  ; Restore the loop counter
; Reorient the character? Not well understood. (?)
  LD A,L                  ; Point at vischar input field
  ADD A,$0D               ;
  LD L,A                  ;
  LD A,(HL)               ; Load the input field and mask off the input_KICK flag
  AND $7F                 ;
  JR Z,collision_17       ; Jump forward if the input field is zero
  INC L                   ; Point at the direction field
  LD A,(HL)               ; Swap direction top <=> bottom
  XOR $02                 ;
  CP (IY+$0E)             ; If direction != state->IY->direction
  JR Z,collision_17       ;
  LD (IY+$0D),$80         ; Set IY's input to input_KICK
; Delay calling character_behaviour for five turns. This delay controls how long it takes before a blocked character will try another direction.
collided:
  LD A,(IY+$07)           ; IY->counter_and_flags = (IY->counter_and_flags & ~vischar_BYTE7_COUNTER_MASK) | 5
  AND $F0                 ;
  OR $05                  ;
  LD (IY+$07),A           ;
  RET NZ                  ; Return  DPT: This return works but it's odd that it's conditional
; ... new input stuff Note: C direction field doesn't get masked, so will access out-of-bounds in new_inputs[] if we collide when crawling.
collision_17:
  LD C,(IY+$0E)           ; Fetch IY->direction, widening it to BC
  LD B,$00                ;
  LD HL,collision_new_inputs ; Point HL at collision_new_inputs
  ADD HL,BC               ; Index it by direction (in BC)
  LD A,(HL)               ; Fetch the direction
  LD (IY+$0D),A           ; IY->input = A
  BIT 0,C                 ; If the new direction is TR or BL
  JR NZ,collision_18      ; Jump if so
  RES 5,(IY+$07)          ; IY->counter_and_flags &= ~vischar_BYTE7_Y_DOMINANT
  JR collided             ; Jump to 'collided'
collision_18:
  SET 5,(IY+$07)          ; IY->counter_and_flags |= vischar_BYTE7_Y_DOMINAN
  JR collided             ; Jump to 'collided'
; New inputs.
collision_new_inputs:
  DEFB $85                ; = input_DOWN + input_LEFT  + input_KICK
  DEFB $84                ; = input_UP   + input_LEFT  + input_KICK
  DEFB $87                ; = input_UP   + input_RIGHT + input_KICK
  DEFB $88                ; = input_DOWN + input_RIGHT + input_KICK
collision_pop_next:
  POP HL                  ; Restore the vischar pointer
  POP BC                  ; Restore the loop counter
collision_19:
  LD A,L                  ; Step HL to the next vischar
  ADD A,$20               ;
  LD L,A                  ;
  DEC B                   ; ...loop for each vischar
  JP NZ,collision_0       ;
  RET                     ; Return with Z set

; Character accepts the bribe.
;
; Used by the routines at collision and target_reached.
;
; I:IY Pointer to visible character.
accept_bribe:
  CALL increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50
  LD (IY+$01),$00         ; Clear the vischar_PURSUIT_PURSUE flag
  PUSH IY                 ; Point HL at IY->route
  POP HL                  ;
  INC L                   ;
  INC L                   ;
  CALL get_target_assign_pos ; Call get_target_assign_pos
; Return early if we have no bribes.
  LD DE,items_held        ; Point DE at items_held
  LD A,(DE)               ; Fetch the first item
  CP $05                  ; Does it hold item_BRIBE?
  JR Z,accept_bribe_0     ; Jump forward if it does
  INC DE                  ; Advance to the second item
  LD A,(DE)               ; Fetch the second item
  CP $05                  ; Does it hold item_BRIBE?
  RET NZ                  ; Return if not
; Remove the bribe item.
accept_bribe_0:
  LD A,$FF                ; Assign item_NONE to the item slot, removing the bribe item
  LD (DE),A               ;
  AND $3F                 ; Set the bribe item's item_struct room to itemstruct_ROOM_NONE
  LD ($76EC),A            ;
  CALL draw_all_items     ; Draw both held items
; Set the vischar_PURSUIT_SAW_BRIBE flag on all visible hostiles. Iterate over hostile and visible non-player characters.
  LD B,$07                ; 7 iterations
  LD HL,$8020             ; Start at the second visible character
; Start loop
accept_bribe_1:
  LD A,(HL)               ; Fetch the character index
  CP $14                  ; Is it > character_20_PRISONER_1?
  JR NC,accept_bribe_2    ; Jump forward if so
  INC L                   ; Set flags to vischar_PURSUIT_SAW_BRIBE if hostile
  LD (HL),$04             ;
  DEC L                   ;
accept_bribe_2:
  LD A,L                  ; Advance to the next vischar
  ADD A,$20               ;
  LD L,A                  ;
  DJNZ accept_bribe_1     ; ...loop
  LD B,$11                ; Queue the message "HE TAKES THE BRIBE"
  CALL queue_message      ;
  LD B,$12                ; Then queue the messsage "AND ACTS AS DECOY"
  JP queue_message        ; Return

; Tests whether the position in saved_pos touches any wall or fence boundary.
;
; A position (x,y,h) touches a wall if the following returns true: (minx + 2 >= x <= maxx + 3) and (miny     >= y <= maxy + 3) and (minh     >= h <= maxh + 1)
;
; Used by the routines at touch and spawn_character.
;
; I:IY Pointer to visible character.
; O:F Z set if no bounds hit, Z clear otherwise
bounds_check:
  LD A,(room_index)       ; Get the global current room index
; Interior boundaries are handled by another routine.
  AND A                   ; Is it indoors?
  JP NZ,interior_bounds_check ; Use the interior bounds check routine instead, if so (exit via)
  LD B,$18                ; 24 iterations / 24 wall definitions
  LD DE,walls             ; Point DE at the first wall definition
; Start loop
bounds_loop:
  PUSH BC                 ; Preserve the loop counter
  PUSH DE                 ; Preserve the wall definition pointer
; Check against minimum X
  LD A,(DE)               ; Read minimum x
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  INC BC                  ; And add two
  INC BC                  ;
  LD HL,(saved_pos_x)     ; Read saved_pos_x
  SBC HL,BC               ; Compute saved_pos_x - ((wall minimum x) * 8 + 2)
  JR C,bounds_next        ; Jump to the next iteration if saved_pos_x is left of minimum x
; Check against maximum X
  INC DE                  ; Move to maximum x field
  LD A,(DE)               ; Read maximum x
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  INC BC                  ; And add four
  INC BC                  ;
  INC BC                  ;
  INC BC                  ;
  LD HL,(saved_pos_x)     ; Re-read saved_pos_x
  SBC HL,BC               ; Compute saved_pos_x - ((wall maximum x) * 8 + 4)
  JR NC,bounds_next       ; Jump to next iteration if saved_pos_x is right of maximum x
; Check against minimum Y
  INC DE                  ; Move to minimum y field
  LD A,(DE)               ; Read minimum y
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  LD HL,(saved_pos_y)     ; Read saved_pos_y
  SBC HL,BC               ; Compute saved_pos_y - ((wall minimum y) * 8)
  JR C,bounds_next        ; Jump to the next iteration if saved_pos_y is below minimum y
; Check against maximum Y
  INC DE                  ; Move to maximum y field
  LD A,(DE)               ; Read maximum y
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  INC BC                  ; And add four
  INC BC                  ;
  INC BC                  ;
  INC BC                  ;
  LD HL,(saved_pos_y)     ; Re-read saved_pos_y
  SBC HL,BC               ; Compute saved_pos_y - ((wall maximum y) * 8 + 4)
  JR NC,bounds_next       ; Jump to next iteration if saved_pos_y is above maximum y
; Check minimum height
  INC DE                  ; Move to minimum height field
  LD A,(DE)               ; Read minimum height
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  LD HL,(saved_height)    ; Read saved_height
  SBC HL,BC               ; Compute saved_height - ((wall minimum height) * 8)
  JR C,bounds_next        ; Jump to the next iteration if saved_height is below minimum height
; Check maximum height
  INC DE                  ; Move to maximum height field
  LD A,(DE)               ; Read maximum height
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  INC BC                  ; And add two
  INC BC                  ;
  LD HL,(saved_height)    ; Re-read saved_height
  SBC HL,BC               ; Compute saved_height - ((wall maximum height) * 8)
  JR NC,bounds_next       ; Jump to the next iteration if saved_height is above maximum height
; Passed all checks - in contact with wall
  POP DE                  ; Restore the wall definition pointer
  POP BC                  ; Restore the loop counter
  LD A,(IY+$07)           ; Toggle counter_and_flags vischar_BYTE7_Y_DOMINANT flag
  XOR $20                 ;
  LD (IY+$07),A           ;
  OR $01                  ; Clear Z flag
  RET                     ; Return with Z clear
bounds_next:
  POP DE                  ; Restore the wall definition pointer
  POP BC                  ; Restore the loop counter
  LD HL,$0006             ; Set the wall definition stride
  ADD HL,DE               ; Point to next wall definition
  EX DE,HL                ; Move the wall definition pointer into DE
  DEC B                   ; ...loop
  JP NZ,bounds_loop       ;
  AND B                   ; B is zero, AND it with itself to set Z flag
  RET                     ; Return with Z set

; Multiplies A by 8, returning the result in BC.
;
; Used by the routines at bounds_check, spawn_character, vischar_move_x, vischar_move_y and get_greatest_itemstruct.
;
; I:A Argument.
; O:BC Result of (A << 3).
multiply_by_8:
  LD B,$00                ; Set B to zero
  ADD A,A                 ; Double the input argument
  RL B                    ; Merge the carry out from the doubling into B
  ADD A,A                 ; Double it again
  RL B                    ;
  ADD A,A                 ; And double it again
  RL B                    ;
  LD C,A                  ; Move low part of result into C
  RET                     ; Return

; Locate current door, queuing a message if it's locked.
;
; Used by the routines at door_handling and door_handling_interior.
;
; O:F Z set if door open.
is_door_locked:
  LD E,$7F                ; Set E to the complement of door_REVERSE ($7F)
  LD A,(current_door)     ; Fetch the current door [index]
  AND E                   ; Mask it off
  LD C,A                  ; Move it to C
; Check all locked doors
  LD HL,locked_doors      ; Point HL at first locked doors
  LD B,$09                ; 9 iterations / 9 locked doors
; Start loop
is_door_locked_0:
  LD A,(HL)               ; Fetch a door index
  AND E                   ; Mask off the locked flag
  CP C                    ; Does it match the current door?
  JR NZ,is_door_locked_1  ; Jump forward if not
  BIT 7,(HL)              ; Test the door_LOCKED flag
  RET Z                   ; Return if the flag was zero: the door is open
; Otherwise the door is locked
  LD B,$05                ; Queue the message "THE DOOR IS LOCKED"
  CALL queue_message      ;
  OR $01                  ; Set flags to NZ - the door is locked
  RET                     ; Return
is_door_locked_1:
  INC HL                  ; Advance to the next locked door
  DJNZ is_door_locked_0   ; ...loop
  AND B                   ; Set flags to Z - the door is open
  RET                     ; Return

; Door handling.
;
; Used by the routine at touch.
;
; I:IY Pointer to visible character.
door_handling:
  LD A,(room_index)       ; Get the global current room index
; Interior doors are handled by another routine.
  AND A                   ; Is it indoors?
  JP NZ,door_handling_interior ; Exit via the interior door handling routine if so
; Select a start position in doors[] based on the direction the hero is facing.
  LD HL,doors             ; Point HL at the first entry in doors[]
  LD E,(IY+$0E)           ; Fetch current vischar's direction field
  LD A,E                  ; Is it direction_BOTTOM_RIGHT or direction_BOTTOM_LEFT?
  CP $02                  ;
  JR C,door_handling_0    ; Jump if not
  LD HL,$78DA             ; Point HL at the second entry in doors[]
door_handling_0:
  LD D,$03                ; Preload door_FLAGS_MASK_DIRECTION mask ($03) into D
; The first 16 (pairs of) entries in doors[] are the only ones with outdoors as a destination, so only consider those.
  LD B,$10                ; 16 iterations / 16 pairs of entries
; Start loop
door_handling_1:
  LD A,(HL)               ; Load the door entry's room_and_direction field
  AND D                   ; Extract the direction field
  CP E                    ; Does it match the vischar's direction?
  JR NZ,door_handling_next ; Jump forward if not
; A match
  PUSH BC                 ; Preserve loop counter
  PUSH HL                 ; Preserve door entry pointer
  PUSH DE                 ; Preserve direction mask
  CALL door_in_range      ; Call door_in_range -- returns C clear if in range
  POP DE                  ; Restore the registers stored prior to call
  POP HL                  ;
  POP BC                  ;
  JR NC,door_handling_found ; If not in range, jump to door_handling_found
door_handling_next:
  LD A,$08                ; Step forward two entries
  ADD A,L                 ;
  LD L,A                  ;
  JR NC,door_handling_2   ;
  INC H                   ;
door_handling_2:
  DJNZ door_handling_1    ; ...loop
; DPT: This seems to exist to set Z, but this routine doesn't return anything!
  AND B                   ; Set Z (B is zero here)
  RET                     ; Return
door_handling_found:
  LD A,$10                ; current door = 16 - iterations
  SUB B                   ;
  LD (current_door),A     ;
  EXX                     ; Switch register banks over the call
  CALL is_door_locked     ; Call is_door_locked -- returns Z clear if locked
  RET NZ                  ; Return if the door was locked
  EXX                     ; Switch registers back
  LD A,(HL)               ; Fetch door entry's room_and_direction
  RRA                     ; Rotate it by two bits
  RRA                     ;
  AND $3F                 ; Clear the top two bits rotated in
  LD (IY+$1C),A           ; Store in vischar->room
  LD A,(HL)               ; Fetch door entry's room_and_direction again
  AND $03                 ; Extract the direction field
  CP $02                  ; Is it direction_BOTTOM_RIGHT or direction_BOTTOM_LEFT?
  JR NC,door_handling_3   ; Jump if either of those
; Point to the next door entry's pos
  INC HL                  ; Step forward five bytes to the next door entry
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  JP transition           ; Jump to transition -- never returns
; Point to the previous door entry's pos
door_handling_3:
  DEC HL                  ; Step back three bytes to the previous door entry
  DEC HL                  ;
  DEC HL                  ;
  JP transition           ; Jump to transition -- never returns

; Test whether an exterior door is in range.
;
; A door is in range if (saved_X,saved_Y) is within -3..+2 of its position (once scaled).
;
; Used by the routines at door_handling and get_nearest_door.
;
; I:HL Pointer to a door_t structure.
; O:F C set if no match.
door_in_range:
  INC HL                  ; Step over the room_and_direction field
; Are we in range on the X axis?
  LD A,(HL)               ; Fetch door's pos.x
  EX DE,HL                ; Preserve the door position pointer
  CALL multiply_by_4      ; Multiply pos.x by 4 returning the result in BC
  LD A,C                  ; Subtract 3
  SUB $03                 ;
  LD C,A                  ;
  JR NC,door_in_range_0   ;
  DEC B                   ;
door_in_range_0:
  LD HL,(saved_pos_x)     ; Get saved_pos_x
  SBC HL,BC               ; Calculate saved_pos_x - (pos.x * 4 - 3)
  RET C                   ; Return if carry set (saved_pos_x is under)
  LD A,$06                ; Add 6, to make pos.x * 4 + 3
  ADD A,C                 ;
  LD C,A                  ;
  JR NC,door_in_range_1   ;
  INC B                   ;
door_in_range_1:
  LD HL,(saved_pos_x)     ; Get saved_pos_x again
  SBC HL,BC               ; Calculate saved_pos_x - (pos.x * 4 + 3)
  CCF                     ; Invert the carry flag
  RET C                   ; Return if carry set (saved_pos_x is over)
; Are we in range on the Y axis?
  EX DE,HL                ; Restore door position pointer
  INC HL                  ; Fetch door's pos.y
  LD A,(HL)               ;
  CALL multiply_by_4      ; Multiply pos.y by 4 returning the result in BC
  EX DE,HL                ; Preserve door position pointer
  LD A,C                  ; Subtract 3
  SUB $03                 ;
  LD C,A                  ;
  JR NC,door_in_range_2   ;
  DEC B                   ;
door_in_range_2:
  LD HL,(saved_pos_y)     ; Get saved_pos_y
  SBC HL,BC               ; Calculate saved_pos_y - (pos.y * 4 - 3)
  RET C                   ; Return if carry set (saved_pos_y is under)
  LD A,$06                ; Add 6, to make pos.y * 4 + 3
  ADD A,C                 ;
  LD C,A                  ;
  JR NC,door_in_range_3   ;
  INC B                   ;
door_in_range_3:
  LD HL,(saved_pos_y)     ; Get saved_pos_y again
  SBC HL,BC               ; Calculate saved_pos_y - (pos.y * 4 + 3)
  CCF                     ; Invert the carry flag
  RET                     ; Return with result of final test

; Multiplies A by 4, returning the result in BC.
;
; Used by the routines at transition and door_in_range.
;
; I:A Value to multiply.
; O:BC Result of A * 4.
multiply_by_4:
  LD B,$00                ; Initialise high byte of result to zero
  ADD A,A                 ; Double input value
  RL B                    ; Shift carry out into high byte
  ADD A,A                 ; Double input value
  RL B                    ; Shift carry out into high byte
  LD C,A                  ; BC is the multiplied value
  RET                     ; Return

; Check the character is inside of bounds, when indoors.
;
; Used by the routine at bounds_check.
;
; I:IY Pointer to visible character.
; O:F Z clear if boundary hit, set otherwise.
interior_bounds_check:
  LD A,(roomdef_bounds_index) ; Fetch index into room dimensions (roomdef_bounds_index)
; Point BC at roomdef_dimensions[roomdef_bounds_index]
  ADD A,A                 ; Multiply index by the size of a bounds (4)
  ADD A,A                 ;
  LD BC,roomdef_dimensions ; Point BC at roomdef_dimensions[0]
  ADD A,C                       ; Combine BC with the scaled index
  LD C,A                        ;
  JR NC,interior_bounds_check_0 ;
  INC B                         ;
; Check X axis
;
; Note that the room dimensions are given in an unusual order: x1, x0, y1, y0.
interior_bounds_check_0:
  LD HL,saved_pos_x       ; Point HL at saved_pos
  LD A,(BC)               ; Fetch bounds.x1
  CP (HL)                 ; Compare bounds.x1 with saved_pos_x
  JR C,stop               ; If bounds.x1 < saved_pos_x jump to 'stop'
  INC BC                  ; Fetch bounds.x0
  LD A,(BC)               ;
  ADD A,$04               ; Add 4
  CP (HL)                 ; Compare (bounds.x0 + 4) with saved_pos_x
  JR NC,stop              ; If (bounds.x0 + 4) >= saved_pos_x jump to 'stop'
  INC HL                  ; Advance HL to saved_pos_y
  INC HL                  ;
; Bug: The next instruction is stray code. DE is incremented but never used.
  INC DE                  ; (bug)
; Check Y axis
  INC BC                  ; Point BC at bounds.y1
  LD A,(BC)               ; Fetch bounds.y1
  SUB $04                 ; Subtract 4
  CP (HL)                 ; Compare (bounds.y1 - 4) with saved_pos_y
  JR C,stop               ; If (bounds.y1 - 4) < saved_pos_y jump to 'stop'
  INC BC                  ; Point BC at bounds.y0
  LD A,(BC)               ; Fetch bounds.y0
  CP (HL)                 ; Compare bounds.y0 with saved_pos_y
  JR NC,stop              ; If bounds.y0 >= saved_pos_y jump to 'stop'
; Bomb out if there are no bounds to consider.
  LD HL,roomdef_object_bounds_count ; Point HL at roomdef_object_bounds_count
  LD B,(HL)               ; Fetch the count of object bounds
  LD A,B                  ; Move it to A so we can test it
  AND A                   ; Is the count zero?
  RET Z                   ; Return with Z set if so
  INC HL                  ; Step over to roomdef_object_bounds
; Start loop (outer)
interior_bounds_check_1:
  PUSH BC                 ; Preserve the loop counter
  PUSH HL                 ; Preserve the bounds pointer
  LD DE,saved_pos_x       ; Point HL at saved_pos
  LD B,$02                ; 2 iterations - once per axis
; Start loop (inner)
interior_bounds_check_2:
  LD A,(DE)               ; Fetch saved_pos_x, or saved_pos_y on the second pass
  CP (HL)                 ; Is it less than the lower bound?
  JR C,next               ; Jump to the next iteration if so
  INC HL                  ; Step to the upper bound
  CP (HL)                 ; Is it greater or equal to the upper bound?
  JR NC,next              ; Jump to the next iteration if so
  INC DE                  ; Step to the next saved_pos axis
  INC DE                  ;
  INC HL                  ; Step to the next bound axis
  DJNZ interior_bounds_check_2 ; ...loop (inner)
; Found.
  POP HL                  ; Restore the bounds pointer
  POP BC                  ; Restore the loop counter
; Toggle movement direction preference.
stop:
  LD A,(IY+$07)           ; Fetch IY->counter_and_flags
  XOR $20                 ; Toggle vischar_BYTE7_Y_DOMINANT
  LD (IY+$07),A           ; Store IY->counter_and_flags
  OR $01                  ; Clear Z flag
  RET                     ; Return with Z clear
; Next iteration.
next:
  POP HL                  ; Restore the bounds pointer
  LD DE,$0004             ; Advance to next bound
  ADD HL,DE               ;
  POP BC                  ; Restore the loop counter
  DJNZ interior_bounds_check_1 ; ...loop (outer)
; Not found.
  AND B                   ; B is zero, AND it with itself to set Z flag
  RET                     ; Return with Z set

; Reset the hero's position, redraw the scene, then zoombox it onto the screen.
;
; Used by the routines at transition and keyscan_break.
;
; Reset hero's position.
reset_outdoors:
  LD HL,$8000                            ; Reset the hero's screen position
  CALL calc_vischar_iso_pos_from_vischar ;
; Centre the map position on the hero.
  LD HL,$8018             ; Point HL at the hero's iso_pos.x
  LD A,(HL)               ; Read it into (A, C)
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8        ; Divide (C,A) by 8 (with no rounding). Result is in A
; 11 here is the width of the game screen minus half of the hero's width
  SUB $0B                 ; Subtract 11
  LD (map_position),A     ; Set map_position.x
  INC L                   ; Advance HL to the hero's iso_pos.y
  LD A,(HL)               ; Read it into (A, C)
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8        ; Divide (C,A) by 8 (with no rounding). Result is in A
; 6 here is the height of the game screen minus half of the hero's height
  SUB $06                 ; Subtract 6
  LD ($81BC),A            ; Set map_position.y
  XOR A                   ; Set the global current room index to room_0_OUTDOORS
  LD (room_index),A       ;
  CALL get_supertiles     ; Update the supertiles in map_buf
  CALL plot_all_tiles     ; Plot all tiles
  CALL setup_movable_items ; Setup movable items
  CALL zoombox            ; Zoombox the scene onto the screen
  RET                     ; Return

; Door handling (indoors).
;
; Used by the routine at door_handling.
;
; I:IY Pointer to visible character.
door_handling_interior:
  LD HL,interior_doors    ; Point HL at the interior_doors array
; Loop through every door index in interior_doors.
;
; Start loop
door_handling_interior_0:
  LD A,(HL)               ; Fetch a door index
  CP $FF                  ; Does it equal door_NONE? ($FF)
  RET Z                   ; If so, we've reached the end of the list - return
  EXX                     ; Switch register banks until the end of this iteration
  LD (current_door),A     ; Set the global current door to door index
  CALL get_door           ; Turn the door_index into a door_t structure pointer in HL
  LD A,(HL)               ; Fetch room_and_flags from the door_t and save in C for later
  LD C,A                  ;
; Does the character face the same direction as the door?
  AND $03                 ; Mask off the door's direction part (door_FLAGS_MASK_DIRECTION)
  LD B,A                  ; Stash it in B for a comparison in a moment
  LD A,(IY+$0E)           ; Fetch IY's direction & crawl byte
  AND $03                 ; Mask off the direction part (vischar_DIRECTION_MASK)
  CP B                    ; Do the door and vischar have the same direction?
  JR NZ,dhi_next          ; Jump to the next iteration if not
; Skip any door which is more than three units away.
  INC HL                  ; Advance HL to point at door's position
  EX DE,HL                ; Move it into DE
; TODO: Does this treat saved_pos as 8-bit quantities? (it's normally 16-bit)
  LD HL,saved_pos_x       ; Point DE at saved_pos_x
  LD B,$02                ; Iterate twice: X,Y axis
; Start loop
door_handling_interior_1:
  LD A,(DE)               ; Fetch door position x/y
  SUB $03                 ; Subtract 3 to form lower bound (pos-3)
  CP (HL)                 ; Compare to saved_pos_x/y
  JR NC,dhi_next          ; If lower bound >= saved_pos goto next
  ADD A,$06               ; Add 6 to form upper bound (pos+3)
  CP (HL)                 ; Compare to saved_pos_x/y
  JR C,dhi_next           ; If upper bound < saved_pos goto next
  INC HL                  ; Step to the next saved_pos axis
  INC HL                  ;
  INC DE                  ; Step to the next door position axis
  DJNZ door_handling_interior_1 ; ...loop
  INC DE                  ; Skip position height byte
  EX DE,HL                ; Move door position back into HL
  PUSH HL                 ; Preserve door position pointer
  PUSH BC                 ; Preserve iteration counter
  CALL is_door_locked     ; Locate current door. Returns Z set if door is open
  POP BC                  ; Restore iteration counter
  POP HL                  ; Restore door position pointer
  RET NZ                  ; Return if Z clear => the door was locked
; The door is in range and is unlocked - proceed with transition.
;
; Set the vischar's room to the door's destination.
  LD A,C                  ; Retrieve the room_and_flags we saved earlier
  RRA                     ; Discard the direction bits so it's room index only
  RRA                     ;
  AND $3F                 ;
  LD (IY+$1C),A           ; Store it in vischar->room
; Get the destination position for transition.
;
; If we're going through the door in the forward direction we fetch our destination position from the next element in the list. If we're reversed we fetch the previous element in the list.
  INC HL                  ; Point at the next door position
  LD A,(current_door)     ; Fetch the global current door
  BIT 7,A                 ; Is door_REVERSE set?
  JR Z,door_handling_interior_2 ; Jump if so. HL is setup for transition call
  LD A,L                         ; Subtract 8 from HL
  SUB $08                        ;
  LD L,A                         ;
  JR NC,door_handling_interior_2 ;
  DEC H                          ;
door_handling_interior_2:
  JP transition           ; Jump to transition -- never returns
dhi_next:
  EXX                     ; Unbank
  INC HL                  ; Advance to the next door in interior_doors[]
  JR door_handling_interior_0 ; ...loop

; The hero has tried to open the red cross parcel.
action_red_cross_parcel:
  LD A,$3F                ; Clear the red cross parcel item's room field
  LD ($771D),A            ;
  LD HL,items_held        ; Point HL at items_held
; We've arrived here from a 'use' command, so one or the other item must be the red cross parcel.
  LD A,$0C                ; Is the first item the red cross parcel? (item_RED_CROSS_PARCEL)
  CP (HL)                 ;
  JR Z,action_red_cross_parcel_0 ; Jump if so
  INC HL                  ; Advance if not
; HL now points to the held item.
action_red_cross_parcel_0:
  LD (HL),$FF             ; Remove parcel from the inventory
  CALL draw_all_items     ; Draw both held items
  LD A,(red_cross_parcel_current_contents) ; Fetch the value of the parcel's current contents
  CALL drop_item_tail     ; Pass that into "drop item, tail part"
  LD B,$0C                ; Queue the message "YOU OPEN THE BOX"
  CALL queue_message      ;
  JP increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50 and exit via

; The hero tries to bribe a prisoner.
;
; This searches through the visible, friendly characters only and returns the first found. The selected character will then pursue the hero. Once they've touched it will accept the bribe (see tr_pursue).
;
; Iterate over non-player visible characters.
action_bribe:
  LD HL,$8020             ; Point HL at the second visible character
  LD B,$07                ; Set B for seven iterations
; Start loop
action_bribe_0:
  LD A,(HL)               ; Fetch the vischar's character index
  CP $FF                  ; Is it character_NONE?
  JR Z,action_bribe_1     ; Jump to the next vischar if so
  CP $14                  ; Is it character_20_PRISONER_1?
  JR NC,bribe_found       ; Jump to bribe_found if >=
action_bribe_1:
  LD A,$20                ; Step to the next vischar
  ADD A,L                 ;
  LD L,A                  ;
  DJNZ action_bribe_0     ; ...loop
  RET                     ; Return
bribe_found:
  LD (bribed_character),A ; Set the global bribed character to A
  INC L                   ; Point HL at vischar flags
  LD (HL),$01             ; Set flags to vischar_PURSUIT_PURSUE
  RET                     ; Return

; Use poison.
action_poison:
  LD HL,(items_held)      ; Load both held items
  LD A,$07                ; Prepare item_FOOD
  CP L                    ; Is the first item item_FOOD?
  JR Z,have_food          ; Jump to have_food if so
  CP H                    ; Is the second item item_FOOD?
  RET NZ                  ; Return if not
have_food:
  LD HL,item_structs_food ; Point HL at item_structs[item_FOOD].item
  BIT 5,(HL)              ; Is bit 5 set? (itemstruct_ITEM_FLAG_POISONED)
  RET NZ                  ; Return if so - the food is already poisoned
  SET 5,(HL)              ; Set bit 5
  LD A,$43                    ; Set the screen attribute for the food item to bright-purple over black
  LD (item_attributes_food),A ;
  CALL draw_all_items     ; Draw both held items
  JP increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50 and exit via

; Use guard's uniform.
action_uniform:
  LD HL,$8015             ; Point HL at the hero's vischar sprite set pointer
  LD DE,sprite_guard      ; Point DE at the guard sprite set
; Bail out if the hero's already in the uniform
  LD A,(HL)               ; Cheap equality test
  CP E                    ;
  RET Z                   ;
; Can't don the uniform when in a tunnel
  LD A,(room_index)       ; If the global current room index is room_29_SECOND_TUNNEL_START or above... we're in the tunnels, so bail out
  CP $1D                  ;
  RET NC                  ;
; Otherwise the uniform can be worn
  LD (HL),E               ; Set the hero's sprite set to sprite_guard
  INC L                   ;
  LD (HL),D               ;
  JP increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50 and exit via

; Use shovel. The shovel only works in the room with the blocked tunnel: number 50.
action_shovel:
  LD A,(room_index)       ; If the global current room index isn't room_50_BLOCKED_TUNNEL bail out
  CP $32                  ;
  RET NZ                  ;
; Bomb out if the blockage is already removed.
  LD A,(roomdef_50_blocked_tunnel_boundary) ; Fetch the room definition's first boundary byte
  CP $FF                  ; Is it 255?
  RET Z                   ; Return if so - the blockage was already removed
; Otherwise we can remove the blockage
;
; (Note that the hero doesn't need to be adjacent to the blockage for this to work, only in the same room).
;
; The blockage boundary's x0 is set to 255. This invalidates the boundary by forcing the "x < bounds->x0" test at B2D9 (in interior_bounds_check) to fail.
  LD A,$FF                                  ; roomdef_50_blocked_tunnel_boundary[0] = 255
  LD (roomdef_50_blocked_tunnel_boundary),A ;
; Remove the blockage graphic.
  INC A                                             ; roomdef_50_blocked_tunnel_collapsed_tunnel = 0
  LD (roomdef_50_blocked_tunnel_collapsed_tunnel),A ;
  CALL setup_room         ; Setup the room
  CALL choose_game_window_attributes ; Choose game window attributes
  CALL plot_interior_tiles ; Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
  JP increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50 and exit via

; Use wiresnips.
;
; Check the hero's position against the four vertically-oriented fences.
action_wiresnips:
  LD HL,$B589             ; Point HL at the 12th entry of the walls array: the start of the vertically-oriented fences PLUS three bytes so it points at the maxy value.
  LD DE,hero_map_position_y ; Point DE at hero_map_position.y
  LD B,$04                ; Set B for four iterations (four vertical fences)
; Start loop
action_wiresnips_0:
  PUSH HL                 ; Preserve the wall entry pointer during this iteration
; Are we in range on the Y axis?
  LD A,(DE)               ; Fetch hero_map_position.y
  CP (HL)                 ; Is it >= wall->maxy?
  JR NC,snips_next_vert   ; Jump to the next iteration if so
  DEC HL                  ; Step HL back to wall->miny
  CP (HL)                 ; Is it < wall->miny?
  JR C,snips_next_vert    ; Jump to the next iteration if so
; Are we adjacent to the wall on the X axis?
  DEC DE                  ; Step DE back to hero_map_position.x
  LD A,(DE)               ; Fetch hero_map_position.x
  DEC HL                  ; Step HL back to wall->maxx
  CP (HL)                 ; Is it == wall->maxx?
  JR Z,snips_crawl_tl     ; Jump to snips_crawl_tl if so
  DEC A                   ; Try the opposite side
  CP (HL)                 ; Is it == wall->maxx?
  JR Z,snips_crawl_br     ; Jump to snips_crawl_br if so
  INC DE                  ; Advance DE to hero_map_position.y
snips_next_vert:
  POP HL                  ; Restore wall array pointer
  LD A,L                   ; Advance HL to the next wall array element PLUS 3 bytes
  ADD A,$06                ;
  LD L,A                   ;
  JR NC,action_wiresnips_1 ;
  INC H                    ;
action_wiresnips_1:
  DJNZ action_wiresnips_0 ; ...loop
; Check the hero's position against the three horizontally-oriented fences.
  DEC DE                  ; Step DE back to hero_map_position.x
; Point HL at the 16th entry of walls array (start of horizontal fences).
  DEC HL                  ; Step HL back to the 16th entry of the walls array PLUS 0 bytes (it's three ahead prior to this)
  DEC HL                  ;
  DEC HL                  ;
  LD B,$03                ; Set B for three iterations (three horizontal fences)
; Start loop
action_wiresnips_2:
  PUSH HL                 ; Preserve wall array pointer during this iteration
; Are we in range on the X axis?
  LD A,(DE)               ; Fetch hero_map_position.x
  CP (HL)                 ; Is it < wall->minx?
  JR C,snips_next_horz    ; Jump to the next iteration if so
  INC HL                  ; Advance HL to wall->maxx
  CP (HL)                 ; Is x >= wall->maxx?
  JR NC,snips_next_horz   ; Jump to the next iteration if so
; Are we adjacent to the wall on the Y axis?
  INC DE                  ; Advance DE to hero_map_position.y
  LD A,(DE)               ; Fetch hero_map_position.y
  INC HL                  ; Advance HL to wall->miny
  CP (HL)                 ; Is it == wall->miny?
  JR Z,snips_crawl_tr     ; Jump to snips_crawl_tr if so
  DEC A                   ; Try the opposite side
  CP (HL)                 ; Is it == wall->maxy?
  JR Z,snips_crawl_bl     ; Jump to snips_crawl_bl if so
  DEC DE                  ; Step DE back to hero_map_position.x
snips_next_horz:
  POP HL                  ; Restore wall array pointer
  LD A,L                   ; Advance HL to the next wall array element PLUS 3 bytes
  ADD A,$06                ;
  LD L,A                   ;
  JR NC,action_wiresnips_3 ;
  INC H                    ;
action_wiresnips_3:
  DJNZ action_wiresnips_2 ; ...loop
  RET                     ; Return
snips_crawl_tl:
  LD A,$04                ; Set A to 4 (direction_TOP_LEFT + vischar_DIRECTION_CRAWL)
  JR snips_tail           ; Jump forward
snips_crawl_tr:
  LD A,$05                ; Set A to 5 (direction_TOP_RIGHT + vischar_DIRECTION_CRAWL)
  JR snips_tail           ; Jump forward
snips_crawl_br:
  LD A,$06                ; Set A to 6 (direction_BOTTOM_RIGHT + vischar_DIRECTION_CRAWL)
  JR snips_tail           ; Jump forward
snips_crawl_bl:
  LD A,$07                ; Set A to 7 (direction_BOTTOM_LEFT + vischar_DIRECTION_CRAWL)
; A is the direction + crawl flag. Proceed to making the hero cut the wire.
snips_tail:
  POP HL                  ; Restore wall array pointer
  LD HL,$800E             ; Set hero's vischar.direction field (direction and walk/crawl flag) to the direction selected above
  LD (HL),A               ;
  DEC L                   ; Set hero's vischar.input field to input_KICK
  LD (HL),$80             ;
  LD HL,$8001             ; Set hero's vischar.flags to vischar_FLAGS_CUTTING_WIRE
  LD (HL),$02             ;
  LD A,$0C                ; Set hero's vischar.mi.pos.height to 12
  LD ($8013),A            ;
  LD HL,sprite_prisoner   ; Set vischar.mi.sprite to the prisoner sprite set
  LD ($8015),HL           ;
  LD A,(game_counter)            ; Lock out the player until the game counter is now + 96
  ADD A,$60                      ;
  LD (player_locked_out_until),A ;
  LD B,$0B                ; Queue the message "CUTTING THE WIRE" and exit via
  JP queue_message        ;

; Use lockpick.
action_lockpick:
  CALL get_nearest_door   ; Get the nearest door in range of the hero in HL
  RET NZ                  ; Return if no door was nearby
  LD (ptr_to_door_being_lockpicked),HL ; Store the door_t pointer in ptr_to_door_being_lockpicked
  LD A,(game_counter)            ; Lock out player control until the game counter becomes now + 255
  ADD A,$FF                      ;
  LD (player_locked_out_until),A ;
  LD HL,$8001             ; Set hero's vischar.flags to vischar_FLAGS_PICKING_LOCK
  LD (HL),$01             ;
  LD B,$0A                ; Queue the message "PICKING THE LOCK" and exit via
  JP queue_message        ;

; Use red key.
action_red_key:
  LD A,$16                ; Set the room number in A to room_22_REDKEY
  JR action_key           ; Jump to action_key

; Use yellow key.
action_yellow_key:
  LD A,$0D                ; Set the room number in A to room_13_CORRIDOR
  JR action_key           ; Jump to action_key

; Use green key.
action_green_key:
  LD A,$0E                ; Set the room number in A to room_14_TORCH
; FALL THROUGH into action_key.

; Use a key.
;
; Used by the routines at action_red_key and action_yellow_key.
;
; I:A Room number to which the key applies.
action_key:
  PUSH AF                 ; Preserve the room number while we get the nearest door
  CALL get_nearest_door   ; Return the nearest door in range of the hero in HL
  POP BC                  ; Restore the room number
  RET NZ                  ; Return if no door was nearby
  LD A,(HL)               ; Fetch door index + flag
  AND $7F                 ; Mask off door_LOCKED flag to get door index alone
  CP B                    ; Are they equal?
  LD B,$07                ; Set B to message_INCORRECT_KEY irrespectively
  JR NZ,action_key_0      ; Jump if not equal
  RES 7,(HL)              ; Unlock the door by resetting door_LOCKED ($80)
  CALL increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50
  LD B,$06                ; Set B to message_IT_IS_OPEN
action_key_0:
  JP queue_message        ; Queue the message identified by B

; Return the nearest door in range of the hero.
;
; Used by the routines at action_lockpick and action_key.
;
; O:HL Pointer to door in locked_doors.
; O:F Returns Z set if a door was found, clear otherwise.
get_nearest_door:
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Is it room_0_OUTDOORS?
  JR Z,gnd_outdoors       ; Jump forward to handle outdoors if so
; Bug: Could avoid this jump instruction by using fallthrough instead.
  JP gnd_indoors          ; Otherwise jump forward to handle indoors
; Outdoors.
;
; Locked doors 0..4 include exterior doors.
gnd_outdoors:
  LD B,$05                ; Set B for five iterations
  LD HL,locked_doors      ; Point HL at the locked door indices
; Start loop
gnd_outdoors_loop:
  LD A,(HL)               ; Fetch the door index and door_LOCKED flag
  AND $7F                 ; Mask off door_LOCKED flag to get the door index alone
  EXX                     ; Switch register banks for this iteration
  CALL get_door           ; Turn a door index into a door_t pointer in HL
  PUSH HL                 ; Preserve the door_t pointer
  CALL door_in_range      ; Call door_in_range. C is clear if it's in range
  POP HL                  ; Restore door_t pointer
  JR NC,gnd_in_range      ; Jump forward if in range
  INC HL                  ; Advance HL to the next door_t
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  CALL door_in_range      ; Call door_in_range. C is clear if it's in range
  JR NC,gnd_in_range      ; Jump forward if in range
  EXX                     ; Unbank
  INC HL                  ; Advance to the next door index and flag in locked_doors
  DJNZ gnd_outdoors_loop  ; ...loop
  RET                     ; Return with Z clear (from the INC HL above) (not found)
gnd_in_range:
  EXX                     ; Unbank
  XOR A                   ; Set Z flag (found)
  RET                     ; Return
; Indoors. Locked doors 2..8 include interior doors.
gnd_indoors:
  LD HL,$F05F             ; Point HL at the third locked door index
; Bug: Ought to be 7 iterations.
  LD B,$08                ; Set B for eight iterations
; Start loop
gnd_indoors_loop:
  LD A,(HL)               ; Fetch the door index and door_LOCKED flag
  AND $7F                 ; Mask off door_LOCKED flag to get the door index alone
  LD C,A                  ; Keep in C for use during the loop
; Search interior doors for the door index in C.
  LD DE,interior_doors    ; Point DE at interior_doors
; Start loop (inner)
gnd_indoors_loop_2:
  LD A,(DE)               ; Fetch an interior door index
  CP $FF                  ; Is it door_NONE? (end of list)
  JR Z,gnd_next           ; Jump if so
  AND $7F                 ; Mask off door_REVERSE flag to get the door index alone
  CP C                    ; Is it a locked door index?
  JR Z,gnd_found          ; Jump if so
  INC DE                  ; Otherwise advance to the next interior door index
; There's no termination condition here where you might expect a test to see if we've run out of doors, but since every room has at least one door it *must* find one.
  JR gnd_indoors_loop_2   ; ...loop
; Start loop
gnd_next:
  INC HL                  ; Advance to the next door index and flag in locked_doors
  DJNZ gnd_indoors_loop   ; ...loop
  OR $01                  ; Clear the Z flag (not found)
  RET                     ; Return
gnd_found:
  LD A,(DE)               ; Fetch an interior door index
  EXX                     ; Switch register banks until we return
  CALL get_door           ; Turn a door index into a door_t pointer in HL
  INC HL                  ; Advance door pointer to door.pos.x
  EX DE,HL                ; Move the door pointer into DE
  LD HL,saved_pos_x       ; Point HL at saved_pos_x
  LD B,$02                ; Set B for two iterations (two axis)
; Note: This treats saved_pos as an 8-bit quantity in a 16-bit container.
;
; Start loop -- once for each axis
;
; On each axis if ((door - 2) <= pos and (door + 3) >= pos) then we're good.
get_nearest_door_0:
  LD A,(DE)               ; Fetch door.pos.x/y
  SUB $03                 ; Compute the lower bound by subtracting 3
  CP (HL)                 ; Is lower bound >= saved_pos_x/y?
  JR NC,gnd_exx_next      ; Jump if so (out of bounds - try the next door)
  ADD A,$06               ; Compute the upper bound by adding 6
  CP (HL)                 ; Is upper bound < saved_pos_x/y?
  JR C,gnd_exx_next       ; Jump if so (out of bounds - try the next door)
  INC HL                  ; Advance to the next saved_pos axis
  INC HL                  ;
  INC DE                  ; Advance to the next door.pos axis
  DJNZ get_nearest_door_0 ; ...loop
; If we arrive here then we're within the bounds
  EXX                     ; Switch back
  XOR A                   ; Set Z flag (found)
  RET                     ; Return
gnd_exx_next:
  EXX                     ; Switch back
  JR gnd_next             ; ...loop

; Wall boundaries.
;
; The coordinates are in map space.
;
; +-------+----------------+
; | Field | Description    |
; +-------+----------------+
; | minx  | Minimum x      |
; | maxx  | Maximum x      |
; | miny  | Minimum y      |
; | maxy  | Maximum y      |
; | minh  | Minimum height |
; | maxh  | Maximum height |
; +-------+----------------+
walls:
  DEFB $6A,$6E,$52,$62,$00,$0B ; 0: (106-110,  82-98,  0-11) Hut 0 (leftmost on main map)
  DEFB $5E,$62,$52,$62,$00,$0B ; 1: ( 94-98,   82-98,  0-11) Hut 1 (home hut)
  DEFB $52,$56,$52,$62,$00,$0B ; 2: ( 82-86,   82-98,  0-11) Hut 2 (rightmost on main map)
  DEFB $3E,$5A,$6A,$80,$00,$30 ; 3: ( 62-90,  106-128, 0-48) Main building, top right
  DEFB $34,$80,$72,$80,$00,$30 ; 4: ( 52-128, 114-128, 0-48) Main building, topmost/right
  DEFB $7E,$98,$5E,$80,$00,$30 ; 5: (126-152,  94-128, 0-48) Main building, top left
  DEFB $82,$98,$5A,$80,$00,$30 ; 6: (130-152,  90-128, 0-48) Main building, top left
  DEFB $86,$8C,$46,$80,$00,$0A ; 7: (134-140,  70-128, 0-10) Main building, left wall / west wall
  DEFB $82,$86,$46,$4A,$00,$12 ; 8: (130-134,  70-74,  0-18) Corner, bottom left / west turret wall
  DEFB $6E,$82,$46,$47,$00,$0A ; 9: (110-130,  70-71,  0-10) Front wall / south wall
  DEFB $6D,$6F,$45,$49,$00,$12 ; 10: (109-111,  69-73,  0-18) Gate post (left)
  DEFB $67,$69,$45,$49,$00,$12 ; 11: (103-105,  69-73,  0-18) Gate post (right)
  DEFB $46,$46,$46,$6A,$00,$08 ; 12: ( 70-70,   70-106, 0-8 ) Fence - right of main camp (vertical)
  DEFB $3E,$3E,$3E,$6A,$00,$08 ; 13: ( 62-62,   62-106, 0-8 ) Fence - rightmost fence (vertical)
  DEFB $4E,$4E,$2E,$3E,$00,$08 ; 14: ( 78-78,   46-62,  0-8 ) Fence - rightmost of yard (vertical)
  DEFB $68,$68,$2E,$45,$00,$08 ; 15: (104-104,  46-69,  0-8 ) Fence - leftmost of yard (vertical)
  DEFB $3E,$68,$3E,$3E,$00,$08 ; 16: ( 62-104,  62-62,  0-8 ) Fence - top of yard (horizontal)
  DEFB $4E,$68,$2E,$2E,$00,$08 ; 17: ( 78-104,  46-46,  0-8 ) Fence - bottom of yard (horizontal)
  DEFB $46,$67,$46,$46,$00,$08 ; 18: ( 70-103,  70-70,  0-8 ) Fence - bottom of main camp (horizontal)
  DEFB $68,$6A,$38,$3A,$00,$08 ; 19: (104-106,  56-58,  0-8 ) Fence - watchtower (left, outside of exercise yard)
  DEFB $4E,$50,$2E,$30,$00,$08 ; 20: ( 78-80,   46-48,  0-8 ) Fence - watchtower (inside exercise yard)
  DEFB $46,$48,$46,$48,$00,$08 ; 21: ( 70-72,   70-72,  0-8 ) Fence - watchtower (corner of main camp)
  DEFB $46,$48,$5E,$60,$00,$08 ; 22: ( 70-72,   94-96,  0-8 ) Fence - watchtower (top right of main camp)
  DEFB $69,$6D,$46,$49,$00,$08 ; 23: (105-109,  70-73,  0-8 ) Fence - gate wall middle

; Animate all visible characters.
;
; Used by the routines at setup_movable_items and main_loop.
animate:
  LD B,$08                ; Set B for eight iterations
  LD IY,$8000             ; Point IY at the first vischar
; Start loop
animate_loop:
  LD A,(IY+$01)           ; Read the vischar's flags byte
  CP $FF                  ; Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
  JP Z,animate_next       ; Jump to the next iteration if so
  PUSH BC                 ; Preserve the loop counter
  SET 7,(IY+$01)          ; Set flags byte to vischar_FLAGS_NO_COLLIDE ($80)
  BIT 7,(IY+$0D)          ; Does the vischar's input field have flag input_KICK set? ($80)
  JP NZ,animate_kicked    ; Jump if so
  LD H,(IY+$0B)           ; Fetch vischar animation pointer into HL
  LD L,(IY+$0A)           ;
  LD A,(IY+$0C)           ; Fetch vischar animation index
  AND A                   ; Is vischar_ANIMINDEX_REVERSE set? ($80)
  JP P,animate_3          ; Jump if not
  AND $7F                 ; Otherwise mask off vischar_ANIMINDEX_REVERSE to get our frame number
; Bug: This ought to check for $7F, not zero.
  JP Z,animate_init       ; Jump to initialisation if the result is zero
  INC A                   ; Calculate the animation frame pointer = (animation pointer) + (frame number + 1) * 4 - 1
  ADD A,A                 ;
  ADD A,A                 ;
  LD C,A                  ;
  LD B,$00                ;
  ADD HL,BC               ;
  DEC HL                  ;
  LD A,(HL)               ; Fetch anim's sprite index
  EX AF,AF'               ; Bank sprite index
  INC HL                  ; ...
animate_backwards:
  EX DE,HL                ; Swap frame pointers
; Apply frame deltas
;
; saved_pos_x = vischar.mi.pos.x - frame->dx
  LD L,(IY+$0F)           ; Fetch vischar.mi.pos.x into HL
  LD H,(IY+$10)           ;
  LD A,(DE)               ; Load animation frame's delta X
  LD C,A                  ; Sign extend into BC
  AND $80                 ;
  JR Z,animate_0          ;
  LD A,$FF                ;
animate_0:
  LD B,A                  ;
  SBC HL,BC               ; Subtract the delta
  LD (saved_pos_x),HL     ; Save it in saved_pos_x
; saved_pos_y = vischar.mi.pos.y - frame->dy
  INC DE                  ; Advance to animation frame's delta Y
  LD L,(IY+$11)           ; Fetch vischar.mi.pos.y into HL
  LD H,(IY+$12)           ;
  LD A,(DE)               ; Load animation frame's delta Y
  LD C,A                  ; Sign extend into BC
  AND $80                 ;
  JR Z,animate_1          ;
  LD A,$FF                ;
animate_1:
  LD B,A                  ;
  SBC HL,BC               ; Subtract the delta
  LD (saved_pos_y),HL     ; Save it in saved_pos_y
; saved_height = vischar.mi.pos.height - frame->dh
  INC DE                  ; Advance to animation frame's delta height
  LD L,(IY+$13)           ; Fetch vischar.mi.pos.height into HL
  LD H,(IY+$14)           ;
  LD A,(DE)               ; Load animation frame's delta height
  LD C,A                  ; Sign extend into BC
  AND $80                 ;
  JR Z,animate_2          ;
  LD A,$FF                ;
animate_2:
  LD B,A                  ;
  SBC HL,BC               ; Subtract the delta
  LD (saved_height),HL    ; Save it in saved_height
  CALL touch              ; Test for characters meeting obstacles like doors and map bounds
  JP NZ,animate_pop_next  ; If outside bounds (collided with something), jump to animate_pop_next to halt any animation
  DEC (IY+$0C)            ; Decrement animation index (DPT: Was there a bug around here?)
  JR animate_7            ; (else)
; Have we reached the end of the animation?
animate_3:
  CP (HL)                 ; Is the animation index equal to the number of frames in the animation?
  JP Z,animate_init       ; Jump if so
  INC A                   ; Calculate the animation frame pointer = (animation pointer) + (frame number + 1) * 4
  ADD A,A                 ;
  ADD A,A                 ;
  LD C,A                  ;
  LD B,$00                ;
  ADD HL,BC               ;
animate_forwards:
  EX DE,HL                ; Swap frame pointers
; Apply frame deltas
;
; saved_pos_x = vischar.mi.pos.x - frame->dx
  LD A,(DE)               ; Load animation frame's delta X
  LD L,A                  ; Sign extend into HL
  AND $80                 ;
  JR Z,animate_4          ;
  LD A,$FF                ;
animate_4:
  LD H,A                  ;
  LD C,(IY+$0F)           ; Fetch vischar.mi.pos.x into BC
  LD B,(IY+$10)           ;
  ADD HL,BC               ; Add the delta
  LD (saved_pos_x),HL     ; Save it in saved_pos_x
; saved_pos_y = vischar.mi.pos.y - frame->dy
  INC DE                  ; Advance to animation frame's delta Y
  LD A,(DE)               ; Load animation frame's delta Y
  LD L,A                  ; Sign extend into HL
  AND $80                 ;
  JR Z,animate_5          ;
  LD A,$FF                ;
animate_5:
  LD H,A                  ;
  LD C,(IY+$11)           ; Fetch vischar.mi.pos.y into BC
  LD B,(IY+$12)           ;
  ADD HL,BC               ; Add the delta
  LD (saved_pos_y),HL     ; Save it in saved_pos_y
; saved_height = vischar.mi.pos.height - frame->dh
  INC DE                  ; Advance to animation frame's delta height
  LD A,(DE)               ; Load animation frame's delta height
  LD L,A                  ; Sign extend into HL
  AND $80                 ;
  JR Z,animate_6          ;
  LD A,$FF                ;
animate_6:
  LD H,A                  ;
  LD C,(IY+$13)           ; Fetch vischar.mi.pos.height into BC
  LD B,(IY+$14)           ;
  ADD HL,BC               ; Add the delta
  LD (saved_height),HL    ; Save it in saved_height
  INC DE                  ; Advance to animation frame's sprite index
  LD A,(DE)               ; Load animation frame's sprite index
  EX AF,AF'               ; Bank A
  CALL touch              ; Test for characters meeting obstacles like doors and map bounds
  JP NZ,animate_pop_next  ; If outside bounds (collided with something), goto animate_pop_next to halt any animation
  INC (IY+$0C)            ; Increment animation index
animate_7:
  PUSH IY                 ; HL = IY
  POP HL                  ;
  CALL calc_vischar_iso_pos_from_state ; Calculate screen position for vischar from saved_pos
animate_pop_next:
  POP BC
  LD A,(IY+$01)           ; Read the vischar's flags byte
  CP $FF                  ; Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
  JR Z,animate_next       ; Jump forward if so
  RES 7,(IY+$01)          ; Otherwise clear the vischar_FLAGS_NO_COLLIDE flag ($80)
animate_next:
  LD DE,$0020             ; Set DE to the vischar stride (32)
  ADD IY,DE               ; Advance IY to the next vischar
  DEC B                   ; ...loop
  JP NZ,animate_loop      ;
  RET                     ; Return
animate_kicked:
  RES 7,(IY+$0D)          ; Clear the input_KICK flag
animate_init:
  LD A,(IY+$0E)           ; Fetch vischar direction field
  LD D,A                  ; Multiply it by 9
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,D                 ;
  ADD A,(IY+$0D)          ; Add vischar input field to it
  LD E,A                  ; Shuffle it into DE
  LD D,$00                ;
  LD HL,animindices       ; Add it to the animindices base address
  ADD HL,DE               ;
  LD A,(HL)               ; Fetch the index pointed to
  LD C,A                  ; Stash in C for later
  LD L,(IY+$08)           ; Fetch vischar.animbase (animbase is always &animations[0])
  LD H,(IY+$09)           ;
  ADD A,A                 ; Double A (and in doing so discard the top bit!)
  LD E,A                  ; Set DE to A (we know D is zero from above)
  ADD HL,DE               ; Point at the A'th frame pointer
  LD E,(HL)               ; Load the frame pointer into DE and set vischar anim field to it
  INC HL                  ;
  LD (IY+$0A),E           ;
  LD D,(HL)               ;
  LD (IY+$0B),D           ;
  BIT 7,C                 ; Was the reverse bit set on the index?
  JR NZ,animate_8         ; Jump forward if so
  LD (IY+$0C),$00         ; Zero the vischar animindex field
  INC DE                  ; Skip nframes and from fields. Advance DE to animB->to
  INC DE                  ;
  LD A,(DE)               ; Set the vischar direction field to animB->to
  LD (IY+$0E),A           ;
  INC DE                  ; Advance to animB->frames
  INC DE                  ;
  EX DE,HL                ; Swap frame pointers
  JP animate_forwards     ; Jump
; else
animate_8:
  LD A,(DE)               ; Fetch nframes
  LD C,A                  ; Stash in C for later
; Bug: C port uses (nframes - 1) here to fix something... (add detail)
  OR $80                  ; Set the vischar animindex field to (nframes | vischar_ANIMINDEX_REVERSE)
  LD (IY+$0C),A           ;
  INC DE                  ; Advance to 'from'
  LD A,(DE)               ; Set the vischar direction field to 'from'
  LD (IY+$0E),A           ;
; Bug: C port uses final frame here, not first... (add detail)
  INC DE                  ; Advance to animB->frame[0]
  INC DE                  ;
  INC DE                  ;
  PUSH DE                 ; Stack animB
  EX DE,HL                ; Swap frame pointers
  LD A,C                  ; Point HL at anim[nframes - 1].spriteindex
  ADD A,A                 ;
  ADD A,A                 ;
  DEC A                   ;
  LD B,$00                ;
  LD C,A                  ;
  ADD HL,BC               ;
  LD A,(HL)               ; Fetch the new sprite index
  EX AF,AF'               ; Swap the sprite indices
  POP HL                  ; Pop and swap?
  JP animate_backwards    ; Jump

; Calculate screen position for the specified vischar from mi.pos.
;
; Used by the routines at enter_room, setup_movable_item, hero_sit_sleep_common, reset_outdoors and spawn_character.
;
; I:HL Pointer to visible character.
calc_vischar_iso_pos_from_vischar:
  PUSH HL                 ; Preserve vischar pointer
; Save a copy of the vischar's position to global saved_pos.
  LD A,$0F                ; Point HL at vischar.mi.pos
  ADD A,L                 ;
  LD L,A                  ;
  LD DE,saved_pos_x       ; Point DE at saved_pos
  LD BC,$0006             ; Six bytes
  LDIR                    ; Block copy
  POP HL                  ; Restore vischar pointer
; Now FALL THROUGH into calc_vischar_iso_pos_from_state which will read from saved_pos.

; Calculate screen position for the specified vischar from saved_pos.
;
; Used by the routine at animate.
;
; Similar to drop_item_tail_interior.
;
; I:HL Pointer to visible character.
;
; Set vischar.iso_pos.x to ($200 - saved_pos_x + saved_pos_y) * 2
calc_vischar_iso_pos_from_state:
  EX DE,HL                ; Preserve vischar pointer
  LD A,$18                ; Point DE at vischar.iso_pos.x (note shortcut - no rollover into high byte)
  ADD A,E                 ;
  LD E,A                  ;
  LD HL,(saved_pos_y)     ; HL = saved_pos_y + $200
  LD BC,$0200             ;
  ADD HL,BC               ;
  LD BC,(saved_pos_x)     ; Fetch saved_pos_x
  AND A                   ; Clear the carry flag
  SBC HL,BC               ; HL -= saved_pos_x
  ADD HL,HL               ; Double the result
  EX DE,HL                ; Restore vischar pointer
  LD (HL),E               ; Store result in vischar.iso_pos.x
  INC L                   ;
  LD (HL),D               ;
  INC L                   ;
; Set vischar.iso_pos_y = $800 - saved_pos_x - saved_pos_y - saved_height
  EX DE,HL                ; Preserve vischar pointer
  LD HL,$0800             ; HL = $800
  AND A                   ; Clear the carry flag
  SBC HL,BC               ; HL -= saved_pos_x
  LD BC,(saved_height)    ; Fetch saved_height
  SBC HL,BC               ; HL -= saved_height
  LD BC,(saved_pos_y)     ; Fetch saved_pos_y
  SBC HL,BC               ; HL -= saved_pos_y
  EX DE,HL                ; Restore vischar pointer
  LD (HL),E               ; Store result in vischar.iso_pos.y
  INC L                   ;
  LD (HL),D               ;
  RET                     ; Return

; Reset the game.
;
; Used by the routines at keyscan_break, escaped and main.
;
; Cause discovery of all items.
reset_game:
  LD BC,$1000             ; Set B for 16 iterations (item__LIMIT) and set C (item index) to zero
; Start loop (once per item)
reset_game_0:
  PUSH BC                 ; Preserve the iteration counter and item index over the next call
  CALL item_discovered    ; Cause item C to be discovered
  POP BC                  ; Restore
  INC C                   ; Increment the item index
  DJNZ reset_game_0       ; ...loop
; Reset the message queue.
  LD HL,$7CFE                   ; Reset the message queue pointer to its default of message_queue[2]
  LD (message_queue_pointer),HL ;
  CALL reset_map_and_characters ; Reset all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, lock the gates, reset all beds, clear the mess halls and reset characters
  XOR A                   ; Clear the hero's vischar flags
  LD ($8001),A            ;
; Reset score digits, hero_in_breakfast, red_flag, automatic_player_counter, in_solitary and morale_exhausted which occupy a contiguous ten byte region.
  LD HL,score_digits      ; Point HL at score_digits
  LD B,$0A                ; Set B for ten iterations
; Start loop (once per score digit)
reset_game_1:
  LD (HL),A               ; Zero the byte
  INC HL                  ; Then advance to the next byte
  DJNZ reset_game_1       ; ...loop
; Reset morale.
  LD (HL),$70             ; Set morale to morale_MAX
  CALL plot_score         ; Draw the current score to the screen
; Reset and redraw items.
  LD HL,$FFFF             ; Set both items_held to item_NONE ($FF)
  LD (items_held),HL      ;
  CALL draw_all_items     ; Draw both held items
; Reset the hero's sprite.
  LD HL,sprite_prisoner   ; Set vischar.mi.sprite to the prisoner sprite set
  LD ($8015),HL           ;
  LD A,$02                ; Set the global current room index to room_2_HUT2LEFT
  LD (room_index),A       ;
; Put the hero to bed.
  CALL hero_sleeps        ; The hero sleeps
  CALL enter_room         ; The hero enters a room
  RET                     ; Return

; Resets all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, locks the gates, resets all beds, clears the mess halls and resets characters.
;
; Used by the routines at reset_game and solitary.
reset_map_and_characters:
  LD B,$07                ; Set B for seven iterations
  LD HL,$8020             ; Point HL at the second vischar
; Start loop (iterate over non-player characters)
reset_map_and_characters_0:
  PUSH BC                 ; Preserve the counter
  PUSH HL                 ; Preserve the vischar pointer
  CALL reset_visible_character ; Reset the visible character
  POP HL                  ; Restore the vischar pointer
  LD A,L                  ; Advance HL to the next vischar (note shortcut)
  ADD A,$20               ;
  LD L,A                  ;
  POP BC                  ; Restore the counter
  DJNZ reset_map_and_characters_0 ; ...loop
  LD A,$07                ; Set the game clock to seven [unsure why seven in particular]
  LD (clock),A            ;
  XOR A                   ; Clear the night-time flag
  LD (day_or_night),A     ;
  LD ($8001),A            ; Clear the hero's vischar flags
  LD A,$14                                          ; Set the roomdef_50_blocked_tunnel_collapsed_tunnel object to interiorobject_COLLAPSED_TUNNEL_SW_NE
  LD (roomdef_50_blocked_tunnel_collapsed_tunnel),A ;
  LD A,$34                                  ; Set the blocked tunnel boundary
  LD (roomdef_50_blocked_tunnel_boundary),A ;
; Lock the gates and doors.
  LD HL,locked_doors      ; Point HL at locked_doors[0]
  LD B,$09                ; Set B for nine iterations (nine locked doors)
; Start loop
reset_map_and_characters_1:
  SET 7,(HL)              ; Set the door_LOCKED flag Advance HL to the next locked door
  INC HL                  ;
  DJNZ reset_map_and_characters_1 ; ...loop
; Reset all beds.
  LD B,$06                ; Set B for six iterations (six beds)
  LD A,$17                ; Preload A with interiorobject_OCCUPIED_BED
  LD HL,beds              ; Point HL at beds[0]
; Start loop
reset_map_and_characters_2:
  LD E,(HL)               ; Load the address of the bed object
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  LD (DE),A               ; Set the bed object to interiorobject_OCCUPIED_BED
  DJNZ reset_map_and_characters_2 ; ...loop
; Clear the mess halls.
  LD A,$0D                ; Preload A with interiorobject_EMPTY_BENCH
  LD (roomdef_23_breakfast_bench_A),A ; Set to empty roomdef_23_breakfast_bench_A
  LD (roomdef_23_breakfast_bench_B),A ; Set to empty roomdef_23_breakfast_bench_B
  LD (roomdef_23_breakfast_bench_C),A ; Set to empty roomdef_23_breakfast_bench_C
  LD (roomdef_25_breakfast_bench_D),A ; Set to empty roomdef_25_breakfast_bench_D
  LD (roomdef_25_breakfast_bench_E),A ; Set to empty roomdef_25_breakfast_bench_E
  LD (roomdef_25_breakfast_bench_F),A ; Set to empty roomdef_25_breakfast_bench_F
  LD (roomdef_25_breakfast_bench_G),A ; Set to empty roomdef_25_breakfast_bench_G
; Reset characters 12..15 (guards) and 20..25 (prisoners).
  LD DE,$7667             ; Point DE at character_structs[12].room
  LD C,$0A                ; Set C for ten iterations
  LD HL,character_reset_data ; Point HL at character_reset_data[0]
; Start loop
reset_map_and_characters_3:
  LD B,$03                ; Set B for three iterations
reset_map_and_characters_4:
  LD A,(HL)               ; Copy a byte and advance
  LD (DE),A               ;
  INC DE                  ;
  INC HL                  ;
  DJNZ reset_map_and_characters_4 ; ...loop
; DE now points to the height
  EX DE,HL                ; Swap
; Bug: This is reset to 18 here but the initial value is 24.
  LD (HL),$12             ; Set height to 18 and advance
  INC HL                  ;
  LD (HL),$00             ; Set route index to zero (halt)
  INC HL                  ;
  INC HL                  ; Advance to the next character struct
  INC HL                  ;
  EX DE,HL                ; Swap
  LD A,C                  ; Get our loop counter
  CP $07                  ; Do seven iterations remain?
  JR NZ,reset_map_and_characters_5 ; Jump if not
  LD DE,$769F             ; Otherwise point DE at character_structs[20].room
reset_map_and_characters_5:
  DEC C                            ; ...loop
  JP NZ,reset_map_and_characters_3 ;
  RET                     ; Return
; Reset data for character_structs.
;
; struct { byte room; byte x; byte y; }; // partial of character_struct
character_reset_data:
  DEFB $03,$28,$3C        ; (room_3_HUT2RIGHT, 40,60) for character 12
  DEFB $03,$24,$30        ; (room_3_HUT2RIGHT, 36,48) for character 13
  DEFB $05,$28,$3C        ; (room_5_HUT3RIGHT, 40,60) for character 14
  DEFB $05,$24,$22        ; (room_5_HUT3RIGHT, 36,34) for character 15
  DEFB $FF,$34,$3C        ; (room_NONE,        52,60) for character 20
  DEFB $FF,$34,$2C        ; (room_NONE,        52,44) for character 21
  DEFB $FF,$34,$1C        ; (room_NONE,        52,28) for character 22
  DEFB $FF,$34,$3C        ; (room_NONE,        52,60) for character 23
  DEFB $FF,$34,$2C        ; (room_NONE,        52,44) for character 24
  DEFB $FF,$34,$1C        ; (room_NONE,        52,28) for character 25

; render_mask_buffer stuff.
mask_left_skip:
  DEFB $00
mask_top_skip:
  DEFB $00
mask_run_height:
  DEFB $00
mask_run_width:
  DEFB $00

; Check the mask buffer to see if the hero is hiding behind something.
;
; Used by the routine at plot_sprites.
;
; I:IY Pointer to visible character.
searchlight_mask_test:
  PUSH IY                 ; Copy the current visible character pointer into HL
  POP HL                  ;
  LD A,L                  ; Extract the visible character's offset
  AND A                   ; Is it zero?
  RET NZ                  ; Return if not - skip non-hero characters
; Start testing at approximately the middle of the character.
  LD HL,$8131             ; Point HL at mask_buffer ($8100) + $31
; Bug: This does a fused load of BC, but doesn't use C after. It's probably a leftover stride constant.
  LD BC,$0804             ; Set B for eight iterations
; Start loop
  XOR A                   ; Preload A with zero
searchlight_mask_test_0:
  CP (HL)                 ; Is the mask byte zero?
  JR NZ,still_in_searchlight ; Jump to still_in_searchlight if not
  INC L                   ; Advance HL to the next row (note cheap increment due to alignment)
  INC L                   ;
  INC L                   ;
  INC L                   ;
  DJNZ searchlight_mask_test_0 ; ...loop
; Otherwise the hero has escaped the searchlight, so decrement the counter.
  LD HL,searchlight_state ; Point HL at searchlight_state
  DEC (HL)                ; Decrement it
  LD A,$FF                ; Is it searchlight_STATE_SEARCHING?
  CP (HL)                 ;
  RET NZ                  ; Return if not
  CALL choose_game_window_attributes ; Choose game window attributes
  CALL set_game_window_attributes ; Set game window attributes
  RET                     ; Return
still_in_searchlight:
  LD HL,searchlight_state ; Set searchlight_state to searchlight_STATE_CAUGHT
  LD (HL),$1F             ;
  RET                     ; Return

; Plot vischars and items in order.
;
; Used by the routines at setup_movable_items and main_loop.
;
; Start (infinite) loop
;
; This can return a vischar OR an itemstruct, but not both.
plot_sprites:
  CALL locate_vischar_or_itemstruct ; Locates a vischar or item to plot
  RET NZ                  ; Return if nothing remains
  BIT 6,A                 ; Was an item returned?
  JR NZ,plot_item         ; Jump to item handling if so
plot_vischar:
  CALL setup_vischar_plotting ; Set up vischar plotting
  JR NZ,plot_sprites      ; If not visible (Z clear) ...loop
  CALL render_mask_buffer ; Render the mask buffer
  LD A,(searchlight_state) ; Fetch the searchlight state
  CP $FF                  ; Is it searchlight_STATE_SEARCHING? ($FF)
  CALL NZ,searchlight_mask_test ; If not: check the mask buffer to see if the hero is hiding behind something
  LD A,(IY+$1E)           ; How wide is the vischar? (3 => 16 wide, 4 => 24 wide)
  CP $03                  ; 16 wide?
  JR Z,plot_16_wide       ; Jump if so
plot_24_wide:
  CALL plot_masked_sprite_24px ; Call the sprite plotter for 24-pixel-wide sprites
  JR plot_sprites         ; ...loop
; It's odd to test for Z here since it's always set.
plot_16_wide:
  CALL Z,plot_masked_sprite_16px ; Call (if Z set) the sprite plotter for 16-pixel-wide sprites
  JR plot_sprites         ; ...loop
plot_item:
  CALL setup_item_plotting ; Set up item plotting
  JR NZ,plot_sprites      ; If not visible (Z clear) ...loop
  CALL render_mask_buffer ; Render the mask buffer
  CALL plot_masked_sprite_16px_x_is_zero ; Call the sprite plotter for 16-pixel-wide sprites
  JR plot_sprites         ; ...loop

; Finds the next vischar or item to draw.
;
; Used by the routine at plot_sprites.
;
; O:F Z set if a valid vischar or item was returned.
; O:A Returns (vischars_LENGTH - iters) if vischar, or ((item__LIMIT - iters) | (1 << 6)) if itemstruct.
; O:IY The vischar or itemstruct to plot.
; O:HL The vischar or itemstruct to plot.
locate_vischar_or_itemstruct:
  LD BC,$0000             ; BC and DE are previous_x and previous_y. Zero them both
  LD D,C                  ;
  LD E,C                  ;
  LD A,$FF                ; Load A with a 'nothing found' marker ($FF)
  EX AF,AF'               ; Bank it
  EXX                     ; Bank the previous_x/y registers
; Note that we maintain a previous_height but it's never usefully used.
  LD DE,$0000             ; Initialise the previous_height to zero
  LD BC,$0820             ; Set B for eight iterations and set C for a 32 byte stride simultaneously
  LD HL,$8007             ; Point HL at vischar 0's counter_and_flags
; Start loop
lvoi_loop:
  BIT 7,(HL)              ; Is counter_and_flags' vischar_TOUCH_ENTERED flag set?
  JR Z,lvoi_next          ; Jump to next iteration if not
  PUSH HL                 ; Preserve the vischar pointer
  PUSH BC                 ; Preserve the loop counter and stride
; Check the X axis
  LD A,$08                ; Point HL at vischar.mi.pos.x
  ADD A,L                 ;
  LD L,A                  ;
  LD C,(HL)               ; Load vischar.mi.pos.x into BC
  INC L                   ;
  LD B,(HL)               ;
  INC BC                  ; Add 4
  INC BC                  ;
  INC BC                  ;
  INC BC                  ;
  PUSH BC                 ; Stack it
  EXX                     ; Switch banks to get spare HL
  POP HL                  ; HL = vischar.mi.pos.x + 4
  SBC HL,BC               ; Subtract previous_x
  EXX                     ; Bank
  JR C,lvoi_pop_next      ; Jump if (vischar.mi.pos.x + 4) < previous_x?
; Check the Y axis
  INC L                   ; Load vischar.mi.pos.y into BC
  LD C,(HL)               ;
  INC L                   ;
  LD B,(HL)               ;
  INC BC                  ; Add 4
  INC BC                  ;
  INC BC                  ;
  INC BC                  ;
  PUSH BC                 ; Stack it
  EXX                     ; Switch banks to get spare HL
  POP HL                  ; HL = vischar.mi.pos.y + 4
  SBC HL,DE               ; Subtract previous_y
  EXX                     ; Bank
  JR C,lvoi_pop_next      ; Jump if (vischar.mi.pos.y + 4) < previous_y?
  INC L                   ; Point HL at vischar.mi.pos.height
; We compute a vischar index here but the outer code never usefully uses it.
  POP BC                  ; Fetch the loop counter from the stack
  PUSH BC                 ;
  LD A,$08                ; Compute the vischar index (8 - B)
  SUB B                   ;
  EX AF,AF'               ; Bank it for return value
  LD E,(HL)               ; previous_height = vischar.mi.pos.height
  INC L                   ;
  LD D,(HL)               ;
  PUSH HL                 ; Preserve the vischar pointer
  EXX                     ; Bank
  POP HL                  ; Restore vischar pointer to the other bank
  DEC L                   ; Point HL at vischar.mi.pos.y
  DEC L                   ;
  LD D,(HL)               ; previous_y = vischar.mi.pos.y
  DEC L                   ;
  LD E,(HL)               ;
  DEC L                   ;
  LD B,(HL)               ; previous_x = vischar.mi.pos.x
  DEC L                   ;
  LD C,(HL)               ;
  LD A,L                  ; Point HL at vischar
  SUB $0F                 ;
  LD L,A                  ;
  PUSH HL                 ; Set IY to HL
  POP IY                  ;
  EXX
lvoi_pop_next:
  POP BC                  ; Restore loop counter and stride
  POP HL                  ; Restore vischar pointer
lvoi_next:
  LD A,L                  ; Advance to the next vischar
  ADD A,C                 ;
  LD L,A                  ;
  DJNZ lvoi_loop          ; ...loop
  CALL get_greatest_itemstruct ; Iterate over all item_structs looking for nearby items
  EX AF,AF'               ; Get the old A back
; If the topmost bit of A' remains set from its initialisation at B8A1, then no vischar was found. It's preserved by the call to get_greatest_itemstruct.
  BIT 7,A                 ; Does bit 7 remain set from initialisation?
  RET NZ                  ; Return with Z clear if so: nothing was found
; Otherwise we've found a vischar
  PUSH IY                 ; Get vischar in HL
  POP HL                  ;
  BIT 6,A                 ; Is item_FOUND set? ($40)
  JR NZ,lvoi_item_found   ; Jump if so
  RES 7,(IY+$07)          ; Clear the vischar.counter_and_flags vischar_TOUCH_ENTERED flag
  RET                     ; Return with Z set
lvoi_item_found:
  INC HL                  ; Point HL at itemstruct.room_and_flags
  RES 6,(HL)              ; Clear itemstruct_ROOM_FLAG_NEARBY_6
  BIT 6,(HL)              ; Test the bit we've just cleared (odd!) - sets Z
  DEC HL                  ; Point HL back at the base of the itemstruct. (Note that DEC HL doesn't alter the Z flag)
  RET                     ; Return with Z set

; Render the mask buffer.
;
; The game uses a series of RLE encoded masks to characters to cut away pixels belonging to foreground objects. This ensures that characters aren't drawn atop of walls, huts and fences. This routine works out which masks intersect with the
; current player position then overlays them into the mask buffer at $8100.
;
; At 32x40 pixels the mask buffer is small: sized to fit a single character.
;
; Used by the routine at plot_sprites.
;
; Set all the bits in the mask buffer at $8100..$819F. A clear bit in this buffer means transparent; a set bit means opaque.
render_mask_buffer:
  LD HL,$8100             ; Point HL at the mask buffer
  LD (HL),$FF             ; Set its first byte to $FF
  LD DE,$8101             ; Do a rolling fill: copy the first byte to the second and so on until the buffer is filled
  LD BC,$009F             ;
  LDIR                    ;
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Are we outdoors?
  JR Z,rmb_outdoors       ; Jump if so
; We're indoors - use the interior mask structures.
rmb_indoors:
  LD HL,interior_mask_data ; Point HL at interior_mask_data_count
  LD A,(HL)               ; Fetch the count of interior masks
  AND A                   ; Is the count zero?
  RET Z                   ; Return if so - there are no masks to render
  LD B,A                  ; B is now our outermost loop counter
  INC HL                  ; Point HL at interior_mask_data[0] + 2 bytes (mask.bounds.x1)
  INC HL                  ;
  INC HL                  ;
  JR rmb_per_mask_loop    ;
; We're outdoors - use the exterior mask structures.
;
; Bug: The mask count of 59 here doesn't match the length of exterior_mask_data[] which is only 58 entries long.
rmb_outdoors:
  LD B,$3B                ; Set B for 59 iterations
  LD HL,$EC03             ; Point HL at exterior_mask_data[0] + 2 bytes (mask.bounds.x1)
; Fill the mask buffer with the union of all matching masks.
;
; Skip any masks which don't overlap the character. 'mask.bounds' is a bounding on the map image (in isometric projected map space). 'mask.pos' is a map coordinate (in map space). We use these to cull those masks which don't intersect with
; the character being rendered and those which are behind the character on the map.
;
; Start loop
rmb_per_mask_loop:
  PUSH BC                 ; Preserve the mask loop counter
  PUSH HL                 ; Preserve the mask data pointer
; X axis part.
  LD A,(iso_pos_x)        ; Compute iso_pos_x - 1
  DEC A                   ;
; Reject if the vischar's left edge is beyond the mask's right edge.
  CP (HL)                 ; Is (iso_pos_x - 1) >= mask.bounds.x1?
  JP NC,rmb_pop_next      ; Jump if so (process the next mask)
; Reject if the vischar's right edge is beyond the mask's left edge.
  ADD A,$04               ; Compute (iso_pos_x - 1) + 4
  DEC HL                  ; Point HL at mask.bounds.x0
  CP (HL)                 ; Is (iso_pos_x - 1) + 4 < mask.bounds.x0?
  JP C,rmb_pop_next       ; Jump if so (process the next mask)
; Y axis part.
  INC HL                  ; Point HL at mask.bounds.y1
  INC HL                  ;
  INC HL                  ;
  LD A,(iso_pos_y)        ; Compute iso_pos_y - 1
  DEC A                   ;
; Reject if the vischar's top edge is beyond the mask's bottom edge.
  CP (HL)                 ; Is (iso_pos_y - 1) >= mask.bounds.y1?
  JP NC,rmb_pop_next      ; Jump if so (process the next mask)
; Reject if the vischar's bottom edge is beyond the mask's top edge.
  ADD A,$05               ; Compute (iso_pos_y - 1) + 5
  DEC HL                  ; Point HL at mask.bounds.y0
  CP (HL)                 ; Is (iso_pos_y - 1) + 5 < mask.bounds.y0?
  JP C,rmb_pop_next       ; Jump if so (process the next mask)
; Skip masks which the character is in front of. A character is in front of a mask when either of its coordinates are less than mask.pos.
;
; tinypos_stash contains the vischar's mi.pos scaled as required.
;
; Reject if the character's X coordinate is not beyond mask.pos.x.
  INC HL                  ; Advance HL to mask.pos.x
  INC HL                  ;
  LD A,(tinypos_stash_x)  ; Fetch tinypos_stash_x
  CP (HL)                 ; Is tinypos_stash_x <= mask.pos.x?
  JP Z,rmb_pop_next       ; Jump if equal
  JP C,rmb_pop_next       ; Or jump if less than
; Reject if the character's Y coordinate is not beyond mask.pos.y.
  INC HL                  ; Advance HL to mask.pos.y
  LD A,(tinypos_stash_y)  ; Fetch tinypos_stash_y
  CP (HL)                 ; Is tinypos_stash_y < mask.pos.y?
  JP C,rmb_pop_next       ; Jump if so
; Reject if the character's height is beyond mask.pos.height.
  INC HL                  ; Advance HL to mask.pos.height
  LD A,(tinypos_stash_height) ; Fetch tinypos_stash_height
  AND A                     ; If tinypos_stash_height is non-zero: add one
  JR Z,render_mask_buffer_0 ;
  DEC A                     ;
render_mask_buffer_0:
  CP (HL)                 ; Is tinypos_stash_height >= mask.pos.height?
  JP NC,rmb_pop_next      ; Jump if so (process the next mask)
  LD A,L                     ; Step HL back to mask.bounds.x0
  SUB $06                    ;
  LD L,A                     ;
  JR NC,render_mask_buffer_1 ;
  DEC H                      ;
; The mask is valid: now calculate the clipped dimensions.
;
; X axis part.
render_mask_buffer_1:
  LD A,(iso_pos_x)        ; Fetch iso_pos_x
  LD C,A                  ; Copy it to C for use later
  CP (HL)                 ; Is iso_pos_x >= mask.bounds.x0?
  JP C,render_mask_buffer_3 ; Jump if so
; If we arrive here then mask.bounds.x0 is to the left of iso_pos_x. This means that the mask starts beyond the left edge of our render buffer.
;
; Set mask_left_skip to <left hand skip> and mask_run_width to <maximum width???>.
  SUB (HL)                ; Set left hand skip to (iso_pos_x - mask.bounds.x0)
  LD (mask_left_skip),A   ;
  INC HL                  ; Advance HL to mask.bounds.x1
  LD A,(HL)               ; Set run width to (mask.bounds.x1 - iso_pos_x)
  SUB C                   ;
  CP $03                    ; The run width must not exceed 4 (byte width of the render buffer)
  JR C,render_mask_buffer_2 ;
  LD A,$03                  ;
render_mask_buffer_2:
  INC A                     ;
  LD (mask_run_width),A   ; Store run width (how much of the mask to draw)
  JR render_mask_buffer_5 ; (else)
; If we arrive here then mask.bounds.x0 is to the right of iso_pos_x.
;
; Set mask_left_skip to zero and mask_run_width to <maximum width???>.
render_mask_buffer_3:
  LD B,(HL)               ; Fetch mask.bounds.x0
  XOR A                   ; Set left hand skip to zero
  LD (mask_left_skip),A   ;
  LD A,B                  ; Calculate maximum remaining space: (iso_pos_x + 4 - mask.bounds.x0)
  SUB C                   ;
  LD C,A                  ;
  LD A,$04                ;
  SUB C                   ;
  LD C,A                  ;
  INC HL                  ; Advance HL to mask.bounds.x1
  LD A,(HL)               ; Calculate total mask width: (mask.bounds.x1 - mask.bounds.x0) + 1
  SUB B                   ;
  INC A                   ;
  CP C                      ; Choose the minimum of the two possible run widths
  JR C,render_mask_buffer_4 ;
  LD A,C                    ;
render_mask_buffer_4:
  LD (mask_run_width),A   ; Store mask_run_width
; Y axis part.
render_mask_buffer_5:
  INC HL
  LD A,(iso_pos_y)        ; Fetch iso_pos_y
  LD C,A                  ; Copy it to C for use later
  CP (HL)                 ; Is iso_pos_y >= mask.bounds.y0?
  JP C,render_mask_buffer_7 ; Jump if so
; If we arrive here then mask.bounds.y0 is above iso_pos_y. This means that the mask starts beyond the top edge of our render buffer.
;
; Set mask_top_skip to <top skip> and mask_run_height to <maximum height???>.
  SUB (HL)                ; Set top skip to (iso_pos_y - mask.bounds.y0)
  LD (mask_top_skip),A    ;
  INC HL                  ; Advance HL to mask.bounds.y1
  LD A,(HL)               ; Set run height to (mask.bounds.y1 - iso_pos_y)
  SUB C                   ;
  CP $04                    ; The run height must not exceed 5 (UDG height of the render buffer)
  JR C,render_mask_buffer_6 ;
  LD A,$04                  ;
render_mask_buffer_6:
  INC A                     ;
  LD (mask_run_height),A  ; Store run height (how much of the mask to draw)
  JR render_mask_buffer_9 ; (else)
; If we arrive here then mask.bounds.y0 is below iso_pos_y.
;
; Set mask_top_skip to zero and mask_run_height to <maximum height???>.
render_mask_buffer_7:
  LD B,(HL)               ; Fetch mask.bounds.y0
  XOR A                   ; Set top skip to zero
  LD (mask_top_skip),A    ;
  LD A,B                  ; Calculate maximum remaining space: (iso_pos_y + 5 - mask.bounds.y0)
  SUB C                   ;
  LD C,A                  ;
  LD A,$05                ;
  SUB C                   ;
  LD C,A                  ;
  INC HL                  ; Advance HL to mask.bounds.y1
  LD A,(HL)               ; Calculate total mask height: (mask.bounds.y1 - mask.bounds.y0) + 1
  SUB B                   ;
  INC A                   ;
  CP C                      ; Choose the minimum of the two possible run heights
  JR C,render_mask_buffer_8 ;
  LD A,C                    ;
render_mask_buffer_8:
  LD (mask_run_height),A  ; Store mask_run_height
; Calculate the initial mask buffer pointer.
render_mask_buffer_9:
  DEC HL                  ; Step HL back to mask.bounds.y0
  LD BC,$0000             ; Initialise (x,y) vars to zero
; When the mask has a top or left hand gap, calculate that.
  LD A,(mask_top_skip)        ; If mask_top_skip is zero, calculate buf_top_skip = (mask.bounds.y0 - iso_pos_y)
  AND A                       ;
  JR NZ,render_mask_buffer_10 ;
  LD A,(iso_pos_y)            ;
  NEG                         ;
  ADD A,(HL)                  ;
  LD C,A                      ;
render_mask_buffer_10:
  DEC HL                  ; Step back to mask.bounds.x0
  DEC HL                  ;
  LD A,(mask_left_skip)       ; If mask_left_skip is zero, calculate buf_left_skip = (mask.bounds.x0 - iso_pos_x)
  AND A                       ;
  JR NZ,render_mask_buffer_11 ;
  LD A,(iso_pos_x)            ;
  NEG                         ;
  ADD A,(HL)                  ;
  LD B,A                      ;
render_mask_buffer_11:
  DEC HL                  ; Step back to mask.index
  LD A,(HL)               ; Load it
  EX AF,AF'               ; Bank it
; buf_top_skip is in C. buf_left_skip is in B. The multiplier 32 is MASK_BUFFER_ROWBYTES.
  LD A,C                  ; Calculate A = (buf_top_skip * 32 + buf_left_skip)
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,B                 ;
  LD HL,$8100             ; Add A to mask_buffer to get the mask buffer pointer
  ADD A,L                 ;
  LD L,A                  ;
  LD ($81A0),HL           ; Save the mask buffer pointer
  EX AF,AF'               ; Unbank index
  ADD A,A                 ; Point DE at mask_pointers[index]
  LD C,A                  ;
  LD B,$00                ;
  LD HL,mask_pointers     ;
  ADD HL,BC               ;
  LD E,(HL)               ;
  INC HL                  ;
  LD D,(HL)               ;
  LD HL,(mask_run_height) ; Load (L,H) with mask_run_height,mask_run_width
  LD A,L                  ; Self modify clip height loop
  LD ($BA70),A            ;
  LD A,H                  ; Self modify clip width loop
  LD ($BA72),A            ;
  LD A,(DE)               ; Self modify mask row skip = (mask width) - mask_run_width
  SUB H                   ;
  LD ($BA90),A            ;
  LD A,$20                ; Self modify buffer row skip = MASK_BUFFER_ROWBYTES - mask_run_width
  SUB H                   ;
  LD ($BABA),A            ;
; Skip the initial clipped mask bytes. The masks are RLE compressed so we can't jump directly to the first byte we need.
;
; First, calculate the total number of mask tiles to skip.
  PUSH DE                 ; Preserve mask data pointer
  LD A,(DE)               ; Fetch the mask's width
  LD E,A                  ;
  LD A,(mask_top_skip)    ; Fetch mask_top_skip
  CALL multiply           ; Multiply mask_top_skip by mask_width. Result is returned in HL. Note: D and B are zeroed
  LD A,(mask_left_skip)   ; Fetch mask_left_skip
  LD E,A                  ;
  ADD HL,DE               ; Add mask_left_skip to HL
  POP DE                  ; Restore mask data pointer
  INC HL                  ; + 1 [Explain]
; Next, loop until we've stepped over that number of mask tiles.
;
; Start loop
rmb_more_to_skip:
  LD A,(DE)               ; Read a byte. It could be a repeat count or a tile index
  AND A                   ; Is the MASK_RUN_FLAG set?
  JP P,rmb_skipping_index ; Jump if clear: it's a tile index (JP P => positive)
  AND $7F                 ; Otherwise mask it off, giving the repeat count
  INC DE                  ; Advance the mask data pointer (over the count)
  LD C,A                  ; Decrease mask_skip by repeat count (B is zeroed by multiply call above)
  SBC HL,BC               ;
  JR C,rmb_skip_went_negative ; Jump if it went negative
  INC DE                  ; Otherwise advance the mask data pointer (over the value) (doesn't affect flags)
  JR NZ,rmb_more_to_skip  ; ...loop while mask_skip > 0
  XOR A                   ; Otherwise mask_skip must be zero. Zero the counter
  JR rmb_start_drawing    ; Jump to rmb_start_drawing
rmb_skipping_index:
  INC DE                  ; Advance the mask data pointer
  DEC HL                  ; Decrement mask_skip
  LD A,L                  ; ...loop while mask_skip > 0
  OR H                    ;
  JP NZ,rmb_more_to_skip  ;
  JR rmb_start_drawing    ; Jump to rmb_start_drawing
rmb_skip_went_negative:
  LD A,L                  ; How far did we overshoot?
  NEG                     ; Negate it to create a positive mask emit(?) count
; A = Count of blocks to emit DE = Points to a value (if -ve case) .. but the upcoming code expects a flag byte...
rmb_start_drawing:
  LD HL,($81A0)           ; Get the mask buffer pointer
  LD C,$01                ; Set C for (self modified height) iterations
; Start loop
render_mask_buffer_12:
  LD B,$01                ; Set B for (self modified width) iterations
; Start loop
;
; DPT: The banking of A is hard to follow here. It's difficult to see if this section is entered with a skip value whether it will be handled correctly.
render_mask_buffer_13:
  EX AF,AF'               ; Bank the <repeat length>
  LD A,(DE)               ; Read a byte. It could be a repeat count or a tile index
  AND A                   ; Is the MASK_RUN_FLAG set?
  JP P,render_mask_buffer_14 ; Jump if clear: it's a tile index (JP P => positive)
  AND $7F                 ; Otherwise mask it off, giving the repeat count
  EX AF,AF'               ; Bank the repeat count; unbank the <repeat length>  REPLACING IT?
  INC DE                  ; Advance the mask data pointer
  LD A,(DE)               ; Read the next byte (a tile)
; Shortcut tile 0 which is blank.
render_mask_buffer_14:
  AND A                   ; Is it tile zero?
  CALL NZ,mask_against_tile ; Call mask_against_tile if not
  INC L                   ; Advance mask buffer pointer (a tile was written)
  EX AF,AF'               ; Unbank the repeat count OR <repeat length>  CONFUSING
; Advance the mask pointer when the repeat count reaches zero.
  AND A                   ; Is it zero?
  JR Z,render_mask_buffer_15 ; Jump if so
  DEC A                   ; Otherwise decrement the repeat count
  JR Z,render_mask_buffer_15 ; Jump if it hit zero
  DEC DE                  ; Otherwise undo the next instruction
render_mask_buffer_15:
  INC DE                  ; Advance the mask data pointer
  DJNZ render_mask_buffer_13 ; ...loop (width)
  PUSH BC                 ; Preserve the loop counter (B will be zero here, C = y)
  LD B,$01                ; Set B for (self modified, right hand skip) iterations
  EX AF,AF'               ; Bank the repeat count while we test B
  LD A,B                  ; Is the right hand skip zero?
  AND A                   ;
  JP Z,rmb_next_line      ; Jump if so (process next mask)
  EX AF,AF'               ; Unbank the repeat count
  AND A                   ; Is it zero?
  JR NZ,rmb_trailskip_dive_in ; Jump if not: (CHECK) must be continuing with a nonzero repeat count
; Start loop
rmb_trailskip_more_to_skip:
  LD A,(DE)               ; Read a byte. It could be a repeat count or a tile index
  AND A                   ; Is the MASK_RUN_FLAG set?
  JP P,rmb_something      ; Jump if clear: it's a tile index (JP P => positive)
; It's a repeat.
  AND $7F                 ; Otherwise mask it off, giving the repeat count
  INC DE                  ; Advance the mask data pointer
; (resume point)
rmb_trailskip_dive_in:
  LD C,A                  ; right_skip = A = (right_skip - A)
  LD A,B                  ;
  SUB C                   ;
  LD B,A                  ;
  JR C,rmb_trailskip_negative ; Jump if it went negative
  INC DE                  ; Advance the mask data pointer (doesn't affect flags)
  JR NZ,rmb_trailskip_more_to_skip ; if (right_skip > 0) goto START OF LOOP
  EX AF,AF'               ; bank // could jump $BAB8 instead
  JR rmb_next_line        ; Otherwise right_skip must be zero, jump to rmb_next_line
rmb_something:
  INC DE                  ; Advance the mask data pointer
  DJNZ rmb_trailskip_more_to_skip ; ...loop
  XOR A                   ; Reset counter (WHAT IS IT?)
  EX AF,AF'               ; bank // could jump $BAB8 instead
  JR rmb_next_line        ; Jump to rmb_next_line
rmb_trailskip_negative:
  NEG                     ; Negate it to create a positive mask emit(?) count
  EX AF,AF'               ; bank
rmb_next_line:
  LD A,$20                ; Advance HL by (self modified skip)
  ADD A,L                 ;
  LD L,A                  ;
  EX AF,AF'               ; Unbank the <repeat length> (re-banked when loop continues)
  POP BC                  ; Restore the height counter
  DEC C                       ; ...loop (height)
  JP NZ,render_mask_buffer_12 ;
rmb_pop_next:
  POP HL                  ; Restore the mask data pointer
  POP BC                  ; Restore the mask loop counter
  LD DE,$0008             ; Advance HL to the next mask_t
  ADD HL,DE               ;
  DEC B                   ; ...loop
  JP NZ,rmb_per_mask_loop ;
; Bug: The RET instruction is missing from the end of the routine. If unfixed the routine will harmlessly fall through into multiply.

; Multiply
;
; Multiplies the two 8-bit values in A and E returning a 16-bit result in HL.
;
; Used by the routine at render_mask_buffer.
;
; I:A Left hand value.
; I:E Right hand value.
; O:D Zero.
; O:HL Multiplied result.
multiply:
  LD B,$08                ; Set B for eight iterations (width of multiplicands)
  LD HL,$0000             ; Set our accumulator to zero
  LD D,H                  ; Zero D so that DE holds the full 16-bit right hand value
; Start loop
multiply_0:
  ADD HL,HL               ; Double our accumulator (shifting it left)
  RLA                     ; Shift A left. The shifted-out top bit becomes the carry flag
  JP NC,multiply_1        ; Jump if no carry
  ADD HL,DE               ; Otherwise HL += DE
multiply_1:
  DJNZ multiply_0         ; ...loop
  RET                     ; Return

; AND a tile in the mask buffer against the specified mask tile.
;
; Used by the routine at render_mask_buffer.
;
; I:A Mask tile index.
; I:HL Pointer to a tile in the mask buffer.
mask_against_tile:
  PUSH HL                 ; Save tile pointer
  EXX                     ; Switch register banks during the routine
; Point HL at mask_tiles[A]
  LD L,A                  ; Move the mask tile index into HL
  LD H,$00                ;
  ADD HL,HL               ; Multiply it by 8
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD BC,mask_tiles        ; Add base of mask_tiles array
  ADD HL,BC               ;
  POP DE                  ; Retrieve tile pointer
  LD B,$08                ; Set B for 8 iterations
; Start loop
mat_loop:
  LD A,(DE)               ; Fetch a byte of mask buffer
  AND (HL)                ; Mask it against a byte of mask tile
  LD (DE),A               ; Overwrite the input byte with result
  INC L                   ; Advance the mask tile pointer by a row
  INC E                   ; Advance the mask buffer pointer by a row
  INC E                   ;
  INC E                   ;
  INC E                   ;
  DJNZ mat_loop           ; ...loop
  EXX                     ; Switch register banks back
  RET                     ; Return

; Clip the given vischar's dimensions to the game window.
;
; Used by the routines at restore_tiles and setup_vischar_plotting.
;
; I:IY Pointer to visible character.
; O:A 0/255 => vischar visible/not visible.
; O:B Lefthand skip (bytes).
; O:C Clipped width (bytes).
; O:D Top skip (rows).
; O:E Clipped height (rows).
;
; To determine visibility and sort out clipping there are five cases to consider per axis: (A) the vischar is completely off the left/top of window, (B) the vischar is clipped on its left/top, (C) the vischar is entirely visible, (D) the
; vischar is clipped on its right/bottom, and (E) the vischar is completely off the right/bottom of window. Note that no vischar will ever be wider than the window so we never need to consider if clipping will occur on both sides.
;
; First handle the horizontal cases.
vischar_visible:
  LD HL,iso_pos_x         ; Point HL at iso_pos_x (vischar left edge)
; Calculate the right edge of the window in map space.
  LD A,(map_position)     ; Load map X position
  ADD A,$18               ; Add 24 (number of window columns)
; Subtract iso_pos_x giving the distance between the right edge of the window and the current vischar's left edge (in bytes).
  SUB (HL)                ; available_right = (map_position.x + 24) - vischar_left_edge
; Check for case (E): Vischar left edge beyond the window's right edge.
  JP Z,vv_not_visible     ; Jump to exit if zero (vischar left edge at right edge)
  JP C,vv_not_visible     ; Jump to exit if negative (vischar left edge beyond right edge)
; Check for case (D): Vischar extends outside the window.
  CP (IY+$1E)             ; Compare result to (sprite width bytes + 1)
  JP NC,vv_not_clipped_on_right_edge ; Jump if it fits
; Vischar's right edge is outside the window: clip its width.
  LD B,$00                ; No lefthand skip
  LD C,A                  ; Clipped width = available_right
  JR vv_height            ; Jump to height part
; Calculate the right edge of the vischar.
vv_not_clipped_on_right_edge:
  LD A,(HL)               ; Load iso_pos_x (vischar left edge)
  ADD A,(IY+$1E)          ; vischar_right_edge = iso_pos_x + (sprite width bytes + 1)
; Subtract the map position's X giving the distance between the current vischar's right edge and the left edge of the window (in bytes).
  LD HL,map_position      ; Load map X position
  SUB (HL)                ; available_left = vischar_right_edge - map_position.x
; Check for case (A): Vischar's right edge is beyond the window's left edge.
  JP Z,vv_not_visible     ; Jump to exit if zero (vischar right edge at left edge)
  JP C,vv_not_visible     ; Jump to exit if negative (vischar right edge beyond left edge)
; Check for case (B): Vischar's left edge is outside the window and its right edge is inside the window.
  CP (IY+$1E)             ; Compare result to (sprite width bytes + 1)
  JP NC,vv_not_clipped    ; Jump if it fits
; Vischar's left edge is outside the window: move the lefthand skip into B and the clipped width into C.
  LD C,A                  ; Clipped width = available_left
  NEG                     ; Lefthand skip = (sprite width bytes + 1) - available_left
  ADD A,(IY+$1E)          ;
  LD B,A                  ;
  JR vv_height            ; (else)
; Case (C): No clipping required.
vv_not_clipped:
  LD B,$00                ; No lefthand skip
  LD C,(IY+$1E)           ; Clipped width = (sprite width bytes + 1)
; Handle vertical cases.
;
; Note: This uses vischar.iso_pos, not state.iso_pos as above.
;
; Calculate the bottom edge of the window in map space.
vv_height:
  LD A,($81BC)            ; Load the map position's Y and add 17 (number of window rows)
  ADD A,$11               ;
  LD L,A                  ; Multiply it by 8
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
; Subtract vischar's Y giving the distance between the bottom edge of the window and the current vischar's top (in rows).
  LD E,(IY+$1A)           ; Load vischar.iso_pos.y (vischar top edge)
  LD D,(IY+$1B)           ;
  AND A                   ; Clear carry flag
  SBC HL,DE               ; available_bottom = window_bottom_edge * 8 - vischar->iso_pos.y
; Check for case (E): Vischar top edge beyond the window's bottom edge.
  JP Z,vv_not_visible     ; Jump to exit if zero (vischar top edge at bottom edge)
  JP C,vv_not_visible     ; Jump to exit if negative (vischar top edge beyond bottom edge)
  LD A,H                  ; Jump to exit if >= 256 (way out of range)
  AND A                   ;
  JP NZ,vv_not_visible    ;
; Check for case (D): Vischar extends outside the window.
  LD A,L                  ; A = available_bottom
  CP (IY+$1F)             ; Compare result to vischar.height
  JP NC,vv_not_clipped_on_top_edge ; Jump if it fits (available_top >= vischar.height)
; Vischar's bottom edge is outside the window: clip its height.
  LD E,A                  ; Clipped height = available_bottom
  LD D,$00                ; No top skip
  JR vv_visible           ; Jump to exit
; Calculate the bottom edge of the vischar.
vv_not_clipped_on_top_edge:
  LD L,(IY+$1F)           ; Load sprite height and widen
  LD H,$00                ;
  ADD HL,DE               ; vischar_bottom_edge = vischar.iso_pos.y + (sprite height)
; Subtract map position's Y (scaled) giving the distance between the current vischar's bottom edge and the top edge of the window (in rows).
  EX DE,HL                ; Bank
  LD A,($81BC)            ; Load the map position's Y and widen
  LD L,A                  ;
  LD H,$00                ;
  ADD HL,HL               ; Multiply by 8
  ADD HL,HL               ;
  ADD HL,HL               ;
  EX DE,HL                ; Unbank
  AND A                   ; Clear the carry flag
  SBC HL,DE               ; available_top = vischar_bottom_edge - map_pos_y * 8
; Check for case (A): Vischar's bottom edge is beyond the window's top edge.
  JP C,vv_not_visible     ; Jump to exit if negative (vischar bottom edge beyond top edge)
  JP Z,vv_not_visible     ; Jump to exit if zero (vischar bottom edge at top edge)
  LD A,H                  ; Jump to exit if >= 256 (way out of range)
  AND A                   ;
  JP NZ,vv_not_visible    ;
; Check for case (B): Vischar's top edge is outside the window and its bottom edge is inside the window.
  LD A,L                  ; A = available_top
  CP (IY+$1F)             ; Compare result to vischar.height
  JP NC,vischar_visible_0 ; Jump if it fits (available_top >= vischar.height)
; Vischar's top edge is outside the window: move the top skip into D and the clipped height into E.
  LD E,A                  ; Clipped height = available_top
  NEG                     ; Top skip = vischar.height - available_top
  ADD A,(IY+$1F)          ;
  LD D,A                  ;
  JR vv_visible           ; (else)
; Case (C): No clipping required.
vischar_visible_0:
  LD D,$00                ; No top skip
  LD E,(IY+$1F)           ; Clipped height = vischar.height
vv_visible:
  XOR A                   ; Set Z (vischar is visible)
  RET                     ; Return
vv_not_visible:
  LD A,$FF                ; Signal invisible
  AND A                   ; Clear Z (vischar is not visible)
  RET                     ; Return

; Paint any tiles occupied by visible characters with tiles from tile_buf.
;
; Used by the routine at main_loop.
restore_tiles:
  LD B,$08                ; Set B for eight iterations
  LD IY,$8000             ; Point IY at the first vischar
; Start loop (once per vischar)
rt_loop:
  PUSH BC                 ; Preserve the loop counter
  LD A,(IY+$01)           ; Read the vischar's flags byte
  CP $FF                  ; Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
  JP Z,rt_next_vischar    ; Jump to the next iteration if so
; Get the visible character's position in screen space.
;
; Compute iso_pos_y = vischar.iso_pos.y / 8.
  LD H,(IY+$1B)           ; Read vischar.iso_pos.y
  LD A,(IY+$1A)           ;
  SRL H                   ; Shift it right by three bits
  RRA                     ;
  SRL H                   ;
  RRA                     ;
  SRL H                   ;
  RRA                     ;
  LD (iso_pos_y),A        ; Store low byte
; Compute iso_pos_x = vischar.iso_pos.x / 8.
  LD H,(IY+$19)           ; Read vischar.iso_pos.x
  LD A,(IY+$18)           ;
  SRL H                   ; Shift it right by three bits
  RRA                     ;
  SRL H                   ;
  RRA                     ;
  SRL H                   ;
  RRA                     ;
  LD (iso_pos_x),A        ; Store low byte
; Clip.
  CALL vischar_visible    ; Clip the vischar's dimensions to the game window
  CP $FF                  ; Jump to next iteration if not visible ($FF)
  JP Z,rt_next_vischar    ;
; Compute scaled clipped height = (clipped height / 8) + 2
  LD A,E                  ; Copy clipped height
  RRA                     ; Shift it right by three bits
  RRA                     ;
  RRA                     ;
  AND $1F                 ; Mask away the rotated-out bits
  ADD A,$02               ; Add two
  PUSH AF                 ; Save the computed height
; DPT: It seems that the following chunk from $BBDC to $BC01 (the clamp-to-5) duplicates the work done by vischar_visible. I can't see any benefit to it.
;
; Compute bottom = height + iso_pos_y - map_position_y. This is the distance of the (clipped) bottom edge of the vischar from the top of the window.
  LD HL,iso_pos_y         ; Point HL at iso_pos_y
  ADD A,(HL)              ; Add iso_pos_y to height
  LD HL,$81BC             ; Point HL at map_position_y
  SUB (HL)                ; Subtract map_position_y from the total
  JR C,rt_visible         ; Jump if bottom is < 0 (the bottom edge is beyond the top edge of screen)
; Bottom edge is on-screen, or off the bottom of the screen.
  SUB $11                 ; Now reduce bottom by the height of the game window
  JR Z,rt_visible         ; Jump over if <= 17 (bottom edge off top of screen)
  JR C,rt_visible         ;
; Bottom edge is now definitely visible
  LD E,A                  ; Save new bottom
  POP AF                  ; Get computed height back
  SUB E                   ; Calculate visible height = computed height - bottom
  JP C,rt_next_vischar    ; If invisible (height < 0) goto next
  JR NZ,rt_clamp_height   ; Jump if visible (height > 0)
  JP rt_next_vischar      ; If invisible (height == 0) goto next
rt_visible:
  POP AF                  ; Restore computed height
; Clamp the height to a maximum of five.
rt_clamp_height:
  CP $05                  ; Compare height to 5
  JP Z,restore_tiles_0    ; Jump over if equal to 5
  JP C,restore_tiles_0    ; Jump over if less than 5
  LD A,$05                ; Otherwise set it to 5
; Self modify the loops' control instructions.
restore_tiles_0:
  LD ($BC5F),A            ; Self modify the outer loop counter (= height)
  LD A,C                  ; Copy (clipped) width to A
  LD ($BC61),A            ; Self modify the inner loop counter (= width)
  LD ($BC89),A            ; Self modify the "reset X" instruction (= width)
  LD A,$18                ; Compute tilebuf_skip = 24 - width (24 is window columns)
  SUB C                   ;
  LD ($BC8E),A            ; Self modify the "tilebuf row-to-row skip" instruction
  ADD A,$A8               ; Compute windowbuf_skip = (8 * 24) - width
  LD ($BC95),A            ; Self modify the "windowbuf row-to-row skip" instruction
; Work out x,y offsets into the tile buffer.
;
; X part
  LD HL,map_position      ; Point HL at map_position.x
  LD A,B                  ; Copy the lefthand skip into A
  AND A                   ; Is it zero?
  LD A,$00                ; Set X to zero (interleaved)
  JR NZ,restore_tiles_1   ; Jump if not
  LD A,(iso_pos_x)        ; Compute x = iso_pos_x - map_position.x
  SUB (HL)                ;
restore_tiles_1:
  LD B,A                  ;
; Y part
  LD A,D                  ; Copy top skip into A
  AND A                   ; Is it zero?
  LD A,$00                ; Set Y to zero (interleaved)
  JR NZ,restore_tiles_2   ; Jump if not
  INC HL                  ; Advance HL to map_position.y
  LD A,(iso_pos_y)        ; Compute y = iso_pos_y - map_position.y
  SUB (HL)                ;
restore_tiles_2:
  LD C,A                  ;
; Calculate the offset into the window buffer.
  LD H,C                  ; DE = y << 7 (== y * 128)
  XOR A                   ;
  SRL H                   ;
  RRA                     ;
  LD E,A                  ;
  LD D,H                  ;
  SRL H                   ; HL = y << 6 (== y * 64)
  RRA                     ;
  LD L,A                  ;
  ADD HL,DE               ; Sum DE and HL = y * 192 (== y * 24 * 8)
  LD E,B                  ; HL += x
  LD D,$00                ;
  ADD HL,DE               ;
  LD DE,$F290             ; Point DE at the window buffer's start address (windowbuf)
  ADD HL,DE               ; Add
  EX DE,HL                ; Swap the buffer offset into DE. HL is about to be overwritten
; Calculate the offset into the tile buffer.
;
; Compute pointer = C * 24 + A + $F0F8
  PUSH BC                 ; Stack the x and y values
  EXX                     ; Bank
  POP HL                  ; Restore into HL
  EXX                     ; Unbank
  LD A,B                  ; Copy x into A
  LD L,C                  ; HL = y
  LD H,$00                ;
  ADD HL,HL               ; Multiply it by 8
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD C,L                  ; Copy result to BC
  LD B,H                  ;
  ADD HL,HL               ; Double result
  ADD HL,BC               ; = y * 8 + y * 16
  LD C,A                  ; Copy x into BC
  LD B,$00                ;
  ADD HL,BC               ; = y * 24 + x
  LD BC,$F0F8             ; Point DE at the visible tiles array (tilebuf)
  ADD HL,BC               ; = $F0F8 + y * 24 + x
  EX DE,HL                ; Move tilebuf pointer into DE
; Loops start here.
  LD C,$05                ; Set C for <self modified by $BC5F> rows
; Start loop
rt_copy_row:
  LD B,$04                ; Set B for <self modified by $BC61> columns
; Start loop
rt_copy_column:
  PUSH HL                 ; Save windowbuf pointer
  LD A,(DE)               ; Read a tile from tilebuf
  EXX                     ; Bank
  POP DE                  ; Restore windowbuf pointer
  PUSH HL                 ; Save x,y
  CALL select_tile_set    ; Turn a map ref into a tile set pointer (in BC)
; Copy the tile into the window buffer.
;
; Compute the tile row pointer. (This is similar to 6B4F onwards).
  LD L,A                  ; Widen the tile index into HL
  LD H,$00                ;
  ADD HL,HL               ; Multiply by 8
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,BC               ; Add to tileset base address
  LD BC,$0818             ; Simultaneously set B for eight iterations and C for a 24 byte stride
; Start loop
rt_copy_tile:
  LD A,(HL)               ; Transfer a byte (a row) of tile across
  LD (DE),A               ;
  LD A,C                     ; Advance the screen buffer pointer by the stride
  ADD A,E                    ;
  JR NC,rt_copy_tile_nocarry ;
  INC D                      ;
rt_copy_tile_nocarry:
  LD E,A                     ;
  INC L                      ;
  DJNZ rt_copy_tile       ; ...loop for each byte of the tile
; Move to next column.
  POP HL                  ; Restore x,y
  INC H                   ; Increment X
  EXX                     ; Unbank
  INC DE                  ; Advance the tilebuf pointer
  INC HL                  ; Advance the windowbuf pointer
  DJNZ rt_copy_column     ; ...loop (width counter)
; Reset x offset. Advance to next row.
  EXX                     ; Bank
  LD A,H                  ; Get X
  SUB $00                 ; Reset X to initial value <self modified by $BC89>
  LD H,A                  ; Save X
  INC L                   ; Increment Y
  EXX                     ; Unbank
  LD A,$14                ; Get tilebuf row-to-row skip <self modified by $BC8E>
  ADD A,E                  ; Increment tilebuf pointer DE
  JR NC,rt_tilebuf_nocarry ;
  INC D                    ;
rt_tilebuf_nocarry:
  LD E,A                   ;
  LD A,$BC                ; Get windowbuf row-to-row skip <self modified by $BC95>
  ADD A,L                    ; Increment windowbuf pointer HL
  JR NC,rt_windowbuf_nocarry ;
  INC H                      ;
rt_windowbuf_nocarry:
  LD L,A                     ;
  DEC C                   ; ...loop
  JP NZ,rt_copy_row       ;
rt_next_vischar:
  POP BC                  ; Restore loop counter
  LD DE,$0020             ; Set DE to the vischar stride (32)
  ADD IY,DE               ; Advance IY to the next vischar
  DEC B                   ; ...loop
  JP NZ,rt_loop           ;
  RET                     ; Return

; Turn a map ref into a tile set pointer.
;
; Used by the routine at restore_tiles.
;
; I:H X shift.
; I:L Y shift.
; O:A Preserved.
; O:BC Pointer to tile set.
select_tile_set:
  EX AF,AF'               ; Preserve A during this routine
  LD A,(room_index)       ; Fetch the global current room index
  AND A                   ; Is it room_0_OUTDOORS?
  JR Z,sts_exterior       ; Jump if so
sts_interior:
  LD BC,interior_tiles    ; Otherwise point BC at interior_tiles[0]
  EX AF,AF'               ; Restore A
  RET                     ; Return
; Convert map position to an index into map_buf: a 7x5 array of supertile indices.
;
; Compute row offset
sts_exterior:
  LD A,($81BC)            ; Get the map position's Y component and isolate its low-order bits
  AND $03                 ;
  ADD A,L                 ; Add on the Y shift from L
  RRA                     ; Divide by two (rotate right by two then clear the rotated-out bits)
  RRA                     ;
  AND $3F                 ;
  LD L,A                  ; Multiply by 7 (columns per row of supertiles)
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  SUB L                   ;
  LD L,A                  ; Save for later
; Compute column offset
  LD A,(map_position)     ; Get the map position's X component and isolate its low-order bits
  AND $03                 ;
  ADD A,H                 ; Add on the X shift from H
  RRA                     ; Divide by two (rotate right by two then clear the rotated-out bits)
  RRA                     ;
  AND $3F                 ;
; Combine offsets
  ADD A,L                 ; Combine the row and column offsets
  LD HL,map_buf           ; Point HL at map_buf (a 7x5 cut-down copy of the main map which holds supertile indices)
  ADD A,L                 ; Add offset (quick version since the values can't overflow)
  LD L,A                  ;
  LD A,(HL)               ; Fetch the supertile index from map_buf
  LD BC,exterior_tiles    ; Point BC at exterior_tiles[0]
; Choose the tile index for the current supertile:
; +----------------------+------------------+
; | For supertile        | Use tile indices |
; +----------------------+------------------+
; | 44 and lower         | 0..249           |
; | 45..138 and 204..218 | 145..400         |
; | 139..203             | 365..570         |
; +----------------------+------------------+
  CP $2D                  ; Is the supertile index < 45?
  JR C,sts_exit           ; Jump if so
  LD BC,$8A18             ; Point BC at exterior_tiles[145]
  CP $8B                  ; Is the supertile index < 139?
  JR C,sts_exit           ; Jump if so
  CP $CC                  ; Is the supertile index >= 204?
  JR NC,sts_exit          ; Jump if so
  LD BC,$90F8             ; Point BC at exterior_tiles[145 + 220]
sts_exit:
  EX AF,AF'               ; Restore A
  RET                     ; Return

; Map super-tile refs. 54x34. Each byte represents a 32x32 tile.
;
; The map, with blanks and grass replaced to show the outline more clearly: 5F 33 3C 58 5F 33 34 2E 3D 45 3C 58 55 5E 31                         33 34 2B 37 2D 3F 28 48 42 5B 58 82 3E 30 2E 57             33 34 2E 37 2A 2F 2C 41 26 47 43 53
; 42 3C 57 75 76 81 5E 31 33 3C 5E 31 33 34 2B 35 2D 36 29 .. .. .. .. 49 44 54 43 3D 45 3C 58 75 76 7C 7F 80 3E 30 39 3D 3E 30 2E 35 2A 2F 38 .. .. .. .. .. .. .. .. 41 44 46 27 48 42 5B 58 75 76 7A 79 75 76 7C 7F 7E 3A 5D 40 31 3A 3F 40
; 31 2D 2F 29 .. .. .. .. .. .. .. .. .. .. .. .. 41 26 47 43 53 42 3C 58 6A 74 77 78 7B 7F 7E 3A 2F 2C 49 3B 32 2C 41 3B 32 38 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 49 44 54 43 3D 52 59 53 63 64 66 6F 7D 3A 2F 38 .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. 06 07 .. .. .. .. .. .. .. .. 41 44 46 51 5D 58 5A 53 65 62 6C 6D 36 2C .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 08 1A .. .. .. .. .. .. .. .. .. 41 44 5C 5B 57 58 5A 53 63 64
; 6B 6E 71 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. .. .. .. .. .. .. 59 53 45 3C 57 58 5A 61 62 5A 73 72 70 71 .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07
; .. .. .. .. .. .. 55 58 5A 53 45 3C 57 49 3B 68    5A 73 72 70 71 .. .. 75 76 7A 79 .. .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. .. .. .. .. 4B 45 3C 58 5A 53 45 45 .. .. 41 56 68    5A 73 72 70 71 6A 74 84 85 7A 79 ..
; 0D 0C 0B 17 20 16 15 18 .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. 4A 50 4C 52 5B 58 5A .. .. .. .. 49 56 68 69 5A 73 72 63 86 88 74 77 78 .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07 49 44 4D 51 4C 52 3C 58 .. ..
; .. .. .. .. 49 67 68 69 5A 65 87 83 64 66 6F .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. 41 44 4E 51 4C 45 3C 58 .. .. .. .. .. .. .. .. 41 67 68 59 CC CD 62 8A 6D .. .. .. .. .. .. .. 0D 0C 0B 17 20 16 15
; 18 .. .. 02 03 04 05 09 1C 1B .. .. .. 49 44 4E 28 4C 52 5B 58 .. .. .. .. .. .. .. .. .. .. 41 89 CE CF D2 D5 6F .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. B9 BA .. 49 26 C8 C9 4C 45 3C 58 .. .. .. ..
; .. .. .. B9 BA B1 B1 49 D0 D1 D3 D6 D8 9B 9C .. .. .. .. .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. BB BC BD BE 9D 97 CA CB 4D 28 4C 45 .. .. .. .. .. .. BB BC BD BE AF B2 B7 93 D4 D7 D9 8E 90 9B 9C .. .. .. .. .. .. .. ..
; .. 0D 0C 0B 17 20 16 15 18 .. .. .. .. .. C5 C0 97 96 93 95 94 41 26 C8 C9 .. .. .. .. .. B1 B1 C5 C0 97 96 B3 B5 B6 '' '' 8C 8D 8B 8E 90 9B 9C .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. .. .. .. 9C 9D C6 C2 93 95 94 '' 99 98 97 CA CB
; .. .. .. B1 B1 B0 AF C6 C2 93 95 B4 8B 8E 90 8F '' '' 8C 8D 8B 8E A8 AA 9C .. .. .. .. .. 10 11 13 18 .. .. .. .. .. 9C 9D 97 96 C7 C4 94 '' 99 98 97 96 93 95 94 .. .. B1 B0 AF 97 96 C7 C4 94 '' B8 8C 8D 8B 8E 90 8F '' '' 8C 8D A7 A6 90
; 9B 9C .. .. .. .. .. .. .. .. .. .. 9C 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. B0 B2 B7 93 95 94 '' '' '' '' '' '' 8C 8D 8B 8E A8 A9 '' '' A5 A4 8B 8E 90 9B 9C .. .. B9 BA .. .. 9C 9D 97 96 93 95 94 B8 99 98 97 96 93 95 94
; .. .. .. .. .. .. B0 B3 B5 B6 '' '' '' '' '' '' '' '' '' '' 8C 8D A7 A6 90 8F '' '' 8C 8D 8B 8E 90 9B BB BC BD BE 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. B1 B4 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' A5 A4 8B
; 8E 90 8F '' '' 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' 8C 8D AB AC 90 8F '' '' 8C 8D 8B C1 C2 93 95 94 '' 99 98 97 96 93 95 94 .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' B9 BA '' '' 99 98 97 AD AE 8B 8E 90 8F '' '' 8C C3 C4 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 8F BB BC BD
; BE 98 97 96 93 95 94 8C 8D 8B 8E 90 8F '' '' '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 .. .. .. .. 8C 8D 8B 8E 90 A2 A3 97 96 93 95 94 .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B C1 C2 93 95 94 .. .. .. .. .. .. .. .. 8C 8D 8B A0 A1 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. 8C C3 C4 94 .. .. .. .. .. .. .. .. .. .. .. .. 8C 9F 9E 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
; .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
map_tiles:
  DEFB $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$5F,$33,$3C,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$5F,$33,$34,$2E,$3D,$45,$3C,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$55,$5E,$31,$60,$60,$60,$60,$60,$60,$60,$60,$33,$34,$2B,$37,$2D,$3F,$28,$48,$42,$5B,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$82,$3E,$30,$2E,$57,$60,$60,$60,$60,$33,$34,$2E,$37,$2A,$2F,$2C,$41,$26,$47,$43,$53,$42,$3C,$57,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $60,$60,$60,$60,$60,$60,$60,$60,$75,$76,$81,$5E,$31,$33,$3C,$5E,$31,$33,$34,$2B,$35,$2D,$36,$29,$25,$24,$23,$25,$49,$44,$54,$43,$3D,$45,$3C,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $60,$60,$60,$60,$60,$60,$75,$76,$7C,$7F,$80,$3E,$30,$39,$3D,$3E,$30,$2E,$35,$2A,$2F,$38,$24,$25,$23,$23,$24,$25,$25,$23,$41,$44,$46,$27,$48,$42,$5B,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $75,$76,$7A,$79,$75,$76,$7C,$7F,$7E,$3A,$5D,$40,$31,$3A,$3F,$40,$31,$2D,$2F,$29,$23,$25,$23,$24,$23,$25,$24,$23,$25,$24,$24,$23,$41,$26,$47,$43,$53,$42,$3C,$58,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $6A,$74,$77,$78,$7B,$7F,$7E,$3A,$2F,$2C,$49,$3B,$32,$2C,$41,$3B,$32,$38,$25,$23,$24,$24,$25,$25,$24,$23,$23,$25,$24,$23,$23,$25,$23,$24,$49,$44,$54,$43,$3D,$52,$59,$53,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $63,$64,$66,$6F,$7D,$3A,$2F,$38,$25,$24,$23,$23,$24,$25,$23,$25,$24,$24,$23,$25,$23,$25,$24,$24,$23,$25,$06,$07,$23,$25,$24,$25,$24,$23,$25,$23,$41,$44,$46,$51,$5D,$58,$5A,$53,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $65,$62,$6C,$6D,$36,$2C,$23,$24,$23,$25,$24,$25,$23,$24,$24,$23,$23,$25,$23,$24,$23,$25,$23,$23,$02,$03,$04,$08,$1A,$23,$25,$24,$25,$24,$23,$25,$24,$23,$41,$44,$5C,$5B,$57,$58,$5A,$53,$60,$60,$60,$60,$60,$60,$60,$60
  DEFB $63,$64,$6B,$6E,$71,$24,$23,$23,$24,$23,$24,$24,$23,$25,$24,$23,$25,$25,$24,$23,$24,$23,$02,$03,$04,$05,$09,$1C,$1B,$25,$23,$23,$24,$25,$24,$23,$25,$25,$23,$24,$59,$53,$45,$3C,$57,$58,$5A,$60,$60,$60,$60,$60,$60,$60
  DEFB $61,$62,$5A,$73,$72,$70,$71,$24,$23,$25,$23,$25,$24,$23,$25,$25,$24,$23,$23,$24,$02,$03,$14,$05,$0A,$17,$1E,$1D,$25,$23,$24,$24,$06,$07,$23,$25,$23,$24,$23,$25,$55,$58,$5A,$53,$45,$3C,$57,$60,$60,$60,$60,$60,$60,$60
  DEFB $49,$3B,$68,$60,$5A,$73,$72,$70,$71,$23,$24,$75,$76,$7A,$79,$24,$23,$25,$00,$01,$04,$05,$0A,$21,$22,$16,$1F,$19,$24,$24,$02,$03,$04,$08,$1A,$23,$24,$25,$25,$24,$4B,$45,$3C,$58,$5A,$53,$45,$45,$60,$60,$60,$60,$60,$60
  DEFB $24,$25,$41,$56,$68,$60,$5A,$73,$72,$70,$71,$6A,$74,$84,$85,$7A,$79,$23,$0D,$0C,$0B,$17,$20,$16,$15,$18,$24,$23,$02,$03,$04,$05,$09,$1C,$1B,$24,$23,$24,$23,$23,$4A,$50,$4C,$52,$5B,$58,$5A,$60,$60,$60,$60,$60,$60,$60
  DEFB $23,$24,$25,$23,$49,$56,$68,$69,$5A,$73,$72,$63,$86,$88,$74,$77,$78,$25,$0E,$0F,$12,$16,$15,$18,$24,$23,$02,$03,$14,$05,$0A,$17,$1E,$1D,$25,$25,$24,$23,$06,$07,$49,$44,$4D,$51,$4C,$52,$3C,$58,$60,$60,$60,$60,$60,$60
  DEFB $25,$23,$24,$25,$24,$23,$49,$67,$68,$69,$5A,$65,$87,$83,$64,$66,$6F,$24,$10,$11,$13,$18,$23,$25,$00,$01,$04,$05,$0A,$21,$22,$16,$1F,$19,$24,$23,$02,$03,$04,$08,$1A,$25,$41,$44,$4E,$51,$4C,$45,$3C,$58,$60,$60,$60,$60
  DEFB $23,$24,$25,$23,$25,$24,$25,$23,$41,$67,$68,$59,$CC,$CD,$62,$8A,$6D,$23,$25,$23,$23,$24,$23,$24,$0D,$0C,$0B,$17,$20,$16,$15,$18,$25,$23,$02,$03,$04,$05,$09,$1C,$1B,$24,$25,$23,$49,$44,$4E,$28,$4C,$52,$5B,$58,$60,$60
  DEFB $24,$25,$23,$25,$24,$23,$24,$24,$25,$23,$41,$89,$CE,$CF,$D2,$D5,$6F,$24,$23,$25,$24,$23,$25,$23,$0E,$0F,$12,$16,$15,$18,$25,$23,$02,$03,$14,$05,$0A,$17,$1E,$1D,$23,$23,$24,$B9,$BA,$25,$49,$26,$C8,$C9,$4C,$45,$3C,$58
  DEFB $23,$24,$25,$24,$23,$23,$25,$B9,$BA,$B1,$B1,$49,$D0,$D1,$D3,$D6,$D8,$9B,$9C,$24,$23,$25,$24,$23,$10,$11,$13,$18,$24,$23,$00,$01,$04,$05,$0A,$21,$22,$16,$1F,$19,$23,$25,$BB,$BC,$BD,$BE,$9D,$97,$CA,$CB,$4D,$28,$4C,$45
  DEFB $25,$23,$24,$23,$25,$24,$BB,$BC,$BD,$BE,$AF,$B2,$B7,$93,$D4,$D7,$D9,$8E,$90,$9B,$9C,$23,$23,$25,$24,$25,$23,$25,$25,$24,$0D,$0C,$0B,$17,$20,$16,$15,$18,$23,$25,$25,$24,$24,$C5,$C0,$97,$96,$93,$95,$94,$41,$26,$C8,$C9
  DEFB $23,$25,$25,$24,$23,$B1,$B1,$C5,$C0,$97,$96,$B3,$B5,$B6,$91,$92,$8C,$8D,$8B,$8E,$90,$9B,$9C,$24,$25,$24,$24,$23,$23,$23,$0E,$0F,$12,$16,$15,$18,$24,$23,$25,$24,$23,$9C,$9D,$C6,$C2,$93,$95,$94,$91,$99,$98,$97,$CA,$CB
  DEFB $25,$24,$23,$B1,$B1,$B0,$AF,$C6,$C2,$93,$95,$B4,$8B,$8E,$90,$8F,$91,$92,$8C,$8D,$8B,$8E,$A8,$AA,$9C,$25,$23,$25,$25,$24,$10,$11,$13,$18,$25,$24,$23,$24,$23,$9C,$9D,$97,$96,$C7,$C4,$94,$92,$99,$98,$97,$96,$93,$95,$94
  DEFB $23,$25,$B1,$B0,$AF,$97,$96,$C7,$C4,$94,$91,$B8,$8C,$8D,$8B,$8E,$90,$8F,$91,$92,$8C,$8D,$A7,$A6,$90,$9B,$9C,$24,$24,$23,$24,$25,$24,$23,$24,$25,$23,$9C,$9D,$97,$96,$93,$95,$94,$91,$99,$98,$97,$96,$93,$95,$94,$23,$24
  DEFB $24,$24,$B0,$B2,$B7,$93,$95,$94,$92,$91,$92,$91,$92,$91,$8C,$8D,$8B,$8E,$A8,$A9,$91,$92,$A5,$A4,$8B,$8E,$90,$9B,$9C,$25,$23,$B9,$BA,$25,$23,$9C,$9D,$97,$96,$93,$95,$94,$B8,$99,$98,$97,$96,$93,$95,$94,$24,$25,$24,$23
  DEFB $25,$23,$B0,$B3,$B5,$B6,$91,$92,$91,$92,$91,$92,$91,$92,$91,$92,$8C,$8D,$A7,$A6,$90,$8F,$91,$92,$8C,$8D,$8B,$8E,$90,$9B,$BB,$BC,$BD,$BE,$9D,$97,$96,$93,$95,$94,$91,$99,$98,$97,$96,$93,$95,$94,$23,$25,$23,$24,$25,$23
  DEFB $24,$25,$B1,$B4,$8B,$8E,$90,$8F,$91,$91,$92,$91,$92,$91,$92,$91,$92,$91,$A5,$A4,$8B,$8E,$90,$8F,$91,$92,$8C,$8D,$8B,$8E,$90,$BF,$C0,$97,$96,$93,$95,$94,$92,$99,$98,$97,$96,$93,$95,$94,$25,$23,$24,$23,$24,$25,$23,$25
  DEFB $23,$24,$25,$24,$8C,$8D,$8B,$8E,$90,$8F,$91,$92,$91,$92,$91,$92,$91,$92,$91,$92,$8C,$8D,$AB,$AC,$90,$8F,$91,$92,$8C,$8D,$8B,$C1,$C2,$93,$95,$94,$91,$99,$98,$97,$96,$93,$95,$94,$25,$24,$23,$24,$23,$25,$25,$24,$25,$23
  DEFB $25,$25,$24,$23,$25,$24,$8C,$8D,$8B,$8E,$90,$8F,$91,$91,$92,$B9,$BA,$91,$92,$99,$98,$97,$AD,$AE,$8B,$8E,$90,$8F,$91,$92,$8C,$C3,$C4,$94,$92,$99,$98,$97,$96,$93,$95,$94,$25,$23,$24,$23,$25,$23,$24,$24,$23,$25,$24,$25
  DEFB $24,$23,$25,$24,$23,$25,$25,$23,$8C,$8D,$8B,$8E,$90,$8F,$BB,$BC,$BD,$BE,$98,$97,$96,$93,$95,$94,$8C,$8D,$8B,$8E,$90,$8F,$91,$92,$91,$99,$98,$97,$96,$93,$95,$94,$23,$25,$24,$24,$23,$25,$24,$25,$23,$23,$25,$23,$24,$24
  DEFB $23,$25,$24,$23,$25,$23,$24,$25,$24,$23,$8C,$8D,$8B,$8E,$90,$BF,$C0,$97,$96,$93,$95,$94,$25,$23,$24,$23,$8C,$8D,$8B,$8E,$90,$A2,$A3,$97,$96,$93,$95,$94,$25,$24,$23,$24,$23,$24,$24,$23,$25,$24,$24,$25,$24,$25,$23,$23
  DEFB $25,$23,$24,$25,$24,$23,$25,$23,$25,$24,$25,$23,$8C,$8D,$8B,$C1,$C2,$93,$95,$94,$25,$24,$23,$23,$25,$25,$24,$23,$8C,$8D,$8B,$A0,$A1,$93,$95,$94,$25,$23,$25,$23,$24,$23,$25,$23,$25,$24,$24,$25,$23,$23,$25,$23,$24,$25
  DEFB $25,$25,$23,$24,$23,$24,$23,$25,$24,$23,$24,$25,$24,$25,$8C,$C3,$C4,$94,$23,$24,$23,$25,$24,$25,$24,$25,$23,$24,$25,$23,$8C,$9F,$9E,$94,$25,$25,$23,$24,$23,$25,$23,$24,$25,$23,$24,$23,$25,$24,$23,$24,$23,$24,$23,$23
  DEFB $23,$24,$25,$23,$25,$24,$25,$23,$23,$25,$23,$24,$23,$24,$23,$25,$23,$24,$25,$23,$24,$23,$24,$24,$23,$24,$25,$24,$23,$25,$24,$25,$23,$24,$23,$24,$24,$25,$24,$23,$25,$23,$24,$25,$24,$25,$23,$25,$24,$25,$25,$23,$25,$23
  DEFB $23,$24,$25,$23,$25,$24,$25,$23,$23,$25,$23,$24,$23,$24,$23,$25,$23,$24,$25,$23,$24,$23,$24,$24,$23,$24,$25,$24,$23,$25,$24,$25,$23,$24,$23,$24,$24,$25,$24,$23,$25,$23,$24,$25,$24,$25,$23,$25,$24,$25,$25,$23,$25,$23

; Pointer to bytes to output as pseudo-random data.
;
; Initially set to $9000. Wraps around after $90FF.
prng_pointer:
  DEFW $9000

; Spawn characters.
;
; Used by the routines at setup_movable_items and main_loop.
;
; Form a clamped map position in DE.
spawn_characters:
  LD HL,(map_position)    ; Read the current map position into HL
  LD A,L                  ; Get map_position.x
  SUB $08                 ; Subtract 8
  JR NC,spawn_characters_0 ; Jump if it was >= 8
  XOR A                   ; Otherwise zero it
spawn_characters_0:
  LD E,A                  ; E is the result: map_x_clamped
  LD A,H                  ; Get map_position.y
  SUB $08                 ; Subtract 8
  JR NC,spawn_characters_1 ; Jump if it was >= 8
  XOR A                   ; Otherwise zero it
spawn_characters_1:
  LD D,A                  ; D is the result: map_y_clamped
; Walk all character structs.
  LD HL,character_structs ; Point HL at character_structs[0] (charstr)
  LD B,$1A                ; Set B for 26 iterations (26 characters)
; Start loop
sc_loop:
  BIT 6,(HL)              ; Fetch flags and test for characterstruct_FLAG_ON_SCREEN
  JR NZ,sc_next           ; Jump if already on-screen
; Is this character in the current room?
  PUSH HL                 ; Preserve the character struct pointer
  INC HL                  ; Point HL at charstr.room
  LD A,(room_index)       ; Get the global current room index
  CP (HL)                 ; Same room?
  JR NZ,sc_unstash_next   ; Jump if not
  AND A                   ; Outdoors?
  JR NZ,sc_indoors        ; Jump if not
; Handle outdoors.
  INC HL                  ; Point HL at charstr.pos.x
; Do screen Y calculation: y = ((256 - charstr.pos.x) - charstr.pos.y) - charstr.pos.height
;
; A is zero here, and represents 0x100.
  SUB (HL)                ; Subtract charstr.pos.x
  INC HL                  ; Advance HL to charstr.pos.y
  SUB (HL)                ; Subtract charstr.pos.y
  INC HL                  ; Advance HL to charstr.pos.height
  SUB (HL)                ; Subtract charstr.pos.height
  LD C,A                  ; Copy y to C
  LD A,D                  ; Copy map_y_clamped to D
  CP C                    ; Is map_y_clamped >= y?
  JR NC,sc_unstash_next   ; Jump if so
  ADD A,$20               ; Add 16 + 2 * 8 (16 => screen height, 8 => spawn zone size)
  JR NC,spawn_characters_2 ; Clamp to a maximum of 255
  LD A,$FF                 ;
spawn_characters_2:
  CP C                    ; Is y > (map_y_clamped + spawn size, clamped to 255)?
  JR C,sc_unstash_next    ; Jump if so
; Do screen X calculation: x = (64 - charstr.pos.x + charstr.pos.y) * 2
  DEC HL                  ; Step HL back to charstr.pos.y
  LD A,$40                ; Start with x = 64
  ADD A,(HL)              ; Add charstr.pos.y
  DEC HL                  ; Step HL back to charstr.pos.x
  SUB (HL)                ; Subtract charstr.pos.x
  ADD A,A                 ; Double it
  LD C,A                  ; Copy x to C
  LD A,E                  ; Copy map_x_clamped to E
  CP C                    ; Is map_x_clamped >= x?
  JR NC,sc_unstash_next   ; Jump if so
  ADD A,$28               ; Add 24 + 2 * 8 (24 => screen width, 8 => spawn zone size)
  JR NC,spawn_characters_3 ; Clamp to a maximum of 255
  LD A,$FF                 ;
spawn_characters_3:
  CP C                    ; Is x > (map_x_clamped + spawn size, clamped to 255)?
  JR C,sc_unstash_next    ; Jump if so
sc_indoors:
  POP HL                  ; Restore the character struct pointer (spawn_character arg)
  PUSH HL                 ; Preserve the character struct pointer over the call
  PUSH DE                 ; Preserve map_x/y_clamped
  PUSH BC                 ; Preserve the loop counter
  CALL spawn_character    ; Add characters to the visible character list
  POP BC                  ; Restore the loop counter
  POP DE                  ; Restore map_x/y_clamped
sc_unstash_next:
  POP HL                  ; Restore the character struct pointer
sc_next:
  LD A,L                   ; Advance to the next characterstruct
  ADD A,$07                ;
  LD L,A                   ;
  JR NC,spawn_characters_4 ;
  INC H                    ;
spawn_characters_4:
  DJNZ sc_loop            ; ...loop
  RET                     ; Return

; Remove any off-screen non-player characters.
;
; This is the opposite of spawn_characters.
;
; Used by the routine at main_loop.
purge_invisible_characters:
  LD HL,(map_position)    ; Read the current map position into HL
; Calculate clamped lower bound.
;
; 9 is the size, in UDGs, of a buffer zone around the visible screen in which visible characters will persist. (Compare to the spawning size of 8).
  LD A,L                  ; Get map_position.x
  SUB $09                 ; Subtract 9
  JR NC,purge_invisible_characters_0 ; Jump if it was >= 9
  XOR A                   ; Otherwise zero it
purge_invisible_characters_0:
  LD E,A                  ; E is the result: minx
  LD A,H                  ; Get map_position.y
  SUB $09                 ; Subtract 9
  JR NC,purge_invisible_characters_1 ; Jump if it was >= 9
  XOR A                   ; Otherwise zero it
purge_invisible_characters_1:
  LD D,A                  ; D is the result: miny
; Iterate over non-player characters.
  LD B,$07                ; Set B for seven iterations
  LD HL,$8020             ; Point HL at the second visible character
; Start loop
;
; Ignore inactive characters.
pic_loop:
  LD A,(HL)               ; Fetch the vischar's character index
  CP $FF                  ; Is it character_NONE?
  JP Z,pic_next           ; Jump to the next vischar if so
  PUSH HL                 ; Preserve the vischar pointer
; Reset this character if it's not in the current room.
  LD A,$1C                ; Point HL at vischar.room
  ADD A,L                 ;
  LD L,A                  ;
  LD A,(room_index)       ; Get the global current room index
  CP (HL)                 ; Is the vischar in the current room?
  JR NZ,pic_reset         ; Jump to reset if not
; Handle Y part
  DEC L                   ; Load vischar.iso_pos.y into (C,A)
  LD C,(HL)               ;
  DEC L                   ;
  LD A,(HL)               ;
  CALL divide_by_8_with_rounding ; Divide (C,A) by 8 with rounding. Result is in A
  LD C,A                  ; Copy result C
  LD A,D                  ; Copy miny to A
  CP C                    ; Is miny >= result?
  JR NC,pic_reset         ; Jump to reset if so (out of bounds)
; DPT: 16 is used for screen height here, but 24 is used for width below - so that doesn't line up with the actual values which are 24x17.
  ADD A,$22               ; Add 16 + 2 * 9 (16 => screen height, 9 => buffer zone size)
  JR NC,purge_invisible_characters_2 ; Clamp to a maximum of 255
  LD A,$FF                           ;
purge_invisible_characters_2:
  CP C                    ; Is result > (miny + buffer size, clamped to 255)?
  JR C,pic_reset          ; Jump to reset if so (out of bounds)
; Handle X part
  DEC L                   ; Load vischar.iso_pos.x into (C,A)
  LD C,(HL)               ;
  DEC L                   ;
  LD A,(HL)               ;
  CALL divide_by_8        ; Divide (C,A) by 8 (with no rounding). Result is in A
  LD C,A                  ; Copy result C
  LD A,E                  ; Copy minx to A
  CP C                    ; Is minx >= result?
  JR NC,pic_reset         ; Jump to reset if so (out of bounds)
  ADD A,$2A               ; Add 24 + 2 * 9 (24 => screen width, 9 => buffer zone size)
  JR NC,purge_invisible_characters_3 ; Clamp to a maximum of 255
  LD A,$FF                           ;
purge_invisible_characters_3:
  CP C                    ; Is result > (minx + buffer size, clamped to 255)?
  JR NC,pic_pop_next      ; Jump to reset if so (out of bounds)
pic_reset:
  POP HL                  ; Restore the vischar pointer (reset_visible_character arg)
  PUSH HL                 ; Preserve the vischar pointer over the call
  PUSH DE                 ; Preserve minx/miny
  PUSH BC                 ; Preserve the loop counter
  CALL reset_visible_character ; Reset the visible character
  POP BC                  ; Restore the loop counter
  POP DE                  ; Restore minx/miny
pic_pop_next:
  POP HL                  ; Restore the vischar pointer
pic_next:
  LD A,$20                ; Advance to the next vischar
  ADD A,L                 ;
  LD L,A                  ;
  DJNZ pic_loop           ; ...loop
  RET                     ; Return

; Add a character to the visible character list.
;
; Used by the routine at spawn_characters.
;
; I:HL Pointer to character to spawn.
spawn_character:
  BIT 6,(HL)              ; Is the character already on-screen? (test flag characterstruct_FLAG_ON_SCREEN)
  RET NZ                  ; Return if so
  PUSH HL                 ; Preserve the character pointer
; Find an empty slot in the visible character list.
;
; Iterate over non-player characters.
  LD HL,$8020             ; Point HL at the second visible character
  LD DE,$0020             ; Prepare the vischar stride
  LD A,$FF                ; Prepare vischar_CHARACTER_EMPTY_SLOT
  LD B,$07                ; Set B for seven iterations (seven non-player vischars)
; Start loop
spawn_find_slot:
  CP (HL)                 ; Empty slot?
  JR Z,spawn_found_slot   ; Jump if so
  ADD HL,DE               ; Advance to the next vischar
  DJNZ spawn_find_slot    ; ...loop
spawn_no_spare_slot:
  POP HL                  ; Restore the character pointer
  RET                     ; Return
; Found an empty slot.
spawn_found_slot:
  POP DE                  ; Restore the character pointer to DE
  PUSH HL                 ; Point IY at the empty vischar slot
  POP IY                  ;
  PUSH HL                 ; Preserve the empty vischar slot pointer
  PUSH DE                 ; Preserve the character pointer
  INC DE                  ; Advance DE to point at charstr.room
; Scale coords dependent on which room the character is in.
  LD HL,saved_pos_x       ; Point HL at saved_pos_x
  LD A,(DE)               ; Fetch charstr.room
  INC DE                  ; Advance DE to charstr.pos
  AND A                   ; Is it outside?
  JR NZ,spawn_indoors     ; Jump if not
; Outdoors
  LD A,$03                ; Set A for three iterations (x,y,height)
; Start loop
spawn_outdoor_pos_loop:
  EX AF,AF'               ; Bank
  LD A,(DE)               ; Read an (8-bit) coord
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  LD (HL),C               ; Store the result widened to 16-bit
  INC HL                  ;
  LD (HL),B               ;
  INC HL                  ;
  INC DE                  ; Advance to the next coord
  EX AF,AF'               ; Unbank
  DEC A                        ; ...loop
  JP NZ,spawn_outdoor_pos_loop ;
  JR spawn_check_collide  ; (else)
spawn_indoors:
  LD B,$03                ; Set B for three iterations
; Start loop
spawn_indoor_pos_loop:
  LD A,(DE)               ; Read an (8-bit) coord
  LD (HL),A               ; Store the coord widened to 16-bit
  INC DE                  ;
  INC HL                  ;
  LD (HL),$00             ;
  INC HL                  ;
  DJNZ spawn_indoor_pos_loop ; ...loop
spawn_check_collide:
  CALL collision          ; Call collision
  CALL Z,bounds_check     ; If no collision, call bounds_check
  POP DE                  ; Restore the character pointer
  POP HL                  ; Restore the empty vischar slot pointer
  RET NZ                  ; Return if collision or bounds_check returned non-zero
; Transfer character struct to vischar.
  LD A,(DE)               ; Set characterstruct_FLAG_ON_SCREEN in charstr.character_and_flags
  OR $40                  ;
  LD (DE),A               ;
  AND $1F                 ; Mask A against characterstruct_CHARACTER_MASK ($1F) and store that as vischar.character
  LD (HL),A               ;
  INC L                   ;
  LD (HL),$00             ; Clear the vischar.flags
  PUSH DE                 ; Preserve the charstr.character_and_flags pointer
  LD DE,character_meta_data_commandant ; Point DE at the character_meta_data for the commandant
  AND A                   ; Is it character_0_COMMANDANT?
  JR Z,spawn_metadata_set ; Jump if so
  LD DE,character_meta_data_guard ; Point DE at the character_meta_data for a guard
  CP $10                  ; Is it character_1_GUARD_1 to character_15_GUARD_15?
  JR C,spawn_metadata_set ; Jump if so
  LD DE,character_meta_data_dog ; Point DE at the character_meta_data for a dog
  CP $14                  ; Is it character_16_GUARD_DOG_1 to character_19_GUARD_DOG_4?
  JR C,spawn_metadata_set ; Jump if so
  LD DE,character_meta_data_prisoner ; Point DE at the character_meta_data for a prisoner
spawn_metadata_set:
  EX DE,HL                ; Swap vischar into DE, metadata into HL
  LD A,$07                ; Point DE at vischar.animbase
  ADD A,E                 ;
  LD E,A                  ;
  LDI                     ; Copy metadata.animbase to vischar.animbase
  LDI                     ;
  LD A,$0B                ; Point DE at vischar.mi.sprite
  ADD A,E                 ;
  LD E,A                  ;
  LDI                     ; Copy metadata.sprite to vischar.mi.sprite
  LDI                     ;
  LD A,E                  ; Rewind DE to vischar.mi.pos
  SUB $08                 ;
  LD E,A                  ;
  LD HL,saved_pos_x       ; Copy saved_pos to vischar.mi.pos
  LD BC,$0006             ;
  LDIR                    ;
  POP HL                  ; Restore the HL charstr.character_and_flags pointer
  INC HL                  ; Advance HL to charstr.route
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  LD A,$07                ; Point DE at vischar.room
  ADD A,E                 ;
  LD E,A                  ;
  LD A,(room_index)       ; Set vischar.room to the global current room index
  LD (DE),A               ;
  AND A                   ; Are we outside?
  JR Z,spawn_entered      ; Jump if so
spawn_indoors_sound:
  LD BC,$2040             ; Play the "character enters" sound effects
  CALL play_speaker       ;
  LD BC,$2030             ;
  CALL play_speaker       ;
spawn_entered:
  LD A,E                  ; Rewind DE to vischar.route
  SUB $1A                 ;
  LD E,A                  ;
  LDI                     ; vischar.route = charstr.route
  LDI                     ;
  DEC HL                  ; Rewind HL to charstr.route
  DEC HL                  ;
; This can get entered twice via C5B4. On the first entry HL points at charstr.route.index. On the second entry HL points at vischar.route.index.
spawn_again:
  LD A,(HL)               ; Load route.index
  AND A                   ; Is this character stood still? (routeindex_0_HALT)
  JR NZ,spawn_moving      ; Jump if not
  LD A,$03                ; Advance DE to vischar.counter_and_flags
  ADD A,E                 ;
  LD E,A                  ;
  JR spawn_end            ; (else)
spawn_moving:
  XOR A                          ; Clear the entered_move_characters flag
  LD (entered_move_characters),A ;
  PUSH DE                 ; Preserve the vischar.target pointer
  CALL get_target         ; Get our next target: a location, a door or 'route ends'. The result is returned in A, target pointer returned in HL
  CP $FF                  ; Did get_target return get_target_ROUTE_ENDS? ($FF)
  JR NZ,spawn_route_door_test ; Jump if not
spawn_route_ends:
  POP HL                  ; Restore the vischar.target pointer
  DEC L                   ; Rewind HL to vischar.route
  DEC L                   ;
  PUSH HL                 ; Preserve the vischar.route pointer
  CALL route_ended        ; Route ended
  POP HL                  ; Restore the vischar.route pointer
  LD D,H                  ; Point DE at vischar.target
  LD E,L                  ;
  INC E                   ;
  INC E                   ;
  JR spawn_again          ; Jump back and try again...
spawn_route_door_test:
  CP $80                  ; Did get_target return get_target_DOOR? ($80)
  JR NZ,spawn_got_target  ; Jump if not (it must be get_target_LOCATION)
spawn_route_door:
  SET 6,(IY+$01)          ; Set the vischar_FLAGS_TARGET_IS_DOOR flag
spawn_got_target:
  POP DE                  ; Restore the vischar.target pointer
  LD BC,$0003             ; Copy the next target to vichar.target
  LDIR                    ;
spawn_end:
  XOR A                   ; Clear vischar.counter_and_flags
  LD (DE),A               ;
  LD A,E                  ; Rewind DE back to vischar.character (first byte)
  SUB $07                 ;
  LD E,A                  ;
  EX DE,HL                ; Swap vischar pointer into HL
  PUSH HL                 ; Preserve vischar pointer
  CALL calc_vischar_iso_pos_from_vischar ; Calculate screen position for the specified vischar
  POP HL                  ; Restore vischar pointer
  JP character_behaviour  ; Exit via character_behaviour

; Reset a visible character (either a character or a stove/crate object).
;
; Used by the routines at transition, reset_nonplayer_visible_characters, reset_map_and_characters and purge_invisible_characters.
;
; I:HL Pointer to visible character.
reset_visible_character:
  LD A,(HL)               ; Fetch the vischar's character index
  CP $FF                  ; Is it character_NONE? ($FF)
  RET Z                   ; Return if so
  CP $1A                  ; Is it a stove/crate character? (character_26_STOVE_1+)
  JR C,rvc_humans         ; Jump if not
  EX AF,AF'               ; Bank
; It's a stove or crate character.
  LD (HL),$FF             ; Set vischar.character to $FF (character_NONE)
  INC L                   ; Advance HL to vischar.flags
  LD (HL),$FF             ; Reset flags to $FF (vischar_FLAGS_EMPTY_SLOT)
  LD A,$06                ; Point HL at counter_and_flags
  ADD A,L                 ;
  LD L,A                  ;
  LD (HL),$00             ; Set counter_and_flags to zero
  ADD A,$08               ; Point HL at vischar.mi.pos
  LD L,A                  ;
  EX AF,AF'               ; Unbank
; Save the old position.
  LD DE,movable_item_stove1 ; Point DE at movable_items[0] / stove 1
  CP $1A                  ; Is A character_26_STOVE_1?
  JR Z,rvc_copy_mi        ; Jump if so
  LD DE,movable_item_stove2 ; Point DE at movable_items[2] / stove 2
  CP $1B                  ; Is A character_27_STOVE_2?
  JR Z,rvc_copy_mi        ; Jump if so
  LD DE,movable_item_crate ; Otherwise point DE at movable_items[1] / crate
; Note: The DOS version of the game has a difference here. Instead of copying the current vischar's position into the movable_items's position, it only copies the first two bytes. The code is setup for a copy of six bytes (cx is set to 3)
; but the 'movsw' ought to be a 'rep movsw' for it to work. It fixes the bug where stoves get left in place after a restarted game, but almost looks like an accident.
rvc_copy_mi:
  LD BC,$0006             ; Copy six bytes to the movable_items entry
  LDIR                    ;
  RET                     ; Return
; A non-object character.
rvc_humans:
  EX DE,HL                ; Bank vischar pointer
  CALL get_character_struct ; Get character struct for A, result in HL
  RES 6,(HL)              ; Clear flag characterstruct_FLAG_ON_SCREEN
  LD A,$1C                ; Point DE at vischar.room
  ADD A,E                 ;
  LD E,A                  ;
  LD A,(DE)               ; Fetch vischar.room
  INC HL                  ; Copy it to charstr.room
  LD (HL),A               ;
  EX AF,AF'               ; Bank room index
  EX DE,HL                ; Unbank vischar pointer
  LD A,L                  ; Point HL at vischar.counter_and_flags
  SUB $15                 ;
  LD L,A                  ;
  LD (HL),$00             ; Clear vischar.counter_and_flags
  ADD A,$08               ; Point HL at vischar.mi.pos
  LD L,A                  ;
; Save the old position.
  INC DE                  ; Point DE at charstr.pos.x
  EX AF,AF'               ; Unbank room index
  AND A                   ; Are we outdoors?
  JR NZ,rvc_indoors       ; Jump if not
; Outdoors.
  CALL pos_to_tinypos     ; Scale down vischar.mi.pos to charstr.pos
  JR rvc_reset_common     ; (else)
; Indoors.
rvc_indoors:
  LD B,$03                ; Set B for three iterations
; Start loop
rvc_indoors_loop:
  LD A,(HL)               ; Copy coordinate
  LD (DE),A               ;
  INC L                   ; Advance the source pointer
  INC L                   ;
  INC DE                  ;
  DJNZ rvc_indoors_loop   ; ...loop
rvc_reset_common:
  LD A,L                  ; Reset HL to point to the original vischar
  SUB $15                 ;
  LD L,A                  ;
  LD A,(HL)               ; Fetch character index
  LD (HL),$FF             ; Set vischar.character to $FF (character_NONE)
  INC L                   ; Advance HL to vischar.flags
  LD (HL),$FF             ; Reset flags to $FF (vischar_FLAGS_EMPTY_SLOT)
  INC L                   ; Advance HL to vischar.route
; Guard dogs only.
  CP $10                  ; Is this a guard dog character? character_16_GUARD_DOG_1..character_19_GUARD_DOG_4
  JR C,rvc_end            ;
  CP $14                  ;
  JR NC,rvc_end           ;
; Choose random locations in the fenced off area (right side).
rvc_dogs:
  LD (HL),$FF             ; Set route to (routeindex_255_WANDER,0) ($FF,$00) -- wander from locations 0..7
  INC L                   ;
  LD (HL),$00             ;
  CP $12                  ; Is this character_18_GUARD_DOG_3 or character_19_GUARD_DOG_4?
  JR C,rvc_dogs_done      ; Jump if not
; Choose random locations in the fenced off area (bottom side).
  LD (HL),$18             ; Set route.step to $18 -- wander from locations 24..31
rvc_dogs_done:
  DEC L                   ; Point HL at vischar.route
rvc_end:
  LDI                     ; Copy route into charstr
  LDI                     ;
  RET                     ; Return

; Return the coordinates of the route's current target.
;
; Given a route_t return the coordinates the character should move to. Coordinates are returned as a tinypos_t when moving to a door or an xy_t when moving to a numbered location.
;
; If the route specifies 'wander' then one of eight random locations starting from route.step is chosen.
;
; Used by the routines at set_route, spawn_character, move_characters and get_target_assign_pos.
;
; I:HL Pointer to route.
; O:A 0/128/255 => Target is a location / a door / the route ended.
; O:HL If the target is a location a pointer into locations[]; if a door a pointer into doors[] (returned as door.pos).
get_target:
  LD A,(HL)               ; Get the route index
  CP $FF                  ; Is it routeindex_255_WANDER? ($FF)
  JR NZ,gt_not_halt       ; Jump if not
; Wander around randomly.
;
; Uses route.step + rand(0..7) to index locations[].
gt_wander:
  INC HL                  ; Clear the bottom three bits of route.step
  LD A,(HL)               ;
  AND $F8                 ;
  LD (HL),A               ;
  CALL random_nibble      ; Get a pseudo-random number in A
  AND $07                 ; Make it 0..7
  ADD A,(HL)              ; Add the random value to route.step
  LD (HL),A               ;
  JR gt_pick_loc          ; Jump
gt_not_halt:
  PUSH HL                 ; Preserve the route pointer
  INC HL                  ; Load route.step
  LD C,(HL)               ;
; Control can arrive here with route.index set to zero. This happens when the hero stands up during breakfast, is pursued by guards, then when left to idle sits down and the pursuing guards resume their original positions. get_route() will
; return in that case a zero pointer so it starts fetching from $0001. In the Spectrum ROM location $0001 holds XOR A ($AF).
  CALL get_route          ; Get the route for A in DE
; Since all of the routes are packed togther, this relies on being able to fetch the previous route's terminator.
  LD H,$00                ; High byte is set to zero unless... route.step is $FF when it's set to $FF
  LD A,C                  ;
  CP $FF                  ;
  JR NZ,get_target_0      ;
  DEC H                   ;
get_target_0:
  LD L,A                  ; HL = -1, or route.step
  ADD HL,DE               ; Point DE at the next route byte
  EX DE,HL                ;
  LD A,(DE)               ; Read a byte of route
  CP $FF                  ; Is it routebyte_END? ($FF)
  POP HL                  ; Irrespectively restore HL
  JR Z,gt_route_ends      ; Jump if so
  AND $7F                 ; Clear its door_REVERSE flag ($80)
  CP $28                  ; Is it a door index?
  JR NC,gt_location       ; Jump if not
; Route byte < 40: A door.
gt_door:
  LD A,(DE)               ; Re-read routebyte to get the reversed flag
  BIT 7,(HL)              ; Reversed?
  JR Z,get_target_1       ; Jump if not
  XOR $80                 ; Toggle reverse flag
get_target_1:
  CALL get_door           ; Turn the door index into a door_t pointer (in HL)
  INC HL                  ; Advance HL to point at door.pos
  LD A,$80                ; Return with A set to 128
  RET                     ;
; Route byte = 40..117: A location index.
gt_location:
  LD A,(DE)               ; The location index is offset by 40
  SUB $28                 ;
gt_pick_loc:
  ADD A,A                 ; Point HL at location[A]
  LD HL,locations         ;
  ADD A,L                 ;
  LD L,A                  ;
  JR NC,get_target_2      ;
  INC H                   ;
get_target_2:
  XOR A                   ; Return with A set to zero
  RET                     ;
gt_route_ends:
  LD A,$FF                ; Return with A set to 255
  RET                     ;

; Move one (off-screen) character around at a time.
;
; Used by the routine at main_loop.
move_characters:
  LD A,$FF                       ; Set the 'character index is valid' flag
  LD (entered_move_characters),A ;
; Move to the next character, wrapping around after character 26.
  LD A,(character_index)  ; Load and increment the current character index
  INC A                   ;
  CP $1A                  ; If the character index became character_26_STOVE_1 then wrap around to character_0_COMMANDANT
  JR NZ,mc_didnt_wrap     ;
  XOR A                   ;
mc_didnt_wrap:
  LD (character_index),A  ; Store the character index
; Get its chararacter struct, or exit if the character isn't on-screen.
  CALL get_character_struct ; Get a pointer to the character struct for character index A, in HL
  BIT 6,(HL)              ; Is the character on-screen? characterstruct_FLAG_ON_SCREEN
  RET NZ                  ; It's not - return
  PUSH HL                 ; Preserve the character struct pointer
; Are any items to be found in the same room as the character?
  INC HL                  ; Advance HL to charstr.room and fetch it
  LD A,(HL)               ;
  AND A                   ; Are we outdoors?
  JR Z,mc_no_item         ; Jump if so
; Note: This discovers just one item at a time.
  CALL is_item_discoverable_interior ; Is the item discoverable indoors?
  JR NZ,mc_no_item        ; Jump if not found
  CALL item_discovered    ; Otherwise cause item C to be discovered
mc_no_item:
  POP HL                  ; Restore the character struct pointer
  INC HL                  ; Advance HL to charstr.pos
  INC HL                  ;
  PUSH HL                 ; Preserve the charstr.pos pointer
  INC HL                  ; Advance HL to charstr.route
  INC HL                  ;
  INC HL                  ;
; If the character is standing still, return now.
  LD A,(HL)               ; Fetch charstr.route.index
  AND A                   ; Is it routeindex_0_HALT?
  JR NZ,mc_not_halted     ; Jump if not
mc_halted:
  POP HL                  ; Restore the charstr.pos pointer
  RET                     ; Return
mc_not_halted:
  CALL get_target         ; Get our next target: a location, a door or 'route ends'. The result is returned in A, target pointer returned in HL
  CP $FF                  ; Did get_target return get_target_ROUTE_ENDS? ($FF)
  JP NZ,mc_door           ; Jump if not
; When the route ends, reverse the route.
  LD A,(character_index)  ; Fetch the current character index
  AND A                   ; Is it the commandant? (character_0_COMMANDANT)
  JR Z,mc_commandant      ; Jump if so
; Not the commandant.
  CP $0C                  ; Is it character_12_GUARD_12 or higher?
  JR NC,mc_trigger_event  ; Jump if so
; Characters 1..11.
mc_reverse_route:
  LD A,(HL)               ; Toggle charstr.route direction flag routeindexflag_REVERSED ($80)
  XOR $80                 ;
  LD (HL),A               ;
  INC HL                  ;
; Pattern: [-2]+1
  BIT 7,A                 ; If the route is reversed then step backwards, otherwise step forwards
  JR Z,mc_route_fwd       ;
  DEC (HL)                ;
  DEC (HL)                ;
mc_route_fwd:
  INC (HL)                ;
  POP HL                  ; Restore the charstr.pos pointer
  RET                     ; Return
; Commandant only.
mc_commandant:
  LD A,(HL)               ; Read the charstr.route index
  AND $7F                 ;
  CP $24                  ; Jump if it's not routeindex_36_GO_TO_SOLITARY
  JR NZ,mc_reverse_route  ;
; We arrive here if the character index is character_12_GUARD_12, or higher, or if it's the commandant on route 36 ("go to solitary").
mc_trigger_event:
  POP DE                  ; Restore the charstr.pos pointer
  JP character_event      ; Exit via character_event
; Two unused bytes.
  DEFB $18,$6F
mc_door:
  CP $80                  ; Did get_target return get_target_DOOR? ($80)
  JP NZ,mc_regular_move   ; Jump if not
; Handle the target-is-a-door case.
  POP DE                  ; Restore the charstr.pos pointer (PUSH at C6C8)
  DEC DE                  ; Get room index
  LD A,(DE)               ;
  INC DE                  ;
  PUSH HL                 ; Preserve the door.pos pointer
  AND A                   ; Are we outdoors?
  JP NZ,mc_door_choose_maxdist ; Jump if not
; Outdoors
  PUSH DE                 ; Preserve the charstr.pos pointer
; Divide the door.pos location at HL by two and store it to saved_pos.
  LD DE,saved_pos_x       ; Point DE at saved_pos_x
  LD B,$02                ; Set B for two iterations
; Start loop
mc_door_copypos_loop:
  LD A,(HL)               ; Copy X,Y of door.pos, each axis divided by two
  AND A                   ;
  RRA                     ;
  LD (DE),A               ;
  INC HL                  ;
  INC DE                  ;
  DJNZ mc_door_copypos_loop ; ...loop
  LD HL,saved_pos_x       ; Point HL at saved_pos_x
  POP DE                  ; Restore the charstr.room pointer
; Decide on a maximum movement distance for move_towards to use.
mc_door_choose_maxdist:
  DEC DE                  ; Rewind DE to point at charstr.room
  LD A,(DE)               ; Fetch it
  INC DE                  ; Advance DE back
  AND A                   ; Was charstr.room room_0_OUTDOORS?
  LD A,$02                ; Set the maximum distance to two irrespectively
  JR Z,mc_door_maxdist_chosen ; Jump if it was
  LD A,$06                ; Otherwise set the maximum distance to six
mc_door_maxdist_chosen:
  EX AF,AF'               ; Move maximum to A'
  LD B,$00                ; Initialise the "arrived" counter to zero
  CALL move_towards       ; Move charstr.pos.x (pointed to by DE) towards tinypos.x (HL), with a maximum delta of A'. B is incremented if no movement was required
  INC DE                  ; Advance to Y axis
  INC HL                  ;
  CALL move_towards       ; Move again, but on Y axis
  POP HL                  ; Restore the door.pos pointer
  LD A,B                  ; Did we move?
  CP $02                  ;
  RET NZ                  ; Return if so
; If we reach here the character has arrived at their destination.
;
; Our current target is a door, so change to the door's target room.
mc_door_reached:
  DEC DE                  ; Rewind DE to charstr.room
  DEC DE                  ;
  DEC HL                  ; Rewind HL to door.room_and_direction
  LD A,(HL)               ; Fetch door.room_and_direction
  AND $FC                 ; Isolate the room number
  RRA                     ;
  RRA                     ;
  LD (DE),A               ; Assign to charstr.room (i.e. change room)
; Determine the destination door.
  LD A,(HL)               ; Isolate the direction (door_FLAGS_MASK_DIRECTION)
  AND $03                 ;
  CP $02                  ; Is the door facing top left or top right?
  JR NC,mc_door_prev      ; Jump if neither
  INC HL                  ; Otherwise calculate the address of the next door half
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  JR mc_door_copy_pos     ; (else)
mc_door_prev:
  DEC HL                  ; Calculate the address of the previous door half
  DEC HL                  ;
  DEC HL                  ;
mc_door_copy_pos:
  LD A,(DE)               ; Fetch charstr.room
  INC DE                  ; Advance to charstr.pos
  AND A                   ; Is it room_0_OUTDOORS?
  JR Z,mc_door_outdoors   ; Jump if so
; Indoors. Copy the door's tinypos into the charstr's tinypos.
  LDI                     ; Copy X
  LDI                     ; Copy Y
  LDI                     ; Copy height
  DEC DE                  ; Rewind DE to charstr.pos.height
  JR mc_regular_reached   ; (else)
; Outdoors. Copy the door's tinypos into the charstr's tinypos, dividing by two.
mc_door_outdoors:
  LD B,$03                ; Set B for three iterations
; Start loop
mc_door_outdoors_loop:
  LD A,(HL)               ; Copy X,Y of door.pos, each axis divided by two
  AND A                   ;
  RRA                     ;
  LD (DE),A               ;
  INC HL                  ;
  INC DE                  ;
  DJNZ mc_door_outdoors_loop ; ...loop
  DEC DE                  ; Rewind DE to charstr.pos.height
  JR mc_regular_reached   ; (else)
; Normal move case.
mc_regular_move:
  POP DE                  ; Restore the charstr.pos pointer
; Establish a maximum for passing into move_towards.
mc_regular_choose_maxdist:
  DEC DE                  ; Rewind DE to point at charstr.room
  LD A,(DE)               ; Fetch it
  INC DE                  ; Advance DE back
  AND A                   ; Are we outdoors?
  LD A,$02                ; Set maximum to two irrespectively
  JR Z,mc_regular_maxdist_chosen ; Jump if we are
  LD A,$06                ; Otherwise set maximum to six
mc_regular_maxdist_chosen:
  EX AF,AF'               ; Move maximum to A'
  LD B,$00                ; Initialise the "arrived" counter to zero
  CALL move_towards       ; Move charstr.pos.x (pointed to by DE) towards tinypos.x (HL), with a maximum delta of A'. B is incremented if no movement was required
  INC HL                  ; Advance to Y axis
  INC DE                  ;
  CALL move_towards       ; Move again, but on Y axis
  INC DE                  ; Advance DE to charstr.pos.height (possibly redundant)
  LD A,B                  ; Did we move?
  CP $02                  ;
  JR Z,mc_regular_reached ; Jump if not
  RET                     ; Otherwise return
; If we reach here the character has arrived at their destination.
mc_regular_reached:
  INC DE                  ; Advance DE to charstr.route
  EX DE,HL                ; Swap charstr into HL
  LD A,(HL)               ; Read charstr.route.index
  CP $FF                  ; Is the route index routeindex_255_WANDER? ($FF)
  RET Z                   ; Return if so
  BIT 7,A                 ; If the route is reversed then step backwards, otherwise step forwards
  INC HL                  ;
  JR NZ,mc_route_down     ;
mc_route_up:
  INC (HL)                ; Increment route.step
  RET                     ; Return
mc_route_down:
  DEC (HL)                ; Decrement route.step
  RET                     ; Return

; Moves the first value toward the second.
;
; Used by the routine at move_characters.
;
; I:A' Largest movement allowed. Either 2 or 6.
; I:B Return code. Incremented if delta is zero.
; I:DE Pointer to the first value (byte).
; I:HL Pointer to the second value (byte).
; O:B Incremented by one when no change.
move_towards:
  EX AF,AF'               ; Set C to the largest movement allowed
  LD C,A                  ;
  EX AF,AF'               ;
  LD A,(DE)               ; delta = first - second
  SUB (HL)                ;
  JR NZ,move_towards_0    ; Was the delta zero? Jump if not
; Delta was zero
  INC B                   ; Otherwise increment the result by one
  RET                     ; Return
move_towards_0:
  JR NC,move_towards_2    ; Was the delta negative? Jump if not
; Delta was negative
  NEG                     ; Get the absolute value
  CP C                    ; Clamp the delta to the largest movement
  JR C,move_towards_1     ;
  LD A,C                  ;
move_towards_1:
  LD C,A                  ; Move the first value towards second
  LD A,(DE)               ;
  ADD A,C                 ;
  LD (DE),A               ;
  RET                     ; Return
; Delta was positive
move_towards_2:
  CP C                    ; Clamp the delta to the largest movement
  JR C,move_towards_3     ;
  LD A,C                  ;
move_towards_3:
  LD C,A                  ; Move the first value towards second
  LD A,(DE)               ;
  SUB C                   ;
  LD (DE),A               ;
  RET                     ; Return

; Get character struct.
;
; Used by the routines at set_character_route, reset_visible_character and move_characters.
;
; I:A Character index.
; O:HL Points to character struct.
get_character_struct:
  LD L,A                  ; Multiply A by seven
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  SUB L                   ;
  LD HL,character_structs ; Point HL at character_structs
  ADD A,L                 ; Combine
  LD L,A                  ;
  RET NC                  ;
  INC H                   ;
  RET                     ; Return

; Character event.
;
; Used by the routines at move_characters and route_ended.
;
; Makes characters sit, sleep or other things TBD.
;
; I:HL Points to character_struct.route or vischar.route.
character_event:
  LD A,(HL)               ; Load route.index
  CP $07                  ; Is it less than routeindex 7?
  JR C,character_event_0  ; Jump if so
  CP $0D                  ; Is it less than routeindex 13?
  JP C,character_sleeps   ; Call 'character sleeps' if so (if indices 7..12)
character_event_0:
  CP $12                  ; Is it less than routeindex_18?
  JR C,character_event_1  ; Jump if so
; Bug: The sixth prisoner doesn't sit for breakfast because this should be $18.
  CP $17                  ; Is it less than routeindex 23?
  JP C,character_sits     ; Call 'character sits' if so (if indices 18..22)
character_event_1:
  PUSH HL                 ; Stack the route pointer - the event handlers will pop
; Locate the character in the character_to_event_handler_index_map.
  LD HL,character_to_event_handler_index_map ; Point HL at character_to_event_handler_index_map[0]
  LD B,$18                ; Set B for 24 iterations - length of the map
; Start loop
character_event_2:
  CP (HL)                 ; Does the route index in A match the map's route index?
  JR Z,ce_call_action     ; Jump if so
  INC HL                  ; Advance to the next map entry
  INC HL                  ;
  DJNZ character_event_2  ; ...loop
  POP HL                  ; Unstack the route pointer
  LD (HL),$00             ; Make the character stand still by setting the new route index to routeindex_0_HALT
  RET                     ; Return
ce_call_action:
  INC HL                  ; Read the index of the handler from the map
  LD A,(HL)               ;
  ADD A,A                 ; Double it
  LD C,A                  ; Copy it to BC
  LD B,$00                ;
  LD HL,character_event_handlers ; Point HL at character_event_handlers[index]
  ADD HL,BC                      ;
  LD A,(HL)               ; Load the event handler address into HL
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  JP (HL)                 ; Jump to the event handler
; character_to_event_handler_index_map
;
; Array of (character + flags, character event handler index) mappings.
character_to_event_handler_index_map:
  DEFW $00A6              ; routeindex_38_GUARD_12_BED         | REVERSE, 0 - wander between locations  8..15
  DEFW $00A7              ; routeindex_39_GUARD_13_BED         | REVERSE, 0 - wander between locations  8..15
  DEFW $01A8              ; routeindex_40_GUARD_14_BED         | REVERSE, 1 - wander between locations 16..23
  DEFW $01A9              ; routeindex_41_GUARD_15_BED         | REVERSE, 1 - wander between locations 16..23
  DEFW $0005              ; routeindex_5_EXIT_HUT2,                       0 - wander between locations  8..15
  DEFW $0106              ; routeindex_6_EXIT_HUT3,                       1 - wander between locations 16..23
  DEFW $0385              ; routeindex_5_EXIT_HUT2             | REVERSE, 3 -
  DEFW $0386              ; routeindex_6_EXIT_HUT3             | REVERSE, 3 -
  DEFW $020E              ; routeindex_14_GO_TO_YARD,                     2 - wander between locations 56..63
  DEFW $020F              ; routeindex_15_GO_TO_YARD,                     2 - wander between locations 56..63
  DEFW $008E              ; routeindex_14_GO_TO_YARD           | REVERSE, 0 - wander between locations  8..15
  DEFW $018F              ; routeindex_15_GO_TO_YARD           | REVERSE, 1 - wander between locations 16..23
  DEFW $0510              ; routeindex_16_BREAKFAST_25,                   5 -
  DEFW $0511              ; routeindex_17_BREAKFAST_23,                   5 -
  DEFW $0090              ; routeindex_16_BREAKFAST_25         | REVERSE, 0 - wander between locations  8..15
  DEFW $0191              ; routeindex_17_BREAKFAST_23         | REVERSE, 1 - wander between locations 16..23
  DEFW $00A0              ; routeindex_32_GUARD_15_ROLL_CALL   | REVERSE, 0 - wander between locations  8..15
  DEFW $01A1              ; routeindex_33_PRISONER_4_ROLL_CALL | REVERSE, 1 - wander between locations 16..23
  DEFW $072A              ; routeindex_42_HUT2_LEFT_TO_RIGHT,             7 -
  DEFW $082C              ; routeindex_44_HUT2_RIGHT_TO_LEFT,             8 - hero sleeps
  DEFW $092B              ; routeindex_43_7833,                           9 - hero sits
  DEFW $06A4              ; routeindex_36_GO_TO_SOLITARY       | REVERSE, 6 -
  DEFW $0A24              ; routeindex_36_GO_TO_SOLITARY,                10 - hero released from solitary
  DEFW $0425              ; routeindex_37_HERO_LEAVE_SOLITARY,            4 - solitary ends
; character_event_handlers
;
; Array of pointers to character event handlers.
character_event_handlers:
  DEFW charevnt_wander_top
  DEFW charevnt_wander_left
  DEFW charevnt_wander_yard
  DEFW charevnt_bed
  DEFW charevnt_solitary_ends
  DEFW charevnt_breakfast
  DEFW charevnt_commandant_to_yard
  DEFW charevnt_exit_hut2
  DEFW charevnt_hero_sleeps
  DEFW charevnt_hero_sits
  DEFW charevnt_hero_release
; charevnt_solitary_end
charevnt_solitary_ends:
  XOR A                   ; in_solitary = 0; // enable player control
  LD (in_solitary),A      ;
  JR charevnt_wander_top  ; goto charevnt_wander_top;
; charevnt_commandant_to_yard
charevnt_commandant_to_yard:
  POP HL                  ; // (popped) sampled HL=$80C2 (x2),$8042  // route
  LD (HL),$03             ; *HL++ = 0x03;
  INC HL                  ;
  LD (HL),$15             ; *HL   = 0x15;
  RET                     ; Return
; charevnt_hero_release
charevnt_hero_release:
  POP HL
  LD (HL),$A4             ; *HL++ = 0xA4;
  INC HL                  ;
  LD (HL),$03             ; *HL   = 0x03;
  XOR A                           ; automatic_player_counter = 0; // force automatic control
  LD (automatic_player_counter),A ;
  LD BC,$2500             ; set_hero_route(0x0025); return;
  JP set_hero_route_force ;
; charevnt_wander_left
charevnt_wander_left:
  LD C,$10                ; C = 0x10; // 0xFF10
  JR character_event_3    ; goto exit;
; charevnt_wander_yard
charevnt_wander_yard:
  LD C,$38                ; C = 0x38; // 0xFF38
  JR character_event_3    ; goto exit;
; charevnt_wander_top
charevnt_wander_top:
  LD C,$08                ; C = 0x08; // 0xFF08 // sampled HL=$8022,$8042,$8002,$8062
character_event_3:
  POP HL                  ; exit:
  LD (HL),$FF             ; *HL++ = 0xFF;
  INC HL                  ;
  LD (HL),C               ; *HL   = C;
  RET                     ; Return
; charevnt_bed
charevnt_bed:
  POP HL
  LD A,(entered_move_characters) ; if (entered_move_characters == 0) goto character_bed_vischar; else goto character_bed_state;
  AND A                          ;
  JP Z,character_bed_vischar     ;
  JP character_bed_state         ;
; charevnt_breakfast
charevnt_breakfast:
  POP HL
  LD A,(entered_move_characters)  ; if (entered_move_characters == 0) goto charevnt_breakfast_vischar; else goto charevnt_breakfast_state;
  AND A                           ;
  JP Z,charevnt_breakfast_vischar ;
  JP charevnt_breakfast_state     ;
; charevnt_exit_hut2
charevnt_exit_hut2:
  POP HL
  LD (HL),$05             ; *HL++ = 0x05;
  INC HL                  ;
  LD (HL),$00             ; *HL   = 0x00;
  RET                     ; Return
; charevnt_hero_sits
charevnt_hero_sits:
  POP HL
  JP hero_sits            ; goto hero_sits;
; charevnt_hero_sleeps
charevnt_hero_sleeps:
  POP HL
  JP hero_sleeps          ; goto hero_sleeps;

; A countdown until any food item is discovered.
;
; (<- automatics, target_reached)
food_discovered_counter:
  DEFB $00

; Make characters follow the hero if he's being suspicious.
;
; Also handles food item discovery and automatic hero behaviour.
;
; Used by the routine at main_loop.
automatics:
  XOR A                          ; Clear the 'character index is valid' flag
  LD (entered_move_characters),A ;
; Hostiles pursue if the bell is not ringing.
  LD A,(bell)             ; Read the bell ring counter/flag
  AND A                   ; Is it bell_RING_PERPETUAL?
  CALL Z,hostiles_pursue  ; Call (hostiles pursue prisoners) if so
; If food was dropped then count down until it is discovered.
  LD HL,food_discovered_counter ; Point HL at food_discovered_counter
  LD A,(HL)               ; Fetch the counter
  AND A                   ; Is it zero?
  JR Z,auto_react         ; Jump if so (it already hit zero)
  DEC (HL)                ; Otherwise decrement it
  JR NZ,auto_react        ; Jump if it's not zero
; De-poison the food.
  LD HL,item_structs_food ; Point HL at item_structs[item_FOOD].item
  RES 5,(HL)              ; Clear its itemstruct_ITEM_FLAG_POISONED flag
  LD C,$07                ; Set C to item_FOOD
  CALL item_discovered    ; Cause item C to be discovered
; Make supporting characters react.
auto_react:
  LD IY,$8020             ; Point HL at the second visible character
  LD B,$07                ; Set B for seven iterations
; Start loop
auto_react_loop:
  PUSH BC                 ; Preserve the loop counter
  LD A,(IY+$01)           ; Load vischar.flags
  CP $FF                  ; Is it an empty slot?
  JP Z,auto_next          ; Jump if so
  LD A,(IY+$00)           ; Load vischar.character
  AND $1F                 ; Mask with vischar_CHARACTER_MASK to get character index
  CP $14                  ; Is it a hostile character? (character_19_GUARD_DOG_4 or below)
  JP NC,auto_behaviour    ; Jump if not
; Characters 0..19.
  PUSH AF                 ; Preserve the character index
  CALL is_item_discoverable ; Is the item discoverable?
  LD A,(red_flag)         ; Is red_flag set?
  AND A                   ;
  JR NZ,auto_follow       ; Jump if so
  LD A,(automatic_player_counter) ; Is automatic_player_counter non-zero?
  AND A                           ;
auto_follow:
  CALL NZ,guards_follow_suspicious_character ; Call (guards follow suspicious character) if so
  POP AF                  ; Restore character index
; Guard dogs 1..4 (characters 16..19).
  CP $0F                  ; Is this character a guard dog?
  JP Z,auto_behaviour     ; Jump if not
  JP C,auto_behaviour     ;
; Dog handling: Is the food nearby?
  PUSH IY                 ; Copy global vischar pointer to HL
  POP HL                  ;
  INC L                   ; Point HL at vischar.flags
  LD A,($76FA)            ; Fetch item_structs[item_FOOD].room
  BIT 7,A                 ; Test for itemstruct_ROOM_FLAG_NEARBY_7
  JR Z,auto_behaviour     ; Jump if clear
  LD (HL),$03             ; Set vischar.flags to vischar_PURSUIT_DOG_FOOD
auto_behaviour:
  CALL character_behaviour ; Call (character behaviour)
auto_next:
  POP BC                  ; Restore the loop counter
  LD DE,$0020             ; Advance to the next vischar
  ADD IY,DE               ;
  DEC B                   ; ...loop
  JP NZ,auto_react_loop   ;
; Inhibit hero automatic behaviour when the flag is red, or otherwise inhibited.
  LD A,(red_flag)         ; Is red_flag set?
  AND A                   ;
; Bug: Pointless JP NZ (jumps to a RET where a RET NZ would suffice).
  JP NZ,auto_return       ; Jump (return) if so
  LD A,(in_solitary)      ; Is in_solitary set?
  AND A                   ;
  JR NZ,auto_run_cb       ; Jump if so
  LD A,(automatic_player_counter) ; Is automatic_player_counter non-zero?
  AND A                           ;
  RET NZ                  ; Return if so
; Otherwise run character behaviour
auto_run_cb:
  LD IY,$8000             ; Point IY at the hero's vischar
  CALL character_behaviour ; Run character behaviour
auto_return:
  RET                     ; Return

; Character behaviour.
;
; Used by the routines at spawn_character and automatics.
;
; I:IY Pointer to visible character.
;
; Proceed into the character behaviour handling only when this delay field hits zero. This stops characters navigating around obstacles too quickly.
character_behaviour:
  LD A,(IY+$07)           ; Fetch vischar.counter_and_flags
  LD B,A                  ; Copy it to B
; If the counter field is set then decrement it and return.
  AND $0F                 ; Isolate the counter field in the bottom nibble
  JR Z,cb_proceed         ; Decrement the counter if it's positive
  DEC B                   ;
  LD (IY+$07),B           ;
  RET                     ; Return
; We arrive here when the counter is zero.
cb_proceed:
  PUSH IY                 ; Copy the vischar pointer into HL
  POP HL                  ;
  INC L                   ; Advance HL to vischar.flags
  LD A,(HL)               ; Fetch the flags so we can check the mode field
  AND A                   ; Are any flag bits set?
  JP Z,cb_check_halt      ; Jump if not
; Check for mode 1 ("pursue")
  CP $01                  ; Is the mode vischar_PURSUIT_PURSUE?
  JR NZ,cb_hassle_check   ; Jump if not
; Mode 1: Hero is chased by hostiles and sent to solitary if caught.
cb_pursue_hero:
  PUSH HL                 ; Preserve vischar.flags pointer
  EXX                     ; Bank
  POP DE                  ; Restore vischar.flags pointer
  INC E                   ; Advance DE to vischar.position
  INC E                   ;
  INC E                   ;
  LD HL,hero_map_position_x ; Point HL at the global map position (the hero's position)
  LDI                     ; Copy hero's (x,y) position to vischar.target
  LDI                     ;
  EXX                     ; Unbank
  JP cb_move              ; Jump to 'move'
; Check for mode 2 ("hassle")
cb_hassle_check:
  CP $02                  ; Is the mode vischar_PURSUIT_HASSLE?
  JR NZ,cb_dog_food_check ; Jump if not
; Mode 2: Hero is chased by hostiles if under player control.
  LD A,(automatic_player_counter) ; Is the automatic_player_counter non-zero?
  AND A                           ;
; The hero is under player control: pursue.
  JR NZ,cb_pursue_hero    ; Jump into mode 1's pursue handler
; Otherwise the hero is under automatic control: hostiles lose interest and resume their original route.
  LD (HL),$00             ; Clear vischar.flags
  INC L                   ;
  JP get_target_assign_pos ; Exit via get_target_assign_pos
; Check for mode 3 ("dog food")
cb_dog_food_check:
  CP $03                  ; Is the mode vischar_PURSUIT_DOG_FOOD?
  JR NZ,cb_saw_bribe_check ; Jump if not
; Mode 3: The food item is near a guard dog.
  PUSH HL                 ; Preserve vischar.flags pointer
  EX DE,HL                ; (get it in DE)
  LD HL,$76FA             ; Point HL at item_structs[item_FOOD].room
  BIT 7,(HL)              ; Is itemstruct_ROOM_FLAG_NEARBY_7 set?
  JR Z,cb_dog_food_not_nearby ; Jump if not
; Set the dog's target to the poisoned food location.
  INC HL                  ; Advance HL to item_structs[item_FOOD].pos.x
  LD A,E                  ; Point DE at vischar.target.x
  ADD A,$03               ;
  LD E,A                  ;
  LDI                     ; Copy (x,y)
  LDI                     ;
  POP HL                  ; Restore vischar.flags pointer
  JR cb_move              ; Jump to 'move'
; Nearby flag wasn't set.
cb_dog_food_not_nearby:
  XOR A                   ; Clear vischar.flags
  LD (DE),A               ;
  EX DE,HL                ; (get vischar.flags pointer in HL)
  INC L                   ; Set vischar.route.index to routeindex_255_WANDER ($FF)
  LD (HL),$FF             ;
  INC L                   ; Set vischar.route.step to zero -- wander from 0..7
  LD (HL),$00             ;
  POP HL                  ; Restore vischar.flags pointer
  JP get_target_assign_pos ; Exit via get_target_assign_pos
; Check for mode 4 ("saw bribe")
cb_saw_bribe_check:
  CP $04                  ; Is the mode vischar_PURSUIT_SAW_BRIBE?
  JR NZ,cb_check_halt     ; Jump if not
; Mode 4: Hostile character witnessed a bribe being given (in accept_bribe).
  PUSH HL                 ; Preserve vischar.flags pointer
  LD A,(bribed_character) ; Get the global bribed character
  CP $FF                  ; Is it character_NONE? ($FF)
  JR Z,cb_bribe_not_found ; Jump if so
  LD C,A                  ; Copy the bribed character to C
; Iterate over non-player characters.
  LD B,$07                ; Set B for seven iterations
  LD HL,$8020             ; Point HL at the second visible character
; Start loop
cb_bribe_loop:
  LD A,C                  ; Copy bribed character to A
  CP (HL)                 ; Is this vischar the bribed character?
  JR Z,cb_bribed_visible  ; Jump if so
  LD A,$20                ; Step HL to the next vischar
  ADD A,L                 ;
  LD L,A                  ;
  DJNZ cb_bribe_loop      ; ...loop
cb_bribe_not_found:
  POP HL                  ; Restore vischar.flags pointer
; Bribed character was not visible: hostiles lose interest and resume following their original route.
  LD (HL),$00             ; Clear vischar.flags
  INC L                   ;
  JP get_target_assign_pos ; Exit via get_target_assign_pos
; Found the bribed character in vischars: hostiles target him.
cb_bribed_visible:
  LD A,$0F                ; Advance HL to vischar.mi.pos
  ADD A,L                 ;
  LD L,A                  ;
  POP DE                  ; Get the vischar pointer
  PUSH DE                 ;
  LD A,E                  ; Point DE at vischar.target
  ADD A,$03               ;
  LD E,A                  ;
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Is it zero?
  JP NZ,cb_bribed_indoors ; Jump if not
; Outdoors
  CALL pos_to_tinypos     ; Scale down the bribed character's position to this vischar's target field
  JR cb_bribed_done       ; (else)
; Indoors
cb_bribed_indoors:
  LDI                     ; Scale down the bribed character's position to this vischar's target field
  INC L                   ;
  LDI                     ;
cb_bribed_done:
  POP HL                  ; Restore the vischar pointer
  JR cb_move              ; Jump to 'move'
cb_check_halt:
  INC L                   ; Advance HL to vischar.route.index
  LD A,(HL)               ; Fetch it
  DEC L                   ; Step back
  AND A                   ; Is it routeindex_0_HALT? ($00)
  JR Z,cb_set_input       ; Jump if so (set input)
cb_move:
  LD A,(HL)               ; Get vischar.flags
  EXX                     ; Bank
  LD C,A                  ; C = flags
; Select a scaling routine.
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Is it outdoors? (zero)
  JR Z,cb_scaling_door    ; Jump if so
cb_scaling_indoors:
  LD HL,multiply_by_1     ; Point HL at multiply_by_1
  JR cb_self_modify       ; (else)
cb_scaling_door:
  BIT 6,C                 ; Is vischar.flags vischar_FLAGS_TARGET_IS_DOOR set?
  JR Z,cb_scaling_outdoors ; Jump if not
  LD HL,multiply_by_4     ; Point HL at multiply_by_4
  JR cb_self_modify       ; (else)
cb_scaling_outdoors:
  LD HL,multiply_by_8     ; Point HL at multiply_by_8
; Self modify vischar_move_x/y routines.
cb_self_modify:
  LD ($CA13),HL           ; Self-modify vischar_move_x
  LD ($CA4B),HL           ; Self-modify vischar_move_y
  EXX                     ; Unbank
; If the vischar_BYTE7_Y_DOMINANT flag is set then cb_move_y_dominant is used instead of the code below, which is x dominant. i.e. It means "try moving y then x, rather than x then y". This is the code which makes characters alternate
; left/right when navigating.
  BIT 5,(IY+$07)          ; Does the vischar's counter_and_flags field have flag vischar_BYTE7_Y_DOMINANT set? ($20)
  JR NZ,cb_move_y_dominant ; Jump if so
cb_move_x_dominant:
  INC L                   ; Advance HL to vischar.position.x
  INC L                   ;
  INC L                   ;
  CALL vischar_move_x     ; Call vischar_move_x
  JR NZ,cb_set_input      ; If it couldn't move call vischar_move_y
  CALL vischar_move_y     ;
  JP Z,target_reached     ; If it still couldn't move exit via target_reached
; This entry point is used by the routine at target_reached.
cb_set_input:
  CP (IY+$0D)             ; Is our new input different from the vischar's existing input?
  RET Z                   ; Return if not
  OR $80                  ; Otherwise set the input_KICK flag
  LD (IY+$0D),A           ;
  RET                     ; Return
cb_move_y_dominant:
  LD A,$04                ; Advance HL to vischar.position.y
  ADD A,L                 ;
  LD L,A                  ;
  CALL vischar_move_y     ; Call vischar_move_y
  JR NZ,cb_set_input      ; If it couldn't move call vischar_move_x
  CALL vischar_move_x     ;
  JR NZ,cb_set_input      ; If it could move, jump to cb_set_input
  DEC L                   ; Rewind HL to vischar.position.x
  JP target_reached       ; Exit via target_reached

; Move a character on the X axis.
;
; Used by the routine at character_behaviour.
;
; I:HL Pointer to vischar.target.
; I:IY Pointer to visible character block.
; O:A New input: input_RIGHT + input_DOWN (8) if x > pos.x, input_LEFT + input_UP (4) if x < pos.x, input_NONE (0) if x == pos.x
; O:F Z set if zero returned, NZ otherwise
; O:HL Pointer to visible character block + 5. (Ready to pass into vischar_move_y)
vischar_move_x:
  LD A,(HL)               ; Read vischar.target.x (target position)
  CALL multiply_by_8      ; Multiply it by 1, 4 or 8 (self modified by cb_self_modify)
  LD A,L                  ; Point HL at vischar.mi.pos.x (current position)
  ADD A,$0B               ;
  LD L,A                  ;
  LD E,(HL)               ; Read vischar.mi.pos.x
  INC L                   ;
  LD D,(HL)               ;
  EX DE,HL                ; Free up HL
  SBC HL,BC               ; Compute the delta: current position - target position
  JR Z,vmx_equal          ; Jump if it's zero
  JP M,vmx_negative       ; Jump if it's negative
; The delta was positive
vmx_positive:
  LD A,H                  ; Delta >= 256?
  AND A                   ;
  JR NZ,vmx_delta_too_big ; Jump if so
  LD A,L                  ; Delta < 3?
  CP $03                  ;
  JR C,vmx_equal          ; Jump if it's in range
; The delta was three or greater
vmx_delta_too_big:
  LD A,$08                ; Return input_RIGHT + input_DOWN (6 + 2)
  RET                     ;
; The delta was negative
vmx_negative:
  LD A,H                  ; Delta < -256?
  CP $FF                  ;
  JR NZ,vmx_delta_too_small ; Jump if so
  LD A,L                  ; Delta >= -2?
  CP $FE                  ;
  JP NC,vmx_equal         ; Jump if it's in range
; The delta was less than negative three
vmx_delta_too_small:
  LD A,$04                ; Return input_LEFT + input_UP (3 + 1)
  RET                     ;
; The delta was -2..2
vmx_equal:
  EX DE,HL                ; Move vischar back into HL
  LD A,L                  ; Point HL at vischar->mi.pos.x
  SUB $0B                 ;
  LD L,A                  ;
  SET 5,(IY+$07)          ; Set vischar.counter_and_flags flag vischar_BYTE7_Y_DOMINANT so that next time we'll use vischar_move_y in preference
  XOR A                   ; Return input_NONE (0)
  RET                     ;

; Move a character on the Y axis.
;
; Used by the routine at character_behaviour.
;
; Nearly identical to vischar_move_x above.
;
; I:HL Pointer to vischar.target.
; I:IY Pointer to visible character block.
; O:A New input: input_LEFT + input_DOWN (5) if y > pos.y, input_RIGHT + input_UP (7) if y < pos.y, input_NONE (0) if y == pos.y
; O:F Z set if zero returned, NZ otherwise
; O:HL Pointer to visible character block + 4. (Ready to pass into vischar_move_x)
vischar_move_y:
  LD A,(HL)               ; Read vischar.target.y (target position)
  CALL multiply_by_8      ; Multiply it by 1, 4 or 8 (self modified by C9DD)
  LD A,L                  ; Point HL at vischar.mi.pos.y (current position)
  ADD A,$0C               ;
  LD L,A                  ;
  LD E,(HL)               ; Read vischar.mi.pos.y
  INC L                   ;
  LD D,(HL)               ;
  EX DE,HL                ; Free up HL
  SBC HL,BC               ; Compute the delta: current position - target position
  JR Z,vmy_equal          ; Jump if it's zero
  JP M,vmy_negative       ; Jump if it's negative
; The delta was positive
vmy_positive:
  LD A,H                  ; Delta >= 256?
  AND A                   ;
  JR NZ,vmy_delta_too_big ; Jump if so
  LD A,L                  ; Delta < 3?
  CP $03                  ;
  JR C,vmy_equal          ; Jump if it's in range
; The delta was three or greater
vmy_delta_too_big:
  LD A,$05                ; Return input_LEFT + input_DOWN (3 + 2)
  RET                     ;
; The delta was negative
vmy_negative:
  LD A,H                  ; Delta < -256?
  CP $FF                  ;
  JR NZ,vmy_delta_too_small ; Jump if so
  LD A,L                  ; Delta >= -2?
  CP $FE                  ;
  JP NC,vmy_equal         ; Jump if it's in range
; The delta was less than negative three
vmy_delta_too_small:
  LD A,$07                ; Return input_RIGHT + input_UP (6 + 1)
  RET                     ;
; The delta was -2..2
vmy_equal:
  EX DE,HL                ; Move vischar back into HL
  LD A,L                  ; Point HL at vischar->mi.pos.y
  SUB $0E                 ;
  LD L,A                  ;
  RES 5,(IY+$07)          ; Clear vischar.counter_and_flags flag vischar_BYTE7_Y_DOMINANT so that next time we'll use vischar_move_x in preference
  XOR A                   ; Return input_NONE (0)
  RET                     ;

; Called when a character reaches its target.
;
; Used by the routine at character_behaviour.
;
; I:IY Pointer to a vischar
; I:HL Pointer to vischar + 4 bytes
target_reached:
  LD A,(IY+$01)           ; Fetch the vischar.flags
  LD C,A                  ; Copy to C for the door check later
; Check for a pursuit mode.
  AND $3F                 ; Mask with vischar_FLAGS_MASK to get the pursuit mode
  JR Z,tr_door_check      ; Jump if not in a pursuit mode
; We're in one of the pursuit modes - find out which one.
  CP $01                  ; Is it vischar_PURSUIT_PURSUE?
  JR NZ,tr_not_pursue     ; Jump if not
tr_pursue:
  LD A,(bribed_character) ; Is this vischar the (pending) bribed character?
  CP (IY+$00)             ;
  JP Z,accept_bribe       ; Jump to accept_bribe if so (exit via)
  JP solitary             ; Otherwise the pursuing character caught its target. This must be the case when a guard pursues the hero, so send the hero to solitary (exit via)
tr_not_pursue:
  CP $02                  ; Is it vischar_PURSUIT_HASSLE?
  RET Z                   ; Exit if so
  CP $04                  ; Is it vischar_PURSUIT_SAW_BRIBE?
  RET Z                   ; Exit if so
; Otherwise we're in vischar_PURSUIT_DOG_FOOD mode. automatics() only permits dogs to enter this mode.
;
; Decide how long remains until the food is discovered. Use 32 if the food is poisoned, 255 otherwise.
  PUSH HL                 ; Save the vischar pointer
  LD HL,item_structs_food ; Point HL at item_structs_food
  BIT 5,(HL)              ; Is the itemstruct_ITEM_FLAG_POISONED flag set?
  LD A,$20                ; Set the counter to 32 irrespectively
  JR Z,tr_set_food_counter ; Jump if the flag was set
  LD A,$FF                ; Otherwise set the counter to 255
tr_set_food_counter:
  LD (food_discovered_counter),A ; Assign food_discovered_counter
  POP HL                  ; Restore the vischar pointer
  DEC L                   ; Rewind HL to point at vischar.route.index
  DEC L                   ;
; This dog has been poisoned, so make it halt.
  XOR A                   ; vischar.route.index = routeindex_0_HALT
  LD (HL),A               ;
  JP cb_set_input         ; Exit via character_behaviour_set_input (A is zero here: that's passed as the new input)
tr_door_check:
  BIT 6,C                 ; Is the flag vischar_FLAGS_TARGET_IS_DOOR set?
  JR Z,tr_set_route       ; Jump if not
; Handle the door - this results in the character entering.
  DEC L                   ; Rewind HL to point at vischar.route.step
  LD C,(HL)               ; Fetch route.step
  DEC L                   ; Rewind
  LD A,(HL)               ; Fetch route.index
  PUSH HL                 ; Preserve route pointer
  CALL get_route          ; Call get_route. A is the index arg. A route *data* pointer is returned in DE
  POP HL                  ; Restore route pointer
  LD A,E                     ; Advance the route data pointer by 'step' bytes
  ADD A,C                    ;
  LD E,A                     ;
  JR NC,tr_routebyte_is_door ;
  INC D                      ;
tr_routebyte_is_door:
  LD A,(DE)               ; Fetch a route byte, which here is a door index
  BIT 7,(HL)              ; Is the route index's route_REVERSED flag set? ($80)
  JR Z,tr_store_door      ; Jump if not
  XOR $80                 ; Otherwise toggle the reverse flag
tr_store_door:
  PUSH AF                 ; Preserve the door index
  LD A,(HL)               ; Fetch route.index
  INC L                   ; Advance to route.step
; Pattern: [-2]+1
  BIT 7,A                 ; If the route is reversed then step backwards, otherwise step forwards
  JR Z,tr_route_step      ;
  DEC (HL)                ;
  DEC (HL)                ;
tr_route_step:
  INC (HL)                ;
; Get the door structure for the door index and start processing it.
  POP AF                  ; Restore door index
  CALL get_door           ; Call get_door. A door_t pointer is returned in HL
  LD A,(HL)               ; Fetch door.room_and_direction
  RRA                     ; Discard the bottom two bits
  RRA                     ;
  AND $3F                 ; Extract the room index
  LD (IY+$1C),A           ; Move the vischar to that room (vischar.room = room index)
; In which direction is the door facing?
  LD A,(HL)               ; Fetch door.room_and_direction
  AND $03                 ; Mask against door_FLAGS_MASK_DIRECTION
; Each door in the doors array is a pair of two "half doors" where each half represents one side of the doorway. We test the direction of the half door we find ourselves pointing at and use it to find the counterpart door's position.
  CP $02                  ; Is it direction_TOP_*?
  JP NC,tr_door_top       ; Jump if not
  INC HL                  ; Point HL at door[1].pos
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  JR tr_door_found        ;
tr_door_top:
  DEC HL                  ; Otherwise point HL at door[-1].pos
  DEC HL                  ;
  DEC HL                  ;
tr_door_found:
  PUSH HL                 ; Preserve the door.pos pointer
  PUSH IY                 ; Copy the current visible character pointer into HL
  POP HL                  ;
  LD A,L                  ; Is this vischar the hero?
  AND A                   ;
  JP NZ,tr_transition     ; Jump if not
; Hero's vischar only.
  INC L                   ; Advance HL to point at vischar.flags
  RES 6,(HL)              ; Clear vischar.flags vischar_FLAGS_TARGET_IS_DOOR flag
  INC L                   ; Advance HL to point at vischar.route
  CALL get_target_assign_pos ; Call get_target_assign_pos
tr_transition:
  POP HL                  ; Restore the door.pos pointer
  CALL transition         ; Call transition
  LD BC,$2030             ; Play the "character enters 1" sound
  CALL play_speaker       ;
  RET                     ; Return
tr_set_route:
  DEC L                   ; Point HL at vischar.route.index
  DEC L                   ;
  LD A,(HL)               ; Load the route.index
  CP $FF                  ; Is it routeindex_255_WANDER?
  JR Z,get_target_assign_pos ; Jump if so
  INC L                   ; Advance HL to vischar.route.step
; Pattern: [-2]+1
  BIT 7,A                    ; If the route is reversed then step backwards, otherwise step forwards
  JR Z,tr_another_route_step ;
  DEC (HL)                   ;
  DEC (HL)                   ;
tr_another_route_step:
  INC (HL)                   ;
  DEC L                   ; Rewind HL to vischar.route.index
; FALL THROUGH to get_target_assign_pos.

; Calls get_target then puts coords in vischar.target and set flags.
;
; Used by the routines at set_route, accept_bribe, character_behaviour, target_reached and route_ended.
;
; I:HL Pointer to route
get_target_assign_pos:
  PUSH HL                 ; Preserve the route pointer
  CALL get_target         ; Get our next target - a location, a door or 'route ends'. The result is returned in A, target pointer returned in HL
  CP $FF                  ; Did get_target return get_target_ROUTE_ENDS? ($FF)
  JP NZ,handle_target     ; Jump if not
  POP HL                  ; Restore the route pointer
; FALL THROUGH into route_ended.

; Called when get_target has run out of route.
;
; Used by the routine at spawn_character.
;
; If not the hero's vischar ...
route_ended:
  LD A,L                  ; Is this the hero's vischar?
  CP $02                  ;
  JP Z,do_character_event ; Jump if so
; Non-player ...
  LD A,(IY+$00)           ; Load vischar.character
  AND $1F                 ; Mask with vischar_CHARACTER_MASK to get character index
  JR NZ,route_ended_0     ; Jump if not character_0_COMMANDANT
; Call character_event at the end of commandant route 36.
  LD A,(HL)               ; Fetch route.index
  AND $7F                 ; Mask off routeindexflag_REVERSED
  CP $24                  ; Is it routeindex_36_GO_TO_SOLITARY?
  JR Z,do_character_event ; Jump if so
  XOR A                   ; Force next if statement to be taken
; Reverse the route for guards 1..11. They have fixed roles so either stand still or march back and forth along their route.
route_ended_0:
  CP $0C                  ; Is the character index <= character_11_GUARD_11?
  JR C,reverse_route      ; Jump if so
; We arrive here if: - vischar is the hero, or - character is character_0_COMMANDANT and (route.index & $7F) == 36, or - character is >= character_12_GUARD_12
do_character_event:
  PUSH HL
  CALL character_event    ; character_event()
  POP HL
  LD A,(HL)               ; Fetch route.index
  AND A                   ; Is it routeindex_0_HALT?
  RET Z                   ; Return 0 if so
  JR get_target_assign_pos ; Otherwise exit via get_target_assign_pos() // re-enters/loops?
; We arrive here if: - vischar is not the hero, and - character is character_0_COMMANDANT and (route.index & $7F) != 36, or - character is character_1_GUARD_1 .. character_11_GUARD_11
reverse_route:
  LD A,(HL)               ; Toggle route direction flag routeindexflag_REVERSED ($80)
  XOR $80                 ;
  LD (HL),A               ;
  INC HL                  ;
; Pattern: [-2]+1
  BIT 7,A                 ; If the route is reversed then step backwards, otherwise forwards
  JR Z,route_ended_1      ;
  DEC (HL)                ;
  DEC (HL)                ;
route_ended_1:
  INC (HL)                ;
  DEC HL                  ;
  XOR A                   ; Return 0
  RET                     ;
  DEFB $18,$09            ; Unreferenced bytes

; "Didn't hit end of list" case. -- not really a routine in its own right
;
; Used by the routine at get_target_assign_pos.
handle_target:
  CP $80                  ; Was the result of get_target get_target_DOOR? ($80)
  JP NZ,handle_target_0   ; Jump if not
  SET 6,(IY+$01)          ; Set vischar.flags flag vischar_FLAGS_TARGET_IS_DOOR
handle_target_0:
  POP DE                  ; Restore the route pointer
  INC E                   ; Copy HL (ptr to doorpos or location) to vischar->target
  INC E                   ;
  LD BC,$0002             ;
  LDIR                    ;
  LD A,$80                ; (This return value is never used)
  RET                     ; Return

; Widen A to BC (multiply by 1).
multiply_by_1:
  LD C,A                  ; Widen A into BC
  LD B,$00                ;
  RET                     ; Return

; Return a route.
;
; Used by the routines at get_target and target_reached.
;
; I:A Index.
; O:DE Pointer to route data.
get_route:
  ADD A,A                 ; Point DE at routes[A]
  LD E,A                  ;
  LD D,$00                ;
  LD HL,routes            ;
  ADD HL,DE               ;
  LD E,(HL)               ;
  INC HL                  ;
  LD D,(HL)               ;
  RET                     ; Return

; Pseudo-random number generator.
;
; This returns the bottom nibbles of the bytes from $9000..$90FF in sequence, acting as a cheap pseudo-random number generator.
;
; Used by the routine at get_target.
;
; O:A Pseudo-random number from 0..15.
; O:HL Preserved.
random_nibble:
  PUSH HL                 ; Preserve HL
  LD HL,(prng_pointer)    ; Point at the prng_pointer (initialised on load to $9000)
  INC L                   ; Increment its bottom byte, wrapping at $90FF
  LD A,(HL)               ; Fetch a byte from the pointer
  AND $0F                 ; Mask off the bottom nibble
  LD (prng_pointer),HL    ; Save the incremented prng_pointer
  POP HL                  ; Restore HL
  RET                     ; Return

; Unreferenced bytes.
LCB92:
  DEFB $13,$40,$30,$10,$7E,$F0

; Send the hero to solitary.
;
; Used by the routines at escaped, collision, target_reached and action_papers.
;
; Silence the bell.
solitary:
  LD A,$FF                ; Set the bell ring counter/flag to bell_STOP
  LD (bell),A             ;
; Seize hero's held items.
  LD HL,items_held        ; Point HL at items_held[0]
  LD C,(HL)               ; Fetch the item
  LD (HL),A               ; Set it to item_NONE
  CALL item_discovered    ; Discover the item
  LD HL,$8216             ; Point HL at items_held[1]
  LD C,(HL)               ; Fetch the item
  LD (HL),$FF             ; Set it to item_NONE
  CALL item_discovered    ; Discover the item
  CALL draw_all_items     ; Redraw both held items
; Discover all items.
  LD B,$10                ; Set B to 16 iterations - once per item
  LD HL,$76C9             ; Point HL at item_structs[0].room
; Start loop
solitary_0:
  PUSH BC                 ; Preserve loop counter
  PUSH HL                 ; Preserve itemstruct pointer
; Is the item outdoors?
  LD A,(HL)               ; Fetch itemstruct.room_and_flags
  AND $3F                 ; Mask off the room part. Is the item indoors?
  JR NZ,solitary_next     ; Jump if so
  DEC HL                  ; Point HL at itemstruct.item_and_flags
  LD A,(HL)               ; Fetch it
  INC HL                  ; Advance HL to itemstruct.pos.x
  INC HL                  ;
  EX DE,HL                ; Bank itemstruct pointer
  EX AF,AF'               ; Bank item_and_flags
  XOR A                   ; Set area index to zero
; Start loop
solitary_1:
  PUSH AF                 ; Preserve area index
  PUSH DE                 ; Preserve itemstruct pointer
; If the item is within the camp bounds then it will be discovered.
  CALL within_camp_bounds ; Is the specified position within the bounds of the indexed area?
  JR Z,solitary_discovered ; Jump if so
  POP DE                  ; Restore itemstruct pointer
  POP AF                  ; Restore area index
  INC A                   ; Loop until area index is 3
  CP $03                  ;
  JP NZ,solitary_1        ;
  JR solitary_next        ; Jump to next
solitary_discovered:
  POP DE                  ; Restore itemstruct pointer
  POP AF                  ; Restore area index
  EX AF,AF'               ; Unbank item_and_flags
  LD C,A                  ; Discover the item
  CALL item_discovered    ;
solitary_next:
  POP HL                  ; Restore itemstruct pointer
  POP BC                  ; Restore loop counter
  LD DE,$0007             ; Advance HL to the next itemstruct
  ADD HL,DE               ;
  DJNZ solitary_0         ; ...loop
; Move the hero to solitary.
  LD A,$18                ; Set vischar[0].room to room_24_SOLITARY
  LD ($801C),A            ;
; DPT: I reckon this should instead be 24 which is the door between room_22_REDKEY and room_24_SOLITARY.
  LD A,$14                ; Set the global current door to 20
  LD (current_door),A     ;
  LD B,$23                ; Decrease morale by 35
  CALL decrease_morale    ;
  CALL reset_map_and_characters ; Reset all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, lock the gates, reset all beds, clear the mess halls and reset characters
; Set the commandant on a path which results in the hero being released.
  LD DE,$7613             ; Point DE at character_structs[character_0_COMMANDANT].room
  LD HL,solitary_commandant_data ; Point HL at solitary_commandant_data
  LD BC,$0006             ; Copy six bytes
  LDIR                    ;
; Queue solitary messages.
  LD B,$0D                ; Queue the message "YOU ARE IN SOLITARY"
  CALL queue_message      ;
  LD B,$0E                ; Queue the message "WAIT FOR RELEASE"
  CALL queue_message      ;
  LD B,$13                ; Queue the message "ANOTHER DAY DAWNS"
  CALL queue_message      ;
  LD A,$FF                ; Inhibit user input
  LD (in_solitary),A      ;
  XOR A                           ; Immediately take automatic control of the hero
  LD (automatic_player_counter),A ;
  LD HL,sprite_prisoner   ; Set vischar.mi.sprite to the prisoner sprite set
  LD ($8015),HL           ;
  LD HL,solitary_pos      ; Point HL at solitary_pos for transition
  LD IY,$8000             ; Point IY at the hero's vischar
  LD (IY+$0E),$03         ; Set vischar.direction to direction_BOTTOM_LEFT
  XOR A                   ; Set hero's route.index to routeindex_0_HALT
  LD ($8002),A            ;
  JP transition           ; Exit via transition

; Partial character struct.
;
; (<- solitary)
solitary_commandant_data:
  DEFB $00                ; room  = room_0_OUTDOORS
  DEFB $74,$64,$03        ; pos   = 116, 100, 3
  DEFB $24,$00            ; route = 36, 0

; Guards follow suspicious character.
;
; This routine decides whether the given vischar pursues the hero. - The commandant can see through the hero's disguise if he's wearing the guard's uniform, but other guards do not. - Bribed characters will ignore the hero. - When outdoors,
; line of sight checking is used to determine if the hero will be pursued. - If the red_flag is in effect the hero will be pursued, otherwise he will just be hassled.
;
; Used by the routine at automatics.
;
; I:IY Pointer to visible character.
guards_follow_suspicious_character:
  PUSH IY                 ; Copy vischar pointer into HL
  POP HL                  ;
  LD A,(HL)               ; Fetch the character index
; Wearing the uniform stops anyone but the commandant from pursuing the hero.
  AND A                   ; Is it character_0_COMMANDANT?
  JR Z,gfsc_chk_bribe     ; Jump if so (the commandant sees through the disguise)
  LD A,($8015)            ; Read the bottom byte of the hero's sprite set pointer
  LD DE,sprite_guard      ; Point DE at the guard sprite set
  CP E                    ; Return if they match
  RET Z                   ;
; If this (hostile) character saw the bribe being used then ignore the hero.
gfsc_chk_bribe:
  INC L                   ; Advance HL to point at vischar.flags
  LD A,(HL)               ; Fetch vischar.flags
  CP $04                  ; Is it vischar_PURSUIT_SAW_BRIBE?
  RET Z                   ; Return if the bribe was seen
; Do line of sight checking when outdoors.
  DEC L                   ; Rewind HL to point at vischar.character
  LD A,L                  ; Point HL at vischar.mi.pos
  ADD A,$0F               ;
  LD L,A                  ;
  LD DE,tinypos_stash_x   ; Point DE at tinypos_stash_x
  LD A,(room_index)       ; If the global current room index is room_0_OUTDOORS...
  AND A                   ;
  JP NZ,gfsc_chk_flag     ;
  CALL pos_to_tinypos     ; Scale down vischar's map position (HL) and assign the result to tinypos_stash (DE). DE is updated to point after tinypos_stash on return
  LD HL,hero_map_position_x ; Point HL at hero_map_position.x
  LD DE,tinypos_stash_x   ; Point DE at tinypos_stash_x
  LD A,(IY+$0E)           ; Get this vischar's direction
; Check for TL/BR directions.
  RRA                     ; Shift out the bottom direction bit into carry
  LD C,A                  ; Save (rotated direction byte) in C
  JR C,gfsc_chk_seen_x    ; Jump if not TL or BR
; Handle TL/BR directions.
;
; Does the hero approximately match our Y coordinate?
gfsc_chk_seen_y:
  INC HL                  ; Advance HL to hero_map_position.y
  INC DE                  ; Advance DE to tinypos_stash_y
  LD A,(DE)               ; Fetch tinypos_stash_y
  DEC A                   ; Return if (tinypos_stash_y - 1) >= hero_map_position.y
  CP (HL)                 ;
  RET NC                  ;
  ADD A,$02               ; Return if (tinypos_stash_y + 1) < hero_map_position.y
  CP (HL)                 ;
  RET C                   ;
; Are we facing the hero?
  DEC HL                  ; Rewind to hero_map_position_x
  DEC DE                  ; Rewind to tinypos_stash_x
  LD A,(DE)               ; Set carry if tinypos_stash_x < hero_map_position_x
  CP (HL)                 ;
  BIT 0,C                 ; Check bit 1 of direction byte (direction_BOTTOM_*?)
  JR NZ,guards_follow_suspicious_character_0 ; Jump if set?
  CCF                     ; Otherwise invert the carry flag
guards_follow_suspicious_character_0:
  RET C                   ; Return if set
  JR gfsc_chk_flag        ; (else)
; Handle TR/BL directions.
;
; Does the hero approximately match our X coordinate?
gfsc_chk_seen_x:
  LD A,(DE)               ; Fetch tinypos_stash_x
  DEC A                   ; Return if (tinypos_stash_x - 1) >= hero_map_position_x
  CP (HL)                 ;
  RET NC                  ;
  ADD A,$02               ; Return if (tinypos_stash_x + 1) < hero_map_position_x
  CP (HL)                 ;
  RET C                   ;
; Are we facing the hero?
  INC HL                  ; Advance to hero_map_position_y
  INC DE                  ; Advance to tinypos_stash_y
  LD A,(DE)               ; Set carry if tinypos_stash_y < hero_map_position_y
  CP (HL)                 ;
  BIT 0,C                 ; Check bit 1 of direction byte (direction_BOTTOM_*?)
  JR NZ,guards_follow_suspicious_character_1 ; Jump if set?
  CCF                     ; Otherwise invert the carry flag
guards_follow_suspicious_character_1:
  RET C                   ; Return if set
gfsc_chk_flag:
  LD A,(red_flag)         ; Is red_flag set?
  AND A                   ;
  JR NZ,gfsc_bell         ; Jump if so
; Hostiles *not* in guard towers hassle the hero.
  LD A,(IY+$13)           ; Fetch vischar.mi.pos.height
  CP $20                  ; Return if it's 32 or greater
  RET NC                  ;
  LD (IY+$01),$02         ; Set vischar's flags to vischar_PURSUIT_HASSLE
  RET                     ; Return
gfsc_bell:
  XOR A                   ; Make the bell ring perpetually
  LD (bell),A             ;
  CALL hostiles_pursue    ; Call hostiles_pursue
  RET                     ; Return

; Hostiles pursue prisoners.
;
; Used by the routines at automatics, guards_follow_suspicious_character, is_item_discoverable and event_roll_call.
;
; For all visible, hostile characters, at height < 32, set the bribed/pursue flag.
;
; Research: If I nop this out then guards don't spot the items I drop. Iterate non-player characters.
hostiles_pursue:
  LD HL,$8020             ; Point HL at the second vischar
  LD DE,$0020             ; Prepare the vischar stride
  LD B,$07                ; Set B for seven iterations
; Start loop
hp_loop:
  PUSH HL                 ; Preserve the vischar pointer
  LD A,(HL)               ; Fetch vischar.character
; Include hostiles only.
  CP $14                  ; Is it character_20_PRISONER_1 or above?
  JR NC,hp_next           ; Jump if so
; Exclude the guards placed high up in towers and over the gate.
  LD A,$13                ; Point HL at vischar.mi.pos.height
  ADD A,L                 ;
  LD L,A                  ;
  LD A,(HL)               ; Fetch vischar.mi.pos.height
  CP $20                  ; Is it 32 or above?
  JR NC,hp_next           ; Jump if so
  LD A,L                  ; Point HL at vischar.flags
  SUB $12                 ;
  LD L,A                  ;
  LD (HL),$01             ; Set vischar.flags to vischar_PURSUIT_PURSUE
hp_next:
  POP HL                  ; Restore the vischar pointer
  ADD HL,DE               ; Advance the vischar pointer
  DJNZ hp_loop            ; ...loop
  RET                     ; Return

; Is item discoverable?
;
; Used by the routine at automatics.
;
; Searches item_structs for items dropped nearby. If items are found the hostiles are made to pursue the hero.
;
; Green key and food items are ignored.
is_item_discoverable:
  LD A,(room_index)       ; Get the global current room index
  AND A                   ; Is it room_0_OUTDOORS?
  JR Z,is_item_discoverable_0 ; Jump if so
; Interior.
  CALL is_item_discoverable_interior ; Is the item discoverable indoors?
  RET NZ                  ; Return if not found
; Item was found.
  CALL hostiles_pursue    ; Hostiles pursue prisoners
  RET                     ; Return
; Exterior.
is_item_discoverable_0:
  LD HL,$76C9             ; Point HL at item_structs[0].room
  LD DE,$0007             ; Prepare the itemstruct stride
  LD B,$10                ; Set B for 16 iterations -- number of itemstructs
; Start loop
is_item_discoverable_1:
  BIT 7,(HL)              ; Is itemstruct.item_and_flags itemstruct_ROOM_FLAG_NEARBY_7 flag set?
  JR NZ,iid_nearby        ; Jump if so
iid_next:
  ADD HL,DE               ; Advance to the next itemstruct
  DJNZ is_item_discoverable_1 ; ..loop
  RET                     ; Return
; Suspected bug: HL is decremented, but not re-incremented before 'goto next'. So it must be reading a byte early when iteration is resumed. Consequences? I think it'll screw up when multiple items are in range.
iid_nearby:
  DEC HL
  LD A,(HL)               ; A = *HL & itemstruct_ITEM_MASK; // sampled HL=$772A (&item_structs[item_PURSE].item)
  AND $0F                 ;
; The green key and food items are ignored.
  CP $0B                  ; Is it item_GREEN_KEY?
  JR Z,iid_next           ; Jump to next iteration if so
  CP $07                  ; Is it item_FOOD?
  JR Z,iid_next           ; Jump to next iteration if so
  CALL hostiles_pursue    ; Otherwise, hostiles pursue prisoners
  RET                     ; Return

; Is an item discoverable indoors?
;
; A discoverable item is one which has been moved away from its default room, and one that isn't the red cross parcel.
;
; Used by the routines at move_characters and is_item_discoverable.
;
; I:A Room index to check against
; O:C Item (if found)
; O:F Z set if found, Z clear otherwise
is_item_discoverable_interior:
  LD C,A                  ; Save the room index in C
  LD HL,$76C9             ; Point HL at the first item_struct's room member
  LD B,$10                ; Set B for 16 iterations (item__LIMIT)
; Start loop
iidi_loop:
  LD A,(HL)               ; Load the room index and flags
  AND $3F                 ; Extract the room index
; Is the item in the specified room?
  CP C                    ; Same room?
  JR NZ,iidi_next         ; Jump if not
  PUSH HL                 ; Preserve the item_struct pointer
; Has the item been moved to a room other than its default?
;
; Bug: room_and_flags doesn't get its flags masked off in the following sequence. However, the only default_item which uses the flags is the wiresnips. The DOS version of the game fixes this.
  DEC HL                  ; Fetch item_and_flags
  LD A,(HL)               ;
  AND $0F                 ; Mask off the item
  LD E,A                  ; Multiply by three - the array stride
  ADD A,A                 ;
  ADD A,E                 ;
  LD E,A                  ; Widen to 16-bit
  LD D,$00                ;
  LD HL,default_item_locations ; Add to default_item_locations
  ADD HL,DE                    ;
  LD A,(HL)               ; Fetch the default item room_and_flags
  CP C                    ; Same room? (bug: not masked)
  JR NZ,iidi_not_default_room ; Jump if not
  POP HL                  ; Restore the item_struct pointer
iidi_next:
  LD DE,$0007             ; Step HL to the next item_struct
  ADD HL,DE               ;
  DJNZ iidi_loop          ; ...loop
  RET                     ; Return with NZ set (not found)
iidi_not_default_room:
  POP HL                  ; Restore the item_struct pointer
  DEC HL                  ; Fetch item_and_flags
  LD A,(HL)               ;
  AND $0F                 ; Mask off the item
; Ignore the red cross parcel.
  CP $0C                  ; Is this item the red cross parcel? (item_RED_CROSS_PARCEL)
  JR NZ,iidi_found        ; Jump if not
  INC HL                  ; Otherwise advance HL to room_and_flags
  JR iidi_next            ; Jump to the next iteration
iidi_found:
  LD C,A                  ; Return the item's index in C
  XOR A                   ; Return with Z set (found)
  RET                     ;

; An item is discovered.
;
; Used by the routines at reset_game, move_characters, automatics and solitary.
;
; I:C Item index.
item_discovered:
  LD A,C                  ; Copy item index to A
  CP $FF                  ; Is it item_NONE? ($FF)
  RET Z                   ; Return if so
  AND $0F                 ; Mask against itemstruct_ITEM_MASK
  PUSH AF                 ; Preserve A while we do calls
  LD B,$10                ; Queue the message "ITEM DISCOVERED"
  CALL queue_message      ;
  LD B,$05                ; Decrease morale by 5
  CALL decrease_morale    ;
  POP AF                  ; Restore A
  ADD A,A                      ; Point HL at default_item_locations[A]
  ADD A,C                      ;
  LD HL,default_item_locations ;
  LD D,$00                     ;
  LD E,A                       ;
  ADD HL,DE                    ;
  LD A,(HL)               ; Load default_item_location.room_and_flags
  EX DE,HL                ; Bank default_item_location pointer
  EX AF,AF'               ; Bank room_and_flags
; Bug: C is not masked, so could go out of range.
  LD A,C                  ; Copy item index to A
  CALL item_to_itemstruct ; Convert the item index into an itemstruct pointer in HL
  RES 7,(HL)              ; Wipe the itemstruct.item_and_flags itemstruct_ITEM_FLAG_HELD flag
  EX DE,HL                ; Unbank default_item_location pointer
  INC DE                  ; Advance DE to itemstruct.room_and_flags
  LD BC,$0003             ; Copy room_and_flags and pos from default_item_location
  LDIR                    ;
  EX DE,HL                ; Swap itemstruct pointer back into HL
  EX AF,AF'               ; Unbank room_and_flags
  AND A                   ; Is it room_0_OUTDOORS?
  JR NZ,id_interior       ; Jump if not
  LD (HL),A               ; Set height to zero. Note A is already zero
  JP calc_exterior_item_iso_pos ; Exit via calc_exterior_item_iso_pos
id_interior:
  LD (HL),$05             ; Set height to 5
  JP calc_interior_item_iso_pos ; Exit via calc_interior_item_iso_pos

; Default locations of items.
;
; An array of 16 three-byte structures.
;
; +------+-------+----------------+---------------------------------------+
; | Type | Bytes | Name           | Meaning                               |
; +------+-------+----------------+---------------------------------------+
; | Byte | 1     | room_and_flags | Room index; bits 6,7 = flags (T.B.D.) |
; | Byte | 1     | x              | X position                            |
; | Byte | 1     | y              | Y position                            |
; +------+-------+----------------+---------------------------------------+
;
; #define ITEM_ROOM(room_no, flags) ((room_no & 0x3F) | (flags << 6)) do the next flags mean that the wiresnips are always or /never/ found?
default_item_locations:
  DEFB $FF,$40,$20        ; item_WIRESNIPS        { ITEM_ROOM(room_NONE, 3),       ... }
  DEFB $09,$3E,$30        ; item_SHOVEL           { ITEM_ROOM(room_9, 0),          ... }
  DEFB $0A,$49,$24        ; item_LOCKPICK         { ITEM_ROOM(room_10, 0),         ... }
  DEFB $0B,$2A,$3A        ; item_PAPERS           { ITEM_ROOM(room_11, 0),         ... }
  DEFB $0E,$32,$18        ; item_TORCH            { ITEM_ROOM(room_14, 0),         ... }
  DEFB $3F,$24,$2C        ; item_BRIBE            { ITEM_ROOM(room_NONE, 0),       ... }
  DEFB $0F,$2C,$41        ; item_UNIFORM          { ITEM_ROOM(room_15, 0),         ... }
  DEFB $13,$40,$30        ; item_FOOD             { ITEM_ROOM(room_19, 0),         ... }
  DEFB $01,$42,$34        ; item_POISON           { ITEM_ROOM(room_1, 0),          ... }
  DEFB $16,$3C,$2A        ; item_RED_KEY          { ITEM_ROOM(room_22, 0),         ... }
  DEFB $0B,$1C,$22        ; item_YELLOW_KEY       { ITEM_ROOM(room_11, 0),         ... }
  DEFB $00,$4A,$48        ; item_GREEN_KEY        { ITEM_ROOM(room_0_OUTDOORS, 0), ... }
  DEFB $3F,$1C,$32        ; item_RED_CROSS_PARCEL { ITEM_ROOM(room_NONE, 0),       ... }
  DEFB $12,$24,$3A        ; item_RADIO            { ITEM_ROOM(room_18, 0),         ... }
  DEFB $3F,$1E,$22        ; item_PURSE            { ITEM_ROOM(room_NONE, 0),       ... }
  DEFB $3F,$34,$1C        ; item_COMPASS          { ITEM_ROOM(room_NONE, 0),       ... }

; Data for the four classes of characters. (<- spawn_character)
character_meta_data_commandant:
  DEFW animations         ; &animations[0]
  DEFW sprite_commandant  ; sprite_commandant
character_meta_data_guard:
  DEFW animations         ; &animations[0]
  DEFW sprite_guard       ; sprite_guard
character_meta_data_dog:
  DEFW animations         ; &animations[0]
  DEFW sprite_dog         ; sprite_dog
character_meta_data_prisoner:
  DEFW animations         ; &animations[0]
  DEFW sprite_prisoner    ; sprite_prisoner

; Indices into animations.
;
; none, up, down, left, up+left, down+left, right, up+right, down+right, fire
;
; Groups of nine. (<- animate)
animindices:
  DEFB $08,$00,$04,$87,$00,$87,$04,$04,$04 ; TL
  DEFB $09,$84,$05,$05,$84,$05,$01,$01,$05 ; TR
  DEFB $0A,$85,$02,$06,$85,$06,$85,$85,$02 ; BR
  DEFB $0B,$07,$86,$03,$07,$03,$07,$07,$86 ; BL
  DEFB $14,$0C,$8C,$93,$0C,$93,$10,$10,$8C ; TL + crawl
  DEFB $15,$90,$11,$8D,$90,$95,$0D,$0D,$11 ; TR + crawl
  DEFB $16,$8E,$0E,$12,$8E,$0E,$91,$91,$0E ; BR + crawl
  DEFB $17,$13,$92,$0F,$13,$0F,$8F,$8F,$92 ; BL + crawl

; Animation states.
;
; Array, 24 long, of pointers to data.
animations:
  DEFW anim_walk_tl       ; anim_walk_tl
  DEFW anim_walk_tr       ; anim_walk_tr
  DEFW anim_walk_br       ; anim_walk_br
  DEFW anim_walk_bl       ; anim_walk_bl
  DEFW anim_turn_tl       ; anim_turn_tl
  DEFW anim_turn_tr       ; anim_turn_tr
  DEFW anim_turn_br       ; anim_turn_br
  DEFW anim_turn_bl       ; anim_turn_bl
  DEFW anim_wait_tl       ; anim_wait_tl
  DEFW anim_wait_tr       ; anim_wait_tr
  DEFW anim_wait_br       ; anim_wait_br
  DEFW anim_wait_bl       ; anim_wait_bl
  DEFW anim_crawl_tl      ; anim_crawl_tl
  DEFW anim_crawl_tr      ; anim_crawl_tr
  DEFW anim_crawl_br      ; anim_crawl_br
  DEFW anim_crawl_bl      ; anim_crawl_bl
  DEFW anim_crawlturn_tl  ; anim_crawlturn_tl
  DEFW anim_crawlturn_tr  ; anim_crawlturn_tr
  DEFW anim_crawlturn_br  ; anim_crawlturn_br
  DEFW anim_crawlturn_bl  ; anim_crawlturn_bl
  DEFW anim_crawlwait_tl  ; anim_crawlwait_tl
  DEFW anim_crawlwait_tr  ; anim_crawlwait_tr
  DEFW anim_crawlwait_br  ; anim_crawlwait_br
  DEFW anim_crawlwait_bl  ; anim_crawlwait_bl

; Sprites: objects which can move.
;
; This include STOVE, CRATE, PRISONER, CRAWL, DOG, GUARD and COMMANDANT.
;
; Structure: (b) width in bytes + 1, (b) height in rows, (w) data ptr, (w) mask ptr
;
; 'tl' => character faces top left of the screen
;
; 'br' => character faces bottom right of the screen
sprite_stove:
  DEFB $03,$16,$46,$DB,$72,$DB ; 3, 22, &bitmap_stove, &mask_stove } // (16x22,$DB46,$DB72)
sprite_crate:
  DEFB $04,$18,$B6,$DA,$FE,$DA ; 4, 24, &bitmap_crate, &mask_crate } // (24x24,$DAB6,$DAFE)
; Glitch: All of the prisoner sprites are one row too high.
sprite_prisoner:
  DEFB $03,$1B,$8C,$D2,$45,$D5 ; 3, 27, &bitmap_prisoner_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x27,$D28C,$D545)
  DEFB $03,$1C,$56,$D2,$05,$D5 ; 3, 28, &bitmap_prisoner_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x28,$D256,$D505)
  DEFB $03,$1C,$20,$D2,$C5,$D4 ; 3, 28, &bitmap_prisoner_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x28,$D220,$D4C5)
  DEFB $03,$1C,$EA,$D1,$85,$D4 ; 3, 28, &bitmap_prisoner_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x28,$D1EA,$D485)
  DEFB $03,$1B,$C0,$D2,$85,$D5 ; 3, 27, &bitmap_prisoner_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x27,$D2C0,$D585)
  DEFB $03,$1D,$F4,$D2,$C5,$D5 ; 3, 29, &bitmap_prisoner_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x29,$D2F4,$D5C5)
  DEFB $03,$1C,$2C,$D3,$05,$D6 ; 3, 28, &bitmap_prisoner_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x28,$D32C,$D605)
  DEFB $03,$1C,$62,$D3,$3D,$D6 ; 3, 28, &bitmap_prisoner_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D362,$D63D)
  DEFB $04,$10,$C5,$D3,$77,$D6 ; 4, 16, &bitmap_crawl_facing_bottom_left_1, &mask_crawl_facing_bottom_left } // (24x16,$D3C5,$D677)
  DEFB $04,$0F,$98,$D3,$77,$D6 ; 4, 15, &bitmap_crawl_facing_bottom_left_2, &mask_crawl_facing_bottom_left } // (24x15,$D398,$D677)
  DEFB $04,$10,$F5,$D3,$55,$D4 ; 4, 16, &bitmap_crawl_facing_top_left_1, &mask_crawl_facing_top_left } // (24x16,$D3F5,$D455)
  DEFB $04,$10,$25,$D4,$55,$D4 ; 4, 16, &bitmap_crawl_facing_top_left_2, &mask_crawl_facing_top_left } // (24x16,$D425,$D455)
sprite_dog:
  DEFB $04,$10,$67,$D8,$21,$D9 ; 4, 16, &bitmap_dog_facing_top_left_1, &mask_dog_facing_top_left } // (24x16,$D867,$D921)
  DEFB $04,$10,$97,$D8,$21,$D9 ; 4, 16, &bitmap_dog_facing_top_left_2, &mask_dog_facing_top_left } // (24x16,$D897,$D921)
  DEFB $04,$0F,$C7,$D8,$21,$D9 ; 4, 15, &bitmap_dog_facing_top_left_3, &mask_dog_facing_top_left } // (24x15,$D8C7,$D921)
  DEFB $04,$0F,$F4,$D8,$21,$D9 ; 4, 15, &bitmap_dog_facing_top_left_4, &mask_dog_facing_top_left } // (24x15,$D8F4,$D921)
  DEFB $04,$0E,$51,$D9,$F9,$D9 ; 4, 14, &bitmap_dog_facing_bottom_right_1, &mask_dog_facing_bottom_right } // (24x14,$D951,$D9F9)
  DEFB $04,$0F,$7B,$D9,$F9,$D9 ; 4, 15, &bitmap_dog_facing_bottom_right_2, &mask_dog_facing_bottom_right } // (24x15,$D97B,$D9F9)
; Glitch: The height of following sprite is two rows too high.
  DEFB $04,$0F,$A8,$D9,$F9,$D9 ; 4, 15, &bitmap_dog_facing_bottom_right_3, &mask_dog_facing_bottom_right } // (24x15,$D9A8,$D9F9)
  DEFB $04,$0E,$CF,$D9,$F9,$D9 ; 4, 14, &bitmap_dog_facing_bottom_right_4, &mask_dog_facing_bottom_right } // (24x14,$D9CF,$D9F9)
sprite_guard:
  DEFB $03,$1B,$4D,$D7,$45,$D5 ; 3, 27, &bitmap_guard_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x27,$D74D,$D545)
  DEFB $03,$1D,$13,$D7,$05,$D5 ; 3, 29, &bitmap_guard_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x29,$D713,$D505)
  DEFB $03,$1B,$DD,$D6,$C5,$D4 ; 3, 27, &bitmap_guard_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x27,$D6DD,$D4C5)
  DEFB $03,$1B,$A7,$D6,$85,$D4 ; 3, 27, &bitmap_guard_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x27,$D6A7,$D485)
  DEFB $03,$1D,$83,$D7,$85,$D5 ; 3, 29, &bitmap_guard_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x29,$D783,$D585)
  DEFB $03,$1D,$BD,$D7,$C5,$D5 ; 3, 29, &bitmap_guard_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x29,$D7BD,$D5C5)
  DEFB $03,$1C,$F7,$D7,$05,$D6 ; 3, 28, &bitmap_guard_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x28,$D7F7,$D605)
  DEFB $03,$1C,$2F,$D8,$3D,$D6 ; 3, 28, &bitmap_guard_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D82F,$D63D)
sprite_commandant:
  DEFB $03,$1C,$D6,$D0,$45,$D5 ; 3, 28, &bitmap_commandant_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x28,$D0D6,$D545)
  DEFB $03,$1E,$9A,$D0,$05,$D5 ; 3, 30, &bitmap_commandant_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x30,$D09A,$D505)
  DEFB $03,$1D,$60,$D0,$C5,$D4 ; 3, 29, &bitmap_commandant_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x29,$D060,$D4C5)
  DEFB $03,$1D,$26,$D0,$85,$D4 ; 3, 29, &bitmap_commandant_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x29,$D026,$D485)
  DEFB $03,$1B,$0E,$D1,$85,$D5 ; 3, 27, &bitmap_commandant_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x27,$D10E,$D585)
  DEFB $03,$1C,$44,$D1,$C5,$D5 ; 3, 28, &bitmap_commandant_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x28,$D144,$D5C5)
  DEFB $03,$1B,$7C,$D1,$05,$D6 ; 3, 27, &bitmap_commandant_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x27,$D17C,$D605)
  DEFB $03,$1C,$B2,$D1,$3D,$D6 ; 3, 28, &bitmap_commandant_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D1B2,$D63D)

; Animations.
;
; Read by routine around $B64F (animate)
anim_crawlwait_tl:
  DEFB $01,$04,$04,$FF,$00,$00,$00,$0A
anim_crawlwait_tr:
  DEFB $01,$05,$05,$FF,$00,$00,$00,$8A
anim_crawlwait_br:
  DEFB $01,$06,$06,$FF,$00,$00,$00,$88
anim_crawlwait_bl:
  DEFB $01,$07,$07,$FF,$00,$00,$00,$08
anim_walk_tl:
  DEFB $04,$00,$00,$02,$02,$00,$00,$00,$02,$00,$00,$01,$02,$00,$00,$02,$02,$00,$00,$03
anim_walk_tr:
  DEFB $04,$01,$01,$03,$00,$02,$00,$80,$00,$02,$00,$81,$00,$02,$00,$82,$00,$02,$00,$83
anim_walk_br:
  DEFB $04,$02,$02,$00,$FE,$00,$00,$04,$FE,$00,$00,$05,$FE,$00,$00,$06,$FE,$00,$00,$07
anim_walk_bl:
  DEFB $04,$03,$03,$01,$00,$FE,$00,$84,$00,$FE,$00,$85,$00,$FE,$00,$86,$00,$FE,$00,$87
anim_wait_tl:
  DEFB $01,$00,$00,$FF,$00,$00,$00,$00
anim_wait_tr:
  DEFB $01,$01,$01,$FF,$00,$00,$00,$80
anim_wait_br:
  DEFB $01,$02,$02,$FF,$00,$00,$00,$04
anim_wait_bl:
  DEFB $01,$03,$03,$FF,$00,$00,$00,$84
anim_turn_tl:
  DEFB $02,$00,$01,$FF,$00,$00,$00,$00,$00,$00,$00,$80
anim_turn_tr:
  DEFB $02,$01,$02,$FF,$00,$00,$00,$80,$00,$00,$00,$04
anim_turn_br:
  DEFB $02,$02,$03,$FF,$00,$00,$00,$04,$00,$00,$00,$84
anim_turn_bl:
  DEFB $02,$03,$00,$FF,$00,$00,$00,$84,$00,$00,$00,$00
anim_crawl_tl:
  DEFB $02,$04,$04,$02,$02,$00,$00,$0A,$02,$00,$00,$0B
anim_crawl_tr:
  DEFB $02,$05,$05,$03,$00,$02,$00,$8A,$00,$02,$00,$8B
anim_crawl_br:
  DEFB $02,$06,$06,$00,$FE,$00,$00,$88,$FE,$00,$00,$89
anim_crawl_bl:
  DEFB $02,$07,$07,$01,$00,$FE,$00,$08,$00,$FE,$00,$09
anim_crawlturn_tl:
  DEFB $02,$04,$05,$FF,$00,$00,$00,$0A,$00,$00,$00,$8A
anim_crawlturn_tr:
  DEFB $02,$05,$06,$FF,$00,$00,$00,$8A,$00,$00,$00,$88
anim_crawlturn_br:
  DEFB $02,$06,$07,$FF,$00,$00,$00,$88,$00,$00,$00,$08
anim_crawlturn_bl:
  DEFB $02,$07,$04,$FF,$00,$00,$00,$08,$00,$00,$00,$0A

; Sprite bitmaps and masks.
bitmap_commandant_facing_top_left_4:
  DEFB $00,$00,$00,$60,$00,$F0,$00,$F8 ; bitmap: COMMANDANT FACING TOP LEFT 4
  DEFB $00,$FC,$01,$7C,$01,$78,$00,$04 ;
  DEFB $00,$FE,$03,$FE,$07,$FA,$07,$FA ;
  DEFB $06,$FA,$0E,$F6,$0E,$C6,$0E,$38 ;
  DEFB $06,$F8,$06,$E0,$09,$98,$04,$58 ;
  DEFB $03,$B0,$03,$B0,$01,$80,$02,$70 ;
  DEFB $03,$B0,$01,$B0,$07,$B0,$01,$30 ;
  DEFB $00,$20                         ;
bitmap_commandant_facing_top_left_3:
  DEFB $00,$00,$00,$60,$00,$F0,$00,$F8 ; bitmap: COMMANDANT FACING TOP LEFT 3
  DEFB $00,$FC,$01,$7C,$01,$78,$00,$00 ;
  DEFB $00,$FC,$03,$FE,$03,$FA,$07,$FA ;
  DEFB $06,$F6,$06,$F6,$0E,$C6,$0D,$3A ;
  DEFB $15,$F8,$1B,$F6,$03,$C8,$04,$18 ;
  DEFB $07,$D8,$03,$80,$02,$30,$01,$D0 ;
  DEFB $01,$C0,$00,$E0,$01,$60,$00,$60 ;
  DEFB $00,$C0                         ;
bitmap_commandant_facing_top_left_2:
  DEFB $00,$00,$00,$60,$00,$F0,$00,$F8 ; bitmap: COMMANDANT FACING TOP LEFT 2
  DEFB $00,$FC,$01,$7C,$01,$78,$00,$04 ;
  DEFB $01,$FE,$03,$FE,$07,$FA,$07,$FA ;
  DEFB $06,$FA,$06,$F4,$0E,$CA,$0E,$3A ;
  DEFB $0D,$F8,$05,$E0,$0B,$98,$04,$50 ;
  DEFB $03,$D0,$07,$A0,$03,$A0,$03,$40 ;
  DEFB $00,$A0,$03,$B0,$03,$A0,$01,$80 ;
  DEFB $07,$80,$01,$80                 ;
bitmap_commandant_facing_top_left_1:
  DEFB $00,$00,$00,$60,$00,$F0,$00,$F8 ; bitmap: COMMANDANT FACING TOP LEFT 1
  DEFB $00,$FC,$01,$7C,$01,$78,$00,$04 ;
  DEFB $00,$FE,$03,$FE,$07,$FA,$06,$FA ;
  DEFB $06,$FA,$07,$7A,$03,$64,$07,$18 ;
  DEFB $06,$F8,$0A,$F0,$0D,$CC,$02,$1C ;
  DEFB $07,$D8,$07,$D8,$03,$A0,$04,$38 ;
  DEFB $07,$B8,$03,$98,$0B,$18,$07,$30 ;
bitmap_commandant_facing_bottom_right_1:
  DEFB $00,$00,$01,$C0,$03,$E0,$07,$C0 ; bitmap: COMMANDANT FACING BOTTOM RIGHT 1
  DEFB $03,$B0,$00,$60,$01,$80,$06,$B0 ;
  DEFB $0F,$78,$1F,$A8,$3F,$B0,$3B,$B0 ;
  DEFB $77,$A8,$37,$8C,$20,$74,$17,$B0 ;
  DEFB $37,$80,$0B,$A0,$0C,$60,$0F,$40 ;
  DEFB $0E,$00,$01,$40,$07,$40,$07,$00 ;
  DEFB $07,$00,$03,$00,$03,$C0         ;
bitmap_commandant_facing_bottom_right_2:
  DEFB $00,$00,$01,$C0,$03,$E0,$07,$C0 ; bitmap: COMMANDANT FACING BOTTOM RIGHT 2
  DEFB $03,$B0,$00,$60,$01,$80,$02,$B0 ;
  DEFB $0F,$68,$1F,$B0,$1F,$B0,$1B,$B0 ;
  DEFB $3B,$A8,$3B,$88,$34,$70,$37,$B0 ;
  DEFB $37,$A8,$07,$10,$28,$B8,$0F,$B8 ;
  DEFB $0F,$60,$0E,$10,$01,$70,$0E,$70 ;
  DEFB $0E,$60,$0C,$38,$0E,$00,$03,$00 ;
bitmap_commandant_facing_bottom_right_3:
  DEFB $00,$00,$01,$C0,$03,$E0,$07,$C0 ; bitmap: COMMANDANT FACING BOTTOM RIGHT 3
  DEFB $03,$B0,$00,$60,$01,$80,$02,$B0 ;
  DEFB $07,$68,$0F,$B0,$0F,$B0,$1D,$B0 ;
  DEFB $1B,$A8,$1B,$88,$1C,$74,$0A,$B4 ;
  DEFB $06,$A0,$09,$90,$0E,$70,$0F,$70 ;
  DEFB $06,$E0,$08,$00,$1E,$E0,$1C,$E0 ;
  DEFB $18,$E0,$18,$60,$08,$70         ;
bitmap_commandant_facing_bottom_right_4:
  DEFB $00,$00,$01,$C0,$03,$E0,$07,$C0 ; bitmap: COMMANDANT FACING BOTTOM RIGHT 4
  DEFB $03,$B0,$00,$60,$01,$80,$06,$B0 ;
  DEFB $0F,$68,$1F,$A8,$1F,$B0,$3B,$B0 ;
  DEFB $3B,$B0,$3B,$88,$30,$70,$37,$B0 ;
  DEFB $0F,$A8,$37,$10,$08,$70,$07,$60 ;
  DEFB $03,$40,$04,$A0,$07,$60,$07,$40 ;
  DEFB $06,$C0,$06,$80,$03,$60,$00,$60 ;
bitmap_prisoner_facing_top_left_4:
  DEFB $00,$00,$00,$F0,$01,$F0,$01,$C0 ; bitmap: PRISONER FACING TOP LEFT 4
  DEFB $00,$F0,$01,$00,$00,$78,$03,$FC ;
  DEFB $07,$F4,$07,$F4,$06,$F4,$0E,$F4 ;
  DEFB $0D,$E8,$0D,$94,$0C,$78,$15,$F8 ;
  DEFB $1B,$D8,$07,$D8,$0F,$B0,$0F,$70 ;
  DEFB $07,$70,$07,$70,$03,$60,$03,$60 ;
  DEFB $0C,$60,$03,$00,$00,$60         ;
bitmap_prisoner_facing_top_left_3:
  DEFB $00,$00,$00,$F0,$01,$F0,$01,$C0 ; bitmap: PRISONER FACING TOP LEFT 3
  DEFB $00,$F0,$01,$00,$00,$78,$03,$FC ;
  DEFB $07,$F4,$07,$F4,$0F,$EC,$0E,$EC ;
  DEFB $1D,$EC,$1B,$94,$54,$70,$6F,$F4 ;
  DEFB $0F,$D0,$0F,$D0,$07,$B0,$07,$A0 ;
  DEFB $07,$A0,$07,$40,$03,$40,$03,$80 ;
  DEFB $05,$80,$00,$40,$03,$C0         ;
bitmap_prisoner_facing_top_left_2:
  DEFB $00,$00,$00,$F0,$01,$F0,$01,$C0 ; bitmap: PRISONER FACING TOP LEFT 2
  DEFB $00,$F0,$01,$00,$00,$78,$01,$FC ;
  DEFB $03,$F4,$07,$F4,$06,$F4,$06,$F4 ;
  DEFB $0E,$E4,$0D,$94,$0C,$78,$15,$F8 ;
  DEFB $1B,$D8,$07,$D8,$0F,$D0,$07,$D0 ;
  DEFB $07,$A0,$07,$A0,$03,$A0,$03,$40 ;
  DEFB $01,$60,$06,$00,$03,$00         ;
bitmap_prisoner_facing_top_left_1:
  DEFB $00,$00,$00,$F0,$01,$F0,$01,$C0 ; bitmap: PRISONER FACING TOP LEFT 1
  DEFB $00,$F0,$01,$00,$00,$70,$01,$F8 ;
  DEFB $03,$F8,$07,$F8,$06,$F0,$0E,$F0 ;
  DEFB $0E,$E8,$06,$88,$06,$70,$02,$F0 ;
  DEFB $05,$D0,$06,$D0,$09,$B0,$0F,$A0 ;
  DEFB $0F,$60,$0E,$E0,$0E,$E0,$0C,$40 ;
  DEFB $34,$20,$18,$E0                 ;
bitmap_prisoner_facing_bottom_right_1:
  DEFB $00,$00,$03,$80,$05,$C0,$07,$80 ; bitmap: PRISONER FACING BOTTOM RIGHT 1
  DEFB $04,$40,$03,$80,$0D,$60,$1E,$E0 ;
  DEFB $3E,$F0,$37,$50,$35,$50,$77,$50 ;
  DEFB $6F,$38,$6E,$54,$51,$CC,$5F,$C0 ;
  DEFB $9E,$C0,$DE,$C0,$0F,$40,$0F,$40 ;
  DEFB $07,$00,$07,$00,$16,$00,$16,$00 ;
  DEFB $05,$00,$03,$80                 ;
bitmap_prisoner_facing_bottom_right_2:
  DEFB $00,$00,$03,$80,$05,$C0,$07,$80 ; bitmap: PRISONER FACING BOTTOM RIGHT 2
  DEFB $04,$40,$03,$80,$0D,$40,$1E,$E0 ;
  DEFB $3E,$E0,$37,$50,$75,$50,$77,$50 ;
  DEFB $77,$50,$34,$30,$33,$C0,$37,$D0 ;
  DEFB $0F,$40,$37,$60,$0F,$60,$3E,$E0 ;
  DEFB $1E,$C0,$1E,$C0,$1D,$80,$1D,$00 ;
  DEFB $1A,$80,$09,$C0,$14,$00,$0E,$00 ;
bitmap_prisoner_facing_bottom_right_3:
  DEFB $00,$00,$03,$80,$05,$C0,$07,$80 ; bitmap: PRISONER FACING BOTTOM RIGHT 3
  DEFB $04,$40,$03,$80,$0D,$40,$1E,$E0 ;
  DEFB $1E,$E0,$37,$40,$35,$40,$37,$40 ;
  DEFB $37,$40,$1A,$20,$19,$C0,$05,$C0 ;
  DEFB $0D,$40,$13,$60,$1E,$E0,$1E,$E0 ;
  DEFB $1C,$C0,$3D,$C0,$39,$80,$31,$80 ;
  DEFB $50,$40,$60,$E0,$30,$00         ;
bitmap_prisoner_facing_bottom_right_4:
  DEFB $00,$00,$03,$80,$05,$C0,$07,$80 ; bitmap: PRISONER FACING BOTTOM RIGHT 4
  DEFB $04,$40,$03,$80,$0D,$60,$1E,$E0 ;
  DEFB $1E,$F0,$3B,$50,$39,$50,$37,$50 ;
  DEFB $37,$50,$36,$30,$21,$C8,$2F,$E8 ;
  DEFB $17,$60,$37,$60,$0F,$60,$1F,$40 ;
  DEFB $07,$40,$06,$C0,$0E,$80,$0D,$80 ;
  DEFB $08,$00,$05,$80,$0E,$C0         ;
bitmap_crawl_facing_bottom_left_2:
  DEFB $00,$00,$00,$00,$0A,$00,$00,$39 ; bitmap: CRAWL FACING BOTTOM RIGHT 2
  DEFB $80,$00,$FE,$C0,$03,$FE,$C0,$07 ;
  DEFB $FE,$C0,$08,$FE,$C0,$07,$7D,$CC ;
  DEFB $0F,$7B,$D6,$2F,$B5,$F8,$37,$38 ;
  DEFB $E0,$C0,$18,$00,$40,$30,$00,$00 ;
  DEFB $10,$00,$00,$60,$00             ;
bitmap_crawl_facing_bottom_left_1:
  DEFB $00,$00,$00,$00,$0A,$00,$00,$3D ; bitmap: CRAWL FACING BOTTOM RIGHT 1
  DEFB $80,$00,$FE,$80,$03,$FE,$C0,$03 ;
  DEFB $FE,$D8,$0D,$FD,$CC,$1E,$FB,$A0 ;
  DEFB $1E,$F7,$98,$1E,$77,$2C,$0C,$EF ;
  DEFB $F0,$30,$EF,$C0,$10,$C7,$00,$01 ;
  DEFB $80,$00,$01,$00,$00,$06,$00,$00 ;
bitmap_crawl_facing_top_left_1:
  DEFB $03,$80,$00,$07,$A0,$00,$07,$78 ; bitmap: CRAWL FACING TOP LEFT 1
  DEFB $00,$06,$FE,$00,$01,$FC,$00,$07 ;
  DEFB $F3,$80,$CF,$EF,$C0,$BE,$DF,$40 ;
  DEFB $10,$3F,$40,$00,$3E,$C0,$00,$7D ;
  DEFB $C0,$00,$73,$80,$00,$79,$C0,$00 ;
  DEFB $1A,$E8,$00,$03,$2C,$00,$01,$04 ;
bitmap_crawl_facing_top_left_2:
  DEFB $03,$80,$00,$07,$80,$00,$06,$78 ; bitmap: CRAWL FACING TOP LEFT 2
  DEFB $00,$05,$FE,$00,$03,$F8,$00,$07 ;
  DEFB $F7,$80,$07,$6F,$C0,$03,$9F,$40 ;
  DEFB $37,$9F,$40,$2F,$1F,$00,$00,$1F ;
  DEFB $00,$00,$1E,$00,$00,$0E,$C0,$00 ;
  DEFB $0F,$00,$00,$07,$60,$00,$01,$30 ;
mask_crawl_facing_top_left:
  DEFB $F8,$1F,$FF,$F0,$07,$FF,$F0,$01 ; mask: CRAWL FACING TOP LEFT (shared)
  DEFB $FF,$F0,$00,$FF,$F8,$00,$7F,$30 ;
  DEFB $00,$3F,$00,$00,$1F,$00,$00,$1F ;
  DEFB $00,$00,$1F,$80,$00,$1F,$D0,$00 ;
  DEFB $1F,$FF,$00,$3F,$FF,$00,$17,$FF ;
  DEFB $80,$03,$FF,$E0,$01,$FF,$F8,$01 ;
mask_various_facing_top_left_4:
  DEFB $FE,$0F,$FC,$07,$F8,$03,$FC,$01 ; mask: VARIOUS FACING TOP LEFT 4
  DEFB $FC,$01,$F8,$01,$FC,$01,$F8,$00 ;
  DEFB $F0,$00,$F0,$00,$E0,$00,$E0,$00 ;
  DEFB $E0,$00,$C0,$00,$C0,$01,$C0,$03 ;
  DEFB $C0,$01,$E0,$01,$C0,$01,$E0,$01 ;
  DEFB $E0,$01,$E0,$01,$E0,$03,$E0,$07 ;
  DEFB $C0,$07,$E0,$07,$F0,$07,$F8,$07 ;
  DEFB $FE,$8F,$FF,$DF,$FF,$FF,$FF,$FF ;
mask_various_facing_top_left_3:
  DEFB $FE,$0F,$FC,$07,$F8,$03,$FC,$01 ; mask: VARIOUS FACING TOP LEFT 3
  DEFB $FC,$01,$F8,$01,$FC,$01,$F8,$01 ;
  DEFB $F0,$00,$E0,$00,$C0,$00,$C0,$00 ;
  DEFB $C0,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$C0,$01,$C0,$03,$C0,$03 ;
  DEFB $C0,$03,$C0,$03,$80,$03,$80,$07 ;
  DEFB $C0,$0F,$E0,$0F,$F0,$0F,$F8,$0F ;
  DEFB $FE,$1F,$FF,$3F,$FF,$FF,$FF,$FF ;
mask_various_facing_top_left_2:
  DEFB $FE,$0F,$FC,$07,$F8,$07,$FC,$03 ; mask: VARIOUS FACING TOP LEFT 2
  DEFB $FC,$01,$F8,$01,$FC,$01,$F8,$01 ;
  DEFB $F0,$00,$E0,$00,$C0,$00,$C0,$00 ;
  DEFB $C0,$00,$C0,$01,$80,$00,$80,$00 ;
  DEFB $80,$01,$C0,$03,$80,$03,$C0,$03 ;
  DEFB $C0,$03,$C0,$03,$C0,$07,$C0,$0F ;
  DEFB $E0,$0F,$F0,$07,$F0,$0F,$E0,$1F ;
  DEFB $F0,$3F,$F8,$3F,$FE,$7F,$FF,$FF ;
mask_various_facing_top_left_1:
  DEFB $FE,$0F,$FC,$07,$F8,$03,$FC,$01 ; mask: VARIOUS FACING TOP LEFT 1
  DEFB $FC,$01,$F8,$01,$FC,$01,$FC,$00 ;
  DEFB $F8,$00,$F0,$00,$E0,$00,$E0,$01 ;
  DEFB $E0,$03,$E0,$03,$E0,$03,$F0,$03 ;
  DEFB $E0,$03,$E0,$01,$E0,$01,$E0,$03 ;
  DEFB $E0,$03,$E0,$03,$C0,$03,$C0,$03 ;
  DEFB $80,$03,$80,$03,$C0,$07,$E0,$CF ;
  DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;
mask_various_facing_bottom_right_1:
  DEFB $F8,$1F,$F0,$0F,$E0,$0F,$E0,$07 ; mask: VARIOUS FACING BOTTOM RIGHT 1
  DEFB $F0,$0F,$C0,$0F,$80,$07,$C0,$03 ;
  DEFB $80,$03,$00,$07,$00,$07,$00,$03 ;
  DEFB $00,$01,$00,$01,$00,$01,$00,$03 ;
  DEFB $00,$0F,$00,$0F,$00,$0F,$80,$07 ;
  DEFB $80,$07,$80,$07,$C0,$0F,$C0,$1F ;
  DEFB $E0,$3F,$E0,$1F,$F4,$0F,$FE,$1F ;
  DEFB $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ;
mask_various_facing_bottom_right_2:
  DEFB $F8,$1F,$F0,$0F,$E0,$0F,$E0,$07 ; mask: VARIOUS FACING BOTTOM RIGHT 2
  DEFB $F0,$0F,$E0,$0F,$C0,$07,$C0,$03 ;
  DEFB $80,$07,$80,$07,$00,$07,$00,$03 ;
  DEFB $00,$03,$00,$07,$80,$07,$80,$03 ;
  DEFB $C0,$07,$80,$03,$80,$03,$80,$07 ;
  DEFB $80,$07,$80,$07,$80,$07,$80,$07 ;
  DEFB $C0,$03,$E0,$03,$C0,$27,$E0,$3F ;
  DEFB $F0,$7F,$FF,$FF,$FF,$FF,$FF,$FF ;
mask_various_facing_bottom_right_3:
  DEFB $F8,$1F,$F0,$0F,$E0,$0F,$E0,$07 ; mask: VARIOUS FACING BOTTOM RIGHT 3
  DEFB $F0,$0F,$C0,$0F,$80,$07,$C0,$03 ;
  DEFB $C0,$07,$80,$07,$80,$07,$00,$03 ;
  DEFB $00,$03,$00,$01,$80,$01,$C0,$03 ;
  DEFB $80,$07,$80,$07,$80,$07,$80,$07 ;
  DEFB $80,$07,$80,$0F,$80,$07,$00,$07 ;
  DEFB $00,$0F,$00,$07,$83,$03,$C7,$C7 ;
mask_various_facing_bottom_right_4:
  DEFB $F8,$1F,$F0,$0F,$E0,$0F,$E0,$07 ; mask: VARIOUS FACING BOTTOM RIGHT 4
  DEFB $F0,$0F,$E0,$0F,$C0,$07,$C0,$03 ;
  DEFB $C0,$03,$80,$07,$80,$07,$00,$07 ;
  DEFB $00,$03,$00,$07,$80,$03,$80,$03 ;
  DEFB $80,$07,$80,$07,$80,$07,$80,$07 ;
  DEFB $80,$07,$80,$0F,$C0,$1F,$C0,$0F ;
  DEFB $E0,$1F,$C0,$0F,$E0,$07,$F0,$0F ;
  DEFB $F8,$FF                         ;
mask_crawl_facing_bottom_left:
  DEFB $FF,$F5,$FF,$FF,$C0,$7F,$FF,$00 ; mask: CRAWL FACING BOTTOM RIGHT (shared)
  DEFB $3F,$FC,$00,$1F,$F8,$00,$07,$F0 ;
  DEFB $00,$03,$E0,$00,$01,$C0,$00,$01 ;
  DEFB $C0,$00,$00,$80,$00,$01,$00,$00 ;
  DEFB $03,$00,$00,$0F,$06,$00,$3F,$AC ;
  DEFB $00,$FF,$F8,$0F,$FF,$F0,$1F,$FF ;
bitmap_guard_facing_top_left_4:
  DEFB $00,$00,$01,$E0,$03,$F0,$01,$F0 ; bitmap: GUARD FACING TOP LEFT 4
  DEFB $01,$E4,$02,$F4,$01,$08,$00,$7C ;
  DEFB $07,$FC,$07,$DC,$0F,$C4,$0E,$34 ;
  DEFB $0E,$F4,$1D,$C4,$1C,$38,$1A,$78 ;
  DEFB $1A,$DC,$03,$DC,$1B,$DC,$07,$DC ;
  DEFB $0F,$DC,$0F,$9C,$0F,$98,$07,$60 ;
  DEFB $18,$70,$0E,$B0,$00,$E0         ;
bitmap_guard_facing_top_left_3:
  DEFB $00,$00,$01,$E0,$03,$F0,$01,$F0 ; bitmap: GUARD FACING TOP LEFT 3
  DEFB $01,$E4,$02,$F4,$01,$04,$00,$78 ;
  DEFB $07,$FC,$0F,$AC,$1F,$8C,$18,$6C ;
  DEFB $1B,$E8,$3B,$C8,$B4,$30,$AC,$F0 ;
  DEFB $0D,$F8,$1F,$B8,$1F,$B8,$1F,$38 ;
  DEFB $1F,$38,$1F,$38,$3E,$38,$3D,$B0 ;
  DEFB $1D,$00,$03,$40,$06,$00         ;
bitmap_guard_facing_top_left_2:
  DEFB $00,$00,$01,$E0,$03,$F0,$01,$F0 ; bitmap: GUARD FACING TOP LEFT 2
  DEFB $01,$E4,$02,$F4,$01,$04,$00,$78 ;
  DEFB $07,$FC,$0F,$BC,$1F,$84,$1E,$74 ;
  DEFB $1D,$E8,$1B,$90,$38,$70,$34,$F8 ;
  DEFB $35,$B8,$0F,$B8,$2F,$B8,$0F,$B8 ;
  DEFB $1F,$B8,$1F,$B8,$1F,$90,$1F,$40 ;
  DEFB $0F,$40,$00,$00,$03,$00,$0B,$00 ;
  DEFB $06,$00                         ;
bitmap_guard_facing_top_left_1:
  DEFB $00,$00,$01,$E0,$03,$F0,$01,$F0 ; bitmap: GUARD FACING TOP LEFT 1
  DEFB $01,$E4,$02,$F4,$01,$04,$00,$78 ;
  DEFB $03,$FC,$07,$D8,$0F,$C4,$0C,$38 ;
  DEFB $0D,$F0,$0D,$C0,$0E,$38,$06,$78 ;
  DEFB $06,$D8,$09,$D8,$06,$D8,$09,$D8 ;
  DEFB $0F,$98,$0F,$98,$1F,$90,$1F,$40 ;
  DEFB $27,$70,$38,$00,$18,$00         ;
bitmap_guard_facing_bottom_right_1:
  DEFB $00,$00,$00,$00,$07,$80,$0F,$C0 ; bitmap: GUARD FACING BOTTOM RIGHT 1
  DEFB $0F,$80,$07,$40,$0C,$80,$23,$A0 ;
  DEFB $14,$70,$16,$D0,$6A,$D0,$EB,$50 ;
  DEFB $EB,$50,$65,$38,$74,$D4,$25,$4C ;
  DEFB $1A,$E0,$22,$E0,$36,$F0,$35,$70 ;
  DEFB $33,$B0,$3F,$B0,$3F,$A0,$1F,$80 ;
  DEFB $1E,$40,$01,$80,$0B,$80,$05,$E0 ;
  DEFB $00,$80                         ;
bitmap_guard_facing_bottom_right_2:
  DEFB $00,$00,$00,$00,$07,$80,$0F,$C0 ; bitmap: GUARD FACING BOTTOM RIGHT 2
  DEFB $0F,$80,$07,$40,$0C,$80,$13,$A0 ;
  DEFB $14,$70,$16,$D0,$16,$D0,$2B,$50 ;
  DEFB $6B,$50,$6B,$10,$68,$D0,$35,$68 ;
  DEFB $35,$68,$0A,$E0,$1A,$F0,$26,$F0 ;
  DEFB $35,$70,$33,$70,$3F,$60,$3F,$00 ;
  DEFB $3F,$60,$1C,$60,$03,$30,$06,$00 ;
  DEFB $03,$80                         ;
bitmap_guard_facing_bottom_right_3:
  DEFB $00,$00,$00,$00,$07,$80,$0F,$C0 ; bitmap: GUARD FACING BOTTOM RIGHT 3
  DEFB $0F,$80,$07,$40,$0C,$80,$23,$A0 ;
  DEFB $14,$60,$16,$D0,$2A,$D0,$2B,$50 ;
  DEFB $6B,$40,$75,$00,$74,$E0,$39,$60 ;
  DEFB $15,$60,$2C,$F0,$32,$F0,$36,$F0 ;
  DEFB $35,$70,$32,$F0,$3E,$C0,$3E,$30 ;
  DEFB $1E,$70,$60,$60,$70,$70,$38,$38 ;
bitmap_guard_facing_bottom_right_4:
  DEFB $00,$00,$00,$00,$07,$80,$0F,$C0 ; bitmap: GUARD FACING BOTTOM RIGHT 4
  DEFB $0F,$80,$07,$40,$0C,$80,$13,$A0 ;
  DEFB $14,$70,$16,$D0,$16,$D0,$2B,$50 ;
  DEFB $6B,$50,$6B,$10,$68,$D0,$35,$60 ;
  DEFB $35,$60,$0A,$E0,$1A,$F0,$25,$70 ;
  DEFB $2B,$70,$27,$B0,$3F,$B0,$1F,$80 ;
  DEFB $1F,$40,$0C,$80,$12,$C0,$0F,$60 ;
bitmap_dog_facing_top_left_1:
  DEFB $1A,$C0,$00,$1F,$80,$00,$0B,$80 ; bitmap: DOG FACING TOP LEFT 1
  DEFB $00,$04,$C0,$00,$03,$F0,$00,$03 ;
  DEFB $FC,$00,$01,$FF,$00,$0F,$FF,$C0 ;
  DEFB $13,$FF,$E0,$00,$7F,$E0,$00,$1F ;
  DEFB $E0,$00,$03,$D0,$00,$01,$D0,$00 ;
  DEFB $00,$88,$00,$00,$A0,$00,$03,$10 ;
bitmap_dog_facing_top_left_2:
  DEFB $1A,$80,$00,$1F,$C0,$00,$0B,$80 ; bitmap: DOG FACING TOP LEFT 2
  DEFB $00,$04,$C0,$00,$03,$F0,$00,$03 ;
  DEFB $F8,$00,$03,$FF,$00,$01,$FF,$C0 ;
  DEFB $01,$FF,$E0,$01,$7F,$E0,$03,$1B ;
  DEFB $E0,$06,$03,$D0,$00,$03,$B0,$00 ;
  DEFB $01,$D0,$00,$00,$40,$00,$00,$C0 ;
bitmap_dog_facing_top_left_3:
  DEFB $1A,$80,$00,$1F,$C0,$00,$0B,$80 ; bitmap: DOG FACING TOP LEFT 3
  DEFB $00,$04,$C0,$00,$03,$E0,$00,$03 ;
  DEFB $F8,$00,$03,$FF,$00,$03,$FF,$C0 ;
  DEFB $01,$FF,$E0,$01,$3F,$E0,$01,$DD ;
  DEFB $E0,$00,$03,$D0,$00,$01,$B0,$00 ;
  DEFB $00,$90,$00,$03,$00             ;
bitmap_dog_facing_top_left_4:
  DEFB $1A,$C0,$00,$1F,$80,$00,$0B,$80 ; bitmap: DOG FACING TOP LEFT 4
  DEFB $00,$04,$C0,$00,$03,$F0,$00,$03 ;
  DEFB $FC,$00,$03,$FF,$00,$01,$FF,$C0 ;
  DEFB $01,$FF,$E0,$03,$7F,$E0,$06,$BD ;
  DEFB $E0,$00,$03,$D0,$00,$03,$30,$00 ;
  DEFB $0E,$C8,$00,$01,$80             ;
mask_dog_facing_top_left:
  DEFB $C0,$1F,$FF,$C0,$1F,$FF,$E0,$3F ; mask: DOG FACING TOP LEFT (shared)
  DEFB $FF,$F0,$0F,$FF,$F8,$03,$FF,$F8 ;
  DEFB $00,$FF,$F0,$00,$3F,$E0,$00,$1F ;
  DEFB $C0,$00,$0F,$E8,$00,$0F,$F0,$00 ;
  DEFB $0F,$F0,$00,$07,$F9,$F0,$07,$FF ;
  DEFB $E0,$03,$FF,$F0,$07,$FF,$F8,$07 ;
bitmap_dog_facing_bottom_right_1:
  DEFB $00,$00,$00,$0E,$00,$00,$1F,$80 ; bitmap: DOG FACING BOTTOM RIGHT 1
  DEFB $00,$1F,$C0,$00,$1F,$F0,$00,$1F ;
  DEFB $F8,$00,$0F,$FD,$80,$0E,$FF,$00 ;
  DEFB $04,$FF,$C0,$08,$7E,$C0,$08,$1D ;
  DEFB $E0,$00,$0C,$60,$00,$02,$00,$00 ;
  DEFB $01,$80                         ;
bitmap_dog_facing_bottom_right_2:
  DEFB $00,$00,$00,$0E,$00,$00,$1F,$00 ; bitmap: DOG FACING BOTTOM RIGHT 2
  DEFB $00,$1F,$C0,$00,$1F,$E0,$00,$1F ;
  DEFB $F8,$00,$0F,$FD,$00,$1E,$FF,$00 ;
  DEFB $68,$FF,$C0,$00,$7E,$C0,$00,$1D ;
  DEFB $E0,$00,$18,$60,$00,$0A,$00,$00 ;
  DEFB $12,$00,$00,$08,$00             ;
bitmap_dog_facing_bottom_right_3:
  DEFB $00,$00,$00,$0C,$00,$00,$1F,$00 ; bitmap: DOG FACING BOTTOM RIGHT 3
  DEFB $00,$1F,$C0,$00,$1F,$E0,$00,$1F ;
  DEFB $F8,$00,$0F,$FD,$00,$0E,$FF,$00 ;
  DEFB $18,$FF,$C0,$09,$7E,$C0,$04,$19 ;
  DEFB $E0,$00,$6C,$60,$00,$1A,$00     ;
bitmap_dog_facing_bottom_right_4:
  DEFB $00,$00,$00,$0C,$00,$00,$1F,$00 ; bitmap: DOG FACING BOTTOM RIGHT 4
  DEFB $00,$1F,$C0,$00,$1F,$F0,$00,$0F ;
  DEFB $F8,$00,$0F,$FD,$80,$0E,$FF,$00 ;
  DEFB $06,$7F,$C0,$04,$7E,$C0,$02,$1D ;
  DEFB $E0,$01,$0A,$60,$00,$0D,$00,$00 ;
  DEFB $18,$00                         ;
mask_dog_facing_bottom_right:
  DEFB $F1,$FF,$FF,$E0,$7F,$FF,$C0,$3F ; mask: DOG FACING BOTTOM RIGHT (shared)
  DEFB $FF,$C0,$0F,$FF,$C0,$07,$FF,$C0 ;
  DEFB $02,$7F,$E0,$00,$3F,$80,$00,$3F ;
  DEFB $00,$00,$1F,$80,$00,$1F,$E0,$00 ;
  DEFB $0F,$F0,$00,$0F,$FE,$80,$1F,$FF ;
  DEFB $C0,$3F,$FF,$E0,$7F,$FF,$F7,$FF ;
bitmap_flag_up:
  DEFB $00,$00,$00,$00,$00,$7C,$00,$03 ; bitmap: FLAG UP
  DEFB $FE,$80,$1F,$FE,$E0,$FF,$8E,$7F ;
  DEFB $FC,$06,$7F,$E0,$06,$7F,$00,$7E ;
  DEFB $60,$03,$FE,$60,$1F,$FE,$30,$FF ;
  DEFB $FE,$3F,$FF,$0C,$3F,$FC,$1C,$3F ;
  DEFB $F0,$1C,$3F,$80,$F8,$30,$03,$F8 ;
  DEFB $70,$0F,$C0,$60,$7E,$00,$7F,$F8 ;
  DEFB $00,$FF,$E0,$00,$0F,$00,$00,$00 ;
  DEFB $00,$00                         ;
bitmap_flag_down:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ; bitmap: FLAG DOWN
  DEFB $00,$F8,$00,$00,$7F,$00,$00,$7F ;
  DEFB $E0,$00,$3F,$FC,$1C,$30,$FF,$FC ;
  DEFB $30,$1F,$FC,$30,$03,$D8,$3F,$00 ;
  DEFB $18,$3F,$E0,$18,$3F,$FC,$38,$3F ;
  DEFB $FF,$F0,$70,$FF,$F0,$60,$1F,$F0 ;
  DEFB $60,$07,$F0,$7F,$00,$F8,$FF,$E0 ;
  DEFB $18,$C3,$F8,$18,$00,$7F,$1C,$00 ;
  DEFB $0F,$FC,$00,$00,$F0,$00,$00,$00 ;
  DEFB $00,$00,$00                     ;
bitmap_crate:
  DEFB $00,$30,$00,$00,$FC,$00,$03,$FF ; bitmap: CRATE
  DEFB $00,$0F,$E7,$C0,$3F,$99,$F0,$4E ;
  DEFB $66,$7C,$73,$99,$FF,$78,$E7,$FC ;
  DEFB $7B,$3F,$F3,$7B,$CF,$CF,$3B,$F3 ;
  DEFB $3F,$4B,$FC,$FF,$73,$FD,$FF,$78 ;
  DEFB $FD,$FC,$7B,$3D,$F3,$7B,$CD,$CF ;
  DEFB $7B,$F1,$3F,$3B,$FC,$FF,$0B,$FD ;
  DEFB $FF,$03,$FD,$FF,$00,$FD,$FC,$00 ;
  DEFB $3D,$F0,$00,$0D,$C0,$00,$01,$00 ;
mask_crate:
  DEFB $FF,$03,$FF,$FC,$00,$FF,$F0,$00 ; mask: CRATE
  DEFB $3F,$C0,$00,$0F,$80,$00,$03,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$80,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$00,$00,$00,$00,$00 ;
  DEFB $00,$00,$00,$80,$00,$00,$C0,$00 ;
  DEFB $00,$F0,$00,$00,$FC,$00,$00,$FF ;
  DEFB $00,$03,$FF,$C0,$0F,$FF,$F0,$3F ;
bitmap_stove:
  DEFB $1C,$00,$13,$C0,$0C,$30,$13,$C8 ; bitmap: STOVE
  DEFB $1F,$F8,$0F,$F0,$13,$C8,$0C,$30 ;
  DEFB $0F,$F0,$0F,$F0,$1F,$F8,$19,$98 ;
  DEFB $16,$68,$35,$AC,$36,$6C,$3B,$DC ;
  DEFB $3C,$3C,$2F,$F4,$17,$E8,$3B,$DC ;
  DEFB $33,$CC,$60,$06                 ;
mask_stove:
  DEFB $C0,$3F,$C0,$0F,$E0,$07,$C0,$03 ; mask: STOVE
  DEFB $C0,$03,$E0,$07,$C0,$03,$E0,$07 ;
  DEFB $E0,$07,$E0,$07,$C0,$03,$C0,$03 ;
  DEFB $C0,$03,$80,$01,$80,$01,$80,$01 ;
  DEFB $80,$01,$80,$01,$C0,$03,$80,$01 ;
  DEFB $80,$01,$0C,$30                 ;

; Mark nearby items.
;
; Iterates over itemstructs, testing to see if each item is within the range (-1..22, 0..15) of the current map position. If it is it sets the flags itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7 on the item, otherwise it
; clears both of those flags.
;
; Used by the routines at setup_movable_items and main_loop.
;
; This is similar to is_item_discoverable_interior in that it iterates over all item_structs.
mark_nearby_items:
  LD A,(room_index)       ; Get the global current room index
  CP $FF                  ; Is it room_NONE?
  JR NZ,mni_room_set      ; Jump if not
  XOR A                   ; Otherwise set it to room_0_OUTDOORS
mni_room_set:
  LD C,A                  ; Preload the room index into C
  LD DE,(map_position)    ; Point DE at the map position
  LD B,$10                ; Set B for 16 iterations (item__LIMIT)
  LD HL,$76C9             ; Point HL at the first item_struct's room member
; Start loop
mni_loop:
  PUSH HL                 ; Preserve item_struct pointer
; Compare room
  LD A,(HL)               ; Load the room index and flags
  AND $3F                 ; Extract the room index
  CP C                    ; Same room?
  JR NZ,mni_reset         ; Jump if not
; Is the item's X coordinate within (-1..22) of the map's X position?
  INC HL                  ; Advance HL to itemstruct.iso_pos.x
  INC HL                  ;
  INC HL                  ;
  INC HL                  ;
  LD A,E                  ; Copy map X position into A
  DEC A                   ; Reduce it by 2
  DEC A                   ;
  CP (HL)                 ; Compare it to itemstruct.iso_pos.x
  JR Z,mni_chk_x_hi       ; Jump if equal (continuing test)
  JR NC,mni_reset         ; Reset if under lower bound
mni_chk_x_hi:
  ADD A,$19               ; Add 25 to make (map X position + 23)
  CP (HL)                 ; Compare to X value in itemstruct
  JR C,mni_reset          ; Reset if over upper bound
; Is the item's Y coordinate within (0..15) of the map's Y position?
  LD A,D                  ; Copy map Y position into A
  INC HL                  ; Advance HL to itemstruct.iso_pos.y
  DEC A                   ; Reduce it by 1
  CP (HL)                 ; Compare it to itemstruct.iso_pos.y
  JR Z,mni_chk_y_hi       ; Jump if equal (continuing test)
  JR NC,mni_reset         ; Reset if under lower bound
mni_chk_y_hi:
  ADD A,$11               ; Add 17 to make (map Y position + 16)
  CP (HL)                 ; Compare to Y value in itemstruct
  JR C,mni_reset          ; Reset if over upper bound
mni_set:
  POP HL                  ; Restore itemstruct pointer
  SET 7,(HL)              ; Set itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7
  SET 6,(HL)              ;
  JR mni_advance          ; Jump to next iteration
mni_reset:
  POP HL                  ; Restore itemstruct pointer
  RES 7,(HL)              ; Clear itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7
  RES 6,(HL)              ;
mni_advance:
  LD A,$07                ; Advance HL by stride
  ADD A,L                 ;
  LD L,A                  ;
  JR NC,mni_next          ;
  INC H                   ;
mni_next:
  DJNZ mni_loop           ; ...loop
  RET                     ; Return

; Iterates over all item_structs looking for nearby items.
;
; Returns the furthest/highest/nearest item?
;
; Iterates over all items. Uses multiply_by_8.
;
; Used by the routine at locate_vischar_or_itemstruct.
;
; I:A' A value to leave in A' when nothing is found (e.g. 255)
; I:BC' X position
; I:DE' Y position
; O:A' Index of the greatest item with the item_FOUND flag set, if found
; O:IY Pointer to an itemstruct, if found
get_greatest_itemstruct:
  LD BC,$1007             ; Set B for 16 iterations (item__LIMIT) and set C for a seven byte stride simultaneously
  LD HL,$76C9             ; Point HL at the first item_struct's room member
; Start loop
ggi_loop:
  BIT 7,(HL)              ; Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_7 flag set? ($80)
  JR Z,ggi_next           ; If not, jump to the next iteration
  BIT 6,(HL)              ; Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_6 flag set? ($40)
  JR Z,ggi_next           ; If not, jump to the next iteration
  PUSH HL                 ; Preserve the item_struct pointer
  PUSH BC                 ; Preserve the item counter and stride
  INC HL                  ; Advance HL to item_struct.pos.x
  LD A,(HL)               ; Fetch item_struct.pos.x
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  PUSH BC                 ; Preserve the result
  EXX                     ; Flip to banked regs - so we can subtract X position
  POP HL                  ; Restore the result into HL
  AND A                   ; Clear the carry flag prior to SBC
  SBC HL,BC               ; Calculate (item_struct.pos.x * 8 - x_position)
  EXX                     ; Flip to unbanked regs - now we have the result
  JR Z,ggi_next_pop       ; Was (item_struct.pos.x * 8 <= x_position)?
  JR C,ggi_next_pop       ; Jump if so
  INC HL                  ; Advance HL to item_struct.pos.y
  LD A,(HL)               ; Fetch item_struct.pos.y
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  PUSH BC                 ; Preserve the result
  EXX                     ; Flip to banked regs - so we can subtract Y position
  POP HL                  ; Restore the result into HL
; Q. Why are we not clearing the carry flag like at DC03?
  SBC HL,DE               ; Calculate (item_struct.pos.y * 8 - y_position)
  EXX                     ; Flip to unbanked regs - now we have the result
  JR Z,ggi_next_pop       ; Was (item_struct.pos.y * 8 <= y_position)?
  JR C,ggi_next_pop       ; Jump if so
  PUSH HL                 ; Preserve the item_struct pointer
  EXX                     ; Flip to banked regs - so we can store new X,Y positions
  POP HL                  ; Restore the item_struct pointer
; Get (x,y) for the next iteration.
  LD A,(HL)               ; Fetch item_struct.pos.y
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  LD E,C                  ; DE = BC
  LD D,B                  ;
  DEC HL                  ; Rewind HL to point at item_struct.pos.x
  LD A,(HL)               ; Fetch item_struct.pos.x
  CALL multiply_by_8      ; Multiply it by 8 returning the result in BC
  DEC HL                  ; Rewind HL to point at item_struct (jump back over item & room bytes)
  DEC HL                  ;
; IY is used to return an item_struct here which is unusual compared to the rest of the code which maintains IY as a current vischar pointer.
  PUSH HL                 ; Copy the item_struct pointer to IY
  POP IY                  ;
  EXX                     ; Flip to unbanked regs
  POP BC                  ; Restore the item counter and stride
  PUSH BC                 ; Preserve the item counter and stride
  LD A,$10                ; Calculate the item index (item__LIMIT - item counter)
  SUB B                   ;
  OR $40                  ; Set the item found flag
  EX AF,AF'               ; Return the value in A'
ggi_next_pop:
  POP BC                  ; Restore item counter and stride
  POP HL                  ; Restore item_struct pointer
ggi_next:
  LD A,C                  ; Advance by stride to next item
  ADD A,L                 ;
  LD L,A                  ;
  JR NC,ggi_loop_end      ;
  INC H                   ;
ggi_loop_end:
  DJNZ ggi_loop           ; ...loop
  RET                     ; Return

; Set up item plotting.
;
; Used by the routine at plot_sprites.
;
; Counterpart of, and very similar to, the routine at setup_vischar_plotting.
;
; I:A Item index
; I:IY Pointer to item_struct
; O:F Z set if item is visible, NZ otherwise
;
; The $3F mask here looks like it ought to be $1F (item__LIMIT - 1). Potential bug: The use of A later on does not re-clamp it to $1F.
setup_item_plotting:
  AND $3F                 ; Mask off item_FOUND
; Bug: This writes the item index to saved_item but that location is never subsequently read from.
  LD (saved_item),A       ; Store saved_item
  PUSH IY                 ; Copy the item_struct pointer into HL
  POP HL                  ;
  INC HL                  ; Advance HL to item_struct.pos
  INC HL                  ;
  LD DE,tinypos_stash_x   ; Copy item_struct.pos and item_struct.iso_pos to tinypos_stash and iso_pos (five contiguous bytes)
  LD BC,$0005             ;
  LDIR                    ;
; HL now points at global sprite_index.
  EX DE,HL                ; Point DE at item_struct.sprite_index
  LD (HL),B               ; Zero sprite_index so that items are never drawn flipped
  LD HL,item_definitions  ; Point HL at item_definitions[item] (a spritedef_t)
  ADD A,A                 ;
  LD C,A                  ;
  ADD A,A                 ;
  ADD A,C                 ;
  LD C,A                  ;
  ADD HL,BC               ;
  INC HL                  ; Advance HL to spritedef.height
  LD A,(HL)               ; Load it
  LD (item_height),A      ; Set item_height to spritedef.height
  INC HL                  ; Advance HL to spritedef.bitmap
  LD DE,bitmap_pointer    ; Copy spritedef bitmap and mask pointers to global bitmap_pointer and mask_pointer
  LD BC,$0004             ;
  LDIR                    ;
  CALL item_visible       ; Clip the item's dimensions to the game window
  RET NZ                  ; Return if the item is invisible
; The item is visible.
  PUSH BC                 ; Preserve the lefthand skip and clipped width
  PUSH DE                 ; Preserve the top skip and clipped height
; Self modify the sprite plotter routines.
  LD A,E                  ; Copy the clipped height into A
  LD ($E2C2),A            ; Write clipped height to the instruction at pms16_right_height_iters in plot_masked_sprite_16px (shift right case)
sip_do_enables:
  LD A,B                  ; Is the lefthand skip zero?
  AND A                   ;
  JP NZ,sip_enable_is_zero ; Jump if not
; There's no left hand skip - enable instructions.
sip_enable_is_one:
  LD A,$77                ; Load A' with the opcode of 'LD (HL),A'
  EX AF,AF'               ;
  LD A,C                  ; Set a counter to clipped_width. We'll write out this many bytes before clipping
  JR sip_enable_cont      ; (else)
sip_enable_is_zero:
  XOR A                   ; Load A' with the opcode of 'NOP'
  EX AF,AF'               ;
  LD A,$03                ; Set a counter to (3 - clipped_width). We'll clip until this many bytes have been written
  SUB C                   ;
sip_enable_cont:
  EXX                     ; Bank
  LD C,A                  ; Move counter to C
  EX AF,AF'               ; Unbank the opcode we'll write`
; Set the addresses in the jump table to NOP or LD (HL),A.
sip_enables_iters:
  LD HL,masked_sprite_plotter_16_enables ; Point HL at masked_sprite_plotter_16_enables[0]
  LD B,$03                ; Set B for 3 iterations / 3 pairs of self modified locations
; Start loop
sip_enables_loop:
  LD E,(HL)               ; Fetch an address
  INC HL                  ;
  LD D,(HL)               ;
  LD (DE),A               ; Write a new opcode
  INC HL                  ; Advance
  LD E,(HL)               ; Fetch an address
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ; Advance
  LD (DE),A               ; Write a new opcode
  DEC C                   ; Count down the counter
  JR NZ,sip_selfmod_next  ; Jump if nonzero
  XOR $77                 ; Swap between LD (HL),A and NOP
sip_selfmod_next:
  DJNZ sip_enables_loop   ; ...loop
; Calculate Y plotting offset.
;
; The full calculation can be avoided if we know there are rows to skip since in that case the sprite always starts at top of the screen.
  EXX                     ; Bank
  LD A,D                  ; Is top skip zero?
  AND A                   ;
  LD DE,$0000             ; Initialise our Y value to zero
  JR NZ,sip_y_skip_set    ; Jump if top skip isn't zero
  LD HL,$81BC             ; Compute Y = iso_pos_y - map_position_y
  LD A,(iso_pos_y)        ;
  SUB (HL)                ;
  LD L,A                  ; Multiply Y by the window buf stride (192) and store it in HL
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD E,L                  ;
  LD D,H                  ;
  ADD HL,HL               ;
  ADD HL,DE               ;
  EX DE,HL                ; Move Y into DE
sip_y_skip_set:
  LD A,(iso_pos_x)        ; Compute x = iso_pos_x - map_position_x
  LD HL,map_position      ;
  SUB (HL)                ;
  LD L,A                  ; Copy x to HL and sign extend it
  LD H,$00                ;
  JR NC,sip_x_skip_set    ;
  LD H,$FF                ;
sip_x_skip_set:
  ADD HL,DE               ; Combine the x and y values
  LD DE,$F290             ; Add the screen buffer start address
  ADD HL,DE               ;
  LD ($81A2),HL           ; Save the finalised screen buffer pointer
  LD HL,$8100             ; Point HL at the mask_buffer
  POP DE                  ; Retrieve the top skip and clipped height
  PUSH DE                 ;
  LD A,D                  ; mask buffer pointer += top_skip * 4
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,L                 ;
  LD L,A                  ;
  LD (foreground_mask_pointer),HL ; Set foreground_mask_pointer
  POP DE                  ; Retrieve the top skip and clipped height (again)
  PUSH DE                 ;
  LD A,D                  ; Is top skip zero?
  AND A                   ;
  JR Z,setup_item_plotting_0 ; Jump if so
; Bug: This loop is setup as generic multiply but only ever multiplies by two.
  LD D,A                  ; Copy top_skip to loop counter
  XOR A                   ; Zero the accumulator
  LD E,$03                ; Set multiplier to two (width bytes - 1)
  DEC E                   ;
; Start loop
sip_mult_loop:
  ADD A,E                 ; Accumulate
  DEC D                   ; Decrement counter
  JP NZ,sip_mult_loop     ; ...loop
; D will be set to zero here either way: if the loop terminates, or if jumped into.
setup_item_plotting_0:
  LD E,A                  ; Set DE to skip (result)
  LD HL,(bitmap_pointer)  ; Advance bitmap_pointer by 'skip'
  ADD HL,DE               ;
  LD (bitmap_pointer),HL  ;
  LD HL,(mask_pointer)    ; Advance mask_pointer by 'skip'
  ADD HL,DE               ;
  LD (mask_pointer),HL    ;
; It's unclear as to why these values are preserved since they're not used by the caller.
  POP BC                  ; Restore the lefthand skip and clipped width
  POP DE                  ; Restore the top skip and clipped height
; This XOR A isn't strictly needed - the Z flag should still be set from DCEC. (The counterpart at E541 doesn't have it).
  XOR A                   ; Set Z flag to signal "is visible" for return
  RET                     ; Return

; Clip the given item's dimensions to the game window.
;
; Counterpart to vischar_visible.
;
; Used by the routine at setup_item_plotting.
;
; O:B Lefthand skip (bytes)
; O:C Clipped width (bytes)
; O:D Top skip (rows)
; O:E Clipped height (rows)
; O:F Z if visible, NZ otherwise
;
; First handle the horizontal cases.
item_visible:
  LD HL,iso_pos_x         ; Point HL at iso_pos_x (item left edge)
; Calculate the right edge of the window in map space.
  LD DE,(map_position)    ; Load map position (both X & Y)
  LD A,E                  ; Extract X
  ADD A,$18               ; Add 24 (number of window columns)
; Subtract iso_pos_x giving the distance between the right edge of the window and the current item's left edge (in bytes).
  SUB (HL)                ; available_right = (map_position.x + 24) - item_left_edge
; Check for case (E): Item left edge beyond the window's right edge.
  JR Z,iv_not_visible     ; Jump to exit if zero (item left edge at right edge)
  JR C,iv_not_visible     ; Jump to exit if negative (item left edge beyond right edge)
; Check for case (D): Item extends outside the window.
  CP $03                  ; Compare result to (item width bytes (2) + 1)
  JP NC,iv_not_clipped_on_right_edge ; Jump if it fits
; Item's right edge is outside the window: clip its width.
  LD B,$00                ; No lefthand skip
  LD C,A                  ; Clipped width = available_right
  JR iv_height            ; Jump to height part
; Calculate the right edge of the item.
iv_not_clipped_on_right_edge:
  LD A,(HL)               ; Load iso_pos_x (item left edge)
  ADD A,$03               ; item_right_edge = iso_pos_x + (item width bytes (2) + 1)
; Subtract the map position's X giving the distance between the current item's right edge and the left edge of the window (in bytes).
  SUB E                   ; available_left = item_right_edge - map_position.x
; Check for case (A): Item's right edge is beyond the window's left edge.
  JR Z,iv_not_visible     ; Jump to exit if zero (item right edge at left edge)
  JR C,iv_not_visible     ; Jump to exit if negative (item right edge beyond left edge)
; Check for case (B): Item's left edge is outside the window and its right edge is inside the window.
  CP $03                  ; Compare result to (item width bytes (2) + 1)
  JP NC,item_visible_0    ; Jump if it fits
; Item's left edge is outside the window: move the lefthand skip into B and the clipped width into C.
  LD C,A                  ; Clipped width = available_left
  LD A,$03                ; Lefthand skip = (item width bytes (2) + 1) - available_left
  SUB C                   ;
  LD B,A                  ;
  JR iv_height            ; (else)
; Case (C): No clipping required.
item_visible_0:
  LD B,$00                ; No lefthand skip
  LD C,$03                ; Clipped width = (item width bytes (2) + 1)
; Handle vertical cases.
;
; Calculate the bottom edge of the window in map space.
iv_height:
  LD A,D                  ; Load the map position's Y and add 17 (number of window rows)
  ADD A,$11               ;
; Subtract item's Y giving the distance between the bottom edge of the window and the current item's top (in rows).
  INC HL                  ; Point HL at iso_pos.y (item top edge)
  SUB (HL)                ; available_bottom = window_bottom_edge - iso_pos.y
; Check for case (E): Item top edge beyond the window's bottom edge.
  JR Z,iv_not_visible     ; Jump to exit if zero (item top edge at bottom edge)
  JR C,iv_not_visible     ; Jump to exit if negative (item top edge beyond bottom edge)
; Check for case (D): Item extends outside the window.
  CP $02                  ; Compare result to item_height (2)
  JP NC,iv_not_clipped_on_top_edge ; Jump if it fits (available_top >= item_height)
; Item's bottom edge is outside the window: clip its height.
  LD E,$08                ; Clipped height = available_bottom (8)
  LD D,$00                ; No top skip
  JR iv_visible           ; Jump to exit
; Calculate the bottom edge of the item.
iv_not_clipped_on_top_edge:
  LD A,(HL)               ; item_bottom_edge = iso_pos.y + item_height (2)
  ADD A,$02               ;
; Subtract map position's Y giving the distance between the current item's bottom edge and the top edge of the window (in rows).
  SUB D                   ; available_top = item_bottom_edge - map_pos_y
; Check for case (A): Item's bottom edge is beyond the window's top edge.
  JR Z,iv_not_visible     ; Jump to exit if zero (item bottom edge at top edge)
  JR C,iv_not_visible     ; Jump to exit if negative (item bottom edge beyond top edge)
; Check for case (B): Item's top edge is outside the window and its bottom edge is inside the window.
  CP $02                  ; Compare result to item_height (2)
  JP NC,item_visible_1    ; Jump if it fits (available_top >= item_height)
; Item's top edge is outside the window: move the top skip into D and the clipped height into E.
  LD A,(item_height)      ; Clipped height = item_height - 8
  SUB $08                 ;
  LD E,A                  ;
  LD D,$08                ; Top skip = 8
  JR iv_visible           ; (else)
; Case (C): No clipping required.
item_visible_1:
  LD D,$00                ; No top skip
  LD A,(item_height)      ; Clipped height = item_height
  LD E,A                  ;
iv_visible:
  XOR A                   ; Set Z (item is visible)
  RET                     ; Return
iv_not_visible:
  OR $01                  ; Clear Z (item is not visible)
  RET                     ; Return

; Item attributes.
;
; 20 bytes, 4 of which are unknown, possibly unused.
;
; 'Yellow/black' means yellow ink over black paper, for example.
item_attributes:
  DEFB $06                ; item_attribute: WIRESNIPS - yellow/black
  DEFB $05                ; item_attribute: SHOVEL - cyan/black
  DEFB $05                ; item_attribute: LOCKPICK - cyan/black
  DEFB $07                ; item_attribute: PAPERS - white/black
  DEFB $04                ; item_attribute: TORCH - green/black
  DEFB $42                ; item_attribute: BRIBE - bright-red/black
  DEFB $04                ; item_attribute: UNIFORM - green/black
; Food turns purple/black when it's poisoned.
item_attributes_food:
  DEFB $07                ; item_attribute: FOOD - white/black
  DEFB $03                ; item_attribute: POISON - purple/black
  DEFB $42                ; item_attribute: RED KEY - bright-red/black
  DEFB $06                ; item_attribute: YELLOW KEY - yellow/black
  DEFB $04                ; item_attribute: GREEN KEY - green/black
  DEFB $05                ; item_attribute: PARCEL - cyan/black
  DEFB $07                ; item_attribute: RADIO - white/black
  DEFB $07                ; item_attribute: PURSE - white/black
  DEFB $04                ; item_attribute: COMPASS - green/black
; The following are likely unused.
  DEFB $06                ; item_attribute: yellow/black
  DEFB $05                ; item_attribute: cyan/black
  DEFB $42                ; item_attribute: bright-red/black
  DEFB $42                ; item_attribute: bright-red/black

; Item definitions.
;
; Array of "sprite" structures.
;
; item_definition: WIRESNIPS
item_definitions:
  DEFB $02                ; width
  DEFB $0B                ; height
  DEFW bitmap_wiresnips   ; bitmap pointer
  DEFW mask_wiresnips     ; mask pointer
; item_definition: SHOVEL
  DEFB $02                ; width
  DEFB $0D                ; height
  DEFW bitmap_shovel      ; bitmap pointer
  DEFW mask_shovel_key    ; mask pointer
; item_definition: LOCKPICK
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_lockpick    ; bitmap pointer
  DEFW mask_lockpick      ; mask pointer
; item_definition: PAPERS
  DEFB $02                ; width
  DEFB $0F                ; height
  DEFW bitmap_papers      ; bitmap pointer
  DEFW mask_papers        ; mask pointer
; item_definition: TORCH
  DEFB $02                ; width
  DEFB $0C                ; height
  DEFW bitmap_torch       ; bitmap pointer
  DEFW mask_torch         ; mask pointer
; item_definition: BRIBE
  DEFB $02                ; width
  DEFB $0D                ; height
  DEFW bitmap_bribe       ; bitmap pointer
  DEFW mask_bribe         ; mask pointer
; item_definition: UNIFORM
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_uniform     ; bitmap pointer
  DEFW mask_uniform       ; mask pointer
; item_definition: FOOD
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_food        ; bitmap pointer
  DEFW mask_food          ; mask pointer
; item_definition: POISON
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_poison      ; bitmap pointer
  DEFW mask_poison        ; mask pointer
; item_definition: RED_KEY
  DEFB $02                ; width
  DEFB $0D                ; height
  DEFW bitmap_key         ; bitmap pointer
  DEFW mask_shovel_key    ; mask pointer
; item_definition: YELLOW_KEY
  DEFB $02                ; width
  DEFB $0D                ; height
  DEFW bitmap_key         ; bitmap pointer
  DEFW mask_shovel_key    ; mask pointer
; item_definition: GREEN_KEY
  DEFB $02                ; width
  DEFB $0D                ; height
  DEFW bitmap_key         ; bitmap pointer
  DEFW mask_shovel_key    ; mask pointer
; item_definition: PARCEL
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_parcel      ; bitmap pointer
  DEFW mask_parcel        ; mask pointer
; item_definition: RADIO
  DEFB $02                ; width
  DEFB $10                ; height
  DEFW bitmap_radio       ; bitmap pointer
  DEFW mask_radio         ; mask pointer
; item_definition: PURSE
  DEFB $02                ; width
  DEFB $0C                ; height
  DEFW bitmap_purse       ; bitmap pointer
  DEFW mask_purse         ; mask pointer
; item_definition: COMPASS
  DEFB $02                ; width
  DEFB $0C                ; height
  DEFW bitmap_compass     ; bitmap pointer
  DEFW mask_compass       ; mask pointer

; Item bitmaps and masks.
bitmap_shovel:
  DEFB $00,$00            ; item_bitmap: SHOVEL (16x13)
  DEFB $00,$02            ;
  DEFB $00,$05            ;
  DEFB $00,$0E            ;
  DEFB $00,$30            ;
  DEFB $00,$C0            ;
  DEFB $33,$00            ;
  DEFB $6C,$00            ;
  DEFB $E7,$00            ;
  DEFB $FC,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
bitmap_key:
  DEFB $00,$00            ; item_bitmap: KEY (shared for all keys) (16x13)
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$18            ;
  DEFB $00,$64            ;
  DEFB $00,$1C            ;
  DEFB $00,$70            ;
  DEFB $19,$C0            ;
  DEFB $27,$00            ;
  DEFB $32,$00            ;
  DEFB $19,$00            ;
  DEFB $07,$00            ;
  DEFB $00,$00            ;
bitmap_lockpick:
  DEFB $01,$80            ; item_bitmap: LOCKPICK (16x16)
  DEFB $00,$C0            ;
  DEFB $03,$70            ;
  DEFB $0C,$60            ;
  DEFB $38,$40            ;
  DEFB $E0,$00            ;
  DEFB $C0,$00            ;
  DEFB $03,$18            ;
  DEFB $0C,$F0            ;
  DEFB $30,$C0            ;
  DEFB $23,$07            ;
  DEFB $2C,$08            ;
  DEFB $30,$38            ;
  DEFB $00,$E6            ;
  DEFB $03,$C4            ;
  DEFB $03,$00            ;
bitmap_compass:
  DEFB $00,$00            ; item_bitmap: COMPASS (16x12)
  DEFB $07,$E0            ;
  DEFB $18,$18            ;
  DEFB $24,$24            ;
  DEFB $41,$02            ;
  DEFB $41,$02            ;
  DEFB $24,$A4            ;
  DEFB $58,$9A            ;
  DEFB $27,$E4            ;
  DEFB $18,$18            ;
  DEFB $07,$E0            ;
  DEFB $00,$00            ;
bitmap_purse:
  DEFB $00,$00            ; item_bitmap: PURSE (16x12)
  DEFB $01,$80            ;
  DEFB $07,$40            ;
  DEFB $03,$80            ;
  DEFB $01,$00            ;
  DEFB $02,$80            ;
  DEFB $05,$40            ;
  DEFB $0D,$A0            ;
  DEFB $0B,$E0            ;
  DEFB $0F,$E0            ;
  DEFB $07,$C0            ;
  DEFB $00,$00            ;
bitmap_papers:
  DEFB $00,$00            ; item_bitmap: PAPERS (16x15)
  DEFB $0C,$00            ;
  DEFB $07,$00            ;
  DEFB $06,$C0            ;
  DEFB $02,$B0            ;
  DEFB $33,$6C            ;
  DEFB $6C,$D4            ;
  DEFB $6B,$36            ;
  DEFB $DA,$CE            ;
  DEFB $D6,$F3            ;
  DEFB $35,$EC            ;
  DEFB $0D,$DC            ;
  DEFB $03,$D0            ;
  DEFB $00,$80            ;
  DEFB $00,$00            ;
bitmap_wiresnips:
  DEFB $00,$00            ; item_bitmap: WIRESNIPS (16x11)
  DEFB $00,$18            ;
  DEFB $00,$36            ;
  DEFB $00,$60            ;
  DEFB $03,$FB            ;
  DEFB $0E,$6E            ;
  DEFB $30,$E0            ;
  DEFB $C1,$80            ;
  DEFB $06,$00            ;
  DEFB $18,$00            ;
  DEFB $00,$00            ;
mask_shovel_key:
  DEFB $FF,$FD            ; item_mask: SHOVEL or KEY (shared) (16x13)
  DEFB $FF,$F8            ;
  DEFB $FF,$E0            ;
  DEFB $FF,$80            ;
  DEFB $FF,$01            ;
  DEFB $CC,$01            ;
  DEFB $80,$03            ;
  DEFB $00,$0F            ;
  DEFB $00,$3F            ;
  DEFB $00,$FF            ;
  DEFB $00,$7F            ;
  DEFB $E0,$7F            ;
  DEFB $F8,$FF            ;
mask_lockpick:
  DEFB $FC,$3F            ; item_mask: LOCKPICK (16x16)
  DEFB $FC,$0F            ;
  DEFB $F0,$07            ;
  DEFB $C0,$0F            ;
  DEFB $03,$1F            ;
  DEFB $07,$BF            ;
  DEFB $1C,$E7            ;
  DEFB $30,$03            ;
  DEFB $C0,$07            ;
  DEFB $80,$08            ;
  DEFB $80,$30            ;
  DEFB $80,$C0            ;
  DEFB $83,$01            ;
  DEFB $CC,$00            ;
  DEFB $F8,$11            ;
  DEFB $F8,$3B            ;
mask_compass:
  DEFB $F8,$1F            ; item_mask: COMPASS (16x12)
  DEFB $E0,$07            ;
  DEFB $C0,$03            ;
  DEFB $80,$01            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $80,$01            ;
  DEFB $00,$00            ;
  DEFB $80,$01            ;
  DEFB $C0,$03            ;
  DEFB $E0,$07            ;
  DEFB $F8,$1F            ;
mask_purse:
  DEFB $FE,$7F            ; item_mask: PURSE (16x12)
  DEFB $F8,$3F            ;
  DEFB $F0,$1F            ;
  DEFB $F8,$3F            ;
  DEFB $FC,$3F            ;
  DEFB $F8,$3F            ;
  DEFB $F0,$1F            ;
  DEFB $E0,$0F            ;
  DEFB $E0,$0F            ;
  DEFB $E0,$0F            ;
  DEFB $F0,$1F            ;
  DEFB $F8,$3F            ;
mask_papers:
  DEFB $F3,$FF            ; item_mask: PAPERS (16x15)
  DEFB $E0,$FF            ;
  DEFB $F0,$3F            ;
  DEFB $F0,$0F            ;
  DEFB $C8,$03            ;
  DEFB $80,$01            ;
  DEFB $00,$01            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $C0,$01            ;
  DEFB $F0,$03            ;
  DEFB $FC,$2F            ;
  DEFB $FF,$7F            ;
mask_wiresnips:
  DEFB $FF,$E7            ; item_mask: WIRESNIPS (16x11)
  DEFB $FF,$C1            ;
  DEFB $FF,$80            ;
  DEFB $FC,$00            ;
  DEFB $F0,$00            ;
  DEFB $C0,$00            ;
  DEFB $00,$01            ;
  DEFB $08,$1F            ;
  DEFB $20,$7F            ;
  DEFB $C1,$FF            ;
  DEFB $E7,$FF            ;
bitmap_food:
  DEFB $00,$30            ; item_bitmap: FOOD (16x16)
  DEFB $00,$00            ;
  DEFB $00,$30            ;
  DEFB $00,$30            ;
  DEFB $0E,$78            ;
  DEFB $1F,$B8            ;
  DEFB $07,$38            ;
  DEFB $18,$B8            ;
  DEFB $1E,$38            ;
  DEFB $19,$98            ;
  DEFB $17,$E0            ;
  DEFB $19,$F8            ;
  DEFB $06,$60            ;
  DEFB $07,$98            ;
  DEFB $01,$F8            ;
  DEFB $00,$60            ;
bitmap_poison:
  DEFB $00,$00            ; item_bitmap: POISON (16x16)
  DEFB $00,$80            ;
  DEFB $00,$80            ;
  DEFB $01,$40            ;
  DEFB $01,$C0            ;
  DEFB $00,$80            ;
  DEFB $01,$40            ;
  DEFB $03,$E0            ;
  DEFB $06,$30            ;
  DEFB $06,$B0            ;
  DEFB $06,$30            ;
  DEFB $06,$F0            ;
  DEFB $06,$F0            ;
  DEFB $07,$F0            ;
  DEFB $05,$D0            ;
  DEFB $03,$E0            ;
bitmap_torch:
  DEFB $00,$00            ; item_bitmap: TORCH (16x12)
  DEFB $00,$08            ;
  DEFB $00,$3C            ;
  DEFB $02,$FC            ;
  DEFB $0D,$70            ;
  DEFB $1E,$A0            ;
  DEFB $1E,$80            ;
  DEFB $16,$80            ;
  DEFB $16,$80            ;
  DEFB $16,$00            ;
  DEFB $0C,$00            ;
  DEFB $00,$00            ;
bitmap_uniform:
  DEFB $01,$E0            ; item_bitmap: UNIFORM (16x16)
  DEFB $07,$F0            ;
  DEFB $0F,$F8            ;
  DEFB $0F,$F8            ;
  DEFB $1F,$FC            ;
  DEFB $0F,$F3            ;
  DEFB $F3,$CC            ;
  DEFB $3C,$30            ;
  DEFB $0F,$CF            ;
  DEFB $F3,$3C            ;
  DEFB $3C,$F0            ;
  DEFB $0F,$CF            ;
  DEFB $F3,$3C            ;
  DEFB $3C,$F0            ;
  DEFB $0F,$C0            ;
  DEFB $03,$00            ;
bitmap_bribe:
  DEFB $00,$00            ; item_bitmap: BRIBE (16x13)
  DEFB $00,$00            ;
  DEFB $03,$00            ;
  DEFB $0F,$C0            ;
  DEFB $3F,$30            ;
  DEFB $4C,$FC            ;
  DEFB $F3,$F2            ;
  DEFB $3C,$CF            ;
  DEFB $0F,$3C            ;
  DEFB $03,$F0            ;
  DEFB $00,$C0            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
bitmap_radio:
  DEFB $00,$10            ; item_bitmap: RADIO (16x16)
  DEFB $00,$10            ;
  DEFB $38,$10            ;
  DEFB $C6,$10            ;
  DEFB $37,$90            ;
  DEFB $CC,$50            ;
  DEFB $F3,$50            ;
  DEFB $CC,$EE            ;
  DEFB $B7,$38            ;
  DEFB $B6,$C6            ;
  DEFB $CF,$36            ;
  DEFB $3E,$D6            ;
  DEFB $0F,$36            ;
  DEFB $03,$D6            ;
  DEFB $00,$F6            ;
  DEFB $00,$35            ;
bitmap_parcel:
  DEFB $00,$00            ; item_bitmap: PARCEL (16x16)
  DEFB $03,$00            ;
  DEFB $0E,$40            ;
  DEFB $39,$F0            ;
  DEFB $E7,$E4            ;
  DEFB $1F,$9F            ;
  DEFB $8E,$7C            ;
  DEFB $B1,$F3            ;
  DEFB $B8,$CF            ;
  DEFB $BB,$37            ;
  DEFB $BB,$73            ;
  DEFB $BB,$67            ;
  DEFB $BB,$77            ;
  DEFB $3B,$7C            ;
  DEFB $0B,$70            ;
  DEFB $03,$40            ;
mask_bribe:
  DEFB $FC,$FF            ; item_mask: BRIBE (16x13)
  DEFB $F0,$3F            ;
  DEFB $C0,$0F            ;
  DEFB $80,$03            ;
  DEFB $80,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $C0,$00            ;
  DEFB $F0,$00            ;
  DEFB $FC,$00            ;
  DEFB $FF,$03            ;
  DEFB $FF,$CF            ;
mask_uniform:
  DEFB $F8,$0F            ; item_mask: UNIFORM (16x16)
  DEFB $F0,$07            ;
  DEFB $E0,$03            ;
  DEFB $E0,$03            ;
  DEFB $C0,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$03            ;
  DEFB $C0,$0F            ;
  DEFB $F0,$3F            ;
mask_parcel:
  DEFB $FC,$FF            ; item_mask: PARCEL (16x16)
  DEFB $F0,$3F            ;
  DEFB $C0,$0F            ;
  DEFB $00,$03            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $C0,$03            ;
  DEFB $F0,$0F            ;
mask_poison:
  DEFB $FF,$7F            ; item_mask: POISON (16x16)
  DEFB $FE,$3F            ;
  DEFB $FE,$3F            ;
  DEFB $FC,$1F            ;
  DEFB $FC,$1F            ;
  DEFB $FE,$3F            ;
  DEFB $FC,$1F            ;
  DEFB $F8,$0F            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F0,$07            ;
  DEFB $F8,$0F            ;
mask_torch:
  DEFB $FF,$F7            ; item_mask: TORCH (16x12)
  DEFB $FF,$C3            ;
  DEFB $FD,$01            ;
  DEFB $F0,$01            ;
  DEFB $E0,$03            ;
  DEFB $C0,$0F            ;
  DEFB $C0,$1F            ;
  DEFB $C0,$3F            ;
  DEFB $C0,$3F            ;
  DEFB $C0,$7F            ;
  DEFB $E1,$FF            ;
  DEFB $F3,$FF            ;
mask_radio:
  DEFB $FF,$C7            ; item_mask: RADIO (16x16)
  DEFB $C7,$C7            ;
  DEFB $01,$C7            ;
  DEFB $00,$47            ;
  DEFB $00,$07            ;
  DEFB $00,$07            ;
  DEFB $00,$01            ;
  DEFB $00,$00            ;
  DEFB $00,$01            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $00,$00            ;
  DEFB $C0,$00            ;
  DEFB $F0,$00            ;
  DEFB $FC,$00            ;
  DEFB $FF,$01            ;
mask_food:
  DEFB $FF,$87            ; item_mask: FOOD (16x16)
  DEFB $FF,$CF            ;
  DEFB $FF,$87            ;
  DEFB $F1,$87            ;
  DEFB $E0,$03            ;
  DEFB $C0,$03            ;
  DEFB $E0,$03            ;
  DEFB $C0,$03            ;
  DEFB $C0,$03            ;
  DEFB $C0,$03            ;
  DEFB $C0,$07            ;
  DEFB $C0,$03            ;
  DEFB $E0,$07            ;
  DEFB $F0,$03            ;
  DEFB $F8,$03            ;
  DEFB $FE,$07            ;

; Unreferenced bytes.
LE0D7:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00

; Addresses of self-modified locations which are changed between NOPs and LD (HL),A.
;
; (<- setup_item_plotting, setup_vischar_plotting)
masked_sprite_plotter_16_enables:
  DEFW pms16_right_plot_enable_0 ; pms16_right_plot_enable_0
  DEFW pms16_left_plot_enable_0 ; pms16_left_plot_enable_0
  DEFW pms16_right_plot_enable_1 ; pms16_right_plot_enable_1
  DEFW pms16_left_plot_enable_1 ; pms16_left_plot_enable_1
  DEFW pms16_right_plot_enable_2 ; pms16_right_plot_enable_2
  DEFW pms16_left_plot_enable_2 ; pms16_left_plot_enable_2

; Addresses of self-modified locations which are changed between NOPs and LD (HL),A.
;
; (<- setup_vischar_plotting)
masked_sprite_plotter_24_enables:
  DEFW pms24_right_plot_enable_0 ; pms24_right_plot_enable_0
  DEFW pms24_left_plot_enable_0 ; pms24_left_plot_enable_0
  DEFW pms24_right_plot_enable_1 ; pms24_right_plot_enable_1
  DEFW pms24_left_plot_enable_1 ; pms24_left_plot_enable_1
  DEFW pms24_right_plot_enable_2 ; pms24_right_plot_enable_2
  DEFW pms24_left_plot_enable_2 ; pms24_left_plot_enable_2
  DEFW pms24_right_plot_enable_3 ; pms24_right_plot_enable_3
  DEFW pms24_left_plot_enable_3 ; pms24_left_plot_enable_3
; These two look different. Unused?
  DEFW plot_masked_sprite_16px ; plot_masked_sprite_16px
  DEFW plot_masked_sprite_24px ; plot_masked_sprite_24px

; Unused word?
;
; Unsure if related to the above masked_sprite_plotter_24_enables table.
LE100:
  DEFW $0806

; Sprite plotter for 24 pixel-wide masked sprites.
;
; This is used for characters and objects.
;
; Used by the routine at plot_sprites.
;
; I:IY Pointer to visible character.
;
; Mask off the bottom three bits of the vischar's (isometric projected) x position and treat it as a signed field. This tells us how far we need to shift the sprite left or right. -4..-1 => left shift by 4..1px; 0..3 => right shift by
; 0..3px.
plot_masked_sprite_24px:
  LD A,(IY+$18)           ; x = (vischar.iso_pos.x & 7)
  AND $07                 ;
  CP $04                  ; Is x equal to 4 or above? (-4..-1)
  JP NC,pms24_left        ; Jump if so
; Right shifting case.
;
; A is 0..3 here: the amount by which we want to shift the sprite right. The following op turns that into a jump table distance. e.g. it turns (0,1,2,3) into (3,2,1,0) then scales it by the length of each rotate sequence (8 bytes) to obtain
; the jump offset.
  CPL                     ; x = (~x & 3)
  AND $03                 ;
  ADD A,A                 ; Multiply by eight to get the jump distance
  ADD A,A                 ;
  ADD A,A                 ;
  LD ($E161),A            ; Self modify the JR at pms24_right_mask_jump to jump into the mask rotate sequence
  LD ($E143),A            ; Self modify the JR at pms24_right_bitmap_jump to jump into the bitmap rotate sequence
  EXX                     ; Fetch mask_pointer
  LD HL,(mask_pointer)    ;
  EXX                     ; Fetch bitmap_pointer
  LD HL,(bitmap_pointer)  ;
pms24_right_height_iters:
  LD B,$20                ; Set B for 32 iterations (self modified by E49D)
; Start loop
pms24_right_loop:
  PUSH BC                 ; Preserve the loop counter
  LD B,(HL)               ; Load the bitmap bytes bm0,bm1,bm2 into B,C,E
  INC HL                  ;
  LD C,(HL)               ;
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the bitmap pointer
  EXX                     ; Bank
  LD B,(HL)               ; Load the mask bytes mask0,mask1,mask2 into B',C',E'
  INC HL                  ;
  LD C,(HL)               ;
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the mask pointer
  LD A,(flip_sprite)      ; Is the top bit of flip_sprite set?
  AND A                   ;
  CALL M,flip_24_masked_pixels ; Call flip_24_masked_pixels if so
  LD HL,(foreground_mask_pointer) ; Fetch foreground_mask_pointer
  EXX                             ;
; Note: This instruction is moved compared to the other routines.
  LD HL,($81A2)           ; Load screen buffer pointer
; Shift the bitmap right.
;
; Our 24px wide bitmap has three bytes to shift (B,C,E) but we'll need an extra byte to capture any shifted-out bits (D).
  LD D,$00                ; bm3 = 0
pms24_right_bitmap_jump:
  JR pms24_right_bitmap_jumptable_0 ; Jump into shifter (self modified by E115)
; Rotate the bitmap bytes (B,C,E,D) right by one pixel.
;
; Shift out the leftmost byte's bottom pixel into the carry flag.
pms24_right_bitmap_jumptable_0:
  SRL B                   ; carry = bm0 & 1; bm0 >>= 1
; Shift out the next byte's bottom pixel into the carry flag while shifting in the previous carry at the top. (x3)
  RR C                    ; new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry
  RR E                    ; new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry
  RR D                    ; new_carry = bm3 & 1; bm3 = (bm3 >> 1) | (carry << 7); carry = new_carry
pms24_right_bitmap_jumptable_1:
  SRL B                   ; Do the same again
  RR C                    ;
  RR E                    ;
  RR D                    ;
pms24_right_bitmap_jumptable_2:
  SRL B                   ; Do the same again
  RR C                    ;
  RR E                    ;
  RR D                    ;
pms24_right_bitmap_jumptable_end:
  EXX                     ; Swap to masks bank
; Shift the mask right.
;
; This follows the same process as the bitmap shifting above, but the mask and a carry flag are set by default.
  LD D,$FF                ; mask3 = $FF
  SCF                     ; carry = 1
pms24_right_mask_jump:
  JR pms24_right_mask_jumptable_0 ; Jump into shifter (self modified by E112)
; Rotate the mask bytes (B,C,E,D) right by one pixel.
pms24_right_mask_jumptable_0:
  RR B                    ; new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry
  RR C                    ; new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry
  RR E                    ; new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry
  RR D                    ; new_carry = mask3 & 1; mask3 = (mask3 >> 1) | (carry << 7); carry = new_carry
pms24_right_mask_jumptable_1:
  RR B                    ; Do the same again
  RR C                    ;
  RR E                    ;
  RR D                    ;
pms24_right_mask_jumptable_2:
  RR B                    ; Do the same again
  RR C                    ;
  RR E                    ;
  RR D                    ;
; Plot using the foreground mask.
;
; In TGE the bitmap pixels are set to 0 for black and 1 for white, and the mask pixels are set to 0 for opaque and 1 for transparent.
;
; TGE uses "AND-OR" type masks. In this type of mask the screen contents are ANDed with the mask (preserving only those pixels set in the mask) then the bitmap is ORed into place, like so: result = (mask & screen) | bitmap
;
; +--------+------+---------------------------------+
; | Bitmap | Mask | Result                          |
; +--------+------+---------------------------------+
; | 0      | 0    | Set to black                    |
; | 0      | 1    | Set to background (transparent) |
; | 1      | 0    | Set to white                    |
; | 1      | 1    | Set to white                    |
; +--------+------+---------------------------------+
;
; See also https://skoolkit.ca/docs/skoolkit-6.2/skool-macros.html#masks
;
; However TGE also has a foreground layer to consider. This allows objects to be in front of a sprite too. The foreground mask removes from a sprite the pixels of objects in front of it. This gives us our final expression: result =
; ((~foreground_mask | mask) & screen) | (bitmap & foreground_mask)
;
; In the left term: ((~foreground_mask | mask) & screen) :: The foreground mask is first inverted so that it will preserve the foreground layer's pixels. It's then ORed with the vischar's mask so that it preserves the transparent pixels
; around the vischar. The result is ANDed with the screen (buffer) pixels, creating a "hole" into which we will insert the bitmap pixels.
;
; In the right term: (bitmap & foreground_mask) :: We take the vischar's bitmap pixels and mask them against the foreground mask. This means that we retain the parts of the vischar outside of the foreground mask.
;
; Finally the OR merges the result with the screen-with-a-hole-cut-out.
;
; +------------+--------+------+---------------------------------+
; | Foreground | Bitmap | Mask | Result                          |
; +------------+--------+------+---------------------------------+
; | 0          | any    | any  | Set to foreground               |
; | 1          | 0      | 0    | Set to black                    |
; | 1          | 0      | 1    | Set to background (transparent) |
; | 1          | 1      | 0    | Set to white                    |
; | 1          | 1      | 1    | Set to white                    |
; +------------+--------+------+---------------------------------+
pms24_right_plot_0:
  LD A,(HL)               ; Load a foreground mask byte
  CPL                     ; Invert it
  OR B                    ; OR with mask byte mask0
  EXX                     ; Swap to bank containing bitmap bytes (in BC & DE) and screen buffer pointer (in HL)
  AND (HL)                ; AND combined masks with screen byte
  EX AF,AF'               ; Bank left hand term
  LD A,B                  ; Get bitmap byte bm0
  EXX                     ; Swap to bank containing mask bytes (in BC' & DE') and foreground mask pointer (in HL')
  AND (HL)                ; AND with foreground mask byte
  LD B,A                  ; Save right hand term
  EX AF,AF'               ; Unbank left hand term
  OR B                    ; Combine terms
  INC L                   ; Advance foreground mask pointer
  EXX                     ; Swap to bitmaps bank
pms24_right_plot_enable_0:
  LD (HL),A               ; Write pixel (self modified)
  INC HL                  ; Advance to next output pixel
  EXX                     ; Swap to masks bank
pms24_right_plot_1:
  LD A,(HL)               ; Do the same again for mask1 & bm1
  CPL                     ;
  OR C                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,C                  ;
  EXX                     ;
  AND (HL)                ;
  LD C,A                  ;
  EX AF,AF'               ;
  OR C                    ;
  INC L                   ;
  EXX                     ;
pms24_right_plot_enable_1:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms24_right_plot_2:
  LD A,(HL)               ; Do the same again for mask2 & bm2
  CPL                     ;
  OR E                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,E                  ;
  EXX                     ;
  AND (HL)                ;
  LD E,A                  ;
  EX AF,AF'               ;
  OR E                    ;
  INC L                   ;
  EXX                     ;
pms24_right_plot_enable_2:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms24_right_plot_3:
  LD A,(HL)               ; Do the same again for mask3 & bm3
  CPL                     ;
  OR D                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,D                  ;
  EXX                     ;
  AND (HL)                ;
  LD D,A                  ;
  EX AF,AF'               ;
  OR D                    ;
  INC L                   ;
  LD (foreground_mask_pointer),HL ; Save foreground_mask_pointer
  POP HL                  ; Restore the mask pointer
  EXX
pms24_right_plot_enable_3:
  LD (HL),A
  LD BC,$0015             ; Advance screen buffer pointer by (24 - 3 = 21) bytes
  ADD HL,BC               ;
  LD ($81A2),HL           ; Save the screen buffer pointer
  POP HL                  ; Restore the bitmap pointer
  POP BC                  ; Restore the loop counter
  DEC B                   ; ...loop
  JP NZ,pms24_right_loop  ;
  RET                     ; Return
; Left shifting case.
;
; A is 4..7 here, which we intepret as -4..-1: the amount by which we want to shift the sprite left.
pms24_left:
  SUB $04                 ; 4..7 => jump table offset 0..3
  RLCA                    ; Multiply by eight to get the jump distance
  RLCA                    ;
  RLCA                    ;
  LD ($E22A),A            ; Self modify the JR at pms24_left_mask_jump to jump into the mask rotate sequence
  LD ($E204),A            ; Self modify the JR at pms24_left_bitmap_jump to jump into the bitmap rotate sequence
  EXX                     ; Fetch mask_pointer
  LD HL,(mask_pointer)    ;
  EXX                     ; Fetch bitmap_pointer
  LD HL,(bitmap_pointer)  ;
pms24_left_height_iters:
  LD B,$20                ; Set B for 32 iterations (self modified by E4A0)
; Start loop
pms24_left_loop:
  PUSH BC                 ; Preserve the loop counter
  LD B,(HL)               ; Load the bitmap bytes bm1,bm2,bm3 into B,C,E
  INC HL                  ;
  LD C,(HL)               ;
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the bitmap pointer
  EXX                     ; Bank
  LD B,(HL)               ; Load the mask bytes mask1,mask2,mask3 into B',C',E'
  INC HL                  ;
  LD C,(HL)               ;
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the mask pointer
  LD A,(flip_sprite)      ; Is the top bit of flip_sprite set?
  AND A                   ;
  CALL M,flip_24_masked_pixels ; Call flip_24_masked_pixels if so
  LD HL,(foreground_mask_pointer) ; Fetch foreground_mask_pointer
  EXX                             ;
  LD HL,($81A2)           ; Load screen buffer pointer
; Shift the bitmap left.
;
; Our 24px wide bitmap has three bytes to shift (B,C,E) but we'll need an extra byte to capture any shifted-out bits (D).
  LD D,$00                ; bm0 = 0
pms24_left_bitmap_jump:
  JR pms24_left_bitmap_jumptable_0 ; Jump into shifter (self modified by E1D6)
; Rotate the bitmap bytes (D,B,C,E) left by one pixel.
;
; Shift out the rightmost byte's top pixel into the carry flag.
pms24_left_bitmap_jumptable_0:
  SLA E                   ; carry = bm3 >> 7; bm3 <<= 1
; Shift out the next byte's top pixel into the carry flag while shifting in the previous carry at the bottom. (x3)
  RL C                    ; new_carry = bm2 >> 7; bm2 = (bm2 << 1) | carry; carry = new_carry
  RL B                    ; new_carry = bm1 >> 7; bm1 = (bm1 << 1) | carry; carry = new_carry
  RL D                    ; new_carry = bm0 >> 7; bm0 = (bm0 << 1) | carry; carry = new_carry
pms24_left_bitmap_jumptable_1:
  SLA E                   ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
pms24_left_bitmap_jumptable_2:
  SLA E                   ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
pms24_left_bitmap_jumptable_3:
  SLA E                   ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
pms24_left_bitmap_jumptable_end:
  EXX                     ; Swap to masks bank
; Shift the mask left.
  LD D,$FF                ; mask0 = $FF
  SCF                     ; carry = 1
pms24_left_mask_jump:
  JR pms24_left_mask_jumptable_0 ; Jump into shifter (self modified by E1D3)
; Rotate the mask bytes (D,B,C,E) left by one pixel.
pms24_left_mask_jumptable_0:
  RL E                    ; new_carry = mask3 >> 7; mask3 = (mask3 << 1) | carry; carry = new_carry
  RL C                    ; new_carry = mask2 >> 7; mask2 = (mask2 << 1) | carry; carry = new_carry
  RL B                    ; new_carry = mask1 >> 7; mask1 = (mask1 << 1) | carry; carry = new_carry
  RL D                    ; new_carry = mask0 >> 7; mask0 = (mask0 << 1) | carry; carry = new_carry
pms24_left_mask_jumptable_1:
  RL E                    ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
pms24_left_mask_jumptable_2:
  RL E                    ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
pms24_left_mask_jumptable_3:
  RL E                    ; Do the same again
  RL C                    ;
  RL B                    ;
  RL D                    ;
; Plot, using the foreground mask.
pms24_left_plot_0:
  LD A,(HL)               ; Load a foreground mask byte
  CPL                     ; Invert it
  OR D                    ; OR with mask byte mask0
  EXX                     ; Swap to bank containing bitmap bytes (in BC & DE) and screen buffer pointer (in HL)
  AND (HL)                ; AND combined masks with screen byte
  EX AF,AF'               ; Bank left hand term
  LD A,D                  ; Get bitmap byte bm0
  EXX                     ; Swap to bank containing mask bytes (in BC' & DE') and foreground mask pointer (in HL')
  AND (HL)                ; AND with foreground mask byte
  LD D,A                  ; Save right hand term
  EX AF,AF'               ; Unbank left hand term
  OR D                    ; Combine results
  INC L                   ; Advance foreground mask pointer
  EXX                     ; Swap to bitmaps bank
pms24_left_plot_enable_0:
  LD (HL),A               ; Write pixel (self modified)
  INC HL                  ; Advance to next output pixel
  EXX                     ; Swap to masks bank
pms24_left_plot_1:
  LD A,(HL)               ; Do the same again for mask1 & bm1
  CPL                     ;
  OR B                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,B                  ;
  EXX                     ;
  AND (HL)                ;
  LD B,A                  ;
  EX AF,AF'               ;
  OR B                    ;
  INC L                   ;
  EXX                     ;
pms24_left_plot_enable_1:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms24_left_plot_2:
  LD A,(HL)               ; Do the same again for mask2 & bm2
  CPL                     ;
  OR C                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,C                  ;
  EXX                     ;
  AND (HL)                ;
  LD C,A                  ;
  EX AF,AF'               ;
  OR C                    ;
  INC L                   ;
  EXX                     ;
pms24_left_plot_enable_2:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms24_left_plot_3:
  LD A,(HL)               ; Do the same again for mask3 & bm3
  CPL                     ;
  OR E                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,E                  ;
  EXX                     ;
  AND (HL)                ;
  LD E,A                  ;
  EX AF,AF'               ;
  OR E                    ;
  INC L                   ;
  LD (foreground_mask_pointer),HL ; Save foreground_mask_pointer
  POP HL                  ; Restore the mask pointer
  EXX
pms24_left_plot_enable_3:
  LD (HL),A
  LD BC,$0015             ; Advance screen buffer pointer by (24 - 3 = 21) bytes
  ADD HL,BC               ;
  LD ($81A2),HL           ; Save the screen buffer pointer
  POP HL                  ; Restore the bitmap pointer
  POP BC                  ; Restore the loop counter
  DEC B                   ; ...loop
  JP NZ,pms24_left_loop   ;
  RET                     ; Return

; Alternative entry point for plot_masked_sprite_16px that assumes x is zero.
;
; Used by the routine at plot_sprites.
plot_masked_sprite_16px_x_is_zero:
  XOR A                   ; Zero x
  JR pms16_right          ; Jump to pms16_left

; Sprite plotter for 16 pixel-wide masked sprites.
;
; This is used for characters and objects.
;
; Used by the routines at plot_sprites, plot_masked_sprite_16px_x_is_zero and plot_masked_sprite_16px.
;
; I:IY Pointer to visible character.
;
; Mask off the bottom three bits of the vischar's (isometric projected) x position and treat it as a signed field. This tells us how far we need to shift the sprite left or right. -4..-1 => left shift by 4..1px; 0..3 => right shift by
; 0..3px.
plot_masked_sprite_16px:
  LD A,(IY+$18)           ; x = (vischar.iso_pos.x & 7)
  AND $07                 ;
  CP $04                  ; Is x equal to 4 or above? (-4..-1)
  JP NC,pms16_left        ; Jump if so
; Right shifting case.
;
; A is 0..3 here: the amount by which we want to shift the sprite right. The following op turns that into a jump table distance. e.g. it turns (0,1,2,3) into (3,2,1,0) then scales it by the length of each rotate sequence (6 bytes) to obtain
; the jump offset.
pms16_right:
  CPL                     ; x = (~x & 3)
  AND $03                 ;
  ADD A,A                 ; Multiply by six to get the jump distance
  LD H,A                  ;
  ADD A,A                 ;
  ADD A,H                 ;
  LD ($E2DC),A            ; Self modify the JR at pms16_right_mask_jump to jump into the mask rotate sequence
  LD ($E2F4),A            ; Self modify the JR at pms16_right_bitmap_jump to jump into the bitmap rotate sequence
  EXX                     ; Fetch mask_pointer
  LD HL,(mask_pointer)    ;
  EXX                     ; Fetch bitmap_pointer
  LD HL,(bitmap_pointer)  ;
pms16_right_height_iters:
  LD B,$20                ; Set B for 32 iterations (self modified by DC73)
; Start loop
pms16_right_loop:
  LD D,(HL)               ; Load the bitmap bytes bm0,bm1 into D,E
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the bitmap pointer
  EXX                     ; Bank
  LD D,(HL)               ; Load the mask bytes mask0,mask1 into D',E'
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the mask pointer
  LD A,(flip_sprite)      ; Is the top bit of flip_sprite set?
  AND A                   ;
  CALL M,flip_16_masked_pixels ; Call flip_16_masked_pixels if so
  LD HL,(foreground_mask_pointer) ; Fetch foreground_mask_pointer
; Shift the mask.
;
; Note: The 24px version does bitmap rotates then mask rotates. Is this the opposite way around to save a bank switch?
  LD C,$FF                ; mask2 = $FF
  SCF                     ; carry = 1
pms16_right_mask_jump:
  JR pms16_right_mask_jumptable_0 ; Jump into shifter (self modified by E2B3)
; Rotate the mask bytes (D,E,C) right by one pixel.
pms16_right_mask_jumptable_0:
  RR D                    ; new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry
  RR E                    ; new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry
  RR C                    ; new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry
pms16_right_mask_jumptable_1:
  RR D                    ; Do the same again
  RR E                    ;
  RR C                    ;
pms16_right_mask_jumptable_2:
  RR D                    ; Do the same again
  RR E                    ;
  RR C                    ;
; Shift the bitmap.
;
; Our 16px bitmap has two bitmap bytes to shift (D,E) but we'll need an extra byte to capture the shift-out (C).
pms16_right_mask_jumptable_end:
  EXX                     ; Swap to bitmaps bank
  LD C,$00                ; bm2 = 0
  AND A                   ; (Suspect this is a stray instruction)
pms16_right_bitmap_jump:
  JR pms16_right_bitmap_jumptable_0 ; Jump into shifter (self modified by E2B6)
; Rotate the bitmap bytes (D,E,C) right by one pixel.
;
; Shift out the leftmost byte's bottom pixel into the carry flag.
pms16_right_bitmap_jumptable_0:
  SRL D                   ; carry = bm0 & 1; bm0 >>= 1
; Shift out the next byte's bottom pixel into the carry flag while shifting in the previous carry at the top. (x2)
  RR E                    ; new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry
  RR C                    ; new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry
pms16_right_bitmap_jumptable_1:
  SRL D                   ; Do the same again
  RR E                    ;
  RR C                    ;
pms16_right_bitmap_jumptable_2:
  SRL D                   ; Do the same again
  RR E                    ;
  RR C                    ;
pms16_right_bitmap_jumptable_end:
  LD HL,($81A2)           ; Load screen buffer pointer
  EXX                     ; Swap to bitmaps bank
; Plot, using the foreground mask. See pms24_right_plot_0 for a discussion of this masking operation.
pms16_right_plot_0:
  LD A,(HL)               ; Load a foreground mask byte
  CPL                     ; Invert it
  OR D                    ; OR with mask byte mask0
  EXX                     ; Swap to bank containing bitmap bytes (in D & E) and screen buffer pointer (in HL)
  AND (HL)                ; AND combined masks with screen byte
  EX AF,AF'               ; Bank left hand term
  LD A,D                  ; Get bitmap byte bm0
  EXX                     ; Swap to bank containing mask bytes (in D' & E') and foreground mask pointer (in HL')
  AND (HL)                ; AND with foreground mask byte
  LD D,A                  ; Save right hand term
  EX AF,AF'               ; Unbank left hand term
  OR D                    ; Combine terms
  INC L                   ; Advance foreground mask pointer
  EXX                     ; Swap to bitmaps bank
pms16_right_plot_enable_0:
  LD (HL),A               ; Write pixel (self modified)
  INC HL                  ; Advance to next output pixel
  EXX                     ; Swap to masks bank
pms16_right_plot_1:
  LD A,(HL)               ; Do the same again for mask1 & bm1
  CPL                     ;
  OR E                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,E                  ;
  EXX                     ;
  AND (HL)                ;
  LD E,A                  ;
  EX AF,AF'               ;
  OR E                    ;
  INC L                   ;
  EXX                     ;
pms16_right_plot_enable_1:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms16_right_plot_2:
  LD A,(HL)               ; Do the same again for mask2 & bm2
  CPL                     ;
  OR C                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,C                  ;
  EXX                     ;
  AND (HL)                ;
  LD C,A                  ;
  EX AF,AF'               ;
  OR C                    ;
  INC L                   ; Advance foreground_mask_pointer by two (buffer is 4 bytes wide)
  INC L                   ;
  LD (foreground_mask_pointer),HL ; Save foreground_mask_pointer
  POP HL                  ; Restore the mask pointer
  EXX
pms16_right_plot_enable_2:
  LD (HL),A
  LD DE,$0016             ; Advance screen buffer pointer by (24 - 2 = 22) bytes
  ADD HL,DE               ;
  LD ($81A2),HL           ; Save the screen buffer pointer
  POP HL                  ; Restore the bitmap pointer
  DEC B                   ; ...loop
  JP NZ,pms16_right_loop  ;
  RET                     ; Return
; Left shifting case.
;
; A is 4..7 here, which we intepret as -4..-1: the amount by which we want to shift the sprite left.
pms16_left:
  SUB $04                 ; 4..7 => jump table offset 0..3
  ADD A,A                 ; Multiply by six to get the jump distance
  LD L,A                  ;
  ADD A,A                 ;
  ADD A,L                 ;
  LD ($E39A),A            ; Self modify the JR at pms16_left_bitmap_jump to jump into the bitmap rotate sequence
  LD ($E37D),A            ; Self modify the JR at pms16_left_mask_jump to jump into the mask rotate sequence
  EXX                     ; Fetch mask_pointer
  LD HL,(mask_pointer)    ;
  EXX                     ; Fetch bitmap_pointer
  LD HL,(bitmap_pointer)  ;
pms16_left_height_iters:
  LD B,$20                ; Set B for 32 iterations (self modified by E492)
; Start loop
pms16_left_loop:
  LD D,(HL)               ; Load the bitmap bytes bm1,bm2 into D,E
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the bitmap pointer
  EXX                     ; Bank
  LD D,(HL)               ; Load the mask bytes mask1,mask2 into D',E'
  INC HL                  ;
  LD E,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve the mask pointer
  LD A,(flip_sprite)      ; Is the top bit of flip_sprite set?
  AND A                   ;
  CALL M,flip_16_masked_pixels ; Call flip_16_masked_pixels if so
  LD HL,(foreground_mask_pointer) ; Fetch foreground_mask_pointer
; Shift the mask.
  LD C,$FF                ; mask0 = $FF
  SCF                     ; carry = 1
pms16_left_mask_jump:
  JR pms16_left_mask_jumptable_0 ; Jump into shifter (self modified by E357)
; Rotate the mask bytes (C,D,E) left by one pixel.
pms16_left_mask_jumptable_0:
  RL E                    ; new_carry = mask2 >> 7; mask2 = (mask2 << 1) | carry; carry = new_carry
  RL D                    ; new_carry = mask1 >> 7; mask1 = (mask1 << 1) | carry; carry = new_carry
  RL C                    ; new_carry = mask0 >> 7; mask0 = (mask0 << 1) | carry; carry = new_carry
pms16_left_mask_jumptable_1:
  RL E                    ; Do the same again
  RL D                    ;
  RL C                    ;
pms16_left_mask_jumptable_2:
  RL E                    ; Do the same again
  RL D                    ;
  RL C                    ;
pms16_left_mask_jumptable_3:
  RL E                    ; Do the same again
  RL D                    ;
  RL C                    ;
; Shift the bitmap.
pms16_left_mask_jumptable_end:
  EXX                     ; Swap to bitmaps bank
  XOR A                   ; bm0 = 0
  LD C,A                  ;
pms16_left_bitmap_jump:
  JR pms16_left_bitmap_jumptable_0 ; Jump into shifter (self modified by E354)
; Rotate the bitmap bytes (C,D,E) left by one pixel.
pms16_left_bitmap_jumptable_0:
  SLA E                   ; carry = bm2 >> 7; bm2 <<= 1
  RL D                    ; new_carry = bm1 >> 7; bm1 = (bm1 << 1) | (carry << 0); carry = new_carry
  RL C                    ; new_carry = bm0 >> 7; bm0 = (bm0 << 1) | (carry << 0); carry = new_carry
pms16_left_bitmap_jumptable_1:
  SLA E                   ; Do the same again
  RL D                    ;
  RL C                    ;
pms16_left_bitmap_jumptable_2:
  SLA E                   ; Do the same again
  RL D                    ;
  RL C                    ;
pms16_left_bitmap_jumptable_3:
  SLA E                   ; Do the same again
  RL D                    ;
  RL C                    ;
; Plot, using foreground mask. See pms24_right_plot_0 for a discussion of this masking operation.
pms16_left_bitmap_jumptable_end:
  LD HL,($81A2)           ; Load screen buffer pointer
  EXX                     ; Swap to masks bank
pms16_left_plot_0:
  LD A,(HL)               ; Load a foreground mask byte
  CPL                     ; Invert it
  OR C                    ; OR with mask byte mask0
  EXX                     ; Swap to bank containing bitmap bytes (in D & E) and screen buffer pointer (in HL)
  AND (HL)                ; AND combined masks with screen byte
  EX AF,AF'               ; Bank left hand term
  LD A,C                  ; Get bitmap byte bm0
  EXX                     ; Swap to bank containing mask bytes (in D' & E') and foreground mask pointer (in HL')
  AND (HL)                ; AND with foreground mask byte
  LD C,A                  ; Save right hand term
  EX AF,AF'               ; Unbank left hand term
  OR C                    ; Combine terms
  INC L                   ; Advance foreground mask pointer
  EXX                     ; Swap to bitmaps bank
pms16_left_plot_enable_0:
  LD (HL),A               ; Write pixel (self modified)
  INC HL                  ; Advance to next output pixel
  EXX                     ; Swap to masks bank
pms16_left_plot_1:
  LD A,(HL)               ; Do the same again for mask1 & bm1
  CPL                     ;
  OR D                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,D                  ;
  EXX                     ;
  AND (HL)                ;
  LD D,A                  ;
  EX AF,AF'               ;
  OR D                    ;
  INC L                   ;
  EXX                     ;
pms16_left_plot_enable_1:
  LD (HL),A               ;
  INC HL                  ;
  EXX                     ;
pms16_left_plot_2:
  LD A,(HL)               ; Do the same again for mask2 & bm2
  CPL                     ;
  OR E                    ;
  EXX                     ;
  AND (HL)                ;
  EX AF,AF'               ;
  LD A,E                  ;
  EXX                     ;
  AND (HL)                ;
  LD E,A                  ;
  EX AF,AF'               ;
  OR E                    ;
  INC L                   ; Advance foreground_mask_pointer by two (buffer is 4 bytes wide)
  INC L                   ;
  LD (foreground_mask_pointer),HL ; Save foreground_mask_pointer
  POP HL                  ; Restore the mask pointer
  EXX
pms16_left_plot_enable_2:
  LD (HL),A
  LD DE,$0016             ; Advance screen buffer pointer by (24 - 2 = 22) bytes
  ADD HL,DE               ;
  LD ($81A2),HL           ; Save the screen buffer pointer
  POP HL                  ; Restore the bitmap pointer
  DEC B                   ; ...loop
  JP NZ,pms16_left_loop   ;
  RET                     ; Return

; Horizontally flips the 24 pixels in E,C,B and counterpart masks in E',C',B'.
;
; Used by the routine at plot_masked_sprite_24px.
;
; I:B Left 8 pixels.
; I:C Middle 8 pixels.
; I:E Right 8 pixels.
; O:B Flipped left 8 pixels.
; O:C Flipped middle 8 pixels.
; O:E Flipped right 8 pixels.
;
; Horizontally flip the bitmap bytes by looking up each byte in the flipped / bit-reversed table at $7F00 and swapping the left and right pixels over.
flip_24_masked_pixels:
  LD H,$7F                ; Point HL into the table of 256 flipped bytes at $7Fxx
  LD L,E                  ; Point HL at the flipped byte for E (right pixels)
  LD E,B                  ; Shuffle
  LD B,(HL)               ; Load the flipped byte into B
  LD L,E                  ; Point HL at the flipped byte for E (left pixels)
  LD E,(HL)               ; Load the flipped byte into E
  LD L,C                  ; Point HL at the flipped byte for C (middle pixels)
  LD C,(HL)               ; Load the flipped byte into C
; Likewise horizontally flip the mask bytes.
  EXX                     ; Swap bank to mask bytes
  LD H,$7F                ; Point HL into the table of 256 flipped bytes at $7Fxx
  LD L,E                  ; Point HL at the flipped byte for E (right mask)
  LD E,B                  ; Shuffle
  LD B,(HL)               ; Load the flipped byte into B
  LD L,E                  ; Point HL at the flipped byte for E (left mask)
  LD E,(HL)               ; Load the flipped byte into E
  LD L,C                  ; Point HL at the flipped byte for C (middle mask)
  LD C,(HL)               ; Load the flipped byte into C
  EXX                     ; Restore original bank
  RET                     ; Return

; Horizontally flips the 16 pixels in D,E and counterpart masks in D',E'.
;
; Used by the routines at pms16_right and pms16_left.
;
; I:D Left 8 pixels.
; I:E Right 8 pixels.
; O:D Flipped left 8 pixels.
; O:E Flipped right 8 pixels.
;
; Horizontally flip the bitmap bytes by looking up each byte in the flipped / bit-reversed table at $7F00 and swapping the left and right pixels over.
flip_16_masked_pixels:
  LD H,$7F                ; Point HL into the table of 256 flipped bytes at $7Fxx
  LD L,D                  ; Point HL at the flipped byte for D (left pixels)
  LD D,E                  ; Shuffle
  LD E,(HL)               ; Load the flipped byte into E
  LD L,D                  ; Point HL at the flipped byte for D (right pixels)
  LD D,(HL)               ; Load the flipped byte into D
; Likewise horizontally flip the mask bytes.
  EXX                     ; Swap bank to mask bytes
  LD H,$7F                ; Point HL into the table of 256 flipped bytes at $7Fxx
  LD L,D                  ; Point HL at the flipped byte for D (left mask)
  LD D,E                  ; Shuffle
  LD E,(HL)               ; Load the flipped byte into E
  LD L,D                  ; Point HL at the flipped byte for D (right mask)
  LD D,(HL)               ; Load the flipped byte into D
  EXX                     ; Restore original bank
  RET                     ; Return

; Set up vischar plotting.
;
; Used by the routine at plot_sprites.
;
; Counterpart of, and very similar to, the routine at setup_item_plotting.
;
; I:HL Pointer to visible character
; I:IY Pointer to visible character
; O:F Z set if vischar is visible, NZ otherwise
setup_vischar_plotting:
  LD A,$0F                ; Advance HL to vischar.mi.pos
  ADD A,L                 ;
  LD L,A                  ;
  LD DE,tinypos_stash_x   ; Point DE at tinypos_stash
  LD A,(room_index)       ; Fetch the global current room index
  AND A                   ; Are we outdoors?
  JR Z,svp_outdoors       ; Jump if so
; Indoors.
;
; Copy vischar.mi.pos.* to tinypos_stash with narrowing.
  LDI                     ; Copy vischar.mi.pos to tinypos_stash (narrowing each element to a byte wide)
  INC L                   ;
  LDI                     ;
  INC L                   ;
  LDI                     ;
  INC L                   ;
  JR svp_tinypos_set      ; (else)
; Outdoors.
;
; Copy vischar.mi.pos.* to tinypos_stash with scaling.
svp_outdoors:
  LD A,(HL)               ; Fetch vischar.mi.pos.x
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8_with_rounding ; Divide (C,A) by 8 with rounding. Result is in A
  LD (DE),A               ; Store the result as tinypos_stash.x
  INC L                   ; Advance HL to vischar.mi.pos.y
  INC DE                  ; Advance DE to tinypos_stash.y
  LD B,$02                ; Set B for two iterations
svp_pos_loop:
  LD A,(HL)               ; Fetch vischar.mi.pos.y or .height
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8        ; Divide (C,A) by 8 (with no rounding). Result is in A
  LD (DE),A               ; Store the result as tinypos_stash.y or .height
  INC L                   ; Advance to the next vischar.mi.pos field
  INC DE                  ; Advance to the next tinypos_stash field (then finally to iso_pos - used later)
  DJNZ svp_pos_loop       ; ...loop
svp_tinypos_set:
  LD C,(HL)               ; Load vischar.mi.sprite (a pointer to a spritedef_t) and stack it
  INC L                   ;
  LD B,(HL)               ;
  PUSH BC                 ;
  INC L                   ; Advance HL to vischar.mi.sprite_index
  LD A,(HL)               ; Load it
  LD (flip_sprite),A      ; Save global sprite_index and left/right flip flag
  EX AF,AF'               ; Bank it too
  INC L                   ; Advance HL to vischar.iso_pos
; Scale down iso_pos.*
  LD B,$02                ; Set B for two iterations
svp_isopos_loop:
  LD A,(HL)               ; Fetch vischar.iso_pos.x/y
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8        ; Divide (C,A) by 8 (with no rounding). Result is in A
  LD (DE),A               ; Write the result to state.iso_pos.*
  INC L                   ; Advance HL to the next vischar.iso_pos element
  INC DE                  ; Advance DE to the next state.iso_pos element
  DJNZ svp_isopos_loop    ; ...loop
  EX AF,AF'               ; Unbank sprite index
  POP DE                  ; Restore sprite pointer
  ADD A,A                 ; Multiply A by six (width of a spritedef_t)
  LD C,A                  ;
  ADD A,A                 ;
  ADD A,C                 ;
  ADD A,E                 ; Add onto sprite base pointer
  LD E,A                  ;
  JR NC,svp_sprptr_ready  ;
  INC D                   ;
svp_sprptr_ready:
  INC L                   ; Skip over vischar.room and unused bytes
  INC L                   ;
  EX DE,HL                ; Put sprite pointer into DE
  LDI                     ; Copy spritedef width in bytes to vischar
  LDI                     ; Copy spritedef height in rows to vischar
  LD DE,bitmap_pointer    ; Copy spritedef bitmap and mask pointers to global bitmap_pointer and mask_pointer
  LD BC,$0004             ;
  LDIR                    ;
  CALL vischar_visible    ; Clip the vischar's dimensions to the game window
  AND A                   ; Is it visible?
  RET NZ                  ; Return if not [RET NZ would do]
; The vischar is visible.
  PUSH BC                 ; Preserve the lefthand skip and clipped width
  PUSH DE                 ; Preserve the top skip and clipped height
; Self modify the sprite plotter routines.
  LD A,(IY+$1E)           ; Fetch vischar.width_bytes to check its width
  CP $03                  ; Is it 3? (3 => 16 pixels wide, 4 => 24 pixels wide)
  JR NZ,svp_24_wide       ; Jump if 24 wide
svp_16_wide:
  LD A,E                  ; Copy the clipped height into A
  LD ($E2C2),A            ; Write clipped height to the instruction at pms16_right_height_iters in plot_masked_sprite_16px (shift right case)
  LD ($E363),A            ; Write clipped height to the instruction at pms16_left_height_iters in plot_masked_sprite_16px (shift left case)
  LD A,$03                ; Set for three enables
  LD HL,masked_sprite_plotter_16_enables ; Point HL at masked_sprite_plotter_16_enables
  JR svp_do_enables       ; (else)
svp_24_wide:
  LD A,E                  ; Copy the clipped height into A
  LD ($E121),A            ; Write clipped height to the instruction at pms24_right_height_iters in plot_masked_sprite_24px (shift right case)
  LD ($E1E2),A            ; Write clipped height to the instruction at pms24_left_height_iters in plot_masked_sprite_24px (shift left case)
  LD A,$04                ; Set for four enables
  LD HL,masked_sprite_plotter_24_enables ; Point HL at masked_sprite_plotter_24_enables
svp_do_enables:
  PUSH HL                 ; Preserve enables pointer
  LD ($E4C0),A            ; Write enable count to the instruction at svp_enables_iters (self modify) and keep a copy
  LD E,A                  ;
  LD A,B                  ; Is the lefthand skip zero?
  AND A                   ;
  JR NZ,svp_enable_is_zero ; Jump if not
; There's no left hand skip - enable instructions.
svp_enable_is_one:
  LD A,$77                ; Load A' with the opcode of 'LD (HL),A'
  EX AF,AF'               ;
  LD A,C                  ; Set a counter to clipped_width. We'll write out this many bytes before clipping
  JR svp_enable_cont      ; (else)
svp_enable_is_zero:
  XOR A                   ; Load A' with the opcode of 'NOP'
  EX AF,AF'               ;
  LD A,E                  ; Set a counter to (enable_count - clipped_width). We'll clip until this many bytes have been written
  SUB C                   ;
svp_enable_cont:
  EXX                     ; Bank
  POP HL                  ; Restore enables pointer
  LD C,A                  ; Move counter to C
  EX AF,AF'               ; Unbank the opcode we'll write
; Set the addresses in the jump table to NOP or LD (HL),A.
svp_enables_iters:
  LD B,$03                ; Set B for 3 iterations (self modified by $E4A9)
; Start loop
svp_enables_loop:
  LD E,(HL)               ; Fetch an address
  INC HL                  ;
  LD D,(HL)               ;
  LD (DE),A               ; Write a new opcode
  INC HL                  ; Advance
  LD E,(HL)               ; Fetch an address
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ; Advance
  LD (DE),A               ; Write a new opcode
  DEC C                   ; Count down the counter
  JR NZ,setup_vischar_plotting_0 ; Jump if nonzero
  XOR $77                 ; Swap between LD (HL),A and NOP
setup_vischar_plotting_0:
  DJNZ svp_enables_loop   ; ...loop
; Calculate Y plotting offset.
;
; The full calculation can be avoided if we know there are rows to skip since in that case the sprite always starts at the top of the screen.
  EXX                     ; Bank
  LD A,D                  ; Is top skip zero?
  AND A                   ;
  LD DE,$0000             ; Initialise our Y value to zero
  JR NZ,svp_y_skip_set    ; Jump if top skip isn't zero
  LD A,($81BC)            ; Compute Y = map_position_y * 8 (pixels per column)
  LD L,A                  ;
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  EX DE,HL                ; Bank the temporary Y
  LD L,(IY+$1A)           ; Fetch vischar.iso_pos.y
  LD H,(IY+$1B)           ;
  AND A                   ; Clear carry flag
  SBC HL,DE               ; Compute Y = (vischar.iso_pos.y - Y)
  ADD HL,HL               ; Multiply Y by 24 (columns)
  ADD HL,HL               ;
  ADD HL,HL               ;
  LD E,L                  ;
  LD D,H                  ;
  ADD HL,HL               ;
  ADD HL,DE               ;
  EX DE,HL                ; Move Y into DE
svp_y_skip_set:
  LD A,(iso_pos_x)        ; Compute x = iso_pos_x - map_position_x
  LD HL,map_position      ;
  SUB (HL)                ;
  LD L,A                  ; Copy x to HL and sign extend it
  LD H,$00                ;
  JR NC,svp_x_skip_set    ;
  LD H,$FF                ;
svp_x_skip_set:
  ADD HL,DE               ; Combine the x and y values
  LD DE,$F290             ; Add the screen buffer start address
  ADD HL,DE               ;
  LD ($81A2),HL           ; Save the finalised screen buffer pointer
  LD HL,$8100             ; Point HL at the mask_buffer
  POP DE                  ; Retrieve the top skip and clipped height
  PUSH DE                 ;
  LD A,D                  ; mask buffer pointer += top_skip * 4
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,L                 ;
  LD L,A                  ;
  LD A,(IY+$1A)           ; mask buffer pointer += (vischar.iso_pos.y & 7) * 4
  AND $07                 ;
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,L                 ;
  LD L,A                  ;
  LD (foreground_mask_pointer),HL ; Set foreground_mask_pointer
  POP DE                  ; Retrieve the top skip and clipped height
  LD A,D                  ; Is top skip zero?
  AND A                   ;
  JR Z,setup_vischar_plotting_1 ; Jump if so
; Generic multiply loop.
  LD D,A                  ; Copy top_skip to loop counter
  XOR A                   ; Zero the accumulator
  LD E,(IY+$1E)           ; Set multiplier to (vischar.width_bytes - 1)
  DEC E                   ;
; Start loop
svp_mult_loop:
  ADD A,E                 ; Accumulate
  DEC D                   ; Decrement counter
  JP NZ,svp_mult_loop     ; ...loop
; D will be set to zero here either way: if the loop terminates, or if jumped into.
setup_vischar_plotting_1:
  LD E,A                  ; Set DE to skip (result)
  LD HL,(bitmap_pointer)  ; Advance bitmap_pointer by 'skip'
  ADD HL,DE               ;
  LD (bitmap_pointer),HL  ;
  LD HL,(mask_pointer)    ; Advance mask_pointer by 'skip'
  ADD HL,DE               ;
  LD (mask_pointer),HL    ;
; It's unclear as to why this value is preserved since it's not used by the caller.
  POP BC                  ; Restore the lefthand skip and clipped width
; The Z flag remains set from E52E signalling "is visible".
  RET                     ; Return

; Scale down a pos_t and assign result to a tinypos_t.
;
; Used by the routines at drop_item_tail, in_permitted_area, reset_visible_character, character_behaviour and guards_follow_suspicious_character.
;
; Divides the three input 16-bit words by 8, with rounding to nearest, storing the result as bytes.
;
; I:HL Pointer to input pos_t.
; I:DE Pointer to output tinypos_t.
; O:HL Updated.
; O:DE Updated.
pos_to_tinypos:
  LD B,$03                ; Set B for three iterations
; Start loop
pos_to_tinypos_0:
  LD A,(HL)               ; Load (A, C)
  INC L                   ;
  LD C,(HL)               ;
  CALL divide_by_8_with_rounding ; Divide (A, C) by 8, with rounding to nearest
  LD (DE),A               ; Save the result
  INC L                   ; Advance HL to the next input pos
  INC DE                  ; Advance DE to the next output tinypos
  DJNZ pos_to_tinypos_0   ; ...loop
  RET                     ; Return

; Divide AC by 8, with rounding to nearest.
;
; Used by the routines at calc_interior_item_iso_pos, purge_invisible_characters, setup_vischar_plotting and pos_to_tinypos.
;
; I:A Low.
; I:C High.
; O:A Result.
divide_by_8_with_rounding:
  ADD A,$04               ; Add 4 to AC
  JR NC,divide_by_8       ;
  INC C                   ;
; FALL THROUGH into divide_by_8.

; Divide AC by 8.
;
; Used by the routines at reset_outdoors, purge_invisible_characters, setup_vischar_plotting and divide_by_8_with_rounding.
;
; I:A Low.
; I:C High.
; O:A Result.
divide_by_8:
  SRL C                   ; Rotate a bit out of C ...
  RRA                     ; Rotate a bit ouf of A ...
  SRL C                   ; And again
  RRA                     ;
  SRL C                   ; And again
  RRA                     ;
  RET                     ; Return

; Masks
;
; Mask encoding: A top-bit-set byte indicates a repetition, the count of which is in the bottom seven bits. The subsequent byte is the value to repeat.
;
; { byte count+flags; ... }
exterior_mask_0:
  DEFB $2A,$A0,$00,$05,$07,$08,$09,$01 ; exterior_mask_0
  DEFB $0A,$A2,$00,$05,$06,$04,$85,$01 ;
  DEFB $0B,$9F,$00,$05,$06,$04,$88,$01 ;
  DEFB $0C,$9C,$00,$05,$06,$04,$8A,$01 ;
  DEFB $0D,$0E,$99,$00,$05,$06,$04,$8D ;
  DEFB $01,$0F,$10,$96,$00,$05,$06,$04 ;
  DEFB $90,$01,$11,$94,$00,$05,$06,$04 ;
  DEFB $92,$01,$12,$92,$00,$05,$06,$04 ;
  DEFB $94,$01,$12,$90,$00,$05,$06,$04 ;
  DEFB $96,$01,$12,$8E,$00,$05,$06,$04 ;
  DEFB $98,$01,$12,$8C,$00,$05,$06,$04 ;
  DEFB $9A,$01,$12,$8A,$00,$05,$06,$04 ;
  DEFB $9C,$01,$12,$88,$00,$05,$06,$04 ;
  DEFB $9E,$01,$18,$86,$00,$05,$06,$04 ;
  DEFB $A1,$01,$84,$00,$05,$06,$04,$A3 ;
  DEFB $01,$00,$00,$05,$06,$04,$A5,$01 ;
  DEFB $05,$03,$04,$A7,$01,$02,$A9,$01 ;
  DEFB $02,$A9,$01,$02,$A9,$01,$02,$A9 ;
  DEFB $01,$02,$A9,$01,$02,$A9,$01,$02 ;
  DEFB $A9,$01,$02,$A9,$01,$02,$A9,$01 ;
exterior_mask_1:
  DEFB $12,$02,$91,$01,$02,$91,$01,$02 ; exterior_mask_1
  DEFB $91,$01,$02,$91,$01,$02,$91,$01 ;
  DEFB $02,$91,$01,$02,$91,$01,$02,$91 ;
  DEFB $01,$02,$91,$01,$02,$91,$01     ;
exterior_mask_2:
  DEFB $10,$13,$14,$15,$8D,$00,$16,$17 ; exterior_mask_2
  DEFB $18,$17,$15,$8B,$00,$19,$1A,$1B ;
  DEFB $17,$18,$17,$15,$89,$00,$19,$1A ;
  DEFB $1C,$1A,$1B,$17,$18,$17,$15,$87 ;
  DEFB $00,$19,$1A,$1C,$1A,$1C,$1A,$1B ;
  DEFB $17,$13,$14,$15,$85,$00,$19,$1A ;
  DEFB $1C,$1A,$1C,$1A,$1C,$1D,$16,$17 ;
  DEFB $18,$17,$15,$83,$00,$19,$1A,$1C ;
  DEFB $1A,$1C,$1A,$1C,$1D,$19,$1A,$1B ;
  DEFB $17,$18,$17,$15,$00,$19,$1A,$1C ;
  DEFB $1A,$1C,$1A,$1C,$1D,$19,$1A,$1C ;
  DEFB $1A,$1B,$17,$18,$17,$00,$20,$1C ;
  DEFB $1A,$1C,$1A,$1C,$1D,$19,$1A,$1C ;
  DEFB $1A,$1C,$1A,$1B,$17,$83,$00,$20 ;
  DEFB $1C,$1A,$1C,$1D,$19,$1A,$1C,$1A ;
  DEFB $1C,$1A,$1C,$1D,$85,$00,$20,$1C ;
  DEFB $1D,$19,$1A,$1C,$1A,$1C,$1A,$1C ;
  DEFB $1D,$87,$00,$1F,$19,$1A,$1C,$1A ;
  DEFB $1C,$1A,$1C,$1D,$89,$00,$20,$1C ;
  DEFB $1A,$1C,$1A,$1C,$1D,$8B,$00,$20 ;
  DEFB $1C,$1A,$1C,$1D,$8D,$00,$20,$1C ;
  DEFB $1D,$8F,$00,$1F                 ;
exterior_mask_3:
  DEFB $1A,$88,$00,$05,$4C,$90,$00,$86 ; exterior_mask_3
  DEFB $00,$05,$06,$04,$32,$30,$4C,$8E ;
  DEFB $00,$84,$00,$05,$06,$04,$84,$01 ;
  DEFB $32,$30,$4C,$8C,$00,$00,$00,$05 ;
  DEFB $06,$04,$88,$01,$32,$30,$4C,$8A ;
  DEFB $00,$00,$06,$04,$8C,$01,$32,$30 ;
  DEFB $4C,$88,$00,$02,$90,$01,$32,$30 ;
  DEFB $4C,$86,$00,$02,$92,$01,$32,$30 ;
  DEFB $4C,$84,$00,$02,$94,$01,$32,$30 ;
  DEFB $4C,$00,$00,$02,$96,$01,$32,$30 ;
  DEFB $00,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12,$02,$98,$01,$12,$02,$98,$01 ;
  DEFB $12                             ;
exterior_mask_4:
  DEFB $0D,$02,$8C,$01,$02,$8C,$01,$02 ; exterior_mask_4
  DEFB $8C,$01,$02,$8C,$01             ;
exterior_mask_5:
  DEFB $0E,$02,$8C,$01,$12,$02,$8C,$01 ; exterior_mask_5
  DEFB $12,$02,$8C,$01,$12,$02,$8C,$01 ;
  DEFB $12,$02,$8C,$01,$12,$02,$8C,$01 ;
  DEFB $12,$02,$8C,$01,$12,$02,$8C,$01 ;
  DEFB $12,$02,$8D,$01,$02,$8D,$01     ;
exterior_mask_6:
  DEFB $08,$5B,$5A,$86,$00,$01,$01,$5B ; exterior_mask_6
  DEFB $5A,$84,$00,$84,$01,$5B,$5A,$00 ;
  DEFB $00,$86,$01,$5B,$5A,$D8,$01     ;
exterior_mask_7:
  DEFB $09,$88,$01,$12,$88,$01,$12,$88 ; exterior_mask_7
  DEFB $01,$12,$88,$01,$12,$88,$01,$12 ;
  DEFB $88,$01,$12,$88,$01,$12,$88,$01 ;
  DEFB $12                             ;
exterior_mask_8:
  DEFB $10,$8D,$00,$23,$24,$25,$8B,$00 ; exterior_mask_8
  DEFB $23,$26,$27,$26,$28,$89,$00,$23 ;
  DEFB $26,$27,$26,$22,$29,$2A,$87,$00 ;
  DEFB $23,$26,$27,$26,$22,$29,$2B,$29 ;
  DEFB $2A,$85,$00,$23,$24,$25,$26,$22 ;
  DEFB $29,$2B,$29,$2B,$29,$2A,$83,$00 ;
  DEFB $23,$26,$27,$26,$28,$2F,$2B,$29 ;
  DEFB $2B,$29,$2B,$29,$2A,$00,$23,$26 ;
  DEFB $27,$26,$22,$29,$2A,$2F,$2B,$29 ;
  DEFB $2B,$29,$2B,$29,$2A,$26,$27,$26 ;
  DEFB $22,$29,$2B,$29,$2A,$2F,$2B,$29 ;
  DEFB $2B,$29,$2B,$29,$2A,$26,$22,$29 ;
  DEFB $2B,$29,$2B,$29,$2A,$2F,$2B,$29 ;
  DEFB $2B,$29,$2B,$31,$2D,$2F,$2B,$29 ;
  DEFB $2B,$29,$2B,$29,$2A,$2F,$2B,$29 ;
  DEFB $2B,$31,$83,$00,$2F,$2B,$29,$2B ;
  DEFB $29,$2B,$29,$2A,$2F,$2B,$31,$85 ;
  DEFB $00,$2F,$2B,$29,$2B,$29,$2B,$29 ;
  DEFB $2A,$2E,$87,$00,$2F,$2B,$29,$2B ;
  DEFB $29,$2B,$31,$2D,$88,$00,$2F,$2B ;
  DEFB $29,$2B,$31,$8B,$00,$2F,$2B,$31 ;
  DEFB $8D,$00,$2E,$8F,$00             ;
exterior_mask_9:
  DEFB $0A,$83,$00,$05,$06,$30,$4C,$83 ; exterior_mask_9
  DEFB $00,$00,$05,$06,$04,$01,$01,$32 ;
  DEFB $30,$4C,$00,$34,$04,$86,$01,$32 ;
  DEFB $33,$83,$00,$40,$01,$01,$3F,$83 ;
  DEFB $00,$02,$46,$47,$48,$49,$42,$41 ;
  DEFB $45,$44,$12,$34,$01,$01,$46,$4B ;
  DEFB $43,$44,$01,$01,$33,$00,$3C,$3E ;
  DEFB $40,$01,$01,$3F,$37,$39,$00,$83 ;
  DEFB $00,$3D,$3A,$3B,$38,$83,$00     ;
exterior_mask_10:
  DEFB $08,$35,$86,$01,$36,$90,$01,$88 ; exterior_mask_10
  DEFB $00,$3C,$86,$00,$39,$3C,$00,$02 ;
  DEFB $36,$35,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39,$3C,$00,$02 ;
  DEFB $01,$01,$12,$00,$39             ;
exterior_mask_11:
  DEFB $08,$01,$4F,$86,$00,$01,$50,$01 ; exterior_mask_11
  DEFB $4F,$84,$00,$01,$00,$00,$51,$01 ;
  DEFB $4F,$00,$00,$01,$00,$00,$53,$19 ;
  DEFB $50,$01,$4F,$01,$00,$00,$53,$19 ;
  DEFB $00,$00,$52,$01,$00,$00,$53,$19 ;
  DEFB $00,$00,$52,$01,$54,$00,$53,$19 ;
  DEFB $00,$00,$52,$83,$00,$55,$19,$00 ;
  DEFB $00,$52,$85,$00,$54,$00,$52     ;
exterior_mask_12:
  DEFB $02,$56,$57,$56,$57,$58,$59,$58 ; exterior_mask_12
  DEFB $59,$58,$59,$58,$59,$58,$59,$58 ;
  DEFB $59                             ;
exterior_mask_13:
  DEFB $05,$00,$00,$23,$24,$25,$02,$00 ; exterior_mask_13
  DEFB $27,$26,$28,$02,$00,$22,$26,$28 ;
  DEFB $02,$00,$2B,$29,$2A,$02,$00,$2B ;
  DEFB $29,$2A,$02,$00,$2B,$29,$2A,$02 ;
  DEFB $00,$2B,$29,$2A,$02,$00,$2B,$29 ;
  DEFB $2A,$02,$00,$2B,$31,$00,$02,$00 ;
  DEFB $83,$00                         ;
exterior_mask_14:
  DEFB $04,$19,$83,$00,$19,$17,$15,$00 ; exterior_mask_14
  DEFB $19,$17,$18,$17,$19,$1A,$1B,$17 ;
  DEFB $19,$1A,$1C,$1D,$19,$1A,$1C,$1D ;
  DEFB $19,$1A,$1C,$1D,$19,$1A,$1C,$1D ;
  DEFB $19,$1A,$1C,$1D,$00,$20,$1C,$1D ;
interior_mask_15:
  DEFB $02,$04,$32,$01,$01 ; interior_mask_15
interior_mask_16:
  DEFB $09,$86,$00,$5D,$5C,$54,$84,$00 ; interior_mask_16
  DEFB $5D,$5C,$01,$01,$01,$00,$00,$5D ;
  DEFB $5C,$85,$01,$5D,$5C,$87,$01,$2B ;
  DEFB $88,$01                         ;
interior_mask_17:
  DEFB $05,$00,$00,$5D,$5C,$67,$5D,$5C ; interior_mask_17
  DEFB $83,$01,$3C,$84,$01             ;
interior_mask_18:
  DEFB $02,$5D,$68,$3C,$69 ; interior_mask_18
interior_mask_19:
  DEFB $0A,$86,$00,$5D,$5C,$46,$47,$84 ; interior_mask_19
  DEFB $00,$5D,$5C,$83,$01,$39,$00,$00 ;
  DEFB $5D,$5C,$86,$01,$5D,$5C,$88,$01 ;
  DEFB $4A,$89,$01                     ;
interior_mask_20:
  DEFB $06,$5D,$5C,$01,$47,$6A,$00,$4A ; interior_mask_20
  DEFB $84,$01,$6B,$00,$84,$01,$5F     ;
interior_mask_21:
  DEFB $04,$05,$4C,$00,$00,$61,$65,$66 ; interior_mask_21
  DEFB $4C,$61,$12,$02,$60,$61,$12,$02 ;
  DEFB $60,$61,$12,$02,$60,$61,$12,$02 ;
  DEFB $60                             ;
interior_mask_22:
  DEFB $04,$00,$00,$05,$4C,$05,$63,$64 ; interior_mask_22
  DEFB $60,$61,$12,$02,$60,$61,$12,$02 ;
  DEFB $60,$61,$12,$02,$60,$61,$12,$02 ;
  DEFB $60,$61,$12,$62,$00             ;
interior_mask_23:
  DEFB $03,$00,$6C,$00,$02,$01,$68,$02 ; interior_mask_23
  DEFB $01,$69                         ;
interior_mask_24:
  DEFB $05,$01,$5E,$4C,$00,$00,$01,$01 ; interior_mask_24
  DEFB $32,$30,$00,$84,$01,$5F         ;
interior_mask_25:
  DEFB $02,$6E,$5A,$6D,$39,$3C,$39 ; interior_mask_25
interior_mask_26:
  DEFB $04,$5D,$5C,$46,$47,$4A,$01,$01 ; interior_mask_26
  DEFB $39                             ;
interior_mask_27:
  DEFB $03,$2C,$47,$00,$00,$61,$12,$00 ; interior_mask_27
  DEFB $61,$12                         ;
interior_mask_28:
  DEFB $03,$00,$45,$1E,$02,$60,$00,$02 ; interior_mask_28
  DEFB $60,$00                         ;
interior_mask_29:
  DEFB $05,$45,$1E,$2C,$47,$00,$2C,$47 ; interior_mask_29
  DEFB $45,$1E,$12,$00,$61,$12,$61,$12 ;
  DEFB $00,$61,$5F,$00,$00             ;

; Interior masking data.
;
; Used only by setup_room.
;
; 47 mask structs with the constant final height byte omitted.
;
; Copied to $81DB by setup_room.
interior_mask_data_source:
  DEFB $1B,$7B,$7F,$F1,$F3,$36,$28 ; $1B, { $7B, $7F, $F1, $F3 }, { $36, $28 }
  DEFB $1B,$77,$7B,$F3,$F5,$36,$18 ; $1B, { $77, $7B, $F3, $F5 }, { $36, $18 }
  DEFB $1B,$7C,$80,$F1,$F3,$32,$2A ; $1B, { $7C, $80, $F1, $F3 }, { $32, $2A }
  DEFB $19,$83,$86,$F2,$F7,$18,$24 ; $19, { $83, $86, $F2, $F7 }, { $18, $24 }
  DEFB $19,$81,$84,$F4,$F9,$18,$1A ; $19, { $81, $84, $F4, $F9 }, { $18, $1A }
  DEFB $19,$81,$84,$F3,$F8,$1C,$17 ; $19, { $81, $84, $F3, $F8 }, { $1C, $17 }
  DEFB $19,$83,$86,$F4,$F8,$16,$20 ; $19, { $83, $86, $F4, $F8 }, { $16, $20 }
  DEFB $18,$7D,$80,$F4,$F9,$18,$1A ; $18, { $7D, $80, $F4, $F9 }, { $18, $1A }
  DEFB $18,$7B,$7E,$F3,$F8,$22,$1A ; $18, { $7B, $7E, $F3, $F8 }, { $22, $1A }
  DEFB $18,$79,$7C,$F4,$F9,$22,$10 ; $18, { $79, $7C, $F4, $F9 }, { $22, $10 }
  DEFB $18,$7B,$7E,$F4,$F9,$1C,$17 ; $18, { $7B, $7E, $F4, $F9 }, { $1C, $17 }
  DEFB $18,$79,$7C,$F1,$F6,$2C,$1E ; $18, { $79, $7C, $F1, $F6 }, { $2C, $1E }
  DEFB $18,$7D,$80,$F2,$F7,$24,$22 ; $18, { $7D, $80, $F2, $F7 }, { $24, $22 }
  DEFB $1D,$7F,$82,$F6,$F7,$1C,$1E ; $1D, { $7F, $82, $F6, $F7 }, { $1C, $1E }
  DEFB $1D,$82,$85,$F2,$F3,$23,$30 ; $1D, { $82, $85, $F2, $F3 }, { $23, $30 }
  DEFB $1D,$86,$89,$F2,$F3,$1C,$37 ; $1D, { $86, $89, $F2, $F3 }, { $1C, $37 }
  DEFB $1D,$86,$89,$F4,$F5,$18,$30 ; $1D, { $86, $89, $F4, $F5 }, { $18, $30 }
  DEFB $1D,$80,$83,$F1,$F2,$28,$30 ; $1D, { $80, $83, $F1, $F2 }, { $28, $30 }
  DEFB $1C,$81,$82,$F4,$F6,$1C,$20 ; $1C, { $81, $82, $F4, $F6 }, { $1C, $20 }
  DEFB $1C,$83,$84,$F4,$F6,$1C,$2E ; $1C, { $83, $84, $F4, $F6 }, { $1C, $2E }
  DEFB $1A,$7E,$80,$F5,$F7,$1C,$20 ; $1A, { $7E, $80, $F5, $F7 }, { $1C, $20 }
  DEFB $12,$7A,$7B,$F2,$F3,$3A,$28 ; $12, { $7A, $7B, $F2, $F3 }, { $3A, $28 }
  DEFB $12,$7A,$7B,$EF,$F0,$45,$35 ; $12, { $7A, $7B, $EF, $F0 }, { $45, $35 }
  DEFB $17,$80,$85,$F4,$F6,$1C,$24 ; $17, { $80, $85, $F4, $F6 }, { $1C, $24 }
  DEFB $14,$80,$84,$F3,$F5,$26,$28 ; $14, { $80, $84, $F3, $F5 }, { $26, $28 }
  DEFB $15,$84,$85,$F6,$F7,$1A,$1E ; $15, { $84, $85, $F6, $F7 }, { $1A, $1E }
  DEFB $15,$7E,$7F,$F3,$F4,$2E,$26 ; $15, { $7E, $7F, $F3, $F4 }, { $2E, $26 }
  DEFB $16,$7C,$85,$EF,$F3,$32,$22 ; $16, { $7C, $85, $EF, $F3 }, { $32, $22 }
  DEFB $16,$79,$82,$F0,$F4,$34,$1A ; $16, { $79, $82, $F0, $F4 }, { $34, $1A }
  DEFB $16,$7D,$86,$F2,$F6,$24,$1A ; $16, { $7D, $86, $F2, $F6 }, { $24, $1A }
  DEFB $10,$76,$78,$F5,$F7,$36,$0A ; $10, { $76, $78, $F5, $F7 }, { $36, $0A }
  DEFB $10,$7A,$7C,$F3,$F5,$36,$0A ; $10, { $7A, $7C, $F3, $F5 }, { $36, $0A }
  DEFB $10,$7E,$80,$F1,$F3,$36,$0A ; $10, { $7E, $80, $F1, $F3 }, { $36, $0A }
  DEFB $10,$82,$84,$EF,$F1,$36,$0A ; $10, { $82, $84, $EF, $F1 }, { $36, $0A }
  DEFB $10,$86,$88,$ED,$EF,$36,$0A ; $10, { $86, $88, $ED, $EF }, { $36, $0A }
  DEFB $10,$8A,$8C,$EB,$ED,$36,$0A ; $10, { $8A, $8C, $EB, $ED }, { $36, $0A }
  DEFB $11,$73,$75,$EB,$ED,$0A,$30 ; $11, { $73, $75, $EB, $ED }, { $0A, $30 }
  DEFB $11,$77,$79,$ED,$EF,$0A,$30 ; $11, { $77, $79, $ED, $EF }, { $0A, $30 }
  DEFB $11,$7B,$7D,$EF,$F1,$0A,$30 ; $11, { $7B, $7D, $EF, $F1 }, { $0A, $30 }
  DEFB $11,$7F,$81,$F1,$F3,$0A,$30 ; $11, { $7F, $81, $F1, $F3 }, { $0A, $30 }
  DEFB $11,$83,$85,$F3,$F5,$0A,$30 ; $11, { $83, $85, $F3, $F5 }, { $0A, $30 }
  DEFB $11,$87,$89,$F5,$F7,$0A,$30 ; $11, { $87, $89, $F5, $F7 }, { $0A, $30 }
  DEFB $10,$84,$86,$F4,$F7,$0A,$30 ; $10, { $84, $86, $F4, $F7 }, { $0A, $30 }
  DEFB $11,$87,$89,$ED,$EF,$0A,$30 ; $11, { $87, $89, $ED, $EF }, { $0A, $30 }
  DEFB $11,$7B,$7D,$F3,$F5,$0A,$0A ; $11, { $7B, $7D, $F3, $F5 }, { $0A, $0A }
  DEFB $11,$79,$7B,$F4,$F6,$0A,$0A ; $11, { $79, $7B, $F4, $F6 }, { $0A, $0A }
  DEFB $0F,$88,$8C,$F5,$F8,$0A,$0A ; $0F, { $88, $8C, $F5, $F8 }, { $0A, $0A }

; Pointers to run-length encoded mask data.
;
; The first half is outdoor masks, the second is indoor masks.
;
; 30 pointers to byte arrays.
mask_pointers:
  DEFW exterior_mask_0    ; exterior_mask
  DEFW exterior_mask_1    ; exterior_mask
  DEFW exterior_mask_2    ; exterior_mask
  DEFW exterior_mask_3    ; exterior_mask
  DEFW exterior_mask_4    ; exterior_mask
  DEFW exterior_mask_5    ; exterior_mask
  DEFW exterior_mask_6    ; exterior_mask
  DEFW exterior_mask_7    ; exterior_mask
  DEFW exterior_mask_8    ; exterior_mask
  DEFW exterior_mask_9    ; exterior_mask
  DEFW exterior_mask_10   ; exterior_mask
  DEFW exterior_mask_11   ; exterior_mask
  DEFW exterior_mask_13   ; exterior_mask
  DEFW exterior_mask_14   ; exterior_mask
  DEFW exterior_mask_12   ; exterior_mask
  DEFW interior_mask_29   ; interior_mask
  DEFW interior_mask_27   ; interior_mask
  DEFW interior_mask_28   ; interior_mask
  DEFW interior_mask_15   ; interior_mask
  DEFW interior_mask_16   ; interior_mask
  DEFW interior_mask_17   ; interior_mask
  DEFW interior_mask_18   ; interior_mask
  DEFW interior_mask_19   ; interior_mask
  DEFW interior_mask_20   ; interior_mask
  DEFW interior_mask_21   ; interior_mask
  DEFW interior_mask_22   ; interior_mask
  DEFW interior_mask_23   ; interior_mask
  DEFW interior_mask_24   ; interior_mask
  DEFW interior_mask_25   ; interior_mask
  DEFW interior_mask_26   ; interior_mask

; mask_t structs for the exterior scene.
;
; 58 mask_t structs.
;
; 'mask_t' defines a mask:
;
; +-----------+-------+--------+-------------------------------------------------------------------------------------------------------------------------------------------------+
; | Type      | Bytes | Name   | Meaning                                                                                                                                         |
; +-----------+-------+--------+-------------------------------------------------------------------------------------------------------------------------------------------------+
; | Byte      | 1     | index  | An index into mask_pointers                                                                                                                     |
; | bounds_t  | 4     | bounds | The isometric projected bounds of the mask. Used for culling                                                                                    |
; | tinypos_t | 3     | pos    | If a character is behind this point then the mask is enabled. ("Behind" here means when character coord x is greater and y is greater-or-equal) |
; +-----------+-------+--------+-------------------------------------------------------------------------------------------------------------------------------------------------+
;
; Used by render_mask_buffer. Used in outdoor mode only.
exterior_mask_data:
  DEFB $00,$47,$70,$27,$3F,$6A,$52,$0C
  DEFB $00,$5F,$88,$33,$4B,$5E,$52,$0C
  DEFB $00,$77,$A0,$3F,$57,$52,$52,$0C
  DEFB $01,$9F,$B0,$28,$31,$3E,$6A,$3C
  DEFB $01,$9F,$B0,$32,$3B,$3E,$6A,$3C
  DEFB $02,$40,$4F,$4C,$5B,$46,$46,$08
  DEFB $02,$50,$5F,$54,$63,$46,$46,$08
  DEFB $02,$60,$6F,$5C,$6B,$46,$46,$08
  DEFB $02,$70,$7F,$64,$73,$46,$46,$08
  DEFB $02,$30,$3F,$54,$63,$3E,$3E,$08
  DEFB $02,$40,$4F,$5C,$6B,$3E,$3E,$08
  DEFB $02,$50,$5F,$64,$73,$3E,$3E,$08
  DEFB $02,$60,$6F,$6C,$7B,$3E,$3E,$08
  DEFB $02,$70,$7F,$74,$83,$3E,$3E,$08
  DEFB $02,$10,$1F,$64,$73,$4A,$2E,$08
  DEFB $02,$20,$2F,$6C,$7B,$4A,$2E,$08
  DEFB $02,$30,$3F,$74,$83,$4A,$2E,$08
  DEFB $03,$2B,$44,$33,$47,$67,$45,$12
  DEFB $04,$2B,$37,$48,$4B,$6D,$45,$08
  DEFB $05,$37,$44,$48,$51,$67,$45,$08
  DEFB $06,$08,$0F,$2A,$3C,$6E,$46,$0A
  DEFB $06,$10,$17,$2E,$40,$6E,$46,$0A
  DEFB $06,$18,$1F,$32,$44,$6E,$46,$0A
  DEFB $06,$20,$27,$36,$48,$6E,$46,$0A
  DEFB $06,$28,$2F,$3A,$4C,$6E,$46,$0A
  DEFB $07,$08,$10,$1F,$26,$82,$46,$12
  DEFB $07,$08,$10,$27,$2D,$82,$46,$12
  DEFB $08,$80,$8F,$64,$73,$46,$46,$08
  DEFB $08,$90,$9F,$5C,$6B,$46,$46,$08
  DEFB $08,$A0,$B0,$54,$63,$46,$46,$08
  DEFB $08,$B0,$BF,$4C,$5B,$46,$46,$08
  DEFB $08,$C0,$CF,$44,$53,$46,$46,$08
  DEFB $08,$80,$8F,$74,$83,$3E,$3E,$08
  DEFB $08,$90,$9F,$6C,$7B,$3E,$3E,$08
  DEFB $08,$A0,$B0,$64,$73,$3E,$3E,$08
  DEFB $08,$B0,$BF,$5C,$6B,$3E,$3E,$08
  DEFB $08,$C0,$CF,$54,$63,$3E,$3E,$08
  DEFB $08,$D0,$DF,$4C,$5B,$3E,$3E,$08
  DEFB $08,$40,$4F,$74,$83,$4E,$2E,$08
  DEFB $08,$50,$5F,$6C,$7B,$4E,$2E,$08
  DEFB $08,$10,$1F,$58,$67,$68,$2E,$08
  DEFB $08,$20,$2F,$50,$5F,$68,$2E,$08
  DEFB $08,$30,$3F,$48,$57,$68,$2E,$08
  DEFB $09,$1B,$24,$4E,$55,$68,$37,$0F
  DEFB $0A,$1C,$23,$51,$5D,$68,$38,$0A
  DEFB $09,$3B,$44,$72,$79,$4E,$2D,$0F
  DEFB $0A,$3C,$43,$75,$81,$4E,$2E,$0A
  DEFB $09,$7B,$84,$62,$69,$46,$45,$0F
  DEFB $0A,$7C,$83,$65,$71,$46,$46,$0A
  DEFB $09,$AB,$B4,$4A,$51,$46,$5D,$0F
  DEFB $0A,$AC,$B3,$4D,$59,$46,$5E,$0A
  DEFB $0B,$58,$5F,$5A,$62,$46,$46,$08
  DEFB $0B,$48,$4F,$62,$6A,$3E,$3E,$08
  DEFB $0C,$0B,$0F,$60,$67,$68,$2E,$08
  DEFB $0D,$0C,$0F,$61,$6A,$4E,$2E,$08
  DEFB $0E,$7F,$80,$7C,$83,$3E,$3E,$08
  DEFB $0D,$2C,$2F,$51,$5A,$3E,$3E,$08
  DEFB $0D,$3C,$3F,$49,$52,$46,$46,$08

; Saved stack pointer.
;
; Used by plot_game_window and wipe_game_window.
saved_sp:
  DEFW $0000

; Game screen start addresses.
;
; 128 screen pointers.
game_window_start_addresses:
  DEFW $4047
  DEFW $4147
  DEFW $4247
  DEFW $4347
  DEFW $4447
  DEFW $4547
  DEFW $4647
  DEFW $4747
  DEFW $4067
  DEFW $4167
  DEFW $4267
  DEFW $4367
  DEFW $4467
  DEFW $4567
  DEFW $4667
  DEFW $4767
  DEFW $4087
  DEFW $4187
  DEFW $4287
  DEFW $4387
  DEFW $4487
  DEFW $4587
  DEFW $4687
  DEFW $4787
  DEFW $40A7
  DEFW $41A7
  DEFW $42A7
  DEFW $43A7
  DEFW $44A7
  DEFW $45A7
  DEFW $46A7
  DEFW $47A7
  DEFW $40C7
  DEFW $41C7
  DEFW $42C7
  DEFW $43C7
  DEFW $44C7
  DEFW $45C7
  DEFW $46C7
  DEFW $47C7
  DEFW $40E7
  DEFW $41E7
  DEFW $42E7
  DEFW $43E7
  DEFW $44E7
  DEFW $45E7
  DEFW $46E7
  DEFW $47E7
  DEFW $4807
  DEFW $4907
  DEFW $4A07
  DEFW $4B07
  DEFW $4C07
  DEFW $4D07
  DEFW $4E07
  DEFW $4F07
  DEFW $4827
  DEFW $4927
  DEFW $4A27
  DEFW $4B27
  DEFW $4C27
  DEFW $4D27
  DEFW $4E27
  DEFW $4F27
  DEFW $4847
  DEFW $4947
  DEFW $4A47
  DEFW $4B47
  DEFW $4C47
  DEFW $4D47
  DEFW $4E47
  DEFW $4F47
  DEFW $4867
  DEFW $4967
  DEFW $4A67
  DEFW $4B67
  DEFW $4C67
  DEFW $4D67
  DEFW $4E67
  DEFW $4F67
  DEFW $4887
  DEFW $4987
  DEFW $4A87
  DEFW $4B87
  DEFW $4C87
  DEFW $4D87
  DEFW $4E87
  DEFW $4F87
  DEFW $48A7
  DEFW $49A7
  DEFW $4AA7
  DEFW $4BA7
  DEFW $4CA7
  DEFW $4DA7
  DEFW $4EA7
  DEFW $4FA7
  DEFW $48C7
  DEFW $49C7
  DEFW $4AC7
  DEFW $4BC7
  DEFW $4CC7
  DEFW $4DC7
  DEFW $4EC7
  DEFW $4FC7
  DEFW $48E7
  DEFW $49E7
  DEFW $4AE7
  DEFW $4BE7
  DEFW $4CE7
  DEFW $4DE7
  DEFW $4EE7
  DEFW $4FE7
  DEFW $5007
  DEFW $5107
  DEFW $5207
  DEFW $5307
  DEFW $5407
  DEFW $5507
  DEFW $5607
  DEFW $5707
  DEFW $5027
  DEFW $5127
  DEFW $5227
  DEFW $5327
  DEFW $5427
  DEFW $5527
  DEFW $5627
  DEFW $5727

; Plot the game screen.
;
; This transfers the game's linear screen buffer into the game window region of the Spectrum's screen memory. The input buffer is 24x17x8 bytes. The output region is smaller at 23x16x8 bytes. The addresses are stored precalculated in the
; table at game_window_start_addresses.
;
; Scrolling to 4-bit nibble accuracy is permitted by implementing two cases here: aligned and unaligned. Aligned transfers just have to move the bytes across and so are fast. Unaligned transfers have to roll bytes right to effect the left
; shift, so are much slower.
;
; The aligned case copies 23 bytes per scanline starting at $F291 (one byte into buffer). The unaligned case rolls the bytes right (so it moves left? CHECK) starting at $F290.
;
; Uses the Z80 SP stack trick.
;
; Used by the routines at main_loop and screen_reset.
plot_game_window:
  LD (saved_sp),SP        ; Preserve the stack pointer
  LD A,($A7C8)            ; Read upper byte of game_window_offset
  AND A                   ; Is it nonzero?
  JP NZ,pgw_unaligned     ; Jump if so
pgw_aligned:
  LD HL,$F291             ; Point HL at the screen buffer's start address + 1
  LD A,(game_window_offset) ; Read lower byte of game_window_offset
  ADD A,L                  ; Combine
  JR NC,plot_game_window_0 ;
  INC H                    ;
plot_game_window_0:
  LD L,A                   ;
  LD SP,game_window_start_addresses ; Point SP at game_window_start_addresses
  LD A,$80                ; There are 128 rows
; Start loop
plot_game_window_1:
  POP DE                  ; Pop a target address off the stack
  LDI                     ; Copy 23 bytes
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  LDI                     ;
  INC HL                  ; Skip the 24th input byte
  DEC A                    ; ...loop
  JP NZ,plot_game_window_1 ;
  LD SP,(saved_sp)        ; Restore the stack pointer
  RET                     ; Return
pgw_unaligned:
  LD HL,$F290             ; Point HL at the screen buffer's start address
  LD A,(game_window_offset) ; Read lower byte of game_window_offset
  ADD A,L                  ; Combine
  JR NC,plot_game_window_2 ;
  INC H                    ;
plot_game_window_2:
  LD L,A                   ;
  LD A,(HL)               ; Fetch a first source byte
  INC L                   ;
  LD SP,game_window_start_addresses ; Point SP at game_window_start_addresses
  EXX                     ; Bank
  LD B,$80                ; There are 128 rows
; Start loop
plot_game_window_3:
  EXX                     ; Unbank
  POP DE                  ; Pop a target address off the stack
  LD B,$04                ; 4 iterations of 5, plus 3 at the end = 23
; Start loop
plot_game_window_4:
  LD C,(HL)               ; Fetch a second source byte (so we can restore it later)
; RRD does a 12-bit rotate: nibble_out = (HL) & $0F; (HL) = ((HL) >> 4) | (A << 4); A = (A & $F0) | nibble_out;
  RRD                     ; Shift (HL) down and rotate A's bottom nibble into the top of (HL)
  EX AF,AF'               ; Bank
  LD A,(HL)               ; Load the rotated and merged value
  LD (DE),A               ; Store it to the screen
  LD (HL),C               ; Restore the corrupted byte
  EX AF,AF'               ; Unbank
  INC HL                  ; Advance
  INC E                   ; Advance
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  DJNZ plot_game_window_4 ; ...loop
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD C,(HL)               ; Repeat
  RRD                     ;
  EX AF,AF'               ;
  LD A,(HL)               ;
  LD (DE),A               ;
  LD (HL),C               ;
  EX AF,AF'               ;
  INC HL                  ;
  INC E                   ;
  LD A,(HL)               ; Preload the next scanline's first input byte
  INC HL                  ;
  EXX                     ; Unbank
  DJNZ plot_game_window_3 ; ...loop
  LD SP,(saved_sp)        ; Restore the stack pointer
  RET                     ; Return

; Event: roll call.
;
; Range checking that X is in ($72..$7C) and Y is in ($6A..$72).
;
; Is the hero within the roll call area bounds?
event_roll_call:
  LD DE,$727C             ; Load DE with the X coordinates of the roll call area ($72..$7C)
  LD HL,hero_map_position_x ; Point HL at global map position (hero)
  LD B,$02                ; Set B for two iterations
; Start loop
event_roll_call_0:
  LD A,(HL)               ; Fetch the next coord
  CP D                    ; Jump if the hero's out of bounds
  JR C,not_at_roll_call   ;
  CP E                    ;
  JR NC,not_at_roll_call  ;
  INC HL                  ; On the second iteration advance to hero_map_position_y ($6A..$72)
  LD DE,$6A72             ; On the second iteration load DE with the Y coordinates of the main gate ($6A..$72)
  DJNZ event_roll_call_0  ; ...loop
; Make all visible characters turn forward.
  LD HL,$800D             ; Point HL at the visible character's input field (always $800D)
  LD B,$08                ; Set B for 8 iterations
; Start loop
event_roll_call_1:
  LD (HL),$80             ; Set input to input_KICK
  INC L                   ; Point HL at the visible character's direction field (always $800E)
  LD (HL),$03             ; Set the direction field to 3 => face bottom left
  LD A,L                  ; Advance HL to the next vischar
  ADD A,$1F               ;
  LD L,A                  ;
  DJNZ event_roll_call_1  ; ...loop
  RET                     ; Return
not_at_roll_call:
  XOR A                   ; Make the bell ring perpetually
  LD (bell),A             ;
  LD B,A                  ; Queue the message "MISSED ROLL CALL"
  CALL queue_message      ;
  JP hostiles_pursue      ; Exit via hostiles_pursue

; Use papers.
;
; Is the hero within the main gate bounds?
;
; Range checking that X is in ($69..$6D) and Y is in ($49..$4B).
action_papers:
  LD DE,$696D             ; Load DE with the X coordinates of the main gate ($69..$6D)
  LD HL,hero_map_position_x ; Point HL at global map position (hero)
  LD B,$02                ; Set B for two iterations
; Start loop
ap_coord_check_loop:
  LD A,(HL)               ; Fetch the next coord
  CP D                    ; Return if the hero's out of bounds
  RET C                   ;
  CP E                    ;
  RET NC                  ;
  INC HL                  ; On the second iteration advance to hero_map_position_y ($49..$4B)
  LD DE,$494B             ; On the second iteration load DE with the Y coordinates of the main gate
  DJNZ ap_coord_check_loop ; ...loop
; The hero was within the bounds of the main gate.
;
; Using the papers at the main gate when not in uniform causes the hero to be sent to solitary. Check for that.
  LD DE,sprite_guard      ; Point DE at the guard sprite set
  LD A,($8015)            ; Load hero's vischar.mi.sprite
  CP E                    ; Jump to solitary if not using the guard sprite set
  JP NZ,solitary          ;
; The hero was wearing the uniform so is transported outside of the gate.
  CALL increase_morale_by_10_score_by_50 ; Increase morale by 10, score by 50
  XOR A                   ; Set hero's vischar.room to room_0_OUTDOORS
  LD ($801C),A            ;
; Transition to outside the main gate.
  LD HL,outside_main_gate ; Point HL at outside_main_gate location
  LD IY,$8000             ; Point IY at the hero's vischar
  JP transition           ; Jump to transition -- never returns
; The position outside of the main gate to which the hero is transported.
outside_main_gate:
  DEFB $D6,$8A,$06

; Wait for the user to press 'Y' or 'N'.
;
; Used by the routines at keyscan_break and choose_keys.
;
; O:F 'Y'/'N' pressed => return Z/NZ
user_confirm:
  LD HL,LF014               ; Print "CONFIRM. Y OR N"
  CALL screenlocstring_plot ;
; Start loop (infinite)
user_confirm_0:
  LD BC,$DFFE             ; Set BC to port_KEYBOARD_POIUY
  IN A,(C)                ; Read the port
  BIT 4,A                 ; Was bit 4 clear? (active low meaning 'Y' is pressed)
  RET Z                   ; Return with Z set if so
  LD B,$7F                ; Set BC to port_KEYBOARD_SPACESYMSHFTMNB
  IN A,(C)                ; Read the port
  CPL                     ; Invert the bits to turn active low into active high
  BIT 3,A                 ; Was bit 3 set? (active high meaning 'N' is pressed)
  RET NZ                  ; Return with Z clear if so
  JR user_confirm_0       ; ...loop

; Confirm query.
LF014:
  DEFB $0B,$50,$0F,$0C,$00,$17,$0F,$12,$1A,$16,$24,$23,$21,$23,$00,$1A,$23,$17 ; "CONFIRM. Y OR N"

; Further game messages.
more_messages_he_takes_the_bribe:
  DEFB $11,$0E,$23,$1C,$0A,$14,$0E,$1B,$23,$1C,$11,$0E,$23,$0B,$1A,$12,$0B,$0E,$FF ; "HE TAKES THE BRIBE"
more_messages_and_acts_as_decoy:
  DEFB $0A,$17,$0D,$23,$0A,$0C,$1C,$1B,$23,$0A,$1B,$23,$0D,$0E,$0C,$00,$21,$FF ; "AND ACTS AS DECOY"
more_messages_another_day_dawns:
  DEFB $0A,$17,$00,$1C,$11,$0E,$1A,$23,$0D,$0A,$21,$23,$0D,$0A,$1F,$17,$1B,$FF ; "ANOTHER DAY DAWNS"

; Locked gates and doors.
locked_doors:
  DEFB $80,$81            ; gates
  DEFB $8D,$8C,$8E,$A2,$98,$9F,$96 ; doors
  DEFB $00,$00            ; unused

; Jump to main.
;
; Used by the routine at loaded.
jump_to_main:
  JP main

; User-defined keys.
;
; Pairs of (port, key mask).
keydefs:
  DEFB $00,$00            ; Left
  DEFB $00,$00            ; Right
  DEFB $00,$00            ; Up
  DEFB $00,$00            ; Down
  DEFB $00,$00            ; Fire

; Everything from $F0F8 onwards is potentially overwritten by the game once the main menu is exited.
;
; Memory Map
; ----------
; $F0F8..$F28F - 24x17 = 408 bytes of tile_buf
; $F290..$FF4F - 24x17x8 = 3,264 bytes of window_buf
; $FF50..$FF57 - seems to be an extra UDG's worth of window_buf to allow overspills
; $FF58..$FF7A - 7x5 = 35 bytes of map_buf
; $FF80..$FFFF - the stack

; Static tiles plot direction.
;
; +-------+------------+
; | Value | Meaning    |
; +-------+------------+
; | 0     | Horizontal |
; | 255   | Vertical   |
; +-------+------------+
static_tiles_plot_direction:
  DEFB $00

; Definitions of fixed graphic elements.
;
; Only used by plot_statics_and_menu_text.
;
; +---------+--------+------------------+---------------------------+
; | Type    | Bytes  | Name             | Meaning                   |
; +---------+--------+------------------+---------------------------+
; | Pointer | 2      | screenloc        | Screen address to draw at |
; | Byte    | 1      | flags_and_length | Direction flag and length |
; | Byte    | Length | tiles            | Index into static_tiles   |
; +---------+--------+------------------+---------------------------+
statics_flagpole:
  DEFB $21,$40,$94,$18,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$1A,$1A
statics_game_window_left_border:
  DEFB $06,$40,$94,$02,$04,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$0E,$10
statics_game_window_right_border:
  DEFB $1E,$40,$94,$05,$07,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$11,$12,$09,$0B
statics_game_window_top_border:
  DEFB $27,$40,$17,$13,$14,$13,$14,$13,$14,$13,$14,$13,$14,$15,$16,$17,$13,$14,$13,$14,$13,$14,$13,$14,$13,$14
statics_game_window_bottom:
  DEFB $47,$50,$17,$13,$14,$13,$14,$13,$14,$13,$14,$13,$14,$15,$16,$17,$13,$14,$13,$14,$13,$14,$13,$14,$13,$14
statics_flagpole_grass:
  DEFB $A0,$50,$05,$1F,$1B,$1C,$1D,$1E
statics_medals_row0:
  DEFB $73,$50,$0D,$20,$21,$22,$21,$23,$21,$24,$21,$22,$21,$25,$0B,$0C
statics_medals_row1:
  DEFB $93,$50,$0B,$26,$4E,$27,$4E,$28,$4E,$29,$4E,$27,$4E,$2A
statics_medals_row2:
  DEFB $B3,$50,$0B,$2B,$2C,$2D,$2C,$2E,$2C,$2F,$2C,$2D,$2C,$30
statics_medals_row3:
  DEFB $D3,$50,$0B,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B
statics_medals_row4:
  DEFB $F3,$50,$0A,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$45
statics_bell_row0:
  DEFB $6E,$50,$03,$46,$47,$48
statics_bell_row1:
  DEFB $8E,$50,$03,$49,$4A,$4B
statics_bell_row2:
  DEFB $AE,$50,$02,$4C,$4D
statics_corner_tl:
  DEFB $05,$40,$82,$01,$03
statics_corner_tr:
  DEFB $1F,$40,$82,$06,$08
statics_corner_bl:
  DEFB $45,$50,$82,$0D,$0F
statics_corner_br:
  DEFB $5F,$50,$82,$0A,$0C

; The game starts here.
;
; Used by the routine at jump_to_main.
main:
  DI                      ; Disable interrupts
; Q: Why is the stack pointer set to $FFFE here when squash_stack_goto_main sets it to $FFFF?
  LD SP,$FFFE             ; Point the stack pointer at the end of RAM
; Clear the screen.
  CALL wipe_full_screen_and_attributes ; Clear the full screen and attributes and set the screen border to black
; Set the morale flag to green.
  LD A,$44                ; Set A to attribute_BRIGHT_GREEN_OVER_BLACK
  CALL set_morale_flag_screen_attributes ; Set the screen attributes of the morale flag
; Draw everything else.
;
; Bug: This passes in index $44 to set_menu_item_attributes in A, but it ought to be zero.
  LD E,$46                ; Set E to attribute_BRIGHT_YELLOW_OVER_BLACK
  CALL set_menu_item_attributes ; Set the screen attributes of the specified menu item
  CALL plot_statics_and_menu_text ; Plot all static graphics and menu text
  CALL plot_score         ; Draw the current score to screen
; Run the menu screen.
;
; We'll be in here for some time until the user selects their input method. When we return we'll continue setting up the things required for the game, then jump into the main loop.
  CALL menu_screen        ; Runs the menu screen
; Construct a table of 256 bit-reversed bytes at $7F00.
  LD HL,static_tiles      ; Point HL at $7F00
; Start loop
main_0:
  LD A,L                  ; Shuffle
  LD C,$00                ; Zero C (DPT: Could have used XOR C)
; Reverse a byte
  LD B,$08                ; Set B for eight iterations
; Start loop
main_1:
  RRA                     ; Shift out lowest bit from A into carry
  RL C                    ; Shift carry into C
  DJNZ main_1             ; ...loop until the byte is completed
  LD (HL),C               ; Store the reversed byte
  INC L                   ;
  JP NZ,main_0            ; ...loop until L becomes zero
  INC H                   ; Advance HL to $8000
; Initialise visible characters (HL is $8000).
  LD DE,vischar_initial   ; Point DE at vischar_initial
  LD B,$08                ; Set B for eight iterations
; Start loop
main_2:
  PUSH BC                 ; Preserve loop counter
  PUSH DE                 ; Preserve vischar_initial
  PUSH HL                 ; Preserve vischar pointer
  LD BC,$0017             ; Populate the vischar slot with vischar_initial's data
  EX DE,HL                ;
  LDIR                    ;
  POP HL                  ; Restore vischar pointer
  LD A,$20                ; Advance HL to the next vischar (assumes no overflow)
  ADD A,L                 ;
  LD L,A                  ;
  POP DE                  ; Restore vischar_initial
  POP BC                  ; ...loop until the vischars are populated
  DJNZ main_2             ;
; Write $FF $FF at $8020 and every 32 bytes after. (DPT: Possibly easier to do the inverse and clear those bytes at $8000).
  LD B,$07                ; Set B for seven iterations
; Iterate over non-player visible characters.
  LD HL,$8020             ; Start at the second visible character
  LD DE,$001F             ; Prepare the vischar stride, minus a byte
  LD A,$FF                ; Prepare the index / flags initialiser
; Start loop
main_3:
  LD (HL),A               ; Set the vischar's character index to $FF
  INC L                   ; Advance HL to the flags field
  LD (HL),A               ; Set the vischar's flags to $FF
  ADD HL,DE               ; Advance the vischar pointer
  DJNZ main_3             ; ...loop until the vischar flags are set
; Zero $118 bytes at HL ($8100 is mask_buffer) onwards.
;
; This wipes everything up until the start of tiles ($8218).
  LD BC,$0118             ; Set B to $118
; Start loop
main_4:
  LD (HL),$00             ; Zero and advance
  INC HL                  ;
  DEC BC                  ; ...loop until cleared
  LD A,C                  ;
  OR B                    ;
  JP NZ,main_4            ;
  CALL reset_game         ; Reset the game
  JP main_loop_setup      ; Jump to main_loop_setup
; Initial state of a visible character.
vischar_initial:
  DEFB $00                ; character
  DEFB $00                ; flags
  DEFW $012C              ; route
  DEFB $2E,$2E,$18        ; target
  DEFB $00                ; counter_and_flags
  DEFW animations         ; animbase
  DEFW anim_wait_tl       ; anim
  DEFB $00                ; animindex
  DEFB $00                ; input
  DEFB $00                ; direction
  DEFW $0000,$0000,$0018  ; mi.pos
  DEFW sprite_prisoner    ; mi.sprite

; Plot all static graphics and menu text.
;
; Used by the routine at main. Plot all static graphics.
plot_statics_and_menu_text:
  LD HL,statics_flagpole  ; Point HL at static_graphic_defs
  LD B,$12                ; Set B for 18 iterations
; Start loop
plot_statics_and_menu_text_0:
  PUSH BC                 ; Preserve the loop counter
  LD E,(HL)               ; Read the target screen address
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  BIT 7,(HL)              ; Is the statictiles_VERTICAL flag set?
  JR Z,plot_statics_and_menu_text_1 ; Jump if not
  CALL plot_static_tiles_vertical ; Plot static tiles vertically
  JR plot_statics_and_menu_text_2 ; (else)
plot_statics_and_menu_text_1:
  CALL plot_static_tiles_horizontal ; Plot static tiles horizontally
plot_statics_and_menu_text_2:
  POP BC                  ; Restore the loop counter
  DJNZ plot_statics_and_menu_text_0 ; ...loop
; Plot menu text.
  LD B,$08                ; Set B for 8 iterations
  LD HL,key_choice_screenlocstrings ; Point HL at key_choice_screenlocstrings
; Start loop
plot_statics_and_menu_text_3:
  PUSH BC                 ; Preserve the loop counter
  CALL screenlocstring_plot ; Plot a single glyph (indirectly)
  POP BC                  ; Restore the loop counter
  DJNZ plot_statics_and_menu_text_3 ; ...loop
  RET                     ; Return

; Plot static tiles horizontally.
;
; Used by the routine at plot_statics_and_menu_text.
;
; I:DE Pointer to screen address.
; I:HL Pointer to [count, tile indices, ...].
plot_static_tiles_horizontal:
  XOR A                   ; Set direction flag to zero
  JR plot_static_tiles    ; Exit via plot static tiles

; Plot static tiles vertically.
;
; Used by the routine at plot_statics_and_menu_text.
;
; I:DE Pointer to screen address.
; I:HL Pointer to [count, tile indices, ...].
plot_static_tiles_vertical:
  LD A,$FF                ; Set the plot direction flag to $FF (vertical)
; FALL THROUGH into plot_static_tiles

; Plot static tiles.
;
; Used by the routine at plot_static_tiles_horizontal.
;
; I:A Plot direction: 0 => horizontal, $FF => vertical.
; I:DE Pointer to destination screen address.
; I:HL Pointer to remainder of static graphic bytes [flags_and_length, tile indices...].
plot_static_tiles:
  LD (static_tiles_plot_direction),A ; Save a copy of the plot direction
  LD A,(HL)               ; Load flags_and_length
  AND $7F                 ; Mask off length
  LD B,A                  ; Set B for loop iterations
  INC HL                  ; Advance to tile indices
  PUSH DE                 ; Preserve the pointer to screen address
  EXX                     ; Bank
  POP DE                  ; Restore the pointer to screen address
  EXX                     ; Unbank
; Start loop (once for each tile)
plot_static_tiles_0:
  LD A,(HL)               ; Read a tile index
  EXX                     ; Bank
; Point HL at static_tiles[tileindex]
  LD C,A                  ; Multiply the tile index by 9
  LD B,$00                ;
  LD L,A                  ;
  LD H,$00                ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,HL               ;
  ADD HL,BC               ;
  LD BC,static_tiles      ; Point BC at static_tiles[0]
  ADD HL,BC               ; Combine
  LD B,$08                ; Set B for 8 iterations
; Plot a tile.
;
; Start loop (once for each byte/row)
plot_static_tiles_1:
  LD A,(HL)               ; Copy a byte of tile
  LD (DE),A               ;
  INC D                   ; Advance DE to the next screen row
  INC HL                  ;
  DJNZ plot_static_tiles_1 ; ...loop
  DEC D                   ; Step DE back so it's still in the right block
  PUSH DE                 ; Preserve screen pointer
; Calculate screen attribute address of tile.
  LD A,D                  ; Get screen pointer high byte
  LD D,$58                ; Set the attribute pointer to $58xx by default
  CP $48                   ; If the screen pointer is $48xx... set the attribute pointer to $59xx
  JR C,plot_static_tiles_2 ;
  INC D                    ;
  CP $50                   ; If the screen pointer is $50xx... set the attribute pointer to $5Axx
  JR C,plot_static_tiles_2 ;
  INC D                    ;
plot_static_tiles_2:
  LD A,(HL)               ; Copy the attribute byte which follows the tile data
  LD (DE),A               ;
  POP HL                  ; Restore screen pointer
  LD A,(static_tiles_plot_direction) ; Fetch static_tiles_plot_direction
  AND A                   ; Is it vertical?
  JR NZ,plot_static_tiles_3 ; Jump if so
; Horizontal
;
; Reset and advance the screen pointer
  LD A,H                  ; Rewind the screen pointer by 7 rows
  SUB $07                 ;
  LD H,A                  ;
  INC L                   ; Advance to the next character
  JR plot_static_tiles_4  ; (else)
; Vertical
plot_static_tiles_3:
  CALL next_scanline_down ; Get the same position on the next scanline down
plot_static_tiles_4:
  EX DE,HL                ; Move new scanline pointer into DE
  EXX                     ; Unbank
  INC HL                  ; Advance to the next input byte
  DJNZ plot_static_tiles_0 ; ...loop
  RET                     ; Return

; Clear the full screen and attributes and set the screen border to black.
;
; Used by the routine at main.
;
; Clear the pixels to zero
wipe_full_screen_and_attributes:
  LD HL,screen            ; Point HL at the start of the screen (source address)
  LD DE,$4001             ; Point DE at the start of the screen plus a byte (destination address)
  LD (HL),$00             ; Set the first screen byte to zero
  LD BC,$17FF             ; 6143 bytes
  LDIR                    ; Copy source to destination 6143 times, advancing until the screen is cleared
; Clear the attributes to white over black
  INC HL                  ; Advance HL to the start of the attributes (source address)
  INC DE                  ; Advance DE to the start of the attributes plus a byte (destination address)
  LD (HL),$07             ; Set the first attribute byte to seven (white over black)
  LD BC,$02FF             ; 767 bytes
  LDIR                    ; Copy source to destination 767 times, advancing until the screen is cleared
; Set the border to black
  XOR A                   ; Set A to zero
  OUT ($FE),A             ; Set the border (and speaker)
  RET                     ; Return

; Menu screen key handling.
;
; Used by the routine at menu_screen.
;
; Scan for a keypress. It will either start the game, select an input device or do nothing. If an input device is chosen, update the menu highlight to match and record which input device was chosen.
;
; If the game is started then copy the required input routine to $F075. If the chosen input device is the keyboard, then exit via choose_keys.
check_menu_keys:
  CALL menu_keyscan       ; Scan for keys that select an input device. Result is in A
  CP $FF                  ; Nothing selected?
  RET Z                   ; Return if so
  AND A                   ; Start game (zero) pressed?
  JR Z,cmk_cpy_rout       ; Jump if so
  DEC A                   ; Turn 1..4 into 0..3
; Clear old selection.
  PUSH AF                 ; Preserve index
  LD A,(chosen_input_device) ; Load previously chosen input device index
  LD E,$07                ; Set E to attribute_WHITE_OVER_BLACK
  CALL set_menu_item_attributes ; Set the screen attributes of the specified menu item
  POP AF                  ; Restore index
; Highlight new selection.
  LD (chosen_input_device),A ; Set chosen input device index
  LD E,$46                ; Set E to attribute_BRIGHT_YELLOW_OVER_BLACK
  CALL set_menu_item_attributes ; Set the screen attributes of the specified menu item
  RET                     ; Return
; Zero pressed to start game.
;
; Copy the input routine to $F075, choose keys if keyboard was chosen, then return to main.
cmk_cpy_rout:
  LD A,(chosen_input_device) ; Load chosen input device index
  ADD A,A                 ; Double it
; This is tricky. A' is left with the low byte of the inputroutine address. In the case of the keyboard, it's zero. choose_keys relies on that in a non-obvious way. [DPT: Check this comment]
  LD C,A                  ; Widen to BC
  LD B,$00                ;
  EX AF,AF'               ; Preserve index
  LD HL,inputroutines     ; Point HL at the list of available input routines
  ADD HL,BC               ; Combine
  LD A,(HL)               ; Fetch input routine address into HL
  INC HL                  ;
  LD H,(HL)               ;
  LD L,A                  ;
  LD DE,static_tiles_plot_direction ; Set the destination address
  LD BC,$004A             ; Worst-case length of an input routine
  LDIR                    ; Copy
  EX AF,AF'               ; Restore index
  AND A                   ; Was the keyboard chosen?
  CALL Z,choose_keys      ; Call choose keys if so
  POP BC                  ; Discard the previous return address and resume at F17D
  RET                     ;

; Key choice prompt strings.
define_key_prompts:
  DEFB $6D,$40,$0B,$0C,$11,$00,$00,$1B,$0E,$23,$14,$0E,"!",$1B ; "CHOOSE KEYS"
  DEFB $CD,$40,$05,$15,$0E,$0F,$1C,"$" ; "LEFT."
  DEFB $0D,$48,$06,$1A,$12,$10,$11,$1C,"$" ; "RIGHT."
  DEFB $4D,$48,$03,$1D,$18,"$" ; "UP."
  DEFB $8D,$48,$05,$0D,$00,$1F,$17,"$" ; "DOWN."
  DEFB $CD,$48,$05,$0F,$12,$1A,$0E ; "FIRE."

; byte_F2E1
;
; Unsure if anything reads this byte for real, but its address is taken prior to accessing keyboard_port_hi_bytes.
;
; (<- choose_keys)
byte_F2E1:
  DEFB $24

; Table of keyscan high bytes.
;
; Zero terminated.
;
; (<- choose_keys)
keyboard_port_hi_bytes:
  DEFB $F7,$EF,$FB,$DF,$FD,$BF,$FE,$7F,$00

; Table of special key name strings, prefixed by their length.
special_key_names:
  DEFB $05,$0E,$17,$1C,$0E,$1A ; "ENTER"
  DEFB $04,$0C,$0A,$18,$1B ; "CAPS"
  DEFB $06,$1B,$21,$16,$0B,$00,$15 ; "SYMBOL"
  DEFB $05,$1B,$18,$0A,$0C,$0E ; "SPACE"

; Table mapping key codes to glyph indices.
;
; Each table entry is a character (a glyph index) OR if its top bit is set then bottom seven bits are an index into special_key_names.
keycode_to_glyph:
  DEFB $01,$02,$03,$04,$05 ; table_12345
  DEFB $00,$09,$08,$07,$06 ; table_09876
  DEFB $19,$1F,$0E,$1A,$1C ; table_QWERT
  DEFB $18,$00,$12,$1D,$21 ; table_POIUY
  DEFB $0A,$1B,$0D,$0F,$10 ; table_ASDFG
  DEFB $80,$15,$14,$13,$11 ; table_ENTERLKJH
  DEFB $86,$22,$20,$0C,$1E ; table_SHIFTZXCV
  DEFB $92,$8B,$16,$17,$0B ; table_SPACESYMSHFTMNB

; Screen addresses where chosen key names are plotted.
key_name_screen_addrs:
  DEFW $40D5
  DEFW $4815
  DEFW $4855
  DEFW $4895
  DEFW $48D5

; Wipe the game screen.
;
; This wipes the area of the screen where the game window is plotted.
;
; Used by the routine at choose_keys.
wipe_game_window:
  DI                      ; Disable interrupts
; This uses the optimisation trick of popping addresses from the stack.
  LD (saved_sp),SP        ; Save the stack pointer
  LD SP,game_window_start_addresses ; Point the stack pointer at game_window_start_addresses
  LD A,$80                ; Set A for 128 iterations (128 rows)
; Start loop
wipe_game_window_0:
  POP HL                  ; Pull a start address from the stack
  LD B,$17                ; Set B for 23 iterations (23 bytes)
; Start loop
wipe_game_window_1:
  LD (HL),$00             ; Write an empty byte
  INC L                   ; Advance (note cheap increment)
  DJNZ wipe_game_window_1 ; ...loop
  DEC A                    ; ...loop
  JP NZ,wipe_game_window_0 ;
  LD SP,(saved_sp)        ; Restore the stack pointer
  RET                     ; Return

; Choose keys.
;
; Used by the routine at check_menu_keys.
;
; Start loop (infinite) - loops until the user confirms the key selection.
;
; Clear the game window.
choose_keys:
  CALL wipe_game_window   ; Wipe the game screen
  LD A,$07                        ; Set game window attributes to attribute_WHITE_OVER_BLACK
  CALL set_game_window_attributes ;
; Draw key choice prompts.
  LD B,$06                ; Set B for six iterations
  LD HL,define_key_prompts ; Point HL at define_key_prompts
; Start loop (once per prompt)
ck_prompts_loop:
  PUSH BC                 ; Preserve the loop counter
  LD E,(HL)               ; Read screen address
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  LD B,(HL)               ; Read string length
  INC HL                  ;
; Draw the prompt's glyphs.
;
; Start loop (once per character)
ck_draw_prompt:
  PUSH BC                 ; Preserve string length
; Bug: The next load is needless (plot_glyph does it already).
  LD A,(HL)               ; Read a glyph
  CALL plot_glyph         ; Plot a single glyph (indirectly)
  INC HL                  ; Advance the string pointer
  POP BC                  ; Restore string length
  DJNZ ck_draw_prompt     ; ...loop (once per character)
  POP BC                  ; Restore the loop counter
  DJNZ ck_prompts_loop    ; ...loop (once per prompt)
; Wipe key definitions.
  LD HL,keydefs           ; Point HL at keydefs
  LD B,$0A                ; Set B for 10 iterations
  XOR A                   ; Zero A in preparation
; Start loop
ck_clear_keydef:
  LD (HL),A               ; Zero a byte of keydef
  INC HL                  ; Advance HL
  DJNZ ck_clear_keydef    ; ...loop
; Now scan for keys.
  LD B,$05                ; Set B for five iterations: left/right/up/down/fire
  LD HL,key_name_screen_addrs ; Point HL at key_name_screen_addrs
; Start loop (once per direction+fire)
ck_keyscan_loop:
  PUSH BC                 ; Preserve the loop counter
  LD E,(HL)               ; Read screen address
  INC HL                  ;
  LD D,(HL)               ;
  INC HL                  ;
  PUSH HL                 ; Preserve screen address
  LD ($F3E9),DE           ; Self modify the "LD DE,$xxxx" at ck_plot_glyph to load the screen address
  LD A,$FF                ; Set the debounce flag. This is only set to zero once we've checked the whole keyboard and no keys are pressed, at which point it gets set to zero
; Start loop (infinite)
ck_keyscan_inner:
  EX AF,AF'               ; Bank the debounce flag
  LD HL,byte_F2E1         ; Point HL at keyboard_port_hi_bytes[-1]
  LD D,$FF                ; Initialise the port index
; Start loop
ck_try_next_port:
  INC HL                  ; Advance HL to the next port high byte
  INC D                   ; Increment the port index
  LD A,(HL)               ; Read the port high byte
  OR A                    ; Have we reached the end of keyboard_port_hi_bytes? ($00)
  JR Z,ck_keyscan_inner   ; ...loop if so (zero in A becomes new debounce flag)
  LD B,A                  ; Read port high byte
  LD C,$FE                ; Read port $FE
  IN A,(C)                ; Read the keyboard port
  CPL                     ; Invert the bits to turn active low into active high
  LD E,A                  ; Copy the result into E so we can restore it each time
  LD C,$20                ; Create a mask with bit 5 set
; Test bits 4,3,2,1,0
ck_keyscan_detect:
  SRL C                   ; Shift the mask right
  JR C,ck_try_next_port   ; Jump (to try next port) if the mask bit got shifted out
  LD A,C                  ; Mask the result
  AND E                   ;
  JR Z,ck_keyscan_detect  ; ...loop while no keys are pressed
; We arrive here if a key was pressed.
  EX AF,AF'               ; Unbank the debounce flag
  OR A                    ; Is it set?
  JR NZ,ck_keyscan_inner  ; Restart the loop if so (A is debounce flag)
  LD A,D                  ; Bank the port index
  EX AF,AF'               ;
  LD HL,$F06A             ; Point HL at the byte before keydefs
; Start loop
ck_next_keydef:
  INC HL                  ; Advance to the next keydef
  LD A,(HL)               ; Read the keydef.port
  OR A                    ; Is it an empty slot?
  JR Z,ck_assign_keydef   ; Jump if so (assign keydef)
  CP B                    ; Does the port high byte match?
  INC HL                  ; Advance HL (interleaved)
  JR NZ,ck_next_keydef    ; ...loop if different
  LD A,(HL)               ; Read keydef.mask
  CP C                    ; Does the mask match?
  JR NZ,ck_next_keydef    ; ...loop if different
  JP ck_keyscan_inner     ; ...loop (infinite) (mask in A becomes new debounce flag)
; Assign key definition.
ck_assign_keydef:
  LD (HL),B               ; Store port
  INC L                   ;
  LD (HL),C               ; Store mask
  EX AF,AF'               ; Unbank the port index
  LD B,A                  ; Multiply it by 5
  ADD A,A                 ;
  ADD A,A                 ;
  ADD A,B                 ;
  LD HL,$F302             ; Point HL one byte prior to keycode_to_glyph. This is off-by-one to compensate for the upcoming preincrement
  ADD A,L                 ; Combine
  LD L,A                  ;
  JR NC,ck_find_key_glyph ;
  INC H                   ;
; Skip entries until the mask carries out.
ck_find_key_glyph:
  INC HL                  ; Advance the glyph pointer
  RR C                    ; Shift mask
  JR NC,ck_find_key_glyph ; ...loop until the mask carries out
  LD B,$01                ; Set length to 1
  LD A,(HL)               ; Load the glyph
  OR A                    ; Test the top bit
  JP P,ck_plot_glyph      ; Jump if clear (JP P => positive)
; If the top bit was set then it's a special key, like BREAK or ENTER.
  AND $7F                 ; Extract the byte offset into special_key_names
  LD DE,special_key_names ; Point DE at special_key_names
  LD L,A                  ; Widen byte offset into HL
  LD H,$00                ;
  ADD HL,DE               ; Combine
  LD B,(HL)               ; First byte is length of special key name
  INC HL                  ; Advance HL to point at glyphs
; Plot.
ck_plot_glyph:
  LD DE,$40D5             ; Point DE at (a self modified screen address)
; Start loop (draw key)
ck_plot_glyph_loop:
  PUSH BC                 ; Preserve the loop counter
; Bug: The next load is needless (plot_glyph does it already).
  LD A,(HL)               ; Read a glyph
  CALL plot_glyph         ; Plot a single glyph (indirectly)
  INC HL                  ; Advance to next glyph index
  POP BC                  ; Restore the loop counter
  DJNZ ck_plot_glyph_loop ; ...loop (draw key)
  POP HL                  ; Restore screen address
  POP BC                  ; Restore the loop counter
  DEC B                   ; ...loop (once per direction+fire)
  JR NZ,ck_keyscan_loop   ;
; Delay loop.
;
; This delays execution by approximately a third of a second (~1.25M T-states).
  LD BC,$FFFF             ; Set BC to $FFFF
ck_delay:
  DEC BC                  ; Count down until it's zero
  LD A,B                  ;
  OR C                    ;
  JR NZ,ck_delay          ;
; Wait for the user's confirmation.
  CALL user_confirm       ; Wait for the user to confirm by pressing 'Y' or 'N'
  RET Z                   ; If Z set 'Y' was pressed so return
  JP NZ,choose_keys       ; ...loop (infinite)

; Set the screen attributes of the specified menu item.
;
; Used by the routines at main and check_menu_keys.
;
; I:A Menu item index.
; I:E Attributes.
set_menu_item_attributes:
  LD HL,$590D             ; Point HL at the first menu item's attributes
; Skip to the item's row.
  AND A                   ; Is the index zero?
  JR Z,set_menu_item_attributes_1 ; Jump if so - no need to advance the pointer
  LD B,A                  ; Set B for (item index) iterations
; Start loop
set_menu_item_attributes_0:
  LD A,L                  ; Advance by two attribute rows per iteration (64 bytes)
  ADD A,$40               ;
  LD L,A                  ;
  DJNZ set_menu_item_attributes_0 ; ...loop
; Set the attributes.
set_menu_item_attributes_1:
  LD B,$0A                ; Set B for ten iterations
; Start loop
set_menu_item_attributes_2:
  LD (HL),E               ; Set one attribute byte
  INC L                   ; Advance to the next
  DJNZ set_menu_item_attributes_2 ; ...loop
  RET                     ; Return

; Scan for keys that select an input device.
;
; Used by the routine at check_menu_keys.
;
; O:A 0/1/2/3/4 if that key was pressed, or 255 if no relevant key was pressed.
menu_keyscan:
  LD BC,$F7FE             ; Set BC to port_KEYBOARD_12345
  LD E,$00                ; Initialise a counter
  IN A,(C)                ; Read the port
  CPL                     ; Invert the bits to turn active low into active high
  AND $0F                 ; Mask off bits for 1,2,3,4
  JR Z,mk_check_for_0     ; If none were pressed then check for zero
; Which key was pressed?
  LD B,$04                ; Set B for 4 iterations
; Start loop
mk_loop:
  RRA                     ; Shift out a bit
  INC E                   ; Increment the counter
  JR C,mk_found           ; Did a bit carry out? Jump if so
  DJNZ mk_loop            ; ...loop
mk_found:
  LD A,E                  ; Return 1..4
  RET                     ;
mk_check_for_0:
  LD B,$EF                ; Set BC to port_KEYBOARD_09876
  IN A,(C)                ; Read the port
  AND $01                 ; Was 0 pressed? (note active low)
  LD A,E                  ; Return 0 if so
  RET Z                   ;
  LD A,$FF                ; Otherwise return $FF
  RET                     ;

; List of available input routines.
;
; Array [4] of pointers to input routines.
inputroutines:
  DEFW inputroutine_keyboard
  DEFW inputroutine_kempston
  DEFW inputroutine_sinclair
  DEFW inputroutine_protek

; Chosen input device.
;
; +-------+----------+
; | Value | Meaning  |
; +-------+----------+
; | 0     | Keyboard |
; | 1     | Kempston |
; | 2     | Sinclair |
; | 3     | Protek   |
; +-------+----------+
chosen_input_device:
  DEFB $00

; Key choice screenlocstrings.
key_choice_screenlocstrings:
  DEFB $8E,$40,$08,$0C,$00,$17,$1C,$1A,$00,$15,$1B ; "CONTROLS"
  DEFB $CD,$40,$08,$00,$23,$1B,$0E,$15,$0E,$0C,$1C ; "0 SELECT"
  DEFB $0D,$48,$0A,$01,$23,$14,$0E,$21,$0B,$00,$0A,$1A,$0D ; "1 KEYBOARD"
  DEFB $4D,$48,$0A,$02,$23,$14,$0E,$16,$18,$1B,$1C,$00,$17 ; "2 KEMPSTON"
  DEFB $8D,$48,$0A,$03,$23,$1B,$12,$17,$0C,$15,$0A,$12,$1A ; "3 SINCLAIR"
  DEFB $CD,$48,$08,$04,$23,$18,$1A,$00,$1C,$0E,$14 ; "4 PROTEK"
  DEFB $07,$50,$17,$0B,$1A,$0E,$0A,$14,$23,$00,$1A,$23,$0C,$0A,$18,$1B,$23,$0A,$17,$0D,$23,$1B,$18,$0A,$0C,$0E ; "BREAK OR CAPS AND SPACE"
  DEFB $2C,$50,$0C,$0F,$00,$1A,$23,$17,$0E,$1F,$23,$10,$0A,$16,$0E ; "FOR NEW GAME"

; Run the menu screen.
;
; Waits for user to select an input device, waves the morale flag and plays the title tune.
;
; Used by the routine at main.
;
; Start loop (infinite)
menu_screen:
  CALL check_menu_keys    ; Handle menu screen keys. When the user starts the game this call will cease to return.
  CALL wave_morale_flag   ; Wave the morale flag (on every other turn)
; Play music.
  LD HL,(music_channel0_index) ; Fetch and increment the music channel 0 index
  INC HL                       ;
; Start loop (infinite)
ms_loop0:
  LD (music_channel0_index),HL ; Save the music channel 0 index
  LD DE,music_channel0_data ; Point DE at music_channel0_data
  ADD HL,DE               ; Add the index
  LD A,(HL)               ; Fetch a semitone
  CP $FF                  ; Was it the end of song marker? ($FF)
  JR NZ,ms_break0         ; Jump if not
  LD HL,$0000             ; Otherwise zero the index and start over
  JR ms_loop0             ;
ms_break0:
  CALL frequency_for_semitone ; Get frequency for semitone
  EXX                     ; Bank the channel 0 parameters
  LD HL,(music_channel1_index) ; Fetch and increment the music channel 1 index
  INC HL                       ;
; Start loop (infinite)
ms_loop1:
  LD (music_channel1_index),HL ; Save the music channel 1 index
  LD DE,music_channel1_data ; Point DE at music_channel1_data
  ADD HL,DE               ; Add the index
  LD A,(HL)               ; Fetch a semitone
  CP $FF                  ; Was it the end of song marker? ($FF)
  JR NZ,ms_break1         ; Jump if not
  LD HL,$0000             ; Otherwise zero the index and start over
  JR ms_loop1             ;
ms_break1:
  CALL frequency_for_semitone ; Get frequency for semitone
; When the second channel is silent use the first channel's frequency.
  LD A,B                  ; Get the second channel's frequency low byte (note B is low here due to endian swap)
  EXX                     ; Unbank the channel 0 parameters
  PUSH BC                 ; Save channel 0's frequency
  CP $FF                  ; Is channel 1's frequency $xxFF?
  JR NZ,menu_screen_0     ; Jump if not
  EXX                     ; Otherwise swap banks to channel 1's registers
  POP BC                  ; Copy channel 0's frequency to channel 1
  LD E,C                  ;
  LD D,B                  ;
  EXX                     ; Bank again
  JR menu_screen_1        ; Jump
menu_screen_0:
  POP BC                  ; Discard saved frequency
; Iterate 6,120 times (24 * 255)
menu_screen_1:
  LD A,$18                ; Set major tune speed (a delay: lower means faster)
; Start loop (major)
menu_screen_2:
  EX AF,AF'               ; Bank the major counter
  LD H,$FF                ; Set minor tune speed (a delay: lower means faster)
; Start loop (minor)
;
; Play channel 0's part
menu_screen_3:
  DJNZ menu_screen_4      ; Decrement B (low). Jump over next block unless zero
  DEC C                   ; Decrement C (high)
  JP NZ,menu_screen_4     ; Jump over next block unless zero
; Countdown hit zero
  LD A,L                  ; Toggle the speaker bit (L is zeroed by frequency_for_semitone)
  XOR $10                 ;
  LD L,A                  ;
  OUT ($FE),A             ;
  LD C,E                  ; Reset counter
  LD B,D                  ;
menu_screen_4:
  EXX                     ; Swap to registers for channel 1
; Play channel 1's part
  DJNZ menu_screen_5      ; Decrement B (low). Jump over next block unless zero
  DEC C                   ; Decrement C (high)
  JP NZ,menu_screen_5     ; Jump over next block unless zero
; Countdown hit zero
  LD A,L                  ; Toggle the speaker bit (L is zeroed by frequency_for_semitone)
  XOR $10                 ;
  LD L,A                  ;
  OUT ($FE),A             ;
  LD C,E                  ; Reset counter
  LD B,D                  ;
menu_screen_5:
  EXX                     ; Swap to registers for channel 0
  DEC H                   ; ...loop (minor tune speed) / 255 iterations
  JP NZ,menu_screen_3     ;
  EX AF,AF'               ; Unbank the major counter
  DEC A                   ; ...loop (major tune speed) / 24 iterations
  JP NZ,menu_screen_2     ;
  JP menu_screen          ; ...loop (infinite)

; Return the frequency to play at to generate the given semitone.
;
; The frequency returned is the number of iterations that the music routine should count for before flipping the speaker output bit.
;
; Used by the routine at menu_screen.
;
; I:A  Semitone index (never larger than 42 in this game). O:BC Frequency. O:DE Frequency. O:L  Zero.
frequency_for_semitone:
  ADD A,A                 ; Double A for index
  LD HL,semitone_to_frequency ; Point HL at the semitone to frequency table
  LD E,A                  ; Widen: DE = A
  LD D,$00                ;
  ADD HL,DE               ; Add
  LD B,(HL)               ; Fetch frequency from table
  INC HL                  ;
  LD C,(HL)               ;
; DPT: This increment could be baked into the table itself.
  INC C                   ; Increment
  INC B                   ; Increment
  JR NZ,frequency_for_semitone_0 ; If B rolled over, increment C (big endian?)
  INC C                          ;
frequency_for_semitone_0:
  LD L,$00                ; Reset L - this is the border+beeper value for OUT
  LD D,B                  ; Return DE and BC the same
  LD E,C                  ;
  RET                     ; Return

; Music channel indices.
music_channel0_index:
  DEFW $0000
music_channel1_index:
  DEFW $0000

; Unreferenced byte.
LF545:
  DEFB $00

; High music channel notes (semitones).
;
; Start of The Great Escape theme.
music_channel0_data:
  DEFB $13,$00,$14,$00,$00,$15,$16,$00
  DEFB $1B,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$1F,$00,$00,$1D,$1B,$00
  DEFB $18,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$1D,$00
  DEFB $00,$00,$1D,$00,$00,$1B,$1A,$00
  DEFB $1B,$00,$1A,$00,$18,$00,$16,$00
  DEFB $13,$00,$00,$00,$00,$00,$00,$00
  DEFB $13,$00,$14,$00,$00,$15,$16,$00
  DEFB $1B,$00,$00,$00,$00,$00,$00,$00
  DEFB $16,$00,$1F,$00,$00,$1D,$1B,$00
  DEFB $18,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$1D,$00
  DEFB $00,$00,$1D,$00,$00,$1B,$1A,$00
  DEFB $16,$00,$00,$00,$1D,$00,$1B,$00
  DEFB $00,$00,$1F,$00,$00,$1D,$1B,$00
  DEFB $19,$00,$18,$00,$16,$00
; Start of "Pack Up Your Troubles in Your Old Kit Bag".
  DEFB $1B,$00
  DEFB $00,$00,$1B,$00,$1D,$00,$1B,$00
  DEFB $19,$00,$18,$00,$19,$00,$1B,$00
  DEFB $00,$00,$24,$00,$00,$00,$24,$00
  DEFB $00,$00,$22,$00,$00,$00,$20,$00
  DEFB $00,$00,$00,$00,$00,$00,$1D,$00
  DEFB $00,$00,$00,$00,$00,$00,$1B,$00
  DEFB $00,$00,$1B,$00,$00,$1D,$1B,$00
  DEFB $19,$00,$18,$00,$16,$00,$1B,$00
  DEFB $00,$00,$1B,$00,$1D,$00,$1B,$00
  DEFB $19,$00,$18,$00,$19,$00,$1B,$00
  DEFB $00,$00,$24,$00,$00,$00,$20,$00
  DEFB $1F,$00,$20,$00,$21,$00,$22,$00
  DEFB $00,$00,$1D,$00,$00,$00,$1F,$00
  DEFB $00,$00,$20,$00,$00,$00,$22,$00
  DEFB $00,$00,$22,$00,$00,$20,$1F,$00
  DEFB $1B,$00,$1D,$00,$1F,$00,$20,$00
  DEFB $00,$00,$00,$00,$22,$00,$24,$00
  DEFB $00,$00,$20,$00,$00,$00,$1F,$00
  DEFB $20,$00,$22,$00,$1B,$1D,$1F,$00
  DEFB $20,$00,$22,$00,$24,$00,$25,$00
  DEFB $00,$00,$22,$00,$00,$00,$24,$00
  DEFB $00,$00,$20,$00,$00,$00,$22,$00
  DEFB $00,$00,$1B,$00,$00,$1D,$1B,$00
  DEFB $19,$00,$18,$00,$19,$00,$1B,$00
  DEFB $00,$00,$1B,$00,$1D,$00,$1B,$00
  DEFB $19,$00,$18,$00,$19,$00,$1B,$00
  DEFB $00,$00,$27,$00,$00,$00,$27,$00
  DEFB $00,$00,$25,$00,$00,$00,$24,$00
  DEFB $1B,$1B,$1A,$00,$1B,$00,$22,$00
  DEFB $1B,$1B,$1A,$00,$1B,$00,$20,$00
  DEFB $1B,$00,$18,$00,$1B,$00,$14,$00
  DEFB $1D,$00,$1E,$00
; Start of "It's a Long Way to Tipperary".
  DEFB $1F,$00,$20,$00
  DEFB $00,$00,$20,$00,$00,$00,$00,$00
  DEFB $20,$00,$22,$00,$24,$00,$25,$00
  DEFB $00,$00,$29,$00,$00,$00,$00,$00
  DEFB $00,$00,$29,$00,$27,$00,$25,$00
  DEFB $00,$00,$22,$00,$00,$00,$00,$00
  DEFB $00,$00,$25,$00,$00,$00,$20,$00
  DEFB $00,$00,$20,$00,$00,$22,$20,$00
  DEFB $1E,$00,$1D,$00,$1E,$00,$20,$00
  DEFB $00,$00,$20,$00,$00,$00,$20,$00
  DEFB $20,$00,$22,$00,$24,$00,$25,$00
  DEFB $00,$00,$29,$00,$00,$00,$00,$00
  DEFB $24,$00,$25,$00,$26,$00,$27,$00
  DEFB $00,$00,$22,$00,$00,$00,$24,$00
  DEFB $00,$00,$25,$00,$00,$00,$27,$00
  DEFB $00,$00,$27,$00,$00,$29,$27,$00
  DEFB $25,$00,$24,$00,$22,$00,$20,$00
  DEFB $00,$00,$20,$00,$00,$00,$20,$00
  DEFB $20,$00,$22,$00,$24,$00,$25,$00
  DEFB $00,$00,$29,$00,$00,$00,$00,$00
  DEFB $25,$00,$27,$00,$29,$00,$2A,$00
  DEFB $00,$00,$22,$00,$00,$00,$25,$00
  DEFB $00,$00,$2A,$00,$00,$00,$29,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$25,$00,$27,$00,$29,$00
  DEFB $00,$00,$29,$00,$00,$00,$29,$00
  DEFB $25,$00,$27,$00,$25,$00,$22,$00
  DEFB $00,$00,$00,$00,$00,$00,$20,$00
  DEFB $00,$00,$25,$00,$00,$00,$29,$00
  DEFB $00,$00,$25,$00,$00,$00,$00,$00
  DEFB $00,$00,$27,$00,$00,$00,$25,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
; End of song marker
  DEFB $FF
; Low music channel notes (semitones). Start of The Great Escape theme.
music_channel1_data:
  DEFB $0A,$00,$0C,$00,$00,$0E,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$14,$00,$15,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$0F,$00
  DEFB $13,$00,$00,$00,$00,$00,$00,$00
  DEFB $0A,$00,$0C,$00,$00,$0E,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$14,$00,$15,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00
; Start of "Pack Up Your Troubles in Your Old Kit Bag".
  DEFB $14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $14,$00,$16,$00,$18,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $0F,$00,$11,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $0F,$00,$14,$00,$15,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$16,$00
  DEFB $1A,$00,$11,$00,$1A,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$14,$00,$13,$00
  DEFB $16,$00,$0F,$00,$13,$00,$0A,$00
  DEFB $13,$00,$16,$00,$18,$00,$19,$00
  DEFB $14,$00,$11,$00,$19,$00,$18,$00
  DEFB $14,$00,$0F,$00,$18,$00,$13,$00
  DEFB $16,$00,$0F,$00,$13,$00,$0A,$00
  DEFB $13,$00,$0F,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$13,$00
  DEFB $16,$00,$0F,$00,$16,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $00,$00,$00,$00
; Start of "It's a Long Way to Tipperary".
  DEFB $00,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$0F,$00,$11,$00,$12,$00
  DEFB $16,$00,$0D,$00,$16,$00,$12,$00
  DEFB $16,$00,$0D,$00,$16,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $08,$00,$0A,$00,$0C,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$0D,$00,$0E,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$0F,$00
  DEFB $13,$00,$0A,$00,$13,$00,$14,$00
  DEFB $18,$00,$0F,$00,$18,$00,$14,$00
  DEFB $08,$00,$0A,$00,$0C,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$0A,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $0D,$00,$0F,$00,$11,$00,$12,$00
  DEFB $16,$00,$0D,$00,$16,$00,$12,$00
  DEFB $16,$00,$12,$00,$12,$00,$11,$00
  DEFB $15,$00,$0C,$00,$15,$00,$11,$00
  DEFB $15,$00,$11,$00,$0C,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$12,$00
  DEFB $16,$00,$0D,$00,$16,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0F,$00
  DEFB $08,$00,$0A,$00,$0C,$00,$0D,$00
  DEFB $11,$00,$08,$00,$11,$00,$0D,$00
; End of song marker
  DEFB $FF
; The frequency to use to produce the given semitone. Covers full octaves from C2 to B6 and C7 only. Used by frequency_for_semitone
semitone_to_frequency:
  DEFW $FEFE              ; delay
  DEFW $0000              ; unused
  DEFW $0000              ; unused
  DEFW $0000              ; unused
  DEFW $0000              ; unused
; Octave 2
  DEFW $0218              ; C2
  DEFW $01FA              ; C2#
  DEFW $01DE              ; D2
  DEFW $01C3              ; D2# -- the lowest note used by the game music
  DEFW $01A9              ; E2
  DEFW $0192              ; F2
  DEFW $017B              ; F2#
  DEFW $0166              ; G2
  DEFW $0152              ; G2#
  DEFW $013F              ; A2
  DEFW $012D              ; A2#
  DEFW $011C              ; B2
; Octave 3
  DEFW $010C              ; C3
  DEFW $00FD              ; C3#
  DEFW $00EF              ; D3
  DEFW $00E1              ; D3#
  DEFW $00D5              ; E3
  DEFW $00C9              ; F3
  DEFW $00BE              ; F3#
  DEFW $00B3              ; G3
  DEFW $00A9              ; G3#
  DEFW $009F              ; A3
  DEFW $0096              ; A3#
  DEFW $008E              ; B3
; Octave 4
  DEFW $0086              ; C4
  DEFW $007E              ; C4#
  DEFW $0077              ; D4
  DEFW $0071              ; D4#
  DEFW $006A              ; E4
  DEFW $0064              ; F4
  DEFW $005F              ; F4#
  DEFW $0059              ; G4
  DEFW $0054              ; G4#
  DEFW $0050              ; A4
  DEFW $004B              ; A4#
  DEFW $0047              ; B4
; Octave 5
  DEFW $0043              ; C5
  DEFW $003F              ; C5# -- the highest note used by the game music
  DEFW $003C              ; D5
  DEFW $0038              ; D5#
  DEFW $0035              ; E5
  DEFW $0032              ; F5
  DEFW $002F              ; F5#
  DEFW $002D              ; G5
  DEFW $002A              ; G5#
  DEFW $0028              ; A5
  DEFW $0026              ; A5#
  DEFW $0023              ; B5
; Octave 6
  DEFW $0021              ; C6
  DEFW $0020              ; C6#
  DEFW $001E              ; D6
  DEFW $001C              ; D6#
  DEFW $001B              ; E6
  DEFW $0019              ; F6
  DEFW $0018              ; F6#
  DEFW $0016              ; G6
  DEFW $0015              ; G6#
  DEFW $0014              ; A6
  DEFW $0013              ; A6#
  DEFW $0012              ; B6
; Octave 7
  DEFW $0011              ; C7
; It's unclear from the original game data where the table is supposed to end. It's not important in practice since the highest note used by the game is C5#.
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000
  DEFW $0000

; 769 bytes of apparently unreferenced bytes.
LFAE0:
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$14,$00,$15,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$0F,$00,$13
  DEFB $00,$00,$00,$00,$00,$00,$00,$0A
  DEFB $00,$0C,$00,$00,$0E,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$14,$00,$15,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$14
  DEFB $00,$16,$00,$18,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$0F
  DEFB $00,$11,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$0F
  DEFB $00,$14,$00,$15,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$16,$00,$1A
  DEFB $00,$11,$00,$1A,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$14,$00,$13,$00,$16
  DEFB $00,$0F,$00,$13,$00,$0A,$00,$13
  DEFB $00,$16,$00,$18,$00,$19,$00,$14
  DEFB $00,$11,$00,$19,$00,$18,$00,$14
  DEFB $00,$0F,$00,$18,$00,$13,$00,$16
  DEFB $00,$0F,$00,$13,$00,$0A,$00,$13
  DEFB $00,$0F,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$13,$00,$16
  DEFB $00,$0F,$00,$16,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$00
  DEFB $00,$00,$00,$00,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$0F,$00,$11,$00,$12,$00,$16
  DEFB $00,$0D,$00,$16,$00,$12,$00,$16
  DEFB $00,$0D,$00,$16,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$08
  DEFB $00,$0A,$00,$0C,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$0D,$00,$0E,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$0F,$00,$13
  DEFB $00,$0A,$00,$13,$00,$14,$00,$18
  DEFB $00,$0F,$00,$18,$00,$14,$00,$08
  DEFB $00,$0A,$00,$0C,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$0A,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$0D
  DEFB $00,$0F,$00,$11,$00,$12,$00,$16
  DEFB $00,$0D,$00,$16,$00,$12,$00,$16
  DEFB $00,$12,$00,$12,$00,$11,$00,$15
  DEFB $00,$0C,$00,$15,$00,$11,$00,$15
  DEFB $00,$11,$00,$0C,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$12,$00,$16
  DEFB $00,$0D,$00,$16,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0F,$00,$08
  DEFB $00,$0A,$00,$0C,$00,$0D,$00,$11
  DEFB $00,$08,$00,$11,$00,$0D,$00,$FF
  DEFB $FE,$FE,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$18,$02,$FA,$01,$DE,$01
  DEFB $C3,$01,$A9,$01,$92,$01,$7B,$01
  DEFB $66,$01,$52,$01,$3F,$01,$2D,$01
  DEFB $1C,$01,$0C,$01,$FD,$00,$EF,$00
  DEFB $E1,$00,$D5,$00,$C9,$00,$BE,$00
  DEFB $B3,$00,$A9,$00,$9F,$00,$96,$00
  DEFB $8E,$00,$86,$00,$7E,$00,$77,$00
  DEFB $71,$00,$6A,$00,$64,$00,$5F,$00
  DEFB $59,$00,$54,$00,$50,$00,$4B,$00
  DEFB $47,$00,$43,$00,$3F,$00,$3C,$00
  DEFB $38,$00,$35,$00,$32,$00,$2F,$00
  DEFB $2D,$00,$2A,$00,$28,$00,$26,$00
  DEFB $23,$00,$21,$00,$20,$00,$1E,$00
  DEFB $1C,$00,$1B,$00,$19,$00,$18,$00
  DEFB $16,$00,$15,$00,$14,$00,$13,$00
  DEFB $12,$00,$11,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $C9

; Loaded.
;
; This is the very first entry point used to shunt the game image down into its proper position.
loaded:
  DI                      ; Disable interrupts
  LD SP,$FFFF             ; Point SP at the topmost byte of RAM
  LD BC,$9FE0             ; Relocate the $9FE0 bytes at $5E00 down to $5B00
  LD HL,$5E00             ;
  LD DE,super_tiles       ;
  LDIR                    ;
  JP jump_to_main         ; Exit via jump_to_main

; Unreferenced bytes.
LFDF3:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00

; Keyboard input routine.
;
; Walks the keydefs table testing the ports against masks as setup by choose_keys.
;
; O:A Input value (as per enum input).
inputroutine_keyboard:
  LD HL,keydefs           ; Point HL at keydefs table - a list of (port high byte, key mask) filled out when the user chose their keys
; Check for left
  LD C,$FE                ; Port $xxFE
  LD B,(HL)               ; Fetch the port high byte
  INC HL                  ; Advance to key mask
  IN A,(C)                ; Read that port
  CPL                     ; The keyboard is active low, so complement the value
  AND (HL)                ; Mask off the wanted bit
  INC HL                  ; Advance to next definition
  JR Z,inputroutine_keyboard_0 ; Key NOT pressed - jump forward to test for right key
  INC HL                  ; Skip the right key definition
  INC HL                  ;
  LD E,$03                ; result = input_LEFT
  JR inputroutine_keyboard_2 ; Jump to up/down checking
; Check for right
inputroutine_keyboard_0:
  LD B,(HL)               ; Fetch the port high byte
  INC HL                  ; Advance to key mask
  IN A,(C)                ; Read that port
  CPL                     ; The keyboard is active low, so complement the value
  AND (HL)                ; Mask off the wanted bit
  INC HL                  ; Advance to next definition
  JR Z,inputroutine_keyboard_1 ; Key NOT pressed - jump forward to test for up key
  LD E,$06                ; result = input_RIGHT
  JR inputroutine_keyboard_2 ; Jump to up/down checking
inputroutine_keyboard_1:
  LD E,A                  ; Otherwise result = 0 (A is zero here)
; Check for up
inputroutine_keyboard_2:
  LD B,(HL)               ; Fetch the port high byte
  INC HL                  ; Advance to key mask
  IN A,(C)                ; Read that port
  CPL                     ; The keyboard is active low, so complement the value
  AND (HL)                ; Mask off the wanted bit
  INC HL                  ; Advance to next definition
  JR Z,inputroutine_keyboard_3 ; Key NOT pressed - jump forward to test for down key
  INC HL                  ; Skip down key definition
  INC HL                  ;
  INC E                   ; result += input_UP
  JR inputroutine_keyboard_4 ; Jump to fire checking
; Check for down
inputroutine_keyboard_3:
  LD B,(HL)               ; Fetch the port high byte
  INC HL                  ; Advance to key mask
  IN A,(C)                ; Read that port
  CPL                     ; The keyboard is active low, so complement the value
  AND (HL)                ; Mask off the wanted bit
  INC HL                  ; Advance to next key definition
  JR Z,inputroutine_keyboard_4 ; Key NOT pressed - jump forward to test for fire key
  INC E                   ; result += input_DOWN
  INC E                   ;
; Check for fire
inputroutine_keyboard_4:
  LD B,(HL)               ; Fetch the port high byte
  INC HL                  ; Advance to key mask
  IN A,(C)                ; Read that port
  CPL                     ; The keyboard is active low, so complement the value
  AND (HL)                ; Mask off the wanted bit
  INC HL                  ; Advance to next key definition
  LD A,E                  ; Result
  RET Z                   ; Return the result if fire NOT pressed
  ADD A,$09               ; result += input_FIRE
  RET                     ; Return

; Protek (cursor) joystick input routine.
;
; Up/Down/Left/Right/Fire = keys 7/6/5/8/0.
;
; O:A Input value (as per enum input).
inputroutine_protek:
  LD BC,$F7FE             ; Load BC with the port number of the keyboard half row for keys 1/2/3/4/5
  IN A,(C)                ; Read that port. We'll receive xxx54321
  CPL                     ; The keyboard is active low, so complement the value
; Check for left
  AND $10                 ; Is '5' pressed?
  LD E,$03                ; left_right = input_LEFT
  LD B,$EF                ; Load BC with the port number of the keyboard half row for keys 0/9/8/7/6
  JR NZ,inputroutine_protek_0 ; Jump forward if '5'/left was pressed
; Check for right
  IN A,(C)                ; Read that port. We'll receive xxx67890
  CPL                     ; The keyboard is active low, so complement the value
  AND $04                 ; Is '8' pressed?
  LD E,$06                ; left_right = input_RIGHT
  JR NZ,inputroutine_protek_0 ; Jump forward if '8'/right was pressed
  LD E,$00                ; Otherwise left_right = 0
inputroutine_protek_0:
  IN A,(C)                ; Read $EFFE again
  CPL                     ; The keyboard is active low, so complement the value
  LD D,A                  ; Save a copy of the port value
; Check for up
  AND $08                 ; Is '7' pressed?
  LD A,$01                ; up_down = input_UP
  JR NZ,inputroutine_protek_1 ; Jump forward if '7'/up was pressed
; Check for down
  LD A,D                  ; Restore the port value
  AND $10                 ; Is '6' pressed?
  LD A,$02                ; up_down = input_DOWN
  JR NZ,inputroutine_protek_1 ; Jump forward if '6'/down was pressed
  XOR A                   ; Otherwise up_down = 0
inputroutine_protek_1:
  ADD A,E                 ; Combine the up_down and left_right values
  LD E,A                  ;
; Check for fire
  LD A,D                  ; Restore the port value
  AND $01                 ; Is '0' pressed?
  LD A,$09                ; fire = input_FIRE
  JR NZ,inputroutine_protek_2 ; Jump forward if fire was pressed
  XOR A                   ; fire = 0
inputroutine_protek_2:
  ADD A,E                 ; Combine the (up_down + left_right) and fire values
  RET                     ; Return

; Kempston joystick input routine.
;
; Reading port $1F yields 000FUDLR active high.
;
; O:A Input value (as per enum input).
inputroutine_kempston:
  LD BC,$001F             ; Load BC with port number $1F
  IN A,(C)                ; Read that port. We'll receive 000FUDLR
  LD BC,$0000             ; Clear our {...} variables
; Right
  RRA                     ; Rotate 'R' out: R000FUDL
  JR NC,inputroutine_kempston_0 ; If carry was set then right was pressed, otherwise skip
  LD B,$06                ; left_right = input_RIGHT
; Left
inputroutine_kempston_0:
  RRA                     ; Rotate 'L' out: LR000FUD
  JR NC,inputroutine_kempston_1 ; If carry was set then left was pressed, otherwise skip
  LD B,$03                ; left_right = input_LEFT
; Down
inputroutine_kempston_1:
  RRA                     ; Rotate 'D' out: DLR000FU
  JR NC,inputroutine_kempston_2 ; If carry was set then down was pressed, otherwise skip
  LD C,$02                ; up_down = input_DOWN
; Up
inputroutine_kempston_2:
  RRA                     ; Rotate 'U' out: UDLR000F
  JR NC,inputroutine_kempston_3 ; If carry was set then up was pressed, otherwise skip
  LD C,$01                ; up_down = input_UP
; Fire
inputroutine_kempston_3:
  RRA                     ; Rotate 'F' out: FUDLR000
  LD A,$09                ; fire = input_FIRE
  JR C,inputroutine_kempston_4 ; If fire bit was set then jump forward
  XOR A                   ; fire = 0
inputroutine_kempston_4:
  ADD A,B                 ; Combine the fire, up_down and left_right values
  ADD A,C                 ;
  RET                     ; Return

; Fuller joystick input routine.
;
; Reading port $7F yields F---RLDU active low.
;
; This is unused by the game.
;
; O:A Input value (as per enum input).
inputroutine_fuller:
  LD BC,$007F             ; Load BC with port number $7F
  IN A,(C)                ; Read that port. We'll receive FxxxRLDU
  LD BC,$0000             ; Clear our variables
; DPT: This is odd. It's testing an unspecified bit to see whether to complement the read value. I don't see a reference for that behaviour anywhere.
  BIT 4,A                 ; Test bit 4
  JR Z,inputroutine_fuller_0 ; Jump forward if clear
  CPL                     ; Complement the value
; Up
inputroutine_fuller_0:
  RRA                     ; Rotate 'U' out: UFxxxRLD
  JR NC,inputroutine_fuller_1 ; If carry was set then up was pressed, otherwise skip
  LD C,$01                ; up_down = input_UP
; Down
inputroutine_fuller_1:
  RRA                     ; Rotate 'D' out: DUFxxxRL
  JR NC,inputroutine_fuller_2 ; If carry was set then down was pressed, otherwise skip
  LD C,$02                ; up_down = input_DOWN
; Left
inputroutine_fuller_2:
  RRA                     ; Rotate 'L' out: LDUFxxxR
  JR NC,inputroutine_fuller_3 ; If carry was set then down was pressed, otherwise skip
  LD B,$03                ; left_right = input_LEFT
; Right
inputroutine_fuller_3:
  RRA                     ; Rotate 'R' out: RLDUFxxx
  JR NC,inputroutine_fuller_4 ; If carry was set then right was pressed, otherwise skip
  LD B,$06                ; left_right = input_RIGHT
; Fire
inputroutine_fuller_4:
  AND $08                 ; Test fire bit (and set A to zero if not set)
  JR Z,inputroutine_fuller_5 ; If bit was set then fire was pressed, otherwise skip
  LD A,$09                ; fire = input_FIRE
inputroutine_fuller_5:
  ADD A,B                 ; Combine the fire, up_down and left_right values
  ADD A,C                 ;
  RET                     ; Return

; Sinclair joystick input routine.
;
; Up/Down/Left/Right/Fire = keys 9/8/6/7/0.
;
; O:A Input value (as per enum input).
inputroutine_sinclair:
  LD BC,$EFFE             ; Load BC with the port number of the keyboard half row for keys 6/7/8/9/0
  IN A,(C)                ; Read that port. We'll receive xxx67890
  CPL                     ; The keyboard is active low, so complement the value
  LD BC,$0000             ; Clear our left_right and up_down variables
  RRCA                    ; Rotate '0' out: 0xxx6789
; Up
  RRCA                    ; Rotate '9' out: 90xxx678
  JR NC,inputroutine_sinclair_0 ; If carry was set then '9' was pressed, otherwise skip
  LD C,$01                ; up_down = input_UP
; Down
inputroutine_sinclair_0:
  RRCA                    ; Rotate '8' out: 890xxx67
  JR NC,inputroutine_sinclair_1 ; If carry was set then '8' was pressed, otherwise skip
  LD C,$02                ; up_down = input_DOWN
; Right
inputroutine_sinclair_1:
  RRCA                    ; Rotate '7' out: 7890xxx6
  JR NC,inputroutine_sinclair_2 ; If carry was set then '7' was pressed, otherwise skip
  LD B,$06                ; left_right = input_RIGHT
; Left
inputroutine_sinclair_2:
  RRCA                    ; Rotate '6' out: 67890xxx
  JR NC,inputroutine_sinclair_3 ; If carry was set then '6' was pressed, otherwise skip
  LD B,$03                ; left_right = input_LEFT
; Fire
inputroutine_sinclair_3:
  AND $08                 ; Is '0' pressed?
  JR Z,inputroutine_sinclair_4 ; Jump forward if not
  LD A,$09                ; fire = input_FIRE
inputroutine_sinclair_4:
  ADD A,B                 ; Combine the fire, up_down and left_right values
  ADD A,C                 ;
  RET                     ; Return

; Data block at FEF4.
;
; The final standard speed data block on the tape is loaded at $FC60..$FF81. The bytes from here up to $FF81 come from that block.
LFEF4:
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$E0,$57
  DEFB $DB,$02,$DB,$02,$4D,$00,$EC,$55
  DEFB $00,$00,$05,$3D,$F3,$0D,$CE,$0B
  DEFB $F0,$50,$DB,$02,$4D,$00,$F9,$55
  DEFB $00,$00,$CE,$0B,$FB,$50,$06,$17
  DEFB $DC,$0A,$D7,$18,$38,$00,$38,$00
  DEFB $0D,$19,$DB,$02,$DB,$02,$4D,$00
  DEFB $F7,$54,$09,$00,$F6,$54,$0C,$02
  DEFB $5C,$0E,$C0,$57,$71,$0E,$F3,$0D
  DEFB $21,$17,$C6,$1E,$FF,$5D,$76,$1B
  DEFB $03,$13,$00,$3E
; UDGs 'A' to 'E' follow, with 'F' truncated at its second byte.
map_buf:
  DEFB $00,$3C,$42,$42,$7E,$42,$42,$00 ; A
  DEFB $00,$7C,$42,$7C,$42,$42,$7C,$00 ; B
  DEFB $00,$3C,$42,$40,$40,$42,$3C,$00 ; C
  DEFB $00,$78,$44,$42,$42,$44,$78,$00 ; D
  DEFB $00,$7E,$40,$7C,$40,$40,$7E,$00 ; E
  DEFB $00,$7E            ; Truncated F
; NUL bytes
  DEFB $00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00,$00,$00,$00,$00
  DEFB $00,$00,$00,$00

