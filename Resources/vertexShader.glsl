uniform mat4 u_mvMatrix;
uniform mat4 u_mvpMatrix;

attribute vec4 a_vertex;
attribute vec4 a_color;

varying vec4 v_color;

void main(void) {
	v_color = a_color;
	gl_Position = u_mvpMatrix * a_vertex;
}