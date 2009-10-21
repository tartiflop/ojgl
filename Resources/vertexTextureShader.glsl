// model view matrix
uniform mat4 mvMatrix;

// perspective matrix
uniform mat4 pMatrix;

attribute vec4 aVertex;
attribute vec2 aTexCoord;

varying vec2 vTexCoord;

void main(void) {
	vTexCoord = aTexCoord;
	gl_Position = pMatrix * mvMatrix * aVertex;
}