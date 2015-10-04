/* main.c -- map compressor for The Great Escape */

/* The map compressor reads in a bilevel (black and white) PNG image and
 * breaks it down into sets of tiles suitable for The Great Escape to use. */

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

static void syntax(const char *program_name)
{
  // TODO
  //
  // -o FILE   specify output file [default: somefile]

  printf("Usage: %s [OPTION]... FILENAME.png\n"
         "\n"
         "Convert a PNG image into The Great Escape map data.\n"
         "\n"
         "Options:\n"
         "  -tilesize N   set super tile size (default: 32)\n"
         "  -groups FILE  load tile groups from FILE\n"
         "  -verbose      be verbose\n"
         "  -quiet        be quiet\n"
         "\n",
         program_name);
  exit(EXIT_FAILURE);
}

/* Parse the command line arguments. */
static result_t parse_args(config_t *config, int argc, char *argv[])
{
  /* set defaults */
  config->program_name = argv[0];
  config->verbosity    = 1;
  config->tilesize     = 32;
  config->groups_file  = NULL;
  config->image_file   = NULL;

  /* skip program name */
  ++argv, --argc;

  if (argc >= 1)
  {
    do
    {
      if (argv[0][0] == '-')
      {
        /* parse options */
        if (strcmp(argv[0], "-tilesize") == 0)
        {
          ++argv, --argc;

          if (argc == 0)
            syntax(config->program_name); // no arg given
          
          config->tilesize = atoi(argv[0]);

          if (config->tilesize == 0)
            syntax(config->program_name); // validate (poorly)
        }
        else if (strcmp(argv[0], "-groups") == 0)
        {
          ++argv, --argc;

          if (argc == 0)
            syntax(config->program_name); // no filename given

          config->groups_file = argv[0];
        }
        else if (strcmp(argv[0], "-verbose") == 0)
        {
          config->verbosity++;
        }
        else if (strcmp(argv[0], "-quiet") == 0)
        {
          if (config->verbosity > 0)
            config->verbosity--;
        }
        else
        {
          /* unknown option */
          syntax(config->program_name);
        }
      }
      else
      {
        /* start of filename(s) */
        break;
      }
    }
    while (++argv, --argc);
  }

  if (argc != 1)
    syntax(config->program_name);

  config->image_file = argv[0];

  return result_OK;
}

int main(int argc, char *argv[])
{
  result_t err;
  config_t config;

  err = parse_args(&config, argc, argv);
  if (err)
    goto failure;
  
  err = make_maps(&config);
  if (err)
    goto failure;

  exit(EXIT_SUCCESS);


failure:

  logf_error("Error %d", err);

  exit(EXIT_FAILURE);
}

// vim: ts=8 sw=2 sts=2 et
