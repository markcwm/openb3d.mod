' fog.bmx
' from Minib3d examples

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


ClearTextureFilters

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,100,-100

Local fogmode%=1
CameraFogMode cam,fogmode
CameraFogRange cam,0,1000

Local light:TLight=CreateLight(1)

Local grid:TMesh=LoadAnimMesh("media/grid.b3d")
ScaleEntity grid,100,1,100

Local tex:TTexture=LoadTexture("media/test.png")

Local cube:TMesh=CreateCube()
Local sphere:TMesh=CreateSphere()
Local cylinder:TMesh=CreateCylinder()
Local cone:TMesh=CreateCone()

PositionEntity cube,0,100,250
PositionEntity sphere,500,100,500
PositionEntity cylinder,-500,100,750
PositionEntity cone,0,100,1000

ScaleEntity cube,100,100,100
ScaleEntity sphere,100,100,100
ScaleEntity cylinder,100,100,100
ScaleEntity cone,100,100,100

EntityTexture cube,tex
EntityTexture sphere,tex
EntityTexture cylinder,tex
EntityTexture cone,tex

Local max2dmode%=0

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyDown(KEY_ESCAPE)		

	' control camera
	MoveEntity cam,KeyDown(KEY_D)*10-KeyDown(KEY_A)*10,0,KeyDown(KEY_W)*10-KeyDown(KEY_S)*10
	TurnEntity cam,KeyDown(KEY_DOWN)*2-KeyDown(KEY_UP)*2,KeyDown(KEY_LEFT)*2-KeyDown(KEY_RIGHT)*2,0
	
	' max2d mode
	If KeyHit(KEY_M) Then max2dmode=Not max2dmode
	
	' fog mode
	If KeyHit(KEY_F)
		fogmode=Not fogmode
		CameraFogMode cam,fogmode
	EndIf
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"WSAD: move camera, M: Max2d mode = "+max2dmode+", F: fog mode = "+fogmode
	
	If max2dmode
		BeginMax2D()
		DrawText "Testing Max2d",0,40
		EndMax2D()
	EndIf
	
	Flip
	
Wend
End
