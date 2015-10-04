/* makemaps.c -- map making */

#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "base/debug.h"
#include "base/result.h"
#include "base/utils.h"
#include "datastruct/bitvec.h"
#include "datastruct/vector.h"
#include "io/stream.h"
#include "io/stream-mem.h"
#include "io/stream-stdio.h"
#include "utils/array.h"

#include "config.h"
#include "groupsloader.h"
#include "makemaps.h"
#include "pngloader.h"
#include "tilearray.h"

/* ----------------------------------------------------------------------- */

#define NREFS (4*4)

typedef struct tilesort
{
  int tile_index; // tile index
  int tiles[NREFS]; // FIXME, fixed size for now
}
tilesort_t;

/* ----------------------------------------------------------------------- */

// could make this a growable array
#define MAXTILEARRAYS 10

typedef struct makemap
{
  int            tilew, tileh;
  unsigned char *map;  // maparray
  int            starting_index;

  int            ngroups;
  tilearray_t   *bigtiles[MAXTILEARRAYS]; // array of tilearray_t's of big tiles
  tilearray_t   *smalltiles[MAXTILEARRAYS]; // array of tilearray_t's of small tiles
  tilesort_t    *tilesort[MAXTILEARRAYS]; // array of tilesort_t's
}
makemap_t;

/* ----------------------------------------------------------------------- */

static void makemap_dealloc(makemap_t *doomed)
{
  int i;

  for (i = 0; i < doomed->ngroups; i++)
  {
    tilearray_destroy(doomed->bigtiles[i]);
    tilearray_destroy(doomed->smalltiles[i]);
    free(doomed->tilesort[i]);
  }

  free(doomed->map);
}

/* ----------------------------------------------------------------------- */

typedef struct grouppos
{
  unsigned char x, y;
  unsigned char count;  /* run length */
}
grouppos_t;

/* ----------------------------------------------------------------------- */

/* Produce 'big' tiles from input map image. */
static result_t make_tiles_from_source(const pngloader_t *png,
                                       int                tilesize,
                                       const vector_t    *groups,
                                       makemap_t         *makemap,
                                       int                verbosity,
                                       tilearray_t      **ptilearray)
{
  result_t     err;
  tilearray_t *bigtiles;
  size_t       total;

  assert(png);
  assert(tilesize > 0);
  assert(groups);
  assert(makemap);

  if (verbosity > 0)
    logf_info("make_tiles_from_source: create big tiles from source image");

  *ptilearray = NULL;

  bigtiles = tilearray_create(tilesize);
  if (bigtiles == NULL)
  {
    err = result_OOM;
    goto failure;
  }

  total = 0;

  {
    const size_t edgebytes = tilesize / 8;

    /* For every grouppos... */

    size_t      npos;
    grouppos_t *pos;

    npos = vector_length(groups);
    pos  = vector_get(groups, 0);
    while (npos--)
    {
      int x, y;
      int count;

      x     = pos->x * tilesize;
      y     = pos->y * tilesize;
      count = pos->count;

      total += count;

      unsigned char *pmap;

      pmap = &makemap->map[pos->y * makemap->tilew + pos->x];
//      int c = count;
//      while (c--)
//        *mapptr++ = "\x00\x55\xEE"[group_index];

      /* For every element... */

      while (count--)
      {
        png_byte  data[bigtiles->tilebytes];
        png_byte *pdata;
        int       tx, ty;
        int       index;
        const int x_in_bytes = x / 8;

        pdata = &data[0];
        for (ty = y; ty < y + tilesize; ty++)
        {
          const png_byte *row = png->row_pointers[ty] + x_in_bytes;

          for (tx = 0; tx < edgebytes; tx++)
            *pdata++ = row[tx];
        }

        err = tilearray_insert(bigtiles, &data[0], 0, x, y, &index);
        if (err)
          goto failure;

        *pmap++ = makemap->starting_index + index;

        x += tilesize;
      }

      pos++;
    }
  }

  *ptilearray = bigtiles;

  if (verbosity > 1)
    logf_info("total map elements seen=%zu", total);

  if (verbosity > 0)
    logf_info("make_tiles_from_source: done");

  return result_OK;


failure:

  return err;
}

static result_t dump_map(makemap_t *makemap, int verbosity)
{
  unsigned char *pmaparray;
  int            x, y;

  // dump map
  pmaparray = makemap->map;
  for (y = 0; y < makemap->tileh; y++)
  {
    for (x = 0; x < makemap->tilew; x++)
      printf("%.2x", *pmaparray++);
    printf("\n");
  }

  // dump map and bigtile stats
  {
    int nuniquetiles;
    int i;

    nuniquetiles = 0;
    for (i = 0; i < makemap->ngroups; i++)
      nuniquetiles += makemap->bigtiles[i]->used;

    logf_info("%d unique 'big' tiles found", nuniquetiles);

    int    bytespermapelement; // bytes per map tile index
    int    bytespersupertile;
    size_t total;

    bytespermapelement = 1;
    bytespersupertile  = 4 * 4;

    total = makemap->tilew * makemap->tileh * bytespermapelement;
    logf_info(" %d (= %dx%d map elements at %d byte(s) each)",
              makemap->tilew * makemap->tileh * bytespermapelement,
              makemap->tilew,
              makemap->tileh,
              bytespermapelement);

    total += nuniquetiles * bytespersupertile;
    logf_info(" + %d (= %d unique supertiles at %d byte(s) each)",
              nuniquetiles * bytespersupertile,
              nuniquetiles,
              bytespersupertile);

    logf_info(" = %lu bytes", total);
  }

  // dump bigtile stats
  if (verbosity > 0)
  {
    int     i;
    int     j;
    tile_t *pt;
    size_t  ncoords;
    int     c;

    for (j = 0; j < makemap->ngroups; j++)
    {
      const tilearray_t *bigtilearray = makemap->bigtiles[j];

      logf_info("big tile set %d", j);

      for (i = 0; i < bigtilearray->used; i++)
      {
        pt = tilearray_get(bigtilearray, i);
        ncoords = vector_length(pt->coords);
        logf_info("big tile %d: count %zu (%.2f%%)",
                  i,
                  ncoords,
                  ncoords * 100.0 / (makemap->tilew * makemap->tileh));

        if (verbosity > 1)
        {
          for (c = 0; c < ncoords; c++)
          {
            const tilecoord_t *r = vector_get(pt->coords, c);
            logf_info("  source=%d x,y=%d,%d", r->space, r->x, r->y);
          }
        }
      }
    }
  }

  return result_OK;
}

/* ----------------------------------------------------------------------- */

/* Produce 'small' tiles from 'big' tiles. */
static result_t make_tiles_from_tiles(int           tilesize,
                                      tilearray_t  *bigtiles,
                                      makemap_t    *makemap,
                                      int           verbosity,
                                      tilearray_t **ptilearray)
{
  result_t     err;
  tilearray_t *tiles;
  int          t;

  assert(tilesize > 0);
  assert(bigtiles);
  assert(makemap);

  if (verbosity > 0)
    logf_info("make_tiles_from_tiles: create small tiles from big tiles");

  *ptilearray = NULL;

  tiles = tilearray_create(tilesize);
  if (tiles == NULL)
  {
    err = result_OOM;
    goto failure;
  }

  {
    const size_t edgebytes = tilesize / 8;

    for (t = 0; t < bigtiles->used; t++)
    {
      tile_t *pst;
      int     x, y;

      pst = tilearray_get(bigtiles, t);

      for (y = 0; y < bigtiles->edgesize; y += tilesize)
      {
        for (x = 0; x < bigtiles->edgesize; x += tilesize)
        {
          png_byte  data[tiles->tilebytes];
          png_byte *pdata;
          int       tx, ty;
          int       index;
          const int x_in_bytes = x / 8;

          pdata = &data[0];
          for (ty = y; ty < y + tilesize; ty++)
          {
            // 4 is 32 bits per row (bigtiles->edgesize / 8)
            const png_byte *row = &pst->data[ty * 4 + x_in_bytes];

            for (tx = 0; tx < edgebytes; tx++)
              *pdata++ = row[tx];
          }

          err = tilearray_insert(tiles, &data[0], t, x, y, &index);
          if (err)
            goto failure;
        }
      }
    }
  }

  *ptilearray = tiles;

  if (verbosity > 0)
    logf_info("make_tiles_from_tiles: done");

  return result_OK;


failure:

  return err;
}

static result_t dump_supertiles(tilesort_t *tilesort, int len, int N, int verbosity)
{
  int i;
  int x,y;

  for (i = 0; i < len; i++)
  {
    printf("{\n");
    for (y = 0; y < N; y++)
    {
      printf("  { ");
      for (x = 0; x < N - 1; x++)
        printf("0x%.2x, ", tilesort->tiles[y * N + x]);
      printf("0x%.2x },\n", tilesort->tiles[y * N + x]);
    }
    printf("},\n");

    tilesort++;
  }

  return result_OK;
}

// print stats
static result_t dump_tiles(tilearray_t *tiles, int verbosity)
{
  const int nuniquetiles = tiles->used;
  int       i;

  if (verbosity > 0)
    logf_info("%d unique small tiles found", nuniquetiles);

  for (i = 0; i < nuniquetiles; i++)
  {
    tile_t *pt;
    size_t  ncoords;

    pt = tilearray_get(tiles, i);
    ncoords = vector_length(pt->coords);
    if (verbosity > 0)
      logf_info("small tile %d: count %zu", i, ncoords);

    if (verbosity > 1)
    {
      int c;

      for (c = 0; c < ncoords; c++)
      {
        const tilecoord_t *r = vector_get(pt->coords, c);
        logf_info("  source=%d x,y=%d,%d", r->space, r->x, r->y);
      }
    }
  }

  return result_OK;
}

/* ----------------------------------------------------------------------- */

// return the number of exact matching tiles in the two given tilesort_t's
static int match(const tilesort_t *a, const tilesort_t *b, int nrefs)
{
  int nmatches;
  int i;
  int j;

  nmatches = 0;

  for (i = 0; i < nrefs; i++)
  {
    int ta;

    ta = a->tiles[i];
    if (ta > 0)
      for (j = 0; j < nrefs; j++)
        if (ta == b->tiles[j]) // assuming here that tile 0 is the blank one
          nmatches++;
  }

  return nmatches;
}

typedef struct meh
{
  int index;
  int x, y;
}
meh_t;

static int meh_compare(const void *va, const void *vb)
{
  const meh_t *a = va;
  const meh_t *b = vb;

  if (a->y > b->y)
    return 1;
  else if (a->y < b->y)
    return -1;
  else
  {
    if (a->x > b->x)
      return 1;
    else if (a->x < b->x)
      return -1;
  }

  return 0;
}

// attempt 3
//
// idea: start with empty array,
//       add an entry
//       find the most similar entry from the as-yet uninserted, insert that
//       repeat until all entries are used up
//
// expect: produced array should be in order of similarity
//
// results: ...
//
static result_t order_tiles(const tilearray_t *bigtiles,
                            const tilearray_t *smalltiles,
                            tilesort_t       **pts,
                            int                verbosity)
{
  // e.g. 4/1*4/1=16
  const int N = bigtiles->edgesize / smalltiles->edgesize *
                bigtiles->edgesize / smalltiles->edgesize;

  result_t    err;
  tilesort_t *sorted;
  tilesort_t *psorted;
  int         bigtileindex;

  *pts = NULL;

  printf("reorder_supertiles\n");

  // start by building an array of tilesort_t's: one for every big tile
  //

  sorted = malloc(bigtiles->used * sizeof(*sorted));
  if (sorted == NULL)
  {
    err = result_OOM;
    goto failure;
  }

  psorted = sorted;

  // for every big tile
  for (bigtileindex = 0; bigtileindex < bigtiles->used; bigtileindex++)
  {
    int   tiles_index;
    int   j;
    meh_t meh[N];

    psorted->tile_index = bigtileindex;

    tiles_index = 0;
    // for every small tile
    for (j = 0; j < smalltiles->used; j++)
    {
      tile_t            *pt;
      size_t             count;
      const tilecoord_t *r;

      pt    = tilearray_get(smalltiles, j);
      count = vector_length(pt->coords);
      r     = vector_get(pt->coords, 0);
      // for every place where it's used
      while (count--)
      {
        if (r->space == bigtileindex)
        {
          meh[tiles_index].index = j;
          meh[tiles_index].x     = r->x;
          meh[tiles_index].y     = r->y;
          tiles_index++;
        }
        r++;
      }
    }

    assert(tiles_index == N);

    // sort meh by x/y
    qsort(&meh[0], tiles_index, sizeof(meh_t), meh_compare);

    // form psorted tiles
    for (j = 0; j < N; j++)
      psorted->tiles[j] = meh[j].index;

    psorted++;
  }

  *pts = sorted;

  if (verbosity >= 1)
  {
    for (int xx = 0; xx < bigtiles->used; xx++)
    {
      printf("%3.1d: ", sorted[xx].tile_index);
      for (int yy = 0; yy < N; yy++)
        printf("%3.1d, ", sorted[xx].tiles[yy]);
      printf("\n");
    }
  }

  return result_OK;


failure:

  return err;
}

/* ----------------------------------------------------------------------- */

static result_t build_tilesets(tilearray_t      *bigtiles,
                               tilearray_t      *smalltiles,
                               const tilesort_t *tilesort,
                               int               verbosity)
{
#define MAXSETS 20

  int      *bigtileallocations = NULL;
  int       i;
  int       curset;
  bitvec_t *tileset[MAXSETS]; // one bit set per tile
  int       lowest = INT_MAX;

  assert(bigtiles);
  assert(smalltiles);
  assert(tilesort);

  if (verbosity > 0)
    printf("build_tilesets: build tile sets\n");

  bigtileallocations = malloc(bigtiles->used * sizeof(*bigtileallocations));
  if (bigtileallocations == NULL)
    goto oom;

  for (i = 0; i < MAXSETS; i++)
  {
    tileset[i] = bitvec_create(smalltiles->used);
    if (tileset[i] == NULL)
      goto oom;
  }

  {
    curset = 0;

    for (int supertileindex = 0; supertileindex < bigtiles->used; supertileindex++) // for every supertile
    {
      const int N = bigtiles->edgesize / smalltiles->edgesize *
                    bigtiles->edgesize / smalltiles->edgesize;
      int       superindex;
      int       refs[N]; // fixed for the moment
      int      *prefs;
      int       j;
      int       need_to_insert;
      int       olderset;

      superindex = tilesort[supertileindex].tile_index;

      prefs = &refs[0];

      for (j = 0; j < smalltiles->used; j++) // for every tile
      {
        tile_t *pt;
        size_t  count;
        int     k;

        pt = tilearray_get(smalltiles, j);
        count = vector_length(pt->coords);
        for (k = 0; k < count; k++) // for every use
        {
          const tilecoord_t *r = vector_get(pt->coords, k);
          if (r->space == superindex)
            *prefs++ = j;
        }
      }

      if (verbosity > 3)
      {
        // want to insert this lot
        for (j = 0; j < N; j++)
          printf("%d,", refs[j]);
        printf("\n");
      }

      need_to_insert = 1;

      // do they (all) exist in any previous tile set?
      for (olderset = 0; olderset <= curset; olderset++)
      {
        for (j = 0; j < N; j++)
          if (bitvec_get(tileset[olderset], refs[j]) == 0)
            break;

        if (j == N) // all were found
        {
          bigtileallocations[superindex] = olderset; // supertile superindex can use tileset olderset
          need_to_insert = 0;
          break;
        }
      }

      if (need_to_insert)
      {
        int exist;
        int need;

        // but is there space for them in the current tile set?

        // how many already exist in the current tile set?
        exist = 0;
        for (j = 0; j < N; j++)
          if (bitvec_get(tileset[curset], refs[j]))
            exist++;

        need = N - exist;

        // is a new tile set required?
        if (bitvec_count(tileset[curset]) + need > 256)
        {
          logf_warning("tile set %d is full: creating tile set %d\n", curset, curset + 1);
          curset++;
          assert(curset < MAXSETS);
        }

        // insert
        for (j = 0; j < N; j++)
          bitvec_set(tileset[curset], refs[j]);

        bigtileallocations[superindex] = curset; // supertile superindex can use tileset curset
      }
    }

    // printf("supertile %d is the last\n", superindex);

    printf("set counts: ");
    int total = 0;
    for (i = 0; i <= curset; i++)
    {
      int count;

      count = bitvec_count(tileset[i]);
      printf("%d%s", count, i <= curset - 1 ? " + " : "");
      total += count;
    }
    printf(" = %d\n", total);

    lowest = MIN(lowest, total);
  }

  printf("lowest no. of tiles = %d\n", lowest);

  // TODO: finally, sort the supertile allocations by set then reorder the map tiles

  // clean up
  for (i = 0; i < MAXSETS; i++)
    bitvec_destroy(tileset[i]);

  free(bigtileallocations);

  return result_OK;


oom:

  free(bigtileallocations);

  return result_OOM;
}

/* ----------------------------------------------------------------------- */

/* Transform the flat map (in 'groups') into a list of lists of grouppos
 * structs, run length encoding as we go. */
static result_t groups_to_grouppos(const groups_t *groups,
                                   vector_t      **output_lists)
{
  result_t             err;
  int                  width, height;
  int                  max_group;
  vector_t            *list_of_lists;
  int                  i;
  vector_t           **pv;
  const unsigned char *p;
  int                  x,y;

  width     = groups->width;
  height    = groups->height;
  max_group = groups->ntokens;

  /* Create a vector to hold pointers to vectors of positions. */
  list_of_lists = vector_create(sizeof(vector_t *));
  if (list_of_lists == NULL)
  {
    err = result_OOM;
    goto failure;
  }

  err = vector_ensure(list_of_lists, max_group);
  if (err)
    goto failure;

  /* Create a worst-case length list of vectors. */
  for (i = 0; i < max_group; i++)
  {
    vector_t *v;

    v = vector_create(sizeof(grouppos_t));
    if (v == NULL)
    {
      err = result_OOM;
      goto failure;
    }

    vector_set(list_of_lists, i, &v);
  }

  /* Keep array base handy. */
  pv = vector_get(list_of_lists, 0);

  /* for every entry, insert the (x,y,count) position + run length into the
   * respective list. */
  p = vector_get(groups->groups, 0);
  for (y = 0; y < height; y++)
  {
    const unsigned char *end = p + width;
    int                  count;

    for (x = 0; x < width; x += count)
    {
      int group;

      /* Find the run length. */
      {
        const unsigned char *startp;

        startp = p;

        group = *p++;
        assert(group < max_group);
        while (p < end && group == *p)
          p++;

        count = (int) (p - startp);
      }

      /* Store the grouppos. */
      {
        const grouppos_t pos = { x, y, count };

        err = vector_insert(pv[group], &pos);
        if (err)
          goto failure;
      }
    }
  }

  *output_lists = list_of_lists;

  return result_OK;


failure:

  // FIXME: Clean up.

  return err;
}

static result_t dump_list_of_grouppos(vector_t *list_of_grouppos)
{
  int    total;
  size_t len;
  int    i;

  total = 0;

  len = vector_length(list_of_grouppos);
  for (i = 0; i < len; i++)
  {
    vector_t  **pgroups;
    vector_t   *groups;
    grouppos_t *element;
    size_t      groups_len;
    int         j;

    pgroups = vector_get(list_of_grouppos, i);
    groups  = *pgroups;

    groups_len = vector_length(groups);
    element    = vector_get(groups, 0);
    for (j = 0; j < groups_len; j++)
    {
      printf("set %d, entry %d is (%d,%d,%d)\n",
             i, j, element->x, element->y, element->count);
      total += element->count;
      element++;
    }
  }

  printf("total=%d\n", total);

  return result_OK;
}

/* ----------------------------------------------------------------------- */

static result_t process_group(const pngloader_t *png,
                              const vector_t    *groups,
                              int                tilesize,
                              int                verbosity,
                              int                group_index,
                              makemap_t         *makemap)
{
  result_t     err;
  tilearray_t *bigtiles;
  tilearray_t *smalltiles;
  tilesort_t  *tilesort;

  // hoist?
  if ((png->width  % tilesize) != 0 &&
      (png->height % tilesize) != 0)
  {
    logf_warning("skipping tile size %d: input file dimensions not a multiple",
                 tilesize);
    return result_OK;
  }

  // arg passing here is a bit awkward (makemap)

  err = make_tiles_from_source(png,
                               tilesize,
                               groups,
                               makemap,
                               verbosity,
                               &bigtiles);
  if (err)
    goto failure;

  err = make_tiles_from_tiles(8,
                              bigtiles,
                              makemap,
                              verbosity,
                              &smalltiles);
  if (err)
    goto failure;
  
  err = order_tiles(bigtiles, smalltiles, &tilesort, verbosity);
  if (err)
    goto failure;

  // think this is redundant now
//  err = build_tilesets(bigtiles, smalltiles, tilesort, verbosity);
//  if (err)
//    goto failure;

  makemap->ngroups++;
  
  // save our results
  makemap->bigtiles[group_index]   = bigtiles;
  makemap->smalltiles[group_index] = smalltiles;
  makemap->tilesort[group_index]   = tilesort;

  makemap->starting_index += bigtiles->used;
  
  return result_OK;
  
  
failure:
  
  return err;
}

/* ----------------------------------------------------------------------- */

/* This is the groupings of the standard exterior map.
 */
static const unsigned char standard_groups[] =
"x_H\n"
"\n"
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxxxxxx_xxx_xxxxxxxxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxxxxxx_x_x_xxxxxxxxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxx_xxx_____xxxxxxxxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxx_xx________xxx_xxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxxxxxxxxxxxx_____________x_xxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxxx_xxx_xxxx________________xxxxxxxxxxxxxxxxxxxx\n"
"xxxxxxxx____________________________xxxxxxxxxxxxxxxxxx\n"
"xxxxx_________________________________xxxxxxxxxxxxxxxx\n"
"xxxxx___________________________________xxxxxxxxxxxxxx\n"
"xxxxxxx_________________________________xxxxxxxxxxxxxx\n"
"xxxxxxxxx__xxxx_________________________xxxxxxxxxxxxxx\n"
"__xxxxxxxxxxxxxxx_______________________xxxxxxxxxxxxxx\n"
"____xxxxxxxxxxxxx_______________________xxxxxxxxxxxxxx\n"
"______xxxxxxxxxxx_________________________xxxxxxxxxxxx\n"
"________xxxxxxxxx___________________________xxx_xxxxxx\n"
"__________xxxxxxx__________________________HH_x_HHxxxx\n"
"_______HHHHxxxxxxHH_______________________HHHHHHHHx_xx\n"
"______HHHHHHHHxxxHHHH______________________HHHHHHHx_HH\n"
"_____HHHHHHHHHHHHHHHHHH__________________HHHHHHHHHHHHH\n"
"___HHHHHHHHHHHHHHHHHHHHHH______________HHHHHHHHHHHHHHH\n"
"__HHHHHHHHHHHHHHHHHHHHHHHHH__________HHHHHHHHHHHHHHH__\n"
"__HHHHHHHHHHHHHHHHHHHHHHHHHHH__HH__HHHHHHHHHHHHHHH____\n"
"__HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH______\n"
"__HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH________\n"
"____HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH__________\n"
"______HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH____________\n"
"________HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH______________\n"
"__________HHHHHHHHHHHH____HHHHHHHHHHHH________________\n"
"____________HHHHHHHH________HHHHHHHH__________________\n"
"______________HHHH____________HHHH____________________\n"
"______________________________________________________\n"
"______________________________________________________\n";

/* ----------------------------------------------------------------------- */

result_t make_maps(const config_t *config)
{
  result_t    err;
  groups_t    groups;
  vector_t   *list_of_grouppos;
  pngloader_t pngloader;

  if (config->verbosity > 0)
  {
    logf_info("MakeMaps -- The Great Escape map data compiler");
    logf_info("Copyright (c) David Thomas, 2014-2015 -- v0.11");
    logf_info("");
  }

  if (config->verbosity > 0)
    logf_info("Extracting grouping information");

  if (config->groups_file == NULL)
  {
    err = parse_groups_from_mem(&groups,
                                &standard_groups[0],
                                sizeof(standard_groups));
    if (err)
      goto failure;
  }
  else
  {
    err = parse_groups_from_file(&groups, config->groups_file);
    if (err)
      goto failure;
  }

  /* Re-encode the flat groups array into a list of lists of grouppos
   * structs. */
  err = groups_to_grouppos(&groups, &list_of_grouppos);
  if (err)
    goto failure;

  if (config->verbosity > 1)
  {
    err = dump_list_of_grouppos(list_of_grouppos);
    if (err)
      goto failure;
  }

  if (config->verbosity > 0)
    logf_info("Decoding PNG input image");

  err = read_png_file(&pngloader, config->image_file, config->verbosity);
  if (err)
    goto failure;

  if (0) // we don't seem to need this
  {
    if (pngloader.color_type != PNG_COLOR_TYPE_GRAY)
      haltf("color_type of input file must be PNG_COLOR_TYPE_GRAY (%d) (is %d)",
            PNG_COLOR_TYPE_GRAY, pngloader.color_type);
  }

  if (pngloader.bit_depth != 1)
    haltf("bit_depth of input file must be %d (is %d)",
          1, pngloader.bit_depth);

  if (pngloader.width  != groups.width  * config->tilesize ||
      pngloader.height != groups.height * config->tilesize)
    haltf("image size does not match grouping data size");

  if (config->verbosity > 0)
    logf_info("Processing groups in order");


  {
    makemap_t makemap;

    int                tilesize;
    int                pngw, pngh;
    int                tilew, tileh;
    const pngloader_t *png = &pngloader;
    unsigned char     *map;
    int                i;

    tilesize = config->tilesize;

    pngw = png->width;
    pngh = png->height;

    if (pngw <= 0 || pngh <= 0)
    {
      err = result_BAD_ARG;
      goto failure;
    }

    tilew = pngw / tilesize;
    tileh = pngh / tilesize;

    if (tilew <= 0 || tileh <= 0)
    {
      err = result_BAD_ARG;
      goto failure;
    }

    if (config->verbosity > 0)
      logf_info("make_tiles_from_source: create tiles from source image");

    if (config->verbosity > 0)
    {
      logf_info("original image is (%d x %d / 8 =) %d bytes",
                pngw, pngh, pngw * pngh / 8);

      logf_info("with tile size %dx%d input is %dx%d = %d tiles",
                tilesize, tilesize, tilew, tileh, tilew * tileh);
    }


    map = malloc(tilew * tileh);
    if (map == NULL)
    {
      err = result_OOM;
      goto failure;
    }


    makemap.tilew          = tilew;
    makemap.tileh          = tileh;
    makemap.map            = map;
    makemap.starting_index = 0;
    makemap.ngroups        = 0;

    {
      size_t     len;
      vector_t **posvecs;

      len     = vector_length(list_of_grouppos);
      posvecs = vector_get(list_of_grouppos, 0);

      for (i = 0; i < len; i++)
      {
        if (config->verbosity > 0)
          logf_info("Processing group %d", i);

        err = process_group(&pngloader,
                            posvecs[i],
                            config->tilesize,
                            config->verbosity,
                            i,
                            &makemap);
        if (err)
          goto failure;
      }
    }

    assert(makemap.ngroups == groups.ntokens);
    assert(makemap.ngroups == vector_length(list_of_grouppos));

    // output :-
    // - game map
    // - map group ranges
    // - supertiles
    // - tilesets

    err = dump_map(&makemap, config->verbosity);
    if (err)
      goto failure;

    // dump group ranges

    // dump supertiles
    for (i = 0; i < makemap.ngroups; i++)
    {
      err = dump_supertiles(makemap.tilesort[i],
                            makemap.bigtiles[i]->used,
                            tilesize / 8, // fix
                            config->verbosity);
      if (err)
        goto failure;
    }

    // dump tilesets
    for (i = 0; i < makemap.ngroups; i++)
    {
      err = dump_tiles(makemap.smalltiles[i], config->verbosity);
      if (err)
        goto failure;
    }

    makemap_dealloc(&makemap);
  }
  
  if (config->verbosity > 0)
    logf_info("(done)");
  
  return result_OK;
  
  
failure:
  
  return err;
}

// vim: ts=8 sw=2 sts=2 et
