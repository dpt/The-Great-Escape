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
; - Extract all images.
;   - Sort out inverted masks issue.
; - Drop 'resources' dir if possible.
; - Use SkoolKit # refs more.
;   - Currently using (<- somefunc) to show a reference.
; - Extract font.

; //////////////////////////////////////////////////////////////////////////////
; CONSTANTS
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
; character_0 = 0                       ; ?
; character_1 = 1                       ; guard
; character_2 = 2                       ; guard
; character_3 = 3                       ; guard
; character_4 = 4                       ; guard
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
; character_24 = 24                     ; ?
; character_25 = 25                     ; ?
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
; character_41 = 41                     ; where did i get this maximum character number from?

; ; enum room
; room_0_outside = 0
; room_1_hut1right = 1
; room_2_hut2left = 2
; room_3_hut2right = 3
; room_4_hut3left = 4
; room_5_hut3right = 5
; room_6_corridor = 6
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
; room_26_hut1left = 26
; room_27_hut1left = 27                ; mystery duplicate
; room_28_hut1left = 28                ; mystery duplicate
; room_29_secondtunnelstart = 29       ; possibly the second tunnel start
;                                      ; many of the tunnels are displayed duplicated
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
; item_NONE = 255

; ; enum zoombox_tiles
; zoombox_tile_tl = 0
; zoombox_tile_hz = 1
; zoombox_tile_tr = 2
; zoombox_tile_vt = 3
; zoombox_tile_br = 4
; zoombox_tile_bl = 5

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

; ; enum sound (width 2 bytes)
; sound_CHARACTER_ENTERS_1 = $2030
; sound_CHARACTER_ENTERS_2 = $2040
; sound_BELL_RINGER = $2530
; sound_3030 = $3030
; sound_DROP_ITEM = $3040

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
; port_KEYBOARD_12345 = $F7FE
; port_KEYBOARD_POIUY = $DFFE
; port_KEYBOARD_SPACESYMSHFTMNB = $7FFE
; port_KEYBOARD_09876 = $EFFE

; ; enum interior_object_tile
; interiorobjecttile_MAX = 194,
; interiorobjecttile_ESCAPE = 255              ; escape character

; ; enum morale
; morale_MIN = 0x00
; morale_MAX = 0x70

; //////////////////////////////////////////////////////////////////////////////
; GAME STATE
; //////////////////////////////////////////////////////////////////////////////

; game state which overlaps with tiles etc.
;
; vars referenced as $8015 etc.

; b $8000 never written?
; b $8001 flags: bit 6 gets toggled in set_target_location /  bit 0: picking lock /  bit 1: cutting wire
; w $8002 could be a target location (set in set_target_location, user_input_was_in_bed_perhaps)
; w $8004 (<- user_input_was_in_bed_perhaps)
; b $800D tunnel related (<- process_user_input, wire_snipped, user_input_was_in_bed_perhaps) assigned from table at 9EE0
; b $800E tunnel related, walk/crawl flag maybe? (bottom 2 bits index $9EE0)
; w $800F position on Y axis (along the line of - bottom right to top left of screen) (set by user_input_super)
; w $8011 position on X axis (along the line of - bottom left to top right of screen) (set by user_input_super)  i think this might be relative to the current size of the map. each step seems to be two pixels.
; b $8013 character's vertical offset // set to 24 in user_input_was_in_bed_perhaps, wire_snipped,  set to 12 in action_wiresnips,  reset in reset_something,  read by called_from_main_loop_9 ($B68C) (via IY), no_idea ($B8DE), sub_E420 ($E433), in_permitted_area ($9F4F)  written by sub_AF8F ($AFD5)
; w $8015 pointer to current character sprite set (gets pointed to the 'tl_4' sprite)
; w $8018 points to something (gets 0x06C8 subtracted from it) (<- in_permitted_area)
; w $801A points to something (gets 0x0448 subtracted from it) (<- in_permitted_area)
; b $801C cleared to zero by action_papers, set to room_24_solitary by solitary, copied to indoor_room_index by sub_68A2 -- looks like a room index!
; ? $8020 character reset data? (<- reset_all_objects) suspect 7 sets of 32 bytes (one per prisoner) possibly visible characters only? can there be >7 characters on-screen/visible at once? or is it prisoners only?

;   $8020 byte -- bit 6 means something here, likely merged with a character index
;   $8021 likely a room index
;   $8022 likely a position
;   $8023 likely a position
;   $8024 likely a position
;   $803C room index within struct at $8020

; w $81A2 (<- masked_sprite_plotter)

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

b $68A0 indoor_room_index
D $68A0 Zero if outdoors.

; ------------------------------------------------------------------------------

b $68A1 current_door
D $68A1 Index.

; ------------------------------------------------------------------------------

c $68A2 sub_68A2
D $68A2 Looks like it's resetting stuff.
  $68A2 ...
  $68DA A = $801C; (room index thing)
  $68DD indoor_room_index = A;
  $68E0 if (A != 0) goto some_sort_of_initial_setup_maybe;
  $68E4 ...
  $68F4 some_sort_of_initial_setup_maybe (<- main and setup) [subroutine or label?]
  $691D goto main_loop;

; ------------------------------------------------------------------------------

c $6920 tunnel_related
D $6920 Probably called when emerging from tunnel.
D $6920 This is resetting the character sprite set to prisoner.
  $6920 HL = $800D;
  $6923 *HL++ = 128;
  $6926 A = indoor_room_index;
  $6929 if (A >= room_29_secondtunnelstart) {
  $692D *HL |= 1<<2;
  $692F $8015 = &sprite_prisoner_tl_4;
  $6935 } else {
  $6936 *HL &= 1<<2; }
  $6938 return;

; ------------------------------------------------------------------------------

c $6939 setup_movable_items
  $6939 reset_all_objects();
  $693C A = indoor_room_index;
  $693F      if (A == room_2_hut2left) setup_stove1();
  $6949 else if (A == room_4_hut3left) setup_stove2();
  $6953 else if (A == room_9_crate)    setup_crate();
  $695B called_from_main_loop_7();
  $695E called_from_main_loop_8();
  $6961 called_from_main_loop_9();
  $6964 called_from_main_loop_10();
  $6967 called_from_main_loop_11(); return;

  $696A setup_crate: HL = &crate;
  $696D A = character_28_crate;
  $696F goto setup_movable_items;
;
  $6971 setup_stove2: HL = &stove2;
  $6974 A = character_27_stove2;
  $6976 goto setup_movable_items;
;
  $6978 setup_stove1: HL = &stove1;
  $697B A = character_26_stove1; // then fallthrough to...
;
  $697D setup_movable_items: $8020 = A; // character index
  $6980 memcpy($802F, HL, 9); // character 0 is $8020..$803F
  $6988 memcpy($8021, byte_69A0, 14);
  $6993 $803C = indoor_room_index;
  $6999 HL = $8020;
  $699C reset_something();
  $699F return;

D $69A0 Fourteen bytes of reset data.
B $69A0 byte_69A0

b $69AE movable_items
D $69AE struct movable_item { word y_coord, x_coord; word vertical_offset; const sprite *; byte terminator; };

W $69AE struct movable_item stove1 = { y_coord,
W $69B0 x_coord,
W $69B2 vertical_offset,
W $69B4 &sprite_stove,
  $69B6 0 };

W $69B7 struct movable_item crate = { y_coord,
W $69B9 x_coord,
W $69BB vertical_offset,
W $69BD &sprite_crate,
  $69BF 0 };

W $69C0 struct movable_item stove2 = { y_coord,
W $69C2 x_coord,
W $69C4 vertical_offset,
W $69C6 &sprite_stove,
  $69C8 0 };

; ------------------------------------------------------------------------------

c $69C9 reset_all_objects
  $69C9 HL = $8020;
  $69CC BC = 0x0720; // 7 iters, 32 stride
  $69CF do < PUSH BC
  $69D0 PUSH HL
  $69D1 reset_object();
  $69D4 POP HL
  $69D5 POP BC
  $69D6 HL += C;
  $69D9 > while (--B);
  $69DB return;

; ------------------------------------------------------------------------------

; looks like it's filling door_related with stuff from the door_positions table
;

c $69DC sub_69DC
D $69DC Wipe $81D6..$81D9 with 0xFF.
  $69DC A = 0xFF;
  $69DE DE = door_related + 3;
  $69E1 B = 4;
  $69E3 do < *DE-- = A;
  $69E5 > while (--B);
;
  $69E7 DE++; // DE = door_related
  $69E8 B = indoor_room_index << 2;
  $69EE C = 0;
  $69F1 HL' = &door_positions[0];
  $69F4 B' = 124; // length of (door_positions)
  $69F6 DE' = 4; // stride
  $69F9 do < if (*HL' & 0xFC == B) {
  $6A00 *DE++ = C ^ 0x80; }
  $6A05 C ^= 0x80;
  $6A08 if (C >= 0) C++; // increment every two stops?
  $6A0E HL' += DE';
  $6A0F > while (--B');
;
  $6A11 return;

; ------------------------------------------------------------------------------

c $6A12 get_door_position
D $6A12 Index turns into door_position struct pointer.
R $6A12 I:A  Index of ...
R $6A12 O:HL Pointer to ...
R $6A12 O:DE Corrupted.
;
  $6A12 HL = &door_positions[A * 2]; // are they pairs of doors?
  $6A1D if (A & (1<<7)) HL += 4;
  $6A26 return;

; ------------------------------------------------------------------------------

c $6A27 wipe_visible_tiles
D $6A27 Wipe the visible tiles array at $F0F8 (24 * 17 = 408).
  $6A27 memset($F0F8, 0, 408);
  $6A34 return;

; ------------------------------------------------------------------------------

c $6A35 select_room_maybe
  $6A35 wipe_visible_tiles();
  $6A38 HL = rooms_and_tunnels[indoor_room_index - 1];

  $6A48 PUSH HL
  $6A49 sub_69DC();
  $6A4C POP HL
  $6A4D DE = &first_byte_of_room_structure;
  $6A50 LDI // *DE++ = *HL++; BC--;
  $6A52 A = *HL;
  $6A53 AND A
  $6A54 *DE = A;
  $6A55 if (A == 0) <
  $6A57 HL++;
  $6A58 > else

  $6A5A < memcpy(DE, HL, (A * 4) + 1); >

  $6A62 DE = byte_81DA;
  $6A65 A = *HL++;
  $6A67 *DE = A;
  $6A68 AND A
  $6A69 if (A) <
;
  $6A6B DE++;
  $6A6C B = A;
  $6A6D do < PUSH BC
  $6A6E PUSH HL
  $6A6F memcpy(DE, &stru_EA7C[*HL], 7);
  $6A83 *DE++ = 32;
  $6A87 POP HL
  $6A88 HL++;
  $6A89 POP BC
  $6A8A > while (--B); >
;
  $6A8C B = *HL; // count of objects
  $6A8D if (B == 0) return;
;
  $6A90 HL++;
  $6A91 do < PUSH BC
  $6A92 C = *HL++; // object index
  $6A94 A = *HL++; // column
  $6A96 PUSH HL
  $6A97 HL = $F0F8 + *HL * 24 + A; // $F0F8 = visible_tiles_array (so *HL = row, A = column)
  $6AAA EX DE,HL
  $6AAB A = C;
  $6AAC expand_object();
  $6AAF POP HL
  $6AB0 POP BC
  $6AB1 HL++;
  $6AB2 > while (--B);
;
  $6AB4 return;

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
  $6AB5 HL = interior_object_tile_refs[A];
  $6AC1 B = *HL++; // width
  $6AC3 C = *HL++; // height
  $6AC5 LD ($6AE7),B    // self modify (== width)
;
  $6AC9 do < do < expand: A = *HL;
  $6ACA if (A != objecttile_ESCAPE) goto $6ADE;
  $6ACE HL++;
  $6ACF A = *HL;
  $6AD0 if (A == objecttile_ESCAPE) goto $6ADE;  // FF FF => FF
  $6AD4 A &= 0xF0;      // redundant?
  $6AD6 if (A >= 128) goto $6AF4;
  $6ADA if (A == 64) goto $6B19;
;
  $6ADE if (A) *DE = A;
  $6AE2 HL++;
  $6AE3 DE++;
  $6AE4 > while (--B);
  $6AE6 B = 1;        // self modified
  $6AE8 DE += 24 - B;
  $6AF0 > while (--C); // for each row
  $6AF3 return;
;
; 128..255 case
  $6AF4 A = *HL++ & 0x7F;
  $6AF7 EX AF,AF'
  $6AF9 A = *HL;
  $6AFA EX AF,AF'
;
  $6AFB do < EX AF,AF'
  $6AFC if (A > 0) *DE = A;
;
  $6B00 DE++;
  $6B01 DJNZ $6B12
; ran out of width
  $6B03 LD A,($6AE7)    // A = width
  $6B07 DE += 24 - A;   // stride
  $6B0F A = *HL;
  $6B10 if (--C == 0) return;
;
  $6B12 EX AF,AF'
  $6B13 > while (--A);
  $6B16 HL++;
  $6B17 goto expand;
;
; 64..127 case
  $6B19 A = 60;         // 'INC A'
  $6B1B LD ($6B28),A    // self modify (but nothing else modifies it! possible evidence that other encodings with 'DEC A' were attempted)
  $6B1E A = *HL++ & 0x0F;
  $6B21 EX AF,AF'
  $6B23 A = *HL;
  $6B24 EX AF,AF'
;
  $6B25 do < EX AF,AF'
  $6B26 *DE++ = A;
  $6B28 INC A           // self modified
  $6B29 DJNZ $6B3B
  $6B2B PUSH AF
  $6B2C LD A,($6AE7)    // A = width
  $6B30 DE += 24 - A;   // stride
  $6B38 POP AF
  $6B3A if (--C == 0) return;
;
  $6B3B EX AF,AF'
  $6B3D > while (--A);
  $6B3F HL++;
  $6B40 goto expand;

; ------------------------------------------------------------------------------

c $6B42 plot_indoor_tiles
D $6B42 Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer.
R $6B42 O:A   Corrupted.
R $6B42 O:BC  Corrupted.
R $6B42 O:DE  Corrupted.
R $6B42 O:HL  Corrupted.
R $6B42 O:A'  Corrupted.
R $6B42 O:BC' Corrupted.
R $6B42 O:DE' Corrupted.
R $6B42 O:HL' Corrupted.
  $6B42 HL = $F290;  // screen buf
  $6B45 DE = $F0F8;  // tiles buf
  $6B48 C = 16;      // rows
  $6B4A do < B = 24; // columns
  $6B4C do < PUSH HL
  $6B4D A = *DE;
  $6B4F HL' = &interior_tiles[A];
  $6B59 POP DE'
  $6B5A B' = 8; C' = 24;
  $6B5D do < *DE' = *HL'++;
  $6B5F DE' += C';
  $6B66 > while (--B');
  $6B69 DE++;
  $6B6A HL++;
  $6B6B > while (--B);
  $6B6D HL += 7 * 24;
  $6B74 > while (--C);
  $6B78 return;

; ------------------------------------------------------------------------------

w $6B79 beds
D $6B79 6x pointers to bed. These are the beds of active prisoners.
D $6B79 Note that the top hut has prisoners permanently in bed.

; ------------------------------------------------------------------------------

b $6B85 four_byte_structures
D $6B85,40,4 10x 4-byte structures which are ranged checked by routine at #R$B29F.

; ------------------------------------------------------------------------------

b $6BAD rooms_and_tunnels
D $6BAD Rooms and tunnels.
W $6BAD Array of pointers to rooms (starting at 1).
W $6BE5 Array of pointers to tunnels.
;
B $6C15 room_def: room1_hut1_right
;
B $6C47 room_def: room2_hut2_left
B $6C61,1 bed
D $6C61 Where the player sleeps.
;
B $6C6D room_def: room3_hut2_right
B $6C8A,1 bed_A
B $6C8D,1 bed_B
B $6C90,1 bed_C
;
B $6C9F room_def: room4_hut3_left
;
B $6CC9 room_def: room5_hut3_right
B $6CE6,1 bed_D
B $6CE9,1 bed_E
B $6CEC,1 bed_F
;
B $6CFB room_def: room6_corridor
;
B $6D0F room_def: room9_crate
;
B $6D37 room_def: room10_lockpick
;
B $6D70 room_def: room11_papers
;
B $6D94 room_def: room12_corridor
;
B $6DA6 room_def: room13_corridor
;
B $6DBE room_def: room14_torch
;
B $6DEA room_def: room15_uniform
;
B $6E20 room_def: room16_corridor
;
B $6E32 room_def: room7_corridor
;
B $6E43 room_def: room18_radio
;
B $6E76 room_def: room19_food
;
B $6EA0 room_def: room20_redcross
;
B $6ECF room_def: room22_red_key
;
B $6EF2 room_def: room23_breakfast
B $6F17,1 bench_A
B $6F1A,1 bench_B
B $6F1D,1 bench_C
;
B $6F20 room_def: room24_solitary
;
B $6F32 room_def: room25_breakfast
B $6F4F,1 bench_D
B $6F52,1 bench_E
B $6F55,1 bench_F
B $6F58,1 bench_G
D $6F58 Where the player sits.
;
B $6F5B room_def: room26_hut1_left
;
B $6F82 room_def: room29_second_tunnel_start
;
B $6F9E room_def: room31
;
B $6FBA room_def: room36
;
B $6FD3 room_def: room32
;
B $6FEC room_def: room34
;
B $7008 room_def: room35
;
B $7024 room_def: room30
;
B $7041 room_def: room40
;
B $705D room_def: room44
;
B $7075 room_def: room50_blocked_tunnel
B $7077,1 blockage
B $708C,1 collapsed_tunnel_obj [unsure]

; ------------------------------------------------------------------------------

; Interior object tile refs.
;
b $7095 interior_object_tile_refs
W $7095 Array of pointer to interior object tile refs, 54 entries long (== number of interior room objects).
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
B $7612 characterstruct_0:
B $7619 characterstruct_1:
B $7620 characterstruct_2:
B $7627 characterstruct_3:
B $762E characterstruct_4:
B $7635 characterstruct_5:
B $763C characterstruct_6:
B $7643 characterstruct_7: prisoner who sleeps at bed position A
B $764A characterstruct_8: prisoner who sleeps at bed position B
B $7651 characterstruct_9: prisoner who sleeps at bed position C
B $7658 characterstruct_10: prisoner who sleeps at bed position D
B $765F characterstruct_11: prisoner who sleeps at bed position E
B $7666 characterstruct_12: prisoner who sleeps at bed position F (<- perhaps_reset_map_and_characters)
B $766D characterstruct_13:
B $7674 characterstruct_14:
B $767B characterstruct_15:
B $7682 characterstruct_16:
B $7689 characterstruct_17:
B $7690 characterstruct_18: prisoner who sits at bench position D
B $7697 characterstruct_19: prisoner who sits at bench position E
B $769E characterstruct_20: prisoner who sits at bench position F (<- sub_A289)
B $76A5 characterstruct_21: prisoner who sits at bench position A
B $76AC characterstruct_22: prisoner who sits at bench position B
B $76B3 characterstruct_23: prisoner who sits at bench position C
B $76BA characterstruct_24:
B $76C1 characterstruct_25:

; ------------------------------------------------------------------------------

b $76C8 item_structs
D $76C8 Array, 16 long, of 7-byte structures. These are 'characters' but seem to be the game items.
D $76C8 struct { byte item; byte room; byte y, x; ... 3 others ...; }
B $76C8 itemstruct_0: wiresnips { item_WIRESNIPS, room_NONE, ... } (<- item_to_itemstruct, find_nearby_item)
B $76CF itemstruct_1: shovel { item_SHOVEL, room_9, ... }
B $76D6 itemstruct_2: lockpick { item_LOCKPICK, room_10, ... }
B $76DD itemstruct_3: papers { item_PAPERS, room_11, ... }
B $76E4 itemstruct_4: torch { item_TORCH, room_14, ... }
B $76EB itemstruct_5: bribe { item_BRIBE, room_NONE, ... } (<- use_bribe)
B $76F2 itemstruct_6: uniform { item_UNIFORM, room_15, ... }
B $76F9 itemstruct_7: food { item_FOOD, room_19, ... } (<- action_poison, called_from_main_loop)
B $7700 itemstruct_8: poison { item_POISON, room_1, ... }
B $7707 itemstruct_9: red key { item_RED_KEY, room_22, ... }
B $770E itemstruct_10: yellow key { item_YELLOW_KEY, room_11, ... }
B $7715 itemstruct_11: green key { item_GREEN_KEY, room_0, ... }
B $771C itemstruct_12: red cross parcel { item_RED_CROSS_PARCEL, room_NONE, ... } (<- event_new_red_cross_parcel, new_red_cross_parcel)
B $7723 itemstruct_13: radio { item_RADIO, room_18, ... }
B $772A itemstruct_14: purse { item_PURSE, room_NONE, ... }
B $7731 itemstruct_15: compass { item_COMPASS, room_NONE, ... }

; ------------------------------------------------------------------------------

; More object tile refs.
;
b $7738 more_object_tile_refs
W $7738 Array of pointers to object tile refs, 46 entries long.
B $7794,1 could be a terminating $FF
B $7795 Object tile refs
B $7799 Object tile refs
B $77A0 Object tile refs
B $77CD Object tile refs
B $77D0 Object tile refs
B $77D4 Object tile refs
B $77D8 Object tile refs
B $77DA Object tile refs
B $77DC Object tile refs
B $77DE Object tile refs
B $77E1 Object tile refs
B $77E7 Object tile refs
B $77EC Object tile refs
B $77F1 Object tile refs
B $77F3 Object tile refs
B $77F5 Object tile refs
B $77F7 Object tile refs
B $77F9 Object tile refs
B $77FB Object tile refs
B $77FD Object tile refs
B $77FF Object tile refs
B $7801 Object tile refs
B $7803 Object tile refs
B $7805 Object tile refs
B $7807 Object tile refs
B $7809 Object tile refs
B $780B Object tile refs
B $780D Object tile refs
B $780F Object tile refs
B $7815 Object tile refs
B $781A Object tile refs
B $781F Object tile refs
B $7825 Object tile refs
B $782B Object tile refs
B $7831 Object tile refs
B $7833 Object tile refs
B $7835 Object tile refs
B $7838 Object tile refs

; ------------------------------------------------------------------------------

b $783A byte_783A
D $783A bytes, 156 long, maybe

; ------------------------------------------------------------------------------

b $78D6 door_positions
D $78D6,496,4 124 four-byte structs (<- sub 69DC)

; ------------------------------------------------------------------------------

b $7AC6 byte_7AC6
D $7AC6 3 bytes long (<- solitary)

; ------------------------------------------------------------------------------

c $7AC9 check_for_pick_up_keypress
D $7AC9 check for 'pick up', 'drop' and both 'use item' keypresses
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
  $7B0A memcpy(&word_81A4, $800F, 6); // copy Y,X and vertical offset
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

; ------------------------------------------------------------------------------

c $7B8B drop_item
  $7B8B A = (items_held)
  $7B8E if (A == item_NONE) return;
  $7B91 if (A == item_UNIFORM) $8015 = sprite_prisoner_tl_4;
  $7B9C ...
  $7B9D HL = items_held + 1 (item slot B)
  $7BA0 A = (HL)
  $7BA1 (HL) = item_NONE;
  $7BA3 HL--;
  $7BA4 (HL) = item_NONE;
  $7BA5 draw_all_items();
  $7BA8 play_speaker(sound_DROP_ITEM);
  $7BAE choose_game_screen_attributes();
  $7BB1 set_game_screen_attributes();
  $7BB4 ...
  $7BB5 box_opening_maybe:
  $7BB8 ...
  $7BE3 return;
  $7BE4 ...
  $7C25 return;

; ------------------------------------------------------------------------------

c $7C26 item_to_itemstruct
R $7C26 A Item index.
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
D $7C54 Wipe item.
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
D $7C54 Plot bitmap.
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
; looks like C is a pick up radius
  $7C82 C = 1; // outside
  $7C84 if (indoor_room_index) C = 6;
  $7C8C B = 16; // 16 iterations
  $7C8E HL = &itemstruct_0.room;
  $7C91 do < if ((*HL & (1<<7)) == 0) goto next; // item is not anywhere
  $7C95 PUSH BC
  $7C96 PUSH HL
  $7C97 HL++;
  $7C98 DE = &player_map_position_perhapsX;
  $7C9B B = 2;
; range check
  $7C9D do < A = *DE - C;
  $7C9F if (A >= *HL) goto popnext;
  $7CA2 A += C * 2;
  $7CA4 if (A < *HL) goto popnext;
  $7CA7 HL++;
  $7CA8 DE++;
  $7CA9 > while (--B);
  $7CAB POP HL
  $7CAC HL--; // compensate for overshoot
  $7CAD POP BC
  $7CAE A = 0; // set Z (found)
  $7CAF return; // (oddly written as RET Z, there's no need for it to be conditional)

  $7CB0 popnext: POP HL
  $7CB1 POP BC
  $7CB2 next: HL += 7; // stride
  $7CB9 > while (--B);
  $7CBB A |= 1; // set NZ
  $7CBD return;

; ------------------------------------------------------------------------------

c $7CBE plot_bitmap
D $7CBE Straight bitmap plot without masking.
R $7CBE I:DE Source address.
R $7CBE I:HL Destination address.
R $7CBE I:BC Dimensions (w x h, where w is in bytes).
;
  $7CBE A = B;
  $7CBF (loopcounter + 1) = A;   // self modifying
  $7CC2 do < loopcounter: B = 3; // modified
  $7CC4 PUSH HL
  $7CC5 do < A = *DE;
  $7CC6 *HL++ = A;
  $7CC8 DE++;
  $7CC9 > while (--B);
  $7CCB POP HL
  $7CCC get_next_scanline();
  $7CCF > while (--C);
  $7CD3 return;

; ------------------------------------------------------------------------------

c $7CD4 screen_wipe
D $7CD4 Wipe the screen.
R $7CD4 I:B  Number of bytes to set.
R $7CD4 I:C  Number of scanlines.
R $7CD4 I:HL Destination address.
;
  $7CD4 A = B;
  $7CD5 (loopcounter + 1) = A;   // self modifying
  $7CD8 do < loopcounter: B = 2; // modified
  $7CDA PUSH HL
  $7CDB do < *HL++ = 0;
  $7CDE > while (--B);
  $7CE0 POP HL
  $7CE1 get_next_scanline();
  $7CE4 > while (--C);
  $7CE8 return;

; ------------------------------------------------------------------------------

c $7CE9 get_next_scanline
D $A082 Given a screen address, returns the same position on the next scanline.
R $A082 I:HL Original screen address.
R $A082 O:HL Updated screen address.
;
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

b $7CFC message_buffer_stuff
  $7CFC message_buffer
  $7D0F message_display_counter
  $7D10 message_display_index
D $7D10 If 128 then shunt_buffer_back_by_two. If > 128 then wipe message. Else ?
W $7D11 message_buffer_pointer
W $7D13 current_message_character

; ------------------------------------------------------------------------------

c $7D15 queue_message_for_display
R $7D15 B message_* index.
R $7D15 C ...
  $7D15 if (*(HL = message_buffer_pointer) == 0xFF) return;
  $7D1C HL -= 2;
  $7D1E A = *HL++; if (A == B) {
  $7D23 A = *HL; if (A == C) return; }
  $7D26 *++HL = B; *++HL = C; HL++;
  $7D2B *message_buffer_pointer = HL;
  $7D2E return;

; ------------------------------------------------------------------------------

c $7D2F plot_glyph
R $7D2F I:HL Pointer to glyph.
R $7D2F   DE Pointer to destination.
R $7D2F O:HL Preserved.
R $7D2F   DE Points to next character.
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
  $7D50 message_display_counter--;
  $7D53 return; }
;
  $7D54 A = message_display_index;
  $7D57 if (A == 128) goto shunt_buffer_back_by_two; // exit via
  $7D5B else if (A > 128) goto wipe_message; // exit via
  $7D5D else { HL = current_message_character;
  $7D60 DE = screen_text_start_address + A;
  $7D65 plot_glyph();
  $7D68 message_display_index = E & 31;
  $7D6E A = *++HL;
  $7D70 if (A != 255) goto nonzero;
  $7D75 message_display_counter = 31; // leave the message for 31 turns
  $7D7A message_display_index |= 128; // then wipe it
  $7D82 return;
;
  $7D83 nonzero: current_message_character = HL;
  $7D86 return; }

; ------------------------------------------------------------------------------

c $7D87 wipe_message
  $7D87 A = message_display_index;
  $7D8A message_display_index = --A;
  $7D8E DE = screen_text_start_address + A;
  $7D93 plot_single_glyph(35); // plot a SPACE character
  $7D98 return;

; ------------------------------------------------------------------------------

c $7D99 shunt_buffer_back_by_two
D $7D99 Looks like message_buffer is poked with the index of the message to display...
  $7D99 HL = message_buffer_pointer;
  $7D9C DE = &message_buffer;
  $7D9F if (L == E) return; // cheap test
;
  $7DA2 swap(DE, HL);
  $7DA3 A = *HL++;
  $7DA5 C = *HL; // I don't understand why C is loaded here.
  $7DA6 HL = &messages_table[A];
  $7DAE E = *HL++;
  $7DB0 D = *HL; // DE = messages_table[A]
  $7DB1 swap(DE, HL);
  $7DB2 current_message_character = HL;
  $7DB5 memmove(message_buffer_slack, message_buffer, 16);
  $7DC0 message_buffer_pointer -= 2;
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
D $81A3 Likely unreferenced byte.

; ------------------------------------------------------------------------------

w $81A4 word_81A4

; ------------------------------------------------------------------------------

w $81A6 word_81A6

; ------------------------------------------------------------------------------

w $81A8 word_81A8

; ------------------------------------------------------------------------------

b $81AA word_81AA

; ------------------------------------------------------------------------------

u $81AB unused_81AB
D $81AB Likely unreferenced byte.

; ------------------------------------------------------------------------------

w $81AC word_81AC

; ------------------------------------------------------------------------------

w $81AE word_81AE

; ------------------------------------------------------------------------------

w $81B0 word_81B0

; ------------------------------------------------------------------------------

b $81B2 byte_81B2

; ------------------------------------------------------------------------------

b $81B3 byte_81B3

; ------------------------------------------------------------------------------

b $81B4 byte_81B4

; ------------------------------------------------------------------------------

b $81B5 map_position_related_1
b $81B6 map_position_related_2

; ------------------------------------------------------------------------------

b $81B7 byte_81B7

; ------------------------------------------------------------------------------

b $81B8 player_map_position_perhapsX
b $81B9 player_map_position_perhapsY

; ------------------------------------------------------------------------------

u $81BA unused_81BA
D $81BA Likely unreferenced byte.

; ------------------------------------------------------------------------------

w $81BB map_position_maybe

; ------------------------------------------------------------------------------

b $81BD spotlight_found_player
D $81BD Suspect that this is a 'player has been found in spotlight' flag.
D $81BD (<- nighttime, something_then_decrease_morale)

; ------------------------------------------------------------------------------

b $81BE first_word_of_room_structure
D $81BE [unsure]

; ------------------------------------------------------------------------------

b $81BF byte_81BF
D $81BF Seems to hold many zeroes.

; ------------------------------------------------------------------------------

b $81D6 door_related
D $81D6 (<- indoors maybe, <- open door)
D $81D9 Final byte?

; ------------------------------------------------------------------------------

b $81DA byte_81DA
D $81DA (<- select_room_maybe, sub_B916)

; ------------------------------------------------------------------------------

b $8213 possibly_holds_an_item

; ------------------------------------------------------------------------------

b $8214 byte_8214

; ------------------------------------------------------------------------------

w $8215 items_held
D $8215 Two byte slots. initialised to 0xFFFF meaning no item in either slot.

; ------------------------------------------------------------------------------

b $8217 character_index

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
D $8218 Exterior tiles set 0. 111 tiles. Looks like mask tiles for huts. (<- plot_a_tile_perhaps)
D $8590 Exterior tiles set 1. 145 tiles. Looks like tiles for huts. (<- plot_a_tile_perhaps)
D $8A18 Exterior tiles set 2. 220 tiles. Looks like main building wall tiles. (<- plot_a_tile_perhaps)
D $90F8 Exterior tiles set 3. 243 tiles. Looks like main building wall tiles.
D $9768 Interior tiles. 194 tiles.
;
;B $8A18,8 tile: ground1 [start of exterior tiles 2] (<- plot_a_tile_perhaps)
;B $8A20,8 tile: ground2
;B $8A28,8 tile: ground3
;B $8A30,8 tile: ground4
;
;D $9768,8 empty tile (<- plot_indoor_tiles, sub_BCAA)

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
  $9D78 some_sort_of_initial_setup_maybe();
  $9D7B main_loop: for (;;) { check_morale();
  $9D7E keyscan_game_cancel();
  $9D81 message_timer();
  $9D84 process_user_input();
  $9D87 in_permitted_area();
  $9D8A called_from_main_loop_3(); // [unknown]
  $9D8D move_characters();
  $9D90 called_from_main_loop_5(); // [unknown]
  $9D93 called_from_main_loop_6(); // [unknown]
  $9D96 called_from_main_loop_7(); // [unknown]
  $9D99 called_from_main_loop_8(); // [unknown]
  $9D9C ring_bell();
  $9D9F called_from_main_loop_9(); // [unknown]
  $9DA2 called_from_main_loop_10(); // [unknown]
  $9DA5 message_timer();
  $9DA8 ring_bell();
  $9DAB called_from_main_loop_11(); // [unknown]
  $9DAE plot_game_screen();
  $9DB1 ring_bell();
  $9DB4 if (day_or_night != 0) nighttime();
  $9DBB if (indoor_room_index != 0) indoors_delay_loop();
  $9DC2 wave_morale_flag();
  $9DC5 if ((game_counter & 63) == 0) dispatch_table_thing();
  $9DCD }

; ------------------------------------------------------------------------------

c $9DCF check_morale
D $9DCF (<- main_loop)
  $9DCF if (morale >= 2) return;
  $9DD5 queue_message_for_display(message_MORALE_IS_ZERO, 0);
  $9DDB *(morale_related + 1) = 0xFF; // mystery
  $9DE0 *(morale_related_also) = 0; // mystery
  $9DE4 return;

; ------------------------------------------------------------------------------

c $9DE5 keyscan_cancel
D $9DE5 Check for 'game cancel' keypress.
  $9DE5 if (!shift_pressed) return;
  $9DED if (!space_pressed) return;
  $9DF4 screen_reset_perhaps(); user_confirm(); if (confirmed) looks_like_a_reset_fn();
  $9DFD if (indoor_room_index == 0) loc_B2FC(); else some_sort_of_initial_setup_maybe(); // exit via

; ------------------------------------------------------------------------------

c $9E07 process_user_input
  $9E07 if (morale_related) return; // inhibits user control when morale hits zero
  $9E0E if (($8001 & 3) == 0) goto not_picking_lock_or_cutting_wire;
  $9E15 morale_related_also = 31;
  $9E1A if ($8001 == 1) goto picking_a_lock;
  $9E1F wire_snipped(); return; // exit via
;
  $9E22 not_picking_lock_or_cutting_wire: A = input_routine(); // lives at same address as counter_of_something
  $9E25 HL = &morale_related_also;
  $9E2A if (A != input_NONE) goto user_input_super(HL);
  $9E2D if (morale_related_also == 0) return;
  $9E30 morale_related_also--;
  $9E31 A = 0;
  $9E32 goto user_input_fire_not_pressed;

; ------------------------------------------------------------------------------

c $9E34 user_input_super
R $9E34 I:HL Points to ?
  $9E34 *HL = 31;
  $9E36 ... (push af) ...
  $9E37 if (bed_related != 0) goto user_input_was_in_bed_perhaps;
  $9E3D if (breakfast_related != 0) goto user_input_was_having_breakfast_perhaps;
  $9E43 (word) $8002 = 0x002B; // ?
  $9E49 (word) $800F = 0x0034; // set Y pos
  $9E4E (word) $8011 = 0x003E; // set X pos
  $9E52 bench_G = interiorobject_EMPTY_BENCH;
  $9E57 HL = breakfast_related;
  $9E5A goto user_input_another_entry_point;

; ------------------------------------------------------------------------------

c $9E5C user_input_was_in_bed_perhaps
  $9E5C (word) $8002 = 0x012C; // ?
  $9E62 (word) $8004 = 0x2E2E; // another position?
  $9E68 (word) $800F = 0x002E; // set Y pos
  $9E6D (word) $8011 = 0x002E; // set X pos
  $9E70 $8013 = 24; // set vertical offset
  $9E75 player_bed = interiorobject_EMPTY_BED;
  $9E7A HL = &bed_related;
;
  $9E7D user_input_another_entry_point: *HL = 0;
  $9E7F select_room_maybe();
  $9E82 plot_indoor_tiles();
  $9E85 user_input_was_having_breakfast_perhaps: ... (pop af -- restores user input value stored at $9E36)
  $9E86 if (A < input_FIRE) goto user_input_fire_not_pressed;
  $9E8A check_for_pick_up_keypress();
  $9E8D A = 0x80;
  $9E8F user_input_fire_not_pressed: if (*$800D == A) return; // tunnel related?
  $9E94 $800D = A | 0x80;
  $9E97 return;

; ------------------------------------------------------------------------------

c $9E98 picking_a_lock
D $9E98 Locks user out until lock is picked.
  $9E98 if (user_locked_out_until != game_counter) return;
  $9EA0 *ptr_to_door_being_lockpicked &= ~(1 << 7); // unlock
  $9EA5 queue_message_for_display(message_IT_IS_OPEN);
  $9EAA clear_lockpick_wirecut_flags_and_return: $8001 &= ~3; // clear lock picking and wire snipping flags
  $9EB1 return;

; ------------------------------------------------------------------------------

c $9EB2 wire_snipped
D $9EB2 Locks user out until wire is snipped.
  $9EB2 A = user_locked_out_until - game_counter;
  $9EB9 if (A == 0) goto wire_successfully_snipped;
  $9EBB if (A >= 4) return;
  $9EBE $800D = table_9EE0[$800E & 3];
  $9ECF return;
;
  $9ED0 wire_successfully_snipped: $800E = A & 3; // walk/crawl flag?
  $9ED6 $800D = 0x80;
  $9ED9 $8013 = 24; // set vertical offset
  $9EDE goto clear_lockpick_wirecut_flags_and_return;

; ------------------------------------------------------------------------------

b $9EE0 byte_9EE0
D $9EE0 Indexed by $800E.

; ------------------------------------------------------------------------------

b $9EE4 twentyonelong
D $9EE4 7 structs, 3 wide. maps bytes to offsets.
  $9EE4,3 byte_to_offset <42, byte_9EF9>
  $9EE7,3 byte_to_offset < 5, byte_9EFC>
  $9EEA,3 byte_to_offset <14, byte_9F01>
  $9EED,3 byte_to_offset <16, byte_9F08>
  $9EF0,3 byte_to_offset <44, byte_9F0E>
  $9EF3,3 byte_to_offset <43, byte_9F11>
  $9EF6,3 byte_to_offset <45, byte_9F13>
  $9EF9 byte_9EF9
  $9EFC byte_9EFC
  $9F01 byte_9F01
  $9F08 byte_9F08
  $9F0E byte_9F0E
  $9F11 byte_9F11
  $9F13 byte_9F13

; ------------------------------------------------------------------------------

b $9F15 byte_9F15
D $9F15 (<- in_permitted_area)

; ------------------------------------------------------------------------------

c $9F21 in_permitted_area
D $9F21 [unsure] -- could be as general as bounds detection
  $A007 a second in_permitted_area entry point

; ------------------------------------------------------------------------------

c $A035 wave_morale_flag
;
D $A035 Wave the flag every other turn.
  $A035 HL = &game_counter;
  $A038 (*HL)++;
  $A039 A = *HL & 1;
  $A03C if (A) return;
;
  $A03D PUSH HL
  $A03E A = morale;
  $A041 HL = &displayed_morale;
  $A044 if (A == *HL) goto wiggle;
  $A047 if (A >  *HL) goto increasing;
;
D $A04A Decreasing morale.
  $A04A (*HL)--;
  $A04B HL = moraleflag_screen_address;
  $A04E get_next_scanline();
  $A051 goto move;
;
  $A053 increasing: (*HL)++;
  $A054 HL = moraleflag_screen_address;
  $A057 get_prev_scanline();
;
  $A05A move: moraleflag_screen_address = HL;
;
  $A05D wiggle: DE = bitmap_flag_down;
  $A060 POP HL
  $A061 if ((*HL & 1) != 0) DE = bitmap_flag_up;
  $A068 plot: HL = moraleflag_screen_address;
  $A06E plot_bitmap(0x0319); // dimensions: 24 x 25 // args-BC // exit via

; ------------------------------------------------------------------------------

c $A071 set_morale_flag_screen_attributes
R $A071 A Attributes to use.
  $A071 HL = $5842; // first attribute byte
  $A074 DE = $001E; // skip
  $A077 B  = $13;
  $A079 do < *HL++ = A;
  $A07B *HL++ = A;
  $A07E HL += DE;
  $A07F > while (--B);
  $A081 return;

; ------------------------------------------------------------------------------

c $A082 get_prev_scanline
D $A082 Given a screen address, returns the same position on the previous scanline.
R $A082 I:HL Original screen address.
R $A082 O:HL Updated screen address.
;
  $A082 if ((H & 7) != 0) // NNN bits
  $A087   HL -= 256; // step back one scanline
  $A088   return;
;
  $A089 if (L < 32) HL -= 32; else HL += 0x06E0; // complicated
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
  $A0A2 if (A == 255) return; // not ringing
  $A0A5 if (A == 0) goto ring_a_ding_ding; // 0 => perpetual ringing
  $A0A8 *HL = --A;
  $A0AA if (A != 0) goto ring_a_ding_ding;
  $A0AC *HL = 255; // counter hit zero - stop ringing
  $A0AF return;
;
  $A0B0 ring_a_ding_ding: A = screenaddr_bell_ringer; // fetch visible state of bell
  $A0B3 if (A == 63) goto plot_ringer_off; // toggle
  $A0B8 goto plot_ringer_on; // note: redundant jump
;
  $A0BB plot_ringer_on: DE = bell_ringer_bitmap_on;
  $A0BE plot_ringer();
  $A0C1 play_speaker(sound_BELL_RINGER); // args=BC
;
  $A0C6 plot_ringer_off: DE = bell_ringer_bitmap_off;
  $A0C9 plot_ringer: HL = screenaddr_bell_ringer;
  $A0CC plot_bitmap(0x010C) // dimensions: 8 x 12 // args=BC // exit via

; ------------------------------------------------------------------------------

c $A0D2 increase_morale
R $A0D2 B Amount to increase morale by. (Preserved)
  $A0D2 A = morale + B;
  $A0D6 if (A >= morale_MAX) A = morale_MAX;
  $A0DC set_morale_from_A: morale = A;
  $A0DF return;

c $A0E0 decrease_morale
R $A0E0 B Amount to decrease morale by. (Preserved)
  $A0E0 A = morale - B;
  $A0E4 if (A < morale_MIN) A = morale_MIN;
  $A0E7 goto set_morale_from_A;

c $A0E9 increase_morale_by_10_score_by_50
D $A0E9 Increase morale by 10, score by 50.
  $A0E9 increase_morale(10);
  $A0EE increase_score(50); return; // exit via

c $A0F2 increase_morale_by_5
D $A0F2 Increase morale by 5, score by 5.
  $A0F2 increase_morale(5);
  $A0F7 increase_score(5); return; // exit via

; ------------------------------------------------------------------------------

c $A0F9 increase_score
D $A0F9 Increases the score then plots it.
R $A0F9 B Amount to increase score by.
  $A0F9 A = 10;
  $A0FB HL = &score_digits + 4;
  $A0FE do { tmp = HL;
  $A0FF increment_score: (*HL)++;
  $A100 if (*HL == A) { *HL-- = 0; goto increment_score; }
  $A108 HL = tmp;
  $A109 } while (--B);
E $A0F9 FALL THROUGH into plot_score.

; ------------------------------------------------------------------------------

c $A10B plot_score
D $A10B Draws the current score to screen.
  $A10B HL = &score_digits;
  $A10E DE = &score; // screen address of score
  $A111 B = 5;
  $A113 do {
  $A114 plot_glyph(); // HL -> glyph, DE -> destination
  $A117 HL++;
  $A118 DE++;
  $A119 ...
  $A11A } while (--B);
  $A11C return;

; ------------------------------------------------------------------------------

c $A11D play_speaker
R $A11D B Iterations.
R $A11D C Delay.
  $A11D
  $A11E Self-modify delay loop at $A126.
  $A121 Initial speaker bit.
  $A123 do { Play.
  $A127 while (delay--) ;
  $A12A Toggle speaker bit.
  $A12C } while (...);
  $A12E return;

; ------------------------------------------------------------------------------

b $A12F game_counter
D $A12F Counts 00..FF then wraps.

; ------------------------------------------------------------------------------

b $A130 bell
D $A130 0 => ring indefinitely; 255 => don't ring; N => ring for N calls

; ------------------------------------------------------------------------------

u $A131 unused_A131
D $A131 Likely unreferenced byte.

; ------------------------------------------------------------------------------

b $A132 score_digits

; ------------------------------------------------------------------------------

b $A137 breakfast_related

; ------------------------------------------------------------------------------

b $A138 naughty_flag_perhaps

; ------------------------------------------------------------------------------

b $A139 morale_related_also
b $A13A morale_related
b $A13C morale

; ------------------------------------------------------------------------------

b $A13D dispatch_counter

; ------------------------------------------------------------------------------

b $A13E byte_A13E

; ------------------------------------------------------------------------------

b $A13F bed_related_perhaps

; ------------------------------------------------------------------------------

b $A140 displayed_morale
D $A140 Displayed morale lags behind actual morale, as the flag moves slowly to its target.

; ------------------------------------------------------------------------------

w $A141 moraleflag_screen_address

; ------------------------------------------------------------------------------

w $A143 ptr_to_door_being_lockpicked
D $A143 Address of door in which bit 7 is cleared when picked.

; ------------------------------------------------------------------------------

b $A145 user_locked_out_until
D $A145 Game time until user control is restored (e.g. when picking a lock or cutting wire).

; ------------------------------------------------------------------------------

b $A146 day_or_night
D $A146 $00 = daytime, $FF = nighttime.

; ------------------------------------------------------------------------------

b $A147 bell_ringer_bitmaps
B $A147 bell_ringer_bitmap_off
B $A153 bell_ringer_bitmap_on

; ------------------------------------------------------------------------------

c $A15F set_game_screen_attributes
R $A15F A Attribute byte.
  $A15F Starting at $5847, set 23 columns of 16 rows to A.

; ------------------------------------------------------------------------------

b $A173 timed_events
D $A173 Array of 15 event structures.
  $A173 {   0, #D$A1D3 }
  $A176 {   8, #D$A1E7 }
  $A179 {  12, #D$A228 }
  $A17C {  16, #D$A1F0 }
  $A17F {  20, #D$EF9A }
  $A182 {  21, #D$A1F9 }
  $A185 {  36, #D$A202 }
  $A188 {  46, #D$A206 }
  $A18B {  64, #D$A215 }
  $A18E {  74, #D$A1F0 }
  $A191 {  78, #D$EF9A }
  $A194 {  79, #D$A219 }
  $A197 {  98, #D$A264 }
  $A19A { 100, #D$A1C3 }
  $A19D { 130, #D$A26A }

; ------------------------------------------------------------------------------

c $A1A0 dispatch_table_thing
D $A1A0 Dispatches time-based game events like parcels, meals, exercise and roll calls.

c $A1C3 event_night_time

c $A1D3 event_another_day_dawns

c $A1E7 event_wake_up

c $A1F0 event_go_to_roll_call

c $A1F9 event_go_to_breakfast_time

c $A202 event_breakfast_time

c $A206 event_go_to_exercise_time

c $A215 event_exercise_time

c $A219 event_go_to_time_for_bed

c $A228 event_new_red_cross_parcel
B $A259 sixlong [it's something like: data to set the parcel object up]
B $A25F red_cross_parcel_contents_list (purse, wiresnips, bribe, compass)
B $A263 red_cross_parcel_current_contents

c $A264 event_time_for_bed

c $A26A event_search_light

; ------------------------------------------------------------------------------

b $A27F tenlong
D $A27F [unsure] (<- sub_A35F, sub_A373)

; ------------------------------------------------------------------------------

c $A289 sub_A289

; ------------------------------------------------------------------------------

c $A2E2 sub_A2E2

; ------------------------------------------------------------------------------

c $A33F set_target_location
  $A33F if (morale_related) return;
  $A344 $8001 &= ~(1<<6); $8002 = b; $8003 = c; return;

; ------------------------------------------------------------------------------

c $A351 sub_A351

; ------------------------------------------------------------------------------

c $A35F sub_A35F
D $A35F Uses tenlong structure.

; ------------------------------------------------------------------------------

c $A373 sub_A373
D $A373 Uses tenlong structure.

; ------------------------------------------------------------------------------

c $A38C sub_A38C

; ------------------------------------------------------------------------------

U $A3A9 unused_A3A9
D $A3A9 Unreferenced byte.

; ------------------------------------------------------------------------------

c $A3AA not_set

; ------------------------------------------------------------------------------

c $A3B3 found
D $A3B3 [possibly a tail of above sub]

; ------------------------------------------------------------------------------

c $A3ED store_banked_A_then_C_at_HL

; ------------------------------------------------------------------------------

c $A3F3 sub_A3F3
D $A3F3 Checks character indexes, sets target locations, ...

; ------------------------------------------------------------------------------

c $A3F8 varA13E_is_zero

; ------------------------------------------------------------------------------

c $A420 character_sits
  $A444 character_sleeps
D $A462 (common end of above two routines)

; ------------------------------------------------------------------------------

c $A47F player_sits
  $A489 player_sleeps
D $A491 (common end of the above two routines)

; ------------------------------------------------------------------------------

c $A4A9 set_location_0xE00
  $A4A9 set_target_location(0x0E00);

; ------------------------------------------------------------------------------

c $A4B7 set_location_0x8E04
  $A4B7 set_target_location(0x8E04);

; ------------------------------------------------------------------------------

c $A4C5 set_location_0x1000
  $A4C5 set_target_location(0x1000);

; ------------------------------------------------------------------------------

c $A4D3 sub_A4D3
D $A4D3 Something character related [very similar to the routine at $A3F3].

; ------------------------------------------------------------------------------

c $A4D8 varA13E_is_zero_anotherone
D $A4D8 sets a target location 2B00

; ------------------------------------------------------------------------------

c $A4FD sub_A4FD

; ------------------------------------------------------------------------------

c $A50B screen_reset
D $A50B [unsure]

; ------------------------------------------------------------------------------

c $A51C escaped

; ------------------------------------------------------------------------------

c $A58C keyscan_all

; ------------------------------------------------------------------------------

c $A59C do_we_have_required_objects_for_escape
R $A59C HL (single) item slot
R $A59C C previous return value
  $A5A3 do_we_have_compass
  $A5AA do_we_have_papers
  $A5B1 do_we_have_purse
  $A5B8 do_we_have_uniform

; ------------------------------------------------------------------------------

c $A5BF screenlocstring_plot

; ------------------------------------------------------------------------------

b $A5CE screenlocstrings
D $A5CE Screen address + string.
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

; ------------------------------------------------------------------------------

b $A7C6 used_by_sub_AAFF

; ------------------------------------------------------------------------------

b $A7C7 plot_game_screen_x

; ------------------------------------------------------------------------------

c $A7C9 sub_A7C9
D $A7C9 resetish

; ------------------------------------------------------------------------------

c $A80A sub_A80A

; ------------------------------------------------------------------------------

c $A819 sub_A819

; ------------------------------------------------------------------------------

c $A8A2 sub_A8A2
D $A8A2 resetish

; ------------------------------------------------------------------------------

c $A8CF sub_A8CF

; ------------------------------------------------------------------------------

c $A8E7 sub_A8E7

; ------------------------------------------------------------------------------

c $A9A0 sub_A9A0

; -----------------------------------------------------------------------------

c $A9AD plot_a_tile_perhaps
D $A9AD Plots tiles to buffer.
R $A9AD HL Supertile index (used to select the correct tile group).
R $A9AD A  Tile index
  $A9AD ...
  $A9B0 tiles = exterior_tiles_1;
  $A9B3 if (super_tile < 45) goto got_it;
  $A9B7 tiles = exterior_tiles_2;
  $A9BA if (super_tile < 139) goto got_it;
  $A9BE if (super_tile >= 204) goto got_it;
  $A9C2 tiles = exterior_tiles_3;
  $A9C5 got_it: ...
  $A9D5 copy_tile: ...
  $A9E3 return;

; -----------------------------------------------------------------------------

c $A9E4 map_shunt_1

c $AA05 map_unshunt_1

c $AA26 map_shunt_2

c $AA4B map_unshunt_2

c $AA6C map_shunt_3

c $AA8D map_unshunt_3

; ------------------------------------------------------------------------------

c $AAB2 called_from_main_loop_10

; ------------------------------------------------------------------------------

w $AB31 map_move_jump_table
D $AB31 jump table of (map_move_1, 2, 3, 4)
C $AB39 map_move_1
C $AB44 map_move_2
C $AB4F map_move_3
C $AB5A map_move_4

; -----------------------------------------------------------------------------

b $AB66 zoombox_stuff
D $AB66 [unsure]
  $AB66 zoombox_related_1
  $AB67 zoombox_horizontal_count
  $AB68 zoombox_related_3
  $AB69 zoombox_vertical_count
  $AB6A game_screen_attribute

; -----------------------------------------------------------------------------

c $AB6B choose_game_screen_attributes
  $AB6B A = (indoor_room_index);
  $AB6E if (A >= room_29_secondtunnelstart) goto choose_attribute_for_tunnel;
  $AB72 A = (day_or_night);
  $AB75 C = attribute_WHITE_OVER_BLACK;
  $AB77 if (A == 0) goto set_attribute_from_C;
  $AB7A A = (indoor_room_index);
  $AB7D C = attribute_BRIGHT_BLUE_OVER_BLACK;
  $AB7F if (A == 0) goto set_attribute_from_C;
  $AB82 C = attribute_CYAN_OVER_BLACK;
  $AB84 set_attribute_from_C: A = C;
  $AB85 set_attribute_from_A: (game_screen_attribute) = A;
  $AB88 return;

; -----------------------------------------------------------------------------

c $AB89 choose_attribute_for_tunnel
  $AB89 C = attribute_RED_OVER_BLACK;
  $AB8B HL = (items_held);
  $AB8E A = item_TORCH;
  $AB90 if (L == A) goto set_attribute_from_C;
  $AB93 if (H == A) goto set_attribute_from_A;
  $AB96 wipe_visible_tiles();
  $AB99 plot_indoor_tiles();
  $AB9C A = attribute_BLUE_OVER_BLACK;
  $AB9E goto set_attribute_from_A;

; -----------------------------------------------------------------------------

c $ABA0 zoombox
  $ABF9 zoombox_1
  $AC6F zoombox_2
  $ACFC zoombox_draw_tile

; ------------------------------------------------------------------------------

w $AD29 word_AD29

; ------------------------------------------------------------------------------

c $AD59 sub_AD59

; ------------------------------------------------------------------------------

c $ADBD nighttime
D $ADBD Turns the screen blue and tracks the player with a spotlight.
;
  $ADBD HL = &spotlight_found_player; // suspected spotlight_found_player flag (possible states: 0, 31, 255)
  $ADC0 A = *HL;
  $ADC1 if (A == 0xFF) goto not_tracking;
;
  $ADC6 A = indoor_room_index;
  $ADC9 if (A == 0) goto outside;
;
  $ADCC *HL = 0xFF; // if the player goes indoors the searchlight loses track
  $ADCE return;
;
  $ADCF outside: A = *HL; // get spotlight_found_player flag
  $ADD0 if (A != 0x1F) goto $AE00;
  $ADD5 HL = map_position_maybe;
  $ADD8 D = L + 4;
  $ADDC D = H;
  $ADDD HL = searchlight_coords;
  $ADE0 A = L;
  $ADE1 if (A != E) goto $ADE9;
  $ADE4 if (H == D) return; // strongly suspect this case means: highlight doesn't need to move, so quit
  $ADE7 goto $ADF1;
;
  $ADE9 if (A >= E) goto $ADEF; // move highlight .. left? down?
  $ADEC A++; // move highlight right? up?
  $ADED goto $ADF0;
;
  $ADEF A--;
;
  $ADF0 L = A; // new coord
;
  $ADF1 A = H;
  $ADF2 if (A == D) goto store;
  $ADF5 if (A > D) goto $ADFB; // move highlight .. left? down?
  $ADF8 A++;
  $ADF9 goto $ADFC;
;
  $ADFB A--;
;
  $ADFC H = A; // new coord
;
  $ADFD store: searchlight_coords = HL;
;
  $AE00 DE = map_position_maybe;
  $AE04 HL = $AE77; // &searchlight_coords + 1 byte;
  $AE07 B = 1; // 1 iteration
  $AE09 PUSH BC
  $AE0A PUSH HL
  $AE0B goto $AE3F;
;
  $AE0D not_tracking: HL = &word_AD29[0];
  $AE10 B = 3; // 3 iterations
  $AE12 do < PUSH BC
  $AE13 PUSH HL
  $AE14 sub_AD59();
  $AE17 POP HL
  $AE18 PUSH HL
  $AE19 something_then_decrease_morale_10();
  $AE1C POP HL
  $AE1D PUSH HL
  $AE1E DE = map_position_maybe;
  $AE22 A = E + 23;
  $AE25 if (A < *HL) goto next; // out of bounds maybe
  $AE29 A = *HL + 16;
  $AE2C if (A < E) goto next;
  $AE30 HL++;
  $AE31 A = D + 16;
  $AE34 if (A < *HL) goto next;
  $AE38 A = *HL + 16;
  $AE3B if (A < D) goto next;
;
  $AE3F A = 0;
;
  $AE40 EX AF,AF'
  $AE41 HL--;
  $AE42 B = 0;
  $AE44 A = *HL - E;
  $AE46 if (A >= 0) goto $AE4E;
  $AE49 B = 0xFF;
  $AE4B EX AF,AF'
  $AE4C A = ~A;
  $AE4D EX AF,AF'
;
  $AE4E C = A;
  $AE4F HL++;
  $AE50 A = *HL;
  $AE51 H = 0;
  $AE53 A -= D;
  $AE54 if (A < 0) H = 0xFF;
;
  $AE59 L = A;
  $AE5A HL *= 32; // attribute address?
  $AE5F HL += BC;
  $AE60 HL += 0x5846; // screen attribute address of top-left game screen attribute
  $AE64 EX DE,HL
  $AE65 EX AF,AF'
;
  $AE66 searchlight_related = A;
  $AE69 searchlight();
;
  $AE6C next: POP HL
  $AE6D POP BC
  $AE6E HL += 7;
  $AE72 > while (--B);
  $AE74 return;

; ------------------------------------------------------------------------------

b $AE75 searchlight_related
D $AE75 (<- nighttime, searchlight)

; ------------------------------------------------------------------------------

w $AE76 searchlight_coords
D $AE76 (<- nighttime)

; ------------------------------------------------------------------------------

c $AE78 something_then_decrease_morale_10
R $AE78 I:HL Pointer to ?
;
  $AE78 DE = map_position_maybe;
  $AE7C B = E + 12;
  $AE80 A = HL[0] + 5;
  $AE83 if (A >= B) return;
;
  $AE85 A += 5;
  $AE87 B -= 2;
  $AE89 if (A < B) return;
;
  $AE8B (hoisted)
  $AE8C B = D + 10;
  $AE90 A = HL[1] + 5;
  $AE93 if (A >= B) return;
;
  $AE95 C = A + 7;
  $AE98 A = B - 4;
  $AE9B if (A >= C) return;
;
  $AE9D A = spotlight_found_player;
  $AEA0 if (A == 0x1F) return;
;
  $AEA3 A = 0x1F;
  $AEA5 spotlight_found_player = A;
  $AEA8 D = HL[0];
  $AEAA E = HL[1];
  $AEAB word_AE76 = DE;
  $AEAF bell = 0;
  $AEB3 decrease_morale(10); // exit via

; ------------------------------------------------------------------------------

c $AEB8 searchlight
  $AEB8 EXX
  $AEB9 DE = &searchlight_shape[0];
  $AEBC C = 16; // iterations  / width?
  $AEBE do < EXX
  $AEBF A = searchlight_related;
  $AEC2 HL = 0x5A40; // screen attribute address (column 0 + bottom of game screen)
  $AEC5 if (A == 0) goto $AED2;
  $AEC9 A = E;
  $AECA if ((A & 31) < 22) goto $AED2;
  $AED0 L = 32;
;
  $AED2 SBC HL,DE // if (HL - DE - carry ...)
  $AED4 RET C
;
  $AED5 PUSH DE
  $AED6 HL = 0x5840; // screen attribute address (column 0 + top of game screen)
  $AED9 if (A == 0) goto $AEE6;
  $AEDD A = E & 31;
  $AEE0 if (A < 7) goto $AEE6;
  $AEE4 L = 32;
;
  $AEE6 SBC HL,DE
  $AEE8 JR C,$AEF0
;
  $AEEA EXX
  $AEEB DE += 2;
  $AEED EXX
  $AEEE goto nextrow;
;
  $AEF0 EX DE,HL
  $AEF1 EXX
  $AEF2 B = 2;
  $AEF4 do < A = *DE;
  $AEF5 EXX
  $AEF6 DE = 0x071E;
  $AEF9 C = A;
  $AEFA B = 8;
  $AEFC do < A = searchlight_related;
  $AEFF if (A != 0) ...
  $AF00 A = L; // interleaved
  $AF01 goto $AF0C;
;
  $AF04 if ((A & 31) >= 22) goto $AF1B;
;
  $AF0A goto $AF18;
;
  $AF0C if ((A & 31) < E) goto $AF18;
;
  $AF11 EXX
  $AF12 do < DE++; > while (--B);
;
  $AF15 EXX
  $AF16 goto nextrow;
;
  $AF18 if (A >= D) goto $AF1F;
;
  $AF1B RL C // looks like bit extraction ...
  $AF1D goto next;
;
  $AF1F RL C
  $AF21 JP NC, plot_dark
;
  $AF24 *HL = attribute_YELLOW_OVER_BLACK;
  $AF26 goto next;
;
  $AF28 plot_dark: *HL = attribute_BRIGHT_BLUE_OVER_BLACK;
;
  $AF2A next: HL++;
  $AF2B > while (--B);
;
  $AF2D EXX
  $AF2E DE++;
  $AF2F > while (--B);
;
  $AF31 EXX
;
  $AF32 nextrow: POP HL
  $AF33 HL += 32;
  $AF37 EX DE,HL
  $AF38 EXX
  $AF39 > while (--C);
;
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

; -----------------------------------------------------------------------------

b $AF8E bribe_related

; ------------------------------------------------------------------------------

c $AF8F sub_AF8F

; ------------------------------------------------------------------------------

c $AFDF sub_AFDF

; ------------------------------------------------------------------------------

b $B0F8 four_bytes_B0F8
D $B0F8 (<- sub_AFDF)

; ------------------------------------------------------------------------------

c $B0FC loc_B0FC

; ------------------------------------------------------------------------------

c $B107 use_bribe
D $B107 'he takes the bribe' 'and acts as decoy'
  $B107 increase_morale_by_10_score_by_50();
  $B10A IY[1] = 0;
  $B10E PUSH IY
  $B110 POP HL
  $B111 L += 2;
  $B113 CALL $CB23
  $B116 DE = &items_held[0];
  $B119 A = *DE;
  $B11A if (A == item_BRIBE) goto $B123;
  $B11E A = *++DE;
  $B120 if (A != item_BRIBE) return; // have no bribes

D $B123 We have a bribe.
  $B123 *DE = item_NONE;
  $B126 itemstruct_5.room = 0x3F;
  $B12B draw_all_items();
  $B12E B = 7; // 7 iterations
  $B130 HL = $8020; // visible characters
  $B133 do < A = *HL; // character index?
  $B134 if (A < 20) < // why 20?
  $B138 HL++;
  $B139 *HL = 4;
  $B13B HL--; >

  $B13C HL += 32;
  $B140 > while (--B);
  $B142 queue_message_for_display(message_HE_TAKES_THE_BRIBE);
  $B147 queue_message_for_display(message_AND_ACTS_AS_DECOY);
  $B149 return;

; ------------------------------------------------------------------------------

c $B14C sub_B14C
D $B14C Outdoor drawing?

; ------------------------------------------------------------------------------

c $B1C7 rotate_A_left_3_widening_to_BC
R $B1C7 A Argument.
R $B1C7 BC Result of (A << 3).
  $B1C7 result = 0;
  $B1C9 arg <<= 1;
  $B1CA result = (result << 1) + carry;
  $B1CC arg <<= 1;
  $B1CD result = (result << 1) + carry;
  $B1CF arg <<= 1;
  $B1D0 result = (result << 1) + carry;
  $B1D3 return;

; ------------------------------------------------------------------------------

c $B1D4 is_door_open
R $B1D4 O:F Z set if door open.
;
  $B1D4 E = 0x7F;
  $B1D6 C = current_door & E;
  $B1DB HL = &gates_and_doors[0];
  $B1DE B = 9; // 9 iterations
  $B1E0 do < if (*HL & E == C) {
  $B1E5 if ((*HL & (1<<7)) == 0) return; // unlocked
;
  $B1EA queue_message_for_display(message_THE_DOOR_IS_LOCKED);
  $B1ED A |= 1; // set NZ
  $B1EF return;

  $B1F0 } HL++;
  $B1F1 > while (--B);
  $B1F3 A &= B; // set Z (B is zero)
  $B1F4 return;

; ------------------------------------------------------------------------------

c $B1F5 door_handling

; ------------------------------------------------------------------------------

c $B252 sub_B252

; ------------------------------------------------------------------------------

c $B295 rotate_A_left_2_widening_to_BC
  $B295 BC = A << 2;
  $B29E return;

; ------------------------------------------------------------------------------

c $B29F sub_B29F
D $B29F This is doing something like checking the bounds for an interior room.
R $B29F O:AF Corrupted.
R $B29F O:BC Corrupted.
R $B29F O:HL Corrupted.
  $B29F BC = &four_byte_structures[first_byte_of_room_structure];
  $B2AC HL = &word_81A4;
  $B2AF A = *BC;
  $B2B0 if (A < *HL) goto $B2E7;
  $B2B3 A = *++BC + 4;
  $B2B7 if (A >= *HL) goto $B2E7;

  $B2BA HL += 2;
  $B2BC DE++; // Stray code? DE is incremented but not used.
  $B2BD A = *++BC - 4;
  $B2C1 if (A < *HL) goto $B2E7;
  $B2C4 A = *++BC;
  $B2C6 if (A >= *HL) goto $B2E7;

  $B2C9 HL = &byte_81BF[0];
  $B2CC B = *HL; // iterations
  $B2CE if (B == 0) return;

  $B2D0 HL++;
  $B2D1 do < PUSH BC
  $B2D2 PUSH HL
  $B2D3 DE = &word_81A4;
  $B2D6 B = 2; // 2 iterations
  $B2D8 do < A = *DE;
  $B2D9 if (A < HL[0] || A >= HL[1]) goto $B2F2; // next outer loop iteration (eg break)
  $B2E0 DE += 2;
  $B2E2 HL += 2; // increment moved - hope it's still correct
  $B2E3 > while (--B);

D $B2E5 Found.
  $B2E5 POP HL
  $B2E6 POP BC

  $B2E7 IY[7] ^= 0x20;
  $B2EF A |= 1;
  $B2F1 return; // return NZ

D $B2F2 Next iteration.
  $B2F2 POP HL
  $B2F3 HL += 4;
  $B2F7 POP BC
  $B2F8 > while (--B);

D $B2FA Not found.
  $B2FA A &= B; // B is zero here
  $B2FB return; // return Z

; ------------------------------------------------------------------------------

c $B2FC resetty

; ------------------------------------------------------------------------------

c $B32D indoors
D $B32D [unsure]

; -----------------------------------------------------------------------------

c $B387 action_red_cross_parcel
D $B387 Player has tried to open the red cross parcel.
  $B387 ...
  $B38C HL = &items_held;
  $B38F A = item_RED_CROSS_PARCEL;
  $B391 if (*HL != A) HL++;
  $B395 *HL = item_NONE; // no longer have parcel (we assume one slot or the other has it)
  $B397 draw_all_items();
  $B39A A = red_cross_parcel_current_contents;
  $B39D box_opening_maybe();
  $B3A0 queue_message_for_display(message_YOU_OPEN_THE_BOX);
  $B3A5 increase_morale_by_10_score_by_50(); return; // exit via

; -----------------------------------------------------------------------------

c $B3A8 action_bribe
D $B3A8 Player has tried to bribe a prisoner.
D $B3A8 I suspect this searches visible characters only.
  $B3A8 HL = $8020;
  $B3AB B = 7; // 7 iterations
  $B3AD do { A = *HL;
  $B3AE if ((A != 255) && (A >= 20)) goto found;
  $B3B6 HL += 32; // sizeof a character struct
  $B3BA } while (--B);
  $B3BC return;
  $B3BD found: bribe_related = A;
  $B3C0 L++;
  $B3C1 *HL = 1;
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
  $B3E1 HL = $8015;
  $B3E4 DE = sprite_guard_...;
  $B3E7 A = (HL);
  $B3E8 if (.. cheap equality test ..) return;
  $B3EA ...

; -----------------------------------------------------------------------------

c $B3F6 action_shovel
D $B3F6 Player has tried to use the shovel item.
  $B3F6 if (indoor_room_index != room_50_blocked_tunnel) return;
  $B3FC if (roomdefn_50_blockage == 255) return; // blockage already cleared
  $B402 roomdefn_50_blockage = 255;
  $B407 roomdefn_50_collapsed_tunnel_obj = 0; // remove blockage graphic
  $B40B select_room_maybe();
  $B40E choose_game_screen_attributes();
  $B411 plot_indoor_tiles();
  $B414 increase_morale_by_10_score_by_50(); return; // exit via

; -----------------------------------------------------------------------------

c $B417 action_wiresnips
  $B417 HL = wiresnips_related_table + 3;
  $B41A DE = player_map_position_perhapsY
  $B41D B = 4; // iterations
  $B41F do < ...
  $B420 A = (DE);
  $B421 if (A >= (HL)) goto continue;
  $B424 HL--;
  $B425 if (A < (HL)) goto continue;
  $B428 DE--; // player_map_position_perhapsX
  $B429 A = (DE);
  $B42A HL--;
  $B42B if (A == (HL)) goto set_to_4;
  $B42E A--;
  $B42F if (A == (HL)) goto set_to_6;
  $B432 DE++; // reset to Y
  $B433 continue: ...
  $B434 HL += 6; // array stride
  $B43B > while (--B);
;
  $B43D DE--; // player_map_position_perhapsX
  $B43E HL -= 3; // pointing to $B59E
  $B441 B = 3; // iterations
  $B443 do < ...
  $B444 A = (DE);
  $B445 if (A < (HL)) goto continue2;
  $B448 HL++;
  $B449 if (A >= (HL)) goto continue2;
  $B44C DE++;
  $B44D A = (DE);
  $B44E HL++;
  $B44F if (A == (HL)) goto set_to_5;
  $B452 A--;
  $B453 if (A == (HL)) goto set_to_7;
  $B456 DE--;
  $B457 continue2: ...
  $B458 HL += 6; // array stride
  $B45F > while (--B);
  $B461 return;
;
; i can see the first 7 entries in the table are used, but what about the remaining 5?
;
  $B466 set_to_4: A = 4; goto action_wiresnips_tail;
  $B466 set_to_5: A = 5; goto action_wiresnips_tail;
  $B46A set_to_6: A = 6; goto action_wiresnips_tail;
  $B46E set_to_7: A = 7;
  $B470 action_wiresnips_tail: ...
  $B471 $800E = A;
  $B475 $800D = 0x80;
  $B478 $8001 = 2;
  $B47D $8013 = 12; // set vertical offset
  $B482 $8015 = sprite_prisoner_tl_4;
  $B488 user_locked_out_until = game_counter + 96;
  $B490 queue_message_for_display(message_CUTTING_THE_WIRE);

; -----------------------------------------------------------------------------

c $B495 action_lockpick

; -----------------------------------------------------------------------------

c $B4AE action_red_key

; -----------------------------------------------------------------------------

c $B4B2 action_yellow_key

; -----------------------------------------------------------------------------

c $B4B6 action_green_key

; -----------------------------------------------------------------------------

c $B4B8 action_key

; -----------------------------------------------------------------------------

c $B4D0 open_door

; ------------------------------------------------------------------------------

b $B53E sixlong_things
D $B53E Probably boundaries.
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

b $B586 wiresnips_related_table
D $B586 Probably snippable places.
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

; -----------------------------------------------------------------------------

c $B71B reset_something

; -----------------------------------------------------------------------------

c $B75A looks_like_a_reset_function
D $B75A [unsure]
  $B75A ...
  $B789 $8015 = sprite_prisoner_tl_4;
  $B78F ...
  $B79A return;

; -----------------------------------------------------------------------------

c $B79B reset_map_and_characters
D $B79B [unsure]

; ------------------------------------------------------------------------------

b $B819 looks_like_character_reset_data
D $B819 10 x 3-byte structs
  $B819,30,3 ...

; ------------------------------------------------------------------------------

b $B837 byte_B837

; ------------------------------------------------------------------------------

b $B838 byte_B838

; ------------------------------------------------------------------------------

w $B839 word_B839

; -----------------------------------------------------------------------------

c $B83B resetty

; -----------------------------------------------------------------------------

c $B866 called_from_main_loop_11

; -----------------------------------------------------------------------------

c $B89C no_idea

; -----------------------------------------------------------------------------

c $B916 sub_B916
D $B916 Sets attr of something, checks indoor room index, ...

; -----------------------------------------------------------------------------

c $BADC sub_BADC

; -----------------------------------------------------------------------------

c $BAF7 ff_anded_with_ff

; -----------------------------------------------------------------------------

c $BB98 called_from_main_loop_3

; -----------------------------------------------------------------------------

c $BCAA sub_BCAA

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
D $C41A [unknown] (<- increment_word_C41A_low_byte_wrapping_at_15)

; -----------------------------------------------------------------------------

; seems to move characters around, or perhaps just spawn them

c $C41C called_from_main_loop_7
;
D $C41C Form a map position in DE.
  $C41C HL = map_position_maybe;
  $C41F E = (L < 8) ? 0 : L;
  $C426 D = (H < 8) ? 0 : H;
;
D $C42D Walk all character structs.
  $C42D HL = &character_structs[0];
  $C430 B = character_26_stove1; // the 26 'real' characters
  $C432 do < if (*HL & (1<<6)) goto skip; // unknown flag
;
  $C436 (stash HL)
  $C437 HL++; // $7613
  $C438 A = indoor_room_index;
  $C43B if (A != *HL) goto unstash_skip; // not in the visible room
  $C43E if (A != 0) goto done_outdoors;
;
D $C441 Outdoors.
  $C441 HL++; // $7614
  $C442 A -= *HL; // A always starts as zero here
  $C443 HL++; // $7615
  $C444 A -= *HL;
  $C445 HL++; // $7616
  $C446 A -= *HL;
  $C447 C = A;
  $C448 A = D;
  $C449 if (C <= A) goto unstash_skip; // check
  $C44C A += 32;
  $C44E if (A > 0xFF) A = 0xFF;
  $C452 if (C > A) goto unstash_skip; // check
;
  $C455 HL--; // $7615
  $C456 A = 64;
  $C458 *HL += A;
  $C459 HL--; // $7614
  $C45A *HL -= A;
  $C45B A *= 2; // A == 128
  $C45C C = A;
  $C45D A = E;
  $C45E if (C <= A) goto unstash_skip; // check
  $C461 A += 40;
  $C463 if (A > 0xFF) A = 0xFF;
  $C467 if (C > A) goto unstash_skip; // check
;
  $C46A done_outdoors: (unstash HL)
  $C46B (stash HL, DE, BC)
  $C46E sub_C4E0();
  $C471 (unstash BC, DE)
;
  $C473 unstash_skip: (unstash HL)
  $C474 skip: HL += 7; // stride
  $C47B > while (--B);
  $C47D return;

; -----------------------------------------------------------------------------

c $C47E called_from_main_loop_6

; -----------------------------------------------------------------------------

c $C4E0 sub_C4E0

; -----------------------------------------------------------------------------

c $C5D3 reset_object

; -----------------------------------------------------------------------------

c $C651 sub_C651

; -----------------------------------------------------------------------------

c $C6A0 move_characters
;
  $C6A0 byte_A13E = 0xFF;
  $C6A5 A = character_index;
  $C6A8 A++;
  $C6A9 if (A == 26) A = 0;
  $C6AE character_index = A;
  $C6B1 get_character_struct();
  $C6B4 if (*HL & (1<<6)) return;
  $C6B7 PUSH HL
  $C6B8 HL++;
  $C6B9 A = *HL;
  $C6BA if (A == 0) goto $C6C5;
  $C6BD sub_CCFB();
  $C6C0 if (Z) item_discovered();
;
  $C6C5 POP HL
  $C6C6 HL += 2;
  $C6C8 PUSH HL
  $C6C9 HL += 3;
  $C6CC A = *HL;
  $C6CD if (A != 0) goto $C6D2;
  $C6D0 POP HL
  $C6D1 return;
;
  $C6D2 sub_C651();
  $C6D5 if (A != 0xFF) goto $C6FF;
  $C6DA A = character_index;
  $C6DD if (A == character_0) goto char_is_zero;
  $C6E0 if (A >= character_12_prisoner) goto char_ge_12;
;
  $C6E4 *HL++ ^= 0x80;
  $C6E9 if ((A & 7) != 0) (*HL) -= 2;
;
  $C6EF (*HL)++; // weird // i.e -1 or +1
  $C6F0 POP HL
  $C6F1 return;
;
  $C6F2 char_is_zero: A = *HL & 127; // fetching a character index?
  $C6F5 if (A != 36) goto $C6E4;
;
  $C6F9 char_ge_12: POP DE        ;
  $C6FA goto character_event; // exit via
;
U $C6FD,2 DEFB $18,$6F  ; UNUSED?
;
  $C6FF if (A != 128) goto $C76E;
  $C704 POP DE
  $C705 A = DE[-1];
  $C708 PUSH HL
  $C709 if (A != 0) got $C71F;
  $C70D PUSH DE
  $C70E DE = &word_81A4;
  $C711 B = 2; // 2 iters
  $C713 do < A = *HL;
  $C714 AND A         ; don't understand
  $C715 RRA           ; rotate right out into carry
  $C716 *DE = A;
  $C717 HL++;
  $C718 DE++;
  $C719 > while (--B);
  $C71B HL = &word_81A4;
  $C71E POP DE
;
  $C71F A = DE[-1];
  $C722 AND A         ; if (A == 0) .. next op interleaved ..
  $C723 A = 2;
  $C725 JR Z,$C729    ; if (A == 0) goto $C729;
  $C727 A = 6;
;
  $C729 EX AF,AF'     ;
  $C72A B = 0;
  $C72C sub_C79A();
  $C72F DE++;
  $C730 HL++;
  $C731 sub_C79A();
  $C734 POP HL        ;
  $C735 A = B;
  $C736 if (A != 2) return;
;
  $C739 DE -= 2;
  $C73B HL--;
  $C73C A = *HL & 0xFC;
  $C73F RRA           ;
  $C740 RRA           ;
  $C741 *DE = A;
  $C742 A = *HL & 3;
  $C745 if (A >= 2) goto $C750;
  $C749 HL += 5;
  $C74E JR $C753      ;
;
  $C750 HL -= 3;
;
  $C753 A = *DE++;
  $C755 if (A == 0) goto $C761;
  $C758 LDI           ;
  $C75A LDI           ;
  $C75C LDI           ;
  $C75E DE--;
  $C75F JR $C78B      ;
;
  $C761 B = 3;
  $C763 do < A = *HL;
  $C764 AND A         ;
  $C765 RRA           ;
  $C766 *DE = A;
  $C767 HL++;
  $C768 DE++;
  $C769 > while (--B);
  $C76B DE--;
  $C76C JR $C78B      ;
;
  $C76E POP DE        ;
  $C76F A = DE[-1];
  $C772 AND A         ;
  $C773 A = 2;      // interleaving again
  $C775 JR Z,$C779    ;
  $C777 A = 6;
;
  $C779 EX AF,AF'     ;
  $C77A B = 0;
  $C77C sub_C79A();
  $C77F HL++;
  $C780 DE++;
  $C781 sub_C79A();
  $C784 DE++;
  $C785 A = B;
  $C786 if (A != 2) return;
;
  $C78B DE++;
  $C78C EX DE,HL      ;
  $C78D A = *HL;
  $C78E if (A == 0xFF) return;
;
  $C791 if (A & (1<<7))
  $C793 HL++;       // interleaved
  $C794 JR NZ,exit
  $C796 (*HL)++;
  $C797 return;
;
  $C798 exit: (*HL)--;
  $C799 return;

; -----------------------------------------------------------------------------

c $C79A sub_C79A
D $C79A [leaf] (<- move_characters)
R $C79A I:B  ?
R $C79A I:DE Pointer to ?
R $C79A I:HL Pointer to ?
R $C79A O:B  ?
;
  $C79A (stash AF)
  $C79B C = A; // ie. banked A
  $C79C (unstash AF)
  $C79D A = *DE - *HL;
  $C79F if (A == 0) {
  $C7A1 B++;
  $C7A2 return; }
;
  $C7A3 if (A < 0) {
  $C7A5 A = -A;
  $C7A7 if (A >= C) A = C;
  $C7AB *DE += A;
  $C7AF return; }
;
  $C7B0 if (A >= C) A = C;
  $C7B4 *DE -= A;
  $C7B8 return;

; -----------------------------------------------------------------------------

c $C7B9 get_character_struct
R $C7B9 I:A Character index.
  $C7B9 HL = &character_structs[A];
  $C7C5 return;

; ------------------------------------------------------------------------------

; Character events and handlers.
;
c $C7C6 character_event
D $C7C6 Makes characters sit, sleep or other things TBD.
R $C7C6 I:HL Points to a byte holding character index (e.g. 0x76C6).
  $C7C6 A = *HL;
  $C7C7 if (A >= character_7_prisoner && A <= character_12_prisoner) goto character_sleeps;
  $C7D0 if (A >= character_18_prisoner && A <= character_22_prisoner) goto character_sits;
;
  $C7D9 PUSH HL
  $C7DA HL = character_to_event_handler_index_map;
  $C7DD B = 24; // 24 iterations
D $C7DF Locate the character in the map.
  $C7DF do < if (A == *HL) goto call_action;
  $C7E2 HL += 2;
  $C7E4 > while (--B);
  $C7E6 POP HL
  $C7E7 *HL = 0; // no action
  $C7E9 return;

  $C7EA call_action: goto character_event_handlers[*++HL];

D $C7F9 character_to_event_handler_index_map
D $C7F9 Array of (character, character event handler index) mappings. (Some of the character indexes look too high though).
W $C7F9 < 0xA6,  0 >,
W $C7FB < 0xA7,  0 >,
W $C7FD < 0xA8,  1 >,
W $C7FF < 0xA9,  1 >,
W $C801 < 0x05,  0 >,
W $C803 < 0x06,  1 >,
W $C805 < 0x85,  3 >,
W $C807 < 0x86,  3 >,
W $C809 < 0x0E,  2 >,
W $C80B < 0x0F,  2 >,
W $C80D < 0x8E,  0 >,
W $C80F < 0x8F,  1 >,
W $C811 < 0x10,  5 >,
W $C813 < 0x11,  5 >,
W $C815 < 0x90,  0 >,
W $C817 < 0x91,  1 >,
W $C819 < 0xA0,  0 >,
W $C81B < 0xA1,  1 >,
W $C81D < 0x2A,  7 >,
W $C81F < 0x2C,  8 >,   // sleeps
W $C821 < 0x2B,  9 >,   // sits
W $C823 < 0xA4,  6 >,
W $C825 < 0x24, 10 >,
W $C827 < 0x25,  4 >,   // morale related

D $C829 character_event_handlers
D $C829 Array of pointers to character event handlers.
W $C829 < &charevnt_pop_hl_and_write_08FF_to_it,
W $C82B &charevnt_pop_hl_and_write_10FF_to_it,
W $C82D &charevnt_pop_hl_and_write_38FF_to_it,
W $C82F &charevnt_pop_hl_and_check_varA13E,
W $C831 &charevnt_zero_morale_related,
W $C833 &charevnt_pop_hl_and_check_varA13E_anotherone,
W $C835 &charevnt_C845,
W $C837 &charevnt_pop_hl_and_write_0005_to_it,
W $C839 &charevnt_pop_hl_and_player_sleeps,
W $C83B &charevnt_pop_hl_and_player_sits,
W $C83D &charevnt_C84C, >

D $C83F charevnt_zero_morale_related
  $C83F morale_related = 0;
  $C843 goto charevnt_pop_hl_and_write_08FF_to_it;

D $C845 charevnt_C845
  $C845 POP HL
  $C846 *HL++ = 0x03;
  $C849 *HL   = 0x15;
  $C84B return;

D $C84C charevnt_C84C
  $C84C POP HL
  $C84D *HL++ = 0xA4;
  $C850 *HL   = 0x03;
  $C852 morale_related_also = 0;
  $C856 set_target_location(0x2500); return;

D $C85C charevnt_pop_hl_and_write_10FF_to_it
  $C85C C = 0x10;
  $C85E goto exit;

D $C860 charevnt_pop_hl_and_write_38FF_to_it
  $C860 C = 0x38;
  $C862 goto exit;

D $C864 charevnt_pop_hl_and_write_08FF_to_it
  $C864 C = 0x08;
  $C866 exit: POP HL
  $C867 *HL++ = 0xFF;
  $C86A *HL   = C;
  $C86B return;

D $C86C charevnt_pop_hl_and_check_varA13E
  $C86C POP HL
  $C86D if (byte_A13E == 0) goto varA13E_is_zero; else goto sub_A3F3;

D $C877 charevnt_pop_hl_and_check_varA13E_anotherone
  $C877 POP HL
  $C878 if (byte_A13E == 0) goto varA13E_is_zero_anotherone; else goto sub_A4D3;

D $C882 charevnt_pop_hl_and_write_0005_to_it
  $C882 POP HL
  $C883 *HL++ = 0x05;
  $C886 *HL   = 0x00;
  $C888 return;

D $C889 charevnt_pop_hl_and_player_sits
  $C889 POP HL
  $C88A goto player_sits;

D $C88D charevnt_pop_hl_and_player_sleeps
  $C88D POP HL
  $C88E goto player_sleeps;

; ------------------------------------------------------------------------------

b $C891 byte_C891
D $C891 (<- called_from_main_loop_5, sub_CA81)

; ------------------------------------------------------------------------------

c $C892 called_from_main_loop_5
C $C892 Clear byte_A13E.
C $C896 if (bell) sub_CCAB();
C $C89D if (byte_C891 == 0) goto loc_C8B1;
C $C8A4 if (--byte_C891 == 0) goto loc_C8B1;
C $C8A7 (wipe a flag bit in character data?)
C $C8AA (something gets discovered)
C $C8B1 ...

; ------------------------------------------------------------------------------

c $C918 sub_C918

; ------------------------------------------------------------------------------

c $CA11 sub_CA11

; ------------------------------------------------------------------------------

c $CA49 sub_CA49

; ------------------------------------------------------------------------------

c $CA81 sub_CA81
D $CA81 Bribes, solitary, food, 'character enters' sound.

; ------------------------------------------------------------------------------

U $CB5F unused_CB5F
D $CB5F,2 Unreferenced bytes.

; ------------------------------------------------------------------------------

c $CB75 ld_bc_a

; ------------------------------------------------------------------------------

c $CB79 element_A_of_table_7738

; ------------------------------------------------------------------------------

c $CB85 increment_word_C41A_low_byte_wrapping_at_15

; ------------------------------------------------------------------------------

u $CB92 unused_CB92
D $CB92 Likely unreferenced bytes.

; ------------------------------------------------------------------------------

c $CB98 solitary
  $CC16 ...
  $CC19 $8015 = sprite_prisoner_tl_4;
  $CC1F ...

; ------------------------------------------------------------------------------

b $CC31 reset_data
D $CC31 (<- solitary)

; ------------------------------------------------------------------------------

c $CC37 guards_follow_suspicious_player
  $CC37 ...
  $CC3E if (*$8015 == sprite_guard_tl_4) return;  // don't follow the player if he's dressed as a guard
  $CC46 ...

; ------------------------------------------------------------------------------

c $CCAB sub_CCAB
D $CCAB Searches for a visible character and something else, sets a flag.
D $CCAB If I nop this out then guards don't spot the items I drop.
  $CCAB HL = $8020;
  $CCB1 B = 7; // iterations
  $CCB3 do <
  $CCB4 if (HL[0] < character_20_prisoner && HL[19] < 0x20) HL[1] = 1; // set the flag [player taken to solitary]
  $CCC9 HL += 32; // step to next element
  $CCCA > while (--B);
  $CCCC return;

; ------------------------------------------------------------------------------

c $CCCD sub_CCCD
D $CCCD Walks item_characterstructs.
D $CCCD This ignores green key and food items. May decide which items are 'found'.
;
  $CCCD A = indoor_room_index;
  $CCD0 if (A == 0) goto outside;
  $CCD3 sub_CCFB();
  $CCD6 if (nonzero) return;
  $CCD7 sub_CCAB();
  $CCDA return;
;
  $CCDB outside: HL = item_structs + 1;
  $CCDE DE = 7; // stride
  $CCE1 B = 16;
  $CCE3 do < if (*HL & (1<<7)) goto check; // flag means what?
  $CCE7 next: HL += DE;
  $CCE8 > while (--B);
  $CCEA return;
;
  $CCEB check: HL--;
  $CCEC A = *HL & 0x0F;
  $CCEF if (A == item_GREEN_KEY) goto next;
  $CCF3 if (A == item_FOOD) goto next;
  $CCF7 sub_CCAB();
  $CCFA return;

; ------------------------------------------------------------------------------

c $CCFB sub_CCFB
D $CCFB Walks item_structs.
D $CCFB This ignores red cross parcel. May decide which items are 'found'.
R $CCFB I:A Room ref.
R $CCFB O:A ?
R $CCFB O:C ?
;
  $CCFB C = A; // room ref
  $CCFC HL = item_structs + 1; // pointer to room ref
  $CCFF B = 16; // nitems
  $CD01 do < A = *HL & 63; // mask off flags [unsure, it's a bit suspect]
  $CD04 if (A != C) goto skip; // check
  $CD07 PUSH HL
  $CD08 HL = &item_location[HL[-1] & 15]; // HL[-1] is item index [again, unsure why it's masked off]
  $CD16 A = *HL; // room_and_flags
  $CD17 if (A != C) goto rooms_dont_match; // item in wrong room?
  $CD1A POP HL
  $CD1B skip: HL += 7; // stride
  $CD1F > while (--B);
  $CD21 return; // return with NZ?
;
  $CD22 rooms_dont_match: POP HL
  $CD23 HL--; // point to item
  $CD24 A = *HL & 0x0F; // does this always need masking? are there flags?
  $CD27 if (A != item_RED_CROSS_PARCEL) goto exit;
  $CD2B HL++;
  $CD2C goto skip;
;
  $CD2E exit: C = A;
  $CD2F A = 0; // set Z
  $CD30 return;

; ------------------------------------------------------------------------------

c $CD31 item_discovered

; ------------------------------------------------------------------------------

b $CD6A item_location
D $CD6A Array of 16 three-byte structures.
D $CD6A struct item_location { byte room_and_flags; byte y; byte x; };
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
  $CD8B item_GREEN_KEY        { ITEM_ROOM(room_0, 0), ... }
  $CD8E item_RED_CROSS_PARCEL { ITEM_ROOM(room_NONE, 0), ... }
  $CD91 item_RADIO            { ITEM_ROOM(room_18, 0), ... }
  $CD94 item_PURSE            { ITEM_ROOM(room_NONE, 0), ... }
  $CD97 item_COMPASS          { ITEM_ROOM(room_NONE, 0), ... }

; ------------------------------------------------------------------------------

b $CD9A character_meta_data
  $CD9A struct ... { something_character_related, sprite_commandant_tl_4 } meta_commandant; (<- sub_C4E0)
  $CD9E struct ... { something_character_related, sprite_guard_tl_4 }      meta_guard;      (<- sub_C4E0)
  $CDA2 struct ... { something_character_related, sprite_dog_tl_4 }        meta_dog;        (<- sub_C4E0)
  $CDA6 struct ... { something_character_related, sprite_prisoner_tl_4 }   meta_prisoner;   (<- sub_C4E0)

; ------------------------------------------------------------------------------

b $CDAA byte_CDAA
D $CDAA (<- called_from_main_loop_9)

; ------------------------------------------------------------------------------

w $CDF2 something_character_related
D $CDF2 Array, 24 long, of pointers to data.
  $CDF2 byte_CF26
  $CDF4 byte_CF3A
  $CDF6 byte_CF4E
  $CDF8 byte_CF62
  $CDFA byte_CF96
  $CDFC byte_CFA2
  $CDFE byte_CFAE
  $CE00 byte_CFBA
  $CE02 byte_CF76
  $CE04 byte_CF7E
  $CE06 byte_CF86
  $CE08 byte_CF8E
  $CE0A byte_CFC6
  $CE0C byte_CFD2
  $CE0E byte_CFDE
  $CE10 byte_CFEA
  $CE12 byte_CFF6
  $CE14 byte_D002
  $CE16 byte_D00E
  $CE18 byte_D01A
  $CE1A byte_CF06
  $CE1C byte_CF0E
  $CE1E byte_CF16
  $CE20 byte_CF1E

; ------------------------------------------------------------------------------

b $CE22 sprites
D $CE22 Objects which can move.
D $CE22 This include STOVE, CRATE, PRISONER, CRAWL, DOG, GUARD and COMMANDANT.
D $CE22 Structure: (b) width in bytes + 1, (b) height in rows, (w) data ptr, (w) mask ptr
D $CE22 'tl' => character faces top left of the screen
D $CE22 'br' => character faces bottom right of the screen
  $CE22 sprite_stove           (16x22)
  $CE28 sprite_crate           (24x24)
  $CE2E sprite_prisoner_tl_4   (16x27)
  $CE34 sprite_prisoner_tl_3   (16x28)
  $CE3A sprite_prisoner_tl_2   (16x28)
  $CE40 sprite_prisoner_tl_1   (16x28)
  $CE46 sprite_prisoner_br_1   (16x27)
  $CE4C sprite_prisoner_br_2   (16x29)
  $CE52 sprite_prisoner_br_3   (16x28)
  $CE58 sprite_prisoner_br_4   (16x28)
  $CE5E sprite_crawl_bl_2      (24x16)
  $CE64 sprite_crawl_bl_1      (24x15)
  $CE6A sprite_crawl_tl_1      (24x16)
  $CE70 sprite_crawl_tl_2      (24x16)
  $CE76 sprite_dog_tl_4        (24x16)
  $CE7C sprite_dog_tl_3        (24x16)
  $CE82 sprite_dog_tl_2        (24x15)
  $CE88 sprite_dog_tl_1        (24x15)
  $CE8E sprite_dog_br_1        (24x14)
  $CE94 sprite_dog_br_2        (24x15)
  $CE9A sprite_dog_br_3        (24x15)
  $CEA0 sprite_dog_br_4        (24x14)
  $CEA6 sprite_guard_tl_4      (16x27)
  $CEAC sprite_guard_tl_3      (16x29)
  $CEB2 sprite_guard_tl_2      (16x27)
  $CEB8 sprite_guard_tl_1      (16x27)
  $CEBE sprite_guard_br_1      (16x29)
  $CEC4 sprite_guard_br_2      (16x29)
  $CECA sprite_guard_br_3      (16x28)
  $CED0 sprite_guard_br_4      (16x28)
  $CED6 sprite_commandant_tl_4 (16x28)
  $CEDC sprite_commandant_tl_3 (16x30)
  $CEE2 sprite_commandant_tl_2 (16x29)
  $CEE8 sprite_commandant_tl_1 (16x29)
  $CEEE sprite_commandant_br_1 (16x27)
  $CEF4 sprite_commandant_br_2 (16x28)
  $CEFA sprite_commandant_br_3 (16x27)
  $CF00 sprite_commandant_br_4 (16x28)

; ------------------------------------------------------------------------------

b $CF06 character_related_stuff
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
D $D026 #UDGTABLE { #UDGARRAY2,7,4,2;$D026-$D05F-1-16{0,0,64,116}(commandant-top-left-1) | #UDGARRAY2,7,4,2;$D060-$D099-1-16{0,0,64,116}(commandant-top-left-2) | #UDGARRAY2,7,4,2;$D09A-$D0D5-1-16{0,0,64,116}(commandant-top-left-3) | #UDGARRAY2,7,4,2;$D0D6-$D10E-1-16{0,0,64,112}(commandant-top-left-4) } TABLE#
D $D026 Masks need inverting: #UDGARRAY2,7,4,2;$D026-$D05F-1-16:$D485-$D4C4-1-16{0,0,64,116}(commandant-top-left-1masked)
B $D026 bitmap: COMMANDANT FACING TOP LEFT 1
B $D060 bitmap: COMMANDANT FACING TOP LEFT 2
B $D09A bitmap: COMMANDANT FACING TOP LEFT 3
B $D0D6 bitmap: COMMANDANT FACING TOP LEFT 4
;
D $D10E #UDGTABLE { #UDGARRAY2,7,4,2;$D10E-$D143-1-16{0,0,64,108}(commandant-bottom-right-1) | #UDGARRAY2,7,4,2;$D144-$D17B-1-16{0,0,64,112}(commandant-bottom-right-2) | #UDGARRAY2,7,4,2;$D17C-$D1B1-1-16{0,0,64,108}(commandant-bottom-right-3) | #UDGARRAY2,7,4,2;$D1B2-$D1E9-1-16{0,0,64,112}(commandant-bottom-right-4) } TABLE#
B $D10E bitmap: COMMANDANT FACING BOTTOM RIGHT 1
B $D144 bitmap: COMMANDANT FACING BOTTOM RIGHT 2
B $D17C bitmap: COMMANDANT FACING BOTTOM RIGHT 3
B $D1B2 bitmap: COMMANDANT FACING BOTTOM RIGHT 4
;
D $D1EA #UDGTABLE { #UDGARRAY2,7,4,2;$D1EA-$D21F-1-16{0,0,64,108}(prisoner-top-left-1) | #UDGARRAY2,7,4,2;$D220-$D255-1-16{0,0,64,108}(prisoner-top-left-2) | #UDGARRAY2,7,4,2;$D256-$D28B-1-16{0,0,64,108}(prisoner-top-left-3) | #UDGARRAY2,7,4,2;$D28C-$D2BF-1-16{0,0,64,104}(prisoner-top-left-4) } TABLE#
B $D1EA bitmap: PRISONER FACING TOP LEFT 1
B $D220 bitmap: PRISONER FACING TOP LEFT 2
B $D256 bitmap: PRISONER FACING TOP LEFT 3
B $D28C bitmap: PRISONER FACING TOP LEFT 4
;
D $D2C0 #UDGTABLE { #UDGARRAY2,7,4,2;$D2C0-$D2F3-1-16{0,0,64,104}(prisoner-bottom-right-1) | #UDGARRAY2,7,4,2;$D2F4-$D32B-1-16{0,0,64,112}(prisoner-bottom-right-2) | #UDGARRAY2,7,4,2;$D32C-$D361-1-16{0,0,64,108}(prisoner-bottom-right-3) | #UDGARRAY2,7,4,2;$D362-$D397-1-16{0,0,64,108}(prisoner-bottom-right-4) } TABLE#
B $D2C0 bitmap: PRISONER FACING BOTTOM RIGHT 1
B $D2F4 bitmap: PRISONER FACING BOTTOM RIGHT 2
B $D32C bitmap: PRISONER FACING BOTTOM RIGHT 3
B $D362 bitmap: PRISONER FACING BOTTOM RIGHT 4
;
D $D398 #UDGARRAY3,7,4,3;$D398-$D3C4-1-24{0,0,96,64}(crawl-bottom-left-1)
D $D3C5 #UDGARRAY3,7,4,3;$D3C5-$D3F4-1-24{0,0,96,60}(crawl-bottom-left-2)
D $D3F5 #UDGARRAY3,7,4,3;$D3F5-$D424-1-24{0,0,96,64}(crawl-top-left-1)
D $D425 #UDGARRAY3,7,4,3;$D425-$D454-1-24{0,0,96,64}(crawl-top-left-2)
D $D455 #UDGARRAY3,7,4,3;$D455-$D484-1-24{0,0,96,64}(crawl-mask-top-left-shared)
B $D398 bitmap: CRAWL FACING BOTTOM LEFT 1
B $D3C5 bitmap: CRAWL FACING BOTTOM LEFT 2
B $D3F5 bitmap: CRAWL FACING TOP LEFT 1
B $D425 bitmap: CRAWL FACING TOP LEFT 2
B $D455 mask: CRAWL FACING TOP LEFT (shared)
;
B $D485 mask: COMMANDANT FACING TOP LEFT 1
B $D4C5 mask: COMMANDANT FACING TOP LEFT 2
B $D505 mask: COMMANDANT FACING TOP LEFT 3
B $D545 mask: COMMANDANT FACING TOP LEFT 4
;
B $D585 mask: COMMANDANT FACING BOTTOM RIGHT 1
B $D5C5 mask: COMMANDANT FACING BOTTOM RIGHT 2
B $D605 mask: COMMANDANT FACING BOTTOM RIGHT 3
B $D63D mask: COMMANDANT FACING BOTTOM RIGHT 4
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
B $D867 bitmap: DOG FACING TOP LEFT 4
B $D897 bitmap: DOG FACING TOP LEFT 3
B $D8C7 bitmap: DOG FACING TOP LEFT 2
B $D8F4 bitmap: DOG FACING TOP LEFT 1
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

; ------------------------------------------------------------------------------

c $DB9E called_from_main_loop_8

; ------------------------------------------------------------------------------

c $DBEB sub_DBEB
c $DBEB Uses rotate_A_left_3_widening_to_BC.

; ------------------------------------------------------------------------------

c $DC41 sub_DC41

; ------------------------------------------------------------------------------

c $DD02 sub_DD02

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
  $DD83 { 2, 13, shovel_data, shovel_key_mask },
  $DD89 { 2, 16, lockpick_data, lockpick_mask },
  $DD8F { 2, 15, papers_data, papers_mask },
  $DD95 { 2, 12, torch_data, torch_mask },
  $DD9B { 2, 13, bribe_data, bribe_mask },
  $DDA1 { 2, 16, uniform_data, uniform_mask },
  $DDA7 { 2, 16, food_data, food_mask },
  $DDAD { 2, 16, poison_data, poison_mask },
  $DDB3 { 2, 13, key_data, shovel_key_mask },
  $DDB9 { 2, 13, key_data, shovel_key_mask },
  $DDBF { 2, 13, key_data, shovel_key_mask },
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
D $E0D7 Likely unreferenced byte.

; ------------------------------------------------------------------------------

; something plotter ish
w $E0E0 pairs_of_offsets
D $E0E0 (<- sub_DC41, sub_E420)
  $E0E0 jump0
  $E0E2 jump1
  $E0E4 jump2
  $E0E6 jump3
  $E0E8 jump4
  $E0EA jump5

; ------------------------------------------------------------------------------

w $E0EC pairs_of_offsets_2
D $E0EC (<- sub_E420)
  $E0EC
  $E0EE
  $E0F0
  $E0F2
  $E0F4
  $E0F6
  $E0F8
  $E0FA
  $E0FC
  $E0FE Pointer to masked sprite plotter.

; ------------------------------------------------------------------------------

u $E100 unused_E100
D $E100 Unsure if related to the above pairs_of_offsets2 table.

; ------------------------------------------------------------------------------

c $E102 masked_sprite_plotter
D $E102 [unsure]

; ------------------------------------------------------------------------------

c $E29F sub_E29F

; ------------------------------------------------------------------------------

c $E2A2 sub_E2A2

; ------------------------------------------------------------------------------

c $E34E sub_E34E

; ------------------------------------------------------------------------------

c $E3FA sub_E3FA
D $E3FA [leaf]

; ------------------------------------------------------------------------------

c $E40F sub_E40F
D $E40F [leaf]

; ------------------------------------------------------------------------------

c $E420 sub_E420

; ------------------------------------------------------------------------------

c $E542 sub_E542

; ------------------------------------------------------------------------------

c $E550 rotate_AC_right_3_with_prologue
C $E555 rotate_AC_right_3

; ------------------------------------------------------------------------------

c $E542 divide_3xAC_by_8_with_rounding
D $E542 Divides 3 words by 8 with rounding to nearest.
R $E542 I:HL Pointer to input words
R $E542 I:DE Pointer to output bytes
  $E542 B = 3;
  $E544 do < A = *HL++;
  $E546 C = *HL++;
  $E547 divide_AC_by_8_with_rounding();
  $E54A *DE++ = A;
  $E54D > while (--B);
  $E54F return;

; ------------------------------------------------------------------------------

c $E550 divide_AC_by_8_with_rounding
D $E550 Divides AC by 8, with rounding to nearest.
R $E550 I:A Low
R $E550 I:C High
  $E550 A += 4;
  $E552 if (carry) C++;
;
C $E555 divide_AC_by_8
  $E555 A = (A >> 3) | (C << 5); C >>= 3;
  $E55E return;

; ------------------------------------------------------------------------------

b $E55F probably_mask_data
  $E55F probably masks
  $E5FF probably masks
  $E61E probably masks
  $E6CA probably masks
  $E74B probably masks
  $E758 probably masks
  $E77F probably masks
  $E796 probably masks
  $E7AF probably masks
  $E85C probably masks
  $E8A3 probably masks
  $E8F0 probably masks
  $E92F probably masks
  $E940 probably masks
  $E972 probably masks
  $E99A probably masks
  $E99F probably masks
  $E9B9 probably masks
  $E9C6 probably masks
  $E9CB probably masks
  $E9E6 probably masks
  $E9F5 probably masks
  $EA0E probably masks
  $EA2B probably masks
  $EA35 probably masks
  $EA43 probably masks
  $EA4A probably masks
  $EA53 probably masks
  $EA5D probably masks
  $EA67 probably masks

; ------------------------------------------------------------------------------

b $EA7C stru_EA7C
D $EA7C 47x 7-byte structs.
  $EA7C,329,7 Elements.

; ------------------------------------------------------------------------------

w $EBC5 table_of_pointers_30_long
D $EBC5 Table of pointers, 30 long, to byte arrays [unsure]  -- probably masks
  $EBC5 -> $E55F
  $EBC7 -> $E5FF
  $EBC9 -> $E61E
  $EBCB -> $E6CA
  $EBCD -> $E74B
  $EBCF -> $E758
  $EBD1 -> $E77F
  $EBD3 -> $E796
  $EBD5 -> $E7AF
  $EBD7 -> $E85C
  $EBD9 -> $E8A3
  $EBDB -> $E8F0
  $EBDD -> $E940
  $EBDF -> $E972
  $EBE1 -> $E92F
  $EBE3 -> $EA67
  $EBE5 -> $EA53
  $EBE7 -> $EA5D
  $EBE9 -> $E99A
  $EBEB -> $E99F
  $EBED -> $E9B9
  $EBEF -> $E9C6
  $EBF1 -> $E9CB
  $EBF3 -> $E9E6
  $EBF5 -> $E9F5
  $EBF7 -> $EA0E
  $EBF9 -> $EA2B
  $EBFB -> $EA35
  $EBFD -> $EA43
  $EBFF -> $EA4A

; ------------------------------------------------------------------------------

b $EC01 stru_EC01
D $EC01 58x 8-byte structs.

; ------------------------------------------------------------------------------

w $EDD1 saved_sp

; ------------------------------------------------------------------------------

w $EDD3 game_screen_scanline_start_addresses

; ------------------------------------------------------------------------------

c $EED3 plot_game_screen

; ------------------------------------------------------------------------------

c $EF9A event_roll_call

; ------------------------------------------------------------------------------

; HOLY SMOKES!
; If you 'use' papers while wearing the uniform by the main gate you can leave
; the camp!
; I NEVER KNEW THAT!

c $EFCB action_papers
  $EFCB [range checking business x in (0x69..0x6D) and y in (0x49..0x4B)]
  $EFDE if (*$8015 != sprite_guard_tl_4) goto solitary; // using the papers at the main gate when not in uniform => get sent to solitary
  $EFE8 increase_morale_by_10_score_by_50
  $EFEB $801C = 0; // clear stored room index?
  $EFEF ... must be a transition to outside the gate ...
W $EFF9 word_EFF9 (<- action_papers)

; ------------------------------------------------------------------------------

u $EFFB unused_EFFB
D $EFFB Likely unreferenced byte.

; ------------------------------------------------------------------------------

c $EFFC user_confirm
;
  $EFFC HL = screenlocstring_confirm_y_or_n;
  $EFFF screenlocstring_plot();
;
  $F002 for (;;) < BC = port_KEYBOARD_POIUY;
  $F005 IN A,(C)
  $F007 if ((A & (1<<4)) == 0) return; // is 'Y' pressed? return Z
;
  $F00A BC = port_KEYBOARD_SPACESYMSHFTMNB;
  $F00C IN A,(C)
  $F00E A = ~A;
  $F00F if ((A & (1<<3)) != 0) return; // is 'N' pressed? return NZ
;
  $F012 >

; ------------------------------------------------------------------------------

b $F014 menu_screenlocstrings
D $F014 Menu screenlocstrings.
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

b $F075 counter_of_something

; ------------------------------------------------------------------------------

b $F076 tile_refs_for_statics
  $F076 statics_flagpole (struct: w(addr),flags+length,attrs[length])
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
  $F163 Disable interrupts and set up stack pointer.
  $F167 wipe_full_screen_and_attributes();
  $F16A set_morale_flag_screen_attributes(attribute_BRIGHT_GREEN_OVER_BLACK);
  $F16F set_menu_item_attributes(attribute_YELLOW_OVER_BLACK);
  $F174 plot_menu_text();
  $F177 plot_score();
  $F17A menu_screen();
  $F17D [unknown]
  $F1C3 looks_like_a_reset_fn();
  $F1C6 goto main_loop_setup;

; ------------------------------------------------------------------------------

b $F1C9 twenty_three_bytes
D $F1C9 main copies this somewhere

; ------------------------------------------------------------------------------

c $F1E0 plot_menu_text

; ------------------------------------------------------------------------------

c $F206 counter_set_0
D $F206 Suspect this plots static screen tiles.
R $F206 I:HL Pointer to tile indices?
;
  $F206 A = 0;
  $F207 goto $F20B;
; This entry point is used by the routine at #R$F1E0.
  $F209 A = 255;
;
  $F20B counter_of_something = A;
  $F20E A = *HL & 0x7F;
  $F211 B = A; // loop iterations
  $F212 HL++;
  $F213 PUSH DE
  $F214 EXX
  $F215 POP DE
  $F216 EXX
  $F217 do < A = *HL;
  $F218 EXX
  $F219 HL = &static_tiles[A]; // elements: 9 bytes each
  $F227 B = 8; // 8 iterations
;
D $F229 Plot a tile.
  $F229 do < A = *HL;
  $F22A *DE = A;
  $F22B DE += 256;
  $F22C HL++;
  $F22D > while (--B);
  $F22F DE -= 256;
  $F230 PUSH DE
;
D $F231 Calculate screen attribute address of tile.
  $F231 A = D;
  $F232 D = 0x58; // screen attributes base
  $F234 if (A >= 0x48) D++; // ie. DE += 256;
  $F239 if (A >= 0x50) D++;
  $F23E *DE = *HL; // copy attribute byte
  $F240 POP HL
  $F241 A = counter_of_something;
  $F244 if (A) goto $F24E;
  $F247 H -= 7;  // HL -= 7*256;
  $F24B L++;
  $F24C goto $F251;
;
  $F24E get_next_scanline();
;
  $F251 EX DE,HL
  $F252 EXX
  $F253 HL++;
  $F254 > while (--B);
  $F256 return;

; ------------------------------------------------------------------------------

c $F257 wipe_full_screen_and_attributes
  $F257 memset(screen, 0, 0x1800);
  $F265 memset(atttributes, attribute_WHITE_OVER_BLACK, 0x300);
  $F26D border = 0; // black
  $F270 return;

; ------------------------------------------------------------------------------

c $F271 select_input_device

; ------------------------------------------------------------------------------

b $F2AD key_choice_prompt_strings
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
D $F2E1 (<- choose_keys)

; ------------------------------------------------------------------------------

b $F2E2 keyboard_port_hi_bytes
D $F2E2 Zero terminated.

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
  $F335 DI
  $F336 saved_sp = SP;
  $F33A sp = game_screen_scanline_start_addresses;
  $F33D A = 128; // 128 rows
  $F33F do < POP HL // start address
  $F340 B = 23; // 23 columns
  $F342 do < *HL = 0;
  $F344 L++;
  $F345 > while (--B);
  $F347 > while (--A);
  $F34B SP = saved_sp;
  $F34F return;

; ------------------------------------------------------------------------------

c $F350 choose_keys

; ------------------------------------------------------------------------------

c $F408 set_menu_item_attributes
R $F408 I:E Attribute.
;
  $F408 HL = 0x590D; // initial screen attribute address
;
D $F40B Skip to the right position.
  $F40B if (A) <
  $F40E B = A;
  $F40F do < L += 64; > while (--B); > // skip two rows per iteration
;
D $F415 Draw.
  $F415 B = 10;
  $F417 do < *HL++ = E; > while (--B);
  $F41B return;

; ------------------------------------------------------------------------------

c $F41C input_device_select_keyscan

; ------------------------------------------------------------------------------

w $F43D inputroutines
D $F43D Array [4] of pointers to input routines.

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

; ------------------------------------------------------------------------------

c $F52C get_tuning (music)
b $F541 music_data_maybe
b $F7C7 music_data2_maybe

; ------------------------------------------------------------------------------

b $FA48 music_tuning_table

; ------------------------------------------------------------------------------

c $FDE0 nop
D $FDE0 No-op subroutine.
  $FDE0 return;

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
; These are relocated into position $F075 when chosen from the menu screen.
;
c $FE00 inputroutine_keyboard
D $FE00 Input routine for keyboard.
R $FE00 O:A Input value (as per enum input).
;
  $FE00 HL = key_defs; // pairs of bytes (port high byte, key mask)
  $FE03 C = 0xFE; // port 0xXXFE
  $FE05 B = *HL++;
  $FE07 IN A,(C)
  $FE09 A = ~A & *HL++;
  $FE0C if (A == 0) goto not_left;
  $FE0E HL += 2; // skip right keydef
  $FE10 E = input_LEFT;
  $FE12 goto up_or_down;
;
  $FE14 not_left: B = *HL++;
  $FE16 IN A,(C)
  $FE18 A = ~A & *HL++;
  $FE1B if (A == 0) goto not_right;
;
  $FE1D E = input_RIGHT;
  $FE1F goto up_or_down;
;
  $FE21 not_right: E = A;
;
  $FE22 up_or_down: B = *HL++;
  $FE24 IN A,(C)
  $FE26 A = ~A & *HL++;
  $FE29 if (A == 0) goto not_up;
;
  $FE2B HL += 2; // skip down keydef
  $FE2D E += input_UP;
  $FE2E goto fire;
;
  $FE30 not_up: B = *HL++;
  $FE32 IN A,(C)
  $FE34 A = ~A & *HL++;
  $FE37 if (A == 0) goto fire;
;
  $FE39 E += input_DOWN;
;
  $FE3B fire: B = *HL++;
  $FE3D IN A,(C)
  $FE3F A = ~A & *HL++;
  $FE42 A = E;
  $FE43 if (A == 0) return;
;
  $FE44 A += input_FIRE;
  $FE46 return;

; ------------------------------------------------------------------------------

c $FE47 inputroutine_protek
D $FE47 Input routine for Protek (cursor) joystick.
R $FE00 O:A Input value (as per enum input).
;
  $FE47 BC = port_KEYBOARD_12345;
  $FE4A IN A,(C)
  $FE4C A = ~A & (1<<4); // 5 == left
  $FE4F E = input_LEFT;
  $FE51 B = 0xEF; // port_KEYBOARD_09876
  $FE53 if (nonzero) goto $FE60;
;
  $FE55 IN A,(C)
  $FE57 A = ~A & (1<<2);
  $FE5A E = input_RIGHT;
  $FE5C if (nonzero) goto $FE60;
;
  $FE5E E = 0; // no horizontal
;
  $FE60 IN A,(C)
  $FE62 A = ~A;
  $FE63 D = A;
  $FE64 A &= (1<<3);
  $FE66 A = input_UP; // interleaved
  $FE68 if (nonzero) goto got_vertical;
;
  $FE6A A = D;
  $FE6B A &= (1<<4);
  $FE6D A = input_DOWN; // interleaved
  $FE6F if (nonzero) goto got_vertical;
;
  $FE71 A = input_NONE;
;
  $FE72 got_vertical: E += A;
  $FE74 A = D & (1<<0);
  $FE77 A = input_FIRE; // interleaved
  $FE79 if (zero) A = 0; // no vertical
;
  $FE7C A += E; // combine axis
  $FE7D return;

; ------------------------------------------------------------------------------

c $FE7E inputroutine_kempston
D $FE7E Input routine for Kempston joystick.
; "#1F Kempston (000FUDLR, active high)"
R $FE00 O:A Input value (as per enum input).
;
  $FE7E BC = 0x001F;
  $FE81 IN A,(C)
  $FE83 BC = 0;
  $FE86 RRA
  $FE87 if (carry) B = input_RIGHT;
  $FE8B RRA
  $FE8C if (carry) B = input_LEFT;
  $FE90 RRA
  $FE91 if (carry) C = input_DOWN;
  $FE95 RRA
  $FE96 if (carry) C = input_UP;
  $FE9A RRA
  $FE9B A = input_FIRE;
  $FE9D if (!carry) A = 0;
  $FEA0 A += B + C;
  $FEA2 return;

; ------------------------------------------------------------------------------

c $FEA3 inputroutine_fuller
D $FEA3 Input routine for Fuller joystick. (Unused).
; "#7F Fuller Box (FxxxRLDU, active low)"
R $FE00 O:A Input value (as per enum input).
;
  $FEA3 BC = 0x007F;
  $FEA6 IN A,(C)
  $FEA8 BC = 0;
  $FEAB if (A & (1<<4)) A = ~A;
  $FEB0 RRA
  $FEB1 if (carry) C = input_UP;
  $FEB5 RRA
  $FEB6 if (carry) C = input_DOWN;
  $FEBA RRA
  $FEBB if (carry) B = input_LEFT;
  $FEBF RRA
  $FEC0 if (carry) B = input_RIGHT;
  $FEC4 if (A & (1<<3)) A = input_FIRE; // otherwise A is zero
  $FECA A += B + C;
  $FECC return;

; ------------------------------------------------------------------------------

c $FECD inputroutine_sinclair
D $FECD Input routine for Sinclair joystick.
; "#EFFE Sinclair1 (000LRDUF, active low, corresponds to keys '6' to '0')"
R $FECD O:A Input value (as per enum input).
;
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

