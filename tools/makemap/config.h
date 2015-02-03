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
