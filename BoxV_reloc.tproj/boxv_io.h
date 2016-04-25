#import <driverkit/i386/ioPorts.h>

/* Local definition - no ISO C headers included. */
#define NULL    0

/* In this case, vid_in/out cannot be defined as macros because NT uses
 * a pretty funky interface for I/O port access.
 */

static void vid_outb( void *cx, unsigned port, unsigned val )
{
    outb( port, val );
}

static void vid_outw( void *cx, unsigned port, unsigned val )
{
    outw( port, val );
}

static unsigned vid_inb( void *cx, unsigned port )
{
    return( inw( port ) );
}

static unsigned vid_inw( void *cx, unsigned port )
{
    return( inw( port ) );
}
