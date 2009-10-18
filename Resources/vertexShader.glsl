// model view matrix
uniform mat4 mvMatrix;

// perspective matrix
uniform mat4 pMatrix;

attribute vec4 aVertex;
attribute vec4 aColor;

varying vec4 vColor;

void main(void) {
	vColor = aColor;
//		vColor = vec4(1.0, 0.0, 0.0, 1.0);
	gl_Position = pMatrix * mvMatrix * aVertex;
}