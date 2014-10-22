// en.wikibooks.org/wiki/GLSL_Programming/Unity/Shading_in_World_Space

varying vec4 position_in_world_space;

void main()
{
	float dist = distance(position_in_world_space, vec4(0.0, 0.0, 0.0, 1.0));
	// computes the distance between the fragment position and the origin
	// (the 4th coordinate should always be 1 for points).

	if (dist < 5.0) {
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0); 
		// color near origin
	}
	else {
		gl_FragColor = vec4(0.3, 0.3, 0.3, 1.0); 
		// color far from origin
	}
}
