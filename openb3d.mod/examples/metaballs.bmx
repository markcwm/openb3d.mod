' metaballs.bmx
' freebasic.net/forum/viewtopic.php?p=202675#p202675

Strict

Framework angros.b3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()
PositionEntity light,5,5,-5

Local fluid:TFluid=CreateFluid()
EntityColor fluid,128,255,128

Local piv:TPivot=CreatePivot()
Local blob1:TBlob=CreateBlob(fluid,10,piv)
Local blob2:TBlob=CreateBlob(fluid,20)
Local blob3:TBlob=CreateBlob(fluid,20)

PositionEntity blob1,0,15,30
PositionEntity blob2,0,-15,30
PositionEntity blob3,0,15,30

Local w%,zoom#


While Not KeyDown(KEY_ESCAPE)

	TurnEntity piv,0,0,1
	
	If KeyDown(KEY_UP) Then TurnEntity camera,-1,0,0,0
	If KeyDown(KEY_DOWN) Then TurnEntity camera,1,0,0,0
	If KeyDown(KEY_LEFT) Then TurnEntity camera,0,1,0,0
	If KeyDown(KEY_RIGHT) Then TurnEntity camera,0,-1,0,0
	
	If KeyDown(KEY_W) Then MoveEntity camera,0,0,1
	If KeyDown(KEY_S) Then MoveEntity camera,0,0,-1
	If KeyDown(KEY_A) Then MoveEntity camera,-1,0,0
	If KeyDown(KEY_D) Then MoveEntity camera,1,0,0
	
	If KeyHit(KEY_SPACE) Then w=Not w ; Wireframe w
	
	UpdateWorld
	
	RenderWorld
	
	Text 0,0,"Arrows: turn camera, WSAD: move camera"
	Text 0,20,"Space: wireframe = "+w+", Camera z = "+EntityZ(camera)
	
	Flip
	
Wend

