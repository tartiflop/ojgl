@import <Foundation/CPObject.j>

@implementation GLShadersLoader : CPObject {
	id _target;
	SEL _onComplete;
	
	CPString _vertexShader;
	CPString _fragmentShader;
	
	CPURLConnection _vertexShaderConnection;
	CPURLConnection _fragmentShaderConnection;
	
}

- (id)initWithShader:(CPString)vertexShaderURL fragmentShaderURL:(CPString)fragmentShaderURL target:(id)target onComplete:(SEL)onComplete {
	self = [super init];
	
	if (self) {
		_target = target;
		_onComplete = onComplete;
		
		// Get vertex shader
		var vertexShaderRequest = [CPURLRequest requestWithURL:vertexShaderURL];
		_vertexShaderConnection = [CPURLConnection connectionWithRequest:vertexShaderRequest delegate:self];	
		
		// Get fragment shader
		var fragmentShaderRequest = [CPURLRequest requestWithURL:fragmentShaderURL];
		_fragmentShaderConnection = [CPURLConnection connectionWithRequest:fragmentShaderRequest delegate:self];	
	}
	
	return self;
}

- (CPString)vertexShader {
	return _vertexShader;
}

- (CPString)fragmentShader {
	return _fragmentShader;
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data {
	if (connection == _vertexShaderConnection) {
		// Verify that the data is not empty: could be that the file has not been found
		if (data == "") {
			CPLog.error("Vertex shader is empty");
			return;
		} 
		
		CPLog.info("got vertex shader");
		_vertexShader = data;

	} else if (connection == _fragmentShaderConnection) {
		if (data == "") {
			// Verify that the data is not empty: could be that the file has not been found
			CPLog.error("Fragment shader is empty");
			return;
		} 
		
		CPLog.info("got fragment shader");
		_fragmentShader = data;
	}
	
	// If both vertex and fragment shaders have been successfully loaded then call selector
	if (_vertexShader && _fragmentShader) {
		objj_msgSend(_target, _onComplete);
	}
}

- (void)connection:(CPURLConnection)connection didFailWithError:(CPString)error {
	if (connection == _vertexShaderConnection) {
		CPLog.error("Failed to get vertex shader");

	} else if (connection == _fragmentShaderConnection) {
		CPLog.error("Failed to get fragment shader");
	} 
}

@end
