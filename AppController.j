
@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import "OJGL/GLView.j"
@import "OJGL/GLProgram.j"
@import "OJGL/GLMatrix.j"
@import "primitives/Sphere.j"
@import "utils/Framerate.j"


@implementation AppController : CPObject {
	CPLabel _label;
	GLContext _glContext;

	Sphere _sphere;
	Framerate _framerate;
	
	int _vertexBufferIndex;
	int _colorBufferIndex;
	int _indicesBufferIndex;
	
	int _vertexAttributeIndex;
	int _colorAttributeIndex;
	int _matrixUniformIndex;
	
	float _angle;
	
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {
	
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
							contentView = [theWindow contentView];
	[contentView setBackgroundColor:[CPColor colorWithHexString:@"F4F7E1"]];
	
	// Create GL View
	var glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
	[glView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[glView setCenter:[contentView center]];
	[contentView addSubview:glView];

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

	// Prepare OpenGL scene
	[self prepare:glView];

	// Render once
	[self draw];

	[theWindow orderFront:self];

	// Timer to redraw
	var timer = [CPTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(run) userInfo:nil repeats:YES]; 
	var timer = [CPTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fps) userInfo:nil repeats:YES]; 
}


- (void)prepare:(GLView)glView {

	// Get the OpenGL Context
	_glContext = [glView glContext];
	
	// Prepare (initialise) context
	[_glContext prepare:[0.2, 0.2, 0.2, 1] clearDepth:1.0];

	// Create a new program
	var glProgram = [_glContext createProgram];
	
	// Add shaders to program and link
	[glProgram addShaderScript:"vertexshader"];
	[glProgram addShaderScript:"fragmentshader"];
	[glProgram linkProgram];
   
	// Get attribute indices
	_vertexAttributeIndex = [glProgram getAttributeLocation:"aVertex"];
	_colorAttributeIndex = [glProgram getAttributeLocation:"aColor"];
	_matrixUniformIndex = [glProgram getUniformLocation:"mvMatrix"];
	var perspectiveUniformIndex = [glProgram getUniformLocation:"pMatrix"];
	
	// Set program to be used
	[_glContext useProgram:glProgram];
	
	// Create a whopper sphere
//	var _sphere = [[Sphere alloc] initWithGeometry:1.5 longs:300 lats:300];

	// Create a modest sphere
	var _sphere = [[Sphere alloc] initWithGeometry:1.5 longs:50 lats:50];
	
	// Create and initialise buffer data
	_vertexBufferIndex = [_glContext createBufferFromArray:[_sphere geometryData]];
	_colorBufferIndex = [_glContext createBufferFromArray:[_sphere colorData]];
	_indicesBufferIndex = [_glContext createBufferFromElementArray:[_sphere indexData]];
	
	// reshape 
	[_glContext reshape:[glView width] height:[glView height]];

	// Set up camera position and perspective
	var perspectiveMatrix = [[GLMatrix alloc] initWithLookat:0 eyey:3 eyez:-2 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	[perspectiveMatrix perspective:60 aspect:[glView width]/[glView height] zNear:1 zFar:10000];
	[_glContext setUniformMatrix:perspectiveUniformIndex matrix:perspectiveMatrix];
}

- (void)draw {
	var mvMatrix = [[GLMatrix alloc] initWithRotation:_angle x:0 y:1 z:0];

	// Clear context
	[_glContext clearBuffer];
	
	// Set rotation matrix
	[_glContext setUniformMatrix:_matrixUniformIndex matrix:mvMatrix];

	// Bind buffers to attributes
	[_glContext bindBufferToAttribute:_vertexBufferIndex attributeIndex:_vertexAttributeIndex size:3];
	[_glContext bindBufferToAttribute:_colorBufferIndex attributeIndex:_colorAttributeIndex size:4];
	
	// Bind element index buffer
	[_glContext bindElementBuffer:_indicesBufferIndex];
 
	// redraw
	[_glContext drawElements:[_sphere numberOfElements]];
}

- (void)run {

	// recalculate rotation matrix
	_angle = _angle + 2;
 
	[self draw];

	// update framerate
	[_framerate tick];
}
- (void)fps {
	[_label setStringValue:@"fps : " + [_framerate fps]];
	[_label sizeToFit];
}

@end
