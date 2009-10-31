@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import "utils/Framerate.j"
@import "SphereView.j"

@implementation AppController : CPObject {
	CPLabel _label;
	SphereView _sphereView;
	Framerate _framerate;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {

	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
	
	// Create GL View
	_sphereView = [[SphereView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	[_sphereView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[_sphereView setCenter:[contentView center]];
	[contentView addSubview:_sphereView];
	
	// FPS label
	_label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[_label setAlignment:CPCenterTextAlignment]; 
	[_label setStringValue:@"fps: "];
	[_label setFont:[CPFont boldSystemFontOfSize:16.0]];
    [_label setBackgroundColor:[CPColor colorWithHexString:@"FF0000"]];
	[_label sizeToFit];
//	[_label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[contentView addSubview:_label];

	// Framerate
	_framerate = [[Framerate alloc] init];

	// Add timer for fps label update
	[CPTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fps) userInfo:nil repeats:YES]; 
	// Timer to redraw
	[CPTimer scheduledTimerWithTimeInterval:1/2 target:self selector:@selector(run) userInfo:nil repeats:NO]; 

	[theWindow orderFront:self];
app = self;
}

- (void)run {
	// update framerate
	[_framerate tick];
	[_sphereView setNeedsDisplay:YES];
	[CPTimer scheduledTimerWithTimeInterval:1/2 target:self selector:@selector(run) userInfo:nil repeats:NO]; 
}

- (void)fps {
	[_label setStringValue:@"fps: " + [_framerate fps]];
	[_label sizeToFit];
}

@end
