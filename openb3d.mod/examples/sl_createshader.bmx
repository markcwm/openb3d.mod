' sl_createshader.bmx
' using strings instead of loading text files

Import Angros.Openb3d

Strict

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,100,100,100

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3

Local shader:TShader=CreateShader("",ExampleVert(),ExampleFrag())
ShadeEntity(cube,shader)


While Not KeyDown(KEY_ESCAPE)

	TurnEntity cube,0,0.5,-0.1
	
	RenderWorld

	Flip

Wend
End


' using a string array
Function ExampleVert$()

	Local v$[] = [..
	"varying vec3 vertex_color;", ..
	"void main()", ..
	"{", ..
	"	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;", ..
	"	vertex_color = clamp(gl_Vertex.xyz,0.0,1.0);", ..
	"	/* Clamp color to avoid unwanted results. */", .. ' newline char not needed for /* multiline comment */
	"}"]
	
	Local s$
	For Local i%=0 To Len(v)-1
		s:+v[i]
	Next
	Return s
	
End Function

' using a multiline string
Function ExampleFrag$()

	Local f$ = ..
	"varying vec3 vertex_color;" + ..
	"void main()" + ..
	"{" + ..
	"	gl_FragColor = vec4(vertex_color,1.0);" + ..
	"	// Example of how to use a constructor." + "~n" + .. ' newline char needed to end // singleline comment
	"}"
	
	Return f
	
End Function
