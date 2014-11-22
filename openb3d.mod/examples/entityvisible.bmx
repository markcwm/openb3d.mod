' entityvisible.bmx
' from minib3d examples

Strict

Framework angros.b3dglgraphics

Local width%=800,height%=600,depth%=0,Mode%=2

Graphics3D width,height,depth,Mode


Local light:TLight=CreateLight(1)
RotateEntity light,90,0,0

Local cam:TCamera=CreateCamera()
PositionEntity cam,0,10,-10

Local sphere1:TMesh=CreateSphere()
PositionEntity sphere1,0,0,-2
EntityColor sphere1,255,0,0

Local box:TMesh=CreateCube()
ScaleMesh box,2,1.5,0.5
EntityPickMode box,2,True

Local sphere2:TMesh=CreateSphere()
PositionEntity sphere2,0,0,2
EntityColor sphere2,0,255,0

PointEntity cam,sphere2


While Not KeyHit(KEY_ESCAPE)

	If KeyDown(KEY_LEFT) Then MoveEntity box,-0.1,0,0
	If KeyDown(KEY_RIGHT) Then MoveEntity box,0.1,0,0
	
	Local visible%=EntityVisible(sphere1,sphere2)
	
	RenderWorld
	
	Text 0,0,"Use left/right cursor keys to move block"
	
	If visible=True
		Text 0,20,"Balls can see each other"
	Else
		Text 0,20,"Balls can't see each other" 
	EndIf
	
	Flip

Wend
End
