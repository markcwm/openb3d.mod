' camerapick.bmx

Strict

Framework Openb3d.B3dglgraphics

Local width%=800,height%=600,depth%=0,Mode%=2

Graphics3D width,height,depth,Mode


Local cam:TCamera=CreateCamera()
PositionEntity cam,0,0,-15

Local light:TLight=CreateLight()
RotateEntity light,45,0,0

Local marker:TMesh=CreateSphere()
ScaleEntity marker,0.2,0.2,0.2
EntityColor marker,255,0,0

Local sphere:TMesh=CreateSphere()
EntityRadius sphere,1
EntityPickMode sphere,1
PositionEntity sphere,-10,0,0

Local mesh:TMesh=LoadMesh("../media/teapot.b3d")
EntityPickMode mesh,2
ScaleEntity mesh,4,4,4

Local box:TMesh=CreateCube()
FitMesh box,-2,-1,-1,4,2,2
EntityBox box,-2,-1,-1,4,2,2
EntityPickMode box,3
PositionEntity box,10,0,0

' used by fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyDown(KEY_ESCAPE)		

	If KeyHit(KEY_ENTER) Then DebugStop

	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	TurnEntity mesh,0,1,0

	' if mousedown then perform camerapick
	Local myPick:TEntity
	If MouseDown(1)
	
		' reset entity colors
		EntityColor sphere,255,255,255
		EntityColor mesh,255,255,255
		EntityColor box,255,255,255

		myPick=CameraPick(cam,MouseX(),MouseY())
		
		If myPick<>Null
			EntityColor myPick,255,255,0
			PositionEntity marker,PickedX(),PickedY(),PickedZ()
		EndIf
	
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
	
	If myPick<>Null
		Text 0,20,"Picked!"
	Else
		Text 0,20,"Not Picked"
	EndIf

	Flip

Wend
End
