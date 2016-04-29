' voxelsprite.bmx

Import Openb3d.B3dglgraphics

Strict

Graphics3D 800,600,0,2


Local cam:TCamera=CreateCamera()
MoveEntity cam,0,0,-3
CameraClsColor cam,70,180,235

Local light:TLight=CreateLight()
RotateEntity light,45,45,0

Local mat:TMaterial=LoadMaterial("../media/1234.png",1+4+8,32,32,1,16)
Local sp:TVoxelSprite=CreateVoxelSprite(32)
VoxelSpriteMaterial sp,mat

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%, ticks%=0


While Not KeyDown(KEY_ESCAPE)

	If KeyDown(KEY_RIGHT) Then TurnEntity sp,0,1,0
	If KeyDown(KEY_LEFT) Then TurnEntity sp,0,-1,0
	If KeyDown(KEY_DOWN) Then TurnEntity sp,-1,0,0
	If KeyDown(KEY_UP) Then TurnEntity sp,1,0,0
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"Arrows: turn voxelsprite"
	
	Flip

Wend
End
