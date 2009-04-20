#import "BurnDeck.h"
#import <DiscRecording/DiscRecording.h>
#import <DiscRecordingUI/DiscRecordingUI.h>

@implementation BurnDeck

+ (void)load {
	printf("+[BurnDeck load]\n");
}

+ (void)initialize {
	printf("+[BurnDeck initialize]\n");
	[[NSNotificationCenter defaultCenter] addObserver:[[BurnDeck alloc] init]
											 selector:@selector(appDidFinishLaunching:)
												 name:NSApplicationDidFinishLaunchingNotification
											   object:nil];
}

- (void)appDidFinishLaunching:(NSNotification*)notification_ {
	printf("-[BurnDeck appDidFinishLaunching:]\n");
    
    NSMenu *fileMenu = [[[NSApp mainMenu] itemAtIndex:1] submenu];
    NSAssert(fileMenu, @"Couldn't get File menu");
    
    NSMenuItem *burnTapeMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Burn Tape to CD..."
                                                               action:@selector(burnTapeAction:)
                                                        keyEquivalent:@"r"] autorelease];
    [burnTapeMenuItem setTarget:self];
    [fileMenu addItem:burnTapeMenuItem];
}

- (IBAction)burnTapeAction:(id)sender {
	printf("+[BurnDeck burnTapeAction:]\n");
    
    NSString *selectedTapePath = [NSApp valueForKeyPath:@"delegate.windowController.selectedTape.filename"];
    if ([selectedTapePath hasPrefix:@"/Users/"]) { // simple sanity checking
        DRTrack *track = [DRTrack trackForAudioFile:selectedTapePath];
        DRBurnSetupPanel *burnSetupPanel = [DRBurnSetupPanel setupPanel];
        if ([burnSetupPanel runSetupPanel] == NSOKButton) {
            DRBurnProgressPanel *burnProgressPanel = [DRBurnProgressPanel progressPanel];
            [burnProgressPanel beginProgressPanelForBurn:[burnSetupPanel burnObject] layout:track];
        }
    } else {
        NSAssert1(NO, @"selectedTapePath doesn't begin with /Users/: %@", selectedTapePath);
    }
}

@end
