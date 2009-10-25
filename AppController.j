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
	[contentView setBackgroundColor:[CPColor colorWithHexString:@"F4F7E1"]];
	
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
	[_label sizeToFit];
	[_label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[contentView addSubview:_label];

	// Framerate
	_framerate = [[Framerate alloc] init];
	// Add timer for fps label update
	var timer = [CPTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fps) userInfo:nil repeats:YES]; 

	// Timer to redraw
	var timer = [CPTimer scheduledTimerWithTimeInterval:1/25 target:self selector:@selector(run) userInfo:nil repeats:NO]; 
	
	[theWindow orderFront:self];
}

- (void)run {
	// update framerate
	[_framerate tick];
//	[self draw];
	[_sphereView setNeedsDisplay:YES];
	// Timer to redraw
	var timer = [CPTimer scheduledTimerWithTimeInterval:1/100 target:self selector:@selector(run) userInfo:nil repeats:NO]; 
}

- (void)fps {
	[_label setStringValue:@"fps : " + [_framerate fps]];
	[_label sizeToFit];
}

@end
