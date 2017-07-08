' stencil_shadows2.bmx
' alpha maps with stencil shadows

Strict

Framework openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2


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
Local cone_shadow:TShadowObject

Local cone2:TMesh=CreateCone()
PositionEntity cone2, 0, 0, 8
ScaleEntity cone2, 2, 2, 2
Local cone_shadow2:TShadowObject
HideEntity cone2

Local cube:TMesh = CreateCube()
Local tex:TTexture = LoadTexture("../media/alpha_map.png", 2) 'Change this to 0 or 1 for correct depth testing
EntityTexture(cube, tex)

Local cube2:TMesh = CreateCube()
Local tex2:TTexture = LoadTexture("../media/test.png", 0) ' solid
EntityTexture(cube2, tex2)

Local multipass%=0


While Not KeyDown(KEY_ESCAPE)

	PositionEntity light, (Sin(MilliSecs() * 0.05) * 5), 1, 16
	PositionEntity cube, 0, Abs(Sin(MilliSecs() * 0.05) * 5), 1
	PositionEntity cube2, 0, Abs(Sin(MilliSecs() * 0.05) * 5), -1
	
	' Note: to hide/show shadow casters causes a random MAV in GL 2.0 but create/free shadow works
	If KeyHit(KEY_M) Then multipass=Not multipass
	If multipass ' 2 pass
		If cone_shadow
			FreeShadow(cone_shadow) ; cone_shadow=Null ; HideEntity cone
		EndIf
		CameraClsMode camera,1,1 ' render scene with shadows
		HideEntity cube
		ShowEntity cube2
		ShowEntity plane
		ShowEntity cone2
		cone_shadow2=CreateShadow(cone2)
		
		RenderWorld
		
		CameraClsMode camera,0,1 ' render alphamaps over scene without shadows
		ShowEntity cube
		HideEntity cube2
		HideEntity plane
		FreeShadow(cone_shadow2)
		HideEntity cone2
		
		RenderWorld
	Else ' single pass
		If cone_shadow=Null Then cone_shadow=CreateShadow(cone)
		CameraClsMode camera,1,1 ' by default alphamaps get blended with shadows
		ShowEntity cube
		ShowEntity cube2
		ShowEntity plane
		ShowEntity cone
		
		RenderWorld
	EndIf
	
	Text 0,20,"M: multipass mode, Memory: "+GCMemAlloced()
	
	Flip(1)
	GCCollect
	
Wend
End
