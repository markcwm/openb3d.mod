' createfragshaderstring.bmx
' using advanced shader functions with shader strings

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

' Creating by data file
Incbin "../glsl/vertcolor.frag.glsl"
Incbin "../glsl/vertcolor.vert.glsl"

Local frag$=String.FromBytes(IncbinPtr("../glsl/vertcolor.frag.glsl"),IncbinLen("../glsl/vertcolor.frag.glsl"))
Local vert$=String.FromBytes(IncbinPtr("../glsl/vertcolor.vert.glsl"),IncbinLen("../glsl/vertcolor.vert.glsl"))

Local camera:TCamera=CreateCamera()
CameraClsColor camera,100,100,100

Local light:TLight=CreateLight()
RotateEntity light,90,0,0

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3

Local shader:TShader=CreateShaderMaterial("")
Local vertshader:TShaderObject=CreateVertShaderString(shader,vert)
Local fragshader:TShaderObject=CreateFragShaderString(shader,frag)
AttachVertShader(shader,vertshader) ' vert before frag or older compilers will crash
AttachFragShader(shader,fragshader)

Local shader2:TShader=CreateShaderMaterial("")
Local vertshader2:TShaderObject=CreateVertShaderString(shader2,VertFunc())
Local fragshader2:TShaderObject=CreateFragShaderString(shader2,FragFunc())
AttachVertShader(shader2,vertshader2)
AttachFragShader(shader2,fragshader2)

ShadeEntity(cube,shader)
Local cs%


While Not KeyDown(KEY_ESCAPE)

	If KeyHit(KEY_SPACE)
		cs=Not cs
		If cs Then ShadeEntity(cube,shader2) Else ShadeEntity(cube,shader)
	EndIf
	
	TurnEntity cube,0,0.5,-0.1
	
	RenderWorld
	Text 0,20,"Space: change shader = "+cs
	Flip

Wend
End


' Creating by string array
Function VertFunc$()

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

' Creating by multiline string
Function FragFunc$()

	Local f$ = ..
	"varying vec3 vertex_color;" + ..
	"void main()" + ..
	"{" + ..
	"	gl_FragColor = vec4(vertex_color,1.0);" + ..
	"	// Example of how to use a constructor." + "~n" + .. ' newline char needed to end // singleline comment
	"}"
	
	Return f
	
End Function
