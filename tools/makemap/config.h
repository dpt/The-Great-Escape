/* config.h -- the program's configuration */

#ifndef CONFIG_H
#define CONFIG_H

typedef struct config
{
  const char *program_name;
  int         verbosity;
  int         tilesize;
  const char *groups_file;
  const char *image_file;
}
config_t;

#endif /* CONFIG_H */

// vim: ts=8 sw=2 sts=2 et
