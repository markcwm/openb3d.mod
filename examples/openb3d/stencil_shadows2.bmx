' stencil_shadows2.bmx
' alpha maps with stencil shadows

Strict

Framework openb3d.B3dglgraphics

Graphics3D(800, 600, 0, 2)


Local camera:TCamera = CreateCamera()
MoveEntity camera, 0, 15, 0
RotateEntity camera, 90, 0, 0

Local light:TLight = CreateLight()
PositionEntity light, 0, 0, 16

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane, 0, -1.5, 0

Local cone:TMesh=CreateCone()
PositionEntity cone, 0, 0, 8
ScaleEntity cone, 2, 2, 2
Local cone_shadow:TShadowObject = CreateShadow(cone)

Local cube:TMesh = CreateCube()
Local tex:TTexture = LoadTexture("../media/alpha_map.png", 2) 'Change this to 0 or 1 for correct depth testing
EntityTexture(cube, tex)

Local cube2:TMesh = CreateCube()
Local tex2:TTexture = LoadTexture("../media/test.png", 0) ' solid
EntityTexture(cube2, tex2)

Local multipass%=0


While Not KeyDown(KEY_ESCAPE)

	PositionEntity cube, 0, Abs(Sin(MilliSecs() * 0.1) * 5), 1
	PositionEntity cube2, 0, Abs(Sin(MilliSecs() * 0.1) * 5), -1
	
	' multipass mode
	If KeyHit(KEY_M) Then multipass=Not multipass
	If multipass
		CameraClsMode camera,1,1 ' render scene
		HideEntity cube
		ShowEntity cube2
		ShowEntity plane
		ShowEntity cone
		RenderWorld()
		
		CameraClsMode camera,0,0 ' render alphamaps over scene
		ShowEntity cube
		HideEntity cube2
		HideEntity plane
		HideEntity cone
		RenderWorld()
	Else
		CameraClsMode camera,1,1 ' by default alphamaps get blended with shadows
		ShowEntity cube
		ShowEntity cube2
		ShowEntity plane
		ShowEntity cone
		RenderWorld()
	EndIf
	
	Text 0,0,"M: multipass mode"
	Flip(1)
	
Wend
End
