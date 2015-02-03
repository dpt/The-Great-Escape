/* pngloader.c -- load PNG images */

#include <stdlib.h>

#define PNG_DEBUG 3
#include <png.h>

#include "base/debug.h"
#include "base/result.h"

#include "pngloader.h"

/* PNG loading code taken from:
 *
 * Copyright 2002-2010 Guillaume Cottenceau.
 *
 * This software may be freely redistributed under the terms
 * of the X11 license.
 */

result_t read_png_file(pngloader_t *png,
                       const char  *file_name,
                       int          verbosity)
{
  result_t  err = result_OK;
  FILE     *fp;
  png_byte  header[8]; /* 8 is the maximum size that can be checked */
  int       y;

  /* open file and test for it being a png */
  fp = fopen(file_name, "rb");
  if (!fp)
    haltf("[read_png_file] File %s could not be opened for reading",
          file_name);

  fread(header, 1, 8, fp);
  if (png_sig_cmp(header, 0, 8))
    haltf("[read_png_file] File %s is not recognized as a PNG file",
          file_name);

  /* initialize stuff */
  png->png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING,
                                        NULL, NULL, NULL);
  if (!png->png_ptr)
    haltf("[read_png_file] png_create_read_struct failed");

  png->info_ptr = png_create_info_struct(png->png_ptr);
  if (!png->info_ptr)
    haltf("[read_png_file] png_create_info_struct failed");

  if (setjmp(png_jmpbuf(png->png_ptr)))
    haltf("[read_png_file] Error during init_io");

  png_init_io(png->png_ptr, fp);
  png_set_sig_bytes(png->png_ptr, 8);

  png_read_info(png->png_ptr, png->info_ptr);

  /* not using png_get_IHDR due to type differences */
  png->width      = png_get_image_width(png->png_ptr, png->info_ptr);
  png->height     = png_get_image_height(png->png_ptr,png->info_ptr);
  png->color_type = png_get_color_type(png->png_ptr, png->info_ptr);
  png->bit_depth  = png_get_bit_depth(png->png_ptr, png->info_ptr);

  if (verbosity > 0)
    logf_info("%d x %d, depth %d, color_type %d",
              png->width,
              png->height,
              png->bit_depth,
              png->color_type);

  png->number_of_passes = png_set_interlace_handling(png->png_ptr);
  png_read_update_info(png->png_ptr, png->info_ptr);

  /* read file */
  if (setjmp(png_jmpbuf(png->png_ptr)))
    haltf("[read_png_file] Error during read_image");

  png->rowbytes = png_get_rowbytes(png->png_ptr, png->info_ptr);

  if (verbosity > 0)
    logf_info("rowbytes=%zu", png->rowbytes);

  png->row_pointers = malloc(sizeof(png_bytep) * png->height);
  png->bitmap       = malloc(png->rowbytes * png->height);
  if (png->row_pointers == NULL || png->bitmap == NULL)
  {
    free(png->row_pointers);
    free(png->bitmap);
    err = result_OOM;
    goto exit;
  }

  for (y = 0; y < png->height; y++)
    png->row_pointers[y] = png->bitmap + y * png->rowbytes;

  png_read_image(png->png_ptr, png->row_pointers);

  fclose(fp);
  
exit:
  return err;
}

// vim: ts=8 sw=2 sts=2 et
