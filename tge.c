/* tge.c */

#include <stdint.h>

/* ----------------------------------------------------------------------- */

#define UNKNOWN 1

/* ----------------------------------------------------------------------- */

// ENUMERATIONS
//

enum message
{
  message_MISSED_ROLL_CALL,
  message_TIME_TO_WAKE_UP,
  message_BREAKFAST_TIME,
  message_EXERCISE_TIME,
  message_TIME_FOR_BED,
  message_THE_DOOR_IS_LOCKED,
  message_IT_IS_OPEN,
  message_INCORRECT_KEY,
  message_ROLL_CALL,
  message_RED_CROSS_PARCEL,
  message_PICKING_THE_LOCK,
  message_CUTTING_THE_WIRE,
  message_YOU_OPEN_THE_BOX,
  message_YOU_ARE_IN_SOLITARY,
  message_WAIT_FOR_RELEASE,
  message_MORALE_IS_ZERO,
  message_ITEM_DISCOVERED,
  message_HE_TAKES_THE_BRIBE,
  message_AND_ACTS_AS_DECOY,
  message_ANOTHER_DAY_DAWNS,
  message__LIMIT,
  message_NONE = 255
};

// this duplicates data...
enum interior_object
{
  interiorobject_TUNNEL_0,
  interiorobject_SMALL_TUNNEL_ENTRANCE,
  interiorobject_ROOM_OUTLINE_2,
  interiorobject_TUNNEL_3,
  interiorobject_TUNNEL_JOIN_4,
  interiorobject_PRISONER_SAT_DOWN_MID_TABLE,
  interiorobject_TUNNEL_CORNER_6,
  interiorobject_TUNNEL_7,
  interiorobject_WIDE_WINDOW,
  interiorobject_EMPTY_BED,
  interiorobject_SHORT_WARDROBE,
  interiorobject_CHEST_OF_DRAWERS,
  interiorobject_TUNNEL_12,
  interiorobject_EMPTY_BENCH,
  interiorobject_TUNNEL_14,
  interiorobject_DOOR_FRAME_15,
  interiorobject_DOOR_FRAME_16,
  interiorobject_TUNNEL_17,
  interiorobject_TUNNEL_18,
  interiorobject_PRISONER_SAT_DOWN_END_TABLE,
  interiorobject_COLLAPSED_TUNNEL,
  interiorobject_ROOM_OUTLINE_21,
  interiorobject_CHAIR_POINTING_BOTTOM_RIGHT,
  interiorobject_OCCUPIED_BED,
  interiorobject_WARDROBE_WITH_KNOCKERS,
  interiorobject_CHAIR_POINTING_BOTTOM_LEFT,
  interiorobject_CUPBOARD,
  interiorobject_ROOM_OUTLINE_27,
  interiorobject_TABLE_1,
  interiorobject_TABLE_2,
  interiorobject_STOVE_PIPE,
  interiorobject_STUFF_31,
  interiorobject_TALL_WARDROBE,
  interiorobject_SMALL_SHELF,
  interiorobject_SMALL_CRATE,
  interiorobject_SMALL_WINDOW,
  interiorobject_DOOR_FRAME_36,
  interiorobject_NOTICEBOARD,
  interiorobject_DOOR_FRAME_38,
  interiorobject_DOOR_FRAME_39,
  interiorobject_DOOR_FRAME_40,
  interiorobject_ROOM_OUTLINE_41,
  interiorobject_CUPBOARD_42,
  interiorobject_MESS_BENCH,
  interiorobject_MESS_TABLE,
  interiorobject_MESS_BENCH_SHORT,
  interiorobject_ROOM_OUTLINE_46,
  interiorobject_ROOM_OUTLINE_47,
  interiorobject_TINY_TABLE,
  interiorobject_TINY_DRAWERS,
  interiorobject_DRAWERS_50,
  interiorobject_DESK,
  interiorobject_SINK,
  interiorobject_KEY_RACK,
  interiorobject__LIMIT
};

enum interior_object_tile
{
  interiorobjecttile_MAX = 194,
  interiorobjecttile_ESCAPE = 255
};

/* ----------------------------------------------------------------------- */

// CONSTANTS
//


/* ----------------------------------------------------------------------- */

// TYPES
//

/** The state of the game. */
typedef struct tgestate tgestate_t;

/** A game object. */
typedef struct tgeobject tgeobject_t;

/** A message. */
typedef enum message message_t;

/** An interior object. */
typedef enum interior_object object_t;

/** An interior object tile. */
typedef enum interior_object_tile objecttile_t;

/** Tiles (also known as UDGs). */
typedef uint8_t tileindex_t;
typedef uint8_t tilerow_t;
typedef tilerow_t tile_t[8];

/* ----------------------------------------------------------------------- */

// EXTERNS
//

extern const tgeobject_t *interior_object_tile_refs[interiorobject__LIMIT];

extern const tile_t interior_tiles[interiorobjecttile_MAX];


/* ----------------------------------------------------------------------- */

// STATIC CONSTS
//

/* ----------------------------------------------------------------------- */

// FORWARD REFERENCES
//


static const char *messages_table[message__LIMIT];

/* ----------------------------------------------------------------------- */

// STRUCTURES
//

struct tgestate
{
  int          columns;    // e.g. 24
  int          rows;       // e.g. 16
  uint8_t     *screen_buf;
  tileindex_t *tile_buf;
};

struct tgeobject
{
  uint8_t      width, height;
  uint8_t      data[UNKNOWN];
};

/* ----------------------------------------------------------------------- */

/* 0x6AB5 */
void expand_object(tgestate_t *state, object_t index, uint8_t *output)
{
  int                rows, columns;
  const tgeobject_t *obj;
  int                width, height;
  int                saved_width;
  const uint8_t     *data;
  int                byte;
  int                val;

  rows        = state->rows;
  columns     = state->columns;

  obj         = interior_object_tile_refs[index];

  width       = obj->width;
  height      = obj->height;

  saved_width = width;

  data        = &obj->data[0];

  do
  {
    do
    {
expand:
      byte = *data;
      if (byte == interiorobjecttile_ESCAPE)
      {
        byte = *++data;
        if (byte != interiorobjecttile_ESCAPE)
        {
          if (byte >= 128)
            goto run;
          if (byte >= 64)
            goto range;
        }
      }

      if (byte)
        *output = byte;
      data++;
      output++;
    }
    while (--width);

    width = saved_width;
    output += columns - width;
  }
  while (--height);

  return;


run:

  byte = *data++ & 0x7F;
  val = *data;
  do
  {
    if (val > 0)
      *output = val;
    output++;

    if (--width == 0) // ran out of width
    {
      if (--height == 0)
        return;

      output += columns - saved_width; // move to next row
    }
  }
  while (--byte);

  data++;

  goto expand;


range:

  byte = *data++ & 0x0F;
  val = *data;
  do
  {
    *output++ = val++;

    if (--width == 0) // ran out of width
    {
      if (--height == 0)
        return;

      output += columns - saved_width; // move to next row
    }
  }
  while (--byte);

  data++;

  goto expand;
}

/* ----------------------------------------------------------------------- */

/* 0x6B42 */
void plot_indoor_tiles(tgestate_t *state)
{
  int                  rows;
  int                  columns;
  uint8_t             *screen_buf;
  const tileindex_t   *tiles_buf;
  int                  rowcounter;
  int                  columncounter;
  int                  bytes;
  int                  stride;

  rows       = state->rows;
  columns    = state->columns;

  screen_buf = state->screen_buf;
  tiles_buf  = state->tile_buf;

  rowcounter = rows;
  do
  {
    columncounter = columns;
    do
    {
      const tilerow_t *tile_data;

      tile_data = &interior_tiles[*tiles_buf++][0];

      bytes  = 8;
      stride = columns;
      do
      {
        *screen_buf = *tile_data++;
        screen_buf += stride;
      }
      while (--bytes);

      screen_buf++; // move to next character position
    }
    while (--columncounter);
    screen_buf += 7 * columns; // move to next row
  }
  while (--rowcounter);
}

/* ----------------------------------------------------------------------- */


/* ----------------------------------------------------------------------- */

/* $7DCD */
static const char *messages_table[message__LIMIT] =
{
  "MISSED ROLL CALL",
  "TIME TO WAKE UP",
  "BREAKFAST TIME",
  "EXERCISE TIME",
  "TIME FOR BED",
  "THE DOOR IS LOCKED",
  "IT IS OPEN",
  "INCORRECT KEY",
  "ROLL CALL",
  "RED CROSS PARCEL",
  "PICKING THE LOCK",
  "CUTTING THE WIRE",
  "YOU OPEN THE BOX",
  "YOU ARE IN SOLITARY",
  "WAIT FOR RELEASE",
  "MORALE IS ZERO",
  "ITEM DISCOVERED",
};
