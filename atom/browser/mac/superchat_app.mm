#import "atom/browser/mac/superchat_app.h"

@implementation SuperchatApp {

}

- (void)sendEvent:(NSEvent *)event
{
    if (event.type == NSEventTypeKeyDown && event.keyCode == 49) {
        // Skipping space bar handling
        NSWindow* nextWindow = event.window;
        [nextWindow sendEvent:event];
    } else {
        [super sendEvent:event];
    }
}

@end
