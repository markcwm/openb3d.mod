' sl_greyscale.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()
CameraClsColor camera,0,125,250

Local light:TLight=CreateLight()

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,4

Local cube2:TMesh=CreateCube()
PositionEntity cube2,1.5,0,4

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

Local shader:TShader=LoadShader("","../glsl/default.vert.glsl","../glsl/greyscale.frag.glsl")
ShaderTexture(shader,LoadTexture("../media/colorkey.jpg"),"texture0",0)
ShadeEntity(cube,shader)
EntityFX(cube,32)

Local shader2:TShader=LoadShader("","../glsl/default.vert.glsl","../glsl/default.frag.glsl")
ShaderTexture(shader2,LoadTexture("../media/colorkey.jpg"),"texture0",0)
ShadeEntity(cube2,shader2)
EntityFX(cube2,32)

Local efx%=1


While Not KeyDown(KEY_ESCAPE)

	' turn cubes
	If KeyDown(KEY_LEFT)
		TurnEntity cube,0,-0.5,0.1
		TurnEntity cube2,0,0.5,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity cube,0,0.5,-0.1
		TurnEntity cube2,0,-0.5,0.1
	EndIf
	
	' alpha blending: alpha / nothing
	If KeyHit(KEY_B)
		efx=Not efx
		If efx
			EntityFX(cube,32) ; EntityFX(cube2,32)
		Else
			EntityFX(cube,0) ; EntityFX(cube2,0)
		EndIf
	EndIf
	
	RenderWorld
	
	Text 0,20,"Left/Right: turn cubes"+", B: alpha blending = "+efx
	
	Flip

Wend
End
