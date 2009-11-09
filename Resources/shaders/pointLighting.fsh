varying vec4 v_color;
varying vec4 v_specular;

void main() {
	gl_FragColor = v_color + v_specular;
}
 
	
