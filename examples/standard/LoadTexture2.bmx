' LoadTexture2.bmx
' supported texture formats

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
PositionEntity camera,0,7,0
MoveEntity camera,0,0,-17

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,4,0

Local temp:TMesh=CreateCube()
Local box:TEntity[], inc%, tex:TTexture

For Local t%=0 To 359 Step 360/6.9
	box=box[..inc+1]
	box[inc]=CopyEntity(temp,pivot)
	TurnEntity box[inc],0,t,0
	MoveEntity box[inc],0,0,10
	If inc=0 Then tex=LoadTexture("../media/compressed.gif")
	If inc=1 Then tex=LoadTexture("../media/compressed.jpg")
	If inc=2 Then tex=LoadTexture("../media/compressed.tga")
	If inc=3 Then tex=LoadTexture("../media/uncompressed.bmp")
	If inc=4 Then tex=LoadTexture("../media/uncompressed.png")
	If inc=5 Then tex=LoadTexture("../media/uncompressed.psd")
	If inc=6 Then tex=LoadTexture("../media/uncompressed.tga")
	If inc<7 Then EntityTexture box[inc],tex
	inc:+1
Next
FreeEntity temp


While Not KeyHit(KEY_ESCAPE)

	' turn camera
	If KeyDown(KEY_LEFT) TurnEntity pivot,0,3,0
	If KeyDown(KEY_RIGHT) TurnEntity pivot,0,-3,0
	
	UpdateWorld
	RenderWorld
	
	Text 0,0,"Left/Right: turn boxes"
	
	Flip
Wend
