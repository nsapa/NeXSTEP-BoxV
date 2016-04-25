/* CONFIDENTIAL
 * Copyright (c) 1993-1996 by NeXT Software, Inc. as an unpublished work.
 * All rights reserved.
 *
 * BoxVModes.h -- internal definitions for the BoxV driver.
 *
 */

#ifndef BOXVMODES_H__
#define BOXVMODES_H__

#import <driverkit/displayDefs.h>
#import <driverkit/i386/ioPorts.h>

#define ONE_MEGABYTE    (1 << 20)
#define TWO_MEGABYTES   (2 << 20)
#define THREE_MEGABYTES (3 << 20)
#define FOUR_MEGABYTES  (4 << 20)

typedef struct BoxVMode {
    const char *name;		/* The name of this mode. */
    unsigned long memSize;	/* The memory necessary for this mode. */
    int mode_no;                /* The BoxV mode number. */
} BoxVMode;

/* A RGB entry in the BoxV format. */
typedef struct BoxVColor {
    unsigned char   red;
    unsigned char   green;
    unsigned char   blue;
    unsigned char   unused;
} BoxVColor;

/* A RGB entry in the DriverKit format. */
typedef struct KitColor {
    unsigned char   gray;
    unsigned char   blue;
    unsigned char   green;
    unsigned char   red;
} KitColor;

extern const IODisplayInfo ModeTable[];
extern const int ModeTableCount;
extern const int defaultMode;

#endif	/* BOXVMODES_H__ */
