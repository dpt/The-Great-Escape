/* groupsloader.c */

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
#include "datastruct/bitvec.h"
#include "datastruct/vector.h"
#include "io/stream.h"
#include "io/stream-mem.h"
#include "io/stream-stdio.h"
#include "utils/array.h"
#include "utils/minmax.h"

#include "groupsloader.h"

static result_t parse_groups(groups_t *groups, stream_t *stream)
{
  typedef enum
  {
    Header,
    BodyStart,
    Body
  }
  state_t;

  result_t       err;
  vector_t      *groupsvec = NULL;
  unsigned char  buf[100];
  const unsigned char *const bufend = buf + sizeof(buf);
  unsigned char *bufp;
  state_t        state;
  unsigned char  tok2idx[256];
  int            i;
  int            width, height;

  groupsvec = vector_create(1);
  if (groupsvec == NULL)
  {
    err = result_OOM;
    goto failure;
  }

  bufp = buf;

  state = Header;

  for (;;)
  {
    int c;

    c = stream_getc(stream);
    if (c == EOF)
      break;

    switch (c)
    {
      case '\n': /* Process the line. */
      {
        int count;

        count = (int) (bufp - buf);
        if (count == 0)
        {
          /* An empty line - ignore it. */
          /* Note that this will allow empty lines anywhere in the input. */
        }
        else
        {
          if (state == Header)
          {
            groups->ntokens = count;
            memcpy(groups->tokens, buf, count);

            /* Populate tok2idx with the index when at the token's position
             * and 255 when elsewhere. */

            // FIXME check the data for repeated characters (which would be ambiguous)
            memset(tok2idx, 255, sizeof(tok2idx));
            for (i = 0; i < count; i++)
              tok2idx[buf[i]] = i;

            state = BodyStart;
          }
          else
          {
            if (state == BodyStart)
            {
              width  = count;
              height = 0;

              state = Body;
            }
            else if (count != width)
            {
              err = result_PARSE_ERROR;
              goto failure;
            }

            /* Replace characters with their token index. */
            for (i = 0; i < count; i++)
              buf[i] = tok2idx[buf[i]];

            err = vector_insert_many(groupsvec, buf, count);
            if (err)
              goto failure;

            height++;
          }

          bufp = buf;
        }
      }
        break;

      case '\r': /* Ignore */
        break;

      default: /* Accumulate in buffer. */
        if (bufp == bufend)
        {
          err = result_BUFFER_OVERFLOW;
          goto failure;
        }

        *bufp++ = c;
        break;
    }
  }

  if (state != Body)
    return result_PARSE_ERROR;

  groups->width  = width;
  groups->height = height;
  groups->groups = groupsvec;

  return result_OK;


failure:

  vector_destroy(groupsvec);

  return err;
}

result_t parse_groups_from_file(groups_t   *groups,
                                const char *filename)
{
  result_t  err;
  FILE     *f = NULL;
  stream_t *s = NULL;

  assert(groups);
  assert(filename);

  f = fopen("rb", filename);
  if (f == NULL)
  {
    err = result_FILE_NOT_FOUND;
    goto failure;
  }

  err = stream_stdio_create(f, 100 /* bufsz */, &s);
  if (err)
    goto failure;

  err = parse_groups(groups, s);
  if (err)
    goto failure;

  stream_destroy(s);
  s = NULL;

  return result_OK;


failure:

  stream_destroy(s);

  return err;
}

result_t parse_groups_from_mem(groups_t            *groups,
                               const unsigned char *start,
                               size_t               length)
{
  result_t  err;
  stream_t *s = NULL;

  assert(groups);
  assert(start);
  assert(length > 0);

  err = stream_mem_create(start, length, &s);
  if (err)
    goto failure;

  err = parse_groups(groups, s);
  if (err)
    goto failure;
  
  stream_destroy(s);
  s = NULL;
  
  return result_OK;
  
  
failure:
  
  stream_destroy(s);
  
  return err;
}
