' createshader.bmx
' using strings instead of loading text files

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

Local shader:TShader=CreateShader("",vert,frag)
Local shader2:TShader=CreateShader("",VertFunc(),FragFunc())
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
