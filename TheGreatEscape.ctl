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

; ------------------------------------------------------------------------------

b $4000 Screen.

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
D $D1EA #UDGTABLE { #UDGARRAY2,7,4,2;$D1EA-$D21F-1-16{0,0,64,108}(prisoner-top-left-1) | #UDGARRAY2,7,4,2;$D220-$D255-1-16{0,0,64,108}(prisoner-top-left-2) | #UDGARRAY2,7,4,2;$D256-$D28B-1-16{0,0,64,108}(prisoner-top-left-3) | #UDGARRAY2,7,4,2;$D28C-$D2BF-1-16{0,0,64,104}(prisoner-top-left-4) } TABLE#
;
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
; Screenlocstrings are a screen address and a string.
;
b $A5CE Screenlocstrings (screen address + string).
B $A5CE "WELL DONE"
B $A5DA "YOU HAVE ESCAPED"
B $A5ED "FROM THE CAMP"
B $A5FD "AND WILL CROSS THE"
B $A612 "BORDER SUCCESSFULLY"
B $A628 "BUT WERE RECAPTURED"
B $A63E "AND SHOT AS A SPY"
B $A652 "TOTALLY UNPREPARED"
B $A667 "TOTALLY LOST"
B $A676 "DUE TO LACK OF PAPERS"
B $A68E "PRESS ANY KEY"
;
b $F014 menu screenlocstrings.
B $F014 "CONFIRM Y OR N"
;
b $F446 key choice screenlocstrings.
B $F446 "CONTROLS"
B $F451 "0 SELECT"
B $F45C "1 KEYBOARD"
B $F469 "2 KEMPSTON"
B $F476 "3 SINCLAIR"
B $F483 "4 PROTEK"
B $F48E "BREAK OR CAPS AND SPACE"
B $F4A8 "FOR NEW GAME"
;
c $A5BF screenlocstring_plot

; ------------------------------------------------------------------------------

; Messages - messages printed at the bottom of the screen when things happen.
;
b $7DCD Messages (non-ASCII: encoded to match the font; FF terminated).
W $7DCD Array of pointers to messages.
B $7DF5 "MISSED ROLL CALL"
B $7E06 "TIME TO WAKE UP"
B $7E16 "BREAKFAST TIME""
B $7E25 "EXERCISE TIME""
B $7E33 "TIME FOR BED"
B $7E40 "THE DOOR IS LOCKED"
B $7E53 "IT IS OPEN"
B $7E5E "INCORRECT KEY"
B $7E6C "ROLL CALL"
B $7E76 "RED CROSS PARCEL"
B $7E87 "PICKING THE LOCK"
B $7E98 "CUTTING THE WIRE"
B $7EA9 "YOU OPEN THE BOX"
B $7EBA "YOU ARE IN SOLITARY"
B $7ECE "WAIT FOR RELEASE"
B $7EDF "MORALE IS ZERO"
B $7EEE "ITEM DISCOVERED"
B $F026 "HE TAKES THE BRIBE"
B $F039 "AND ACTS AS DECOY"
B $F04B "ANOTHER DAY DAWNS"

; ------------------------------------------------------------------------------

; Counted strings.
;
b $F2AD Key choice prompt strings. (encoded to match font; first byte is count).
W $F2AD choose_keys_screenaddr - holds screen position of 'CHOOSE KEYS' string
B $F2AF counted_string: "CHOOSE KEYS"
W $F2BB holds screen position of 'LEFT' string
B $F2BD counted_string: "LEFT"
W $F2C3 holds screen position of 'RIGHT' string
B $F2C5 counted_string: "RIGHT"
W $F2CC holds screen position of 'UP' string
B $F2CE counted_string: "UP"
W $F2D2 holds screen position of 'DOWN' string
B $F2D4 counted_string: "DOWN"
W $F2DA holds screen position of 'FIRE' string
B $F2DC counted_string: "FIRE"

b $F2EB Counted strings (encoded to match font; first byte is count).
B $F2EB counted_string: "ENTER"
B $F2F1 counted_string: "CAPS"
B $F2F6 counted_string: "SYMBOL"
B $F2FD counted_string: "SPACE"

; ------------------------------------------------------------------------------

; Static tiles.
;
b $7F00 Static tiles (those used on-screen for medals, etc.) 9 bytes each: 8x8 bitmap + 1 byte attribute. 75 tiles.
D $7F00 #UDGARRAY75,6,1;$7F00,7;$7F09;$7F12;$7F1B;$7F24;$7F2D;$7F36;$7F3F;$7F48;$7F51;$7F5A;$7F63;$7F6C;$7F75;$7F7E;$7F87;$7F90;$7F99;$7FA2;$7FAB;$7FB4;$7FBD;$7FC6;$7FCF;$7FD8,7;$7FE1,7;$7FEA,7;$7FF3,7;$7FFC,4;$8005,4;$800E,4;$8017,4;$8020,3;$8029,7;$8032,3;$803B,3;$8044,3;$804D,3;$8056,3;$805F,3;$8068,3;$8071,3;$807A,3;$8083,3;$808C,7;$8095,3;$809E,3;$80A7,3;$80B0,3;$80B9,7;$80C2,7;$80CB;$80D4;$80DD;$80E6;$80EF,5;$80F8,5;$8101,4;$810A,4;$8113,4;$811C,7;$8125,7;$812E;$8137;$8140;$8149;$8152,5;$815B,5;$8164,5;$816D,4;$8176;$817F;$8188;$8191;$819A(static-tiles)
B $7F00,9 blank
; i'm calling these speakers but are they more accurately tannoys?
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
B $7F75,9 speaker_3_tl
B $7F7E,9 speaker_3_tr
B $7F87,9 speaker_3_bl
B $7F90,9 speaker_3_br
B $7F99,9 barbwire_v_top
B $7FA2,9 barbwire_v_bottom
B $7FAB,9 barbwire_h_left
B $7FB4,9 barbwire_h_right
B $7FBD,9 barbwire_h_wide_left
B $7FC6,9 barbwire_h_wide_middle
B $7FCF,9 barbwire_h_wide_right
B $7FD8,9 flagpole_top
B $7FE1,9 flagpole_middle
B $7FEA,9 flagpole_bottom
B $7FF3,9 flagpole_ground1
B $7FFC,9 flagpole_ground2
B $8005,9 flagpole_ground3
B $800E,9 flagpole_ground4
B $8017,9 flagpole_ground0
B $8020,9 medal_0
B $8029,9 medal_1
B $8032,9 medal_2
B $803B,9 medal_3
B $8044,9 medal_4
B $804D,9 medal_14
B $8056,9 medal_5
B $805F,9 medal_6
B $8068,9 medal_7
B $8071,9 medal_8
B $807A,9 medal_9
B $8083,9 medal_10
B $808C,9 medal
B $8095,9 medal
B $809E,9 medal
B $80A7,9 medal
B $80B0,9 medal
B $80B9,9 medal
B $80C2,9 medal
B $80CB,9 medal
B $80D4,9 medal
B $80DD,9 medal
B $80E6,9 medal
B $80EF,9 medal
B $80F8,9 medal
B $8101,9 medal
B $810A,9 medal
B $8113,9 medal
B $811C,9 medal
B $8125,9 medal
B $812E,9 medal
B $8137,9 medal
B $8140,9 medal
B $8149,9 medal
B $8152,9 medal
B $815B,9 medal
B $8164,9 medal
B $816D,9 medal
B $8176,9 medal
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
b $7612 Characters.
D $7612 Array, 26 long, of 7-byte structures.
B $7612 character_0
B $7619 character_1
B $7620 character_2
B $7627 character_3
B $762E character_4
B $7635 character_5
B $763C character_6
B $7643 character_7: prisoner who sleeps at bed position A
B $764A character_8: prisoner who sleeps at bed position B
B $7651 character_9: prisoner who sleeps at bed position C
B $7658 character_10: prisoner who sleeps at bed position D
B $765F character_11: prisoner who sleeps at bed position E
B $7666 character_12: prisoner who sleeps at bed position F (<- perhaps_reset_map_and_characters)
B $766D character_13:
B $7674 character_14:
B $767B character_15:
B $7682 character_16:
B $7689 character_17:
B $7690 character_18: prisoner who sits at bench position D
B $7697 character_19: prisoner who sits at bench position E
B $769E character_20: prisoner who sits at bench position F (<- sub_A289)
B $76A5 character_21: prisoner who sits at bench position A
B $76AC character_22: prisoner who sits at bench position B
B $76B3 character_23: prisoner who sits at bench position C
B $76BA character_24:
B $76C1 character_25:
;
D $77C8 Array, 16 long, of 7-byte structures. These 'characters' seem to be the game items.
B $76C8 (wiresnips) (<- item_to_thing, pick_up_related)
B $76CF (shovel)
B $76D6 (lockpick)
B $76DD (papers)
B $76E4 (torch)
B $76EB (bribe) (<- sub_B107)
B $76F2 (uniform)
B $76F9 (food) (<- action_poison, called_from_main_loop)
B $7700 (poison)
B $7707 (red key)
B $770E (yellow key)
B $7715 (green key)
B $771C (red cross parcel) (<- event_new_red_cross_parcel, new_red_cross_parcel)  is the parcel a 'character'?
B $7723 (radio)
B $772A (purse)
B $7731 (compass)

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

b $EBC5 Table of pointers, 30 long, to byte arrays [unsure]  -- probably tiles
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
b $E55F probably tile data
B $E55F probably tiles
B $E5FF probably tiles
B $E61E probably tiles
B $E6CA probably tiles
B $E74B probably tiles
B $E758 probably tiles
B $E77F probably tiles
B $E796 probably tiles
B $E7AF probably tiles
B $E85C probably tiles
B $E8A3 probably tiles
B $E8F0 probably tiles
B $E92F probably tiles
B $E940 probably tiles
B $E972 probably tiles
B $E99A probably tiles
B $E99F probably tiles
B $E9B9 probably tiles
B $E9C6 probably tiles
B $E9CB probably tiles
B $E9E6 probably tiles
B $E9F5 probably tiles
B $EA0E probably tiles
B $EA2B probably tiles
B $EA35 probably tiles
B $EA43 probably tiles
B $EA4A probably tiles
B $EA53 probably tiles
B $EA5D probably tiles
B $EA67 probably tiles

b $EA74 (<- sub_68A2)

; ------------------------------------------------------------------------------

b $5B00 unknown - probably map data
b $68A0 indoor_room_index (zero if outdoors)
b $68A1 current_door
b $69A0 unknown - fourteen bytes long
w $6B79 pointers to six beds (beds of active prisoners) (note that the top hut has prisoners permanently in bed)
w $6B85 four byte structures (which are ranged checked by routine at #R$B29F)
u $81A3 UNUSED?
b $A69E bitmap font: 0..9, A..Z (omitting O), space, full stop
b $A7C7 plot_game_screen_x
b $AB31 jumptable
b $AE75 searchlight_related (<- a_flag_became_nonzero, searchlight)
w $AE76 word_AE76 (<- a_flag_became_nonzero)
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
b $81BD byte_81BD (<- a_flag_became_nonzero, something_then_decrease_morale)
b $81BE first word of room structure [unsure]
b $81BF byte_81BF (seems to hold many zeroes)
b $81D6 door related (<- indoors maybe, <- open door)
B $81D9 door related (final byte?)
b $81DA unk_81DA (<- select_room_maybe, sub_B916)
b $8213 possibly holds an item
b $8214 byte_8214
w $8215 items held (two byte slots. initialised to 0xFFFF meaning no item in either slot)
b $8217 character_index

b $8218 tiles. starts with building masks.
D $8218 #UDGARRAY1,7,4,1;$8218-$858F-8(exterior-tiles0)
D $8590 #UDGARRAY1,7,4,1;$8590-$8A17-8(exterior-tiles1)
D $8A18 #UDGARRAY1,7,4,1;$8A18-$90F7-8(exterior-tiles2)
D $90F8 #UDGARRAY1,7,4,1;$90F8-$988F-8(exterior-tiles3)
D $9890 #UDGARRAY1,7,4,1;$9890-$9D77-8(interior-tiles0)

B $8218,8 start of mask tiles, could be for hut? (<- sub_A9AD)
B $8590,8 start of hut tiles (<- sub_A9AD)

B $8A18,8 tile: ground1 [start of exterior tiles] (<- sub_A9AD)
B $8A20,8 tile: ground2
B $8A28,8 tile: ground3
B $8A30,8 tile: ground4

B $90F8,8 [start of interior tiles]
B $9768,8 empty tile (<- plot_indoor_tiles, sub_BCAA)

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
b $A146 a_flag [unknown]  seems to be reset each day, might influence which parcels arrive

b $A147 bell ringing bitmaps
B $A147 bell_ringer_bitmap_off
B $A153 bell_ringer_bitmap_on

b $A7C6 used by sub_AAFF

w $AD29 word_AD29

c $B3C4 action_poison
C $B3C4 Load items_held.
C $B3C7 Load item_FOOD.
C $B3C9 Is 'low' slot item_FOOD?
C $B3CA Yes - goto have_food.
C $B3CC Is 'high' slot item_FOOD?
C $B3CD No - return.
C $B3CE have_food: (test a character flag?)
C $B3D1 Bit 5 set?
C $B3D3 Yes - return.
C $B3D4 Set bit 5.
C $B3D6 Set item_attribute: FOOD to bright-purple/black.
C $B3D8
C $B3DB draw_all_items()
C $B3DE goto increase_morale_by_10_score_by_50

b $B53E sixlong_things
b $B54E wiresnips_related_table

b $B819 10 x 3-byte structs
B $B819,30,3 looks_like_character_reset_data -- 10 x 3-byte structs
b $B837 byte_B837
b $B838 byte_B838
w $B839 word_B839

b $BCEE HUGE block of unknown data!

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

w $EFF9 word_EFF9 (<- action papers)
u $EFFB UNUSED?


; ------------------------------------------------------------------------------



c $68A2 sub 68A2 - looks like it's resetting stuff
C $68F4 some_sort_of_initial_setup_maybe (<- main and setup)
46038
c $6920 tunnel_related [unsure]
c $6939 setup_movable_items
c $696A setup_crate
c $6971 setup_stove2
c $6978 setup_stove1
c $69C9 calledby_setup_movable_items
c $69DC sub_69DC
c $6A12 sub_6A12
c $6A27 zero_some_area_407_bytes_long
c $6A35 select_room_maybe
c $6AB5 draw_object_to_tiles [unsure]
c $6B42 plot_indoor_tiles
c $7AC9 check for 'pick up', 'drop' and both 'use item' keypresses
c $7AF0 use_item_B
c $7AF5 use_item_A
c $7B36 pick_up_item
c $7B8B drop_item
c $7C26 item-to-thing
c $7C33 draw_all_items
c $7C46 draw_item
c $7C82 pick_up_related
c $7CBE plot_bitmap
c $7CD4 screen_wipe
c $7CE9 get_next_scanline
c $7D15 queue_message_for_display
c $7D2F plot_glyph_(indirect)
c $7D48 message_timer
c $9D78 main_loop

c $9DCF check_morale (<- main_loop)
C $9DCF if (morale >= 2) return;
C $9DD5 queue_message_for_display(message_MORALE_IS_ZERO);
C $9DDB *(morale_related + 1) = 0xFF; // mystery
C $9DE0 *(morale_related_also) = 0; // mystery
C $9DE4 return;

c $9DE5 check for 'game cancel' keypress
C $9DE5 if (!shift_pressed) return;
C $9DED if (!space_pressed) return;
C $9DF4 screen_reset_perhaps() user_confirm() if (confirmed) looks_like_a_reset_fn()
C $9DFD if (indoor_room_index == 0) loc_B2FC(); else some_sort_of_initial_setup_maybe();

c $9E07 process_user_input
C $9E07 if (morale_related) return; // inhibits user control when morale hits zero
C $9E0E if ((0x8001 & 3) == 0) goto is_zero;
C $9E15 morale_related_also = 31;
C $9E1A if (0x8001 == 1) goto lock_picked;
C $9E1F goto sub_9EB2;
C $9E22 is_zero: counter_of_something();
C $9E25 hl = &morale_related_also; if (? != 0) goto user_input_super(hl);
C $9E2D if (morale_related_also == 0) return;
C $9E30 morale_related_also--; a = 0; goto user_input_fire_not_pressed;

c $9F21 in permitted area?

c $A007 a second in permitted area entry point

c $A035 wave morale flag

c $A071 set morale flag screen attributes

c $A082 call mystery if h AND 7 is zero

c $A095 indoors-only delay loop

c $A09E ring bell

c $A0D2 increase_morale

c $A0E0 decrease_morale

c $A0E9 increase_morale_by_10,_score_by_50

c $A0F2 increase_morale_by_5

c $A11D play speaker

c $A15F set game screen attributes

; ------------------------------------------------------------------------------

b $A173 timed_events array (15 event structures)
  $A173 0, event_another_day_dawns
  $A176 8, event_wake_up
  $A179 12, event_new_red_cross_parcel
  $A17C 16, event_go_to_roll_call
  $A17F 20, event_roll_call
  $A182 21, event_go_to_breakfast_time
  $A185 36, event_breakfast_time
  $A188 46, event_go_to_exercise_time
  $A18B 64, event_exercise_time
  $A18E 74, event_go_to_roll_call
  $A191 78, event_roll_call
  $A194 79, event_go_to_time_for_bed
  $A197 98, event_time_for_bed
  $A19A 100, event_night_time
  $A19D 130, event_search_light

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
  $A344 0x8001 |= (1<<6); 0x8002 = b; 0x8003 = c; return;

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

c $A9AD sub_A9AD

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

b $AB66 Zoombox (scene transition) stuff.
B $AB66 zoombox related 1
B $AB67 zoombox horizontal count
B $AB68 zoombox related 3
B $AB69 zoombox vertical count
B $AB6A zoombox_attribute_value
C $AB6B choose_zoombox_attributes
C $ABA0 zoombox
C $ABF9 zoombox 1
C $AC6F zoombox 2
C $ACFC zoombox draw tile
B $AF5E zoombox_tile_wire_tl
B $AF66 zoombox_tile_wire_hz
B $AF6E zoombox_tile_wire_tr
B $AF76 zoombox_tile_wire_vt
B $AF7E zoombox_tile_wire_br
B $AF86 zoombox_tile_wire_bl

b $AF8E bribe_related

c $AD59 sub_AD59

c $ADBD a_flag_became_nonzero

c $AE78 something_then_decrease_morale_10

c $AEB8 searchlight
B $AF3E bitmap: searchlight shape (circle)

c $AF8F sub_AF8F

c $AFDF sub_AFDF

b $B0F8 four bytes (<- sub_AFDF)

c $B0FC loc_B0FC

c $B107 use_bribe -- 'he takes the bribe' 'and acts as decoy'

c $B14C sub_B14C -- outdoor drawing?

c $B1C7 rotate_A_left_3_widening_to_BC
R $B1C7 A Argument.
R $B1C7 BC Result of A << 3
C $B1C7 result = 0;
C $B1C9 arg <<= 1;
C $B1CA result = (result << 1) + carry;
C $B1CC arg <<= 1;
C $B1CD result = (result << 1) + carry;
C $B1CF arg <<= 1;
C $B1D0 result = (result << 1) + carry;

c $B1D4 is_door_open

c $B1F5 door_handling

c $B252 sub_B252

c $B295 rotate_A_left_2_widening_to_BC

c $B29F sub_B29F

c $B2FC resetty

c $B32D indoors [unsure]

c $B387 action_red_cross_parcel

c $B3A8 action_bribe

c $B3E1 action_uniform

c $B3F6 action_shovel

c $B417 action_wiresnips

c $B495 action_lockpick

c $B4AE action_red_key

c $B4B2 action_yellow_key

c $B4B6 action_green_key

c $B4B8 action_key

c $B4D0 open_door

c $B5CE called_from_main_loop_9

c $B71B reset_something

c $B75A looks_like_a_reset_function [unsure]

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

c $C6A0 called_from_main_loop_4
U $C6FD,2 UNUSED?
C $C6FF

c $C79A sub_C79A [leaf]

c $C7B9 get_character

; ------------------------------------------------------------------------------

; Character events and handlers.
;
c $C7C6 character_event -- makes characters sit or sleep
R $C7C6 HL Points to byte (e.g. 0x76C6)
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
C $C892 called_from_main_loop_5
C $C892 Clear byte_A13E.
C $C896 if (bell) sub_CCAB();
C $C89D if (byte_C891 == 0) goto loc_C8B1;
C $C8A4 if (--byte_C891 == 0) goto loc_C8B1;
C $C8A7 (wipe a flag bit in character data?)
C $C8AA (something gets discovered)
C $C8B1 ...

c $C918 sub_C918

c $CA11 sub_CA11

c $CA49 sub_CA49

c $CA81 sub_CA81 -- bribes, solitary, food, character enters sound,
U $CB5F,2 two mystery bytes

c $CB75 ld_bc_a

c $CB79 element_A_of_table_7738

c $CB85 increment_word_C41A_low_byte_wrapping_at_15

c $CB98 solitary

c $CC37 guards_follow_suspicious_player

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

c $EFCB action: papers

c $EFFC user confirm

c $F075 counter of something [unsure]

c $F163 main

c $F1E0 plot_menu_text

c $F206 counter_set_0

c $F257 wipe_full_screen_and_attributes

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

c $FDE1 pre_main
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

