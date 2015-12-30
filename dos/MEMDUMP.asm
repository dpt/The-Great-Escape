; ---------------------------------------------------------------------------

tinypos				struc ;	(sizeof=0x3)
x				db ?			    ; base 10
y				db ?			    ; base 10
height				db ?			    ; base 10
tinypos				ends

; ---------------------------------------------------------------------------

searchlight_movement_s		struc ;	(sizeof=0x7)
xy				xy ?
step				db ?			    ; base 10
direction			db ?			    ; base 10
counter				db ?			    ; base 10
data				dw ?			    ; offset (00000000)
searchlight_movement_s		ends

; ---------------------------------------------------------------------------

screenstring			struc ;	(sizeof=0x3)
screenaddr			dw ?			    ; base 16
length				db ?			    ; base 10
screenstring			ends

; ---------------------------------------------------------------------------

pos				struc ;	(sizeof=0x6)
x				dw ?			    ; base 10
y				dw ?			    ; base 10
height				dw ?			    ; base 10
pos				ends

; ---------------------------------------------------------------------------

bytetopointer			struc ;	(sizeof=0x3)
byte				db ?			    ; base 16
pointer				dw ?			    ; offset (00000000)
bytetopointer			ends

; ---------------------------------------------------------------------------

sprite				struc ;	(sizeof=0x6)
widthbytes			db ?			    ; base 10
height				db ?			    ; base 10
bitmap				dw ?			    ; offset (00000000)
mask				dw ?			    ; offset (00000000)
sprite				ends

; ---------------------------------------------------------------------------

timedevent			struc ;	(sizeof=0x3)
time				db ?			    ; base 16
event				dw ?			    ; offset (00000000)
timedevent			ends

; ---------------------------------------------------------------------------

xy				struc ;	(sizeof=0x2)
x				db ?			    ; base 10
y				db ?			    ; base 10
xy				ends

; ---------------------------------------------------------------------------

item_struct			struc ;	(sizeof=0x7)
item_and_flags			db ?			    ; base 16
room_and_flags			db ?			    ; base 16
pos				tinypos	?
screenpos			xy ?
item_struct			ends

; ---------------------------------------------------------------------------

default_item_location		struc ;	(sizeof=0x3)
room_and_flags			db ?			    ; base 16
x				db ?			    ; base 10
y				db ?			    ; base 10
default_item_location		ends

; ---------------------------------------------------------------------------

bounds				struc ;	(sizeof=0x4)
x0				db ?			    ; base 10
x1				db ?			    ; base 10
y0				db ?			    ; base 10
y1				db ?			    ; base 10
bounds				ends

; ---------------------------------------------------------------------------

mask				struc ;	(sizeof=0x8)
index				db ?			    ; base 16
bounds				bounds ?
pos				tinypos	?
mask				ends

; ---------------------------------------------------------------------------

mask7				struc ;	(sizeof=0x7)
index				db ?			    ; base 16
bounds				bounds ?
xy				xy ?
mask7				ends

; ---------------------------------------------------------------------------

wall				struc ;	(sizeof=0x6)
minx				db ?			    ; base 10
maxx				db ?			    ; base 10
miny				db ?			    ; base 10
maxy				db ?			    ; base 10
minheight			db ?			    ; base 10
maxheight			db ?			    ; base 10
wall				ends

; ---------------------------------------------------------------------------

movableitem			struc ;	(sizeof=0x9)
pos				pos ?
sprite				dw ?			    ; offset (00000000)
sprite_index			db ?			    ; base 16
movableitem			ends

; ---------------------------------------------------------------------------

vischar_s			struc ;	(sizeof=0x20)
character			db ?			    ; base 16
flags				db ?			    ; base 16
target				xy ?
p04				tinypos	?
counter_and_flags		db ?			    ; base 16
crpbase				dw ?			    ; offset (00000000)
crp				dw ?			    ; offset (00000000)
b0C				db ?			    ; base 16
input				db ?			    ; base 16
direction			db ?			    ; base 16
mi				movableitem ?
scrx				dw ?			    ; base 10
scry				dw ?			    ; base 10
room				db ?			    ; base 10
unused				db ?
width_bytes			db ?			    ; base 10
height				db ?			    ; base 10
vischar_s			ends

; ---------------------------------------------------------------------------

; enum character (width	4 bytes)
character_0_COMMANDANT		 = 0
character_1_GUARD_1		 = 1
character_2_GUARD_2		 = 2
character_3_GUARD_3		 = 3
character_4_GUARD_4		 = 4
character_5_GUARD_5		 = 5
character_6_GUARD_6		 = 6
character_7_GUARD_7		 = 7
character_8_GUARD_8		 = 8
character_9_GUARD_9		 = 9
character_10_GUARD_10		 = 10
character_11_GUARD_11		 = 11
character_12_GUARD_12		 = 12
character_13_GUARD_13		 = 13
character_14_GUARD_14		 = 14
character_15_GUARD_15		 = 15
character_16_GUARD_DOG_1	 = 16
character_17_GUARD_DOG_2	 = 17
character_18_GUARD_DOG_3	 = 18
character_19_GUARD_DOG_4	 = 19
character_20_PRISONER_1		 = 20
character_21_PRISONER_2		 = 21
character_22_PRISONER_3		 = 22
character_23_PRISONER_4		 = 23
character_24_PRISONER_5		 = 24
character_25_PRISONER_6		 = 25
character_26_STOVE_1		 = 26			    ; movable item
character_27_STOVE_2		 = 27			    ; movable item
character_28_CRATE		 = 28			    ; movable item
character_NONE			 = 255

; ---------------------------------------------------------------------------

; enum room (width 4 bytes)
room_0_OUTDOORS			 = 0
room_1_HUT1RIGHT		 = 1
room_2_HUT2LEFT			 = 2
room_3_HUT2RIGHT		 = 3
room_4_HUT3LEFT			 = 4
room_5_HUT3RIGHT		 = 5
room_6				 = 6			    ; unused room
room_7_CORRIDOR			 = 7
room_8_CORRIDOR			 = 8
room_9_CRATE			 = 9
room_10_LOCKPICK		 = 10
room_11_PAPERS			 = 11
room_12_CORRIDOR		 = 12
room_13_CORRIDOR		 = 13
room_14_TORCH			 = 14
room_15_UNIFORM			 = 15
room_16_CORRIDOR		 = 16
room_17_CORRIDOR		 = 17
room_18_RADIO			 = 18
room_19_FOOD			 = 19
room_20_REDCROSS		 = 20
room_21_CORRIDOR		 = 21
room_22_REDKEY			 = 22
room_23_BREAKFAST		 = 23
room_24_SOLITARY		 = 24
room_25_BREAKFAST		 = 25
room_26				 = 26			    ; unused room
room_27				 = 27			    ; unused room
room_28_HUT1LEFT		 = 28
room_29_SECOND_TUNNEL_START	 = 29
room_30				 = 30
room_31				 = 31
room_32				 = 32
room_33				 = 33
room_34				 = 34
room_35				 = 35
room_36				 = 36
room_37				 = 37
room_38				 = 38
room_39				 = 39
room_40				 = 40
room_41				 = 41
room_42				 = 42
room_43				 = 43
room_44				 = 44
room_45				 = 45
room_46				 = 46
room_47				 = 47
room_48				 = 48
room_49				 = 49
room_50_BLOCKED_TUNNEL		 = 50
room_51				 = 51
room_52				 = 52
room_NONE			 = 255

; ---------------------------------------------------------------------------

; enum item
item_WIRESNIPS			 = 0
item_SHOVEL			 = 1
item_LOCKPICK			 = 2
item_PAPERS			 = 3
item_TORCH			 = 4
item_BRIBE			 = 5
item_UNIFORM			 = 6
item_FOOD			 = 7
item_POISON			 = 8
item_RED_KEY			 = 9
item_YELLOW_KEY			 = 10
item_GREEN_KEY			 = 11
item_RED_CROSS_PARCEL		 = 12
item_RADIO			 = 13
item_PURSE			 = 14
item_COMPASS			 = 15
item__LIMIT			 = 16
item_NONE			 = 255

; ---------------------------------------------------------------------------

; enum zoombox_tile
zoombox_tile_TL			 = 0
zoombox_tile_HZ			 = 1
zoombox_tile_TR			 = 2
zoombox_tile_VT			 = 3
zoombox_tile_BR			 = 4
zoombox_tile_BL			 = 5

; ---------------------------------------------------------------------------

; enum message
message_MISSED_ROLL_CALL	 = 0
message_TIME_TO_WAKE_UP		 = 1
message_BREAKFAST_TIME		 = 2
message_EXERCISE_TIME		 = 3
message_TIME_FOR_BED		 = 4
message_THE_DOOR_IS_LOCKED	 = 5
message_IT_IS_OPEN		 = 6
message_INCORRECT_KEY		 = 7
message_ROLL_CALL		 = 8
message_RED_CROSS_PARCEL	 = 9
message_PICKING_THE_LOCK	 = 10
message_CUTTING_THE_WIRE	 = 11
message_YOU_OPEN_THE_BOX	 = 12
message_YOU_ARE_IN_SOLITARY	 = 13
message_WAIT_FOR_RELEASE	 = 14
message_MORALE_IS_ZERO		 = 15
message_ITEM_DISCOVERED		 = 16
message_HE_TAKES_THE_BRIBE	 = 17
message_AND_ACTS_AS_DECOY	 = 18
message_ANOTHER_DAY_DAWNS	 = 19
message_QUEUE_END		 = 255

; ---------------------------------------------------------------------------

; enum interiorobject
interiorobject_STRAIGHT_TUNNEL_SW_NE  =	0
interiorobject_SMALL_TUNNEL_ENTRANCE  =	1
interiorobject_ROOM_OUTLINE_22x12_A  = 2
interiorobject_STRAIGHT_TUNNEL_NW_SE  =	3
interiorobject_TUNNEL_T_JOIN_NW_SE  = 4
interiorobject_PRISONER_SAT_MID_TABLE  = 5
interiorobject_TUNNEL_T_JOIN_SW_NE  = 6
interiorobject_TUNNEL_CORNER_SW_SE  = 7
interiorobject_WIDE_WINDOW_FACING_SE  =	8
interiorobject_EMPTY_BED_FACING_SE  = 9
interiorobject_SHORT_WARDROBE_FACING_SW	 = 10
interiorobject_CHEST_OF_DRAWERS_FACING_SW  = 11
interiorobject_TUNNEL_CORNER_NW_NE  = 12
interiorobject_EMPTY_BENCH	 = 13
interiorobject_TUNNEL_CORNER_NE_SE  = 14
interiorobject_DOOR_FRAME_SE	 = 15
interiorobject_DOOR_FRAME_SW	 = 16
interiorobject_TUNNEL_CORNER_NW_SW  = 17
interiorobject_TUNNEL_ENTRANCE	 = 18
interiorobject_PRISONER_SAT_END_TABLE  = 19
interiorobject_COLLAPSED_TUNNEL_SW_NE  = 20
interiorobject_UNUSED_21	 = 21
interiorobject_CHAIR_FACING_SE	 = 22
interiorobject_OCCUPIED_BED	 = 23
interiorobject_ORNATE_WARDROBE_FACING_SW  = 24
interiorobject_CHAIR_FACING_SW	 = 25
interiorobject_CUPBOARD_FACING_SE  = 26
interiorobject_ROOM_OUTLINE_18x10_A  = 27
interiorobject_UNUSED_28	 = 28
interiorobject_TABLE		 = 29
interiorobject_STOVE_PIPE	 = 30
interiorobject_PAPERS_ON_FLOOR	 = 31
interiorobject_TALL_WARDROBE_FACING_SW	= 32
interiorobject_SMALL_SHELF_FACING_SE  =	33
interiorobject_SMALL_CRATE	 = 34
interiorobject_SMALL_WINDOW_WITH_BARS_FACING_SE	 = 35
interiorobject_TINY_DOOR_FRAME_NE  = 36
interiorobject_NOTICEBOARD_FACING_SE  =	37
interiorobject_DOOR_FRAME_NW	 = 38
interiorobject_UNUSED_39	 = 39
interiorobject_DOOR_FRAME_NE	 = 40
interiorobject_ROOM_OUTLINE_15x8  = 41
interiorobject_CUPBOARD_FACING_SW  = 42
interiorobject_MESS_BENCH	 = 43
interiorobject_MESS_TABLE	 = 44
interiorobject_MESS_BENCH_SHORT	 = 45
interiorobject_ROOM_OUTLINE_18x10_B  = 46
interiorobject_ROOM_OUTLINE_22x12_B  = 47
interiorobject_TINY_TABLE	 = 48
interiorobject_TINY_DRAWERS_FACING_SE  = 49
interiorobject_TALL_DRAWERS_FACING_SW  = 50
interiorobject_DESK_FACING_SW	 = 51
interiorobject_SINK_FACING_SE	 = 52
interiorobject_KEY_RACK_FACING_SE  = 53
interiorobject__LIMIT		 = 54

; ---------------------------------------------------------------------------

; enum sound
sound_CHARACTER_ENTERS_1	 = 2030h
sound_CHARACTER_ENTERS_2	 = 2040h
sound_BELL_RINGER		 = 2530h
sound_PICK_UP_ITEM		 = 3030h
sound_DROP_ITEM			 = 3040h

; ---------------------------------------------------------------------------

; enum input
input_NONE			 = 0
input_UP			 = 1
input_DOWN			 = 2
input_LEFT			 = 3
input_RIGHT			 = 6
input_FIRE			 = 9
input_UP_FIRE			 = 0Ah
input_DOWN_FIRE			 = 0Bh
input_LEFT_FIRE			 = 0Ch
input_RIGHT_FIRE		 = 0Fh

; ---------------------------------------------------------------------------

; enum escapeitem
escapeitem_COMPASS		 = 1
escapeitem_PAPERS		 = 2
escapeitem_PURSE		 = 4
escapeitem_UNIFORM		 = 8

; ---------------------------------------------------------------------------

; enum doorpos
doorpos_FLAGS_MASK_DIRECTION	 = 3
doorpos_FLAGS_MASK_ROOM		 = 0FCh

; ---------------------------------------------------------------------------

; enum vischar
vischar_FLAGS_PICKING_LOCK	 = 1
vischar_FLAGS_CUTTING_WIRE	 = 2
vischar_BYTE7_IMPEDED		 = 20h

; ---------------------------------------------------------------------------

; enum interiorobjecttile
interiorobjecttile_MAX		 = 194
interiorobjecttile_ESCAPE	 = 255

; ---------------------------------------------------------------------------

; enum characterstruct_FLAG
characterstruct_FLAG_DISABLED	 = 40h

; ---------------------------------------------------------------------------

; enum attribute
attribute_BLUE_OVER_BLACK	 = 1
attribute_RED_OVER_BLACK	 = 2
attribute_CYAN_OVER_BLACK	 = 5
attribute_WHITE_OVER_BLACK	 = 7
attribute_BRIGHT_BLUE_OVER_BLACK  = 41h
attribute_BRIGHT_PURPLE_OVER_BLACK  = 43h
attribute_BRIGHT_GREEN_OVER_BLACK  = 44h
attribute_BRIGHT_YELLOW_OVER_BLACK  = 46h

; ---------------------------------------------------------------------------

; enum searchlightstate
searchlight_STATE_0		 = 0
searchlight_STATE_CAUGHT	 = 1Fh
searchlight_STATE_SEARCHING	 = 0FFh

; ---------------------------------------------------------------------------

; enum direction
direction_TOP_LEFT		 = 0
direction_TOP_RIGHT		 = 1
direction_BOTTOM_RIGHT		 = 2
direction_BOTTOM_LEFT		 = 3

;
; +-------------------------------------------------------------------------+
; |   This file	has been generated by The Interactive Disassembler (IDA)    |
; |	   Copyright (c) 2010 by Hex-Rays, <support@hex-rays.com>	    |
; |			 License info: 48-353B-73D4-79			    |
; |		      Graeme Harkness, Metaforic Limited		    |
; +-------------------------------------------------------------------------+
;
; Input	MD5   :	CAB2C61479FC6C12967A3EDF0A7FF832
; Input	CRC32 :	B59F919D

; File Name   :	/Users/dave/SyncProjects/github/The-Great-Escape/not-for-commit/other.platforms/PC-Great Escape	The (1986)(Ocean)/MEMDUMP.BIN
; Format      :	Binary file
; Base Address:	0000h Range: 0000h - 10000h Loaded length: 10000h

				.8086
				.model flat

; ===========================================================================

; Segment type:	Pure code
seg000				segment	byte public 'CODE'
				assume cs:seg000
				assume es:nothing, ss:nothing, ds:nothing
unk_0				db    0			    ; DATA XREF: seg000:ptr_to_door_being_lockpickedo
							    ; seg000:table_7738o
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_18				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_40				db    0			    ; DATA XREF: wipe_full_screen_and_attributes+4r
							    ; wipe_full_screen_and_attributes+Cr ...
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_58				db    0			    ; DATA XREF: user_confirm+2r
							    ; user_confirm+8r ...
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_84				db    0			    ; DATA XREF: menu_screen+Ar
							    ; user_confirm-2r
unk_85				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_FF				db    0

; =============== S U B	R O U T	I N E =======================================


main				proc near
				mov	ax, cs
				mov	ds, ax
				mov	es, ax
				mov	ss, ax
				mov	sp, 0FFFEh
				cld
				call	wipe_full_screen_and_attributes
				mov	al, attribute_BRIGHT_GREEN_OVER_BLACK
				call	set_morale_flag_screen_attributes
				mov	al, attribute_BRIGHT_YELLOW_OVER_BLACK
				call	plot_statics_and_menu_text
				call	plot_score
				call	menu_screen
				call	keyscan_THING1
Construct a table of 256 bit-reversed bytes.
				mov	di, offset reversed ; A	table of 256 bit-reversed bytes.
				mov	dx, 0

loop:							    ; CODE XREF: main+38j
				mov	ax, dx
				mov	cx, 8

flip:							    ; CODE XREF: main+31j
				rcr	ah, 1
				rcl	al, 1
				loop	flip
				stosb			    ; *di = al;
				inc	dh
				or	dh, dh
				jnz	short loop
				mov	di, offset vischar_0 ; Hero's visible character.
				mov	si, offset vischar_initial
				mov	cx, 8

initvischars:						    ; CODE XREF: main+4Cj
				push	cx
				push	si
				mov	cx, 10h
				rep movsw
				pop	si
				pop	cx
				loop	initvischars
				mov	di, offset vischar_0 ; Hero's visible character.
				mov	word ptr [di], 0
				mov	byte ptr [di+1Eh], 3
				mov	byte ptr [di+1Fh], 4
				mov	di, offset mask_buffer ; Mask buffer.
				mov	cx, 8Ch	; 'Œ'
				mov	ax, 0
				rep stosw
				call	reset_game
				call	enter_room
main				endp ; sp-analysis failed

; START	OF FUNCTION CHUNK FOR enter_room

main_loop:						    ; CODE XREF: enter_room:doeventslaterj
							    ; enter_room+29j
				call	check_morale
				call	keyscan_break
				call	message_display
				call	process_player_input
				call	in_permitted_area
				call	called_from_main_loop_3
				call	move_characters
				call	follow_suspicious_character
				call	purge_visible_characters
				call	spawn_characters
				call	mark_nearby_items
				call	ring_bell
				call	called_from_main_loop_9
				call	move_map
				call	message_display
				call	ring_bell
				call	locate_vischar_or_itemstruct_then_plot
				call	plot_game_window
				mov	al, ds:day_or_night
				and	al, al
				jz	short day	    ; new
				call	nighttime

day:							    ; CODE XREF: enter_room-6643j
				call	set_game_window_attributes ; new
				call	ring_bell
				mov	al, ds:room_index
				and	al, al
				jz	short outside
				call	interior_delay_loop

outside:						    ; CODE XREF: enter_room-6633j
				call	wave_morale_flag
				mov	al, ds:game_counter
				and	al, 3Fh
				jnz	short doeventslater
				call	dispatch_timed_event

doeventslater:						    ; CODE XREF: enter_room-6626j
				jmp	short main_loop
; END OF FUNCTION CHUNK	FOR enter_room

; =============== S U B	R O U T	I N E =======================================


interior_delay_loop		proc near		    ; CODE XREF: enter_room-6631p
				mov	cx, 2000h

loop:							    ; CODE XREF: interior_delay_loop:loopj
				loop	loop
				retn
interior_delay_loop		endp

; ---------------------------------------------------------------------------
vischar_initial			vischar_s <0FFh, 0FFh, <44, 1>,	<46, 46, 24>, 0, offset	character_related_pointers, offset character_related_data_8, 0,	0,\
							    ; DATA XREF: main+3Do
					   0, <<0, 0, 24>, offset sprite_prisoner_facing_away_4, 0>, 496, 200, 228, 6, 4, 32>
reversed			db 0, 0, 0, 0, 0, 0, 0,	0   ; DATA XREF: main+22o
							    ; searchlight_plot+36o ...
				db 0, 0, 0, 0, 0, 0, 0,	0   ; A	table of 256 bit-reversed bytes.
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0
vischar_0			vischar_s <0>		    ; DATA XREF: main+3Ao
							    ; main+4Eo	...
							    ; Hero's visible character.
vischar_1			vischar_s 7 dup(<0>)	    ; DATA XREF: follow_suspicious_character:depoisonfoodo
							    ; character_behaviour+73o ...
							    ; NPC visible characters.
mask_buffer			db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
							    ; DATA XREF: main+5Do
							    ; seg000:foreground_mask_pointero ...
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh ; Mask buffer.
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
mask_stuff_thing		dw 0			    ; DATA XREF: mask_stuff+130w
							    ; mask_stuff:loc_8B8Ar
							    ; was $81A0
screen_pointer			dw offset window_buf	    ; DATA XREF: masked_sprite_plotter_24_wide+82r
							    ; masked_sprite_plotter_24_wide+CBw ...
saved_pos			pos <0>			    ; DATA XREF: move_characters+7Eo
							    ; move_characters+8Eo ...
touch_stashed_A			db 0			    ; DATA XREF: touchw
							    ; touch+4Br
unused_049E			db 0			    ; This is called unused_81AB in the	Speccy version.
bitmap_pointer			dw 0			    ; DATA XREF: masked_sprite_plotter_24_wide+20r
							    ; masked_sprite_plotter_24_wide+E6r ...
mask_pointer			dw 0			    ; DATA XREF: masked_sprite_plotter_24_wide+24r
							    ; masked_sprite_plotter_24_wide+EAr ...
foreground_mask_pointer		dw offset mask_buffer	    ; DATA XREF: masked_sprite_plotter_24_wide+7Er
							    ; masked_sprite_plotter_24_wide+C4w ...
							    ; Mask buffer.
tinypos_stash			tinypos	<20, 19, 4>	    ; DATA XREF: guards_follow_suspicious_character+25o
							    ; guards_follow_suspicious_character+2Eo ...
map_position_related		xy <62,	25>		    ; DATA XREF: called_from_main_loop_3+26w
							    ; called_from_main_loop_3+86r ...
flip_sprite			db 0			    ; DATA XREF: masked_sprite_plotter_24_wide+35r
							    ; masked_sprite_plotter_24_wide+5Er ...
hero_map_position		tinypos	<0>		    ; DATA XREF: character_behaviour:loc_5411r
							    ; event_roll_call+3o ...
map_position			dw 3874h		    ; DATA XREF: get_supertiles+1Dr
							    ; plot_topmost_tiles+15r ...
searchlight_state		db 0			    ; DATA XREF: locate_vischar_or_itemstruct_then_plot+12r
							    ; searchlight_mask_test+1Co ...
roomdef_bounds_index		db 0			    ; DATA XREF: bounds_check:interior_bounds_checkr
							    ; setup_room+15o
roomdef_object_bounds_count	db 0			    ; DATA XREF: bounds_check+182o
roomdef_object_bounds		db 0, 0, 0, 0
				db 0, 0, 0, 0
				db 0, 0, 0, 0
				db 0, 0, 0, 0
unused_04C3			db 0, 0, 0, 0, 0, 0	    ; This is called unused_81D0 in the	Speccy version.
doors_related			db 0FFh, 0FFh, 0FFh, 0FFh   ; DATA XREF: door_handling:loc_7C93o
							    ; open_door+42o ...
interior_mask_data_count	db 0			    ; DATA XREF: setup_room:loc_87F2o
							    ; mask_stuff:indoorso
interior_mask_data		mask <0>
				mask <0>
				mask <0>
				mask <0>
				mask <0>
				mask <0>
				mask <0>
saved_item			db 0			    ; DATA XREF: setup_item_plotting+2w
item_height			db 0			    ; DATA XREF: setup_item_plotting+26w
							    ; item_visible+4Br
items_held			dw 0FF05h		    ; DATA XREF: reset_game_continued+2Fw
							    ; accept_bribe+Eo ...
character_index			db 0			    ; DATA XREF: move_characters+5r
							    ; move_characters:doesntwrapw ...
game_counter			db 2Eh			    ; DATA XREF: enter_room-662Br
							    ; wave_morale_flago ...
unused_050C			db 0Ah			    ; This is called unused_A131 in the	Speccy version.
score_digits			db 0, 0, 0, 0, 0	    ; DATA XREF: reset_game_continued+11o
							    ; plot_scoreo ...
hero_in_breakfast		db 0			    ; DATA XREF: breakfast_time+2r
							    ; breakfast_time+16w ...
red_flag			db 0			    ; DATA XREF: follow_suspicious_character+44r
							    ; follow_suspicious_character+70r ...
automatic_player_counter	db 0			    ; DATA XREF: follow_suspicious_character+4Br
							    ; follow_suspicious_character+7Er ...
morale_1_2			dw 0			    ; DATA XREF: follow_suspicious_character+77r
							    ; set_hero_target_locationr ...
							    ; The Speccy .skool	file version has these as separate bytes.
morale				db 112			    ; DATA XREF: wave_morale_flag+Cr
							    ; check_moraler ...
clock				db 7			    ; DATA XREF: dispatch_timed_evento
							    ; in_permitted_area:loc_6871r ...
entered_move_characters		db 0			    ; DATA XREF: follow_suspicious_character+2w
							    ; wassub_A3BB+1w ...
hero_in_bed			db 0FFh			    ; DATA XREF: event_night_timer
							    ; wake_up+7r ...
ptr_to_door_being_lockpicked	dw offset unk_0		    ; DATA XREF: process_player_input+B6r
							    ; action_lockpick+5w
player_locked_out_until		db 0			    ; DATA XREF: process_player_input+ADr
							    ; process_player_input:snipping_wirer ...
day_or_night			db 0			    ; DATA XREF: enter_room-6648r
							    ; event_night_time:loc_6254w ...
room_index			db 0			    ; DATA XREF: enter_room-6638r
							    ; character_behaviour+92r ...
current_door			db 0			    ; DATA XREF: is_door_lockedr
							    ; door_handling+3Dw ...
food_discovered_counter		db 0			    ; DATA XREF: follow_suspicious_character:loc_5373o
							    ; character_behaviour:loc_559Cw
searchlight_mask_test_result	db 0			    ; DATA XREF: searchlight_mask_test+17w
							    ; searchlight_mask_test:still_in_searchlightw ...
							    ; This is new over the Speccy version.
mask_stuff_x			db 0			    ; DATA XREF: mask_stuff+7Fw
							    ; mask_stuff+97w ...
mask_stuff_y			db 0			    ; DATA XREF: mask_stuff+C5w
							    ; mask_stuff+DDw ...
mask_stuff_height		dw 0			    ; DATA XREF: mask_stuff+D5w
							    ; mask_stuff:loc_8AFAw ...
							    ; Odd: this	gets used both as a byte and a word...
game_window_offset		dw 0			    ; DATA XREF: move_map:loc_5F9Cw
							    ; plot_game_window+15r ...
map_buf				db 0, 0, 0, 0, 0, 0, 0	    ; DATA XREF: get_supertiles+2Ao
							    ; plot_topmost_tiles+3o ...
				db 0, 0, 0, 0, 0, 0, 0	    ; 7x5
				db 0, 0, 0, 0, 0, 0, 0
				db 0, 0, 0, 0, 0, 0, 0
				db 0, 0, 0, 0, 0, 0, 0
tile_buf			db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
							    ; DATA XREF: plot_topmost_tileso
							    ; plot_all_tileso ...
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
window_buf			db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
							    ; DATA XREF: seg000:screen_pointero
							    ; plot_topmost_tiles+9o ...
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
unk_12E4			db    0			    ; DATA XREF: plot_bottommost_tiles+Ao
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_13A2			db    0			    ; DATA XREF: move_map_down_left+26o
							    ; move_map_up_right+48o
unk_13A3			db    0			    ; DATA XREF: move_map_up_right+4Bo
							    ; move_map_down_right+22o
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_141E			db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_1916			db    0			    ; DATA XREF: draw_all_itemso
				db    0
				db    0
				db    0
				db    0
				db    0
unk_191C			db    0			    ; DATA XREF: draw_all_items+9o
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
message_text_screen_address	db    0			    ; DATA XREF: message_display+19o
							    ; message_display+47o
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_2064			db    0			    ; DATA XREF: plot_game_window+1Co
							    ; set_game_window_attributes+12o ...
				db    0
				db    0
unk_2067			db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
unk_3874			db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
screenaddr_bell_ringer		db    0			    ; DATA XREF: plot_ringero
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0

; =============== S U B	R O U T	I N E =======================================


follow_suspicious_character	proc near		    ; CODE XREF: enter_room-6669p
				xor	al, al
				mov	ds:entered_move_characters, al
				mov	al, ds:bell
				and	al, al
				jnz	short loc_5373
				call	hostiles_persue

loc_5373:						    ; CODE XREF: follow_suspicious_character+Aj
				mov	bx, offset food_discovered_counter
				mov	al, [bx]
				and	al, al
				jz	short depoisonfood
				dec	byte ptr [bx]
				jnz	short depoisonfood
				mov	bx, offset item_struct_7_food
				and	byte ptr [bx], 0DFh
				mov	cl, 7
				call	item_discovered

depoisonfood:						    ; CODE XREF: follow_suspicious_character+16j
							    ; follow_suspicious_character+1Aj
				mov	bp, offset vischar_1 ; NPC visible characters.
				mov	cx, 7

loc_5391:						    ; CODE XREF: follow_suspicious_character+6Ej
				push	cx
				mov	al, ds:[bp+1]
				cmp	al, 0FFh
				jz	short loc_53CE
				mov	al, ds:[bp+0]
				and	al, 1Fh
				cmp	al, character_20_PRISONER_1
				jnb	short loc_53CB
				push	ax
				call	is_item_discoverable
				test	ds:red_flag, 0FFh
				jnz	short loc_53B4
				test	ds:automatic_player_counter, 0FFh

loc_53B4:						    ; CODE XREF: follow_suspicious_character+49j
				jz	short loc_53B9
				call	guards_follow_suspicious_character

loc_53B9:						    ; CODE XREF: follow_suspicious_character:loc_53B4j
				pop	ax
				cmp	al, 0Fh
				jb	short loc_53CB
				mov	bx, bp
				inc	bx
				test	ds:item_struct_7_food.room_and_flags, 80h
				jz	short loc_53CB
				mov	byte ptr [bx], 3

loc_53CB:						    ; CODE XREF: follow_suspicious_character+3Ej
							    ; follow_suspicious_character+58j ...
				call	character_behaviour

loc_53CE:						    ; CODE XREF: follow_suspicious_character+34j
				pop	cx
				add	bp, 20h	; ' '
				loop	loc_5391
				test	ds:red_flag, 0FFh
				jnz	short locret_53F0
				test	byte ptr ds:morale_1_2,	0FFh
				jnz	short loc_53EA
				test	ds:automatic_player_counter, 0FFh
				jz	short loc_53EA
				retn
; ---------------------------------------------------------------------------

loc_53EA:						    ; CODE XREF: follow_suspicious_character+7Cj
							    ; follow_suspicious_character+83j
				mov	bp, offset vischar_0 ; Hero's visible character.
				call	character_behaviour

locret_53F0:						    ; CODE XREF: follow_suspicious_character+75j
				retn
follow_suspicious_character	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


character_behaviour		proc near		    ; CODE XREF: follow_suspicious_character:loc_53CBp
							    ; follow_suspicious_character+89p ...

; FUNCTION CHUNK AT 556B SIZE 000000C5 BYTES
; FUNCTION CHUNK AT 968B SIZE 000000A5 BYTES

				mov	al, [bp+7]
				mov	ch, al
				and	al, 0Fh
				jz	short loc_5400
				dec	ch
				mov	[bp+7],	ch
				retn
; ---------------------------------------------------------------------------

loc_5400:						    ; CODE XREF: character_behaviour+7j
				mov	bx, bp
				inc	bx
				mov	al, [bp+1]
				and	al, al
				jnz	short loc_540D
				jmp	loc_549C
; ---------------------------------------------------------------------------

loc_540D:						    ; CODE XREF: character_behaviour+17j
				cmp	al, 1
				jnz	short loc_541A

loc_5411:						    ; CODE XREF: character_behaviour+32j
				mov	ax, word ptr ds:hero_map_position.x
				mov	[bp+4],	ax
				jmp	loc_54A3
; ---------------------------------------------------------------------------

loc_541A:						    ; CODE XREF: character_behaviour+1Ej
				cmp	al, 2
				jnz	short loc_542D
				mov	al, ds:automatic_player_counter
				and	al, al
				jnz	short loc_5411
				mov	byte ptr [bp+1], 0
				inc	bx
				jmp	wassub_CB23
; ---------------------------------------------------------------------------

loc_542D:						    ; CODE XREF: character_behaviour+2Bj
				cmp	al, 3
				jnz	short loc_5455
				push	bx
				mov	bx, offset item_struct_7_food.room_and_flags
				test	byte ptr [bx], 80h
				jz	short loc_5443
				mov	ax, [bx+1]
				mov	[bp+4],	ax
				pop	bx
				jmp	short loc_54A3
; ---------------------------------------------------------------------------

loc_5443:						    ; CODE XREF: character_behaviour+47j
				xor	al, al
				mov	[bp+1],	al
				mov	byte ptr [bp+2], 0FFh
				mov	byte ptr [bp+3], 0
				pop	bx
				inc	bx
				jmp	wassub_CB23
; ---------------------------------------------------------------------------

loc_5455:						    ; CODE XREF: character_behaviour+3Ej
				cmp	al, 4
				jnz	short loc_549C
				push	bx
				mov	al, ds:bribed_character
				cmp	al, 0FFh
				jz	short loc_5470
				mov	cx, 7
				mov	bx, offset vischar_1 ; NPC visible characters.

loc_5467:						    ; CODE XREF: character_behaviour+7Dj
				cmp	al, [bx]
				jz	short loc_5479
				add	bx, 20h	; ' '
				loop	loc_5467

loc_5470:						    ; CODE XREF: character_behaviour+6Ej
				pop	bx
				mov	byte ptr [bp+1], 0
				inc	bx
				jmp	wassub_CB23
; ---------------------------------------------------------------------------

loc_5479:						    ; CODE XREF: character_behaviour+78j
				add	bx, 0Fh
				mov	si, bx
				pop	di
				push	di
				add	di, 3
				mov	al, ds:room_index
				and	al, al
				jnz	short loc_548F
				call	pos_to_tinypos
				jmp	short loc_5499
; ---------------------------------------------------------------------------

loc_548F:						    ; CODE XREF: character_behaviour+97j
				mov	ax, [bx]
				mov	[di], al
				mov	ax, [bx+2]
				mov	[di+1],	al

loc_5499:						    ; CODE XREF: character_behaviour+9Cj
				pop	bx
				jmp	short loc_54A3
; ---------------------------------------------------------------------------

loc_549C:						    ; CODE XREF: character_behaviour+19j
							    ; character_behaviour+66j
				mov	al, [bp+2]
				and	al, al
				jz	short character_behaviour_end_1

loc_54A3:						    ; CODE XREF: character_behaviour+26j
							    ; character_behaviour+50j ...
				mov	al, [bx]
				push	bx
				mov	cl, al
				mov	al, ds:room_index
				and	al, al
				jz	short loc_54B3
				mov	al, 6
				jmp	short loc_54BE
; ---------------------------------------------------------------------------

loc_54B3:						    ; CODE XREF: character_behaviour+BCj
				test	cl, 40h
				jz	short loc_54BC
				mov	al, 2
				jmp	short loc_54BE
; ---------------------------------------------------------------------------

loc_54BC:						    ; CODE XREF: character_behaviour+C5j
				mov	al, 0

loc_54BE:						    ; CODE XREF: character_behaviour+C0j
							    ; character_behaviour+C9j
				mov	byte ptr ds:loc_54FB+1,	al
				mov	byte ptr ds:loc_5535+1,	al
				pop	bx
				test	byte ptr [bp+7], 20h
				jnz	short loc_54E6
				inc	bx
				inc	bx
				inc	bx
				call	move_character_x
				jnz	short character_behaviour_end_1
				call	move_character_y
				jnz	short character_behaviour_end_1
				jmp	bribes_solitary_food
; ---------------------------------------------------------------------------

character_behaviour_end_1:				    ; CODE XREF: character_behaviour+B0j
							    ; character_behaviour+E0j ...
				cmp	al, [bp+0Dh]
				jz	short exit
				or	al, 80h
				mov	[bp+0Dh], al

exit:							    ; CODE XREF: character_behaviour+EDj
				retn
; ---------------------------------------------------------------------------

loc_54E6:						    ; CODE XREF: character_behaviour+D8j
				add	bx, 4
				call	move_character_y
				jnz	short character_behaviour_end_1
				call	move_character_x
				jnz	short character_behaviour_end_1
				dec	bx
				jmp	short bribes_solitary_food
character_behaviour		endp

; ---------------------------------------------------------------------------
				nop			    ; odd

; =============== S U B	R O U T	I N E =======================================


move_character_x		proc near		    ; CODE XREF: character_behaviour+DDp
							    ; character_behaviour+FDp

; FUNCTION CHUNK AT 5527 SIZE 0000000A BYTES

				mov	al, [bx]
				xor	ah, ah

loc_54FB:						    ; DATA XREF: character_behaviour:loc_54BEw
				jmp	short $+2
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				add	bx, 0Bh
				mov	dx, [bx]
				sub	dx, ax
				jz	short loc_5527
				js	short loc_551A
				and	dh, dh
				jnz	short loc_5517
				cmp	dl, 3
				jb	short loc_5527

loc_5517:						    ; CODE XREF: move_character_x+19j
				mov	al, 8
				retn
; ---------------------------------------------------------------------------

loc_551A:						    ; CODE XREF: move_character_x+15j
				cmp	dh, 0FFh
				jnz	short loc_5524
				cmp	dl, 0FEh ; 'þ'
				jnb	short loc_5527

loc_5524:						    ; CODE XREF: move_character_x+26j
				mov	al, 4
				retn
move_character_x		endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR move_character_x

loc_5527:						    ; CODE XREF: move_character_x+13j
							    ; move_character_x+1Ej ...
				sub	bx, 0Ah
				or	byte ptr [bp+7], vischar_BYTE7_IMPEDED
				xor	al, al
				retn
; END OF FUNCTION CHUNK	FOR move_character_x

; =============== S U B	R O U T	I N E =======================================


move_character_y		proc near		    ; CODE XREF: character_behaviour+E2p
							    ; character_behaviour+F8p
				mov	al, [bx]
				xor	ah, ah

loc_5535:						    ; DATA XREF: character_behaviour+D0w
				jmp	short $+2
				shl	ax, 1		    ; inlined divide_by_8
				shl	ax, 1
				shl	ax, 1
				add	bx, 0Ch
				mov	dx, [bx]
				sub	dx, ax
				jz	short loc_5561
				js	short loc_5554
				and	dh, dh
				jnz	short loc_5551
				cmp	dl, 3
				jb	short loc_5561

loc_5551:						    ; CODE XREF: move_character_y+19j
				mov	al, 5
				retn
; ---------------------------------------------------------------------------

loc_5554:						    ; CODE XREF: move_character_y+15j
				cmp	dh, 0FFh
				jnz	short loc_555E
				cmp	dl, 0FEh ; 'þ'
				jnb	short loc_5561

loc_555E:						    ; CODE XREF: move_character_y+26j
				mov	al, 7
				retn
; ---------------------------------------------------------------------------

loc_5561:						    ; CODE XREF: move_character_y+13j
							    ; move_character_y+1Ej ...
				sub	bx, 0Dh
				and	byte ptr [bp+7], 0DFh ;	vischar_BYTE7_IMPEDED
				xor	al, al
				retn
move_character_y		endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR character_behaviour

bribes_solitary_food:					    ; CODE XREF: character_behaviour+E7j
							    ; character_behaviour+103j
				mov	al, [bp+1]
				mov	cl, al
				and	al, 3Fh		    ; vischar_FLAGS_MASK
				jz	short loc_55A9
				cmp	al, 1		    ; vischar_FLAGS_BRIBE_PENDING
				jnz	short loc_5586
				mov	al, ds:bribed_character
				cmp	al, [bp+0]
				jnz	short gotosolitary
				jmp	accept_bribe
; ---------------------------------------------------------------------------

gotosolitary:						    ; CODE XREF: character_behaviour+18Dj
				jmp	solitary
; ---------------------------------------------------------------------------

loc_5586:						    ; CODE XREF: character_behaviour+185j
				cmp	al, 2		    ; vischar_FLAGS_BIT1
				jz	short locret_558E
				cmp	al, 4		    ; vischar_FLAGS_SAW_BRIBE
				jnz	short loc_558F

locret_558E:						    ; CODE XREF: character_behaviour+197j
				retn
; ---------------------------------------------------------------------------

loc_558F:						    ; CODE XREF: character_behaviour+19Bj
				push	bx
				mov	bx, offset item_struct_7_food
				test	byte ptr [bx], 20h  ; itemstruct_ITEM_FLAG_POISONED
				mov	al, 20h	; ' '
				jz	short loc_559C
				mov	al, 0FFh

loc_559C:						    ; CODE XREF: character_behaviour+1A7j
				mov	ds:food_discovered_counter, al
				pop	bx
				dec	bx
				dec	bx
				xor	al, al
				mov	[bx], al
				jmp	character_behaviour_end_1
; ---------------------------------------------------------------------------

loc_55A9:						    ; CODE XREF: character_behaviour+181j
				test	cl, 40h
				jz	short loc_5618
				dec	bx
				mov	cl, [bx]
				dec	bx
				mov	al, [bx]
				push	bx
				call	element_A_of_table_7738
				mov	bx, dx
				mov	al, bl
				add	al, cl
				mov	bl, al
				jnb	short loc_55C4
				inc	bh

loc_55C4:						    ; CODE XREF: character_behaviour+1CFj
				mov	al, [bx]
				pop	bx
				test	byte ptr [bx], 80h
				jz	short loc_55CE
				xor	al, 80h

loc_55CE:						    ; CODE XREF: character_behaviour+1D9j
				push	ax
				mov	al, [bx]
				inc	bl
				test	al, 80h
				jz	short loc_55DB
				dec	byte ptr [bx]
				dec	byte ptr [bx]

loc_55DB:						    ; CODE XREF: character_behaviour+1E4j
				inc	byte ptr [bx]
				pop	ax
				call	get_door_position
				mov	al, [bx]
				rcr	al, 1
				rcr	al, 1
				and	al, 3Fh
				mov	[bp+1Ch], al
				mov	al, [bx]
				and	al, 3
				cmp	al, 2
				jnb	short loc_55F9
				add	bx, 5
				jmp	short loc_55FC
; ---------------------------------------------------------------------------

loc_55F9:						    ; CODE XREF: character_behaviour+201j
				dec	bx
				dec	bx
				dec	bx

loc_55FC:						    ; CODE XREF: character_behaviour+206j
				push	bx
				mov	bx, bp
				cmp	bx, offset vischar_0 ; Hero's visible character.
				jnz	short loc_560D
				inc	bx
				and	byte ptr [bx], 0BFh ; was vischar_FLAGS_BIT6
				inc	bx
				call	wassub_CB23

loc_560D:						    ; CODE XREF: character_behaviour+212j
				pop	bx
				call	transition
				mov	cx, sound_CHARACTER_ENTERS_1
				call	play_speaker
				retn
; ---------------------------------------------------------------------------

loc_5618:						    ; CODE XREF: character_behaviour+1BBj
				dec	bx
				dec	bx
				mov	al, [bx]
				cmp	al, 0FFh
				jz	short loc_562C
				inc	bx
				test	al, 80h		    ; vischar_BYTE2_BIT7
				jz	short loc_5629
				dec	byte ptr [bx]
				dec	byte ptr [bx]

loc_5629:						    ; CODE XREF: character_behaviour+232j
				inc	byte ptr [bx]
				dec	bx		    ; was fallthrough

loc_562C:						    ; CODE XREF: character_behaviour+22Dj
				call	wassub_CB23
				retn
; END OF FUNCTION CHUNK	FOR character_behaviour

; =============== S U B	R O U T	I N E =======================================


menu_screen			proc near		    ; CODE XREF: main+1Cp
				in	al, 61h		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				and	al, 0FCh
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd

menu_screen_loop:					    ; CODE XREF: menu_screen+8Dj
				mov	ah, 6
				mov	dl, 0FFh
				int	21h		    ; DOS - DIRECT CONSOLE I/O CHARACTER OUTPUT
							    ; DL = character <>	FFh
							    ;  Return: ZF set =	no character
							    ;	ZF clear = character recieved, AL = character
				jz	short waveflagetc
				retn
; ---------------------------------------------------------------------------

waveflagetc:						    ; CODE XREF: menu_screen+Cj
				call	wave_morale_flag

music0:							    ; CODE XREF: menu_screen+29j
				mov	si, ds:music_channel0_index
				inc	ds:music_channel0_index
				mov	bx, offset music_channel0_data
				mov	al, [bx+si]
				cmp	al, 0FFh
				jnz	short loc_565B
				mov	ds:music_channel0_index, 0
				jmp	short music0
; ---------------------------------------------------------------------------

loc_565B:						    ; CODE XREF: menu_screen+21j
				call	get_tuning
				push	ax

music1:							    ; CODE XREF: menu_screen+46j
				mov	si, ds:music_channel1_index
				inc	ds:music_channel1_index
				mov	bx, offset music_channel1_data
				mov	al, [bx+si]
				cmp	al, 0FFh
				jnz	short loc_5678
				mov	ds:music_channel1_index, 0
				jmp	short music1
; ---------------------------------------------------------------------------

loc_5678:						    ; CODE XREF: menu_screen+3Ej
				call	get_tuning
				mov	dx, ax
				pop	bx
				cmp	al, 0FFh
				jnz	short loc_5684
				mov	dx, bx

loc_5684:						    ; CODE XREF: menu_screen+50j
				mov	ds:word_56D2, bx
				mov	ds:word_56D4, dx
				in	al, 61h		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				mov	ah, al
				mov	ds:music_speed_counter,	18h

loc_5695:						    ; CODE XREF: menu_screen+8Bj
				mov	cx, 0FFh

loc_5698:						    ; CODE XREF: menu_screen:loc_56B5j
				dec	bx
				jnz	short loc_56A3
				xor	al, 2
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				mov	bx, ds:word_56D2

loc_56A3:						    ; CODE XREF: menu_screen+69j
				push	bx
				pop	bx
				dec	dx
				jnz	short loc_56B5
				xor	ah, 2
				xchg	al, ah
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				xchg	al, ah
				mov	dx, ds:word_56D4

loc_56B5:						    ; CODE XREF: menu_screen+76j
				loop	loc_5698
				dec	ds:music_speed_counter
				jnz	short loc_5695
				jmp	menu_screen_loop
menu_screen			endp


; =============== S U B	R O U T	I N E =======================================


get_tuning			proc near		    ; CODE XREF: menu_screen:loc_565Bp
							    ; menu_screen:loc_5678p
				add	al, al
				mov	bx, offset music_tuning_table
				cbw
				add	bx, ax
				mov	ax, [bx]
				inc	al
				retn
get_tuning			endp

; ---------------------------------------------------------------------------
music_channel0_index		dw 12Eh			    ; DATA XREF: menu_screen:music0r
							    ; menu_screen+16w ...
music_channel1_index		dw 12Eh			    ; DATA XREF: menu_screen:music1r
							    ; menu_screen+33w ...
music_speed_counter		db 0Dh			    ; DATA XREF: menu_screen+60w
							    ; menu_screen+87w
word_56D2			dw 0FEFFh		    ; DATA XREF: menu_screen:loc_5684w
							    ; menu_screen+6Fr
word_56D4			dw 0FEFFh		    ; DATA XREF: menu_screen+58w
							    ; menu_screen+81r
music_channel0_data		db  13h,   0, 14h,   0,	  0, 15h, 16h,	 0
							    ; DATA XREF: menu_screen+1Ao
				db  1Bh,   0,	0,   0,	  0,   0,   0,	 0
				db  16h,   0, 1Fh,   0,	  0, 1Dh, 1Bh,	 0
				db  18h,   0,	0,   0,	  0,   0,   0,	 0
				db    0,   0,	0,   0,	  0,   0, 1Dh,	 0
				db    0,   0, 1Dh,   0,	  0, 1Bh, 1Ah,	 0
				db  1Bh,   0, 1Ah,   0,	18h,   0, 16h,	 0
				db  13h,   0,	0,   0,	  0,   0,   0,	 0
				db  13h,   0, 14h,   0,	  0, 15h, 16h,	 0
				db  1Bh,   0,	0,   0,	  0,   0,   0,	 0
				db  16h,   0, 1Fh,   0,	  0, 1Dh, 1Bh,	 0
				db  18h,   0,	0,   0,	  0,   0,   0,	 0
				db    0,   0,	0,   0,	  0,   0, 1Dh,	 0
				db    0,   0, 1Dh,   0,	  0, 1Bh, 1Ah,	 0
				db  16h,   0,	0,   0,	1Dh,   0, 1Bh,	 0
				db    0,   0, 1Fh,   0,	  0, 1Dh, 1Bh,	 0
				db  19h,   0, 18h,   0,	16h,   0, 1Bh,	 0
				db    0,   0, 1Bh,   0,	1Dh,   0, 1Bh,	 0
				db  19h,   0, 18h,   0,	19h,   0, 1Bh,	 0
				db    0,   0, 24h,   0,	  0,   0, 24h,	 0
				db    0,   0, 22h,   0,	  0,   0, 20h,	 0
				db    0,   0,	0,   0,	  0,   0, 1Dh,	 0
				db    0,   0,	0,   0,	  0,   0, 1Bh,	 0
				db    0,   0, 1Bh,   0,	  0, 1Dh, 1Bh,	 0
				db  19h,   0, 18h,   0,	16h,   0, 1Bh,	 0
				db    0,   0, 1Bh,   0,	1Dh,   0, 1Bh,	 0
				db  19h,   0, 18h,   0,	19h,   0, 1Bh,	 0
				db    0,   0, 24h,   0,	  0,   0, 20h,	 0
				db  1Fh,   0, 20h,   0,	21h,   0, 22h,	 0
				db    0,   0, 1Dh,   0,	  0,   0, 1Fh,	 0
				db    0,   0, 20h,   0,	  0,   0, 22h,	 0
				db    0,   0, 22h,   0,	  0, 20h, 1Fh,	 0
				db  1Bh,   0, 1Dh,   0,	1Fh,   0, 20h,	 0
				db    0,   0,	0,   0,	22h,   0, 24h,	 0
				db    0,   0, 20h,   0,	  0,   0, 1Fh,	 0
				db  20h,   0, 22h,   0,	1Bh, 1Dh, 1Fh,	 0
				db  20h,   0, 22h,   0,	24h,   0, 25h,	 0
				db    0,   0, 22h,   0,	  0,   0, 24h,	 0
				db    0,   0, 20h,   0,	  0,   0, 22h,	 0
				db    0,   0, 1Bh,   0,	  0, 1Dh, 1Bh,	 0
				db  19h,   0, 18h,   0,	19h,   0, 1Bh,	 0
				db    0,   0, 1Bh,   0,	1Dh,   0, 1Bh,	 0
				db  19h,   0, 18h,   0,	19h,   0, 1Bh,	 0
				db    0,   0, 27h,   0,	  0,   0, 27h,	 0
				db    0,   0, 25h,   0,	  0,   0, 24h,	 0
				db  1Bh, 1Bh, 1Ah,   0,	1Bh,   0, 22h,	 0
				db  1Bh, 1Bh, 1Ah,   0,	1Bh,   0, 20h,	 0
				db  1Bh,   0, 18h,   0,	1Bh,   0, 14h,	 0
				db  1Dh,   0, 1Eh,   0,	1Fh,   0, 20h,	 0
				db    0,   0, 20h,   0,	  0,   0,   0,	 0
				db  20h,   0, 22h,   0,	24h,   0, 25h,	 0
				db    0,   0, 29h,   0,	  0,   0,   0,	 0
				db    0,   0, 29h,   0,	27h,   0, 25h,	 0
				db    0,   0, 22h,   0,	  0,   0,   0,	 0
				db    0,   0, 25h,   0,	  0,   0, 20h,	 0
				db    0,   0, 20h,   0,	  0, 22h, 20h,	 0
				db  1Eh,   0, 1Dh,   0,	1Eh,   0, 20h,	 0
				db    0,   0, 20h,   0,	  0,   0, 20h,	 0
				db  20h,   0, 22h,   0,	24h,   0, 25h,	 0
				db    0,   0, 29h,   0,	  0,   0,   0,	 0
				db  24h,   0, 25h,   0,	26h,   0, 27h,	 0
				db    0,   0, 22h,   0,	  0,   0, 24h,	 0
				db    0,   0, 25h,   0,	  0,   0, 27h,	 0
				db    0,   0, 27h,   0,	  0, 29h, 27h,	 0
				db  25h,   0, 24h,   0,	22h,   0, 20h,	 0
				db    0,   0, 20h,   0,	  0,   0, 20h,	 0
				db  20h,   0, 22h,   0,	24h,   0, 25h,	 0
				db    0,   0, 29h,   0,	  0,   0,   0,	 0
				db  25h,   0, 27h,   0,	29h,   0, 2Ah,	 0
				db    0,   0, 22h,   0,	  0,   0, 25h,	 0
				db    0,   0, 2Ah,   0,	  0,   0, 29h,	 0
				db    0,   0,	0,   0,	  0,   0,   0,	 0
				db    0,   0, 25h,   0,	27h,   0, 29h,	 0
				db    0,   0, 29h,   0,	  0,   0, 29h,	 0
				db  25h,   0, 27h,   0,	25h,   0, 22h,	 0
				db    0,   0,	0,   0,	  0,   0, 20h,	 0
				db    0,   0, 25h,   0,	  0,   0, 29h,	 0
				db    0,   0, 25h,   0,	  0,   0,   0,	 0
				db    0,   0, 27h,   0,	  0,   0, 25h,	 0
				db    0,   0,	0,   0,	  0,   0,   0,	 0
				db 0FFh
music_channel1_data		db  0Ah,   0, 0Ch,   0,	  0, 0Eh, 0Fh,	 0
							    ; DATA XREF: menu_screen+37o
				db  13h,   0, 0Ah,   0,	13h,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 14h,   0,	15h,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 0Fh,	 0
				db  13h,   0,	0,   0,	  0,   0,   0,	 0
				db  0Ah,   0, 0Ch,   0,	  0, 0Eh, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 14h,   0,	15h,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  14h,   0, 16h,   0,	18h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  0Fh,   0, 11h,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  0Fh,   0, 14h,   0,	15h,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 16h,	 0
				db  1Ah,   0, 11h,   0,	1Ah,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	14h,   0, 13h,	 0
				db  16h,   0, 0Fh,   0,	13h,   0, 0Ah,	 0
				db  13h,   0, 16h,   0,	18h,   0, 19h,	 0
				db  14h,   0, 11h,   0,	19h,   0, 18h,	 0
				db  14h,   0, 0Fh,   0,	18h,   0, 13h,	 0
				db  16h,   0, 0Fh,   0,	13h,   0, 0Ah,	 0
				db  13h,   0, 0Fh,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 13h,	 0
				db  16h,   0, 0Fh,   0,	16h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db    0,   0,	0,   0,	  0,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0, 0Fh,   0,	11h,   0, 12h,	 0
				db  16h,   0, 0Dh,   0,	16h,   0, 12h,	 0
				db  16h,   0, 0Dh,   0,	16h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db    8,   0, 0Ah,   0,	0Ch,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0, 0Dh,   0,	0Eh,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 0Fh,	 0
				db  13h,   0, 0Ah,   0,	13h,   0, 14h,	 0
				db  18h,   0, 0Fh,   0,	18h,   0, 14h,	 0
				db    8,   0, 0Ah,   0,	0Ch,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0, 0Ah,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  0Dh,   0, 0Fh,   0,	11h,   0, 12h,	 0
				db  16h,   0, 0Dh,   0,	16h,   0, 12h,	 0
				db  16h,   0, 12h,   0,	12h,   0, 11h,	 0
				db  15h,   0, 0Ch,   0,	15h,   0, 11h,	 0
				db  15h,   0, 11h,   0,	0Ch,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 12h,	 0
				db  16h,   0, 0Dh,   0,	16h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Fh,	 0
				db    8,   0, 0Ah,   0,	0Ch,   0, 0Dh,	 0
				db  11h,   0,	8,   0,	11h,   0, 0Dh,	 0
				db 0FFh
music_tuning_table		dw 0FEFEh		    ; DATA XREF: get_tuning+2o
				dw 0
				dw 0
				dw 0
				dw 0
				dw 218h
				dw 1FAh
				dw 1DEh
				dw 1C3h
				dw 1A9h
				dw 192h
				dw 17Bh
				dw 166h
				dw 152h
				dw 13Fh
				dw 12Dh
				dw 11Ch
				dw 10Ch
				dw 0FDh
				dw 0EFh
				dw 0E1h
				dw 0D5h
				dw 0C9h
				dw 0BEh
				dw 0B3h
				dw 0A9h
				dw 9Fh
				dw 96h
				dw 8Eh
				dw 86h
				dw 7Eh
				dw 77h
				dw 71h
				dw 6Ah
				dw 64h
				dw 5Fh
				dw 59h
				dw 54h
				dw 50h
				dw 4Bh
				dw 47h
				dw 43h
				dw 3Fh
				dw 3Ch
				dw 38h
				dw 35h
				dw 32h
				dw 2Fh
				dw 2Dh
				dw 2Ah
				dw 28h
				dw 26h
				dw 23h
				dw 21h
				dw 20h
				dw 1Eh
				dw 1Ch
				dw 1Bh
				dw 19h
				dw 18h
				dw 16h
				dw 15h
				dw 14h
				dw 13h
				dw 12h
				dw 11h
move_map_arg			db 0			    ; DATA XREF: move_map_up_leftr
							    ; move_map_down_leftr ...

; =============== S U B	R O U T	I N E =======================================


get_supertiles			proc near		    ; CODE XREF: move_map_up_left+10p
							    ; move_map_up_left+32p ...
				push	ds
				pop	es
				mov	al, byte ptr ds:map_position+1
				and	al, 0FCh
				mov	ah, 0
				mov	si, ax
				shr	al, 1
				add	si, ax
				mov	ax, si
				shl	si, 1
				shl	si, 1
				shl	si, 1
				add	si, ax
				add	si, (offset super_tiles+0D6Ah)
				mov	al, byte ptr ds:map_position
				shr	al, 1
				shr	al, 1
				cbw
				add	si, ax
				mov	cx, 5
				mov	di, offset map_buf
				cld

loop:							    ; CODE XREF: get_supertiles+35j
				movsw
				movsw
				movsw
				movsb
				add	si, 2Fh	; '/'
				loop	loop
				retn
get_supertiles			endp


; =============== S U B	R O U T	I N E =======================================


plot_bottommost_tiles		proc near		    ; CODE XREF: move_map_up_left+2Ap
							    ; move_map_up_right+2Ep
							    ; DATA XREF: ...
				add	[bp+si+1740], bh
				mov	si, (offset map_buf+1Ch)
				mov	al, byte ptr ds:map_position+1
				mov	di, offset unk_12E4
				jmp	short plot_horizontal_tiles_common
plot_bottommost_tiles		endp


; =============== S U B	R O U T	I N E =======================================


plot_topmost_tiles		proc near		    ; CODE XREF: move_map_down_left+2Ep
							    ; move_map_down_right+2Ap
				mov	dx, offset tile_buf
				mov	si, offset map_buf
				mov	al, byte ptr ds:map_position+1
				mov	di, offset window_buf

plot_horizontal_tiles_common:				    ; CODE XREF: plot_bottommost_tiles+Dj
				and	al, 3
				shl	al, 1
				shl	al, 1
				mov	byte ptr ds:plot_bottommost_tiles, al
				mov	ah, byte ptr ds:map_position
				and	ah, 3
				add	al, ah
				call	get_super_tile	    ; this is inlined in the speccy version
				neg	al
				mov	cx, 4
				and	al, 3
				jz	short loc_5CD0
				mov	cl, al

loc_5CD0:						    ; CODE XREF: plot_topmost_tiles+28j
				call	plot_tile_loop_inner ; this is inlined in the speccy version
				mov	cx, 5

loop:							    ; CODE XREF: plot_topmost_tiles+40j
				push	cx
				mov	al, byte ptr ds:plot_bottommost_tiles
				call	get_super_tile	    ; this is inlined in the speccy version
				mov	cx, 4
				call	plot_tile_loop_inner ; this is inlined in the speccy version
				pop	cx
				loop	loop
				mov	al, byte ptr ds:plot_bottommost_tiles
				call	get_super_tile	    ; this is inlined in the speccy version
				mov	cl, byte ptr ds:map_position
				and	cl, 3
				jz	short locret_5CFA
				mov	ch, 0
				call	plot_tile_loop_inner ; this is inlined in the speccy version

locret_5CFA:						    ; CODE XREF: plot_topmost_tiles+4Fj
				retn
plot_topmost_tiles		endp


; =============== S U B	R O U T	I N E =======================================

; this is inlined in the speccy	version

get_super_tile			proc near		    ; CODE XREF: plot_topmost_tiles+1Ep
							    ; plot_topmost_tiles+36p ...
				mov	bl, [si]
				mov	bh, 0
				mov	ah, bh
				shl	bx, 1		    ; multiply by 16
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				add	bx, offset super_tiles
				add	bx, ax
				retn
get_super_tile			endp


; =============== S U B	R O U T	I N E =======================================

; this is inlined in the speccy	version

plot_tile_loop_inner		proc near		    ; CODE XREF: plot_topmost_tiles:loc_5CD0p
							    ; plot_topmost_tiles+3Cp ...
				mov	al, [bx]
				xchg	bx, dx
				mov	[bx], al
				xchg	bx, dx
				call	plot_tile
				inc	bx
				inc	dx
				loop	plot_tile_loop_inner ; this is inlined in the speccy version
				inc	si
				retn
plot_tile_loop_inner		endp


; =============== S U B	R O U T	I N E =======================================


plot_all_tiles			proc near		    ; CODE XREF: reset_outdoors+2Ep
							    ; pick_up_item+2Dp
				mov	dx, offset tile_buf
				mov	si, offset map_buf
				mov	di, offset window_buf
				mov	al, byte ptr ds:map_position
				mov	cx, 18h

loop:							    ; CODE XREF: plot_all_tiles+25j
				push	cx
				push	di
				push	si
				push	ax
				push	dx
				call	plot_vertical_tiles_common
				pop	dx
				inc	dx
				pop	ax
				pop	si
				inc	al
				test	al, 3
				jnz	short next
				inc	si

next:							    ; CODE XREF: plot_all_tiles+1Fj
				pop	di
				inc	di
				pop	cx
				loop	loop
				retn
plot_all_tiles			endp

; ---------------------------------------------------------------------------
plot_vertical_tiles_scratch	db 0			    ; DATA XREF: plot_vertical_tiles_common+2w
							    ; plot_vertical_tiles_common+2Br ...
							    ; New vs Speccy version.

; =============== S U B	R O U T	I N E =======================================


plot_rightmost_tiles		proc near		    ; CODE XREF: move_map_up_left+4Cp
							    ; move_map_down_left+31p
				mov	dx, (offset tile_buf+17h)
				mov	si, (offset map_buf+6)
				mov	di, (offset window_buf+17h)
				mov	al, byte ptr ds:map_position
				test	al, 3
				jnz	short loc_5D5B
				dec	si

loc_5D5B:						    ; CODE XREF: plot_rightmost_tiles+Ej
				dec	al
				jmp	short plot_vertical_tiles_common
plot_rightmost_tiles		endp


; =============== S U B	R O U T	I N E =======================================


plot_leftmost_tiles		proc near		    ; CODE XREF: move_map_up_right+31p
							    ; move_map_up_right+53p
				mov	dx, offset tile_buf
				mov	si, offset map_buf
				mov	di, offset window_buf
				mov	al, byte ptr ds:map_position
plot_leftmost_tiles		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


plot_vertical_tiles_common	proc near		    ; CODE XREF: plot_all_tiles+14p
							    ; plot_rightmost_tiles+13j
				and	al, 3
				mov	ds:plot_vertical_tiles_scratch,	al
				mov	ah, al
				mov	al, byte ptr ds:map_position+1
				and	al, 3
				shl	al, 1
				shl	al, 1
				add	al, ah
				call	get_super_tile	    ; this is inlined in the speccy version
				shr	al, 1
				shr	al, 1
				neg	al
				mov	cx, 4
				and	al, 3
				jz	short loc_5D8F
				mov	cl, al

loc_5D8F:						    ; CODE XREF: plot_vertical_tiles_common+20j
				call	plot_tile_loop
				mov	cx, 3

loop:							    ; CODE XREF: plot_vertical_tiles_common+38j
				push	cx
				mov	al, ds:plot_vertical_tiles_scratch
				call	get_super_tile	    ; this is inlined in the speccy version
				mov	cx, 4
				call	plot_tile_loop
				pop	cx
				loop	loop
				mov	al, ds:plot_vertical_tiles_scratch
				call	get_super_tile	    ; this is inlined in the speccy version
				mov	cl, byte ptr ds:map_position+1
				and	cl, 3
				mov	ch, 0
				inc	cx
				call	plot_tile_loop
				retn
plot_vertical_tiles_common	endp


; =============== S U B	R O U T	I N E =======================================


plot_tile_loop			proc near		    ; CODE XREF: plot_vertical_tiles_common:loc_5D8Fp
							    ; plot_vertical_tiles_common+34p ...
				mov	al, [bx]
				xchg	bx, dx
				mov	[bx], al
				xchg	bx, dx
				call	plot_tile_then_advance
				add	bx, 4
				add	dx, 24
				loop	plot_tile_loop
				add	si, 7
				retn
plot_tile_loop			endp


; =============== S U B	R O U T	I N E =======================================


plot_tile_then_advance		proc near		    ; CODE XREF: plot_tile_loop+8p
				call	plot_tile
				add	di, 0BFh ; '¿'
				retn
plot_tile_then_advance		endp


; =============== S U B	R O U T	I N E =======================================


plot_tile			proc near		    ; CODE XREF: plot_tile_loop_inner+8p
							    ; plot_tile_then_advancep
				push	bx
				push	cx
				push	si
				push	di
				push	ds
				pop	es
				cld
				mov	ah, [si]
				mov	si, offset exterior_tiles_1
				cmp	ah, 45
				jb	short chosen
				mov	si, offset exterior_tiles_2
				cmp	ah, 139
				jb	short chosen
				cmp	ah, 204
				jnb	short chosen
				mov	si, offset exterior_tiles_3

chosen:							    ; CODE XREF: plot_tile+Fj
							    ; plot_tile+17j ...
				mov	ah, 0
				shl	ax, 1		    ; multiply_by_8
				shl	ax, 1
				shl	ax, 1
				add	si, ax
				mov	cx, 8

loop:							    ; CODE XREF: plot_tile+32j
				movsb
				add	di, 17h
				loop	loop
				pop	di
				inc	di
				pop	si
				pop	cx
				pop	bx
				retn
plot_tile			endp


; =============== S U B	R O U T	I N E =======================================


move_map_up_left		proc near		    ; DATA XREF: seg000:move_map_jump_tableo
				mov	al, ds:move_map_arg
				and	al, al
				jz	short shunt_map_1
				test	al, 1
				jnz	short shunt_map_2
				retn
; ---------------------------------------------------------------------------

shunt_map_1:						    ; CODE XREF: move_map_up_left+5j
				inc	byte ptr ds:map_position+1
				call	get_supertiles
				cld
				mov	si, (offset tile_buf+18h)
				mov	di, offset tile_buf
				mov	cx, 180h
				rep movsb
				mov	si, (offset window_buf+0C0h)
				mov	di, offset window_buf
				mov	cx, 600h
				rep movsw
				call	near ptr plot_bottommost_tiles+1
				retn
; ---------------------------------------------------------------------------

shunt_map_2:						    ; CODE XREF: move_map_up_left+9j
							    ; move_map_down_left+5j
				inc	byte ptr ds:map_position
				call	get_supertiles
				cld
				mov	si, (offset tile_buf+1)
				mov	di, offset tile_buf
				mov	cx, 197h
				rep movsb
				mov	si, (offset window_buf+1)
				mov	di, offset window_buf
				mov	cx, 0CBFh
				rep movsb
				call	plot_rightmost_tiles
				retn
move_map_up_left		endp


; =============== S U B	R O U T	I N E =======================================


move_map_down_left		proc near		    ; DATA XREF: seg000:5FA7o
				mov	al, ds:move_map_arg
				cmp	al, 1
				jz	short shunt_map_2
				cmp	al, 3
				jz	short shunt_map_3
				retn
; ---------------------------------------------------------------------------

shunt_map_3:						    ; CODE XREF: move_map_down_left+9j
				inc	byte ptr ds:map_position
				dec	byte ptr ds:map_position+1
				call	get_supertiles
				std
				mov	si, (offset tile_buf+17Fh)
				mov	di, (offset tile_buf+196h)
				mov	cx, 17Fh
				rep movsb
				mov	si, (offset window_buf+0BFFh)
				mov	di, offset unk_13A2
				mov	cx, 0BFFh
				rep movsb
				call	plot_topmost_tiles
				call	plot_rightmost_tiles
				retn
move_map_down_left		endp


; =============== S U B	R O U T	I N E =======================================


move_map_up_right		proc near		    ; DATA XREF: seg000:5FA3o
				mov	al, ds:move_map_arg
				and	al, al
				jz	short shunt_map_4
				cmp	al, 2
				jz	short shunt_map_5
				retn
; ---------------------------------------------------------------------------

shunt_map_4:						    ; CODE XREF: move_map_up_right+5j
				dec	byte ptr ds:map_position
				inc	byte ptr ds:map_position+1
				call	get_supertiles
				cld
				mov	si, (offset tile_buf+18h)
				mov	di, (offset tile_buf+1)
				mov	cx, 180h
				rep movsb

loc_5EBA:
				mov	si, (offset window_buf+0C0h)
				mov	di, (offset window_buf+1)
				mov	cx, 600h
				rep movsw
				call	near ptr plot_bottommost_tiles+1
				call	plot_leftmost_tiles
				retn
; ---------------------------------------------------------------------------

shunt_map_5:						    ; CODE XREF: move_map_up_right+9j
							    ; move_map_down_right+9j
				dec	byte ptr ds:map_position
				call	get_supertiles
				std
				mov	si, (offset tile_buf+196h)
				mov	di, (offset tile_buf+197h)
				mov	cx, 197h
				rep movsb
				mov	si, offset unk_13A2
				mov	di, offset unk_13A3
				mov	cx, 0CBFh
				rep movsb
				call	plot_leftmost_tiles
				retn
move_map_up_right		endp


; =============== S U B	R O U T	I N E =======================================


move_map_down_right		proc near		    ; DATA XREF: seg000:5FA5o
				mov	al, ds:move_map_arg
				cmp	al, 3
				jz	short shunt_map_6
				rcr	al, 1
				jnb	short shunt_map_5
				retn
; ---------------------------------------------------------------------------

shunt_map_6:						    ; CODE XREF: move_map_down_right+5j
				dec	byte ptr ds:map_position+1
				call	get_supertiles
				std
				mov	si, (offset tile_buf+17Fh)
				mov	di, (offset tile_buf+197h)
				mov	cx, 180h
				rep movsb
				mov	si, (offset window_buf+0BFFh)
				mov	di, offset unk_13A3
				mov	cx, 600h
				rep movsw
				call	plot_topmost_tiles
				retn
move_map_down_right		endp


; =============== S U B	R O U T	I N E =======================================


move_map			proc near		    ; CODE XREF: enter_room-6657p
							    ; setup_movable_items+28p
				mov	al, ds:room_index
				and	al, al
				jz	short outside
				retn
; ---------------------------------------------------------------------------

outside:						    ; CODE XREF: move_map+5j
				mov	bx, 2FAh
				test	byte ptr [bx], 40h
				jz	short loc_5F2D
				retn
; ---------------------------------------------------------------------------

loc_5F2D:						    ; CODE XREF: move_map+Ej
				mov	bx, 2FDh
				mov	cl, [bx+2]
				mov	bx, [bx]
				mov	al, [bx+3]
				cmp	al, 0FFh
				jnz	short loc_5F3D
				retn
; ---------------------------------------------------------------------------

loc_5F3D:						    ; CODE XREF: move_map+1Ej
				test	cl, 80h
				jz	short loc_5F44
				xor	al, 2

loc_5F44:						    ; CODE XREF: move_map+24j
				mov	ah, 0
				shl	ax, 1
				mov	bx, offset move_map_jump_table
				add	bx, ax
				mov	bx, [bx]
				shr	ax, 1
				push	bx
				mov	cx, 7C00h
				cmp	al, 2
				jb	short loc_5F5B
				mov	ch, 0

loc_5F5B:						    ; CODE XREF: move_map+3Bj
				cmp	al, 1
				jz	short loc_5F65
				cmp	al, 2
				jz	short loc_5F65
				mov	cl, 0C0h ; 'À'

loc_5F65:						    ; CODE XREF: move_map+41j
							    ; move_map+45j
				cmp	byte ptr ds:map_position, cl
				jnz	short loc_5F6D

loc_5F6B:						    ; CODE XREF: move_map+55j
				pop	bx
				retn
; ---------------------------------------------------------------------------

loc_5F6D:						    ; CODE XREF: move_map+4Dj
				cmp	byte ptr ds:map_position+1, ch
				jz	short loc_5F6B
				mov	bx, offset move_map_arg
				cmp	al, 2
				mov	al, [bx]
				jnb	short loc_5F80
				inc	al
				jmp	short loc_5F82
; ---------------------------------------------------------------------------

loc_5F80:						    ; CODE XREF: move_map+5Ej
				dec	al

loc_5F82:						    ; CODE XREF: move_map+62j
				and	al, 3
				mov	[bx], al
				mov	bx, 0
				and	al, al
				jz	short loc_5F9C
				mov	bl, 60h	; '`'
				cmp	al, 2
				jz	short loc_5F9C
				mov	bx, 0FF30h
				cmp	al, 1
				jz	short loc_5F9C
				mov	bl, 90h	; ''

loc_5F9C:						    ; CODE XREF: move_map+6Fj
							    ; move_map+75j ...
				mov	ds:game_window_offset, bx
				retn
move_map			endp ; sp-analysis failed

; ---------------------------------------------------------------------------
move_map_jump_table		dw offset move_map_up_left  ; DATA XREF: move_map+2Co
				dw offset move_map_up_right
				dw offset move_map_down_right
				dw offset move_map_down_left
displayed_morale		db 70h			    ; DATA XREF: wave_morale_flag+Fo
moraleflag_screen_address	dw 28Ch			    ; DATA XREF: wave_morale_flag+1Ar
							    ; wave_morale_flag+2Er ...
moraleflag_screen_attributes	db 44h			    ; DATA XREF: wave_morale_flag+55r
							    ; set_morale_flag_screen_attributesw ...
							    ; New vs Speccy version.

; =============== S U B	R O U T	I N E =======================================


wave_morale_flag		proc near		    ; CODE XREF: enter_room:outsidep
							    ; menu_screen:waveflagetcp
				mov	bx, offset game_counter
				inc	byte ptr [bx]
				test	byte ptr [bx], 1    ; Wave the flag on every other turn.
				jz	short dowave
				retn
; ---------------------------------------------------------------------------

dowave:							    ; CODE XREF: wave_morale_flag+8j
				push	bx
				mov	al, ds:morale
				mov	bx, offset displayed_morale
				cmp	al, [bx]
				jz	short drawdown
				jnb	short loc_5FD9
				dec	byte ptr [bx]
				mov	bx, ds:moraleflag_screen_address
				xor	bx, 2000h
				test	bh, 20h
				jnz	short loc_5FEB
				add	bx, 50h	; 'P'
				jmp	short loc_5FEB
; ---------------------------------------------------------------------------

loc_5FD9:						    ; CODE XREF: wave_morale_flag+16j
				inc	byte ptr [bx]
				mov	bx, ds:moraleflag_screen_address
				xor	bx, 2000h
				test	bh, 20h
				jz	short loc_5FEB
				sub	bx, 50h	; 'P'

loc_5FEB:						    ; CODE XREF: wave_morale_flag+25j
							    ; wave_morale_flag+2Aj ...
				mov	ds:moraleflag_screen_address, bx

drawdown:						    ; CODE XREF: wave_morale_flag+14j
				mov	si, offset bitmap_flag_down
				pop	bx
				test	byte ptr [bx], 2
				jz	short draw
				mov	si, offset bitmap_flag_up

draw:							    ; CODE XREF: wave_morale_flag+49j
				mov	di, ds:moraleflag_screen_address
				mov	cx, 319h	    ; dimensions
				mov	al, ds:moraleflag_screen_attributes ; Attributes.
				call	plot_bitmap
				retn
wave_morale_flag		endp


; =============== S U B	R O U T	I N E =======================================


set_morale_flag_screen_attributes proc near		    ; CODE XREF: main+11p
							    ; in_permitted_area:loc_6920j
				mov	ds:moraleflag_screen_attributes, al
				retn
set_morale_flag_screen_attributes endp

; ---------------------------------------------------------------------------
bitmap_flag_up			db    0,   0,	0	    ; DATA XREF: wave_morale_flag+4Bo
				db    0,   0, 7Ch
				db    0,   3,0FEh
				db  80h, 1Fh,0FEh
				db 0E0h,0FFh, 8Eh
				db  7Fh,0FCh,	6
				db  7Fh,0E0h,	6
				db  7Fh,   0, 7Eh
				db  60h,   3,0FEh
				db  60h, 1Fh,0FEh
				db  30h,0FFh,0FEh
				db  3Fh,0FFh, 0Ch
				db  3Fh,0FCh, 1Ch
				db  3Fh,0F0h, 1Ch
				db  3Fh, 80h,0F8h
				db  30h,   3,0F8h
				db  70h, 0Fh,0C0h
				db  60h, 7Eh,	0
				db  7Fh,0F8h,	0
				db 0FFh,0E0h,	0
				db  0Fh,   0,	0
				db    0,   0,	0
bitmap_flag_down		db    0,   0,	0	    ; DATA XREF: wave_morale_flag:drawdowno
				db    0,   0,	0
				db    0,   0,	0
				db 0F8h,   0,	0
				db  7Fh,   0,	0
				db  7Fh,0E0h,	0
				db  3Fh,0FCh, 1Ch
				db  30h,0FFh,0FCh
				db  30h, 1Fh,0FCh
				db  30h,   3,0D8h
				db  3Fh,   0, 18h
				db  3Fh,0E0h, 18h
				db  3Fh,0FCh, 38h
				db  3Fh,0FFh,0F0h
				db  70h,0FFh,0F0h
				db  60h, 1Fh,0F0h
				db  60h,   7,0F0h
				db  7Fh,   0,0F8h
				db 0FFh,0E0h, 18h
				db 0C3h,0F8h, 18h
				db    0, 7Fh, 1Ch
				db    0, 0Fh,0FCh
				db    0,   0,0F0h
				db    0,   0,	0
				db    0,   0,	0
keything_1			db 80h			    ; DATA XREF: input_routine+1r
							    ; sub_60D6:loc_6101w ...
keything_mask			db 80h			    ; DATA XREF: input_routine:loc_60BBr
							    ; sub_60D6:loc_60FBw ...

; =============== S U B	R O U T	I N E =======================================


input_routine			proc near		    ; CODE XREF: process_player_input:loc_6BA7p
				push	bx
				mov	al, ds:keything_1
				test	al, 80h
				jnz	short loc_60B9
				mov	bx, offset word_60C6
				mov	cx, 8

loop:							    ; CODE XREF: input_routine+14j
				cmp	al, [bx]
				jz	short loc_60B4
				inc	bx
				inc	bx
				loop	loop
				jmp	short loc_60B9
; ---------------------------------------------------------------------------

loc_60B4:						    ; CODE XREF: input_routine+10j
				mov	al, [bx+1]
				jmp	short loc_60BB
; ---------------------------------------------------------------------------

loc_60B9:						    ; CODE XREF: input_routine+6j
							    ; input_routine+16j
				xor	ax, ax

loc_60BB:						    ; CODE XREF: input_routine+1Bj
				test	ds:keything_mask, 80h
				jnz	short exit
				add	al, 9

exit:							    ; CODE XREF: input_routine+24j
				pop	bx
				retn
input_routine			endp

; ---------------------------------------------------------------------------
word_60C6			dw 148h			    ; DATA XREF: input_routine+8o
				dw 250h
				dw 34Bh
				dw 447h
				dw 54Fh
				dw 64Dh
				dw 749h
				dw 851h

; =============== S U B	R O U T	I N E =======================================


sub_60D6			proc far		    ; DATA XREF: keyscan_THING1+16o
				push	ax
				in	al, 60h		    ; AT Keyboard controller 8042.
				push	ax
				in	al, 61h		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				mov	ah, al
				or	al, 80h
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				mov	al, ah
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				pop	ax
				mov	ah, al
				and	ah, 7Fh
				cmp	ah, 39h	; '9'
				jz	short loc_60FB
				cmp	ah, 2Ah	; '*'
				jz	short loc_60FB
				cmp	ah, 36h	; '6'
				jnz	short loc_6101

loc_60FB:						    ; CODE XREF: sub_60D6+19j
							    ; sub_60D6+1Ej
				mov	cs:keything_mask, al
				jmp	short loc_6105
; ---------------------------------------------------------------------------

loc_6101:						    ; CODE XREF: sub_60D6+23j
				mov	cs:keything_1, al

loc_6105:						    ; CODE XREF: sub_60D6+29j
				mov	al, 20h	; ' '
				out	20h, al		    ; Interrupt	controller, 8259A.
				pop	ax
				iret
sub_60D6			endp


; =============== S U B	R O U T	I N E =======================================


keyscan_THING1			proc near		    ; CODE XREF: main+1Fp
							    ; keyscan_break+15p
				push	es
				xor	ax, ax
				mov	es, ax
				mov	bx, 36
				cli
				mov	ax, es:[bx]
				mov	ds:keyscan_thing_word1,	ax
				mov	ax, es:[bx+2]
				mov	ds:keyscan_thing_word2,	ax
				mov	ax, offset sub_60D6
				mov	es:[bx], ax
				mov	ax, cs
				mov	es:[bx+2], ax
				sti
				pop	es
				retn
keyscan_THING1			endp


; =============== S U B	R O U T	I N E =======================================


keyscan_THING2			proc near		    ; CODE XREF: keyscan_break+7p
				push	es
				xor	ax, ax
				mov	es, ax
				mov	bx, 36
				cli
				mov	ax, ds:keyscan_thing_word1
				mov	es:[bx], ax
				mov	ax, ds:keyscan_thing_word2
				mov	es:[bx+2], ax
				sti
				pop	es
				retn
keyscan_THING2			endp

; ---------------------------------------------------------------------------
keyscan_thing_word1		dw 0			    ; DATA XREF: keyscan_THING1+Cw
							    ; keyscan_THING2+9r
keyscan_thing_word2		dw 0			    ; DATA XREF: keyscan_THING1+13w
							    ; keyscan_THING2+Fr

; =============== S U B	R O U T	I N E =======================================


plot_game_window		proc near		    ; CODE XREF: enter_room-664Bp
							    ; screen_reset+Ep
				cld
				mov	al, ds:game_window_attribute
				mov	bx, offset plot_game_window_masks
				and	al, 0Fh
				xlat
				mov	ah, al
				mov	word ptr ds:selfmod0+1,	ax ; self modify
				mov	word ptr ds:selfmod1+1,	ax ; self modify
				mov	si, (offset window_buf+1)
				mov	al, byte ptr ds:game_window_offset
				xor	ah, ah
				add	si, ax
				mov	di, offset unk_2064
				mov	dx, offset plot_game_window_table
				mov	cx, 128		    ; 128 rows
				test	byte ptr ds:game_window_offset+1, 0FFh
				jnz	short unaligned

aligned:						    ; CODE XREF: plot_game_window+43j
				push	cx
				mov	cx, 23

aloop:							    ; CODE XREF: plot_game_window+3Fj
				lodsb			    ; if (DF==0) AL = *SI++; else AL = *SI--;
				xor	ah, ah
				shl	ax, 1
				mov	bx, dx
				add	bx, ax
				mov	ax, [bx]

selfmod0:						    ; DATA XREF: plot_game_window+Cw
				and	ax, 0FFFFh
				stosw
				loop	aloop
				pop	cx
				inc	si
				loop	aligned
				retn
; ---------------------------------------------------------------------------

unaligned:						    ; CODE XREF: plot_game_window+2Aj
				dec	si

uloop:							    ; CODE XREF: plot_game_window+6Dj
				push	cx
				lodsb
				xor	ah, ah
				shl	ax, 1
				mov	bx, dx
				add	bx, ax
				mov	cx, [bx]
				mov	cl, 23

uinnerloop:						    ; CODE XREF: plot_game_window+6Aj
				lodsb
				xor	ah, ah
				shl	ax, 1
				mov	bx, dx
				add	bx, ax
				mov	ax, [bx]
				xchg	al, ah
				xchg	al, ch

selfmod1:						    ; DATA XREF: plot_game_window+Fw
				and	ax, 0FFFFh
				stosw
				dec	cl
				jnz	short uinnerloop
				pop	cx
				loop	uloop
				retn
plot_game_window		endp


; =============== S U B	R O U T	I N E =======================================


set_game_window_attributes	proc near		    ; CODE XREF: enter_room:dayp
							    ; screen_reset+11p
				push	es
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				mov	di, 296h
				mov	dx, di
				xor	dx, 2000h
				mov	ax, 80h	; '€'
				mov	si, offset unk_2064

loop:							    ; CODE XREF: set_game_window_attributes+20j
				mov	cx, 17h
				rep movsw
				xchg	di, dx
				add	dx, 22h	; '"'
				dec	ax
				jnz	short loop
				pop	es
				assume es:nothing
				retn
set_game_window_attributes	endp

; ---------------------------------------------------------------------------
timed_events			timedevent <0, offset event_another_day_dawns>
							    ; DATA XREF: dispatch_timed_event+Fo
				timedevent <8, offset wake_up> ; hero wakes up
				timedevent <0Ch, offset	event_new_red_cross_parcel>
				timedevent <10h, offset	event_go_to_roll_call>
				timedevent <14h, offset	event_roll_call>
				timedevent <15h, offset	event_go_to_breakfast_time>
				timedevent <24h, offset	breakfast_time>
				timedevent <2Eh, offset	event_go_to_exercise_time>
				timedevent <40h, offset	event_exercise_time>
				timedevent <4Ah, offset	event_go_to_roll_call>
				timedevent <4Eh, offset	event_roll_call>
				timedevent <4Fh, offset	event_go_to_time_for_bed>
				timedevent <62h, offset	event_time_for_bed>
				timedevent <64h, offset	event_night_time>
				timedevent <82h, offset	event_search_light>

; =============== S U B	R O U T	I N E =======================================


dispatch_timed_event		proc near		    ; CODE XREF: enter_room-6624p
				mov	bx, offset clock
				mov	al, [bx]
				inc	al
				cmp	al, 8Ch	; 'Œ'
				jnz	short loc_621B
				xor	al, al

loc_621B:						    ; CODE XREF: dispatch_timed_event+9j
				mov	[bx], al
				mov	bx, offset timed_events
				mov	cx, 0Fh

loc_6223:						    ; CODE XREF: dispatch_timed_event+1Cj
				cmp	al, [bx]
				jz	short loc_622D
				add	bx, 3
				loop	loc_6223
				retn
; ---------------------------------------------------------------------------

loc_622D:						    ; CODE XREF: dispatch_timed_event+17j
				mov	bx, [bx+1]
				push	bx
				mov	al, 28h	; '('
				mov	bx, offset bell
				retn
dispatch_timed_event		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


event_night_time		proc near		    ; DATA XREF: seg000:6208o
				mov	al, ds:hero_in_bed
				and	al, al
				jnz	short loc_6244
				mov	cx, 2C01h
				call	set_hero_target_location

loc_6244:						    ; CODE XREF: event_night_time+5j
				mov	al, 0FFh
				jmp	short loc_6254
; ---------------------------------------------------------------------------

event_another_day_dawns:				    ; DATA XREF: seg000:timed_eventso
				mov	ch, message_ANOTHER_DAY_DAWNS
				call	queue_message_for_display
				mov	ch, 19h
				call	decrease_morale
				xor	al, al

loc_6254:						    ; CODE XREF: event_night_time+Fj
				mov	ds:day_or_night, al

loc_6257:
				call	choose_game_window_attributes
				retn
event_night_time		endp


; =============== S U B	R O U T	I N E =======================================


event_go_to_roll_call		proc near		    ; DATA XREF: seg000:61EAo
							    ; seg000:61FCo
				mov	[bx], al
				mov	ch, message_ROLL_CALL
				call	queue_message_for_display
				call	go_to_roll_call
				retn
event_go_to_roll_call		endp


; =============== S U B	R O U T	I N E =======================================


event_roll_call			proc near		    ; DATA XREF: seg000:61EDo
							    ; seg000:61FFo
				mov	dx, 727Ch	    ; coord
				mov	bx, offset hero_map_position
				mov	cx, 2

loc_626F:						    ; CODE XREF: event_roll_call+17j
				mov	al, [bx]
				cmp	al, dh
				jb	short loc_6292
				cmp	al, dl
				jnb	short loc_6292
				inc	bx
				mov	dx, 6A72h	    ; coord
				loop	loc_626F
				mov	bx, 300h
				mov	cx, 8

loc_6285:						    ; CODE XREF: event_roll_call+29j
				mov	byte ptr [bx], 80h ; '€'
				mov	byte ptr [bx+1], 3
				add	bx, 20h	; ' '
				loop	loc_6285
				retn
; ---------------------------------------------------------------------------

loc_6292:						    ; CODE XREF: event_roll_call+Dj
							    ; event_roll_call+11j
				xor	al, al
				mov	ds:bell, al
				mov	ch, al		    ; message_MISSED_ROLL_CALL
				call	queue_message_for_display
				call	hostiles_persue
				retn
event_roll_call			endp


; =============== S U B	R O U T	I N E =======================================


event_new_red_cross_parcel	proc near		    ; DATA XREF: seg000:61E7o
				mov	al, ds:item_struct_12_red_cross_parcel.room_and_flags
				and	al, 3Fh
				cmp	al, 3Fh	; '?'
				jnz	short exit
				mov	si, offset red_cross_parcel_contents_list
				mov	cx, 4

loc_62AF:						    ; CODE XREF: event_new_red_cross_parcel+1Ej
				mov	al, [si]
				call	item_to_itemstruct
				inc	bx
				mov	al, [bx]
				and	al, 3Fh
				cmp	al, 3Fh	; '?'
				jz	short found
				inc	si
				loop	loc_62AF

exit:							    ; CODE XREF: event_new_red_cross_parcel+7j
				retn
; ---------------------------------------------------------------------------

found:							    ; CODE XREF: event_new_red_cross_parcel+1Bj
				mov	al, [si]
				mov	ds:red_cross_parcel_current_contents, al
				push	ds
				pop	es
				cld
				mov	di, offset item_struct_12_red_cross_parcel.room_and_flags
				mov	si, offset red_cross_parcel_reset_data
				mov	cx, 3
				rep movsw
				mov	ch, message_RED_CROSS_PARCEL
				call	queue_message_for_display
				retn
event_new_red_cross_parcel	endp

; ---------------------------------------------------------------------------
red_cross_parcel_reset_data	db 14h			    ; DATA XREF: event_new_red_cross_parcel+2Co
				tinypos	<44, 44, 12>
				dw 0F480h
red_cross_parcel_contents_list	db 0Eh,	0, 5, 0Fh	    ; DATA XREF: event_new_red_cross_parcel+9o
red_cross_parcel_current_contents db 0FFh		    ; DATA XREF: event_new_red_cross_parcel+23w
							    ; action_red_cross_parcel+15r

; =============== S U B	R O U T	I N E =======================================


event_time_for_bed		proc near		    ; DATA XREF: seg000:6205o
				mov	al, 0A6h ; '¦'
				mov	cl, 3
				jmp	short common
; ---------------------------------------------------------------------------

event_search_light:					    ; DATA XREF: seg000:620Bo
				mov	al, 26h	; '&'
				mov	cl, 0

common:							    ; CODE XREF: event_time_for_bed+4j
				mov	ah, al
				mov	al, 0Ch
				mov	ch, 4

loop:							    ; CODE XREF: event_time_for_bed+1Bj
				push	ax
				call	set_character_location
				pop	ax
				inc	al
				inc	ah
				dec	ch
				jnz	short loop
				retn
event_time_for_bed		endp


; =============== S U B	R O U T	I N E =======================================

; original code	has event_wake_up and wake_up, this is all in one

wake_up				proc near		    ; DATA XREF: seg000:61E4o
				mov	[bx], al
				mov	ch, message_TIME_TO_WAKE_UP
				call	queue_message_for_display
				mov	al, ds:hero_in_bed
				and	al, al
				jz	short notinbed
				mov	bx, offset vischar_0.mi.pos.x ;	hero's x position
				mov	byte ptr [bx], 2Eh ; '.'
				inc	bx
				inc	bx
				mov	byte ptr [bx], 2Eh ; '.'

notinbed:						    ; CODE XREF: wake_up+Cj
				xor	al, al
				mov	ds:hero_in_bed,	al
				mov	cx, 2A00h
				call	set_hero_target_location
				mov	bx, (offset character_structs+8Dh) ; &characterstruct_20.room;
				mov	al, 3		    ; room_3_HUT2RIGHT
				mov	cx, 3

sethut2right:						    ; CODE XREF: wake_up+31j
				mov	[bx], al
				add	bx, 7
				loop	sethut2right
				mov	al, 5		    ; room_5_HUT3RIGHT
				mov	cx, 3

sethut3right:						    ; CODE XREF: wake_up+3Dj
				mov	[bx], al
				add	bx, 7
				loop	sethut3right
				mov	ah, 5
				mov	cl, 0
				call	set_prisoners_and_guards_location_B
				mov	al, 9		    ; interiorobject_EMPTY_BED
				mov	bx, offset beds
				mov	cx, 7

emptybeds:						    ; CODE XREF: wake_up+54j
				mov	di, [bx]
				mov	[di], al
				inc	bx
				inc	bx
				loop	emptybeds
				mov	bx, offset room2_hut2_left_bed
				mov	[bx], al
				mov	al, ds:room_index
				and	al, al		    ; room_0_OUTDOORS?
				jz	short exit
				cmp	al, 6		    ; room_6
				jnb	short exit
				call	setup_room
				call	plot_interior_tiles

exit:							    ; CODE XREF: wake_up+60j
							    ; wake_up+64j
				retn
wake_up				endp


; =============== S U B	R O U T	I N E =======================================


breakfast_time			proc near		    ; DATA XREF: seg000:61F3o
				mov	[bx], al
				mov	al, ds:hero_in_breakfast
				and	al, al
				jz	short loc_6384
				mov	bx, offset vischar_0.mi.pos.x ;	Hero's visible character.
				mov	byte ptr [bx], 34h ; '4'
				inc	bx
				inc	bx
				mov	byte ptr [bx], 3Eh ; '>'

loc_6384:						    ; CODE XREF: breakfast_time+7j
				xor	al, al
				mov	ds:hero_in_breakfast, al
				mov	cx, 9003h
				call	set_hero_target_location
				mov	bx, (offset character_structs+8Dh)
				mov	al, 19h
				mov	cx, 3

loc_6397:						    ; CODE XREF: breakfast_time+2Cj
				mov	[bx], al
				add	bx, 7
				loop	loc_6397
				mov	al, 17h
				mov	cx, 3

loc_63A3:						    ; CODE XREF: breakfast_time+38j
				mov	[bx], al
				add	bx, 7
				loop	loc_63A3
				mov	ah, 90h	; ''
				mov	cl, 3
				call	set_prisoners_and_guards_location_B
				mov	al, interiorobject_EMPTY_BENCH
				mov	ds:roomdef_23_breakfast_bench_A, al
				mov	ds:roomdef_23_breakfast_bench_B, al
				mov	ds:roomdef_23_breakfast_bench_C, al
				mov	ds:roomdef_25_breakfast_bench_D, al
				mov	ds:roomdef_25_breakfast_bench_E, al
				mov	ds:roomdef_25_breakfast_bench_F, al
				mov	ds:roomdef_25_breakfast_bench_G, al
				mov	al, ds:room_index
				and	al, al
				jz	short locret_63E1
				cmp	al, 1Dh
				jnb	short locret_63E1
				call	setup_room
				call	plot_interior_tiles
				retn
breakfast_time			endp


; =============== S U B	R O U T	I N E =======================================


set_hero_target_location	proc near		    ; CODE XREF: event_night_time+Ap
							    ; wake_up+21p ...
				mov	al, byte ptr ds:morale_1_2
				and	al, al
				jz	short set_hero_target_location_0

locret_63E1:						    ; CODE XREF: breakfast_time+5Dj
							    ; breakfast_time+61j
				retn
; ---------------------------------------------------------------------------

set_hero_target_location_0:				    ; CODE XREF: set_hero_target_location+5j
							    ; charevnt_handler_10_hero_released_from_solitary+10p
				mov	bx, offset vischar_0.flags ; Hero's visible character.
				and	byte ptr [bx], 0BFh ; masks off	only vischar_FLAGS_BIT6	in speccy version
				inc	bx
				mov	[bx], ch
				inc	bx
				mov	[bx], cl
				call	wassub_A3BB	    ; Called sub_A3BB in Speccy	version
				retn
set_hero_target_location	endp


; =============== S U B	R O U T	I N E =======================================


event_go_to_time_for_bed	proc near		    ; DATA XREF: seg000:6202o
				mov	[bx], al
				mov	bx, 8180h	    ; reset gates_and_doors[0..1]
				mov	word ptr ds:gates_and_doors, bx
				mov	ch, message_TIME_FOR_BED
				call	queue_message_for_display
				mov	cx, 8502h
				call	set_hero_target_location
				mov	ah, 85h	; '…'
				mov	cl, 2
				call	set_prisoners_and_guards_location_B
				retn
event_go_to_time_for_bed	endp

; ---------------------------------------------------------------------------
gates_and_doors			db 80h			    ; DATA XREF: event_go_to_time_for_bed+5w
							    ; event_go_to_exercise_time+Aw ...
				db 81h
				db 8Dh
				db 8Ch
				db 8Eh
				db 0A2h
				db 98h
				db 9Fh
				db 96h

; =============== S U B	R O U T	I N E =======================================


set_prisoners_and_guards_location proc near		    ; CODE XREF: go_to_roll_call+4p
				mov	bx, offset prisoners_and_guards
				mov	ch, 0Ah

loc_641C:						    ; CODE XREF: set_prisoners_and_guards_location+15j
				push	bx
				push	cx
				push	ax
				mov	al, [bx]
				call	set_character_location
				pop	ax
				inc	ah
				pop	cx
				pop	bx
				inc	bx
				dec	ch
				jnz	short loc_641C
				retn
set_prisoners_and_guards_location endp


; =============== S U B	R O U T	I N E =======================================


set_prisoners_and_guards_location_B proc near		    ; CODE XREF: wake_up+43p
							    ; breakfast_time+3Ep ...
				mov	bx, offset prisoners_and_guards
				mov	ch, 0Ah

loop:							    ; CODE XREF: set_prisoners_and_guards_location_B+1Aj
				push	bx
				push	cx
				push	ax
				mov	al, [bx]
				call	set_character_location
				pop	ax
				pop	cx
				cmp	ch, 6
				jnz	short loc_6445
				inc	ah

loc_6445:						    ; CODE XREF: set_prisoners_and_guards_location_B+12j
				pop	bx
				inc	bx
				dec	ch
				jnz	short loop
				retn
set_prisoners_and_guards_location_B endp

; ---------------------------------------------------------------------------
prisoners_and_guards		db 12, 13, 20, 21, 22, 14, 15, 23, 24, 25
							    ; DATA XREF: set_prisoners_and_guards_locationo
							    ; set_prisoners_and_guards_location_Bo
							    ; all characters

; =============== S U B	R O U T	I N E =======================================


set_character_location		proc near		    ; CODE XREF: event_time_for_bed+11p
							    ; set_prisoners_and_guards_location+Ap ...
				call	get_character_struct ; in: AL =	character index
							    ; out: BX =	character struct
				test	byte ptr [bx], 40h  ; test characterstruct_FLAG_DISABLED
				jz	short not_set
				push	cx
				mov	al, [bx]
				and	al, 11111b	    ; characterstruct_BYTE0_MASK
				mov	cx, 7
				mov	bx, offset vischar_1 ; NPC visible characters.

loop:							    ; CODE XREF: set_character_location+1Aj
				cmp	al, [bx]
				jz	short found
				add	bx, 20h	; ' '
				loop	loop
				pop	cx
				jmp	short exit
; ---------------------------------------------------------------------------
				nop			    ; odd: unreferenced	byte

not_set:						    ; CODE XREF: set_character_location+6j
				add	bx, 5
				mov	[bx], ah	    ; inlined store_location
				inc	bx
				mov	[bx], cl

exit:							    ; CODE XREF: set_character_location+1Dj
				retn
; ---------------------------------------------------------------------------

found:							    ; CODE XREF: set_character_location+15j
				pop	cx
				inc	bx
				and	byte ptr [bx], 0BFh ; was ~vischar_FLAGS_BIT6
				inc	bx
				mov	[bx], ah	    ; inlined store_location
				inc	bx
				mov	[bx], cl	    ; fallthrough
set_character_location		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================

; Called sub_A3BB in Speccy version

wassub_A3BB			proc near		    ; CODE XREF: set_hero_target_location+14p
				push	cx
				mov	ds:entered_move_characters, 0
				mov	bp, bx
				sub	bp, 3
				dec	bx
				push	bx
				call	wassub_C651
				cmp	al, 0FFh
				jnz	short loc_64A4
				pop	bx
				call	wassub_CB23
				pop	cx
				retn
; ---------------------------------------------------------------------------

loc_64A4:						    ; CODE XREF: wassub_A3BB+12j
				mov	dx, [bx]
				mov	[bp+4],	dx
				pop	bx
				cmp	al, 80h	; '€'
				jnz	short loc_64B2
				or	byte ptr [bp+1], 40h ; set vischar_FLAGS_BIT6

loc_64B2:						    ; CODE XREF: wassub_A3BB+22j
				pop	cx
				retn
wassub_A3BB			endp


; =============== S U B	R O U T	I N E =======================================


event_go_to_exercise_time	proc near		    ; DATA XREF: seg000:61F6o
				mov	[bx], al
				mov	ch, message_EXERCISE_TIME
				call	queue_message_for_display
				mov	bx, 100h
				mov	word ptr ds:gates_and_doors, bx
				mov	cx, 0E00h	    ; inlined set_location_0x000E
				call	set_hero_target_location
				mov	ah, 0Eh
				mov	cl, 0
				call	set_prisoners_and_guards_location_B
				retn
event_go_to_exercise_time	endp


; =============== S U B	R O U T	I N E =======================================


event_exercise_time		proc near		    ; DATA XREF: seg000:61F9o
				mov	[bx], al
				mov	cx, 8E04h
				call	set_hero_target_location
				mov	ah, 8Eh	; 'Ž'
				mov	cl, 4
				call	set_prisoners_and_guards_location_B
				retn
event_exercise_time		endp


; =============== S U B	R O U T	I N E =======================================


event_go_to_breakfast_time	proc near		    ; DATA XREF: seg000:61F0o
				mov	[bx], al
				mov	ch, message_BREAKFAST_TIME
				call	queue_message_for_display
				mov	cx, 1000h	    ; inlined set_location_0x0010
				call	set_hero_target_location
				mov	ah, 10h
				mov	cl, 0
				call	set_prisoners_and_guards_location_B
				retn
event_go_to_breakfast_time	endp


; =============== S U B	R O U T	I N E =======================================


go_to_roll_call			proc near		    ; CODE XREF: event_go_to_roll_call+7p
				mov	ah, 1Ah
				mov	cl, 0
				call	set_prisoners_and_guards_location
				mov	cx, 2D00h
				call	set_hero_target_location
				retn
go_to_roll_call			endp


; =============== S U B	R O U T	I N E =======================================


purge_visible_characters	proc near		    ; CODE XREF: enter_room-6666p
				mov	dx, ds:map_position
				sub	dl, 9
				jnb	short loc_650E
				mov	dl, 0

loc_650E:						    ; CODE XREF: purge_visible_characters+7j
				sub	dh, 9
				jnb	short loc_6515
				mov	dh, 0

loc_6515:						    ; CODE XREF: purge_visible_characters+Ej
				mov	cx, 7
				mov	bx, offset vischar_1 ; NPC visible characters.

loop:							    ; CODE XREF: purge_visible_characters+6Aj
				cmp	byte ptr [bx], 0FFh
				jz	short loc_656A	    ; skip unused characters
				mov	al, ds:room_index
				cmp	al, [bx+1Ch]
				jnz	short loc_6561
				mov	ax, [bx+1Ah]
				add	ax, 4		    ; inlined divide_by_8_with_rounding
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				mov	ah, al
				mov	al, dh
				cmp	al, ah
				jnb	short loc_6561
				add	al, 22h	; '"'
				jnb	short loc_6542
				mov	al, 0FFh

loc_6542:						    ; CODE XREF: purge_visible_characters+3Bj
				cmp	al, ah
				jb	short loc_6561
				mov	ax, [bx+18h]
				shr	ax, 1		    ; inlined divide_by_8
				shr	ax, 1
				shr	ax, 1
				mov	ah, al
				mov	al, dl
				cmp	al, ah
				jnb	short loc_6561
				add	al, 2Ah	; '*'
				jnb	short loc_655D
				mov	al, 0FFh

loc_655D:						    ; CODE XREF: purge_visible_characters+56j
				cmp	al, ah
				jnb	short loc_656A

loc_6561:						    ; CODE XREF: purge_visible_characters+23j
							    ; purge_visible_characters+37j ...
				push	bx
				push	dx
				push	cx
				call	reset_visible_character
				pop	cx
				pop	dx
				pop	bx

loc_656A:						    ; CODE XREF: purge_visible_characters+1Bj
							    ; purge_visible_characters+5Cj
				add	bx, 20h	; ' '
				loop	loop
				retn
purge_visible_characters	endp

; ---------------------------------------------------------------------------
message_queue			db 0FFh, 0FFh, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0FFh
							    ; DATA XREF: message_display+70o
							    ; seg000:message_queue_pointero ...
message_display_delay		db 0			    ; DATA XREF: message_displayr
							    ; message_display+7w ...
message_display_index		db 80h			    ; DATA XREF: message_display:reached_zeror
							    ; message_display+22w ...
message_queue_pointer		dw offset message_queue+2   ; DATA XREF: queue_message_for_display+3r
							    ; queue_message_for_display+1Aw ...
current_message_character	dw 0			    ; DATA XREF: message_display+15r
							    ; message_display:exitw ...

; =============== S U B	R O U T	I N E =======================================


queue_message_for_display	proc near		    ; CODE XREF: event_night_time+13p
							    ; event_go_to_roll_call+4p	...
				push	bx
				xchg	ch, cl
				mov	bx, ds:message_queue_pointer
				cmp	byte ptr [bx], message_QUEUE_END
				jz	short exit	    ; queue full
				cmp	cx, [bx-2]
				jz	short exit	    ; already in queue
				cmp	cx, [bx-4]
				jz	short exit	    ; already in queue
				mov	[bx], cx	    ; enqueue
				inc	bx
				inc	bx
				mov	ds:message_queue_pointer, bx

exit:							    ; CODE XREF: queue_message_for_display+Aj
							    ; queue_message_for_display+Fj ...
				xchg	ch, cl
				pop	bx
				retn
queue_message_for_display	endp


; =============== S U B	R O U T	I N E =======================================


message_display			proc near		    ; CODE XREF: enter_room-6678p
							    ; enter_room-6654p
				test	ds:message_display_delay, 0FFh
				jz	short reached_zero
				dec	ds:message_display_delay
				retn
; ---------------------------------------------------------------------------

reached_zero:						    ; CODE XREF: message_display+5j
				mov	al, ds:message_display_index
				cmp	al, 80h	; '€'
				jz	short next_message
				jnb	short wipe_message
				mov	bx, ds:current_message_character
				mov	di, offset message_text_screen_address
				cbw
				add	di, ax
				call	plot_glyph
				inc	ds:message_display_index ; different logic here
				inc	ds:message_display_index
				inc	bx
				cmp	byte ptr [bx], 0FFh
				jnz	short exit
				mov	ds:message_display_delay, 1Fh
				or	ds:message_display_index, 80h
				retn
; ---------------------------------------------------------------------------

exit:							    ; CODE XREF: message_display+2Ej
				mov	ds:current_message_character, bx
				retn
; ---------------------------------------------------------------------------

wipe_message:						    ; CODE XREF: message_display+13j
				dec	al
				dec	al
				mov	ds:message_display_index, al
				mov	di, offset message_text_screen_address
				and	al, 7Fh
				cbw
				add	di, ax
				mov	bx, offset space_character
				call	plot_glyph
				retn
; ---------------------------------------------------------------------------

next_message:						    ; CODE XREF: message_display+11j
				mov	bx, (offset message_queue+2)
				cmp	ds:message_queue_pointer, bx
				jnz	short loc_660B
				retn
; ---------------------------------------------------------------------------

loc_660B:						    ; CODE XREF: message_display+5Dj
				mov	al, [bx]
				cbw
				add	ax, ax
				mov	bx, offset messages_table
				add	bx, ax
				mov	bx, [bx]
				mov	ds:current_message_character, bx
				mov	di, offset message_queue
				mov	si, (offset message_queue+2)
				mov	cx, 16
				cld
				rep movsb
				dec	ds:message_queue_pointer
				dec	ds:message_queue_pointer
				mov	ds:message_display_index, 0
				retn
message_display			endp

; ---------------------------------------------------------------------------
messages_table			dw 665Eh, 666Fh, 667Fh,	668Eh, 669Ch, 66A9h, 66BCh, 66C7h, 66D5h, 66DFh, 66F0h,	6701h, 6712h
							    ; DATA XREF: message_display+65o
				dw 6723h, 6737h, 6748h,	6757h, 6767h, 677Ah, 678Ch
space_character			db 20h			    ; DATA XREF: message_display+4Fo
messages_missed_roll_call	db 'MISSED ROLL CALL',0FFh
messages_time_to_wake_up	db 'TIME TO WAKE UP',0FFh
messages_breakfast_time		db 'BREAKFAST TIME',0FFh
messages_exercise_time		db 'EXERCISE TIME',0FFh
messages_time_for_bed		db 'TIME FOR BED',0FFh
messages_the_door_is_locked	db 'THE DOOR IS LOCKED',0FFh
messages_it_is_open		db 'IT IS OPEN',0FFh
messages_incorrect_key		db 'INCORRECT KEY',0FFh
messages_roll_call		db 'ROLL CALL',0FFh
messages_red_cross_parcel	db 'RED CROSS PARCEL',0FFh
messages_picking_the_lock	db 'PICKING THE LOCK',0FFh
messages_cutting_the_wire	db 'CUTTING THE WIRE',0FFh
messages_you_open_the_box	db 'YOU OPEN THE BOX',0FFh
messages_you_are_in_solitary	db 'YOU ARE IN SOLITARY',0FFh
messages_wait_for_release	db 'WAIT FOR RELEASE',0FFh
messages_morale_is_zero		db 'MORALE IS ZERO',0FFh
messages_item_discovered	db 'ITEM DISCOVERED',0FFh
more_messages_he_takes_the_bribe db 'HE TAKES THE BRIBE',0FFh
more_messages_and_acts_as_decoy	db 'AND ACTS AS DECOY',0FFh
more_messages_another_day_dawns	db 'ANOTHER DAY DAWNS',0FFh

; =============== S U B	R O U T	I N E =======================================


transition			proc near		    ; CODE XREF: character_behaviour+21Dp
							    ; door_handling+5Cj ...
				push	ds
				pop	es
				cld
				mov	si, bx
				mov	di, bp
				add	di, 0Fh
				mov	al, ds:[bp+1Ch]
				mov	cx, 3
				and	al, al
				jnz	short loc_67BF

loc_67B3:						    ; CODE XREF: transition+1Dj
				lodsb
				mov	ah, 0
				shl	ax, 1		    ; multiply_by_4
				shl	ax, 1
				stosw
				loop	loc_67B3
				jmp	short loc_67C5
; ---------------------------------------------------------------------------

loc_67BF:						    ; CODE XREF: transition+13j
				mov	ah, 0

loc_67C1:						    ; CODE XREF: transition+25j
				lodsb
				stosw
				loop	loc_67C1

loc_67C5:						    ; CODE XREF: transition+1Fj
				mov	bx, bp
				cmp	bx, offset vischar_0 ; Hero's visible character.
				jz	short loc_67D1
				call	reset_visible_character
				retn
; ---------------------------------------------------------------------------

loc_67D1:						    ; CODE XREF: transition+2Dj
				and	byte ptr [bx+1], 7Fh
				mov	al, [bx+1Ch]
				mov	ds:room_index, al
				and	al, al
				jnz	short enter_room
				mov	byte ptr [bx+0Dh], 80h ; '€' ; input_KICK
				and	byte ptr [bx+0Eh], 3 ; likely a	sprite direction
				call	reset_outdoors
				jmp	short squash_stack_goto_main
transition			endp


; =============== S U B	R O U T	I N E =======================================


enter_room			proc near		    ; CODE XREF: main+6Bp
							    ; transition+3Fj ...

; FUNCTION CHUNK AT 016E SIZE 0000005F BYTES

				xor	ax, ax
				mov	ds:game_window_offset, ax
				call	setup_room
				call	plot_interior_tiles
				mov	byte ptr ds:map_position, 74h ;	't'
				mov	byte ptr ds:map_position+1, 0EAh ; 'ê'
				call	set_hero_sprite_for_room
				call	reset_position
				call	setup_movable_items
				call	zoombox
				mov	ch, 1
				call	increase_score

squash_stack_goto_main:					    ; CODE XREF: transition+4Cj
				mov	sp, 0FFFEh
				jmp	main_loop
enter_room			endp


; =============== S U B	R O U T	I N E =======================================


set_hero_sprite_for_room	proc near		    ; CODE XREF: enter_room+15p
				mov	bx, offset vischar_0 ; Hero's visible character.
				mov	byte ptr [bx+0Dh], 80h ; '€'
				cmp	ds:room_index, 1Dh
				jb	short loc_6830
				or	byte ptr [bx+0Eh], 4
				mov	word ptr [bx+15h], 9D7Bh
				retn
; ---------------------------------------------------------------------------

loc_6830:						    ; CODE XREF: set_hero_sprite_for_room+Cj
				and	byte ptr [bx+0Eh], 0FBh
				retn
set_hero_sprite_for_room	endp


; =============== S U B	R O U T	I N E =======================================


in_permitted_area		proc near		    ; CODE XREF: enter_room-6672p

; FUNCTION CHUNK AT 7F8A SIZE 00000033 BYTES
; FUNCTION CHUNK AT 7FBE SIZE 00000043 BYTES

				mov	si, 302h
				mov	di, offset hero_map_position
				mov	al, ds:room_index
				and	al, al
				jnz	short indoors
				call	pos_to_tinypos
				mov	bx, ds:vischar_0.scrx ;	Hero's visible character.
				sub	bx, 6C8h	    ; map range
				jb	short maybeescaped
				jmp	escaped
; ---------------------------------------------------------------------------

maybeescaped:						    ; CODE XREF: in_permitted_area+18j
				mov	bx, ds:vischar_0.scry ;	Hero's visible character.
				sbb	bx, 448h	    ; map range
				jb	short loc_6867
				jmp	escaped
; ---------------------------------------------------------------------------

indoors:						    ; CODE XREF: in_permitted_area+Bj
				push	ds
				pop	es
				cld
				movsb
				inc	si
				movsb
				inc	si
				movsb

loc_6867:						    ; CODE XREF: in_permitted_area+25j
				mov	al, ds:vischar_0.flags ; Hero's visible character.
				and	al, 3
				jz	short loc_6871
				jmp	loc_6924
; ---------------------------------------------------------------------------

loc_6871:						    ; CODE XREF: in_permitted_area+37j
				mov	al, ds:clock
				cmp	al, 64h	; 'd'
				jb	short loc_6885
				mov	al, ds:room_index
				cmp	al, 2
				jnz	short loc_6882
				jmp	loc_6905
; ---------------------------------------------------------------------------

loc_6882:						    ; CODE XREF: in_permitted_area+48j
				jmp	loc_6924
; ---------------------------------------------------------------------------

loc_6885:						    ; CODE XREF: in_permitted_area+41j
				mov	al, byte ptr ds:morale_1_2
				and	al, al
				jnz	short loc_6905
				mov	bx, offset vischar_0.target ; Hero's visible character.
				mov	al, [bx]
				inc	bx
				mov	cl, [bx]
				test	al, 80h
				jz	short loc_689A
				inc	cl

loc_689A:						    ; CODE XREF: in_permitted_area+61j
				cmp	al, 0FFh
				jnz	short loc_68B1
				mov	al, [bx]
				and	al, 0F8h
				cmp	al, 8
				mov	al, 1
				jz	short loc_68AA
				mov	al, 2

loc_68AA:						    ; CODE XREF: in_permitted_area+71j
				call	in_permitted_area_end_bit
				jz	short loc_6905
				jmp	short loc_6924
; ---------------------------------------------------------------------------

loc_68B1:						    ; CODE XREF: in_permitted_area+67j
				and	al, 7Fh
				mov	bx, offset maps_byte_to_pointer
				mov	ch, 7

loc_68B8:						    ; CODE XREF: in_permitted_area+8Cj
				cmp	al, [bx]
				jz	short loc_68C5
				add	bx, 3
				dec	ch
				jnz	short loc_68B8
				jmp	short loc_6905
; ---------------------------------------------------------------------------

loc_68C5:						    ; CODE XREF: in_permitted_area+85j
				mov	dx, [bx+1]
				mov	bx, dx
				mov	ch, 0
				add	bx, cx
				mov	al, [bx]
				push	dx
				call	in_permitted_area_end_bit
				pop	bx
				jz	short loc_6905
				mov	al, ds:vischar_0.target.x ; Hero's visible character.
				test	al, 80h
				jz	short loc_68DF
				inc	bx

loc_68DF:						    ; CODE XREF: in_permitted_area+A7j
				mov	cx, 0

loc_68E2:						    ; CODE XREF: in_permitted_area+C0j
				push	cx
				push	bx
				add	bx, cx
				mov	al, [bx]
				cmp	al, 0FFh
				jz	short loc_6901
				call	in_permitted_area_end_bit
				pop	bx
				pop	cx
				jz	short loc_68F7
				inc	cl
				jmp	short loc_68E2
; ---------------------------------------------------------------------------

loc_68F7:						    ; CODE XREF: in_permitted_area+BCj
				mov	al, ds:vischar_0.target.x ; Hero's visible character.
				mov	ch, al
				call	set_hero_target_location
				jmp	short loc_6905
; ---------------------------------------------------------------------------

loc_6901:						    ; CODE XREF: in_permitted_area+B5j
				pop	cx
				pop	bx
				jmp	short loc_6924
; ---------------------------------------------------------------------------

loc_6905:						    ; CODE XREF: in_permitted_area+4Aj
							    ; in_permitted_area+55j ...
				xor	al, al
				mov	cl, 44h	; 'D'

loc_6909:						    ; CODE XREF: in_permitted_area+100j
				mov	ds:red_flag, al
				mov	al, cl
				mov	bx, offset moraleflag_screen_attributes
				cmp	al, [bx]
				jz	short locret_6923
				cmp	al, 44h	; 'D'
				jnz	short loc_6920
				mov	al, 0FFh
				mov	ds:bell, al
				mov	al, cl

loc_6920:						    ; CODE XREF: in_permitted_area+E2j
				jmp	set_morale_flag_screen_attributes
; ---------------------------------------------------------------------------

locret_6923:						    ; CODE XREF: in_permitted_area+DEj
				retn
; ---------------------------------------------------------------------------

loc_6924:						    ; CODE XREF: in_permitted_area+39j
							    ; in_permitted_area:loc_6882j ...
				mov	cl, 42h	; 'B'
				mov	al, ds:moraleflag_screen_attributes
				cmp	al, cl
				jnz	short loc_692E
				retn
; ---------------------------------------------------------------------------

loc_692E:						    ; CODE XREF: in_permitted_area+F6j
				xor	al, al
				mov	ds:vischar_0.input, al ; Hero's visible character.
				mov	al, 0FFh
				jmp	short loc_6909
in_permitted_area		endp


; =============== S U B	R O U T	I N E =======================================


in_permitted_area_end_bit	proc near		    ; CODE XREF: in_permitted_area:loc_68AAp
							    ; in_permitted_area+9Cp ...
				mov	bx, offset room_index
				test	al, 80h
				jz	short loc_6943
				and	al, 7Fh		    ; return with flags
				cmp	al, [bx]
				retn
; ---------------------------------------------------------------------------

loc_6943:						    ; CODE XREF: in_permitted_area_end_bit+5j
				test	byte ptr [bx], 0FFh
				jnz	short or_al_1_then_return
				mov	si, offset hero_map_position
in_permitted_area_end_bit	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


within_camp_bounds		proc near		    ; CODE XREF: character_behaviour+42CDp
				shl	al, 1
				shl	al, 1
				mov	cl, al
				mov	ch, 0
				mov	bx, offset permitted_bounds
				add	bx, cx
				mov	cx, 2

loop:							    ; CODE XREF: within_camp_bounds+20j
				mov	al, [si]
				cmp	al, [bx]
				jb	short exit
				inc	bx
				cmp	al, [bx]
				jb	short next

or_al_1_then_return:					    ; CODE XREF: in_permitted_area_end_bit+Fj
							    ; within_camp_bounds+14j
exit:
				or	al, 1
				retn
; ---------------------------------------------------------------------------

next:							    ; CODE XREF: within_camp_bounds+19j
				inc	si
				inc	bx
				loop	loop
				and	al, ch
				retn
within_camp_bounds		endp

; ---------------------------------------------------------------------------
maps_byte_to_pointer		bytetopointer <2Ah, offset byte_6985>
							    ; DATA XREF: in_permitted_area+7Eo
							    ; nb, renamed from byte_to_pointer to avoid	IDA whinge
				bytetopointer <5, offset byte_6988>
				bytetopointer <0Eh, offset byte_698D>
				bytetopointer <10h, offset byte_6994>
				bytetopointer <2Ch, offset byte_699A>
				bytetopointer <2Bh, offset byte_699D>
				bytetopointer <2Dh, offset byte_699F>
byte_6985			db 82h			    ; DATA XREF: seg000:maps_byte_to_pointero
				db 82h
				db 0FFh
byte_6988			db 83h			    ; DATA XREF: seg000:6973o
				db 1
				db 1
				db 1
				db 0FFh
byte_698D			db 1			    ; DATA XREF: seg000:6976o
				db 1
				db 1
				db 0
				db 2
				db 2
				db 0FFh
byte_6994			db 1			    ; DATA XREF: seg000:6979o
				db 1
				db 95h
				db 97h
				db 99h
				db 0FFh
byte_699A			db 83h			    ; DATA XREF: seg000:697Co
				db 82h
				db 0FFh
byte_699D			db 99h			    ; DATA XREF: seg000:697Fo
				db 0FFh
byte_699F			db 1			    ; DATA XREF: seg000:6982o
				db 0FFh
duplicates_of_above		db 82h
				db 82h
				db 0FFh
				db 83h
				db 1
				db 1
				db 1
				db 0FFh
				db 1
				db 1
				db 1
				db 0
				db 2
				db 2
				db 0FFh
				db 1
				db 1
				db 95h
				db 97h
				db 99h
				db 0FFh
				db 83h
				db 82h
				db 0FFh
				db 99h
				db 0FFh
permitted_bounds		db 56h,	5Eh, 3Dh, 48h	    ; DATA XREF: within_camp_bounds+8o
				db 4Eh,	84h, 47h, 74h
				db 4Fh,	69h, 2Fh, 3Fh

; =============== S U B	R O U T	I N E =======================================


locate_vischar_or_itemstruct_then_plot proc near	    ; CODE XREF: enter_room-664Ep
							    ; locate_vischar_or_itemstruct_then_plot+Dj ...
				call	locate_vischar_or_itemstruct
				jz	short character
				retn
; ---------------------------------------------------------------------------

character:						    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+3j
				test	al, 64		    ; mysteryflagconst874
				jnz	short item
				call	setup_vischar_plotting
				jnz	short locate_vischar_or_itemstruct_then_plot
				call	mask_stuff
				cmp	ds:searchlight_state, searchlight_STATE_SEARCHING
				jz	short seehowwide
				call	searchlight_mask_test ;	test the mask_buffer to	see if the hero	is obscured behind something

seehowwide:						    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+17j
				cmp	byte ptr [bp+1Eh], 3 ; 3 => 16 wide
				jz	short mustbe16wide
				call	masked_sprite_plotter_24_wide
				jmp	short locate_vischar_or_itemstruct_then_plot
; ---------------------------------------------------------------------------

mustbe16wide:						    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+20j
				call	masked_sprite_plotter_16_wide
				jmp	short locate_vischar_or_itemstruct_then_plot
; ---------------------------------------------------------------------------

item:							    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+8j
				call	setup_item_plotting
				jnz	short locate_vischar_or_itemstruct_then_plot
				call	mask_stuff
				call	masked_sprite_plotter_16_wide_case_1_searchlight
locate_vischar_or_itemstruct_then_plot endp ; sp-analysis failed

				jmp	short locate_vischar_or_itemstruct_then_plot

; =============== S U B	R O U T	I N E =======================================

; test the mask_buffer to see if the hero is obscured behind something

searchlight_mask_test		proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+19p
				cmp	bp, offset vischar_0 ; Check the mask buffer to	see if the hero	is hiding behind something.
				jnz	short exit	    ; skip non-hero characters
				mov	bx, (offset mask_buffer+31h) ; Mask buffer.
				mov	cx, 8
				xor	al, al

loop:							    ; CODE XREF: searchlight_mask_test+15j
				cmp	al, [bx]
				jnz	short still_in_searchlight
				add	bx, 4
				loop	loop		    ; changed stuff here vs speccy
				mov	ds:searchlight_mask_test_result, searchlight_STATE_SEARCHING ; the hero	has escaped the	searchlight, so	decrement the counter.
				mov	bx, offset searchlight_state
				cmp	byte ptr [bx], 0
				jz	short exit
				dec	byte ptr [bx]
				retn
; ---------------------------------------------------------------------------

still_in_searchlight:					    ; CODE XREF: searchlight_mask_test+10j
				mov	ds:searchlight_mask_test_result, searchlight_STATE_0
				mov	bx, offset searchlight_state
				cmp	byte ptr [bx], 0
				jz	short exit
				mov	byte ptr [bx], searchlight_STATE_CAUGHT

exit:							    ; CODE XREF: searchlight_mask_test+4j
							    ; searchlight_mask_test+22j ...
				retn
searchlight_mask_test		endp


; =============== S U B	R O U T	I N E =======================================


move_characters			proc near		    ; CODE XREF: enter_room-666Cp
				mov	ds:entered_move_characters, 0FFh
				mov	al, ds:character_index
				inc	al
				cmp	al, character_26_STOVE_1 ; movable item
				jnz	short doesntwrap
				xor	al, al

doesntwrap:						    ; CODE XREF: move_characters+Cj
				mov	ds:character_index, al
				call	get_character_struct ; in: AL =	character index
							    ; out: BX =	character struct
				test	byte ptr [bx], characterstruct_FLAG_DISABLED
				jnz	short exit
				push	bx
				inc	bx
				mov	al, [bx]
				and	al, al
				jz	short exterior
				call	is_item_discoverable_interior
				jnz	short exterior
				call	item_discovered

exterior:						    ; CODE XREF: move_characters+21j
							    ; move_characters+26j
				pop	bx
				inc	bx
				inc	bx		    ; point at characterstruct pos
				push	bx		    ; save it
				inc	bx
				inc	bx
				inc	bx		    ; point at characterstruct target
				mov	al, [bx]	    ; fetch target.x
				and	al, al
				jnz	short targetxnonzero
				pop	bx

exit:							    ; CODE XREF: move_characters+19j
				retn
; ---------------------------------------------------------------------------

targetxnonzero:						    ; CODE XREF: move_characters+36j
				call	wassub_C651
				cmp	al, 0FFh
				jnz	short loc_6AA4
				mov	al, ds:character_index
				and	al, al
				jz	short loc_6A97
				cmp	al, 0Ch		    ; character_12_GUARD_12
				jnb	short loc_6A9F

loc_6A84:						    ; CODE XREF: move_characters+65j
				mov	al, [bx]
				xor	al, 80h
				mov	[bx], al
				inc	bx
				test	al, 80h
				jz	short loc_6A93
				dec	byte ptr [bx]
				dec	byte ptr [bx]

loc_6A93:						    ; CODE XREF: move_characters+55j
				inc	byte ptr [bx]
				pop	bx
				retn
; ---------------------------------------------------------------------------

loc_6A97:						    ; CODE XREF: move_characters+46j
				mov	al, [bx]
				and	al, 7Fh		    ; characterstruct_BYTE5_MASK
				cmp	al, 24h	; '$'
				jnz	short loc_6A84

loc_6A9F:						    ; CODE XREF: move_characters+4Aj
				pop	dx
				call	character_event
				retn
; ---------------------------------------------------------------------------

loc_6AA4:						    ; CODE XREF: move_characters+3Fj
				cmp	al, 80h	; '€'
				jz	short loc_6AAB
				jmp	loc_6B2A
; ---------------------------------------------------------------------------

loc_6AAB:						    ; CODE XREF: move_characters+6Ej
				pop	si
				dec	si
				mov	al, [si]
				inc	si
				push	bx
				and	al, al
				jnz	short loc_6ACA
				push	si
				mov	si, offset saved_pos
				mov	cx, 2

loc_6ABC:						    ; CODE XREF: move_characters+8Cj
				mov	al, [bx]
				shr	al, 1
				mov	[si], al
				inc	bx
				inc	si
				loop	loc_6ABC
				mov	bx, offset saved_pos
				pop	si

loc_6ACA:						    ; CODE XREF: move_characters+7Bj
				dec	si
				mov	al, [si]
				inc	si
				and	al, al
				mov	al, 2
				jz	short loc_6AD6
				mov	al, 6

loc_6AD6:						    ; CODE XREF: move_characters+9Aj
				mov	ch, 0
				call	change_by_delta
				inc	si
				inc	bx
				call	change_by_delta
				pop	bx
				cmp	ch, 2		    ; managed to move
				jz	short loc_6AE7
				retn
; ---------------------------------------------------------------------------

loc_6AE7:						    ; CODE XREF: move_characters+ACj
				dec	si
				dec	si
				dec	bx
				mov	al, [bx]
				shr	al, 1
				shr	al, 1
				mov	[si], al
				mov	al, [bx]
				and	al, 3
				cmp	al, 2
				jnb	short loc_6B01
				inc	bx
				inc	bx
				inc	bx
				inc	bx
				inc	bx
				jmp	short loc_6B04
; ---------------------------------------------------------------------------

loc_6B01:						    ; CODE XREF: move_characters+C0j
				dec	bx
				dec	bx
				dec	bx

loc_6B04:						    ; CODE XREF: move_characters+C7j
				mov	al, [si]
				inc	si
				and	al, al
				jz	short loc_6B1A
				mov	ax, [bx]
				mov	[si], ax
				inc	bx
				inc	bx
				inc	si
				inc	si
				mov	al, [bx]
				mov	[si], al
				inc	bx
				jmp	short loc_6B48
; ---------------------------------------------------------------------------

loc_6B1A:						    ; CODE XREF: move_characters+D1j
				mov	cx, 3

loc_6B1D:						    ; CODE XREF: move_characters+EDj
				mov	al, [bx]
				shr	al, 1
				mov	[si], al
				inc	bx
				inc	si
				loop	loc_6B1D
				dec	si
				jmp	short loc_6B48
; ---------------------------------------------------------------------------

loc_6B2A:						    ; CODE XREF: move_characters+70j
				pop	si
				dec	si
				mov	al, [si]	    ; get room
				inc	si
				and	al, al		    ; room_0_OUTDOORS?
				mov	al, 2
				jz	short loc_6B37
				mov	al, 6

loc_6B37:						    ; CODE XREF: move_characters+FBj
				mov	ch, 0
				call	change_by_delta
				inc	bx
				inc	si
				call	change_by_delta
				inc	si
				cmp	ch, 2
				jz	short loc_6B48
				retn
; ---------------------------------------------------------------------------

loc_6B48:						    ; CODE XREF: move_characters+E0j
							    ; move_characters+F0j ...
				inc	si
				mov	al, [si]	    ; target
				cmp	al, 0FFh
				jz	short exit_0
				test	al, 80h
				jnz	short loc_6B57
				inc	byte ptr [si+1]

exit_0:							    ; CODE XREF: move_characters+115j
				retn
; ---------------------------------------------------------------------------

loc_6B57:						    ; CODE XREF: move_characters+119j
				dec	byte ptr [si+1]
				retn
move_characters			endp


; =============== S U B	R O U T	I N E =======================================


change_by_delta			proc near		    ; CODE XREF: move_characters+A0p
							    ; move_characters+A5p ...
				mov	cl, al
				mov	al, [si]
				sub	al, [bx]
				jnz	short loc_6B67
				inc	ch
				jmp	short loc_6B7D
; ---------------------------------------------------------------------------

loc_6B67:						    ; CODE XREF: change_by_delta+6j
				jnb	short loc_6B75
				neg	al
				cmp	al, cl
				jb	short loc_6B71
				mov	al, cl

loc_6B71:						    ; CODE XREF: change_by_delta+12j
				add	[si], al
				jmp	short loc_6B7D
; ---------------------------------------------------------------------------

loc_6B75:						    ; CODE XREF: change_by_delta:loc_6B67j
				cmp	al, cl
				jb	short loc_6B7B
				mov	al, cl

loc_6B7B:						    ; CODE XREF: change_by_delta+1Cj
				sub	[si], al

loc_6B7D:						    ; CODE XREF: change_by_delta+Aj
							    ; change_by_delta+18j
				mov	al, cl
				retn
change_by_delta			endp


; =============== S U B	R O U T	I N E =======================================

; in: AL = character index
; out: BX = character struct

get_character_struct		proc near		    ; CODE XREF: set_character_locationp
							    ; move_characters+13p ...
				mov	bl, al
				mov	bh, 0
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				sub	bl, al
				add	bx, offset character_structs
				retn
get_character_struct		endp


; =============== S U B	R O U T	I N E =======================================


process_player_input		proc near		    ; CODE XREF: enter_room-6675p
				test	ds:morale_1_2, 0FFFFh
				jz	short loc_6B9A
				retn
; ---------------------------------------------------------------------------

loc_6B9A:						    ; CODE XREF: process_player_input+6j
				mov	bx, offset vischar_0 ; Hero's visible character.
				mov	al, [bx+1]
				and	al, 3
				jz	short loc_6BA7
				jmp	picking_a_lock
; ---------------------------------------------------------------------------

loc_6BA7:						    ; CODE XREF: process_player_input+11j
				call	input_routine
				or	al, al
				jnz	short loc_6BBD
				test	ds:automatic_player_counter, 0FFh
				jz	short locret_6C34
				dec	ds:automatic_player_counter
				xor	al, al
				jmp	short loc_6C2A
; ---------------------------------------------------------------------------

loc_6BBD:						    ; CODE XREF: process_player_input+1Bj
				push	bx
				push	ax
				mov	ds:automatic_player_counter, 1Fh
				mov	al, ds:hero_in_bed
				and	al, al
				jnz	short loc_6BF0
				mov	al, ds:hero_in_breakfast
				and	al, al
				jz	short loc_6C1F
				mov	byte ptr [bx+2], 2Bh ; '+'
				mov	byte ptr [bx+3], 0
				mov	word ptr [bx+0Fh], 34h ; '4'
				mov	word ptr [bx+11h], 3Eh ; '>'
				mov	ds:roomdef_25_breakfast_bench_G, interiorobject_EMPTY_BENCH
				mov	ds:hero_in_breakfast, 0
				jmp	short loc_6C19
; ---------------------------------------------------------------------------

loc_6BF0:						    ; CODE XREF: process_player_input+38j
				mov	byte ptr [bx+2], 2Ch ; ','
				mov	byte ptr [bx+3], 1
				mov	byte ptr [bx+4], 2Eh ; '.'
				mov	byte ptr [bx+5], 2Eh ; '.'
				mov	word ptr [bx+0Fh], 2Eh ; '.'
				mov	word ptr [bx+11h], 2Eh ; '.'
				mov	word ptr [bx+13h], 18h
				mov	ds:room2_hut2_left_bed,	9
				mov	ds:hero_in_bed,	0

loc_6C19:						    ; CODE XREF: process_player_input+5Dj
				call	setup_room
				call	plot_interior_tiles

loc_6C1F:						    ; CODE XREF: process_player_input+3Fj
				pop	ax
				cmp	al, 9
				jb	short loc_6C29
				call	process_player_input_fire
				mov	al, 80h	; '€'

loc_6C29:						    ; CODE XREF: process_player_input+91j
				pop	bx

loc_6C2A:						    ; CODE XREF: process_player_input+2Aj
				cmp	al, [bx+0Dh]
				jz	short locret_6C34
				or	al, 80h
				mov	[bx+0Dh], al

locret_6C34:						    ; CODE XREF: process_player_input+22j
							    ; process_player_input+9Cj
				retn
; ---------------------------------------------------------------------------

picking_a_lock:						    ; CODE XREF: process_player_input+13j
				mov	ds:automatic_player_counter, 1Fh
				cmp	al, 1
				jnz	short snipping_wire
				mov	al, ds:player_locked_out_until
				cmp	al, ds:game_counter
				jnz	short exit
				mov	bx, ds:ptr_to_door_being_lockpicked
				and	byte ptr [bx], 7Fh  ; ~gates_and_doors_LOCKED
				mov	cx, 600h	    ; message_IT_IS_OPEN
				call	queue_message_for_display
				and	ds:vischar_0.flags, 0FCh ; Hero's visible character.
				retn
; ---------------------------------------------------------------------------

snipping_wire:						    ; CODE XREF: process_player_input+ABj
				mov	al, ds:player_locked_out_until
				sub	al, ds:game_counter
				jz	short snipped
				cmp	al, 4
				jnb	short exit
				mov	bx, offset vischar_0 ; Hero's visible character.
				mov	si, offset snipping_wire_new_inputs
				mov	al, [bx+0Eh]
				and	al, 3
				cbw
				add	si, ax
				mov	al, [si]
				mov	[bx+0Dh], al
				retn
; ---------------------------------------------------------------------------

snipped:						    ; CODE XREF: process_player_input+D0j
				mov	bx, offset vischar_0 ; Hero's visible character.
				mov	byte ptr [bx+0Eh], 0
				mov	byte ptr [bx+0Dh], 80h ; '€' ; input_KICK
				mov	byte ptr [bx+13h], 18h
				and	byte ptr [bx+1], 0FCh

exit:							    ; CODE XREF: process_player_input+B4j
							    ; process_player_input+D4j
				retn
process_player_input		endp

; ---------------------------------------------------------------------------
snipping_wire_new_inputs	db 84h			    ; DATA XREF: process_player_input+D9o
				db 87h
				db 88h
				db 85h

; =============== S U B	R O U T	I N E =======================================


plot_statics_and_menu_text	proc near		    ; CODE XREF: main+16p
				push	es
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				mov	si, offset static_graphic_defs
				mov	cx, 12h

loop:							    ; CODE XREF: plot_statics_and_menu_text+1Fj
				push	cx
				lodsw
				mov	di, ax
				test	byte ptr [si], 80h
				jz	short horizontal
				call	plot_static_tiles_vertical
				jmp	short cont
; ---------------------------------------------------------------------------
				nop			    ; odd

horizontal:						    ; CODE XREF: plot_statics_and_menu_text+13j
				call	plot_static_tiles_horizontal

cont:							    ; CODE XREF: plot_statics_and_menu_text+18j
				pop	cx
				loop	loop
				call	plot_menu_text
				pop	es
				assume es:nothing
				retn
plot_statics_and_menu_text	endp

; ---------------------------------------------------------------------------
static_tiles_plot_direction	db 0FFh			    ; DATA XREF: plot_static_tiles_vertical+3w
							    ; plot_static_tiles_vertical+56r

; =============== S U B	R O U T	I N E =======================================


plot_static_tiles_horizontal	proc near		    ; CODE XREF: plot_statics_and_menu_text:horizontalp
				xor	al, al
				jmp	short plot_static_tiles
plot_static_tiles_horizontal	endp


; =============== S U B	R O U T	I N E =======================================


plot_static_tiles_vertical	proc near		    ; CODE XREF: plot_statics_and_menu_text+15p
				mov	al, 0FFh

plot_static_tiles:					    ; CODE XREF: plot_static_tiles_horizontal+2j
				push	bp
				mov	ds:static_tiles_plot_direction,	al
				lodsb
				and	al, 7Fh
				cbw
				mov	cx, ax

loop:							    ; CODE XREF: plot_static_tiles_vertical+63j
				push	cx
				lodsb
				cbw
				mov	bx, ax
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				add	ax, bx
				mov	bx, offset static_tiles
				add	bx, ax
				push	bx
				mov	al, [bx+8]
				and	al, 0Fh
				mov	bx, offset plot_game_window_masks
				xlat
				mov	dl, al
				mov	dh, al
				pop	bx
				mov	bp, offset plot_game_window_table
				mov	cx, 8
				push	si
				mov	word ptr ds:loc_6D07+1,	dx ; self modify
				mov	dx, di
				xor	dx, 2000h

innerloop:						    ; CODE XREF: plot_static_tiles_vertical+54j
				mov	al, [bx]
				inc	bx
				xor	ah, ah
				shl	ax, 1
				mov	si, ax
				mov	ax, [bp+si]

loc_6D07:						    ; DATA XREF: plot_static_tiles_vertical+34w
				and	ax, 0FFFFh
				mov	es:[di], ax
				xchg	di, dx
				add	dx, 50h	; 'P'
				loop	innerloop
				test	ds:static_tiles_plot_direction,	0FFh
				jnz	short loc_6D1F
				sub	di, 13Eh

loc_6D1F:						    ; CODE XREF: plot_static_tiles_vertical+5Bj
				pop	si
				pop	cx
				loop	loop
				pop	bp
				retn
plot_static_tiles_vertical	endp


; =============== S U B	R O U T	I N E =======================================


wipe_full_screen_and_attributes	proc near		    ; CODE XREF: main+Cp
				push	es
				mov	ax, 4
				int	10h		    ; -	VIDEO -	SET VIDEO MODE
							    ; AL = mode
				mov	ah, 0Bh
				mov	bh, 1
				mov	bl, 0
				int	10h		    ; -	VIDEO -	SET COLOR PALETTE
							    ; BH = 00h,	BL = border color
							    ; BH = 01h,	BL = palette (0-3)
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				mov	di, 0
				mov	ax, 0
				mov	cx, 2000h
				rep stosw
				pop	es
				assume es:nothing
				retn
wipe_full_screen_and_attributes	endp

; ---------------------------------------------------------------------------
static_graphic_defs		dw 14Ah			    ; DATA XREF: plot_statics_and_menu_text+6o
							    ; statics_flagpole
				db  94h, 18h, 19h, 19h,	19h, 19h, 19h, 19h, 19h, 19h, 19h, 19h,	19h, 19h, 19h, 19h, 19h
				db  19h, 19h, 1Ah, 1Ah
				dw 14h			    ; statics_game_window_left_border
				db  94h,   2,	4, 11h,	12h, 11h, 12h, 11h, 12h, 11h, 12h, 11h,	12h, 11h, 12h, 11h, 12h
				db  11h, 12h, 0Eh, 10h
				dw 44h			    ; statics_game_window_right_border
				db  94h,   5,	7, 11h,	12h, 11h, 12h, 11h, 12h, 11h, 12h, 11h,	12h, 11h, 12h, 11h, 12h
				db  11h, 12h,	9, 0Bh
				dw 156h			    ; statics_game_window_top_border
				db  17h, 13h, 14h, 13h,	14h, 13h, 14h, 13h, 14h, 13h, 14h, 15h,	16h, 17h, 13h, 14h, 13h
				db  14h, 13h, 14h, 13h,	14h, 13h, 14h
				dw 1696h		    ; statics_game_window_bottom
				db  17h, 13h, 14h, 13h,	14h, 13h, 14h, 13h, 14h, 13h, 14h, 15h,	16h, 17h, 13h, 14h, 13h
				db  14h, 13h, 14h, 13h,	14h, 13h, 14h
				dw 1A48h		    ; statics_flagpole_grass
				db    5, 1Fh, 1Bh, 1Ch,	1Dh, 1Eh
				dw 17EEh		    ; statics_medals_row0
				db  0Dh, 20h, 21h, 22h,	21h, 23h, 21h, 24h, 21h, 22h, 21h, 25h,	0Bh, 0Ch
				dw 192Eh		    ; statics_medals_row1
				db  0Bh, 26h, 4Eh, 27h,	4Eh, 28h, 4Eh, 29h, 4Eh, 27h, 4Eh, 2Ah
				dw 1A6Eh		    ; statics_medals_row2
				db  0Bh, 2Bh, 2Ch, 2Dh,	2Ch, 2Eh, 2Ch, 2Fh, 2Ch, 2Dh, 2Ch, 30h
				dw 1BAEh		    ; statics_medals_row3
				db  0Bh, 31h, 32h, 33h,	34h, 35h, 36h, 37h, 38h, 39h, 3Ah, 3Bh
				dw 1CEEh		    ; statics_medals_row4
				db  0Ah, 3Ch, 3Dh, 3Eh,	3Fh, 40h, 41h, 42h, 43h, 44h, 45h
				dw 17E4h		    ; statics_bell_row0
				db    3, 46h, 47h, 48h
				dw 1924h		    ; statics_bell_row1
				db    3, 49h, 4Ah, 4Bh,	64h
				dw 21Ah			    ; statics_bell_row2
				db  4Ch, 4Dh
				dw 12h			    ; statics_corner_tl
				db  82h,   1,	3
				dw 46h			    ; statics_corner_tr
				db  82h,   6,	8
				dw 1692h
				db  82h, 0Dh, 0Fh	    ; statics_corner_bl
				dw 16C6h		    ; statics_corner_br
				db  82h, 0Ah, 0Ch

; =============== S U B	R O U T	I N E =======================================


keyscan_break			proc near		    ; CODE XREF: enter_room-667Bp
				mov	al, ds:keything_1
				cmp	al, 1
				jnz	short exit
				call	keyscan_THING2
				jmp	short doreset
; ---------------------------------------------------------------------------
				nop			    ; odd

exit:							    ; CODE XREF: keyscan_break+5j
				retn
; ---------------------------------------------------------------------------

doreset:						    ; CODE XREF: keyscan_break+Aj
				call	screen_reset
				call	user_confirm
				pushf
				call	keyscan_THING1
				popf
				jnz	short loc_6E50
				jmp	short reset_game
; ---------------------------------------------------------------------------
				nop			    ; odd

loc_6E50:						    ; CODE XREF: keyscan_break+19j
				mov	al, ds:room_index
				and	al, al
				jnz	short loc_6E5A
				jmp	reset_outdoors
; ---------------------------------------------------------------------------

loc_6E5A:						    ; CODE XREF: keyscan_break+23j
				jmp	enter_room
keyscan_break			endp


; =============== S U B	R O U T	I N E =======================================


screen_reset			proc near		    ; CODE XREF: keyscan_break:doresetp
							    ; in_permitted_area:escapedp
				call	wipe_visible_tiles
				mov	ds:game_window_attribute, 7
				call	plot_interior_tiles
				call	zoombox
				call	plot_game_window
				call	set_game_window_attributes
				retn
screen_reset			endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR user_confirm

loc_6E72:						    ; CODE XREF: user_confirm+1Ej
				mov	ah, 0
				mov	al, 3
				int	10h		    ; -	VIDEO -	SET VIDEO MODE
							    ; AL = mode
				mov	ax, 4C00h
				int	21h		    ; DOS - 2+ - QUIT WITH EXIT	CODE (EXIT)
; END OF FUNCTION CHUNK	FOR user_confirm		    ; AL = exit	code

; =============== S U B	R O U T	I N E =======================================


user_confirm			proc near		    ; CODE XREF: keyscan_break+11p
							    ; user_confirm+Aj

; FUNCTION CHUNK AT 6E72 SIZE 0000000B BYTES

				mov	ah, 1
				int	16h		    ; KEYBOARD - CHECK BUFFER, DO NOT CLEAR
							    ; Return: ZF clear if character in buffer
							    ; AH = scan	code, AL = character
							    ; ZF set if	no character in	buffer
				jz	short plot
				mov	ah, 0
				int	16h		    ; KEYBOARD - READ CHAR FROM	BUFFER,	WAIT IF	EMPTY
							    ; Return: AH = scan	code, AL = character
				jmp	short user_confirm
; ---------------------------------------------------------------------------

plot:							    ; CODE XREF: user_confirm+4j
				mov	bx, offset screenlocstring_confirm_y_or_n
				call	screenlocstring_plot

loop:							    ; CODE XREF: user_confirm+23j
				mov	ah, 0
				int	16h		    ; KEYBOARD - READ CHAR FROM	BUFFER,	WAIT IF	EMPTY
							    ; Return: AH = scan	code, AL = character
				cmp	ah, 15h
				jz	short exit	    ; 'N'
				cmp	ah, 10h
				jz	short loc_6E72	    ; 'Y'
				cmp	ah, 31h	; '1'
				jnz	short loop
				or	ah, ah

exit:							    ; CODE XREF: user_confirm+19j
				retn
user_confirm			endp

; ---------------------------------------------------------------------------
screenlocstring_confirm_y_or_n	screenstring <141Eh, 15>    ; DATA XREF: user_confirm:ploto
aConfirm_YOrN			db 'CONFIRM. Y OR N'

; =============== S U B	R O U T	I N E =======================================


reset_game			proc near		    ; CODE XREF: main+68p
							    ; keyscan_break+1Bj ...
				mov	cx, 1000h
reset_game			endp ; sp-analysis failed

; START	OF FUNCTION CHUNK FOR reset_game_continued

discoverallitems:					    ; CODE XREF: reset_game_continuedj
				push	cx
				call	item_discovered
				pop	cx
				inc	cl
				dec	ch
; END OF FUNCTION CHUNK	FOR reset_game_continued

; =============== S U B	R O U T	I N E =======================================


reset_game_continued		proc near

; FUNCTION CHUNK AT 6EBA SIZE 00000009 BYTES

				jnz	short discoverallitems
				mov	bx, (offset message_queue+2) ; reset message queue
				mov	ds:message_queue_pointer, bx
				call	reset_map_and_characters
				xor	al, al
				mov	ds:vischar_0.flags, al ; Hero's visible character.
				mov	bx, offset score_digits
				mov	cx, 5

resetscoreloop:						    ; CODE XREF: reset_game_continued+1Bj
				mov	byte ptr [bx], '0'
				inc	bx
				loop	resetscoreloop
				mov	cx, 5

resetsomethingelse:					    ; CODE XREF: reset_game_continued+24j
				mov	byte ptr [bx], 0
				inc	bx
				loop	resetsomethingelse
				mov	byte ptr [bx], 70h ; 'p'
				call	plot_score
				mov	bx, 0FFFFh
				mov	ds:items_held, bx
				call	draw_all_items
				mov	bx, offset sprite_prisoner_facing_away_4
				mov	ds:vischar_0.mi.sprite,	bx ; Hero's visible character.
				mov	ds:room_index, 2
				call	hero_sleeps
				call	enter_room
				retn
reset_game_continued		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


reset_map_and_characters	proc near		    ; CODE XREF: reset_game_continued+9p
							    ; character_behaviour+42FBp
				mov	cx, 7
				mov	bx, offset vischar_1 ; NPC visible characters.

resetallvischars:					    ; CODE XREF: reset_map_and_characters+10j
				push	cx
				push	bx
				call	reset_visible_character
				pop	bx
				add	bx, 20h	; ' '
				pop	cx
				loop	resetallvischars
				mov	al, 7
				mov	ds:clock, 7
				xor	al, al
				mov	ds:day_or_night, al
				mov	ds:vischar_0.flags, al ; Hero's visible character.
				mov	ds:roomdef_50_blocked_tunnel_collapsed_tunnel, interiorobject_COLLAPSED_TUNNEL_SW_NE
				mov	ds:roomdef_50_blocked_tunnel_boundary, 34h ; '4'
				mov	bx, offset gates_and_doors_2
				mov	cx, 9

lockgatesloop:						    ; CODE XREF: reset_map_and_characters+35j
				or	byte ptr [bx], 80h  ; gates_and_doors_LOCKED
				inc	bx
				loop	lockgatesloop	    ; gates_and_doors_LOCKED
				mov	cx, 6
				mov	al, interiorobject_OCCUPIED_BED
				mov	bx, offset beds

resetbedsloop:						    ; CODE XREF: reset_map_and_characters+45j
				mov	di, [bx]
				inc	bx
				inc	bx
				mov	[di], al
				loop	resetbedsloop
				mov	al, interiorobject_EMPTY_BENCH
				mov	ds:roomdef_23_breakfast_bench_A, al
				mov	ds:roomdef_23_breakfast_bench_B, al
				mov	ds:roomdef_23_breakfast_bench_C, al
				mov	ds:roomdef_25_breakfast_bench_D, al
				mov	ds:roomdef_25_breakfast_bench_E, al
				mov	ds:roomdef_25_breakfast_bench_F, al
				mov	ds:roomdef_25_breakfast_bench_G, al
				mov	di, (offset character_structs+55h) ; &character_structs[12].room
				mov	cx, 0Ah
				mov	si, offset character_reset_data

resetcharactersloop:					    ; CODE XREF: reset_map_and_characters:loc_6F92j
				push	cx
				mov	cx, 3

copyloop:						    ; CODE XREF: reset_map_and_characters+71j
				mov	al, [si]
				mov	[di], al
				inc	di
				inc	si
				loop	copyloop
				pop	cx
				mov	byte ptr [di], 12h
				inc	di
				mov	byte ptr [di], 0
				inc	di
				inc	di
				inc	di
				cmp	cx, 7
				jnz	short loc_6F92	    ; &character_structs[20].room
				mov	di, (offset character_structs+8Dh)

loc_6F92:						    ; CODE XREF: reset_map_and_characters+81j
				loop	resetcharactersloop
				retn
reset_map_and_characters	endp

; ---------------------------------------------------------------------------
gates_and_doors_2		db 80h			    ; DATA XREF: reset_map_and_characters+2Bo
				db 81h
				db 8Dh
				db 8Ch
				db 8Eh
				db 0A2h
				db 98h
				db 9Fh
				db 96h
character_reset_data		db 3, 28h, 3Ch		    ; DATA XREF: reset_map_and_characters+64o
				db 3, 24h, 30h
				db 5, 28h, 3Ch
				db 5, 24h, 22h
				db 0FFh, 34h, 3Ch
				db 0FFh, 34h, 2Ch
				db 0FFh, 34h, 1Ch
				db 0FFh, 34h, 3Ch
				db 0FFh, 34h, 2Ch
				db 0FFh, 34h, 1Ch

; =============== S U B	R O U T	I N E =======================================


called_from_main_loop_3		proc near		    ; CODE XREF: enter_room-666Fp
				push	ds
				pop	es
				cld
				mov	cx, 8
				mov	bp, offset vischar_0 ; Hero's visible character.

loop:							    ; CODE XREF: called_from_main_loop_3+63j
				push	cx
				mov	al, [bp+1]
				cmp	al, room_NONE
				jz	short next
				mov	ax, [bp+1Ah]
				shr	ax, 1		    ; divide_by_8
				shr	ax, 1
				shr	ax, 1
				mov	ds:map_position_related.y, al
				mov	ax, [bp+18h]
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				mov	ds:map_position_related.x, al
				call	vischar_visible
				cmp	al, 0FFh	    ; not found
				jz	short next
				mov	al, dl
				shr	al, 1		    ; divide_by_8
				shr	al, 1
				shr	al, 1
				add	al, 2
				push	ax
				mov	bx, offset map_position_related.y
				add	al, [bx]
				mov	bx, (offset map_position+1)
				sub	al, [bx]
				jb	short loc_7011
				sub	al, 11h
				jbe	short loc_7011
				mov	dl, al
				pop	ax
				sub	al, dl
				jbe	short next
				jmp	short loc_7012
; ---------------------------------------------------------------------------
				nop			    ; odd

loc_7011:						    ; CODE XREF: called_from_main_loop_3+45j
							    ; called_from_main_loop_3+49j
				pop	ax

loc_7012:						    ; CODE XREF: called_from_main_loop_3+52j
				cmp	al, 5
				jb	short loc_7018	    ; if (al > 5) al = 5;
				mov	al, 5

loc_7018:						    ; CODE XREF: called_from_main_loop_3+58j
				call	loc_7022	    ; is a subroutine here, was	inlined	before

next:							    ; CODE XREF: called_from_main_loop_3+Fj
							    ; called_from_main_loop_3+2Ej ...
				pop	cx
				add	bp, 20h	; ' '
				loop	loop
				retn
; ---------------------------------------------------------------------------

loc_7022:						    ; CODE XREF: called_from_main_loop_3:loc_7018p
				mov	byte ptr ds:loc_7089+1,	al
				mov	al, cl
				mov	byte ptr ds:loc_708D+1,	al
				mov	byte ptr ds:loc_70B1+2,	al
				mov	al, 18h
				sub	al, cl
				mov	byte ptr ds:loc_70B6+2,	al
				add	al, 0A8h ; '¨'
				mov	byte ptr ds:loc_70B9+2,	al
				mov	bx, offset map_position
				xor	al, al
				and	ch, ch
				jnz	short loc_7047
				mov	al, ds:map_position_related.x
				sub	al, [bx]

loc_7047:						    ; CODE XREF: called_from_main_loop_3+84j
				mov	ch, al
				xor	al, al
				and	dh, dh
				jnz	short loc_7055
				inc	bx
				mov	al, ds:map_position_related.y
				sub	al, [bx]

loc_7055:						    ; CODE XREF: called_from_main_loop_3+91j
				mov	cl, al
				mov	dx, cx
				mov	ah, cl
				xor	al, al
				shr	ax, 1
				mov	di, ax
				shr	ax, 1
				add	di, ax
				mov	al, ch
				xor	ah, ah
				add	di, ax
				add	di, offset window_buf
				mov	al, cl
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				mov	bx, ax
				shl	ax, 1
				add	bx, ax
				mov	al, ch
				xor	ah, ah
				add	bx, ax
				add	bx, offset tile_buf

loc_7089:						    ; DATA XREF: called_from_main_loop_3:loc_7022w
				mov	cx, 5

loc_708C:						    ; CODE XREF: called_from_main_loop_3+102j
				push	cx

loc_708D:						    ; DATA XREF: called_from_main_loop_3+6Bw
				mov	cl, 4		    ; self-modified

loc_708F:						    ; CODE XREF: called_from_main_loop_3+F3j
				mov	al, [bx]
				call	select_tile_set
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				add	si, ax
				mov	ch, 8

loc_70A0:						    ; CODE XREF: called_from_main_loop_3+EAj
				movsb
				add	di, 17h
				dec	ch
				jnz	short loc_70A0
				inc	dh
				inc	bx
				sub	di, 0BFh ; '¿'
				loop	loc_708F

loc_70B1:						    ; DATA XREF: called_from_main_loop_3+6Ew
				sub	dh, 0		    ; self-modified
				inc	dl

loc_70B6:						    ; DATA XREF: called_from_main_loop_3+75w
				add	bx, 14h		    ; self-modified

loc_70B9:						    ; DATA XREF: called_from_main_loop_3+7Aw
				add	di, 0BCh ; '¼'      ; self-modified
				pop	cx
				loop	loc_708C
				retn
called_from_main_loop_3		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


select_tile_set			proc near		    ; CODE XREF: called_from_main_loop_3+D5p
				test	ds:room_index, room_NONE ; not stricly room_NONE but testing any bits set
				jz	short exterior
				mov	si, offset interior_tiles
				retn
; ---------------------------------------------------------------------------

exterior:						    ; CODE XREF: select_tile_set+5j
				push	ax
				xor	ah, ah
				mov	al, byte ptr ds:map_position+1
				and	al, 3
				add	al, dl
				shr	al, 1
				shr	al, 1
				mov	si, ax
				shl	si, 1
				shl	si, 1
				shl	si, 1
				sub	si, ax
				mov	al, byte ptr ds:map_position
				and	al, 3
				add	al, dh
				shr	al, 1
				shr	al, 1
				add	si, ax
				add	si, offset map_buf
				mov	al, [si]
				mov	si, offset exterior_tiles_1
				cmp	al, 2Dh	; '-'
				jb	short allgood
				mov	si, offset exterior_tiles_2
				cmp	al, 8Bh	; '‹'
				jb	short allgood
				cmp	al, 0CCh ; 'Ì'
				jnb	short allgood
				mov	si, offset exterior_tiles_3

allgood:						    ; CODE XREF: select_tile_set+3Bj
							    ; select_tile_set+42j ...
				pop	ax
				retn
select_tile_set			endp


; =============== S U B	R O U T	I N E =======================================


called_from_main_loop_9		proc near		    ; CODE XREF: enter_room-665Ap
							    ; setup_movable_items+25p
				mov	ch, 8
				mov	bp, offset vischar_0 ; Hero's visible character.

loc_7113:						    ; CODE XREF: called_from_main_loop_9+BDj
				mov	al, [bp+1]
				cmp	al, 0FFh
				jnz	short loc_711D
				jmp	loc_71C4
; ---------------------------------------------------------------------------

loc_711D:						    ; CODE XREF: called_from_main_loop_9+Aj
				push	cx
				or	byte ptr [bp+1], 80h
				test	byte ptr [bp+0Dh], 80h
				jz	short loc_712B
				jmp	loc_71CF
; ---------------------------------------------------------------------------

loc_712B:						    ; CODE XREF: called_from_main_loop_9+18j
				mov	bx, [bp+0Ah]
				mov	al, [bp+0Ch]
				and	al, al
				js	short loc_7138
				jmp	short loc_717E
; ---------------------------------------------------------------------------
				nop			    ; odd

loc_7138:						    ; CODE XREF: called_from_main_loop_9+25j
				and	al, 7Fh
				jnz	short loc_713F
				jmp	loc_71D3
; ---------------------------------------------------------------------------

loc_713F:						    ; CODE XREF: called_from_main_loop_9+2Cj
				inc	al
				cbw
				shl	ax, 1
				shl	ax, 1
				add	bx, ax
				dec	bx
				mov	al, [bx]
				inc	bx

loc_714C:						    ; CODE XREF: called_from_main_loop_9+125j
				push	ax
				mov	dx, [bp+0Fh]
				mov	al, [bx]
				cbw
				sub	dx, ax
				mov	ds:saved_pos.x,	dx
				mov	dx, [bp+11h]
				mov	al, [bx+1]
				cbw
				sub	dx, ax
				mov	ds:saved_pos.y,	dx
				mov	dx, [bp+13h]
				mov	al, [bx+2]
				cbw
				sub	dx, ax
				mov	ds:saved_pos.height, dx
				pop	ax
				call	touch
				jnz	short loc_71B8
				dec	byte ptr [bp+0Ch]
				jmp	short loc_71B3
; ---------------------------------------------------------------------------

loc_717E:						    ; CODE XREF: called_from_main_loop_9+27j
				cmp	al, [bx]
				jz	short loc_71D3
				inc	al
				shl	al, 1
				shl	al, 1
				cbw
				add	bx, ax

loc_718B:						    ; CODE XREF: called_from_main_loop_9+FEj
				mov	al, [bx]
				cbw
				add	ax, [bp+0Fh]
				mov	ds:saved_pos.x,	ax
				mov	al, [bx+1]
				cbw
				add	ax, [bp+11h]
				mov	ds:saved_pos.y,	ax
				mov	al, [bx+2]
				cbw
				add	ax, [bp+13h]
				mov	ds:saved_pos.height, ax
				mov	al, [bx+3]
				call	touch
				jnz	short loc_71B8
				inc	byte ptr [bp+0Ch]

loc_71B3:						    ; CODE XREF: called_from_main_loop_9+6Ej
				mov	bx, bp
				call	calc_vischar_screenpos

loc_71B8:						    ; CODE XREF: called_from_main_loop_9+69j
							    ; called_from_main_loop_9+A0j
				pop	cx
				mov	al, [bp+1]
				cmp	al, 0FFh
				jz	short loc_71C4
				and	byte ptr [bp+1], 7Fh

loc_71C4:						    ; CODE XREF: called_from_main_loop_9+Cj
							    ; called_from_main_loop_9+B0j
				add	bp, 20h	; ' '
				dec	ch
				jz	short locret_71CE
				jmp	loc_7113
; ---------------------------------------------------------------------------

locret_71CE:						    ; CODE XREF: called_from_main_loop_9+BBj
				retn
; ---------------------------------------------------------------------------

loc_71CF:						    ; CODE XREF: called_from_main_loop_9+1Aj
				and	byte ptr [bp+0Dh], 7Fh

loc_71D3:						    ; CODE XREF: called_from_main_loop_9+2Ej
							    ; called_from_main_loop_9+72j
				mov	al, [bp+0Eh]
				mov	dh, al
				shl	al, 1
				shl	al, 1
				shl	al, 1
				add	al, dh
				add	al, [bp+0Dh]
				xor	ah, ah
				mov	bx, offset wasbyte_CDAA
				add	bx, ax
				mov	al, [bx]
				mov	cl, al
				mov	bx, [bp+8]
				shl	al, 1
				add	bx, ax
				mov	bx, [bx]
				mov	[bp+0Ah], bx
				test	cl, 80h
				jnz	short loc_720F
				mov	byte ptr [bp+0Ch], 0
				inc	bx
				inc	bx
				mov	al, [bx]
				mov	[bp+0Eh], al
				inc	bx
				inc	bx
				jmp	loc_718B
; ---------------------------------------------------------------------------

loc_720F:						    ; CODE XREF: called_from_main_loop_9+EFj
				mov	al, [bx]
				mov	cl, al
				or	al, 80h
				mov	[bp+0Ch], al
				inc	bx
				mov	al, [bx]
				mov	[bp+0Eh], al
				inc	bx
				inc	bx
				inc	bx
				push	bx
				mov	al, cl
				shl	al, 1
				shl	al, 1
				dec	al
				mov	ch, 0
				mov	cl, al
				add	bx, cx
				mov	al, [bx]
				pop	bx
				jmp	loc_714C
called_from_main_loop_9		endp

; ---------------------------------------------------------------------------
searchlight_movements		searchlight_movement_s <<36, 82>, 44, 2, 0, offset searchlight_path_2>
							    ; DATA XREF: nighttime:loc_72E9o
							    ; nighttime:not_trackingo
				searchlight_movement_s <<120, 82>, 24, 1, 0, offset searchlight_path_1>
				searchlight_movement_s <<60, 76>, 32, 2, 0, offset searchlight_path_0>
searchlight_path_0		db 20h,	2, 20h,	1, 0FFh	    ; DATA XREF: seg000:searchlight_movementso
searchlight_path_1		db 18h,	1, 0Ch,	0, 18h,	3, 0Ch,	0, 20h,	1, 14h,	0, 20h,	3, 2Ch,	2, 0FFh
							    ; DATA XREF: seg000:searchlight_movementso
searchlight_path_2		db 2Ch,	2, 2Ah,	1, 0FFh	    ; DATA XREF: seg000:searchlight_movementso

; =============== S U B	R O U T	I N E =======================================


searchlight_movement		proc near		    ; CODE XREF: nighttime+27p
							    ; nighttime+7Ep
				dec	byte ptr [bx+2]
				jnz	short loc_72A5
				mov	al, [bx+4]
				test	al, 80h
				jz	short loc_727C
				and	al, 7Fh
				jz	short loc_727E
				or	al, 80h
				dec	al
				dec	al

loc_727C:						    ; CODE XREF: searchlight_movement+Aj
				inc	al

loc_727E:						    ; CODE XREF: searchlight_movement+Ej
				mov	[bx+4],	al
				mov	si, [bx+5]
				xor	ah, ah
				shl	al, 1
				add	si, ax
				mov	al, [si]
				cmp	al, 0FFh
				jnz	short loc_729B

loc_7290:
				dec	byte ptr [bx+4]
				or	byte ptr [bx+4], 80h
				dec	si
				dec	si
				mov	al, [si]

loc_729B:						    ; CODE XREF: searchlight_movement+28j
				mov	[bx+2],	al
				mov	al, [si+1]
				mov	[bx+3],	al
				retn
; ---------------------------------------------------------------------------

loc_72A5:						    ; CODE XREF: searchlight_movement+3j
				mov	dx, [bx]
				mov	al, [bx+3]
				test	byte ptr [bx+4], 80h
				jz	short loc_72B2
				xor	al, direction_BOTTOM_RIGHT

loc_72B2:						    ; CODE XREF: searchlight_movement+48j
				cmp	al, direction_BOTTOM_RIGHT
				jnb	short loc_72BA
				dec	dh
				dec	dh

loc_72BA:						    ; CODE XREF: searchlight_movement+4Ej
				inc	dh
				or	al, al
				jp	short loc_72C3
				add	dl, 4

loc_72C3:						    ; CODE XREF: searchlight_movement+58j
				dec	dl
				dec	dl
				mov	[bx], dx
				retn
searchlight_movement		endp


; =============== S U B	R O U T	I N E =======================================


nighttime			proc near		    ; CODE XREF: enter_room-6641p
				mov	bx, offset searchlight_state
				mov	al, [bx]
				cmp	al, searchlight_STATE_SEARCHING
				jz	short dunno
				mov	al, ds:room_index
				and	al, al
				jz	short outdoors
				mov	byte ptr [bx], searchlight_STATE_SEARCHING
				retn
; ---------------------------------------------------------------------------

dunno:							    ; CODE XREF: nighttime+7j
				mov	al, ds:room_index
				and	al, al
				jnz	short loc_72E9
				mov	byte ptr [bx], 0
				retn
; ---------------------------------------------------------------------------

loc_72E9:						    ; CODE XREF: nighttime+19j
				mov	bx, offset searchlight_movements
				mov	cx, 3

loop:							    ; CODE XREF: nighttime+2Fj
				push	cx
				push	bx
				call	searchlight_movement
				pop	bx
				pop	cx
				add	bx, 7
				loop	loop
				retn
; ---------------------------------------------------------------------------

outdoors:						    ; CODE XREF: nighttime+Ej
				mov	al, [bx]
				or	al, al
				jz	short not_tracking
				cmp	al, 1Fh
				jnz	short loc_7334
				mov	dx, ds:map_position
				add	dx, offset vischar_0.mi.sprite ; Hero's visible character.
				mov	bx, ds:searchlight_caught_coord
				cmp	bl, dl
				jnz	short loc_731C
				cmp	bh, dh
				jnz	short loc_7324
				jmp	short loc_7334
; ---------------------------------------------------------------------------

loc_731C:						    ; CODE XREF: nighttime+4Aj
				jnb	short loc_7322
				inc	bl
				inc	bl

loc_7322:						    ; CODE XREF: nighttime:loc_731Cj
				dec	bl

loc_7324:						    ; CODE XREF: nighttime+4Ej
				cmp	bh, dh
				jz	short loc_7330
				jnb	short loc_732E
				inc	bh
				inc	bh

loc_732E:						    ; CODE XREF: nighttime+5Ej
				dec	bh

loc_7330:						    ; CODE XREF: nighttime+5Cj
				mov	ds:searchlight_caught_coord, bx

loc_7334:						    ; CODE XREF: nighttime+3Aj
							    ; nighttime+50j
				mov	dx, ds:map_position
				mov	bx, offset searchlight_caught_coord
				mov	ch, 1
				push	cx
				push	bx
				jmp	short loc_7352
; ---------------------------------------------------------------------------

not_tracking:						    ; CODE XREF: nighttime+36j
				mov	bx, offset searchlight_movements
				mov	ch, 3

forallmovements:					    ; CODE XREF: nighttime+115j
				push	cx
				push	bx
				call	searchlight_movement
				pop	bx
				push	bx
				call	searchlight_caught
				pop	bx
				push	bx

loc_7352:						    ; CODE XREF: nighttime+75j
				mov	dx, ds:map_position
				mov	al, dl
				sub	al, [bx]
				jb	short loc_7373
				cmp	al, 0Ah
				jnb	short loc_73D6
				mov	ds:byte_742C, 0
				shl	al, 1
				mov	ds:byte_742E, al
				neg	al
				add	al, 14h
				mov	ds:byte_7430, al
				jmp	short loc_7390
; ---------------------------------------------------------------------------

loc_7373:						    ; CODE XREF: nighttime+90j
				neg	al
				cmp	al, 17h
				jnb	short loc_73D6
				shl	al, 1
				mov	ds:byte_742C, al
				mov	ds:byte_742E, 0
				neg	al
				add	al, 2Eh	; '.'
				cmp	al, 14h
				jb	short loc_738D
				mov	al, 14h

loc_738D:						    ; CODE XREF: nighttime+BFj
				mov	ds:byte_7430, al

loc_7390:						    ; CODE XREF: nighttime+A7j
				mov	al, dh
				sub	al, [bx+1]
				jb	short loc_73B2
				cmp	al, 0Ah
				jnb	short loc_73D6
				shl	al, 1		    ; multiply_by_8
				shl	al, 1
				shl	al, 1
				mov	ds:byte_742D, 0
				mov	ds:byte_742F, al
				neg	al
				add	al, 50h	; 'P'
				mov	ds:byte_7431, al
				jmp	short loc_73D3
; ---------------------------------------------------------------------------

loc_73B2:						    ; CODE XREF: nighttime+CBj
				neg	al
				cmp	al, 10h
				jnb	short loc_73D6
				shl	al, 1		    ; multiply_by_8
				shl	al, 1
				shl	al, 1
				mov	ds:byte_742D, al
				mov	ds:byte_742F, 0
				neg	al
				add	al, 80h	; '€'
				cmp	al, 50h	; 'P'
				jb	short loc_73D0
				mov	al, 50h	; 'P'

loc_73D0:						    ; CODE XREF: nighttime+102j
				mov	ds:byte_7431, al

loc_73D3:						    ; CODE XREF: nighttime+E6j
				call	searchlight_plot

loc_73D6:						    ; CODE XREF: nighttime+94j
							    ; nighttime+ADj ...
				pop	bx
				pop	cx
				add	bx, 7
				dec	ch
				jz	short exit
				jmp	forallmovements
; ---------------------------------------------------------------------------

exit:							    ; CODE XREF: nighttime+113j
				retn
nighttime			endp

; ---------------------------------------------------------------------------
				db    0
searchlight_caught_coord	dw 0			    ; DATA XREF: nighttime+44r
							    ; nighttime:loc_7330w ...

; =============== S U B	R O U T	I N E =======================================


searchlight_caught		proc near		    ; CODE XREF: nighttime+83p
				test	ds:searchlight_mask_test_result, 0FFh ;	different to speccy version - new var
				jnz	short exit
				mov	dx, ds:map_position
				mov	al, dl
				add	al, 10		    ; these numbers look different from	speccy version
				cmp	[bx], al
				jnb	short exit
				sub	al, 7
				cmp	[bx], al
				jb	short exit
				mov	al, dh
				add	al, 8
				cmp	[bx+1],	al
				jnb	short exit
				sub	al, 11
				cmp	[bx+1],	al
				jb	short exit
				cmp	ds:searchlight_state, searchlight_STATE_CAUGHT
				jz	short exit
				mov	ds:searchlight_state, searchlight_STATE_CAUGHT
				mov	dx, [bx]
				mov	ds:searchlight_caught_coord, dx
				mov	ds:bell, 0
				mov	ch, 10
				call	decrease_morale

exit:							    ; CODE XREF: searchlight_caught+5j
							    ; searchlight_caught+11j ...
				retn
searchlight_caught		endp

; ---------------------------------------------------------------------------
byte_742C			db 0			    ; DATA XREF: nighttime+96w
							    ; nighttime+B1w ...
byte_742D			db 0			    ; DATA XREF: nighttime+D7w
							    ; nighttime+F4w ...
byte_742E			db 0			    ; DATA XREF: nighttime+9Dw
							    ; nighttime+B4w ...
byte_742F			db 0			    ; DATA XREF: nighttime+DCw
							    ; nighttime+F7w ...
byte_7430			db 0			    ; DATA XREF: nighttime+A4w
							    ; nighttime:loc_738Dw ...
byte_7431			db 0			    ; DATA XREF: nighttime+E3w
							    ; nighttime:loc_73D0w ...

; =============== S U B	R O U T	I N E =======================================


searchlight_plot		proc near		    ; CODE XREF: nighttime:loc_73D3p
				mov	al, ds:byte_742D
				xor	ah, ah
				mov	di, offset unk_2064
				shl	ax, 1
				sub	di, ax
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				add	di, ax
				shl	ax, 1
				add	di, ax
				mov	cl, ds:byte_742C
				xor	ch, ch
				add	di, cx
				mov	al, ds:byte_742F
				mov	ds:offset, al
				xor	ch, ch
				mov	cl, ds:byte_7431

loc_745E:						    ; CODE XREF: searchlight_plot+B0j
				push	cx
				call	sub_74E6
				mov	al, [si+1]
				mov	byte ptr ds:loc_74C1+1,	al
				mov	bx, offset reversed ; A	table of 256 bit-reversed bytes.
				xlat
				mov	byte ptr ds:loc_74D6+1,	al
				mov	dx, 2Eh	; '.'
				mov	cl, 0Ah
				sub	cl, [si]
				shl	cl, 1
				mov	al, ds:byte_742E
				sub	al, [si]
				jbe	short loc_7487
				mov	ch, 0
				sub	cl, al
				jbe	short loc_74B2
				jmp	short loc_7495
; ---------------------------------------------------------------------------

loc_7487:						    ; CODE XREF: searchlight_plot+4Bj
				neg	al
				cbw
				mov	ch, al
				add	di, ax
				sub	dx, ax
				mov	byte ptr ds:loc_74C1+1,	0FFh

loc_7495:						    ; CODE XREF: searchlight_plot+53j
				mov	al, ch
				add	al, cl
				cmp	al, ds:byte_7430
				jbe	short loc_74AC
				mov	cl, ds:byte_7430
				sub	cl, ch
				jbe	short loc_74B2
				mov	byte ptr ds:loc_74D6+1,	0FFh

loc_74AC:						    ; CODE XREF: searchlight_plot+6Bj
				xor	ch, ch
				sub	dx, cx
				jmp	short loc_74B4
; ---------------------------------------------------------------------------

loc_74B2:						    ; CODE XREF: searchlight_plot+51j
							    ; searchlight_plot+73j
				xor	cx, cx

loc_74B4:						    ; CODE XREF: searchlight_plot+7Ej
				mov	byte ptr ds:loc_74DB+2,	dl
				jcxz	short loc_74DB
				dec	cx
				jz	short loc_74D2
				mov	al, [di]
				shl	al, 1

loc_74C1:						    ; DATA XREF: searchlight_plot+33w
							    ; searchlight_plot+5Ew
				and	al, 0FFh
				or	[di], al
				inc	di
				dec	cx
				jz	short loc_74D2

loc_74C9:						    ; CODE XREF: searchlight_plot+9Ej
				mov	al, [di]
				shl	al, 1
				or	[di], al
				inc	di
				loop	loc_74C9

loc_74D2:						    ; CODE XREF: searchlight_plot+89j
							    ; searchlight_plot+95j
				mov	al, [di]
				shl	al, 1

loc_74D6:						    ; DATA XREF: searchlight_plot+3Aw
							    ; searchlight_plot+75w
				and	al, 0FFh
				or	[di], al
				inc	di

loc_74DB:						    ; CODE XREF: searchlight_plot+86j
							    ; DATA XREF: searchlight_plot:loc_74B4w
				add	di, 2Eh	; '.'
				pop	cx
				dec	cx
				jz	short exit
				jmp	loc_745E
; ---------------------------------------------------------------------------

exit:							    ; CODE XREF: searchlight_plot+AEj
				retn
searchlight_plot		endp


; =============== S U B	R O U T	I N E =======================================


sub_74E6			proc near		    ; CODE XREF: searchlight_plot+2Dp
				mov	si, offset searchlight_shape_PROBABLY
				mov	al, ds:offset
				inc	ds:offset
				cmp	al, 40
				jb	short lessthan40
				neg	al
				add	al, 80

lessthan40:						    ; CODE XREF: sub_74E6+Cj
				cbw
				shl	ax, 1
				add	si, ax
				or	ax, ax
				retn
sub_74E6			endp

; ---------------------------------------------------------------------------
offset				db 0			    ; DATA XREF: searchlight_plot+23w
							    ; sub_74E6+3r ...
searchlight_shape_PROBABLY	db 8			    ; 0	; DATA XREF: sub_74E6o
				db 3			    ; 1
				db 7			    ; 2
				db 0Fh			    ; 3
				db 6			    ; 4
				db 3			    ; 5
				db 6			    ; 6
				db 0FFh			    ; 7
				db 5			    ; 8
				db 0Fh			    ; 9
				db 5			    ; 10
				db 0FFh			    ; 11
				db 4			    ; 12
				db 3			    ; 13
				db 4			    ; 14
				db 3Fh			    ; 15
				db 4			    ; 16
				db 0FFh			    ; 17
				db 3			    ; 18
				db 3			    ; 19
				db 3			    ; 20
				db 3Fh			    ; 21
				db 3			    ; 22
				db 0FFh			    ; 23
				db 2			    ; 24
				db 3			    ; 25
				db 2			    ; 26
				db 0Fh			    ; 27
				db 2			    ; 28
				db 0Fh			    ; 29
				db 2			    ; 30
				db 3Fh			    ; 31
				db 2			    ; 32
				db 0FFh			    ; 33
				db 1			    ; 34
				db 3			    ; 35
				db 1			    ; 36
				db 3			    ; 37
				db 1			    ; 38
				db 0Fh			    ; 39
				db 1			    ; 40
				db 3Fh			    ; 41
				db 1			    ; 42
				db 3Fh			    ; 43
				db 1			    ; 44
				db 0FFh			    ; 45
				db 1			    ; 46
				db 0FFh			    ; 47
				db 0			    ; 48
				db 3			    ; 49
				db 0			    ; 50
				db 3			    ; 51
				db 0			    ; 52
				db 3			    ; 53
				db 0			    ; 54
				db 0Fh			    ; 55
				db 0			    ; 56
				db 0Fh			    ; 57
				db 0			    ; 58
				db 0Fh			    ; 59
				db 0			    ; 60
				db 3Fh			    ; 61
				db 0			    ; 62
				db 3Fh			    ; 63
				db 0			    ; 64
				db 3Fh			    ; 65
				db 0			    ; 66
				db 3Fh			    ; 67
				db 0			    ; 68
				db 3Fh			    ; 69
				db 0			    ; 70
				db 0FFh			    ; 71
				db 0			    ; 72
				db 0FFh			    ; 73
				db 0			    ; 74
				db 0FFh			    ; 75
				db 0			    ; 76
				db 0FFh			    ; 77
				db 0			    ; 78
				db 0FFh			    ; 79
				db 0			    ; 80
				db 0FFh			    ; 81

; =============== S U B	R O U T	I N E =======================================


check_morale			proc near		    ; CODE XREF: enter_room:main_loopp
				mov	al, ds:morale
				cmp	al, 2
				jnb	short exit
				mov	cx, 0F00h	    ; message_MORALE_IS_ZERO
				call	queue_message_for_display
				mov	byte ptr ds:morale_1_2+1, 0FFh
				mov	ds:automatic_player_counter, 0

exit:							    ; CODE XREF: check_morale+5j
				retn
check_morale			endp


; =============== S U B	R O U T	I N E =======================================


increase_morale			proc near		    ; CODE XREF: increase_morale_by_10_score_by_50+2p
							    ; increase_morale_by_5_score_by_5+2p
				mov	al, ds:morale
				add	al, ch
				cmp	al, 70h	; 'p'
				jb	short exit
				mov	al, 70h	; 'p'

glb_7576:						    ; CODE XREF: increase_morale+7j
							    ; decrease_morale+5j ...
exit:
				mov	ds:morale, al
				retn
increase_morale			endp


; =============== S U B	R O U T	I N E =======================================


decrease_morale			proc near		    ; CODE XREF: event_night_time+18p
							    ; searchlight_caught+42p ...
				mov	al, ds:morale
				sub	al, ch
				jnb	short glb_7576
				xor	al, al
				jmp	short glb_7576
decrease_morale			endp


; =============== S U B	R O U T	I N E =======================================


increase_morale_by_10_score_by_50 proc near		    ; CODE XREF: accept_bribep
							    ; action_red_cross_parcel+20j ...
				mov	ch, 0Ah
				call	increase_morale
				mov	ch, 32h	; '2'
				jmp	short increase_score
increase_morale_by_10_score_by_50 endp


; =============== S U B	R O U T	I N E =======================================


increase_morale_by_5_score_by_5	proc near		    ; CODE XREF: pick_up_item+45p
				mov	ch, 5
				call	increase_morale
increase_morale_by_5_score_by_5	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


increase_score			proc near		    ; CODE XREF: enter_room+23p
							    ; increase_morale_by_10_score_by_50+7j
				mov	cl, ch
				mov	ch, 0
				mov	bx, (offset score_digits+4)

loc_759A:						    ; CODE XREF: increase_score+16j
				push	bx

loc_759B:						    ; CODE XREF: increase_score+13j
				inc	byte ptr [bx]
				cmp	byte ptr [bx], 3Ah ; ':'
				jnz	short loc_75A8
				mov	byte ptr [bx], 30h ; '0'
				dec	bx
				jmp	short loc_759B
; ---------------------------------------------------------------------------

loc_75A8:						    ; CODE XREF: increase_score+Dj
				pop	bx
				loop	loc_759A
increase_score			endp


; =============== S U B	R O U T	I N E =======================================


plot_score			proc near		    ; CODE XREF: main+19p
							    ; reset_game_continued+29p
				mov	bx, offset score_digits
				mov	di, 1930h	    ; where to plot
				mov	cx, 5

loc_75B4:						    ; CODE XREF: plot_score+11j
				push	cx
				call	plot_glyph
				inc	bx
				inc	di
				inc	di
				pop	cx
				loop	loc_75B4
				retn
plot_score			endp

; ---------------------------------------------------------------------------
bell				db 0FFh			    ; DATA XREF: follow_suspicious_character+5r
							    ; dispatch_timed_event+25o	...
bell_state			db 0			    ; DATA XREF: ring_bell:plotr
							    ; ring_bell+1Cw ...
							    ; speccy version reads state of bell from the screen, this version maintains this state variable

; =============== S U B	R O U T	I N E =======================================


ring_bell			proc near		    ; CODE XREF: enter_room-665Dp
							    ; enter_room-6651p	...
				mov	bx, offset bell
				mov	al, [bx]
				cmp	al, 0FFh
				jz	short exit
				and	al, al
				jz	short plot
				dec	byte ptr [bx]
				jnz	short plot
				mov	byte ptr [bx], 0FFh

exit:							    ; CODE XREF: ring_bell+7j
				retn
; ---------------------------------------------------------------------------

plot:							    ; CODE XREF: ring_bell+Bj
							    ; ring_bell+Fj
				test	ds:bell_state, 0FFh
				jnz	short on
				mov	ds:bell_state, 0FFh
				mov	si, offset bell_ringer_bitmap_off
				jmp	short plot_ringer
; ---------------------------------------------------------------------------
				nop			    ; odd

on:							    ; CODE XREF: ring_bell+1Aj
				mov	ds:bell_state, 0
				mov	si, offset bell_ringer_bitmap_on
				call	plot_ringer
				mov	cx, sound_BELL_RINGER
				call	play_speaker
				retn
ring_bell			endp


; =============== S U B	R O U T	I N E =======================================


plot_ringer			proc near		    ; CODE XREF: ring_bell+24j
							    ; ring_bell+2Fp
				mov	di, offset screenaddr_bell_ringer
				mov	cx, 10Ch	    ; dimensions
				mov	al, 7
				call	plot_bitmap
				retn
plot_ringer			endp

; ---------------------------------------------------------------------------
bell_ringer_bitmap_off		db 0E7h			    ; DATA XREF: ring_bell+21o
				db 0E7h
				db  83h
				db  83h
				db  43h
				db  41h
				db  20h
				db  10h
				db    8
				db    4
				db    2
				db    2
bell_ringer_bitmap_on		db  3Fh			    ; DATA XREF: ring_bell+2Co
				db  3Fh
				db  27h
				db  13h
				db  13h
				db    9
				db    8
				db    4
				db    4
				db    2
				db    2
				db    1

; =============== S U B	R O U T	I N E =======================================


play_speaker			proc near		    ; CODE XREF: character_behaviour+223p
							    ; ring_bell+35p ...
				mov	byte ptr ds:loc_762A+1,	cl
				in	al, 61h		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd
				and	al, 0FCh

loc_7626:						    ; CODE XREF: play_speaker+16j
				xor	al, 2
				out	61h, al		    ; PC/XT PPI	port B bits:
							    ; 0: Tmr 2 gate ÍËÍ OR 03H=spkr ON
							    ; 1: Tmr 2 data Í¼	AND 0fcH=spkr OFF
							    ; 3: 1=read	high switches
							    ; 4: 0=enable RAM parity checking
							    ; 5: 0=enable I/O channel check
							    ; 6: 0=hold	keyboard clock low
							    ; 7: 0=enable kbrd

loc_762A:						    ; DATA XREF: play_speakerw
				mov	cl, 37h	; '7'

loc_762C:						    ; CODE XREF: play_speaker+12j
				nop
				nop
				dec	cl
				jnz	short loc_762C
				dec	ch
				jnz	short loc_7626
				retn
play_speaker			endp


; =============== S U B	R O U T	I N E =======================================


mark_nearby_items		proc near		    ; CODE XREF: enter_room-6660p
							    ; setup_movable_items+22p
				mov	cl, ds:room_index
				cmp	cl, 0FFh
				jnz	short loc_7642
				xor	cl, cl

loc_7642:						    ; CODE XREF: mark_nearby_items+7j
				mov	dx, ds:map_position
				mov	ch, 10h
				mov	bx, 0DEE0h

loc_764B:						    ; CODE XREF: mark_nearby_items+4Ej
				mov	al, [bx+1]
				and	al, 3Fh
				cmp	al, cl
				jnz	short loc_767C
				mov	al, dl
				dec	al
				dec	al
				cmp	al, [bx+5]
				ja	short loc_767C
				add	al, 19h
				cmp	al, [bx+5]
				jb	short loc_767C
				mov	al, dh
				dec	al
				cmp	al, [bx+6]
				ja	short loc_767C
				add	al, 11h
				cmp	al, [bx+6]
				jb	short loc_767C
				or	byte ptr [bx+1], 0C0h
				jmp	short loc_7680
; ---------------------------------------------------------------------------

loc_767C:						    ; CODE XREF: mark_nearby_items+1Bj
							    ; mark_nearby_items+26j ...
				and	byte ptr [bx+1], 3Fh

loc_7680:						    ; CODE XREF: mark_nearby_items+43j
				add	bx, 7
				dec	ch
				jnz	short loc_764B
				retn
mark_nearby_items		endp


; =============== S U B	R O U T	I N E =======================================


spawn_characters		proc near		    ; CODE XREF: enter_room-6663p
							    ; setup_movable_items:notcratep
				mov	dx, ds:map_position
				sub	dl, 8
				jnb	short loc_7693
				mov	dl, 0

loc_7693:						    ; CODE XREF: spawn_characters+7j
				sub	dh, 8
				jnb	short loc_769A
				mov	dh, 0

loc_769A:						    ; CODE XREF: spawn_characters+Ej
				mov	bx, offset character_structs
				mov	cx, 1Ah

loc_76A0:						    ; CODE XREF: spawn_characters+6Cj
				test	byte ptr [bx], 40h
				jnz	short loc_76F1
				mov	al, ds:room_index
				cmp	al, [bx+1]
				jnz	short loc_76F1
				and	al, al
				jnz	short loc_76E8
				sub	al, [bx+2]
				sub	al, [bx+3]
				sub	al, [bx+4]
				mov	ah, al
				mov	al, dh
				cmp	al, ah
				jnb	short loc_76F1
				add	al, 20h	; ' '
				jnb	short loc_76C8
				mov	al, 0FFh

loc_76C8:						    ; CODE XREF: spawn_characters+3Cj
				cmp	al, ah
				jb	short loc_76F1
				mov	al, 40h	; '@'
				add	al, [bx+3]
				sub	al, [bx+2]
				shl	al, 1
				mov	ah, al
				mov	al, dl
				cmp	al, ah
				jnb	short loc_76F1
				add	al, 28h	; '('
				jnb	short loc_76E4
				mov	al, 0FFh

loc_76E4:						    ; CODE XREF: spawn_characters+58j
				cmp	al, ah
				jb	short loc_76F1

loc_76E8:						    ; CODE XREF: spawn_characters+27j
				push	bx
				push	dx
				push	cx
				call	spawn_character
				pop	cx
				pop	dx
				pop	bx

loc_76F1:						    ; CODE XREF: spawn_characters+1Bj
							    ; spawn_characters+23j ...
				add	bx, 7
				loop	loc_76A0
				retn
spawn_characters		endp


; =============== S U B	R O U T	I N E =======================================


plot_bitmap			proc near		    ; CODE XREF: wave_morale_flag+58p
							    ; plot_ringer+8p ...
				push	bx
				push	bp
				push	es
				and	al, 0Fh
				mov	bx, offset plot_game_window_masks
				xlat
				mov	ah, al
				mov	word ptr ds:loc_773A+1,	ax
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				mov	byte ptr ds:loc_772D+1,	ch
				shl	ch, 1
				neg	ch
				add	ch, 50h	; 'P'
				mov	byte ptr ds:loc_7744+2,	ch
				mov	dx, di
				xor	dx, 2000h
				test	dh, 20h
				jnz	short loc_7727
				add	dx, 50h	; 'P'

loc_7727:						    ; CODE XREF: plot_bitmap+2Bj
				mov	bx, si
				mov	bp, offset plot_game_window_table
				cld

loc_772D:						    ; CODE XREF: plot_bitmap+50j
							    ; DATA XREF: plot_bitmap+13w
				mov	ch, 3

loc_772F:						    ; CODE XREF: plot_bitmap+49j
				mov	al, [bx]
				inc	bx
				xor	ah, ah
				shl	ax, 1
				mov	si, ax
				mov	ax, [bp+si]

loc_773A:						    ; DATA XREF: plot_bitmap+Bw
				and	ax, 5555h
				stosw
				dec	ch
				jnz	short loc_772F
				xchg	di, dx

loc_7744:						    ; DATA XREF: plot_bitmap+1Ew
				add	dx, 4Ah	; 'J'
				loop	loc_772D
				pop	es
				assume es:nothing
				pop	bp
				pop	bx
				retn
plot_bitmap			endp


; =============== S U B	R O U T	I N E =======================================


screen_wipe			proc near		    ; CODE XREF: draw_item+6p
				push	es
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				mov	dx, di
				mov	byte ptr ds:loc_7760+1,	ch
				mov	ax, 0
				mov	ch, ah
				cld

loop:							    ; CODE XREF: screen_wipe+26j
				push	cx

loc_7760:						    ; DATA XREF: screen_wipe+8w
				mov	cl, 2
				rep stosw
				xor	dx, 2000h
				test	dh, 20h
				jnz	short loc_7770
				add	dx, 50h	; 'P'

loc_7770:						    ; CODE XREF: screen_wipe+1Ej
				mov	di, dx
				pop	cx
				loop	loop
				pop	es
				assume es:nothing
				retn
screen_wipe			endp

; ---------------------------------------------------------------------------
plot_game_window_masks		db 0			    ; DATA XREF: plot_game_window+4o
							    ; plot_static_tiles_vertical+24o ...
				db 55h
				db 0AAh
				db 0AAh
				db 55h
				db 55h
				db 0FFh
				db 0FFh

; =============== S U B	R O U T	I N E =======================================


plot_menu_text			proc near		    ; CODE XREF: plot_statics_and_menu_text+21p
				mov	cx, 8
				mov	bx, offset key_choice_screenlocstrings

loop:							    ; CODE XREF: plot_menu_text+Bj
				push	cx
				call	screenlocstring_plot
				pop	cx
				loop	loop
				retn
plot_menu_text			endp

; ---------------------------------------------------------------------------
key_choice_screenlocstrings	screenstring <3DAh, 19>	    ; DATA XREF: plot_menu_text+3o
aUseKeypadControls		db 'USE KEYPAD CONTROLS'
				screenstring <666h, 5>
a789				db '7 8 9'
				screenstring <7A6h, 5>
				db '  [  '
				screenstring <8E6h, 5>
a456				db '4^5]6'
				screenstring <0A26h, 5>
				db '  \  '
				screenstring <0B66h, 5>
a123				db '1 2 3'
				screenstring <0F18h, 16>
aSpaceToFire			db 'SPACE    TO FIRE'
				screenstring <1198h, 21>
aEscForNewGame			db ' ESC     FOR NEW GAME'

; =============== S U B	R O U T	I N E =======================================


get_door_position		proc near		    ; CODE XREF: character_behaviour+1EDp
							    ; door_handling+14Dp ...
				mov	cl, al
				mov	ah, 0
				shl	al, 1
				shl	ax, 1
				shl	ax, 1
				mov	bx, 0C0D7h
				add	bx, ax
				test	cl, 80h
				jz	short locret_780D
				add	bx, 4

locret_780D:						    ; CODE XREF: get_door_position+12j
				retn
get_door_position		endp


; =============== S U B	R O U T	I N E =======================================


vischar_visible			proc near		    ; CODE XREF: called_from_main_loop_3+29p
							    ; setup_vischar_plotting+61p
				mov	bx, offset map_position_related
				mov	ah, [bp+1Eh]
				xor	ch, ch
				mov	al, byte ptr ds:map_position
				add	al, 18h
				sub	al, [bx]
				jbe	short loc_7898
				cmp	al, ah
				jnb	short loc_7827
				mov	cl, al
				jmp	short loc_7841
; ---------------------------------------------------------------------------

loc_7827:						    ; CODE XREF: vischar_visible+13j
				mov	al, [bx]
				add	al, ah
				sub	al, byte ptr ds:map_position
				jbe	short loc_7898
				cmp	al, ah
				jnb	short loc_783F
				mov	cl, al
				neg	al
				add	al, ah
				mov	ch, al
				jmp	short loc_7841
; ---------------------------------------------------------------------------

loc_783F:						    ; CODE XREF: vischar_visible+25j
				mov	cl, ah

loc_7841:						    ; CODE XREF: vischar_visible+17j
							    ; vischar_visible+2Fj
				mov	bl, byte ptr ds:map_position+1
				add	bl, 11h
				mov	bh, 0
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				sub	bx, [bp+1Ah]
				jbe	short loc_7898
				and	bh, bh
				jnz	short loc_7898
				cmp	bl, [bp+1Fh]
				jnb	short loc_7862
				mov	dx, bx
				jmp	short loc_7895
; ---------------------------------------------------------------------------

loc_7862:						    ; CODE XREF: vischar_visible+4Ej
				mov	bl, [bp+1Fh]
				mov	bh, 0
				add	bx, [bp+1Ah]
				mov	dl, byte ptr ds:map_position+1
				mov	dh, 0
				shl	dx, 1
				shl	dx, 1
				shl	dx, 1
				sub	bx, dx
				jbe	short loc_7898
				and	bh, bh
				jnz	short loc_7898
				mov	al, bl
				cmp	al, [bp+1Fh]
				jnb	short loc_7890
				mov	dl, al
				neg	al
				add	al, [bp+1Fh]
				mov	dh, al
				jmp	short loc_7895
; ---------------------------------------------------------------------------

loc_7890:						    ; CODE XREF: vischar_visible+75j
				mov	dh, 0
				mov	dl, [bp+1Fh]

loc_7895:						    ; CODE XREF: vischar_visible+52j
							    ; vischar_visible+80j
				xor	al, al
				retn
; ---------------------------------------------------------------------------

loc_7898:						    ; CODE XREF: vischar_visible+Fj
							    ; vischar_visible+21j ...
				mov	al, 0FFh
				and	al, al
				retn
vischar_visible			endp


; =============== S U B	R O U T	I N E =======================================


reset_position			proc near		    ; CODE XREF: enter_room+18p
							    ; reset_outdoors+3p ...
				push	ds
				pop	es
				cld
				mov	si, bx
				add	si, 0Fh
				mov	di, offset saved_pos
				mov	cx, 3
				rep movsw		    ; fallthrough
reset_position			endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


calc_vischar_screenpos		proc near		    ; CODE XREF: called_from_main_loop_9+A7p
				mov	dx, ds:saved_pos.y
				add	dx, 200h
				sub	dx, ds:saved_pos.x
				shl	dx, 1
				mov	[bx+18h], dx
				mov	dx, 800h
				sub	dx, ds:saved_pos.x
				sbb	dx, ds:saved_pos.height
				sbb	dx, ds:saved_pos.y
				mov	[bx+1Ah], dx
				retn
calc_vischar_screenpos		endp

; ---------------------------------------------------------------------------
bribed_character		db 0FFh			    ; DATA XREF: character_behaviour+69r
							    ; character_behaviour+187r	...

; =============== S U B	R O U T	I N E =======================================


touch				proc near		    ; CODE XREF: called_from_main_loop_9+66p
							    ; called_from_main_loop_9+9Dp
				mov	ds:touch_stashed_A, al
				or	byte ptr [bp+7], 0C0h
				cmp	bp, offset vischar_0 ; Hero's visible character.
				jnz	short automatic
				mov	al, ds:automatic_player_counter
				and	al, al
				jz	short automatic
				call	door_handling

automatic:						    ; CODE XREF: touch+Bj
							    ; touch+12j
				cmp	bp, offset vischar_0 ; Hero's visible character.
				jnz	short loc_78F6
				mov	al, ds:vischar_0.flags ; Hero's visible character.
				and	al, 3
				cmp	al, 2		    ; vischar_FLAGS_CUTTING_WIRE

loc_78F6:						    ; CODE XREF: touch+1Bj
				jz	short loc_78FD
				call	bounds_check
				jnz	short exit

loc_78FD:						    ; CODE XREF: touch:loc_78F6j
				mov	al, [bp+0]
				cmp	al, character_26_STOVE_1 ; movable item
				jnb	short loc_7909
				call	collision
				jnz	short exit

loc_7909:						    ; CODE XREF: touch+30j
				and	byte ptr [bp+7], 0BFh ;	was ~vischar_BYTE7_BIT6
				push	ds
				pop	es
				cld
				mov	si, offset saved_pos
				mov	di, bp
				add	di, 0Fh
				mov	cx, 3
				rep movsw
				mov	al, ds:touch_stashed_A
				mov	[bp+17h], al
				xor	al, al

exit:							    ; CODE XREF: touch+29j
							    ; touch+35j
				retn
touch				endp


; =============== S U B	R O U T	I N E =======================================


collision			proc near		    ; CODE XREF: touch+32p
							    ; spawn_character:loc_8D86p
				mov	bx, offset vischar_0.flags ; Hero's visible character.
				mov	ch, 8

loop:							    ; CODE XREF: collision+65j
				test	byte ptr [bx], 80h  ; vischar_FLAGS_NO_COLLIDE
				jnz	short next
				push	cx
				push	bx
				add	bx, 0Eh
				mov	cx, [bx]
				inc	bx
				xchg	dx, bx
				mov	bx, ds:saved_pos.x
				add	cx, 4
				sub	bx, cx
				jz	short loc_7952
				jnb	short loc_7984
				sub	cx, 8
				mov	bx, ds:saved_pos.x
				sub	bx, cx
				jb	short loc_7984

loc_7952:						    ; CODE XREF: collision+1Dj
				xchg	dx, bx
				inc	bx
				mov	cx, [bx]
				inc	bx
				xchg	dx, bx
				mov	bx, ds:saved_pos.y
				add	cx, 4
				sub	bx, cx
				jz	short loc_7972
				jnb	short loc_7984
				sub	cx, 8
				mov	bx, ds:saved_pos.y
				sub	bx, cx
				jb	short loc_7984

loc_7972:						    ; CODE XREF: collision+3Dj
				xchg	dx, bx
				inc	bx
				mov	cl, [bx]
				mov	al, byte ptr ds:saved_pos.height
				sub	al, cl
				jnb	short loc_7980
				neg	al

loc_7980:						    ; CODE XREF: collision+56j
				cmp	al, 18h
				jb	short loc_798E

loc_7984:						    ; CODE XREF: collision+1Fj
							    ; collision+2Aj ...
				pop	bx
				pop	cx

next:							    ; CODE XREF: collision+8j
				add	bx, 20h	; ' '
				dec	ch
				jnz	short loop
				retn
; ---------------------------------------------------------------------------

loc_798E:						    ; CODE XREF: collision+5Cj
				mov	al, [bp+1]
				and	al, 0Fh
				cmp	al, 1
				jnz	short loc_79B5
				pop	bx
				push	bx
				dec	bx
				cmp	bx, offset vischar_0 ; Hero's visible character.
				jnz	short loc_79B5
				mov	al, ds:bribed_character
				cmp	al, [bp+0]
				jnz	short herocaught
				call	accept_bribe
				jmp	short loc_79B5
; ---------------------------------------------------------------------------

herocaught:						    ; CODE XREF: collision+80j
				pop	bx
				pop	cx
				mov	bx, bp
				inc	bx
				jmp	solitary
; ---------------------------------------------------------------------------

loc_79B5:						    ; CODE XREF: collision+6Fj
							    ; collision+78j ...
				pop	bx
				dec	bx
				mov	al, [bx]
				cmp	al, character_26_STOVE_1 ; movable item
				jb	short loc_7A0C
				push	bx
				add	bx, 11h
				mov	cx, (offset window_buf+3Fh)
				cmp	al, 1Ch
				mov	al, [bp+0Eh]
				jnz	short loc_79D1
				dec	bx
				dec	bx
				mov	cl, 36h	; '6'
				xor	al, 1

loc_79D1:						    ; CODE XREF: collision+A3j
				and	al, al
				jnz	short loc_79E5
				mov	al, [bx]
				cmp	al, cl
				jz	short loc_7A0B
				jb	short loc_79E1
				dec	byte ptr [bx]
				dec	byte ptr [bx]

loc_79E1:						    ; CODE XREF: collision+B5j
				inc	byte ptr [bx]
				jmp	short loc_7A0B
; ---------------------------------------------------------------------------

loc_79E5:						    ; CODE XREF: collision+ADj
				cmp	al, 1
				jnz	short loc_79F5
				mov	al, cl
				add	al, ch
				cmp	al, [bx]
				jz	short loc_7A0B
				inc	byte ptr [bx]
				jmp	short loc_7A0B
; ---------------------------------------------------------------------------

loc_79F5:						    ; CODE XREF: collision+C1j
				cmp	al, 2
				jnz	short loc_7A01
				mov	al, cl
				sub	al, ch
				mov	[bx], al
				jmp	short loc_7A0B
; ---------------------------------------------------------------------------

loc_7A01:						    ; CODE XREF: collision+D1j
				mov	al, cl
				sub	al, ch
				cmp	al, [bx]
				jz	short loc_7A0B
				dec	byte ptr [bx]

loc_7A0B:						    ; CODE XREF: collision+B3j
							    ; collision+BDj ...
				pop	bx

loc_7A0C:						    ; CODE XREF: collision+95j
				pop	cx
				add	bx, 0Dh
				mov	al, [bx]
				and	al, 7Fh		    ; ~input_KICK
				jz	short loc_7A31
				inc	bx
				mov	al, [bx]
				xor	al, 2
				cmp	al, [bp+0Eh]
				jz	short loc_7A31
				mov	byte ptr [bp+0Dh], 80h ; '€' ; input_KICK

exit:							    ; CODE XREF: collision+123j
							    ; collision+129j
				mov	al, [bp+7]
				and	al, 0F0h	    ; vischar_BYTE7_MASK_HI
				or	al, 5
				mov	[bp+7],	al
				jz	short loc_7A31
				retn
; ---------------------------------------------------------------------------

loc_7A31:						    ; CODE XREF: collision+EEj
							    ; collision+F8j ...
				mov	cl, [bp+0Eh]
				mov	ch, 0
				mov	bx, offset collision_new_inputs
				add	bx, cx
				mov	al, [bx]
				mov	[bp+0Dh], al
				test	cl, 1
				jnz	short loc_7A4B
				and	byte ptr [bp+7], 0DFh ;	 ~vischar_BYTE7_IMPEDED
				jmp	short exit
; ---------------------------------------------------------------------------

loc_7A4B:						    ; CODE XREF: collision+11Dj
				or	byte ptr [bp+7], 20h ; vischar_BYTE7_IMPEDED
				jmp	short exit
collision			endp

; ---------------------------------------------------------------------------
collision_new_inputs		db 85h			    ; DATA XREF: collision+110o
				db 84h
				db 87h
				db 88h

; =============== S U B	R O U T	I N E =======================================


accept_bribe			proc near		    ; CODE XREF: character_behaviour+18Fj
							    ; collision+82p
				call	increase_morale_by_10_score_by_50
				mov	byte ptr [bp+1], 0
				mov	bx, bp
				inc	bx
				inc	bx
				call	wassub_CB23
				mov	di, offset items_held
				mov	al, [di]
				cmp	al, 5
				jz	short loc_7A74
				inc	di
				mov	al, [di]
				cmp	al, 5
				jz	short loc_7A74
				retn
; ---------------------------------------------------------------------------

loc_7A74:						    ; CODE XREF: accept_bribe+15j
							    ; accept_bribe+1Cj
				mov	al, 0FFh
				mov	[di], al
				and	al, 3Fh
				mov	ds:item_struct_5_bribe.room_and_flags, al
				call	draw_all_items
				mov	ch, 7
				mov	bx, offset vischar_1 ; NPC visible characters.

loop:							    ; CODE XREF: accept_bribe+3Fj
				mov	al, [bx]
				cmp	al, 14h
				jnb	short loc_7A8F
				mov	byte ptr [bx+1], 4

loc_7A8F:						    ; CODE XREF: accept_bribe+34j
				add	bx, 20h	; ' '       ; ~gates_and_doors_LOCKED
				dec	ch
				jnz	short loop
				mov	ch, message_HE_TAKES_THE_BRIBE
				call	queue_message_for_display
				mov	ch, message_AND_ACTS_AS_DECOY
				call	queue_message_for_display
				retn
accept_bribe			endp


; =============== S U B	R O U T	I N E =======================================


bounds_check			proc near		    ; CODE XREF: touch+26p
							    ; spawn_character+4Dp

; FUNCTION CHUNK AT 7BEF SIZE 0000006C BYTES

				mov	al, ds:room_index
				and	al, al
				jz	short outdoors
				jmp	interior_bounds_check
; ---------------------------------------------------------------------------

outdoors:						    ; CODE XREF: bounds_check+5j
				mov	ch, 24		    ; NELEMS(walls)
				mov	bx, offset walls

loop:							    ; CODE XREF: bounds_check+85j
				mov	al, [bx]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				inc	ax
				shl	ax, 1
				cmp	ds:saved_pos.x,	ax
				jb	short next
				mov	al, [bx+1]
				xor	ah, ah
				shl	ax, 1
				inc	ax
				shl	ax, 1
				shl	ax, 1
				cmp	ds:saved_pos.x,	ax
				jnb	short next
				mov	al, [bx+2]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				cmp	ds:saved_pos.y,	ax
				jb	short next
				mov	al, [bx+3]
				xor	ah, ah
				shl	ax, 1
				inc	ax
				shl	ax, 1
				shl	ax, 1
				cmp	ds:saved_pos.y,	ax
				jnb	short next
				mov	al, [bx+4]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				cmp	ds:saved_pos.height, ax
				jb	short next
				inc	bx
				mov	al, [bx+5]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				inc	ax
				shl	ax, 1
				cmp	ds:saved_pos.height, ax
				jnb	short next
				xor	byte ptr [bp+7], vischar_BYTE7_IMPEDED ; vischar_BYTE7_IMPEDED
				or	al, 1
				retn
; ---------------------------------------------------------------------------

next:							    ; CODE XREF: bounds_check+1Ej
							    ; bounds_check+30j	...
				add	bx, 6		    ; stride
				dec	ch
				jnz	short loop
				and	al, ch
				retn
bounds_check			endp


; =============== S U B	R O U T	I N E =======================================


is_door_locked			proc near		    ; CODE XREF: door_handling+41p
							    ; door_handling+183p
				mov	al, ds:current_door
				and	al, 7Fh
				mov	cl, al
				mov	bx, offset gates_and_doors
				mov	ch, 9

loc_7B37:						    ; CODE XREF: is_door_locked+24j
				mov	al, [bx]
				and	al, 7Fh
				cmp	al, cl
				jnz	short loc_7B4C
				test	byte ptr [bx], 80h
				jz	short exit
				mov	ch, message_THE_DOOR_IS_LOCKED
				call	queue_message_for_display
				or	al, 1
				retn
; ---------------------------------------------------------------------------

loc_7B4C:						    ; CODE XREF: is_door_locked+12j
				inc	bx
				dec	ch
				jnz	short loc_7B37
				and	al, ch

exit:							    ; CODE XREF: is_door_locked+17j
				retn
is_door_locked			endp


; =============== S U B	R O U T	I N E =======================================


door_handling			proc near		    ; CODE XREF: touch+14p

; FUNCTION CHUNK AT 7C93 SIZE 00000068 BYTES

				mov	al, ds:room_index
				and	al, al
				jz	short loc_7B5E
				jmp	loc_7C93
; ---------------------------------------------------------------------------

loc_7B5E:						    ; CODE XREF: door_handling+5j
				mov	bx, offset door_positions
				mov	dl, [bp+0Eh]
				cmp	dl, 2
				jb	short loc_7B6C
				add	bx, 4

loc_7B6C:						    ; CODE XREF: door_handling+13j
				mov	dh, 3
				mov	ch, 10h

loc_7B70:						    ; CODE XREF: door_handling+34j
				mov	al, [bx]
				and	al, dh
				cmp	al, dl
				jnz	short loc_7B83
				push	cx
				push	bx
				push	dx
				call	door_in_range
				pop	dx
				pop	bx
				pop	cx
				jnb	short loc_7B8D

loc_7B83:						    ; CODE XREF: door_handling+22j
				add	bx, 8
				dec	ch
				jnz	short loc_7B70
				and	al, ch
				retn
; ---------------------------------------------------------------------------

loc_7B8D:						    ; CODE XREF: door_handling+2Dj
				mov	al, 10h
				sub	al, ch
				mov	ds:current_door, al
				push	bx
				call	is_door_locked
				pop	bx
				jz	short loc_7B9C
				retn
; ---------------------------------------------------------------------------

loc_7B9C:						    ; CODE XREF: door_handling+45j
				mov	al, [bx]
				shr	al, 1
				shr	al, 1
				mov	[bp+1Ch], al
				mov	al, [bx]
				and	al, 3
				cmp	al, 2
				jnb	short loc_7BB3	    ; previous door
				add	bx, 5		    ; next door
				jmp	transition
; ---------------------------------------------------------------------------

loc_7BB3:						    ; CODE XREF: door_handling+57j
				dec	bx		    ; previous door
				dec	bx
				dec	bx
				jmp	transition
door_handling			endp


; =============== S U B	R O U T	I N E =======================================


door_in_range			proc near		    ; CODE XREF: door_handling+27p
							    ; open_door+19p ...
				mov	al, [bx+1]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				sub	ax, 3
				cmp	ds:saved_pos.x,	ax
				jb	short exit
				add	ax, 6
				cmp	ds:saved_pos.x,	ax
				jnb	short loc_7BED
				mov	al, [bx+2]
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				sub	ax, 3
				cmp	ds:saved_pos.y,	ax
				jb	short exit
				add	ax, 6
				cmp	ds:saved_pos.y,	ax

loc_7BED:						    ; CODE XREF: door_in_range+19j
				cmc

exit:							    ; CODE XREF: door_in_range+10j
							    ; door_in_range+2Bj
				retn
door_in_range			endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR bounds_check

interior_bounds_check:					    ; CODE XREF: bounds_check+7j
				mov	al, ds:roomdef_bounds_index
				cbw
				shl	ax, 1
				shl	ax, 1
				mov	bx, offset roomdef_bounds
				add	bx, ax
				mov	al, [bx]
				cmp	al, byte ptr ds:saved_pos.x
				jb	short found
				mov	al, [bx+1]
				add	al, 4
				cmp	al, byte ptr ds:saved_pos.x
				jnb	short found
				mov	al, [bx+2]
				sub	al, 4
				cmp	al, byte ptr ds:saved_pos.y
				jb	short found
				mov	al, [bx+3]
				cmp	al, byte ptr ds:saved_pos.y
				jnb	short found
				mov	bx, offset roomdef_object_bounds_count
				mov	ch, [bx]
				and	ch, ch
				jz	short exit
				inc	bx

loop2:							    ; CODE XREF: bounds_check+1B5j
				push	cx
				push	bx
				mov	di, offset saved_pos
				mov	ch, 2

loop1:							    ; CODE XREF: bounds_check+1A3j
				mov	al, [di]
				cmp	al, [bx]
				jb	short loc_7C4F
				inc	bx
				cmp	al, [bx]
				jnb	short loc_7C4F
				inc	di
				inc	di
				inc	bx
				dec	ch
				jnz	short loop1
				pop	bx
				pop	cx

found:							    ; CODE XREF: bounds_check+161j
							    ; bounds_check+16Cj ...
				xor	byte ptr [bp+7], vischar_BYTE7_IMPEDED
				or	al, 1

exit:							    ; CODE XREF: bounds_check+189j
				retn
; ---------------------------------------------------------------------------

loc_7C4F:						    ; CODE XREF: bounds_check+197j
							    ; bounds_check+19Cj
				pop	bx
				add	bx, 4
				pop	cx
				dec	ch
				jnz	short loop2
				and	al, ch
				retn
; END OF FUNCTION CHUNK	FOR bounds_check

; =============== S U B	R O U T	I N E =======================================


reset_outdoors			proc near		    ; CODE XREF: transition+49p
							    ; keyscan_break+25j
				mov	bx, offset vischar_0 ; Hero's visible character.
				call	reset_position
				mov	bx, offset vischar_0.scrx ; Hero's visible character.
				mov	ax, [bx]
				inc	bx
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				sub	al, 0Bh
				mov	byte ptr ds:map_position, al
				inc	bx
				mov	ax, [bx]
				inc	bx
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				sub	al, 6
				mov	byte ptr ds:map_position+1, al
				xor	al, al
				mov	ds:room_index, al
				call	get_supertiles
				call	plot_all_tiles
				call	setup_movable_items
				call	zoombox
				retn
reset_outdoors			endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR door_handling

loc_7C93:						    ; CODE XREF: door_handling+7j
				mov	bx, offset doors_related

loc_7C96:						    ; CODE XREF: door_handling+1A5j
				mov	al, [bx]
				cmp	al, 0FFh
				jnz	short loc_7C9D
				retn
; ---------------------------------------------------------------------------

loc_7C9D:						    ; CODE XREF: door_handling+146j
				push	bx
				mov	ds:current_door, al
				call	get_door_position
				mov	al, [bx]
				mov	cl, al
				and	al, 3
				mov	ch, al
				mov	al, [bp+0Eh]
				and	al, 3
				cmp	al, ch
				jnz	short loc_7CF7
				inc	bx
				xchg	di, bx
				mov	bx, offset saved_pos
				mov	ch, 2

loc_7CBD:						    ; CODE XREF: door_handling+17Cj
				mov	al, [di]
				sub	al, 3
				cmp	al, [bx]
				jnb	short loc_7CF7
				add	al, 6
				cmp	al, [bx]
				jb	short loc_7CF7
				inc	bx
				inc	bx
				inc	di
				dec	ch
				jnz	short loc_7CBD
				inc	di
				xchg	di, bx
				push	bx
				push	cx
				call	is_door_locked
				pop	cx
				pop	bx
				pop	dx
				jz	short loc_7CE0
				retn
; ---------------------------------------------------------------------------

loc_7CE0:						    ; CODE XREF: door_handling+189j
				mov	al, cl
				shr	al, 1
				shr	al, 1
				mov	[bp+1Ch], al
				inc	bx
				mov	al, ds:current_door
				test	al, 80h
				jz	short loc_7CF4
				sub	bx, 8

loc_7CF4:						    ; CODE XREF: door_handling+19Bj
				jmp	transition
; ---------------------------------------------------------------------------

loc_7CF7:						    ; CODE XREF: door_handling+15Fj
							    ; door_handling+16Fj ...
				pop	bx
				inc	bx
				jmp	short loc_7C96
; END OF FUNCTION CHUNK	FOR door_handling

; =============== S U B	R O U T	I N E =======================================


action_red_cross_parcel		proc near		    ; DATA XREF: seg000:9282o
				mov	al, 3Fh	; '?'
				mov	ds:item_struct_12_red_cross_parcel.room_and_flags, al
				mov	bx, offset items_held
				mov	al, 0Ch
				cmp	al, [bx]
				jz	short loc_7D0A
				inc	bx

loc_7D0A:						    ; CODE XREF: action_red_cross_parcel+Cj
				mov	byte ptr [bx], 0FFh
				call	draw_all_items
				mov	al, ds:red_cross_parcel_current_contents
				call	drop_item_tail
				mov	ch, message_YOU_OPEN_THE_BOX
				call	queue_message_for_display
				jmp	increase_morale_by_10_score_by_50
action_red_cross_parcel		endp


; =============== S U B	R O U T	I N E =======================================


action_bribe			proc near		    ; DATA XREF: seg000:9274o
				mov	bx, offset vischar_1 ; NPC visible characters.
				mov	ch, 7

loc_7D23:						    ; CODE XREF: action_bribe+14j
				mov	al, [bx]
				cmp	al, 0FFh
				jz	short loc_7D2D
				cmp	al, 14h
				jnb	short loc_7D35

loc_7D2D:						    ; CODE XREF: action_bribe+9j
				add	bx, 20h	; ' '
				dec	ch
				jnz	short loc_7D23
				retn
; ---------------------------------------------------------------------------

loc_7D35:						    ; CODE XREF: action_bribe+Dj
				mov	ds:bribed_character, al
				inc	bx
				mov	byte ptr [bx], 1
				retn
action_bribe			endp


; =============== S U B	R O U T	I N E =======================================


action_poison			proc near		    ; DATA XREF: seg000:927Ao

; FUNCTION CHUNK AT 7D98 SIZE 00000003 BYTES

				mov	bx, ds:items_held
				mov	al, item_FOOD
				cmp	al, bl
				jz	short have_food
				cmp	al, bh
				jnz	short return_only

have_food:						    ; CODE XREF: action_poison+8j
				mov	bx, offset item_struct_7_food
				test	byte ptr [bx], 20h  ; bit 5 set?
				jnz	short return_only
				or	byte ptr [bx], 20h  ; set bit 5
				mov	al, attribute_BRIGHT_PURPLE_OVER_BLACK
				mov	ds:item_attributes+7, al ; set food attr
				call	draw_all_items
				jmp	short exitviaincreasemorale
action_poison			endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


action_uniform			proc near		    ; DATA XREF: seg000:9276o
				mov	bx, offset vischar_0.mi.sprite ; Hero's visible character.
				mov	dx, offset sprite_guard_facing_away_4
				mov	ax, [bx]
				cmp	ax, dx
				jz	short return_only
				mov	al, ds:room_index
				cmp	al, room_29_SECOND_TUNNEL_START
				jnb	short return_only
				mov	[bx], dx
				jmp	short exitviaincreasemorale
action_uniform			endp


; =============== S U B	R O U T	I N E =======================================


action_shovel			proc near		    ; DATA XREF: seg000:926Co
				mov	al, ds:room_index
				cmp	al, 50
				jnz	short return_only
				mov	al, ds:roomdef_50_blocked_tunnel_boundary
				cmp	al, 0FFh
				jz	short return_only
				mov	al, 0FFh
				mov	ds:roomdef_50_blocked_tunnel_boundary, al
				inc	al
				mov	ds:roomdef_50_blocked_tunnel_collapsed_tunnel, al
				call	setup_room
				call	choose_game_window_attributes
				call	plot_interior_tiles
action_shovel			endp ; sp-analysis failed

; START	OF FUNCTION CHUNK FOR action_poison

exitviaincreasemorale:					    ; CODE XREF: action_poison+21j
							    ; action_uniform+15j
				call	increase_morale_by_10_score_by_50
; END OF FUNCTION CHUNK	FOR action_poison

; =============== S U B	R O U T	I N E =======================================


return_only			proc near		    ; CODE XREF: action_poison+Cj
							    ; action_poison+14j ...
				retn
return_only			endp


; =============== S U B	R O U T	I N E =======================================


action_wiresnips		proc near		    ; DATA XREF: seg000:item_actions_jump_tableo
				mov	bx, (offset walls.maxy+48h)
				mov	di, offset hero_map_position.y
				mov	ch, 4

wallxloop:						    ; CODE XREF: action_wiresnips+29j
				push	bx
				mov	al, [di]
				cmp	al, [bx]
				jnb	short wallxnext
				dec	bx
				cmp	al, [bx]
				jb	short wallxnext
				dec	di
				mov	al, [di]
				dec	bx
				cmp	al, [bx]
				jz	short crawl_topleft
				dec	al
				cmp	al, [bx]
				jz	short crawl_bottomright
				inc	di

wallxnext:						    ; CODE XREF: action_wiresnips+Dj
							    ; action_wiresnips+12j
				pop	bx
				add	bx, 6		    ; wall stride
				dec	ch
				jnz	short wallxloop
				dec	di
				dec	bx
				dec	bx
				dec	bx
				mov	ch, 3

wallyloop:						    ; CODE XREF: action_wiresnips+52j
				push	bx
				mov	al, [di]
				cmp	al, [bx]
				jb	short wallynext
				inc	bx
				cmp	al, [bx]
				jnb	short wallynext
				inc	di
				mov	al, [di]
				inc	bx
				cmp	al, [bx]
				jz	short crawl_topright
				dec	al
				cmp	al, [bx]
				jz	short crawl_bottomleft
				dec	di

wallynext:						    ; CODE XREF: action_wiresnips+36j
							    ; action_wiresnips+3Bj
				pop	bx
				add	bx, 6		    ; wall stride
				dec	ch
				jnz	short wallyloop
				retn
; ---------------------------------------------------------------------------

crawl_topleft:						    ; CODE XREF: action_wiresnips+1Aj
				mov	al, 4
				jmp	short action_wiresnips_tail
; ---------------------------------------------------------------------------

crawl_topright:						    ; CODE XREF: action_wiresnips+43j
				mov	al, 5
				jmp	short action_wiresnips_tail
; ---------------------------------------------------------------------------

crawl_bottomright:					    ; CODE XREF: action_wiresnips+20j
				mov	al, 6
				jmp	short action_wiresnips_tail
; ---------------------------------------------------------------------------

crawl_bottomleft:					    ; CODE XREF: action_wiresnips+49j
				mov	al, 7

action_wiresnips_tail:					    ; CODE XREF: action_wiresnips+57j
							    ; action_wiresnips+5Bj ...
				pop	bx
				mov	bx, offset vischar_0.direction ; Hero's visible character.
				mov	[bx], al
				dec	bx
				mov	byte ptr [bx], 80h
				mov	bx, offset vischar_0.flags ; Hero's visible character.
				mov	byte ptr [bx], vischar_FLAGS_CUTTING_WIRE
				mov	al, 0Ch		    ; height
				mov	byte ptr ds:vischar_0.mi.pos.height, al	; Hero's visible character.
				mov	bx, offset sprite_prisoner_facing_away_4
				mov	ds:vischar_0.mi.sprite,	bx ; Hero's visible character.
				mov	al, ds:game_counter
				add	al, 60h	; '`'
				mov	ds:player_locked_out_until, al
				mov	ch, message_CUTTING_THE_WIRE
				jmp	queue_message_for_display
action_wiresnips		endp


; =============== S U B	R O U T	I N E =======================================


action_lockpick			proc near		    ; DATA XREF: seg000:926Eo
				call	open_door
				jnz	short exit
				mov	ds:ptr_to_door_being_lockpicked, bx
				mov	al, ds:game_counter
				add	al, 0FFh
				mov	ds:player_locked_out_until, al
				mov	bx, offset vischar_0.flags ; Hero's visible character.
				mov	byte ptr [bx], vischar_FLAGS_PICKING_LOCK
				mov	ch, message_PICKING_THE_LOCK
				call	queue_message_for_display

exit:							    ; CODE XREF: action_lockpick+3j
				retn
action_lockpick			endp


; =============== S U B	R O U T	I N E =======================================


action_red_key			proc near		    ; DATA XREF: seg000:927Co
				mov	al, room_22_REDKEY
				jmp	short action_key
action_red_key			endp


; =============== S U B	R O U T	I N E =======================================


action_yellow_key		proc near		    ; DATA XREF: seg000:927Eo
				mov	al, room_13_CORRIDOR
				jmp	short action_key
action_yellow_key		endp


; =============== S U B	R O U T	I N E =======================================


action_green_key		proc near		    ; DATA XREF: seg000:9280o
				mov	al, room_14_TORCH
action_green_key		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


action_key			proc near		    ; CODE XREF: action_red_key+2j
							    ; action_yellow_key+2j
				push	ax
				call	open_door
				pop	cx
				jnz	short exit
				mov	al, [bx]
				and	al, 7Fh
				xchg	al, cl
				cmp	al, cl
				mov	ch, message_INCORRECT_KEY
				jnz	short message
				and	byte ptr [bx], 7Fh
				call	increase_morale_by_10_score_by_50
				mov	ch, message_IT_IS_OPEN

message:						    ; CODE XREF: action_key+11j
				call	queue_message_for_display

exit:							    ; CODE XREF: action_key+5j
				retn
action_key			endp


; =============== S U B	R O U T	I N E =======================================


open_door			proc near		    ; CODE XREF: action_lockpickp
							    ; action_key+1p
				mov	al, ds:room_index
				and	al, al
				jz	short loc_7E78
				jmp	short loc_7EA5
; ---------------------------------------------------------------------------
				nop			    ; odd

loc_7E78:						    ; CODE XREF: open_door+5j
				mov	ch, 5
				mov	bx, offset gates_and_doors

loc_7E7D:						    ; CODE XREF: open_door+2Dj
				mov	al, [bx]
				and	al, 7Fh
				push	bx
				push	cx
				call	get_door_position
				push	bx
				call	door_in_range
				pop	bx
				jnb	short loc_7EA0
				inc	bx
				inc	bx
				inc	bx
				inc	bx
				call	door_in_range
				jnb	short loc_7EA0
				pop	cx
				pop	bx
				inc	bx
				dec	ch
				jnz	short loc_7E7D
				or	al, 1
				retn
; ---------------------------------------------------------------------------

loc_7EA0:						    ; CODE XREF: open_door+1Dj
							    ; open_door+26j
				pop	cx
				pop	bx
				xor	al, al
				retn
; ---------------------------------------------------------------------------

loc_7EA5:						    ; CODE XREF: open_door+7j
				mov	bx, (offset gates_and_doors+2)
				mov	ch, 8

loc_7EAA:						    ; CODE XREF: open_door+57j
				mov	al, [bx]
				and	al, 7Fh
				mov	cl, al
				mov	di, offset doors_related

loc_7EB3:						    ; CODE XREF: open_door+52j
				mov	al, [di]
				cmp	al, 0FFh
				jz	short loc_7EC2
				and	al, 7Fh
				cmp	al, cl
				jz	short loc_7ECA
				inc	di
				jmp	short loc_7EB3
; ---------------------------------------------------------------------------

loc_7EC2:						    ; CODE XREF: open_door+49j
							    ; open_door+8Aj
				inc	bx
				dec	ch
				jnz	short loc_7EAA
				or	al, 1
				retn
; ---------------------------------------------------------------------------

loc_7ECA:						    ; CODE XREF: open_door+4Fj
				mov	al, [di]
				push	bx
				push	di
				push	cx
				call	get_door_position
				inc	bx
				xchg	di, bx
				mov	bx, offset saved_pos
				mov	ch, 2

loc_7EDA:						    ; CODE XREF: open_door+7Fj
				mov	al, [di]
				sub	al, 3
				cmp	al, [bx]
				jnb	short loc_7EF5
				add	al, 6
				cmp	al, [bx]
				jb	short loc_7EF5
				inc	bx
				inc	bx
				inc	di
				dec	ch
				jnz	short loc_7EDA
				pop	cx
				pop	di
				pop	bx
				xor	al, al
				retn
; ---------------------------------------------------------------------------

loc_7EF5:						    ; CODE XREF: open_door+72j
							    ; open_door+78j
				pop	cx
				pop	di
				pop	bx
				jmp	short loc_7EC2
open_door			endp

; ---------------------------------------------------------------------------
walls				wall < 106,  110,   82,	  98, 0,   11>
							    ; DATA XREF: bounds_check+Co
				wall <	94,   98,   82,	  98, 0,   11>
				wall <	82,   86,   82,	  98, 0,   11>
				wall <	62,   90,  106,	 128, 0,   48>
				wall <	52,  128,  114,	 128, 0,   48>
				wall < 126,  152,   94,	 128, 0,   48>
				wall < 130,  152,   90,	 128, 0,   48>
				wall < 134,  140,   70,	 128, 0,   10>
				wall < 130,  134,   70,	  74, 0,   18>
				wall < 110,  130,   70,	  71, 0,   10>
				wall < 109,  111,   69,	  73, 0,   18>
				wall < 103,  105,   69,	  73, 0,   18>
				wall <	70,   70,   70,	 106, 0,    8>
				wall <	62,   62,   62,	 106, 0,    8>
				wall <	78,   78,   46,	  62, 0,    8>
				wall < 104,  104,   46,	  69, 0,    8>
				wall <	62,  104,   62,	  62, 0,    8>
				wall <	78,  104,   46,	  46, 0,    8>
				wall <	70,  103,   70,	  70, 0,    8>
				wall < 104,  106,   56,	  58, 0,    8>
				wall <	78,   80,   46,	  48, 0,    8>
				wall <	70,   72,   70,	  72, 0,    8>
				wall <	70,   72,   94,	  96, 0,    8>
				wall < 105,  109,   70,	  73, 0,    8>
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR in_permitted_area

escaped:						    ; CODE XREF: in_permitted_area+1Aj
							    ; in_permitted_area+27j
				call	screen_reset
				mov	bx, offset escapestring_well_done
				call	screenlocstring_plot
				call	screenlocstring_plot
				call	screenlocstring_plot
				mov	cl, 0
				mov	bx, offset items_held
				call	join_item_to_escapeitem
				inc	bx
				call	join_item_to_escapeitem
				mov	al, cl
				cmp	al, 5
				jz	short loc_7FAF
				cmp	al, 3
				jnz	short loc_7FBE

loc_7FAF:						    ; CODE XREF: in_permitted_area+1774j
				mov	bx, offset escapestring_and_will_cross_the
				call	screenlocstring_plot
				call	screenlocstring_plot
				mov	al, 0FFh
				push	ax
				jmp	short loc_7FDF
; END OF FUNCTION CHUNK	FOR in_permitted_area
; ---------------------------------------------------------------------------
				nop			    ; odd
; START	OF FUNCTION CHUNK FOR in_permitted_area

loc_7FBE:						    ; CODE XREF: in_permitted_area+1778j
				push	ax
				mov	bx, offset escapestring_but_were_recaptured
				call	screenlocstring_plot
				pop	ax
				push	ax
				cmp	al, 8
				jnb	short loc_7FDC
				mov	bx, offset escapestring_totally_unprepared
				and	al, al
				jz	short loc_7FDC
				mov	bx, (offset aTotallyUnprepareda+12h)
				test	al, 1
				jz	short loc_7FDC
				mov	bx, (offset aTotallyLosts+0Ch)

loc_7FDC:						    ; CODE XREF: in_permitted_area+1794j
							    ; in_permitted_area+179Bj ...
				call	screenlocstring_plot

loc_7FDF:						    ; CODE XREF: in_permitted_area+1786j
				mov	bx, offset escapestring_press_any_key
				call	screenlocstring_plot

waitforkeydown:						    ; CODE XREF: in_permitted_area+17B3j
				call	keyscan_all
				jnz	short waitforkeydown

waitforkeyup:						    ; CODE XREF: in_permitted_area+17B8j
				call	keyscan_all
				jz	short waitforkeyup
				pop	ax
				cmp	al, 0FFh
				jnz	short loc_7FF7
				jmp	reset_game
; ---------------------------------------------------------------------------

loc_7FF7:						    ; CODE XREF: in_permitted_area+17BDj
				cmp	al, escapeitem_UNIFORM
				jb	short loc_7FFE
				jmp	reset_game
; ---------------------------------------------------------------------------

loc_7FFE:						    ; CODE XREF: in_permitted_area+17C4j
				jmp	solitary
; END OF FUNCTION CHUNK	FOR in_permitted_area

; =============== S U B	R O U T	I N E =======================================


keyscan_all			proc near		    ; CODE XREF: in_permitted_area:waitforkeydownp
							    ; in_permitted_area:waitforkeyupp
				mov	al, ds:keything_1
				and	al, ds:keything_mask
				and	al, 80h
				cmp	al, 80h	; '€'
				retn
keyscan_all			endp


; =============== S U B	R O U T	I N E =======================================


join_item_to_escapeitem		proc near		    ; CODE XREF: in_permitted_area+1769p
							    ; in_permitted_area+176Dp
				mov	al, [bx]
				mov	ah, escapeitem_COMPASS
				cmp	al, item_COMPASS
				jz	short exit
				mov	ah, escapeitem_PAPERS
				cmp	al, item_PAPERS
				jz	short exit
				mov	ah, escapeitem_PURSE
				cmp	al, item_PURSE
				jz	short exit
				mov	ah, escapeitem_UNIFORM
				cmp	al, item_UNIFORM
				jz	short exit
				xor	ah, ah

exit:							    ; CODE XREF: join_item_to_escapeitem+6j
							    ; join_item_to_escapeitem+Cj ...
				add	cl, ah
				retn
join_item_to_escapeitem		endp

; ---------------------------------------------------------------------------
escapestring_well_done		screenstring <3E4h, 9>	    ; DATA XREF: in_permitted_area+1758o
aWellDone			db 'WELL DONE'
escapestring_you_have_escaped	screenstring <65Ch, 16>
aYouHaveEscaped			db 'YOU HAVE ESCAPED'
escapestring_from_the_camp_0	screenstring <8E0h, 13>
aFromTheCamp			db 'FROM THE CAMP'
escapestring_and_will_cross_the	screenstring <0A1Ah, 18>    ; DATA XREF: in_permitted_area:loc_7FAFo
aAndWillCrossThe		db 'AND WILL CROSS THE'
escapestring_border_successfully screenstring <0C9Ah, 19>
aBorderSuccessfully		db 'BORDER SUCCESSFULLY'
escapestring_but_were_recaptured screenstring <0A1Ah, 19>   ; DATA XREF: in_permitted_area+178Ao
aButWereRecaptured		db 'BUT WERE RECAPTURED'
escapestring_and_shot_as_a_spy	screenstring <0C9Ch, 17>
aAndShotAsASpy			db 'AND SHOT AS A SPY'
escapestring_totally_unprepared	screenstring <0C9Ah, 18>    ; DATA XREF: in_permitted_area+1796o
aTotallyUnprepareda		db 'TOTALLY UNPREPARED '
				db  0Ch			    ; doesn't look right: one byte short to be a screenlocstring
				db  0Ch
aTotallyLosts			db 'TOTALLY LOST˜'          ; DATA XREF: in_permitted_area+17A4o
				db  0Ch
				db  15h
aDueToLackOfPapers		db 'DUE TO LACK OF PAPERS'
escapestring_press_any_key	screenstring <1422h, 13>    ; DATA XREF: in_permitted_area:loc_7FDFo
aPressAnyKey			db 'PRESS ANY KEY'
game_window_attribute		db 0			    ; DATA XREF: plot_game_window+1r
							    ; screen_reset+3w ...
							    ; new compared to the speccy version

; =============== S U B	R O U T	I N E =======================================


choose_game_window_attributes	proc near		    ; CODE XREF: event_night_time:loc_6257p
							    ; action_shovel+1Bp ...
				mov	al, ds:room_index
				cmp	al, room_29_SECOND_TUNNEL_START
				jnb	short intunnel
				mov	al, ds:day_or_night
				mov	cl, attribute_WHITE_OVER_BLACK
				and	al, al
				jz	short set_attribute_from_cl
				mov	al, ds:room_index
				mov	cl, attribute_BRIGHT_BLUE_OVER_BLACK
				and	al, al
				jz	short set_attribute_from_cl
				mov	cl, attribute_CYAN_OVER_BLACK

set_attribute_from_cl:					    ; CODE XREF: choose_game_window_attributes+Ej
							    ; choose_game_window_attributes+17j ...
				mov	al, cl

set:							    ; CODE XREF: choose_game_window_attributes+39j
				mov	ds:game_window_attribute, al
				retn
; ---------------------------------------------------------------------------

intunnel:						    ; CODE XREF: choose_game_window_attributes+5j
				mov	cl, attribute_RED_OVER_BLACK
				mov	bx, ds:items_held   ; is there a torch in either slot?
				mov	al, item_TORCH
				cmp	al, bl
				jz	short set_attribute_from_cl
				cmp	al, bh
				jz	short set_attribute_from_cl
				call	wipe_visible_tiles
				call	plot_interior_tiles
				mov	al, attribute_BLUE_OVER_BLACK
				jmp	short set
choose_game_window_attributes	endp


; =============== S U B	R O U T	I N E =======================================


item_discovered			proc near		    ; CODE XREF: follow_suspicious_character+24p
							    ; move_characters+28p ...
				cmp	cl, item_NONE
				jz	short exit
				and	cl, 0Fh		    ; itemstruct_ITEM_MASK
				mov	al, cl
				mov	ch, message_ITEM_DISCOVERED
				call	queue_message_for_display
				mov	ch, 5
				call	decrease_morale
				mov	al, cl
				cbw
				mov	si, offset default_item_locations
				add	si, ax
				shl	ax, 1
				add	si, ax
				mov	al, cl
				call	item_to_itemstruct
				and	byte ptr [bx], 1Fh
				cmp	cl, item_FOOD
				jnz	short notfood
				mov	ds:item_attributes+7, 7	; reset	the food poisoned state

notfood:						    ; CODE XREF: item_discovered+2Bj
				inc	bx
				lodsw
				mov	[bx], ax
				inc	bx
				inc	bx
				mov	ah, al
				lodsb
				and	ah, ah		    ; room_0 ?
				jnz	short interior
				mov	[bx], ax
				inc	bx
				call	calc_exterior_item_screenpos
				retn
; ---------------------------------------------------------------------------

interior:						    ; CODE XREF: item_discovered+3Dj
				mov	ah, 5
				mov	[bx], ax
				inc	bx
				call	calc_interior_item_screenpos

exit:							    ; CODE XREF: item_discovered+3j
				retn
item_discovered			endp

; ---------------------------------------------------------------------------
default_item_locations		default_item_location <0FFh,  64,  32>;	0
							    ; DATA XREF: item_discovered+17o
							    ; is_item_discoverable_interior+1Eo
				default_item_location <9, 62, 48>
				default_item_location <0Ah, 73,	36>
				default_item_location <0Bh, 42,	58>
				default_item_location <0Eh, 50,	24>
				default_item_location <3Fh, 36,	44>
				default_item_location <0Fh, 44,	65>
				default_item_location <13h, 64,	48>
				default_item_location <1, 66, 52>
				default_item_location <16h, 60,	42>
				default_item_location <0Bh, 28,	34>
				default_item_location <0, 74, 72>
				default_item_location <3Fh, 28,	50>
				default_item_location <12h, 36,	58>
				default_item_location <3Fh, 30,	34>
				default_item_location <3Fh, 52,	28>
plotter_self_modified_addrs	dw offset loc_841A	    ; 0
							    ; DATA XREF: setup_item_plotting:loc_8C5Fo
							    ; setup_vischar_plotting+7Co ...
				dw offset loc_84D5	    ; 1
				dw offset loc_8428	    ; 2
				dw offset loc_84E9	    ; 3
				dw offset loc_843C	    ; 4
				dw offset loc_84F7	    ; 5
				dw offset loc_8274	    ; 6
				dw offset loc_8342	    ; 7
				dw offset loc_8282	    ; 8
				dw offset loc_8350	    ; 9
				dw offset loc_8296	    ; 10
				dw offset loc_8364	    ; 11
				dw offset loc_82A4	    ; 12
				dw offset loc_8372	    ; 13
				dw offset loc_82A4	    ; 14
				dw offset loc_8372	    ; 15
				dw offset masked_sprite_plotter_16_wide; 16
				dw offset masked_sprite_plotter_24_wide; 17
unk_81DB			db    0			    ; DATA XREF: masked_sprite_plotter_24_wide+3o
							    ; masked_sprite_plotter_16_wide_case_1_searchlight+Ao
				db    0
				db    0
				db    0
				db    0
				db    0

; =============== S U B	R O U T	I N E =======================================


masked_sprite_plotter_24_wide	proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+22p
							    ; DATA XREF: seg000:plotter_self_modified_addrso
				push	ds
				pop	es
				cld
				mov	si, offset unk_81DB
				mov	al, [bp+18h]	    ; speccy version begins here
				and	al, 7
				cmp	al, 4
				jb	short loc_81F3
				jmp	loc_82BB
; ---------------------------------------------------------------------------

loc_81F3:						    ; CODE XREF: masked_sprite_plotter_24_wide+Dj
				not	al
				and	al, 3
				shl	al, 1
				shl	al, 1
				mov	byte ptr ds:loc_824C+1,	al
				mov	byte ptr ds:loc_8222+1,	al
				mov	bx, ds:bitmap_pointer
				mov	di, ds:mask_pointer

loc_8209:						    ; DATA XREF: setup_vischar_plotting:loc_916Ew
				mov	ch, 20h	; ' '

loc_820B:						    ; CODE XREF: masked_sprite_plotter_24_wide+D6j
				push	cx
				mov	ch, [bx]
				inc	bx
				mov	cl, [bx]
				inc	bx
				mov	dh, [bx]
				inc	bx
				push	bx
				test	ds:flip_sprite,	80h
				jz	short noflip1
				call	flip_24_masked_pixels_1

noflip1:						    ; CODE XREF: masked_sprite_plotter_24_wide+3Aj
				mov	dl, 0

loc_8222:						    ; DATA XREF: masked_sprite_plotter_24_wide+1Dw
				jmp	short $+2
				shr	cx, 1
				rcr	dx, 1
				shr	cx, 1
				rcr	dx, 1
				shr	cx, 1
				rcr	dx, 1
				mov	[si], cx
				mov	[si+2],	dx
				mov	ch, [di]
				inc	di
				mov	cl, [di]
				inc	di
				mov	dh, [di]
				inc	di
				push	di
				test	ds:flip_sprite,	80h
				jz	short noflip2
				call	flip_24_masked_pixels_1

noflip2:						    ; CODE XREF: masked_sprite_plotter_24_wide+63j
				mov	dl, 0FFh
				stc

loc_824C:						    ; DATA XREF: masked_sprite_plotter_24_wide+1Aw
				jmp	short $+2
				rcr	cx, 1
				rcr	dx, 1
				rcr	cx, 1
				rcr	dx, 1
				rcr	cx, 1
				rcr	dx, 1
				mov	[si+4],	dx
				mov	dx, [si]
				mov	bx, ds:foreground_mask_pointer
				mov	di, ds:screen_pointer
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_8274:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_8282:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	cx, [si+4]
				mov	dx, [si+2]
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_8296:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_82A4:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	ds:foreground_mask_pointer, bx
				add	di, 14h
				mov	ds:screen_pointer, di
				pop	di
				pop	bx
				pop	cx
				dec	ch
				jz	short exit
				jmp	loc_820B
; ---------------------------------------------------------------------------

exit:							    ; CODE XREF: masked_sprite_plotter_24_wide+D4j
				retn
; ---------------------------------------------------------------------------

loc_82BB:						    ; CODE XREF: masked_sprite_plotter_24_wide+Fj
				sub	al, 4
				shl	al, 1
				shl	al, 1
				mov	byte ptr ds:loc_8316+1,	al
				mov	byte ptr ds:loc_82E8+1,	al
				mov	bx, ds:bitmap_pointer
				mov	di, ds:mask_pointer

loc_82CF:						    ; DATA XREF: setup_vischar_plotting+85w
				mov	ch, 20h	; ' '

loc_82D1:						    ; CODE XREF: masked_sprite_plotter_24_wide+1A4j
				push	cx
				mov	cl, [bx]
				inc	bx
				mov	dh, [bx]
				inc	bx
				mov	dl, [bx]
				inc	bx
				push	bx
				test	ds:flip_sprite,	80h
				jz	short loc_82E6
				call	flip_24_masked_pixels_2

loc_82E6:						    ; CODE XREF: masked_sprite_plotter_24_wide+100j
				mov	ch, 0

loc_82E8:						    ; DATA XREF: masked_sprite_plotter_24_wide+E3w
				jmp	short $+2
				shl	dx, 1
				rcl	cx, 1
				shl	dx, 1
				rcl	cx, 1
				shl	dx, 1
				rcl	cx, 1
				shl	dx, 1
				rcl	cx, 1
				mov	[si], cx
				mov	[si+2],	dx
				mov	cl, [di]
				inc	di
				mov	dh, [di]
				inc	di
				mov	dl, [di]
				inc	di
				push	di
				test	ds:flip_sprite,	80h
				jz	short loc_8313
				call	flip_24_masked_pixels_2

loc_8313:						    ; CODE XREF: masked_sprite_plotter_24_wide+12Dj
				mov	ch, 0FFh
				stc

loc_8316:						    ; DATA XREF: masked_sprite_plotter_24_wide+E0w
				jmp	short $+2
				rcl	dx, 1
				rcl	cx, 1
				rcl	dx, 1
				rcl	cx, 1
				rcl	dx, 1
				rcl	cx, 1
				rcl	dx, 1
				rcl	cx, 1
				mov	[si+4],	dx
				mov	dx, [si]
				mov	bx, ds:foreground_mask_pointer
				mov	di, ds:screen_pointer
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_8342:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_8350:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	cx, [si+4]
				mov	dx, [si+2]
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_8364:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_8372:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	ds:foreground_mask_pointer, bx
				add	di, 14h
				mov	ds:screen_pointer, di
				pop	di
				pop	bx
				pop	cx
				dec	ch
				jz	short locret_8388
				jmp	loc_82D1
; ---------------------------------------------------------------------------

locret_8388:						    ; CODE XREF: masked_sprite_plotter_24_wide+1A2j
				retn
masked_sprite_plotter_24_wide	endp


; =============== S U B	R O U T	I N E =======================================


masked_sprite_plotter_16_wide_case_1_searchlight proc near  ; CODE XREF: locate_vischar_or_itemstruct_then_plot+34p

; FUNCTION CHUNK AT 8390 SIZE 0000003B BYTES
; FUNCTION CHUNK AT 8454 SIZE 0000002A BYTES

				xor	al, al
				jmp	short loc_8390
masked_sprite_plotter_16_wide_case_1_searchlight endp ;	sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


masked_sprite_plotter_16_wide	proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot:mustbe16widep
							    ; DATA XREF: seg000:plotter_self_modified_addrso
				mov	al, [bp+18h]
masked_sprite_plotter_16_wide	endp ; sp-analysis failed

; START	OF FUNCTION CHUNK FOR masked_sprite_plotter_16_wide_case_1_searchlight

loc_8390:						    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+2j
				push	ds
				pop	es
				cld
				mov	si, offset unk_81DB
				and	al, 7
				cmp	al, 4
				jb	short masked_sprite_plotter_16_wide_left
				jmp	loc_8454
; ---------------------------------------------------------------------------

masked_sprite_plotter_16_wide_left:			    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+11j
				not	al
				and	al, 3
				shl	al, 1
				shl	al, 1
				mov	byte ptr ds:masked_sprite_plotter_16_wide_left+1, al
				mov	byte ptr ds:loc_83F2+1,	al
				mov	bx, ds:bitmap_pointer
				mov	di, ds:mask_pointer

loc_83B5:						    ; DATA XREF: setup_item_plotting+39w
							    ; setup_vischar_plotting+72w
				mov	ch, 20h	; ' '

loc_83B7:						    ; CODE XREF: masked_sprite_plotter_16_wide_left+85j
				push	cx
				mov	ch, [bx]
				inc	bx
				mov	cl, [bx]
				inc	bx
				push	bx
				test	ds:flip_sprite,	80h
				jz	short noflip
				call	flip_16_masked_pixels

noflip:							    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+3Bj
				mov	dh, 0
; END OF FUNCTION CHUNK	FOR masked_sprite_plotter_16_wide_case_1_searchlight

; =============== S U B	R O U T	I N E =======================================


masked_sprite_plotter_16_wide_left proc	near		    ; DATA XREF: masked_sprite_plotter_16_wide_case_1_searchlight+1Ew
				jmp	short $+2
				shr	cx, 1
				rcr	dh, 1
				shr	cx, 1
				rcr	dh, 1
				shr	cx, 1
				rcr	dh, 1
				mov	[si], cx
				mov	[si+2],	dx
				mov	ch, [di]
				inc	di
				mov	cl, [di]
				inc	di
				push	di
				test	ds:flip_sprite,	80h
				jz	short noflip
				call	flip_16_masked_pixels

noflip:							    ; CODE XREF: masked_sprite_plotter_16_wide_left+1Fj
				mov	dh, 0FFh
				stc

loc_83F2:						    ; DATA XREF: masked_sprite_plotter_16_wide_case_1_searchlight+21w
				jmp	short $+2
				rcr	cx, 1
				rcr	dh, 1
				rcr	cx, 1
				rcr	dh, 1
				rcr	cx, 1
				rcr	dh, 1
				mov	[si+4],	dx
				mov	dx, [si]
				mov	bx, ds:foreground_mask_pointer
				mov	di, ds:screen_pointer
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_841A:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_8428:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	cx, [si+4]
				mov	dx, [si+2]
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_843C:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				inc	bx
				mov	ds:foreground_mask_pointer, bx
				add	di, 15h
				mov	ds:screen_pointer, di
				pop	di
				pop	bx
				pop	cx
				dec	ch
				jz	short locret_8453
				jmp	loc_83B7
; ---------------------------------------------------------------------------

locret_8453:						    ; CODE XREF: masked_sprite_plotter_16_wide_left+83j
				retn
masked_sprite_plotter_16_wide_left endp	; sp-analysis failed

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR masked_sprite_plotter_16_wide_case_1_searchlight

loc_8454:						    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+13j
				sub	al, 4
				shl	al, 1
				shl	al, 1
				mov	byte ptr ds:loc_84A9+1,	al
				mov	byte ptr ds:masked_sprite_plotter_16_wide_right+1, al
				mov	bx, ds:bitmap_pointer
				mov	di, ds:mask_pointer

loc_8468:						    ; DATA XREF: setup_vischar_plotting+76w
				mov	ch, 20h	; ' '

loc_846A:						    ; CODE XREF: masked_sprite_plotter_16_wide_right+8Dj
				push	cx
				mov	ch, [bx]
				inc	bx
				mov	cl, [bx]
				inc	bx
				push	bx
				test	ds:flip_sprite,	80h
				jz	short loc_847C
				call	flip_16_masked_pixels

loc_847C:						    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+EEj
				mov	dh, 0
; END OF FUNCTION CHUNK	FOR masked_sprite_plotter_16_wide_case_1_searchlight

; =============== S U B	R O U T	I N E =======================================


masked_sprite_plotter_16_wide_right proc near		    ; DATA XREF: masked_sprite_plotter_16_wide_case_1_searchlight+D4w
				jmp	short $+2
				shl	cx, 1
				rcl	dh, 1
				shl	cx, 1
				rcl	dh, 1
				shl	cx, 1
				rcl	dh, 1
				shl	cx, 1
				rcl	dh, 1
				mov	[si], dx
				mov	[si+2],	cx
				mov	ch, [di]
				inc	di
				mov	cl, [di]
				inc	di
				push	di
				test	ds:flip_sprite,	80h
				jz	short loc_84A6
				call	flip_16_masked_pixels

loc_84A6:						    ; CODE XREF: masked_sprite_plotter_16_wide_right+23j
				mov	dh, 0FFh
				stc

loc_84A9:						    ; DATA XREF: masked_sprite_plotter_16_wide_case_1_searchlight+D1w
				jmp	short $+2
				rcl	cx, 1
				rcl	dh, 1
				rcl	cx, 1
				rcl	dh, 1
				rcl	cx, 1
				rcl	dh, 1
				rcl	cx, 1
				rcl	dh, 1
				mov	[si+4],	cx
				mov	cx, [si]
				mov	bx, ds:foreground_mask_pointer
				mov	di, ds:screen_pointer
				mov	al, [bx]
				and	ch, al
				not	al
				or	al, dh
				and	al, [di]
				or	al, ch
				inc	bx

loc_84D5:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	cx, [si+4]
				mov	dx, [si+2]
				mov	al, [bx]
				and	dh, al
				not	al
				or	al, ch
				and	al, [di]
				or	al, dh
				inc	bx

loc_84E9:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				mov	al, [bx]
				and	dl, al
				not	al
				or	al, cl
				and	al, [di]
				or	al, dl
				inc	bx

loc_84F7:						    ; DATA XREF: seg000:plotter_self_modified_addrso
				stosb
				inc	bx
				mov	ds:foreground_mask_pointer, bx
				add	di, 15h

loc_8500:
				mov	ds:screen_pointer, di
				pop	di
				pop	bx
				pop	cx
				dec	ch
				jz	short locret_850E
				jmp	loc_846A
; ---------------------------------------------------------------------------

locret_850E:						    ; CODE XREF: masked_sprite_plotter_16_wide_right+8Bj
				retn
masked_sprite_plotter_16_wide_right endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


flip_24_masked_pixels_1		proc near		    ; CODE XREF: masked_sprite_plotter_24_wide+3Cp
							    ; masked_sprite_plotter_24_wide+65p
				mov	bx, offset reversed ; A	table of 256 bit-reversed bytes.
				mov	al, ch
				xlat
				mov	ch, al
				mov	al, cl
				xlat
				mov	cl, al
				mov	al, dh
				xlat
				mov	dh, al
				xchg	ch, dh
				retn
flip_24_masked_pixels_1		endp


; =============== S U B	R O U T	I N E =======================================


flip_24_masked_pixels_2		proc near		    ; CODE XREF: masked_sprite_plotter_24_wide+102p
							    ; masked_sprite_plotter_24_wide+12Fp
				mov	bx, offset reversed ; A	table of 256 bit-reversed bytes.
				mov	al, cl
				xlat
				mov	cl, al
				mov	al, dh
				xlat
				mov	dh, al
				mov	al, dl
				xlat
				mov	dl, al
				xchg	cl, dl
				retn
flip_24_masked_pixels_2		endp


; =============== S U B	R O U T	I N E =======================================


flip_16_masked_pixels		proc near		    ; CODE XREF: masked_sprite_plotter_16_wide_case_1_searchlight+3Dp
							    ; masked_sprite_plotter_16_wide_left+21p ...
				mov	bx, offset reversed ; A	table of 256 bit-reversed bytes.
				mov	al, ch
				xlat
				mov	ch, al
				mov	al, cl
				xlat
				mov	cl, al
				xchg	ch, cl
				retn
flip_16_masked_pixels		endp


; =============== S U B	R O U T	I N E =======================================


guards_follow_suspicious_character proc	near		    ; CODE XREF: follow_suspicious_character+52p
				mov	al, [bp+0]
				and	al, al
				jz	short loc_855B
				mov	al, byte ptr ds:vischar_0.mi.sprite ; Hero's visible character.
				mov	dx, offset sprite_guard_facing_away_4
				cmp	al, dl
				jnz	short loc_855B
				retn
; ---------------------------------------------------------------------------

loc_855B:						    ; CODE XREF: guards_follow_suspicious_character+5j
							    ; guards_follow_suspicious_character+Fj
				cmp	byte ptr [bp+1], 4
				jnz	short loc_8562
				retn
; ---------------------------------------------------------------------------

loc_8562:						    ; CODE XREF: guards_follow_suspicious_character+16j
				mov	al, ds:room_index
				and	al, al
				jnz	short notoutdoors
				mov	si, bp
				add	si, 0Fh
				mov	di, offset tinypos_stash
				call	pos_to_tinypos
				mov	bx, offset hero_map_position
				mov	si, offset tinypos_stash
				mov	cl, [bp+0Eh]
				rcr	cl, 1
				jb	short loc_85A0
				mov	al, [si+1]
				dec	al
				cmp	al, [bx+1]
				jnb	short exit
				add	al, 2
				cmp	al, [bx+1]
				jb	short exit
				mov	al, [si]
				cmp	al, [bx]
				test	cl, 1
				jnz	short loc_859C
				cmc

loc_859C:						    ; CODE XREF: guards_follow_suspicious_character+50j
				jb	short exit
				jmp	short notoutdoors
; ---------------------------------------------------------------------------

loc_85A0:						    ; CODE XREF: guards_follow_suspicious_character+36j
				mov	al, [si]
				dec	al
				cmp	al, [bx]
				jnb	short exit
				add	al, 2
				cmp	al, [bx]
				jb	short exit
				mov	al, [si+1]
				cmp	al, [bx+1]
				test	cl, 1
				jnz	short loc_85BA
				cmc

loc_85BA:						    ; CODE XREF: guards_follow_suspicious_character+6Ej
				jb	short exit

notoutdoors:						    ; CODE XREF: guards_follow_suspicious_character+1Ej
							    ; guards_follow_suspicious_character+55j
				mov	al, ds:red_flag
				and	al, al
				jnz	short alarm
				mov	al, [bp+13h]
				cmp	al, 20h	; ' '
				jnb	short exit
				mov	byte ptr [bp+1], 2
				retn
; ---------------------------------------------------------------------------

alarm:							    ; CODE XREF: guards_follow_suspicious_character+78j
				mov	ds:bell, 0	    ; bell_RING_PERPETUAL
				call	hostiles_persue

exit:							    ; CODE XREF: guards_follow_suspicious_character+40j
							    ; guards_follow_suspicious_character+47j ...
				retn
guards_follow_suspicious_character endp


; =============== S U B	R O U T	I N E =======================================


pos_to_tinypos			proc near		    ; CODE XREF: character_behaviour+99p
							    ; in_permitted_area+Dp ...
				mov	cx, 3

loop:							    ; CODE XREF: pos_to_tinypos+13j
				mov	ax, [si]
				inc	si
				add	ax, 4		    ; inlined divide_by_8_with_rounding
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				mov	[di], al
				inc	si
				inc	di
				loop	loop
				retn
pos_to_tinypos			endp


; =============== S U B	R O U T	I N E =======================================


divide_by_8_with_rounding	proc near
				add	ax, 4
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				retn
divide_by_8_with_rounding	endp


; =============== S U B	R O U T	I N E =======================================


character_event			proc near		    ; CODE XREF: move_characters+68p
							    ; wassub_CB2D+1Cp

; FUNCTION CHUNK AT 86A5 SIZE 0000000A BYTES
; FUNCTION CHUNK AT 8702 SIZE 00000060 BYTES

				mov	al, [bx]
				cmp	al, 7
				jb	short loc_8605
				cmp	al, 0Dh
				jnb	short loc_8605
				jmp	loc_8728
; ---------------------------------------------------------------------------

loc_8605:						    ; CODE XREF: character_event+4j
							    ; character_event+8j
				cmp	al, 12h
				jb	short loc_8610
				cmp	al, 17h
				jnb	short loc_8610
				jmp	loc_8702
; ---------------------------------------------------------------------------

loc_8610:						    ; CODE XREF: character_event+Fj
							    ; character_event+13j
				push	bx
				mov	bx, offset character_to_event_handler_index_map
				mov	cx, 18h

loc_8617:						    ; CODE XREF: character_event+25j
				cmp	al, [bx]
				jz	short loc_8624
				inc	bx
				inc	bx
				loop	loc_8617
				pop	bx
				mov	byte ptr [bx], 0
				retn
; ---------------------------------------------------------------------------

loc_8624:						    ; CODE XREF: character_event+21j
				inc	bx
				mov	bl, [bx]
				mov	bh, 0
				shl	bx, 1
				add	bx, 8663h
				mov	bx, [bx]
				push	bx
				retn
; ---------------------------------------------------------------------------
character_to_event_handler_index_map dw	0A6h		    ; DATA XREF: character_event+19o
				dw 0A7h
				dw 1A8h
				dw 1A9h
				dw 5
				dw 106h
				dw 385h
				dw 386h
				dw 20Eh
				dw 20Fh
				dw 8Eh
				dw 18Fh
				dw 510h
				dw 511h
				dw 90h
				dw 191h
				dw 0A0h
				dw 1A1h
				dw 72Ah
				dw 82Ch
				dw 92Bh
				dw 6A4h
				dw 0A24h
				dw 425h
character_event			endp ; sp-analysis failed

character_event_handlers	dw offset charevnt_handler_0
				dw offset charevnt_handler_1
				dw offset charevnt_handler_2
				dw offset charevnt_handler_3_check_var_A13E
				dw offset charevnt_handler_4_zero_morale_1
				dw offset charevnt_handler_5_check_var_A13E_anotherone
				dw offset charevnt_handler_6
				dw offset charevnt_handler_7
				dw offset charevnt_handler_8_hero_sleeps
				dw offset charevnt_handler_9_hero_sits
				dw offset charevnt_handler_10_hero_released_from_solitary

; =============== S U B	R O U T	I N E =======================================


charevnt_handler_4_zero_morale_1 proc near		    ; DATA XREF: seg000:character_event_handlerso
				xor	al, al
				mov	byte ptr ds:morale_1_2,	al
				jmp	short charevnt_handler_0
charevnt_handler_4_zero_morale_1 endp


; =============== S U B	R O U T	I N E =======================================


charevnt_handler_6		proc near		    ; DATA XREF: seg000:character_event_handlerso
				pop	bx
				mov	byte ptr [bx], 3
				inc	bx
				mov	byte ptr [bx], 15h
				retn
charevnt_handler_6		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


charevnt_handler_10_hero_released_from_solitary	proc near   ; DATA XREF: seg000:character_event_handlerso
				pop	bx
				mov	byte ptr [bx], 0A4h ; '¤'
				inc	bx
				mov	byte ptr [bx], 3
				xor	al, al
				mov	ds:automatic_player_counter, al
				mov	cx, 2500h
				call	set_hero_target_location_0
				retn
charevnt_handler_10_hero_released_from_solitary	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


charevnt_handler_1		proc near		    ; DATA XREF: seg000:character_event_handlerso
				mov	cl, 10h
				jmp	short loc_86A7
charevnt_handler_1		endp


; =============== S U B	R O U T	I N E =======================================


charevnt_handler_2		proc near		    ; DATA XREF: seg000:character_event_handlerso
				mov	cl, 38h	; '8'
				jmp	short loc_86A7
charevnt_handler_2		endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR character_event

charevnt_handler_0:					    ; CODE XREF: charevnt_handler_4_zero_morale_1+5j
							    ; DATA XREF: seg000:character_event_handlerso
				mov	cl, 8

loc_86A7:						    ; CODE XREF: charevnt_handler_1+2j
							    ; charevnt_handler_2+2j
				pop	bx
				mov	byte ptr [bx], 0FFh
				inc	bx
				mov	[bx], cl
				retn
; END OF FUNCTION CHUNK	FOR character_event

; =============== S U B	R O U T	I N E =======================================


charevnt_handler_3_check_var_A13E proc near		    ; DATA XREF: seg000:character_event_handlerso

; FUNCTION CHUNK AT 8798 SIZE 0000002A BYTES

				pop	bx
				mov	al, ds:entered_move_characters
				and	al, al
				jnz	short var_A13E_nonzero
				jmp	short var_A13E_zero
; ---------------------------------------------------------------------------
				nop

var_A13E_nonzero:					    ; CODE XREF: charevnt_handler_3_check_var_A13E+6j
				jmp	short loc_86D4
; ---------------------------------------------------------------------------
				nop

charevnt_handler_5_check_var_A13E_anotherone:		    ; DATA XREF: seg000:character_event_handlerso
				pop	bx
				mov	al, ds:entered_move_characters
				and	al, al
				jnz	short var_A13E_is_nonzero_anotherone
				jmp	var_A13E_is_zero_anotherone
; ---------------------------------------------------------------------------

var_A13E_is_nonzero_anotherone:				    ; CODE XREF: charevnt_handler_3_check_var_A13E+14j
				jmp	loc_8798
; ---------------------------------------------------------------------------

charevnt_handler_7:					    ; DATA XREF: seg000:character_event_handlerso
				pop	bx
				mov	byte ptr [bx], 5
				inc	bx
				mov	byte ptr [bx], 0
				retn
; ---------------------------------------------------------------------------

loc_86D4:						    ; CODE XREF: charevnt_handler_3_check_var_A13E:var_A13E_nonzeroj
				mov	al, ds:character_index
				jmp	short loc_86E7
; ---------------------------------------------------------------------------

var_A13E_zero:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+8j
				mov	al, [bp+0]
				and	al, al
				jnz	short loc_86E7
				mov	cx, 2C00h
				call	set_hero_target_location
				retn
; ---------------------------------------------------------------------------

loc_86E7:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+28j
							    ; charevnt_handler_3_check_var_A13E+2Fj
				inc	bx
				mov	byte ptr [bx], 0
				cmp	al, 13h
				jb	short loc_86F3
				sub	al, 0Dh
				jmp	short loc_86FE
; ---------------------------------------------------------------------------

loc_86F3:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+3Ej
				test	al, 1
				mov	al, 0Dh
				jz	short loc_86FE
				mov	byte ptr [bx], 1
				or	al, 80h

loc_86FE:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+42j
							    ; charevnt_handler_3_check_var_A13E+48j
				dec	bx
				mov	[bx], al
				retn
charevnt_handler_3_check_var_A13E endp ; sp-analysis failed

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR character_event

loc_8702:						    ; CODE XREF: character_event+15j
				push	ax
				mov	dx, bx
				sub	al, 12h
				mov	bx, offset roomdef_25_breakfast_bench_D
				cmp	al, 3
				jb	short loc_8713
				mov	bx, offset roomdef_23_breakfast_bench_A
				sub	al, 3

loc_8713:						    ; CODE XREF: character_event+114j
				cbw
				add	bx, ax
				shl	ax, 1
				add	bx, ax
				mov	byte ptr [bx], interiorobject_PRISONER_SAT_MID_TABLE
				pop	ax
				mov	cl, room_25_BREAKFAST
				cmp	al, character_21_PRISONER_2
				jb	short loc_8743
				mov	cl, room_23_BREAKFAST
				jmp	short loc_8743
; ---------------------------------------------------------------------------

loc_8728:						    ; CODE XREF: character_event+Aj
				push	ax
				mov	dx, bx
				mov	bx, offset beds
				sub	al, 7
				cbw
				shl	ax, 1
				add	bx, ax
				mov	bx, [bx]
				mov	byte ptr [bx], interiorobject_OCCUPIED_BED
				pop	ax
				mov	cl, room_5_HUT3RIGHT
				cmp	al, character_10_GUARD_10
				jnb	short loc_8743
				mov	cl, room_3_HUT2RIGHT

loc_8743:						    ; CODE XREF: character_event+12Aj
							    ; character_event+12Ej ...
				mov	bx, dx
				mov	byte ptr [bx], 0
				cmp	cl, ds:room_index
				jz	short loc_8755
				sub	bx, 4
				mov	byte ptr [bx], 0FFh
				retn
; ---------------------------------------------------------------------------

loc_8755:						    ; CODE XREF: character_event+154j
				add	bx, 1Ah
				mov	byte ptr [bx], 0FFh
				call	setup_room
				call	plot_interior_tiles
				retn
; END OF FUNCTION CHUNK	FOR character_event

; =============== S U B	R O U T	I N E =======================================


charevnt_handler_9_hero_sits	proc near		    ; DATA XREF: seg000:character_event_handlerso
				pop	bx
				mov	ds:roomdef_25_breakfast_bench_G, 13h
				mov	bx, offset hero_in_breakfast
				jmp	short hero_sit_sleep_common
charevnt_handler_9_hero_sits	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


charevnt_handler_8_hero_sleeps	proc near		    ; DATA XREF: seg000:character_event_handlerso
				pop	bx
charevnt_handler_8_hero_sleeps	endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


hero_sleeps			proc near		    ; CODE XREF: reset_game_continued+42p
				mov	ds:room2_hut2_left_bed,	17h
				mov	bx, offset hero_in_bed

hero_sit_sleep_common:					    ; CODE XREF: charevnt_handler_9_hero_sits+9j
				mov	byte ptr [bx], 0FFh
				xor	al, al
				mov	bx, offset vischar_0.target ; Hero's visible character.
				mov	[bx], al
				mov	bx, offset vischar_0.mi	; Hero's visible character.
				mov	cx, 4

loop:							    ; CODE XREF: hero_sleeps+1Bj
				mov	[bx], al
				inc	bx
				loop	loop
				mov	bx, offset vischar_0 ; Hero's visible character.
				call	reset_position
				call	setup_room
				call	plot_interior_tiles
				retn
hero_sleeps			endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR charevnt_handler_3_check_var_A13E

loc_8798:						    ; CODE XREF: charevnt_handler_3_check_var_A13E:var_A13E_is_nonzero_anotheronej
				mov	al, ds:character_index
				jmp	short loc_87AA
; ---------------------------------------------------------------------------

var_A13E_is_zero_anotherone:				    ; CODE XREF: charevnt_handler_3_check_var_A13E+16j
				mov	al, [bp+0]
				and	al, al
				jnz	short loc_87AA
				mov	cx, 2B00h
				jmp	set_hero_target_location
; ---------------------------------------------------------------------------

loc_87AA:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+ECj
							    ; charevnt_handler_3_check_var_A13E+F3j
				inc	bx
				mov	byte ptr [bx], 0
				cmp	al, 13h
				jb	short loc_87B6
				sub	al, 2
				jmp	short loc_87BE
; ---------------------------------------------------------------------------

loc_87B6:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+101j
				test	al, 1
				mov	al, 18h
				jz	short loc_87BE
				inc	al

loc_87BE:						    ; CODE XREF: charevnt_handler_3_check_var_A13E+105j
							    ; charevnt_handler_3_check_var_A13E+10Bj
				dec	bx
				mov	[bx], al
				retn
; END OF FUNCTION CHUNK	FOR charevnt_handler_3_check_var_A13E

; =============== S U B	R O U T	I N E =======================================


setup_room			proc near		    ; CODE XREF: wake_up+66p
							    ; breakfast_time+63p ...
				call	wipe_visible_tiles
				mov	al, ds:room_index
				cbw
				shl	ax, 1
				mov	bx, (offset roomdef_bounds+26h)
				add	bx, ax
				mov	bx, [bx]
				push	bx
				call	setup_doors
				pop	si
				mov	di, offset roomdef_bounds_index
				movsb
				mov	al, [si]
				and	al, al
				mov	[di], al
				jnz	short loc_87E6
				inc	si
				jmp	short loc_87F2
; ---------------------------------------------------------------------------

loc_87E6:						    ; CODE XREF: setup_room+1Fj
				shl	al, 1
				shl	al, 1
				inc	al
				mov	cl, al
				mov	ch, 0
				rep movsb

loc_87F2:						    ; CODE XREF: setup_room+22j
				mov	di, offset interior_mask_data_count
				mov	al, [si]
				inc	si
				mov	[di], al
				and	al, al
				jz	short loc_8822
				inc	di
				mov	cl, al
				mov	ch, 0

loc_8803:						    ; CODE XREF: setup_room+5Ej
				push	cx
				lodsb
				push	si
				mov	ah, 0
				mov	si, ax
				shl	si, 1
				shl	si, 1
				shl	si, 1
				sub	si, ax
				add	si, offset interior_mask_data_source
				mov	cx, 7
				rep movsb
				mov	al, 20h	; ' '
				stosb
				pop	si
				pop	cx
				loop	loc_8803

loc_8822:						    ; CODE XREF: setup_room+3Aj
				mov	al, [si]
				and	al, al
				jz	short locret_8858
				cbw
				mov	cx, ax
				inc	si

expandobjects:						    ; CODE XREF: setup_room+94j
				push	cx
				mov	cl, [si]
				inc	si
				mov	al, [si]
				mov	ah, 0
				inc	si
				push	si
				mov	bl, [si]
				mov	bh, 0
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				mov	dx, bx

loc_8842:
				shl	bx, 1
				add	bx, dx
				add	bx, ax
				add	bx, offset tile_buf
				mov	di, bx
				mov	al, cl
				call	expand_object
				pop	si
				pop	cx
				inc	si
				loop	expandobjects

locret_8858:						    ; CODE XREF: setup_room+64j
				retn
setup_room			endp


; =============== S U B	R O U T	I N E =======================================


setup_doors			proc near		    ; CODE XREF: setup_room+11p
				std
				mov	al, 0FFh
				mov	di, (offset doors_related+3) ; might be	the end	of the block
				mov	cx, 4
				rep stosb
				inc	di
				cld
				mov	dh, ds:room_index
				shl	dh, 1
				shl	dh, 1
				mov	dl, 0
				mov	bx, offset door_positions
				mov	cx, 7Ch	; '|'       ; length of door_positions

loop:							    ; CODE XREF: setup_doors+34j
				mov	al, [bx]
				and	al, 0FCh
				cmp	al, dh
				jnz	short loc_8883
				mov	al, dl
				xor	al, 80h
				stosb

loc_8883:						    ; CODE XREF: setup_doors+23j
				xor	dl, 80h
				js	short next
				inc	dl

next:							    ; CODE XREF: setup_doors+2Dj
				add	bx, 4
				loop	loop
				retn
setup_doors			endp

; ---------------------------------------------------------------------------
expand_object_width		db 1			    ; DATA XREF: expand_object+10w
							    ; expand_object+3Ar ...

; =============== S U B	R O U T	I N E =======================================


expand_object			proc near		    ; CODE XREF: setup_room+8Ep
				mov	bx, offset interior_object_defs
				cbw
				shl	ax, 1
				add	bx, ax
				mov	bx, [bx]
				mov	ch, [bx]
				inc	bx
				mov	cl, [bx]
				inc	bx
				mov	ds:expand_object_width,	ch ; speccy version is self modified here

expand:							    ; CODE XREF: expand_object+35j
							    ; expand_object+46j ...
				mov	al, [bx]
				cmp	al, interiorobjecttile_ESCAPE
				jnz	short notescape
				inc	bx
				mov	al, [bx]
				cmp	al, interiorobjecttile_ESCAPE
				jz	short notescape
				and	al, 0F0h
				cmp	al, 80h	; '€'
				jnb	short run
				cmp	al, 40h	; '@'
				jz	short range

notescape:						    ; CODE XREF: expand_object+18j
							    ; expand_object+1Fj
				and	al, al
				jz	short loc_88C2
				mov	[di], al

loc_88C2:						    ; CODE XREF: expand_object+2Dj
				inc	bx
				inc	di
				dec	ch
				jnz	short expand
				add	di, 18h
				mov	dl, ds:expand_object_width
				mov	dh, 0
				sub	di, dx
				mov	ch, dl
				dec	cl
				jnz	short expand

locret_88D9:						    ; CODE XREF: expand_object+6Bj
							    ; expand_object+94j
				retn
; ---------------------------------------------------------------------------

run:							    ; CODE XREF: expand_object+25j
				mov	ah, [bx]
				and	ah, 7Fh
				inc	bx
				mov	al, [bx]

loc_88E2:						    ; CODE XREF: expand_object+6Fj
				and	al, al
				jz	short loc_88E8
				mov	[di], al

loc_88E8:						    ; CODE XREF: expand_object+53j
				inc	di
				dec	ch
				jnz	short loc_88FE
				add	di, 18h
				mov	dl, ds:expand_object_width
				mov	dh, 0
				sub	di, dx
				mov	ch, dl
				dec	cl
				jz	short locret_88D9

loc_88FE:						    ; CODE XREF: expand_object+5Aj
				dec	ah
				jnz	short loc_88E2
				inc	bx
				jmp	short expand
; ---------------------------------------------------------------------------

range:							    ; CODE XREF: expand_object+29j
				mov	ah, [bx]
				and	ah, 0Fh
				inc	bx
				mov	al, [bx]

loc_890D:						    ; CODE XREF: expand_object+98j
				mov	[di], al
				inc	di
				inc	al
				dec	ch
				jnz	short loc_8927
				add	di, 18h
				mov	dl, ds:expand_object_width
				mov	dh, 0
				sub	di, dx
				mov	ch, dl
				dec	cl
				jz	short locret_88D9

loc_8927:						    ; CODE XREF: expand_object+83j
				dec	ah
				jnz	short loc_890D
				inc	bx
				jmp	expand
expand_object			endp


; =============== S U B	R O U T	I N E =======================================


wassub_CB23			proc near		    ; CODE XREF: character_behaviour+39j
							    ; character_behaviour+61j ...

; FUNCTION CHUNK AT 8973 SIZE 00000012 BYTES

				push	bx
				call	wassub_C651
				cmp	al, 0FFh
				jnz	short wassub_CB61
				pop	bx
wassub_CB23			endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


wassub_CB2D			proc near		    ; CODE XREF: spawn_character+C9p
				cmp	bx, offset vischar_0.target ; Hero's visible character.
				jz	short loc_8953
				mov	al, [bp+0]
				and	al, 1Fh		    ; vischar_CHARACTER_MASK
				jnz	short nothero
				mov	al, [bx]
				and	al, 7Fh		    ; vischar_BYTE2_MASK
				cmp	al, 24h	; '$'
				jz	short loc_8953
				xor	al, al

nothero:						    ; CODE XREF: wassub_CB2D+Bj
				cmp	al, 0Ch		    ; character_12_GUARD_12
				jb	short loc_895F

loc_8953:						    ; CODE XREF: wassub_CB2D+4j
							    ; wassub_CB2D+13j
				push	bx
				call	character_event
				pop	bx
				mov	al, [bx]
				and	al, al
				jnz	short wassub_CB23
				retn
; ---------------------------------------------------------------------------

loc_895F:						    ; CODE XREF: wassub_CB2D+19j
				xor	byte ptr [bx], 80h
				test	byte ptr [bx], 80h
				jz	short loc_896D
				dec	byte ptr [bx+1]
				dec	byte ptr [bx+1]

loc_896D:						    ; CODE XREF: wassub_CB2D+2Dj
				inc	byte ptr [bx+1]
				xor	al, al
				retn
wassub_CB2D			endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR wassub_CB23

wassub_CB61:						    ; CODE XREF: wassub_CB23+6j
				cmp	al, 80h	; '€'
				jnz	short not128
				or	byte ptr [bp+1], 40h ; vischar_FLAGS_BIT6

not128:							    ; CODE XREF: wassub_CB23+46j
				pop	di
				inc	di
				inc	di
				mov	ax, [bx]
				mov	[di], ax
				mov	al, 80h	; '€'
				retn
; END OF FUNCTION CHUNK	FOR wassub_CB23

; =============== S U B	R O U T	I N E =======================================


element_A_of_table_7738		proc near		    ; CODE XREF: character_behaviour+1C4p
							    ; wassub_C651+19p
				xor	ah, ah
				shl	al, 1
				mov	bx, offset table_7738
				add	bx, ax
				mov	dx, [bx]
				retn
element_A_of_table_7738		endp


; =============== S U B	R O U T	I N E =======================================


wassub_C651			proc near		    ; CODE XREF: wassub_A3BB+Dp
							    ; move_characters:targetxnonzerop ...
				mov	al, [bx]
				cmp	al, 0FFh
				jnz	short loc_89A6
				inc	bx
				and	byte ptr [bx], 0F8h
				call	random_nibble
				and	al, 7
				add	al, [bx]
				mov	[bx], al
				jmp	short loc_89DD
; ---------------------------------------------------------------------------

loc_89A6:						    ; CODE XREF: wassub_C651+4j
				push	bx
				inc	bx
				mov	cl, [bx]
				call	element_A_of_table_7738
				mov	bh, 0
				mov	bl, cl
				cmp	bl, 0FFh
				jnz	short loc_89B8
				dec	bh

loc_89B8:						    ; CODE XREF: wassub_C651+23j
				add	bx, dx
				mov	al, [bx]
				cmp	al, 0FFh
				mov	si, bx
				pop	bx
				jz	short loc_89E9
				and	al, 7Fh
				cmp	al, 28h	; '('
				jnb	short loc_89D9
				mov	al, [si]
				test	byte ptr [bx], 80h
				jz	short loc_89D2
				xor	al, 80h

loc_89D2:						    ; CODE XREF: wassub_C651+3Dj
				call	get_door_position
				inc	bx
				mov	al, 80h	; '€'
				retn
; ---------------------------------------------------------------------------

loc_89D9:						    ; CODE XREF: wassub_C651+36j
				mov	al, [si]
				sub	al, 28h	; '('

loc_89DD:						    ; CODE XREF: wassub_C651+13j
				xor	ah, ah
				shl	al, 1
				mov	bx, offset locations
				add	bx, ax
				xor	al, al
				retn
; ---------------------------------------------------------------------------

loc_89E9:						    ; CODE XREF: wassub_C651+30j
				mov	al, 0FFh
				retn
wassub_C651			endp

; ---------------------------------------------------------------------------
prng_pointer			dw offset rooms_and_tunnels ; DATA XREF: random_nibble+1r
							    ; random_nibble+Bw

; =============== S U B	R O U T	I N E =======================================


random_nibble			proc near		    ; CODE XREF: wassub_C651+Ap
				push	bx
				mov	bx, ds:prng_pointer
				inc	bl
				mov	al, [bx]
				and	al, 0Fh
				mov	ds:prng_pointer, bx
				pop	bx
				retn
random_nibble			endp


; =============== S U B	R O U T	I N E =======================================


mask_stuff			proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+Fp
							    ; locate_vischar_or_itemstruct_then_plot+31p
				push	ds
				pop	es
				cld			    ; Clear the	mask buffer with 0xFF.
				mov	ax, 0FFFFh
				mov	di, offset mask_buffer ; Mask buffer.
				mov	cx, 50h	; 'P'       ; = 0xA0 / 2
				rep stosw
				test	ds:room_index, 0FFh
				jz	short outdoors

indoors:
				mov	bx, offset interior_mask_data_count
				mov	ch, [bx]
				and	ch, ch
				jz	short exit	    ; exit - mask count	was zero
				inc	bx
				jmp	short cont
; ---------------------------------------------------------------------------

outdoors:						    ; CODE XREF: mask_stuff+13j
				mov	ch, 59		    ; bug: too large by	one
				mov	bx, offset exterior_mask_data

cont:							    ; CODE XREF: mask_stuff+1Fj
							    ; mask_stuff+6Fj
				push	cx
				push	bx
				mov	al, ds:map_position_related.x
				dec	al
				cmp	al, [bx+2]
				jnb	short next
				add	al, 4
				cmp	al, [bx+1]
				jb	short next
				mov	al, ds:map_position_related.y
				dec	al
				cmp	al, [bx+4]
				jnb	short next
				add	al, 5
				cmp	al, [bx+3]
				jb	short next
				mov	al, ds:tinypos_stash.x
				cmp	al, [bx+5]
				jbe	short next
				mov	al, ds:tinypos_stash.y
				cmp	al, [bx+6]
				jb	short next
				mov	al, ds:tinypos_stash.height
				and	al, al
				jz	short loc_8A62
				dec	al

loc_8A62:						    ; CODE XREF: mask_stuff+5Fj
				cmp	al, [bx+7]
				jb	short clipping

next:							    ; CODE XREF: mask_stuff+30j
							    ; mask_stuff+37j ...
				pop	bx
				pop	cx
				add	bx, 8
				dec	ch
				jnz	short cont

exit:							    ; CODE XREF: mask_stuff+1Cj
				retn
; ---------------------------------------------------------------------------

clipping:						    ; CODE XREF: mask_stuff+66j
				mov	al, ds:map_position_related.x
				mov	cl, al
				cmp	al, [bx+1]
				jb	short loc_8A93
				sub	al, [bx+1]
				mov	ds:mask_stuff_x, al
				mov	al, [bx+2]
				sub	al, cl
				cmp	al, 3
				jb	short loc_8A8C
				mov	al, 3

loc_8A8C:						    ; CODE XREF: mask_stuff+89j
				inc	al
				mov	byte ptr ds:mask_stuff_height+1, al
				jmp	short loc_8AB7
; ---------------------------------------------------------------------------

loc_8A93:						    ; CODE XREF: mask_stuff+7Aj
				mov	ch, [bx+1]
				mov	ds:mask_stuff_x, 0
				mov	al, ch
				sub	al, cl
				mov	cl, al
				mov	al, 4
				sub	al, cl
				mov	cl, al
				mov	al, [bx+2]
				sub	al, ch
				inc	al
				cmp	al, cl
				jb	short loc_8AB4
				mov	al, cl

loc_8AB4:						    ; CODE XREF: mask_stuff+B1j
				mov	byte ptr ds:mask_stuff_height+1, al

loc_8AB7:						    ; CODE XREF: mask_stuff+92j
				mov	al, ds:map_position_related.y
				mov	cl, al
				cmp	al, [bx+3]
				jb	short loc_8AD9
				sub	al, [bx+3]
				mov	ds:mask_stuff_y, al
				mov	al, [bx+4]
				sub	al, cl
				cmp	al, 4
				jb	short loc_8AD2
				mov	al, 4

loc_8AD2:						    ; CODE XREF: mask_stuff+CFj
				inc	al
				mov	byte ptr ds:mask_stuff_height, al
				jmp	short loc_8AFD
; ---------------------------------------------------------------------------

loc_8AD9:						    ; CODE XREF: mask_stuff+C0j
				mov	ch, [bx+3]
				mov	ds:mask_stuff_y, 0
				mov	al, ch
				sub	al, cl
				mov	cl, al
				mov	al, 5
				sub	al, cl
				mov	cl, al
				mov	al, [bx+4]
				sub	al, ch
				inc	al
				cmp	al, cl
				jb	short loc_8AFA
				mov	al, cl

loc_8AFA:						    ; CODE XREF: mask_stuff+F7j
				mov	byte ptr ds:mask_stuff_height, al

loc_8AFD:						    ; CODE XREF: mask_stuff+D8j
				xor	cx, cx
				mov	al, ds:mask_stuff_y
				and	al, al
				jnz	short loc_8B10
				mov	al, ds:map_position_related.y
				neg	al
				add	al, [bx+3]
				mov	cl, al

loc_8B10:						    ; CODE XREF: mask_stuff+105j
				mov	al, ds:mask_stuff_x
				and	al, al
				jnz	short loc_8B21
				mov	al, ds:map_position_related.x
				neg	al
				add	al, [bx+1]
				mov	ch, al

loc_8B21:						    ; CODE XREF: mask_stuff+116j
				mov	al, cl
				cbw
				ror	al, 1
				ror	al, 1
				ror	al, 1
				add	al, ch
				add	ax, offset mask_buffer ; Mask buffer.
				mov	ds:mask_stuff_thing, ax
				mov	al, [bx]
				xor	ah, ah
				shl	ax, 1
				mov	bx, offset exterior_mask_data_pointers
				add	bx, ax
				mov	bx, [bx]
				mov	dx, ds:mask_stuff_height
				mov	byte ptr ds:loc_8B8E+1,	dl ; self-modify
				mov	byte ptr ds:loc_8B93+1,	dh ; self-modify
				mov	al, [bx]
				mov	dl, al
				sub	al, dh
				mov	byte ptr ds:loc_8BB8+1,	al ; self-modify
				mov	al, 20h	; ' '
				sub	al, dh
				mov	byte ptr ds:loc_8BE9+2,	al ; self-modify
				mov	al, ds:mask_stuff_y
				mul	dl
				mov	dx, ax
				mov	al, ds:mask_stuff_x
				xor	ah, ah
				add	dx, ax
				jz	short loc_8B81

loc_8B6B:						    ; CODE XREF: mask_stuff+17Bj
							    ; mask_stuff+180j
				inc	bx
				mov	al, [bx]
				and	al, al
				jns	short loc_8B7E
				and	al, 7Fh
				inc	bx
				cbw
				sub	dx, ax
				jb	short loc_8B86
				jnz	short loc_8B6B
				jmp	short loc_8B81
; ---------------------------------------------------------------------------

loc_8B7E:						    ; CODE XREF: mask_stuff+171j
				dec	dx
				jnz	short loc_8B6B

loc_8B81:						    ; CODE XREF: mask_stuff+16Aj
							    ; mask_stuff+17Dj
				inc	bx
				xor	al, al
				jmp	short loc_8B8A
; ---------------------------------------------------------------------------

loc_8B86:						    ; CODE XREF: mask_stuff+179j
				mov	al, dl
				neg	al

loc_8B8A:						    ; CODE XREF: mask_stuff+185j
				mov	di, ds:mask_stuff_thing

loc_8B8E:						    ; DATA XREF: mask_stuff+144w
				mov	ch, 1

loc_8B90:						    ; CODE XREF: mask_stuff+1F2j
				mov	cl, al
				push	cx

loc_8B93:						    ; DATA XREF: mask_stuff+148w
				mov	ch, 1

loc_8B95:						    ; CODE XREF: mask_stuff+1B7j
				mov	al, [bx]
				and	al, al
				jns	short loc_8BA2
				and	al, 7Fh
				mov	cl, al
				inc	bx
				mov	al, [bx]

loc_8BA2:						    ; CODE XREF: mask_stuff+19Aj
				and	al, al
				jz	short loc_8BA9
				call	mask_against_tile

loc_8BA9:						    ; CODE XREF: mask_stuff+1A5j
				inc	di
				and	cl, cl
				jz	short loc_8BB3
				dec	cl
				jz	short loc_8BB3
				dec	bx

loc_8BB3:						    ; CODE XREF: mask_stuff+1ADj
							    ; mask_stuff+1B1j
				inc	bx
				dec	ch
				jnz	short loc_8B95

loc_8BB8:						    ; DATA XREF: mask_stuff+152w
				mov	ch, 1
				and	ch, ch
				mov	al, cl
				jz	short loc_8BE9
				inc	bx
				and	cl, cl
				jnz	short loc_8BD2
				dec	bx

loc_8BC6:						    ; CODE XREF: mask_stuff+1DBj
							    ; mask_stuff+1E1j
				mov	al, [bx]
				inc	bx
				and	al, al
				jns	short loc_8BDE
				and	al, 7Fh
				mov	cl, al
				inc	bx

loc_8BD2:						    ; CODE XREF: mask_stuff+1C4j
				mov	al, ch
				sub	al, cl
				mov	ch, al
				jb	short loc_8BE6
				jnz	short loc_8BC6
				jmp	short loc_8BE9
; ---------------------------------------------------------------------------

loc_8BDE:						    ; CODE XREF: mask_stuff+1CCj
				dec	ch
				jnz	short loc_8BC6
				xor	al, al
				jmp	short loc_8BE9
; ---------------------------------------------------------------------------

loc_8BE6:						    ; CODE XREF: mask_stuff+1D9j
				dec	bx
				neg	al

loc_8BE9:						    ; CODE XREF: mask_stuff+1BFj
							    ; mask_stuff+1DDj ...
				add	di, 20h	; ' '
				pop	cx
				dec	ch
				jz	short loc_8BF3
				jmp	short loc_8B90
; ---------------------------------------------------------------------------

loc_8BF3:						    ; CODE XREF: mask_stuff+1F0j
				jmp	next
mask_stuff			endp


; =============== S U B	R O U T	I N E =======================================


mask_against_tile		proc near		    ; CODE XREF: mask_stuff+1A7p
				push	cx
				mov	si, offset exterior_tiles_0
				cbw
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				add	si, ax
				mov	cx, 8

loop:							    ; CODE XREF: mask_against_tile+16j
				lodsb
				and	[di], al
				add	di, 4
				loop	loop
				sub	di, 20h	; ' '
				pop	cx
				retn
mask_against_tile		endp


; =============== S U B	R O U T	I N E =======================================


setup_item_plotting		proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot:itemp
				and	al, 3Fh
				mov	ds:saved_item, al   ; Bug: This	writes to saved_item but it's never subsequently read from.
				mov	si, bp
				push	ds
				pop	es
				cld
				inc	si
				inc	si
				mov	di, offset tinypos_stash
				mov	cx, 5
				rep movsb
				mov	byte ptr [di], 0
				mov	si, offset item_definitions
				cbw
				shl	ax, 1
				add	si, ax
				shl	ax, 1
				add	si, ax
				inc	si
				mov	al, [si]
				mov	ds:item_height,	al
				inc	si
				mov	di, offset bitmap_pointer
				mov	cx, 2
				rep movsw
				call	item_visible
				jz	short invisible
				retn
; ---------------------------------------------------------------------------

invisible:						    ; CODE XREF: setup_item_plotting+35j
				push	cx
				mov	byte ptr ds:loc_83B5+1,	dl
				and	ch, ch
				jnz	short loc_8C58
				mov	al, 0AAh ; 'ª'
				jmp	short loc_8C5F
; ---------------------------------------------------------------------------

loc_8C58:						    ; CODE XREF: setup_item_plotting+3Fj
				mov	al, 47h	; 'G'
				neg	cl
				add	cl, 3

loc_8C5F:						    ; CODE XREF: setup_item_plotting+43j
				mov	bx, offset plotter_self_modified_addrs
				mov	ch, 3

loc_8C64:						    ; CODE XREF: setup_item_plotting+65j
				mov	di, [bx]
				inc	bx
				inc	bx
				mov	[di], al
				mov	di, [bx]
				inc	bx
				inc	bx
				mov	[di], al
				dec	cl
				jnz	short loc_8C76
				xor	al, 0EDh

loc_8C76:						    ; CODE XREF: setup_item_plotting+5Fj
				dec	ch
				jnz	short loc_8C64
				mov	bx, offset window_buf
				and	dh, dh
				jnz	short loc_8C93
				mov	ah, ds:map_position_related.y
				sub	ah, byte ptr ds:map_position+1
				xor	al, al
				shr	ax, 1
				add	bx, ax
				shr	ax, 1
				add	bx, ax

loc_8C93:						    ; CODE XREF: setup_item_plotting+6Cj
				mov	al, ds:map_position_related.x
				sub	al, byte ptr ds:map_position
				cbw
				add	bx, ax
				mov	ds:screen_pointer, bx
				mov	bx, offset mask_buffer ; Mask buffer.
				mov	al, dl
				cbw
				shl	ax, 1
				shl	ax, 1
				add	bx, ax
				mov	ds:foreground_mask_pointer, bx
				mov	al, dh
				cbw
				shl	al, 1
				add	ds:bitmap_pointer, ax
				add	ds:mask_pointer, ax
				pop	cx
				xor	al, al
				retn
setup_item_plotting		endp


; =============== S U B	R O U T	I N E =======================================


item_visible			proc near		    ; CODE XREF: setup_item_plotting+32p
				mov	bx, offset map_position_related
				mov	dx, ds:map_position
				mov	al, dl
				add	al, 18h
				sub	al, [bx]
				jbe	short invisible
				cmp	al, 3
				jnb	short loc_8CDB
				mov	ch, 0
				mov	cl, al
				jmp	short loc_8CF2
; ---------------------------------------------------------------------------

loc_8CDB:						    ; CODE XREF: item_visible+11j
				mov	al, [bx]
				add	al, 3
				sub	al, dl
				jbe	short invisible
				cmp	al, 3
				jnb	short loc_8CEF
				mov	cl, al
				mov	ch, 3
				sub	ch, cl
				jmp	short loc_8CF2
; ---------------------------------------------------------------------------

loc_8CEF:						    ; CODE XREF: item_visible+23j
				mov	cx, 3

loc_8CF2:						    ; CODE XREF: item_visible+17j
							    ; item_visible+2Bj
				mov	al, dh
				add	al, 11h
				inc	bx
				sub	al, [bx]
				jbe	short invisible
				cmp	al, 2
				jnb	short loc_8D05
				mov	dl, 8
				mov	dh, 0
				jmp	short visible
; ---------------------------------------------------------------------------

loc_8D05:						    ; CODE XREF: item_visible+3Bj
				mov	al, [bx]
				add	al, 2
				sub	al, dh
				jbe	short invisible
				mov	dl, ds:item_height
				xor	dh, dh
				cmp	al, 2
				jnb	short visible
				mov	dh, 8
				sub	dl, dh

visible:						    ; CODE XREF: item_visible+41j
							    ; item_visible+53j
				xor	al, al
				retn
; ---------------------------------------------------------------------------

invisible:						    ; CODE XREF: item_visible+Dj
							    ; item_visible+1Fj	...
				or	al, 1
				retn
item_visible			endp


; =============== S U B	R O U T	I N E =======================================


hostiles_persue			proc near		    ; CODE XREF: follow_suspicious_character+Cp
							    ; event_roll_call+36p ...
				mov	bx, offset vischar_1 ; NPC visible characters.
				mov	cx, 7

loop:							    ; CODE XREF: hostiles_persue+1Aj
				mov	al, [bx]
				cmp	al, 14h
				jnb	short loc_8D38
				mov	al, [bx+13h]
				cmp	al, 20h	; ' '
				jnb	short loc_8D38
				mov	byte ptr [bx+1], 1

loc_8D38:						    ; CODE XREF: hostiles_persue+Aj
							    ; hostiles_persue+11j
				add	bx, 20h	; ' '
				loop	loop
				retn
hostiles_persue			endp


; =============== S U B	R O U T	I N E =======================================


spawn_character			proc near		    ; CODE XREF: spawn_characters+63p
				test	byte ptr [bx], characterstruct_FLAG_DISABLED
				jnz	short locret_8D56
				push	bx
				mov	bx, offset vischar_1 ; NPC visible characters.
				mov	al, 0FFh
				mov	cx, 7

loop1:							    ; CODE XREF: spawn_character+15j
				cmp	al, [bx]
				jz	short loc_8D57
				add	bx, 20h	; ' '
				loop	loop1
				pop	bx

locret_8D56:						    ; CODE XREF: spawn_character+3j
							    ; spawn_character+51j
				retn
; ---------------------------------------------------------------------------

loc_8D57:						    ; CODE XREF: spawn_character+10j
				pop	si
				push	ds
				pop	es
				cld
				mov	bp, bx
				push	si
				inc	si
				mov	bx, offset saved_pos
				mov	al, [si]
				inc	si
				and	al, al
				mov	cx, 3
				jnz	short loc_8D7D

loop2:							    ; CODE XREF: spawn_character+3Bj
				lodsb
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				mov	[bx], ax
				inc	bx
				inc	bx
				loop	loop2
				jmp	short loc_8D86
; ---------------------------------------------------------------------------

loc_8D7D:						    ; CODE XREF: spawn_character+2Cj
				xor	ah, ah

loc_8D7F:						    ; CODE XREF: spawn_character+46j
				lodsb
				mov	[bx], ax
				inc	bx
				inc	bx
				loop	loc_8D7F

loc_8D86:						    ; CODE XREF: spawn_character+3Dj
				call	collision
				jnz	short loc_8D8E
				call	bounds_check

loc_8D8E:						    ; CODE XREF: spawn_character+4Bj
				pop	si
				jnz	short locret_8D56
				mov	al, [si]
				or	al, characterstruct_FLAG_DISABLED
				mov	[si], al
				and	al, 1Fh		    ; characterstruct_BYTE0_MASK
				mov	[bp+0],	al
				mov	byte ptr [bp+1], 0
				push	si
				mov	si, offset character_meta_data_commandant
				and	al, al
				jz	short loc_8DB9
				mov	si, offset character_meta_data_guard
				cmp	al, character_16_GUARD_DOG_1
				jb	short loc_8DB9
				mov	si, offset character_meta_data_dog
				cmp	al, character_20_PRISONER_1
				jb	short loc_8DB9
				mov	si, offset character_meta_data_prisoner

loc_8DB9:						    ; CODE XREF: spawn_character+68j
							    ; spawn_character+6Fj ...
				lodsw
				mov	[bp+8],	ax
				lodsw
				mov	[bp+15h], ax
				mov	di, bp
				add	di, 0Fh
				mov	si, offset saved_pos
				mov	cx, 3
				rep movsw
				pop	si
				add	si, 5
				mov	al, ds:room_index
				mov	[bp+1Ch], al
				and	al, al
				jz	short loc_8DE8
				mov	cx, sound_CHARACTER_ENTERS_2
				call	play_speaker
				mov	cx, sound_CHARACTER_ENTERS_1
				call	play_speaker

loc_8DE8:						    ; CODE XREF: spawn_character+9Cj
				mov	ax, [si]
				mov	[bp+2],	ax

loc_8DED:						    ; CODE XREF: spawn_character+CDj
				mov	al, [si]
				and	al, al
				jz	short loc_8E21
				mov	ds:entered_move_characters, 0
				mov	bx, si
				call	wassub_C651
				cmp	al, 0FFh
				jnz	short loc_8E0D
				mov	bx, bp
				add	bx, 2
				push	bx
				call	wassub_CB2D
				pop	si
				jmp	short loc_8DED
; ---------------------------------------------------------------------------

loc_8E0D:						    ; CODE XREF: spawn_character+C1j
				cmp	al, 80h	; '€'       ; vischar_FLAGS_BIT6
				jnz	short loc_8E15
				or	byte ptr [bp+1], 40h

loc_8E15:						    ; CODE XREF: spawn_character+D1j
				mov	si, bx
				mov	di, bp
				add	di, 4
				mov	cx, 3
				rep movsb

loc_8E21:						    ; CODE XREF: spawn_character+B3j
				mov	byte ptr [bp+7], 0
				mov	bx, bp
				call	reset_position
				call	character_behaviour
				retn
spawn_character			endp


; =============== S U B	R O U T	I N E =======================================


wipe_visible_tiles		proc near		    ; CODE XREF: screen_resetp
							    ; choose_game_window_attributes+31p ...
				push	ds
				pop	es
				cld
				xor	ax, ax
				mov	di, offset tile_buf
				mov	cx, 0CCh ; 'Ì'
				rep stosw
				retn
wipe_visible_tiles		endp


; =============== S U B	R O U T	I N E =======================================


is_item_discoverable		proc near		    ; CODE XREF: follow_suspicious_character+41p
				mov	al, ds:room_index
				and	al, al
				jz	short exterior
				call	is_item_discoverable_interior
				jnz	short exit
				call	hostiles_persue

exit:							    ; CODE XREF: is_item_discoverable+Aj
				retn
; ---------------------------------------------------------------------------

exterior:						    ; CODE XREF: is_item_discoverable+5j
				mov	bx, offset item_structs
				mov	cx, 10h

loop:							    ; CODE XREF: is_item_discoverable+1Fj
				test	byte ptr [bx+1], 80h ; itemstruct_ROOM_FLAG_NEARBY_7
				jnz	short found

next:							    ; CODE XREF: is_item_discoverable+28j
							    ; is_item_discoverable+2Cj
				add	bx, 7
				loop	loop		    ; itemstruct_ROOM_FLAG_NEARBY_7
				retn
; ---------------------------------------------------------------------------

found:							    ; CODE XREF: is_item_discoverable+1Aj
				mov	al, [bx]
				and	al, 0Fh		    ; itemstruct_ITEM_MASK
				cmp	al, 0Bh		    ; item_GREEN_KEY
				jz	short next
				cmp	al, 7		    ; item_FOOD
				jz	short next
				call	hostiles_persue
				retn
is_item_discoverable		endp


; =============== S U B	R O U T	I N E =======================================


is_item_discoverable_interior	proc near		    ; CODE XREF: move_characters+23p
							    ; is_item_discoverable+7p
				mov	ah, al
				mov	bx, offset item_structs
				mov	cx, item__LIMIT

loc_8E76:						    ; CODE XREF: is_item_discoverable_interior+2Aj
				mov	al, [bx+1]
				and	al, 3Fh
				cmp	al, ah
				jnz	short exit
				push	bx
				mov	al, [bx]
				and	al, 0Fh
				mov	bl, al
				shl	al, 1
				add	bl, al
				xor	bh, bh
				add	bx, offset default_item_locations
				cmp	ah, [bx]
				jnz	short found
				pop	bx

exit:							    ; CODE XREF: is_item_discoverable_interior+Fj
							    ; is_item_discoverable_interior+34j
				add	bx, 7
				loop	loc_8E76
				retn
; ---------------------------------------------------------------------------

found:							    ; CODE XREF: is_item_discoverable_interior+24j
				pop	bx
				mov	al, [bx]
				and	al, 0Fh
				cmp	al, item_RED_CROSS_PARCEL
				jz	short exit
				mov	cl, al
				xor	al, al
				retn
is_item_discoverable_interior	endp ; sp-analysis failed

; ---------------------------------------------------------------------------
plot_game_window_table		dw 0			    ; DATA XREF: plot_game_window+1Fo
							    ; plot_static_tiles_vertical+2Do ...
				dw 300h
				dw 0C00h
				dw 0F00h
				dw 3000h
				dw 3300h
				dw 3C00h
				dw 3F00h
				dw 0C000h
				dw 0C300h
				dw 0CC00h
				dw 0CF00h
				dw 0F000h
				dw 0F300h
				dw 0FC00h
				dw 0FF00h
				dw 3
				dw 303h
				dw 0C03h
				dw 0F03h
				dw 3003h
				dw 3303h
				dw 3C03h
				dw 3F03h
				dw 0C003h
				dw 0C303h
				dw 0CC03h
				dw 0CF03h
				dw 0F003h
				dw 0F303h
				dw 0FC03h
				dw 0FF03h
				dw 0Ch
				dw 30Ch
				dw 0C0Ch
				dw 0F0Ch
				dw 300Ch
				dw 330Ch
				dw 3C0Ch
				dw 3F0Ch
				dw 0C00Ch
				dw 0C30Ch
				dw 0CC0Ch
				dw 0CF0Ch
				dw 0F00Ch
				dw 0F30Ch
				dw 0FC0Ch
				dw 0FF0Ch
				dw 0Fh
				dw 30Fh
				dw 0C0Fh
				dw 0F0Fh
				dw 300Fh
				dw 330Fh
				dw 3C0Fh
				dw 3F0Fh
				dw 0C00Fh
				dw 0C30Fh
				dw 0CC0Fh
				dw 0CF0Fh
				dw 0F00Fh
				dw 0F30Fh
				dw 0FC0Fh
				dw 0FF0Fh
				dw 30h
				dw 330h
				dw 0C30h
				dw 0F30h
				dw 3030h
				dw 3330h
				dw 3C30h
				dw 3F30h
				dw 0C030h
				dw 0C330h
				dw 0CC30h
				dw 0CF30h
				dw 0F030h
				dw 0F330h
				dw 0FC30h
				dw 0FF30h
				dw 33h
				dw 333h
				dw 0C33h
				dw 0F33h
				dw 3033h
				dw 3333h
				dw 3C33h
				dw 3F33h
				dw 0C033h
				dw 0C333h
				dw 0CC33h
				dw 0CF33h
				dw 0F033h
				dw 0F333h
				dw 0FC33h
				dw 0FF33h
				dw 3Ch
				dw 33Ch
				dw 0C3Ch
				dw 0F3Ch
				dw 303Ch
				dw 333Ch
				dw 3C3Ch
				dw 3F3Ch
				dw 0C03Ch
				dw 0C33Ch
				dw 0CC3Ch
				dw 0CF3Ch
				dw 0F03Ch
				dw 0F33Ch
				dw 0FC3Ch
				dw 0FF3Ch
				dw 3Fh
				dw 33Fh
				dw 0C3Fh
				dw 0F3Fh
				dw 303Fh
				dw 333Fh
				dw 3C3Fh
				dw 3F3Fh
				dw 0C03Fh
				dw 0C33Fh
				dw 0CC3Fh
				dw 0CF3Fh
				dw 0F03Fh
				dw 0F33Fh
				dw 0FC3Fh
				dw 0FF3Fh
				dw 0C0h
				dw 3C0h
				dw 0CC0h
				dw 0FC0h
				dw 30C0h
				dw 33C0h
				dw 3CC0h
				dw 3FC0h
				dw 0C0C0h
				dw 0C3C0h
				dw 0CCC0h
				dw 0CFC0h
				dw 0F0C0h
				dw 0F3C0h
				dw 0FCC0h
				dw 0FFC0h
				dw 0C3h
				dw 3C3h
				dw 0CC3h
				dw 0FC3h
				dw 30C3h
				dw 33C3h
				dw 3CC3h
				dw 3FC3h
				dw 0C0C3h
				dw 0C3C3h
				dw 0CCC3h
				dw 0CFC3h
				dw 0F0C3h
				dw 0F3C3h
				dw 0FCC3h
				dw 0FFC3h
				dw 0CCh
				dw 3CCh
				dw 0CCCh
				dw 0FCCh
				dw 30CCh
				dw 33CCh
				dw 3CCCh
				dw 3FCCh
				dw 0C0CCh
				dw 0C3CCh
				dw 0CCCCh
				dw 0CFCCh
				dw 0F0CCh
				dw 0F3CCh
				dw 0FCCCh
				dw 0FFCCh
				dw 0CFh
				dw 3CFh
				dw 0CCFh
				dw 0FCFh
				dw 30CFh
				dw 33CFh
				dw 3CCFh
word_9017			dw 3FCFh
				dw 0C0CFh
				dw 0C3CFh
				dw 0CCCFh
				dw 0CFCFh
				dw 0F0CFh
				dw 0F3CFh
				dw 0FCCFh
				dw 0FFCFh
				dw 0F0h
				dw 3F0h
				dw 0CF0h
				dw 0FF0h
				dw 30F0h
				dw 33F0h
				dw 3CF0h
				dw 3FF0h
				dw 0C0F0h
				dw 0C3F0h
				dw 0CCF0h
				dw 0CFF0h
				dw 0F0F0h
				dw 0F3F0h
				dw 0FCF0h
				dw 0FFF0h
				dw 0F3h
				dw 3F3h
				dw 0CF3h
				dw 0FF3h
				dw 30F3h
				dw 33F3h
				dw 3CF3h
				dw 3FF3h
				dw 0C0F3h
				dw 0C3F3h
				dw 0CCF3h
				dw 0CFF3h
				dw 0F0F3h
				dw 0F3F3h
				dw 0FCF3h
				dw 0FFF3h
				dw 0FCh
				dw 3FCh
				dw 0CFCh
				dw 0FFCh
				dw 30FCh
				dw 33FCh
				dw 3CFCh
				dw 3FFCh
				dw 0C0FCh
				dw 0C3FCh
				dw 0CCFCh
				dw 0CFFCh
				dw 0F0FCh
				dw 0F3FCh
				dw 0FCFCh
				dw 0FFFCh
				dw 0FFh
				dw 3FFh
				dw 0CFFh
				dw 0FFFh
				dw 30FFh
				dw 33FFh
				dw 3CFFh
				dw 3FFFh
				dw 0C0FFh
				dw 0C3FFh
				dw 0CCFFh
				dw 0CFFFh
				dw 0F0FFh
				dw 0F3FFh
				dw 0FCFFh
				dw 0FFFFh

; =============== S U B	R O U T	I N E =======================================


draw_all_items			proc near		    ; CODE XREF: reset_game_continued+33p
							    ; accept_bribe+28p	...
				mov	di, offset unk_1916 ; screenaddr_item1
				mov	al, byte ptr ds:items_held
				call	draw_item
				mov	di, offset unk_191C ; screenaddr_item2
				mov	al, byte ptr ds:items_held+1
				call	draw_item
				retn
draw_all_items			endp


; =============== S U B	R O U T	I N E =======================================


draw_item			proc near		    ; CODE XREF: draw_all_items+6p
							    ; draw_all_items+Fp
				push	ax
				push	di
				mov	ch, 2
				mov	cl, 10h
				call	screen_wipe
				pop	di
				pop	ax
				cmp	al, 0FFh
				jnz	short loc_90CC
				retn
; ---------------------------------------------------------------------------

loc_90CC:						    ; CODE XREF: draw_item+Dj
				mov	bx, offset item_attributes
				cbw
				add	bx, ax
				mov	cl, [bx]
				mov	bx, offset item_definitions
				shl	ax, 1
				add	bx, ax
				shl	ax, 1
				add	bx, ax
				mov	al, cl
				mov	ch, [bx]
				mov	cl, [bx+1]
				mov	si, [bx+2]
				call	plot_bitmap
				retn
draw_item			endp


; =============== S U B	R O U T	I N E =======================================


setup_vischar_plotting		proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plot+Ap
				push	ds
				pop	es
				cld
				mov	bx, bp
				add	bx, 0Fh
				mov	si, bx
				mov	di, offset tinypos_stash
				mov	al, ds:room_index
				and	al, al
				jz	short loc_9109
				movsb
				inc	si
				movsb
				inc	si
				movsb
				inc	si
				jmp	short loc_911E
; ---------------------------------------------------------------------------

loc_9109:						    ; CODE XREF: setup_vischar_plotting+12j
				mov	cx, 3
				mov	ax, [si]
				add	ax, 4

loc_9111:						    ; CODE XREF: setup_vischar_plotting+2Fj
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				stosb
				inc	si
				inc	si
				mov	ax, [si]
				loop	loc_9111

loc_911E:						    ; CODE XREF: setup_vischar_plotting+1Aj
				mov	cx, [si]
				push	cx
				inc	si
				inc	si
				mov	al, [si]
				mov	ds:flip_sprite,	al
				inc	si
				mov	cx, 2

loc_912C:						    ; CODE XREF: setup_vischar_plotting+47j
				lodsw
				shr	ax, 1
				shr	ax, 1
				shr	ax, 1
				stosb
				loop	loc_912C
				pop	di
				mov	al, ds:flip_sprite
				xor	ah, ah
				shl	al, 1
				add	di, ax
				shl	ax, 1
				add	di, ax
				inc	si
				inc	si
				xchg	di, si
				movsw
				mov	di, offset bitmap_pointer
				movsw
				movsw
				call	vischar_visible
				and	al, al
				jz	short loc_9156
				retn
; ---------------------------------------------------------------------------

loc_9156:						    ; CODE XREF: setup_vischar_plotting+66j
				push	cx
				push	dx
				mov	al, [bp+1Eh]
				cmp	al, 3
				jnz	short loc_916E
				mov	byte ptr ds:loc_83B5+1,	dl
				mov	byte ptr ds:loc_8468+1,	dl
				mov	al, 3
				mov	bx, offset plotter_self_modified_addrs
				jmp	short loc_917B
; ---------------------------------------------------------------------------

loc_916E:						    ; CODE XREF: setup_vischar_plotting+70j
				mov	byte ptr ds:loc_8209+1,	dl
				mov	byte ptr ds:loc_82CF+1,	dl
				mov	al, 4
				mov	bx, (offset plotter_self_modified_addrs+0Ch)

loc_917B:						    ; CODE XREF: setup_vischar_plotting+7Fj
				mov	byte ptr ds:loc_9192+1,	al
				mov	dl, al
				and	ch, ch
				jnz	short loc_918A
				mov	ah, 0AAh ; 'ª'
				mov	al, cl
				jmp	short loc_9190
; ---------------------------------------------------------------------------

loc_918A:						    ; CODE XREF: setup_vischar_plotting+95j
				mov	ah, 47h	; 'G'
				mov	al, dl
				sub	al, cl

loc_9190:						    ; CODE XREF: setup_vischar_plotting+9Bj
				mov	cl, al

loc_9192:						    ; DATA XREF: setup_vischar_plotting:loc_917Bw
				mov	ch, 3

loop:							    ; CODE XREF: setup_vischar_plotting+BCj
				mov	di, [bx]
				inc	bx
				inc	bx
				mov	[di], ah
				mov	di, [bx]
				inc	bx
				inc	bx
				mov	[di], ah
				dec	cl
				jnz	short loc_91A7
				xor	ah, 0EDh

loc_91A7:						    ; CODE XREF: setup_vischar_plotting+B5j
				dec	ch
				jnz	short loop
				and	dh, dh
				mov	dx, 0
				jnz	short loc_91CE
				mov	al, byte ptr ds:map_position+1
				xor	ah, ah
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				mov	bx, [bp+1Ah]
				sub	bx, ax
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				mov	dx, bx
				shl	bx, 1
				add	dx, bx

loc_91CE:						    ; CODE XREF: setup_vischar_plotting+C3j
				mov	al, ds:map_position_related.x
				mov	bx, offset map_position
				sub	al, [bx]
				cbw
				mov	bx, offset window_buf
				add	bx, dx
				add	bx, ax
				mov	ds:screen_pointer, bx
				mov	bx, offset mask_buffer ; Mask buffer.
				pop	dx
				push	dx
				mov	al, dh
				xor	ah, ah
				shl	al, 1
				shl	al, 1
				add	bx, ax
				mov	al, [bp+1Ah]
				and	al, 7
				cbw
				shl	ax, 1
				shl	ax, 1
				add	bx, ax
				mov	ds:foreground_mask_pointer, bx
				pop	dx
				mov	al, dh
				and	al, al
				jz	short loc_9215
				xor	al, al
				mov	dl, [bp+1Eh]
				dec	dl

loc_920F:						    ; CODE XREF: setup_vischar_plotting+126j
				add	al, dl
				dec	dh
				jnz	short loc_920F

loc_9215:						    ; CODE XREF: setup_vischar_plotting+119j
				xor	ah, ah
				add	ds:bitmap_pointer, ax
				add	ds:mask_pointer, ax
				pop	cx
				xor	ah, ah
				retn
setup_vischar_plotting		endp


; =============== S U B	R O U T	I N E =======================================


process_player_input_fire	proc near		    ; CODE XREF: process_player_input+93p
				cmp	al, input_UP_FIRE
				jnz	short loc_922B
				call	pick_up_item
				retn
; ---------------------------------------------------------------------------

loc_922B:						    ; CODE XREF: process_player_input_fire+2j
				cmp	al, input_DOWN_FIRE
				jnz	short loc_9233
				call	drop_item
				retn
; ---------------------------------------------------------------------------

loc_9233:						    ; CODE XREF: process_player_input_fire+Aj
				cmp	al, input_LEFT_FIRE
				jnz	short loc_923B
				call	use_item_A
				retn
; ---------------------------------------------------------------------------

loc_923B:						    ; CODE XREF: process_player_input_fire+12j
				cmp	al, input_RIGHT_FIRE
				jnz	short exit
				call	use_item_B

exit:							    ; CODE XREF: process_player_input_fire+1Aj
							    ; DATA XREF: seg000:9272o ...
				retn
process_player_input_fire	endp


; =============== S U B	R O U T	I N E =======================================


use_item_B			proc near		    ; CODE XREF: process_player_input_fire+1Cp
				mov	al, byte ptr ds:items_held+1
				jmp	short use_item_common
use_item_B			endp


; =============== S U B	R O U T	I N E =======================================


use_item_A			proc near		    ; CODE XREF: process_player_input_fire+14p
				mov	al, byte ptr ds:items_held

use_item_common:					    ; CODE XREF: use_item_B+3j
				cmp	al, 0FFh
				jnz	short haveitem
				retn
; ---------------------------------------------------------------------------

haveitem:						    ; CODE XREF: use_item_A+5j
				add	al, al
				cbw
				mov	bx, offset item_actions_jump_table
				add	bx, ax
				mov	bx, [bx]
				push	bx
				push	ds
				pop	es
				cld
				mov	di, offset saved_pos
				mov	si, offset vischar_0.mi	; Hero's visible character.
				mov	cx, 3
				rep movsw
				retn
use_item_A			endp ; sp-analysis failed

; ---------------------------------------------------------------------------
item_actions_jump_table		dw offset action_wiresnips  ; DATA XREF: use_item_A+Bo
				dw offset action_shovel
				dw offset action_lockpick
				dw offset action_papers
				dw offset exit
				dw offset action_bribe
				dw offset action_uniform
				dw offset exit
				dw offset action_poison
				dw offset action_red_key
				dw offset action_yellow_key
				dw offset action_green_key
				dw offset action_red_cross_parcel
				dw offset exit
				dw offset exit
				dw offset exit

; =============== S U B	R O U T	I N E =======================================


pick_up_item			proc near		    ; CODE XREF: process_player_input_fire+4p
				mov	bx, ds:items_held
				mov	al, item_NONE
				cmp	bl, al
				jz	short have_spare_slot
				cmp	bh, al

loc_9296:
				jz	short have_spare_slot
				retn
; ---------------------------------------------------------------------------

have_spare_slot:					    ; CODE XREF: pick_up_item+8j
							    ; pick_up_item:loc_9296j
				call	find_nearby_item
				jz	short founditem
				retn
; ---------------------------------------------------------------------------

founditem:						    ; CODE XREF: pick_up_item+12j
				mov	si, offset items_held
				mov	al, [si]
				cmp	al, item_NONE
				jz	short loc_92A9
				inc	si

loc_92A9:						    ; CODE XREF: pick_up_item+1Cj
				mov	al, [bx]
				and	al, 1Fh
				mov	[si], al
				push	bx
				mov	al, ds:room_index
				or	al, al
				jnz	short loc_92BC
				call	plot_all_tiles

loc_92BA:
				jmp	short loc_92C5
; ---------------------------------------------------------------------------

loc_92BC:						    ; CODE XREF: pick_up_item+2Bj
				call	setup_room
				call	plot_interior_tiles

loc_92C2:
				call	choose_game_window_attributes

loc_92C5:						    ; CODE XREF: pick_up_item:loc_92BAj
				pop	bx

loc_92C6:						    ; itemstruct_ITEM_FLAG_HELD
				test	byte ptr [bx], 80h
				jnz	short loc_92D3	    ; itemstruct->room_and_flags
				or	byte ptr [bx], 80h
				push	bx
				call	increase_morale_by_5_score_by_5
				pop	bx

loc_92D3:						    ; CODE XREF: pick_up_item+3Fj
				mov	byte ptr [bx+1], 0  ; itemstruct->room_and_flags
				mov	byte ptr [bx+5], 0
				mov	byte ptr [bx+6], 0
				call	draw_all_items

loc_92E2:
				mov	cx, sound_PICK_UP_ITEM
				call	play_speaker
				retn
pick_up_item			endp


; =============== S U B	R O U T	I N E =======================================


drop_item			proc near		    ; CODE XREF: process_player_input_fire+Cp

; FUNCTION CHUNK AT 934B SIZE 00000013 BYTES

				mov	al, byte ptr ds:items_held
				cmp	al, 0FFh
				jnz	short loc_92F1
				retn
; ---------------------------------------------------------------------------

loc_92F1:						    ; CODE XREF: drop_item+5j
				cmp	al, item_UNIFORM
				jnz	short loc_92FC
				mov	bx, offset sprite_prisoner_facing_away_4
				mov	ds:vischar_0.mi.sprite,	bx ; Hero's visible character.

loc_92FC:						    ; CODE XREF: drop_item+Aj
				push	ax
				mov	bx, offset items_held
				mov	al, [bx+1]
				mov	byte ptr [bx+1], 0FFh
				mov	[bx], al
				call	draw_all_items
				mov	cx, sound_DROP_ITEM
				call	play_speaker
				call	choose_game_window_attributes
				pop	ax

drop_item_tail:						    ; CODE XREF: action_red_cross_parcel+18p
				call	item_to_itemstruct
				inc	bx
				mov	al, ds:room_index
				mov	[bx], al
				and	al, al
				jnz	short loc_934B
				inc	bx
				mov	di, bx
				mov	si, offset vischar_0.mi	; Hero's visible character.
				call	pos_to_tinypos
				dec	di
				mov	byte ptr [di], 0
				mov	bx, di
drop_item			endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


calc_exterior_item_screenpos	proc near		    ; CODE XREF: item_discovered+42p
				sub	bx, 2
				mov	ax, 40h	; '@'
				add	al, [bx+1]
				sub	al, [bx]
				shl	al, 1
				sub	ah, [bx]
				sub	ah, [bx+1]
				sub	ah, [bx+2]
				mov	[bx+3],	ax
				retn
calc_exterior_item_screenpos	endp

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR drop_item

loc_934B:						    ; CODE XREF: drop_item+38j
				inc	bx
				mov	si, offset vischar_0.mi	; Hero's visible character.
				mov	al, [si]
				mov	[bx], al
				inc	bx
				inc	si
				inc	si
				mov	al, [si]
				mov	[bx], al
				inc	bx
				mov	byte ptr [bx], 5
; END OF FUNCTION CHUNK	FOR drop_item

; =============== S U B	R O U T	I N E =======================================


calc_interior_item_screenpos	proc near		    ; CODE XREF: item_discovered+4Bp
				sub	bx, 2
				mov	dh, 2
				mov	dl, [bx+1]
				mov	cl, [bx]
				xor	ch, ch
				sub	dx, cx
				add	dx, 2
				shr	dx, 1
				shr	dx, 1
				mov	[bx+3],	dl
				mov	dx, 800h
				mov	cl, [bx]
				sub	dx, cx
				mov	cl, [bx+1]
				sbb	dx, cx
				mov	cl, [bx+2]
				sbb	dx, cx
				add	dx, 4
				shr	dx, 1
				shr	dx, 1
				shr	dx, 1
				mov	[bx+4],	dl
				retn
calc_interior_item_screenpos	endp


; =============== S U B	R O U T	I N E =======================================


item_to_itemstruct		proc near		    ; CODE XREF: event_new_red_cross_parcel+11p
							    ; item_discovered+22p ...
				and	al, 0Fh
				cbw
				mov	bx, offset item_structs
				add	bx, ax
				shl	ax, 1
				add	bx, ax
				shl	ax, 1
				add	bx, ax
				retn
item_to_itemstruct		endp


; =============== S U B	R O U T	I N E =======================================


find_nearby_item		proc near		    ; CODE XREF: pick_up_item:have_spare_slotp
				mov	ah, 1
				mov	al, ds:room_index
				and	al, al
				jz	short exterior	    ; item__LIMIT
				mov	ah, 6

exterior:						    ; CODE XREF: find_nearby_item+7j
				mov	cx, 10h		    ; item__LIMIT
				mov	bx, offset item_structs.room_and_flags ; &item_structs[0].room

foreachitem:						    ; CODE XREF: find_nearby_item+3Ej
				test	byte ptr [bx], 80h  ; itemstruct_ROOM_FLAG_NEARBY_7
				jz	short next
				push	cx
				push	bx
				inc	bx
				mov	si, offset hero_map_position
				mov	cx, 2

loop:							    ; CODE XREF: find_nearby_item+31j
				mov	al, [si]
				sub	al, ah
				cmp	al, [bx]
				jnb	short popnext
				add	al, ah
				add	al, ah
				cmp	al, [bx]
				jb	short popnext
				inc	bx
				inc	si
				loop	loop
				pop	bx
				dec	bx
				pop	cx
				xor	al, al
				retn
; ---------------------------------------------------------------------------

popnext:						    ; CODE XREF: find_nearby_item+25j
							    ; find_nearby_item+2Dj
				pop	bx
				pop	cx

next:							    ; CODE XREF: find_nearby_item+14j
				add	bx, 7
				loop	foreachitem	    ; itemstruct_ROOM_FLAG_NEARBY_7
				or	al, 1
				retn
find_nearby_item		endp

; ---------------------------------------------------------------------------
zoombox_x			db 0Ch			    ; DATA XREF: zoomboxw
							    ; zoombox:loopo ...
zoombox_horizontal_count	db 1			    ; DATA XREF: zoombox+Fw
							    ; zoombox+4Eo ...
zoombox_y			db 8			    ; DATA XREF: zoombox+5w
							    ; zoombox_fill+11r	...
zoombox_vertical_count		db 1			    ; DATA XREF: zoombox+12w
							    ; zoombox_fill+53r	...

; =============== S U B	R O U T	I N E =======================================


zoombox				proc near		    ; CODE XREF: enter_room+1Ep
							    ; screen_reset+Bp ...
				mov	ds:zoombox_x, 0Ch
				mov	ds:zoombox_y, 8
				call	choose_game_window_attributes
				xor	al, al
				mov	ds:zoombox_horizontal_count, al
				mov	ds:zoombox_vertical_count, al

loop:							    ; CODE XREF: zoombox+58j
				mov	bx, offset zoombox_x
				mov	al, [bx]
				cmp	al, 1
				jz	short loc_9411
				dec	byte ptr [bx]
				dec	al
				inc	byte ptr [bx+1]

loc_9411:						    ; CODE XREF: zoombox+1Cj
				add	al, [bx+1]
				cmp	al, 16h
				jnb	short loc_941B
				inc	byte ptr [bx+1]

loc_941B:						    ; CODE XREF: zoombox+2Aj
				mov	al, [bx+2]
				cmp	al, 1
				jz	short loc_942A
				dec	byte ptr [bx+2]
				dec	al
				inc	byte ptr [bx+3]

loc_942A:						    ; CODE XREF: zoombox+34j
				add	al, [bx+3]
				cmp	al, 0Fh
				jnb	short loc_9434
				inc	byte ptr [bx+3]

loc_9434:						    ; CODE XREF: zoombox+43j
				call	zoombox_fill
				call	zoombox_draw_border
				mov	bx, offset zoombox_horizontal_count
				mov	al, [bx+2]
				add	al, [bx]
				cmp	al, 23h	; '#'
				jb	short loop
				retn
zoombox				endp


; =============== S U B	R O U T	I N E =======================================


zoombox_fill			proc near		    ; CODE XREF: zoombox:loc_9434p
				mov	al, ds:game_window_attribute
				mov	bx, offset plot_game_window_masks
				and	al, 0Fh
				xlat
				mov	bl, al
				mov	bh, al
				mov	word ptr ds:loc_94BD+1,	bx
				mov	ah, ds:zoombox_y
				xor	al, al
				mov	di, ax
				shr	ax, 1
				mov	bx, ax
				shr	ax, 1
				add	bx, ax
				add	di, ax
				add	di, 296h
				mov	al, ds:zoombox_x
				cbw
				add	bx, ax
				add	bx, 6E5h
				shl	ax, 1
				add	di, ax
				push	es
				mov	ax, 0B800h
				mov	es, ax
				assume es:nothing
				cld
				mov	al, ds:zoombox_horizontal_count
				mov	ah, al
				shl	al, 1
				neg	al
				add	al, 50h	; 'P'
				mov	byte ptr ds:loc_94CA+2,	al
				mov	al, ah
				neg	al
				add	al, 18h
				mov	byte ptr ds:loc_94C5+2,	al
				mov	cl, ds:zoombox_vertical_count
				shl	cl, 1
				shl	cl, 1
				shl	cl, 1
				push	bp
				mov	bp, offset plot_game_window_table
				mov	dx, di
				xor	dx, 2000h

loc_94AE:						    ; CODE XREF: zoombox_fill+86j
				mov	ch, ds:zoombox_horizontal_count

loc_94B2:						    ; CODE XREF: zoombox_fill+7Cj
				mov	al, [bx]
				inc	bx
				xor	ah, ah
				shl	ax, 1
				mov	si, ax
				mov	ax, [bp+si]

loc_94BD:						    ; DATA XREF: zoombox_fill+Dw
				and	ax, 0FFFFh
				stosw
				dec	ch
				jnz	short loc_94B2

loc_94C5:						    ; DATA XREF: zoombox_fill+50w
				add	bx, 0
				xchg	di, dx

loc_94CA:						    ; DATA XREF: zoombox_fill+47w
				add	dx, 0
				loop	loc_94AE
				pop	bp
				pop	es
				assume es:nothing
				retn
zoombox_fill			endp


; =============== S U B	R O U T	I N E =======================================


zoombox_draw_border		proc near		    ; CODE XREF: zoombox+4Bp
				mov	ah, ds:zoombox_y
				dec	ah
				xor	al, al
				mov	di, ax
				shr	ax, 1
				shr	ax, 1
				add	di, ax
				add	di, 296h
				mov	ch, 0
				mov	al, ds:zoombox_x
				dec	al
				cbw
				shl	ax, 1
				add	di, ax
				mov	al, 0
				call	zoombox_draw_tile
				mov	cl, ds:zoombox_horizontal_count

loc_94FB:						    ; CODE XREF: zoombox_draw_border+30j
				inc	di
				inc	di
				mov	al, 1
				call	zoombox_draw_tile
				loop	loc_94FB
				inc	di
				inc	di
				mov	al, 2
				call	zoombox_draw_tile
				mov	cl, ds:zoombox_vertical_count

loc_950F:						    ; CODE XREF: zoombox_draw_border+46j
				add	di, 140h
				mov	al, 3
				call	zoombox_draw_tile
				loop	loc_950F
				add	di, 140h
				mov	al, 4
				call	zoombox_draw_tile
				dec	di
				dec	di
				mov	cl, ds:zoombox_horizontal_count

loc_9529:						    ; CODE XREF: zoombox_draw_border+5Ej
				mov	al, 1
				call	zoombox_draw_tile
				dec	di
				dec	di
				loop	loc_9529
				mov	al, 5
				call	zoombox_draw_tile
				sub	di, 140h
				mov	cl, ds:zoombox_vertical_count

loc_953F:						    ; CODE XREF: zoombox_draw_border+76j
				mov	al, 3
				call	zoombox_draw_tile
				sub	di, 140h
				loop	loc_953F
				retn
zoombox_draw_border		endp


; =============== S U B	R O U T	I N E =======================================


zoombox_draw_tile		proc near		    ; CODE XREF: zoombox_draw_border+22p
							    ; zoombox_draw_border+2Dp ...
				push	cx
				push	di
				cbw
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				mov	si, ax
				add	si, offset zoombox_tiles
				mov	cx, 108h
				mov	al, ds:game_window_attribute
				call	plot_bitmap
				pop	di
				pop	cx
				retn
zoombox_draw_tile		endp

; ---------------------------------------------------------------------------
zoombox_tiles			db	  0,	   0,	    0,	     3,	      4,       8,	8,	 8; 0
							    ; DATA XREF: zoombox_draw_tile+Bo
				db	  0,	 20h,	  18h,	  0F4h,	    2Fh,     18h,	4,	 0; 8
				db	  0,	   0,	    0,	     0,	   0E0h,     10h,	8,	 8; 16
				db	  8,	   8,	  1Ah,	   2Ch,	    34h,     58h,     10h,     10h; 24
				db	10h,	 10h,	  10h,	   20h,	   0C0h,       0,	0,	 0; 32
				db	10h,	 10h,	    8,	     7,	      0,       0,	0,	 0; 40

; =============== S U B	R O U T	I N E =======================================


plot_interior_tiles		proc near		    ; CODE XREF: wake_up+69p
							    ; breakfast_time+66p ...
				mov	di, offset window_buf
				mov	si, offset tile_buf
				push	ds
				pop	es
				cld
				mov	cl, 16		    ; rows

outerloop:						    ; CODE XREF: plot_interior_tiles+38j
				mov	ch, 24		    ; columns

innerloop:						    ; CODE XREF: plot_interior_tiles+32j
				mov	al, [si]
				mov	dx, si
				mov	ah, 0
				shl	ax, 1
				shl	ax, 1
				shl	ax, 1
				mov	si, offset interior_tiles
				add	si, ax
				push	cx
				mov	cx, 8		    ; copy the tile

innerinnerloop:						    ; CODE XREF: plot_interior_tiles+26j
				movsb			    ; *es++ = *ds++
				add	di, 23
				loop	innerinnerloop	    ; *es++ = *ds++
				mov	si, dx
				inc	si
				sub	di, 191
				pop	cx
				dec	ch
				jnz	short innerloop
				add	di, 168		    ; 7	* 24
				loop	outerloop	    ; columns
				retn
plot_interior_tiles		endp


; =============== S U B	R O U T	I N E =======================================


reset_visible_character		proc near		    ; CODE XREF: purge_visible_characters+61p
							    ; transition+2Fp ...
				mov	al, [bx]
				cmp	al, 0FFh
				jnz	short loc_95D8
				retn
; ---------------------------------------------------------------------------

loc_95D8:						    ; CODE XREF: reset_visible_character+4j
				push	ds
				pop	es
				cld
				cmp	al, 1Ah
				jb	short loc_9605
				mov	byte ptr [bx], 0FFh
				mov	byte ptr [bx+1], 0FFh
				mov	byte ptr [bx+7], 0
				mov	di, offset movable_item_stove1
				cmp	al, character_26_STOVE_1 ; movable item
				jz	short loc_95FB
				mov	di, offset movable_item_stove2
				cmp	al, 1Bh
				jz	short loc_95FB
				mov	di, offset movable_item_crate

loc_95FB:						    ; CODE XREF: reset_visible_character+1Ej
							    ; reset_visible_character+25j
				mov	si, bx
				add	si, 0Fh
				mov	cx, 3
				movsw
				retn
; ---------------------------------------------------------------------------

loc_9605:						    ; CODE XREF: reset_visible_character+Cj
				mov	si, bx
				call	get_character_struct ; in: AL =	character index
							    ; out: BX =	character struct
				mov	di, bx
				and	byte ptr [di], 0BFh ; was ~characterstruct_FLAG_DISABLED
				mov	al, [si+1Ch]
				inc	di
				mov	[di], al
				mov	byte ptr [si+7], 0
				add	si, 0Fh
				inc	di
				and	al, al
				jnz	short loc_9626
				call	pos_to_tinypos
				jmp	short loc_962D
; ---------------------------------------------------------------------------

loc_9626:						    ; CODE XREF: reset_visible_character+4Ej
				mov	cx, 3

loc_9629:						    ; CODE XREF: reset_visible_character+5Aj
				movsb
				inc	si
				loop	loc_9629

loc_962D:						    ; CODE XREF: reset_visible_character+53j
				sub	si, 15h
				mov	al, [si]
				mov	byte ptr [si], 0FFh
				inc	si
				mov	byte ptr [si], 0FFh
				inc	si
				cmp	al, 10h
				jb	short loc_9651
				cmp	al, 14h
				jnb	short loc_9651
				mov	byte ptr [si], 0FFh
				mov	byte ptr [si+1], 0
				cmp	al, 12h
				jb	short loc_9651
				mov	byte ptr [si+1], 18h

loc_9651:						    ; CODE XREF: reset_visible_character+6Bj
							    ; reset_visible_character+6Fj ...
				movsw
				retn
reset_visible_character		endp


; =============== S U B	R O U T	I N E =======================================


action_papers			proc near		    ; DATA XREF: seg000:9270o
				mov	dx, 696Dh	    ; map_MAIN_GATE_X
				mov	bx, offset hero_map_position
				mov	cx, 2

loop:							    ; CODE XREF: action_papers+17j
				mov	al, [bx]
				cmp	al, dh
				jb	short exit
				cmp	al, dl
				jnb	short exit
				inc	bx
				mov	dx, 494Bh	    ; map_MAIN_GATE_Y
				loop	loop
				mov	dx, offset sprite_guard_facing_away_4
				mov	al, byte ptr ds:vischar_0.mi.sprite ; hero's sprite
				cmp	al, dl
				jnz	short solitary
				call	increase_morale_by_10_score_by_50
				xor	al, al
				mov	ds:vischar_0.room, al ;	hero's room index
				mov	bx, offset outside_main_gate
				mov	si, offset vischar_0 ; Hero's visible character.
				jmp	transition
; ---------------------------------------------------------------------------

exit:							    ; CODE XREF: action_papers+Dj
							    ; action_papers+11j
				retn
action_papers			endp

; ---------------------------------------------------------------------------
outside_main_gate		tinypos	<214, 138, 6>	    ; DATA XREF: action_papers+2Bo
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR character_behaviour

solitary:						    ; CODE XREF: character_behaviour:gotosolitaryj
							    ; collision+8Cj ...
				mov	al, 0FFh
				mov	ds:bell, al
				mov	bx, offset items_held
				mov	cl, [bx]
				mov	[bx], al
				call	item_discovered
				mov	bx, (offset items_held+1)
				mov	cl, [bx]
				mov	byte ptr [bx], 0FFh
				call	item_discovered
				call	draw_all_items
				mov	cx, 10h
				mov	si, offset item_structs

loc_96AE:						    ; CODE XREF: character_behaviour+42E8j
				push	cx
				push	si
				test	byte ptr [si+1], 3Fh
				jnz	short loc_96D4
				mov	ah, [si]
				inc	si
				inc	si
				xor	al, al

loc_96BC:						    ; CODE XREF: character_behaviour+42D8j
				push	ax
				push	si
				call	within_camp_bounds
				jz	short loc_96CD
				pop	si
				pop	ax
				inc	al
				cmp	al, 3
				jnz	short loc_96BC
				jmp	short loc_96D4
; ---------------------------------------------------------------------------

loc_96CD:						    ; CODE XREF: character_behaviour+42D0j
				pop	dx
				pop	ax
				mov	cl, ah
				call	item_discovered

loc_96D4:						    ; CODE XREF: character_behaviour+42C3j
							    ; character_behaviour+42DAj
				pop	si
				pop	cx
				add	si, 7
				loop	loc_96AE
				mov	ds:vischar_0.room, room_24_SOLITARY ; Hero's visible character.
				mov	al, 14h
				mov	ds:current_door, 14h
				mov	ch, 23h	; '#'
				call	decrease_morale
				call	reset_map_and_characters
				push	ds
				pop	es
				cld
				mov	di, (offset character_structs+1)
				mov	si, offset solitary_hero_reset_data
				mov	cx, 3
				rep movsw
				mov	ch, message_YOU_ARE_IN_SOLITARY
				call	queue_message_for_display
				mov	ch, message_WAIT_FOR_RELEASE
				call	queue_message_for_display
				mov	ch, message_ANOTHER_DAY_DAWNS
				call	queue_message_for_display
				mov	al, 0FFh
				mov	byte ptr ds:morale_1_2,	al
				xor	al, al
				mov	ds:automatic_player_counter, al
				mov	bx, offset sprite_prisoner_facing_away_4
				mov	ds:vischar_0.mi.sprite,	bx ; Hero's visible character.
				mov	bx, offset solitary_pos
				mov	bp, offset vischar_0 ; Hero's visible character.
				mov	byte ptr [bp+0Eh], 3
				xor	al, al
				mov	ds:vischar_0.target.x, al ; Hero's visible character.
				call	transition
				retn
; END OF FUNCTION CHUNK	FOR character_behaviour
; ---------------------------------------------------------------------------
solitary_hero_reset_data	db 0			    ; DATA XREF: character_behaviour+4304o
							    ; room_0_OUTDOORS
				tinypos	<116, 100, 3>
				dw 24h			    ; target
locate_scratch			dw 0			    ; DATA XREF: locate_vischar_or_itemstruct+6o
							    ; scratch words replace banked regs	on speccy version
				dw 0

; =============== S U B	R O U T	I N E =======================================


locate_vischar_or_itemstruct	proc near		    ; CODE XREF: locate_vischar_or_itemstruct_then_plotp
				mov	cx, 8
				mov	si, offset vischar_0 ; Hero's visible character.
				mov	di, offset locate_scratch
				xor	ax, ax
				mov	[di], ax
				mov	[di+2],	ax
				dec	al

loop:							    ; CODE XREF: locate_vischar_or_itemstruct+41j
				test	byte ptr [si+7], 80h
				jz	short next
				mov	bx, [si+0Fh]
				add	bx, 4
				cmp	bx, [di]
				jb	short next
				mov	dx, [si+11h]
				add	dx, 4
				cmp	dx, [di+2]
				jb	short next
				sub	bx, 4
				mov	[di], bx
				sub	dx, 4
				mov	[di+2],	dx
				mov	al, 8
				sub	al, cl
				mov	bp, si

next:							    ; CODE XREF: locate_vischar_or_itemstruct+16j
							    ; locate_vischar_or_itemstruct+20j	...
				add	si, 20h	; ' '
				loop	loop
				call	get_greatest_itemstruct
				test	al, 80h
				jnz	short exit
				mov	bx, bp
				test	al, 40h
				jnz	short loc_9791
				and	byte ptr [bx+7], 7Fh
				xor	ah, ah
				retn
; ---------------------------------------------------------------------------

loc_9791:						    ; CODE XREF: locate_vischar_or_itemstruct+4Ej
				and	byte ptr [bx+1], 0BFh
				xor	ah, ah

exit:							    ; CODE XREF: locate_vischar_or_itemstruct+48j
				retn
locate_vischar_or_itemstruct	endp


; =============== S U B	R O U T	I N E =======================================


get_greatest_itemstruct		proc near		    ; CODE XREF: locate_vischar_or_itemstruct+43p
				mov	cx, item__LIMIT
				mov	si, offset item_structs

loop:							    ; CODE XREF: get_greatest_itemstruct+41j
				test	byte ptr [si+1], 80h
				jz	short next
				test	byte ptr [si+1], 40h
				jz	short next
				xor	bh, bh
				mov	bl, [si+2]
				shl	bx, 1
				shl	bx, 1
				shl	bx, 1
				cmp	bx, [di]
				jbe	short next
				xor	dh, dh
				mov	dl, [si+3]
				shl	dx, 1
				shl	dx, 1
				shl	dx, 1
				cmp	dx, [di+2]
				jbe	short next
				mov	[di], bx
				mov	[di+2],	dx
				mov	bp, si
				mov	al, 10h
				sub	al, cl
				or	al, 40h

next:							    ; CODE XREF: get_greatest_itemstruct+Aj
							    ; get_greatest_itemstruct+10j ...
				add	si, 7
				loop	loop
				retn
get_greatest_itemstruct		endp


; =============== S U B	R O U T	I N E =======================================


screenlocstring_plot		proc near		    ; CODE XREF: user_confirm+Fp
							    ; plot_menu_text+7p ...
				mov	di, [bx]	    ; di = address
				inc	bx
				inc	bx
				mov	cl, [bx]	    ; cx = count
				mov	ch, 0
				inc	bx

loop:							    ; CODE XREF: screenlocstring_plot+Fj
				push	cx
				call	plot_glyph
				inc	bx
				pop	cx
				loop	loop
				retn
screenlocstring_plot		endp


; =============== S U B	R O U T	I N E =======================================

; di ->	where to plot
; bx ->	glyph

plot_glyph			proc near		    ; CODE XREF: message_display+1Fp
							    ; message_display+52p ...
				mov	al, [bx]
				cmp	al, 20h	; ' '       ; space?
				jnz	short notspace	    ; full stop?
				mov	al, 0		    ; use glyph	0
				jmp	short plot
; ---------------------------------------------------------------------------

notspace:						    ; CODE XREF: plot_glyph+4j
				cmp	al, 2Eh	; '.'       ; full stop?
				jnz	short notfullstop   ; 0?
				mov	al, 1		    ; use glyph	1
				jmp	short plot
; ---------------------------------------------------------------------------

notfullstop:						    ; CODE XREF: plot_glyph+Cj
				cmp	al, 30h	; '0'       ; 0?
				jb	short exit
				cmp	al, 3Ah	; ':'       ; colon?

loc_9806:
				jnb	short loc_980C
				sub	al, 2Eh	; '.'
				jmp	short plot
; ---------------------------------------------------------------------------

loc_980C:						    ; CODE XREF: plot_glyph:loc_9806j
				and	al, 5Fh
				sub	al, 35h	; '5'

plot:							    ; CODE XREF: plot_glyph+8j
							    ; plot_glyph+10j ...
				cbw
				push	si
				mov	si, ax		    ; glyph id
				shl	si, 1		    ; inlined multiply_by_8
				shl	si, 1
				shl	si, 1
				add	si, 982Ch	    ; font base
				push	di
				mov	al, 7
				mov	cx, 108h
				call	plot_bitmap
				pop	di
				inc	di
				inc	di
				pop	si

exit:							    ; CODE XREF: plot_glyph+14j
				retn
plot_glyph			endp

; ---------------------------------------------------------------------------
bitmap_font			db    0,   0,	0,   0,	  0,   0,   0,	 0
				db    0,   0,	0,   0,	  0,   0, 30h, 30h
				db    0, 7Ch,0FEh,0EEh,0EEh,0EEh,0FEh, 7Ch
				db    0, 1Eh, 3Eh, 6Eh,	0Eh, 0Eh, 0Eh, 0Eh
				db    0, 7Ch,0FEh,0CEh,	1Ch, 70h,0FEh,0FEh
				db    0,0FCh,0FEh, 0Eh,	3Ch, 0Eh,0FEh,0FCh
				db    0, 0Eh, 1Eh, 3Eh,	6Eh,0FEh, 0Eh, 0Eh
				db    0,0FCh,0C0h,0FCh,	7Eh, 0Eh,0FEh,0FCh
				db    0, 38h, 60h,0FCh,0FEh,0C6h,0FEh, 7Ch
				db    0,0FEh, 0Eh, 0Eh,	1Ch, 1Ch, 38h, 38h
				db    0, 7Ch,0EEh,0EEh,	7Ch,0EEh,0EEh, 7Ch
				db    0, 7Ch,0FEh,0C6h,0FEh, 7Eh, 0Ch, 38h
				db    0, 38h, 7Ch, 7Ch,0EEh,0EEh,0FEh,0EEh
				db    0,0FCh,0EEh,0EEh,0FCh,0EEh,0EEh,0FCh
				db    0, 1Eh, 7Eh,0FEh,0F0h,0FEh, 7Eh, 1Eh
				db    0,0F0h,0FCh,0EEh,0EEh,0EEh,0FCh,0F0h
				db    0,0FEh,0FEh,0E0h,0FEh,0E0h,0FEh,0FEh
				db    0,0FEh,0FEh,0E0h,0FCh,0E0h,0E0h,0E0h
				db    0, 1Eh, 7Eh,0F0h,0EEh,0F2h, 7Eh, 1Eh
				db    0,0EEh,0EEh,0EEh,0FEh,0EEh,0EEh,0EEh
				db    0, 38h, 38h, 38h,	38h, 38h, 38h, 38h
				db    0,0FEh, 38h, 38h,	38h, 38h,0F8h,0F0h
				db    0,0EEh,0EEh,0FCh,0F8h,0FCh,0EEh,0EEh
				db    0,0E0h,0E0h,0E0h,0E0h,0E0h,0FEh,0FEh
				db    0, 6Ch,0FEh,0FEh,0D6h,0D6h,0C6h,0C6h
				db    0,0E6h,0F6h,0FEh,0FEh,0EEh,0E6h,0E6h
				db    0, 7Ch,0FEh,0EEh,0EEh,0EEh,0FEh, 7Ch
				db    0,0FCh,0EEh,0EEh,0EEh,0FCh,0E0h,0E0h
				db    0, 7Ch,0FEh,0EEh,0EEh,0EEh,0FCh, 7Eh
				db    0,0FCh,0EEh,0EEh,0FCh,0F8h,0ECh,0EEh
				db    0, 7Eh,0FEh,0F0h,	7Ch, 1Eh,0FEh,0FCh
				db    0,0FEh,0FEh, 38h,	38h, 38h, 38h, 38h
				db    0,0EEh,0EEh,0EEh,0EEh,0EEh,0FEh, 7Ch
				db    0,0EEh,0EEh,0EEh,0EEh, 6Ch, 7Ch, 38h
				db    0,0C6h,0C6h,0C6h,0D6h,0FEh,0EEh,0C6h
				db    0,0C6h,0EEh, 7Ch,	38h, 7Ch,0EEh,0C6h
				db    0,0C6h,0EEh, 7Ch,	38h, 38h, 38h, 38h
				db    0,0FEh,0FEh, 0Eh,	38h,0E0h,0FEh,0FEh
				db    0, 10h, 38h, 7Ch,0BAh, 38h, 38h, 38h
				db    0, 38h, 38h, 38h,0BAh, 7Ch, 38h, 10h
				db    0, 10h,	8,0FCh,0FEh,0FCh,   8, 10h
				db    0,   8, 10h, 3Fh,	7Fh, 3Fh, 10h,	 8

; =============== S U B	R O U T	I N E =======================================


setup_movable_items		proc near		    ; CODE XREF: enter_room+1Bp
							    ; reset_outdoors+31p
				call	reset_nonplayer_visible_characters
				mov	al, ds:room_index
				cmp	al, 2		    ; room_2_HUT2LEFT
				jnz	short notstove1	    ; room_4_HUT3LEFT
				call	setup_stove1
				jmp	short notcrate
; ---------------------------------------------------------------------------

notstove1:						    ; CODE XREF: setup_movable_items+8j
				cmp	al, 4		    ; room_4_HUT3LEFT
				jnz	short notstove2	    ; room_9_CRATE
				call	setup_stove2
				jmp	short notcrate
; ---------------------------------------------------------------------------

notstove2:						    ; CODE XREF: setup_movable_items+11j
				cmp	al, 9		    ; room_9_CRATE
				jnz	short notcrate
				call	setup_crate

notcrate:						    ; CODE XREF: setup_movable_items+Dj
							    ; setup_movable_items+16j ...
				call	spawn_characters
				call	mark_nearby_items
				call	called_from_main_loop_9
				call	move_map
				call	locate_vischar_or_itemstruct_then_plot
				retn
; ---------------------------------------------------------------------------

setup_crate:						    ; CODE XREF: setup_movable_items+1Cp
				mov	si, offset movable_item_crate
				mov	al, character_28_CRATE ; movable item
				jmp	short setup_movable_item
; ---------------------------------------------------------------------------

setup_stove2:						    ; CODE XREF: setup_movable_items+13p
				mov	si, offset movable_item_stove2
				mov	al, character_27_STOVE_2 ; movable item
				jmp	short setup_movable_item
; ---------------------------------------------------------------------------

setup_stove1:						    ; CODE XREF: setup_movable_items+Ap
				mov	si, offset movable_item_stove1
				mov	al, character_26_STOVE_1 ; movable item
setup_movable_items		endp ; sp-analysis failed


; =============== S U B	R O U T	I N E =======================================


setup_movable_item		proc near		    ; CODE XREF: setup_movable_items+34j
							    ; setup_movable_items+3Bj
				push	ds
				pop	es
				cld
				mov	ds:vischar_1.character,	al ; NPC visible characters.
				mov	cx, 9
				mov	di, offset vischar_1.mi	; NPC visible characters.
				rep movsb
				mov	si, 99E4h
				mov	di, offset vischar_1.flags ; NPC visible characters.
				mov	cx, 7
				rep movsw
				mov	al, ds:room_index
				mov	ds:vischar_1.room, al ;	NPC visible characters.
				mov	bx, offset vischar_1 ; NPC visible characters.
				call	reset_position
				retn
setup_movable_item		endp

; ---------------------------------------------------------------------------
movable_item_reset_data		db 0
				dw 0
				tinypos	<0>
				db 0
				dw offset character_related_pointers
				dw offset character_related_data_8
				db 0
				db 0
				db 0
movable_item_stove1		movableitem <<62, 35, 16>, offset sprite_stove,	0>
							    ; DATA XREF: reset_visible_character+19o
							    ; setup_movable_items:setup_stove1o
movable_item_crate		movableitem <<55, 54, 14>, offset sprite_crate,	0>
							    ; DATA XREF: reset_visible_character+27o
							    ; setup_movable_items:setup_crateo
movable_item_stove2		movableitem <<62, 35, 16>, offset sprite_stove,	0>
							    ; DATA XREF: reset_visible_character+20o
							    ; setup_movable_items:setup_stove2o

; =============== S U B	R O U T	I N E =======================================


reset_nonplayer_visible_characters proc	near		    ; CODE XREF: setup_movable_itemsp
				mov	bx, offset vischar_1 ; NPC visible characters.
				mov	cx, 7

loc_9A13:						    ; CODE XREF: reset_nonplayer_visible_characters+10j
				push	cx
				push	bx
				call	reset_visible_character
				pop	bx
				pop	cx
				add	bx, 20h	; ' '
				loop	loc_9A13
				retn
reset_nonplayer_visible_characters endp

; ---------------------------------------------------------------------------
static_tiles			db    0,   0,	0,   0,	  0,   0,   0,	 0,   7
							    ; DATA XREF: plot_static_tiles_vertical+19o
				db    0,   0,	0,   0,	  3,   4,   9, 0Ch,   6
				db    0,   0,	0,   0,0E0h, 50h, 10h, 58h,   6
				db    8, 0Ch,	9,   7,	  1,   0,   0,	 0,   6
				db  98h, 3Ch, 7Ch,0FBh,0FCh, 6Fh, 17h, 16h,   6
				db    0,   0,	0,   0,	  7, 0Ah,   8, 1Ch,   6
				db    0,   0,	0,   0,0C0h,0A0h, 10h, 50h,   6
				db  19h, 3Ch, 3Eh,0DFh,	3Fh,0F6h,0E8h, 68h,   6
				db  10h,0B0h, 10h,0E0h,	80h,   0,   0,	 0,   6
				db  68h,0E8h,0F6h, 3Fh,0DFh, 3Eh, 3Ch, 18h,   6
				db    0,   0,	0, 80h,0E0h, 90h, 30h, 90h,   6
				db  19h,   8, 0Ah,   7,	  0,   0,   0,	 0,   6
				db  30h, 10h, 20h,0C0h,	  0,   0,   0,	 0,   6
				db    0,   0,	0,   1,	  7,   8, 0Ch,	 9,   6
				db  16h, 17h, 6Fh,0FCh,0FBh, 7Ch, 3Ch, 18h,   6
				db  0Ch,   8,	5,   3,	  0,   0,   0,	 0,   6
				db  98h, 10h, 10h,0E0h,	  0,   0,   0,	 0,   6
				db  10h, 10h, 91h, 42h,	5Ah, 24h, 18h, 24h,   6
				db  18h, 24h, 52h, 52h,	91h, 10h, 10h, 10h,   6
				db  10h, 0Ch,	2,0FDh,	  1,   2, 0Ch, 10h,   6
				db    4, 18h,0A0h, 57h,	50h,0A0h, 18h,	 4,   6
				db    2,   1,	0,0FFh,	  0,   0,   1,	 2,   6
				db    0, 83h, 54h,0AAh,	2Ah, 54h, 83h,	 0,   6
				db  80h,   0,	0,0FFh,	  0,   0,   0, 80h,   6
				db    0,   0,	0,0FEh,	38h, 38h, 3Eh, 38h,   7
				db  3Ah, 3Ah, 3Ah, 3Ah,	3Ah, 3Ah, 3Ah, 3Ah,   7
				db  7Ch, 7Ch, 7Ch, 7Ch,	7Ch, 7Ch, 7Ch, 7Ch,   7
				db  7Ch, 7Ch, 7Ch, 7Ah,0B5h, 74h, 7Ah,0FBh,   7
				db    0,   0, 10h, 49h,	49h,0D5h,0D4h,0FDh,   4
				db    0,   0,	0, 42h,0A4h, 2Ah, 5Ah,0BDh,   4
				db    0,   0,	0,   0,	40h, 80h,0D0h,0A6h,   4
				db    0,   0,	0,   0,	0Ah, 24h, 55h,0DBh,   4
				db    0,   0,	0,   0,	1Fh,   8,   6,	 6,   3
				db    0,   0,	0,   0,0FFh,   0,0BAh,0BAh,   7
				db    0,   0,	0,   0,0FFh, 30h,0CEh,0CEh,   3
				db    0,   0,	0,   0,0FFh, 18h,0E6h,0E6h,   3
				db    0,   0,	0,   0,0FFh, 28h,0C6h,0C6h,   3
				db    0,   0,	0,   0,0F8h, 10h,0E0h,0E0h,   3
				db    6,   6,	6,   6,	  6,   6,   6,	 6,   3
				db 0CEh,0CEh,0CEh,0CEh,0CEh,0CEh,0CEh,0CEh,   3
				db 0E6h,0E6h,0E6h,0E6h,0E6h,0E6h,0E6h,0E6h,   3
				db 0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,   3
				db 0E0h,0E0h,0E0h,0E0h,0E0h,0E0h,0E0h,0E0h,   3
				db    6,   6,	6,   6,	  2,   4,   7,	 0,   3
				db    0,0BAh,0BAh,0BAh,0BAh,   0,0FFh, 10h,   7
				db 0CEh,0CEh,0CEh,0CEh,	86h, 48h,0CFh,	 0,   3
				db 0E6h,0E6h,0E6h,0E6h,0C2h, 24h,0E7h,	 0,   3
				db 0C6h,0C6h,0C6h,0C6h,	82h, 44h,0C7h,	 0,   3
				db 0E0h,0E0h,0E0h,0E0h,0C0h, 20h,0E0h,	 0,   3
				db    3,   2,	2,   2,	  2,   1,   2,	 2,   7
				db 0EFh, 38h,0FEh,0AAh,0B2h,0FFh, 96h,0A2h,   7
				db  80h, 81h, 83h, 87h,	86h, 0Eh, 8Eh, 86h,   6
				db  7Ch,0FFh,0C7h, 11h,0E0h, 72h, 5Ch,0A6h,   6
				db    0,   0, 81h,0C1h,0C3h,0E3h,0E3h,0C1h,   6
				db  38h,0FEh,0C7h,0ABh,	6Dh,   1, 6Dh,0ABh,   6
				db    0,   0,	0,   0,	8Ch, 8Fh, 8Bh,	 8,   5
				db 0FEh,0C6h, 6Ch, 6Ch,	28h, 39h,0D7h, 6Ch,   5
				db    0,   0,	0,   1,	61h,0E6h,0A6h, 26h,   4
				db  38h, 38h,0C6h,0BBh,	45h,0BAh,0BAh,0BAh,   4
				db    0,   0,	0,   0,	  0,0C0h,0C0h,0C0h,   4
				db    2,   2,	3,   0,	  0,   0,   0,	 0,   7
				db 0FEh, 10h,0EFh,   0,	  0,   0,   0,	 0,   7
				db  87h, 83h, 81h,   0,	  0,   0,   0,	 0,   6
				db  19h,0C7h,0FFh, 7Ch,	  0,   0,   0,	 0,   6
				db 0C1h, 80h,	0,   0,	  0,   0,   0,	 0,   6
				db 0C7h,0FEh, 38h,   0,	  0,   0,   0,	 0,   6
				db  0Bh, 0Fh, 0Ch,   0,	  0,   0,   0,	 0,   5
				db 0D7h, 39h, 28h, 6Ch,	6Ch,0C6h,0FEh,	 0,   5
				db 0A1h,0E1h, 60h,   0,	  0,   0,   0,	 0,   5
				db  45h,0BBh,0C6h, 38h,	38h,   0,   0,	 0,   4
				db    0,   0,	0,   1,	  3,   3,   6,	 6,   6
				db    0,   0, 7Eh,0FFh,	8Fh, 7Fh,0FFh,0FFh,   6
				db    0,   0,	0, 80h,0C0h,0C0h,0E0h,0E0h,   6
				db    6,0E7h,0E7h, 87h,	83h, 43h, 41h, 20h,   6
				db 0E7h,0E7h,0FFh,0FFh,0FEh,0F9h,0FFh, 7Eh,   6
				db 0E0h,0E0h, 60h, 60h,0C0h,0C0h, 80h,	 0,   6
				db  10h,   8,	4,   2,	  2,   1,   1,	 0,   6
				db  81h,0FFh,0E7h,0DBh,0DBh,0FFh, 81h,0FFh,   4
				db    0, 38h, 44h,0CAh,0D2h,0E2h, 7Ch, 38h, 47h
character_meta_data_commandant	dw offset character_related_pointers
							    ; DATA XREF: spawn_character+63o
				dw offset sprite_commandant_facing_away_4
character_meta_data_guard	dw offset character_related_pointers
							    ; DATA XREF: spawn_character+6Ao
				dw offset sprite_guard_facing_away_4
character_meta_data_dog		dw offset character_related_pointers
							    ; DATA XREF: spawn_character+71o
				dw offset sprite_dog_facing_away_1
character_meta_data_prisoner	dw offset character_related_pointers
							    ; DATA XREF: spawn_character+78o
				dw offset sprite_prisoner_facing_away_4
wasbyte_CDAA			db    8,   0,	4, 87h,	  0, 87h,   4,	 4,   4
							    ; DATA XREF: called_from_main_loop_9+D7o
				db    9, 84h,	5,   5,	84h,   5,   1,	 1,   5	; TL,TR,BR,BL, then same again for crawl
				db  0Ah, 85h,	2,   6,	85h,   6, 85h, 85h,   2
				db  0Bh,   7, 86h,   3,	  7,   3,   7,	 7, 86h
				db  14h, 0Ch, 8Ch, 93h,	0Ch, 93h, 10h, 10h, 8Ch
				db  15h, 90h, 11h, 8Dh,	90h, 95h, 0Dh, 0Dh, 11h
				db  16h, 8Eh, 0Eh, 12h,	8Eh, 0Eh, 91h, 91h, 0Eh
				db  17h, 13h, 92h, 0Fh,	13h, 0Fh, 8Fh, 8Fh, 92h
character_related_pointers	dw offset character_related_data_4; 0
							    ; DATA XREF: seg000:vischar_initialo
							    ; seg000:99EBo ...
				dw offset character_related_data_5; 1
				dw offset character_related_data_6; 2
				dw offset character_related_data_7; 3
				dw offset character_related_data_12; 4
				dw offset character_related_data_13; 5
				dw offset character_related_data_14; 6
				dw offset character_related_data_15; 7
				dw offset character_related_data_8; 8
				dw offset character_related_data_9; 9
				dw offset character_related_data_10; 10
				dw offset character_related_data_11; 11
				dw offset character_related_data_16; 12
				dw offset character_related_data_17; 13
				dw offset character_related_data_18; 14
				dw offset character_related_data_19; 15
				dw offset character_related_data_20; 16
				dw offset character_related_data_21; 17
				dw offset character_related_data_22; 18
				dw offset character_related_data_23; 19
				dw offset character_related_data_0; 20
				dw offset character_related_data_1; 21
				dw offset character_related_data_2; 22
				dw offset character_related_data_3; 23
sprite_stove			sprite <3, 22, offset bitmap_stove, offset mask_stove>
							    ; DATA XREF: seg000:movable_item_stove1o
							    ; seg000:movable_item_stove2o
sprite_crate			sprite <4, 24, offset bitmap_crate, offset mask_crate>
							    ; DATA XREF: seg000:movable_item_crateo
sprite_prisoner_facing_away_4	sprite <3, 27, offset bitmap_prisoner_facing_away_4, offset mask_various_facing_away_4>
							    ; DATA XREF: seg000:vischar_initialo
							    ; reset_game_continued+36o	...
sprite_prisoner_facing_away_3	sprite <3, 28, offset bitmap_prisoner_facing_away_3, offset mask_various_facing_away_3>
sprite_prisoner_facing_away_2	sprite <3, 28, offset bitmap_prisoner_facing_away_2, offset mask_various_facing_away_2>
sprite_prisoner_facing_away_1	sprite <3, 28, offset bitmap_prisoner_facing_away_1, offset mask_various_facing_away_1>
sprite_prisoner_facing_towards_1 sprite	<3, 27,	offset bitmap_prisoner_facing_towards_1, offset	mask_various_facing_towards_1>
sprite_prisoner_facing_towards_2 sprite	<3, 29,	offset bitmap_prisoner_facing_towards_2, offset	mask_various_facing_towards_2>
sprite_prisoner_facing_towards_3 sprite	<3, 28,	offset bitmap_prisoner_facing_towards_3, offset	mask_various_facing_towards_3>
sprite_prisoner_facing_towards_4 sprite	<3, 28,	offset bitmap_prisoner_facing_towards_4, offset	mask_various_facing_towards_4>
sprite_crawl_facing_towards_2	sprite <4, 16, offset bitmap_crawl_facing_towards_2, offset mask_crawl_facing_towards_shared>
sprite_crawl_facing_towards_1	sprite <4, 15, offset bitmap_crawl_facing_towards_1, offset mask_crawl_facing_towards_shared>
sprite_crawl_facing_away_1	sprite <4, 16, offset bitmap_crawl_facing_away_1, offset mask_crawl_facing_away_shared>
sprite_crawl_facing_away_2	sprite <4, 16, offset bitmap_crawl_facing_away_2, offset mask_crawl_facing_away_shared>
sprite_dog_facing_away_1	sprite <4, 16, offset bitmap_dog_facing_away_1,	offset mask_dog_facing_away_shared>
							    ; DATA XREF: seg000:9CF1o
sprite_dog_facing_away_2	sprite <4, 16, offset bitmap_dog_facing_away_2,	offset mask_dog_facing_away_shared>
sprite_dog_facing_away_3	sprite <4, 15, offset bitmap_dog_facing_away_3,	offset mask_dog_facing_away_shared>
sprite_dog_facing_away_4	sprite <4, 15, offset bitmap_dog_facing_away_4,	offset mask_dog_facing_away_shared>
sprite_dog_facing_towards_1	sprite <4, 14, offset bitmap_dog_facing_towards_1, offset mask_dog_facing_towards_shared>
sprite_dog_facing_towards_2	sprite <4, 15, offset bitmap_dog_facing_towards_2, offset mask_dog_facing_towards_shared>
sprite_dog_facing_towards_3	sprite <4, 15, offset bitmap_dog_facing_towards_3, offset mask_dog_facing_towards_shared>
sprite_dog_facing_towards_4	sprite <4, 14, offset bitmap_dog_facing_towards_4, offset mask_dog_facing_towards_shared>
sprite_guard_facing_away_4	sprite <3, 27, offset bitmap_guard_facing_away_4, offset mask_various_facing_away_4>
							    ; DATA XREF: action_uniform+3o
							    ; guards_follow_suspicious_character+Ao ...
sprite_guard_facing_away_3	sprite <3, 29, offset bitmap_guard_facing_away_3, offset mask_various_facing_away_3>
sprite_guard_facing_away_2	sprite <3, 27, offset bitmap_guard_facing_away_2, offset mask_various_facing_away_2>
sprite_guard_facing_away_1	sprite <3, 27, offset bitmap_guard_facing_away_1, offset mask_various_facing_away_1>
sprite_guard_facing_towards_1	sprite <3, 29, offset bitmap_guard_facing_towards_1, offset mask_various_facing_towards_1>
sprite_guard_facing_towards_2	sprite <3, 29, offset bitmap_guard_facing_towards_2, offset mask_various_facing_towards_2>
sprite_guard_facing_towards_3	sprite <3, 28, offset bitmap_guard_facing_towards_3, offset mask_various_facing_towards_3>
sprite_guard_facing_towards_4	sprite <3, 28, offset bitmap_guard_facing_towards_4, offset mask_various_facing_towards_4>
sprite_commandant_facing_away_4	sprite <3, 28, offset bitmap_commandant_facing_away_4, offset mask_various_facing_away_4>
							    ; DATA XREF: seg000:9CE9o
sprite_commandant_facing_away_3	sprite <3, 30, offset bitmap_commandant_facing_away_3, offset mask_various_facing_away_3>
sprite_commandant_facing_away_2	sprite <3, 29, offset bitmap_commandant_facing_away_2, offset mask_various_facing_away_2>
sprite_commandant_facing_away_1	sprite <3, 29, offset bitmap_commandant_facing_away_1, offset mask_various_facing_away_1>
sprite_commandant_facing_towards_1 sprite <3, 27, offset bitmap_commandant_facing_towards_1, offset mask_various_facing_towards_1>
sprite_commandant_facing_towards_2 sprite <3, 28, offset bitmap_commandant_facing_towards_2, offset mask_various_facing_towards_2>
sprite_commandant_facing_towards_2_0 sprite <3,	27, offset bitmap_commandant_facing_towards_3, offset mask_various_facing_towards_3>
sprite_commandant_facing_towards_4 sprite <3, 28, offset bitmap_commandant_facing_towards_4, offset mask_various_facing_towards_4>
character_related_data_0	db 1, 4, 4, 0FFh, 0, 0,	0, 0Ah
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_1	db 1, 5, 5, 0FFh, 0, 0,	0, 8Ah
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_2	db 1, 6, 6, 0FFh, 0, 0,	0, 88h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_3	db 1, 7, 7, 0FFh, 0, 0,	0, 8
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_4	db 4, 0, 0, 2, 2, 0, 0,	0, 2, 0, 0, 1, 2, 0, 0,	2, 2, 0, 0, 3
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_5	db 4, 1, 1, 3, 0, 2, 0,	80h, 0,	2, 0, 81h, 0, 2, 0, 82h, 0, 2, 0, 83h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_6	db 4, 2, 2, 0, 0FEh, 0,	0, 4, 0FEh, 0, 0, 5, 0FEh, 0, 0, 6, 0FEh, 0, 0,	7
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_7	db 4, 3, 3, 1, 0, 0FEh,	0, 84h,	0, 0FEh, 0, 85h, 0, 0FEh, 0, 86h, 0, 0FEh, 0, 87h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_8	db 1, 0, 0, 0FFh, 0, 0,	0, 0
							    ; DATA XREF: seg000:vischar_initialo
							    ; seg000:99EDo ...
character_related_data_9	db 1, 1, 1, 0FFh, 0, 0,	0, 80h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_10	db 1, 2, 2, 0FFh, 0, 0,	0, 4
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_11	db 1, 3, 3, 0FFh, 0, 0,	0, 84h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_12	db 2, 0, 1, 0FFh, 0, 0,	0, 0, 0, 0, 0, 80h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_13	db 2, 1, 2, 0FFh, 0, 0,	0, 80h,	0, 0, 0, 4
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_14	db 2, 2, 3, 0FFh, 0, 0,	0, 4, 0, 0, 0, 84h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_15	db 2, 3, 0, 0FFh, 0, 0,	0, 84h,	0, 0, 0, 0
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_16	db 2, 4, 4, 2, 2, 0, 0,	0Ah, 2,	0, 0, 0Bh
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_17	db 2, 5, 5, 3, 0, 2, 0,	8Ah, 0,	2, 0, 8Bh
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_18	db 2, 6, 6, 0, 0FEh, 0,	0, 88h,	0FEh, 0, 0, 89h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_19	db 2, 7, 7, 1, 0, 0FEh,	0, 8, 0, 0FEh, 0, 9
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_20	db 2, 4, 5, 0FFh, 0, 0,	0, 0Ah,	0, 0, 0, 8Ah
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_21	db 2, 5, 6, 0FFh, 0, 0,	0, 8Ah,	0, 0, 0, 88h
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_22	db 2, 6, 7, 0FFh, 0, 0,	0, 88h,	0, 0, 0, 8
							    ; DATA XREF: seg000:character_related_pointerso
character_related_data_23	db 2, 7, 4, 0FFh, 0, 0,	0, 8, 0, 0, 0, 0Ah
							    ; DATA XREF: seg000:character_related_pointerso
bitmap_commandant_facing_away_1	db 0, 0, 0, 60h, 0, 0F0h, 0, 0F8h, 0, 0FCh, 1, 7Ch, 1, 78h, 0, 4, 0, 0FEh, 3, 0FEh, 7, 0FAh
							    ; DATA XREF: seg000:sprite_commandant_facing_away_1o
				db 7, 0FAh, 6, 0FAh, 0Eh, 0F6h,	0Eh, 0C6h, 0Eh,	38h, 6,	0F8h, 6, 0E0h, 9, 98h, 4, 58h, 3
				db 0B0h, 3, 0B0h, 1, 80h, 2, 70h, 3, 0B0h, 1, 0B0h, 7, 0B0h, 1,	30h, 0,	20h
bitmap_commandant_facing_away_2	db 0, 0, 0, 60h, 0, 0F0h, 0, 0F8h, 0, 0FCh, 1, 7Ch, 1, 78h, 0, 0, 0, 0FCh, 3, 0FEh, 3, 0FAh
							    ; DATA XREF: seg000:sprite_commandant_facing_away_2o
				db 7, 0FAh, 6, 0F6h, 6,	0F6h, 0Eh, 0C6h, 0Dh, 3Ah, 15h,	0F8h, 1Bh, 0F6h, 3, 0C8h, 4, 18h
				db 7, 0D8h, 3, 80h, 2, 30h, 1, 0D0h, 1,	0C0h, 0, 0E0h, 1, 60h, 0, 60h, 0, 0C0h
bitmap_commandant_facing_away_3	db 0, 0, 0, 60h, 0, 0F0h, 0, 0F8h, 0, 0FCh, 1, 7Ch, 1, 78h, 0, 4, 1, 0FEh, 3, 0FEh, 7, 0FAh
							    ; DATA XREF: seg000:sprite_commandant_facing_away_3o
				db 7, 0FAh, 6, 0FAh, 6,	0F4h, 0Eh, 0CAh, 0Eh, 3Ah, 0Dh,	0F8h, 5, 0E0h, 0Bh, 98h, 4, 50h
				db 3, 0D0h, 7, 0A0h, 3,	0A0h, 3, 40h, 0, 0A0h, 3, 0B0h,	3, 0A0h, 1, 80h, 7, 80h, 1, 80h
bitmap_commandant_facing_away_4	db 0, 0, 0, 60h, 0, 0F0h, 0, 0F8h, 0, 0FCh, 1, 7Ch, 1, 78h, 0, 4, 0, 0FEh, 3, 0FEh, 7, 0FAh
							    ; DATA XREF: seg000:sprite_commandant_facing_away_4o
				db 6, 0FAh, 6, 0FAh, 7,	7Ah, 3,	64h, 7,	18h, 6,	0F8h, 0Ah, 0F0h, 0Dh, 0CCh, 2, 1Ch, 7, 0D8h
				db 7, 0D8h, 3, 0A0h, 4,	38h, 7,	0B8h, 3, 98h, 0Bh, 18h,	7, 30h
bitmap_commandant_facing_towards_1 db 0, 0, 1, 0C0h, 3,	0E0h, 7, 0C0h, 3, 0B0h,	0, 60h,	1, 80h,	6, 0B0h, 0Fh, 78h, 1Fh,	0A8h
							    ; DATA XREF: seg000:sprite_commandant_facing_towards_1o
				db 3Fh,	0B0h, 3Bh, 0B0h, 77h, 0A8h, 37h, 8Ch, 20h, 74h,	17h, 0B0h, 37h,	80h, 0Bh, 0A0h,	0Ch
				db 60h,	0Fh, 40h, 0Eh, 0, 1, 40h, 7, 40h, 7, 0,	7, 0, 3, 0, 3, 0C0h
bitmap_commandant_facing_towards_2 db 0, 0, 1, 0C0h, 3,	0E0h, 7, 0C0h, 3, 0B0h,	0, 60h,	1, 80h,	2, 0B0h, 0Fh, 68h, 1Fh,	0B0h
							    ; DATA XREF: seg000:sprite_commandant_facing_towards_2o
				db 1Fh,	0B0h, 1Bh, 0B0h, 3Bh, 0A8h, 3Bh, 88h, 34h, 70h,	37h, 0B0h, 37h,	0A8h, 7, 10h, 28h
				db 0B8h, 0Fh, 0B8h, 0Fh, 60h, 0Eh, 10h,	1, 70h,	0Eh, 70h, 0Eh, 60h, 0Ch, 38h, 0Eh, 0, 3
				db 0
bitmap_commandant_facing_towards_3 db 0, 0, 1, 0C0h, 3,	0E0h, 7, 0C0h, 3, 0B0h,	0, 60h,	1, 80h,	2, 0B0h, 7, 68h, 0Fh, 0B0h
							    ; DATA XREF: seg000:sprite_commandant_facing_towards_2_0o
				db 0Fh,	0B0h, 1Dh, 0B0h, 1Bh, 0A8h, 1Bh, 88h, 1Ch, 74h,	0Ah, 0B4h, 6, 0A0h, 9, 90h, 0Eh
				db 70h,	0Fh, 70h, 6, 0E0h, 8, 0, 1Eh, 0E0h, 1Ch, 0E0h, 18h, 0E0h, 18h, 60h, 8, 70h
bitmap_commandant_facing_towards_4 db 0, 0, 1, 0C0h, 3,	0E0h, 7, 0C0h, 3, 0B0h,	0, 60h,	1, 80h,	6, 0B0h, 0Fh, 68h, 1Fh,	0A8h
							    ; DATA XREF: seg000:sprite_commandant_facing_towards_4o
				db 1Fh,	0B0h, 3Bh, 0B0h, 3Bh, 0B0h, 3Bh, 88h, 30h, 70h,	37h, 0B0h, 0Fh,	0A8h, 37h, 10h,	8
				db 70h,	7, 60h,	3, 40h,	4, 0A0h, 7, 60h, 7, 40h, 6, 0C0h, 6, 80h, 3, 60h, 0, 60h
bitmap_prisoner_facing_away_1	db 0, 0, 0, 0F0h, 1, 0F0h, 1, 0C0h, 0, 0F0h, 1,	0, 0, 78h, 3, 0FCh, 7, 0F4h, 7,	0F4h, 6
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_1o
				db 0F4h, 0Eh, 0F4h, 0Dh, 0E8h, 0Dh, 94h, 0Ch, 78h, 15h,	0F8h, 1Bh, 0D8h, 7, 0D8h, 0Fh, 0B0h
				db 0Fh,	70h, 7,	70h, 7,	70h, 3,	60h, 3,	60h, 0Ch, 60h, 3, 0, 0,	60h
bitmap_prisoner_facing_away_2	db 0, 0, 0, 0F0h, 1, 0F0h, 1, 0C0h, 0, 0F0h, 1,	0, 0, 78h, 3, 0FCh, 7, 0F4h, 7,	0F4h, 0Fh
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_2o
				db 0ECh, 0Eh, 0ECh, 1Dh, 0ECh, 1Bh, 94h, 54h, 70h, 6Fh,	0F4h, 0Fh, 0D0h, 0Fh, 0D0h, 7, 0B0h
				db 7, 0A0h, 7, 0A0h, 7,	40h, 3,	40h, 3,	80h, 5,	80h, 0,	40h, 3,	0C0h
bitmap_prisoner_facing_away_3	db 0, 0, 0, 0F0h, 1, 0F0h, 1, 0C0h, 0, 0F0h, 1,	0, 0, 78h, 1, 0FCh, 3, 0F4h, 7,	0F4h, 6
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_3o
				db 0F4h, 6, 0F4h, 0Eh, 0E4h, 0Dh, 94h, 0Ch, 78h, 15h, 0F8h, 1Bh, 0D8h, 7, 0D8h,	0Fh, 0D0h
				db 7, 0D0h, 7, 0A0h, 7,	0A0h, 3, 0A0h, 3, 40h, 1, 60h, 6, 0, 3,	0
bitmap_prisoner_facing_away_4	db 0, 0, 0, 0F0h, 1, 0F0h, 1, 0C0h, 0, 0F0h, 1,	0, 0, 70h, 1, 0F8h, 3, 0F8h, 7,	0F8h, 6
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_4o
				db 0F0h, 0Eh, 0F0h, 0Eh, 0E8h, 6, 88h, 6, 70h, 2, 0F0h,	5, 0D0h, 6, 0D0h, 9, 0B0h, 0Fh,	0A0h
				db 0Fh,	60h, 0Eh, 0E0h,	0Eh, 0E0h, 0Ch,	40h, 34h, 20h, 18h, 0E0h
bitmap_prisoner_facing_towards_1 db 0, 0, 3, 80h, 5, 0C0h, 7, 80h, 4, 40h, 3, 80h, 0Dh,	60h, 1Eh, 0E0h,	3Eh, 0F0h, 37h,	50h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_1o
				db 35h,	50h, 77h, 50h, 6Fh, 38h, 6Eh, 54h, 51h,	0CCh, 5Fh, 0C0h, 9Eh, 0C0h, 0DEh, 0C0h,	0Fh
				db 40h,	0Fh, 40h, 7, 0,	7, 0, 16h, 0, 16h, 0, 5, 0, 3, 80h
bitmap_prisoner_facing_towards_2 db 0, 0, 3, 80h, 5, 0C0h, 7, 80h, 4, 40h, 3, 80h, 0Dh,	40h, 1Eh, 0E0h,	3Eh, 0E0h, 37h,	50h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_2o
				db 75h,	50h, 77h, 50h, 77h, 50h, 34h, 30h, 33h,	0C0h, 37h, 0D0h, 0Fh, 40h, 37h,	60h, 0Fh
				db 60h,	3Eh, 0E0h, 1Eh,	0C0h, 1Eh, 0C0h, 1Dh, 80h, 1Dh,	0, 1Ah,	80h, 9,	0C0h, 14h, 0, 0Eh
				db 0
bitmap_prisoner_facing_towards_3 db 0, 0, 3, 80h, 5, 0C0h, 7, 80h, 4, 40h, 3, 80h, 0Dh,	40h, 1Eh, 0E0h,	1Eh, 0E0h, 37h,	40h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_3o
				db 35h,	40h, 37h, 40h, 37h, 40h, 1Ah, 20h, 19h,	0C0h, 5, 0C0h, 0Dh, 40h, 13h, 60h, 1Eh,	0E0h
				db 1Eh,	0E0h, 1Ch, 0C0h, 3Dh, 0C0h, 39h, 80h, 31h, 80h,	50h, 40h, 60h, 0E0h, 30h, 0
bitmap_prisoner_facing_towards_4 db 0, 0, 3, 80h, 5, 0C0h, 7, 80h, 4, 40h, 3, 80h, 0Dh,	60h, 1Eh, 0E0h,	1Eh, 0F0h, 3Bh,	50h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_4o
				db 39h,	50h, 37h, 50h, 37h, 50h, 36h, 30h, 21h,	0C8h, 2Fh, 0E8h, 17h, 60h, 37h,	60h, 0Fh
				db 60h,	1Fh, 40h, 7, 40h, 6, 0C0h, 0Eh,	80h, 0Dh, 80h, 8, 0, 5,	80h, 0Eh, 0C0h
bitmap_crawl_facing_towards_1	db 0, 0, 0, 0, 0Ah, 0, 0, 39h, 80h, 0, 0FEh, 0C0h, 3, 0FEh, 0C0h, 7, 0FEh, 0C0h, 8, 0FEh
							    ; DATA XREF: seg000:sprite_crawl_facing_towards_1o
				db 0C0h, 7, 7Dh, 0CCh, 0Fh, 7Bh, 0D6h, 2Fh, 0B5h, 0F8h,	37h, 38h, 0E0h,	0C0h, 18h, 0, 40h
				db 30h,	0, 0, 10h, 0, 0, 60h, 0
bitmap_crawl_facing_towards_2	db 0, 0, 0, 0, 0Ah, 0, 0, 3Dh, 80h, 0, 0FEh, 80h, 3, 0FEh, 0C0h, 3, 0FEh, 0D8h,	0Dh, 0FDh
							    ; DATA XREF: seg000:sprite_crawl_facing_towards_2o
				db 0CCh, 1Eh, 0FBh, 0A0h, 1Eh, 0F7h, 98h, 1Eh, 77h, 2Ch, 0Ch, 0EFh, 0F0h, 30h, 0EFh, 0C0h
				db 10h,	0C7h, 0, 1, 80h, 0, 1, 0, 0, 6,	0, 0
bitmap_crawl_facing_away_1	db 3, 80h, 0, 7, 0A0h, 0, 7, 78h, 0, 6,	0FEh, 0, 1, 0FCh, 0, 7,	0F3h, 80h, 0CFh, 0EFh, 0C0h
							    ; DATA XREF: seg000:sprite_crawl_facing_away_1o
				db 0BEh, 0DFh, 40h, 10h, 3Fh, 40h, 0, 3Eh, 0C0h, 0, 7Dh, 0C0h, 0, 73h, 80h, 0, 79h, 0C0h
				db 0, 1Ah, 0E8h, 0, 3, 2Ch, 0, 1, 4
bitmap_crawl_facing_away_2	db 3, 80h, 0, 7, 80h, 0, 6, 78h, 0, 5, 0FEh, 0,	3, 0F8h, 0, 7, 0F7h, 80h, 7, 6Fh, 0C0h,	3
							    ; DATA XREF: seg000:sprite_crawl_facing_away_2o
				db 9Fh,	40h, 37h, 9Fh, 40h, 2Fh, 1Fh, 0, 0, 1Fh, 0, 0, 1Eh, 0, 0, 0Eh, 0C0h, 0,	0Fh, 0,	0
				db 7, 60h, 0, 1, 30h
mask_crawl_facing_away_shared	db 0F8h, 1Fh, 0FFh, 0F0h, 7, 0FFh, 0F0h, 1, 0FFh, 0F0h,	0, 0FFh, 0F8h, 0, 7Fh, 30h, 0, 3Fh
							    ; DATA XREF: seg000:sprite_crawl_facing_away_1o
							    ; seg000:sprite_crawl_facing_away_2o
				db 0, 0, 1Fh, 0, 0, 1Fh, 0, 0, 1Fh, 80h, 0, 1Fh, 0D0h, 0, 1Fh, 0FFh, 0,	3Fh, 0FFh, 0, 17h
				db 0FFh, 80h, 3, 0FFh, 0E0h, 1,	0FFh, 0F8h, 1
mask_various_facing_away_1	db 0FEh, 0Fh, 0FCh, 7, 0F8h, 3,	0FCh, 1, 0FCh, 1, 0F8h,	1, 0FCh, 1, 0F8h, 0, 0F0h, 0, 0F0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_1o
							    ; seg000:sprite_guard_facing_away_1o ...
				db 0, 0E0h, 0, 0E0h, 0,	0E0h, 0, 0C0h, 0, 0C0h,	1, 0C0h, 3, 0C0h, 1, 0E0h, 1, 0C0h, 1, 0E0h
				db 1, 0E0h, 1, 0E0h, 1,	0E0h, 3, 0E0h, 7, 0C0h,	7, 0E0h, 7, 0F0h, 7, 0F8h, 7, 0FEh, 8Fh
				db 0FFh, 0DFh, 0FFh, 0FFh, 0FFh, 0FFh
mask_various_facing_away_2	db 0FEh, 0Fh, 0FCh, 7, 0F8h, 3,	0FCh, 1, 0FCh, 1, 0F8h,	1, 0FCh, 1, 0F8h, 1, 0F0h, 0, 0E0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_2o
							    ; seg000:sprite_guard_facing_away_2o ...
				db 0, 0C0h, 0, 0C0h, 0,	0C0h, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0C0h, 1, 0C0h,	3, 0C0h, 3, 0C0h
				db 3, 0C0h, 3, 80h, 3, 80h, 7, 0C0h, 0Fh, 0E0h,	0Fh, 0F0h, 0Fh,	0F8h, 0Fh, 0FEh, 1Fh, 0FFh
				db 3Fh,	0FFh, 0FFh, 0FFh, 0FFh
mask_various_facing_away_3	db 0FEh, 0Fh, 0FCh, 7, 0F8h, 7,	0FCh, 3, 0FCh, 1, 0F8h,	1, 0FCh, 1, 0F8h, 1, 0F0h, 0, 0E0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_3o
							    ; seg000:sprite_guard_facing_away_3o ...
				db 0, 0C0h, 0, 0C0h, 0,	0C0h, 0, 0C0h, 1, 80h, 0, 80h, 0, 80h, 1, 0C0h,	3, 80h,	3, 0C0h
				db 3, 0C0h, 3, 0C0h, 3,	0C0h, 7, 0C0h, 0Fh, 0E0h, 0Fh, 0F0h, 7,	0F0h, 0Fh, 0E0h, 1Fh, 0F0h
				db 3Fh,	0F8h, 3Fh, 0FEh, 7Fh, 0FFh, 0FFh
mask_various_facing_away_4	db 0FEh, 0Fh, 0FCh, 7, 0F8h, 3,	0FCh, 1, 0FCh, 1, 0F8h,	1, 0FCh, 1, 0FCh, 0, 0F8h, 0, 0F0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_away_4o
							    ; seg000:sprite_guard_facing_away_4o ...
				db 0, 0E0h, 0, 0E0h, 1,	0E0h, 3, 0E0h, 3, 0E0h,	3, 0F0h, 3, 0E0h, 3, 0E0h, 1, 0E0h, 1, 0E0h
				db 3, 0E0h, 3, 0E0h, 3,	0C0h, 3, 0C0h, 3, 80h, 3, 80h, 3, 0C0h,	7, 0E0h, 0CFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
mask_various_facing_towards_1	db 0F8h, 1Fh, 0F0h, 0Fh, 0E0h, 0Fh, 0E0h, 7, 0F0h, 0Fh,	0C0h, 0Fh, 80h,	7, 0C0h, 3, 80h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_1o
							    ; seg000:sprite_guard_facing_towards_1o ...
				db 3, 0, 7, 0, 7, 0, 3,	0, 1, 0, 1, 0, 1, 0, 3,	0, 0Fh,	0, 0Fh,	0, 0Fh,	80h, 7,	80h, 7,	80h
				db 7, 0C0h, 0Fh, 0C0h, 1Fh, 0E0h, 3Fh, 0E0h, 1Fh, 0F4h,	0Fh, 0FEh, 1Fh,	0FFh, 7Fh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
mask_various_facing_towards_2	db 0F8h, 1Fh, 0F0h, 0Fh, 0E0h, 0Fh, 0E0h, 7, 0F0h, 0Fh,	0E0h, 0Fh, 0C0h, 7, 0C0h, 3, 80h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_2o
							    ; seg000:sprite_guard_facing_towards_2o ...
				db 7, 80h, 7, 0, 7, 0, 3, 0, 3,	0, 7, 80h, 7, 80h, 3, 0C0h, 7, 80h, 3, 80h, 3, 80h, 7, 80h
				db 7, 80h, 7, 80h, 7, 80h, 7, 0C0h, 3, 0E0h, 3,	0C0h, 27h, 0E0h, 3Fh, 0F0h, 7Fh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh
mask_various_facing_towards_3	db 0F8h, 1Fh, 0F0h, 0Fh, 0E0h, 0Fh, 0E0h, 7, 0F0h, 0Fh,	0C0h, 0Fh, 80h,	7, 0C0h, 3, 0C0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_3o
							    ; seg000:sprite_guard_facing_towards_3o ...
				db 7, 80h, 7, 80h, 7, 0, 3, 0, 3, 0, 1,	80h, 1,	0C0h, 3, 80h, 7, 80h, 7, 80h, 7, 80h, 7
				db 80h,	7, 80h,	0Fh, 80h, 7, 0,	7, 0, 0Fh, 0, 7, 83h, 3, 0C7h, 0C7h
mask_various_facing_towards_4	db 0F8h, 1Fh, 0F0h, 0Fh, 0E0h, 0Fh, 0E0h, 7, 0F0h, 0Fh,	0E0h, 0Fh, 0C0h, 7, 0C0h, 3, 0C0h
							    ; DATA XREF: seg000:sprite_prisoner_facing_towards_4o
							    ; seg000:sprite_guard_facing_towards_4o ...
				db 3, 80h, 7, 80h, 7, 0, 7, 0, 3, 0, 7,	80h, 3,	80h, 3,	80h, 7,	80h, 7,	80h, 7,	80h, 7,	80h
				db 7, 80h, 0Fh,	0C0h, 1Fh, 0C0h, 0Fh, 0E0h, 1Fh, 0C0h, 0Fh, 0E0h, 7, 0F0h, 0Fh,	0F8h, 0FFh
mask_crawl_facing_towards_shared db 0FFh, 0F5h,	0FFh, 0FFh, 0C0h, 7Fh, 0FFh, 0,	3Fh, 0FCh, 0, 1Fh, 0F8h, 0, 7, 0F0h, 0,	3
							    ; DATA XREF: seg000:sprite_crawl_facing_towards_2o
							    ; seg000:sprite_crawl_facing_towards_1o
				db 0E0h, 0, 1, 0C0h, 0,	1, 0C0h, 0, 0, 80h, 0, 1, 0, 0,	3, 0, 0, 0Fh, 6, 0, 3Fh, 0ACh, 0
				db 0FFh, 0F8h, 0Fh, 0FFh, 0F0h,	1Fh, 0FFh
bitmap_guard_facing_away_1	db 0, 0, 1, 0E0h, 3, 0F0h, 1, 0F0h, 1, 0E4h, 2,	0F4h, 1, 8, 0, 7Ch, 7, 0FCh, 7,	0DCh, 0Fh
							    ; DATA XREF: seg000:sprite_guard_facing_away_1o
				db 0C4h, 0Eh, 34h, 0Eh,	0F4h, 1Dh, 0C4h, 1Ch, 38h, 1Ah,	78h, 1Ah, 0DCh,	3, 0DCh, 1Bh, 0DCh
				db 7, 0DCh, 0Fh, 0DCh, 0Fh, 9Ch, 0Fh, 98h, 7, 60h, 18h,	70h, 0Eh, 0B0h,	0, 0E0h
bitmap_guard_facing_away_2	db 0, 0, 1, 0E0h, 3, 0F0h, 1, 0F0h, 1, 0E4h, 2,	0F4h, 1, 4, 0, 78h, 7, 0FCh, 0Fh, 0ACh,	1Fh
							    ; DATA XREF: seg000:sprite_guard_facing_away_2o
				db 8Ch,	18h, 6Ch, 1Bh, 0E8h, 3Bh, 0C8h,	0B4h, 30h, 0ACh, 0F0h, 0Dh, 0F8h, 1Fh, 0B8h, 1Fh
				db 0B8h, 1Fh, 38h, 1Fh,	38h, 1Fh, 38h, 3Eh, 38h, 3Dh, 0B0h, 1Dh, 0, 3, 40h, 6, 0
bitmap_guard_facing_away_3	db 0, 0, 1, 0E0h, 3, 0F0h, 1, 0F0h, 1, 0E4h, 2,	0F4h, 1, 4, 0, 78h, 7, 0FCh, 0Fh, 0BCh,	1Fh
							    ; DATA XREF: seg000:sprite_guard_facing_away_3o
				db 84h,	1Eh, 74h, 1Dh, 0E8h, 1Bh, 90h, 38h, 70h, 34h, 0F8h, 35h, 0B8h, 0Fh, 0B8h, 2Fh, 0B8h
				db 0Fh,	0B8h, 1Fh, 0B8h, 1Fh, 0B8h, 1Fh, 90h, 1Fh, 40h,	0Fh, 40h, 0, 0,	3, 0, 0Bh, 0, 6
				db 0
bitmap_guard_facing_away_4	db 0, 0, 1, 0E0h, 3, 0F0h, 1, 0F0h, 1, 0E4h, 2,	0F4h, 1, 4, 0, 78h, 3, 0FCh, 7,	0D8h, 0Fh
							    ; DATA XREF: seg000:sprite_guard_facing_away_4o
				db 0C4h, 0Ch, 38h, 0Dh,	0F0h, 0Dh, 0C0h, 0Eh, 38h, 6, 78h, 6, 0D8h, 9, 0D8h, 6,	0D8h, 9
				db 0D8h, 0Fh, 98h, 0Fh,	98h, 1Fh, 90h, 1Fh, 40h, 27h, 70h, 38h,	0, 18h,	0
bitmap_guard_facing_towards_1	db 0, 0, 0, 0, 7, 80h, 0Fh, 0C0h, 0Fh, 80h, 7, 40h, 0Ch, 80h, 23h, 0A0h, 14h, 70h, 16h,	0D0h
							    ; DATA XREF: seg000:sprite_guard_facing_towards_1o
				db 6Ah,	0D0h, 0EBh, 50h, 0EBh, 50h, 65h, 38h, 74h, 0D4h, 25h, 4Ch, 1Ah,	0E0h, 22h, 0E0h
				db 36h,	0F0h, 35h, 70h,	33h, 0B0h, 3Fh,	0B0h, 3Fh, 0A0h, 1Fh, 80h, 1Eh,	40h, 1,	80h, 0Bh
				db 80h,	5, 0E0h, 0, 80h
bitmap_guard_facing_towards_2	db 0, 0, 0, 0, 7, 80h, 0Fh, 0C0h, 0Fh, 80h, 7, 40h, 0Ch, 80h, 13h, 0A0h, 14h, 70h, 16h,	0D0h
							    ; DATA XREF: seg000:sprite_guard_facing_towards_2o
				db 16h,	0D0h, 2Bh, 50h,	6Bh, 50h, 6Bh, 10h, 68h, 0D0h, 35h, 68h, 35h, 68h, 0Ah,	0E0h, 1Ah
				db 0F0h, 26h, 0F0h, 35h, 70h, 33h, 70h,	3Fh, 60h, 3Fh, 0, 3Fh, 60h, 1Ch, 60h, 3, 30h, 6
				db 0, 3, 80h
bitmap_guard_facing_towards_3	db 0, 0, 0, 0, 7, 80h, 0Fh, 0C0h, 0Fh, 80h, 7, 40h, 0Ch, 80h, 23h, 0A0h, 14h, 60h, 16h,	0D0h
							    ; DATA XREF: seg000:sprite_guard_facing_towards_3o
				db 2Ah,	0D0h, 2Bh, 50h,	6Bh, 40h, 75h, 0, 74h, 0E0h, 39h, 60h, 15h, 60h, 2Ch, 0F0h, 32h
				db 0F0h, 36h, 0F0h, 35h, 70h, 32h, 0F0h, 3Eh, 0C0h, 3Eh, 30h, 1Eh, 70h,	60h, 60h, 70h, 70h
				db 38h,	38h
bitmap_guard_facing_towards_4	db 0, 0, 0, 0, 7, 80h, 0Fh, 0C0h, 0Fh, 80h, 7, 40h, 0Ch, 80h, 13h, 0A0h, 14h, 70h, 16h,	0D0h
							    ; DATA XREF: seg000:sprite_guard_facing_towards_4o
				db 16h,	0D0h, 2Bh, 50h,	6Bh, 50h, 6Bh, 10h, 68h, 0D0h, 35h, 60h, 35h, 60h, 0Ah,	0E0h, 1Ah
				db 0F0h, 25h, 70h, 2Bh,	70h, 27h, 0B0h,	3Fh, 0B0h, 1Fh,	80h, 1Fh, 40h, 0Ch, 80h, 12h, 0C0h
				db 0Fh,	60h
bitmap_dog_facing_away_1	db 1Ah,	0C0h, 0, 1Fh, 80h, 0, 0Bh, 80h,	0, 4, 0C0h, 0, 3, 0F0h,	0, 3, 0FCh, 0, 1, 0FFh,	0
							    ; DATA XREF: seg000:sprite_dog_facing_away_1o
				db 0Fh,	0FFh, 0C0h, 13h, 0FFh, 0E0h, 0,	7Fh, 0E0h, 0, 1Fh, 0E0h, 0, 3, 0D0h, 0,	1, 0D0h
				db 0, 0, 88h, 0, 0, 0A0h, 0, 3,	10h
bitmap_dog_facing_away_2	db 1Ah,	80h, 0,	1Fh, 0C0h, 0, 0Bh, 80h,	0, 4, 0C0h, 0, 3, 0F0h,	0, 3, 0F8h, 0, 3, 0FFh,	0
							    ; DATA XREF: seg000:sprite_dog_facing_away_2o
				db 1, 0FFh, 0C0h, 1, 0FFh, 0E0h, 1, 7Fh, 0E0h, 3, 1Bh, 0E0h, 6,	3, 0D0h, 0, 3, 0B0h, 0,	1
				db 0D0h, 0, 0, 40h, 0, 0, 0C0h
bitmap_dog_facing_away_3	db 1Ah,	80h, 0,	1Fh, 0C0h, 0, 0Bh, 80h,	0, 4, 0C0h, 0, 3, 0E0h,	0, 3, 0F8h, 0, 3, 0FFh,	0
							    ; DATA XREF: seg000:sprite_dog_facing_away_3o
				db 3, 0FFh, 0C0h, 1, 0FFh, 0E0h, 1, 3Fh, 0E0h, 1, 0DDh,	0E0h, 0, 3, 0D0h, 0, 1,	0B0h, 0
				db 0, 90h, 0, 3, 0
bitmap_dog_facing_away_4	db 1Ah,	0C0h, 0, 1Fh, 80h, 0, 0Bh, 80h,	0, 4, 0C0h, 0, 3, 0F0h,	0, 3, 0FCh, 0, 3, 0FFh,	0
							    ; DATA XREF: seg000:sprite_dog_facing_away_4o
				db 1, 0FFh, 0C0h, 1, 0FFh, 0E0h, 3, 7Fh, 0E0h, 6, 0BDh,	0E0h, 0, 3, 0D0h, 0, 3,	30h, 0,	0Eh
				db 0C8h, 0, 1, 80h
mask_dog_facing_away_shared	db 0C0h, 1Fh, 0FFh, 0C0h, 1Fh, 0FFh, 0E0h, 3Fh,	0FFh, 0F0h, 0Fh, 0FFh, 0F8h, 3,	0FFh, 0F8h
							    ; DATA XREF: seg000:sprite_dog_facing_away_1o
							    ; seg000:sprite_dog_facing_away_2o	...
				db 0, 0FFh, 0F0h, 0, 3Fh, 0E0h,	0, 1Fh,	0C0h, 0, 0Fh, 0E8h, 0, 0Fh, 0F0h, 0, 0Fh, 0F0h,	0
				db 7, 0F9h, 0F0h, 7, 0FFh, 0E0h, 3, 0FFh, 0F0h,	7, 0FFh, 0F8h, 7
bitmap_dog_facing_towards_1	db 0, 0, 0, 0Eh, 0, 0, 1Fh, 80h, 0, 1Fh, 0C0h, 0, 1Fh, 0F0h, 0,	1Fh, 0F8h, 0, 0Fh, 0FDh
							    ; DATA XREF: seg000:sprite_dog_facing_towards_1o
				db 80h,	0Eh, 0FFh, 0, 4, 0FFh, 0C0h, 8,	7Eh, 0C0h, 8, 1Dh, 0E0h, 0, 0Ch, 60h, 0, 2, 0, 0
				db 1, 80h
bitmap_dog_facing_towards_2	db 0, 0, 0, 0Eh, 0, 0, 1Fh, 0, 0, 1Fh, 0C0h, 0,	1Fh, 0E0h, 0, 1Fh, 0F8h, 0, 0Fh, 0FDh, 0
							    ; DATA XREF: seg000:sprite_dog_facing_towards_2o
				db 1Eh,	0FFh, 0, 68h, 0FFh, 0C0h, 0, 7Eh, 0C0h,	0, 1Dh,	0E0h, 0, 18h, 60h, 0, 0Ah, 0, 0
				db 12h,	0, 0, 8, 0
bitmap_dog_facing_towards_3	db 0, 0, 0, 0Ch, 0, 0, 1Fh, 0, 0, 1Fh, 0C0h, 0,	1Fh, 0E0h, 0, 1Fh, 0F8h, 0, 0Fh, 0FDh, 0
							    ; DATA XREF: seg000:sprite_dog_facing_towards_3o
				db 0Eh,	0FFh, 0, 18h, 0FFh, 0C0h, 9, 7Eh, 0C0h,	4, 19h,	0E0h, 0, 6Ch, 60h, 0, 1Ah, 0
bitmap_dog_facing_towards_4	db 0, 0, 0, 0Ch, 0, 0, 1Fh, 0, 0, 1Fh, 0C0h, 0,	1Fh, 0F0h, 0, 0Fh, 0F8h, 0, 0Fh, 0FDh, 80h
							    ; DATA XREF: seg000:sprite_dog_facing_towards_4o
				db 0Eh,	0FFh, 0, 6, 7Fh, 0C0h, 4, 7Eh, 0C0h, 2,	1Dh, 0E0h, 1, 0Ah, 60h,	0, 0Dh,	0, 0, 18h
				db 0
mask_dog_facing_towards_shared	db 0F1h, 0FFh, 0FFh, 0E0h, 7Fh,	0FFh, 0C0h, 3Fh, 0FFh, 0C0h, 0Fh, 0FFh,	0C0h, 7, 0FFh, 0C0h
							    ; DATA XREF: seg000:sprite_dog_facing_towards_1o
							    ; seg000:sprite_dog_facing_towards_2o ...
				db 2, 7Fh, 0E0h, 0, 3Fh, 80h, 0, 3Fh, 0, 0, 1Fh, 80h, 0, 1Fh, 0E0h, 0, 0Fh, 0F0h, 0, 0Fh
				db 0FEh, 80h, 1Fh, 0FFh, 0C0h, 3Fh, 0FFh, 0E0h,	7Fh, 0FFh, 0F7h, 0FFh
bitmap_crate			db 0, 30h, 0, 0, 0FCh, 0, 3, 0FFh, 0, 0Fh, 0E7h, 0C0h, 3Fh, 99h, 0F0h, 4Eh, 66h, 7Ch, 73h
							    ; DATA XREF: seg000:sprite_crateo
				db 99h,	0FFh, 78h, 0E7h, 0FCh, 7Bh, 3Fh, 0F3h, 7Bh, 0CFh, 0CFh,	3Bh, 0F3h, 3Fh,	4Bh, 0FCh
				db 0FFh, 73h, 0FDh, 0FFh, 78h, 0FDh, 0FCh, 7Bh,	3Dh, 0F3h, 7Bh,	0CDh, 0CFh, 7Bh, 0F1h, 3Fh
				db 3Bh,	0FCh, 0FFh, 0Bh, 0FDh, 0FFh, 3,	0FDh, 0FFh, 0, 0FDh, 0FCh, 0, 3Dh, 0F0h, 0, 0Dh
				db 0C0h, 0, 1, 0
mask_crate			db 0FFh, 3, 0FFh, 0FCh,	0, 0FFh, 0F0h, 0, 3Fh, 0C0h, 0,	0Fh, 80h, 0, 3,	0, 0, 0, 0, 0, 0
							    ; DATA XREF: seg000:sprite_crateo
				db 0, 0, 0, 0, 0, 0, 0,	0, 0, 80h, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0
				db 0, 0, 80h, 0, 0, 0C0h, 0, 0,	0F0h, 0, 0, 0FCh, 0, 0,	0FFh, 0, 3, 0FFh, 0C0h,	0Fh, 0FFh
				db 0F0h, 3Fh
bitmap_stove			db 1Ch,	0, 13h,	0C0h, 0Ch, 30h,	13h, 0C8h, 1Fh,	0F8h, 0Fh, 0F0h, 13h, 0C8h, 0Ch, 30h, 0Fh
							    ; DATA XREF: seg000:sprite_stoveo
				db 0F0h, 0Fh, 0F0h, 1Fh, 0F8h, 19h, 98h, 16h, 68h, 35h,	0ACh, 36h, 6Ch,	3Bh, 0DCh, 3Ch,	3Ch
				db 2Fh,	0F4h, 17h, 0E8h, 3Bh, 0DCh, 33h, 0CCh, 60h, 6
mask_stove			db 0C0h, 3Fh, 0C0h, 0Fh, 0E0h, 7, 0C0h,	3, 0C0h, 3, 0E0h, 7, 0C0h, 3, 0E0h, 7, 0E0h, 7,	0E0h
							    ; DATA XREF: seg000:sprite_stoveo
				db 7, 0C0h, 3, 0C0h, 3,	0C0h, 3, 80h, 1, 80h, 1, 80h, 1, 80h, 1, 80h, 1, 0C0h, 3, 80h, 1
				db 80h,	1, 0Ch,	30h
beds				dw 0AB6Fh		    ; DATA XREF: wake_up+48o
							    ; reset_map_and_characters+3Co ...
				dw 0AB72h
				dw 0AB75h
				dw 0ABCBh
				dw 0ABCEh
				dw 0ABD1h
roomdef_bounds			db 42h,	1Ah, 46h, 16h	    ; DATA XREF: bounds_check+156o
				db 3Eh,	16h, 3Ah, 1Ah
				db 36h,	1Eh, 42h, 12h
				db 3Eh,	1Eh, 3Ah, 22h
				db 4Ah,	12h, 3Eh, 1Eh
				db 38h,	32h, 64h, 0Ah
				db 68h,	6, 38h,	32h
				db 38h,	32h, 64h, 1Ah
				db 68h,	1Ch, 38h, 32h
				db 38h,	32h, 58h, 0Ah
rooms_and_tunnels		dw offset roomdef_1_hut1_right;	0
							    ; DATA XREF: seg000:prng_pointero
				dw offset roomdef_2_hut2_left; 1
				dw offset roomdef_3_hut2_right;	2
				dw offset roomdef_4_hut3_left; 3
				dw offset roomdef_5_hut3_right;	4
				dw offset roomdef_8_corridor; 5
				dw offset roomdef_7_corridor; 6
				dw offset roomdef_8_corridor; 7
				dw offset roomdef_9_crate   ; 8
				dw offset roomdef_10_lockpick; 9
				dw offset roomdef_11_papers ; 10
				dw offset roomdef_12_corridor; 11
				dw offset roomdef_13_corridor; 12
				dw offset roomdef_14_torch  ; 13
				dw offset roomdef_15_uniform; 14
				dw offset roomdef_16_corridor; 15
				dw offset roomdef_7_corridor; 16
				dw offset roomdef_18_radio  ; 17
				dw offset roomdef_19_food   ; 18
				dw offset roomdef_20_redcross; 19
				dw offset roomdef_16_corridor; 20
				dw offset roomdef_22_red_key; 21
				dw offset roomdef_23_breakfast;	22
				dw offset roomdef_24_solitary; 23
				dw offset roomdef_25_breakfast;	24
				dw offset roomdef_28_hut1_left;	25
				dw offset roomdef_28_hut1_left;	26
				dw offset roomdef_28_hut1_left;	27
				dw offset roomdef_29_second_tunnel_start; 28
				dw offset roomdef_30	    ; 29
				dw offset roomdef_31	    ; 30
				dw offset roomdef_32	    ; 31
				dw offset roomdef_29_second_tunnel_start; 32
				dw offset roomdef_34	    ; 33
				dw offset roomdef_35	    ; 34
				dw offset roomdef_36	    ; 35
				dw offset roomdef_34	    ; 36
				dw offset roomdef_35	    ; 37
				dw offset roomdef_32	    ; 38
				dw offset roomdef_40	    ; 39
				dw offset roomdef_30	    ; 40
				dw offset roomdef_32	    ; 41
				dw offset roomdef_29_second_tunnel_start; 42
				dw offset roomdef_44	    ; 43
				dw offset roomdef_36	    ; 44
				dw offset roomdef_36	    ; 45
				dw offset roomdef_32	    ; 46
				dw offset roomdef_34	    ; 47
				dw offset roomdef_36	    ; 48
				dw offset roomdef_50_blocked_tunnel; 49
				dw offset roomdef_32	    ; 50
				dw offset roomdef_40	    ; 51
roomdef_1_hut1_right		db 0, 3, 36h, 44h, 17h,	22h, 36h, 44h, 27h, 32h, 36h, 44h, 37h,	44h, 4,	0, 1, 3, 0Ah, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 2, 1, 4, 8, 8, 0, 8,	2, 3, 17h, 0Ah,	5, 17h,	6, 7, 0Fh, 0Fh,	8, 18h,	12h, 5,	18h, 14h
				db 6, 9, 2, 9, 10h, 7, 0Ah
roomdef_2_hut2_left		db 1, 2, 30h, 40h, 2Bh,	38h, 18h, 26h, 1Ah, 28h, 2, 0Dh, 8, 8, 1Bh, 3, 6, 8, 6,	2, 28h,	10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 5, 1Eh, 4, 5
room2_hut2_left_bed		db 17h,	8, 7, 10h, 7, 9, 1Dh, 0Bh, 0Ch,	1, 5, 9
							    ; DATA XREF: wake_up+56o
							    ; process_player_input+7Ew	...
roomdef_3_hut2_right		db 0, 3, 36h, 44h, 17h,	22h, 36h, 44h, 27h, 32h, 36h, 44h, 37h,	44h, 4,	0, 1, 3, 0Ah, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 2, 1, 4, 8, 8, 0, 8,	2, 3, 17h, 0Ah,	5, 17h,	6, 7, 17h, 2, 9, 0Bh, 10h, 5, 0Fh, 0Fh,	8
				db 0Ah,	12h, 5,	10h, 7,	0Ah
roomdef_4_hut3_left		db 1, 2, 18h, 28h, 18h,	2Ah, 30h, 40h, 2Bh, 38h, 3, 12h, 14h, 8, 9, 1Bh, 3, 6, 28h, 10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 5, 8, 6, 2, 1Eh, 4, 5, 9, 8,	7, 10h,	7, 9, 16h, 0Bh,	0Bh, 19h, 0Dh, 0Ah, 1Fh, 0Eh, 0Eh
roomdef_5_hut3_right		db 0, 3, 36h, 44h, 17h,	22h, 36h, 44h, 27h, 32h, 36h, 44h, 37h,	44h, 4,	0, 1, 3, 0Ah, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 2, 1, 4, 8, 8, 0, 8,	2, 3, 17h, 0Ah,	5, 17h,	6, 7, 17h, 2, 9, 0Fh, 0Fh, 8, 0Bh, 10h,	5
				db 0Bh,	14h, 7,	10h, 7,	0Ah
roomdef_8_corridor		db 2, 0, 1, 9, 5, 2Eh, 3, 6, 26h, 0Ah, 3, 26h, 4, 6, 10h, 5, 0Ah, 0Ah, 12h, 6
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_9_crate			db 1, 1, 3Ah, 40h, 1Ch,	2Ah, 2,	4, 15h,	0Ah, 1Bh, 3, 6,	23h, 6,	3, 21h,	9, 4, 24h, 0Ch,	6
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 0Fh,	0Dh, 0Ah, 20h, 10h, 6, 0Ah, 12h, 8, 1Ah, 3, 6, 22h, 6, 8, 22h, 4, 9
roomdef_10_lockpick		db 4, 2, 45h, 4Bh, 20h,	36h, 24h, 2Fh, 30h, 3Ch, 3, 6, 0Eh, 16h, 0Eh, 2Fh, 1, 4, 0Fh, 0Fh
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 0Ah,	23h, 4,	1, 35h,	2, 3, 35h, 7, 2, 20h, 0Ah, 2, 2Ah, 0Dh,	3, 2Ah,	0Fh, 4,	2Ah, 11h
				db 5, 1Dh, 0Eh,	8, 0Bh,	12h, 8,	0Bh, 14h, 9, 22h, 6, 5,	1Dh, 2,	6
roomdef_11_papers		db 4, 1, 1Bh, 2Ch, 24h,	30h, 1,	17h, 9,	2Fh, 1,	4, 21h,	6, 3, 20h, 0Ch,	3, 32h,	0Ah, 3,	0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 0Eh,	5, 26h,	2, 2, 32h, 12h,	7, 32h,	14h, 8,	33h, 0Ch, 0Ah
roomdef_12_corridor		db 1, 0, 2, 4, 7, 4, 1Bh, 3, 6,	23h, 6,	3, 10h,	9, 0Ah,	0Fh, 0Dh, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_13_corridor		db 1, 0, 2, 4, 8, 6, 1Bh, 3, 6,	26h, 6,	3, 10h,	7, 9, 0Fh, 0Dh,	0Ah, 32h, 0Ch, 5, 0Bh, 0Eh
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 7
roomdef_14_torch		db 0, 3, 36h, 44h, 16h,	20h, 3Eh, 44h, 30h, 3Ah, 36h, 44h, 36h,	44h, 1,	1, 9, 2, 1, 4, 26h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 4, 3, 31h, 8, 5, 9, 0Ah, 5, 0Bh, 10h, 5, 0Ah, 12h, 5, 28h, 14h, 4, 21h, 2, 7, 9, 2, 9
roomdef_15_uniform		db 0, 4, 36h, 44h, 16h,	20h, 36h, 44h, 36h, 44h, 3Eh, 44h, 28h,	3Ah, 1Eh, 28h, 38h, 43h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 4, 1, 5, 0Ah, 0Fh, 0Ah, 2, 1, 4, 0Ah, 10h, 4, 9, 0Ah, 5, 31h, 8, 5, 31h, 6, 6, 21h, 2
				db 7, 9, 2, 9, 10h, 7, 0Ah, 0Fh, 0Dh, 9, 1Dh, 12h, 8
roomdef_16_corridor		db 1, 0, 2, 4, 7, 4, 1Bh, 3, 6,	26h, 4,	4, 10h,	9, 0Ah,	0Fh, 0Dh, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_7_corridor		db 1, 0, 1, 4, 4, 1Bh, 3, 6, 26h, 4, 4,	0Fh, 0Dh, 0Ah, 20h, 0Ch, 4
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_18_radio		db 4, 3, 26h, 38h, 30h,	3Ch, 26h, 2Eh, 27h, 3Ch, 16h, 20h, 30h,	3Ch, 5,	0Bh, 11h, 10h, 18h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 19h,	0Ah, 2Fh, 1, 4,	1Ah, 1,	4, 23h,	4, 1, 21h, 7, 2, 28h, 0Ah, 1, 1Dh, 0Ch,	7, 2Dh,	0Ch
				db 9, 1Dh, 12h,	0Ah, 30h, 10h, 0Ch, 10h, 5, 7
roomdef_19_food			db 1, 1, 34h, 40h, 2Fh,	38h, 1,	7, 0Bh,	1Bh, 3,	6, 23h,	6, 3, 1Ah, 9, 3, 2Ah, 0Ch, 3, 2Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 0Eh,	4, 1Dh,	9, 6, 21h, 3, 5, 34h, 3, 7, 0Bh, 0Eh, 7, 28h, 10h, 5, 10h, 9, 0Ah
roomdef_20_redcross		db 1, 2, 3Ah, 40h, 1Ah,	2Ah, 32h, 40h, 2Eh, 36h, 2, 15h, 4, 0Bh, 1Bh, 3, 6, 0Fh, 0Dh, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 21h,	9, 4, 1Ah, 3, 6, 22h, 6, 8, 22h, 4, 9, 1Dh, 9, 6, 20h, 0Eh, 5, 20h, 10h, 6, 18h
				db 12h,	8, 30h,	0Bh, 8
roomdef_22_red_key		db 3, 2, 36h, 40h, 2Eh,	38h, 3Ah, 40h, 24h, 2Ch, 2, 0Ch, 15h, 7, 29h, 5, 6, 25h, 4, 4, 21h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 9, 4, 22h, 6, 8, 10h, 9, 8, 1Dh, 9, 6, 28h, 0Eh, 4
roomdef_23_breakfast		db 0, 1, 36h, 44h, 22h,	44h, 2,	0Ah, 3,	0Ch, 2,	1, 4, 23h, 8, 0, 23h, 2, 3, 10h, 7, 0Ah
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 2Ch,	5, 4, 2Ah, 12h,	4, 28h,	14h, 4,	0Fh, 0Fh, 8, 2Bh, 7, 6
roomdef_23_breakfast_bench_A	db 0Dh,	0Ch, 5		    ; DATA XREF: breakfast_time+43w
							    ; reset_map_and_characters+49w ...
roomdef_23_breakfast_bench_B	db 0Dh			    ; DATA XREF: breakfast_time+46w
							    ; reset_map_and_characters+4Cw
				db 0Ah
				db 6
roomdef_23_breakfast_bench_C	db 0Dh			    ; DATA XREF: breakfast_time+49w
							    ; reset_map_and_characters+4Fw
				db 8
				db 7
roomdef_24_solitary		db 3, 1, 30h, 36h, 26h,	2Eh, 1,	1Ah, 3,	29h, 5,	6, 28h,	0Eh, 4,	30h, 0Ah, 9
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_25_breakfast		db 0, 1, 36h, 44h, 22h,	44h, 0,	0Bh, 2,	1, 4, 23h, 8, 0, 1Ah, 5, 3, 23h, 2, 3, 28h, 12h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 3, 2Ch, 5, 4, 2Bh, 7, 6
roomdef_25_breakfast_bench_D	db 0Dh			    ; DATA XREF: breakfast_time+4Cw
							    ; reset_map_and_characters+52w ...
				db 0Ch
				db 5
roomdef_25_breakfast_bench_E	db 0Dh			    ; DATA XREF: breakfast_time+4Fw
							    ; reset_map_and_characters+55w
				db 0Ah
				db 6
roomdef_25_breakfast_bench_F	db 0Dh			    ; DATA XREF: breakfast_time+52w
							    ; reset_map_and_characters+58w
				db 8
				db 7
roomdef_25_breakfast_bench_G	db 0Dh			    ; DATA XREF: breakfast_time+55w
							    ; process_player_input+53w	...
				db 0Eh
				db 4
roomdef_28_hut1_left		db 1, 2, 1Ch, 28h, 1Ch,	34h, 30h, 3Fh, 2Ch, 38h, 3, 8, 0Dh, 13h, 8, 1Bh, 3, 6, 8, 6, 2,	28h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 0Eh,	4, 1Ah,	3, 6, 17h, 8, 7, 10h, 7, 9, 19h, 0Fh, 0Ah, 1Dh,	0Bh, 0Ch
roomdef_29_second_tunnel_start	db 5, 0, 6, 1Eh, 1Fh, 20h, 21h,	22h, 23h, 6, 0,	14h, 0,	0, 10h,	2, 0, 0Ch, 4, 0, 8, 6, 0
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 4, 8, 0, 0, 0Ah
roomdef_31			db 6, 0, 6, 24h, 25h, 26h, 27h,	28h, 29h, 6, 3,	0, 0, 3, 4, 2, 3, 8, 4,	3, 0Ch,	6, 3, 10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 8, 3, 14h, 0Ah
roomdef_36			db 7, 0, 6, 1Fh, 20h, 21h, 22h,	23h, 2Dh, 5, 0,	14h, 0,	0, 10h,	2, 0, 0Ch, 4, 0, 8, 6, 0Eh
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 4, 8
roomdef_32			db 8, 0, 6, 24h, 25h, 26h, 27h,	28h, 2Ah, 5, 3,	0, 0, 3, 4, 2, 3, 8, 4,	3, 0Ch,	6, 11h,	10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 8
roomdef_34			db 6, 0, 6, 24h, 25h, 26h, 27h,	28h, 2Eh, 6, 3,	0, 0, 3, 4, 2, 3, 8, 4,	3, 0Ch,	6, 3, 10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 8, 12h, 14h,	0Ah
roomdef_35			db 6, 0, 6, 24h, 25h, 26h, 27h,	28h, 29h, 6, 3,	0, 0, 3, 4, 2, 4, 8, 4,	3, 0Ch,	6, 3, 10h
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 8, 3, 14h, 0Ah
roomdef_30			db 5, 0, 7, 1Eh, 1Fh, 20h, 21h,	22h, 23h, 2Ch, 6, 0, 14h, 0, 0,	10h, 2,	0, 0Ch,	4, 6, 8
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 6, 0, 4, 8, 0, 0, 0Ah
roomdef_40			db 9, 0, 6, 1Eh, 1Fh, 20h, 21h,	22h, 2Bh, 6, 7,	14h, 0,	0, 10h,	2, 0, 0Ch, 4, 0, 8, 6, 0
							    ; DATA XREF: seg000:rooms_and_tunnelso
				db 4, 8, 0, 0, 0Ah
roomdef_44			db 8, 0, 5, 24h, 25h, 26h, 27h,	28h, 5,	3, 0, 0, 3, 4, 2, 3, 8,	4, 3, 0Ch, 6, 0Ch, 10h,	8
							    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_50_blocked_tunnel	db 5, 1			    ; DATA XREF: seg000:rooms_and_tunnelso
roomdef_50_blocked_tunnel_boundary db 34h, 3Ah,	20h, 36h, 6, 1Eh, 1Fh, 20h, 21h, 22h, 2Bh, 6, 7, 14h, 0, 0, 10h, 2, 0, 0Ch
							    ; DATA XREF: reset_map_and_characters+26w
							    ; action_shovel+7r	...
				db 4
roomdef_50_blocked_tunnel_collapsed_tunnel db 14h, 8, 6, 0, 4, 8, 0, 0,	0Ah
							    ; DATA XREF: reset_map_and_characters+21w
							    ; action_shovel+15w
interior_object_defs		dw offset interior_object_tile_refs_0; 0
							    ; DATA XREF: expand_objecto
				dw offset interior_object_tile_refs_1; 1
				dw offset interior_object_tile_refs_2; 2
				dw offset interior_object_tile_refs_3; 3
				dw offset interior_object_tile_refs_4; 4
				dw offset interior_object_tile_refs_5; 5
				dw offset interior_object_tile_refs_6; 6
				dw offset interior_object_tile_refs_7; 7
				dw offset interior_object_tile_refs_8; 8
				dw offset interior_object_tile_refs_9; 9
				dw offset interior_object_tile_refs_10;	10
				dw offset interior_object_tile_refs_11;	11
				dw offset interior_object_tile_refs_12;	12
				dw offset interior_object_tile_refs_13;	13
				dw offset interior_object_tile_refs_14;	14
				dw offset interior_object_tile_refs_15;	15
				dw offset interior_object_tile_refs_16;	16
				dw offset interior_object_tile_refs_17;	17
				dw offset interior_object_tile_refs_18;	18
				dw offset interior_object_tile_refs_19;	19
				dw offset interior_object_tile_refs_20;	20
				dw offset interior_object_tile_refs_2; 21
				dw offset interior_object_tile_refs_22;	22
				dw offset interior_object_tile_refs_23;	23
				dw offset interior_object_tile_refs_24;	24
				dw offset interior_object_tile_refs_25;	25
				dw offset interior_object_tile_refs_26;	26
				dw offset interior_object_tile_refs_27;	27
				dw offset interior_object_tile_refs_28;	28
				dw offset interior_object_tile_refs_28;	29
				dw offset interior_object_tile_refs_30;	30
				dw offset interior_object_tile_refs_31;	31
				dw offset interior_object_tile_refs_32;	32
				dw offset interior_object_tile_refs_33;	33
				dw offset interior_object_tile_refs_34;	34
				dw offset interior_object_tile_refs_35;	35
				dw offset interior_object_tile_refs_36;	36
				dw offset interior_object_tile_refs_37;	37
				dw offset interior_object_tile_refs_38;	38
				dw offset interior_object_tile_refs_39;	39
				dw offset interior_object_tile_refs_39;	40
				dw offset interior_object_tile_refs_41;	41
				dw offset interior_object_tile_refs_42;	42
				dw offset interior_object_tile_refs_43;	43
				dw offset interior_object_tile_refs_44;	44
				dw offset interior_object_tile_refs_45;	45
				dw offset interior_object_tile_refs_46;	46
				dw offset interior_object_tile_refs_47;	47
				dw offset interior_object_tile_refs_48;	48
				dw offset interior_object_tile_refs_49;	49
				dw offset interior_object_tile_refs_50;	50
				dw offset interior_object_tile_refs_51;	51
				dw offset interior_object_tile_refs_52;	52
				dw offset interior_object_tile_refs_53;	53
interior_object_tile_refs_0	db 4, 6, 0, 0, 0, 2, 3,	2, 4, 5, 8, 0Fh, 9, 0Ah, 6, 7, 0Eh, 0Ch, 0Eh, 0Bh, 0Dh,	0, 0Dh,	0
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0
interior_object_tile_refs_1	db 2, 2, 0B6h, 0, 0B7h,	0B5h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_3	db 4, 6, 2, 0, 0, 0, 11h, 12h, 2, 0, 15h, 16h, 17h, 8, 18h, 0Eh, 7, 19h, 0, 13h, 1Ah, 0Eh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0, 0, 13h
interior_object_tile_refs_4	db 4, 6, 2, 0, 0, 0, 11h, 12h, 4, 5, 15h, 16h, 9, 0Ah, 18h, 0Eh, 7, 0Ch, 0, 13h, 1Ah, 0Eh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0, 0, 13h
interior_object_tile_refs_5	db 2, 3, 0FFh, 46h, 0B8h    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_6	db 4, 6, 0, 0, 3, 2, 0,	2, 4, 5, 8, 0Fh, 9, 0Ah, 11h, 12h, 0Eh,	0Ch, 15h, 16h, 0Dh, 0, 18h
							    ; DATA XREF: seg000:interior_object_defso
				db 0Eh,	0, 0
interior_object_tile_refs_7	db 4, 6, 0, 0, 2, 17h, 0, 8, 0Fh, 2, 8,	0Fh, 18h, 8, 11h, 12h, 7, 16h, 15h, 16h, 0Dh, 0
							    ; DATA XREF: seg000:interior_object_defso
				db 18h,	0Eh, 0,	0
interior_object_tile_refs_12	db 4, 6, 2, 0, 0, 0, 11h, 12h, 4, 5, 15h, 16h, 9, 0Ah, 18h, 0Eh, 7, 0Ch, 0, 13h, 0Dh, 0FFh
							    ; DATA XREF: seg000:interior_object_defso
				db 85h,	0
interior_object_tile_refs_13	db 2, 3, 0FFh, 86h, 0	    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_14	db 4, 6, 0, 0, 3, 2, 0,	2, 4, 5, 8, 0Fh, 1Dh, 12h, 9, 7, 15h, 16h, 0, 13h, 18h,	7, 0FFh
							    ; DATA XREF: seg000:interior_object_defso
				db 84h,	0
interior_object_tile_refs_17	db 4, 6, 8, 2, 0, 0, 11h, 12h, 8, 0, 4,	1Ch, 17h, 0Fh, 9, 0Ah, 7, 16h, 7, 0Ch, 0Dh, 0, 0Dh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0, 0
interior_object_tile_refs_18	db 4, 6, 2, 0, 0, 0, 11h, 12h, 4, 5, 4,	1Ch, 1Dh, 12h, 9, 0Ah, 7, 0Ch, 0, 0Ch, 0Dh, 0, 0
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0, 0
interior_object_tile_refs_19	db 2, 3, 0BEh, 0BFh, 0BAh, 0C0h, 0BCh, 0C1h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_20	db 4, 6, 0, 0, 0, 2, 0,	2, 1Eh,	5, 1Bh,	22h, 22h, 24h, 21h, 22h, 22h, 23h, 1Fh,	20h, 0Dh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 0Dh, 0, 0, 0
interior_object_tile_refs_2	db 16h,	0Ch, 0FFh, 8Bh,	0, 32h,	36h, 0FFh, 92h,	0, 32h,	25h, 34h, 37h, 35h, 36h, 0FFh, 8Eh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 32h, 25h,	34h, 0FFh, 84h,	0, 37h,	35h, 36h, 0FFh,	8Ah, 0,	32h, 25h, 34h, 0FFh, 88h
				db 0, 37h, 35h,	36h, 0FFh, 86h,	0, 32h,	25h, 34h, 0FFh,	8Ch, 0,	37h, 35h, 36h, 0, 0, 32h
				db 25h,	34h, 0FFh, 90h,	0, 37h,	35h, 25h, 34h, 0FFh, 92h, 0, 39h, 0Dh, 13h, 3Ah, 0FFh, 90h
				db 0, 39h, 0Dh,	0FFh, 84h, 0, 13h, 3Ah,	0FFh, 8Ch, 0, 39h, 0Dh,	0FFh, 88h, 0, 13h, 3Ah,	0FFh
				db 88h,	0, 39h,	0Dh, 0FFh, 8Ch,	0, 13h,	3Ah, 0FFh, 84h,	0, 39h,	0Dh, 0FFh, 90h,	0, 13h,	3Ah
				db 39h,	0Dh, 0FFh, 8Ah,	0
interior_object_tile_refs_8	db 5, 6, 0, 0, 0, 32h, 36h, 0, 32h, 25h, 26h, 27h, 25h,	26h, 2Ah, 29h, 27h, 28h, 29h, 2Bh
							    ; DATA XREF: seg000:interior_object_defso
				db 2Ch,	2Dh, 31h, 2Ch, 30h, 2Fh, 0, 2Eh, 2Fh, 0, 0, 0
interior_object_tile_refs_9	db 5, 4, 3Eh, 3Fh, 40h,	0, 0, 0FFh, 45h, 41h, 0, 0FFh, 44h, 46h, 0, 0, 0, 4Ah, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_10	db 3, 4, 0FFh, 46h, 51h, 54h, 57h, 56h,	58h, 59h, 5Ah
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_11	db 2, 3, 0FFh, 46h, 4Bh	    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_15	db 4, 6, 0, 0, 32h, 36h, 32h, 25h, 34h,	27h, 38h, 0, 0,	27h, 38h, 0, 0,	27h, 38h, 0, 1,	3Bh
							    ; DATA XREF: seg000:interior_object_defso
				db 3Ch,	1, 1, 0
interior_object_tile_refs_16	db 4, 6, 32h, 36h, 0, 0, 38h, 37h, 35h,	36h, 38h, 0, 0,	27h, 38h, 0, 0,	27h, 33h, 1, 0,	27h
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 1, 1, 3Dh
interior_object_tile_refs_22	db 2, 4, 67h, 0, 68h, 36h, 69h,	6Bh, 6Ah, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_23	db 5, 4, 3Eh, 70h, 6Ch,	0, 0, 41h, 42h,	6Dh, 6Eh, 45h, 0, 46h, 47h, 6Fh, 49h, 0, 0, 0, 4Ah
							    ; DATA XREF: seg000:interior_object_defso
				db 0
interior_object_tile_refs_24	db 3, 4, 51h, 52h, 53h,	71h, 72h, 56h, 54h, 57h, 56h, 58h, 59h,	5Ah
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_25	db 2, 4, 0, 73h, 5Ch, 0FFh, 44h, 74h, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_26	db 3, 3, 5Ch, 0FFh, 48h, 78h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_28	db 4, 3, 0FFh, 48h, 5Ch, 4Ah, 38h, 0, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_30	db 3, 4, 80h, 81h, 0, 0, 82h, 0, 0, 82h, 0, 0, 80h, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_31	db 1, 1, 83h		    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_32	db 3, 5, 0FFh, 46h, 51h, 54h, 57h, 56h,	54h, 57h, 56h, 58h, 59h, 5Ah
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_33	db 2, 2, 0FFh, 44h, 88h	    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_34	db 2, 2, 0FFh, 44h, 8Ch	    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_35	db 3, 5, 0, 32h, 36h, 25h, 84h,	27h, 85h, 86h, 27h, 85h, 87h, 2Dh, 2Eh,	2Fh, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_36	db 4, 3, 32h, 36h, 0, 0, 5Bh, 37h, 35h,	36h, 0,	1, 1, 27h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_37	db 4, 4, 0, 0, 32h, 36h, 32h, 25h, 34h,	27h, 38h, 90h, 90h, 27h, 38h, 25h, 34h,	0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_38	db 4, 6, 0, 0, 32h, 36h, 32h, 25h, 34h,	27h, 38h, 0, 0,	27h, 38h, 0, 0,	27h, 38h, 0, 1,	91h
							    ; DATA XREF: seg000:interior_object_defso
				db 38h,	1, 1, 0
interior_object_tile_refs_39	db 4, 6, 32h, 36h, 0, 0, 38h, 37h, 35h,	36h, 38h, 0, 0,	27h, 38h, 0, 0,	27h, 5Bh, 1, 0,	27h
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 1, 1, 27h
interior_object_tile_refs_41	db 0Eh,	8, 0FFh, 85h, 0, 32h, 36h, 0FFh, 8Ah, 0, 32h, 25h, 34h,	37h, 35h, 36h, 0FFh, 86h
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 32h, 25h,	34h, 0FFh, 84h,	0, 37h,	35h, 36h, 0, 0,	0, 25h,	34h, 0FFh, 88h,	0, 37h,	35h
				db 36h,	0, 13h,	3Ah, 0FFh, 8Ah,	0, 37h,	35h, 0,	0, 13h,	3Ah, 0FFh, 88h,	0, 39h,	0Dh, 0FFh
				db 84h,	0, 13h,	3Ah, 0FFh, 84h,	0, 39h,	0Dh, 0FFh, 88h,	0, 13h,	3Ah, 39h, 0Dh, 0FFh, 84h
				db 0
interior_object_tile_refs_42	db 2, 3, 51h, 52h, 54h,	55h, 58h, 59h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_43	db 9, 5, 0FFh, 86h, 0, 5Ch, 94h, 99h, 0FFh, 84h, 0, 5Ch, 94h, 97h, 66h,	96h, 0,	0, 5Ch,	94h
							    ; DATA XREF: seg000:interior_object_defso
				db 97h,	66h, 0,	0, 0, 5Ch, 94h,	97h, 66h, 0FFh,	85h, 0,	98h, 66h, 0FFh,	87h, 0
interior_object_tile_refs_44	db 0Ah,	6, 0FFh, 86h, 0, 0FFh, 44h, 5Ch, 0FFh, 84h, 0, 5Ch, 5Dh, 64h, 65h, 62h,	63h, 0,	0
							    ; DATA XREF: seg000:interior_object_defso
				db 5Ch,	5Dh, 64h, 65h, 62h, 66h, 0, 0, 5Ch, 5Dh, 64h, 65h, 62h,	66h, 0FFh, 84h,	0, 60h,	61h
				db 62h,	66h, 0FFh, 86h,	0, 4Ah,	38h, 0FFh, 88h,	0
interior_object_tile_refs_45	db 5, 3, 0, 0, 5Ch, 94h, 95h, 5Ch, 94h,	97h, 66h, 96h, 98h, 66h, 0, 0, 0
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_46	db 12h,	0Ah, 0FFh, 8Bh,	0, 32h,	36h, 0FFh, 8Eh,	0, 32h,	25h, 34h, 37h, 35h, 36h, 0FFh, 8Ah
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 32h, 25h,	34h, 0FFh, 84h,	0, 37h,	35h, 36h, 0FFh,	86h, 0,	32h, 25h, 34h, 0FFh, 88h
				db 0, 37h, 35h,	0, 0, 0, 32h, 25h, 34h,	0FFh, 8Ah, 0, 39h, 0Dh,	0, 32h,	25h, 34h, 0FFh,	8Ah
				db 0, 39h, 0Dh,	0, 0, 25h, 34h,	0FFh, 8Ah, 0, 39h, 0Dh,	0FFh, 84h, 0, 13h, 3Ah,	0FFh, 88h
				db 0, 39h, 0Dh,	0FFh, 88h, 0, 13h, 3Ah,	0FFh, 84h, 0, 39h, 0Dh,	0FFh, 8Ch, 0, 13h, 3Ah,	39h
				db 0Dh,	0FFh, 8Ah, 0
interior_object_tile_refs_47	db 16h,	0Ch, 0FFh, 87h,	0, 32h,	36h, 0FFh, 92h,	0, 32h,	25h, 34h, 37h, 35h, 36h, 0FFh, 8Eh
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 32h, 25h,	34h, 0FFh, 84h,	0, 37h,	35h, 36h, 0FFh,	8Ah, 0,	32h, 25h, 34h, 0FFh, 88h
				db 0, 37h, 35h,	36h, 0FFh, 87h,	0, 25h,	34h, 0FFh, 8Ch,	0, 37h,	35h, 36h, 0FFh,	85h, 0,	13h
				db 3Ah,	0FFh, 8Eh, 0, 37h, 35h,	36h, 0FFh, 85h,	0, 13h,	3Ah, 0FFh, 8Eh,	0, 37h,	35h, 36h
				db 0FFh, 85h, 0, 13h, 3Ah, 0FFh, 8Eh, 0, 37h, 35h, 0FFh, 86h, 0, 13h, 3Ah, 0FFh, 8Ch, 0
				db 39h,	0Dh, 0FFh, 88h,	0, 13h,	3Ah, 0FFh, 88h,	0, 39h,	0Dh, 0FFh, 8Ch,	0, 13h,	3Ah, 0FFh
				db 84h,	0, 39h,	0Dh, 0FFh, 90h,	0, 13h,	3Ah, 39h, 0Dh, 0FFh, 86h, 0
interior_object_tile_refs_48	db 2, 2, 5Ch, 36h, 98h,	93h ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_49	db 2, 3, 5Ch, 9Ah, 7Ah,	9Bh, 9Dh, 9Ch
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_50	db 2, 4, 4Bh, 4Ch, 9Eh,	4Eh, 9Fh, 4Eh, 4Fh, 50h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_51	db 6, 4, 5Ch, 5Dh, 5Eh,	0A0h, 0A8h, 0, 60h, 61h, 0A1h, 0A2h, 0A3h, 0A7h, 4Ah, 38h, 0A4h
							    ; DATA XREF: seg000:interior_object_defso
				db 0A5h, 0A6h, 0, 0, 0,	0, 2Dh,	0, 0
interior_object_tile_refs_52	db 3, 3, 0A9h, 0AAh, 0,	0FFh, 46h, 0ABh
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_53	db 2, 2, 0B2h, 0B1h, 0B3h, 0B4h
							    ; DATA XREF: seg000:interior_object_defso
interior_object_tile_refs_27	db 12h,	0Ah, 0FFh, 87h,	0, 32h,	36h, 0FFh, 8Eh,	0, 32h,	25h, 34h, 37h, 35h, 36h, 0FFh, 8Ah
							    ; DATA XREF: seg000:interior_object_defso
				db 0, 32h, 25h,	34h, 0FFh, 84h,	0, 37h,	35h, 36h, 0FFh,	86h, 0,	32h, 25h, 34h, 0FFh, 88h
				db 0, 37h, 35h,	36h, 0,	0, 0, 25h, 34h,	0FFh, 8Ch, 0, 37h, 35h,	36h, 0,	13h, 3Ah, 0FFh,	8Eh
				db 0, 37h, 35h,	0, 0, 13h, 3Ah,	0FFh, 8Ch, 0, 39h, 0Dh,	0FFh, 84h, 0, 13h, 3Ah,	0FFh, 88h
				db 0, 39h, 0Dh,	0FFh, 88h, 0, 13h, 3Ah,	0FFh, 84h, 0, 39h, 0Dh,	0FFh, 8Ch, 0, 13h, 3Ah,	39h
				db 0Dh,	0FFh, 86h, 0
item_attributes			db 6			    ; DATA XREF: draw_item:loc_90CCo
							    ; action_poison+1Bw ...
				db 5
				db 5
				db 7
				db 4
				db 42h
				db 4
				db 7
				db 3
				db 42h
				db 6
				db 4
				db 5
				db 7
				db 7
				db 4
				db 6
				db 5
				db 42h
				db 42h
item_definitions		sprite <2, 11, offset bitmap_wiresnips,	offset mask_wiresnips>
							    ; DATA XREF: setup_item_plotting+17o
							    ; draw_item+18o
				sprite <2, 13, offset bitmap_shovel, offset mask_shovelkey>
				sprite <2, 16, offset bitmap_lockpick, offset mask_lockpick>
				sprite <2, 15, offset bitmap_papers, offset mask_papers>
				sprite <2, 12, offset bitmap_torch, offset mask_torch>
				sprite <2, 13, offset bitmap_bribe, offset mask_bribe>
				sprite <2, 16, offset bitmap_uniform, offset mask_uniform>
				sprite <2, 16, offset bitmap_food, offset mask_food>
				sprite <2, 16, offset bitmap_poison, offset mask_poison>
				sprite <2, 13, offset bitmap_key, offset mask_shovelkey>
				sprite <2, 13, offset bitmap_key, offset mask_shovelkey>
				sprite <2, 13, offset bitmap_key, offset mask_shovelkey>
				sprite <2, 16, offset bitmap_parcel, offset mask_parcel>
				sprite <2, 16, offset bitmap_radio, offset mask_radio>
				sprite <2, 12, offset bitmap_purse, offset mask_purse>
				sprite <2, 12, offset bitmap_compass, offset mask_compass>
bitmap_shovel			db    0,   0		    ; DATA XREF: seg000:B511o
				db    0,   2
				db    0,   5
				db    0, 0Eh
				db    0, 30h
				db    0,0C0h
				db  33h,   0
				db  6Ch,   0
				db 0E7h,   0
				db 0FCh,   0
				db    0,   0
				db    0,   0
				db    0,   0
bitmap_key			db    0,   0		    ; DATA XREF: seg000:B541o
							    ; seg000:B547o ...
				db    0,   0
				db    0,   0
				db    0, 18h
				db    0, 64h
				db    0, 1Ch
				db    0, 70h
				db  19h,0C0h
				db  27h,   0
				db  32h,   0
				db  19h,   0
				db    7,   0
				db    0,   0
bitmap_lockpick			db    1, 80h		    ; DATA XREF: seg000:B517o
				db    0,0C0h
				db    3, 70h
				db  0Ch, 60h
				db  38h, 40h
				db 0E0h,   0
				db 0C0h,   0
				db    3, 18h
				db  0Ch,0F0h
				db  30h,0C0h
				db  23h,   7
				db  2Ch,   8
				db  30h, 38h
				db    0,0E6h
				db    3,0C4h
				db    3,   0
bitmap_compass			db    0,   0		    ; DATA XREF: seg000:B565o
				db    7,0E0h
				db  18h, 18h
				db  24h, 24h
				db  41h,   2
				db  41h,   2
				db  24h,0A4h
				db  58h, 9Ah
				db  27h,0E4h
				db  18h, 18h
				db    7,0E0h
				db    0,   0
bitmap_purse			db    0,   0		    ; DATA XREF: seg000:B55Fo
				db    1, 80h
				db    7, 40h
				db    3, 80h
				db    1,   0
				db    2, 80h
				db    5, 40h
				db  0Dh,0A0h
				db  0Bh,0E0h
				db  0Fh,0E0h
				db    7,0C0h
				db    0,   0
bitmap_papers			db    0,   0		    ; DATA XREF: seg000:B51Do
				db  0Ch,   0
				db    7,   0
				db    6,0C0h
				db    2,0B0h
				db  33h, 6Ch
				db  6Ch,0D4h
				db  6Bh, 36h
				db 0DAh,0CEh
				db 0D6h,0F3h
				db  35h,0ECh
				db  0Dh,0DCh
				db    3,0D0h
				db    0, 80h
				db    0,   0
bitmap_wiresnips		db    0,   0		    ; DATA XREF: seg000:item_definitionso
				db    0, 18h
				db    0, 36h
				db    0, 60h
				db    3,0FBh
				db  0Eh, 6Eh
				db  30h,0E0h
				db 0C1h, 80h
				db    6,   0
				db  18h,   0
				db    0,   0
mask_shovelkey			db 0FFh,0FDh		    ; DATA XREF: seg000:B511o
							    ; seg000:B541o ...
				db 0FFh,0F8h
				db 0FFh,0E0h
				db 0FFh, 80h
				db 0FFh,   1
				db 0CCh,   1
				db  80h,   3
				db    0, 0Fh
				db    0, 3Fh
				db    0,0FFh
				db    0, 7Fh
				db 0E0h, 7Fh
				db 0F8h,0FFh
mask_lockpick			db 0FCh, 3Fh		    ; DATA XREF: seg000:B517o
				db 0FCh, 0Fh
				db 0F0h,   7
				db 0C0h, 0Fh
				db    3, 1Fh
				db    7,0BFh
				db  1Ch,0E7h
				db  30h,   3
				db 0C0h,   7
				db  80h,   8
				db  80h, 30h
				db  80h,0C0h
				db  83h,   1
				db 0CCh,   0
				db 0F8h, 11h
				db 0F8h, 3Bh
mask_compass			db 0F8h, 1Fh		    ; DATA XREF: seg000:B565o
				db 0E0h,   7
				db 0C0h,   3
				db  80h,   1
				db    0,   0
				db    0,   0
				db  80h,   1
				db    0,   0
				db  80h,   1
				db 0C0h,   3
				db 0E0h,   7
				db 0F8h, 1Fh
mask_purse			db 0FEh, 7Fh		    ; DATA XREF: seg000:B55Fo
				db 0F8h, 3Fh
				db 0F0h, 1Fh
				db 0F8h, 3Fh
				db 0FCh, 3Fh
				db 0F8h, 3Fh
				db 0F0h, 1Fh
				db 0E0h, 0Fh
				db 0E0h, 0Fh
				db 0E0h, 0Fh
				db 0F0h, 1Fh
				db 0F8h, 3Fh
mask_papers			db 0F3h,0FFh		    ; DATA XREF: seg000:B51Do
				db 0E0h,0FFh
				db 0F0h, 3Fh
				db 0F0h, 0Fh
				db 0C8h,   3
				db  80h,   1
				db    0,   1
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db 0C0h,   1
				db 0F0h,   3
				db 0FCh, 2Fh
				db 0FFh, 7Fh
mask_wiresnips			db 0FFh,0E7h		    ; DATA XREF: seg000:item_definitionso
				db 0FFh,0C1h
				db 0FFh, 80h
				db 0FCh,   0
				db 0F0h,   0
				db 0C0h,   0
				db    0,   1
				db    8, 1Fh
				db  20h, 7Fh
				db 0C1h,0FFh
				db 0E7h,0FFh
bitmap_food			db    0, 30h		    ; DATA XREF: seg000:B535o
				db    0,   0
				db    0, 30h
				db    0, 30h
				db  0Eh, 78h
				db  1Fh,0B8h
				db    7, 38h
				db  18h,0B8h
				db  1Eh, 38h
				db  19h, 98h
				db  17h,0E0h
				db  19h,0F8h
				db    6, 60h
				db    7, 98h
				db    1,0F8h
				db    0, 60h
bitmap_poison			db    0,   0		    ; DATA XREF: seg000:B53Bo
				db    0, 80h
				db    0, 80h
				db    1, 40h
				db    1,0C0h
				db    0, 80h
				db    1, 40h
				db    3,0E0h
				db    6, 30h
				db    6,0B0h
				db    6, 30h
				db    6,0F0h
				db    6,0F0h
				db    7,0F0h
				db    5,0D0h
				db    3,0E0h
bitmap_torch			db    0,   0		    ; DATA XREF: seg000:B523o
				db    0,   8
				db    0, 3Ch
				db    2,0FCh
				db  0Dh, 70h
				db  1Eh,0A0h
				db  1Eh, 80h
				db  16h, 80h
				db  16h, 80h
				db  16h,   0
				db  0Ch,   0
				db    0,   0
bitmap_uniform			db    1,0E0h		    ; DATA XREF: seg000:B52Fo
				db    7,0F0h
				db  0Fh,0F8h
				db  0Fh,0F8h
				db  1Fh,0FCh
				db  0Fh,0F3h
				db 0F3h,0CCh
				db  3Ch, 30h
				db  0Fh,0CFh
				db 0F3h, 3Ch
				db  3Ch,0F0h
				db  0Fh,0CFh
				db 0F3h, 3Ch
				db  3Ch,0F0h
				db  0Fh,0C0h
				db    3,   0
bitmap_bribe			db    0,   0		    ; DATA XREF: seg000:B529o
				db    0,   0
				db    3,   0
				db  0Fh,0C0h
				db  3Fh, 30h
				db  4Ch,0FCh
				db 0F3h,0F2h
				db  3Ch,0CFh
				db  0Fh, 3Ch
				db    3,0F0h
				db    0,0C0h
				db    0,   0
				db    0,   0
bitmap_radio			db    0, 10h		    ; DATA XREF: seg000:B559o
				db    0, 10h
				db  38h, 10h
				db 0C6h, 10h
				db  37h, 90h
				db 0CCh, 50h
				db 0F3h, 50h
				db 0CCh,0EEh
				db 0B7h, 38h
				db 0B6h,0C6h
				db 0CFh, 36h
				db  3Eh,0D6h
				db  0Fh, 36h
				db    3,0D6h
				db    0,0F6h
				db    0, 35h
bitmap_parcel			db    0,   0		    ; DATA XREF: seg000:B553o
				db    3,   0
				db  0Eh, 40h
				db  39h,0F0h
				db 0E7h,0E4h
				db  1Fh, 9Fh
				db  8Eh, 7Ch
				db 0B1h,0F3h
				db 0B8h,0CFh
				db 0BBh, 37h
				db 0BBh, 73h
				db 0BBh, 67h
				db 0BBh, 77h
				db  3Bh, 7Ch
				db  0Bh, 70h
				db    3, 40h
mask_bribe			db 0FCh,0FFh		    ; DATA XREF: seg000:B529o
				db 0F0h, 3Fh
				db 0C0h, 0Fh
				db  80h,   3
				db  80h,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db 0C0h,   0
				db 0F0h,   0
				db 0FCh,   0
				db 0FFh,   3
				db 0FFh,0CFh
mask_uniform			db 0F8h, 0Fh		    ; DATA XREF: seg000:B52Fo
				db 0F0h,   7
				db 0E0h,   3
				db 0E0h,   3
				db 0C0h,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   3
				db 0C0h, 0Fh
				db 0F0h, 3Fh
mask_parcel			db 0FCh,0FFh		    ; DATA XREF: seg000:B553o
				db 0F0h, 3Fh
				db 0C0h, 0Fh
				db    0,   3
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db    0,   0
				db 0C0h,   3
				db 0F0h, 0Fh
mask_poison			db 0FFh, 7Fh		    ; DATA XREF: seg000:B53Bo
				db 0FEh, 3Fh
				db 0FEh, 3Fh
				db 0FCh, 1Fh
				db 0FCh, 1Fh
				db 0FEh, 3Fh
				db 0FCh, 1Fh
				db 0F8h, 0Fh
				db 0F0h,   7
				db 0F0h,   7
				db 0F0h,   7
				db 0F0h,   7
				db 0F0h,   7
				db 0F0h,   7
				db 0F0h,   7
				db 0F8h, 0Fh
mask_torch			db 0FFh,0F7h		    ; DATA XREF: seg000:B523o
				db 0FFh,0C3h
				db 0FDh,   1
				db 0F0h,   1
				db 0E0h,   3
				db 0C0h, 0Fh
				db 0C0h, 1Fh
				db 0C0h, 3Fh
				db 0C0h, 3Fh
				db 0C0h, 7Fh
				db 0E1h,0FFh
				db 0F3h,0FFh
mask_radio			db 0FFh,0C7h		    ; DATA XREF: seg000:B559o
				db 0C7h,0C7h
				db    1,0C7h
				db    0, 47h
				db    0,   7
				db    0,   7
				db    0,   1
				db    0,   0
				db    0,   1
				db    0,   0
				db    0,   0
				db    0,   0
				db 0C0h,   0
				db 0F0h,   0
				db 0FCh,   0
				db 0FFh,   1
mask_food			db 0FFh, 87h		    ; DATA XREF: seg000:B535o
				db 0FFh,0CFh
				db 0FFh, 87h
				db 0F1h, 87h
				db 0E0h,   3
				db 0C0h,   3
				db 0E0h,   3
				db 0C0h,   3
				db 0C0h,   3
				db 0C0h,   3
				db 0C0h,   7
				db 0C0h,   3
				db 0E0h,   7
				db 0F0h,   3
				db 0F8h,   3
				db 0FEh,   7
exterior_mask_0			db 2Ah,	0A0h, 0, 5, 7, 8, 9, 1,	0Ah, 0A2h, 0, 5, 6, 4, 85h, 1, 0Bh, 9Fh, 0, 5, 6, 4, 88h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 1, 0Ch, 9Ch,	0, 5, 6, 4, 8Ah, 1, 0Dh, 0Eh, 99h, 0, 5, 6, 4, 8Dh, 1, 0Fh, 10h, 96h, 0
				db 5, 6, 4, 90h, 1, 11h, 94h, 0, 5, 6, 4, 92h, 1, 12h, 92h, 0, 5, 6, 4,	94h, 1,	12h, 90h
				db 0, 5, 6, 4, 96h, 1, 12h, 8Eh, 0, 5, 6, 4, 98h, 1, 12h, 8Ch, 0, 5, 6,	4, 9Ah,	1, 12h,	8Ah
				db 0, 5, 6, 4, 9Ch, 1, 12h, 88h, 0, 5, 6, 4, 9Eh, 1, 18h, 86h, 0, 5, 6,	4, 0A1h, 1, 84h
				db 0, 5, 6, 4, 0A3h, 1,	0, 0, 5, 6, 4, 0A5h, 1,	5, 3, 4, 0A7h, 1, 2, 0A9h, 1, 2, 0A9h, 1
				db 2, 0A9h, 1, 2, 0A9h,	1, 2, 0A9h, 1, 2, 0A9h,	1, 2, 0A9h, 1, 2, 0A9h,	1, 2, 0A9h, 1
exterior_mask_1			db 12h,	2, 91h,	1, 2, 91h, 1, 2, 91h, 1, 2, 91h, 1, 2, 91h, 1, 2, 91h, 1, 2, 91h, 1, 2,	91h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 1, 2, 91h, 1, 2, 91h, 1
exterior_mask_2			db 10h,	13h, 14h, 15h, 8Dh, 0, 16h, 17h, 18h, 17h, 15h,	8Bh, 0,	19h, 1Ah, 1Bh, 17h, 18h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 17h,	15h, 89h, 0, 19h, 1Ah, 1Ch, 1Ah, 1Bh, 17h, 18h,	17h, 15h, 87h, 0, 19h, 1Ah, 1Ch
				db 1Ah,	1Ch, 1Ah, 1Bh, 17h, 13h, 14h, 15h, 85h,	0, 19h,	1Ah, 1Ch, 1Ah, 1Ch, 1Ah, 1Ch, 1Dh
				db 16h,	17h, 18h, 17h, 15h, 83h, 0, 19h, 1Ah, 1Ch, 1Ah,	1Ch, 1Ah, 1Ch, 1Dh, 19h, 1Ah, 1Bh
				db 17h,	18h, 17h, 15h, 0, 19h, 1Ah, 1Ch, 1Ah, 1Ch, 1Ah,	1Ch, 1Dh, 19h, 1Ah, 1Ch, 1Ah, 1Bh
				db 17h,	18h, 17h, 0, 20h, 1Ch, 1Ah, 1Ch, 1Ah, 1Ch, 1Dh,	19h, 1Ah, 1Ch, 1Ah, 1Ch, 1Ah, 1Bh
				db 17h,	83h, 0,	20h, 1Ch, 1Ah, 1Ch, 1Dh, 19h, 1Ah, 1Ch,	1Ah, 1Ch, 1Ah, 1Ch, 1Dh, 85h, 0
				db 20h,	1Ch, 1Dh, 19h, 1Ah, 1Ch, 1Ah, 1Ch, 1Ah,	1Ch, 1Dh, 87h, 0, 1Fh, 19h, 1Ah, 1Ch, 1Ah
				db 1Ch,	1Ah, 1Ch, 1Dh, 89h, 0, 20h, 1Ch, 1Ah, 1Ch, 1Ah,	1Ch, 1Dh, 8Bh, 0, 20h, 1Ch, 1Ah
				db 1Ch,	1Dh, 8Dh, 0, 20h, 1Ch, 1Dh, 8Fh, 0, 1Fh
exterior_mask_3			db 1Ah,	88h, 0,	5, 4Ch,	90h, 0,	86h, 0,	5, 6, 4, 32h, 30h, 4Ch,	8Eh, 0,	84h, 0,	5, 6, 4
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 84h,	1, 32h,	30h, 4Ch, 8Ch, 0, 0, 0,	5, 6, 4, 88h, 1, 32h, 30h, 4Ch,	8Ah, 0,	0, 6, 4
				db 8Ch,	1, 32h,	30h, 4Ch, 88h, 0, 2, 90h, 1, 32h, 30h, 4Ch, 86h, 0, 2, 92h, 1, 32h, 30h
				db 4Ch,	84h, 0,	2, 94h,	1, 32h,	30h, 4Ch, 0, 0,	2, 96h,	1, 32h,	30h, 0,	2, 98h,	1, 12h,	2
				db 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1
				db 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h,	2, 98h,	1, 12h
exterior_mask_4			db 0Dh,	2, 8Ch,	1, 2, 8Ch, 1, 2, 8Ch, 1, 2, 8Ch, 1
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
exterior_mask_5			db 0Eh,	2, 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2, 8Ch,	1, 12h,	2, 8Dh,	1, 2, 8Dh, 1
exterior_mask_6			db 8,'[Z†',0,1,1,'[Z„',0,'„',1,'[Z',0,0,'†',1,'[ZØ',1
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
exterior_mask_7			db 9, 88h, 1, 12h, 88h,	1, 12h,	88h, 1,	12h, 88h, 1, 12h, 88h, 1, 12h, 88h, 1, 12h, 88h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 1, 12h, 88h,	1, 12h
exterior_mask_8			db 10h,	8Dh, 0,	23h, 24h, 25h, 8Bh, 0, 23h, 26h, 27h, 26h, 28h,	89h, 0,	23h, 26h, 27h, 26h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 22h,	29h, 2Ah, 87h, 0, 23h, 26h, 27h, 26h, 22h, 29h,	2Bh, 29h, 2Ah, 85h, 0, 23h, 24h
				db 25h,	26h, 22h, 29h, 2Bh, 29h, 2Bh, 29h, 2Ah,	83h, 0,	23h, 26h, 27h, 26h, 28h, 2Fh, 2Bh
				db 29h,	2Bh, 29h, 2Bh, 29h, 2Ah, 0, 23h, 26h, 27h, 26h,	22h, 29h, 2Ah, 2Fh, 2Bh, 29h, 2Bh
				db 29h,	2Bh, 29h, 2Ah, 26h, 27h, 26h, 22h, 29h,	2Bh, 29h, 2Ah, 2Fh, 2Bh, 29h, 2Bh, 29h,	2Bh
				db 29h,	2Ah, 26h, 22h, 29h, 2Bh, 29h, 2Bh, 29h,	2Ah, 2Fh, 2Bh, 29h, 2Bh, 29h, 2Bh, 31h,	2Dh
				db 2Fh,	2Bh, 29h, 2Bh, 29h, 2Bh, 29h, 2Ah, 2Fh,	2Bh, 29h, 2Bh, 31h, 83h, 0, 2Fh, 2Bh, 29h
				db 2Bh,	29h, 2Bh, 29h, 2Ah, 2Fh, 2Bh, 31h, 85h,	0, 2Fh,	2Bh, 29h, 2Bh, 29h, 2Bh, 29h, 2Ah
				db 2Eh,	87h, 0,	2Fh, 2Bh, 29h, 2Bh, 29h, 2Bh, 31h, 2Dh,	88h, 0,	2Fh, 2Bh, 29h, 2Bh, 31h
				db 8Bh,	0, 2Fh,	2Bh, 31h, 8Dh, 0, 2Eh, 8Fh, 0
exterior_mask_9			db 0Ah,	83h, 0,	5, 6, 30h, 4Ch,	83h, 0,	0, 5, 6, 4, 1, 1, 32h, 30h, 4Ch, 0, 34h, 4, 86h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 1, 32h, 33h,	83h, 0,	40h, 1,	1, 3Fh,	83h, 0,	2, 46h,	47h, 48h, 49h, 42h, 41h, 45h, 44h
				db 12h,	34h, 1,	1, 46h,	4Bh, 43h, 44h, 1, 1, 33h, 0, 3Ch, 3Eh, 40h, 1, 1, 3Fh, 37h, 39h
				db 0, 83h, 0, 3Dh, 3Ah,	3Bh, 38h, 83h, 0
exterior_mask_10		db 8, 35h, 86h,	1, 36h,	90h, 1,	88h, 0,	3Ch, 86h, 0, 39h, 3Ch, 0, 2, 36h, 35h, 12h, 0, 39h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 3Ch,	0, 2, 1, 1, 12h, 0, 39h, 3Ch, 0, 2, 1, 1, 12h, 0, 39h, 3Ch, 0, 2, 1, 1,	12h, 0,	39h
				db 3Ch,	0, 2, 1, 1, 12h, 0, 39h, 3Ch, 0, 2, 1, 1, 12h, 0, 39h, 3Ch, 0, 2, 1, 1,	12h, 0,	39h
				db 3Ch,	0, 2, 1, 1, 12h, 0, 39h
exterior_mask_11		db 8, 1, 4Fh, 86h, 0, 1, 50h, 1, 4Fh, 84h, 0, 1, 0, 0, 51h, 1, 4Fh, 0, 0, 1, 0,	0, 53h,	19h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 50h,	1, 4Fh,	1, 0, 0, 53h, 19h, 0, 0, 52h, 1, 0, 0, 53h, 19h, 0, 0, 52h, 1, 54h, 0, 53h
				db 19h,	0, 0, 52h, 83h,	0, 55h,	19h, 0,	0, 52h,	85h, 0,	54h, 0,	52h
exterior_mask_12		db 2, 56h, 57h,	56h, 57h, 58h, 59h, 58h, 59h, 58h, 59h,	58h, 59h, 58h, 59h, 58h, 59h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
exterior_mask_13		db 5, 0, 0, 23h, 24h, 25h, 2, 0, 27h, 26h, 28h,	2, 0, 22h, 26h,	28h, 2,	0, 2Bh,	29h, 2Ah
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 2, 0, 2Bh, 29h, 2Ah,	2, 0, 2Bh, 29h,	2Ah, 2,	0, 2Bh,	29h, 2Ah, 2, 0,	2Bh, 29h, 2Ah, 2
				db 0, 2Bh, 31h,	0, 2, 0, 83h, 0
exterior_mask_14		db 4, 19h, 83h,	0, 19h,	17h, 15h, 0, 19h, 17h, 18h, 17h, 19h, 1Ah, 1Bh,	17h, 19h, 1Ah, 1Ch
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 1Dh,	19h, 1Ah, 1Ch, 1Dh, 19h, 1Ah, 1Ch, 1Dh,	19h, 1Ah, 1Ch, 1Dh, 19h, 1Ah, 1Ch, 1Dh,	0
				db 20h,	1Ch, 1Dh
interior_mask_15		db 2, 4, 32h, 1, 1	    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_16		db 9, 86h, 0, 5Dh, 5Ch,	54h, 84h, 0, 5Dh, 5Ch, 1, 1, 1,	0, 0, 5Dh, 5Ch,	85h, 1,	5Dh, 5Ch
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 87h,	1, 2Bh,	88h, 1
interior_mask_17		db 5, 0, 0, 5Dh, 5Ch, 67h, 5Dh,	5Ch, 83h, 1, 3Ch, 84h, 1
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_18		db 2, 5Dh, 68h,	3Ch, 69h    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_19		db 0Ah,	86h, 0,	5Dh, 5Ch, 46h, 47h, 84h, 0, 5Dh, 5Ch, 83h, 1, 39h, 0, 0, 5Dh, 5Ch, 86h,	1
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 5Dh,	5Ch, 88h, 1, 4Ah, 89h, 1
interior_mask_20		db 6, 5Dh, 5Ch,	1, 47h,	6Ah, 0,	4Ah, 84h, 1, 6Bh, 0, 84h, 1, 5Fh
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_21		db 4, 5, 4Ch, 0, 0, 61h, 65h, 66h, 4Ch,	61h, 12h, 2, 60h, 61h, 12h, 2, 60h, 61h, 12h, 2
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 60h,	61h, 12h, 2, 60h
interior_mask_22		db 4, 0, 0, 5, 4Ch, 5, 63h, 64h, 60h, 61h, 12h,	2, 60h,	61h, 12h, 2, 60h, 61h, 12h, 2, 60h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 61h,	12h, 2,	60h, 61h, 12h, 62h, 0
interior_mask_23		db 3, 0, 6Ch, 0, 2, 1, 68h, 2, 1, 69h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_24		db 5, 1, 5Eh, 4Ch, 0, 0, 1, 1, 32h, 30h, 0, 84h, 1, 5Fh
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_25		db 2, 6Eh, 5Ah,	6Dh, 39h, 3Ch, 39h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_26		db 4, 5Dh, 5Ch,	46h, 47h, 4Ah, 1, 1, 39h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_27		db 3, 2Ch, 47h,	0, 0, 61h, 12h,	0, 61h,	12h
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_28		db 3, 0, 45h, 1Eh, 2, 60h, 0, 2, 60h, 0
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
interior_mask_29		db 5, 45h, 1Eh,	2Ch, 47h, 0, 2Ch, 47h, 45h, 1Eh, 12h, 0, 61h, 12h, 61h,	12h, 0,	61h, 5Fh
							    ; DATA XREF: seg000:exterior_mask_data_pointerso
				db 0, 0
interior_mask_data_source	mask7 <1Bh, <123, 127, 241, 243>, <54, 40>>
							    ; DATA XREF: setup_room+50o
				mask7 <1Bh, <119, 123, 243, 245>, <54, 24>>
				mask7 <1Bh, <124, 128, 241, 243>, <50, 42>>
				mask7 <19h, <131, 134, 242, 247>, <24, 36>>
				mask7 <19h, <129, 132, 244, 249>, <24, 26>>
				mask7 <19h, <129, 132, 243, 248>, <28, 23>>
				mask7 <19h, <131, 134, 244, 248>, <22, 32>>
				mask7 <18h, <125, 128, 244, 249>, <24, 26>>
				mask7 <18h, <123, 126, 243, 248>, <34, 26>>
				mask7 <18h, <121, 124, 244, 249>, <34, 16>>
				mask7 <18h, <123, 126, 244, 249>, <28, 23>>
				mask7 <18h, <121, 124, 241, 246>, <44, 30>>
				mask7 <18h, <125, 128, 242, 247>, <36, 34>>
				mask7 <1Dh, <127, 130, 246, 247>, <28, 30>>
				mask7 <1Dh, <130, 133, 242, 243>, <35, 48>>
				mask7 <1Dh, <134, 137, 242, 243>, <28, 55>>
				mask7 <1Dh, <134, 137, 244, 245>, <24, 48>>
				mask7 <1Dh, <128, 131, 241, 242>, <40, 48>>
				mask7 <1Ch, <129, 130, 244, 246>, <28, 32>>
				mask7 <1Ch, <131, 132, 244, 246>, <28, 46>>
				mask7 <1Ah, <126, 128, 245, 247>, <28, 32>>
				mask7 <12h, <122, 123, 242, 243>, <58, 40>>
				mask7 <12h, <122, 123, 239, 240>, <69, 53>>
				mask7 <17h, <128, 133, 244, 246>, <28, 36>>
				mask7 <14h, <128, 132, 243, 245>, <38, 40>>
				mask7 <15h, <132, 133, 246, 247>, <26, 30>>
				mask7 <15h, <126, 127, 243, 244>, <46, 38>>
				mask7 <16h, <124, 133, 239, 243>, <50, 34>>
				mask7 <16h, <121, 130, 240, 244>, <52, 26>>
				mask7 <16h, <125, 134, 242, 246>, <36, 26>>
				mask7 <10h, <118, 120, 245, 247>, <54, 10>>
				mask7 <10h, <122, 124, 243, 245>, <54, 10>>
				mask7 <10h, <126, 128, 241, 243>, <54, 10>>
				mask7 <10h, <130, 132, 239, 241>, <54, 10>>
				mask7 <10h, <134, 136, 237, 239>, <54, 10>>
				mask7 <10h, <138, 140, 235, 237>, <54, 10>>
				mask7 <11h, <115, 117, 235, 237>, <10, 48>>
				mask7 <11h, <119, 121, 237, 239>, <10, 48>>
				mask7 <11h, <123, 125, 239, 241>, <10, 48>>
				mask7 <11h, <127, 129, 241, 243>, <10, 48>>
				mask7 <11h, <131, 133, 243, 245>, <10, 48>>
				mask7 <11h, <135, 137, 245, 247>, <10, 48>>
				mask7 <10h, <132, 134, 244, 247>, <10, 48>>
				mask7 <11h, <135, 137, 237, 239>, <10, 48>>
				mask7 <11h, <123, 125, 243, 245>, <10, 10>>
				mask7 <11h, <121, 123, 244, 246>, <10, 10>>
				mask7 <0Fh, <136, 140, 245, 248>, <10, 10>>
exterior_mask_data_pointers	dw offset exterior_mask_0   ; 0	; DATA XREF: mask_stuff+139o
				dw offset exterior_mask_1   ; 1	; "\b[Z†\x01\x01[Z„„\x01[Z†\x01[ZØ\x01"
				dw offset exterior_mask_2   ; 2
				dw offset exterior_mask_3   ; 3
				dw offset exterior_mask_4   ; 4
				dw offset exterior_mask_5   ; 5
				dw offset exterior_mask_6   ; 6
				dw offset exterior_mask_7   ; 7
				dw offset exterior_mask_8   ; 8
				dw offset exterior_mask_9   ; 9
				dw offset exterior_mask_10  ; 10
				dw offset exterior_mask_11  ; 11
				dw offset exterior_mask_13  ; 12
				dw offset exterior_mask_14  ; 13
				dw offset exterior_mask_12  ; 14
				dw offset interior_mask_29  ; 15
				dw offset interior_mask_27  ; 16
				dw offset interior_mask_28  ; 17
				dw offset interior_mask_15  ; 18
				dw offset interior_mask_16  ; 19
				dw offset interior_mask_17  ; 20
				dw offset interior_mask_18  ; 21
				dw offset interior_mask_19  ; 22
				dw offset interior_mask_20  ; 23
				dw offset interior_mask_21  ; 24
				dw offset interior_mask_22  ; 25
				dw offset interior_mask_23  ; 26
				dw offset interior_mask_24  ; 27
				dw offset interior_mask_25  ; 28
				dw offset interior_mask_26  ; 29
exterior_mask_data		mask <0, <71, 112, 39, 63>, <106, 82, 12>>
							    ; DATA XREF: mask_stuff+23o
				mask <0, <95, 136, 51, 75>, <94, 82, 12>>
				mask <0, <119, 160, 63,	87>, <82, 82, 12>>
				mask <1, <159, 176, 40,	49>, <62, 106, 60>>
				mask <1, <159, 176, 50,	59>, <62, 106, 60>>
				mask <2, <64, 79, 76, 91>, <70,	70, 8>>
				mask <2, <80, 95, 84, 99>, <70,	70, 8>>
				mask <2, <96, 111, 92, 107>, <70, 70, 8>>
				mask <2, <112, 127, 100, 115>, <70, 70,	8>>
				mask <2, <48, 63, 84, 99>, <62,	62, 8>>
				mask <2, <64, 79, 92, 107>, <62, 62, 8>>
				mask <2, <80, 95, 100, 115>, <62, 62, 8>>
				mask <2, <96, 111, 108,	123>, <62, 62, 8>>
				mask <2, <112, 127, 116, 131>, <62, 62,	8>>
				mask <2, <16, 31, 100, 115>, <74, 46, 8>>
				mask <2, <32, 47, 108, 123>, <74, 46, 8>>
				mask <2, <48, 63, 116, 131>, <74, 46, 8>>
				mask <3, <43, 68, 51, 71>, <103, 69, 18>>
				mask <4, <43, 55, 72, 75>, <109, 69, 8>>
				mask <5, <55, 68, 72, 81>, <103, 69, 8>>
				mask <6, <8, 15, 42, 60>, <110,	70, 10>>
				mask <6, <16, 23, 46, 64>, <110, 70, 10>>
				mask <6, <24, 31, 50, 68>, <110, 70, 10>>
				mask <6, <32, 39, 54, 72>, <110, 70, 10>>
				mask <6, <40, 47, 58, 76>, <110, 70, 10>>
				mask <7, <8, 16, 31, 38>, <130,	70, 18>>
				mask <7, <8, 16, 39, 45>, <130,	70, 18>>
				mask <8, <128, 143, 100, 115>, <70, 70,	8>>
				mask <8, <144, 159, 92,	107>, <70, 70, 8>>
				mask <8, <160, 176, 84,	99>, <70, 70, 8>>
				mask <8, <176, 191, 76,	91>, <70, 70, 8>>
				mask <8, <192, 207, 68,	83>, <70, 70, 8>>
				mask <8, <128, 143, 116, 131>, <62, 62,	8>>
				mask <8, <144, 159, 108, 123>, <62, 62,	8>>
				mask <8, <160, 176, 100, 115>, <62, 62,	8>>
				mask <8, <176, 191, 92,	107>, <62, 62, 8>>
				mask <8, <192, 207, 84,	99>, <62, 62, 8>>
				mask <8, <208, 223, 76,	91>, <62, 62, 8>>
				mask <8, <64, 79, 116, 131>, <78, 46, 8>>
				mask <8, <80, 95, 108, 123>, <78, 46, 8>>
				mask <8, <16, 31, 88, 103>, <104, 46, 8>>
				mask <8, <32, 47, 80, 95>, <104, 46, 8>>
				mask <8, <48, 63, 72, 87>, <104, 46, 8>>
				mask <9, <27, 36, 78, 85>, <104, 55, 15>>
				mask <0Ah, <28,	35, 81,	93>, <104, 56, 10>>
				mask <9, <59, 68, 114, 121>, <78, 45, 15>>
				mask <0Ah, <60,	67, 117, 129>, <78, 46,	10>>
				mask <9, <123, 132, 98,	105>, <70, 69, 15>>
				mask <0Ah, <124, 131, 101, 113>, <70, 70, 10>>
				mask <9, <171, 180, 74,	81>, <70, 93, 15>>
				mask <0Ah, <172, 179, 77, 89>, <70, 94,	10>>
				mask <0Bh, <88,	95, 90,	98>, <70, 70, 8>>
				mask <0Bh, <72,	79, 98,	106>, <62, 62, 8>>
				mask <0Ch, <11,	15, 96,	103>, <104, 46,	8>>
				mask <0Dh, <12,	15, 97,	106>, <78, 46, 8>>
				mask <0Eh, <127, 128, 124, 131>, <62, 62, 8>>
				mask <0Dh, <44,	47, 81,	90>, <62, 62, 8>>
				mask <0Dh, <60,	63, 73,	82>, <70, 70, 8>>
door_positions			db    1,0B2h, 8Ah,   6	    ; 0
							    ; DATA XREF: door_handling:loc_7B5Eo
							    ; setup_doors+17o
				db    3,0B2h, 8Eh,   6	    ; 4
				db    1,0B2h, 7Ah,   6	    ; 8
				db    3,0B2h, 7Eh,   6	    ; 12
				db  88h, 8Ah,0B3h,   6	    ; 16
				db    2, 10h, 34h, 0Ch	    ; 20
				db 0C0h,0CCh, 79h,   6	    ; 24
				db    2, 10h, 34h, 0Ch	    ; 28
				db  71h,0D9h,0A3h,   6	    ; 32
				db    3, 2Ah, 1Ch, 18h	    ; 36
				db    4,0D4h,0BDh,   6	    ; 40
				db    2, 1Eh, 2Eh, 18h	    ; 44
				db    9,0C1h,0A3h,   6	    ; 48
				db    3, 2Ah, 1Ch, 18h	    ; 52
				db  0Ch,0BCh,0BDh,   6	    ; 56
				db    2, 20h, 2Eh, 18h	    ; 60
				db  11h,0A9h,0A3h,   6	    ; 64
				db    3, 2Ah, 1Ch, 18h	    ; 68
				db  14h,0A4h,0BDh,   6	    ; 72
				db    2, 20h, 2Eh, 18h	    ; 76
				db  54h,0FCh,0CAh,   6	    ; 80
				db    2, 1Ch, 24h, 18h	    ; 84
				db  50h,0FCh,0DAh,   6	    ; 88
				db    2, 1Ah, 22h, 18h	    ; 92
				db  3Dh,0F7h,0E3h,   6	    ; 96
				db    3, 26h, 19h, 18h	    ; 100
				db  35h,0DFh,0E3h,   6	    ; 104
				db    3, 2Ah, 1Ch, 18h	    ; 108
				db  21h, 97h,0D3h,   6	    ; 112
				db    3, 2Ah, 15h, 18h	    ; 116
				db  19h,   0,	0,   0	    ; 120
				db    3, 22h, 22h, 18h	    ; 124
				db    5, 2Ch, 34h, 18h	    ; 128
				db  73h, 26h, 1Ah, 18h	    ; 132
				db  0Dh, 24h, 36h, 18h	    ; 136
				db  0Bh, 26h, 1Ah, 18h	    ; 140
				db  15h, 24h, 36h, 18h	    ; 144
				db  13h, 26h, 1Ah, 18h	    ; 148
				db  5Dh, 28h, 42h, 18h	    ; 152
				db  67h, 26h, 18h, 18h	    ; 156
				db  5Ch, 3Eh, 24h, 18h	    ; 160
				db  56h, 20h, 2Eh, 18h	    ; 164
				db  4Dh, 22h, 42h, 18h	    ; 168
				db  5Fh, 22h, 1Ch, 18h	    ; 172
				db  49h, 24h, 36h, 18h	    ; 176
				db  4Fh, 38h, 22h, 18h	    ; 180
				db  55h, 2Ch, 36h, 18h	    ; 184
				db  5Bh, 22h, 1Ch, 18h	    ; 188
				db  59h, 2Ch, 36h, 18h	    ; 192
				db  63h, 2Ah, 26h, 18h	    ; 196
				db  31h, 42h, 3Ah, 18h	    ; 200
				db  4Bh, 22h, 1Ch, 18h	    ; 204
				db  44h, 3Ch, 24h, 18h	    ; 208
				db  1Eh, 1Ch, 22h, 18h	    ; 212
				db  3Ch, 40h, 28h, 18h	    ; 216
				db  3Ah, 1Eh, 28h, 18h	    ; 220
				db  41h, 22h, 42h, 18h	    ; 224
				db  3Bh, 22h, 1Ch, 18h	    ; 228
				db  40h, 3Eh, 2Eh, 18h	    ; 232
				db  36h, 1Ah, 22h, 18h	    ; 236
				db    0, 44h, 30h, 18h	    ; 240
				db    2, 20h, 30h, 18h	    ; 244
				db  34h, 4Ah, 28h, 18h	    ; 248
				db  2Eh, 1Ah, 22h, 18h	    ; 252
				db  1Ch, 40h, 24h, 18h	    ; 256
				db  42h, 1Ah, 22h, 18h	    ; 260
				db  28h, 36h, 35h, 18h	    ; 264
				db  22h, 17h, 26h, 18h	    ; 268
				db  24h, 36h, 1Ch, 18h	    ; 272
				db  22h, 1Ah, 22h, 18h	    ; 276
				db  30h, 3Eh, 24h, 18h	    ; 280
				db  46h, 1Ah, 22h, 18h	    ; 284
				db  75h, 36h, 36h, 18h	    ; 288
				db  27h, 38h, 0Ah, 0Ch	    ; 292
				db 0D1h, 38h, 62h, 0Ch	    ; 296
				db  7Bh, 38h, 0Ah, 0Ch	    ; 300
				db  78h, 64h, 34h, 0Ch	    ; 304
				db  7Eh, 38h, 26h, 0Ch	    ; 308
				db  79h, 38h, 62h, 0Ch	    ; 312
				db  93h, 38h, 0Ah, 0Ch	    ; 316
				db  7Ch, 64h, 34h, 0Ch	    ; 320
				db  82h, 0Ah, 34h, 0Ch	    ; 324
				db  81h, 38h, 62h, 0Ch	    ; 328
				db  87h, 20h, 34h, 0Ch	    ; 332
				db  85h, 40h, 34h, 0Ch	    ; 336
				db  8Fh, 38h, 0Ah, 0Ch	    ; 340
				db  8Ch, 64h, 34h, 0Ch	    ; 344
				db  8Ah, 0Ah, 34h, 0Ch	    ; 348
				db  90h, 64h, 34h, 0Ch	    ; 352
				db  8Eh, 38h, 1Ch, 0Ch	    ; 356
				db  94h, 3Eh, 22h, 18h	    ; 360
				db  0Ah, 10h, 34h, 0Ch	    ; 364
				db  98h, 64h, 34h, 0Ch	    ; 368
				db  96h, 10h, 34h, 0Ch	    ; 372
				db  9Dh, 40h, 34h, 0Ch	    ; 376
				db  9Bh, 20h, 34h, 0Ch	    ; 380
				db 0A0h, 64h, 34h, 0Ch	    ; 384
				db  9Ah, 38h, 54h, 0Ch	    ; 388
				db 0A1h, 38h, 62h, 0Ch	    ; 392
				db 0A7h, 38h, 0Ah, 0Ch	    ; 396
				db 0A4h, 64h, 34h, 0Ch	    ; 400
				db 0AAh, 38h, 26h, 0Ch	    ; 404
				db 0A5h, 38h, 62h, 0Ch	    ; 408
				db 0B7h, 38h, 0Ah, 0Ch	    ; 412
				db 0B4h, 64h, 34h, 0Ch	    ; 416
				db 0B2h, 38h, 1Ch, 0Ch	    ; 420
				db 0ADh, 20h, 34h, 0Ch	    ; 424
				db 0B3h, 38h, 0Ah, 0Ch	    ; 428
				db 0A9h, 38h, 62h, 0Ch	    ; 432
				db 0AFh, 20h, 34h, 0Ch	    ; 436
				db 0B8h, 64h, 34h, 0Ch	    ; 440
				db  9Eh, 38h, 1Ch, 0Ch	    ; 444
				db 0BDh, 38h, 62h, 0Ch	    ; 448
				db 0BBh, 20h, 34h, 0Ch	    ; 452
				db 0C8h, 64h, 34h, 0Ch	    ; 456
				db 0BEh, 38h, 56h, 0Ch	    ; 460
				db 0C9h, 38h, 62h, 0Ch	    ; 464
				db 0C7h, 38h, 0Ah, 0Ch	    ; 468
				db 0C4h, 64h, 34h, 0Ch	    ; 472
				db 0C2h, 38h, 1Ch, 0Ch	    ; 476
				db 0CDh, 38h, 62h, 0Ch	    ; 480
				db  77h, 20h, 34h, 0Ch	    ; 484
				db 0D0h, 64h, 34h, 0Ch	    ; 488
				db 0CEh, 38h, 54h, 0Ch	    ; 492
solitary_pos			db 3Ah,2Ah,18h		    ; 0
							    ; DATA XREF: character_behaviour+432Co
exterior_tiles_0		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
							    ; DATA XREF: mask_against_tile+1o
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0FEh, 0FEh, 0FEh, 0FEh, 0FEh, 0FEh, 0FEh, 0FEh
				db 0FFh, 0FFh, 0FFh, 0FCh, 0F0h, 0C0h, 0C0h, 0
				db 0F0h, 0C0h, 0, 0, 0,	0, 0, 0
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FCh
				db 0FFh, 0FFh, 0FFh, 0FCh, 0F0h, 0C0h, 0, 0
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0F0h, 0, 0
				db 0FFh, 0FFh, 0FFh, 0F0h, 0, 0, 0, 0
				db 0FFh, 0F0h, 0, 0, 0,	0, 0, 0
				db 7Fh,	3Fh, 1Fh, 0Fh, 7, 3, 1,	0
				db 0FFh, 7Fh, 3Fh, 1Fh,	0Fh, 7,	7, 3
				db 0FFh, 0FFh, 7Fh, 3Fh, 3Fh, 1Fh, 0Fh,	7
				db 3, 3, 1, 0, 0, 0, 0,	0
				db 0FFh, 0FFh, 0FFh, 0FFh, 7Fh,	3Fh, 1Fh, 1Fh
				db 0Fh,	7, 3, 1, 1, 0, 0, 0
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 7Fh, 3Fh
				db 3Fh,	1Fh, 3Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
				db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
				db 3, 0C0h, 0F0h, 0F0h,	0F8h, 0D8h, 0, 0
				db 0C3h, 81h, 3, 1, 3, 0, 0, 10h
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0DFh, 0Fh, 0Dh
				db 0C0h, 80h, 0, 0, 3, 7, 3, 0
				db 0FFh, 0DFh, 0Fh, 0Dh, 0, 0, 0B0h, 0F0h
				db 0, 0, 0B0h, 0F0h, 0FBh, 0DFh, 0Fh, 0Dh
				db 0, 4, 7, 7, 7, 7, 7,	3
				db 0CFh, 0Fh, 3, 80h, 90h, 9Ch,	0CFh, 0CFh
				db 0, 0, 0B0h, 0D0h, 0Bh, 0Fh, 3, 0
				db 90h,	9Ch, 0CFh, 0CFh, 0CFh, 0Fh, 0Fh, 3
				db 0Eh,	0Eh, 0Eh, 2, 90h, 9Ch, 0CEh, 0CEh
				db 0, 0, 0, 3, 0Fh, 3Fh, 0FFh, 0FFh
				db 0Eh,	0Eh, 0Eh, 2, 0B0h, 0FCh, 0FEh, 0FEh
				db 0Fh,	0Fh, 0Fh, 3, 0B0h, 0FCh, 0FFh, 0FFh
				db 0, 9Ch, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0, 0, 0Dh, 0Bh, 0D8h, 0F8h, 0C0h, 1
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FBh, 0F0h, 0B0h
				db 0C3h, 81h, 0C0h, 80h, 0C0h, 0, 0, 8
				db 0, 3, 0Fh, 0Fh, 1Fh,	1Bh, 0,	0
				db 0FFh, 0FBh, 0F0h, 0B0h, 0, 0, 0Dh, 0Fh
				db 0, 0, 0Dh, 0Fh, 0DFh, 0FBh, 0F0h, 0B0h
				db 0, 1, 0, 0, 0C0h, 0E0h, 0C0h, 0
				db 0F0h, 0F8h, 0F1h, 0C1h, 9, 39h, 0F3h, 0F3h
				db 0, 20h, 0E0h, 0E0h, 0E0h, 0E0h, 0E0h, 0C0h
				db 9, 39h, 0F3h, 0F3h, 0F3h, 0F0h, 0F0h, 0C0h
				db 0, 0, 0, 0C0h, 0F0h,	0FCh, 0FFh, 0FFh
				db 0, 39h, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 79h,	7Ch, 70h, 40h, 0Dh, 3Fh, 7Fh, 7Fh
				db 7Bh,	78h, 70h, 41h, 9, 39h, 73h, 73h
				db 0FFh, 0FFh, 0FFh, 3Fh, 0Fh, 3, 0, 0
				db 0F0h, 0F0h, 0C0h, 0,	0Dh, 3Fh, 0FFh,	0FFh
				db 0Fh,	3, 0, 0, 0, 0, 0, 0
				db 9Fh,	0Fh, 7,	0Fh, 0Fh, 7, 0Fh, 9Fh
				db 0F9h, 0F0h, 0E0h, 0F0h, 0F0h, 0E0h, 0F0h, 0F9h
				db 0C0h, 0C0h, 0C1h, 0C0h, 0C0h, 0C0h, 0C0h, 0
				db 3, 3, 83h, 3, 3, 3, 3, 0
				db 0, 0, 0, 0, 0, 38h, 0FEh, 0FFh
				db 0Fh,	3Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
				db 1, 1, 1, 1, 1, 1, 1,	1
				db 0, 0, 0, 0, 0, 1, 3,	3
				db 0, 0, 0, 0, 0, 80h, 0C0h, 0C0h
				db 80h,	80h, 80h, 80h, 80h, 80h, 80h, 80h
				db 0F0h, 0FCh, 0FEh, 0FEh, 0FEh, 0FEh, 0FEh, 0FEh
				db 0, 0, 0, 0, 0, 1Ch, 7Fh, 0FFh
				db 0, 0, 0, 0, 0, 0, 0,	3
				db 0, 0, 0, 0, 0, 0, 0,	0C0h
				db 0Fh,	3Fh, 0FFh, 0FFh, 0FFh, 0FFh, 0FCh, 0F0h
				db 0, 0, 0, 3, 1, 3, 7,	1Fh
				db 1Fh,	1Fh, 1Ch, 10h, 0, 0, 0,	0
				db 0C0h, 0, 0, 0, 0, 0,	0, 0
				db 0FFh, 0FFh, 0FCh, 0F0h, 0C0h, 0, 0, 0
				db 3, 0, 0, 0, 0, 0, 0,	0
				db 0FFh, 0FFh, 3Fh, 0Fh, 3, 0, 0, 0
				db 0F0h, 0FCh, 0FFh, 0FFh, 0FFh, 0FFh, 3Fh, 0Fh
				db 0, 0, 0, 0C0h, 80h, 0C0h, 0E0h, 0F0h
				db 80h,	0C0h, 0E0h, 0E0h, 0E0h,	0E0h, 0E0h, 0E0h
				db 0F8h, 0F8h, 38h, 8, 0, 0, 0,	0
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 3Fh
				db 0, 0, 1, 1, 1, 1, 1,	1
				db 0, 0, 80h, 80h, 80h,	80h, 80h, 80h
				db 3Fh,	0Fh, 3,	0, 0, 0, 0, 0
				db 0, 0, 0, 0, 10h, 1Ch, 8Fh, 8Fh
				db 0, 0, 0, 0, 10h, 1Ch, 8Ch, 8Ch
				db 0, 0, 0, 0, 0, 0, 80h, 80h
				db 0Ch,	0Ch, 0,	0, 10h,	1Ch, 8Ch, 8Ch
				db 0Fh,	0Fh, 3,	0, 0, 0C0h, 0F0h, 0FCh
				db 0Ch,	0Ch, 0,	0, 0, 0C0h, 0F0h, 0FCh
				db 0FCh, 0D8h, 8, 8, 0,	0, 0B0h, 0F8h
				db 3Fh,	1Bh, 10h, 10h, 0, 0, 0Dh, 1Fh
				db 38h,	8, 0, 0, 10h, 18h, 88h,	88h
				db 1Ch,	10h, 0,	0, 8, 18h, 11h,	11h
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 3Fh, 0Fh, 3
				db 0FFh, 3Fh, 0Fh, 3, 0, 0, 0, 0
				db 0FFh, 0FCh, 0F0h, 0C0h, 0, 0, 0, 0
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FCh, 0F0h, 0C0h
				db 3Fh,	3Fh, 1Fh, 0Fh, 0Fh, 3, 0, 0
				db 7Fh,	7Fh, 7Fh, 7Fh, 7Fh, 0FFh, 0FFh,	0FFh
				db 1Fh,	1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
				db 0F8h, 0F8h, 0F8h, 0F8h, 0F8h, 0F8h, 0F8h, 0F8h
				db 0FEh, 0FEh, 0FEh, 0FEh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FCh, 0F0h, 0C0h, 0, 3, 0Fh
				db 0C0h, 0, 2, 0Eh, 3Eh, 0FEh, 0FEh, 0FEh
				db 3, 0, 40h, 70h, 7Ch,	7Fh, 7Fh, 7Fh
				db 0FFh, 0FFh, 3Fh, 0Fh, 3, 0, 0C0h, 0F0h
				db 0FFh, 0FFh, 3Fh, 0Fh, 7, 0Fh, 0Fh, 0Fh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 3Fh, 0Fh
				db 7, 7, 7, 7, 7, 7, 7,	7
				db 0Fh,	3, 0, 10h, 18h,	8, 0, 0
				db 0FFh, 0FFh, 3Fh, 1Fh, 3Fh, 0FFh, 7Fh, 7Fh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0F3h, 0C1h, 1
				db 0FEh, 0FEh, 0FEh, 0FEh, 0FEh, 0FCh, 0F0h, 0C0h
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FEh, 0FEh
exterior_tiles_1		db 0, 0, 0, 0, 0, 0, 0,	0   ; DATA XREF: plot_tile+9o
							    ; select_tile_set+36o
				db 80h,	80h, 80h, 80h, 80h, 80h, 80h, 80h
				db 0FFh, 0F0h, 0, 8Ch, 0C3h, 0B0h, 80h,	0C0h
				db 0, 20h, 6, 0, 3, 4Ch, 3, 3Fh
				db 3, 0Ch, 30h,	0C0h, 3, 3Fh, 0FFh, 0F0h
				db 0Fh,	0F0h, 3, 3Fh, 0FFh, 0F0h, 0, 0
				db 6, 3Fh, 0FFh, 0F1h, 0, 0, 0,	0
				db 0, 40h, 0, 8, 3, 0Ch, 30h, 0C0h
				db 23h,	0Ch, 30h, 0C0h,	0Fh, 0F0h, 0Fh,	0F0h
				db 0Fh,	0F0h, 0Fh, 0F0h, 3, 0CFh, 3Fh, 0FFh
				db 3, 0CFh, 3Fh, 0FFh, 0FCh, 0F2h, 0C9h, 24h
				db 0FCh, 0F2h, 0C9h, 4,	82h, 49h, 20h, 90h
				db 0FCh, 72h, 0A9h, 0C4h, 0E2h,	75h, 78h, 38h
				db 1Ch,	0Eh, 7,	7, 3, 1, 0, 0
				db 49h,	24h, 12h, 0A9h,	0C5h, 0C4h, 0E2h, 71h
				db 38h,	3Dh, 1Eh, 0Eh, 7, 3, 1,	1
				db 92h,	4Ah, 29h, 24h, 12h, 89h, 0D4h, 0E2h
				db 0E2h, 71h, 38h, 1Ch,	1Eh, 0Fh, 7, 3
				db 49h,	24h, 92h, 49h, 0A5h, 14h, 12h, 89h
				db 1, 0, 0, 0, 0, 0, 0,	0
				db 0C4h, 0EAh, 0F1h, 71h, 38h, 1Ch, 0Eh, 0Fh
				db 7, 3, 1, 0, 5, 3, 31h, 9
				db 30h,	0, 0, 80h, 80h,	80h, 80h, 80h
				db 92h,	49h, 24h, 92h, 4Ah, 29h, 0A4h, 90h
				db 48h,	28h, 0A4h, 92h,	49h, 24h, 92h, 49h
				db 25h,	94h, 52h, 49h, 24h, 92h, 49h, 24h
				db 20h,	92h, 48h, 24h, 92h, 4Ah, 29h, 0A4h
				db 4, 92h, 41h,	21h, 90h, 50h, 49h, 24h
				db 49h,	24h, 92h, 49h, 25h, 14h, 12h, 9
				db 42h,	21h, 0A0h, 90h,	49h, 24h, 92h, 49h
				db 92h,	4Ah, 29h, 24h, 12h, 9, 24h, 82h
				db 49h,	24h, 12h, 9, 25h, 84h, 42h, 41h
				db 90h,	48h, 24h, 92h, 4Ah, 29h, 0A4h, 92h
				db 3, 0CEh, 3Eh, 0FEh, 0FCh, 0F0h, 0C6h, 20h
				db 0Ch,	0F2h, 0F5h, 0F0h, 0F0h,	0EFh, 0EFh, 0EFh
				db 6Fh,	0Fh, 6,	0, 63h,	0Ch, 0B2h, 49h
				db 92h,	49h, 24h, 92h, 4Ah, 29h, 24h, 12h
				db 69h,	0Ch, 32h, 0C9h,	5, 94h,	42h, 41h
				db 0, 10h, 0, 4, 40h, 0, 0Fh, 0F0h
				db 0, 4, 40h, 0, 0Fh, 0F0h, 3, 3Ch
				db 0, 0, 0Fh, 0F0h, 3, 0Fh, 3Fh, 0FFh
				db 3, 0CFh, 3Fh, 0FFh, 0FCh, 0F2h, 0C9h, 24h
				db 10h,	80h, 0C2h, 20h,	90h, 48h, 24h, 92h
				db 0, 8, 80h, 40h, 22h,	90h, 50h, 48h
				db 24h,	92h, 49h, 24h, 92h, 4Ah, 29h, 0A4h
				db 20h,	0, 4, 80h, 80h,	40h, 22h, 90h
				db 2, 0, 20h, 0, 2, 80h, 40h, 40h
				db 20h,	90h, 48h, 24h, 94h, 52h, 49h, 24h
				db 0, 0, 0Ch, 0, 80h, 2, 0, 80h
				db 0, 0C0h, 0, 4, 0, 0,	20h, 1
				db 94h,	52h, 49h, 24h, 93h, 4Ch, 0B3h, 0CCh
				db 93h,	4Ch, 33h, 0CEh,	32h, 0C2h, 2, 2
				db 30h,	0C0h, 0, 0, 0, 0, 0, 0
				db 94h,	52h, 49h, 24h, 93h, 4Ch, 33h, 0CCh
				db 93h,	4Ch, 33h, 0CCh,	30h, 0C0h, 0, 0
				db 93h,	4Ch, 33h, 0CCh,	32h, 0C6h, 6, 6
				db 6, 6, 6, 6, 6, 6, 6,	6
				db 30h,	0C3h, 0, 33h, 0CFh, 3Ch, 0F0h, 0C0h
				db 0CFh, 3Ch, 0F1h, 0C1h, 1, 81h, 81h, 81h
				db 0, 30h, 42h,	4, 10h,	0C3h, 8, 3
				db 30h,	0C3h, 0, 3, 4Fh, 3Ch, 0F1h, 0C1h
				db 0CEh, 3Dh, 0F3h, 0C3h, 3, 3,	3, 3
				db 3, 0Dh, 33h,	0C3h, 3, 3, 3, 3
				db 1, 81h, 81h,	81h, 83h, 8Dh, 0B1h, 0C1h
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C3h, 0CCh, 0F0h, 0C0h
				db 82h,	8Dh, 0B1h, 0C1h, 81h, 81h, 81h,	0C1h
				db 81h,	83h, 85h, 85h, 81h, 81h, 81h, 81h
				db 83h,	43h, 43h, 0, 3,	0Fh, 3Fh, 7Ch
				db 0C1h, 0C2h, 0C2h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
				db 0A1h, 0A1h, 81h, 80h, 83h, 8Fh, 0BFh, 0BCh
				db 81h,	8Eh, 0BFh, 0BCh, 71h, 0CCh, 10h, 0
				db 70h,	0C0h, 10h, 0C0h, 0Ch, 30h, 1, 7
				db 0C3h, 0CFh, 0DFh, 0DCh, 0D3h, 0C4h, 30h, 0C1h
				db 86h,	0Eh, 36h, 46h, 0Eh, 36h, 0C7h, 7
				db 8Ch,	10h, 0C1h, 7, 1Fh, 7Ch,	0F0h, 0C0h
				db 1Fh,	7Ch, 0F0h, 0C0h, 2, 0, 0, 18h
				db 1, 6, 88h, 0, 6, 18h, 21h, 7
				db 0CCh, 0D0h, 0C1h, 0C7h, 0DFh, 0FCh, 0F0h, 0C0h
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
				db 0Fh,	3Ch, 0F0h, 0C0h, 0, 0, 0, 0
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0D0h, 0DCh
				db 0C0h, 0C0h, 0C0h, 0C0h, 0, 0C0h, 0, 0C0h
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C3h, 0CFh, 0DFh
				db 0, 3, 0Fh, 3Fh, 0FCh, 0F0h, 0C3h, 0Fh
				db 0C0h, 6, 0C0h, 21h, 30h, 0C8h, 0F4h,	0CEh
				db 1, 1, 1, 1, 1, 1, 1,	1
				db 3, 0Dh, 21h,	1, 0Dh,	31h, 81h, 5
				db 1Ah,	7Bh, 0F3h, 0C3h, 3, 3, 13h, 1
				db 32h,	2, 0Ah,	12h, 0C2h, 0Ah,	32h, 42h
				db 0Ah,	12h, 82h, 0Ah, 22h, 0C2h, 0Ah, 32h
				db 0C2h, 2, 32h, 0C2h, 0Ah, 32h, 82h, 2
				db 1Ah,	7Ah, 0F2h, 0C2h, 2, 2, 2, 22h
				db 8Ch,	0B0h, 0C1h, 87h, 0DFh, 0BCh, 0B0h, 80h
				db 40h,	0D0h, 0C2h, 0C0h, 0C0h,	0C0h, 0CAh, 80h
				db 2, 3, 3, 3, 3, 3, 3,	1
				db 31h,	0Dh, 83h, 0E1h,	0FBh, 3Dh, 0Dh,	1
				db 9, 0C3h, 31h, 0Dh, 0C3h, 11h, 0Dh, 0C3h
				db 0C3h, 31h, 0Dh, 81h,	31h, 0Dh, 43h, 31h
				db 1, 9, 3, 1, 0Dh, 3, 11h, 0Dh
				db 6, 7, 0Eh, 16h, 6, 6, 16h, 6
				db 0Eh,	36h, 7,	0Eh, 26h, 46h, 0Eh, 36h
				db 0F8h, 3Eh, 0Fh, 43h,	0, 0, 4, 8
				db 3, 20h, 0Ch,	0C3h, 30h, 8, 83h, 0E0h
				db 0C0h, 0C0h, 0C0h, 0E0h, 0F8h, 3Eh, 0CFh, 0C3h
				db 0F0h, 0C8h, 0C2h, 0E0h, 0C8h, 0C0h, 0E0h, 0C0h
				db 10h,	0Ch, 82h, 0E0h,	0F8h, 3Eh, 0Fh,	3
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 30h, 0FCh
				db 58h,	0DEh, 0CFh, 0C3h, 0C0h,	0C0h, 0C8h, 84h
				db 0C0h, 0B0h, 84h, 0C0h, 0B0h,	8Ch, 81h, 0A0h
				db 4Ah,	29h, 0A4h, 92h,	49h, 24h, 92h, 49h
				db 93h,	4Ch, 33h, 0CCh,	31h, 0C1h, 1, 1
				db 3Ch,	0D0h, 0E3h, 0F7h, 0FBh,	3Ch, 0Eh, 3
				db 3Fh,	0FCh, 0F0h, 0C0h, 0, 0Ch, 0, 0
				db 3, 0, 60h, 0, 1, 0, 0, 8
				db 0, 0, 0, 0, 0, 0, 0C0h, 0C0h
				db 2, 2, 2, 2, 2, 2, 2,	2
				db 90h,	0C2h, 8Ch, 0B0h, 0C3h, 84h, 0B0h, 80h
				db 0C3h, 84h, 0B0h, 0C3h, 8Ch, 90h, 0C3h, 8Ch
				db 84h,	0B0h, 0C0h, 8Ch, 90h, 0C3h, 84h, 0B0h
				db 90h,	0C0h, 80h, 0B0h, 0C0h, 84h, 90h, 0C0h
				db 0, 0, 0, 80h, 0, 0, 0C0h, 0
				db 10h,	0C0h, 8, 30h, 80h, 0Ch,	20h, 0C0h
				db 8, 30h, 0C2h, 4, 30h, 80h, 8, 20h
				db 0, 0, 0, 0, 3, 8, 10h, 1
				db 0Ch,	10h, 0C3h, 0Ch,	20h, 3,	4, 0
				db 0, 0, 0, 10h, 0, 0Ch, 30h, 42h
				db 1, 1, 3, 1, 1, 3, 9,	1
				db 0D0h, 0C1h, 0CCh, 0D0h, 0C2h, 0CCh, 0D0h, 0C3h
				db 0C0h, 0C0h, 0D0h, 0C0h, 0C8h, 0D0h, 0C2h, 0C4h
				db 0, 10h, 0C3h, 0F0h, 0FCh, 0CFh, 0C3h, 0C0h
				db 0, 20h, 0Ch,	0C0h, 30h, 0Ch,	0C2h, 0F0h
				db 3Ch,	0Fh, 3,	0, 0, 0, 0, 0
				db 0, 0, 0D0h, 0CCh, 0C1h, 0F0h, 0CCh, 0C2h
				db 80h,	80h, 0C0h, 80h,	80h, 0C0h, 0B0h, 80h
				db 3, 0, 0Ch, 2, 30h, 0Ch, 3, 20h
				db 0, 0C0h, 30h, 0, 0C0h, 30h, 0Ch, 0C0h
				db 0Ch,	2, 0, 4, 3, 0, 0, 0
				db 20h,	0Ch, 0C0h, 30h,	8, 43h,	30h, 0Ch
				db 3, 30h, 8, 1, 0, 0, 0, 0
				db 0, 0C0h, 30h, 8, 0C0h, 0, 0,	0
				db 1, 43h, 4, 0Bh, 1Ch,	30h, 1,	2
				db 3Fh,	0Fh, 0C3h, 0F0h, 0FCh, 3Fh, 0Fh, 3
				db 0, 0C0h, 0F0h, 0FCh,	3Eh, 0Fh, 0C2h,	0F1h
				db 0FBh, 37h, 0Fh, 1Ch,	30h, 0,	0, 40h
				db 0C0h, 0C4h, 0, 0, 20h, 18h, 0, 0
exterior_tiles_2		db 0, 1, 0, 30h, 0, 2, 0, 0 ; DATA XREF: plot_tile+11o
							    ; select_tile_set+3Do
				db 4, 0, 0, 0, 80h, 0, 18h, 4
				db 2, 80h, 0, 8, 4, 0, 60h, 0
				db 0, 0, 20h, 1, 0, 0, 0, 20h
				db 0, 40h, 30h,	78h, 77h, 7Bh, 3Fh, 7Fh
				db 0FFh, 3Dh, 0Fh, 3, 0, 0, 0, 0
				db 0Bh,	0Fh, 0Fh, 0Fh, 0Dh, 4Fh, 73h, 7Ch
				db 7Bh,	7Fh, 7Fh, 7Fh, 6Fh, 3Fh, 0Fh, 3
				db 0FEh, 0FCh, 0DEh, 0FEh, 0FEh, 0B4h, 0E0h, 0C2h
				db 0FCh, 0DCh, 0FCh, 0FCh, 0FCh, 0F2h, 0CEh, 36h
				db 0, 2, 0Eh, 1Eh, 0EEh, 0FEh, 7Eh, 0FEh
				db 0FEh, 0FCh, 70h, 0C1h, 0, 10h, 0, 2
				db 33h,	3Ch, 2Fh, 3Fh, 0Fh, 3, 0Ch, 0Fh
				db 0C0h, 30h, 0F0h, 0F0h, 70h, 0CCh, 3Ch, 0FCh
				db 0Fh,	3, 0Ch,	0Fh, 0Fh, 0Bh, 0Fh, 0Fh
				db 0F0h, 0CCh, 3Ch, 0ECh, 0FCh,	0FCh, 0FCh, 0B0h
				db 33h,	3Ch, 3Fh, 37h, 3Fh, 3Fh, 3Fh, 3Dh
				db 0C0h, 30h, 0F0h, 0F0h, 70h, 0F0h, 0F0h, 0F0h
				db 0Fh,	0Fh, 0Fh, 0Fh, 0Bh, 0Fh, 0Fh, 0Fh
				db 0BCh, 0FCh, 0F4h, 0FCh, 0FCh, 0DCh, 0FCh, 0F0h
				db 0BCh, 0FCh, 0F4h, 0FCh, 0FCh, 0DCh, 0FCh, 0F3h
				db 0C7h, 37h, 0F4h, 0F3h, 77h, 0F4h, 0F0h, 0F0h
				db 0CCh, 3Ch, 0B0h, 88h, 38h, 0F8h, 0F0h, 0CCh
				db 0Fh,	0Fh, 6Ch, 63h, 7, 34h, 0F0h, 0CCh
				db 3Ch,	0FCh, 0F3h, 0C7h, 4, 3,	3, 3
				db 0, 0, 0, 0, 0, 0, 0C0h, 0C0h
				db 0, 0, 0, 0, 20h, 0E0h, 0C0h,	30h
				db 0F0h, 0F0h, 0C8h, 38h, 70h, 40h, 0, 0
				db 3Ch,	0B3h, 83h, 33h,	0F0h, 0F3h, 0CFh, 0Ch
				db 0Fh,	0Eh, 0Fh, 0Fh, 0Ch, 3, 0Fh, 3Fh
				db 0Fh,	0Bh, 0Fh, 0Fh, 0Fh, 0Dh, 0Fh, 0Fh
				db 70h,	0F0h, 0F0h, 0F0h, 0F0h,	0D0h, 0F0h, 0F0h
				db 0, 0, 0, 20h, 0F0h, 0E0h, 0E0h, 0D0h
				db 0, 0, 0, 0, 0, 3, 7,	9
				db 0, 0, 0, 0Ch, 0Fh, 0Fh, 0Bh,	0Fh
				db 0, 0, 0, 0, 0, 0C0h,	0F0h, 0F0h
				db 0FFh, 0FFh, 7Fh, 0FBh, 0FFh,	3Fh, 4Fh, 73h
				db 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 96h, 0E6h
				db 7Ch,	7Fh, 77h, 6Bh, 6Bh, 6Dh, 6Dh, 6Dh
				db 0FFh, 3Bh, 0CFh, 0F3h, 0FCh,	0DEh, 0AEh, 0AEh
				db 6Dh,	6Dh, 6Dh, 6Dh, 6Dh, 6Dh, 6Dh, 6Dh
				db 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h
				db 6Dh,	6Dh, 6Dh, 65h, 79h, 3Fh, 0Fh, 3
				db 0FFh, 3Eh, 0Eh, 2, 0, 0, 0, 0
				db 0FEh, 0ECh, 73h, 0Fh, 3Fh, 7Bh, 75h,	75h
				db 0FFh, 0F7h, 0FFh, 0FEh, 0FBh, 0B4h, 0E2h, 0CEh
				db 3Fh,	0FEh, 0EEh, 0D6h, 0D6h,	0B6h, 0B6h, 0B6h
				db 6Dh,	6Dh, 6Dh, 6Dh, 6Dh, 6Dh, 69h, 67h
				db 0B6h, 0B6h, 0B7h, 0A6h, 9Eh,	0FCh, 0F0h, 0C1h
				db 7Fh,	7Ch, 70h, 41h, 0, 0, 40h, 2
				db 70h,	0F3h, 0CFh, 3Fh, 0FFh, 0DFh, 0FDh, 0FFh
				db 0B7h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 0B6h
				db 0Fh,	0CFh, 0F7h, 0FFh, 0FFh,	0BFh, 0FFh, 0FFh
				db 0F0h, 0F0h, 0F0h, 0D0h, 0F0h, 0F0h, 0F0h, 0FCh
				db 0, 1, 0Eh, 37h, 0B7h, 0D7h, 0F7h, 0F7h
				db 0F6h, 0B4h, 0F0h, 0C0h, 1, 40h, 0, 6
				db 0, 0, 0, 0, 0, 0, 0,	0Ch
				db 0, 0C0h, 0F0h, 3Ch, 7Fh, 0B3h, 87h, 8Bh
				db 0, 3, 0Fh, 3Ch, 0FEh, 0CDh, 0E1h, 0D1h
				db 0Fh,	0Bh, 0Dh, 0Dh, 0Eh, 0Eh, 6, 0Eh
				db 0Eh,	0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
				db 7Fh,	0B3h, 87h, 8Bh,	88h, 88h, 88h, 88h
				db 0, 0C0h, 70h, 0F0h, 0F0h, 0D0h, 0F0h, 0F0h
				db 0Eh,	0Ah, 0Eh, 0Eh, 0Eh, 0Eh, 0Dh, 0Dh
				db 88h,	88h, 88h, 88h, 88h, 48h, 70h, 74h
				db 37h,	0F7h, 0F3h, 0DFh, 0FFh,	3Dh, 0Fh, 3
				db 8, 48h, 70h,	74h, 36h, 0F6h,	0F2h, 0DEh
				db 60h,	0D0h, 0B0h, 0B0h, 70h, 70h, 70h, 70h
				db 70h,	70h, 50h, 70h, 70h, 70h, 70h, 70h
				db 11h,	11h, 11h, 11h, 11h, 11h, 11h, 11h
				db 0FEh, 0CDh, 0E1h, 0D1h, 11h,	11h, 11h, 11h
				db 0, 3, 7, 0Dh, 0Fh, 0Fh, 0Fh,	0Fh
				db 11h,	11h, 11h, 11h, 11h, 12h, 0Eh, 2Eh
				db 70h,	50h, 70h, 70h, 70h, 70h, 0B0h, 0B0h
				db 10h,	12h, 0Eh, 2Eh, 6Ch, 6Fh, 4Fh, 7Bh
				db 0ECh, 0EFh, 0CFh, 0FBh, 0FFh, 0BCh, 0F0h, 0C0h
				db 0D0h, 0F0h, 0F0h, 0C0h, 0, 0, 0, 0
				db 0Fh,	0Fh, 0Fh, 0Fh, 0Fh, 0Ch, 0, 0
				db 0, 0, 0Ch, 13h, 14h,	14h, 8,	8
				db 0, 0, 0, 0, 0C0h, 30h, 10h, 6Ch
				db 0FEh, 0FEh, 7Ch, 0, 0, 0, 0,	0
				db 13h,	0Ch, 30h, 0C3h,	0Ch, 32h, 0C0h,	20h
				db 0, 1, 1, 2, 12h, 4, 34h, 0CBh
				db 0, 0, 0, 0, 0, 0, 1,	0
				db 8, 14h, 0D0h, 20h, 20h, 20h,	20h, 20h
				db 0, 0, 0, 0, 3, 0Ch, 8, 36h
				db 7Fh,	7Fh, 3Eh, 0, 0,	0, 0, 0
				db 0, 0, 30h, 0C8h, 28h, 28h, 10h, 10h
				db 0, 0, 0, 0, 0, 0, 80h, 0
				db 0C8h, 30h, 0Ch, 0C3h, 30h, 4Ch, 3, 4
				db 0, 80h, 80h,	40h, 48h, 20h, 2Ch, 0D3h
				db 10h,	28h, 0Bh, 4, 4,	4, 4, 4
				db 0Bh,	0Fh, 0Fh, 3, 0,	0, 0, 0
				db 0E0h, 0F0h, 0B0h, 0F0h, 0F0h, 30h, 0, 0
				db 88h,	88h, 88h, 88h, 88h, 88h, 88h, 88h
				db 8, 6, 0Bh, 1Ch, 13h,	3Bh, 1Bh, 2Bh
				db 0, 0, 0, 4, 18h, 0CCh, 72h, 36h
				db 4Bh,	9, 1, 0, 0, 0C0h, 0F0h,	3Ch
				db 67h,	0DFh, 0CEh, 8Ah, 12h, 24h, 4, 0
				db 0, 0, 0, 0, 0, 0C0h,	0F0h, 3Ch
				db 0, 80h, 80h,	30h, 0F0h, 0F3h, 0CFh, 3Ch
				db 0, 0, 0, 0, 0, 2, 0Eh, 3Eh
				db 0, 0, 0, 0, 0, 40h, 70h, 7Ch
				db 0FFh, 0DFh, 0FDh, 0FFh, 0FFh, 0FCh, 70h, 0C0h
				db 70h,	0F0h, 0F0h, 0F0h, 0D0h,	0F0h, 0F0h, 0F0h
				db 0Fh,	8Fh, 8Fh, 4Fh, 4Bh, 2Fh, 2Fh, 0D7h
				db 0BCh, 0FDh, 0F5h, 0FAh, 0FAh, 0D4h, 0F4h, 0EBh
				db 13h,	28h, 2Bh, 35h, 35h, 35h, 35h, 3Bh
				db 0C8h, 14h, 0D0h, 0A0h, 20h, 0A0h, 0A0h, 0D0h
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0C0h, 0F0h, 0FCh,	3Ch, 0Ch, 30h, 3Ch
				db 0, 3, 43h, 73h, 38h,	0CBh, 0F3h, 0FCh
				db 0, 0, 0C0h, 0F0h, 0F0h, 30h,	0C0h, 0D0h
				db 0Dh,	1, 0Ch,	0Fh, 0Fh, 3, 0Ch, 0Fh
				db 3Ch,	0CCh, 0E0h, 2Ch, 0CFh, 0C3h, 0CCh, 0Fh
				db 1Ch,	0CEh, 0F2h, 0FCh, 3Ch, 4Ch, 70h, 38h
				db 0, 0, 0, 0, 0, 0C0h,	0F0h, 0FCh
				db 3, 0, 3, 3, 3, 0, 0,	0
				db 4Fh,	73h, 38h, 0CBh,	0F3h, 0F0h, 30h, 0
				db 0CBh, 0C3h, 0CCh, 0Fh, 0CFh,	0D3h, 1Ch, 0Ch
				db 3Ch,	0CCh, 0C0h, 0, 0C0h, 0C0h, 0C0h, 0
				db 0, 0C0h, 70h, 0ECh, 0EDh, 0EBh, 0EFh, 0EFh
				db 0EFh, 2Dh, 0Fh, 3, 0, 0, 0, 0
				db 0FEh, 0FCh, 70h, 0C6h, 30h, 0F3h, 0CFh, 0Ch
				db 0, 0Ch, 3Ch,	0FCh, 0F3h, 4Fh, 0Ch, 3
				db 3Ch,	0FCh, 0F3h, 0CFh, 0Ch, 2, 0Eh, 3Eh
				db 0Fh,	3Fh, 3Ch, 33h, 0Bh, 38h, 70h, 40h
				db 4, 1Ch, 0D3h, 0CFh, 3Fh, 3Ch, 30h, 0
				db 0FFh, 0DFh, 0FFh, 0FFh, 0FBh, 3Fh, 0Dh, 1
				db 3, 3, 0Ch, 0Fh, 0Fh,	13h, 1Ch, 0Eh
				db 32h,	3Ch, 3Fh, 0Fh, 13h, 1Ch, 0Eh, 2
				db 30h,	0C0h, 0B0h, 0FCh, 0FFh,	0DFh, 0EFh, 0FFh
				db 0F0h, 0F0h, 0F0h, 0F0h, 0B0h, 0F0h, 0F0h, 0F0h
				db 30h,	0C0h, 0F0h, 0ECh, 0FCh,	0F4h, 3Ch, 0CCh
				db 0FCh, 0ECh, 3Ch, 0CCh, 0F0h,	0D0h, 0F0h, 0F0h
				db 30h,	0C0h, 0F0h, 0BCh, 0FCh,	0FCh, 0ECh, 0DCh
				db 8, 48h, 70h,	74h, 37h, 0F7h,	0F3h, 0FFh
				db 30h,	0F0h, 0F0h, 0F0h, 0F0h,	0F0h, 0F0h, 0F0h
				db 2Ch,	4Dh, 15h, 15h, 14h, 0, 0, 0
				db 0C0h, 30h, 0F0h, 0F0h, 0F0h,	0C3h, 2Fh, 0EFh
				db 0EFh, 6Fh, 0EBh, 0EFh, 0EFh,	0ACh, 0E3h, 0EFh
				db 0CFh, 2Fh, 0EBh, 0EFh, 0AFh,	0EDh, 0CFh, 33h
				db 0ECh, 3Fh, 0Fh, 3, 0, 0, 80h, 0
				db 6Dh,	2Dh, 0CDh, 0F1h, 0CCh, 3Fh, 0Fh, 3
				db 0B6h, 0B6h, 0B6h, 0B6h, 0B6h, 36h, 0C6h, 0F2h
				db 0B0h, 0F3h, 0CFh, 33h, 0E8h,	0E8h, 0A8h, 0ECh
				db 8, 10h, 0C0h, 70h, 0FCh, 3Bh, 0Fh, 3
				db 0, 0, 0, 0, 0, 0, 0C0h, 0F0h
				db 0C3h, 8, 0C2h, 0F0h,	0ECh, 3Fh, 0Fh,	3
				db 0, 0C0h, 30h, 0Ch, 93h, 0, 0C0h, 0F2h
				db 0ECh, 3Fh, 0Fh, 3, 0, 0C0h, 30h, 4Ch
				db 3, 10h, 0C4h, 0B0h, 0FCh, 3Fh, 0Fh, 3
				db 0Eh,	0Dh, 1,	0Ah, 3Ah, 5, 35h, 0CBh
				db 2Bh,	17h, 0D4h, 23h,	2Fh, 2Dh, 2Fh, 0Fh
				db 0, 10h, 0C0h, 71h, 0FCh, 3Bh, 0Fh, 3
				db 0Fh,	0Ch, 3,	0Fh, 3Fh, 3Fh, 2Fh, 3Fh
				db 3Dh,	3Fh, 3Ch, 33h, 0Fh, 0Dh, 0Fh, 0Fh
				db 0Fh,	0Ch, 3,	0Fh, 3Fh, 2Fh, 3Ch, 33h
				db 0Fh,	0Fh, 0Dh, 0Fh, 0Fh, 0Fh, 0Fh, 0Bh
				db 0Fh,	0Fh, 0Dh, 0Fh, 0Fh, 0Fh, 0CFh, 0F3h
				db 0, 2, 20h, 0, 0, 8, 0C0h, 0F0h
				db 0FCh, 3Fh, 0CFh, 0F3h, 0ECh,	0FCh, 0BCh, 0FCh
				db 3Fh,	0DCh, 0F3h, 0CDh, 3Fh, 2Fh, 3Ch, 33h
				db 0, 0, 0, 0, 3, 0Ch, 0C1h, 0F0h
				db 3, 0Ch, 30h,	0C0h, 1, 20h, 0, 4
				db 0, 0, 0, 0, 3, 0Ch, 30h, 0C0h
				db 0, 0, 0, 0, 3, 0Fh, 3Fh, 7Ch
				db 3, 0Dh, 3Fh,	0FCh, 0B0h, 0C0h, 0, 0
				db 0F0h, 0C0h, 0, 0, 0,	0, 0, 0
				db 0Fh,	3, 0, 0, 0, 0, 0, 0
				db 0C0h, 0B0h, 0FCh, 3Fh, 0Dh, 3, 0, 0
				db 0, 0, 0, 0, 0C0h, 0F0h, 0ECh, 3Fh
				db 0, 0, 0, 0, 0C0h, 30h, 0Ch, 43h
				db 0C0h, 30h, 0Ch, 43h,	0, 2, 20h, 0
				db 0, 0, 0, 0, 0C0h, 30h, 3, 8Fh
				db 0, 40h, 3, 0Dh, 3Fh,	0FCh, 0B0h, 0C0h
				db 3Fh,	0DCh, 0F0h, 0C0h, 0, 0,	0, 0
				db 0, 10h, 0, 0, 2, 80h, 3, 0Fh
				db 0, 42h, 0, 8, 3, 4Ch, 33h, 0CCh
				db 43h,	0Ch, 33h, 0CCh,	30h, 0C7h, 9, 0Eh
				db 8, 0C0h, 30h, 0CCh, 33h, 0Ch, 83h, 0
				db 0, 0, 44h, 0, 0, 0C2h, 30h, 0ECh
				db 33h,	8Ch, 3,	10h, 0,	0, 40h,	2
				db 0, 0C1h, 30h, 0CCh, 33h, 0Ch, 23h, 0
				db 70h,	90h, 0E3h, 0Ch,	33h, 0CCh, 32h,	0C0h
				db 33h,	0CCh, 30h, 0C0h, 0, 11h, 0, 20h
				db 0, 0, 0, 0, 3, 0Ch, 33h, 0CDh
				db 2Fh,	6Eh, 2Fh, 6Fh, 63h, 4Fh, 6Fh, 2Ch
				db 3, 0Ch, 30h,	0C0h, 0, 0, 0, 0
				db 70h,	40h, 0,	0, 0, 0, 0, 0
				db 2, 40h, 3, 0Fh, 3Bh,	7Ch, 70h, 40h
				db 0, 0, 0, 0, 3, 0Ch, 30h, 40h
				db 30h,	0F0h, 0B0h, 0F0h, 0F0h,	0D0h, 0F0h, 0F0h
				db 3, 0Ch, 30h,	0C0h, 8, 20h, 2Ch, 0D3h
				db 0F0h, 0D0h, 0F0h, 0F0h, 0F0h, 0B0h, 0F0h, 0CCh
				db 0FFh, 3Ch, 3, 8Dh, 3Fh, 0DCh, 0F0h, 0C0h
				db 2Fh,	0CFh, 0F7h, 0FFh, 0DFh,	0FFh, 0EFh, 0FDh
				db 2Fh,	0CBh, 2Fh, 0EFh, 0AFh, 0EDh, 0EFh, 0EFh
				db 0EFh, 0AFh, 0EFh, 0E3h, 0ECh, 2Fh, 0CDh, 0EFh
				db 0C0h, 0E0h, 0E0h, 0ECh, 0E7h, 0E3h, 2Fh, 0CFh
				db 0C0h, 30h, 0CCh, 0F3h, 0F0h,	0F0h, 0CCh, 3Ch
				db 10h,	8, 0Bh,	4, 0C4h, 34h, 0C4h, 0CBh
				db 0D6h, 0D6h, 0D6h, 0D6h, 0D2h, 0D0h, 0D4h, 3
				db 0C0h, 30h, 0CCh, 93h, 54h, 0D6h, 0D6h, 0D6h
				db 0D6h, 0D2h, 0D4h, 0D6h, 0D6h, 56h, 96h, 0C6h
				db 0F0h, 0DCh, 0CFh, 0D3h, 0D4h, 0D6h, 56h, 96h
				db 0D4h, 0D6h, 0D6h, 0D2h, 0D4h, 56h, 96h, 0C6h
				db 0, 0, 0, 0, 1, 3, 5,	0Fh
				db 0CBh, 2Bh, 0EDh, 0EDh, 6Dh, 2Dh, 0Dh, 33h
				db 0D6h, 0D6h, 0D6h, 0D6h, 0D6h, 0D6h, 0C6h, 0D2h
				db 1Ch,	0Fh, 3,	0, 10h,	0, 0, 2
				db 56h,	16h, 0C6h, 0F2h, 3Ch, 0Bh, 4, 3
				db 0D6h, 0D2h, 0D4h, 83h, 4Ch, 32h, 0C8h, 2Ch
				db 0D6h, 0D6h, 16h, 0C6h, 0F2h,	3Ch, 0CFh, 0D3h
				db 0Fh,	0Ch, 3,	0Fh, 3Fh, 2Fh, 3Ch, 33h
				db 0CBh, 0Bh, 0Dh, 0Dh,	8Dh, 0EDh, 4Dh,	33h
				db 0Bh,	0Fh, 2Fh, 0CDh,	32h, 4Ch, 3, 4
				db 23h,	0CFh, 33h, 4Ch,	53h, 5Ch, 2Fh, 23h
				db 0D3h, 0D0h, 0B0h, 0B0h, 0B3h, 0B7h, 0B3h, 0CCh
				db 0D3h, 0D4h, 0B6h, 0B7h, 0B7h, 0B4h, 0F0h, 0ECh
exterior_tiles_3		db 4Ch,	32h, 0C0h, 20h,	4, 3, 0Ch, 32h
							    ; DATA XREF: plot_tile+1Eo
							    ; select_tile_set+48o
				db 18h,	3Ch, 78h, 0B4h,	0E0h, 0CCh, 0A3h, 44h
				db 40h,	8, 8, 0, 0, 0, 20h, 0C0h
				db 1Eh,	2Ch, 7Bh, 64h, 98h, 0B0h, 0D0h,	0CCh
				db 0, 0, 0, 0, 80h, 0C0h, 0A0h,	0F0h
				db 32h,	4Ch, 3,	4, 0, 0, 20h, 0C0h
				db 0, 0, 20h, 0C0h, 32h, 4Ch, 3, 4
				db 32h,	4Ch, 3,	4, 1, 3, 25h, 0CFh
				db 0D3h, 0D0h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0CCh
				db 20h,	0C0h, 30h, 4Ch,	43h, 40h, 20h, 20h
				db 32h,	4Ch, 3,	4, 20h,	0C0h, 30h, 4Ch
				db 43h,	40h, 20h, 20h, 20h, 0C0h, 30h, 4Ch
				db 20h,	0C0h, 30h, 4Ch,	42h, 40h, 20h, 20h
				db 3, 0, 40h, 40h, 20h,	4, 4, 0
				db 20h,	0C0h, 30h, 4Ch,	2, 10h,	8, 48h
				db 20h,	0C0h, 30h, 4Ch,	3, 0, 30h, 0
				db 0D3h, 0D0h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0ECh
				db 63h,	0, 0, 0, 4, 24h, 14h, 0
				db 40h,	40h, 1,	9, 8, 4, 64h, 0
				db 0, 4, 5, 42h, 22h, 20h, 8, 0
				db 0, 12h, 2, 40h, 40h,	24h, 28h, 8
				db 0C2h, 2, 4, 20h, 20h, 10h, 2, 0
				db 40h,	8, 0Ah,	4, 4, 40h, 40h,	20h
				db 0, 20h, 10h,	0, 0, 8, 8, 0
				db 40h,	0, 0, 10h, 10h,	0, 4, 3
				db 18h,	3Ch, 1Eh, 2Dh, 7, 33h, 0C5h, 22h
				db 0Ch,	30h, 0C0h, 20h,	80h, 0C0h, 0A4h, 0F3h
				db 0, 0, 4, 3, 4Ch, 32h, 0C0h, 20h
				db 4Ch,	32h, 0C0h, 20h,	0, 0, 4, 3
				db 78h,	34h, 0DEh, 26h,	19h, 0Dh, 0Bh, 33h
				db 4, 3, 0Ch, 32h, 0C2h, 2, 4, 4
				db 0CBh, 0Bh, 0Dh, 0Dh,	0Dh, 0Dh, 0Dh, 33h
				db 0C2h, 2, 4, 4, 4, 3,	0Ch, 32h
				db 0C0h, 0, 0, 8, 4, 44h, 40h, 0
				db 4, 3, 0Ch, 32h, 0C0h, 0, 2, 0
				db 0C6h, 0, 10h, 12h, 0Ah, 48h,	0, 0
				db 4, 3, 0Ch, 30h, 40h,	0, 0Ch,	0
				db 4, 3, 0Ch, 32h, 42h,	2, 4, 4
				db 0, 1, 0, 30h, 0, 2, 0, 0
				db 2, 0, 0, 0, 40h, 0, 0Ch, 0
				db 2, 80h, 0, 8, 4, 0, 60h, 0
				db 0, 0, 20h, 1, 0, 0, 0, 20h
				db 23h,	0C3h, 33h, 4Ah,	2, 2, 2, 3
				db 44h,	43h, 4Ch, 0D2h,	0C0h, 0C0h, 0C0h, 0C0h
				db 23h,	0C3h, 33h, 4Ah,	42h, 42h, 22h, 22h
				db 44h,	43h, 4Ch, 0D2h,	0C2h, 0C2h, 0C4h, 0C4h
				db 3, 3, 0C2h, 33h, 0Bh, 3, 2, 2
				db 40h,	0C0h, 0C3h, 0CCh, 0D0h,	0C0h, 0C0h, 0C0h
				db 1, 3, 22h, 0C3h, 33h, 4Bh, 2, 3
				db 80h,	0C0h, 0C4h, 0C3h, 4Ch, 0D2h, 0C0h, 0C0h
				db 1Eh,	3Ch, 7Bh, 64h, 0F8h, 0C0h, 0B0h, 0BCh
				db 0BFh, 0CFh, 0B3h, 0B4h, 0B7h, 0D6h, 0D6h, 0D6h
				db 0B7h, 0AEh, 0AFh, 0AFh, 0AFh, 0AFh, 0AFh, 0B7h
				db 0D7h, 0D6h, 0D7h, 0B7h, 0B7h, 0B7h, 0B7h, 0D7h
				db 67h,	6, 2, 40h, 40h,	0, 4, 0
				db 32h,	4Ch, 3,	4, 0, 0C0h, 0F0h, 0FCh
				db 0, 0C0h, 70h, 0FCh, 3Fh, 0CDh, 0F3h,	0FCh
				db 0, 0C0h, 0F0h, 0DCh,	3Eh, 0CEh, 0F2h, 0F4h
				db 2Eh,	0CEh, 2Eh, 4Eh,	4Eh, 4Eh, 2Eh, 2Eh
				db 43h,	40h, 20h, 20h, 20h, 0A0h, 0D0h,	0FCh
				db 2Eh,	0AEh, 0D6h, 0F6h, 36h, 0Eh, 2, 0
				db 3Fh,	0Fh, 3,	40h, 40h, 20h, 2, 0
				db 20h,	0A0h, 0D0h, 0FCh, 3Fh, 0Fh, 3, 40h
				db 36h,	0CEh, 2Eh, 4Eh,	4Eh, 4Eh, 2Eh, 2Eh
				db 37h,	0CFh, 0F3h, 0FCh, 3Fh, 0CFh, 33h, 4Ch
				db 0B3h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0BCh
				db 0B3h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0ACh
				db 3Fh,	0CFh, 33h, 4Ch,	43h, 40h, 20h, 20h
				db 3Fh,	8Fh, 0B3h, 0BCh, 0BFh, 0BFh, 0B3h, 0ACh
				db 21h,	0C1h, 31h, 4Dh,	41h, 41h, 21h, 21h
				db 21h,	0A1h, 0D1h, 0FDh, 3Fh, 0Fh, 3, 0
				db 3Fh,	0CFh, 33h, 4Dh,	41h, 41h, 21h, 21h
				db 0, 0, 0, 0, 92h, 0CCh, 0A3h,	0F0h
				db 20h,	0C0h, 30h, 4Ch,	43h, 40h, 24h, 3
				db 4Ch,	30h, 0C0h, 2Ch,	3, 40h,	44h, 3
				db 4Ch,	30h, 0C0h, 0Ch,	0, 13h,	0Ch, 32h
				db 44h,	43h, 0Ch, 32h, 0C2h, 2,	34h, 4
				db 0C2h, 2, 34h, 4, 44h, 43h, 0Ch, 32h
				db 0CBh, 0Bh, 2Dh, 0Dh,	4Dh, 4Dh, 0Dh, 33h
				db 20h,	0C0h, 30h, 4Ch,	43h, 40h, 4, 3
				db 43h,	40h, 4,	3, 4Ch,	32h, 0C0h, 2Ch
				db 3, 40h, 44h,	3, 4Ch,	32h, 0C0h, 2Ch
				db 0D3h, 0D0h, 0B4h, 3,	4Ch, 32h, 0C0h,	20h
				db 0C3h, 0, 4, 3, 4Ch, 32h, 0C0h, 20h
				db 0, 0, 20h, 20h, 0, 0, 0, 0
				db 0, 0, 0, 18h, 0, 0, 0, 0
				db 0, 8, 4, 0, 0, 0, 0,	20h
				db 10h,	0, 0, 0, 0, 2, 4, 0
				db 4, 3, 0Ch, 32h, 42h,	2, 24h,	0C0h
				db 4, 3, 0Ch, 32h, 0C0h, 0, 20h, 0C0h
				db 0, 60h, 94h,	0F3h, 0B4h, 0B2h, 0D0h,	0D0h
				db 32h,	4Ch, 3,	34h, 41h, 3, 25h, 0CFh
				db 0CBh, 0Bh, 2Dh, 0CDh, 32h, 4Ch, 3, 34h
				db 0C2h, 2, 22h, 0C0h, 32h, 4Ch, 3, 34h
				db 0C0h, 2, 20h, 0C0h, 32h, 4Ch, 3, 4
				db 32h,	4Ch, 3,	34h, 0C0h, 2, 22h, 0C0h
				db 20h,	0C2h, 30h, 4Ch,	43h, 40h, 2Ch, 20h
				db 0D3h, 0D0h, 0B4h, 0B2h, 0B2h, 0B2h, 0B0h, 0CCh
				db 32h,	4Ch, 3,	4, 20h,	0C2h, 30h, 4Ch
				db 0Ah,	0CEh, 32h, 4Ch,	42h, 4Ch, 2Eh, 26h
				db 0Ch,	0, 20h,	0C0h, 32h, 4Ch,	3, 34h
				db 0F2h, 0CCh, 0D3h, 0D4h, 0B0h, 0B0h, 0B0h, 0CCh
				db 22h,	0C2h, 30h, 4Ch,	43h, 40h, 2Ch, 22h
				db 22h,	0C2h, 30h, 4Ch,	43h, 40h, 20h, 20h
				db 43h,	40h, 2Ch, 22h, 22h, 0C2h, 30h, 4Ch
				db 0, 21h, 10h,	10h, 3,	0Ch, 33h, 0CCh
				db 40h,	8Ch, 30h, 0C4h,	30h, 0C0h, 0Eh,	12h
				db 33h,	0Ch, 3,	40h, 44h, 44h, 20h, 0
				db 0Ch,	0C0h, 3, 0C0h, 30h, 2, 0Ah, 4
				db 0, 40h, 0E0h, 0, 0C2h, 0E0h,	0C0h, 0
				db 31h,	0CDh, 32h, 0Dh,	3Eh, 19h, 2, 2
				db 8Ch,	0B3h, 4Ch, 0B0h, 7Ch, 99h, 0C0h, 0C0h
				db 0, 2, 7, 0, 43h, 7, 2, 0
				db 0D9h, 0DBh, 2Ah, 0CBh, 33h, 4Bh, 0B2h, 0DBh
				db 9Bh,	0DBh, 0D4h, 0D3h, 4Ch, 0D2h, 0CDh, 0DBh
				db 3Bh,	0CBh, 33h, 0CAh, 0E2h, 0EAh, 0EAh, 0EAh
				db 5Ch,	53h, 4Ch, 0D3h,	0C7h, 0D7h, 0D7h, 0D7h
				db 31h,	0CDh, 32h, 0CCh, 0BEh, 0D8h, 0E0h, 0F8h
				db 8Ch,	0B3h, 4Ch, 33h,	7Dh, 1Bh, 7, 1Fh
				db 32h,	4Ch, 33h, 34h, 3Ah, 1Ah, 2Ah, 0C8h
				db 32h,	4Ch, 33h, 14h, 2Ah, 0CAh, 32h, 4Ch
				db 53h,	54h, 26h, 26h, 2Ah, 0CAh, 32h, 4Ch
				db 3Bh,	0C3h, 33h, 0Bh,	2, 2, 3, 1
				db 0D8h, 0D8h, 0D8h, 0D8h, 0E8h, 0E8h, 0E8h, 0E8h
				db 1Bh,	1Bh, 1Bh, 1Bh, 17h, 17h, 17h, 17h
				db 5Ch,	43h, 4Ch, 50h, 0C0h, 0C0h, 0C0h, 80h
				db 4Ch,	32h, 0CCh, 2Ch,	5Ch, 58h, 54h, 13h
				db 4Ch,	32h, 0CCh, 28h,	54h, 53h, 4Ch, 32h
				db 0CAh, 2Ah, 64h, 64h,	54h, 53h, 4Ch, 32h
				db 36h,	36h, 36h, 36h, 3Ah, 1Ah, 2Ah, 0C8h
				db 6Ch,	6Ch, 6Ch, 6Ch, 5Ch, 58h, 54h, 13h
				db 0Bh,	43h, 2,	0C2h, 0F3h, 3Dh, 0CEh, 3
				db 42h,	50h, 0C0h, 0C3h, 0CFh, 0BCh, 70h, 0CCh
				db 0C0h, 0Ch, 30h, 0C3h, 0Ch, 33h, 0CCh, 30h
				db 1, 0Dh, 20h,	0C3h, 0Ch, 33h,	0CCh, 30h
				db 0, 21h, 10h,	10h, 3,	0Ch, 32h, 0CDh
				db 13h,	1Ch, 1Ch, 1Ch, 1Dh, 1Dh, 1Ch, 2Ch
				db 0CCh, 3Ch, 6Ch, 6Ch,	5Ch, 5Ch, 5Ch, 5Ch
				db 3, 30h, 8, 0C3h, 30h, 0CCh, 33h, 0Ch
				db 82h,	80h, 8,	0C2h, 30h, 0CCh, 33h, 0Ch
				db 0F0h, 3Ch, 0Fh, 3, 8, 83h, 20h, 0Ch
				db 0F0h, 3Ch, 8Fh, 83h,	88h, 83h, 0A0h,	8Ch
				db 0Fh,	3Ch, 0F1h, 0C1h, 1, 1, 0C1h, 9
				db 30h,	0CCh, 33h, 4Ch,	0E3h, 80h, 8, 0
				db 33h,	3Ch, 36h, 36h, 3Ah, 3Ah, 3Ah, 3Ah
				db 0C0h, 30h, 4Ch, 3, 10h, 2, 40h, 3
				db 0Ch,	33h, 0CCh, 32h,	0C7h, 1, 20h, 0
				db 0C8h, 38h, 38h, 38h,	0B8h, 0B8h, 38h, 34h
				db 7, 40h, 8, 20h, 0C0h, 4, 30h, 0C3h
				db 0C0h, 0F0h, 1Ch, 83h, 0Ch, 33h, 0CCh, 30h
				db 0, 0, 0, 0C0h, 0F3h,	3Ch, 8Fh, 3
				db 3, 0Fh, 38h,	0C1h, 30h, 8Ch,	33h, 0Ch
				db 3, 0Ch, 30h,	0C2h, 10h, 0, 8, 0C1h
				db 0E0h, 2, 10h, 0Ch, 1, 30h, 4, 0C3h
				db 2, 2, 0, 10h, 0C0h, 30h, 4Ch, 0B3h
				db 6, 38h, 0C0h, 10h, 0C0h, 32h, 0Ch, 3
				db 60h,	1Ch, 3,	8, 3, 4Ch, 30h,	0C0h
				db 0C0h, 30h, 0Ch, 0E3h, 18h, 7, 20h, 0
				db 0, 4, 4, 0, 0C1h, 30h, 0CCh,	3Bh
				db 3, 0Ch, 30h,	0C7h, 18h, 0E0h, 4, 0
				db 0, 22h, 20h,	0, 3, 0Ch, 33h,	0DCh
				db 36h,	36h, 36h, 36h, 3Ah, 3Ah, 3Ah, 3Ah
				db 36h,	32h, 34h, 33h, 4Ch, 32h, 0C8h, 2Ah
				db 34h,	33h, 0Ch, 32h, 0CAh, 3Ah, 34h, 34h
				db 0D9h, 0DBh, 0DAh, 0DBh, 0EBh, 0EBh, 0EAh, 0A3h
				db 4Dh,	33h, 0CAh, 2Bh,	0CBh, 0EBh, 0EAh, 0A3h
				db 4Dh,	33h, 0CBh, 2Ah,	0CAh, 0E2h, 0CCh, 0B2h
				db 0C3h, 3, 3, 3, 2, 2,	0Bh, 33h
				db 0CBh, 1Bh, 0DBh, 0DAh, 0EAh,	0E2h, 0CCh, 32h
				db 30h,	0C3h, 0, 33h, 0CFh, 3Ch, 0F0h, 0C0h
				db 0, 30h, 42h,	4, 10h,	0C3h, 8, 3
				db 0Fh,	3Ch, 0F0h, 0C0h, 0, 0, 0, 0
				db 9, 0C3h, 31h, 0Dh, 0C3h, 11h, 0Dh, 0C3h
				db 90h,	0C2h, 8Ch, 0B0h, 0C3h, 84h, 0B0h, 80h
				db 8, 30h, 0C2h, 4, 30h, 80h, 8, 20h
				db 0, 0C0h, 30h, 0, 0C0h, 30h, 0Ch, 0C0h
				db 20h,	0Ch, 0C0h, 30h,	8, 43h,	30h, 0Ch
				db 0C3h, 31h, 0Dh, 81h,	31h, 0Dh, 43h, 31h
				db 0C3h, 84h, 0B0h, 0C3h, 8Ch, 90h, 0C3h, 8Ch
				db 0CBh, 0Bh, 0Dh, 0Dh,	0Dh, 0CDh, 0CDh, 33h
				db 0CBh, 2Bh, 0EDh, 0EDh, 0EDh,	2Dh, 0Dh, 37h
				db 0F4h, 33h, 0Ch, 32h,	0C2h, 2, 4, 4
				db 4, 0C3h, 0CCh, 32h, 0Ah, 3Ah, 0F5h, 0F5h
				db 0C2h, 2, 4, 4, 4, 43h, 4Ch, 32h
				db 0CAh, 3Ah, 75h, 75h,	74h, 33h, 0Ch, 32h
				db 4Ch,	32h, 0CDh, 2Bh,	0D4h, 33h, 0Ch,	32h
				db 4Ch,	32h, 0C0h, 20h,	0, 0C0h, 0F4h, 0B3h
				db 5Fh,	3Bh, 4,	3, 4Ch,	32h, 0C0h, 20h
				db 0, 40h, 74h,	33h, 4Ch, 32h, 0CDh, 2Fh
				db 0D6h, 0D6h, 0D6h, 0D6h, 0D6h, 0D2h, 0D4h, 93h
				db 0CBh, 2Bh, 0CDh, 0EDh, 2Dh, 0Dh, 0Dh, 33h
				db 0, 0, 0, 0, 6, 0Bh, 0Fh, 0Dh
				db 4Fh,	37h, 0CDh, 2Fh,	0Bh, 0Fh, 0Dh, 0Fh
				db 0, 0, 0, 0, 60h, 0D0h, 0F0h,	0B0h
				db 0F2h, 0ACh, 0F3h, 0F4h, 0D0h, 0F0h, 0F0h, 0B0h
				db 0D3h, 0D0h, 0B0h, 0B0h, 0B3h, 0B7h, 0B3h, 0CCh
				db 22h,	0CEh, 32h, 4Ch,	52h, 5Ch, 0AEh,	2Eh
				db 0D3h, 0D4h, 0B7h, 0B7h, 0B7h, 0B4h, 0B0h, 0CCh
				db 2Eh,	0CCh, 30h, 4Ch,	43h, 40h, 20h, 20h
				db 43h,	40h, 20h, 20h, 23h, 0CFh, 33h, 4Ch
				db 53h,	5Ch, 0AFh, 0AFh, 2Fh, 0CCh, 30h, 4Ch
				db 0Bh,	0Fh, 2Fh, 0CDh,	32h, 4Ch, 13h, 14h
				db 7Fh,	7Fh, 3Eh, 0, 0,	0, 0, 0
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 4Fh,	73h, 38h, 0CBh,	0F3h, 0F0h, 30h, 0
				db 3Ch,	0CCh, 0C0h, 0, 0C0h, 0C0h, 0C0h, 0
interior_tiles			db 0, 0, 0, 0, 0, 0, 0,	0   ; DATA XREF: select_tile_set+7o
							    ; plot_interior_tiles+19o
				db 0, 0, 0, 0, 0, 0, 0,	0
				db 0, 0, 0, 30h, 40h, 2, 0Ch, 80h
				db 0, 0, 0, 0, 0, 4, 8,	4
				db 30h,	0FCh, 3Fh, 0CFh, 0C3h, 0C0h, 0C8h, 0C6h
				db 10h,	60h, 0,	0C6h, 0F0h, 0FCh, 3Fh, 0Ch
				db 0, 98h, 62h,	8, 20h,	80h, 4,	0
				db 24h,	81h, 0,	8, 1, 40h, 20h,	1
				db 40h,	30h, 0,	4Ch, 30h, 0, 86h, 8
				db 0C8h, 0C0h, 0C2h, 0CCh, 0F0h, 0C0h, 0Ch, 1
				db 23h,	83h, 3,	13h, 3,	83h, 43h, 3
				db 0, 18h, 0, 40h, 2, 8, 20h, 80h
				db 3, 13h, 3, 3, 43h, 0Ch, 30h,	80h
				db 2, 8, 20h, 80h, 0, 0, 0, 0
				db 8, 40h, 0, 20h, 0, 4, 40h, 0
				db 40h,	4, 2, 4Ch, 30h,	0, 0C3h, 8
				db 0, 0, 3, 44h, 8Ch, 1Eh, 0Ch,	40h
				db 8, 6, 0, 63h, 0Fh, 3Fh, 0FCh, 30h
				db 0Ch,	3Fh, 0FCh, 0F3h, 0C3h, 0Bh, 23h, 0C3h
				db 40h,	10h, 4,	1, 0, 0, 0, 0
				db 0, 0, 0C0h, 22h, 31h, 78h, 30h, 2
				db 0C4h, 0C1h, 0C0h, 0D0h, 0C0h, 0C1h, 0C2h, 0C0h
				db 13h,	0Bh, 43h, 33h, 0Fh, 3, 20h, 80h
				db 6, 20h, 40h,	34h, 8,	3, 0C0h, 30h
				db 0C0h, 0C8h, 0C0h, 0C0h, 0C2h, 30h, 0Ch, 1
				db 0, 19h, 46h,	10h, 4,	1, 20h,	0
				db 0, 0, 18h, 0, 42h, 10h, 4, 1
				db 81h,	9Bh, 62h, 1, 80h, 23h, 4Fh, 0Bh
				db 0C3h, 13h, 3, 0C3h, 0F3h, 0FCh, 3Fh,	0Ch
				db 0C8h, 0C4h, 0C0h, 0C3h, 0CFh, 3Fh, 0FCh, 30h
				db 30h,	0FCh, 3Fh, 0CFh, 0C3h, 0C0h, 98h, 7Eh
				db 73h,	4Fh, 77h, 38h, 16h, 3, 40h, 4
				db 0FFh, 7Eh, 9Ch, 0E8h, 0F2h, 0, 20h, 80h
				db 1Bh,	5Fh, 0Eh, 0C5h,	1Fh, 33h, 6Dh, 7Dh
				db 72h,	0FBh, 0FFh, 0DBh, 67h, 0FDh, 9Fh, 6Dh
				db 0BBh, 7Bh, 7Bh, 63h,	0C3h, 0CCh, 10h, 0
				db 0C3h, 0CBh, 63h, 0E3h, 0D3h,	0FBh, 0BBh, 0CBh
				db 0, 0, 0, 3, 0Fh, 3Ch, 0F0h, 0C0h
				db 0Fh,	3Ch, 0F0h, 0C0h, 0, 80h, 80h, 80h
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C0h
				db 0C0h, 0C0h, 0C0h, 0C0h, 0C0h, 0C3h, 0CCh, 0F0h
				db 80h,	83h, 8Ch, 0B0h,	0C0h, 80h, 80h,	80h
				db 0, 80h, 80h,	80h, 80h, 83h, 8Ch, 0B0h
				db 0C0h, 81h, 82h, 82h,	80h, 80h, 80h, 80h
				db 0C0h, 0A0h, 0A0h, 80h, 83h, 8Fh, 0BFh, 0BCh
				db 0C0h, 0C0h, 0C0h, 0C0h, 40h,	0C0h, 0, 0
				db 0C3h, 0CFh, 0DFh, 0DCh, 0F0h, 0C0h, 0, 0
				db 70h,	0C0h, 0, 0, 0, 0, 0, 0
				db 83h,	8Fh, 0BFh, 0BCh, 70h, 0C0h, 0, 0
				db 0C0h, 0C1h, 0C2h, 0C2h, 0C0h, 0C0h, 0C0h, 0C0h
				db 0, 0, 0, 0, 0, 0, 0,	3
				db 43h,	13h, 7,	3, 0, 0, 0, 0
				db 0Fh,	3Ch, 0F0h, 0C0h, 0, 0, 0, 0
				db 0, 0, 0, 0C0h, 0F0h,	3Ch, 0Fh, 3
				db 0, 0, 0, 0, 0, 0, 0,	0C0h
				db 0F0h, 3Ch, 0Fh, 3, 0, 0, 0, 0
				db 3, 3, 3, 3, 3, 3, 3,	3
				db 0, 0, 0, 0, 2, 8, 20h, 80h
				db 0, 0, 0, 0, 40h, 10h, 4, 1
				db 0C2h, 0C8h, 0E0h, 0C0h, 0, 0, 0, 0
				db 3, 3, 3, 3, 2, 8, 20h, 80h
				db 0C0h, 0C0h, 0C0h, 0C0h, 40h,	10h, 4,	1
				db 0, 0, 0, 0, 1, 3, 6,	5
				db 1, 7, 1Ch, 73h, 0CFh, 3Fh, 7Fh, 0BCh
				db 8Fh,	1Ch, 0D0h, 0E0h, 0E0h, 0C0h, 3Ch, 0FFh
				db 5, 35h, 0F4h, 0C5h, 5, 5, 4,	4
				db 0D3h, 0CFh, 0DFh, 3Fh, 0CCh,	0F3h, 0FCh, 3Fh
				db 0FCh, 0F3h, 0CFh, 3Fh, 0FFh,	0FFh, 0FFh, 3Fh
				db 0C0h, 0F0h, 0FCh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db 0, 0, 0, 0, 0C0h, 0F0h, 0FCh, 0F9h
				db 0Fh,	3, 0, 0, 0, 0, 0, 0
				db 0CFh, 0F3h, 0FCh, 3Fh, 0Fh, 3, 0, 0
				db 0FFh, 0FFh, 0FEh, 39h, 0D7h,	0ECh, 0EBh, 28h
				db 0E7h, 9Dh, 71h, 0CDh, 31h, 0C0h, 0, 0
				db 8, 8, 8, 0, 0, 0, 0,	0
				db 0, 1Ch, 7Fh,	1Fh, 67h, 59h, 46h, 59h
				db 0, 0, 0, 0C0h, 0F0h,	0FCh, 70h, 8Ch
				db 56h,	5Eh, 46h, 58h, 56h, 5Eh, 46h, 58h
				db 0BCh, 0BCh, 0BCh, 0BCh, 0BCh, 0BCh, 0BCh, 0BCh
				db 56h,	5Eh, 66h, 18h, 6, 1, 0,	0
				db 0BCh, 0BCh, 0BDh, 0BDh, 0BCh, 0B8h, 0, 0
				db 18h,	7Eh, 1Fh, 67h, 59h, 46h, 5Bh, 5Bh
				db 0, 0, 80h, 0E0h, 0F8h, 7Eh, 9Fh, 66h
				db 0, 0, 0, 0, 0, 0, 80h, 0
				db 5Bh,	5Bh, 5Bh, 5Bh, 5Bh, 5Bh, 5Bh, 5Bh
				db 19h,	6Bh, 6Bh, 6Bh, 6Bh, 6Bh, 6Bh, 6Bh
				db 80h,	80h, 80h, 80h, 80h, 80h, 80h, 80h
				db 6Bh,	6Bh, 6Bh, 6Bh, 6Bh, 6Bh, 6Bh, 6Bh
				db 63h,	1Bh, 7,	1, 0, 0, 0, 0
				db 6Bh,	6Bh, 6Bh, 8Bh, 6Bh, 1Bh, 2, 0
				db 80h,	80h, 80h, 80h, 0B0h, 0BCh, 0Fh,	3
				db 3, 3, 3, 0C3h, 0F3h,	3Fh, 0Fh, 3
				db 0, 0, 0, 0, 0, 0, 3,	0Fh
				db 0, 0, 3, 0Fh, 3Fh, 0FFh, 0FFh, 0FFh
				db 30h,	0FCh, 0FFh, 0FFh, 0FFh,	0FFh, 0FFh, 0FFh
				db 0, 0, 0, 0C0h, 0F0h,	0FCh, 0FFh, 0FCh
				db 3Fh,	0Fh, 3,	0Ch, 0Bh, 8, 8,	8
				db 0FFh, 0FFh, 0FFh, 0FFh, 3Fh,	0CFh, 33h, 0Ch
				db 0FFh, 0FFh, 0FFh, 0FCh, 0F3h, 0CCh, 30h, 0C0h
				db 0F0h, 0CCh, 34h, 0C4h, 4, 4,	4, 4
				db 3Fh,	0FFh, 0FFh, 0FFh, 0FFh,	0FFh, 0FFh, 0FFh
				db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FCh
				db 0F3h, 0CCh, 30h, 0C0h, 0, 0,	0, 0
				db 0, 0, 0, 0, 0, 0, 0Ch, 34h
				db 0CCh, 0B4h, 0C4h, 84h, 84h, 80h, 8Fh, 3Fh
				db 0FFh, 3Fh, 8Fh, 80h,	82h, 82h, 82h, 82h
				db 2, 2, 2, 0, 0, 0, 0,	0
				db 0F0h, 0C0h, 10h, 10h, 10h, 10h, 10h,	10h
				db 8Fh,	1Ch, 0E0h, 30h,	0D0h, 0E0h, 0D4h, 0BBh
				db 7Dh,	0DDh, 0BBh, 0FBh, 0F7h,	0CFh, 0FDh, 3Eh
				db 0C0h, 70h, 0BCh, 0DFh, 0DFh,	0E9h, 0EEh, 0FEh
				db 73h,	8Dh, 0FEh, 39h,	0C7h, 0ECh, 0EBh, 28h
				db 1, 7, 1Ch, 70h, 0CDh, 3Bh, 7Bh, 0BCh
				db 43h,	5Bh, 3Dh, 3Dh, 5Ah, 42h, 5Bh, 5Bh
				db 19h,	6Bh, 0Bh, 6Bh, 0F3h, 0F3h, 6Bh,	0Bh
				db 0, 0, 0, 0, 0, 0, 0C0h, 0B0h
				db 0CCh, 0B4h, 8Ch, 84h, 84h, 4, 0C4h, 0F0h
				db 3Fh,	0Fh, 23h, 20h, 21h, 21h, 21h, 21h
				db 0FCh, 0F0h, 0C4h, 4,	4, 4, 4, 4
				db 1, 1, 1, 0, 0, 0, 0,	0
				db 0, 0, 3, 0Fh, 3Fh, 0FCh, 0F3h, 0CCh
				db 0, 0C0h, 0F0h, 0C0h,	30h, 0D0h, 10h,	0D0h
				db 3, 0Ch, 0Eh,	0Eh, 0Eh, 0Eh, 0Eh, 0Eh
				db 33h,	0CBh, 0BBh, 0BBh, 0BBh,	0BBh, 0BBh, 0BBh
				db 0D0h, 0D0h, 0D0h, 50h, 50h, 0D0h, 0D0h, 0D0h
				db 0Eh,	0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 2, 0
				db 0BBh, 0B8h, 0B3h, 8Ch, 0B0h,	0C0h, 0, 0
				db 30h,	0C0h, 0, 0, 0, 0, 0, 0
				db 70h,	0D8h, 66h, 3Dh,	0Dh, 3,	1, 0
				db 0, 0, 0, 80h, 40h, 0A0h, 0E0h, 0F0h
				db 0F0h, 60h, 90h, 0F0h, 0B0h, 0B0h, 0B0h, 0B0h
				db 30h,	0FCh, 3Fh, 0Ch,	0, 0F0h, 0, 0
				db 0Fh,	3Ch, 0F0h, 0C0h, 8, 8, 88h, 88h
				db 0C8h, 0C8h, 0C8h, 0C8h, 0C8h, 0C8h, 0C8h, 0C8h
				db 88h,	88h, 88h, 88h, 88h, 88h, 88h, 88h
				db 88h,	88h, 88h, 88h, 83h, 8Fh, 3Fh, 0FCh
				db 0, 0, 0, 4, 1Eh, 3Ch, 12h, 2Eh
				db 0, 0, 0, 0, 0, 0, 30h, 0FCh
				db 2Eh,	2Dh, 13h, 0ECh,	30h, 8,	8, 0
				db 0F0h, 0C0h, 20h, 20h, 0, 0, 0, 0
				db 1, 7, 1Fh, 7Fh, 1Fh,	67h, 79h, 5Eh
				db 80h,	60h, 98h, 0E6h,	98h, 66h, 9Eh, 7Eh
				db 5Fh,	5Bh, 57h, 5Fh, 67h, 1Bh, 7, 1
				db 7Eh,	7Ah, 72h, 76h, 7Eh, 78h, 60h, 80h
				db 6, 1Ah, 6Eh,	7Ah, 5Eh, 76h, 58h, 63h
				db 0C0h, 0C0h, 0C0h, 0C3h, 0CFh, 0FCh, 0F0h, 0C0h
				db 0C0h, 0B0h, 8Ch, 0E4h, 9Ch, 0C4h, 34h, 0Ch
				db 0F0h, 0C0h, 30h, 0D0h, 10h, 10h, 0, 0
				db 0, 0, 3, 0Fh, 3Fh, 0FFh, 0FFh, 0FCh
				db 0, 0, 0, 0C0h, 0F0h,	0C0h, 20h, 0E0h
				db 20h,	20h, 0,	0, 0, 0, 0, 0
				db 3Fh,	0FFh, 0FFh, 0FCh, 0F3h,	0CDh, 31h, 0C1h
				db 3Fh,	0Fh, 33h, 2Ch, 23h, 22h, 2, 2
				db 0F0h, 3Ch, 0Fh, 0C3h, 0F0h, 0C0h, 20h, 0E0h
				db 0, 0, 0, 0Ch, 3Fh, 0FCh, 0F3h, 0CDh
				db 31h,	0CDh, 0B5h, 0B1h, 8Dh, 0B5h, 0B1h, 8Dh
				db 0B5h, 0BDh, 0B3h, 8Ch, 0B0h,	0C0h, 0, 0
				db 0Eh,	2Eh, 0EEh, 0CEh, 0Eh, 0Eh, 2, 0
				db 5Eh,	52h, 5Eh, 5Eh, 46h, 58h, 5Eh, 52h
				db 5Eh,	56h, 5Eh, 46h, 58h, 5Eh, 52h, 5Eh
				db 0, 0, 0, 0C0h, 0F0h,	0FCh, 0FFh, 0F3h
				db 0FFh, 0FFh, 0FCh, 0F3h, 0CFh, 3Fh, 0CFh, 0F3h
				db 0CCh, 3Fh, 0FFh, 0FFh, 0FFh,	0FFh, 0FCh, 0F3h
				db 0F0h, 3Ch, 0CFh, 0F3h, 0CFh,	3Ch, 0F3h, 0CBh
				db 3Ch,	4Fh, 73h, 7Ch, 7Fh, 3Eh, 0Eh, 2
				db 0CFh, 3Ch, 0F3h, 0CFh, 3Fh, 0DFh, 0DCh, 0D0h
				db 3Bh,	0FBh, 0FBh, 0F3h, 0C3h,	3, 0, 0
				db 0, 0, 0, 0C0h, 0, 0,	0, 0
				db 0C0h, 0F0h, 3Ch, 4Fh, 43h, 60h, 1Ah,	0C6h
				db 0, 0, 3, 1, 39h, 11h, 19h, 15h
				db 0, 0, 80h, 0, 80h, 40h, 0, 0
				db 10h,	10h, 1,	7, 1Fh,	27h, 39h, 3Eh
				db 18h,	6Eh, 0EFh, 0EFh, 0EFh, 96h, 0F9h, 67h
				db 0, 0, 80h, 0E0h, 90h, 70h, 0F0h, 0F0h
				db 3Fh,	3Fh, 1Fh, 7, 1,	2, 1Bh,	6
				db 9Fh,	0FFh, 0BFh, 0BEh, 0B8h,	60h, 0,	3
				db 0F0h, 0E0h, 80h, 3, 0Fh, 3Ch, 0F0h, 0C0h
				db 0Ch,	3Ch, 0F4h, 0E8h, 68h, 88h, 88h,	94h
				db 0, 0, 0, 3, 0Fh, 3Eh, 36h, 28h
				db 28h,	9, 8, 14h, 4, 8, 0, 0
				db 84h,	48h, 40h, 80h, 0, 0, 0,	0
				db 0C0h, 60h, 80h, 0, 0, 0, 0, 0
				db 0, 0, 0, 3, 0Fh, 3Ch, 0FCh, 0CBh
				db 88h,	60h, 19h, 6, 0,	0, 0, 0
				db 0FFh, 0FFh, 0FFh, 0FEh, 0FDh, 0FBh, 0FBh, 0F9h
				db 0FFh, 0FFh, 0FFh, 1Ch, 0E3h,	0ECh, 80h, 0E0h
				db 0F2h, 0C8h, 37h, 8Fh, 6Fh, 7Dh, 3Dh,	1Bh
				db 0, 0F0h, 0F8h, 0E8h,	0E8h, 0D8h, 0D3h, 0CFh
				db 27h,	78h, 7Fh, 5Fh, 0Fh, 0F0h, 0FFh,	0FCh
				db 2Fh,	0EFh, 0EFh, 0DCh, 33h, 0CDh, 31h, 0C1h
				db 0, 0, 0, 0C0h, 0F1h,	0FBh, 0FBh, 0F9h
				db 0, 0, 0, 0, 0E0h, 0E0h, 80h,	0E0h
				db 0, 0F0h, 0F8h, 0E8h,	0E8h, 0D8h, 0D0h, 0C0h
				db 20h,	0ECh, 0EFh, 0DFh, 33h, 0CDh, 31h, 0C1h
character_structs		db	 0,    0Bh,    2Eh,    2Eh,    18h,	 3,	 0; 0
							    ; DATA XREF: get_character_struct+Co
							    ; spawn_characters:loc_769Ao ...
				db	 1,	 0,    66h,    44h,	 3,	 1,	 0; 7
				db	 2,	 0,    44h,    68h,	 3,	 1,	 2; 14
				db	 3,    10h,    2Eh,    2Eh,    18h,	 3,    13h; 21
				db	 4,	 0,    3Dh,    67h,	 3,	 2,	 4; 28
				db	 5,	 0,    6Ah,    38h,    0Dh,	 0,	 0; 35
				db	 6,	 0,    48h,    5Eh,    0Dh,	 0,	 0; 42
				db	 7,	 0,    48h,    46h,    0Dh,	 0,	 0; 49
				db	 8,	 0,    50h,    2Eh,    0Dh,	 0,	 0; 56
				db	 9,	 0,    6Ch,    47h,    15h,	 4,	 0; 63
				db     0Ah,	 0,    5Ch,    34h,	 3,   0FFh,    38h; 70
				db     0Bh,	 0,    6Dh,    45h,	 3,	 0,	 0; 77
				db     0Ch,	 3,    28h,    3Ch,    18h,	 0,	 8; 84
				db     0Dh,	 2,    24h,    30h,    18h,	 0,	 8; 91
				db     0Eh,	 5,    28h,    3Ch,    18h,	 0,    10h; 98
				db     0Fh,	 5,    24h,    22h,    18h,	 0,    10h; 105
				db     10h,	 0,    44h,    54h,	 1,   0FFh,	 0; 112
				db     11h,	 0,    44h,    68h,	 1,   0FFh,	 0; 119
				db     12h,	 0,    66h,    44h,	 1,   0FFh,    18h; 126
				db     13h,	 0,    58h,    44h,	 1,   0FFh,    18h; 133
				db     14h,   0FFh,    34h,    3Ch,    18h,	 0,	 8; 140
				db     15h,   0FFh,    34h,    2Ch,    18h,	 0,	 8; 147
				db     16h,   0FFh,    34h,    1Ch,    18h,	 0,	 8; 154
				db     17h,   0FFh,    34h,    3Ch,    18h,	 0,    10h; 161
				db     18h,   0FFh,    34h,    2Ch,    18h,	 0,    10h; 168
				db     19h,   0FFh,    34h,    1Ch,    18h,	 0,    10h; 175
item_structs			item_struct <0,	0FFh, <64, 32, 2>, <120, 244>>
							    ; DATA XREF: is_item_discoverable:exterioro
							    ; is_item_discoverable_interior+2o	...
				item_struct <1,	9, <62,	48, 0>,	<124, 242>>
				item_struct <2,	0Ah, <73, 36, 16>, <119, 240>>
				item_struct <3,	0Bh, <42, 58, 4>, <132,	243>>
				item_struct <4,	0Eh, <50, 24, 2>, <122,	246>>
item_struct_5_bribe		item_struct <5,	0FFh, <36, 44, 4>, <126, 244>>
							    ; DATA XREF: accept_bribe+25w
				item_struct <6,	0Fh, <44, 65, 16>, <135, 241>>
item_struct_7_food		item_struct <7,	13h, <64, 48, 16>, <126, 240>>
							    ; DATA XREF: follow_suspicious_character+1Co
							    ; character_behaviour+19Fo	...
				item_struct <8,	1, <66,	52, 4>,	<124, 241>>
				item_struct <9,	16h, <60, 42, 0>, <123,	242>>
				item_struct <0Ah, 0Bh, <28, 34,	0>, <129, 248>>
				item_struct <0Bh, 0, <74, 72, 0>, <122,	110>>
item_struct_12_red_cross_parcel	item_struct <0Ch, 0FFh,	<28, 50, 12>, <133, 246>>
							    ; DATA XREF: event_new_red_cross_parcelr
							    ; event_new_red_cross_parcel+29o ...
				item_struct <0Dh, 12h, <36, 58,	8>, <133, 244>>
				item_struct <0Eh, 0FFh,	<36, 44, 4>, <126, 244>>
				item_struct <0Fh, 0FFh,	<52, 28, 4>, <126, 244>>
table_7738			dw offset unk_0		    ; 0
							    ; DATA XREF: element_A_of_table_7738+4o
				dw offset byte_DFAD	    ; 1
				dw offset byte_DFB1	    ; 2
				dw offset byte_DFB8	    ; 3
				dw offset byte_DFE5	    ; 4
				dw offset byte_DFE8	    ; 5
				dw offset byte_DFEC	    ; 6
				dw offset byte_DFF0	    ; 7
				dw offset byte_DFF2	    ; 8
				dw offset byte_DFF4	    ; 9
				dw offset byte_DFF0	    ; 10
				dw offset byte_DFF2	    ; 11
				dw offset byte_DFF4	    ; 12
				dw offset byte_DFF6	    ; 13
				dw offset byte_DFF9	    ; 14
				dw offset byte_DFF9	    ; 15
				dw offset byte_DFFF	    ; 16
				dw offset byte_E004	    ; 17
				dw offset byte_E009	    ; 18
				dw offset byte_E00B	    ; 19
				dw offset byte_E00D	    ; 20
				dw offset byte_E009	    ; 21
				dw offset byte_E00B	    ; 22
				dw offset byte_E00D	    ; 23
				dw offset byte_E00F	    ; 24
				dw offset byte_E011	    ; 25
				dw offset byte_E013	    ; 26
				dw offset byte_E015	    ; 27
				dw offset byte_E01B	    ; 28
				dw offset byte_E01D	    ; 29
				dw offset byte_E01F	    ; 30
				dw offset byte_E017	    ; 31
				dw offset byte_E019	    ; 32
				dw offset byte_E021	    ; 33
				dw offset byte_E023	    ; 34
				dw offset byte_E025	    ; 35
				dw offset byte_E027	    ; 36
				dw offset byte_E02D	    ; 37
				dw offset byte_E032	    ; 38
				dw offset byte_E037	    ; 39
				dw offset byte_E03D	    ; 40
				dw offset byte_E043	    ; 41
				dw offset byte_E049	    ; 42
				dw offset byte_E04B	    ; 43
				dw offset byte_E04D	    ; 44
				dw offset byte_E050	    ; 45
				db 0FFh
byte_DFAD			db 48h,	49h, 4Ah, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFB1			db 4Bh,	4Ch, 4Dh, 4Eh, 4Fh, 50h, 0FFh; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFB8			db 56h,	1Fh, 1Dh, 20h, 1Ah, 23h, 99h, 96h, 95h,	94h, 97h, 52h, 17h, 8Ah, 0Bh, 8Bh, 0Ch,	9Bh; 0
							    ; DATA XREF: seg000:table_7738o
				db 1Ch,	9Dh, 8Dh, 33h, 5Fh, 80h, 81h, 64h, 1, 0, 4, 10h, 85h, 33h, 7, 91h, 86h,	8, 12h,	89h; 18
				db 55h,	0Eh, 22h, 0A2h,	21h, 0A1h, 0FFh; 38
byte_DFE5			db 53h,	54h, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFE8			db 87h,	33h, 34h, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFEC			db 89h,	55h, 36h, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFF0			db 56h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFF2			db 57h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFF4			db 58h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFF6			db 5Ch,	5Dh, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFF9			db 33h,	5Fh, 80h, 81h, 60h, 0FFh; 0
							    ; DATA XREF: seg000:table_7738o
byte_DFFF			db 34h,	0Ah, 14h, 93h, 0FFh ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E004			db 38h,	34h, 0Ah, 14h, 0FFh ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E009			db 68h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E00B			db 69h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E00D			db 6Ah,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E00F			db 6Ch,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E011			db 6Dh,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E013			db 31h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E015			db 33h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E017			db 39h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E019			db 59h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E01B			db 70h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E01D			db 71h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E01F			db 72h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E021			db 73h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E023			db 74h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E025			db 75h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E027			db 36h,	0Ah, 97h, 98h, 52h, 0FFh; 0
							    ; DATA XREF: seg000:table_7738o
byte_E02D			db 18h,	17h, 8Ah, 36h, 0FFh ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E032			db 34h,	33h, 7,	5Ch, 0FFh   ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E037			db 34h,	33h, 7,	91h, 5Dh, 0FFh;	0
							    ; DATA XREF: seg000:table_7738o
byte_E03D			db 34h,	33h, 55h, 9, 5Ch, 0FFh;	0
							    ; DATA XREF: seg000:table_7738o
byte_E043			db 34h,	33h, 55h, 9, 5Dh, 0FFh;	0
							    ; DATA XREF: seg000:table_7738o
byte_E049			db 11h,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E04B			db 6Bh,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E04D			db 91h,	6Eh, 0FFh	    ; 0
							    ; DATA XREF: seg000:table_7738o
byte_E050			db 5Ah,	0FFh		    ; 0
							    ; DATA XREF: seg000:table_7738o
locations			dw 6844h		    ; 0	; DATA XREF: wassub_C651+50o
				dw 5444h		    ; 1
				dw 4644h		    ; 2
				dw 6640h		    ; 3
				dw 4040h		    ; 4
				dw 4444h		    ; 5
				dw 4040h		    ; 6
				dw 4044h		    ; 7
				dw 7068h		    ; 8
				dw 7060h		    ; 9
				dw 666Ah		    ; 10
				dw 685Dh		    ; 11
				dw 657Ch		    ; 12
				dw 707Ch		    ; 13
				dw 6874h		    ; 14
				dw 6470h		    ; 15
				dw 6078h		    ; 16
				dw 5880h		    ; 17
				dw 6070h		    ; 18
				dw 5474h		    ; 19
				dw 647Ch		    ; 20
				dw 707Ch		    ; 21
				dw 6874h		    ; 22
				dw 6470h		    ; 23
				dw 4466h		    ; 24
				dw 4066h		    ; 25
				dw 4060h		    ; 26
				dw 445Ch		    ; 27
				dw 4456h		    ; 28
				dw 4054h		    ; 29
				dw 444Ah		    ; 30
				dw 404Ah		    ; 31
				dw 4466h		    ; 32
				dw 4444h		    ; 33
				dw 6844h		    ; 34
				dw 456Bh		    ; 35
				dw 2D6Bh		    ; 36
				dw 2D4Dh		    ; 37
				dw 3D4Dh		    ; 38
				dw 3D3Dh		    ; 39
				dw 673Dh		    ; 40
				dw 4C74h		    ; 41
				dw 2A2Ch		    ; 42
				dw 486Ah		    ; 43
				dw 486Eh		    ; 44
				dw 6851h		    ; 45
				dw 3C34h		    ; 46
				dw 2C34h		    ; 47
				dw 1C34h		    ; 48
				dw 6B77h		    ; 49
				dw 6E7Ah		    ; 50
				dw 1C34h		    ; 51
				dw 3C28h		    ; 52
				dw 2224h		    ; 53
				dw 4C50h		    ; 54
				dw 4C59h		    ; 55
				dw 3C59h		    ; 56
				dw 3D64h		    ; 57
				dw 365Ch		    ; 58
				dw 3254h		    ; 59
				dw 3066h		    ; 60
				dw 3860h		    ; 61
				dw 3B4Fh		    ; 62
				dw 2F67h		    ; 63
				dw 3634h		    ; 64
				dw 2E34h		    ; 65
				dw 2434h		    ; 66
				dw 3E34h		    ; 67
				dw 3820h		    ; 68
				dw 1834h		    ; 69
				dw 2E2Ah		    ; 70
				dw 2222h		    ; 71
				dw 6E78h		    ; 72
				dw 6E76h		    ; 73
				dw 6E74h		    ; 74
				dw 6D79h		    ; 75
				dw 6D77h		    ; 76
				dw 6D75h		    ; 77
super_tiles			db 94h,	93h, 92h, 94h	    ; DATA XREF: get_super_tile+Eo
				db 92h,	92h, 94h, 93h
				db 91h,	94h, 7,	8
				db 3, 4, 5, 6
				db 91h,	92h, 7,	8
				db 7, 8, 9, 0Ah
				db 9, 0Ah, 0Bh,	17h
				db 0Ch,	17h, 18h, 1Fh
				db 94h,	93h, 92h, 94h
				db 92h,	91h, 94h, 93h
				db 91h,	94h, 7,	8
				db 7, 8, 9, 0Ah
				db 91h,	92h, 7,	8
				db 7, 8, 9, 0Ah
				db 9, 0Ah, 0Bh,	17h
				db 0Bh,	17h, 18h, 1Fh
				db 9, 0Ah, 0Bh,	17h
				db 0Bh,	17h, 18h, 1Fh
				db 18h,	1Fh, 19h, 1Ah
				db 19h,	1Ah, 1Eh, 17h
				db 18h,	1Fh, 19h, 1Ah
				db 19h,	1Ah, 1Eh, 17h
				db 1Eh,	17h, 1Dh, 1Ch
				db 1Dh,	1Ch, 19h, 1Bh
				db 93h,	92h, 91h, 92h
				db 91h,	93h, 91h, 94h
				db 91h,	91h, 93h, 94h
				db 26h,	27h, 28h, 29h
				db 94h,	93h, 92h, 94h
				db 92h,	91h, 94h, 93h
				db 91h,	94h, 93h, 94h
				db 2Ah,	92h, 94h, 91h
				db 6Dh,	2Bh, 91h, 93h
				db 19h,	2Ch, 2Dh, 93h
				db 1Eh,	17h, 18h, 2Eh
				db 1Dh,	1Ch, 19h, 2Fh
				db 1Eh,	17h, 1Dh, 1Ch
				db 1Dh,	1Ch, 19h, 1Bh
				db 19h,	1Bh, 35h, 36h
				db 35h,	36h, 34h, 0
				db 1Eh,	17h, 1Dh, 1Ch
				db 1Dh,	1Ch, 19h, 1Bh
				db 19h,	1Bh, 35h, 37h
				db 35h,	36h, 34h, 38h
				db 1Eh,	17h, 1Dh, 1Ch
				db 1Dh,	1Ch, 19h, 1Bh
				db 19h,	1Bh, 35h, 37h
				db 32h,	33h, 34h, 38h
				db 0Dh,	0Eh, 19h, 1Ah
				db 0, 0Fh, 10h,	17h
				db 0, 0, 11h, 12h
				db 8Bh,	0, 13h,	14h
				db 2, 0, 0, 0
				db 85h,	0, 86h,	87h
				db 1, 0, 88h, 89h
				db 1, 0, 0, 8Ah
				db 1, 0, 0, 81h
				db 85h,	0, 0, 4Eh
				db 6Ch,	0, 0, 50h
				db 6Bh,	69h, 66h, 4Eh
				db 82h,	0, 0, 15h
				db 83h,	84h, 0,	55h
				db 0, 68h, 0, 55h
				db 0, 4Eh, 0, 62h
				db 93h,	94h, 65h, 6Ah
				db 94h,	91h, 8Ch, 8Dh
				db 91h,	92h, 94h, 94h
				db 92h,	94h, 93h, 91h
				db 0, 4Eh, 0, 61h
				db 8Eh,	67h, 66h, 60h
				db 8Fh,	90h, 65h, 5Fh
				db 93h,	92h, 91h, 5Eh
				db 16h,	73h, 78h, 38h
				db 1, 73h, 0, 38h
				db 77h,	73h, 0,	63h
				db 76h,	58h, 0,	64h
				db 75h,	59h, 0,	49h
				db 74h,	5Ah, 4Ah, 4Bh
				db 5Ch,	5Bh, 91h, 93h
				db 5Dh,	93h, 92h, 94h
				db 9, 21h, 22h,	24h
				db 0Bh,	20h, 23h, 25h
				db 18h,	1Fh, 19h, 1Ah
				db 19h,	1Ah, 1Eh, 17h
				db 0, 0, 0, 49h
				db 0, 4Ch, 4Ah,	4Bh
				db 4Ah,	4Bh, 91h, 93h
				db 94h,	93h, 92h, 94h
				db 39h,	3Ah, 3Fh, 3Eh
				db 40h,	41h, 42h, 43h
				db 44h,	45h, 46h, 47h
				db 48h,	47h, 4Ah, 4Bh
				db 19h,	1Bh, 35h, 36h
				db 35h,	36h, 34h, 0
				db 34h,	7Dh, 0,	0
				db 0, 3Bh, 3Ch,	3Dh
				db 4Ah,	4Bh, 93h, 91h
				db 93h,	94h, 91h, 92h
				db 94h,	92h, 93h, 94h
				db 93h,	91h, 92h, 91h
				db 4Ah,	5Bh, 93h, 94h
				db 93h,	94h, 91h, 92h
				db 94h,	92h, 93h, 94h
				db 93h,	91h, 92h, 91h
				db 91h,	93h, 94h, 92h
				db 92h,	94h, 91h, 94h
				db 94h,	93h, 91h, 92h
				db 30h,	92h, 94h, 93h
				db 31h,	93h, 92h, 91h
				db 91h,	92h, 91h, 94h
				db 93h,	94h, 93h, 91h
				db 94h,	93h, 94h, 92h
				db 19h,	1Bh, 35h, 6Eh
				db 35h,	33h, 34h, 55h
				db 34h,	73h, 0,	56h
				db 0, 73h, 0, 55h
				db 79h,	73h, 0,	55h
				db 0, 58h, 0, 7Eh
				db 7Ah,	59h, 79h, 56h
				db 78h,	5Ah, 4Ah, 57h
				db 34h,	0, 0, 7Ch
				db 0, 3Bh, 72h,	0
				db 39h,	4Fh, 4Eh, 0
				db 4Eh,	0, 80h,	7Bh
				db 50h,	0, 7Fh,	4Ch
				db 51h,	0, 4Dh,	4Bh
				db 52h,	53h, 54h, 91h
				db 6Fh,	70h, 71h, 94h
				db 34h,	0, 0, 38h
				db 7Bh,	78h, 0,	38h
				db 7Ch,	79h, 0,	38h
				db 7Ah,	0, 0, 38h
				db 19h,	1Bh, 35h, 36h
				db 35h,	36h, 34h, 7Bh
				db 34h,	0, 0, 7Ch
				db 0, 3Bh, 3Ch,	3Dh
				db 34h,	0, 0, 38h
				db 77h,	0, 0, 38h
				db 79h,	0, 0, 63h
				db 7Ah,	0, 0, 64h
				db 94h,	93h, 92h, 94h
				db 92h,	91h, 94h, 93h
				db 91h,	94h, 93h, 94h
				db 93h,	92h, 94h, 91h
				db 93h,	92h, 91h, 92h
				db 91h,	93h, 91h, 93h
				db 91h,	91h, 93h, 94h
				db 94h,	92h, 94h, 93h
				db 93h,	94h, 93h, 91h
				db 94h,	91h, 94h, 93h
				db 91h,	92h, 94h, 94h
				db 92h,	94h, 93h, 91h
				db 0AFh, 0B9h, 0C4h, 0B0h
				db 0C5h, 0B9h, 0BAh, 0B0h
				db 96h,	0BBh, 0B6h, 0C6h
				db 94h,	93h, 0BCh, 98h
				db 0, 0F0h, 0F1h, 0
				db 0B3h, 0F2h, 0F3h, 0
				db 0AFh, 0B5h, 95h, 0B4h
				db 0AFh, 0B7h, 0B8h, 0B0h
				db 0, 0, 0, 0
				db 0B3h, 0F4h, 0, 0
				db 0AFh, 0B5h, 95h, 0B4h
				db 0AFh, 0B7h, 0B8h, 0B0h
				db 0AEh, 0C0h, 0C1h, 9Ch
				db 0F8h, 0C2h, 91h, 92h
				db 94h,	92h, 93h, 94h
				db 93h,	91h, 92h, 91h
				db 0B2h, 9Bh, 0BEh, 0B0h
				db 0AFh, 0BDh, 0BFh, 0B0h
				db 0AFh, 0B9h, 0BAh, 0F9h
				db 0AFh, 0B9h, 0BAh, 0C3h
				db 0E3h, 0E2h, 0E5h, 0
				db 0E5h, 0, 0, 0
				db 0, 0, 0, 0
				db 0, 0, 0F5h, 0B1h
				db 0F6h, 0C7h, 99h, 9Ch
				db 99h,	0C8h, 91h, 93h
				db 91h,	91h, 93h, 94h
				db 94h,	92h, 94h, 93h
				db 1Eh,	45h, 45h, 44h
				db 1Eh,	45h, 48h, 49h
				db 1Eh,	4Ah, 4Bh, 4Ch
				db 4Dh,	7Bh, 65h, 0Ah
				db 52h,	51h, 54h, 6Dh
				db 54h,	6Dh, 6Dh, 6Dh
				db 18h,	64h, 3Ah, 43h
				db 47h,	46h, 45h, 44h
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 65h, 0Ah
				db 65h,	36h, 8,	0Bh
				db 8, 37h, 0, 1
				db 13h,	6Dh, 6Dh, 53h
				db 0Dh,	53h, 52h, 51h
				db 6Ah,	51h, 54h, 6Dh
				db 6Ch,	6Dh, 4Eh, 4Fh
				db 0Fh,	6Dh, 6Dh, 50h
				db 0Dh,	6Dh, 6Dh, 6Dh
				db 14h,	19h, 6Dh, 6Dh
				db 15h,	16h, 6Dh, 6Dh
				db 0Fh,	6Dh, 6Dh, 6Dh
				db 0Dh,	6Dh, 65h, 0Ah
				db 9, 0Ah, 8, 0Bh
				db 8, 0Bh, 2, 0
				db 1Eh,	45h, 48h, 49h
				db 1Eh,	4Ah, 4Bh, 4Ch
				db 4Dh,	7Bh, 6Dh, 53h
				db 6Dh,	53h, 52h, 51h
				db 6Dh,	6Dh, 6Dh, 53h
				db 6Dh,	53h, 52h, 51h
				db 52h,	51h, 54h, 6Dh
				db 54h,	4Eh, 4Fh, 6Dh
				db 6Dh,	6Dh, 50h, 6Dh
				db 7Ch,	19h, 6Dh, 6Dh
				db 17h,	16h, 1Ah, 6Dh
				db 18h,	1Ch, 1Bh, 6Dh
				db 7Ch,	19h, 6Dh, 6Dh
				db 17h,	16h, 65h, 0Ah
				db 7Dh,	36h, 8,	0Bh
				db 8, 37h, 0, 1
				db 6Dh,	7Ch, 50h, 6Dh
				db 6Dh,	7Eh, 7Fh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 7Dh,	36h, 8,	0Bh
				db 8, 37h, 0, 2
				db 0, 0, 2, 3
				db 3, 1, 3, 2
				db 52h,	51h, 54h, 6Dh
				db 54h,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	7Ch, 19h, 6Dh
				db 6Dh,	17h, 16h, 1Ah
				db 7Ch,	18h, 1Ch, 1Bh
				db 7Eh,	7Fh, 6Dh, 6Dh
				db 6Dh,	6Dh, 7Dh, 0Ah
				db 6Dh,	6Dh, 6Dh, 0Eh
				db 4, 63h, 6Dh,	0Ch
				db 5, 80h, 4, 6
				db 0, 2, 5, 7
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 58h,	6Dh, 6Dh, 6Dh
				db 59h,	5Ah, 58h, 6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 55h, 57h
				db 58h,	6Dh, 6Dh, 12h
				db 59h,	5Ah, 58h, 0Ch
				db 6Dh,	5Bh, 59h, 69h
				db 6Dh,	6Dh, 6Dh, 6Bh
				db 70h,	6Dh, 56h, 6Dh
				db 73h,	74h, 6Dh, 6Dh
				db 77h,	78h, 6Dh, 6Dh
				db 4, 66h, 6Dh,	6Dh
				db 6Dh,	6Dh, 6Dh, 0Eh
				db 6Dh,	6Dh, 6Dh, 0Ch
				db 6Dh,	6Dh, 6Dh, 12h
				db 6Dh,	6Dh, 6Dh, 10h
				db 5, 7, 4, 66h
				db 3, 0, 5, 7
				db 0, 1, 3, 3
				db 1, 3, 2, 0
				db 58h,	6Dh, 6Dh, 6Dh
				db 59h,	5Ah, 58h, 6Dh
				db 38h,	5Bh, 59h, 5Ah
				db 3Bh,	39h, 63h, 5Bh
				db 3Ch,	5Eh, 3Dh, 3Eh
				db 3Ch,	5Eh, 5Eh, 1Fh
				db 3Ch,	5Eh, 5Eh, 1Fh
				db 3Fh,	40h, 5Eh, 1Fh
				db 5Ch,	41h, 42h, 1Fh
				db 4, 66h, 5, 5Dh
				db 5, 7, 4, 63h
				db 2, 3, 5, 80h
				db 58h,	6Dh, 6Dh, 6Dh
				db 59h,	5Ah, 58h, 6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 6Dh,	6Dh, 56h, 74h
				db 70h,	6Dh, 81h, 78h
				db 73h,	6Dh, 6Dh, 6Dh
				db 4, 63h, 6Dh,	6Dh
				db 6Dh,	82h, 6Dh, 6Dh
				db 74h,	6Dh, 6Dh, 6Dh
				db 73h,	6Dh, 6Dh, 6Dh
				db 4, 63h, 6Dh,	6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 55h,	57h, 74h, 6Dh
				db 56h,	81h, 78h, 6Dh
				db 5, 80h, 4, 63h
				db 1, 0, 5, 80h
				db 0, 3, 2, 3
				db 2, 1, 3, 0
				db 86h,	6Dh, 56h, 6Dh
				db 85h,	6Eh, 6Fh, 70h
				db 84h,	71h, 72h, 73h
				db 83h,	63h, 76h, 77h
				db 87h,	5Bh, 59h, 5Ah
				db 86h,	82h, 6Dh, 5Bh
				db 84h,	6Dh, 6Dh, 6Dh
				db 87h,	6Dh, 55h, 57h
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 55h,	57h, 6Dh, 6Dh
				db 56h,	6Dh, 55h, 57h
				db 6Dh,	6Dh, 56h, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 82h,	6Dh, 6Dh, 6Eh
				db 4, 66h, 6Dh,	71h
				db 6Dh,	74h, 56h, 6Dh
				db 81h,	78h, 6Dh, 6Dh
				db 82h,	6Dh, 6Dh, 6Dh
				db 4, 63h, 6Dh,	6Dh
				db 70h,	6Dh, 56h, 6Dh
				db 73h,	74h, 6Dh, 6Dh
				db 77h,	78h, 6Dh, 81h
				db 4, 66h, 6Dh,	82h
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 38h,	6Dh, 6Dh, 6Dh
				db 3Bh,	39h, 63h, 6Dh
				db 3Fh,	40h, 3Dh, 3Eh
				db 71h,	72h, 73h, 74h
				db 38h,	76h, 77h, 78h
				db 3Bh,	39h, 63h, 6Dh
				db 3Fh,	40h, 3Dh, 3Eh
				db 58h,	6Dh, 6Dh, 6Dh
				db 59h,	5Ah, 58h, 6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Eh,	6Fh, 70h, 5Bh
				db 38h,	5Bh, 59h, 5Ah
				db 3Bh,	39h, 63h, 5Bh
				db 3Ch,	5Eh, 3Dh, 3Eh
				db 3Ch,	5Eh, 5Eh, 1Fh
				db 3Ch,	5Eh, 5Eh, 1Fh
				db 3Fh,	40h, 5Eh, 1Fh
				db 5Ch,	41h, 42h, 1Fh
				db 4, 63h, 5, 5Dh
				db 86h,	6Dh, 6Dh, 6Dh
				db 84h,	6Dh, 6Dh, 6Dh
				db 87h,	6Dh, 6Dh, 6Dh
				db 86h,	5Ah, 58h, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 4, 66h, 82h,	6Dh
				db 5, 7, 4, 63h
				db 2, 3, 5, 80h
				db 6Eh,	6Fh, 70h, 6Dh
				db 71h,	72h, 73h, 74h
				db 75h,	76h, 77h, 78h
				db 6Dh,	6Dh, 82h, 6Dh
				db 3Ch,	5Eh, 5Eh, 1Fh
				db 3Fh,	40h, 5Eh, 1Fh
				db 5Ch,	41h, 42h, 1Fh
				db 6Dh,	6Dh, 5,	5Dh
				db 87h,	6Dh, 6Dh, 5Bh
				db 86h,	82h, 55h, 57h
				db 84h,	6Eh, 56h, 6Dh
				db 87h,	82h, 6Dh, 6Dh
				db 55h,	57h, 6Dh, 6Dh
				db 56h,	6Dh, 55h, 57h
				db 6Dh,	6Dh, 56h, 6Dh
				db 73h,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Eh, 6Fh
				db 6Dh,	6Dh, 71h, 72h
				db 58h,	6Dh, 75h, 76h
				db 59h,	5Ah, 58h, 6Dh
				db 86h,	6Dh, 6Dh, 6Dh
				db 84h,	5Ah, 58h, 6Dh
				db 87h,	5Bh, 59h, 5Ah
				db 86h,	6Dh, 6Dh, 5Bh
				db 86h,	6Dh, 6Dh, 74h
				db 84h,	6Dh, 81h, 78h
				db 84h,	6Dh, 82h, 6Dh
				db 87h,	66h, 6Dh, 6Dh
				db 6Eh,	6Fh, 70h, 12h
				db 71h,	72h, 73h, 10h
				db 75h,	76h, 77h, 0Eh
				db 6Dh,	6Dh, 6Dh, 0Ch
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 65h,	7Ch, 6Dh, 6Dh
				db 8, 7Eh, 7Fh,	6Dh
				db 6Dh,	6Dh, 6Dh, 7Ch
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 86h,	3Fh, 40h, 5Eh
				db 85h,	5Ch, 41h, 88h
				db 84h,	6Dh, 82h, 5
				db 83h,	63h, 6Dh, 6Dh
				db 5Eh,	3Dh, 3Eh, 0Eh
				db 40h,	5Eh, 1Fh, 0Ch
				db 41h,	42h, 1Fh, 12h
				db 58h,	5, 5Dh,	10h
				db 87h,	6Dh, 6Dh, 5Bh
				db 86h,	38h, 81h, 78h
				db 84h,	3Bh, 39h, 63h
				db 87h,	3Ch, 5Eh, 3Dh
				db 59h,	5Ah, 58h, 0Eh
				db 6Dh,	5Bh, 59h, 5Fh
				db 6Dh,	6Dh, 81h, 6Bh
				db 39h,	63h, 82h, 10h
				db 86h,	3Fh, 40h, 5Eh
				db 84h,	5Ch, 41h, 88h
				db 87h,	5Ah, 58h, 5
				db 86h,	5Bh, 59h, 5Ah
				db 0Fh,	53h, 52h, 51h
				db 6Ah,	51h, 54h, 7Fh
				db 6Ch,	4Eh, 4Fh, 6Dh
				db 11h,	6Dh, 50h, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 4, 66h, 6Dh,	6Dh
				db 5, 7, 4, 63h
				db 3, 2, 5, 80h
				db 6Dh,	6Fh, 70h, 6Dh
				db 81h,	72h, 73h, 6Dh
				db 82h,	76h, 77h, 6Dh
				db 4, 66h, 82h,	6Dh
				db 66h,	6Dh, 6Dh, 6Dh
				db 7, 74h, 6Eh,	6Dh
				db 81h,	78h, 4,	82h
				db 82h,	6Dh, 5,	6Dh
				db 0A1h, 9Ah, 0A3h, 0A4h
				db 86h,	6Dh, 8Eh, 9Ah
				db 85h,	5Ah, 58h, 81h
				db 84h,	5Bh, 59h, 5Ah
				db 8Eh,	8Fh, 90h, 91h
				db 6Eh,	5Ah, 8Eh, 94h
				db 82h,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 0Fh,	6Dh, 64h, 20h
				db 8Bh,	0Ah, 2Dh, 1Fh
				db 8Ch,	2Ch, 2Eh, 1Fh
				db 8Dh,	28h, 29h, 68h
				db 17h,	16h, 1Ah, 9Bh
				db 18h,	1Ch, 1Bh, 9Ch
				db 6Dh,	53h, 52h, 9Dh
				db 52h,	51h, 54h, 9Ch
				db 92h,	93h, 6Dh, 9Dh
				db 95h,	96h, 9Ah, 9Fh
				db 8Eh,	97h, 95h, 96h
				db 59h,	5Ah, 8Eh, 97h
				db 54h,	19h, 6Dh, 9Bh
				db 17h,	16h, 6Dh, 9Ch
				db 6Dh,	7Dh, 6Dh, 9Dh
				db 7Ch,	19h, 6Dh, 9Eh
				db 9Ah,	0A0h, 0, 1
				db 95h,	96h, 9Ah, 0A0h
				db 8Eh,	97h, 95h, 96h
				db 59h,	5Ah, 8Eh, 97h
				db 2, 0, 1, 0
				db 3, 1, 2, 3
				db 9Ah,	0A0h, 1, 0
				db 95h,	96h, 9Ah, 0A0h
				db 8Eh,	97h, 95h, 96h
				db 59h,	5Ah, 8Eh, 94h
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Eh, 74h, 5Bh
				db 6Dh,	81h, 78h, 6Dh
				db 6Dh,	82h, 6Dh, 6Dh
				db 0, 3, 0B2h, 0B3h
				db 0A0h, 1, 0B6h, 0B7h
				db 8Eh,	9Ah, 0A0h, 2
				db 58h,	82h, 8Eh, 9Ah
				db 2, 0, 1, 0
				db 3, 1, 2, 3
				db 1, 0, 0A6h, 0A7h
				db 0A6h, 0A7h, 0A8h, 6Dh
				db 2, 1, 0A6h, 0A7h
				db 0A6h, 0A7h, 0A8h, 6Dh
				db 0A8h, 6Dh, 0A5h, 0A4h
				db 0A5h, 0A4h, 0, 3
				db 0B4h, 0B5h, 2, 1
				db 0B8h, 0B9h, 3, 0B1h
				db 2, 0B1h, 0AFh, 0B0h
				db 0AFh, 0B0h, 6Dh, 53h
				db 0ADh, 0AEh, 0AFh, 0A2h
				db 0AFh, 0B0h, 7Eh, 9Eh
				db 7Ch,	53h, 52h, 9Bh
				db 52h,	51h, 54h, 9Ch
				db 2, 3, 0, 2
				db 0, 0, 2, 3
				db 0AAh, 0ABh, 3, 2
				db 6Dh,	0A9h, 0AAh, 0ABh
				db 0AAh, 0ABh, 3, 0
				db 6Dh,	0A9h, 0AAh, 0ABh
				db 0ADh, 0ACh, 6Dh, 0A9h
				db 2, 1, 0ADh, 0ACh
				db 0BDh, 6Dh, 0A5h, 0A4h
				db 0BFh, 0A4h, 1, 0
				db 0, 2, 3, 0B1h
				db 0, 0B1h, 0AFh, 0B0h
				db 0A8h, 6Dh, 0A5h, 0A4h
				db 0A5h, 0A4h, 1, 0
				db 0, 2, 3, 0B1h
				db 0, 0B1h, 0AFh, 0B0h
				db 0BEh, 0B0h, 0BAh, 0BCh
				db 0BFh, 0BCh, 0BBh, 6Dh
				db 6Dh,	7Ch, 0BBh, 6Dh
				db 6Dh,	7Eh, 7Fh, 6Dh
				db 0AFh, 0B0h, 0BAh, 0BCh
				db 0A5h, 0BCh, 0BBh, 7Ch
				db 6Dh,	6Dh, 0BBh, 6Dh
				db 6Dh,	6Dh, 6Dh, 6Dh
				db 2, 3, 0FEh, 0B1h
				db 1, 0B1h, 0AFh, 0B0h
				db 0AFh, 0B0h, 0A5h, 0BCh
				db 0A5h, 0BCh, 6Dh, 6Dh
				db 0AFh, 0B0h, 0BAh, 0C1h
				db 0A5h, 0BCh, 6Dh, 5Bh
				db 89h,	6Dh, 55h, 57h
				db 87h,	6Dh, 56h, 6Dh
				db 0C5h, 28h, 33h, 15h
				db 0C4h, 28h, 29h, 1Fh
				db 5, 2Ah, 25h,	0C2h
				db 0, 0B1h, 0C3h, 0B0h
				db 85h,	5Bh, 59h, 5Ah
				db 0C7h, 63h, 6Dh, 5Bh
				db 0C6h, 24h, 4, 23h
				db 0C6h, 26h, 27h, 1Fh
				db 6Dh,	6Dh, 6Dh, 5Bh
				db 70h,	38h, 81h, 78h
				db 73h,	3Bh, 39h, 63h
				db 6Dh,	3Ch, 5Eh, 3Dh
				db 0B4h, 0B5h, 2, 1
				db 0B8h, 0B9h, 3, 0
				db 0, 2, 3, 1
				db 0A0h, 0, 1, 2
				db 0ADh, 0ACh, 6Dh, 0A9h
				db 3, 0, 0ADh, 0ACh
				db 0, 1, 3, 3
				db 1, 3, 2, 0
				db 59h,	5Ah, 58h, 6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 6Dh,	6Dh, 81h, 5Bh
				db 39h,	63h, 82h, 6Dh
				db 5Eh,	3Dh, 3Eh, 6Dh
				db 40h,	5Eh, 1Fh, 70h
				db 41h,	42h, 1Fh, 73h
				db 58h,	5, 5Dh,	6Dh
				db 8Eh,	9Ah, 0A0h, 1
				db 58h,	6Dh, 8Eh, 9Ah
				db 59h,	5Ah, 58h, 6Dh
				db 6Dh,	5Bh, 59h, 5Ah
				db 86h,	6Fh, 70h, 6Dh
				db 85h,	72h, 73h, 74h
				db 84h,	76h, 77h, 78h
				db 83h,	63h, 6Dh, 6Dh
				db 0Fh,	6Dh, 6Dh, 6Dh
				db 0Dh,	7Ch, 19h, 6Dh
				db 13h,	17h, 16h, 1Ah
				db 11h,	18h, 1Ch, 1Bh
				db 8, 9, 0Bh, 9
				db 8, 9, 0Bh, 9
				db 8, 9, 0Bh, 9
				db 10h,	9, 0Bh,	9
				db 11h,	0Fh, 0Bh, 9
				db 15h,	13h, 0Dh, 0Fh
				db 12h,	16h, 12h, 13h
				db 13h,	14h, 15h, 15h
				db 0Bh,	9, 0Bh,	0Ch
				db 0Bh,	9, 0Bh,	0Ch
				db 0Dh,	0Fh, 0Bh, 0Ch
				db 14h,	13h, 0Dh, 0Eh
				db 0Bh,	9, 0Ah,	6
				db 0Bh,	9, 0Bh,	0Ch
				db 0Bh,	9, 0Bh,	0Ch
				db 0Bh,	9, 0Bh,	0Ch
				db 15h,	14h, 13h, 12h
				db 2, 12h, 14h,	15h
				db 5, 6, 2, 16h
				db 0Ah,	6, 5, 6
				db 7, 1, 2, 17h
				db 3, 6, 5, 6
				db 8, 9, 0Ah, 6
				db 8, 9, 0Bh, 9
				db 14h,	16h, 12h, 13h
				db 15h,	14h, 13h, 17h
				db 17h,	13h, 15h, 14h
				db 2, 12h, 13h,	12h
				db 16h,	15h, 17h, 14h
				db 14h,	13h, 15h, 12h
				db 16h,	12h, 17h, 13h
				db 15h,	14h, 13h, 17h
				db 1Eh,	20h, 1Eh, 1Fh
				db 1Eh,	20h, 1Eh, 1Fh
				db 1Eh,	20h, 1Eh, 1Fh
				db 1Eh,	20h, 1Eh, 1Fh
				db 1Eh,	20h, 22h, 23h
				db 22h,	21h, 17h, 14h
				db 14h,	13h, 15h, 12h
				db 16h,	12h, 17h, 13h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 22h, 21h
				db 24h,	21h, 17h, 13h
				db 1Bh,	0, 1Eh,	20h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 17h,	18h, 19h, 1Ah
				db 1Bh,	1Ch, 1Bh, 1Dh
				db 1Bh,	0, 1Eh,	1Fh
				db 1Eh,	20h, 1Eh, 1Fh
				db 13h,	15h, 14h, 15h
				db 14h,	16h, 17h, 18h
				db 17h,	18h, 1Bh, 1Ch
				db 1Bh,	1Ch, 1Bh, 0
				db 16h,	15h, 17h, 14h
				db 14h,	13h, 15h, 12h
				db 12h,	16h, 17h, 13h
				db 15h,	17h, 13h, 18h
				db 16h,	14h, 15h, 12h
				db 13h,	69h, 6Ah, 13h
				db 15h,	6Bh, 6Ch, 14h
				db 14h,	13h, 16h, 12h
				db 28h,	27h, 26h, 29h
				db 2, 28h, 29h,	27h
				db 5, 6, 2, 17h
				db 0Ah,	6, 5, 6
				db 27h,	28h, 29h, 28h
				db 26h,	29h, 28h, 27h
				db 28h,	27h, 27h, 26h
				db 2, 28h, 26h,	18h
				db 26h,	28h, 27h, 28h
				db 28h,	27h, 29h, 18h
				db 26h,	18h, 1Bh, 1Ch
				db 1Bh,	1Ch, 1Bh, 0
				db 2Dh,	20h, 1Eh, 20h
				db 2Dh,	20h, 1Eh, 20h
				db 2Dh,	20h, 22h, 21h
				db 2Bh,	21h, 17h, 13h
				db 0Bh,	9, 0Bh,	2Ch
				db 0Bh,	9, 0Bh,	2Ch
				db 0Dh,	0Fh, 0Bh, 2Ch
				db 13h,	14h, 0Dh, 2Ah
				db 0Bh,	9, 0Ah,	2Eh
				db 0Bh,	9, 0Bh,	2Ch
				db 0Bh,	9, 0Bh,	2Ch
				db 0Bh,	9, 0Bh,	2Ch
				db 2Fh,	0, 1Eh,	20h
				db 2Dh,	20h, 1Eh, 20h
				db 2Dh,	20h, 1Eh, 20h
				db 2Dh,	20h, 1Eh, 20h
				db 15h,	14h, 13h, 12h
				db 2, 17h, 14h,	15h
				db 5, 6, 2, 17h
				db 0Ah,	6, 5, 30h
				db 13h,	15h, 14h, 15h
				db 14h,	16h, 17h, 18h
				db 17h,	18h, 1Bh, 1Ch
				db 31h,	1Ch, 1Bh, 0
				db 42h,	9, 0Bh,	3Ah
				db 41h,	9, 0Bh,	3Ah
				db 3Dh,	3Eh, 3Bh, 3Ah
				db 13h,	17h, 3Dh, 3Ch
				db 36h,	3Eh, 3Bh, 45h
				db 12h,	13h, 3Dh, 46h
				db 14h,	15h, 14h, 13h
				db 12h,	13h, 12h, 14h
				db 44h,	38h, 37h, 6
				db 42h,	43h, 40h, 39h
				db 42h,	9, 0Bh,	3Fh
				db 42h,	9, 0Bh,	3Ah
				db 35h,	9, 0Bh,	47h
				db 35h,	9, 0Bh,	45h
				db 34h,	9, 0Bh,	45h
				db 35h,	9, 0Bh,	45h
				db 7, 1, 2, 17h
				db 32h,	6, 5, 6
				db 33h,	38h, 37h, 6
				db 34h,	43h, 40h, 38h
				db 16h,	15h, 14h, 15h
				db 2, 17h, 13h,	17h
				db 5, 6, 2, 15h
				db 41h,	6, 5, 6
				db 29h,	27h, 28h, 29h
				db 2, 28h, 29h,	27h
				db 5, 6, 2, 26h
				db 0Ah,	6, 5, 6
				db 8, 9, 0Bh, 9
				db 8, 9, 0Bh, 4Fh
				db 8, 4Fh, 50h,	4Ah
				db 52h,	4Ah, 51h, 4Bh
				db 0Bh,	49h, 19h, 48h
				db 50h,	4Ah, 50h, 1Dh
				db 51h,	4Bh, 4Ch, 4Eh
				db 4Ch,	4Dh, 4Ch, 4Eh
				db 53h,	4Bh, 4Ch, 4Dh
				db 25h,	20h, 1Eh, 4Dh
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 4Ch,	4Dh, 4Ch, 4Eh
				db 4Ch,	4Dh, 4Ch, 4Eh
				db 1Eh,	4Dh, 4Ch, 4Eh
				db 1Eh,	20h, 1Eh, 4Eh
				db 55h,	54h, 57h, 55h
				db 54h,	56h, 55h, 18h
				db 57h,	18h, 1Bh, 1Ch
				db 1Bh,	1Ch, 1Bh, 0
				db 54h,	55h, 56h, 57h
				db 56h,	57h, 54h, 55h
				db 55h,	56h, 57h, 54h
				db 54h,	55h, 54h, 18h
				db 28h,	28h, 26h, 29h
				db 27h,	29h, 27h, 56h
				db 29h,	56h, 57h, 57h
				db 57h,	56h, 55h, 54h
				db 17h,	18h, 19h, 1Ah
				db 5Ah,	1Ch, 1Bh, 1Dh
				db 65h,	64h, 58h, 1Fh
				db 65h,	5Eh, 5Fh, 5Ch
				db 61h,	66h, 62h, 5Ch
				db 61h,	66h, 68h, 63h
				db 61h,	66h, 68h, 63h
				db 61h,	66h, 68h, 63h
				db 61h,	66h, 68h, 9
				db 61h,	67h, 0Bh, 9
				db 11h,	0Fh, 0Bh, 9
				db 15h,	14h, 0Dh, 0Fh
				db 5Bh,	1, 58h,	20h
				db 3, 6, 5Fh, 5Dh
				db 61h,	60h, 0Ah, 5Eh
				db 61h,	9, 0Bh,	9
				db 1Eh,	20h, 22h, 23h
				db 59h,	21h, 17h, 15h
				db 5, 6, 2, 16h
				db 0Ah,	6, 5, 6
				db 1Bh,	0, 1Eh,	20h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 58h,	20h, 1Eh, 20h
				db 16h,	14h, 15h, 12h
				db 13h,	69h, 6Ah, 13h
				db 15h,	6Bh, 6Ch, 14h
				db 14h,	13h, 16h, 12h
				db 28h,	27h, 26h, 16h
				db 29h,	17h, 28h, 27h
				db 17h,	28h, 16h, 51h
				db 17h,	0A0h, 9Fh, 9Bh
				db 17h,	28h, 16h, 26h
				db 16h,	29h, 27h, 28h
				db 9Ah,	17h, 28h, 27h
				db 9Ch,	9Dh, 9Eh, 17h
				db 26h,	27h, 17h, 70h
				db 16h,	28h, 29h, 15h
				db 28h,	29h, 26h, 16h
				db 2, 17h, 26h,	70h
				db 97h,	99h, 0B0h, 0B1h
				db 88h,	8Fh, 8Ah, 0ACh
				db 8Dh,	96h, 98h, 6Eh
				db 8Bh,	0AFh, 8Ch, 83h
				db 0B2h, 0AEh, 94h, 95h
				db 0ADh, 85h, 92h, 93h
				db 6Fh,	91h, 0A9h, 8Eh
				db 84h,	0ABh, 0AAh, 85h
				db 6Dh,	16h, 28h, 27h
				db 17h,	28h, 27h, 26h
				db 16h,	27h, 17h, 28h
				db 6Dh,	15h, 29h, 18h
				db 90h,	8Fh, 8Ah, 0ACh
				db 81h,	17h, 0Dh, 75h
				db 77h,	6, 2, 7Bh
				db 78h,	6, 5, 71h
				db 0ADh, 85h, 92h, 89h
				db 76h,	21h, 26h, 82h
				db 7Ch,	18h, 1Bh, 7Eh
				db 72h,	1Ch, 1Bh, 7Fh
				db 79h,	9, 0Ah,	71h
				db 79h,	9, 0Bh,	73h
				db 79h,	9, 0Bh,	73h
				db 79h,	9, 0Bh,	73h
				db 72h,	0, 1Eh,	80h
				db 74h,	20h, 1Eh, 80h
				db 74h,	20h, 1Eh, 80h
				db 74h,	20h, 1Eh, 80h
				db 79h,	9, 0Bh,	73h
				db 79h,	9, 0Bh,	73h
				db 0Dh,	0Fh, 0Bh, 73h
				db 13h,	12h, 0Dh, 7Ah
				db 74h,	20h, 1Eh, 80h
				db 74h,	20h, 1Eh, 80h
				db 74h,	20h, 22h, 21h
				db 7Dh,	21h, 14h, 15h
				db 90h,	8Fh, 8Ah, 0ACh
				db 0A1h, 28h, 0Dh, 75h
				db 0A1h, 15h, 27h, 7Bh
				db 0A1h, 28h, 17h, 0A4h
				db 0A1h, 18h, 1Bh, 0A5h
				db 0A2h, 1Ch, 1Bh, 0A6h
				db 0A2h, 0, 1Eh, 0A8h
				db 0A3h, 20h, 1Eh, 0A8h
				db 0A3h, 20h, 1Eh, 0A8h
				db 0A3h, 20h, 1Eh, 0A8h
				db 1Eh,	20h, 1Eh, 0A8h
				db 1Eh,	20h, 1Eh, 0A7h
				db 0CBh, 0CBh, 0CAh, 0CBh
				db 0CBh, 0CBh, 0CBh, 18h
				db 0CBh, 18h, 1Bh, 1Ch
				db 0BCh, 0BAh, 1Bh, 0
				db 0CCh, 0CDh, 19h, 4
				db 1Bh,	1Ch, 1Bh, 1Dh
				db 1Bh,	0, 1Eh,	1Fh
				db 1Eh,	20h, 1Eh, 1Fh
				db 0BBh, 0B9h, 0B6h, 0B7h
				db 25h,	20h, 0B5h, 0B8h
				db 25h,	20h, 1Eh, 20h
				db 25h,	20h, 1Eh, 20h
				db 1Eh,	20h, 1Eh, 1Fh
				db 0B6h, 0B7h, 1Eh, 1Fh
				db 0B5h, 0B8h, 0B6h, 0B3h
				db 1Eh,	20h, 0B5h, 0B4h
				db 59h,	5Ah, 58h, 6Dh
				db 0C8h, 0C9h, 59h, 5Ah
				db 13h,	19h, 0CBh, 0C9h
				db 0Dh,	16h, 0CCh, 0CEh
				db 6Dh,	3Fh, 40h, 5Eh
				db 58h,	5Ch, 41h, 88h
				db 59h,	5Ah, 58h, 5
				db 0CBh, 0C9h, 59h, 5Ah
				db 14h,	19h, 0CCh, 0CCh
				db 15h,	16h, 0CDh, 0D5h
				db 0Fh,	6Dh, 0CCh, 0CEh
				db 0Dh,	6Dh, 0CCh, 0CCh
				db 0CCh, 0CEh, 0CBh, 0C9h
				db 0CCh, 0CCh, 0CCh, 0CEh
				db 0CCh, 0CCh, 0CCh, 0CCh
				db 0CCh, 0CCh, 0CCh, 0CAh
				db 9, 0Ah, 0D1h, 0CCh
				db 8, 0Bh, 0D2h, 0D3h
				db 6Dh,	0F4h, 0F7h, 0F8h
				db 0F7h, 0F8h, 0F7h, 0DCh
				db 0CCh, 0CAh, 0F5h, 0F6h
				db 0D4h, 0F8h, 0F7h, 0F9h
				db 0F7h, 0DCh, 0FAh, 0FBh
				db 0FAh, 0FCh, 0FAh, 0FBh
				db 59h,	5Ah, 58h, 0Eh
				db 6Dh,	5Bh, 59h, 69h
				db 6Dh,	6Dh, 6Dh, 6Bh
				db 0F5h, 0E0h, 6Dh, 10h
				db 0F7h, 0F9h, 6Dh, 0Eh
				db 0FAh, 0FBh, 6Dh, 0Ch
				db 0FAh, 0FBh, 6Dh, 12h
				db 0FAh, 0FBh, 6Dh, 10h
				db 0FAh, 0FBh, 6Dh, 0Eh
				db 0FAh, 0D7h, 6Dh, 0Ch
				db 0FAh, 0D0h, 4, 6
				db 0FEh, 0FFh, 5, 7
				db 0Fh,	53h, 52h, 51h
				db 6Ah,	51h, 54h, 6Dh
				db 6Ch,	6Dh, 6Dh, 6Dh
				db 11h,	6Dh, 0CFh, 0DDh
				db 0Fh,	6Dh, 0DFh, 0E2h
				db 0Dh,	6Dh, 0E4h, 0E8h
				db 13h,	6Dh, 0E4h, 0E8h
				db 11h,	6Dh, 0E4h, 0E8h
				db 0Fh,	6Dh, 0E4h, 0E8h
				db 0Dh,	6Dh, 0DAh, 0E8h
				db 9, 0Ah, 0DBh, 0E8h
				db 8, 0Bh, 0EDh, 0EAh
				db 0E3h, 0DDh, 0DEh, 0D6h
				db 0DFh, 0E2h, 0E1h, 0D8h
				db 0E4h, 0E5h, 0E6h, 0D8h
				db 0E4h, 0E5h, 0E6h, 0D9h
				db 0DAh, 0D9h, 0E7h, 0E5h
				db 0E4h, 0E5h, 0E7h, 0E5h
				db 0E4h, 0E5h, 0E7h, 0E5h
				db 0E4h, 0E5h, 0E7h, 0E5h
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  5Fh	; _
				db  33h	; 3
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  5Fh	; _
				db  33h	; 3
				db  34h	; 4
				db  2Eh	; .
				db  3Dh	; =
				db  45h	; E
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  55h	; U
				db  5Eh	; ^
				db  31h	; 1
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  33h	; 3
				db  34h	; 4
				db  2Bh	; +
				db  37h	; 7
				db  2Dh	; -
				db  3Fh	; ?
				db  28h	; (
				db  48h	; H
				db  42h	; B
				db  5Bh	; [
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  82h	; ‚
				db  3Eh	; >
				db  30h	; 0
				db  2Eh	; .
				db  57h	; W
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  33h	; 3
				db  34h	; 4
				db  2Eh	; .
				db  37h	; 7
				db  2Ah	; *
				db  2Fh	; /
				db  2Ch	; ,
				db  41h	; A
				db  26h	; &
				db  47h	; G
				db  43h	; C
				db  53h	; S
				db  42h	; B
				db  3Ch	; <
				db  57h	; W
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  75h	; u
				db  76h	; v
				db  81h	; 
				db  5Eh	; ^
				db  31h	; 1
				db  33h	; 3
				db  3Ch	; <
				db  5Eh	; ^
				db  31h	; 1
				db  33h	; 3
				db  34h	; 4
				db  2Bh	; +
				db  35h	; 5
				db  2Dh	; -
				db  36h	; 6
				db  29h	; )
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  49h	; I
				db  44h	; D
				db  54h	; T
				db  43h	; C
				db  3Dh	; =
				db  45h	; E
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  75h	; u
				db  76h	; v
				db  7Ch	; |
				db  7Fh	; 
				db  80h	; €
				db  3Eh	; >
				db  30h	; 0
				db  39h	; 9
				db  3Dh	; =
				db  3Eh	; >
				db  30h	; 0
				db  2Eh	; .
				db  35h	; 5
				db  2Ah	; *
				db  2Fh	; /
				db  38h	; 8
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  41h	; A
				db  44h	; D
				db  46h	; F
				db  27h	; '
				db  48h	; H
				db  42h	; B
				db  5Bh	; [
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  75h	; u
				db  76h	; v
				db  7Ah	; z
				db  79h	; y
				db  75h	; u
				db  76h	; v
				db  7Ch	; |
				db  7Fh	; 
				db  7Eh	; ~
				db  3Ah	; :
				db  5Dh	; ]
				db  40h	; @
				db  31h	; 1
				db  3Ah	; :
				db  3Fh	; ?
				db  40h	; @
				db  31h	; 1
				db  2Dh	; -
				db  2Fh	; /
				db  29h	; )
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  41h	; A
				db  26h	; &
				db  47h	; G
				db  43h	; C
				db  53h	; S
				db  42h	; B
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  6Ah	; j
				db  74h	; t
				db  77h	; w
				db  78h	; x
				db  7Bh	; {
				db  7Fh	; 
				db  7Eh	; ~
				db  3Ah	; :
				db  2Fh	; /
				db  2Ch	; ,
				db  49h	; I
				db  3Bh	; ;
				db  32h	; 2
				db  2Ch	; ,
				db  41h	; A
				db  3Bh	; ;
				db  32h	; 2
				db  38h	; 8
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  49h	; I
				db  44h	; D
				db  54h	; T
				db  43h	; C
				db  3Dh	; =
				db  52h	; R
				db  59h	; Y
				db  53h	; S
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  63h	; c
				db  64h	; d
				db  66h	; f
				db  6Fh	; o
				db  7Dh	; }
				db  3Ah	; :
				db  2Fh	; /
				db  38h	; 8
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db    6
				db    7
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  41h	; A
				db  44h	; D
				db  46h	; F
				db  51h	; Q
				db  5Dh	; ]
				db  58h	; X
				db  5Ah	; Z
				db  53h	; S
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  65h	; e
				db  62h	; b
				db  6Ch	; l
				db  6Dh	; m
				db  36h	; 6
				db  2Ch	; ,
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db    2
				db    3
				db    4
				db    8
				db  1Ah
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  41h	; A
				db  44h	; D
				db  5Ch	; \
				db  5Bh	; [
				db  57h	; W
				db  58h	; X
				db  5Ah	; Z
				db  53h	; S
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  63h	; c
				db  64h	; d
				db  6Bh	; k
				db  6Eh	; n
				db  71h	; q
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db    2
				db    3
				db    4
				db    5
				db    9
				db  1Ch
				db  1Bh
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  59h	; Y
				db  53h	; S
				db  45h	; E
				db  3Ch	; <
				db  57h	; W
				db  58h	; X
				db  5Ah	; Z
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  61h	; a
				db  62h	; b
				db  5Ah	; Z
				db  73h	; s
				db  72h	; r
				db  70h	; p
				db  71h	; q
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db    2
				db    3
				db  14h
				db    5
				db  0Ah
				db  17h
				db  1Eh
				db  1Dh
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db    6
				db    7
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  55h	; U
				db  58h	; X
				db  5Ah	; Z
				db  53h	; S
				db  45h	; E
				db  3Ch	; <
				db  57h	; W
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  49h	; I
				db  3Bh	; ;
				db  68h	; h
				db  60h	; `
				db  5Ah	; Z
				db  73h	; s
				db  72h	; r
				db  70h	; p
				db  71h	; q
				db  23h	; #
				db  24h	; $
				db  75h	; u
				db  76h	; v
				db  7Ah	; z
				db  79h	; y
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db    0
				db    1
				db    4
				db    5
				db  0Ah
				db  21h	; !
				db  22h	; "
				db  16h
				db  1Fh
				db  19h
				db  24h	; $
				db  24h	; $
				db    2
				db    3
				db    4
				db    8
				db  1Ah
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  4Bh	; K
				db  45h	; E
				db  3Ch	; <
				db  58h	; X
				db  5Ah	; Z
				db  53h	; S
				db  45h	; E
				db  45h	; E
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  24h	; $
				db  25h	; %
				db  41h	; A
				db  56h	; V
				db  68h	; h
				db  60h	; `
				db  5Ah	; Z
				db  73h	; s
				db  72h	; r
				db  70h	; p
				db  71h	; q
				db  6Ah	; j
				db  74h	; t
				db  84h	; „
				db  85h	; …
				db  7Ah	; z
				db  79h	; y
				db  23h	; #
				db  0Dh
				db  0Ch
				db  0Bh
				db  17h
				db  20h
				db  16h
				db  15h
				db  18h
				db  24h	; $
				db  23h	; #
				db    2
				db    3
				db    4
				db    5
				db    9
				db  1Ch
				db  1Bh
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  4Ah	; J
				db  50h	; P
				db  4Ch	; L
				db  52h	; R
				db  5Bh	; [
				db  58h	; X
				db  5Ah	; Z
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  49h	; I
				db  56h	; V
				db  68h	; h
				db  69h	; i
				db  5Ah	; Z
				db  73h	; s
				db  72h	; r
				db  63h	; c
				db  86h	; †
				db  88h	; ˆ
				db  74h	; t
				db  77h	; w
				db  78h	; x
				db  25h	; %
				db  0Eh
				db  0Fh
				db  12h
				db  16h
				db  15h
				db  18h
				db  24h	; $
				db  23h	; #
				db    2
				db    3
				db  14h
				db    5
				db  0Ah
				db  17h
				db  1Eh
				db  1Dh
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db    6
				db    7
				db  49h	; I
				db  44h	; D
				db  4Dh	; M
				db  51h	; Q
				db  4Ch	; L
				db  52h	; R
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  49h	; I
				db  67h	; g
				db  68h	; h
				db  69h	; i
				db  5Ah	; Z
				db  65h	; e
				db  87h	; ‡
				db  83h	; ƒ
				db  64h	; d
				db  66h	; f
				db  6Fh	; o
				db  24h	; $
				db  10h
				db  11h
				db  13h
				db  18h
				db  23h	; #
				db  25h	; %
				db    0
				db    1
				db    4
				db    5
				db  0Ah
				db  21h	; !
				db  22h	; "
				db  16h
				db  1Fh
				db  19h
				db  24h	; $
				db  23h	; #
				db    2
				db    3
				db    4
				db    8
				db  1Ah
				db  25h	; %
				db  41h	; A
				db  44h	; D
				db  4Eh	; N
				db  51h	; Q
				db  4Ch	; L
				db  45h	; E
				db  3Ch	; <
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  60h	; `
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  41h	; A
				db  67h	; g
				db  68h	; h
				db  59h	; Y
				db 0CCh	; Ì
				db 0CDh	; Í
				db  62h	; b
				db  8Ah	; Š
				db  6Dh	; m
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  0Dh
				db  0Ch
				db  0Bh
				db  17h
				db  20h
				db  16h
				db  15h
				db  18h
				db  25h	; %
				db  23h	; #
				db    2
				db    3
				db    4
				db    5
				db    9
				db  1Ch
				db  1Bh
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  49h	; I
				db  44h	; D
				db  4Eh	; N
				db  28h	; (
				db  4Ch	; L
				db  52h	; R
				db  5Bh	; [
				db  58h	; X
				db  60h	; `
				db  60h	; `
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  41h	; A
				db  89h	; ‰
				db 0CEh	; Î
				db 0CFh	; Ï
				db 0D2h	; Ò
				db 0D5h	; Õ
				db  6Fh	; o
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  0Eh
				db  0Fh
				db  12h
				db  16h
				db  15h
				db  18h
				db  25h	; %
				db  23h	; #
				db    2
				db    3
				db  14h
				db    5
				db  0Ah
				db  17h
				db  1Eh
				db  1Dh
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db 0B9h	; ¹
				db 0BAh	; º
				db  25h	; %
				db  49h	; I
				db  26h	; &
				db 0C8h	; È
				db 0C9h	; É
				db  4Ch	; L
				db  45h	; E
				db  3Ch	; <
				db  58h	; X
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db 0B9h	; ¹
				db 0BAh	; º
				db 0B1h	; ±
				db 0B1h	; ±
				db  49h	; I
				db 0D0h	; Ð
				db 0D1h	; Ñ
				db 0D3h	; Ó
				db 0D6h	; Ö
				db 0D8h	; Ø
				db  9Bh	; ›
				db  9Ch	; œ
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  10h
				db  11h
				db  13h
				db  18h
				db  24h	; $
				db  23h	; #
				db    0
				db    1
				db    4
				db    5
				db  0Ah
				db  21h	; !
				db  22h	; "
				db  16h
				db  1Fh
				db  19h
				db  23h	; #
				db  25h	; %
				db 0BBh	; »
				db 0BCh	; ¼
				db 0BDh	; ½
				db 0BEh	; ¾
				db  9Dh	; 
				db  97h	; —
				db 0CAh	; Ê
				db 0CBh	; Ë
				db  4Dh	; M
				db  28h	; (
				db  4Ch	; L
				db  45h	; E
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db 0BBh	; »
				db 0BCh	; ¼
				db 0BDh	; ½
				db 0BEh	; ¾
				db 0AFh	; ¯
				db 0B2h	; ²
				db 0B7h	; ·
				db  93h	; “
				db 0D4h	; Ô
				db 0D7h	; ×
				db 0D9h	; Ù
				db  8Eh	; Ž
				db  90h	; 
				db  9Bh	; ›
				db  9Ch	; œ
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  0Dh
				db  0Ch
				db  0Bh
				db  17h
				db  20h
				db  16h
				db  15h
				db  18h
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db 0C5h	; Å
				db 0C0h	; À
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  41h	; A
				db  26h	; &
				db 0C8h	; È
				db 0C9h	; É
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db 0B1h	; ±
				db 0B1h	; ±
				db 0C5h	; Å
				db 0C0h	; À
				db  97h	; —
				db  96h	; –
				db 0B3h	; ³
				db 0B5h	; µ
				db 0B6h	; ¶
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  9Bh	; ›
				db  9Ch	; œ
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  23h	; #
				db  0Eh
				db  0Fh
				db  12h
				db  16h
				db  15h
				db  18h
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  9Ch	; œ
				db  9Dh	; 
				db 0C6h	; Æ
				db 0C2h	; Â
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  91h	; ‘
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db 0CAh	; Ê
				db 0CBh	; Ë
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db 0B1h	; ±
				db 0B1h	; ±
				db 0B0h	; °
				db 0AFh	; ¯
				db 0C6h	; Æ
				db 0C2h	; Â
				db  93h	; “
				db  95h	; •
				db 0B4h	; ´
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db 0A8h	; ¨
				db 0AAh	; ª
				db  9Ch	; œ
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  10h
				db  11h
				db  13h
				db  18h
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  9Ch	; œ
				db  9Dh	; 
				db  97h	; —
				db  96h	; –
				db 0C7h	; Ç
				db 0C4h	; Ä
				db  94h	; ”
				db  92h	; ’
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  23h	; #
				db  25h	; %
				db 0B1h	; ±
				db 0B0h	; °
				db 0AFh	; ¯
				db  97h	; —
				db  96h	; –
				db 0C7h	; Ç
				db 0C4h	; Ä
				db  94h	; ”
				db  91h	; ‘
				db 0B8h	; ¸
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db 0A7h	; §
				db 0A6h	; ¦
				db  90h	; 
				db  9Bh	; ›
				db  9Ch	; œ
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  9Ch	; œ
				db  9Dh	; 
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  91h	; ‘
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  24h	; $
				db 0B0h	; °
				db 0B2h	; ²
				db 0B7h	; ·
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db 0A8h	; ¨
				db 0A9h	; ©
				db  91h	; ‘
				db  92h	; ’
				db 0A5h	; ¥
				db 0A4h	; ¤
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  9Bh	; ›
				db  9Ch	; œ
				db  25h	; %
				db  23h	; #
				db 0B9h	; ¹
				db 0BAh	; º
				db  25h	; %
				db  23h	; #
				db  9Ch	; œ
				db  9Dh	; 
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db 0B8h	; ¸
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db 0B0h	; °
				db 0B3h	; ³
				db 0B5h	; µ
				db 0B6h	; ¶
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db 0A7h	; §
				db 0A6h	; ¦
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  9Bh	; ›
				db 0BBh	; »
				db 0BCh	; ¼
				db 0BDh	; ½
				db 0BEh	; ¾
				db  9Dh	; 
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  91h	; ‘
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db 0B1h	; ±
				db 0B4h	; ´
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db 0A5h	; ¥
				db 0A4h	; ¤
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db 0BFh	; ¿
				db 0C0h	; À
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  92h	; ’
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db 0ABh	; «
				db 0ACh	; ¬
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db 0C1h	; Á
				db 0C2h	; Â
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  91h	; ‘
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  91h	; ‘
				db  92h	; ’
				db 0B9h	; ¹
				db 0BAh	; º
				db  91h	; ‘
				db  92h	; ’
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db 0ADh	; ­
				db 0AEh	; ®
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  8Ch	; Œ
				db 0C3h	; Ã
				db 0C4h	; Ä
				db  94h	; ”
				db  92h	; ’
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db 0BBh	; »
				db 0BCh	; ¼
				db 0BDh	; ½
				db 0BEh	; ¾
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db  8Fh	; 
				db  91h	; ‘
				db  92h	; ’
				db  91h	; ‘
				db  99h	; ™
				db  98h	; ˜
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db 0BFh	; ¿
				db 0C0h	; À
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db  8Eh	; Ž
				db  90h	; 
				db 0A2h	; ¢
				db 0A3h	; £
				db  97h	; —
				db  96h	; –
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db 0C1h	; Á
				db 0C2h	; Â
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  8Ch	; Œ
				db  8Dh	; 
				db  8Bh	; ‹
				db 0A0h	;  
				db 0A1h	; ¡
				db  93h	; “
				db  95h	; •
				db  94h	; ”
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  8Ch	; Œ
				db 0C3h	; Ã
				db 0C4h	; Ä
				db  94h	; ”
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  8Ch	; Œ
				db  9Fh	; Ÿ
				db  9Eh	; ž
				db  94h	; ”
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  23h	; #
				db  24h	; $
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  24h	; $
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  24h	; $
				db  25h	; %
				db  25h	; %
				db  23h	; #
				db  25h	; %
				db  23h	; #
				db  88h	; ˆ
				db  88h	; ˆ
				db  88h	; ˆ
				db  88h	; ˆ
				db  88h	; ˆ
				db  88h	; ˆ
				db 0EBh	; ë
				db  0Ah
				db  30h	; 0
				db    0
				db    0
				db  12h
				db    0
				db 0EAh	; ê
				db    0
				db    0
				db    0
				db    0
				db 0E8h	; è
				db 0CFh	; Ï
				db    4
				db  33h	; 3
				db 0EDh	; í
				db 0B9h	; ¹
				db    4
				db    0
				db  8Bh	; ‹
				db 0D4h	; Ô
				db  83h	; ƒ
				db 0C2h	; Â
				db  0Fh
				db 0D3h	; Ó
				db 0EAh	; ê
				db  8Ch	; Œ
				db 0D0h	; Ð
				db    3
				db 0C2h	; Â
				db  2Eh	; .
				db  8Bh	; ‹
				db  36h	; 6
				db    4
				db    0
				db 0D3h	; Ó
				db 0EEh	; î
				db 0BAh	; º
				db 0FFh
				db  0Fh
				db 0BBh	; »
				db    4
				db    0
				db  8Bh	; ‹
				db 0C8h	; È
				db  23h	; #
				db 0CAh	; Ê
				db    3
				db 0CEh	; Î
				db  3Bh	; ;
				db 0CAh	; Ê
				db  76h	; v
				db  2Ah	; *
				db    3
				db 0C6h	; Æ
				db  25h	; %
				db    0
				db 0FFh
				db  4Bh	; K
				db  77h	; w
				db 0EEh	; î
				db  1Eh
				db  0Eh
				db  1Fh
				db 0BAh	; º
				db  4Ch	; L
				db    0
				db 0B4h	; ´
				db    9
				db 0CDh	; Í
				db  21h	; !
				db  1Fh
				db 0E9h	; é
				db  88h	; ˆ
				db    0
				db  66h	; f
				db  61h	; a
				db  69h	; i
				db  6Ch	; l
				db  20h
				db  69h	; i
				db  6Eh	; n
				db  20h
				db  36h	; 6
				db  34h	; 4
				db  6Bh	; k
				db  20h
				db  66h	; f
				db  69h	; i
				db  78h	; x
				db  75h	; u
				db  70h	; p
				db  0Dh
				db  0Ah
				db  24h	; $
				db  8Bh	; ‹
				db 0D0h	; Ð
				db 0CDh	; Í
				db  12h
				db 0B1h	; ±
				db    6
				db 0D3h	; Ó
				db 0E0h	; à
				db  3Bh	; ;
				db 0C2h	; Â
				db  73h	; s
				db  1Dh
				db  1Eh
				db  0Eh
				db  1Fh
				db 0BAh	; º
				db  7Ah	; z
				db    0
				db 0B4h	; ´
				db    9
				db 0CDh	; Í
				db  21h	; !
				db  1Fh
				db 0EBh	; ë
				db  5Bh	; [
				db  90h	; 
				db  49h	; I
				db  6Eh	; n
				db  73h	; s
				db  75h	; u
				db  66h	; f
				db  20h
				db  6Dh	; m
				db  65h	; e
				db  6Dh	; m
				db  6Fh	; o
				db  72h	; r
				db  79h	; y
				db  0Dh
				db  0Ah
				db  24h	; $
				db 0EBh	; ë
				db    1
				db  65h	; e
				db 0E8h	; è
				db  66h	; f
				db    3
				db  47h	; G
				db 0EEh	; î
				db  18h
				db  47h	; G
				db  51h	; Q
				db  20h
				db  4Ch	; L
				db 0B2h	; ²
				db    0
				db  47h	; G
				db  4Ah	; J
				db    0
				db  93h	; “
				db 0B9h	; ¹
				db  71h	; q
				db    4
				db 0F1h	; ñ
				db 0A2h	; ¢
				db    8
				db 0EFh	; ï
				db  84h	; „
				db 0A3h	; £
				db  70h	; p
				db 0CDh	; Í
				db  50h	; P
				db    0
				db  51h	; Q
				db 0E8h	; è
				db 0C6h	; Æ
				db    0
				db  59h	; Y
				db  72h	; r
				db    2
				db 0E2h	; â
				db 0F7h	; ÷
				db  73h	; s
				db  20h
				db 0EBh	; ë
				db    1
				db  90h	; 
				db 0E8h	; è
				db  3Bh	; ;
				db    3
				db  47h	; G
				db  7Fh	; 
				db  10h
				db  93h	; “
				db 0A8h	; ¨
				db  47h	; G
				db  6Dh	; m
				db  18h
				db  47h	; G
				db 0FFh
				db  10h
				db 0D7h	; ×
				db  47h	; G
				db 0B7h	; ·
				db  18h
				db  74h	; t
				db  86h	; †
				db  5Ch	; \
				db  0Fh
				db  47h	; G
				db 0DAh	; Ú
				db  18h
				db 0DFh	; ß
				db  4Fh	; O
				db  99h	; ™
				db 0FFh
				db  8Ch	; Œ
				db 0D8h	; Ø
				db 0BEh	; ¾
				db    7
				db    0
				db  2Eh	; .
				db  88h	; ˆ
				db  44h	; D
				db    3
				db  2Eh	; .
				db  88h	; ˆ
				db  64h	; d
				db    4
				db 0E9h	; é
				db  23h	; #
				db 0FFh
				db    6
				db  1Eh
				db 0B8h	; ¸
				db  40h	; @
				db    0
				db  8Eh	; Ž
				db 0D8h	; Ø
				db 0BFh	; ¿
				db  3Eh	; >
				db    0
				db  8Ah	; Š
				db  95h	; •
				db    4
				db    0
				db  80h	; €
				db 0E2h	; â
				db    3
				db 0E8h	; è
				db  77h	; w
				db    3
				db 0EBh	; ë
				db    1
				db 0D4h	; Ô
				db 0E8h	; è
				db 0F7h	; ÷
				db    2
				db  74h	; t
				db  32h	; 2
				db    0
				db  99h	; ™
				db 0DEh	; Þ
				db 0B5h	; µ
				db    0
				db 0ADh	; ­
				db  30h	; 0
				db  8Dh	; 
				db    8
				db 0C5h	; Å
				db    8
				db  10h
				db  6Eh	; n
				db  98h	; ˜
				db  93h	; “
				db  90h	; 
				db    4
				db 0D7h	; ×
				db    0
				db 0A3h	; £
				db  50h	; P
				db  95h	; •
				db    0
				db 0EBh	; ë
				db 0E5h	; å
				db  1Fh
				db    7
				db 0E8h	; è
				db  0Dh
				db    3
				db 0C3h	; Ã
				db 0F9h	; ù
				db 0EBh	; ë
				db 0F7h	; ÷
				db 0F6h	; ö
				db 0C4h	; Ä
				db    4
				db  75h	; u
				db    2
				db 0EBh	; ë
				db 0F6h	; ö
				db 0E8h	; è
				db  93h	; “
				db    3
				db 0C6h	; Æ
				db  45h	; E
				db    2
				db 0FFh
				db 0B8h	; ¸
				db    0
				db    0
				db  8Eh	; Ž
				db 0C0h	; À
				db 0BEh	; ¾
				db  78h	; x
				db    0
				db  26h	; &
				db 0C4h	; Ä
				db  34h	; 4
				db 0EBh	; ë
				db    1
				db  17h
				db 0E8h	; è
				db 0B4h	; ´
				db    2
				db  47h	; G
				db  88h	; ˆ
				db    0
				db  93h	; “
				db  40h	; @
				db  47h	; G
				db  78h	; x
				db    8
				db  47h	; G
				db  45h	; E
				db    0
				db  5Fh	; _
				db  5Eh	; ^
				db  47h	; G
				db  5Dh	; ]
				db    8
				db 0C7h	; Ç
				db  5Fh	; _
				db  2Eh	; .
				db 0FFh
				db 0F0h	; ð
				db 0BAh	; º
				db  82h	; ‚
				db 0C5h	; Å
				db    0
				db 0F0h	; ð
				db  8Eh	; Ž
				db 0D8h	; Ø
				db 0BFh	; ¿
				db 0FEh	; þ
				db 0FFh
				db  8Ah	; Š
				db    5
				db  2Eh	; .
				db 0A2h	; ¢
				db  54h	; T
				db    1
				db  3Ch	; <
				db 0FDh	; ý
				db  74h	; t
				db    4
				db 0F8h	; ø
				db 0EBh	; ë
				db    2
				db  90h	; 
				db 0F9h	; ù
				db  58h	; X
				db  5Fh	; _
				db  1Fh
				db 0C3h	; Ã
				db    6
				db  1Eh
				db 0B8h	; ¸
				db  40h	; @
				db    0
				db  8Eh	; Ž
				db 0D8h	; Ø
				db 0BFh	; ¿
				db  3Eh	; >
				db    0
				db  8Ah	; Š
				db  95h	; •
				db    4
				db    0
				db  80h	; €
				db 0E2h	; â
				db    3
				db  32h	; 2
				db 0F6h	; ö
				db 0B6h	; ¶
				db    0
				db 0B5h	; µ
				db    6
				db  2Eh	; .
				db  8Ah	; Š
				db  0Eh
				db 0C8h	; È
				db    1
				db 0B8h	; ¸
				db    1
				db    4
				db 0CDh	; Í
				db  13h
				db 0C6h	; Æ
				db  45h	; E
				db    2
				db 0FFh
				db 0B8h	; ¸
				db    0
				db    0
				db  8Eh	; Ž
				db 0C0h	; À
				db 0BEh	; ¾
				db  78h	; x
				db    0
				db  26h	; &
				db 0C4h	; Ä
				db  34h	; 4
				db 0E8h	; è
				db  23h	; #
				db    0
				db  8Bh	; ‹
				db  45h	; E
				db    9
				db 0B5h	; µ
				db    1
				db 0B1h	; ±
				db    1
				db  2Eh	; .
				db 0A2h	; ¢
				db 0C8h	; È
				db    1
				db  3Bh	; ;
				db 0C1h	; Á
				db  75h	; u
				db  0Fh
				db  8Bh	; ‹
				db  45h	; E
				db    7
				db 0B5h	; µ
				db    0
				db 0B1h	; ±
				db    6
				db  3Bh	; ;
				db 0C1h	; Á
				db  75h	; u
				db    4
				db 0F9h	; ù
				db 0EBh	; ë
				db    2
				db  90h	; 
				db 0F8h	; ø
				db  1Fh
				db    7
				db 0C3h	; Ã
				db    8
				db  52h	; R
				db 0B4h	; ´
				db  4Ah	; J
				db 0E8h	; è
				db  0Dh
				db    1
				db  5Ah	; Z
				db 0B4h	; ´
				db    0
				db 0B1h	; ±
				db    2
				db 0D2h	; Ò
				db 0E4h	; ä
				db  0Ah
				db 0E2h	; â
				db 0E8h	; è
				db    1
				db    1
				db 0E8h	; è
				db 0B6h	; ¶
				db    0
				db 0E8h	; è
				db 0CAh	; Ê
				db    0
				db  72h	; r
				db    9
				db  8Ah	; Š
				db  85h	; …
				db    4
				db    0
				db  24h	; $
				db 0C0h	; À
				db  74h	; t
				db    1
				db 0F9h	; ù
				db  26h	; &
				db  8Ah	; Š
				db  64h	; d
				db    2
				db  88h	; ˆ
				db  65h	; e
				db    2
				db 0C3h	; Ã
				db 0EBh	; ë
				db    1
				db 0D0h	; Ð
				db 0E8h	; è
				db 0FBh	; û
				db    1
				db  92h	; ’
				db 0A5h	; ¥
				db  12h
				db  47h	; G
				db 0E6h	; æ
				db    0
				db 0D2h	; Ò
				db  54h	; T
				db  17h
				db    4
				db  66h	; f
				db    0
				db  47h	; G
				db  9Eh	; ž
				db    0
				db 0A5h	; ¥
				db  30h	; 0
				db  47h	; G
				db  76h	; v
				db    0
				db 0A5h	; ¥
				db    0
				db  47h	; G
				db  4Eh	; N
				db    0
				db 0B4h	; ´
				db    1
				db 0E8h	; è
				db 0C4h	; Ä
				db    0
				db  26h	; &
				db  8Ah	; Š
				db  64h	; d
				db    3
				db 0E8h	; è
				db 0BDh	; ½
				db    0
				db 0EBh	; ë
				db    1
				db 0FBh	; û
				db 0E8h	; è
				db 0D0h	; Ð
				db    1
				db  47h	; G
				db  18h
				db  10h
				db  31h	; 1
				db  54h	; T
				db  23h	; #
				db  20h
				db  47h	; G
				db  6Dh	; m
				db    0
				db  31h	; 1
				db  54h	; T
				db  23h	; #
				db  28h	; (
				db  47h	; G
				db  35h	; 5
				db    0
				db  31h	; 1
				db  54h	; T
				db  23h	; #
				db  30h	; 0
				db  47h	; G
				db 0FCh	; ü
				db    0
				db  47h	; G
				db  54h	; T
				db    0
				db 0E8h	; è
				db  68h	; h
				db    0
				db  72h	; r
				db    8
				db  8Ah	; Š
				db  45h	; E
				db    4
				db  24h	; $
				db 0C0h	; À
				db  74h	; t
				db    1
				db 0F9h	; ù
				db  26h	; &
				db  8Ah	; Š
				db  64h	; d
				db    2
				db  88h	; ˆ
				db  65h	; e
				db    2
				db 0E8h	; è
				db 0D4h	; Ô
				db    1
				db 0C3h	; Ã
				db 0EBh	; ë
				db    1
				db  34h	; 4
				db 0E8h	; è
				db  97h	; —
				db    1
				db  85h	; …
				db  32h	; 2
				db  37h	; 7
				db  60h	; `
				db  37h	; 7
				db  58h	; X
				db  5Ch	; \
				db  32h	; 2
				db    0
				db  8Dh	; 
				db  20h
				db  9Eh	; ž
				db    6
				db  54h	; T
				db  47h	; G
				db  21h	; !
				db  87h	; ‡
				db  37h	; 7
				db  20h
				db  54h	; T
				db  26h	; &
				db  37h	; 7
				db  20h
				db  54h	; T
				db  2Eh	; .
				db  24h	; $
				db  0Fh
				db 0E6h	; æ
				db  81h	; 
				db  2Eh	; .
				db 0A1h	; ¡
				db    4
				db    0
				db 0EBh	; ë
				db    1
				db  5Bh	; [
				db 0E8h	; è
				db  70h	; p
				db    1
				db  47h	; G
				db  1Dh
				db    8
				db  42h	; B
				db  37h	; 7
				db  28h	; (
				db  54h	; T
				db  26h	; &
				db  37h	; 7
				db  28h	; (
				db  85h	; …
				db  10h
				db  37h	; 7
				db  50h	; P
				db  1Eh
				db 0DFh	; ß
				db  9Dh	; 
				db  10h
				db  99h	; ™
				db  4Eh	; N
				db 0B7h	; ·
				db  28h	; (
				db    4
				db 0ABh	; «
				db  38h	; 8
				db 0E2h	; â
				db 0F9h	; ù
				db 0FEh	; þ
				db 0CBh	; Ë
				db  75h	; u
				db 0F5h	; õ
				db 0F9h	; ù
				db  9Ch	; œ
				db  80h	; €
				db  25h	; %
				db  7Fh	; 
				db  9Dh	; 
				db 0C3h	; Ã
				db 0FCh	; ü
				db  57h	; W
				db  83h	; ƒ
				db 0C7h	; Ç
				db    4
				db 0B3h	; ³
				db    7
				db  33h	; 3
				db 0C9h	; É
				db 0BAh	; º
				db 0F4h	; ô
				db    3
				db 0ECh	; ì
				db 0A8h	; ¨
				db  80h	; €
				db  75h	; u
				db    5
				db 0E2h	; â
				db 0F9h	; ù
				db 0F9h	; ù
				db  5Fh	; _
				db 0C3h	; Ã
				db 0ECh	; ì
				db 0A8h	; ¨
				db  40h	; @
				db  74h	; t
				db 0F8h	; ø
				db  42h	; B
				db 0ECh	; ì
				db  88h	; ˆ
				db    5
				db  47h	; G
				db 0B9h	; ¹
				db  0Ah
				db    0
				db 0E2h	; â
				db 0FEh	; þ
				db  4Ah	; J
				db 0ECh	; ì
				db 0A8h	; ¨
				db  10h
				db  74h	; t
				db 0E9h	; é
				db 0FEh	; þ
				db 0CBh	; Ë
				db  74h	; t
				db 0E4h	; ä
				db 0EBh	; ë
				db 0EAh	; ê
				db 0BAh	; º
				db 0F4h	; ô
				db    3
				db  33h	; 3
				db 0C9h	; É
				db 0ECh	; ì
				db 0A8h	; ¨
				db  40h	; @
				db  74h	; t
				db    4
				db 0E2h	; â
				db 0F9h	; ù
				db 0F9h	; ù
				db 0C3h	; Ã
				db  33h	; 3
				db 0C9h	; É
				db 0ECh	; ì
				db 0A8h	; ¨
				db  80h	; €
				db  75h	; u
				db    4
				db 0E2h	; â
				db 0F9h	; ù
				db 0EBh	; ë
				db 0F3h	; ó
				db  8Ah	; Š
				db 0C4h	; Ä
				db  42h	; B
				db 0EEh	; î
				db 0F8h	; ø
				db 0EBh	; ë
				db 0EDh	; í
				db 0EBh	; ë
				db  0Ch
				db  8Bh	; ‹
				db  13h
				db    0
				db 0F0h	; ð
				db 0B4h	; ´
				db 0E9h	; é
				db    0
				db 0F0h	; ð
				db  44h	; D
				db 0EDh	; í
				db    0
				db 0F0h	; ð
				db 0EBh	; ë
				db    1
				db 0E6h	; æ
				db 0E8h	; è
				db 0E5h	; å
				db    0
				db 0A5h	; ¥
				db  10h
				db 0B5h	; µ
				db    0
				db 0ADh	; ­
				db  30h	; 0
				db  8Dh	; 
				db    8
				db  31h	; 1
				db  54h	; T
				db  22h	; "
				db  20h
				db  30h	; 0
				db  74h	; t
				db  32h	; 2
				db    0
				db  9Ah	; š
				db  99h	; ™
				db 0DEh	; Þ
				db 0DFh	; ß
				db  30h	; 0
				db  82h	; ‚
				db  82h	; ‚
				db  82h	; ‚
				db  9Ah	; š
				db  51h	; Q
				db  1Eh
				db  56h	; V
				db  57h	; W
				db  55h	; U
				db  52h	; R
				db  8Bh	; ‹
				db 0ECh	; ì
				db 0E8h	; è
				db 0F7h	; ÷
				db    0
				db  57h	; W
				db 0BFh	; ¿
				db  46h	; F
				db    3
				db  0Eh
				db  57h	; W
				db 0BFh	; ¿
				db  8Dh	; 
				db 0ECh	; ì
				db  57h	; W
				db  8Bh	; ‹
				db  7Eh	; ~
				db    4
				db  2Eh	; .
				db 0FFh
				db  2Eh	; .
				db 0FEh	; þ
				db    2
				db 0E8h	; è
				db  40h	; @
				db    0
				db  57h	; W
				db 0EBh	; ë
				db    1
				db  26h	; &
				db 0E8h	; è
				db 0A5h	; ¥
				db    0
				db 0FDh	; ý
				db  1Bh
				db  18h
				db  70h	; p
				db 0BAh	; º
				db 0FDh	; ý
				db  6Ch	; l
				db  67h	; g
				db 0BAh	; º
				db  9Dh	; 
				db  20h
				db  5Ch	; \
				db 0F3h	; ó
				db  20h
				db  71h	; q
				db 0FFh
				db  71h	; q
				db  10h
				db  18h
				db 0FDh	; ý
				db    2
				db    0
				db  44h	; D
				db  29h	; )
				db 0FDh	; ý
				db  41h	; A
				db    0
				db  8Ah	; Š
				db  25h	; %
				db  88h	; ˆ
				db  66h	; f
				db  0Fh
				db  5Ah	; Z
				db  5Dh	; ]
				db  5Fh	; _
				db  5Eh	; ^
				db  1Fh
				db  59h	; Y
				db 0E8h	; è
				db 0B2h	; ²
				db    0
				db  5Bh	; [
				db  58h	; X
				db  83h	; ƒ
				db 0C4h	; Ä
				db    4
				db    7
				db  80h	; €
				db 0FCh	; ü
				db    1
				db 0F5h	; õ
				db  5Bh	; [
				db    7
				db 0E8h	; è
				db 0A3h	; £
				db    0
				db 0C3h	; Ã
				db  8Ah	; Š
				db 0F0h	; ð
				db  57h	; W
				db 0BFh	; ¿
				db  3Fh	; ?
				db    0
				db  80h	; €
				db  25h	; %
				db  7Fh	; 
				db  5Fh	; _
				db 0EBh	; ë
				db    2
				db  90h	; 
				db 0C3h	; Ã
				db  57h	; W
				db 0BFh	; ¿
				db 0ABh	; «
				db    3
				db  0Eh
				db  57h	; W
				db 0BFh	; ¿
				db  8Dh	; 
				db 0ECh	; ì
				db  57h	; W
				db  8Bh	; ‹
				db  7Eh	; ~
				db    4
				db 0B4h	; ´
				db  42h	; B
				db  2Eh	; .
				db 0FFh
				db  2Eh	; .
				db    6
				db    3
				db 0C3h	; Ã
				db 0EBh	; ë
				db    1
				db  88h	; ˆ
				db 0E8h	; è
				db  43h	; C
				db    0
				db 0F0h	; ð
				db  74h	; t
				db 0F2h	; ò
				db    0
				db 0F5h	; õ
				db 0FFh
				db    8
				db    4
				db 0E1h	; á
				db 0BFh	; ¿
				db 0A3h	; £
				db    8
				db 0CFh	; Ï
				db 0F8h	; ø
				db  47h	; G
				db  43h	; C
				db    0
				db  1Eh
				db 0F0h	; ð
				db  64h	; d
				db 0DEh	; Þ
				db  74h	; t
				db 0F2h	; ò
				db    0
				db  1Ch
				db 0C3h	; Ã
				db  10h
				db  8Ch	; Œ
				db 0C8h	; È
				db  8Eh	; Ž
				db 0C0h	; À
				db  2Eh	; .
				db  8Bh	; ‹
				db  36h	; 6
				db    2
				db    0
				db  81h	; 
				db 0C6h	; Æ
				db    0
				db    1
				db 0E8h	; è
				db  4Eh	; N
				db    0
				db 0BFh	; ¿
				db    8
				db    0
				db 0ADh	; ­
				db 0ABh	; «
				db 0ADh	; ­
				db    3
				db 0C3h	; Ã
				db 0ABh	; «
				db 0ADh	; ­
				db  8Bh	; ‹
				db 0C8h	; È
				db 0ADh	; ­
				db    3
				db 0C3h	; Ã
				db 0E8h	; è
				db  3Ch	; <
				db    0
				db  5Bh	; [
				db  8Eh	; Ž
				db 0DBh	; Û
				db  8Eh	; Ž
				db 0C3h	; Ã
				db 0C3h	; Ã
				db  56h	; V
				db  57h	; W
				db  55h	; U
				db  8Bh	; ‹
				db 0ECh	; ì
				db  8Bh	; ‹
				db  76h	; v
				db    6
				db  9Ch	; œ
				db  51h	; Q
				db  50h	; P
				db  53h	; S
				db 0EBh	; ë
				db    3
				db  90h	; 
				db  19h
				db    5
				db 0E8h	; è
				db  1Fh
				db    0
				db  32h	; 2
				db 0FFh
				db  2Eh	; .
				db  8Ah	; Š
				db  5Dh	; ]
				db 0FBh	; û
				db  2Eh	; .
				db  8Ah	; Š
				db  4Dh	; M
				db 0FCh	; ü
				db  2Eh	; .
				db  8Ah	; Š
				db  24h	; $
				db 0D2h	; Ò
				db 0C4h	; Ä
				db  2Eh	; .
				db  88h	; ˆ
				db  24h	; $
				db  46h	; F
				db 0FEh	; þ
				db 0CBh	; Ë
				db  75h	; u
				db 0F3h	; ó
				db  5Bh	; [
				db  58h	; X
				db  59h	; Y
				db  9Dh	; 
				db  5Dh	; ]
				db  5Fh	; _
				db  5Eh	; ^
				db 0C3h	; Ã
				db  5Fh	; _
				db  57h	; W
				db 0C3h	; Ã
				db  56h	; V
				db  57h	; W
				db  55h	; U
				db  8Bh	; ‹
				db 0ECh	; ì
				db  8Bh	; ‹
				db  76h	; v
				db    6
				db  9Ch	; œ
				db  51h	; Q
				db  52h	; R
				db  50h	; P
				db  53h	; S
				db 0B8h	; ¸
				db    0
				db    0
				db 0CDh	; Í
				db  1Ah
				db  81h	; 
				db 0E1h	; á
				db    7
				db    0
				db  75h	; u
				db    3
				db 0B9h	; ¹
				db    5
				db    0
				db  8Bh	; ‹
				db 0DAh	; Ú
				db  81h	; 
				db 0E3h	; ã
				db  0Fh
				db    0
				db  83h	; ƒ
				db 0C3h	; Ã
				db  19h
				db  3Bh	; ;
				db 0F3h	; ó
				db  75h	; u
				db    2
				db  8Bh	; ‹
				db 0DEh	; Þ
				db  2Bh	; +
				db 0F3h	; ó
				db 0FEh	; þ
				db 0CBh	; Ë
				db  2Eh	; .
				db  8Ah	; Š
				db  24h	; $
				db 0D2h	; Ò
				db 0CCh	; Ì
				db  2Eh	; .
				db  88h	; ˆ
				db  24h	; $
				db  46h	; F
				db 0FEh	; þ
				db 0CBh	; Ë
				db  75h	; u
				db 0F3h	; ó
				db  5Bh	; [
				db  58h	; X
				db  5Ah	; Z
				db  59h	; Y
				db  9Dh	; 
				db  5Dh	; ]
				db  5Fh	; _
				db  5Eh	; ^
				db 0C3h	; Ã
				db  9Ch	; œ
				db  51h	; Q
				db  52h	; R
				db  50h	; P
				db 0E8h	; è
				db  76h	; v
				db    0
				db  52h	; R
				db  51h	; Q
				db  3Ch	; <
				db    0
				db  74h	; t
				db  0Ch
				db  81h	; 
				db 0C2h	; Â
				db 0B0h	; °
				db    0
				db  73h	; s
				db    1
				db  41h	; A
				db  83h	; ƒ
				db 0C1h	; Á
				db  18h
				db  72h	; r
				db  2Ah	; *
				db  2Eh	; .
				db  2Bh	; +
				db  16h
				db 0F5h	; õ
				db    4
				db  73h	; s
				db    1
				db  49h	; I
				db  2Eh	; .
				db  2Bh	; +
				db  0Eh
				db 0F3h	; ó
				db    4
				db  72h	; r
				db  1Bh
				db  2Eh	; .
				db  89h	; ‰
				db  0Eh
				db 0BBh	; »
				db    4
				db  2Eh	; .
				db  89h	; ‰
				db  16h
				db 0BDh	; ½
				db    4
				db  59h	; Y
				db  5Ah	; Z
				db  2Eh	; .
				db  89h	; ‰
				db  0Eh
				db 0F3h	; ó
				db    4
				db  2Eh	; .
				db  89h	; ‰
				db  16h
				db 0F5h	; õ
				db    4
				db  58h	; X
				db  5Ah	; Z
				db  59h	; Y
				db  9Dh	; 
				db 0C3h	; Ã
				db 0E8h	; è
				db  76h	; v
				db 0FFh
				db 0E8h	; è
				db  3Dh	; =
				db 0FFh
				db 0E9h	; é
				db  19h
				db 0FCh	; ü
				db    2
				db    0
				db  40h	; @
				db    0
				db  9Ch	; œ
				db  51h	; Q
				db  52h	; R
				db  2Eh	; .
				db  8Bh	; ‹
				db  0Eh
				db 0BBh	; »
				db    4
				db  83h	; ƒ
				db 0F9h	; ù
				db    0
				db  75h	; u
				db 0E6h	; æ
				db  2Eh	; .
				db  8Bh	; ‹
				db  0Eh
				db 0BDh	; ½
				db    4
				db  2Eh	; .
				db  3Bh	; ;
				db  0Eh
				db 0DCh	; Ü
				db    4
				db  73h	; s
				db 0DAh	; Ú
				db  5Ah	; Z
				db  59h	; Y
				db  9Dh	; 
				db 0C3h	; Ã
				db  20h
				db    0
				db 0E8h	; è
				db  0Bh
				db    0
				db  2Eh	; .
				db  89h	; ‰
				db  0Eh
				db 0F3h	; ó
				db    4
				db  2Eh	; .
				db  89h	; ‰
				db  16h
				db 0F5h	; õ
				db    4
				db 0C3h	; Ã
				db 0B4h	; ´
				db    0
				db  9Ch	; œ
				db 0CDh	; Í
				db  1Ah
				db  9Dh	; 
				db 0C3h	; Ã
				db  20h
				db    0
				db    0
				db    2
				db  8Bh	; ‹
				db  0Eh
				db 0E8h	; è
				db    4
				db  2Eh	; .
				db  3Bh	; ;
				db  0Eh
				db    5
				db    5
				db  73h	; s
				db 0E1h	; á
				db  5Ah	; Z
				db  59h	; Y
				db 0C3h	; Ã
				db  20h
				db    0
				db 0E8h	; è
				db  0Bh
				db    0
				db  2Eh	; .
				db  89h	; ‰
				db  0Eh
				db  1Ah
				db    5
				db  2Eh	; .
				db  89h	; ‰
				db  16h
				db  1Ch
				db    5
				db 0C3h	; Ã
				db 0B4h	; ´
				db    0
				db 0CDh	; Í
				db  1Ah
				db 0C3h	; Ã
				db  20h
				db    0
				db    0
				db    2
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db  4Bh	; K
				db 0FFh
				db    0
				db  20h
				db    0
				db    0
				db    0
				db    0
				db    1
				db 0FEh	; þ
				db 0FFh
				db  1Ch
				db    9
				db 0D3h	; Ó
				db    1
				db 0D3h	; Ó
				db    1
				db 0C8h	; È
				db  20h
				db    0
				db 0F0h	; ð
				db    2
				db  70h	; p
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db    0
				db 0AEh	; ®
				db 0FEh	; þ
				db 0AEh	; ®
				db 0FEh	; þ
				db    0
				db 0F0h	; ð
				db  46h	; F
				db  70h	; p
				db  0Eh
				db    2
				db 0FFh
				db    0
				db    0
				db    6
				db 0CBh	; Ë
				db  14h
				db    0
				db 0F0h	; ð
				db  0Eh
				db    2
				db  1Ch
				db    9
				db  0Bh
				db    5
				db  7Bh	; {
				db  56h	; V
				db  5Ah	; Z
				db 0F3h	; ó
				db  1Fh
				db    1
				db    0
				db    0
seg000				ends


				end
