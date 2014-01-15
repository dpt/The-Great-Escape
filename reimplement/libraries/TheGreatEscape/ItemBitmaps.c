/**
 * $DDDD: Item bitmaps and masks.
 *
 * All are 16 pixels wide. Variable height.
 */

#include "TheGreatEscape/ItemBitmaps.h"

/* Possible future idea for encoding bitmap data in the source:
 *
 * #define ____ 0x0
 * #define ___X 0x1
 * #define __X_ 0x2
 * #define __XX 0x3
 * #define _X__ 0x4
 * #define _X_X 0x5
 * #define _XX_ 0x6
 * #define _XXX 0x7
 * #define X___ 0x8
 * #define X__X 0x9
 * #define X_X_ 0xA
 * #define X_XX 0xB
 * #define XX__ 0xC
 * #define XX_X 0xD
 * #define XXX_ 0xE
 * #define XXXX 0xF
 *
 * #define BM2(A,B,C,D) (A << 4) | B, (C << 4) | D
 *
 * Then we could encode the bitmap_shovel array above with:
 *
 * BM2(____,____,____,____), // 0000
 * BM2(____,____,____,__X_), // 0002
 * BM2(____,____,____,_X_X), // 0005
 * BM2(____,____,____,XXX_), // 000E
 * BM2(____,____,__XX,____), // 0030
 * BM2(____,____,XX__,____), // 00C0
 * BM2(__XX,__XX,____,____), // 3300
 * BM2(_XX_,XX__,____,____), // 6C00
 * BM2(XXX_,_XXX,____,____), // E700
 * BM2(XXXX,XX__,____,____), // FC00
 * BM2(____,____,____,____), // 0000
 * BM2(____,____,____,____), // 0000
 * BM2(____,____,____,____), // 0000
 *
 * And we could encode the mask_food array above with:
 *
 * BM2(XXXX,XXXX,X___,_XXX), // FF87
 * BM2(XXXX,XXXX,XX__,XXXX), // FFCF
 * BM2(XXXX,XXXX,X___,_XXX), // FF87
 * BM2(XXXX,___X,X___,_XXX), // F187
 * BM2(XXX_,____,____,__XX), // E003
 * BM2(XX__,____,____,__XX), // C003
 * BM2(XXX_,____,____,__XX), // E003
 * BM2(XX__,____,____,__XX), // C003
 * BM2(XX__,____,____,__XX), // C003
 * BM2(XX__,____,____,__XX), // C003
 * BM2(XX__,____,____,_XXX), // C007
 * BM2(XX__,____,____,__XX), // C003
 * BM2(XXX_,____,____,_XXX), // E007
 * BM2(XXXX,____,____,__XX), // F003
 * BM2(XXXX,X___,____,__XX), // F803
 * BM2(XXXX,XXX_,____,_XXX), // FE07
 */

const uint8_t bitmap_shovel[] =
{
  0x00, 0x00,
  0x00, 0x02,
  0x00, 0x05,
  0x00, 0x0E,
  0x00, 0x30,
  0x00, 0xC0,
  0x33, 0x00,
  0x6C, 0x00,
  0xE7, 0x00,
  0xFC, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
};

const uint8_t bitmap_key[] =
{
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x18,
  0x00, 0x64,
  0x00, 0x1C,
  0x00, 0x70,
  0x19, 0xC0,
  0x27, 0x00,
  0x32, 0x00,
  0x19, 0x00,
  0x07, 0x00,
  0x00, 0x00,
};

const uint8_t bitmap_lockpick[] =
{
  0x01, 0x80,
  0x00, 0xC0,
  0x03, 0x70,
  0x0C, 0x60,
  0x38, 0x40,
  0xE0, 0x00,
  0xC0, 0x00,
  0x03, 0x18,
  0x0C, 0xF0,
  0x30, 0xC0,
  0x23, 0x07,
  0x2C, 0x08,
  0x30, 0x38,
  0x00, 0xE6,
  0x03, 0xC4,
  0x03, 0x00,
};

const uint8_t bitmap_compass[] =
{
  0x00, 0x00,
  0x07, 0xE0,
  0x18, 0x18,
  0x24, 0x24,
  0x41, 0x02,
  0x41, 0x02,
  0x24, 0xA4,
  0x58, 0x9A,
  0x27, 0xE4,
  0x18, 0x18,
  0x07, 0xE0,
  0x00, 0x00,
};

const uint8_t bitmap_purse[] =
{
  0x00, 0x00,
  0x01, 0x80,
  0x07, 0x40,
  0x03, 0x80,
  0x01, 0x00,
  0x02, 0x80,
  0x05, 0x40,
  0x0D, 0xA0,
  0x0B, 0xE0,
  0x0F, 0xE0,
  0x07, 0xC0,
  0x00, 0x00,
};

const uint8_t bitmap_papers[] =
{
  0x00, 0x00,
  0x0C, 0x00,
  0x07, 0x00,
  0x06, 0xC0,
  0x02, 0xB0,
  0x33, 0x6C,
  0x6C, 0xD4,
  0x6B, 0x36,
  0xDA, 0xCE,
  0xD6, 0xF3,
  0x35, 0xEC,
  0x0D, 0xDC,
  0x03, 0xD0,
  0x00, 0x80,
  0x00, 0x00,
};

const uint8_t bitmap_wiresnips[] =
{
  0x00, 0x00,
  0x00, 0x18,
  0x00, 0x36,
  0x00, 0x60,
  0x03, 0xFB,
  0x0E, 0x6E,
  0x30, 0xE0,
  0xC1, 0x80,
  0x06, 0x00,
  0x18, 0x00,
  0x00, 0x00,
};

const uint8_t mask_shovelkey[] =
{
  0xFF, 0xFD,
  0xFF, 0xF8,
  0xFF, 0xE0,
  0xFF, 0x80,
  0xFF, 0x01,
  0xCC, 0x01,
  0x80, 0x03,
  0x00, 0x0F,
  0x00, 0x3F,
  0x00, 0xFF,
  0x00, 0x7F,
  0xE0, 0x7F,
  0xF8, 0xFF,
};

const uint8_t mask_lockpick[] =
{
  0xFC, 0x3F,
  0xFC, 0x0F,
  0xF0, 0x07,
  0xC0, 0x0F,
  0x03, 0x1F,
  0x07, 0xBF,
  0x1C, 0xE7,
  0x30, 0x03,
  0xC0, 0x07,
  0x80, 0x08,
  0x80, 0x30,
  0x80, 0xC0,
  0x83, 0x01,
  0xCC, 0x00,
  0xF8, 0x11,
  0xF8, 0x3B,
};

const uint8_t mask_compass[] =
{
  0xF8, 0x1F,
  0xE0, 0x07,
  0xC0, 0x03,
  0x80, 0x01,
  0x00, 0x00,
  0x00, 0x00,
  0x80, 0x01,
  0x00, 0x00,
  0x80, 0x01,
  0xC0, 0x03,
  0xE0, 0x07,
  0xF8, 0x1F,
};

const uint8_t mask_purse[] =
{
  0xFE, 0x7F,
  0xF8, 0x3F,
  0xF0, 0x1F,
  0xF8, 0x3F,
  0xFC, 0x3F,
  0xF8, 0x3F,
  0xF0, 0x1F,
  0xE0, 0x0F,
  0xE0, 0x0F,
  0xE0, 0x0F,
  0xF0, 0x1F,
  0xF8, 0x3F,
};

const uint8_t mask_papers[] =
{
  0xF3, 0xFF,
  0xE0, 0xFF,
  0xF0, 0x3F,
  0xF0, 0x0F,
  0xC8, 0x03,
  0x80, 0x01,
  0x00, 0x01,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0xC0, 0x01,
  0xF0, 0x03,
  0xFC, 0x2F,
  0xFF, 0x7F,
};

const uint8_t mask_wiresnips[] =
{
  0xFF, 0xE7,
  0xFF, 0xC1,
  0xFF, 0x80,
  0xFC, 0x00,
  0xF0, 0x00,
  0xC0, 0x00,
  0x00, 0x01,
  0x08, 0x1F,
  0x20, 0x7F,
  0xC1, 0xFF,
  0xE7, 0xFF,
};

const uint8_t bitmap_food[] =
{
  0x00, 0x30,
  0x00, 0x00,
  0x00, 0x30,
  0x00, 0x30,
  0x0E, 0x78,
  0x1F, 0xB8,
  0x07, 0x38,
  0x18, 0xB8,
  0x1E, 0x38,
  0x19, 0x98,
  0x17, 0xE0,
  0x19, 0xF8,
  0x06, 0x60,
  0x07, 0x98,
  0x01, 0xF8,
  0x00, 0x60,
};

const uint8_t bitmap_poison[] =
{
  0x00, 0x00,
  0x00, 0x80,
  0x00, 0x80,
  0x01, 0x40,
  0x01, 0xC0,
  0x00, 0x80,
  0x01, 0x40,
  0x03, 0xE0,
  0x06, 0x30,
  0x06, 0xB0,
  0x06, 0x30,
  0x06, 0xF0,
  0x06, 0xF0,
  0x07, 0xF0,
  0x05, 0xD0,
  0x03, 0xE0,
};

const uint8_t bitmap_torch[] =
{
  0x00, 0x00,
  0x00, 0x08,
  0x00, 0x3C,
  0x02, 0xFC,
  0x0D, 0x70,
  0x1E, 0xA0,
  0x1E, 0x80,
  0x16, 0x80,
  0x16, 0x80,
  0x16, 0x00,
  0x0C, 0x00,
  0x00, 0x00,
};

const uint8_t bitmap_uniform[] =
{
  0x01, 0xE0,
  0x07, 0xF0,
  0x0F, 0xF8,
  0x0F, 0xF8,
  0x1F, 0xFC,
  0x0F, 0xF3,
  0xF3, 0xCC,
  0x3C, 0x30,
  0x0F, 0xCF,
  0xF3, 0x3C,
  0x3C, 0xF0,
  0x0F, 0xCF,
  0xF3, 0x3C,
  0x3C, 0xF0,
  0x0F, 0xC0,
  0x03, 0x00,
};

const uint8_t bitmap_bribe[] =
{
  0x00, 0x00,
  0x00, 0x00,
  0x03, 0x00,
  0x0F, 0xC0,
  0x3F, 0x30,
  0x4C, 0xFC,
  0xF3, 0xF2,
  0x3C, 0xCF,
  0x0F, 0x3C,
  0x03, 0xF0,
  0x00, 0xC0,
  0x00, 0x00,
  0x00, 0x00,
};

const uint8_t bitmap_radio[] =
{
  0x00, 0x10,
  0x00, 0x10,
  0x38, 0x10,
  0xC6, 0x10,
  0x37, 0x90,
  0xCC, 0x50,
  0xF3, 0x50,
  0xCC, 0xEE,
  0xB7, 0x38,
  0xB6, 0xC6,
  0xCF, 0x36,
  0x3E, 0xD6,
  0x0F, 0x36,
  0x03, 0xD6,
  0x00, 0xF6,
  0x00, 0x35,
};

const uint8_t bitmap_parcel[] =
{
  0x00, 0x00,
  0x03, 0x00,
  0x0E, 0x40,
  0x39, 0xF0,
  0xE7, 0xE4,
  0x1F, 0x9F,
  0x8E, 0x7C,
  0xB1, 0xF3,
  0xB8, 0xCF,
  0xBB, 0x37,
  0xBB, 0x73,
  0xBB, 0x67,
  0xBB, 0x77,
  0x3B, 0x7C,
  0x0B, 0x70,
  0x03, 0x40,
};

const uint8_t mask_bribe[] =
{
  0xFC, 0xFF,
  0xF0, 0x3F,
  0xC0, 0x0F,
  0x80, 0x03,
  0x80, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0xC0, 0x00,
  0xF0, 0x00,
  0xFC, 0x00,
  0xFF, 0x03,
  0xFF, 0xCF,
};

const uint8_t mask_uniform[] =
{
  0xF8, 0x0F,
  0xF0, 0x07,
  0xE0, 0x03,
  0xE0, 0x03,
  0xC0, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x03,
  0xC0, 0x0F,
  0xF0, 0x3F,
};

const uint8_t mask_parcel[] =
{
  0xFC, 0xFF,
  0xF0, 0x3F,
  0xC0, 0x0F,
  0x00, 0x03,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0xC0, 0x03,
  0xF0, 0x0F,
};

const uint8_t mask_poison[] =
{
  0xFF, 0x7F,
  0xFE, 0x3F,
  0xFE, 0x3F,
  0xFC, 0x1F,
  0xFC, 0x1F,
  0xFE, 0x3F,
  0xFC, 0x1F,
  0xF8, 0x0F,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF0, 0x07,
  0xF8, 0x0F,
};

const uint8_t mask_torch[] =
{
  0xFF, 0xF7,
  0xFF, 0xC3,
  0xFD, 0x01,
  0xF0, 0x01,
  0xE0, 0x03,
  0xC0, 0x0F,
  0xC0, 0x1F,
  0xC0, 0x3F,
  0xC0, 0x3F,
  0xC0, 0x7F,
  0xE1, 0xFF,
  0xF3, 0xFF,
};

const uint8_t mask_radio[] =
{
  0xFF, 0xC7,
  0xC7, 0xC7,
  0x01, 0xC7,
  0x00, 0x47,
  0x00, 0x07,
  0x00, 0x07,
  0x00, 0x01,
  0x00, 0x00,
  0x00, 0x01,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0xC0, 0x00,
  0xF0, 0x00,
  0xFC, 0x00,
  0xFF, 0x01,
};

const uint8_t mask_food[] =
{
  0xFF, 0x87,
  0xFF, 0xCF,
  0xFF, 0x87,
  0xF1, 0x87,
  0xE0, 0x03,
  0xC0, 0x03,
  0xE0, 0x03,
  0xC0, 0x03,
  0xC0, 0x03,
  0xC0, 0x03,
  0xC0, 0x07,
  0xC0, 0x03,
  0xE0, 0x07,
  0xF0, 0x03,
  0xF8, 0x03,
  0xFE, 0x07,
};
