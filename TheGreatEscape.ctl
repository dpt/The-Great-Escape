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
; alter that to jump to itself. Save the snapshot in Z80 format. Use a hex
; editor on the .z80 to restore the bytes to their former values (JP $F163).

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
; - Sort entire .ctl file by address.
;   - Presently data is listed first.
; - Extract font.

; //////////////////////////////////////////////////////////////////////////////
; CONSTANTS
; //////////////////////////////////////////////////////////////////////////////
;
; These are here for information only and are not used by any of the control
; directives.
;

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
; character_0 = 0
; character_1 = 1
; character_2 = 2
; character_3 = 3
; character_4 = 4
; character_5 = 5
; character_6 = 6
; character_7_prisoner = 7             ; prisoner who sleeps at bed position A
; character_8_prisoner = 8             ; prisoner who sleeps at bed position B
; character_9_prisoner = 9             ; prisoner who sleeps at bed position C
; character_10_prisoner = 10           ; prisoner who sleeps at bed position D
; character_11_prisoner = 11           ; prisoner who sleeps at bed position E
; character_12_prisoner = 12           ; prisoner who sleeps at bed position F
; character_13 = 13
; character_14 = 14
; character_15 = 15
; character_16 = 16
; character_17 = 17
; character_18_prisoner = 18           ; prisoner who sits at bench position D
; character_19_prisoner = 19           ; prisoner who sits at bench position E
; character_20_prisoner = 20           ; prisoner who sits at bench position F
; character_21_prisoner = 21           ; prisoner who sits at bench position A
; character_22_prisoner = 22           ; prisoner who sits at bench position B
; character_23_prisoner = 23           ; prisoner who sits at bench position C
; character_24 = 24
; character_25 = 25
; character_26 = 26                 ; suspect that non-character characters start here (could be the items -- both ranges are 16 long)
; character_27 = 27
; character_28 = 28
; character_29 = 29
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

; ; enum otherobject
; suspect that these may be the same constants as the characters above
; otherobject_STOVE1 = 26              ; secondary object types ... unknown which apply where atm
;                                         ; movable objects perhaps?
;                                         ;
;                                         ; 7x prisoners
;                                         ; ?x guards
;                                         ; 3x dogs (i think)
;                                         ; 1x commandant
;                                         ; ...
;                                         ; 2x stoves
;                                         ; 1x crate
; otherobject_STOVE2 = 27
; otherobject_CRATE = 28

; ; enum room
; room_0 = 0
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
;                                         ; many of the tunnels are displayed duplicated
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
; room_255 = 255

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

; ; enum object
; object_UNKNOWN_0 = 0                 ; unsure what this is
; object_SMALL_TUNNEL_ENTRANCE = 1
; object_ROOM_OUTLINE_2 = 2
; object_TUNNEL_3 = 3
; object_TUNNEL_JOIN_4 = 4
; object_PRISONER_SAT_DOWN_MID_TABLE = 5
; object_TUNNEL_CORNER_6 = 6
; object_TUNNEL_7 = 7
; object_WIDE_WINDOW = 8
; object_EMPTY_BED = 9
; object_SHORT_WARDROBE = 10
; object_CHEST_OF_DRAWERS = 11
; object_TUNNEL_12 = 12
; object_EMPTY_BENCH = 13
; object_TUNNEL_14 = 14
; object_DOOR_FRAME_15 = 15
; object_DOOR_FRAME_16 = 16
; object_TUNNEL_17 = 17
; object_TUNNEL_18 = 18
; object_PRISONER_SAT_DOWN_END_TABLE = 19
; object_COLLAPSED_TUNNEL = 20
; object_ROOM_OUTLINE_21 = 21
; object_CHAIR_POINTING_BOTTOM_RIGHT = 22
; object_OCCUPIED_BED = 23
; object_WARDROBE_WITH_KNOCKERS = 24
; object_CHAIR_POINTING_BOTTOM_LEFT = 25
; object_CUPBOARD = 26
; object_ROOM_OUTLINE_27 = 27
; object_TABLE_1 = 28
; object_TABLE_2 = 29                 ; the two table objects look identical to me
; object_STOVE_PIPE = 30
; object_UNKNOWN_31 = 31               ; can't tell what it is
; object_TALL_WARDROBE = 32
; object_SMALL_SHELF = 33
; object_SMALL_CRATE = 34
; object_SMALL_WINDOW = 35
; object_DOOR_FRAME_36 = 36
; object_NOTICEBOARD = 37
; object_DOOR_FRAME_38 = 38
; object_DOOR_FRAME_39 = 39
; object_DOOR_FRAME_40 = 40
; object_ROOM_OUTLINE_41 = 41
; object_CUPBOARD_42 = 42
; object_MESS_BENCH = 43
; object_MESS_TABLE = 44
; object_MESS_BENCH_SHORT = 45
; object_ROOM_OUTLINE_46 = 46
; object_ROOM_OUTLINE_47 = 47
; object_TINY_TABLE = 48
; object_TINY_DRAWERS = 49
; object_DRAWERS_50 = 50
; object_DESK = 51
; object_SINK = 52
; object_KEY_RACK = 53
; object__LIMIT = 54

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
; input_UP = 0                  ; wrong, for now
; input_DOWN = 1                  ; wrong, for now
; input_LEFT = 2                  ; wrong, for now
; input_RIGHT = 3                  ; wrong, for now
; input_FIRE = 9
; input_UP_FIRE = 10
; input_DOWN_FIRE = 11
; input_LEFT_FIRE = 12
; input_RIGHT_FIRE = 15

; ; enum port_keyboard
; port_KEYBOARD_12345 = $0F7FE

; ; enum objecttile (width 1 byte)
; objecttile_ESCAPE = 255              ; escape character

; //////////////////////////////////////////////////////////////////////////////
; CONTROL DIRECTIVES
; //////////////////////////////////////////////////////////////////////////////

; ------------------------------------------------------------------------------

b $4000 Screen.
D $4000 #UDGTABLE { #SCR(loading) | This is the loading screen. } TABLE#

; ------------------------------------------------------------------------------

b $CE22 Sprite definitions -- objects which can move.
;
D $CE22 This include STOVE, CRATE, PRISONER, CRAWL, DOG, GUARD and COMMANDANT.
D $CE22 Structure: (b) width in bytes, (b) height in rows, (w) data ptr, (w) mask ptr
B $CE22 sprite: STOVE (16x22)
B $CE28 sprite: CRATE (24x24)
B $CE2E sprite: PRISONER (16x27) TOP LEFT 4
B $CE34 sprite: PRISONER (16x28) TOP LEFT 3
B $CE3A sprite: PRISONER (16x28) TOP LEFT 2
B $CE40 sprite: PRISONER (16x28) TOP LEFT 1
B $CE46 sprite: PRISONER (16x27) BOTTOM RIGHT 1
B $CE4C sprite: PRISONER (16x29) BOTTOM RIGHT 2
B $CE52 sprite: PRISONER (16x28) BOTTOM RIGHT 3
B $CE58 sprite: PRISONER (16x28) BOTTOM RIGHT 4
B $CE5E sprite: CRAWL (24x16) BOTTOM LEFT 2
B $CE64 sprite: CRAWL (24x15) BOTTOM LEFT 1
B $CE6A sprite: CRAWL (24x16) TOP LEFT 1
B $CE70 sprite: CRAWL (24x16) TOP LEFT 2
B $CE76 sprite: DOG [fillmeout]
B $CEA6 sprite: GUARD [fillmeout]
B $CED6 sprite: COMMANDANT [fillmeout]

; ------------------------------------------------------------------------------

b $D026 Sprite bitmaps and masks.
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

b $DD7D Item definitions.
D $DD7D Array of "sprite" structures.
;
B $DD7D item_sprite: WIRESNIPS
B $DD83 item_sprite: SHOVEL
B $DD89 item_sprite: LOCKPICK
B $DD8F item_sprite: PAPERS
B $DD95 item_sprite: TORCH
B $DD9B item_sprite: BRIBE
B $DDA1 item_sprite: UNIFORM
B $DDA7 item_sprite: FOOD
B $DDAD item_sprite: POISON
B $DDB3 item_sprite: RED KEY
B $DDB9 item_sprite: YELLOW KEY
B $DDBF item_sprite: GREEN KEY
B $DDC5 item_sprite: PARCEL
B $DDCB item_sprite: RADIO
B $DDD1 item_sprite: PURSE
B $DDD7 item_sprite: COMPASS

; ------------------------------------------------------------------------------

b $DDDD Item bitmaps and masks.
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

z $E0D7 UNUSED

; ------------------------------------------------------------------------------

b $6BAD Rooms and tunnels.
;
W $6BAD Array of pointers to rooms.
W $6BE5 Array of pointers to tunnels.
;
B $6C15 room_def: room1_hut1_right
;
B $6C47 room_def: room2_hut2_left
B $6C61,1 bed -- where the player sleeps
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
B $6F58,1 bench_G -- where the player sits
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

; Screenlocstrings.
;
; Screenlocstrings are a screen address followed by a counted string.
;
b $A5CE Screenlocstrings (screen address + string).
D $A5CE "WELL DONE"
B $A5CE #CALL:decode_screenlocstring($A5CE)
D $A5DA "YOU HAVE ESCAPED"
B $A5DA #CALL:decode_screenlocstring($A5DA)
D $A5ED "FROM THE CAMP"
B $A5ED #CALL:decode_screenlocstring($A5ED)
D $A5FD "AND WILL CROSS THE"
B $A5FD #CALL:decode_screenlocstring($A5FD)
D $A612 "BORDER SUCCESSFULLY"
B $A612 #CALL:decode_screenlocstring($A612)
D $A628 "BUT WERE RECAPTURED"
B $A628 #CALL:decode_screenlocstring($A628)
D $A63E "AND SHOT AS A SPY"
B $A63E #CALL:decode_screenlocstring($A63E)
D $A652 "TOTALLY UNPREPARED"
B $A652 #CALL:decode_screenlocstring($A652)
D $A667 "TOTALLY LOST"
B $A667 #CALL:decode_screenlocstring($A667)
D $A676 "DUE TO LACK OF PAPERS"
B $A676 #CALL:decode_screenlocstring($A676)
D $A68E "PRESS ANY KEY"
B $A68E #CALL:decode_screenlocstring($A68E)
;
b $F014 Menu screenlocstrings.
D $F014 "CONFIRM Y OR N"
B $F014 #CALL:decode_screenlocstring($F014)
;
b $F2AD Key choice prompt strings.
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
;
b $F446 Key choice screenlocstrings.
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
;
c $A5BF screenlocstring_plot

; ------------------------------------------------------------------------------

; Messages - messages printed at the bottom of the screen when things happen.
;
b $7DCD Messages (non-ASCII: encoded to match the font; FF terminated).
W $7DCD Array of pointers to messages.
D $7DF5 "MISSED ROLL CALL"
B $7DF5 #CALL:decode_stringFF($7DF5)
D $7E06 "TIME TO WAKE UP"
B $7E06 #CALL:decode_stringFF($7E06)
D $7E16 "BREAKFAST TIME"
B $7E16 #CALL:decode_stringFF($7E16)
D $7E25 "EXERCISE TIME"
B $7E25 #CALL:decode_stringFF($7E25)
D $7E33 "TIME FOR BED"
B $7E33 #CALL:decode_stringFF($7E33)
D $7E40 "THE DOOR IS LOCKED"
B $7E40 #CALL:decode_stringFF($7E40)
D $7E53 "IT IS OPEN"
B $7E53 #CALL:decode_stringFF($7E53)
D $7E5E "INCORRECT KEY"
B $7E5E #CALL:decode_stringFF($7E5E)
D $7E6C "ROLL CALL"
B $7E6C #CALL:decode_stringFF($7E6C)
D $7E76 "RED CROSS PARCEL"
B $7E76 #CALL:decode_stringFF($7E76)
D $7E87 "PICKING THE LOCK"
B $7E87 #CALL:decode_stringFF($7E87)
D $7E98 "CUTTING THE WIRE"
B $7E98 #CALL:decode_stringFF($7E98)
D $7EA9 "YOU OPEN THE BOX"
B $7EA9 #CALL:decode_stringFF($7EA9)
D $7EBA "YOU ARE IN SOLITARY"
B $7EBA #CALL:decode_stringFF($7EBA)
D $7ECE "WAIT FOR RELEASE"
B $7ECE #CALL:decode_stringFF($7ECE)
D $7EDF "MORALE IS ZERO"
B $7EDF #CALL:decode_stringFF($7EDF)
D $7EEE "ITEM DISCOVERED"
B $7EEE #CALL:decode_stringFF($7EEE)
;
b $F025 More messages.
D $F026 "HE TAKES THE BRIBE"
B $F026 #CALL:decode_stringFF($F026)
D $F039 "AND ACTS AS DECOY"
B $F039 #CALL:decode_stringFF($F039)
D $F04B "ANOTHER DAY DAWNS"
B $F04B #CALL:decode_stringFF($F04B)

; ------------------------------------------------------------------------------

; Counted strings.
;
b $F2EB Counted strings (encoded to match font; first byte is count).
D $F2EB "ENTER"
B $F2EB #CALL:decode_stringcounted($F2EB)
D $F2F1 "CAPS"
B $F2F1 #CALL:decode_stringcounted($F2F1)
D $F2F6 "SYMBOL"
B $F2F6 #CALL:decode_stringcounted($F2F6)
D $F2FD "SPACE"
B $F2FD #CALL:decode_stringcounted($F2FD)

; ------------------------------------------------------------------------------

; Static tiles.
;
b $7F00 Static tiles (those used on-screen for medals, etc.) 9 bytes each: 8x8 bitmap + 1 byte attribute. 75 tiles.
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

; Interior object tile refs.
;
b $7095 Interior object tile refs.
W $7095 Array of pointer to interior object tile refs, 54 entries long (== number of interior room objects).
B $7101 Object tile refs 0
B $711B Object tile refs 1
B $7121 Object tile refs 3
B $713B Object tile refs 4
B $7155 Object tile refs 5
B $715A Object tile refs 6
B $7174 Object tile refs 7
B $718E Object tile refs 12
B $71A6 Object tile refs 13
B $71AB Object tile refs 14
B $71C4 Object tile refs 17
B $71DE Object tile refs 18
B $71F8 Object tile refs 19
B $7200 Object tile refs 20
B $721A Object tile refs 2
B $728E Object tile refs 8
B $72AE Object tile refs 9
B $72C1 Object tile refs 10
B $72CC Object tile refs 11
B $72D1 Object tile refs 15
B $72EB Object tile refs 16
B $7305 Object tile refs 22
B $730F Object tile refs 23
B $7325 Object tile refs 24
B $7333 Object tile refs 25
B $733C Object tile refs 26
B $7342 Object tile refs 28
B $734B Object tile refs 30
B $7359 Object tile refs 31
B $735C Object tile refs 32
B $736A Object tile refs 33
B $736F Object tile refs 34
B $7374 Object tile refs 35
B $7385 Object tile refs 36
B $7393 Object tile refs 37
B $73A5 Object tile refs 38
B $73BF Object tile refs 39
B $73D9 Object tile refs 41
B $7425 Object tile refs 42
B $742D Object tile refs 43
B $7452 Object tile refs 44
B $7482 Object tile refs 45
B $7493 Object tile refs 46
B $74F5 Object tile refs 47
B $7570 Object tile refs 48
B $7576 Object tile refs 49
B $757E Object tile refs 50
B $7588 Object tile refs 51
B $75A2 Object tile refs 52
B $75AA Object tile refs 53
B $75B0 Object tile refs 27
B $75B3 the block which terminates the object tile refs [unsure what -- it could just be a large object definition]

; ------------------------------------------------------------------------------

; More object tile refs.
;
b $7738 More object tile refs.
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

; Characters.
;
b $7612 character_structs.
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
;
b $76C8 item_structs.
D $76C8 Array, 16 long, of 7-byte structures. These are 'characters' but seem to be the game items.
B $76C8 itemstruct_0: wiresnips (<- item_to_thing, pick_up_related)
B $76CF itemstruct_1: shovel
B $76D6 itemstruct_2: lockpick
B $76DD itemstruct_3: papers
B $76E4 itemstruct_4: torch
B $76EB itemstruct_5: bribe (<- use_bribe)
B $76F2 itemstruct_6: uniform
B $76F9 itemstruct_7: food (<- action_poison, called_from_main_loop)
B $7700 itemstruct_8: poison
B $7707 itemstruct_9: red key
B $770E itemstruct_10: yellow key
B $7715 itemstruct_11: green key
B $771C itemstruct_12: red cross parcel (<- event_new_red_cross_parcel, new_red_cross_parcel)
B $7723 itemstruct_13: radio
B $772A itemstruct_14: purse
B $7731 itemstruct_15: compass

; ------------------------------------------------------------------------------

b $F076 tile refs for statics
B $F076 statics_flagpole (struct: w(addr),flags+length,attrs[length])
B $F08D statics_game_screen_left_border
B $F0A4 statics_game_screen_right_border
B $F0BB statics_game_screen_top_border
B $F0D5 statics_game_screen_bottom
B $F0EF statics_flagpole_grass
B $F0F7 statics_medals_row0
B $F107 statics_medals_row1
B $F115 statics_medals_row2
B $F123 statics_medals_row3
B $F131 statics_medals_row4
B $F13E statics_bell_row0
B $F144 statics_bell_row1
B $F14A statics_bell_row2
B $F14F statics_corner_tl
B $F154 statics_corner_tr
B $F159 statics_corner_bl
B $F15E statics_corner_br

; ------------------------------------------------------------------------------

b $EBC5 Table of pointers, 30 long, to byte arrays [unsure]  -- probably masks
W $EBC5 -> $E55F
W $EBC7 -> $E5FF
W $EBC9 -> $E61E
W $EBCB -> $E6CA
W $EBCD -> $E74B
W $EBCF -> $E758
W $EBD1 -> $E77F
W $EBD3 -> $E796
W $EBD5 -> $E7AF
W $EBD7 -> $E85C
W $EBD9 -> $E8A3
W $EBDB -> $E8F0
W $EBDD -> $E940
W $EBDF -> $E972
W $EBE1 -> $E92F
W $EBE3 -> $EA67
W $EBE5 -> $EA53
W $EBE7 -> $EA5D
W $EBE9 -> $E99A
W $EBEB -> $E99F
W $EBED -> $E9B9
W $EBEF -> $E9C6
W $EBF1 -> $E9CB
W $EBF3 -> $E9E6
W $EBF5 -> $E9F5
W $EBF7 -> $EA0E
W $EBF9 -> $EA2B
W $EBFB -> $EA35
W $EBFD -> $EA43
W $EBFF -> $EA4A
;
b $E55F probably mask data
B $E55F probably masks
B $E5FF probably masks
B $E61E probably masks
B $E6CA probably masks
B $E74B probably masks
B $E758 probably masks
B $E77F probably masks
B $E796 probably masks
B $E7AF probably masks
B $E85C probably masks
B $E8A3 probably masks
B $E8F0 probably masks
B $E92F probably masks
B $E940 probably masks
B $E972 probably masks
B $E99A probably masks
B $E99F probably masks
B $E9B9 probably masks
B $E9C6 probably masks
B $E9CB probably masks
B $E9E6 probably masks
B $E9F5 probably masks
B $EA0E probably masks
B $EA2B probably masks
B $EA35 probably masks
B $EA43 probably masks
B $EA4A probably masks
B $EA53 probably masks
B $EA5D probably masks
B $EA67 probably masks

b $EA74 (<- sub_68A2)

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


b $68A0 indoor_room_index (zero if outdoors)
b $68A1 current_door
b $69A0 unknown - fourteen bytes long
w $6B79 pointers to six beds (beds of active prisoners) (note that the top hut has prisoners permanently in bed)
w $6B85 four byte structures (which are ranged checked by routine at #R$B29F)
u $81A3 UNUSED?
b $A69E bitmap font: 0..9, A..Z (omitting O), space, full stop
b $A7C7 plot_game_screen_x
b $AB31 jumptable
b $AE75 searchlight_related (<- nighttime, searchlight)
w $AE76 word_AE76 (<- nighttime)
u $CB5F UNUSED
u $CB92 UNUSED
b $F1C9 twenty three bytes [unsure] -- main copies this somewhere
b $FA48 music tuning table

; ------------------------------------------------------------------------------

; something plotter ish
w $E0E0 pairs_of_offsets (jumps0..5) (<- sub_DC41, sub_E420)
W $E0E0 jump0
W $E0E2 jump1
W $E0E4 jump2
W $E0E6 jump3
W $E0E8 jump4
W $E0EA jump5

w $E0EC pairs_of_offsets2 (<- sub_E420)
W $E0EC
W $E0EE
W $E0F0
W $E0F2
W $E0F4
W $E0F6
W $E0F8
W $E0FA
W $E0FC
W $E0FE -> masked sprite plotter

u $E100 UNUSED? (unsure if related to the above pairs_of_offsets2 table)


b $783A unknown - bytes, 156 long, maybe

b $78D6 four byte structs (<- sub 69DC)

b $7AC6 unk_7AC6, 3 bytes long (<- solitary)

w $7B16 item actions jump table

b $7CFC message buffer stuff
B $7CFC message buffer (two starting slack bytes?)
B $7D0F message_display_counter
B $7D10 message_display_index
W $7D11 message_buffer_pointer
W $7D13 current_message_character

b $81A3 mystery byte

w $81A4 word_81A4
w $81A6 word_81A6
w $81A8 word_81A8
b $81AA word_81AA
b $81AB mystery byte
w $81AC word_81AC
w $81AE word_81AE
w $81B0 word_81B0
b $81B2 byte_81B2
b $81B3 byte_81B3
b $81B4 byte_81B4
b $81B5 map position related 1
b $81B6 map position related 2
b $81B7 byte_81B7
b $81B8 byte_81B8
b $81B9 wiresnips_related
b $81BA mystery byte
w $81BB map_position_maybe
b $81BD byte_81BD (<- nighttime, something_then_decrease_morale)
b $81BE first word of room structure [unsure]
b $81BF byte_81BF (seems to hold many zeroes)
b $81D6 door related (<- indoors maybe, <- open door)
B $81D9 door related (final byte?)
b $81DA unk_81DA (<- select_room_maybe, sub_B916)
b $8213 possibly holds an item
b $8214 byte_8214
w $8215 items held (two byte slots. initialised to 0xFFFF meaning no item in either slot)
b $8217 character_index

; ------------------------------------------------------------------------------

; Tiles.
;
b $8218 Tiles.
;
D $8218 #UDGARRAY1,7,4,1;$8218-$858F-8(exterior-tiles0)
D $8590 #UDGARRAY1,7,4,1;$8590-$8A17-8(exterior-tiles1)
D $8A18 #UDGARRAY1,7,4,1;$8A18-$90F7-8(exterior-tiles2)
D $90F8 #UDGARRAY1,7,4,1;$90F8-$988F-8(exterior-tiles3)
D $9890 #UDGARRAY1,7,4,1;$9890-$9D77-8(interior-tiles)
;
B $8218 Exterior tiles set 0. 111 tiles. Looks like mask tiles for huts. (<- plot_a_tile_perhaps)
;
B $8590 Exterior tiles set 1. 145 tiles. Looks like tiles for huts. (<- plot_a_tile_perhaps)
;
B $8A18 Exterior tiles set 2. 220 tiles. Looks like main building wall tiles. (<- plot_a_tile_perhaps)
B $8A18,8 tile: ground1 [start of exterior tiles 2] (<- plot_a_tile_perhaps)
B $8A20,8 tile: ground2
B $8A28,8 tile: ground3
B $8A30,8 tile: ground4
;
B $90F8 Exterior tiles set 3. 243 tiles. Looks like main building wall tiles.
;
B $9890 Interior tiles. 157 tiles.
B $9768,8 empty tile (<- plot_indoor_tiles, sub_BCAA)

; ------------------------------------------------------------------------------

b $A12F game_counter: counts 00..FF then wraps.
b $A130 bell
b $A131 mystery byte
b $A132 score_digits
b $A137 byte_A137
b $A138 naughty_flag_perhaps
b $A139 morale_related_also
b $A13A morale_related
b $A13C morale
b $A13D dispatch_counter
b $A13E byte_A13E
b $A13F bed_related_perhaps
b $A140 displayed_morale_maybe [displayed morale lags behind actual morale, as the flag moves slowly to its target]
w $A141 moraleflag_screen_address
w $A143 ptr_to_door_being_lockpicked: address of door in which bit 7 is cleared when picked
b $A145 user_locked_out_until: game time until user control is restored (e.g. when picking a lock or cutting wire)
b $A146 day_or_night ($00 = daytime, $FF = nighttime)

; ------------------------------------------------------------------------------

b $A147 bell ringing bitmaps
B $A147 bell_ringer_bitmap_off
B $A153 bell_ringer_bitmap_on

; ------------------------------------------------------------------------------

b $A7C6 used by sub_AAFF

w $AD29 word_AD29

b $B53E sixlong_things
b $B54E wiresnips_related_table

b $B819 10 x 3-byte structs
B $B819,30,3 looks_like_character_reset_data -- 10 x 3-byte structs
b $B837 byte_B837
b $B838 byte_B838
w $B839 word_B839

; ------------------------------------------------------------------------------

; Map
;
b $BCEE map_tiles
D $BCEE Map super-tile refs. 54x32. Each byte represents a 32x32 tile.
D $BCEE #CALL:map($BCEE, 54, 32)

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

w $C41A (<- increment_word_C41A_low_byte_wrapping_at_15)

b $CC31 reset_data (<- solitary)
b $EA7C stru_EA7C - 47 x seven byte structs
b $EC01 58 8-byte structs.

b $F05D Gates and doors.
B $F05D,2 gates_flags
B $F05F,7 door_flags
B $F066,2 unknown

c $F068 jump_to_main

b $F06B key_defs -- user-configured keys

b $F075 counter_of_something


b $F2E1 unk_F2E1 (<- choose_keys)
b $F2E2 keyboard port hi bytes (zero terminated)


w $EDD1 saved_sp
w $EDD3 game screen scanline start addresses

u $EFFB UNUSED?











; ------------------------------------------------------------------------------

; game state which overlaps with tiles etc.
;
; vars referenced as (overlap.$8015)

; b $8000 -- never written?
; b $8001 -- flags: bit 6 gets toggled in set_target_location /  bit 0: picking lock /  bit 1: cutting wire
; w $8002 -- could be a target location (set in set_target_location, user_input_was_in_bed_perhaps)
; w $8004 -- (<- user_input_was_in_bed_perhaps)
; b $800D -- tunnel related (<- process_user_input, wire_snipped, user_input_was_in_bed_perhaps) assigned from table at 9EE0
; b $800E -- tunnel related, walk/crawl flag maybe? (bottom 2 bits index $9EE0)
; w $800F --
; w $8011 --
; b $8013 -- set to 24 in user_input_was_in_bed_perhaps
; w $8015 -- pointer to current character sprite set (gets pointed to the 'tl_4' sprite)
; w $8018 -- points to something (gets 0x06C8 subtracted from it) (<- in_permitted_area)
; w $801A -- points to something (gets 0x0448 subtracted from it) (<- in_permitted_area)
; b $801C -- cleared to zero by action_papers, set to room_24_solitary by solitary, copied to indoor_room_index by sub_68A2 -- looks like a room index!
; ? $8020 -- character reset data? (<- calledby_setup_movable_items)

; ------------------------------------------------------------------------------









c $6920 tunnel_related -- probably when emerging from tunnel -- this is resetting the character sprite set to prisoner
  $6929 ...
  $6926 A = indoor_room_index;
  $6929 if (A < room_29_secondtunnelstart) goto not_in_a_tunnel;
  $692D ...
  $692F (overlap.$8015) = sprite_prisoner_tl_4;
  $6935 return;
  $6936 not_in_a_tunnel: ...
  $6938 return;

; ------------------------------------------------------------------------------

c $68A2 sub 68A2 - looks like it's resetting stuff
C $68F4 some_sort_of_initial_setup_maybe (<- main and setup)
c $6920 tunnel_related [unsure]
c $6939 setup_movable_items

; ------------------------------------------------------------------------------

c $696A setup_crate

; ------------------------------------------------------------------------------

c $6971 setup_stove2

; ------------------------------------------------------------------------------

c $6978 setup_stove1

; ------------------------------------------------------------------------------

c $69C9 calledby_setup_movable_items

; ------------------------------------------------------------------------------

c $69DC sub_69DC

; ------------------------------------------------------------------------------

c $6A12 sub_6A12

; ------------------------------------------------------------------------------

c $6A27 wipe_visible_tiles
D $6A27 Wipe the visible tiles array at $F0F8 (24 * 16 = 408);

; ------------------------------------------------------------------------------

c $6A35 select_room_maybe
c $6AB5 draw_object_to_tiles [unsure]

; ------------------------------------------------------------------------------

c $6B42 plot_indoor_tiles

; ------------------------------------------------------------------------------

c $7AC9 check for 'pick up', 'drop' and both 'use item' keypresses
  $7AF0 use_item_B
  $7AF5 use_item_A
  $7AFB (pointless_jump)
  $7AFD ...

; ------------------------------------------------------------------------------

c $7B36 pick_up_item

; ------------------------------------------------------------------------------

c $7B8B drop_item
  $7B8B A = (items_held)
  $7B8E if (A == item_NONE) return;
  $7B91 if (A == item_UNIFORM) (overlap.$8015) = sprite_prisoner_tl_4;
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
  $7BE3 return;
  $7BE4 ...
  $7C25 return;

; ------------------------------------------------------------------------------

c $7C26 item_to_thing

; ------------------------------------------------------------------------------

c $7C33 draw_all_items
  $7C33 draw_item(screenaddr_item1, items_held[0]);
  $7C3C draw_item(screenaddr_item2, items_held[1]);
  $7C45 return;

; ------------------------------------------------------------------------------

c $7C46 draw_item

; ------------------------------------------------------------------------------

c $7C82 pick_up_related
c $7CBE plot_bitmap
c $7CD4 screen_wipe
c $7CE9 get_next_scanline

; ------------------------------------------------------------------------------

c $7D15 queue_message_for_display
R $7D15 B message_* index.
R $7D15 C ...
  $7D15 if (*(hl = message_buffer_pointer) == 0xFF) return;
  $7D1C hl -= 2;
  $7D1E a = *hl++; if (a != b) goto set;
  $7D23 a = *hl; if (a == c) return;
  $7D26 set: *++hl = b; *++hl = c; hl++;
  $7D2B *message_buffer_pointer = hl;
  $7D2E return;

; ------------------------------------------------------------------------------

c $7D2F plot_glyph
R $7D2F HL Pointer to glyph.
R $7D2F DE Pointer to destination.
  $7D2F a = *hl;
  $7D30 ...
  $7D31 hl = a * 8;
  $7D37 bc = bitmap_font;
  $7D3A hl += bc;
  $7D3C 8 iterations.
  $7D3E do { *de = *hl;
  $7D40 d++; // i.e. de += 256;
  $7D41 hl++;
  $7D42 } while (--b);
  $7D44 de++;
  $7D47 return;

; ------------------------------------------------------------------------------

c $7D48 message_timer

; ------------------------------------------------------------------------------

c $9D78 main_loop
  $9D78 some_sort_of_initial_setup_maybe();
  $9D7B for (;;) { check_morale();
  $9D7E keyscan_game_cancel();
  $9D81 message_timer();
  $9D84 process_user_input();
  $9D87 in_permitted_area();
  $9D8A called_from_main_loop_3(); [unknown]
  $9D8D move_characters();
  $9D90 called_from_main_loop_5(); [unknown]
  $9D93 called_from_main_loop_6(); [unknown]
  $9D96 called_from_main_loop_7(); [unknown]
  $9D99 called_from_main_loop_8(); [unknown]
  $9D9C ring_bell();
  $9D9F called_from_main_loop_9(); [unknown]
  $9DA2 called_from_main_loop_10(); [unknown]
  $9DA5 message_timer();
  $9DA8 ring_bell();
  $9DAB called_from_main_loop_11(); [unknown]
  $9DAE plot_game_screen();
  $9DB1 ring_bell();
  $9DB4 if ($A145 != 0) call $ADBD; [unknown]
  $9DBB if (indoor_room_index != 0) indoors_delay_loop();
  $9DC2 wave_moraleflag
  $9DC5 if ((game_counter & 63) == 0) dispatch_table_thing();
  $9DCD }

; ------------------------------------------------------------------------------

c $9DCF check_morale (<- main_loop)
  $9DCF if (morale >= 2) return;
  $9DD5 queue_message_for_display(message_MORALE_IS_ZERO, 0);
  $9DDB *(morale_related + 1) = 0xFF; // mystery
  $9DE0 *(morale_related_also) = 0; // mystery
  $9DE4 return;

; ------------------------------------------------------------------------------

c $9DE5 check for 'game cancel' keypress
  $9DE5 if (!shift_pressed) return;
  $9DED if (!space_pressed) return;
  $9DF4 screen_reset_perhaps() user_confirm() if (confirmed) looks_like_a_reset_fn()
  $9DFD if (indoor_room_index == 0) loc_B2FC(); else some_sort_of_initial_setup_maybe();

; ------------------------------------------------------------------------------

c $9E07 process_user_input
  $9E07 if (morale_related) return; // inhibits user control when morale hits zero
  $9E0E if (($8001 & 3) == 0) goto zero_flags;
  $9E15 morale_related_also = 31;
  $9E1A if ($8001 == 1) goto lock_picked;
  $9E1F goto wire_snipped;
  $9E22 zero_flags: input_routine(); // lives at same address as counter_of_something
  $9E25 hl = &morale_related_also; if (? != 0) goto user_input_super(hl);
  $9E2D if (morale_related_also == 0) return;
  $9E30 morale_related_also--; a = 0; goto user_input_fire_not_pressed;

; ------------------------------------------------------------------------------

c $9E34 user_input_super

; ------------------------------------------------------------------------------

c $9E5C user_input_was_in_bed_perhaps
  $9E5C ...
  $9E75 player_bed = object_EMPTY_BED;
  $9E7A ...
  $9E7D user_input_another_entry_point
  $9E85 user_input_A137_was_zero
  $9E8D A = 0x80;
  $9E8F user_input_fire_not_pressed: if ($800D == A) return;
  $9E94 $800D = A | 0x80;
  $9E97 return;

; ------------------------------------------------------------------------------

c $9E98 lock_picked -- locks user out until lock is picked
  $9E98 HL = &game_counter
  $9E9B A = user_locked_out_until
  $9E9E if (A != *HL) return;
  $9EA0 *ptr_to_door_being_lockpicked &= ~(1 << 7); // open door
  $9EA5 queue_message_for_display(message_IT_IS_OPEN);
  $9EAA clear bottom two bits of $8001
  $9EB1 return;

; ------------------------------------------------------------------------------


b $9EE4 twentyonelong -- 7 structs, 3 wide. maps bytes to offsets
  $9EE4,3 byte_to_offset <42, unk_9EF9>
  $9EE7,3 byte_to_offset < 5, unk_9EFC>
  $9EEA,3 byte_to_offset <14, unk_9F01>
  $9EED,3 byte_to_offset <16, unk_9F08>
  $9EF0,3 byte_to_offset <44, unk_9F0E>
  $9EF3,3 byte_to_offset <43, unk_9F11>
  $9EF6,3 byte_to_offset <45, unk_9F13>
  $9EF9 unk_9EF9
  $9EFC unk_9EFC
  $9F01 unk_9F01
  $9F08 unk_9F08
  $9F0E unk_9F0E
  $9F11 unk_9F11
  $9F13 unk_9F13

; ------------------------------------------------------------------------------

b $9F15 (<- in_permitted_area)

c $9F21 in_permitted_area [unsure] -- could be as general as bounds detection
  $A007 a second in_permitted_area entry point

; ------------------------------------------------------------------------------

c $A035 wave_morale_flag

c $A071 set_morale_flag_screen_attributes

c $A082 call_mystery_if_h_AND_7_is_zero

c $A095 indoors-only delay loop

c $A09E ring_bell

c $A0D2 increase_morale

c $A0E0 decrease_morale

c $A0E9 increase_morale_by_10,_score_by_50

c $A0F2 increase_morale_by_5

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

c $A15F set_game_screen_attributes
R $A15F A Attribute byte.
  $A15F Starting at $5847, set 23 columns of 16 rows to A.

; ------------------------------------------------------------------------------

b $A173 timed_events array (15 event structures)
  $A173 { 0, event_another_day_dawns }
  $A176 { 8, event_wake_up }
  $A179 { 12, event_new_red_cross_parcel }
  $A17C { 16, event_go_to_roll_call }
  $A17F { 20, event_roll_call }
  $A182 { 21, event_go_to_breakfast_time }
  $A185 { 36, event_breakfast_time }
  $A188 { 46, event_go_to_exercise_time }
  $A18B { 64, event_exercise_time }
  $A18E { 74, event_go_to_roll_call }
  $A191 { 78, event_roll_call }
  $A194 { 79, event_go_to_time_for_bed }
  $A197 { 98, event_time_for_bed }
  $A19A { 100, event_night_time }
  $A19D { 130, event_search_light }

; ------------------------------------------------------------------------------

c $A1A0 dispatch_table_thing // dispatches time-based game events like parcels, meals, exercise and roll calls

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

b $A27F tenlong [unsure] (<- sub_A35F, sub_A373)

c $A289 sub_A289

c $A2E2 sub_A2E2

c $A33F set_target_location
  $A33F if (morale_related) return;
  $A344 $8001 &= ~(1<<6); $8002 = b; $8003 = c; return;

c $A351 sub_A351

c $A35F sub_A35F -- uses tenlong structure

c $A373 sub_A373 -- uses tenlong structure

c $A38C sub_A38C
U $A3A9 mystery byte

c $A3AA not set

c $A3B3 found [possibly a tail of above sub]

c $A3ED store_banked_A_then_C_at_HL

c $A3F3 sub_A3F3 -- checks character indexes, sets target locations, ...

c $A3F8 varA13E_is_zero

c $A420 character_sits

c $A444 character_sleeps

c $A462 (common end of above two routines)

c $A47F player_sits

c $A489 player_sleeps

c $A491 (common end of the above two routines)

c $A4A9 sets a target location 0E00

c $A4B7 sets a target location 8E04

c $A4C5 sets a target location 1000

c $A4D3 sub_A4D3 -- something character related [very similar to the routine at $A3F3]

c $A4D8 varA13E_is_zero_anotherone / sets a target location 2B00

c $A4FD sub_A4FD

c $A50B screen reset [unsure]

c $A51C escaped

c $A58C keyscan all

c $A59C do_we_have_required_objects_for_escape
R $A59C HL (single) item slot
R $A59C C previous return value
C $A5A3 do_we_have_compass
C $A5AA do_we_have_papers
C $A5B1 do_we_have_purse
C $A5B8 do_we_have_uniform

c $A7C9 sub_A7C9 -- resetish

c $A80A sub_A80A

c $A819 sub_A819

c $A8A2 sub_A8A2 -- resetish

c $A8CF sub_A8CF

c $A8E7 sub_A8E7

c $A9A0 sub_A9A0

; -----------------------------------------------------------------------------

c $A9AD plot_a_tile_perhaps -- plots tiles to buffer
R $A9AD HL Likely the supertile index (used to select the correct tile group).
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

c $AAB2 called_from_main_loop_10

w $AB31 jump table of (map_move_1, 2, 3, 4)
C $AB39 map_move_1
C $AB44 map_move_2
C $AB4F map_move_3
C $AB5A map_move_4

; -----------------------------------------------------------------------------

b $AB66 Zoombox? stuff.
  $AB66 zoombox related 1
  $AB67 zoombox horizontal count
  $AB68 zoombox related 3
  $AB69 zoombox vertical count
  $AB6A game_screen_attribute

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

c $ABA0 zoombox
  $ABF9 zoombox 1
  $AC6F zoombox 2
  $ACFC zoombox draw tile

b $AF5E zoombox tiles
  $AF5E zoombox_tile_wire_tl
  $AF66 zoombox_tile_wire_hz
  $AF6E zoombox_tile_wire_tr
  $AF76 zoombox_tile_wire_vt
  $AF7E zoombox_tile_wire_br
  $AF86 zoombox_tile_wire_bl

; -----------------------------------------------------------------------------

b $AF8E bribe_related

c $AD59 sub_AD59

c $ADBD nighttime

c $AE78 something_then_decrease_morale_10

c $AEB8 searchlight
B $AF3E bitmap: searchlight shape (circle)

c $AF8F sub_AF8F

c $AFDF sub_AFDF

b $B0F8 four bytes (<- sub_AFDF)

c $B0FC loc_B0FC

c $B107 use_bribe -- 'he takes the bribe' 'and acts as decoy'

c $B14C sub_B14C -- outdoor drawing?

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

c $B1F5 door_handling

c $B252 sub_B252

c $B295 rotate_A_left_2_widening_to_BC

c $B29F sub_B29F

c $B2FC resetty

c $B32D indoors [unsure]

c $B387 action_red_cross_parcel

c $B3A8 action_bribe

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
  $B3E1 HL = (overlap.$8015);
  $B3E4 DE = sprite_guard_...;
  $B3E7 A = (HL);
  $B3E8 if (.. cheap equality test ..) return;
  $B3EA ...

c $B3F6 action_shovel

c $B417 action_wiresnips
  $B417 ...
  $B482 (overlap.$8015) = sprite_prisoner_tl_4;
  $B488 ...

c $B495 action_lockpick

c $B4AE action_red_key

c $B4B2 action_yellow_key

c $B4B6 action_green_key

c $B4B8 action_key

c $B4D0 open_door

c $B5CE called_from_main_loop_9

c $B71B reset_something

c $B75A looks_like_a_reset_function [unsure]
  $B75A ...
  $B789 (overlap.$8015) = sprite_prisoner_tl_4;
  $B78F ...
  $B79A return;

c $B79B reset map and characters [unsure]

c $B83B resetty

c $B866 called_from_main_loop_11

c $B89C no_idea

c $B916 sub_B916 -- sets attr of something, checks indoor room index, ...

c $BADC sub_BADC

#c $BAF8 ff_anded_with_ff

c $BB98 called_from_main_loop_3

c $BCAA sub_BCAA

c $C41C called_from_main_loop_7

c $C47E called_from_main_loop_6

c $C4E0 sub_C4E0

c $C5D3 reset_object

c $C651 sub_C651

c $C6A0 move_characters
U $C6FD,2 UNUSED?
C $C6FF

c $C79A sub_C79A [leaf]

c $C7B9 get_character_struct

; ------------------------------------------------------------------------------

; Character events and handlers.
;
c $C7C6 character_event.
D $C7C6 Makes characters sit, sleep or other things TBD.
R $C7C6 HL Points to byte holding character index (e.g. 0x76C6).
W $C7F9 Array of (character,index) mappings. (Some of the character indexes look too high though).
W $C829 Array of pointers to event handlers.
C $C83F handler: zero_morale_related
C $C845 handler: sub_C845 -- pop hl, store 3, inc hl, store 21, ret
C $C84C handler: sub_C84C -- morale related
C $C85C handler: morale_related__pop_hl_and_write_10FF_to_it
C $C860 handler: morale_related__pop_hl_and_write_38FF_to_it
C $C864 handler: morale_related__pop_hl_and_write_08FF_to_it
C $C86C handler: pop_hl_and_check_varA13E
C $C877 handler: pop_hl_and_check_varA13E_anotherone
C $C882 handler: pop_hl_and_write_0005_to_it
C $C889 handler: pop_hl_and_player_sits
C $C88D handler: pop_hl_and_player_sleeps

; ------------------------------------------------------------------------------

; called_from_main_loop_5
;
b $C891 (<- called_from_main_loop_5, sub_CA81)
;
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

c $CA11 sub_CA11

c $CA49 sub_CA49

c $CA81 sub_CA81 -- bribes, solitary, food, character enters sound,
U $CB5F,2 two mystery bytes

c $CB75 ld_bc_a

c $CB79 element_A_of_table_7738

c $CB85 increment_word_C41A_low_byte_wrapping_at_15

; ------------------------------------------------------------------------------

c $CB98 solitary
  $CC16 ...
  $CC19 (overlap.$8015) = sprite_prisoner_tl_4;
  $CC1F ...

; ------------------------------------------------------------------------------

c $CC37 guards_follow_suspicious_player
  $CC37 ...
  $CC3E if (*overlap.$8015) == sprite_guard_tl_4 return;  // don't follow the player if he's dressed as a guard
  $CC46 ...

; ------------------------------------------------------------------------------

c $CCAB sub_CCAB

c $CCCD sub_CCCD -- walks item_characterstructs. ignores green key and food items. may decide which items are 'found'.

c $CCFB sub_CCFB -- walks item_characterstructs. ignores red cross parcel. may decide which items are 'found'.

c $CD31 item_discovered

b $CD6A item_data_related (16 groups of 3 bytes)

c $DB9E called_from_main_loop_8

c $DBEB something which uses rotate_A_left_3_widening_to_BC

c $DC41 sub_DC41

c $DD02 sub_DD02

; ------------------------------------------------------------------------------

b $DD69 Item attributes -- 20 bytes, 4 of which are unknown, possibly unused.
D $DD69 'Yellow/black' means yellow ink over black paper, for example.
;
B $DD69 item_attribute: WIRESNIPS - yellow/black
B $DD6A item_attribute: SHOVEL - cyan/black
B $DD6B item_attribute: LOCKPICK - cyan/black
B $DD6C item_attribute: PAPERS - white/black
B $DD6D item_attribute: TORCH - green/black
B $DD6E item_attribute: BRIBE - bright-red/black
B $DD6F item_attribute: UNIFORM - green/black
B $DD70 item_attribute: FOOD - white/black
D $DD70 Food turns purple/black when it's poisoned.
B $DD71 item_attribute: POISON - purple/black
B $DD72 item_attribute: RED KEY - bright-red/black
B $DD73 item_attribute: YELLOW KEY - yellow/black
B $DD74 item_attribute: GREEN KEY - green/black
B $DD75 item_attribute: PARCEL - cyan/black
B $DD76 item_attribute: RADIO - white/black
B $DD77 item_attribute: PURSE - white/black
B $DD78 item_attribute: COMPASS - green/black
B $DD79 item_attribute: Unused? - yellow/black
B $DD7A item_attribute: Unused? - cyan/black
B $DD7B item_attribute: Unused? - bright-red/black
B $DD7C item_attribute: Unused? - bright-red/black

; ------------------------------------------------------------------------------

c $E102 masked sprite plotter [unsure]

c $E29F sub_E29F

c $E2A2 sub_E2A2

c $E34E sub_E34E

c $E3FA sub_E3FA [leaf]

c $E40F sub_E40F [leaf]

c $E420 sub_E420

c $E542 sub_E542

c $E550 rotate_AC_right_3_with_prologue
C $E555 rotate_AC_right_3

c $EED3 plot_game_screen

c $EF9A event_roll_call

; ------------------------------------------------------------------------------

; HOLY SMOKES!
; If you 'use' papers while wearing the uniform by the main gate you can leave
; the camp!
; I NEVER KNEW THAT!

c $EFCB action_papers
  $EFCB [range checking business x in (0x69..0x6D) and y in (0x49..0x4B)]
  $EFDE if ((*overlap.$8015) != sprite_guard_tl_4) goto solitary; // using the papers at the main gate when not in uniform => get sent to solitary
  $EFE8 increase_morale_by_10_score_by_50
  $EFEB (overlap.$801C) = 0; // clear stored room index?
  $EFEF ... must be a transition to outside the gate ...
W $EFF9 word_EFF9 (<- action_papers)

; ------------------------------------------------------------------------------

c $EFFC user confirm

; ------------------------------------------------------------------------------

c $F075 counter of something [unsure]

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
  $F1C6 goto pre_main;

; ------------------------------------------------------------------------------

c $F1E0 plot_menu_text

c $F206 counter_set_0

; ------------------------------------------------------------------------------

c $F257 wipe_full_screen_and_attributes
  $F257 memset(screen, 0, 0x1800);
  $F265 memset(atttributes, attribute_WHITE_OVER_BLACK, 0x300);
  $F26D border = 0; // black
  $F270 return;

; ------------------------------------------------------------------------------

c $F271 select_input_device

b $F303 key tables
B $F303 table_12345
B $F308 table_09876
B $F30D table_QWERT
B $F312 table_POIUY
B $F317 table_ASDFG
B $F31C table_ENTERLKJH
B $F321 table_SHIFTZXCV
B $F326 table_SPACESYMSHFTMNB
w $F32B screen address for chosen key names (5 long)

c $F335 wipe_game_screen

c $F350 choose_keys

c $F408 set_menu_item_attributes

c $F41C input_device_select_keyscan

w $F43D inputroutines -- array [4] of pointers to input routines

b $F445 chosen_input_device -- 0/1/2/3 keyboard/kempston/sinclair/protek

c $F4B7 menu screen

c $F52C get_tuning (music)

c $FDE0 nop
D $FDE0 No-op subroutine.

c $FDE1 loaded
D $FDE1 Very first entry point used to shunt the game image down into its proper position.

u $FDF3 UNUSED

b $FEF4 A block starting with NOPs.

; Input routines (not called directly)
;
; These are relocated into position (addr?) when chosen from the menu screen.
;
c $FE00 inputroutine_keyboard
D $FE00 Input routine: Keyboard.

c $FE47 inputroutine_protek
D $FE47 Input routine: Protek joystick.

c $FE7E inputroutine_kempston
D $FE7E Input routine: Kempston joystick.

c $FEA3 inputroutine_fuller
D $FEA3 Input routine: Fuller joystick. (Unused).

c $FECD inputroutine_sinclair
D $FECD Input routine: Sinclair joystick.

