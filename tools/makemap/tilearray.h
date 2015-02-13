/* tilearray.h -- managed arrays of map tiles */

#ifndef TILEARRAY_H
#define TILEARRAY_H

#include <stddef.h>

#include "base/result.h"
#include "datastruct/vector.h"

// Q: Why not make tilearray_t use a vector? I'm using vector anyway for the tilecoord arrays.

typedef struct tilearray
{
  int       edgesize;       /* edge size of tiles */
  size_t    tilebytes;      /* tile_t tile bytes */
  size_t    elementsize;    /* tile_t element size */

  void     *array;          /* array of tile_t's */
  int       used;
  int       allocated;
}
tilearray_t;

tilearray_t *tilearray_create(int edgesize);
void tilearray_destroy(tilearray_t *doomed);

typedef struct tile
{
  vector_t *coords;         /* list of all locations where this tile is used */
  uint8_t   data[UNKNOWN];  /* flexibly sized array */
}
tile_t;

tile_t *tilearray_get(const tilearray_t *tilearray,
                      int                index);

result_t tilearray_insert(tilearray_t *tilearray,
                          uint8_t     *data,
                          int          space,
                          int          x,
                          int          y,
                          int         *index);

typedef struct tilecoord
{
  int space; /* input space */
  int x, y;  /* coord */
}
tilecoord_t;

#endif /* TILEARRAY_H */

// vim: ts=8 sw=2 sts=2 et
