/* tilearray.c -- managed arrays of map tiles */

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "base/result.h"
#include "datastruct/vector.h"
#include "utils/array.h"

#include "tilearray.h"

tilearray_t *tilearray_create(int edgesize)
{
  tilearray_t *tilearray;

  assert(edgesize > 0);

  const size_t tilebytes   = edgesize * edgesize / 8;
  const size_t elementsize = offsetof(tile_t, data) + tilebytes;

  tilearray = malloc(sizeof(*tilearray));
  if (tilearray == NULL)
    return NULL;

  tilearray->edgesize    = edgesize;
  tilearray->tilebytes   = tilebytes;
  tilearray->elementsize = elementsize;

  tilearray->array       = NULL;
  tilearray->allocated   = 0;
  tilearray->used        = 0;

  return tilearray;
}

void tilearray_destroy(tilearray_t *doomed)
{
  int i;

  if (doomed == NULL)
    return;

  for (i = 0; i < doomed->used; i++)
    vector_destroy(tilearray_get(doomed, i)->coords);

  free(doomed->array);
  free(doomed);
}

// TODO inline this
tile_t *tilearray_get(const tilearray_t *tilearray,
                      int                index)
{
  assert(tilearray);
  assert(index >= 0);

  return (tile_t *) ((char *) tilearray->array + index * tilearray->elementsize);
}

result_t tilearray_insert(tilearray_t *tilearray,
                          uint8_t     *data,
                          int          space,
                          int          x,
                          int          y,
                          int         *index)
{
  result_t          err;
  int               i;
  tile_t           *tile;
  const tilecoord_t coord = { space, x, y };

  assert(tilearray);
  assert(data);
  assert(index);

  *index = -1;

  /* Find the tile, if present. */

  for (i = 0; i < tilearray->used; i++)
  {
    tile = tilearray_get(tilearray, i);
    if (memcmp(&tile->data[0], data, tilearray->tilebytes) == 0)
    {
      /* Found it. */

      err = vector_insert(tile->coords, &coord);
      if (err)
        return err;

      *index = i;

      return result_OK;
    }
  }

  /* The tile was not found - add it. */

  /* Grow if required. */
  if (tilearray->used == tilearray->allocated)
  {
    const int minimum = 512; // guess

    if (array_grow(&tilearray->array,
                   tilearray->elementsize,
                   tilearray->used,
                   &tilearray->allocated,
                   tilearray->used + 1,
                   minimum))
    {
      return result_OOM;
    }
  }

  tile = tilearray_get(tilearray, tilearray->used);

  *index = tilearray->used++;

  memcpy(&tile->data[0], data, tilearray->tilebytes);

  tile->coords = vector_create(sizeof(coord));
  if (tile->coords == NULL)
    return result_OOM;

  err = vector_insert(tile->coords, &coord);
  if (err)
    return err; // FIXME cleanup is missing

  return result_OK;
}

// vim: ts=8 sw=2 sts=2 et
