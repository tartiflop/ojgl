@import <Foundation/CPObject.j>
@import "GLMatrix.j"

@implementation GLContext : CPObject {

	DOMElement _gl;
	
}

- (id)initWithGL:(DOMElement)gl {
	self = [super init];
	
	if (self) {
		_gl = gl;
		
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
	_gl.clearDepth(clearDepth);
	_gl.clear(_gl.COLOR_BUFFER_BIT | _gl.DEPTH_BUFFER_BIT);
	_gl.enable(_gl.DEPTH_TEST);

}

- (void)clearBuffer {
    _gl.clear(_gl.COLOR_BUFFER_BIT | _gl.DEPTH_BUFFER_BIT);
}

- (void)introspect {
	for (var property in _gl) {
		if (typeof(_gl[property]) != "undefined") {
			if (typeof(_gl[property]) == "function") {
				CPLog.info(property)
			}
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

- (void)bindBufferToAttribute:(int)bufferIndex attributeIndex:(int)attributeIndex size:(int)size {
	// Enable attribute array and bind to buffer data 
	_gl.enableVertexAttribArray(attributeIndex);
	_gl.bindBuffer(_gl.ARRAY_BUFFER, bufferIndex);
	_gl.vertexAttribPointer(attributeIndex, size, _gl.FLOAT, false, 0, 0);
}

- (void)bindElementBuffer:(int)bufferIndex {
	_gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, bufferIndex);
}

- (void)setUniformMatrix:(int)uniformIndex matrix:(GLMatrix)matrix {
	_gl.uniformMatrix4fv(uniformIndex, false, [matrix getAsCanvasFloatArray]);
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
