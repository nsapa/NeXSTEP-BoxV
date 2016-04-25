/* Copyright (c) 1993-1996 by NeXT Software, Inc.
 * All rights reserved.
 *
 * BoxVSetMode.m -- Mode support for the VirtualBox SVGA.
 *
 */
#import <string.h>
#import <driverkit/generalFuncs.h>
#import <driverkit/i386/ioPorts.h>
#import "BoxVDriver.h"
#import "boxv.h"

/* The `SetMode' category of `BoxV'. */

@implementation BoxV (SetMode)

- (void)reportConfiguration
{
    const char *memString;

    switch (availableMemory) {
    case FOUR_MEGABYTES: memString = "4 Mb VRAM"; break;
    case THREE_MEGABYTES: memString = "3 Mb VRAM"; break;
    case TWO_MEGABYTES: memString = "2 Mb VRAM"; break;
    case ONE_MEGABYTE: memString = "1 Mb VRAM"; break;
    case ONE_MEGABYTE/2: memString = "500 Kb VRAM"; break;
    default: memString = "(unknown memory size)"; break;
    }

    IOLog("%s: %s.\n", [self name], memString);
}

- determineConfiguration
{
    modeTable = ModeTable;
    modeTableCount = ModeTableCount;

    /* Get the bus and memory configuration. */
    availableMemory = FOUR_MEGABYTES;

    [self reportConfiguration];

    return self;
}

/* Select a display mode based on hardware configuration.
 * Return the selected mode, or -1 if no valid mode found.
 */
- selectMode
{
    int k, mode;
    const BoxVMode *modeData;
    BOOL valid[modeTableCount];

    for (k = 0; k < modeTableCount; k++) {
	modeData = modeTable[k].parameters;
	valid[k] = (modeData->memSize <= availableMemory);
    }

    mode = [self selectMode:modeTable count:modeTableCount valid:valid];
    if (mode < 0) {
	IOLog("%s: Sorry, cannot use requested display mode.\n", [self name]);
	mode = defaultMode;
    }
    *[self displayInfo] = modeTable[mode];
    return self;
}

- initializeMode
{
    const BoxVMode *mode;
    const IODisplayInfo *displayInfo;

    displayInfo = [self displayInfo];
    mode = displayInfo->parameters;

    BOXV_mode_set(0, mode->mode_no);	
    return self;
}

- enableLinearFrameBuffer
{
    const BoxVMode *mode;
    IODisplayInfo *displayInfo;

    displayInfo = [self displayInfo];
    mode = displayInfo->parameters;

    /* Clear the screen. */
    memset(displayInfo->frameBuffer, 0, mode->memSize);
    return self;
}

- resetVGA
{
    /* Disable the extended functionality. */
    BOXV_ext_disable(0);
    return self;
}

- programDAC
{
    int                 i;
    IOBitsPerPixel      bpp;
    IOColorSpace        cspace;
    unsigned char       val;
    const KitColor      *ktab;
    int                 level;
    BoxVColor           *palette;
    int                 entries;

    /* Check if there's anything to do at all. */
    bpp = [self displayInfo]->bitsPerPixel;
    cspace = [self displayInfo]->colorSpace;

    if (transferTable == 0 || bpp != IO_8BitsPerPixel)
        return self;

    /* The stored transfer table is in reverse byte order to what
     * we need, but it also needs to be scaled for brightness anyway.
     * We munge it here before passing it to hardware.
     */
    ktab = (const void *)transferTable;
    level = brightnessLevel;

    entries = transferTableCount;
    palette = IOMalloc(transferTableCount * sizeof(BoxVColor));

    if (cspace == IO_OneIsWhiteColorSpace) {
	for (i = 0; i < entries; i++) {
            val = EV_SCALE_BRIGHTNESS(level, ktab[i].gray);
	    palette[i].red = palette[i].green = palette[i].blue = val;
	}
    } else if (cspace == IO_RGBColorSpace) {
	for (i = 0; i < entries; i++) {
            palette[i].red   = EV_SCALE_BRIGHTNESS(level, ktab[i].red);
            palette[i].green = EV_SCALE_BRIGHTNESS(level, ktab[i].green);
            palette[i].blue  = EV_SCALE_BRIGHTNESS(level, ktab[i].blue);
	}
    } else {
	entries = 0;    /* Don't set anything. */
    }
    
    /* Program the hardware and free the munged table copy. */
    BOXV_dac_set(0, 0, entries, palette);
    IOFree(palette, transferTableCount * sizeof(BoxVColor));

    return self;
}

@end
