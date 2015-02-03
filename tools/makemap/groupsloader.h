/* groupsloader.h -- load grouping information from a text file */

#ifndef GROUPSLOADER_H
#define GROUPSLOADER_H

#include <stddef.h>

#include "base/result.h"
#include "datastruct/vector.h"

/* Groups are the supertile locations in the input which should be bunched
 * together. */
typedef struct groups
{
  int       width, height;
  char      tokens[10];    /* if this holds "ABC" then "A", "B" and "C" are 0, 1 and 2 respectively */
  int       ntokens;       /* == max group index */
  vector_t *groups;        /* one byte per tile */
}
groups_t;

result_t parse_groups_from_file(groups_t   *groups,
                                const char *filename);

result_t parse_groups_from_mem(groups_t            *groups,
                               const unsigned char *start,
                               size_t               length);

#endif /* GROUPSLOADER_H */

// vim: ts=8 sw=2 sts=2 et
