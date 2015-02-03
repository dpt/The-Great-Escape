/* config.h -- the program's configuration */

#ifndef CONFIG_H
#define CONFIG_H

typedef struct config
{
  const char *program_name;
  int         verbosity;    /* 0 => quiet, 1 => chatty, 2+ => noisy */
  int         tilesize;     /* e.g 32 */
  const char *groups_file;  /* filename of groups file */
  const char *image_file;   /* filename of input image */
}
config_t;

#endif /* CONFIG_H */

// vim: ts=8 sw=2 sts=2 et
