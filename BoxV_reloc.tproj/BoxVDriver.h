/*
 * Copyright (c) 1993-1996 Michal Necasek.
 * All rights reserved.
 *
 * BoxVDriver.h -- interface for the VirtualBox SVGA display driver.
 *
 */

#ifndef BOXVDRIVER_H__
#define BOXVDRIVER_H__

#import <driverkit/IOFrameBufferDisplay.h>
#import "BoxVModes.h"

@interface BoxV:IOFrameBufferDisplay
{
    /* The memory installed on this device. */
    vm_size_t availableMemory;

    /* The table of valid modes for this device. */
    const IODisplayInfo *modeTable;

    /* The count of valid modes for this device. */
    unsigned int modeTableCount;

    /* The physical address of framebuffer. */
    unsigned long videoRamAddress;

    /* The transfer table for this mode. */
    BoxVColor *transferTable;

    /* The number of entries in the transfer table. */
    int transferTableCount;

    /* The current screen brightness. */
    int brightnessLevel;
}
- (void)enterLinearMode;
- (void)revertToVGAMode;
- initFromDeviceDescription: deviceDescription;
- setBrightness:(int)level token:(int)t;
@end

@interface BoxV (SetMode)
- determineConfiguration;
- selectMode;
- initializeMode;
- enableLinearFrameBuffer;
- resetVGA;
- programDAC;
@end

#endif	/* BOXVDRIVER_H__ */
