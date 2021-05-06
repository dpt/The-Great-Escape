> $4000 @start
> $4000 @writer=:TheGreatEscape.TheGreatEscapeAsmWriter
> $4000 @set-line-width=240
> $4000 @set-warnings=1
> $4000 @replace=/#FACT(?![A-Z])/#LINK:Facts
> $4000 ;
> $4000 ; SkoolKit disassembly of The Great Escape by Denton Designs.
> $4000 ; https://github.com/dpt/The-Great-Escape
> $4000 ;
> $4000 ; Copyright 1986 Ocean Software Ltd. (The Great Escape)
> $4000 ; Copyright 2012-2020 David Thomas <dave@davespace.co.uk> (this disassembly)
> $4000 ;
> $4000 @ofix+begin
> $4000 ; This disassembly contains ofix changes (operand fixes):
> $4000 ;
> $4000 @ofix+end
> $4000 @bfix+begin
> $4000 ; This disassembly contains bfix changes (bug fixes):
> $4000 ;   * Fix the $A2C6 incorrect iteration count resulting in a ROM write to $1A42.
> $4000 ;   * Makes unconditional a needless conditional return at $7CAF.
> $4000 ;   * Corrects the exterior_mask_data iteration count in render_mask_buffer/$B935.
> $4000 ;
> $4000 @bfix+end
> $4000 @rfix+begin
> $4000 ; This disassembly contains rfix changes (code movement):
> $4000 ;   * Removes the redundant self-modifying code at $6B19.
> $4000 ;   * Removes a redundant jump at $7AFB.
> $4000 ;   * Removes a redundant jump at $A0B8.
> $4000 ;   * Inserts the missing RET at the end of render_mask_buffer/$B916.
> $4000 ;   * $CCED potential bug fix for is_item_discoverable.
> $4000 ;
> $4000 @rfix+end
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; THE DISASSEMBLY
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; * This is a disassembly of the game when it has been loaded and relocated,
> $4000 ;   but not yet invoked: every byte is in its pristine state.
> $4000 ;
> $4000 ; * Any terminology used herein such as 'super tiles' or 'vischars' is my own
> $4000 ;   and has been invented for the purposes of the disassembly. I have seen none
> $4000 ;   of the original source, nor know anything of how it was built.
> $4000 ;
> $4000 ;   When I contacted the designer and author, John Heap, he informed me that
> $4000 ;   the original source is probably now lost forever. :-(
> $4000 ;
> $4000 ; * The md5sum of the original tape image this disassembly was taken from is
> $4000 ;   a6e5d50ab065accb017ecc957a954b53 and was sourced from
> $4000 ;   http://www.worldofspectrum.org/pub/sinclair/games/g/GreatEscapeThe.tzx.zip
> $4000 ;   but you may see slight differences towards the end of the file if you
> $4000 ;   attempt to recreate the disassembly yourself.
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; ASSEMBLY PATTERNS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Here are a selection of Z80 assembly language patterns which occur throughout
> $4000 ; the code.
> $4000 ;
> $4000 ; Multiply A by 2^N:
> $4000 ;   ADD A,A ; A += A (repeated N times)
> $4000 ; Note that this disposes of the topmost bit of A. Some routines discard flag
> $4000 ; bits this way.
> $4000 ;
> $4000 ; Increment HL by an 8-bit delta:
> $4000 ;   A = L
> $4000 ;   A += delta
> $4000 ;   L = A
> $4000 ;   JR NC,skip
> $4000 ;   H++
> $4000 ;   skip:
> $4000 ; Q: Does this only work for HL?
> $4000 ;
> $4000 ; if-else:
> $4000 ;   CP <value>
> $4000 ;   JR <cond>,elsepart;
> $4000 ;   <ifwork>
> $4000 ;   JR endifpart;
> $4000 ;   elsepart: <elsework>
> $4000 ;   endifpart:
> $4000 ;
> $4000 ; Jump if less than or equal:
> $4000 ;   CP $0F
> $4000 ;   JP Z,$C8F1
> $4000 ;   JP C,$C8F1
> $4000 ;
> $4000 ; Transfer between awkward registers:
> $4000 ;   PUSH reg
> $4000 ;   POP anotherreg
> $4000 ;
> $4000 ; Increment (HL) by -1 or +1:
> $4000 ;   BIT 7,A
> $4000 ;   JR Z,inc
> $4000 ;   DEC (HL)
> $4000 ;   DEC (HL)
> $4000 ;   inc: INC (HL)
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; COMMENTARY TERMS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; "CHECK". This indicates something that is still to be proven or verified.
> $4000 ;
> $4000 ; "Exit via". This indicates that, instead of a RET, the instruction will jump
> $4000 ; into another routine which itself will perform the RET.
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; ZX SPECTRUM BASIC DEFINITIONS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; These are here for information only and are not used by any of the assembly
> $4000 ; directives.
> $4000 ;
> $4000 ; attribute_BLUE_OVER_BLACK                     = 1,
> $4000 ; attribute_RED_OVER_BLACK                      = 2,
> $4000 ; attribute_PURPLE_OVER_BLACK                   = 3,
> $4000 ; attribute_GREEN_OVER_BLACK                    = 4,
> $4000 ; attribute_CYAN_OVER_BLACK                     = 5,
> $4000 ; attribute_YELLOW_OVER_BLACK                   = 6,
> $4000 ; attribute_WHITE_OVER_BLACK                    = 7,
> $4000 ; attribute_BRIGHT_BLUE_OVER_BLACK              = 65,
> $4000 ; attribute_BRIGHT_RED_OVER_BLACK               = 66,
> $4000 ; attribute_BRIGHT_PURPLE_OVER_BLACK            = 67,
> $4000 ; attribute_BRIGHT_GREEN_OVER_BLACK             = 68,
> $4000 ; attribute_BRIGHT_CYAN_OVER_BLACK              = 69,
> $4000 ; attribute_BRIGHT_YELLOW_OVER_BLACK            = 70,
> $4000 ; attribute_BRIGHT_WHITE_OVER_BLACK             = 71,
> $4000 ;
> $4000 ; port_KEYBOARD_SHIFTZXCV                       = $FEFE,
> $4000 ; port_KEYBOARD_ASDFG                           = $FDFE,
> $4000 ; port_KEYBOARD_QWERT                           = $FBFE,
> $4000 ; port_KEYBOARD_12345                           = $F7FE,
> $4000 ; port_KEYBOARD_09876                           = $EFFE,
> $4000 ; port_KEYBOARD_POIUY                           = $DFFE,
> $4000 ; port_KEYBOARD_ENTERLKJH                       = $BFFE,
> $4000 ; port_KEYBOARD_SPACESYMSHFTMNB                 = $7FFE,
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; CONSTANTS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; These are here for information only and are not used by any of the assembly
> $4000 ; directives.
> $4000 ;
> $4000 ; character_0_COMMANDANT                        = 0,
> $4000 ; character_1_GUARD_1                           = 1,
> $4000 ; character_2_GUARD_2                           = 2,
> $4000 ; character_3_GUARD_3                           = 3,
> $4000 ; character_4_GUARD_4                           = 4,
> $4000 ; character_5_GUARD_5                           = 5,
> $4000 ; character_6_GUARD_6                           = 6,
> $4000 ; character_7_GUARD_7                           = 7,
> $4000 ; character_8_GUARD_8                           = 8,
> $4000 ; character_9_GUARD_9                           = 9,
> $4000 ; character_10_GUARD_10                         = 10,
> $4000 ; character_11_GUARD_11                         = 11,
> $4000 ; character_12_GUARD_12                         = 12,
> $4000 ; character_13_GUARD_13                         = 13,
> $4000 ; character_14_GUARD_14                         = 14,
> $4000 ; character_15_GUARD_15                         = 15,
> $4000 ; character_16_GUARD_DOG_1                      = 16,
> $4000 ; character_17_GUARD_DOG_2                      = 17,
> $4000 ; character_18_GUARD_DOG_3                      = 18,
> $4000 ; character_19_GUARD_DOG_4                      = 19,
> $4000 ; character_20_PRISONER_1                       = 20,
> $4000 ; character_21_PRISONER_2                       = 21,
> $4000 ; character_22_PRISONER_3                       = 22,
> $4000 ; character_23_PRISONER_4                       = 23,
> $4000 ; character_24_PRISONER_5                       = 24,
> $4000 ; character_25_PRISONER_6                       = 25,
> $4000 ; character_26_STOVE_1                          = 26,   ; movable item
> $4000 ; character_27_STOVE_2                          = 27,   ; movable item
> $4000 ; character_28_CRATE                            = 28,   ; movable item
> $4000 ; character_NONE                                = 255,
> $4000 ;
> $4000 ; room_0_OUTDOORS                               = 0,
> $4000 ; room_1_HUT1RIGHT                              = 1,
> $4000 ; room_2_HUT2LEFT                               = 2,
> $4000 ; room_3_HUT2RIGHT                              = 3,
> $4000 ; room_4_HUT3LEFT                               = 4,
> $4000 ; room_5_HUT3RIGHT                              = 5,
> $4000 ; room_6                                        = 6,    ; unused room index
> $4000 ; room_7_CORRIDOR                               = 7,
> $4000 ; room_8_CORRIDOR                               = 8,
> $4000 ; room_9_CRATE                                  = 9,
> $4000 ; room_10_LOCKPICK                              = 10,
> $4000 ; room_11_PAPERS                                = 11,
> $4000 ; room_12_CORRIDOR                              = 12,
> $4000 ; room_13_CORRIDOR                              = 13,
> $4000 ; room_14_TORCH                                 = 14,
> $4000 ; room_15_UNIFORM                               = 15,
> $4000 ; room_16_CORRIDOR                              = 16,
> $4000 ; room_17_CORRIDOR                              = 17,
> $4000 ; room_18_RADIO                                 = 18,
> $4000 ; room_19_FOOD                                  = 19,
> $4000 ; room_20_REDCROSS                              = 20,
> $4000 ; room_21_CORRIDOR                              = 21,
> $4000 ; room_22_REDKEY                                = 22,
> $4000 ; room_23_MESS_HALL                             = 23,
> $4000 ; room_24_SOLITARY                              = 24,
> $4000 ; room_25_MESS_HALL                             = 25,
> $4000 ; room_26                                       = 26,   ; unused room index
> $4000 ; room_27                                       = 27,   ; unused room index
> $4000 ; room_28_HUT1LEFT                              = 28,
> $4000 ; room_29_SECOND_TUNNEL_START                   = 29,   ; first of the tunnel rooms
> $4000 ; room_30                                       = 30,
> $4000 ; room_31                                       = 31,
> $4000 ; room_32                                       = 32,
> $4000 ; room_33                                       = 33,
> $4000 ; room_34                                       = 34,
> $4000 ; room_35                                       = 35,
> $4000 ; room_36                                       = 36,
> $4000 ; room_37                                       = 37,
> $4000 ; room_38                                       = 38,
> $4000 ; room_39                                       = 39,
> $4000 ; room_40                                       = 40,
> $4000 ; room_41                                       = 41,
> $4000 ; room_42                                       = 42,
> $4000 ; room_43                                       = 43,
> $4000 ; room_44                                       = 44,
> $4000 ; room_45                                       = 45,
> $4000 ; room_46                                       = 46,
> $4000 ; room_47                                       = 47,
> $4000 ; room_48                                       = 48,
> $4000 ; room_49                                       = 49,
> $4000 ; room_50_BLOCKED_TUNNEL                        = 50,
> $4000 ; room_51                                       = 51,
> $4000 ; room_52                                       = 52,
> $4000 ; room_NONE                                     = 255,
> $4000 ;
> $4000 ; item_WIRESNIPS                                = 0,
> $4000 ; item_SHOVEL                                   = 1,
> $4000 ; item_LOCKPICK                                 = 2,
> $4000 ; item_PAPERS                                   = 3,
> $4000 ; item_TORCH                                    = 4,
> $4000 ; item_BRIBE                                    = 5,
> $4000 ; item_UNIFORM                                  = 6,
> $4000 ; item_FOOD                                     = 7,
> $4000 ; item_POISON                                   = 8,
> $4000 ; item_RED_KEY                                  = 9,
> $4000 ; item_YELLOW_KEY                               = 10,
> $4000 ; item_GREEN_KEY                                = 11,
> $4000 ; item_RED_CROSS_PARCEL                         = 12,
> $4000 ; item_RADIO                                    = 13,
> $4000 ; item_PURSE                                    = 14,
> $4000 ; item_COMPASS                                  = 15,
> $4000 ; item__LIMIT                                   = 16,
> $4000 ; item_NONE                                     = 255,
> $4000 ;
> $4000 ; zoombox_tile_TL                               = 0,    ; top left
> $4000 ; zoombox_tile_HZ                               = 1,    ; horizontal
> $4000 ; zoombox_tile_TR                               = 2,    ; top right
> $4000 ; zoombox_tile_VT                               = 3,    ; vertical
> $4000 ; zoombox_tile_BR                               = 4,    ; bottom right
> $4000 ; zoombox_tile_BL                               = 5,    ; bottom left
> $4000 ;
> $4000 ; message_MISSED_ROLL_CALL                      = 0,
> $4000 ; message_TIME_TO_WAKE_UP                       = 1,
> $4000 ; message_BREAKFAST_TIME                        = 2,
> $4000 ; message_EXERCISE_TIME                         = 3,
> $4000 ; message_TIME_FOR_BED                          = 4,
> $4000 ; message_THE_DOOR_IS_LOCKED                    = 5,
> $4000 ; message_IT_IS_OPEN                            = 6,
> $4000 ; message_INCORRECT_KEY                         = 7,
> $4000 ; message_ROLL_CALL                             = 8,
> $4000 ; message_RED_CROSS_PARCEL                      = 9,
> $4000 ; message_PICKING_THE_LOCK                      = 10,
> $4000 ; message_CUTTING_THE_WIRE                      = 11,
> $4000 ; message_YOU_OPEN_THE_BOX                      = 12,
> $4000 ; message_YOU_ARE_IN_SOLITARY                   = 13,
> $4000 ; message_WAIT_FOR_RELEASE                      = 14,
> $4000 ; message_MORALE_IS_ZERO                        = 15,
> $4000 ; message_ITEM_DISCOVERED                       = 16,
> $4000 ; message_HE_TAKES_THE_BRIBE                    = 17,
> $4000 ; message_AND_ACTS_AS_DECOY                     = 18,
> $4000 ; message_ANOTHER_DAY_DAWNS                     = 19,
> $4000 ; message_QUEUE_END                             = 255,
> $4000 ;
> $4000 ; interiorobject_STRAIGHT_TUNNEL_SW_NE          = 0,
> $4000 ; interiorobject_SMALL_TUNNEL_ENTRANCE          = 1,
> $4000 ; interiorobject_ROOM_OUTLINE_22x12_A           = 2,
> $4000 ; interiorobject_STRAIGHT_TUNNEL_NW_SE          = 3,
> $4000 ; interiorobject_TUNNEL_T_JOIN_NW_SE            = 4,
> $4000 ; interiorobject_PRISONER_SAT_MID_TABLE         = 5,
> $4000 ; interiorobject_TUNNEL_T_JOIN_SW_NE            = 6,
> $4000 ; interiorobject_TUNNEL_CORNER_SW_SE            = 7,
> $4000 ; interiorobject_WIDE_WINDOW_FACING_SE          = 8,
> $4000 ; interiorobject_EMPTY_BED_FACING_SE            = 9,
> $4000 ; interiorobject_SHORT_WARDROBE_FACING_SW       = 10,
> $4000 ; interiorobject_CHEST_OF_DRAWERS_FACING_SW     = 11,
> $4000 ; interiorobject_TUNNEL_CORNER_NW_NE            = 12,
> $4000 ; interiorobject_EMPTY_BENCH                    = 13,
> $4000 ; interiorobject_TUNNEL_CORNER_NE_SE            = 14,
> $4000 ; interiorobject_DOOR_FRAME_SE                  = 15,
> $4000 ; interiorobject_DOOR_FRAME_SW                  = 16,
> $4000 ; interiorobject_TUNNEL_CORNER_NW_SW            = 17,
> $4000 ; interiorobject_TUNNEL_ENTRANCE                = 18,
> $4000 ; interiorobject_PRISONER_SAT_END_TABLE         = 19,
> $4000 ; interiorobject_COLLAPSED_TUNNEL_SW_NE         = 20,
> $4000 ; interiorobject_UNUSED_21                      = 21,   ; unused by game, draws as interiorobject_ROOM_OUTLINE_22x12_A
> $4000 ; interiorobject_CHAIR_FACING_SE                = 22,
> $4000 ; interiorobject_OCCUPIED_BED                   = 23,
> $4000 ; interiorobject_ORNATE_WARDROBE_FACING_SW      = 24,
> $4000 ; interiorobject_CHAIR_FACING_SW                = 25,
> $4000 ; interiorobject_CUPBOARD_FACING_SE             = 26,
> $4000 ; interiorobject_ROOM_OUTLINE_18x10_A           = 27,
> $4000 ; interiorobject_UNUSED_28                      = 28,   ; unused by game, draws as interiorobject_TABLE
> $4000 ; interiorobject_TABLE                          = 29,
> $4000 ; interiorobject_STOVE_PIPE                     = 30,
> $4000 ; interiorobject_PAPERS_ON_FLOOR                = 31,
> $4000 ; interiorobject_TALL_WARDROBE_FACING_SW        = 32,
> $4000 ; interiorobject_SMALL_SHELF_FACING_SE          = 33,
> $4000 ; interiorobject_SMALL_CRATE                    = 34,
> $4000 ; interiorobject_SMALL_WINDOW_WITH_BARS_FACING_SE = 35
> $4000 ; interiorobject_TINY_DOOR_FRAME_NE             = 36,   ; tunnel entrance
> $4000 ; interiorobject_NOTICEBOARD_FACING_SE          = 37,
> $4000 ; interiorobject_DOOR_FRAME_NW                  = 38,
> $4000 ; interiorobject_UNUSED_39                      = 39,   ; unused by game, draws as interiorobject_END_DOOR_FRAME_NW_SE
> $4000 ; interiorobject_DOOR_FRAME_NE                  = 40,
> $4000 ; interiorobject_ROOM_OUTLINE_15x8              = 41,
> $4000 ; interiorobject_CUPBOARD_FACING_SW             = 42,
> $4000 ; interiorobject_MESS_BENCH                     = 43,
> $4000 ; interiorobject_MESS_TABLE                     = 44,
> $4000 ; interiorobject_MESS_BENCH_SHORT               = 45,
> $4000 ; interiorobject_ROOM_OUTLINE_18x10_B           = 46,
> $4000 ; interiorobject_ROOM_OUTLINE_22x12_B           = 47,
> $4000 ; interiorobject_TINY_TABLE                     = 48,
> $4000 ; interiorobject_TINY_DRAWERS_FACING_SE         = 49,
> $4000 ; interiorobject_TALL_DRAWERS_FACING_SW         = 50,
> $4000 ; interiorobject_DESK_FACING_SW                 = 51,
> $4000 ; interiorobject_SINK_FACING_SE                 = 52,
> $4000 ; interiorobject_KEY_RACK_FACING_SE             = 53,
> $4000 ; interiorobject__LIMIT                         = 54
> $4000 ;
> $4000 ; interiorobjecttile_MAX                        = 194,  ; number of tiles at $9768 interior_tiles
> $4000 ; interiorobjecttile_ESCAPE                     = 255,  ; escape character
> $4000 ;
> $4000 ; sound_CHARACTER_ENTERS_1                      = $2030,
> $4000 ; sound_CHARACTER_ENTERS_2                      = $2040,
> $4000 ; sound_BELL_RINGER                             = $2530,
> $4000 ; sound_PICK_UP_ITEM                            = $3030,
> $4000 ; sound_DROP_ITEM                               = $3040,
> $4000 ;
> $4000 ; morale_MIN                                    = 0,
> $4000 ; morale_MAX                                    = 112,
> $4000 ;
> $4000 ; direction_TOP_LEFT                            = 0
> $4000 ; direction_TOP_RIGHT                           = 1,
> $4000 ; direction_BOTTOM_RIGHT                        = 2,
> $4000 ; direction_BOTTOM_LEFT                         = 3,
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; FLAGS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; These are here for information only and are not used by any of the
> $4000 ; directives.
> $4000 ;
> $4000 ; INPUT
> $4000 ; -----
> $4000 ;
> $4000 ; input_NONE                                    = 0,
> $4000 ; input_UP                                      = 1,
> $4000 ; input_DOWN                                    = 2,
> $4000 ; input_LEFT                                    = 3,
> $4000 ; input_RIGHT                                   = 6,
> $4000 ; input_FIRE                                    = 9,
> $4000 ; input_UP_FIRE                                 = input_UP    + input_FIRE,
> $4000 ; input_DOWN_FIRE                               = input_DOWN  + input_FIRE,
> $4000 ; input_LEFT_FIRE                               = input_LEFT  + input_FIRE,
> $4000 ; input_RIGHT_FIRE                              = input_RIGHT + input_FIRE,
> $4000 ;
> $4000 ; VISCHAR
> $4000 ; -------
> $4000 ;
> $4000 ; vischar byte 0 'character' ::
> $4000 ;
> $4000 ; Character index mask. This is used in a couple of places but it's not
> $4000 ; consistently applied. I've not spotted anything else sharing the this field.
> $4000 ; vischar_CHARACTER_MASK                        = $1F,
> $4000 ;
> $4000 ; vischar byte 1 'flags' ::
> $4000 ;
> $4000 ; Indicates that this vischar is unused.
> $4000 ; vischar_FLAGS_EMPTY_SLOT                      = $FF,
> $4000 ;
> $4000 ; Bits 0..5 form a mask to isolate all of the modes.
> $4000 ; Note: $0F would be sufficient.
> $4000 ; vischar_FLAGS_MASK                            = $3F,
> $4000 ;
> $4000 ; The bottom nibble of flags contains either two flags for the hero, or a
> $4000 ; pursuit mode field for NPCs.
> $4000 ;
> $4000 ; Bit 0 is set when the hero is picking a lock. (Hero only)
> $4000 ; vischar_FLAGS_PICKING_LOCK                    = 1,
> $4000 ;
> $4000 ; Bit 1 is set when the hero is cutting wire. (Hero only)
> $4000 ; vischar_FLAGS_CUTTING_WIRE                    = 2,
> $4000 ;
> $4000 ; Bits 0..3 are a mask to isolate the pursuit mode.
> $4000 ; vischar_FLAGS_PURSUIT_MASK                    = $0F,
> $4000 ;
> $4000 ; Pursuit mode == 1 when a friendly character was nearby when a bribe was used
> $4000 ; or when a hostile is pursuing with intent to capture. (NPC only) Set in
> $4000 ; #R$CCAB.
> $4000 ; vischar_PURSUIT_PURSUE                        = 1,
> $4000 ;
> $4000 ; Pursuit mode == 2 when a hostile sees a player-controlled hero, or the flag
> $4000 ; is red. It causes hostiles to follow the hero and get in his way but not
> $4000 ; arrest him. (NPC only)
> $4000 ; Set in #R$CC37.
> $4000 ; vischar_PURSUIT_HASSLE                        = 2,
> $4000 ;
> $4000 ; Pursuit mode == 3 when food is in the vicinity of a dog. (Guard dog NPC only)
> $4000 ; vischar_PURSUIT_DOG_FOOD                      = 3,
> $4000 ;
> $4000 ; Pursuit mode == 4 when a hostile was nearby when a bribe was accepted. It
> $4000 ; causes the hostile to target the character who accepted the bribe. (Hostile
> $4000 ; NPC only)
> $4000 ; vischar_PURSUIT_SAW_BRIBE                     = 4,
> $4000 ;
> $4000 ; Bits 4 and 5 are unused.
> $4000 ;
> $4000 ; Bit 6 is set when the next target is a door.
> $4000 ; vischar_FLAGS_TARGET_IS_DOOR                  = 1 << 6,
> $4000 ;
> $4000 ; Bit 7 is set in #R$B5CE to stop #R$AFDF running for this vischar.
> $4000 ; vischar_FLAGS_NO_COLLIDE                      = 1 << 7,
> $4000 ;
> $4000 ; vischar byte 7 'counter_and_flags' ::
> $4000 ;
> $4000 ; Bits 0..3 form a mask to isolate the character behaviour delay field.
> $4000 ; #R$C918 counts this field down to zero at which point it performs character
> $4000 ; behaviours. In the game this is only ever set to five.
> $4000 ; vischar_BYTE7_COUNTER_MASK                    = $F0,
> $4000 ;
> $4000 ; Bit 4 is unused.
> $4000 ;
> $4000 ; Bit 5 is set when #$CA49 should run in preference to #R$CA11.
> $4000 ; vischar_BYTE7_Y_DOMINANT                      = 1 << 5,
> $4000 ;
> $4000 ; Bit 6 is set when map movement should be inhibited. (Hero only)
> $4000 ; Set in #R$AF8F.
> $4000 ; vischar_BYTE7_DONT_MOVE_MAP                   = 1 << 6,
> $4000 ;
> $4000 ; Bit 7 is set when #R$AF8F is entered, implying that vischar.mi etc. are
> $4000 ; setup.
> $4000 ; vischar_DRAWABLE                              = 1 << 7,
> $4000 ;
> $4000 ; vischar byte $C 'animindex' ::
> $4000 ;
> $4000 ; Bit 7 is set to play the animation in reverse.
> $4000 ; vischar_ANIMINDEX_BIT7                        = 1 << 7,
> $4000 ;
> $4000 ; vischar byte $E 'direction' ::
> $4000 ;
> $4000 ; Bits 0..1 form a mask to isolate the direction field.
> $4000 ; vischar_DIRECTION_MASK                        = $03,
> $4000 ;
> $4000 ; Bit 2 is set when crawling.
> $4000 ; vischar_DIRECTION_CRAWL                       = 1 << 2,
> $4000 ;
> $4000 ; ITEMSTRUCT
> $4000 ; ----------
> $4000 ;
> $4000 ; itemstruct byte 0 'item_and_flags' ::
> $4000 ;
> $4000 ; Bits 0..3 form a mask to isolate the item field.
> $4000 ; itemstruct_ITEM_MASK                          = $0F,
> $4000 ;
> $4000 ; Bit 4 is an unknown purpose flag used in a mask by #R$7B36, but never set.
> $4000 ; It's possibly evidence of a larger itemstruct_ITEM_MASK.
> $4000 ;
> $4000 ; Bit 5 is set on item_FOOD when it is poisoned. This only affects the amount
> $4000 ; of time a guard dog is stalled for. The dog will eat the food and "die"
> $4000 ; (halt) either way.
> $4000 ; itemstruct_ITEM_FLAG_POISONED                 = 1 << 5,
> $4000 ;
> $4000 ; Bit 6 is unused.
> $4000 ;
> $4000 ; Bit 7 is set when the item is picked up for the first time (for scoring).
> $4000 ; itemstruct_ITEM_FLAG_HELD                     = 1 << 7,
> $4000 ;
> $4000 ; itemstruct byte 1 'room_and_flags' ::
> $4000 ;
> $4000 ; Bits 0..5 form a mask to isolate the room field.
> $4000 ; itemstruct_ROOM_MASK                          = $3F,
> $4000 ;
> $4000 ; Indicates that the item is nowhere. This is (item_NONE &
> $4000 ; itemstruct_ROOM_MASK).
> $4000 ; itemstruct_ROOM_NONE                          = $3F,
> $4000 ;
> $4000 ; Bit 6 is set when the item is nearby.
> $4000 ; Cleared by #R$DB9E and #R$B89C.
> $4000 ; itemstruct_ROOM_FLAG_NEARBY_6                 = 1 << 6,
> $4000 ;
> $4000 ; Bit 7 is set when the item is nearby.
> $4000 ; Cleared by #R$DB9E. Enables #R$7C82 for the item. #R$C918 uses it on
> $4000 ; item_FOOD to trigger guard dog behaviour.
> $4000 ; itemstruct_ROOM_FLAG_NEARBY_7                 = 1 << 7,
> $4000 ;
> $4000 ; OTHERS
> $4000 ; ------
> $4000 ;
> $4000 ; route_REVERSED                                = 1 << 7,       ; set if the route is to be followed in reverse order
> $4000 ;
> $4000 ; door_REVERSE                                  = 1 << 7,       ; used to reverse door transitions
> $4000 ; door_LOCKED                                   = 1 << 7,       ; used to lock doors in locked_doors[]
> $4000 ; door_NONE                                     = $FF
> $4000 ;
> $4000 ; characterstruct_FLAG_ON_SCREEN                = 1 << 6,       ; this disables the character
> $4000 ; characterstruct_CHARACTER_MASK                = $1F,
> $4000 ; characterstruct_BYTE5_MASK                    = $7F,
> $4000 ; characterstruct_BYTE6_MASK_LO                 = $07,
> $4000 ;
> $4000 ; door_FLAGS_MASK_DIRECTION                     = $03,          ; up/down or direction field?
> $4000 ;
> $4000 ; searchlight_STATE_CAUGHT                      = $1F,
> $4000 ; searchlight_STATE_SEARCHING                   = $FF,          ; hunting for hero
> $4000 ;
> $4000 ; bell_RING_PERPETUAL                           = $00,
> $4000 ; bell_RING_40_TIMES                            = $28,
> $4000 ; bell_STOP                                     = $FF,
> $4000 ;
> $4000 ; escapeitem_COMPASS                            = 1,
> $4000 ; escapeitem_PAPERS                             = 2,
> $4000 ; escapeitem_PURSE                              = 4,
> $4000 ; escapeitem_UNIFORM                            = 8,
> $4000 ;
> $4000 ; statictiles_COUNT_MASK                        = $7F,
> $4000 ; statictiles_VERTICAL                          = 1 << 7,       ; otherwise horizontal
> $4000 ;
> $4000 ; map_MAIN_GATE_X                               = $696D,        ; coords: $69..$6D
> $4000 ; map_MAIN_GATE_Y                               = $494B,
> $4000 ; map_ROLL_CALL_X                               = $727C,
> $4000 ; map_ROLL_CALL_Y                               = $6A72,
> $4000 ;
> $4000 ; inputdevice_KEYBOARD                          = 0,
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; COMMON TYPES
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; 'bounds_t' is a bounding box:
> $4000 ; +---------------------------------+
> $4000 ; | Type | Bytes | Name | Meaning   |
> $4000 ; |---------------------------------|
> $4000 ; | Byte |     1 |   x0 | Minimum x |
> $4000 ; | Byte |     1 |   x1 | Maximum x |
> $4000 ; | Byte |     1 |   y0 | Minimum y |
> $4000 ; | Byte |     1 |   y1 | Maximum y |
> $4000 ; +---------------------------------+
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; ROOMS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Key
> $4000 ;
> $4000 ;   '' => door (up/down)
> $4000 ;   =  => door (left/right)
> $4000 ;   in => entrance
> $4000 ;   [] => exit
> $4000 ;   ~  => void / ground
> $4000 ;
> $4000 ; Map of rooms' indices
> $4000 ;
> $4000 ;   +--------+--------+----+----+----+
> $4000 ;   |   25   =   23   = 19 = 18 = 12 |
> $4000 ;   +--------+-+-''-+-+----+    +-''-+
> $4000 ;    | 24 = 22 = 21 | | 20 +    + 17 |
> $4000 ;    +----+----+-''-+ +-''-+----+-''-+
> $4000 ;                          = 15 |  7 |
> $4000 ;       +----+------+      +-''-+-''-+
> $4000 ;       = 28 =   1  |      | 14 = 16 |
> $4000 ;       +----+--''--+      +----+-''-+
> $4000 ;                               = 13 |
> $4000 ;       +----+------+           +-''-+
> $4000 ;       =  2 =   3  |           | 11 |
> $4000 ;       +----+--''--+           |    |
> $4000 ;                          +----+----+
> $4000 ;       +----+------+      | 10 |  9 |
> $4000 ;       =  4 =   5  |      |    |    |
> $4000 ;       +----+--''--+      +-''-+-''-+
> $4000 ;                          =    8    |
> $4000 ;                          +----+----+
> $4000 ;
> $4000 ; Map of tunnels' indices 1
> $4000 ;
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~+---------+----+
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~|    49   = 50 |
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~+-''-+----+-''-+
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~| 48 |~~~~| 47 |
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~+-[]-+~~~~|    |
> $4000 ;   +------+-------+----+----+----+    |
> $4000 ;   |  45  =   41  =    40   | 46 =    |
> $4000 ;   +-''-+-+--+-''-+------''-+-''-+----+
> $4000 ;   | 44 = 43 = 42 |~~~~| 38 = 39 |~~~~~
> $4000 ;   +----+----+----+~~~~+-''-+----+~~~~~
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~| 37 |~~~~~~~~~~
> $4000 ;   ~~~~~~~~~~~~~~~~~~~~+-in-+~~~~~~~~~~
> $4000 ;
> $4000 ; Map of tunnels' indices 2
> $4000 ;
> $4000 ;   +----------+--------+--------+
> $4000 ;   |    36    =   30   =   52   |
> $4000 ;   +-''-+-----+--''----+---+-''-+
> $4000 ;   | 35 |~~~~~~| 31 |~~~~~~| 51 |
> $4000 ;   |    +------+-''-+~~~~~~|    |
> $4000 ;   |    =  33  = 32 |~~~~~~|    |
> $4000 ;   |    +------+----+~~~~~~|    |
> $4000 ;   |    |~~~~~~~~~~~~~+----+    |
> $4000 ;   +-''-+~~~~~~~~~~~~in 29 =    |
> $4000 ;   | 34 |~~~~~~~~~~~~~+----+----+
> $4000 ;   +-[]-+~~~~~~~~~~~~~~~~~~~~~~~~
> $4000 ;
> $4000 ; I'm fairly sure that the visual of the above layout is actually topologically
> $4000 ; impossible. e.g. if you take screenshots of every room and attempt to combine
> $4000 ; them in an image editor it won't join up.
> $4000 ;
> $4000 ; Unused room indices: 6, 26, 27
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; GAME STATE
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; There are eight visible character (vischar) structures living at $8000
> $4000 ; onwards. The game therefore supports up to eight characters on-screen at
> $4000 ; once. The stove and crate items count as characters too.
> $4000 ;
> $4000 ; These structures occupy the same addresses as some of the static tiles. This
> $4000 ; is fine as the static tiles are never referenced once they're plotted to the
> $4000 ; screen at startup.
> $4000 ;
> $4000 ; The structures are 32 bytes long. Each structure is laid out as follows:
> $4000 ;
> $4000 ; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
> $4000 ; | Type        | Bytes | Name              | Meaning                                                                       |
> $4000 ; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
> $4000 ; | Character   |     1 | character         | Character index, or $FF if none                                               |
> $4000 ; | Byte        |     1 | flags             | Flags                                                                         |
> $4000 ; | Route       |     2 | route             | Route                                                                         |
> $4000 ; | TinyPos     |     3 | target            | Target position                                                               |
> $4000 ; | Byte        |     1 | counter_and_flags | Top nibble = flags, bottom nibble = counter used by character_behaviour only  |
> $4000 ; | Pointer     |     2 | animbase          | Pointer to animation base (never changes)                                     |
> $4000 ; | Pointer     |     2 | anim              | Pointer to value in animations                                                |
> $4000 ; | Byte        |     1 | animindex         | Bit 7 is up/down flag, other bits are an animation counter                    |
> $4000 ; | Byte        |     1 | input             | Input .. previous direction?                                                  |
> $4000 ; | Byte        |     1 | direction         | Direction and walk/crawl flag                                                 |
> $4000 ; | MovableItem |     9 | mi                | Movable item structure (pos (where we are), current sprite, sprite index)     |
> $4000 ; | BigXY       |     4 | iso_pos           | Screen x, y coord                                                             |
> $4000 ; | Room        |     1 | room              | Current room index                                                            |
> $4000 ; | Byte        |     1 | unused            | -                                                                             |
> $4000 ; | Byte        |     1 | width_bytes       | Copy of sprite width in bytes + 1                                             |
> $4000 ; | Byte        |     1 | height            | Copy of sprite height in rows                                                 |
> $4000 ; +-------------+-------+-------------------+-------------------------------------------------------------------------------+
> $4000 ;
> $4000 ; The first entry in the array is the hero.
> $4000 ;
> $4000 ; Further notes:
> $4000 ;
> $4000 ; b $8001 flags: bit 6 gets toggled in set_hero_route /  bit 0: picking lock /  bit 1: cutting wire  ($FF when reset)
> $4000 ; w $8002 route (set in set_hero_route, process_player_input)
> $4000 ; b*3 $8004 (<- process_player_input) a coordinate? (i see it getting scaled in #R$CA11)
> $4000 ; b $8007 bits 5/6/7: flags  (suspect bit 4 is a flag too) ($00 when reset)
> $4000 ; w $8008 (read by animate)
> $4000 ; w $800A (read/written by animate)
> $4000 ; b $800C (read/written by animate)
> $4000 ; b $800D tunnel related (<- process_player_input, cutting_wire, process_player_input) assigned from cutting_wire_new_inputs table.  causes movement when set. but not when in solitary.
> $4000 ;            $81 -> move toward top left,
> $4000 ;            $82 -> move toward bottom right,
> $4000 ;            $83 -> move toward bottom left,
> $4000 ;            $84 -> TL (again)
> $4000 ;            $85 ->
> $4000 ; b $800E tunnel related, direction (bottom 2 bits index cutting_wire_new_inputs) bit 2 is walk/crawl flag
> $4000 ; set to - $00 -> character faces top left
> $4000 ;          $01 -> character faces top right
> $4000 ;          $02 -> character faces bottom right
> $4000 ;          $03 -> character faces bottom left
> $4000 ;          $04 -> character faces top left     (crawling)
> $4000 ;          $05 -> character faces top right    (crawling)
> $4000 ;          $06 -> character faces bottom right (crawling)
> $4000 ;          $07 -> character faces bottom left  (crawling)
> $4000 ; w $800F position on X axis (along the line of - bottom right to top left of screen) (set by process_player_input)
> $4000 ; w $8011 position on Y axis (along the line of - bottom left to top right of screen) (set by process_player_input)  i think this might be relative to the current size of the map. each step seems to be two pixels.
> $4000 ; w $8013 character's height // set to 24 in process_player_input, cutting_wire,  set to 12 in action_wiresnips,  reset in calc_vischar_iso_pos_from_vischar,  read by animate ($B68C) (via IY), get_next_drawable ($B8DE), setup_vischar_plotting ($E433), in_permitted_area ($9F4F)  written by touch ($AFD5)  often written as a byte, but suspect it's a word-sized value
> $4000 ; w $8015 pointer to current character sprite set (gets pointed to the 'tl_4' sprite)
> $4000 ; b $8017 touch sets this to touch_stashed_A
> $4000 ; w $8018 points to something (gets $06C8 subtracted from it) (<- in_permitted_area)
> $4000 ; w $801A points to something (gets $0448 subtracted from it) (<- in_permitted_area)
> $4000 ; b $801C room index: cleared to zero by action_papers, set to room_24_SOLITARY by solitary, copied to room_index by transition
> $4000 ;
> $4000 ; Other things:
> $4000 ;
> $4000 ; b $8100 mask buffer ($A0 bytes - 4 * 8 * 5)
> $4000 ; w $81A0 mask buffer pointer
> $4000 ; w $81A2 screen buffer pointer
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; ROUTES
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Each vischar has a "route" structure that guides its pathfinding. The route
> $4000 ; is composed of an index and a step (the first and second bytes respectively).
> $4000 ; The index selects a route from the table at #R$7738. The step is the index
> $4000 ; into that route. If the top bit of the route index is set then the route is
> $4000 ; followed in reverse order.
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; HUTS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Hut 1 is the hut at the 'top' of the map.
> $4000 ; Hut 2 is the middle hut.
> $4000 ; Hut 3 is the bottom hut.
> $4000 ;
> $4000 ; These identifiers for the huts are my own convention - as with all things in
> $4000 ; this disassembly it was determined from scratch.
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; HUT INTERIORS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Hut 1 is composed of room 28 on the left and room 1 on the right.
> $4000 ; Hut 2 is composed of room  2 on the left and room 3 on the right.
> $4000 ; Hut 3 is composed of room  4 on the left and room 5 on the right.
> $4000 ;
> $4000 ;
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ; SLEEPING CHARACTERS
> $4000 ; //////////////////////////////////////////////////////////////////////////////
> $4000 ;
> $4000 ; Three of the four beds in hut 1 are occupied by sleeping figures who -
> $4000 ; creepily - never rise from their slumber. Perhaps more concurrent prisoner
> $4000 ; characters were originally planned - there's capacity in the room layout for
> $4000 ; eleven - but machine limits prevented more than six being used.
> $4000 ;
> $4000 ; In hut 2, our hero sleeps in the left hand room and three active characters
> $4000 ; (20..22) slumber in the right hand room.
> $4000 ;
> $4000 ; Hut 3 has no character sleeping in its left hand room and three active
> $4000 ; characters (23..25) sleep in the right hand room.
> $4000 ;
> $4000 ;       |-- Left room --|----------------- Right room -----------------|
> $4000 ;       |---------------|-- Left bed --|-- Middle bed -|-- Right bed --|
> $4000 ; Hut 1 | Always asleep | Always empty | Always asleep | Always asleep |
> $4000 ; Hut 2 | Hero          | 22           | 21            | 20            |
> $4000 ; Hut 3 | Always empty  | 25           | 24            | 23            |
> $4000 ;
> $4000 @org=$4000
;
b $4000 Loading screen.
D $4000 #UDGTABLE { #SCR(loading) | This is the loading screen. } TABLE#
@ $4000 label=screen
B $4000,6144,32 Pixel data.
B $5800,768,32 Attribute data.
;
b $5B00 Super tiles.
D $5B00 The map for the game's exterior section (defined by #R$BCEE) is built from references to these 32x32 pixel "super tiles". Each super tile is a 4x4 array of tile indices (defined by #R$8590).
@ $5B00 label=super_tiles
B $5B00,16,4 super_tile $00 #HTML[#CALL:supertile($5B00, 0)]
B $5B10,16,4 super_tile $01 #HTML[#CALL:supertile($5B10, 0)]
B $5B20,16,4 super_tile $02 #HTML[#CALL:supertile($5B20, 0)]
B $5B30,16,4 super_tile $03 #HTML[#CALL:supertile($5B30, 0)]
B $5B40,16,4 super_tile $04 #HTML[#CALL:supertile($5B40, 0)]
B $5B50,16,4 super_tile $05 #HTML[#CALL:supertile($5B50, 0)]
B $5B60,16,4 super_tile $06 #HTML[#CALL:supertile($5B60, 0)]
B $5B70,16,4 super_tile $07 #HTML[#CALL:supertile($5B70, 0)]
B $5B80,16,4 super_tile $08 #HTML[#CALL:supertile($5B80, 0)]
B $5B90,16,4 super_tile $09 #HTML[#CALL:supertile($5B90, 0)]
B $5BA0,16,4 super_tile $0A #HTML[#CALL:supertile($5BA0, 0)]
B $5BB0,16,4 super_tile $0B #HTML[#CALL:supertile($5BB0, 0)]
B $5BC0,16,4 super_tile $0C #HTML[#CALL:supertile($5BC0, 0)]
B $5BD0,16,4 super_tile $0D #HTML[#CALL:supertile($5BD0, 0)]
B $5BE0,16,4 super_tile $0E #HTML[#CALL:supertile($5BE0, 0)]
B $5BF0,16,4 super_tile $0F #HTML[#CALL:supertile($5BF0, 0)]
B $5C00,16,4 super_tile $10 #HTML[#CALL:supertile($5C00, 0)]
B $5C10,16,4 super_tile $11 #HTML[#CALL:supertile($5C10, 0)]
B $5C20,16,4 super_tile $12 #HTML[#CALL:supertile($5C20, 0)]
B $5C30,16,4 super_tile $13 #HTML[#CALL:supertile($5C30, 0)]
B $5C40,16,4 super_tile $14 #HTML[#CALL:supertile($5C40, 0)]
B $5C50,16,4 super_tile $15 #HTML[#CALL:supertile($5C50, 0)]
B $5C60,16,4 super_tile $16 #HTML[#CALL:supertile($5C60, 0)]
B $5C70,16,4 super_tile $17 #HTML[#CALL:supertile($5C70, 0)]
B $5C80,16,4 super_tile $18 #HTML[#CALL:supertile($5C80, 0)]
B $5C90,16,4 super_tile $19 #HTML[#CALL:supertile($5C90, 0)]
B $5CA0,16,4 super_tile $1A #HTML[#CALL:supertile($5CA0, 0)]
B $5CB0,16,4 super_tile $1B #HTML[#CALL:supertile($5CB0, 0)]
B $5CC0,16,4 super_tile $1C #HTML[#CALL:supertile($5CC0, 0)]
B $5CD0,16,4 super_tile $1D #HTML[#CALL:supertile($5CD0, 0)]
B $5CE0,16,4 super_tile $1E #HTML[#CALL:supertile($5CE0, 0)]
B $5CF0,16,4 super_tile $1F #HTML[#CALL:supertile($5CF0, 0)]
B $5D00,16,4 super_tile $20 #HTML[#CALL:supertile($5D00, 0)]
B $5D10,16,4 super_tile $21 #HTML[#CALL:supertile($5D10, 0)]
B $5D20,16,4 super_tile $22 #HTML[#CALL:supertile($5D20, 0)]
B $5D30,16,4 super_tile $23 #HTML[#CALL:supertile($5D30, 0)]
B $5D40,16,4 super_tile $24 #HTML[#CALL:supertile($5D40, 0)]
B $5D50,16,4 super_tile $25 #HTML[#CALL:supertile($5D50, 0)]
B $5D60,16,4 super_tile $26 #HTML[#CALL:supertile($5D60, 0)]
B $5D70,16,4 super_tile $27 #HTML[#CALL:supertile($5D70, 0)]
B $5D80,16,4 super_tile $28 #HTML[#CALL:supertile($5D80, 0)]
B $5D90,16,4 super_tile $29 #HTML[#CALL:supertile($5D90, 0)]
B $5DA0,16,4 super_tile $2A #HTML[#CALL:supertile($5DA0, 0)]
B $5DB0,16,4 super_tile $2B #HTML[#CALL:supertile($5DB0, 0)]
B $5DC0,16,4 super_tile $2C #HTML[#CALL:supertile($5DC0, 0)]
B $5DD0,16,4 super_tile $2D #HTML[#CALL:supertile($5DD0, 0)]
B $5DE0,16,4 super_tile $2E #HTML[#CALL:supertile($5DE0, 0)]
B $5DF0,16,4 super_tile $2F #HTML[#CALL:supertile($5DF0, 0)]
B $5E00,16,4 super_tile $30 #HTML[#CALL:supertile($5E00, 0)]
B $5E10,16,4 super_tile $31 #HTML[#CALL:supertile($5E10, 0)]
B $5E20,16,4 super_tile $32 #HTML[#CALL:supertile($5E20, 0)]
B $5E30,16,4 super_tile $33 #HTML[#CALL:supertile($5E30, 0)]
B $5E40,16,4 super_tile $34 #HTML[#CALL:supertile($5E40, 0)]
B $5E50,16,4 super_tile $35 #HTML[#CALL:supertile($5E50, 0)]
B $5E60,16,4 super_tile $36 #HTML[#CALL:supertile($5E60, 0)]
B $5E70,16,4 super_tile $37 #HTML[#CALL:supertile($5E70, 0)]
B $5E80,16,4 super_tile $38 #HTML[#CALL:supertile($5E80, 0)]
B $5E90,16,4 super_tile $39 #HTML[#CALL:supertile($5E90, 0)]
B $5EA0,16,4 super_tile $3A #HTML[#CALL:supertile($5EA0, 0)]
B $5EB0,16,4 super_tile $3B #HTML[#CALL:supertile($5EB0, 0)]
B $5EC0,16,4 super_tile $3C #HTML[#CALL:supertile($5EC0, 0)]
B $5ED0,16,4 super_tile $3D #HTML[#CALL:supertile($5ED0, 0)]
B $5EE0,16,4 super_tile $3E #HTML[#CALL:supertile($5EE0, 0)]
B $5EF0,16,4 super_tile $3F #HTML[#CALL:supertile($5EF0, 0)]
B $5F00,16,4 super_tile $40 #HTML[#CALL:supertile($5F00, 0)]
B $5F10,16,4 super_tile $41 #HTML[#CALL:supertile($5F10, 0)]
B $5F20,16,4 super_tile $42 #HTML[#CALL:supertile($5F20, 0)]
B $5F30,16,4 super_tile $43 #HTML[#CALL:supertile($5F30, 0)]
B $5F40,16,4 super_tile $44 #HTML[#CALL:supertile($5F40, 0)]
B $5F50,16,4 super_tile $45 #HTML[#CALL:supertile($5F50, 0)]
B $5F60,16,4 super_tile $46 #HTML[#CALL:supertile($5F60, 0)]
B $5F70,16,4 super_tile $47 #HTML[#CALL:supertile($5F70, 0)]
B $5F80,16,4 super_tile $48 #HTML[#CALL:supertile($5F80, 0)]
B $5F90,16,4 super_tile $49 #HTML[#CALL:supertile($5F90, 0)]
B $5FA0,16,4 super_tile $4A #HTML[#CALL:supertile($5FA0, 0)]
B $5FB0,16,4 super_tile $4B #HTML[#CALL:supertile($5FB0, 0)]
B $5FC0,16,4 super_tile $4C #HTML[#CALL:supertile($5FC0, 0)]
B $5FD0,16,4 super_tile $4D #HTML[#CALL:supertile($5FD0, 0)]
B $5FE0,16,4 super_tile $4E #HTML[#CALL:supertile($5FE0, 0)]
B $5FF0,16,4 super_tile $4F #HTML[#CALL:supertile($5FF0, 0)] [unused by map]
B $6000,16,4 super_tile $50 #HTML[#CALL:supertile($6000, 0)]
B $6010,16,4 super_tile $51 #HTML[#CALL:supertile($6010, 0)]
B $6020,16,4 super_tile $52 #HTML[#CALL:supertile($6020, 0)]
B $6030,16,4 super_tile $53 #HTML[#CALL:supertile($6030, 0)]
B $6040,16,4 super_tile $54 #HTML[#CALL:supertile($6040, 0)]
B $6050,16,4 super_tile $55 #HTML[#CALL:supertile($6050, 0)]
B $6060,16,4 super_tile $56 #HTML[#CALL:supertile($6060, 0)]
B $6070,16,4 super_tile $57 #HTML[#CALL:supertile($6070, 0)]
B $6080,16,4 super_tile $58 #HTML[#CALL:supertile($6080, 0)]
B $6090,16,4 super_tile $59 #HTML[#CALL:supertile($6090, 0)]
B $60A0,16,4 super_tile $5A #HTML[#CALL:supertile($60A0, 0)]
B $60B0,16,4 super_tile $5B #HTML[#CALL:supertile($60B0, 0)]
B $60C0,16,4 super_tile $5C #HTML[#CALL:supertile($60C0, 0)]
B $60D0,16,4 super_tile $5D #HTML[#CALL:supertile($60D0, 0)]
B $60E0,16,4 super_tile $5E #HTML[#CALL:supertile($60E0, 0)]
B $60F0,16,4 super_tile $5F #HTML[#CALL:supertile($60F0, 0)]
B $6100,16,4 super_tile $60 #HTML[#CALL:supertile($6100, 0)]
B $6110,16,4 super_tile $61 #HTML[#CALL:supertile($6110, 0)]
B $6120,16,4 super_tile $62 #HTML[#CALL:supertile($6120, 0)]
B $6130,16,4 super_tile $63 #HTML[#CALL:supertile($6130, 0)]
B $6140,16,4 super_tile $64 #HTML[#CALL:supertile($6140, 0)]
B $6150,16,4 super_tile $65 #HTML[#CALL:supertile($6150, 0)]
B $6160,16,4 super_tile $66 #HTML[#CALL:supertile($6160, 0)]
B $6170,16,4 super_tile $67 #HTML[#CALL:supertile($6170, 0)]
B $6180,16,4 super_tile $68 #HTML[#CALL:supertile($6180, 0)]
B $6190,16,4 super_tile $69 #HTML[#CALL:supertile($6190, 0)]
B $61A0,16,4 super_tile $6A #HTML[#CALL:supertile($61A0, 0)]
B $61B0,16,4 super_tile $6B #HTML[#CALL:supertile($61B0, 0)]
B $61C0,16,4 super_tile $6C #HTML[#CALL:supertile($61C0, 0)]
B $61D0,16,4 super_tile $6D #HTML[#CALL:supertile($61D0, 0)]
B $61E0,16,4 super_tile $6E #HTML[#CALL:supertile($61E0, 0)]
B $61F0,16,4 super_tile $6F #HTML[#CALL:supertile($61F0, 0)]
B $6200,16,4 super_tile $70 #HTML[#CALL:supertile($6200, 0)]
B $6210,16,4 super_tile $71 #HTML[#CALL:supertile($6210, 0)]
B $6220,16,4 super_tile $72 #HTML[#CALL:supertile($6220, 0)]
B $6230,16,4 super_tile $73 #HTML[#CALL:supertile($6230, 0)]
B $6240,16,4 super_tile $74 #HTML[#CALL:supertile($6240, 0)]
B $6250,16,4 super_tile $75 #HTML[#CALL:supertile($6250, 0)]
B $6260,16,4 super_tile $76 #HTML[#CALL:supertile($6260, 0)]
B $6270,16,4 super_tile $77 #HTML[#CALL:supertile($6270, 0)]
B $6280,16,4 super_tile $78 #HTML[#CALL:supertile($6280, 0)]
B $6290,16,4 super_tile $79 #HTML[#CALL:supertile($6290, 0)]
B $62A0,16,4 super_tile $7A #HTML[#CALL:supertile($62A0, 0)]
B $62B0,16,4 super_tile $7B #HTML[#CALL:supertile($62B0, 0)]
B $62C0,16,4 super_tile $7C #HTML[#CALL:supertile($62C0, 0)]
B $62D0,16,4 super_tile $7D #HTML[#CALL:supertile($62D0, 0)]
B $62E0,16,4 super_tile $7E #HTML[#CALL:supertile($62E0, 0)]
B $62F0,16,4 super_tile $7F #HTML[#CALL:supertile($62F0, 0)]
B $6300,16,4 super_tile $80 #HTML[#CALL:supertile($6300, 0)]
B $6310,16,4 super_tile $81 #HTML[#CALL:supertile($6310, 0)]
B $6320,16,4 super_tile $82 #HTML[#CALL:supertile($6320, 0)]
B $6330,16,4 super_tile $83 #HTML[#CALL:supertile($6330, 0)]
B $6340,16,4 super_tile $84 #HTML[#CALL:supertile($6340, 0)]
B $6350,16,4 super_tile $85 #HTML[#CALL:supertile($6350, 0)]
B $6360,16,4 super_tile $86 #HTML[#CALL:supertile($6360, 0)]
B $6370,16,4 super_tile $87 #HTML[#CALL:supertile($6370, 0)]
B $6380,16,4 super_tile $88 #HTML[#CALL:supertile($6380, 0)]
B $6390,16,4 super_tile $89 #HTML[#CALL:supertile($6390, 0)]
B $63A0,16,4 super_tile $8A #HTML[#CALL:supertile($63A0, 0)]
B $63B0,16,4 super_tile $8B #HTML[#CALL:supertile($63B0, 0)]
B $63C0,16,4 super_tile $8C #HTML[#CALL:supertile($63C0, 0)]
B $63D0,16,4 super_tile $8D #HTML[#CALL:supertile($63D0, 0)]
B $63E0,16,4 super_tile $8E #HTML[#CALL:supertile($63E0, 0)]
B $63F0,16,4 super_tile $8F #HTML[#CALL:supertile($63F0, 0)]
B $6400,16,4 super_tile $90 #HTML[#CALL:supertile($6400, 0)]
B $6410,16,4 super_tile $91 #HTML[#CALL:supertile($6410, 0)]
B $6420,16,4 super_tile $92 #HTML[#CALL:supertile($6420, 0)]
B $6430,16,4 super_tile $93 #HTML[#CALL:supertile($6430, 0)]
B $6440,16,4 super_tile $94 #HTML[#CALL:supertile($6440, 0)]
B $6450,16,4 super_tile $95 #HTML[#CALL:supertile($6450, 0)]
B $6460,16,4 super_tile $96 #HTML[#CALL:supertile($6460, 0)]
B $6470,16,4 super_tile $97 #HTML[#CALL:supertile($6470, 0)]
B $6480,16,4 super_tile $98 #HTML[#CALL:supertile($6480, 0)]
B $6490,16,4 super_tile $99 #HTML[#CALL:supertile($6490, 0)]
B $64A0,16,4 super_tile $9A #HTML[#CALL:supertile($64A0, 0)] [unused by map]
B $64B0,16,4 super_tile $9B #HTML[#CALL:supertile($64B0, 0)]
B $64C0,16,4 super_tile $9C #HTML[#CALL:supertile($64C0, 0)]
B $64D0,16,4 super_tile $9D #HTML[#CALL:supertile($64D0, 0)]
B $64E0,16,4 super_tile $9E #HTML[#CALL:supertile($64E0, 0)]
B $64F0,16,4 super_tile $9F #HTML[#CALL:supertile($64F0, 0)]
B $6500,16,4 super_tile $A0 #HTML[#CALL:supertile($6500, 0)]
B $6510,16,4 super_tile $A1 #HTML[#CALL:supertile($6510, 0)]
B $6520,16,4 super_tile $A2 #HTML[#CALL:supertile($6520, 0)]
B $6530,16,4 super_tile $A3 #HTML[#CALL:supertile($6530, 0)]
B $6540,16,4 super_tile $A4 #HTML[#CALL:supertile($6540, 0)]
B $6550,16,4 super_tile $A5 #HTML[#CALL:supertile($6550, 0)]
B $6560,16,4 super_tile $A6 #HTML[#CALL:supertile($6560, 0)]
B $6570,16,4 super_tile $A7 #HTML[#CALL:supertile($6570, 0)]
B $6580,16,4 super_tile $A8 #HTML[#CALL:supertile($6580, 0)]
B $6590,16,4 super_tile $A9 #HTML[#CALL:supertile($6590, 0)]
B $65A0,16,4 super_tile $AA #HTML[#CALL:supertile($65A0, 0)]
B $65B0,16,4 super_tile $AB #HTML[#CALL:supertile($65B0, 0)]
B $65C0,16,4 super_tile $AC #HTML[#CALL:supertile($65C0, 0)]
B $65D0,16,4 super_tile $AD #HTML[#CALL:supertile($65D0, 0)]
B $65E0,16,4 super_tile $AE #HTML[#CALL:supertile($65E0, 0)]
B $65F0,16,4 super_tile $AF #HTML[#CALL:supertile($65F0, 0)]
B $6600,16,4 super_tile $B0 #HTML[#CALL:supertile($6600, 0)]
B $6610,16,4 super_tile $B1 #HTML[#CALL:supertile($6610, 0)]
B $6620,16,4 super_tile $B2 #HTML[#CALL:supertile($6620, 0)]
B $6630,16,4 super_tile $B3 #HTML[#CALL:supertile($6630, 0)]
B $6640,16,4 super_tile $B4 #HTML[#CALL:supertile($6640, 0)]
B $6650,16,4 super_tile $B5 #HTML[#CALL:supertile($6650, 0)]
B $6660,16,4 super_tile $B6 #HTML[#CALL:supertile($6660, 0)]
B $6670,16,4 super_tile $B7 #HTML[#CALL:supertile($6670, 0)]
B $6680,16,4 super_tile $B8 #HTML[#CALL:supertile($6680, 0)]
B $6690,16,4 super_tile $B9 #HTML[#CALL:supertile($6690, 0)]
B $66A0,16,4 super_tile $BA #HTML[#CALL:supertile($66A0, 0)]
B $66B0,16,4 super_tile $BB #HTML[#CALL:supertile($66B0, 0)]
B $66C0,16,4 super_tile $BC #HTML[#CALL:supertile($66C0, 0)]
B $66D0,16,4 super_tile $BD #HTML[#CALL:supertile($66D0, 0)]
B $66E0,16,4 super_tile $BE #HTML[#CALL:supertile($66E0, 0)]
B $66F0,16,4 super_tile $BF #HTML[#CALL:supertile($66F0, 0)]
B $6700,16,4 super_tile $C0 #HTML[#CALL:supertile($6700, 0)]
B $6710,16,4 super_tile $C1 #HTML[#CALL:supertile($6710, 0)]
B $6720,16,4 super_tile $C2 #HTML[#CALL:supertile($6720, 0)]
B $6730,16,4 super_tile $C3 #HTML[#CALL:supertile($6730, 0)]
B $6740,16,4 super_tile $C4 #HTML[#CALL:supertile($6740, 0)]
B $6750,16,4 super_tile $C5 #HTML[#CALL:supertile($6750, 0)]
B $6760,16,4 super_tile $C6 #HTML[#CALL:supertile($6760, 0)]
B $6770,16,4 super_tile $C7 #HTML[#CALL:supertile($6770, 0)]
B $6780,16,4 super_tile $C8 #HTML[#CALL:supertile($6780, 0)]
B $6790,16,4 super_tile $C9 #HTML[#CALL:supertile($6790, 0)]
B $67A0,16,4 super_tile $CA #HTML[#CALL:supertile($67A0, 0)]
B $67B0,16,4 super_tile $CB #HTML[#CALL:supertile($67B0, 0)]
B $67C0,16,4 super_tile $CC #HTML[#CALL:supertile($67C0, 0)]
B $67D0,16,4 super_tile $CD #HTML[#CALL:supertile($67D0, 0)]
B $67E0,16,4 super_tile $CE #HTML[#CALL:supertile($67E0, 0)]
B $67F0,16,4 super_tile $CF #HTML[#CALL:supertile($67F0, 0)]
B $6800,16,4 super_tile $D0 #HTML[#CALL:supertile($6800, 0)]
B $6810,16,4 super_tile $D1 #HTML[#CALL:supertile($6810, 0)]
B $6820,16,4 super_tile $D2 #HTML[#CALL:supertile($6820, 0)]
B $6830,16,4 super_tile $D3 #HTML[#CALL:supertile($6830, 0)]
B $6840,16,4 super_tile $D4 #HTML[#CALL:supertile($6840, 0)]
B $6850,16,4 super_tile $D5 #HTML[#CALL:supertile($6850, 0)]
B $6860,16,4 super_tile $D6 #HTML[#CALL:supertile($6860, 0)]
B $6870,16,4 super_tile $D7 #HTML[#CALL:supertile($6870, 0)]
B $6880,16,4 super_tile $D8 #HTML[#CALL:supertile($6880, 0)]
B $6890,16,4 super_tile $D9 #HTML[#CALL:supertile($6890, 0)]
;
g $68A0 The current room index.
D $68A0 This holds the index of the room that the hero is presently in, or 0 when he's outside.
D $68A0 The possible room numbers are as follows:
D $68A0 #TABLE(default) { =h Room | =h Description | =h Movable Object | =h Items } { 0 | Outdoors / exterior / main map | - | Green key } { 1 | Lowest hut, right hand side | - | Poison } { 2 | Middle hut, left hand side (Hero's start room) | - | Stove } { 3 | Middle hut, right hand side | - | - } { 4 | Highest hut, left hand side | - | - } { 5 | Highest hut, right hand side | - | - } { 6 | (unused index) | - | - } { 7 | Corridor | - | - } { 8 | Corridor | - | - } { 9 | "Crate" | Crate | Shovel } { 10 | "Lockpick" | - | Lockpick } { 11 | Commandant's office | - | Papers } { 12 | Corridor | - | - } { 13 | Corridor | - | - } { 14 | Guard’s quarters 1 | - | Torch } { 15 | Guard’s quarters 2 | - | Uniform, Yellow key } { 16 | Corridor | - | - } { 17 | Corridor | - | - } { 18 | “Radio” | - | Radio } { 19 | “Food” | - | Food } { 20 | "Red Cross parcel" | - | From parcel: Purse, Wire snips, Bribe, Compass } { 21 | Corridor | - | - } { 22 | Corridor to solitary | - | Red key } { 23 | Mess hall, right room | - | - } { 24 | Solitary confinement | - | - } { 25 | Mess hall, left room | - | - } { 26 | (unused index) | - | - } { 27 | (unused index) | - | - } { 28 | Lowest hut, left hand side | Stove | - } { 29 | Tunnel 2, start of | - | - } { 30 | Tunnel 2 | - | - } { 31 | Tunnel 2 | - | - } { 32 | Tunnel 2 | - | - } { 33 | Tunnel 2 | - | - } { 34 | Tunnel 2, end of | - | - } { 35 | Tunnel 2 | - | - } { 36 | Tunnel 2 | - | - } { 37 | Tunnel 1, start of | - | - } { 38 | Tunnel 1 | - | - } { 39 | Tunnel 1 | - | - } { 40 | Tunnel 1 | - | - } { 41 | Tunnel 1 | - | - } { 42 | Tunnel 1 | - | - } { 43 | Tunnel 1 | - | - } { 44 | Tunnel 1 | - | - } { 45 | Tunnel 1 | - | - } { 46 | Tunnel 1 | - | - } { 47 | Tunnel 1 | - | - } { 48 | Tunnel 1, end of | - | - } { 49 | Tunnel 1 | - | - } { 50 | Tunnel 1 (initially blocked) | - | - } { 51 | Tunnel 2 | - | - } { 52 | Tunnel 2 | - | - } TABLE#
@ $68A0 label=room_index
B $68A0,1,1
;
g $68A1 The current door id.
D $68A1 Used by the routines at #R$B1D4, #R$B1F5, #R$B32D and #R$CB98.
D $68A1 Bit 7 is the door_REVERSE flag.
@ $68A1 label=current_door
B $68A1,1,1
;
c $68A2 Transition from room to room, or to a new part of the map.
D $68A2 This is called when a visible character (a vischar, pointed to by #REGiy) needs to change room, or to change position on the exterior map, e.g. when the hero moves outside of the main gate.
D $68A2 vischar.room is expected to already be set to the new room index. If the character is outdoors we take the given map position, (a tinypos, pointed to by #REGhl) scale it up, multiplying the values by 4, then store those as vischar.mi.mappos. Otherwise we just copy them across without scaling.
D $68A2 If the current vischar is not the hero then we reset the character. Otherwise we're handling the hero so we either reset the visible scene for outdoors, or for the new room.
D $68A2 Used by the routines at #R$B1F5, #R$B32D, #R$CA81, #R$CB98 and #R$EFCB.
R $68A2 I:HL Pointer to map position (type: tinypos_t).
R $68A2 I:IY Pointer to current visible character.
@ $68A2 label=transition
C $68A2,1 Save position into #REGde
C $68A3,3 Copy the current visible character pointer into #REGhl
C $68A6,1 Extract the visible character's index/offset
C $68A7,1 Save it for later
C $68A8,3 Point #REGhl at the visible character's position
C $68AB,3 Fetch the visible character's current room index
C $68AE,1 Are we outdoors?
C $68AF,3 Jump if not
N $68B2 We're outdoors.
N $68B2 Set position on X, Y axis and height by multiplying by 4.
C $68B2,2 Iterate thrice: X, Y and height fields
C $68B4,1 Save #REGbc - #R$B295's output register
C $68B5,1 Fetch a position byte
C $68B6,3 Multiply it by 4, widening it to a word in #REGbc
C $68B9,5 Store it to visible character's position and increment pointers
C $68BE,1 Restore
C $68BF,2 Loop
C $68C1,2 Jump over indoors case
N $68C3 We're indoors.
N $68C3 Set position on X, Y axis and height by copying.
C $68C3,2 Iterate thrice: X, Y and height fields
C $68C5,7 Widen position bytes to words, store and increment pointers
C $68CC,2 Loop
C $68CE,1 Retrieve vischar index/offset stacked at $68A7
C $68D0,1 Is it the hero?
C $68D1,3 Jump if so
N $68D4 Not the hero.
N $68D4 Commentary: This is an unusual construct. Why did the author not use JP NZ,$C5D3 above and fallthrough otherwise?
C $68D4,3 If not, exit via #R$C5D3 resetting the visible character
N $68D7 Hero only.
N $68D7 #REGhl points to the hero's visible character at this point.
C $68D7,1 Point #REGhl at the visible character's flags field (always $8001)
C $68D8,2 Clear vischar_FLAGS_NO_COLLIDE in flags
C $68DA,3 Get the visible character's room index
C $68DD,3 Set the global current room index
C $68E0,1 Are we outdoors?
C $68E1,3 Jump if not
N $68E4 We're outdoors.
C $68E4,4 Point #REGhl at the visible character's input field (always $800D)
C $68E8,2 Set input to input_KICK
C $68EA,1 Point #REGhl at the visible character's direction field (always $800E)
C $68EB,4 Fetch the direction field and clear the non-direction bits, resetting the crawl flag
C $68EF,3 Reset the hero's position, redraw the scene then zoombox it onto the screen
C $68F2,2 Restart from main loop
;
c $68F4 The hero enters a room.
D $68F4 This is called when the hero should enter a room. It resets the game window position, expands out the room definition into tile references then plots those tiles, centres the map position, sets an appropriate sprite for the hero (walk or crawl), sets up movable items then zoomboxes the scenes onto the screen and boosts the score by one. Finally it squashes the stack and jumps to the main loop.
D $68F4 Used by the routines at #R$68A2, #R$9D78, #R$9DE5 and #R$B75A.
@ $68F4 label=enter_room
C $68F4,6 Reset the game_window_offset X and Y coordinates to zero
C $68FA,3 Setup the room
C $68FD,3 Render visible tiles array into the screen buffer
C $6900,6 Set the map_position to (116,234)
C $6906,3 Set appropriate sprite for the room (standing or crawl)
C $6909,6 Reset the hero's screen position
C $690F,3 Setup movable items
C $6912,3 Zoombox the scene onto the screen
C $6915,5 Increment score by one
E $68F4 FALL THROUGH into squash_stack_goto_main.
;
c $691A Squash the stack then jump into the game's main loop.
D $691A This is called by transition or enter_room to restart the game's main loop, after they have performed a scene change.
D $691A Used by the routines at #R$68A2 and #R$68F4 (a fall through).
@ $691A label=squash_stack_goto_main
C $691A,3 Set stack to the very top of RAM
C $691D,3 Jump to the start of the game's main loop
;
c $6920 Set appropriate hero sprite for room.
D $6920 This is called by enter_room to select an appropriate hero sprite for the current room. This forces the use of the prisoner sprite set with the crawl flag enabled, when the hero is in a tunnel room.
D $6920 This routine doesn't remember your uniform state, so if you enter a tunnel while wearing the guards' uniform you will find it removed on exit from the tunnel.
D $6920 Used by the routine at #R$68F4.
@ $6920 label=set_hero_sprite_for_room
@ $6920 nowarn
C $6920,5 Set the hero's visible character input field to input_KICK
C $6925,1 Point #REGhl at vischar.direction ($800E)
N $6926 vischar_DIRECTION_CRAWL is set, or cleared, here but not tested directly anywhere else so it must be an offset into animindices[].
N $6926 When in tunnel rooms force the hero sprite to 'prisoner' and set the crawl flag appropriately.
C $6926,7 If the global current room index is room_29_SECOND_TUNNEL_START or above...
N $692D We're in a tunnel room.
C $692D,2 Set the vischar_DIRECTION_CRAWL bit on vischar.direction
C $692F,6 Set vischar.mi.sprite to the prisoner sprite set
C $6935,1 Return
N $6936 We're not in a tunnel room.
C $6936,2 Clear the vischar_DIRECTION_CRAWL bit from vischar.direction
C $6938,1 Return
;
c $6939 Setup movable items.
D $6939 "Movable items" are the stoves and the crate which appear in three rooms in the game. Unlike ordinary items such as keys and the radio the movable items can be pushed around by the hero character walking into them. Internally they use the second visible character slot.
D $6939 Used by the routines at #R$68F4 and #R$B2FC.
@ $6939 label=setup_movable_items
C $6939,3 Reset all non-player visible characters
C $693C,3 Get the global current room index
C $693F,10 If current room index is room_2_HUT2LEFT then jump to setup_stove1
C $6949,10 If current room index is room_4_HUT3LEFT then jump to setup_stove2
C $6953,8 If current room index is room_9_CRATE then jump to setup_crate
C $695B,3 Spawn characters
C $695E,3 Mark nearby items
C $6961,3 Animate all visible characters
C $6964,3 Move the map
C $6967,3 Plot vischars and items
@ $696A label=setup_crate
C $696A,3 Point #REGhl at movable_item_crate
C $696D,2 Set #REGa to character index character_28_CRATE
C $696F,2 Jump to setup_movable_item
@ $6971 label=setup_stove2
C $6971,3 Point #REGhl at movable_item_stove2
C $6974,2 Set #REGa to character index character_27_STOVE_2
C $6976,2 Jump to setup_movable_item
@ $6978 label=setup_stove1
C $6978,3 Point #REGhl at movable_item_stove1
C $697B,2 Set #REGa to character index character_26_STOVE_1
N $697D Using the movable item specific data and a generic item reset data, setup the second visible character as a movable item.
@ $697D label=setup_movable_item
@ $697D nowarn
C $697D,3 Assign the character index in #REGa to the second visible character's character field
C $6980,8 Copy nine bytes of item-specific movable item data over the second visible character data
@ $6988 nowarn
C $6988,11 Copy fourteen bytes of visible character data over the vischar
C $6993,6 Set the visible character's room index to the global current room index
@ $6999 nowarn
C $6999,3 Point #REGhl at the second visible character
C $699C,3 Set saved_pos
C $699F,1 Return
N $69A0 Fourteen bytes of visible character reset data.
@ $69A0 label=movable_item_reset_data
B $69A0,1,1 Flags
W $69A1,2,2 Route
B $69A3,3,3 Position
B $69A6,1,1 Counter and flags
W $69A7,2,2 Animation base = &animations[0]
W $69A9,2,2 Animation      = animations[8] // anim_wait_tl animation
B $69AB,1,1 Animation index
B $69AC,1,1 Input
B $69AD,1,1 Direction
N $69AE Movable items. struct movable_item { word x_coord, y_coord, height; const sprite *; byte index; };
N $69AE Sub-struct of vischar ($802F..$8038).
@ $69AE label=movable_item_stove1
W $69AE,6,6 Position (62, 35, 16)
W $69B4,2,2 Sprite: sprite_stove
B $69B6,1,1 Index: 0
@ $69B7 label=movable_item_crate
W $69B7,6,6 Position (55, 54, 14)
W $69BD,2,2 Sprite: sprite_crate
B $69BF,1,1 Index: 0
@ $69C0 label=movable_item_stove2
W $69C0,6,6 Position (62, 35, 16)
W $69C6,2,2 Sprite: sprite_stove
B $69C8,1,1 Index: 0
;
c $69C9 Reset non-player visible characters.
D $69C9 This is called by setup_movable_items to reset all seven non-player visible characters.
D $69C9 Used by the routine at #R$6939 only.
@ $69C9 label=reset_nonplayer_visible_characters
@ $69C9 nowarn
C $69C9,3 Start at the second visible character
C $69CC,3 Set #REGb for seven iterations and set #REGc for a 32 byte stride simultaneously
N $69CF Start loop
C $69CF,7 Reset the visible character at #REGhl
C $69D6,3 Step #REGhl to the next visible character
C $69D9,2 ...loop
C $69DB,1 Return
;
c $69DC Setup interior doors.
D $69DC This is called by setup_room to setup the #R$81D6 array. It walks through the #R$78D6 array, extracting the indices of doors relevant to the current room and stores those indices into #R$81D6.
D $69DC Used by the routine at #R$6A35 only.
N $69DC Clear the interior_doors[] array with door_NONE ($FF).
@ $69DC label=setup_doors
C $69DC,2 Set #REGa to door_NONE
C $69DE,3 Set #REGde to the final byte of interior_doors[] (byte 4)
C $69E1,6 Set all four bytes to door_NONE
N $69E7 Setup to populate interior_doors[].
C $69E7,1 Set #REGde to the first interior_doors[] byte
C $69E8,6 Fetch and shift the global current room index up by two bits, to match door_flags, then store it in #REGb
C $69EE,2 Initialise the door index
C $69F0,1 Switch register banks for the iteration
N $69F1 We're about to walk through doors[] and extract the indices of the doors relevant to the current room.
C $69F1,3 Point #REGhl' to the first byte of doors[]
C $69F4,2 Set #REGb' to the number of entries in doors[] (124)
C $69F6,3 Set #REGde' to the stride of four bytes (each door is a room_and_direction byte followed by a 3-byte position)
N $69F9 Start loop
N $69F9 Save any door index which matches the current room.
C $69F9,1 Fetch door's room_and_direction
C $69FA,1 Switch registers back to the set used on entry to the routine
C $69FB,2 Clear room_and_direction's direction bits (door_FLAGS_MASK_DIRECTION)
C $69FD,1 Is it the current room?
C $69FE,2 Jump if not
N $6A00 This is the current room.
C $6A00,5 Write to #REGde register #REGc toggled with door_REVERSE
C $6A05,3 Toggle door_REVERSE in #REGc for the next iteration
C $6A08,3 Jump if (#REGc >= door_REVERSE)
C $6A0B,2 Increment the door index once every two steps through the array
C $6A0D,1 Switch registers again
C $6A0E,1 Step #REGhl' to the next door
C $6A0F,2 ...loop
C $6A11,1 Return
;
c $6A12 Turn a door index into a door_t pointer.
D $6A12 This is called by a few routines to turn a door index into a pointer to a door structure (a door_t). The doors[] array contains pairs of door structures. If the door_REVERSE flag is set in bit 7, the first of the pair is returned, otherwise the second is.
D $6A12 Used by the routines at #R$B32D, #R$B4D0, #R$C651 and #R$CA81.
R $6A12 I:A Index of door + door_REVERSE flag in bit 7.
R $6A12 O:HL Pointer to door_t.
@ $6A12 label=get_door
C $6A12,1 Save the original #REGa so we can test its flag bit in a moment
C $6A13,1 First double #REGa since doors[] contains pairs of doors. This also discards the door_REVERSE flag in bit 7
C $6A14,9 Form the address of doors[#REGa] in #REGhl
C $6A1D,2 Was the door_REVERSE flag (bit 7) set on entry?
C $6A1F,1 If not, return with #REGhl pointing to the entry
C $6A20,6 Otherwise, point to the next entry along
C $6A26,1 Return
;
c $6A27 Wipe the visible tiles array.
D $6A27 The visible tiles array is a 24x17 grid of tile references. The game uses it to render room interiors and the exterior map. This routine clears all of the tiles all to zero.
D $6A27 Used by the routines at #R$6A35, #R$A50B and #R$AB6B.
@ $6A27 label=wipe_visible_tiles
C $6A27,13 Set all RAM from $F0F8 to $F0F8 + 24 * 17 - 1 to zero
C $6A34,1 Return
;
c $6A35 Expand out the room definition for room_index.
D $6A35 This first wipes the visible tiles array then sets up interior doors, gets the room definition pointer then uses that to setup boundaries, set up interior masks and finally plot all objects into the visible tile array.
D $6A35 Used by the routines at #R$68F4, #R$7B36, #R$9E07, #R$A289, #R$A2E2, #R$A479 and #R$B3F6.
@ $6A35 label=setup_room
C $6A35,3 Wipe the visible tiles array
N $6A38 Form the address of rooms_and_tunnels[room_index - 1] in #REGhl.
C $6A38,3 Fetch the global current room index
C $6A3B,1 Double it so we can index rooms_and_tunnels[]
@ $6A3C isub=LD HL,rooms_and_tunnels - 2
C $6A3C,3 Point #REGhl at #R$6BAD rooms_and_tunnels[-1]
C $6A3F,5 #REGhl + #REGa
C $6A44,4 Fetch room pointer in #REGhl
C $6A48,1 Push it
C $6A49,3 Setup interior doors
C $6A4C,1 Pop it
N $6A4D Copy the count of boundaries into state.
C $6A4D,3 Point #REGde at #R$81BE roomdef_bounds_index
C $6A50,2 Copy first byte of roomdef into roomdef_bounds_index. (#REGde, #REGhl incremented).
N $6A52 #REGde now points to #R$81BF
N $6A52 Copy all boundary structures into state, if any.
C $6A52,1 Fetch count of boundaries
C $6A53,1 Is it zero?
C $6A54,1 Store it irrespectively
C $6A55,2 No, jump to copying step
C $6A57,1 Skip roomdef count of boundaries
C $6A58,2 Jump to mask copying
C $6A5A,3 Multiply #REGa by four (size of boundary structures) then add one (skip current counter) == size of boundary structures
C $6A5D,5 Copy all boundary structures
N $6A62 Copy interior mask into interior_mask_data.
C $6A62,3 Point #REGde at interior_mask_data
C $6A65,1 Get count of interior masks
C $6A66,1 Step
C $6A67,1 Write it out
C $6A68,1 Is the count non-zero?
C $6A69,2 Jump if not
C $6A6B,1 Skip over the written count
C $6A6C,1 #REGb is our loop counter
N $6A6D Start loop
N $6A6D interior_mask_data holds indices into interior_mask_data_source[].
C $6A6F,3 Fetch an index (from roomdef?)
C $6A72,2 #REGbc = #REGhl
C $6A74,3 Multiply it by eight
C $6A77,1 Clear the carry flag
C $6A78,2 Final offset is index * 7
C $6A7A,3 Point at interior_mask_data_source
C $6A7D,1 Form the address of the mask data
C $6A7E,3 Width of mask data
C $6A81,2 Copy it
C $6A83,4 Constant final byte is always 32
C $6A8A,2 ...loop
N $6A8C Plot all objects (as tiles).
C $6A8C,1 Count of objects
C $6A8E,1 Is it zero?
C $6A8F,1 Return if so
C $6A90,1 Skip the count
N $6A91 Start loop: for every object in the roomdef
C $6A92,1 Fetch the object index
C $6A94,1 Fetch the column
N $6A98 Plot the object into the visible tiles array
C $6A98,19 #REGde = $F0F8 + row * 24 + column.
C $6AAC,3 Expand RLE-encoded object out to a set of tile references
C $6AB2,2 ...loop
C $6AB4,1 Return
;
c $6AB5 Expands RLE-encoded objects to a full set of tile references.
D $6AB5 This is only ever called by setup_room. It expands the run length encoded object with the given index into indices in the visible tile array.
D $6AB5 Objects have the following format:
D $6AB5 #TABLE(default) { =c2 Each object starts with two bytes which specify its dimensions: } { <w> <h> | Width in tiles, Height in tiles } { =c2 Which are then followed by a repetition of the following bytes: } { <t> | Literal: Emit a single tile <t> } { <$FF> <$FF> | Escape: Emit a single tile $FF } { <$FF> <c=128..254> <t> | Repetition: Emit tile <t> count (<c> AND 127) times } { <$FF> <c=64..79> <t> | Ascending range: Emit tile <t> then <t+1> then <t+2> and so on, up to <t+(c AND 15)> } { <$FF> <other> | Other encodings are not used } TABLE#
D $6AB5 Tile references of zero produce no output.
D $6AB5 Used by the routine at #R$6A35.
R $6AB5 I:A Object index.
R $6AB5 I:DE Tile array location to expand to.
@ $6AB5 label=expand_object
C $6AB5,12 Fetch the object pointer from #R$7095[A] into #REGhl
C $6AC1,2 Fetch the object's width (in tiles)
C $6AC3,2 Fetch the object's height (in tiles)
@ $6AC6 isub=LD (end_of_row + 1),A
C $6AC5,4 Self modify the "LD B,$xx" at #R$6AE6 to load the tile-width into #REGb
N $6AC9 Start main expand loop
@ $6AC9 label=expand
C $6AC9,1 Fetch the next byte
C $6ACA,2 Is it an escape byte? (interiorobjecttile_ESCAPE/$FF)
C $6ACC,2 Jump if not
N $6ACE Handle an escape byte - indicating an encoded sequence
C $6ACE,1 Step over the escape byte
C $6ACF,1 Fetch the next byte
C $6AD0,2 Is it also an escape byte?
C $6AD2,2 Jump to tile write op if so - we'll emit $FF (Note: Could jump two instructions later)
C $6AD4,2 Isolate the top nibble - the top two bits are flags (Note: This could move down to before the $40 test without affecting anything)
C $6AD6,2 Is it >= 128?
C $6AD8,2 Jump to repetition handling if so
C $6ADA,2 Is it == 64?
C $6ADC,2 Jump to range handling if so
@ $6ADE label=write_tile
C $6ADE,4 Write out the tile if it's non-zero
C $6AE2,1 Move to next input byte
C $6AE3,1 Move to next output byte
C $6AE4,2 ...loop while width counter #REGb is non-zero
@ $6AE6 label=end_of_row
C $6AE6,2 Reset width counter. Self modified by #R$6AC5
C $6AE8,2 Width of tile buffer is 24
C $6AEA,1 Tile buffer width minus width of object gives the rowskip
C $6AEB,5 Add #REGa to #REGde to move by rowskip
C $6AF0,1 Decrement row counter
C $6AF1,2 ...loop to expand while row > 0
C $6AF3,1 Return
N $6AF4 Escape + 128..255 case: emit a repetition of the same byte
@ $6AF4 label=repetition
C $6AF4,1 Fetch flags+count byte
C $6AF5,2 Mask off top bit to get repetition counter/length
C $6AF7,1 Bank repetition counter
C $6AF8,1 Move to the next tile value
C $6AF9,1 Fetch a tile value
C $6AFA,1 Unbank repetition counter ready for the next bank
N $6AFB Start of repetition loop
@ $6AFB label=repetition_loop
C $6AFB,1 Bank the repetition counter
C $6AFC,1 Is the tile value zero?
C $6AFD,2 Jump if so, avoiding the write
C $6AFF,1 Write it
C $6B00,1 Move to next tile output byte
C $6B01,2 Decrement the width counter. Jump over the end-of-row code to #R$6B12 if it's non-zero
N $6B03 Ran out of width / end of row
@ $6B03 isub=LD A,(end_of_row + 1)
C $6B03,3 Fetch width (from self modified instruction) into #REGa'
C $6B06,1 Reset width counter
C $6B07,2 Width of tile buffer is 24
C $6B09,1 Tile buffer width minus width of object gives the rowskip
C $6B0A,5 Add #REGa to #REGde to move by rowskip
C $6B0F,1 Fetch the next tile value (reload)
C $6B10,1 Decrement the row counter
C $6B11,1 Return if it hit zero
@ $6B12 label=repetition_end
C $6B12,1 Unbank the repetition counter
C $6B13,1 Decrement the repetition counter
C $6B14,2 ...loop if non-zero
C $6B16,1 Advance the data pointer
C $6B17,2 Jump to main expand loop
N $6B19 Escape + 64..79 case: emit an ascending range of bytes
N $6B19 Trivial bug: This self-modifies the INC A at #R$6B28 at the end of the loop body, but nothing else in the code modifies it! Possible evidence that other encodings (e.g. 'DEC A') were attempted.
@ $6B19 label=range
@ $6B1B nowarn
C $6B19,5 Make the instruction at #R$6B28 an 'INC A'
C $6B1E,1 Fetch flags+count byte
C $6B1F,2 Mask off the bottom nibble which contains the range counter
C $6B21,1 Bank the range counter
C $6B22,1 Move to the first tile value
C $6B23,1 Get the first tile value
C $6B24,1 Unbank the range counter ready for the next bank
N $6B25 Start of range loop
@ $6B25 label=range_loop
C $6B25,1 Bank the range counter
C $6B26,1 Write the tile value (Note: We assume it's non-zero)
C $6B27,1 Move to the next tile output byte
@ $6B28 label=expand_object_increment
C $6B28,1 Increment the tile value. Self modified by #R$6B1B
C $6B29,2 Decrement width counter. Jump over the end-of-row code to #R$6B3B if it's non-zero
N $6B2B Ran out of width / end of row
C $6B2B,1 Stash the tile value
@ $6B2C isub=LD A,(reset_width + 1)
C $6B2C,3 Fetch width (from self modified instruction) into #REGa'
C $6B2F,1 Reset width counter
C $6B30,2 Width of tile buffer is 24
C $6B32,1 Tile buffer width minus width of object gives the rowskip
C $6B33,5 Add #REGa to #REGde to move by rowskip
C $6B38,1 Unstash the tile value
C $6B39,1 Decrement row counter
C $6B3A,1 Return if it hit zero
@ $6B3B label=range_end
C $6B3B,1 Unbank the range counter
C $6B3C,1 Decrement the range counter
C $6B3D,2 ...loop if non-zero
C $6B3F,1 Advance the data pointer
C $6B40,2 Jump to main expand loop
;
c $6B42 Render visible tiles array into the screen buffer.
D $6B42 This routine expands all of the tile indices in the visible tiles array to the screen buffer. It's only ever used when drawing interior scenes (rooms).
D $6B42 Used by the routines at #R$68F4, #R$7B36, #R$9E07, #R$A289, #R$A2E2, #R$A479, #R$A50B, #R$AB6B and #R$B3F6.
@ $6B42 label=plot_interior_tiles
C $6B42,3 Point #REGhl at the screen buffer's start address
C $6B45,3 Point #REGde at the visible tiles array
C $6B48,2 Set row counter to 16
N $6B4A For every row
@ $6B4A label=row_loop
C $6B4A,2 Set column counter to 24
N $6B4C For every column
@ $6B4C label=column_loop
C $6B4C,1 Stack screen buffer pointer while we form a tile pointer
C $6B4D,1 Load a tile index
C $6B4E,1 Bank outer registers
C $6B4F,10 Point #REGhl at interior_tiles[tile index]
C $6B59,1 Unstack screen buffer pointer
C $6B5A,3 Simultaneously set #REGb for eight iterations and #REGc for a 24 byte stride
@ $6B5D label=tile_loop
C $6B5D,2 Transfer a byte (a row) of tile across
C $6B5F,7 Advance the screen buffer pointer by the stride
C $6B66,2 ...loop for each byte of the tile
N $6B68 End of column
C $6B68,1 Unbank outer registers
C $6B69,1 Move to next input tile
C $6B6A,1 Move to next screen buffer output
C $6B6B,2 ...loop for each column
N $6B6D End of row
C $6B6D,7 Move to the next screen buffer row (seven rows down)
C $6B74,4 ...loop for each row
N $6B78 End
C $6B78,1 Return
;
w $6B79 Table of pointers to prisoner bed objects in room definition data.
D $6B79 This is an array of six pointers to room definition bed objects. These are the beds of the active prisoners (characters 20 to 25).
D $6B79 Note that the topmost hut does not feature in this list. It has three prisoners permanently in bed and one permanently empty bed.
@ $6B79 label=beds
W $6B79,2,2 roomdef_3_hut2_right byte 29. The rightmost bed in hut 2 right. This is used by route 7.
W $6B7B,2,2 roomdef_3_hut2_right byte 32. The middle bed in hut 2 right. This is used by route 8.
W $6B7D,2,2 roomdef_3_hut2_right byte 35. The leftmost bed in hut 2 right. This is used by route 9.
W $6B7F,2,2 roomdef_5_hut3_right byte 29. The rightmost in hut 3 right. This is used by route 10.
W $6B81,2,2 roomdef_5_hut3_right byte 32. The middle in hut 3 right. This is used by route 11.
W $6B83,2,2 roomdef_5_hut3_right byte 35. The leftmost in hut 3 right. This is used by route 12.
;
b $6B85 Room dimensions.
D $6B85 The room definitions specify their dimensions via an index into this table. Note that it looks like a bounds_t but has a different order.
D $6B85 #TABLE(default) { =h Type | =h Bytes | =h Name | =h Meaning } { Byte    |        1 |      x1 | Maximum x  } { Byte    |        1 |      x0 | Minimum x  } { Byte    |        1 |      y1 | Maximum y  } { Byte    |        1 |      y0 | Minimum y  } TABLE#
D $6B85 Used by #R$B29F only.
@ $6B85 label=roomdef_dimensions
B $6B85,4,4 ( 66, 26,  70, 22)
B $6B89,4,4 ( 62, 22,  58, 26)
B $6B8D,4,4 ( 54, 30,  66, 18)
B $6B91,4,4 ( 62, 30,  58, 34)
B $6B95,4,4 ( 74, 18,  62, 30)
B $6B99,4,4 ( 56, 50, 100, 10)
B $6B9D,4,4 (104,  6,  56, 50)
B $6BA1,4,4 ( 56, 50, 100, 26)
B $6BA5,4,4 (104, 28,  56, 50)
B $6BA9,4,4 ( 56, 50,  88, 10)
;
w $6BAD Array of pointers to room and tunnel definitions.
D $6BAD Room definition format:
D $6BAD #TABLE(default) { =h Byte             | =h Meaning } { <rd>                | Room dimensions - indirect via #R$6B85 } { <nb>                | Number of boundaries in the room (rectangles where characters can't walk) } { =c2 Followed by an array of those boundaries: } { <x0> <y0> <x1> <y1> | A boundary } { =c2 Then: } { <nm>                | Number of mask indices used in the room (indexes #R$EA7C) } { =c2 Followed by an array of those mask bytes: } { <mb>                | Mask byte } { =c2 Then: } { <no>                | Number of objects in the room } { =c2 Followed by an array of those objects: } { <io> <x> <y>        | Interior object ref, x, y } TABLE#
D $6BAD Note: The first entry is room 1, not room 0.
@ $6BAD label=rooms_and_tunnels
W $6BAD,2,2 Room 1
W $6BAF,8,2
W $6BB7,2,2 Room 6 is unused
W $6BB9,20,2
W $6BCD,2,2 Room 17 uses the same definition as room 7
W $6BCF,6,2
W $6BD5,2,2 Room 21 uses the same definition as room 16
W $6BD7,8,2
W $6BDF,2,2 Room 26 is unused
W $6BE1,2,2 Room 27 is unused
W $6BE3,2,2
N $6BE5 Array of pointers to tunnels.
W $6BE5,8,2
W $6BED,2,2 Room 33 uses the same definition as room 29
W $6BEF,6,2
W $6BF5,2,2 Room 37 uses the same definition as room 34
W $6BF7,2,2 Room 38 uses the same definition as room 35
W $6BF9,2,2 Room 39 uses the same definition as room 32
W $6BFB,2,2
W $6BFD,2,2 Room 41 uses the same definition as room 30
W $6BFF,2,2 Room 42 uses the same definition as room 32
W $6C01,2,2 Room 43 uses the same definition as room 29
W $6C03,2,2
W $6C05,2,2 Room 45 uses the same definition as room 36
W $6C07,2,2 Room 46 uses the same definition as room 36
W $6C09,2,2 Room 47 uses the same definition as room 32
W $6C0B,2,2 Room 48 uses the same definition as room 34
W $6C0D,2,2 Room 49 uses the same definition as room 36
W $6C0F,2,2
W $6C11,2,2 Room 51 uses the same definition as room 32
W $6C13,2,2 Room 52 uses the same definition as room 40
;
b $6C15 Room 1: Hut 1, far side.
@ $6C15 label=roomdef_1_hut1_right
B $6C15,1,1 0 -- Room dimensions index
B $6C16,1,1 3 -- Number of boundaries
B $6C17,4,4 { 54, 68, 23, 34 } -- Boundary
B $6C1B,4,4 { 54, 68, 39, 50 } -- Boundary
B $6C1F,4,4 { 54, 68, 55, 68 } -- Boundary
B $6C23,1,1 4 -- Number of mask bytes
B $6C24,4,4 [0, 1, 3, 10] -- Mask bytes
B $6C28,1,1 10 -- Number of objects
B $6C29,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6C2C,3,3 { interiorobject_WIDE_WINDOW, 8, 0 }
B $6C2F,3,3 { interiorobject_WIDE_WINDOW, 2, 3 }
B $6C32,3,3 { interiorobject_OCCUPIED_BED, 10, 5 }
B $6C35,3,3 { interiorobject_OCCUPIED_BED, 6, 7 }
B $6C38,3,3 { interiorobject_DOOR_FRAME_SW_NE, 15, 8 }
B $6C3B,3,3 { interiorobject_ORNATE_WARDROBE_FACING_SW, 18, 5 }
B $6C3E,3,3 { interiorobject_ORNATE_WARDROBE_FACING_SW, 20, 6 }
B $6C41,3,3 { interiorobject_EMPTY_BED, 2, 9 }
B $6C44,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 10 }
> $6C47 ; Illustration
> $6C47 ;
> $6C47 ; Cartesian coordinates for room 2:
> $6C47 ;
> $6C47 ;        X>>>>> Y>>>>>
> $6C47 ;  Room: 22..62 26..58 - the first byte of the room definition gives us this
> $6C47 ;   Bed: 48..64 43..56 - the first boundary is the bed
> $6C47 ; Table: 24..38 26..40 - the second boundary is the table
> $6C47 ;
> $6C47 ;    22 ................X................. 62
> $6C47 ; 26 +-+------------+-----------------------+
> $6C47 ;  . | |            |                       |
> $6C47 ;  . | |            |                       |
> $6C47 ;  . | |   Table    |                       |
> $6C47 ;  . | |            |                       |
> $6C47 ;  . | |            |                       |
> $6C47 ;  . | +------------+                       |
> $6C47 ;  . |                                      |
> $6C47 ;  Y |                    +-------------------+
> $6C47 ;  . |                    |                   |
> $6C47 ;  . |                    |                   |
> $6C47 ;  . |                    |        Bed        |
> $6C47 ;  . |                    |                   |
> $6C47 ;  . |                    |                   |
> $6C47 ;  . |                    +-------------------+
> $6C47 ;  . |                                      |
> $6C47 ; 58 +--------------------------------------+
> $6C47 ;
> $6C47 ; (Not necessarily to scale.)
;
b $6C47 Room 2: Hut 2, near side.
@ $6C47 label=roomdef_2_hut2_left
B $6C47,1,1 1 -- Room dimensions index
B $6C48,1,1 2 -- Number of boundaries
B $6C49,4,4 { 48, 64, 43, 56 } -- Boundary (bed)
B $6C4D,4,4 { 24, 38, 26, 40 } -- Boundary (table)
B $6C51,1,1 2 -- Number of mask bytes
B $6C52,2,2 [13, 8] -- Mask bytes
B $6C54,1,1 8 -- Number of objects
B $6C55,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6C58,3,3 { interiorobject_WIDE_WINDOW, 6, 2 }
B $6C5B,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 16, 5 }
B $6C5E,3,3 { interiorobject_STOVE_PIPE, 4, 5 }
@ $6C61 label=roomdef_2_hut2_left_heros_bed
B $6C61,3,3 { interiorobject_OCCUPIED_BED, 8, 7 }
B $6C64,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 9 }
B $6C67,3,3 { interiorobject_TABLE, 11, 12 }
B $6C6A,3,3 { interiorobject_SMALL_TUNNEL_ENTRANCE, 5, 9 }
;
b $6C6D Room 3: Hut 2, far side.
@ $6C6D label=roomdef_3_hut2_right
B $6C6D,1,1 0 -- Room dimensions index
B $6C6E,1,1 3 -- Number of boundaries
B $6C6F,4,4 { 54, 68, 23, 34 } -- Boundary
B $6C73,4,4 { 54, 68, 39, 50 } -- Boundary
B $6C77,4,4 { 54, 68, 55, 68 } -- Boundary
B $6C7B,1,1 4 -- Number of mask bytes
B $6C7C,4,4 [0, 1, 3, 10] -- Mask bytes
B $6C80,1,1 10 -- Number of objects
B $6C81,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6C84,3,3 { interiorobject_WIDE_WINDOW, 8, 0 }
B $6C87,3,3 { interiorobject_WIDE_WINDOW, 2, 3 }
@ $6C8A label=roomdef_3_hut2_right_bed_A
B $6C8A,3,3 { interiorobject_OCCUPIED_BED, 10, 5 }
@ $6C8D label=roomdef_3_hut2_right_bed_B
B $6C8D,3,3 { interiorobject_OCCUPIED_BED, 6, 7 }
@ $6C90 label=roomdef_3_hut2_right_bed_C
B $6C90,3,3 { interiorobject_OCCUPIED_BED, 2, 9 }
B $6C93,3,3 { interiorobject_CHEST_OF_DRAWERS, 16, 5 }
B $6C96,3,3 { interiorobject_DOOR_FRAME_SW_NE, 15, 8 }
B $6C99,3,3 { interiorobject_SHORT_WARDROBE, 18, 5 }
B $6C9C,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 10 }
;
b $6C9F Room 4: Hut 3, near side.
@ $6C9F label=roomdef_4_hut3_left
B $6C9F,1,1 1 -- Room dimensions index
B $6CA0,1,1 2 -- Number of boundaries
B $6CA1,4,4 { 24, 40, 24, 42 } -- Boundary
B $6CA5,4,4 { 48, 64, 43, 56 } -- Boundary
B $6CA9,1,1 3 -- Number of mask bytes
B $6CAA,3,3 [18, 20, 8] -- Mask bytes
B $6CAD,1,1 9 -- Number of objects
B $6CAE,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6CB1,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 16, 5 }
B $6CB4,3,3 { interiorobject_WIDE_WINDOW, 6, 2 }
B $6CB7,3,3 { interiorobject_STOVE_PIPE, 4, 5 }
B $6CBA,3,3 { interiorobject_EMPTY_BED, 8, 7 }
B $6CBD,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 9 }
B $6CC0,3,3 { interiorobject_CHAIR_FACING_SE, 11, 11 }
B $6CC3,3,3 { interiorobject_CHAIR_FACING_SW, 13, 10 }
B $6CC6,3,3 { interiorobject_STUFF, 14, 14 }
;
b $6CC9 Room 5: Hut 3, far side.
@ $6CC9 label=roomdef_5_hut3_right
B $6CC9,1,1 0 -- Room dimensions index
B $6CCA,1,1 3 -- Number of boundaries
B $6CCB,4,4 { 54, 68, 23, 34 } -- Boundary
B $6CCF,4,4 { 54, 68, 39, 50 } -- Boundary
B $6CD3,4,4 { 54, 68, 55, 68 } -- Boundary
B $6CD7,1,1 4 -- Number of mask bytes
B $6CD8,4,4 [0, 1, 3, 10] -- Mask bytes
B $6CDC,1,1 10 -- Number of objects
B $6CDD,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6CE0,3,3 { interiorobject_WIDE_WINDOW, 8, 0 }
B $6CE3,3,3 { interiorobject_WIDE_WINDOW, 2, 3 }
@ $6CE6 label=roomdef_5_hut2_right_bed_D
B $6CE6,3,3 { interiorobject_OCCUPIED_BED, 10, 5 }
@ $6CE9 label=roomdef_5_hut2_right_bed_E
B $6CE9,3,3 { interiorobject_OCCUPIED_BED, 6, 7 }
@ $6CEC label=roomdef_5_hut2_right_bed_F
B $6CEC,3,3 { interiorobject_OCCUPIED_BED, 2, 9 }
B $6CEF,3,3 { interiorobject_DOOR_FRAME_SW_NE, 15, 8 }
B $6CF2,3,3 { interiorobject_CHEST_OF_DRAWERS, 16, 5 }
B $6CF5,3,3 { interiorobject_CHEST_OF_DRAWERS, 20, 7 }
B $6CF8,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 10 }
;
b $6CFB Room 8: Corridor.
@ $6CFB label=roomdef_8_corridor
B $6CFB,1,1 2 -- Room dimensions index
B $6CFC,1,1 0 -- Number of boundaries
B $6CFD,1,1 1 -- Number of mask bytes
B $6CFE,1,1 [9] -- Mask bytes
B $6CFF,1,1 5 -- Number of objects
B $6D00,3,3 { interiorobject_ROOM_OUTLINE_18x10_B, 3, 6 }
B $6D03,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 10, 3 }
B $6D06,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 4, 6 }
B $6D09,3,3 { interiorobject_DOOR_FRAME_NW_SE, 5, 10 }
B $6D0C,3,3 { interiorobject_SHORT_WARDROBE, 18, 6 }
;
b $6D0F Room 9: Room with crate.
@ $6D0F label=roomdef_9_crate
B $6D0F,1,1 1 -- Room dimensions index
B $6D10,1,1 1 -- Number of boundaries
B $6D11,4,4 { 58, 64, 28, 42 } -- Boundary
B $6D15,1,1 2 -- Number of mask bytes
B $6D16,2,2 [4, 21] -- Mask bytes
B $6D18,1,1 10 -- Number of objects
B $6D19,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6D1C,3,3 { interiorobject_SMALL_WINDOW, 6, 3 }
B $6D1F,3,3 { interiorobject_SMALL_SHELF, 9, 4 }
B $6D22,3,3 { interiorobject_TINY_DOOR_FRAME_NW_SE, 12, 6 }
B $6D25,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
B $6D28,3,3 { interiorobject_TALL_WARDROBE, 16, 6 }
B $6D2B,3,3 { interiorobject_SHORT_WARDROBE, 18, 8 }
B $6D2E,3,3 { interiorobject_CUPBOARD, 3, 6 }
B $6D31,3,3 { interiorobject_SMALL_CRATE, 6, 8 }
B $6D34,3,3 { interiorobject_SMALL_CRATE, 4, 9 }
;
b $6D37 Room 10: Room with lockpick.
@ $6D37 label=roomdef_10_lockpick
B $6D37,1,1 4 -- Room dimensions index
B $6D38,1,1 2 -- Number of boundaries
B $6D39,4,4 { 69, 75, 32, 54 } -- Boundary
B $6D3D,4,4 { 36, 47, 48, 60 } -- Boundary
B $6D41,1,1 3 -- Number of mask bytes
B $6D42,3,3 [6, 14, 22] -- Mask bytes
B $6D45,1,1 14 -- Number of objects
B $6D46,3,3 { interiorobject_ROOM_OUTLINE_22x12_B, 1, 4 }
B $6D49,3,3 { interiorobject_DOOR_FRAME_SW_NE, 15, 10 }
B $6D4C,3,3 { interiorobject_SMALL_WINDOW, 4, 1 }
B $6D4F,3,3 { interiorobject_KEY_RACK, 2, 3 }
B $6D52,3,3 { interiorobject_KEY_RACK, 7, 2 }
B $6D55,3,3 { interiorobject_TALL_WARDROBE, 10, 2 }
B $6D58,3,3 { interiorobject_CUPBOARD_42, 13, 3 }
B $6D5B,3,3 { interiorobject_CUPBOARD_42, 15, 4 }
B $6D5E,3,3 { interiorobject_CUPBOARD_42, 17, 5 }
B $6D61,3,3 { interiorobject_TABLE, 14, 8 }
B $6D64,3,3 { interiorobject_CHEST_OF_DRAWERS, 18, 8 }
B $6D67,3,3 { interiorobject_CHEST_OF_DRAWERS, 20, 9 }
B $6D6A,3,3 { interiorobject_SMALL_CRATE, 6, 5 }
B $6D6D,3,3 { interiorobject_TABLE, 2, 6 }
;
b $6D70 Room 11: Room with papers.
@ $6D70 label=roomdef_11_papers
B $6D70,1,1 4 -- Room dimensions index
B $6D71,1,1 1 -- Number of boundaries
B $6D72,4,4 { 27, 44, 36, 48 } -- Boundary
B $6D76,1,1 1 -- Number of mask bytes
B $6D77,1,1 [23] -- Mask bytes
B $6D78,1,1 9 -- Number of objects
B $6D79,3,3 { interiorobject_ROOM_OUTLINE_22x12_B, 1, 4 }
B $6D7C,3,3 { interiorobject_SMALL_SHELF, 6, 3 }
B $6D7F,3,3 { interiorobject_TALL_WARDROBE, 12, 3 }
B $6D82,3,3 { interiorobject_TALL_DRAWERS, 10, 3 }
B $6D85,3,3 { interiorobject_SHORT_WARDROBE, 14, 5 }
B $6D88,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 2, 2 }
B $6D8B,3,3 { interiorobject_TALL_DRAWERS, 18, 7 }
B $6D8E,3,3 { interiorobject_TALL_DRAWERS, 20, 8 }
B $6D91,3,3 { interiorobject_DESK, 12, 10 }
;
b $6D94 Room 12: Corridor.
@ $6D94 label=roomdef_12_corridor
B $6D94,1,1 1 -- Room dimensions index
B $6D95,1,1 0 -- Number of boundaries
B $6D96,1,1 2 -- Number of mask bytes
B $6D97,2,2 [4, 7] -- Mask bytes
B $6D99,1,1 4 -- Number of objects
B $6D9A,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6D9D,3,3 { interiorobject_SMALL_WINDOW, 6, 3 }
B $6DA0,3,3 { interiorobject_DOOR_FRAME_NW_SE, 9, 10 }
B $6DA3,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
;
b $6DA6 Room 13: Corridor.
@ $6DA6 label=roomdef_13_corridor
B $6DA6,1,1 1 -- Room dimensions index
B $6DA7,1,1 0 -- Number of boundaries
B $6DA8,1,1 2 -- Number of mask bytes
B $6DA9,2,2 [4, 8] -- Mask bytes
B $6DAB,1,1 6 -- Number of objects
B $6DAC,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6DAF,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 6, 3 }
B $6DB2,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 9 }
B $6DB5,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
B $6DB8,3,3 { interiorobject_TALL_DRAWERS, 12, 5 }
B $6DBB,3,3 { interiorobject_CHEST_OF_DRAWERS, 14, 7 }
;
b $6DBE Room 14: Room with torch.
@ $6DBE label=roomdef_14_torch
B $6DBE,1,1 0 -- Room dimensions index
B $6DBF,1,1 3 -- Number of boundaries
B $6DC0,4,4 { 54, 68, 22, 32 } -- Boundary
B $6DC4,4,4 { 62, 68, 48, 58 } -- Boundary
B $6DC8,4,4 { 54, 68, 54, 68 } -- Boundary
B $6DCC,1,1 1 -- Number of mask bytes
B $6DCD,1,1 [1] -- Mask bytes
B $6DCE,1,1 9 -- Number of objects
B $6DCF,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6DD2,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 4, 3 }
B $6DD5,3,3 { interiorobject_TINY_DRAWERS, 8, 5 }
B $6DD8,3,3 { interiorobject_EMPTY_BED, 10, 5 }
B $6DDB,3,3 { interiorobject_CHEST_OF_DRAWERS, 16, 5 }
B $6DDE,3,3 { interiorobject_SHORT_WARDROBE, 18, 5 }
B $6DE1,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 20, 4 }
B $6DE4,3,3 { interiorobject_SMALL_SHELF, 2, 7 }
B $6DE7,3,3 { interiorobject_EMPTY_BED, 2, 9 }
;
b $6DEA Room 15: Room with uniform.
@ $6DEA label=roomdef_15_uniform
B $6DEA,1,1 0 -- Room dimensions index
B $6DEB,1,1 4 -- Number of boundaries
B $6DEC,4,4 { 54, 68, 22, 32 } -- Boundary
B $6DF0,4,4 { 54, 68, 54, 68 } -- Boundary
B $6DF4,4,4 { 62, 68, 40, 58 } -- Boundary
B $6DF8,4,4 { 30, 40, 56, 67 } -- Boundary
B $6DFC,1,1 4 -- Number of mask bytes
B $6DFD,4,4 [1, 5, 10, 15] -- Mask bytes
B $6E01,1,1 10 -- Number of objects
B $6E02,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6E05,3,3 { interiorobject_SHORT_WARDROBE, 16, 4 }
B $6E08,3,3 { interiorobject_EMPTY_BED, 10, 5 }
B $6E0B,3,3 { interiorobject_TINY_DRAWERS, 8, 5 }
B $6E0E,3,3 { interiorobject_TINY_DRAWERS, 6, 6 }
B $6E11,3,3 { interiorobject_SMALL_SHELF, 2, 7 }
B $6E14,3,3 { interiorobject_EMPTY_BED, 2, 9 }
B $6E17,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 10 }
B $6E1A,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 9 }
B $6E1D,3,3 { interiorobject_TABLE, 18, 8 }
;
b $6E20 Room 16: Corridor.
@ $6E20 label=roomdef_16_corridor
B $6E20,1,1 1 -- Room dimensions index
B $6E21,1,1 0 -- Number of boundaries
B $6E22,1,1 2 -- Number of mask bytes
B $6E23,2,2 [4, 7] -- Mask bytes
B $6E25,1,1 4 -- Number of objects
B $6E26,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6E29,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 4, 4 }
B $6E2C,3,3 { interiorobject_DOOR_FRAME_NW_SE, 9, 10 }
B $6E2F,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
;
b $6E32 Room 7: Corridor.
@ $6E32 label=roomdef_7_corridor
B $6E32,1,1 1 -- Room dimensions index
B $6E33,1,1 0 -- Number of boundaries
B $6E34,1,1 1 -- Number of mask bytes
B $6E35,1,1 [4] -- Mask bytes
B $6E36,1,1 4 -- Number of objects
B $6E37,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6E3A,3,3 { interiorobject_END_DOOR_FRAME_SW_NE, 4, 4 }
B $6E3D,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
B $6E40,3,3 { interiorobject_TALL_WARDROBE, 12, 4 }
;
b $6E43 Room 18: Room with radio.
@ $6E43 label=roomdef_18_radio
B $6E43,1,1 4 -- Room dimensions index
B $6E44,1,1 3 -- Number of boundaries
B $6E45,4,4 { 38, 56, 48, 60 } -- Boundary
B $6E49,4,4 { 38, 46, 39, 60 } -- Boundary
B $6E4D,4,4 { 22, 32, 48, 60 } -- Boundary
B $6E51,1,1 5 -- Number of mask bytes
B $6E52,5,5 [11, 17, 16, 24, 25] -- Mask bytes
B $6E57,1,1 10 -- Number of objects
B $6E58,3,3 { interiorobject_ROOM_OUTLINE_22x12_B, 1, 4 }
B $6E5B,3,3 { interiorobject_CUPBOARD, 1, 4 }
B $6E5E,3,3 { interiorobject_SMALL_WINDOW, 4, 1 }
B $6E61,3,3 { interiorobject_SMALL_SHELF, 7, 2 }
B $6E64,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 10, 1 }
B $6E67,3,3 { interiorobject_TABLE, 12, 7 }
B $6E6A,3,3 { interiorobject_MESS_BENCH_SHORT, 12, 9 }
B $6E6D,3,3 { interiorobject_TABLE, 18, 10 }
B $6E70,3,3 { interiorobject_TINY_TABLE, 16, 12 }
B $6E73,3,3 { interiorobject_DOOR_FRAME_NW_SE, 5, 7 }
;
b $6E76 Room 19: Room with food.
@ $6E76 label=roomdef_19_food
B $6E76,1,1 1 -- Room dimensions index
B $6E77,1,1 1 -- Number of boundaries
B $6E78,4,4 { 52, 64, 47, 56 } -- Boundary
B $6E7C,1,1 1 -- Number of mask bytes
B $6E7D,1,1 [7] -- Mask bytes
B $6E7E,1,1 11 -- Number of objects
B $6E7F,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6E82,3,3 { interiorobject_SMALL_WINDOW, 6, 3 }
B $6E85,3,3 { interiorobject_CUPBOARD, 9, 3 }
B $6E88,3,3 { interiorobject_CUPBOARD_42, 12, 3 }
B $6E8B,3,3 { interiorobject_CUPBOARD_42, 14, 4 }
B $6E8E,3,3 { interiorobject_TABLE, 9, 6 }
B $6E91,3,3 { interiorobject_SMALL_SHELF, 3, 5 }
B $6E94,3,3 { interiorobject_SINK, 3, 7 }
B $6E97,3,3 { interiorobject_CHEST_OF_DRAWERS, 14, 7 }
B $6E9A,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 16, 5 }
B $6E9D,3,3 { interiorobject_DOOR_FRAME_NW_SE, 9, 10 }
;
b $6EA0 Room 20: Room with red cross parcel.
@ $6EA0 label=roomdef_20_redcross
B $6EA0,1,1 1 -- Room dimensions index
B $6EA1,1,1 2 -- Number of boundaries
B $6EA2,4,4 { 58, 64, 26, 42 } -- Boundary
B $6EA6,4,4 { 50, 64, 46, 54 } -- Boundary
B $6EAA,1,1 2 -- Number of mask bytes
B $6EAB,2,2 [21, 4] -- Mask bytes
B $6EAD,1,1 11 -- Number of objects
B $6EAE,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6EB1,3,3 { interiorobject_DOOR_FRAME_SW_NE, 13, 10 }
B $6EB4,3,3 { interiorobject_SMALL_SHELF, 9, 4 }
B $6EB7,3,3 { interiorobject_CUPBOARD, 3, 6 }
B $6EBA,3,3 { interiorobject_SMALL_CRATE, 6, 8 }
B $6EBD,3,3 { interiorobject_SMALL_CRATE, 4, 9 }
B $6EC0,3,3 { interiorobject_TABLE, 9, 6 }
B $6EC3,3,3 { interiorobject_TALL_WARDROBE, 14, 5 }
B $6EC6,3,3 { interiorobject_TALL_WARDROBE, 16, 6 }
B $6EC9,3,3 { interiorobject_ORNATE_WARDROBE_FACING_SW, 18, 8 }
B $6ECC,3,3 { interiorobject_TINY_TABLE, 11, 8 }
;
b $6ECF Room 22: Room with red key.
@ $6ECF label=roomdef_22_red_key
B $6ECF,1,1 3 -- Room dimensions index
B $6ED0,1,1 2 -- Number of boundaries
B $6ED1,4,4 { 54, 64, 46, 56 } -- Boundary
B $6ED5,4,4 { 58, 64, 36, 44 } -- Boundary
B $6ED9,1,1 2 -- Number of mask bytes
B $6EDA,2,2 [12, 21] -- Mask bytes
B $6EDC,1,1 7 -- Number of objects
B $6EDD,3,3 { interiorobject_ROOM_OUTLINE_15x8, 5, 6 }
B $6EE0,3,3 { interiorobject_NOTICEBOARD, 4, 4 }
B $6EE3,3,3 { interiorobject_SMALL_SHELF, 9, 4 }
B $6EE6,3,3 { interiorobject_SMALL_CRATE, 6, 8 }
B $6EE9,3,3 { interiorobject_DOOR_FRAME_NW_SE, 9, 8 }
B $6EEC,3,3 { interiorobject_TABLE, 9, 6 }
B $6EEF,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 14, 4 }
;
b $6EF2 Room 23: Breakfast room.
@ $6EF2 label=roomdef_23_breakfast
B $6EF2,1,1 0 -- Room dimensions index
B $6EF3,1,1 1 -- Number of boundaries
B $6EF4,4,4 { 54, 68, 34, 68 } -- Boundary
B $6EF8,1,1 2 -- Number of mask bytes
B $6EF9,2,2 [10, 3] -- Mask bytes
B $6EFB,1,1 12 -- Number of objects
B $6EFC,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6EFF,3,3 { interiorobject_SMALL_WINDOW, 8, 0 }
B $6F02,3,3 { interiorobject_SMALL_WINDOW, 2, 3 }
B $6F05,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 10 }
B $6F08,3,3 { interiorobject_MESS_TABLE, 5, 4 }
B $6F0B,3,3 { interiorobject_CUPBOARD_42, 18, 4 }
B $6F0E,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 20, 4 }
B $6F11,3,3 { interiorobject_DOOR_FRAME_SW_NE, 15, 8 }
B $6F14,3,3 { interiorobject_MESS_BENCH, 7, 6 }
@ $6F17 label=roomdef_23_breakfast_bench_A
B $6F17,3,3 { interiorobject_EMPTY_BENCH, 12, 5 }
@ $6F1A label=roomdef_23_breakfast_bench_B
B $6F1A,3,3 { interiorobject_EMPTY_BENCH, 10, 6 }
@ $6F1D label=roomdef_23_breakfast_bench_C
B $6F1D,3,3 { interiorobject_EMPTY_BENCH, 8, 7 }
;
b $6F20 Room 24: Solitary confinement cell.
@ $6F20 label=roomdef_24_solitary
B $6F20,1,1 3 -- Room dimensions index
B $6F21,1,1 1 -- Number of boundaries
B $6F22,4,4 { 48, 54, 38, 46 } -- Boundary
B $6F26,1,1 1 -- Number of mask bytes
B $6F27,1,1 [26] -- Mask bytes
B $6F28,1,1 3 -- Number of objects
B $6F29,3,3 { interiorobject_ROOM_OUTLINE_15x8, 5, 6 }
B $6F2C,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 14, 4 }
B $6F2F,3,3 { interiorobject_TINY_TABLE, 10, 9 }
;
b $6F32 Room 25: Breakfast room.
@ $6F32 label=roomdef_25_breakfast
B $6F32,1,1 0 -- Room dimensions index
B $6F33,1,1 1 -- Number of boundaries
B $6F34,4,4 { 54, 68, 34, 68 } -- Boundary
B $6F38,1,1 0 -- Number of mask bytes
B $6F39,1,1 11 -- Number of objects
B $6F3A,3,3 { interiorobject_ROOM_OUTLINE_22x12_A, 1, 4 }
B $6F3D,3,3 { interiorobject_SMALL_WINDOW, 8, 0 }
B $6F40,3,3 { interiorobject_CUPBOARD, 5, 3 }
B $6F43,3,3 { interiorobject_SMALL_WINDOW, 2, 3 }
B $6F46,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 18, 3 }
B $6F49,3,3 { interiorobject_MESS_TABLE, 5, 4 }
B $6F4C,3,3 { interiorobject_MESS_BENCH, 7, 6 }
@ $6F4F label=roomdef_25_breakfast_bench_D
B $6F4F,3,3 { interiorobject_EMPTY_BENCH, 12, 5 }
@ $6F52 label=roomdef_25_breakfast_bench_E
B $6F52,3,3 { interiorobject_EMPTY_BENCH, 10, 6 }
@ $6F55 label=roomdef_25_breakfast_bench_F
B $6F55,3,3 { interiorobject_EMPTY_BENCH, 8, 7 }
@ $6F58 label=roomdef_25_breakfast_bench_G
B $6F58,3,3 { interiorobject_EMPTY_BENCH, 14, 4 }
;
b $6F5B Room 28: Hut 1, near side.
@ $6F5B label=roomdef_28_hut1_left
B $6F5B,1,1 1 -- Room dimensions index
B $6F5C,1,1 2 -- Number of boundaries
B $6F5D,4,4 { 28, 40, 28, 52 } -- Boundary
B $6F61,4,4 { 48, 63, 44, 56 } -- Boundary
B $6F65,1,1 3 -- Number of mask bytes
B $6F66,3,3 [8, 13, 19] -- Mask bytes
B $6F69,1,1 8 -- Number of objects
B $6F6A,3,3 { interiorobject_ROOM_OUTLINE_18x10_A, 3, 6 }
B $6F6D,3,3 { interiorobject_WIDE_WINDOW, 6, 2 }
B $6F70,3,3 { interiorobject_END_DOOR_FRAME_NW_SE, 14, 4 }
B $6F73,3,3 { interiorobject_CUPBOARD, 3, 6 }
B $6F76,3,3 { interiorobject_OCCUPIED_BED, 8, 7 }
B $6F79,3,3 { interiorobject_DOOR_FRAME_NW_SE, 7, 9 }
B $6F7C,3,3 { interiorobject_CHAIR_FACING_SW, 15, 10 }
B $6F7F,3,3 { interiorobject_TABLE, 11, 12 }
;
b $6F82 Room 29: Start of second tunnel.
@ $6F82 label=roomdef_29_second_tunnel_start
B $6F82,1,1 5 -- Room dimensions index
B $6F83,1,1 0 -- Number of boundaries
B $6F84,1,1 6 -- Number of mask bytes
B $6F85,6,6 [30, 31, 32, 33, 34, 35] -- Mask bytes
B $6F8B,1,1 6 -- Number of objects
B $6F8C,3,3 { interiorobject_TUNNEL_SW_NE, 20, 0 }
B $6F8F,3,3 { interiorobject_TUNNEL_SW_NE, 16, 2 }
B $6F92,3,3 { interiorobject_TUNNEL_SW_NE, 12, 4 }
B $6F95,3,3 { interiorobject_TUNNEL_SW_NE, 8, 6 }
B $6F98,3,3 { interiorobject_TUNNEL_SW_NE, 4, 8 }
B $6F9B,3,3 { interiorobject_TUNNEL_SW_NE, 0, 10 }
;
b $6F9E Room 31.
@ $6F9E label=roomdef_31
B $6F9E,1,1 6 -- Room dimensions index
B $6F9F,1,1 0 -- Number of boundaries
B $6FA0,1,1 6 -- Number of mask bytes
B $6FA1,6,6 [36, 37, 38, 39, 40, 41] -- Mask bytes
B $6FA7,1,1 6 -- Number of objects
B $6FA8,3,3 { interiorobject_TUNNEL_NW_SE, 0, 0 }
B $6FAB,3,3 { interiorobject_TUNNEL_NW_SE, 4, 2 }
B $6FAE,3,3 { interiorobject_TUNNEL_NW_SE, 8, 4 }
B $6FB1,3,3 { interiorobject_TUNNEL_NW_SE, 12, 6 }
B $6FB4,3,3 { interiorobject_TUNNEL_NW_SE, 16, 8 }
B $6FB7,3,3 { interiorobject_TUNNEL_NW_SE, 20, 10 }
;
b $6FBA Room 36.
@ $6FBA label=roomdef_36
B $6FBA,1,1 7 -- Room dimensions index
B $6FBB,1,1 0 -- Number of boundaries
B $6FBC,1,1 6 -- Number of mask bytes
B $6FBD,6,6 [31, 32, 33, 34, 35, 45] -- Mask bytes
B $6FC3,1,1 5 -- Number of objects
B $6FC4,3,3 { interiorobject_TUNNEL_SW_NE, 20, 0 }
B $6FC7,3,3 { interiorobject_TUNNEL_SW_NE, 16, 2 }
B $6FCA,3,3 { interiorobject_TUNNEL_SW_NE, 12, 4 }
B $6FCD,3,3 { interiorobject_TUNNEL_SW_NE, 8, 6 }
B $6FD0,3,3 { interiorobject_TUNNEL_14, 4, 8 }
;
b $6FD3 Room 32.
@ $6FD3 label=roomdef_32
B $6FD3,1,1 8 -- Room dimensions index
B $6FD4,1,1 0 -- Number of boundaries
B $6FD5,1,1 6 -- Number of mask bytes
B $6FD6,6,6 [36, 37, 38, 39, 40, 42] -- Mask bytes
B $6FDC,1,1 5 -- Number of objects
B $6FDD,3,3 { interiorobject_TUNNEL_NW_SE, 0, 0 }
B $6FE0,3,3 { interiorobject_TUNNEL_NW_SE, 4, 2 }
B $6FE3,3,3 { interiorobject_TUNNEL_NW_SE, 8, 4 }
B $6FE6,3,3 { interiorobject_TUNNEL_NW_SE, 12, 6 }
B $6FE9,3,3 { interiorobject_TUNNEL_17, 16, 8 }
;
b $6FEC Room 34.
@ $6FEC label=roomdef_34
B $6FEC,1,1 6 -- Room dimensions index
B $6FED,1,1 0 -- Number of boundaries
B $6FEE,1,1 6 -- Number of mask bytes
B $6FEF,6,6 [36, 37, 38, 39, 40, 46] -- Mask bytes
B $6FF5,1,1 6 -- Number of objects
B $6FF6,3,3 { interiorobject_TUNNEL_NW_SE, 0, 0 }
B $6FF9,3,3 { interiorobject_TUNNEL_NW_SE, 4, 2 }
B $6FFC,3,3 { interiorobject_TUNNEL_NW_SE, 8, 4 }
B $6FFF,3,3 { interiorobject_TUNNEL_NW_SE, 12, 6 }
B $7002,3,3 { interiorobject_TUNNEL_NW_SE, 16, 8 }
B $7005,3,3 { interiorobject_TUNNEL_JOIN_18, 20, 10 }
;
b $7008 Room 35.
@ $7008 label=roomdef_35
B $7008,1,1 6 -- Room dimensions index
B $7009,1,1 0 -- Number of boundaries
B $700A,1,1 6 -- Number of mask bytes
B $700B,6,6 [36, 37, 38, 39, 40, 41] -- Mask bytes
B $7011,1,1 6 -- Number of objects
B $7012,3,3 { interiorobject_TUNNEL_NW_SE, 0, 0 }
B $7015,3,3 { interiorobject_TUNNEL_NW_SE, 4, 2 }
B $7018,3,3 { interiorobject_TUNNEL_T_JOIN_NW_SE, 8, 4 }
B $701B,3,3 { interiorobject_TUNNEL_NW_SE, 12, 6 }
B $701E,3,3 { interiorobject_TUNNEL_NW_SE, 16, 8 }
B $7021,3,3 { interiorobject_TUNNEL_NW_SE, 20, 10 }
;
b $7024 Room 30.
@ $7024 label=roomdef_30
B $7024,1,1 5 -- Room dimensions index
B $7025,1,1 0 -- Number of boundaries
B $7026,1,1 7 -- Number of mask bytes
B $7027,7,7 [30, 31, 32, 33, 34, 35, 44] -- Mask bytes
B $702E,1,1 6 -- Number of objects
B $702F,3,3 { interiorobject_TUNNEL_SW_NE, 20, 0 }
B $7032,3,3 { interiorobject_TUNNEL_SW_NE, 16, 2 }
B $7035,3,3 { interiorobject_TUNNEL_SW_NE, 12, 4 }
B $7038,3,3 { interiorobject_TUNNEL_CORNER_6, 8, 6 }
B $703B,3,3 { interiorobject_TUNNEL_SW_NE, 4, 8 }
B $703E,3,3 { interiorobject_TUNNEL_SW_NE, 0, 10 }
;
b $7041 Room 40.
@ $7041 label=roomdef_40
B $7041,1,1 9 -- Room dimensions index
B $7042,1,1 0 -- Number of boundaries
B $7043,1,1 6 -- Number of mask bytes
B $7044,6,6 [30, 31, 32, 33, 34, 43] -- Mask bytes
B $704A,1,1 6 -- Number of objects
B $704B,3,3 { interiorobject_TUNNEL_CORNER_7, 20, 0 }
B $704E,3,3 { interiorobject_TUNNEL_SW_NE, 16, 2 }
B $7051,3,3 { interiorobject_TUNNEL_SW_NE, 12, 4 }
B $7054,3,3 { interiorobject_TUNNEL_SW_NE, 8, 6 }
B $7057,3,3 { interiorobject_TUNNEL_SW_NE, 4, 8 }
B $705A,3,3 { interiorobject_TUNNEL_SW_NE, 0, 10 }
;
b $705D Room 44.
@ $705D label=roomdef_44
B $705D,1,1 8 -- Room dimensions index
B $705E,1,1 0 -- Number of boundaries
B $705F,1,1 5 -- Number of mask bytes
B $7060,5,5 [36, 37, 38, 39, 40] -- Mask bytes
B $7065,1,1 5 -- Number of objects
B $7066,3,3 { interiorobject_TUNNEL_NW_SE, 0, 0 }
B $7069,3,3 { interiorobject_TUNNEL_NW_SE, 4, 2 }
B $706C,3,3 { interiorobject_TUNNEL_NW_SE, 8, 4 }
B $706F,3,3 { interiorobject_TUNNEL_NW_SE, 12, 6 }
B $7072,3,3 { interiorobject_TUNNEL_CORNER_NW_NE, 16, 8 }
;
b $7075 Room 50: Blocked tunnel.
@ $7075 label=roomdef_50_blocked_tunnel
B $7075,1,1 5 -- Room dimensions index
B $7076,1,1 1 -- Number of boundaries
@ $7077 label=roomdef_50_blocked_tunnel_boundary
B $7077,4,4 { 52, 58, 32, 54 } -- Boundary
B $707B,1,1 6 -- Number of mask bytes
B $707C,6,6 [30, 31, 32, 33, 34, 43] -- Mask bytes
B $7082,1,1 6 -- Number of objects
B $7083,3,3 { interiorobject_TUNNEL_CORNER_7, 20, 0 }
B $7086,3,3 { interiorobject_TUNNEL_SW_NE, 16, 2 }
B $7089,3,3 { interiorobject_TUNNEL_SW_NE, 12, 4 }
@ $708C label=roomdef_50_blocked_tunnel_collapsed_tunnel
B $708C,3,3 { interiorobject_COLLAPSED_TUNNEL_SW_NE, 8, 6 }
B $708F,3,3 { interiorobject_TUNNEL_SW_NE, 4, 8 }
B $7092,3,3 { interiorobject_TUNNEL_SW_NE, 0, 10 }
;
b $7095 Interior object definitions.
D $7095 This is an array of pointers to interior object definitions. It's 54 entries long.
@ $7095 label=interior_object_defs
W $7095,108,2
;
b $7101 Room object 0: Straight tunnel section SW-NE
@ $7101 label=interior_object_tile_refs_0
B $7101,1,1 width
B $7102,1,1 height
B $7103,24,4 tile references
E $7101 #HTML[#CALL:decode_object($7101, 0)]
;
b $711B Room object 1: Small tunnel entrance
@ $711B label=interior_object_tile_refs_1
B $711B,1,1 width
B $711C,1,1 height
B $711D,4,2 tile references
E $711B #HTML[#CALL:decode_object($711B, 1)]
;
b $7121 Room object 3: Straight tunnel section NW-SE
@ $7121 label=interior_object_tile_refs_3
B $7121,1,1 width
B $7122,1,1 height
B $7123,24,4 tile references
E $7121 #HTML[#CALL:decode_object($7121, 3)]
;
b $713B Room object 4: Tunnel T-join section NW-SE
@ $713B label=interior_object_tile_refs_4
B $713B,1,1 width
B $713C,1,1 height
B $713D,24,4 tile references
E $713B #HTML[#CALL:decode_object($713B, 4)]
;
b $7155 Room object 5: Prisoner sat mid table
@ $7155 label=interior_object_tile_refs_5
B $7155,1,1 width
B $7156,1,1 height
B $7157,3,3 tile references (incl. RLE)
E $7155 #HTML[#CALL:decode_object($7155, 5)]
;
b $715A Room object 6: Tunnel T-join section SW-NE
@ $715A label=interior_object_tile_refs_6
B $715A,1,1 width
B $715B,1,1 height
B $715C,24,4 tile references
E $715A #HTML[#CALL:decode_object($715A, 6)]
;
b $7174 Room object 7: Tunnel corner section SW-SE
@ $7174 label=interior_object_tile_refs_7
B $7174,1,1 width
B $7175,1,1 height
B $7176,24,4 tile references
E $7174 #HTML[#CALL:decode_object($7174, 7)]
;
b $718E Room object 12: Tunnel corner section NW-NE
@ $718E label=interior_object_tile_refs_12
B $718E,1,1 width
B $718F,1,1 height
B $7190,22,8*2,6 tile references (incl. RLE)
E $718E #HTML[#CALL:decode_object($718E, 12)]
;
b $71A6 Room object 13: Empty bench
@ $71A6 label=interior_object_tile_refs_13
B $71A6,1,1 width
B $71A7,1,1 height
B $71A8,3,3 tile references (incl. RLE)
E $71A6 #HTML[#CALL:decode_object($71A6, 13)]
;
b $71AB Room object 14: Tunnel corner section NE-SE
@ $71AB label=interior_object_tile_refs_14
B $71AB,1,1 width
B $71AC,1,1 height
B $71AD,23,8*2,7 tile references (incl. RLE)
E $71AB #HTML[#CALL:decode_object($71AB, 14)]
;
b $71C4 Room object 17: Tunnel corner section NW-SW
@ $71C4 label=interior_object_tile_refs_17
B $71C4,1,1 width
B $71C5,1,1 height
B $71C6,24,4 tile references
E $71C4 #HTML[#CALL:decode_object($71C4, 17)]
;
b $71DE Room object 18: Tunnel entrance
@ $71DE label=interior_object_tile_refs_18
B $71DE,1,1 width
B $71DF,1,1 height
B $71E0,24,4 tile references
E $71DE #HTML[#CALL:decode_object($71DE, 18)]
;
b $71F8 Room object 19: Prisoner sat end table
@ $71F8 label=interior_object_tile_refs_19
B $71F8,1,1 width
B $71F9,1,1 height
B $71FA,6,2 tile references
E $71F8 #HTML[#CALL:decode_object($71F8, 19)]
;
b $7200 Room object 20: Collapsed tunnel section SW-NE
@ $7200 label=interior_object_tile_refs_20
B $7200,1,1 width
B $7201,1,1 height
B $7202,3,3 tile references (incl. RLE)
B $7205,21,8*2,5
E $7200 #HTML[#CALL:decode_object($7200, 20)]
;
b $721A Room object 2: Room outline 22x12 A
@ $721A label=interior_object_tile_refs_2
B $721A,1,1 width
B $721B,1,1 height
B $721C,114,8*14,2 tile references (incl. RLE)
E $721A #HTML[#CALL:decode_object($721A, 2)]
;
b $728E Room object 8: Wide window facing SE
@ $728E label=interior_object_tile_refs_8
B $728E,1,1 width
B $728F,1,1 height
B $7290,30,5 tile references
E $728E #HTML[#CALL:decode_object($728E, 8)]
;
b $72AE Room object 9: Empty bed facing SE
@ $72AE label=interior_object_tile_refs_9
B $72AE,1,1 width
B $72AF,1,1 height
B $72B0,17,8*2,1 tile references (incl. RLE)
E $72AE #HTML[#CALL:decode_object($72AE, 9)]
;
b $72C1 Room object 10: Short wardrobe facing SW
@ $72C1 label=interior_object_tile_refs_10
B $72C1,1,1 width
B $72C2,1,1 height
B $72C3,9,8,1 tile references (incl. RLE)
E $72C1 #HTML[#CALL:decode_object($72C1, 10)]
;
b $72CC Room object 11: Chest of drawers facing SW
@ $72CC label=interior_object_tile_refs_11
B $72CC,1,1 width
B $72CD,1,1 height
B $72CE,3,3 tile references (incl. RLE)
E $72CC #HTML[#CALL:decode_object($72CC, 11)]
;
b $72D1 Room object 15: Door frame SE
@ $72D1 label=interior_object_tile_refs_15
B $72D1,1,1 width
B $72D2,1,1 height
B $72D3,24,4 tile references
E $72D1 #HTML[#CALL:decode_object($72D1, 15)]
;
b $72EB Room object 16: Door frame SW
@ $72EB label=interior_object_tile_refs_16
B $72EB,1,1 width
B $72EC,1,1 height
B $72ED,24,4 tile references
E $72EB #HTML[#CALL:decode_object($72EB, 16)]
;
b $7305 Room object 22: Chair facing SE
@ $7305 label=interior_object_tile_refs_22
B $7305,1,1 width
B $7306,1,1 height
B $7307,8,2 tile references
E $7305 #HTML[#CALL:decode_object($7305, 22)]
;
b $730F Room object 23: Occupied bed
@ $730F label=interior_object_tile_refs_23
B $730F,1,1 width
B $7310,1,1 height
B $7311,20,5 tile references
E $730F #HTML[#CALL:decode_object($730F, 23)]
;
b $7325 Room object 24: Ornate wardrobe facing SW
@ $7325 label=interior_object_tile_refs_24
B $7325,1,1 width
B $7326,1,1 height
B $7327,12,3 tile references
E $7325 #HTML[#CALL:decode_object($7325, 24)]
;
b $7333 Room object 25: Chair facing SW
@ $7333 label=interior_object_tile_refs_25
B $7333,1,1 width
B $7334,1,1 height
B $7335,7,7 tile references (incl. RLE)
E $7333 #HTML[#CALL:decode_object($7333, 25)]
;
b $733C Room object 26: Cupboard facing SE
@ $733C label=interior_object_tile_refs_26
B $733C,1,1 width
B $733D,1,1 height
B $733E,4,4 tile references (incl. RLE)
E $733C #HTML[#CALL:decode_object($733C, 26)]
;
b $7342 Room object 29: Table
@ $7342 label=interior_object_tile_refs_29
B $7342,1,1 width
B $7343,1,1 height
B $7344,7,7 tile references (incl. RLE)
E $7342 #HTML[#CALL:decode_object($7342, 29)]
;
b $734B Room object 30: Stove pipe
@ $734B label=interior_object_tile_refs_30
B $734B,1,1 width
B $734C,1,1 height
B $734D,12,8,4 tile references (incl. RLE)
E $734B #HTML[#CALL:decode_object($734B, 30)]
;
b $7359 Room object 31: Papers on floor
@ $7359 label=interior_object_tile_refs_31
B $7359,1,1 width
B $735A,1,1 height
B $735B,1,1 tile references
E $7359 #HTML[#CALL:decode_object($7359, 31)]
;
b $735C Room object 32: Tall wardrobe facing SW
@ $735C label=interior_object_tile_refs_32
B $735C,1,1 width
B $735D,1,1 height
B $735E,12,8,4 tile references (incl. RLE)
E $735C #HTML[#CALL:decode_object($735C, 32)]
;
b $736A Room object 33: Small shelf facing SE
@ $736A label=interior_object_tile_refs_33
B $736A,1,1 width
B $736B,1,1 height
B $736C,3,3 tile references (incl. RLE)
E $736A #HTML[#CALL:decode_object($736A, 33)]
;
b $736F Room object 34: Small crate
@ $736F label=interior_object_tile_refs_34
B $736F,1,1 width
B $7370,1,1 height
B $7371,3,3 tile references (incl. RLE)
E $736F #HTML[#CALL:decode_object($736F, 34)]
;
b $7374 Room object 35: Small window with bars facing SE
@ $7374 label=interior_object_tile_refs_35
B $7374,1,1 width
B $7375,1,1 height
B $7376,15,8,7 tile references (incl. RLE)
E $7374 #HTML[#CALL:decode_object($7374, 35)]
;
b $7385 Room object 36: Tiny door frame NE (tunnel entrance)
@ $7385 label=interior_object_tile_refs_36
B $7385,1,1 width
B $7386,1,1 height
B $7387,12,8,4 tile references (incl. RLE)
E $7385 #HTML[#CALL:decode_object($7385, 36)]
;
b $7393 Room object 37: Noticeboard facing SE
@ $7393 label=interior_object_tile_refs_37
B $7393,1,1 width
B $7394,1,1 height
B $7395,16,8 tile references (incl. RLE)
E $7393 #HTML[#CALL:decode_object($7393, 37)]
;
b $73A5 Room object 38: Door frame NW
@ $73A5 label=interior_object_tile_refs_38
B $73A5,1,1 width
B $73A6,1,1 height
B $73A7,24,4 tile references
E $73A5 #HTML[#CALL:decode_object($73A5, 38)]
;
b $73BF Room object 40: Door frame NE
@ $73BF label=interior_object_tile_refs_40
B $73BF,1,1 width
B $73C0,1,1 height
B $73C1,24,4 tile references
E $73BF #HTML[#CALL:decode_object($73BF, 40)]
;
b $73D9 Room object 41: Room outline 15x8
@ $73D9 label=interior_object_tile_refs_41
B $73D9,1,1 width
B $73DA,1,1 height
B $73DB,74,8*9,2 tile references (incl. RLE)
E $73D9 #HTML[#CALL:decode_object($73D9, 41)]
;
b $7425 Room object 42: Cupboard facing SW
@ $7425 label=interior_object_tile_refs_42
B $7425,1,1 width
B $7426,1,1 height
B $7427,6,2 tile references
E $7425 #HTML[#CALL:decode_object($7425, 42)]
;
b $742D Room object 43: Mess bench
@ $742D label=interior_object_tile_refs_43
B $742D,1,1 width
B $742E,1,1 height
B $742F,35,8*4,3 tile references (incl. RLE)
E $742D #HTML[#CALL:decode_object($742D, 43)]
;
b $7452 Room object 44: Mess table
@ $7452 label=interior_object_tile_refs_44
B $7452,1,1 width
B $7453,1,1 height
B $7454,46,8*5,6 tile references (incl. RLE)
E $7452 #HTML[#CALL:decode_object($7452, 44)]
;
b $7482 Room object 45: Mess bench short
@ $7482 label=interior_object_tile_refs_45
B $7482,1,1 width
B $7483,1,1 height
B $7484,15,8,7 tile references (incl. RLE)
E $7482 #HTML[#CALL:decode_object($7482, 45)]
;
b $7493 Room object 46: Room outline 18x10 B
@ $7493 label=interior_object_tile_refs_46
B $7493,1,1 width
B $7494,1,1 height
B $7495,96,8 tile references (incl. RLE)
E $7493 #HTML[#CALL:decode_object($7493, 46)]
;
b $74F5 Room object 47: Room outline 22x12 B
@ $74F5 label=interior_object_tile_refs_47
B $74F5,1,1 width
B $74F6,1,1 height
B $74F7,121,8*15,1 tile references (incl. RLE)
E $74F5 #HTML[#CALL:decode_object($74F5, 47)]
;
b $7570 Room object 48: Tiny table
@ $7570 label=interior_object_tile_refs_48
B $7570,1,1 width
B $7571,1,1 height
B $7572,4,2 tile references
E $7570 #HTML[#CALL:decode_object($7570, 48)]
;
b $7576 Room object 49: Tiny drawers facing SE
@ $7576 label=interior_object_tile_refs_49
B $7576,1,1 width
B $7577,1,1 height
B $7578,6,2 tile references
E $7576 #HTML[#CALL:decode_object($7576, 49)]
;
b $757E Room object 50: Tall drawers facing SW
@ $757E label=interior_object_tile_refs_50
B $757E,1,1 width
B $757F,1,1 height
B $7580,8,2 tile references
E $757E #HTML[#CALL:decode_object($757E, 50)]
;
b $7588 Room object 51: Desk facing SW
@ $7588 label=interior_object_tile_refs_51
B $7588,1,1 width
B $7589,1,1 height
B $758A,24,6 tile references
E $7588 #HTML[#CALL:decode_object($7588, 51)]
;
b $75A2 Room object 52: Sink facing SE
@ $75A2 label=interior_object_tile_refs_52
B $75A2,1,1 width
B $75A3,1,1 height
B $75A4,6,6 tile references (incl. RLE)
E $75A2 #HTML[#CALL:decode_object($75A2, 52)]
;
b $75AA Room object 53: Key rack facing SE
@ $75AA label=interior_object_tile_refs_53
B $75AA,1,1 width
B $75AB,1,1 height
B $75AC,4,2 tile references
E $75AA #HTML[#CALL:decode_object($75AA, 53)]
;
b $75B0 Room object 27: Room outline 18x10 A
@ $75B0 label=interior_object_tile_refs_27
B $75B0,1,1 width
B $75B1,1,1 height
B $75B2,96,8 tile references (incl. RLE)
E $75B0 #HTML[#CALL:decode_object($75B0, 27)]
;
b $7612 Character structures.
D $7612 This array contains one of the following seven-byte structures for each of the 26 game characters.
D $7612 #TABLE(default) { =h Type | =h Bytes | =h Name | =h Meaning } { Character | 1 | character_and_flags | Character index. Bit 6 set => on-screen } { Room | 1 | room | Index of the room this character is in, and flags } { TinyPos | 3 | pos | Map position of the character } { Route | 2 | route | The route the character's on } TABLE#
@ $7612 label=character_structs
B $7612,7,7 { character_0_COMMANDANT, room_11_PAPERS, ( 46, 46, 24), (0x03, 0x00) }
B $7619,7,7 { character_1_GUARD_1, room_0_OUTDOORS, (102, 68, 3), (0x01, 0x00) }
B $7620,7,7 { character_2_GUARD_2, room_0_OUTDOORS, ( 68, 104, 3), (0x01, 0x02) }
B $7627,7,7 { character_3_GUARD_3, room_16_CORRIDOR, ( 46, 46, 24), (0x03, 0x13) }
B $762E,7,7 { character_4_GUARD_4, room_0_OUTDOORS, ( 61, 103, 3), (0x02, 0x04) }
B $7635,7,7 { character_5_GUARD_5, room_0_OUTDOORS, (106, 56, 13), (0x00, 0x00) }
B $763C,7,7 { character_6_GUARD_6, room_0_OUTDOORS, ( 72, 94, 13), (0x00, 0x00) }
B $7643,7,7 { character_7_GUARD_7, room_0_OUTDOORS, ( 72, 70, 13), (0x00, 0x00) }
B $764A,7,7 { character_8_GUARD_8, room_0_OUTDOORS, ( 80, 46, 13), (0x00, 0x00) }
B $7651,7,7 { character_9_GUARD_9, room_0_OUTDOORS, (108, 71, 21), (0x04, 0x00) }
B $7658,7,7 { character_10_GUARD_10, room_0_OUTDOORS, ( 92, 52, 3), (0xFF, 0x38) }
B $765F,7,7 { character_11_GUARD_11, room_0_OUTDOORS, (109, 69, 3), (0x00, 0x00) }
B $7666,7,7 { character_12_GUARD_12, room_3_HUT2RIGHT, ( 40, 60, 24), (0x00, 0x08) }
N $766D Bug: The room field here is 2 but reset_map_and_characters will reset it to 3.
B $766D,7,7 { character_13_GUARD_13, room_2_HUT2LEFT, ( 36, 48, 24), (0x00, 0x08) }
B $7674,7,7 { character_14_GUARD_14, room_5_HUT3RIGHT, ( 40, 60, 24), (0x00, 0x10) }
B $767B,7,7 { character_15_GUARD_15, room_5_HUT3RIGHT, ( 36, 34, 24), (0x00, 0x10) }
B $7682,7,7 { character_16_GUARD_DOG_1, room_0_OUTDOORS, ( 68, 84, 1), (0xFF, 0x00) }
B $7689,7,7 { character_17_GUARD_DOG_2, room_0_OUTDOORS, ( 68, 104, 1), (0xFF, 0x00) }
B $7690,7,7 { character_18_GUARD_DOG_3, room_0_OUTDOORS, (102, 68, 1), (0xFF, 0x18) }
B $7697,7,7 { character_19_GUARD_DOG_4, room_0_OUTDOORS, ( 88, 68, 1), (0xFF, 0x18) }
B $769E,7,7 { character_20_PRISONER_1, room_NONE, ( 52, 60, 24), (0x00, 0x08) }
B $76A5,7,7 { character_21_PRISONER_2, room_NONE, ( 52, 44, 24), (0x00, 0x08) }
B $76AC,7,7 { character_22_PRISONER_3, room_NONE, ( 52, 28, 24), (0x00, 0x08) }
B $76B3,7,7 { character_23_PRISONER_4, room_NONE, ( 52, 60, 24), (0x00, 0x10) }
B $76BA,7,7 { character_24_PRISONER_5, room_NONE, ( 52, 44, 24), (0x00, 0x10) }
B $76C1,7,7 { character_25_PRISONER_6, room_NONE, ( 52, 28, 24), (0x00, 0x10) }
;
b $76C8 Item structures.
D $76C8 This array contains one of the following seven-byte structures for each of the 16 game items:
D $76C8 #TABLE(default) { =h Type | =h Bytes | =h Name | =h Meaning } { Item | 1 | item_and_flags | bits 0..3 = item; bits 4..7 = flags } { Room | 1 | room_and_flags | bits 0..5 = room; bits 6..7 = flags } { TinyPos | 3 | pos | Map position of the item } { IsoPos | 2 | iso_pos | Isometric projected position of the item } TABLE#
@ $76C8 label=item_structs
N $76C8 The first entry is used by #R$7C26, #R$7C82.
B $76C8,7,7 { item_WIRESNIPS, room_NONE, (64, 32, 2), (0x78, 0xF4) }
B $76CF,7,7 { item_SHOVEL, room_9_CRATE, (62, 48, 0), (0x7C, 0xF2) }
B $76D6,7,7 { item_LOCKPICK, room_10_LOCKPICK, (73, 36, 16), (0x77, 0xF0) }
B $76DD,7,7 { item_PAPERS, room_11_PAPERS, (42, 58, 4), (0x84, 0xF3) }
B $76E4,7,7 { item_TORCH, room_14_TORCH, (34, 24, 2), (0x7A, 0xF6) }
N $76EB The bribe item is used by #R$B107.
B $76EB,7,7 { item_BRIBE, room_NONE, (36, 44, 4), (0x7E, 0xF4) }
B $76F2,7,7 { item_UNIFORM, room_15_UNIFORM, (44, 65, 16), (0x87, 0xF1) }
@ $76F9 label=item_structs_food
N $76F9 The food item is used by #R$B3C4, #R$C892.
B $76F9,7,7 { item_FOOD, room_19_FOOD, (64, 48, 16), (0x7E, 0xF0) }
B $7700,7,7 { item_POISON, room_1_HUT1RIGHT, (66, 52, 4), (0x7C, 0xF1) }
B $7707,7,7 { item_RED_KEY, room_22_REDKEY, (60, 42, 0), (0x7B, 0xF2) }
B $770E,7,7 { item_YELLOW_KEY, room_11_PAPERS, (28, 34, 0), (0x81, 0xF8) }
B $7715,7,7 { item_GREEN_KEY, room_0_OUTDOORS, (74, 72, 0), (0x7A, 0x6E) }
N $771C The red cross parcel is used by #R$A228, #R$B387.
B $771C,7,7 { item_RED_CROSS_PARCEL, room_NONE, (28, 50, 12), (0x85, 0xF6) }
B $7723,7,7 { item_RADIO, room_18_RADIO, (36, 58, 8), (0x85, 0xF4) }
B $772A,7,7 { item_PURSE, room_NONE, (36, 44, 4), (0x7E, 0xF4) }
B $7731,7,7 { item_COMPASS, room_NONE, (52, 28, 4), (0x7E, 0xF4) }
@ $7738 assemble=,1
;
b $7738 Table of pointers to routes.
D $7738 Array, 46 long, of pointers to $FF-terminated runs.
@ $7738 label=routes
W $7738,92,2
B $7794,1,1 Fake terminator used by get_target.
@ $7795 label=route_7795
B $7795,4,4 L-shaped route in the fenced area. #ROUTE($7795)
@ $7799 label=route_7799
B $7799,7,7 The guard's route around the front perimeter wall. #ROUTE($7799)
@ $77A0 label=route_commandant
B $77A0,45,8*5,5 The commandant's route. This is the longest of all the routes. #ROUTE($77A0)
@ $77CD label=route_77CD
B $77CD,3,3 The route of the guard marching over the front gate. #ROUTE($77CD)
@ $77D0 label=route_exit_hut2
B $77D0,4,4 route_exit_hut2. #ROUTE($77D0)
@ $77D4 label=route_exit_hut3
B $77D4,4,4 route_exit_hut3. #ROUTE($77D4)
@ $77D8 label=route_prisoner_sleeps_1
B $77D8,2,2 route_prisoner_sleeps_1. #ROUTE($77D8)
@ $77DA label=route_prisoner_sleeps_2
B $77DA,2,2 route_prisoner_sleeps_2. #ROUTE($77DA)
@ $77DC label=route_prisoner_sleeps_3
B $77DC,2,2 route_prisoner_sleeps_3. #ROUTE($77DC)
@ $77DE label=route_77DE
B $77DE,3,3 route_77DE. #ROUTE($77DE)
@ $77E1 label=route_77E1
B $77E1,6,6 route_77E1. #ROUTE($77E1)
@ $77E7 label=route_77E7
B $77E7,5,5 route_77E7. #ROUTE($77E7)
@ $77EC label=route_77EC
B $77EC,5,5 route_77EC. #ROUTE($77EC)
@ $77F1 label=route_prisoner_sits_1
B $77F1,2,2 route_prisoner_sits_1. #ROUTE($77F1)
@ $77F3 label=route_prisoner_sits_2
B $77F3,2,2 route_prisoner_sits_2. #ROUTE($77F3)
@ $77F5 label=route_prisoner_sits_3
B $77F5,2,2 route_prisoner_sits_3. #ROUTE($77F5)
@ $77F7 label=route_guardA_breakfast
B $77F7,2,2 route_guardA_breakfast. #ROUTE($77F7)
@ $77F9 label=route_guardB_breakfast
B $77F9,2,2 route_guardB_breakfast. #ROUTE($77F9)
@ $77FB label=route_guard_12_roll_call
B $77FB,2,2 route_guard_12_roll_call. #ROUTE($77FB)
@ $77FD label=route_guard_13_roll_call
B $77FD,2,2 route_guard_13_roll_call. #ROUTE($77FD)
@ $77FF label=route_guard_14_roll_call
B $77FF,2,2 route_guard_14_roll_call. #ROUTE($77FF)
@ $7801 label=route_guard_15_roll_call
B $7801,2,2 route_guard_15_roll_call. #ROUTE($7801)
@ $7803 label=route_prisoner_1_roll_call
B $7803,2,2 route_prisoner_1_roll_call. #ROUTE($7803)
@ $7805 label=route_prisoner_2_roll_call
B $7805,2,2 route_prisoner_2_roll_call. #ROUTE($7805)
@ $7807 label=route_prisoner_3_roll_call
B $7807,2,2 route_prisoner_3_roll_call. #ROUTE($7807)
@ $7809 label=route_prisoner_4_roll_call
B $7809,2,2 route_prisoner_4_roll_call. #ROUTE($7809)
@ $780B label=route_prisoner_5_roll_call
B $780B,2,2 route_prisoner_5_roll_call. #ROUTE($780B)
@ $780D label=route_prisoner_6_roll_call
B $780D,2,2 route_prisoner_6_roll_call. #ROUTE($780D)
@ $780F label=route_go_to_solitary
B $780F,6,6 route_go_to_solitary. #ROUTE($780F)
@ $7815 label=route_hero_leave_solitary
B $7815,5,5 route_hero_leave_solitary. #ROUTE($7815)
@ $781A label=route_guard_12_bed
B $781A,5,5 route_guard_12_bed. #ROUTE($781A)
@ $781F label=route_guard_13_bed
B $781F,6,6 route_guard_13_bed. #ROUTE($781F)
@ $7825 label=route_guard_14_bed
B $7825,6,6 route_guard_14_bed. #ROUTE($7825)
@ $782B label=route_guard_15_bed
B $782B,6,6 route_guard_15_bed. #ROUTE($782B)
@ $7831 label=route_hut2_left_to_right
B $7831,2,2 route_hut2_left_to_right. #ROUTE($7831)
@ $7833 label=route_7833
B $7833,2,2 route_7833. #ROUTE($7833)
@ $7835 label=route_hut2_right_to_left
B $7835,3,3 route_hut2_right_to_left. #ROUTE($7835)
@ $7838 label=route_hero_roll_call
B $7838,2,2 route_hero_roll_call. #ROUTE($7838)
@ $783A assemble=,0
;
w $783A Table of locations used by routes.
D $783A Array, 78 long, of two-byte locations (index, step).
@ $783A label=locations
@ $783A keep
W $783A,2,2 ( 68, 104)
W $783C,2,2 ( 68,  84)
W $783E,2,2 ( 68,  70)
@ $7840 keep
W $7840,2,2 ( 64, 102)
@ $7842 keep
W $7842,2,2 ( 64,  64)
W $7844,2,2 ( 68,  68)
@ $7846 keep
W $7846,2,2 ( 64,  64)
W $7848,2,2 ( 68,  64)
W $784A,2,2 (104, 112)
@ $784C keep
W $784C,2,2 ( 96, 112)
W $784E,2,2 (106, 102)
W $7850,2,2 ( 93, 104)
@ $7852 keep
W $7852,2,2 (124, 101)
@ $7854 keep
W $7854,2,2 (124, 112)
@ $7856 keep
W $7856,2,2 (116, 104)
@ $7858 keep
W $7858,2,2 (112, 100)
@ $785A keep
W $785A,2,2 (120,  96)
@ $785C keep
W $785C,2,2 (128,  88)
@ $785E keep
W $785E,2,2 (112,  96)
W $7860,2,2 (116,  84)
@ $7862 keep
W $7862,2,2 (124, 100)
@ $7864 keep
W $7864,2,2 (124, 112)
@ $7866 keep
W $7866,2,2 (116, 104)
@ $7868 keep
W $7868,2,2 (112, 100)
W $786A,2,2 (102,  68)
W $786C,2,2 (102,  64)
@ $786E keep
W $786E,2,2 ( 96,  64)
W $7870,2,2 ( 92,  68)
W $7872,2,2 ( 86,  68)
W $7874,2,2 ( 84,  64)
W $7876,2,2 ( 74,  68)
W $7878,2,2 ( 74,  64)
W $787A,2,2 (102,  68)
W $787C,2,2 ( 68,  68)
@ $787E keep
W $787E,2,2 ( 68, 104)
W $7880,2,2 (107,  69)
W $7882,2,2 (107,  45)
W $7884,2,2 ( 77,  45)
W $7886,2,2 ( 77,  61)
W $7888,2,2 ( 61,  61)
W $788A,2,2 ( 61, 103)
W $788C,2,2 (116,  76)
W $788E,2,2 ( 44,  42)
W $7890,2,2 (106,  72)
W $7892,2,2 (110,  72)
W $7894,2,2 ( 81, 104)
W $7896,2,2 ( 52,  60)
W $7898,2,2 ( 52,  44)
W $789A,2,2 ( 52,  28)
W $789C,2,2 (119, 107)
W $789E,2,2 (122, 110)
W $78A0,2,2 ( 52,  28)
W $78A2,2,2 ( 40,  60)
W $78A4,2,2 ( 36,  34)
W $78A6,2,2 ( 80,  76)
W $78A8,2,2 ( 89,  76)
W $78AA,2,2 ( 89,  60)
W $78AC,2,2 (100,  61)
W $78AE,2,2 ( 92,  54)
W $78B0,2,2 ( 84,  50)
W $78B2,2,2 (102,  48)
W $78B4,2,2 ( 96,  56)
W $78B6,2,2 ( 79,  59)
W $78B8,2,2 (103,  47)
W $78BA,2,2 ( 52,  54)
W $78BC,2,2 ( 52,  46)
W $78BE,2,2 ( 52,  36)
W $78C0,2,2 ( 52,  62)
W $78C2,2,2 ( 32,  56)
W $78C4,2,2 ( 52,  24)
W $78C6,2,2 ( 42,  46)
W $78C8,2,2 ( 34,  34)
@ $78CA keep
W $78CA,2,2 (120, 110)
@ $78CC keep
W $78CC,2,2 (118, 110)
W $78CE,2,2 (116, 110)
@ $78D0 keep
W $78D0,2,2 (121, 109)
@ $78D2 keep
W $78D2,2,2 (119, 109)
W $78D4,2,2 (117, 109)
;
b $78D6 Door positions.
D $78D6 62 pairs of four-byte structs laid out as follows:
D $78D6 #TABLE(default) { =h Type | =h Bytes | =h Name | =h Meaning } { Byte | 1 | room_and_direction | bits 0..1 = direction door faces (direction_t); bits 2..7 = target room of door (room_t) } { TinyPos | 3 | pos | Map position of the door } TABLE#
D $78D6 Each door is stored as a pair of two "half doors". Each half of the pair contains (room, direction, position) where the room is the *target* room index, the direction is the direction in which the door faces and the position is the coordinates of the door. Outdoor coordinates are divided by four.
@ $78D6 label=doors
B $78D6,4,4 BYTE(room_0_OUTDOORS,             1), 0xB2, 0x8A, 6 }, // 0
B $78DA,4,4 BYTE(room_0_OUTDOORS,             3), 0xB2, 0x8E, 6 },
B $78DE,4,4 BYTE(room_0_OUTDOORS,             1), 0xB2, 0x7A, 6 },
B $78E2,4,4 BYTE(room_0_OUTDOORS,             3), 0xB2, 0x7E, 6 },
B $78E6,4,4 BYTE(room_34,                     0), 0x8A, 0xB3, 6 },
B $78EA,4,4 BYTE(room_0_OUTDOORS,             2), 0x10, 0x34, 12 },
B $78EE,4,4 BYTE(room_48,                     0), 0xCC, 0x79, 6 },
B $78F2,4,4 BYTE(room_0_OUTDOORS,             2), 0x10, 0x34, 12 },
B $78F6,4,4 BYTE(room_28_HUT1LEFT,            1), 0xD9, 0xA3, 6 },
B $78FA,4,4 BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
B $78FE,4,4 BYTE(room_1_HUT1RIGHT,            0), 0xD4, 0xBD, 6 },
B $7902,4,4 BYTE(room_0_OUTDOORS,             2), 0x1E, 0x2E, 24 },
@ $7906 label=doors_home_to_outside
B $7906,4,4 BYTE(room_2_HUT2LEFT,             1), 0xC1, 0xA3, 6 },
B $790A,4,4 BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
B $790E,4,4 BYTE(room_3_HUT2RIGHT,            0), 0xBC, 0xBD, 6 },
B $7912,4,4 BYTE(room_0_OUTDOORS,             2), 0x20, 0x2E, 24 },
B $7916,4,4 BYTE(room_4_HUT3LEFT,             1), 0xA9, 0xA3, 6 },
B $791A,4,4 BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
B $791E,4,4 BYTE(room_5_HUT3RIGHT,            0), 0xA4, 0xBD, 6 },
B $7922,4,4 BYTE(room_0_OUTDOORS,             2), 0x20, 0x2E, 24 },
B $7926,4,4 BYTE(room_21_CORRIDOR,            0), 0xFC, 0xCA, 6 }, // 10
B $792A,4,4 BYTE(room_0_OUTDOORS,             2), 0x1C, 0x24, 24 },
B $792E,4,4 BYTE(room_20_REDCROSS,            0), 0xFC, 0xDA, 6 },
B $7932,4,4 BYTE(room_0_OUTDOORS,             2), 0x1A, 0x22, 24 },
B $7936,4,4 BYTE(room_15_UNIFORM,             1), 0xF7, 0xE3, 6 },
B $793A,4,4 BYTE(room_0_OUTDOORS,             3), 0x26, 0x19, 24 },
B $793E,4,4 BYTE(room_13_CORRIDOR,            1), 0xDF, 0xE3, 6 },
B $7942,4,4 BYTE(room_0_OUTDOORS,             3), 0x2A, 0x1C, 24 },
B $7946,4,4 BYTE(room_8_CORRIDOR,             1), 0x97, 0xD3, 6 },
B $794A,4,4 BYTE(room_0_OUTDOORS,             3), 0x2A, 0x15, 24 },
@ $794E label=doors_unused
B $794E,4,4 BYTE(room_6,                      1), 0x00, 0x00, 0 },
B $7952,4,4 BYTE(room_0_OUTDOORS,             3), 0x22, 0x22, 24 },
B $7956,4,4 BYTE(room_1_HUT1RIGHT,            1), 0x2C, 0x34, 24 },
B $795A,4,4 BYTE(room_28_HUT1LEFT,            3), 0x26, 0x1A, 24 },
B $795E,4,4 BYTE(room_3_HUT2RIGHT,            1), 0x24, 0x36, 24 },
@ $7962 label=doors_home_to_inside
B $7962,4,4 BYTE(room_2_HUT2LEFT,             3), 0x26, 0x1A, 24 },
B $7966,4,4 BYTE(room_5_HUT3RIGHT,            1), 0x24, 0x36, 24 },
B $796A,4,4 BYTE(room_4_HUT3LEFT,             3), 0x26, 0x1A, 24 },
B $796E,4,4 BYTE(room_23_MESS_HALL,           1), 0x28, 0x42, 24 },
B $7972,4,4 BYTE(room_25_MESS_HALL,           3), 0x26, 0x18, 24 },
B $7976,4,4 BYTE(room_23_MESS_HALL,           0), 0x3E, 0x24, 24 }, // 20
B $797A,4,4 BYTE(room_21_CORRIDOR,            2), 0x20, 0x2E, 24 },
B $797E,4,4 BYTE(room_19_FOOD,                1), 0x22, 0x42, 24 },
B $7982,4,4 BYTE(room_23_MESS_HALL,           3), 0x22, 0x1C, 24 },
B $7986,4,4 BYTE(room_18_RADIO,               1), 0x24, 0x36, 24 },
B $798A,4,4 BYTE(room_19_FOOD,                3), 0x38, 0x22, 24 },
B $798E,4,4 BYTE(room_21_CORRIDOR,            1), 0x2C, 0x36, 24 },
B $7992,4,4 BYTE(room_22_REDKEY,              3), 0x22, 0x1C, 24 },
B $7996,4,4 BYTE(room_22_REDKEY,              1), 0x2C, 0x36, 24 },
B $799A,4,4 BYTE(room_24_SOLITARY,            3), 0x2A, 0x26, 24 },
B $799E,4,4 BYTE(room_12_CORRIDOR,            1), 0x42, 0x3A, 24 },
B $79A2,4,4 BYTE(room_18_RADIO,               3), 0x22, 0x1C, 24 },
B $79A6,4,4 BYTE(room_17_CORRIDOR,            0), 0x3C, 0x24, 24 },
B $79AA,4,4 BYTE(room_7_CORRIDOR,             2), 0x1C, 0x22, 24 },
B $79AE,4,4 BYTE(room_15_UNIFORM,             0), 0x40, 0x28, 24 },
B $79B2,4,4 BYTE(room_14_TORCH,               2), 0x1E, 0x28, 24 },
B $79B6,4,4 BYTE(room_16_CORRIDOR,            1), 0x22, 0x42, 24 },
B $79BA,4,4 BYTE(room_14_TORCH,               3), 0x22, 0x1C, 24 },
B $79BE,4,4 BYTE(room_16_CORRIDOR,            0), 0x3E, 0x2E, 24 },
B $79C2,4,4 BYTE(room_13_CORRIDOR,            2), 0x1A, 0x22, 24 },
B $79C6,4,4 BYTE(room_0_OUTDOORS,             0), 0x44, 0x30, 24 }, // 30
B $79CA,4,4 BYTE(room_0_OUTDOORS,             2), 0x20, 0x30, 24 },
B $79CE,4,4 BYTE(room_13_CORRIDOR,            0), 0x4A, 0x28, 24 },
B $79D2,4,4 BYTE(room_11_PAPERS,              2), 0x1A, 0x22, 24 },
B $79D6,4,4 BYTE(room_7_CORRIDOR,             0), 0x40, 0x24, 24 },
B $79DA,4,4 BYTE(room_16_CORRIDOR,            2), 0x1A, 0x22, 24 },
B $79DE,4,4 BYTE(room_10_LOCKPICK,            0), 0x36, 0x35, 24 },
B $79E2,4,4 BYTE(room_8_CORRIDOR,             2), 0x17, 0x26, 24 },
B $79E6,4,4 BYTE(room_9_CRATE,                0), 0x36, 0x1C, 24 },
B $79EA,4,4 BYTE(room_8_CORRIDOR,             2), 0x1A, 0x22, 24 },
B $79EE,4,4 BYTE(room_12_CORRIDOR,            0), 0x3E, 0x24, 24 },
B $79F2,4,4 BYTE(room_17_CORRIDOR,            2), 0x1A, 0x22, 24 },
B $79F6,4,4 BYTE(room_29_SECOND_TUNNEL_START, 1), 0x36, 0x36, 24 },
B $79FA,4,4 BYTE(room_9_CRATE,                3), 0x38, 0x0A, 12 },
B $79FE,4,4 BYTE(room_52,                     1), 0x38, 0x62, 12 },
B $7A02,4,4 BYTE(room_30,                     3), 0x38, 0x0A, 12 },
B $7A06,4,4 BYTE(room_30,                     0), 0x64, 0x34, 12 },
B $7A0A,4,4 BYTE(room_31,                     2), 0x38, 0x26, 12 },
B $7A0E,4,4 BYTE(room_30,                     1), 0x38, 0x62, 12 },
B $7A12,4,4 BYTE(room_36,                     3), 0x38, 0x0A, 12 },
B $7A16,4,4 BYTE(room_31,                     0), 0x64, 0x34, 12 }, // 40
B $7A1A,4,4 BYTE(room_32,                     2), 0x0A, 0x34, 12 },
B $7A1E,4,4 BYTE(room_32,                     1), 0x38, 0x62, 12 },
B $7A22,4,4 BYTE(room_33,                     3), 0x20, 0x34, 12 },
B $7A26,4,4 BYTE(room_33,                     1), 0x40, 0x34, 12 },
B $7A2A,4,4 BYTE(room_35,                     3), 0x38, 0x0A, 12 },
B $7A2E,4,4 BYTE(room_35,                     0), 0x64, 0x34, 12 },
B $7A32,4,4 BYTE(room_34,                     2), 0x0A, 0x34, 12 },
B $7A36,4,4 BYTE(room_36,                     0), 0x64, 0x34, 12 },
B $7A3A,4,4 BYTE(room_35,                     2), 0x38, 0x1C, 12 },
@ $7A3E label=doors_home_to_tunnel
B $7A3E,4,4 BYTE(room_37,                     0), 0x3E, 0x22, 24 },
B $7A42,4,4 BYTE(room_2_HUT2LEFT,             2), 0x10, 0x34, 12 },
B $7A46,4,4 BYTE(room_38,                     0), 0x64, 0x34, 12 },
B $7A4A,4,4 BYTE(room_37,                     2), 0x10, 0x34, 12 },
B $7A4E,4,4 BYTE(room_39,                     1), 0x40, 0x34, 12 },
B $7A52,4,4 BYTE(room_38,                     3), 0x20, 0x34, 12 },
B $7A56,4,4 BYTE(room_40,                     0), 0x64, 0x34, 12 },
B $7A5A,4,4 BYTE(room_38,                     2), 0x38, 0x54, 12 },
B $7A5E,4,4 BYTE(room_40,                     1), 0x38, 0x62, 12 },
B $7A62,4,4 BYTE(room_41,                     3), 0x38, 0x0A, 12 },
B $7A66,4,4 BYTE(room_41,                     0), 0x64, 0x34, 12 }, // 50
B $7A6A,4,4 BYTE(room_42,                     2), 0x38, 0x26, 12 },
B $7A6E,4,4 BYTE(room_41,                     1), 0x38, 0x62, 12 },
B $7A72,4,4 BYTE(room_45,                     3), 0x38, 0x0A, 12 },
B $7A76,4,4 BYTE(room_45,                     0), 0x64, 0x34, 12 },
B $7A7A,4,4 BYTE(room_44,                     2), 0x38, 0x1C, 12 },
B $7A7E,4,4 BYTE(room_43,                     1), 0x20, 0x34, 12 },
B $7A82,4,4 BYTE(room_44,                     3), 0x38, 0x0A, 12 },
B $7A86,4,4 BYTE(room_42,                     1), 0x38, 0x62, 12 },
B $7A8A,4,4 BYTE(room_43,                     3), 0x20, 0x34, 12 },
B $7A8E,4,4 BYTE(room_46,                     0), 0x64, 0x34, 12 },
B $7A92,4,4 BYTE(room_39,                     2), 0x38, 0x1C, 12 },
B $7A96,4,4 BYTE(room_47,                     1), 0x38, 0x62, 12 },
B $7A9A,4,4 BYTE(room_46,                     3), 0x20, 0x34, 12 },
B $7A9E,4,4 BYTE(room_50_BLOCKED_TUNNEL,      0), 0x64, 0x34, 12 },
B $7AA2,4,4 BYTE(room_47,                     2), 0x38, 0x56, 12 },
B $7AA6,4,4 BYTE(room_50_BLOCKED_TUNNEL,      1), 0x38, 0x62, 12 },
B $7AAA,4,4 BYTE(room_49,                     3), 0x38, 0x0A, 12 },
B $7AAE,4,4 BYTE(room_49,                     0), 0x64, 0x34, 12 },
B $7AB2,4,4 BYTE(room_48,                     2), 0x38, 0x1C, 12 },
B $7AB6,4,4 BYTE(room_51,                     1), 0x38, 0x62, 12 }, // 60
B $7ABA,4,4 BYTE(room_29_SECOND_TUNNEL_START, 3), 0x20, 0x34, 12 },
B $7ABE,4,4 BYTE(room_52,                     0), 0x64, 0x34, 12 },
B $7AC2,4,4 BYTE(room_51,                     2), 0x38, 0x54, 12 },
;
b $7AC6 Solitary map position.
D $7AC6 This is the coordinates (type: tinypos_t) of where our hero stands when he's in solitary.
D $7AC6 Used by #R$CB98.
@ $7AC6 label=solitary_pos
B $7AC6,3,3
;
c $7AC9 Check for 'fire' events.
D $7AC9 This checks for the input events triggered by the fire button: 'pick up', 'drop' and 'use'.
D $7AC9 Used by the routine at #R$9E07.
R $7AC9 I:A Input event (type: input_t).
@ $7AC9 label=process_player_input_fire
C $7AC9,2 Is the input event fire + up?
C $7ACB,3 Test for the next input event if not
C $7ACE,3 Call pick_up_item if so
C $7AD1,2 Then return
C $7AD3,2 Is the input event fire + down?
C $7AD5,3 Test for the next input event if not
C $7AD8,3 Call drop_item if so
C $7ADB,2 Then return
C $7ADD,2 Is the input event fire + left?
C $7ADF,3 Test for the next input event if not
C $7AE2,3 Call use_item_A if so
C $7AE5,2 Then return
C $7AE7,2 Is the input event fire + right?
C $7AE9,3 Test for the next input event if not
C $7AEC,3 Call use_item_B if so
@ $7AEF label=check_for_pick_up_keypress_exit
C $7AEF,1 Return
N $7AF0 Use item 'B'.
@ $7AF0 label=use_item_B
@ $7AF0 isub=LD A,(items_held + 1)
C $7AF0,3 Fetch the second held item
C $7AF3,2 Jump over item 'A' case
N $7AF5 Use item 'A'.
@ $7AF5 label=use_item_A
C $7AF5,3 Fetch the first held item
N $7AF8 Use item common.
@ $7AF8 label=use_item_common
C $7AF8,2 Is the item in #REGa item_NONE? ($FF)
C $7AFA,1 Return if so
C $7AFB,2 Bug: Pointless jump to adjacent instruction
@ $7B01 nowarn
C $7AFD,8 Point #REGhl at the #REGa'th entry of item_actions_jump_table
C $7B05,4 Fetch the jump table destination address
C $7B09,1 Stack the jump table destination address
C $7B0A,11 Copy X,Y and height from the hero's position into saved_pos
C $7B15,1 Jump to the stacked destination address
N $7B16 Item actions jump table.
@ $7B16 label=item_actions_jump_table
W $7B16,8,2
W $7B1E,2,2 Return
W $7B20,4,2
W $7B24,2,2 Return
W $7B26,10,2
W $7B30,2,2 Return
W $7B32,2,2 Return
W $7B34,2,2 Return
;
c $7B36 Pick up an item.
D $7B36 Used by the routine at #R$7AC9.
@ $7B36 label=pick_up_item
C $7B36,3 Load both held items into #REGhl
C $7B39,2 Set #REGa to item_NONE ($FF)
C $7B3B,5 If neither item slot is empty then return - we don't have the space to pick another item up
@ $7B40 label=pick_up_have_empty_slot
C $7B40,3 Find nearby items. #REGhl points to an item in item_structs if found
C $7B43,1 Return if no items were found
N $7B44 Locate an empty item slot.
C $7B44,3 Point #REGde at the held items array
C $7B47,1 Load an item
C $7B48,5 Step over the item if it's item_NONE
C $7B4D,4 Fetch the item_struct item's first byte and mask off the item. Note: The mask used here is $1F, not $0F as seen elsewhere in the code. Unsure why
C $7B51,1 Save the item_struct item pointer
C $7B52,3 Fetch the global current room index
C $7B55,2 Are we outdoors?
C $7B57,3 No - jump to indoor handling
@ $7B5A label=pick_up_outdoors
C $7B5A,3 Plot all tiles
C $7B5D,2 Jump over indoor handling
@ $7B5F label=pick_up_indoors
C $7B5F,3 Expand out the room definition for room_index
C $7B62,3 Render visible tiles array into the screen buffer.
C $7B65,3 Choose game window attributes
C $7B68,3 Set game window attributes
C $7B6B,1 Retrieve the item_struct item pointer
C $7B6C,2 Is the itemstruct_ITEM_FLAG_HELD flag set? ($80)
C $7B6E,2 Jump if so
N $7B70 Have picked up an item not previously held - increase the score.
@ $7B70 label=pick_up_novel_item
C $7B70,2 Set the itemstruct_ITEM_FLAG_HELD flag so we only award these points on the first pick-up
C $7B72,1 Save the item_struct item pointer again
C $7B73,3 Increase morale by 5, score by 5
C $7B76,1 Retrieve again
N $7B77 Make the item disappear.
C $7B77,1 Zero #REGa
C $7B78,2 Zero itemstruct->room_and_flags
C $7B7A,4 Advance #REGhl to itemstruct->iso_pos
C $7B7E,3 Zero itemstruct->iso_pos.screen_x and screen_y
C $7B81,3 Draw held items
C $7B84,6 Play the "pick up item" sound
C $7B8A,1 Return
;
c $7B8B Drop an item.
D $7B8B This drops the hero's first held item then moves the second into the first slot.
D $7B8B Used by the routine at #R$7AC9.
N $7B8B Return if no items are held.
@ $7B8B label=drop_item
C $7B8B,3 Fetch the first held item
C $7B8E,2 Is the item item_NONE? ($FF)
C $7B90,1 Return if so - there are no items to drop
N $7B91 If dropping the uniform reset the hero's sprite.
C $7B91,2 Does #REGa contain item_UNIFORM? (6)
C $7B93,3 Jump if not
C $7B96,6 Set the hero's sprite definition pointer to #R$CE2E to remove the guard's uniform
C $7B9C,1 Save item
N $7B9D Shuffle items down.
@ $7B9D isub=LD HL,items_held + 1
C $7B9D,3 Point #REGhl at the second held item
C $7BA0,1 Fetch its value
C $7BA1,2 Set it to item_NONE
C $7BA3,1 Now point to the first held item
C $7BA4,1 Store the fetched item there
N $7BA5 Redraw the items.
C $7BA5,3 Draw held items
C $7BA8,6 Play the "drop item" sound
C $7BAE,3 Choose game window attributes
C $7BB1,3 Set game window attributes
C $7BB4,1 Restore item
E $7B8B FALL THROUGH into drop_item_tail.
;
c $7BB5 Drop item, tail part.
D $7BB5 This updates the itemstruct with the dropped item. It is its own function so that #R$B387 can make use of it.
D $7BB5 Used by the routine at #R$B387.
R $7BB5 I:A Item index.
@ $7BB5 label=drop_item_tail
C $7BB5,3 Convert the item index in #REGa into an itemstruct pointer in #REGhl
C $7BB8,1 Advance #REGhl to point to the room index
C $7BB9,3 Get the global current room index
C $7BBC,1 Set the object's room index
C $7BBD,1 Is it outdoors? (room index is zero)
C $7BBE,2 Jump if not
N $7BC0 Outdoors.
C $7BC0,1 Point #REGhl at itemstruct.pos
C $7BC1,1 Save for below
C $7BC2,2 Bug: #REGhl is incremented by two here but then is immediately overwritten by the LD HL at $7BC5.
C $7BC4,1 Restore itemstruct.pos pointer into #REGde
C $7BC5,3 Point #REGhl at the hero's map position
C $7BC8,3 Scale down hero's map position (#REGhl) and assign the result to itemstruct's tinypos (#REGde). #REGde is updated to point after tinypos on return
C $7BCB,1 Point at height field
C $7BCC,3 Set height to zero
C $7BCF,1 Move itemstruct pointer into #REGhl
E $7BB5 FALL THROUGH into calc_exterior_item_iso_pos.
;
c $7BD0 Calculate isometric screen position for exterior item.
D $7BD0 Used by the routine at #R$CD31.
R $7BD0 I:HL Pointer to itemstruct's pos.height field.
N $7BD0 Set #REGc to ($40 + y - x) * 2
@ $7BD0 label=calc_exterior_item_iso_pos
C $7BD0,1 Step #REGhl back to itemstruct.pos.y
C $7BD1,2 Start with $40
C $7BD3,1 Add pos.y
C $7BD4,2 Subtract pos.x
C $7BD6,1 Double the result
C $7BD7,1 Save it in #REGc
N $7BD8 Set #REGb to ($200 - x - y - height)
C $7BD8,1 Zero the result; this acts like $200 for our purposes
C $7BD9,1 Subtract pos.x
C $7BDA,2 Subtract pos.y
C $7BDC,2 Subtract pos.height
C $7BDE,1 Save it in #REGb
N $7BDF Write the result to itemstruct.iso_pos
C $7BDF,1 Point #REGhl at itemstruct.iso_pos
C $7BE0,3 Store #REGbc
C $7BE3,1 Return
;
c $7BE4 Drop item, interior part.
D $7BE4 Used by the routine at #R$7BB5.
R $7BE4 I:HL Pointer to itemstruct.room.
@ $7BE4 label=drop_item_interior
C $7BE4,1 Point to itemstruct.x
C $7BE5,3 Point #REGde at the hero's map position.x
C $7BE8,1 Fetch x
C $7BE9,1 Store x in itemstruct.x
C $7BEA,1 Point to itemstruct.y
C $7BEB,2 Point #REGde at the hero's map position.y
C $7BED,1 Fetch y
C $7BEE,1 Store y in itemstruct.y
C $7BEF,1 Point #REGhl at itemstruct.height
C $7BF0,2 Set height to five
E $7BE4 FALL THROUGH into calc_interior_item_iso_pos.
;
c $7BF2 Calculate isometric screen position for interior item.
D $7BF2 Unlike the exterior version of this routine at #R$7BD0, this version scales the result down with rounding to nearest.
D $7BF2 Used by the routine at #R$CD31.
R $7BF2 I:HL Pointer to itemstruct's pos.height field.
N $7BF2 Set #REGa' to ($200 + y - x) * 2
@ $7BF2 label=calc_interior_item_iso_pos
C $7BF2,1 Step #REGhl back to itemstruct.pos.y
C $7BF3,3 Start with $200 + pos.y
C $7BF6,1 Use via #REGde now
C $7BF7,1 Step #REGde back to pos.x
C $7BF8,1 Fetch pos.x
C $7BF9,3 Widen it to 16-bit
C $7BFC,1 Clear carry flag
C $7BFD,2 Subtract (widened) pos.x
C $7BFF,1 Double the result
C $7C00,2 Move result into (#REGc,#REGa)
C $7C02,3 Divide by 8 with rounding. Result is in #REGa
C $7C05,1 Bank x result
N $7C06 Set #REGa to ($800 - x - y - height)
C $7C06,3 Start with $800
C $7C09,4 Load and widen pos.x to 16-bit
C $7C0D,1 Clear carry flag
C $7C0E,2 Subtract (widened) pos.x
C $7C10,1 Advance #REGde to pos.y
C $7C11,2 Load and widen pos.y to 16-bit (#REGb already zero)
C $7C13,2 Subtract (widened) pos.y
C $7C15,1 Advance #REGde to pos.height
C $7C16,2 Load and widen pos.height to 16-bit (#REGb already zero)
C $7C18,2 Subtract (widened) pos.height
C $7C1A,2 Move result into (#REGc,#REGa)
C $7C1C,3 Divide by 8 with rounding. Result is in #REGa
N $7C1F Write the result to itemstruct.iso_pos
C $7C1F,2 Advance #REGde to itemstruct.iso_pos
C $7C21,2 Store #REGa (y result)
C $7C23,1 Unbank x result
C $7C24,1 Store #REGa (x result)
C $7C25,1 Return
;
c $7C26 Item to itemstruct.
D $7C26 This turns an item index to an itemstruct pointer.
D $7C26 Used by the routines at #R$7BB5, #R$A228 and #R$CD31.
R $7C26 I:A Item index (type: item_t).
R $7C26 O:HL Pointer to itemstruct (type: itemstruct_t).
@ $7C26 label=item_to_itemstruct
C $7C26,5 Multiply item index by seven
C $7C2B,3 Point #REGhl at the first element of item_structs
C $7C2E,4 Add the two
C $7C32,1 Return i'th element of item_structs in #REGhl
;
c $7C33 Draw held items.
D $7C33 This draws both held items.
D $7C33 Used by the routines at #R$7B36, #R$7B8B, #R$B107, #R$B387, #R$B3C4, #R$B75A and #R$CB98.
@ $7C33 label=draw_all_items
C $7C33,3 Point #REGhl at the screen address of item 1
C $7C36,3 Fetch the first held item
C $7C39,3 Draw the item
C $7C3C,3 Point #REGhl at the screen address of item 2
C $7C3F,3 Fetch the second held item
C $7C42,3 Draw the item
C $7C45,1 Return
;
c $7C46 Draw a single held item.
D $7C46 This draws the required item at the specified screen address.
D $7C46 Used by the routine at #R$7C33.
R $7C46 I:A Item index (type: item_t).
R $7C46 I:HL Screen address of item.
@ $7C46 label=draw_item
C $7C46,1 Save screen address of item
C $7C47,1 Bank item index
N $7C48 Wipe the item's screen area.
C $7C48,2 2 bytes / pixels wide
C $7C4A,2 16 pixels high
C $7C4C,3 Wipe the screen area pointed to by #REGhl
N $7C4F Bail if no item.
C $7C4F,1 Retrieve screen address
C $7C50,1 Retrieve item index
C $7C51,2 Is the item index item_NONE? ($FF)
C $7C53,1 Return if so
N $7C54 Set screen attributes.
C $7C54,1 Save screen address again
C $7C55,2 Set #REGh to $5A which points #REGhl at the attribute for the equivalent screen address
C $7C57,1 Save item index
C $7C58,9 Get the attribute byte for this item
C $7C61,3 Write two attribute bytes
N $7C64 Move to next attribute row.
C $7C64,1 Move #REGhl back for the next row
C $7C65,2 Move #REGhl to the next attribute row
C $7C67,3 Write two attribute bytes
C $7C6A,1 Retrieve item index
N $7C6B Plot bitmap.
C $7C6B,11 Point #REGhl at the definition for this item
C $7C76,2 Fetch width
C $7C78,2 Fetch height
C $7C7A,3 Fetch sprite data pointer
C $7C7D,1 Retrieve screen address saved at #R$7C54
C $7C7E,3 Plot the bitmap without masking
C $7C81,1 Return
;
c $7C82 Return the first item within range of the hero.
D $7C82 This returns the first item within range of the hero not by distance but by item order. A radius of one is used when outdoors, otherwise a radius of six is used.
D $7C82 Used by the routine at #R$7B36.
R $7C82 O:AF Z set if item found, NZ otherwise.
R $7C82 O:HL If item was found contains pointer to the item.
N $7C82 Select a pick up radius based on the room.
@ $7C82 label=find_nearby_item
C $7C82,2 Set the pick up radius to one
C $7C84,3 Fetch the global current room index
C $7C87,1 Is it room_0_OUTDOORS?
C $7C88,2 Jump if so
C $7C8A,2 Otherwise set the pick up radius to six
N $7C8C Loop for all items.
C $7C8C,2 Set #REGb for 16 iterations (item__LIMIT)
C $7C8E,3 Point #REGhl at the first item_struct's room member
@ $7C91 label=find_nearby_item_loop
C $7C91,2 Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_7 flag set? ($80)
C $7C93,2 If not, jump to the next iteration
C $7C95,1 Save item counter
C $7C96,1 Save item_struct pointer
C $7C97,1 Point #REGhl at itemstruct position
C $7C98,3 Point #REGde at global map position (hero)
C $7C9B,2 Do two loop iterations (once for x then y)
N $7C9D Range check.
@ $7C9D label=find_nearby_position_loop
C $7C9D,1 Read a map position byte
C $7C9E,9 if (map_pos_byte (#REGa) - pick_up_radius (#REGc) >= itemstruct_byte || map_pos_byte + pick_up_radius < itemstruct_byte) jump to pop_next
C $7CA7,1 Move to next itemstruct byte
C $7CA8,1 Move to next map position byte
C $7CA9,2 ...loop for both bytes
C $7CAB,1 Restore item_struct pointer
C $7CAC,1 Compensate for overshoot. Point to itemstruct.item for return value
C $7CAD,1 Restore item counter
C $7CAE,1 Set Z (found)
N $7CAF Bug: The next instruction is written as RET Z but there's no need for it to be conditional.
C $7CAF,1 Return
@ $7CB0 label=find_nearby_pop_next
C $7CB0,1 Restore item_struct pointer
C $7CB1,1 Restore item counter
@ $7CB2 label=find_nearby_next
C $7CB2,7 Step #REGhl to the next item_struct
C $7CB9,2 ...loop for each item
C $7CBB,2 Ran out of items: set NZ (not found)
C $7CBD,1 Return
;
c $7CBE Plot a bitmap without masking.
D $7CBE Used by the routines at #R$7C46, #R$A035 and #R$A0C9.
R $7CBE I:BC Dimensions (#REGb x #REGc == width x height, where width is specified in bytes).
R $7CBE I:DE Source address.
R $7CBE I:HL Destination address.
@ $7CBE label=plot_bitmap
C $7CBE,1 Set #REGa to the byte width of the bitmap
C $7CBF,3 Self modify the width counter at $7CC2 to set #REGb to the byte width
@ $7CC2 label=plot_bitmap_row
C $7CC2,2 Set the column counter to the bitmap width in bytes
C $7CC4,1 Save the destination address
@ $7CC5 label=plot_bitmap_column
C $7CC5,2 Copy a byte across
C $7CC7,1 Step destination address
C $7CC8,1 Step source address
C $7CC9,2 Decrement the column counter then loop for every column
C $7CCB,1 Restore the destination address
C $7CCC,3 Move the destination address down a scanline
C $7CCF,1 Decrement the row counter
C $7CD0,3 ...loop for every row
C $7CD3,1 Return
;
c $7CD4 Wipe an area of the screen.
D $7CD4 Used by the routine at #R$7C46.
R $7CD4 I:BC Dimensions (#REGb x #REGc == width x height, where width is specified in bytes).
R $7CD4 I:HL Destination address.
@ $7CD4 label=screen_wipe
C $7CD4,1 Set #REGa to the byte width of the area to wipe
C $7CD5,3 Self modify the width counter at $7CD8 to set #REGb to the byte width
@ $7CD8 label=screen_wipe_row
C $7CD8,2 Set the column counter to the bitmap width in bytes
C $7CDA,1 Save the destination address
@ $7CDB label=screen_wipe_column
C $7CDB,2 Wipe a byte
C $7CDD,1 Step destination address
C $7CDE,2 Decrement the column counter then loop for every column
C $7CE0,1 Restore the destination address
C $7CE1,3 Move the destination address down a scanline
C $7CE4,1 Decrement the row counter
C $7CE5,3 ...loop for every row
C $7CE8,1 Return
;
c $7CE9 Given a screen address, return the same position on the next scanline down.
D $7CE9 Used by the routines at #R$7CBE, #R$7CD4, #R$A035 and #R$F20B.
R $7CE9 I:HL Original screen address.
R $7CE9 O:HL Updated screen address.
@ $7CE9 label=next_scanline_down
C $7CE9,1 Incrementing #REGh moves us to the next minor row
C $7CEB,2 Unless we hit an exact multiple of eight - in which case we stepped to the next third of the screen
C $7CED,1 Just return if we didn't
C $7CEE,1 Borrow #REGde for scratch
C $7CEF,3 Step back by a third ($F8), then to the next major row ($20)
C $7CF2,3 Unless we will hit a boundary in doing that
C $7CF5,2 Skip, if we won't
C $7CF7,2 If we will then step back by a minor row, then to the next major row
C $7CF9,1 Step
C $7CFA,1 Restore
C $7CFB,1 Return
;
g $7CFC The pending message queue.
@ $7CFC label=message_queue
B $7CFC,19,8*2,3 Queue of message indexes. Pairs of bytes + 0xFF terminator.
;
g $7D0F Countdown to the next message.
@ $7D0F label=message_display_delay
B $7D0F,1,1 Decrementing counter which shows the next message when it reaches zero.
;
g $7D10 Index into the message we're displaying or wiping.
@ $7D10 label=message_display_index
B $7D10,1,1 If 128 then next_message. If > 128 then wipe_message. Else display.
;
g $7D11 Pointer to the next available slot in the message queue.
@ $7D11 label=message_queue_pointer
W $7D11,2,2
;
g $7D13 Pointer to the next message character to be displayed.
@ $7D13 label=current_message_character
W $7D13,2,2
;
c $7D15 Add a new message index to the pending messages queue.
D $7D15 Used by the routines at #R$9DCF, #R$9E98, #R$A1D3, #R$A1E7, #R$A1F0, #R$A1F9, #R$A206, #R$A219, #R$A228, #R$B107, #R$B1D4, #R$B387, #R$B417, #R$B495, #R$B4B8, #R$CB98, #R$CD31 and #R$EF9A.
D $7D15 The use of #REGc on entry to this routine is puzzling. One routine (#R$9DCF) explicitly sets it to zero before calling, but the other callers do not so we receive whatever was in #REGc previously.
R $7D15 I:B Message index.
R $7D15 I:C Unknown: possibly a second message index.
@ $7D15 label=queue_message
C $7D15,3 Fetch the message queue pointer
C $7D18,3 Is the currently pointed-to index message_QUEUE_END? ($FF)
C $7D1B,1 Return if so - the queue is full
N $7D1C Is this message index already pending?
C $7D1C,2 Step back two bytes to the next pending entry
C $7D1E,8 If the new message index matches the pending entry then return
N $7D26 Add it to the queue.
C $7D26,5 Store the new message index
C $7D2B,3 Update the message queue pointer
C $7D2E,1 Return
;
c $7D2F Plot a single glyph (indirectly).
D $7D2F Used by the routines at #R$7D48, #R$A10B, #R$A5BF and #R$F350.
R $7D2F I:HL Pointer to glyph index.
R $7D2F I:DE Pointer to screen destination.
R $7D2F O:HL Preserved.
R $7D2F O:DE Points to the next character position to the right.
@ $7D2F label=plot_glyph
C $7D2F,1 Fetch the glyph index
E $7D2F FALL THROUGH into plot_single_glyph,
;
c $7D30 Plot a single glyph.
D $7D30 Used by the routine at #R$7D87.
D $7D30 Note: This won't work for arbitrary screen locations.
R $7D30 I:HL Glyph index.
R $7D30 I:DE Pointer to screen destination.
R $7D30 O:HL Preserved.
R $7D30 O:DE Points to the next character position to the right.
@ $7D30 label=plot_single_glyph
C $7D30,1 Preserve #REGhl
C $7D31,10 Point #REGhl at the bitmap glyph we want to plot
C $7D3B,1 Preserve #REGde so we can return it incremented later
C $7D3C,2 8 rows
@ $7D3E label=glyph_loop
C $7D3E,2 Plot a byte (a row) of bitmap glyph
C $7D40,1 Move down to the next scanline (#REGde increases by 256)
C $7D41,1 Move to the next byte of the bitmap glyph
C $7D42,2 ...loop until the glyph is drawn
C $7D44,2 Restore and point #REGde at the next character position to the right
C $7D46,1 Restore #REGhl
C $7D47,1 Return
;
c $7D48 Incrementally wipe and display queued game messages.
D $7D48 Used by the routine at #R$9D7B.
N $7D48 Proceed only if message display delay is zero.
@ $7D48 label=message_display
C $7D48,7 If message display delay is positive...
C $7D4F,4 Decrement it - we'll get called again until it hits zero
C $7D53,1 Return
N $7D54 Otherwise message_display_delay reached zero.
C $7D54,7 If message display index == message_NEXT (128) exit via (jump to) next_message
C $7D5B,2 Otherwise if message display index > message_NEXT exit via (jump to) wipe_message
N $7D5D Display a character
C $7D5D,3 Otherwise... point #REGhl to the current message character
@ $7D60 nowarn
C $7D60,5 Point #REGde at the message text screen address plus the display index
C $7D65,3 Plot the glyph
C $7D68,6 Save the incremented message display index
C $7D6E,7 Check for end of string ($FF)
N $7D75 Leave the message for 31 turns, then wipe it.
C $7D75,5 Set message display delay to 31
C $7D7A,8 Set the message_NEXT flag in the message display index
C $7D82,1 Return
@ $7D83 label=not_end_of_string
C $7D83,3 If it wasn't the end of the string set current message character to #REGhl
C $7D86,1 Return
;
c $7D87 Incrementally wipe away any on-screen game message.
D $7D87 Used by the routine at #R$7D48.
@ $7D87 label=wipe_message
C $7D87,7 Decrement the message display index
@ $7D8E nowarn
C $7D8E,5 Point #REGde at the message text screen address plus the display index
N $7D93 Overplot the previous character with a single space.
C $7D93,2 Glyph index of space
C $7D95,3 Plot the single space glyph
C $7D98,1 Return
;
c $7D99 Change to displaying the next queued game message.
D $7D99 Used by the routine at #R$7D48.
D $7D99 Called when messages.display_index == 128.
@ $7D99 label=next_message
C $7D99,3 Get the message queue pointer
C $7D9C,3 Queue start address
C $7D9F,2 Is the queue pointer at the start of the queue?
C $7DA1,1 Return if so
C $7DA3,2 Get message index from queue
C $7DA5,1 Bug: #REGc is loaded here but not used. This could be a hangover from 16-bit message IDs
C $7DA6,15 Set current message character pointer to messages_table[A]
C $7DB5,11 Shunt the whole queue back by two bytes discarding the first element
C $7DC0,8 Move the message queue pointer back
C $7DC8,4 Zero the message display index
C $7DCC,1 Return
;
w $7DCD Array of pointers to game messages.
@ $7DCD label=messages_table
W $7DCD,40,2
t $7DF5 Game messages.
D $7DF5 Non-ASCII: encoded to match the font; $FF terminated.
@ $7DF5 label=messages_missed_roll_call
B $7DF5,17,17 "MISSED ROLL CALL" #HTML[/ #CALL:decode_stringFF($7DF5)]
@ $7E06 label=messages_time_to_wake_up
B $7E06,16,16 "TIME TO WAKE UP" #HTML[/ #CALL:decode_stringFF($7E06)]
@ $7E16 label=messages_breakfast_time
B $7E16,15,15 "BREAKFAST TIME" #HTML[/ #CALL:decode_stringFF($7E16)]
@ $7E25 label=messages_exercise_time
B $7E25,14,14 "EXERCISE TIME" #HTML[/ #CALL:decode_stringFF($7E25)]
@ $7E33 label=messages_time_for_bed
B $7E33,13,13 "TIME FOR BED" #HTML[/ #CALL:decode_stringFF($7E33)]
@ $7E40 label=messages_the_door_is_locked
B $7E40,19,19 "THE DOOR IS LOCKED" #HTML[/ #CALL:decode_stringFF($7E40)]
@ $7E53 label=messages_it_is_open
B $7E53,11,11 "IT IS OPEN" #HTML[/ #CALL:decode_stringFF($7E53)]
@ $7E5E label=messages_incorrect_key
B $7E5E,14,14 "INCORRECT KEY" #HTML[/ #CALL:decode_stringFF($7E5E)]
@ $7E6C label=messages_roll_call
B $7E6C,10,10 "ROLL CALL" #HTML[/ #CALL:decode_stringFF($7E6C)]
@ $7E76 label=messages_red_cross_parcel
B $7E76,17,17 "RED CROSS PARCEL" #HTML[/ #CALL:decode_stringFF($7E76)]
@ $7E87 label=messages_picking_the_lock
B $7E87,17,17 "PICKING THE LOCK" #HTML[/ #CALL:decode_stringFF($7E87)]
@ $7E98 label=messages_cutting_the_wire
B $7E98,17,17 "CUTTING THE WIRE" #HTML[/ #CALL:decode_stringFF($7E98)]
@ $7EA9 label=messages_you_open_the_box
B $7EA9,17,17 "YOU OPEN THE BOX" #HTML[/ #CALL:decode_stringFF($7EA9)]
@ $7EBA label=messages_you_are_in_solitary
B $7EBA,20,20 "YOU ARE IN SOLITARY" #HTML[/ #CALL:decode_stringFF($7EBA)]
@ $7ECE label=messages_wait_for_release
B $7ECE,17,17 "WAIT FOR RELEASE" #HTML[/ #CALL:decode_stringFF($7ECE)]
@ $7EDF label=messages_morale_is_zero
B $7EDF,15,15 "MORALE IS ZERO" #HTML[/ #CALL:decode_stringFF($7EDF)]
@ $7EEE label=messages_item_discovered
B $7EEE,16,16 "ITEM DISCOVERED" #HTML[/ #CALL:decode_stringFF($7EEE)]
;
u $7EFE Unreferenced bytes.
D $7EFE Two alignment bytes to make static_tiles start at $7F00.
B $7EFE,2,2
;
b $7F00 Static tiles.
D $7F00 These tiles are used to draw fixed screen elements such as medals.
D $7F00 9 bytes each: 8x8 bitmap + 1 byte attribute. 75 tiles.
D $7F00 #UDGTABLE { #UDGARRAY75,6,1;$7F00,7;$7F09;$7F12;$7F1B;$7F24;$7F2D;$7F36;$7F3F;$7F48;$7F51;$7F5A;$7F63;$7F6C;$7F75;$7F7E;$7F87;$7F90;$7F99;$7FA2;$7FAB;$7FB4;$7FBD;$7FC6;$7FCF;$7FD8,7;$7FE1,7;$7FEA,7;$7FF3,7;$7FFC,4;$8005,4;$800E,4;$8017,4;$8020,3;$8029,7;$8032,3;$803B,3;$8044,3;$804D,3;$8056,3;$805F,3;$8068,3;$8071,3;$807A,3;$8083,3;$808C,7;$8095,3;$809E,3;$80A7,3;$80B0,3;$80B9,7;$80C2,7;$80CB;$80D4;$80DD;$80E6;$80EF,5;$80F8,5;$8101,4;$810A,4;$8113,4;$811C,7;$8125,7;$812E;$8137;$8140;$8149;$8152,5;$815B,5;$8164,5;$816D,4;$8176;$817F;$8188;$8191;$819A(static-tiles) } TABLE#
@ $7F00 label=static_tiles
B $7F00,9,9 blank
B $7F09,9,9 speaker_tl_tl
B $7F12,9,9 speaker_tl_tr
B $7F1B,9,9 speaker_tl_bl
B $7F24,9,9 speaker_tl_br
B $7F2D,9,9 speaker_tr_tl
B $7F36,9,9 speaker_tr_tr
B $7F3F,9,9 speaker_tr_bl
B $7F48,9,9 speaker_tr_br
B $7F51,9,9 speaker_br_tl
B $7F5A,9,9 speaker_br_tr
B $7F63,9,9 speaker_br_bl
B $7F6C,9,9 speaker_br_br
B $7F75,9,9 speaker_bl_tl
B $7F7E,9,9 speaker_bl_tr
B $7F87,9,9 speaker_bl_bl
B $7F90,9,9 speaker_bl_br
B $7F99,9,9 barbwire_v_top
B $7FA2,9,9 barbwire_v_bottom
B $7FAB,9,9 barbwire_h_left
B $7FB4,9,9 barbwire_h_right
B $7FBD,9,9 barbwire_h_wide_left
B $7FC6,9,9 barbwire_h_wide_middle
B $7FCF,9,9 barbwire_h_wide_right
B $7FD8,9,9 flagpole_top
B $7FE1,9,9 flagpole_middle
B $7FEA,9,9 flagpole_bottom
B $7FF3,9,9 flagpole_ground1
B $7FFC,9,9 flagpole_ground2
B $8005,9,9 flagpole_ground3
B $800E,9,9 flagpole_ground4
B $8017,9,9 flagpole_ground0
B $8020,9,9 medal_0_0
B $8029,9,9 medal_0_1/3/5/7/9
B $8032,9,9 medal_0_2
B $803B,9,9 medal_0_4
B $8044,9,9 medal_0_6
B $804D,9,9 medal_0_8
B $8056,9,9 medal_1_0
B $805F,9,9 medal_1_2
B $8068,9,9 medal_1_4
B $8071,9,9 medal_1_6
B $807A,9,9 medal_1_8
B $8083,9,9 medal_1_10
B $808C,9,9 medal_2_0
B $8095,9,9 medal_2_1/3/5/7/9
B $809E,9,9 medal_2_2
B $80A7,9,9 medal_2_4
B $80B0,9,9 medal_2_6
B $80B9,9,9 medal_2_8
B $80C2,9,9 medal_2_10
B $80CB,9,9 medal_3_0
B $80D4,9,9 medal_3_1
B $80DD,9,9 medal_3_2
B $80E6,9,9 medal_3_3
B $80EF,9,9 medal_3_4
B $80F8,9,9 medal_3_5
B $8101,9,9 medal_3_6
B $810A,9,9 medal_3_7
B $8113,9,9 medal_3_8
B $811C,9,9 medal_3_9
B $8125,9,9 medal_4_0
B $812E,9,9 medal_4_1
B $8137,9,9 medal_4_2
B $8140,9,9 medal_4_3
B $8149,9,9 medal_4_4
B $8152,9,9 medal_4_5
B $815B,9,9 medal_4_6
B $8164,9,9 medal_4_7
B $816D,9,9 medal_4_8
B $8176,9,9 medal_4_9
B $817F,9,9 bell_top_middle
B $8188,9,9 bell_top_right
B $8191,9,9 bell_middle_left
B $819A,9,9 bell_middle_middle
;
u $81A3 Unreferenced byte.
B $81A3,1,1
;
g $81A4 Saved/stashed position.
D $81A4 Structure type: pos_t.
@ $81A4 label=saved_pos_x
@ $81A4 keep
@ $81A6 label=saved_pos_y
@ $81A8 label=saved_height
W $81A4,6,2
;
g $81AA Used by touch() only.
@ $81AA label=touch_stashed_A
B $81AA,1,1
;
u $81AB Unreferenced byte.
B $81AB,1,1
;
g $81AC Bitmap and mask pointers.
@ $81AC label=bitmap_pointer
@ $81AE label=mask_pointer
@ $81B0 label=foreground_mask_pointer
W $81AC,6,2
;
g $81B2 Saved/stashed position.
D $81B2 Structure type: tinypos_t.
D $81B2 Written by setup_item_plotting, setup_vischar_plotting.
D $81B2 Read by render_mask_buffer, guards_follow_suspicious_character.
@ $81B2 label=tinypos_stash_x
@ $81B3 label=tinypos_stash_y
@ $81B4 label=tinypos_stash_height
B $81B2,3,1
;
g $81B5 Current vischar's isometric projected map position.
@ $81B5 label=iso_pos_x
@ $81B6 label=iso_pos_y
B $81B5,2,1
;
g $81B7 Controls character left/right flipping.
@ $81B7 label=flip_sprite
B $81B7,1,1
;
g $81B8 Hero's map position.
D $81B8 Structure type: tinypos_t.
@ $81B8 label=hero_map_position_x
@ $81B9 label=hero_map_position_y
@ $81BA label=hero_map_position_height
B $81B8,3,1
;
g $81BB Map position.
D $81BB Used when drawing tiles.
@ $81BB label=map_position
W $81BB,2,2
;
g $81BD Searchlight state.
D $81BD Suspect that this is a 'hero has been found in searchlight' flag. (possible states: 0, 31, 255)
D $81BD Used by the routines at #R$ADBD, #R$B866.
D $81BD #TABLE(default,centre) { =h Value | =h Meaning } { 0 | Searchlight is sweeping } { 31 | Searchlight is tracking the hero } { 255 | Searchlight is off } TABLE#
@ $81BD label=searchlight_state
B $81BD,1,1
;
g $81BE Copy of first byte of current room def.
D $81BE Indexes roomdef_dimensions[].
@ $81BE label=roomdef_bounds_index
B $81BE,1,1
;
g $81BF Count of object bounds.
@ $81BF label=roomdef_object_bounds_count
B $81BF,1,1
;
g $81C0 Copy of current room def's additional bounds (allows for four room objects).
@ $81C0 label=roomdef_object_bounds
B $81C0,16,4
;
g $81D0 Unreferenced bytes.
D $81D0 These are possibly spare object bounds bytes, but not ever used.
B $81D0,6,6
;
g $81D6 Indices of interior doors.
D $81D6 Used by the routines at #R$69DC, #R$B32D, #R$B4D0.
@ $81D6 label=interior_doors
B $81D6,4,4
;
g $81DA Interior mask data.
D $81DA Used by the routines at #R$6A35 and #R$B916.
D $81DA The first byte is a count, followed by 'count' mask_t's:
D $81DA #TABLE(default) { =h Type   | =h Bytes | =h Name | =h Meaning } { Byte      |        1 | index   | Index into mask_pointers } { bounds_t  |        4 | bounds  | Isometric projected bounds of the mask. Used for culling. } { tinypos_t |        3 | pos     | If a character is behind this point then the mask is enabled. ("Behind" here means when character coord x is greater and y is greater-or-equal). } TABLE#
@ $81DA label=interior_mask_data
B $81DA,57,8*7,1
;
g $8213 Written to by #R$DC41 setup_item_plotting but never read.
@ $8213 label=saved_item
B $8213,1,1
;
g $8214 A copy of item_definition height.
D $8214 Used by the routines at #R$DC41, #R$DD02.
@ $8214 label=item_height
B $8214,1,1
;
g $8215 The items which the hero is holding.
D $8215 Each byte holds one item. Initialised to 0xFFFF meaning no item in either slot.
@ $8215 label=items_held
W $8215,2,2
;
g $8217 The current character index.
@ $8217 label=character_index
B $8217,1,1
;
b $8218 Tiles
D $8218 Exterior tiles set 0. 111 tiles.
@ $8218 label=tiles
@ $8218 label=mask_tiles
B $8218,8,8 #HTML[#UDGARRAY1,7,4,1;$8218-$821F-8(exterior-tiles0-000)]
B $8220,8,8 #HTML[#UDGARRAY1,7,4,1;$8220-$8227-8(exterior-tiles0-001)]
B $8228,8,8 #HTML[#UDGARRAY1,7,4,1;$8228-$822F-8(exterior-tiles0-002)]
B $8230,8,8 #HTML[#UDGARRAY1,7,4,1;$8230-$8237-8(exterior-tiles0-003)]
B $8238,8,8 #HTML[#UDGARRAY1,7,4,1;$8238-$823F-8(exterior-tiles0-004)]
B $8240,8,8 #HTML[#UDGARRAY1,7,4,1;$8240-$8247-8(exterior-tiles0-005)]
B $8248,8,8 #HTML[#UDGARRAY1,7,4,1;$8248-$824F-8(exterior-tiles0-006)]
B $8250,8,8 #HTML[#UDGARRAY1,7,4,1;$8250-$8257-8(exterior-tiles0-007)]
B $8258,8,8 #HTML[#UDGARRAY1,7,4,1;$8258-$825F-8(exterior-tiles0-008)]
B $8260,8,8 #HTML[#UDGARRAY1,7,4,1;$8260-$8267-8(exterior-tiles0-009)]
B $8268,8,8 #HTML[#UDGARRAY1,7,4,1;$8268-$826F-8(exterior-tiles0-010)]
B $8270,8,8 #HTML[#UDGARRAY1,7,4,1;$8270-$8277-8(exterior-tiles0-011)]
B $8278,8,8 #HTML[#UDGARRAY1,7,4,1;$8278-$827F-8(exterior-tiles0-012)]
B $8280,8,8 #HTML[#UDGARRAY1,7,4,1;$8280-$8287-8(exterior-tiles0-013)]
B $8288,8,8 #HTML[#UDGARRAY1,7,4,1;$8288-$828F-8(exterior-tiles0-014)]
B $8290,8,8 #HTML[#UDGARRAY1,7,4,1;$8290-$8297-8(exterior-tiles0-015)]
B $8298,8,8 #HTML[#UDGARRAY1,7,4,1;$8298-$829F-8(exterior-tiles0-016)]
B $82A0,8,8 #HTML[#UDGARRAY1,7,4,1;$82A0-$82A7-8(exterior-tiles0-017)]
B $82A8,8,8 #HTML[#UDGARRAY1,7,4,1;$82A8-$82AF-8(exterior-tiles0-018)]
B $82B0,8,8 #HTML[#UDGARRAY1,7,4,1;$82B0-$82B7-8(exterior-tiles0-019)]
B $82B8,8,8 #HTML[#UDGARRAY1,7,4,1;$82B8-$82BF-8(exterior-tiles0-020)]
B $82C0,8,8 #HTML[#UDGARRAY1,7,4,1;$82C0-$82C7-8(exterior-tiles0-021)]
B $82C8,8,8 #HTML[#UDGARRAY1,7,4,1;$82C8-$82CF-8(exterior-tiles0-022)]
B $82D0,8,8 #HTML[#UDGARRAY1,7,4,1;$82D0-$82D7-8(exterior-tiles0-023)]
B $82D8,8,8 #HTML[#UDGARRAY1,7,4,1;$82D8-$82DF-8(exterior-tiles0-024)]
B $82E0,8,8 #HTML[#UDGARRAY1,7,4,1;$82E0-$82E7-8(exterior-tiles0-025)]
B $82E8,8,8 #HTML[#UDGARRAY1,7,4,1;$82E8-$82EF-8(exterior-tiles0-026)]
B $82F0,8,8 #HTML[#UDGARRAY1,7,4,1;$82F0-$82F7-8(exterior-tiles0-027)]
B $82F8,8,8 #HTML[#UDGARRAY1,7,4,1;$82F8-$82FF-8(exterior-tiles0-028)]
B $8300,8,8 #HTML[#UDGARRAY1,7,4,1;$8300-$8307-8(exterior-tiles0-029)]
B $8308,8,8 #HTML[#UDGARRAY1,7,4,1;$8308-$830F-8(exterior-tiles0-030)]
B $8310,8,8 #HTML[#UDGARRAY1,7,4,1;$8310-$8317-8(exterior-tiles0-031)]
B $8318,8,8 #HTML[#UDGARRAY1,7,4,1;$8318-$831F-8(exterior-tiles0-032)]
B $8320,8,8 #HTML[#UDGARRAY1,7,4,1;$8320-$8327-8(exterior-tiles0-033)]
B $8328,8,8 #HTML[#UDGARRAY1,7,4,1;$8328-$832F-8(exterior-tiles0-034)]
B $8330,8,8 #HTML[#UDGARRAY1,7,4,1;$8330-$8337-8(exterior-tiles0-035)]
B $8338,8,8 #HTML[#UDGARRAY1,7,4,1;$8338-$833F-8(exterior-tiles0-036)]
B $8340,8,8 #HTML[#UDGARRAY1,7,4,1;$8340-$8347-8(exterior-tiles0-037)]
B $8348,8,8 #HTML[#UDGARRAY1,7,4,1;$8348-$834F-8(exterior-tiles0-038)]
B $8350,8,8 #HTML[#UDGARRAY1,7,4,1;$8350-$8357-8(exterior-tiles0-039)]
B $8358,8,8 #HTML[#UDGARRAY1,7,4,1;$8358-$835F-8(exterior-tiles0-040)]
B $8360,8,8 #HTML[#UDGARRAY1,7,4,1;$8360-$8367-8(exterior-tiles0-041)]
B $8368,8,8 #HTML[#UDGARRAY1,7,4,1;$8368-$836F-8(exterior-tiles0-042)]
B $8370,8,8 #HTML[#UDGARRAY1,7,4,1;$8370-$8377-8(exterior-tiles0-043)]
B $8378,8,8 #HTML[#UDGARRAY1,7,4,1;$8378-$837F-8(exterior-tiles0-044)]
B $8380,8,8 #HTML[#UDGARRAY1,7,4,1;$8380-$8387-8(exterior-tiles0-045)]
B $8388,8,8 #HTML[#UDGARRAY1,7,4,1;$8388-$838F-8(exterior-tiles0-046)]
B $8390,8,8 #HTML[#UDGARRAY1,7,4,1;$8390-$8397-8(exterior-tiles0-047)]
B $8398,8,8 #HTML[#UDGARRAY1,7,4,1;$8398-$839F-8(exterior-tiles0-048)]
B $83A0,8,8 #HTML[#UDGARRAY1,7,4,1;$83A0-$83A7-8(exterior-tiles0-049)]
B $83A8,8,8 #HTML[#UDGARRAY1,7,4,1;$83A8-$83AF-8(exterior-tiles0-050)]
B $83B0,8,8 #HTML[#UDGARRAY1,7,4,1;$83B0-$83B7-8(exterior-tiles0-051)]
B $83B8,8,8 #HTML[#UDGARRAY1,7,4,1;$83B8-$83BF-8(exterior-tiles0-052)]
B $83C0,8,8 #HTML[#UDGARRAY1,7,4,1;$83C0-$83C7-8(exterior-tiles0-053)]
B $83C8,8,8 #HTML[#UDGARRAY1,7,4,1;$83C8-$83CF-8(exterior-tiles0-054)]
B $83D0,8,8 #HTML[#UDGARRAY1,7,4,1;$83D0-$83D7-8(exterior-tiles0-055)]
B $83D8,8,8 #HTML[#UDGARRAY1,7,4,1;$83D8-$83DF-8(exterior-tiles0-056)]
B $83E0,8,8 #HTML[#UDGARRAY1,7,4,1;$83E0-$83E7-8(exterior-tiles0-057)]
B $83E8,8,8 #HTML[#UDGARRAY1,7,4,1;$83E8-$83EF-8(exterior-tiles0-058)]
B $83F0,8,8 #HTML[#UDGARRAY1,7,4,1;$83F0-$83F7-8(exterior-tiles0-059)]
B $83F8,8,8 #HTML[#UDGARRAY1,7,4,1;$83F8-$83FF-8(exterior-tiles0-060)]
B $8400,8,8 #HTML[#UDGARRAY1,7,4,1;$8400-$8407-8(exterior-tiles0-061)]
B $8408,8,8 #HTML[#UDGARRAY1,7,4,1;$8408-$840F-8(exterior-tiles0-062)]
B $8410,8,8 #HTML[#UDGARRAY1,7,4,1;$8410-$8417-8(exterior-tiles0-063)]
B $8418,8,8 #HTML[#UDGARRAY1,7,4,1;$8418-$841F-8(exterior-tiles0-064)]
B $8420,8,8 #HTML[#UDGARRAY1,7,4,1;$8420-$8427-8(exterior-tiles0-065)]
B $8428,8,8 #HTML[#UDGARRAY1,7,4,1;$8428-$842F-8(exterior-tiles0-066)]
B $8430,8,8 #HTML[#UDGARRAY1,7,4,1;$8430-$8437-8(exterior-tiles0-067)]
B $8438,8,8 #HTML[#UDGARRAY1,7,4,1;$8438-$843F-8(exterior-tiles0-068)]
B $8440,8,8 #HTML[#UDGARRAY1,7,4,1;$8440-$8447-8(exterior-tiles0-069)]
B $8448,8,8 #HTML[#UDGARRAY1,7,4,1;$8448-$844F-8(exterior-tiles0-070)]
B $8450,8,8 #HTML[#UDGARRAY1,7,4,1;$8450-$8457-8(exterior-tiles0-071)]
B $8458,8,8 #HTML[#UDGARRAY1,7,4,1;$8458-$845F-8(exterior-tiles0-072)]
B $8460,8,8 #HTML[#UDGARRAY1,7,4,1;$8460-$8467-8(exterior-tiles0-073)]
B $8468,8,8 #HTML[#UDGARRAY1,7,4,1;$8468-$846F-8(exterior-tiles0-074)]
B $8470,8,8 #HTML[#UDGARRAY1,7,4,1;$8470-$8477-8(exterior-tiles0-075)]
B $8478,8,8 #HTML[#UDGARRAY1,7,4,1;$8478-$847F-8(exterior-tiles0-076)]
B $8480,8,8 #HTML[#UDGARRAY1,7,4,1;$8480-$8487-8(exterior-tiles0-077)]
B $8488,8,8 #HTML[#UDGARRAY1,7,4,1;$8488-$848F-8(exterior-tiles0-078)]
B $8490,8,8 #HTML[#UDGARRAY1,7,4,1;$8490-$8497-8(exterior-tiles0-079)]
B $8498,8,8 #HTML[#UDGARRAY1,7,4,1;$8498-$849F-8(exterior-tiles0-080)]
B $84A0,8,8 #HTML[#UDGARRAY1,7,4,1;$84A0-$84A7-8(exterior-tiles0-081)]
B $84A8,8,8 #HTML[#UDGARRAY1,7,4,1;$84A8-$84AF-8(exterior-tiles0-082)]
B $84B0,8,8 #HTML[#UDGARRAY1,7,4,1;$84B0-$84B7-8(exterior-tiles0-083)]
B $84B8,8,8 #HTML[#UDGARRAY1,7,4,1;$84B8-$84BF-8(exterior-tiles0-084)]
B $84C0,8,8 #HTML[#UDGARRAY1,7,4,1;$84C0-$84C7-8(exterior-tiles0-085)]
B $84C8,8,8 #HTML[#UDGARRAY1,7,4,1;$84C8-$84CF-8(exterior-tiles0-086)]
B $84D0,8,8 #HTML[#UDGARRAY1,7,4,1;$84D0-$84D7-8(exterior-tiles0-087)]
B $84D8,8,8 #HTML[#UDGARRAY1,7,4,1;$84D8-$84DF-8(exterior-tiles0-088)]
B $84E0,8,8 #HTML[#UDGARRAY1,7,4,1;$84E0-$84E7-8(exterior-tiles0-089)]
B $84E8,8,8 #HTML[#UDGARRAY1,7,4,1;$84E8-$84EF-8(exterior-tiles0-090)]
B $84F0,8,8 #HTML[#UDGARRAY1,7,4,1;$84F0-$84F7-8(exterior-tiles0-091)]
B $84F8,8,8 #HTML[#UDGARRAY1,7,4,1;$84F8-$84FF-8(exterior-tiles0-092)]
B $8500,8,8 #HTML[#UDGARRAY1,7,4,1;$8500-$8507-8(exterior-tiles0-093)]
B $8508,8,8 #HTML[#UDGARRAY1,7,4,1;$8508-$850F-8(exterior-tiles0-094)]
B $8510,8,8 #HTML[#UDGARRAY1,7,4,1;$8510-$8517-8(exterior-tiles0-095)]
B $8518,8,8 #HTML[#UDGARRAY1,7,4,1;$8518-$851F-8(exterior-tiles0-096)]
B $8520,8,8 #HTML[#UDGARRAY1,7,4,1;$8520-$8527-8(exterior-tiles0-097)]
B $8528,8,8 #HTML[#UDGARRAY1,7,4,1;$8528-$852F-8(exterior-tiles0-098)]
B $8530,8,8 #HTML[#UDGARRAY1,7,4,1;$8530-$8537-8(exterior-tiles0-099)]
B $8538,8,8 #HTML[#UDGARRAY1,7,4,1;$8538-$853F-8(exterior-tiles0-100)]
B $8540,8,8 #HTML[#UDGARRAY1,7,4,1;$8540-$8547-8(exterior-tiles0-101)]
B $8548,8,8 #HTML[#UDGARRAY1,7,4,1;$8548-$854F-8(exterior-tiles0-102)]
B $8550,8,8 #HTML[#UDGARRAY1,7,4,1;$8550-$8557-8(exterior-tiles0-103)]
B $8558,8,8 #HTML[#UDGARRAY1,7,4,1;$8558-$855F-8(exterior-tiles0-104)]
B $8560,8,8 #HTML[#UDGARRAY1,7,4,1;$8560-$8567-8(exterior-tiles0-105)]
B $8568,8,8 #HTML[#UDGARRAY1,7,4,1;$8568-$856F-8(exterior-tiles0-106)]
B $8570,8,8 #HTML[#UDGARRAY1,7,4,1;$8570-$8577-8(exterior-tiles0-107)]
B $8578,8,8 #HTML[#UDGARRAY1,7,4,1;$8578-$857F-8(exterior-tiles0-108)]
B $8580,8,8 #HTML[#UDGARRAY1,7,4,1;$8580-$8587-8(exterior-tiles0-109)]
B $8588,8,8 #HTML[#UDGARRAY1,7,4,1;$8588-$858F-8(exterior-tiles0-110)]
N $8590 Exterior tiles. 145 + 220 + 206 tiles. (<- plot_tile)
@ $8590 label=exterior_tiles
B $8590,8,8 #HTML[#UDGARRAY1,7,4,1;$8590-$8597-8(exterior-tiles1-000)]
B $8598,8,8 #HTML[#UDGARRAY1,7,4,1;$8598-$859F-8(exterior-tiles1-001)]
B $85A0,8,8 #HTML[#UDGARRAY1,7,4,1;$85A0-$85A7-8(exterior-tiles1-002)]
B $85A8,8,8 #HTML[#UDGARRAY1,7,4,1;$85A8-$85AF-8(exterior-tiles1-003)]
B $85B0,8,8 #HTML[#UDGARRAY1,7,4,1;$85B0-$85B7-8(exterior-tiles1-004)]
B $85B8,8,8 #HTML[#UDGARRAY1,7,4,1;$85B8-$85BF-8(exterior-tiles1-005)]
B $85C0,8,8 #HTML[#UDGARRAY1,7,4,1;$85C0-$85C7-8(exterior-tiles1-006)]
B $85C8,8,8 #HTML[#UDGARRAY1,7,4,1;$85C8-$85CF-8(exterior-tiles1-007)]
B $85D0,8,8 #HTML[#UDGARRAY1,7,4,1;$85D0-$85D7-8(exterior-tiles1-008)]
B $85D8,8,8 #HTML[#UDGARRAY1,7,4,1;$85D8-$85DF-8(exterior-tiles1-009)]
B $85E0,8,8 #HTML[#UDGARRAY1,7,4,1;$85E0-$85E7-8(exterior-tiles1-010)]
B $85E8,8,8 #HTML[#UDGARRAY1,7,4,1;$85E8-$85EF-8(exterior-tiles1-011)]
B $85F0,8,8 #HTML[#UDGARRAY1,7,4,1;$85F0-$85F7-8(exterior-tiles1-012)]
B $85F8,8,8 #HTML[#UDGARRAY1,7,4,1;$85F8-$85FF-8(exterior-tiles1-013)]
B $8600,8,8 #HTML[#UDGARRAY1,7,4,1;$8600-$8607-8(exterior-tiles1-014)]
B $8608,8,8 #HTML[#UDGARRAY1,7,4,1;$8608-$860F-8(exterior-tiles1-015)]
B $8610,8,8 #HTML[#UDGARRAY1,7,4,1;$8610-$8617-8(exterior-tiles1-016)]
B $8618,8,8 #HTML[#UDGARRAY1,7,4,1;$8618-$861F-8(exterior-tiles1-017)]
B $8620,8,8 #HTML[#UDGARRAY1,7,4,1;$8620-$8627-8(exterior-tiles1-018)]
B $8628,8,8 #HTML[#UDGARRAY1,7,4,1;$8628-$862F-8(exterior-tiles1-019)]
B $8630,8,8 #HTML[#UDGARRAY1,7,4,1;$8630-$8637-8(exterior-tiles1-020)]
B $8638,8,8 #HTML[#UDGARRAY1,7,4,1;$8638-$863F-8(exterior-tiles1-021)]
B $8640,8,8 #HTML[#UDGARRAY1,7,4,1;$8640-$8647-8(exterior-tiles1-022)]
B $8648,8,8 #HTML[#UDGARRAY1,7,4,1;$8648-$864F-8(exterior-tiles1-023)]
B $8650,8,8 #HTML[#UDGARRAY1,7,4,1;$8650-$8657-8(exterior-tiles1-024)]
B $8658,8,8 #HTML[#UDGARRAY1,7,4,1;$8658-$865F-8(exterior-tiles1-025)]
B $8660,8,8 #HTML[#UDGARRAY1,7,4,1;$8660-$8667-8(exterior-tiles1-026)]
B $8668,8,8 #HTML[#UDGARRAY1,7,4,1;$8668-$866F-8(exterior-tiles1-027)]
B $8670,8,8 #HTML[#UDGARRAY1,7,4,1;$8670-$8677-8(exterior-tiles1-028)]
B $8678,8,8 #HTML[#UDGARRAY1,7,4,1;$8678-$867F-8(exterior-tiles1-029)]
B $8680,8,8 #HTML[#UDGARRAY1,7,4,1;$8680-$8687-8(exterior-tiles1-030)]
B $8688,8,8 #HTML[#UDGARRAY1,7,4,1;$8688-$868F-8(exterior-tiles1-031)]
B $8690,8,8 #HTML[#UDGARRAY1,7,4,1;$8690-$8697-8(exterior-tiles1-032)]
B $8698,8,8 #HTML[#UDGARRAY1,7,4,1;$8698-$869F-8(exterior-tiles1-033)]
B $86A0,8,8 #HTML[#UDGARRAY1,7,4,1;$86A0-$86A7-8(exterior-tiles1-034)]
B $86A8,8,8 #HTML[#UDGARRAY1,7,4,1;$86A8-$86AF-8(exterior-tiles1-035)]
B $86B0,8,8 #HTML[#UDGARRAY1,7,4,1;$86B0-$86B7-8(exterior-tiles1-036)]
B $86B8,8,8 #HTML[#UDGARRAY1,7,4,1;$86B8-$86BF-8(exterior-tiles1-037)]
B $86C0,8,8 #HTML[#UDGARRAY1,7,4,1;$86C0-$86C7-8(exterior-tiles1-038)]
B $86C8,8,8 #HTML[#UDGARRAY1,7,4,1;$86C8-$86CF-8(exterior-tiles1-039)]
B $86D0,8,8 #HTML[#UDGARRAY1,7,4,1;$86D0-$86D7-8(exterior-tiles1-040)]
B $86D8,8,8 #HTML[#UDGARRAY1,7,4,1;$86D8-$86DF-8(exterior-tiles1-041)]
B $86E0,8,8 #HTML[#UDGARRAY1,7,4,1;$86E0-$86E7-8(exterior-tiles1-042)]
B $86E8,8,8 #HTML[#UDGARRAY1,7,4,1;$86E8-$86EF-8(exterior-tiles1-043)]
B $86F0,8,8 #HTML[#UDGARRAY1,7,4,1;$86F0-$86F7-8(exterior-tiles1-044)]
B $86F8,8,8 #HTML[#UDGARRAY1,7,4,1;$86F8-$86FF-8(exterior-tiles1-045)]
B $8700,8,8 #HTML[#UDGARRAY1,7,4,1;$8700-$8707-8(exterior-tiles1-046)]
B $8708,8,8 #HTML[#UDGARRAY1,7,4,1;$8708-$870F-8(exterior-tiles1-047)]
B $8710,8,8 #HTML[#UDGARRAY1,7,4,1;$8710-$8717-8(exterior-tiles1-048)]
B $8718,8,8 #HTML[#UDGARRAY1,7,4,1;$8718-$871F-8(exterior-tiles1-049)]
B $8720,8,8 #HTML[#UDGARRAY1,7,4,1;$8720-$8727-8(exterior-tiles1-050)]
B $8728,8,8 #HTML[#UDGARRAY1,7,4,1;$8728-$872F-8(exterior-tiles1-051)]
B $8730,8,8 #HTML[#UDGARRAY1,7,4,1;$8730-$8737-8(exterior-tiles1-052)]
B $8738,8,8 #HTML[#UDGARRAY1,7,4,1;$8738-$873F-8(exterior-tiles1-053)]
B $8740,8,8 #HTML[#UDGARRAY1,7,4,1;$8740-$8747-8(exterior-tiles1-054)]
B $8748,8,8 #HTML[#UDGARRAY1,7,4,1;$8748-$874F-8(exterior-tiles1-055)]
B $8750,8,8 #HTML[#UDGARRAY1,7,4,1;$8750-$8757-8(exterior-tiles1-056)]
B $8758,8,8 #HTML[#UDGARRAY1,7,4,1;$8758-$875F-8(exterior-tiles1-057)]
B $8760,8,8 #HTML[#UDGARRAY1,7,4,1;$8760-$8767-8(exterior-tiles1-058)]
B $8768,8,8 #HTML[#UDGARRAY1,7,4,1;$8768-$876F-8(exterior-tiles1-059)]
B $8770,8,8 #HTML[#UDGARRAY1,7,4,1;$8770-$8777-8(exterior-tiles1-060)]
B $8778,8,8 #HTML[#UDGARRAY1,7,4,1;$8778-$877F-8(exterior-tiles1-061)]
B $8780,8,8 #HTML[#UDGARRAY1,7,4,1;$8780-$8787-8(exterior-tiles1-062)]
B $8788,8,8 #HTML[#UDGARRAY1,7,4,1;$8788-$878F-8(exterior-tiles1-063)]
B $8790,8,8 #HTML[#UDGARRAY1,7,4,1;$8790-$8797-8(exterior-tiles1-064)]
B $8798,8,8 #HTML[#UDGARRAY1,7,4,1;$8798-$879F-8(exterior-tiles1-065)]
B $87A0,8,8 #HTML[#UDGARRAY1,7,4,1;$87A0-$87A7-8(exterior-tiles1-066)]
B $87A8,8,8 #HTML[#UDGARRAY1,7,4,1;$87A8-$87AF-8(exterior-tiles1-067)]
B $87B0,8,8 #HTML[#UDGARRAY1,7,4,1;$87B0-$87B7-8(exterior-tiles1-068)]
B $87B8,8,8 #HTML[#UDGARRAY1,7,4,1;$87B8-$87BF-8(exterior-tiles1-069)]
B $87C0,8,8 #HTML[#UDGARRAY1,7,4,1;$87C0-$87C7-8(exterior-tiles1-070)]
B $87C8,8,8 #HTML[#UDGARRAY1,7,4,1;$87C8-$87CF-8(exterior-tiles1-071)]
B $87D0,8,8 #HTML[#UDGARRAY1,7,4,1;$87D0-$87D7-8(exterior-tiles1-072)]
B $87D8,8,8 #HTML[#UDGARRAY1,7,4,1;$87D8-$87DF-8(exterior-tiles1-073)]
B $87E0,8,8 #HTML[#UDGARRAY1,7,4,1;$87E0-$87E7-8(exterior-tiles1-074)]
B $87E8,8,8 #HTML[#UDGARRAY1,7,4,1;$87E8-$87EF-8(exterior-tiles1-075)]
B $87F0,8,8 #HTML[#UDGARRAY1,7,4,1;$87F0-$87F7-8(exterior-tiles1-076)]
B $87F8,8,8 #HTML[#UDGARRAY1,7,4,1;$87F8-$87FF-8(exterior-tiles1-077)]
B $8800,8,8 #HTML[#UDGARRAY1,7,4,1;$8800-$8807-8(exterior-tiles1-078)]
B $8808,8,8 #HTML[#UDGARRAY1,7,4,1;$8808-$880F-8(exterior-tiles1-079)]
B $8810,8,8 #HTML[#UDGARRAY1,7,4,1;$8810-$8817-8(exterior-tiles1-080)]
B $8818,8,8 #HTML[#UDGARRAY1,7,4,1;$8818-$881F-8(exterior-tiles1-081)]
B $8820,8,8 #HTML[#UDGARRAY1,7,4,1;$8820-$8827-8(exterior-tiles1-082)]
B $8828,8,8 #HTML[#UDGARRAY1,7,4,1;$8828-$882F-8(exterior-tiles1-083)]
B $8830,8,8 #HTML[#UDGARRAY1,7,4,1;$8830-$8837-8(exterior-tiles1-084)]
B $8838,8,8 #HTML[#UDGARRAY1,7,4,1;$8838-$883F-8(exterior-tiles1-085)]
B $8840,8,8 #HTML[#UDGARRAY1,7,4,1;$8840-$8847-8(exterior-tiles1-086)]
B $8848,8,8 #HTML[#UDGARRAY1,7,4,1;$8848-$884F-8(exterior-tiles1-087)]
B $8850,8,8 #HTML[#UDGARRAY1,7,4,1;$8850-$8857-8(exterior-tiles1-088)]
B $8858,8,8 #HTML[#UDGARRAY1,7,4,1;$8858-$885F-8(exterior-tiles1-089)]
B $8860,8,8 #HTML[#UDGARRAY1,7,4,1;$8860-$8867-8(exterior-tiles1-090)]
B $8868,8,8 #HTML[#UDGARRAY1,7,4,1;$8868-$886F-8(exterior-tiles1-091)]
B $8870,8,8 #HTML[#UDGARRAY1,7,4,1;$8870-$8877-8(exterior-tiles1-092)]
B $8878,8,8 #HTML[#UDGARRAY1,7,4,1;$8878-$887F-8(exterior-tiles1-093)]
B $8880,8,8 #HTML[#UDGARRAY1,7,4,1;$8880-$8887-8(exterior-tiles1-094)]
B $8888,8,8 #HTML[#UDGARRAY1,7,4,1;$8888-$888F-8(exterior-tiles1-095)]
B $8890,8,8 #HTML[#UDGARRAY1,7,4,1;$8890-$8897-8(exterior-tiles1-096)]
B $8898,8,8 #HTML[#UDGARRAY1,7,4,1;$8898-$889F-8(exterior-tiles1-097)]
B $88A0,8,8 #HTML[#UDGARRAY1,7,4,1;$88A0-$88A7-8(exterior-tiles1-098)]
B $88A8,8,8 #HTML[#UDGARRAY1,7,4,1;$88A8-$88AF-8(exterior-tiles1-099)]
B $88B0,8,8 #HTML[#UDGARRAY1,7,4,1;$88B0-$88B7-8(exterior-tiles1-100)]
B $88B8,8,8 #HTML[#UDGARRAY1,7,4,1;$88B8-$88BF-8(exterior-tiles1-101)]
B $88C0,8,8 #HTML[#UDGARRAY1,7,4,1;$88C0-$88C7-8(exterior-tiles1-102)]
B $88C8,8,8 #HTML[#UDGARRAY1,7,4,1;$88C8-$88CF-8(exterior-tiles1-103)]
B $88D0,8,8 #HTML[#UDGARRAY1,7,4,1;$88D0-$88D7-8(exterior-tiles1-104)]
B $88D8,8,8 #HTML[#UDGARRAY1,7,4,1;$88D8-$88DF-8(exterior-tiles1-105)]
B $88E0,8,8 #HTML[#UDGARRAY1,7,4,1;$88E0-$88E7-8(exterior-tiles1-106)]
B $88E8,8,8 #HTML[#UDGARRAY1,7,4,1;$88E8-$88EF-8(exterior-tiles1-107)]
B $88F0,8,8 #HTML[#UDGARRAY1,7,4,1;$88F0-$88F7-8(exterior-tiles1-108)]
B $88F8,8,8 #HTML[#UDGARRAY1,7,4,1;$88F8-$88FF-8(exterior-tiles1-109)]
B $8900,8,8 #HTML[#UDGARRAY1,7,4,1;$8900-$8907-8(exterior-tiles1-110)]
B $8908,8,8 #HTML[#UDGARRAY1,7,4,1;$8908-$890F-8(exterior-tiles1-111)]
B $8910,8,8 #HTML[#UDGARRAY1,7,4,1;$8910-$8917-8(exterior-tiles1-112)]
B $8918,8,8 #HTML[#UDGARRAY1,7,4,1;$8918-$891F-8(exterior-tiles1-113)]
B $8920,8,8 #HTML[#UDGARRAY1,7,4,1;$8920-$8927-8(exterior-tiles1-114)]
B $8928,8,8 #HTML[#UDGARRAY1,7,4,1;$8928-$892F-8(exterior-tiles1-115)]
B $8930,8,8 #HTML[#UDGARRAY1,7,4,1;$8930-$8937-8(exterior-tiles1-116)]
B $8938,8,8 #HTML[#UDGARRAY1,7,4,1;$8938-$893F-8(exterior-tiles1-117)]
B $8940,8,8 #HTML[#UDGARRAY1,7,4,1;$8940-$8947-8(exterior-tiles1-118)]
B $8948,8,8 #HTML[#UDGARRAY1,7,4,1;$8948-$894F-8(exterior-tiles1-119)]
B $8950,8,8 #HTML[#UDGARRAY1,7,4,1;$8950-$8957-8(exterior-tiles1-120)]
B $8958,8,8 #HTML[#UDGARRAY1,7,4,1;$8958-$895F-8(exterior-tiles1-121)]
B $8960,8,8 #HTML[#UDGARRAY1,7,4,1;$8960-$8967-8(exterior-tiles1-122)]
B $8968,8,8 #HTML[#UDGARRAY1,7,4,1;$8968-$896F-8(exterior-tiles1-123)]
B $8970,8,8 #HTML[#UDGARRAY1,7,4,1;$8970-$8977-8(exterior-tiles1-124)]
B $8978,8,8 #HTML[#UDGARRAY1,7,4,1;$8978-$897F-8(exterior-tiles1-125)]
B $8980,8,8 #HTML[#UDGARRAY1,7,4,1;$8980-$8987-8(exterior-tiles1-126)]
B $8988,8,8 #HTML[#UDGARRAY1,7,4,1;$8988-$898F-8(exterior-tiles1-127)]
B $8990,8,8 #HTML[#UDGARRAY1,7,4,1;$8990-$8997-8(exterior-tiles1-128)]
B $8998,8,8 #HTML[#UDGARRAY1,7,4,1;$8998-$899F-8(exterior-tiles1-129)]
B $89A0,8,8 #HTML[#UDGARRAY1,7,4,1;$89A0-$89A7-8(exterior-tiles1-130)]
B $89A8,8,8 #HTML[#UDGARRAY1,7,4,1;$89A8-$89AF-8(exterior-tiles1-131)]
B $89B0,8,8 #HTML[#UDGARRAY1,7,4,1;$89B0-$89B7-8(exterior-tiles1-132)]
B $89B8,8,8 #HTML[#UDGARRAY1,7,4,1;$89B8-$89BF-8(exterior-tiles1-133)]
B $89C0,8,8 #HTML[#UDGARRAY1,7,4,1;$89C0-$89C7-8(exterior-tiles1-134)]
B $89C8,8,8 #HTML[#UDGARRAY1,7,4,1;$89C8-$89CF-8(exterior-tiles1-135)]
B $89D0,8,8 #HTML[#UDGARRAY1,7,4,1;$89D0-$89D7-8(exterior-tiles1-136)]
B $89D8,8,8 #HTML[#UDGARRAY1,7,4,1;$89D8-$89DF-8(exterior-tiles1-137)]
B $89E0,8,8 #HTML[#UDGARRAY1,7,4,1;$89E0-$89E7-8(exterior-tiles1-138)]
B $89E8,8,8 #HTML[#UDGARRAY1,7,4,1;$89E8-$89EF-8(exterior-tiles1-139)]
B $89F0,8,8 #HTML[#UDGARRAY1,7,4,1;$89F0-$89F7-8(exterior-tiles1-140)]
B $89F8,8,8 #HTML[#UDGARRAY1,7,4,1;$89F8-$89FF-8(exterior-tiles1-141)]
B $8A00,8,8 #HTML[#UDGARRAY1,7,4,1;$8A00-$8A07-8(exterior-tiles1-142)]
B $8A08,8,8 #HTML[#UDGARRAY1,7,4,1;$8A08-$8A0F-8(exterior-tiles1-143)]
B $8A10,8,8 #HTML[#UDGARRAY1,7,4,1;$8A10-$8A17-8(exterior-tiles1-144)]
B $8A18,8,8 #HTML[#UDGARRAY1,7,4,1;$8A18-$8A1F-8(exterior-tiles2-000)]
B $8A20,8,8 #HTML[#UDGARRAY1,7,4,1;$8A20-$8A27-8(exterior-tiles2-001)]
B $8A28,8,8 #HTML[#UDGARRAY1,7,4,1;$8A28-$8A2F-8(exterior-tiles2-002)]
B $8A30,8,8 #HTML[#UDGARRAY1,7,4,1;$8A30-$8A37-8(exterior-tiles2-003)]
B $8A38,8,8 #HTML[#UDGARRAY1,7,4,1;$8A38-$8A3F-8(exterior-tiles2-004)]
B $8A40,8,8 #HTML[#UDGARRAY1,7,4,1;$8A40-$8A47-8(exterior-tiles2-005)]
B $8A48,8,8 #HTML[#UDGARRAY1,7,4,1;$8A48-$8A4F-8(exterior-tiles2-006)]
B $8A50,8,8 #HTML[#UDGARRAY1,7,4,1;$8A50-$8A57-8(exterior-tiles2-007)]
B $8A58,8,8 #HTML[#UDGARRAY1,7,4,1;$8A58-$8A5F-8(exterior-tiles2-008)]
B $8A60,8,8 #HTML[#UDGARRAY1,7,4,1;$8A60-$8A67-8(exterior-tiles2-009)]
B $8A68,8,8 #HTML[#UDGARRAY1,7,4,1;$8A68-$8A6F-8(exterior-tiles2-010)]
B $8A70,8,8 #HTML[#UDGARRAY1,7,4,1;$8A70-$8A77-8(exterior-tiles2-011)]
B $8A78,8,8 #HTML[#UDGARRAY1,7,4,1;$8A78-$8A7F-8(exterior-tiles2-012)]
B $8A80,8,8 #HTML[#UDGARRAY1,7,4,1;$8A80-$8A87-8(exterior-tiles2-013)]
B $8A88,8,8 #HTML[#UDGARRAY1,7,4,1;$8A88-$8A8F-8(exterior-tiles2-014)]
B $8A90,8,8 #HTML[#UDGARRAY1,7,4,1;$8A90-$8A97-8(exterior-tiles2-015)]
B $8A98,8,8 #HTML[#UDGARRAY1,7,4,1;$8A98-$8A9F-8(exterior-tiles2-016)]
B $8AA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AA0-$8AA7-8(exterior-tiles2-017)]
B $8AA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AA8-$8AAF-8(exterior-tiles2-018)]
B $8AB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AB0-$8AB7-8(exterior-tiles2-019)]
B $8AB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AB8-$8ABF-8(exterior-tiles2-020)]
B $8AC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AC0-$8AC7-8(exterior-tiles2-021)]
B $8AC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AC8-$8ACF-8(exterior-tiles2-022)]
B $8AD0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AD0-$8AD7-8(exterior-tiles2-023)]
B $8AD8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AD8-$8ADF-8(exterior-tiles2-024)]
B $8AE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AE0-$8AE7-8(exterior-tiles2-025)]
B $8AE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AE8-$8AEF-8(exterior-tiles2-026)]
B $8AF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8AF0-$8AF7-8(exterior-tiles2-027)]
B $8AF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8AF8-$8AFF-8(exterior-tiles2-028)]
B $8B00,8,8 #HTML[#UDGARRAY1,7,4,1;$8B00-$8B07-8(exterior-tiles2-029)]
B $8B08,8,8 #HTML[#UDGARRAY1,7,4,1;$8B08-$8B0F-8(exterior-tiles2-030)]
B $8B10,8,8 #HTML[#UDGARRAY1,7,4,1;$8B10-$8B17-8(exterior-tiles2-031)]
B $8B18,8,8 #HTML[#UDGARRAY1,7,4,1;$8B18-$8B1F-8(exterior-tiles2-032)]
B $8B20,8,8 #HTML[#UDGARRAY1,7,4,1;$8B20-$8B27-8(exterior-tiles2-033)]
B $8B28,8,8 #HTML[#UDGARRAY1,7,4,1;$8B28-$8B2F-8(exterior-tiles2-034)]
B $8B30,8,8 #HTML[#UDGARRAY1,7,4,1;$8B30-$8B37-8(exterior-tiles2-035)]
B $8B38,8,8 #HTML[#UDGARRAY1,7,4,1;$8B38-$8B3F-8(exterior-tiles2-036)]
B $8B40,8,8 #HTML[#UDGARRAY1,7,4,1;$8B40-$8B47-8(exterior-tiles2-037)]
B $8B48,8,8 #HTML[#UDGARRAY1,7,4,1;$8B48-$8B4F-8(exterior-tiles2-038)]
B $8B50,8,8 #HTML[#UDGARRAY1,7,4,1;$8B50-$8B57-8(exterior-tiles2-039)]
B $8B58,8,8 #HTML[#UDGARRAY1,7,4,1;$8B58-$8B5F-8(exterior-tiles2-040)]
B $8B60,8,8 #HTML[#UDGARRAY1,7,4,1;$8B60-$8B67-8(exterior-tiles2-041)]
B $8B68,8,8 #HTML[#UDGARRAY1,7,4,1;$8B68-$8B6F-8(exterior-tiles2-042)]
B $8B70,8,8 #HTML[#UDGARRAY1,7,4,1;$8B70-$8B77-8(exterior-tiles2-043)]
B $8B78,8,8 #HTML[#UDGARRAY1,7,4,1;$8B78-$8B7F-8(exterior-tiles2-044)]
B $8B80,8,8 #HTML[#UDGARRAY1,7,4,1;$8B80-$8B87-8(exterior-tiles2-045)]
B $8B88,8,8 #HTML[#UDGARRAY1,7,4,1;$8B88-$8B8F-8(exterior-tiles2-046)]
B $8B90,8,8 #HTML[#UDGARRAY1,7,4,1;$8B90-$8B97-8(exterior-tiles2-047)]
B $8B98,8,8 #HTML[#UDGARRAY1,7,4,1;$8B98-$8B9F-8(exterior-tiles2-048)]
B $8BA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BA0-$8BA7-8(exterior-tiles2-049)]
B $8BA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BA8-$8BAF-8(exterior-tiles2-050)]
B $8BB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BB0-$8BB7-8(exterior-tiles2-051)]
B $8BB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BB8-$8BBF-8(exterior-tiles2-052)]
B $8BC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BC0-$8BC7-8(exterior-tiles2-053)]
B $8BC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BC8-$8BCF-8(exterior-tiles2-054)]
B $8BD0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BD0-$8BD7-8(exterior-tiles2-055)]
B $8BD8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BD8-$8BDF-8(exterior-tiles2-056)]
B $8BE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BE0-$8BE7-8(exterior-tiles2-057)]
B $8BE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BE8-$8BEF-8(exterior-tiles2-058)]
B $8BF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8BF0-$8BF7-8(exterior-tiles2-059)]
B $8BF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8BF8-$8BFF-8(exterior-tiles2-060)]
B $8C00,8,8 #HTML[#UDGARRAY1,7,4,1;$8C00-$8C07-8(exterior-tiles2-061)]
B $8C08,8,8 #HTML[#UDGARRAY1,7,4,1;$8C08-$8C0F-8(exterior-tiles2-062)]
B $8C10,8,8 #HTML[#UDGARRAY1,7,4,1;$8C10-$8C17-8(exterior-tiles2-063)]
B $8C18,8,8 #HTML[#UDGARRAY1,7,4,1;$8C18-$8C1F-8(exterior-tiles2-064)]
B $8C20,8,8 #HTML[#UDGARRAY1,7,4,1;$8C20-$8C27-8(exterior-tiles2-065)]
B $8C28,8,8 #HTML[#UDGARRAY1,7,4,1;$8C28-$8C2F-8(exterior-tiles2-066)]
B $8C30,8,8 #HTML[#UDGARRAY1,7,4,1;$8C30-$8C37-8(exterior-tiles2-067)]
B $8C38,8,8 #HTML[#UDGARRAY1,7,4,1;$8C38-$8C3F-8(exterior-tiles2-068)]
B $8C40,8,8 #HTML[#UDGARRAY1,7,4,1;$8C40-$8C47-8(exterior-tiles2-069)]
B $8C48,8,8 #HTML[#UDGARRAY1,7,4,1;$8C48-$8C4F-8(exterior-tiles2-070)]
B $8C50,8,8 #HTML[#UDGARRAY1,7,4,1;$8C50-$8C57-8(exterior-tiles2-071)]
B $8C58,8,8 #HTML[#UDGARRAY1,7,4,1;$8C58-$8C5F-8(exterior-tiles2-072)]
B $8C60,8,8 #HTML[#UDGARRAY1,7,4,1;$8C60-$8C67-8(exterior-tiles2-073)]
B $8C68,8,8 #HTML[#UDGARRAY1,7,4,1;$8C68-$8C6F-8(exterior-tiles2-074)]
B $8C70,8,8 #HTML[#UDGARRAY1,7,4,1;$8C70-$8C77-8(exterior-tiles2-075)]
B $8C78,8,8 #HTML[#UDGARRAY1,7,4,1;$8C78-$8C7F-8(exterior-tiles2-076)]
B $8C80,8,8 #HTML[#UDGARRAY1,7,4,1;$8C80-$8C87-8(exterior-tiles2-077)]
B $8C88,8,8 #HTML[#UDGARRAY1,7,4,1;$8C88-$8C8F-8(exterior-tiles2-078)]
B $8C90,8,8 #HTML[#UDGARRAY1,7,4,1;$8C90-$8C97-8(exterior-tiles2-079)]
B $8C98,8,8 #HTML[#UDGARRAY1,7,4,1;$8C98-$8C9F-8(exterior-tiles2-080)]
B $8CA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CA0-$8CA7-8(exterior-tiles2-081)]
B $8CA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CA8-$8CAF-8(exterior-tiles2-082)]
B $8CB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CB0-$8CB7-8(exterior-tiles2-083)]
B $8CB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CB8-$8CBF-8(exterior-tiles2-084)]
B $8CC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CC0-$8CC7-8(exterior-tiles2-085)]
B $8CC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CC8-$8CCF-8(exterior-tiles2-086)]
B $8CD0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CD0-$8CD7-8(exterior-tiles2-087)]
B $8CD8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CD8-$8CDF-8(exterior-tiles2-088)]
B $8CE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CE0-$8CE7-8(exterior-tiles2-089)]
B $8CE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CE8-$8CEF-8(exterior-tiles2-090)]
B $8CF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8CF0-$8CF7-8(exterior-tiles2-091)]
B $8CF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8CF8-$8CFF-8(exterior-tiles2-092)]
B $8D00,8,8 #HTML[#UDGARRAY1,7,4,1;$8D00-$8D07-8(exterior-tiles2-093)]
B $8D08,8,8 #HTML[#UDGARRAY1,7,4,1;$8D08-$8D0F-8(exterior-tiles2-094)]
B $8D10,8,8 #HTML[#UDGARRAY1,7,4,1;$8D10-$8D17-8(exterior-tiles2-095)]
B $8D18,8,8 #HTML[#UDGARRAY1,7,4,1;$8D18-$8D1F-8(exterior-tiles2-096)]
B $8D20,8,8 #HTML[#UDGARRAY1,7,4,1;$8D20-$8D27-8(exterior-tiles2-097)]
B $8D28,8,8 #HTML[#UDGARRAY1,7,4,1;$8D28-$8D2F-8(exterior-tiles2-098)]
B $8D30,8,8 #HTML[#UDGARRAY1,7,4,1;$8D30-$8D37-8(exterior-tiles2-099)]
B $8D38,8,8 #HTML[#UDGARRAY1,7,4,1;$8D38-$8D3F-8(exterior-tiles2-100)]
B $8D40,8,8 #HTML[#UDGARRAY1,7,4,1;$8D40-$8D47-8(exterior-tiles2-101)]
B $8D48,8,8 #HTML[#UDGARRAY1,7,4,1;$8D48-$8D4F-8(exterior-tiles2-102)]
B $8D50,8,8 #HTML[#UDGARRAY1,7,4,1;$8D50-$8D57-8(exterior-tiles2-103)]
B $8D58,8,8 #HTML[#UDGARRAY1,7,4,1;$8D58-$8D5F-8(exterior-tiles2-104)]
B $8D60,8,8 #HTML[#UDGARRAY1,7,4,1;$8D60-$8D67-8(exterior-tiles2-105)]
B $8D68,8,8 #HTML[#UDGARRAY1,7,4,1;$8D68-$8D6F-8(exterior-tiles2-106)]
B $8D70,8,8 #HTML[#UDGARRAY1,7,4,1;$8D70-$8D77-8(exterior-tiles2-107)]
B $8D78,8,8 #HTML[#UDGARRAY1,7,4,1;$8D78-$8D7F-8(exterior-tiles2-108)]
B $8D80,8,8 #HTML[#UDGARRAY1,7,4,1;$8D80-$8D87-8(exterior-tiles2-109)]
B $8D88,8,8 #HTML[#UDGARRAY1,7,4,1;$8D88-$8D8F-8(exterior-tiles2-110)]
B $8D90,8,8 #HTML[#UDGARRAY1,7,4,1;$8D90-$8D97-8(exterior-tiles2-111)]
B $8D98,8,8 #HTML[#UDGARRAY1,7,4,1;$8D98-$8D9F-8(exterior-tiles2-112)]
B $8DA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DA0-$8DA7-8(exterior-tiles2-113)]
B $8DA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DA8-$8DAF-8(exterior-tiles2-114)]
B $8DB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DB0-$8DB7-8(exterior-tiles2-115)]
B $8DB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DB8-$8DBF-8(exterior-tiles2-116)]
B $8DC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DC0-$8DC7-8(exterior-tiles2-117)]
B $8DC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DC8-$8DCF-8(exterior-tiles2-118)]
B $8DD0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DD0-$8DD7-8(exterior-tiles2-119)]
B $8DD8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DD8-$8DDF-8(exterior-tiles2-120)]
B $8DE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DE0-$8DE7-8(exterior-tiles2-121)]
B $8DE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DE8-$8DEF-8(exterior-tiles2-122)]
B $8DF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8DF0-$8DF7-8(exterior-tiles2-123)]
B $8DF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8DF8-$8DFF-8(exterior-tiles2-124)]
B $8E00,8,8 #HTML[#UDGARRAY1,7,4,1;$8E00-$8E07-8(exterior-tiles2-125)]
B $8E08,8,8 #HTML[#UDGARRAY1,7,4,1;$8E08-$8E0F-8(exterior-tiles2-126)]
B $8E10,8,8 #HTML[#UDGARRAY1,7,4,1;$8E10-$8E17-8(exterior-tiles2-127)]
B $8E18,8,8 #HTML[#UDGARRAY1,7,4,1;$8E18-$8E1F-8(exterior-tiles2-128)]
B $8E20,8,8 #HTML[#UDGARRAY1,7,4,1;$8E20-$8E27-8(exterior-tiles2-129)]
B $8E28,8,8 #HTML[#UDGARRAY1,7,4,1;$8E28-$8E2F-8(exterior-tiles2-130)]
B $8E30,8,8 #HTML[#UDGARRAY1,7,4,1;$8E30-$8E37-8(exterior-tiles2-131)]
B $8E38,8,8 #HTML[#UDGARRAY1,7,4,1;$8E38-$8E3F-8(exterior-tiles2-132)]
B $8E40,8,8 #HTML[#UDGARRAY1,7,4,1;$8E40-$8E47-8(exterior-tiles2-133)]
B $8E48,8,8 #HTML[#UDGARRAY1,7,4,1;$8E48-$8E4F-8(exterior-tiles2-134)]
B $8E50,8,8 #HTML[#UDGARRAY1,7,4,1;$8E50-$8E57-8(exterior-tiles2-135)]
B $8E58,8,8 #HTML[#UDGARRAY1,7,4,1;$8E58-$8E5F-8(exterior-tiles2-136)]
B $8E60,8,8 #HTML[#UDGARRAY1,7,4,1;$8E60-$8E67-8(exterior-tiles2-137)]
B $8E68,8,8 #HTML[#UDGARRAY1,7,4,1;$8E68-$8E6F-8(exterior-tiles2-138)]
B $8E70,8,8 #HTML[#UDGARRAY1,7,4,1;$8E70-$8E77-8(exterior-tiles2-139)]
B $8E78,8,8 #HTML[#UDGARRAY1,7,4,1;$8E78-$8E7F-8(exterior-tiles2-140)]
B $8E80,8,8 #HTML[#UDGARRAY1,7,4,1;$8E80-$8E87-8(exterior-tiles2-141)]
B $8E88,8,8 #HTML[#UDGARRAY1,7,4,1;$8E88-$8E8F-8(exterior-tiles2-142)]
B $8E90,8,8 #HTML[#UDGARRAY1,7,4,1;$8E90-$8E97-8(exterior-tiles2-143)]
B $8E98,8,8 #HTML[#UDGARRAY1,7,4,1;$8E98-$8E9F-8(exterior-tiles2-144)]
B $8EA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8EA0-$8EA7-8(exterior-tiles2-145)]
B $8EA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8EA8-$8EAF-8(exterior-tiles2-146)]
B $8EB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8EB0-$8EB7-8(exterior-tiles2-147)]
B $8EB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8EB8-$8EBF-8(exterior-tiles2-148)]
B $8EC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8EC0-$8EC7-8(exterior-tiles2-149)]
B $8EC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8EC8-$8ECF-8(exterior-tiles2-150)]
B $8ED0,8,8 #HTML[#UDGARRAY1,7,4,1;$8ED0-$8ED7-8(exterior-tiles2-151)]
B $8ED8,8,8 #HTML[#UDGARRAY1,7,4,1;$8ED8-$8EDF-8(exterior-tiles2-152)]
B $8EE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8EE0-$8EE7-8(exterior-tiles2-153)]
B $8EE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8EE8-$8EEF-8(exterior-tiles2-154)]
B $8EF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8EF0-$8EF7-8(exterior-tiles2-155)]
B $8EF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8EF8-$8EFF-8(exterior-tiles2-156)]
B $8F00,8,8 #HTML[#UDGARRAY1,7,4,1;$8F00-$8F07-8(exterior-tiles2-157)]
B $8F08,8,8 #HTML[#UDGARRAY1,7,4,1;$8F08-$8F0F-8(exterior-tiles2-158)]
B $8F10,8,8 #HTML[#UDGARRAY1,7,4,1;$8F10-$8F17-8(exterior-tiles2-159)]
B $8F18,8,8 #HTML[#UDGARRAY1,7,4,1;$8F18-$8F1F-8(exterior-tiles2-160)]
B $8F20,8,8 #HTML[#UDGARRAY1,7,4,1;$8F20-$8F27-8(exterior-tiles2-161)]
B $8F28,8,8 #HTML[#UDGARRAY1,7,4,1;$8F28-$8F2F-8(exterior-tiles2-162)]
B $8F30,8,8 #HTML[#UDGARRAY1,7,4,1;$8F30-$8F37-8(exterior-tiles2-163)]
B $8F38,8,8 #HTML[#UDGARRAY1,7,4,1;$8F38-$8F3F-8(exterior-tiles2-164)]
B $8F40,8,8 #HTML[#UDGARRAY1,7,4,1;$8F40-$8F47-8(exterior-tiles2-165)]
B $8F48,8,8 #HTML[#UDGARRAY1,7,4,1;$8F48-$8F4F-8(exterior-tiles2-166)]
B $8F50,8,8 #HTML[#UDGARRAY1,7,4,1;$8F50-$8F57-8(exterior-tiles2-167)]
B $8F58,8,8 #HTML[#UDGARRAY1,7,4,1;$8F58-$8F5F-8(exterior-tiles2-168)]
B $8F60,8,8 #HTML[#UDGARRAY1,7,4,1;$8F60-$8F67-8(exterior-tiles2-169)]
B $8F68,8,8 #HTML[#UDGARRAY1,7,4,1;$8F68-$8F6F-8(exterior-tiles2-170)]
B $8F70,8,8 #HTML[#UDGARRAY1,7,4,1;$8F70-$8F77-8(exterior-tiles2-171)]
B $8F78,8,8 #HTML[#UDGARRAY1,7,4,1;$8F78-$8F7F-8(exterior-tiles2-172)]
B $8F80,8,8 #HTML[#UDGARRAY1,7,4,1;$8F80-$8F87-8(exterior-tiles2-173)]
B $8F88,8,8 #HTML[#UDGARRAY1,7,4,1;$8F88-$8F8F-8(exterior-tiles2-174)]
B $8F90,8,8 #HTML[#UDGARRAY1,7,4,1;$8F90-$8F97-8(exterior-tiles2-175)]
B $8F98,8,8 #HTML[#UDGARRAY1,7,4,1;$8F98-$8F9F-8(exterior-tiles2-176)]
B $8FA0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FA0-$8FA7-8(exterior-tiles2-177)]
B $8FA8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FA8-$8FAF-8(exterior-tiles2-178)]
B $8FB0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FB0-$8FB7-8(exterior-tiles2-179)]
B $8FB8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FB8-$8FBF-8(exterior-tiles2-180)]
B $8FC0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FC0-$8FC7-8(exterior-tiles2-181)]
B $8FC8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FC8-$8FCF-8(exterior-tiles2-182)]
B $8FD0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FD0-$8FD7-8(exterior-tiles2-183)]
B $8FD8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FD8-$8FDF-8(exterior-tiles2-184)]
B $8FE0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FE0-$8FE7-8(exterior-tiles2-185)]
B $8FE8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FE8-$8FEF-8(exterior-tiles2-186)]
B $8FF0,8,8 #HTML[#UDGARRAY1,7,4,1;$8FF0-$8FF7-8(exterior-tiles2-187)]
B $8FF8,8,8 #HTML[#UDGARRAY1,7,4,1;$8FF8-$8FFF-8(exterior-tiles2-188)]
B $9000,8,8 #HTML[#UDGARRAY1,7,4,1;$9000-$9007-8(exterior-tiles2-189)]
B $9008,8,8 #HTML[#UDGARRAY1,7,4,1;$9008-$900F-8(exterior-tiles2-190)]
B $9010,8,8 #HTML[#UDGARRAY1,7,4,1;$9010-$9017-8(exterior-tiles2-191)]
B $9018,8,8 #HTML[#UDGARRAY1,7,4,1;$9018-$901F-8(exterior-tiles2-192)]
B $9020,8,8 #HTML[#UDGARRAY1,7,4,1;$9020-$9027-8(exterior-tiles2-193)]
B $9028,8,8 #HTML[#UDGARRAY1,7,4,1;$9028-$902F-8(exterior-tiles2-194)]
B $9030,8,8 #HTML[#UDGARRAY1,7,4,1;$9030-$9037-8(exterior-tiles2-195)]
B $9038,8,8 #HTML[#UDGARRAY1,7,4,1;$9038-$903F-8(exterior-tiles2-196)]
B $9040,8,8 #HTML[#UDGARRAY1,7,4,1;$9040-$9047-8(exterior-tiles2-197)]
B $9048,8,8 #HTML[#UDGARRAY1,7,4,1;$9048-$904F-8(exterior-tiles2-198)]
B $9050,8,8 #HTML[#UDGARRAY1,7,4,1;$9050-$9057-8(exterior-tiles2-199)]
B $9058,8,8 #HTML[#UDGARRAY1,7,4,1;$9058-$905F-8(exterior-tiles2-200)]
B $9060,8,8 #HTML[#UDGARRAY1,7,4,1;$9060-$9067-8(exterior-tiles2-201)]
B $9068,8,8 #HTML[#UDGARRAY1,7,4,1;$9068-$906F-8(exterior-tiles2-202)]
B $9070,8,8 #HTML[#UDGARRAY1,7,4,1;$9070-$9077-8(exterior-tiles2-203)]
B $9078,8,8 #HTML[#UDGARRAY1,7,4,1;$9078-$907F-8(exterior-tiles2-204)]
B $9080,8,8 #HTML[#UDGARRAY1,7,4,1;$9080-$9087-8(exterior-tiles2-205)]
B $9088,8,8 #HTML[#UDGARRAY1,7,4,1;$9088-$908F-8(exterior-tiles2-206)]
B $9090,8,8 #HTML[#UDGARRAY1,7,4,1;$9090-$9097-8(exterior-tiles2-207)]
B $9098,8,8 #HTML[#UDGARRAY1,7,4,1;$9098-$909F-8(exterior-tiles2-208)]
B $90A0,8,8 #HTML[#UDGARRAY1,7,4,1;$90A0-$90A7-8(exterior-tiles2-209)]
B $90A8,8,8 #HTML[#UDGARRAY1,7,4,1;$90A8-$90AF-8(exterior-tiles2-210)]
B $90B0,8,8 #HTML[#UDGARRAY1,7,4,1;$90B0-$90B7-8(exterior-tiles2-211)]
B $90B8,8,8 #HTML[#UDGARRAY1,7,4,1;$90B8-$90BF-8(exterior-tiles2-212)]
B $90C0,8,8 #HTML[#UDGARRAY1,7,4,1;$90C0-$90C7-8(exterior-tiles2-213)]
B $90C8,8,8 #HTML[#UDGARRAY1,7,4,1;$90C8-$90CF-8(exterior-tiles2-214)]
B $90D0,8,8 #HTML[#UDGARRAY1,7,4,1;$90D0-$90D7-8(exterior-tiles2-215)]
B $90D8,8,8 #HTML[#UDGARRAY1,7,4,1;$90D8-$90DF-8(exterior-tiles2-216)]
B $90E0,8,8 #HTML[#UDGARRAY1,7,4,1;$90E0-$90E7-8(exterior-tiles2-217)]
B $90E8,8,8 #HTML[#UDGARRAY1,7,4,1;$90E8-$90EF-8(exterior-tiles2-218)]
B $90F0,8,8 #HTML[#UDGARRAY1,7,4,1;$90F0-$90F7-8(exterior-tiles2-219)]
B $90F8,8,8 #HTML[#UDGARRAY1,7,4,1;$90F8-$90FF-8(exterior-tiles3-000)]
B $9100,8,8 #HTML[#UDGARRAY1,7,4,1;$9100-$9107-8(exterior-tiles3-001)]
B $9108,8,8 #HTML[#UDGARRAY1,7,4,1;$9108-$910F-8(exterior-tiles3-002)]
B $9110,8,8 #HTML[#UDGARRAY1,7,4,1;$9110-$9117-8(exterior-tiles3-003)]
B $9118,8,8 #HTML[#UDGARRAY1,7,4,1;$9118-$911F-8(exterior-tiles3-004)]
B $9120,8,8 #HTML[#UDGARRAY1,7,4,1;$9120-$9127-8(exterior-tiles3-005)]
B $9128,8,8 #HTML[#UDGARRAY1,7,4,1;$9128-$912F-8(exterior-tiles3-006)]
B $9130,8,8 #HTML[#UDGARRAY1,7,4,1;$9130-$9137-8(exterior-tiles3-007)]
B $9138,8,8 #HTML[#UDGARRAY1,7,4,1;$9138-$913F-8(exterior-tiles3-008)]
B $9140,8,8 #HTML[#UDGARRAY1,7,4,1;$9140-$9147-8(exterior-tiles3-009)]
B $9148,8,8 #HTML[#UDGARRAY1,7,4,1;$9148-$914F-8(exterior-tiles3-010)]
B $9150,8,8 #HTML[#UDGARRAY1,7,4,1;$9150-$9157-8(exterior-tiles3-011)]
B $9158,8,8 #HTML[#UDGARRAY1,7,4,1;$9158-$915F-8(exterior-tiles3-012)]
B $9160,8,8 #HTML[#UDGARRAY1,7,4,1;$9160-$9167-8(exterior-tiles3-013)]
B $9168,8,8 #HTML[#UDGARRAY1,7,4,1;$9168-$916F-8(exterior-tiles3-014)]
B $9170,8,8 #HTML[#UDGARRAY1,7,4,1;$9170-$9177-8(exterior-tiles3-015)]
B $9178,8,8 #HTML[#UDGARRAY1,7,4,1;$9178-$917F-8(exterior-tiles3-016)]
B $9180,8,8 #HTML[#UDGARRAY1,7,4,1;$9180-$9187-8(exterior-tiles3-017)]
B $9188,8,8 #HTML[#UDGARRAY1,7,4,1;$9188-$918F-8(exterior-tiles3-018)]
B $9190,8,8 #HTML[#UDGARRAY1,7,4,1;$9190-$9197-8(exterior-tiles3-019)]
B $9198,8,8 #HTML[#UDGARRAY1,7,4,1;$9198-$919F-8(exterior-tiles3-020)]
B $91A0,8,8 #HTML[#UDGARRAY1,7,4,1;$91A0-$91A7-8(exterior-tiles3-021)]
B $91A8,8,8 #HTML[#UDGARRAY1,7,4,1;$91A8-$91AF-8(exterior-tiles3-022)]
B $91B0,8,8 #HTML[#UDGARRAY1,7,4,1;$91B0-$91B7-8(exterior-tiles3-023)]
B $91B8,8,8 #HTML[#UDGARRAY1,7,4,1;$91B8-$91BF-8(exterior-tiles3-024)]
B $91C0,8,8 #HTML[#UDGARRAY1,7,4,1;$91C0-$91C7-8(exterior-tiles3-025)]
B $91C8,8,8 #HTML[#UDGARRAY1,7,4,1;$91C8-$91CF-8(exterior-tiles3-026)]
B $91D0,8,8 #HTML[#UDGARRAY1,7,4,1;$91D0-$91D7-8(exterior-tiles3-027)]
B $91D8,8,8 #HTML[#UDGARRAY1,7,4,1;$91D8-$91DF-8(exterior-tiles3-028)]
B $91E0,8,8 #HTML[#UDGARRAY1,7,4,1;$91E0-$91E7-8(exterior-tiles3-029)]
B $91E8,8,8 #HTML[#UDGARRAY1,7,4,1;$91E8-$91EF-8(exterior-tiles3-030)]
B $91F0,8,8 #HTML[#UDGARRAY1,7,4,1;$91F0-$91F7-8(exterior-tiles3-031)]
B $91F8,8,8 #HTML[#UDGARRAY1,7,4,1;$91F8-$91FF-8(exterior-tiles3-032)]
B $9200,8,8 #HTML[#UDGARRAY1,7,4,1;$9200-$9207-8(exterior-tiles3-033)]
B $9208,8,8 #HTML[#UDGARRAY1,7,4,1;$9208-$920F-8(exterior-tiles3-034)]
B $9210,8,8 #HTML[#UDGARRAY1,7,4,1;$9210-$9217-8(exterior-tiles3-035)]
B $9218,8,8 #HTML[#UDGARRAY1,7,4,1;$9218-$921F-8(exterior-tiles3-036)]
B $9220,8,8 #HTML[#UDGARRAY1,7,4,1;$9220-$9227-8(exterior-tiles3-037)]
B $9228,8,8 #HTML[#UDGARRAY1,7,4,1;$9228-$922F-8(exterior-tiles3-038)]
B $9230,8,8 #HTML[#UDGARRAY1,7,4,1;$9230-$9237-8(exterior-tiles3-039)]
B $9238,8,8 #HTML[#UDGARRAY1,7,4,1;$9238-$923F-8(exterior-tiles3-040)]
B $9240,8,8 #HTML[#UDGARRAY1,7,4,1;$9240-$9247-8(exterior-tiles3-041)]
B $9248,8,8 #HTML[#UDGARRAY1,7,4,1;$9248-$924F-8(exterior-tiles3-042)]
B $9250,8,8 #HTML[#UDGARRAY1,7,4,1;$9250-$9257-8(exterior-tiles3-043)]
B $9258,8,8 #HTML[#UDGARRAY1,7,4,1;$9258-$925F-8(exterior-tiles3-044)]
B $9260,8,8 #HTML[#UDGARRAY1,7,4,1;$9260-$9267-8(exterior-tiles3-045)]
B $9268,8,8 #HTML[#UDGARRAY1,7,4,1;$9268-$926F-8(exterior-tiles3-046)]
B $9270,8,8 #HTML[#UDGARRAY1,7,4,1;$9270-$9277-8(exterior-tiles3-047)]
B $9278,8,8 #HTML[#UDGARRAY1,7,4,1;$9278-$927F-8(exterior-tiles3-048)]
B $9280,8,8 #HTML[#UDGARRAY1,7,4,1;$9280-$9287-8(exterior-tiles3-049)]
B $9288,8,8 #HTML[#UDGARRAY1,7,4,1;$9288-$928F-8(exterior-tiles3-050)]
B $9290,8,8 #HTML[#UDGARRAY1,7,4,1;$9290-$9297-8(exterior-tiles3-051)]
B $9298,8,8 #HTML[#UDGARRAY1,7,4,1;$9298-$929F-8(exterior-tiles3-052)]
B $92A0,8,8 #HTML[#UDGARRAY1,7,4,1;$92A0-$92A7-8(exterior-tiles3-053)]
B $92A8,8,8 #HTML[#UDGARRAY1,7,4,1;$92A8-$92AF-8(exterior-tiles3-054)]
B $92B0,8,8 #HTML[#UDGARRAY1,7,4,1;$92B0-$92B7-8(exterior-tiles3-055)]
B $92B8,8,8 #HTML[#UDGARRAY1,7,4,1;$92B8-$92BF-8(exterior-tiles3-056)]
B $92C0,8,8 #HTML[#UDGARRAY1,7,4,1;$92C0-$92C7-8(exterior-tiles3-057)]
B $92C8,8,8 #HTML[#UDGARRAY1,7,4,1;$92C8-$92CF-8(exterior-tiles3-058)]
B $92D0,8,8 #HTML[#UDGARRAY1,7,4,1;$92D0-$92D7-8(exterior-tiles3-059)]
B $92D8,8,8 #HTML[#UDGARRAY1,7,4,1;$92D8-$92DF-8(exterior-tiles3-060)]
B $92E0,8,8 #HTML[#UDGARRAY1,7,4,1;$92E0-$92E7-8(exterior-tiles3-061)]
B $92E8,8,8 #HTML[#UDGARRAY1,7,4,1;$92E8-$92EF-8(exterior-tiles3-062)]
B $92F0,8,8 #HTML[#UDGARRAY1,7,4,1;$92F0-$92F7-8(exterior-tiles3-063)]
B $92F8,8,8 #HTML[#UDGARRAY1,7,4,1;$92F8-$92FF-8(exterior-tiles3-064)]
B $9300,8,8 #HTML[#UDGARRAY1,7,4,1;$9300-$9307-8(exterior-tiles3-065)]
B $9308,8,8 #HTML[#UDGARRAY1,7,4,1;$9308-$930F-8(exterior-tiles3-066)]
B $9310,8,8 #HTML[#UDGARRAY1,7,4,1;$9310-$9317-8(exterior-tiles3-067)]
B $9318,8,8 #HTML[#UDGARRAY1,7,4,1;$9318-$931F-8(exterior-tiles3-068)]
B $9320,8,8 #HTML[#UDGARRAY1,7,4,1;$9320-$9327-8(exterior-tiles3-069)]
B $9328,8,8 #HTML[#UDGARRAY1,7,4,1;$9328-$932F-8(exterior-tiles3-070)]
B $9330,8,8 #HTML[#UDGARRAY1,7,4,1;$9330-$9337-8(exterior-tiles3-071)]
B $9338,8,8 #HTML[#UDGARRAY1,7,4,1;$9338-$933F-8(exterior-tiles3-072)]
B $9340,8,8 #HTML[#UDGARRAY1,7,4,1;$9340-$9347-8(exterior-tiles3-073)]
B $9348,8,8 #HTML[#UDGARRAY1,7,4,1;$9348-$934F-8(exterior-tiles3-074)]
B $9350,8,8 #HTML[#UDGARRAY1,7,4,1;$9350-$9357-8(exterior-tiles3-075)]
B $9358,8,8 #HTML[#UDGARRAY1,7,4,1;$9358-$935F-8(exterior-tiles3-076)]
B $9360,8,8 #HTML[#UDGARRAY1,7,4,1;$9360-$9367-8(exterior-tiles3-077)]
B $9368,8,8 #HTML[#UDGARRAY1,7,4,1;$9368-$936F-8(exterior-tiles3-078)]
B $9370,8,8 #HTML[#UDGARRAY1,7,4,1;$9370-$9377-8(exterior-tiles3-079)]
B $9378,8,8 #HTML[#UDGARRAY1,7,4,1;$9378-$937F-8(exterior-tiles3-080)]
B $9380,8,8 #HTML[#UDGARRAY1,7,4,1;$9380-$9387-8(exterior-tiles3-081)]
B $9388,8,8 #HTML[#UDGARRAY1,7,4,1;$9388-$938F-8(exterior-tiles3-082)]
B $9390,8,8 #HTML[#UDGARRAY1,7,4,1;$9390-$9397-8(exterior-tiles3-083)]
B $9398,8,8 #HTML[#UDGARRAY1,7,4,1;$9398-$939F-8(exterior-tiles3-084)]
B $93A0,8,8 #HTML[#UDGARRAY1,7,4,1;$93A0-$93A7-8(exterior-tiles3-085)]
B $93A8,8,8 #HTML[#UDGARRAY1,7,4,1;$93A8-$93AF-8(exterior-tiles3-086)]
B $93B0,8,8 #HTML[#UDGARRAY1,7,4,1;$93B0-$93B7-8(exterior-tiles3-087)]
B $93B8,8,8 #HTML[#UDGARRAY1,7,4,1;$93B8-$93BF-8(exterior-tiles3-088)]
B $93C0,8,8 #HTML[#UDGARRAY1,7,4,1;$93C0-$93C7-8(exterior-tiles3-089)]
B $93C8,8,8 #HTML[#UDGARRAY1,7,4,1;$93C8-$93CF-8(exterior-tiles3-090)]
B $93D0,8,8 #HTML[#UDGARRAY1,7,4,1;$93D0-$93D7-8(exterior-tiles3-091)]
B $93D8,8,8 #HTML[#UDGARRAY1,7,4,1;$93D8-$93DF-8(exterior-tiles3-092)]
B $93E0,8,8 #HTML[#UDGARRAY1,7,4,1;$93E0-$93E7-8(exterior-tiles3-093)]
B $93E8,8,8 #HTML[#UDGARRAY1,7,4,1;$93E8-$93EF-8(exterior-tiles3-094)]
B $93F0,8,8 #HTML[#UDGARRAY1,7,4,1;$93F0-$93F7-8(exterior-tiles3-095)]
B $93F8,8,8 #HTML[#UDGARRAY1,7,4,1;$93F8-$93FF-8(exterior-tiles3-096)]
B $9400,8,8 #HTML[#UDGARRAY1,7,4,1;$9400-$9407-8(exterior-tiles3-097)]
B $9408,8,8 #HTML[#UDGARRAY1,7,4,1;$9408-$940F-8(exterior-tiles3-098)]
B $9410,8,8 #HTML[#UDGARRAY1,7,4,1;$9410-$9417-8(exterior-tiles3-099)]
B $9418,8,8 #HTML[#UDGARRAY1,7,4,1;$9418-$941F-8(exterior-tiles3-100)]
B $9420,8,8 #HTML[#UDGARRAY1,7,4,1;$9420-$9427-8(exterior-tiles3-101)]
B $9428,8,8 #HTML[#UDGARRAY1,7,4,1;$9428-$942F-8(exterior-tiles3-102)]
B $9430,8,8 #HTML[#UDGARRAY1,7,4,1;$9430-$9437-8(exterior-tiles3-103)]
B $9438,8,8 #HTML[#UDGARRAY1,7,4,1;$9438-$943F-8(exterior-tiles3-104)]
B $9440,8,8 #HTML[#UDGARRAY1,7,4,1;$9440-$9447-8(exterior-tiles3-105)]
B $9448,8,8 #HTML[#UDGARRAY1,7,4,1;$9448-$944F-8(exterior-tiles3-106)]
B $9450,8,8 #HTML[#UDGARRAY1,7,4,1;$9450-$9457-8(exterior-tiles3-107)]
B $9458,8,8 #HTML[#UDGARRAY1,7,4,1;$9458-$945F-8(exterior-tiles3-108)]
B $9460,8,8 #HTML[#UDGARRAY1,7,4,1;$9460-$9467-8(exterior-tiles3-109)]
B $9468,8,8 #HTML[#UDGARRAY1,7,4,1;$9468-$946F-8(exterior-tiles3-110)]
B $9470,8,8 #HTML[#UDGARRAY1,7,4,1;$9470-$9477-8(exterior-tiles3-111)]
B $9478,8,8 #HTML[#UDGARRAY1,7,4,1;$9478-$947F-8(exterior-tiles3-112)]
B $9480,8,8 #HTML[#UDGARRAY1,7,4,1;$9480-$9487-8(exterior-tiles3-113)]
B $9488,8,8 #HTML[#UDGARRAY1,7,4,1;$9488-$948F-8(exterior-tiles3-114)]
B $9490,8,8 #HTML[#UDGARRAY1,7,4,1;$9490-$9497-8(exterior-tiles3-115)]
B $9498,8,8 #HTML[#UDGARRAY1,7,4,1;$9498-$949F-8(exterior-tiles3-116)]
B $94A0,8,8 #HTML[#UDGARRAY1,7,4,1;$94A0-$94A7-8(exterior-tiles3-117)]
B $94A8,8,8 #HTML[#UDGARRAY1,7,4,1;$94A8-$94AF-8(exterior-tiles3-118)]
B $94B0,8,8 #HTML[#UDGARRAY1,7,4,1;$94B0-$94B7-8(exterior-tiles3-119)]
B $94B8,8,8 #HTML[#UDGARRAY1,7,4,1;$94B8-$94BF-8(exterior-tiles3-120)]
B $94C0,8,8 #HTML[#UDGARRAY1,7,4,1;$94C0-$94C7-8(exterior-tiles3-121)]
B $94C8,8,8 #HTML[#UDGARRAY1,7,4,1;$94C8-$94CF-8(exterior-tiles3-122)]
B $94D0,8,8 #HTML[#UDGARRAY1,7,4,1;$94D0-$94D7-8(exterior-tiles3-123)]
B $94D8,8,8 #HTML[#UDGARRAY1,7,4,1;$94D8-$94DF-8(exterior-tiles3-124)]
B $94E0,8,8 #HTML[#UDGARRAY1,7,4,1;$94E0-$94E7-8(exterior-tiles3-125)]
B $94E8,8,8 #HTML[#UDGARRAY1,7,4,1;$94E8-$94EF-8(exterior-tiles3-126)]
B $94F0,8,8 #HTML[#UDGARRAY1,7,4,1;$94F0-$94F7-8(exterior-tiles3-127)]
B $94F8,8,8 #HTML[#UDGARRAY1,7,4,1;$94F8-$94FF-8(exterior-tiles3-128)]
B $9500,8,8 #HTML[#UDGARRAY1,7,4,1;$9500-$9507-8(exterior-tiles3-129)]
B $9508,8,8 #HTML[#UDGARRAY1,7,4,1;$9508-$950F-8(exterior-tiles3-130)]
B $9510,8,8 #HTML[#UDGARRAY1,7,4,1;$9510-$9517-8(exterior-tiles3-131)]
B $9518,8,8 #HTML[#UDGARRAY1,7,4,1;$9518-$951F-8(exterior-tiles3-132)]
B $9520,8,8 #HTML[#UDGARRAY1,7,4,1;$9520-$9527-8(exterior-tiles3-133)]
B $9528,8,8 #HTML[#UDGARRAY1,7,4,1;$9528-$952F-8(exterior-tiles3-134)]
B $9530,8,8 #HTML[#UDGARRAY1,7,4,1;$9530-$9537-8(exterior-tiles3-135)]
B $9538,8,8 #HTML[#UDGARRAY1,7,4,1;$9538-$953F-8(exterior-tiles3-136)]
B $9540,8,8 #HTML[#UDGARRAY1,7,4,1;$9540-$9547-8(exterior-tiles3-137)]
B $9548,8,8 #HTML[#UDGARRAY1,7,4,1;$9548-$954F-8(exterior-tiles3-138)]
B $9550,8,8 #HTML[#UDGARRAY1,7,4,1;$9550-$9557-8(exterior-tiles3-139)]
B $9558,8,8 #HTML[#UDGARRAY1,7,4,1;$9558-$955F-8(exterior-tiles3-140)]
B $9560,8,8 #HTML[#UDGARRAY1,7,4,1;$9560-$9567-8(exterior-tiles3-141)]
B $9568,8,8 #HTML[#UDGARRAY1,7,4,1;$9568-$956F-8(exterior-tiles3-142)]
B $9570,8,8 #HTML[#UDGARRAY1,7,4,1;$9570-$9577-8(exterior-tiles3-143)]
B $9578,8,8 #HTML[#UDGARRAY1,7,4,1;$9578-$957F-8(exterior-tiles3-144)]
B $9580,8,8 #HTML[#UDGARRAY1,7,4,1;$9580-$9587-8(exterior-tiles3-145)]
B $9588,8,8 #HTML[#UDGARRAY1,7,4,1;$9588-$958F-8(exterior-tiles3-146)]
B $9590,8,8 #HTML[#UDGARRAY1,7,4,1;$9590-$9597-8(exterior-tiles3-147)]
B $9598,8,8 #HTML[#UDGARRAY1,7,4,1;$9598-$959F-8(exterior-tiles3-148)]
B $95A0,8,8 #HTML[#UDGARRAY1,7,4,1;$95A0-$95A7-8(exterior-tiles3-149)]
B $95A8,8,8 #HTML[#UDGARRAY1,7,4,1;$95A8-$95AF-8(exterior-tiles3-150)]
B $95B0,8,8 #HTML[#UDGARRAY1,7,4,1;$95B0-$95B7-8(exterior-tiles3-151)]
B $95B8,8,8 #HTML[#UDGARRAY1,7,4,1;$95B8-$95BF-8(exterior-tiles3-152)]
B $95C0,8,8 #HTML[#UDGARRAY1,7,4,1;$95C0-$95C7-8(exterior-tiles3-153)]
B $95C8,8,8 #HTML[#UDGARRAY1,7,4,1;$95C8-$95CF-8(exterior-tiles3-154)]
B $95D0,8,8 #HTML[#UDGARRAY1,7,4,1;$95D0-$95D7-8(exterior-tiles3-155)]
B $95D8,8,8 #HTML[#UDGARRAY1,7,4,1;$95D8-$95DF-8(exterior-tiles3-156)]
B $95E0,8,8 #HTML[#UDGARRAY1,7,4,1;$95E0-$95E7-8(exterior-tiles3-157)]
B $95E8,8,8 #HTML[#UDGARRAY1,7,4,1;$95E8-$95EF-8(exterior-tiles3-158)]
B $95F0,8,8 #HTML[#UDGARRAY1,7,4,1;$95F0-$95F7-8(exterior-tiles3-159)]
B $95F8,8,8 #HTML[#UDGARRAY1,7,4,1;$95F8-$95FF-8(exterior-tiles3-160)]
B $9600,8,8 #HTML[#UDGARRAY1,7,4,1;$9600-$9607-8(exterior-tiles3-161)]
B $9608,8,8 #HTML[#UDGARRAY1,7,4,1;$9608-$960F-8(exterior-tiles3-162)]
B $9610,8,8 #HTML[#UDGARRAY1,7,4,1;$9610-$9617-8(exterior-tiles3-163)]
B $9618,8,8 #HTML[#UDGARRAY1,7,4,1;$9618-$961F-8(exterior-tiles3-164)]
B $9620,8,8 #HTML[#UDGARRAY1,7,4,1;$9620-$9627-8(exterior-tiles3-165)]
B $9628,8,8 #HTML[#UDGARRAY1,7,4,1;$9628-$962F-8(exterior-tiles3-166)]
B $9630,8,8 #HTML[#UDGARRAY1,7,4,1;$9630-$9637-8(exterior-tiles3-167)]
B $9638,8,8 #HTML[#UDGARRAY1,7,4,1;$9638-$963F-8(exterior-tiles3-168)]
B $9640,8,8 #HTML[#UDGARRAY1,7,4,1;$9640-$9647-8(exterior-tiles3-169)]
B $9648,8,8 #HTML[#UDGARRAY1,7,4,1;$9648-$964F-8(exterior-tiles3-170)]
B $9650,8,8 #HTML[#UDGARRAY1,7,4,1;$9650-$9657-8(exterior-tiles3-171)]
B $9658,8,8 #HTML[#UDGARRAY1,7,4,1;$9658-$965F-8(exterior-tiles3-172)]
B $9660,8,8 #HTML[#UDGARRAY1,7,4,1;$9660-$9667-8(exterior-tiles3-173)]
B $9668,8,8 #HTML[#UDGARRAY1,7,4,1;$9668-$966F-8(exterior-tiles3-174)]
B $9670,8,8 #HTML[#UDGARRAY1,7,4,1;$9670-$9677-8(exterior-tiles3-175)]
B $9678,8,8 #HTML[#UDGARRAY1,7,4,1;$9678-$967F-8(exterior-tiles3-176)]
B $9680,8,8 #HTML[#UDGARRAY1,7,4,1;$9680-$9687-8(exterior-tiles3-177)]
B $9688,8,8 #HTML[#UDGARRAY1,7,4,1;$9688-$968F-8(exterior-tiles3-178)]
B $9690,8,8 #HTML[#UDGARRAY1,7,4,1;$9690-$9697-8(exterior-tiles3-179)]
B $9698,8,8 #HTML[#UDGARRAY1,7,4,1;$9698-$969F-8(exterior-tiles3-180)]
B $96A0,8,8 #HTML[#UDGARRAY1,7,4,1;$96A0-$96A7-8(exterior-tiles3-181)]
B $96A8,8,8 #HTML[#UDGARRAY1,7,4,1;$96A8-$96AF-8(exterior-tiles3-182)]
B $96B0,8,8 #HTML[#UDGARRAY1,7,4,1;$96B0-$96B7-8(exterior-tiles3-183)]
B $96B8,8,8 #HTML[#UDGARRAY1,7,4,1;$96B8-$96BF-8(exterior-tiles3-184)]
B $96C0,8,8 #HTML[#UDGARRAY1,7,4,1;$96C0-$96C7-8(exterior-tiles3-185)]
B $96C8,8,8 #HTML[#UDGARRAY1,7,4,1;$96C8-$96CF-8(exterior-tiles3-186)]
B $96D0,8,8 #HTML[#UDGARRAY1,7,4,1;$96D0-$96D7-8(exterior-tiles3-187)]
B $96D8,8,8 #HTML[#UDGARRAY1,7,4,1;$96D8-$96DF-8(exterior-tiles3-188)]
B $96E0,8,8 #HTML[#UDGARRAY1,7,4,1;$96E0-$96E7-8(exterior-tiles3-189)]
B $96E8,8,8 #HTML[#UDGARRAY1,7,4,1;$96E8-$96EF-8(exterior-tiles3-190)]
B $96F0,8,8 #HTML[#UDGARRAY1,7,4,1;$96F0-$96F7-8(exterior-tiles3-191)]
B $96F8,8,8 #HTML[#UDGARRAY1,7,4,1;$96F8-$96FF-8(exterior-tiles3-192)]
B $9700,8,8 #HTML[#UDGARRAY1,7,4,1;$9700-$9707-8(exterior-tiles3-193)]
B $9708,8,8 #HTML[#UDGARRAY1,7,4,1;$9708-$970F-8(exterior-tiles3-194)]
B $9710,8,8 #HTML[#UDGARRAY1,7,4,1;$9710-$9717-8(exterior-tiles3-195)]
B $9718,8,8 #HTML[#UDGARRAY1,7,4,1;$9718-$971F-8(exterior-tiles3-196)]
B $9720,8,8 #HTML[#UDGARRAY1,7,4,1;$9720-$9727-8(exterior-tiles3-197)]
B $9728,8,8 #HTML[#UDGARRAY1,7,4,1;$9728-$972F-8(exterior-tiles3-198)]
B $9730,8,8 #HTML[#UDGARRAY1,7,4,1;$9730-$9737-8(exterior-tiles3-199)]
B $9738,8,8 #HTML[#UDGARRAY1,7,4,1;$9738-$973F-8(exterior-tiles3-200)]
B $9740,8,8 #HTML[#UDGARRAY1,7,4,1;$9740-$9747-8(exterior-tiles3-201)]
B $9748,8,8 #HTML[#UDGARRAY1,7,4,1;$9748-$974F-8(exterior-tiles3-202)]
B $9750,8,8 #HTML[#UDGARRAY1,7,4,1;$9750-$9757-8(exterior-tiles3-203)]
B $9758,8,8 #HTML[#UDGARRAY1,7,4,1;$9758-$975F-8(exterior-tiles3-204)]
B $9760,8,8 #HTML[#UDGARRAY1,7,4,1;$9760-$9767-8(exterior-tiles3-205)]
N $9768 Interior tiles. 194 tiles.
@ $9768 label=interior_tiles
B $9768,8,8 #HTML[#UDGARRAY1,7,4,1;$9768-$976F-8(interior-tiles-000)]
B $9770,8,8 #HTML[#UDGARRAY1,7,4,1;$9770-$9777-8(interior-tiles-001)]
B $9778,8,8 #HTML[#UDGARRAY1,7,4,1;$9778-$977F-8(interior-tiles-002)]
B $9780,8,8 #HTML[#UDGARRAY1,7,4,1;$9780-$9787-8(interior-tiles-003)]
B $9788,8,8 #HTML[#UDGARRAY1,7,4,1;$9788-$978F-8(interior-tiles-004)]
B $9790,8,8 #HTML[#UDGARRAY1,7,4,1;$9790-$9797-8(interior-tiles-005)]
B $9798,8,8 #HTML[#UDGARRAY1,7,4,1;$9798-$979F-8(interior-tiles-006)]
B $97A0,8,8 #HTML[#UDGARRAY1,7,4,1;$97A0-$97A7-8(interior-tiles-007)]
B $97A8,8,8 #HTML[#UDGARRAY1,7,4,1;$97A8-$97AF-8(interior-tiles-008)]
B $97B0,8,8 #HTML[#UDGARRAY1,7,4,1;$97B0-$97B7-8(interior-tiles-009)]
B $97B8,8,8 #HTML[#UDGARRAY1,7,4,1;$97B8-$97BF-8(interior-tiles-010)]
B $97C0,8,8 #HTML[#UDGARRAY1,7,4,1;$97C0-$97C7-8(interior-tiles-011)]
B $97C8,8,8 #HTML[#UDGARRAY1,7,4,1;$97C8-$97CF-8(interior-tiles-012)]
B $97D0,8,8 #HTML[#UDGARRAY1,7,4,1;$97D0-$97D7-8(interior-tiles-013)]
B $97D8,8,8 #HTML[#UDGARRAY1,7,4,1;$97D8-$97DF-8(interior-tiles-014)]
B $97E0,8,8 #HTML[#UDGARRAY1,7,4,1;$97E0-$97E7-8(interior-tiles-015)]
B $97E8,8,8 #HTML[#UDGARRAY1,7,4,1;$97E8-$97EF-8(interior-tiles-016)]
B $97F0,8,8 #HTML[#UDGARRAY1,7,4,1;$97F0-$97F7-8(interior-tiles-017)]
B $97F8,8,8 #HTML[#UDGARRAY1,7,4,1;$97F8-$97FF-8(interior-tiles-018)]
B $9800,8,8 #HTML[#UDGARRAY1,7,4,1;$9800-$9807-8(interior-tiles-019)]
B $9808,8,8 #HTML[#UDGARRAY1,7,4,1;$9808-$980F-8(interior-tiles-020)]
B $9810,8,8 #HTML[#UDGARRAY1,7,4,1;$9810-$9817-8(interior-tiles-021)]
B $9818,8,8 #HTML[#UDGARRAY1,7,4,1;$9818-$981F-8(interior-tiles-022)]
B $9820,8,8 #HTML[#UDGARRAY1,7,4,1;$9820-$9827-8(interior-tiles-023)]
B $9828,8,8 #HTML[#UDGARRAY1,7,4,1;$9828-$982F-8(interior-tiles-024)]
B $9830,8,8 #HTML[#UDGARRAY1,7,4,1;$9830-$9837-8(interior-tiles-025)]
B $9838,8,8 #HTML[#UDGARRAY1,7,4,1;$9838-$983F-8(interior-tiles-026)]
B $9840,8,8 #HTML[#UDGARRAY1,7,4,1;$9840-$9847-8(interior-tiles-027)]
B $9848,8,8 #HTML[#UDGARRAY1,7,4,1;$9848-$984F-8(interior-tiles-028)]
B $9850,8,8 #HTML[#UDGARRAY1,7,4,1;$9850-$9857-8(interior-tiles-029)]
B $9858,8,8 #HTML[#UDGARRAY1,7,4,1;$9858-$985F-8(interior-tiles-030)]
B $9860,8,8 #HTML[#UDGARRAY1,7,4,1;$9860-$9867-8(interior-tiles-031)]
B $9868,8,8 #HTML[#UDGARRAY1,7,4,1;$9868-$986F-8(interior-tiles-032)]
B $9870,8,8 #HTML[#UDGARRAY1,7,4,1;$9870-$9877-8(interior-tiles-033)]
B $9878,8,8 #HTML[#UDGARRAY1,7,4,1;$9878-$987F-8(interior-tiles-034)]
B $9880,8,8 #HTML[#UDGARRAY1,7,4,1;$9880-$9887-8(interior-tiles-035)]
B $9888,8,8 #HTML[#UDGARRAY1,7,4,1;$9888-$988F-8(interior-tiles-036)]
B $9890,8,8 #HTML[#UDGARRAY1,7,4,1;$9890-$9897-8(interior-tiles-037)]
B $9898,8,8 #HTML[#UDGARRAY1,7,4,1;$9898-$989F-8(interior-tiles-038)]
B $98A0,8,8 #HTML[#UDGARRAY1,7,4,1;$98A0-$98A7-8(interior-tiles-039)]
B $98A8,8,8 #HTML[#UDGARRAY1,7,4,1;$98A8-$98AF-8(interior-tiles-040)]
B $98B0,8,8 #HTML[#UDGARRAY1,7,4,1;$98B0-$98B7-8(interior-tiles-041)]
B $98B8,8,8 #HTML[#UDGARRAY1,7,4,1;$98B8-$98BF-8(interior-tiles-042)]
B $98C0,8,8 #HTML[#UDGARRAY1,7,4,1;$98C0-$98C7-8(interior-tiles-043)]
B $98C8,8,8 #HTML[#UDGARRAY1,7,4,1;$98C8-$98CF-8(interior-tiles-044)]
B $98D0,8,8 #HTML[#UDGARRAY1,7,4,1;$98D0-$98D7-8(interior-tiles-045)]
B $98D8,8,8 #HTML[#UDGARRAY1,7,4,1;$98D8-$98DF-8(interior-tiles-046)]
B $98E0,8,8 #HTML[#UDGARRAY1,7,4,1;$98E0-$98E7-8(interior-tiles-047)]
B $98E8,8,8 #HTML[#UDGARRAY1,7,4,1;$98E8-$98EF-8(interior-tiles-048)]
B $98F0,8,8 #HTML[#UDGARRAY1,7,4,1;$98F0-$98F7-8(interior-tiles-049)]
B $98F8,8,8 #HTML[#UDGARRAY1,7,4,1;$98F8-$98FF-8(interior-tiles-050)]
B $9900,8,8 #HTML[#UDGARRAY1,7,4,1;$9900-$9907-8(interior-tiles-051)]
B $9908,8,8 #HTML[#UDGARRAY1,7,4,1;$9908-$990F-8(interior-tiles-052)]
B $9910,8,8 #HTML[#UDGARRAY1,7,4,1;$9910-$9917-8(interior-tiles-053)]
B $9918,8,8 #HTML[#UDGARRAY1,7,4,1;$9918-$991F-8(interior-tiles-054)]
B $9920,8,8 #HTML[#UDGARRAY1,7,4,1;$9920-$9927-8(interior-tiles-055)]
B $9928,8,8 #HTML[#UDGARRAY1,7,4,1;$9928-$992F-8(interior-tiles-056)]
B $9930,8,8 #HTML[#UDGARRAY1,7,4,1;$9930-$9937-8(interior-tiles-057)]
B $9938,8,8 #HTML[#UDGARRAY1,7,4,1;$9938-$993F-8(interior-tiles-058)]
B $9940,8,8 #HTML[#UDGARRAY1,7,4,1;$9940-$9947-8(interior-tiles-059)]
B $9948,8,8 #HTML[#UDGARRAY1,7,4,1;$9948-$994F-8(interior-tiles-060)]
B $9950,8,8 #HTML[#UDGARRAY1,7,4,1;$9950-$9957-8(interior-tiles-061)]
B $9958,8,8 #HTML[#UDGARRAY1,7,4,1;$9958-$995F-8(interior-tiles-062)]
B $9960,8,8 #HTML[#UDGARRAY1,7,4,1;$9960-$9967-8(interior-tiles-063)]
B $9968,8,8 #HTML[#UDGARRAY1,7,4,1;$9968-$996F-8(interior-tiles-064)]
B $9970,8,8 #HTML[#UDGARRAY1,7,4,1;$9970-$9977-8(interior-tiles-065)]
B $9978,8,8 #HTML[#UDGARRAY1,7,4,1;$9978-$997F-8(interior-tiles-066)]
B $9980,8,8 #HTML[#UDGARRAY1,7,4,1;$9980-$9987-8(interior-tiles-067)]
B $9988,8,8 #HTML[#UDGARRAY1,7,4,1;$9988-$998F-8(interior-tiles-068)]
B $9990,8,8 #HTML[#UDGARRAY1,7,4,1;$9990-$9997-8(interior-tiles-069)]
B $9998,8,8 #HTML[#UDGARRAY1,7,4,1;$9998-$999F-8(interior-tiles-070)]
B $99A0,8,8 #HTML[#UDGARRAY1,7,4,1;$99A0-$99A7-8(interior-tiles-071)]
B $99A8,8,8 #HTML[#UDGARRAY1,7,4,1;$99A8-$99AF-8(interior-tiles-072)]
B $99B0,8,8 #HTML[#UDGARRAY1,7,4,1;$99B0-$99B7-8(interior-tiles-073)]
B $99B8,8,8 #HTML[#UDGARRAY1,7,4,1;$99B8-$99BF-8(interior-tiles-074)]
B $99C0,8,8 #HTML[#UDGARRAY1,7,4,1;$99C0-$99C7-8(interior-tiles-075)]
B $99C8,8,8 #HTML[#UDGARRAY1,7,4,1;$99C8-$99CF-8(interior-tiles-076)]
B $99D0,8,8 #HTML[#UDGARRAY1,7,4,1;$99D0-$99D7-8(interior-tiles-077)]
B $99D8,8,8 #HTML[#UDGARRAY1,7,4,1;$99D8-$99DF-8(interior-tiles-078)]
B $99E0,8,8 #HTML[#UDGARRAY1,7,4,1;$99E0-$99E7-8(interior-tiles-079)]
B $99E8,8,8 #HTML[#UDGARRAY1,7,4,1;$99E8-$99EF-8(interior-tiles-080)]
B $99F0,8,8 #HTML[#UDGARRAY1,7,4,1;$99F0-$99F7-8(interior-tiles-081)]
B $99F8,8,8 #HTML[#UDGARRAY1,7,4,1;$99F8-$99FF-8(interior-tiles-082)]
B $9A00,8,8 #HTML[#UDGARRAY1,7,4,1;$9A00-$9A07-8(interior-tiles-083)]
B $9A08,8,8 #HTML[#UDGARRAY1,7,4,1;$9A08-$9A0F-8(interior-tiles-084)]
B $9A10,8,8 #HTML[#UDGARRAY1,7,4,1;$9A10-$9A17-8(interior-tiles-085)]
B $9A18,8,8 #HTML[#UDGARRAY1,7,4,1;$9A18-$9A1F-8(interior-tiles-086)]
B $9A20,8,8 #HTML[#UDGARRAY1,7,4,1;$9A20-$9A27-8(interior-tiles-087)]
B $9A28,8,8 #HTML[#UDGARRAY1,7,4,1;$9A28-$9A2F-8(interior-tiles-088)]
B $9A30,8,8 #HTML[#UDGARRAY1,7,4,1;$9A30-$9A37-8(interior-tiles-089)]
B $9A38,8,8 #HTML[#UDGARRAY1,7,4,1;$9A38-$9A3F-8(interior-tiles-090)]
B $9A40,8,8 #HTML[#UDGARRAY1,7,4,1;$9A40-$9A47-8(interior-tiles-091)]
B $9A48,8,8 #HTML[#UDGARRAY1,7,4,1;$9A48-$9A4F-8(interior-tiles-092)]
B $9A50,8,8 #HTML[#UDGARRAY1,7,4,1;$9A50-$9A57-8(interior-tiles-093)]
B $9A58,8,8 #HTML[#UDGARRAY1,7,4,1;$9A58-$9A5F-8(interior-tiles-094)]
B $9A60,8,8 #HTML[#UDGARRAY1,7,4,1;$9A60-$9A67-8(interior-tiles-095)]
B $9A68,8,8 #HTML[#UDGARRAY1,7,4,1;$9A68-$9A6F-8(interior-tiles-096)]
B $9A70,8,8 #HTML[#UDGARRAY1,7,4,1;$9A70-$9A77-8(interior-tiles-097)]
B $9A78,8,8 #HTML[#UDGARRAY1,7,4,1;$9A78-$9A7F-8(interior-tiles-098)]
B $9A80,8,8 #HTML[#UDGARRAY1,7,4,1;$9A80-$9A87-8(interior-tiles-099)]
B $9A88,8,8 #HTML[#UDGARRAY1,7,4,1;$9A88-$9A8F-8(interior-tiles-100)]
B $9A90,8,8 #HTML[#UDGARRAY1,7,4,1;$9A90-$9A97-8(interior-tiles-101)]
B $9A98,8,8 #HTML[#UDGARRAY1,7,4,1;$9A98-$9A9F-8(interior-tiles-102)]
B $9AA0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AA0-$9AA7-8(interior-tiles-103)]
B $9AA8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AA8-$9AAF-8(interior-tiles-104)]
B $9AB0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AB0-$9AB7-8(interior-tiles-105)]
B $9AB8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AB8-$9ABF-8(interior-tiles-106)]
B $9AC0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AC0-$9AC7-8(interior-tiles-107)]
B $9AC8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AC8-$9ACF-8(interior-tiles-108)]
B $9AD0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AD0-$9AD7-8(interior-tiles-109)]
B $9AD8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AD8-$9ADF-8(interior-tiles-110)]
B $9AE0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AE0-$9AE7-8(interior-tiles-111)]
B $9AE8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AE8-$9AEF-8(interior-tiles-112)]
B $9AF0,8,8 #HTML[#UDGARRAY1,7,4,1;$9AF0-$9AF7-8(interior-tiles-113)]
B $9AF8,8,8 #HTML[#UDGARRAY1,7,4,1;$9AF8-$9AFF-8(interior-tiles-114)]
B $9B00,8,8 #HTML[#UDGARRAY1,7,4,1;$9B00-$9B07-8(interior-tiles-115)]
B $9B08,8,8 #HTML[#UDGARRAY1,7,4,1;$9B08-$9B0F-8(interior-tiles-116)]
B $9B10,8,8 #HTML[#UDGARRAY1,7,4,1;$9B10-$9B17-8(interior-tiles-117)]
B $9B18,8,8 #HTML[#UDGARRAY1,7,4,1;$9B18-$9B1F-8(interior-tiles-118)]
B $9B20,8,8 #HTML[#UDGARRAY1,7,4,1;$9B20-$9B27-8(interior-tiles-119)]
B $9B28,8,8 #HTML[#UDGARRAY1,7,4,1;$9B28-$9B2F-8(interior-tiles-120)]
B $9B30,8,8 #HTML[#UDGARRAY1,7,4,1;$9B30-$9B37-8(interior-tiles-121)]
B $9B38,8,8 #HTML[#UDGARRAY1,7,4,1;$9B38-$9B3F-8(interior-tiles-122)]
B $9B40,8,8 #HTML[#UDGARRAY1,7,4,1;$9B40-$9B47-8(interior-tiles-123)]
B $9B48,8,8 #HTML[#UDGARRAY1,7,4,1;$9B48-$9B4F-8(interior-tiles-124)]
B $9B50,8,8 #HTML[#UDGARRAY1,7,4,1;$9B50-$9B57-8(interior-tiles-125)]
B $9B58,8,8 #HTML[#UDGARRAY1,7,4,1;$9B58-$9B5F-8(interior-tiles-126)]
B $9B60,8,8 #HTML[#UDGARRAY1,7,4,1;$9B60-$9B67-8(interior-tiles-127)]
B $9B68,8,8 #HTML[#UDGARRAY1,7,4,1;$9B68-$9B6F-8(interior-tiles-128)]
B $9B70,8,8 #HTML[#UDGARRAY1,7,4,1;$9B70-$9B77-8(interior-tiles-129)]
B $9B78,8,8 #HTML[#UDGARRAY1,7,4,1;$9B78-$9B7F-8(interior-tiles-130)]
B $9B80,8,8 #HTML[#UDGARRAY1,7,4,1;$9B80-$9B87-8(interior-tiles-131)]
B $9B88,8,8 #HTML[#UDGARRAY1,7,4,1;$9B88-$9B8F-8(interior-tiles-132)]
B $9B90,8,8 #HTML[#UDGARRAY1,7,4,1;$9B90-$9B97-8(interior-tiles-133)]
B $9B98,8,8 #HTML[#UDGARRAY1,7,4,1;$9B98-$9B9F-8(interior-tiles-134)]
B $9BA0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BA0-$9BA7-8(interior-tiles-135)]
B $9BA8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BA8-$9BAF-8(interior-tiles-136)]
B $9BB0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BB0-$9BB7-8(interior-tiles-137)]
B $9BB8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BB8-$9BBF-8(interior-tiles-138)]
B $9BC0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BC0-$9BC7-8(interior-tiles-139)]
B $9BC8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BC8-$9BCF-8(interior-tiles-140)]
B $9BD0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BD0-$9BD7-8(interior-tiles-141)]
B $9BD8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BD8-$9BDF-8(interior-tiles-142)]
B $9BE0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BE0-$9BE7-8(interior-tiles-143)]
B $9BE8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BE8-$9BEF-8(interior-tiles-144)]
B $9BF0,8,8 #HTML[#UDGARRAY1,7,4,1;$9BF0-$9BF7-8(interior-tiles-145)]
B $9BF8,8,8 #HTML[#UDGARRAY1,7,4,1;$9BF8-$9BFF-8(interior-tiles-146)]
B $9C00,8,8 #HTML[#UDGARRAY1,7,4,1;$9C00-$9C07-8(interior-tiles-147)]
B $9C08,8,8 #HTML[#UDGARRAY1,7,4,1;$9C08-$9C0F-8(interior-tiles-148)]
B $9C10,8,8 #HTML[#UDGARRAY1,7,4,1;$9C10-$9C17-8(interior-tiles-149)]
B $9C18,8,8 #HTML[#UDGARRAY1,7,4,1;$9C18-$9C1F-8(interior-tiles-150)]
B $9C20,8,8 #HTML[#UDGARRAY1,7,4,1;$9C20-$9C27-8(interior-tiles-151)]
B $9C28,8,8 #HTML[#UDGARRAY1,7,4,1;$9C28-$9C2F-8(interior-tiles-152)]
B $9C30,8,8 #HTML[#UDGARRAY1,7,4,1;$9C30-$9C37-8(interior-tiles-153)]
B $9C38,8,8 #HTML[#UDGARRAY1,7,4,1;$9C38-$9C3F-8(interior-tiles-154)]
B $9C40,8,8 #HTML[#UDGARRAY1,7,4,1;$9C40-$9C47-8(interior-tiles-155)]
B $9C48,8,8 #HTML[#UDGARRAY1,7,4,1;$9C48-$9C4F-8(interior-tiles-156)]
B $9C50,8,8 #HTML[#UDGARRAY1,7,4,1;$9C50-$9C57-8(interior-tiles-157)]
B $9C58,8,8 #HTML[#UDGARRAY1,7,4,1;$9C58-$9C5F-8(interior-tiles-158)]
B $9C60,8,8 #HTML[#UDGARRAY1,7,4,1;$9C60-$9C67-8(interior-tiles-159)]
B $9C68,8,8 #HTML[#UDGARRAY1,7,4,1;$9C68-$9C6F-8(interior-tiles-160)]
B $9C70,8,8 #HTML[#UDGARRAY1,7,4,1;$9C70-$9C77-8(interior-tiles-161)]
B $9C78,8,8 #HTML[#UDGARRAY1,7,4,1;$9C78-$9C7F-8(interior-tiles-162)]
B $9C80,8,8 #HTML[#UDGARRAY1,7,4,1;$9C80-$9C87-8(interior-tiles-163)]
B $9C88,8,8 #HTML[#UDGARRAY1,7,4,1;$9C88-$9C8F-8(interior-tiles-164)]
B $9C90,8,8 #HTML[#UDGARRAY1,7,4,1;$9C90-$9C97-8(interior-tiles-165)]
B $9C98,8,8 #HTML[#UDGARRAY1,7,4,1;$9C98-$9C9F-8(interior-tiles-166)]
B $9CA0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CA0-$9CA7-8(interior-tiles-167)]
B $9CA8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CA8-$9CAF-8(interior-tiles-168)]
B $9CB0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CB0-$9CB7-8(interior-tiles-169)]
B $9CB8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CB8-$9CBF-8(interior-tiles-170)]
B $9CC0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CC0-$9CC7-8(interior-tiles-171)]
B $9CC8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CC8-$9CCF-8(interior-tiles-172)]
B $9CD0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CD0-$9CD7-8(interior-tiles-173)]
B $9CD8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CD8-$9CDF-8(interior-tiles-174)]
B $9CE0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CE0-$9CE7-8(interior-tiles-175)]
B $9CE8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CE8-$9CEF-8(interior-tiles-176)]
B $9CF0,8,8 #HTML[#UDGARRAY1,7,4,1;$9CF0-$9CF7-8(interior-tiles-177)]
B $9CF8,8,8 #HTML[#UDGARRAY1,7,4,1;$9CF8-$9CFF-8(interior-tiles-178)]
B $9D00,8,8 #HTML[#UDGARRAY1,7,4,1;$9D00-$9D07-8(interior-tiles-179)]
B $9D08,8,8 #HTML[#UDGARRAY1,7,4,1;$9D08-$9D0F-8(interior-tiles-180)]
B $9D10,8,8 #HTML[#UDGARRAY1,7,4,1;$9D10-$9D17-8(interior-tiles-181)]
B $9D18,8,8 #HTML[#UDGARRAY1,7,4,1;$9D18-$9D1F-8(interior-tiles-182)]
B $9D20,8,8 #HTML[#UDGARRAY1,7,4,1;$9D20-$9D27-8(interior-tiles-183)]
B $9D28,8,8 #HTML[#UDGARRAY1,7,4,1;$9D28-$9D2F-8(interior-tiles-184)]
B $9D30,8,8 #HTML[#UDGARRAY1,7,4,1;$9D30-$9D37-8(interior-tiles-185)]
B $9D38,8,8 #HTML[#UDGARRAY1,7,4,1;$9D38-$9D3F-8(interior-tiles-186)]
B $9D40,8,8 #HTML[#UDGARRAY1,7,4,1;$9D40-$9D47-8(interior-tiles-187)]
B $9D48,8,8 #HTML[#UDGARRAY1,7,4,1;$9D48-$9D4F-8(interior-tiles-188)]
B $9D50,8,8 #HTML[#UDGARRAY1,7,4,1;$9D50-$9D57-8(interior-tiles-189)]
B $9D58,8,8 #HTML[#UDGARRAY1,7,4,1;$9D58-$9D5F-8(interior-tiles-190)]
B $9D60,8,8 #HTML[#UDGARRAY1,7,4,1;$9D60-$9D67-8(interior-tiles-191)]
B $9D68,8,8 #HTML[#UDGARRAY1,7,4,1;$9D68-$9D6F-8(interior-tiles-192)]
B $9D70,8,8 #HTML[#UDGARRAY1,7,4,1;$9D70-$9D77-8(interior-tiles-193)]
;
c $9D78 Main loop setup.
D $9D78 Used by the routine at #R$F163.
D $9D78 There seems to be litle point in this: enter_room terminates with 'goto main_loop' so it never returns. In fact, the single calling routine (main) might just as well goto enter_room instead of goto main_loop_setup.
@ $9D78 label=main_loop_setup
C $9D78,3 The hero enters a room - returns via squash_stack_goto_main
;
c $9D7B Main game loop.
D $9D7B Used by the routine at #R$691A.
@ $9D7B label=main_loop
C $9D7B,3 Check morale level, report if (near) zero and inhibit player control if exhausted
C $9D7E,3 Check for a BREAK keypress
C $9D81,3 Incrementally wipe and display queued game messages
C $9D84,3 Process player input
C $9D87,3 Check the hero's map position and colour the flag accordingly
C $9D8A,3 Paint any tiles occupied by visible characters with tiles from tile_buf
C $9D8D,3 Move a character around
C $9D90,3 Make characters follow the hero if he's being suspicious
C $9D93,3 Run through all visible characters, resetting them if they're off-screen
C $9D96,3 Spawn characters
C $9D99,3 Mark nearby items
C $9D9C,3 Ring the alarm bell (1)
C $9D9F,3 Animate all visible characters
C $9DA2,3 Move the map when the hero walks
C $9DA5,3 Incrementally wipe and display queued game messages
C $9DA8,3 Ring the alarm bell (2)
C $9DAB,3 Plot vischars and items in order
C $9DAE,3 Plot the game screen
C $9DB1,3 Ring the alarm bell (3)
C $9DB4,7 If the night-time flag is set, turns white screen elements light blue and tracks the hero with a searchlight
C $9DBB,7 If the global current room index is non-zero then slow the game down with a delay loop
C $9DC2,3 Wave the morale flag
C $9DC5,8 Dispatch a timed event event once every 64 ticks of the game counter
C $9DCD,2 ...loop forever
;
c $9DCF Check morale level, report if (near) zero and inhibit player control if exhausted.
D $9DCF Used by the routine at #R$9D7B.
@ $9DCF label=check_morale
C $9DCF,6 If morale is greater than one then return
C $9DD5,6 Queue the message "MORALE IS ZERO"
C $9DDB,5 Set the "morale exhausted" flag to inhibit player input
C $9DE0,4 Immediately take automatic control of the hero
C $9DE4,1 Return
;
c $9DE5 Check for a BREAK keypress.
D $9DE5 Used by the routine at #R$9D7B.
D $9DE5 If pressed then clear the screen and confirm with the player that they want to reset the game. Reset if requested.
@ $9DE5 label=keyscan_break
C $9DE5,15 If shift or space are not pressed then return
C $9DF4,3 Reset the screen
C $9DF7,3 Wait for the player to press 'Y' or 'N'
C $9DFA,3 If 'Y' was pressed (Z set) then reset the game
C $9DFD,7 If the global current room index is room_0_OUTDOORS then !(Reset the hero's position, redraw the scene, then zoombox it onto the screen) and return
C $9E04,3 The hero enters a room - returns via squash_stack_goto_main
;
c $9E07 Process player input.
D $9E07 Used by the routine at #R$9D7B.
N $9E07 Morale exhausted? If so then don't allow input.
@ $9E07 label=process_player_input
C $9E07,3 Simultaneously load the in_solitary and morale_exhausted flags
C $9E0A,4 Return if either is set. This inhibits the player's control
C $9E0E,5 Is the hero is picking a lock, or cutting wire?
C $9E13,2 Jump if not
N $9E15 Hero is picking a lock, or cutting through a wire fence.
C $9E15,5 Postpone automatic control for 31 turns of this routine
C $9E1A,2 Is the hero picking a lock?
C $9E1C,3 Jump to picking_lock if so
C $9E1F,3 Jump to cutting_wire otherwise
@ $9E22 label=process_player_input_no_flags
C $9E22,3 Call the input routine. Input is returned in #REGa. (Note: The routine lives at same address as static_tiles_plot_direction)
C $9E25,3 Take address of the automatic player counter
C $9E28,2 Did the input routine return input_NONE? (zero)
C $9E2A,3 Jump if not
N $9E2D No user input was received: count down the automatic player counter
C $9E2D,3 If the automatic player counter is zero then return
C $9E30,1 Decrement the automatic player counter
C $9E31,1 Set input to input_NONE
C $9E32,2 Jump to end bit
N $9E34 User input was received.
N $9E34 Postpone automatic control for 31 turns.
@ $9E34 label=process_player_input_received
C $9E34,2 Set the automatic player counter to 31
C $9E36,1 Bank input routine result
C $9E37,3 Load hero in bed flag
C $9E3A,1 Is it zero?
C $9E3B,2 Jump to 'hero was in bed' case if not
C $9E3D,3 Load hero at breakfast flag
C $9E40,1 Is it zero?
C $9E41,2 Jump to 'not bed or breakfast' case if so
N $9E43 Hero was at breakfast: make him stand up
C $9E43,6 Set hero's route to 43, step 0
C $9E49,9 Set hero's (x,y) pos to (52,62)
C $9E52,5 Set room definition 25's bench_G object to interiorobject_EMPTY_BENCH
C $9E57,3 Point #REGhl at hero at breakfast flag
C $9E5A,2 Jump to common part
N $9E5C Hero was in bed: make him get up
@ $9E5C label=process_player_input_in_bed
C $9E5C,6 Set hero's route to 44, step 1
@ $9E65 nowarn
C $9E62,6 Set hero's target (x,y) to (46,46)
C $9E68,8 Set hero's (x,y) pos to (46,46)
C $9E70,5 Set hero's height to 24
C $9E75,5 Set room definition 2's bed object to interiorobject_EMPTY_BED
C $9E7A,3 Point #REGhl at hero in bed flag
@ $9E7D label=process_player_input_common
C $9E7D,2 Clear the hero at breakfast / hero in bed flag
C $9E7F,3 Expand out the room definition for room_index
C $9E82,3 Render visible tiles array into the screen buffer.
@ $9E85 label=process_player_input_check_fire
C $9E85,1 Unbank input routine result
C $9E86,2 Was fire pressed?
C $9E88,2 Jump if not
C $9E8A,3 Check for 'pick up', 'drop' and 'use' input events
C $9E8D,2 Set #REGa to input_KICK ($80)
N $9E8F If input state has changed then kick a sprite update.
@ $9E8F label=process_player_input_set_kick
@ $9E8F nowarn
C $9E8F,4 Did the input state change from the hero's existing input?
C $9E93,1 Return if not
C $9E94,3 Kick a sprite update if it did
C $9E97,1 Return
;
c $9E98 Locks the player out until the lock is picked.
D $9E98 Used by the routine at #R$9E07.
@ $9E98 label=picking_lock
C $9E98,8 Return unless player_locked_out_until becomes equal to game_counter
N $9EA0 Countdown reached: Unlock the door.
C $9EA0,5 Clear door_LOCKED ($80) from the door whose lock is being picked
C $9EA5,5 Queue the message "IT IS OPEN"
N $9EAA This entry point is used by the routine at #R$9EB2.
@ $9EAA label=clear_lockpick_wirecut_flags_and_return
C $9EAA,7 Clear the vischar_FLAGS_PICKING_LOCK and vischar_FLAGS_CUTTING_WIRE flags
C $9EB1,1 Return
;
c $9EB2 Locks the player out until the wire is snipped.
D $9EB2 Used by the routine at #R$9E07.
@ $9EB2 label=cutting_wire
C $9EB2,7 How much longer do we have to wait until the wire cutting is complete?
C $9EB9,2 Jump if the countdown reached zero
C $9EBB,3 Return if greater than 3
@ $9EBE nowarn
C $9EBE,3 Read current direction
@ $9EC1 nowarn
C $9EC1,3 Point at cutting_wire_new_inputs
C $9EC4,2 Mask off direction part
C $9EC6,6 Look that up in cutting_wire_new_inputs
@ $9ECC nowarn
C $9ECC,3 Save new input
C $9ECF,1 Return
N $9ED0 Countdown reached zero: Snip the wire.
@ $9ED0 label=cutting_wire_complete
@ $9ED0 nowarn
C $9ED0,3 Point #REGhl at hero's direction field
N $9ED3 Bug: An LD A,(HL) instruction is missing here. #REGa is always zero at this point from above, so $800E is always set to zero. The hero will always face top-left (direction_TOP_LEFT is 0) after breaking through a fence. Note that the DOS x86 version moves zero into $800E - it has no AND - hardcoding the bug.
C $9ED6,3 Set vischar.input to input_KICK
C $9ED9,5 Set vischar height to 24
C $9EDE,2 Jump to clear_lockpick_wirecut_flags_and_return
N $9EE0 New inputs table.
@ $9EE0 label=cutting_wire_new_inputs
B $9EE0,1,1 input_UP   + input_LEFT  + input_KICK
B $9EE1,1,1 input_UP   + input_RIGHT + input_KICK
B $9EE2,1,1 input_DOWN + input_RIGHT + input_KICK
B $9EE3,1,1 input_DOWN + input_LEFT  + input_KICK
;
b $9EE4 Maps route indices to arrays of valid rooms or areas.
D $9EE4 #R$9F21 uses this to check if the hero is in an area permitted for the current route.
@ $9EE4 label=route_to_permitted
B $9EE4,3,3 (Route 42: #R$9EF9)
B $9EE7,3,3 (Route  5: #R$9EFC)
B $9EEA,3,3 (Route 14: #R$9F01)
B $9EED,3,3 (Route 16: #R$9F08)
B $9EF0,3,3 (Route 44: #R$9F0E)
B $9EF3,3,3 (Route 43: #R$9F11)
B $9EF6,3,3 (Route 45: #R$9F13)
N $9EF9 Seven variable-length arrays which encode a list of valid rooms (if top bit is set) or permitted areas (0, 1 or 2) for a given route and step within the route. Terminated with $FF.
N $9EF9 Note that while routes encode transitions _between_ rooms this table encodes individual rooms or areas, so each list here will be one entry longer than the corresponding route.
N $9EF9 In the table: R => Room, A => Area
B $9EF9,3,3 ( R2, R2,                    $FF)
B $9EFC,5,5 ( R3, A1,  A1,  A1,          $FF)
B $9F01,7,7 ( A1, A1,  A1,  A0,  A2, A2, $FF)
B $9F08,6,6 ( A1, A1, R21, R23, R25,     $FF)
B $9F0E,3,3 ( R3, R2,                    $FF)
B $9F11,2,2 (R25,                        $FF)
B $9F13,2,2 ( A1,                        $FF)
;
b $9F15 Boundings of the three main exterior areas.
@ $9F15 label=permitted_bounds
B $9F15,4,4 Corridor to exercise yard
B $9F19,4,4 Hut area
B $9F1D,4,4 Exercise yard area
;
c $9F21 Check the hero's map position, check for escape and colour the flag accordingly.
D $9F21 This also sets the main (hero's) map position in #R$81B8 to that of the hero's vischar position.
D $9F21 Used by the routine at #R$9D7B.
@ $9F21 label=in_permitted_area
C $9F21,3 Point #REGhl at the hero's vischar position
C $9F24,3 Point #REGde at the hero's map position
C $9F27,3 Get the global current room index
C $9F2A,1 Is it indoors?
C $9F2B,3 Jump if so
@ $9F2E label=ipa_outdoors
C $9F2E,3 Scale down the vischar position and assign the result to the hero's map position
N $9F31 Check for the hero escaping across the edge of the map (obviously this only can happen outdoors).
C $9F31,11 If the hero's isometric x position is 217 * 8 or higher... jump to "hero has escaped"
C $9F3C,11 If the hero's isometric y position is 137 * 8 or higher... jump to "hero has escaped"
C $9F47,2 Otherwise jump over the indoors handling
@ $9F49 label=ipa_indoors
C $9F49,8 Copy position across
N $9F51 Set the flag red if picking a lock, or cutting wire.
@ $9F51 label=ipa_picking_or_cutting
C $9F51,3 Read hero's vischar flags
C $9F54,2 AND the flags with (vischar_FLAGS_PICKING_LOCK OR vischar_FLAGS_CUTTING_WIRE)
C $9F56,3 If either of those flags is set then set the morale flag red
N $9F59 Is it night time?
C $9F59,3 Read the game clock
C $9F5C,2 If it's 100 or higher then it's night time
C $9F5E,2 Jump if it's not night time
N $9F60 At night, home room is the only safe place.
@ $9F60 label=ipa_night
C $9F60,3 What room are we in?
C $9F63,2 Is it the home room? (room_2_HUT2LEFT)
C $9F65,3 Jump if so
C $9F68,3 Otherwise set the flag red
N $9F6B If in solitary then bypass all checks.
@ $9F6B label=ipa_day
C $9F6B,4 Are we in solitary?
C $9F6F,3 Jump if we are
N $9F72 Not in solitary: turn the route into an area number then check that area is a permitted one.
C $9F72,3 Point #REGhl at the hero's vischar route
C $9F75,1 Load the route index
C $9F76,2 Load the route step
C $9F78,2 Is the route index's route_REVERSED flag set? ($80)
C $9F7A,2 Jump if not
C $9F7C,1 Otherwise increment the route step
@ $9F7D label=ipa_check_wander
C $9F7D,2 Is the route index routeindex_255_WANDER? ($FF)
C $9F7F,2 Jump if not
N $9F81 Hero is wandering.
C $9F81,3 Load the route step again and clear its bottom three bits
C $9F84,8 If step is 8 then set #REGa to 1 (hut area) otherwise set #REGa to 2 (exercise yard area)
@ $9F8C label=ipa_bounds_check
C $9F8C,3 Check that the hero is in the specified room or camp bounds
C $9F8F,2 Jump if within the permitted area (Z set)
C $9F91,2 Otherwise goto set_flag_red
N $9F93 Hero is en route.
N $9F93 Check regular routes against route_to_permitted.
@ $9F93 label=ipa_en_route
C $9F93,2 Mask off the route_REVERSED flag
C $9F95,3 Point #REGhl at route_to_permitted table
C $9F98,2 Set #REGb for seven iterations
N $9F9A Start loop
@ $9F9A label=ipa_route_check_loop
C $9F9A,2 Does the first byte of the entry match the route index?
C $9F9C,2 Jump if so
C $9F9E,2 Otherwise move to the next entry
C $9FA0,2 ...loop
N $9FA2 If the route is not found in route_to_permitted assume a green flag
C $9FA2,2 Jump if route index wasn't found in the table
N $9FA4 Route index was found in route_to_permitted.
@ $9FA4 label=ipa_route_check_found
C $9FA4,3 Load #REGde with the sub-table's address
C $9FA7,2 Move it into #REGhl
C $9FA9,2 Zero #REGb so we can use #REGbc in the next instruction
C $9FAB,2 Fetch byte at #REGhl + #REGbc
C $9FAD,1 Save the sub-table's address
C $9FAE,3 Check that the hero is in the specified room or camp bounds
C $9FB1,1 Restore the sub-table address
C $9FB2,2 Jump if within the permitted area (Z set)
C $9FB4,3 Load the hero's vischar route index
C $9FB7,5 If the route index's route_REVERSED flag is set ($80) move the sub-table pointer forward by a byte
N $9FBC Search through the list testing against the places permitted for the route we're on.
@ $9FBC label=ipa_check_route_places
C $9FBC,3 Initialise index
N $9FBF Start loop
@ $9FBF label=ipa_check_route_places_loop
C $9FBF,1 Save index
C $9FC0,1 Save sub-table address
C $9FC1,2 Fetch byte at #REGhl + #REGbc
C $9FC3,2 Did we hit the end of the list?
C $9FC5,2 Jump if we did
C $9FC7,3 Check that the hero is in the specified room or camp bounds
C $9FCA,1 Restore the sub-table address
C $9FCB,1 Restore the index
C $9FCC,2 If within the area (Z set) break out of the loop
C $9FCE,1 Increment counter
C $9FCF,2 ...loop
@ $9FD1 label=ipa_set_route_then_set_flag_green
C $9FD1,4 Fetch the hero's route index
C $9FD5,3 Set the hero's route (to #REGa,#REGc) unless in solitary
C $9FD8,2 Jump to "set flag green"
@ $9FDA label=ipa_pop_and_set_flag_red
C $9FDA,2 Restore the stack pointer position - don't care about order
C $9FDC,2 Jump to "set flag red"
N $9FDE Green flag code path.
@ $9FDE label=ipa_set_flag_green
C $9FDE,1 Clear the red flag
C $9FDF,2 Load #REGc with attribute_BRIGHT_GREEN_OVER_BLACK
@ $9FE1 label=ipa_flag_select
C $9FE1,3 Assign red_flag
C $9FE4,1 Shuffle wanted attribute value into #REGa
C $9FE5,3 Point #REGhl at the first attribute byte of the morale flag
C $9FE8,1 Is the flag already the correct colour?
C $9FE9,1 Return if so
C $9FEA,2 Are we in the green flag case?
C $9FEC,3 Exit via set_morale_flag_screen_attributes if not
C $9FEF,5 Silence the bell
C $9FF4,1 Shuffle wanted attribute value into #REGa
C $9FF5,3 Exit via set_morale_flag_screen_attributes
N $9FF8 Red flag code path.
@ $9FF8 label=ipa_set_flag_red
C $9FF8,2 Load #REGc with attribute_BRIGHT_RED_OVER_BLACK
C $9FFA,3 Fetch the first attribute byte of the morale flag
C $9FFD,1 Is the flag already the correct colour?
C $9FFE,1 Return if so
@ $A000 nowarn
C $9FFF,4 Set the vischar's input to 0
C $A003,2 Set the red flag flag
C $A005,2 Jump to flag_select
;
c $A007 Check that the hero is in the specified room or camp bounds.
D $A007 Used by the routine at #R$9F21.
R $A007 I:A If bit 7 is set then bits 0..6 contain a room index. Otherwise it's an area index as passed into within_camp_bounds.
R $A007 O:F Z set if in the permitted area.
@ $A007 label=in_permitted_area_end_bit
C $A007,3 Point #REGhl at the global current room index
C $A00A,2 Was the permitted_route_ROOM flag set on entry? ($80)
C $A00C,2 Jump if not
C $A00E,2 Mask off the room flag
C $A010,1 Does the specified room match the global current room index?
C $A011,1 Return immediately with the result in flags
@ $A012 label=end_bit_area
C $A012,1 Bank A
C $A013,1 Fetch the global current room index
C $A014,1 Is it room_0_OUTDOORS? (0)
C $A015,1 Return if not
C $A016,3 Point #REGde at hero_map_position
C $A019,1 Unbank #REGa - restoring original #REGa
E $A007 FALL THROUGH to within_camp_bounds.
;
c $A01A Is the specified position within the bounds of the indexed area?
D $A01A Used by the routine at #R$CB98.
R $A01A I:A Index (0..2) into permitted_bounds[] table.
R $A01A I:DE Pointer to position (a TinyPos).
R $A01A O:F Z set if position is within the area specified.
R $A01A Point #REGhl at permitted_bounds[A]
@ $A01A label=within_camp_bounds
C $A01A,2 Multiply #REGa by 4
C $A01C,3 Move it into #REGbc
C $A01F,3 Point #REGhl at permitted_bounds
C $A022,1 Add
N $A023 Test position against bounds
C $A023,2 Iterate twice - first checking the X axis, then the Y axis
N $A025 Start loop
C $A025,1 Fetch a position byte
C $A026,1 Is #REGa less than the lower bound?
C $A027,1 Return with flags NZ if so (outside area)
C $A028,1 Move to x1, or y1 on second iteration
C $A029,1 Is #REGa less than the upper bound?
C $A02A,2 Jump to the next loop iteration if so (inside area)
C $A02C,3 Otherwise return with flags NZ (outside area)
C $A02F,1 Advance to second axis for position
C $A030,1 Advance to second axis for bounds
C $A031,2 ...loop
C $A033,2 Return with flags Z (within area)
;
c $A035 Wave the morale flag.
D $A035 Used by the routines at #R$9D7B and #R$F4B7.
@ $A035 label=wave_morale_flag
C $A035,3 Point #REGhl at the game counter
C $A038,1 Increment the game counter in-place
N $A039 Wave the flag on every other turn.
C $A039,1 Now fetch the game counter
C $A03A,2 Is its bottom bit set?
C $A03C,1 Return if so
C $A03D,1 Save the game counter pointer
C $A03E,3 Fetch morale
C $A041,3 Point #REGhl at currently displayed morale
C $A044,1 Is the currently displayed morale different to the actual morale?
C $A045,2 It's equal - jump straight to wiggling the flag
C $A047,3 Actual morale exceeds displayed morale - jump to the increasing case
N $A04A Decreasing morale.
C $A04A,1 Decrement displayed morale
C $A04B,3 Get the current screen address of the morale flag
C $A04E,3 Given a screen address, return the same position on the next scanline down
C $A051,2 Jump over increasing morale block
N $A053 Increasing morale.
C $A053,1 Increment displayed morale
C $A054,3 Get the current screen address of the morale flag
C $A057,3 Given a screen address, returns the same position on the next scanline up
C $A05A,3 Set the screen address of the morale flag
N $A05D Wiggle and draw the flag.
C $A05D,3 Point #REGde at bitmap_flag_down
C $A060,1 Restore the game counter pointer
C $A061,2 Is bit 1 set?
C $A063,2 Skip next instruction if not
N $A065 Note that the last three rows of the bitmap_flag_up bitmap overlap with the first three of the bitmap_flag_down bitmap.
C $A065,3 Point #REGde at bitmap_flag_up
C $A068,3 Get the screen address of the morale flag
C $A06B,3 Plot the flag always at 24x25 pixels in size
C $A06E,3 Exit via plot_bitmap
;
c $A071 Set the screen attributes of the morale flag.
D $A071 Used by the routines at #R$9F21 and #R$F163.
R $A071 I:A Screen attributes to use.
@ $A071 label=set_morale_flag_screen_attributes
C $A071,3 Point #REGhl at the top-left attribute byte of the morale flag
C $A074,3 Set #REGde to the rowskip (32 attributes per row, minus 2)
C $A077,2 The flag is 19 attributes high
N $A079 Start loop
C $A079,5 Write out three attribute bytes
C $A07E,1 Move to next row
C $A07F,2 ...loop
C $A081,1 Return
;
c $A082 Given a screen address, returns the same position on the next scanline up.
D $A082 Spectrum screen memory addresses have the form:
D $A082 #TABLE(default) bit: { 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 } field: { =c3 0-1-0 | =c2 Y7-Y6 | =c3 Y2-Y1-Y0 | =c3 Y5-Y4-Y3 | =c5 X4-X3-X2-X1-X0 } TABLE#
D $A082 To calculate the address of the previous scanline (that is the next scanline higher up) we test two of the fields in sequence and subtract accordingly:
D $A082 Y2-Y1-Y0: If this field is non-zero it's an easy case: we can just decrement the top byte (e.g. using DEC H). Only the bottom three bits of Y will be affected.
D $A082 Y5-Y4-Y3: If this field is zero we can add $FFE0 (-32) to HL. This is like adding "-1" to the register starting from bit 5 upwards. Since Y2-Y1-Y0 and Y5-Y4-Y3 are both zero here we don't care about bits propagating across boundaries.
D $A082 Otherwise we add $06E0 (0000 0110 1110 0000) to HL. This will add 111 binary or "-1" to the Y5-Y4-Y3 field, which will carry out into Y0 for all possible values. Simultaneously it adds 110 binary or "-2" to the Y2-Y1-Y0 field (all zeroes) so the complete field becomes 111. Thus the complete field is decremented.
D $A082 Used by the routine at #R$A035.
R $A082 I:HL Original screen address.
R $A082 O:HL Updated screen address.
@ $A082 label=next_scanline_up
C $A082,5 If Y2-Y1-Y0 zero jump to the complicated case
N $A087 Easy case.
C $A087,1 Just decrement the high byte of the address to go back a scanline
C $A088,1 Return
N $A089 Complicated case.
C $A089,3 Load #REGde with $06E0 by default
C $A08C,3 Is #REGl < 32?
C $A08F,2 Jump if not
C $A091,2 If so bits Y5-Y4-Y3 are clear. Load #REGde with $FFE0 (-32)
C $A093,1 Add
C $A094,1 Return
;
c $A095 Delay loop called only when the hero is indoors.
D $A095 Used by the routine at #R$9D7B.
@ $A095 label=interior_delay_loop
C $A095,8 Count down from 4095
C $A09D,1 Return
;
c $A09E Ring the alarm bell.
D $A09E Used by the routine at #R$9D7B.
D $A09E Called three times from main_loop.
@ $A09E label=ring_bell
C $A09E,3 Point #REGhl at bell ring counter/flag
C $A0A1,1 Fetch its value
C $A0A2,3 If it's bell_STOP then return
C $A0A5,3 If it's bell_RING_PERPETUAL then jump over the decrement code
N $A0A8 Decrement the ring counter.
C $A0A8,2 Decrement and store
C $A0AA,2 If it didn't hit zero then jump over the stop code
N $A0AC Counter hit zero - stop ringing.
C $A0AC,3 Stop the bell
C $A0AF,1 Return
N $A0B0 Fetch visible state of bell from the screen.
C $A0B0,3 Fetch the bell ringing graphic from the screen
C $A0B3,2 Is it $3F? (63)
C $A0B5,3 If so, jump to plot "off" code
C $A0B8,3 Bug: Pointless jump to adjacent instruction
N $A0BB Plot UDG for the bell ringer "on" and make the bell sound
C $A0BB,3 Point #REGde at bell_ringer_bitmap_on
C $A0BE,3 Plot ringer
C $A0C1,5 Play the "bell ringing" sound, exiting via it
N $A0C6 Plot UDG for the bell ringer "off".
C $A0C6,3 Point #REGde at bell_ringer_bitmap_on
E $A09E FALL THROUGH to plot_ringer.
;
c $A0C9 Plot ringer.
D $A0C9 Used by the routine at #R$A09E.
R $A0C9 I:HL Source bitmap.
@ $A0C9 label=plot_ringer
C $A0C9,3 Point #REGhl at screenaddr_bell_ringer
C $A0CC,6 Plot the bell always at 8x12 pixels in size, exiting via it
;
c $A0D2 Increase morale level.
D $A0D2 Used by the routines at #R$A0E9 and #R$A0F2.
R $A0D2 I:B Amount to increase morale level by. (Preserved)
@ $A0D2 label=increase_morale
C $A0D2,4 Fetch morale level and add #REGb onto it
C $A0D6,6 Clamp morale level to morale_MAX (112)
E $A0D2 FALL THROUGH into set_morale.
;
c $A0DC Set morale level.
D $A0DC Used by the routines at #R$A0D2 and #R$A0E0.
R $A0DC I:A Morale.
@ $A0DC label=set_morale
C $A0DC,3 Set morale level to #REGa
C $A0DF,1 Return
;
c $A0E0 Decrease morale level.
D $A0E0 Used by the routines at #R$A1D3, #R$AE78, #R$CB98 and #R$CD31.
R $A0E0 I:B Amount to decrease morale level by. (Preserved)
@ $A0E0 label=decrease_morale
C $A0E0,4 Fetch morale level and subtract #REGb from it
C $A0E4,3 Clamp morale level to morale_MIN (0)
C $A0E7,2 Jump to set_morale
;
c $A0E9 Increase morale by 10, score by 50.
D $A0E9 Used by the routines at #R$B107, #R$B387, #R$B3C4, #R$B3E1, #R$B3F6, #R$B4B8 and #R$EFCB.
@ $A0E9 label=increase_morale_by_10_score_by_50
C $A0E9,5 Increase morale by 10
C $A0EE,4 Increase score by 50, exiting via it
;
c $A0F2 Increase morale by 5, score by 5.
D $A0F2 Used by the routine at #R$7B36.
@ $A0F2 label=increase_morale_by_5_score_by_5
C $A0F2,5 Increase morale by 5
C $A0F7,2 Increase score by 5, exiting via it
;
c $A0F9 Increases the score then plots it.
D $A0F9 Used by the routines at #R$68F4, #R$A0E9 and #R$A0F2.
R $A0F9 I:B Amount to increase score by.
N $A0F9 Increment the score digit-wise until #REGb is zero.
@ $A0F9 label=increase_score
C $A0F9,2 Set #REGa to our base: 10
C $A0FB,3 Point #REGhl at the last of the score digits
N $A0FE Start loop
C $A0FE,1 Save HL
@ $A0FF label=increment_score
C $A0FF,1 Increment the pointed-to score digit by one
C $A100,1 Has the pointed-to digit incremented to equal our base 10?
C $A101,2 No - loop
C $A103,2 Yes - reset the current digit to zero
C $A105,1 Move to the next higher digit
C $A106,2 "Recurse" - we'll arrive at the next instruction when we increment a digit which doesn't roll over
C $A108,1 Restore HL
C $A109,2 ...loop until the (score specified on entry) turns have been had
E $A0F9 FALL THROUGH into plot_score.
;
c $A10B Draws the current score to screen.
D $A10B Used by the routines at #R$B75A and #R$F163.
@ $A10B label=plot_score
C $A10B,3 Point #REGhl at the first of the score digits
C $A10E,3 Point #REGde at the screen address of the score
C $A111,2 Plot five digits
N $A113 Start loop
C $A113,1 Save BC
C $A114,3 Plot a single glyph pointed to by #REGhl at #REGde
C $A117,1 Move to the next score digit
C $A118,1 Move to the next character position (in addition to plot_glyph's increment)
C $A119,1 Restore BC
C $A11A,2 ...loop until all digits plotted
C $A11C,1 Return
;
c $A11D Plays a sound.
D $A11D Used by the routines at #R$7B36, #R$7B8B, #R$A09E, #R$C4E0 and #R$CA81.
R $A11D I:B Number of iterations to play for.
R $A11D I:C Delay inbetween each iteration.
@ $A11D label=play_speaker
C $A11D,4 Self-modify the delay loop at $A126
C $A121,2 Initially set the speaker bit on
N $A123 Start loop
C $A123,2 Play the speaker (and set the border)
C $A125,5 Delay
C $A12A,2 Toggle the speaker bit
C $A12C,2 ...loop
C $A12E,1 Return
;
g $A12F Game counter.
D $A12F Counts 00..FF then wraps.
D $A12F Read-only by main_loop, picking_lock, cutting_wire, action_wiresnips, action_lockpick.
D $A12F Write/read-write by wave_morale_flag.
@ $A12F label=game_counter
B $A12F,1,1
;
g $A130 Bell.
D $A130 #TABLE(default,centre) { =h Value | =h Meaning } { 0 | Ring indefinitely } { 255 | Don't ring } { N | Ring for N calls } TABLE#
D $A130 Read-only by automatics.
D $A130 Write/read-write by in_permitted_area, ring_bell, event_wake_up, event_go_to_roll_call, event_go_to_breakfast_time, event_breakfast_time, event_go_to_exercise_time, event_exercise_time, event_go_to_time_for_bed, searchlight_caught, solitary, guards_follow_suspicious_character, event_roll_call.
@ $A130 label=bell
B $A130,1,1
;
u $A131 Unreferenced byte.
B $A131,1,1
;
g $A132 Score digits.
D $A132 Read-only by plot_score.
D $A132 Write/read-write by increase_score, reset_game.
@ $A132 label=score_digits
B $A132,5,5
;
g $A137 'Hero is at breakfast' flag.
D $A137 Write/read-write by process_player_input, end_of_breakfast, hero_sit_sleep_common.
@ $A137 label=hero_in_breakfast
B $A137,1,1
;
g $A138 'Red morale flag' flag.
D $A138 #TABLE(default,centre) { =h Value | =h Meaning } { 0 | The hero is in a permitted area } { 255 | The hero is not in a permitted area } TABLE#
D $A138 Read-only by automatics, guards_follow_suspicious_character.
D $A138 Write/read-write by in_permitted_area.
@ $A138 label=red_flag
B $A138,1,1
;
g $A139 Automatic player counter.
D $A139 Counts down until zero at which point CPU control of the player is assumed. It's usually set to 31 by input events.
D $A139 Read-only by touch, automatics, character_behaviour.
D $A139 Write/read-write by check_morale, process_player_input, charevnt_hero_release, solitary.
@ $A139 label=automatic_player_counter
B $A139,1,1
;
g $A13A 'In solitary' flag.
D $A13A Stops set_hero_route working.
D $A13A Used to set flag colour.
D $A13A Read-only by process_player_input, in_permitted_area, set_hero_route, automatics.
D $A13A Write/read-write by charevnt_solitary_ends, solitary.
@ $A13A label=in_solitary
B $A13A,1,1
;
g $A13B 'Morale exhausted' flag.
D $A13B Inhibits user input when non-zero.
D $A13B Set by check_morale.
D $A13B Reset by reset_game.
D $A13B Read-only by process_player_input.
D $A13B Write/read-write by check_morale.
@ $A13B label=morale_exhausted
B $A13B,1,1
;
g $A13C Remaining morale.
D $A13C Ranges morale_MIN..morale_MAX.
D $A13C Read-only by check_morale, wave_morale_flag.
D $A13C Write/read-write by increase_morale, decrease_morale, reset_game.
@ $A13C label=morale
B $A13C,1,1
;
g $A13D Game clock.
D $A13D Ranges 0..139.
D $A13D Read-only by in_permitted_area.
D $A13D Write/read-write by dispatch_timed_event, reset_map_and_characters.
@ $A13D label=clock
B $A13D,1,1
;
g $A13E 'Character index is valid' flag.
D $A13E In character_bed_state etc.: when non-zero, character_index is valid, otherwise #REGiy points to character_struct.
D $A13E Read-only by charevnt_bed, charevnt_breakfast.
D $A13E Write/read-write by set_route, spawn_character, move_character, automatics, set_route.
@ $A13E label=entered_move_a_character
B $A13E,1,1
;
g $A13F 'Hero in bed' flag.
D $A13F Read-only by event_night_time,
D $A13F Write/read-write by process_player_input, wake_up, hero_sit_sleep_common.
@ $A13F label=hero_in_bed
B $A13F,1,1
;
g $A140 Currently displayed morale.
D $A140 This lags behind actual morale while the flag moves steadily to its target.
D $A140 Write/read-write by wave_morale_flag.
@ $A140 label=displayed_morale
B $A140,1,1
;
g $A141 Pointer to the screen address where the morale flag was last plotted.
D $A141 Write/read-write by wave_morale_flag.
@ $A141 label=moraleflag_screen_address
W $A141,2,2
;
g $A143 Address of door (in locked_doors[]) in which bit 7 is cleared when picked.
D $A143 Read-only by picking_lock.
D $A143 Write/read-write by action_lockpick.
@ $A143 label=ptr_to_door_being_lockpicked
W $A143,2,2
;
g $A145 The game time when player control will be restored.
D $A145 e.g. when picking a lock or cutting wire.
D $A145 Read-only by picking_lock, cutting_wire.
D $A145 Write/read-write by action_wiresnips, action_lockpick.
@ $A145 label=player_locked_out_until
B $A145,1,1
;
g $A146 'Night-time' flag.
D $A146 #TABLE(default,centre) { =h Value | =h Meaning } { 0 | Daytime } { 255 | Night-time } TABLE#
D $A146 Read-only by main_loop, choose_game_window_attributes.
D $A146 Write/read-write by set_day_or_night, reset_map_and_characters.
@ $A146 label=day_or_night
B $A146,1,1
;
b $A147 Bell ringer bitmaps.
D $A147 These are the bitmaps for the left hand side of the bell graphic which animates when the bell rings.
D $A147 8x12 pixels.
@ $A147 label=bell_ringer_bitmap_off
@ $A153 label=bell_ringer_bitmap_on
B $A147,24,1
;
c $A15F Set game window attributes.
D $A15F Used by the routines at #R$7B36, #R$7B8B, #R$A1D3, #R$A50B, #R$B83B and #R$F350.
D $A15F Starting at $5847, set 23 columns of 16 rows to the specified attribute byte.
R $A15F I:A Attribute byte.
@ $A15F label=set_game_window_attributes
C $A15F,3 Point #REGhl at the top-left game window attribute
C $A162,2 Set rows to 16
C $A164,3 Set rowskip to 9 (32 - 23 columns)
N $A167 Start loop
C $A167,2 Set columns to 23
N $A169 Start loop
C $A169,1 Set attribute byte
C $A16A,1 Step to the next
C $A16B,2 ...loop
C $A16D,1 Add rowskip
C $A16E,1 Decrement row counter
C $A16F,3 ...loop
C $A172,1 Return
;
b $A173 Timed events.
D $A173 Array of 15 structures which map game times to event handlers.
@ $A173 label=timed_events
B $A173,3,3 (   0, event_another_day_dawns ),
B $A176,3,3 (   8, event_wake_up ),
B $A179,3,3 (  12, event_new_red_cross_parcel ),
B $A17C,3,3 (  16, event_go_to_roll_call ),
B $A17F,3,3 (  20, event_roll_call ),
B $A182,3,3 (  21, event_go_to_breakfast_time ),
B $A185,3,3 (  36, event_breakfast_time ),
B $A188,3,3 (  46, event_go_to_exercise_time ),
B $A18B,3,3 (  64, event_exercise_time ),
B $A18E,3,3 (  74, event_go_to_roll_call ),
B $A191,3,3 (  78, event_roll_call ),
B $A194,3,3 (  79, event_go_to_time_for_bed ),
B $A197,3,3 (  98, event_time_for_bed ),
B $A19A,3,3 ( 100, event_night_time ),
B $A19D,3,3 ( 130, event_search_light ),
;
c $A1A0 Dispatch timed events.
D $A1A0 Used by the routine at #R$9D7B.
D $A1A0 Dispatches time-based game events like parcels, meals, exercise and roll calls.
N $A1A0 Increment the clock, wrapping at 140.
@ $A1A0 label=dispatch_timed_event
C $A1A0,3 Point #REGhl at the game clock
C $A1A3,1 Load the game clock
C $A1A4,1 ...and increment it
C $A1A5,5 If it hits 140 then reset it to zero
C $A1AA,1 Then save the game clock back
N $A1AB Find an event for the current clock
C $A1AB,3 Point #REGhl at the timed events table
C $A1AE,2 There are fifteen timed events
N $A1B0 Start loop
@ $A1B0 label=find_event
C $A1B0,2 Does the current event's time match the game clock?
C $A1B2,2 Jump to setup event handler if so
C $A1B4,2 Skip the event handler address
C $A1B6,2 ...loop
C $A1B8,1 Return with no event matched
N $A1B9 Found an event
@ $A1B9 label=event_found
C $A1B9,4 Read the event handler address into #REGhl
N $A1BD Most events need to sound the bell, so prepare for that
C $A1BD,2 Set #REGa to bell_RING_40_TIMES
C $A1BF,3 Point #REGbc at bell
C $A1C2,1 Jump to the event handler
;
c $A1C3 Event: Night time.
@ $A1C3 label=event_night_time
C $A1C3,4 Is the hero already in his bed?
C $A1C7,2 Skip route setting if so
C $A1C9,6 If not in bed set the hero's route to (routeindex_44_HUT2_RIGHT_TO_LEFT, 1) to make him move to bed
C $A1CF,2 Set the night time flag ($FF)
C $A1D1,2 Jump to set_attrs
;
c $A1D3 Event: Another day dawns.
@ $A1D3 label=event_another_day_dawns
C $A1D3,5 Queue the message "ANOTHER DAY DAWNS"
C $A1D8,5 Decrease morale by 25
C $A1DD,1 Clear the night time flag
N $A1DE This entry point is used by the routine at #R$A1C3.
@ $A1DE label=set_attrs
C $A1DE,3 Set the night-time flag to #REGa
C $A1E1,3 Choose game window attributes
C $A1E4,3 Exit via set_game_window_attributes
;
c $A1E7 Event: Wake up.
@ $A1E7 label=event_wake_up
C $A1E7,1 Ring the bell 40 times as passed in
C $A1E8,5 Queue the message "TIME TO WAKE UP"
C $A1ED,3 Exit via wake_up
;
c $A1F0 Event: Go to roll call.
@ $A1F0 label=event_go_to_roll_call
C $A1F0,1 Ring the bell 40 times as passed in
C $A1F1,5 Queue the message "ROLL CALL"
C $A1F6,3 Exit via go_to_roll_call
;
c $A1F9 Event: Go to breakfast time.
@ $A1F9 label=event_go_to_breakfast_time
C $A1F9,1 Ring the bell 40 times as passed in
C $A1FA,5 Queue the message "BREAKFAST TIME"
C $A1FF,3 Exit via set_route_go_to_breakfast
;
c $A202 Event: Breakfast time.
@ $A202 label=event_breakfast_time
C $A202,1 Ring the bell 40 times as passed in
C $A203,3 Exit via end_of_breakfast
;
c $A206 Event: Go to exercise time.
@ $A206 label=event_go_to_exercise_time
C $A206,1 Ring the bell 40 times as passed in
C $A207,5 Queue the message "EXERCISE TIME"
C $A20C,6 Unlock the gates to the exercise yard
C $A212,3 Exit via set_route_go_to_yard
;
c $A215 Event: Exercise time.
@ $A215 label=event_exercise_time
C $A215,1 Ring the bell 40 times as passed in
C $A216,3 Exit via set_route_go_to_yard_reversed
;
c $A219 Event: Go to time for bed.
@ $A219 label=event_go_to_time_for_bed
C $A219,1 Ring the bell 40 times as passed in
C $A21A,6 Lock the gates to the exercise yard
C $A220,5 Queue the message "TIME FOR BED"
C $A225,3 Exit via go_to_time_for_bed
;
c $A228 Event: New red cross parcel.
N $A228 Don't deliver a new red cross parcel while the previous one still exists.
@ $A228 label=event_new_red_cross_parcel
C $A228,3 Fetch the red cross parcel's room (and flags)
C $A22B,2 Mask off the room part
C $A22D,2 Is it $3F? (i.e. room_NONE ($FF) masked)
C $A22F,1 Return if not
N $A230 Select the contents of the next parcel; choosing the first item from the list which does not already exist.
@ $A230 nowarn
C $A230,3 Point #REGde at the red cross parcel contents list
C $A233,2 There are four entries in the list
N $A235 Start loop
C $A235,1 Fetch item number
C $A236,3 Turn it into an itemstruct
C $A239,4 Get its room and mask it
C $A23D,2 Is it $3F? (i.e. room_NONE ($FF) masked)
C $A23F,2 Jump to parcel_found if so
C $A242,2 ...loop while (...)
C $A244,1 Return - a parcel could not be spawned
@ $A245 label=parcel_found
C $A245,4 Set red_cross_parcel_current_contents to the item number
@ $A24C nowarn
C $A249,11 Copy the red cross parcel reset data over the red cross parcel itemstruct
C $A254,5 Queue the message "RED CROSS PARCEL" and exit via
N $A259 Red cross parcel reset data.
@ $A259 label=red_cross_parcel_reset_data
B $A259,1,1 Room: room_20_REDCROSS
B $A25A,3,3 TinyPos: (44, 44, 12)
B $A25D,2,2 Coord: (128, 244)
N $A25F Red cross parcel contents list.
@ $A25F label=red_cross_parcel_contents_list
B $A25F,1,1 item_PURSE
B $A260,1,1 item_WIRESNIPS
B $A261,1,1 item_BRIBE
B $A262,1,1 item_COMPASS
;
g $A263 Current contents of red cross parcel.
@ $A263 label=red_cross_parcel_current_contents
B $A263,1,1
;
c $A264 Event: Time for bed.
@ $A264 label=event_time_for_bed
C $A264,4 Set route to (REVERSED routeindex_38_GUARD_12_BED, 3)
C $A268,2 Jump to $A26E
;
c $A26A Event: Search light.
@ $A26A label=event_search_light
C $A26A,4 Set route to (routeindex_38_GUARD_12_BED, 0)
N $A26E This entry point is used by the routine at #R$A264.
N $A26E Common end of event_time_for_bed and event_search_light. Sets the route for guards 12..15 to (#REGc + 0, #REGa)..(#REGc + 3, #REGa) respectively.
N $A26E TODO: Split off to its own routine
@ $A26E label=set_guards_route
C $A26E,1 bank
C $A26F,2 Set character index to character_12_GUARD_12
C $A271,2 4 iterations
N $A273 Start loop
C $A274,3 Set the route for a character in #REGa to route (#REGa', #REGc)
C $A278,1 Increment the character index
C $A27A,1 Increment the route index
C $A27C,2 ...loop
C $A27E,1 Return
;
b $A27F List of non-player characters: six prisoners and four guards.
D $A27F Read-only by set_prisoners_and_guards_route, set_prisoners_and_guards_route_B.
@ $A27F label=prisoners_and_guards
B $A27F,1,1 character_12_GUARD_12
B $A280,1,1 character_13_GUARD_13
B $A281,1,1 character_20_PRISONER_1
B $A282,1,1 character_21_PRISONER_2
B $A283,1,1 character_22_PRISONER_3
B $A284,1,1 character_14_GUARD_14
B $A285,1,1 character_15_GUARD_15
B $A286,1,1 character_23_PRISONER_4
B $A287,1,1 character_24_PRISONER_5
B $A288,1,1 character_25_PRISONER_6
;
c $A289 Wake up.
D $A289 Used by the routine at #R$A1E7.
@ $A289 label=wake_up
C $A289,7 If the hero's not in bed, jump forward (note: it could jump one instruction later instead)
N $A290 Hero gets out of bed.
C $A290,9 Set the hero's vischar position to (46, 46)
C $A299,4 Clear the 'hero in bed' flag
C $A29D,6 Set the hero's route to (routeindex_42_HUT2_LEFT_TO_RIGHT, 0)
N $A2A3 Position all six prisoners.
C $A2A3,3 Point #REGhl at characterstruct 20's room field (character 20 is the first of the prisoners)
C $A2A6,3 Prepare the characterstruct stride
C $A2A9,2 Prepare room_3_HUT2RIGHT
C $A2AB,2 Do the first three prisoner characters
N $A2AD Start loop
C $A2AD,1 Set this characterstruct's room to room_3_HUT2RIGHT
C $A2AE,1 Advance to the next characterstruct
C $A2AF,2 ...loop
C $A2B1,2 Prepare room_5_HUT3RIGHT
C $A2B3,2 Do the second three prisoner characters
N $A2B5 Start loop
C $A2B5,1 Set this characterstruct's room to room_5_HUT3RIGHT
C $A2B6,1 Advance to the next characterstruct
C $A2B7,2 ...loop
C $A2B9,3 Set initial route index in #REGa'. This gets incremented by set_prisoners_and_guards_route_B for every route it assigns
C $A2BC,2 Zero route step
C $A2BE,3 Set the routes of all characters in prisoners_and_guards
N $A2C1 Update all the bed objects to be empty.
C $A2C1,2 Prepare interiorobject_EMPTY_BED
C $A2C3,3 Point #REGhl at table of pointers to prisoner bed objects
N $A2C6 Bug: Seven iterations are specified here BUT there are only six beds in the 'beds' array. This results in a spurious write to ROM location $1A42.
C $A2C6,2 Set seven iterations
N $A2C8 Start loop
C $A2C8,4 Load the current bed object address into #REGde
C $A2CC,1 Overwrite the current bed object with interiorobject_EMPTY_BED
C $A2CD,2 ...loop
N $A2CF Update the hero's bed object to be empty and redraw if required.
C $A2CF,4 Set room definition 2's bed object to interiorobject_EMPTY_BED
C $A2D3,8 If the global current room index is outdoors, or is not a hut room (6 or above) then return
C $A2DB,3 Expand out the room definition for room_index
C $A2DE,3 Render visible tiles array into the screen buffer.
C $A2E1,1 Return
;
c $A2E2 End of breakfast time.
D $A2E2 Used by the routine at #R$A202.
@ $A2E2 label=end_of_breakfast
C $A2E2,7 If the hero's not at breakfast, jump forward (note: it could jump one instruction later instead)
C $A2E9,9 Set the hero's vischar position to (52,62)
C $A2F2,4 Clear the 'at breakfast' flag
C $A2F6,6 Set the hero's route to (REVERSED routeindex_16_BREAKFAST_25, 3)
N $A2FC Position all six prisoners.
C $A2FC,3 Point #REGhl at characterstruct 20's room field (character 20 is the first of the prisoners)
C $A2FF,3 Prepare the characterstruct stride
C $A302,2 Prepare room_25_MESS_HALL
C $A304,2 Do the first three prisoner characters
N $A306 Start loop
C $A306,1 Set this characterstruct's room to room_25_MESS_HALL
C $A307,1 Advance to the next characterstruct
C $A308,2 ...loop
C $A30A,2 Prepare room_23_MESS_HALL
C $A30C,2 Do the second three prisoner characters
N $A30E Start loop
C $A30E,1 Set this characterstruct's room to room_23_MESS_HALL
C $A30F,1 Advance to the next characterstruct
C $A310,2 ...loop
C $A312,3 Set initial route index in #REGa'. This gets incremented by set_prisoners_and_guards_route_B for every route it assigns
C $A315,2 Set route step to 3
C $A317,3 Set the routes of all characters in prisoners_and_guards
N $A31A Update all the benches to be empty.
C $A31A,2 Prepare interiorobject_EMPTY_BENCH
C $A31C,3 Set room definition 23's bench_A object to interiorobject_EMPTY_BENCH
C $A31F,3 Set room definition 23's bench_B object to interiorobject_EMPTY_BENCH
C $A322,3 Set room definition 23's bench_C object to interiorobject_EMPTY_BENCH
C $A325,3 Set room definition 25's bench_D object to interiorobject_EMPTY_BENCH
C $A328,3 Set room definition 25's bench_E object to interiorobject_EMPTY_BENCH
C $A32B,3 Set room definition 25's bench_F object to interiorobject_EMPTY_BENCH
C $A32E,3 Set room definition 25's bench_G object to interiorobject_EMPTY_BENCH
C $A331,8 If the global current room index is outdoors, or a tunnel room then return
C $A339,3 Expand out the room definition for room_index
C $A33C,3 Render visible tiles array into the screen buffer and exit via (note: different to wake_up's end)
;
c $A33F Set the hero's route, unless he's in solitary.
D $A33F Used by the routines at #R$9F21, #R$A1C3, #R$A289, #R$A2E2, #R$A351, #R$A3F8, #R$A4A9, #R$A4B7, #R$A4C5, #R$A4D8 and #R$A4FD.
R $A33F I:B Route index.
R $A33F I:C Route step.
@ $A33F label=set_hero_route
C $A33F,5 Do nothing if the hero's in solitary
E $A33F FALL THROUGH into set_hero_route_force
;
c $A344 Set the hero's route
D $A344 Used by the routine at #R$C7C6.
R $A344 I:B Route index.
R $A344 I:C Route step.
@ $A344 label=set_hero_route_force
C $A344,5 Clear vischar_FLAGS_TARGET_IS_DOOR flag
C $A349,4 Assign route
C $A34D,3 Set the route
C $A350,1 Return
;
c $A351 Go to time for bed.
D $A351 Used by the routine at #R$A219.
@ $A351 label=go_to_time_for_bed
C $A351,6 Set the hero's route to (REVERSED routeindex_5_EXIT_HUT2, 2)
C $A357,3 Set route index to (REVERSED routeindex_5_EXIT_HUT2)
C $A35A,2 Set route step to 2
C $A35C,3 Set the routes of all characters in prisoners_and_guards and exit via
;
c $A35F Set individual routes for all characters in prisoners_and_guards.
D $A35F The route passed in (#REGa',#REGc) is assigned to the first character. The second character gets route (#REGa'+1,#REGc) and so on.
D $A35F Used by the routine at #R$A4FD.
R $A35F I:A' Route index.
R $A35F I:C Route step.
@ $A35F label=set_prisoners_and_guards_route
C $A35F,3 Point #REGhl at prisoners_and_guards table of character indices
C $A362,2 Iterate over the ten entries
N $A364 Start loop
C $A364,1 Save
C $A365,1 Save
C $A366,1 Fetch the character index
C $A367,3 Set the route for the character
C $A36A,3 Increment the route index
C $A36D,1 Restore
C $A36E,1 Restore
C $A36F,1 Advance to the next character
C $A370,2 ...loop
C $A372,1 Return
;
c $A373 Set joint routes for all characters in prisoners_and_guards.
D $A373 The first half of the list (guards 12,13 and prisoners 1,2,3) are set to the route passed in (#REGa',#REGc). The second half of the list (guards 14,15 and prisoners 4,5,6) are set to route (#REGa'+1,#REGc).
D $A373 Used by the routines at #R$A289, #R$A2E2, #R$A351, #R$A4A9, #R$A4B7 and #R$A4C5.
R $A373 I:A' Route index.
R $A373 I:C Route step.
@ $A373 label=set_prisoners_and_guards_route_B
C $A373,3 Point #REGhl at prisoners_and_guards table of character indices
C $A376,2 Iterate over the ten entries
N $A378 Start loop
C $A378,1 Save
C $A379,1 Save
C $A37A,1 Fetch the character index
C $A37B,3 Set the route for the character
C $A37E,1 Check the loop index
N $A37F When this is 6, the character being processed is character_22_PRISONER_3 and the next is character_14_GUARD_14, the start of the second half of the list.
C $A37F,3 Is it six?
C $A382,2 Jump over if not
C $A384,3 Otherwise increment the route index
C $A387,1 Restore
C $A388,1 Advance to the next character
C $A389,2 ...loop
C $A38B,1 Return
;
c $A38C Set the route for a character.
D $A38C Used by the routines at #R$A26A, #R$A35F and #R$A373.
D $A38C Finds a charstruct, or a vischar, and stores a route.
R $A38C I:A Character index.
R $A38C I:A' Route index.
R $A38C I:C Route step.
R $A38C O:BC Preserved.
@ $A38C label=set_character_route
C $A38C,3 Get a pointer to the character struct in #REGhl for character index #REGa
C $A38F,2 Is the character on-screen? characterstruct_FLAG_ON_SCREEN
C $A391,3 It's not - jump to characterstruct setting code
@ $A394 label=set_vischar_route
C $A394,1 Save route step
C $A395,3 #REGa = *#REGhl & characterstruct_CHARACTER_MASK;
N $A398 Search non-player characters to see if this character is already on-screen.
C $A398,2 There are seven non-player vischars
C $A39A,3 Prepare the vischar stride
@ $A39D nowarn
C $A39D,3 Point #REGhl at the second visible character
N $A3A0 Start loop
C $A3A0,1 Is this the character we want?
C $A3A1,2 Jump if so
C $A3A3,1 Advance the vischar pointer
C $A3A4,2 ...loop
C $A3A6,1 Restore
C $A3A7,2 Jump to exit (note: why not just RET here?)
B $A3A9,1,1 Unreferenced byte
@ $A3AA label=set_character_struct_route
C $A3AA,5 Advance #REGhl to point to the characterstruct's route
C $A3AF,3 Store the route at #REGhl
@ $A3B2 label=set_character_route_exit
C $A3B2,1 Return
@ $A3B3 label=set_character_route_vischar_found
C $A3B3,1 Restore route step
C $A3B4,4 Reset vischar_FLAGS_TARGET_IS_DOOR flag
C $A3B8,3 Store the route at #REGhl
E $A38C FALL THROUGH into set_route.
;
c $A3BB Calls get_target and assigns the result into vischar.
D $A3BB Used by the routine at #R$A33F.
R $A3BB I:HL Points to route.step.
R $A3BB O:BC Preserved.
@ $A3BB label=set_route
C $A3BB,4 Clear the entered_move_a_character flag so that the vischar pointed to by #REGiy is used for character events
C $A3BF,1 Preserve for callers
C $A3C0,1 Preserve route.step pointer
C $A3C1,1 Point #REGhl at route.index
C $A3C2,3 Get our next target: a location, a door or 'route ends'. The result is returned in #REGa, target pointer returned in #REGhl
C $A3C5,1 Restore route.step pointer to #REGde
C $A3C6,1 Point #REGde at vischar.target
C $A3C7,4 Copy target across
C $A3CB,2 Did #R$C651 return get_target_ROUTE_ENDS? ($FF)
C $A3CD,3 Jump if not
N $A3D0 Result was 'route ends'
C $A3D0,4 Point #REGde at the vischar's start
C $A3D4,3 Assign current vischar to #REGiy
C $A3D7,1 Swap vischar pointer into #REGhl
C $A3D8,2 Point #REGhl at route
C $A3DA,3 Call get_target_assign_pos so that the end-of-route handling code is invoked if required. Note: This seems like something of a waste as get_target is (appears to be) called again with the same arguments as above
C $A3DD,1 Restore
C $A3DE,1 Return
N $A3DF Result was a location or a door
@ $A3DF label=set_route_not_end
C $A3DF,2 Did #R$C651 return get_target_DOOR? ($80)
C $A3E1,3 Jump if not (it must be get_target_LOCATION)
@ $A3E4 label=set_route_door
C $A3E4,4 Point #REGde at vischar.flags
C $A3E8,1 Swap vischar pointer into #REGhl
C $A3E9,2 Set the vischar_FLAGS_TARGET_IS_DOOR flag
@ $A3EB label=set_route_exit
C $A3EB,1 Restore
C $A3EC,1 Return
;
c $A3ED Store a route at the specified address.
D $A3ED Used by the routine at #R$A38C.
R $A3ED I:A' Route index.
R $A3ED I:C Route step.
R $A3ED I:HL Pointer to route.
R $A3ED O:HL Pointer to route.step.
@ $A3ED label=store_route
C $A3ED,1 Unbank the route index
C $A3EE,1 Store the route index
C $A3EF,1 Bank the route index
C $A3F0,2 Store the route step
C $A3F2,1 Return
;
c $A3F3 Character goes to bed: used when entered_move_a_character is non-zero.
D $A3F3 Used by the routine at #R$C7C6.
R $A3F3 I:HL Pointer to location.
@ $A3F3 label=character_bed_state
C $A3F3,3 Get the current character index
C $A3F6,2 Jump to character_bed_common
;
c $A3F8 Character goes to bed: used when entered_move_a_character is zero.
D $A3F8 Used by the routine at #R$C7C6.
R $A3F8 I:HL Pointer to location.
@ $A3F8 label=character_bed_vischar
C $A3F8,3 Read the current vischar's character index
C $A3FB,3 If it's not the commandant (0) then goto character_bed_common
C $A3FE,6 Otherwise set the commandant's route to ($2C,$00) and exit via
;
c $A404 Common end of above two routines.
D $A404 Used by the routines at #R$A3F3 and #R$A3F8.
R $A404 I:A Character index.
R $A404 I:HL Pointer to route.
@ $A404 label=character_bed_common
C $A404,3 Clear route's step
C $A407,2 Is the character a hostile? (its index less than or equal to character_19_GUARD_DOG_4)
C $A409,6 Jump to hostile handling if so
C $A40F,2 Compute the route index by subtracting 13 from the character index, e.g. character 20 is assigned route 7
C $A411,2 Jump to end part
@ $A413 label=character_bed_hostile
C $A413,2 Does this hostile have an odd numbered character index?
C $A415,2 Set the default route index to 13
C $A417,2 Jump to exit if it had an even numbered character index
C $A419,4 Otherwise reverse its route by setting the route step to 1 and setting the reversed route flag
C $A41D,2 Save route index
C $A41F,1 Return
;
c $A420 Character sits.
D $A420 Used by the routine at #R$C7C6.
R $A420 I:A Route index.
R $A420 I:HL Pointer to route.
@ $A420 label=character_sits
C $A420,1 Save the route index
C $A421,1 Move the route pointer into #REGde for the common part later
C $A422,2 Bias the route index by 18
C $A424,3 Point #REGhl at room definition 25's bench_D
C $A427,4 Is #REGa equal to two or lower? Jump if so
C $A42B,3 Point #REGhl at room definition 23's bench_A
C $A42E,2 Bias...
N $A430 Poke object.
C $A430,3 Triple #REGa
C $A433,3 Move it into #REGbc
C $A436,1 Point to the required object
C $A437,2 Set the object at #REGhl to interiorobject_PRISONER_SAT_MID_TABLE ($05)
C $A439,1 Restore the route index
C $A43A,2 Room is room_25_MESS_HALL
C $A43C,2 Is the route index less than routeindex_21_PRISONER_SITS_1?
C $A43E,2 Jump if so
C $A440,2 Otherwise room is room_23_MESS_HALL
C $A442,2 Jump to character_sit_sleep_common
;
c $A444 Character sleeps.
D $A444 Used by the routine at #R$C7C6.
R $A444 I:A Route index.
R $A444 I:HL Pointer to route.
@ $A444 label=character_sleeps
C $A444,1 Save the route index
C $A445,2 Route indices 7..12 map to beds array indices 0..5
C $A447,1 Turn index into an offset
C $A448,1 Move the route pointer into #REGde for the common part later
N $A449 Poke object.
C $A449,10 Fetch the bed object pointer from beds array
C $A453,3 Write interiorobject_OCCUPIED_BED to the bed object
C $A456,1 Restore the route index
C $A457,2 Is the route index greater than or equal to routeindex_10_PRISONER_SLEEPS_1?
C $A459,3 Jump if so
C $A45C,4 Otherwise room is room_3_HUT2RIGHT
C $A460,2 Room is room_5_HUT3RIGHT
E $A444 FALL THROUGH into character_sit_sleep_common.
;
c $A462 Common end of character sits/sleeps.
D $A462 Used by the routines at #R$A420 and #R$A444.
R $A462 I:C Room.
R $A462 I:DE Pointer to route.
@ $A462 label=character_sit_sleep_common
C $A462,1 Move the route pointer back into #REGhl
C $A463,2 Stand still - set the character's route to route_HALT ($00) (Note: This receives a pointer to a route structure which is within either a characterstruct or a vischar).
C $A465,1 (unknown)
C $A466,6 If the global current room index matches #REGc ... Jump to refresh code
N $A46C Character is sitting or sleeping in a room presently not visible.
C $A46C,4 Point #REGhl at characterstruct's room member
C $A470,2 Set room to room_NONE ($FF)
C $A472,1 Return
N $A473 Character is visible - force a repaint.
@ $A473 label=character_sit_sleep_refresh
C $A473,4 Pointer #REGhl at vischar's room member
C $A477,2 Set room to room_NONE ($FF)
E $A462 FALL THROUGH into select_room_and_plot.
;
c $A479 Select room and plot.
D $A479 Used by the routine at #R$A491.
@ $A479 label=select_room_and_plot
C $A479,3 Expand out the room definition for room_index
C $A47C,3 Render visible tiles array into the screen buffer, exit via
;
c $A47F The hero sits.
D $A47F Used by the routine at #R$C7C6.
@ $A47F label=hero_sits
C $A47F,5 Set room definition 25's bench_G object (where the hero sits) to interiorobject_PRISONER_SAT_DOWN_END_TABLE
C $A484,3 Point #REGhl at the hero_in_breakfast flag
C $A487,2 Jump to hero_sit_sleep_common
;
c $A489 The hero sleeps.
D $A489 Used by the routines at #R$B75A and #R$C7C6.
@ $A489 label=hero_sleeps
C $A489,5 Set room definition 2's bed object (where the hero sleeps) to interiorobject_OCCUPIED_BED
C $A48E,3 Point #REGhl at the hero_in_bed flag
E $A489 FALL THROUGH into hero_sit_sleep_common.
;
c $A491 Common end of hero sits/sleeps.
D $A491 Used by the routine at #R$A47F.
R $A491 I:HL Pointer to hero_in_breakfast or hero_in_bed flag.
@ $A491 label=hero_sit_sleep_common
C $A491,2 Set the sit/sleep flag, whichever it was
C $A493,5 Stand still - set the hero's route to route_HALT ($00)
N $A498 Set hero position (x,y) to zero.
C $A498,9 Zero $800F..$8012
C $A4A1,6 Reset the hero's screen position
C $A4A7,2 Exit via select_room_and_plot
;
c $A4A9 Set hero's and prisoners_and_guards's routes to "go to yard".
D $A4A9 Used by the routine at #R$A206.
@ $A4A9 label=set_route_go_to_yard
C $A4A9,6 Set the hero's route to (routeindex_14_GO_TO_YARD, 0)
C $A4AF,8 And set the routes of all characters in prisoners_and_guards to the same route (exit via)
;
c $A4B7 Set hero's and prisoners_and_guards's routes to "go to yard" reversed.
D $A4B7 Used by the routine at #R$A215.
@ $A4B7 label=set_route_go_to_yard_reversed
C $A4B7,6 Set the hero's route to (REVERSED routeindex_14_GO_TO_YARD, 4)
C $A4BD,8 And set the routes of all characters in prisoners_and_guards to the same route (exit via)
;
c $A4C5 Set hero's and prisoners_and_guards's routes to "go to breakfast".
D $A4C5 Used by the routine at #R$A1F9.
@ $A4C5 label=set_route_go_to_breakfast
C $A4C5,6 Set the hero's route to (routeindex_16_BREAKFAST_25, 0)
C $A4CB,8 And set the routes of all characters in prisoners_and_guards to the same route (exit via)
;
c $A4D3 Character event: used when entered_move_a_character is non-zero.
D $A4D3 Used by the routine at #R$C7C6.
D $A4D3 Something character related [very similar to the routine at $A3F3].
@ $A4D3 label=charevnt_breakfast_state
C $A4D3,3 Get the current character index
C $A4D6,2 Jump to charevnt_breakfast_common
;
c $A4D8 Character event: used when entered_move_a_character is zero.
D $A4D8 Used by the routine at #R$C7C6.
@ $A4D8 label=charevnt_breakfast_vischar
C $A4D8,3 Read the current vischar's character index
C $A4DB,3 If it's not the commandant (0) then goto charevnt_breakfast_common
C $A4DE,6 Otherwise set the commandant's route to ($2B,$00) and exit via
;
c $A4E4 Common end of above two routines.
D $A4E4 Sets routes for prisoners and guards.
D $A4E4 Used by the routines at #R$A4D3 and #R$A4D8.
R $A4E4 I:A Character index.
R $A4E4 I:HL Pointer to route.
@ $A4E4 label=charevnt_breakfast_common
C $A4E4,3 Set the route's step to zero
C $A4E7,2 Is the character index less than or equal to character_19_GUARD_DOG_4?
C $A4E9,6 Jump to hostile handling if so
C $A4EF,2 Map prisoner 1..6 to route 18..23 (routes to sitting)
C $A4F1,2 Jump to store
C $A4F3,2 Is the character index odd?
C $A4F5,2 Route index is 24 if even
C $A4F7,2 Jump to store if even
C $A4F9,1 Route index is 25 if odd
C $A4FA,2 Store route index
C $A4FC,1 Return
;
c $A4FD Go to roll call.
D $A4FD Used by the routine at #R$A1F0.
@ $A4FD label=go_to_roll_call
C $A4FD,5 Set route to (routeindex_26_GUARD_12_ROLL_CALL, 0)
C $A502,3 Set individual routes for prisoners_and_guards
C $A505,6 Set the hero's route to (routeindex_45_HERO_ROLL_CALL, 0)
;
c $A50B Reset the screen.
D $A50B Used by the routines at #R$9DE5 and #R$A51C.
@ $A50B label=screen_reset
C $A50B,3 Wipe the visible tiles array
C $A50E,3 Render visible tiles array into the screen buffer
C $A511,3 Zoombox the scene onto the screen
C $A514,3 Plot the game screen
C $A517,2 Set #REGa to attribute_WHITE_OVER_BLACK
C $A519,3 Set game window attributes (exit via)
;
c $A51C Hero has escaped.
D $A51C Used by the routine at #R$9F21.
D $A51C Print 'well done' message then test to see if the correct objects were used in the escape attempt.
@ $A51C label=escaped
C $A51C,3 Reset the screen
N $A51F Print standard prefix messages.
C $A51F,3 Point #REGhl at the escape messages
C $A522,9 Print "WELL DONE" "YOU HAVE ESCAPED" "FROM THE CAMP" (each print call advances #REGhl)
N $A52B Form an escape items bitfield.
C $A52B,2 Clear the item flags
C $A52D,3 Point #REGhl at the first held item
C $A530,3 Turn the item into a flag
C $A533,1 Point #REGhl at the second held item
C $A534,3 Turn the item into a flag, merging with previous result
N $A537 Print item-tailored messages.
C $A537,1 Move flags into #REGa
C $A538,4 If the flags show we're holding are escapeitem_COMPASS and escapeitem_PURSE then jump to the success case
C $A53C,4 Otherwise if we don't have both escapeitem_COMPASS and escapeitem_PAPERS jump to the captured case
@ $A540 label=escaped_success
@ $A540 nowarn
C $A540,3 Point #REGhl at the fourth escape message
C $A543,6 Print "AND WILL CROSS THE "BORDER SUCCESSFULLY"
C $A549,3 Signal to reset the game at the end of this routine
C $A54C,2 Jump to "press any key"
@ $A54E label=escaped_captured
C $A54E,1 Save flags
@ $A54F nowarn
C $A54F,3 Point #REGhl at the sixth escape message
C $A552,3 Print "BUT WERE RECAPTURED"
C $A555,2 Fetch flags
C $A557,4 If flags include escapeitem_UNIFORM print "AND SHOT AS A SPY"
@ $A55B nowarn
C $A55B,3 Point #REGhl at the eighth escape message
C $A55E,3 If flags is zero then print "TOTALLY UNPREPARED"
@ $A561 nowarn
C $A561,3 Point #REGhl at the ninth escape message
C $A564,4 If there was no compass then print "TOTALLY LOST"
@ $A568 nowarn
C $A568,3 Print "DUE TO LACK OF PAPERS"
@ $A56B label=escaped_plot
C $A56B,3 Print
@ $A56E nowarn
@ $A56E label=escaped_press_any_key
C $A56E,6 Print "PRESS ANY KEY"
N $A574 Wait for a keypress.
C $A574,5 Wait for a key down
C $A579,5 Wait for a key up
C $A57E,1 Fetch flags
N $A57F Reset the game, or send the hero to solitary.
C $A57F,2 Are the flags $FF?
C $A581,3 Reset the game if so (exit via)
C $A584,2 Are the flags greater or equal to escapeitem_UNIFORM?
C $A586,3 Reset the game if so (exit via)
C $A589,3 Otherwise send the hero to solitary (exit via)
;
c $A58C Check for any key press.
D $A58C Used by the routine at #R$A51C.
R $A58C O:F NZ if a key was pressed, Z otherwise.
@ $A58C label=keyscan_all
C $A58C,3 Set #REGb to $FE (initial keyboard half-row selector) and #REGc to $FE (keyboard port number)
N $A58F Start loop
C $A58F,2 Read the port
C $A591,1 Complement the value returned to change it from active-low
C $A592,2 Discard any non-key flags
C $A594,1 Return with Z clear if any key was pressed
C $A595,2 Rotate the half-row selector ($FE -> $FD -> $FB -> .. -> $7F)
C $A597,3 ...loop until the zero bit shifts out (eight iterations)
C $A59A,2 No keys were pressed - return with Z set
;
c $A59C Call item_to_escapeitem then merge result with a previous escapeitem.
D $A59C Used by the routine at #R$A51C.
R $A59C I:C Previous return value.
R $A59C I:HL Pointer to (single) item slot.
R $A59C O:C Previous return value + escapeitem_ flag.
@ $A59C label=join_item_to_escapeitem
C $A59C,1 Fetch the item we've been pointed at
C $A59D,3 Turn the item into a flag
C $A5A0,2 Merge the new flag with the previous
C $A5A2,1 Return
;
c $A5A3 Return a bitmask indicating the presence of items required for escape.
D $A5A3 Used by the routine at #R$A59C.
R $A5A3 I:A Item.
R $A5A3 O:A Bitfield.
@ $A5A3 label=item_to_escapeitem
C $A5A3,2 Is it item_COMPASS?
C $A5A5,2 No - try the next interesting item
C $A5A7,3 Otherwise return flag escapeitem_COMPASS
C $A5AA,2 Is it item_PAPERS?
C $A5AC,2 No - try the next interesting item
C $A5AE,3 Otherwise return flag escapeitem_PAPERS
C $A5B1,2 Is it item_PURSE?
C $A5B3,2 No - try the next interesting item
C $A5B5,3 Otherwise return flag escapeitem_PURSE
C $A5B8,2 Is it item_UNIFORM?
C $A5BA,3 Return escapeitem_UNIFORM if so
C $A5BD,2 Otherwise return zero
;
c $A5BF Plot a screenlocstring.
D $A5BF A screenlocstring is a structure consisting of a screen address at which to start drawing, a count of glyph indices and an array of that number of glyph indices.
D $A5BF Used by the routines at #R$A51C, #R$EFFC and #R$F1E0.
R $A5BF I:HL Pointer to screenlocstring.
R $A5BF O:HL Pointer to byte after screenlocstring.
@ $A5BF label=screenlocstring_plot
C $A5BF,4 Read the screen address into #REGde
C $A5C3,2 Read the number of characters to plot
N $A5C5 #REGhl now points at the first glyph to plot
N $A5C5 Start loop
@ $A5C5 label=screenlocstring_loop
C $A5C5,1 Save the counter
C $A5C6,3 Plot a single glyph
C $A5C9,1 Advance the glyph pointer
C $A5CA,1 Restore the counter
C $A5CB,2 ...loop until the counter is zero
C $A5CD,1 Return
t $A5CE Escape messages.
D $A5CE "WELL DONE"
@ $A5CE label=escape_strings
B $A5CE,12,12 #HTML[#CALL:decode_screenlocstring($A5CE)]
N $A5DA "YOU HAVE ESCAPED"
B $A5DA,19,19 #HTML[#CALL:decode_screenlocstring($A5DA)]
N $A5ED "FROM THE CAMP"
B $A5ED,16,16 #HTML[#CALL:decode_screenlocstring($A5ED)]
N $A5FD "AND WILL CROSS THE"
B $A5FD,21,21 #HTML[#CALL:decode_screenlocstring($A5FD)]
N $A612 "BORDER SUCCESSFULLY"
B $A612,22,22 #HTML[#CALL:decode_screenlocstring($A612)]
N $A628 "BUT WERE RECAPTURED"
B $A628,22,22 #HTML[#CALL:decode_screenlocstring($A628)]
N $A63E "AND SHOT AS A SPY"
B $A63E,20,20 #HTML[#CALL:decode_screenlocstring($A63E)]
N $A652 "TOTALLY UNPREPARED"
B $A652,21,21 #HTML[#CALL:decode_screenlocstring($A652)]
N $A667 "TOTALLY LOST"
B $A667,15,15 #HTML[#CALL:decode_screenlocstring($A667)]
N $A676 "DUE TO LACK OF PAPERS"
B $A676,24,24 #HTML[#CALL:decode_screenlocstring($A676)]
N $A68E "PRESS ANY KEY"
B $A68E,16,16 #HTML[#CALL:decode_screenlocstring($A68E)]
;
b $A69E Bitmap font definition.
D $A69E 0..9, A..Z (omitting O), space, full stop
D $A69E #UDGTABLE { #FONT$A69E,35,7,2{0,0,560,16}(font) } TABLE#
@ $A69E label=bitmap_font
B $A69E,8,8 0
B $A6A6,8,8 1
B $A6AE,8,8 2
B $A6B6,8,8 3
B $A6BE,8,8 4
B $A6C6,8,8 5
B $A6CE,8,8 6
B $A6D6,8,8 7
B $A6DE,8,8 8
B $A6E6,8,8 9
B $A6EE,8,8 A
B $A6F6,8,8 B
B $A6FE,8,8 C
B $A706,8,8 D
B $A70E,8,8 E
B $A716,8,8 F
B $A71E,8,8 G
B $A726,8,8 H
B $A72E,8,8 I
B $A736,8,8 J
B $A73E,8,8 K
B $A746,8,8 L
B $A74E,8,8 M
B $A756,8,8 N
B $A75E,8,8 P
B $A766,8,8 Q
B $A76E,8,8 R
B $A776,8,8 S
B $A77E,8,8 T
B $A786,8,8 U
B $A78E,8,8 V
B $A796,8,8 W
B $A79E,8,8 X
B $A7A6,8,8 Y
B $A7AE,8,8 Z
B $A7B6,8,8 SPACE
B $A7BE,8,8 FULL STOP
;
g $A7C6 An index used only by move_map().
@ $A7C6 label=move_map_y
B $A7C6,1,1
;
g $A7C7 Game window plotting offset.
@ $A7C7 label=game_window_offset
W $A7C7,2,2
;
c $A7C9 Get supertiles.
D $A7C9 Using map_position copies supertile indices from map_tiles at $BCB8 into the map_buf buffer at $FF58.
D $A7C9 Used by the routines at #R$A9E4, #R$AA05, #R$AA26, #R$AA4B, #R$AA6C, #R$AA8D and #R$B2FC.
N $A7C9 Get vertical offset.
@ $A7C9 label=get_supertiles
C $A7C9,5 Get the map position's Y component and round it down to a multiple of four
N $A7CE Multiply the Y component by 13.5 producing 0, 54, 108, 162, ...
C $A7CE,3 Copy #REGa into #REGhl
C $A7D1,3 Halve #REGa
C $A7D4,5 Add #REGa to #REGhl, giving us Y multiplied by 1.5
C $A7D9,2 Copy #REGhl into #REGde
C $A7DB,4 Multiply by nine, giving us Y multiplied by 13.5
C $A7DF,3 Point #REGde at map_tiles but minus a whole row
C $A7E2,1 Combine
N $A7E3 Add the X component.
C $A7E3,7 Get the map position's X component and divide it by 4
C $A7EA,3 Move #REGa into #REGde
C $A7ED,1 Combine. Now we have a pointer into map_tiles
N $A7EE Populate map_buf with 7x5 array of supertile refs.
C $A7EE,2 Five rows
C $A7F0,3 Point #REGde at map_buf (a 7x5 scratch buffer which holds copied-out supertile indices)
N $A7F3 Start loop
C $A7F3,14 Fill the buffer row with seven bytes from #REGhl
C $A801,4 Move #REGhl forward by (stride - width of map_buf)
C $A805,4 ...loop
C $A809,1 Return
;
c $A80A Plot the complete bottommost row of tiles.
D $A80A Used by the routines at #R$AA26 and #R$AA4B.
@ $A80A label=plot_bottommost_tiles
@ $A80A nowarn
C $A80A,4 Point #REGde' at the start of tile_buf's final row (= tile_buf + 24 * 16)
@ $A80E nowarn
C $A80E,3 Point #REGhl at the start of map_buf's final row (= map_buf + 7 * 4)
C $A811,3 Get the map's Y coordinate
@ $A814 nowarn
C $A814,3 Point #REGde at the start of window_buf's final row (= window_buf + 24 * 16 * 8)
C $A817,2 Jump to plot_horizontal_tiles_common
;
c $A819 Plot the complete topmost row of tiles.
D $A819 Used by the routines at #R$AA6C and #R$AA8D.
@ $A819 label=plot_topmost_tiles
C $A819,4 Point #REGde' at the start of tile_buf's first row
C $A81D,3 Point #REGhl at the start of map_buf's first row
C $A820,3 Get the map's Y coordinate
C $A823,3 Point #REGde at the start of window_buf's first row
E $A819 FALL THROUGH into plot_horizontal_tiles_common
;
c $A826 Plots a single horizontal row of tiles to the screen buffer.
D $A826 Simultaneously updates the visible tiles buffer.
D $A826 Used by the routine at #R$A80A.
R $A826 I:A Map Y position
R $A826 I:DE Pointer into the 24x17 visible tiles array ("tile_buf")
R $A826 I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
R $A826 I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
@ $A826 label=plot_horizontal_tiles_common
C $A826,4 Compute the row offset within a supertile from the map's Y position (0, 4, 8 or 12)
C $A82A,3 Self modify the "LD A,$xx" instruction at #R$A869 to load the row offset
C $A82D,1 Preserve the row offset in #REGc for the next step
C $A82E,5 Compute the column offset within a supertile from the map's X position (0, 1, 2 or 3)
C $A833,1 Now add it to the row offset - giving the combined offset
C $A834,1 Bank the combined offset
N $A835 Initial edge. This draws up to 4 tiles.
C $A835,1 Fetch a supertile index from map_buf
C $A836,1 Switch register banks for the initial edge
C $A837,11 Point #REGhl at super_tiles[A]
C $A842,1 Unbank the combined offset
C $A843,2 Add on the combined offset to #REGhl to point us at the appropriate part of the supertile
C $A845,8 Turn 0,1,2,3 into 4,3,2,1 - the number of initial loop iterations
C $A84D,1 Set 1..4 iterations
N $A84E Start loop
C $A84E,1 Fetch a tile index from the super tile pointer
C $A84F,1 Store it in visible tiles (#REGde' on entry)
C $A850,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl'
C $A853,1 Advance the tile pointer
C $A854,1 Advance the visible tiles pointer
C $A855,2 ...loop
C $A857,1 Unbank
C $A858,1 Advance the map buffer pointer
N $A859 Middle loop.
C $A859,2 There are always five iterations (five supertiles in the middle section).
N $A85B Start loop (outer) -- advanced for each supertile
C $A85B,1 Preserve the loop counter
C $A85C,1 Fetch a supertile index from the map buffer pointer
C $A85D,1 Switch register banks during the middle loop
C $A85E,11 Point #REGhl at super_tiles[A]
@ $A869 label=supertile_plot_horizontal_common_iters
C $A869,2 Load the row offset - self modified by $A82A
C $A86B,2 Add on the row offset to #REGhl
C $A86D,2 Supertiles are four tiles wide
N $A86F Start loop (inner) -- advanced for each tile
C $A86F,1 Fetch a tile index from the super tile pointer
C $A870,1 Store it in visible tiles
C $A871,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl'
C $A874,1 Advance the tiles pointer
C $A875,1 Advance the visible tiles pointer
C $A876,2 ...loop (inner)
C $A878,1 Unbank
C $A879,1 Advance the map buffer pointer
C $A87A,1 Restore the loop counter
C $A87B,2 ...loop (outer)
N $A87D Trailing edge.
C $A87D,2 Spurious instructions
C $A87F,1 Fetch a supertile index from map_buf
C $A880,1 Switch register banks during the trailing loop
C $A881,11 Point #REGhl at super_tiles[A]
C $A88C,3 Load the row offset from (self modified) $A86A
C $A88F,2 Add on the row offset to #REGhl
C $A891,5 Form the trailing loop iteration counter
C $A896,1 Return if no iterations are required
C $A897,1 Move iterations into #REGb
N $A898 Start loop
C $A898,1 Fetch a tile index from the super tile pointer
C $A899,1 Store it in visible tiles
C $A89A,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl'
C $A89D,1 Advance the tiles pointer
C $A89E,1 Advance the visible tiles pointer
C $A89F,2 ...loop
C $A8A1,1 Return
;
c $A8A2 Plot all tiles.
D $A8A2 Renders the complete screen by plotting all vertical columns in turn.
D $A8A2 Used by the routines at #R$7B36 and #R$B2FC.
D $A8A2 Note: Exits with banked registers active.
@ $A8A2 label=plot_all_tiles
C $A8A2,3 Point #REGde at the 24x17 visible tiles array ("tile_buf")
C $A8A5,1 Bank
C $A8A6,3 Point #REGhl' at the 7x5 supertile indices buffer ("map_buf")
C $A8A9,3 Point #REGde' at the 24x17x8 screen buffer ("window_buf")
C $A8AC,3 Get map X position
C $A8AF,2 Set 24 iterations (screen columns)
N $A8B1 Start loop
C $A8B1,1 Preserve the loop counter
C $A8B2,1 Preserve the screen buffer pointer
C $A8B3,1 Preserve the supertile indices pointer
C $A8B4,1 Preserve the map X position
C $A8B5,1 Unbank
C $A8B6,1 Preserve the visible tiles pointer
C $A8B7,1 Bank
C $A8B8,3 Plot a complete column of tiles
C $A8BB,1 Unbank
C $A8BC,2 Restore and advance the visible tiles pointer
C $A8BE,1 Bank
C $A8BF,1 Restore the map X position
C $A8C0,1 Restore the supertile indices pointer
C $A8C1,1 Advance the map X position
C $A8C2,1 Save the result in #REGc
C $A8C3,5 If the X position hits a multiple of 4 advance to the next supertile
C $A8C8,1 Restore the map X position
C $A8C9,2 Restore and advance the screen buffer pointer to the next column
C $A8CB,1 Restore the loop counter
C $A8CC,2 ...loop
C $A8CE,1 Return
;
c $A8CF Plot the complete rightmost column of tiles.
D $A8CF Used by the routines at #R$A9E4 and #R$AA8D.
@ $A8CF label=plot_rightmost_tiles
@ $A8CF nowarn
C $A8CF,3 Point #REGde at the 24x17 visible tiles array ("tile_buf") rightmost column [+23]
C $A8D2,1 Bank
C $A8D3,3 Point #REGhl' at the 7x5 supertile indices buffer ("map_buf") rightmost supertile [+6]
C $A8D6,3 Point #REGde' at the 24x17x8 screen buffer ("window_buf") rightmost column [+23]
C $A8D9,5 Compute the column offset by ANDing the map's X position with 3
C $A8DE,3 If column offset is zero - use the previous supertile CHECK
C $A8E1,3 Get the map's X coordinate
C $A8E4,1 Decrement it
C $A8E5,2 Jump to plot_vertical_tiles_common
;
c $A8E7 Plot the complete leftmost column of tiles.
D $A8E7 Used by the routines at #R$AA05 and #R$AA26.
@ $A8E7 label=plot_leftmost_tiles
C $A8E7,3 Point #REGde at the 24x17 visible tiles array ("tile_buf") leftmost column
C $A8EA,1 Bank
C $A8EB,3 Point #REGhl' at the 7x5 supertile indices buffer ("map_buf") leftmost supertile
C $A8EE,3 Point #REGde' at the 24x17x8 screen buffer ("window_buf") leftmost column
C $A8F1,3 Get the map's X coordinate
E $A8E7 FALL THROUGH into plot_vertical_tiles_common
;
c $A8F4 Plots a single vertical row of tiles to the screen buffer.
D $A8F4 Simultaneously updates the visible tiles buffer.
D $A8F4 Used by the routines at #R$A8A2 and #R$A8CF.
R $A8F4 I:A Map X position
R $A8F4 I:DE Pointer into the 24x17 visible tiles array ("tile_buf")
R $A8F4 I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
R $A8F4 I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
@ $A8F4 label=plot_vertical_tiles_common
C $A8F4,2 Compute the column offset within a supertile from the map's X position (0, 1, 2 or 3)
C $A8F6,3 Self modify the "LD A,$xx" instruction at $A94C to load the column offset
C $A8F9,1 Preserve the column offset in #REGc for the next step
C $A8FA,7 Compute the row offset within a supertile from the map's Y position (0, 4, 8 or 12)
C $A901,1 Now add it to the column offset - giving the combined offset
C $A902,1 Bank the combined offset
N $A903 Initial edge. This draws up to 4 tiles.
C $A903,1 Fetch a supertile index from map_buf
C $A904,1 Switch register banks for the initial edge
C $A905,11 Point #REGhl at super_tiles[A]
C $A910,1 Unbank the combined offset
C $A911,2 Add on the combined offset to #REGhl to point us at the appropriate part of the supertile
C $A913,12 Turn 0,4,8,12 into 4,3,2,1 - the number of initial loop iterations
C $A91F,1 Transpose tile_buf and map_buf pointers
C $A920,3 Set visible tiles stride
N $A923 Start loop
C $A923,1 Save the loop counter
C $A924,1 Fetch a tile index from the super tile pointer
C $A925,1 Store it in the visible tiles (#REGde' on entry)
C $A926,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl' then advance #REGde' by a row
C $A929,4 Advance the tile pointer by a supertile row (4)
C $A92D,1 Advance the visible tiles pointer by a row (24)
C $A92E,1 Restore the loop counter
C $A92F,4 ...loop
C $A933,1 Transpose the tile_buf and map_buf pointers back
C $A934,1 Unbank
C $A935,7 Advance the map buffer pointer by a row (7)
N $A93C Middle loop.
C $A93C,2 There are always three iterations (three supertiles in the middle section).
N $A93E Start loop (outer) -- advanced for each supertile
C $A93E,1 Preserve the loop counter
C $A93F,1 Fetch a supertile index from the map buffer pointer
C $A940,1 Switch register banks during the middle loop
C $A941,11 Point #REGhl at super_tiles[A]
@ $A94C label=supertile_plot_vertical_common_iters
C $A94C,2 Load the column offset - self modified by $A8F6
C $A94E,2 Add on the column offset to #REGhl
C $A950,3 Set visible tiles stride
C $A953,1 Transpose the tile_buf and map_buf pointers
C $A954,2 Supertiles are four tiles high
N $A956 Start loop (inner) -- advanced for each tile
C $A956,1 Preserve the loop counter
C $A957,1 Fetch a tile index from the super tile pointer
C $A958,1 Store it in visible tiles
C $A959,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl' then advance #REGde' by a row
C $A95C,1 Advance the visible tiles pointer by a row
C $A95D,4 Advance the tiles pointer by a row
C $A961,1 Restore the loop counter
C $A962,4 ...loop (inner)
C $A966,1 Transpose the tile_buf and map_buf pointers back
C $A967,1 Unbank
C $A968,7 Advance the map buffer pointer
C $A96F,1 Restore the loop counter
C $A970,2 ...loop (outer)
N $A972 Trailing edge.
C $A972,1 Fetch a supertile index from map_buf
C $A973,1 Switch register banks during the trailing loop
C $A974,11 Point #REGhl at super_tiles[A]
C $A97F,3 Load the column offset from (self modified) $A94D
C $A982,2 Add on the column offset to #REGhl
C $A984,6 Form the trailing loop iteration counter
C $A98A,3 Set visible tiles stride
C $A98D,1 Transpose the tile_buf and map_buf pointers
N $A98E Start loop
C $A98E,1 Preserve the loop counter
C $A98F,1 Fetch a tile index from the super tile pointer
C $A990,1 Store it in visible tiles
C $A991,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl' then advance #REGde' by a row
C $A994,4 Advance the tiles pointer by a row
C $A998,1 Advance the visible tiles pointer by a row
C $A999,1 Restore the loop counter
C $A99A,4 ...loop
C $A99E,1 Transpose the tile_buf and map_buf pointers back
C $A99F,1 Return
;
c $A9A0 Call plot_tile then advance the screen buffer pointer in #REGde' by a row.
D $A9A0 Used by the routine at #R$A8F4.
R $A9A0 I:A Tile index
R $A9A0 I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
R $A9A0 I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf")
@ $A9A0 label=plot_tile_then_advance
C $A9A0,3 Plot the tile in #REGa to the screen buffer at #REGde' using supertile pointer #REGhl'
C $A9A3,1 Bank
C $A9A4,7 Advance the screen buffer pointer #REGde' to the next row (add 24 * 8 - 1)
C $A9AB,1 Unbank
C $A9AC,1 Return
;
c $A9AD Plot an exterior tile then advance #REGde' to the next column.
D $A9AD Used by the routines at #R$A826 and #R$A9A0.
R $A9AD I:A Tile index
R $A9AD I:DE' Pointer into the 24x17x8 screen buffer ("window_buf")
R $A9AD I:HL' Pointer into the 7x5 supertile indices buffer ("map_buf") (used to select the correct tile group)
@ $A9AD label=plot_tile
C $A9AD,1 Unbank input registers
C $A9AE,1 Bank the tile index
C $A9AF,1 Fetch a supertile index from map_buf
N $A9B0 Now map the tile index and supertile index into a tile pointer: #TABLE(default) { Supertiles 44 and lower         | use tiles   0..249 (249 tile span) } { Supertiles 45..138 and 204..218 | use tiles 145..400 (255 tile span) } { Supertiles 139..203             | use tiles 365..570 (205 tile span) } TABLE#
C $A9B0,3 Point #REGbc at exterior_tiles[0]
C $A9B3,4 If supertile index <= 44 jump to plot_tile_chosen
C $A9B7,3 Point #REGbc at exterior_tiles[145]
C $A9BA,8 If supertile index <= 138 or >= 204 jump to plot_tile_chosen
C $A9C2,3 Point #REGbc at exterior_tiles[365]
@ $A9C5 label=plot_tile_chosen
C $A9C5,1 Preserve the supertile pointer
C $A9C6,1 Unbank the tile index
C $A9C7,7 Point #REGhl at #REGbc[tile index]
C $A9CE,1 Preserve the screen buffer pointer
C $A9CF,1 Transpose
C $A9D0,3 Set the screen buffer stride to 24
C $A9D3,2 Set eight iterations
N $A9D5 Start loop
@ $A9D5 label=plot_tile_loop
C $A9D5,1 Preserve the loop counter
C $A9D6,2 Copy a byte of tile
C $A9D8,1 Advance the destination pointer to the next row
C $A9D9,1 Advance the source pointer
C $A9DA,1 Restore the loop counter
C $A9DB,4 ...loop
C $A9DF,1 Restore the screen buffer pointer
C $A9E0,1 Advance the screen buffer pointer
C $A9E1,1 Restore the supertile pointer
C $A9E2,1 Re-bank input registers
C $A9E3,1 Return
;
c $A9E4 Shunt the map left.
D $A9E4 Used by the routine at #R$AAB2.
@ $A9E4 label=shunt_map_left
C $A9E4,4 Move the map position to the left
C $A9E8,3 Update the supertiles in map_buf
C $A9EB,11 Shunt the tile_buf back by one byte
@ $A9F6 nowarn
C $A9F6,11 Shunt the window_buf back by one byte
C $AA01,3 Plot the complete rightmost column of tiles
C $AA04,1 Return
;
c $AA05 Shunt the map right.
D $AA05 Used by the routine at #R$AAB2.
@ $AA05 label=shunt_map_right
C $AA05,4 Move the map position to the right
C $AA09,3 Update the supertiles in map_buf
@ $AA0C nowarn
C $AA0C,11 Shunt the tile_buf forward by one byte
N $AA17 Bug: The length in the following is one byte too long.
C $AA17,11 Shunt the window_buf forward by one byte
C $AA22,3 Plot the complete leftmost column of tiles
C $AA25,1 Return
;
c $AA26 Shunt the map up-right.
D $AA26 Used by the routine at #R$AAB2.
R $AA26 I:HL Contents of #R$81BB map position
@ $AA26 label=shunt_map_up_right
C $AA26,5 Move the map position up (#REGh) and to the right (#REGl)
C $AA2B,3 Update the supertiles in map_buf
C $AA2E,11 Shunt the tile_buf up and to the right
@ $AA39 nowarn
@ $AA3C nowarn
C $AA39,11 Shunt the window_buf up and to the right
C $AA44,3 Plot the complete bottommost row of tiles
C $AA47,3 Plot the complete leftmost column of tiles
C $AA4A,1 Return
;
c $AA4B Shunt the map up.
D $AA4B Used by the routine at #R$AAB2.
@ $AA4B label=shunt_map_up
C $AA4B,4 Move the map position up
C $AA4F,3 Update the supertiles in map_buf
C $AA52,11 Shunt the tile_buf up
@ $AA5D nowarn
C $AA5D,11 Shunt the window_buf up
C $AA68,3 Plot the complete bottommost row of tiles
C $AA6B,1 Return
;
c $AA6C Shunt the map down.
D $AA6C Used by the routine at #R$AAB2.
@ $AA6C label=shunt_map_down
C $AA6C,4 Move the map position down
C $AA70,3 Update the supertiles in map_buf
@ $AA73 nowarn
C $AA73,11 Shunt the tile_buf down
C $AA7E,11 Shunt the window_buf down
C $AA89,3 Plot the complete topmost row of tiles
C $AA8C,1 Return
;
c $AA8D Shunt the map down left.
D $AA8D Used by the routine at #R$AAB2.
@ $AA8D label=shunt_map_down_left
C $AA8D,5 Shunt the map position down (#REGh) and to the left (#REGl)
C $AA92,3 Update the supertiles in map_buf
@ $AA95 nowarn
@ $AA98 nowarn
C $AA95,11 Shunt the tile_buf down
C $AAA0,11 Shunt the window_buf down
C $AAAB,3 Plot the complete topmost row of tiles
C $AAAE,3 Plot the complete rightmost column of tiles
C $AAB1,1 Return
;
c $AAB2 Move the map when the hero walks around outdoors.
D $AAB2 The map is shunted around in the opposite direction to the apparent character motion.
D $AAB2 Used by the routines at #R$6939 and #R$9D7B.
@ $AAB2 label=move_map
C $AAB2,5 Ignore any attempt to move the map when we're indoors
C $AAB7,5 Is the hero's vischar_BYTE7_DONT_MOVE_MAP flag set? (See #R$AF93)
C $AABC,1 Return if so
C $AABD,3 Point #REGhl at the hero's animation pointer field
C $AAC0,4 Fetch the animation pointer into #REGde
C $AAC4,1 Load the current animation index
C $AAC5,3 Step forward through the animation structure to the map direction field
C $AAC8,1 Read the animation's map direction field
C $AAC9,2 A map direction of 255 means "don't move"
C $AACB,1 Return if 255
C $AACC,6 If animation index's vischar_ANIMINDEX_REVERSE bit is set then exchange the up and down directions
C $AAD2,1 Preserve map direction
@ $AAD7 nowarn
C $AAD3,8 Point #REGhl at move_map_jump_table[A]
C $AADB,4 Load jump address into #REGhl
C $AADF,1 Restore map direction
C $AAE0,1 Stack the jump table target - our final RET will call it
C $AAE1,1 Preserve map direction
N $AAE2 Calculate the position at which we should stop scrolling the map
N $AAE2 For example in the animation anim_walk_tl (where 'tl' denotes a character walking towards the top left) we're asked to scroll the map to the bottom and right. If the map scrolls further than 192 across we'll render off the side of the map, so we clamp the scroll at that point. Similar for vertical.
N $AAE2 #TABLE(default) { =h Direction | =h Clamps at (x,y) } { direction_TOP_LEFT | (192,124) aka bottom right of the map } { direction_TOP_RIGHT | (0,124) aka bottom left of the map } { direction_BOTTOM_RIGHT | (0,0) aka top left of the map } { direction_BOTTOM_LEFT | (192,0) aka top right of th map } TABLE#
@ $AAE2 keep
C $AAE2,3 Set the initial clamp position (x,y) to (#REGc = 0,#REGb = 124)
C $AAE5,6 If the map scroll direction is direction_BOTTOM_* (scrolling up) then the y limit becomes 0
C $AAEB,10 If the map scroll direction is direction_*_LEFT (scrolling right) then the x limit becomes 192
C $AAF5,3 Read the current map position into #REGhl
C $AAF8,4 If current map X equals limit X then return
C $AAFC,1 Restore map direction
C $AAFD,1 Restore jump table target
C $AAFE,1 Return
C $AAFF,4 If current map Y equals limit Y then return
C $AB03,1 Restore map direction
N $AB04 Now we form a counter that's used by the move_map functions to decide in which order the map shunt operations will be issued. Instead of immediately shunting the map in the named direction, they use this counter to work through a pattern of moves.
C $AB04,3 Point #REGhl at move_map_y
C $AB07,2 Is the map direction direction_BOTTOM_*?
C $AB09,2 Jump if so
C $AB0B,4 Cycle the counter forwards for TOP cases
C $AB0F,2 Cycle the counter backwards for BOTTOM cases
C $AB11,2 Clamp to 0..3
C $AB13,1 Save it back to move_map_y
C $AB14,1 Transpose (for passing into move_map_*)
N $AB15 Now choose the game window offset that will be used by plot_game_window. A 255 in the high byte means to plot the screen offset (which direction?) by half a byte. The low byte is a byte offset added to the source data.
C $AB15,3 Clear the game window offset (GWO)
C $AB18,3 If move_map_y is 0 GWO becomes (0, 0)
C $AB1B,6 If move_map_y is 2 GWO becomes (4 * 24, 0)
C $AB21,7 If move_map_y is 1 GWO becomes (2 * 24, 255)
C $AB28,2 Otherwise GWO becomes (6 * 24, 255)
C $AB2A,3 Write it to game_window_offset
C $AB2D,3 Point #REGhl at map_position
C $AB30,1 NOT a return - pops and calls the move_map_* routine pushed at #R$AAE0 which then returns
@ $AB31 label=move_map_jump_table
W $AB31,2,2 move_map_up_left
W $AB33,2,2 move_map_up_right
W $AB35,2,2 move_map_down_right
W $AB37,2,2 move_map_down_left
N $AB39 Called when player moves down-right (map is shifted up or left). This moves the map in the pattern up/left/none/left.
@ $AB39 label=move_map_up_left
C $AB39,1 Fetch move_map_y
C $AB3A,4 If move_map_y is 0 then jump to shunt_map_up
C $AB3E,3 If move_map_y is 2 then return
C $AB41,3 Otherwise move_map_y is 1 or 3 - jump to shunt_map_left
N $AB44 Called when player moves down-left (map is shifted up or right). This moves the map in the pattern up-right/none/right/none.
@ $AB44 label=move_map_up_right
C $AB44,1 Fetch move_map_y
C $AB45,4 If move_map_y is 0 then jump to shunt_map_up_right
C $AB49,3 If move_map_y is 1 or 3 then return
C $AB4C,3 Otherwise move_map_y is 2 - jump to shunt_map_right
N $AB4F Called when player moves up-left (map is shifted down or right). This moves the map in the pattern right/none/right/down.
@ $AB4F label=move_map_down_right
C $AB4F,1 Fetch move_map_y
C $AB50,5 If move_map_y is 3 then jump to shunt_map_down
C $AB55,4 If move_map_y is 0 or 2 then jump to shunt_map_right
C $AB59,1 Otherwise move_map_y is 1 - return
N $AB5A Called when player moves up-right (map is shifted down or left). This moves the map in the pattern none/left/down/left.
@ $AB5A label=move_map_down_left
C $AB5A,1 Fetch move_map_y
C $AB5B,5 If move_map_y is 1 then jump to shunt_map_left
C $AB60,5 If move_map_y is 3 then jump to shunt_map_down_left
C $AB65,1 Otherwise move_map_y is 0 or 2 - return
;
g $AB66 Zoombox parameters.
@ $AB66 label=zoombox_x
B $AB66,1,1 X coordinate of left zoombox fill, in game window area
@ $AB67 label=zoombox_width
B $AB67,1,1 Maximum width (ish) of zoombox
@ $AB68 label=zoombox_y
B $AB68,1,1 Y coordinate of top zoombox fill, in game window area
@ $AB69 label=zoombox_height
B $AB69,1,1 Maximum height (ish) of zoombox
;
g $AB6A Game window current attribute byte.
@ $AB6A label=game_window_attribute
B $AB6A,1,1 Assigned by #R$AB85. Used by #R$AD21 to set the attribute of a zoombox border tile
;
c $AB6B Choose game window attributes.
D $AB6B This uses the current room index and the night-time flag to decide which screen attributes should be used for the game window. Additionally, when in non-illuminated tunnel rooms it will wipe the visible tiles to obscure the tunnel's route.
D $AB6B Used by the routines at #R$7B36, #R$7B8B, #R$A1D3, #R$ABA0, #R$B3F6 and #R$B83B.
R $AB6B O:A Chosen attribute.
@ $AB6B label=choose_game_window_attributes
C $AB6B,7 If the global current room index is room_28_HUT1LEFT or below...
N $AB72 The hero is outside, or in a room, but not in a tunnel.
C $AB72,3 Read the night-time flag
C $AB75,2 Default attribute is attribute_WHITE_OVER_BLACK
C $AB77,1 Is it night-time?
C $AB78,2 Jump if not
N $AB7A Consider night-time colours.
C $AB7A,3 Read the global current room index
C $AB7D,2 For outside at night we use attribute_BRIGHT_BLUE_OVER_BLACK
C $AB7F,1 Are we outside?
C $AB80,2 Jump if so
C $AB82,2 Otherwise for inside at night we use attribute_CYAN_OVER_BLACK
@ $AB84 label=set_attribute_from_C
C $AB84,1 Copy
@ $AB85 label=set_attribute_from_A
C $AB85,3 Assign game_window_attribute
C $AB88,1 Return
N $AB89 The hero is in a tunnel.
@ $AB89 label=choose_attribute_tunnel
C $AB89,2 For an illuminated tunnel we use attribute_RED_OVER_BLACK
C $AB8B,3 Load #REGhl with items_held
N $AB8E If the hero holds a torch - illuminate the room.
C $AB8E,2 Load item_TORCH into #REGa
C $AB90,1 Item is torch?
C $AB91,2 Jump if so
C $AB93,1 Item is torch?
C $AB94,2 Jump if so
N $AB96 The hero holds no torch - wipe the tiles so that nothing gets drawn.
C $AB96,3 Wipe the visible tiles array
C $AB99,3 Render visible tiles array into the screen buffer
C $AB9C,2 For a dark tunnel we use attribute_BLUE_OVER_BLACK
C $AB9E,2 Jump to set_attribute_from_A
;
c $ABA0 Zoombox.
D $ABA0 Animate the window buffer onto the screen via a zooming box effect.
D $ABA0 Used by the routines at #R$68F4, #R$A50B and #R$B2FC.
@ $ABA0 label=zoombox
C $ABA0,5 Initialise zoombox_x to 12
@ $ABA7 nowarn
C $ABA5,5 Initialise zoombox_y to 8
C $ABAA,3 Choose the game window attributes (the chosen attribute is returned in #REGa)
C $ABAD,2 Duplicate attribute into both bytes of #REGhl
C $ABAF,6 Set the attributes of the initial zoombox fill rectangle
C $ABB5,7 Set zoombox_width and zoombox_height to zero
N $ABBC Start loop
N $ABBC Shrink X and grow width until X is 1
C $ABBC,3 Point #REGhl at zoombox_x
C $ABBF,1 Fetch it
C $ABC0,2 Is it 1?
C $ABC2,3 Skip the next chunk if so
C $ABC5,1 Decrement zoombox_x
C $ABC6,1 And the register copy too
C $ABC7,1 Point #REGhl at zoombox_width
C $ABC8,1 Increment zoombox_width
C $ABC9,1 Step back
N $ABCA Grow width until it's 22
C $ABCA,1 Point #REGhl at zoombox_width
C $ABCB,1 Add width to x
C $ABCC,2 Did we hit 22?
C $ABCE,3 Jump if not
C $ABD1,1 Increment zoombox_width
N $ABD2 Shrink Y and grow height until Y is 1
C $ABD2,1 Point #REGhl at zoombox_y
C $ABD3,1 Fetch it
C $ABD4,2 Is it 1?
C $ABD6,3 Skip the next chunk if so
C $ABD9,1 Decrement zoombox_y
C $ABDA,1 And the register copy too
C $ABDB,1 Point #REGhl at zoombox_height
C $ABDC,1 Increment zoombox_height
C $ABDD,1 Step back
N $ABDE Grow height until it's 15
C $ABDE,1 Point #REGhl at zoombox_height
C $ABDF,1 Add height to y
C $ABE0,2 Did we hit 15?
C $ABE2,3 Jump if not
C $ABE5,1 Increment zoombox_height
C $ABE6,3 Draw the zoombox contents
C $ABE9,3 Draw the zoombox border
C $ABEC,7 Sum the width and height
C $ABF3,5 If it's less than 35 then ...loop
C $ABF8,1 Return
;
c $ABF9 Draw the zoombox contents.
D $ABF9 Used by the routine at #R$ABA0.
@ $ABF9 label=zoombox_fill
C $ABF9,3 Fetch zoombox_y
C $ABFC,7 Multiply it by 128 and store it in #REGde
C $AC03,4 Multiply it by 64 and store it in #REGhl
C $AC07,1 Sum the two, producing zoombox_y * 192
C $AC08,3 Fetch zoombox_x
C $AC0B,5 Add zoombox_x to zoombox_y * 192 producing the window buffer source offset
@ $AC10 nowarn
C $AC10,3 Point #REGde at window buffer + 1 (TODO: Explain the +1)
C $AC13,1 Form the final source pointer
C $AC14,1 Free up #REGhl for the next chunk
@ $AC15 nowarn
C $AC15,3 Fetch zoombox_y again
C $AC18,4 Multiply it by 16 producing an offset into the game_window_start_addresses array
C $AC1C,3 Point #REGhl at the game_window_start_addresses array
C $AC1F,5 Combine it with the offset
C $AC24,4 Fetch the game window start address
C $AC28,3 Fetch zoombox_x again
C $AC2B,2 Combine with game window start address
C $AC2D,1 Get the source pointer back in #REGhl
C $AC2E,3 Fetch zoombox_width
C $AC31,3 Self modify the 'SUB $00' at #R$AC54
C $AC34,4 Compute source skip (24 - width)
C $AC38,3 Self modify the 'LD A,$00' at #R$AC4C
C $AC3B,3 Fetch zoombox_height (number of rows to copy)
C $AC3E,1 Set outer iterations
N $AC3F Start loop (outer) -- once for every row
C $AC3F,1 Preserve iteration counter
C $AC40,1 Preserve destination pointer
C $AC41,2 8 iterations / 1 row
N $AC43 Start loop (inner) -- once for every line
C $AC43,1 Bank the counter
C $AC44,6 Fetch zoombox_width into #REGbc
C $AC4A,2 Copy zoombox_width bytes from #REGhl to #REGde, then advance those pointers
C $AC4C,2 Load the (self modified) source skip
C $AC4E,5 Advance the source pointer by source skip bytes
C $AC53,4 Subtract the (self modified) zoombox_width from the destination pointer to undo LDIR's post-increment
C $AC57,1 Move to the next scanline by incrementing high byte
C $AC58,1 Unbank the inner loop counter
C $AC59,4 ...loop (inner)
C $AC5D,1 Restore the destination pointer
C $AC5E,1 Exchange
C $AC5F,3 Set the row-to-row delta to 32
C $AC62,1 Isolate
C $AC63,2 Is #REGa < 224? This sets the C flag if we're NOT at the end of the current third of the screen
C $AC65,2 Jump over if so
C $AC67,2 Otherwise set the stride to $0720 so we will step forward to the next third of the screen. In this case #REGhl is of the binary form 010ttyyy111xxxxx. Adding $0720 - binary 0000011100100000 - will result in 010TTyyy000xxxxx where the 't' bits are incremented, moving the pointer forward to the next screen third
C $AC69,1 Step
C $AC6A,1 Exchange back
C $AC6B,1 Pop the outer loop counter
C $AC6C,2 ...loop (outer)
C $AC6E,1 Return
;
c $AC6F Draw the zoombox border.
D $AC6F Used by the routine at #R$ABA0.
@ $AC6F label=zoombox_draw_border
@ $AC6F nowarn
C $AC6F,3 Fetch zoombox_y
C $AC72,1 Subtract one so that we draw around the zoombox fill area
C $AC73,4 Multiply it by 16 producing an offset into the game_window_start_addresses array
C $AC77,3 Point #REGhl at the game_window_start_addresses array
C $AC7A,5 Combine it with the offset
C $AC7F,4 Fetch the game window start address
N $AC83 Top left corner tile.
C $AC83,3 Fetch zoombox_x
C $AC86,1 Subtract one so that we draw around the zoombox fill area
C $AC87,2 Combine with game window start address
C $AC89,5 Draw a top-left zoombox border tile
C $AC8E,1 Move the destination pointer forward
N $AC8F Top horizontal run, moving right.
C $AC8F,3 Fetch zoombox_width
C $AC92,1 Set iterations
N $AC93 Start loop
C $AC93,5 Draw a horizontal zoombox border tile
C $AC98,1 Move the destination pointer forward
C $AC99,2 ...loop
N $AC9B Top right corner tile.
C $AC9B,5 Draw a top-right zoombox border tile
C $ACA0,11 See similar code at #R$AC5F onwards
N $ACAB Right hand vertical run, moving down.
C $ACAB,3 Fetch zoombox_height
C $ACAE,1 Set iterations
N $ACAF Start loop
C $ACAF,5 Draw a vertical zoombox border tile
C $ACB4,11 See similar code at #R$AC5F onwards
C $ACBF,2 ...loop
N $ACC1 Bottom right corner tile.
C $ACC1,5 Draw a bottom-right zoombox border tile
C $ACC6,1 Move the destination pointer backwards
N $ACC7 Bottom horizontal run, moving left.
C $ACC7,3 Fetch zoombox_width
C $ACCA,1 Set iterations
N $ACCB Start loop
C $ACCB,5 Draw a horizontal zoombox border tile
C $ACD0,1 Move the destination pointer backwards
C $ACD1,2 ...loop
N $ACD3 Bottom left corner tile.
C $ACD3,5 Draw a bottom-left zoombox border tile
C $ACD8,12 Inversion of similar code at #R$AC5F onwards
N $ACE4 Left hand vertical run, moving up.
C $ACE4,3 Fetch zoombox_height
C $ACE7,1 Set iterations
N $ACE8 Start loop
C $ACE8,5 Draw a vertical zoombox border tile
C $ACED,12 Inversion of similar code at #R$AC5F onwards
C $ACF9,2 ...loop
C $ACFB,1 Return
;
c $ACFC Draw a single zoombox border tile.
D $ACFC Used by the routine at #R$AC6F.
R $ACFC I:A Index of tile to draw.
R $ACFC I:BC (preserved)
R $ACFC I:HL Destination address.
@ $ACFC label=zoombox_draw_tile
C $ACFC,1 Preserve
C $ACFD,1 Preserve
C $ACFE,1 Preserve
C $ACFF,1 Move destination address into #REGde
C $AD00,3 Widen the tile index from #REGa into #REGhl
C $AD03,3 Then multiply the tile index by eight
C $AD06,3 Point #REGbc at zoombox_tiles
C $AD09,1 Combine to form a pointer to the required tile in #REGhl
C $AD0A,2 8 iterations / 8 rows
N $AD0C Start loop
C $AD0C,2 Copy a byte
C $AD0E,1 Next destination byte is 8 * 32 (=256) bytes ahead
C $AD0F,1 Next source byte is adjacent
C $AD10,2 ...loop
C $AD12,2 Shunt #REGd into #REGa and undo the earlier INC D
C $AD14,3 Point #REGhl at the attributes bank
C $AD17,2 Was the tile on the middle or later third of the screen?
C $AD19,2 If not, jump to writing the attribute
C $AD1B,1 If so, increment the attribute bank pointer
C $AD1C,2 Was the tile on to the final third of the screen?
C $AD1E,2 If not, jump to writing the attribute
C $AD20,1 If so, increment the attribute bank pointer
C $AD21,3 Read our current game_window_attribute
C $AD24,1 Write it to the attribute byte
C $AD25,1 Restore
C $AD26,1 Restore
C $AD27,1 Restore
C $AD28,1 Return
;
w $AD29 Searchlight movement data.
@ $AD29 label=searchlight_movements
B $AD29,5,5 x, y, counter, direction, index
W $AD2E,2,2 pointer to movement data
B $AD30,5,5 x, y, counter, direction, index
W $AD35,2,2 pointer to movement data
B $AD37,5,5 x, y, counter, direction, index
W $AD3C,2,2 pointer to movement data
N $AD3E Searchlight movement pattern for ?
@ $AD3E label=searchlight_path_0
B $AD3E,2,2 (32, bottom right)
B $AD40,2,2 (32, top right)
B $AD42,1,1 terminator
N $AD43 Searchlight movement pattern for main compound.
@ $AD43 label=searchlight_path_1
B $AD43,2,2 (24, top right)
B $AD45,2,2 (12, top left)
B $AD47,2,2 (24, bottom left)
B $AD49,2,2 (12, top left)
B $AD4B,2,2 (32, top right)
B $AD4D,2,2 (20, top left)
B $AD4F,2,2 (32, bottom left)
B $AD51,2,2 (44, bottom right)
B $AD53,1,1 terminator
N $AD54 Searchlight movement pattern for ?
@ $AD54 label=searchlight_path_2
B $AD54,2,2 (44, bottom right)
B $AD56,2,2 (42, top right)
B $AD58,1,1 terminator
;
c $AD59 Decides searchlight movement.
D $AD59 Used by the routine at #R$ADBD.
R $AD59 I:HL Pointer to a searchlight movement data.
@ $AD59 label=searchlight_movement
C $AD59,1 Fetch movement.x
C $AD5A,1 Step over
C $AD5B,1 Fetch movement.y
C $AD5C,1 Step over
C $AD5D,1 Decrement movement.counter
C $AD5E,3 Jump if it's non-zero
N $AD61 End of previous sweep: work out the next.
C $AD61,2 Advance to movement.index
C $AD63,1 Fetch movement.index
C $AD64,2 Is the reverse direction flag set?
C $AD66,3 Jump if not
C $AD69,2 Clear the reverse direction flag
C $AD6B,3 Jump if non-zero index
N $AD6E Index is zero.
C $AD6E,2 Clear direction bit when index hits zero
C $AD70,2 (else)
N $AD72 Index is non-zero.
C $AD72,1 Decrement movement.index
C $AD73,1 Decrement local copy too (sans direction bit)
C $AD74,2 (else)
N $AD76 Not reverse direction.
C $AD76,1 Count up
C $AD77,1 Assign to movement.index
C $AD78,1 Advance to movement.pointer
C $AD79,3 Load pointer
C $AD7C,2 Backtrack to movement.index
C $AD7E,6 Index in #REGa doubled and added to pointer
C $AD84,1 Fetch movement byte
C $AD85,5 End of list?
C $AD8A,1 !overshot? count down counter byte
C $AD8B,2 !go negative
C $AD8D,2 Pointer -= 2
C $AD8F,1 Bug: #REGa is loaded but never used again
C $AD90,2 #REGhl -= 2
N $AD92 Copy counter + direction_t.
C $AD92,4 Copy counter
C $AD96,2 Copy direction
C $AD98,1 Return
C $AD99,1 Advance to direction
C $AD9A,2 Fetch direction
C $AD9C,2 !Test sign
C $AD9E,2 Jump if clear
C $ADA0,2 Toggle direction
C $ADA2,7 If direction <= direction_TOP_RIGHT, y-- else y++
C $ADA9,13 If direction is RIGHT, x+=2 else x-=2
C $ADB6,3 Backtrack to (x,y)
C $ADB9,2 Store y
C $ADBB,1 Store x
C $ADBC,1 Return
;
c $ADBD Turns white screen elements light blue and tracks the hero with a searchlight.
D $ADBD Used by the routine at #R$9D7B.
@ $ADBD label=nighttime
C $ADBD,3 Point #REGhl at searchlight_state
C $ADC0,1 Fetch the state
C $ADC1,2 Is it in searchlight_STATE_SEARCHING state? ($FF)
C $ADC3,3 If so, jump to searching
C $ADC6,3 Fetch the global current room index
C $ADC9,1 Are we outdoors?
C $ADCA,2 If so, jump to searchlight movement code
N $ADCC If the hero goes indoors then the searchlight loses track.
C $ADCC,2 Set the searchlight state to searchlight_STATE_SEARCHING
C $ADCE,1 Return
N $ADCF The hero is outdoors.
N $ADCF If the searchlight previously caught the hero, then track him.
C $ADCF,1 Fetch the searchlight state again - it's a counter
C $ADD0,2 Does it equal searchlight_STATE_CAUGHT? ($1F)
C $ADD2,3 If not, jump to single searchlight code. This will draw the searchlight in the place where the hero was last seen
N $ADD5 Caught in searchlight.
C $ADD5,3 Fetch map_position into #REGhl
C $ADD8,4 Compute map_x as map_position.x + 4
C $ADDC,1 map_y is just map_position.y
C $ADDD,3 Fetch the searchlight_caught_coord x/y into #REGhl
C $ADE0,2 Does caught_x equal map_x?
C $ADE2,2 Jump if not
C $ADE4,2 Does caught_y equal map_y?
C $ADE6,1 If both are equal the highlight doesn't need to move so return
C $ADE7,2 (else)
N $ADE9 Move searchlight left/right to focus on the hero.
C $ADE9,3 Jump to decrement case if caught_x exceeds map_x
C $ADEC,1 Increment caught_x
C $ADED,2 (else)
C $ADEF,1 Decrement caught_x
C $ADF0,1 Save to #REGhl
N $ADF1 Move searchlight up/down to focus on the hero.
C $ADF1,2 Does caught_y equal map_y? (Note: This looks like a duplicated check but isn't - the equivalent above doesn't always execute)
C $ADF3,2 Skip movement code if so
C $ADF5,3 Jump to decrement case if caught_y exceeds map_y
C $ADF8,1 Increment caught_y
C $ADF9,2 (else)
C $ADFB,1 Decrement caught_y
C $ADFC,1 Save to #REGhl
C $ADFD,3 Save #REGhl back to searchlight_caught_coord
N $AE00 When tracking the hero a single searchlight is used.
C $AE00,4 Fetch map_position into #REGhl
C $AE04,3 Point #REGhl at searchlight_caught_coord plus a byte to compensate for the 'DEC HL' at the jump target
C $AE07,2 1 iteration / 1 searchlight
C $AE09,1 Preserve loop counter
C $AE0A,1 Preserve searchlight movement pointer
C $AE0B,2 Jump
N $AE0D When not tracking the hero all three searchlights are cycled through.
@ $AE0D label=searching
C $AE0D,3 Point #REGhl at searchlight_movements[0]
C $AE10,2 3 iterations / 3 searchlights
N $AE12 Start loop
C $AE12,1 Preserve loop counter
C $AE13,1 Preserve searchlight movement pointer
C $AE14,3 Decide searchlight movement
C $AE17,2 Restore searchlight movement pointer
C $AE19,3 Is the hero caught in the searchlight?
C $AE1C,2 Restore searchlight movement pointer
C $AE1E,4 Point #REGde at map_position
C $AE22,7 If map_x + 23 < searchlight.x (off right hand side) goto next
C $AE29,7 If searchlight.x + 16 < map_x (off left hand side) goto next
C $AE30,1 Point #REGhl at searchlight.y
C $AE31,7 If map_y + 16 < searchlight.y (off top side) goto next
C $AE38,7 If searchlight.y + 16 < map_y (off bottom side) goto next
C $AE3F,1 Set the clip flag to zero
C $AE40,1 Bank the clip flag
C $AE41,1 Point #REGhl at searchlight.x (or caught_coord.x depending on how it was entered)
N $AE42 Calculate the column
C $AE42,2 Clear top part of 'column' skip
C $AE44,2 Calculate the left side skip = searchlight.x - map_x
C $AE46,3 Jump if left hand skip is +ve
C $AE49,2 Invert the top part of 'column'
C $AE4B,3 Bitwise complement the banked clip flag
C $AE4E,1 Finalise #REGbc as column
N $AE4F Calculate the row
C $AE4F,1 Point #REGhl at searchlight.y
C $AE50,1 Fetch searchlight.y
C $AE51,2 Clear top part of 'row' skip
C $AE53,1 Calculate the top side skip = searchlight.y - map_y
C $AE54,3 Jump if top side skip is +ve
C $AE57,2 Invert the top part of 'row'
C $AE59,1 Finalise #REGhl as row
N $AE5A #REGhl is row, #REGbc is column
C $AE5A,5 Multiply row by 32
C $AE5F,1 Add column to it
C $AE60,3 Point #REGhl at the address of the top-left game window attribute
C $AE63,1 Add row+column to base, producing our plot pointer
C $AE64,1 Move it to #REGde
C $AE65,1 Unbank the clip flag
C $AE66,3 Assign it to searchlight_clip_left
C $AE69,3 Plot the searchlight
@ $AE6C label=next_searchlight
C $AE6C,1 Restore searchlight_movement pointer
C $AE6D,1 Restore loop counter
C $AE6E,4 Step to the next searchlight_movement
C $AE72,2 ...loop
C $AE74,1 Return
;
g $AE75 Searchlight state variables
D $AE75 (Assigned by nighttime. Read by searchlight_plot.)
@ $AE75 label=searchlight_clip_left
B $AE75,1,1
N $AE76 Coordinates of searchlight when hero is caught.
@ $AE76 label=searchlight_caught_coord
W $AE76,2,2
;
c $AE78 Is the hero is caught in the searchlight?
D $AE78 Used by the routine at #R$ADBD.
R $AE78 I:HL Pointer to searchlight movement data.
@ $AE78 label=searchlight_caught
C $AE78,4 Fetch map_position into #REGde. #REGe is x, #REGd is y
N $AE7C Detect when the searchlight overlaps the hero.
C $AE7C,3 Compute map_position.x + 12
C $AE7F,1 Save it in #REGb
C $AE80,1 Fetch searchlight.x
C $AE81,2 Compute searchlight.x + 5
C $AE83,1 Is (searchlight.x + 5) >= (map_position.x + 12)?
N $AE84 Is the searchlight hotspot left edge beyond the hero's right edge?
C $AE84,1 Return if so - the hero isn't in the hotspot
C $AE85,2 Compute (searchlight.x + 5) + 5
C $AE87,2 Compute (map_position.x + 12) - 2
C $AE89,1 Is (searchlight.x + 10) < (map_position.x + 10)?
N $AE8A Is the searchlight hotspot right edge beyond the hero's left edge?
C $AE8A,1 Return if so - the hero isn't in the hotspot
C $AE8B,1 Advance #REGhl to searchlight.y
C $AE8C,3 Compute map_position.y + 10
C $AE8F,1 Save it in #REGb
C $AE90,1 Fetch searchlight.y
C $AE91,2 Compute searchlight.y + 5
C $AE93,1 Is (searchlight.y + 5) >= (map_position.y + 10)?
N $AE94 Is the searchlight hotspot top edge beyond the hero's bottom edge?
C $AE94,1 Return if so - the hero isn't in the hotspot
C $AE95,2 Compute (searchlight.y + 5) + 7
C $AE97,1 Save it in #REGc
C $AE98,3 Compute (map_position.y + 10) - 4
C $AE9B,1 Is (map_position.y + 6) >= (searchlight.y + 12)?
N $AE9C Is the searchlight hotspot bottom edge beyond the hero's top edge?
C $AE9C,1 Return if so - the hero isn't in the hotspot
N $AE9D The hero is in the hotspot.
N $AE9D Commentary: It seems odd to not do this next test first, since it's cheaper.
C $AE9D,5 Is searchlight_state set to searchlight_STATE_CAUGHT? ($1F)
C $AEA2,1 Return if so
C $AEA3,5 Set searchlight_state to searchlight_STATE_CAUGHT
C $AEA8,7 Assign searchlight_caught_coord from searchlight.x and .y
C $AEAF,4 Make the bell ring perpetually
C $AEB3,2 Decrease morale by 10
C $AEB5,3 Exit via decrease_morale
;
c $AEB8 Plot the searchlight.
D $AEB8 Note: In terms of attributes the game window is at (7,2)-(29,17) inclusive.
D $AEB8 Used by the routine at #R$ADBD.
R $AEB8 I:DE Pointer to screen attributes.
@ $AEB8 label=searchlight_plot
C $AEB8,1 Bank the screen attribute pointer supplied in #REGde
@ $AEB9 nowarn
C $AEB9,3 Point #REGde at the searchlight bitmap searchlight_shape[0]
C $AEBC,2 16 iterations - one per row of searchlight bitmap
N $AEBE Start loop (outer)
C $AEBE,1 Switch register banks for this iteration
N $AEBF Note: I'm presently unable to discern the intent of the 'clip' flag.
C $AEBF,3 Fetch the clip flag
N $AEC2 Stop if we're beyond the maximum Y
@ $AEC2 nowarn
C $AEC2,3 Point #REGhl at the screen attribute (0,18). This is max_y_attrs: the bottom of the game window
C $AEC5,1 Is the clip flag zero?
C $AEC6,3 Jump forward if so
C $AEC9,3 Extract the X position from the screen attribute pointer
C $AECC,2 Is it < 22?
C $AECE,2 Jump forward if so
C $AED0,2 Otherwise point #REGhl at screen attribute (0,17)
C $AED2,2 Is the screen attribute pointer >= max_y_attrs?
C $AED4,1 Return if so
C $AED5,1 Preserve the screen attribute pointer
N $AED6 Skip rows until we're in bounds
@ $AED6 nowarn
C $AED6,3 Point #REGhl at screen attribute (0,2). This is min_y_attrs: the first row that has the game window on it
C $AED9,1 Is the clip flag zero?
C $AEDA,3 Jump forward if so
C $AEDD,3 Extract the X position from the screen attribute pointer
C $AEE0,2 Is it < 7?
C $AEE2,2 Jump forward if so
C $AEE4,2 Otherwise point #REGhl at screen attribute (0,1)
C $AEE6,2 Is the screen attribute pointer >= min_y_attrs?
C $AEE8,2 Jump forward if so
C $AEEA,4 Otherwise we need to skip this row. Increment the (banked) shape pointer by a row
C $AEEE,2 Then jump to the next row, skipping all of the plotting
C $AEF0,1 Move shape pointer into #REGde
C $AEF2,2 Two iterations (two bytes per row)
N $AEF4 Start loop (inner)
C $AEF4,1 Fetch eight pixels from the shape data
C $AEF6,3 Preload #REGd with 7 (left hand clip) and #REGe with 30 (right hand clip)
C $AEF9,1 Save the shape pixels to #REGc
C $AEFA,2 Eight iterations (bits per byte)
N $AEFC Start loop (inner inner)
N $AEFC Clip right hand edge
C $AEFC,3 Fetch the clip flag
C $AEFF,1 Is the clip flag zero?
C $AF00,1 Fetch the screen attribute pointer low byte (interleaved)
C $AF01,3 Jump forward if so
C $AF04,2 Get X
C $AF06,2 Is it >= 22?
C $AF08,2 Jump to don't plot if so
C $AF0A,2 Otherwise jump to plot test
C $AF0C,2 Get X
C $AF0E,1 Is it < 30? (#REGe is 30 here, as set by #R$AEF6)
C $AF0F,2 Jump to plot test if so
N $AF12 Tight loop to increment #REGde by #REGb
C $AF12,3 Skip the remainder of the shape's row
C $AF16,2 Jump to next_row
N $AF18 Clip left hand edge
C $AF18,1 Is #REGa >= 8? (#R$AEF6 previously stored 7 in #REGd)
C $AF19,2 Jump to plot if so
@ $AF1B label=dont_plot
C $AF1B,2 Extract the next bit from shape's pixels
C $AF1D,2 Jump to the next pixel
@ $AF1F label=do_plot
C $AF1F,2 Extract the next bit from shape's pixels
C $AF21,3 Jump if the pixel is not set
C $AF24,2 Set screen attribute to attribute_YELLOW_OVER_BLACK
C $AF26,2 (else)
C $AF28,2 Set screen attribute to attribute_BRIGHT_BLUE_OVER_BLACK
C $AF2A,1 Advance to the next pixel and attribute
C $AF2B,2 ...loop (inner inner)
C $AF2E,1 Advance shape pointer
C $AF2F,2 ...loop (inner)
@ $AF32 label=next_row
C $AF33,4 Move the attribute pointer to the next scanline
C $AF39,1 Decrement row counter
C $AF3A,3 ...loop while row > 0 (outer)
C $AF3D,1 Return
N $AF3E Searchlight circle shape.
@ $AF3E label=searchlight_shape
B $AF3E,32,2
;
b $AF5E Barbed wire tiles used by the zoombox effect.
@ $AF5E label=zoombox_tiles
B $AF5E,8,8 top left tile, zoombox_tile_wire_tl #HTML[#UDG$AF5E]
B $AF66,8,8 horizontal tile, zoombox_tile_wire_hz #HTML[#UDG$AF66]
B $AF6E,8,8 top right tile, zoombox_tile_wire_tr #HTML[#UDG$AF6E]
B $AF76,8,8 vertical tile, zoombox_tile_wire_vt #HTML[#UDG$AF76]
B $AF7E,8,8 bottom right tile, zoombox_tile_wire_br #HTML[#UDG$AF7E]
B $AF86,8,8 bottom left tile, zoombox_tile_wire_bl #HTML[#UDG$AF86]
;
g $AF8E Bribed character.
@ $AF8E label=bribed_character
B $AF8E,1,1
;
c $AF8F Test for characters meeting obstacles like doors and map bounds.
D $AF8F Also assigns saved_pos to specified vischar's pos and sets the sprite_index.
D $AF8F Used by the routine at #R$B5CE.
R $AF8F I:A' Flip flag and sprite offset.
R $AF8F I:IY Pointer to visible character block.
R $AF8F O:F Z/NZ => inside/outside bounds.
@ $AF8F label=touch
C $AF8F,1 Exchange #REGa registers
C $AF90,3 Stash the flip flag and sprite offset
C $AF93,4 Set the vischar's vischar_BYTE7_DONT_MOVE_MAP flag
C $AF97,4 Set the vischar's vischar_DRAWABLE flag
C $AF9B,3 #REGhl = #REGiy
N $AF9E If the hero is player controlled then check for door transitions.
C $AF9E,2 Which vischar are we processing?
C $AFA0,1 Preserve the vischar low byte
C $AFA1,2 Jump forward if not the hero's vischar
C $AFA3,7 If the automatic player counter is positive (under player control)... call door_handling
C $AFAA,1 Restore vischar low byte
N $AFAB Check bounds if this is a non-player character or the hero is not cutting the fence.
C $AFAB,3 If it's a non-player vischar... jump foward to bounds check
C $AFAE,10 OR if it's the hero's vischar and its flags (vischar_FLAGS_PICKING_LOCK | vischar_FLAGS_CUTTING_WIRE) don't equal vischar_FLAGS_CUTTING_WIRE call bounds_check
C $AFB8,1 Return if a wall was hit
N $AFB9 Check "real" characters for collisions.
C $AFB9,3 Get this vischar's character index
C $AFBC,2 Is it >= character_26_STOVE_1?
C $AFBE,2 Jump forward if so
C $AFC0,3 Call collision
C $AFC3,1 Return if there was a collision
N $AFC4 At this point we handle non-colliding characters and items only.
C $AFC4,4 Clear vischar_BYTE7_DONT_MOVE_MAP
C $AFC8,15 Copy saved_pos to vischar's position
C $AFD7,3 Unstash the flip flag and sprite offset
C $AFDA,3 Set it in the vischar's sprite_index field
C $AFDD,1 Set flags to Z
C $AFDE,1 Return
;
c $AFDF Handle collisions, including items being pushed around.
D $AFDF Used by the routines at #R$AF8F and #R$C4E0.
R $AFDF O:F Z/NZ => no collision/collision.
N $AFDF Iterate over characters being collided with (e.g. stove).
@ $AFDF label=collision
C $AFDF,3 Point #REGhl at the first vischar's flags field
C $AFE2,2 Set #REGb for eight iterations
N $AFE4 Start loop
C $AFE4,2 Is the vischar_FLAGS_NO_COLLIDE flag bit set?
C $AFE6,3 Skip if so
C $AFE9,1 Preserve the loop counter
C $AFEA,1 Preserve the vischar pointer
N $AFEB Test for contact between the current vischar and saved_pos.
C $AFEB,4 Point #REGhl at vischar's X position
N $AFEF Check X is within (-4..+4)
C $AFEF,3 Fetch X position
C $AFF2,1 Save our vischar pointer while we compare bounds
C $AFF3,3 Fetch saved_pos_x
C $AFF6,7 Add 4 to the X position - our upper bound
C $AFFD,1 Clear the carry flag
C $AFFE,2 Compare saved_pos_x to (X position + 4)
C $B000,2 Equal - jump forward to comparing Y position
C $B002,3 If (saved_pos_x >= (X position + 4)) there was no collision, so jump to the next iteration
C $B005,7 Reduce #REGa by 8 giving (X position - 4) - our lower bound
C $B00C,3 Fetch saved_pos_x again
C $B00F,2 Compare saved_pos_x to (X position - 4)
C $B011,3 If (saved_pos_x < (X position - 4)) there was no collision, so jump to the next iteration
C $B014,1 Restore our vischar pointer
C $B015,1 Advance to Y position
N $B016 Check Y is within (-4..+4)
C $B016,3 Fetch Y position
C $B019,1 Save our vischar pointer while we compare bounds
C $B01A,3 Fetch saved_pos_y
C $B01D,7 Add 4 to the Y position - our upper bound
C $B024,1 Clear the carry flag
C $B025,2 Compare saved_pos_y to (Y position + 4)
C $B027,2 Equal - jump forward to comparing height
C $B029,3 If (saved_pos_y >= (Y position + 4)) there was no collision, so jump to the next iteration
C $B02C,7 Reduce #REGa by 8 giving (Y position - 4) - our lower bound
C $B033,3 Fetch saved_pos_y again
C $B036,2 Compare saved_pos_y to (Y position - 4)
C $B038,3 If (saved_pos_y < (Y position - 4)) there was no collision, so jump to the next iteration
C $B03B,1 Restore our vischar pointer
C $B03C,1 Advance to height
N $B03D Ensure that the heights are within 24 of each other. This will stop the character colliding with any guards high up in watchtowers.
C $B03D,1 Fetch height
C $B03E,3 Fetch saved_height
C $B041,1 Subtract height from saved_height
C $B042,4 If negative flip the sign - get the absolute value
C $B046,5 If the result is >= 24 then jump to the next iteration
N $B04B Check for pursuit.
C $B04B,3 Read the vischar's flags
C $B04E,2 AND the flags with vischar_FLAGS_PURSUIT_MASK
C $B050,2 Is the result vischar_PURSUIT_PURSUE?
C $B052,2 If not, jump forward to collision checking
N $B054 Vischar (IY) is pursuing.
C $B054,2 Restore vischar pointer
C $B056,1 Point at vischar base, not flags
C $B057,4 Is the current vischar the hero's? ($8000)
N $B05B Currently tested vischar (HL) is the hero's.
C $B05B,3 Fetch global bribed character
C $B05E,3 Does it match IY's vischar character?
C $B061,2 No, jump forward to solitary check
N $B063 Vischar #REGiy is a bribed character pursuing the hero.
N $B063 When the pursuer catches the hero the bribe will be accepted.
C $B063,3 Call accept_bribe
C $B066,2 (else)
N $B068 Vischar #REGiy is a hostile who's caught the hero!
C $B068,1 Restore vischar pointer
C $B069,1 Restore loop counter
C $B06A,4 Unused sequence: #REGhl = #REGiy + 1
C $B06E,3 Exit via solitary
N $B071 Check for collisions with items.
C $B071,1 Restore vischar pointer
C $B072,1 Point at vischar base, not flags
C $B073,1 Fetch the vischar's character
C $B074,2 Is the character >= character_26_STOVE_1?
C $B076,2 Jump if NOT
N $B078 It's an item.
C $B078,1 Preserve the vischar pointer
C $B079,1 Bank the character index
C $B07A,4 Point #REGhl at vischar->mi.pos.y
C $B07E,1 Retrieve the character index
N $B07F By default, setup for the stove. It can move on the Y axis only (bottom left to top right).
C $B07F,3 Set #REGb to 7 - the permitted range, in either direction, from the centre point and set #REGc to 35 - the centre point
C $B082,2 Compare character index with character_28_CRATE
C $B084,3 (interleaved) Fetch IY's direction
C $B087,2 If it's not the crate then jump to the stove handling
N $B089 Handle the crate. It can move on the X axis only (top left to bottom right).
C $B089,2 Point #REGhl at vischar->mi.pos.x
C $B08B,2 Centre point is 54 (crate will move 47..54..61)
C $B08D,2 Swap axis left<=>right
N $B08F Top left case.
C $B08F,1 Test the direction: Is it top left? (zero)
C $B090,2 Jump forward to next check if not
N $B092 The player is pushing the movable item from its front, so centre it.
C $B092,1 Load the coordinate
C $B093,1 Is it already at the centre point?
C $B094,2 Jump forward if so
C $B096,5 If the coordinate is larger than the centre point then decrement, else increment its position
C $B09B,2 (else)
N $B09D Top right case.
C $B09D,2 Test the direction: Is it top right? (one)
C $B09F,2 Jump forward to next check if not
C $B0A1,6 If the coordinate is not at its maximum (C+B) then increment its position
C $B0A7,2 (else)
N $B0A9 Bottom right case.
C $B0A9,2 Test the direction: Is it bottom right? (two)
C $B0AB,2 Jump forward to next check if not
C $B0AD,3 Set the position to minimum (C-B) irrespective. Note that this never seems to happen in practice in the game
C $B0B0,2 (else)
N $B0B2 Bottom left case.
C $B0B2,6 If the coordinate is not at its minimum (C-B) then decrement its position
C $B0B8,1 Restore the vischar pointer
C $B0B9,1 Restore the loop counter
N $B0BA Check for collisions with characters.
C $B0BA,4 Point at vischar input field
C $B0BE,3 Load the input field and mask off the input_KICK flag
C $B0C1,2 Jump forward if the input field is zero
C $B0C3,1 Point at the direction field
C $B0C4,3 Swap direction top <=> bottom
C $B0C7,5 If direction != state->IY->direction
@ $B0CC label=collided_not_facing
C $B0CC,4 Set IY's input to input_KICK
N $B0D0 Delay calling character_behaviour for five turns. This delay controls how long it takes before a blocked character will try another direction.
@ $B0D0 label=collided_set_delay
C $B0D0,10 IY->counter_and_flags = (IY->counter_and_flags & ~vischar_BYTE7_COUNTER_MASK) | 5
N $B0DA Note: The following return does work but it's odd that it's conditional.
C $B0DA,1 Return
N $B0DB Note: The #REGc direction field ought to be masked so that we don't access out-of-bounds in new_inputs[] if we collide when crawling.
@ $B0DB label=collided_facing
C $B0DB,5 Fetch IY->direction, widening it to BC
@ $B0E0 nowarn
C $B0E0,3 Point #REGhl at collision_new_inputs
C $B0E3,1 Index it by direction (in BC)
C $B0E4,1 Fetch the direction
C $B0E5,3 IY->input = direction
C $B0E8,2 Is the new direction TR or BL?
C $B0EA,2 Jump if so
C $B0EC,4 IY->counter_and_flags &= ~vischar_BYTE7_Y_DOMINANT
C $B0F0,2 Jump to 'collided_set_delay'
C $B0F2,4 IY->counter_and_flags |= vischar_BYTE7_Y_DOMINAN
C $B0F6,2 Jump to 'collided_set_delay'
N $B0F8 Inputs which move the character in the next anticlockwise direction.
@ $B0F8 label=collision_new_inputs
B $B0F8,1,1 = input_(DOWN+LEFT +KICK) => if facing TL, move D+L
B $B0F9,1,1 = input_(UP  +LEFT +KICK) => if facing TR, move U+L
B $B0FA,1,1 = input_(UP  +RIGHT+KICK) => if facing BR, move U+R
B $B0FB,1,1 = input_(DOWN+RIGHT+KICK) => if facing BL, move D+R
@ $B0FC label=collision_pop_next
C $B0FC,1 Restore the vischar pointer
C $B0FD,1 Restore the loop counter
C $B0FE,4 Step #REGhl to the next vischar
C $B102,4 ...loop for each vischar
C $B106,1 Return with Z set
;
c $B107 Character accepts the bribe.
D $B107 Used by the routines at #R$AFDF and #R$CA81.
R $B107 I:IY Pointer to visible character.
@ $B107 label=accept_bribe
C $B107,3 Increase morale by 10, score by 50
C $B10A,4 Clear the vischar_PURSUIT_PURSUE flag
C $B10E,5 Point #REGhl at IY->route
C $B113,3 Call get_target_assign_pos
N $B116 Return early if we have no bribes.
C $B116,3 Point #REGde at items_held
C $B119,1 Fetch the first item
C $B11A,2 Does it hold item_BRIBE?
C $B11C,2 Jump forward if it does
C $B11E,1 Advance to the second item
C $B11F,1 Fetch the second item
C $B120,2 Does it hold item_BRIBE?
C $B122,1 Return if not
N $B123 Remove the bribe item.
C $B123,3 Assign item_NONE to the item slot, removing the bribe item
C $B126,5 Set the bribe item's item_struct room to itemstruct_ROOM_NONE
C $B12B,3 Draw held items
N $B12E Set the vischar_PURSUIT_SAW_BRIBE flag on all visible hostiles. Iterate over hostile and visible non-player characters.
C $B12E,2 7 iterations
@ $B130 nowarn
C $B130,3 Start at the second visible character
N $B133 Start loop
C $B133,1 Fetch the character index
C $B134,2 Is it > character_20_PRISONER_1?
C $B136,2 Jump forward if so
C $B138,4 Set flags to vischar_PURSUIT_SAW_BRIBE if hostile
C $B13C,4 Advance to the next vischar
C $B140,2 ...loop
C $B142,5 Queue the message "HE TAKES THE BRIBE"
C $B147,2 Then queue the messsage "AND ACTS AS DECOY"
C $B149,3 Return
;
c $B14C Tests whether the position in saved_pos touches any wall or fence boundary.
D $B14C A position (x,y,h) touches a wall if (minx + 2 >= x <= maxx + 3) and (miny >= y <= maxy + 3) and (minh >= h <= maxh + 1).
D $B14C Used by the routines at #R$AF8F and #R$C4E0.
R $B14C I:IY Pointer to visible character.
R $B14C O:F Z set if no bounds hit, Z clear otherwise
@ $B14C label=bounds_check
C $B14C,3 Get the global current room index
N $B14F Interior boundaries are handled by another routine.
C $B14F,1 Is it indoors?
C $B150,3 Use the interior bounds check routine instead, if so (exit via)
C $B153,2 24 iterations / 24 wall definitions
C $B155,3 Point #REGde at the first wall definition
N $B158 Start loop
@ $B158 label=bounds_loop
C $B158,1 Preserve the loop counter
C $B159,1 Preserve the wall definition pointer
N $B15A Check against minimum X
C $B15A,1 Read minimum x
C $B15B,3 Multiply it by 8 returning the result in #REGbc
C $B15E,2 And add two
C $B160,3 Read saved_pos_x
C $B163,2 Compute saved_pos_x - ((wall minimum x) * 8 + 2)
C $B165,2 Jump to the next iteration if saved_pos_x is left of minimum x
N $B167 Check against maximum X
C $B167,1 Move to maximum x field
C $B168,1 Read maximum x
C $B169,3 Multiply it by 8 returning the result in #REGbc
C $B16C,4 And add four
C $B170,3 Re-read saved_pos_x
C $B173,2 Compute saved_pos_x - ((wall maximum x) * 8 + 4)
C $B175,2 Jump to next iteration if saved_pos_x is right of maximum x
N $B177 Check against minimum Y
C $B177,1 Move to minimum y field
C $B178,1 Read minimum y
C $B179,3 Multiply it by 8 returning the result in #REGbc
C $B17C,3 Read saved_pos_y
C $B17F,2 Compute saved_pos_y - ((wall minimum y) * 8)
C $B181,2 Jump to the next iteration if saved_pos_y is below minimum y
N $B183 Check against maximum Y
C $B183,1 Move to maximum y field
C $B184,1 Read maximum y
C $B185,3 Multiply it by 8 returning the result in #REGbc
C $B188,4 And add four
C $B18C,3 Re-read saved_pos_y
C $B18F,2 Compute saved_pos_y - ((wall maximum y) * 8 + 4)
C $B191,2 Jump to next iteration if saved_pos_y is above maximum y
N $B193 Check minimum height
C $B193,1 Move to minimum height field
C $B194,1 Read minimum height
C $B195,3 Multiply it by 8 returning the result in #REGbc
C $B198,3 Read saved_height
C $B19B,2 Compute saved_height - ((wall minimum height) * 8)
C $B19D,2 Jump to the next iteration if saved_height is below minimum height
N $B19F Check maximum height
C $B19F,1 Move to maximum height field
C $B1A0,1 Read maximum height
C $B1A1,3 Multiply it by 8 returning the result in #REGbc
C $B1A4,2 And add two
C $B1A6,3 Re-read saved_height
C $B1A9,2 Compute saved_height - ((wall maximum height) * 8)
C $B1AB,2 Jump to the next iteration if saved_height is above maximum height
N $B1AD Passed all checks - in contact with wall
C $B1AD,1 Restore the wall definition pointer
C $B1AE,1 Restore the loop counter
C $B1AF,8 Toggle counter_and_flags vischar_BYTE7_Y_DOMINANT flag
C $B1B7,2 Clear Z flag
C $B1B9,1 Return with Z clear
@ $B1BA label=bounds_next
C $B1BA,1 Restore the wall definition pointer
C $B1BB,1 Restore the loop counter
C $B1BC,3 Set the wall definition stride
C $B1BF,1 Point to next wall definition
C $B1C0,1 Move the wall definition pointer into #REGde
C $B1C1,4 ...loop
C $B1C5,1 #REGb is zero, AND it with itself to set Z flag
C $B1C6,1 Return with Z set
;
c $B1C7 Multiplies #REGa by 8, returning the result in #REGbc.
D $B1C7 Used by the routines at #R$B14C, #R$C4E0, #R$CA11, #R$CA49 and #R$DBEB.
R $B1C7 I:A Argument.
R $B1C7 O:BC Result of (A << 3).
@ $B1C7 label=multiply_by_8
C $B1C7,2 Set #REGb to zero
C $B1C9,1 Double the input argument
C $B1CA,2 Merge the carry out from the doubling into #REGb
C $B1CC,3 Double it again
C $B1CF,3 And double it again
C $B1D2,1 Move low part of result into #REGc
C $B1D3,1 Return
;
c $B1D4 Locate current door, queuing a message if it's locked.
D $B1D4 Used by the routines at #R$B1F5 and #R$B32D.
R $B1D4 O:F Z set if door open.
@ $B1D4 label=is_door_locked
C $B1D4,2 Set #REGe to the complement of door_REVERSE ($7F)
C $B1D6,3 Fetch the current door [index]
C $B1D9,1 Mask it off
C $B1DA,1 Move it to #REGc
N $B1DB Check all locked doors
C $B1DB,3 Point #REGhl at first locked doors
C $B1DE,2 9 iterations / 9 locked doors
N $B1E0 Start loop
C $B1E0,1 Fetch a door index
C $B1E1,1 Mask off the locked flag
C $B1E2,1 Does it match the current door?
C $B1E3,2 Jump forward if not
C $B1E5,2 Test the door_LOCKED flag
C $B1E7,1 Return if the flag was zero: the door is open
N $B1E8 Otherwise the door is locked
C $B1E8,5 Queue the message "THE DOOR IS LOCKED"
C $B1ED,2 Set flags to NZ - the door is locked
C $B1EF,1 Return
C $B1F0,1 Advance to the next locked door
C $B1F1,2 ...loop
C $B1F3,1 Set flags to Z - the door is open
C $B1F4,1 Return
;
c $B1F5 Door handling.
D $B1F5 Used by the routine at #R$AF8F.
R $B1F5 I:IY Pointer to visible character.
@ $B1F5 label=door_handling
C $B1F5,3 Get the global current room index
N $B1F8 Interior doors are handled by another routine.
C $B1F8,1 Is it indoors?
C $B1F9,3 Exit via the interior door handling routine if so
N $B1FC Select a start position in doors[] based on the direction the hero is facing.
C $B1FC,3 Point #REGhl at the first entry in doors[]
C $B1FF,3 Fetch current vischar's direction field
C $B202,3 Is it direction_BOTTOM_RIGHT or direction_BOTTOM_LEFT?
C $B205,2 Jump if not
C $B207,3 Point #REGhl at the second entry in doors[]
C $B20A,2 Preload door_FLAGS_MASK_DIRECTION mask ($03) into #REGd
N $B20C The first 16 (pairs of) entries in doors[] are the only ones with outdoors as a destination, so only consider those.
C $B20C,2 16 iterations / 16 pairs of entries
N $B20E Start loop
C $B20E,1 Load the door entry's room_and_direction field
C $B20F,1 Extract the direction field
C $B210,1 Does it match the vischar's direction?
C $B211,2 Jump forward if not
N $B213 A match
C $B213,1 Preserve loop counter
C $B214,1 Preserve door entry pointer
C $B215,1 Preserve direction mask
C $B216,3 Call door_in_range -- returns C clear if in range
C $B219,3 Restore the registers stored prior to call
C $B21C,2 If not in range, jump to door_handling_found
@ $B21E label=door_handling_next
C $B21E,7 Step forward two entries
C $B225,2 ...loop
N $B227 Commentary: This seems to exist to set Z, but this routine doesn't return anything!
C $B227,1 Set Z (#REGb is zero here)
C $B228,1 Return
@ $B229 label=door_handling_found
C $B229,6 current door = 16 - iterations
C $B22F,1 Switch register banks over the call
C $B230,3 Call is_door_locked -- returns Z clear if locked
C $B233,1 Return if the door was locked
C $B234,1 Switch registers back
C $B235,1 Fetch door entry's room_and_direction
C $B236,2 Rotate it by two bits
C $B238,2 Clear the top two bits rotated in
C $B23A,3 Store in vischar->room
C $B23D,1 Fetch door entry's room_and_direction again
C $B23E,2 Extract the direction field
C $B240,2 Is it direction_BOTTOM_RIGHT or direction_BOTTOM_LEFT?
C $B242,2 Jump if either of those
N $B244 Point to the next door entry's pos
C $B244,5 Step forward five bytes to the next door entry
C $B249,3 Jump to transition -- never returns
N $B24C Point to the previous door entry's pos
C $B24C,3 Step back three bytes to the previous door entry
C $B24F,3 Jump to transition -- never returns
;
c $B252 Test whether an exterior door is in range.
D $B252 A door is in range if (saved_X,saved_Y) is within -3..+2 of its position (once scaled).
D $B252 Used by the routines at #R$B1F5 and #R$B4D0.
R $B252 I:HL Pointer to a door_t structure.
R $B252 O:F C set if no match.
@ $B252 label=door_in_range
C $B252,1 Step over the room_and_direction field
N $B253 Are we in range on the X axis?
C $B253,1 Fetch door's pos.x
C $B254,1 Preserve the door position pointer
C $B255,3 Multiply pos.x by 4 returning the result in #REGbc
C $B258,7 Subtract 3
C $B25F,3 Get saved_pos_x
C $B262,2 Calculate saved_pos_x - (pos.x * 4 - 3)
C $B264,1 Return if carry set (saved_pos_x is under)
C $B265,7 Add 6, to make pos.x * 4 + 3
C $B26C,3 Get saved_pos_x again
C $B26F,2 Calculate saved_pos_x - (pos.x * 4 + 3)
C $B271,1 Invert the carry flag
C $B272,1 Return if carry set (saved_pos_x is over)
N $B273 Are we in range on the Y axis?
C $B273,1 Restore door position pointer
C $B274,2 Fetch door's pos.y
C $B276,3 Multiply pos.y by 4 returning the result in #REGbc
C $B279,1 Preserve door position pointer
C $B27A,7 Subtract 3
C $B281,3 Get saved_pos_y
C $B284,2 Calculate saved_pos_y - (pos.y * 4 - 3)
C $B286,1 Return if carry set (saved_pos_y is under)
C $B287,7 Add 6, to make pos.y * 4 + 3
C $B28E,3 Get saved_pos_y again
C $B291,2 Calculate saved_pos_y - (pos.y * 4 + 3)
C $B293,1 Invert the carry flag
C $B294,1 Return with result of final test
;
c $B295 Multiplies #REGa by 4, returning the result in #REGbc.
D $B295 Used by the routines at #R$68A2 and #R$B252.
R $B295 I:A Value to multiply.
R $B295 O:BC Result of #REGa * 4.
@ $B295 label=multiply_by_4
C $B295,2 Initialise high byte of result to zero
C $B297,1 Double input value
C $B298,2 Shift carry out into high byte
C $B29A,1 Double input value
C $B29B,2 Shift carry out into high byte
C $B29D,1 #REGbc is the multiplied value
C $B29E,1 Return
;
c $B29F Check the character is inside of bounds, when indoors.
D $B29F Used by the routine at #R$B14C.
R $B29F I:IY Pointer to visible character.
R $B29F O:F Z clear if boundary hit, set otherwise.
@ $B29F label=interior_bounds_check
C $B29F,3 Fetch index into room dimensions (roomdef_bounds_index)
N $B2A2 Point #REGbc at roomdef_dimensions[roomdef_bounds_index]
C $B2A2,2 Multiply index by the size of a bounds (4)
C $B2A4,3 Point #REGbc at roomdef_dimensions[0]
C $B2A7,5 Combine #REGbc with the scaled index
N $B2AC Check X axis
N $B2AC Note that the room dimensions are given in an unusual order: x1, x0, y1, y0.
C $B2AC,3 Point #REGhl at saved_pos
C $B2AF,1 Fetch bounds.x1
C $B2B0,1 Compare bounds.x1 with saved_pos_x
C $B2B1,2 If bounds.x1 < saved_pos_x jump to 'stop'
C $B2B3,2 Fetch bounds.x0
C $B2B5,2 Add 4
C $B2B7,1 Compare (bounds.x0 + 4) with saved_pos_x
C $B2B8,2 If (bounds.x0 + 4) >= saved_pos_x jump to 'stop'
C $B2BA,2 Advance #REGhl to saved_pos_y
N $B2BC Bug: The next instruction is stray code. #REGde is incremented but never used.
C $B2BC,1 (bug)
N $B2BD Check Y axis
C $B2BD,1 Point #REGbc at bounds.y1
C $B2BE,1 Fetch bounds.y1
C $B2BF,2 Subtract 4
C $B2C1,1 Compare (bounds.y1 - 4) with saved_pos_y
C $B2C2,2 If (bounds.y1 - 4) < saved_pos_y jump to 'stop'
C $B2C4,1 Point #REGbc at bounds.y0
C $B2C5,1 Fetch bounds.y0
C $B2C6,1 Compare bounds.y0 with saved_pos_y
C $B2C7,2 If bounds.y0 >= saved_pos_y jump to 'stop'
N $B2C9 Bomb out if there are no bounds to consider.
C $B2C9,3 Point #REGhl at roomdef_object_bounds_count
C $B2CC,1 Fetch the count of object bounds
C $B2CD,1 Move it to #REGa so we can test it
C $B2CE,1 Is the count zero?
C $B2CF,1 Return with Z set if so
C $B2D0,1 Step over to roomdef_object_bounds
N $B2D1 Start loop (outer)
C $B2D1,1 Preserve the loop counter
C $B2D2,1 Preserve the bounds pointer
C $B2D3,3 Point #REGhl at saved_pos
C $B2D6,2 2 iterations - once per axis
N $B2D8 Start loop (inner)
C $B2D8,1 Fetch saved_pos_x, or saved_pos_y on the second pass
C $B2D9,1 Is it less than the lower bound?
C $B2DA,2 Jump to the next iteration if so
C $B2DC,1 Step to the upper bound
C $B2DD,1 Is it greater or equal to the upper bound?
C $B2DE,2 Jump to the next iteration if so
C $B2E0,2 Step to the next saved_pos axis
C $B2E2,1 Step to the next bound axis
C $B2E3,2 ...loop (inner)
N $B2E5 Found.
C $B2E5,1 Restore the bounds pointer
C $B2E6,1 Restore the loop counter
N $B2E7 Toggle movement direction preference.
@ $B2E7 label=stop
C $B2E7,3 Fetch IY->counter_and_flags
C $B2EA,2 Toggle vischar_BYTE7_Y_DOMINANT
C $B2EC,3 Store IY->counter_and_flags
C $B2EF,2 Clear Z flag
C $B2F1,1 Return with Z clear
N $B2F2 Next iteration.
@ $B2F2 label=next
C $B2F2,1 Restore the bounds pointer
C $B2F3,4 Advance to next bound
C $B2F7,1 Restore the loop counter
C $B2F8,2 ...loop (outer)
N $B2FA Not found.
C $B2FA,1 #REGb is zero, AND it with itself to set Z flag
C $B2FB,1 Return with Z set
;
c $B2FC Reset the hero's position, redraw the scene, then zoombox it onto the screen.
D $B2FC Used by the routines at #R$68A2 and #R$9DE5.
N $B2FC Reset hero's position.
@ $B2FC label=reset_outdoors
C $B2FC,6 Reset the hero's screen position
N $B302 Centre the map position on the hero.
C $B302,3 Point #REGhl at the hero's iso_pos.x
C $B305,3 Read it into (#REGa, #REGc)
C $B308,3 Divide (#REGc,#REGa) by 8 (with no rounding). Result is in #REGa
N $B30B 11 here is the width of the game screen minus half of the hero's width
C $B30B,2 Subtract 11
C $B30D,3 Set map_position.x
C $B310,1 Advance #REGhl to the hero's iso_pos.y
C $B311,3 Read it into (#REGa, #REGc)
C $B314,3 Divide (#REGc,#REGa) by 8 (with no rounding). Result is in #REGa
N $B317 6 here is the height of the game screen minus half of the hero's height
C $B317,2 Subtract 6
C $B319,3 Set map_position.y
C $B31C,4 Set the global current room index to room_0_OUTDOORS
C $B320,3 Update the supertiles in map_buf
C $B323,3 Plot all tiles
C $B326,3 Setup movable items
C $B329,3 Zoombox the scene onto the screen
C $B32C,1 Return
;
c $B32D Door handling (indoors).
D $B32D Used by the routine at #R$B1F5.
R $B32D I:IY Pointer to visible character.
@ $B32D label=door_handling_interior
C $B32D,3 Point #REGhl at the interior_doors array
N $B330 Loop through every door index in interior_doors.
N $B330 Start loop
C $B330,1 Fetch a door index
C $B331,2 Does it equal door_NONE? ($FF)
C $B333,1 If so, we've reached the end of the list - return
C $B334,1 Switch register banks until the end of this iteration
C $B335,3 Set the global current door to door index
C $B338,3 Turn the door_index into a door_t structure pointer in #REGhl
C $B33B,2 Fetch room_and_flags from the door_t and save in #REGc for later
N $B33D Does the character face the same direction as the door?
C $B33D,2 Mask off the door's direction part (door_FLAGS_MASK_DIRECTION)
C $B33F,1 Stash it in #REGb for a comparison in a moment
C $B340,3 Fetch IY's direction & crawl byte
C $B343,2 Mask off the direction part (vischar_DIRECTION_MASK)
C $B345,1 Do the door and vischar have the same direction?
C $B346,2 Jump to the next iteration if not
N $B348 Skip any door which is more than three units away.
C $B348,1 Advance #REGhl to point at door's position
C $B349,1 Move it into #REGde
N $B34A TODO: Does this treat saved_pos as 8-bit quantities? (it's normally 16-bit)
C $B34A,3 Point #REGde at saved_pos_x
C $B34D,2 Iterate twice: X,Y axis
N $B34F Start loop
C $B34F,1 Fetch door position x/y
C $B350,2 Subtract 3 to form lower bound (pos-3)
C $B352,1 Compare to saved_pos_x/y
C $B353,2 If lower bound >= saved_pos goto next
C $B355,2 Add 6 to form upper bound (pos+3)
C $B357,1 Compare to saved_pos_x/y
C $B358,2 If upper bound < saved_pos goto next
C $B35A,2 Step to the next saved_pos axis
C $B35C,1 Step to the next door position axis
C $B35D,2 ...loop
C $B35F,1 Skip position height byte
C $B360,1 Move door position back into #REGhl
C $B361,1 Preserve door position pointer
C $B362,1 Preserve iteration counter
C $B363,3 Locate current door. Returns Z set if door is open
C $B366,1 Restore iteration counter
C $B367,1 Restore door position pointer
C $B368,1 Return if Z clear => the door was locked
N $B369 The door is in range and is unlocked - proceed with transition.
N $B369 Set the vischar's room to the door's destination.
C $B369,1 Retrieve the room_and_flags we saved earlier
C $B36A,4 Discard the direction bits so it's room index only
C $B36E,3 Store it in vischar->room
N $B371 Get the destination position for transition.
N $B371 If we're going through the door in the forward direction we fetch our destination position from the next element in the list. If we're reversed we fetch the previous element in the list.
C $B371,1 Point at the next door position
C $B372,3 Fetch the global current door
C $B375,2 Is door_REVERSE set?
C $B377,2 Jump if so. #REGhl is setup for transition call
C $B379,7 Subtract 8 from #REGhl
C $B380,3 Jump to transition -- never returns
@ $B383 label=dhi_next
C $B383,1 Unbank
C $B384,1 Advance to the next door in interior_doors[]
C $B385,2 ...loop
;
c $B387 The hero has tried to open the red cross parcel.
@ $B387 label=action_red_cross_parcel
C $B387,5 Clear the red cross parcel item's room field
C $B38C,3 Point #REGhl at items_held
N $B38F We've arrived here from a 'use' command, so one or the other item must be the red cross parcel.
C $B38F,3 Is the first item the red cross parcel? (item_RED_CROSS_PARCEL)
C $B392,2 Jump if so
C $B394,1 Advance if not
N $B395 #REGhl now points to the held item.
C $B395,2 Remove parcel from the inventory
C $B397,3 Draw held items
C $B39A,3 Fetch the value of the parcel's current contents
C $B39D,3 Pass that into "drop item, tail part"
C $B3A0,5 Queue the message "YOU OPEN THE BOX"
C $B3A5,3 Increase morale by 10, score by 50 and exit via
;
c $B3A8 The hero tries to bribe a prisoner.
D $B3A8 This searches through the visible, friendly characters only and returns the first found. The selected character will then pursue the hero. Once they've touched it will accept the bribe (see #R$CA8D).
N $B3A8 Iterate over non-player visible characters.
@ $B3A8 label=action_bribe
@ $B3A8 nowarn
C $B3A8,3 Point #REGhl at the second visible character
C $B3AB,2 Set #REGb for seven iterations
N $B3AD Start loop
C $B3AD,1 Fetch the vischar's character index
C $B3AE,2 Is it character_NONE?
C $B3B0,2 Jump to the next vischar if so
C $B3B2,2 Is it character_20_PRISONER_1?
C $B3B4,2 Jump to bribe_found if >=
C $B3B6,4 Step to the next vischar
C $B3BA,2 ...loop
C $B3BC,1 Return
@ $B3BD label=bribe_found
C $B3BD,3 Set the global bribed character to #REGa
C $B3C0,1 Point #REGhl at vischar flags
C $B3C1,2 Set flags to vischar_PURSUIT_PURSUE
C $B3C3,1 Return
;
c $B3C4 Use poison.
@ $B3C4 label=action_poison
C $B3C4,3 Load both held items
C $B3C7,2 Prepare item_FOOD
C $B3C9,1 Is the first item item_FOOD?
C $B3CA,2 Jump to have_food if so
C $B3CC,1 Is the second item item_FOOD?
C $B3CD,1 Return if not
@ $B3CE label=have_food
C $B3CE,3 Point #REGhl at item_structs[item_FOOD].item
C $B3D1,2 Is bit 5 set? (itemstruct_ITEM_FLAG_POISONED)
C $B3D3,1 Return if so - the food is already poisoned
C $B3D4,2 Set bit 5
C $B3D6,5 Set the screen attribute for the food item to bright-purple over black
C $B3DB,3 Draw held items
C $B3DE,3 Increase morale by 10, score by 50 and exit via
;
c $B3E1 Use guard's uniform.
@ $B3E1 label=action_uniform
C $B3E1,3 Point #REGhl at the hero's vischar sprite set pointer
C $B3E4,3 Point #REGde at the guard sprite set
N $B3E7 Bail out if the hero's already in the uniform
C $B3E7,3 Cheap equality test
N $B3EA Can't don the uniform when in a tunnel
C $B3EA,6 If the global current room index is room_29_SECOND_TUNNEL_START or above... we're in the tunnels, so bail out
N $B3F0 Otherwise the uniform can be worn
C $B3F0,3 Set the hero's sprite set to sprite_guard
C $B3F3,3 Increase morale by 10, score by 50 and exit via
;
c $B3F6 Use shovel.
D $B3F6 The shovel only works in the room with the blocked tunnel: number 50.
@ $B3F6 label=action_shovel
C $B3F6,6 If the global current room index isn't room_50_BLOCKED_TUNNEL bail out
N $B3FC Bomb out if the blockage is already removed.
C $B3FC,3 Fetch the room definition's first boundary byte
C $B3FF,2 Is it 255?
C $B401,1 Return if so - the blockage was already removed
N $B402 Otherwise we can remove the blockage
N $B402 (Note that the hero doesn't need to be adjacent to the blockage for this to work, only in the same room).
N $B402 The blockage boundary's x0 is set to 255. This invalidates the boundary by forcing the "x < bounds->x0" test at #R$B2D9 (in interior_bounds_check) to fail.
C $B402,5 roomdef_50_blocked_tunnel_boundary[0] = 255
N $B407 Remove the blockage graphic.
C $B407,4 roomdef_50_blocked_tunnel_collapsed_tunnel = 0
C $B40B,3 Setup the room
C $B40E,3 Choose game window attributes
C $B411,3 Render visible tiles array into the screen buffer
C $B414,3 Increase morale by 10, score by 50 and exit via
;
c $B417 Use wiresnips.
N $B417 Check the hero's position against the four vertically-oriented fences.
@ $B417 label=action_wiresnips
C $B417,3 Point #REGhl at the 12th entry of the walls array: the start of the vertically-oriented fences PLUS three bytes so it points at the maxy value.
C $B41A,3 Point #REGde at hero_map_position.y
C $B41D,2 Set #REGb for four iterations (four vertical fences)
N $B41F Start loop
C $B41F,1 Preserve the wall entry pointer during this iteration
N $B420 Are we in range on the Y axis?
C $B420,1 Fetch hero_map_position.y
C $B421,1 Is it >= wall->maxy?
C $B422,2 Jump to the next iteration if so
C $B424,1 Step #REGhl back to wall->miny
C $B425,1 Is it < wall->miny?
C $B426,2 Jump to the next iteration if so
N $B428 Are we adjacent to the wall on the X axis?
C $B428,1 Step #REGde back to hero_map_position.x
C $B429,1 Fetch hero_map_position.x
C $B42A,1 Step #REGhl back to wall->maxx
C $B42B,1 Is it == wall->maxx?
C $B42C,2 Jump to snips_crawl_tl if so
C $B42E,1 Try the opposite side
C $B42F,1 Is it == wall->maxx?
C $B430,2 Jump to snips_crawl_br if so
C $B432,1 Advance #REGde to hero_map_position.y
@ $B433 label=snips_next_vert
C $B433,1 Restore wall array pointer
C $B434,7 Advance #REGhl to the next wall array element PLUS 3 bytes
C $B43B,2 ...loop
N $B43D Check the hero's position against the three horizontally-oriented fences.
C $B43D,1 Step #REGde back to hero_map_position.x
N $B43E Point #REGhl at the 16th entry of walls array (start of horizontal fences).
C $B43E,3 Step #REGhl back to the 16th entry of the walls array PLUS 0 bytes (it's three ahead prior to this)
C $B441,2 Set #REGb for three iterations (three horizontal fences)
N $B443 Start loop
C $B443,1 Preserve wall array pointer during this iteration
N $B444 Are we in range on the X axis?
C $B444,1 Fetch hero_map_position.x
C $B445,1 Is it < wall->minx?
C $B446,2 Jump to the next iteration if so
C $B448,1 Advance #REGhl to wall->maxx
C $B449,1 Is x >= wall->maxx?
C $B44A,2 Jump to the next iteration if so
N $B44C Are we adjacent to the wall on the Y axis?
C $B44C,1 Advance #REGde to hero_map_position.y
C $B44D,1 Fetch hero_map_position.y
C $B44E,1 Advance #REGhl to wall->miny
C $B44F,1 Is it == wall->miny?
C $B450,2 Jump to snips_crawl_tr if so
C $B452,1 Try the opposite side
C $B453,1 Is it == wall->maxy?
C $B454,2 Jump to snips_crawl_bl if so
C $B456,1 Step #REGde back to hero_map_position.x
@ $B457 label=snips_next_horz
C $B457,1 Restore wall array pointer
C $B458,7 Advance #REGhl to the next wall array element PLUS 3 bytes
C $B45F,2 ...loop
C $B461,1 Return
@ $B462 label=snips_crawl_tl
C $B462,2 Set #REGa to 4 (direction_TOP_LEFT + vischar_DIRECTION_CRAWL)
C $B464,2 Jump forward
@ $B466 label=snips_crawl_tr
C $B466,2 Set #REGa to 5 (direction_TOP_RIGHT + vischar_DIRECTION_CRAWL)
C $B468,2 Jump forward
@ $B46A label=snips_crawl_br
C $B46A,2 Set #REGa to 6 (direction_BOTTOM_RIGHT + vischar_DIRECTION_CRAWL)
C $B46C,2 Jump forward
@ $B46E label=snips_crawl_bl
C $B46E,2 Set #REGa to 7 (direction_BOTTOM_LEFT + vischar_DIRECTION_CRAWL)
N $B470 #REGa is the direction + crawl flag. Proceed to making the hero cut the wire.
@ $B470 label=snips_tail
C $B470,1 Restore wall array pointer
@ $B471 nowarn
C $B471,4 Set hero's vischar.direction field (direction and walk/crawl flag) to the direction selected above
C $B475,3 Set hero's vischar.input field to input_KICK
C $B478,5 Set hero's vischar.flags to vischar_FLAGS_CUTTING_WIRE
C $B47D,5 Set hero's vischar.mi.pos.height to 12
C $B482,6 Set vischar.mi.sprite to the prisoner sprite set
C $B488,8 Lock out the player until the game counter is now + 96
C $B490,5 Queue the message "CUTTING THE WIRE" and exit via
;
c $B495 Use lockpick.
@ $B495 label=action_lockpick
C $B495,3 Get the nearest door in range of the hero in #REGhl
C $B498,1 Return if no door was nearby
C $B499,3 Store the door_t pointer in ptr_to_door_being_lockpicked
C $B49C,8 Lock out player control until the game counter becomes now + 255
C $B4A4,5 Set hero's vischar.flags to vischar_FLAGS_PICKING_LOCK
C $B4A9,5 Queue the message "PICKING THE LOCK" and exit via
;
c $B4AE Use red key.
@ $B4AE label=action_red_key
C $B4AE,2 Set the room number in #REGa to room_22_REDKEY
C $B4B0,2 Jump to action_key
;
c $B4B2 Use yellow key.
@ $B4B2 label=action_yellow_key
C $B4B2,2 Set the room number in #REGa to room_13_CORRIDOR
C $B4B4,2 Jump to action_key
;
c $B4B6 Use green key.
@ $B4B6 label=action_green_key
C $B4B6,2 Set the room number in #REGa to room_14_TORCH
E $B4B6 FALL THROUGH into action_key.
;
c $B4B8 Use a key.
D $B4B8 Used by the routines at #R$B4AE and #R$B4B2.
R $B4B8 I:A Room number to which the key applies.
@ $B4B8 label=action_key
C $B4B8,1 Preserve the room number while we get the nearest door
C $B4B9,3 Return the nearest door in range of the hero in #REGhl
C $B4BC,1 Restore the room number
C $B4BD,1 Return if no door was nearby
C $B4BE,1 Fetch door index + flag
C $B4BF,2 Mask off door_LOCKED flag to get door index alone
C $B4C1,1 Are they equal?
C $B4C2,2 Set #REGb to message_INCORRECT_KEY irrespectively
C $B4C4,2 Jump if not equal
C $B4C6,2 Unlock the door by resetting door_LOCKED ($80)
C $B4C8,3 Increase morale by 10, score by 50
C $B4CB,2 Set #REGb to message_IT_IS_OPEN
C $B4CD,3 Queue the message identified by #REGb
;
c $B4D0 Return the nearest door in range of the hero.
D $B4D0 Used by the routines at #R$B495 and #R$B4B8.
R $B4D0 O:HL Pointer to door in locked_doors.
R $B4D0 O:F Returns Z set if a door was found, clear otherwise.
@ $B4D0 label=get_nearest_door
C $B4D0,3 Get the global current room index
C $B4D3,1 Is it room_0_OUTDOORS?
C $B4D4,2 Jump forward to handle outdoors if so
N $B4D6 Bug: Could avoid this jump instruction by using fallthrough instead.
C $B4D6,3 Otherwise jump forward to handle indoors
N $B4D9 Outdoors.
N $B4D9 Locked doors 0..4 include exterior doors.
@ $B4D9 label=gnd_outdoors
C $B4D9,2 Set #REGb for five iterations
C $B4DB,3 Point #REGhl at the locked door indices
N $B4DE Start loop
@ $B4DE label=gnd_outdoors_loop
C $B4DE,1 Fetch the door index and door_LOCKED flag
C $B4DF,2 Mask off door_LOCKED flag to get the door index alone
C $B4E1,1 Switch register banks for this iteration
C $B4E2,3 Turn a door index into a door_t pointer in #REGhl
C $B4E5,1 Preserve the door_t pointer
C $B4E6,3 Call door_in_range. C is clear if it's in range
C $B4E9,1 Restore door_t pointer
C $B4EA,2 Jump forward if in range
C $B4EC,4 Advance #REGhl to the next door_t
C $B4F0,3 Call door_in_range. C is clear if it's in range
C $B4F3,2 Jump forward if in range
C $B4F5,1 Unbank
C $B4F6,1 Advance to the next door index and flag in locked_doors
C $B4F7,2 ...loop
C $B4F9,1 Return with Z clear (from the INC HL above) (not found)
@ $B4FA label=gnd_in_range
C $B4FA,1 Unbank
C $B4FB,1 Set Z flag (found)
C $B4FC,1 Return
N $B4FD Indoors.
N $B4FD Locked doors 2..8 include interior doors.
@ $B4FD nowarn
@ $B4FD label=gnd_indoors
C $B4FD,3 Point #REGhl at the third locked door index
N $B500 Bug: Ought to be 7 iterations.
C $B500,2 Set #REGb for eight iterations
N $B502 Start loop
@ $B502 label=gnd_indoors_loop
C $B502,1 Fetch the door index and door_LOCKED flag
C $B503,2 Mask off door_LOCKED flag to get the door index alone
C $B505,1 Keep in #REGc for use during the loop
N $B506 Search interior doors for the door index in #REGc.
C $B506,3 Point #REGde at interior_doors
N $B509 Start loop (inner)
@ $B509 label=gnd_indoors_loop_2
C $B509,1 Fetch an interior door index
C $B50A,2 Is it door_NONE? (end of list)
C $B50C,2 Jump if so
C $B50E,2 Mask off door_REVERSE flag to get the door index alone
C $B510,1 Is it a locked door index?
C $B511,2 Jump if so
C $B513,1 Otherwise advance to the next interior door index
N $B514 There's no termination condition here where you might expect a test to see if we've run out of doors, but since every room has at least one door it *must* find one.
C $B514,2 ...loop
N $B516 Start loop
@ $B516 label=gnd_next
C $B516,1 Advance to the next door index and flag in locked_doors
C $B517,2 ...loop
C $B519,2 Clear the Z flag (not found)
C $B51B,1 Return
@ $B51C label=gnd_found
C $B51C,1 Fetch an interior door index
C $B51D,1 Switch register banks until we return
C $B51E,3 Turn a door index into a door_t pointer in #REGhl
C $B521,1 Advance door pointer to door.pos.x
C $B522,1 Move the door pointer into #REGde
C $B523,3 Point #REGhl at saved_pos_x
C $B526,2 Set #REGb for two iterations (two axis)
N $B528 Note: This treats saved_pos as an 8-bit quantity in a 16-bit container.
N $B528 Start loop -- once for each axis
N $B528 On each axis if ((door - 2) <= pos and (door + 3) >= pos) then we're good.
C $B528,1 Fetch door.pos.x/y
C $B529,2 Compute the lower bound by subtracting 3
C $B52B,1 Is lower bound >= saved_pos_x/y?
C $B52C,2 Jump if so (out of bounds - try the next door)
C $B52E,2 Compute the upper bound by adding 6
C $B530,1 Is upper bound < saved_pos_x/y?
C $B531,2 Jump if so (out of bounds - try the next door)
C $B533,2 Advance to the next saved_pos axis
C $B535,1 Advance to the next door.pos axis
C $B536,2 ...loop
N $B538 If we arrive here then we're within the bounds
C $B538,1 Switch back
C $B539,1 Set Z flag (found)
C $B53A,1 Return
@ $B53B label=gnd_exx_next
C $B53B,1 Switch back
C $B53C,2 ...loop
;
b $B53E Wall boundaries.
D $B53E The coordinates are in map space.
D $B53E #TABLE(default) { =h Field | =h Description } { minx     | Minimum x } { maxx     | Maximum x } { miny     | Minimum y } { maxy     | Maximum y } { minh     | Minimum height } { maxh     | Maximum height } TABLE#
@ $B53E label=walls
B $B53E,6,6 0: (106-110,  82-98,  0-11) Hut 0 (leftmost on main map)
B $B544,6,6 1: ( 94-98,   82-98,  0-11) Hut 1 (home hut)
B $B54A,6,6 2: ( 82-86,   82-98,  0-11) Hut 2 (rightmost on main map)
B $B550,6,6 3: ( 62-90,  106-128, 0-48) Main building, top right
B $B556,6,6 4: ( 52-128, 114-128, 0-48) Main building, topmost/right
B $B55C,6,6 5: (126-152,  94-128, 0-48) Main building, top left
B $B562,6,6 6: (130-152,  90-128, 0-48) Main building, top left
B $B568,6,6 7: (134-140,  70-128, 0-10) Main building, left wall / west wall
B $B56E,6,6 8: (130-134,  70-74,  0-18) Corner, bottom left / west turret wall
B $B574,6,6 9: (110-130,  70-71,  0-10) Front wall / south wall
B $B57A,6,6 10: (109-111,  69-73,  0-18) Gate post (left)
B $B580,6,6 11: (103-105,  69-73,  0-18) Gate post (right)
B $B586,6,6 12: ( 70-70,   70-106, 0-8 ) Fence - right of main camp (vertical)
B $B58C,6,6 13: ( 62-62,   62-106, 0-8 ) Fence - rightmost fence (vertical)
B $B592,6,6 14: ( 78-78,   46-62,  0-8 ) Fence - rightmost of yard (vertical)
B $B598,6,6 15: (104-104,  46-69,  0-8 ) Fence - leftmost of yard (vertical)
B $B59E,6,6 16: ( 62-104,  62-62,  0-8 ) Fence - top of yard (horizontal)
B $B5A4,6,6 17: ( 78-104,  46-46,  0-8 ) Fence - bottom of yard (horizontal)
B $B5AA,6,6 18: ( 70-103,  70-70,  0-8 ) Fence - bottom of main camp (horizontal)
B $B5B0,6,6 19: (104-106,  56-58,  0-8 ) Fence - watchtower (left, outside of exercise yard)
B $B5B6,6,6 20: ( 78-80,   46-48,  0-8 ) Fence - watchtower (inside exercise yard)
B $B5BC,6,6 21: ( 70-72,   70-72,  0-8 ) Fence - watchtower (corner of main camp)
B $B5C2,6,6 22: ( 70-72,   94-96,  0-8 ) Fence - watchtower (top right of main camp)
B $B5C8,6,6 23: (105-109,  70-73,  0-8 ) Fence - gate wall middle
;
c $B5CE Animate all visible characters.
D $B5CE Used by the routines at #R$6939 and #R$9D7B.
@ $B5CE label=animate
C $B5CE,2 Set #REGb for eight iterations
C $B5D0,4 Point #REGiy at the first vischar
N $B5D4 Start loop
@ $B5D4 label=animate_loop
C $B5D4,3 Read the vischar's flags byte
C $B5D7,2 Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
C $B5D9,3 Jump to the next iteration if so
C $B5DC,1 Preserve the loop counter
C $B5DD,4 Set flags byte to vischar_FLAGS_NO_COLLIDE ($80)
C $B5E1,4 Does the vischar's input field have flag input_KICK set? ($80)
C $B5E5,3 Jump if so
C $B5E8,6 Fetch vischar animation pointer into #REGhl
C $B5EE,3 Fetch vischar animation index
C $B5F1,1 Is vischar_ANIMINDEX_REVERSE set? ($80)
C $B5F2,3 Jump if not
C $B5F5,2 Otherwise mask off vischar_ANIMINDEX_REVERSE to get our frame number
N $B5F7 Bug: This ought to check for $7F, not zero.
C $B5F7,3 Jump to initialisation if the result is zero
C $B5FA,8 Calculate the animation frame pointer = (animation pointer) + (frame number + 1) * 4 - 1
C $B602,1 Fetch anim's sprite index
C $B603,1 Bank sprite index
C $B604,1 ...
@ $B605 label=animate_backwards
C $B605,1 Swap frame pointers
N $B606 Apply frame deltas
N $B606 saved_pos_x = vischar.mi.pos.x - frame->dx
C $B606,6 Fetch vischar.mi.pos.x into #REGhl
C $B60C,1 Load animation frame's delta X
C $B60D,8 Sign extend into #REGbc
C $B615,2 Subtract the delta
C $B617,3 Save it in saved_pos_x
N $B61A saved_pos_y = vischar.mi.pos.y - frame->dy
C $B61A,1 Advance to animation frame's delta Y
C $B61B,6 Fetch vischar.mi.pos.y into #REGhl
C $B621,1 Load animation frame's delta Y
C $B622,8 Sign extend into #REGbc
C $B62A,2 Subtract the delta
C $B62C,3 Save it in saved_pos_y
N $B62F saved_height = vischar.mi.pos.height - frame->dh
C $B62F,1 Advance to animation frame's delta height
C $B630,6 Fetch vischar.mi.pos.height into #REGhl
C $B636,1 Load animation frame's delta height
C $B637,8 Sign extend into #REGbc
C $B63F,2 Subtract the delta
C $B641,3 Save it in saved_height
C $B644,3 Test for characters meeting obstacles like doors and map bounds
C $B647,3 If outside bounds (collided with something), jump to animate_pop_next to halt any animation
C $B64A,3 Decrement animation index [DPT: Was there a bug around here?]
C $B64D,2 (else)
N $B64F Have we reached the end of the animation?
C $B64F,1 Is the animation index equal to the number of frames in the animation?
C $B650,3 Jump if so
C $B653,7 Calculate the animation frame pointer = (animation pointer) + (frame number + 1) * 4
@ $B65A label=animate_forwards
C $B65A,1 Swap frame pointers
N $B65B Apply frame deltas
N $B65B saved_pos_x = vischar.mi.pos.x - frame->dx
C $B65B,1 Load animation frame's delta X
C $B65C,8 Sign extend into #REGhl
C $B664,6 Fetch vischar.mi.pos.x into #REGbc
C $B66A,1 Add the delta
C $B66B,3 Save it in saved_pos_x
N $B66E saved_pos_y = vischar.mi.pos.y - frame->dy
C $B66E,1 Advance to animation frame's delta Y
C $B66F,1 Load animation frame's delta Y
C $B670,8 Sign extend into #REGhl
C $B678,6 Fetch vischar.mi.pos.y into #REGbc
C $B67E,1 Add the delta
C $B67F,3 Save it in saved_pos_y
N $B682 saved_height = vischar.mi.pos.height - frame->dh
C $B682,1 Advance to animation frame's delta height
C $B683,1 Load animation frame's delta height
C $B684,8 Sign extend into #REGhl
C $B68C,6 Fetch vischar.mi.pos.height into #REGbc
C $B692,1 Add the delta
C $B693,3 Save it in saved_height
C $B696,1 Advance to animation frame's sprite index
C $B697,1 Load animation frame's sprite index
C $B698,1 Bank #REGa
C $B699,3 Test for characters meeting obstacles like doors and map bounds
C $B69C,3 If outside bounds (collided with something), goto animate_pop_next to halt any animation
C $B69F,3 Increment animation index
C $B6A2,3 #REGhl = #REGiy
C $B6A5,3 Calculate screen position for vischar from saved_pos
@ $B6A8 label=animate_pop_next
C $B6A9,3 Read the vischar's flags byte
C $B6AC,2 Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
C $B6AE,2 Jump forward if so
C $B6B0,4 Otherwise clear the vischar_FLAGS_NO_COLLIDE flag ($80)
@ $B6B4 label=animate_next
C $B6B4,3 Set #REGde to the vischar stride (32)
C $B6B7,2 Advance #REGiy to the next vischar
C $B6B9,4 ...loop
C $B6BD,1 Return
@ $B6BE label=animate_kicked
C $B6BE,4 Clear the input_KICK flag
@ $B6C2 label=animate_init
C $B6C2,3 Fetch vischar direction field
C $B6C5,5 Multiply it by 9
C $B6CA,3 Add vischar input field to it
C $B6CD,3 Shuffle it into #REGde
C $B6D0,4 Add it to the animindices base address
C $B6D4,1 Fetch the index pointed to
C $B6D5,1 Stash in #REGc for later
C $B6D6,6 Fetch vischar.animbase (animbase is always &animations[0])
C $B6DC,1 Double #REGa (and in doing so discard the top bit!)
C $B6DD,1 Set #REGde to #REGa (we know #REGd is zero from above)
C $B6DE,1 Point at the #REGa'th frame pointer
C $B6DF,9 Load the frame pointer into #REGde and set vischar anim field to it
C $B6E8,2 Was the reverse bit set on the index?
C $B6EA,2 Jump forward if so
C $B6EC,4 Zero the vischar animindex field
C $B6F0,2 Skip nframes and from fields. Advance #REGde to animB->to
C $B6F2,4 Set the vischar direction field to animB->to
C $B6F6,2 Advance to animB->frames
C $B6F8,1 Swap frame pointers
C $B6F9,3 Jump
N $B6FC else
C $B6FC,1 Fetch nframes
C $B6FD,1 Stash in #REGc for later
N $B6FE Bug: C port uses (nframes - 1) here to fix something... (add detail)
C $B6FE,5 Set the vischar animindex field to (nframes | vischar_ANIMINDEX_REVERSE)
C $B703,1 Advance to 'from'
C $B704,4 Set the vischar direction field to 'from'
N $B708 Bug: C port uses final frame here, not first... (add detail)
C $B708,3 Advance to animB->frame[0]
C $B70B,1 Stack animB
C $B70C,1 Swap frame pointers
C $B70D,8 Point #REGhl at anim[nframes - 1].spriteindex
C $B715,1 Fetch the new sprite index
C $B716,1 Swap the sprite indices
C $B717,1 Pop and swap?
C $B718,3 Jump
;
c $B71B Calculate screen position for the specified vischar from mi.pos.
D $B71B Used by the routines at #R$68F4, #R$697D, #R$A491, #R$B2FC and #R$C4E0.
R $B71B I:HL Pointer to visible character.
@ $B71B label=calc_vischar_iso_pos_from_vischar
C $B71B,1 Preserve vischar pointer
N $B71C Save a copy of the vischar's position to global saved_pos.
C $B71C,4 Point #REGhl at vischar.mi.pos
C $B720,3 Point #REGde at saved_pos
C $B723,3 Six bytes
C $B726,2 Block copy
C $B728,1 Restore vischar pointer
E $B71B Now FALL THROUGH into calc_vischar_iso_pos_from_state which will read from saved_pos.
;
c $B729 Calculate screen position for the specified vischar from saved_pos.
D $B729 Used by the routine at #R$B5CE.
D $B729 Similar to drop_item_tail_interior.
R $B729 I:HL Pointer to visible character.
N $B729 Set vischar.iso_pos.x to ($200 - saved_pos_x + saved_pos_y) * 2
@ $B729 label=calc_vischar_iso_pos_from_state
C $B729,1 Preserve vischar pointer
C $B72A,4 Point #REGde at vischar.iso_pos.x (note shortcut - no rollover into high byte)
C $B72E,7 #REGhl = saved_pos_y + $200
C $B735,4 Fetch saved_pos_x
C $B739,1 Clear the carry flag
C $B73A,2 #REGhl -= saved_pos_x
C $B73C,1 Double the result
C $B73D,1 Restore vischar pointer
C $B73E,4 Store result in vischar.iso_pos.x
N $B742 Set vischar.iso_pos_y = $800 - saved_pos_x - saved_pos_y - saved_height
C $B742,1 Preserve vischar pointer
C $B743,3 #REGhl = $800
C $B746,1 Clear the carry flag
C $B747,2 #REGhl -= saved_pos_x
C $B749,4 Fetch saved_height
C $B74D,2 #REGhl -= saved_height
C $B74F,4 Fetch saved_pos_y
C $B753,2 #REGhl -= saved_pos_y
C $B755,1 Restore vischar pointer
C $B756,3 Store result in vischar.iso_pos.y
C $B759,1 Return
;
c $B75A Reset the game.
D $B75A Used by the routines at #R$9DE5, #R$A51C and #R$F163.
N $B75A Cause discovery of all items.
@ $B75A label=reset_game
C $B75A,3 Set #REGb for 16 iterations (item__LIMIT) and set #REGc (item index) to zero
N $B75D Start loop (once per item)
C $B75D,1 Preserve the iteration counter and item index over the next call
C $B75E,3 Cause item #REGc to be discovered
C $B761,1 Restore
C $B762,1 Increment the item index
C $B763,2 ...loop
N $B765 Reset the message queue.
C $B765,6 Reset the message queue pointer to its default of message_queue[2]
C $B76B,3 Reset all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, lock the gates, reset all beds, clear the mess halls and reset characters
C $B76E,4 Clear the hero's vischar flags
N $B772 Reset score digits, hero_in_breakfast, red_flag, automatic_player_counter, in_solitary and morale_exhausted which occupy a contiguous ten byte region.
C $B772,3 Point #REGhl at score_digits
C $B775,2 Set #REGb for ten iterations
N $B777 Start loop (once per score digit)
C $B777,1 Zero the byte
C $B778,1 Then advance to the next byte
C $B779,2 ...loop
N $B77B Reset morale.
C $B77B,2 Set morale to morale_MAX
C $B77D,3 Draw the current score to the screen
N $B780 Reset and redraw items.
C $B780,6 Set both items_held to item_NONE ($FF)
C $B786,3 Draw held items
N $B789 Reset the hero's sprite.
C $B789,6 Set vischar.mi.sprite to the prisoner sprite set
C $B78F,5 Set the global current room index to room_2_HUT2LEFT
N $B794 Put the hero to bed.
C $B794,3 The hero sleeps
C $B797,3 The hero enters a room
C $B79A,1 Return
;
c $B79B Resets all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, locks the gates, resets all beds, clears the mess halls and resets characters.
D $B79B Used by the routines at #R$B75A and #R$CB98.
@ $B79B label=reset_map_and_characters
C $B79B,2 Set #REGb for seven iterations
@ $B79D nowarn
C $B79D,3 Point #REGhl at the second vischar
N $B7A0 Start loop (iterate over non-player characters)
C $B7A0,1 Preserve the counter
C $B7A1,1 Preserve the vischar pointer
C $B7A2,3 Reset the visible character
C $B7A5,1 Restore the vischar pointer
C $B7A6,4 Advance #REGhl to the next vischar (note shortcut)
C $B7AA,1 Restore the counter
C $B7AB,2 ...loop
C $B7AD,5 Set the game clock to seven [unsure why seven in particular]
C $B7B2,4 Clear the night-time flag
C $B7B6,3 Clear the hero's vischar flags
C $B7B9,5 Set the roomdef_50_blocked_tunnel_collapsed_tunnel object to interiorobject_COLLAPSED_TUNNEL_SW_NE
@ $B7C0 nowarn
C $B7BE,5 Set the blocked tunnel boundary
N $B7C3 Lock the gates and doors.
C $B7C3,3 Point #REGhl at locked_doors[0]
C $B7C6,2 Set #REGb for nine iterations (nine locked doors)
N $B7C8 Start loop
C $B7C8,3 Set the door_LOCKED flag Advance #REGhl to the next locked door
C $B7CB,2 ...loop
N $B7CD Reset all beds.
C $B7CD,2 Set #REGb for six iterations (six beds)
C $B7CF,2 Preload #REGa with interiorobject_OCCUPIED_BED
C $B7D1,3 Point #REGhl at beds[0]
N $B7D4 Start loop
C $B7D4,4 Load the address of the bed object
C $B7D8,1 Set the bed object to interiorobject_OCCUPIED_BED
C $B7D9,2 ...loop
N $B7DB Clear the mess halls.
C $B7DB,2 Preload #REGa with interiorobject_EMPTY_BENCH
C $B7DD,3 Set to empty roomdef_23_breakfast_bench_A
C $B7E0,3 Set to empty roomdef_23_breakfast_bench_B
C $B7E3,3 Set to empty roomdef_23_breakfast_bench_C
C $B7E6,3 Set to empty roomdef_25_breakfast_bench_D
C $B7E9,3 Set to empty roomdef_25_breakfast_bench_E
C $B7EC,3 Set to empty roomdef_25_breakfast_bench_F
C $B7EF,3 Set to empty roomdef_25_breakfast_bench_G
N $B7F2 Reset characters 12..15 (guards) and 20..25 (prisoners).
C $B7F2,3 Point #REGde at character_structs[12].room
C $B7F5,2 Set #REGc for ten iterations
@ $B7F7 nowarn
C $B7F7,3 Point #REGhl at character_reset_data[0]
N $B7FA Start loop
C $B7FA,2 Set #REGb for three iterations
C $B7FC,4 Copy a byte and advance
C $B800,2 ...loop
N $B802 #REGde now points to the height
C $B802,1 Swap
N $B803 Bug: This is reset to 18 here but the initial value is 24.
C $B803,3 Set height to 18 and advance
C $B806,3 Set route index to zero (halt)
C $B809,2 Advance to the next character struct
C $B80B,1 Swap
C $B80C,1 Get our loop counter
C $B80D,2 Do seven iterations remain?
C $B80F,2 Jump if not
C $B811,3 Otherwise point #REGde at character_structs[20].room
C $B814,4 ...loop
C $B818,1 Return
N $B819 Reset data for character_structs.
N $B819 struct { byte room; byte x; byte y; }; // partial of character_struct
@ $B819 label=character_reset_data
B $B819,3,3 (room_3_HUT2RIGHT, 40,60) for character 12
B $B81C,3,3 (room_3_HUT2RIGHT, 36,48) for character 13
B $B81F,3,3 (room_5_HUT3RIGHT, 40,60) for character 14
B $B822,3,3 (room_5_HUT3RIGHT, 36,34) for character 15
B $B825,3,3 (room_NONE,        52,60) for character 20
B $B828,3,3 (room_NONE,        52,44) for character 21
B $B82B,3,3 (room_NONE,        52,28) for character 22
B $B82E,3,3 (room_NONE,        52,60) for character 23
B $B831,3,3 (room_NONE,        52,44) for character 24
B $B834,3,3 (room_NONE,        52,28) for character 25
;
g $B837 render_mask_buffer stuff.
@ $B837 label=mask_left_skip
@ $B838 label=mask_top_skip
@ $B839 label=mask_run_height
@ $B83A label=mask_run_width
B $B837,4,1
;
c $B83B Check the mask buffer to see if the hero is hiding behind something.
D $B83B Used by the routine at #R$B866.
R $B83B I:IY Pointer to visible character.
@ $B83B label=searchlight_mask_test
C $B83B,3 Copy the current visible character pointer into #REGhl
C $B83E,1 Extract the visible character's offset
C $B83F,1 Is it zero?
C $B840,1 Return if not - skip non-hero characters
N $B841 Start testing at approximately the middle of the character.
C $B841,3 Point #REGhl at mask_buffer ($8100) + $31
N $B844 Bug: This does a fused load of #REGbc, but doesn't use #REGc after. It's probably a leftover stride constant.
C $B844,3 Set #REGb for eight iterations
N $B847 Start loop
C $B847,1 Preload #REGa with zero
C $B848,1 Is the mask byte zero?
C $B849,2 Jump to still_in_searchlight if not
C $B84B,4 Advance #REGhl to the next row (note cheap increment due to alignment)
C $B84F,2 ...loop
N $B851 Otherwise the hero has escaped the searchlight, so decrement the counter.
C $B851,3 Point #REGhl at searchlight_state
C $B854,1 Decrement it
C $B855,3 Is it searchlight_STATE_SEARCHING?
C $B858,1 Return if not
C $B859,3 Choose game window attributes
C $B85C,3 Set game window attributes
C $B85F,1 Return
@ $B860 label=still_in_searchlight
C $B860,5 Set searchlight_state to searchlight_STATE_CAUGHT
C $B865,1 Return
;
c $B866 Plot vischars and items in order.
D $B866 Used by the routines at #R$6939 and #R$9D7B.
N $B866 Start (infinite) loop
N $B866 This can return a vischar OR an itemstruct, but not both.
@ $B866 label=plot_sprites
C $B866,3 Finds the next vischar or item to draw
C $B869,1 Return if nothing remains
C $B86A,2 Was an item returned?
C $B86C,2 Jump to item handling if so
@ $B86E label=plot_vischar
C $B86E,3 Set up vischar plotting
C $B871,2 If not visible (Z clear) ...loop
C $B873,3 Render the mask buffer
C $B876,3 Fetch the searchlight state
C $B879,2 Is it searchlight_STATE_SEARCHING? ($FF)
C $B87B,3 If not: check the mask buffer to see if the hero is hiding behind something
C $B87E,3 How wide is the vischar? (3 => 16 wide, 4 => 24 wide)
C $B881,2 16 wide?
C $B883,2 Jump if so
@ $B885 label=plot_24_wide
C $B885,3 Call the sprite plotter for 24-pixel-wide sprites
C $B888,2 ...loop
N $B88A It's odd to test for Z here since it's always set.
@ $B88A label=plot_16_wide
C $B88A,3 Call (if Z set) the sprite plotter for 16-pixel-wide sprites
C $B88D,2 ...loop
@ $B88F label=plot_item
C $B88F,3 Set up item plotting
C $B892,2 If not visible (Z clear) ...loop
C $B894,3 Render the mask buffer
C $B897,3 Call the sprite plotter for 16-pixel-wide sprites
C $B89A,2 ...loop
;
c $B89C Finds the next vischar or item to draw.
D $B89C Used by the routine at #R$B866.
R $B89C O:F Z set if a valid vischar or item was returned.
R $B89C O:A Returns (vischars_LENGTH - iters) if vischar, or ((item__LIMIT - iters) | (1 << 6)) if itemstruct.
R $B89C O:IY The vischar or itemstruct to plot.
R $B89C O:HL The vischar or itemstruct to plot.
@ $B89C label=get_next_drawable
C $B89C,5 #REGbc and #REGde are previous_x and previous_y. Zero them both
C $B8A1,2 Load #REGa with a 'nothing found' marker ($FF)
C $B8A3,1 Bank it
C $B8A4,1 Bank the previous_x/y registers
N $B8A5 Note that we maintain a previous_height but it's never usefully used.
C $B8A5,3 Initialise the previous_height to zero
C $B8A8,3 Set #REGb for eight iterations and set #REGc for a 32 byte stride simultaneously
C $B8AB,3 Point #REGhl at vischar 0's counter_and_flags
N $B8AE Find the rearmost vischar that is flagged for drawing.
N $B8AE Start loop
@ $B8AE label=lvoi_loop
C $B8AE,2 Is counter_and_flags' vischar_DRAWABLE flag set?
C $B8B0,2 Jump to next iteration if not
C $B8B2,1 Preserve the vischar pointer
C $B8B3,1 Preserve the loop counter and stride
N $B8B4 Check the X axis
C $B8B4,4 Point #REGhl at vischar.mi.pos.x
C $B8B8,3 Load vischar.mi.pos.x into #REGbc
C $B8BB,4 Add 4
C $B8BF,1 Stack it
C $B8C0,1 Switch banks to get spare #REGhl
C $B8C1,1 #REGhl = vischar.mi.pos.x + 4
C $B8C2,2 Subtract previous_x
C $B8C4,1 Bank
C $B8C5,2 Jump if (vischar.mi.pos.x + 4) < previous_x?
N $B8C7 Check the Y axis
C $B8C7,4 Load vischar.mi.pos.y into #REGbc
C $B8CB,4 Add 4
C $B8CF,1 Stack it
C $B8D0,1 Switch banks to get spare #REGhl
C $B8D1,1 #REGhl = vischar.mi.pos.y + 4
C $B8D2,2 Subtract previous_y
C $B8D4,1 Bank
C $B8D5,2 Jump if (vischar.mi.pos.y + 4) < previous_y?
C $B8D7,1 Point #REGhl at vischar.mi.pos.height
N $B8D8 We compute a vischar index here but the outer code never usefully uses it.
C $B8D8,2 Fetch the loop counter from the stack
C $B8DA,3 Compute the vischar index (8 - #REGb)
C $B8DD,1 Bank it for return value
C $B8DE,3 previous_height = vischar.mi.pos.height
C $B8E1,1 Preserve the vischar pointer
C $B8E2,1 Bank
C $B8E3,1 Restore vischar pointer to the other bank
C $B8E4,2 Point #REGhl at vischar.mi.pos.y
C $B8E6,4 previous_y = vischar.mi.pos.y
C $B8EA,3 previous_x = vischar.mi.pos.x
C $B8ED,4 Point #REGhl at vischar
C $B8F1,3 Set #REGiy to #REGhl
@ $B8F5 label=lvoi_pop_next
C $B8F5,1 Restore loop counter and stride
C $B8F6,1 Restore vischar pointer
@ $B8F7 label=lvoi_next
C $B8F7,3 Advance to the next vischar
C $B8FA,2 ...loop
C $B8FC,3 Iterate over all item_structs looking for nearby items
C $B8FF,1 Get the old #REGa back
N $B900 If the topmost bit of #REGa' remains set from its initialisation at #R$B8A1, then no vischar was found. It's preserved by the call to get_next_drawable_itemstruct.
C $B900,2 Does bit 7 remain set from initialisation?
C $B902,1 Return with Z clear if so: nothing was found
N $B903 Otherwise we've found a vischar
C $B903,3 Get vischar in #REGhl
C $B906,2 Is item_FOUND set? ($40)
C $B908,2 Jump if so
C $B90A,4 Clear the vischar.counter_and_flags vischar_DRAWABLE flag
C $B90E,1 Return with Z set
@ $B90F label=lvoi_item_found
C $B90F,1 Point #REGhl at itemstruct.room_and_flags
C $B910,2 Clear itemstruct_ROOM_FLAG_NEARBY_6
C $B912,2 Test the bit we've just cleared (odd!) - sets Z
C $B914,1 Point #REGhl back at the base of the itemstruct. (Note that DEC HL doesn't alter the Z flag)
C $B915,1 Return with Z set
;
c $B916 Render the mask buffer.
D $B916 The game uses a series of RLE encoded masks to characters to cut away pixels belonging to foreground objects. This ensures that characters aren't drawn atop of walls, huts and fences. This routine works out which masks intersect with the current player position then overlays them into the mask buffer at $8100.
D $B916 At 32x40 pixels the mask buffer is small: sized to fit a single character.
D $B916 Used by the routine at #R$B866.
N $B916 Set all the bits in the mask buffer at $8100..$819F. A clear bit in this buffer means transparent; a set bit means opaque.
@ $B916 label=render_mask_buffer
@ $B916 nowarn
C $B916,3 Point #REGhl at the mask buffer
C $B919,2 Set its first byte to $FF
@ $B91B nowarn
C $B91B,8 Do a rolling fill: copy the first byte to the second and so on until the buffer is filled
C $B923,3 Get the global current room index
C $B926,1 Are we outdoors?
C $B927,2 Jump if so
N $B929 We're indoors - use the interior mask structures.
@ $B929 label=rmb_indoors
C $B929,3 Point #REGhl at interior_mask_data_count
C $B92C,1 Fetch the count of interior masks
C $B92D,1 Is the count zero?
C $B92E,1 Return if so - there are no masks to render
C $B92F,1 #REGb is now our outermost loop counter
C $B930,5 Point #REGhl at interior_mask_data[0] + 2 bytes (mask.bounds.x1)
N $B935 We're outdoors - use the exterior mask structures.
N $B935 Bug: The mask count of 59 here doesn't match the length of exterior_mask_data[] which is only 58 entries long.
@ $B935 label=rmb_outdoors
C $B935,2 Set #REGb for 59 iterations
C $B937,3 Point #REGhl at exterior_mask_data[0] + 2 bytes (mask.bounds.x1)
N $B93A Fill the mask buffer with the union of all matching masks.
N $B93A Skip any masks which don't overlap the character. 'mask.bounds' is a bounding on the map image (in isometric projected map space). 'mask.pos' is a map coordinate (in map space). We use these to cull those masks which don't intersect with the character being rendered and those which are behind the character on the map.
N $B93A Start loop
@ $B93A label=rmb_per_mask_loop
C $B93A,1 Preserve the mask loop counter
C $B93B,1 Preserve the mask data pointer
N $B93C X axis part.
C $B93C,4 Compute iso_pos_x - 1
N $B940 Reject if the vischar's left edge is beyond the mask's right edge.
C $B940,1 Is (iso_pos_x - 1) >= mask.bounds.x1?
C $B941,3 Jump if so (process the next mask)
N $B944 Reject if the vischar's right edge is beyond the mask's left edge.
C $B944,2 Compute (iso_pos_x - 1) + 4
C $B946,1 Point #REGhl at mask.bounds.x0
C $B947,1 Is (iso_pos_x - 1) + 4 < mask.bounds.x0?
C $B948,3 Jump if so (process the next mask)
N $B94B Y axis part.
C $B94B,3 Point #REGhl at mask.bounds.y1
C $B94E,4 Compute iso_pos_y - 1
N $B952 Reject if the vischar's top edge is beyond the mask's bottom edge.
C $B952,1 Is (iso_pos_y - 1) >= mask.bounds.y1?
C $B953,3 Jump if so (process the next mask)
N $B956 Reject if the vischar's bottom edge is beyond the mask's top edge.
C $B956,2 Compute (iso_pos_y - 1) + 5
C $B958,1 Point #REGhl at mask.bounds.y0
C $B959,1 Is (iso_pos_y - 1) + 5 < mask.bounds.y0?
C $B95A,3 Jump if so (process the next mask)
N $B95D Skip masks which the character is in front of. A character is in front of a mask when either of its coordinates are less than mask.pos.
N $B95D tinypos_stash contains the vischar's mi.pos scaled as required.
N $B95D Reject if the character's X coordinate is not beyond mask.pos.x.
C $B95D,2 Advance #REGhl to mask.pos.x
C $B95F,3 Fetch tinypos_stash_x
C $B962,1 Is tinypos_stash_x <= mask.pos.x?
C $B963,3 Jump if equal
C $B966,3 Or jump if less than
N $B969 Reject if the character's Y coordinate is not beyond mask.pos.y.
C $B969,1 Advance #REGhl to mask.pos.y
C $B96A,3 Fetch tinypos_stash_y
C $B96D,1 Is tinypos_stash_y < mask.pos.y?
C $B96E,3 Jump if so
N $B971 Reject if the character's height is beyond mask.pos.height.
C $B971,1 Advance #REGhl to mask.pos.height
C $B972,3 Fetch tinypos_stash_height
C $B975,4 If tinypos_stash_height is non-zero: add one
C $B979,1 Is tinypos_stash_height >= mask.pos.height?
C $B97A,3 Jump if so (process the next mask)
C $B97D,7 Step #REGhl back to mask.bounds.x0
N $B984 The mask is valid: now calculate the clipped dimensions.
N $B984 X axis part.
C $B984,3 Fetch iso_pos_x
C $B987,1 Copy it to #REGc for use later
C $B988,1 Is iso_pos_x >= mask.bounds.x0?
C $B989,3 Jump if so
N $B98C If we arrive here then mask.bounds.x0 is to the left of iso_pos_x. This means that the mask starts beyond the left edge of our render buffer.
N $B98C Set mask_left_skip to <left hand skip> and mask_run_width to <maximum width???>.
C $B98C,4 Set left hand skip to (iso_pos_x - mask.bounds.x0)
C $B990,1 Advance #REGhl to mask.bounds.x1
C $B991,2 Set run width to (mask.bounds.x1 - iso_pos_x)
C $B993,7 The run width must not exceed 4 (byte width of the render buffer)
C $B99A,3 Store run width (how much of the mask to draw)
C $B99D,2 (else)
N $B99F If we arrive here then mask.bounds.x0 is to the right of iso_pos_x.
N $B99F Set mask_left_skip to zero and mask_run_width to <maximum width???>.
C $B99F,1 Fetch mask.bounds.x0
C $B9A0,4 Set left hand skip to zero
C $B9A4,7 Calculate maximum remaining space: (iso_pos_x + 4 - mask.bounds.x0)
C $B9AB,1 Advance #REGhl to mask.bounds.x1
C $B9AC,3 Calculate total mask width: (mask.bounds.x1 - mask.bounds.x0) + 1
C $B9AF,4 Choose the minimum of the two possible run widths
C $B9B3,3 Store mask_run_width
N $B9B6 Y axis part.
C $B9B7,3 Fetch iso_pos_y
C $B9BA,1 Copy it to #REGc for use later
C $B9BB,1 Is iso_pos_y >= mask.bounds.y0?
C $B9BC,3 Jump if so
N $B9BF If we arrive here then mask.bounds.y0 is above iso_pos_y. This means that the mask starts beyond the top edge of our render buffer.
N $B9BF Set mask_top_skip to <top skip> and mask_run_height to <maximum height???>.
C $B9BF,4 Set top skip to (iso_pos_y - mask.bounds.y0)
C $B9C3,1 Advance #REGhl to mask.bounds.y1
C $B9C4,2 Set run height to (mask.bounds.y1 - iso_pos_y)
C $B9C6,7 The run height must not exceed 5 (UDG height of the render buffer)
C $B9CD,3 Store run height (how much of the mask to draw)
C $B9D0,2 (else)
N $B9D2 If we arrive here then mask.bounds.y0 is below iso_pos_y.
N $B9D2 Set mask_top_skip to zero and mask_run_height to <maximum height???>.
C $B9D2,1 Fetch mask.bounds.y0
C $B9D3,4 Set top skip to zero
C $B9D7,7 Calculate maximum remaining space: (iso_pos_y + 5 - mask.bounds.y0)
C $B9DE,1 Advance #REGhl to mask.bounds.y1
C $B9DF,3 Calculate total mask height: (mask.bounds.y1 - mask.bounds.y0) + 1
C $B9E2,4 Choose the minimum of the two possible run heights
C $B9E6,3 Store mask_run_height
N $B9E9 Calculate the initial mask buffer pointer.
C $B9E9,1 Step #REGhl back to mask.bounds.y0
C $B9EA,3 Initialise (x,y) vars to zero
N $B9ED When the mask has a top or left hand gap, calculate that.
C $B9ED,13 If mask_top_skip is zero, calculate buf_top_skip = (mask.bounds.y0 - iso_pos_y)
C $B9FA,2 Step back to mask.bounds.x0
C $B9FC,13 If mask_left_skip is zero, calculate buf_left_skip = (mask.bounds.x0 - iso_pos_x)
C $BA09,1 Step back to mask.index
C $BA0A,1 Load it
C $BA0B,1 Bank it
N $BA0C buf_top_skip is in #REGc. buf_left_skip is in #REGb. The multiplier 32 is MASK_BUFFER_ROWBYTES.
C $BA0C,7 Calculate #REGa = (buf_top_skip * 32 + buf_left_skip)
@ $BA13 nowarn
C $BA13,5 Add #REGa to mask_buffer to get the mask buffer pointer
C $BA18,3 Save the mask buffer pointer
C $BA1B,1 Unbank index
C $BA1C,11 Point #REGde at mask_pointers[index]
C $BA27,3 Load (#REGl,#REGh) with mask_run_height,mask_run_width
C $BA2A,4 Self modify clip height loop
C $BA2E,4 Self modify clip width loop
C $BA32,5 Self modify mask row skip = (mask width) - mask_run_width
C $BA37,6 Self modify buffer row skip = MASK_BUFFER_ROWBYTES - mask_run_width
N $BA3D Skip the initial clipped mask bytes. The masks are RLE compressed so we can't jump directly to the first byte we need.
N $BA3D First, calculate the total number of mask tiles to skip.
C $BA3D,1 Preserve mask data pointer
C $BA3E,2 Fetch the mask's width
C $BA40,3 Fetch mask_top_skip
C $BA43,3 Multiply mask_top_skip by mask_width. Result is returned in #REGhl. Note: #REGd and #REGb are zeroed
C $BA46,4 Fetch mask_left_skip
C $BA4A,1 Add mask_left_skip to #REGhl
C $BA4B,1 Restore mask data pointer
C $BA4C,1 + 1 [Explain]
N $BA4D Next, loop until we've stepped over that number of mask tiles.
N $BA4D Start loop
@ $BA4D label=rmb_more_to_skip
C $BA4D,1 Read a byte. It could be a repeat count or a tile index
C $BA4E,1 Is the MASK_RUN_FLAG set?
C $BA4F,3 Jump if clear: it's a tile index (JP P => positive)
C $BA52,2 Otherwise mask it off, giving the repeat count
C $BA54,1 Advance the mask data pointer (over the count)
C $BA55,3 Decrease mask_skip by repeat count (#REGb is zeroed by #R$BACD call above)
C $BA58,2 Jump if it went negative
C $BA5A,1 Otherwise advance the mask data pointer (over the value) (doesn't affect flags)
C $BA5B,2 ...loop while mask_skip > 0
C $BA5D,1 Otherwise mask_skip must be zero. Zero the counter
C $BA5E,2 Jump to rmb_start_drawing
@ $BA60 label=rmb_skipping_index
C $BA60,1 Advance the mask data pointer
C $BA61,1 Decrement mask_skip
C $BA62,5 ...loop while mask_skip > 0
C $BA67,2 Jump to rmb_start_drawing
@ $BA69 label=rmb_skip_went_negative
C $BA69,1 How far did we overshoot?
C $BA6A,2 Negate it to create a positive mask emit(?) count
N $BA6C #REGa = Count of blocks to emit. #REGde = Points to a value (if -ve case) .. but the upcoming code expects a flag byte...
@ $BA6C label=rmb_start_drawing
C $BA6C,3 Get the mask buffer pointer
C $BA6F,2 Set #REGc for (self modified height) iterations
N $BA71 Start loop
C $BA71,2 Set #REGb for (self modified width) iterations
N $BA73 Start loop
N $BA73 Commentary: The banking of #REGa is hard to follow here. It's difficult to see if this section is entered with a skip value whether it will be handled correctly.
C $BA73,1 Bank the <repeat length>
C $BA74,1 Read a byte. It could be a repeat count or a tile index
C $BA75,1 Is the MASK_RUN_FLAG set?
C $BA76,3 Jump if clear: it's a tile index (JP P => positive)
C $BA79,2 Otherwise mask it off, giving the repeat count
C $BA7B,1 Bank the repeat count; unbank the <repeat length> REPLACING IT?
C $BA7C,1 Advance the mask data pointer
C $BA7D,1 Read the next byte (a tile)
N $BA7E Shortcut tile 0 which is blank.
C $BA7E,1 Is it tile zero?
C $BA7F,3 Call mask_against_tile if not
C $BA82,1 Advance mask buffer pointer (a tile was written)
C $BA83,1 Unbank the repeat count OR <repeat length>  CONFUSING
N $BA84 Advance the mask pointer when the repeat count reaches zero.
C $BA84,1 Is it zero?
C $BA85,2 Jump if so
C $BA87,1 Otherwise decrement the repeat count
C $BA88,2 Jump if it hit zero
C $BA8A,1 Otherwise undo the next instruction
C $BA8B,1 Advance the mask data pointer
C $BA8C,2 ...loop (width)
C $BA8E,1 Preserve the loop counter (#REGb will be zero here, #REGc = y)
C $BA8F,2 Set #REGb for (self modified, right hand skip) iterations
C $BA91,1 Bank the repeat count while we test #REGb
C $BA92,2 Is the right hand skip zero?
C $BA94,3 Jump if so (process next mask)
C $BA97,1 Unbank the repeat count
C $BA98,1 Is it zero?
C $BA99,2 Jump if not: (CHECK) must be continuing with a nonzero repeat count
N $BA9B Start loop
@ $BA9B label=rmb_trailskip_more_to_skip
C $BA9B,1 Read a byte. It could be a repeat count or a tile index
C $BA9C,1 Is the MASK_RUN_FLAG set?
C $BA9D,3 Jump if clear: it's a tile index (JP P => positive)
N $BAA0 It's a repeat.
C $BAA0,2 Otherwise mask it off, giving the repeat count
C $BAA2,1 Advance the mask data pointer
N $BAA3 (resume point)
@ $BAA3 label=rmb_trailskip_dive_in
C $BAA3,4 right_skip = #REGa = (right_skip - #REGa)
C $BAA7,2 Jump if it went negative
C $BAA9,1 Advance the mask data pointer (doesn't affect flags)
C $BAAA,2 if (right_skip > 0) goto START OF LOOP
C $BAAC,1 bank // could jump $BAB8 instead
C $BAAD,2 Otherwise right_skip must be zero, jump to rmb_next_line
@ $BAAF label=rmb_something
C $BAAF,1 Advance the mask data pointer
C $BAB0,2 ...loop
C $BAB2,1 Reset counter (WHAT IS IT?)
C $BAB3,1 bank // could jump $BAB8 instead
C $BAB4,2 Jump to rmb_next_line
@ $BAB6 label=rmb_trailskip_negative
C $BAB6,2 Negate it to create a positive mask emit(?) count
C $BAB8,1 bank
@ $BAB9 label=rmb_next_line
C $BAB9,4 Advance #REGhl by (self modified skip)
C $BABD,1 Unbank the <repeat length> (re-banked when loop continues)
C $BABE,1 Restore the height counter
C $BABF,4 ...loop (height)
@ $BAC3 label=rmb_pop_next
C $BAC3,1 Restore the mask data pointer
C $BAC4,1 Restore the mask loop counter
C $BAC5,4 Advance #REGhl to the next mask_t
C $BAC9,4 ...loop
E $B916 Bug: The RET instruction is missing from the end of the routine. If unfixed the routine will harmlessly fall through into multiply.
;
c $BACD Multiply
D $BACD Multiplies the two 8-bit values in #REGa and #REGe returning a 16-bit result in #REGhl.
D $BACD Used by the routine at #R$B916.
R $BACD I:A Left hand value.
R $BACD I:E Right hand value.
R $BACD O:D Zero.
R $BACD O:HL Multiplied result.
@ $BACD label=multiply
C $BACD,2 Set #REGb for eight iterations (width of multiplicands)
C $BACF,3 Set our accumulator to zero
C $BAD2,1 Zero #REGd so that #REGde holds the full 16-bit right hand value
N $BAD3 Start loop
C $BAD3,1 Double our accumulator (shifting it left)
C $BAD4,1 Shift #REGa left. The shifted-out top bit becomes the carry flag
C $BAD5,3 Jump if no carry
C $BAD8,1 Otherwise #REGhl += #REGde
C $BAD9,2 ...loop
C $BADB,1 Return
;
c $BADC AND a tile in the mask buffer against the specified mask tile.
D $BADC Used by the routine at #R$B916.
R $BADC I:A Mask tile index.
R $BADC I:HL Pointer to a tile in the mask buffer.
@ $BADC label=mask_against_tile
C $BADC,1 Save tile pointer
C $BADD,1 Switch register banks during the routine
N $BADE Point #REGhl at mask_tiles[#REGa]
C $BADE,3 Move the mask tile index into #REGhl
C $BAE1,3 Multiply it by 8
C $BAE4,4 Add base of mask_tiles array
C $BAE8,1 Retrieve tile pointer
C $BAE9,2 Set #REGb for 8 iterations
N $BAEB Start loop
@ $BAEB label=mat_loop
C $BAEB,1 Fetch a byte of mask buffer
C $BAEC,1 Mask it against a byte of mask tile
C $BAED,1 Overwrite the input byte with result
C $BAEE,1 Advance the mask tile pointer by a row
C $BAEF,4 Advance the mask buffer pointer by a row
C $BAF3,2 ...loop
C $BAF5,1 Switch register banks back
C $BAF6,1 Return
;
c $BAF7 Clip the given vischar's dimensions to the game window.
D $BAF7 Used by the routines at #R$BB98 and #R$E420.
R $BAF7 I:IY Pointer to visible character.
R $BAF7 O:A 0/255 => vischar visible/not visible.
R $BAF7 O:B Lefthand skip (bytes).
R $BAF7 O:C Clipped width (bytes).
R $BAF7 O:D Top skip (rows).
R $BAF7 O:E Clipped height (rows).
N $BAF7 To determine visibility and sort out clipping there are five cases to consider per axis: (A) the vischar is completely off the left/top of window, (B) the vischar is clipped on its left/top, (C) the vischar is entirely visible, (D) the vischar is clipped on its right/bottom, and (E) the vischar is completely off the right/bottom of window.
N $BAF7 Note that no vischar will ever be wider than the window so we never need to consider if clipping will occur on both sides.
N $BAF7 First handle the horizontal cases.
@ $BAF7 label=vischar_visible
C $BAF7,3 Point #REGhl at iso_pos_x (vischar left edge)
N $BAFA Calculate the right edge of the window in map space.
C $BAFA,3 Load map X position
C $BAFD,2 Add 24 (number of window columns)
N $BAFF Subtract iso_pos_x giving the distance between the right edge of the window and the current vischar's left edge (in bytes).
C $BAFF,1 available_right = (map_position.x + 24) - vischar_left_edge
N $BB00 Check for case (E): Vischar left edge beyond the window's right edge.
C $BB00,3 Jump to exit if zero (vischar left edge at right edge)
C $BB03,3 Jump to exit if negative (vischar left edge beyond right edge)
N $BB06 Check for case (D): Vischar extends outside the window.
C $BB06,3 Compare result to (sprite width bytes + 1)
C $BB09,3 Jump if it fits
N $BB0C Vischar's right edge is outside the window: clip its width.
C $BB0C,2 No lefthand skip
C $BB0E,1 Clipped width = available_right
C $BB0F,2 Jump to height part
N $BB11 Calculate the right edge of the vischar.
@ $BB11 label=vv_not_clipped_on_right_edge
C $BB11,1 Load iso_pos_x (vischar left edge)
C $BB12,3 vischar_right_edge = iso_pos_x + (sprite width bytes + 1)
N $BB15 Subtract the map position's X giving the distance between the current vischar's right edge and the left edge of the window (in bytes).
C $BB15,3 Load map X position
C $BB18,1 available_left = vischar_right_edge - map_position.x
N $BB19 Check for case (A): Vischar's right edge is beyond the window's left edge.
C $BB19,3 Jump to exit if zero (vischar right edge at left edge)
C $BB1C,3 Jump to exit if negative (vischar right edge beyond left edge)
N $BB1F Check for case (B): Vischar's left edge is outside the window and its right edge is inside the window.
C $BB1F,3 Compare result to (sprite width bytes + 1)
C $BB22,3 Jump if it fits
N $BB25 Vischar's left edge is outside the window: move the lefthand skip into #REGb and the clipped width into #REGc.
C $BB25,1 Clipped width = available_left
C $BB26,6 Lefthand skip = (sprite width bytes + 1) - available_left
C $BB2C,2 (else)
N $BB2E Case (C): No clipping required.
@ $BB2E label=vv_not_clipped
C $BB2E,2 No lefthand skip
C $BB30,3 Clipped width = (sprite width bytes + 1)
N $BB33 Handle vertical cases.
N $BB33 Note: This uses vischar.iso_pos, not state.iso_pos as above.
N $BB33 Calculate the bottom edge of the window in map space.
@ $BB33 label=vv_height
C $BB33,5 Load the map position's Y and add 17 (number of window rows)
C $BB38,6 Multiply it by 8
N $BB3E Subtract vischar's Y giving the distance between the bottom edge of the window and the current vischar's top (in rows).
C $BB3E,6 Load vischar.iso_pos.y (vischar top edge)
C $BB44,1 Clear carry flag
C $BB45,2 available_bottom = window_bottom_edge * 8 - vischar->iso_pos.y
N $BB47 Check for case (E): Vischar top edge beyond the window's bottom edge.
C $BB47,3 Jump to exit if zero (vischar top edge at bottom edge)
C $BB4A,3 Jump to exit if negative (vischar top edge beyond bottom edge)
C $BB4D,5 Jump to exit if >= 256 (way out of range)
N $BB52 Check for case (D): Vischar extends outside the window.
C $BB52,1 #REGa = available_bottom
C $BB53,3 Compare result to vischar.height
C $BB56,3 Jump if it fits (available_top >= vischar.height)
N $BB59 Vischar's bottom edge is outside the window: clip its height.
C $BB59,1 Clipped height = available_bottom
C $BB5A,2 No top skip
C $BB5C,2 Jump to exit
N $BB5E Calculate the bottom edge of the vischar.
@ $BB5E label=vv_not_clipped_on_top_edge
C $BB5E,5 Load sprite height and widen
C $BB63,1 vischar_bottom_edge = vischar.iso_pos.y + (sprite height)
N $BB64 Subtract map position's Y (scaled) giving the distance between the current vischar's bottom edge and the top edge of the window (in rows).
C $BB64,1 Bank
C $BB65,6 Load the map position's Y and widen
C $BB6B,3 Multiply by 8
C $BB6E,1 Unbank
C $BB6F,1 Clear the carry flag
C $BB70,2 available_top = vischar_bottom_edge - map_pos_y * 8
N $BB72 Check for case (A): Vischar's bottom edge is beyond the window's top edge.
C $BB72,3 Jump to exit if negative (vischar bottom edge beyond top edge)
C $BB75,3 Jump to exit if zero (vischar bottom edge at top edge)
C $BB78,5 Jump to exit if >= 256 (way out of range)
N $BB7D Check for case (B): Vischar's top edge is outside the window and its bottom edge is inside the window.
C $BB7D,1 #REGa = available_top
C $BB7E,3 Compare result to vischar.height
C $BB81,3 Jump if it fits (available_top >= vischar.height)
N $BB84 Vischar's top edge is outside the window: move the top skip into #REGd and the clipped height into #REGe.
C $BB84,1 Clipped height = available_top
C $BB85,6 Top skip = vischar.height - available_top
C $BB8B,2 (else)
N $BB8D Case (C): No clipping required.
C $BB8D,2 No top skip
C $BB8F,3 Clipped height = vischar.height
@ $BB92 label=vv_visible
C $BB92,1 Set Z (vischar is visible)
C $BB93,1 Return
@ $BB94 label=vv_not_visible
C $BB94,2 Signal invisible
C $BB96,1 Clear Z (vischar is not visible)
C $BB97,1 Return
;
c $BB98 Paint any tiles occupied by visible characters with tiles from tile_buf.
D $BB98 Used by the routine at #R$9D7B.
@ $BB98 label=restore_tiles
C $BB98,2 Set #REGb for eight iterations
C $BB9A,4 Point #REGiy at the first vischar
N $BB9E Start loop (once per vischar)
@ $BB9E label=rt_loop
C $BB9E,1 Preserve the loop counter
C $BB9F,3 Read the vischar's flags byte
C $BBA2,2 Is it vischar_FLAGS_EMPTY_SLOT? ($FF)
C $BBA4,3 Jump to the next iteration if so
N $BBA7 Get the visible character's position in screen space.
N $BBA7 Compute iso_pos_y = vischar.iso_pos.y / 8.
C $BBA7,6 Read vischar.iso_pos.y
C $BBAD,9 Shift it right by three bits
C $BBB6,3 Store low byte
N $BBB9 Compute iso_pos_x = vischar.iso_pos.x / 8.
C $BBB9,6 Read vischar.iso_pos.x
C $BBBF,9 Shift it right by three bits
C $BBC8,3 Store low byte
N $BBCB Clip.
C $BBCB,3 Clip the vischar's dimensions to the game window
C $BBCE,5 Jump to next iteration if not visible ($FF)
N $BBD3 Compute scaled clipped height = (clipped height / 8) + 2
C $BBD3,1 Copy clipped height
C $BBD4,3 Shift it right by three bits
C $BBD7,2 Mask away the rotated-out bits
C $BBD9,2 Add two
C $BBDB,1 Save the computed height
N $BBDC Commentary: It seems that the following sequence (from $BBDC to $BC01) duplicates the work done by vischar_visible. I can't see any benefit to it.
N $BBDC Compute bottom = height + iso_pos_y - map_position_y. This is the distance of the (clipped) bottom edge of the vischar from the top of the window.
C $BBDC,3 Point #REGhl at iso_pos_y
C $BBDF,1 Add iso_pos_y to height
C $BBE0,3 Point #REGhl at map_position_y
C $BBE3,1 Subtract map_position_y from the total
C $BBE4,2 Jump if bottom is < 0 (the bottom edge is beyond the top edge of screen)
N $BBE6 Bottom edge is on-screen, or off the bottom of the screen.
C $BBE6,2 Now reduce bottom by the height of the game window
C $BBE8,4 Jump over if <= 17 (bottom edge off top of screen)
N $BBEC Bottom edge is now definitely visible.
C $BBEC,1 Save new bottom
C $BBED,1 Get computed height back
C $BBEE,1 Calculate visible height = computed height - bottom
C $BBEF,3 If invisible (height < 0) goto next
C $BBF2,2 Jump if visible (height > 0)
C $BBF4,3 If invisible (height == 0) goto next
@ $BBF7 label=rt_visible
C $BBF7,1 Restore computed height
N $BBF8 Clamp the height to a maximum of five.
@ $BBF8 label=rt_clamp_height
C $BBF8,2 Compare height to 5
C $BBFA,3 Jump over if equal to 5
C $BBFD,3 Jump over if less than 5
C $BC00,2 Otherwise set it to 5
N $BC02 Self modify the loops' control instructions.
C $BC02,3 Self modify the outer loop counter (= height)
C $BC05,1 Copy (clipped) width to #REGa
C $BC06,3 Self modify the inner loop counter (= width)
C $BC09,3 Self modify the "reset x" instruction (= width)
C $BC0C,3 Compute tilebuf_skip = 24 - width (24 is window columns)
C $BC0F,3 Self modify the "tilebuf row-to-row skip" instruction
C $BC12,2 Compute windowbuf_skip = (8 * 24) - width
C $BC14,3 Self modify the "windowbuf row-to-row skip" instruction
N $BC17 Work out x,y offsets into the tile buffer.
N $BC17 X part
C $BC17,3 Point #REGhl at map_position.x
C $BC1A,1 Copy the lefthand skip into #REGa
C $BC1B,1 Is it zero?
C $BC1C,2 Set x to zero (interleaved)
C $BC1E,2 Jump if not
C $BC20,5 Compute x = iso_pos_x - map_position.x
N $BC25 Y part
C $BC25,1 Copy top skip into #REGa
C $BC26,1 Is it zero?
C $BC27,2 Set Y to zero (interleaved)
C $BC29,2 Jump if not
C $BC2B,1 Advance #REGhl to map_position.y
C $BC2C,5 Compute y = iso_pos_y - map_position.y
N $BC31 Calculate the offset into the window buffer.
C $BC31,7 #REGde = y << 7 (== y * 128)
C $BC38,4 #REGhl = y << 6 (== y * 64)
C $BC3C,1 Sum #REGde and #REGhl = y * 192 (== y * 24 * 8)
C $BC3D,4 #REGhl += x
C $BC41,3 Point #REGde at the window buffer's start address (windowbuf)
C $BC44,1 Add
C $BC45,1 Swap the buffer offset into #REGde. #REGhl is about to be overwritten
N $BC46 Calculate the offset into the tile buffer.
N $BC46 Compute pointer = #REGc * 24 + #REGa + $F0F8
C $BC46,1 Stack the x and y values
C $BC47,1 Bank
C $BC48,1 Restore into #REGhl
C $BC49,1 Unbank
C $BC4A,1 Copy x into #REGa
C $BC4B,3 #REGhl = y
C $BC4E,3 Multiply it by 8
C $BC51,2 Copy result to #REGbc
C $BC53,1 Double result
C $BC54,1 = y * 8 + y * 16
C $BC55,3 Copy x into #REGbc
C $BC58,1 = y * 24 + x
C $BC59,3 Point #REGde at the visible tiles array (tilebuf)
C $BC5C,1 = $F0F8 + y * 24 + x
C $BC5D,1 Move tilebuf pointer into #REGde
N $BC5E Loops start here.
C $BC5E,2 Set #REGc for <self modified by $BC5F> rows
N $BC60 Start loop
@ $BC60 label=rt_copy_row
C $BC60,2 Set #REGb for <self modified by $BC61> columns
N $BC62 Start loop
@ $BC62 label=rt_copy_column
C $BC62,1 Save windowbuf pointer
C $BC63,1 Read a tile from tilebuf
C $BC64,1 Bank
C $BC65,1 Restore windowbuf pointer
C $BC66,1 Save x,y
C $BC67,3 Turn a map ref into a tile set pointer (in #REGbc)
N $BC6A Copy the tile into the window buffer.
N $BC6A Compute the tile row pointer. (This is similar to #R$6B4F onwards).
C $BC6A,3 Widen the tile index into #REGhl
C $BC6D,3 Multiply by 8
C $BC70,1 Add to tileset base address
C $BC71,3 Simultaneously set #REGb for eight iterations and #REGc for a 24 byte stride
N $BC74 Start loop
@ $BC74 label=rt_copy_tile
C $BC74,2 Transfer a byte (a row) of tile across
@ $BC7B label=rt_copy_tile_nocarry
C $BC76,7 Advance the screen buffer pointer by the stride
C $BC7D,2 ...loop for each byte of the tile
N $BC7F Move to next column.
C $BC7F,1 Restore x,y
C $BC80,1 Increment x
C $BC81,1 Unbank
C $BC82,1 Advance the tilebuf pointer
C $BC83,1 Advance the windowbuf pointer
C $BC84,2 ...loop (width counter)
N $BC86 Reset x offset. Advance to next row.
C $BC86,1 Bank
C $BC87,1 Get x
C $BC88,2 Reset x to initial value <self modified by $BC89>
C $BC8A,1 Save x
C $BC8B,1 Increment y
C $BC8C,1 Unbank
C $BC8D,2 Get tilebuf row-to-row skip <self modified by $BC8E>
@ $BC93 label=rt_tilebuf_nocarry
C $BC8F,5 Increment tilebuf pointer #REGde
C $BC94,2 Get windowbuf row-to-row skip <self modified by $BC95>
@ $BC9A label=rt_windowbuf_nocarry
C $BC96,5 Increment windowbuf pointer #REGhl
C $BC9B,4 ...loop
@ $BC9F label=rt_next_vischar
C $BC9F,1 Restore loop counter
C $BCA0,3 Set #REGde to the vischar stride (32)
C $BCA3,2 Advance #REGiy to the next vischar
C $BCA5,4 ...loop
C $BCA9,1 Return
;
c $BCAA Turn a map ref into a tile set pointer.
D $BCAA Used by the routine at #R$BB98.
R $BCAA I:H X shift.
R $BCAA I:L Y shift.
R $BCAA O:A Preserved.
R $BCAA O:BC Pointer to tile set.
@ $BCAA label=select_tile_set
C $BCAA,1 Preserve #REGa during this routine
C $BCAB,3 Fetch the global current room index
C $BCAE,1 Is it room_0_OUTDOORS?
C $BCAF,2 Jump if so
@ $BCB1 label=sts_interior
C $BCB1,3 Otherwise point #REGbc at interior_tiles[0]
C $BCB4,1 Restore #REGa
C $BCB5,1 Return
N $BCB6 Convert map position to an index into map_buf: a 7x5 array of supertile indices.
N $BCB6 Compute row offset
@ $BCB6 label=sts_exterior
C $BCB6,5 Get the map position's Y component and isolate its low-order bits
C $BCBB,1 Add on the Y shift from #REGl
C $BCBC,4 Divide by two (rotate right by two then clear the rotated-out bits)
C $BCC0,5 Multiply by 7 (columns per row of supertiles)
C $BCC5,1 Save for later
N $BCC6 Compute column offset
C $BCC6,5 Get the map position's X component and isolate its low-order bits
C $BCCB,1 Add on the X shift from #REGh
C $BCCC,4 Divide by two (rotate right by two then clear the rotated-out bits)
N $BCD0 Combine offsets
C $BCD0,1 Combine the row and column offsets
C $BCD1,3 Point #REGhl at map_buf (a 7x5 cut-down copy of the main map which holds supertile indices)
C $BCD4,2 Add offset (quick version since the values can't overflow)
C $BCD6,1 Fetch the supertile index from map_buf
C $BCD7,3 Point #REGbc at exterior_tiles[0]
N $BCDA Choose the tile index for the current supertile: #TABLE(default) { =h For supertile     | =h Use tile indices } { 44 and lower         |   0..249 } { 45..138 and 204..218 | 145..400 } { 139..203             | 365..570 } TABLE#
C $BCDA,2 Is the supertile index < 45?
C $BCDC,2 Jump if so
C $BCDE,3 Point #REGbc at exterior_tiles[145]
C $BCE1,2 Is the supertile index < 139?
C $BCE3,2 Jump if so
C $BCE5,2 Is the supertile index >= 204?
C $BCE7,2 Jump if so
C $BCE9,3 Point #REGbc at exterior_tiles[145 + 220]
@ $BCEC label=sts_exit
C $BCEC,1 Restore #REGa
C $BCED,1 Return
;
b $BCEE Map super-tile refs. 54x34. Each byte represents a 32x32 tile.
D $BCEE The map, with blanks and grass replaced to show the outline more clearly:
D $BCEE _______________________________________________________________________ 5F 33 3C 58 _____________________________________________________________________________
D $BCEE _________________________________________________________________ 5F 33 34 2E 3D 45 3C 58 _______________________________________________________________________
D $BCEE _____________________________ 55 5E 31________________________ 33 34 2B 37 2D 3F 28 48 42 5B 58 _________________________________________________________________
D $BCEE _____________________________ 82 3E 30 2E 57____________ 33 34 2E 37 2A 2F 2C 41 26 47 43 53 42 3C 57 ___________________________________________________________
D $BCEE _______________________ 75 76 81 5E 31 33 3C 5E 31 33 34 2B 35 2D 36 29 .. .. .. .. 49 44 54 43 3D 45 3C 58 _____________________________________________________
D $BCEE _________________ 75 76 7C 7F 80 3E 30 39 3D 3E 30 2E 35 2A 2F 38 .. .. .. .. .. .. .. .. 41 44 46 27 48 42 5B 58 _______________________________________________
D $BCEE 75 76 7A 79 75 76 7C 7F 7E 3A 5D 40 31 3A 3F 40 31 2D 2F 29 .. .. .. .. .. .. .. .. .. .. .. .. 41 26 47 43 53 42 3C 58 _________________________________________
D $BCEE 6A 74 77 78 7B 7F 7E 3A 2F 2C 49 3B 32 2C 41 3B 32 38 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 49 44 54 43 3D 52 59 53 ___________________________________
D $BCEE 63 64 66 6F 7D 3A 2F 38 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 06 07 .. .. .. .. .. .. .. .. 41 44 46 51 5D 58 5A 53 _____________________________
D $BCEE 65 62 6C 6D 36 2C .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 08 1A .. .. .. .. .. .. .. .. .. 41 44 5C 5B 57 58 5A 53 _______________________
D $BCEE 63 64 6B 6E 71 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. .. .. .. .. .. .. 59 53 45 3C 57 58 5A ____________________
D $BCEE 61 62 5A 73 72 70 71 .. .. .. .. .. .. .. .. .. .. .. .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07 .. .. .. .. .. .. 55 58 5A 53 45 3C 57 ____________________
D $BCEE 49 3B 68    5A 73 72 70 71 .. .. 75 76 7A 79 .. .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. .. .. .. .. 4B 45 3C 58 5A 53 45 45 _________________
D $BCEE .. .. 41 56 68    5A 73 72 70 71 6A 74 84 85 7A 79 .. 0D 0C 0B 17 20 16 15 18 .. .. 02 03 04 05 09 1C 1B .. .. .. .. .. 4A 50 4C 52 5B 58 5A ____________________
D $BCEE .. .. .. .. 49 56 68 69 5A 73 72 63 86 88 74 77 78 .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. .. 06 07 49 44 4D 51 4C 52 3C 58 _________________
D $BCEE .. .. .. .. .. .. 49 67 68 69 5A 65 87 83 64 66 6F .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. 02 03 04 08 1A .. 41 44 4E 51 4C 45 3C 58 ___________
D $BCEE .. .. .. .. .. .. .. .. 41 67 68 59 CC CD 62 8A 6D .. .. .. .. .. .. .. 0D 0C 0B 17 20 16 15 18 .. .. 02 03 04 05 09 1C 1B .. .. .. 49 44 4E 28 4C 52 5B 58 _____
D $BCEE .. .. .. .. .. .. .. .. .. .. 41 89 CE CF D2 D5 6F .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. 02 03 14 05 0A 17 1E 1D .. .. .. B9 BA .. 49 26 C8 C9 4C 45 3C 58
D $BCEE .. .. .. .. .. .. .. B9 BA B1 B1 49 D0 D1 D3 D6 D8 9B 9C .. .. .. .. .. 10 11 13 18 .. .. 00 01 04 05 0A 21 22 16 1F 19 .. .. BB BC BD BE 9D 97 CA CB 4D 28 4C 45
D $BCEE .. .. .. .. .. .. BB BC BD BE AF B2 B7 93 D4 D7 D9 8E 90 9B 9C .. .. .. .. .. .. .. .. .. 0D 0C 0B 17 20 16 15 18 .. .. .. .. .. C5 C0 97 96 93 95 94 41 26 C8 C9
D $BCEE .. .. .. .. .. B1 B1 C5 C0 97 96 B3 B5 B6 '' '' 8C 8D 8B 8E 90 9B 9C .. .. .. .. .. .. .. 0E 0F 12 16 15 18 .. .. .. .. .. 9C 9D C6 C2 93 95 94 '' 99 98 97 CA CB
D $BCEE .. .. .. B1 B1 B0 AF C6 C2 93 95 B4 8B 8E 90 8F '' '' 8C 8D 8B 8E A8 AA 9C .. .. .. .. .. 10 11 13 18 .. .. .. .. .. 9C 9D 97 96 C7 C4 94 '' 99 98 97 96 93 95 94
D $BCEE .. .. B1 B0 AF 97 96 C7 C4 94 '' B8 8C 8D 8B 8E 90 8F '' '' 8C 8D A7 A6 90 9B 9C .. .. .. .. .. .. .. .. .. .. 9C 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. ..
D $BCEE .. .. B0 B2 B7 93 95 94 '' '' '' '' '' '' 8C 8D 8B 8E A8 A9 '' '' A5 A4 8B 8E 90 9B 9C .. .. B9 BA .. .. 9C 9D 97 96 93 95 94 B8 99 98 97 96 93 95 94 .. .. .. ..
D $BCEE .. .. B0 B3 B5 B6 '' '' '' '' '' '' '' '' '' '' 8C 8D A7 A6 90 8F '' '' 8C 8D 8B 8E 90 9B BB BC BD BE 9D 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. ..
D $BCEE .. .. B1 B4 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' A5 A4 8B 8E 90 8F '' '' 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' '' '' '' '' '' '' '' 8C 8D AB AC 90 8F '' '' 8C 8D 8B C1 C2 93 95 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. 8C 8D 8B 8E 90 8F '' '' '' B9 BA '' '' 99 98 97 AD AE 8B 8E 90 8F '' '' 8C C3 C4 94 '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 8F BB BC BD BE 98 97 96 93 95 94 8C 8D 8B 8E 90 8F '' '' '' 99 98 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. .. .. .. .. 8C 8D 8B 8E 90 BF C0 97 96 93 95 94 .. .. .. .. 8C 8D 8B 8E 90 A2 A3 97 96 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. .. .. .. .. .. .. 8C 8D 8B C1 C2 93 95 94 .. .. .. .. .. .. .. .. 8C 8D 8B A0 A1 93 95 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. .. .. .. .. .. .. .. .. 8C C3 C4 94 .. .. .. .. .. .. .. .. .. .. .. .. 8C 9F 9E 94 .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
D $BCEE .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .. ..
@ $BCEE label=map_tiles
B $BCEE,1836,54
;
g $C41A Pointer to bytes to output as pseudo-random data.
D $C41A Initially set to $9000. Wraps around after $90FF.
@ $C41A label=prng_pointer
W $C41A,2,2
;
c $C41C Spawn characters.
D $C41C Used by the routines at #R$6939 and #R$9D7B.
N $C41C Form a clamped map position in #REGde.
@ $C41C label=spawn_characters
C $C41C,3 Read the current map position into #REGhl
C $C41F,1 Get map_position.x
C $C420,2 Subtract 8
C $C422,2 Jump if it was >= 8
C $C424,1 Otherwise zero it
C $C425,1 #REGe is the result: map_x_clamped
C $C426,1 Get map_position.y
C $C427,2 Subtract 8
C $C429,2 Jump if it was >= 8
C $C42B,1 Otherwise zero it
C $C42C,1 #REGd is the result: map_y_clamped
N $C42D Walk all character structs.
C $C42D,3 Point #REGhl at character_structs[0] (charstr)
C $C430,2 Set #REGb for 26 iterations (26 characters)
N $C432 Start loop
@ $C432 label=sc_loop
C $C432,2 Fetch flags and test for characterstruct_FLAG_ON_SCREEN
C $C434,2 Jump if already on-screen
N $C436 Is this character in the current room?
C $C436,1 Preserve the character struct pointer
C $C437,1 Point #REGhl at charstr.room
C $C438,3 Get the global current room index
C $C43B,1 Same room?
C $C43C,2 Jump if not
C $C43E,1 Outdoors?
C $C43F,2 Jump if not
N $C441 Handle outdoors.
C $C441,1 Point #REGhl at charstr.pos.x
N $C442 Do screen Y calculation:
N $C442 y = ((256 - charstr.pos.x) - charstr.pos.y) - charstr.pos.height
N $C442 #REGa is zero here, and represents 0x100.
C $C442,1 Subtract charstr.pos.x
C $C443,1 Advance #REGhl to charstr.pos.y
C $C444,1 Subtract charstr.pos.y
C $C445,1 Advance #REGhl to charstr.pos.height
C $C446,1 Subtract charstr.pos.height
C $C447,1 Copy y to #REGc
C $C448,1 Copy map_y_clamped to #REGd
C $C449,1 Is map_y_clamped >= y?
C $C44A,2 Jump if so
C $C44C,2 Add 16 + 2 * 8 (16 => screen height, 8 => spawn zone size)
C $C44E,4 Clamp to a maximum of 255
C $C452,1 Is y > (map_y_clamped + spawn size, clamped to 255)?
C $C453,2 Jump if so
N $C455 Do screen X calculation:
N $C455 x = (64 - charstr.pos.x + charstr.pos.y) * 2
C $C455,1 Step #REGhl back to charstr.pos.y
C $C456,2 Start with x = 64
C $C458,1 Add charstr.pos.y
C $C459,1 Step #REGhl back to charstr.pos.x
C $C45A,1 Subtract charstr.pos.x
C $C45B,1 Double it
C $C45C,1 Copy x to #REGc
C $C45D,1 Copy map_x_clamped to #REGe
C $C45E,1 Is map_x_clamped >= x?
C $C45F,2 Jump if so
C $C461,2 Add 24 + 2 * 8 (24 => screen width, 8 => spawn zone size)
C $C463,4 Clamp to a maximum of 255
C $C467,1 Is x > (map_x_clamped + spawn size, clamped to 255)?
C $C468,2 Jump if so
@ $C46A label=sc_indoors
C $C46A,1 Restore the character struct pointer (spawn_character arg)
C $C46B,1 Preserve the character struct pointer over the call
C $C46C,1 Preserve map_x/y_clamped
C $C46D,1 Preserve the loop counter
C $C46E,3 Add characters to the visible character list
C $C471,1 Restore the loop counter
C $C472,1 Restore map_x/y_clamped
@ $C473 label=sc_unstash_next
C $C473,1 Restore the character struct pointer
@ $C474 label=sc_next
C $C474,7 Advance to the next characterstruct
C $C47B,2 ...loop
C $C47D,1 Return
;
c $C47E Remove any off-screen non-player characters.
D $C47E This is the opposite of #R$C41C.
D $C47E Used by the routine at #R$9D7B.
@ $C47E label=purge_invisible_characters
C $C47E,3 Read the current map position into #REGhl
N $C481 Calculate clamped lower bound.
N $C481 9 is the size, in UDGs, of a buffer zone around the visible screen in which visible characters will persist. (Compare to the spawning size of 8).
C $C481,1 Get map_position.x
C $C482,2 Subtract 9
C $C484,2 Jump if it was >= 9
C $C486,1 Otherwise zero it
C $C487,1 #REGe is the result: minx
C $C488,1 Get map_position.y
C $C489,2 Subtract 9
C $C48B,2 Jump if it was >= 9
C $C48D,1 Otherwise zero it
C $C48E,1 #REGd is the result: miny
N $C48F Iterate over non-player characters.
C $C48F,2 Set #REGb for seven iterations
@ $C491 nowarn
C $C491,3 Point #REGhl at the second visible character
N $C494 Start loop
N $C494 Ignore inactive characters.
@ $C494 label=pic_loop
C $C494,1 Fetch the vischar's character index
C $C495,2 Is it character_NONE?
C $C497,3 Jump to the next vischar if so
C $C49A,1 Preserve the vischar pointer
N $C49B Reset this character if it's not in the current room.
C $C49B,4 Point #REGhl at vischar.room
C $C49F,3 Get the global current room index
C $C4A2,1 Is the vischar in the current room?
C $C4A3,2 Jump to reset if not
N $C4A5 Handle Y part
C $C4A5,4 Load vischar.iso_pos.y into (#REGc,#REGa)
C $C4A9,3 Divide (#REGc,#REGa) by 8 with rounding. Result is in #REGa
C $C4AC,1 Copy result #REGc
C $C4AD,1 Copy miny to #REGa
C $C4AE,1 Is miny >= result?
C $C4AF,2 Jump to reset if so (out of bounds)
N $C4B1 Commentary: 16 is used for screen height here, but 24 is used for width below - so that doesn't line up with the actual values which are 24x17.
C $C4B1,2 Add 16 + 2 * 9 (16 => screen height, 9 => buffer zone size)
C $C4B3,4 Clamp to a maximum of 255
C $C4B7,1 Is result > (miny + buffer size, clamped to 255)?
C $C4B8,2 Jump to reset if so (out of bounds)
N $C4BA Handle X part
C $C4BA,4 Load vischar.iso_pos.x into (#REGc,#REGa)
C $C4BE,3 Divide (#REGc,#REGa) by 8 (with no rounding). Result is in #REGa
C $C4C1,1 Copy result #REGc
C $C4C2,1 Copy minx to #REGa
C $C4C3,1 Is minx >= result?
C $C4C4,2 Jump to reset if so (out of bounds)
C $C4C6,2 Add 24 + 2 * 9 (24 => screen width, 9 => buffer zone size)
C $C4C8,4 Clamp to a maximum of 255
C $C4CC,1 Is result > (minx + buffer size, clamped to 255)?
C $C4CD,2 Jump to reset if so (out of bounds)
@ $C4CF label=pic_reset
C $C4CF,1 Restore the vischar pointer (reset_visible_character arg)
C $C4D0,1 Preserve the vischar pointer over the call
C $C4D1,1 Preserve minx/miny
C $C4D2,1 Preserve the loop counter
C $C4D3,3 Reset the visible character
C $C4D6,1 Restore the loop counter
C $C4D7,1 Restore minx/miny
@ $C4D8 label=pic_pop_next
C $C4D8,1 Restore the vischar pointer
@ $C4D9 label=pic_next
C $C4D9,4 Advance to the next vischar
C $C4DD,2 ...loop
C $C4DF,1 Return
;
c $C4E0 Add a character to the visible character list.
D $C4E0 Used by the routine at #R$C41C.
R $C4E0 I:HL Pointer to character to spawn.
@ $C4E0 label=spawn_character
C $C4E0,2 Is the character already on-screen? (test flag characterstruct_FLAG_ON_SCREEN)
C $C4E2,1 Return if so
C $C4E3,1 Preserve the character pointer
N $C4E4 Find an empty slot in the visible character list.
N $C4E4 Iterate over non-player characters.
@ $C4E4 nowarn
C $C4E4,3 Point #REGhl at the second visible character
C $C4E7,3 Prepare the vischar stride
C $C4EA,2 Prepare vischar_CHARACTER_EMPTY_SLOT
C $C4EC,2 Set #REGb for seven iterations (seven non-player vischars)
N $C4EE Start loop
@ $C4EE label=spawn_find_slot
C $C4EE,1 Empty slot?
C $C4EF,2 Jump if so
C $C4F1,1 Advance to the next vischar
C $C4F2,2 ...loop
@ $C4F4 label=spawn_no_spare_slot
C $C4F4,1 Restore the character pointer
C $C4F5,1 Return (Z set)
N $C4F6 Found an empty slot.
@ $C4F6 label=spawn_found_empty_slot
C $C4F6,1 Restore the character pointer to #REGde
C $C4F7,3 Point #REGiy at the empty vischar slot
C $C4FA,1 Preserve the empty vischar slot pointer
C $C4FB,1 Preserve the character pointer
C $C4FC,1 Advance #REGde to point at charstr.room
N $C4FD Scale coords dependent on which room the character is in.
C $C4FD,3 Point #REGhl at saved_pos_x
C $C500,1 Fetch charstr.room
C $C501,1 Advance #REGde to charstr.pos
C $C502,1 Is it outside?
C $C503,2 Jump if not
N $C505 Outdoors
C $C505,2 Set #REGa for three iterations (x,y,height)
N $C507 Start loop
@ $C507 label=spawn_outdoor_pos_loop
C $C507,1 Bank
C $C508,1 Read an (8-bit) coord
C $C509,3 Multiply it by 8 returning the result in #REGbc
C $C50C,4 Store the result widened to 16-bit
C $C510,1 Advance to the next coord
C $C511,1 Unbank
C $C512,4 ...loop
C $C516,2 (else)
@ $C518 label=spawn_indoors
C $C518,2 Set #REGb for three iterations
N $C51A Start loop
@ $C51A label=spawn_indoor_pos_loop
C $C51A,1 Read an (8-bit) coord
C $C51B,6 Store the coord widened to 16-bit
C $C521,2 ...loop
@ $C523 label=spawn_check_collide
C $C523,3 Call collision
C $C526,3 If no collision, call bounds_check
C $C529,1 Restore the character pointer
C $C52A,1 Restore the empty vischar slot pointer
C $C52B,1 Return if collision or bounds_check returned non-zero
N $C52C Transfer character struct to vischar.
C $C52C,4 Set characterstruct_FLAG_ON_SCREEN in charstr.character_and_flags
C $C530,4 Mask #REGa against characterstruct_CHARACTER_MASK ($1F) and store that as vischar.character
C $C534,2 Clear the vischar.flags
C $C536,1 Preserve the charstr.character_and_flags pointer
C $C537,3 Point #REGde at the character_meta_data for the commandant
C $C53A,1 Is it character_0_COMMANDANT?
C $C53B,2 Jump if so
@ $C53D nowarn
C $C53D,3 Point #REGde at the character_meta_data for a guard
C $C540,2 Is it character_1_GUARD_1 to character_15_GUARD_15?
C $C542,2 Jump if so
C $C544,3 Point #REGde at the character_meta_data for a dog
C $C547,2 Is it character_16_GUARD_DOG_1 to character_19_GUARD_DOG_4?
C $C549,2 Jump if so
C $C54B,3 Point #REGde at the character_meta_data for a prisoner
@ $C54E label=spawn_metadata_set
C $C54E,1 Swap vischar into #REGde, metadata into #REGhl
C $C54F,4 Point #REGde at vischar.animbase
C $C553,4 Copy metadata.animbase to vischar.animbase
C $C557,4 Point #REGde at vischar.mi.sprite
C $C55B,4 Copy metadata.sprite to vischar.mi.sprite
C $C55F,4 Rewind #REGde to vischar.mi.pos
C $C563,8 Copy saved_pos to vischar.mi.pos
C $C56B,1 Restore the #REGhl charstr.character_and_flags pointer
C $C56C,5 Advance #REGhl to charstr.route
C $C571,4 Point #REGde at vischar.room
C $C575,4 Set vischar.room to the global current room index
C $C579,1 Are we outside?
C $C57A,2 Jump if so
@ $C57C label=spawn_indoors_sound
C $C57C,12 Play the "character enters" sound effects
@ $C588 label=spawn_entered
C $C588,4 Rewind #REGde to vischar.route
C $C58C,4 vischar.route = charstr.route
C $C590,2 Rewind #REGhl to charstr.route
N $C592 This can get entered twice via #R$C5B4. On the first entry #REGhl points at charstr.route.index. On the second entry #REGhl points at vischar.route.index.
@ $C592 label=spawn_again
C $C592,1 Load route.index
C $C593,1 Is this character stood still? (routeindex_0_HALT)
C $C594,2 Jump if not
C $C596,4 Advance #REGde to vischar.counter_and_flags
C $C59A,2 (else)
@ $C59C label=spawn_moving
C $C59C,4 Clear the entered_move_a_character flag
C $C5A0,1 Preserve the vischar.target pointer
C $C5A1,3 Get our next target: a location, a door or 'route ends'. The result is returned in #REGa, target pointer returned in #REGhl
C $C5A4,2 Did #R$C651 return get_target_ROUTE_ENDS? ($FF)
C $C5A6,2 Jump if not
@ $C5A8 label=spawn_route_ends
C $C5A8,1 Restore the vischar.target pointer
C $C5A9,2 Rewind #REGhl to vischar.route
C $C5AB,1 Preserve the vischar.route pointer
C $C5AC,3 Route ended
C $C5AF,1 Restore the vischar.route pointer
C $C5B0,4 Point #REGde at vischar.target
C $C5B4,2 Jump back and try again...
@ $C5B6 label=spawn_route_door_test
C $C5B6,2 Did #R$C651 return get_target_DOOR? ($80)
C $C5B8,2 Jump if not (it must be get_target_LOCATION)
@ $C5BA label=spawn_route_door
C $C5BA,4 Set the vischar_FLAGS_TARGET_IS_DOOR flag
@ $C5BE label=spawn_got_target
C $C5BE,1 Restore the vischar.target pointer
C $C5BF,5 Copy the next target to vichar.target
@ $C5C4 label=spawn_end
C $C5C4,2 Clear vischar.counter_and_flags
C $C5C6,4 Rewind #REGde back to vischar.character (first byte)
C $C5CA,1 Swap vischar pointer into #REGhl
C $C5CB,1 Preserve vischar pointer
C $C5CC,3 Calculate screen position for the specified vischar
C $C5CF,1 Restore vischar pointer
C $C5D0,3 Exit via character_behaviour
;
c $C5D3 Reset a visible character (either a character or a stove/crate object).
D $C5D3 Used by the routines at #R$68A2, #R$69C9, #R$B79B and #R$C47E.
R $C5D3 I:HL Pointer to visible character.
@ $C5D3 label=reset_visible_character
C $C5D3,1 Fetch the vischar's character index
C $C5D4,2 Is it character_NONE? ($FF)
C $C5D6,1 Return if so
C $C5D7,2 Is it a stove/crate character? (character_26_STOVE_1+)
C $C5D9,2 Jump if not
C $C5DB,1 Bank
N $C5DC It's a stove or crate character.
C $C5DC,2 Set vischar.character to $FF (character_NONE)
C $C5DE,1 Advance #REGhl to vischar.flags
C $C5DF,2 Reset flags to $FF (vischar_FLAGS_EMPTY_SLOT)
C $C5E1,4 Point #REGhl at counter_and_flags
C $C5E5,2 Set counter_and_flags to zero
C $C5E7,3 Point #REGhl at vischar.mi.pos
C $C5EA,1 Unbank
N $C5EB Save the old position.
C $C5EB,3 Point #REGde at movable_items[0] / stove 1
C $C5EE,2 Is #REGa character_26_STOVE_1?
C $C5F0,2 Jump if so
C $C5F2,3 Point #REGde at movable_items[2] / stove 2
C $C5F5,2 Is #REGa character_27_STOVE_2?
C $C5F7,2 Jump if so
C $C5F9,3 Otherwise point #REGde at movable_items[1] / crate
N $C5FC Note: The DOS version of the game has a difference here. Instead of copying the current vischar's position into the movable_items's position, it only copies the first two bytes. The code is setup for a copy of six bytes (cx is set to 3) but the 'movsw' ought to be a 'rep movsw' for it to work. It fixes the bug where stoves get left in place after a restarted game, but almost looks like an accident.
@ $C5FC label=rvc_copy_mi
C $C5FC,5 Copy six bytes to the movable_items entry
C $C601,1 Return
N $C602 A non-object character.
@ $C602 label=rvc_humans
C $C602,1 Bank vischar pointer
C $C603,3 Get character struct for #REGa, result in #REGhl
C $C606,2 Clear flag characterstruct_FLAG_ON_SCREEN
C $C608,4 Point #REGde at vischar.room
C $C60C,1 Fetch vischar.room
C $C60D,2 Copy it to charstr.room
C $C60F,1 Bank room index
C $C610,1 Unbank vischar pointer
C $C611,4 Point #REGhl at vischar.counter_and_flags
C $C615,2 Clear vischar.counter_and_flags
C $C617,3 Point #REGhl at vischar.mi.pos
N $C61A Save the old position.
C $C61A,1 Point #REGde at charstr.pos.x
C $C61B,1 Unbank room index
C $C61C,1 Are we outdoors?
C $C61D,2 Jump if not
N $C61F Outdoors.
C $C61F,3 Scale down vischar.mi.pos to charstr.pos
C $C622,2 (else)
N $C624 Indoors.
@ $C624 label=rvc_indoors
C $C624,2 Set #REGb for three iterations
N $C626 Start loop
@ $C626 label=rvc_indoors_loop
C $C626,2 Copy coordinate
C $C628,3 Advance the source pointer
C $C62B,2 ...loop
@ $C62D label=rvc_reset_common
C $C62D,4 Reset #REGhl to point to the original vischar
C $C631,1 Fetch character index
C $C632,2 Set vischar.character to $FF (character_NONE)
C $C634,1 Advance #REGhl to vischar.flags
C $C635,2 Reset flags to $FF (vischar_FLAGS_EMPTY_SLOT)
C $C637,1 Advance #REGhl to vischar.route
N $C638 Guard dogs only.
C $C638,8 Is this a guard dog character? character_16_GUARD_DOG_1..character_19_GUARD_DOG_4
N $C640 Choose random locations in the fenced off area (right side).
@ $C640 label=rvc_dogs
C $C640,5 Set route to (routeindex_255_WANDER,0) ($FF,$00) -- wander from locations 0..7
C $C645,2 Is this character_18_GUARD_DOG_3 or character_19_GUARD_DOG_4?
C $C647,2 Jump if not
N $C649 Choose random locations in the fenced off area (bottom side).
C $C649,2 Set route.step to $18 -- wander from locations 24..31
@ $C64B label=rvc_dogs_done
C $C64B,1 Point #REGhl at vischar.route
@ $C64C label=rvc_end
C $C64C,4 Copy route into charstr
C $C650,1 Return
;
c $C651 Return the coordinates of the route's current target.
D $C651 Given a route_t return the coordinates the character should move to. Coordinates are returned as a tinypos_t when moving to a door or an xy_t when moving to a numbered location.
D $C651 If the route specifies 'wander' then one of eight random locations starting from route.step is chosen.
D $C651 Used by the routines at #R$A3BB, #R$C4E0, #R$C6A0 and #R$CB23.
R $C651 I:HL Pointer to route.
R $C651 O:A 0/128/255 => Target is a location / a door / the route ended.
R $C651 O:HL If the target is a location a pointer into locations[]; if a door a pointer into doors[] (returned as door.pos).
@ $C651 label=get_target
C $C651,1 Get the route index
C $C652,2 Is it routeindex_255_WANDER? ($FF)
C $C654,2 Jump if not
N $C656 Wander around randomly.
N $C656 Uses route.step + rand(0..7) to index locations[].
@ $C656 label=gt_wander
C $C656,5 Clear the bottom three bits of route.step
C $C65B,3 Get a pseudo-random number in #REGa
C $C65E,2 Make it 0..7
C $C660,2 Add the random value to route.step
C $C662,2 Jump
@ $C664 label=gt_not_halt
C $C664,1 Preserve the route pointer
C $C665,2 Load route.step
N $C667 Control can arrive here with route.index set to zero. This happens when the hero stands up during breakfast, is pursued by guards, then when left to idle sits down and the pursuing guards resume their original positions. get_route() will return in that case a zero pointer so it starts fetching from $0001. In the Spectrum ROM location $0001 holds XOR A ($AF).
C $C667,3 Get the route for #REGa in #REGde
N $C66A Since all of the routes are packed togther, this relies on being able to fetch the previous route's terminator.
C $C66A,8 High byte is set to zero unless... route.step is $FF when it's set to $FF
C $C672,1 #REGhl = -1, or route.step
C $C673,2 Point #REGde at the next route byte
C $C675,1 Read a byte of route
C $C676,2 Is it routebyte_END? ($FF)
C $C678,1 Irrespectively restore #REGhl
C $C679,2 Jump if so
C $C67B,2 Clear its door_REVERSE flag ($80)
C $C67D,2 Is it a door index?
C $C67F,2 Jump if not
N $C681 Route byte < 40: A door.
@ $C681 label=gt_door
C $C681,1 Re-read routebyte to get the reversed flag
C $C682,2 Reversed?
C $C684,2 Jump if not
C $C686,2 Toggle reverse flag
C $C688,3 Turn the door index into a door_t pointer (in #REGhl)
C $C68B,1 Advance #REGhl to point at door.pos
C $C68C,3 Return with #REGa set to 128
N $C68F Route byte = 40..117: A location index.
@ $C68F label=gt_location
C $C68F,3 The location index is offset by 40
@ $C692 label=gt_pick_loc
C $C692,9 Point #REGhl at location[#REGa]
C $C69B,2 Return with #REGa set to zero
@ $C69D label=gt_route_ends
C $C69D,3 Return with #REGa set to 255
;
c $C6A0 Move one (off-screen) character around at a time.
D $C6A0 Used by the routine at #R$9D7B.
@ $C6A0 label=move_a_character
C $C6A0,5 Set the 'character index is valid' flag
N $C6A5 Move to the next character, wrapping around after character 26.
C $C6A5,4 Load and increment the current character index
C $C6A9,5 If the character index became character_26_STOVE_1 then wrap around to character_0_COMMANDANT
@ $C6AE label=mc_didnt_wrap
C $C6AE,3 Store the character index
N $C6B1 Get its chararacter struct and exit if the character is on-screen.
C $C6B1,3 Get a pointer to the character struct for character index #REGa, in #REGhl
C $C6B4,2 Is the character on-screen? characterstruct_FLAG_ON_SCREEN
C $C6B6,1 It is - return
C $C6B7,1 Preserve the character struct pointer
N $C6B8 Are any items to be found in the same room as the character?
C $C6B8,2 Advance #REGhl to charstr.room and fetch it
C $C6BA,1 Are we outdoors?
C $C6BB,2 Jump if so
N $C6BD Note: This discovers just one item at a time.
C $C6BD,3 Is the item discoverable indoors?
C $C6C0,2 Jump if not found
C $C6C2,3 Otherwise cause item #REGc to be discovered
@ $C6C5 label=mc_no_item
C $C6C5,1 Restore the character struct pointer
C $C6C6,2 Advance #REGhl to charstr.pos
C $C6C8,1 Preserve the charstr.pos pointer
C $C6C9,3 Advance #REGhl to charstr.route
N $C6CC If the character is standing still, return now.
C $C6CC,1 Fetch charstr.route.index
C $C6CD,1 Is it routeindex_0_HALT?
C $C6CE,2 Jump if not
@ $C6D0 label=mc_halted
C $C6D0,1 Restore the charstr.pos pointer
C $C6D1,1 Return
@ $C6D2 label=mc_not_halted
C $C6D2,3 Get our next target: a location, a door or 'route ends'. The result is returned in #REGa, target pointer returned in #REGhl
C $C6D5,2 Did #R$C651 return get_target_ROUTE_ENDS? ($FF)
C $C6D7,3 Jump if not
N $C6DA When the route ends, reverse the route.
C $C6DA,3 Fetch the current character index
C $C6DD,1 Is it the commandant? (character_0_COMMANDANT)
C $C6DE,2 Jump if so
N $C6E0 Not the commandant.
C $C6E0,2 Is it character_12_GUARD_12 or higher?
C $C6E2,2 Jump if so
N $C6E4 Characters 1..11.
@ $C6E4 label=mc_reverse_route
C $C6E4,5 Toggle charstr.route direction flag routeindexflag_REVERSED ($80)
N $C6E9 Pattern: [-2]+1
@ $C6EF label=mc_route_fwd
C $C6E9,7 If the route is reversed then step backwards, otherwise step forwards
C $C6F0,1 Restore the charstr.pos pointer
C $C6F1,1 Return
N $C6F2 Commandant only.
@ $C6F2 label=mc_commandant
C $C6F2,3 Read the charstr.route index
C $C6F5,4 Jump if it's not routeindex_36_GO_TO_SOLITARY
N $C6F9 We arrive here if the character index is character_12_GUARD_12, or higher, or if it's the commandant on route 36 ("go to solitary").
@ $C6F9 label=mc_trigger_event
C $C6F9,1 Restore the charstr.pos pointer
C $C6FA,3 Exit via character_event
N $C6FD Two unused bytes.
B $C6FD,2,2
@ $C6FF label=mc_door
C $C6FF,2 Did #R$C651 return get_target_DOOR? ($80)
C $C701,3 Jump if not
N $C704 Handle the target-is-a-door case.
C $C704,1 Restore the charstr.pos pointer (PUSH at #R$C6C8)
C $C705,3 Get room index
C $C708,1 Preserve the door.pos pointer
C $C709,1 Are we outdoors?
C $C70A,3 Jump if not
N $C70D Outdoors
C $C70D,1 Preserve the charstr.pos pointer
N $C70E Divide the door.pos location at #REGhl by two and store it to saved_pos.
C $C70E,3 Point #REGde at saved_pos_x
C $C711,2 Set #REGb for two iterations
N $C713 Start loop
@ $C713 label=mc_door_copypos_loop
C $C713,6 Copy X,Y of door.pos, each axis divided by two
C $C719,2 ...loop
C $C71B,3 Point #REGhl at saved_pos_x
C $C71E,1 Restore the charstr.room pointer
N $C71F Decide on a maximum movement distance for move_towards to use.
@ $C71F label=mc_door_choose_maxdist
C $C71F,1 Rewind #REGde to point at charstr.room
C $C720,1 Fetch it
C $C721,1 Advance #REGde back
C $C722,1 Was charstr.room room_0_OUTDOORS?
C $C723,2 Set the maximum distance to two irrespectively
C $C725,2 Jump if it was
C $C727,2 Otherwise set the maximum distance to six
@ $C729 label=mc_door_maxdist_chosen
C $C729,1 Move maximum to #REGa'
C $C72A,2 Initialise the "arrived" counter to zero
C $C72C,3 Move charstr.pos.x (pointed to by #REGde) towards tinypos.x (#REGhl), with a maximum delta of #REGa'. #REGb is incremented if no movement was required
C $C72F,2 Advance to Y axis
C $C731,3 Move again, but on Y axis
C $C734,1 Restore the door.pos pointer
C $C735,3 Did we move?
C $C738,1 Return if so
N $C739 If we reach here the character has arrived at their destination.
N $C739 Our current target is a door, so change to the door's target room.
@ $C739 label=mc_door_reached
C $C739,2 Rewind #REGde to charstr.room
C $C73B,1 Rewind #REGhl to door.room_and_direction
C $C73C,1 Fetch door.room_and_direction
C $C73D,4 Isolate the room number
C $C741,1 Assign to charstr.room (i.e. change room)
N $C742 Determine the destination door.
C $C742,3 Isolate the direction (door_FLAGS_MASK_DIRECTION)
C $C745,2 Is the door facing top left or top right?
C $C747,2 Jump if neither
C $C749,5 Otherwise calculate the address of the next door half
C $C74E,2 (else)
@ $C750 label=mc_door_prev
C $C750,3 Calculate the address of the previous door half
N $C753 Copy the door's tinypos position into the charstr.
@ $C753 label=mc_door_copy_pos
C $C753,1 Fetch charstr.room
C $C754,1 Advance to charstr.pos
C $C755,1 Is it room_0_OUTDOORS?
C $C756,2 Jump if so
N $C758 Indoors. Copy the door's tinypos into the charstr's tinypos.
C $C758,2 Copy X
C $C75A,2 Copy Y
C $C75C,2 Copy height
C $C75E,1 Rewind #REGde to charstr.pos.height
C $C75F,2 (else)
N $C761 Outdoors. Copy the door's tinypos into the charstr's tinypos, dividing by two.
@ $C761 label=mc_door_outdoors
C $C761,2 Set #REGb for three iterations
N $C763 Start loop
@ $C763 label=mc_door_outdoors_loop
C $C763,6 Copy X,Y of door.pos, each axis divided by two
C $C769,2 ...loop
C $C76B,1 Rewind #REGde to charstr.pos.height
C $C76C,2 (else)
N $C76E Normal move case.
@ $C76E label=mc_regular_move
C $C76E,1 Restore the charstr.pos pointer
N $C76F Establish a maximum for passing into move_towards.
@ $C76F label=mc_regular_choose_maxdist
C $C76F,1 Rewind #REGde to point at charstr.room
C $C770,1 Fetch it
C $C771,1 Advance #REGde back
C $C772,1 Are we outdoors?
C $C773,2 Set maximum to two irrespectively
C $C775,2 Jump if we are
C $C777,2 Otherwise set maximum to six
@ $C779 label=mc_regular_maxdist_chosen
C $C779,1 Move maximum to #REGa'
C $C77A,2 Initialise the "arrived" counter to zero
C $C77C,3 Move charstr.pos.x (pointed to by #REGde) towards tinypos.x (#REGhl), with a maximum delta of #REGa'. #REGb is incremented if no movement was required
C $C77F,2 Advance to Y axis
C $C781,3 Move again, but on Y axis
C $C784,1 Advance #REGde to charstr.pos.height (possibly redundant)
C $C785,3 Did we move?
C $C788,2 Jump if not
C $C78A,1 Otherwise return
N $C78B If we reach here the character has arrived at their destination.
@ $C78B label=mc_regular_reached
C $C78B,1 Advance #REGde to charstr.route
C $C78C,1 Swap charstr into #REGhl
C $C78D,1 Read charstr.route.index
C $C78E,2 Is the route index routeindex_255_WANDER? ($FF)
C $C790,1 Return if so
C $C791,5 If the route is reversed then step backwards, otherwise step forwards
@ $C796 label=mc_route_up
C $C796,1 Increment route.step
C $C797,1 Return
@ $C798 label=mc_route_down
C $C798,1 Decrement route.step
C $C799,1 Return
;
c $C79A Moves the first value toward the second.
D $C79A Used by the routine at #R$C6A0.
R $C79A I:A' Largest movement allowed. Either 2 or 6.
R $C79A I:B Return code. Incremented if delta is zero.
R $C79A I:DE Pointer to the first value (byte).
R $C79A I:HL Pointer to the second value (byte).
R $C79A O:B Incremented by one when no change.
@ $C79A label=move_towards
C $C79A,3 Set #REGc to the largest movement allowed
C $C79D,2 delta = first - second
C $C79F,2 Was the delta zero? Jump if not
N $C7A1 Delta was zero
C $C7A1,1 Otherwise increment the result by one
C $C7A2,1 Return
C $C7A3,2 Was the delta negative? Jump if not
N $C7A5 Delta was negative
C $C7A5,2 Get the absolute value
C $C7A7,4 Clamp the delta to the largest movement
C $C7AB,4 Move the first value towards second
C $C7AF,1 Return
N $C7B0 Delta was positive
C $C7B0,4 Clamp the delta to the largest movement
C $C7B4,4 Move the first value towards second
C $C7B8,1 Return
;
c $C7B9 Get character struct.
D $C7B9 Used by the routines at #R$A38C, #R$C5D3 and #R$C6A0.
R $C7B9 I:A Character index.
R $C7B9 O:HL Points to character struct.
@ $C7B9 label=get_character_struct
C $C7B9,5 Multiply #REGa by seven
C $C7BE,3 Point #REGhl at character_structs
C $C7C1,4 Combine
C $C7C5,1 Return
;
c $C7C6 Character event.
D $C7C6 Used by the routines at #R$C6A0 and #R$CB2D.
D $C7C6 Makes characters sit, sleep or other things TBD.
R $C7C6 I:HL Points to character_struct.route or vischar.route.
@ $C7C6 label=character_event
C $C7C6,1 Load route.index
C $C7C7,2 Is it less than routeindex 7?
C $C7C9,2 Jump if so
C $C7CB,2 Is it less than routeindex 13?
C $C7CD,3 Call 'character sleeps' if so (if indices 7..12)
C $C7D0,2 Is it less than routeindex_18?
C $C7D2,2 Jump if so
N $C7D4 Bug: The sixth prisoner doesn't sit for breakfast because this should be $18.
C $C7D4,2 Is it less than routeindex 23?
C $C7D6,3 Call 'character sits' if so (if indices 18..22)
C $C7D9,1 Stack the route pointer - the event handlers will pop
N $C7DA Locate the character in the character_to_event_handler_index_map.
@ $C7DA nowarn
C $C7DA,3 Point #REGhl at character_to_event_handler_index_map[0]
C $C7DD,2 Set #REGb for 24 iterations - length of the map
N $C7DF Start loop
C $C7DF,1 Does the route index in #REGa match the map's route index?
C $C7E0,2 Jump if so
C $C7E2,2 Advance to the next map entry
C $C7E4,2 ...loop
C $C7E6,1 Unstack the route pointer
C $C7E7,2 Make the character stand still by setting the new route index to routeindex_0_HALT
C $C7E9,1 Return
@ $C7EA label=ce_call_action
C $C7EA,2 Read the index of the handler from the map
C $C7EC,1 Double it
C $C7ED,3 Copy it to #REGbc
@ $C7F0 nowarn
C $C7F0,4 Point #REGhl at character_event_handlers[index]
C $C7F4,4 Load the event handler address into #REGhl
C $C7F8,1 Jump to the event handler
N $C7F9 character_to_event_handler_index_map
N $C7F9 Array of (character + flags, character event handler index) mappings.
@ $C7F9 label=character_to_event_handler_index_map
W $C7F9,2,2 routeindex_38_GUARD_12_BED         | REVERSE, 0 - wander between locations  8..15
W $C7FB,2,2 routeindex_39_GUARD_13_BED         | REVERSE, 0 - wander between locations  8..15
W $C7FD,2,2 routeindex_40_GUARD_14_BED         | REVERSE, 1 - wander between locations 16..23
W $C7FF,2,2 routeindex_41_GUARD_15_BED         | REVERSE, 1 - wander between locations 16..23
W $C801,2,2 routeindex_5_EXIT_HUT2,                       0 - wander between locations  8..15
W $C803,2,2 routeindex_6_EXIT_HUT3,                       1 - wander between locations 16..23
W $C805,2,2 routeindex_5_EXIT_HUT2             | REVERSE, 3 -
W $C807,2,2 routeindex_6_EXIT_HUT3             | REVERSE, 3 -
W $C809,2,2 routeindex_14_GO_TO_YARD,                     2 - wander between locations 56..63
W $C80B,2,2 routeindex_15_GO_TO_YARD,                     2 - wander between locations 56..63
W $C80D,2,2 routeindex_14_GO_TO_YARD           | REVERSE, 0 - wander between locations  8..15
W $C80F,2,2 routeindex_15_GO_TO_YARD           | REVERSE, 1 - wander between locations 16..23
W $C811,2,2 routeindex_16_BREAKFAST_25,                   5 -
W $C813,2,2 routeindex_17_BREAKFAST_23,                   5 -
W $C815,2,2 routeindex_16_BREAKFAST_25         | REVERSE, 0 - wander between locations  8..15
W $C817,2,2 routeindex_17_BREAKFAST_23         | REVERSE, 1 - wander between locations 16..23
W $C819,2,2 routeindex_32_GUARD_15_ROLL_CALL   | REVERSE, 0 - wander between locations  8..15
W $C81B,2,2 routeindex_33_PRISONER_4_ROLL_CALL | REVERSE, 1 - wander between locations 16..23
W $C81D,2,2 routeindex_42_HUT2_LEFT_TO_RIGHT,             7 -
W $C81F,2,2 routeindex_44_HUT2_RIGHT_TO_LEFT,             8 - hero sleeps
W $C821,2,2 routeindex_43_7833,                           9 - hero sits
W $C823,2,2 routeindex_36_GO_TO_SOLITARY       | REVERSE, 6 -
W $C825,2,2 routeindex_36_GO_TO_SOLITARY,                10 - hero released from solitary
W $C827,2,2 routeindex_37_HERO_LEAVE_SOLITARY,            4 - solitary ends
N $C829 character_event_handlers
N $C829 Array of pointers to character event handlers.
@ $C829 label=character_event_handlers
W $C829,22,2
N $C83F charevnt_solitary_end
@ $C83F label=charevnt_solitary_ends
C $C83F,4 in_solitary = 0; // enable player control
C $C843,2 goto charevnt_wander_top;
N $C845 charevnt_commandant_to_yard
@ $C845 label=charevnt_commandant_to_yard
C $C845,1 // (popped) sampled HL=$80C2 (x2),$8042  // route
C $C846,3 *HL++ = 0x03;
C $C849,2 *HL   = 0x15;
C $C84B,1 Return
N $C84C charevnt_hero_release
@ $C84C label=charevnt_hero_release
C $C84D,3 *HL++ = 0xA4;
C $C850,2 *HL   = 0x03;
C $C852,4 automatic_player_counter = 0; // force automatic control
C $C856,6 set_hero_route(0x0025); return;
N $C85C charevnt_wander_left
@ $C85C label=charevnt_wander_left
C $C85C,2 #REGc = 0x10; // 0xFF10
C $C85E,2 goto exit;
N $C860 charevnt_wander_yard
@ $C860 label=charevnt_wander_yard
C $C860,2 #REGc = 0x38; // 0xFF38
C $C862,2 goto exit;
N $C864 charevnt_wander_top
@ $C864 label=charevnt_wander_top
C $C864,2 #REGc = 0x08; // 0xFF08 // sampled HL=$8022,$8042,$8002,$8062
C $C866,1 exit:
C $C867,3 *HL++ = 0xFF;
C $C86A,1 *HL   = C;
C $C86B,1 Return
N $C86C charevnt_bed
@ $C86C label=charevnt_bed
C $C86D,10 if (entered_move_a_character == 0) goto character_bed_vischar; else goto character_bed_state;
N $C877 charevnt_breakfast
@ $C877 label=charevnt_breakfast
C $C878,10 if (entered_move_a_character == 0) goto charevnt_breakfast_vischar; else goto charevnt_breakfast_state;
N $C882 charevnt_exit_hut2
@ $C882 label=charevnt_exit_hut2
C $C883,3 *HL++ = 0x05;
C $C886,2 *HL   = 0x00;
C $C888,1 Return
N $C889 charevnt_hero_sits
@ $C889 label=charevnt_hero_sits
C $C88A,3 goto hero_sits;
N $C88D charevnt_hero_sleeps
@ $C88D label=charevnt_hero_sleeps
C $C88E,3 goto hero_sleeps;
;
g $C891 A countdown until any food item is discovered.
D $C891 (<- automatics, target_reached)
@ $C891 label=food_discovered_counter
B $C891,1,1
;
c $C892 Make characters follow the hero if he's being suspicious.
D $C892 Also handles food item discovery and automatic hero behaviour.
D $C892 Used by the routine at #R$9D7B.
@ $C892 label=automatics
C $C892,4 Clear the 'character index is valid' flag
N $C896 Hostiles pursue if the bell is not ringing.
C $C896,3 Read the bell ring counter/flag
C $C899,1 Is it bell_RING_PERPETUAL?
C $C89A,3 Call (hostiles pursue prisoners) if so
N $C89D If food was dropped then count down until it is discovered.
C $C89D,3 Point #REGhl at food_discovered_counter
C $C8A0,1 Fetch the counter
C $C8A1,1 Is it zero?
C $C8A2,2 Jump if so (it already hit zero)
C $C8A4,1 Otherwise decrement it
C $C8A5,2 Jump if it's not zero
N $C8A7 De-poison the food.
@ $C8A7 nowarn
C $C8A7,3 Point #REGhl at item_structs[item_FOOD].item
C $C8AA,2 Clear its itemstruct_ITEM_FLAG_POISONED flag
C $C8AC,2 Set #REGc to item_FOOD
C $C8AE,3 Cause item #REGc to be discovered
N $C8B1 Make supporting characters react.
@ $C8B1 label=auto_react
@ $C8B1 nowarn
C $C8B1,4 Point #REGhl at the second visible character
C $C8B5,2 Set #REGb for seven iterations
N $C8B7 Start loop
@ $C8B7 label=auto_react_loop
C $C8B7,1 Preserve the loop counter
C $C8B8,3 Load vischar.flags
C $C8BB,2 Is it an empty slot?
C $C8BD,3 Jump if so
C $C8C0,3 Load vischar.character
C $C8C3,2 Mask with vischar_CHARACTER_MASK to get character index
C $C8C5,2 Is it a hostile character? (character_19_GUARD_DOG_4 or below)
C $C8C7,3 Jump if not
N $C8CA Characters 0..19.
C $C8CA,1 Preserve the character index
C $C8CB,3 Is the item discoverable?
C $C8CE,4 Is red_flag set?
C $C8D2,2 Jump if so
C $C8D4,4 Is automatic_player_counter non-zero?
@ $C8D8 label=auto_follow
C $C8D8,3 Call (guards follow suspicious character) if so
C $C8DB,1 Restore character index
N $C8DC Guard dogs 1..4 (characters 16..19).
C $C8DC,2 Is this character a guard dog?
C $C8DE,6 Jump if not
N $C8E4 Dog handling: Is the food nearby?
C $C8E4,3 Copy global vischar pointer to #REGhl
C $C8E7,1 Point #REGhl at vischar.flags
C $C8E8,3 Fetch item_structs[item_FOOD].room
C $C8EB,2 Test for itemstruct_ROOM_FLAG_NEARBY_7
C $C8ED,2 Jump if clear
C $C8EF,2 Set vischar.flags to vischar_PURSUIT_DOG_FOOD
@ $C8F1 label=auto_behaviour
C $C8F1,3 Call (character behaviour)
@ $C8F4 label=auto_next
C $C8F4,1 Restore the loop counter
C $C8F5,5 Advance to the next vischar
C $C8FA,4 ...loop
N $C8FE Inhibit hero automatic behaviour when the flag is red, or otherwise inhibited.
C $C8FE,4 Is red_flag set?
N $C902 Bug: Pointless JP NZ (jumps to a RET where a RET NZ would suffice).
C $C902,3 Jump (return) if so
C $C905,4 Is in_solitary set?
C $C909,2 Jump if so
C $C90B,4 Is automatic_player_counter non-zero?
C $C90F,1 Return if so
N $C910 Otherwise run character behaviour
@ $C910 label=auto_run_cb
C $C910,4 Point #REGiy at the hero's vischar
C $C914,3 Run character behaviour
@ $C917 label=auto_return
C $C917,1 Return
;
c $C918 Character behaviour.
D $C918 Used by the routines at #R$C4E0 and #R$C892.
R $C918 I:IY Pointer to visible character.
N $C918 Proceed into the character behaviour handling only when this delay field hits zero. This stops characters navigating around obstacles too quickly.
@ $C918 label=character_behaviour
C $C918,3 Fetch vischar.counter_and_flags
C $C91B,1 Copy it to #REGb
N $C91C If the counter field is set then decrement it and return.
C $C91C,2 Isolate the counter field in the bottom nibble
C $C91E,6 Decrement the counter if it's positive
C $C924,1 Return
N $C925 We arrive here when the counter is zero.
@ $C925 label=cb_proceed
C $C925,3 Copy the vischar pointer into #REGhl
C $C928,1 Advance #REGhl to vischar.flags
C $C929,1 Fetch the flags so we can check the mode field
C $C92A,1 Are any flag bits set?
C $C92B,3 Jump if not
N $C92E Check for mode 1 ("pursue")
C $C92E,2 Is the mode vischar_PURSUIT_PURSUE?
C $C930,2 Jump if not
N $C932 Mode 1: Hero is chased by hostiles and sent to solitary if caught.
@ $C932 label=cb_pursue_hero
C $C932,1 Preserve vischar.flags pointer
C $C933,1 Bank
C $C934,1 Restore vischar.flags pointer
C $C935,3 Advance #REGde to vischar.position
C $C938,3 Point #REGhl at the global map position (the hero's position)
C $C93B,4 Copy hero's (x,y) position to vischar.target
C $C93F,1 Unbank
C $C940,3 Jump to 'move'
N $C943 Check for mode 2 ("hassle")
@ $C943 label=cb_hassle_check
C $C943,2 Is the mode vischar_PURSUIT_HASSLE?
C $C945,2 Jump if not
N $C947 Mode 2: Hero is chased by hostiles if under player control.
C $C947,4 Is the automatic_player_counter non-zero?
N $C94B The hero is under player control: pursue.
C $C94B,2 Jump into mode 1's pursue handler
N $C94D Otherwise the hero is under automatic control: hostiles lose interest and resume their original route.
C $C94D,3 Clear vischar.flags
C $C950,3 Exit via get_target_assign_pos
N $C953 Check for mode 3 ("dog food")
@ $C953 label=cb_dog_food_check
C $C953,2 Is the mode vischar_PURSUIT_DOG_FOOD?
C $C955,2 Jump if not
N $C957 Mode 3: The food item is near a guard dog.
C $C957,1 Preserve vischar.flags pointer
C $C958,1 (get it in #REGde)
C $C959,3 Point #REGhl at item_structs[item_FOOD].room
C $C95C,2 Is itemstruct_ROOM_FLAG_NEARBY_7 set?
C $C95E,2 Jump if not
N $C960 Set the dog's target to the poisoned food location.
C $C960,1 Advance #REGhl to item_structs[item_FOOD].pos.x
C $C961,4 Point #REGde at vischar.target.x
C $C965,4 Copy (x,y)
C $C969,1 Restore vischar.flags pointer
C $C96A,2 Jump to 'move'
N $C96C Nearby flag wasn't set.
@ $C96C label=cb_dog_food_not_nearby
C $C96C,2 Clear vischar.flags
C $C96E,1 (get vischar.flags pointer in #REGhl)
C $C96F,3 Set vischar.route.index to routeindex_255_WANDER ($FF)
C $C972,3 Set vischar.route.step to zero -- wander from 0..7
C $C975,1 Restore vischar.flags pointer
C $C976,3 Exit via get_target_assign_pos
N $C979 Check for mode 4 ("saw bribe")
@ $C979 label=cb_saw_bribe_check
C $C979,2 Is the mode vischar_PURSUIT_SAW_BRIBE?
C $C97B,2 Jump if not
N $C97D Mode 4: Hostile character witnessed a bribe being given (in accept_bribe).
C $C97D,1 Preserve vischar.flags pointer
C $C97E,3 Get the global bribed character
C $C981,2 Is it character_NONE? ($FF)
C $C983,2 Jump if so
C $C985,1 Copy the bribed character to #REGc
N $C986 Iterate over non-player characters.
C $C986,2 Set #REGb for seven iterations
@ $C988 nowarn               ;
C $C988,3 Point #REGhl at the second visible character
N $C98B Start loop
@ $C98B label=cb_bribe_loop
C $C98B,1 Copy bribed character to #REGa
C $C98C,1 Is this vischar the bribed character?
C $C98D,2 Jump if so
C $C98F,4 Step #REGhl to the next vischar
C $C993,2 ...loop
@ $C995 label=cb_bribe_not_found
C $C995,1 Restore vischar.flags pointer
N $C996 Bribed character was not visible: hostiles lose interest and resume following their original route.
C $C996,3 Clear vischar.flags
C $C999,3 Exit via get_target_assign_pos
N $C99C Found the bribed character in vischars: hostiles target him.
@ $C99C label=cb_bribed_visible
C $C99C,4 Advance #REGhl to vischar.mi.pos
C $C9A0,2 Get the vischar pointer
C $C9A2,4 Point #REGde at vischar.target
C $C9A6,3 Get the global current room index
C $C9A9,1 Is it zero?
C $C9AA,3 Jump if not
N $C9AD Outdoors
C $C9AD,3 Scale down the bribed character's position to this vischar's target field
C $C9B0,2 (else)
N $C9B2 Indoors
@ $C9B2 label=cb_bribed_indoors
C $C9B2,5 Scale down the bribed character's position to this vischar's target field
@ $C9B7 label=cb_bribed_done
C $C9B7,1 Restore the vischar pointer
C $C9B8,2 Jump to 'move'
@ $C9BA label=cb_check_halt
C $C9BA,1 Advance #REGhl to vischar.route.index
C $C9BB,1 Fetch it
C $C9BC,1 Step back
C $C9BD,1 Is it routeindex_0_HALT? ($00)
C $C9BE,2 Jump if so (set input)
@ $C9C0 label=cb_move
C $C9C0,1 Get vischar.flags
C $C9C1,1 Bank
C $C9C2,1 #REGc = flags
N $C9C3 Select a scaling routine.
C $C9C3,3 Get the global current room index
C $C9C6,1 Is it outdoors? (zero)
C $C9C7,2 Jump if so
@ $C9C9 label=cb_scaling_indoors
@ $C9C9 nowarn
C $C9C9,3 Point #REGhl at multiply_by_1
C $C9CC,2 (else)
@ $C9CE label=cb_scaling_door
C $C9CE,2 Is vischar.flags vischar_FLAGS_TARGET_IS_DOOR set?
C $C9D0,2 Jump if not
@ $C9D2 nowarn
C $C9D2,3 Point #REGhl at multiply_by_4
C $C9D5,2 (else)
@ $C9D7 label=cb_scaling_outdoors
@ $C9D7 nowarn
C $C9D7,3 Point #REGhl at multiply_by_8
N $C9DA Self modify vischar_move_x/y routines.
@ $C9DA label=cb_self_modify
C $C9DA,3 Self-modify vischar_move_x
C $C9DD,3 Self-modify vischar_move_y
C $C9E0,1 Unbank
N $C9E1 If the vischar_BYTE7_Y_DOMINANT flag is set then #R$C9FF is used instead of the code below, which is x dominant. i.e. It means "try moving y then x, rather than x then y". This is the code which makes characters alternate left/right when navigating.
C $C9E1,4 Does the vischar's counter_and_flags field have flag vischar_BYTE7_Y_DOMINANT set? ($20)
C $C9E5,2 Jump if so
@ $C9E7 label=cb_move_x_dominant
C $C9E7,3 Advance #REGhl to vischar.position.x
C $C9EA,3 Call vischar_move_x
C $C9ED,5 If it couldn't move call vischar_move_y
C $C9F2,3 If it still couldn't move exit via target_reached
N $C9F5 This entry point is used by the routine at #R$CA81.
@ $C9F5 label=cb_set_input
C $C9F5,3 Is our new input different from the vischar's existing input?
C $C9F8,1 Return if not
C $C9F9,5 Otherwise set the input_KICK flag
C $C9FE,1 Return
@ $C9FF label=cb_move_y_dominant
C $C9FF,4 Advance #REGhl to vischar.position.y
C $CA03,3 Call vischar_move_y
C $CA06,5 If it couldn't move call vischar_move_x
C $CA0B,2 If it could move, jump to cb_set_input
C $CA0D,1 Rewind #REGhl to vischar.position.x
C $CA0E,3 Exit via target_reached
;
c $CA11 Move a character on the X axis.
D $CA11 Used by the routine at #R$C918.
R $CA11 I:HL Pointer to vischar.target.
R $CA11 I:IY Pointer to visible character block.
R $CA11 O:A New input: input_RIGHT + input_DOWN (8) if x > pos.x, input_LEFT + input_UP (4) if x < pos.x, input_NONE (0) if x == pos.x
R $CA11 O:F Z set if zero returned, NZ otherwise
R $CA11 O:HL Pointer to visible character block + 5. (Ready to pass into vischar_move_y)
@ $CA11 label=vischar_move_x
C $CA11,1 Read vischar.target.x (target position)
C $CA12,3 Multiply it by 1, 4 or 8 (self modified by #R$C9DA)
C $CA15,4 Point #REGhl at vischar.mi.pos.x (current position)
C $CA19,3 Read vischar.mi.pos.x
C $CA1C,1 Free up #REGhl
C $CA1D,2 Compute the delta: current position - target position
C $CA1F,2 Jump if it's zero
C $CA21,3 Jump if it's negative
N $CA24 The delta was positive
@ $CA24 label=vmx_positive
C $CA24,2 Delta >= 256?
C $CA26,2 Jump if so
C $CA28,3 Delta < 3?
C $CA2B,2 Jump if it's in range
N $CA2D The delta was three or greater
@ $CA2D label=vmx_delta_too_big
C $CA2D,3 Return input_RIGHT + input_DOWN (6 + 2)
N $CA30 The delta was negative
@ $CA30 label=vmx_negative
C $CA30,3 Delta < -256?
C $CA33,2 Jump if so
C $CA35,3 Delta >= -2?
C $CA38,3 Jump if it's in range
N $CA3B The delta was less than negative three
@ $CA3B label=vmx_delta_too_small
C $CA3B,3 Return input_LEFT + input_UP (3 + 1)
N $CA3E The delta was -2..2
@ $CA3E label=vmx_equal
C $CA3E,1 Move vischar back into #REGhl
C $CA3F,4 Point #REGhl at vischar->mi.pos.x
C $CA43,4 Set vischar.counter_and_flags flag vischar_BYTE7_Y_DOMINANT so that next time we'll use #R$CA49 in preference
C $CA47,2 Return input_NONE (0)
;
c $CA49 Move a character on the Y axis.
D $CA49 Used by the routine at #R$C918.
D $CA49 Nearly identical to vischar_move_x above.
R $CA49 I:HL Pointer to vischar.target.
R $CA49 I:IY Pointer to visible character block.
R $CA49 O:A New input: input_LEFT + input_DOWN (5) if y > pos.y, input_RIGHT + input_UP (7) if y < pos.y, input_NONE (0) if y == pos.y
R $CA49 O:F Z set if zero returned, NZ otherwise
R $CA49 O:HL Pointer to visible character block + 4. (Ready to pass into vischar_move_x)
@ $CA49 label=vischar_move_y
C $CA49,1 Read vischar.target.y (target position)
C $CA4A,3 Multiply it by 1, 4 or 8 (self modified by #R$C9DD)
C $CA4D,4 Point #REGhl at vischar.mi.pos.y (current position)
C $CA51,3 Read vischar.mi.pos.y
C $CA54,1 Free up #REGhl
C $CA55,2 Compute the delta: current position - target position
C $CA57,2 Jump if it's zero
C $CA59,3 Jump if it's negative
N $CA5C The delta was positive
@ $CA5C label=vmy_positive
C $CA5C,2 Delta >= 256?
C $CA5E,2 Jump if so
C $CA60,3 Delta < 3?
C $CA63,2 Jump if it's in range
N $CA65 The delta was three or greater
@ $CA65 label=vmy_delta_too_big
C $CA65,3 Return input_LEFT + input_DOWN (3 + 2)
N $CA68 The delta was negative
@ $CA68 label=vmy_negative
C $CA68,3 Delta < -256?
C $CA6B,2 Jump if so
C $CA6D,3 Delta >= -2?
C $CA70,3 Jump if it's in range
N $CA73 The delta was less than negative three
@ $CA73 label=vmy_delta_too_small
C $CA73,3 Return input_RIGHT + input_UP (6 + 1)
N $CA76 The delta was -2..2
@ $CA76 label=vmy_equal
C $CA76,1 Move vischar back into #REGhl
C $CA77,4 Point #REGhl at vischar->mi.pos.y
C $CA7B,4 Clear vischar.counter_and_flags flag vischar_BYTE7_Y_DOMINANT so that next time we'll use #R$CA11 in preference
C $CA7F,2 Return input_NONE (0)
;
c $CA81 Called when a character reaches its target.
D $CA81 Used by the routine at #R$C918.
R $CA81 I:IY Pointer to a vischar
R $CA81 I:HL Pointer to vischar + 4 bytes
@ $CA81 label=target_reached
C $CA81,3 Fetch the vischar.flags
C $CA84,1 Copy to #REGc for the door check later
N $CA85 Check for a pursuit mode.
C $CA85,2 Mask with vischar_FLAGS_MASK to get the pursuit mode
C $CA87,2 Jump if not in a pursuit mode
N $CA89 We're in one of the pursuit modes - find out which one.
C $CA89,2 Is it vischar_PURSUIT_PURSUE?
C $CA8B,2 Jump if not
@ $CA8D label=tr_pursue
C $CA8D,6 Is this vischar the (pending) bribed character?
C $CA93,3 Jump to accept_bribe if so (exit via)
C $CA96,3 Otherwise the pursuing character caught its target. This must be the case when a guard pursues the hero, so send the hero to solitary (exit via)
@ $CA99 label=tr_not_pursue
C $CA99,2 Is it vischar_PURSUIT_HASSLE?
C $CA9B,1 Exit if so
C $CA9C,2 Is it vischar_PURSUIT_SAW_BRIBE?
C $CA9E,1 Exit if so
N $CA9F Otherwise we're in vischar_PURSUIT_DOG_FOOD mode. automatics() only permits dogs to enter this mode.
N $CA9F Decide how long remains until the food is discovered. Use 32 if the food is poisoned, 255 otherwise.
C $CA9F,1 Save the vischar pointer
@ $CAA0 nowarn
C $CAA0,3 Point #REGhl at item_structs_food
C $CAA3,2 Is the itemstruct_ITEM_FLAG_POISONED flag set?
C $CAA5,2 Set the counter to 32 irrespectively
C $CAA7,2 Jump if the flag was set
C $CAA9,2 Otherwise set the counter to 255
@ $CAAB label=tr_set_food_counter
C $CAAB,3 Assign food_discovered_counter
C $CAAE,1 Restore the vischar pointer
C $CAAF,2 Rewind #REGhl to point at vischar.route.index
N $CAB1 This dog has been poisoned, so make it halt.
C $CAB1,2 vischar.route.index = routeindex_0_HALT
C $CAB3,3 Exit via character_behaviour_set_input (#REGa is zero here: that's passed as the new input)
@ $CAB6 label=tr_door_check
C $CAB6,2 Is the flag vischar_FLAGS_TARGET_IS_DOOR set?
C $CAB8,2 Jump if not
N $CABA Handle the door - this results in the character entering.
C $CABA,1 Rewind #REGhl to point at vischar.route.step
C $CABB,1 Fetch route.step
C $CABC,1 Rewind
C $CABD,1 Fetch route.index
C $CABE,1 Preserve route pointer
C $CABF,3 Call get_route. #REGa is the index arg. A route *data* pointer is returned in #REGde
C $CAC2,1 Restore route pointer
C $CAC3,6 Advance the route data pointer by 'step' bytes
@ $CAC9 label=tr_routebyte_is_door
C $CAC9,1 Fetch a route byte, which here is a door index
C $CACA,2 Is the route index's route_REVERSED flag set? ($80)
C $CACC,2 Jump if not
C $CACE,2 Otherwise toggle the reverse flag
@ $CAD0 label=tr_store_door
C $CAD0,1 Preserve the door index
C $CAD1,1 Fetch route.index
C $CAD2,1 Advance to route.step
N $CAD3 Pattern: [-2]+1
@ $CAD9 label=tr_route_step
C $CAD3,7 If the route is reversed then step backwards, otherwise step forwards
N $CADA Get the door structure for the door index and start processing it.
C $CADA,1 Restore door index
C $CADB,3 Call get_door. A door_t pointer is returned in #REGhl
C $CADE,1 Fetch door.room_and_direction
C $CADF,2 Discard the bottom two bits
C $CAE1,2 Extract the room index
C $CAE3,3 Move the vischar to that room (vischar.room = room index)
N $CAE6 In which direction is the door facing?
C $CAE6,1 Fetch door.room_and_direction
C $CAE7,2 Mask against door_FLAGS_MASK_DIRECTION
N $CAE9 Each door in the doors array is a pair of two "half doors" where each half represents one side of the doorway. We test the direction of the half door we find ourselves pointing at and use it to find the counterpart door's position.
C $CAE9,2 Is it direction_TOP_*?
C $CAEB,3 Jump if not
C $CAEE,7 Point #REGhl at door[1].pos
@ $CAF5 label=tr_door_top
C $CAF5,3 Otherwise point #REGhl at door[-1].pos
@ $CAF8 label=tr_door_found
C $CAF8,1 Preserve the door.pos pointer
C $CAF9,3 Copy the current visible character pointer into #REGhl
C $CAFC,2 Is this vischar the hero?
C $CAFE,3 Jump if not
N $CB01 Hero's vischar only.
C $CB01,1 Advance #REGhl to point at vischar.flags
C $CB02,2 Clear vischar.flags vischar_FLAGS_TARGET_IS_DOOR flag
C $CB04,1 Advance #REGhl to point at vischar.route
C $CB05,3 Call get_target_assign_pos
@ $CB08 label=tr_transition
C $CB08,1 Restore the door.pos pointer
C $CB09,3 Call transition
C $CB0C,6 Play the "character enters 1" sound
C $CB12,1 Return
@ $CB13 label=tr_set_route
C $CB13,2 Point #REGhl at vischar.route.index
C $CB15,1 Load the route.index
C $CB16,2 Is it routeindex_255_WANDER?
C $CB18,2 Jump if so
C $CB1A,1 Advance #REGhl to vischar.route.step
N $CB1B Pattern: [-2]+1
@ $CB21 label=tr_another_route_step
C $CB1B,7 If the route is reversed then step backwards, otherwise step forwards
C $CB22,1 Rewind #REGhl to vischar.route.index
E $CA81 FALL THROUGH to get_target_assign_pos.
;
c $CB23 Calls get_target then puts coords in vischar.target and set flags.
D $CB23 Used by the routines at #R$A3BB, #R$B107, #R$C918, #R$CA81 and #R$CB2D.
R $CB23 I:HL Pointer to route
@ $CB23 label=get_target_assign_pos
C $CB23,1 Preserve the route pointer
C $CB24,3 Get our next target - a location, a door or 'route ends'. The result is returned in #REGa, target pointer returned in #REGhl
C $CB27,2 Did #R$C651 return get_target_ROUTE_ENDS? ($FF)
C $CB29,3 Jump if not
C $CB2C,1 Restore the route pointer
E $CB23 FALL THROUGH into route_ended.
;
c $CB2D Called when get_target has run out of route.
D $CB2D Used by the routine at #R$C4E0.
N $CB2D If not the hero's vischar ...
@ $CB2D label=route_ended
C $CB2D,3 Is this the hero's vischar?
C $CB30,3 Jump if so
N $CB33 Non-player ...
C $CB33,3 Load vischar.character
C $CB36,2 Mask with vischar_CHARACTER_MASK to get character index
C $CB38,2 Jump if not character_0_COMMANDANT
N $CB3A Call character_event at the end of commandant route 36.
C $CB3A,1 Fetch route.index
C $CB3B,2 Mask off routeindexflag_REVERSED
C $CB3D,2 Is it routeindex_36_GO_TO_SOLITARY?
C $CB3F,2 Jump if so
C $CB41,1 Force next if statement to be taken
N $CB42 Reverse the route for guards 1..11. They have fixed roles so either stand still or march back and forth along their route.
C $CB42,2 Is the character index <= character_11_GUARD_11?
C $CB44,2 Jump if so
N $CB46 We arrive here if: - vischar is the hero, or - character is character_0_COMMANDANT and (route.index & $7F) == 36, or - character is >= character_12_GUARD_12
@ $CB46 label=do_character_event
C $CB47,3 character_event()
C $CB4B,1 Fetch route.index
C $CB4C,1 Is it routeindex_0_HALT?
C $CB4D,1 Return 0 if so
C $CB4E,2 Otherwise exit via get_target_assign_pos() // re-enters/loops?
N $CB50 We arrive here if: - vischar is not the hero, and - character is character_0_COMMANDANT and (route.index & $7F) != 36, or - character is character_1_GUARD_1 .. character_11_GUARD_11
@ $CB50 label=reverse_route
C $CB50,5 Toggle route direction flag routeindexflag_REVERSED ($80)
N $CB55 Pattern: [-2]+1
C $CB55,8 If the route is reversed then step backwards, otherwise forwards
C $CB5D,2 Return 0
B $CB5F,2,2 Unreferenced bytes
;
c $CB61 "Didn't hit end of list" case. -- not really a routine in its own right
D $CB61 Used by the routine at #R$CB23.
@ $CB61 label=handle_target
C $CB61,2 Was the result of get_target get_target_DOOR? ($80)
C $CB63,3 Jump if not
C $CB66,4 Set vischar.flags flag vischar_FLAGS_TARGET_IS_DOOR
C $CB6A,1 Restore the route pointer
C $CB6B,7 Copy #REGhl (ptr to doorpos or location) to vischar->target
C $CB72,2 (This return value is never used)
C $CB74,1 Return
;
c $CB75 Widen #REGa to #REGbc (multiply by 1).
@ $CB75 label=multiply_by_1
C $CB75,3 Widen #REGa into #REGbc
C $CB78,1 Return
;
c $CB79 Return a route.
D $CB79 Used by the routines at #R$C651 and #R$CA81.
R $CB79 I:A Index.
R $CB79 O:DE Pointer to route data.
@ $CB79 label=get_route
C $CB79,11 Point #REGde at routes[#REGa]
C $CB84,1 Return
;
c $CB85 Pseudo-random number generator.
D $CB85 This returns the bottom nibbles of the bytes from $9000..$90FF in sequence, acting as a cheap pseudo-random number generator.
D $CB85 Used by the routine at #R$C651.
R $CB85 O:A Pseudo-random number from 0..15.
R $CB85 O:HL Preserved.
@ $CB85 label=random_nibble
C $CB85,1 Preserve #REGhl
C $CB86,3 Point at the prng_pointer (initialised on load to $9000)
C $CB89,1 Increment its bottom byte, wrapping at $90FF
C $CB8A,1 Fetch a byte from the pointer
C $CB8B,2 Mask off the bottom nibble
C $CB8D,3 Save the incremented prng_pointer
C $CB90,1 Restore #REGhl
C $CB91,1 Return
;
u $CB92 Unreferenced bytes.
B $CB92,6,6
;
c $CB98 Send the hero to solitary.
D $CB98 Used by the routines at #R$A51C, #R$AFDF, #R$CA81 and #R$EFCB.
R $CB98 Silence the bell.
@ $CB98 label=solitary
C $CB98,5 Set the bell ring counter/flag to bell_STOP
N $CB9D Seize hero's held items.
C $CB9D,3 Point #REGhl at items_held[0]
C $CBA0,1 Fetch the item
C $CBA1,1 Set it to item_NONE
C $CBA2,3 Discover the item
C $CBA5,3 Point #REGhl at items_held[1]
C $CBA8,1 Fetch the item
C $CBA9,2 Set it to item_NONE
C $CBAB,3 Discover the item
C $CBAE,3 Draw held items
N $CBB1 Discover all items.
C $CBB1,2 Set #REGb to 16 iterations - once per item
C $CBB3,3 Point #REGhl at item_structs[0].room
N $CBB6 Start loop
C $CBB6,1 Preserve loop counter
C $CBB7,1 Preserve itemstruct pointer
N $CBB8 Is the item outdoors?
C $CBB8,1 Fetch itemstruct.room_and_flags
C $CBB9,2 Mask off the room part. Is the item indoors?
C $CBBB,2 Jump if so
C $CBBD,1 Point #REGhl at itemstruct.item_and_flags
C $CBBE,1 Fetch it
C $CBBF,2 Advance #REGhl to itemstruct.pos.x
C $CBC1,1 Bank itemstruct pointer
C $CBC2,1 Bank item_and_flags
C $CBC3,1 Set area index to zero
N $CBC4 Start loop
C $CBC4,1 Preserve area index
C $CBC5,1 Preserve itemstruct pointer
N $CBC6 If the item is within the camp bounds then it will be discovered.
C $CBC6,3 Is the specified position within the bounds of the indexed area?
C $CBC9,2 Jump if so
C $CBCB,1 Restore itemstruct pointer
C $CBCC,1 Restore area index
C $CBCD,6 Loop until area index is 3
C $CBD3,2 Jump to next
@ $CBD5 label=solitary_discovered
C $CBD5,1 Restore itemstruct pointer
C $CBD6,1 Restore area index
C $CBD7,1 Unbank item_and_flags
C $CBD8,4 Discover the item
@ $CBDC label=solitary_next
C $CBDC,1 Restore itemstruct pointer
C $CBDD,1 Restore loop counter
C $CBDE,4 Advance #REGhl to the next itemstruct
C $CBE2,2 ...loop
N $CBE4 Move the hero to solitary.
C $CBE4,5 Set vischar[0].room to room_24_SOLITARY
N $CBE9 Commentary: This should instead be 24 which is the door between room_22_REDKEY and room_24_SOLITARY.
C $CBE9,5 Set the global current door to 20
C $CBEE,5 Decrease morale by 35
C $CBF3,3 Reset all visible characters, clock, day_or_night flag, general flags, collapsed tunnel objects, lock the gates, reset all beds, clear the mess halls and reset characters
N $CBF6 Set the commandant on a path which results in the hero being released.
C $CBF6,3 Point #REGde at character_structs[character_0_COMMANDANT].room
C $CBF9,3 Point #REGhl at solitary_commandant_data
C $CBFC,5 Copy six bytes
N $CC01 Queue solitary messages.
C $CC01,5 Queue the message "YOU ARE IN SOLITARY"
C $CC06,5 Queue the message "WAIT FOR RELEASE"
C $CC0B,5 Queue the message "ANOTHER DAY DAWNS"
C $CC10,5 Inhibit user input
C $CC15,4 Immediately take automatic control of the hero
C $CC19,6 Set vischar.mi.sprite to the prisoner sprite set
C $CC1F,3 Point #REGhl at solitary_pos for transition
C $CC22,4 Point #REGiy at the hero's vischar
C $CC26,4 Set vischar.direction to direction_BOTTOM_LEFT
C $CC2A,4 Set hero's route.index to routeindex_0_HALT
C $CC2E,3 Exit via transition
;
b $CC31 Partial character struct.
D $CC31 (<- solitary)
@ $CC31 label=solitary_commandant_data
B $CC31,1,1 room  = room_0_OUTDOORS
B $CC32,3,3 pos   = 116, 100, 3
B $CC35,2,2 route = 36, 0
;
c $CC37 Guards follow suspicious character.
D $CC37 This routine decides whether the given vischar pursues the hero. - The commandant can see through the hero's disguise if he's wearing the guard's uniform, but other guards do not. - Bribed characters will ignore the hero. - When outdoors, line of sight checking is used to determine if the hero will be pursued. - If the red_flag is in effect the hero will be pursued, otherwise he will just be hassled.
R $CC37 Used by the routine at #R$C892.
N $CC37 I:IY Pointer to visible character.
@ $CC37 label=guards_follow_suspicious_character
C $CC37,3 Copy vischar pointer into #REGhl
C $CC3A,1 Fetch the character index
N $CC3B Wearing the uniform stops anyone but the commandant from pursuing the hero.
C $CC3B,1 Is it character_0_COMMANDANT?
C $CC3C,2 Jump if so (the commandant sees through the disguise)
C $CC3E,3 Read the bottom byte of the hero's sprite set pointer
C $CC41,3 Point #REGde at the guard sprite set
C $CC44,2 Return if they match
N $CC46 If this (hostile) character saw the bribe being used then ignore the hero.
@ $CC46 label=gfsc_chk_bribe
C $CC46,1 Advance #REGhl to point at vischar.flags
C $CC47,1 Fetch vischar.flags
C $CC48,2 Is it vischar_PURSUIT_SAW_BRIBE?
C $CC4A,1 Return if the bribe was seen
N $CC4B Do line of sight checking when outdoors.
C $CC4B,1 Rewind #REGhl to point at vischar.character
C $CC4C,4 Point #REGhl at vischar.mi.pos
C $CC50,3 Point #REGde at tinypos_stash_x
C $CC53,7 If the global current room index is room_0_OUTDOORS...
C $CC5A,3 Scale down vischar's map position (#REGhl) and assign the result to tinypos_stash (#REGde). #REGde is updated to point after tinypos_stash on return
C $CC5D,3 Point #REGhl at hero_map_position.x
C $CC60,3 Point #REGde at tinypos_stash_x
C $CC63,3 Get this vischar's direction
N $CC66 Check for TL/BR directions.
C $CC66,1 Shift out the bottom direction bit into carry
C $CC67,1 Save (rotated direction byte) in #REGc
C $CC68,2 Jump if not TL or BR
N $CC6A Handle TL/BR directions.
N $CC6A Does the hero approximately match our Y coordinate?
@ $CC6A label=gfsc_chk_seen_y
C $CC6A,1 Advance #REGhl to hero_map_position.y
C $CC6B,1 Advance #REGde to tinypos_stash_y
C $CC6C,1 Fetch tinypos_stash_y
C $CC6D,3 Return if (tinypos_stash_y - 1) >= hero_map_position.y
C $CC70,4 Return if (tinypos_stash_y + 1) < hero_map_position.y
N $CC74 Are we facing the hero?
C $CC74,1 Rewind to hero_map_position_x
C $CC75,1 Rewind to tinypos_stash_x
C $CC76,2 Set carry if tinypos_stash_x < hero_map_position_x
C $CC78,2 Check bit 1 of direction byte (direction_BOTTOM_*?)
C $CC7A,2 Jump if set?
C $CC7C,1 Otherwise invert the carry flag
C $CC7D,1 Return if set
C $CC7E,2 (else)
N $CC80 Handle TR/BL directions.
N $CC80 Does the hero approximately match our X coordinate?
@ $CC80 label=gfsc_chk_seen_x
C $CC80,1 Fetch tinypos_stash_x
C $CC81,3 Return if (tinypos_stash_x - 1) >= hero_map_position_x
C $CC84,4 Return if (tinypos_stash_x + 1) < hero_map_position_x
N $CC88 Are we facing the hero?
C $CC88,1 Advance to hero_map_position_y
C $CC89,1 Advance to tinypos_stash_y
C $CC8A,2 Set carry if tinypos_stash_y < hero_map_position_y
C $CC8C,2 Check bit 1 of direction byte (direction_BOTTOM_*?)
C $CC8E,2 Jump if set?
C $CC90,1 Otherwise invert the carry flag
C $CC91,1 Return if set
@ $CC92 label=gfsc_chk_flag
C $CC92,4 Is red_flag set?
C $CC96,2 Jump if so
N $CC98 Hostiles *not* in guard towers hassle the hero.
C $CC98,3 Fetch vischar.mi.pos.height
C $CC9B,3 Return if it's 32 or greater
C $CC9E,4 Set vischar's flags to vischar_PURSUIT_HASSLE
C $CCA2,1 Return
@ $CCA3 label=gfsc_bell
C $CCA3,4 Make the bell ring perpetually
C $CCA7,3 Call hostiles_pursue
C $CCAA,1 Return
;
c $CCAB Hostiles pursue prisoners.
D $CCAB Used by the routines at #R$C892, #R$CC37, #R$CCCD and #R$EF9A.
D $CCAB For all visible, hostile characters, at height < 32, set the bribed/pursue flag.
D $CCAB Research: If I nop this out then guards don't spot the items I drop. Iterate non-player characters.
@ $CCAB label=hostiles_pursue
@ $CCAB nowarn
C $CCAB,3 Point #REGhl at the second vischar
C $CCAE,3 Prepare the vischar stride
C $CCB1,2 Set #REGb for seven iterations
N $CCB3 Start loop
@ $CCB3 label=hp_loop
C $CCB3,1 Preserve the vischar pointer
C $CCB4,1 Fetch vischar.character
N $CCB5 Include hostiles only.
C $CCB5,2 Is it character_20_PRISONER_1 or above?
C $CCB7,2 Jump if so
N $CCB9 Exclude the guards placed high up in towers and over the gate.
C $CCB9,4 Point #REGhl at vischar.mi.pos.height
C $CCBD,1 Fetch vischar.mi.pos.height
C $CCBE,2 Is it 32 or above?
C $CCC0,2 Jump if so
C $CCC2,4 Point #REGhl at vischar.flags
C $CCC6,2 Set vischar.flags to vischar_PURSUIT_PURSUE
@ $CCC8 label=hp_next
C $CCC8,1 Restore the vischar pointer
C $CCC9,1 Advance the vischar pointer
C $CCCA,2 ...loop
C $CCCC,1 Return
;
c $CCCD Is item discoverable?
D $CCCD Used by the routine at #R$C892.
D $CCCD Searches item_structs for items dropped nearby. If items are found the hostiles are made to pursue the hero.
D $CCCD Green key and food items are ignored.
@ $CCCD label=is_item_discoverable
C $CCCD,3 Get the global current room index
C $CCD0,1 Is it room_0_OUTDOORS?
C $CCD1,2 Jump if so
N $CCD3 Interior.
C $CCD3,3 Is the item discoverable indoors?
C $CCD6,1 Return if not found
N $CCD7 Item was found.
C $CCD7,3 Hostiles pursue prisoners
C $CCDA,1 Return
N $CCDB Exterior.
C $CCDB,3 Point #REGhl at item_structs[0].room
C $CCDE,3 Prepare the itemstruct stride
C $CCE1,2 Set #REGb for 16 iterations -- number of itemstructs
N $CCE3 Start loop
C $CCE3,2 Is itemstruct.item_and_flags itemstruct_ROOM_FLAG_NEARBY_7 flag set?
C $CCE5,2 Jump if so
@ $CCE7 label=iid_next
C $CCE7,1 Advance to the next itemstruct
C $CCE8,2 ..loop
C $CCEA,1 Return
N $CCEB Suspected bug: #REGhl is decremented, but not re-incremented before 'goto next'. So it must be reading a byte early when iteration is resumed. Consequences? I think it'll screw up when multiple items are in range.
@ $CCEB label=iid_nearby
C $CCEC,3 #REGa = *#REGhl & itemstruct_ITEM_MASK; // sampled HL=$772A (&item_structs[item_PURSE].item)
N $CCEF The green key and food items are ignored.
C $CCEF,2 Is it item_GREEN_KEY?
C $CCF1,2 Jump to next iteration if so
C $CCF3,2 Is it item_FOOD?
C $CCF5,2 Jump to next iteration if so
C $CCF7,3 Otherwise, hostiles pursue prisoners
C $CCFA,1 Return
;
c $CCFB Is an item discoverable indoors?
D $CCFB A discoverable item is one which has been moved away from its default room, and one that isn't the red cross parcel.
D $CCFB Used by the routines at #R$C6A0 and #R$CCCD.
R $CCFB I:A Room index to check against
R $CCFB O:C Item (if found)
R $CCFB O:F Z set if found, Z clear otherwise
@ $CCFB label=is_item_discoverable_interior
C $CCFB,1 Save the room index in #REGc
C $CCFC,3 Point #REGhl at the first item_struct's room member
C $CCFF,2 Set #REGb for 16 iterations (item__LIMIT)
N $CD01 Start loop
@ $CD01 label=iidi_loop
C $CD01,1 Load the room index and flags
C $CD02,2 Extract the room index
N $CD04 Is the item in the specified room?
C $CD04,1 Same room?
C $CD05,2 Jump if not
C $CD07,1 Preserve the item_struct pointer
N $CD08 Has the item been moved to a room other than its default?
N $CD08 Bug: room_and_flags doesn't get its flags masked off in the following sequence. However, the only default_item which uses the flags is the wiresnips. The DOS version of the game fixes this.
C $CD08,2 Fetch item_and_flags
C $CD0A,2 Mask off the item
C $CD0C,3 Multiply by three - the array stride
C $CD0F,3 Widen to 16-bit
C $CD12,4 Add to default_item_locations
C $CD16,1 Fetch the default item room_and_flags
C $CD17,1 Same room? (bug: not masked)
C $CD18,2 Jump if not
C $CD1A,1 Restore the item_struct pointer
@ $CD1B label=iidi_next
C $CD1B,4 Step #REGhl to the next item_struct
C $CD1F,2 ...loop
C $CD21,1 Return with NZ set (not found)
@ $CD22 label=iidi_not_default_room
C $CD22,1 Restore the item_struct pointer
C $CD23,2 Fetch item_and_flags
C $CD25,2 Mask off the item
N $CD27 Ignore the red cross parcel.
C $CD27,2 Is this item the red cross parcel? (item_RED_CROSS_PARCEL)
C $CD29,2 Jump if not
C $CD2B,1 Otherwise advance #REGhl to room_and_flags
C $CD2C,2 Jump to the next iteration
@ $CD2E label=iidi_found
C $CD2E,1 Return the item's index in #REGc
C $CD2F,2 Return with Z set (found)
;
c $CD31 An item is discovered.
D $CD31 Used by the routines at #R$B75A, #R$C6A0, #R$C892 and #R$CB98.
R $CD31 I:C Item index.
@ $CD31 label=item_discovered
C $CD31,1 Copy item index to #REGa
C $CD32,2 Is it item_NONE? ($FF)
C $CD34,1 Return if so
C $CD35,2 Mask against itemstruct_ITEM_MASK
C $CD37,1 Preserve #REGa while we do calls
C $CD38,5 Queue the message "ITEM DISCOVERED"
C $CD3D,5 Decrease morale by 5
C $CD42,1 Restore #REGa
C $CD43,9 Point #REGhl at default_item_locations[#REGa]
C $CD4C,1 Load default_item_location.room_and_flags
C $CD4D,1 Bank default_item_location pointer
C $CD4E,1 Bank room_and_flags
N $CD4F Bug: #REGc is not masked, so could go out of range.
C $CD4F,1 Copy item index to #REGa
C $CD50,3 Convert the item index into an itemstruct pointer in #REGhl
C $CD53,2 Wipe the itemstruct.item_and_flags itemstruct_ITEM_FLAG_HELD flag
C $CD55,1 Unbank default_item_location pointer
C $CD56,1 Advance #REGde to itemstruct.room_and_flags
C $CD57,5 Copy room_and_flags and pos from default_item_location
C $CD5C,1 Swap itemstruct pointer back into #REGhl
C $CD5D,1 Unbank room_and_flags
C $CD5E,1 Is it room_0_OUTDOORS?
C $CD5F,2 Jump if not
C $CD61,1 Set height to zero. Note #REGa is already zero
C $CD62,3 Exit via calc_exterior_item_iso_pos
@ $CD65 label=id_interior
C $CD65,2 Set height to 5
C $CD67,3 Exit via calc_interior_item_iso_pos
;
b $CD6A Default locations of items.
D $CD6A An array of 16 three-byte structures.
D $CD6A #TABLE(default) { =h Type | =h Bytes | =h Name        | =h Meaning } { Byte    |        1 | room_and_flags | Room index; bits 6,7 = flags (T.B.D.) } { Byte    |        1 | x              | X position  } { Byte    |        1 | y              | Y position  } TABLE#
D $CD6A #define ITEM_ROOM(room_no, flags) ((room_no & 0x3F) | (flags << 6)) do the next flags mean that the wiresnips are always or /never/ found?
@ $CD6A label=default_item_locations
B $CD6A,3,3 item_WIRESNIPS        { ITEM_ROOM(room_NONE, 3), ... }
B $CD6D,3,3 item_SHOVEL           { ITEM_ROOM(room_9, 0), ... }
B $CD70,3,3 item_LOCKPICK         { ITEM_ROOM(room_10, 0), ... }
B $CD73,3,3 item_PAPERS           { ITEM_ROOM(room_11, 0), ... }
B $CD76,3,3 item_TORCH            { ITEM_ROOM(room_14, 0), ... }
B $CD79,3,3 item_BRIBE            { ITEM_ROOM(room_NONE, 0), ... }
B $CD7C,3,3 item_UNIFORM          { ITEM_ROOM(room_15, 0), ... }
B $CD7F,3,3 item_FOOD             { ITEM_ROOM(room_19, 0), ... }
B $CD82,3,3 item_POISON           { ITEM_ROOM(room_1, 0), ... }
B $CD85,3,3 item_RED_KEY          { ITEM_ROOM(room_22, 0), ... }
B $CD88,3,3 item_YELLOW_KEY       { ITEM_ROOM(room_11, 0), ... }
B $CD8B,3,3 item_GREEN_KEY        { ITEM_ROOM(room_0_OUTDOORS, 0), ... }
B $CD8E,3,3 item_RED_CROSS_PARCEL { ITEM_ROOM(room_NONE, 0), ... }
B $CD91,3,3 item_RADIO            { ITEM_ROOM(room_18, 0), ... }
B $CD94,3,3 item_PURSE            { ITEM_ROOM(room_NONE, 0), ... }
B $CD97,3,3 item_COMPASS          { ITEM_ROOM(room_NONE, 0), ... }
;
w $CD9A Data for the four classes of characters. (<- spawn_character)
@ $CD9A label=character_meta_data_commandant
W $CD9A,2,2 &animations[0]
W $CD9C,2,2 sprite_commandant
@ $CD9E label=character_meta_data_guard
W $CD9E,2,2 &animations[0]
W $CDA0,2,2 sprite_guard
@ $CDA2 label=character_meta_data_dog
W $CDA2,2,2 &animations[0]
W $CDA4,2,2 sprite_dog
@ $CDA6 label=character_meta_data_prisoner
W $CDA6,2,2 &animations[0]
W $CDA8,2,2 sprite_prisoner
;
b $CDAA Indices into animations.
D $CDAA none, up, down, left, up+left, down+left, right, up+right, down+right, fire
D $CDAA Groups of nine. (<- animate)
@ $CDAA label=animindices
B $CDAA,9,9 TL
B $CDB3,9,9 TR
B $CDBC,9,9 BR
B $CDC5,9,9 BL
B $CDCE,9,9 TL + crawl
B $CDD7,9,9 TR + crawl
B $CDE0,9,9 BR + crawl
B $CDE9,9,9 BL + crawl
;
w $CDF2 Animation states.
D $CDF2 Array, 24 long, of pointers to data.
@ $CDF2 label=animations
W $CDF2,2,2 anim_walk_tl
W $CDF4,2,2 anim_walk_tr
W $CDF6,2,2 anim_walk_br
W $CDF8,2,2 anim_walk_bl
W $CDFA,2,2 anim_turn_tl
W $CDFC,2,2 anim_turn_tr
W $CDFE,2,2 anim_turn_br
W $CE00,2,2 anim_turn_bl
W $CE02,2,2 anim_wait_tl
W $CE04,2,2 anim_wait_tr
W $CE06,2,2 anim_wait_br
W $CE08,2,2 anim_wait_bl
W $CE0A,2,2 anim_crawl_tl
W $CE0C,2,2 anim_crawl_tr
W $CE0E,2,2 anim_crawl_br
W $CE10,2,2 anim_crawl_bl
W $CE12,2,2 anim_crawlturn_tl
W $CE14,2,2 anim_crawlturn_tr
W $CE16,2,2 anim_crawlturn_br
W $CE18,2,2 anim_crawlturn_bl
W $CE1A,2,2 anim_crawlwait_tl
W $CE1C,2,2 anim_crawlwait_tr
W $CE1E,2,2 anim_crawlwait_br
W $CE20,2,2 anim_crawlwait_bl
;
b $CE22 Sprites: objects which can move.
D $CE22 This include STOVE, CRATE, PRISONER, CRAWL, DOG, GUARD and COMMANDANT.
D $CE22 Structure: (b) width in bytes + 1, (b) height in rows, (w) data ptr, (w) mask ptr
D $CE22 'tl' => character faces top left of the screen
D $CE22 'br' => character faces bottom right of the screen
@ $CE22 label=sprites
@ $CE22 label=sprite_stove
B $CE22,6,6 3, 22, &bitmap_stove, &mask_stove } // (16x22,$DB46,$DB72)
@ $CE28 label=sprite_crate
B $CE28,6,6 4, 24, &bitmap_crate, &mask_crate } // (24x24,$DAB6,$DAFE)
N $CE2E Glitch: All of the prisoner sprites are one row too high.
@ $CE2E label=sprite_prisoner
B $CE2E,6,6 3, 27, &bitmap_prisoner_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x27,$D28C,$D545)
B $CE34,6,6 3, 28, &bitmap_prisoner_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x28,$D256,$D505)
B $CE3A,6,6 3, 28, &bitmap_prisoner_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x28,$D220,$D4C5)
B $CE40,6,6 3, 28, &bitmap_prisoner_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x28,$D1EA,$D485)
B $CE46,6,6 3, 27, &bitmap_prisoner_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x27,$D2C0,$D585)
B $CE4C,6,6 3, 29, &bitmap_prisoner_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x29,$D2F4,$D5C5)
B $CE52,6,6 3, 28, &bitmap_prisoner_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x28,$D32C,$D605)
B $CE58,6,6 3, 28, &bitmap_prisoner_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D362,$D63D)
B $CE5E,6,6 4, 16, &bitmap_crawl_facing_bottom_left_1, &mask_crawl_facing_bottom_left } // (24x16,$D3C5,$D677)
B $CE64,6,6 4, 15, &bitmap_crawl_facing_bottom_left_2, &mask_crawl_facing_bottom_left } // (24x15,$D398,$D677)
B $CE6A,6,6 4, 16, &bitmap_crawl_facing_top_left_1, &mask_crawl_facing_top_left } // (24x16,$D3F5,$D455)
B $CE70,6,6 4, 16, &bitmap_crawl_facing_top_left_2, &mask_crawl_facing_top_left } // (24x16,$D425,$D455)
@ $CE76 label=sprite_dog
B $CE76,6,6 4, 16, &bitmap_dog_facing_top_left_1, &mask_dog_facing_top_left } // (24x16,$D867,$D921)
B $CE7C,6,6 4, 16, &bitmap_dog_facing_top_left_2, &mask_dog_facing_top_left } // (24x16,$D897,$D921)
B $CE82,6,6 4, 15, &bitmap_dog_facing_top_left_3, &mask_dog_facing_top_left } // (24x15,$D8C7,$D921)
B $CE88,6,6 4, 15, &bitmap_dog_facing_top_left_4, &mask_dog_facing_top_left } // (24x15,$D8F4,$D921)
B $CE8E,6,6 4, 14, &bitmap_dog_facing_bottom_right_1, &mask_dog_facing_bottom_right } // (24x14,$D951,$D9F9)
B $CE94,6,6 4, 15, &bitmap_dog_facing_bottom_right_2, &mask_dog_facing_bottom_right } // (24x15,$D97B,$D9F9)
N $CE9A Glitch: The height of following sprite is two rows too high.
B $CE9A,6,6 4, 15, &bitmap_dog_facing_bottom_right_3, &mask_dog_facing_bottom_right } // (24x15,$D9A8,$D9F9)
B $CEA0,6,6 4, 14, &bitmap_dog_facing_bottom_right_4, &mask_dog_facing_bottom_right } // (24x14,$D9CF,$D9F9)
@ $CEA6 label=sprite_guard
B $CEA6,6,6 3, 27, &bitmap_guard_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x27,$D74D,$D545)
B $CEAC,6,6 3, 29, &bitmap_guard_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x29,$D713,$D505)
B $CEB2,6,6 3, 27, &bitmap_guard_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x27,$D6DD,$D4C5)
B $CEB8,6,6 3, 27, &bitmap_guard_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x27,$D6A7,$D485)
B $CEBE,6,6 3, 29, &bitmap_guard_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x29,$D783,$D585)
B $CEC4,6,6 3, 29, &bitmap_guard_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x29,$D7BD,$D5C5)
B $CECA,6,6 3, 28, &bitmap_guard_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x28,$D7F7,$D605)
B $CED0,6,6 3, 28, &bitmap_guard_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D82F,$D63D)
@ $CED6 label=sprite_commandant
B $CED6,6,6 3, 28, &bitmap_commandant_facing_top_left_1, &mask_various_facing_top_left_1 } // (16x28,$D0D6,$D545)
B $CEDC,6,6 3, 30, &bitmap_commandant_facing_top_left_2, &mask_various_facing_top_left_2 } // (16x30,$D09A,$D505)
B $CEE2,6,6 3, 29, &bitmap_commandant_facing_top_left_3, &mask_various_facing_top_left_3 } // (16x29,$D060,$D4C5)
B $CEE8,6,6 3, 29, &bitmap_commandant_facing_top_left_4, &mask_various_facing_top_left_4 } // (16x29,$D026,$D485)
B $CEEE,6,6 3, 27, &bitmap_commandant_facing_bottom_right_1, &mask_various_facing_bottom_right_1 } // (16x27,$D10E,$D585)
B $CEF4,6,6 3, 28, &bitmap_commandant_facing_bottom_right_2, &mask_various_facing_bottom_right_2 } // (16x28,$D144,$D5C5)
B $CEFA,6,6 3, 27, &bitmap_commandant_facing_bottom_right_3, &mask_various_facing_bottom_right_3 } // (16x27,$D17C,$D605)
B $CF00,6,6 3, 28, &bitmap_commandant_facing_bottom_right_4, &mask_various_facing_bottom_right_4 } // (16x28,$D1B2,$D63D)
;
b $CF06 Animations.
D $CF06 Read by routine around $B64F (animate)
@ $CF06 label=anim_crawlwait_tl
@ $CF0E label=anim_crawlwait_tr
@ $CF16 label=anim_crawlwait_br
@ $CF1E label=anim_crawlwait_bl
@ $CF26 label=anim_walk_tl
@ $CF3A label=anim_walk_tr
@ $CF4E label=anim_walk_br
@ $CF62 label=anim_walk_bl
@ $CF76 label=anim_wait_tl
@ $CF7E label=anim_wait_tr
@ $CF86 label=anim_wait_br
@ $CF8E label=anim_wait_bl
@ $CF96 label=anim_turn_tl
@ $CFA2 label=anim_turn_tr
@ $CFAE label=anim_turn_br
@ $CFBA label=anim_turn_bl
@ $CFC6 label=anim_crawl_tl
@ $CFD2 label=anim_crawl_tr
@ $CFDE label=anim_crawl_br
@ $CFEA label=anim_crawl_bl
@ $CFF6 label=anim_crawlturn_tl
@ $D002 label=anim_crawlturn_tr
@ $D00E label=anim_crawlturn_br
@ $D01A label=anim_crawlturn_bl
B $CF06,288,8*4,20*4,8*4,12
;
b $D026 Sprite bitmaps and masks.
D $D026 #UDGTABLE { #UDGARRAY2,7,4,2;$D026-$D05F-1-16{0,0,64,116}(bitmap-commandant-facing-top-left-1) } TABLE#
@ $D026 label=bitmap_commandant_facing_top_left_4
B $D026,58,8*7,2 bitmap: COMMANDANT FACING TOP LEFT 4
N $D060 #UDGTABLE { #UDGARRAY2,7,4,2;$D060-$D099-1-16{0,0,64,116}(bitmap-commandant-facing-top-left-2) } TABLE#
@ $D060 label=bitmap_commandant_facing_top_left_3
B $D060,58,8*7,2 bitmap: COMMANDANT FACING TOP LEFT 3
N $D09A #UDGTABLE { #UDGARRAY2,7,4,2;$D09A-$D0D5-1-16{0,0,64,120}(bitmap-commandant-facing-top-left-3) } TABLE#
@ $D09A label=bitmap_commandant_facing_top_left_2
B $D09A,60,8*7,4 bitmap: COMMANDANT FACING TOP LEFT 2
N $D0D6 #UDGTABLE { #UDGARRAY2,7,4,2;$D0D6-$D10E-1-16{0,0,64,112}(bitmap-commandant-facing-top-left-4) } TABLE#
@ $D0D6 label=bitmap_commandant_facing_top_left_1
B $D0D6,56,8 bitmap: COMMANDANT FACING TOP LEFT 1
N $D10E #UDGTABLE { #UDGARRAY2,7,4,2;$D10E-$D143-1-16{0,0,64,108}(bitmap-commandant-facing-bottom-right-1) } TABLE#
@ $D10E label=bitmap_commandant_facing_bottom_right_1
B $D10E,54,8*6,6 bitmap: COMMANDANT FACING BOTTOM RIGHT 1
N $D144 #UDGTABLE { #UDGARRAY2,7,4,2;$D144-$D17B-1-16{0,0,64,112}(bitmap-commandant-facing-bottom-right-2) } TABLE#
@ $D144 label=bitmap_commandant_facing_bottom_right_2
B $D144,56,8 bitmap: COMMANDANT FACING BOTTOM RIGHT 2
N $D17C #UDGTABLE { #UDGARRAY2,7,4,2;$D17C-$D1B1-1-16{0,0,64,108}(bitmap-commandant-facing-bottom-right-3) } TABLE#
@ $D17C label=bitmap_commandant_facing_bottom_right_3
B $D17C,54,8*6,6 bitmap: COMMANDANT FACING BOTTOM RIGHT 3
N $D1B2 #UDGTABLE { #UDGARRAY2,7,4,2;$D1B2-$D1E9-1-16{0,0,64,112}(bitmap-commandant-facing-bottom-right-4) } TABLE#
@ $D1B2 label=bitmap_commandant_facing_bottom_right_4
B $D1B2,56,8 bitmap: COMMANDANT FACING BOTTOM RIGHT 4
N $D1EA #UDGTABLE { #UDGARRAY2,7,4,2;$D1EA-$D21F-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-1) } TABLE#
@ $D1EA label=bitmap_prisoner_facing_top_left_4
B $D1EA,54,8*6,6 bitmap: PRISONER FACING TOP LEFT 4
N $D220 #UDGTABLE { #UDGARRAY2,7,4,2;$D220-$D255-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-2) } TABLE#
@ $D220 label=bitmap_prisoner_facing_top_left_3
B $D220,54,8*6,6 bitmap: PRISONER FACING TOP LEFT 3
N $D256 #UDGTABLE { #UDGARRAY2,7,4,2;$D256-$D28B-1-16{0,0,64,108}(bitmap-prisoner-facing-top-left-3) } TABLE#
@ $D256 label=bitmap_prisoner_facing_top_left_2
B $D256,54,8*6,6 bitmap: PRISONER FACING TOP LEFT 2
N $D28C #UDGTABLE { #UDGARRAY2,7,4,2;$D28C-$D2BF-1-16{0,0,64,104}(bitmap-prisoner-facing-top-left-4) } TABLE#
@ $D28C label=bitmap_prisoner_facing_top_left_1
B $D28C,52,8*6,4 bitmap: PRISONER FACING TOP LEFT 1
N $D2C0 #UDGTABLE { #UDGARRAY2,7,4,2;$D2C0-$D2F3-1-16{0,0,64,104}(bitmap-prisoner-facing-bottom-right-1) } TABLE#
@ $D2C0 label=bitmap_prisoner_facing_bottom_right_1
B $D2C0,52,8*6,4 bitmap: PRISONER FACING BOTTOM RIGHT 1
N $D2F4 #UDGTABLE { #UDGARRAY2,7,4,2;$D2F4-$D32B-1-16{0,0,64,112}(bitmap-prisoner-facing-bottom-right-2) } TABLE#
@ $D2F4 label=bitmap_prisoner_facing_bottom_right_2
B $D2F4,56,8 bitmap: PRISONER FACING BOTTOM RIGHT 2
N $D32C #UDGTABLE { #UDGARRAY2,7,4,2;$D32C-$D361-1-16{0,0,64,108}(bitmap-prisoner-facing-bottom-right-3) } TABLE#
@ $D32C label=bitmap_prisoner_facing_bottom_right_3
B $D32C,54,8*6,6 bitmap: PRISONER FACING BOTTOM RIGHT 3
N $D362 #UDGTABLE { #UDGARRAY2,7,4,2;$D362-$D397-1-16{0,0,64,108}(bitmap-prisoner-facing-bottom-right-4) } TABLE#
@ $D362 label=bitmap_prisoner_facing_bottom_right_4
B $D362,54,8*6,6 bitmap: PRISONER FACING BOTTOM RIGHT 4
N $D398 #UDGTABLE { #UDGARRAY3,7,4,3;$D398-$D3C4-1-24{0,0,96,60}(bitmap-crawl-facing-bottom-right-1) } TABLE#
@ $D398 label=bitmap_crawl_facing_bottom_left_2
B $D398,45,8*5,5 bitmap: CRAWL FACING BOTTOM RIGHT 2
N $D3C5 #UDGTABLE { #UDGARRAY3,7,4,3;$D3C5-$D3F4-1-24{0,0,96,64}(bitmap-crawl-facing-bottom-right-2) } TABLE#
@ $D3C5 label=bitmap_crawl_facing_bottom_left_1
B $D3C5,48,8 bitmap: CRAWL FACING BOTTOM RIGHT 1
N $D3F5 #UDGTABLE { #UDGARRAY3,7,4,3;$D3F5-$D424-1-24{0,0,96,64}(bitmap-crawl-facing-top-left-1) } TABLE#
@ $D3F5 label=bitmap_crawl_facing_top_left_1
B $D3F5,48,8 bitmap: CRAWL FACING TOP LEFT 1
N $D425 #UDGTABLE { #UDGARRAY3,7,4,3;$D425-$D454-1-24{0,0,96,64}(bitmap-crawl-facing-top-left-2) } TABLE#
@ $D425 label=bitmap_crawl_facing_top_left_2
B $D425,48,8 bitmap: CRAWL FACING TOP LEFT 2
N $D455 #UDGTABLE { #UDGARRAY3,7,4,3;$D455-$D484-1-24{0,0,96,64}(mask-crawl-facing-top-left) } TABLE#
@ $D455 label=mask_crawl_facing_top_left
B $D455,48,8 mask: CRAWL FACING TOP LEFT (shared)
N $D485 #UDGTABLE { #UDGARRAY2,7,4,2;$D485-$D4C4-1-16(mask-various-facing-top-left-1) } TABLE#
@ $D485 label=mask_various_facing_top_left_4
B $D485,64,8 mask: VARIOUS FACING TOP LEFT 4
N $D4C5 #UDGTABLE { #UDGARRAY2,7,4,2;$D4C5-$D504-1-16(mask-various-facing-top-left-2) } TABLE#
@ $D4C5 label=mask_various_facing_top_left_3
B $D4C5,64,8 mask: VARIOUS FACING TOP LEFT 3
N $D505 #UDGTABLE { #UDGARRAY2,7,4,2;$D505-$D544-1-16(mask-various-facing-top-left-3) } TABLE#
@ $D505 label=mask_various_facing_top_left_2
B $D505,64,8 mask: VARIOUS FACING TOP LEFT 2
N $D545 #UDGTABLE { #UDGARRAY2,7,4,2;$D545-$D584-1-16(mask-various-facing-top-left-4) } TABLE#
@ $D545 label=mask_various_facing_top_left_1
B $D545,64,8 mask: VARIOUS FACING TOP LEFT 1
N $D585 #UDGTABLE { #UDGARRAY2,7,4,2;$D585-$D5C4-1-16(mask-various-facing-bottom-right-1) } TABLE#
@ $D585 label=mask_various_facing_bottom_right_1
B $D585,64,8 mask: VARIOUS FACING BOTTOM RIGHT 1
N $D5C5 #UDGTABLE { #UDGARRAY2,7,4,2;$D5C5-$D604-1-16(mask-various-facing-bottom-right-2) } TABLE#
@ $D5C5 label=mask_various_facing_bottom_right_2
B $D5C5,64,8 mask: VARIOUS FACING BOTTOM RIGHT 2
N $D605 #UDGTABLE { #UDGARRAY2,7,4,2;$D605-$D63C-1-16{0,0,64,112}(mask-various-facing-bottom-right-3) } TABLE#
@ $D605 label=mask_various_facing_bottom_right_3
B $D605,56,8 mask: VARIOUS FACING BOTTOM RIGHT 3
N $D63D #UDGTABLE { #UDGARRAY2,7,4,2;$D63D-$D676-1-16{0,0,64,116}(mask-various-facing-bottom-right-4) } TABLE#
@ $D63D label=mask_various_facing_bottom_right_4
B $D63D,58,8*7,2 mask: VARIOUS FACING BOTTOM RIGHT 4
N $D677 #UDGTABLE { #UDGARRAY3,7,4,3;$D677-$D6A6-1-24(mask-crawl-facing-bottom-left) } TABLE#
@ $D677 label=mask_crawl_facing_bottom_left
B $D677,48,8 mask: CRAWL FACING BOTTOM RIGHT (shared)
N $D6A7 #UDGTABLE { #UDGARRAY2,7,4,2;$D6A7-$D6DC-1-16{0,0,64,108}(bitmap-guard-facing-top-left-1) } TABLE#
@ $D6A7 label=bitmap_guard_facing_top_left_4
B $D6A7,54,8*6,6 bitmap: GUARD FACING TOP LEFT 4
N $D6DD #UDGTABLE { #UDGARRAY2,7,4,2;$D6DD-$D712-1-16{0,0,64,108}(bitmap-guard-facing-top-left-2) } TABLE#
@ $D6DD label=bitmap_guard_facing_top_left_3
B $D6DD,54,8*6,6 bitmap: GUARD FACING TOP LEFT 3
N $D713 #UDGTABLE { #UDGARRAY2,7,4,2;$D713-$D74C-1-16{0,0,64,116}(bitmap-guard-facing-top-left-3) } TABLE#
@ $D713 label=bitmap_guard_facing_top_left_2
B $D713,58,8*7,2 bitmap: GUARD FACING TOP LEFT 2
N $D74D #UDGTABLE { #UDGARRAY2,7,4,2;$D74D-$D782-1-16{0,0,64,108}(bitmap-guard-facing-top-left-4) } TABLE#
@ $D74D label=bitmap_guard_facing_top_left_1
B $D74D,54,8*6,6 bitmap: GUARD FACING TOP LEFT 1
N $D783 #UDGTABLE { #UDGARRAY2,7,4,2;$D783-$D7BC-1-16{0,0,64,116}(bitmap-guard-facing-bottom-right-1) } TABLE#
@ $D783 label=bitmap_guard_facing_bottom_right_1
B $D783,58,8*7,2 bitmap: GUARD FACING BOTTOM RIGHT 1
N $D7BD #UDGTABLE { #UDGARRAY2,7,4,2;$D7BD-$D7F6-1-16{0,0,64,116}(bitmap-guard-facing-bottom-right-2) } TABLE#
@ $D7BD label=bitmap_guard_facing_bottom_right_2
B $D7BD,58,8*7,2 bitmap: GUARD FACING BOTTOM RIGHT 2
N $D7F7 #UDGTABLE { #UDGARRAY2,7,4,2;$D7F7-$D82E-1-16{0,0,64,112}(bitmap-guard-facing-bottom-right-3) } TABLE#
@ $D7F7 label=bitmap_guard_facing_bottom_right_3
B $D7F7,56,8 bitmap: GUARD FACING BOTTOM RIGHT 3
N $D82F #UDGTABLE { #UDGARRAY2,7,4,2;$D82F-$D866-1-16{0,0,64,112}(bitmap-guard-facing-bottom-right-4) } TABLE#
@ $D82F label=bitmap_guard_facing_bottom_right_4
B $D82F,56,8 bitmap: GUARD FACING BOTTOM RIGHT 4
N $D867 #UDGTABLE { #UDGARRAY3,7,4,3;$D867-$D896-1-24{0,0,96,64}(bitmap-dog-facing-top-left-1) } TABLE#
@ $D867 label=bitmap_dog_facing_top_left_1
B $D867,48,8 bitmap: DOG FACING TOP LEFT 1
N $D897 #UDGTABLE { #UDGARRAY3,7,4,3;$D897-$D8C6-1-24{0,0,96,64}(bitmap-dog-facing-top-left-2) } TABLE#
@ $D897 label=bitmap_dog_facing_top_left_2
B $D897,48,8 bitmap: DOG FACING TOP LEFT 2
N $D8C7 #UDGTABLE { #UDGARRAY3,7,4,3;$D8C7-$D8F3-1-24{0,0,96,60}(bitmap-dog-facing-top-left-3) } TABLE#
@ $D8C7 label=bitmap_dog_facing_top_left_3
B $D8C7,45,8*5,5 bitmap: DOG FACING TOP LEFT 3
N $D8F4 #UDGTABLE { #UDGARRAY3,7,4,3;$D8F4-$D920-1-24{0,0,96,60}(bitmap-dog-facing-top-left-4) } TABLE#
@ $D8F4 label=bitmap_dog_facing_top_left_4
B $D8F4,45,8*5,5 bitmap: DOG FACING TOP LEFT 4
N $D921 #UDGTABLE { #UDGARRAY3,7,4,3;$D921-$D950-1-24(mask-dog-facing-top-left) } TABLE#
@ $D921 label=mask_dog_facing_top_left
B $D921,48,8 mask: DOG FACING TOP LEFT (shared)
N $D951 #UDGTABLE { #UDGARRAY3,7,4,3;$D951-$D97A-1-24{0,0,96,56}(bitmap-dog-facing-bottom-right-1) } TABLE#
@ $D951 label=bitmap_dog_facing_bottom_right_1
B $D951,42,8*5,2 bitmap: DOG FACING BOTTOM RIGHT 1
N $D97B #UDGTABLE { #UDGARRAY3,7,4,3;$D97B-$D9A7-1-24{0,0,96,60}(bitmap-dog-facing-bottom-right-2) } TABLE#
@ $D97B label=bitmap_dog_facing_bottom_right_2
B $D97B,45,8*5,5 bitmap: DOG FACING BOTTOM RIGHT 2
N $D9A8 #UDGTABLE { #UDGARRAY3,7,4,3;$D9A8-$D9CE-1-24{0,0,96,60}(bitmap-dog-facing-bottom-right-3) } TABLE#
@ $D9A8 label=bitmap_dog_facing_bottom_right_3
B $D9A8,39,8*4,7 bitmap: DOG FACING BOTTOM RIGHT 3
N $D9CF #UDGTABLE { #UDGARRAY3,7,4,3;$D9CF-$D9F8-1-24{0,0,96,56}(bitmap-dog-facing-bottom-right-4) } TABLE#
@ $D9CF label=bitmap_dog_facing_bottom_right_4
B $D9CF,42,8*5,2 bitmap: DOG FACING BOTTOM RIGHT 4
N $D9F9 #UDGTABLE { #UDGARRAY3,7,4,3;$D9F9-$DA28-1-24(mask-dog-facing-bottom-right) } TABLE#
@ $D9F9 label=mask_dog_facing_bottom_right
B $D9F9,48,8 mask: DOG FACING BOTTOM RIGHT (shared)
N $DA29 #UDGTABLE { #UDGARRAY3,7,4,3;$DA29-$DA6A-1-24{0,0,96,96}(flag-up) } TABLE#
@ $DA29 label=bitmap_flag_up
B $DA29,66,8*8,2 bitmap: FLAG UP
N $DA6B #UDGTABLE { #UDGARRAY3,7,4,3;$DA6B-$DAB5-1-24{0,0,96,96}(flag-down) } TABLE#
@ $DA6B label=bitmap_flag_down
B $DA6B,75,8*9,3 bitmap: FLAG DOWN
N $DAB6 #UDGTABLE { #UDGARRAY3,7,4,3;$DAB6-$DAFD-1-24{0,0,96,96}(bitmap-crate) } TABLE#
@ $DAB6 label=bitmap_crate
B $DAB6,72,8 bitmap: CRATE
N $DAFE #UDGTABLE { #UDGARRAY3,7,4,3;$DAFE-$DB45-1-24(mask-crate) } TABLE#
@ $DAFE label=mask_crate
B $DAFE,72,8 mask: CRATE
N $DB46 #UDGTABLE { #UDGARRAY2,7,4,2;$DB46-$DB71-1-16{0,0,64,88}(bitmap-stove) } TABLE#
@ $DB46 label=bitmap_stove
B $DB46,44,8*5,4 bitmap: STOVE
N $DB72 #UDGTABLE { #UDGARRAY2,7,4,2;$DB72-$DB9D-1-16(mask-stove) } TABLE#
@ $DB72 label=mask_stove
B $DB72,44,8*5,4 mask: STOVE
;
c $DB9E Mark nearby items.
D $DB9E Iterates over itemstructs, testing to see if each item is within the range (-1..22, 0..15) of the current map position. If it is it sets the flags itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7 on the item, otherwise it clears both of those flags.
D $DB9E Used by the routines at #R$6939 and #R$9D7B.
D $DB9E This is similar to is_item_discoverable_interior in that it iterates over all item_structs.
@ $DB9E label=mark_nearby_items
C $DB9E,3 Get the global current room index
C $DBA1,2 Is it room_NONE?
C $DBA3,2 Jump if not
C $DBA5,1 Otherwise set it to room_0_OUTDOORS
@ $DBA6 label=mni_room_set
C $DBA6,1 Preload the room index into #REGc
C $DBA7,4 Point #REGde at the map position
C $DBAB,2 Set #REGb for 16 iterations (item__LIMIT)
C $DBAD,3 Point #REGhl at the first item_struct's room member
N $DBB0 Start loop
@ $DBB0 label=mni_loop
C $DBB0,1 Preserve item_struct pointer
N $DBB1 Compare room
C $DBB1,1 Load the room index and flags
C $DBB2,2 Extract the room index
C $DBB4,1 Same room?
C $DBB5,2 Jump if not
N $DBB7 Is the item's X coordinate within (-1..22) of the map's X position?
C $DBB7,4 Advance #REGhl to itemstruct.iso_pos.x
C $DBBB,1 Copy map X position into #REGa
C $DBBC,2 Reduce it by 2
C $DBBE,1 Compare it to itemstruct.iso_pos.x
C $DBBF,2 Jump if equal (continuing test)
C $DBC1,2 Reset if under lower bound
@ $DBC3 label=mni_chk_x_hi
C $DBC3,2 Add 25 to make (map X position + 23)
C $DBC5,1 Compare to X value in itemstruct
C $DBC6,2 Reset if over upper bound
N $DBC8 Is the item's Y coordinate within (0..15) of the map's Y position?
C $DBC8,1 Copy map Y position into #REGa
C $DBC9,1 Advance #REGhl to itemstruct.iso_pos.y
C $DBCA,1 Reduce it by 1
C $DBCB,1 Compare it to itemstruct.iso_pos.y
C $DBCC,2 Jump if equal (continuing test)
C $DBCE,2 Reset if under lower bound
@ $DBD0 label=mni_chk_y_hi
C $DBD0,2 Add 17 to make (map Y position + 16)
C $DBD2,1 Compare to Y value in itemstruct
C $DBD3,2 Reset if over upper bound
@ $DBD5 label=mni_set
C $DBD5,1 Restore itemstruct pointer
C $DBD6,4 Set itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7
C $DBDA,2 Jump to next iteration
@ $DBDC label=mni_reset
C $DBDC,1 Restore itemstruct pointer
C $DBDD,4 Clear itemstruct_ROOM_FLAG_NEARBY_6 and itemstruct_ROOM_FLAG_NEARBY_7
@ $DBE1 label=mni_advance
C $DBE1,7 Advance #REGhl by stride
@ $DBE8 label=mni_next
C $DBE8,2 ...loop
C $DBEA,1 Return
;
c $DBEB Find the next item to draw that is furthest behind (x,y).
D $DBEB Used by the routine at #R$B89C.
R $DBEB I:A' A value to leave in #REGa' when nothing is found (e.g. 255)
R $DBEB I:BC' X position
R $DBEB I:DE' Y position
R $DBEB O:A' Index of the greatest item with the item_FOUND flag set, if found
R $DBEB O:IY Pointer to an itemstruct, if found
@ $DBEB label=get_next_drawable_itemstruct
C $DBEB,3 Set #REGb for 16 iterations (item__LIMIT) and set #REGc for a seven byte stride simultaneously
C $DBEE,3 Point #REGhl at the first item_struct's room member
N $DBF1 Start loop
@ $DBF1 label=ggi_loop
C $DBF1,2 Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_7 flag set? ($80)
C $DBF3,2 If not, jump to the next iteration
C $DBF5,2 Is the itemstruct_ROOM_FLAG_ITEM_NEARBY_6 flag set? ($40)
C $DBF7,2 If not, jump to the next iteration
C $DBF9,1 Preserve the item_struct pointer
C $DBFA,1 Preserve the item counter and stride
N $DBFB Select an item if it's behind the point (x,y).
C $DBFB,1 Advance #REGhl to item_struct.pos.x
C $DBFC,1 Fetch item_struct.pos.x
C $DBFD,3 Multiply it by 8 returning the result in #REGbc
C $DC00,1 Preserve the result
C $DC01,1 Flip to banked regs - so we can subtract X position
C $DC02,1 Restore the result into #REGhl
C $DC03,1 Clear the carry flag prior to SBC
C $DC04,2 Calculate (item_struct.pos.x * 8 - x_position)
C $DC06,1 Flip to unbanked regs - now we have the result
C $DC07,2 Was (item_struct.pos.x * 8 <= x_position)?
C $DC09,2 Jump if so
C $DC0B,1 Advance #REGhl to item_struct.pos.y
C $DC0C,1 Fetch item_struct.pos.y
C $DC0D,3 Multiply it by 8 returning the result in #REGbc
C $DC10,1 Preserve the result
C $DC11,1 Flip to banked regs - so we can subtract Y position
C $DC12,1 Restore the result into #REGhl
N $DC13 Q. Why are we not clearing the carry flag like at #R$DC03?
C $DC13,2 Calculate (item_struct.pos.y * 8 - y_position)
C $DC15,1 Flip to unbanked regs - now we have the result
C $DC16,2 Was (item_struct.pos.y * 8 <= y_position)?
C $DC18,2 Jump if so
C $DC1A,1 Preserve the item_struct pointer
C $DC1B,1 Flip to banked regs - so we can store new X,Y positions
C $DC1C,1 Restore the item_struct pointer
N $DC1D Calculate (x,y) for the next iteration.
C $DC1D,1 Fetch item_struct.pos.y
C $DC1E,3 Multiply it by 8 returning the result in #REGbc
C $DC21,2 #REGde = #REGbc
C $DC23,1 Rewind #REGhl to point at item_struct.pos.x
C $DC24,1 Fetch item_struct.pos.x
C $DC25,3 Multiply it by 8 returning the result in #REGbc
C $DC28,2 Rewind #REGhl to point at item_struct (jump back over item & room bytes)
N $DC2A #REGiy is used to return an item_struct here which is unusual compared to the rest of the code which maintains #REGiy as a current vischar pointer.
C $DC2A,3 Copy the item_struct pointer to #REGiy
C $DC2D,1 Flip to unbanked regs
C $DC2E,1 Restore the item counter and stride
C $DC2F,1 Preserve the item counter and stride
C $DC30,3 Calculate the item index (item__LIMIT - item counter)
C $DC33,2 Set the item found flag
C $DC35,1 Return the value in #REGa'
@ $DC36 label=ggi_next_pop
C $DC36,1 Restore item counter and stride
C $DC37,1 Restore item_struct pointer
@ $DC38 label=ggi_next
C $DC38,6 Advance by stride to next item
@ $DC3E label=ggi_loop_end
C $DC3E,2 ...loop
C $DC40,1 Return
;
c $DC41 Set up item plotting.
D $DC41 Used by the routine at #R$B866.
D $DC41 Counterpart of, and very similar to, the routine at #R$E420.
R $DC41 I:A Item index
R $DC41 I:IY Pointer to item_struct
R $DC41 O:F Z set if item is visible, NZ otherwise
N $DC41 The $3F mask here looks like it ought to be $1F (item__LIMIT - 1). Potential bug: The use of #REGa later on does not re-clamp it to $1F.
@ $DC41 label=setup_item_plotting
C $DC41,2 Mask off item_FOUND
N $DC43 Bug: This writes the item index to #R$8213 but that location is never subsequently read from.
C $DC43,3 Store saved_item
C $DC46,3 Copy the item_struct pointer into #REGhl
C $DC49,2 Advance #REGhl to item_struct.pos
C $DC4B,8 Copy item_struct.pos and item_struct.iso_pos to tinypos_stash and iso_pos (five contiguous bytes)
N $DC53 #REGhl now points at global sprite_index.
C $DC53,1 Point #REGde at item_struct.sprite_index
C $DC54,1 Zero sprite_index so that items are never drawn flipped
C $DC55,9 Point #REGhl at item_definitions[item] (a spritedef_t)
C $DC5E,1 Advance #REGhl to spritedef.height
C $DC5F,1 Load it
C $DC60,3 Set item_height to spritedef.height
C $DC63,1 Advance #REGhl to spritedef.bitmap
C $DC64,8 Copy spritedef bitmap and mask pointers to global bitmap_pointer and mask_pointer
C $DC6C,3 Clip the item's dimensions to the game window
C $DC6F,1 Return if the item is invisible
N $DC70 The item is visible.
C $DC70,1 Preserve the lefthand skip and clipped width
C $DC71,1 Preserve the top skip and clipped height
N $DC72 Self modify the sprite plotter routines.
C $DC72,1 Copy the clipped height into #REGa
C $DC73,3 Write clipped height to the instruction at #R$E2C1 in plot_masked_sprite_16px (shift right case)
@ $DC76 label=sip_do_enables
C $DC76,2 Is the lefthand skip zero?
C $DC78,3 Jump if not
N $DC7B There's no left hand skip - enable instructions.
@ $DC7B label=sip_enable_is_one
C $DC7B,3 Load #REGa' with the opcode of 'LD (HL),A'
C $DC7E,1 Set a counter to clipped_width. We'll write out this many bytes before clipping
C $DC7F,2 (else)
@ $DC81 label=sip_enable_is_zero
C $DC81,2 Load #REGa' with the opcode of 'NOP'
C $DC83,3 Set a counter to (3 - clipped_width). We'll clip until this many bytes have been written
@ $DC86 label=sip_enable_cont
C $DC86,1 Bank
C $DC87,1 Move counter to #REGc
C $DC88,1 Unbank the opcode we'll write`
N $DC89 Set the addresses in the jump table to NOP or LD (HL),A.
@ $DC89 label=sip_enables_iters
C $DC89,3 Point #REGhl at plot_masked_sprite_16px_enables[0]
C $DC8C,2 Set #REGb for 3 iterations / 3 pairs of self modified locations
N $DC8E Start loop
@ $DC8E label=sip_enables_loop
C $DC8E,3 Fetch an address
C $DC91,1 Write a new opcode
C $DC92,1 Advance
C $DC93,3 Fetch an address
C $DC96,1 Advance
C $DC97,1 Write a new opcode
C $DC98,1 Count down the counter
C $DC99,2 Jump if nonzero
C $DC9B,2 Swap between LD (HL),A and NOP
@ $DC9D label=sip_selfmod_next
C $DC9D,2 ...loop
N $DC9F Calculate Y plotting offset.
N $DC9F The full calculation can be avoided if we know there are rows to skip since in that case the sprite always starts at top of the screen.
C $DC9F,1 Bank
C $DCA0,2 Is top skip zero?
C $DCA2,3 Initialise our Y value to zero
C $DCA5,2 Jump if top skip isn't zero
C $DCA7,7 Compute Y = iso_pos_y - map_position_y
C $DCAE,13 Multiply Y by the window buf stride (192) and store it in #REGhl
C $DCBB,1 Move Y into #REGde
@ $DCBC label=sip_y_skip_set
C $DCBC,7 Compute x = iso_pos_x - map_position_x
C $DCC3,7 Copy x to #REGhl and sign extend it
@ $DCCA label=sip_x_skip_set
C $DCCA,1 Combine the x and y values
C $DCCB,4 Add the screen buffer start address
@ $DCCF nowarn
C $DCCF,3 Save the finalised screen buffer pointer
@ $DCD2 nowarn
C $DCD2,3 Point #REGhl at the mask_buffer
C $DCD5,2 Retrieve the top skip and clipped height
C $DCD7,5 mask buffer pointer += top_skip * 4
C $DCDC,3 Set foreground_mask_pointer
C $DCDF,2 Retrieve the top skip and clipped height (again)
C $DCE1,2 Is top skip zero?
C $DCE3,2 Jump if so
N $DCE5 Bug: This loop is setup as generic multiply but only ever multiplies by two.
C $DCE5,1 Copy top_skip to loop counter
C $DCE6,1 Zero the accumulator
C $DCE7,3 Set multiplier to two (width bytes - 1)
N $DCEA Start loop
@ $DCEA label=sip_mult_loop
C $DCEA,1 Accumulate
C $DCEB,1 Decrement counter
C $DCEC,3 ...loop
N $DCEF #REGd will be set to zero here either way: if the loop terminates, or if jumped into.
C $DCEF,1 Set #REGde to skip (result)
C $DCF0,7 Advance bitmap_pointer by 'skip'
C $DCF7,7 Advance mask_pointer by 'skip'
N $DCFE It's unclear as to why these values are preserved since they're not used by the caller.
C $DCFE,1 Restore the lefthand skip and clipped width
C $DCFF,1 Restore the top skip and clipped height
N $DD00 This XOR A isn't strictly needed - the Z flag should still be set from #R$DCEC. (The counterpart at #R$E541 doesn't have it).
C $DD00,1 Set Z flag to signal "is visible" for return
C $DD01,1 Return
;
c $DD02 Clip the given item's dimensions to the game window.
D $DD02 Counterpart to vischar_visible.
D $DD02 Used by the routine at #R$DC41.
R $DD02 O:B Lefthand skip (bytes)
R $DD02 O:C Clipped width (bytes)
R $DD02 O:D Top skip (rows)
R $DD02 O:E Clipped height (rows)
R $DD02 O:F Z if visible, NZ otherwise
N $DD02 First handle the horizontal cases.
@ $DD02 label=item_visible
C $DD02,3 Point #REGhl at iso_pos_x (item left edge)
N $DD05 Calculate the right edge of the window in map space.
C $DD05,4 Load map position (both X & Y)
C $DD09,1 Extract X
C $DD0A,2 Add 24 (number of window columns)
N $DD0C Subtract iso_pos_x giving the distance between the right edge of the window and the current item's left edge (in bytes).
C $DD0C,1 available_right = (map_position.x + 24) - item_left_edge
N $DD0D Check for case (E): Item left edge beyond the window's right edge.
C $DD0D,2 Jump to exit if zero (item left edge at right edge)
C $DD0F,2 Jump to exit if negative (item left edge beyond right edge)
N $DD11 Check for case (D): Item extends outside the window.
C $DD11,2 Compare result to (item width bytes (2) + 1)
C $DD13,3 Jump if it fits
N $DD16 Item's right edge is outside the window: clip its width.
C $DD16,2 No lefthand skip
C $DD18,1 Clipped width = available_right
C $DD19,2 Jump to height part
N $DD1B Calculate the right edge of the item.
@ $DD1B label=iv_not_clipped_on_right_edge
C $DD1B,1 Load iso_pos_x (item left edge)
C $DD1C,2 item_right_edge = iso_pos_x + (item width bytes (2) + 1)
N $DD1E Subtract the map position's X giving the distance between the current item's right edge and the left edge of the window (in bytes).
C $DD1E,1 available_left = item_right_edge - map_position.x
N $DD1F Check for case (A): Item's right edge is beyond the window's left edge.
C $DD1F,2 Jump to exit if zero (item right edge at left edge)
C $DD21,2 Jump to exit if negative (item right edge beyond left edge)
N $DD23 Check for case (B): Item's left edge is outside the window and its right edge is inside the window.
C $DD23,2 Compare result to (item width bytes (2) + 1)
C $DD25,3 Jump if it fits
N $DD28 Item's left edge is outside the window: move the lefthand skip into #REGb and the clipped width into #REGc.
C $DD28,1 Clipped width = available_left
C $DD29,4 Lefthand skip = (item width bytes (2) + 1) - available_left
C $DD2D,2 (else)
N $DD2F Case (C): No clipping required.
C $DD2F,2 No lefthand skip
C $DD31,2 Clipped width = (item width bytes (2) + 1)
N $DD33 Handle vertical cases.
N $DD33 Calculate the bottom edge of the window in map space.
@ $DD33 label=iv_height
C $DD33,3 Load the map position's Y and add 17 (number of window rows)
N $DD36 Subtract item's Y giving the distance between the bottom edge of the window and the current item's top (in rows).
C $DD36,1 Point #REGhl at iso_pos.y (item top edge)
C $DD37,1 available_bottom = window_bottom_edge - iso_pos.y
N $DD38 Check for case (E): Item top edge beyond the window's bottom edge.
C $DD38,2 Jump to exit if zero (item top edge at bottom edge)
C $DD3A,2 Jump to exit if negative (item top edge beyond bottom edge)
N $DD3C Check for case (D): Item extends outside the window.
C $DD3C,2 Compare result to item_height (2)
C $DD3E,3 Jump if it fits (available_top >= item_height)
N $DD41 Item's bottom edge is outside the window: clip its height.
C $DD41,2 Clipped height = available_bottom (8)
C $DD43,2 No top skip
C $DD45,2 Jump to exit
N $DD47 Calculate the bottom edge of the item.
@ $DD47 label=iv_not_clipped_on_top_edge
C $DD47,3 item_bottom_edge = iso_pos.y + item_height (2)
N $DD4A Subtract map position's Y giving the distance between the current item's bottom edge and the top edge of the window (in rows).
C $DD4A,1 available_top = item_bottom_edge - map_pos_y
N $DD4B Check for case (A): Item's bottom edge is beyond the window's top edge.
C $DD4B,2 Jump to exit if zero (item bottom edge at top edge)
C $DD4D,2 Jump to exit if negative (item bottom edge beyond top edge)
N $DD4F Check for case (B): Item's top edge is outside the window and its bottom edge is inside the window.
C $DD4F,2 Compare result to item_height (2)
C $DD51,3 Jump if it fits (available_top >= item_height)
N $DD54 Item's top edge is outside the window: move the top skip into #REGd and the clipped height into #REGe.
C $DD54,6 Clipped height = item_height - 8
C $DD5A,2 Top skip = 8
C $DD5C,2 (else)
N $DD5E Case (C): No clipping required.
C $DD5E,2 No top skip
C $DD60,4 Clipped height = item_height
@ $DD64 label=iv_visible
C $DD64,1 Set Z (item is visible)
C $DD65,1 Return
@ $DD66 label=iv_not_visible
C $DD66,2 Clear Z (item is not visible)
C $DD68,1 Return
;
b $DD69 Item attributes.
D $DD69 20 bytes, 4 of which are unknown, possibly unused.
D $DD69 'Yellow/black' means yellow ink over black paper, for example.
@ $DD69 label=item_attributes
B $DD69,1,1 item_attribute: WIRESNIPS - yellow/black
B $DD6A,1,1 item_attribute: SHOVEL - cyan/black
B $DD6B,1,1 item_attribute: LOCKPICK - cyan/black
B $DD6C,1,1 item_attribute: PAPERS - white/black
B $DD6D,1,1 item_attribute: TORCH - green/black
B $DD6E,1,1 item_attribute: BRIBE - bright-red/black
B $DD6F,1,1 item_attribute: UNIFORM - green/black
N $DD70 Food turns purple/black when it's poisoned.
@ $DD70 label=item_attributes_food
B $DD70,1,1 item_attribute: FOOD - white/black
B $DD71,1,1 item_attribute: POISON - purple/black
B $DD72,1,1 item_attribute: RED KEY - bright-red/black
B $DD73,1,1 item_attribute: YELLOW KEY - yellow/black
B $DD74,1,1 item_attribute: GREEN KEY - green/black
B $DD75,1,1 item_attribute: PARCEL - cyan/black
B $DD76,1,1 item_attribute: RADIO - white/black
B $DD77,1,1 item_attribute: PURSE - white/black
B $DD78,1,1 item_attribute: COMPASS - green/black
N $DD79 The following are likely unused.
B $DD79,1,1 item_attribute: yellow/black
B $DD7A,1,1 item_attribute: cyan/black
B $DD7B,1,1 item_attribute: bright-red/black
B $DD7C,1,1 item_attribute: bright-red/black
;
b $DD7D Item definitions.
D $DD7D Array of "sprite" structures.
D $DD7D item_definition: WIRESNIPS
@ $DD7D label=item_definitions
B $DD7D,1,1 width
B $DD7E,1,1 height
W $DD7F,2,2 bitmap pointer
W $DD81,2,2 mask pointer
N $DD83 item_definition: SHOVEL
B $DD83,1,1 width
B $DD84,1,1 height
W $DD85,2,2 bitmap pointer
W $DD87,2,2 mask pointer
N $DD89 item_definition: LOCKPICK
B $DD89,1,1 width
B $DD8A,1,1 height
W $DD8B,2,2 bitmap pointer
W $DD8D,2,2 mask pointer
N $DD8F item_definition: PAPERS
B $DD8F,1,1 width
B $DD90,1,1 height
W $DD91,2,2 bitmap pointer
W $DD93,2,2 mask pointer
N $DD95 item_definition: TORCH
B $DD95,1,1 width
B $DD96,1,1 height
W $DD97,2,2 bitmap pointer
W $DD99,2,2 mask pointer
N $DD9B item_definition: BRIBE
B $DD9B,1,1 width
B $DD9C,1,1 height
W $DD9D,2,2 bitmap pointer
W $DD9F,2,2 mask pointer
N $DDA1 item_definition: UNIFORM
B $DDA1,1,1 width
B $DDA2,1,1 height
W $DDA3,2,2 bitmap pointer
W $DDA5,2,2 mask pointer
N $DDA7 item_definition: FOOD
B $DDA7,1,1 width
B $DDA8,1,1 height
W $DDA9,2,2 bitmap pointer
W $DDAB,2,2 mask pointer
N $DDAD item_definition: POISON
B $DDAD,1,1 width
B $DDAE,1,1 height
W $DDAF,2,2 bitmap pointer
W $DDB1,2,2 mask pointer
N $DDB3 item_definition: RED_KEY
B $DDB3,1,1 width
B $DDB4,1,1 height
W $DDB5,2,2 bitmap pointer
W $DDB7,2,2 mask pointer
N $DDB9 item_definition: YELLOW_KEY
B $DDB9,1,1 width
B $DDBA,1,1 height
W $DDBB,2,2 bitmap pointer
W $DDBD,2,2 mask pointer
N $DDBF item_definition: GREEN_KEY
B $DDBF,1,1 width
B $DDC0,1,1 height
W $DDC1,2,2 bitmap pointer
W $DDC3,2,2 mask pointer
N $DDC5 item_definition: PARCEL
B $DDC5,1,1 width
B $DDC6,1,1 height
W $DDC7,2,2 bitmap pointer
W $DDC9,2,2 mask pointer
N $DDCB item_definition: RADIO
B $DDCB,1,1 width
B $DDCC,1,1 height
W $DDCD,2,2 bitmap pointer
W $DDCF,2,2 mask pointer
N $DDD1 item_definition: PURSE
B $DDD1,1,1 width
B $DDD2,1,1 height
W $DDD3,2,2 bitmap pointer
W $DDD5,2,2 mask pointer
N $DDD7 item_definition: COMPASS
B $DDD7,1,1 width
B $DDD8,1,1 height
W $DDD9,2,2 bitmap pointer
W $DDDB,2,2 mask pointer
;
b $DDDD Item bitmaps and masks.
D $DDDD #UDGTABLE { #UDGARRAY2,7,4,2;$DDDD-$DDF6-1-16{0,0,64,52}(item-shovel) } TABLE#
@ $DDDD label=bitmap_shovel
B $DDDD,26,2 item_bitmap: SHOVEL (16x13)
N $DDF7 #UDGTABLE { #UDGARRAY2,7,4,2;$DDF7-$DE10-1-16{0,0,64,52}(item-key) } TABLE#
@ $DDF7 label=bitmap_key
B $DDF7,26,2 item_bitmap: KEY (shared for all keys) (16x13)
N $DE11 #UDGTABLE { #UDGARRAY2,7,4,2;$DE11-$DE30-1-16{0,0,64,64}(item-lockpick) } TABLE#
@ $DE11 label=bitmap_lockpick
B $DE11,32,2 item_bitmap: LOCKPICK (16x16)
N $DE31 #UDGTABLE { #UDGARRAY2,7,4,2;$DE31-$DE48-1-16{0,0,64,48}(item-compass) } TABLE#
@ $DE31 label=bitmap_compass
B $DE31,24,2 item_bitmap: COMPASS (16x12)
N $DE49 #UDGTABLE { #UDGARRAY2,7,4,2;$DE49-$DE60-1-16{0,0,64,48}(item-purse) } TABLE#
@ $DE49 label=bitmap_purse
B $DE49,24,2 item_bitmap: PURSE (16x12)
N $DE61 #UDGTABLE { #UDGARRAY2,7,4,2;$DE61-$DE7E-1-16{0,0,64,60}(item-papers) } TABLE#
@ $DE61 label=bitmap_papers
B $DE61,30,2 item_bitmap: PAPERS (16x15)
N $DE7F #UDGTABLE { #UDGARRAY2,7,4,2;$DE7F-$DE94-1-16{0,0,64,44}(item-wiresnips) } TABLE#
@ $DE7F label=bitmap_wiresnips
B $DE7F,22,2 item_bitmap: WIRESNIPS (16x11)
N $DE95 #UDGTABLE { #UDGARRAY2,7,4,2;$DE95-$DEAE-1-16{0,0,64,52}(item-mask-shovelkey) } TABLE#
@ $DE95 label=mask_shovel_key
B $DE95,26,2 item_mask: SHOVEL or KEY (shared) (16x13)
N $DEAF #UDGTABLE { #UDGARRAY2,7,4,2;$DEAF-$DECE-1-16{0,0,64,64}(item-mask-lockpick) } TABLE#
@ $DEAF label=mask_lockpick
B $DEAF,32,2 item_mask: LOCKPICK (16x16)
N $DECF #UDGTABLE { #UDGARRAY2,7,4,2;$DECF-$DEE6-1-16{0,0,64,48}(item-mask-compass) } TABLE#
@ $DECF label=mask_compass
B $DECF,24,2 item_mask: COMPASS (16x12)
N $DEE7 #UDGTABLE { #UDGARRAY2,7,4,2;$DEE7-$DEFE-1-16{0,0,64,48}(item-mask-purse) } TABLE#
@ $DEE7 label=mask_purse
B $DEE7,24,2 item_mask: PURSE (16x12)
N $DEFF #UDGTABLE { #UDGARRAY2,7,4,2;$DEFF-$DF1C-1-16{0,0,64,60}(item-mask-papers) } TABLE#
@ $DEFF label=mask_papers
B $DEFF,30,2 item_mask: PAPERS (16x15)
N $DF1D #UDGTABLE { #UDGARRAY2,7,4,2;$DF1D-$DF32-1-16{0,0,64,44}(item-mask-wiresnips) } TABLE#
@ $DF1D label=mask_wiresnips
B $DF1D,22,2 item_mask: WIRESNIPS (16x11)
N $DF33 #UDGTABLE { #UDGARRAY2,7,4,2;$DF33-$DF52-1-16{0,0,64,64}(item-food) } TABLE#
@ $DF33 label=bitmap_food
B $DF33,32,2 item_bitmap: FOOD (16x16)
N $DF53 #UDGTABLE { #UDGARRAY2,7,4,2;$DF53-$DF72-1-16{0,0,64,64}(item-poison) } TABLE#
@ $DF53 label=bitmap_poison
B $DF53,32,2 item_bitmap: POISON (16x16)
N $DF73 #UDGTABLE { #UDGARRAY2,7,4,2;$DF73-$DF8A-1-16{0,0,64,48}(item-torch) } TABLE#
@ $DF73 label=bitmap_torch
B $DF73,24,2 item_bitmap: TORCH (16x12)
N $DF8B #UDGTABLE { #UDGARRAY2,7,4,2;$DF8B-$DFAA-1-16{0,0,64,64}(item-uniform) } TABLE#
@ $DF8B label=bitmap_uniform
B $DF8B,32,2 item_bitmap: UNIFORM (16x16)
N $DFAB #UDGTABLE { #UDGARRAY2,7,4,2;$DFAB-$DFC4-1-16{0,0,64,52}(item-bribe) } TABLE#
@ $DFAB label=bitmap_bribe
B $DFAB,26,2 item_bitmap: BRIBE (16x13)
N $DFC5 #UDGTABLE { #UDGARRAY2,7,4,2;$DFC5-$DFE4-1-16{0,0,64,64}(item-radio) } TABLE#
@ $DFC5 label=bitmap_radio
B $DFC5,32,2 item_bitmap: RADIO (16x16)
N $DFE5 #UDGTABLE { #UDGARRAY2,7,4,2;$DFE5-$E004-1-16{0,0,64,64}(item-parcel) } TABLE#
@ $DFE5 label=bitmap_parcel
B $DFE5,32,2 item_bitmap: PARCEL (16x16)
N $E005 #UDGTABLE { #UDGARRAY2,7,4,2;$E005-$E01E-1-16{0,0,64,52}(item-mask-bribe) } TABLE#
@ $E005 label=mask_bribe
B $E005,26,2 item_mask: BRIBE (16x13)
N $E01F #UDGTABLE { #UDGARRAY2,7,4,2;$E01F-$E03E-1-16{0,0,64,64}(item-mask-uniform) } TABLE#
@ $E01F label=mask_uniform
B $E01F,32,2 item_mask: UNIFORM (16x16)
N $E03F #UDGTABLE { #UDGARRAY2,7,4,2;$E03F-$E05E-1-16{0,0,64,64}(item-mask-parcel) } TABLE#
@ $E03F label=mask_parcel
B $E03F,32,2 item_mask: PARCEL (16x16)
N $E05F #UDGTABLE { #UDGARRAY2,7,4,2;$E05F-$E07E-1-16{0,0,64,64}(item-mask-poison) } TABLE#
@ $E05F label=mask_poison
B $E05F,32,2 item_mask: POISON (16x16)
N $E07F #UDGTABLE { #UDGARRAY2,7,4,2;$E07F-$E096-1-16{0,0,64,48}(item-mask-torch) } TABLE#
@ $E07F label=mask_torch
B $E07F,24,2 item_mask: TORCH (16x12)
N $E097 #UDGTABLE { #UDGARRAY2,7,4,2;$E097-$E0B6-1-16{0,0,64,64}(item-mask-radio) } TABLE#
@ $E097 label=mask_radio
B $E097,32,2 item_mask: RADIO (16x16)
N $E0B7 #UDGTABLE { #UDGARRAY2,7,4,2;$E0B7-$E0D6-1-16{0,0,64,64}(item-mask-food) } TABLE#
@ $E0B7 label=mask_food
B $E0B7,32,2 item_mask: FOOD (16x16)
;
u $E0D7 Unreferenced bytes.
B $E0D7,9,8,1
;
w $E0E0 Addresses of self-modified locations which are changed between NOPs and LD (HL),A.
D $E0E0 (<- setup_item_plotting, setup_vischar_plotting)
@ $E0E0 label=plot_masked_sprite_16px_enables
W $E0E0,2,2 pms16_right_plot_enable_0
W $E0E2,2,2 pms16_left_plot_enable_0
W $E0E4,2,2 pms16_right_plot_enable_1
W $E0E6,2,2 pms16_left_plot_enable_1
W $E0E8,2,2 pms16_right_plot_enable_2
W $E0EA,2,2 pms16_left_plot_enable_2
;
w $E0EC Addresses of self-modified locations which are changed between NOPs and LD (HL),A.
D $E0EC (<- setup_vischar_plotting)
@ $E0EC label=plot_masked_sprite_24px_enables
W $E0EC,2,2 pms24_right_plot_enable_0
W $E0EE,2,2 pms24_left_plot_enable_0
W $E0F0,2,2 pms24_right_plot_enable_1
W $E0F2,2,2 pms24_left_plot_enable_1
W $E0F4,2,2 pms24_right_plot_enable_2
W $E0F6,2,2 pms24_left_plot_enable_2
W $E0F8,2,2 pms24_right_plot_enable_3
W $E0FA,2,2 pms24_left_plot_enable_3
N $E0FC These two look different. Unused?
W $E0FC,2,2 plot_masked_sprite_16px
W $E0FE,2,2 plot_masked_sprite_24px
;
u $E100 Unused word?
D $E100 Unsure if related to the above plot_masked_sprite_24px_enables table.
W $E100,2,2
;
c $E102 Sprite plotter for 24 pixel-wide masked sprites.
D $E102 This is used for characters and objects.
D $E102 Used by the routine at #R$B866.
R $E102 I:IY Pointer to visible character.
N $E102 Mask off the bottom three bits of the vischar's (isometric projected) x position and treat it as a signed field. This tells us how far we need to shift the sprite left or right. -4..-1 => left shift by 4..1px; 0..3 => right shift by 0..3px.
@ $E102 label=plot_masked_sprite_24px
C $E102,5 x = (vischar.iso_pos.x & 7)
C $E107,2 Is x equal to 4 or above? (-4..-1)
C $E109,3 Jump if so
N $E10C Right shifting case.
N $E10C #REGa is 0..3 here: the amount by which we want to shift the sprite right. The following op turns that into a jump table distance. e.g. it turns (0,1,2,3) into (3,2,1,0) then scales it by the length of each rotate sequence (8 bytes) to obtain the jump offset.
C $E10C,3 x = (~x & 3)
C $E10F,3 Multiply by eight to get the jump distance
C $E112,3 Self modify the JR at #R$E160 to jump into the mask rotate sequence
C $E115,3 Self modify the JR at #R$E142 to jump into the bitmap rotate sequence
C $E118,4 Fetch mask_pointer
C $E11C,4 Fetch bitmap_pointer
@ $E120 label=pms24_right_height_iters
C $E120,2 Set #REGb for 32 iterations (self modified by #R$E49D)
N $E122 Start loop
@ $E122 label=pms24_right_loop
C $E122,1 Preserve the loop counter
C $E123,6 Load the bitmap bytes bm0,bm1,bm2 into #REGb,#REGc,#REGe
C $E129,1 Preserve the bitmap pointer
C $E12A,1 Bank
C $E12B,6 Load the mask bytes mask0,mask1,mask2 into #REGb',#REGc',#REGe'
C $E131,1 Preserve the mask pointer
C $E132,4 Is the top bit of flip_sprite set?
C $E136,3 Call flip_24_masked_pixels if so
C $E139,4 Fetch foreground_mask_pointer
N $E13D Note: This instruction is moved compared to the other routines.
@ $E13D nowarn
C $E13D,3 Load screen buffer pointer
N $E140 Shift the bitmap right.
N $E140 Our 24px wide bitmap has three bytes to shift (#REGb,#REGc,#REGe) but we'll need an extra byte to capture any shifted-out bits (#REGd).
C $E140,2 bm3 = 0
@ $E142 label=pms24_right_bitmap_jump
C $E142,2 Jump into shifter (self modified by #R$E115)
N $E144 Rotate the bitmap bytes (#REGb,#REGc,#REGe,#REGd) right by one pixel.
N $E144 Shift out the leftmost byte's bottom pixel into the carry flag.
@ $E144 label=pms24_right_bitmap_jumptable_0
C $E144,2 carry = bm0 & 1; bm0 >>= 1
N $E146 Shift out the next byte's bottom pixel into the carry flag while shifting in the previous carry at the top. (x3)
C $E146,2 new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry
C $E148,2 new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry
C $E14A,2 new_carry = bm3 & 1; bm3 = (bm3 >> 1) | (carry << 7); carry = new_carry
@ $E14C label=pms24_right_bitmap_jumptable_1
C $E14C,8 Do the same again
@ $E154 label=pms24_right_bitmap_jumptable_2
C $E154,8 Do the same again
@ $E15C label=pms24_right_bitmap_jumptable_end
C $E15C,1 Swap to masks bank
N $E15D Shift the mask right.
N $E15D This follows the same process as the bitmap shifting above, but the mask and a carry flag are set by default.
C $E15D,2 mask3 = $FF
C $E15F,1 carry = 1
@ $E160 label=pms24_right_mask_jump
C $E160,2 Jump into shifter (self modified by #R$E112)
N $E162 Rotate the mask bytes (#REGb,#REGc,#REGe,#REGd) right by one pixel.
@ $E162 label=pms24_right_mask_jumptable_0
C $E162,2 new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry
C $E164,2 new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry
C $E166,2 new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry
C $E168,2 new_carry = mask3 & 1; mask3 = (mask3 >> 1) | (carry << 7); carry = new_carry
@ $E16A label=pms24_right_mask_jumptable_1
C $E16A,8 Do the same again
@ $E172 label=pms24_right_mask_jumptable_2
C $E172,8 Do the same again
N $E17A Plot using the foreground mask.
N $E17A In TGE the bitmap pixels are set to 0 for black and 1 for white, and the mask pixels are set to 0 for opaque and 1 for transparent.
N $E17A TGE uses "AND-OR" type masks. In this type of mask the screen contents are ANDed with the mask (preserving only those pixels set in the mask) then the bitmap is ORed into place, like so: result = (mask & screen) | bitmap
N $E17A #TABLE(default) { =h Bitmap | =h Mask | =h Result } {         0 |       0 | Set to black } {         0 |       1 | Set to background (transparent) } {         1 |       0 | Set to white } {         1 |       1 | Set to white } TABLE#
N $E17A See also https://skoolkit.ca/docs/skoolkit-6.2/skool-macros.html#masks
N $E17A However TGE also has a foreground layer to consider. This allows objects to be in front of a sprite too. The foreground mask removes from a sprite the pixels of objects in front of it. This gives us our final expression: result = ((~foreground_mask | mask) & screen) | (bitmap & foreground_mask)
N $E17A In the left term: ((~foreground_mask | mask) & screen) :: The foreground mask is first inverted so that it will preserve the foreground layer's pixels. It's then ORed with the vischar's mask so that it preserves the transparent pixels around the vischar. The result is ANDed with the screen (buffer) pixels, creating a "hole" into which we will insert the bitmap pixels.
N $E17A In the right term: (bitmap & foreground_mask) :: We take the vischar's bitmap pixels and mask them against the foreground mask. This means that we retain the parts of the vischar outside of the foreground mask.
N $E17A Finally the OR merges the result with the screen-with-a-hole-cut-out.
N $E17A #TABLE(default) { =h Foreground | =h Bitmap | =h Mask | =h Result } {             0 |       any |     any | Set to foreground } {             1 |         0 |       0 | Set to black } {             1 |         0 |       1 | Set to background (transparent) } {             1 |         1 |       0 | Set to white } {             1 |         1 |       1 | Set to white } TABLE#
@ $E17A label=pms24_right_plot_0
C $E17A,1 Load a foreground mask byte
C $E17B,1 Invert it
C $E17C,1 OR with mask byte mask0
C $E17D,1 Swap to bank containing bitmap bytes (in #REGbc & #REGde) and screen buffer pointer (in #REGhl)
C $E17E,1 AND combined masks with screen byte
C $E17F,1 Bank left hand term
C $E180,1 Get bitmap byte bm0
C $E181,1 Swap to bank containing mask bytes (in #REGbc' & #REGde') and foreground mask pointer (in #REGhl')
C $E182,1 AND with foreground mask byte
C $E183,1 Save right hand term
C $E184,1 Unbank left hand term
C $E185,1 Combine terms
C $E186,1 Advance foreground mask pointer
C $E187,1 Swap to bitmaps bank
@ $E188 label=pms24_right_plot_enable_0
C $E188,1 Write pixel (self modified)
C $E189,1 Advance to next output pixel
C $E18A,1 Swap to masks bank
@ $E18B label=pms24_right_plot_1
@ $E199 label=pms24_right_plot_enable_1
C $E18B,17 Do the same again for mask1 & bm1
@ $E19C label=pms24_right_plot_2
@ $E1AA label=pms24_right_plot_enable_2
C $E19C,17 Do the same again for mask2 & bm2
@ $E1AD label=pms24_right_plot_3
C $E1AD,13 Do the same again for mask3 & bm3
C $E1BA,3 Save foreground_mask_pointer
C $E1BD,1 Restore the mask pointer
@ $E1BF label=pms24_right_plot_enable_3
C $E1C0,4 Advance screen buffer pointer by (24 - 3 = 21) bytes
@ $E1C4 nowarn
C $E1C4,3 Save the screen buffer pointer
C $E1C7,1 Restore the bitmap pointer
C $E1C8,1 Restore the loop counter
C $E1C9,4 ...loop
C $E1CD,1 Return
N $E1CE Left shifting case.
N $E1CE #REGa is 4..7 here, which we intepret as -4..-1: the amount by which we want to shift the sprite left.
@ $E1CE label=pms24_left
C $E1CE,2 4..7 => jump table offset 0..3
C $E1D0,3 Multiply by eight to get the jump distance
C $E1D3,3 Self modify the JR at #R$E229 to jump into the mask rotate sequence
C $E1D6,3 Self modify the JR at #R$E203 to jump into the bitmap rotate sequence
C $E1D9,4 Fetch mask_pointer
C $E1DD,4 Fetch bitmap_pointer
@ $E1E1 label=pms24_left_height_iters
C $E1E1,2 Set #REGb for 32 iterations (self modified by #R$E4A0)
N $E1E3 Start loop
@ $E1E3 label=pms24_left_loop
C $E1E3,1 Preserve the loop counter
C $E1E4,6 Load the bitmap bytes bm1,bm2,bm3 into #REGb,#REGc,#REGe
C $E1EA,1 Preserve the bitmap pointer
C $E1EB,1 Bank
C $E1EC,6 Load the mask bytes mask1,mask2,mask3 into #REGb',#REGc',#REGe'
C $E1F2,1 Preserve the mask pointer
C $E1F3,4 Is the top bit of flip_sprite set?
C $E1F7,3 Call flip_24_masked_pixels if so
C $E1FA,4 Fetch foreground_mask_pointer
@ $E1FE nowarn
C $E1FE,3 Load screen buffer pointer
N $E201 Shift the bitmap left.
N $E201 Our 24px wide bitmap has three bytes to shift (#REGb,#REGc,#REGe) but we'll need an extra byte to capture any shifted-out bits (#REGd).
C $E201,2 bm0 = 0
@ $E203 label=pms24_left_bitmap_jump
C $E203,2 Jump into shifter (self modified by #R$E1D6)
N $E205 Rotate the bitmap bytes (#REGd,#REGb,#REGc,#REGe) left by one pixel.
N $E205 Shift out the rightmost byte's top pixel into the carry flag.
@ $E205 label=pms24_left_bitmap_jumptable_0
C $E205,2 carry = bm3 >> 7; bm3 <<= 1
N $E207 Shift out the next byte's top pixel into the carry flag while shifting in the previous carry at the bottom. (x3)
C $E207,2 new_carry = bm2 >> 7; bm2 = (bm2 << 1) | carry; carry = new_carry
C $E209,2 new_carry = bm1 >> 7; bm1 = (bm1 << 1) | carry; carry = new_carry
C $E20B,2 new_carry = bm0 >> 7; bm0 = (bm0 << 1) | carry; carry = new_carry
@ $E20D label=pms24_left_bitmap_jumptable_1
C $E20D,8 Do the same again
@ $E215 label=pms24_left_bitmap_jumptable_2
C $E215,8 Do the same again
@ $E21D label=pms24_left_bitmap_jumptable_3
C $E21D,8 Do the same again
@ $E225 label=pms24_left_bitmap_jumptable_end
C $E225,1 Swap to masks bank
N $E226 Shift the mask left.
C $E226,2 mask0 = $FF
C $E228,1 carry = 1
@ $E229 label=pms24_left_mask_jump
C $E229,2 Jump into shifter (self modified by #R$E1D3)
N $E22B Rotate the mask bytes (#REGd,#REGb,#REGc,#REGe) left by one pixel.
@ $E22B label=pms24_left_mask_jumptable_0
C $E22B,2 new_carry = mask3 >> 7; mask3 = (mask3 << 1) | carry; carry = new_carry
C $E22D,2 new_carry = mask2 >> 7; mask2 = (mask2 << 1) | carry; carry = new_carry
C $E22F,2 new_carry = mask1 >> 7; mask1 = (mask1 << 1) | carry; carry = new_carry
C $E231,2 new_carry = mask0 >> 7; mask0 = (mask0 << 1) | carry; carry = new_carry
@ $E233 label=pms24_left_mask_jumptable_1
C $E233,8 Do the same again
@ $E23B label=pms24_left_mask_jumptable_2
C $E23B,8 Do the same again
@ $E243 label=pms24_left_mask_jumptable_3
C $E243,8 Do the same again
N $E24B Plot, using the foreground mask.
@ $E24B label=pms24_left_plot_0
C $E24B,1 Load a foreground mask byte
C $E24C,1 Invert it
C $E24D,1 OR with mask byte mask0
C $E24E,1 Swap to bank containing bitmap bytes (in #REGbc & #REGde) and screen buffer pointer (in #REGhl)
C $E24F,1 AND combined masks with screen byte
C $E250,1 Bank left hand term
C $E251,1 Get bitmap byte bm0
C $E252,1 Swap to bank containing mask bytes (in #REGbc' & #REGde') and foreground mask pointer (in #REGhl')
C $E253,1 AND with foreground mask byte
C $E254,1 Save right hand term
C $E255,1 Unbank left hand term
C $E256,1 Combine results
C $E257,1 Advance foreground mask pointer
C $E258,1 Swap to bitmaps bank
@ $E259 label=pms24_left_plot_enable_0
C $E259,1 Write pixel (self modified)
C $E25A,1 Advance to next output pixel
C $E25B,1 Swap to masks bank
@ $E25C label=pms24_left_plot_1
@ $E26A label=pms24_left_plot_enable_1
C $E25C,17 Do the same again for mask1 & bm1
@ $E26D label=pms24_left_plot_2
@ $E27B label=pms24_left_plot_enable_2
C $E26D,17 Do the same again for mask2 & bm2
@ $E27E label=pms24_left_plot_3
C $E27E,13 Do the same again for mask3 & bm3
C $E28B,3 Save foreground_mask_pointer
C $E28E,1 Restore the mask pointer
@ $E290 label=pms24_left_plot_enable_3
C $E291,4 Advance screen buffer pointer by (24 - 3 = 21) bytes
@ $E295 nowarn
C $E295,3 Save the screen buffer pointer
C $E298,1 Restore the bitmap pointer
C $E299,1 Restore the loop counter
C $E29A,4 ...loop
C $E29E,1 Return
;
c $E29F Alternative entry point for plot_masked_sprite_16px that assumes x is zero.
D $E29F Used by the routine at #R$B866.
@ $E29F label=plot_masked_sprite_16px_x_is_zero
C $E29F,1 Zero x
C $E2A0,2 Jump to pms16_left
;
c $E2A2 Sprite plotter for 16 pixel-wide masked sprites.
D $E2A2 This is used for characters and objects.
D $E2A2 Used by the routines at #R$B866, #R$E29F and #R$E2A2.
R $E2A2 I:IY Pointer to visible character.
N $E2A2 Mask off the bottom three bits of the vischar's (isometric projected) x position and treat it as a signed field. This tells us how far we need to shift the sprite left or right. -4..-1 => left shift by 4..1px; 0..3 => right shift by 0..3px.
@ $E2A2 label=plot_masked_sprite_16px
C $E2A2,5 x = (vischar.iso_pos.x & 7)
C $E2A7,2 Is x equal to 4 or above? (-4..-1)
C $E2A9,3 Jump if so
N $E2AC Right shifting case.
N $E2AC #REGa is 0..3 here: the amount by which we want to shift the sprite right. The following op turns that into a jump table distance. e.g. it turns (0,1,2,3) into (3,2,1,0) then scales it by the length of each rotate sequence (6 bytes) to obtain the jump offset.
@ $E2AC label=pms16_right
C $E2AC,3 x = (~x & 3)
C $E2AF,4 Multiply by six to get the jump distance
C $E2B3,3 Self modify the JR at #R$E2DB to jump into the mask rotate sequence
C $E2B6,3 Self modify the JR at #R$E2F3 to jump into the bitmap rotate sequence
C $E2B9,4 Fetch mask_pointer
C $E2BD,4 Fetch bitmap_pointer
@ $E2C1 label=pms16_right_height_iters
C $E2C1,2 Set #REGb for 32 iterations (self modified by #R$DC73)
N $E2C3 Start loop
@ $E2C3 label=pms16_right_loop
C $E2C3,4 Load the bitmap bytes bm0,bm1 into #REGd,#REGe
C $E2C7,1 Preserve the bitmap pointer
C $E2C8,1 Bank
C $E2C9,4 Load the mask bytes mask0,mask1 into #REGd',#REGe'
C $E2CD,1 Preserve the mask pointer
C $E2CE,4 Is the top bit of flip_sprite set?
C $E2D2,3 Call flip_16_masked_pixels if so
C $E2D5,3 Fetch foreground_mask_pointer
N $E2D8 Shift the mask.
N $E2D8 Note: The 24px version does bitmap rotates then mask rotates. Is this the opposite way around to save a bank switch?
C $E2D8,2 mask2 = $FF
C $E2DA,1 carry = 1
@ $E2DB label=pms16_right_mask_jump
C $E2DB,2 Jump into shifter (self modified by #R$E2B3)
N $E2DD Rotate the mask bytes (#REGd,#REGe,#REGc) right by one pixel.
@ $E2DD label=pms16_right_mask_jumptable_0
C $E2DD,2 new_carry = mask0 & 1; mask0 = (mask0 >> 1) | (carry << 7); carry = new_carry
C $E2DF,2 new_carry = mask1 & 1; mask1 = (mask1 >> 1) | (carry << 7); carry = new_carry
C $E2E1,2 new_carry = mask2 & 1; mask2 = (mask2 >> 1) | (carry << 7); carry = new_carry
@ $E2E3 label=pms16_right_mask_jumptable_1
C $E2E3,6 Do the same again
@ $E2E9 label=pms16_right_mask_jumptable_2
C $E2E9,6 Do the same again
N $E2EF Shift the bitmap.
N $E2EF Our 16px bitmap has two bitmap bytes to shift (#REGd,#REGe) but we'll need an extra byte to capture the shift-out (#REGc).
@ $E2EF label=pms16_right_mask_jumptable_end
C $E2EF,1 Swap to bitmaps bank
C $E2F0,2 bm2 = 0
C $E2F2,1 (Suspect this is a stray instruction)
@ $E2F3 label=pms16_right_bitmap_jump
C $E2F3,2 Jump into shifter (self modified by #R$E2B6)
N $E2F5 Rotate the bitmap bytes (#REGd,#REGe,#REGc) right by one pixel.
N $E2F5 Shift out the leftmost byte's bottom pixel into the carry flag.
@ $E2F5 label=pms16_right_bitmap_jumptable_0
C $E2F5,2 carry = bm0 & 1; bm0 >>= 1
N $E2F7 Shift out the next byte's bottom pixel into the carry flag while shifting in the previous carry at the top. (x2)
C $E2F7,2 new_carry = bm1 & 1; bm1 = (bm1 >> 1) | (carry << 7); carry = new_carry
C $E2F9,2 new_carry = bm2 & 1; bm2 = (bm2 >> 1) | (carry << 7); carry = new_carry
@ $E2FB label=pms16_right_bitmap_jumptable_1
C $E2FB,6 Do the same again
@ $E301 label=pms16_right_bitmap_jumptable_2
C $E301,6 Do the same again
@ $E307 label=pms16_right_bitmap_jumptable_end
@ $E307 nowarn
C $E307,3 Load screen buffer pointer
C $E30A,1 Swap to bitmaps bank
N $E30B Plot, using the foreground mask. See #R$E17A for a discussion of this masking operation.
@ $E30B label=pms16_right_plot_0
C $E30B,1 Load a foreground mask byte
C $E30C,1 Invert it
C $E30D,1 OR with mask byte mask0
C $E30E,1 Swap to bank containing bitmap bytes (in #REGd & #REGe) and screen buffer pointer (in #REGhl)
C $E30F,1 AND combined masks with screen byte
C $E310,1 Bank left hand term
C $E311,1 Get bitmap byte bm0
C $E312,1 Swap to bank containing mask bytes (in #REGd' & #REGe') and foreground mask pointer (in #REGhl')
C $E313,1 AND with foreground mask byte
C $E314,1 Save right hand term
C $E315,1 Unbank left hand term
C $E316,1 Combine terms
C $E317,1 Advance foreground mask pointer
C $E318,1 Swap to bitmaps bank
@ $E319 label=pms16_right_plot_enable_0
C $E319,1 Write pixel (self modified)
C $E31A,1 Advance to next output pixel
C $E31B,1 Swap to masks bank
@ $E31C label=pms16_right_plot_1
@ $E32A label=pms16_right_plot_enable_1
C $E31C,17 Do the same again for mask1 & bm1
@ $E32D label=pms16_right_plot_2
C $E32D,12 Do the same again for mask2 & bm2
C $E339,2 Advance foreground_mask_pointer by two (buffer is 4 bytes wide)
C $E33B,3 Save foreground_mask_pointer
C $E33E,1 Restore the mask pointer
@ $E340 label=pms16_right_plot_enable_2
C $E341,4 Advance screen buffer pointer by (24 - 2 = 22) bytes
@ $E345 nowarn
C $E345,3 Save the screen buffer pointer
C $E348,1 Restore the bitmap pointer
C $E349,4 ...loop
C $E34D,1 Return
N $E34E Left shifting case.
N $E34E #REGa is 4..7 here, which we intepret as -4..-1: the amount by which we want to shift the sprite left.
@ $E34E label=pms16_left
C $E34E,2 4..7 => jump table offset 0..3
C $E350,4 Multiply by six to get the jump distance
C $E354,3 Self modify the JR at #R$E399 to jump into the bitmap rotate sequence
C $E357,3 Self modify the JR at #R$E37C to jump into the mask rotate sequence
C $E35A,4 Fetch mask_pointer
C $E35E,4 Fetch bitmap_pointer
@ $E362 label=pms16_left_height_iters
C $E362,2 Set #REGb for 32 iterations (self modified by #R$E492)
N $E364 Start loop
@ $E364 label=pms16_left_loop
C $E364,4 Load the bitmap bytes bm1,bm2 into #REGd,#REGe
C $E368,1 Preserve the bitmap pointer
C $E369,1 Bank
C $E36A,4 Load the mask bytes mask1,mask2 into #REGd',#REGe'
C $E36E,1 Preserve the mask pointer
C $E36F,4 Is the top bit of flip_sprite set?
C $E373,3 Call flip_16_masked_pixels if so
C $E376,3 Fetch foreground_mask_pointer
N $E379 Shift the mask.
C $E379,2 mask0 = $FF
C $E37B,1 carry = 1
@ $E37C label=pms16_left_mask_jump
C $E37C,2 Jump into shifter (self modified by #R$E357)
N $E37E Rotate the mask bytes (#REGc,#REGd,#REGe) left by one pixel.
@ $E37E label=pms16_left_mask_jumptable_0
C $E37E,2 new_carry = mask2 >> 7; mask2 = (mask2 << 1) | carry; carry = new_carry
C $E380,2 new_carry = mask1 >> 7; mask1 = (mask1 << 1) | carry; carry = new_carry
C $E382,2 new_carry = mask0 >> 7; mask0 = (mask0 << 1) | carry; carry = new_carry
@ $E384 label=pms16_left_mask_jumptable_1
C $E384,6 Do the same again
@ $E38A label=pms16_left_mask_jumptable_2
C $E38A,6 Do the same again
@ $E390 label=pms16_left_mask_jumptable_3
C $E390,6 Do the same again
N $E396 Shift the bitmap.
@ $E396 label=pms16_left_mask_jumptable_end
C $E396,1 Swap to bitmaps bank
C $E397,2 bm0 = 0
@ $E399 label=pms16_left_bitmap_jump
C $E399,2 Jump into shifter (self modified by #R$E354)
N $E39B Rotate the bitmap bytes (#REGc,#REGd,#REGe) left by one pixel.
@ $E39B label=pms16_left_bitmap_jumptable_0
C $E39B,2 carry = bm2 >> 7; bm2 <<= 1
C $E39D,2 new_carry = bm1 >> 7; bm1 = (bm1 << 1) | (carry << 0); carry = new_carry
C $E39F,2 new_carry = bm0 >> 7; bm0 = (bm0 << 1) | (carry << 0); carry = new_carry
@ $E3A1 label=pms16_left_bitmap_jumptable_1
C $E3A1,6 Do the same again
@ $E3A7 label=pms16_left_bitmap_jumptable_2
C $E3A7,6 Do the same again
@ $E3AD label=pms16_left_bitmap_jumptable_3
C $E3AD,6 Do the same again
N $E3B3 Plot, using foreground mask.
N $E3B3 See #R$E17A for a discussion of this masking operation.
@ $E3B3 label=pms16_left_bitmap_jumptable_end
@ $E3B3 nowarn
C $E3B3,3 Load screen buffer pointer
C $E3B6,1 Swap to masks bank
@ $E3B7 label=pms16_left_plot_0
C $E3B7,1 Load a foreground mask byte
C $E3B8,1 Invert it
C $E3B9,1 OR with mask byte mask0
C $E3BA,1 Swap to bank containing bitmap bytes (in #REGd & #REGe) and screen buffer pointer (in #REGhl)
C $E3BB,1 AND combined masks with screen byte
C $E3BC,1 Bank left hand term
C $E3BD,1 Get bitmap byte bm0
C $E3BE,1 Swap to bank containing mask bytes (in #REGd' & #REGe') and foreground mask pointer (in #REGhl')
C $E3BF,1 AND with foreground mask byte
C $E3C0,1 Save right hand term
C $E3C1,1 Unbank left hand term
C $E3C2,1 Combine terms
C $E3C3,1 Advance foreground mask pointer
C $E3C4,1 Swap to bitmaps bank
@ $E3C5 label=pms16_left_plot_enable_0
C $E3C5,1 Write pixel (self modified)
C $E3C6,1 Advance to next output pixel
C $E3C7,1 Swap to masks bank
@ $E3C8 label=pms16_left_plot_1
@ $E3D6 label=pms16_left_plot_enable_1
C $E3C8,17 Do the same again for mask1 & bm1
@ $E3D9 label=pms16_left_plot_2
C $E3D9,12 Do the same again for mask2 & bm2
C $E3E5,2 Advance foreground_mask_pointer by two (buffer is 4 bytes wide)
C $E3E7,3 Save foreground_mask_pointer
C $E3EA,1 Restore the mask pointer
@ $E3EC label=pms16_left_plot_enable_2
C $E3ED,4 Advance screen buffer pointer by (24 - 2 = 22) bytes
@ $E3F1 nowarn
C $E3F1,3 Save the screen buffer pointer
C $E3F4,1 Restore the bitmap pointer
C $E3F5,4 ...loop
C $E3F9,1 Return
;
c $E3FA Horizontally flips the 24 pixels in E,C,B and counterpart masks in E',C',B'.
D $E3FA Used by the routine at #R$E102.
R $E3FA I:B Left 8 pixels.
R $E3FA I:C Middle 8 pixels.
R $E3FA I:E Right 8 pixels.
R $E3FA O:B Flipped left 8 pixels.
R $E3FA O:C Flipped middle 8 pixels.
R $E3FA O:E Flipped right 8 pixels.
N $E3FA Horizontally flip the bitmap bytes by looking up each byte in the flipped / bit-reversed table at $7F00 and swapping the left and right pixels over.
@ $E3FA label=flip_24_masked_pixels
C $E3FA,2 Point #REGhl into the table of 256 flipped bytes at $7Fxx
C $E3FC,1 Point #REGhl at the flipped byte for #REGe (right pixels)
C $E3FD,1 Shuffle
C $E3FE,1 Load the flipped byte into #REGb
C $E3FF,1 Point #REGhl at the flipped byte for #REGe (left pixels)
C $E400,1 Load the flipped byte into #REGe
C $E401,1 Point #REGhl at the flipped byte for #REGc (middle pixels)
C $E402,1 Load the flipped byte into #REGc
N $E403 Likewise horizontally flip the mask bytes.
C $E403,1 Swap bank to mask bytes
C $E404,2 Point #REGhl into the table of 256 flipped bytes at $7Fxx
C $E406,1 Point #REGhl at the flipped byte for #REGe (right mask)
C $E407,1 Shuffle
C $E408,1 Load the flipped byte into #REGb
C $E409,1 Point #REGhl at the flipped byte for #REGe (left mask)
C $E40A,1 Load the flipped byte into #REGe
C $E40B,1 Point #REGhl at the flipped byte for #REGc (middle mask)
C $E40C,1 Load the flipped byte into #REGc
C $E40D,1 Restore original bank
C $E40E,1 Return
;
c $E40F Horizontally flips the 16 pixels in D,E and counterpart masks in D',E'.
D $E40F Used by the routines at #R$E2AC and #R$E34E.
R $E40F I:D Left 8 pixels.
R $E40F I:E Right 8 pixels.
R $E40F O:D Flipped left 8 pixels.
R $E40F O:E Flipped right 8 pixels.
N $E40F Horizontally flip the bitmap bytes by looking up each byte in the flipped / bit-reversed table at $7F00 and swapping the left and right pixels over.
@ $E40F label=flip_16_masked_pixels
C $E40F,2 Point #REGhl into the table of 256 flipped bytes at $7Fxx
C $E411,1 Point #REGhl at the flipped byte for #REGd (left pixels)
C $E412,1 Shuffle
C $E413,1 Load the flipped byte into #REGe
C $E414,1 Point #REGhl at the flipped byte for #REGd (right pixels)
C $E415,1 Load the flipped byte into #REGd
N $E416 Likewise horizontally flip the mask bytes.
C $E416,1 Swap bank to mask bytes
C $E417,2 Point #REGhl into the table of 256 flipped bytes at $7Fxx
C $E419,1 Point #REGhl at the flipped byte for #REGd (left mask)
C $E41A,1 Shuffle
C $E41B,1 Load the flipped byte into #REGe
C $E41C,1 Point #REGhl at the flipped byte for #REGd (right mask)
C $E41D,1 Load the flipped byte into #REGd
C $E41E,1 Restore original bank
C $E41F,1 Return
;
c $E420 Set up vischar plotting.
D $E420 Used by the routine at #R$B866.
D $E420 Counterpart of, and very similar to, the routine at #R$DC41.
R $E420 I:HL Pointer to visible character
R $E420 I:IY Pointer to visible character
R $E420 O:F Z set if vischar is visible, NZ otherwise
@ $E420 label=setup_vischar_plotting
C $E420,4 Advance #REGhl to vischar.mi.pos
C $E424,3 Point #REGde at tinypos_stash
C $E427,3 Fetch the global current room index
C $E42A,1 Are we outdoors?
C $E42B,2 Jump if so
N $E42D Indoors.
N $E42D Copy vischar.mi.pos.* to tinypos_stash with narrowing.
C $E42D,9 Copy vischar.mi.pos to tinypos_stash (narrowing each element to a byte wide)
C $E436,2 (else)
N $E438 Outdoors.
N $E438 Copy vischar.mi.pos.* to tinypos_stash with scaling.
@ $E438 label=svp_outdoors
C $E438,3 Fetch vischar.mi.pos.x
C $E43B,3 Divide (#REGc,#REGa) by 8 with rounding. Result is in #REGa
C $E43E,1 Store the result as tinypos_stash.x
C $E43F,1 Advance #REGhl to vischar.mi.pos.y
C $E440,1 Advance #REGde to tinypos_stash.y
C $E441,2 Set #REGb for two iterations
@ $E443 label=svp_pos_loop
C $E443,3 Fetch vischar.mi.pos.y or .height
C $E446,3 Divide (#REGc,#REGa) by 8 (with no rounding). Result is in #REGa
C $E449,1 Store the result as tinypos_stash.y or .height
C $E44A,1 Advance to the next vischar.mi.pos field
C $E44B,1 Advance to the next tinypos_stash field (then finally to iso_pos - used later)
C $E44C,2 ...loop
@ $E44E label=svp_tinypos_set
C $E44E,4 Load vischar.mi.sprite (a pointer to a spritedef_t) and stack it
C $E452,1 Advance #REGhl to vischar.mi.sprite_index
C $E453,1 Load it
C $E454,3 Save global sprite_index and left/right flip flag
C $E457,1 Bank it too
C $E458,1 Advance #REGhl to vischar.iso_pos
N $E459 Scale down iso_pos.*
C $E459,2 Set #REGb for two iterations
@ $E45B label=svp_isopos_loop
C $E45B,3 Fetch vischar.iso_pos.x/y
C $E45E,3 Divide (#REGc,#REGa) by 8 (with no rounding). Result is in #REGa
C $E461,1 Write the result to state.iso_pos.*
C $E462,1 Advance #REGhl to the next vischar.iso_pos element
C $E463,1 Advance #REGde to the next state.iso_pos element
C $E464,2 ...loop
C $E466,1 Unbank sprite index
C $E467,1 Restore sprite pointer
C $E468,4 Multiply #REGa by six (width of a spritedef_t)
C $E46C,5 Add onto sprite base pointer
@ $E471 label=svp_sprptr_ready
C $E471,2 Skip over vischar.room and unused bytes
C $E473,1 Put sprite pointer into #REGde
C $E474,2 Copy spritedef width in bytes to vischar
C $E476,2 Copy spritedef height in rows to vischar
C $E478,8 Copy spritedef bitmap and mask pointers to global bitmap_pointer and mask_pointer
C $E480,3 Clip the vischar's dimensions to the game window
C $E483,1 Is it visible?
C $E484,1 Return if not [RET NZ would do]
N $E485 The vischar is visible.
C $E485,1 Preserve the lefthand skip and clipped width
C $E486,1 Preserve the top skip and clipped height
N $E487 Self modify the sprite plotter routines.
C $E487,3 Fetch vischar.width_bytes to check its width
C $E48A,2 Is it 3? (3 => 16 pixels wide, 4 => 24 pixels wide)
C $E48C,2 Jump if 24 wide
@ $E48E label=svp_16_wide
C $E48E,1 Copy the clipped height into #REGa
C $E48F,3 Write clipped height to the instruction at #R$E2C1 in plot_masked_sprite_16px (shift right case)
C $E492,3 Write clipped height to the instruction at #R$E362 in plot_masked_sprite_16px (shift left case)
C $E495,2 Set for three enables
C $E497,3 Point #REGhl at plot_masked_sprite_16px_enables
C $E49A,2 (else)
@ $E49C label=svp_24_wide
C $E49C,1 Copy the clipped height into #REGa
C $E49D,3 Write clipped height to the instruction at #R$E120 in plot_masked_sprite_24px (shift right case)
C $E4A0,3 Write clipped height to the instruction at #R$E1E1 in plot_masked_sprite_24px (shift left case)
C $E4A3,2 Set for four enables
C $E4A5,3 Point #REGhl at plot_masked_sprite_24px_enables
@ $E4A8 label=svp_do_enables
C $E4A8,1 Preserve enables pointer
C $E4A9,4 Write enable count to the instruction at #R$E4BF (self modify) and keep a copy
C $E4AD,2 Is the lefthand skip zero?
C $E4AF,2 Jump if not
N $E4B1 There's no left hand skip - enable instructions.
@ $E4B1 label=svp_enable_is_one
C $E4B1,3 Load #REGa' with the opcode of 'LD (HL),A'
C $E4B4,1 Set a counter to clipped_width. We'll write out this many bytes before clipping
C $E4B5,2 (else)
@ $E4B7 label=svp_enable_is_zero
C $E4B7,2 Load #REGa' with the opcode of 'NOP'
C $E4B9,2 Set a counter to (enable_count - clipped_width). We'll clip until this many bytes have been written
@ $E4BB label=svp_enable_cont
C $E4BB,1 Bank
C $E4BC,1 Restore enables pointer
C $E4BD,1 Move counter to #REGc
C $E4BE,1 Unbank the opcode we'll write
N $E4BF Set the addresses in the jump table to NOP or LD (HL),A.
@ $E4BF label=svp_enables_iters
C $E4BF,2 Set #REGb for 3 iterations (self modified by $E4A9)
N $E4C1 Start loop
@ $E4C1 label=svp_enables_loop
C $E4C1,3 Fetch an address
C $E4C4,1 Write a new opcode
C $E4C5,1 Advance
C $E4C6,3 Fetch an address
C $E4C9,1 Advance
C $E4CA,1 Write a new opcode
C $E4CB,1 Count down the counter
C $E4CC,2 Jump if nonzero
C $E4CE,2 Swap between LD (HL),A and NOP
C $E4D0,2 ...loop
N $E4D2 Calculate Y plotting offset.
N $E4D2 The full calculation can be avoided if we know there are rows to skip since in that case the sprite always starts at the top of the screen.
C $E4D2,1 Bank
C $E4D3,2 Is top skip zero?
C $E4D5,3 Initialise our Y value to zero
C $E4D8,2 Jump if top skip isn't zero
C $E4DA,9 Compute Y = map_position_y * 8 (pixels per column)
C $E4E3,1 Bank the temporary Y
C $E4E4,6 Fetch vischar.iso_pos.y
C $E4EA,1 Clear carry flag
C $E4EB,2 Compute Y = (vischar.iso_pos.y - Y)
C $E4ED,7 Multiply Y by 24 (columns)
C $E4F4,1 Move Y into #REGde
@ $E4F5 label=svp_y_skip_set
C $E4F5,7 Compute x = iso_pos_x - map_position_x
C $E4FC,7 Copy x to #REGhl and sign extend it
@ $E503 label=svp_x_skip_set
C $E503,1 Combine the x and y values
C $E504,4 Add the screen buffer start address
@ $E508 nowarn
C $E508,3 Save the finalised screen buffer pointer
@ $E50B nowarn
C $E50B,3 Point #REGhl at the mask_buffer
C $E50E,2 Retrieve the top skip and clipped height
C $E510,5 mask buffer pointer += top_skip * 4
C $E515,9 mask buffer pointer += (vischar.iso_pos.y & 7) * 4
C $E51E,3 Set foreground_mask_pointer
C $E521,1 Retrieve the top skip and clipped height
C $E522,2 Is top skip zero?
C $E524,2 Jump if so
N $E526 Generic multiply loop.
C $E526,1 Copy top_skip to loop counter
C $E527,1 Zero the accumulator
C $E528,4 Set multiplier to (vischar.width_bytes - 1)
N $E52C Start loop
@ $E52C label=svp_mult_loop
C $E52C,1 Accumulate
C $E52D,1 Decrement counter
C $E52E,3 ...loop
N $E531 #REGd will be set to zero here either way: if the loop terminates, or if jumped into.
C $E531,1 Set #REGde to skip (result)
C $E532,7 Advance bitmap_pointer by 'skip'
C $E539,7 Advance mask_pointer by 'skip'
N $E540 It's unclear as to why this value is preserved since it's not used by the caller.
C $E540,1 Restore the lefthand skip and clipped width
N $E541 The Z flag remains set from #R$E52E signalling "is visible".
C $E541,1 Return
;
c $E542 Scale down a pos_t and assign result to a tinypos_t.
D $E542 Used by the routines at #R$7BB5, #R$9F21, #R$C5D3, #R$C918 and #R$CC37.
D $E542 Divides the three input 16-bit words by 8, with rounding to nearest, storing the result as bytes.
R $E542 I:HL Pointer to input pos_t.
R $E542 I:DE Pointer to output tinypos_t.
R $E542 O:HL Updated.
R $E542 O:DE Updated.
@ $E542 label=pos_to_tinypos
C $E542,2 Set #REGb for three iterations
N $E544 Start loop
C $E544,3 Load (#REGa, #REGc)
C $E547,3 Divide (#REGa, #REGc) by 8, with rounding to nearest
C $E54A,1 Save the result
C $E54B,1 Advance #REGhl to the next input pos
C $E54C,1 Advance #REGde to the next output tinypos
C $E54D,2 ...loop
C $E54F,1 Return
;
c $E550 Divide AC by 8, with rounding to nearest.
D $E550 Used by the routines at #R$7BF2, #R$C47E, #R$E420 and #R$E542.
R $E550 I:A Low.
R $E550 I:C High.
R $E550 O:A Result.
@ $E550 label=divide_by_8_with_rounding
C $E550,5 Add 4 to AC
E $E550 FALL THROUGH into divide_by_8.
;
c $E555 Divide AC by 8.
D $E555 Used by the routines at #R$B2FC, #R$C47E, #R$E420 and #R$E550.
R $E555 I:A Low.
R $E555 I:C High.
R $E555 O:A Result.
@ $E555 label=divide_by_8
C $E555,2 Rotate a bit out of #REGc ...
C $E557,1 Rotate a bit ouf of #REGa ...
C $E558,3 And again
C $E55B,3 And again
C $E55E,1 Return
;
b $E55F Masks
D $E55F Mask encoding: A top-bit-set byte indicates a repetition, the count of which is in the bottom seven bits. The subsequent byte is the value to repeat.
D $E55F { byte count+flags; ... }
@ $E55F label=masks
@ $E55F label=exterior_mask_0
B $E55F,160,8 exterior_mask_0
@ $E5FF label=exterior_mask_1
B $E5FF,31,8*3,7 exterior_mask_1
@ $E61E label=exterior_mask_2
B $E61E,172,8*21,4 exterior_mask_2
@ $E6CA label=exterior_mask_3
B $E6CA,129,8*16,1 exterior_mask_3
@ $E74B label=exterior_mask_4
B $E74B,13,8,5 exterior_mask_4
@ $E758 label=exterior_mask_5
B $E758,39,8*4,7 exterior_mask_5
@ $E77F label=exterior_mask_6
B $E77F,23,8*2,7 exterior_mask_6
@ $E796 label=exterior_mask_7
B $E796,25,8*3,1 exterior_mask_7
@ $E7AF label=exterior_mask_8
B $E7AF,173,8*21,5 exterior_mask_8
@ $E85C label=exterior_mask_9
B $E85C,71,8*8,7 exterior_mask_9
@ $E8A3 label=exterior_mask_10
B $E8A3,77,8*9,5 exterior_mask_10
@ $E8F0 label=exterior_mask_11
B $E8F0,63,8*7,7 exterior_mask_11
@ $E92F label=exterior_mask_12
B $E92F,17,8*2,1 exterior_mask_12
@ $E940 label=exterior_mask_13
B $E940,50,8*6,2 exterior_mask_13
@ $E972 label=exterior_mask_14
B $E972,40,8 exterior_mask_14
@ $E99A label=interior_mask_15
B $E99A,5,5 interior_mask_15
@ $E99F label=interior_mask_16
B $E99F,26,8*3,2 interior_mask_16
@ $E9B9 label=interior_mask_17
B $E9B9,13,8,5 interior_mask_17
@ $E9C6 label=interior_mask_18
B $E9C6,5,5 interior_mask_18
@ $E9CB label=interior_mask_19
B $E9CB,27,8*3,3 interior_mask_19
@ $E9E6 label=interior_mask_20
B $E9E6,15,8,7 interior_mask_20
@ $E9F5 label=interior_mask_21
B $E9F5,25,8*3,1 interior_mask_21
@ $EA0E label=interior_mask_22
B $EA0E,29,8*3,5 interior_mask_22
@ $EA2B label=interior_mask_23
B $EA2B,10,8,2 interior_mask_23
@ $EA35 label=interior_mask_24
B $EA35,14,8,6 interior_mask_24
@ $EA43 label=interior_mask_25
B $EA43,7,7 interior_mask_25
@ $EA4A label=interior_mask_26
B $EA4A,9,8,1 interior_mask_26
@ $EA53 label=interior_mask_27
B $EA53,10,8,2 interior_mask_27
@ $EA5D label=interior_mask_28
B $EA5D,10,8,2 interior_mask_28
@ $EA67 label=interior_mask_29
B $EA67,21,8*2,5 interior_mask_29
;
b $EA7C Interior masking data.
D $EA7C Used only by setup_room.
D $EA7C 47 mask structs with the constant final height byte omitted.
D $EA7C Copied to $81DB by setup_room.
@ $EA7C label=interior_mask_data_source
B $EA7C,7,7 $1B, { $7B, $7F, $F1, $F3 }, { $36, $28 }
B $EA83,7,7 $1B, { $77, $7B, $F3, $F5 }, { $36, $18 }
B $EA8A,7,7 $1B, { $7C, $80, $F1, $F3 }, { $32, $2A }
B $EA91,7,7 $19, { $83, $86, $F2, $F7 }, { $18, $24 }
B $EA98,7,7 $19, { $81, $84, $F4, $F9 }, { $18, $1A }
B $EA9F,7,7 $19, { $81, $84, $F3, $F8 }, { $1C, $17 }
B $EAA6,7,7 $19, { $83, $86, $F4, $F8 }, { $16, $20 }
B $EAAD,7,7 $18, { $7D, $80, $F4, $F9 }, { $18, $1A }
B $EAB4,7,7 $18, { $7B, $7E, $F3, $F8 }, { $22, $1A }
B $EABB,7,7 $18, { $79, $7C, $F4, $F9 }, { $22, $10 }
B $EAC2,7,7 $18, { $7B, $7E, $F4, $F9 }, { $1C, $17 }
B $EAC9,7,7 $18, { $79, $7C, $F1, $F6 }, { $2C, $1E }
B $EAD0,7,7 $18, { $7D, $80, $F2, $F7 }, { $24, $22 }
B $EAD7,7,7 $1D, { $7F, $82, $F6, $F7 }, { $1C, $1E }
B $EADE,7,7 $1D, { $82, $85, $F2, $F3 }, { $23, $30 }
B $EAE5,7,7 $1D, { $86, $89, $F2, $F3 }, { $1C, $37 }
B $EAEC,7,7 $1D, { $86, $89, $F4, $F5 }, { $18, $30 }
B $EAF3,7,7 $1D, { $80, $83, $F1, $F2 }, { $28, $30 }
B $EAFA,7,7 $1C, { $81, $82, $F4, $F6 }, { $1C, $20 }
B $EB01,7,7 $1C, { $83, $84, $F4, $F6 }, { $1C, $2E }
B $EB08,7,7 $1A, { $7E, $80, $F5, $F7 }, { $1C, $20 }
B $EB0F,7,7 $12, { $7A, $7B, $F2, $F3 }, { $3A, $28 }
B $EB16,7,7 $12, { $7A, $7B, $EF, $F0 }, { $45, $35 }
B $EB1D,7,7 $17, { $80, $85, $F4, $F6 }, { $1C, $24 }
B $EB24,7,7 $14, { $80, $84, $F3, $F5 }, { $26, $28 }
B $EB2B,7,7 $15, { $84, $85, $F6, $F7 }, { $1A, $1E }
B $EB32,7,7 $15, { $7E, $7F, $F3, $F4 }, { $2E, $26 }
B $EB39,7,7 $16, { $7C, $85, $EF, $F3 }, { $32, $22 }
B $EB40,7,7 $16, { $79, $82, $F0, $F4 }, { $34, $1A }
B $EB47,7,7 $16, { $7D, $86, $F2, $F6 }, { $24, $1A }
B $EB4E,7,7 $10, { $76, $78, $F5, $F7 }, { $36, $0A }
B $EB55,7,7 $10, { $7A, $7C, $F3, $F5 }, { $36, $0A }
B $EB5C,7,7 $10, { $7E, $80, $F1, $F3 }, { $36, $0A }
B $EB63,7,7 $10, { $82, $84, $EF, $F1 }, { $36, $0A }
B $EB6A,7,7 $10, { $86, $88, $ED, $EF }, { $36, $0A }
B $EB71,7,7 $10, { $8A, $8C, $EB, $ED }, { $36, $0A }
B $EB78,7,7 $11, { $73, $75, $EB, $ED }, { $0A, $30 }
B $EB7F,7,7 $11, { $77, $79, $ED, $EF }, { $0A, $30 }
B $EB86,7,7 $11, { $7B, $7D, $EF, $F1 }, { $0A, $30 }
B $EB8D,7,7 $11, { $7F, $81, $F1, $F3 }, { $0A, $30 }
B $EB94,7,7 $11, { $83, $85, $F3, $F5 }, { $0A, $30 }
B $EB9B,7,7 $11, { $87, $89, $F5, $F7 }, { $0A, $30 }
B $EBA2,7,7 $10, { $84, $86, $F4, $F7 }, { $0A, $30 }
B $EBA9,7,7 $11, { $87, $89, $ED, $EF }, { $0A, $30 }
B $EBB0,7,7 $11, { $7B, $7D, $F3, $F5 }, { $0A, $0A }
B $EBB7,7,7 $11, { $79, $7B, $F4, $F6 }, { $0A, $0A }
B $EBBE,7,7 $0F, { $88, $8C, $F5, $F8 }, { $0A, $0A }
;
w $EBC5 Pointers to run-length encoded mask data.
D $EBC5 The first half is outdoor masks, the second is indoor masks.
R $EBC5 30 pointers to byte arrays.
@ $EBC5 label=mask_pointers
W $EBC5,2,2 exterior_mask
W $EBC7,2,2 exterior_mask
W $EBC9,2,2 exterior_mask
W $EBCB,2,2 exterior_mask
W $EBCD,2,2 exterior_mask
W $EBCF,2,2 exterior_mask
W $EBD1,2,2 exterior_mask
W $EBD3,2,2 exterior_mask
W $EBD5,2,2 exterior_mask
W $EBD7,2,2 exterior_mask
W $EBD9,2,2 exterior_mask
W $EBDB,2,2 exterior_mask
W $EBDD,2,2 exterior_mask
W $EBDF,2,2 exterior_mask
W $EBE1,2,2 exterior_mask
W $EBE3,2,2 interior_mask
W $EBE5,2,2 interior_mask
W $EBE7,2,2 interior_mask
W $EBE9,2,2 interior_mask
W $EBEB,2,2 interior_mask
W $EBED,2,2 interior_mask
W $EBEF,2,2 interior_mask
W $EBF1,2,2 interior_mask
W $EBF3,2,2 interior_mask
W $EBF5,2,2 interior_mask
W $EBF7,2,2 interior_mask
W $EBF9,2,2 interior_mask
W $EBFB,2,2 interior_mask
W $EBFD,2,2 interior_mask
W $EBFF,2,2 interior_mask
;
b $EC01 mask_t structs for the exterior scene.
D $EC01 58 mask_t structs.
D $EC01 'mask_t' defines a mask:
D $EC01 #TABLE(default) { =h Type   | =h Bytes | =h Name | =h Meaning } { Byte      |        1 |   index | An index into mask_pointers } { bounds_t  |        4 |  bounds | The isometric projected bounds of the mask. Used for culling } { tinypos_t |        3 |     pos | If a character is behind this point then the mask is enabled. ("Behind" here means when character coord x is greater and y is greater-or-equal) } TABLE#
D $EC01 Used by render_mask_buffer. Used in outdoor mode only.
@ $EC01 label=exterior_mask_data
B $EC01,464,8
;
g $EDD1 Saved stack pointer.
D $EDD1 Used by plot_game_window and wipe_game_window.
@ $EDD1 label=saved_sp
W $EDD1,2,2
;
w $EDD3 Game screen start addresses.
D $EDD3 128 screen pointers.
@ $EDD3 label=game_window_start_addresses
W $EDD3,256,2
;
c $EED3 Plot the game screen.
D $EED3 This transfers the game's linear screen buffer into the game window region of the Spectrum's screen memory. The input buffer is 24x17x8 bytes. The output region is smaller at 23x16x8 bytes. The addresses are stored precalculated in the table at #R$EDD3.
D $EED3 Scrolling to 4-bit nibble accuracy is permitted by implementing two cases here: aligned and unaligned. Aligned transfers just have to move the bytes across and so are fast. Unaligned transfers have to roll bytes right to effect the left shift, so are much slower.
D $EED3 The aligned case copies 23 bytes per scanline starting at $F291 (one byte into buffer). The unaligned case rolls the bytes right (so it moves left? CHECK) starting at $F290.
D $EED3 Uses the Z80 SP stack trick.
D $EED3 Used by the routines at #R$9D7B and #R$A50B.
@ $EED3 label=plot_game_window
C $EED3,4 Preserve the stack pointer
C $EED7,3 Read upper byte of game_window_offset
C $EEDA,1 Is it nonzero?
C $EEDB,3 Jump if so
@ $EEDE label=pgw_aligned
@ $EEDE nowarn
C $EEDE,3 Point #REGhl at the screen buffer's start address + 1
C $EEE1,3 Read lower byte of game_window_offset
C $EEE4,5 Combine
C $EEE9,3 Point #REGsp at game_window_start_addresses
C $EEEC,2 There are 128 rows
N $EEEE Start loop
C $EEEE,1 Pop a target address off the stack
C $EEEF,46 Copy 23 bytes
C $EF1D,1 Skip the 24th input byte
C $EF1E,4 ...loop
C $EF22,4 Restore the stack pointer
C $EF26,1 Return
@ $EF27 label=pgw_unaligned
C $EF27,3 Point #REGhl at the screen buffer's start address
C $EF2A,3 Read lower byte of game_window_offset
C $EF2D,5 Combine
C $EF32,2 Fetch a first source byte
C $EF34,3 Point #REGsp at game_window_start_addresses
C $EF37,1 Bank
C $EF38,2 There are 128 rows
N $EF3A Start loop
C $EF3A,1 Unbank
C $EF3B,1 Pop a target address off the stack
C $EF3C,2 4 iterations of 5, plus 3 at the end = 23
N $EF3E Start loop
C $EF3E,1 Fetch a second source byte (so we can restore it later)
N $EF3F RRD does a 12-bit rotate: nibble_out = (HL) & $0F; (HL) = ((HL) >> 4) | (A << 4); A = (A & $F0) | nibble_out;
C $EF3F,2 Shift (#REGhl) down and rotate #REGa's bottom nibble into the top of (#REGhl)
C $EF41,1 Bank
C $EF42,1 Load the rotated and merged value
C $EF43,1 Store it to the screen
C $EF44,1 Restore the corrupted byte
C $EF45,1 Unbank
C $EF46,1 Advance
C $EF47,1 Advance
C $EF48,10 Repeat
C $EF52,10 Repeat
C $EF5C,10 Repeat
C $EF66,10 Repeat
C $EF70,2 ...loop
C $EF72,10 Repeat
C $EF7C,10 Repeat
C $EF86,10 Repeat
C $EF90,2 Preload the next scanline's first input byte
C $EF92,1 Unbank
C $EF93,2 ...loop
C $EF95,4 Restore the stack pointer
C $EF99,1 Return
;
c $EF9A Event: roll call.
D $EF9A Range checking that X is in ($72..$7C) and Y is in ($6A..$72).
N $EF9A Is the hero within the roll call area bounds?
@ $EF9A label=event_roll_call
@ $EF9A keep
C $EF9A,3 Load #REGde with the X coordinates of the roll call area ($72..$7C)
C $EF9D,3 Point #REGhl at global map position (hero)
C $EFA0,2 Set #REGb for two iterations
N $EFA2 Start loop
C $EFA2,1 Fetch the next coord
C $EFA3,6 Jump if the hero's out of bounds
C $EFA9,1 On the second iteration advance to hero_map_position_y ($6A..$72)
@ $EFAA keep
C $EFAA,3 On the second iteration load #REGde with the Y coordinates of the main gate ($6A..$72)
C $EFAD,2 ...loop
N $EFAF Make all visible characters turn forward.
@ $EFAF nowarn
C $EFAF,3 Point #REGhl at the visible character's input field (always $800D)
C $EFB2,2 Set #REGb for 8 iterations
N $EFB4 Start loop
C $EFB4,2 Set input to input_KICK
C $EFB6,1 Point #REGhl at the visible character's direction field (always $800E)
C $EFB7,2 Set the direction field to 3 => face bottom left
C $EFB9,4 Advance #REGhl to the next vischar
C $EFBD,2 ...loop
C $EFBF,1 Return
@ $EFC0 label=not_at_roll_call
C $EFC0,4 Make the bell ring perpetually
C $EFC4,4 Queue the message "MISSED ROLL CALL"
C $EFC8,3 Exit via hostiles_pursue
;
c $EFCB Use papers.
D $EFCB Is the hero within the main gate bounds?
N $EFCB Range checking that X is in ($69..$6D) and Y is in ($49..$4B).
@ $EFCB label=action_papers
@ $EFCB keep
C $EFCB,3 Load #REGde with the X coordinates of the main gate ($69..$6D)
C $EFCE,3 Point #REGhl at global map position (hero)
C $EFD1,2 Set #REGb for two iterations
N $EFD3 Start loop
@ $EFD3 label=ap_coord_check_loop
C $EFD3,1 Fetch the next coord
C $EFD4,4 Return if the hero's out of bounds
C $EFD8,1 On the second iteration advance to hero_map_position_y ($49..$4B)
@ $EFD9 keep
C $EFD9,3 On the second iteration load #REGde with the Y coordinates of the main gate
C $EFDC,2 ...loop
N $EFDE The hero was within the bounds of the main gate.
N $EFDE Using the papers at the main gate when not in uniform causes the hero to be sent to solitary. Check for that.
C $EFDE,3 Point #REGde at the guard sprite set
C $EFE1,3 Load hero's vischar.mi.sprite
C $EFE4,4 Jump to solitary if not using the guard sprite set
N $EFE8 The hero was wearing the uniform so is transported outside of the gate.
C $EFE8,3 Increase morale by 10, score by 50
C $EFEB,4 Set hero's vischar.room to room_0_OUTDOORS
N $EFEF Transition to outside the main gate.
@ $EFEF nowarn
C $EFEF,3 Point #REGhl at outside_main_gate location
C $EFF2,4 Point #REGiy at the hero's vischar
C $EFF6,3 Jump to transition -- never returns
N $EFF9 The position outside of the main gate to which the hero is transported.
@ $EFF9 label=outside_main_gate
B $EFF9,3,3
;
c $EFFC Wait for the user to press 'Y' or 'N'.
D $EFFC Used by the routines at #R$9DE5 and #R$F350.
R $EFFC O:F 'Y'/'N' pressed => return Z/NZ
@ $EFFC label=user_confirm
C $EFFC,6 Print "CONFIRM. Y OR N"
N $F002 Start loop (infinite)
C $F002,3 Set #REGbc to port_KEYBOARD_POIUY
C $F005,2 Read the port
C $F007,2 Was bit 4 clear? (active low meaning 'Y' is pressed)
C $F009,1 Return with Z set if so
C $F00A,2 Set #REGbc to port_KEYBOARD_SPACESYMSHFTMNB
C $F00C,2 Read the port
C $F00E,1 Invert the bits to turn active low into active high
C $F00F,2 Was bit 3 set? (active high meaning 'N' is pressed)
C $F011,1 Return with Z clear if so
C $F012,2 ...loop
t $F014 Confirm query.
B $F014,18,18 "CONFIRM. Y OR N" #HTML[/ #CALL:decode_screenlocstring($F014)]
t $F026 Further game messages.
@ $F026 label=more_messages_he_takes_the_bribe
B $F026,19,19 "HE TAKES THE BRIBE" #HTML[/ #CALL:decode_stringFF($F026)]
@ $F039 label=more_messages_and_acts_as_decoy
B $F039,18,18 "AND ACTS AS DECOY" #HTML[/ #CALL:decode_stringFF($F039)]
@ $F04B label=more_messages_another_day_dawns
B $F04B,18,18 "ANOTHER DAY DAWNS" #HTML[/ #CALL:decode_stringFF($F04B)]
;
b $F05D Locked gates and doors.
@ $F05D label=locked_doors
B $F05D,2,2 gates
B $F05F,7,7 doors
B $F066,2,2 unused
;
c $F068 Jump to main.
D $F068 Used by the routine at #R$FDE1.
@ $F068 label=jump_to_main
;
g $F06B User-defined keys.
D $F06B Pairs of (port, key mask).
@ $F06B label=keydefs
B $F06B,2,2 Left
B $F06D,2,2 Right
B $F06F,2,2 Up
B $F071,2,2 Down
B $F073,2,2 Fire
> $F075
> $F075 ; Everything from $F0F8 onwards is potentially overwritten by the game once the main menu is exited.
> $F075 ;
> $F075 ; Memory Map
> $F075 ; ----------
> $F075 ; $F0F8..$F28F - 24x17 = 408 bytes of tile_buf
> $F075 ; $F290..$FF4F - 24x17x8 = 3,264 bytes of window_buf
> $F075 ; $FF50..$FF57 - seems to be an extra UDG's worth of window_buf to allow overspills
> $F075 ; $FF58..$FF7A - 7x5 = 35 bytes of map_buf
> $F075 ; $FF80..$FFFF - the stack
> $F075
;
g $F075 Static tiles plot direction.
D $F075 #TABLE(default,centre) { =h Value | =h Meaning } {        0 | Horizontal } {      255 | Vertical   } TABLE#
@ $F075 label=static_tiles_plot_direction
B $F075,1,1
;
b $F076 Definitions of fixed graphic elements.
D $F076 Only used by #R$F1E0.
D $F076 #TABLE(default) { =h Type | =h Bytes | =h Name          | =h Meaning                } { Pointer |        2 | screenloc        | Screen address to draw at } { Byte    |        1 | flags_and_length | Direction flag and length } { Byte    |   Length | tiles            | Index into static_tiles   } TABLE#
@ $F076 label=static_graphic_defs
@ $F076 label=statics_flagpole
@ $F08D label=statics_game_window_left_border
@ $F0A4 label=statics_game_window_right_border
@ $F0BB label=statics_game_window_top_border
@ $F0D5 label=statics_game_window_bottom
@ $F0EF label=statics_flagpole_grass
@ $F0F7 label=statics_medals_row0
@ $F107 label=statics_medals_row1
@ $F115 label=statics_medals_row2
@ $F123 label=statics_medals_row3
@ $F131 label=statics_medals_row4
@ $F13E label=statics_bell_row0
@ $F144 label=statics_bell_row1
@ $F14A label=statics_bell_row2
@ $F14F label=statics_corner_tl
@ $F154 label=statics_corner_tr
@ $F159 label=statics_corner_bl
@ $F15E label=statics_corner_br
B $F076,237,23*3,26*2,8,16,14*3,13,6*2,5
;
c $F163 The game starts here.
D $F163 Used by the routine at #R$F068.
@ $F163 label=main
C $F163,1 Disable interrupts
N $F164 Q: Why is the stack pointer set to $FFFE here when squash_stack_goto_main sets it to $FFFF?
C $F164,3 Point the stack pointer at the end of RAM
N $F167 Clear the screen.
C $F167,3 Clear the full screen and attributes and set the screen border to black
N $F16A Set the morale flag to green.
C $F16A,2 Set #REGa to attribute_BRIGHT_GREEN_OVER_BLACK
C $F16C,3 Set the screen attributes of the morale flag
N $F16F Draw everything else.
N $F16F Bug: This passes in index $44 to #R$F408 in #REGa, but it ought to be zero.
C $F16F,2 Set #REGe to attribute_BRIGHT_YELLOW_OVER_BLACK
C $F171,3 Set the screen attributes of the specified menu item
C $F174,3 Plot all static graphics and menu text
C $F177,3 Draw the current score to screen
N $F17A Run the menu screen.
N $F17A We'll be in here for some time until the user selects their input method. When we return we'll continue setting up the things required for the game, then jump into the main loop.
C $F17A,3 Runs the menu screen
N $F17D Construct a table of 256 bit-reversed bytes at $7F00.
C $F17D,3 Point #REGhl at $7F00
N $F180 Start loop
C $F180,1 Shuffle
C $F181,2 Zero #REGc (Commentary: Could have used XOR C)
N $F183 Reverse a byte
C $F183,2 Set #REGb for eight iterations
N $F185 Start loop
C $F185,1 Shift out lowest bit from #REGa into carry
C $F186,2 Shift carry into #REGc
C $F188,2 ...loop until the byte is completed
C $F18A,2 Store the reversed byte
C $F18C,3 ...loop until #REGl becomes zero
C $F18F,1 Advance #REGhl to $8000
N $F190 Initialise visible characters (#REGhl is $8000).
@ $F190 nowarn
C $F190,3 Point #REGde at vischar_initial
C $F193,2 Set #REGb for eight iterations
N $F195 Start loop
C $F195,1 Preserve loop counter
C $F196,1 Preserve vischar_initial
C $F197,1 Preserve vischar pointer
C $F198,6 Populate the vischar slot with vischar_initial's data
C $F19E,1 Restore vischar pointer
C $F19F,4 Advance #REGhl to the next vischar (assumes no overflow)
C $F1A3,1 Restore vischar_initial
C $F1A4,3 ...loop until the vischars are populated
N $F1A7 Write $FF $FF at $8020 and every 32 bytes after. (Commentary: It could be easier to do the inverse and clear those bytes at $8000).
C $F1A7,2 Set #REGb for seven iterations
N $F1A9 Iterate over non-player visible characters.
@ $F1A9 nowarn
C $F1A9,3 Start at the second visible character
C $F1AC,3 Prepare the vischar stride, minus a byte
C $F1AF,2 Prepare the index / flags initialiser
N $F1B1 Start loop
C $F1B1,1 Set the vischar's character index to $FF
C $F1B2,1 Advance #REGhl to the flags field
C $F1B3,1 Set the vischar's flags to $FF
C $F1B4,1 Advance the vischar pointer
C $F1B5,2 ...loop until the vischar flags are set
N $F1B7 Zero $118 bytes at #REGhl ($8100 is mask_buffer) onwards.
N $F1B7 This wipes everything up until the start of tiles ($8218).
C $F1B7,3 Set #REGb to $118
N $F1BA Start loop
C $F1BA,3 Zero and advance
C $F1BD,6 ...loop until cleared
C $F1C3,3 Reset the game
C $F1C6,3 Jump to main_loop_setup
N $F1C9 Initial state of a visible character.
@ $F1C9 label=vischar_initial
B $F1C9,1,1 character
B $F1CA,1,1 flags
W $F1CB,2,2 route
B $F1CD,3,3 target
B $F1D0,1,1 counter_and_flags
W $F1D1,2,2 animbase
W $F1D3,2,2 anim
B $F1D5,1,1 animindex
B $F1D6,1,1 input
B $F1D7,1,1 direction
W $F1D8,6,6 mi.pos
W $F1DE,2,2 mi.sprite
;
c $F1E0 Plot all static graphics and menu text.
D $F1E0 Used by the routine at #R$F163.
@ $F1E0 label=plot_statics_and_menu_text
C $F1E0,3 Point #REGhl at static_graphic_defs
C $F1E3,2 Set #REGb for 18 iterations
N $F1E5 Start loop
C $F1E5,1 Preserve the loop counter
C $F1E6,4 Read the target screen address
C $F1EA,2 Is the statictiles_VERTICAL flag set?
C $F1EC,2 Jump if not
C $F1EE,3 Plot static tiles vertically
C $F1F1,2 (else)
C $F1F3,3 Plot static tiles horizontally
C $F1F6,1 Restore the loop counter
C $F1F7,2 ...loop
N $F1F9 Plot menu text.
C $F1F9,2 Set #REGb for 8 iterations
C $F1FB,3 Point #REGhl at key_choice_screenlocstrings
N $F1FE Start loop
C $F1FE,1 Preserve the loop counter
C $F1FF,3 Plot a single glyph (indirectly)
C $F202,1 Restore the loop counter
C $F203,2 ...loop
C $F205,1 Return
;
c $F206 Plot static tiles horizontally.
D $F206 Used by the routine at #R$F1E0.
R $F206 I:DE Pointer to screen address.
R $F206 I:HL Pointer to [count, tile indices, ...].
@ $F206 label=plot_static_tiles_horizontal
C $F206,1 Set direction flag to zero
C $F207,2 Exit via plot static tiles
;
c $F209 Plot static tiles vertically.
D $F209 Used by the routine at #R$F1E0.
R $F209 I:DE Pointer to screen address.
R $F209 I:HL Pointer to [count, tile indices, ...].
@ $F209 label=plot_static_tiles_vertical
C $F209,2 Set the plot direction flag to $FF (vertical)
E $F209 FALL THROUGH into plot_static_tiles
;
c $F20B Plot static tiles.
D $F20B Used by the routine at #R$F206.
R $F20B I:A Plot direction: 0 => horizontal, $FF => vertical.
R $F20B I:DE Pointer to destination screen address.
R $F20B I:HL Pointer to remainder of static graphic bytes [flags_and_length, tile indices...].
@ $F20B label=plot_static_tiles
C $F20B,3 Save a copy of the plot direction
C $F20E,1 Load flags_and_length
C $F20F,2 Mask off length
C $F211,1 Set #REGb for loop iterations
C $F212,1 Advance to tile indices
C $F213,1 Preserve the pointer to screen address
C $F214,1 Bank
C $F215,1 Restore the pointer to screen address
C $F216,1 Unbank
N $F217 Start loop (once for each tile)
C $F217,1 Read a tile index
C $F218,1 Bank
N $F219 Point #REGhl at static_tiles[tileindex]
C $F219,10 Multiply the tile index by 9
C $F223,3 Point #REGbc at static_tiles[0]
C $F226,1 Combine
C $F227,2 Set #REGb for 8 iterations
N $F229 Plot a tile.
N $F229 Start loop (once for each byte/row)
C $F229,2 Copy a byte of tile
C $F22B,2 Advance #REGde to the next screen row
C $F22D,2 ...loop
C $F22F,1 Step #REGde back so it's still in the right block
C $F230,1 Preserve screen pointer
N $F231 Calculate screen attribute address of tile.
C $F231,1 Get screen pointer high byte
C $F232,2 Set the attribute pointer to $58xx by default
C $F234,5 If the screen pointer is $48xx... set the attribute pointer to $59xx
C $F239,5 If the screen pointer is $50xx... set the attribute pointer to $5Axx
C $F23E,2 Copy the attribute byte which follows the tile data
C $F240,1 Restore screen pointer
C $F241,3 Fetch static_tiles_plot_direction
C $F244,1 Is it vertical?
C $F245,2 Jump if so
N $F247 Horizontal
N $F247 Reset and advance the screen pointer
C $F247,4 Rewind the screen pointer by 7 rows
C $F24B,1 Advance to the next character
C $F24C,2 (else)
N $F24E Vertical
C $F24E,3 Get the same position on the next scanline down
C $F251,1 Move new scanline pointer into #REGde
C $F252,1 Unbank
C $F253,1 Advance to the next input byte
C $F254,2 ...loop
C $F256,1 Return
;
c $F257 Clear the full screen and attributes and set the screen border to black.
D $F257 Used by the routine at #R$F163.
N $F257 Clear the pixels to zero
@ $F257 label=wipe_full_screen_and_attributes
C $F257,3 Point #REGhl at the start of the screen (source address)
C $F25A,3 Point #REGde at the start of the screen plus a byte (destination address)
C $F25D,2 Set the first screen byte to zero
C $F25F,3 6143 bytes
C $F262,2 Copy source to destination 6143 times, advancing until the screen is cleared
N $F264 Clear the attributes to white over black
C $F264,1 Advance #REGhl to the start of the attributes (source address)
C $F265,1 Advance #REGde to the start of the attributes plus a byte (destination address)
C $F266,2 Set the first attribute byte to seven (white over black)
C $F268,3 767 bytes
C $F26B,2 Copy source to destination 767 times, advancing until the screen is cleared
N $F26D Set the border to black
C $F26D,1 Set #REGa to zero
C $F26E,2 Set the border (and speaker)
C $F270,1 Return
;
c $F271 Menu screen key handling.
D $F271 Used by the routine at #R$F4B7.
D $F271 Scan for a keypress. It will either start the game, select an input device or do nothing. If an input device is chosen, update the menu highlight to match and record which input device was chosen.
D $F271 If the game is started then copy the required input routine to $F075. If the chosen input device is the keyboard, then exit via choose_keys.
@ $F271 label=check_menu_keys
C $F271,3 Scan for keys that select an input device. Result is in #REGa
C $F274,2 Nothing selected?
C $F276,1 Return if so
C $F277,1 Start game (zero) pressed?
C $F278,2 Jump if so
C $F27A,1 Turn 1..4 into 0..3
N $F27B Clear old selection.
C $F27B,1 Preserve index
C $F27C,3 Load previously chosen input device index
C $F27F,2 Set #REGe to attribute_WHITE_OVER_BLACK
C $F281,3 Set the screen attributes of the specified menu item
C $F284,1 Restore index
N $F285 Highlight new selection.
C $F285,3 Set chosen input device index
C $F288,2 Set #REGe to attribute_BRIGHT_YELLOW_OVER_BLACK
C $F28A,3 Set the screen attributes of the specified menu item
C $F28D,1 Return
N $F28E Zero pressed to start game.
N $F28E Copy the input routine to $F075, choose keys if keyboard was chosen, then return to main.
@ $F28E label=cmk_cpy_rout
C $F28E,3 Load chosen input device index
C $F291,1 Double it
N $F292 This is tricky. #REGa' is left with the low byte of the inputroutine address. In the case of the keyboard, it's zero. choose_keys relies on that in a non-obvious way. [DPT: Check this comment]
C $F292,3 Widen to #REGbc
C $F295,1 Preserve index
C $F296,3 Point #REGhl at the list of available input routines
C $F299,1 Combine
C $F29A,4 Fetch input routine address into #REGhl
C $F29E,3 Set the destination address
C $F2A1,3 Worst-case length of an input routine
C $F2A4,2 Copy
C $F2A6,1 Restore index
C $F2A7,1 Was the keyboard chosen?
C $F2A8,3 Call choose keys if so
C $F2AB,2 Discard the previous return address and resume at #R$F17D
t $F2AD Key choice prompt strings.
@ $F2AD label=define_key_prompts
B $F2AD,14,12:c1:1 "CHOOSE KEYS" #HTML[/ #CALL:decode_screenlocstring($F2AD)]
B $F2BB,8,7:c1 "LEFT." #HTML[/ #CALL:decode_screenlocstring($F2BB)]
B $F2C3,9,8:c1 "RIGHT." #HTML[/ #CALL:decode_screenlocstring($F2C3)]
B $F2CC,6,5:c1 "UP." #HTML[/ #CALL:decode_screenlocstring($F2CC)]
B $F2D2,8,7:c1 "DOWN." #HTML[/ #CALL:decode_screenlocstring($F2D2)]
B $F2DA,7,7 "FIRE." #HTML[/ #CALL:decode_screenlocstring($F2DA)]
;
b $F2E1 byte_F2E1
D $F2E1 Unsure if anything reads this byte for real, but its address is taken prior to accessing keyboard_port_hi_bytes.
D $F2E1 (<- choose_keys)
@ $F2E1 label=byte_F2E1
B $F2E1,1,1
;
b $F2E2 Table of keyscan high bytes.
D $F2E2 Zero terminated.
D $F2E2 (<- choose_keys)
@ $F2E2 label=keyboard_port_hi_bytes
B $F2E2,9,9
t $F2EB Table of special key name strings, prefixed by their length.
@ $F2EB label=special_key_names
B $F2EB,6,6 "ENTER" #HTML[/ #CALL:decode_stringcounted($F2EB)]
B $F2F1,5,5 "CAPS" #HTML[/ #CALL:decode_stringcounted($F2F1)]
B $F2F6,7,7 "SYMBOL" #HTML[/ #CALL:decode_stringcounted($F2F6)]
B $F2FD,6,6 "SPACE" #HTML[/ #CALL:decode_stringcounted($F2FD)]
;
b $F303 Table mapping key codes to glyph indices.
D $F303 Each table entry is a character (a glyph index) OR if its top bit is set then bottom seven bits are an index into special_key_names.
@ $F303 label=keycode_to_glyph
B $F303,5,5 table_12345
B $F308,5,5 table_09876
B $F30D,5,5 table_QWERT
B $F312,5,5 table_POIUY
B $F317,5,5 table_ASDFG
B $F31C,5,5 table_ENTERLKJH
B $F321,5,5 table_SHIFTZXCV
B $F326,5,5 table_SPACESYMSHFTMNB
;
w $F32B Screen addresses where chosen key names are plotted.
@ $F32B label=key_name_screen_addrs
W $F32B,10,2
;
c $F335 Wipe the game screen.
D $F335 This wipes the area of the screen where the game window is plotted.
D $F335 Used by the routine at #R$F350.
@ $F335 label=wipe_game_window
C $F335,1 Disable interrupts
N $F336 This uses the optimisation trick of popping addresses from the stack.
C $F336,4 Save the stack pointer
C $F33A,3 Point the stack pointer at game_window_start_addresses
C $F33D,2 Set #REGa for 128 iterations (128 rows)
N $F33F Start loop
C $F33F,1 Pull a start address from the stack
C $F340,2 Set #REGb for 23 iterations (23 bytes)
N $F342 Start loop
C $F342,2 Write an empty byte
C $F344,1 Advance (note cheap increment)
C $F345,2 ...loop
C $F347,4 ...loop
C $F34B,4 Restore the stack pointer
C $F34F,1 Return
;
c $F350 Choose keys.
D $F350 Used by the routine at #R$F271.
N $F350 Start loop (infinite) - loops until the user confirms the key selection.
N $F350 Clear the game window.
@ $F350 label=choose_keys
C $F350,3 Wipe the game screen
C $F353,5 Set game window attributes to attribute_WHITE_OVER_BLACK
N $F358 Draw key choice prompts.
C $F358,2 Set #REGb for six iterations
C $F35A,3 Point #REGhl at define_key_prompts
N $F35D Start loop (once per prompt)
@ $F35D label=ck_prompts_loop
C $F35D,1 Preserve the loop counter
C $F35E,4 Read screen address
C $F362,2 Read string length
N $F364 Draw the prompt's glyphs.
N $F364 Start loop (once per character)
@ $F364 label=ck_draw_prompt
C $F364,1 Preserve string length
N $F365 Bug: The next load is needless (plot_glyph does it already).
C $F365,1 Read a glyph
C $F366,3 Plot a single glyph (indirectly)
C $F369,1 Advance the string pointer
C $F36A,1 Restore string length
C $F36B,2 ...loop (once per character)
C $F36D,1 Restore the loop counter
C $F36E,2 ...loop (once per prompt)
N $F370 Wipe key definitions.
C $F370,3 Point #REGhl at keydefs
C $F373,2 Set #REGb for 10 iterations
C $F375,1 Zero #REGa in preparation
N $F376 Start loop
@ $F376 label=ck_clear_keydef
C $F376,1 Zero a byte of keydef
C $F377,1 Advance #REGhl
C $F378,2 ...loop
N $F37A Now scan for keys.
C $F37A,2 Set #REGb for five iterations: left/right/up/down/fire
C $F37C,3 Point #REGhl at key_name_screen_addrs
N $F37F Start loop (once per direction+fire)
@ $F37F label=ck_keyscan_loop
C $F37F,1 Preserve the loop counter
C $F380,4 Read screen address
C $F384,1 Preserve screen address
C $F385,4 Self modify the "LD DE,$xxxx" at #R$F3E8 to load the screen address
C $F389,2 Set the debounce flag. This is only set to zero once we've checked the whole keyboard and no keys are pressed, at which point it gets set to zero
N $F38B Start loop (infinite)
@ $F38B label=ck_keyscan_inner
C $F38B,1 Bank the debounce flag
C $F38C,3 Point #REGhl at keyboard_port_hi_bytes[-1]
C $F38F,2 Initialise the port index
N $F391 Start loop
@ $F391 label=ck_try_next_port
C $F391,1 Advance #REGhl to the next port high byte
C $F392,1 Increment the port index
C $F393,1 Read the port high byte
C $F394,1 Have we reached the end of keyboard_port_hi_bytes? ($00)
C $F395,2 ...loop if so (zero in #REGa becomes new debounce flag)
C $F397,1 Read port high byte
C $F398,2 Read port $FE
C $F39A,2 Read the keyboard port
C $F39C,1 Invert the bits to turn active low into active high
C $F39D,1 Copy the result into #REGe so we can restore it each time
C $F39E,2 Create a mask with bit 5 set
N $F3A0 Test bits 4,3,2,1,0
@ $F3A0 label=ck_keyscan_detect
C $F3A0,2 Shift the mask right
C $F3A2,2 Jump (to try next port) if the mask bit got shifted out
C $F3A4,2 Mask the result
C $F3A6,2 ...loop while no keys are pressed
N $F3A8 We arrive here if a key was pressed.
C $F3A8,1 Unbank the debounce flag
C $F3A9,1 Is it set?
C $F3AA,2 Restart the loop if so (#REGa is debounce flag)
C $F3AC,2 Bank the port index
C $F3AE,3 Point #REGhl at the byte before keydefs
N $F3B1 Start loop
@ $F3B1 label=ck_next_keydef
C $F3B1,1 Advance to the next keydef
C $F3B2,1 Read the keydef.port
C $F3B3,1 Is it an empty slot?
C $F3B4,2 Jump if so (assign keydef)
C $F3B6,1 Does the port high byte match?
C $F3B7,1 Advance #REGhl (interleaved)
C $F3B8,2 ...loop if different
C $F3BA,1 Read keydef.mask
C $F3BB,1 Does the mask match?
C $F3BC,2 ...loop if different
C $F3BE,3 ...loop (infinite) (mask in #REGa becomes new debounce flag)
N $F3C1 Assign key definition.
@ $F3C1 label=ck_assign_keydef
C $F3C1,2 Store port
C $F3C3,1 Store mask
C $F3C4,1 Unbank the port index
C $F3C5,4 Multiply it by 5
@ $F3C9 nowarn
C $F3C9,3 Point #REGhl one byte prior to #R$F303. This is off-by-one to compensate for the upcoming preincrement
C $F3CC,5 Combine
N $F3D1 Skip entries until the mask carries out.
@ $F3D1 label=ck_find_key_glyph
C $F3D1,1 Advance the glyph pointer
C $F3D2,2 Shift mask
C $F3D4,2 ...loop until the mask carries out
C $F3D6,2 Set length to 1
C $F3D8,1 Load the glyph
C $F3D9,1 Test the top bit
C $F3DA,3 Jump if clear (JP P => positive)
N $F3DD If the top bit was set then it's a special key, like BREAK or ENTER.
C $F3DD,2 Extract the byte offset into special_key_names
C $F3DF,3 Point #REGde at special_key_names
C $F3E2,3 Widen byte offset into #REGhl
C $F3E5,1 Combine
C $F3E6,1 First byte is length of special key name
C $F3E7,1 Advance #REGhl to point at glyphs
N $F3E8 Plot.
@ $F3E8 label=ck_plot_glyph
C $F3E8,3 Point #REGde at (a self modified screen address)
N $F3EB Start loop (draw key)
@ $F3EB label=ck_plot_glyph_loop
C $F3EB,1 Preserve the loop counter
N $F3EC Bug: The next load is needless (plot_glyph does it already).
C $F3EC,1 Read a glyph
C $F3ED,3 Plot a single glyph (indirectly)
C $F3F0,1 Advance to next glyph index
C $F3F1,1 Restore the loop counter
C $F3F2,2 ...loop (draw key)
C $F3F4,1 Restore screen address
C $F3F5,1 Restore the loop counter
C $F3F6,3 ...loop (once per direction+fire)
N $F3F9 Delay loop.
N $F3F9 This delays execution by approximately a third of a second (~1.25M T-states).
C $F3F9,3 Set #REGbc to $FFFF
@ $F3FC label=ck_delay
C $F3FC,5 Count down until it's zero
N $F401 Wait for the user's confirmation.
C $F401,3 Wait for the user to confirm by pressing 'Y' or 'N'
C $F404,1 If Z set 'Y' was pressed so return
C $F405,3 ...loop (infinite)
;
c $F408 Set the screen attributes of the specified menu item.
D $F408 Used by the routines at #R$F163 and #R$F271.
R $F408 I:A Menu item index.
R $F408 I:E Attributes.
@ $F408 label=set_menu_item_attributes
C $F408,3 Point #REGhl at the first menu item's attributes
N $F40B Skip to the item's row.
C $F40B,1 Is the index zero?
C $F40C,2 Jump if so - no need to advance the pointer
C $F40E,1 Set #REGb for (item index) iterations
N $F40F Start loop
C $F40F,4 Advance by two attribute rows per iteration (64 bytes)
C $F413,2 ...loop
N $F415 Set the attributes.
C $F415,2 Set #REGb for ten iterations
N $F417 Start loop
C $F417,1 Set one attribute byte
C $F418,1 Advance to the next
C $F419,2 ...loop
C $F41B,1 Return
;
c $F41C Scan for keys that select an input device.
D $F41C Used by the routine at #R$F271.
R $F41C O:A 0/1/2/3/4 if that key was pressed, or 255 if no relevant key was pressed.
@ $F41C label=menu_keyscan
C $F41C,3 Set #REGbc to port_KEYBOARD_12345
C $F41F,2 Initialise a counter
C $F421,2 Read the port
C $F423,1 Invert the bits to turn active low into active high
C $F424,2 Mask off bits for 1,2,3,4
C $F426,2 If none were pressed then check for zero
N $F428 Which key was pressed?
C $F428,2 Set #REGb for 4 iterations
N $F42A Start loop
@ $F42A label=mk_loop
C $F42A,1 Shift out a bit
C $F42B,1 Increment the counter
C $F42C,2 Did a bit carry out? Jump if so
C $F42E,2 ...loop
@ $F430 label=mk_found
C $F430,2 Return 1..4
@ $F432 label=mk_check_for_0
C $F432,2 Set #REGbc to port_KEYBOARD_09876
C $F434,2 Read the port
C $F436,2 Was 0 pressed? (note active low)
C $F438,2 Return 0 if so
C $F43A,3 Otherwise return $FF
;
w $F43D List of available input routines.
D $F43D Array [4] of pointers to input routines.
@ $F43D label=inputroutines
W $F43D,8,2
;
g $F445 Chosen input device.
D $F445 #TABLE(default,centre) { =h Value | =h Meaning } { 0 | Keyboard } { 1 | Kempston } { 2 | Sinclair } { 3 | Protek } TABLE#
@ $F445 label=chosen_input_device
B $F445,1,1
t $F446 Key choice screenlocstrings.
@ $F446 label=key_choice_screenlocstrings
B $F446,11,11 "CONTROLS" #HTML[/ #CALL:decode_screenlocstring($F446)]
B $F451,11,11 "0 SELECT" #HTML[/ #CALL:decode_screenlocstring($F451)]
B $F45C,13,13 "1 KEYBOARD" #HTML[/ #CALL:decode_screenlocstring($F45C)]
B $F469,13,13 "2 KEMPSTON" #HTML[/ #CALL:decode_screenlocstring($F469)]
B $F476,13,13 "3 SINCLAIR" #HTML[/ #CALL:decode_screenlocstring($F476)]
B $F483,11,11 "4 PROTEK" #HTML[/ #CALL:decode_screenlocstring($F483)]
B $F48E,26,26 "BREAK OR CAPS AND SPACE" #HTML[/ #CALL:decode_screenlocstring($F48E)]
B $F4A8,15,15 "FOR NEW GAME" #HTML[/ #CALL:decode_screenlocstring($F4A8)]
;
c $F4B7 Run the menu screen.
D $F4B7 Waits for user to select an input device, waves the morale flag and plays the title tune.
D $F4B7 Used by the routine at #R$F163.
N $F4B7 Start loop (infinite)
@ $F4B7 label=menu_screen
C $F4B7,3 Handle menu screen keys. When the user starts the game this call will cease to return.
C $F4BA,3 Wave the morale flag (on every other turn)
N $F4BD Play music.
C $F4BD,4 Fetch and increment the music channel 0 index
N $F4C1 Start loop (infinite)
@ $F4C1 label=ms_loop0
C $F4C1,3 Save the music channel 0 index
C $F4C4,3 Point #REGde at music_channel0_data
C $F4C7,1 Add the index
C $F4C8,1 Fetch a semitone
C $F4C9,2 Was it the end of song marker? ($FF)
C $F4CB,2 Jump if not
C $F4CD,5 Otherwise zero the index and start over
@ $F4D2 label=ms_break0
C $F4D2,3 Get frequency for semitone
C $F4D5,1 Bank the channel 0 parameters
C $F4D6,4 Fetch and increment the music channel 1 index
N $F4DA Start loop (infinite)
@ $F4DA label=ms_loop1
C $F4DA,3 Save the music channel 1 index
C $F4DD,3 Point #REGde at music_channel1_data
C $F4E0,1 Add the index
C $F4E1,1 Fetch a semitone
C $F4E2,2 Was it the end of song marker? ($FF)
C $F4E4,2 Jump if not
C $F4E6,5 Otherwise zero the index and start over
@ $F4EB label=ms_break1
C $F4EB,3 Get frequency for semitone
N $F4EE When the second channel is silent use the first channel's frequency.
C $F4EE,1 Get the second channel's frequency low byte (note #REGb is low here due to endian swap)
C $F4EF,1 Unbank the channel 0 parameters
C $F4F0,1 Save channel 0's frequency
C $F4F1,2 Is channel 1's frequency $xxFF?
C $F4F3,2 Jump if not
C $F4F5,1 Otherwise swap banks to channel 1's registers
C $F4F6,3 Copy channel 0's frequency to channel 1
C $F4F9,1 Bank again
C $F4FA,2 Jump
C $F4FC,1 Discard saved frequency
N $F4FD Iterate 6,120 times (24 * 255)
C $F4FD,2 Set major tune speed (a delay: lower means faster)
N $F4FF Start loop (major)
C $F4FF,1 Bank the major counter
C $F500,2 Set minor tune speed (a delay: lower means faster)
N $F502 Start loop (minor)
N $F502 Play channel 0's part
C $F502,2 Decrement #REGb (low). Jump over next block unless zero
C $F504,1 Decrement #REGc (high)
C $F505,3 Jump over next block unless zero
N $F508 Countdown hit zero
C $F508,6 Toggle the speaker bit (#REGl is zeroed by frequency_for_semitone)
C $F50E,2 Reset counter
C $F510,1 Swap to registers for channel 1
N $F511 Play channel 1's part
C $F511,2 Decrement #REGb (low). Jump over next block unless zero
C $F513,1 Decrement #REGc (high)
C $F514,3 Jump over next block unless zero
N $F517 Countdown hit zero
C $F517,6 Toggle the speaker bit (#REGl is zeroed by frequency_for_semitone)
C $F51D,2 Reset counter
C $F51F,1 Swap to registers for channel 0
C $F520,4 ...loop (minor tune speed) / 255 iterations
C $F524,1 Unbank the major counter
C $F525,4 ...loop (major tune speed) / 24 iterations
C $F529,3 ...loop (infinite)
;
c $F52C Return the frequency to play at to generate the given semitone.
D $F52C The frequency returned is the number of iterations that the music routine should count for before flipping the speaker output bit.
D $F52C Used by the routine at #R$F4B7.
R $F52C I:A Semitone index (never larger than 42 in this game).
R $F52C O:BC Frequency.
R $F52C O:DE Frequency.
R $F52C O:L Zero.
@ $F52C label=frequency_for_semitone
C $F52C,1 Double #REGa for index
C $F52D,3 Point #REGhl at the semitone to frequency table
C $F530,3 Widen: #REGde = #REGa
C $F533,1 Add
C $F534,3 Fetch frequency from table
N $F537 Commentary: This increment could be baked into the table itself.
C $F537,1 Increment
C $F538,1 Increment
C $F539,3 If #REGb rolled over, increment #REGc (big endian?)
C $F53C,2 Reset #REGl - this is the border+beeper value for OUT
C $F53E,2 Return #REGde and #REGbc the same
C $F540,1 Return
;
g $F541 Music channel indices.
@ $F541 label=music_channel0_index
@ $F543 label=music_channel1_index
W $F541,4,2
;
u $F545 Unreferenced byte.
B $F545,1,1
;
b $F546 High music channel notes (semitones).
D $F546 Start of The Great Escape theme.
@ $F546 label=music_channel0_data
B $F546,134,8*16,6
N $F5CC Start of "Pack Up Your Troubles in Your Old Kit Bag".
B $F5CC,254,2,8*31,4
N $F6CA Start of "It's a Long Way to Tipperary".
B $F6CA,252,4,8
N $F7C6 End of song marker
B $F7C6,1,1
N $F7C7 Low music channel notes (semitones).
N $F7C7 Start of The Great Escape theme.
@ $F7C7 label=music_channel1_data
B $F7C7,134,8*16,6
N $F84D Start of "Pack Up Your Troubles in Your Old Kit Bag".
B $F84D,254,2,8*31,4
N $F94B Start of "It's a Long Way to Tipperary".
B $F94B,252,4,8
N $FA47 End of song marker
B $FA47,1,1
N $FA48 The frequency to use to produce the given semitone.
N $FA48 Covers full octaves from C2 to B6 and C7 only.
N $FA48 Used by #R$F52C
@ $FA48 label=semitone_to_frequency
W $FA48,2,2 delay
W $FA4A,2,2 unused
W $FA4C,2,2 unused
W $FA4E,2,2 unused
W $FA50,2,2 unused
N $FA52 Octave 2
W $FA52,2,2 C2
W $FA54,2,2 C2#
W $FA56,2,2 D2
W $FA58,2,2 D2# -- the lowest note used by the game music
W $FA5A,2,2 E2
W $FA5C,2,2 F2
W $FA5E,2,2 F2#
W $FA60,2,2 G2
W $FA62,2,2 G2#
W $FA64,2,2 A2
W $FA66,2,2 A2#
W $FA68,2,2 B2
N $FA6A Octave 3
W $FA6A,2,2 C3
W $FA6C,2,2 C3#
W $FA6E,2,2 D3
W $FA70,2,2 D3#
W $FA72,2,2 E3
W $FA74,2,2 F3
W $FA76,2,2 F3#
W $FA78,2,2 G3
W $FA7A,2,2 G3#
W $FA7C,2,2 A3
W $FA7E,2,2 A3#
W $FA80,2,2 B3
N $FA82 Octave 4
W $FA82,2,2 C4
W $FA84,2,2 C4#
W $FA86,2,2 D4
W $FA88,2,2 D4#
W $FA8A,2,2 E4
W $FA8C,2,2 F4
W $FA8E,2,2 F4#
W $FA90,2,2 G4
W $FA92,2,2 G4#
W $FA94,2,2 A4
W $FA96,2,2 A4#
W $FA98,2,2 B4
N $FA9A Octave 5
W $FA9A,2,2 C5
W $FA9C,2,2 C5# -- the highest note used by the game music
W $FA9E,2,2 D5
W $FAA0,2,2 D5#
W $FAA2,2,2 E5
W $FAA4,2,2 F5
W $FAA6,2,2 F5#
W $FAA8,2,2 G5
W $FAAA,2,2 G5#
W $FAAC,2,2 A5
W $FAAE,2,2 A5#
W $FAB0,2,2 B5
N $FAB2 Octave 6
W $FAB2,2,2 C6
W $FAB4,2,2 C6#
W $FAB6,2,2 D6
W $FAB8,2,2 D6#
W $FABA,2,2 E6
W $FABC,2,2 F6
W $FABE,2,2 F6#
W $FAC0,2,2 G6
W $FAC2,2,2 G6#
W $FAC4,2,2 A6
W $FAC6,2,2 A6#
W $FAC8,2,2 B6
N $FACA Octave 7
W $FACA,2,2 C7
N $FACC It's unclear from the original game data where the table is supposed to end. It's not important in practice since the highest note used by the game is C5#.
W $FACC,20,2
;
u $FAE0 769 bytes of apparently unreferenced bytes.
B $FAE0,769,8*96,1
;
c $FDE1 Loaded.
D $FDE1 This is the very first entry point used to shunt the game image down into its proper position.
@ $FDE1 label=loaded
C $FDE1,1 Disable interrupts
C $FDE2,3 Point #REGsp at the topmost byte of RAM
@ $FDE8 nowarn
C $FDE5,11 Relocate the $9FE0 bytes at $5E00 down to $5B00
C $FDF0,3 Exit via jump_to_main
;
u $FDF3 Unreferenced bytes.
B $FDF3,13,8,5
;
c $FE00 Keyboard input routine.
D $FE00 Walks the keydefs table testing the ports against masks as setup by #R$F350.
R $FE00 O:A Input value (as per enum input).
@ $FE00 label=inputroutine_keyboard
C $FE00,3 Point #REGhl at keydefs table - a list of (port high byte, key mask) filled out when the user chose their keys
N $FE03 Check for left
C $FE03,2 Port $xxFE
C $FE05,1 Fetch the port high byte
C $FE06,1 Advance to key mask
C $FE07,2 Read that port
C $FE09,1 The keyboard is active low, so complement the value
C $FE0A,1 Mask off the wanted bit
C $FE0B,1 Advance to next definition
C $FE0C,2 Key NOT pressed - jump forward to test for right key
C $FE0E,2 Skip the right key definition
C $FE10,2 result = input_LEFT
C $FE12,2 Jump to up/down checking
N $FE14 Check for right
C $FE14,1 Fetch the port high byte
C $FE15,1 Advance to key mask
C $FE16,2 Read that port
C $FE18,1 The keyboard is active low, so complement the value
C $FE19,1 Mask off the wanted bit
C $FE1A,1 Advance to next definition
C $FE1B,2 Key NOT pressed - jump forward to test for up key
C $FE1D,2 result = input_RIGHT
C $FE1F,2 Jump to up/down checking
C $FE21,1 Otherwise result = 0 (#REGa is zero here)
N $FE22 Check for up
C $FE22,1 Fetch the port high byte
C $FE23,1 Advance to key mask
C $FE24,2 Read that port
C $FE26,1 The keyboard is active low, so complement the value
C $FE27,1 Mask off the wanted bit
C $FE28,1 Advance to next definition
C $FE29,2 Key NOT pressed - jump forward to test for down key
C $FE2B,2 Skip down key definition
C $FE2D,1 result += input_UP
C $FE2E,2 Jump to fire checking
N $FE30 Check for down
C $FE30,1 Fetch the port high byte
C $FE31,1 Advance to key mask
C $FE32,2 Read that port
C $FE34,1 The keyboard is active low, so complement the value
C $FE35,1 Mask off the wanted bit
C $FE36,1 Advance to next key definition
C $FE37,2 Key NOT pressed - jump forward to test for fire key
C $FE39,2 result += input_DOWN
N $FE3B Check for fire
C $FE3B,1 Fetch the port high byte
C $FE3C,1 Advance to key mask
C $FE3D,2 Read that port
C $FE3F,1 The keyboard is active low, so complement the value
C $FE40,1 Mask off the wanted bit
C $FE41,1 Advance to next key definition
C $FE42,1 Result
C $FE43,1 Return the result if fire NOT pressed
C $FE44,2 result += input_FIRE
C $FE46,1 Return
;
c $FE47 Protek (cursor) joystick input routine.
D $FE47 Up/Down/Left/Right/Fire = keys 7/6/5/8/0.
R $FE47 O:A Input value (as per enum input).
@ $FE47 label=inputroutine_protek
C $FE47,3 Load #REGbc with the port number of the keyboard half row for keys 1/2/3/4/5
C $FE4A,2 Read that port. We'll receive xxx54321
C $FE4C,1 The keyboard is active low, so complement the value
N $FE4D Check for left
C $FE4D,2 Is '5' pressed?
C $FE4F,2 left_right = input_LEFT
C $FE51,2 Load #REGbc with the port number of the keyboard half row for keys 0/9/8/7/6
C $FE53,2 Jump forward if '5'/left was pressed
N $FE55 Check for right
C $FE55,2 Read that port. We'll receive xxx67890
C $FE57,1 The keyboard is active low, so complement the value
C $FE58,2 Is '8' pressed?
C $FE5A,2 left_right = input_RIGHT
C $FE5C,2 Jump forward if '8'/right was pressed
C $FE5E,2 Otherwise left_right = 0
C $FE60,2 Read $EFFE again
C $FE62,1 The keyboard is active low, so complement the value
C $FE63,1 Save a copy of the port value
N $FE64 Check for up
C $FE64,2 Is '7' pressed?
C $FE66,2 up_down = input_UP
C $FE68,2 Jump forward if '7'/up was pressed
N $FE6A Check for down
C $FE6A,1 Restore the port value
C $FE6B,2 Is '6' pressed?
C $FE6D,2 up_down = input_DOWN
C $FE6F,2 Jump forward if '6'/down was pressed
C $FE71,1 Otherwise up_down = 0
C $FE72,2 Combine the up_down and left_right values
N $FE74 Check for fire
C $FE74,1 Restore the port value
C $FE75,2 Is '0' pressed?
C $FE77,2 fire = input_FIRE
C $FE79,2 Jump forward if fire was pressed
C $FE7B,1 fire = 0
C $FE7C,1 Combine the (up_down + left_right) and fire values
C $FE7D,1 Return
;
c $FE7E Kempston joystick input routine.
D $FE7E Reading port $1F yields 000FUDLR active high.
R $FE7E O:A Input value (as per enum input).
@ $FE7E label=inputroutine_kempston
C $FE7E,3 Load #REGbc with port number $1F
C $FE81,2 Read that port. We'll receive 000FUDLR
C $FE83,3 Clear our {...} variables
N $FE86 Right
C $FE86,1 Rotate 'R' out: R000FUDL
C $FE87,2 If carry was set then right was pressed, otherwise skip
C $FE89,2 left_right = input_RIGHT
N $FE8B Left
C $FE8B,1 Rotate 'L' out: LR000FUD
C $FE8C,2 If carry was set then left was pressed, otherwise skip
C $FE8E,2 left_right = input_LEFT
N $FE90 Down
C $FE90,1 Rotate 'D' out: DLR000FU
C $FE91,2 If carry was set then down was pressed, otherwise skip
C $FE93,2 up_down = input_DOWN
N $FE95 Up
C $FE95,1 Rotate 'U' out: UDLR000F
C $FE96,2 If carry was set then up was pressed, otherwise skip
C $FE98,2 up_down = input_UP
N $FE9A Fire
C $FE9A,1 Rotate 'F' out: FUDLR000
C $FE9B,2 fire = input_FIRE
C $FE9D,2 If fire bit was set then jump forward
C $FE9F,1 fire = 0
C $FEA0,2 Combine the fire, up_down and left_right values
C $FEA2,1 Return
;
c $FEA3 Fuller joystick input routine.
D $FEA3 Reading port $7F yields F---RLDU active low.
R $FEA3 This is unused by the game.
N $FEA3 O:A Input value (as per enum input).
@ $FEA3 label=inputroutine_fuller
C $FEA3,3 Load #REGbc with port number $7F
C $FEA6,2 Read that port. We'll receive FxxxRLDU
C $FEA8,3 Clear our variables
N $FEAB Commentary: This is odd. It's testing an unspecified bit to see whether to complement the read value. I don't see a reference for that behaviour anywhere.
C $FEAB,2 Test bit 4
C $FEAD,2 Jump forward if clear
C $FEAF,1 Complement the value
N $FEB0 Up
C $FEB0,1 Rotate 'U' out: UFxxxRLD
C $FEB1,2 If carry was set then up was pressed, otherwise skip
C $FEB3,2 up_down = input_UP
N $FEB5 Down
C $FEB5,1 Rotate 'D' out: DUFxxxRL
C $FEB6,2 If carry was set then down was pressed, otherwise skip
C $FEB8,2 up_down = input_DOWN
N $FEBA Left
C $FEBA,1 Rotate 'L' out: LDUFxxxR
C $FEBB,2 If carry was set then down was pressed, otherwise skip
C $FEBD,2 left_right = input_LEFT
N $FEBF Right
C $FEBF,1 Rotate 'R' out: RLDUFxxx
C $FEC0,2 If carry was set then right was pressed, otherwise skip
C $FEC2,2 left_right = input_RIGHT
N $FEC4 Fire
C $FEC4,2 Test fire bit (and set #REGa to zero if not set)
C $FEC6,2 If bit was set then fire was pressed, otherwise skip
C $FEC8,2 fire = input_FIRE
C $FECA,2 Combine the fire, up_down and left_right values
C $FECC,1 Return
;
c $FECD Sinclair joystick input routine.
D $FECD Up/Down/Left/Right/Fire = keys 9/8/6/7/0.
R $FECD O:A Input value (as per enum input).
@ $FECD label=inputroutine_sinclair
C $FECD,3 Load #REGbc with the port number of the keyboard half row for keys 6/7/8/9/0
C $FED0,2 Read that port. We'll receive xxx67890
C $FED2,1 The keyboard is active low, so complement the value
C $FED3,3 Clear our left_right and up_down variables
C $FED6,1 Rotate '0' out: 0xxx6789
N $FED7 Up
C $FED7,1 Rotate '9' out: 90xxx678
C $FED8,2 If carry was set then '9' was pressed, otherwise skip
C $FEDA,2 up_down = input_UP
N $FEDC Down
C $FEDC,1 Rotate '8' out: 890xxx67
C $FEDD,2 If carry was set then '8' was pressed, otherwise skip
C $FEDF,2 up_down = input_DOWN
N $FEE1 Right
C $FEE1,1 Rotate '7' out: 7890xxx6
C $FEE2,2 If carry was set then '7' was pressed, otherwise skip
C $FEE4,2 left_right = input_RIGHT
N $FEE6 Left
C $FEE6,1 Rotate '6' out: 67890xxx
C $FEE7,2 If carry was set then '6' was pressed, otherwise skip
C $FEE9,2 left_right = input_LEFT
N $FEEB Fire
C $FEEB,2 Is '0' pressed?
C $FEED,2 Jump forward if not
C $FEEF,2 fire = input_FIRE
C $FEF1,2 Combine the fire, up_down and left_right values
C $FEF3,1 Return
;
b $FEF4 Data block at FEF4.
D $FEF4 The final standard speed data block on the tape is loaded at $FC60..$FF81. The bytes from here up to $FF81 come from that block.
B $FEF4,100,8*12,4
N $FF58 UDGs 'A' to 'E' follow, with 'F' truncated at its second byte.
@ $FF58 label=map_buf
B $FF58,8,8 A #HTML[#UDG$FF58]
B $FF60,8,8 B #HTML[#UDG$FF60]
B $FF68,8,8 C #HTML[#UDG$FF68]
B $FF70,8,8 D #HTML[#UDG$FF70]
B $FF78,8,8 E #HTML[#UDG$FF78]
B $FF80,2,2 Truncated F
N $FF82 NUL bytes
B $FF82,126,2,8*15,4
