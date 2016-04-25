/*
 * Copyright (c) 2011 Michal Necasek.
 * All rights reserved.
 *
 * BoxVModes.c -- Mode table for the VirtualBox SVGA driver.
 *
 */
#import "BoxVModes.h"

/* Table of supported modes. */

/* 800x600x16 (BoxV mode 0x114). */
static const BoxVMode BoxV_800x600x16 = {
    "[800x600x16]", TWO_MEGABYTES, 0x114
};

/* 800x600x24 (BoxV mode 0x12E). */
static const BoxVMode BoxV_800x600x32 = {
    "[800x600x32]", THREE_MEGABYTES, 0x12E
};

/* 1024x768x8 (BoxV mode 0x105). */
static const BoxVMode BoxV_1024x768x8 = {
    "[1024x768x8]", ONE_MEGABYTE, 0x105
};

/* 1024x768x16 (BoxV mode 0x117). */
static const BoxVMode BoxV_1024x768x16 = {
    "[1024x768x16]", TWO_MEGABYTES, 0x117
};

/* 1024x768x32 (BoxV mode 0x138). */
static const BoxVMode BoxV_1024x768x32 = {
    "[1024x768x32]", THREE_MEGABYTES, 0x138
};

/* 1280x1024x8 (BoxV mode 0x107). */
static const BoxVMode BoxV_1280x1024x8 = {
    "[1280x1024x8]", TWO_MEGABYTES, 0x107
};

/* 1280x1024x15 (BoxV mode 0x21A). */
static const BoxVMode BoxV_1280x1024x16 = {
    "[1280x1024x16]", FOUR_MEGABYTES, 0
};

const IODisplayInfo ModeTable[] = {
    {
	/* 800x600x16 */
	800, 600, 800, 1600, 60, 0, IO_15BitsPerPixel, 
	IO_RGBColorSpace, "RRRRRGGGGGGBBBBB", 0, (void *)&BoxV_800x600x16,
    },
    {
	/* 800x600x32 */
	800, 600, 800, 3200, 60, 0, IO_24BitsPerPixel, 
	IO_RGBColorSpace, "--------RRRRRRRRGGGGGGGGBBBBBBBB",
	0, (void *)&BoxV_800x600x32,
    },
    {
	/* 1024x768x8 RGB */
	1024, 768, 1024, 1024, 60, 0, IO_8BitsPerPixel,
	IO_RGBColorSpace, "PPPPPPPP", 0, (void *)&BoxV_1024x768x8,
    },
    {
	/* 1024x768x8 Grayscale */
	1024, 768, 1024, 1024, 60, 0, IO_8BitsPerPixel,
	IO_OneIsWhiteColorSpace, "WWWWWWWW", 0, (void *)&BoxV_1024x768x8,
    },
    {
	/* 1024x768x16 */
	1024, 768, 1024, 2048, 60, 0, IO_15BitsPerPixel,
	IO_RGBColorSpace, "RRRRRGGGGGGBBBBB", 0, (void *)&BoxV_1024x768x16,
    },
    {
	/* 1024x768x32 */
	1024, 768, 1024, 4096, 60, 0, IO_24BitsPerPixel,
	IO_RGBColorSpace, "--------RRRRRRRRGGGGGGGGBBBBBBBB",
	0, (void *)&BoxV_1024x768x32,
    },
    {
	/* 1280x1024x8 Grayscale */
	1280, 1024, 1280, 1280, 60, 0, IO_8BitsPerPixel,
	IO_OneIsWhiteColorSpace, "WWWWWWWW", 0, (void *)&BoxV_1280x1024x8,
    },
    {
	/* 1280x1024x8 RGB */
	1280, 1024, 1280, 1280, 60, 0, IO_8BitsPerPixel,
	IO_RGBColorSpace, "PPPPPPPP", 0, (void *)&BoxV_1280x1024x8,
    },
    {
	/* 1280x1024x16 */
	1280, 1024, 1280, 2560, 60, 0, IO_15BitsPerPixel,
	IO_RGBColorSpace, "-RRRRRGGGGGBBBBB", 0, (void *)&BoxV_1280x1024x16,
    },
};

const int ModeTableCount =
	(sizeof(ModeTable) / sizeof(ModeTable[0]));

const int defaultMode = 2;
