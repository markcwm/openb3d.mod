' sl_toon.bmx
' cel or toon shading

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235

Local lighttype%=2 ' set lighttype 1 or 2
Local light:TLight=CreateLight(lighttype)
RotateEntity light,45,45,0
PositionEntity light,10,10,0
LightRange light,10

Local mesh:TMesh=LoadMesh("../media/green_ufo.b3d")
PositionEntity mesh,0,0,3
ScaleMesh mesh,0.5,0.5,0.5

Local mesh2:TMesh=LoadMesh("../media/camel.b3d")
PositionEntity mesh2,0,0,3
HideEntity mesh2

Local mesh3:TMesh=LoadMesh("../media/teapot.b3d")
PositionEntity mesh3,0,0,3
HideEntity mesh3

Local shader:TShader=LoadShader("","../shaders/toon.vert.glsl","../shaders/toon.frag.glsl")

Local shader2:TShader=LoadShader("","../shaders/toon2.vert.glsl","../shaders/toon2.frag.glsl")

PositionEntity light,EntityX(camera),EntityY(camera),EntityZ(camera)
PointEntity light,mesh

Local shademode%,meshmode%=1
ShadeEntity(mesh,shader) ; ShadeEntity(mesh2,shader) ; ShadeEntity(mesh3,shader)


While Not KeyDown(KEY_ESCAPE)

	' mesh mode
	If KeyHit(KEY_M)
		meshmode:+1
		If meshmode>3 Then meshmode=1
		If meshmode=1 Then HideEntity mesh3 ; ShowEntity mesh
		If meshmode=2 Then HideEntity mesh ; ShowEntity mesh2
		If meshmode=3 Then HideEntity mesh2 ; ShowEntity mesh3
	EndIf
	
	' shader mode
	If KeyHit(KEY_S)
		shademode:+1 ; If shademode=2 Then shademode=0
		If shademode=0
			ShadeEntity(mesh,shader) ; ShadeEntity(mesh2,shader) ; ShadeEntity(mesh3,shader)
		ElseIf shademode=1
			ShadeEntity(mesh,shader2) ; ShadeEntity(mesh2,shader2) ; ShadeEntity(mesh3,shader2)
		EndIf
	EndIf
	
	' turn
	If KeyDown(KEY_UP)
		TurnEntity mesh,0.75,0,-0.1
		TurnEntity mesh2,0.75,0,-0.1
		TurnEntity mesh3,0.75,0,-0.1
	EndIf
	If KeyDown(KEY_DOWN)
		TurnEntity mesh,-0.75,0,-0.1
		TurnEntity mesh2,-0.75,0,-0.1
		TurnEntity mesh3,-0.75,0,-0.1
	EndIf
	If KeyDown(KEY_LEFT)
		TurnEntity mesh,0,0.75,-0.1
		TurnEntity mesh2,0,0.75,-0.1
		TurnEntity mesh3,0,0.75,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity mesh,0,-0.75,0.1
		TurnEntity mesh2,0,-0.75,0.1
		TurnEntity mesh3,0,-0.75,0.1
	EndIf
	
	RenderWorld
	
	Text 0,0,"Arrows: rotate mesh, lighttype = "+lighttype
	Text 0,20,"M: mesh mode = "+meshmode+", S: shader mode = "+shademode
	
	Flip

Wend
End
