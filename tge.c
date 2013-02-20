/* tge.c */

#include <stdint.h>

/* ----------------------------------------------------------------------- */

#define UNKNOWN 1

/* ----------------------------------------------------------------------- */

// this duplicates data...
enum object
{
  object_TUNNEL_0,
  object_SMALL_TUNNEL_ENTRANCE,
  object_ROOM_OUTLINE_2,
  object_TUNNEL_3,
  object_TUNNEL_JOIN_4,
  object_PRISONER_SAT_DOWN_MID_TABLE,
  object_TUNNEL_CORNER_6,
  object_TUNNEL_7,
  object_WIDE_WINDOW,
  object_EMPTY_BED,
  object_SHORT_WARDROBE,
  object_CHEST_OF_DRAWERS,
  object_TUNNEL_12,
  object_EMPTY_BENCH,
  object_TUNNEL_14,
  object_DOOR_FRAME_15,
  object_DOOR_FRAME_16,
  object_TUNNEL_17,
  object_TUNNEL_18,
  object_PRISONER_SAT_DOWN_END_TABLE,
  object_COLLAPSED_TUNNEL,
  object_ROOM_OUTLINE_21,
  object_CHAIR_POINTING_BOTTOM_RIGHT,
  object_OCCUPIED_BED,
  object_WARDROBE_WITH_KNOCKERS,
  object_CHAIR_POINTING_BOTTOM_LEFT,
  object_CUPBOARD,
  object_ROOM_OUTLINE_27,
  object_TABLE_1,
  object_TABLE_2,
  object_STOVE_PIPE,
  object_STUFF_31,
  object_TALL_WARDROBE,
  object_SMALL_SHELF,
  object_SMALL_CRATE,
  object_SMALL_WINDOW,
  object_DOOR_FRAME_36,
  object_NOTICEBOARD,
  object_DOOR_FRAME_38,
  object_DOOR_FRAME_39,
  object_DOOR_FRAME_40,
  object_ROOM_OUTLINE_41,
  object_CUPBOARD_42,
  object_MESS_BENCH,
  object_MESS_TABLE,
  object_MESS_BENCH_SHORT,
  object_ROOM_OUTLINE_46,
  object_ROOM_OUTLINE_47,
  object_TINY_TABLE,
  object_TINY_DRAWERS,
  object_DRAWERS_50,
  object_DESK,
  object_SINK,
  object_KEY_RACK,
  object__LIMIT
};

enum objecttile
{
  objecttile_MAX = 194,
  objecttile_ESCAPE = 255
};

/* ----------------------------------------------------------------------- */

/** The state of the game. */
typedef struct tgestate tgestate_t;

/** A game object. */
typedef struct tgeobject tgeobject_t;

/** An interior (only?) object. */
typedef enum object object_t;

typedef enum objecttile objecttile_t;

/** Tiles (also known as UDGs). */
typedef uint8_t tileindex_t;
typedef uint8_t tilerow_t;
typedef tilerow_t tile_t[8];

/* ----------------------------------------------------------------------- */

extern const tgeobject_t *interior_object_tile_refs[object__LIMIT];

extern const tile_t interior_tiles[objecttile_MAX];

/* ----------------------------------------------------------------------- */

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
      if (byte == objecttile_ESCAPE)
      {
        byte = *++data;
        if (byte != objecttile_ESCAPE)
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

