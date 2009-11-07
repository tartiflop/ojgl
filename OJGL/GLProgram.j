@import <Foundation/CPObject.j>

GL_VERTEX_SHADER = 0;
GL_FRAGMENT_SHADER = 1;

@implementation GLProgram : CPObject {

	DOMElement _gl;

	int _program;
	CPArray _shaders;
}

- (id)initWithGL:(DOMElement)gl {
	self = [super init];
	
	if (self) {
		_gl = gl;


		// Create the program object
		_program = _gl.createProgram();
		if (!_program) {
			CPLog.error(@"Could not create program");
			return nil;
		}
		
		// create shader array
		_shaders = [[CPArray alloc] init]
	}
	
	return self;
}

- (int)glProgram {
	return _program;
}

- (void)addShaderText:(string)shaderText shaderType:(int)shaderType {


	var glShaderType;
	if (shaderType == GL_VERTEX_SHADER) {
		glShaderType = _gl.VERTEX_SHADER;
	
	} else if (shaderType == GL_FRAGMENT_SHADER) {
		glShaderType = _gl.FRAGMENT_SHADER;
	}  
	
	var shader = [self _loadShader:shaderText shaderType:glShaderType];
	if (shader) {
		_gl.attachShader(_program, shader);
	}
}

- (void)addShaderScript:(string)shaderId {
	
  var shaderScript = document.getElementById(shaderId);
	if (!shaderScript) {
		CPLog.error(@"Error: shader script '" + shaderId + "' not found");
		return;
	}
		
	if (shaderScript.type == "x-shader/x-vertex") {
		var glShaderType = _gl.VERTEX_SHADER;
	
	} else if (shaderScript.type == "x-shader/x-fragment") {
		var glShaderType = _gl.FRAGMENT_SHADER;
	
	} else {
		CPLog.error(@"Error: shader script '" + shaderId + "' of undefined type '" + shaderScript.type+"'");	   
		return nil;
	}

	var shader = [self _loadShader:shaderScript.text shaderType:glShaderType];
	if (shader) {
		_gl.attachShader(_program, shader);
	}
}


- (void)linkProgram {
	
	_gl.linkProgram(_program);

	if (!_gl.getProgrami(_program, _gl.LINK_STATUS)) {
		CPLog.error(@"Error in program linking: " + _gl.getProgramInfoLog(_program));
		
		_gl.deleteProgram(_program);

		for (var shader in _shaders) {
			_gl.deleteProgram(shader);
		}
	}
	
}

- (int)getAttributeLocation:(string)attributeName {
	return _gl.getAttribLocation(_program, attributeName);
}

- (int)getUniformLocation:(string)uniformName {
	return _gl.getUniformLocation(_program, uniformName);
}

- (int)_loadShader:(string)shaderText shaderType:(int)shaderType {
	
	// Create the shader object
	var shader = _gl.createShader(shaderType);
	if (!shader) {
		CPLog.error(@"Error: unable to create shader '" + shaderType + "'");	   
		return nil;
	}

	// Load the shader source
	_gl.shaderSource(shader, shaderText);

	// Compile the shader
	_gl.compileShader(shader);

	// Check the compile status
	var compiled = _gl.getShaderi(shader, _gl.COMPILE_STATUS);
	if (!compiled) {
		// Something went wrong during compilation; get the error
		var error = _gl.getShaderInfoLog(shader);
		CPLog.error(@"Error compiling " + ((shaderType == _gl.VERTEX_SHADER) ? "vertex" : "fragment") + " shader:" + error);
		_gl.deleteShader(shader);
		return nil;
	}
	
	
	[_shaders addObject:shader];

	return shader;
}



@end
