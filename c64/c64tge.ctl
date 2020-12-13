> $0000 ; SkoolKit disassembly of The Great Escape by Denton Designs.
> $0000 ; https://github.com/dpt/The-Great-Escape
> $0000 ;
> $0000 ; Copyright 1986 Ocean Software Ltd. (The Great Escape)
> $0000 ; Copyright 2020 David Thomas <dave@davespace.co.uk> (this disassembly)
> $0000 ;
> $0000 ; Note: This is a disassembled snapshot of a running game.
> $0000 ;
> $0000 ; Note: It's possible that there are discrepancies herein of two bytes.
@ $0000 start
@ $0000 org
b $0000 Data block at 0000
B $0000,48,8
g $0030
B $0030,2,2 global map position (x,y)
b $0032
B $0032,3,3
B $0035,1,1 used by keyscan_all
B $0036,1,1 used by keyscan_all
g $0037
@ $0037 label=game_counter
B $0037,1,1
g $0038
@ $0038 label=bell
B $0038,1,1
u $0039
B $0039,1,1 unreferenced in ZX version / perhaps store only
g $003A
@ $003A label=score_digits
B $003A,5,5
g $003F
@ $003F label=hero_in_breakfast
B $003F,1,1
g $0040
B $0040,1,1 likely red flag flag
g $0041
@ $0041 label=automatic_player_counter
B $0041,1,1
g $0042
B $0042,1,1 likely in_solitary
g $0043
@ $0043 label=morale_exhausted
B $0043,1,1
b $0044
B $0044,3,1
g $0047
B $0047,1,1 ptr?_to_door_being_lockpicked
B $0048,1,1
g $0049
@ $0049 label=player_locked_out_until
B $0049,1,1
b $004A
B $004A,1,1 day or night flag
B $004B,1,1 room index?
B $004C,22,4,8*2,2
B $0062,2,2 items held
B $0064,1,1 morale
B $0065,1,1
g $0066
@ $0066 label=hero_in_bed
B $0066,1,1
b $0067
B $0067,2,1
g $0069
B $0069,1,1
b $006A
B $006A,3,3 screenlocstring_plot stashes values here
B $006D,755,3,8
b $0360 MASK BUFFER (5*8*4)
B $0360,160,8
b $0400 Data block at 0400
B $0400,1042,8*130,2
b $0812 TABLE OF FLIPPED BYTES (256)
B $0812,254,8*31,6
b $0910 VISCHARS
B $0910,1,1 vischar[0]
B $0911,1,1 vischar[0].flags
B $0912,22,8*2,6
B $0928,2,2 hero's isometric x pos
B $092A,2,2 hero's isometric y pos
B $092C,1396,8*174,4
b $0EA0
@ $0EA0 label=map_tiles
B $0EA0,1836,4,8
b $15CC
B $15CC,3369,8*421,1
b $22F5 COMMANDANT SPRITES
B $22F5,452,7,8*55,5
b $24B9 PRISONER SPRITES
B $24B9,430,3,8*53,3
b $2667 CRAWL SPRITES (... as for original game)
B $2667,1679,5,8*209,2
b $2CF6 CRATE SPRITES (then stove)
B $2CF6,2518,6,8
b $36CC FONT (but it has an 'O') -- my numbers above are off by two...?
B $36CC,288,8
b $37EC
B $37EC,16,8
b $37FC walls array
B $37FC,144,8
b $388C
B $388C,933,8*116,5
b $3C31 Mask tiles
D $3C31 Mask tiles set 0. 111 tiles.
B $3C31,888,8
b $3FA9 Locked gates and doors.
@ $3FA9 label=locked_doors
B $3FA9,2,2 gates
B $3FAB,7,7 doors
b $3FB2
B $3FB2,13,7,6
c $3FBF main loop
D $3FBF Used by the routines at #R$4008 and #R$4B0C.
@ $3FBF label=main_loop
C $3FBF,3 check_morale
C $3FC5,3 message_display
C $3FC8,3 process_player_input
C $3FCB,3 in_permitted_area
C $3FFB,2 load probably day_or_night flag
C $4005,3 probably nighttime
c $4008 Routine at 4008
C $4008,2 game_counter
C $400C,2 loop?
C $400E,3 dispatch_timed_event
c $4014 Check morale level, report if zero and inhibit player control if exhausted.
D $4014 Used by the routine at #R$3FBF.
@ $4014 label=check_morale
C $4014,4 If morale is greater than ZERO then return (Diff: ZX version uses >= 1)
C $4018,5 Queue the message "MORALE IS ZERO"
C $401D,4 Set the "morale exhausted" flag to inhibit player input
C $4021,4 Immediately take automatic control of the hero
N $4025 This entry point is used by the routine at #R$4026.
C $4025,1 Return
c $4026 Routine at 4026
D $4026 Used by the routine at #R$3FC2.
c $402D Routine at 402D
c $4034 Routine at 4034
D $4034 Used by the routine at #R$3FC2.
c $4051 Routine at 4051
D $4051 Used by the routine at #R$4034.
c $406A Process player input.
D $406A Used by the routine at #R$3FC2.
C $406A,4 Load the in_solitary and morale_exhausted flags
C $406E,2 Return if either is set. This inhibits the player's control
C $4070,5 Is the hero is picking a lock, or cutting wire?
C $4075,2 Jump if not
N $4077 Hero is picking a lock, or cutting through a wire fence.
C $4077,4 Postpone automatic control for 31 turns of this routine
C $407B,2 Is the hero picking a lock?
C $407D,2 ...
C $407F,3 Jump to cutting_wire if not
C $4082,3 Jump to picking_lock if so
C $4085,1 Return
@ $4086 label=process_player_input_no_flags
C $4086,3 Call the input routine. Input is returned in #REGa.
C $4089,2 Did the input routine return input_NONE? (zero)
C $408B,2 Jump if not
N $408D No user input was received: count down the automatic player counter
C $408D,4 If the automatic player counter is zero then return
C $4091,2 Decrement the automatic player counter
C $4093,2 Set input to input_NONE
C $4095,3 Jump to end bit
N $4098 User input was received.
N $4098 Postpone automatic control for 31 turns.
@ $4098 label=process_player_input_received
C $4098,1 Bank input routine result CHECK
C $4099,4 Set the automatic player counter to 31
C $409D,2 Load hero in bed flag
C $409F,2 Jump to 'hero was in bed' case if non-zero
C $40A1,2 Load hero at breakfast flag
C $40A3,2 Jump to 'not bed or breakfast' case if zero
N $40A5 Hero was at breakfast: make him stand up
C $40A5,10 Set hero's route to 43, step 0
C $40AF,2 Clear the hero at breakfast flag
C $40B1,10 Set hero's (x,y) pos to (52,62)
C $40BB,5 Set room definition 25's bench_G object to interiorobject_EMPTY_BENCH
N $40C3 Hero was in bed: make him get up
@ $40C3 label=process_player_input_in_bed
C $40C3,10 Set hero's route to 44, step 1
C $40CD,8 Set hero's target (x,y) to (46,46)
C $40D5,14 Set hero's (x,y) pos to (46,46)
C $40E3,2 Clear the hero in bed flag
C $40E5,5 Set hero's height to 24
C $40EA,5 Set room definition 2's bed object to interiorobject_EMPTY_BED
@ $40EF label=process_player_input_common
C $40EF,3 Expand out the room definition for room_index
C $40F2,3 Expand all of the tile indices in the tiles buffer to full tiles in the screen buffer
@ $40F5 label=process_player_input_check_fire
C $40F5,1 Unbank input routine result
C $40F6,2 Was fire pressed?
C $40F8,2 Jump if not
C $40FA,3 Check for 'pick up', 'drop' and 'use' input events
C $40FD,2 Set #REGa to input_KICK ($80)
N $40FF If input state has changed then kick a sprite update.
@ $40FF label=process_player_input_set_kick
C $40FF,3 Did the input state change from the hero's existing input?
C $4102,2 Return if not
C $4104,5 Kick a sprite update if it did
N $4109 This entry point is used by the routine at #R$410A.
C $4109,1 Return
c $410A Routine at 410A
D $410A Used by the routine at #R$406A.
N $411F This entry point is used by the routine at #R$4167.
c $4128 input routine for keyboard?
D $4128 Used by the routine at #R$406A.
N $4145 This entry point is used by the routine at #R$8549.
c $4167 Routine at 4167
D $4167 Used by the routine at #R$406A.
c $4191 Check the hero's map position, check for escape and colour the flag accordingly.
D $4191 This also sets the main (hero's) map position in #R$81B8 to that of the hero's vischar position.
D $4191 Used by the routine at #R$3FC2.
C $4191,2 Get the global current room index
C $4193,2 Jump if indoors
C $4195,5 copy arg lo/hi byte?
C $419A,3 hero_map_position_x
C $419D,3 divide_by_8_with_rounding
C $41A0,2 tinypos.x
C $41AA,3 divide_by_8_with_rounding
C $41AD,2 tinypos.y
C $41B7,3 divide_by_8_with_rounding
C $41BA,2 tinypos.z
C $41C9,3 jmp escaped
C $41D9,3 jmp escaped
N $4295 This entry point is used by the routine at #R$42AB.
@ $4295 label=ipa_flag_select
C $4295,2 red flag
c $42AB Routine at 42AB
D $42AB Used by the routine at #R$4191.
c $42B7 Routine at 42B7
D $42B7 Used by the routine at #R$4191.
N $42BF This entry point is used by the routines at #R$4191 and #R$42AB.
N $42C4 This entry point is used by the routine at #R$58AD.
c $42E8 Routine at 42E8
D $42E8 Used by the routine at #R$3FC2.
N $434F This entry point is used by the routine at #R$8504.
c $4353 Routine at 4353
D $4353 Used by the routine at #R$4191.
c $4360 Routine at 4360
D $4360 Used by the routine at #R$4361.
c $4361 Routine at 4361
D $4361 Used by the routine at #R$3FC2.
b $439E Data block at 439E
B $439E,4,4
t $43A2 Message at 43A2
B $43A2,3,c3
b $43A5 Data block at 43A5
B $43A5,5,5
t $43AA Message at 43AA
B $43AA,3,c3
b $43AD Data block at 43AD
B $43AD,8,8
c $43B5 Routine at 43B5
N $43BF This entry point is used by the routine at #R$43C2.
c $43C2 Routine at 43C2
D $43C2 Used by the routines at #R$44C8, #R$5907, #R$5A98, #R$9148 and #R$CBA1.
c $43D1 Routine at 43D1
D $43D1 Used by the routines at #R$65BB, #R$690B, #R$694F, #R$6971, #R$698B, #R$6A59, #R$8F06 and #R$C95F.
c $43DB Routine at 43DB
D $43DB Used by the routines at #R$8C80 and #R$C6CC.
N $43E2 This entry point is used by the routines at #R$43D1 and #R$4B0C.
N $43F8 This entry point is used by the routine at #R$5FBE.
c $442D Routine at 442D
c $442E Routine at 442E
D $442E Used by the routines at #R$44C8, #R$48C9, #R$4B0C, #R$6866, #R$6B12, #R$8C80, #R$8CDE, #R$C6CC and #R$C737.
b $4464 Data block at 4464
B $4464,43,8*5,3
c $448F Routine at 448F
c $44B8 Routine at 44B8
c $44C8 Routine at 44C8
N $44D4 This entry point is used by the routine at #R$44B8.
c $44DC Routine at 44DC
c $44E6 Routine at 44E6
c $44F0 Routine at 44F0
c $44FA Routine at 44FA
c $44FF Routine at 44FF
c $4513 Routine at 4513
c $4518 Routine at 4518
c $452C Routine at 452C
C $453A,3 mult by 7
N $4552 This entry point is used by the routine at #R$8549.
c $4562 Routine at 4562
c $456B Routine at 456B
N $4571 This entry point is used by the routine at #R$4562.
b $4588 Data block at 4588
B $4588,3,3
c $458B Routine at 458B
c $45F6 Routine at 45F6
D $45F6 Used by the routine at #R$44FA.
N $4657 This entry point is used by the routine at #R$4658.
c $4658 Routine at 4658
D $4658 Used by the routines at #R$4191, #R$44B8, #R$458B, #R$45F6, #R$4673, #R$4748, #R$4830, #R$4844, #R$4858, #R$4871 and #R$48B3.
N $465C This entry point is used by the routine at #R$54E7.
c $4673 Routine at 4673
D $4673 Used by the routine at #R$4518.
c $4687 Routine at 4687
D $4687 Used by the routine at #R$48B3.
c $469F Routine at 469F
D $469F Used by the routines at #R$458B, #R$45F6, #R$4673, #R$4830, #R$4844 and #R$4858.
c $46BF Routine at 46BF
D $46BF Used by the routines at #R$456B, #R$4687 and #R$469F.
N $46FC This entry point is used by the routine at #R$4658.
c $4743 Routine at 4743
D $4743 Used by the routine at #R$5500.
c $4748 Routine at 4748
D $4748 Used by the routine at #R$5500.
N $4758 This entry point is used by the routine at #R$4743.
c $4778 Routine at 4778
D $4778 Used by the routine at #R$5434.
c $47AF Routine at 47AF
D $47AF Used by the routine at #R$5423.
N $47D4 This entry point is used by the routine at #R$4778.
N $47F7 This entry point is used by the routine at #R$480E.
c $4802 Routine at 4802
D $4802 Used by the routine at #R$5514.
c $480E Routine at 480E
D $480E Used by the routines at #R$5517 and #R$5FBE.
N $4817 This entry point is used by the routine at #R$4802.
c $4830 Routine at 4830
D $4830 Used by the routine at #R$44FF.
c $4844 Routine at 4844
D $4844 Used by the routine at #R$4513.
c $4858 Routine at 4858
D $4858 Used by the routine at #R$44F0.
c $486C Routine at 486C
D $486C Used by the routine at #R$550A.
c $4871 Routine at 4871
D $4871 Used by the routine at #R$550A.
N $4881 This entry point is used by the routine at #R$486C.
c $48B3 Routine at 48B3
D $48B3 Used by the routine at #R$44E6.
c $48C9 Routine at 48C9
D $48C9 Used by the routines at #R$48D7 and #R$5FBE.
c $48D7 Hero has escaped.
D $48D7 Used by the routine at in_permitted_area.
R $48D7 Print 'well done' message then test to see if the correct objects were used in the escape attempt.
@ $48D7 label=escaped
C $48D7,3 Reset the screen
N $48DA Print standard prefix messages.
C $48DA,4 Point ?REGxy at the escape messages
C $48DE,9 Print "WELL DONE" "YOU HAVE ESCAPED" "FROM THE CAMP" (each print call advances ?REGxy)
N $48E7 Form an escape items bitfield.
C $48E7,4 Clear the item flags
C $48EB,2 item index 0
C $48ED,3 Turn the item into a flag
C $48F0,2 item index 1
C $48F2,3 Turn the item into a flag, merging with previous result
N $48F5 Print item-tailored messages.
C $48F5,2 ?
C $48F7,4 If the flags show we're holding are escapeitem_COMPASS and escapeitem_PURSE then jump to the success case
C $48FB,4 Otherwise if we don't have both escapeitem_COMPASS and escapeitem_PAPERS jump to the captured case
@ $48FF label=escaped_success
C $48FF,2 Point #REGhl at the fourth escape message
C $4901,8 Print "AND WILL CROSS THE "BORDER SUCCESSFULLY"
C $4909,3 Signal to reset the game at the end of this routine
C $490C,3 Jump to "press any key"
@ $490F label=escaped_captured
C $490F,1 Save flags
C $4910,4 Point #REGhl at the sixth escape message
C $4914,3 Print "BUT WERE RECAPTURED"
C $4917,2 Fetch flags
C $4919,4 If flags include escapeitem_UNIFORM print "AND SHOT AS A SPY"
C $491D,4 Point #REGhl at the eighth escape message
C $4921,4 If flags is zero then print "TOTALLY UNPREPARED"
C $4925,4 Point #REGhl at the ninth escape message
C $4929,4 If there was no compass then print "TOTALLY LOST"
C $492D,4 Print "DUE TO LACK OF PAPERS"
@ $4931 label=escaped_plot
C $4931,3 Print
@ $4934 label=escaped_press_any_key
C $4934,7 Print "PRESS ANY KEY"
N $493B Wait for a keypress.
C $493B,5 Wait for a key down
C $4940,5 Wait for a key up
C $4945,1 Fetch flags
N $4946 Reset the game, or send the hero to solitary.
C $4946,4 Are the flags $FF?
C $494A,3 Reset the game if so (exit via)
C $494D,4 Are the flags greater or equal to escapeitem_UNIFORM?
C $4951,3 Reset the game if so (exit via)
C $4954,3 Otherwise send the hero to solitary (exit via)
c $4957 Check for any key press.
D $4957 Used by the routine at #R$48D7.
@ $4957 label=keyscan_all
C $4959,2 var $1 = $35
C $495D,3 connect all keyboard rows
C $4960,3 read pressed keys ($FF => no keys pressed)
C $4963,2 complement
C $4965,1 push PSR
C $4966,2 var $1 = $34
C $496A,1 pop PSR
C $496B,1 return with status set
c $496C Call item_to_escapeitem then merge result with a previous escapeitem.
D $496C Used by the routine at escaped.
R $496C I:C Previous return value.
R $496C I:HL Pointer to (single) item slot.
R $496C O:C Previous return value + escapeitem_ flag.
@ $496C label=join_item_to_escapeitem
C $496C,2 $62 must be items, X is the index of the item 0 or 1
C $4972,2 A += zeropage[$04]
c $4977 Return a bitmask indicating the presence of items required for escape.
D $4977 Used by the routine at join_item_to_escapeitem.
R $4977 I:A Item.
R $4977 O:A Bitfield.
@ $4977 label=item_to_escapeitem
C $4977,2 Is it item_COMPASS?
C $4979,2 No - try the next interesting item
C $497B,2 Otherwise return flag escapeitem_COMPASS
C $497E,2 Is it item_PAPERS?
C $4980,2 No - try the next interesting item
C $4982,2 Otherwise return flag escapeitem_PAPERS
C $4985,2 Is it item_PURSE?
C $4987,2 No - try the next interesting item
C $4989,2 Otherwise return flag escapeitem_PURSE
C $498C,2 Is it item_UNIFORM?
C $498F,2 Return escapeitem_UNIFORM if so
C $4994,2 Otherwise return zero
c $4997 screenlocstring_plot
D $4997 Used by the routines at #R$48D7 and #R$4AE0. XY must point to screenlocstring
@ $4997 label=screenlocstring_plot
C $4997,4 save XY
C $499D,2 $6a  screen addr lo?
C $49A2,2 $6b  screen addr hi?
C $49A7,2 $6c  number of chars?
C $49AC,3 call out to plot a single glyph?
C $49B0,2 get screen addr lo?
C $49B2,1 clear carry (6502 only has ADC, no plain ADD)
C $49B3,2 advance to next character?
C $49B9,2 advance screen addr hi?
C $49BB,2 decrement nchars
C $49BD,2 ?...loop until the counter is zero
N $49BF compute outgoing address
C $49BF,1 Y -> A
C $49C1,2 loc 106
C $49C6,2 loc 107
b $49CA Escape messages.
D $49CA "WELL DONE"
@ $49CA label=escape_strings
B $49CA,226,3,c9,3,c16,3,c13,8*20,4,c15
B $4AAC,4,4 ?
c $4AB0 Routine at 4AB0
c $4AE0 Routine at 4AE0
c $4B0C Routine at 4B0C
D $4B0C Used by the routines at #R$5759, #R$5907, #R$670B, #R$689F, #R$8F06 and #R$C95F.
N $4B6E This entry point is used by the routine at #R$5FBE.
c $4B9E Routine at 4B9E
D $4B9E Used by the routine at #R$4B0C.
c $4BC5 Routine at 4BC5
D $4BC5 Used by the routines at #R$4B0C and #R$6866.
c $4BF4 Routine at 4BF4
D $4BF4 Used by the routine at #R$4BC5.
c $4C01 Routine at 4C01
D $4C01 Used by the routine at #R$4BC5.
c $4C0E Routine at 4C0E
D $4C0E Used by the routine at #R$4BC5.
C $4C0E,2 $3689 or $8936? suspect former
C $4C16,2 26
N $4C18 This entry point is used by the routines at #R$4BF4 and #R$4C01.
C $4C1B,2 8
C $4C1D,2 25
C $4C28,2 13
C $4C2A,2 14
C $4C3B,2 32
c $4C40 Routine at 4C40
D $4C40 Used by the routine at #R$4BC5.
c $4C4D Routine at 4C4D
D $4C4D Used by the routine at #R$4CE9.
c $4C9B Routine at 4C9B
D $4C9B Used by the routines at #R$51FF, #R$5759, #R$689F, #R$6A83 and #R$6ABD.
c $4CD5 Routine at 4CD5
D $4CD5 Used by the routines at #R$48C9, #R$4CE9, #R$8F3B and #R$C994.
c $4CE9 Expand out the room definition for room_index.
D $4CE9 Used by the routines at #R$406A, #R$458B, #R$45F6, #R$47AF, #R$4B0C, #R$698B, #R$8C80 and #R$C6CC.
@ $4CE9 label=setup_room
C $4CE9,3 Wipe the visible tiles array
c $4DC6 Routine at 4DC6
D $4DC6 Used by the routine at #R$4CE9.
c $4E97 Routine at 4E97
D $4E97 Used by the routines at #R$406A, #R$458B, #R$45F6, #R$47AF, #R$48C9, #R$4B0C, #R$698B, #R$8C80, #R$8F3B, #R$C6CC and #R$C994.
c $4F06 Routine at 4F06
D $4F06 Used by the routine at #R$4BC5.
c $4F87 Routine at 4F87
D $4F87 Used by the routine at #R$3FC2.
N $5000 This entry point is used by the routine at #R$5001.
c $5001 Routine at 5001
D $5001 Used by the routine at #R$4F06.
c $5044 Routine at 5044
D $5044 Used by the routine at #R$5045.
c $5045 Routine at 5045
D $5045 Used by the routine at #R$5001.
N $5059 This entry point is used by the routine at #R$5001.
N $50FF This entry point is used by the routine at #R$84F8.
c $512C Routine at 512C
D $512C Used by the routines at #R$4B0C, #R$4C40, #R$4F87 and #R$6165.
c $51FF Routine at 51FF
D $51FF Used by the routines at #R$46BF, #R$5045, #R$526C and #R$5759.
N $526B This entry point is used by the routine at #R$526C.
c $526C Routine at 526C
D $526C Used by the routine at #R$3FC2.
c $5371 Routine at 5371
D $5371 Used by the routine at #R$526C.
N $5397 This entry point is used by the routine at #R$526C.
c $53B6 Routine at 53B6
D $53B6 Used by the routines at #R$526C and #R$5371.
c $53F1 Routine at 53F1
D $53F1 Used by the routines at #R$46BF, #R$512C and #R$526C.
c $53FB Routine at 53FB
D $53FB Used by the routine at #R$5759.
c $5409 Routine at 5409
D $5409 Used by the routine at #R$526C.
b $5417 Data block at 5417
D $5417 Used by the routines at #R$53FB and #R$5409.
B $5417,12,8,4
c $5423 Routine at 5423
b $5428 Data block at 5428
B $5428,12,8,4
c $5434 Routine at 5434
c $5439 Routine at 5439
c $544F Routine at 544F
b $5463 Data block at 5463
B $5463,71,8*8,7
c $54AA Routine at 54AA
c $54B0 Routine at 54B0
c $54BB Routine at 54BB
c $54C2 Routine at 54C2
c $54C9 Routine at 54C9
D $54C9 Used by the routine at #R$54AA.
N $54CD This entry point is used by the routines at #R$54BB and #R$54C2.
c $54E7 Routine at 54E7
c $5500 Routine at 5500
c $550A Routine at 550A
c $5514 Routine at 5514
c $5517 Routine at 5517
c $551A Routine at 551A
c $5525 Routine at 5525
N $5526 This entry point is used by the routine at #R$3FC2.
N $5592 This entry point is used by the routine at #R$5045.
N $56BD This entry point is used by the routine at #R$5759.
c $56D5 Routine at 56D5
D $56D5 Used by the routine at #R$5525.
c $5717 Routine at 5717
D $5717 Used by the routine at #R$5525.
N $5758 This entry point is used by the routine at #R$5759.
c $5759 Routine at 5759
D $5759 Used by the routine at #R$5525.
N $581C This entry point is used by the routines at #R$46BF, #R$5525 and #R$65BB.
N $5835 This entry point is used by the routine at #R$5045.
c $588A Routine at 588A
c $5891 Routine at 5891
D $5891 Used by the routine at #R$51FF.
c $5898 Routine at 5898
D $5898 Used by the routine at #R$51FF.
b $58A5 Data block at 58A5
B $58A5,8,8
c $58AD Routine at 58AD
C $58AF,2 prolly item_NONE
C $58B3,2 reset first held item
C $58C0,2 reset second held item
N $58D0 This entry point is used by the routine at #R$5907.
c $5907 Routine at 5907
N $5911 This entry point is used by the routine at #R$58AD.
b $596E Data block at 596E
B $596E,5,5
c $5973 Routine at 5973
N $5974 This entry point is used by the routine at #R$5525.
N $5A09 This entry point is used by the routines at #R$4AB0, #R$5525 and #R$5A2A.
N $5A29 This entry point is used by the routine at #R$5A2A.
c $5A2A Routine at 5A2A
D $5A2A Used by the routine at #R$5525.
c $5A5B Routine at 5A5B
D $5A5B Used by the routines at #R$526C and #R$5A2A.
N $5A97 This entry point is used by the routine at #R$5A98.
c $5A98 Routine at 5A98
D $5A98 Used by the routines at #R$526C, #R$5525, #R$58AD, #R$5907 and #R$5FBE.
C $5AB7,3 mult by 7
b $5AE6 Data block at 5AE6
B $5AE6,15,8,7
t $5AF5 Message at 5AF5
B $5AF5,3,c3
b $5AF8 Data block at 5AF8
B $5AF8,16,8
t $5B08 Message at 5B08
B $5B08,3,c3
b $5B0B Data block at 5B0B
B $5B0B,3,3
t $5B0E Message at 5B0E
B $5B0E,3,c3
b $5B11 Data block at 5B11
B $5B11,1,1
t $5B12 Message at 5B12
B $5B12,3,c3
b $5B15 Data block at 5B15
B $5B15,1,1
c $5B16 Routine at 5B16
D $5B16 Used by the routine at #R$4BC5.
c $5B71 Routine at 5B71
D $5B71 Used by the routine at #R$6B83.
N $5BDD This entry point is used by the routine at #R$5BDE.
c $5BDE suspect this is: Set up item plotting.
D $5BDE Used by the routine at #R$6B3D.
c $5D32 Routine at 5D32
D $5D32 Used by the routine at #R$5BDE.
c $5DB6 Routine at 5DB6
D $5DB6 Used by the routine at #R$4BC5.
N $5DB8 This entry point is used by the routine at #R$5E77.
N $5DF9 This entry point is used by the routine at #R$5EFC.
c $5E77 Routine at 5E77
D $5E77 Used by the routine at #R$5DB6.
N $5E84 This entry point is used by the routine at #R$5EFC.
N $5EE2 This entry point is used by the routine at #R$5DB6.
N $5EE5 This entry point is used by the routine at #R$5DB6.
N $5EF1 This entry point is used by the routine at #R$5DB6.
c $5EFC Routine at 5EFC
D $5EFC Used by the routine at #R$5DB6.
N $5F04 This entry point is used by the routines at #R$5DB6 and #R$5E77.
c $5F63 Routine at 5F63
D $5F63 Used by the routines at #R$480E, #R$4B0C, #R$4C0E, #R$5045 and #R$6866.
N $5F78 This entry point is used by the routine at #R$5E77.
c $5FBE Routine at 5FBE
D $5FBE Used by the routines at #R$48D7 and #R$C212.
N $60FA This entry point is used by the routine at #R$4026.
c $6165 Routine at 6165
D $6165 Used by the routines at #R$5907 and #R$5FBE.
b $6210 Data block at 6210
B $6210,29,8*3,5
t $622D Message at 622D
B $622D,3,c3
b $6230 Data block at 6230
B $6230,5,5
c $6235 Routine at 6235
c $623B Routine at 623B
b $623C Data block at 623C
B $623C,222,8*27,6
t $631A Message at 631A
B $631A,3,c3
b $631D Data block at 631D
B $631D,3,3
t $6320 Message at 6320
B $6320,3,c3
b $6323 Data block at 6323
B $6323,101,8*12,5
t $6388 Message at 6388
B $6388,3,c3
b $638B Data block at 638B
B $638B,10,8,2
t $6395 Message at 6395
B $6395,7,c7
b $639C Data block at 639C
B $639C,13,8,5
c $63A9 Routine at 63A9
b $63C5 Data block at 63C5
B $63C5,3,3
c $63C8 Routine at 63C8
c $6429 Routine at 6429
D $6429 Used by the routines at #R$5045 and #R$63C8.
N $642F This entry point is used by the routine at #R$65AE.
c $64E9 Routine at 64E9
D $64E9 Used by the routine at #R$64F1.
c $64F1 Routine at 64F1
D $64F1 Used by the routine at #R$6429.
N $6513 This entry point is used by the routine at #R$64E9.
b $65AA Data block at 65AA
B $65AA,4,4
c $65AE Routine at 65AE
D $65AE Used by the routine at #R$6429.
N $65BA This entry point is used by the routine at #R$65BB.
c $65BB Routine at 65BB
D $65BB Used by the routines at #R$5759 and #R$6429.
c $6604 Routine at 6604
D $6604 Used by the routines at #R$5045 and #R$63C8.
c $66C2 Routine at 66C2
D $66C2 Used by the routines at #R$5001, #R$56D5, #R$5717, #R$5B71 and #R$6604.
c $66D6 Routine at 66D6
D $66D6 Used by the routines at #R$670B and #R$689F.
c $670B Routine at 670B
D $670B Used by the routine at #R$63C8.
c $6778 Routine at 6778
D $6778 Used by the routines at #R$670B and #R$6A83.
c $67F1 Routine at 67F1
D $67F1 Used by the routines at #R$4B0C and #R$6778.
c $6802 Routine at 6802
D $6802 Used by the routine at #R$6604.
c $6866 Routine at 6866
D $6866 Used by the routine at #R$4B0C.
c $689E Routine at 689E
D $689E Used by the routine at #R$689F.
c $689F Routine at 689F
D $689F Used by the routine at #R$670B.
c $690B Routine at 690B
c $6931 Routine at 6931
N $694E This entry point is used by the routines at #R$694F, #R$6971 and #R$698B.
c $694F Routine at 694F
c $6971 Routine at 6971
c $698B Routine at 698B
c $69AE Use wiresnips.
N $69AE Check the hero's position against the four vertically-oriented fences.
@ $69AE label=action_wiresnips
C $69B0,2 global map pos.y or hero_map_position_y? must be the latter
C $69BC,2 hero_map_position_x
N $69D4 Point #REGhl at the 16th entry of walls array (start of horizontal fences).
C $69D7,2 three iters?
C $69D9,2 hero_map_position_x
C $69E5,2 hero_map_position_y
@ $69FD label=snips_crawl_tl
C $69FD,2 Set #REGa to 4 (direction_TOP_LEFT + vischar_DIRECTION_CRAWL)
C $69FF,3 Jump forward
@ $6A02 label=snips_crawl_tr
C $6A02,2 Set #REGa to 5 (direction_TOP_RIGHT + vischar_DIRECTION_CRAWL)
C $6A04,3 Jump forward
@ $6A07 label=snips_crawl_br
C $6A07,2 Set #REGa to 6 (direction_BOTTOM_RIGHT + vischar_DIRECTION_CRAWL)
C $6A09,3 Jump forward
@ $6A0C label=snips_crawl_bl
C $6A0C,2 Set #REGa to 7 (direction_BOTTOM_LEFT + vischar_DIRECTION_CRAWL)
@ $6A0E label=snips_tail
C $6A11,5 Set hero's vischar.input field to input_KICK
C $6A16,5 Set hero's vischar.flags to vischar_FLAGS_CUTTING_WIRE
C $6A1B,5 Set hero's vischar.mi.pos.height to 12
C $6A20,10 Set vischar.mi.sprite to the prisoner sprite set
C $6A2A,7 Lock out the player until the game counter is now + 96
C $6A31,5 Queue the message "CUTTING THE WIRE" and exit via
c $6A36 Use lockpick.
@ $6A36 label=action_lockpick
C $6A36,3 Get the nearest door in range of the hero in ?REGhl
C $6A39,2 Return if no door was nearby
C $6A3B,2 Store the door_t pointer? index? in ptr_to_door_being_lockpicked
C $6A3D,7 Lock out player control until the game counter becomes now + 255
C $6A44,5 Set hero's vischar.flags to vischar_FLAGS_PICKING_LOCK
C $6A49,5 Queue the message "PICKING THE LOCK" and exit via
> $6A4F ; This entry point is used by the routine at #R$6A59.
> $6A4F *$6A4E RTS           ;
c $6A4F Use red key.
@ $6A4F label=action_red_key
C $6A4F,2 Set the room number in #REGa to room_22_REDKEY
C $6A51,3 Jump to action_key
c $6A54 Use yellow key.
@ $6A54 label=action_yellow_key
C $6A54,2 Set the room number in #REGa to room_13_CORRIDOR
C $6A56,3 Jump to action_key
c $6A59 Use green key.
@ $6A59 label=action_green_key
C $6A59,2 Set the room number in #REGa to room_14_TORCH
E $6A59 FALL THROUGH into action_key.
c $6A5B Use a key.
D $6A5B This entry point ?? is used by the routines at #R$6A4F and #R$6A54.
R $6A5B I:A Room number to which the key applies.
@ $6A5B label=action_key
C $6A5B,2 Preserve the room number while we get the nearest door
C $6A5D,3 Return the nearest door in range of the hero in ?REGhl
C $6A60,2 Return if no door was nearby
C $6A62,3 Fetch door index + flag
C $6A65,2 Mask off door_LOCKED flag to get door index alone
C $6A67,4 Set ?REGb to message_INCORRECT_KEY irrespectively
C $6A6B,2 Are they equal?
C $6A6D,2 Jump if not equal
C $6A6F,8 Unlock the door by resetting door_LOCKED ($80)
C $6A77,3 Increase morale by 10, score by 50
C $6A7A,4 Set ?REGb to message_IT_IS_OPEN
C $6A7E,5 Queue the message identified by ?REGb
c $6A83 Return the nearest door in range of the hero.
D $6A83 Used by the routines at #R$6A36 and #R$6A59.
R $6A83 O:HL Pointer to door in locked_doors.
R $6A83 O:F Returns Z set if a door was found, clear otherwise.
c $6ABD Routine at 6ABD
D $6ABD Used by the routine at #R$6A83.
c $6B12 Routine at 6B12
D $6B12 Used by the routine at #R$6B3D.
N $6B3C This entry point is used by the routine at #R$6B3D.
c $6B3D Routine at 6B3D
D $6B3D Used by the routine at #R$4BC5.
c $6B83 Routine at 6B83
D $6B83 Used by the routine at #R$6B3D.
N $6C25 This entry point is used by the routine at #R$6C26.
c $6C26 Routine at 6C26
D $6C26 Used by the routine at #R$6B3D.
c $6EC1 Routine at 6EC1
D $6EC1 Used by the routine at #R$6C26.
c $6EF9 Routine at 6EF9
D $6EF9 Used by the routine at #R$6EFC.
c $6EFC Routine at 6EFC
D $6EFC Used by the routines at #R$6FD6 and #R$75CB.
N $6FD3 This entry point is used by the routine at #R$6EF9.
c $6FD6 Routine at 6FD6
D $6FD6 Used by the routine at #R$3FC2.
c $7174 Routine at 7174
D $7174 Used by the routine at #R$6FD6.
b $71D4 Data block at 71D4
B $71D4,237,8*29,5
c $72C1 Routine at 72C1
b $72E2 Data block at 72E2
B $72E2,5,5
t $72E7 Message at 72E7
B $72E7,3,c3
b $72EA Data block at 72EA
B $72EA,1,1
t $72EB Message at 72EB
B $72EB,3,c3
b $72EE Data block at 72EE
B $72EE,204,8*25,4
c $73BA Routine at 73BA
c $73DC Routine at 73DC
D $73DC Used by the routine at #R$6B3D.
c $73E1 Routine at 73E1
D $73E1 Used by the routine at #R$6B3D.
N $73ED This entry point is used by the routine at #R$73DC.
N $7405 This entry point is used by the routine at #R$7489.
B $745B,2,2
B $7461,2,2
B $746E,2,2
B $7474,2,2
B $7481,2,2
B $7487,2,2
c $7489 Routine at 7489
b $74AB Data block at 74AB
D $74AB Used by the routine at #R$73E1.
B $74AB,167,8*20,7
c $7552 Routine at 7552
c $75A6 Routine at 75A6
D $75A6 Used by the routine at #R$73E1.
c $75CB Routine at 75CB
D $75CB Used by the routine at #R$6B3D.
c $77C1 Divide AC by 8, with rounding to nearest.
D $77C1 Used by the routines at #R$4191, #R$4F87, #R$512C, #R$5525, #R$5973, #R$75CB, #R$8CDE and #R$C737.
@ $77C1 label=divide_by_8_with_rounding
N $77C8 This entry point is used by the routines at #R$4F87, #R$6866 and #R$75CB.
c $77D2 Routine at 77D2
D $77D2 Used by the routine at #R$5FBE.
c $7842 one of the sprite plotters
D $7842 Used by the routine at #R$48C9.
b $8333 The pending message queue.
@ $8333 label=message_queue
B $8333,19,8*2,3 Queue of message indexes. Pairs of bytes + 0xFF terminator.
b $8346 Countdown to the next message.
@ $8346 label=message_display_delay
B $8346,1,1 Decrementing counter which shows the next message when it reaches zero.
b $8347 Index into the message we're displaying or wiping.
@ $8347 label=message_display_index
B $8347,1,1 If 128 then next_message. If > 128 then wipe_message. Else display.
g $8348 Pointer to the next available slot in the message queue.
@ $8348 label=message_queue_pointer
B $8348,1,1 ?more of an index than a pointer?
c $8349 Add a new message index to the pending messages queue.
D $8349 Used by the routines at #R$4014, #R$410A, #R$44C8, #R$44DC, #R$44E6, #R$44F0, #R$44FF, #R$4518, #R$452C, #R$4AB0, #R$5907, #R$5A98, #R$65BB, #R$66D6, #R$690B, #R$69AE, #R$6A36 and #R$6A59.
R $8349 I:A Message index.
@ $8349 label=queue_message
C $8349,2 ?stash message index for later
C $834B,3 Fetch the message queue pointer ?index?
C $834E,2 Is the currently pointed-to index message_QUEUE_END?
N $8350 in 6502: cmp $8333,x => ($8333+x)
C $8350,3 ($FF)}
C $8353,2 Return if so - the queue is full
N $8355 Is this message index already pending?
C $8355,2 Step back two bytes to the next pending entry
C $8357,3 If the new message index matches the pending entry then
> $8377  $835A INX           ; return
> $8377  $835B CMP $05       ;
> $8377  $835D BNE $8366     ;
> $8377  $835F LDA $8333,X   ;
> $8377 ; where does $04 come from? is this the equivalent of register C in the speccy version?
> $8377  $8362 CMP $04       ;
> $8377  $8364 BEQ $8376     ; }
> $8377 ; Add it to the queue.
> $8377 *$8366 INX           ; {Store the new message index
> $8377  $8367 LDA $05       ; ?fetch stashed message index
> $8377  $8369 STA $8333,X   ;
> $8377  $836C INX           ;
> $8377  $836D LDA $04       ;
> $8377  $836F STA $8333,X   ;
> $8377  $8372 INX           ; }
> $8377  $8373 STX $8348     ; Update the message queue pointer ?index?
> $8377 *$8376 RTS           ; Return
c $8377 Routine at 8377   likely plot a single glyph
D $8377 Used by the routines at #R$4997, #R$5FBE and #R$83A4.
N $8387 This entry point is used by the routines at #R$42E8 and #R$83A4.
N $838E This entry point is used by the routines at #R$42E8, #R$43DB and #R$5FBE.
C $838E,3 * 8
C $839D,2 ?compare Y to 8?
C $83A3,1 Return
c $83A4 Incrementally wipe and display queued game messages.
D $83A4 Used by the routine at main_loop.
R $83A4 Proceed only if message display delay is zero.
C $8412,2 index $8440
w $8440 Array of pointers to game messages.
@ $8440 label=messages_table
W $8440,40,2
t $8468 Message at 8468
B $8468,17,c16,1
t $8479 Message at 8479
B $8479,15,c15
b $8488 Data block at 8488
B $8488,1,1
t $8489 Message at 8489
B $8489,14,c14
b $8497 Data block at 8497
B $8497,1,1
t $8498 Message at 8498
B $8498,13,c13
b $84A5 Data block at 84A5
B $84A5,1,1
t $84A6 Message at 84A6
B $84A6,12,c12
b $84B2 Data block at 84B2
B $84B2,1,1
t $84B3 Message at 84B3
B $84B3,18,c18
b $84C5 Data block at 84C5
B $84C5,1,1
t $84C6 Message at 84C6
B $84C6,10,c10
b $84D0 Data block at 84D0
B $84D0,1,1
t $84D1 Message at 84D1
B $84D1,13,c13
b $84DE Data block at 84DE
B $84DE,1,1
t $84DF Message at 84DF
B $84DF,10,c9,1
t $84E9 Message at 84E9
B $84E9,15,c15
c $84F8 Routine at 84F8
t $84FB Message at 84FB
B $84FB,9,c9
c $8504 Routine at 8504
b $8509 Data block at 8509
B $8509,2,2
t $850B Message at 850B
B $850B,16,c16
b $851B Data block at 851B
B $851B,1,1
t $851C Message at 851C
B $851C,16,c16
b $852C Data block at 852C
B $852C,1,1
t $852D Message at 852D
B $852D,16,c16
t $853D Message at 853D
B $853D,3,c3
b $8540 Data block at 8540
B $8540,1,1
t $8541 Message at 8541
B $8541,8,c8
c $8549 Routine at 8549
b $854F Data block at 854F
B $854F,3,3
t $8552 Message at 8552
B $8552,14,c14
b $8560 Data block at 8560
B $8560,1,1
t $8561 Message at 8561
B $8561,15,c15
b $8570 Data block at 8570
B $8570,1,1
t $8571 Message at 8571
B $8571,18,c18
b $8583 Data block at 8583
B $8583,1,1
t $8584 Message at 8584
B $8584,16,c16
b $8594 Data block at 8594
B $8594,2,2
t $8596 Message at 8596
B $8596,17,c17
c $85A7 Routine at 85A7
B $85A7,3,3
c $8634 Routine at 8634
D $8634 Used by the routines at #R$8A29, #R$8A79, #R$C482 and #R$C4D2.
c $8649 Routine at 8649
D $8649 Used by the routines at #R$8AC3, #R$8B29, #R$C51C and #R$C582.
N $865B This entry point is used by the routine at #R$8634.
c $874D Routine at 874D
D $874D Used by the routines at #R$6866, #R$8C80 and #R$C6CC.
c $87A5 Routine at 87A5
D $87A5 Used by the routines at #R$8971, #R$8B29, #R$C3CA and #R$C582.
c $87C6 Routine at 87C6
D $87C6 Used by the routines at #R$89C5, #R$8A29, #R$C41E and #R$C482.
N $87DA This entry point is used by the routines at #R$874D, #R$87A5 and #R$C217.
c $8900 Routine at 8900
D $8900 Used by the routines at #R$87C6 and #R$C21F.
c $890F Routine at 890F
D $890F Used by the routines at #R$8649, #R$8900 and #R$C359.
N $8970 This entry point is used by the routine at #R$8971.
c $8971 Routine at 8971
N $897E This entry point is used by the routines at #R$8A79 and #R$C4D2.
c $89C5 Routine at 89C5
D $89C5 Used by the routines at #R$8A29, #R$8AC3, #R$C482 and #R$C51C.
c $8A29 Routine at 8A29
c $8A79 Routine at 8A79
N $8A83 This entry point is used by the routine at #R$8AC3.
c $8AC3 Routine at 8AC3
c $8B29 Routine at 8B29
D $8B29 Used by the routines at #R$8971 and #R$C3CA.
c $8B82 Routine at 8B82
D $8B82 Used by the routine at #R$4BC5.
N $8BEB This entry point is used by the routine at #R$C5DB.
b $8C14 Data block at 8C14
B $8C14,6,6
c $8C1A Routine at 8C1A
N $8C1C This entry point is used by the routine at #R$406A.
N $8C38 This entry point is used by the routine at #R$8C3E.
c $8C39 Routine at 8C39
D $8C39 Used by the routines at #R$8C1A and #R$C673.
c $8C3E Routine at 8C3E
D $8C3E Used by the routines at #R$8C1A and #R$C673.
N $8C40 This entry point is used by the routines at #R$8C39 and #R$C692.
> $8C5E ;00008c60: ae 69 8b 69 36 6a 06 8f 38 8c 31 69 71 69 38 8c  .i.i6j..8.1iqi8.
> $8C5E ;00008c70: 4f 69 4f 6a 54 6a 59 6a 0b 69 38 8c 3a 8c 38 8c  OiOjTjYj.i8.:.8.
> $8C5E ;00008c80: a9 ff c5 62 f0 04 c5 63 d0 22 20 4c 8e d0 1d a0  ...b...c." L....
> $8C5E ;00008c90: 00 a5 62 c9 ff f0 01 c8 bd cd 0a 29 1f 99 62 00  ..b........)..b.
> $8C5E ;00008ca0: 8a 48 a5 4b d0 07 20 4f 87 4c b9 8c 60 20 eb 4c  .H.K.. O.L..` .L
> $8C5E
> $8C5E ;; off by two bytes again!
w $8C5E Item actions jump table.
@ $8C5E label=item_actions_jump_table
W $8C5E,2,2 action_wiresnips
W $8C60,2,2 action_shovel
W $8C62,2,2 action_lockpick
W $8C64,2,2 action_papers
W $8C66,2,2 nop
W $8C68,2,2 action_bribe
W $8C6A,2,2 action_uniform
W $8C6C,2,2 nop
W $8C6E,2,2 action_poison
W $8C70,2,2 action_red_key
W $8C72,2,2 action_yellow_key
W $8C74,2,2 action_green_key
W $8C76,2,2 action_red_cross_parcel
W $8C78,2,2 nop
W $8C7A,2,2 bug?jumps into an instr, should be nop
W $8C7C,2,2 nop
c $8C80 Routine
N $8CB7 This entry point is used by the routine at #R$C6CC.
c $8CDE Routine at 8CDE
D $8CDE Used by the routines at #R$8C1A and #R$C673.
N $8D08 This entry point is used by the routine at #R$690B.
C $8D08,3 mult by 7
N $8D33 This entry point is used by the routine at #R$5A98.
N $8D67 This entry point is used by the routine at #R$5A98.
c $8DB7 seems to be a multiply by 7 routine
D $8DB7 Used by the routines at #R$452C, #R$5A98, #R$8CDE and #R$C737.
c $8DC1 Routine at 8DC1
D $8DC1 Used by the routine at #R$8DC8.
c $8DC8 Routine at 8DC8
D $8DC8 Used by the routines at #R$58AD, #R$5FBE, #R$65BB, #R$690B, #R$694F, #R$8C80, #R$8CDE, #R$C6CC and #R$C737.
N $8DDF This entry point is used by the routine at #R$C821.
N $8E11 This entry point is used by the routine at #R$C821.
c $8E4A Routine at 8E4A
D $8E4A Used by the routines at #R$8C80 and #R$C6CC.
c $8E94 Routine at 8E94
D $8E94 Used by the routines at #R$8DC8, #R$8EBD, #R$C821 and #R$C916.
c $8EBD Routine at 8EBD
D $8EBD Used by the routines at #R$8DC8 and #R$C821.
c $8ED5 Routine at 8ED5
D $8ED5 Used by the routines at #R$8E94 and #R$C8ED.
N $8F03 This entry point is used by the routine at #R$8F06.
c $8F06 Use papers.
D $8F06 Is the hero within the main gate bounds?
N $8F06 Range checking that X is in ($69..$6D) and Y is in ($49..$4B).
@ $8F06 label=action_papers
C $8F06,2 $30= global map position x
C $8F08,8 range check x
C $8F10,2 get y
C $8F12,8 range check y
c $8F3B Routine at 8F3B
N $8F3F This entry point is used by the routines at #R$44C8, #R$4B0C, #R$6866, #R$698B, #R$6B12, #R$8C80, #R$8CDE, #R$C6CC and #R$C737.
N $8F5B This entry point is used by the routine at #R$C994.
t $8F78 Message at 8F78
B $8F78,3,c3
b $8F7B Data block at 8F7B
B $8F7B,11,8,3
t $8F86 Message at 8F86
B $8F86,3,c3
b $8F89 Data block at 8F89
B $8F89,31,8*3,7
c $8FA8 Routine at 8FA8
N $8FAB This entry point is used by the routines at #R$903E and #R$CA97.
N $8FDD This entry point is used by the routine at #R$CA01.
N $9033 This entry point is used by the routine at #R$CA01.
c $903E Routine at 903E
D $903E Used by the routine at #R$3FC2.
N $9072 This entry point is used by the routine at #R$CA97.
N $9085 This entry point is used by the routine at #R$CA97.
N $9097 This entry point is used by the routine at #R$CA97.
N $90D5 This entry point is used by the routine at #R$CA97.
N $913B This entry point is used by the routine at #R$CA97.
N $9147 This entry point is used by the routine at #R$9148.
c $9148 Routine at 9148
D $9148 Used by the routines at #R$903E and #R$CA97.
c $919F Routine at 919F
D $919F Used by the routines at #R$903E and #R$CA97.
N $91A5 This entry point is used by the routine at #R$CBF8.
N $9222 This entry point is used by the routine at #R$CBF8.
N $923C This entry point is used by the routine at #R$CBF8.
N $924B This entry point is used by the routine at #R$CBF8.
b $925E Data block at 925E
B $925E,27,8*3,3
c $9279 Routine at 9279
N $927E This entry point is used by the routines at #R$919F and #R$CBF8.
c $929A Routine at 929A
c $92B8 Routine at 92B8
D $92B8 Used by the routines at #R$8C80, #R$8CDE, #R$C6CC and #R$C737.
c $92C4 Routine at 92C4
D $92C4 Used by the routine at #R$5045.
c $92D0 Routine at 92D0
D $92D0 Used by the routine at #R$4361.
c $92DC Routine at 92DC
b $9325 Data block at 9325
B $9325,220,8*27,4
c $9401 Routine at 9401
c $9412 Routine at 9412
D $9412 Used by the routines at #R$92B8 and #R$CD0B.
c $941B Routine at 941B
D $941B Used by the routines at #R$92C4 and #R$CD17.
b $9424 Data block at 9424
B $9424,124,8*15,4
c $94A0 Routine at 94A0
c $94AB Routine at 94AB
D $94AB Used by the routines at #R$958B and #R$9615.
N $94B1 This entry point is used by the routine at #R$9615.
c $94C2 Routine at 94C2
D $94C2 Used by the routine at #R$958B.
c $94D9 Routine at 94D9
D $94D9 Used by the routines at #R$9401, #R$9412, #R$941B, #R$CE54, #R$CE65 and #R$CE6E.
c $956D Routine at 956D
D $956D Used by the routine at #R$5FBE.
N $958A This entry point is used by the routines at #R$94D9 and #R$958B.
c $958B Routine at 958B
D $958B Used by the routine at #R$94D9.
N $959C This entry point is used by the routine at #R$96B2.
N $95A6 This entry point is used by the routine at #R$96B2.
c $95EF Routine at 95EF
D $95EF Used by the routine at #R$9721.
N $9614 This entry point is used by the routine at #R$9615.
c $9615 Routine at 9615
D $9615 Used by the routine at #R$9721.
c $96B2 Routine at 96B2
N $96B3 This entry point is used by the routine at #R$9615.
N $96F7 This entry point is used by the routine at #R$9615.
c $9721 Routine at 9721
D $9721 Used by the routines at #R$929A and #R$CCED.
b $9753 Data block at 9753
B $9753,813,8*101,5
b $9A80 Exterior tiles. 145 + 220 + 206 tiles. (<- plot_tile)
B $9A80,4568,8
b $AC58 Interior tiles. 194 tiles.
B $AC58,1552,8
b $B268 Super tiles.
B $B268,3488,16 super_tile $00..$D9
b $C008 Data block at C008
B $C008,79,8*9,7
t $C057 Message at C057
B $C057,4,c4
b $C05B Data block at C05B
B $C05B,19,8*2,3
t $C06E Message at C06E
B $C06E,5,c5
b $C073 Data block at C073
B $C073,19,8*2,3
t $C086 Message at C086
B $C086,5,c5
b $C08B Data block at C08B
B $C08B,19,8*2,3
t $C09E Message at C09E
B $C09E,6,c6
b $C0A4 Data block at C0A4
B $C0A4,4,4
t $C0A8 Message at C0A8
B $C0A8,4,c4
b $C0AC Data block at C0AC
B $C0AC,10,8,2
t $C0B6 Message at C0B6
B $C0B6,3,c3
b $C0B9 Data block at C0B9
B $C0B9,1,1
c $C0BA Routine at C0BA
b $C0BD Data block at C0BD
B $C0BD,17,8*2,1
t $C0CE Message at C0CE
B $C0CE,4,c4
b $C0D2 Data block at C0D2
B $C0D2,2,2
t $C0D4 Message at C0D4
B $C0D4,5,c5
b $C0D9 Data block at C0D9
B $C0D9,13,8,5
t $C0E6 Message at C0E6
B $C0E6,5,c5
b $C0EB Data block at C0EB
B $C0EB,20,8*2,4
t $C0FF Message at C0FF
B $C0FF,5,c5
b $C104 Data block at C104
B $C104,94,8*11,6
t $C162 Message at C162
B $C162,3,c3
b $C165 Data block at C165
B $C165,173,8*21,5
c $C212 Routine at C212
c $C217 Routine at C217
c $C21F Routine at C21F
c $C359 Routine at C359
c $C368 Routine at C368
N $C3C9 This entry point is used by the routine at #R$C3CA.
c $C3CA Routine at C3CA
c $C41E Routine at C41E
c $C482 Routine at C482
c $C4D2 Routine at C4D2
N $C4DC This entry point is used by the routine at #R$C51C.
c $C51C Routine at C51C
c $C582 Routine at C582
c $C5DB Routine at C5DB
b $C66D Data block at C66D
B $C66D,6,6
c $C673 Routine at C673
N $C691 This entry point is used by the routine at #R$C697.
c $C692 Routine at C692
c $C697 Routine at C697
b $C6B7 Data block at C6B7
B $C6B7,21,8*2,5
c $C6CC Routine at C6CC
c $C737 Routine at C737
C $C761,3 mult by 7?
c $C810 Routine at C810
c $C81A Routine at C81A
D $C81A Used by the routine at #R$C821.
c $C821 Routine at C821
c $C8A3 Routine at C8A3
c $C8ED Routine at C8ED
c $C916 Routine at C916
c $C92E Routine at C92E
N $C95C This entry point is used by the routine at #R$C95F.
c $C95F Routine at C95F
c $C994 Routine at C994
C $C9BE,2 item 1
C $C9C2,2 item 2
t $C9D1 Message at C9D1
B $C9D1,3,c3
b $C9D4 Data block at C9D4
B $C9D4,11,8,3
t $C9DF Message at C9DF
B $C9DF,3,c3
b $C9E2 Data block at C9E2
B $C9E2,31,8*3,7
c $CA01 Routine at CA01
c $CA97 Routine at CA97
N $CBA0 This entry point is used by the routine at #R$CBA1.
c $CBA1 Routine at CBA1
c $CBF8 Routine at CBF8
N $CC32 This entry point is used by the routine at #R$A9E0.
b $CCB7 Data block at CCB7
B $CCB7,24,8
c $CCCF Routine at CCCF
c $CCED Routine at CCED
c $CD0B Routine at CD0B
c $CD17 Routine at CD17
c $CD23 Routine at CD23
c $CD2F Routine at CD2F
b $CD78 Data block at CD78
B $CD78,220,8*27,4
c $CE54 Routine at CE54
c $CE65 Routine at CE65
c $CE6E Routine at CE6E
b $CE77 Data block at CE77
B $CE77,21,8*2,5
c $CE8C Routine at CE8C
c $CE97 Routine at CE97
c $CEAE Routine at CEAE
b $CEC5 Data block at CEC5
B $CEC5,1293,8*161,5
c $D3D2 Routine at D3D2
b $D3DE Data block at D3DE
B $D3DE,180,8*22,4
c $D492 Routine at D492
b $D49E Data block at D49E
B $D49E,725,8*90,5
c $D773 Routine at D773
b $D784 Data block at D784
B $D784,89,8*11,1
c $D7DD Routine at D7DD
b $D7E5 Data block at D7E5
B $D7E5,89,8*11,1
c $D83E Routine at D83E
b $D846 Data block at D846
B $D846,88,8
c $D89E Routine at D89E
b $D8A7 Data block at D8A7
B $D8A7,371,8*46,3
c $DA1A Routine at DA1A
b $DA2B Data block at DA2B
B $DA2B,78,8*9,6
c $DA79 Routine at DA79
b $DA8C Data block at DA8C
B $DA8C,76,8*9,4
c $DAD8 Routine at DAD8
b $DAED Data block at DAED
B $DAED,90,8*11,2
t $DB47 Message at DB47
B $DB47,4,c4
b $DB4B Data block at DB4B
B $DB4B,10,8,2
t $DB55 Message at DB55
B $DB55,7,c7
b $DB5C Data block at DB5C
B $DB5C,137,8*17,1
t $DBE5 Message at DBE5
B $DBE5,3,c3
b $DBE8 Data block at DBE8
B $DBE8,8,8
t $DBF0 Message at DBF0
B $DBF0,3,c3
b $DBF3 Data block at DBF3
B $DBF3,815,8*101,7
t $DF22 Message at DF22
B $DF22,6,c6
b $DF28 Data block at DF28
B $DF28,34,8*4,2
t $DF4A Message at DF4A
B $DF4A,6,c6
b $DF50 Data block at DF50
B $DF50,155,8*19,3
c $DFEB Routine at DFEB
b $DFEF Data block at DFEF
B $DFEF,9,8,1
c $DFF8 Routine at DFF8
b $DFF9 Data block at DFF9
B $DFF9,706,8*88,2
t $E2BB Message at E2BB
B $E2BB,3,c3
b $E2BE Data block at E2BE
B $E2BE,189,8*23,5
t $E37B Message at E37B
B $E37B,3,c3
b $E37E Data block at E37E
B $E37E,123,8*15,3
t $E3F9 Message at E3F9
B $E3F9,3,c3
b $E3FC Data block at E3FC
B $E3FC,189,8*23,5
t $E4B9 Message at E4B9
B $E4B9,3,c3
b $E4BC Data block at E4BC
B $E4BC,127,8*15,7
t $E53B Message at E53B
B $E53B,3,c3
b $E53E Data block at E53E
B $E53E,189,8*23,5
t $E5FB Message at E5FB
B $E5FB,3,c3
b $E5FE Data block at E5FE
B $E5FE,123,8*15,3
t $E679 Message at E679
B $E679,3,c3
b $E67C Data block at E67C
B $E67C,189,8*23,5
t $E739 Message at E739
B $E739,3,c3
b $E73C Data block at E73C
B $E73C,127,8*15,7
t $E7BB Message at E7BB
B $E7BB,3,c3
b $E7BE Data block at E7BE
B $E7BE,189,8*23,5
t $E87B Message at E87B
B $E87B,3,c3
b $E87E Data block at E87E
B $E87E,123,8*15,3
t $E8F9 Message at E8F9
B $E8F9,3,c3
b $E8FC Data block at E8FC
B $E8FC,80,8
c $E94C Routine at E94C
b $E94D Data block at E94D
B $E94D,108,8*13,4
t $E9B9 Message at E9B9
B $E9B9,3,c3
b $E9BC Data block at E9BC
B $E9BC,127,8*15,7
t $EA3B Message at EA3B
B $EA3B,3,c3
b $EA3E Data block at EA3E
B $EA3E,189,8*23,5
t $EAFB Message at EAFB
B $EAFB,3,c3
b $EAFE Data block at EAFE
B $EAFE,123,8*15,3
t $EB79 Message at EB79
B $EB79,3,c3
b $EB7C Data block at EB7C
B $EB7C,189,8*23,5
t $EC39 Message at EC39
B $EC39,3,c3
b $EC3C Data block at EC3C
B $EC3C,127,8*15,7
t $ECBB Message at ECBB
B $ECBB,3,c3
b $ECBE Data block at ECBE
B $ECBE,189,8*23,5
t $ED7B Message at ED7B
B $ED7B,3,c3
b $ED7E Data block at ED7E
B $ED7E,123,8*15,3
t $EDF9 Message at EDF9
B $EDF9,3,c3
b $EDFC Data block at EDFC
B $EDFC,189,8*23,5
t $EEB9 Message at EEB9
B $EEB9,3,c3
b $EEBC Data block at EEBC
B $EEBC,127,8*15,7
t $EF3B Message at EF3B
B $EF3B,3,c3
b $EF3E Data block at EF3E
B $EF3E,189,8*23,5
t $EFFB Message at EFFB
B $EFFB,3,c3
b $EFFE Data block at EFFE
B $EFFE,123,8*15,3
t $F079 Message at F079
B $F079,3,c3
c $F07C Routine at F07C
c $F091 Routine at F091
b $F09D Data block at F09D
B $F09D,156,8*19,4
t $F139 Message at F139
B $F139,3,c3
b $F13C Data block at F13C
B $F13C,127,8*15,7
t $F1BB Message at F1BB
B $F1BB,3,c3
b $F1BE Data block at F1BE
B $F1BE,3,3
c $F1C1 Routine at F1C1
c $F1E1 Routine at F1E1
b $F1ED Data block at F1ED
B $F1ED,142,8*17,6
t $F27B Message at F27B
B $F27B,3,c3
b $F27E Data block at F27E
B $F27E,123,8*15,3
t $F2F9 Message at F2F9
B $F2F9,3,c3
b $F2FC Data block at F2FC
B $F2FC,189,8*23,5
t $F3B9 Message at F3B9
B $F3B9,3,c3
b $F3BC Data block at F3BC
B $F3BC,127,8*15,7
t $F43B Message at F43B
B $F43B,3,c3
b $F43E Data block at F43E
B $F43E,78,8*9,6
c $F48C Routine at F48C
b $F48D Data block at F48D
B $F48D,110,8*13,6
t $F4FB Message at F4FB
B $F4FB,3,c3
b $F4FE Data block at F4FE
B $F4FE,123,8*15,3
t $F579 Message at F579
B $F579,3,c3
c $F57C Routine at F57C
c $F5D1 Routine at F5D1
b $F5DD Data block at F5DD
B $F5DD,92,8*11,4
t $F639 Message at F639
B $F639,3,c3
b $F63C Data block at F63C
B $F63C,641,8*80,1
c $F8BD Routine at F8BD
b $F914 Data block at F914
B $F914,441,8*55,1
t $FACD Message at FACD
B $FACD,3,c3
b $FAD0 Data block at FAD0
B $FAD0,5,5
c $FAD5 Routine at FAD5
c $FADB Routine at FADB
b $FADC Data block at FADC
B $FADC,1315,8*164,3
i $FFFF
