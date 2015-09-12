' sl_pixellight.bmx
' per pixel lighting

Strict

Framework Angros.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235

Local lighttype%=2 ' set lighttype 1 or 2
Local light:TLight=CreateLight(lighttype)
RotateEntity light,45,45,0
PositionEntity light,10,10,0
LightRange light,10

Local teapot:TMesh=LoadMesh("media/teapot.b3d")
PositionEntity teapot,0,0,3

Local teapot2:TMesh=LoadMesh("media/teapot.b3d")
PositionEntity teapot2,0,0,3
HideEntity teapot2

Local shader:TShader=LoadShader("","shaders/pixellight.vert.glsl","shaders/pixellight.frag.glsl")
SetInteger(shader,"lighttype",lighttype)
ShadeEntity(teapot,shader)

Local pixellight%=1


While Not KeyDown(KEY_ESCAPE)

	' enable pixel lighting
	If KeyHit(KEY_P)
		pixellight=Not pixellight
		If pixellight
			HideEntity teapot2 ; ShowEntity teapot
		Else
			HideEntity teapot ; ShowEntity teapot2
		EndIf
	EndIf

	TurnEntity teapot,0,0.5,-0.1
	TurnEntity teapot2,0,0.5,-0.1
	
	RenderWorld
	
	Text 0,0,"lighttype = "+lighttype+", P: pixellight = "+pixellight
	
	Flip

Wend
End
