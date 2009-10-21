@import <Foundation/CPObject.j>
@import "../math/Matrix3D.j"

@implementation GLContext : CPObject {

	DOMElement _gl;
	CPString _platform;
	
}

- (id)initWithGL:(DOMElement)gl platform:(CPString)platform {
	self = [super init];
	
	if (self) {
		_gl = gl;
		_platform = platform;
	}
	
	return self;
}

- (GLProgram)createProgram {
	
	return [[GLProgram alloc] initWithGL:_gl];
}

- (void)useProgram:(GLProgram)program {
	
	_gl.useProgram([program glProgram]);
}

- (void)prepare:(Array)clearColor clearDepth:(float)clearDepth {

	_gl.clearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
	
	// possible bug in mozilla ?
	if (_platform != "mozilla") {
		_gl.clearDepth(clearDepth);
	}
	_gl.clear(_gl.COLOR_BUFFER_BIT | _gl.DEPTH_BUFFER_BIT);
	_gl.enable(_gl.DEPTH_TEST);

}

- (void)setFrontFaceWinding:(CPString)winding {

	if (winding == @"CW") {
		_gl.frontFace(_gl.CW);
	
	} else if (winding == @"CCW") {
		_gl.frontFace(_gl.CCW);
	
	} else {
		CPLog.error("GLContext: unrecognised winding for front-facing triangles: " + winding);
		return;
	}
	
}

- (void)enableBackfaceCulling {

	_gl.enable(_gl.CULL_FACE);
	_gl.cullFace(_gl.BACK);
}

- (void)enableTexture {
	_gl.enable(_gl.TEXTURE_2D);
}

- (void)clearBuffer {
    _gl.clear(_gl.COLOR_BUFFER_BIT | _gl.DEPTH_BUFFER_BIT);
}

- (void)introspect {
	for (var property in _gl) {
		if (typeof(_gl[property]) != "undefined") {
	//		if (typeof(_gl[property]) == "function") {
				CPLog.info(property)
	//		}
		}
	}
}

- (int)createBufferFromArray:(Array)array {
	// set up buffer to store array
	var bufferIndex = _gl.createBuffer();
	_gl.bindBuffer(_gl.ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	_gl.bufferData(_gl.ARRAY_BUFFER, new CanvasFloatArray(array), _gl.STATIC_DRAW);
	
	return bufferIndex;
}

- (int)createBufferFromElementArray:(Array)array {
	// set up buffer to store array
	var bufferIndex = _gl.createBuffer();
	_gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	_gl.bufferData(_gl.ELEMENT_ARRAY_BUFFER, new CanvasUnsignedShortArray(array), _gl.STATIC_DRAW);
	
	return bufferIndex;
}

- (int)createTextureFromImage:(Image)image {
	var textureIndex = _gl.createTexture();
	   
    _gl.enable(_gl.TEXTURE_2D);
    _gl.bindTexture(_gl.TEXTURE_2D, textureIndex);
    _gl.texImage2D(_gl.TEXTURE_2D, 0, image);
    _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MAG_FILTER, _gl.LINEAR);
    _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MIN_FILTER, _gl.LINEAR_MIPMAP_LINEAR);
    _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_WRAP_S, _gl.CLAMP_TO_EDGE);
    _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_WRAP_T, _gl.CLAMP_TO_EDGE);
    _gl.generateMipmap(_gl.TEXTURE_2D)
    _gl.bindTexture(_gl.TEXTURE_2D, 0);
    
    return textureIndex;
}


- (void)bindBufferToAttribute:(int)bufferIndex attributeLocation:(int)attributeLocation size:(int)size {
	// Enable attribute array and bind to buffer data 
	_gl.enableVertexAttribArray(attributeLocation);
	_gl.bindBuffer(_gl.ARRAY_BUFFER, bufferIndex);
	_gl.vertexAttribPointer(attributeLocation, size, _gl.FLOAT, false, 0, 0);
}

- (void)bindElementBuffer:(int)bufferIndex {
	_gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, bufferIndex);
}

- (void)bindTexture:(int)textureIndex {
//    _gl.activeTexture(_gl.TEXTURE0);
	_gl.bindTexture(_gl.TEXTURE_2D, textureIndex);
}

- (void)setUniformMatrix:(int)uniformIndex matrix:(Matrix3D)matrix {
	_gl.uniformMatrix4fv(uniformIndex, false, [matrix getAsColumnMajorCanvasFloatArray]);
}

- (void)setUniformSampler:(int)samplerIndex {
	_gl.uniform1i(samplerIndex, 0);
}


- (void)draw {
	_gl.drawArrays(_gl.TRIANGLES, 0, 3);
	
	_gl.flush();
}

- (void)drawElements:(int)size {
	_gl.drawElements(_gl.TRIANGLES, size, _gl.UNSIGNED_SHORT, 0);
	
	_gl.flush();
}

- (void)reshape:(int)width height:(int)height {
	
	_gl.viewport(0, 0, width, height);
}


@end
