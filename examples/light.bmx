' light.bmx
' from Minib3d examples

Strict

Framework Openb3d.B3dglgraphics

Local width%=800,height%=600,depth%=0,Mode%=2

Graphics3D width,height,depth,Mode


AmbientLight 32,32,32

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,0,-60

Local light:TLight=CreateLight(2)
LightColor light,255,0,0
LightRange light,5

Local lr%
Local light2:TLight=CreateLight(2)
LightColor light2,0,255,0
LightRange light2,5
PositionEntity light2,0,0,10

Local ent1:TMesh=LoadAnimMesh("media/grid.b3d")
Local ent2:TEntity=CopyEntity(ent1)

PositionEntity ent1,0,10,0
PositionEntity ent2,0,-10,0

RotateEntity ent1,180,0,0

Local ent3:TMesh=CreateSphere()
Local ent4:TMesh=CreateSphere()

PositionEntity ent3,-10,0,0
PositionEntity ent4,10,0,0

ScaleEntity ent3,4,4,4
ScaleEntity ent4,4,4,4

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyDown(KEY_ESCAPE)		

	If KeyHit(KEY_ENTER) Then DebugStop
	If KeyHit(KEY_L)
		lr=Not lr
		If lr Then LightRange light2,0 Else LightRange light2,5
	EndIf
	
	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"L: switch off green light, WSAD: move camera"

	Flip

Wend
End
