@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import "utils/Framerate.j"
@import "demos/camera/SphereView.j"
@import "demos/pointLight/LightingView.j"

@implementation AppController : CPObject {
	CPLabel _label;
	GLView _view;
	Framerate _framerate;
    int _speed;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {

	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
	[contentView setBackgroundColor:[CPColor colorWithHexString:@"EEEEEE"]];

	// Create GL View
	_view = [[LightingView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	[_view setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[_view setCenter:[contentView center]];
	[contentView addSubview:_view];
	
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
    _speed = 25;
	[CPTimer scheduledTimerWithTimeInterval:1/_speed target:self selector:@selector(run) userInfo:nil repeats:NO]; 

	[theWindow orderFront:self];
	
	app = self;
}

- (void)run {
	// update framerate
	[_framerate tick];
	[_view setNeedsDisplay:YES];
	[CPTimer scheduledTimerWithTimeInterval:1/_speed target:self selector:@selector(run) userInfo:nil repeats:NO]; 
}

- (void)slow { _speed = 2;  }
- (void)fast { _speed = 25; }

- (void)fps {
	[_label setStringValue:@"fps: " + [_framerate fps]];
	[_label sizeToFit];
}

@end
