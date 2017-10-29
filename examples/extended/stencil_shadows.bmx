' stencil_shadows.bmx

Strict

Framework openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()
PositionEntity camera,0,0,-15

Local light_piv:TPivot=CreatePivot()
Local light:TLight=CreateLight(2,light_piv)
PositionEntity light,25,10,25

Local plane:TMesh=CreateCube()
ScaleEntity plane,25,0.1,25
MoveEntity plane, 0, -2, 0
Local tex:TTexture = LoadTexture("../media/Moss.bmp")
EntityTexture(plane, tex)

Local cube:TMesh = CreateCube()
Local tex2:TTexture = LoadTexture("../media/test.png", 0) ' solid
EntityTexture(cube, tex2)
Local cube_shadow:TShadowObject=CreateShadow(cube)

Local alpha_piv:TPivot=CreatePivot()

Local cube2:TMesh = CreateCube(alpha_piv)
PositionEntity cube2,-5,-1,-5
EntityTexture(cube2, tex2)
Local cube_shadow2:TShadowObject=CreateShadow(cube2)

Local alpha_cube:TMesh = CreateCube(alpha_piv)
PositionEntity alpha_cube,5,-1,5
Local alpha_tex:TTexture = LoadTexture("../media/alpha_map.png", 2) 'Change this to 0 or 1 for correct depth testing
EntityTexture(alpha_cube, alpha_tex)
'Local cube_shadow3:TShadowObject=CreateShadow(alpha_cube)


While Not KeyDown(KEY_ESCAPE)

	TurnEntity alpha_piv,0,KeyDown(KEY_D)-KeyDown(KEY_A),0
	TurnEntity light_piv,0,KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	TurnEntity cube,1,1,1
	
	CameraClsMode camera,1,1 ' by default alphamaps get blended with shadows
	RenderWorld
	
	Text 0,20,"Arrows: turn light, AD: turn alpha cube, Memory: "+GCMemAlloced()
	
	Flip(1)
	GCCollect
	
Wend
End
