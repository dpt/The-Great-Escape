/* tge.c */

#include <stdint.h>

/* ----------------------------------------------------------------------- */

#define UNKNOWN 1

/* ----------------------------------------------------------------------- */

// ENUMERATIONS
//

enum item
{
  item_WIRESNIPS,
  item_SHOVEL,
  item_LOCKPICK,
  item_PAPERS,
  item_TORCH,
  item_BRIBE,
  item_UNIFORM,
  item_FOOD,
  item_POISON,
  item_RED_KEY,
  item_YELLOW_KEY,
  item_GREEN_KEY,
  item_RED_CROSS_PARCEL,
  item_RADIO,
  item_PURSE,
  item_COMPASS,
  item__LIMIT,
  item_NONE = 255
};

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
typedef struct { tilerow_t row[8]; } tile_t;

/** An item. */
typedef enum item item_t;

/* ----------------------------------------------------------------------- */

// EXTERNS
//

extern const tgeobject_t *interior_object_tile_refs[interiorobject__LIMIT];

extern const tile_t interior_tiles[interiorobjecttile_MAX];


/* ----------------------------------------------------------------------- */

// STATIC CONSTS
//

static const tile_t bitmap_font[] =
{
  { { 0x00, 0x7C, 0xFE, 0xEE, 0xEE, 0xEE, 0xFE, 0x7C } }, // 0 or O
  { { 0x00, 0x1E, 0x3E, 0x6E, 0x0E, 0x0E, 0x0E, 0x0E } }, // 1
  { { 0x00, 0x7C, 0xFE, 0xCE, 0x1C, 0x70, 0xFE, 0xFE } }, // 2
  { { 0x00, 0xFC, 0xFE, 0x0E, 0x3C, 0x0E, 0xFE, 0xFC } }, // 3
  { { 0x00, 0x0E, 0x1E, 0x3E, 0x6E, 0xFE, 0x0E, 0x0E } }, // 4
  { { 0x00, 0xFC, 0xC0, 0xFC, 0x7E, 0x0E, 0xFE, 0xFC } }, // 5
  { { 0x00, 0x38, 0x60, 0xFC, 0xFE, 0xC6, 0xFE, 0x7C } }, // 6
  { { 0x00, 0xFE, 0x0E, 0x0E, 0x1C, 0x1C, 0x38, 0x38 } }, // 7
  { { 0x00, 0x7C, 0xEE, 0xEE, 0x7C, 0xEE, 0xEE, 0x7C } }, // 8
  { { 0x00, 0x7C, 0xFE, 0xC6, 0xFE, 0x7E, 0x0C, 0x38 } }, // 9
  { { 0x00, 0x38, 0x7C, 0x7C, 0xEE, 0xEE, 0xFE, 0xEE } }, // A
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xFC, 0xEE, 0xEE, 0xFC } }, // B
  { { 0x00, 0x1E, 0x7E, 0xFE, 0xF0, 0xFE, 0x7E, 0x1E } }, // C
  { { 0x00, 0xF0, 0xFC, 0xEE, 0xEE, 0xEE, 0xFC, 0xF0 } }, // D
  { { 0x00, 0xFE, 0xFE, 0xE0, 0xFE, 0xE0, 0xFE, 0xFE } }, // E
  { { 0x00, 0xFE, 0xFE, 0xE0, 0xFC, 0xE0, 0xE0, 0xE0 } }, // F
  { { 0x00, 0x1E, 0x7E, 0xF0, 0xEE, 0xF2, 0x7E, 0x1E } }, // G
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xFE, 0xEE, 0xEE, 0xEE } }, // H
  { { 0x00, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38 } }, // I
  { { 0x00, 0xFE, 0x38, 0x38, 0x38, 0x38, 0xF8, 0xF0 } }, // J
  { { 0x00, 0xEE, 0xEE, 0xFC, 0xF8, 0xFC, 0xEE, 0xEE } }, // K
  { { 0x00, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xFE, 0xFE } }, // L
  { { 0x00, 0x6C, 0xFE, 0xFE, 0xD6, 0xD6, 0xC6, 0xC6 } }, // M
  { { 0x00, 0xE6, 0xF6, 0xFE, 0xFE, 0xEE, 0xE6, 0xE6 } }, // N
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xEE, 0xFC, 0xE0, 0xE0 } }, // P
  { { 0x00, 0x7C, 0xFE, 0xEE, 0xEE, 0xEE, 0xFC, 0x7E } }, // Q
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xFC, 0xF8, 0xEC, 0xEE } }, // R
  { { 0x00, 0x7E, 0xFE, 0xF0, 0x7C, 0x1E, 0xFE, 0xFC } }, // S
  { { 0x00, 0xFE, 0xFE, 0x38, 0x38, 0x38, 0x38, 0x38 } }, // T
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE, 0xFE, 0x7C } }, // U
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xEE, 0x6C, 0x7C, 0x38 } }, // V
  { { 0x00, 0xC6, 0xC6, 0xC6, 0xD6, 0xFE, 0xEE, 0xC6 } }, // W
  { { 0x00, 0xC6, 0xEE, 0x7C, 0x38, 0x7C, 0xEE, 0xC6 } }, // X
  { { 0x00, 0xC6, 0xEE, 0x7C, 0x38, 0x38, 0x38, 0x38 } }, // Y
  { { 0x00, 0xFE, 0xFE, 0x0E, 0x38, 0xE0, 0xFE, 0xFE } }, // Z
  { { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } }, // SPACE
  { { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30 } }, // FULL STOP
  { { 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC } }, // UNKNOWN
};

#define _ 38 // UNKNOWN
static const unsigned char ascii_to_font[256] =
{
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
 36,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _, 37,  _,
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  _,  _,  _,  _,  _,  _,
 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,  0,
 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
};
#undef _

/* ----------------------------------------------------------------------- */

// FORWARD REFERENCES
//

uint8_t *plot_single_glyph(int A, uint8_t *output);

static const char *messages_table[message__LIMIT];

int item_to_bitmask(item_t item);

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

/* $6AB5 */
void expand_object(tgestate_t *state, object_t index, uint8_t *output)
{
  int                columns;
  const tgeobject_t *obj;
  int                width, height;
  int                saved_width;
  const uint8_t     *data;
  int                byte;
  int                val;

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

/* $6B42 */
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

      tile_data = &interior_tiles[*tiles_buf++].row[0];

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

/* $7CE9 */
/* Given a screen address, return the same position on the next scanline. */
uint16_t get_next_scanline(uint16_t HL) /* stateless */
{
  uint16_t DE;

  HL += 0x0100;
  if (HL & 0x0700)
    return HL; /* line count didn't rollover */

  if ((HL & 0xFF) >= 0xE0)
    DE = 0xFF20;
  else
    DE = 0xF820;

  return HL + DE; /* needs to be a 16-bit add! */
}

/* ----------------------------------------------------------------------- */


/* ----------------------------------------------------------------------- */

/* $7D2F */
uint8_t *plot_glyph(const char *pcharacter, uint8_t *output)
{
  return plot_single_glyph(*pcharacter, output);
}

uint8_t *plot_single_glyph(int character, uint8_t *output)
{
  const tile_t    *glyph;
  const tilerow_t *row;
  int              iters;

  glyph = &bitmap_font[ascii_to_font[character]];
  row   = &glyph->row[0];
  iters = 8; // 8 iterations
  do
  {
    *output = *row++;
    output += 256; // next row
  }
  while (--iters);

  return ++output; // return the next character position
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

/* ----------------------------------------------------------------------- */

/* $A59C */
int have_required_items(const item_t *pitem, int previous)
{
  return item_to_bitmask(*pitem) + previous;
}

/* $A5A3 */
int item_to_bitmask(item_t item)
{
  switch (item)
  {
    case item_COMPASS: return 1;
    case item_PAPERS:  return 2;
    case item_PURSE:   return 4;
    case item_UNIFORM: return 8;
    default: return 0;
  }
}

/* ----------------------------------------------------------------------- */

/* $A5BF */
void screenlocstring_plot(tgestate_t *state, uint8_t *HL)
{
  uint8_t *screenaddr;
  int      nbytes;

  screenaddr = state->screen_buf + HL[0] + (HL[1] << 8);
  nbytes     = HL[2];
  HL += 3;
  do
    screenaddr = plot_glyph((const char *) HL++, screenaddr);
  while (--nbytes);
}

/* ----------------------------------------------------------------------- */

#define door_FLAG_LOCKED (1 << 7)

/* $B1D4 */
int is_door_open(tgestate_t *state)
{
  int      mask;
  int      cur;
  uint8_t *door;
  int      iters;

  mask  = 0xFF & ~door_FLAG_LOCKED;
  cur   = state->current_door & mask;
  door  = &state->gates_and_doors[0];
  iters = 9;
  do
  {
    if ((*door & mask) == cur)
    {
      if ((*door & door_FLAG_LOCKED) == 0)
        return 0; // open

      queue_message_for_display(state, message_THE_DOOR_IS_LOCKED);
      return 1; // locked
    }
    door++;
  }
  while (--iters);

  return 0; // open
}

/* ----------------------------------------------------------------------- */

