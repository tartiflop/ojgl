uniform mat4 u_mvMatrix;
uniform mat4 u_mvpMatrix;

attribute vec4 a_vertex;
attribute vec2 a_texCoord;

varying vec2 v_texCoord;

void main(void) {
	v_texCoord = a_texCoord;
	gl_Position = u_mvpMatrix * a_vertex;
}