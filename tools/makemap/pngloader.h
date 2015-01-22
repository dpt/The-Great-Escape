/* pngloader.h */

#ifndef PNGLOADER_H
#define PNGLOADER_H

#include <stddef.h>

#include <png.h>

#include "base/result.h"

typedef struct pngloader
{
  png_structp png_ptr;
  png_infop   info_ptr;
  int         width, height;
  png_byte    color_type;
  png_byte    bit_depth;
  int         number_of_passes;
  png_size_t  rowbytes;
  png_bytep  *row_pointers;
  png_byte   *bitmap;
}
pngloader_t;

result_t read_png_file(pngloader_t *png,
                       const char  *file_name,
                       int          verbosity);

#endif /* PNGLOADER_H */

// vim: ts=8 sw=2 sts=2 et
