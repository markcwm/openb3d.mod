' fog.bmx
' from Minib3d examples

Strict

Framework Angros.B3dglgraphics

Local width%=800,height%=600,depth%=0,Mode%=2

Graphics3D width,height,depth,Mode


ClearTextureFilters

Local cam:TCamera=CreateCamera()
CameraFogMode cam,1
CameraFogRange cam,0,1000
PositionEntity cam,0,100,-100

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

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyDown(KEY_ESCAPE)		

	If KeyHit(KEY_ENTER) Then DebugStop

	' control camera
	MoveEntity cam,KeyDown(KEY_D)*10-KeyDown(KEY_A)*10,0,KeyDown(KEY_W)*10-KeyDown(KEY_S)*10
	TurnEntity cam,KeyDown(KEY_DOWN)*2-KeyDown(KEY_UP)*2,KeyDown(KEY_LEFT)*2-KeyDown(KEY_RIGHT)*2,0

	RenderWorld

	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps

	Flip
	
Wend
End
