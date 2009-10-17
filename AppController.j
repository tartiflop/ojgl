
@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import "OJGL/GLView.j"
@import "OJGL/GLProgram.j"
@import "OJGL/GLMatrix.j"


@implementation AppController : CPObject {
	GLContext _glContext;

	int _vertexBufferIndex;
	int _colorBufferIndex;
	int _vertexAttributeIndex;
	int _colorAttributeIndex;
	int _matrixUniformIndex;
	
	float _angle;
	
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {
	
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
							contentView = [theWindow contentView];

	[contentView setBackgroundColor:[CPColor shadowColor]];
	
	// Create GL View
	var glView = [[GLView alloc] initWithFrame:CGRectMake(200, 200, 480, 320)];
	[contentView addSubview:glView];

	[glView setBackgroundColor:[CPColor blueColor]];
	[glView setAutoresizingMask: CPViewMinXMargin | CPViewMinYMargin | CPViewMaxXMargin | CPViewMaxYMargin];
	
	// Get the OpenGL Context
	_glContext = [glView glContext];
	
	// Prepare (initialise) context
	[_glContext prepare:[0.15, 0.15, 0.15, 1] clearDepth:1.0];

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
	
	// Define vertex and color data 
	var vertexArray = [   0.0,  0.5,  0,
	                     -0.5, -0.5,  0,
	                      0.5, -0.5,  0  ];
	
	var vertexArray2 = [   0.0,  0.5,  0.0,
		                      0.0, -0.5, -0.5,
		                      0.0, -0.5,  0.5  ];

	var vertexArray3 = [   0.0, 0.0,  0.5,
	                      -0.5, 0.0, -0.5,
	                       0.5, 0.0, -0.5  ];

	var colorArray = [  1.0, 0.0, 0.0, 1.0,
	                    0.0, 1.0, 0.0, 1.0,
	                    0.0, 0.0, 1.0, 1.0];

	// Create and initialise buffer data
	_vertexBufferIndex = [_glContext createBufferFromArray:vertexArray];
	_colorBufferIndex = [_glContext createBufferFromArray:colorArray];
	
	// Set program to be used
	[_glContext useProgram:glProgram];
	
	[theWindow orderFront:self];

	[_glContext reshape:[glView width] height:[glView height]];

	var perspectiveMatrix = [[GLMatrix alloc] initWithLookat:0 eyey:1 eyez:-2 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	
	[perspectiveMatrix perspective:60 aspect:[glView width]/[glView height] zNear:1 zFar:10000];
    
	[_glContext setUniformMatrix:[glProgram getUniformLocation:"pMatrix"] matrix:perspectiveMatrix];

	[self draw];

	// Timer to redraw
	var timer = [CPTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(run) userInfo:nil repeats:YES]; 
}

- (void)run {

	// recalculate rotation matrix
	_angle = _angle + 4;
 
	[self draw];
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
 
	// redraw
	[_glContext draw];
	
}

@end