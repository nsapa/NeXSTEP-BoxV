/* 
 * Copyright (c) 2011 Michal Necasek.
 * All rights reserved.
 *
 * BoxVDriver.m -- driver for VirtualBox SVGA graphics adapter
 *
 */
#import <driverkit/i386/IOEISADeviceDescription.h>
#import "BoxVDriver.h"

@implementation BoxV

/* Enable a linear framebuffer mode. This normally happens
 * when the window server initializes.
 */
- (void)enterLinearMode
{
    /* Set up the chip to use the selected mode. */
    [self initializeMode];

    /* Enter linear mode. */
    if ([self enableLinearFrameBuffer] == nil) {
	IOLog("%s: Failed to enter linear mode.\n", [self name]);
	return;
    }
}

/* Disable any advanced mode and get back to pure VGA compatible state. */
- (void)revertToVGAMode
{
    /* Disable extended mode. */
    [self resetVGA];

    /* Have the superclass actually set the appropriate mode. */
    [super revertToVGAMode];
}

/* Set the brightness to `level'. Only useful for 8bpp modes. */
- setBrightness:(int)level token:(int)t
{
    if (level < EV_SCREEN_MIN_BRIGHTNESS || level > EV_SCREEN_MAX_BRIGHTNESS) {
	IOLog("BoxV: Invalid brightness level `%d'.\n", level);
	return nil;
    }
    brightnessLevel = level;
    /* Adjust the previously set transfer table for the brightness. */
    [self programDAC];
    return self;
}

/* Set the transfer table (aka palette). */
- setTransferTable:(const unsigned int *)table count:(int)numEntries
{
    /* Store the transfer table. */
    if (transferTable != 0)
	IOFree(transferTable, transferTableCount * sizeof(unsigned int));

    transferTable = IOMalloc(numEntries * sizeof(unsigned int));
    transferTableCount = numEntries;
    memcpy(transferTable, table, numEntries * sizeof(unsigned int));

    /* Program the DAC. */
    [self programDAC];
    return self;
}

- initFromDeviceDescription:deviceDescription
{
    IODisplayInfo *displayInfo;
    const IORange *range;
    const BoxVMode *mode;

    if ([super initFromDeviceDescription:deviceDescription] == nil)
	return [super free];

    if ([self determineConfiguration] == nil)
	return [super free];

    if ([self selectMode] == nil)
	return [super free];

    range = [deviceDescription memoryRangeList];
    if (range == 0) {
	IOLog("%s: No memory range set.\n", [self name]);
	return [super free];
    }
    videoRamAddress = range[0].start;

    transferTable = 0;
    transferTableCount = 0;
    brightnessLevel = EV_SCREEN_MAX_BRIGHTNESS;

    displayInfo = [self displayInfo];
    mode = displayInfo->parameters;

    /* Set up display info flags. */
    displayInfo->flags = IO_DISPLAY_CACHE_WRITETHROUGH;
    if (displayInfo->bitsPerPixel == IO_15BitsPerPixel)
        displayInfo->flags |= IO_DISPLAY_NEEDS_SOFTWARE_GAMMA_CORRECTION;
    else if (displayInfo->bitsPerPixel == IO_8BitsPerPixel)
        displayInfo->flags |= IO_DISPLAY_HAS_TRANSFER_TABLE;

    displayInfo->frameBuffer =
        (void *)[self mapFrameBufferAtPhysicalAddress:videoRamAddress
	     length:mode->memSize];
    if (displayInfo->frameBuffer == 0)
	return [super free];

    IOLog("%s: Initialized `%s'@%d Hz.\n", [self name], mode->name, 
	  displayInfo->refreshRate);

    return self;
}
@end
